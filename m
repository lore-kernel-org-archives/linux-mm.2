Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A422CD5BDE
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 05:00:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 567CB6B0005; Wed, 27 May 2026 01:00:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 518A96B008A; Wed, 27 May 2026 01:00:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 407C96B008C; Wed, 27 May 2026 01:00:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 31D316B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 01:00:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CDF4D1404D1
	for <linux-mm@kvack.org>; Wed, 27 May 2026 05:00:21 +0000 (UTC)
X-FDA: 84811998642.17.0DB2EB2
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf14.hostedemail.com (Postfix) with ESMTP id BFB56100011
	for <linux-mm@kvack.org>; Wed, 27 May 2026 05:00:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="vtfk/MMG";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf14.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779858019; a=rsa-sha256;
	cv=pass;
	b=2cvaMVfPO1PdsZbbuaEulBxX9BU5+axst1rhDjfTaamIqi2lSdy+AdPOgq1PMw9DR774Al
	CnGlq+cWUIsffnaTXopvIwa7Y0As8do9JdRuCV7cduNxsq+ETm7NsWCIjiRq/mAkiudQD3
	kU1ftEx7tAx7jod8j+FotKt8DFSPohM=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="vtfk/MMG";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf14.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779858019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nFwG7VGhx5nRDfvYBWcsiTNd1aNj2RuJ8zuR2JIO+LY=;
	b=gqn+mwMyt1eMRznqmHdr9lUk5yXz31kylw1zE7Tww19/orH9/xlP1LsegxijNevxi5BaHt
	UVKREDDfsyBq/6U3rLXgr42OGxE3i9d4x389zLQMjsIfOZZUCyJUhD9SY+c0HUJ1aZl97V
	IeHZKpokyB5cNN/awlskgpBHQzxTw3I=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-49045e2a8a2so1475e9.0
        for <linux-mm@kvack.org>; Tue, 26 May 2026 22:00:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779858018; cv=none;
        d=google.com; s=arc-20240605;
        b=VxabqRntmxoZUjUdPkYwP+eApRpD820vXFpe3mMCj2BS97F/CfuOxEMbaLgBiQkvSh
         AIrGIk1nGPOEaKAHAzKqIFpmDJfKoq79/cK100U8LTcMFXhzp2Q79cp9tJku3rauLl8N
         SnubzPfrTvTCpRv1aV5wjTr8DOtkk4QAJbjt/UWP6uMXyAvyomOFw4W0jmNFOpzaGYhM
         innUVqedWsYmwOfpvhwJE0J7UzHNIZHJlez1dNnUhXSBO/zzq5pcSHNG8FbOGCvECd0f
         x4liPiUiqIy9+v+Op4Xqr0nKbunoBRFLfKJkxlJtNZUeneQsapU16u1n/3VmKUCGRGqd
         FITw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nFwG7VGhx5nRDfvYBWcsiTNd1aNj2RuJ8zuR2JIO+LY=;
        fh=kCVB6McUr5XTRO4MW+IZwNNVNAcz7LK6+sLNsNHsI1Q=;
        b=X6vgRHVJSUXp+a14dm+zrrHKdRs3jG7MNWiB8GkOsSufPLrE167mkuQAMxvYIWQer/
         9d8ECp9nrDManXwfhYpk+y4JAoYqFexdeGkQOSH/aVzjrJSHxlE36ZjHYvBKSRdKRgdL
         jJtyg6AowLxRc41HqvYwXLIg1HmLbR6uXhsp0H1zLiftJ+OuQdOK8mRS2/ngZioM0dxy
         T9MPhc7KAjVEO6wX21b8dhIENgrNVgXxWjc7WcYT8/BozGlOj6nYCp5suTwa1U2/yE/I
         UBEPqI6V534/lkcwDvAxAUnsvk3Qg+0yK0BS+B1AMHqqejiPOtuo8WOshqt3dTXmj8aB
         Nflw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779858018; x=1780462818; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nFwG7VGhx5nRDfvYBWcsiTNd1aNj2RuJ8zuR2JIO+LY=;
        b=vtfk/MMG9vw0D0udd1YU8EhivixSnkKDETao/1BntXikWmkqbn22puWqJTL3cRxlqh
         hEG8YTLxT5VswZKqjV8X+vnSqHYHPvvOHx1r72TKzUYGuBWQtFGVlZjH4dAtQYTqiMy+
         MYQl6d7kzOxQDb7yM9PDvxvll6T9PjZUKZXhcINQ3a5ugVUY0VrFvj11L0I2mS1WE9OA
         nhB1qWMDUFckU2SbiUh8EOASUARLBYWD0LemALmnZxsKdHG7fIp6SDH2g3dq9YJHLbZS
         d2WvZC794VYHc1XU8f/PNxBPL5fwugV7q0J6QtqzqBwEw9Nld18KFmpY1xFvlFrfhR8G
         qL2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779858018; x=1780462818;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nFwG7VGhx5nRDfvYBWcsiTNd1aNj2RuJ8zuR2JIO+LY=;
        b=iZrww0j8PJ1eTQzvOir+Wi43aK3K9y4eQ/DvAst5ivG4xL6uxJrNx472/Su8gGyFSD
         Ju2JIG3Ysze3VAKlmatpFA8pVpq8MrT8tUdGXdVAnZ6Ok3fFWvxuGvf0SQS4W1fqKmqA
         EjYmg8sBRAa2knpMMmfDjjCXREzfZsh0ERN3fB9r/3zmlMbNbDPT1UD33OJVgIHa7+e+
         d1yqNkvWmx/KDQj6lmaLLK69wpxNbNH56Q1+Suwf1GfIiaY5Rc6j/fnl7pecvMKJMu5F
         U1RMHBnL9STgj8IdF+aBSfLGMopLtwPjq4srkEXyqwwPCyZm9IERY+iGlN+uw6NAU5r7
         wVTQ==
