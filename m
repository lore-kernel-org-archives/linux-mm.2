Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B708DD116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 13:40:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14EC76B0023; Mon,  1 Dec 2025 08:40:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FFDA6B0024; Mon,  1 Dec 2025 08:40:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03C146B0062; Mon,  1 Dec 2025 08:40:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E66256B0023
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 08:40:08 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A3B03131010
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 13:40:08 +0000 (UTC)
X-FDA: 84171010896.28.9AABD2D
Received: from fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.158.153.154])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6190880006
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 13:40:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=hizFFB1G;
	spf=pass (imf30.hostedemail.com: domain of "prvs=4230525c4=kalyazin@amazon.co.uk" designates 18.158.153.154 as permitted sender) smtp.mailfrom="prvs=4230525c4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764596406;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nemidgf20T0MiuPAn2IxvBVJhvchWGtF0eYiaEKtbrI=;
	b=465QJBcZGa1cLCyYQrFDrmM2GnANiFfanKd/07eqyzMeIW4TuxWzmrD0X/YYVmHOieFq9Y
	hq6w4KI7d5TETYODendNvPJTF7LR98A2k0qeo+g+ecVJ787VcFP9FX6Z0/iuu5GO13ncZ2
	0yPHHzLyAJu08/6aS2w7THYy2Wz/hJg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=hizFFB1G;
	spf=pass (imf30.hostedemail.com: domain of "prvs=4230525c4=kalyazin@amazon.co.uk" designates 18.158.153.154 as permitted sender) smtp.mailfrom="prvs=4230525c4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764596406; a=rsa-sha256;
	cv=none;
	b=7kC1AdkiDts+A4kIAjwSZipLZffJPXLEh5IQk/oSpQAn3sTNVqSwz/QA27cZwKr/X8Ijc6
	xrl4E/KlZeZwD5lT+4gXdcqTVXSU8uTURMcoYuAA4vJ6K9fVTdqeFawTvfGcWslkSWxN7O
	MFiEfVgnpUlJHO7B3rcQsMdRgA+3a7k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1764596406; x=1796132406;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=nemidgf20T0MiuPAn2IxvBVJhvchWGtF0eYiaEKtbrI=;
  b=hizFFB1Gf5Fo7mIs2sK9ZxB0d2OcXnKMywV/CD08gR2800AZGVk5yNJK
   gC2wTCtyIHEjsFdcde8Lmim46f/cPse4hHdPGU+8jCkqGNnKSuHK0n8L4
   jmdiOEWFlfJvRaFwuqOu+8X2SB+JQcucibaSOw93oCknrDsd2MjoFtEW3
   1FL+gK9TuQRs8MC4Xseug3yJlqRSQr1qQtdXDUIwPzkaueeH3ZU142xnq
   61rlxdI5+RWH993IHFIXLGD1EmN2f0esEoXifEywYmS+kHLmCvW0Ef4VL
   lYpoIdrViOh5l71dzblnMQW48ueRaNYPRpgBK3bpxF3wZSZ0PH5UJtHdS
   w==;
X-CSE-ConnectionGUID: h5WV4QyQRryAuPtxYLRY1w==
X-CSE-MsgGUID: NHijns49Qe2ZupRDZONfLQ==
X-IronPort-AV: E=Sophos;i="6.20,240,1758585600"; 
   d="scan'208";a="5941279"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 13:39:48 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.226:19444]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.14.220:2525] with esmtp (Farcaster)
 id d52c58bf-1924-463c-99a6-f963e446f61b; Mon, 1 Dec 2025 13:39:47 +0000 (UTC)
X-Farcaster-Flow-ID: d52c58bf-1924-463c-99a6-f963e446f61b
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Mon, 1 Dec 2025 13:39:40 +0000
Received: from [192.168.8.132] (10.106.82.12) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29; Mon, 1 Dec 2025
 13:39:39 +0000
Message-ID: <652578cc-eeff-4996-8c80-e26682a57e6d@amazon.com>
Date: Mon, 1 Dec 2025 13:39:38 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v3 4/5] guest_memfd: add support for userfaultfd minor
 mode
To: Mike Rapoport <rppt@kernel.org>, <linux-mm@kvack.org>
CC: Andrea Arcangeli <aarcange@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand
	<david@redhat.com>, Hugh Dickins <hughd@google.com>, James Houghton
	<jthoughton@google.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>, Michal Hocko
	<mhocko@suse.com>, "Paolo Bonzini" <pbonzini@redhat.com>, Peter Xu
	<peterx@redhat.com>, "Sean Christopherson" <seanjc@google.com>, Shuah Khan
	<shuah@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, Vlastimil Babka
	<vbabka@suse.cz>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>
References: <20251130111812.699259-1-rppt@kernel.org>
 <20251130111812.699259-5-rppt@kernel.org>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
Autocrypt: addr=kalyazin@amazon.com; keydata=
 xjMEY+ZIvRYJKwYBBAHaRw8BAQdA9FwYskD/5BFmiiTgktstviS9svHeszG2JfIkUqjxf+/N
 JU5pa2l0YSBLYWx5YXppbiA8a2FseWF6aW5AYW1hem9uLmNvbT7CjwQTFggANxYhBGhhGDEy
 BjLQwD9FsK+SyiCpmmTzBQJnrNfABQkFps9DAhsDBAsJCAcFFQgJCgsFFgIDAQAACgkQr5LK
 IKmaZPOpfgD/exazh4C2Z8fNEz54YLJ6tuFEgQrVQPX6nQ/PfQi2+dwBAMGTpZcj9Z9NvSe1
 CmmKYnYjhzGxzjBs8itSUvWIcMsFzjgEY+ZIvRIKKwYBBAGXVQEFAQEHQCqd7/nb2tb36vZt
 ubg1iBLCSDctMlKHsQTp7wCnEc4RAwEIB8J+BBgWCAAmFiEEaGEYMTIGMtDAP0Wwr5LKIKma
 ZPMFAmes18AFCQWmz0MCGwwACgkQr5LKIKmaZPNTlQEA+q+rGFn7273rOAg+rxPty0M8lJbT
 i2kGo8RmPPLu650A/1kWgz1AnenQUYzTAFnZrKSsXAw5WoHaDLBz9kiO5pAK
In-Reply-To: <20251130111812.699259-5-rppt@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.82.12]
X-ClientProxiedBy: EX19D012EUC003.ant.amazon.com (10.252.51.208) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Stat-Signature: frqqsoqyu1qo1o97h9oa3heebmbp6z7q
X-Rspam-User: 
X-Rspamd-Queue-Id: 6190880006
X-Rspamd-Server: rspam09
X-HE-Tag: 1764596406-208669
X-HE-Meta: U2FsdGVkX19y735t2lBZXRrSbST5LptoHQqUwuQDS50psxjKvpUPj/Ym32ZdbQOdctPtOZAM0S/Qf5xxfLplW2vlG+990Bf1CkVkxvfoj+DsTF/gKy5M7HYDMm1URicMjJqfuPDjnUmFRlCoGyAKxnHFT57Ma1u9abMANDBpg4ysY9IQWYOvZdPpD29noO+B94/pBO8KZNwSX9A0umxbRWB4aHzU+TIbDH81nBqqsG1PjQ8hKSvoJnnhRqUry2bWPKrHcbznkuNdAOwc3cmI0GEdAwZ5GUF5UpsYaE7aZ0BgthHPBENxjp39Vc7gq5XzHYCvjTdBe/jYlPYPw54yGlku2KV0WpyirPotG8Kq6oHuVUbPNLt91r5ZOdsuR4vJG0vowmr4s3/VL0KVQikvB7novIX+jOaiqqWSotXFQbbJRPUPvq2/GVufuy8YNk9ajfXd15qW3cab0WgTAaaB+ZQX1agvUPthufO3LdN8PWLyIHnXYaZQQX9b7DmxsuA70X5rVz1turvUurMy1ZmWjrvog0pSR8ZF1lh0JTJoiQFV55lx7e6mOsMVZSD/KxNHjd1GkfIS6z6Tpbi4FMO8itzG68YuC2k0rZoNPtKz/27/Vlm6R3mGTYtXvvMSFmMm126Z662RgWMS7Sjg88FGkNhiXCSPwMOisHYGWcSWWpvmtmgYXAqkr63t4cy/Sf/Afd1mFDYt6OD7HBmHefktsYHAlRHSLg4z+V5YuspIJ/RfSQdSyzfRyxAmPKpKFBJgEK+AjWJ60Ftbnef2e06YcX1jnUXvIPAsYNP27Rq31CsNFsowwo7t9UyCf15vYaO4xa3iC8A177tlDyVUIHDdiR7d/EQPhr5Mk/C1VqlgtSwALRQ3PU8j6J6M4UcauBAMmry4HVA46zLe1aZjTnM/f2MKzw+GcKAa0AIDZ7nL/xsY7TAqmtniCPcgFsRlu4aeJuqetO1GtAYu5zKubIj
 bHtt6QG1
 K5AN9vcwW2gzkr2/c4Mxz+VZElMC/fjt1qneuCGcpbFxHGojdLJWCetaU5EDrPMb/yhnsGi0WukSxZ96giSR2qVUIe92Jy/P5Hu4PLH695Bh61KppI0hcqYYoAfc3iVIx985VufLVrdc6YYzFxy05nl9ZdCobOKRMwIj+JZs30ShRZvLWcjRhclHRh0Y/9x3NAyYPztjgWaZFIgG1prhIwG8KeBkifCJzf7hYXALS15nKRsAwiCBVm+aGiL+cjTNfnb1nIJ821OQqlbgCz+HRU2WCEy2teSxRUJucP0p6i7Ep1SU3vtqpkqOI7UKsPq4deD1UlgSCDyEBHHfaptEfyJxpGS1kwa9Cac2h/MDoNScpGkKyMLdQJIfM+ZfyMRaY5p3aRbMFSQPFkRfuGrdwN80w9dA7M+niazXoifCxlVfpwF4YFRgQIh/8gz9rZD5ZojBKQZfLMwz+o2waYNwCmmFGF/x9HfNy14JteeCLfnyuzx8DSIfPPPvo2iRh/j2mR2NYiz6/QNjXkHxjE3L6KViGY3XIo8hLM9IZf1HZuxlT51U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 30/11/2025 11:18, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> userfaultfd notifications about minor page faults used for live migration
