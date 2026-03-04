Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B179EFCE21
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 17:17:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A1C36B0089; Wed,  4 Mar 2026 12:17:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86C8D6B008C; Wed,  4 Mar 2026 12:17:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 778C26B0092; Wed,  4 Mar 2026 12:17:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 62FAE6B0089
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 12:17:45 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 14E6713ACF0
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:17:45 +0000 (UTC)
X-FDA: 84509037690.05.393094C
Received: from fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.72.182.33])
	by imf25.hostedemail.com (Postfix) with ESMTP id A7EF3A000E
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:17:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=J0WQJQPq;
	spf=pass (imf25.hostedemail.com: domain of "prvs=516a86686=kalyazin@amazon.co.uk" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=516a86686=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772644662;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CPgNxadSzjpIoq3NwpOhLARCcrCv7zz8pTRRdyXfzUA=;
	b=yocrQM+dGkirfGIFq+sI13FHykLzoUojPblIpNisTE1kpvZtVsmOGbxqMot/JzhMFpLrXG
	UqlseNhDujDY2BUdVd3pXMeMTO5GU6TxxbCR9bCVkmqwRIee3SpqvY4mcGkSs7WLkERqaJ
	TVWPWLGcCL+3woZheTx8Jxj58O/7F18=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772644663; a=rsa-sha256;
	cv=none;
	b=RESC+H2y+9WPKacNUeSV7p/jKy9rXnfgPhFCaWVGXnBWt1EAK18e7SXGFxiB0fM+WpWO7f
	D5HYJzPHl3KtDyLP8O6FH5lC4UmJNfR3HyGNaHR85l586RKU2g+iYik14H2eh+QN35+xkU
	QyQ/dFpIWagJMk9+d9vtxX/RtQWKV0Y=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=J0WQJQPq;
	spf=pass (imf25.hostedemail.com: domain of "prvs=516a86686=kalyazin@amazon.co.uk" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=516a86686=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772644662; x=1804180662;
  h=message-id:date:mime-version:reply-to:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=CPgNxadSzjpIoq3NwpOhLARCcrCv7zz8pTRRdyXfzUA=;
  b=J0WQJQPqEl0uJjsubbOKOEHZ/x1kaN6Uq/wbj2RAGuAQifR6srWYEkvM
   rWcKhZWdBJYIFFrZTxofYos0fqKR8sjUNCmN37Ca2m1ysijEku1RNniFf
   Qwb2EprjDfiVHEAY64ez//hVNU1GiDlB8Tb+6HlaxAuON2+z7vCiDt8Y4
   23CEpTa9Q99yImA768Ad5OpSWM3oksfKlnI1NhsaeNiR+kA8QDZs9TZ3j
   aQUdnr6iRn17MvoK+khDgvkg3kHMjWgIAZQsBy+rt9zd8yoHm3iNMXnuk
   kJldyXbK6w1t2KbsWo4Q/RVIvROorb0gIcxDFeT+tfibdHbsXFzlbblC7
   g==;
X-CSE-ConnectionGUID: kCX+YtFiRNyIDKqonzWj2Q==
X-CSE-MsgGUID: rCpAbOjCT3KIJvBbO/BAqg==
X-IronPort-AV: E=Sophos;i="6.21,324,1763424000"; 
   d="scan'208";a="10324163"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 17:17:37 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.233:10769]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.8.50:2525] with esmtp (Farcaster)
 id 5c685bb8-c81d-4b86-ac12-2b82286bbda5; Wed, 4 Mar 2026 17:17:36 +0000 (UTC)
X-Farcaster-Flow-ID: 5c685bb8-c81d-4b86-ac12-2b82286bbda5
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 4 Mar 2026 17:17:30 +0000
Received: from [192.168.5.225] (10.106.83.18) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Wed, 4 Mar 2026
 17:17:29 +0000
Message-ID: <11b78807-00c3-4131-932c-7e32053f9531@amazon.com>
Date: Wed, 4 Mar 2026 17:17:28 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH RFC 15/17] KVM: guest_memfd: implement userfaultfd missing
 mode
From: Nikita Kalyazin <kalyazin@amazon.com>
To: Mike Rapoport <rppt@kernel.org>, <linux-mm@kvack.org>
CC: Andrea Arcangeli <aarcange@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, "Oscar
 Salvador" <osalvador@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Peter Xu
	<peterx@redhat.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan
	<shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka
	<vbabka@suse.cz>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, "david@kernel.org" <david@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-16-rppt@kernel.org>
 <90cf68db-2e21-4153-8eb6-2c8ffb398d0d@amazon.com>
