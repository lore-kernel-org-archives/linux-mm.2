Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB5CCA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 22:03:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EE6E8E0197; Tue, 12 Aug 2025 18:03:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 177FB8E0196; Tue, 12 Aug 2025 18:03:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03F2E8E0197; Tue, 12 Aug 2025 18:03:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DFE118E0196
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 18:03:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 72291115AF0
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 22:03:35 +0000 (UTC)
X-FDA: 83769482790.01.C4B1100
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id B05F080013
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 22:03:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lsQi2ZUe;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755036213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EWdqftYk3EaWeCO1FjUtaqKykBdBlqKmEG93jk+LFUY=;
	b=c82S+GSqHihpFSJec85om4Rds2lEMY/7AImfkoiFEEOFBGLPR7F7O3RNQZABcLL3a3/4sB
	edzTIFdH6EA+8V5V7ciOCOUbHpZwgk+n8uPZtA8SJHsu1/7+4tWaksol2Ia6t3vlV9cddq
	AMfagyRMjJdqrcpMOkapypv8fCHNXJU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lsQi2ZUe;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755036213; a=rsa-sha256;
	cv=none;
	b=Sq7gBfPEZLYyOCLoPpcK8TcG2ECweahKXJELHYZ+OUsjKuTyYAk6v/YL4NRhHt2c+QIg8V
	Mz42gx7Y3SFDiZ9LOyXEyLCYVY7fdY0tA0yC0F13YyEldNAGTY54Jz9L1oNSwYZoS1Xtq8
	S81s7aaJ+nUkDUbzjFMJsZ2pHwp4+gQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5BC8A4413C;
	Tue, 12 Aug 2025 22:03:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136E6C4CEF0;
	Tue, 12 Aug 2025 22:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755036212;
	bh=exvvZP2rP+R5jI+G7rsqT5N9VfuXc9aPekZm6d12tNY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=lsQi2ZUegaHNI4h3O3XuHaqI2JTiMeCPKyOIncLGwlszYvrcTn363rIxyKcGmPW+8
	 zTD2ur8XXDWwW8ZSJoK0s9GSaKciMzayx8DWNBa2Ed3tpWlaCTWvVzc/gHT/FNAfVM
	 9ZhgKdef8c0piqe25zuYDgg0sRyGLrkP0DW4Tc1k=
Date: Tue, 12 Aug 2025 15:03:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@redhat.com>
Cc: kernel test robot <lkp@intel.com>, llvm@lists.linux.dev,
 oe-kbuild-all@lists.linux.dev, Linux Memory Management List
 <linux-mm@kvack.org>
Subject: Re: [akpm-mm:mm-new 101/118] arch/powerpc/mm/ptdump/shared.c:70:1:
 error: use of 'pgtable_level' with tag type that does not match previous
 declaration
Message-Id: <20250812150331.cfe4090372c3864aa768fa7f@linux-foundation.org>
In-Reply-To: <522f31cc-f250-4883-8832-0d26ebf5210b@redhat.com>
References: <202508130304.5FJqRz2c-lkp@intel.com>
	<0c96fa0e-6f7e-4cca-8d57-f3e3786d44fa@redhat.com>
	<522f31cc-f250-4883-8832-0d26ebf5210b@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B05F080013
X-Stat-Signature: xrmie4wokdyfda4nzeoe3zyierfbaoxx
X-Rspam-User: 
X-HE-Tag: 1755036213-146547
X-HE-Meta: U2FsdGVkX1+2enlsNxPklpcpxwvXOLjKoXECEmY2HvH8PXPq1Iip1p7VHHF3+KIkD62x2Cr1E/HgOY5zmiNZwO4zbgSacyOE0up4//n6X6Wq6PW4Kb4RS+T8UEdZpFvmh69wVnnU5R0YwdWeuFuMvTS1CUjmSKtqP4xdctaUn5sBi7Fu2pMjhG8hblBOpTKV4FhGwD09qAzFBrnx6nBOs4LODFjBvls9ZgWynUOtMZ8/CqOUJFp0I/VVmOgHO/YGBl+GgqOfmFCRpnXim5le+7L0T1k3niyZZicNj4zdmrlogKNTBeCXGyC6H7kaY+AnHBZJqsgVocdMMXdswMp0JTG//GCKCupMYoDPaQvdaCsk3uMgodzIjwlBX4X/1nZR/fW+6ZfDjS6PfOQn6RXDajnf/k89WhoOzPqTpuK8VKeVVGasHU+5QWHOxtqmN0Cfk512cAby3QHWm1WeL/74Hvg8ey5lAlaoL0WHb6uSP93TmNxcKFSOM7h0oxzmTcJ424OIJJ2/qbr3hLVHqTxRwGMNmZI1h2kqxCbTs4qwq9rWBy+4k6GZ4KVqGct/66othHIKT5BNqWvQsCf2RMmBrEqDSy5ReI4n3Q3+dZ55p/BQcno+0pOz/M1t2L9zU+X81FfKKKGtftAE07Uy4KyV2AqLnH73dsIHv+OZQz3apjAa1sPckSjcj064W/6l1XvDfNJeZfu9WDeLLwChjfzD5S3lGVHOR91C5uJ9u9FY/fRcsZQFGJUG7X2mNeddoo4Lvv1EIYEdUkkPSqAQACJ+QX+wMrbLyMqgeAUVwSU46jALlIPfcwGopujYHNmomBpyH/rqABce8xACR8gyzj6Cd/z8dXo+3Hn9Yoz8R5c5CW1DEo2bA/YZMqWqKX7+c601bPBpPfhI3HId32lmFmVoQ5X0SV4ecVk/Rx+dvuWkwCAXNXdQG7/9c2RMSSMmfvT9QLqzAOAB2/AFiU2ZHKH
 Ypy0Cmxb
 xDY6oX72PRMEvTrFUmlvAGO/TyNXZjG7e4bg76e5efsxNRi7rvOrompxv8n85ZHXkPFeUyBiGa6F7LQEGk9hBq6E4ZosK3oQZjh5JkOZhYvRJ7qQqKmXlCFitarnmNxx56iqf/vvB5uoHayq5umD03KPvn4nXxAgIqEJsmgFZVzMexQkCJ25lpJ04DWggtrxfxDNNm+mVIJEsdG+Y1KErZgbwHchITvi0/bsNBTAT78+Vi8D+nDXAZ5ik2+rtt9P2Y9n66r8LvaD6VykJ1rgrbRo1XRmaQjgdkgJUJDWlyWuLAEaz5fuQ0XOr/KlmBkzkmMdoT6VS/rlYLeRFac1qtrUBxLCsz5pTLuX0RGDrX36/OJn4fLJ+i4H54w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 12 Aug 2025 22:57:18 +0200 David Hildenbrand <david@redhat.com> wrote:

> >>      3 errors generated.
> > 
> > Huh, I cross compiled this on a bunch of ppc configs, but maybe not emough.
> > 
> > No, on the branch I submitted that did not exist.
> > 
> > Probably due to the rebase.
> 
> Ehm, no, Andrew, could it be that you accidentally dropped the ppc patch 
> from mm-new. I can spot all but that patch in there:
> 
> https://lkml.kernel.org/r/20250811112631.759341-7-david@redhat.com

yup, I totally missed that one, sorry.  Added now.

