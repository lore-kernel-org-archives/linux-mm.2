Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2572D606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 10:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bs9n8fVX
Received: by kanga.kvack.org (Postfix)
	id 1570D6B05B5; Wed, 18 Nov 2026 05:20:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12F546B05B6; Wed, 18 Nov 2026 05:20:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06C866B05B7; Wed, 18 Nov 2026 05:20:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DB0716B05B5
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:20:10 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4B9CA160614
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:20:09 +0000 (UTC)
X-FDA: 85447844538.15.4ED474B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 990AF80003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:20:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bs9n8fVX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794997207;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=POAfG/hlAXEXQEmGrFpMganFMdPp+WfGa1v4PFN5VbI=;
	b=R/CyJqMxDN2QLVXwyp3lk/IcrIQ4nn6nlyJmgzovjL0nCVtPPJEhizPrOx5+gBCUmDRhIr
	6YqqvMfjiFa5G9q0l6OgaZ00FDbn0GenOMVWlxDGAN0iQPKdgTN7vmf1lmep2S7YNGmcni
	fzDLDvWPXF00KrN74xsTNvGXbAxfonU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bs9n8fVX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794997207;
	b=f72w0DMqTxb9KMKTDTDFc2uH5H9HeCuN0YNB6GcpBgmNIj7JxsEjw9cyvNfg34gW1E4IO3
	3qxbZSHL9Cyw08D/h54qmblKzUaxdpWIgWJ+nAXvVs0TkWB4nUVfR0kWv4h67163AWjVqH
	8WhMvX89LKkmYzG6LRyMHwHPNmIDAVA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C926745757;
	Wed, 18 Nov 2026 10:20:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 261C91F000C8;
	Wed, 18 Nov 2026 10:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794997206;
	bh=POAfG/hlAXEXQEmGrFpMganFMdPp+WfGa1v4PFN5VbI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bs9n8fVXb9bEWESdLWRsXU8Cv1StN59XA/rJHcR05QfwKw1IUHVhC7Q9ww5fsdRR4
	 tjOHHJkVWQuDoVnAYJq6Bm4nxIq5qw0jMBchNrEzTUV4dYnw1mALCpyZY+CTWaeB53
	 yFBBcfd6GDBxjlEPWa6MLHZAhtzNWkaRPhwZiW7jav+HsjQ/YIDDsiU62VGTLNqlDz
	 szQ1yhr3DoJ8WcEYlFi08JjBzPLJ/xesWUqcB/2eOv1sBf4y1IM2UCQ54odw2/mPzJ
	 t30oU+CSlMUmQeupvCRgtpvyIIA634oTrtQYbqm1PS8PbbwsDF+EKXt9Tc8LOG0084
	 n70Qc2214EJBA==
