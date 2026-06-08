Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A73A3CD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 19:59:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E44496B008C; Mon,  8 Jun 2026 15:59:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCDB66B0092; Mon,  8 Jun 2026 15:59:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE3726B0093; Mon,  8 Jun 2026 15:59:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C058A6B008C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:59:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 81F091C12BB
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 19:59:18 +0000 (UTC)
X-FDA: 84857809596.17.4AF407E
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id AF883C0002
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 19:59:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="g/LWqP9Y";
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780948756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Xwdm1oiBGcy95PBpOYBrMILZr7DavlHrl7pDmQKHX0=;
	b=GRZifUuDgnMuoMe6JLhQXJHsdC9rI9RELCHZJBhhNX0raVh6lrkbQovWyWobR+aryRUzbI
	D0JJ/zbkPzPiwRKCh1488v9LhjExZp8rFtsY4iwSIUELMVTHjJJi65jVElXMWZMO76TNvZ
	Ip6gbjIBUFQVSqjuLnpRFltKI5esgzY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="g/LWqP9Y";
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780948756;
	b=nIRSo62qci2EatnOr23Lz4p/yoZmVNKP+i3Jacj+qBKHUq9yZul3sPOyRGhjMZQbWxBdp5
	Vf+mEY2xchn1OBzlvFuTaJDlvcM5qkdnX0wSnMFoH9nurM6zsTGJWFS930fh1+QqpUrfe0
	FdQe3sV66tkgSg2DAiBNgWIqhBSkivI=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-9158c621ebbso566408685a.2
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 12:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780948756; x=1781553556; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7Xwdm1oiBGcy95PBpOYBrMILZr7DavlHrl7pDmQKHX0=;
        b=g/LWqP9Yda/YQ7cWsDFIyh9/IU+dIDOjXi9sr3YFs8YblReHrA3wZQM12Gsjb3s2R3
         Pyh+GuVoSn4TV3PWTDMXTkCAn+oKsl9CDSTmi4Qf/eRJZDF/7JAayZjHu8KfZgHpgz0P
         P1WGnARSiJVGnA2VdTXqmpJRVsTALcoHPigpanQZmy78HHhZNaQ2ApihGBHfTvFcoiqW
         mHsq1i8Zbkx06c1k+y2HESUDjQsjr9m8EqbGJF146BjQekjnuwCTZgiU97rSIpUGCxMe
         PR06iLV0HLUs+YOgN5KggWD4bxI+C/6hu2leuDqRcL5Vj07PJLfjKUxGBnBobHs6R8xl
         4ZxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780948756; x=1781553556;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Xwdm1oiBGcy95PBpOYBrMILZr7DavlHrl7pDmQKHX0=;
        b=lba7OOse9VT2GNcApuzHmNkt4Xb39ta8q4qPrMJeGaHmW6AsT76mLbgFbPLxXeddmE
         yvu6KgGhkMbO2ZTFm67DzkYftJE8kbmAAHVNuIQOynN0sg97StoSz8RGJj/B0O9MrO4q
         Vurnzl5OgrBBwA3dgzqK3IGeL/UaENR+45wnMzpemob8gzpHHgBPbpUkrWZt+BKgCDdz
         BSgc0rhcFBfdVjYr0rX+AzmSa56SLY4KSr/LF9IRDn2CTTD6RrCOg4lpbcryKAxNVWlC
         X69OkRWg44h3oQMU442N+IWgHK6cipIBDCVRVg5xidFpDQU8T13cYDPBw24tVeZBgS/g
         nZew==
X-Forwarded-Encrypted: i=1; AFNElJ87zqCPd9LjtPZn8qCj47bFhpghVChKQnXFC9nRd/0bVWfjX1M/TWp706dQA0dh8ThWr2sAgC5nJA==@kvack.org
X-Gm-Message-State: AOJu0YyoGlR2x5f0coP+b5b6BdiXFCDqRzPeQYr0cdWDQ+iU7iKgeh49
	j6ZD2+GmD+MNocILSKDtSOgpwLiNNz50foszEsDxlzDiW2UjejeXXHy1yF4XOZDV3TY=
