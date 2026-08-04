Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97731C5518F
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:49:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE88F6B0092; Tue,  4 Aug 2026 10:49:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB3526B0122; Tue,  4 Aug 2026 10:49:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C8F26B0092; Tue,  4 Aug 2026 10:49:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6FB216B00D8
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:49:39 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 13FFDC011D
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:11:32 +0000 (UTC)
X-FDA: 85063321224.05.24ED311
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 84BEAA0008
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:11:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nR2VBNRV;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785841890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lPlMqpw1IDLRtYVeniRNxYTVPDHrNiexqffQCORp34g=;
	b=7H40WEuWyLiT3O3H38ohByMfNhGq+cdrdzjh2NGUagBEW78G7rY6Don+j8isZLIh3o3gFW
	MvnL9ydVDkIavkxPfM4XBgkxkvl47jf47sId4S/Y61pK4omczQufiMxiXlsXsIBlvVHP3T
	hyTnqbMtS1JIJzM6vtWkX8qXP4BvNNM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nR2VBNRV;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785841890;
	b=k4VfLQtfgI4zJjh/87HcsfY31GcYg+krm0FiwaYp1ZMwU8s0QEM10f1qC2bUArWXxvC2cU
	j/LuUCUX4hvfyHj+FHy3CxAJ//yCX7OEMBVXOoXTYlSSFos673UgnPTJJlg/RnQf8i/aQx
	7acaGX5gwjdT/Wx31+T4LuPxTTTgV80=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1586060A71;
	Tue,  4 Aug 2026 11:11:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 189511F00A3D;
	Tue,  4 Aug 2026 11:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785841889;
	bh=lPlMqpw1IDLRtYVeniRNxYTVPDHrNiexqffQCORp34g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nR2VBNRV0pk1/OgzMczs6p6psKwdhUOyZldMBZXdygQAo/uvz9Wm+fZryWyxvHs1N
	 tugMO3FuAf8iTrlmndYjOm/Bb/N2rPZdKEmFl846PR+iMA0btzcbh2c3EJcd8mHuuN
	 fdGFsBi04TbQFLPu9RVEjd22d+D6Cay6M2i7vOJMy6U9VB1zlCfalZJjnNA8BRXlsZ
	 cbAldKjKURmWlZZvTpkRiXIqqL4UOmUjNeH/t+yvRz0qMxgWP69xU+r6rms3nYh3Ei
	 EHdYt4bqTsBxaFdvBxzCK1DLNkVJdNj41y96psFb8DllhxnbvJ6lbCR59BEPua/jAx
	 QNUZ57jLN53YQ==
Date: Tue, 4 Aug 2026 12:11:08 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kevin Brodsky <kevin.brodsky@arm.com>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	John David Anglin <dave.anglin@bell.net>
Subject: Re: [PATCH v2 2/6] parisc: Drop own implementations for ptep_get()
 and ptep_test_and_clear_young()