Message-ID: <sashiko-outbox-220674@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/mempolicy: limit compat bitmap reads to the source
 nodemask
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?R3JlZ29yeSBQcmljZSAoTWV0YSk=?= <gourry@gourry.net>, linux-mm@kvack.org
Cc: kernel-team@meta.com, david@kernel.org, ziy@nvidia.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, ying.huang@linux.alibaba.com, akpm@linux-foundation.org, arnd@arndb.de, larips <larips950@gmail.com>
In-Reply-To: <20261117101910.1820066-1-gourry@gourry.net>
References: <20261117101910.1820066-1-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 10:20:05 +0000
X-Rspamd-Queue-Id: 990AF80003
X-Stat-Signature: 51aojrak8s8e73jit8uydwgwonmmdd13
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794997207-317826
X-HE-Meta: U2FsdGVkX18oJHiVTDyNFFCwhLM5rWcFTQU/KcgctBosMDs1tQWV5hwS/Xym6wOxKkj/gqtDMobIfIiFI16/ZEq4uJCHyAOC3125HiBLZ3OnQlB8gw2yOxoHQ3b7Wv5D5K23aW99ZkaW58bSGIkx0+LI0xMuXdeIjtPf1zj/5ZSpuCqQAynpZaUe+jfM4+QfXc58o5Rx95QHCIpwyPUONPn+fgvE21M0GjJiYr17BdJ9BNX75m1JBqFIoIEjSvm4U++f92yhiqFGidzq5oK9wxcoO3drZk72CeN9Ks9y+p+jwb8t/gMC/iznaYbeCJvnj4YNP4o9hzhiRMiZamC79F+JpP3kmp4ZW7rDkUTvV8G5zg4w9zUuOLXeaDeQ4oUTOoAjX8Gvq+Gp+izWiJObrk+UPO9jZVxaxUUDtBaEbfav5pn/vvKDhVM8C0PEaFrEIhrSe4cjxUHPy2uaJweJYvEWFc+wnRoIFva4iNwBFaHFMwSBJuw8LCgWy9DLDxVfpp4nO+LDZiqeZhj6GmdArMVhcv1SSxYE8Z1IyIGIyIiUmQ9TxH2XgGFQ9JLAnAM1eNWUuDd01y7yQPNs7MoC4ojbQsRz4UC0nsfOtGQ7bribecF+OLwTMtjmgP87kNU6Y1R2UNRl8OtS8FB+owrI6XHF44cfKlNmgg3PXRxX0kPuBA9Hy+w3L3QceqPsC66PnQEJPphiXGHMHk1yygAaIxwvuCg6LIS6wZoKglII0YCo26JpZZwDecNfYyNyVdNew/LdqCtyWS/6nBojFCBzhN2hKnK88U4fucasWMS0cnBfcHVl2L4K/3sgh3s2Kp/lgbCoHXBC4jFhLV/pSz+fxbSSjRQ36QLSfol4UYwGCK5kYs1ssUHNYMXJn1B5c6ZChs2GzMjD1BqNBIxLidQyi1XnLwFcyr975FFn7Ero07qwUB5A2q8GrtoMOC2/9O9XTkT0WC0xNhYeMbgL0DH
 W8c/21GW
 hMUqu+cuwe0MEmmcnpBw9h+XyNC3q7mX0MWRjYuznZROvedA5StD6uf5ozWhZoxy+cvnLxsnavKA1zauUqdQuKXniGrFjuoPAE6sCi57bwmo4FfwXivQcbl5o8C+iA133nypSTrcZ5fvbJX35Qk8JV0cQy3brxX1a/f5siCfE81aqMXZUFFD7+09K589bhSh4Ak3G+tf0sXP6WTsYMFa42KVXo7MyTSde9nvhDJBKTPCFznaaGXdMKOyOIw9BDuaRhSOfHDygjYcYZl38TMFNQIrPskcR9T0sj9Dicto4CUydCHK5sGm/DvN3fDhMe1M8GBGrt+V0Xb7mVS9G/FUX+svLZUGEbEjvnJR2ZJb8UM5NJfoIXfZAh6k7vrpZgbeFzljXIrNhiJWf5MS1zT2F6OleoKeoEDiOi4MBFNNcK5dAFlOdddFFyYoVEzEi53QzyOXGRzbxdFFUPKX+L5HSqcEvNGyg2slMWCCuTxnq2HrzHxU9CZImWlkbwa3Abxe2zfkCypmAKVmdAkxxfz/yPDvCum6dVeCJZdY+pNRjPrbBalMKp7YHoL8oOZWdng0+/kulW9CyAZwc/Rd4wzhUMMryETxWpRA6CMyY/daNSkeXMSpa5+cVs3mcqCW+oIpgJ9ApNErldKvqRW7O5wjf7dc6a+pM/zxUR2KfoHU5nkgUQ3G9euo4t6Sf4hgfVGUzkhdC5b66Hxldf4w3aS4U58No/IfaBZvf6E9Ggsgl5kzOQ1E=
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
- [Medium] mm/mempolicy: compat buffer overflow in copy_nodes_to_user()
  when maxnode=3D65
--

commit f6a3a5979382343bb522ac36af5733f2e67acb24
Author: Gregory Price (Meta) <gourry@gourry.net>

mm/mempolicy: limit compat bitmap reads to the source nodemask

This commit bounds the bitmap size passed to compat_put_bitmap() in
copy_nodes_to_user() by MAX_NUMNODES to prevent reading past the kernel
nodemask on the stack.

> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index fb627b37afcbb..7cfcb6b49c542 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1738,7 +1738,8 @@ static int copy_nodes_to_user(unsigned long __user =
*mask, unsigned long maxnode,
> =20
>  	if (compat)
>  		return compat_put_bitmap((compat_ulong_t __user *)mask,
> -					 nodes_addr(*nodes), maxnode);
> +					 nodes_addr(*nodes),
> +					 min(maxnode, MAX_NUMNODES));
> =20
>  	return copy_to_user(mask, nodes_addr(*nodes), copy) ? -EFAULT : 0;
>  }

[Severity: Medium]
Can this still write 4 bytes past the caller's userspace nodemask buffer
when MAX_NUMNODES > 64?

In the mempolicy ABI, maxnode is 1-based, so a 32-bit caller with a
64-bit (8-byte) buffer passes maxnode =3D 65:

mm/mempolicy.c:copy_nodes_to_user() {
	unsigned long copy =3D ALIGN(maxnode-1, 64) / 8;
	unsigned int nbytes =3D BITS_TO_LONGS(nr_node_ids) * sizeof(long);
	bool compat =3D in_compat_syscall();

	if (compat)
		nbytes =3D BITS_TO_COMPAT_LONGS(nr_node_ids) * sizeof(compat_long_t);

	if (copy > nbytes) {
		...
		maxnode =3D nr_node_ids;
	}

On a kernel with CONFIG_NODES_SHIFT > 6 (for example MAX_NUMNODES =3D 1024)
running on a machine where 33 <=3D nr_node_ids <=3D 64, both copy and nbytes
are 8, so the copy > nbytes clamp is skipped and min(maxnode, MAX_NUMNODES)
evaluates to 65.  compat_put_bitmap() then aligns bitmap_size =3D 65 up to
96 bits (three compat_ulong_t words) and writes 12 bytes to mask,
overwriting 4 bytes past the 8-byte userspace buffer or failing with
-EFAULT at a page boundary.

Since kernel_get_mempolicy() already rejects maxnode < nr_node_ids and the
copy > nbytes block zeroes any trailing bytes up to copy, passing
nr_node_ids (or maxnode - 1 after clamping) to compat_put_bitmap() would
bound both the kernel stack read and the userspace write.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117101910.1820=
066-1-gourry@gourry.net?part=3D1