X-Gm-Gg: Acq92OGEvQdd1iNaVI0tGxd7RKKi0ZgKccL36qjH9MkBxjVDu8LJDAJJgrykXgwP0Kd
	m3tEbwiGRJGI0DAzztkYATaDN/JdrnecWwciwvydZ1PWaAJSP2R1DI1sATZBTC3LJgab2uXJnRn
	MtP4tEw69Tx47isF761ZFcy2izlks20fddqJsJPfpGe5t591tFx5P3ei8y/NS9/nNjh5jsS/P9m
	TIcuydDKP3HeyJZP1GO8wk9sMC3IhIQMJ0NIxXKF4UOTJ5rjVRZ5qS/qC37Yg/Y1B2N17TxKkKv
	vYfgSDX9snYisFXPR/Hrp0p5JOF1JFdyZMtmIjI76oSJ0E8dbPdbrYR2ZipN0gXuiCtY9cVPFC2
	TgjXQ7FMlj3Ai1yA4GL5VfqVmrkGBSufiMTsNHufzRSeI4twhSaYQRRteVvNiNDbEVHBaO09PBB
	k+EZ10ImPCCvzfJjMWpJ8v+yhVlgqmjkkJ93NbnDeqf1vcGnxAuByqJYA3EFSgv3LfWyAc6me/A
	tVdjAWqY8fioaNCMA==
X-Received: by 2002:a05:620a:a0c8:10b0:914:babf:9f56 with SMTP id af79cd13be357-915a9d763b4mr1978857285a.39.1780948755844;
        Mon, 08 Jun 2026 12:59:15 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a3c2492sm1978154685a.34.2026.06.08.12.59.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 12:59:15 -0700 (PDT)
Date: Mon, 8 Jun 2026 15:59:13 -0400
From: Gregory Price <gourry@gourry.net>
To: Matthew Wilcox <willy@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
	linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [PATCH v10 07/37] mm: thread user_addr through page allocator
 for cache-friendly zeroing
Message-ID: <aicfERTP3H6AndOs@gourry-fedora-PF4VCD3F>
References: <cover.1780906288.git.mst@redhat.com>
 <50d410b47fe3f45327783e05bd306d5eaab75e65.1780906288.git.mst@redhat.com>
 <aiaUDTeHDA45ZXFS@lucifer>
 <aiagMc9Ng_AE_adh@lucifer>
 <aia93IzhTgi1vGi6@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aia93IzhTgi1vGi6@casper.infradead.org>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: cimmybs3imw1gkxow1wgow9rixb3jw74
