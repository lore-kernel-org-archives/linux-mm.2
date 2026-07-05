Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9E28C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 22:15:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A6056B00AB; Sun,  5 Jul 2026 18:15:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87CD26B00AD; Sun,  5 Jul 2026 18:15:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7939C6B00AE; Sun,  5 Jul 2026 18:15:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 567016B00AB
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 18:15:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B5AD11C72E0
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 22:15:15 +0000 (UTC)
X-FDA: 84956129790.29.5CA977F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 03EBB140006
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 22:15:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Dd3TD8ef;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783289714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nXuLCJldxAxxF5W+GFvVR6nldqpJGGJTsZJb+RBW/5w=;
	b=XsnojsFju/dRHOyNJj1uEmzkG5QFGRzyqcYTt/WnoSRVRMAGiW0y+v1G47i7s+6Mftwi6i
	9GAyjMlArvmfR0xgeU9NNp8YMZMxaoAirxuLO3WHCx2RiXsrNTvh+N9JntlA9HWvC6OXR/
	fM3vdeXnzmZl7Y8fnK4dLVPSeubsjgA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Dd3TD8ef;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783289714;
	b=JNEOPH+8bLkp4VNkkMHo1ScRO7WgcF3icJm6Le+6IWEcKue942LdJI1bKroaop/PDlsGy3
	WSAAJKb4ANB8yDdkQURDTUXiOYpJOpupwtFl+Uz+tHA3OHGPqC5ECMjhG+pKZ4j9mx2fx/
	eGBoW5aiVRnMDI/CDpUrZ1ORhVixmhA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 32A2F600BB;
	Sun,  5 Jul 2026 22:15:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74EC1F000E9;
	Sun,  5 Jul 2026 22:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783289712;
	bh=nXuLCJldxAxxF5W+GFvVR6nldqpJGGJTsZJb+RBW/5w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Dd3TD8efaxwxZY6lOjY7jb6GwMR02CtgoeG20uFUH27MueOEGV8Zgy/bHt2K2ISOW
	 2O05TiyLAmwwdsYdc4DyW1YIDD/VSRH0S4/SaKLo0ExNUjuTMu4noPQvdH9UE6ciFX
	 N/+Q1kR4A55CLKJzSYlNnrwiIQ9b50SCD3aeJ+vw=
Date: Sun, 5 Jul 2026 15:15:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hajime Tazaki <thehajime@gmail.com>
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, jannh@google.com,
 pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: nommu: add sysctl_max_map_count() check for
 do_mmap()
Message-Id: <20260705151512.5edabd9bb5d11cb6f1c6309f@linux-foundation.org>
In-Reply-To: <20260702012830.667205-1-thehajime@gmail.com>
References: <20260702012830.667205-1-thehajime@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 03EBB140006
X-Stat-Signature: 6c5grmhio9qer87eto1u67cu6tazohxz
X-HE-Tag: 1783289713-973944
X-HE-Meta: U2FsdGVkX1+oAGh07y19z06o6Sd69Y1sA2FeG2KDgATFuUbBB7G5b2PPwyKbBkp2NQ+Y//av/8fSN7K50rYjf+daCGlL9EsvuxCvhK/HmLMK1y2fxs+8SN1TjenOgCW5SYCJjeq/UkjdHkqv/udODZdXMDFcCDswy18MSda24efxewJE4jI2OOYK4+V0YqgJvEwn4ptHw/8V5JLQXMK7LAPi6oS8CMP9i6nh9AwLx3D35e9ZI0WisVb7DQT2BXS/UaWXY4LAlSGt9tYf8iNbfQ2fLpmerFL9WQzk0530T7XNyC3TQFatTPFjCUu2O5u+dORdmYUo37jsxBWGM9NlCVeA8yu+pdJrKt56rpePxw0u9eB2nh4XhyWusDoiHhpYBXqFpWBW+skINNni16vM1iyRrHO6Ic42mNVaXs1Dkv6YMhG63kaNtAHgPB7lpZwxhmw9xBeSYqmzn/d5kC85iMsUyFfF7s6SFjCdtvsNX+nQGRhsFJX/zbKevI795tjEk01NtMTliK/P4cljAGHn0QowxR9KIpkEh17A0gGj6pdep0xU9hfyIqi7EsgJggWO9tympHdR8VdoUjOQl2TVNZS8j/h+k3GVYeVAO1BcSLB4t290MmFEv567O8b7kGdEFnpUsdcYjwekEZ7y3J4XhOnhjnSjPIec4oq6X4VnwVRBzqb6+6TIjyLAO6Xac5USLkTD3xDQ/Aauxin6oHrkIxAkSJWeMlRKoogQyCMW2LTU7J/mmgucgvE9EScnegZxlolRqkUqHa6/NIg4jDaAojl35C6iZ45xrvLBKJjOaQSRUhgP1fmBnlAurL4035dd5UXHpPUHAySmZUrrXWFDdkWe0LuujUKeeglp/R74AMFjsCtfpXrcz4/hZYLCFDPeSEFPHFqBzSs1ZZh31srnwjv5i5vzFGSagNvRp6h8ULsvsgMo9/RtXTGp2pcN7RktimbBlEip3bjHxza2qCF
 F0RCAede
 yOvVMho9Xhaxmxk3Du100ktBX7x3MPb7fWY/1BOPGCVhPiZFixJEZYctmjmZa3osIEM6BZX2e6JMI/EH/ad0CrhLwtW/D0q2+ryuBehmdVIjXhtXtG4oSV8hZgnnlp9o4a98ME5C1uB8m+TpT3iYOUtxm54JIZdhpkxS5/XaS54UWsvDSfiWQruyvk7dwmKH+y3MDg5WDPeDZUpwsaNuG5WpbdhrhLVGX6s3UafXvLH2Ka4ya10eptQ6I7M5QfwwGc2L6awIPjUnmfa92OrD2WGnwgUyaqLPqpBhGb9kf49QPDNYJGYK5jfeIfDhyc/L6rSiFfa1qTkM/cbhhUkMhUHfI3Hy7F6xxDbwOkMUnoN541TRQosDvv8Ij9FpnyyEeX1EN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  2 Jul 2026 10:28:30 +0900 Hajime Tazaki <thehajime@gmail.com> wrote:

> The sysctl variable vm.max_map_count (sysctl_max_map_count) is not
> expose under !MMU case but used it wit the default vaule
> DEFAULT_MAX_MAP_COUNT as a limit of count.  This is currently used when
> a vma entry is split into two chunks (split_vma()) but not used when
> allocated (do_mmap()).  As a result, even if users request a large
> number of allocate memory, it will keep allocating until OOM happens.
> 
> This commit introduces a check at the begining of do_mmap in nommu.c to
> prevent this situation.
> 
> This is detected with a LTP (Linux Test Project) test, which linked
> below.

AI review flagged a couple of issues in the current code, one quite
serious:

https://sashiko.dev/#/patchset/20260702012830.667205-1-thehajime@gmail.com

