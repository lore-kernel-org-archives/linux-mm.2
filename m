Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97E6CC88E7F
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 18:47:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62FB36B0096; Wed, 16 Sep 2026 14:47:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E1046B0098; Wed, 16 Sep 2026 14:47:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CF746B0099; Wed, 16 Sep 2026 14:47:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DBDF6B0096
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:47:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 20786A6084
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 18:47:07 +0000 (UTC)
X-FDA: 85220507694.21.DB9241C
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1C03FA0007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 18:47:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=U58nXiTI;
	spf=pass (imf25.hostedemail.com: domain of aa9736195201@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789584425;
	b=qWg29FV7g0YkV7xsW5uuiZLN9gty8ysWcBT0xsy1atvGjC8s7rCmBpQAbAz1j/gJjDxHTA
	kw+lxwVGRgvW5+c3yoHlesLxtmpEjf2oU/xSJpE93HxFjkHfEaXEjXAsdyj8/nsRoym8Va
	JHzjXVkw071tiYAxPpJO1Otxw3ZFotM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=U58nXiTI;
	spf=pass (imf25.hostedemail.com: domain of aa9736195201@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789584425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=id2J5iDXrFVnIxVAGr7DM5v73OGdSGZqAF4hKdj2nAA=;
	b=F8lSBDyY9mPMRd14jfCs6N71U4paxSKfqxPrbP8GM3VQNGawr02YUjtnvy5ikoJ6KNRkNb
	5XNMcXYKh1bjwjkIYxueEhYIinr1NJpIk42Z0WMFmZJ4n92m34L+QiXA8QTKnYK8h9C6Ze
	nMOsvg13TCxDoOxk28dUzG3z44Qwg94=
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d747f05ffcso347005ad.0
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789584424; x=1790189224; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=id2J5iDXrFVnIxVAGr7DM5v73OGdSGZqAF4hKdj2nAA=;
        b=U58nXiTIU4nZTa6pu3UBsXFQAmCxw9lRDj5Bvr8HcrsYRkEclO0k4DSJQuIGma2mgX
         YoPVVDBo3IuMbjN3ZT5Ivkz+FeRLhkSQ3WolZZYsk+c9r1PFaf1KElKMho8FMsLbQF+v
         V7RpXkT0eqpXzrvwIFVYozNUMAx5coqTAbjKDTHh9DO5Qd9oIxq9QeuEgEGeibVaPdQz
         iExx5xGSgKoHyZ0awO0/UcR6YFcBaELbNXdURw9P4SQqlNsjR8xBR7iTTMRxWu47Wx6V
         7vFo62Z9l5yQwdJfFZWwjsjJgkGpLJ4DHc377Of19Rr9WaRE3dPWVyuG40pEDYyezMkZ
         z+NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789584424; x=1790189224;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=id2J5iDXrFVnIxVAGr7DM5v73OGdSGZqAF4hKdj2nAA=;
        b=dSojXy6A1d7TdvPcNBFdw0v1McDjaxJK0rYLKYoElwdyF1AuqPqI/wg7sznv2ZnO0m
         AChfY/dJ8T0ozUVx4DFm4lT6LwCIxCAJjTMMfuOKb6TXCWNI7dS15W9znwWiidqxb7hy
         J+TG9dT5KBsQl2oQyQUDxTZSXbAnmQ2WKTFvozPDGG07MtVAIR55VER3kfSgPUo5Ae6N
         pEyPL/nQg9o/ca//fs5UwkKab0+IkmUeUKo7WFk+5yCOJqTSpU15X8JjGIX5cMQLr1p7
         bnXzVIqjFFsmZnHt7uYVAmm99IpkIw7SK7dP/wGe4Y+bg7FBYq5XLAG44yMw3dLbxCC9
         1GJw==
X-Forwarded-Encrypted: i=1; AKwUvBwzhzqQc2GwnJZ45eU1NMx6OADtcYYmYpGiOSHKPLfyPKE6XvQVtTQNpwpEmAUwKumN+h4bxangoQ==@kvack.org
X-Gm-Message-State: AFuF++kmiw6th2XhOsdYf/BXkZMr6rljxfEjvw23jpFQqLmKot34Hk4F
	yLdwEljUI41r9MJ1AF6fpuV+FL+m6+WKmYAkqp+jqJ8KaT8vwQafrqNL
X-Gm-Gg: AYBFou03Hn7cKna01w0gWYNXYzVtPW5eW4B629o8TfHlVgr/IRlbYfa1O1XPjymMZGD
	1JDtZ5pH7TQLgAg5oEOTTZ6uRn/WEzjs7ZdsJrI4vO/w8Zh5atJTCPJwlE/q/KVwPkicDFxmnvG
	8cTThzbhCocXOh4edfOrr2db6uS3jGM7gxAH+UrB1aZriPXJaDfMlUOfcGsQ+bxxq1cFlCHtpA4
	1F5zNXQ3aD/r0azEMTz7FZzWT7Cr5SStRWerDuYAw9/GvFVlsQQnXxR2XGRk5VG6F2I54iN5ext
	uh6B2cn83efjrM6JeqpuRJEXC3f/V1cO5xG1e0fhXGVKhEFaCjBPlOmgfLdnnF0NSqUstAbAQHW
	wbZgRjqb/ab3bTXKnQYRQr80GegzwKKNaSv1FuWKCY7IRJPN8tKpyQXmQRC/zUDE7fOVr9FRo/O
	CQQEexyg3T5jke5n9MJjfo9jAwhzduKPJytp1bJGzBRXPj8wI468DGiW9W9byCRcG2+lm81NnIJ
	Q9noZiXuRtnXvlCcG5nMFAnqDzKPcgMHy36XSt2acx4v73pE5a+VyuDbpKeyGO7/eSaiT8zxV7Z
	08l4O9PO3YRPWHLYXcrbTYgGyg==
X-Received: by 2002:a17:902:d4c2:b0:2d9:3be4:7e31 with SMTP id d9443c01a7336-2dd8dd0b188mr78874235ad.5.1789584423704;
        Wed, 16 Sep 2026 11:47:03 -0700 (PDT)
Received: from DESKTOP-TJS95SS.tail460ce2.ts.net (36-232-230-153.dynamic-ip.hinet.net. [36.232.230.153])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89d9007csm16143405ad.5.2026.09.16.11.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 11:47:03 -0700 (PDT)
From: Yuan-Hao Hsu <aa9736195201@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Chao Yu <chao@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/readahead: use large folios in page_cache_ra_unbounded()
Date: Thu, 17 Sep 2026 02:46:58 +0800
Message-ID: <20260916184658.647-1-aa9736195201@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260915172615.c183c61c774f529ca57f1fb5@linux-foundation.org>
References: <20260915135909.1007-1-aa9736195201@gmail.com> <20260915172615.c183c61c774f529ca57f1fb5@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1C03FA0007
X-Stat-Signature: t54ubkz19pxw963fore4pa64eakysiup
X-Rspam-User: 
X-HE-Tag: 1789584424-29777
X-HE-Meta: U2FsdGVkX1/RnohuYGNNjtpjxJnDg6/+z0Od4Ve+t60+vNiHNc6Y2MwPg9WEPvQAd4S5YQBEaAGBYgKf3xzFe/hjSTJujcuuqfDA7TqSBQsI1vjoCkGFRmJuLnGSLCNJb/XM2jmM/nDOU271r8ypyhK8se1XLR4Vepum3FJBiA1G8pXyCDa/MZsVPiKVzJaU9Vo3E89ggPEwZTNfF3ufWNEaRkUIQj+tetFbLUtPsXPePQl5Pm0r1UTGX9zss5LL5i56sVx9mTtAMkJmdJBj2k+kbojFHhys80mHwNWSuUs+v/5zO9836UiIqcy9Hbx9JAxqB+FEP3jQitEeUIIUwEkbhV+Ggd5lWNy3O/zbQyFSEKkqjayKu86cWmcYqegBAmr92cyl6n2OLiwMsG7K0f2bhDYYXt7W9Vwwj7Dmh3hUKbIrdvPQ4wZYBA9WBNasEnRyRn7c96Af6exgQ8K71ZtLvFHJDcPytBOk3DY/ta7qsawqer8cj+CyQshfWDfx8xFdtzxluw9FI3zAvGhf5MRv1hqQzgd6Dmk0+Jc9awBFVK95ASAryRzjeLhNg4Bb+tGxRdryRtP0U3+VdzN1N1pvPbRFMEkZ+uHwLbdj0tSY1SZNq2y0anWJBZ0sY87yL9VAealmwqiRCJC2nuxYCUNy3HAHoLVdMDDC76HV/vMCWqnwBQ0tF8LunvPDK/rHzh0VZndraWUZ1XZP+YtMceXjZEQ63abptDU0hssDydO/qOviAstXtAWOQZz/tWuYuvjY3tvE5/FK+kAIi/ipeSVAT3zSjSLRueyCJ7zd172UP4DctsiMZp38Drl2PYBwqKjVgBmc6jqsOGo1t5kD8JNJhCKPAfxPJJXHQa0sdesN1kKVkZvCvUGj8vW47wbmH1qq1zsNaPKdVydmzVOO/tSkC0+339UXyFSktSngnN8L5/VpRFPgp+5MINGdx4huJSxpbg7ijDyWXwrLb88
 NnxeYh6y
 HBRnz4YhS8l2DYSDNe0ngGK7VvyJPnRxMXnHDvBUNzlEycXQVvQ/tFP6XFNCmK0E13u8nf2M+hvzMeHKBCt7eOGWk+KBmLQMkoYPIcNrWbcw8X3hSBGuk5nx1dh0Zmw0KKB6jAPnIBi+EunV4NvqTBLRWY4IOic5SPRtLs/OvFav6D/HqltBACufxhMYsabTLJ2m+ps7nxsfzLFP4G4dYBNBMp8ZqI4ffqEASs5Lvz/QL+ZSTeU2LqJz5f1cViVX5hwlhl6lH7gQVJCu3iuhVM9Y+OlG7fLp/TSR65uPZUmTnwNMgLW1lhpZ6bbrDEElzhuieNo7uI1rojXqMLbv3kiQXDx9BMFBo+2tlBQtcQYF8mxmbe1Li45YXQ/PShglj4LMwtHpZOlxQOL1GTL5FUJ/TI0xffed+ovQxUNuuWIM5q11PLZnslHA/Zg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 15 Sep 2026 17:26:15 -0700, Andrew Morton wrote:
> Thanks, and welcome to Linux (I think?).

Thanks.  Yes, this is my first patch.

> Are any other filesystems affected by this change?

Every mapping with mapping_max_folio_order() above the minimum: ext4
(except the encrypt feature and data=journal), xfs, btrfs (except
HIGHMEM), erofs, nfs, afs, cifs, zonefs, f2fs immutable files, and the
block device page cache.  overlayfs follows the filesystem below it.

tmpfs sets the flag but cannot get here: force_page_cache_ra() returns
without read_folio/readahead a_ops, generic_fadvise() ignores hints on
a noop bdi, and madvise(MADV_WILLNEED) takes shmem_swapin_range().
fuse, gfs2, ubifs, ntfs3, ceph and 9p do not enable large folios.
Nothing changes with CONFIG_TRANSPARENT_HUGEPAGE=n.

v2 is tested on ext4, f2fs, xfs, btrfs, erofs, a block device, NFS and
cifs over loopback, and zonefs on a zoned null_blk; read() and mmap()
match the O_DIRECT sha256 of the file on each.  I could not set up
afs, but its ->readahead is netfs_readahead(), as used by cifs.

> This all sounds great, but I worry that the resulting increased
> consumption of larger-order pages will cause all sorts of unexpected
> mayhem to all sorts of unexpected things.

You are right, and v1 does exactly that.  __GFP_NORETRY on a costly
order still means an async compaction, a round of direct reclaim, a
second compaction and two kswapd wakeups before giving up, and v1
could pay that up to nine times per read().

Memory fragmented so that no block above order 3 remained, with the
remaining pages pinned so compaction could not help, 1024 x 1 MiB
pread() after POSIX_FADV_RANDOM from a RAM disk:

                              before       v1       v2
  sys ms                         219    1,462      239
  compact_stall                    0    2,437        0
  pgsteal_kswapd (pages)           0  234,494        0
  pswpout (pages)                  0   23,759        0
  folios left in the cache   262,144   36,508  260,869

v1 also made a plain sequential read() 3.6x slower there, through the
page_cache_ra_order() fallback into page_cache_ra_unbounded().

v2 allocates above the minimum order without __GFP_RECLAIM: it takes
a large folio when the free lists have one and never reclaims,
compacts or wakes kswapd to make one.  On the first failure the rest
of the request uses the minimum order, as page_cache_ra_order() does.
Keeping the reclaim flags but limiting it to one attempt per request
was not enough (543 ms, 67,183 pages reclaimed by kswapd): the gfp
mask is what matters, not the number of attempts.

> So for several reasons it's
>
> - allocate a large folio
> - check it
> - oops, can't use it, free it and retry with a smaller one

v2 scans the xarray first and sizes the folio to the absent run, so
filemap_add_folio() fails with -EEXIST only when another reader got
in between, and then the loop rescans instead of trying smaller
orders.  Four processes reading the same cold file after
POSIX_FADV_RANDOM, 64 KiB at a time, counted with a kretprobe:

  before  7,754 -EEXIST (one order-0 page each)
  v1     59,783
  v2     15,828

What is left is the race itself; the unpatched kernel sees the same
race at page granularity.  A memcg charge over the limit now fails
without reclaim and the request continues at the minimum order, the
path it takes today.

The setup and the numbers are in the v2 changelog.

Thanks,
Yuan-Hao Hsu

