Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DB6FCA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 10:48:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74B798E0001; Tue,  9 Sep 2025 06:48:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FBDC6B0028; Tue,  9 Sep 2025 06:48:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C4558E0001; Tue,  9 Sep 2025 06:48:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 441C96B000E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 06:48:09 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E31D38661C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:48:08 +0000 (UTC)
X-FDA: 83869387056.16.1EAC154
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf18.hostedemail.com (Postfix) with ESMTP id D292E1C000E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:48:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="I RjGDNL";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=LJWV1kGW;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757414887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rNoH5fa/opO+WTmOJxSo7bt81WHvwxJBdsDyJBfGjpI=;
	b=FTMPnxRMrCB6xrGh5YNGa76HYyKQRx0qXlyGmg7SUrXwJLECBVXJSK/ufoGe1vcp0/2G1Y
	i/HJRY9r8Rf42rbqW4WNd4mVd4DfUUh6PSn6ZrkkvopvomYlzbsArE098IMjUve5qM/4xY
	MXrI8Q7uPO034IvgkSnRZ24KVtwZYEY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757414887; a=rsa-sha256;
	cv=none;
	b=heGrhL5CABS3yYIwRJwVRN0IVGNCSpxQuU0SyU60CfEzN6ppGmNk9Bvy7AbeXIDjHp0X60
	LbWS+Oj4rp8HP5ClvjvsRK2VI1sT6sIDdMSrqIQc/7FrdltOrgUB7LEoNs+7p2OvwTrYyA
	Jx3jE5BnES+Bu8CUzQ6jpIhvNUiv1Qc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="I RjGDNL";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=LJWV1kGW;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.stl.internal (Postfix) with ESMTP id ACC591300944;
	Tue,  9 Sep 2025 06:48:04 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Tue, 09 Sep 2025 06:48:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1757414884; x=
	1757422084; bh=rNoH5fa/opO+WTmOJxSo7bt81WHvwxJBdsDyJBfGjpI=; b=I
	RjGDNLB/RvSdGLCqb3j+4cvPg9x83RzGw4YfoxuMzxhnbrV5imieTZMRic/GszNq
	Gu1964qdV57thuLyTgetKVQ6HJxfgbEv3UMuC8h1Vs5Nt90xP40FkdLIKQt+TRSp
	OYv2f72B7OeOpQYN+QG4Wd/KEL5IM3wD9lkLeXFTuRyr6J0Fok88qUdapRzRceiT
	YNzXr9PBg1acj5d0jXVsxbYQHtEKmc7Yxw0ZbKZOj3aTebd22IAoYD0UXdgPCLqN
	OQFcTJubPTv7lbquF065Wsmup36e4D+UU/96S4PbUuQ72h2MkHT2UtHrAIGuDZ4d
	6i8Sv+W1IjotUYlCk/yEg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1757414884; x=1757422084; bh=rNoH5fa/opO+WTmOJxSo7bt81WHvwxJBdsD
	yJBfGjpI=; b=LJWV1kGWhYibguXeTgcDjb+fFkP+m0K8wKlA9or7VmvDoMIFxoU
	aCi3tx2mmkmTX1mshqZhRyc/y0EzH548Pbv17VCsDn4IFXRfieq+0hq/+v39Ha1z
	oCzYQYQjv9GVs9zhQsRQYC22h8EdxHwHxeJfbj/zRJGMEY7iE5FPTKzF5A8jDL0S
	8RNjlNxSOopw+S74tESDKvmiXz/oDtBEGaavl+C2TLcbhOVq0+P+4B7+ILMLWkwS
	G7cIwVinr89cH9O2yiviIAKP6Din/4IxBzCHg2vs0FMg7MmBmGpQVeJq/sYruYuf
	arWXSeIvpeMGwcBul3FDWtvlMW7y+FPwmzw==
