Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61CC9CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 04:24:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F7458E00C0; Tue, 12 Aug 2025 00:24:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A31D8E00BE; Tue, 12 Aug 2025 00:24:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B89C8E00C0; Tue, 12 Aug 2025 00:24:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 656DA8E00BE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 00:24:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CEA9E115296
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:24:26 +0000 (UTC)
X-FDA: 83766813732.11.8F267F0
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2FC2240002
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:24:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ORehQ+3V;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754972665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SISqaPWaEdFgIf5huLZHpnyFyaSM0xVnvM53J+71qbw=;
	b=27X91tg4wb9yzsgns2HjJEAqNo2UFtlgRNxwmWQCPY4PzxoW6G7oo7iL2O5Yh55VUxQsU6
	IZe+wC+HqojoxR59DkNZr7YmAIPy90yF8Ql9xh+lWEJHrKhIRY5UnMpyw40gBc0a2FV92D
	bZ7thx/3HmQeIK98dh7GA6JW25tCTGg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ORehQ+3V;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754972665; a=rsa-sha256;
	cv=none;
	b=JVO1nX3wXatXxstIgue2W35o0KqbOYm8N6Kccn0J2cEG2iAMf0tqw23DJNM8a5ECi/EbKh
	UleL8oKUzVWWS78aU1O592ob2vtVaCDNEXBaZDt0ewxNcgQB3DkSG5S3s5vI32Ucuf70xa
	EE2/adEL5TAFK24ki35o7kpqsyGLf68=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 786D9A55375;
	Tue, 12 Aug 2025 04:24:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB3DC4CEF0;
	Tue, 12 Aug 2025 04:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754972664;
	bh=O9P/G1Ih8tTVtSV9YFM4J40omVsN3/KHtihc36JdYbw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ORehQ+3Vxi69JooCCz4dg6o18FXa76u+r2DI44fok7luCDFxQFkUwP2U+B14cLtiU
	 jqyCJozhGoRtoMTZAiYEzJsTclsr+B4e0qb4b4Y1TzVpAGVVLfMELVz2xNfDazjlQl
	 +zsRFjh3ArCm4dxlxPi/06cR5uqhLDUfhKVQQJTY=
Date: Mon, 11 Aug 2025 21:24:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song
 <baohua@kernel.org>, "Huang, Ying" <ying.huang@linux.alibaba.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/swapfile.c: introduce function
 alloc_swap_scan_list()
Message-Id: <20250811212423.5667183e69c373c1daf95ecc@linux-foundation.org>
In-Reply-To: <CAMgjq7DnniGUdpQQA0YF+LuMuL9+FCLQJP2Q04G_Hsd1sztv9A@mail.gmail.com>
References: <20250808-swap-scan-list-v2-1-d50e4758ecee@kernel.org>
	<CAMgjq7DnniGUdpQQA0YF+LuMuL9+FCLQJP2Q04G_Hsd1sztv9A@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2FC2240002
X-Rspamd-Server: rspam06
X-Stat-Signature: ujkyrrfqpif3b7mqeh3mifaxztqwc4w4
X-HE-Tag: 1754972665-488550
X-HE-Meta: U2FsdGVkX1/uoqrJROX3yqfy+DmmvsA7uXsEfzx9XREaP6UKjtVtWiLhV/78yMGKp5NjS/POhpiSj3rq4s8K6+AoRa1UaOaTkUNlkAjLEXIvr64zyo35K2h9dqvu22H6KMKq1jyCUbm9F3y8zzdDJ8vhDLo8PnTbzGX80YgKV3c3yzzQosXCIJ6ciUYXl/H/WRie9xOyGUue30lk2KmfISP8+AtzVIPnpsP4Aya3TcEwsBheo/DnBkXMBaWZxNeykbbLPw5T9Ea5tn02yyDmisYVoyKJ1UMkmg4mCecb6sgwMXTECrrimmhznTO4ss82wEWRQyCsjx5n6M9f5TgQTvanIOr+TzPNRgNJ1p207ZxI/cLDRYA82O5NWyTDQUwnIeEILyowabBLVngeewmaJzm9B8/DfirC1RYQjTNgpt6KefOlibPYcr18Q8RR2EQdQYbYqZi85/+v21ig0xL/JWLz6qGa01gtAV+/i9tlsPlEi4VFSJuSvrYfEjxFVuiqCkTzazk1yZG5GFVmLBhbjgD6u5EOoJCaHS7rWV/TfReG5CzusSCAZjirDp/cxlM2Xnd05P9rZYMJ1PzsdeXtAnRuhR/pmzzO3HR8VFICQiQj7Piqf07JhZPtwU4rcD38GJoNocUP3TH83fppGXlH4QJSLuaxdFckHvY8fYA2YuZAjjEsM7rveXEvBrEOEmxTZ45x8EAa3LGOwWr3oXRz5JQhosLbP3BvS3vqiUF8arRw4PmtcNJ7RDdi0PAhHMiAdDLAIT/7Qz0M18siKwogVlejMNukJ4OiyNUv00TtVnnYRKnCOndSRGo/oCnMvqVD0CBauIR4/2472YF3nMe8/CxR2A1zd5AtSaHR1i5LJTg0KU0P3YAcB+nHdgrdSUyD+rtgeFY65XtaF3W0m3eiQRUhFvkQIRf+jktCNsPOjGL3Oo15TiJX+K6913DFarGibP8mGDKSZ/MoONdYLle
 iI9OeMm3
 xbPoFwj19TxwjVDIuXCprOruRA4cVzOHiESQH3qIIrzZA6jSIFSmDLQwXPhAvaUJbubX7erroSbUfnvlStY4kr2xhseC1OCVYd4zMzF6N3dPdbLCUCsjRK7b2Pnns6XZuB/iKUlv4WaL68TzgfFKRZkdufLZ1jI3Hsvg38m/ib9/aWGVJmsqkTM+M55hGtXcvSUPMg/R2z7sIAcOSwTU9vxwm/u3Tv2iyNplkkRCoWhDTmHMlS1J+IRnf4Mw3FENXVmdXsbRA5pYUsM/1QbzHwClp0jO0JHSuHXE2ZWvI8JJMWStJnJhf6H/w/wte8E/gblUL9nTZCPWfB+oKeXIGBkc48JEq5HnBxiT6DXfMhN9LGts6/N2/6hNoxI43WR2ZE9IsZ7EIltx/QbU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 9 Aug 2025 03:51:48 +0800 Kairui Song <ryncsn@gmail.com> wrote:

> On Fri, Aug 8, 2025 at 3:48 PM Chris Li <chrisl@kernel.org> wrote:
> >
> > This the alloc_swap_scan_list() will scan the whole list or the first
> > cluster.
> 
> Hi Chris,
> 
> This sentence reads strange to me, but English is not my native
> language so I'm not very sure about it.

Yes, I rewrote this to


: alloc_swap_scan_list() will scan the whole list or the first cluster.
: 
: This reduces the repeat patterns of isolating a cluster then scanning that
: cluster.  As a result, cluster_alloc_swap_entry() is shorter and
: shallower.
: 
: No functional change.

Which is hopefully accurate.


LLMs do an awesome job of doing this, although one should carefully
review the output.  Here's gemini.google.com:

: alloc_swap_scan_list() now scans either the entire list or just the
: first cluster.  This change eliminates the repetitive pattern of
: isolating and then scanning a cluster.  As a result, the function
: cluster_alloc_swap_entry() is now shorter and less complex.  There are
: no functional changes to the code's behavior.

