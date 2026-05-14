Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D400CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:07:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E209D6B0092; Thu, 14 May 2026 10:07:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD01F6B0093; Thu, 14 May 2026 10:07:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C983E6B0095; Thu, 14 May 2026 10:07:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B857F6B0092
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:07:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3D9161C0482
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:07:54 +0000 (UTC)
X-FDA: 84766204068.19.CD15023
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6098FA000A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:07:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gsqxgFSF;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778767672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uzkmFh1ZQqsmfN+ZQzPcPofqB0NQiVM+nge3NejXpRM=;
	b=2IG7GbQabBZV5XXHQk7ouPEUgFvRiw1wtiGUUsGF1pE25/rAvZeYEo8z4SiU94WJvaTC3O
	qdaxZev+UDTlv6KHyyF6wFtNrTLGTn9Anxuy6TaaLrGrTx0Xy4oPl8KrBNoyCs0w7Mu+j0
	01ymD2hD/MfZOz+EOBRIQNA5OpmWKJU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gsqxgFSF;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778767672; a=rsa-sha256;
	cv=none;
	b=wciqdbMRBpyh+qXprR5obD56zd0lpNP6Im48xKZxI9YX0Pw6zeqL+NIT0gqS3YJ54tFdSB
	aOqfP8Z+61Cg63GythNzNcix3s9TWzRw+1ErnBnv9wT277cqhc1GxSSN1tRWVFEHTHrtWW
	ydzmWycfi/6rcpSYQyBifBMwApt4HzA=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-911796e9885so27375385a.0
        for <linux-mm@kvack.org>; Thu, 14 May 2026 07:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778767671; x=1779372471; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uzkmFh1ZQqsmfN+ZQzPcPofqB0NQiVM+nge3NejXpRM=;
        b=gsqxgFSFG/5H7o8galCCF06j3j7qZeOIelQf3XJNqPvBHCiAbloI8H/v1DS+3u6qpn
         OZMDqg/Nklm8IZsdx5pOCfk+rvvVW+VzYLpeyinf8IyiN0ofdFgmxClBuM1vrH6JN8eM
         QkQujFXGRbBmxATxGbJmyY5ZKA3BFpMAXaYpju2WDxcGpCqSgOarG+91p9WT/AI8eh8B
         fjqL3CyWaUHl8F/GXVJ0I7S+QK2YO4/gcJJN5RymJ+U2eQ0xsinjv5cioZgdveaR+/r9
         suKdIHtfn3rFsd2QieYTlYcvOOkMdR2moRLqijnGpHhqMU8qmbj6XJOYT+O8LKqL0az7
         lb+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778767671; x=1779372471;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uzkmFh1ZQqsmfN+ZQzPcPofqB0NQiVM+nge3NejXpRM=;
        b=XRCnGvWFfn/GOMPP/oN37fLLh7cmCS/e1IiJdaTBOaBpLx6e2zjwBHDhHk+gEC7l0c
         mCvmIFqIM3hhGU6Mkfzuvsv2lrqrsJE2BRX0HD7zg7Dwai7tdhg/kCUXkTRSpTLZBDLk
         Y1SN1J/RLYBAmgzdwCAgH4ESyD+0k9A+D1zMqTZCIC7aIHttP8XAdvjFFmtWwe4jtMZS
         ettmDbwL82d5hPJarpShiyDp9qAAxq8aAOxRdBHt2mWzity07FrvI1hBqQnnTi+NCUHt
         q+XLBhndVglgjzkMOYGWtMfv39TSFB1BqydJC/kvM7wCZb/pBZNkOpIg1zcnonpr5744
         Yo0g==
X-Forwarded-Encrypted: i=1; AFNElJ8gcC9lEIhb1f5JsH0WJ+idEU4xzZTo+yQw7mjLCHwOHY7IFl4BAtPV5PMACKatrGJuDW3ckbx0MA==@kvack.org
X-Gm-Message-State: AOJu0YxPpFY9CVr1NRE8Lz9S68IhYxxskf/+6gEcv4PaIe8VFAxSSdlV
	V/TP3TABOo1QNBBrHbFsFyxRZbFQr3/tWKZt0pDo7xAHdxI5Vy24cceObNG/XHC8BIo=
