Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0B8FEFCE21
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 17:13:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C82326B0005; Wed,  4 Mar 2026 12:13:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2FB36B0088; Wed,  4 Mar 2026 12:13:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2E766B0089; Wed,  4 Mar 2026 12:13:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A195B6B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 12:13:13 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1C8EF8B672
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:13:13 +0000 (UTC)
X-FDA: 84509026266.19.592FCC2
Received: from fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.158.153.154])
	by imf02.hostedemail.com (Postfix) with ESMTP id A39EC80009
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:13:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=pWyr33JI;
	spf=pass (imf02.hostedemail.com: domain of "prvs=516a86686=kalyazin@amazon.co.uk" designates 18.158.153.154 as permitted sender) smtp.mailfrom="prvs=516a86686=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772644391;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GOyFbmGrjwCzzxO3kPvRp3gPk09ea9B/RkcYvfV3U7w=;
	b=rDssSNbwYH51bGw3dmwj4gSYAEku5oomJ4fsIo41aZLcvydOA7kU58hJMODz7PAEaPtWYT
	5nlrsqNBkMASoUH03MjmJtT5l3uPdxn2OfM4NfaeB/5xj2B5+u1Jdwn8InnyzShG8ICIuU
	2pBhxNvTfDjRI0GyvwbgX1ec+E+GZCQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=pWyr33JI;
	spf=pass (imf02.hostedemail.com: domain of "prvs=516a86686=kalyazin@amazon.co.uk" designates 18.158.153.154 as permitted sender) smtp.mailfrom="prvs=516a86686=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772644391; a=rsa-sha256;
	cv=none;
	b=fuT5NdXN2EYlh4gJJwLMqE40PI0sXUCKxPYI5ExoB1F4aI8ZRnDKTvWVXk9nzLuhWc2vLJ
	j3s9P03ncmF1GTSOuLuO7Y8xtx/BIxImEuAqj6cdMgExcB8p/N4EduNaUz8fLZXfW20bO6
	VGiXvGA1dq+2BGOuA82gMCuKQeZ7/dc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772644390; x=1804180390;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=GOyFbmGrjwCzzxO3kPvRp3gPk09ea9B/RkcYvfV3U7w=;
  b=pWyr33JIxKbbEHhVq8T/YTduH76L/Go+moWbxPNd5FLZ2pEVEcLn7QeL
   e6xYQ0Ytvlz5C0RH8NwdunezEVSOhP4VxHjkOVjwDG85ZCfIeK+sRzH1Q
   /RXFSXo/3OKMS+TesRwg0VhwNWStuLW22jFfjIKwjrk/IR0XT1HnIYaPn
   DeW7tjBRkL1dn7mYewCbFB6NrZL872iyIV+dhDyTq5FXn8/vNGU2DHQmD
   Y1ecctdWx+ROhKLl01/LjoAhpnGvCVpRvLudyRlwjqLwhU219TWsPXIEu
   5gaPi3e4EVteHaVcNnzUG2z78oAFIAgRtDeKVHwz78CtGfyL/CypFDd5A
   w==;
X-CSE-ConnectionGUID: UYsfpQ/XTKGj1mLFxoxIhw==
X-CSE-MsgGUID: vkl+gh6YQl+E7Yf9zukrFQ==
X-IronPort-AV: E=Sophos;i="6.21,324,1763424000"; 
   d="scan'208";a="10202501"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 17:13:06 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:21320]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.16.189:2525] with esmtp (Farcaster)
 id 9f0d1b18-a341-4a05-a845-dd316410b6b5; Wed, 4 Mar 2026 17:13:06 +0000 (UTC)
X-Farcaster-Flow-ID: 9f0d1b18-a341-4a05-a845-dd316410b6b5
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 4 Mar 2026 17:13:06 +0000
Received: from [192.168.5.225] (10.106.83.18) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Wed, 4 Mar 2026
 17:13:05 +0000
Message-ID: <90cf68db-2e21-4153-8eb6-2c8ffb398d0d@amazon.com>
Date: Wed, 4 Mar 2026 17:12:59 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH RFC 15/17] KVM: guest_memfd: implement userfaultfd missing
 mode
To: Mike Rapoport <rppt@kernel.org>, <linux-mm@kvack.org>
CC: Andrea Arcangeli <aarcange@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand
	<david@redhat.com>, Hugh Dickins <hughd@google.com>, James Houghton
	<jthoughton@google.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>, Michal Hocko
	<mhocko@suse.com>, "Muchun Song" <muchun.song@linux.dev>, Oscar Salvador
	<osalvador@suse.de>, "Paolo Bonzini" <pbonzini@redhat.com>, Peter Xu
	<peterx@redhat.com>, "Sean Christopherson" <seanjc@google.com>, Shuah Khan
	<shuah@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, Vlastimil Babka
	<vbabka@suse.cz>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-16-rppt@kernel.org>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
