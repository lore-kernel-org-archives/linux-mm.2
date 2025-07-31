Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 929ECC87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 17:09:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A45C6B008A; Thu, 31 Jul 2025 13:09:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 256046B0092; Thu, 31 Jul 2025 13:09:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16AF86B0095; Thu, 31 Jul 2025 13:09:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 063736B008A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 13:09:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 92E86BBC52
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 17:09:29 +0000 (UTC)
X-FDA: 83725196058.09.2264B68
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id C57121C000F
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 17:09:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JrYhVc0x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753981768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BNLgy0LBtzJv+1Qw+K6PGYvOeXMA0fsVW0wwiDg57n8=;
	b=F8ckjCTRpVSlB6Teg9eivRHGH6tAaMOjA2jEQ87jKW4sRopx0JcCitqXMrdk4hQzJ6hB6V
	uFpN5FFm5RYP/OqfuE3DvIo8YWmamAku2YP6fYGCjHcS7cp4kaMEV//83CLIbDSiIxffuM
	/hcOWs0c1av13QFo7+aDSF3BME4YeUA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753981768; a=rsa-sha256;
	cv=none;
	b=MiB6awc78aTPtNS3bvk3S+HNtwHURRRvHOCpYUguLd0M0hfeQYToalrTc1cCgZfVDVlBUA
	ygLxdpqbcoWVthv8nM+4Ggv0T/vM+a51lGExdMl+VF/D5yyQfraGxHuuqwtwa+VZKgs+r5
	NBbhbTp6L1+kX0w52VlDTObdqexz028=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JrYhVc0x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A064F440FF;
	Thu, 31 Jul 2025 17:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578C8C4CEEF;
	Thu, 31 Jul 2025 17:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753981766;
	bh=6bPNipU0whTXeXOhptgV+3Q6u/o8UbEZkKzhgED/zPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JrYhVc0xd4AcMXOGqQ0Y8GmkjSdg4OTi0uigcLGh+9hlV3+eXpAjERV3Hsn8+YCNO
	 yMswq5UkElC8KNPSPq9U0jOFCe/y8L1d/vQaMuaCsg37rKV1gM6cI7VyVoj7HLOWYS
	 puzRJgmPQG59HL3sa5iOt6oMiixqKGRuX1OTZDA/CoLyJONtreMK+SNqXpp2DLrYZn
	 ekwVF4HXof5kTPFidO2CcwRshg11Hv0Lj1/iaCBHQsPktfSVN5f9kwEniUVutlGT3u
	 XwcRFccN2PnUXNqED+fIbFbzahSuZiX0Yti0nBNLs5J6XcLU4ZqF/XkLIDt3JRi3w1
	 1LKe03BYd1KIw==
From: SeongJae Park <sj@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Takero Funaki <flintglass@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/zswap: store compression failed page as-is
Date: Thu, 31 Jul 2025 10:09:22 -0700
Message-Id: <20250731170922.15509-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250731152701.GA1055539@cmpxchg.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7hazm5uxf9fqkq4x4bwfqcgze7w6kd4x
X-Rspamd-Queue-Id: C57121C000F
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753981767-727761
X-HE-Meta: U2FsdGVkX18bM3P/12HhOjQAVhM3qKTdjoL77I7iulOokNpZYnfiSwnzf58VQkF+jQJjpVzxQTmiXyH+77juQCZmLhJt14UbdvUzcopVkR/vZpOjoWM6FozTteP7v90heRIdco8p/2338Yr1qaHBq3vIEYyblG+ggwo+ti6dJuSnJhBBjpGEuPcsngAoT8gnd0njTyNjbW7Egyp5fRyqz/x9GssUorQv9zh8s86Atbzmua/S2kCU/9u1EmLLtUrgEYwVtwAXcX5hUhNlNuoL+q6bNWFJVdAvZx98FyEcz0OGkozsUoZE1nFi7wYiuurVqT37vUJk0iUCRELRwbXlCixGCb49Q5Yo/1SR5N8laF/xjsxgH2AAD5OVPNNm5ThsNGvaiJHbNf7tpbC+IEBF400jeP6aeIBTkAdYISccQKoTGuTRjISbtxrL3B6puvfOPqhFL0UBliH7BGs/lGOhtDtQIRqrl/sXkBDeHJcyq5vdU85N4Sx7wVxSLkvqiKLSKeBQ6ijFrVxTpgA13WF9JIRh96YG8IHP1oY2I6ksC/4a/jSDP1of0kHB+TE+Ta26BImFjcHARWIS/OjXOAdLlWUXhQkWE+ihgCkuHrySmwNwQ+MHbrZqqApurdPWUI9Wm7iU1A4nd3Rc7ZWQuwAUKHLsQdc1qfrVPS5DjAxlN9CTja5IziFr7X5b+0xqDYLEkC8w3EWah354Vc3SFi98qpMrlBDGPrdrVtAoA/xl96kIq1xlib9JWJmEH+3dYzSA1x4o7QzJazDPU6Mh5t4OPJuam2vIXDqA3xEJckGQCfqU+Ez5D0Avqls/gGF2u93bWxyQ3r+xm1PfHaeyGjNHQk5/8v9zpXxcY2WTYF+5aLD6fc4EOkKDKiUvQ1fbhDiaushz+6VNkcwa72C7sUVmBG/soTMu87v0axZaTPMc8/Do1AFO/gahkcJRX5tSx7CJO2Umo43nV1fsI4QZIuB
 LfwOBHDJ
 pHT+Sl8OtN0xe+PDSf/zXwbd+O4FQEnXh6+jIyU7RDCjFLN3s33/YU7wm04/FvPpbZY/HsK2mVBN5VV9476iECVrGhVDGrIvLRkOuZVWvdJqrN8IocuzKavmt03m4SpT57Br0xsEFoDSF0AeEnbcMP/w14GdaGC4kFHo4/0h6l6JSRlhAMOV+eeviXKZ2iKvdhkB8UU1Ufhm2UT0ptNZERVYQELJHcRKDOFeSjLPaXROUgEJn9LX0P4snt1zXNZu/zyfTYo+x0ra00s4DUBuFShiCCUllFZ5GObRc9W1Hy+jKYC7mmcNoo3BHLw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 31 Jul 2025 11:27:01 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

