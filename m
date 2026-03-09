Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D35E1F3C26D
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 14:22:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35A8A6B0005; Mon,  9 Mar 2026 10:22:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3387C6B0088; Mon,  9 Mar 2026 10:22:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 210296B0089; Mon,  9 Mar 2026 10:22:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E1BD6B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 10:22:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BF3CF1A0197
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 14:22:37 +0000 (UTC)
X-FDA: 84526740354.30.8FFF84A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 118F540012
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 14:22:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="sAMSqI/u";
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773066156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m2JigjYaeagKQK2ad/WJpiqX5pXXMq3wEeGjXNmO4kY=;
	b=iR5RaK46LHpeJi1WGBGgdU7/ORIBkDN3garESMs/xaMg/KJSjAPDwBg3/PmKRB748G9Cpz
	a8NmCR0k6Fn7uvZskuLPkAqs/reuAADgw5etUGrikxbe5IXd+1Z3MlNFwa0Q1Z9ES1Z5KV
	5hf6sv0StihgULa97E+5RfH7Cd9tBQg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="sAMSqI/u";
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773066156; a=rsa-sha256;
	cv=none;
	b=kiN6SnzE8svW3jLzjBwlTLusJ89Run8ZACGWwA0+o09lHpBUzeT7zLHPFx0eFv/LdJvwCs
	4hGayYbxATSnRXfIutdhwyiAXqNaOeBysCgVI32cRlVOP5OgvqcdQhwauRQwvnwJFtF6SL
	R8++KkBqiTJhccdMJwimIVJnBSCGsrQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C889600AE;
	Mon,  9 Mar 2026 14:22:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3FEC4CEF7;
	Mon,  9 Mar 2026 14:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773066155;
	bh=5KlEfbz0Ee4iB8X6UNcKHVf2pxVqxGqjkSUK1qr0Ki4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sAMSqI/uCvaejl/SUMKvoSWH6sSKm5gIS5a7zZC1gBP+slwLpC/zYJd9K6T2Li00b
	 my7gQs9YzFHCkFHNeSo4WXKTjIdOzztCtEcIdwryUoOJpR7udIQN51pFPDwQhDlqU8
	 AVYjfJ3X63dHXNKTHVNtoG650ZchzyUZ2+f0pcaTVbptv7OVZNYoyZ4/K5pR17HnMT
	 JBF/S4MvLr9HbP1i+lUbJ88WOiEauPQLtObsYtQ6Tg5brdOIp+TGxXI3/IxRb6Nyt9
	 iaOghqdSWK+HOdfh9/ca+HrpHCnyXv1o6C3Ba+0qDpwi/Qs42oZby+pXqkp4bcrRuN
	 pqPISn1qnChiQ==
Message-ID: <fbfea9cd-0bd5-459f-a656-22af2b9f53f3@kernel.org>
Date: Mon, 9 Mar 2026 15:22:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] binfmt_elf: Align eligible read-only PT_LOAD segments
 to PMD_SIZE for THP
To: WANG Rui <r@hev.cc>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Kees Cook <kees@kernel.org>, Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260304114727.384416-1-r@hev.cc>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260304114727.384416-1-r@hev.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 118F540012
X-Rspamd-Server: rspam07
X-Stat-Signature: w68s46nmir5xg3oeksiwept9qmicig1z
X-Rspam-User: 
X-HE-Tag: 1773066155-401805
X-HE-Meta: U2FsdGVkX1+soQrLFvLtPxaDCinDZhjmVnJvHHtdtTVgBNnkB30qCWmlz+wDGSyw2EVSRx4fCWQWxJ3DR0yyJEaOFnyTCocNgJoOqsvjBrKkT7gOnde7uoH0+A7bP+2YskdI/zW5OGTSlGYLqnRG+HPYJ9dm+fIJn0uVj3byG18B358rrLLP0rH0wQRC12EB9JamvHKrmBBFGcjpq7RL+KGExMkKiKNis38N16UdbqsPBbrSfioQOVJdH/WXaeLnW/S51lKsPEp7kAZUY9fhqkxxnqG9Z9o1MKiGel7U1Rsf8IJIfc2VffNkJFEao65kIid6O3nIZqjUAShJCKJMNAn2nXZe8Ej2T0/ZzZZHFtsh1mSxWoqFsl3BetkvIycG2VCXIviwmcyUHXLE5kYw9ApDo/FdC4Z0w8pLdPxngcZVf7bY6hebstejal7gxfFe7Q5o8o7nA/HJsrX5twfW919NPhb6RGpRsl7poz7YyTZT3FwiRBRqkdJctUu0baDW2Lo82cm6XT+O3RdbYaBkDJyblahAPmySclmc39930apgPFAdDtptVV00ZYwTKWtZp9LtD9uiq8P9DizlnSkzvVx3xCRm/vWTEBTk8EuL+6frCm9JNFd/McXOXz962iK6ypIrCVyPyiN4ScU44jiw8fARowuYkm3wmeTnDqJ5ntmaLYiO0bHxxD4FpNdrqguUBjZfQrqzmlV6O6WQljKOuP2jIjIBcjItrc+UP0gnGxy5FZ7yYKb9rx9g6RvdCFgdbJSfxH9ewZ5rzyXjSFTfPTtbRJCGETrHtK+vhYgLPNBwnPAjzO98ScfZ/rA2wj5EjY2vZuvTXPMYicogOZkp9iSi8ffLOq33/+fszeXUyfWW3tqxcBFnutHAGTAb5Dy56Ltj8EMky4KN2m6VW9edPSbw4ziSL/svg0oW92aL6OCzQBVe7v9/j8SCYAgvc+QhIJ7G/gMYtlDlzptGpK7
 xUeAbkU5
 +k+mWKXlNYsDaMekRvoMMDbjEvag74zZaMZW6UEBd+5XSkXZl07d+flMgDmNaiLsnuN2tkqGgr2LVSxUohh69cdL+EkmGsQCErE0wOhmZn2KnVMfvhZT/lJnZHnOvTBE7STCnTTcqkcglyOxC4GE7e9qF3vtXkuA+PIMGQIs9nWkUXxDRFLlbQ5k/eMj2zrVF5dnx53L3A44EBCUxKehzrtE07GwZFC1TGt+3TCwyI70MBKqw2KbP3n601zbjqMaTQ9+GeqCQ3j4izwpBfAfH6A1msSBqfk0zHfi8L6+0ifZDSGihM3fhuuMONYXJbnVcjN9A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/4/26 12:47, WANG Rui wrote:
