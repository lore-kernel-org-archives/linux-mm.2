Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07B13606A680
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 11:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jb3fbWjX
Received: by kanga.kvack.org (Postfix)
	id 0E9D06B0683; Tue, 24 Nov 2026 06:16:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09ADF6B0685; Tue, 24 Nov 2026 06:16:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF2096B0686; Tue, 24 Nov 2026 06:16:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CA9716B0683
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 06:16:22 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CF949A0B46
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:16:21 +0000 (UTC)
X-FDA: 85469758962.08.6590E8E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 34A83A0002
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:16:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jb3fbWjX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795518980;
	b=nugHxkotinooyUZijSXFEPOv1KYrUYIHFlZYqcdRDYuPlpWKjPdoQwSqunpbMXNTzn566A
	eae6B+/FrBDSb8czugMJYsipknMBMzGlw8jFKijf/TBcMUoeOn79UsXtXPSUE2hjhfAOyk
	TNeHyosKFORwUB+oQPSKft80crguuyA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795518980;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KkEAREBtCxRyk+VZAQ84I1rNdllc+YXCR4hKLNCRlYs=;
	b=SxEgscAVeq9in8EFYLmxnrb3Jwj3acojk9if0eaComYDcvpFLVlniTxt9tCIECqjSJhE1W
	lgWf2phBjT8bYxgXD15sW5dFBLt9YWZ9xb/4ogZGm1YNVKOdL4PnhfWSV73jpV7I0N+v6y
	GtLt6ZedQTczFKsjt/CyVniheMzWQ3w=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jb3fbWjX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B79B64334B;
	Tue, 24 Nov 2026 11:16:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4A71F000D1;
	Tue, 24 Nov 2026 11:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795518978;
	bh=KkEAREBtCxRyk+VZAQ84I1rNdllc+YXCR4hKLNCRlYs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jb3fbWjXKAyo4sbavwz2OhqsIupbcwoPoUDXigzlBls6Gyd6FNwzIrYSvV7MMVVps
	 mFmu4Yp57wabuxo83HqJgEjZ+n8+wM8Cc44SEvV+eQ07pMi+/IaoA0wikqZf5E191b
	 jJvrdoUNceCo4gcpyacC2riAlPzPeSRr4M2qdKgK/EPOZs0dYaiB0i6z8AhpsKBZa8
	 7KmgHIpYHYEjFY/rH1MCL8/wm8Hnb5EoqKpLrl0zyPiBBWxYEdDhXVofqZVJfIFm9G
	 Ux3M4CypnKFhPb2DoPn90zxFzvMILfHGGxYZETRamNgCTS9ZiX28doXWBxITIXoW2C
	 2HX4ShJDQI7Lg==
Message-ID: <sashiko-outbox-231028@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/6] mm/hugetlb_vmemmap: remove the vmemmap savings boot
 message
Reply-To: sashiko-reviews@lists.linux.dev
To: "Muchun Song" <songmuchun@bytedance.com>, "Oscar Salvador" <osalvador@suse.de>, "Mike
 Rapoport" <rppt@kernel.org>, "David Hildenbrand" <david@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>
Cc: "Muchun Song" <muchun.song@linux.dev>, "Lance Yang" <lance.yang@linux.dev>, "Qi
 Zheng" <qi.zheng@linux.dev>, linux-mm@kvack.org
