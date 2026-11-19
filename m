Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D73E60A2605
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 00:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=jveJF1b7
Received: by kanga.kvack.org (Postfix)
	id 84B476B05FA; Wed, 18 Nov 2026 19:13:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 822B26B065E; Wed, 18 Nov 2026 19:13:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 710F86B060F; Wed, 18 Nov 2026 19:13:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 475716B065E
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:13:23 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C09EA808BF
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 00:13:22 +0000 (UTC)
X-FDA: 85449944244.28.36EEB9B
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id C4411C0008
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 00:13:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=jveJF1b7;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf22.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.51 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795047201;
	b=yhuIxYZzXKrXpIUj4wC4l7+5DUJO7bDR0k7edX8gk09HwAYZKbEpMtblDOSXNbFhYJLL7o
	NUn8sosQHJzncAOoOMhvMQRvb1102qF3AZcSXVYVXsW6o4o9Xxf/0Kzm3AWb7+QG/6/21P
	zMAJA3KA6O3lTYz5IdAHlXE8z0OyFt8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795047201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z+4T7HksHFh0HyOVyESymA8Z3DhRY0Y5VmPHJCOWPKw=;
	b=xY7kDvAy2WLa4QjBEvZOugj+74M/kNWyxJrndsVTnbvUEP0vC61b0T/FSeaGAqBop0M9Ed
	gtgd6B6h1TrTgF+vxAnQYHxRT9WM2Ed5Pl/o3SycRGYyDQfDuvDVNZW30W51UQsID1X9DC
	bMnAFBWI7OR6IBeHVtuOHeKiqvDVdrI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=jveJF1b7;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf22.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.51 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-679aeeddc6bso1483927d50.2
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:13:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1795047200; x=1795652000; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Z+4T7HksHFh0HyOVyESymA8Z3DhRY0Y5VmPHJCOWPKw=;
        b=jveJF1b7HYaLHgVNIq29s6mVxxCVXIQfWLiCkuh33P5mfRUPHXTV/i/W+FClw5iPNc
         sOZO0riLpgTRyUT3vEkE2pu3jn8x7ZqI5Z5mIKHlqchTuXc/MrsZzvq0F78SoO2Tdqbc
         9S/Iurlj5r26yNGIJNUqxjAgLT47jFB0wWcA5gV9dwPBDjvABFFlvuppgMOkgkIXhMwL
         11ytRST4qnruODaFxISGjfU2ou1Vu31sJ66F7+0MFUYaAxDAFixZi4iIG/f0ROFwY9Gq
         GZJFzOSv907ll8kuBS7DUkE7/V9Ebjnu2UnlTBJaag3S+M/DKi9zsf3Js8YtcV5c4WzJ
         xN5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795047200; x=1795652000;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z+4T7HksHFh0HyOVyESymA8Z3DhRY0Y5VmPHJCOWPKw=;
        b=tm82O7q9FJmKzlW1RIOWgu7AUw4xfa3SJgzIs/pTR/JD+Jqkt2mWr25kvQAgHVMjQd
         LAiHWG0ertpU9qCwNoVvQb0IEqUgpihik04XVcK53Or847qJwk0HRgokhfSSJA7txr0w
         K6Q173LI4tNHyaMHdziOOec56lPdVwW+IJDVpnIBQCBoKX7/RnOroCvtbWeUb7Nskj/+
         w/ZtKcPJXC5dHVAGLp9SntpfzMSLJGI1vo7ojHMPYC7UkJpeIf0U0Wq/nDYZphRSOSne
         rrrsEYeQEK88VBmzF8hd2bF+VJxLBfnbMNQz99Hq6RY79NaHDf6Ptm0DGG/rLb8x2FSX
         qxVw==
X-Forwarded-Encrypted: i=1; AL+hErEw9MJNLE/wGQWNu4K5Jip9yIXEKZuepT2iF9G1zSYiXZME1PtMbVIVEVfnm5dsSYddmon7tKvZ1A==@kvack.org
X-Gm-Message-State: APuU4Z+XNamShFBuv8dOYb0bIei2wrfSmcGRWg/DRGMnV2wb2urlg3at
	4y+7vUnVwjqY8WnYgSZNMwiPRuU0mt8m3tChGA7N2ds8xcNDrBqtwi2qkYYOgYeiTx8=