Content-Language: en-US
In-Reply-To: <90cf68db-2e21-4153-8eb6-2c8ffb398d0d@amazon.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.106.83.18]
X-ClientProxiedBy: EX19D013EUA004.ant.amazon.com (10.252.50.48) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A7EF3A000E
X-Stat-Signature: pfx1seogynofhpg8turgt88c3yzhstqt
X-HE-Tag: 1772644662-701790
X-HE-Meta: U2FsdGVkX18dE2Unlm9/gKjn4ChtWNmbNzIEyzhCFSDmevl1O+mceWyDNDypfvI6IIqu5uwfXGcqPnQd4Eaq8GJ5cDooqWLVu3yGf8eEowRPYv5wggot0JR4O3c7RQ66Ts4yY76u2TAzM9yEy9nf/vYofHECCIm7QvRRHRExAOYhe6EYbrjGOv8YlXxjIytE+NvrR1slx7y0qvWq08QSDIJn7RuxmIAmPZ4TfvoD2pAN+e7c3SLInPnJ4mMpeRBYxSExugmbp2jk3u9txoG4LDjxKVA8UHadX2bHEfxU0iygoC9CrokaNN7SnCFger8YPDdp0VAL4zycxk6PHEMD79On8hS32hMChZNX8RU+riVsqB9O8icQkwYXKXSU1K8nVhTckBPlutovBdNteV/P+C4zOTfPNMMfTuJytwr7FxM1PerqkDtYXj0HibKE8lD3+wJimMcYwqbZPtdX5L8nmuEqJuE48eSl4ngOR1s883maO/9skV36JLxWV4W4B9TUWrEiPDk3yEomandul0vDk1tNIZDmFnFZba/XGnhSAs8NtlkfKtnnHBBoDMvRiETOTnx/embdggYcfihU7dsvjbxdpaH0N2R0srJ/+KQM00yGfyMdpk0GR3W4rz13/LlnCxnnfpdK/FrArjbaKhvB2r+NnO4QkVweex29Aj2SHbbDwxlaZ6gddsOKsuvuDnkSr/kmdYCS9UfBqDvTsdLmtcQsS5MoDXVg3QqLpHQsCJaKHRyhPpcnn5CreeQdQ7Rd3Unlp/3mKUP8on9CCixJpVCXXYGsXOeevkNzYUDCn0ricTKvvqRd5GEudeKpZSpSnYhs9pqdqdhxRibEf9t3anocKWyqP1zooGl1wSgqsGTQPYm44g/8yo6/Lau3qn30HLrCxStcRAv2WW5oU7f0HMOyfNoE95ypQx6Lrme5L1YQqirp1zJGHTuAedarkI+CZi0BO+gGfJzUaSO2ZUr
 aJg6RLbE
 nflajU1dFZrXUWY1R3Mzt7a6u7Vo1bmqtfEoltnns6AtvkPd3g/Re7FbbSv3cyOoYAMIrWAMupsSwN+sKgXO1lSArAFnbcNx8CV2pxxJYhn/+A2yLyz61jCbSap5RFiXK7vL5pcImISyOgvbxUmUu6ux33rnoEXlgz/4CMRW1hz/U3hAsw6PADEkxxmJQNnKI2EZ/UxV1grvN0ozx//rnJz3wGJxOWfz84IZIru/+cvA6JnABACf7Gy13pHiqHYhLvJPvxWFt9QiL2NEfZnN5ATD8CbU06E2KKL6aR0xhWw+zwMaxczG954gaKmJYIeapmnqbuKQCn9rZfeVyO5Q811zDqH7rsHJtmvFJ50U71JwuPqzhqA3326OIwFpV1LeC0hfGNGBt36ErCkuIzlGfHes1WIShmP0+M3Q/G0CjJhC15aVhcnumPjt0oey3s76wtEt/cpE8OeKTS/R04wzv6/c1GbeyqGmQfal0tBrJBsGx2srCIYWjIyhh0FiY10UBlepohLBdr+yle9aVUmnO9pH422jVBDtiY6naEjmuyB69ZXQnCjV31p1nVU2X0iVMLnT6qu80y4yIjKzAoqej2kb1KAbQpZ9WgghfaqVdrsaUGtiX69RHTbQx3FqmSh5LZWa4QgGtJpULf0BnG2eonDM37EavQBEgZ3DZFDsTGxhYjeaHF0zHPlb0IqSi63nq972nbe7NIHR1II+/k13VNFMJYbzX6dXZox5/dNO1GK3NpcUVAPLbv9VqXD3qhD+jx7ay+94vPMFYlvERyXT0ceKjSr7ezPZ9gqOO/iGkUrrj+5v4+AExxIDNfIl9TqZPIPHzV4e0Y8dwEhXKzRSHQj1du6RlVYaFT3KBsWc/h0168vCJebtBsMKKPN40enAAtzoGpMAYkThcGwTb/3bEyljjm80xOLWlD9aZHeGJulVa6yNDvAzP6JaLlBAKzYX7nVfJCFeuZ61wmBIMIFELeFg5PaCO
 YNTr2mZ/
 eoSFDGOFoTC6/7XsVQRgm7bSGjkgI5v5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ David's new email


