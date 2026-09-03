Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D41FFC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 14:10:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E25FE6B0088; Thu,  3 Sep 2026 10:10:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFC366B009B; Thu,  3 Sep 2026 10:10:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3A3D6B009D; Thu,  3 Sep 2026 10:10:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B399E6B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:10:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 539A61604DC
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:10:48 +0000 (UTC)
X-FDA: 85172636976.20.4E12DA6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9FEF6C0010
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:10:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jygmUT9I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788444646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3JZzmgG9bG+UNAMwOnm5lvihONair7Pb+TlG3wgKfYE=;
	b=xFMVUyihCnd4vGymaMYjH50TLsXQs4if19LBmeWSd4ztt+3joIDyiBkEDfl61kwLzqMRc4
	8qv+T3EwjHEurdsIO7bieMQS9K3SBCAEk2RlFzrUw/AqeLouCntSjpn6a2ws6rNnjYRNlF
	lLis0NMJejR6xrOwMILc0Abdo/idjKc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jygmUT9I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788444646;
	b=5hzk8eD+jhL56LH0C5p6S44yU4j3wMqKTz9rH+1n28JG83CZv1jJaeUwJ5Q3bXrGhEe+6v
	dzDxniH44H0d2mqcZvD9IofmLhDO9tS7YhgUaqQUBVkK1sbrx5h+jeMn0mE9VVA+dWjSms
	Ol9bqNTXRKUWJSxExFY27kPIom4QOl0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BCFC040F8D;
	Thu,  3 Sep 2026 14:10:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B131F000E9;
	Thu,  3 Sep 2026 14:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788444645;
	bh=3JZzmgG9bG+UNAMwOnm5lvihONair7Pb+TlG3wgKfYE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jygmUT9I2xlA9gFXYgsMjQnieC9T4700PPohryUEchjY9qdyFurXttHb/9ScGKasp
	 p/6yyvXWyKak+rj+jCkxoAKJSG2mYUuM3ZfRJT0u0LPIzdpjHRfDUxArBrhmtTLMkP
	 OuzjGv3w8HqZAY9nskFe1nP6D+3HSC5IZl4AeyXMPenTlWaC+n2qzuDxpC5way5ZCf
	 kGE+P/qYXmD0QnB1+vuyXte9h5HZ2orivrgTMbbLj8pBFnhlVbi0X3hkLahkoJL+u9
	 iBP8TxMau6ClWm9iHmKoRz0aYWFHSewpMoeDVtJzpmvJNoj0Gtiqlu/GBow7WEsoS/
	 USHFM1ZcYVHyw==
