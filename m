Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCFE1C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 12:19:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6E1C6B00FD; Tue, 30 Jun 2026 08:19:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A46FA6B00FE; Tue, 30 Jun 2026 08:19:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95D6A6B0100; Tue, 30 Jun 2026 08:19:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B78B6B00FD
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:19:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D44C61C34B9
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:19:48 +0000 (UTC)
X-FDA: 84936485256.09.D737B8A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7B5044000E
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:19:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SQt+qN5Y;
	spf=pass (imf11.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782821986;
	b=W4gVmccIMZEmAAW+AYqftjrvkgmUN7SZkoACnWeiuTZA9Nm15P3PYnOyEnAK1ib8C7KKLJ
	7XiJjboLU7288eY84gJVpiaMBfgMjJgY+Rij22kN6sCaHUUUFkHxNMX8zkwDwqdP2XeUPJ
	Kkts8SYSDcxmqFFrw2Polf7xZhR92EM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782821986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DDGTaeRRb3D8M5qicYQpFLUVvv74PX4dJAEV76CGQQM=;
	b=o7GmipKgDiGNA2FGPvHsqG9BXvU3AiPmDDqMvoGjAbLOIQnIyGep1P7yG2mUrFaohDRQ1c
	GeWh2AxPPs+RVDubBF69gihAgLjS+k8zDmz4Cm2nnY3oQorWvhqIo0MEPCWYPGvs2TyIWZ
	z5lC3VNpXdfRzNXx7UGkgDPDYghYxc4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SQt+qN5Y;
	spf=pass (imf11.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782821985; x=1814357985;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eazOhytQrFMvUq1ReP67qLKPgCSBV6aajIEIlT27i24=;
  b=SQt+qN5YI5wEPY1Gg31FZfJ3I43eP6NShvGnrq4rE6MoNf30We6MlApG
   +F1mOX6Xu3FubiPDlSYLFqZAtLpP6LBEy3o5j9wISir5pQR8W2J4WzSVz
   4a5ZamzDZGuHsjc2C/w3nteeXrs6+yUqIjtEBGMEmCxm+zpRO/nl1YqZE
   Oyl9R4rRwOUhmgPNbfBLgchJx7N+zToN+y+5yLmRM8ghF7sj+L+ou4CvP
   XgS0j+k52SD6lVxKmmeteg9ZfIRI3OrGll00STsZiUOE32xwSZfUC3u8S
   jsWZK5pH6QM35nVFzunD4VZ7GnwtVzMNzpV3Ko+ZTDO5aOwiFbt+m0Cn5
   w==;
X-CSE-ConnectionGUID: 9U7z0699T06InBqMMlM4vw==
X-CSE-MsgGUID: Gdwhu485R8y+czbUGg6ziw==
X-IronPort-AV: E=McAfee;i="6800,10657,11832"; a="94683315"
X-IronPort-AV: E=Sophos;i="6.24,233,1774335600"; 
   d="scan'208";a="94683315"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 05:19:44 -0700
X-CSE-ConnectionGUID: B7OjnqsRQEixcvKJEwnbxg==
X-CSE-MsgGUID: dfLIyfHYTAKDobdyePXMlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,233,1774335600"; 
   d="scan'208";a="254160487"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.239.158.70]) ([10.239.158.70])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 05:19:30 -0700
Message-ID: <a8b4641f-ae3b-4b19-81e5-84e3c05b9760@intel.com>
Date: Tue, 30 Jun 2026 20:19:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 09/46] KVM: guest_memfd: Introduce function to check
 GFN private/shared status
To: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 david@kernel.org, jmattson@google.com, jthoughton@google.com,
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com,
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com,
 shivankg@amd.com, steven.price@arm.com, tabba@google.com,
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com,
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com,
 aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-9-9d2959357853@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-9-9d2959357853@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9h94c8kk7xk69opcwpitgytw8fuaz58w
