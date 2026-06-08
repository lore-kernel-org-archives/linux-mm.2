Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6FBDCD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:43:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 286396B0088; Mon,  8 Jun 2026 04:43:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 237976B008C; Mon,  8 Jun 2026 04:43:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14DBD6B00DC; Mon,  8 Jun 2026 04:43:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0336A6B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:43:39 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B4839140A23
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:43:38 +0000 (UTC)
X-FDA: 84856106916.11.DB294AE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9E1F61A0006
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:43:36 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Y3K2BCo0;
	spf=pass (imf19.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780908217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rutAQAQbRcONt+TKAz5ivC7J2+sBJj9YBxxqg/7YtKM=;
	b=zgZLhUbv54gCtNyOHXwJajLtQPFPcmNWOxO+G4UerX9lmDt4Av7hpCtpk6c8NIn0ph6lv/
	wI+DFiT25r2cCQTPpmZraQB1Vrouvh//lvbR1oF/udx/NQNhJj9Ox3TBO3R3atxKW1acha
	Ggp88ow3KMJPOTWnOwEmqeU/WRbj1No=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780908217;
	b=fQg2I32BZ9+tLUwobowWnJ9FxZME00j56XdmiPEDrxoG4Ljp/fH1314c470xcxMR+bwbbk
	NcyM9Bo9jUv7BOQM946/OOtTkVqHeeEbkbRQp98UO+q+t2a/vrCHZuYYCQfIQtfm2VlOjy
	SYVit/zg4fOFYT0KphdSKqdX/ONyBUU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Y3K2BCo0;
	spf=pass (imf19.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8DE1A3290;
	Mon,  8 Jun 2026 01:43:30 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 693C33F99C;
	Mon,  8 Jun 2026 01:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780908215; bh=FjzT5RcBQdDdIEoaNoG32miDcUBIMi1hQyHWzkZszv4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y3K2BCo0/UBNqU0k0thuEuhnek8OYAJF79Xh+dFBb16uvJzUHv0//2JXHjFGytIIY
	 ZTcaOYXijTpBDiXvaHTdKouF7fWJCVNNJxmbHGVH4xqTlTynktxZc/o7XT6d1vqF9l
	 2bj0jXSxM/9AaXUe8OGPBioPd65MM7iMjNx4qrig=
Date: Mon, 8 Jun 2026 09:43:29 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Will Deacon <will@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	David Vernet <void@manifault.com>,
	Changwoo Min <changwoo@igalia.com>,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 bpf-next] arm64: mm: Complete the PTE store in
 ptep_try_set()
Message-ID: <aiaAsTnEtwHx9JqE@arm.com>
References: <088f52fd25860ca961449d53f91b214a@kernel.org>
 <5f68f44310d4878185fd5ebc52d66530b99f174c6d04ab1170dc53cefaa54568@mail.kernel.org>
 <1780862659.ccb18e27e916dc4b@kernel.org>
 <aiXVFK_qb54is8b1@arm.com>
 <7f5f7c94601312c1a401fb18998291cc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f5f7c94601312c1a401fb18998291cc@kernel.org>
X-Rspamd-Queue-Id: 9E1F61A0006
X-Rspam-User: 
X-Stat-Signature: 1pn8yzb8ukr57zsd3x9zdraxinifxh5u
X-Rspamd-Server: rspam08
X-HE-Tag: 1780908216-307539
X-HE-Meta: U2FsdGVkX197aMA9OCQd9GtitJrPBvShI5EGZs5pzJ1Y0Oh+IVjxXmq+0TCouSMOXhNahSweYP1aZhiqbqGQCyBpl8zsYh6mySrTpUjIvwCvQZ55o0oRbggE8HXx2nleqNvlZJD9ox3KRYsIkggaCrbS/kH2Z18l6CoUYw18jUJ3rMEJl2CraC5QomCZk1fnwLWIshH2HnXbex65dDtkFzmGf4Kox1v0NPEWPYxlQG9hMnCPLZeR5DwiAjVW29a1d4ol1oK7K6zzF+Q3UYCyfMeVEqlTY1qnO2V4lta4ZoLIMr3S9XT/HIq/okV584ECLv0ZoAzh+zEsQ73B9VQ5BROnkwzZCiZOhXCbzRJABB5bDvJyWukUTZHyYtvhkqNk7D42VBZUMM2CByxe0iVwJ12oHyk9u8kj2qXb15iZybLDSXwwlWTMbMsl5+cbo9ihtjPRUrhRWhVchogC95gqqjHr6zTUJg6F1+cYvO0Qms1A+A6DaOSHdxXwJY5uTEBUMcvhMh4zjSfSUy9aBq39aLljtzGk6OUwtVDE3q9Em9iQ6/sHFo6HYCpArnre0XUl8OMYqC9Z580+A5v7Y9OEiTtiG3frbs1Wf9ZGCCP/CXwpnzH5RnkBA9JbMYqp8y2HqDKsj0U2fBdSpvCS9uMsDOBDAqjUh/vEVJFaLcOJ4zJwxmX9eSdCQLynQG+pKDvufAhAKyraUTysH9y4C7s5mHZLE0suA91iJlNfvgfq+V15klMW19JkXQcluzyQrAd1GdJvtnADFhZF+drGQHUnuvjpLeWYMTfE45k2bC3O9TLqRG1Dwqdm04YQMRBsc0CD+BaP7sbOsc4f60gF9gvNti/5zsSMzc/KD580ffCMgw9+EAl/GTSBvBKpBCB0a4tKlxsHGB2wDAP64yF5+09n+1Wl9L7qhCCDBEoarwIWQwIabfS0FpHx8B8U2xeMoKZLzWO0gS8pmSyVUwpV0OY
 tJjsXACD
 JHoRhPvxU2WhWyxhQ0Kh06E9+ViNYM5L/xhHmSjglR11/Pc6Uu5+qgQZ/x8A3Zau5l5cJBALmFvjgoTXZ/0VJm1mpzCpZtkPaWtahVZ1UN51Uh551t2yPO112qDaQf2I2IEgP1RUmkVITmf5BeASiJ71yMIT8Quuu/UEq9CjOgLnfB+f7dTowmw//jHyEUcTgHu2eFEODE+cfr+DiUDc+pARf5CYTtE9lqEb4SXcuRyJWhual43C+PSoWCwbSkbRhSo++hHgTLy2+DUvCfvRDT/h1816GnDMTRHPtdjo+KPjH78jfG6KWt/x+/Kr1zkuTUFxA+JuWWIHpum34EtWOfarQzmQPxzES8jhH8oWg1qHtZC4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jun 07, 2026 at 09:25:47PM -1000, Tejun Heo wrote:
> ptep_try_set() installs a kernel PTE with try_cmpxchg() but, unlike
> __set_pte(), skips the barriers that arm64 requires after writing a valid
> kernel PTE. Without them a subsequent access can fault instead of seeing
> the new mapping.
> 
> Issue them with emit_pte_barriers() rather than __set_pte_complete().
> ptep_try_set() must finish the store before it returns, but
> __set_pte_complete() would defer the barriers when the calling context is in
> lazy MMU mode.
> 
> v2: Emit the barriers directly instead of __set_pte_complete(). (Catalin)

Nit: I'd place this after the --- line.

> Fixes: 258df8fce42f ("mm: Add ptep_try_set() for lockless empty-slot installs")
> Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
> Link: https://lore.kernel.org/all/aiRFcz78QTZdIHHB@arm.com/
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  arch/arm64/include/asm/pgtable.h | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 3ce0f2a6cab6..3e579c26b383 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -1838,7 +1838,16 @@ static inline bool ptep_try_set(pte_t *ptep, pte_t new_pte)
>  {
>  	pteval_t old = 0;
>  
> -	return try_cmpxchg(&pte_val(*ptep), &old, pte_val(new_pte));
> +	if (!try_cmpxchg(&pte_val(*ptep), &old, pte_val(new_pte)))
> +		return false;
> +
> +	/*
> +	 * The store must be complete by the time this returns, but the caller
> +	 * may be in lazy MMU mode, where __set_pte_complete() would defer the
> +	 * barriers. Issue them directly.
> +	 */
> +	emit_pte_barriers();
> +	return true;
>  }
>  #define ptep_try_set ptep_try_set

It looks fine now. Thanks!

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

