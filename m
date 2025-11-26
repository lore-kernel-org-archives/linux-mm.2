Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E710D10F28
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 16:50:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D31D86B0028; Wed, 26 Nov 2025 11:49:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D095F6B0088; Wed, 26 Nov 2025 11:49:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C46E66B008C; Wed, 26 Nov 2025 11:49:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B4A0F6B0028
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:49:59 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4BD9613B91E
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:49:59 +0000 (UTC)
X-FDA: 84153345318.22.61F5136
Received: from fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com [35.158.23.94])
	by imf12.hostedemail.com (Postfix) with ESMTP id D5C9740010
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:49:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="NfGl/JfQ";
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf12.hostedemail.com: domain of "prvs=4186e4d8c=kalyazin@amazon.co.uk" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=4186e4d8c=kalyazin@amazon.co.uk"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764175797; a=rsa-sha256;
	cv=none;
	b=dJPKUXVUxr+vGrR6ZGjm2Tv107lclB0w9NQjek7Wz4BQml/KMVbtclfu2O1bGAj8GivgQh
	gjhBAGCQPLtCaJjFL4QjYXyE6CckV2lgYCTH/SzeBJdDd3qVbYz4+Z+XZ4D4h/eOs5b7Wv
	YrEIvUvJKW8tZ0DPEvoviWqFKz9MpXs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="NfGl/JfQ";
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf12.hostedemail.com: domain of "prvs=4186e4d8c=kalyazin@amazon.co.uk" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=4186e4d8c=kalyazin@amazon.co.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764175797;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ODZ1VeNiyr/lGvz6HoLA70V3LBo9h0c48wtwRnKdqzI=;
	b=Tk4I+Q6/WZzyYL22IrTUW1kAXUfTtGJLdlS9daagQ9cURWs7hjcZth4S7d2bMZ4kAaWO5e
	e2QQ8w8HKUs/h2UGuxLmRoi+Eqqdl6/lJ4ScgVcfPBiDYWoF3M+Fr/4+inXr1Ka8SrLShK
	AT2x18KKPy/vdXI+AypLhzyYfoWbKq4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1764175796; x=1795711796;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=ODZ1VeNiyr/lGvz6HoLA70V3LBo9h0c48wtwRnKdqzI=;
  b=NfGl/JfQ9L+0oSEnCpOJst5f1AAtjdH9TrvI/sEluebD3L5A9R0n0Jqr
   44a1trsGO4G/Qcg5XF8R1ZSEsXBbKVwdsc6hsOBKvLZRxR7rOGFnTxG/V
   nTQ3dXIykAL8/oFV+RZtCT5wsajYYTAX7ZXJXGhywFXufOe9VIUzFjodz
   GcsfagW5Wl84z3FsCpXYx8cHLrCqj4sEwOWVsx+VGPEqfu43+5sVKEaKG
   vOV4bvT6J6XKmtEi/vSPt//Jyssht4RrMhHUGJPsUWi/IY/e62sERPro8
   aET/IPjp0WYLtuy4VMjl1Yg1MP9e3losVDACT9X1m3AA4GDNVJSAnIl1j
   w==;
X-CSE-ConnectionGUID: cGVRR6noRwWrARLD/aWlaA==
X-CSE-MsgGUID: 8cTU9VN8SHafCqwLnVItPg==
X-IronPort-AV: E=Sophos;i="6.20,228,1758585600"; 
   d="scan'208";a="5848663"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 16:49:39 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:15053]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.27.255:2525] with esmtp (Farcaster)
 id ac3d6538-a606-4006-a0e4-7164b8793913; Wed, 26 Nov 2025 16:49:39 +0000 (UTC)
X-Farcaster-Flow-ID: ac3d6538-a606-4006-a0e4-7164b8793913
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Wed, 26 Nov 2025 16:49:33 +0000
Received: from [192.168.8.204] (10.106.83.30) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29; Wed, 26 Nov 2025
 16:49:32 +0000
