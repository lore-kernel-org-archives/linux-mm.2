Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E612BC5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 18:58:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A98C6B008C; Mon, 24 Aug 2026 14:58:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45A616B0092; Mon, 24 Aug 2026 14:58:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 370446B0095; Mon, 24 Aug 2026 14:58:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 18CB66B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:58:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9532AA2FF6
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 18:58:25 +0000 (UTC)
X-FDA: 85137073770.01.3416B1D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id E801720007
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 18:58:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Zn0EqbIN;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787597904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9iP0OYVCyA9jgeKgRoeawI5DGtD6ETSLXhd9snKsJOU=;
	b=6fMBZN9F037X6C4WVUWdkyzIJ/riaQzHTQoSkniBXOpr0NQG0HV5JP5Cz4saC6ITp948cY
	oEyhWalXETXAtL1lyUu83n/BqndkdudtqoZx+LG1WhVfB+Rkq/cBX/+NJmaWOhJJjEsBOR
	8Ej1juAwS9qNhplgKMZl1FMXOFaJ3js=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Zn0EqbIN;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787597904;
	b=ffZJD8ItHXkQ1jeNzukvxm3vn2FNgNzGRAI2q+eVnPkhftobV/K6z0gnkhKcliWTR3pu7p
	eOub2I7orHskifgo5G9vHFmorXel8ghYM1Ertzzaxr8Wi7F0CIGqfhLhllb8qBxHJxQlNX
	I7CYS1ytGk7PosU3CPnd/rKbGz/eIDk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 59F6A6011F;
	Mon, 24 Aug 2026 18:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF351F000E9;
	Mon, 24 Aug 2026 18:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787597903;
	bh=9iP0OYVCyA9jgeKgRoeawI5DGtD6ETSLXhd9snKsJOU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Zn0EqbINJtWhi+ebHF5yPai8wjnoqI7W81FKrw5+1OpvQiKgGI46XYLDgJ48/JBpN
	 DiR0ODdtsocSDbsG04qE/9514sGzFOHebTwoW1HqJvNw2lc7azXwJWMs8w5ZYeh58g
	 OWcwblGQcxLHRWRwrnAjj+V3UtFQbA9xqBDCpG84=
Date: Mon, 24 Aug 2026 11:58:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH v2] memblock: remove conditional return with no effect
Message-Id: <20260824115822.6e41bd0cacd471a8074623f8@linux-foundation.org>
In-Reply-To: <20260823154840.3793140-1-ekffu200098@gmail.com>
References: <20260823154840.3793140-1-ekffu200098@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E801720007
X-Rspamd-Server: rspam07
X-Stat-Signature: jq5y8ymdzkr5d475iooffddwkek5brm1
X-HE-Tag: 1787597903-822695
X-HE-Meta: U2FsdGVkX18j10fFGh7loYWM4HGF8noaStDHqSqLlHTOySY3gvMTmvBkI+2dfwNnz7MDfNfI4f8t9/h8AVjzFl47tQiuWtZhxDqkwh0g4pskNy/yackOGLT/dbwh6P7ZLnZdtxPmPDQxS00oFWs68bAApZOpsXcVG70yti09SjPEMNB1pTGA2gcWKaTkU8okpP37o6eIPPSJ+wXXhbLiJzsmuWcwDpl6Kgf7wCZ4HifLA23ycxx4wfDHpjztNwNFkIRrzRBmKIsI75WJ7ccRqUU24p59RmyOBK6L0nBvrN4ZtGkr/mwPLOHOuU8cHgUClkwsUJYOj+v/z0i2PfvCA9Myp7PFykfagHTxkLWYoIB6HzWQuU2fkJI7StzjlBg3lTknEgTfQenboUrTiq0CBOYq+irc0Ap51H0ZyMN8hWhwebF+sXsw7ckzhRLRxu75Kau0fA5cEegoo+M42ori203oqP4SxqA0tWiTVSl0fEWXmXsA7hlAIn5/Cn114dpQsIb8k2ALVF2On9NXCGNNIEmFGfrvS2diIRQFCRcPdzfzixOClZqbIxczGAM4CrNFARxn0e7kbsLT1U0A9gwXxJruUFBB02gNSsrbiFJ4twUCeOCSi+hB9Yd7BcnAWUBbqJTSeCtbe0KBqqchOkeWpFdt/Wp8mhKNFjUsE1uPtsADxFlQctSr+oYDwWbqB2I4QUoEcDFCXtdBbkKrzYgFF5nTSP6BCW1HqiPpL4BlQJUy3frkpisVH76E+vrQvdaDPWDIxw80ngJaNkFvxIJaFETPCkWOuxFkyXMn7Ay+JGv7bNLv0KgZPodXd56ZDcKd9uVuF6ST12Fk0Tw1/usev5n8wiqh/MpnbF6wqEJSRf5XVs1xRooOss8wb15L7WrdkOQm3p9LFUjSVIWZyutJnrXKoMn3tmdUkvomBH1HrIxVURQJYK2TTCgEhk182KsndQ/sm5Ktnz5QBVBsziU
 dTrAlZcm
 FiotxylAF49EbfM/MSk5/iw3GRDWxCBc3faESwQPkjGSGFDTs/bBavRLbIrO52z8HEDkhVwQVrTa1S7fEujSqj8IfcRnnjECMY5FyW5SclSTK5GiHbyS45UDTxUFSKVCnCI6I32b0zc4PzKW53/+ime1lvUMVl+2CD2DUtuPyL1EJrEya32jblu3Xyr7/XoiFIctWSnrL+9iWXQ7iE51J13wMRSQ/UrfMp+ZgR/yOjMFTT7ZzBycUgXH1qhowDAu9eG944iJyYpgx1kUifGOF3dL67zzacpeQdNI0+FkBNDeyR3bmmPfKhrngtfvXq6NLO75o4Ap9AoP4O/ATDjs9cnNXYlchYx8MvcJfxV3b9+zFUb7GrLENZEAphvGrD/KabIB8WUQLjENz/5k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 24 Aug 2026 00:48:38 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> Both branches of the check return the same value, so the check has
> no effect. Remove it and return the value directly.
> 
> This is the result of running the Coccinelle script from
> scripts/coccinelle/misc/cond_return_no_effect.cocci.
> 
> ...
>
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -2613,15 +2613,10 @@ static int __init prepare_kho_fdt(void)
>  
>  static int __init reserve_mem_init(void)
>  {
> -	int err;
> -
>  	if (!kho_is_enabled() || !reserved_mem_count)
>  		return 0;
>  
> -	err = prepare_kho_fdt();
> -	if (err)
> -		return err;
> -	return err;
> +	return prepare_kho_fdt();
>  }
>  late_initcall(reserve_mem_init);

Reviewed-by: Andrew Morton <akpm@linux-foundation.org>

Your patch led Sashiko to suggest the addition of a round_up() in
nearby code:

	https://sashiko.dev/#/patchset/20260823154840.3793140-1-ekffu200098@gmail.com

