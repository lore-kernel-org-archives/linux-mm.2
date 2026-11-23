Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F546606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CAJGWU5M
Received: by kanga.kvack.org (Postfix)
	id 323CC6B05B7; Mon, 23 Nov 2026 04:24:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FB666B05B8; Mon, 23 Nov 2026 04:24:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 210F56B05B9; Mon, 23 Nov 2026 04:24:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 09CB66B05B7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:24:05 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 987C0A8336
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:24:04 +0000 (UTC)
X-FDA: 85465847208.07.A88D3B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0028120005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:24:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CAJGWU5M;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795425843;
	b=u9HBu4prXMBwVt/i9yGzOJvoAM6rLRwvFULb/d3VqM+P3S8YmL13vPT7bzyTEQGRyeIGM0
	PGISU44WC6RqEu9nAn1lyZVY4pfSQaAs64K30J9z4a0bhWlQ3FhIPhz0E2e6+4XyxruktE
	8TUmTxa4Y1NkM93ajFDPX4gx2l85C+s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795425843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4SASklNkTeizD/6hspIoB2DzJc2sRiMDkEkS/nt+fz8=;
	b=C3vx2rgv79GkwAZ/hJeINyAJKTBrWCH0I55PbdgNaGK5IR6gj+Jee88aamjxAPgfWqbmGR
	ONlgPEyXrxuNLnXvwICLR0qBeX0/IMt1EOPifg1e9Vqi2uuIat7vz1bulSPunxB4CHOvH7
	d+PwzDD+4p5ruXEjfvxrTSDjMDX2AHM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CAJGWU5M;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CA2AB41A1D;
	Mon, 23 Nov 2026 09:24:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B1A1F000C0;
	Mon, 23 Nov 2026 09:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795425841;
	bh=4SASklNkTeizD/6hspIoB2DzJc2sRiMDkEkS/nt+fz8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CAJGWU5Mj8DNCGd1IqPkhWlrCz1pUjiEUVbLxxl8HYLdf07aesjbLu6k6ye1cYht6
	 zqQNaVjbsjEsLR9fIJpDclLyDA/PGC71k4k+h5DwSKgZ+WDabaB5c94hiDmBxRHKKu
	 ViPVuJ5OmKU20U8yl/zGf1e+d01ycrVpkZSWbbC3+igRrCgr1xs+zWfaYSX0qpAth5
	 CmssC7VCkdqQu9RtjLKIFYQJPMvgX/1etsvL5ER4mXOEHnjqvsLL9mzHCqZnT6hRa+
	 Vsju3S8tZVm+BCSKj+ysWbq+bsgIqRKzbqRj3dlFP9TLGFG4blS4mZfGhtPpZOspQK
	 FK9nM5sJlBjPQ==
Date: Mon, 23 Nov 2026 10:23:54 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Li Zhe <lizhe.67@bytedance.com>, Andrew Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 03/11] mm/mm_init: simplify zone device page
 initialization
Message-ID: <awQGKjbQzKtuCgLO@localhost.localdomain>
References: <20261120100856.16929-1-songmuchun@bytedance.com>
 <20261120100856.16929-4-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120100856.16929-4-songmuchun@bytedance.com>
X-Stat-Signature: rk1fe4ntrncrghbxcx1n5bbu7upgspn4
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0028120005
X-HE-Tag: 1795425842-22559
X-HE-Meta: U2FsdGVkX1+vaG2i2tWrPIWz8BWKUhnqoLkFqbMMmSPC5BrMNBMT5VGMP+SmKtcUzptuinKMeww3SAjdlkRKBlOGgvjjMn1LVdXGcwJIjOusfnSX736dwzmR8UlT4wHtjS5WAy1Y5WVQ1T4705bF+Xs0pwS1dVHjVcdPHr2Zx9DlaiDDBjG3ngsfrTpU3sdSeySxxuowR6y/mLgdDyopfJ+50yPK/SNxBNrIH2I2A6cwx2H9hnqPrJdGjLm0cQdZ8Phu/UN/SBsy5PosfBaqXTb7zq3YF7jkrk+6lA/eOnxGK3+7qXp7YOs+icCq92dbsj36CqQTQfVr6axuLTNF51uPb8PsEqZC0EsPHY1LYMEq/uSlxnvvPfn5VnnOQ3sxZAWDH0n1PuZqRBHStVm2l9ZDbntCXtQ0JJ7es3vRCu5TI1nShu7yTWjnPwfx+34zBvvQjtyn6fcinG4Vs6SavvzlIumXGTPvNQWVekxWezxQgZiYBhD94SYIqtCMURmhZPwEOv4WT1tUZnhVOy2ofgkZzLD0dOFQ3xwuBARFynaWg3ez3Psd83C9J2D6oJ2vX0VX2mbOz+HbABVnSygjAbSWQWT8ugnSTOJzbCXTFPF9hbv9ZJkvdhLtehmqycwklAS21m+3NBT6sRcZKHaknACA2d6tsiYx8kKg7+qbrYB4gOhfRhpFhHNLZfDoM4d5kSX83DpDvJQgHc+yfdeTz2hMfAQz9hMcu52/l1ZJPnYZZMseNkRjJVmTCYPfyLsPD+uYC9t9gq1KI1B5kgBxTQPMzJVRSxJPAgg4MDS1FsEWIeeiFmZThmvCX5RWvUDVLqSgJ5EUbSr4qJP1PE+UsvWF2XmvmsJr7kGSOp0bmBE5lpib1iAmYxVz/YO6BGHPWdBACvqf4opKRS+Y/FurEGe0nks1QclVHQjenGCvyuWFaOEYVyAfT7Df3HZAHhwJpyUoNWeEVZe8V+61pOh
 KyfDzZkh
 n94AUP7Ri7Wq7zzUazxR2H0ZjQsGVIUz2lzNv51rvmHY3x/OizyGaRG+yuNv38zKk70qNrCj4qfO0IxyZqyDlzBu+5jYa8zfMoUVEQuGr8TeWosc4gs3rxzC2+hp3eIUo5SRnHOrusYjwK5NgE1mxKlYper7QqSo/G/BSay31PGFS2jRGuBKlTpjsHjdp+gZ3LvMiJDJtMKxaucTTb5dnhCrVVZ0sjriHxZVV2u/A46uTzHUV0UjJCbZf8TpT50D73hGq5RzVhZwh6TLW8L5oy8pZjJe+KMZgkUoZyfym9MdWpqkMeivw0ynbL5QJXd03AruopatT7K9gtMGnjGC97Zta2yUtiBlyf4g3YBqGIuVSqboDafXCR8pah9aE58Nf3dVXzEy3Nzssiy2JH+wF1oFp4oZyJNUrVIPHT9ewUJQTrZYcsDCyJ8MuAyLZ5QKVnqBDgeobU7EzXxeYqj1pV5CgNrOjhexw2bJwodq5otzQJEXli9j+uqQMBPTPmOhuPd4IJvddpdiMR1/lhxa6Uu3tswHN4qtlwo5O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 06:08:48PM +0800, Muchun Song wrote:
> memmap_init_zone_device() currently seeds its reusable head and tail
> templates by fully initializing the first real struct page and copying
> it back into a stack object. This keeps the first page outside the
> common loops and leaves __init_zone_device_page() only for template
> construction.
> 
> Build both templates directly from the PFN-independent state. Add the
> head-specific pgmap and refcount state to the head template and the
> compound metadata to the tail template, then initialize every page
> through zone_device_page_init_from_template().
> 
> This removes the special handling for the first head and tail pages
> without changing their final state.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

