Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 032EDCDE011
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 12:06:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B19876B013F; Fri, 26 Jun 2026 08:06:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC9786B0140; Fri, 26 Jun 2026 08:06:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BA716B0141; Fri, 26 Jun 2026 08:06:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6E0C76B013F
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:06:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D9DB1120446
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 12:06:33 +0000 (UTC)
X-FDA: 84921936666.09.8AA50F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3E6274000B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 12:06:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HuLiCafF;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782475592;
	b=VSDZienHg/+FJoBydyRFfzS9sSftTWgBhZ2O7LWIsiHyA+GFattt5KJcIlj3uc2jhKLEup
	+cEULiUKbKTuSN22Sc89QSBMpXtm/y7hfdfcG/B/pHa4sfD9jbBDhQgFwKYy6LtssVPY+h
	aFHrYRBGY+3IQtdZPkTByhenixAsvRE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782475592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CR/q+u4UxqSX/SXdvCBsFabJIJzu5N3mtpvnRKl9G+s=;
	b=AjoRNopBARpC8S3UxU/zl3wTWNqI4y6CkiPVa8baMmEZPA6PlXVfw1qQdNMJACvtdPgAdr
	1ZVcHSCHd4rcmsRgMB333aCUFpDIxyDB1PGnKBDCg6OIylpKuHK7nNFG+1Od1A7Hi2JEFA
	9JXW+nr1jQEkpWSN9l3f0EdJKhrBl2s=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HuLiCafF;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6905F41AA7;
	Fri, 26 Jun 2026 12:06:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE9F1F000E9;
	Fri, 26 Jun 2026 12:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782475591;
	bh=CR/q+u4UxqSX/SXdvCBsFabJIJzu5N3mtpvnRKl9G+s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HuLiCafF27i+a1Hwbe58UcUWXi+RtmTlsiS1578ZPbFvyClVUMajIx4xvQq1Nn9MW
	 6U9H0QCEquJHo5VesQ4uw/caR8kMCLxe/nFB59OF7KtpZiRUrh0cuf6AOVwt/zP1bJ
	 sXe63MHAbjGiDG2Nef7mAnwdboy4eJuhMEe5QZJusYZ+4XkVGtrDtnKkodet8xtO31
	 zUUEh1HFS/oV6/plnRvAFtq8v/w075BqMhU3Sc+KEzY+vTFxFd3uZgAHPVemYOqkrZ
	 TEm+sXgtZqQN/Jef6Wk7mfhIzzZhNGqRnfFkvJdoHDBShsbePempzC73XGjppHzGVA
	 F7pI/mUK+NtQw==
Date: Fri, 26 Jun 2026 13:06:23 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Alice Ryhl <aliceryhl@google.com>, linux-mm@kvack.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm: fix CONFIG_STACK_GROWSUP typo in
 tools/testing/vma/include/dup.h
