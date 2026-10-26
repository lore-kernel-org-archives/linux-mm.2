Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 400AE606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 11:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=BodUu069
Received: by kanga.kvack.org (Postfix)
	id 1BE9C6B05B0; Mon, 26 Oct 2026 07:50:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16E746B05B1; Mon, 26 Oct 2026 07:50:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 035A16B05B2; Mon, 26 Oct 2026 07:50:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C36F56B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 07:50:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C32F11A06FC
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:49:59 +0000 (UTC)
X-FDA: 85364608518.30.A0A99F1
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf09.hostedemail.com (Postfix) with ESMTP id D03D2140006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:49:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=BodUu069;
	spf=pass (imf09.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.169 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793015397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VISLXd9A6kVIeHStuLPHvX3dA8WAZRLfoTFh4XJxWjc=;
	b=pXHccjzEEmJ1ux9x8K4USMUaxdBH4oA45LCtACmGkRmTrDErGyP2081BYxWQ/pyBAAIRhP
	AD+tyzzU4ftWDXkK8eu7f/kJwodimKEjOlK+HVnz+/NQ4BgHd7YIOZ5SUWAxt2jYAOq1aW
	JG9eU+y0bs59lcfcqqalBUlUFNsoWAg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=BodUu069;
	spf=pass (imf09.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.169 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793015397;
	b=H30LaVAdwHlimFb8fbuA/+n6LHTFf8VzMQimYzbBJsz6w4FUAcRnKeANX1jL9EmLILjHPF
	9oT9OqB0nUEih/9UVmuGR6LO8I/XcjVFhldDOuDWD9Yxilom6rqfqzpP6kUShbCBydTqnr
	YfPwmiXLShnoIaHfEDdyOVPPPmuT2gM=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-93f2f2edb19so263856385a.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 04:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793015397; x=1793620197; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VISLXd9A6kVIeHStuLPHvX3dA8WAZRLfoTFh4XJxWjc=;
        b=BodUu069k4MsEvmuHn82Ykc6adBS/giOiQLNtCN05GCKlp0DFTV//4YeqJmKgExraZ
         ypl1Am0pDN7i/syAUR3Wsd6p6+GedudWVSUx+NVkuiNHhv5UoGgzX9ii9BtIqjlZ9Djy
         ZQeK4YzRNZs7tauslUm6Rs9gL+9QRBVe/APrDyeDFS+px6/VEXdIir7ynn90j7+0wynf
         QceSnGTcbWf3eYAYXFMjmfobJpleSTdgdDtZYlWsYmBHR4FBzppkkWbMgfy05PblzCJ2
         +49Oc/YiebroFEz4ja/rAPxS2UvrqYqMcDSUKJo4KVto9DQepmnoMQKCuJ89UdeRyeuB
         i8Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793015397; x=1793620197;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VISLXd9A6kVIeHStuLPHvX3dA8WAZRLfoTFh4XJxWjc=;
        b=UFa9DXt87OAnczVw+pUyQkm56aZeYQZ8hAt/57IE/FNw0T8eSUv28ZrZ1o81PsRuXo
         PadF45g1ZXxrmZTrW7iPsKsFuPpks9xmxFK+Hl8rt5KTmPbY43dcTCqdDAZyR5kdfdeK
         SsKkp6Hun0gS4jWJOoXoLXhIeN8Rn8N7aaHk/grIuucsZ11kwpoWitvcxAmA8QiwU2J2
         UN9WGNTsRj5nUd9+6uw+LE5B7yPC6vyRj5JPB6MTOV0OjKUWGCZEXhnSPHhJNRi91GLZ
         4A8RNUOZ5qi6CsCdHryeEdswsSAGvzIZJDcMDHbJXVX2U/Z7VEGBwi27wCKqgnQEybPW
         XdBg==
X-Forwarded-Encrypted: i=1; AKwUvBw3kzDexI4lJO3W0f1XVk1dUt7tVfjmtV1pEgQ4NnvY6MqnFqnkGoqlwa0dOqmCBY/MrU8W2ZgYyA==@kvack.org
X-Gm-Message-State: AFq9FYIsQW3sgzMw6EDSe7InUCMzJQ/1UGE9px7OvTOdpmK8V/IaFBxI
	L6SCAfjVF2WI8BpuuaEloNGfLjUk7sGVfqnZjSE3nw380r/iR5Yek0/tYVJQiTQUj3A=
X-Gm-Gg: AYBFou3mIKjwFrgwBYQl9zQ/SF+9r689q7XkY7d5SOqp6SEUeBWe1KB2Uyf69xgwx9n
	ad/yEYC7APVZ9/lmkaWBZdwAHVRmVcRzPjSjLHuOpok2zoYYFYFsqMbH+S42vlP/LAPnLJT3/l2
	CIYHUo197dtx51SFdhEi+mLS0Bm5XYGjeils2Y8iSUG7psJtrCocS+XNytLICr0Pb6RbfQSQ3Bt
	DgTcyfF2h0KNRpsC+SxQffl1+g0A6LfuRQKyoTPxdBs5J/0nMJWPZryThc1bNeMz7H3DyKcMt+x
	CMh7Ga6IWT6KXTSjCwjdItOuenGn7oX6ae6mxDMyvsbBXpkSSXhHKnZ5HEmEpipbOgWk3wrRSdW
	0pBLMMtIgV2FQqlu/Cz4WTJMiA4LRi3A/SYTqdiVsy1M7Xolus467dXHHmN/bY9Hk+7HCo6IyJj
	F8U+LWj9FVqSmHgyjCSj9n/z8iYGndZJV6X4VOuhpWNIS0qeWFy+Y/tV7d9wPCFRTLFymhoRDNQ
	awaOiumUFu9//yoB9UUsMkqhnTDpOX1bxTygaHKfIBR4JlEJEjot1za29OYoRU5KDKb4B0EYz6D
	dh+J5sYMvPgz2jUdu+BlYGtdJehSjyBkmI1HamN0chnS458OMv3Yda61yWw=
X-Received: by 2002:a05:620a:4482:b0:93e:c12c:43f9 with SMTP id af79cd13be357-940ef9bcb84mr927155285a.70.1793015396920;
        Mon, 26 Oct 2026 04:49:56 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-940f06690c0sm666997585a.11.2026.10.26.04.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 04:49:56 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xLJD9-00000006ir2-3FkQ;
	Mon, 26 Oct 2026 08:49:55 -0300
Date: Mon, 26 Oct 2026 08:49:55 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Zi Yan <ziy@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>, linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/uverbs: Don't return the shared zero page from
 rdma_umap_fault()
Message-ID: <20261026114955.GP3977851@ziepe.ca>
References: <20261025-fix-rdma_umap_fault-zero-page-v1-1-186255624f1f@nvidia.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261025-fix-rdma_umap_fault-zero-page-v1-1-186255624f1f@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D03D2140006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: r4u6mnwfykjg53jnuies8peauzmnfhye
X-HE-Tag: 1793015397-755592
X-HE-Meta: U2FsdGVkX1+Tzge57hLMWJ8bXE/xLsRydlAMLfvCjP8Zkqy+bkUvvtLGUYiDKf2g37VYL+OziUbPKxMuubW9Wi/yallt/Kb2IHh6zRgaBtNnMDIVpZEX6uJBLMhI/VYzpsUSSLDASdyroGHetKm/ZylCjPQyX10YTUJAAk0Rcli8NMe9BnT6Gu+NG7ZUaSmScF5gX90NbHVm0xMnAism9rboJ3IVm6XM4tdncyne2OX5C9mM369SmFClNHOiE6fAB7m42BI3294OROYwTv6y5zXIBWbOluILlKmEhTJiITa9mBTTaEbx04CFDkzKGjLX1B844CF2SfEFdaINmvPGie19g8I4r5Y9WN+NfpzsIG+989t3gHBkbE89dQQQwtziWousxXhlAeroVAi9rT6NZStzqj9YwmLCkts3hNd0wWPhboHORwRJytUg26guugaVKv3IM5i+gDucs8ZF/yOTiYengl4V2rOEW+PrsRy+nQW+dJWN8xCmRHvf237zW1KPUf4WnzDK5iA00ccBAZfkJGCAzTr0TQLso3thj2eOcMVwYVTTQ3R442ZTSBjlf9d2mE+57hWXKO4cQwnewS2DtUcKLgPn8af6EuBeakRq6Lv1AskDB80P0ygEPI5EP1M8/LTnkt2dJryqKq6kUG2Fc9vVRiCwRy2bp3CYKykp9/rElXTJNwim0EdUgcNcEAQj63dsY30jP7ZUZg65LfdSU4lunDxjQDp811SVDQyk5FIEuqViJIJ3O9zKjBm2Upr4izJoGTk9BcyqwApw7X9WXNg0ZMrVfMEaMUfFz8+PyUN2f0RYyiL2EPqgTp1p+4mtErJmtGWkfkXNwNJzf7znzuqIISF4UaUfskV+9CGIFnTmE4aVJ42PzJlxYD+rkKzwhZhAbngFhY2cP81iouQa0GpkxMlgx3nUNOzF/iQdlKKJdbZ46Py8SBNSz6/GqJiuVH8vfVJhrht4u9idrxm
 BwuJwGeA
 ncT94M253xs0zNrkT0U6Et0c6alVL+3/bCUybuOL72P2j7AwLOcjUspXHeVeoDEGVbcEo6E0aUKMHLxnFTknc5ICTwr8mkqoemEis1u44OOgHm00c0wi/HPnlKMl2sEMjq1V4cS4zJQvYbKqYcfGAblYdlVhsTF8IFlagvls4pLqieE5wOLOwdNkoWeSXnSfAE2bs4Yt9AS/WfJs2Ro754apcJJzPyhStOPCn2wpOdhGPFE74im1jSZI3WAOuv3vSJtwlyO2FULfvhu3Nj1YR7NkOky3FBGwm1T5b4hdSSNJy7G7jaYb2NSTjnMykrCQspXDDGPjkyMzlS1RYd2NvvRj0KGK/VWBffDCb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Oct 25, 2026 at 10:04:42PM -0400, Zi Yan wrote:
> After disassociation, rdma_umap_fault() returns the shared zero page from
> ->fault for VMAs without VM_WRITE and VM_MAYWRITE. Such VMAs come from
> rdma_user_mmap_io() in drivers that clear VM_MAYWRITE and they are shared
> VM_PFNMAP. A page returned from ->fault is mapped as a normal page and goes
> through rmap code. Two issues:
> 
> 1. shared zero page causes VM_WARN_ONs in rmap code,
> 
> 2. normal pages in shared VM_PFNMAP VMAs cause accounting leak on arch
>    without pte_special(), namely the page refcount, mapcount, and vm stats
>    are never dropped.
> 
> Map ufile->disassociate_page for VMAs without VM_WRITE and VM_MAYWRITE,
> with vmf_insert_pfn(). The page lives until ib_uverbs_release_file(), which
> cannot run while a VMA holds a reference to the file.
> 
> Writable VMAs keep returning disassociate_page in vmf->page, thus its
> accounting leak on arch without pte_special() needs a separate fix.
> 
> Userspace can see two differences after the patch. A mapping without
> VM_WRITE and VM_MAYWRITE now reads what was written through writable
> mappings of the same uverbs file instead of zeroes; after disassociation
> both are dummy data. The first fault now allocates the page and fails with
> VM_FAULT_SIGBUS if the allocation fails, as a write fault already does.
> 
> Fixes: 67f269b37f9b ("RDMA/ucontext: Fix regression with disassociate")
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
> The issue was discovered during PG_folio development when making sure only
> rmappable folios can enter rmap code path.
> 
> Alternative: map the zero page with vmf_insert_pfn_prot()
> ===
> 
> Read-only mappings could keep reading zeroes if rdma_umap_fault()
> installed the zero page itself as a special PTE:
> 
> return vmf_insert_pfn_prot(vmf->vma, vmf->address, zero_pfn(vmf->address));
> 
> It does not work today. Commit 7b466529307be ("mm: disallow raw PFN
> mappings of huge/shared zeropage") makes vmf_insert_pfn_prot() return
> VM_FAULT_SIGBUS for the zero pfn. vmf_insert_mixed() does not support
> VM_PFNMAP, since vm_mixed_zeropage_allowed() warns on VM_PFNMAP.
> 
> The first version of that patch [1] did not change vmf_insert_pfn_prot().
> Due to no in-kernel user at that time and complication it can cause,
> vmf_insert_pfn_prot() rejects zero pages now.
> 
> Fix to writable VMA path
> ===
> A new vmf_insert_pfn_mkwrite() is needed, since vmf_insert_pfn() has a
> narrow failing scenario. When a process mapping the disassociated page has
> soft-dirty tracking enabled, vm_page_prot becomes read-only;
> vmf_insert_pfn() then uses a read-only PTE instead of a writable one;
> fixup_user_fault() is used to write to the page (e.g., KVM with the uverbs
> mapping as guest memory) and fails, because it does not take the second
> fault to upgrade the read-only PTE to a writable one.
> 
> LLM was used for investigation and code development.

Is that why all of the above was so hard to read?

The zero page was used because things like the clock page really need
to be zero. Reflecting back random things from the disassociate page
is not going to work out.

I don't think rdma supports any architectures without the special bit
so I'm not sure this is a real issue in practice.

I guess using vmf_insert_pfn_prot() consistently is the right answer
since these VMAs are not supposed to be mixed maps.

Jason

