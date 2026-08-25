Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CDC5C5DF9C
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 01:57:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DAB56B0092; Mon, 24 Aug 2026 21:57:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B1E86B0095; Mon, 24 Aug 2026 21:57:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A0DD6B0096; Mon, 24 Aug 2026 21:57:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DDC7C6B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 21:57:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5DE6A1201E1
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:57:14 +0000 (UTC)
X-FDA: 85138129188.12.51F8F28
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9CCCE80008
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:57:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qBrCq4WI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of thehajime@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787623032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T3Y7JSI1a8tq1uRjkFjsaZKcIVEv3JOwvcnDEKrHIyI=;
	b=xNjOGpwyzisltWmIWS6aYb0PUaJhm4Saz5Rp6CwuEWV9Ij1TprsA1WgQ/2Vjy7p9+HXIwf
	7ehAwQ6CnWnzdkfzxIUjBXKCFR5g8dFQpX6P/zWOIJ7BC7OqqNpbXhDOjo8pS7vFXtXLHb
	s3DmKucM9ytL4naY/A9Onmoo7B8YMlc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qBrCq4WI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of thehajime@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787623032;
	b=n5NWUe1SQv7g02/jc8Ipwq7SlGvtWGWqCmuNr0L7C7ox4GXgUfPvsRE582P2as/ZMe8GmV
	IN+TjgZehuR/IT5id0Llscf/fPc3LX6lMZ50Jh6LG2gMENBbureL5/TFijCloxoW5Q6BvC
	KrQLgNHxYSkvtK7OsSfH9/t24vEJkIM=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c9e607d81fcso2596448a12.2
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 18:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787623031; x=1788227831; darn=kvack.org;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=T3Y7JSI1a8tq1uRjkFjsaZKcIVEv3JOwvcnDEKrHIyI=;
        b=qBrCq4WI2nDUaI+yqkgPuA9P6Idd39S3NYNRJzaqCfWL4ZeGGXh51kiRvtnxeoBnk4
         TJ9UEJ5arnUX2tz7iEVjXI0MMRCkmfBqV85WMK8DX31ZZ+HNq+mFsZJRsihTZU0YFjy8
         a2mhhOhemC4yBBJg0PPPl+s3igRU8/q8cDhyi+znn/8iqu69wHnlnVm0/57NxYzbDkAE
         gwlYLqRmXJW7bauzYz3R0YaQfxZYBRGTKA1N2YwMbiXB2XpTpOJ/YBSL/mCN2Elt7yVf
         xmbAU8R8iQ9JcAMLLTuQJ3dsD43BvRyXBLiz0nHPxlxndK5PNwFf8h9gqxZAQJOLl9NS
         WYUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787623031; x=1788227831;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=T3Y7JSI1a8tq1uRjkFjsaZKcIVEv3JOwvcnDEKrHIyI=;
        b=P8youbA03gGui+uPhRZhE+dOXweCvrHsPZ6RxosIs5fTy2aZBi59WLKz3hQMr2Nx7+
         LIRxa1KRl/sT8Nxw3a3xGgINuqbLtFCBCgh7wLYCByGpsU1+S82JHUvq64TmcQAKTmCE
         ICz4FYNGoBWlXutY5OXZpyF39/L54tLg2tK/smPxv5cIHpcncOZIyO6PRWH9r713h1oz
         el6wnsQT1jMfUMX8cVYbjS/aL5xQIBJp+oF6b+RwBHlP5y6GJmd3qUIaPg47QLjA15tG
         DNEXoU9q1l05uoy2g5knxCw9M1PRqIN7qE0os9ma6/BiH/XNVLArkWlgFW39EQulnTSY
         okqg==
X-Gm-Message-State: AFuF++nEfHYdHXeOeWv3Y18G9NZBUTFHx3Dlup/GcODqe2BViKkKVlUQ
	cg3UDVLATPfDCemOE0zw4jDEoqGz9WAk4Zu0Q54F6PpWCYA7h39eDeGi