Message-ID: <aj5qnsGDPC3nREdT@lucifer>
References: <20260611012258.432043-1-enelsonmoore@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611012258.432043-1-enelsonmoore@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3E6274000B
X-Stat-Signature: 6pusdxtn5igzu3e6q44ch4nmc1rz4u78
X-HE-Tag: 1782475592-781605
X-HE-Meta: U2FsdGVkX19w/BA2/ergTcF3BD9+hRwPn3gQNZnjqkNYQFQG3C6OhRA6dYNuSIbhtldtoNwxVedNvn8T2R83i7In79Hr+YI09t2j68zpyEhh+1u5cctRKvd0uJPdeXAn3eaX29fVPlRmfowXsWucFpgmCT01dXvzcijHMEx7xH5Ggbmd2L8PFtRLdi2PNMGqD+cg9NCew0A0Z/ly6P6yhNaSpYcn3/BsjdlNC0duDvRtoxqzL07SviCvSNgrU/iHf/fJykgddThaVSrRWfzx9EbDqLHp5mvSEZ+3qa38sSbHFvrnACoPk1cfOp6Eh/adzcr8NRDXXsIDnWGO+po8c5ZUPCvCvmGH/u2uRECnsLWwYAuNP0mrvaFQtPob3Ox4MUuI1Iv6g7Tq4Ii2SruYwAlI4NuEYqmIWSUXn3A0za4vQNGsb59D8Hb814yMdsqgp139964E+FirHDJxG0vSy71kK54FKBldGevagnCTLLbx/0b824ME+VXCVpPLqBuMz8CRz+ym+uA8+m0M++n9H5O/ECTn8uM7S9mHcv4pkDPhbfxulrGpj72uBWElLg6AOAEKqyMp1TLmdp/932AocrD/vxsIcep/TJbP+QqOIbAFBolOEHQCo1XdTzdKCJjoTss5tEUKbGDoafXEsUX9p88XMBI68FGpxEUWVxacmb9K6eOw9E7JdrzWX2UiDnll9CiG/Pf5KnbjuIUavW9WJrsDtI0ZoQiSW2cCdE8BlImTkykesm4RKxmpIYNHOHn8Y6llWS/0CeQzOFp+oHcLshKio3GdvMvPWEzxNSINjjbUn/XhVEc6ruDX/MpU9IMuoWNJQzRJ1qX1rV3wGsWczuIwMC94h8XJJ+pS99Q45uwTLe5GzHncGTNolcFjHXUsx30yr51oC9xwt3io3PRN2XOyWWHqHMR42DRjKab8cbiq6xrdJJbGn9FKABg6BjPDMsiLaBEdENo6mDeIg9q
 qVa++rHd
 ZujL3KDP2WzQHaKa6aS0jYmelEuLMgL4pg+gS7fbVZr9T2pcH7WXduYO/tCHmGzJWs1jbgOAmKjTAkwLRHdZ9PCp5YU5LWqVlOxrOSGdKMKG7xuZ+Y8E5zRjvhVAhq4bsmsrAZCdIxnYjl7ZYRgwVhJEq7MLUPyKXR049mY8RBkL8Rl7JkC8//UGr7CKyaCjWZlg4dp16p5TBSK+PiFzacTrQjAIEWN0Wd9FPKnQ1G4DAR/4WClSZMYsa0TLzWOKny1Q46efu7eqjczbRF/Excf291FpXKacRMxwxjOtPDKlG1PSm6YebnVogXiNpIgq7pV1DthhNBWsz1TUwu/EWo/c4eA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 06:22:44PM -0700, Ethan Nelson-Moore wrote:
> Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") significantly
> refactored the header file include/linux/mm.h.  In that step, it introduced
> a typo in an ifdef, referring to a non-existing config option
> STACK_GROWS_UP, whereas the actual config option is called STACK_GROWSUP.
> 
> Commit 40a4af52e047 ("mm: fix CONFIG_STACK_GROWSUP typo in mm.h") fixed
> this typo in the mm.h header file, but did not update the copy of the
> code in tools/testing/vma/include/dup.h. Update this copy as well.
> 
> Commit message adapted from the above-referenced fix to mm.h.
> 
> Fixes: 2b6a3f061f11 ("mm: declare VMA flags by bit")
> Cc: stable@vger.kernel.org # 7.0+

Actually since we don't set the config options like the kernel does in
userland tests, this can't actually be something that you can get to
happen :P

So drop both Fixes, and the Cc: stable please as per David (Andrew - can
you make that change? Thanks!)

> Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>

Thanks for fixing this however! I typo'd this in the actual code but didn't
update the VMA userland test code. Appreciate the cleanup! So, with the
fixes, Cc: stable tags dropped:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  tools/testing/vma/include/dup.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
> index 9e0dfd3a85b0..adbc3179085d 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -243,7 +243,7 @@ enum {
>  #define VM_NOHUGEPAGE	INIT_VM_FLAG(NOHUGEPAGE)
>  #define VM_MERGEABLE	INIT_VM_FLAG(MERGEABLE)
>  #define VM_STACK	INIT_VM_FLAG(STACK)
> -#ifdef CONFIG_STACK_GROWS_UP
> +#ifdef CONFIG_STACK_GROWSUP
>  #define VM_STACK_EARLY	INIT_VM_FLAG(STACK_EARLY)
>  #else
>  #define VM_STACK_EARLY	VM_NONE
> -- 
> 2.43.0
> 

Cheers, Lorenzo

