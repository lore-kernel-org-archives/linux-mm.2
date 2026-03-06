Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F136DF01825
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 11:12:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 664796B0093; Fri,  6 Mar 2026 06:12:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60EEE6B0095; Fri,  6 Mar 2026 06:12:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 511496B0096; Fri,  6 Mar 2026 06:12:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 39B006B0093
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:12:32 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E22511B7F8A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:12:31 +0000 (UTC)
X-FDA: 84515374902.06.C62D2E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 42949160004
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:12:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jEvdu6gn;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772795550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nVHR+ctvMJLIt7XjpskcNJsliA9Ir3/a+o9mlmeey4A=;
	b=pRaf6nzLjwm/vPomY+PY0DneL+/pEV7cAj+uetD/4mcrCdWp0KiXWOimRKQcabBCZSWGwA
	SYkY8y18xSf9HQFvZjMRkNjvEtEGYLMK1W7xtFaHyecBf5lmPCUD+z1HIyJ3/udZ1SjhGl
	dcH0kmrJvV22RsjLl46yoLZGGYT/mUE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772795550; a=rsa-sha256;
	cv=none;
	b=O2a5JRYIz6kkS8dHshqinqaUzEz9wn0CAIFOmoKvNbtYK1orKuEbJEaXOa6pxDvR3eTeNz
	csegtTIBy3wV8sC+pT+GFIeO9Fir0ER2PHyE5mvXJWFuUr/XLs28oO61jjyPPSGymr7ed/
	gE5kZ5/USX73dHz/tdpS6KXHeQYATg0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jEvdu6gn;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C1D2438A8;
	Fri,  6 Mar 2026 11:12:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3080C4CEF7;
	Fri,  6 Mar 2026 11:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772795549;
	bh=0Ke5eZ//15clBpSAjnQRnmOa0hryc2fy44XRrBa5OZ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jEvdu6gnFrMR/jaM1eC2XOup9hwsvDUiBF11qNOw09xdkEyBBO9FAE9ams+odLwvd
	 33sBKFnJaUA+PNxEDQfpwSqHvWcGNBc4/7WW379CL92582oYijNtnOOELNIR6MKgyw
	 WP09l3vJL1R65yPpsXkejCBvIOx5CypvyWMn4ywh8jJKvKdQXERPnkBu5Fey7G/0J9
	 H7CGTyaXAEQcbhiBzD9f3vJCyhgVzdz3tDU/OErQ80gE4HJXgLniNvA4X8G6Sby6d8
	 cKW4Ximsknhlr+thYxHOXKZACMFOoz8Yw6/gYqkEXcSy9XnOMWPMmnb/hSRgpczViu
	 XJcuAdCXwXIcQ==
Date: Fri, 6 Mar 2026 11:12:26 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
Subject: Re: [PATCH v1 4/4] KVM: PPC: remove hugetlb.h inclusion
Message-ID: <7d708a94-d25a-45cf-a49c-a86a6d1be753@lucifer.local>
References: <20260306101600.57355-1-david@kernel.org>
 <20260306101600.57355-5-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306101600.57355-5-david@kernel.org>
X-Rspam-User: 
X-Stat-Signature: ehnmm8sn9wcmqapuwjmiby19t5usjtkf
X-Rspamd-Queue-Id: 42949160004
X-Rspamd-Server: rspam03
X-HE-Tag: 1772795550-46686
X-HE-Meta: U2FsdGVkX18/VH8O83NaRbGdBWFTdv8sy/CoFPxbKmGpHSdD9MrsP2Guw1gP3e/TbQJZ3KU+q1pTblZpPIGGJkHRbz8sOZPsfZULe8T1zStDoJ7f807fLA25A+1ek2SdyXjWL3/VJxoWvMTgdVKsYca1rAw46IfYOZAlLb+4srIxzjyMlU836iC406vi8rS37DLXOgJyWCp+wX0QQUk511CcO0A4WfrxMc1iO7cr+6obEynkpFgp3vw8KKOwBFsFaXqKm3iJmPrfKWbn0SKUJ74i6I79eUvggKCx4j9dWu+FAKRf7xEKHskbV/zjX0tr0zf4Ia2s4EHn94WTFzSNCDhx+/egYb3I9WHtnweVIQuoLUfEJ/9dh4sylK0ez43fuyWSzUUOeylFVyw7+l5kik5jIYyJmifkrezEaLAqKjnPqHGKtmTrD/0wQZtfLFSl/dzLxLyEOYpTHN+TmOw6WlcZYvOH0fEqo1LsKf1E33L58howiha4Zj4pUQ1dKZhz2NrGGuRodFGK5d1OQ98QomI+nlbKw8+kfrlPc47HsLkzx+i6w76QoC6xSd0Vesn7dRdOREA6jKhQRefy89zLKgjMQYIVXuZeMzZxEYFcPFaaqGpcghQru5tfz8G0N/aQklLKay7b88FyE50JzdMml8Riwt1DCcDGN/qao+dQysjWWWyrwS6pMQRLRdb8C5sCEMAnxHVMjqsxWapy1h9aElE2THFsQdGbFdjaHUqMtkhMClmWQSdzB96ZVzoo7EoO2KA2qMqZmFPps74ZRD28JK0wwHf5LF4lOXwj31W4RBo5437izg/OD3k/S4m/3AA0S0G/YKKCje2g++kz1gMAsCC4Zsb7alroCPppDeBVKCT6v5d4f3wOIT+lKmvY6vbmdgZwJLJR0TkZnnlCisblqI+XMiuWUOkZVZT/zv6zmDexSszLykcpw9AI7G1tzbZIny7eXFeItwdkar/a4D7
 smxg1jej
 mYfmekWe647gyfu2fl1aHFfu/nnZd8Bp8m/43zHYg3eoc6/9dt5Huete3yKDEPj2zsdlaWOJdWeO1LXWIho5C2B4UpSxqdB9LDvDSnkhF7BkyiP/3pGKfDKaeYNBVCHho2+2rm2TnTkwABr0pZJLpYFQb0mwzWe6r6tVxhs/DiQttq3szbd995+Qs/JHA2+bjpDul03mZ+cDLyGRxPvZ7WeXbc+GQU7BvyAuNyUeJApm6rjI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 11:16:00AM +0100, David Hildenbrand (Arm) wrote:
> hugetlb.h is no longer required now that we moved vma_kernel_pagesize()
> to mm.h.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

You've gone mega cute on this one too! <3

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  arch/powerpc/kvm/book3s_hv.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 08e5816fdd61..61dbeea317f3 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -36,7 +36,6 @@
>  #include <linux/gfp.h>
>  #include <linux/vmalloc.h>
>  #include <linux/highmem.h>
> -#include <linux/hugetlb.h>
>  #include <linux/kvm_irqfd.h>
>  #include <linux/irqbypass.h>
>  #include <linux/module.h>
> --
> 2.43.0
>

Cheers, Lorenzo

