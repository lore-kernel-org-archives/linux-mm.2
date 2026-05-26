Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9CABCD6E40
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 21:52:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE2626B0005; Tue, 26 May 2026 17:52:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B92C06B008A; Tue, 26 May 2026 17:52:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA8616B008C; Tue, 26 May 2026 17:52:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 987486B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:52:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3F3754049A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 21:52:45 +0000 (UTC)
X-FDA: 84810921090.26.CD47C38
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 77FFD20008
	for <linux-mm@kvack.org>; Tue, 26 May 2026 21:52:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jRKFuqdw;
	spf=pass (imf03.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779832363; a=rsa-sha256;
	cv=none;
	b=Hr4Bu1kAlVEwI6inLILUHPwkON9+g1vElu9r2XixB4s2tMWYjqbLKVL6lAoNV9CHdeJ2j2
	Z3g4Q80ZA3CTphNt3LK3hYALzBzSLT3quiM0E6XOo4KNCNhbXGuRVtu5zXM2K+GLWincNZ
	zU3xfKKSmMVT0BwgyKIH+QzPEOAUZWk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jRKFuqdw;
	spf=pass (imf03.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779832363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YI4DLcvbXipAMyS1cQ/oZ3L9E0DlHKPUuIOEJebdbEE=;
	b=CZNkdqVZHHj9qlgmODpLI2OwVk05Tu03Aj2x+FNw5BMqjoCofWULOlUa7XzuMosgNRczzW
	0/4zVA+S+elCGor2tQq59GCMyaav6OxY42/FArASnZbrmQAYlJGSRl1+RLbsFZaHAzpg3L
	ewly9gtvhb7s3rGUuFmSDA09VmaKl3M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F73F408F6;
	Tue, 26 May 2026 21:52:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAAA91F000E9;
	Tue, 26 May 2026 21:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779832362;
	bh=YI4DLcvbXipAMyS1cQ/oZ3L9E0DlHKPUuIOEJebdbEE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jRKFuqdwRftvpOm9p7jpjT92MLNyesJVNfVyNIM6a8b28h8abHP+de6smVeNxUS9s
	 AD0l4dGEhJdqCPFSNruEo3kcQA6qGgOohdfyV2+C9smodAtEedm7lj/yYzvCbZkX/N
	 AhBesMpOvOXzZkccXIcGMs8/wpQZew5M3lYM1ffGf2mrdBelcDDj4zS/ARObMxNm3G
	 36RGlLV6aHNIhk8jBnOLufsXmVucf93UgdJIqW71/oUxCpXCxMEbwYXjJTliOyrkre
	 mwMAeN4DB/kKvUYAZAA90cKWwvgyv5XIZYsJd+ohbd9J2C3CKprqObflqhP8pgdeX3
	 4QkN0Jb1ArP3g==
Date: Tue, 26 May 2026 21:52:40 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Akilesh Kailash <akailash@google.com>,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <ahYWKH9-ybDlZuJd@google.com>
References: <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
 <ag_OVwPF49LSZ7rz@google.com>
 <20260522141115.GA8258@macsyma-wired.lan>
 <ahCNmWbcd_2lAJyk@google.com>
 <20260522224108.GA18663@macsyma-wired.lan>
 <ahTzHyHBL8t0iNBR@google.com>
 <ybmbjekuvzmaw4hmlxd7nxs546dqtwmxqxwyali74d6m3u7tat@b4q3japqnhrl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ybmbjekuvzmaw4hmlxd7nxs546dqtwmxqxwyali74d6m3u7tat@b4q3japqnhrl>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 77FFD20008
X-Stat-Signature: 9s6xyb5wsh6ureoyxf6oi4o6xih91z8m
X-HE-Tag: 1779832363-168944
X-HE-Meta: U2FsdGVkX1+u6huzfeI+9mf/DEy8zgrvhtd65byRBwNQPdUbOBX+IsGQ3M4MWDJz0cfvEIzl54rud1ZaDDA4zHKchVtEzgjY8t1hP0d52p94cj3LcL39j1KXgyYm+tTrTYiFjW/QUTSdZyoS2pY0ANhsrOqUiv9grpwuO7R+Vi7svc4v0OFAXujnyOnhVeZfqa6UOxZojw8MKrfPAcc1qL34wOzr1GUHgmrbas9ISSo5Bg74ZmMlHs7GYV6gKiKDQ3BhBQFTuLwMIZ+cKaFCFC3qp41wjmvtEXMg1rnbiL/q660We4bjBOhmyPxUb1v8ESj89mbupnkNxeQ7TWcyndeLZJIGLr/9MODXB9ssH7EPFjuK8PD0CxihhirDqNs2Yi7C4hs5HDJ4aRB8bZOc4Yj/wg3j7b/Lva4oMYDHwIuvt2cIWcvDUo+/vBautgYMkqNmF0VGO4LtEfw+/Aux+kyySeLUtOVIAp3IsDuo+NLF4PCSAj5FuhK1GumcKlEOirVaiiDF61dFY9kSjQv0Gls7VOQhfWOD4chDShfPPIk2h5lZ3XB3HPrIcF9oTqWLwD+DaFvrRYAS1TNPopuZ7Kj3t0WOsw7cHQay8Jm2S9MKdTxtm3pAfsBdDj2cJ6WgV5I13oWHEhdkKzlmJ0WUJm+o+xX73Vubv1mKyHDGiddbbEV76Ky9ETIu1FAtvbO3hmDxqr0B5Dbi30my0v2j1eMQKURwbdt5gMbwGbaX7W6NDNPiFxJ06TzY4ekZHyiHgMbJvyf2JCjeJ5x6XxKdtul1Uwrp6ajFlzWxNlDugoWZS/oJ/0lX05d1tcaYOwpkGjhHGgP/te9B1sPR22MRi9F3FcDEKXtodgKSyTDf2M4p1J/xD3luFXLxafCotERGZSSm2otzK39GkstJ9LGJv6uqJtB5WDqQMRecfiBoChomi+n5dYyxhCxqT/Hz1LkmDOibGBg6REFJuj0f0JY
 ip9oVa3d
 dCfV6/L73J1zoMdmAjXrbBD0q2802YvhiXd6juBuGzp4NFQiOFArfwwLm5eEUhFSbESMOOcDQPg4VrXgz+rTw3ZIc0w0gh5zvqer5MCQuIxVI3m7Lrr2OvRQLzMzzexX4v+gYxLsR/FQxQlUc6e5adYqetGvLBPDzTkyEewDvsjcKEt6Pym2uH4Pk3OAkXUNKGXqvoZBR7Md+EsUqzVU7ySr7WoyGskoFnBySu7tqPbXrmzGKbDdjywJWdIffmNvjzzyD+fk3NHeHUVnIRB4iPNM6c4+4zgTt0KIkYIEN/WMhTVSpTKfKGG1a4L0E/PoA006tmhZ8Vs9l6+Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/26, Theodore Tso wrote:
> On Tue, May 26, 2026 at 01:10:55AM +0000, Jaegeuk Kim wrote:
> > Background
> > ----------
> > The primary use case is accelerating AI model loading, which demands
> > exceptionally high sequential read speeds. In our benchmarks on embedded
> > systems:
> >  - Using high-order page allocations allows the system to saturate the
> >    Universal Flash Storage (UFS) bandwidth, reaching 4 GB/s even at
> >    medium-to-low CPU frequencies.
> >  - In contrast, standard small folios cap performance at 2 GB/s.
> 
> So you're interested in optimizing the I/O speeds.  And apparenty, on
> your hardware, the UFS controller has limits on scatter-gather entries
> --- UFS seems to call this Physical Region Description (PRD) table
> entries.  Per Gemini:
> 
>     1. PRD Segment & Length Limits
> 	
> 	Maximum PRD Entries: Hardware limits typically cap the number
> 	    of PRD entries (or segments) to 255 or 256 per transfer
> 	    request.
> 	
> 	Maximum Transfer Length: Each individual PRD entry typically
> 	    allows a maximum transfer size of (65,535 bytes) per segment.
> 
>     2. Host Controller Hardware Limits (UFSHCI)
>     
> 	Transfer Queue Depth: A UFS controller supports a predefined
> 	    number of outstanding task request entries. This is often
> 	    hard-capped at 32 concurrent transfer requests (slots) by the
> 	    doorbell register array.
> 	
> 	Descriptor Pre-fetch: Some UFS host controllers are
> 	   pre-configured to pre-fetch multiple PRD entries sequentially
> 	   before requiring main memory reads.
> 
> Is this an accurate description of the limits that you are trying to
> work with?  How much data are you trying to read?  Looking at Gemma 4
> models, E2B is about 10GB or 3GB for the 4-bit quantized version.  E4B
> is 15GB, or 5GB for the 4-bit quantized version.  Is that about right?
> 
> It seems... surprising that the additional I/O operations are actually
> throttloing UFS device bandwidth by 2x (4GB/s vs 2GB/s).  Have you dug
> into why this is happening, and whether there is anything that can be
> optimized below the file system?

I can't tell the exact size tho, roughly it's between 1GB and 4GB. And,
per lots of test results with various tunings, it turned out memory
allocation speed was the culprit. If we use 4KB page, we couldn't get
the full bandwidth unless we set the biggest core running the highest frequency.
Unfortunately, however, we can't use the core like that due to performance
drop of other system service and power drain.

> 
> > Problem Statement
> > -----------------
> > High-order pages become heavily fragmented and scarce shortly after
> > device boot.  We cannot afford to deplete these limited resources on
> > default filesystem operations using large folios. Instead, we need a
> > mechanism to strictly prioritize and reserve high-order allocations
> > for specific, critical payloads—specifically, large AI model files.
> 
> There's a fundamental assumption here, which is that the only use of
> high order pages is the page cache.  This doesn't take into account
> anonymous pages used by programs that isn't backed by files.  Nor does
> it take into account kernel memory allocations.
> 
> But that being said, you seem to be assuming that you can reduce the
> pressure on high order pages by only using large folios for these AI
> model files.
> 
> But the problem with using small folios is that if you want to
> actually *use* the memory, unless you want to segment out the memory
> so it can't be used for anything other than the AI models (e.g., by
> using somthing like hugetlbfs) it's just going to break up the memory
> into smaller folios.  So that's not actually going to *help* in actual
> real life use cases.  It might help for your artificial benchmarks /
> experiments, but in the real life case where Android applications are
> running and fragmenting all of the device memory, the large folios
> won't be available *anyway*.

Agreed it's hard to get this done perfectly tho, as the best effort on this
particular AI model case, I focused on two timings when loading the models:
1) right after device boot, 2) dynamic loading when required. To secure high
order pages, for 1), I disabled the large folio consumed by EROFS, while for
2), I tried to call compact_memory before loading the model. Both of cases,
I could observe we could get fair amount of large folios. Yes, not 100% tho.