Message-ID: <bafb0c9e-9ce6-4294-b1d6-e32c41635add@amazon.com>
Date: Wed, 26 Nov 2025 16:49:31 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v2 4/5] guest_memfd: add support for userfaultfd minor
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
References: <20251125183840.2368510-1-rppt@kernel.org>
 <20251125183840.2368510-5-rppt@kernel.org>
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
In-Reply-To: <20251125183840.2368510-5-rppt@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.83.30]
X-ClientProxiedBy: EX19D014EUA001.ant.amazon.com (10.252.50.20) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D5C9740010
X-Stat-Signature: kk8a61q9w8k8rwmbcngo4acrdwpr6pcd
X-Rspam-User: 
X-HE-Tag: 1764175796-241262
X-HE-Meta: U2FsdGVkX19J6wXcH3YBnS2/ocKKLsALs1PmjcTuE47rjqlUNtim486cK0BxLftu3l+iWg+7zJNyjlMSAi6CY616e98kQ/JDYy9HP23sk0wDmRQSJNlv4ShADm4voZqqUj6nx0T2zwBfp+42kOaiki6l6++DcOtQhcl6RL4xrKSXMgCpmV14yft1BNfRp05myg+rc08XULgx/fJOm7K61AlbVLDK6W8SdEmyRdn5HEhef24Q9Ou9iHQqCdrvZW8siWTFQd3rMnZMgQvAqa021OJoHUrZf0eKvLhNZrA/l8DEGbPLQk4KMc6NDrASw5XUPE+7AC5KX6eO/h2jGtYVE+DmglVC2q99+cMxnpB46EcokqN+G2WfMcLa3Ij7sYRfLl/1BKGQ18SIwl3YD92SnqD5klNtSnGDiU2f1bMwIH1ZBkI0Popww1pwid9GDnxhGnY6C9M1Fg44bBtYstTzdMVc4Zg4zfio7zKvCuiihZG/OcgnOQSSgZ/6Jti2SJfOv2lh1CLQcQKORc7yZ8f/pVRUlIDswWlg43yjuRepEOHxBbC9XoJoBMVZNy+QLsZLoDFRVV/5x+FkKu/8R3cUJr7Gk8FFPLRjBMwXOAycjn/c6bR7gOmaRqeHw05bHYq2i5fva82DsPWxHbLQf1G2d/rftag+9Zl0zj0U482xe2hdzN2sDLrcH8eTqdwMWeP3gA9uE8KnerJBl84RrhzdPn5+R/m7AsoilSmGCX1pT/DM+11pz/DZxp8DOOrZaouuIIIOC65AdoJgomPeAfUHy+S+oHR2PS24k/G9vmG25j6cDKS9H43d7s+LntdlQnrC0gvGbIuzw8lx9FnsDHP9t+eWuCU9XTi0LUC0+YthaQO2fTO7FLWuKal8CX1PqivF8sOnwR88NNL51m7g2jXUXdHS3ZqZ6EBNbrCRGdYU4PzC0yK2jmIZep2mTchhZe4x3uAAnoqw+OEsZDFa9UQ
 wBD1wENh
 59dp8iN747xgxRRVnesotS4eRAAx1coqjB9q2OWh4FMSCgW0VYJ/B5ZInSBDZ7trzB29qYEV1O3npVtEsZCorZHeGz9QhJjZqq8h2hHU6i+i8b9nnJeUkjG9qmuQ46C4vpsr4Xrh94re6Z9eI8cjs22Az4WlGLYNsS1xMlLnqdVSPEs4+ch2WTpbQrPd0NKUhbBYHYSch4/btlqqDUQH6dRvQJu4w7tR1HKBgicxc3WNqI049qO+u9y9HPd+x2e4CInOU+onn9F8+h1j3DXUUBDOD6tcTzY0Rwi0ZjhMLzBKIWPDE+ZccjP9Yu+kyN4Fzbdr0RecPnA6bt2pfmJrQMmXNiByQDGwguAKomxGTUWaOD7Vb0ofU5Hn0BD1kfbQziEZCCre0+ygOQX3+BmsGdC74UV/1VnXK7yha7ReYMVESlLr5yDL1lQB2hDIwxyyiZYMOXI8W0QVdsf7Y+Fhkmdly9SE5cnepDooPU+DpQW2OPrU/vSioMaCdT7bYXXMGOoPO/eU6BoRp+OHb4n36+KpIZe272xnMaM5LzTmGKps97EcJ0I7fA93sb4ye+kA6wr3CefIVgUEjL7x52uRh0s8aTRi2JPJioh2Ksm0fxb3I9qLGDPpDV62CJTIFNmlmVpBApCQSIFxP8px2eS6ZXmUglAtJk/EMRUBb0H01fY7XA47woEcUZpwp+wS5dDtMUbK3+zt5K+/7TXDzlC8DUeACLYBF4OE391zQhFOQ4vHLJGkYVCpZr9c15DnnjnEGwCHWvtRX6Ca/W9nDaSlbzCOWjav5GyhT+HFvIyINO6Qxzl/+IDN9pTLHHYNJnI7Yls629+Kk+brdFy87mXWNu7g10mgQBiRGZ5AWyfE43luRZwFCHh6MzORaEBRwynS/ZEi+vtxBzNXf20VZ4vBtdeUr53Ij/AP044PUFTnBKvv90zKfcVaRqwA5jvXiowSw8OhRk2lgk4E/4kkRkQC8+55/AQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 25/11/2025 18:38, Mike Rapoport wrote:
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
> complete and add implementation of ->get_shared_folio() to guest_memfd
> vm_ops.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   virt/kvm/guest_memfd.c | 28 ++++++++++++++++++++++++++++
>   1 file changed, 28 insertions(+)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index ffadc5ee8e04..2a2b076293f9 100644
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
> @@ -369,6 +370,12 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>                  return vmf_error(err);
>          }
> 
> +       if (userfaultfd_minor(vmf->vma)) {
> +               folio_unlock(folio);
> +               folio_put(folio);
> +               return VM_FAULT_UFFD_MINOR;
> +       }
> +
>          if (WARN_ON_ONCE(folio_test_large(folio))) {
>                  ret = VM_FAULT_SIGBUS;
>                  goto out_folio;
> @@ -390,8 +397,29 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>          return ret;
>   }
> 
> +#ifdef CONFIG_USERFAULTFD
> +static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t pgoff)

We have to name it differently, otherwise it clashes with the existing 
one in this file.

> +{
> +       struct folio *folio;
> +
> +       folio = kvm_gmem_get_folio(inode, pgoff);

                   ^^

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
> +       .get_folio      = kvm_gmem_get_folio,
> +#endif
>   };
> 
>   static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
> --
> 2.50.1
> 


