Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68338E63CA0
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 14:47:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81C656B0088; Sun, 25 Jan 2026 09:47:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F2D56B0089; Sun, 25 Jan 2026 09:47:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FF5F6B008A; Sun, 25 Jan 2026 09:47:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5BF306B0088
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 09:47:05 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E6FA413A185
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 14:47:04 +0000 (UTC)
X-FDA: 84370763568.27.59BC77C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id F33F614000F
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 14:47:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Aw0t/T1+";
	spf=pass (imf23.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769352423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pFt68Q4+goK93Nz3JR6DyVM6cbjS7yaqJz3AamnIoVE=;
	b=mT5BFypbATVI546uGUml9sIGlQfbm9cNhWr0WtHMF8AerA4SKeZwFaN0NRp1WKYJC5PetQ
	gY4z7ehVunlZTSPsmhOVpIYn7bPbB5jXW3LkSmKxbr8Pbq4d1eOOZKJr//QPPYkHb7XZvi
	XYdRhX/9japukyUxncBapCizLMf6y7k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Aw0t/T1+";
	spf=pass (imf23.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769352423; a=rsa-sha256;
	cv=none;
	b=Un46QyUmfqy4IY9PdWBZwO2d0inbIkcnaBATFRjJIo4z2QUIT/HgS3ijRyn/NMztqOVmwC
	WJzp67oIrpAl582Hz2R5wU3IbhAA7ZXOxGSfahQt3ScJ8FsdToiYTGm97sQdJFfEXs2ndo
	Gxxij46rB4sJOFb6SsVqGbXSt48nE2w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E653E404A0;
	Sun, 25 Jan 2026 14:47:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A86AC4CEF1;
	Sun, 25 Jan 2026 14:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769352421;
	bh=D4rZHek649r38ZMrKc0EUETSxogBTg6UND5Vy7tJuco=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Aw0t/T1+o7fdk6QYLzKKJivljnur6v67ACKvC4S8H+eVALhS5z2OftpOca/2ip1vT
	 mP+TErWLDAgv4hW1xmsBzRU9yZ8M/uOn87tjE5IDCqBOPPzvzbIsxsMl6EV+UL80Dy
	 tvJgIjkGAOSxz10G9q4hE52kHSfGRvpZwvs6p03OPaUGL00W6878lBlhoz0e1t0EAO
	 EMS3+DJHEjMUhiW5+resBf0NdRY49WZT2DFOKwn5xjHU3oaqq5kBOpu6IO3rDCwwHs
	 EIboBUhJdwLQr8OWBqzpJqvfpNrzLdLbP1dmo7BjOdCsX2AZ/I614TVnqN2xNKHVXk
	 TzdzzUx/4SWKA==
Date: Sun, 25 Jan 2026 16:46:57 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Wentong Tian <tianwentong2000@gmail.com>
Cc: dave.hansen@linux.intel.com, tglx@kernel.org, mingo@redhat.com,
	bp@alien8.de, x86@kernel.org, linux-sgx@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86/sgx: use vm_flags_t for vm_prot_bits
Message-ID: <aXYs4QyRrnDc_iDj@kernel.org>
References: <20260122133633.79792-1-tianwentong2000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122133633.79792-1-tianwentong2000@gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F33F614000F
X-Stat-Signature: 4xy71itijcq16qnkgya3p4cazgb57f6t
X-Rspam-User: 
X-HE-Tag: 1769352422-791600
X-HE-Meta: U2FsdGVkX1/NeqQJmEImcyLLU6Q5sYgPv92VxGKKUwJDEonyxdu3u1V63Qzq5LgOUQ7CZetPf2PyfZgSQ4AE8pCPIxzA2g2B3UUXGiJsWpNID00W3acObc7kcYwV+RAZay0fsjeneT9T9kIXHJP44Y0RH0xUR2/YzNegn4scmUThphDUhWpT3FgOu0prvKYAEaPklpbxe4Z9LswvcqfMp2TzZTfFjjcWdL5W1D7726ic6RbYNVo+lfldPGnG6FWD8pjRGn4x0qYISwdiZG5AE9nmaIDwYcs5Adq9N1zd/ELLo1Pw2OxNy4gXC51r+zEit/GbzVPFkPcmBXVT1W0nn2V1jf/epQs5IgOaEmzFsecG+NbJOhAjUq/gs3gk51fbEMkb/q+2hCtmN6J35pU6SwhToBj56/l53F3oAPbJkR4eM9+x8vYKtVDILIJrXM88vDScL5UceQJ1pS4VXjBHHPB1IuoO08gBUzdjprf8HX47K/jE3OW1wpLHJNe4TFcZ9FNxOfUk2whiFLDS4o7R8duafA5EmXgIL6BuXC6dZebcs7rm6Xt2YJs5pzXtE7fA3zP+PRxKZLnxhiLe/vAFw+CD2XPkEufBt2MU4WImTNFvQmA9MbfND+LaqcWxV6ihlERr/2AOpawqf6iv785Em9vChpCB5r4qAfzWRZpz3GMXP1Xu/W/UdQQ47kMKIb/gQCMWZ/RG1EAjX5P5edwEh8isnOygvIeDjtfJBin2HA4O9/eInqmvdPEjuredSmdkOq8zJUOQHWA74XDD71ok+IzRFvhYvZP5VfllJnAfbsHjRwMeQnb94vvx5QcTjWMmGFhDwnAs2rTf5OZD6NniFdyC3i772iokXcomPefDvp3zQAkPgJG2AHw89EuJBS6gwHwrlWpI1zpa3m9a7q89Q/vKvvDGQuyLRbbf4hdLQ/+An8OzB5199YPBnK4rLMlx3GhM6X2kRFgEdp4tbqz
 S1925H73
 pisZmJPM8NHGxhzJZAXMBe84rDUaH0Cmgz4HT5WeEXoL85PbQbI+NWk0t4pe1Cp1v3kVsmkXXS3er1uyT/W6DTrNp0eaeZc3sXeG9+rEq1dtUAtFZQ6jZvkwgieN9UiVuHTP7swdEqZoVk8MbSaOuR6b0xV2lNUfVbxLKuoWD1rj3pULc00o6ahWzO/iNshbYF9jy0HJrstQzoMMaiFGfBg89RBrcx9tHtbafilLm/dYBojgnbjEYVabBJOqcR12Lp2+/vaEZzwzvdSG58PspLRjXjyjfK9fwE8vmGK+QBTuCbSsxHF3ikz8XJSTLX6e6p2OYWwjixfFKz2Ko1oK1qss9cUGkZmFhb2S6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 09:36:33PM +0800, Wentong Tian wrote:
> The vm_flags_t type is the dedicated type for virtual memory flags.
> Architecture and driver code should use this type instead of assuming
> vm_flags is an unsigned long, as the underlying type may change in the
> future.
> 
> This follows the cleanup in commit d75fa3c94750 ("mm: update
> architecture and driver code to use vm_flags_t") by converting the
> remaining vm_prot_bits usage in SGX code. Also, update the vm_max_prot_bits
> type in struct sgx_encl_page to vm_flags_t for consistency.
> 
> No functional change intended.
> 
> Signed-off-by: Wentong Tian <tianwentong2000@gmail.com>
> ---
> v2:
>  - Also convert the type of vm_max_prot_bits in struct sgx_encl_page
>    to vm_flags_t, as suggested.
> 
>  arch/x86/kernel/cpu/sgx/encl.c | 2 +-
>  arch/x86/kernel/cpu/sgx/encl.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index cf149b9f4916..814edcde225d 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -281,7 +281,7 @@ static struct sgx_encl_page *sgx_encl_load_page_in_vma(struct sgx_encl *encl,
>  						       unsigned long addr,
>  						       vm_flags_t vm_flags)
>  {
> -	unsigned long vm_prot_bits = vm_flags & VM_ACCESS_FLAGS;
> +	vm_flags_t vm_prot_bits = vm_flags & VM_ACCESS_FLAGS;
>  	struct sgx_encl_page *entry;
>  
>  	entry = xa_load(&encl->page_array, PFN_DOWN(addr));
> diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
> index 8ff47f6652b9..0e0b97e91905 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.h
> +++ b/arch/x86/kernel/cpu/sgx/encl.h
> @@ -27,7 +27,7 @@
>  
>  struct sgx_encl_page {
>  	unsigned long desc;
> -	unsigned long vm_max_prot_bits:8;
> +	vm_flags_t vm_max_prot_bits:8;
>  	enum sgx_page_type type:16;
>  	struct sgx_epc_page *epc_page;
>  	struct sgx_encl *encl;

OK, I missed the remark from Kai, but it is acceptable.

> -- 
> 2.34.1
> 

So again:

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko

