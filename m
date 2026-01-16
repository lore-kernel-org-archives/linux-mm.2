Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07043D4A5E4
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 01:54:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FD4A6B0005; Thu, 15 Jan 2026 20:54:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AA9A6B0088; Thu, 15 Jan 2026 20:54:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B6AB6B0089; Thu, 15 Jan 2026 20:54:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 387586B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:54:26 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D8D3B13B212
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 01:54:25 +0000 (UTC)
X-FDA: 84336157290.03.0395B28
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 36F6540009
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 01:54:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kkaArhLT;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768528464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yzZHisbnFyhpjYl5GAKOtWBxY+PeUf3CDlz1zEe70EM=;
	b=uZBsSRpq/+RIKbR64Um+/SVSrS8aaqQmEdpY6Oq7oR0bkF/Ww6fD8aGkEhEyUmMq5vThZL
	jEENgNmpASb+6FJmz0ccT+bg4FhNmZAvCQZItJfFoSQIKiGPs5RiTlPNGQMW2mYoA1E0jc
	WM0mM5CzrfnhNLP20iqsBlISGOnVxs8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kkaArhLT;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768528464; a=rsa-sha256;
	cv=none;
	b=iIXhy8N0s4vPlITenSW3B8zzNX+C+QRH76xIUqNqaWZLjJCswd6H6Ne4T52jHeH60s+2uh
	zjJpvgcCCPMO/NXlQcKDCSLSYXiA1CEjry+8wwXhXDoEU3eUh8Kxy6Fk3gzKr/9eVrgPF+
	c8YB3Z2HWD47NTvn72Mchgp/Tt7hrjo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 404B040919;
	Fri, 16 Jan 2026 01:54:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE36C116D0;
	Fri, 16 Jan 2026 01:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768528463;
	bh=E3VHf3jps9JywfKsABhLUkLhWni3+c+9qdgoykGsHz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kkaArhLTj4B2/MOE8w/J3+qf/M+KLOQRfQskHWPwtN+LgB/6eGNx986/0paN180VE
	 9hGa+Jjmqn+3v061l6QAXsL5wqZWfQy9NJ1/XXwHNrXROaCOwBa2xM0Xmb9YPoV6Yt
	 VSYAjMG/r3wNWMMn8eRx1r3X965QPNyqRTzE0TNp5XOotlXzDO7JN2MPi+T+YkU5qS
	 SR2KsFhq1+1Ysoa/6RqoIzA85M6GmRYdqmgmK6bMBTZAloLL77YHzE4PtAdigYyZeN
	 uun/yYwdZM3DF/AMCz0mPvrteQRON4EJT9eIDwowkLKPo78qBhvYVpsurUVSL9+IU4
	 ovw/uHagOtbGw==