On 04/03/2026 17:12, Nikita Kalyazin wrote:
> 
> 
> On 27/01/2026 19:29, Mike Rapoport wrote:
>> From: Nikita Kalyazin <kalyazin@amazon.com>
>>
>> userfaultfd missing mode allows populating guest memory with the content
>> supplied by userspace on demand.
>>
>> Extend guest_memfd implementation of vm_uffd_ops to support MISSING
>> mode.
>>
>> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
>> Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> ---
>>   virt/kvm/guest_memfd.c | 60 +++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 59 insertions(+), 1 deletion(-)
>>
>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> index 087e7632bf70..14cca057fc0e 100644
>> --- a/virt/kvm/guest_memfd.c
>> +++ b/virt/kvm/guest_memfd.c
>> @@ -431,6 +431,14 @@ static vm_fault_t 
>> kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>>                          ret = VM_FAULT_UFFD_MINOR;
>>                          goto out_folio;
>>                  }
>> +
>> +               /*
>> +                * Check if userfaultfd is registered in missing mode. 
>> If so,
>> +                * check if a folio exists in the page cache. If not, 
>> return
>> +                * VM_FAULT_UFFD_MISSING to trigger the userfaultfd 
>> handler.
>> +                */
>> +               if (userfaultfd_missing(vmf->vma) && 
>> IS_ERR_OR_NULL(folio))
>> +                       return VM_FAULT_UFFD_MISSING;
>>          }
>>
>>          /* folio not in the pagecache, try to allocate */
>> @@ -507,9 +515,59 @@ static bool kvm_gmem_can_userfault(struct 
>> vm_area_struct *vma, vm_flags_t vm_fla
>>          return true;
>>   }
>>
>> +static struct folio *kvm_gmem_folio_alloc(struct vm_area_struct *vma,
>> +                                         unsigned long addr)
>> +{
>> +       struct inode *inode = file_inode(vma->vm_file);
>> +       pgoff_t pgoff = linear_page_index(vma, addr);
>> +       struct mempolicy *mpol;
>> +       struct folio *folio;
>> +       gfp_t gfp;
>> +
>> +       if (unlikely(pgoff >= (i_size_read(inode) >> PAGE_SHIFT)))
>> +               return NULL;
>> +
>> +       gfp = mapping_gfp_mask(inode->i_mapping);
>> +       mpol = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, pgoff);
>> +       mpol = mpol ?: get_task_policy(current);
>> +       folio = folio_alloc_mpol(gfp, 0, mpol, pgoff, numa_node_id());
> 
> It looks like folio_alloc_mpol_noprof() and filemap_remove_folio() are 
> not actually exported to modules.  Would it be ok to export them similar 
> to how it was done in f634f10809ec ("mm/mempolicy: Export memory policy 
> symbols")?
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 3e4579e4b8bb..041c7719e524 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -261,6 +261,7 @@ void filemap_remove_folio(struct folio *folio)
> 
>          filemap_free_folio(mapping, folio);
>   }
> +EXPORT_SYMBOL_FOR_MODULES(filemap_remove_folio, "kvm");
> 
>   /*
>    * page_cache_delete_batch - delete several folios from page cache
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 3d797d47a040..1dbbbb28a36e 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2442,6 +2442,7 @@ struct folio *folio_alloc_mpol_noprof(gfp_t gfp, 
> unsigned int order,
>          set_page_refcounted(page);
>          return page_rmappable_folio(page);
>   }
> +EXPORT_SYMBOL_FOR_MODULES(folio_alloc_mpol_noprof, "kvm");
> 
>   /**
>    * vma_alloc_folio - Allocate a folio for a VMA.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/ 
> commit/?id=f634f10809ec3d51d9529dfb0f99bc7cec1b5eff
> 
>> +       mpol_cond_put(mpol);
>> +
>> +       return folio;
>> +}
>> +
>> +static int kvm_gmem_filemap_add(struct folio *folio,
>> +                               struct vm_area_struct *vma,
>> +                               unsigned long addr)
>> +{
>> +       struct inode *inode = file_inode(vma->vm_file);
>> +       struct address_space *mapping = inode->i_mapping;
>> +       pgoff_t pgoff = linear_page_index(vma, addr);
>> +       int err;
>> +
>> +       __folio_set_locked(folio);
>> +       err = filemap_add_folio(mapping, folio, pgoff, GFP_KERNEL);
>> +       if (err) {
>> +               folio_unlock(folio);
>> +               return err;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static void kvm_gmem_filemap_remove(struct folio *folio,
>> +                                   struct vm_area_struct *vma)
>> +{
>> +       filemap_remove_folio(folio);
>> +       folio_unlock(folio);
>> +}
>> +
>>   static const struct vm_uffd_ops kvm_gmem_uffd_ops = {
>> -       .can_userfault = kvm_gmem_can_userfault,
>> +       .can_userfault     = kvm_gmem_can_userfault,
>>          .get_folio_noalloc = kvm_gmem_get_folio_noalloc,
>> +       .alloc_folio       = kvm_gmem_folio_alloc,
>> +       .filemap_add       = kvm_gmem_filemap_add,
>> +       .filemap_remove    = kvm_gmem_filemap_remove,
>>   };
>>   #endif /* CONFIG_USERFAULTFD */
>>
>> -- 
>> 2.51.0
>>
> 