X-Gm-Gg: Acq92OF2OGB4ujvlzKiUwfgRoCsQQmE1/aMicqgZCiE2bzNaONUzbr6o2HY1IYT7OCT
	A8WwTEAkFzCyIRi+PQTKPlzr40SdCULKgge99/S8AULJW91Wv3AJfXzRjeyOCS7IvFwIE+vQabJ
	x4lykYhLUZ/YhOVwAEYD0vHfdte/IjNGNxYz2XAeVQO3EUc7RZLoI4KxaLLuycMn7rUB2ZID5uV
	+j1wAYJ8W4ohKSmRQKT05URgxIEEswLkaZsP4VeRJ0Nptht51ndAkz39SCg3sLpIpvC4AFVHUDG
	/qX3FH76T1hwx+fmrjAIFuVR7PEaf16iy1UAaLx4Gfl74MVplVfg4+WE79h+3rB34v70c0mvOQR
	lBMyniO6HIyE1k4LJ+3djFpJ8D7C2yhXQEYmNVVrjaT/NY2Fx/lqpYgAApv6N1Tjn5pYBLiwy+6
	rY2O8qtCMA7/ErOIQFtZQoWsgL5X0RvckMHUNdntObGrcM7dEEtqijix1qf/Qet2UThm7/0twD4
	DJi5UEmRd3Q
X-Received: by 2002:a05:620a:4809:b0:8ee:b817:9a03 with SMTP id af79cd13be357-910af5599c8mr528786685a.9.1778767671219;
        Thu, 14 May 2026 07:07:51 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bae27359sm271238485a.17.2026.05.14.07.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 07:07:50 -0700 (PDT)
Date: Thu, 14 May 2026 10:07:48 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v7 18/31] mm: memfd: skip zeroing for zeroed hugetlb pool
 pages
Message-ID: <agXXNJNR9CV_dlwl@gourry-fedora-PF4VCD3F>
References: <cover.1778616612.git.mst@redhat.com>
 <0ec51a9091b5ed3f61a49935953dd537d6c87428.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ec51a9091b5ed3f61a49935953dd537d6c87428.1778616612.git.mst@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6098FA000A