X-Rspamd-Queue-Id: 7B5044000E
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782821985-398984
X-HE-Meta: U2FsdGVkX19uQCro52vpYnuTkCEd9V7AnH8/WZLhrHr3Puwr2ip5pfw9K4855LVnnhiUcfJy0B/NNd71d4V3PNpKBk+AmDxDP0z1vi0JerIVZw1aQ0ij784pFYUD8Il1c/2GANApAm16wevAG53VKjGp9hR4VaQZWS1DchXKumrDflk6WjW9mvKsRX3LVvOU7meTTxFo/v2+4pdWkt+5VLDDu5axWr51D1O6cGtX6kP6pd1KYmVZhLAFnl9sc/A3Rr0vHmHoLZfP0I4sNAuRwL/hBDZ4gSpamgTTpTsnNJ4oX6bJ4Qc+u2gSQ+r3Pd+zGn0UdX+PcMlcnU1x60SZeoIiYUdgOUi/G+OijZBX6my4MfX3rOKBEHDzn+qUKMiYfteJ9JeKPSUy2vzPf4V5hbomd0ddhJnPLxlyJNLDv+SxttnIoQof2p8o9BhN/HzwebAhiy2qY1diZ2VebpWubvYc/cSAm1Ha7u9wGitwL485WccWmLuxIp/1jn65eucBWssISOaAn7yXYRnb4ph78mMoBC5ERxLuKuu+pT3IPWS7DdQZVQgBiRFSsZsqa+XtsPujAen1kRE/fdRqLB7CPiFrZAEsB6hCOohfx41lUCGVeRUJRw0NhK2nxj7FYOpAA9RlewDITZ7CDftVO7vbE6n0LyNrZxALMpfU3JLXyQT1q2pNAzAEb2FC2DP2TJ0MPr3HrsPUc4GbwlfnFbggM4H4D74an13tZrUvoCJykJ1v7HuVVUzY1JBatOpPahr6Sw/TMX2oRE7rLN97VepiTmyMsEIuFPwv61Ra+P0sWqejE4dOL1QynMjoGZ4eaumaYzEJKfigd7u3bruhQQHf9Pty6tPJUl3kbDTuXXRqBptuJoKYlD5gLmcLp3D82c9Jpo0/fBvdv+WJS0DhckfCCKs/DwIo9d0OP89Cq7RtshVYKkvZTZbYh0XwUxdyiHvu/zKKIZKRa9nVeDRaJQH
 MORwNNPE
 gyygyccBIO4hpq84zXvItbpHSgzM9zoeze578DuKLFraI5+hnQavhLiD7+KZPt7DqFLB+OMkazJu797FfzQCGp6FY3VWMd9dHAKXuytxrwzS4gaLwE8gNJ9m9d1MzBqL1UCu8EGNcaVlzU03+WLL8iN7Y5ZFbXftUniU0zWiB7+XGGukIYn7OTP+fVOgG1u7wxTjpVvOdcpS/Sd6TjJbfrPyWefLBk7ZkLGWPlvQJy+X2FhvKkPZY4gFTDsT/7WUvqI3S+89ZHi/n0quVLibwEOm9iqcuXcd4RCWn85TpAsMO180=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Introduce function for KVM to check the private/shared status of guest
> memory at a given GFN.
> 
> This will be used in a later patch.
> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

With binbin's comment resolved,

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

BTW, it looks better to move the patch 01 just behind this one.

> ---
>   include/linux/kvm_host.h |  2 ++
>   virt/kvm/guest_memfd.c   | 31 +++++++++++++++++++++++++++++++
>   2 files changed, 33 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 3915da2a61778..27687fb9d5201 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2575,6 +2575,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>   #endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
>   
>   #ifdef CONFIG_KVM_GUEST_MEMFD
> +bool kvm_gmem_is_private(struct kvm *kvm, gfn_t gfn);
> +
>   int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>   		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
>   		     int *max_order);
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 8101f64e0366f..bca912db5be6e 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -510,6 +510,37 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
>   	return 0;
>   }
>   
> +bool kvm_gmem_is_private(struct kvm *kvm, gfn_t gfn)
> +{
> +	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
> +	struct inode *inode;
> +
> +	/*
> +	 * If this gfn has no associated memslot, there's no chance of the gfn
> +	 * being backed by private memory, since guest_memfd must be used for
> +	 * private memory, and guest_memfd must be associated with some memslot.
> +	 */
> +	if (!slot)
> +		return 0;
> +
> +	CLASS(gmem_get_file, file)(slot);
> +	if (!file)
> +		return 0;
> +
> +	inode = file_inode(file);
> +
> +	/*
> +	 * Rely on the maple tree's internal RCU lock to ensure a
> +	 * stable result. This result can become stale as soon as the
> +	 * lock is dropped, so the caller _must_ still protect
> +	 * consumption of private vs. shared by checking
> +	 * mmu_invalidate_retry_gfn() under mmu_lock to serialize
> +	 * against ongoing attribute updates.
> +	 */
> +	return kvm_gmem_is_private_mem(inode, kvm_gmem_get_index(slot, gfn));
> +}
> +EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_is_private);
> +
>   static struct file_operations kvm_gmem_fops = {
>   	.mmap		= kvm_gmem_mmap,
>   	.open		= generic_file_open,
> 