X-Forwarded-Encrypted: i=1; AFNElJ9zFQEMPpceTa8T+TOYEoGfOowKoB7NgJYLi/3GnA0uEndCFFM+aZrV7760TTlPdaI49mfdrBCkcA==@kvack.org
X-Gm-Message-State: AOJu0YySidU50KAzlH9hKWw/tBR6QwRKFWF4OmXss6pO54a3O2qwVcn2
	Ji6BSB5F+Z2E7Zm44sZm/GzEScACbw2Vq3GMJIBS9nTSy/fbn1iES+psQ7nC7x1K39qSLltCnqk
	w/q3jja9mlHpncW489LZh+TEBPqF29pdM3f29+J0f
X-Gm-Gg: Acq92OGMfWawJmyUKkTCqAk+dMX2jF9QQ87QsvIuROuIgNeGbBu+5k0TG8UDd1N5UMs
	V8jZJSCIFv3iu/8TA55NgAMw6GKockowiilUwREIVbPlibhWImbT7/+RTrohdw/HpMf8p6rInrC
	sqFEdYlgPsvCjZ5CwSB1QwU+0E/YqcdHlWYgWcm1stIH8LONMei2WCoYGh6wanoXq1VwVVCS2uQ
	DlbONOCHNRFtWXif3euvb8Fi1m3X8FiHxuIJ/xJ+GX9nvWAj4t94kOTqEaMrBe4vKOFeUq6zpXa
	5Ap6jZM0p2iEmvfU9mB9HomWHvTzt31J3f6MpEmMNwL8uHfSsiY=
X-Received: by 2002:a05:600c:e489:10b0:490:3bcf:11ce with SMTP id
 5b1f17b1804b1-4904f68edd9mr2323895e9.4.1779858017737; Tue, 26 May 2026
 22:00:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260202194125.2191216-1-jiaqiyan@google.com> <CACw3F53U8xNTHJkdJMo-74_t0a2dX2cJtQOjpjizU8=UNLQRqg@mail.gmail.com>
 <ahXFPh-a_Zt1Q_r_@lucifer> <ahXVuBoNUeEvLRrb@localhost.localdomain>
In-Reply-To: <ahXVuBoNUeEvLRrb@localhost.localdomain>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Tue, 26 May 2026 22:00:06 -0700
X-Gm-Features: AVHnY4LOR8x_HUOjn534sUEO79tSiX6sIAyC2S_ND39hqBXgfiVtvpIWzc-fiW8
Message-ID: <CACw3F51tWMjcCX-xkfUEKb+nUo+O_Q_gpAi+UhiBL+8i+T8MQg@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] Only free healthy pages in high-order
 has_hwpoisoned folio
To: "Oscar Salvador (SUSE)" <osalvador@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, nao.horiguchi@gmail.com, william.roche@oracle.com, 
	tony.luck@intel.com, wangkefeng.wang@huawei.com, jane.chu@oracle.com, 
	akpm@linux-foundation.org, osalvador@suse.de, muchun.song@linux.dev, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Liam.Howlett@oracle.com, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, boudewijn@delta-utec.com, 
	ziy@nvidia.com, harry.yoo@oracle.com, willy@infradead.org, 
	linmiaohe@huawei.com, hannes@cmpxchg.org, jackmanb@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BFB56100011