X-Gm-Gg: AZFdTZdDatXNmr1nRPk++zuPerrsKsrw5n9PuIhQggZ8uu64UixxqrMVZ/rfxLdzfyf
	eaKoQn0iziVIkMWdvDEzJQLYRQ1UMsXaL6TbMsc0lAQsjZ4PC53Fmp4DfxbEKAr4xTOy1q8Jq+x
	w4QLrjmE0fW2vS94nbLyHnFy13Ur2hUf90DDfkRN1zWw0lleKp2ZePOkr7bz+ATFpsNnINngnFN
	tSWza5kYf5CM0jYprFUIdEoPGHNibqXtR6Tz45wDnPsKvxfNW7t8SF/ZMnAl64BvE/5XuVDPdH0
	wL7u5OvF30ppKfdeD/EQajHBaNrG43zfYtuWPH8OV7zGQT5v2CcuEHDQ/nnQaYuSle8zeicE+L8
	8Aelon4I2TC+H3gi6vKbfr47DE8pv4QHr7tb4jIorxEv15PMOSu1TtM6ubmrlIagCtIG9Ac2od8
	1bmKxwRTzCkg/PbfN2XKC3B+LqU8lL4qVAHOgxShrfPUdp/XXlUm9fyEOO0rqasYOfyg7HD9G4S
	JPZIx5atObWV+na9hy3yXEKB1Oco6B6JgoXAbDFoKpQQ2QLXYFYasr4rgXIgIaF9kZrZNU1UnH5
	vdfQU7egq3viscVjpIC8sb6NZp7d
X-Received: by 2002:a53:d005:0:b0:67c:6e1b:84d2 with SMTP id 956f58d0204a3-67dd460a10amr1474859d50.101.1795047199791;
        Wed, 18 Nov 2026 16:13:19 -0800 (PST)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67dd5843177sm2483921d50.5.2026.11.18.16.13.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 16:13:19 -0800 (PST)
Date: Wed, 18 Nov 2026 19:13:18 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Cenk =?utf-8?Q?Y=C4=B1lmaz?= <cenk@deepfinresearch.com>,
	Zhang Peng <zippermonkey@icloud.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>, Mel Gorman <mgorman@suse.de>,
	Sasha Levin <sasha.levin@oracle.com>,
	Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>,
	Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/4] mm/vmscan: flush deferred writable TLB entries
 before unlocking the folio
Message-ID: <av4_Hkq1kNQUyIeI@cmpxchg.org>
References: <20261118-file_folio_flush-v1-0-e9e739ed14e0@kernel.org>
 <20261118-file_folio_flush-v1-2-e9e739ed14e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118-file_folio_flush-v1-2-e9e739ed14e0@kernel.org>
