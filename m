Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E662FEEF56
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 15:01:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 489886B00AE; Tue,  7 Apr 2026 11:01:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 439FC6B00AF; Tue,  7 Apr 2026 11:01:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 303146B00B0; Tue,  7 Apr 2026 11:01:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1651D6B00AE
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 11:01:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B24E1160888
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 15:01:22 +0000 (UTC)
X-FDA: 84632073204.27.5EB5390
Received: from iad-out-001.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-001.esa.us-east-1.outbound.mail-perimeter.amazon.com [107.22.191.150])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6E1B5100008
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 15:01:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=sVx9tjGg;
	spf=pass (imf14.hostedemail.com: domain of "prvs=55035e87f=kalyazin@amazon.co.uk" designates 107.22.191.150 as permitted sender) smtp.mailfrom="prvs=55035e87f=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=sVx9tjGg;
	spf=pass (imf14.hostedemail.com: domain of "prvs=55035e87f=kalyazin@amazon.co.uk" designates 107.22.191.150 as permitted sender) smtp.mailfrom="prvs=55035e87f=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775574079; a=rsa-sha256;
	cv=none;
	b=hq+9MVicskzFdJG11mDEcbIHXYQ2Bf0nSvpAVziKcnTBvWSTE1GNP2P+TCneOqlJGVI0IN
	cnNPiJdetgStYWxMPnDBbPBELgPDRPU35ZOckakhWJ1Va43ipA+HuF+jx6p5e2ascJbfuF
	OMLbMijyFAe2vC6frW79Z2DcWwKLQaU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775574079;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bXFue4CzneVNAUS4v5FS5sS8xN9kUhj+uU79zotALlE=;
	b=GSinroTVWqZEwU9K1S4dL2p27leDRHxUMIz+xgCJvAwdbAYz8R3etqJO5R8CRqzvswr4XV
	E5wVLXurbzR4d/8tDTyMiZPiE6an8Sy85He3ZNETMiz65DQAUP3aWkuRH8UTjrg6vxQD+I
	vnCzeHe6T6IFUQh8btO1ZuDT3MKISPg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1775574079; x=1807110079;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=bXFue4CzneVNAUS4v5FS5sS8xN9kUhj+uU79zotALlE=;
  b=sVx9tjGg82s5hBz94nTJnw3LTaLPFvdWrm0sWOKaxOJeuJBHmR/sejtS
   3UVzrZ49OslLApNTL2nHqjkN6XGj/2K2Y+/uMFjLf1H0SiYEJUhB/NDbC
   LBSnNOesVJkMgeINIXSfNN2n+ZVRjQspZtNurc8dwgTUaFmFJfB3hyMxl
   4G+zVWCiDMgGtDpxNWzBPQYiocF4MnK2R2GLbgxMERvDOW/fdNRXiWyDK
   GgvtUUSWGnB5FfC5h6gaIe+aBqLydfaEF5MyaFs9/WNVoDSL5QWOaQYZE
   va73V6FBZgM1wpWmRNhQ63Mrf4N/cw3b+vMZxENrQhUEjMb/skNSfewPs
   w==;
X-CSE-ConnectionGUID: xZCsw8LsSsy0L2k2ntCVFA==
X-CSE-MsgGUID: HTpfa+OORmacjwkQSIHjEQ==
X-IronPort-AV: E=Sophos;i="6.23,165,1770595200"; 
   d="scan'208";a="15250780"
Received: from ip-10-4-17-41.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.17.41])
  by internal-iad-out-001.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 15:01:15 +0000
Received: from EX19MTAUEC001.ant.amazon.com [52.94.133.134:5670]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.46.155:2525] with esmtp (Farcaster)
 id 4afc94d5-1501-4b30-9870-7a2c9f5a830c; Tue, 7 Apr 2026 15:01:15 +0000 (UTC)
X-Farcaster-Flow-ID: 4afc94d5-1501-4b30-9870-7a2c9f5a830c
Received: from EX19D027UEC003.ant.amazon.com (10.252.137.250) by
 EX19MTAUEC001.ant.amazon.com (10.252.135.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 7 Apr 2026 15:01:13 +0000
Received: from [192.168.5.214] (10.106.82.17) by EX19D027UEC003.ant.amazon.com
 (10.252.137.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Tue, 7 Apr 2026
 15:01:10 +0000
Message-ID: <8c563ffe-531d-4cb7-b445-813bb93766f1@amazon.com>
Date: Tue, 7 Apr 2026 16:01:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v4 13/15] KVM: guest_memfd: implement userfaultfd
 operations
To: Sean Christopherson <seanjc@google.com>, Mike Rapoport <rppt@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Andrea Arcangeli
	<aarcange@redhat.com>, Andrei Vagin <avagin@google.com>, Axel Rasmussen
	<axelrasmussen@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>, Harry Yoo <harry.yoo@oracle.com>, "Hugh
 Dickins" <hughd@google.com>, James Houghton <jthoughton@google.com>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, "Lorenzo Stoakes (Oracle)"
	<ljs@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, "Michal
 Hocko" <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, Oscar Salvador
	<osalvador@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Peter Xu
	<peterx@redhat.com>, Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan
	<surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, <kvm@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-mm@kvack.org>
References: <20260402041156.1377214-1-rppt@kernel.org>
 <20260402041156.1377214-14-rppt@kernel.org> <ac7oE_1j6gxf8OKT@google.com>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
In-Reply-To: <ac7oE_1j6gxf8OKT@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.82.17]
X-ClientProxiedBy: EX19D006EUC001.ant.amazon.com (10.252.51.203) To
 EX19D027UEC003.ant.amazon.com (10.252.137.250)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6E1B5100008
X-Stat-Signature: godgxdmqdr5qb1jtw4s6a4ibo7d8i7cr
X-Rspam-User: 
X-HE-Tag: 1775574079-367436
X-HE-Meta: U2FsdGVkX18N++X+v2t5jF1XDnmEk68QMPbWMwT3XclfIRAiTJUzjg2CbeNW3W318Mvz31Vfev+o3QfIUSpZu+FubWBTHlq+0tgqwBC7nAz4kSrpgIE0iUud01urX6BSOi6scGzNATTW9N4YcJsGvV/qNMLZVDyL1pCXsT+mfDlALq4lykN0lESOAaUDkRS092Eb44bYzlwp3N+5LCAtigPUSzNwKyMOPn5Z+ndKvfh4sRmbeXLS4QZWTPyOrj/pya+ylmaco7d5UNTTvT1tisV6+BSXq90EdQ+ROXItp0Qz4QTET9gahMt/pNSBE566jg9Do1k21XmO1i3MFIvvkUHN2xgKRcY7PEjJHO3vl5q9TZDsvi45i25bc3lDo/IrtoEsNjZpaEBwVy65osOb9ZKI+D8yT10bPvMffTemavOxp03SA57rHeIpIQWxGLyyf3uwD/rxzL62+IDOpRYrbbO7UZd7VZAyGkKtChekHxRxZGh4pG1/aU8lPod61BzfO4fHXapswY+tN5eKVe6jCKtCwp3RvHahnQgfSKX+vbUjF8OVg0Y3lLcUd+Qnyb7gPoDwtzYQ03El+n4/PmjmymQrHKo/GHngd4F1qNQ0Y/7eltCWA852gHcl3aj8aiknyWS7tkaCsCM/BNyNLuF0tX9HB+HlkIfjBvjQr518m6EEXFgRbjkEswQVdPHiSERyyYDJNtUxm2O2ngWJEk4eAhBovDyQbYs4czGY851nQVpfV9/d7A9/qk4hL6DUqbF4Gec8e7kKuXLAeoS1ksvWAMF+eGaWJoD6re6Lv4mWyyio0jq2Qfq18WcfaGXgBsm9N9bVFOxnaLouYwdOjvlPzYqeJWXesM3I5sm2Y6MyC8hKoqIVQYLgPfzxc1oB0e/G7mts58RSeRgO/1imItelmPbPKwKH2FiVnRUyh9LXHTnfoUulImpUIu+xXH+7j3qXAu6WIuBWV0HNF7rGTG1
 xCn7uhU+
 ddeSo+Gi+mI7gVUu/DIsMbVknZNfoUFgutvT0C1KzTtJVC1gWzK5kQNC2zAFzEH8nmmivD80DcXX+ofWSOuMAPePcTZd1RqK9PUWEUaIVs28E7Fjd+bhkiWiB72nHeEb4jdaRdUYiWed3g/gn0yhK7lfBwJiU0Dpbl+BEZaZ/SUy+wv0JaXASS0cFApftMv32BL3CHciD9utOqNUttFXLAx1UY5uMYeAwsT8jU2DnupN6ieaztOGv4nLF8LUJ9oom0Pd9zONmvuFYTjPMLqtmx7r8ZxVuc6hUjDPErlHaGiSn9R3hlLYB5u1ZHY1c/WW9Bp4EInnlmGXsZUNJCkhJpd8YJlZz4erh/SY7wtJwBwrkgoja7c1dPmY0DNeNPZnbhMze4a1/1YmyjdoY82/QqQOkKBfyYUaxXOm4wuaOjljAltUtbxX+3EcgAHc573Y4/vhilYJbPrijRsV75o5qT3JrW3fAr6/qj1D6ZotWqsndNdo/m7MDoG6nSXyMFoOaeVj+/9C6bxdGmhINofCgl81CJrWPVTx8QmpZcJcPiaOR9ovkoIP2i/lBS+YGGIkkrHCq4fu5ZiBi2f7YfRGhemW2cNTDzlbyyzXbWWJjvovLOoUiNpTIagTUnxkfw4riwftVvmtOCkvSvsj975pyh5CSlIsXh/B9kuOoUxR3/w3qoh/leeXYHLTYVtihfAGPjPxU/ATSlVApk0RhngKxZ+2XktH6m9QLbCNamYPNYse07SXGPm9zIPmaCdMC4NHl2m6UCBgQ11YFRAtyYptoC9EIIW5tQZ4WssAR5GQdmLiZlHPRserPt84JLmEeo4J5/den/ItC6L7bY7HsqsQuXMkXsn4XiUiSyiiU/588OeGPQShbpeCYWc7FRUhT1W+Lck9d6ld2hjN4HJmA4t6d8Tf+rqYbzqHdRXERaxrdtqykImkSwyw7E+1WWG9ZWjkPifW1G9B0VFY0VYmsm10lbjARt4Nw
 vKVyyT2n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/04/2026 23:05, Sean Christopherson wrote:
> On Thu, Apr 02, 2026, Mike Rapoport wrote:
>> From: Nikita Kalyazin <kalyazin@amazon.com>
>> 
>> userfaultfd notifications about page faults used for live
>> migration and snapshotting of VMs.
>> 
>> MISSING mode allows post-copy live migration and MINOR mode allows 
>> optimization for post-copy live migration for VMs backed with
>> shared hugetlbfs or tmpfs mappings as described in detail in
>> commit 7677f7fd8be7 ("userfaultfd: add minor fault registration
>> mode").
>> 
>> To use the same mechanisms for VMs that use guest_memfd to map
>> their memory, guest_memfd should support userfaultfd operations.
>> 
>> Add implementation of vm_uffd_ops to guest_memfd.
>> 
>> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com> Co-developed-
>> by: Mike Rapoport (Microsoft) <rppt@kernel.org> Signed-off-by:
>> Mike Rapoport (Microsoft) <rppt@kernel.org> --- mm/
>> filemap.c           |  1 + virt/kvm/guest_memfd.c | 84 ++++++++++++
>> +++++++++++++++++++++++++++++- 2 files changed, 83 insertions(+),
>> 2 deletions(-)
>> 
>> diff --git a/mm/filemap.c b/mm/filemap.c index
>> 406cef06b684..a91582293118 100644 --- a/mm/filemap.c +++ b/mm/
>> filemap.c @@ -262,6 +262,7 @@ void filemap_remove_folio(struct
>> folio *folio)
>> 
>> filemap_free_folio(mapping, folio); } 
>> +EXPORT_SYMBOL_FOR_MODULES(filemap_remove_folio, "kvm");
> 
> This can be EXPORT_SYMBOL_FOR_KVM so that the symbol is exported if
> and only if KVM is built as a module.
> 
>> /* * page_cache_delete_batch - delete several folios from page
>> cache diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c 
>> index 017d84a7adf3..46582feeed75 100644 --- a/virt/kvm/
>> guest_memfd.c +++ b/virt/kvm/guest_memfd.c @@ -7,6 +7,7 @@ 
>> #include <linux/mempolicy.h> #include <linux/pseudo_fs.h> #include
>> <linux/pagemap.h> +#include <linux/userfaultfd_k.h>
>> 
>> #include "kvm_mm.h"
>> 
>> @@ -107,6 +108,12 @@ static int kvm_gmem_prepare_folio(struct kvm
>> *kvm, struct kvm_memory_slot *slot, return
>> __kvm_gmem_prepare_folio(kvm, slot, index, folio); }
>> 
>> +static struct folio *kvm_gmem_get_folio_noalloc(struct inode
>> *inode, pgoff_t pgoff) +{ +     return __filemap_get_folio(inode-
>> >i_mapping, pgoff, +                                FGP_LOCK |
>> FGP_ACCESSED, 0);
> 
> Note, this will conflict with commit 6dad5447c7bf ("KVM:
> guest_memfd: Don't set FGP_ACCESSED when getting folios") sitting in
> 
> https://github.com/kvm-x86/linux.git gmem
> 
> I think the resolution is to just end up with:
> 
> static struct folio *kvm_gmem_get_folio_noalloc(struct inode *inode,
> pgoff_t pgoff) { return filemap_lock_folio(inode->i_mapping, pgoff); 
> }
> 
> However, I think that'll be a moot point in the end (the conflict
> will be avoided). More below.
> 
>> +} + /* * Returns a locked folio on success.  The caller is
>> responsible for * setting the up-to-date flag before the memory is
>> mapped into the guest. @@ -126,8 +133,7 @@ static struct folio
>> *kvm_gmem_get_folio(struct inode *inode, pgoff_t index) * Fast-
>> path: See if folio is already present in mapping to avoid *
>> policy_lookup. */ -     folio = __filemap_get_folio(inode-
>> >i_mapping, index, -                                 FGP_LOCK |
>> FGP_ACCESSED, 0); +     folio = kvm_gmem_get_folio_noalloc(inode,
>> index); if (!IS_ERR(folio)) return folio;
>> 
>> @@ -457,12 +463,86 @@ static struct mempolicy
>> *kvm_gmem_get_policy(struct vm_area_struct *vma, } #endif /*
>> CONFIG_NUMA */
>> 
>> +#ifdef CONFIG_USERFAULTFD +static bool
>> kvm_gmem_can_userfault(struct vm_area_struct *vma, vm_flags_t
>> vm_flags) +{ +     struct inode *inode = file_inode(vma->vm_file); 
>> + +     /* +      * Only support userfaultfd for guest_memfd with
>> INIT_SHARED flag. +      * This ensures the memory can be mapped
>> to userspace. +      */ +     if (!(GMEM_I(inode)->flags &
>> GUEST_MEMFD_FLAG_INIT_SHARED)) +             return false;
> 
> I'm not comfortable with this change.  It works for now, but it's
> going to be wildly wrong when in-place conversion comes along.
> While I agree with the "Let's solve each problem in it's
> time :)"[*], the time for in-place conversion is now. In-place
> conversion isn't landing this cycle or next, but it's been in
> development for longer than UFFD support, and I'm not willing to
> punt solvable problems to that series, because it's plenty fat as
> is.
> 
> Happily, IIUC, this is an easy problem to solve, and will have a
> nice side effect for the common UFFD code.
> 
> My objection to an early, global "can_userfault()" check is that
> it's guaranteed to cause TOCTOU issues.  E.g. for VM_UFFD_MISSING
> and VM_UFFD_MINOR, the check on whether or not a given address can
> be faulted in needs to happen in __do_userfault(), not broadly when
> VM_UFFD_MINOR is added to a VMA.  Conceptually, that also better 
> aligns the code with the "normal" user fault path in
> kvm_gmem_fault_user_mapping().
> 
> I'm definitely not asking to fully prep for in-place conversion, I
> just want to set us up for success and also to not have to churn a
> pile of code.  Concretely, again IIUC, I think we just need to move
> the INIT_SHARED check to ->alloc_folio() and ->get_folio_noalloc().
> And if we extract kvm_gmem_is_shared_mem() now instead of waiting
> for in-place conversion, then we'll avoid a small amount of churn
> when in-place conversion comes along.
> 
> The bonus side effect is that dropping guest_memfd's more "complex" 
> can_userfault means the only remaining check is constant based on
> the backing memory vs. the UFFD flags.  If we want, the indirect
> call to a function can be replace with a constant vm_flags_t
> variable that enumerates the supported (or unsupported if we're
> feeling negative) flags, e.g.

