Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37F6AFCB619
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 15:31:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97DC16B00A7; Fri,  6 Mar 2026 10:31:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95B4F6B00A8; Fri,  6 Mar 2026 10:31:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86B406B00A9; Fri,  6 Mar 2026 10:31:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 760A56B00A7
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:31:00 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 363051605D1
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:31:00 +0000 (UTC)
X-FDA: 84516026280.19.65E69A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7BEC480007
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:30:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NoF4well;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772811058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vUfo6geUlLgmheYj0TiS5OJJ5PkiuTaIbtAjZT9aCig=;
	b=zwE4rlANUda7Q9BlCN9vZnGYNSTUWZ/9WMOzLh97E21RKMGJTguHfdic2DIOUYS6mbItIT
	kqjUHgZFZZlcnGEwNRZKlqjL7k1bmC/Y0AGE2thJRMNy4KzKA/p5+T1F3YGhLTH/RxzmCb
	r+LJvBS/p4ezNxnzy2A+Wzr7BOqFFxU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772811058; a=rsa-sha256;
	cv=none;
	b=1YwShCwIHu6cNHqWp3PRs+sJwtXwNotx332JKo53FIu8Fw4cDajh3mihb2J6/1w0/n33Ti
	gonGdP2gSrlLCBd8pEBEASfcOC9ekS5y3HuoaWc6pt2c075fY/SMpbE4trb53kiDwL5/bq
	ufRoEa0KdFlMb/DulF5zgCAgORcqmsw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NoF4well;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 63CBE44445;
	Fri,  6 Mar 2026 15:30:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C18C4CEF7;
	Fri,  6 Mar 2026 15:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772811057;
	bh=FI8J0CjY0WXJD6/7B/GSNXzO95+rzP9IqNX3Ca1r71Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NoF4wellfs0vfiQzzobsNQGra3x4pLi0cJws1pr+x30i0RlpCqJKZZQVnD5XctHLE
	 g4y/n6YSj8XujqnVBpKz31Y7JnvL7UdCI++Y0SE/oEzTSRkMPbe7ByH7OH4D3BASg+
	 CBo1HJsAMYGWlG30XfhhShBCL7RW1zdWCcyOy3irWZwJ1a3rHtXW66CQ3+CBkdx13c
	 bA2kvLRek/KpwCumfN4HNI3bTSoGzTxTXr9CpyY/7TbPZphiKH/pcruk7h3JU8hnnU
	 eRuhStXyC+hP6o+ghWOC/UBwAHjRz2QPAFfMVpGkg1hsRmeOSLZmW9rqScbJlP7Ohl
	 8c5r5taPhJVdA==
Date: Fri, 6 Mar 2026 17:30:45 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v1 0/4] mm: move vma_(kernel|mmu)_pagesize() out of
 hugetlb.c
