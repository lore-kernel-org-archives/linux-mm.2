Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACB93ED7B84
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 07:58:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F332D6B008A; Tue, 14 Apr 2026 03:58:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F09266B0092; Tue, 14 Apr 2026 03:58:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E46546B0093; Tue, 14 Apr 2026 03:58:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D54496B008A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:58:05 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 59D681A048E
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:58:05 +0000 (UTC)
X-FDA: 84656408130.27.896180F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id B77F01C000E
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:58:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JqfRbvLT;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776153483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dIJyZECg8iTObfZ0uJTZY1ud8JKptMmWEw9v4pixmMA=;
	b=8Bf8UD2w2sFpp/1rhyWmyDwM5Yl7TnDuTQjU+TsGQG7+EWX51xlrtzUbzB9pDBsG43vxDI
	rbIOR5DIH6JLaFJBC7Yb92ZkPOAC1vUAftx/vohzAhZKlAdBIY7gZhIk02WaOVr2d3uwd8
	+bCvZru96wWJgpLXuJTcHy1o8Vb4uqQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JqfRbvLT;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776153483; a=rsa-sha256;
	cv=none;
	b=Irqtg0y7Kdp06rItYKtGP8Wz+sy0iYeHeDe2vMQ8OuoYmLZrXiXe/VLQPEOULT3Pb1wsn0
	7Lk87YPTd4p4H+6or/gKuKI3+WR+syri4eCEYeYHDBoSgpb/5a9p42Z4Pu8mLtVD4fC+tW
	E2R0aNR/T5bN8dnf09SGpAwGfTFjEKc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 23C0F60018;
	Tue, 14 Apr 2026 07:58:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC63C2BCB5;
	Tue, 14 Apr 2026 07:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776153482;
	bh=Wd00Fb8v82agFo5MqfTVM6OTKpK8OL65duSpxeBGSeA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JqfRbvLT4hCuBCnA5MJjWfqA38egZlzZmFDR4OF6TsMAF+DVLvQ/nDm69oJPQIsne
	 ck9NeyFNqoNOeiQbMUIIQKQSufxjbTz8vAnaGUZL5aDu2Neacw78Z25W+MEj13WDRO
	 tIG9OoxV88NNbjNfVTa5tTLjFDMmtHfFi/mIXBQrT9TCRyiZMm2Kw2KIDvctS0II4V
	 CWDyM2/afqFAdvj6uA3gsdYSKez0yf9Cgq9JQDtCLW47H1Z8FDSXS36T95KNu1YCTv
	 6VXUOwgBA6ZnlZ0e+q7NHlyPrXutQ2XPb0wPpkrLi4k2vKvVk/qPyNDyuUKUMqbfmi
	 7zbVmYKzbR0OQ==
Message-ID: <453f7de1-1ed7-4785-ab95-5d63dd4a3499@kernel.org>
Date: Tue, 14 Apr 2026 09:57:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/pagewalk: honor action in pgd_entry and p4d_entry
Content-Language: en-US
To: Cao Ruichuang <create0818@163.com>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260414051854.18487-1-create0818@163.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260414051854.18487-1-create0818@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B77F01C000E
X-Stat-Signature: gp45zbd9b1ejoa9gjarfd89xh9w94gb1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776153483-706241
X-HE-Meta: U2FsdGVkX1+81G23/9D+gkByUfxmG2ytlQISejvfgSElfN1dkVYsYvjiKWtK7v6BNbkm4H1wpw0GzCuFXqaZJP8KmDfPuuMMc4fLPiCJ74DV5mlkHmowuCGPC+nbURU/qxlvCLUW1Kc5HzDjQND8rIKV5bzoKvKZSF6LtnkzjnFEqkg8ue0eDmHIXWpU5+H4SwNbir1o04Bf+qr8dt3FwEFy6/RWGyzzJXq/4dnCgMLi1YuWUJV8CB8wOyg4Yt/IeuxDKUrKcZqpSJIgPTdHnxUmIUGYCsjwmFW0H/RiV8Ywq6PJ5CAqbvmNmERxGT1p/c/GLIRwWfLBi8AmV9zR8lnQ+fHK/QUqPW4jts6bmy0Z0VI48aWliphMYzDYDJDyxNjWDzwL0VWSq+yp5hdUpHibIUDcg2E8JPD10poYG4rH/mEj1RuPwwrD7obOleYhDiqkn2qb/XGEFZJsOr6vOhpa0T8wCd4AyG8A20eb7NhFFHVLPi1QgPqItP1ApnY3wc+Z+z57yPu0X6Yp3U4QISqjgGuPhAEGmtEBiyDWcQSlStHftmgGax8r2fP+PavJupyvxFY/CN8UftFXSJ6naeinYH9pDqKg67h8ovXpxRMpxXoampdEPgCQ3WsEgpfGJlyHih9PXZknsfA+YC4j0dmbE4sfmI6gk8ji4f6vlLn42cCCphIfAPmmx31UYTZ9LS2y6QA0AZsAnE5jL7dizL4HdFBl5Or3I4aN9bsexVSDtbKJTg04VGjtkGLdr9Eibbu+lQQOwnaiLufhAJaiESVN6Yz6iwNBo8Gu0JzMv847iAJxP4IUjvEdnx6l+7FsWfAILDlTnwzplzrPze4Ei347afGCFyg+nb/6h/aEA2mSvqmBDQzg/fy5U/qmHWpYU371EGUVMMMrJ8BAmgRWaMDtwOAbHrRtntJK2+alWhlni9qUxJBffRe2YyJTSAXbaooIPM6kh4HwzmgUt9e
 H06Ych6j
 tisuESZPfhIlGh22/ppO6QnaJw1JbvfCruVpMF//keHvuj1sdeG6/jmfAvoWujVeZyueJ2/93xChi43/Dk+W8RDk2sjjYkCiUlRJu9LxLHinVm8l4rujr1OXGTdw+j5PUiQgM/FaoyLK1rSuiIKqdxaOCqUc7EvRetwzOdNQjAZbLHiWyVOmyt7qxsbDCxeGJCfVRGu7tB75upTclfeDgD5HmQf5geWEd0efKc4ZpBlqbyuudjUwhxZUDznRFlI7sPkalxPrgK09NGZuDtdM1eQyA8NX13udKBX0H9YdZQU04loXs/pbfYblCCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/14/26 07:18, Cao Ruichuang wrote:
> walk_pud_range() and walk_pmd_range() reset walk->action to ACTION_SUBTREE and honor ACTION_CONTINUE/ACTION_AGAIN after invoking their callbacks, but walk_pgd_range() and walk_p4d_range() do not.
> 
> That leaves the top levels with inconsistent callback semantics. In particular, ptdump sets ACTION_CONTINUE from pgd_entry() and p4d_entry() for leaf entries, but the generic walker still descends into lower levels instead of skipping the subtree.
> 
> Initialize walk->action before calling pgd_entry() and p4d_entry(), and handle ACTION_CONTINUE and ACTION_AGAIN afterwards just like the lower page-table levels do. Also update the action comment to reflect that it applies to pgd_entry() and p4d_entry() as well.

Your LLM has broken line wrapping. But it's ok, we're not interested in
patches produced by LLM reviewing code, with no human oversight and
understanding. NAK.

> ---
>  include/linux/pagewalk.h |  4 ++--
>  mm/pagewalk.c            | 20 ++++++++++++++++++++
>  2 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/pagewalk.h b/include/linux/pagewalk.h
> index 88e18615dd7..d3f84781792 100644
> --- a/include/linux/pagewalk.h
> +++ b/include/linux/pagewalk.h
> @@ -94,8 +94,8 @@ struct mm_walk_ops {
>  };
>  
>  /*
> - * Action for pud_entry / pmd_entry callbacks.
> - * ACTION_SUBTREE is the default
> + * Action for pgd_entry / p4d_entry / pud_entry / pmd_entry callbacks.
> + * ACTION_SUBTREE is the default.
>   */
>  enum page_walk_action {
>  	/* Descend to next level, splitting huge pages if needed and possible */
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index 4e7bcd975c5..4268e08eabb 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -261,6 +261,7 @@ static int walk_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
>  
>  	p4d = p4d_offset(pgd, addr);
>  	do {
> +again:
>  		next = p4d_addr_end(addr, end);
>  		if (p4d_none_or_clear_bad(p4d)) {
>  			if (has_install)
> @@ -272,11 +273,20 @@ static int walk_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
>  			if (!has_install)
>  				continue;
>  		}
> +
> +		walk->action = ACTION_SUBTREE;
> +
>  		if (ops->p4d_entry) {
>  			err = ops->p4d_entry(p4d, addr, next, walk);
>  			if (err)
>  				break;
>  		}
> +
> +		if (walk->action == ACTION_AGAIN)
> +			goto again;
> +		if (walk->action == ACTION_CONTINUE)
> +			continue;
> +
>  		if (has_handler || has_install)
>  			err = walk_pud_range(p4d, addr, next, walk);
>  		if (err)
> @@ -302,6 +312,7 @@ static int walk_pgd_range(unsigned long addr, unsigned long end,
>  	else
>  		pgd = pgd_offset(walk->mm, addr);
>  	do {
> +again:
>  		next = pgd_addr_end(addr, end);
>  		if (pgd_none_or_clear_bad(pgd)) {
>  			if (has_install)
> @@ -313,11 +324,20 @@ static int walk_pgd_range(unsigned long addr, unsigned long end,
>  			if (!has_install)
>  				continue;
>  		}
> +
> +		walk->action = ACTION_SUBTREE;
> +
>  		if (ops->pgd_entry) {
>  			err = ops->pgd_entry(pgd, addr, next, walk);
>  			if (err)
>  				break;
>  		}
> +
> +		if (walk->action == ACTION_AGAIN)
> +			goto again;
> +		if (walk->action == ACTION_CONTINUE)
> +			continue;
> +
>  		if (has_handler || has_install)
>  			err = walk_p4d_range(pgd, addr, next, walk);
>  		if (err)
> 
> base-commit: e39f5a33eec1a4ea03358d82e861d6bb0a426b17