From: SeongJae Park <sj@kernel.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 3/3] mm/hugetlb: Enforce brace style
Date: Thu, 15 Jan 2026 17:54:14 -0800
Message-ID: <20260116015415.71492-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <63201bd0-4375-48d3-8955-5925221ae241@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 36F6540009
X-Stat-Signature: 6m78fo4jxsqi8fkkwsoj75jgywiosmsi
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768528464-216435
X-HE-Meta: U2FsdGVkX1/AQXd8A0yhZztkOIlMIsy8Avs6eMRVDks43/+L/buKHJTB5zIeTIhlnmGSZ6Tgs52RVONvIU6leniPtr8qctJAzszzMsX3wBk4D1tbsz6tD67cBPsSq3G+cW6BtVM18e0BYNbw4PO7muR6Fqh1PXIy9GTcZYu0aEKfQujUYh3fnwWu9Atsv0OtAVpeCEuxTXLxterQwu6SKowT5ZfRSGniZQMTE/ktDVihI7Tiq8NYuyEPUWRHO+URvD34Dg1k5amijras3tzLOe2U1R4MNOrGnXtzdEzT0Y4tPiGpPiPO/f4sPcxIBXI/pGsfVu81ZkLjDHVpvfv+olpCDTi8GSTRdqE2BtDywz40iyP+rbfOLSjEVVKzLLGTU0ff6sydCBnemh9xyzJKNaq0dkvBWRHwNOkHADUal5fK5bJaF28UoHrM/vUdk/dQN8sqhhxln9//NMMw4PEvFxxu3wactkXK8sn/u3Vjz1/x4vtubZgSXFas8jy6kaD/0e/h6llXAtNLWrLlxgJVNhwCyR3sdIPLdOqbm1L25BXtBuc6evKb9zjZS5cqIv0ZXm9iTwpxdfe0BplDvKXKK3Mz+xA7U7kC18IVWOO166Lh5Oi70ZgL0yd/1/A4SFrZ0gdQisPfxBN61aGtYwNmU1WQy8kQoM9QFLXuzV2+RkjslQiDGHmpqyPCCgTVj5AePgL0fW9RcIdiYSpUFY1yJiZvKCSSzEqyj9LsKGy587hNqQquhbSHh8xOJKT+ghj4riz8WIgN3vPz0jn6voC1+cJIJkEiTygWjgKhRIgvP/LbCXDXGU2qtA3KANAXn1qeeQomNzaSUYjFtd37R0SqCiw+gYcUhTO3TxbOfQT1Leg6keK5RjyJPXVlfsQSHKlx5PX3IPZeSi3aF8T1swPC4ScC9UcFn1JsnA2pFvYbs8pm9C4LWgJYp8ZcJooTTmEPQpJBZzF5uz5C8wWcbwC
 K22Wn/VN
 ApJ+g6/woubOX5TE+IO7weF7EnEAlmQtuYGFpxKyTXIxHp2Ic2cb0kIrp1fXFmuv3uoZjCKjv16y14T0Ff6XgB4CQTvkD5814SKV3IYC1pX8TVxLTzM14gZ1Dze4GIRxsBXBB6z/RBvbjJOZRjlRO39g0249b3lzEETWPdYKY9SKYkjiEDWYbvjnf6eIl2pLkvAlaFNACEhwtwOUQAruqJl0VH++zxfUFoakTmH4BYCKfmfuk5NqpD3wFLsxpjkuZtkF8mWnL+UvnS3pcW2huECi6u7K8srEFSFwft1OBBYFeDsTSR+HiW+7vBABc9/rM2CDLFU/fg+lHP2s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Jan 2026 22:16:12 +0100 "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:

> On 1/15/26 22:14, Joshua Hahn wrote:
> > On Thu, 15 Jan 2026 21:10:41 +0100 "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:
> > 
> >> On 1/15/26 19:14, Joshua Hahn wrote:
> >>> Documentation/process/coding-style.rst explicitly notes that if only one
> >>> branch of a conditional statement is a single statement, braces should
> >>> be used in both branches. Enforce this in mm/hugetlb.c.
> >>>
> >>> No functional change intended.
> >>>
> >>> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> >>> ---
> >>
> >> [...]
> >>
> >>>    		update_and_free_hugetlb_folio(h, folio, false);
> >>>    		return rc;
> >>> @@ -2672,11 +2675,13 @@ void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
> >>>    				 * be consumed on a subsequent allocation.
> >>>    				 */
> >>>    				folio_set_hugetlb_restore_reserve(folio);
> >>> -		} else
> >>> +		} else {
> >>>    			/*
> >>>    			 * No reservation present, do nothing
> >>>    			 */
> >>>    			 vma_end_reservation(h, vma, address);

                                ^ The space here seems unnecessary?

> >>> +
> >>
> >> But why the empty line? :)
> > 
> > Hello David,
> > 
> > Whoops, I totally forgot to run checkpatch on this one. I think Andrew
> > also noticed this, he sent a fixlet for it. Sorry for this! I'll fix it up
> > in v2.
> 
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> 
> with that ;)

Regardless of my finding, but assuming you will fix David's finding ;) please
feel free to add below to the v2.

Reviewed-by: SeongJae PArk <sj@kernel.org>


Thanks,
SJ

[...]