X-Rspam-User:
X-Rspamd-Server: rspam07
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C4411C0008
X-Stat-Signature: gp3waiexy47i5ds3w9pctcdfx1ypix5p
X-HE-Tag: 1795047200-892601
X-HE-Meta: U2FsdGVkX1/UNGJb2YFZ8BPBcxaL0HN2MZiY/kgjc2EOal7oIJ+SzxECAQlizc++ULHoqJwhcn2qLo+SD/q2tmciJt3PG4KgG0VqMUFMPoSNcnLezs2VawFWMTD+RuxrZJqSJ6mnaShJO7KG3f5lTAKvFhdV8IgdWZro3jiCRYa6HJPbpq3isWzcr8WqQ1+CmlBa7G+SbCKDgtf8tnc+cBvP8nxTmHKQxDExqQz7ZjI2XY5qn6bKTHxCpyy5dNZ6ARlqLC+EENYyEtmU30XfGzOF8LRwK5h2DchdE3s+h1e0BIsjVPTJje4X1OqW+/Kfa4fUiF2q3lASEPzOhoD4Jr+8fAjR/M4pMVSoeth+WnPxyUjfDiUeFGovdwvvBkFryu0AW9nHSs8brqxOYnwBlSA4gPvJzSKV0d+wOZT+QbmeKqR4oAoA3wB+ggw37kmPw0b3VmiEom9cYRFCIvj4oO2fiUJORx2c8kd3YUUYF0MbRTuG5c2jszrpR1OqP9/oIf4J/q8lkmAAvQWMxtpCrUUl0s4AQzEplyvV16qySgMOBIwVw3SE8AgNq0EBrYXuNljL48Gfj5ZEGrWpXOx16+sXlkj4KRz1+Gk1ivMQLofAS1UxdkA5YckE+LBnBZXNuisDOF3DFqr2bL4JrERPwtgspbEqV5thPRJvyXBvI47BZMMoVs/xqS2fryirx9V1JZ+tJ6GSzfkVfMOAXtUPaGRFcsalUL2QpEeqWhVoTY29Dj2tE2SlaSRJpA3CIS2uXqBmc0no5HhXRsf78j4pTjQYpyu9TlTC1nNAoE9AxJOsaqDdRZeO7Dpj35oOXBFyp/t+DJvuIjjxp1nmCnHXe2SEv/MQvdGLhbqHfACJLox7bIt3+fSF+V7yANvrtx+tN4gilna7A2ynZMqrIxa/0/9yYDxItBCkjHzDCf8c97WGbQU6WbCJF687z/8U/U8ryuTM0EpoXkVkdtuF0eu
 eAkgROsa
 kUaXrvjg/xtU42MtQgQsEHaNPm4KAbx4VjifgS44YsNfhSn5cW5JT/VdboI48RdbQ64e4dQVTyrM4tq7lfRZ1t+h1RaAAH2ekURVGgsAoXrlpBQs8HEfax7lh8uKUoTnk3MVcaRZiIQF9iLKoFvAJw2fIRAnLowuyu4m960Ej0Hg4mRgiPyWYL6+58XgkrIGaqg05L+2OvdUnQQGekOzmEEfLwY3LvjViSNS7RZPZ7H4R9Rx78+mPFGys0jnLXudkAiIKOFnjOfS/d+CMkRPvj+WWz4Sxnx2c9IGiZ8dc2MRwx3d9ncQNNlCCta8gKopzcbB/tB/PMwSy+s5m4jJwKJNKT8wuDuFWbv9BTBMTaMsMG/paBHKlvyaDCj+R1S3Z6y3zQ+QQmUePPk9A7d1Bi3ABDv7oKfyLUEai+CffeUQLRBH2KJF6XOiwzAmxoVV9ZWH2Ll7lxBWMX48ztwSaxoB/E01F4UKXMpUqr6aczw5D+KpLptcjhA/8o5nUp1HXgTfNZ4z1eiHdtTakxmx54Zq0msJspcl+Lma1dNYw3HEqObOFS/xFFsvIv48FYkBQIHIVsMG/NlDY2KPU2M4KujPmHSQ6QJu7isQP8Upo3CmgzKa7OyP5W6PLlwnkm2tOUtmeVLEFxSugL4dTEUUrw7izLyWT1ne5s87a7WbgOavlD/M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 10:20:37AM +0100, David Hildenbrand (Arm) wrote:
> try_to_unmap() with TTU_BATCH_FLUSH transfers the PTE dirty bit to the
> folio and defers the TLB flush.
> 
> Reclaim must flush the TLB before unlocking the folio, otherwise stale
> writable TLB entries might be left behind temporarily: writeback started
> by other mechanisms (e.g., fsync) will not find any mappings in
> folio_mkclean(), so it will neither write-protect nor flush anything.
> 
> A write through a stale TLB entry after the folio was cleaned gets lost
> once the folio is reclaimed.
> 
> However, reclaim currently does not flush the TLB if the now-dirty folio
> does not get written back (e.g., gets activated or kept instead). Fix it
> by flushing right after try_to_unmap() if the folio is dirty, which makes
> the existing flush before pageout() unnecessary.
> 
> For dirty page-cache folios that reclaim activates, we will now flush the
> TLB immediately after unmapping them instead of batching the flush, which
> is the right thing to do. Performance-wise, it shouldn't really matter
> much, because folios with dirty PTEs are usually young and reclaim won't
> even try to unmap them.
> 
> Fixes: d950c9477d51 ("mm: defer flush of writable TLB entries")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