X-Gm-Gg: AR+sD13kEcpCLe3J69TXIJA/UThO33fZsak+oy6Y/AygvH75nQYKbhw2ruOga+hVQTM
	IRHD0AXKqgjiE/C7mp633nvf4wx3I8hgxC0WDuK8jhIoxxP2EvG8Q6PASkq6JCf85FllNWLJ1fx
	7b2K3eWrHRXvR91v6YZecbBOcPGp0JT8uoS8mQ9LD7JX2EheApe93RGoC53HsRnr2AZ82wcsVfI
	CpYZH1EZ4cy0u+hW6ClOCUnrZp8rbm3kQnnBb6+wdacJonU4uacgf3WnswSazg8Bycq0+AhSVfO
	PRIO9TZuBK0F+kN6i1Bd95bZUV7yaqKJEwe+kq0QOOw1XMkB5+0w6nWtRuePETVrv0xmvRRyMkf
	olFRT/CEAe9OkG9zSd5yPJwUO1suzJbT1QHho3/8ofjdI3cdNcAKSEDnXxmObFKtpf44ieWGty/
	j7iO7b97zOEK0O/39GcsvvaMtEXzeA+mBQOa8EL564MfRTDOaPEgpSZKt+LzjgdtSKj9aYWqMLm
	w2oNawXqX41u2zmrB5C+jQdBBPIXQYWZPd4eoS/4ntXpSYscVnbRkGDTfkGmLTNnW5KMfOQp2l+
	0GamFQ==
X-Received: by 2002:a17:90b:582e:b0:38e:524:8797 with SMTP id 98e67ed59e1d1-3964652c610mr5884454a91.13.1787623031308;
        Mon, 24 Aug 2026 18:57:11 -0700 (PDT)
Received: from mars.local.gmail.com (221x241x217x81.ap221.ftth.ucom.ne.jp. [221.241.217.81])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39645b64c48sm1675960a91.8.2026.08.24.18.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 18:57:10 -0700 (PDT)
Date: Tue, 25 Aug 2026 10:57:07 +0900
Message-ID: <m2ecfnvu6k.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: ljs@kernel.org
Cc: linux-mm@kvack.org,
	geert@linux-m68k.org,
	daniel@thingy.jp,
	arnd@arndb.de,
	gregkh@linuxfoundation.org,
	willy@infradead.org,
	jack@suse.cz,
	akpm@linux-foundation.org,
	liam@infradead.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 3/6] mm: nommu: fix an issue on map request to /dev/zero
In-Reply-To: <an8BlTgk7sc5vFJ1@lucifer>
References: <20260813063401.1786548-1-thehajime@gmail.com>
	<20260813063401.1786548-4-thehajime@gmail.com>
	<an8BlTgk7sc5vFJ1@lucifer>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Stat-Signature: 3a5jxdzmqj3woczs75r53tg67b35xff7
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9CCCE80008
X-HE-Tag: 1787623032-637647
X-HE-Meta: U2FsdGVkX1+6w9JWFQ5uT4Vu8OKGuorEhahtXetg4W+q50k2cxsAjuvaNUYTz7gLM1HSLVrYvIBqXMgULDFT1I8fPCO3h6FIf5YcpUx3Nwjcp97fwFT+BHgFwNAWBb9Pao19pJh2fuFyGFKDxOo40BkWvp2kTqo93PM9/WQ/JPd1D1aWH0ijJNhVOCHypQVtOxBMQmuomsNiZtGTnMl8scIF5s8b2uhPJ1VQyEU77sYlfaec9MsU/BLHKK9LGFxzdcgVZ3PeI2ouFyLxFkD9mXpiyU8PWI7If3UrbTH90tm6E1tMfDeoqlZEQzclVzs4NuWmUrHMGjqVGcbYdpXY+HG3lTyJx/J6NZ513tMBcRMlF6nEyP6Y8zTMd4ABA6YCqnQq7bw424HAwV46n+lkzFL1Y2SDhDPs/Bgqfcd4IdaHniyhzfDRF4JZKFJo+S5FC/kjYc1LBH/tWmk4jUInYNnpLTEGRvjUQ1/Bo3gK2pCpAFQxHXY6evXIfewNJzNi1LBSow8pZXeqtsc2jN7K5VPVyQsstnMvD729a7uRyvghpqgZHLMKO5a/Etnkqn6X64SKYRPgzUCFEbbnp1vZ26eP977VQ/DbvbNhfpxQxLYeA72r4dF/U/Z1l2f9v07OprJyuIbWiG5pCzFUiphL8xbzB07mbd2gkywzYqaLMcb+/etRViMjNA8jmTdJRW2daQRmB+qiHy/0K/IP+Xn3h8ErQnp6EdcAJrcARYF04+TFzD3do/dPpGj22VPw39C5XRxoW6gmgAOBMskI5iREdWxq8l2/myg6qcaizQQ0M0OHNp50gjkXUClcoCwFgzfUjptDaLIcSFtReYIM11dPuSQ5yF3KXzPW8Kw2h5VEAb6Wncy0F199Vw7O0CmaA8JKr2uLJ76l32mai+36Ixv4Sbdawk7YGNTagHSp5sQeUHL0p2kSCDztUNSdLPIFJ4VvojbvVKhZvDG/vyMdzbt
 j+l7ziow
 6x6FcprkqBR0TBYWKLS2ORGRCN6aj7iBxDptStqwOeibWrU6UXyf5O6WuzBnGAWPtwnCVxf/eOXFHSOa6k0r20QAxNakwOuVidoa0lX3FumrIX59SXS0kCVuRXkRFFAomzNXzK5PjybZpa9At83PaowK5RZk2iMWffaDlZFZZJym6X13csCT04wCoEgsEYqN7do2ixQj2dUlrHxBwo+GLMtMp/3ESecv3VU8fGX6vvs4VQ/pkAArDC2XPcg9OqafsI8ukRTSbhukut7bCS3ZEPzP/4ArVcWa1n76onjG1s09EGX3ObpLr6CrAvFpRqb8iZdYFRPVHWIJcVWRC76OxEiVfdwC5HvFQ16D69LwyGDXu+nkHII0PDBZVLfx168IDe7vcF8jENjaL8X4WZiE2JyA2FNgLmeS1lDuq3vQgoO32pnMgDqzzc7vi/vg7Rj6afWR62SDXLiXn778KTw0sdMqg09M4wn4ypohhsS8ReJ+fkfHy7ERSV00hOgrPD9Yjx2ykpjvZ6WsQweITPavFaQgHhIZSjSDTBuJfEFlN+hKeboztZ88pavVstoW/DEhCcqSz0J8PqqFgvOI8KkrhTqX6IS4f7nQTHDxENOi6245fS5cB/3lZE8EH3T21FkHDv4DZ8FGX4qFxNu855XoCETnVF1uOteYbStsZoEtR9SNEu9enahZ5aX/nfmCPOKptX0Dt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hello Lorenzo,

