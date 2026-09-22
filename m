Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F20EAC982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 06:28:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D21506B00AB; Tue, 22 Sep 2026 02:28:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF88C6B00B0; Tue, 22 Sep 2026 02:28:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0EB66B00B1; Tue, 22 Sep 2026 02:28:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B2BA6B00AB
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:28:15 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 96B1EA4AD6
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:28:14 +0000 (UTC)
X-FDA: 85240418508.22.3383D97
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf03.hostedemail.com (Postfix) with ESMTP id DF31520003
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:28:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="TVb/Xxdn";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf03.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790058492;
	b=qG4cslthWpWGaEQyapFFh9xz6Lf4eTx72Nt8ZdVvG18zIVwWEUTuy8RawC11MO50risofP
	hsRNieVEDLAhSKq7iuMUmjKKK/V0aGT77Qd9d5PNW32YS2Rg76IlKXxCWy+Q2aQq4CZn4U
	146An1u7M0Y5SAbTIRmy2svnLoOLWmM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="TVb/Xxdn";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf03.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790058492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FGbhkQwIGfdAyVtjg1Ql4s8k82iByJqzyE4qhg2yGrY=;
	b=NFZRaMbCoYgbfsoFftnD98d5SMmc0gx7d0hGumOoPfUKwxRm4vBLUKypDNxiyu6CVFtR2+
	r0ve/TcsMGkJBiI+AvckxBiXc+fScP8wAlWBLgS4MJGxF6lhWR4Dfm23S8NmZLI/XutZp4
	TGwkHKHZ1Id51Gw/e320Lu+4+eIAAOw=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=FGbhkQwIGfdAyVtjg1Ql4s8k82iByJqzyE4qhg2yGrY=;
	b=TVb/XxdniyjxDFy7pVMTRQxolIRi+rQVHqCEnlKh1dbNqIt3c2xKfhY78rYOnafftzF8lAstD
	xy2sKyyG+aKfvZphbGF6i0pqXqKi4+Lx7oBYcGyOLnBdBgO4nzlpnNBmoKdAIsiGoqcxSUoEfMe
	/ubLcOzVXiphJvNeeFaqF5c=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4hpqcs4qVZzLlXZ;
	Tue, 22 Sep 2026 14:17:01 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id EDB3440573;
	Tue, 22 Sep 2026 14:28:03 +0800 (CST)
Received: from [10.173.124.160] (10.173.124.160) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 22 Sep 2026 14:28:00 +0800
Subject: Re: [PATCH v5 0/9] mm/memory-failure: keep hardware-poisoned pages
 out of the next kexec
To: Breno Leitao <leitao@debian.org>
CC: <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <rmikey@meta.com>, <riel@surriel.com>,
	<harry@kernel.org>, <linux-cxl@vger.kernel.org>,
	<driver-core@lists.linux.dev>, <kernel-team@meta.com>, Ard Biesheuvel
	<ardb@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, Naoya
 Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton
	<akpm@linux-foundation.org>, <kas@kernel.org>, <kexec@lists.infradead.org>,
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner
	<hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Oscar Salvador
	<osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael
 J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
	<hannes@cmpxchg.or>, <shakeel.butt@linux.dev>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <d6e35901-f74d-bf81-75d3-bac4b26d9d72@huawei.com>
Date: Tue, 22 Sep 2026 14:27:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 whupemk100004.china.huawei.com (7.152.185.74)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DF31520003
X-Stat-Signature: brofo4ka87fur5pt15hp4k3mf16kiqjc
X-HE-Tag: 1790058490-373090
X-HE-Meta: U2FsdGVkX1/8/IUTNuczsncNpy4/zSxQDer0wFi1maqIciS7iRLfu7EjJrYxRYmS8Z+iTN81RsJUwbAQ35IQRM1l1er0hAY+UF8dHEj7Pc4CSNtjJsaPN3tbqnTQ2B2VgY5AbIvSH7YOmkUj4yPlSuVmO1nxsHBiyf17oHYQ9WAq53D6nbPwOittBhqfx+wVc2/NRieAWQBqvADoFnzxb/Qo+38jFo12+EAeoXHxhS/JpW7ieuOq8SYvvDwdTenxRejD6mKLk01JDcMNeQ7UgE3xaLmEweR909BxaEHOi87uPT6oDkEe4TRpA+afXqB3tnv09X8I3pHJ3xRgZvXk4H5qWrTxAeUcgAKBwcr29mDwIu56huspyzaOzH+59Dyx3RnFufC2Pz2oAJQGgU2RVeItm4ddRVXHnrxAdQZob0YH2ynioZrrK8lFzccjwYKYzB02OySGLKIWn/hNWri+tOfXY4oEcCn9Sj31r0fljQNvqM9Y1mx0M0mERJq+tk3vWNF+TfRYuUq0pUjYN4zFd7dc2BofkY91vqEogki75W2Ep+niqJZU/eoRKe5dnoFbDEKBRQud7hL8Y6SKcrr925giHBx7JjJEpGWfIYdHiih79EppJ58Fnoal/teO+P0dEy/cnKd5+FrZCB1tYt38l7Fh1+aU5VZwcFJ++JmUujwOiZEcybny3h/UCJH7A95crGWceXlC0MbjxUyXAp5dW/TtPRK6hZ5EUmim+a5tb0O+1Z4rorMLhUu6+YKuK/x3AZybaji6ZzQG5bug20wWNjp5Rd3n4fsYipjbvvsHFJSHVPtz9qj0mfT5Cu5EIMh9QETUIYnoXBA3jwYC3NY2cfG/JJs4BoEDT16VpM/9Q/Kl9ztRtlYRdz16A8yEijHHblwqOX6EUze5z5G4hVYwKhoRxaYOSs8AW0Mk3PBnczUGUSzBGteylGCux2jbssZJGNJLYMk1ZKaMJD7+AIP
 c2aupZah
 Xo4cXquFD0BJvooCvS+8shDHFZY/U+1+nj4cKjZxhAD4R30yJ0+nhj7JtXukiKoiCWi37s0l17Czonpdiq494r+jt55yNJ8ikMVBym9FY/mg4JFJbreU4i59PM1jBFSMHKZg9qeZ9GjyEYLDtxn+XMbyvJVvZTMShTaTqKUEgKHUoIAUD/bYgXCH8KsUnHa6uNSG3MkQD31eVFXoF5D16MeOrgUC1F54KisdQwTetYX/qks3swAaFy7Pg26nX1Tsm5aIWMxczi1cNcH8AzfClJLLoUGwDaV/xWhHOkdr3xZOCPSE0ZGW1q49lS3Iq9nV3BLs42Dmi4+pBR3ENpiIWafCNTKKxyNtILkopfkX4PjiCmg7wrjlkG2lTaTtbOX1AwQMbiCsnGCwWwywyUGvrJNBnpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/9/15 20:53, Breno Leitao wrote:
> Problem:
> ========
> 
> When a page is hard-offlined due to an uncorrectable memory error (multi
> bit ECC), memory_failure() sets PG_hwpoison, unmaps it, removes it from
> the buddy allocator. This information is not carried to the next kernel
> that is kexeced. The new kernel kexecs and trip over that bad memory
> bank _again_.
> 
> Why now:
> ========
> 
> Several industry trends make this increasingly important:
> 
>     1) DRAM is getting more expensive
>     2) soldered / on-package memory (LPDDR, HBM) is becoming more common, so a
>        failing part can no longer simply be swapped;
>     3) memory is kept in service far longer (at Meta, DRAM lifetime is being
>        drastically extended).
>     4) It is more and more common to kexec instead of full reboot
>     5) Increase of memory per system with CXL
> 
> What was done already:
> ======================
> 
> In order make linux deal better with the problem above, I've done
> already fixed a bunch of stuff in this area, such as:
> 
> 1) Panic on unrecoverable errors, instead of "printk and carry over":
> https://lore.kernel.org/all/20260630-ecc_panic-v10-0-c6ed5b62eea2@debian.org/
> 
> 2) Respect poisoned memory at kexec time
> https://lore.kernel.org/all/20260812-kexec_posioned-v6-0-e477887086f0@debian.org/
> 
> Now, the natural follow up is to carry the poisoned memory information
> to the next kexec kernel, avoiding tripping over a known "bad page".
> 
> Proposed Solution:
> ==================
> 
> Carry the poisoned frames to the next kernel in a new EFI configuration
> table, LINUX_EFI_POISONED_MEMORY.
> 
> The table is a bitmap with one bit per 2MB of physical memory, modeled
> on LINUX_EFI_UNACCEPTED_MEMORY. The stub sizes it from the EFI memory
> map and installs it empty while boot services are up -- a running kernel
> cannot install a configuration table, it can only flip bits -- and a
> table inherited from an earlier boot is reused as-is. That is one
> fixed-size allocation, 64KB per TiB of the span the memory map describes,
> with no list to grow at runtime and no chain to trust at parse time.
> 
> The mechanism is architecture independent, so x86 and arm64 use the same
> code.
> 
> Each hard offline sets the bit for its unit. Soft-offlined pages are not
> recorded: they are still functional, and were offlined predictively.
> 
> The next kernel takes the table into use from efi_config_parse_tables(),
> which vets the inherited header and hands the table's pages to memblock.
> It is EFI ACPI reclaim memory, which x86 leaves out of memblock and so
> out of the direct map; the unaccepted memory table is handled the same
> way for the same reason.
> 
> The frames themselves are poisoned in __free_pages_core(), as each block
> reaches the buddy allocator. That is the one point every producer passes
> through -- memblock_free_pages() early, deferred_free_pages() once the
> deferred struct pages are up, and generic_online_page() at any later
> hotplug -- and it is already where the unaccepted memory table is
> consulted. The recorded frames are held back and the rest of the block is
> freed, so they never enter the allocator instead of being taken back out
> of it. They end up in the state a frame poisoned by this kernel would be
> in, so everything that already understands PG_hwpoison covers them --
> including the kexec segment placement check from the series linked above,
> which keeps the segments a kexec places off these frames.
> 
> Granularity is the trade-off: one bad 4KB frame costs a whole 2MB unit in
> every later kernel of the chain. In exchange, a row or column fault --
> roughly a quarter of the DRAM faults reported in [1], and potentially
> thousands of 4KB pages scattered over gigabytes -- collapses into a bit
> or two.
> 
> A bit is never cleared, which is a known limitation: it stands for a
> whole unit, so an unpoison of one frame cannot tell whether the unit as a
> whole is good again.

Thanks for your patches. I have a question about unpoison: If a bit is never
cleared, after we do some memory-failure+unpoison tests, kexec will lose the
tested memory without reboot?

Thanks.
.


