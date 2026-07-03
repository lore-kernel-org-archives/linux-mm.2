Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 573D7C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 10:19:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C3E56B00B4; Fri,  3 Jul 2026 06:19:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 077336B00B5; Fri,  3 Jul 2026 06:19:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7ED36B00B6; Fri,  3 Jul 2026 06:19:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B62DB6B00B4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 06:19:34 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 277931A049B
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 10:19:34 +0000 (UTC)
X-FDA: 84947068668.18.0CBF8AB
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf25.hostedemail.com (Postfix) with ESMTP id 87B30A000F
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 10:19:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e0Cuc7Jv;
	spf=pass (imf25.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783073972;
	b=RB+E7uuG7qR3o6yRuSX79q1pIIXaen+cGFFamVhLFbIgdE8QEMRiKqkeOVLU/pIDZ1iD9q
	Zg2ana1CsDLbNBj2UhA5vGo02svNZACF6yMn5UqmEW1e7bt4E2bxVWJReWasITbYprw8Fn
	r/gJ6H5f0epe/Sp8QYS4A9eWdnJ8aa8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783073972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kh3FyxapX81U/ZPkDXPQ35eHo8l1a0EYTCkh/tPyQcQ=;
	b=tEJRPA5xKpRaO7Eeu4jLpkKCXx4iAdHbezQT69JdhcEuzqdMFsbBUVJv+VyiTv4A6wMl0O
	lknYpd+cYAZX7zqitGnaxFVV2VJEnrxMEFR/dYtaqwpeDlXMQ4XzuJaGF1jJK12s4Nfr4d
	lO5QVe4nmgcFs4wz0HwrBkC2BcTRzNs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e0Cuc7Jv;
	spf=pass (imf25.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783073967;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kh3FyxapX81U/ZPkDXPQ35eHo8l1a0EYTCkh/tPyQcQ=;
	b=e0Cuc7JvJVHteKushc+UtNVkwNT9o1lVu5LvqWVmdqPsMSPQgu9A2kRfsnx0xQfRnUHPYp
	E5DoGGsQTiJ/6LeWKpBLgQMBOdLAW9HcOCrzUybirGsEQP8UiAZrRmv4xietGvdTMPXY2X
	gD/tE/T+aE5W3zMioXiLzp1kYJy+Cz0=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 03 Jul 2026 10:19:10 +0000
Message-Id: <DJOUYOKL6N3R.BFIO8HEL03OA@linux.dev>
Subject: Re: [PATCH v12 02/16] set_memory: add
 folio_{zap,restore}_direct_map helpers
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "linux-doc@vger.kernel.org"
 <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
 <kvmarm@lists.linux.dev>, "linux-fsdevel@vger.kernel.org"
 <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "kernel@xen0n.name" <kernel@xen0n.name>, "linux-riscv@lists.infradead.org"
 <linux-riscv@lists.infradead.org>, "linux-s390@vger.kernel.org"
 <linux-s390@vger.kernel.org>, "loongarch@lists.linux.dev"
 <loongarch@lists.linux.dev>, "linux-pm@vger.kernel.org"
 <linux-pm@vger.kernel.org>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net"
 <corbet@lwn.net>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "will@kernel.org"
 <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
 "tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
 "bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com"
 <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
 "hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>,
 "peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org"
 <willy@infradead.org>, "akpm@linux-foundation.org"
 <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org"
 <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
 "mhocko@suse.com" <mhocko@suse.com>, "ast@kernel.org" <ast@kernel.org>,
 "martin.lau@linux.dev" <martin.lau@linux.dev>, "eddyz87@gmail.com"
 <eddyz87@gmail.com>, "song@kernel.org" <song@kernel.org>,
 "yonghong.song@linux.dev" <yonghong.song@linux.dev>,
 "john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org"
 <kpsingh@kernel.org>, "sdf@fomichev.me" <sdf@fomichev.me>,
 "haoluo@google.com" <haoluo@google.com>, "jolsa@kernel.org"
 <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com"
 <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>,
 "jannh@google.com" <jannh@google.com>, "pfalcato@suse.de"
 <pfalcato@suse.de>, "skhan@linuxfoundation.org"
 <skhan@linuxfoundation.org>, "riel@surriel.com" <riel@surriel.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jgross@suse.com"
 <jgross@suse.com>, "yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>,
 "kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com" <coxu@redhat.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>, "yosry@kernel.org"
 <yosry@kernel.org>, "maobibo@loongson.cn" <maobibo@loongson.cn>,
 "tabba@google.com" <tabba@google.com>, "prsampat@amd.com"
 <prsampat@amd.com>, "jthoughton@google.com" <jthoughton@google.com>,
 "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, "aou@eecs.berkeley.edu"
 <aou@eecs.berkeley.edu>, "borntraeger@linux.ibm.com"
 <borntraeger@linux.ibm.com>, "chenhuacai@kernel.org"
 <chenhuacai@kernel.org>, "baolu.lu@linux.intel.com"
 <baolu.lu@linux.intel.com>, "dev.jain@arm.com" <dev.jain@arm.com>,
 "gor@linux.ibm.com" <gor@linux.ibm.com>, "hca@linux.ibm.com"
 <hca@linux.ibm.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>,
 "pjw@kernel.org" <pjw@kernel.org>, "shijie@os.amperecomputing.com"
 <shijie@os.amperecomputing.com>, "svens@linux.ibm.com"
 <svens@linux.ibm.com>, "thuth@redhat.com" <thuth@redhat.com>,
 "yang@os.amperecomputing.com" <yang@os.amperecomputing.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "urezki@gmail.com"
 <urezki@gmail.com>, "zhengqi.arch@bytedance.com"
 <zhengqi.arch@bytedance.com>, "gerald.schaefer@linux.ibm.com"
 <gerald.schaefer@linux.ibm.com>, "jiayuan.chen@shopee.com"
 <jiayuan.chen@shopee.com>, "rafael@kernel.org" <rafael@kernel.org>,
 "yangyicong@hisilicon.com" <yangyicong@hisilicon.com>,
 "vannapurve@google.com" <vannapurve@google.com>, "jackmanb@google.com"
 <jackmanb@google.com>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>,
 "Itazuri, Takahiro" <itazur@amazon.co.uk>, "Manwaring, Derek"
 <derekmn@amazon.com>
References: <20260410151746.61150-1-kalyazin@amazon.com>
 <20260410151746.61150-3-kalyazin@amazon.com>
In-Reply-To: <20260410151746.61150-3-kalyazin@amazon.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 87B30A000F
X-Rspam-User: 
X-Stat-Signature: 5dpmxwbjknddctyq55ua1b4ntaxgrn8m
X-HE-Tag: 1783073971-197381
X-HE-Meta: U2FsdGVkX1/7sA0YPhtPNNK9jQnVfa2tnPeCReGeSt/TBYAEi26bIvDti86CHC7BmLl4mRJLSoVWKHd8UheaKQxttcGn3vuJNLuuFBQwuaRFOFj4ASMTD518nN7pQ86+EqncRci9qmLh9FcwzoCQB13D9lXy9wLr6EmsMoPOuNVTwG9j2kITaRDZfzZ602qWKz47tXnZwcKP2mfjnH6yMcf1r/UzFR3uyRJ17l04CTKeBmDU0hFqKIQVltgq3BODG1F4uVSvTPza8QfQ0GAQlgDyvvjQYc6EYgIAnfU/6yYdB8jvdb8CT9xkY7TtRXzJmDoMYivYaELCCAT+/LkgWGJ3Eo1Ku2wyc0qBave2OOdOJMcyr5ltoo/379/cFgl0vGI7ivlr2kzBwV/fZvrVX2NVEQemJDkhGxm+09y8F8LogoDbZYMuGBObX6c0e4NkRs6/i5M6iVUTDo/ZAIxebSV6CIhB0Mq/3INkJQxE/dGcsyrFUC4DS48tQ6eQscTH70UY4aPdbgjlh20Q/wEJPVa2tMIXW3Gbj95tsXK39HtQ2TaKBPn4wG6nSh6fl8a9nuqNCywEzyoMoZx+n50R2Hml6AImYLRGM1IvBJZmGE55ab9FD7OmNr62HCYv+aMW7yBVtJqOqHAMV+E9Fcmo5Gifv1z6bx3U+Su6Jw3OJf9RT5gFroGwqkNsba7c8+IFfPMLAGqvIOaFj7tdSRpiIDAy0ZUDq8hlXsj5Mn4uBNJyPu7LZnYml3GHYjrcLDmF0U2rM1jO+9fmNgnJ3v/P9+le7Ta083qAPjtK3CzIMWGIk2AYm2RM2CLqUbrIuwCnkVq7GBgK5i6Q87hf5s1FDNJ3r+VYG2MiaCD+MghGcsDN0MtDHl12al9v1Wpj+0+JeCE07SGQ9tprLT3D4wt6QBTMFNJd6AfyGWHRzGw34q4PVO4XxRfMGtMtCN3uk8qWfKKPX4mACfsHMFgEzQC
 q8oN1H0m
 ixI44WDpcVJeNbyX7D5sYAziMOiqzRvEfCFbnXYYMQRiqvTeYxAD+UBQ68RPWblU7WZJrRxoVslcMvAmGknH7Mpz0PUkFM5yzlvQINXAQRLBjL3weM/P6en1J77Mi/e7BNbKhlUcOXB5Ghc26LiVkoxSlDeZAT8hrXijq4i2QPvB8vZ/Ef3eHF8z5D+/SPwno4qdP7dnBKAapD9l9ilgXXmuULUm5wTg2SvsGOPNYH4ra8DolnUJ/b1aK61sUv0TOGybs24COAYjA0o2By//pCXk7wSz40QojCeCriBgGQxfaQp0ksPNQIYxER0cxa7ngRPueoS+fBTUJ4tQSC4cr21nqWo7yk87TEHbFtODQKXpa/bz3UiBrydxpLxpcxIHTcXi145sXOmi3SieGafG4Y+ad7Lb0N2ivshzOgUBPuSPiv/R3cgWOe6SJDIo1OpZqB3ZPpZI2DlJ/YvDEl6g0ZlDx6p5KcWqfB6Qty0VR5AD/nc0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Apr 10, 2026 at 3:18 PM UTC, Nikita Kalyazin wrote:
> From: Nikita Kalyazin <nikita.kalyazin@linux.dev>
>
> Let's provide folio_{zap,restore}_direct_map helpers as preparation for
> supporting removal of the direct map for guest_memfd folios.
> In folio_zap_direct_map(), flush TLB to make sure the data is not
> accessible.  On some architectures, there may be a double TLB flush
> issued because set_direct_map_valid_noflush already performs a flush
> internally.
>
> The new helpers need to be accessible to KVM on architectures that
> support guest_memfd (x86 and arm64).
>
> Direct map removal gives guest_memfd the same protection that
> memfd_secret does, such as hardening against Spectre-like attacks
> through in-kernel gadgets.
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Nikita Kalyazin <nikita.kalyazin@linux.dev>
> ---
>  include/linux/set_memory.h | 13 +++++++++++
>  mm/memory.c                | 45 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 58 insertions(+)
>
> diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
> index 1a2563f525fc..24caea2931f9 100644
> --- a/include/linux/set_memory.h
> +++ b/include/linux/set_memory.h
> @@ -41,6 +41,15 @@ static inline int set_direct_map_valid_noflush(const v=
oid *addr,
>  	return 0;
>  }
> =20
> +static inline int folio_zap_direct_map(struct folio *folio)
> +{
> +	return 0;
> +}
> +
> +static inline void folio_restore_direct_map(struct folio *folio)
> +{
> +}
> +
>  static inline bool kernel_page_present(struct page *page)
>  {
>  	return true;
> @@ -57,6 +66,10 @@ static inline bool can_set_direct_map(void)
>  }
>  #define can_set_direct_map can_set_direct_map
>  #endif
> +
> +int folio_zap_direct_map(struct folio *folio);
> +void folio_restore_direct_map(struct folio *folio);
> +
>  #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
> =20
>  #ifdef CONFIG_X86_64
> diff --git a/mm/memory.c b/mm/memory.c
> index 2f815a34d924..3b9ada2cc19c 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -78,6 +78,7 @@
>  #include <linux/sched/sysctl.h>
>  #include <linux/pgalloc.h>
>  #include <linux/uaccess.h>
> +#include <linux/set_memory.h>
> =20
>  #include <trace/events/kmem.h>
> =20
> @@ -7479,3 +7480,47 @@ void vma_pgtable_walk_end(struct vm_area_struct *v=
ma)
>  	if (is_vm_hugetlb_page(vma))
>  		hugetlb_vma_unlock_read(vma);
>  }
> +
> +#ifdef CONFIG_ARCH_HAS_SET_DIRECT_MAP
> +/**
> + * folio_zap_direct_map - remove a folio from the kernel direct map
> + * @folio: folio to remove from the direct map
> + *
> + * Removes the folio from the kernel direct map and flushes the TLB.  Th=
is may
> + * require splitting huge pages in the direct map, which can fail due to=
 memory
> + * allocation.  So far, only order-0 folios are supported.
> + *
> + * Return: 0 on success, or a negative error code on failure.
> + */
> +int folio_zap_direct_map(struct folio *folio)
> +{
> +	const void *addr =3D folio_address(folio);
> +	int ret;
> +
> +	if (folio_test_large(folio))
> +		return -EINVAL;
> +
> +	ret =3D set_direct_map_valid_noflush(addr, folio_nr_pages(folio), false=
);
> +	flush_tlb_kernel_range((unsigned long)addr,
> +			       (unsigned long)addr + folio_size(folio));
> +
> +	return ret;
> +}

My local Sashiko run pointed out that this is broken for highmem.

There's no highmem for guest_memfd but there is for secretmem.

... but this isn't actually an issue with the patch, it's currently
broken in Linus' master:

Su[   30.071284] ------------[ cut here ]------------
ccessfully allocated and mapped 2097152000 bytes at 0x3a449000
Populating memor[   30.074614] CPA: called for zero pte. vaddr =3D 0 cpa->v=
addr =3D 0
y...
[   30.078636] WARNING: arch/x86/mm/pat/set_memory.c:1840 at __cpa_process_=
fault+0x34d/0x360, CPU#5: allocate_secret/570
[   30.084789] CPU: 5 UID: 0 PID: 570 Comm: allocate_secret Not tainted 7.1=
.0-14063-g4edcdefd4083-dirty #10 PREEMPTLAZY
[   30.090937] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
[   30.097543] EIP: __cpa_process_fault+0x34d/0x360
[   30.100514] Code: ff ff 85 c0 0f 89 7d fe ff ff e9 3d fe ff ff 8b 03 8b =
00 c7 04 24 c8 ff 64 c1 89 44 24 08 8b 45 e8 89 44 24 04 e8 53 7a 00 00 <0f=
> 0b c7 45 f0 f2 ff ff ff e9 fc fc ff ff 90 8d 74 26 00 55 25 00
[   30.110829] EAX: 00000000 EBX: f64afe98 ECX: 00000000 EDX: 00000000
[   30.114799] ESI: 00000000 EDI: f64afe98 EBP: f64afe04 ESP: f64afdcc
[   30.118785] DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068 EFLAGS: 0001024=
6
[   30.123020] CR0: 80050033 CR2: 46c48ffc CR3: 038c8000 CR4: 00000690
[   30.127010] Call Trace:
[   30.129078]  __change_page_attr_set_clr+0x5e7/0x870
[   30.132275]  ? console_unlock+0x99/0x130
[   30.135069]  ? irq_work_queue+0x36/0x70
[   30.137853]  ? page_address+0xd3/0xf0
[   30.140421]  set_direct_map_invalid_noflush+0x52/0x60
[   30.143782]  secretmem_fault+0x128/0x210
[   30.146560]  __do_fault+0x25/0x90
[   30.149053]  handle_mm_fault+0x6d1/0xcb0
[   30.151759]  exc_page_fault+0x135/0x3b0
[   30.154487]  ? doublefault_shim+0x150/0x150
[   30.157416]  handle_exception+0x130/0x130
[   30.160137] EIP: 0x804d29f
[   30.162307] Code: 89 54 08 e1 89 54 08 e5 89 54 08 e9 89 54 08 ed c3 0f =
b6 44 24 08 89 7c 24 0c 69 c0 01 01 01 01 8b 7c 24 04 f7 c7 0f 00 00 00 <89=
> 44 0f fc 75 0e c1 e9 02 f3 ab 8b 44 24 04 8b 7c 24 0c c3 31 d2
[   30.172936] EAX: 5a5a5a5a EBX: 00000000 ECX: 0c800000 EDX: 3a449000
[   30.176927] ESI: 00000000 EDI: 3a449000 EBP: bfbbae18 ESP: bfbbadac
[   30.180897] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 0001024=
6
[   30.185161]  ? doublefault_shim+0x150/0x150
[   30.187979] ---[ end trace 0000000000000000 ]---
Bus error                  (core dumped) ./allocate_secret_i686 2000M

Fixing this directly in secretmem.c is kinda yucky but if we can just
make folio_zap_direct_map() a NOP for highmem folios it's nice and easy
so I propose to just fix it as a followup to this series.

Alternatively, we maybe should disable secretmem for highmem systems
since it evidently doesn't have any users.