Thanks Sean.  Checking for GUEST_MEMFD_FLAG_INIT_SHARED at the time of
use and adding uffd_ prefixes to the callbacks make sense to me.  I
tested your changes in my local setup and they are functional with minor 
tweaks:
  - remove the no-longer-used anon_can_userfault
  - fix for the vm_flags check


diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 100aeadd7180..df91c40c6281 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -32,14 +32,6 @@ struct mfill_state {
  	pmd_t *pmd;
  };

-static bool anon_can_userfault(struct vm_area_struct *vma, vm_flags_t 
vm_flags)
-{
-	/* anonymous memory does not support MINOR mode */
-	if (vm_flags & VM_UFFD_MINOR)
-		return false;
-	return true;
-}
-
  static struct folio *anon_alloc_folio(struct vm_area_struct *vma,
  				      unsigned long addr)
  {
@@ -2051,7 +2043,7 @@ bool vma_can_userfault(struct vm_area_struct *vma, 
vm_flags_t vm_flags,
  	    !ops->get_folio_noalloc)
  		return false;

-	return ops->supported_uffd_flags & vm_flags;
+	return (ops->supported_uffd_flags & vm_flags) == vm_flags;
  }

  static void userfaultfd_set_vm_flags(struct vm_area_struct *vma,

> 
> diff --git a/include/linux/userfaultfd_k.h b/include/linux/
> userfaultfd_k.h index 6f33307c2780..8a2d0625ffa3 100644 --- a/
> include/linux/userfaultfd_k.h +++ b/include/linux/userfaultfd_k.h @@
> -82,8 +82,8 @@ extern vm_fault_t handle_userfault(struct vm_fault
> *vmf, unsigned long reason);
> 
> /* VMA userfaultfd operations */ struct vm_uffd_ops { -       /*
> Checks if a VMA can support userfaultfd */ -       bool
> (*can_userfault)(struct vm_area_struct *vma, vm_flags_t vm_flags); 
> +       /* What UFFD flags/modes are supported. */ +       const
> vm_flags_t supported_uffd_flags; /* * Called to resolve
> UFFDIO_CONTINUE request. * Should return the folio found at pgoff in
> the VMA's pagecache if it
> 
> with usage like:
> 
> static const struct vm_uffd_ops shmem_uffd_ops = { 
> .supported_uffd_flags   = __VM_UFFD_FLAGS, .get_folio_noalloc      =
> shmem_get_folio_noalloc, .alloc_folio            =
> shmem_mfill_folio_alloc, .filemap_add            =
> shmem_mfill_filemap_add, .filemap_remove         =
> shmem_mfill_filemap_remove, };
> 
> [*] https://lore.kernel.org/all/acZuW7_7yBdVsJqK@kernel.org
> 
>> +     return true; +}
> 
> ...
> 
>> +static const struct vm_uffd_ops kvm_gmem_uffd_ops = { 
>> +     .can_userfault     = kvm_gmem_can_userfault, 
>> +     .get_folio_noalloc = kvm_gmem_get_folio_noalloc, 
>> +     .alloc_folio       = kvm_gmem_folio_alloc, 
>> +     .filemap_add       = kvm_gmem_filemap_add, 
>> +     .filemap_remove    = kvm_gmem_filemap_remove,
> 
> Please use kvm_gmem_uffd_xxx().  The names are a bit verbose, but
> these are waaay to generic of names as-is, e.g.
> kvm_gmem_folio_alloc() has implications and restrictions far beyond
> just allocating a folio.
> 
> All in all, somelike like so (completely untested):
> 
> --- include/linux/userfaultfd_k.h |  4 +- mm/
> filemap.c                  |  1 + mm/hugetlb.c                  |  8
> +--- mm/shmem.c                    |  7 +-- mm/
> userfaultfd.c              |  6 +-- virt/kvm/guest_memfd.c        |
> 80 ++++++++++++++++++++++++++++++++++- 6 files changed, 87
> insertions(+), 19 deletions(-)
> 
> diff --git a/include/linux/userfaultfd_k.h b/include/linux/
> userfaultfd_k.h index 6f33307c2780..8a2d0625ffa3 100644 --- a/
> include/linux/userfaultfd_k.h +++ b/include/linux/userfaultfd_k.h @@
> -82,8 +82,8 @@ extern vm_fault_t handle_userfault(struct vm_fault
> *vmf, unsigned long reason);
> 
> /* VMA userfaultfd operations */ struct vm_uffd_ops { -       /*
> Checks if a VMA can support userfaultfd */ -       bool
> (*can_userfault)(struct vm_area_struct *vma, vm_flags_t vm_flags); 
> +       /* What UFFD flags/modes are supported. */ +       const
> vm_flags_t supported_uffd_flags; /* * Called to resolve
> UFFDIO_CONTINUE request. * Should return the folio found at pgoff in
> the VMA's pagecache if it diff --git a/mm/filemap.c b/mm/filemap.c 
> index 6cd7974d4ada..19dfcebcd23f 100644 --- a/mm/filemap.c +++ b/mm/
> filemap.c @@ -262,6 +262,7 @@ void filemap_remove_folio(struct folio
> *folio)
> 
> filemap_free_folio(mapping, folio); } 
> +EXPORT_SYMBOL_FOR_MODULES(filemap_remove_folio, "kvm");
> 
> /* * page_cache_delete_batch - delete several folios from page cache 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c index
> 077968a8a69a..f55857961adb 100644 --- a/mm/hugetlb.c +++ b/mm/
> hugetlb.c @@ -4819,14 +4819,8 @@ static vm_fault_t
> hugetlb_vm_op_fault(struct vm_fault *vmf) }
> 
> #ifdef CONFIG_USERFAULTFD -static bool hugetlb_can_userfault(struct
> vm_area_struct *vma, -                                 vm_flags_t
> vm_flags) -{ -       return true; -} - static const struct
> vm_uffd_ops hugetlb_uffd_ops = { -       .can_userfault =
> hugetlb_can_userfault, +       .supported_uffd_flags =
> __VM_UFFD_FLAGS, }; #endif
> 
> diff --git a/mm/shmem.c b/mm/shmem.c index
> 239545352cd2..76d8488b9450 100644 --- a/mm/shmem.c +++ b/mm/shmem.c 
> @@ -3250,13 +3250,8 @@ static struct folio
> *shmem_get_folio_noalloc(struct inode *inode, pgoff_t pgoff) return
> folio; }
> 
> -static bool shmem_can_userfault(struct vm_area_struct *vma,
> vm_flags_t vm_flags) -{ -       return true; -} - static const
> struct vm_uffd_ops shmem_uffd_ops = { 
> -       .can_userfault          = shmem_can_userfault, 
> +       .supported_uffd_flags   = __VM_UFFD_FLAGS, 
> .get_folio_noalloc      = shmem_get_folio_noalloc, 
> .alloc_folio            = shmem_mfill_folio_alloc, 
> .filemap_add            = shmem_mfill_filemap_add, diff --git a/mm/
> userfaultfd.c b/mm/userfaultfd.c index 9ba6ec8c0781..ccbd7bb334c2
> 100644 --- a/mm/userfaultfd.c +++ b/mm/userfaultfd.c @@ -58,8 +58,8
> @@ static struct folio *anon_alloc_folio(struct vm_area_struct *vma, 
> }
> 
> static const struct vm_uffd_ops anon_uffd_ops = { 
> -       .can_userfault  = anon_can_userfault, 
> -       .alloc_folio    = anon_alloc_folio, 
> +       .supported_uffd_flags   = __VM_UFFD_FLAGS & ~VM_UFFD_MINOR, 
> +       .alloc_folio            = anon_alloc_folio, };
> 
> static const struct vm_uffd_ops *vma_uffd_ops(struct vm_area_struct
> *vma) @@ -2055,7 +2055,7 @@ bool vma_can_userfault(struct
> vm_area_struct *vma, vm_flags_t vm_flags, !ops->get_folio_noalloc) 
> return false;
> 
> -       return ops->can_userfault(vma, vm_flags); +       return ops-
> >supported_uffd_flags & vm_flags; }
> 
> static void userfaultfd_set_vm_flags(struct vm_area_struct *vma, 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c index
> 462c5c5cb602..e634bf671d12 100644 --- a/virt/kvm/guest_memfd.c +++ b/
> virt/kvm/guest_memfd.c @@ -7,6 +7,7 @@ #include <linux/mempolicy.h> 
> #include <linux/pseudo_fs.h> #include <linux/pagemap.h> +#include
> <linux/userfaultfd_k.h>
> 
> #include "kvm_mm.h"
> 
> @@ -59,6 +60,11 @@ static pgoff_t kvm_gmem_get_index(struct
> kvm_memory_slot *slot, gfn_t gfn) return gfn - slot->base_gfn + slot-
> >gmem.pgoff; }
> 
> +static bool kvm_gmem_is_shared_mem(struct inode *inode, pgoff_t
> index) +{ +       return GMEM_I(inode)->flags &
> GUEST_MEMFD_FLAG_INIT_SHARED; +} + static int
> __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot
> *slot, pgoff_t index, struct folio *folio) { @@ -396,7 +402,7 @@
> static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf) 
> if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode)) return
> VM_FAULT_SIGBUS;
> 
> -       if (!(GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED)) 
> +       if (!kvm_gmem_is_shared_mem(inode, vmf->pgoff)) return
> VM_FAULT_SIGBUS;
> 
> folio = kvm_gmem_get_folio(inode, vmf->pgoff); @@ -456,12 +462,84 @@
> static struct mempolicy *kvm_gmem_get_policy(struct vm_area_struct
> *vma, } #endif /* CONFIG_NUMA */
> 
> +#ifdef CONFIG_USERFAULTFD +static struct folio
> *kvm_gmem_uffd_get_folio_noalloc(struct inode *inode, 
> +                                                    pgoff_t pgoff) 
> +{ +       if (!kvm_gmem_is_shared_mem(inode, pgoff)) 
> +               return NULL; + +       return
> filemap_lock_folio(inode->i_mapping, pgoff); +} + +static struct
> folio *kvm_gmem_uffd_folio_alloc(struct vm_area_struct *vma, 
> +                                              unsigned long addr) 
> +{ +       struct inode *inode = file_inode(vma->vm_file); +
> pgoff_t pgoff = linear_page_index(vma, addr); +       struct
> mempolicy *mpol; +       struct folio *folio; +       gfp_t gfp; + 
> +       if (unlikely(pgoff >= (i_size_read(inode) >> PAGE_SHIFT))) 
> +               return NULL; + +       if (!
> kvm_gmem_is_shared_mem(inode, pgoff)) +               return NULL; + 
> +       gfp = mapping_gfp_mask(inode->i_mapping); +       mpol =
> mpol_shared_policy_lookup(&GMEM_I(inode)->policy, pgoff); +
> mpol = mpol ?: get_task_policy(current); +       folio =
> filemap_alloc_folio(gfp, 0, mpol); +       mpol_cond_put(mpol); + 
> +       return folio; +} + +static int
> kvm_gmem_uffd_filemap_add(struct folio *folio, 
> +                                    struct vm_area_struct *vma, 
> +                                    unsigned long addr) +{ +
> struct inode *inode = file_inode(vma->vm_file); +       struct
> address_space *mapping = inode->i_mapping; +       pgoff_t pgoff =
> linear_page_index(vma, addr); +       int err; + +
> __folio_set_locked(folio); +       err = filemap_add_folio(mapping,
> folio, pgoff, GFP_KERNEL); +       if (err) { +
> folio_unlock(folio); +               return err; +       } + +
> return 0; +} + +static void kvm_gmem_uffd_filemap_remove(struct
> folio *folio, +                                        struct
> vm_area_struct *vma) +{ +       filemap_remove_folio(folio); +
> folio_unlock(folio); +} + +static const struct vm_uffd_ops
> kvm_gmem_uffd_ops = { +       .supported_uffd_flags   =
> __VM_UFFD_FLAGS, +       .get_folio_noalloc      =
> kvm_gmem_uffd_get_folio_noalloc, +       .alloc_folio            =
> kvm_gmem_uffd_folio_alloc, +       .filemap_add            =
> kvm_gmem_uffd_filemap_add, +       .filemap_remove         =
> kvm_gmem_uffd_filemap_remove, +}; +#endif /* CONFIG_USERFAULTFD */ + 
> static const struct vm_operations_struct kvm_gmem_vm_ops = { 
> .fault          = kvm_gmem_fault_user_mapping, #ifdef CONFIG_NUMA 
> .get_policy     = kvm_gmem_get_policy, .set_policy     =
> kvm_gmem_set_policy, #endif +#ifdef CONFIG_USERFAULTFD 
> +       .uffd_ops       = &kvm_gmem_uffd_ops, +#endif };
> 
> static int kvm_gmem_mmap(struct file *file, struct vm_area_struct
> *vma)
> 
> base-commit: d63beb006dba56d5fa219f106c7a97eb128c356f --