sorry, I didn't answer this comment.

On Fri, 14 Aug 2026 21:37:38 +0900,
Lorenzo Stoakes (ARM) wrote:
> 
> The subject isn't great - before you're not allowed to mmap /dev/zero _at
> all_ on nommu, here you try to allow it.
> 
> I'm kinda against it to be honest, nommu has been functioning... I'll not
> say perfectly fine, given it's broken in many ways that nobody ever
> reports, but I'd say instead 'the same as it was' with no issue.
> 
> And you're not really explaining why you need this.
> 
> You're not correctly supporting MAP_SHARED-/dev/zero AFAICT at all, it'll
> just... actually I don't know what it'll do

okay,
I started this patch when Sashiko reported, so for me it seems this is
a bug.  I wasn't aware of the fact not allowing mmap /dev/zero on
nommu.

> On Thu, Aug 13, 2026 at 03:33:58PM +0900, Hajime Tazaki wrote:
> > Upon a private file mapping request to /dev/zero, it calls
> > kernel_read() in do_mmap_private(), getting a failure with the message
> > like: "kernel reads not supported for file /dev/zero", which is because
> > zero_fops defined in drivers/char/mem.c has both .read and .read_iter
> > definitions.
> 
> Can this be broken out into its own separate fix please.
> 
> It's not about /dev/zero at all but rather being able to MAP_PRIVATE-map
> literally anything with .read and .read_iter.

I understand.

> >
> > Even fixing this issue, the map request to /dev/zero works fine without
> > errors but the allocated vma isn't marked with anonymous because
> > mmap_zero_prepare() isn't called under nommu platform, resulting
> > vma_desc_set_anonymous() isn't called either.
> 
> "Resulting _in_ vma_desc_set_anonymous() _not being_ called either" is clearer.

thanks,

> >
> > This commit fixes those issues by:
> 
> Already 'issues' suggests >1 patch would be a better idea :)

agreed.

