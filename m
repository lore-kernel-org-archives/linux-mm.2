Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6348C4450A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 03:03:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 568846B00A2; Thu, 16 Jul 2026 23:03:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53FE46B00A3; Thu, 16 Jul 2026 23:03:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47D606B00A4; Thu, 16 Jul 2026 23:03:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 11B076B00A2
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 23:03:13 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7DE9440406
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 03:03:12 +0000 (UTC)
X-FDA: 84996772224.04.77BB434
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9FEE214000A
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 03:03:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="KQlo/Wk3";
	spf=pass (imf09.hostedemail.com: domain of linkl@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=linkl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784257390;
	b=RvOs/lsbkFplMfjoWnszbEQkcK6uGyG92t5KdnxrwRT39bMnrHjlMNy0KFA1smkuLER5IG
	ctB8wNfK74DCscsRD30L0EFTwXTc1SEqzis8Mog5PeS1Ou7yHDGFZEbMmgKH9HDO1a9IqN
	cyf/cxo87VdJTdRw9DJEwWLqY0QTmlU=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="KQlo/Wk3";
	spf=pass (imf09.hostedemail.com: domain of linkl@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=linkl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784257390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oikrldI+OBOTPyHwwL9NWbSdthSThDKPFciiKUoHmng=;
	b=phy/o1lK+rK/D/sgHZi9PxcQ2O199aE61/45zcmWBAk5IALXX9pMPpx8YzlUB0q7NdoROA
	ANJwenujJh4KHD2iFaeM4C1wXlDMD7d5FD8QB6dwEoa/2fhN1BaxrjXS+a/xjHVmVFO3mv
	x7zatteGvHxn1gXb1J9MP2Na0sSo6Vg=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51c10ed63c0so243831cf.1
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 20:03:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784257390; cv=none;
        d=google.com; s=arc-20260327;
        b=hI35uh7CJvJcJh5J4TUxSrtiYQ8Wo8i/PNRgLyAbSXjYv+Ca8BdwxoCi/4Za8t7Len
         eDMyStEXrkpswhBfhPZT3C8+UYeGFgfMSeKs5Lw2FwtWBnT+L1uEOoLhXtFqjmAk25gx
         AZEGCsr8zVXxcPd4se8g02IcpHpNnlhKJA6A/mWTinIxDGdg4L9t9hPk/NfNYs00ZC32
         fK4yTGifWv8k9SlJjskWWH3ZWsDCgd8oLwK/cEr295my2DJyRZodCjzl+oVCnkHD7dL2
         R/nCYUW9NRwLmpohwgOkUhNWilRoULwfcpiOLKF0Ruw+ardiCnbcj32/KoDBUNNUF2ql
         0+2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=oikrldI+OBOTPyHwwL9NWbSdthSThDKPFciiKUoHmng=;
        fh=7TYE5Pkfu+FKpEwK/1RbwXiBpzIu1oYTapgIlZRrJJA=;
        b=IL/fa7Q+ZGvsx1mpTfLX/PRVivOC73U0dqLM8N1ztDVg8iWeKWXfff8IYg0/ylnQ5+
         Aw4hVBoWBcw1nCSAccsLmeXhm2kjtK5Bt58YmKFP33EaSsMqXAi9sxQXe+x1zjoVkj6x
         8V5qrvnrYcSjpKO/aa8bhUXuwP12wcDz8A++z/jn6tocHqwxVKjJs7NAXBSwOZPSW8tx
         2/lBoyU0clxvlMCkz3bZAZxEOmnSJNwfAiRNJHQGrye9AFDTTxxa3bUax7LEiAWQ8wEx
         KxWfjXLZeZ8BUqiQOCxPRMoeFizSMyDevQrxy6nIBwTbtsLzUFKQ4wGjsR8/Nj1R7pwH
         zSkQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784257390; x=1784862190; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oikrldI+OBOTPyHwwL9NWbSdthSThDKPFciiKUoHmng=;
        b=KQlo/Wk30Qnc0mNLfKP2Z+goYkvQYVEjfjtdwHqEpfUyEkd5pez3fcemTA/E9cl3ub
         VJ6AAM7cLR3gEfYLbVi8yUR506PZSvrfLh/s+zeqBRsefoLcJWcfqXhsfQyR6A5PNqEZ
         d52O+Jrj2DbxzY33hnQhS8g6xDXUSmYDbvu9Xavrs9BWNPr4TxpDzqILlwroyh53iaPc
         GGkAcO1yxT0ldZfwW5dSlGyxWA5JMXlf8ZIrNvYYIACuz/0M0xIWxWkreKC0tckznc18
         mGJzn1o9llOL0SP2nQtfkA+Efn1dpvL60mIzE1MRLlSvhT316l9DnQ2pbHpb40Ya5EkM
         v7Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784257390; x=1784862190;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=oikrldI+OBOTPyHwwL9NWbSdthSThDKPFciiKUoHmng=;
        b=jG4ZzgqYWYI3YodNGQwn41xlCwKxqGXC7tTBe7+nbOYLajSp03xIQwxq7H4TE1p77K
         viNTdoepaaUYCQsshZyd+CPapiZKnBnpa6TONIEBy9GpBtJfVAoYOB/foFsFv4nWmNS/
         w2CzK8gC0oTkvJcUGy1WdQ9aIt6gxiVjundSNgIpD7q+ONOBvMsTmXCbPbGIQ/xBlFbP
         uwcqCJpeMh+n5OtZThzxuuX32CIDciezOEgD+rHJb54+cI0eaO2mny+3+8YTPyzX29xA
         ZvMXhnpEz1iesJulDtTf8qqkkgOOV6TO3iKMzXk0orlTYZsrH4DuGGx29Z1VkaB3P7S3
         RH4w==
X-Forwarded-Encrypted: i=1; AHgh+Ro9x89z4Q2V+Y9fi3UCB5HpLGwLfpGbE1Cb7zKTq3WbJ6qWcwa4HVubsrhLlSKcM3kuDH781TAEDg==@kvack.org
X-Gm-Message-State: AOJu0YwRzlU9ivCEXXV9hc6YDYnbewAXc6aoKgj/3XGbPZM4F4o7321W
	qsBl7An+prclekkitj882+0JkawbL771FbeO4hfT7rQ9iHEk496VQJ/iGFHvTAHNoxQWzTZBFLi
	IbJOQ0vo2ETuIF8WULW5/UDy9q9CDTuxn0FEeGiL4
X-Gm-Gg: AfdE7cnlFFxyVy/FFCbOjy+MbZSQfQMIz16/+wGGA788HLXBABncCvMtEYpVmp7Vrpk
	1pJPGsuSLT52q7BXeNnWDp0Wg5r3dkLb27bzmjUB02gHiZiBcrpkXDg3I12GnA7yLUUxwYYufVP
	mHUag0hytSeW59LKAQl0ql4B6YadP1cO0aAAonj6uOMLZUQJpBWyaXPBDBimUyGN5bhw5i4ktuN
	lXpTIv7RGftmWo+Z3nTQ3xBAzuLUuPVzFKRzj9jsdsd/GSHzrMH+ueF2Gm2DVIN7eykEIMZPGXM
	SuKT/PNFgn5sy/k0
X-Received: by 2002:a05:622a:3d2:b0:517:38aa:c2b3 with SMTP id
 d75a77b69052e-520d52524e6mr5272751cf.14.1784257389146; Thu, 16 Jul 2026
 20:03:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260709224330.946683-1-linkl@google.com> <8d316b6c-41fb-4ae3-8923-3b649b92b33d@kernel.org>
 <20260714092146-mutt-send-email-mst@kernel.org> <CALUx4KSxjpHhgkHZ5p1khLSe7+-cDHd+ZtBEJS1HytWSo5WbHQ@mail.gmail.com>
In-Reply-To: <CALUx4KSxjpHhgkHZ5p1khLSe7+-cDHd+ZtBEJS1HytWSo5WbHQ@mail.gmail.com>
From: Link Lin <linkl@google.com>
Date: Thu, 16 Jul 2026 20:02:58 -0700
X-Gm-Features: AUfX_mxvju2ajwqaWLph45EfnN052a5lxttcd4lHH1YraUcmngeJ8Hc_Z-8C0HE
Message-ID: <CALUx4KRiyxDfoA9D48zz0fChrsc_NUFk3gDacZrMjsntj1m=dw@mail.gmail.com>
Subject: Re: [RFC] virtio_balloon: fix Use-After-Free in page reporting during
 PM freeze
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, virtualization@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, prasin@google.com, rientjes@google.com, 
	duenwen@google.com, jasowang@redhat.com, xuanzhuo@linux.alibaba.com, 
	Ammar Faizi <ammarfaizi2@openresty.com>, jiaqiyan@google.com, ahwilkins@google.com, 
	Greg Thelen <gthelen@google.com>, Alexander Duyck <alexander.duyck@gmail.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9FEE214000A
X-Stat-Signature: drc1phznsjw4p6f6dan7oc3grrcbbgbb
X-HE-Tag: 1784257390-616627
X-HE-Meta: U2FsdGVkX1/0cSeInt3NW9s8qCiGDCwFq1sy3OfjSEZ7zFFzrGoZkNX+YVz/IuePzjd1NCcZUIHGMM60mWcANCaKi4RTbNQB2dOue0hUuC/Ts9jB0kvJSxV4ZWRNStRIlTAxyw97pxDN26crN6jbJJ7aGW7aecNkhdEMPp4Hz+8GOwWjVhtgoy9Q4Yij6JS501F4cE7wU2qaqXNUFV1K3FkN8/5k1OeADmuwf+m9qafd0ttjIa5xBr0AOHx2XI1a9ibfVZOF49tbo8FN0V7e1T5EeikGqSAuTZyySSkdnbazzGHs4ewmKJA2auGsVx8FfFa54QrQTDMGgywJ2q5F52mHGd4FgZ9UECADfTmpB1B42bHTI65H59NBKdMX6FynxQCfqCL7vQoxIjNdRlLgx6iqGtqN5j81yA75xv/fD39WINl235WsRY7VHNP2YG+RR5bmMP6aaNavngTjqHh5I03/MaxFCrcvgg5DFAujomnHEf7C+XpocTmalJUCtG75QO8x5iybawX7TicTWodBQMSYakWjFwf4yPRgWKgS1YKW4U+9OLXEbjezI8EcdmcoI0I+quGpE57WfvAE3bwJTBWp9OUT0LerJTS6x1sZcEL8626KVhJD8DyGX2wwiI2kcMRpnp4auTGsR22T9cTHk93NYO2kLusCCyixY/GXXPdPeBuPJejW4Gk1NOUhvDmHGbJNMjCqSeBApNLO4kLETj3GaQchZS4Ym+MVNsUmg7tGeB7yBAko7NcYEuQorOt18r5A0NdTpwhtNQXtXu2khK0bmQkx4IgO/aUOA6t0mGJQgQvgc8KdMiMpgO8zE9XaM2fai+npm9G1/9A15dwEp8cbHpXdJkMILDE4zjnwYDyx+jNqyGGzktagJ9UhPJ+YwljdXLrYwni6Y3S15WRJR6uZwQU+1P1NNxYsgraI6bthckHrhix4KJ8OMyD6TIKLZkEVn6wa9lwGr6rkDQ3
 hXjvBiSi
 wPMQOiMfp/xMoQy2JKlrzK7GvqJHMydkXPoebhaHy00nm1oaecb8O6xiysNpj+5PCdpZsSyIgUwNgO8mGKgbPTovf8MKnXEMYhsM8EUWrmpL4OVcCBbGKGC6WKInFCnDzK3iiIw0idrzRk5JUS8Iz1Ng4/VdegYJJUAi3Hn3PfiOY8SC/Oby9+74CPod0HptVkIw7OXIkNy51mA2Q3WLP5vmM7/IfH6wjIL/s6mnsIqkpG/JkAD7sNo+3s8LnPMNuIMuhwezMwDrY3giR9KZmrHH99+jw/sjAAQd6jVproIKbbH4yqOfltnUeRZxtuGdPJ49hzMXISOQbaTKXNx4+9tilmlJC8jUh3vUg7XRowsnnDsUDR+sez8pblFhvog3ZvkgbvrzXoBP+RAaQ1Lg4fcHigw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 11:05 AM Link Lin <linkl@google.com> wrote:
>
> Per the earlier feedback to keep these fixes independent, I'll format
> v2 as a 3-part patch series:
>   [PATCH v2 1/3] mm/page_reporting: use system_freezable_wq
>   [PATCH v2 2/3] virtio_balloon: fix shrinker UAF during PM freeze
>   [PATCH v2 3/3] virtio_balloon: fix OOM notifier UAF during PM freeze
>
> I'll send that out shortly.

Hi everyone,

I have just sent out the v2 patch series in a new thread:
https://lore.kernel.org/all/20260717002311.681748-1-linkl@google.com/

Just a quick update: I previously mentioned I would include a fix for
the OOM notifier as part 3. However, upon further audit, the PM core
explicitly disables the OOM killer (via oom_killer_disable()) during
freeze_processes() before device drivers are frozen.

Therefore, the virtio_balloon_oom_notify callback cannot trigger while
the virtqueues are deleted. Since it is already safe, I dropped it
from the series.

v2 now consists solely of the page reporting workqueue migration and
the shrinker TOCTOU fix. Thanks again for the reviews!

Best,
Link

