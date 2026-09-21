Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EF58C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 12:36:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A98EA6B00DF; Mon, 21 Sep 2026 08:36:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A70176B00E1; Mon, 21 Sep 2026 08:36:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 911116B00E2; Mon, 21 Sep 2026 08:36:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6E6696B00DF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:36:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E6038120153
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:36:37 +0000 (UTC)
X-FDA: 85237718034.11.1C766B6
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id C778640015
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:36:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HKVQrNyW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OD9EmZus;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cHHrtVLq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CSecNRpc;
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789994195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KmKS7vgZjryTeBZ+ib7L48JK7MuFB51dHdQeosw3LQk=;
	b=jz4Q9MehkPb298xc6X/HhZMGkm4s9gVdOzbJ5y6YNqCXfV8OXPDqtuWpl5GpuQ9VhQevyk
	BibcKrfU+1xEY+sMQdwWNN0/Felkl2YPfpnmVCfALlKggMhkxgVIQHrKaLnBGPOEJxmvqw
	bf16ymvgMMzRY1HNyQz0BULXKa1qZBs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HKVQrNyW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OD9EmZus;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cHHrtVLq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CSecNRpc;
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789994195;
	b=mDK9jrqweXuBmG09zIgETV6UCi1AEXST2INIorg6KimKOrhmmL4j5K/QtS1aCtGJ3jZwph
	kDdBJcYtFX0D1M9jDVlvPwGZp5x6oXO9Gbidw92VCeQyGGuSfXBe7vqUU6tLU6RxY9EonX
	1ayRl6mQ8k2gOS89AaCuFQgO6OmDOYE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 31FFA1F79C;
	Mon, 21 Sep 2026 12:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789994190; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KmKS7vgZjryTeBZ+ib7L48JK7MuFB51dHdQeosw3LQk=;
	b=HKVQrNyW0PujYUrfNIOmuleTTSxxTpFxmY8ftBGt3h7T4CNzL0bnb2b9+bNQ2BQCGshM/g
	DWrJX2ipGhw+f0ez89lE3mzVUpaB7hyCm9ZuOxWPTECUleJ7QhsjjgifO3FkqTMqbGt4ag
	EWZ2nWgYa3up3Ks4A+F/WJgtbQ6W254=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789994190;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KmKS7vgZjryTeBZ+ib7L48JK7MuFB51dHdQeosw3LQk=;
	b=OD9EmZusZV0ghtKl3GVXtAhKF796oMJvfJl2KALuwhm9BBdfkyeBngkI5Vv4FLOsZ7rdUo
	PCkm5OmJ11RWxNCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789994186; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KmKS7vgZjryTeBZ+ib7L48JK7MuFB51dHdQeosw3LQk=;
	b=cHHrtVLqY1veO2gvOxhdj29S6Ykkt5fi4s8Ju8EMh850xgEPdd2gWjLJK16JdNLD+456AA
	jh/dSaO0BuimasECzYrd13F6zGPTbecPLvjlRQYrPBiOk9ABMPL3uBXhIyLCHK9Qt0kEpP
	SVXZ/laSHvpa/msD/LWwv5ckuduntW8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789994186;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KmKS7vgZjryTeBZ+ib7L48JK7MuFB51dHdQeosw3LQk=;
	b=CSecNRpc0BOLGYO4qK3Xc2+1nIvCVfFI6XHUaAXzALOxJvdC0/MND1spvgcxpwX6afDUfw
	YCjrJqitCopj0vAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 91FAD13793;
	Mon, 21 Sep 2026 12:36:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id swsyGMkksWrpRwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 21 Sep 2026 12:36:25 +0000
Date: Mon, 21 Sep 2026 13:36:23 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: ayhan =?utf-8?B?YXlkxLFu?= <nsd.project.dev@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] Neural Storage Driver - learning page cache
 prefetcher
