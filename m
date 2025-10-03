Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBFB7CAC5B8
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 01:02:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 111538E0006; Thu,  2 Oct 2025 21:02:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C2CA8E0001; Thu,  2 Oct 2025 21:02:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F19898E0006; Thu,  2 Oct 2025 21:02:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E1D408E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 21:02:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 63F97BAA2C
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 01:02:39 +0000 (UTC)
X-FDA: 83955002838.22.F3D7E86
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf27.hostedemail.com (Postfix) with ESMTP id EA85540006
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 01:02:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759453357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4OBKKwIO3WuO+KhtZhc+7woqfVrywZ4Jt91solNLovM=;
	b=C20k9wIvwCN1zgpDkLXfW3h5VkJTKgNfeMjomXvZ88LXVsCBBsu8xB911zlo0Bu4GTorOC
	64ijkSK7gS+E5SDO/unSDfQR80g8WlLkw4sUQmi+dYmJKgrd2wi+1RzfjOl+bu444ZINZK
	cEYW3ulajNVC9thySMHXTE+7v0Jferg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759453357; a=rsa-sha256;
	cv=none;
	b=TkGVNmlhfiS3kBe5VU4gxfqTC7lGgYwg1MdIphCkdlIFNTGIQCHuFVhNxM3f0fvcLJzAIJ
	k856lWUgNc0lzyNntMVzpbBZbIbHve3grOUIQq5XuA2sZmAl7jnOk9ffVcj/VAF8FXSyfp
	1shsWJr5HeQRpla7VN5IW/eF4+fVmLQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
X-AuditID: a67dfc5b-c2dff70000001609-fd-68df20ab7c6a
Date: Fri, 3 Oct 2025 10:02:30 +0900
From: Byungchul Park <byungchul@sk.com>
To: David Hildenbrand <david@redhat.com>
Cc: akpm@linux-foundation.org, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, gourry@gourry.net,
	ying.huang@linux.alibaba.com, apopple@nvidia.com, clameter@sgi.com,
	kravetz@us.ibm.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, max.byungchul.park@gmail.com,
	kernel_team@skhynix.com, harry.yoo@oracle.com,
	gwan-gyeong.mun@intel.com, yeoreum.yun@arm.com,
	syzkaller@googlegroups.com, ysk@kzalloc.com,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC] mm/migrate: make sure folio_unlock() before
 folio_wait_writeback()
Message-ID: <20251003010230.GC75385@system.software.com>
References: <20251002081612.53281-1-byungchul@sk.com>
 <9a586b5b-c47f-45eb-83c8-1e86431fc83d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a586b5b-c47f-45eb-83c8-1e86431fc83d@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsXC9ZZnoe5qhfsZBrcfKFnMWb+GzWLXjRCL
	9Y3r2C2+rv/FbPHz7nF2i4uv/zBZ3F/2jMXi+NZ57BbX1x5lsri8aw6bxb01/1ktvvVJW1yY
	2MtqceRNN7PF7x9A8blfDC1Wr8mw+LJ6FZvF7KP32B2EPdbMW8PosXPWXXaPPRNPsnl0t11m
	99i8Qstj8Z6XTB6bPk1i91j4+wWzx4kZv1k8dj609Ohtfsfm8fHpLRaP9/uusnncvQ5Udu5a
	H7PH501yAQJRXDYpqTmZZalF+nYJXBmTl31hLdgrUDFv/XX2BsbfXF2MnBwSAiYSJ++9YO1i
	5ACzP0yzAjFZBFQkXi73AKlgE1CXuHHjJzOILSKgIbGpbQOQzcXBLPCOWeLoilUsIAlhgXCJ
	6e3nwGxeAQuJMwsusYLYQgKZEqc7ZjBBxAUlTs58AlbDLKAlcePfSyaQXcwC0hLL/3GAhDkF
	7CSmf/oKtktUQFniwLbjTBBXnmKXOPmaDcKWlDi44gbLBEaBWUimzkIydRbC1AWMzKsYhTLz
	ynITM3NM9DIq8zIr9JLzczcxAiN2We2f6B2Mny4EH2IU4GBU4uH1KLiXIcSaWFZcmXuIUYKD
	WUmEN2HFnQwh3pTEyqrUovz4otKc1OJDjNIcLErivEbfylOEBNITS1KzU1MLUotgskwcnFIN
	jF43p3C5u1+dvMFPL8XH816PKa/ysydZ8ZZWZjPZTlgv2SxqYTVDaKWjerX5rA+MUpk3A94t
	N2J0Wqjyg5c/b9oEse+lstoLlLTeM4T4ucx529iwds7ixM+SJXW3mQwqL26uaHU48Pm0xA2X
	/vqWeXk7rt670//RSq4sZcH+U/PncHI9VhTcoMRSnJFoqMVcVJwIAChf3JzUAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsXC5WfdrLta4X6Gwbl9EhZz1q9hs9h1I8Ri
	feM6douv638xW/y8e5zd4uLrP0wW95c9Y7E4vnUeu8XhuSdZLa6vPcpkcXnXHDaLe2v+s1p8
	65O2uDCxl9Xi0LXnrBZH3nQzW/z+AZSc+8XQYvWaDIsvq1exWcw+eo/dQdRjzbw1jB47Z91l
	99gz8SSbR3fbZXaPzSu0PBbvecnksenTJHaPhb9fMHucmPGbxWPnQ0uP3uZ3bB4fn95i8Xi/
	7yqbx93rQGXfbnt4LH7xgSlAKIrLJiU1J7MstUjfLoErY/KyL6wFewUq5q2/zt7A+Juri5GD
	Q0LAROLDNCsQk0VAReLlco8uRk4ONgF1iRs3fjKD2CICGhKb2jYA2VwczALvmCWOrljFApIQ
	FgiXmN5+DszmFbCQOLPgEiuILSSQKXG6YwYTRFxQ4uTMJ2A1zAJaEjf+vWQC2cUsIC2x/B8H
	SJhTwE5i+qevYLtEBZQlDmw7zjSBkXcWku5ZSLpnIXQvYGRexSiSmVeWm5iZY6pXnJ1RmZdZ
	oZecn7uJERiBy2r/TNzB+OWy+yFGAQ5GJR5ej4J7GUKsiWXFlbmHGCU4mJVEeBNW3MkQ4k1J
	rKxKLcqPLyrNSS0+xCjNwaIkzusVnpogJJCeWJKanZpakFoEk2Xi4JRqYCzJfXo+Qd+W68oF
	OUtTRkXL5W+uqspK5ZsXV1m0nbbiim9JOr/z46ZHcmEbjktPORXE8G0iZ3f3jfU/ODaUKhfe
	Wb02drl+/kaF09x+qu9ZEvPec28tSj7QZbLK+3PHSwPh+vWH7SMFLhavLObaktz/ydFeiusA
	s3t6TUQ+w+oXkiov94hyKLEUZyQaajEXFScCAH4UmxC8AgAA