In-Reply-To: <20261124110530.3004071-2-songmuchun@bytedance.com>
References: <20261124110530.3004071-1-songmuchun@bytedance.com>
 <20261124110530.3004071-2-songmuchun@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 11:16:17 +0000
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 34A83A0002
X-Stat-Signature: oje7hc6j743dguz6ofszuf1mgspi38bz
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795518980-894903
X-HE-Meta: U2FsdGVkX1/aDc9SJdK/aaZUobjco/mshtxIlAXGim8faYbd7rm37ytMLFD4/zT8MRBEWWcg3r/gHXYGcwK8cm1qtf6lk5L6NIj0qm93Z+WB3X7tVZyIM1EnkG4zHFuyikF2fi+RGCuTjLU3V4pI3aD6FRvlY+dx+EbVczfp6UTfupuzoXYiMSXldNNkGw1ZgWYhBHSdrOr/HNPxpEWrN+8dKQZWdbYLIFqf8MK/IHQMyRKM0lKx2ByopEviUi0lk8TEX8IWfxFxeXc9jDudMecmOedQl35/PDKm7mTboZGs4LQRPM/IyCC+GHGSJzIE/F/Hr5c3EQKTmSzfiuGSUW5NVgXSwd9/Qpb8G/h4KR/DYG22OBOxxLtO6ekysT0VWS/qX0s/SZf2d5zii/2DcrBRZVyFwm3Z+LVl0RZSTjL9S1ujZTSMCXh3qcUfTWp3WUA9sBFTvTix+SffLR+w5RMXwB573iSJfMaF9nf/A9j1gcaRb2SeR+9s23HZLD8VlFPcJlN4U0+zsAtnQuzBxNY8AN2m7iw7kPG1pIZT9LnSzVVnj2XvkdDg+7McGiyBHdrsLadw6WIubmDhX95WRr1+1AefiNPoIIIqCtSY011ZzBnmrmt5EH1UbluF04YPuXfa3LSu46v1EigAOjnShxWliP5jKh5JUfj0SXO4IbdzIaVnzKklTJ5H0R5UAcNJgpKbD7PIWIrxjKTnePMYwRJtZ3qXuuEnObxxO2u8zpKXUhLoAGRPJ5Lkv86SSxNfnCDoPAyzz/MxR8UWjMZz9R3q1s8V9GN7un8X0YpmL4L0FsDadLvrtkLG+XmAs5ZxqHlic+xPQC+UMO/FzNVSz6Tpr9cvkh1QML6+8rmdzxTBs9XoEND6CsJnZ8KGYGUIlnRnGZVM9uJSE4AP+/bvZinCRSPvv5ISd3wExpss7o05bhMm5NvzjAEJ1O59ClvXocCE7al/YLeEENWESuQ
 q7xouv0Y
 vPS4tVErqdvPv6AigbWh7QM+6uwicrJXhgPdm0jTxrfYcN87ghu0CHzs5p9fCPgivoM//FvMd0GvDSsvzuIS0dBrPOv9CgxDxI1ORR83GYq6zE8abR3yTIwp8BLeFJDHm2Qq1ZqqtDb01xtHOG1cnRtj+gSA48shF1KKItTYte1yZMjpZw3bACgVcLCxN+FBgRACnjZ6jFkhEj/HhmwgBVyuUOAxYQIh+OOZXpXAFj9o9uFHrWEt60LzMog9EB1K+IOv4NRvvvzwS4Le05KekLNBnJiL9/hP0ggyAxdc7pFx9aU5bmuRslHfe6uz4g76Mu5+Xy2Q22I5njy5amzTFcT/3NCAyvzf6J4k7rYPlVwyB7jt4WdOQu+V9GGcjjmw6+DOqW3Z5ThSsALsd8qXPAfReCVvxl8xAL1artbklS+YoX00BeVR6boE+/bdSOG3ePsddmLEhpFKuBmMbUSU1q9T+H+ZlOT7Qrsk9vDKBEaGdYH94VRMTSvSV5cZJEnCA2AfvkK5ac1BhrDPltIm4Z+LrKGqxxbTZcpHdxezNRQCGr2VyRuvmH8qkM0qxcV0jxs6uSI9inQRkaKQMqgll5CoSiSQlCREz/QseJuLdBXtWWdga/942KCIoC2eeFotiZmuVU5/4bvS8bnPwKqh61TJDCIlQ+skNbr9iETc2wXmL+aOhxNHszsxlYGEi824OfNDnTTtQT+4sY4CRF9T21awGLk0MPJHfBRzmKRx82QPGqY7uDmWkZpe9LaS6r9xP1F8VM6sE+XMoSKyYUAVumEqN1JSlQVLZ7FGWnvbgBYp6iPDbYOAVCJFrJO2tn/S7nRRZCs3RaTJIZ0+SGA0POcPhTOPm3aLlHPMnIF+lEDLDweI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm: missing const in !CONFIG_HUGETLB_PAGE huge_page_order()
  stub
--

commit 852c6ee3c3138346a4a6991f35b8658e23f3cb65
Author: Muchun Song <muchun.song@linux.dev>

mm/hugetlb_vmemmap: remove the vmemmap savings boot message

This commit removes the boot message reporting potential HugeTLB vmemmap
savings along with hugetlb_vmemmap_optimizable_size(), and updates
hugetlb_vmemmap_optimizable() to check vmemmap_optimizable_order() via
huge_page_order().

> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 0d5414392d870..b5b877ed5b92c 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -812,7 +812,7 @@ static inline unsigned long huge_page_mask(struct hst=
ate *h)
>  	return h->mask;
>  }
> =20
> -static inline unsigned int huge_page_order(struct hstate *h)
> +static inline unsigned int huge_page_order(const struct hstate *h)
>  {
>  	return h->order;
>  }

[Severity: Medium]
Should the !CONFIG_HUGETLB_PAGE stub of huge_page_order() in
include/linux/hugetlb.h also take a const struct hstate *h?

hugetlb_vmemmap_optimizable(const struct hstate *h) is defined outside
#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP and now passes h to
huge_page_order(h) behind an IS_ENABLED() check.  When a file such as
mm/memory-failure.c includes mm/hugetlb_vmemmap.h with
CONFIG_MEMORY_FAILURE=3Dy and CONFIG_HUGETLB_PAGE=3Dn, calling the non-const
stub triggers a -Wdiscarded-qualifiers warning (or build failure with
CONFIG_WERROR=3Dy).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124110530.3004=
071-1-songmuchun@bytedance.com?part=3D1