X-Stat-Signature: nh4cjn5uyotadyzeu9dsonubmy564fw5
X-HE-Tag: 1778767672-232237
X-HE-Meta: U2FsdGVkX1+on1CHYkAf9+z4tr8x5UEnXttcECImr8vedYZWbtnND1gnT11DhlHRG5IZbVzhFgX3YMK77sitUMzOIc19uPfW+CXRQy3RL+e8J9Ga8UQUZ/aiIdhakZNOzNgd9VteI0WsneO6k8TaZG7twZVdF3o5cliWQDnK/HVNjyVhJIphg6N+8CiUcAhqNRGnR0UDQaWQCjFWEg+3Rjd1tD0Oa/FA8WtSD+2IWfadXjG265r/G8ENvXMITzWD9VCxzJQrCbRgRT6HMC7CCF0kfY9yIcvMEdFpuSwRWWo7enx6SDT3nz335UgcPwqYOjhSECmusGLrtNwSSFjl4dCnsADw0tdpTKLFcooueQ3EAL8XqMahDq89cvTg0D4yamLAg/bvTsLpbS06s/8NqZCn1SMxbkTKKTL5lweVO9kM8HhTA/GIYDdh9OrrqJVfbCP9jUrc3Zfd9mhfRP9dy02UA301PvUgGibs/tI5xIAc/SgkPs+KZK/CwaNBk5kaM71H91E0rUio3TCAE5Mx68WRLZ0XkjWZVFNhoXPSc59BZ/vHC8bcapgouI68Hf96b8AJeWPvvE3SYnGFVXqxGBTbLtGz9EO9paMenkvLraO5y4fDRpqUf5oF4CBtNBMzqZnniwElk9sTlp5CBFrSR4e2TnBxuZq4y7XiM1mdzvCuzKGWiOlDb4KyUmuT+7+xthU+rgeApLyggXEo5TBJpEGeInhW5ccZn6ntejFXuGTIDkmmuOZY8h+BaAlqjLppQS71EaQpa5x55r7LkCdyztn3ENH7pTcLUyrDKT4C0efyffrrxA2b3nrGyVjB+MSVXeaexquW9hA1ebumRruEUhUO5z83BS6aQcRGUxF1zPRDQRHLHXK/AEtE0Mn3rLgiIXy1WWP/1RKFBRuWj/OJF0w3XN9DDd62+7oljlxh6dNJgwnj66u7XnMTpi1F5kInKpa0Y3qhO0t9Wxk+nK0
 ZjlRwGUR
 hJabZ6Sy/RSRy1HrAq4FyseKONnbPm3zYhXYZRbtqpuFd4A0OHB5lnXheOkNG8N9Oa6HzhoMgl6uRdpQl6cRH9EIBGUf4I+hsEbUhkxajXx1Y2B+eDq243RnXNRFEm7ipqGnp8w4s26GSPkoTF8nfA3Matc8iAB799x/HwtpzB7Z/jKB1gEqd45tZVA7R5WAjNQqgnQiS4A72TLV1HtwtPaVEd/nXI3dFzdZNespBp3kDsMk3JQOUjZQcvHLjKxl3/srMKMHgm68kdIKg6HhiT9e5VOK1hIThq7KInl0maEiE2U3+RznMTfF1r7Lh+rc1VOQxxNn92yIPe+KWEDvOBzJz4D3numlEZU8uR41DPM4LughEPM3wLhv+5Dj4bx/009ahua5VNyxWLkrmUKik0FXnvUM1Wi/4iDOUKiuJPf7z3vXNOk8vLJrlNrldzj4affPvHu1gUbfga14/PQUdkbx0K/6t7W8C2aa32DOi3vF0jhro2+Q9t6SVL95WR617qrY6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 05:06:43PM -0400, Michael S. Tsirkin wrote:
> gather_surplus_pages() pre-allocates hugetlb pages into the pool
> during mmap.  Pass __GFP_ZERO so these pages are zeroed by the
> buddy allocator, and HPG_zeroed is set by alloc_surplus_hugetlb_folio.
> 
> Add bool *zeroed output to alloc_hugetlb_folio_reserve() so
> callers can check whether the pool page is known-zero.  memfd's
> memfd_alloc_folio() uses this to skip the explicit folio_zero_user()
> when the page is already zero.
> 
> This avoids redundant zeroing for memfd hugetlb pages that were
> pre-allocated into the pool and never mapped to userspace.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6
> ---
>  include/linux/hugetlb.h |  6 ++++--
>  mm/hugetlb.c            | 11 +++++++++--
>  mm/memfd.c              | 14 ++++++++------
>  3 files changed, 21 insertions(+), 10 deletions(-)
> 
... snip ...
> @@ -2221,6 +2221,12 @@ struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
>  		h->resv_huge_pages--;
>  
>  	spin_unlock_irq(&hugetlb_lock);
> +
> +	if (zeroed && folio) {
> +		*zeroed = folio_test_hugetlb_zeroed(folio);
> +		folio_clear_hugetlb_zeroed(folio);
> +	}
> +
>  	return folio;
>  }

Hmmm...

if the intent is to simply communicate to the next function up whether
the folio has been zeroed just so that function can zero it - does it
make sense instead to just zero it in this function instead?

Also the only user is memfd, and that appears to always want the folio
zeroed, so i think it simplifies this entire patch to:

struct folio* alloc_hugetlb_folio_reserve() {
... 
    if (folio && !folio_test_hugetlb_zeroed(folio))
        folio_zero_user(folio, 0);
    else if (folio)
        folio_clear_hugetlb_zeroed(folio);
    return folio;
...
}

with no API changes

~Gregory

