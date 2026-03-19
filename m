Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BC0F108E1F7
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 11:59:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC8076B0495; Thu, 19 Mar 2026 07:59:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9E026B0496; Thu, 19 Mar 2026 07:59:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB3B96B0497; Thu, 19 Mar 2026 07:59:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 959176B0495
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:59:00 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3344E1B8147
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:59:00 +0000 (UTC)
X-FDA: 84562666440.07.A9198DB
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id C9A39C0004
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:58:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nSKhg5D9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zwzdr+xX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nSKhg5D9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zwzdr+xX;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773921538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oKoAmC5H5WL0MZfIguD4pR+XH+ZQMjAOOTptAPJl/Y8=;
	b=BxhsBCCKX96EP7SlXpLYw/U3wc1kkcClapvhvlXhQckO/EDQcorIa0W3WFtmEpkvoB/5Af
	UvqH67sBzWpH9PW4YZj1fUwRSTKlRGc7GLCd/Ov5YfgV3RdWoWxobAZtRsTr0V8OPxpBQe
	x/Z89qoq9f0D0QYC8Fa85FgOV6Nw8d4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nSKhg5D9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zwzdr+xX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nSKhg5D9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zwzdr+xX;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773921538; a=rsa-sha256;
	cv=none;
	b=kM8foZZVHbzMGmZPfF4ktTders5/r2g4s0i3TGxo4o+sLLvpaWoMDF6OP278szZUiDcIso
	StitWiGBmgF42s2mW47Fv/k9HTUer4DJWW95Dyo2sYQy8MtwbOpu3iCoCZPlA2n2r9x/Sv
	1kqBPU+c59R7iITxUuGMaDdZFPJpIis=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B50F15BD45;
	Thu, 19 Mar 2026 11:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773921535; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oKoAmC5H5WL0MZfIguD4pR+XH+ZQMjAOOTptAPJl/Y8=;
	b=nSKhg5D9cRCTMSxWiaWiUbsfNSOulM/++tiDrKjaYiWcHL6m+7V9IBkKBm9F/jZz5GjsIE
	Y2YeBGqTzv7Z5Rp2lx+Tx54T5YqKOmjcMVoL8/tEDj2M1p+Ku/gw8tkQSfYwZIJDr34zIl
	LDVe8tjTg3LD3BA87H5Ew7BLE3/cj0I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773921535;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oKoAmC5H5WL0MZfIguD4pR+XH+ZQMjAOOTptAPJl/Y8=;
	b=zwzdr+xXpSPMkxZs3hlI0VJumMhkiI92xqBgRmeS4UMVCMSFNlKy+bxxRQ2qvYDrfTfywu
	T0TsNZ3vwOLE1jBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773921535; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oKoAmC5H5WL0MZfIguD4pR+XH+ZQMjAOOTptAPJl/Y8=;
	b=nSKhg5D9cRCTMSxWiaWiUbsfNSOulM/++tiDrKjaYiWcHL6m+7V9IBkKBm9F/jZz5GjsIE
	Y2YeBGqTzv7Z5Rp2lx+Tx54T5YqKOmjcMVoL8/tEDj2M1p+Ku/gw8tkQSfYwZIJDr34zIl
	LDVe8tjTg3LD3BA87H5Ew7BLE3/cj0I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773921535;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oKoAmC5H5WL0MZfIguD4pR+XH+ZQMjAOOTptAPJl/Y8=;
	b=zwzdr+xXpSPMkxZs3hlI0VJumMhkiI92xqBgRmeS4UMVCMSFNlKy+bxxRQ2qvYDrfTfywu
	T0TsNZ3vwOLE1jBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9DFFE4273B;
	Thu, 19 Mar 2026 11:58:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gyWLJv/ku2nLVgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 19 Mar 2026 11:58:55 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 54B4CA0B32; Thu, 19 Mar 2026 12:58:51 +0100 (CET)
Date: Thu, 19 Mar 2026 12:58:51 +0100
From: Jan Kara <jack@suse.cz>
To: Yunzhao Li <yunzhao@cloudflare.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Jesper Brouer <jesper@cloudflare.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: balance_dirty_pages() causes 40% IO PSI (full) with no drain
 benefit on 384 GB machine
