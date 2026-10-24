Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 898CF60A262A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 00:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BcAEolwN
Received: by kanga.kvack.org (Postfix)
	id 78C5E6B0BF2; Fri, 23 Oct 2026 20:52:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E7936B0BF4; Fri, 23 Oct 2026 20:52:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FE416B0BF6; Fri, 23 Oct 2026 20:52:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 312446B0BF2
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 20:52:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0D9FD14024F
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 00:52:12 +0000 (UTC)
X-FDA: 85355693304.10.168BEF3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 48EC6A0003
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 00:52:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BcAEolwN;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792803130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ag7wZH+Anox9ZA0BlMjFkXjW+sPcmu+vVsFwCNQlWXc=;
	b=JkLcA0IJCEUv5tvGVRCMknKMO9pgtkQw5r9u+/H2z76B9277nYO4IxD8pyUlsuyX/mkBDb
	tvqQBUwie5EFnAJ+1Pe3fQF6e2nrfumn5EXjlY+qQ7YUZ4hfr9orPKFjAfsjAKey3OC/Q9
	38uZpMfpya3P55PwQrgvBKQHIfch9Ps=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BcAEolwN;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792803130;
	b=UtpEldiTmEQVe9yK2edc4w1Nw15k1pK53k/vu/1+O/z9aurDl9HUkF9OUa9kRcKNaSXwbZ
	v9iZH43gtFLU94jn2ttnJ/B7+ooNuZBFQ381pIVSrSwA82tfK8xs89J6wpmPsZN7nCYE52
	PGBc9FF9WnxRin9NcRgF3mzaO1VL7JE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1E27A43E98;
	Sat, 24 Oct 2026 00:52:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93E21F0119A;
	Sat, 24 Oct 2026 00:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792803129;
	bh=ag7wZH+Anox9ZA0BlMjFkXjW+sPcmu+vVsFwCNQlWXc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=BcAEolwNLLk4z87Erj1L0+VCvb9TWSsTDxto+khX3db/jxXVhuSRVWFU092FYEL6/
	 FAs/Z8A4pxpFqsSypf3GifdwW5hlyd3LJoLzogildKYLEjgxJvpTMRVI0jz5XZGxGs
	 B2Dt6pH5UsbeJVNaZaAsCclJRulgqvYRf2X5zMyY=
Date: Fri, 23 Oct 2026 17:52:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>, Mark Brown
 <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>
Subject: Re: [linux-next:master] BUILD REGRESSION
 bd1ecbb61afefc6a8b876ccbc31e9228b44e9eab
Message-Id: <20261023175208.9cbb6ce7e595229d61c0d99f@linux-foundation.org>
In-Reply-To: <202610240135.uFA85jSq-lkp@intel.com>
References: <202610240135.uFA85jSq-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 48EC6A0003
X-Rspam-User: 
X-Stat-Signature: 9s67ekrukmps1u6bddoix91g8wt1fxns
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792803130-167321
X-HE-Meta: U2FsdGVkX1+HREYTF2JuOaZXZm5Kot8HOSTBlI5fB0Xv9nlE6kp7iZwSuiIFEVLTPXExEJ96oANEVmp+ksqPL1r7uJhjP9/rysZPw3uoH7Ff0ORElXqjQnskI93REfH1CSY2zvyeJbnmAtK74+P2tiCYqxpLvCtIZ5QwbsXhuEywfEhOx7vb7QdzomsbYRtvZd+AQLUdTNsnFEfhS9866AuQ7HkpiVoSYecVIlorg2gu7GwzPwCh1sswI7VvQkJxWnYgzs8CSI0vbVzeT/5Lw79LVgzdY1a316Xlhc3jqaIdQLAhbzVFDIklRsr0XD6aDbo1eISF9Nb1ohmvKWsXRNEnGhT81btYiL8wTCbMN+0zVafERernfqs3CSBdw1TBYWBNvibhJmmk1QnM/ZT+HjChNUU+huPHQEhSM6hdhxrzpgSqH/XBL1USEfjBImPBNSxPg1WD+zenPqoxhFST0TQB5avXaw6BDqtn9j/O1VyNCS1gJCXiAHuQh4BAUN2Xu1zk8gqL/s+1PmZ/5ALW7NKMk5azGhyzS3bU59w5/iWqbrjDdRkfANUQTqjrzJGdi9xZjc3MuAFTZrQECHb72+OF+b1XLZqCOPNq7xYwwzktce+FDI9EIxnMtc13RwHN/VIb5CgNOBdvRs76RICwf1ZvsQkz9FFI/e3YOaURL8AVrVu3Z0yjs5NLRsCJPiOvqAqRNX3vrx6wmurbqgMBypEx5i//nXdh7DP2tqfwNbPbgO+kFS5m5Vj5fn8ndNR9K81DWiAZ2xC2M58xqkRdDy55CTBdIV72T52p3QQNO81VhQC9fulfKSdko5+ZBnZut3SBj/Uq2RXJ4WwD2gkutYn6CuWOIPUP1PGObNih+XladmCMK4As3k0Otji+ogsaAurXjIvqu6ykMnORXEHOvllMFbpfaeBvaOAsFx0eOc67HYVvqN1VxjyEngDUq0+Al4YZYOMEKqj4/XhqV/a
 9Dei2VlB
 SjJP/JqbYDxdKW2eoMpL189yRj3doB7Yc9TTZ8MvVFS+x1u/Lb9+NOb56CQP6UapjfkAPx7hunNtjtbITOzKHmnzWjp7kJuGxxZAcyjnP5E9IczwyAiUDe/xV9iO+lIZH6LeHal/zBoeDBYUf3qIYOeJcqPmGQlganxhMUJkH4CGmOFfw04YMVNPVw0o2LNqCC9B4sorUrpkri+oGkLkNFjHmqzVCl5Ol52BaAOK3zTZwlLNrsESNbbeNjjYaGtjufHu/FdkbvJ81Pps3bCTj8NHf3yX71mDxQF2RXRb37ZU4XJM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 24 Oct 2026 01:50:46 +0800 kernel test robot <lkp@intel.com> wrote:

> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> branch HEAD: bd1ecbb61afefc6a8b876ccbc31e9228b44e9eab  Add linux-next specific files for 20261022
> 
> Error/Warning (recently discovered and may have been fixed):
> 
>     https://lore.kernel.org/oe-kbuild-all/202610232206.jTTTXj8l-lkp@intel.com
> 
>     Warning: drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c:204 function parameter 'readonly' not described in 'amdgpu_ttm_map_buffer'
>     arch/openrisc/include/asm/page.h:50:29: error: request for member 'pgd' in something not a structure or union
>     arch/openrisc/include/asm/page.h:54:25: error: incompatible types when initializing type 'int' using type 'pgd_t'
>     arch/powerpc/kernel/irq.c:116:(.text+0x22b8): undefined reference to `irq_proc_emit_counts'
>     include/asm-generic/pgtable-nop4d.h:9:18: error: unknown type name 'pgd_t'; did you mean 'pid_t'?
>     include/linux/mm.h:3639:22: error: pointer/integer type mismatch in conditional expression [-Wint-conversion]
>     include/linux/pgtable.h:1544:13: error: implicit declaration of function 'pgd_none'; did you mean 'pud_none'? [-Wimplicit-function-declaration]
>     include/linux/pgtable.h:1546:22: error: implicit declaration of function 'pgd_bad'; did you mean 'pud_bad'? [-Wimplicit-function-declaration]
>     include/linux/pgtable.h:167:38: error: implicit declaration of function 'p4d_offset'; did you mean 'pmd_offset'? [-Wimplicit-function-declaration]
>     include/linux/pgtable.h:167:38: error: passing argument 1 of 'pud_offset' makes pointer from integer without a cast [-Wint-conversion]

Thanks.  This is a blooper in Matthew's pagemap-headers tree.  I'll
send over the fix.


