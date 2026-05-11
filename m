Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20174CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:39:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C3956B0098; Mon, 11 May 2026 12:39:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89B226B0099; Mon, 11 May 2026 12:39:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B1E86B009B; Mon, 11 May 2026 12:39:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 68B536B0098
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:39:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 101251C00EE
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:39:25 +0000 (UTC)
X-FDA: 84755699490.04.FA1E7EA
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf15.hostedemail.com (Postfix) with ESMTP id 357A4A0009
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:39:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=r2EKR62m;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ic4BaUG28/kqkN2pOVPcrp/DL/iwy8HK3B1u3S3Yl0=;
	b=yI3hBVqay11114X7OFwWmLaUp//xMJikpPm/F/FLm7pVGs2YUrXu1InQpGd2Kx9+QUNIx6
	bbwUwn66f7uPicOjNscckouZwP3R/13r/hq2aek29BdHF2e5B8mluv+Dw3vbsy9vty7N+n
	n81OU0ogEUsVJIBU5ZceY7JtnxOVDFA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517563; a=rsa-sha256;
	cv=none;
	b=5Wg+NESUEAMYjJ7cOhnfvt29xg1MIgoSbTaCP7k4p5+N//TkWGpYCOBVvxTO0NNV+0xwIt
	at4DGYDB4I8LT0G8cHpKSVldzzKKwmIhLaV4BAy5JQWnvHMRYjhK6+IcA9uy4iEJulBDQe
	AaEUyT5Yz++YyhEH5rs8UWmLIFsFljw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=r2EKR62m;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-902deb2412fso488631085a.3
        for <linux-mm@kvack.org>; Mon, 11 May 2026 09:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778517562; x=1779122362; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5ic4BaUG28/kqkN2pOVPcrp/DL/iwy8HK3B1u3S3Yl0=;
        b=r2EKR62m4MC4m/RKRmFMgkrjqhpQ5eKbGAlQ3ueChO3ZEyy+o8dLG7htM4byfAMLTC
         8LRnVVj7HctP/lOiHQX34E4KrYSF1xVgbtCI0IMCr9ImxRaY9mDaN9xeSSTujCNZX8b+
         Dgr3J/aE7PjX6SkTasXo8S1xo9M9xJ2RjWUxeyvS1OyrG915K6QmvhFPsM+7fykE9S++
         FAFZaet9weEyEDpta/14aksKuY9FH1+armcAcS0aKPi+cQI5IEhFoJHESM7O7sCOl6ci
         TZVqf8S7xJVBV5JQ161R1ccYcvT7yK83asU2/Iz2fEolWnZTkXqfukVjBoPyrvBVahnV
         fUmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778517562; x=1779122362;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5ic4BaUG28/kqkN2pOVPcrp/DL/iwy8HK3B1u3S3Yl0=;
        b=N4SZd4RNyyDOpGcWdEwE/+njplXeSRo8leRJxMcb4mi2CGW8QOjhRGbOBiN/UTF0b1
         9zkuAQL7ZsYojZM8AZSGb7+BwDYvdUkBNVRx9EAhp+hSjw9tvkULae+/HzfSI451bpfS
         o0YXr4EHOH3d6CQUue5YUtEnJx/9IJM1O5y/8PF791tf525CWeeGBJo9PXwIjV8VbEbW
         lO0UpV1AzFRoJCvbOzhJ+OEaNYjCLRyJfs66S2zYQwuUeMbKc3AM8Rmfqv9P+MHuxPX5
         b9CNA1Ysc2AV8UxS/KiCHn0CCfNKy0gEgjU/EVFdhLUp1Ug8h49su9WMvuAf+qt0XCdK
         SIfQ==
X-Forwarded-Encrypted: i=1; AFNElJ9mbnaPI+VZ1BDL3uH62sC4V+DGfAEaUMJB/qDRJDFEwhy8l+Xzsa9xkEY9OfqJecXG2u0lTLkjMw==@kvack.org
X-Gm-Message-State: AOJu0YyQF5zi101SW8nNi6Gl5WFgY3MxZ93tXMAfWSkfxUGyQ56sC8Kt
	3+2Q9Hii9fHUafMBq5A79cCdw0g06zob2XWcFcTYP2AXgKoAz+rpYEN+V7CMz7tyBxE=
X-Gm-Gg: Acq92OF5B7GivIGmttsnZ6NtZrzzuE7CvLeJIdW2gQ+Hc4CsauRqrR6EFZHlP4V3ahy
	sIcljpieOglsKq/UCOPDxucqFK3kDULbNZUD3THg5kH18Y+Q98hoIjaaBnjtk8HJ3Sc3z8wQzmg
	y1XzfjVS3nInaoqC4TLEyXYh6r7eMBhth22RbiYACzXpR7cIq0iEz2jVUs/KWJKlDivRqymj0+m
	no+ZxiSciqr1kMJKi5+PQva5lpN9er2bsuiAzJzU3p++eBcRsPqzf6oBD39cdSp2agmoyF9yB6Z
	SJXh9Pdl2Lj1Ml4FmsZPf/M/6kZ143AtLwYn8KPwVbXtWirDiOuuzZEQhgqrBZlW6/dWRbeKBLk
	0+Alle2XVb/ZGarn+smy5nVqkNWHG4pedZRTPFLF5ZrazObRevKBmMQhHw4dbhwEf4LHtQGVrvw
	QcXwZ1h77RRmPaJuEOJq61pSXOgMgSx1KcMqcqEgE2jxXOvPeWT+QuIgNR9G/hukFSB1sfiW5Gz
	1ULe/1TrPTe