In-Reply-To: <20260127192936.1250096-16-rppt@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.83.18]
X-ClientProxiedBy: EX19D011EUB003.ant.amazon.com (10.252.51.108) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Rspamd-Queue-Id: A39EC80009
X-Rspamd-Server: rspam07
X-Stat-Signature: czeab14qa5caheip3ojjnxn85jgqnt3q
X-Rspam-User: 
X-HE-Tag: 1772644390-584386
X-HE-Meta: U2FsdGVkX19xpcULeB0i2PJ1KmrEGIJzGTEA75ZtuuHoasayjdqZiJ+ZlIM7vIkn77DX7aSRDcocpu+xp74SLlAmfEz0c3n1NzjdNNzLAcXXiJ76dzoc6oVuSwDTlnwvaZ8aGcMeUa+L3MnZlsjDeWE9vd4rK6hlNMErhzhiTcosLhQ+ATc1x5SljrBJvijKG8+pwv06FR3QuolrLgHIhX7XfW9vhFtgyfzMJY+Kk1eyCKOV1hS4pZGRcJBG81WLrxtt8wGdHIik8KIUYtNHMMtexMXB3TOlwAbUtBQ1/Ge6ee5sx+lxed2a886B8/I8kg/paqa4UJ6qJAGu9Jehy/2ER67TfGWzQacTH8rhYpCgM6PqDRf9heIFcXpOVHADsQIKM8/VVC+qy2gtZSjF72PQ3yyR+sLxIgrxlobebt7Q1XjDB1N/T3+UKkEqX/+FoDptzRQ50CfBkXikvQ5YvbpmeRRKlEP0rz0cff0hHRfPeoSnMvIPzbBfPVyg9i1D5gKfoCpaaNVLC1ZuTUSpjbVgptzwlZfMc7GBun5yporLuBZ9sPEpVFORVMxNJNFD66t5QRnpNlCLm5uie9MrRfqzpfHG4TvDW84ZcDy74FhEYlDYsfQzAT2q8cm0Q0IdYmxV52p4zpY8xa3i7mBj+aF3aFxTc1NZ/yXrnQZU6YK2aKWCY8KkM5CCZTM/m/U1hO5nxVNgzRszHOQZ7kJUYjxZvj+IP3Zh4z/SiKpBGBh3Cr4Ib5+M6DP4nPBZDZfQWcGG4pydIa6BmgLHKuCWCQudN5NfdTEtKHi6aXuYeiUQcB0GfYQymRUJSPC7oEY7/slVDLUr/U3AsexfZ4i1a/pHKgenNqhVoxg+hm/r/qxnNF6UfGyOA1VjJqiIaZ4rfr2yuAQ8UvQpPD7x5UcEnmUZz7AwH6jD+r1eJ2vHBIZCn4iYYVPUQMHfAHCFBUUVkkjiVmHtzxwd9zDWPxp
 Dbz0xWoP
 xje/NQIISxIzsS9Xmr6tIB/X2Uros7JHRDuMrLlIzyh/QTX1MV5M+R28rgvYdLHrYzL4oqMcsP6edp3nP5fofGLN2p2pOANWIUcrFpxUcGQM0QoSKqlG6ahr7JIxbuMnVbTV+x6SA3u/HIeyp7bOMbeKpy+0sXJp3ybf83ZTXReQ6WYy0L2FUw+ZamBbyertbI0+ErDzcMEhpPfq/BrMLr4XGXpaJsF8SgjWEGiBV0mUQlSbh8HmjhUebf6J+In9qJjAMF2tq+xGCITh++Wngs9SLi4nILQSdfs3DQABdOh9XTleg1H6ijUQJcqEU6k04iCWpvdoyM9eGaabSUslFhGf8oJMU+q1dbOMSoszjPiqLc3VMw9I7OoHGLxQA2AY9Xkmdla+5qPbwtewn9UmlhF82R+bFhoLC8CCxD0MFy0IvKUcbRxnvFnurbdRAZxEiaqzkV+qzUR/j42lJh63hU8042zf+8Iqx0Ndh3pXiD/u2B9l5TwXnWOFAjS3kohD+YnDiGpwSt1yNC/kP6W3kUv5ZzhM3lbAfNp6wgmud9nKV/osbTqHezsMXLF7hrxhaRVUoaSzT1kMKHORIrU5OZ7XufW72WkqZyNMLWUEFzzdNxafNOvLbd98njOYBiHUFg88+G7A4Vz3gWyIszyqT40TfUHDzKEnNc7SX13RHFdaW6vbDNaD5cCtJzZdWoFp/Lc6ZH9gmHDlnlDUV7fp932DiB7Nz5Vg6srpaH2n3KCwsSHv35tukQJJA8ssRGfd2GGtNaOT1LTCC38Ad5In3Nrwm7IzfpTFZ/oufd2PYljX/4L/MTG8szhM4dz3C+sw9fUaPibka20EMwRhvLYbQ5utPQRij2FsNHDaLbPd/d7OYrOnSHX8bVzmSoQgwHnrTMh2iGWqkX37FzvvGTtLRtWzaoRQKrn19mjs1OPv5KY/9stFskN3VTvepTIMQltdavwL2iertJmoIqHE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 27/01/2026 19:29, Mike Rapoport wrote:
> From: Nikita Kalyazin <kalyazin@amazon.com>
> 
> userfaultfd missing mode allows populating guest memory with the content
> supplied by userspace on demand.
> 
> Extend guest_memfd implementation of vm_uffd_ops to support MISSING
> mode.
> 
> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
> Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   virt/kvm/guest_memfd.c | 60 +++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 59 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 087e7632bf70..14cca057fc0e 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -431,6 +431,14 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>                          ret = VM_FAULT_UFFD_MINOR;
>                          goto out_folio;
>                  }
> +
> +               /*
> +                * Check if userfaultfd is registered in missing mode. If so,
> +                * check if a folio exists in the page cache. If not, return
> +                * VM_FAULT_UFFD_MISSING to trigger the userfaultfd handler.
> +                */
> +               if (userfaultfd_missing(vmf->vma) && IS_ERR_OR_NULL(folio))
> +                       return VM_FAULT_UFFD_MISSING;
>          }
> 
>          /* folio not in the pagecache, try to allocate */
> @@ -507,9 +515,59 @@ static bool kvm_gmem_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_fla
>          return true;
>   }
> 
> +static struct folio *kvm_gmem_folio_alloc(struct vm_area_struct *vma,
> +                                         unsigned long addr)
> +{
> +       struct inode *inode = file_inode(vma->vm_file);
> +       pgoff_t pgoff = linear_page_index(vma, addr);
> +       struct mempolicy *mpol;
> +       struct folio *folio;
> +       gfp_t gfp;
> +
> +       if (unlikely(pgoff >= (i_size_read(inode) >> PAGE_SHIFT)))
> +               return NULL;
> +
> +       gfp = mapping_gfp_mask(inode->i_mapping);
> +       mpol = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, pgoff);
> +       mpol = mpol ?: get_task_policy(current);
> +       folio = folio_alloc_mpol(gfp, 0, mpol, pgoff, numa_node_id());

It looks like folio_alloc_mpol_noprof() and filemap_remove_folio() are 
not actually exported to modules.  Would it be ok to export them similar 
to how it was done in f634f10809ec ("mm/mempolicy: Export memory policy 
symbols")?

diff --git a/mm/filemap.c b/mm/filemap.c
index 3e4579e4b8bb..041c7719e524 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -261,6 +261,7 @@ void filemap_remove_folio(struct folio *folio)

         filemap_free_folio(mapping, folio);
  }
+EXPORT_SYMBOL_FOR_MODULES(filemap_remove_folio, "kvm");

  /*
   * page_cache_delete_batch - delete several folios from page cache
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 3d797d47a040..1dbbbb28a36e 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2442,6 +2442,7 @@ struct folio *folio_alloc_mpol_noprof(gfp_t gfp, 
unsigned int order,
         set_page_refcounted(page);
         return page_rmappable_folio(page);
  }
+EXPORT_SYMBOL_FOR_MODULES(folio_alloc_mpol_noprof, "kvm");

  /**
   * vma_alloc_folio - Allocate a folio for a VMA.

[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f634f10809ec3d51d9529dfb0f99bc7cec1b5eff

> +       mpol_cond_put(mpol);
> +
> +       return folio;
> +}
> +
> +static int kvm_gmem_filemap_add(struct folio *folio,
> +                               struct vm_area_struct *vma,
> +                               unsigned long addr)
> +{
> +       struct inode *inode = file_inode(vma->vm_file);
> +       struct address_space *mapping = inode->i_mapping;
> +       pgoff_t pgoff = linear_page_index(vma, addr);
> +       int err;
> +
> +       __folio_set_locked(folio);
> +       err = filemap_add_folio(mapping, folio, pgoff, GFP_KERNEL);
> +       if (err) {
> +               folio_unlock(folio);
> +               return err;
> +       }
> +
> +       return 0;
> +}
> +
> +static void kvm_gmem_filemap_remove(struct folio *folio,
> +                                   struct vm_area_struct *vma)
> +{
> +       filemap_remove_folio(folio);
> +       folio_unlock(folio);
> +}
> +
>   static const struct vm_uffd_ops kvm_gmem_uffd_ops = {
> -       .can_userfault = kvm_gmem_can_userfault,
> +       .can_userfault     = kvm_gmem_can_userfault,
>          .get_folio_noalloc = kvm_gmem_get_folio_noalloc,
> +       .alloc_folio       = kvm_gmem_folio_alloc,
> +       .filemap_add       = kvm_gmem_filemap_add,
> +       .filemap_remove    = kvm_gmem_filemap_remove,
>   };
>   #endif /* CONFIG_USERFAULTFD */
> 
> --
> 2.51.0
> 