Date: Thu, 3 Sep 2026 15:10:39 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Christos Skarlos <christosskarlos.kernel@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: fix various coding style warnings
Message-ID: <apl_vDvfWZldRknr@gremlin>
References: <20260903092200.88910-1-christosskarlos.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903092200.88910-1-christosskarlos.kernel@gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9FEF6C0010
X-Stat-Signature: 8syfetmk1dt7mngne17qen1ugnyyyoyz
X-Rspam-User: 
X-HE-Tag: 1788444646-151675
X-HE-Meta: U2FsdGVkX1+XlLFFNDkQFCl5qreyp2wZnVjn41Uxufah2KT5Kx2VfRyCF8or3sZa1VF7TpMCbMdwTRTrzKBN2Hd7lJ1O8KWvasKY85+mEkpaD0DB8zdMK/BY1jY97DDXFOBU4sGpjkQOa+2fvlJ+koz+aILp/LhB/VsE6OMwUu7upKiY5JDHoEg4lPX9FPDa77bSn0A80LAYXuRNhcHdno9YZQ5tlwkw3/7IvVMTxmzdtXgvQMDi9m5hT9FDSivJRui4E7WGeS3WQOnnEbTi/rhkcsDTtlIsEPwxHnzkXwP+lmZdd/eA6xh1ccKpuS9MKP5hUONVb9DPCiY13oTGM7YGlckLTw/LEZqpcmHUQnxpDFmR6JJ6nMfOr9DDindF5bQr5XusUMMTRzdB7Uq0HTwJ/d4o2C4Un2+I48j3MrIG9C86ZBA3DLX9hyKHrPmbvQLpwxTa4J0G+LqF9YRrbSncc7Cda/eZqtJKPLLuwB5RSIzgOuQrPKs4vBe6q0ti/OEoiswg9LGRE3zG7KUw2EI12YguDMWiBlIkEMZiVt2qqRJ6lhQDSOGk+9ChF1dgXSjTPiX1QzOZh9I8EkLgOdVH/GwgZr+s1bje927nA1khM3jHMKiQBIcCs43XYOXYSCUjlyEymSMZGhqtQAX/O52b7ggiGo7EB6O7oeSl76/tay9bxNav8s/LFSQHWS4Yul9iwctNG6LBWLmbGAvIQs8Dg+zkwztiqpyBJsVf9l+oc3SYMACN/jjZnDdzNVcLWIBqdTTfww0LW+ylJDVpBDZ4K+ucWM83lvyU0fFP6FfwmujC6CLAnqvX+Jge4yHQQ2DSUXBXVz450eoJF1floNoUNznD53FewCWOYYKUrn/JEQeGV73dMJAisRrau5HiqU6EoEz9knhQOBB11hAaZQWIN+ZzNscbiyfuWPtd3VICv+9dcLW985AS2/VzMQYd/xJtR8Up91524ED5V68
 RzZkRJiY
 bUepI1Fh15R28sUKpxTx/tRmvNOLB9hyPegBz/TnVrnd1e3Q+d2t2ot6G6KZlj9jNL17smTcL2c1q5ZquX/yjItQ8waF75B+XYiVriKhQzYoEynLNDRi9JATt0mXf/5kst9o1Ofec6LZHYhuO3xh7gGyEjrG4o8phcphZ06zFNX/V8RMpcBpIkdbo7KqsPhNk85IRuRl6usu5q5FYBYegQZJH2nrK+uW3wE9qFjo34V47LcP3foJJhJ+VjyW/XM9z4U55dkwN7oJAH6HVc9h1E7Z1wfcGLHNTSc6uE0WSlhIpaLSwp4TUFeZTtHudTe6yRpZ6IY8nGF8eTYPl0I9dPqworEGomhFq9aT9AposTWd30E8BtOp6F2BfDUk/ZYzRoPDjGtwWiJW+pEUcQ4+dHklalf59C2gsZ1nN3Si7IpBPSCc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 12:22:00PM +0300, Christos Skarlos wrote:
> Resolve coding style issues flagged by checkpatch.pl Specifically:
> - Add missing blank lines after variable declarations.
> - Remove unnecessary braces {} for a single statement block.
>
> No functional changes are introduced.
>
> Signed-off-by: Christos Skarlos <christosskarlos.kernel@gmail.com>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/huge_memory.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index ced400f72d43..371ee8d38c45 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1104,6 +1104,7 @@ subsys_initcall(hugepage_init);
>  static int __init setup_transparent_hugepage(char *str)
>  {
>  	int ret = 0;
> +
>  	if (!str)
>  		goto out;
>  	if (!strcmp(str, "always")) {
> @@ -1510,6 +1511,7 @@ static void set_huge_zero_folio(pgtable_t pgtable, struct mm_struct *mm,
>  		struct folio *zero_folio)
>  {
>  	pmd_t entry;
> +
>  	entry = folio_mk_pmd(zero_folio, vma->vm_page_prot);
>  	entry = pmd_mkspecial(entry);
>  	pgtable_trans_huge_deposit(mm, pmd, pgtable);
> @@ -2613,6 +2615,7 @@ bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
>
>  		if (pmd_move_must_withdraw(new_ptl, old_ptl, vma)) {
>  			pgtable_t pgtable;
> +
>  			pgtable = pgtable_trans_huge_withdraw(mm, old_pmd);
>  			pgtable_trans_huge_deposit(mm, new_pmd, pgtable);
>  		}
> @@ -3901,9 +3904,8 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
>  	 * swapcache folio split. Only uniform split to order-0 can be used
>  	 * here.
>  	 */
> -	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && folio_test_swapcache(folio)) {
> +	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && folio_test_swapcache(folio))
>  		return -EINVAL;
> -	}
>
>  	if (is_huge_zero_folio(folio))
>  		return -EINVAL;
> --
> 2.55.0
>

--
Cheers, Lorenzo

