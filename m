Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E119CD343F
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 03:24:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B61226B008C; Tue, 12 May 2026 23:24:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B11EC6B0092; Tue, 12 May 2026 23:24:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A28506B0093; Tue, 12 May 2026 23:24:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 92B746B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 23:24:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2EAE8A06A3
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:24:43 +0000 (UTC)
X-FDA: 84760954446.01.A698619
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 622491C0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:24:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xd0V97Ck;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778642681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MYZpouVE2OLehGyAa7PaE6T71GlIlZTGmcLnilYkS4g=;
	b=CFA8O2i6X/B58O0sStRaloZ0QzA4UyGPzWSJargQDj0LntmkPDAbe04t6uxJZlMmb1UGq3
	CI+V9XBzVo8q3L9ZSbkHgoV0hS0F/DiSiBzfA6dFDbspL4VA2GHPEi/fbl6PYSDRO/2xzD
	ztFQBbTP1qVmCUciRLDRwjO7KVu6XTQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xd0V97Ck;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778642681; a=rsa-sha256;
	cv=none;
	b=lSuVKUn65cHerRTA2qSOC/I9ujUHeRE/2Q4kYkMXT3AVOU/BH6uWXdWHiXW3ab697CMgQf
	/ehckb0iEY5y2k1OairpQxFRPHJ7NxMZRlZ7f3Mr2bza54MYSYla9qIMe77LkNC1u1JKo2
	5MeQE3FWRC6kQv9+7XELtw3knoaF0dI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BA3BA60121;
	Wed, 13 May 2026 03:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6B5C2BCB0;
	Wed, 13 May 2026 03:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778642680;
	bh=WeTxWCELMc05TsXWrycjVf+KrYRziDCqbR7joXkp6tw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=xd0V97CkQEyg8x1FCAD5O8fl3kaLAs6QTAlIzAN8i7h9BDqugDelSjLtLWiLpt82w
	 /lo32+w1a5m/ikHJozf7RS3jC3KMNyJPQRApM3skBLRvETu1vUSWOhogkx1RkNfRkY
	 WVNe7LEJIPK3i85YpX/8OCD2wwknb8wg1/pXfZt0=
Date: Tue, 12 May 2026 20:24:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sayali Patil <sayalip@linux.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, Ritesh
 Harjani <ritesh.list@gmail.com>, David Hildenbrand <david@kernel.org>, Zi
 Yan <ziy@nvidia.com>, Michal Hocko <mhocko@kernel.org>, Oscar Salvador
 <osalvador@suse.de>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain
 <dev.jain@arm.com>, Liam.Howlett@oracle.com, linuxppc-dev@lists.ozlabs.org,
 Miaohe Lin <linmiaohe@huawei.com>, Venkat Rao Bagalkote
 <venkat88@linux.ibm.com>
Subject: Re: [PATCH v6 00/14] selftests/mm: fix failures and robustness
 improvements
Message-Id: <20260512202439.e71f233281428ff596dab0b6@linux-foundation.org>
In-Reply-To: <cover.1777877814.git.sayalip@linux.ibm.com>
References: <cover.1777877814.git.sayalip@linux.ibm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 622491C0005
X-Rspamd-Server: rspam06
X-Stat-Signature: dtp33mdgsxbz6w993ye74p1zcm5ggd4f
X-HE-Tag: 1778642681-882849
X-HE-Meta: U2FsdGVkX18lDv6lZPBWRtcouRdBBllhrpTr9KsYpi11j/cJNE6P708iigO47QKDgD/FnnTFbcirgUC3RukySsDC2/6ARF0ShyGiijiwsk6efe1gpU+GWB5Ooyh0xE0jkNSCmDbHcYIJ4jSOL8epgQk45fZ8oCYc9apm2g4c5638RbVBPjbw3sINh0HwT+UeBCnkeBzqZx6diFCGS5v7IY1nFCjuKy2Fa8BCjMSXppdYc98fP1p85b3nhrrzmERXoK8AHlTtcCclZRyr5apKa46CAmM8AMzYwJR8Y09CSx3RrVOr0/18YKbBAFXTH6Y3CFxchTMGChxy3ytm9a/3ZmBYJ6+0PCWPjDiSHZ56ANS1CJPmvvhPA3GhaHe8RroFbNQbKHZp+AuGEfaFOkrA1L6ROkc3TNQ6aKAWK1hfCQRBl80BywgvAgFgMFNdjx7yZDvkOUB0hhp2d9duOvofhB4yc304u89rEn4oiIBR4q22tj9AfwmdRRpbM1KlYIc3crOizj+OpJwnfMStbvWVsKZHht7sdsSk+epe8kGrFRkTiwkb73XqK4Wu37rdNANIKgMxvDlY318HSKRq367fd+L/27nYan5x7d8LTy1hfGbvxKDvIRdskoIeTtoh3xxCFro5SIzGaxe3PDBBN5pgqVK1APk1jlAVATqMZutfeLGacKGjLrBFzzQc1pwZ1vqM86SHrRglqDUb+bKo4L+2O0r5/xN0O+lxIrx2IVJsxx/mQEdGZzzCFAImehRyFBIjTl++aPtYphTJgNUkUbn/q49l3G9OO8TU2enAytrdmuMrQcGwEL3OfT94XNxiiq/g05fIkNW587zrgxzfkz8pqyQA0BRJZuPgLudjfyDAZJYeRQWfwCx2fnifbyBk468A5jHWFJ8ttnYAeHbqq7SvDHcesCwXAU88iFI7YS3bbtpDUOLFY2fL1ixHGozAduVn6asFb7qAW68YoP6NSMP
 nJKCODcw
 xDWyQE0Hg7M+u9Ns4AAdRtyp85moZW6bJXC4U/b7qDHGAgu4cWzHkvmRLVciRCz04XcUhl2sQ4AZLTLE/Ey/2iJMOYW6PVuSAOeM7zWxIt+lelhHKim/x8zPoXSVrYd20Akc25QiB3JeY01wZDT+x3sjgbhbiTYaT2Gvahw839CtvbE9I9GtdV7X0Xrabo4gwyp+W3tXERwXQlIhlnYIudRuk9lrw0lbyufOLI0ytu0kbZlwlOSLd5qVLhUbW+dbV9jk6p1o/9+ftI+iT4nVB/xU8+BaP7nfqLTZV8VNjK9DiAAt14kRSMir1PGebZS989N7OH6VHm8FsX3P9ShX1BztjRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  4 May 2026 13:54:37 +0530 Sayali Patil <sayalip@linux.ibm.com> wrote:

> Powerpc systems with a 64K base page size exposed several issues while
> running mm selftests. Some tests assume specific hugetlb configurations,
> use incorrect interfaces, or fail instead of skipping when the required
> kernel features are not available.
> 
> This series fixes these issues and improves test robustness.

Sorry, bitrot.  Mike's monster series "make MM selftests more CI
friendly" has moved a lot of this code around then altered it.  Can you
please redo against mm.git's mm-new branch?

Thanks.