Message-ID: <z3quejtbpkiizgmvu2pjhqv6ioyach2wszen5slkau2hossj7p@rk2ftlwbdfw5>
References: <CAAnvDSwOoEOkMEDgKUcHkx-SdmZ_ar5AbVy4Gp-XT7i04ON5fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAnvDSwOoEOkMEDgKUcHkx-SdmZ_ar5AbVy4Gp-XT7i04ON5fg@mail.gmail.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: C9A39C0004
X-Rspamd-Server: rspam07
X-Stat-Signature: 9x8rhb7j1s738p7ttyixj9is1t9197j8
X-Rspam-User: 
X-HE-Tag: 1773921537-673390
X-HE-Meta: U2FsdGVkX1+3t7NYPCpiND94lk8/Nj2hE0FqQyBmpwMF42Z4BoIyhQLCmyKX0mGw3dYQn2PLLwWAir3Nc+Pvi/WNHsSLmYtxFePqdOWfvJOkI0ep/ObhZKNx+JAOR1Nc/aj94XIjcVqt44G5cARFUWe2nUFaN2kM0XPJSOpPNxgGYHYHBUgSh/RbTLJN3F0pR6ED0nqaUnmNAmUqHG7+1cSXfMsSSeq5om5Ke5peEo4w1V2GkzSGVdsH/50sbv6f/luXsIzjM/k8Nj9sMIKIUiQ/GX5QUmVfyFb94WVH7r47UTLJNgUHi+5z5wWO8vmK7uHJjTlwJ7MZm+TR4pIlXjIHdN8gkcl9q7A6U99Ep1iYjCBwjMgS0TxJCgFW1lbDX9vESv6/4K/zQpFNAAHv19ySjy4KFCzjowlO1ef2/9aLCN0aTnF4LiUkSYK6vmIlziaMQq8VBUp6mW6rFwkEu5h42/Px/AxCZiRKLYR1Ad7ZKnBZdy4KmKDaial+y69RRZK3bYWJjuK5YveN8HEMForRJf4sb9q4pZwkZME+FerIhUTJ75wJrnuA/AsEDMWqIdXoizK4YK5lUuvb0A3uwa753vwC+O3wxAJf2Riqfk9BMdBoFKBcon6uoZjAV82g0GjYYI3MKM6cXQbHnH22Rxgd76ZaCYJNZmlOiZLen0SwLhafiYWJGr1+QcGHCKI9ytb88t6YX9KFRYbQI7yzqXrryRk2UhGvAseZiGkzL3x7DeI1PKZZdOdLIzLH19KkMKidv+aC4yWOdaW9MseaUksxiDn6Onr9tcQqVFHCFXAQQ0uyxt/yIPUPdEFQqhMnqSkN4bWionesNIEoLo3woYUlZBMbw9XRMpVVaAgyX+c8PKuSQHwBrFs+8HDTwb1oFlUK+cEX8VTdXEmnTxGm1uDGEMvXIrzegJrd0voIENQZJme/OL154raHgM9Kh9/WjX4PWHyYZ2PXhcVqpZi
 RFbjl6FM
 p82akLAroGOQiSsxFgZtBAE4wDxUu3QKdKEM4ZCYhX9ltPa1rUPJpNp07cJuAnIRJNjMevqN4b5SJ44H+IqxguGz969lccOjJEU1EhXdrqeuUqaY2jNxTMGhd6Rn6hfyL5PbiwvKgmz63G+5UI/6+LR4oqtdMkbVftMH2/Rt/ko59NfCEZPi9eA/O9hQeXmJ4+x2xVUXZijDiJqlXYkftWGRQMpfbhvbfgDskV/2IJ5ESWn9+i+FRAGd7yhB+vVo9YQ3O7QFztRvL58U6qFaJogL/jgRPMdAeuQt1BnGzchVFLo9fbkK48QNMB8epHVdQbbt9u7aX4NqiUGUWLTojDcuqBMRNbA/+EDThuggzNTOTtW0eR4LUiTZzqVlOSwZQHPzD66bYJKd5JxGRMAi+1xgWaVZZ0pB4gFBJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

[looks more like a question about IO PSI behavior so CCing relevant people]

