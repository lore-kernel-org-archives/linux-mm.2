Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6DC6CD37B2
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 02:56:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52BEA6B0088; Sun, 10 May 2026 22:56:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 502BE6B008A; Sun, 10 May 2026 22:56:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 419016B008C; Sun, 10 May 2026 22:56:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2EE696B0088
	for <linux-mm@kvack.org>; Sun, 10 May 2026 22:56:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AD72A1C046A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 02:56:02 +0000 (UTC)
X-FDA: 84753624564.22.431382F
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf18.hostedemail.com (Postfix) with ESMTP id E7B621C0005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 02:55:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uYHZXYuu;
	spf=pass (imf18.hostedemail.com: domain of feng.tang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=feng.tang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778468160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0upIL/r5PlHA2QmAdZKfeZ5Wg4iPfn0PljTHC25lCFM=;
	b=VBm2GR1rOADWXE1wEQ1M9HBBJPNZp0f+AgL6CInuC4cn0DlRqDu9ZUhGH6I/qUc7u814Z3
	k/OkqbSql0NJwI2E1j0vQ9JZ9YQMyhp0GiagjvW0CGXqb3MC/hV/e/tn+qwAyWA677hyCT
	7/IJX1MfjWEt4POaxk9LepjFjY5JRZM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uYHZXYuu;
	spf=pass (imf18.hostedemail.com: domain of feng.tang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=feng.tang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778468160; a=rsa-sha256;
	cv=none;
	b=iJWSSW1Lnuz0VPaw+CJt4zzxvh7fxSp22kZcPxTliZ4IK1ohdORm96YFPFYJOLbQlvKSvi
	rKPgbSJ8aleTn9zOX1cxTr87g1tKxigsvC2h25NL7Io3HuefJOZY4+z7EhNhTuHXAvMM3X
	WgubE8ta4x+dwogcjJSOOCltK/s8/8s=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778468155; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=0upIL/r5PlHA2QmAdZKfeZ5Wg4iPfn0PljTHC25lCFM=;
	b=uYHZXYuupdm71JRKi5At4wOfByW6BFKCxsGLSV2iMcgraoD0O88djuhrZ+NRqvfct/ia/eyCzgOX+lTgQO0n9o68gVojs3N6C1BpDgSSWwFASPRXgy8C9qLeXMIfObVV2AvLv3rgE5d4efrfqQOtkAUdBV1WIORxCKUq8VmN71k=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=feng.tang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X2dsRpW_1778468153;
Received: from localhost(mailfrom:feng.tang@linux.alibaba.com fp:SMTPD_---0X2dsRpW_1778468153 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 11 May 2026 10:55:54 +0800
Date: Mon, 11 May 2026 10:55:53 +0800
From: Feng Tang <feng.tang@linux.alibaba.com>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com,
	Ard Biesheuvel <ardb@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Liz Prucka <lizprucka@google.com>,
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v4 02/15] mm: Make empty_zero_page __ro_after_init
Message-ID: <agFFOZvRHMWCtPHm@U-2FWC9VHC-2323.local>
References: <20260427153416.2103979-17-ardb+git@google.com>
 <20260427153416.2103979-19-ardb+git@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260427153416.2103979-19-ardb+git@google.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E7B621C0005
X-Rspam-User: 
X-Stat-Signature: onnw43m55kwggo5fzffm9ec637dmyf1p
X-HE-Tag: 1778468158-895048
X-HE-Meta: U2FsdGVkX1+kBL+o//4kRKOnip5qnvgsN9e2OB0n7XSSe/35cj3XTgUGa5Kaxjs0elZVuIvaLvDtVHHy//uzkPSsyDMHYnMqz0wqjrIIrDamr7mgJotYOzlz1LQ0bJaVE8lKV8fojd19ZTr19NuCfJONIFyP991NhGVyyciH/TkJ7vP5U1QQ2jq7qCnVP3ofdDlPobH8lM1Ezvf+WTuwZLxuE2O4vhHQGP/p339XfV2g2KsOUrDL5NdtFycdAVXG3O3GanK2JMaHJGxbUuBIp9Hox2F0dVfkbqT0JUvUWgcbF3Ny2D61MkPYThLuXks65n+OjaJsBokuj7u00UVi1Ya+LvzfnN+/sGZ4qrpoxSpKZaDsRqj+/9xvBVfp6CkWYxlmF4Fte7NXGR2DF24goNLnasHEEY6YgEvD9307ujisHBxvWRnUXn/kbp6K1FaeaPjzIsxU925jKgDFZ5fqKQaJi67KdlDBjrUlw/GJVzKKtIk7uMzbKOPwKN84L6fWiVImBHPCgzsSJ6FzwKg8I5mkek7rKE3LExyhzaKuHcJo8/s53CsQ4d4KFoH2szBNLQ4S6RBe7CCOkpxmXsLATiaxeMRt9f4lHEaNFDknXLxxARoQ1/I3dzylkwWYZRw85Iq1uX6hA3p3uIaN93bWMW9xZJJ93jrFX7lpJFja3uD21Q9otvPLvMC24WYmtuVyoAYHR/JwIGjUC+tcYwBFIf7ntYDyuxGv+zZ729mgWU0Z/M1mOMdXDJTklyn4UZ0Da8s41OHIO/ljfUT3GM8W6q1tm0kXfOVWxoLzmQ60MTagIQfjbehcjgs3A7csiUnn6R23oSZOnwDsm3XfGfGApWn2eVb31d76Ii2Q+i0XcG1UxhpIatwiruSaS1U3KIXH9b9r9lDE+s/XnT2HKNEq4PPCnOD0PU5aoPcjS+xU4tOzgArqEpv7ow+DmQVhgfngWU5VNVPZH0achoAzAOg
 2AGqQpoy
 SK2TeJKryC/YIqH5BUOtlFzr+PZfmowVn3palGOFc6eLSSGFuAyY1OqE2qV2qpmuurJCASC7zhm4/VtE90HUygJ3HvcB0eSzgTwptfsTq2rhtmk22vhUqcPphkslEiw6am6x63zlfs4/IkWylMJBjYVs2iRz1UqeIZa9LWkjP4EwLhI9GPJSQbcDMP6x3ccxRJFnmKEU0CCQcqcV2TSSLttYfDnc7hzayJTDncEHKd+Fu6HQoWL7KlJISebjN+qwB8Jmlbh232kf2CVl78HdOMSf0watnmn1G+P94brqgxwtgbXHtAh2U+jJCgQCKSi2svnYZTdxg2C7M4tKEUGbEF+1dN50m0cN0BnqXfb8SojGKMEha/GMrTfV/fu1gL30EsCoUKDZg57X4cg0zC6p6jAOEW/ptcnF1CMJJhUDQvwZHVBSdJvR+YFUnl+vLU9A9m+C/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 05:34:19PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> The empty zero page is used to back any kernel or user space mapping
> that is supposed to remain cleared, and so the page itself is never
> supposed to be modified.
> 
> So make it __ro_after_init rather than __page_aligned_bss: on most
> architectures, this ensures that both the kernel's mapping of it and any
> aliases that are accessible via the kernel direct (linear) map are
> mapped read-only, and cannot be used (inadvertently or maliciously) to
> corrupt the contents of the zero page.

Reviewed-by: Feng Tang <feng.tang@linux.alibaba.com>

We did hit the issue that zero page got corrupted due to non-kernel
reason earlier this year, and it took us weeks to track it down to
zero page corruption and the final root cause, as it randomly happened
to different user space tasks. Thanks for the patch!

> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  mm/mm_init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index f9f8e1af921c..6ca01ed2a5a4 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -57,7 +57,7 @@ unsigned long zero_page_pfn __ro_after_init;
>  EXPORT_SYMBOL(zero_page_pfn);
>  
>  #ifndef __HAVE_COLOR_ZERO_PAGE
> -uint8_t empty_zero_page[PAGE_SIZE] __page_aligned_bss;
> +uint8_t empty_zero_page[PAGE_SIZE] __ro_after_init __aligned(PAGE_SIZE);
>  EXPORT_SYMBOL(empty_zero_page);
>  
>  struct page *__zero_page __ro_after_init;
> -- 
> 2.54.0.rc2.544.gc7ae2d5bb8-goog
> 

