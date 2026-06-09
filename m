Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54349CD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 09:38:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94B416B00A2; Tue,  9 Jun 2026 05:38:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FC076B00A3; Tue,  9 Jun 2026 05:38:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EAE56B00A4; Tue,  9 Jun 2026 05:38:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E8FB6B00A2
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:38:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 185D540460
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:38:00 +0000 (UTC)
X-FDA: 84859872720.24.D59E6CF
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf07.hostedemail.com (Postfix) with ESMTP id D464740002
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:37:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Lswe3NP4;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780997878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lx1Uj9ALacAYcxK3gPmx8FCujSx8SGCSZJ/pzDLpCcY=;
	b=Upb8il6YGMPts6A1lHQBjCbVZ4KSgrz3UE4penKJJ3B9UtSZvOsN01e3jctMCKKMVi8gCd
	lFYleWtGWGqakxkp5acosYXzAn2jFGKSUGIIbjqCEvHXpJgwckBSLca/1hUZWL4vv/1pJO
	R8tIoHtfL2/aI4XtSTdWXmcXcTJaJxE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Lswe3NP4;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780997878;
	b=g2dK78CWTjHosN0TDyqi1NZODtbjyeMAOeHhZnQFKzNiFgGdock1EcA32AL+bo0qVqsnN3
	A8VUxbjCnaS3nhaexBYOjbbqEt8OvcykYR55rmqvysIrnyURrzNs9U6ZyGWCcikoV2OnbH
	l6hRgq4jKWPxcFclQDMuhv1QesKpM70=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-490a767521dso5891465e9.1
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 02:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780997876; x=1781602676; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lx1Uj9ALacAYcxK3gPmx8FCujSx8SGCSZJ/pzDLpCcY=;
        b=Lswe3NP4DeOlt5qwb+tnl2OiKl1L2IB6mg2ZvZDU/BKkK4EH7IrV4mh4e0/hjIztQE
         /DrKKqIjEUyDwXjbTKDxZe5CHmRlU4c6vnpCG3bXUkwpALEFfPogiex4xtlagCmmVK9S
         tmZ/+L8kepsAMcQfgLEr/1ZO1oBXTO7jJFJfwcGXJkF/d/GJlrr3whoLueu1QovYtuZo
         8Q7P1vMrrqhTbKTEmSewNmu4qWTJ7BqZW38MKvjMWtxKe4LwYvaMNhazXyFNQBFh1DT6
         W9IMMCL2ULMXqB6W4XfvbxMteuy97pou3w+w/0XeM34IEdCUlz3HFgTvc/n/16gTVb3y
         XQYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780997876; x=1781602676;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lx1Uj9ALacAYcxK3gPmx8FCujSx8SGCSZJ/pzDLpCcY=;
        b=exm8TCFvIIjxJukxrqPMOdXblUPuoc74IRjfjXxnIZVI/ssvN0eTfb8d2IpcmE6v/2
         Bto1pi5ehsNykpaLZYHs7fPUEGQ7MgQhakJN/r3EpzGHpl4oz30S57iE+W/d9JQI+bM8
         OIRjM9066wfy+xxVvI6cjBmi7i5hIPS5q7KzLjTG+N3WZXMTzXCAns9vvpMK0iK2CGh6
         4Yy1WsGy5aGuTGZPAwoZH5+acr9Y1ESTD/j+sP6aoTGadS1cwqIcn5asJIdCoPfOv/Lz
         pOrS7+4O3sN2wI0Aibizw/zLZuiMr/HZlxWzxU0CDAVT6oLUoTlto4zOtog7i1cBqXb+
         GOxQ==
X-Forwarded-Encrypted: i=1; AFNElJ+oVE1I8QUX8vL1bQlcMHNFFKEzfogwsyOdiW1jYhRTORoA1OPs73qVC9Tqi8SublQm/QuSuCx/8g==@kvack.org
X-Gm-Message-State: AOJu0YytPWL4xeO6a6IUSTBmIfB6/rCj4JGlwwFN24eNBzKWiOBLVDB1
	i3rKx7+QpO4F63w7EtSztY7t4ptvy/gqSOY6h0oLzRaFEl+7eHd95voUcDUwiVx9zSE=