Message-ID: <anHHyiHqYf3yLf2K@lucifer>
References: <20260803164400.531199-1-pfalcato@suse.de>
 <20260803164400.531199-3-pfalcato@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803164400.531199-3-pfalcato@suse.de>
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 84BEAA0008
X-Stat-Signature: nffixtmx4c94wh5crzxkxx48mppjyckj
X-HE-Tag: 1785841890-661910
X-HE-Meta: U2FsdGVkX18Sk2L8BH5WuCI0iwPksOoMZnrLzUwBPcx0rAUaoGKEyuDB3rE0VCa9gnFja8qLVRVqr/djokBVd+/i0Jw/8fxi90QOHX7r/702aM6vEnP+CMF/9cQeRnl5OHEGuo3kd0wl0ojDtPG7Yp/IYTE/3M1b5gooh/0DarhVT5IXvv4yfu9yf8UCqZKQQebpzpPR6yBgouibQqItjVvt0ONKN8Og1XwyT7KFV6Mw1vJcH749Xg4nIZAm0GnG+g7N272IXFMysSajZi/4IqL5vnsIjB2lF0zaLYvcDctTtP+2WY6kweukwQo5JzE4re6xLgGmcle1fJv7UTRs6rKsXFiOBPKtGZ3px2AsRbidnbdVI+uZcRSxvDBHWs73niN09jP+O0yP7/hrnj+3FDonQ7Ja5IzzMKRdI2wH4DrR3oN+FMoFmtKcmQtJCg3qatj6CC7D0F2PIwcpDffXiXQe4m0wMM1hWVxz5TaI9JxtvFYiOzTDLHoA1khPFafqPIStgqkNvqTD0n9rH4lkUKVlx5+gFVSsVn3/5E8gAb300FfyHVQOWDRYAwLSiv+YKbih55yOnzozsM8eSXwE1MlGK/aLq3Vh7AiX9C7ltNqX2orJVkOv8ck8onXalKTM2+YHoEeYMGXCKLEe80rASGpk9zVno+gUb3t0XK/44Qb4He7EYzGzpO0ebtQWItRyynZLfMeT1u5/OtV4oytmoF0TzN7yCsgzrVtJKlwDp+qpgBZTw0gZ5Z44yjvP7lFTPHfMxO9dGdNoKh7cYxrQUq4LRO/UNUfnaF/xbyeKbolyd12cHg8y9q2f798F+kwRSLfUpbhRtrmbOJVNebovDu7fs2B4uFkq4prGsbK8sC/8hIUn9Ux06wWj8b87/0ErUnaFJxrJle4f/sts4Q9UQnamvDq3Kl86+3euf1LOSMrwBdsgdZ5eSuqVdSSDID6DYjZD5VSHq7KRW4FbsoJ
 9bVryzcH
 Je9K6cL9EtIFoGaeWBMJ4Cz4FA6P3CjOqBgAUNbf6ClI9YMluKjRyX5gZMBXGtJd6q6Ng6yNUgXPw2Qt79uOnBYnF6LAidoc/7Jx5kf217lmYcRLJuPmbER8f/pkgYBCw9yuCpvPTTHuv7PUcD0kRoy3vi1qzXQGXusFv7N5NosWS8tOVmK/BS17fnAU+7O3pOhuhjx9bjDU8cBr548ooI7+OpmPSN2I+Ru5jZEqQmd0KoMUx6ejwVEd6rVI1+4+chUvIvlBC0PW71oDIX7QespvWPY7ux5TxKj7dC1xNOGqM6D7fmJZfsyTx7bKBujZ5BE7wSTpVCAFrNdJZKwsWWHi2QDU0lYr+hQZf1MMiHM8CnGTK0sOQqWHPlM0zBwHsSH3gg18TfdLNoDOwQbV1Gxhyg2rvvbqcqOAv0rQSD5D3Ax4PstWqLeisgdQtorxySJOR9RpxY7s1vgg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 05:43:56PM +0100, Pedro Falcato wrote:
> From: Helge Deller <deller@gmx.de>
>
> Switch to the generic implementations, which are identical.

You sure do like succinct commit messages :)

Maybe worth saying by dropping the __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG and
ptep_get defines you get the generic versions from include/pgtable.h which are
functionally identical.

(Being pedantic, they're not quite strictly identical as the
ptep_test_and_clear_young() generic function does some weird unnecessary
indirection with a local variable and the single {} is dropped etc.)

>
> Suggested-by: Usama Arif <usama.arif@linux.dev>
> Suggested-by: John David Anglin <dave.anglin@bell.net>
> Signed-off-by: Helge Deller <deller@gmx.de>
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

Nits above notwithstanding, LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  arch/parisc/include/asm/pgtable.h | 20 --------------------
>  1 file changed, 20 deletions(-)
>
> diff --git a/arch/parisc/include/asm/pgtable.h b/arch/parisc/include/asm/pgtable.h
> index 467b8547ac8b..d92dee9fef3f 100644
> --- a/arch/parisc/include/asm/pgtable.h
> +++ b/arch/parisc/include/asm/pgtable.h
> @@ -432,25 +432,6 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
>  	return pte;
>  }
>
> -static inline pte_t ptep_get(pte_t *ptep)
> -{
> -	return READ_ONCE(*ptep);
> -}
> -#define ptep_get ptep_get
> -
> -static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
> -		unsigned long addr, pte_t *ptep)
> -{
> -	pte_t pte;
> -
> -	pte = ptep_get(ptep);
> -	if (!pte_young(pte)) {
> -		return false;
> -	}
> -	set_pte_at(vma->vm_mm, addr, ptep, pte_mkold(pte));
> -	return true;
> -}
> -
>  bool ptep_clear_flush_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep);
>  pte_t ptep_clear_flush(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep);
>
> @@ -491,7 +472,6 @@ static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr,
>  #define HAVE_ARCH_UNMAPPED_AREA
>  #define HAVE_ARCH_UNMAPPED_AREA_TOPDOWN
>
> -#define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
>  #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
>  #define __HAVE_ARCH_PTEP_CLEAR_FLUSH
>  #define __HAVE_ARCH_PTEP_SET_WRPROTECT
> --
> 2.55.0
>

--
Cheers, Lorenzo

