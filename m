Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F6CDC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 21:32:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE7276B00A0; Fri,  8 Aug 2025 17:32:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B976B6B00A1; Fri,  8 Aug 2025 17:32:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A85E56B00A2; Fri,  8 Aug 2025 17:32:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B3B26B00A0
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 17:32:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 02F6FB9C4B
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 21:32:03 +0000 (UTC)
X-FDA: 83754888168.04.9F5DC80
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id A9BC7180004
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 21:32:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=WvkJF2MV;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="1/9xl/VC";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VlFEcN1+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=V21WGjzr;
	spf=pass (imf16.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754688722; a=rsa-sha256;
	cv=none;
	b=FyKTnsotKw9teez8BaGYg2pLA8YQSPVSbIYMj8nSCMNTjR01G5xnfMu0cp2n1fr24OR7oX
	R96yolL2oOUJ1d2wsbiFdarVH44S1GCMb18lt8hEKtzVgCtPRhXTIzpHSi3nW2/aVBui2w
	+TYVqzZcH1QV4ZmUI0SpVXPDMFUKYyM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=WvkJF2MV;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="1/9xl/VC";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VlFEcN1+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=V21WGjzr;
	spf=pass (imf16.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754688722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ozpPeuGz/5jR8RvrsN+ym3S5Zd0rR0WHaXf/FgJQh6A=;
	b=g2Cvy5cp2fFf5j5tHTLgnvV/ld1VAXpba2/nJw9chVuqWP1/qgLeuuHT1XpgTUtxO6Ok5u
	lrcRPCVHm036K9HYYb567US3wi1nqh/7MQef5Wk3w6uJJuPUAlA3sKtUHPDtmBX/Zjk0s7
	H6zaQXhDwmUfTKwyovUyzmrf5nCSMXM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EEDDE5BE9D;
	Fri,  8 Aug 2025 21:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1754688720; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ozpPeuGz/5jR8RvrsN+ym3S5Zd0rR0WHaXf/FgJQh6A=;
	b=WvkJF2MV28XaR7NjO9JlgURbxOnMk04dnMp3rU4DB+pvF138qC1HM2dOGur2+tvInHtwhn
	jfNI+6dwVILpfddZ5FmtdADWInRef0Aa4aDmpkDE8OeG6hXziJoFvpb5otsMlx91lJkn9p
	2m/F5CAyCG+GyMGd/F8hyoXHpYBBgLk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1754688720;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ozpPeuGz/5jR8RvrsN+ym3S5Zd0rR0WHaXf/FgJQh6A=;
	b=1/9xl/VCICqUNFJtiSIuAX5jSdnseyst7G72Zy0fJ2FKOjxsvcQ5ttp93n869MszjrK2oR
	zLat/mG/+eJP8NBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1754688719; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ozpPeuGz/5jR8RvrsN+ym3S5Zd0rR0WHaXf/FgJQh6A=;
	b=VlFEcN1+KLihWbtuyRDQBtfXWzk0WoralxzzPCXwgLkywvuLnKCdmwApiPQcdkM4PbR3GB
	DzsEFBuBRWQ/HbMHepl0O+uKty1mFsgMInZlfJW4cQ21pnxwft9x75plbp0d6nKcdj42kS
	7U5Fal2G9obLQfUOO5e1J4/vZjHztUY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1754688719;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ozpPeuGz/5jR8RvrsN+ym3S5Zd0rR0WHaXf/FgJQh6A=;
	b=V21WGjzrpRzk35KZ/w/wPCKv/uza/4Jmfd/mwutbrrQnlrPEXgiG0XLJYDwrNWrx1hWeLe
	AJjdavret2ktQQAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2A2261392A;
	Fri,  8 Aug 2025 21:31:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZjKwBs9slmgRHgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 08 Aug 2025 21:31:59 +0000
Date: Fri, 8 Aug 2025 22:32:01 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: kernel test robot <lkp@intel.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Linux Memory Management List <linux-mm@kvack.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	linux-riscv@lists.infradead.org, llvm@lists.linux.dev
Subject: Re: ld.lld: error: Function Import: link error: linking module flags
 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at
 1229286), and 'i32 1' from vmlinux.a(vma_exec.o at 1246866)
Message-ID: <j6pxm4n2n3tnan22x73ff3ku6dwr6e65mi4tafjmlyoicbpygi@vbjbioh7p5fx>
References: <202508082339.sjRnzZrX-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202508082339.sjRnzZrX-lkp@intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A9BC7180004
X-Stat-Signature: xzomh81eg99t83r7wc1q5y7yxm38ts91
X-HE-Tag: 1754688721-560912
X-HE-Meta: U2FsdGVkX1+1qxiBsqu+AVOEtV7WNqcJo7O/CWmy3DxiAmDW2tcVoB4VzXP0mfiVzdGV5Gv3qxiyzMwzGVMVvvd47KeXXUtiweUJePOaATL4tRMgRjAgv3lLWXQS/C+BhQGrQPl2gDil/ZaobclI+oR1ZBabbhva9fsXk5D8jdO7r18RttCibwhbCtwtEPDONrgcRKTt+DgHA3EZDfCaRpMoyEswjI/2hXoZDIfdO3PIVPG9Yrb9OmdCWC9V4mD95p0Kyx0fiD4P4Ga8Gk58JYKdbGxvNnn70Ib7FfE8u1+6qQiUYPE7naPIYtqba+gJP78fuFPSJAbItg3BkSyfWGsDXYcYBHzYmpz4cdidY7NXxIri2QsmymSzgZP7Lu00EqtzKQUCpCXUPNFH+fCpDIX+PjhTs9mw8it9voJR/ysUvwCFlt4hL6tC69rYDy5wkBYHDYPp8hY/KrGo7wLnJzMl48dd5uFy33D2kSoZ3EDiMqdNHFmTAj8HII8SQgCmPGVI4723BMAYz1ETnnQcXutLPZb421TXNwEC0IY5t1d8b141ZvtTMxuCD5lEa+2hXiKk7fmTgiN6L04UjXLP+T7tV/yeBw1l8xphJtkj7usdGvpUhwA3h59/lod+GEUbxmfnsYXdV+gguQTzu7RN5G/oYAU5MuUtKH7QDw2GMINzyHvRakfEzS2QYpZLfYIFV+n291k9KOwGITtx4JLcgugo9VooO61hKzXN1BNOlQLt9lcBUo2cf3Z8edUWmxYJJEfhoxXyiqsToLrv6BUTLxOStgkktTuKmzbfBZfkvABVIfuld/C0qKy8ihRg4KEni0jZ3XxKYi3z+F+MehlpA+6QFLHP3JLm+7ZC9mIQSfUx3oYKcO8uOyvrQlQbkKgpBBxdy8czgXJEMa4hJFtXj4GdHRfnN/b3Ey8dO+Df+/ooCcm5U+DYEnljrZMhjAcEAksGUgbVq+MnTlT5F+h
 Vv6mKLpT
 c8Qh3Smxb6XFAF0SyGaG6iFHZM9PQ0tODku7guM5YvHhi8HvQujlxY1ADpi7XFXaZqI8EfH0+Qn+w9wi+RoYso7lrxKm/glV0DikWno4fNhTVr7Q3VvsXZhhoKdx3GswJQ/C8/DZNuMGjfuvHQF+RLkQGhGDa4SkTcKLbuFiwXH1R5NJo1mS8tVzImOVXd/fpUc6sE1bPprutnL+qdpP5Bhn6467wbTM1Pn6emwM4HMF3dzUopGsGUO4zliXlBT7ihcSoDOT5XL9Y4aPk42r15jTJI4LzVThatXbLwSdN0+hMrPBipZ23Utvb4nnY8/+aM/SsgRPJujVOCt4dCFn4pCV1x1dlBtffKxnoj+E13l/P/uHsrCe/966Qq6Sc7sVaPCcHQRvtsfBrDDwYYIEESp/nLc3GDi06ZuWmyr2lFyywtLBLYkQlIjkHNb461STU4vYQPohG30LpuIuVzY+5QrRH7IW9EZTr5Aqf9dQlywoD6VdPesgXFOIf/ZxLkAQtmmVCydenfeOkHN7MUwMajMoV78inrItSZNGNnuhzT9D/XHG24YFyDdxtcF/1pdzUOrLB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This doesn't look particularly mm related, CC'd riscv and kernel llvm lists.

On Sat, Aug 09, 2025 at 12:09:05AM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   37816488247ddddbc3de113c78c83572274b1e2e
> commit: dd7a6246f4fd6e8a6dcb08f1f51c899f3e0d3b83 mm: abstract initial stack setup to mm subsystem
> date:   3 months ago
> config: riscv-randconfig-r071-20250729 (https://download.01.org/0day-ci/archive/20250808/202508082339.sjRnzZrX-lkp@intel.com/config)
> compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 1b4db78d2eaa070b3f364a2d2b2b826a5439b892)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250808/202508082339.sjRnzZrX-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202508082339.sjRnzZrX-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(core.o at 1243626)
>    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(ring_buffer.o at 1239546)
>    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(vmalloc.o at 1246746)
>    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(memory.o at 1246026)
>    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(main.o at 1225686)
>    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(output.o at 1404306)
>    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(mmap.o at 1246206)
>    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(vma.o at 1246806)
>    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(drm_gem.o at 1315866)
>    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(drm_gem_shmem_helper.o at 1317846)
>    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(virtgpu_vram.o at 1327806)
>    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 1' from vmlinux.a(alternative.o at 1226286), and 'i32 3' from vmlinux.a(init.o at 1229286)
>    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(direct-io.o at 1251666)
>    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(debug_vm_pgtable.o at 1247886)
>    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(drm_gem_dma_helper.o at 1317726)
>    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(blk-lib.o at 1282566)
> >> ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(vma_exec.o at 1246866)
>    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(context.o at 1229706)
>    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(setup.o at 1226826)
>    ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 1229286), and 'i32 1' from vmlinux.a(physaddr.o at 1229886)
>    ld.lld: error: too many errors emitted, stopping now (use --error-limit=0 to see all errors)
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

-- 
Pedro