> 
> > 
> > Q: Why is deregistering the inode number linked to inode deletion?
> > A: We need the high-order allocation hint to persist even if the inode is
> >  temporarily evicted from the VFS cache. To achieve this, we maintain a tracking
> >  list of hinted inode numbers. When a file is permanently deleted, its hint
> >  becomes obsolete, requiring us to deregister it from the list to prevent memory
> >  leaks or identifier reuse conflicts.
> 
> Assuming that the high-order allocation hint is a good thing, why not
> just make it persistent?  e.g., just a *real* extended attribute
> (which is more wateful of space), or grab a flag in the on-disk f2fs
> inode?  Then you don't need to have an in-memory list of hinted
> inodes; instead, you can just have the Android package manager set
> that flag indicating that you want that special treatment.  This is
> all assuming that we need an explicit hint, though....

I think that's doable, yes, if the explict hint is acceptable.

> 
> > Massive AI model loading is a long-term architectural
> > paradigm. Providing a targeted VFS/filesystem hint to optimize read
> > bandwidth for specific large datasets is a highly practical,
> > repeatable pattern that addresses a systemic bottleneck in embedded
> > AI deployments.
> 
> It's really too bad you didn't propose this as a LSF/MM topic, and
> presented this at a session at Zagreb two weeks ago.  That would have
> been a much more upstream-friendly way of collaborating, and it might
> have allowed the mm experts to give you some more dynamic, real-time
> feedback.

Indeed, I was off from LSF/MM for years due to various product issues, not
related F2FS tho. Let me make some effort to attend upcoming ones like LPC,
if I can get the budget from company.

> 
> Cheers,
> 
> 					- Ted
> 
> 
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