X-ME-Sender: <xms:4wXAaIcOxZi6MXDqaZPIMlJR5zG4ACk08EQzc-U3BBu5BW46SgISZg>
    <xme:4wXAaK7gX7yfoqo-9U4Azoba1S2mciOcfJKCZT-72w3ZI84zOzS6KTbZSMEYs2OiU
    Yc63AndtE-CqI5bBB0>
X-ME-Received: <xmr:4wXAaODP57_RB-SuXqQxv_XDLB54bYX1E6XbwE0Ue-2JhJe7zYqklBZn42zgXQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvtddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeegfeehleevvdetffeluefftdffledvgfetheegieevtefgfefhieej
    heevkeeigeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlsehshhhuthgvmhho
    vhdrnhgrmhgvpdhnsggprhgtphhtthhopeehgedpmhhouggvpehsmhhtphhouhhtpdhrtg
    hpthhtohephhhughhhugesghhoohhglhgvrdgtohhmpdhrtghpthhtoheprghkphhmsehl
    ihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopegrlhgvgigrnhguvg
    hrrdhkrhgrsghlvghrsehkuhhkrgdrtghomhdprhgtphhtthhopegrnhgvvghshhdrkhhu
    mhgrrheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprgigvghlrhgrshhmuhhsshgvnh
    esghhoohhglhgvrdgtohhmpdhrtghpthhtoheptghhrhhishhlsehkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopehhtghhsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepug
    grvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtohepfhhmrgihlhgvsehgohhoghhl
    vgdrtghomh
X-ME-Proxy: <xmx:4wXAaOdLSe-xaKiD5TO0AqzQ9XC39lKIU-xgGJla6Y30gOXlvP5hAg>
    <xmx:4wXAaLTmnw6yxOwdmb84zM7NERF65vJI1kb3Cp1Mc5Jc0oZtvBhU1Q>
    <xmx:4wXAaNkWZ5wi5tbkrHF-riz_nNfw22LQY6lAtojPGT-2SVrn_1Hj2A>
    <xmx:4wXAaPbwvxo-jaFdVewfjDSZGvsVouF90dv5sf2ZfI9XDq4NP6Vupw>
    <xmx:5AXAaDy7XY-XTU-fy23f5joErztRzUXdTLdiBZeqv2mg0pnGDXgjwb6E>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 9 Sep 2025 06:48:02 -0400 (EDT)
Date: Tue, 9 Sep 2025 11:48:00 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Alexander Krabler <Alexander.Krabler@kuka.com>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Chris Li <chrisl@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, David Hildenbrand <david@redhat.com>, 
	Frederick Mayle <fmayle@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>, 
	Keir Fraser <keirf@google.com>, Konstantin Khlebnikov <koct9i@gmail.com>, 
	Li Zhe <lizhe.67@bytedance.com>, Matthew Wilcox <willy@infradead.org>, 
	Peter Xu <peterx@redhat.com>, Rik van Riel <riel@surriel.com>, Shivank Garg <shivankg@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>, 
	yangge <yangge1116@126.com>, Yuanchu Xie <yuanchu@google.com>, Yu Zhao <yuzhao@google.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/6] mm/gup: check ref_count instead of lru before
 migration
Message-ID: <qsaofruq3r6ffvcutn4rx23rhgc6dg42t6yvnmwpimqk3loz56@d3j24wa3hho7>
References: <41395944-b0e3-c3ac-d648-8ddd70451d28@google.com>
 <bd1f314a-fca1-8f19-cac0-b936c9614557@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd1f314a-fca1-8f19-cac0-b936c9614557@google.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D292E1C000E