> and snapshotting of VMs with memory backed by shared hugetlbfs or tmpfs
> mappings as described in detail in commit 7677f7fd8be7 ("userfaultfd: add
> minor fault registration mode").
> 
> To use the same mechanism for VMs that use guest_memfd to map their memory,
> guest_memfd should support userfaultfd minor mode.
> 
> Extend ->fault() method of guest_memfd with ability to notify core page
> fault handler that a page fault requires handle_userfault(VM_UFFD_MINOR) to
> complete and add implementation of ->get_folio_noalloc() to guest_memfd
> vm_ops.
> 
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   virt/kvm/guest_memfd.c | 33 ++++++++++++++++++++++++++++++++-
>   1 file changed, 32 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index ffadc5ee8e04..dca6e373937b 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -4,6 +4,7 @@
>   #include <linux/kvm_host.h>
>   #include <linux/pagemap.h>
>   #include <linux/anon_inodes.h>
> +#include <linux/userfaultfd_k.h>
> 
>   #include "kvm_mm.h"
> 
> @@ -359,7 +360,15 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>          if (!((u64)inode->i_private & GUEST_MEMFD_FLAG_INIT_SHARED))
>                  return VM_FAULT_SIGBUS;
> 
> -       folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> +       folio = filemap_lock_folio(inode->i_mapping, vmf->pgoff);
> +       if (!IS_ERR_OR_NULL(folio) && userfaultfd_minor(vmf->vma)) {
> +               ret = VM_FAULT_UFFD_MINOR;
> +               goto out_folio;
> +       }

I realised that I might have been wrong in [1] saying that the noalloc 
get folio was ok for our use case.  Unfortunately we rely on a minor 
fault to get generated even when the page is being allocated.  Peter and 
I discussed it originally in [2].  Since we want to populate guest 
memory with the content supplied by userspace on demand, we have to be 
able to intercept the very first access, meaning we either need a minor 
or major UFFD event for that.  We decided to make use of the minor at 
the time.  If we have to preserve the shmem semantics, it forces us to 
implement support for major/UFFDIO_COPY.

[1] 
https://lore.kernel.org/all/4405c306-9d7c-4fd6-9ea6-2ed1b73f5c2e@amazon.com
[2] https://lore.kernel.org/kvm/Z9HhTjEWtM58Zfxf@x1.local

> +
> +       if (PTR_ERR(folio) == -ENOENT)
> +               folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> +
>          if (IS_ERR(folio)) {
>                  int err = PTR_ERR(folio);
> 
> @@ -390,8 +399,30 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>          return ret;
>   }
> 
> +#ifdef CONFIG_USERFAULTFD
> +static struct folio *kvm_gmem_get_folio_noalloc(struct inode *inode,
> +                                               pgoff_t pgoff)
> +{
> +       struct folio *folio;
> +
> +       folio = filemap_lock_folio(inode->i_mapping, pgoff);
> +       if (IS_ERR_OR_NULL(folio))
> +               return folio;
> +
> +       if (!folio_test_uptodate(folio)) {
> +               clear_highpage(folio_page(folio, 0));
> +               kvm_gmem_mark_prepared(folio);
> +       }
> +
> +       return folio;
> +}
> +#endif
> +
>   static const struct vm_operations_struct kvm_gmem_vm_ops = {
>          .fault = kvm_gmem_fault_user_mapping,
> +#ifdef CONFIG_USERFAULTFD
> +       .get_folio_noalloc      = kvm_gmem_get_folio_noalloc,
> +#endif
>   };
> 
>   static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
> --
> 2.51.0
> 


