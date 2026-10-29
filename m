Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6226D606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=vdi5/0Zd
Received: by kanga.kvack.org (Postfix)
	id 55E266B05B3; Thu, 29 Oct 2026 16:02:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5368F6B05B5; Thu, 29 Oct 2026 16:02:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 472A66B05B6; Thu, 29 Oct 2026 16:02:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 278C36B05B3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:02:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 89E26C050B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:02:37 +0000 (UTC)
X-FDA: 85376736354.18.1ACF450
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2EB968000A
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:02:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="vdi5/0Zd";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf02.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793304155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zKBj/4/nslR1aXuIkz63N04FOxASl+KN0QZ/uCoAH4A=;
	b=SiKlKTeaHD0EHkBXhCYkuyifRkSfL5almmrQLy6qbGA8dxl6STFJTsH1FDEty+miXZpjZl
	VINvWHq3KUyQVYQptGFKKSac/SHeXLY5hLJca35C+fQ0sgcKvE3grBbpBoNoUv4ZrNaJ6b
	7IvnZEUGZneNVkXyI31plMKIzdnRD5k=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="vdi5/0Zd";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf02.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793304155;
	b=RQsYV3UMGYAHa4tzV/Zh2b10XOHWDgy2CTtXFcXUb+tixVgnX/Tf3ugqQC01hGeK2WtY/6
	wyxs+eapaGSCF08PHg6CmXNVYsFrgBrb8ngWq4MqedADtrDnWne4CPJuGcsn8508IWldAE
	FX1IzDAn4GZY6KVLWZyYffeDfAkWhGg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zKBj/4/nslR1aXuIkz63N04FOxASl+KN0QZ/uCoAH4A=; b=vdi5/0Zd/6Xz6Rp5HRC/mveyI3
	4PI5bZgyL7DpIZESI385vlS1aDjzpPHdHKr7jzWQcXtFsr95tO9srXq+1SgTUmlFOj/tWhJQmDW0i
	FxJi7u26tzbINCzg9qdzAh3Q6+dvF10rGd28LSuLLKO7GyEJqFu3OMkb+Pm7BBtaY573EtGmxzVo8
	WkAB6JrFiv95j5scLqaAOPgc8+fCUDhlS1/RK4G9t7pKEp51QcjGc7uoE52v0TLYQsln5hO5AhWtz
	ThWjNUm7ukcilSgqnTpFvcpa/QsJ6WR4BTVMl70JrtcN4gHBjzdFOa54C1gl0wgblNhFj6WvNeUIN
	7urNr9NA==;
Received: from willy by casper.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xMWKX-0000000H1uP-09fx;
	Thu, 29 Oct 2026 20:02:33 +0000
Date: Thu, 29 Oct 2026 20:02:32 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "Liam R. Howlett (Google)" <liam@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Thomas Graf <tgraf@suug.ch>,
	Herbert Xu <herbert@gondor.apana.org.au>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
Message-ID: <auOmWM5uiQC9LPwx@casper.infradead.org>
References: <20261028154218.1668182-1-liam@infradead.org>
 <20261028154218.1668182-5-liam@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028154218.1668182-5-liam@infradead.org>
X-Rspamd-Queue-Id: 2EB968000A
X-Stat-Signature: tzciddwpto8w3kpqu1upfyyhecismrkc
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793304155-377229
X-HE-Meta: U2FsdGVkX1+btTy+17Iu/cdIjSle9Zs8M3d08ns+zjjoEHsx6iAaBy1dzzPUh15mPMppyRkR2CkCSsGTeHfbtD5wvLGhp6P2ZykXmQIHJk1ilFH4DCFIjl6ij7POuU2HoilHfiETAhvouRAlrd+fNaRix3mNoxbOsq0ewDyGQl0gqU1iiNtS6OCs32ktn26hxKWAoK560FGbqx/3c0OA51jYzMIgsBFJgDRthYJcF1IOA5b4MNidP5KXOCuicCepjENC6gRUs0DykHhyXEsR3v0TpdapxAk2RwOnzsaXe7untpBFuNxpJ5NpWG5MzXV8MTQc/jvtdsL2U7fjgsO+0ljs/ePAM0KffjS+5USHnjUjzEVGf1OZ6uHhvthsSrky0fm1gxZzzWFjB+Rhx7yizDvvlS1MFDNL5ElbcLBgkVGNpFlDEQ/j2OHuKSVKYdLQ1BX1/QSuVFATT8yLO/I+/kOTf3Jsvc3oELz19Puc3ModO0tlGJ/bK32tdJ6z0vqz1IFNeXMeegyLoIGUx2hjGH8M30B6Qgym83dtGwOrfxdFYG4DH2k/DZQTL6C1NSb0EFkrk0W4iYoc/FgOLELTZ3nt6gEW9vQptBR0AlqqdEp8JAmAwjv2I7QYVFeZG0r4NkJgo3/PhHgecvtYd2tZP3A8xoFFZHlOSPeYIQ9cMc3okOZtjqLJztPNHsQ9CgtTNGwzEmkGsGse9SXO/Y0rg2ltvzgVZUqiUGld1Y8tGqOr9C9kOiiTa6k5kYZnMmX0ew8561giHuw1JD4v5uNcMn2Qjkttfq1/BXWQpg0EKhNwid5zW67BRPVPFfvItVgD6GatqxGJsvJNl7mOdPZuQo3EvU/5OVGiCmicu8GXGXv3ntgkzXxMY2NzkiZ3VLfb11LjHXvy69b9Ft5FoPgyoXFo5484g5El9D+EMsV2HXuI/h5jrO0nmyIhIgemyFZRL5TNulfo5c9eGCVf0lZ
 NsnMmimP
 baXZ0JMfqa8xMiG+XJUgXA7kMexMCiTgc+wsKUnPOisRlicllISoSBeXNIYfsuInnSq4RTBbtjZ79KfPbYkCT38jxeaYCzbEnw8cpJRMmNbURx6RSdZt2RP2BQL4ooRAHp3FiqiRD1h28xuJiPhyv/rZb8NlI144F+W2tIf1k49e1Z72S1vuj9jqQWO7RyqxzvLcTPxWXSf5Eo36F7f4GOLCtKw06tV37lfZsQTzZi5x02tpHh2qks0OBdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 11:42:18AM -0400, Liam R. Howlett (Google) wrote:
> Below, one CPU adds an FDB entry for an RTM_NEWNEIGH netlink request,
> while another CPU is inside vmalloc() or vfree():
> 
>     RTM_NEWNEIGH                      vmalloc() or vfree()
>     ============                      ====================
>     spin_lock_bh(&br->hash_lock)
>                                       spin_lock(&vn->busy.lock)
>     rhashtable_insert_rehash()
>       kvmalloc(GFP_ATOMIC)
>         vmalloc()
>           spin_lock(&vn->busy.lock)
>             waits for the other CPU
>                                       softirq: a frame for the bridge
>                                         spin_lock(&br->hash_lock)
>                                           waits for RTM_NEWNEIGH

This seems like the kind of deadlock that lockdep can catch.  Why
hasn't it?  Do we need to add a fake lock for RTM_NEWNEIGH?