> Hi SJ,
> 
> On Wed, Jul 30, 2025 at 04:40:59PM -0700, SeongJae Park wrote:
> > When zswap writeback is enabled and it fails compressing a given page,
> > zswap lets the page be swapped out to the backing swap device.  This
> > behavior breaks the zswap's writeback LRU order, and hence users can
> > experience unexpected latency spikes.
> 
> +1 Thanks for working on this!

My pleasure :)

[...]
> >     config            0       1-1     1-2      1-3      2-1     2-2      2-3
> >     perf_normalized   1.0000  0.0060  0.0230   0.0310   0.0030  0.0116   0.0003
> >     perf_stdev_ratio  0.06    0.04    0.11     0.14     0.03    0.05     0.26
> >     zswpin            0       0       1701702  6982188  0       2479848  815742
> >     zswpout           0       0       1725260  7048517  0       2535744  931420
> >     zswpwb            0       0       0        0        0       0        0
> >     pswpin            0       468612  481270   0        476434  535772   0
> >     pswpout           0       574634  689625   0        612683  591881   0
> 
> zswpwb being zero across the board suggests the zswap shrinker was not
> enabled. Can you double check that?

You're correct, I didn't.

> 
> We should only take on incompressible pages to maintain LRU order on
> their way to disk. If we don't try to move them out, then it's better
> to reject them and avoid the metadata overhead.

I agree.  I will update the test to explore the writeback effect, and share the
results, by the posting of the next version of this patch.

[...]
> > +/*
> > + * If the compression is failed, try saving the content as is without
> > + * compression, to keep the LRU order.  This can increase memory overhead from
> > + * metadata, but in common zswap use cases where there are sufficient amount of
> > + * compressible pages, the overhead should be not ciritical, and can be
> > + * mitigated by the writeback.  Also, the decompression overhead is optimized.
> > + *
> > + * When the writeback is disabled, however, the additional overhead could be
> > + * problematic.  For the case, just return the failure.  swap_writeout() will
> > + * put the page back to the active LRU list in the case.
> > + */
> > +static int zswap_handle_compression_failure(int comp_ret, struct page *page,
> > +		struct zswap_entry *entry)
> > +{
> > +	if (!zswap_save_incompressible_pages)
> > +		return comp_ret;
> > +	if (!mem_cgroup_zswap_writeback_enabled(
> > +				folio_memcg(page_folio(page))))
> > +		return comp_ret;
> > +
> > +	entry->orig_data = kmalloc_node(PAGE_SIZE, GFP_NOWAIT | __GFP_NORETRY |
> > +			__GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
> > +	if (!entry->orig_data)
> > +		return -ENOMEM;
> > +	memcpy_from_page(entry->orig_data, page, 0, PAGE_SIZE);
> > +	entry->length = PAGE_SIZE;
> > +	atomic_long_inc(&zswap_stored_uncompressed_pages);
> > +	return 0;
> > +}
> 
> Better to still use the backend (zsmalloc) for storage. It'll give you
> migratability, highmem handling, stats etc.

Nhat also pointed out the migratability.  Thank you for further letting me know
even more benefits from zsmalloc reuse.  As I also replied to Nhat, I agree
those are important benefits, and I will rework on the next version to use the
backend.

> 
> So if compression fails, still do zpool_malloc(), but for PAGE_SIZE
> and copy over the uncompressed page contents.
> 
> struct zswap_entry has a hole after bool referenced, so you can add a
> flag to mark those uncompressed entries at no extra cost.
> 
> Then you can detect this case in zswap_decompress() and handle the
> uncompressed copy into @folio accordingly.

I think we could still use 'zswap_entry->length == PAGE_SIZE' as the indicator,
As long as we ensure that always means the content is incompressed, following
Nhat's suggestion[1].

Please let me know if I'm missing something.

[1] https://lore.kernel.org/CAKEwX=Py+yvxtR5zt-1DtskhGWWHkRP_h8kneEHSrcQ947=m9Q@mail.gmail.com


Thanks,
SJ

