Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7899DCCD19F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 03:54:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D464D8E0005; Mon, 20 Oct 2025 23:54:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C810F8E0002; Mon, 20 Oct 2025 23:54:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B97688E0005; Mon, 20 Oct 2025 23:54:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A4EA18E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 23:54:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4708D47F34
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:54:12 +0000 (UTC)
X-FDA: 84020753544.13.DB3D02E
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf20.hostedemail.com (Postfix) with ESMTP id 53FFC1C0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:54:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=X7XvrZ2B;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf20.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761018850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8DqkQFzbLJRAr2/bah4u5arNYsIBZs+B2Fh0nUeM2Ec=;
	b=uzE7sTZMMMvlm0e3AgMo6RMRmeoqa+H4iYWlWw+2TeEXkJfhPAetCga71l9kS3NGqDUuOb
	8zuFkOmbNg8qqOsneoprcZseNUGttbj6jxgsfq2OHUbV8Bi3XB44EgOXnplJ8ORPeIZGwA
	JW2DMBx7+YS4Gs+BfTssobrjK5CwtUQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=X7XvrZ2B;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf20.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761018850; a=rsa-sha256;
	cv=none;
	b=YBZ7gdid1lQdTab80R8aVljE22RQjzwUTH3vWWY3mv3R7L843+U/Pmq2BckMm6Nv9Byy4a
	O20c3Db/qp+2YwnvrwRZbCnVO9GwX2u02/PlnhaoHq6fZOG0lwnNxSfGQ5GEMANtbY0xP7
	TyuczUO4MxVSpOwd6cSP0HCghwSZb88=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761018846; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=8DqkQFzbLJRAr2/bah4u5arNYsIBZs+B2Fh0nUeM2Ec=;
	b=X7XvrZ2Br59dvcYj8hU0HfdvrBvWyyiNVZdtwk4RlwhLTQaZ7zM6E/dzkc/zPGkBX+c9g5LKd1E9xfVQgl6YBJyc4C1q8mpHOha+Pr+78Iy0zoXbrGTEjZ1pvxLDZFoOeB9LoirC+UocJjzjjNsw94dqRN3Ke3EuIyRipZSLijM=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WqhQHqT_1761018843 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 21 Oct 2025 11:54:04 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org,  Andrew Morton <akpm@linux-foundation.org>,  David
 Hildenbrand <david@redhat.com>,  linux-kernel@vger.kernel.org,  Catalin
 Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] mm/debug_vm_pgtable: Add [pte|pmd]_mkwrite_novma() tests