X-Gm-Gg: Acq92OG40uNpMmVjdY26V2Eownkb7IiBxkpc6sEvXl41KJWI/FfwjpOUD03EqOm+Z+8
	65R9odeTRQAb64ypXhm8ZK2Bsr5B1mrKg+pkCAS1FgVMdErblcTiRRWTgYd9k1pWRlSDtE0MN5Q
	0Q0gzgGSzsTh+h0fUzOHcbLfhYxkhUznm+s3kKdC9i2RmfciHxXIZ9Twf7TIEVG4yQZXRYnsjFW
	gISIHi61TADZgMwWfbvxXDq9Lo8a5duCHuVMc5wgz9OAh0sHYPl7Z4vyt097Uwy9dla+whAuTM3
	xaOJCMCIs/un9srt3OOcBl/DFBLVmAQ8EafO/2cQokUUg95qIxsjCcymQoI1JWWOQv6JysDMug4
	lqRKa2qEhMzKU4wRGF9IieJBLOSRySdNhMeA9tpmMrWp9MAKrw1Z1ZT6d+rCu2L/ffo4PNMy00W
	Ib4RmFF8+rEBF0GwWDpxyuyKPtwsss
X-Received: by 2002:a05:600c:8b82:b0:490:abf1:2ddb with SMTP id 5b1f17b1804b1-490c2603825mr139566865e9.6.1780997876074;
        Tue, 09 Jun 2026 02:37:56 -0700 (PDT)
Received: from ?IPV6:2001:1a48:8:903::e14? ([2001:1a48:8:903::e14])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f34413csm59623796f8f.21.2026.06.09.02.37.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jun 2026 02:37:55 -0700 (PDT)
Message-ID: <44bff0d5-3884-45d8-a525-15c6325620ea@suse.com>
Date: Tue, 9 Jun 2026 11:37:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Memory fragmentation with large block
 sizes
Content-Language: en-US
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>
Cc: lsf-pc <lsf-pc@lists.linux-foundation.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 linux-mm@kvack.org
References: <f22caf98-1375-493a-a275-0500ffac3e81@suse.de>
 <aifAm1rRKF75HVeM@infradead.org>
 <1225376d-dc29-44a1-add6-0cb14926a538@suse.de>
From: Vlastimil Babka <vbabka@suse.com>
Autocrypt: addr=vbabka@suse.com; keydata=
 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
 pYekxJujNeEDkUlky0Y=
In-Reply-To: <1225376d-dc29-44a1-add6-0cb14926a538@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D464740002
X-Stat-Signature: naz1of7wnqyx64bmdzirdpz6wsmbogkc
X-Rspam-User: 
X-HE-Tag: 1780997877-568250
X-HE-Meta: U2FsdGVkX1/2q7OTl8HZI1PMK7pJoaQPJwAI0iFXsatKoev1z37nfuQkNlVomPFd83g+FXGYikVKn9wDZsFaiL55S2QFkE5unO95I28tPc9bNZs91BAfw8fxm3Eq7tFM61IdL5h9E38v3HDAhqNwmzbIcA1kbKlAOaRDSNI0vfKRE/GOz9Ep3SNzxbZhQ36xROnpRFFRGcPdocBUYLpvkbb/IWY5fqlcvAzGGGA7TcL0xLNIykXapFESbTxEeCYj/EFSWF+84lMhQH/lS0uRqae5Bs/sKJS1EuZO+jIRfvdl4tLIHtDMFYgBPrGo+fwxUXx4cb3OI5BaBh4tLA3/dySrVTIVlj39SWdxrzTLFVASw4ScVCSO4/r5YUYmEhSYWLWFgMpqlc4MZBQnRf6sURwyRdu72uKW98EJhwCWBbkkyhZ11wpl/lseYe8Q+dge5M2DgQvNxj+f9shZgyUuHrNFOoeujnWjmBnnGbkyhMX4oa0c5Ki+W9Jn7GO/H1KBAsn95XuMx7F4MPSLgX+IOjA74JsW3ECawnv69V81VBvsuZXXVkhS8Q1T/++iBxinVuqXd3pmoZieXHnMP5TovYgFdJ1cqLgI0ktf3mzZMWTEi1bEI7JCaT4C66/cLhWlMZScomFzXL579YqHyJZ5+yBDaDRKicMHgrjWs2bjCQo8ECxDKrDD83gKe0Se9+4M74KZsyWtgrNgZVb+2b5l/v61ogfRMrP3BgxWchXaCX5BojKNTNHLHB3iWtUtjfKGtOXQtxDWiIicoLrk1PQsDJSFjZVVxDLuqfn2g0lXzxAl5qWA3fg+Lmw7NfWyfmSuI5OoL+PDe8FDpc6QqnQRyVj6AcuHQTQFZzqiQFJRiNHrSwGq96GkStscn66FB/a1iV4TpO5nSJiHTuKq8HaRCAJ+qcV/KAVS08hWnf6xHePgxQzNrDtoC/YmZfjXGd2sghxcvpNPcuMPcqo0hhP
 6AMfBgTg
 ZlyizsBcg8fQhgQVxyCqrFQc9QuPTgdnY4RXGDgSIqCvKF3zTYL5EKKAlCgwkymxOFVgeQcSddi5CI9EKpezkh2WNYzP9qWdlSLOWbn7P8vqRImBrIBe5Ciuz/VguQqIOg4E5y1smgNqCLr0Dj0SGbarVrN+XgPa2ngr+Cldl0eXQnwNaUcT/sfsOrTwvT7Fy0BpOnGbxYMGP5u8Okujj1EC3q8hVy3GCXNhzG3mtTBRPXE0WBLavx5IZXGVnScMfRwV84o5d9jGsYl+v7HBRv11cpD0mS+jxtZuBEMp9CYQR+4+E9JWlgmjNtyFiTLcoQ5gglR+EKFuGtjp6c2h9sqdHv2YXBjC8ZnBauG918aTeZXMclL1r5UAkVS6ip7QdR2RKa/4VtgiSOD8RviwEg+084nYAwhDHgK+/BjFU9PNaLXHQCYvxQ5qGQ4IX86Vfxr5uSJAs+eyJGkxexDWExhtYqcEe5++HXqdfZ8aOTP/z/60PBQArFPZsfYYoeHLZsiqjjQ4vZGlvCrE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 10:39, Hannes Reinecke wrote:
> On 6/9/26 09:28, Christoph Hellwig wrote:
>> Hannes,
>> 
>> can you share your results on the mailing list?
>> 
> I sure can.
> 
> We have run a simple testcase with on fio job on an LBS-enabled device, 
> and another job permanently allocating and deallocating arrays of pages
> of various array lengths.
> 
> We then took snapshots of /proc/buddyinfo to track memory pressure
> over time.
> 
> Results are visualized in the attach plot.
> 
> With 4k block sizes we have seen a high number of 0- and 1- order pages,
> and then the expected decline towards higher orders.
> 
> With 8k and 16k block sizes a noticeable 'bump' in free pages was 
> developing in 2- and 3- order pages, which we think is down to 
> compaction trying to merge pages together.
> The number of 0- order pages increased slightly, but only half of the
> maximum number of pages in the 'bump'.
> 
> With 32k block sizes the picture changed completely; the 'bump'
> vanished, and there was only pronounces spike with 0-order pages
> (about four times the size of the spike with 4k block sizes).
> 
> This led me to assume that compaction broke down at 32k block sizes;
> this assumption was confirmed by Vlastimil Babka who pointed out that
> there is a maximum order to which page compaction is attempted:

Yep, but after the LSF/MM session I've realized I made an off-by-one error
thanks to the misleading name of the define.

> include/linux/mmzone.h:
> /*
>   * PAGE_ALLOC_COSTLY_ORDER is the order at which allocations are deemed
>   * costly to service.  That is between allocation orders which should
>   * coalesce naturally under reasonable reclaim pressure and those which
>   * will not.
>   */
> #define PAGE_ALLOC_COSTLY_ORDER 3

Which is 32k

> and it's main usage is 'order > PAGE_ALLOC_COSTLY_ORDER'.

And indeed, this means any changes in behavior due to this should only
happen at 64k (order 4) or more. The value of 3 is in fact something like
"PAGE_ALLOC_MAX_CHEAP_ORDER". I'd send a rename patch (Kiryl fixed a similar
off-by-one gotcha with MAX_ORDER), but I suspect we'll be making more
involved changes here so I'd wait for that first.

> Which ties in directly with what we're seeing.

So it's probably not that straigtforward. We should investigate more first?

> It will probably make sense to align the maximum block size which we
> currently support (ie 64k) with this value to ensure that compaction
> works with larger block sizes. Or maybe even the other way round;
> tie the maximum block size which we support to PAGE_ALLOC_COSTLY_ORDER.
> But that would mean to restrict the blocksize to 16k, whereas xfs
> works happily with 32k. So we might want to raise PAGE_ALLOC_COSTLY_ORDER.
> 
> Question is, though, how could we measure the impact?
> This particular value has been in since 2007 (commit 5ad333eb66ff1 
> 'lumpy reclaim V4'), and it might well be that the original
> reasoning doesn't apply anymore.
> 
> At the same time, this value is tied to a _LOT_ of things
> (not to mention the page allocator itself), so increasing it
> to '4' has an extremely high chance of impacting mm performance.
> 
> I'll probably run mmtests and see what I get.
> 
> Cheers,
> 
> Hannes
> 
> 
> fragmentation.png
> 
> 
> _______________________________________________
> Lsf-pc mailing list
> Lsf-pc@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/lsf-pc


