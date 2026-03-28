Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78C4310F3DF2
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 18:35:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94FCA6B008C; Sat, 28 Mar 2026 14:35:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 901336B0095; Sat, 28 Mar 2026 14:35:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8168F6B0096; Sat, 28 Mar 2026 14:35:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6D1F76B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 14:35:01 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0A6611B6F40
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 18:35:01 +0000 (UTC)
X-FDA: 84596323602.01.31FECD4
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 20CB61C0014
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 18:34:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=manguebit.org header.s=dkim header.b=h3K0MwFp;
	spf=pass (imf18.hostedemail.com: domain of pc@manguebit.org designates 143.255.12.172 as permitted sender) smtp.mailfrom=pc@manguebit.org;
	dmarc=pass (policy=quarantine) header.from=manguebit.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774722899; a=rsa-sha256;
	cv=none;
	b=aDb2Jc0Nhh3RmmpeOILTypQfqoxA/V7OaxCbaV5JfM4pihgMeiaft4R+018a7YOmi+5/Xj
	LOU9zPvA07l03bHf7J39/GxbB1HmZdMh2p4KD2L/MMxJAUx3KeZpTlGVeo8xpnrRrEmxVA
	5g712rGIaVX3gmrxC99xhysluM34YEA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774722899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ub/AEo4t598Shwt8YJggaAGXX2PtzkMnlWDy9kFv50=;
	b=sggrmFNHYZ/F3wQLvNwmcOKki3HJVIe2DITKIPKNE6LWIY35o9J8c+GB0PzRH3yVsVRDxY
	6CTb8ykhurCX1F7La6/2cmQ6kF5MIao+LXzilOrWI7AtF7vFWBbnNarykjXICASrp/9PpS
	cn9//x19VlJ5VxV8qhMKdW01PbIY0g4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=manguebit.org header.s=dkim header.b=h3K0MwFp;
	spf=pass (imf18.hostedemail.com: domain of pc@manguebit.org designates 143.255.12.172 as permitted sender) smtp.mailfrom=pc@manguebit.org;
	dmarc=pass (policy=quarantine) header.from=manguebit.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1ub/AEo4t598Shwt8YJggaAGXX2PtzkMnlWDy9kFv50=; b=h3K0MwFpfg1kOVZtxuEJyHiHDU
	tX+sBwyY714azoskpQItXMe6WutTWzchu+ys9rlEXgKMUrtoQP+IMK7Hh18U7+mCps3nul3d2umbw
	IJHgA8WWL0iyYLsgndr9cSUZImNlxqScEJ5a/cY81IMsSsmZddiHNvr2hSgXlDmbKrffLxIi7kQ55
	TEZXxMr/ZXA7DsiyEpV7PRv0ffUkbX//iDCTtHQnEthyuAIRc5hoXiq5/kBimytSBr/dMF3/I69Wd
	VNe0A33tRpWQ2TFaN+m/7OfnlPqLzI9sedM1p6tNFek3X4nJGAr+Mk7msLIlTjBzj+mSm7B1kiDht
	0HhLASww==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1w6YUr-00000001nnY-0QeS;
	Sat, 28 Mar 2026 15:34:57 -0300
Message-ID: <16a6ca6a01cb7f65cf71c1358cf88f53@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: David Howells <dhowells@redhat.com>, Christian Brauner
 <christian@brauner.io>, Matthew Wilcox <willy@infradead.org>, Christoph
 Hellwig <hch@infradead.org>
Cc: David Howells <dhowells@redhat.com>, Jens Axboe <axboe@kernel.dk>, Leon
 Romanovsky <leon@kernel.org>, Steve French <sfrench@samba.org>,
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>, Marc Dionne
 <marc.dionne@auristor.com>, Eric Van Hensbergen <ericvh@kernel.org>,
 Dominique Martinet <asmadeus@codewreck.org>, Ilya Dryomov
 <idryomov@gmail.com>, Trond Myklebust <trondmy@kernel.org>,
 netfs@lists.linux.dev, linux-afs@lists.infradead.org,
 linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
 ceph-devel@vger.kernel.org, v9fs@lists.linux.dev,
 linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 09/26] mm: Make readahead store folio count in
 readahead_control
In-Reply-To: <20260326104544.509518-10-dhowells@redhat.com>
References: <20260326104544.509518-1-dhowells@redhat.com>
 <20260326104544.509518-10-dhowells@redhat.com>
