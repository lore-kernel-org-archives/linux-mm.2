Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB172FA1FE3
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 19:13:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 271236B0088; Wed, 22 Apr 2026 15:13:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 249926B008A; Wed, 22 Apr 2026 15:13:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 186576B008C; Wed, 22 Apr 2026 15:13:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 09A266B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 15:13:24 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AE07FC11FB
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 19:13:23 +0000 (UTC)
X-FDA: 84687140286.16.5719B9B
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf10.hostedemail.com (Postfix) with ESMTP id C51B7C0008
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 19:13:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ho2tFJxD;
	spf=pass (imf10.hostedemail.com: domain of joshlaw48@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=joshlaw48@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776885201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A3dMidoRZcf/RPOcj04rq5SmffBfHuwcMa2j9+ABoHw=;
	b=OC8YiKeRxB04PvxAEQ5Y8exAn6/wV/GjZggBWpUgtIbAgL4Mt04vQ/hk2YcXH0MhPhHtcN
	lWfAWfzmNZQAXXRgZLqPhSr5XmIDG+9vblAXd1xUPk8yskEgw6yhtsiZQC96AU/IS66r44
	7cwHGn32xJ/zVM7J+DnZSaqy19O0BsI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ho2tFJxD;
	spf=pass (imf10.hostedemail.com: domain of joshlaw48@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=joshlaw48@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776885201; a=rsa-sha256;
	cv=none;
	b=M6xo6C0Cyb0hzevhI83d0oeOXoi5BXQJEHD1mDqEAmMJxQ7IobuRJ6qY42ltWKT0Bfe04L
	s2s+95XO0LY97LKCj6HF7ByklxvHfi4VTqKGNYbAyc6xuGImhz/pSdM0MyG+x+7USJz9Db
	WY77xaNNobH2bIm+Ac/nL+em526qi5A=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-48374014a77so76169085e9.3
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 12:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776885200; x=1777490000; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A3dMidoRZcf/RPOcj04rq5SmffBfHuwcMa2j9+ABoHw=;
        b=Ho2tFJxDMAMtMUtdClfvjzEMdLmOXND/A3AdOlk5yPnS09zftAZzNdj1JClYGCJTmc
         kOrdvAEqwA2fnxcUSK/HmS0enjBLKyZueN2RUJ3mAphLP2LB4qCznc1jlhM93ckaCOcE
         GDm3msh9t3ib7IoZFmmyvuKb3+hBA/NOqtfV4rRtNT42eOBm6WX2Iu0a/u3I7FLaaVqN
         PUCdHu0zRbntBJUyfWLYBZUTrNwCxVH8M8ioz/r24SJ4lE9VSqYezRxGACUmhhJ1lew5
         VBA/twtZJIxC1Qd5LHCFd6R4+RccIIcmlu1dF2Ioh7+UtWxrseTaE1wZXy3/EGMdt4SN
         lpog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776885200; x=1777490000;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A3dMidoRZcf/RPOcj04rq5SmffBfHuwcMa2j9+ABoHw=;
        b=IuuYaZOYR/QnQIbTydnNLLKciCPsgwL2J5J8hQ9aNy1TUwC+LlWMke+dVbkVkaxNbT
         Fgmg8yoWN/df+tlY5DD0BxQwXkFaMhBB3Oflj4oLyH8cJVLHUjQOEJW8HK/3CfFQNM9E
         9aoXM3BhRVQxOKHJZnYfsexsg7ybk+CA7wH1h4yg3cj3h8xPSGBUtOhp/dxP2NVAmL/z
         /HPZtJojJS44JHFOHcxHq88oYSUAhSVIhoztjzdByOBj8+O+Z///781puqDC9GTnrPa3
         2oFihkvDHeeKH9Y02MMZVPupzMCOzazdWVgj1gOxBSHvj78ZdIXWk1pW8gWhNnJjE+s5
         59Vg==
X-Forwarded-Encrypted: i=1; AFNElJ+590zvrogBJjF5kx5s1fNQKYCJ0TwN6sJLF3YttglblRu2CsX2UpSlnw7m2kZfSEhALvf85pJiyQ==@kvack.org
X-Gm-Message-State: AOJu0YwFKtUSuTSLZxtCFhQTzoqSXyK0tP7Tu7bPkNK5lsVZkgySFQq9
	b0OlVtqX6PfNqexED2lvNXD/KMnKo7jiLoqPHCtpom+GYm+XeiVG/TMex1CHV7Z2YEk=
X-Gm-Gg: AeBDievm9qECjVQE02KLPXXA8fEBwOD3qp1G4foAoLU+Yq6aLqk44kJi/G/f535iXEI
	1QTLzgL2LvisPwQI2XvD6w1aiSyXJvH6/i3xdWd5EG/UjmJUihYoajh3MtPf1nEcr9nWHLc0Abf
	RLhs8ACcYwZLwXgDR0EOd3XNwyYMnm4p/tmb8LItVa31O/VKJpCVSMPIGiyS0A9kjLhrbYRjoBs
	Va18/K1ZRD3oxTFQt44o/X2v8CPS/VXFv6hCumNRRODgoPJhzI5Uu/vooCMolJKhk30mx6x/87I
	qB64StwGkepEQTz4yIEShQMyQTRSt5/E3Zynbe+wm0NsaLmxEseOuRc1CcmSgpv+QFRB0DFR7K7
	8KbxFaNMEo1qfgqPMuQiP1/vR4j0ZAJMLtNcqh0bS2ZCV0LkWvo7fAb9dgm8j3T1/AOMPNxFMxS
	AwiHWt17cJVlN60XhYQ35t8rbGEoCDgi5Zvwrc
X-Received: by 2002:a05:600c:c4a8:b0:48a:52ee:5776 with SMTP id 5b1f17b1804b1-48a52ee579dmr176982725e9.11.1776885199992;
        Wed, 22 Apr 2026 12:13:19 -0700 (PDT)
Received: from ehlo.thunderbird.net ([86.1.69.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a55dc9f58sm330602485e9.6.2026.04.22.12.13.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2026 12:13:19 -0700 (PDT)
Date: Wed, 22 Apr 2026 20:13:19 +0100
From: Josh Law <joshlaw48@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
CC: akpm@linux-foundation.org, david@kernel.org, linux-mm@kvack.org,
 rostedt@goodmis.org
Subject: Re: [LSF/MM/BPF TOPIC] MM transition
In-Reply-To: <aekbhQN9afqMBs4_@casper.infradead.org>
References: <20260421094216.8dfe14a8c62f2420fa5aace1@linux-foundation.org> <16B7B5A8-EEA7-4580-A565-3A0B4DBB08AB@gmail.com> <aekbhQN9afqMBs4_@casper.infradead.org>
Message-ID: <7BAB465F-C09A-4C67-B9A9-3C63ADD91AB5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6e151i19cu159e1xtf5jxay6zpo3h4f4
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C51B7C0008
X-HE-Tag: 1776885201-361681
X-HE-Meta: U2FsdGVkX19/s7t4HHbAnhamj6k5enZnuc9QcWWafLlmqmKSgqI9bh0Mpl2zANDeq8UGrbW7wm3+ZU46WFp87TcNJhhbPGYz4qdzEHSCm9VBCA0HzBc3v+cIm/oGui0yZTpm8Hcf7VTYrFSFeejZL2qMHPsp1lpgUzQQ7JiCKYhp0pPQ1ctUfAhFjmWKinSgjeIkSvm3W3Og23OdhzeRhE4LIx/MlTbabUp6nzIURJVvIBDcC209M9zrWRZPNu4uEJ0rfFDWo9+nNNY62arHe7R2BVewroRQrYtTU4CYFhcau6unFAbVDMY8Mo7U6IJe3tGssi6y3cgfRRvroO+qkd3Af0kVTw6Fe8gJBuFQu7GUil4YI3fsiXx4gWLeAjpLpYNBL245KyNWduAttkoVyjKb/E5Jl19abJOq3IMT2Jw++HUEBDOcicYR55SpOsyvesVPg9U8I2msTfZ1aBdC3G+C8Si8aRv3aNiNnMxVXrfBnWsurdvac4Onskh/x1tk1yauZB/KCzznek5r9KP66PuOkt9m7Qq8RUhbiMVYKTFv7RpZHPEc6vBjmPk/1IibXawj62HadWyhCPFx2UaXOwl4Ihm28sxn2QIXMli/EhBDcXRD5mY1jgtZoNHhfBK53iDcKw/HxV+W8Uam67/RsWFJEofVesBD79U7mXuPZp89M5RHJUaQSqmEXs0hF1mnzRlE1yoDwYeZ3DPmsizbdIvZQc+Ji4AYOyrIWT0wWgDF9VUS8injaOt27iG83xymTXCO7aJHqBYT+Gn/2TnW/PS3BjctXY1wZ+yq8H/kD6Lsb0WMNl9xyizQa7L0SiniWP/p0lrnzEoIGYO/waD7BIFNoRZLV/6/+yyLKbsMjwWFjmBAuyKNe3mgc5lvRlPYiXvQC5Es6P5or/vdHt2n09XgKdJQcimKxJR/w+KfjcTUu8gT+eUsWzldKtpZI3ppJkHaU/rLgibCjCBkh3B
 Gf40qms3
 bBzSNmkjnmeya7+KYHt39anQZ9UmOnaW3OFH9v+P+UHMxNDTEUsFFaFPL16cSL0tNKDMLAVpQznGcf2OT9Szz78Dx/D99ANnguXNg0TscQYpgWfE6BvZdym8CYHdJJk6XdmCZe2UeqmE4DUv2lnWW34Qed+cw5oUVFH6ey2KNDyny3rJ6AHbqjvG+eu9nnSsVG/HZgJBhf69BkjNBYAAXbk1JbiRMzpICFfO5WFAQGeNN7SM6sofEuQoy2bGn4icr9b/wuW4bouU5UzJ5Mvtb4EvDyO0nVYL9+NdbtFvgs0DLu7OUtCAv/ItoxIScsKR341BdpPU3u+pthSypR+0tAe+TKvdEp0EnBdXWzuEcm7gLXykq1Tj2yMeObgn3Y1bAAhnSHmS7EJSUChgVByxIX9KSUMpG1SWawyamUmBckrLfEdX016mPNrFz6WbUZqt6edN8145vS9jnqk34OOWZsWViVOF6zAF0419QC23rVf7Auec3q/jMkNNnqCW6HcgR2YeQmwu126AW5vMqmU0YycOf7H6nUGOxPq74uQZHag+mZx4FPQY8WNhcKb4svi8KRiMeqHpHVEuBTS9N9A4LYIR6PFVLilTb9Xc5mkGImFpQ7cPJkpxcWGx8Nw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22 April 2026 20:03:33 BST, Matthew Wilcox <willy@infradead.org> wrote:
>On Tue, Apr 21, 2026 at 08:25:24PM +0100, Josh Law wrote:
>> Hello, since I'm not coming to LSF/BPF because of my age (aw)
>
>What is this nonsense?  You aren't coming to LSFMM because you haven't
>requested an invitation.  If you had requested an invitation, you would
>have been rejected (because we have limited seats and there are people
>who are far more qualified than you who did not get an invitation).

Sorry. Yeah, didn't realise till I googled it.


>You already have a reputation as a liar [1].  Don't compound it.  At this
>point I've tentatively assigned to you some other nasty character traits.
>
>[1]
>https://lore.kernel.org/linux-mm/cea99016-5407-4392-9b7d-2e6a994f550f@lucifer.local/

The "bot" thing has been disproven [1]

About the whole trust thing. I'm working hard to get that back, sorry
but no need to be harsh.

I'm working with Steven here to try and handle the social side, bare
with me here since I'm not perfect

[1]:
https://lore.kernel.org/all/20260402093410.040423b1@gandalf.local.home/

>> (And I'm more than aware this post is more mm focused, but I'm
>> representing lib :))
>
>No.  You're not.  You sent a presumptive patch adding yourself as lib
>reviewer, and that was also rejected.  You don't have what we're looking
>for in a maintainer, and you're starting from rather further behind than
>somebody with no record.

No, not in the maintainer way. As in like me being patriotic for the
directory 

Let's please please please not cause a argument here. We can agree to
disagree on things. 

(Cc: rostedt@goodmis.org because I said his name.)


Thanks!

