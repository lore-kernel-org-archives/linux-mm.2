Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A70D1CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 17:20:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C92806B008A; Tue, 12 May 2026 13:20:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C69D66B008C; Tue, 12 May 2026 13:20:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7FAB6B0092; Tue, 12 May 2026 13:20:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AAFB86B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 13:20:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5DA891C0432
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:20:28 +0000 (UTC)
X-FDA: 84759431736.05.6DC98C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id C9636C0018
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:20:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YIsvNhVm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778606426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q3Gnd8EjsNufRjor8+DIQCTNeKfrTcQw/b7um69bZKI=;
	b=HUG6pXAatCTNxLK4M1Xx4LTSTfJ35IL/QSs1icWwZGYjG/ah70Rxv9tsUgBcvHU0pRdPHy
	aQEQT8o5bZWKNQrw+K6amFGo6KMH/mdU/SJ+j/zK9ioTLQypkg30noou/xzNYeIHrj5ONB
	uS/ngWIpRHaQSEVp1wvnVsrjE+O8BHE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778606426; a=rsa-sha256;
	cv=none;
	b=6faHmS1K6mYwMgCiLwfEJIapjvZrNF0qz27/FWFaGm8csMLMzqaYYqBSpctVX3Ab4DiUsr
	81sHunO6vip7ibwsATGjZueGTl/d3Ym2VxUTdU6Ky4yutdOaFDRCk9HrG9CWxRjVe4Ls53
	KHxxg6O6gpQvGhHIB/CErKELc/G9PEc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YIsvNhVm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1911A60120;
	Tue, 12 May 2026 17:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4AEC2BCF6;
	Tue, 12 May 2026 17:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778606425;
	bh=DRoLtgIvcD2e2vf2baoMKR6QXNkbxpK/O1mp/m/ymfU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YIsvNhVmAYXymKaSFDsIZLzQKlZ79T6SkCywkU24ZoKbuOSR9wkaJafMAQxn3MHnW
	 LlsNQCAsJWNJ8n+Jp3KfprZWydWAS0nLhVY9L9atoR/TgYwS7SBGdNgrx8Zk1LprqI
	 q0Nps/N9ITY1XhzQx5tDBcueyh6ovjN02qUFqlqP/cyPRVOOr7+OHS1B92f8yewJPo
	 wtiCkeNXZ4f8dGZTIfgdsUW+/j67oSsSjp+5fedQZHVJe8l/KgrvUU+ubsi2UI3Fmz
	 lOB0Yrigesl7xoDwcYLVwUlvzGKQcXbjjmopo/Q1+0ueAp/Yosl/B6ZLZtz9sp2Vqc
	 fWWsdcsBxaJkA==
Date: Tue, 12 May 2026 20:20:14 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: akpm@linux-foundation.org, peterx@redhat.com, david@kernel.org,
	ljs@kernel.org, surenb@google.com, vbabka@kernel.org,
	Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net,
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com,
	jthoughton@google.com, aarcange@redhat.com, sj@kernel.org,
	usama.arif@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 08/14] userfaultfd: add UFFDIO_REGISTER_MODE_RWP and
 UFFDIO_RWPROTECT plumbing
Message-ID: <agNhTvqeOD1eo8mD@kernel.org>
References: <cover.1778254670.git.kas@kernel.org>
 <1ad0cb61a7b5a33a5375baadbd0720ba2ba43d2f.1778254670.git.kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ad0cb61a7b5a33a5375baadbd0720ba2ba43d2f.1778254670.git.kas@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: C9636C0018
