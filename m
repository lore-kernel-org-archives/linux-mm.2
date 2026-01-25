Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF788E63CA0
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 14:45:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80D856B0005; Sun, 25 Jan 2026 09:45:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BB866B0088; Sun, 25 Jan 2026 09:45:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BD606B0089; Sun, 25 Jan 2026 09:45:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5AC7A6B0005
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 09:45:38 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EDF8C8BEF7
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 14:45:37 +0000 (UTC)
X-FDA: 84370759914.28.62AB770
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 492C4A0008
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 14:45:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="m6oL/QRk";
	spf=pass (imf15.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769352336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lg7/BHFKZKaH/OFm7kz0P2wH0svnx96Z2AwgLQCV9mg=;
	b=63PqfJbEryNgLwG2NqksXHsereBAzDqnyLZ/DSqwzBmcWnsThvTYYE9z1hyL4nlLxK/Byb
	7+S5VqXDZIUkUzL0Edc6c+9n4GGNZdaXS50FfMEFFkw7bmhFtqa4A5tVM2ngxZXYuxUxIX
	wN8UHg2pcHrTEL4+7stXusDGMMU0FfU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769352336; a=rsa-sha256;
	cv=none;
	b=KipNr/DGMCWjYavwhwqSAAkuMaM6CsxEKXRIzWI7bUS5l7UCP4oeRpaDMr+XnC3ZdLw3V4
	ZZ0mteE2f/fCzOt2VrOLx51UznGho3vQo3rp5KLJ7LmvKoU6bTFDQEad7wOBXFfgWJPXds
	LO7XTc6mPmi3cJLC3Q43bTT1R3JxPs4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="m6oL/QRk";
	spf=pass (imf15.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3484D404BD;
	Sun, 25 Jan 2026 14:45:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B9AC4CEF1;
	Sun, 25 Jan 2026 14:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769352335;
	bh=pgkOQSEjB2Sw/CI7QDlrl9YkRcVaVCAeiqMx1e8wmAw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m6oL/QRkuZtbyX55NjTdA/RX5Y8/r2M89CoYdUfLcpFzRoA0K7F7eNjkfN+GGx7uv
	 CM81trUqYgE9bH+7riIh4MBDGYKNwTZEYnFMMchLfwMWMc4ejzUdTimZLhM04amSRW
	 8YklSov1f57soG7M7qGS+w7RlLZ9xoCDPvT3eNDbGj3Q16Nov9tz9C4XR8MbOROy0k
	 OelfTp7OoEQ2kpOl5k5LgFVEC8IEdxih7mu4RRxB5Q0gTPG+HnjaPrjT9TyMYbzIEw
	 vy8il94ydSnTfHxu0DVX8rQpMDEARexPb26zQ9vGiPpwyc1KAGe6okjYiATBngqAgW
	 CWVXecugvd3cg==
Date: Sun, 25 Jan 2026 16:45:30 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Wentong Tian <tianwentong2000@gmail.com>
Cc: dave.hansen@linux.intel.com, tglx@kernel.org, mingo@redhat.com,
	bp@alien8.de, x86@kernel.org, linux-sgx@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: use vm_flags_t for vm_prot_bits
Message-ID: <aXYsikbf-2yMnJ1F@kernel.org>
References: <20260122055435.95911-1-tianwentong2000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122055435.95911-1-tianwentong2000@gmail.com>
X-Rspamd-Queue-Id: 492C4A0008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: p6yefd6s6n7a713ukdf8ri1cyza7nnft
X-HE-Tag: 1769352336-891405
X-HE-Meta: U2FsdGVkX1+pvP82VrtA1WstjbV4hvgoPYmn83oEsBQIqTxB6ZpC9+ICySMnGsOIyZB3AJBn4zLUY0y+rXzN8UgPhux+cffmrkbh+HdK4xo640Ct4z6qP7nAjSoemXGfcdBitw+rg62itzIbsrN4lS3REYAjvjBCUVOgTv00KHyBP63cj8SZ/XAJVhHH7sgliKAcyfxEtG9MA17urQZYObrC8cer7irgAFzwAJmt2HosAHSUNajAsOePOiwx2LAd3TpJZr75ODZj57egjwqMkR8424FrLbLUkQEY7UKiyH6gpFIKNiRxdD4gldbL/GdsrZByUkwm5u/Z236IyjKXT2f0UI1OGdfFYwUuScaeVr8RsQ8k2/Vquw6NzH30m1tch3GWe0AU3uoqdbbnjIa6oWEu4nRAqIRUD7CLlM029w7cGalv8ux9ifozp8Y3Jwy60btPKkMnjkeSSGiLB1p1VsVNHZ0+70t7Pn1sgn1AzKpHLHPno4TmYGWGbtCC5X+zsG0PFxUlulXrz0rNlcGoYbSCbJ2MBsKj4vtRRFI1UHVhg5D93izrA0eBsL8uj1pVo2e86h+kDJODBd6Ieja4rKsSs5+1jGufdOhiHqLyy/+jQwbHEt3HRWHGR8PrfvM9WykFx8nzaPzrGxOZJ2FrHMDowP2d8vDCE9euuqpZ4ykgox64sBhZyqX0T6wbMKp5kmBPJ5ukbhmshO1q+BCaSdgbvkQ8GnE1cfmusaib22UbchuT8ZdGNVvl3OpK7CtFQMYBcdI/c+G2ByaEqbqj5bN/I49Yl6X8vtIy9ecL3L3Zs8rxiY/3bhHTDqyukGIt9iGP5J9CEe2QOfkipiiFizWcRPWqfCATc2FB0ZICdbktC6cyMjitPzgz+tWGFdRHpJEMdJ1om/5gegLj9uuLvQSjl6okJBIMqFVaitXPJxMPKVo2SJZHw0E+SOR437TZ67ryu7lm6eDW58niKk+
 AxykPnLf
 Ozh9iN3BVwGDNrUo+H/+DJzEvYtPFIA22smG2rzJMuYpdo0p2GW2vVPMyMVK9AOMXAQBbDIqTkFpU/gWe+aAQsTryKxi49fQNlC7fMG51xdwPqOwHYlIBFHa56WEE9gye+jKvZTufUK3C5SopoIid0taK/bvlpckAPNW1DoUq4OkSBBn783yJe+e43mZaGmbEjUNls/kfq3eN26KiH+DL8SY3HWsSSv3qsU3Yx1lx2S7c0gjK0ZofBa1jvuV7jY7/8y/3Yzmv2LG6dMepxlLMUj+6qnjt4Vt3rbJEWiblkampgFSkpE4NFnGpToCjkhPejX/I2Ct/hvp7tv4iFwd3LG48+gGRiAf7vq6J
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 01:54:35PM +0800, Wentong Tian wrote:
> The vm_flags_t type is the dedicated type for virtual memory flags.
> Architecture and driver code should use this type instead of assuming
> vm_flags is an unsigned long, as the underlying type may change in the
> future.
> 
> This follows the cleanup in commit d75fa3c94750 ("mm: update
> architecture and driver code to use vm_flags_t") by converting the
> remaining vm_prot_bits usage in SGX code.
> 
> No functional change intended.
> 
> Signed-off-by: Wentong Tian <tianwentong2000@gmail.com>
> ---
>  arch/x86/kernel/cpu/sgx/encl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
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
> -- 
> 2.34.1
> 

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko

