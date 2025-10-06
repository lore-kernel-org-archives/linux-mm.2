Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50055CCA470
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 17:01:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 892478E000C; Mon,  6 Oct 2025 13:01:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 869C88E0002; Mon,  6 Oct 2025 13:01:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77F728E000C; Mon,  6 Oct 2025 13:01:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 676048E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 13:01:52 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9312413B90E
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 17:01:51 +0000 (UTC)
X-FDA: 83968306422.08.AD56DB8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id B8C58C000C
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 17:01:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NgLfsYlT;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759770109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yinai1lbXaVtpc5IhOc41oOTDHKO4GxGtRHWIokQ9xI=;
	b=Af6k/PNkIXNY/+ALsGNsVEsSbVfRp76L0UKjHRvv0PQXSLYyls3BNo1YehYA349kxG7Mvl
	U5oKeDGa6VMuYDKbHRi0D6bLgR/ppEndV35GDSUPdkLvNxZYfGjyoIaTl+FesD6s7e2pqt
	OKqjCCXYRc5tnTmqP1Aq6WZ8R3BpEp4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NgLfsYlT;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759770109; a=rsa-sha256;
	cv=none;
	b=UZ89WG3OOPGQ0NjIgnt67/iBuZRdVW35WDW/WQPX5oPfUyX8J6sM0QWZ7OPDru0BekQ8Ji
	prkdftcDZ5dkoGYXV5RuKIoeeENBsy8/T704UbX4ESiPyCasSPWsrJ15enGfG6lorNmqjd
	w0eDqfXXGZj0M/sNdNigcUZP9zDeMeU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B17A43D67;
	Mon,  6 Oct 2025 17:01:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E62C4CEF5;
	Mon,  6 Oct 2025 17:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759770108;
	bh=MG1dcQMphQ748JndS811tTZbOvZl5viKUiBdA36kux8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=NgLfsYlTgtpvDbSOm2NiGUojPOjwRGe/OH3C0JNNWeU0NeJOo51dJ2Ci9kDtEdQQe
	 3k5DscndvUU0phiQ/ZHNvwhZrgX6lqwI5J/xlNMT8aZdV5u3WDO3VM8ATPykvRSGGT
	 r5b1d+SHy8/FqS7MKcd7EdWJCNFHUCHjE9sfR1Z8e+WnV6oVs1zsX8KGWKj3S8B7Ik
	 dfqxPViKr/BDk3+rzxCGaCa3H0MaJSLU2n1ptlHIv/2Y1ql7EfqnzAbEI1HB2hxOHp
	 1IF9IgN+pr/DVwtODnsjwyUKJ4s19AHLk26ebEq26WDj2aZOB2f8yyO+hVGm27x+7w
	 a51lxbN5OsjFQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org,  jasonmiu@google.com,  graf@amazon.com,
  changyuanl@google.com,  rppt@kernel.org,  dmatlack@google.com,
  rientjes@google.com,  corbet@lwn.net,  rdunlap@infradead.org,
  ilpo.jarvinen@linux.intel.com,  kanie@linux.alibaba.com,
  ojeda@kernel.org,  aliceryhl@google.com,  masahiroy@kernel.org,
  akpm@linux-foundation.org,  tj@kernel.org,  yoann.congal@smile.fr,
  mmaurer@google.com,  roman.gushchin@linux.dev,  chenridong@huawei.com,
  axboe@kernel.dk,  mark.rutland@arm.com,  jannh@google.com,
  vincent.guittot@linaro.org,  hannes@cmpxchg.org,
  dan.j.williams@intel.com,  david@redhat.com,  joel.granados@kernel.org,
  rostedt@goodmis.org,  anna.schumaker@oracle.com,  song@kernel.org,
  zhangguopeng@kylinos.cn,  linux@weissschuh.net,
  linux-kernel@vger.kernel.org,  linux-doc@vger.kernel.org,
  linux-mm@kvack.org,  gregkh@linuxfoundation.org,  tglx@linutronix.de,
  mingo@redhat.com,  bp@alien8.de,  dave.hansen@linux.intel.com,
  x86@kernel.org,  hpa@zytor.com,  rafael@kernel.org,  dakr@kernel.org,
  bartosz.golaszewski@linaro.org,  cw00.choi@samsung.com,
  myungjoo.ham@samsung.com,  yesanishhere@gmail.com,
  Jonathan.Cameron@huawei.com,  quic_zijuhu@quicinc.com,
  aleksander.lobakin@intel.com,  ira.weiny@intel.com,
  andriy.shevchenko@linux.intel.com,  leon@kernel.org,  lukas@wunner.de,
  bhelgaas@google.com,  wagi@kernel.org,  djeffery@redhat.com,
  stuart.w.hayes@gmail.com,  lennart@poettering.net,  brauner@kernel.org,
  linux-api@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  saeedm@nvidia.com,  ajayachandra@nvidia.com,  jgg@nvidia.com,
  parav@nvidia.com,  leonro@nvidia.com,  witu@nvidia.com,
  hughd@google.com,  skhawaja@google.com,  chrisl@kernel.org,
  steven.sistare@oracle.com