X-Stat-Signature: qwt8jnkbphy5yw43bwjy9wgbzz6a8y61
X-HE-Tag: 1779858019-326739
X-HE-Meta: U2FsdGVkX18Il3v7VRlRJjI6NF+WICT+UiCgpUdTN5cXwbFp5h5wLPcOQfQOKXBRQ+uzIuCZvGHm8uCx8sgJ2Quusww/Q/i47h4K8CIictKiwarpFDLBOxJMl3yUOor8+ARh9/aGKqGJuszacGmbpXNVbA/yxEVwQWv5IrRDzXc36uToJnl9GtTsAf3zW0bUfhK31+zaI9SAZlC4N7BjHpvILiD5UwLeNM094NtAFp2ORFStgy6kAW2g9Pp6b5KG3jic4RUx5jo66//+lG2jm79Y/kvSJUqexo16hQ08qD7szLz6FtfWRsYvaDG2+4BBCEir6eDoUgBYtJtMuUgQi6qHlmvtgpxvZMQeJuc96MVrYH6o7dA9JorCJu1we5HNz5G9MbdYHzbyKSABD0M1txVTPbc8k7BUr+i3yC7h/6lLiPQFMMZbPXTboBu/osJ6oIfrpOFtuaP7VOjzWihWm4ymZ1arRW/NXbvWXMiYNfZq5+jt3XTCcTA1PbpPtFymoBCr7glsStm/oz5Nmn1rp9HLk4kH5Q15PZjxtMsuAzT+YgEKfNrJygRS4bfIphVfuxRwqiNH/sqkCa4i1E+Qvs4BnDnRVnxnrzvPjJb6LE9WS8oCVVmS3eL7DsgbznB/OLkrCIFQRjIRMtwRBrXd2jN7u7psElp+9doIpntC1IsL3Y7kKlmx/xss6PkHGwcT21I3zBdc6Iw71Mi1BrV6MjkjKuvTXIEylXftZh2F0BGnL8aRZG78IzAJJdFH4qvkOymU3k2Vtd58sJC5jhDGD8fB7tGrResy/eZ3ipfdvaeHeyleEdgX8TXECXpQTtr/KEX2lgM1qdTFM0l3tcYw5mY6aLrTi9k/plj3DTIFjfR+4AemJWyE8wQnZ9B09KpDqhE62UvlQyetnQU0LnKn5GNf3SF0Vzu1lu4JUxn+mZ/8QmSORafE48abyB0x1mVBG6qcRMkykbkdHQI6eMV
 8deB3wS7
 v4ygmvFDMrCOQTYzWi1rhZYzmp2lH2uxrifA0ntGiKhnEySNazykU4OeSWHA2vJrZ/nVloQRZhR14nE2OBHHyfzYSBy19XNl5v25b0WDMPXKlHDCnd4SaOfcYp4dTGXxIyk1sh9o4XxZ6Fcp5NJdPByZumOCoKhZEER9WwEGp0QZuu/Vj+UjpL5NY/X/akeaZVHp9gmHWRSZ9J5NUsbsZ/So7i52zsvKQC1LfTnYbSceGiZ7wUNLE2Xg8MrieweTF/CnLezMMAc6qgSvWd98ieSUopT/+ClrGN0j896rE1MHuD30LH0jIARGVJyTyoI+0evXb1JsxMf8hTzxlly+B1XdTgXHEjDITQqV6UFQaw5T6EDpW6b70nThPk9O0cyO22X9kZgtUF+e02O9gVCmjZfd04g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks Lorenzo and Oscar.

On Tue, May 26, 2026 at 10:17=E2=80=AFAM Oscar Salvador (SUSE)
<osalvador@kernel.org> wrote:
>
> On Tue, May 26, 2026 at 05:09:28PM +0100, Lorenzo Stoakes wrote:
> > On Mon, Feb 23, 2026 at 03:17:57PM -0800, Jiaqi Yan wrote:
> > > Hi Vlastimil,
> > >
> > > Could you and other page_alloc.c reviewers share your thoughts on thi=
s
> > > patchset? Thanks!
> >
> > Hi Jiaqi,
> >
> > I guess you are blocked on review here, did you intend to return to thi=
s?

Yes, as long as this patchset is useful to the community.

> >
> > I'd suggest attempted a respin to get some movement here as clearly thi=
s slipped
> > through the gaps last cycle.
>
> This fell off my radar, I plan to have a look this week/early next week.
>
>

By "respin" do you mean I should re-work the patches on top of the
latest akpm/mm-stable or linus/master, for whatever the changes in
mm/page_alloc.c and mm/memory-failure.c since Feb?

> --
> Oscar Salvador
> SUSE Labs