> > 1) use vfs_iter_read() instead to avoid failure at kernel_read()
> > 2) calls .mmap_prepare on private mapping in do_mmap() so that required
> >    preparations are done even in private mapping.
> >
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: "Liam R. Howlett" <liam@infradead.org>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: Vlastimil Babka <vbabka@kernel.org>
> > Cc: Jann Horn <jannh@google.com>
> > Cc: Pedro Falcato <pfalcato@suse.de>
> > Cc: linux-fsdevel@vger.kernel.org
> > Cc: linux-mm@kvack.org (open list:PAGE CACHE)
> > Fixes: 4d03e3cc5982 ("fs: don't allow kernel reads and writes without iter ops")
> 
> Yeah as Greg says, it really suggests nobody is using mainline nommu in any
> serious way given this is from 5.10 and would require avoiding /dev/zero in
> a way that seems kinda unlikely.
> 
> Should be Cc: stable also but not as a combined patch, the mmap_prepare
> bits only came in recently.
> 
> > Assisted-by: cubic.dev:unspecified
> 
> Unspecified? :)
> 
> Really the best approach nowadays is:
> 
> Assisted-by: LLM # it wrote the whole thing
> 
> or:
> 
> Assisted-by: LLM # it merely complimented my dress sense
> 
> Or whatever :)

I tried to follow the way described in
Documentation/process/coding-assistants.rst, which says

```
  Assisted-by: AGENT_NAME:MODEL_VERSION [TOOL1] [TOOL2]

Where:

* ``AGENT_NAME`` is the name of the AI tool or framework
* ``MODEL_VERSION`` is the specific model version used
* ``[TOOL1] [TOOL2]`` are optional specialized analysis tools used
  (e.g., coccinelle, sparse, smatch, clang-tidy)
```

but cubic.dev, which I used for the assist, doesn't document about the
model they used.  without MODEL_VERSION, checkpatch.pl reports an
issue.  Thus put a name for the moment.



> > Signed-off-by: Hajime Tazaki <thehajime@gmail.com>
> 
> In general this is opening up whole new areas of code to nommu and given
> nobody seems to be testing anything I'm not sure I'm ok with it.
> 
> Since forever /dev/zero's been disabled for mmap in nommu. So I don't
> really see the point in making it work at quite a lot of risk here +
> necessitating doing some more nommu stuff in unrelated areas.
> 
> In any case, it's probably worth waiting for me to do my follow up series
> on /dev/zero next cycle, which will inform how it will look for real
> arches.
> 
> It's worth breaking the read_iter fixup out of it though probably, and the
> mmap_prepare support.

understand, anyway I would wait for your update, and go with another
patches for the fixups.

