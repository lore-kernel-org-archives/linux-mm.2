Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D40D9606A33C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 14:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VCXdsPfc
Received: by kanga.kvack.org (Postfix)
	id B0AF26B05B0; Thu,  5 Nov 2026 09:02:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA3F66B05B1; Thu,  5 Nov 2026 09:02:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BB176B05B2; Thu,  5 Nov 2026 09:02:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 745F76B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:02:07 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F1257C0A05
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:02:06 +0000 (UTC)
X-FDA: 85401229452.14.7E62E7D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9579320008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:02:06 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VCXdsPfc;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793887325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xsq3HeGsICcD9qR4LeaVPKieAjkKF0z7rahKgx3b78c=;
	b=JF2jo9g6h1/MKdOKAUQT1EQnMuCBGu9I4oDXjHI/pPKfMWKcALdWeEM1k/NTRIs2DsZFtp
	6t+pvwtfpnVkIGP1L8aBuPrOHAVegI4y5qkbZrla+mPuRrZg+XVa/jzXaUCvbS3DeQQEz6
	WTzhg4cQUphLB96fu+7eLThyVqyNx4c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793887325;
	b=61n+wiBAZmWBbnebgh0DUUnT2FPlbFqJGSn0jSOVnhio7decqyszPsrI3iSqHWdyA+6FSI
	ArKFPPwSbdPN4nKDDnzY1ByULGufY+zSBsl883ibwogxNg3WmJQoXN+PtjYQ6bV2qVlZCF
	wgl7MFRd0vG7LPWF4uefaB7x/FPrbnM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VCXdsPfc;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CA26260A97;
	Thu,  5 Nov 2026 14:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E023E1F000C1;
	Thu,  5 Nov 2026 14:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793887324;
	bh=xsq3HeGsICcD9qR4LeaVPKieAjkKF0z7rahKgx3b78c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VCXdsPfcQokl8f+rjLdNBL+YCFkzVLRKWrFySEE1WMzPl+ktC9vx0bBWrQsN9nihj
	 tI18V1AdcZLO2Wp4q/XVD+jddiqq8RxzmrwGeZc2I/5xJGlBmc/lzvB9ahZ8wbsrHo
	 2uxI2T8kn4sNtptex1MZV2ldZjPoTKOBNL315/ys3xnd96b7/OmUqv3SMvRknBUU6n
	 dlceNP+HUlg47v3tzKlUWNTjIKpN5HQZNGVg406HGvI1os0tGuxwamsSam0tHt6WI5
	 TLF6oIQU3Cawwx/shvdd/m82/qVvcUBjYJs1I074yQfHmmLWRCw4F5bVOdVN7WG+5r
	 flUIfgaLzHqIQ==
Date: Thu, 5 Nov 2026 14:01:56 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yonghong Song <yonghong.song@linux.dev>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Song Liu <song@kernel.org>, Jiri Olsa <jolsa@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Ihor Solodrai <ihor.solodrai@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 2/5] mm/khugepaged: scan mm's more efficiently under
 mmap_lock contention
Message-ID: <auyL2gLT3lDVqwMJ@gremlin>
References: <20261103-khugepaged-latency-fix-v1-0-a07ab16ac860@kernel.org>
 <20261103-khugepaged-latency-fix-v1-2-a07ab16ac860@kernel.org>
 <dfa01a1d-0b95-4cd2-ab8a-390da5ffe2ab@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfa01a1d-0b95-4cd2-ab8a-390da5ffe2ab@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9579320008
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 94ym33k9zwi7pf45hxui1jy3iuk1uqey
X-Rspam-User: 
X-HE-Tag: 1793887326-310818
X-HE-Meta: U2FsdGVkX1/ygHPfgXyLlxTfqzpTTQ94IL3Ql6i5sUuSv1sUg+/ZhDVm/p6HIB0pofAKkDGwKenym7m49fS9I8LYYB7Y3kM+gCD0krDGlKIkEq4r2CRvAzsAwUwp7IHT7l8wViRDj8ngupYZnN6W3jGltcrLpgyBKoyBVay8dOzVAZ7AAFcYMgMyqtvJKo8sYb+bXoue4LvYrlWm0jER5yAnGHRUrhphPtou5G/IpikEwtBYVdVFnvga/IMUR6yk1kbSaM2rp7hDEKwUo2/fTF0L93YymXOTTgCRaAplZWZQlBsJYuWiPdW4QKgTEUpHswuijb0l3cbcLuLjwcjQq/wtj2m2GvXr5dLgEQqgCIHfsKtHVM1giucxD8bzpND1MFHteXJDAhnoo2l3/+OCa57+d/Q2AyTmdwBg1oxtEgXI0PYH06vZ8ZjLVrryV4A24LfF7SLFZrb3oPCR6ndv8kwGPRXDHDww11E76I85W/+eH4r+V2pKes24frTq8SLLSbNt8Qc+EMAbu/Y3vU5qKTWtsnCvk7nKjWcNPOuREpG39XU/z7oe7VIUOG1EkehLk+kSzO8iloDevVHmqn6TvkKyG8td1JgUoK1PFUOSttF24yJM+IOVQa6aWaQ+0MES5IJmAYsj2to3xREbifSp9JMKgXq4EcdEwSXMHjly9owpXRLuJPhTNw0pBLlah69GsTa77Tclu10ID6UR0SPBMdn3Dd4uyw9epoSDId6hGFTQRDrxu5TRQrvEWufv+B+qCs9y6LjzwIXMnr/t9iiEhjaCSOEIRO4O0PLsGNofiw5S9U9S6TN1gPIlsWLnZwtJWijbA4w0udBVwpBzmAgWI3cim2cB+N+FfI+jX4a2wOJKKSH3SfyaKSN1uMYn+sgLNESm/xWl6Jc1tTazKNhQlA+2HUpqd4x7NOKDxt8D0iIhSRrRmbA2c63a2COtmLTiW5DjyIjgnuqZnzZiPlY
 AYhEye2c
 Cxp73iswMfRPA35jh3NSvzzo/RglzkxQjGtxQ25UuTgvmbeMHlN1GEjPFbvctn4YOC8HwlD2LxMs9nyErkAwYk1QKsC9RuVTmlqLj/XKvDekpNam+F0hlxFCc+LZlbyVUYj6pymkSO8TFnGsw8ZTmfcGvRlrpaMJEIwFMXxFY/+PYLknIkU+Qxss402wwLy2Tv41y5oLtksiTbQjZtn+NR8Z3Ac0z3vFxQmAneqUIdpspb83n8PrqlRnGdpoNGG9BaHGWLifrmwycce5tVn/GUcRlwYS10OrTxXYnZdQV1dE4TnQpH5BOKjPMPhDQ6wFwOlaT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 11:23:41AM +0100, David Hildenbrand (Arm) wrote:
> I could have sworn I saw a similar patch from Nico at some point ... maybe it
> was in a private discussion.

Ah, yeah, it seems a fairly obvious thing to do (as often these things
are), was surprised somebody hadn't already tried it.

>
>
> Am I correct or is the short version of this change "Remember the next scan
> address per MM instead of starting from address 0 whenever we continue scanning
> a MM after a skip; and we might skip under mmap lock contention" ?

Yes!

>
> I think a lot of the commit message above can be simplified.

The book author part of me comes through sometimes ;) Will try and cut it
down for the respin.

>
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