Message-ID: <arEkgM15qewERAOJ@pedro-suse.tail5790ac.ts.net>
References: <20260725182628.221603-1-nsd.project.dev@gmail.com>
 <CAFLp9PEQQVuDpJPwrNvLN1-u3w3TMwZPUUrf0+rOBrvDjBBf1A@mail.gmail.com>
 <anlByPDZmvEhWeXI@casper.infradead.org>
 <ffcij36vnozf3rginqd2opd2dwqyki7xhtdo4veuty734hhgba@utjav2k263o6>
 <nsd.1787001235.35928@mail.gmail.com>
 <w7vte4itudtkw2yf4vbmuofiumfffmp2y52dpu2bqvqtdgjvpd@5femyiozss3e>
 <CAFLp9PGkVYZcQT5qAx-RKFOF-urZ92m417zpAeF7ZQempbS1HQ@mail.gmail.com>
 <o5ihhfa252cjfspqlag65xhnmehz3a5feyclmlyy4xlrcmceck@njmhyu7oom3d>
 <CAFLp9PF+6KUY7ZAGQZ_X9AN4VYbkdW_aDk1QSth3ZAVVqLTqsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFLp9PF+6KUY7ZAGQZ_X9AN4VYbkdW_aDk1QSth3ZAVVqLTqsQ@mail.gmail.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C778640015
X-Stat-Signature: cdfcicxm8ynquwy79mt37oafr9geupwj
X-Rspam-User: 
X-HE-Tag: 1789994195-465303
X-HE-Meta: U2FsdGVkX1/TIyhMo9WsL03MRHRz/WPNdFbS4uwnCMvwV9T4KnQNRg7lOF0Fp0ON8BJjr7LlCT314hEjsSXT6Dc7gAtwBRNe1azYzOtTTzD9Q9fkgU8RAWajOyOQrBWxT12oCo4VGN5SDIW9+MsEOoFFExNfoDd+BjO4s4KcJB+6Jri7nlLnlsKVLdfv606nFht9oBDqWG2iAu+d/lamdrsdRcXnGVl51aRnX8a/g/f1+veBX7Sh6mt5OVAN0r5iPPQZH1d5Ryc715nmCVqln0JewW3ZdMXwLDD8sv12HfdqRhXW8iI6M8axrbXW+LVjkZQ6f+vJ2GQQej0LU1/YlfAlIU4VG8ZHuExeFAGoSNx997tDXLQTEPQmgzTvvGgCLwwYHBNhp8noziyZmoVY+dWjO4Xp7jDhGUhAHlCjXt58GjjIW7/HBJZSVyyXVKNjtgUerHdDcJHPxBV7V+30/I3ftcRZpOG3kLZ13ULEN8AgpMmhh4HTV5v0ijCYACFAaYNfp5+deNrB/dOwM7/BhfRz69ndDswdqwyVLsutiTwPWr0NCyqGx6lrSJFiLEpO693S1rktp6OdKMgq0E6H40uAqWYaryJHmbnPpV2VjA7PB53Fd+zA+tiZ/f+rWSxvGrkyBgeldUwd5fHc4NkI6obnR/wo8Qg1zEL5D0XHsB4YN1TzaNiM5yDUidhKq7LiloP0NpL+LilZ3Tk7+JxF8rvjFBjSRpXAdka+Egyyq5rw3+rkH18nIItv9VVSd3G2BR6ULW9vSEmlixUkO3gPAcuRTHyZqs5Sx2EtJUzoPXVPT3LM2cSHbYLKnUh9YeQmZwAM9QfaK0zoxxDG3U8vOyLWYGPh3EWNUo6FiHzr+0PbkMX56j0kGALiWo+LrxQ5iK8AXsWPVviB523DkdQargKIA5r6xzQ6gHZgf1+ExVkc6y/ZMeg4Vi5Bb6/Pgy3UH3gj5GxUthcKbTQGK2u
 DLbLnS7N
 JHfmjDIBdVpbpe9zxooFPG+uMeG23g+NR4AB35A8t07BR2vq3CChzkWy+dkkaCzoOfWmkOvSCEB4QiaUd58pBUU17b4E8Slm0Ifv5xftkFMTHQNOpd4h+RTjbWGx/ui579qyIfD+Fv7dLwZT9N1Z7OdDRDDyVjBTisPoVfGByD75xb6dCncaZzx5c59D1j3FQV4kvvEK/jOCaafhAfvFvCUuatIFYnjj83PfNVlakvz3icXBzbwuSFtSqO9zOR3l+wONDfM0Q/1jOvzH+8CDy67/G4iyMYTl6EcVqx+cVRQ7TAuCGKlPAIBqCP/wT0t7K8tsNJiKtt5h4AWoRRI9wEl1kgAm1Z7mR8Ugc9qufkKoJrFQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Can you please reply with something that isn't copied straight out of an LLM?