On Tue 17-03-26 15:53:51, Yunzhao Li wrote:
> On a 384 GB machine with NVMe storage (2x NVMe RAID0, dm-crypt,
> XFS, kernel 6.12, AMD EPYC 9684X 96-Core), balance_dirty_pages()
> throttles writers via io_schedule_timeout(), causing 26-40% IO PSI(full).
> But the throttling doesn't actually drain dirty pages faster.
> The flusher only submits ~578 MB/s of writeback regardless of
> whether writers are throttled, and the NVMe device has ample
> spare capacity (1,044 MB/s benchmarked).
> 
> I'd like to understand whether this is expected and what the
> right approach is.
> 
> The setup
> ---------
> 
>   dirty_background_ratio=10, dirty_ratio=20 (defaults)
>   dirtyable memory: ~77 GB
>   -> bg_thresh:       10% * 77 GB         =  7.7 GB
>   -> freerun ceiling: (20%+10%)/2 * 77 GB = 11.7 GB
>   -> limit (hard):    20% * 77 GB         = 15.5 GB
> 
>   Write generation:   ~580 MB/s (HTTP cache miss writes)
>   Flusher drain rate: ~578 MB/s (device can do 1044 MB/s
>                        flusher can't feed it fast enough)
> 
> Below freerun, balance_dirty_pages() returns immediately.
> Between freerun and limit, pos_ratio ramps from 2.0 down to 0
> via cubic polynomial that tasks sleep proportionally in
> io_schedule_timeout(). At limit, pos_ratio=0 and all writers
> block (max 200ms sleep).
> 
> Generation ≈ drain, so dirty settles at 10-14 GB — crossing
> the freerun ceiling into the proportional throttle zone.
> 
> The observation
> ---------------
> 
>                  throughput  IO PSI full
>   dirty 5-10 GB:  494 MB/s       1.4%
>   dirty >10 GB:   578 MB/s      26.2%
>                   (dirty still accumulating at +2 MB/s)
> 
>   Peak IO PSI full: 39.5%.
> 
> The proportional throttle adds 26% IO PSI (full) but dirty
> still grows. The flusher is already at its submission ceiling
> and sleeping writers doesn't help it submit I/O faster.

The throttling of the writers works as it should - the point is to not
allow writers to dirty more memory than is the configured limit and as your
data shows that is indeed what the code successfully does. The point of
throttling is *not* to speed up writeback or anything like that what you
describe above. You are correct that page writeback using single flush
worker isn't able to saturate relatively fast storage - that is a
limitation of current writeback subsystem and is something that is being
worked on (by allowing more parallel writeback workers) but it isn't IMHO
substantial for this report.

I cannot really comment whether IO PSI of 40% is or is not appropriate for
this situation - I'm deferring that to PSI guys I've CCed.

> The device is actually starved: writeback-in-flight drops from 6-8 MB
> (baseline) to 1.8 MB (during throttle), and NVMe QD drops from 45 to 37.
> The device could drain more if fed more, but the flusher can't feed it
> faster.
> 
> Meanwhile, memory is not scarce:
> 
>   Dirty:          16 GB
>   Clean file LRU: 57 GB  (instantly reclaimable)
>   Memory PSI:     1-2%
> 
> The dirty pages aren't causing memory pressure. 57 GB of clean
> pages remain available for instant reclaim. The throttle is
> protecting a resource that isn't scarce, at a cost of 40% IO
> PSI (full).

The configuration is that no more than 20% of you page cache can be dirty.
The throttling code just makes sure this is the case. If you configure
higher limit, that's what throttling code will enforce. However note that
higher amount of dirty memory is unlikely to increase writeback speed -
that is likely bottlenecked on CPU overhead of submitting writeback IOs.
Also note that the limit is set to 20% because dirty memory is not possible
to reclaim fast (you need to write it back first) and so in case of memory
pressure the machine can easily trash for quite some time if the dirty
limits are too high.

> Our workaround plan: dirty_background_ratio=5, dirty_ratio=40.
> This raises freerun to ~17.5 GB, keeping dirty in freerun.
> The flusher drains identically. It runs to bg_thresh either
> way.
> 
> Questions
> ---------
> 
> 1. When should balance_dirty_pages() sleep writers? Currently
>    the criterion is "dirty > fraction of dirtyable memory."
>    This doesn't consider whether sleeping actually helps
>    drain dirty faster, or whether the remaining clean pages
>    are sufficient. Should the decision factor in flusher/
>    device saturation or available reclaimable memory?

I think I've answered this above.

> 2. Is tuning dirty_ratio to 30-40% the expected approach for
>    high-memory (>256 GB) systems? Documentation doesn't
>    cover this.

No, it is actually recommened to set it lower because more dirty memory
doesn't usually help IO throughput beyond certain amount. But it all
depends very much on your workload and it's dirtying pattern (how much of
the page cache gets frequently redirtied).

> 3. The freerun ceiling gates entry into the proportional
>    throttle path. Even moderate sleeping shows up as IO PSI
>    (io_schedule_timeout is accounted as IO stall). Dirty
>    never hits the hard limit in our case. It sits in the
>    proportional zone, but cumulative PSI from many tasks
>    sleeping short durations is already 26-40% (full). Should
>    the throttle path be skipped when sleeping cannot help
>    drain?

Perhaps bumping PSI when dirty throttling kicks in is not ideal measure
(because it doesn't necessarily mean the storage itself is maxed out,
besides flush worker not being able to saturate the storage there can be
also various block layer controllers arbitrarily throttling background
writeback) but again I'll let PSI guys to chime in here with their
opinions.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

