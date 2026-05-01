Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88830CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 14:57:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E99FF6B0005; Fri,  1 May 2026 10:57:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4A0B6B0098; Fri,  1 May 2026 10:57:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5FAF6B0099; Fri,  1 May 2026 10:57:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C83476B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 10:57:04 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8F04514011C
	for <linux-mm@kvack.org>; Fri,  1 May 2026 14:57:04 +0000 (UTC)
X-FDA: 84719153568.30.5C971BC
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id AEEAD140010
	for <linux-mm@kvack.org>; Fri,  1 May 2026 14:57:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Er8GF8z4;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777647423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GWaEOZ6T8RZshC5VNeX+VR+c38seOstsZgFtVZK1Yb0=;
	b=kbAQvYnga06gs06prKneN/FrXZF1O0PdDWGHYOacHa3/xaPfF/Y9nq1JzIZaMvSwxb3h44
	IcoqZr+YlXWbxLu5mSRWaXLOxxaSvuecsV4gzn+/ADVPzshjAtdMX/B2vLJHwhjoKOmec0
	Et4rwAWc5G42nspPSmRNSKlNuxyOyR8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777647423; a=rsa-sha256;
	cv=none;
	b=D7CemnD3OyzuiN5VoEApk58qDknVCWmI3R90RMwrRWUKQ/qy9DR/6EZiNVPWO/klXLcDse
	HGUumIS4tAMzvnWaRLmKVicQH+T1sspPg1QH/5JlbdRrkpmdKsJw/9jpLiGodNZBLwZDCd
	3WsSjK7+CuHgC784w1TjXARiNFQ/NnY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Er8GF8z4;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GWaEOZ6T8RZshC5VNeX+VR+c38seOstsZgFtVZK1Yb0=; b=Er8GF8z4i4fcdoqldcSz6UdIrK
	0uV2fMmb401OPsbWUDQlEgY0WImYvRoaOS/51Kt7cci4PwM0IwWZmDRUbGXw7O9IkTUTcXx4Dq2Om
	1ySnKP5ZPsmA0cdTKwQEUsbejJKOkDxp+xsnqOc9et7bCG9WzZFKFYNxcz4UjijcH9lNIaYGg9axV
	D8CvZuRnVnBvGs0WeFCpwaRxMrcj+ZmM+kVA2Q+aDmR35tDfpqtDlNjfzVDU0ieNT7dT3nkuFY8KO
	oBaeuIlQkfSbM8D3+gtqA/Kl4BULEQcG2OPtDBswRpN88NbjoIlZE7bl29JItAlrzNVWRNazfWERT
	lB1uWyaw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wIpIN-00000008wbR-3iIK;
	Fri, 01 May 2026 14:56:48 +0000
Date: Fri, 1 May 2026 15:56:47 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, david@kernel.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, jack@suse.cz,
	pfalcato@suse.de, wanglian@kylinos.cn, chentao@kylinos.cn,
	lianux.mm@gmail.com, kunwu.chan@gmail.com, liyangouwen1@oppo.com,
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com,
	nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
Message-ID: <afS_L-5XeWIldTXA@casper.infradead.org>
References: <20260430040427.4672-1-baohua@kernel.org>
 <afNM-gIqxpyJ6ro7@casper.infradead.org>
 <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AEEAD140010
X-Stat-Signature: eocduy4dht363fha4bzrdsw6wgb57xt9
X-Rspam-User: 
X-HE-Tag: 1777647422-720235
X-HE-Meta: U2FsdGVkX19br95TlkhW1Rf8Bkipa90p7SkDwWHKs2jDrHZ/4eAF1xBp94LMmSAt4mWv+iBvFO2QdHa0CkSzTP9Jd6koAD7/tIKVs5sMQqQCghg8/dymYwHuWLcMKQKGtHsntl62vQ2QAKKV88relIux63iBp7+aeo8Uy3Vdwz6jEK9uDZt9E/M6RMEzVcggs+pgrhZFzqr3rAkLk8iUUlwX30gGfZ88EZMGy7v/zCRo6TCtPS9NqkwE0sMeklQI3Y53dpIUv4s6mzWeOb3GFbOtnpZEeJJTRMZ16ZhvnrCFNa23rm/5IeoDlGQAwTLW1GorxXdIohh/Fo12F/j6YhwxHhN51+BNWVEJ2MbdWVBhAOwzRB+6DDCqUkvroKjBNn73r5vtMonsOKmEJEy3k2+2bNkOJomx+Y+EnljwqIL+USYde/GzLhsrrfVsxBch3B0Cbzp290ZuB4jW2wKHymnZuXN1gez+awJoIJ2wIvyvR89GrJ0VzK86DzTtZhoSINdJgtLIBQENUFM4WRGa3tdrZRJXLu0V3WmaNXFQoFBDuqQGDYVpnfX0qAGILYWaQR9gVMvuRc01SXz95WVFLNoSLqkqQ9LMxZgHcH5BNfUkLksUukJtjuTlCTHQnZPwHYZYttyvNsLKmbwoqXY9B5VPGeAgFokGovxA0qZQSkDSCH62+qJqCN+/TEop7uwUmyJ2bC4Hevk59KRdLLggLDYUspDIJptSDuhyTKULbG2YBbM20RgeYVCOn/wzVUeihBAx3imzuc29/UoMySwFNJqsCBYiH5lg+crVSf9MXjEYzQXbBUW8o54Q4JgsArS83eoXqVftdQKDcZbHdvjek2g2IfcargTdtQjS5956igSnacQFr0KONNilab6TwTf6m+/wnUEkb9owvec3zQWcX+g/jcPUMRe3Ujhubxgnd8cCDUKo1qPIKgU1zCzVx2vWOz4/WMPnrjtPHOOgy3r
 v0Jocvae
 /V6+5itQ/w1mCI/XU4Q7a2DTM8mM++VqYVvCn1YsSvPSEtadK+yFin1laWtaLFf7rYm9CbiiIyf5CD2GmhRNuciAt395gBPkPuBQ90/g1gp8i4cn4m0MrzapD2ElBrP0uWqIzdILgcEmrEToZ5/WH/U1QTytDE7dEt1KJUUOwtK9bxyjHSgofciYNBDoPDAn1vJ/O+VC0ZrkOwhEg7bYWYWOEeN3sSjFSE0sMefbkMmsTfuF5iaybmSx5jrXTHaCFELtX2kLiZ4yPTUiM7Q6iyeYHpbzAfLMVIRJQYO4w+edcUq0kb+eDuj7+AlicMo+VL+41yoZh1O2YcXqIrqnwvMwvcIpAsogHlVNEqJcRKRicnAWqJdesyZODIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 01, 2026 at 06:49:58AM +0800, Barry Song wrote:
> 1. There is no deterministic latency for I/O completion. It depends on
> both the hardware and the software stack (bio/request queues and the
> block scheduler). Sometimes the latency is short; at other times it can
> be quite long. In such cases, a high-priority thread performing operations
> such as mprotect, unmap, prctl_set_vma, or madvise may be forced to wait
> for an unpredictable amount of time.

But does that actually happen?  I find it hard to believe that thread A
unmaps a VMA while thread B is in the middle of taking a page fault in
that same VMA.  mprotect() and madvise() are more likely to happen, but
it still seems really unlikely to me.