Date: Sat, 28 Mar 2026 15:34:56 -0300
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 20CB61C0014
X-Stat-Signature: u5a6coyzfesrso9xyxkywrbbemjxuc4n
X-HE-Tag: 1774722898-609261
X-HE-Meta: U2FsdGVkX1/nLPJL12te4vDGAzJYjugDjiRFLp7sAlQuxogqufWReiBW0swCQ6VCJ18By0bx5Eypuni/44x7zLbARb5BJYf6aptZMtDAleEDo03hmbAcME7v67J0NLzdIab6FRIjS1xWdXNiOPxxFGppfS/b0sJ/LTo6mw1GOXHG0lBRl2HgGjyboG2Qpv98Ih+FdWEqCgDK3mlUKf5KbasFOoKfvXnuvcdI4vASYX3VpcfNgFgtfeoa2Uzmf6r9UbXDYxx9gKj6wSn0LAJdLU1BKJpk8CoPozbWQdIAYJsTPkwnak01of0GDhnRT1cpQWLX4sDiTc1kWB3aB0Q4xDUYdsnz2MMfuj7YnhiqU5QAMtY8qULQocKXAhMMV+9CHVOVvcvTD+sEVlTgMOs7XJtrv0Ocy+6B0dV+2ugG38IXYpUHo945FOJW3To6+Rl4w96/qDFL+5yqUfMUJHPrSwrl0y7hnRCA2OyeTXT16RPsTL8r+AiUmhvUvLpjt23/6vS6yHd+3C/+CiTuNQ6K3dkcA9OQoklKCR4tYXrS5+zj2PzU0I5mzaU4VYrSKTsva7Inb2VFFMmhRlmXmXD9gIxOFr70Ljp98Xww4WAyBjbN5zatX6yxdXNebqsxu91a7f2cPvJ5MKWSw823RoVcI5d1dvTZsozMQXxIUEP9Ojx9enORhs/7xtiWvFxP44BqHPHrI/UeDlvHP1/BIR64iWVmuaIMJSga8mezITHsOihMNLp1YsD/kvRKEaP5Rv1h8X74ED3Btq3e7q6uAyR1mM0/fUcLY5r3cF5LGp7FtBahbd5s9e15GiLYMZRNmK3Ge4uabGyRX+AMtfB8orV1sEEwbnurK3TMxb4qz9EhIBo0JMa/E1OxmwRpkMhOZSzwsinJsc5rfQFordEHEl29WTAzMxJNovsw9fSJzKasKDzDAXnnvVMVO4iHVG2KxM7CzovAr6ZTDDLvyDiN0Qb
 6F8k9UCh
 FYITOy7FaVbKxB8AZeVODmzMM/Fp4IfP/SNVhiK2V5Og2yHmjWF89AfkEN63EgSCdEileTYU49QtkHMjoJsN9wXoQiQAPcnc7XThIk2IQ3Ci731TCuYATp+8ZQxGHlRXlGI2Hr9ag4LGn7ibnXra+hvMcZo/PGpYNS1R+X4cp01Xzaf3KdeNUKTfusOdItUjxhiprcIzIQGckjhir4JKxkCt66BmWSz2muI73MeOVeYOBVjto8R+jia42GLFTaCSeGWsvXR1zCVRFsthzYU97Kwf0GhTiJhevN/4ghdPVhrPd8iJ1pkwa561Nffi44B0njWc4Rkv4oDvUbs4nC2SM5QsKx/5LKV8yZQEF7s0FgsbeQOZvDwS24bZN6iLT5pU663mIvKjpZm01jOIjFZvqQucA0D3jwSl8JuoGtgxSRKMlWxQTr5gLSDwUuADIPPtVBzq2oseSha8aLCYZLYdFIgoT9GwSlRTlQ6aB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

David Howells <dhowells@redhat.com> writes:

> Make readahead store folio count in readahead_control so that the
> filesystem can know in advance how many folios it needs to keep track of.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Paulo Alcantara <pc@manguebit.org>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: netfs@lists.linux.dev
> cc: linux-mm@kvack.org
> cc: linux-fsdevel@vger.kernel.org
> ---
>  include/linux/pagemap.h | 1 +
>  mm/readahead.c          | 4 ++++
>  2 files changed, 5 insertions(+)

Reviewed-by:: Paulo Alcantara (Red Hat) <pc@manguebit.org>