X-Rspamd-Queue-Id: AF883C0002
X-HE-Tag: 1780948756-508867
X-HE-Meta: U2FsdGVkX1/+S74LxgZr2fSSh4U2SE8W4RdS0WNobYeB9DsrPQw+QdkLmSJTzrsxca5hi/Qr8C7u2d/WViO6RwGdCoPYaPsRRXVM9yH9RCIDpGHZ39TcHrTpAmfOA43bOFYs96CWZbI1xsIdKVRdz9i+goRNR+UvYqxAdkbeMEklF4/9cnt2e6vazW70v2GgjJZMDMNMpHzs/ZHVCZTlhoqrsQ4qTZNgG8CNyfk/WO5VZw6LobPY4u1GBRk4CZu/EKFk3J0HzI1HObdrkqq0qg7Pqw0zqb6V1EyenxK3tHI9bLpCtzOICkoZD19CO/VqDWuh9Z5VPIc3eaMEXwCLDDCNascSTLVOFsxj4ps7oydD+SCY/U7kKIYv40mto6Xka1mvcZlDiX3Nm++tBuiE4PQOfjmmTp+po8hzn7mwmGf6/+XWqO53ryDPxzuzDEbJxrTkt8SR3i3/mXNbw3RHS0hjEQMIxpUnEfYjLLxf7Sc9F2BU/SLsvAUPVSqSJKLRruuiAT7uKzVGb7hfDLjN/G9UIQCrKoRjAgwvh2OqxDHuaQFAGXRbmdIcMYQc3uhalnJz7/1frs9KSPlZb2ftOrrkfJMBryNt3olRi88qVpgUcsKG4kSomlwVH0aSHxC0oypfcvoBUcojXExpDE6BbjxfSTj2wL+ouMHbCWeP3mDxv/cRRwj5pEGGxQKXYViaxiMcEUkZdf49mFFxeDeX66R5tUbRmD3P3tD7wm3LM21YBAsi8QGn9SMAktPAg5KHCMEHBtY+EJexf5KY82HD9JDC6sVjIGMlB6/nWLrnmrBawSXtji3NlJ/NudywlKXIfwsHOHXh39v+RsLRRM8/cO8IcJUmxsFAS/J+QQCu6rpP+ca/zAcnNnK3KteoZXgK6lPb3cjUzEE02M78ZIskQvE/Dgskodo0dhj4krbzmU1vFG9+YTJaSoPb+jN+KI8QaupZ7vUv9flGYkb0xjw
 D08U/H6Y
 PKUnuOdAhAGoxxxeb4bLzWbGIFENNDdg15X0vJaP1W80vOmY78AW47oML1kRT99q8wUhd6v/3ZA0YdP5x9qWUHJu+UiWuSl6ntpJWSexMFuUE3CZzbrYC5nPO+mGGXdDDl2XaK52/mZx0kWGTihl5vWNQqhytpxj6V15hdckkVvaeMZrk1vhoCjuqf+g62HEXKO0gF9r6LY3TiXvbCmtmh9xbpZR4r3ZRUsrR+Pj7CN71T4Y8HFp21MRZCJnt+jiuva21KrkEy2OBAgZRf+ybYUuQZcEefTqu/D4wpHcszH8NDsuAF6mP0zVwPRhVJjEcCKJQo8WWoU5iJrZcKencxVByZvelbXVijdRWpBQsVBJzqhcEjw01PiAykLK4IhMNd+YtVXI6hRc183claes2Lp0EX2kz26dZHXF+15hfYV9pBly6ZqBh2MN3PHRSoXtQxSPwKBZZP6C4OvU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 02:04:28PM +0100, Matthew Wilcox wrote:
> On Mon, Jun 08, 2026 at 12:06:35PM +0100, Lorenzo Stoakes wrote:
> > But instead of overloading user_addr to indicate all kinds of things, instead
> > make life easier by actually breaking things out.
> > 
> > Like:
> > 
> > enum alloc_context_type {
> > 	KERNEL_ALLOCATION,
> > 	USER_MAPPED_ALLOCATION,
> > 	USER_UNMAPPED_ALLOCATION, // Maybe? Do we ever?
> > 	/* Perhaps some other states we want to encode? */
> > };
> > 
> > struct alloc_context {
> > 	...
> > 
> > 	enum alloc_context_type type;
> > 	unsigned long user_addr; // Only set if type == USER_ALLOCATION
> > 
> > 	// Maybe something suggesting context or whether we init before in some
> > 	// cases?
> > };
> 
> Ugh, please, no.  As I suggested last time I commented on this
> trainwreck of a series, lift the zeroing functionality from
> alloc_frozen_pages() into its callers.

This sort of just implies writing the "alloc_frozen_zeroed_pages()"
wrapper that does the zeroing at the end before return, and then killing
the post hook nonsense associated with it in the first place.

None of this resolves the user address annoyance which is needed on some
archs for cache flushing.  Whether anyone agrees that the page allocator
should be responsible for this particular operation - open debate.

~Gregory