Subject: Re: [PATCH v4 03/30] kho: drop notifiers
In-Reply-To: <20250929010321.3462457-4-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Mon, 29 Sep 2025 01:02:54 +0000")
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
	<20250929010321.3462457-4-pasha.tatashin@soleen.com>
Date: Mon, 06 Oct 2025 19:01:37 +0200
Message-ID: <mafs0tt0cnevi.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: kk5dc179r4pghhrwsm8cmd8tc1ughxq3
X-Rspamd-Queue-Id: B8C58C000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1759770109-853868
X-HE-Meta: U2FsdGVkX19pLcq4zY6csfjXOlp7/mEhbmxl4S7sOvJiKYUhTB+y3ZhPtEbqXwAmR3qypXNZSsrIsxAWRMhjznY5pfv/PF0ImKgB2//0SiCwTkegsl6w9fx1jhYm6fLIS/2XJA//NqehswmzN1sJR7v7kAA4kPkAA/ZkVbzdnELy5edvBqgQkLvNBQBB9hx/qvnXl7zLwHl24aLU9VmCLMWkhqMAwMehW0wiqMDiUILD1JPGSlTP5JeHeVCaVNEGl4y+wnsu9aktmALE5BDd4LzF5EgNbFELyAOjLcDME+N55b3TElVR+fH1tMtVhiZ4X6so8AjeNwhUqSmgEYHZSsaEDbu7fYaNVGLTt9eiaYAG/SP7+P/SvYYAGMRMZp6NOPekc9cpFuoXfIXb4KmFY6WdpsoVmyO2e9ZTQcwQrrMzFo/fsslw0BYoo46pMmRCMa1fY6cGg6rkhd/lDLNwioOwtHEYl4te8LqUGjyZGoyBRNWzDFcGG2DnzRTM4vADFKkMBO0+P+ylIZG3ctOO5hxJEEMSpkQ6DIgnlu2zzkDOTjhqSmK/pk7o9QNySYrvcn2i2h60Urd3gLgQySdgbfMHO68LBzeF6Ful51zDOvhd6HEq0vAL4cmLHsLPbYoojWLHxKVvph/k4wdqCvLjjy2EOjlven/ilRttRpsEAEsKYPEIi2nVL/RRZQC5UgbdVzfs25OciYOngyvfJ2F5CsWicrMi94Cs1p/TwUMtoAd20zQ1N1TPfXSnD6ZiRSeWfmeNqlbU/Nz/xPTmqXyxlCmEWAdBn7+gLO8L+S1l2lVqv3KufB6fhBM18Y0ixkPYwNqEKyhBt+QHoOncd3UNpT6oHuOHomGeYY24khLaoc7oAuKvZ3ykoMc+3DElBGa5ODhXBub+GWMOEn/qLyZBJHeV5OHBiJTwVT2Q1PfFrhbvsnbQwJaUpgwi2v7v4WBn+4QwEWuZlDcuSCLdOxe
 Kae9jhdV
 2xU2jHQgJPCQ+kOFGkZUXxBOuxzofh5OmmfJ5mCDIwMXiTE6WZSuDnKdQIEI2d5fj47atUu225hZPFXMz0pYbjrL7NgZkFOTQkjjErGnjosCX5jLHCGreZgGZUrTTecmuL5aET4BSycdcyhyH3td9eqC4jA/NoPcaI7g6Uu1tyImzrqKiZDe6s75GXEljK5Cf9AHhtL69G9MvGMZ0TCD9VttGyuls2GYaGH1QV1UHYntWH35FhdJzPy2OMn7de93Y7b9VKkS+llqyXG1htjLWM+W0H31mbX0BbuI8rn5WwpSS/0WVSAzx6bcwVP6M3glpmbuw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 29 2025, Pasha Tatashin wrote:

> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> The KHO framework uses a notifier chain as the mechanism for clients to
> participate in the finalization process. While this works for a single,
> central state machine, it is too restrictive for kernel-internal
> components like pstore/reserve_mem or IMA. These components need a
> simpler, direct way to register their state for preservation (e.g.,
> during their initcall) without being part of a complex,
> shutdown-time notifier sequence. The notifier model forces all
> participants into a single finalization flow and makes direct
> preservation from an arbitrary context difficult.
> This patch refactors the client participation model by removing the
> notifier chain and introducing a direct API for managing FDT subtrees.
>
> The core kho_finalize() and kho_abort() state machine remains, but
> clients now register their data with KHO beforehand.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
[...]
> diff --git a/mm/memblock.c b/mm/memblock.c
> index e23e16618e9b..c4b2d4e4c715 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -2444,53 +2444,18 @@ int reserve_mem_release_by_name(const char *name)
>  #define MEMBLOCK_KHO_FDT "memblock"
>  #define MEMBLOCK_KHO_NODE_COMPATIBLE "memblock-v1"
>  #define RESERVE_MEM_KHO_NODE_COMPATIBLE "reserve-mem-v1"
> -static struct page *kho_fdt;
> -
> -static int reserve_mem_kho_finalize(struct kho_serialization *ser)
> -{
> -	int err = 0, i;
> -
> -	for (i = 0; i < reserved_mem_count; i++) {
> -		struct reserve_mem_table *map = &reserved_mem_table[i];
> -		struct page *page = phys_to_page(map->start);
> -		unsigned int nr_pages = map->size >> PAGE_SHIFT;
> -
> -		err |= kho_preserve_pages(page, nr_pages);
> -	}
> -
> -	err |= kho_preserve_folio(page_folio(kho_fdt));
> -	err |= kho_add_subtree(ser, MEMBLOCK_KHO_FDT, page_to_virt(kho_fdt));
> -
> -	return notifier_from_errno(err);
> -}
> -
> -static int reserve_mem_kho_notifier(struct notifier_block *self,
> -				    unsigned long cmd, void *v)
> -{
> -	switch (cmd) {
> -	case KEXEC_KHO_FINALIZE:
> -		return reserve_mem_kho_finalize((struct kho_serialization *)v);
> -	case KEXEC_KHO_ABORT:
> -		return NOTIFY_DONE;
> -	default:
> -		return NOTIFY_BAD;
> -	}
> -}
> -
> -static struct notifier_block reserve_mem_kho_nb = {
> -	.notifier_call = reserve_mem_kho_notifier,
> -};
>  
>  static int __init prepare_kho_fdt(void)
>  {
>  	int err = 0, i;
> +	struct page *fdt_page;
>  	void *fdt;
>  
> -	kho_fdt = alloc_page(GFP_KERNEL);
> -	if (!kho_fdt)
> +	fdt_page = alloc_page(GFP_KERNEL);
> +	if (!fdt_page)
>  		return -ENOMEM;
>  
> -	fdt = page_to_virt(kho_fdt);
> +	fdt = page_to_virt(fdt_page);
>  
>  	err |= fdt_create(fdt, PAGE_SIZE);
>  	err |= fdt_finish_reservemap(fdt);
> @@ -2499,7 +2464,10 @@ static int __init prepare_kho_fdt(void)
>  	err |= fdt_property_string(fdt, "compatible", MEMBLOCK_KHO_NODE_COMPATIBLE);
>  	for (i = 0; i < reserved_mem_count; i++) {
>  		struct reserve_mem_table *map = &reserved_mem_table[i];
> +		struct page *page = phys_to_page(map->start);
> +		unsigned int nr_pages = map->size >> PAGE_SHIFT;
>  
> +		err |= kho_preserve_pages(page, nr_pages);
>  		err |= fdt_begin_node(fdt, map->name);
>  		err |= fdt_property_string(fdt, "compatible", RESERVE_MEM_KHO_NODE_COMPATIBLE);
>  		err |= fdt_property(fdt, "start", &map->start, sizeof(map->start));
> @@ -2507,13 +2475,14 @@ static int __init prepare_kho_fdt(void)
>  		err |= fdt_end_node(fdt);
>  	}
>  	err |= fdt_end_node(fdt);
> -
>  	err |= fdt_finish(fdt);
>  
> +	err |= kho_preserve_folio(page_folio(fdt_page));
> +	err |= kho_add_subtree(MEMBLOCK_KHO_FDT, fdt);
> +
>  	if (err) {
>  		pr_err("failed to prepare memblock FDT for KHO: %d\n", err);
> -		put_page(kho_fdt);
> -		kho_fdt = NULL;
> +		put_page(fdt_page);

This adds subtree to KHO even if the FDT might be invalid. And then
leaves a dangling reference in KHO to the FDT in case of an error. I
think you should either do this check after
kho_preserve_folio(page_folio(fdt_page)) and do a clean error check for
kho_add_subtree(), or call kho_remove_subtree() in the error block.

I prefer the former since if kho_add_subtree() is the one that fails,
there is little sense in removing a subtree that was never added.

>  	}
>  
>  	return err;
> @@ -2529,13 +2498,6 @@ static int __init reserve_mem_init(void)
>  	err = prepare_kho_fdt();
>  	if (err)
>  		return err;
> -
> -	err = register_kho_notifier(&reserve_mem_kho_nb);
> -	if (err) {
> -		put_page(kho_fdt);
> -		kho_fdt = NULL;
> -	}
> -
>  	return err;
>  }
>  late_initcall(reserve_mem_init);

-- 
Regards,
Pratyush Yadav