X-Rspamd-Server: rspam04
X-Stat-Signature: zsdfejdhyfas6ni1seyx9azhn3dbfge6
X-HE-Tag: 1778606426-196771
X-HE-Meta: U2FsdGVkX1/Ed9HUGrPqPSMwSgQ8S6hpGgH66ewuO+ImIyLWs7oks9rEUCYOyLX8PFai137WRihH3w9hKgqS6ikYdOc6hNYFg5pwmso0N6q/pIpaWL4GHvDxwLuRj4y6bKcOAcaoYcwz3Ee7+g5UpHSphlxjI0QlTF3OjzwvTMC08i14R/pmlY1BvxtqX2li5IE1zPshW4sFnXq6umgg3hlkNnBaN9pUmsHLG3/hkrrsqVuNkdpAQ1dBb90Ke5Qi+6Xi5YzB6PzTribKLQ8k/d7w9+NPe04gZpuKsyoBcp9dUCdusNjZwDX+aSvKhjwya2ISSOXkTlFboyL7mem3r9PJLx0dwgcVhubQuAxcMspkRntEl/MNWYfAc4SYyjXVhwiA9FBzmXsDFIcfboNQii3fwW01EoZLj6zl5oar72N8EbKOkntzv+eA4XKVJCfowekXFU0F0ZPcw7VvAPgmeecFrGdYAuvd4l3WBkIMJBN8EFypZNsPnze6nnSNC6tWnxDfA28/jGpu6ALN+taxYPi3Dxy5m7tJJWHpt/D8pQ6Oy/kyrykF80LG+z262pbuDqY0a64XNZ5ucg3vwnG69vm4HDOGMPu7KojUaYTHrhhBvqAxhcxy5SZgPNKpvj9ssUKnw8tznCgbMdCVc04TXA8K3YiC2pYmMaoY3XUVTRtuAJOwXl4RxhAjyYjrCiITxehbOWK821lGdqKq8xYaxJsgLDTS0+g4WcW8OKkXCEXPi3QEmMODaGr7oNxXQMhEzTc43xkKfr0bkoz6ZZVmAfMn3kpcDRtpDxTlLfdjOlRnb6S+Rr+HZ81qOZrETnWi+xE1dqalAvmiMc6/6Sb+atGQ7nqhfxWdliVNpGJLh+/LDTLbpT1EvCZZB0oGZoem/ZIh7WWVcvVmJ+U7S68CTYC2icpFA7ayF/5AY8aMmdQc1v1UyeloB0w06daPg2vBD9m691IoOIaeRioXXFd
 qjzDeZ2B
 RzdDg1GK/spRKnSi6Aeir99CVRFNFotbOZbAIBEpSoFskUxu+GtofBsvK10imfxQamiECkEckE2LU5dXaRTWfHouB0PdpZmFNnAoHr6oTUf0OWnZK5e+vMVfDqovSQ6uV54ze1pj1vJu95VDdspHIxbcU0byvPPaTp4kt7RQz5dpJ+mA4o/eD0SQ5dZoVvfZqiLsNg2E1cOrq5oW1z7DutlXIW77gRMmovcJ3BAt01x7JUC2arHb9LQeqxL9hbBIY7p5Dy1X/PfBZNuB4ZK7p55xiADzKFa0DvgdQuL1ybRw9u4YTBr7M4qDtphFlJPqfGMc9o/rTeDVjbVE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 04:55:20PM +0100, Kiryl Shutsemau (Meta) wrote:
> Add the userspace interface for read-write protection tracking:
> 
>   - UFFDIO_REGISTER_MODE_RWP      register a range for RWP tracking
>   - UFFD_FEATURE_RWP              capability bit
>   - UFFDIO_RWPROTECT              install / remove RWP on a range
> 
> Registration sets VM_UFFD_RWP on the VMA. Combining MODE_WP with
> MODE_RWP is rejected because both modes claim the uffd PTE bit.
> 
> UFFDIO_RWPROTECT is the bidirectional counterpart of
> UFFDIO_WRITEPROTECT:
> 
>   - MODE_RWP              change_protection() with MM_CP_UFFD_RWP
>                           installs PAGE_NONE and sets the uffd bit on
>                           present PTEs
>   - !MODE_RWP             change_protection() with MM_CP_UFFD_RWP_RESOLVE
>                           restores vma->vm_page_prot and clears the bit
> 
> userfaultfd_clear_vma() runs the same resolve pass on unregister so
> RWP state cannot outlive the uffd.
> 
> Re-registering a range must not drop a mode that installs per-PTE
> markers (WP or RWP); doing so returns -EBUSY. This also closes a
> pre-existing window where re-registering without MODE_WP would strand
> uffd-wp markers: before, those caused extra write-faults but were
> otherwise benign; with RWP preservation in place, a subsequent
> mprotect() on a VM_UFFD_RWP VMA would silently promote the stale
> markers to RWP.
> 
> The feature is not yet advertised. UFFDIO_REGISTER_MODE_RWP,
> UFFD_FEATURE_RWP, and _UFFDIO_RWPROTECT are intentionally absent from
> UFFD_API_REGISTER_MODES, UFFD_API_FEATURES, and UFFD_API_RANGE_IOCTLS,
> so UFFDIO_API masks them out and the register-mode validator rejects
> the bit. The follow-up patch adds fault dispatch and exposes the UAPI.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Assisted-by: Claude:claude-opus-4-6

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

with a comment below

> ---
>  Documentation/admin-guide/mm/userfaultfd.rst | 10 ++
>  fs/userfaultfd.c                             | 84 +++++++++++++++++
>  include/linux/userfaultfd_k.h                |  2 +
>  include/uapi/linux/userfaultfd.h             | 19 ++++
>  mm/userfaultfd.c                             | 97 +++++++++++++++++++-
>  5 files changed, 209 insertions(+), 3 deletions(-)
> 
> +	/*
> +	 * Pre-scan the range: validate every spanned VMA before applying
> +	 * any change_protection() so a partial failure cannot leave the
> +	 * process with only a prefix of the range re-protected.
> +	 */
> +	err = -ENOENT;
> +	for_each_vma_range(vmi, dst_vma, end) {
> +		if (!userfaultfd_rwp(dst_vma))
> +			return -ENOENT;
> +
> +		if (is_vm_hugetlb_page(dst_vma)) {
> +			unsigned long page_mask;
> +
> +			page_mask = vma_kernel_pagesize(dst_vma) - 1;
> +			if ((start & page_mask) || (len & page_mask))
> +				return -EINVAL;
> +		}
> +		err = 0;
> +	}
> +	if (err)
> +		return err;

It's an interesting way to say "no VMA found in range" :)
I think bool found and
	
	if (!found)
		return -ENOENT;

looks more readable.

-- 
Sincerely yours,
Mike.