In-Reply-To: <20251021024424.2390325-1-anshuman.khandual@arm.com> (Anshuman
	Khandual's message of "Tue, 21 Oct 2025 03:44:24 +0100")
References: <20251021024424.2390325-1-anshuman.khandual@arm.com>
Date: Tue, 21 Oct 2025 11:54:03 +0800
Message-ID: <875xc8ap0k.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Rspamd-Queue-Id: 53FFC1C0002
X-Rspamd-Server: rspam03
X-Stat-Signature: hup9d1ddy44oaot45i5je3qh9jjh49gt
X-HE-Tag: 1761018848-667467
X-HE-Meta: U2FsdGVkX18OX3i9Cfrbh2S0sQouc8PWto6ZVTjmrKFveRCqi+uhcHTuhHGb5RWbrlR8ZfDhbtx+wBvQKsYgLnzKxv69960dhqTvj40u/MEeV5tlGfzMoOvMpz6rbn4Oh3Y6AHXOftM6r3e+yiM3B9aw3sCplrEptAtu91Q6fHoQnlKBpZG3pbPTy7I2gYiyu/xEr72KCuzeAjoyeQQm8Ld22ALQfVPu1qeKaogp6LAGquBNYnaDlrF0XnMeCWagn+XbDIsUjMHWD1xW0odBnX1/lvxC0iV4HwY929Pe4xiIUWFYOa54TP7nFxLzhJGAiMuvrGayNEt7puYfeubgTgFB2KZM8/ljdyHG1d/8jj6hBl9N4lXxh3501TQYOQwRwr+hhBQP/LZEp3wEhK0ry/F3cW2oFpCaPTelxw48/QWUC+M7DbkvEYW522d1mX49l3AqVN5Ytf4XzWjM8rh05xOSFUweT6z3wrTIQguU8YffPh+gCf06OKpRoF0GSYcPris8lPrBuQor3CHoDwV2aONfQllwt/vuW4Yxiop1/UjtZi9h3dgO/v6Aghg2EwhuYLirAMYp4jNs23M9RowxzRgAsRd8RogelyLLdrNGJ5txIoX8t3VWS5VE02KF7if3khscqUbUVMEzQoVYc8lmqLgEeAhGFhL6wral2guQF7hC6MoylcrC4SJEmOw+EDidPQr47kfW+a7IPFt53xPqUEWVb736NhBQTK32n2wQlzJVZeHcVThkPSCJIjrZ2e6dS6eNcnwoVMPb5IlRhda7eBLi38G4nYrZ/qGPblfhF2TKWuw9eeZur1f4ARRAPyUKh3aA777BXbYjzl6XYcDZkNLlhx5p9wxoTyrbT2ORaJLeuZr3fZsQ1RZ2Sccu97XgiOFeqCbsOaQqmQEed28KX22hCmiBQUmQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Anshuman Khandual <anshuman.khandual@arm.com> writes:

> Add some [pte|pmd]_mkwrite_novma() relevant tests.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Huang Ying <ying.huang@linux.alibaba.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
> These tests clear on arm64 platform after the following recent patch.
>
> https://lore.kernel.org/all/20251015023712.46598-1-ying.huang@linux.alibaba.com/
>
>  mm/debug_vm_pgtable.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
> index 830107b6dd08..b9cae1580782 100644
> --- a/mm/debug_vm_pgtable.c
> +++ b/mm/debug_vm_pgtable.c
> @@ -102,6 +102,11 @@ static void __init pte_basic_tests(struct pgtable_debug_args *args, int idx)
>  	WARN_ON(pte_write(pte_wrprotect(pte_mkwrite(pte, args->vma))));
>  	WARN_ON(pte_dirty(pte_wrprotect(pte_mkclean(pte))));
>  	WARN_ON(!pte_dirty(pte_wrprotect(pte_mkdirty(pte))));
> +
> +	WARN_ON(pte_dirty(pte_mkwrite_novma(pte_mkclean(pte))));

Why not use: pte_mkwrite(pte, args->vma)?

Maybe add

        WARN_ON(!pte_dirty(pte_mkwrite_novma(pte_mkdirty(pte))));

> +	WARN_ON(!pte_write(pte_mkdirty(pte_mkwrite_novma(pte))));
> +	WARN_ON(!pte_write(pte_mkwrite_novma(pte_wrprotect(pte))));
> +	WARN_ON(pte_write(pte_wrprotect(pte_mkwrite_novma(pte))));
>  }
>  
>  static void __init pte_advanced_tests(struct pgtable_debug_args *args)
> @@ -195,6 +200,11 @@ static void __init pmd_basic_tests(struct pgtable_debug_args *args, int idx)
>  	WARN_ON(pmd_write(pmd_wrprotect(pmd_mkwrite(pmd, args->vma))));
>  	WARN_ON(pmd_dirty(pmd_wrprotect(pmd_mkclean(pmd))));
>  	WARN_ON(!pmd_dirty(pmd_wrprotect(pmd_mkdirty(pmd))));
> +
> +	WARN_ON(pmd_dirty(pmd_mkwrite_novma(pmd_mkclean(pmd))));
> +	WARN_ON(!pmd_write(pmd_mkdirty(pmd_mkwrite_novma(pmd))));
> +	WARN_ON(!pmd_write(pmd_mkwrite_novma(pmd_wrprotect(pmd))));
> +	WARN_ON(pmd_write(pmd_wrprotect(pmd_mkwrite_novma(pmd))));
>  	/*
>  	 * A huge page does not point to next level page table
>  	 * entry. Hence this must qualify as pmd_bad().

---
Best Regards,
Huang, Ying

