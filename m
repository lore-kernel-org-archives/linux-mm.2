Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E538CCD183
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 06:28:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBAFD8E002E; Sat, 11 Oct 2025 02:28:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C926A8E000E; Sat, 11 Oct 2025 02:28:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCFBF8E002E; Sat, 11 Oct 2025 02:28:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A63C88E000E
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 02:28:24 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 49B2A14055F
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 06:28:24 +0000 (UTC)
X-FDA: 83984854128.09.D0630F0
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6C7CC100009
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 06:28:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VatXPrGG;
	spf=pass (imf14.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760164102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/JCRyAnmokJayy/TZ9IjsmBaCJ6vmXBQql3AFCgnx0c=;
	b=biEhsQP93TnWvNi39Amp9ljKmsxmAeaMAmf4vabpUmt8PCzNK+6R6gG0j0fq2ztjAEvkaa
	hwZ9fUFAsmldIulbZwSR1HQvQB0q4RVWCOVKdJN/SrIc6oz85VeVpMI12zVKqZfEDQsj51
	yu84CJ0rbXsIJvlf3lRK3bAors4Oi4k=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VatXPrGG;
	spf=pass (imf14.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760164102; a=rsa-sha256;
	cv=none;
	b=FiwuS3lkVfALgucdlPnhP79YwBbAZSsZGj3yhg3IceZumxKzXFSHQ7HCvXrSqg3+WHWFg/
	68dso5Dhe3NZ7F27ngN0+MRuYPz9AtpwoxvcuEbac5Qykd3nTWWDn+pTtl2PgylyvJGRW9
	VKNQAfc166fOKeLgC6LOlqx0ji+FY3w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760164101; x=1791700101;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JmDOfQUbMEHiVtzCQOOrc24XvL9I3YKy6Q+bCgh3a1o=;
  b=VatXPrGGd6inhjlcQX3/6woHzxD2gvPzRFOeeKu2wGyNJYnB2Mf4TvvS
   AA/RBzh0aCcsVmka0BC3eGuvnLJkvVrBI2o3JIJmIeHkLyyOHN1Sk2+5u
   +30U52UG6J2lab3dR7MND+VFS0H/kEaA3s5jCoZNATvDEFK6hbJUj3qGW
   R5SMc2HGaQah9oQrG0VR+XGcLLDz/9iCapHCWi89zzjDx5hYqbjOqv2Pp
   5RoUihTSLs+Lh2wP3eGMVbcH1fP7KWzTxADuMt+cIr1udxC76QLFYhxbV
   3X0qG191VP3mknLWFS5bb1Wo0dLQJPG57VLMlAcqKei3HH93K6ST66QaZ
   w==;
X-CSE-ConnectionGUID: Nqr2Hhl4QSKIFj4Lj7OHyw==
X-CSE-MsgGUID: I/yGvG9kSfaUefEm8Ngf+g==
X-IronPort-AV: E=McAfee;i="6800,10657,11578"; a="62258570"
X-IronPort-AV: E=Sophos;i="6.19,220,1754982000"; 
   d="scan'208";a="62258570"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2025 23:28:20 -0700
X-CSE-ConnectionGUID: ak6XigH/QdeMlk+cNQCyDA==
X-CSE-MsgGUID: +31j5JXqT2muzztIzmPLXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,220,1754982000"; 
   d="scan'208";a="180257706"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2025 23:28:14 -0700
Message-ID: <3971a3fd-c733-4864-851a-87dc9d3f686a@linux.intel.com>
Date: Sat, 11 Oct 2025 14:24:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/8] mm: Add a ptdesc flag to mark kernel page tables
To: Matthew Wilcox <willy@infradead.org>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>, Kevin Tian <kevin.tian@intel.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Jann Horn <jannh@google.com>,
 Vasant Hegde <vasant.hegde@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@intel.com>, Alistair Popple <apopple@nvidia.com>,
 Peter Zijlstra <peterz@infradead.org>, Uladzislau Rezki <urezki@gmail.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>,
 iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Dave Hansen <dave.hansen@linux.intel.com>
References: <20250919054007.472493-1-baolu.lu@linux.intel.com>
 <20250919054007.472493-2-baolu.lu@linux.intel.com>
 <aObCAwbf1-Sxepni@casper.infradead.org>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <aObCAwbf1-Sxepni@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6C7CC100009
X-Stat-Signature: mhehj7uurppng5so1eoqy87ksmyfsnnh
X-Rspam-User: 
X-HE-Tag: 1760164101-230741
X-HE-Meta: U2FsdGVkX19VVXwL4BtSQl7iBdhp7k0ZbNCg4cLFwkxlshQSsUyR3Fbm3oZgpzgwV0LZ28bvV2w+O450i9SY7FK6P3E0CAWub6XFiqg2Nvbne2UYDuRp9OksdKgjXA5i2m0pDnzTaop6oqCva0KgCPndUsiVBMr5MbXQ/VhoiTQJCkcjYIA/dPnahBThHlUD0zH7dDzjvmEg/2wyLWq6zijj4Gq4suup0E0NieWfdYFnUbkVnlVDW756uEMFuUI9FlMwZerYlNTTik0J/ZsjGOAVNemJUnGixSeWAHTT7ZT18LgYTGzUvE9zwG+iNqRzx7RQoVGu6YXoG45/ZBATAuI9GpBSIwpVGEswy/ucLKdQyiplsGcU064cJI6KrCjfhPA58RYxGzYHbFL31f4/9VkfO6FMXrzzLU9tUTaoNp5Ud7xKTp1iiarNijOLtEkVQw1o0stpCpATtTq/3nqftQq3Uf1PocA1wKTv2lthIN5Oa/4U3K9/oM8X9M0Mqzx9P1LloHT9uhIF5YggNyQQiFqsNYZCnQAP/W2fhBir9Jkc3gBjcWi0XycXmmKKB8aFUetIUgK7MJ4RzkKoEUlaS579+bCGBB9SrLnCPaTYpU72ldk9mWld9RVJWeOk62C/3zciBlA2Fr2IU672xbGOjZoia9Nw+wSuxxiiCumq1ILU8Rz4D1/oKdmfkcPrDVFBLCMMxKHSZ9o23d7axXyek4ji7/ydhH1WhY7lnaBcHTwaerAW+UioZc31njFd4O7qXwQ7wmRbr0mGJBMw2xDPFLtduTxg3rcXnyYQGtJwW0LS9f9/hLaLhTHFN6TM8xSmHl12fFg/1cZfUuRw04FRczXGBG4AUTRShIHaMEIQZGowECI+iXBzrmQTjjL3yWNL7CwIP5hlgGKgsZJp4hqd7iiyoFlVOPdJeV6EOm8kdgChDmH3BsXDtNYma1k0G+43Ew0RMG1svURgDEFGbzC
 pwqxrK0s
 KaGWXXiVOo6nms9FTQQcW3w3EXabnEu4yqMHDNTrmzEi/nZL992T2HTn2lLoYjWFEdGh5TlUduZ003mjLkHhRZWJNV+mMid4PQ3Uc/ObUIm1WDLNR2+ImThUY958JBKVrkpICxbi0pt/R0oTFwk12Tvwqj4awHXLdH90V4gSgIft6uoCvsZXnzlNaR4n6aMZFA6e2yg/HizfAlee1z6LcD5i5WUWyLZjyOeqPd2uu5oh8DcU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/9/25 03:56, Matthew Wilcox wrote:
> On Fri, Sep 19, 2025 at 01:39:59PM +0800, Lu Baolu wrote:
>> +static inline void ptdesc_set_kernel(struct ptdesc *ptdesc)
>> +{
>> +	struct folio *folio = ptdesc_folio(ptdesc);
>> +
>> +	folio_set_referenced(folio);
>> +}
> So this was the right way to do this at the time.  However, if you look
> at commit 522abd92279a this should now be ...
> 
>   enum pt_flags {
>   	PT_reserved = PG_reserved,
> +	PT_kernel = PG_referenced,
>   	/* High bits are used for zone/node/section */
>   };
> [...]
> 
> +static inline void ptdesc_set_kernel(struct ptdesc *ptdesc)
> +{
> +	set_bit(PT_kernel, &pt->pt_flags.f);
> +}

Thank you for the review comment. I updated the patch like the
following:

diff --git a/include/linux/mm.h b/include/linux/mm.h
index a3f97c551ad8..5abd427b6202 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2940,6 +2940,7 @@ static inline pmd_t *pmd_alloc(struct mm_struct 
*mm, pud_t *pud, unsigned long a
  #endif /* CONFIG_MMU */

  enum pt_flags {
+       PT_kernel = PG_referenced,
         PT_reserved = PG_reserved,
         /* High bits are used for zone/node/section */
  };
@@ -2965,6 +2966,46 @@ static inline bool pagetable_is_reserved(struct 
ptdesc *pt)
         return test_bit(PT_reserved, &pt->pt_flags.f);
  }

+/**
+ * ptdesc_set_kernel - Mark a ptdesc used to map the kernel
+ * @ptdesc: The ptdesc to be marked
+ *
+ * Kernel page tables often need special handling. Set a flag so that
+ * the handling code knows this ptdesc will not be used for userspace.
+ */
+static inline void ptdesc_set_kernel(struct ptdesc *ptdesc)
+{
+       set_bit(PT_kernel, &ptdesc->pt_flags.f);
+}
+
+/**
+ * ptdesc_clear_kernel - Mark a ptdesc as no longer used to map the kernel
+ * @ptdesc: The ptdesc to be unmarked
+ *
+ * Use when the ptdesc is no longer used to map the kernel and no longer
+ * needs special handling.
+ */
+static inline void ptdesc_clear_kernel(struct ptdesc *ptdesc)
+{
+       /*
+        * Note: the 'PG_referenced' bit does not strictly need to be
+        * cleared before freeing the page. But this is nice for
+        * symmetry.
+        */
+       clear_bit(PT_kernel, &ptdesc->pt_flags.f);
+}
+
+/**
+ * ptdesc_test_kernel - Check if a ptdesc is used to map the kernel
+ * @ptdesc: The ptdesc being tested
+ *
+ * Call to tell if the ptdesc used to map the kernel.
+ */
+static inline bool ptdesc_test_kernel(struct ptdesc *ptdesc)
+{
+       return test_bit(PT_kernel, &ptdesc->pt_flags.f);
+}
+
  /**
   * pagetable_alloc - Allocate pagetables
   * @gfp:    GFP flags

Thanks,
baolu

