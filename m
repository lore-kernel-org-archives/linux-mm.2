Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCD0DCFC269
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 11:59:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C1C36B00A0; Fri, 21 Nov 2025 06:59:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 099DC6B00A3; Fri, 21 Nov 2025 06:59:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F184C6B00A4; Fri, 21 Nov 2025 06:59:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DF4386B00A0
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 06:59:19 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BBB1C140553
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 11:59:18 +0000 (UTC)
X-FDA: 84134468796.16.6AC10ED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 114A9180008
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 11:59:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C9rHWLou;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763726357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/VC0rLK7avPdZ1/pOnGKaCiL3bqlIpNaltx3xnsyzdo=;
	b=UpdCrHKCPC88x1TjXzndFD8RZo9NjP4E7l+j/SoHLrLERTRJa5eglYY9dfeqbW4KczW8i0
	Krrc3e7XtxzKAkGL/TMBJ9Bb6vC/cRMMQ9E56bWtl5U9Ey44lnU3+XNaipuNoNEioSMglX
	gE8ohq9PyGDzX1swvWUUqyLTiQuD43E=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C9rHWLou;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763726357; a=rsa-sha256;
	cv=none;
	b=F0iUed2UkeSpRhnJYeiR4RPvaEQDbe/Fd7oBvZB1XxgNHseqEW9mHHD6/syzI8xCL0dNlp
	3YgK2oxxVa0JsmypTlozv3mpIm63rdBhchuqxlmD4/WXjxHl9IUqDzTlXv/rC6oqbLKj04
	99J0ERMQFfIX2+kNORCWaItCpGNzbEc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D0AB8434DC;
	Fri, 21 Nov 2025 11:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4F2C4CEF1;
	Fri, 21 Nov 2025 11:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763726355;
	bh=RiQAcjp2e+731JZhVL1+P6ye9ciRcuL6VvATes7vC24=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C9rHWLou00pxAF6NJa4RQBnLlmDOL5cqA0B2wM2fNW2Yo3T5CM9n6+r1ARo/vkyv2
	 1tbDSVQCW4tGNdOwt/5PZe2wvr/qMDXRSCf4ncesFymiHBjirobG0VQ0xY33Yyg/kI
	 spHo1UL+T48z36hpT02GI9B7/FVKFQkfgGu+0IxyHZoFAiojYLf7aEEair0maBs0oW
	 7g8PFSncyT4fKsVC/KlKZ/f6Ma5vzE7LZT4guENhM09Eda7055CiewP3iG9GVpUY2k
	 fLjljE/8XCA+DyPPDQ4Js4IL0wa/hldO2IgPo6RPAb2j+csxcCPauHd3cA7DR1R3+3
	 7jFaYIvzEubMg==
Date: Fri, 21 Nov 2025 13:59:05 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 3/4] userfaultfd, guest_memfd: support userfault
 minor mode in guest_memfd
Message-ID: <aSBUCcjmZ5PM61ir@kernel.org>
References: <20251117114631.2029447-1-rppt@kernel.org>
 <20251117114631.2029447-4-rppt@kernel.org>
 <007c08e4-ce70-4c30-b3b1-e25e02dfe29d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <007c08e4-ce70-4c30-b3b1-e25e02dfe29d@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 114A9180008
X-Stat-Signature: u3akush58qjkhqugys18irmw4xfjob34
X-Rspam-User: 
X-HE-Tag: 1763726356-482929
X-HE-Meta: U2FsdGVkX19czlpjPb1odHzLroPEfzsNC/suxfv0Me8iAGuJFWEV3RYDPEEZbcr8HWTie7/b17iAO9fMqINaaTkkd9QqnkUee6+yninIZnHrtBouH0reikBiUIn4ErjZ8NU/L4MfGIIi7e6XgoVj0368IGTzsU9r5tvHpYSw5GS1LiTACqz5eVqRPdjTRvu6T1KAVETi70pCXRnsvyCoDPz0JfWAa8/Q5YUmTExbVJHAKGv3qhavNM5d+QvvXulk/3Nc1wFkeRTjF2YtsBlDM9VSFCC8ExKP6dqpP+Owk9Zi7GipaTNY4Is0In2ZUfgcx1pGDES0Zp8R8StgOlMTKJHdQKUMP/QRf+z5EndBWC+/Rm2LMTwGVfeJPJOSqI4NzYB1CbbpOPnIbboleaIAIOd1hDhiwX9N8+gR79WzLcuQPXsDXzN1T8woSG7+v8W9vdOWycw33K4rvGA8HQa3672g340UZTTrhlYGRfDFjEePX6v1CpFuGnSrlC6lMlmYm1ZMZGYV6+KYcIgUvrJS2fr88G80kxlBqtd2mN79+WKfQAEz08BFalzuOsqLJep4XeXjXg2ag0BM1081cgmoAqaqFJnFn+p66OWN1bHlfpNbXbNmyCM0A7KAS8EC3dM+8gKDqh7Jp1SWNJpuWhxXM8ARKn2fCuYY4J6A6vW73MDAzwuS7IQjNgL5p9XvKo/eZTYftrzEq1m8UkRmCdnBv61EWVwYX6+6TNCLsQSILBIGidHUIR52YV4WKo+YL008YwrflAIUZpYxtbu8FUl4+T2IODXo7HI4c6h26lCDwQnxOfxyAQiY9C1wWE1QMfk8R6NOROXamFQZw9fpw8DyUjFu4qSXv2SNSX3nheJSh8I8p1zIbR7oG58tCNrbaTlFfVf+7wNTRh9coAkL6DIt1Nmwnc8iB7pWp+ZBWkRYinaAd8tGySyRNqBHcQlliYS5ZfTU9X6i6vhNl5WW+be
 9YQrfkV0
 xQ7CmKkUlL2gKnKcMOZL8rxPwLCaTaSQaMIvPRlRCnar0lIkL5nGCd2xcBzF/vyuIXeA5x7qsLo7KwaB/TlCSR94zS2UrrkDQm1EjX9g8XKpiZFmfMSQDGwfoSUiltAupjgmqTx11FAZxAvwpc9cWprZRUxM0HbLtmG3KUzBhrm/F5Rv4Ot4ol48uIBmre1GvSg0RY7mI4V4b1YDUlGSH24TIhkPGTOEhBCXUgsnj6ADtk5JtjB6TlFDYq2NroJsz9L6UI2JJGeckIYDP5Z/PWpJgQzIp+s8+YVbvmSGxBR79GTI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 05:41:13PM +0100, David Hildenbrand (Red Hat) wrote:
> On 17.11.25 12:46, Mike Rapoport wrote:
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index fbca8c0972da..5e3c63307fdf 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -4,6 +4,7 @@
> >   #include <linux/kvm_host.h>
> >   #include <linux/pagemap.h>
> >   #include <linux/anon_inodes.h>
> > +#include <linux/userfaultfd_k.h>
> >   #include "kvm_mm.h"
> > @@ -369,6 +370,12 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
> >   		return vmf_error(err);
> >   	}
> > +	if (userfaultfd_minor(vmf->vma)) {
> > +		folio_unlock(folio);
> > +		folio_put(folio);
> > +		return handle_userfault(vmf, VM_UFFD_MINOR);
> > +	}
> 
> Staring at things like VM_FAULT_NEEDDSYNC, I'm wondering whether we could have a
> new return value from ->fault that would indicate that
> handle_userfault(vmf, VM_UFFD_MINOR) should be called.
> 
> Maybe some VM_FAULT_UFFD_MINOR or simply VM_FAULT_USERFAULTFD and we
> can just derive that it is VM_UFFD_MINOR.

_UFFD_MINOR sounds better, maybe we'll want something for missing later on. 
 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 4f66a3206a63c..2cf17da880f0e 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -1601,6 +1601,8 @@ typedef __bitwise unsigned int vm_fault_t;
>   *                             fsync() to complete (for synchronous page faults
>   *                             in DAX)
>   * @VM_FAULT_COMPLETED:                ->fault completed, meanwhile mmap lock released
> + * @VM_FAULT_USERFAULTFD:      ->fault did not modify page tables and needs
> + *                             handle_userfault() to complete
>   * @VM_FAULT_HINDEX_MASK:      mask HINDEX value
>   *
>   */
> @@ -1618,6 +1620,7 @@ enum vm_fault_reason {
>         VM_FAULT_DONE_COW       = (__force vm_fault_t)0x001000,
>         VM_FAULT_NEEDDSYNC      = (__force vm_fault_t)0x002000,
>         VM_FAULT_COMPLETED      = (__force vm_fault_t)0x004000,
> +       VM_FAULT_USERFAULTFD    = (__force vm_fault_t)0x006000,
>         VM_FAULT_HINDEX_MASK    = (__force vm_fault_t)0x0f0000,
>  };
> @@ -1642,6 +1645,7 @@ enum vm_fault_reason {
>         { VM_FAULT_FALLBACK,            "FALLBACK" },   \
>         { VM_FAULT_DONE_COW,            "DONE_COW" },   \
>         { VM_FAULT_NEEDDSYNC,           "NEEDDSYNC" },  \
> +       { VM_FAULT_USERFAULTFD,         "USERFAULTFD" },\
>         { VM_FAULT_COMPLETED,           "COMPLETED" }
>  struct vm_special_mapping {
> 
> 
> IIUC, we have exactly two invocations of ->fault(vmf) in memory.c where
> we would have to handle it IIUC. And the return value would never leave
> the core.

I've found only one :/
But nevertheless, I like the idea to return VM_FAULT_UFFD_MINOR from
->fault() and then call handle_userfault() from __do_fault().
 
> That way, we wouldn't have to export handle_userfault().
> 
> Just a thought ...
> 
> -- 
> Cheers
> 
> David

-- 
Sincerely yours,
Mike.