X-Stat-Signature: zh6ctum3cocx6rqq354epxp7nehefqzh
X-Rspam-User: 
X-HE-Tag: 1757414886-475886
X-HE-Meta: U2FsdGVkX18zrSYdcEm8PEn0W4+l8AS5OaO7hbxBjZ0XqF+t8xHwL2IFvs+GJk7dLVFOz/dAPd/3UpbfhZXWz22Rp0n/lrDFxNUiSPihmJvY3D11T7XkjAjbf9eCRHpP9NDY1fcR8VRycPKZ0qSyC4G+bVduROUDvA9aGyFVlWwcRzcUaQ6WUOo3jb1c0HaYnbl5Xqe6fPk0VoH7Eu3jmy/A+/hELeuHrPDiiK2+uKz88RH+QgP3MNf5Ij8bnlfAc3CQWEYRwOsFiWhBcP3dCmz7ivZ2nKThN60NK2SGMaR700dWV1eR742jIaue2mdUZ/WsNjDbzSvX5WKzPU0Tzbn+qsAvzUjgCBSYXYDw4iDwx4qKqw2TP3/tuyFIc73NQI1fx5hmlH2LXPUgpF1N3+KdfZ7Q/ug5Im6r0nKmrsVgVaPQO0US5vYg3uQ01O8HHDlWSZaJm8d3o4BUcZHj0TrpGqWmgS5EsEUQgoAdR+G5jOZT1Yo9vQZj1GMGqQDmWq0/XvnzHc7FH+CVA2guNB/J0VPOqsFik2zGloxGmebJM1yAeIJ3wRyPHZghznMRRUP1FtIo89Rkz0yoDOMtdlcfBce9XKJ2rmJkmhgQFbNfcQZnKwHF78v5z2pyJRSgpqZSPEhQZH7Goz69ohMc1FM+yL7pPUKWaCn2J5BJL1qhEaste79qv2Xo0lK65PCq7x8TGprgK8pXFiNTIGY/yh4H7r6J4natfBtWYWIGqWc3DfnN5zp+BaeRGPp04riAOrVGkSJGxPwVdTi7DfhVLYfciklo4j8z5g5/YgMziq0T64gyZCmgr0YAFHBOIlz95F7FLfKa0bg5ZGqchb4h4xg38pC2z8a9lkU06RDiuDXl5aeowrfPEh6CcUcFv2f25M4TWIOuf6swenZCx3DgUMfbHRsrYiKnNloF3V8FsIjgHGVdvnJlIcOaa5oAU9dwbs2yz3WKZc+5h+qRVBP
 KeJyIDdT
 y0ra+Gbtm3z9kkFOUbxfDzdaPeenvmpYz15Yswo7p88g0kNYN8WmVPRxPEf9Zw1I56eOUa1z88gWwsFVXcmueK/eUwSQNtYI3iLOFFcRNX284XIpBZ1lxkoOddZx90+etkjg1OkECW7U+Uj57OiDPIk4F7iwbZoGtvlEL+FbN/UCUkfBFfyno4c0kJni7BtjrMe20JgmzYCdPPE0zPO6P8tD5P+TKD+jQUjZaBvUgdKeG+PRqcgpotgdKPmJsYgF3cYnAi5bb7R/m5C9NPEIPDwfpIwAxO9J7vSNNaHn7WdJn+kX/ZtYsfCwucgDA1z5+1DIPWOO6NhtvWxkz85f5IOq66c8oQXh6/S5FUlH9uLaKXBW5QNBDCaQ9EZE+igeGyLMtSFGcRaj5ReuBCe6TrhOPo/OmbuzIJNR48LYg/C32ch5wb5zSkctRYLxSTr0mppG95eNxw8v33XcG0NrWK3MPXD2TmoyleS8aTUMtjbl8NsVLRFVF9Jcmdw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 03:15:03PM -0700, Hugh Dickins wrote:
> Will Deacon reports:-
> 
> When taking a longterm GUP pin via pin_user_pages(),
> __gup_longterm_locked() tries to migrate target folios that should not
> be longterm pinned, for example because they reside in a CMA region or
> movable zone. This is done by first pinning all of the target folios
> anyway, collecting all of the longterm-unpinnable target folios into a
> list, dropping the pins that were just taken and finally handing the
> list off to migrate_pages() for the actual migration.
> 
> It is critically important that no unexpected references are held on the
> folios being migrated, otherwise the migration will fail and
> pin_user_pages() will return -ENOMEM to its caller. Unfortunately, it is
> relatively easy to observe migration failures when running pKVM (which
> uses pin_user_pages() on crosvm's virtual address space to resolve
> stage-2 page faults from the guest) on a 6.15-based Pixel 6 device and
> this results in the VM terminating prematurely.
> 
> In the failure case, 'crosvm' has called mlock(MLOCK_ONFAULT) on its
> mapping of guest memory prior to the pinning. Subsequently, when
> pin_user_pages() walks the page-table, the relevant 'pte' is not
> present and so the faulting logic allocates a new folio, mlocks it
> with mlock_folio() and maps it in the page-table.
> 
> Since commit 2fbb0c10d1e8 ("mm/munlock: mlock_page() munlock_page()
> batch by pagevec"), mlock/munlock operations on a folio (formerly page),
> are deferred. For example, mlock_folio() takes an additional reference
> on the target folio before placing it into a per-cpu 'folio_batch' for
> later processing by mlock_folio_batch(), which drops the refcount once
> the operation is complete. Processing of the batches is coupled with
> the LRU batch logic and can be forcefully drained with
> lru_add_drain_all() but as long as a folio remains unprocessed on the
> batch, its refcount will be elevated.
> 
> This deferred batching therefore interacts poorly with the pKVM pinning
> scenario as we can find ourselves in a situation where the migration
> code fails to migrate a folio due to the elevated refcount from the
> pending mlock operation.
> 
> Hugh Dickins adds:-
> 
> !folio_test_lru() has never been a very reliable way to tell if an
> lru_add_drain_all() is worth calling, to remove LRU cache references
> to make the folio migratable: the LRU flag may be set even while the
> folio is held with an extra reference in a per-CPU LRU cache.
> 
> 5.18 commit 2fbb0c10d1e8 may have made it more unreliable.  Then 6.11
> commit 33dfe9204f29 ("mm/gup: clear the LRU flag of a page before adding
> to LRU batch") tried to make it reliable, by moving LRU flag clearing;
> but missed the mlock/munlock batches, so still unreliable as reported.
> 
> And it turns out to be difficult to extend 33dfe9204f29's LRU flag
> clearing to the mlock/munlock batches: if they do benefit from batching,
> mlock/munlock cannot be so effective when easily suppressed while !LRU.
> 
> Instead, switch to an expected ref_count check, which was more reliable
> all along: some more false positives (unhelpful drains) than before, and
> never a guarantee that the folio will prove migratable, but better.
> 
> Note on PG_private_2: ceph and nfs are still using the deprecated
> PG_private_2 flag, with the aid of netfs and filemap support functions.
> Although it is consistently matched by an increment of folio ref_count,
> folio_expected_ref_count() intentionally does not recognize it, and ceph
> folio migration currently depends on that for PG_private_2 folios to be
> rejected.  New references to the deprecated flag are discouraged, so do
> not add it into the collect_longterm_unpinnable_folios() calculation:
> but longterm pinning of transiently PG_private_2 ceph and nfs folios
> (an uncommon case) may invoke a redundant lru_add_drain_all().  And
> this makes easy the backport to earlier releases: up to and including
> 6.12, btrfs also used PG_private_2, but without a ref_count increment.
> 
> Note for stable backports: requires 6.16 commit 86ebd50224c0 ("mm:
> add folio_expected_ref_count() for reference count calculation").
> 
> Reported-by: Will Deacon <will@kernel.org>
> Closes: https://lore.kernel.org/linux-mm/20250815101858.24352-1-will@kernel.org/
> Fixes: 9a4e9f3b2d73 ("mm: update get_user_pages_longterm to migrate pages allocated from CMA region")
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: <stable@vger.kernel.org>

Acked-by: Kiryl Shutsemau <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