X-Received: by 2002:a05:620a:3706:b0:8ee:21b3:2eb5 with SMTP id af79cd13be357-9090e2f7bd2mr1517107185a.6.1778517562231;
        Mon, 11 May 2026 09:39:22 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8fc2c9229c8sm3399020585a.36.2026.05.11.09.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 09:39:20 -0700 (PDT)
Date: Mon, 11 May 2026 12:39:18 -0400
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
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
Subject: Re: [PATCH resend v6 15/30] mm: memfd: skip zeroing for zeroed
 hugetlb pool pages
Message-ID: <agIGNvfVCJucGUyT@gourry-fedora-PF4VCD3F>
References: <cover.1778489843.git.mst@redhat.com>
 <a39ab8288aceb244bdb31141aa9cf67106c0e042.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a39ab8288aceb244bdb31141aa9cf67106c0e042.1778489843.git.mst@redhat.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 357A4A0009
X-Stat-Signature: oz13jatp7itz8n9rd9bf689b6r59e9i9
X-Rspam-User: 
X-HE-Tag: 1778517563-214960
X-HE-Meta: U2FsdGVkX1+2aw4rfDkytiF4JPiPGjdIp68uUqqHJKDVpej6OvA6TXTafEyfapocG11k9yJBx8CW0Nr0cl8k2hFT2DAEWba8Z2II6TEOLmLALo16nBA6nMGTbxG5AGwOuc6aik/Xfss3ZHnd6I+d3lVxeV9Jp71kTXBYUwgG7oQYcquFkJOIhGC+GZG7aKLyV+pxaZMmientcFn5VLSwfMI7IM/BdoPamrJI7CJCDTYc9Nusv2AmFjjiFXi0AobPIW0NG6KUcshgtSPcPJeXJSLIvtP+qCbxv906ecoVIV+Ned/IbV8tKF1pogzKJBNek4+g+GH4opxAwlfVdOwCKDJnpgTup0utKvNvRyKEAMtyOwY+aLJdpEYcUo2P1YcK21uWX+lW1WfPJUKnF2+ibvLktAeswhUewQB2/BxEmDejZI8oV0MBuK3ZSCoKvEAkxdH5XAR3OujMsYp3xFdGMnXmZ30LjbeHccXzzo99YjI+DzhNUM/Y/UoC9Lls84pPdKkRyEG1lxl+g2+vNUENaHaZ4QWAhAOT0e+OY27A1nGjphp67hyuv9gNyX76Pnlg+OoWWozg/WXo8U/n3kFPUpWD9Le5jHB3z4P7RQHHf88+AkKCE25J75r0b4sgTK/tPBPJ5D7hBylhPdUTlB3pTb/CHB+t0j/l8CU4YBnsxCsGd9gNGhKMxKSSnWC6QU/RIcQYrVwjDBPDDGxcJ7lH1qGpPUULdk9m66n+wkAnRFqmGhp2Rm3iiIwoEdm7QZfdMmOnlqdI0F0D86aOgPYyKn7I93T21t7SzoKIBpo3GIyzFl13TP0tRaSJ9gdYvJRutPiyYiOhdVr7aKLGEbuzmw5GOucVvVGw/XPXuL7EfV/aRqcy6qG9zhqKHmikGv6LkZ195BI3YYG/mvquTU70EHoeP2qK7PmZHG+MQtEt55SUlrTafivBUC+VLOh/NOxOiCSJf/5IRspQGIjCsmh
 YdaiSI42
 k7R1NR8Wyvy5FAbv3W43Rydhah+XhbmlGPxn5bZq+b6VRrIh9lvN3w2SDSYBYqFx1Q7DvAKM0TaZk9MnmsYv0SmC/q18LH7f2NE9wDw0tGejjBndWlOHDlTOYgGNv8tBQ2zGk65wfujg1Qol3Pv9R844RVHtMFkw5UkW/MSJGlVlZq7jJzEGVAQlzcDGWJS0GXgBr0kYcxytgt2bYR/+PhySA1C9yLxmikjKK2R4P97W4dNnp0eiW9S3h7HZydxvlxUEQdMg2yoVEzzsIxmhWJjl1X+auCMMJIpT5B3I0UuYzL6pkHLcdCpzvni2+fT4lSsBxEwTDevWmat044eQJFOkOo6tbr1BdmoZsx+TwbtvVmuqpio93zUzKu++yCK+czza5pD+50JXznB0jzf6OoGRrUbBAeebn6RnKYYKWw7vjvuFH6FLK0bci0tp935gpxDRUWizewQuaKRqPH6mxACJiuWXVm7qy2oyblVmENfE2gvM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 05:03:08AM -0400, Michael S. Tsirkin wrote:
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

Same thing here, seems more like what's actually wanted is to sink the
folio_user_zero stuff into hugetlb.c rather than make memfd.c request
for zeroing - and then have to check again anyway.

~Gregory