And, ideally, add the Assisted-by: LLM's where necessary.

On Sun, Sep 20, 2026 at 03:39:20PM -0700, ayhan aydın wrote:
> Hi Honza, hi Willy,
> 
> First, my Aug 20 follow-up bounced on the HTML part. My mistake, resending
> as plain text. Below is that content updated with six more weeks of
> measurement. Two self corrections first, before any numbers.
> 
> What changed since the RFC (same out of tree module):
> Automated prefetch never exceeds ra_pages now. Overhangs get trimmed
> or dropped, all counted. The only exception is our own measured
> willneed ranges up to io_pages. That follows Ming Lei's RFC direction
> and the MADV_POPULATE precedent. It is toggleable, Mod A means strict cap.
> 
> Fault path first, as you asked in Q3. filemap_fault hook observes, then
> prefetches with depth capped at 2 and bounded by the cap. One more
> thing on this: the fault path stands down explicitly at 1M windows and
> up. There is a straight s_bdi->ra_pages check in nsd_process(). The
>   parity we see at 256K and 512K is a different thing. Our code still
>   fires there. The kernel just catches up on its own at those sizes.
> 
> A sleeping in atomic bug in our fast path got found through a stack
> trace and fixed. vfs_fadvise was called from fprobe context. It now
> goes through a workqueue.
> 
> A len==0 fadvise footgun got found through our own counters. Len 0
> means to end of file, so those sends preloaded whole files. All our
> earlier big mmap and SQLite speedups traced back to it. Retracted.
> Sends with len 0 are now dropped and counted.
> 
> Narrowed claims after all that. Interleaved A/B, drop_caches before
> every run, checksums verified, 500+ runs in total:
> 
>   sparse mmap scan, about 64KB stride, 512MB to 20GB files, 128K window,
>   SSD: ON ~47s vs OFF ~88s median over 30+30 reps, no overlap.
>     The threshold lines up exactly with FAULT_AROUND_ORDER=4 (65536B).
>     Below it the kernel fault around covers the fault by itself.
>     Above it, it does not.
>   same setup at 256K, 512K, 1024K windows: parity, kernel catches up.
>   dense mmap, rand 4K, seq read, SQLite, THP, and HDD sparse mmap:
>   parity everywhere. The early small HDD lean got remeasured with
>   current code and traced to the same len 0 accident, retracted too.
>   No workload regresses. dmesg tracked throughout, no new warnings.
> 
> So the scope is sparse mmap scans at default size windows on
> SSD. That is where the fault path underprovisions while the read path
> is already saturated. Dense, random, 1M tuned and HDD cases are parity
> by measurement.
> Separately, one thing that might be useful here too: p99 tail latency
> is about 4x worse at 1M than at 128K regardless of NSD state. Another
> practical reason to keep windows small.
> 
> Open questions, updated:
>   Q1, fadvise beyond ra_pages: we stopped doing it silently. Only
>       measured willneed ranges up to io_pages, and that can be turned
>       off. Acceptable shape?
>   Q2, ra_state integration: we prototyped window steering from the
>       module. The kernel keeps our window but wall clock does not move
>       because there is just not enough volume from outside. Real
>       integration needs in kernel changes, so we drafted a minimal one:
>       2 stream slots plus stride state in file_ra_state, every window
>       bounded by ra_pages, read path only. Want me to post it separately
>       for direction feedback before any boot testing?
>   Q3: fault path first as described above, with timely versus correct
>       accounting running underneath.
> 
> For Willy: backward patterns get detected near perfectly (strides with
> negative deltas, counted separately) but they do not move the wall on
> SATA SSD, so throttled now. Fault path is covered as you asked.
> PG_readahead replacement stays an in kernel question as above.
> 
> Full data and the retraction notes are in the tree. Happy to run any
> counter matrix you ask for.
> 
> Thanks,
> Ayhan
> 

-- 
Pedro