X-CFilter-Loop: Reflected
X-Stat-Signature: 7orqg6g8pgs4ds83jopc9paf88snyjjt
X-Rspam-User: 
X-Rspamd-Queue-Id: EA85540006
X-Rspamd-Server: rspam10
X-HE-Tag: 1759453356-290024
X-HE-Meta: U2FsdGVkX1+LYFh2r9HHaRq1AkPgk/RNOGiMxy8nayFgYjDeOPFs0DVwB0zqeQHyx2TfoG41rn25E+2wdUCQU3509BH7+NEQEeYWngZIy0exGbxMZOgrcIFnixvWKFKFqvkx0tmHU3DY2Lyr7kVHE8cppdiFyDOxC6mAR+cJu/PIk1q+in1FH+bs43Y3eiagHrBQYLWRx8fLNIH9F1/X/cUxGXbd5jNz6XbfySIS2UGIn95rrPUmW0JzGdYMwcom0yzgb1z1mG2f+q69ixIBiLCTsTPsz7+trTRxIl75gm7ufRlk9UoqN+HH5CTN/xu94I/UfWrZZynuftyrhCiCzkMhmSJJB0CbdSDKo5YK7+go2s71NVe1YuTiJSq1IQeS8w8uznaKSZpcLa6Pro9iZEraCr9Z9oEgZ+Hk6NHroHak8hO0Jbg98n2cf5Mfze+xiIWVxKmKXemRu+1lgfb306e9l5MKmbruJRl7qQ83XGip6K4/CmEvbXTj7U/+q8brzoDMkuF3AOA5JUR758t2u0sYjjqEIFcYWom9GX3yJ/TuePTdkInuOnCFv+t2XVroOGtdWDIdzeTKXBPDW2SIwANOy1olWeZdLhoTUVsO2q4Qnf9RPDk2j/613ZQVDWkfaHfmAX9Qd8wW8qqFGGof4H+l4l+iGOQftHCZFP7/f1/j5CEXvNlnfV7w3D0imz1UI7U0rBQcI30co0YqWYSfEjnpooIDXjj0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 02, 2025 at 01:38:59PM +0200, David Hildenbrand wrote:
> > To simplify the scenario:
> > 
> 
> Just curious, where is the __folio_start_writeback() to complete the
> picture?
> 
> >     context X (wq worker)     context Y (process context)
> > 
> >                               migrate_pages_batch()
> >     ext4_end_io_end()           ...
> >       ...                       migrate_folio_unmap()
> >       ext4_get_inode_loc()        ...
> >         ...                       folio_lock() // hold the folio lock
> >         bdev_getblk()             ...
> >           ...                     folio_wait_writeback() // wait forever
> >           __find_get_block_slow()
> >             ...                           ...
> >             folio_lock() // wait forever
> >             folio_unlock()      migrate_folio_undo_src()
> >                                   ...
> >       ...                         folio_unlock() // never reachable
> >       ext4_finish_bio()
> >       ...
> >       folio_end_writeback() // never reachable
> > 
> 
> But aren't you implying that it should from this point on be disallowed
> to call folio_wait_writeback() with the folio lock held? That sounds ...
> a bit wrong.
> 
> Note that it is currently explicitly allowed: folio_wait_writeback()
> documents "If the folio is not locked, writeback may start again after
> writeback has finished.". So there is no way to prevent writeback from

Thank you for the information.  I was wrong then.

That means we shouldn't allow folio_lock() but try lock, while heading
for writeback end in terms of dependency.

	Byungchul

> immediately starting again.
> 
> In particular, wouldn't we have to fixup other callsites to make this
> consistent and then VM_WARN_ON_ONCE() assert that in folio_wait_writeback()?
> 
> Of course, as we've never seen this deadlock before in practice, I do
> wonder if something else prevents it?
> 
> If it's a real issue, I wonder if a trylock on the writeback path could
> be an option.
> 
> --
> Cheers
> 
> David / dhildenb
> 