> When Transparent Huge Pages (THP) are enabled in "always" mode,
> file-backed read-only mappings can be backed by PMD-sized huge pages
> if they meet the alignment and size requirements.
> 
> For ELF executables loaded by the kernel ELF binary loader, PT_LOAD
> segments are normally aligned according to p_align, which is often
> only page-sized. As a result, large read-only segments that are
> otherwise eligible may fail to be mapped using PMD-sized THP.
> 
> A segment is considered eligible if:
> 
> * THP is in "always" mode,
> * it is not writable,
> * both p_vaddr and p_offset are PMD-aligned,
> * its file size is at least PMD_SIZE, and
> * its existing p_align is smaller than PMD_SIZE.
> 
> To avoid excessive address space padding on systems with very large
> PMD_SIZE values, this optimization is applied only when PMD_SIZE <= 32MB,
> since requiring larger alignments would be unreasonable, especially on
> 32-bit systems with a much more limited virtual address space.
> 
> This increases the likelihood that large text segments of ELF
> executables are backed by PMD-sized THP, reducing TLB pressure and
> improving performance for large binaries.
> 
> This only affects ELF executables loaded directly by the kernel
> binary loader. Shared libraries loaded by user space (e.g. via the
> dynamic linker) are not affected.
> 
> Signed-off-by: WANG Rui <r@hev.cc>
> ---
> Changes since [v1]:
> * Dropped the Kconfig option CONFIG_ELF_RO_LOAD_THP_ALIGNMENT.
> * Moved the alignment logic into a helper align_to_pmd() for clarity.
> * Improved the comment explaining why we skip the optimization
>   when PMD_SIZE > 32MB.
> 
> [v1]: https://lore.kernel.org/linux-fsdevel/20260302155046.286650-1-r@hev.cc
> ---
>  fs/binfmt_elf.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index fb857faaf0d6..39bad27d8490 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -28,6 +28,7 @@
>  #include <linux/highuid.h>
>  #include <linux/compiler.h>
>  #include <linux/highmem.h>
> +#include <linux/huge_mm.h>
>  #include <linux/hugetlb.h>
>  #include <linux/pagemap.h>
>  #include <linux/vmalloc.h>
> @@ -489,6 +490,30 @@ static int elf_read(struct file *file, void *buf, size_t len, loff_t pos)
>  	return 0;
>  }
>  
> +static inline bool align_to_pmd(const struct elf_phdr *cmd)
> +{
> +	/*
> +	 * Avoid excessive virtual address space padding when PMD_SIZE is very
> +	 * large (e.g. some 64K base-page configurations).
> +	 */
> +	if (PMD_SIZE > SZ_32M)
> +		return false;
> +
> +	if (!hugepage_global_always())
> +		return false;
> +
> +	if (!IS_ALIGNED(cmd->p_vaddr | cmd->p_offset, PMD_SIZE))
> +		return false;
> +
> +	if (cmd->p_filesz < PMD_SIZE)
> +		return false;
> +
> +	if (cmd->p_flags & PF_W)
> +		return false;
> +
> +	return true;
> +}
> +
>  static unsigned long maximum_alignment(struct elf_phdr *cmds, int nr)
>  {
>  	unsigned long alignment = 0;
> @@ -501,6 +526,10 @@ static unsigned long maximum_alignment(struct elf_phdr *cmds, int nr)
>  			/* skip non-power of two alignments as invalid */
>  			if (!is_power_of_2(p_align))
>  				continue;
> +
> +			if (align_to_pmd(&cmds[i]) && p_align < PMD_SIZE)
> +				p_align = PMD_SIZE;

The function name does not make any sense when reading this chunk.

"should_align_XXX_to_pmd" ?

-- 
Cheers,

David