Message-ID: <aarzJeKhv9S9QOnW@kernel.org>
References: <20260306101600.57355-1-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306101600.57355-1-david@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7BEC480007
X-Stat-Signature: 6fz4e4c9e8wimtpt7qgizx9h7refpmox
X-Rspam-User: 
X-HE-Tag: 1772811058-119289
X-HE-Meta: U2FsdGVkX18okpy3WLLGW7FrX6A3gYLCC0+u6fH4mGVDuM2agl3UaoAt3Lo4TuEVKgLPHZiMKcPRvgII3Fl7UrUypm+1KS2+gyKqB/0Hxndkua17m8ovkdTwn2amH9SCwo2nw00HY8LnRewEtLpAEPPCC7g2pt2O76rYE8DKxVfzaNTWZJKsOwVcsqhKasB3kMsVXQmK+uM9uSv+b08WNIy5HMxZhs4G7ppTjeRQYKji0BKzWTle5DZOf45HsyxRr/BPgXj2/+GSRX8AqJjS8uLsrCzj8chY9ce0kaeqR5RkT02m6BgukepTueyjs7wt2xhalJO2CfxmAeJsDK/xl3CLHwOcxaH8jjLX4DNqswwvRjb42Vn5xADrLxRaGomaKqRYsLMMsLtcN5VjbS7kTyDysXM211kMZRE7zNZcqL2r7sAg6ld4dangDzLu3yUpgX1/T+/2v+nmGOOu/d6UwMioan0KE4XvoEN69+mgo5jSVPCp95La5S6lJ/7ymv8IY3IK4MHfLzMLt2heltvYSqCsuPtYCdG3Ny9wRz9wQ2JaJ3wjJr6Kt2jC1sqaML/SIKLNNjvANPHmMWDD/nTRzgKHqmxt/k/zM8EwO77TRXR1x87zCJHtgiazMvfMPXYnbe0RrWcXvNnJC1DohoSxiawk4JT7IbZHQJUEh1ccgGCr9/3rrAjHRJZ+KK+GkcNno7CR/7NZ8l52hnhrPijry9dU/lo0UkKr2MQJXEcc8oatRmgFCfcHGdvts+YdRVxvKbNE+s/ZdWB8WExhw3N0O8QVjTLI5PNImqWYU97D7z+IcgYLpdLDujm6y80VUE4IJceJzNdg6d86mspNDQ5CYg8p5kofazRb/7WMVCgPRxq1iYtD/9tQ2z9/dhgXpxiH09SNVimjKC86eG/Q0TS6dvnqTP6Xwr+xsPOJMbCDaZehswAysAXpXYuEpJpqAxjdWq2r0w7GNXeDmS5gTUG
 auXALD+J
 auE/9jVHTxMqSvHquRLSol5BfcFL9sFVOThffOJ9ZgtEXfmsPSMHwKMhNM00LDcESd4jCE8EuS4II4LDslCqktN71cGDWwAtikb0vjvcE8B4tNtWSByCt2EIP/RBek0MaQctn4pAMgaUGK5RAa4NWQ4kVbsrEdP2jDtsddXH7EpNMx+YTlguzApHoq5SxRKr6M+zutl23MTfI1GscR5cPW/92jDx+E67lJL38KnEtPCkURD4HC7Rmabobxo4++rrElXrMiUShcz9UPd94XrgikE67N2mpBMra+Nb3ubwSOutV57ukgOX+s4FrZMVod3HoFH0gAON4vTq2LhlGl7uoTue1U+Htt5wCvWWh5pu9E8u3HZBHnoGDRtA1vGKJ4KyA9hvKJbrDKmwEEmoPh2mYOEbfclc9OJfo9u6ierSL3n150XMIWa2+3rLVEA6N4lGrYzFgjpDLzU60sOzsZn7+dpiJXJyMPOJoahDzmu8RLt59wAM0Ti3JAuJX7ZYuGGQviBKc0mQwn5W8cwajKh1OZICzN471MS7/bKsf+7Y6f7Ob2oFE3mMGFQpL5FlLMfu+ijBmccPh0My0PGk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 11:15:56AM +0100, David Hildenbrand (Arm) wrote:
> Looking into vma_(kernel|mmu)_pagesize(), I realized that there is one
> scenario where DAX would not do the right thing when the kernel is
> not compiled with hugetlb support.
> 
> Without hugetlb support, vma_(kernel|mmu)_pagesize() will always return
> PAGE_SIZE instead of using the ->pagesize() result provided by dax-device
> code.
> 
> Fix that by moving vma_kernel_pagesize() to core MM code, where it belongs.
> I don't think this is stable material, but am not 100% sure.
> 
> Also, move vma_mmu_pagesize() while at it. Remove the unnecessary hugetlb.h
> inclusion from KVM code.
> 
> Cross-compiled heavily.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Jann Horn <jannh@google.com>
> Cc: Pedro Falcato <pfalcato@suse.de>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> 
> David Hildenbrand (Arm) (4):
>   mm: move vma_kernel_pagesize() from hugetlb to mm.h
>   mm: move vma_mmu_pagesize() from hugetlb to vma.c
>   KVM: remove hugetlb.h inclusion
>   KVM: PPC: remove hugetlb.h inclusion
> 
>  arch/powerpc/kvm/book3s_hv.c |  1 -
>  include/linux/hugetlb.h      | 14 --------------
>  include/linux/mm.h           | 22 ++++++++++++++++++++++
>  mm/hugetlb.c                 | 28 ----------------------------
>  mm/vma.c                     | 21 +++++++++++++++++++++
>  virt/kvm/kvm_main.c          |  1 -
>  6 files changed, 43 insertions(+), 44 deletions(-)

For the series:
 
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> base-commit: f75825cdfc4c5477cffcfd2cafa4e5ce5aa67f13
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

