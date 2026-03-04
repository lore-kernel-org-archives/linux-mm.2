Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6F25EFCE33
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 17:59:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4F266B0005; Wed,  4 Mar 2026 12:59:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D27EA6B0089; Wed,  4 Mar 2026 12:59:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFBDD6B008C; Wed,  4 Mar 2026 12:59:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B1B876B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 12:59:11 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4C67B1B81DA
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:59:11 +0000 (UTC)
X-FDA: 84509142102.13.7D03A59
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0179C1C000E
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:59:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AlDMCLmC;
	spf=pass (imf21.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772647149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mndxsLknrh8CEjoGWg13z+ehijVBFIyYI2Gh1KFe+s0=;
	b=1jKQS7bX1gFzIA+qEkTwFr84tcQZQ3NbycINIhz7JJYGP3c3QAMxJo07nAdfy6Q8oHHyxn
	AxL4TYuEMkEaTLBQV6iDrhZNHvC6RMGjesv47pHoOjy5K3a/fVfm+vyt4iO3KAz0pF3lHq
	+WMpzJ53W6B6fwdsuBmuu5tXQA04T2o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772647149; a=rsa-sha256;
	cv=none;
	b=DwWUjxgbQYqY3t6tSZzDxKrXRizE+sLn8Z+rPQ1rhjaVNJCeunWEXq8oSN3QHlIackI4Zk
	ajNMMkOEp9lPhyp4jxy5xCFmOw3M+Olme0bGhwOT4CV4PbVUBiZqwPz97ea/0/CTpkMvWi
	CPRK0jy1dJDqVLwNmIPBcXRXij/+qj0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AlDMCLmC;
	spf=pass (imf21.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772647148; x=1804183148;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/CV0BOByGYSuzWxUSGsbDoPh7GMERLO9A3GhGMQraAA=;
  b=AlDMCLmCSRZCWW9UitxGhyy4llheFqqcN5dqJEe4gOBnxKCBY5lf+kDF
   XDNOrl/djQK7M3teDxV9POFQ5u/kSWqmajH8Ag1l4txDON82XXP7NGw3x
   golHBI+FNTZ0mcs4PZqY1Z3ZHIOMzDgn50He+jFH7gtzOB9cx5zCCklNX
   lt0h7IBpx03x63c1rA/bRSQqO1Hwd+yoBmeeRfBwC4RTUiyUW3spafB0b
   MQYubVMENFN+kpZfiyqn3DNx7YEcoaDWXOopkPcZ8KFP5Txd5LpksZ2FE
   JQsafOzk5Ko1d1WPhFAKY/qrNdQcGKy7VMmZnP/yDdbP9n/qN7uYd5zFX
   Q==;
X-CSE-ConnectionGUID: CgLLv0SZTU6GpQvs2SgkWQ==
X-CSE-MsgGUID: m24X//KVRyOuOCOrrTuRXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="73787446"
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="73787446"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 09:59:07 -0800
X-CSE-ConnectionGUID: 4TQsiUvKR6SROeOWGs/bKg==
X-CSE-MsgGUID: m6KG54ICSbu6tHecqNx0sQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="214537504"
Received: from aschende-mobl.amr.corp.intel.com (HELO [10.125.108.205]) ([10.125.108.205])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 09:59:05 -0800
Message-ID: <7dc30fbf-17c0-47db-8457-24b531cd0071@intel.com>
Date: Wed, 4 Mar 2026 09:59:11 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/2] x86/tlb: skip redundant sync IPIs for native TLB
 flush
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: peterz@infradead.org, david@kernel.org, dave.hansen@linux.intel.com,
 ypodemsk@redhat.com, hughd@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, npiggin@gmail.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
 arnd@arndb.de, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com, jgross@suse.com,
 seanjc@google.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com
References: <20260304021046.18550-1-lance.yang@linux.dev>
 <20260304021046.18550-3-lance.yang@linux.dev>
Content-Language: en-US
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260304021046.18550-3-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0179C1C000E
X-Stat-Signature: yc5yxndscmj6hznq6eb5wnmoyyg8hbmd
X-HE-Tag: 1772647147-246292
X-HE-Meta: U2FsdGVkX1+NVHCbRkLGOss/BWTOH63VvzWKeHFpYQe6n/qz4vEdc3KuJV4Loz2Y6pMJCnn04FULjs0uMxqeE0Mz1Hp9va5gR/3se8mER5lg7eL5yJOCXD9yU9AAYI6XQkwaGuK74joHbVbieQlbPdG1RmII5en9AFD/8gI4V0I0xpGjzqOXc7yURKFwcRcY8WWS4oUgAQ+IpACm3GBHwCqmyf8ARisBEOSFbDwRz+B/bD0J0D/kHywKJTwfYF8XhecWtjI9kaiAric8vXayjy786inw+zMp8heCIBuTN6Sj2SoP6TkDPBEg13bh67cXdy7uFFrOolywgSpzkSQfj03HvuZecD18L9gJ7vkvZ9oE1ze0igV6M0zmZRGaD6URw4QCjbPnBZ9xi8+PsNgijHWdtSBc1PU0SagHSwUTN4CDBZb9EhrHGcqThSI3zG9wWAYlR99fx+rncEZihLsT/Hm9/GwHo1W59IxGX/ETkVLgbYtHoW8U+327k4UmlrxEm+qvjWP+jHJmUEVizk+zK2WZWiH1l9AuN1GZWtsjIKmguuS69Ru74IVUiEIzKXnx97Ppp+vJ1++NFBMsFqZUcf7jMPfToBtIZlS6Z1TH1M8UQN7k3V0fR+GsuLuvQ0pkZ+ABTaqchl3M4M417nTYKyGv4wsmk1wiMgBV5gfc8LyU83mvXEHsJFd018OC5BZgC/nsAi16n0sluxj2NcUNuEY0OluVIu/ChT22lCOKAUG9/FU2/dBh9BBGuFT07LNBXqD5nCb+UQZlKdeAUxhcDOd8GOaTa2yAmzhOdS2LDHZ3BFnujakPdGLwtp0t4NlTa0ysWCLz9NxksoTyazNPjBgggIofjARpGox0+AEvcirjciWWqNZXW0iqNKqUlUFF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/3/26 18:10, Lance Yang wrote:
...
> +	if (pv_ops.mmu.flush_tlb_multi == native_flush_tlb_multi &&
> +	    !cpu_feature_enabled(X86_FEATURE_INVLPGB)) {
> +		pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast = true;
> +		static_branch_enable(&tlb_ipi_broadcast_key);
> +	}
> +}
...
> +#ifndef CONFIG_PARAVIRT
> +void __init native_pv_tlb_init(void)
> +{
> +	/*
> +	 * For non-PARAVIRT builds, check if native TLB flush sends real IPIs
> +	 * (i.e., not using INVLPGB broadcast invalidation).
> +	 */
> +	if (!cpu_feature_enabled(X86_FEATURE_INVLPGB))
> +		static_branch_enable(&tlb_ipi_broadcast_key);
> +}
> +#endif

I really despise duplicated logic. The X86_FEATURE_INVLPGB check is
small, but it is duplicated. You're also setting the static branch in a
*bunch* of different places.

Can this be arranged so that the PV code just tells the core code that
it is compatible with flush_tlb_multi_implies_ipi_broadcast?

void __init bool is_pv_ok(void)
{
	/* This check is super sketchy an unexplained: */
	if (pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast)
		return true;

	if (pv_ops.mmu.flush_tlb_multi != native_flush_tlb_multi)
		return false;

	pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast = true;

	return true;
}

void __init tlb_init(void)
{
	if (!is_pv_ok())
		return;

	if (cpu_feature_enabled(X86_FEATURE_INVLPGB))
		return;
		
	static_branch_enable(&tlb_ipi_broadcast_key);
}

Isn't that like a billion times more readable? It has one
X86_FEATURE_INVLPGB check and one static_branch_enable() point and no
#ifdeffery other than defining a stub is_pv_ok().

BTW, why is there even an early return for the case where
flush_tlb_multi_implies_ipi_broadcast is already set? Isn't this
decision made once on the boot CPU and then never touched again? Do any
PV instances actually set the bit?