> > ---
> >  drivers/char/mem.c |  5 ++-
> >  mm/filemap.c       |  6 ++--
> >  mm/nommu.c         | 84 ++++++++++++++++++++++++++++++++++++++++++++--
> >  3 files changed, 87 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> > index 63253d1de5d7..dba24d0a7b33 100644
> > --- a/drivers/char/mem.c
> > +++ b/drivers/char/mem.c
> > @@ -500,11 +500,10 @@ static ssize_t read_zero(struct file *file, char __user *buf,
> >
> >  static int mmap_zero_prepare(struct vm_area_desc *desc)
> >  {
> > -#ifndef CONFIG_MMU
> > -	return -ENOSYS;
> > -#endif
> 
> > +#ifdef CONFIG_MMU
> >  	if (vma_desc_test(desc, VMA_SHARED_BIT))
> >  		return shmem_zero_setup_desc(desc);
> > +#endif
> 
> This is pretty horrible already :(
> 
> You're also letting VMA_SHARED_BIT be a return 0 noop, that
> seems... unwise?
> 
> You can use IS_ENABLED(CONFIG_MMU) to make things vastly less terrible,
> e.g.:
> 
> 	static int mmap_zero_prepare(struct vm_area_desc *desc)
> 	{
> 		if (!vma_desc_is_cow_mapping(desc)) {
> 			if (!IS_ENABLED(CONFIG_MMU))
> 				return -ENOSYS;
> 			return shmem_zero_setup_desc(desc);
> 		}
> 		...
> 	}
> 
> But again, I don't really feel that nommu should be enabling this and I'm
> changing the /dev/zero stuff anyway.

noted.

> >  	/*
> >  	 * This is a highly unique situation where we mark a MAP_PRIVATE mapping
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index d721986d5f46..cf02faad86aa 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -4077,7 +4077,7 @@ int generic_file_mmap(struct file *file, struct vm_area_struct *vma)
> >  }
> >  int generic_file_mmap_prepare(struct vm_area_desc *desc)
> >  {
> > -	return -ENOSYS;
> > +	return 0;
> 
> Err, no, making this a noop breaks it?
> 
> I'm not really hugely fine with you making this be the same as CONFIG_MMU
> either as I am not confident in the change being correctly audited given
> the until-recently total lack of testing of nommu, and now very limited, as
> well intentioned as it might be testing.
> 
> I would prefer anything that currently doesn't function with nommu to
> remain so.

as I mentioned, I would defer this patch if maintainers think this is
intentionally disabled, or it is not the right moment to change the
behavior.

I'm pretty fine as this is a Sashiko-initiated fix, not personally
motivated fix in real use case.

> >  }
> >  int generic_file_readonly_mmap(struct file *file, struct vm_area_struct *vma)
> >  {
> > @@ -4085,7 +4085,9 @@ int generic_file_readonly_mmap(struct file *file, struct vm_area_struct *vma)
> >  }
> >  int generic_file_readonly_mmap_prepare(struct vm_area_desc *desc)
> >  {
> > -	return -ENOSYS;
> > +	if (is_shared_maywrite(&desc->vma_flags))
> > +		return -EINVAL;
> > +	return generic_file_mmap_prepare(desc);
> 
> Again same objections as above re: doing real-arch stuff in nommu.

noted.

> >  }
> >  #endif /* CONFIG_MMU */
> >
> > diff --git a/mm/nommu.c b/mm/nommu.c
> > index e40990e15831..a29a53c1c80a 100644
> > --- a/mm/nommu.c
> > +++ b/mm/nommu.c
> > @@ -37,6 +37,7 @@
> >
> >  #include <linux/uaccess.h>
> >  #include <linux/uio.h>
> > +#include <linux/major.h>
> >  #include <asm/tlb.h>
> >  #include <asm/tlbflush.h>
> >  #include <asm/mmu_context.h>
> > @@ -856,6 +857,22 @@ static int validate_mmap_request(struct file *file,
> >  	return 0;
> >  }
> >
> > +static int is_file_anonymous(struct file *file)
> > +{
> 
> As stated on the cover, I don't adore this and that's all changing soon
> anyway.

understand.

> 
> > +	if (!file)
> > +		return 1;
> 
> It's 2026 use a bool please.

thanks,

> > +
> > +	if (file->f_path.dentry && file->f_path.dentry->d_inode) {
> > +		struct inode *inode = file->f_path.dentry->d_inode;
> > +		/* if the device is /dev/zero */
> > +		if (S_ISCHR(inode->i_mode) &&
> > +		    imajor(inode) == MEM_MAJOR && iminor(inode) == 5)
> > +			return 1;
> 
> This is horrible really. The /dev/zero stuff I'm doing kinda had to do
> _something_ this this (in a roundabout way) - well I thought so - anyway :)
> 
> But yeah again wait for me to do /dev/zero follow up.

understand,

> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  /*
> >   * we've determined that we can make the mapping, now translate what we
> >   * now know into VMA flags
> > @@ -869,7 +886,11 @@ static vm_flags_t determine_vm_flags(struct file *file,
> >
> >  	vm_flags = calc_vm_prot_bits(prot, 0) | calc_vm_flag_bits(file, flags);
> >
> > -	if (!file) {
> > +	/* private and file mapping will be marked anonymous later (do_mmap_private()).
> > +	 * and /dev/zero is marked by them at .mmap_prepare,
> > +	 * which should be _before_ this point.
> > +	 */
> > +	if (is_file_anonymous(file)) {
> 
> You're kinda throwing in a bunch of random stuff in 1 patch you really need
> to break things out more.

okay.

> >  		/*
> >  		 * MAP_ANONYMOUS. MAP_SHARED is mapped to MAP_PRIVATE, because
> >  		 * there is no fork().
> > @@ -923,6 +944,29 @@ static int do_mmap_shared_file(struct vm_area_struct *vma)
> >  	return -ENODEV;
> >  }
> >
> > +static ssize_t nommu_read_iter(struct file *file, void *buf,
> > +			       size_t count, loff_t *pos)
> > +{
> > +	struct iov_iter iter;
> > +	ssize_t ret;
> > +	size_t done = 0;
> > +
> > +	while (done < count) {
> > +		struct kvec iov = {
> > +			.iov_base = buf + done,
> > +			.iov_len = min_t(size_t, count - done, MAX_RW_COUNT),
> > +		};
> > +
> > +		iov_iter_kvec(&iter, ITER_DEST, &iov, 1, iov.iov_len);
> > +		ret = vfs_iter_read(file, &iter, pos, 0);
> > +		if (ret <= 0)
> > +			return done ? done : ret;
> > +		done += ret;
> > +	}
> > +
> > +	return done;
> > +}
> > +
> >  /*
> >   * set up a private mapping or an anonymous shared mapping
> >   */
> > @@ -993,7 +1037,7 @@ static int do_mmap_private(struct vm_area_struct *vma,
> >  		fpos = vma->vm_pgoff;
> >  		fpos <<= PAGE_SHIFT;
> >
> > -		ret = kernel_read(vma->vm_file, base, len, &fpos);
> > +		ret = nommu_read_iter(vma->vm_file, base, len, &fpos);
> 
> Hmm so now you just assume there's always a .read_iter and error out if
> there isn't one?
> 
> Seems questionable.

you're right.  I should consider such situations.

> >  		if (ret < 0)
> >  			goto error_free;
> >
> > @@ -1080,6 +1124,28 @@ unsigned long do_mmap(struct file *file,
> >  		vma->vm_file = get_file(file);
> >  	}
> >
> > +	/* call mmap_prepare function if any */
> > +	if (!(flags & MAP_SHARED) && !(capabilities & NOMMU_MAP_DIRECT) &&
> > +	    (vma->vm_file && vma->vm_file->f_op->mmap_prepare)) {
> 
> > +		struct vm_area_desc desc;
> > +
> > +		vma->vm_start = addr;
> > +		vma->vm_end = addr + len;
> > +
> > +		compat_set_desc_from_vma(&desc, vma->vm_file, vma);
> > +		ret = vma->vm_file->f_op->mmap_prepare(&desc);
> > +		/* private ramfs/romfs mappings fails with -ENOSYS so,
> > +		 * fall back to copied mapping.
> > +		 */
> > +		if (ret && ret != -ENOSYS)
> > +			goto error_mmap_prepare;
> > +
> > +		ret = __compat_vma_mmap(&desc, vma);
> > +		if (ret)
> > +			goto error_mmap_prepare;
> > +	}
> 
> Again break out code into separate functions please!
> 
> I invented this compat mmap_prepare stuff to handle stacked file system
> mounts, and I intend to remove it once the mmap_prepare conversion is
> complete.
> 
> But I suppose... maybe stuff could be migrated to nommu.c at that point as
> a local fixup just for it.
> 
> Probably worth breaking this out as a separate patch too then so
> mmap_prepare is properly supported in nommu otherwise stuff will break
> there, eventually (with X year lag possibly inf on reporting of course ;)

understand, I will take this into consideration.

> > +
> > +
> >  	down_write(&nommu_region_sem);
> >
> >  	/* if we want to share, we need to check for regions created by other
> > @@ -1196,7 +1262,7 @@ unsigned long do_mmap(struct file *file,
> >  	add_nommu_region(region);
> >
> >  	/* clear anonymous mappings that don't ask for uninitialized data */
> > -	if (vma_is_anonymous(vma) &&
> > +	if (is_file_anonymous(vma->vm_file) &&
> 
> As above re: this function.

understand,

> >  	    (!IS_ENABLED(CONFIG_MMAP_ALLOW_UNINITIALIZED) ||
> >  	     !(flags & MAP_UNINITIALIZED)))
> >  		memset((void *)region->vm_start, 0,
> > @@ -1247,6 +1313,18 @@ unsigned long do_mmap(struct file *file,
> >  	ret = -EINVAL;
> >  	goto error;
> >
> > +error_mmap_prepare:
> > +	if (region->vm_file)
> > +		fput(region->vm_file);
> > +	kmem_cache_free(vm_region_jar, region);
> > +	if (vma->vm_file)
> > +		fput(vma->vm_file);
> > +	vm_area_free(vma);
> > +
> > +	pr_warn("mmap_prepare failed for %lu byte allocation from process %d\n",
> > +			len, current->pid);
> > +	return ret;
> > +
> >  error_getting_vma:
> >  	kmem_cache_free(vm_region_jar, region);
> >  	pr_warn("Allocation of vma for %lu byte allocation from process %d failed\n",
> > --
> > 2.43.0
> >

anyway, thank you for your time to looking at the patch.

-- Hajime

