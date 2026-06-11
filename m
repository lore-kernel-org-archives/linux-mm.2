Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8FE4CD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 16:22:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57E036B00B3; Thu, 11 Jun 2026 12:22:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55BA96B00B4; Thu, 11 Jun 2026 12:22:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 443A56B00B5; Thu, 11 Jun 2026 12:22:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 363426B00B3
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:22:38 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EE132120764
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:22:37 +0000 (UTC)
X-FDA: 84868149954.26.64B05D2
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4F7D580004
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:22:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=zx3pB8WR;
	spf=pass (imf30.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781194956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1DBXTpnSQTN1lQhl3/mI/26yvza/QwG2H0WdOd5522M=;
	b=5LdDhaF8bEH2bL5qLU6kL/aRWA6vaJtbKNmFHQlAd9/GxZS+RCv2M9pxPWhTc+9U/YVrfd
	QtSCNjgaEFNByIEOcF1dwb5ar3vr2Jqy5Lr+OLY9b9nQd1Gq3+Z/T6/1ImIcpoRE4qShxU
	D4yvAwiSY2RuU/JMDOFdfLuHkF4y6z0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781194956;
	b=r+ihet2SOr45eTbbmgqnkmmCphY7G9s/HH3pK3jnCyqcxUdD6T+jERGDAQ6sp9zz9V2d/g
	tbSdihwtGCNkIUw33gMOp9imkv+M5zczfEv9u0prJLDFd8JjDGgHWvBw6FCe9OMyk7msLM
	bpCIc1F0nNcHbHiw76G3t5L2v0BzVYI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=zx3pB8WR;
	spf=pass (imf30.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1DBXTpnSQTN1lQhl3/mI/26yvza/QwG2H0WdOd5522M=; b=zx3pB8WRL7XeCfajXYOgzonQ77
	jGiiH65o+PZambK6+kA2Oi2vfNdN7/62nichkav3KSywe1ag0lTA9EM92pJNjbDLQ5sJ8FnJk5ELf
	rZG8e5Gkrm4yIlcjhtOJPnPSDtFVjgAALqPDBi4n63Lcmt+4TbarI7ZOKVVZZ7JPYVx24gsrjKfCM
	irLoCoUFr4EaODXVk7h4kc0p2AvMi73eI5+nnOICbuy5thD3KuMjGLbBFPI2BrVN1mgK50bIrfp5t
	EbOzLrtf84UO8mnWjJNX5bQWz9W9u2/df5/3JXCYU4iMXKZpwEBeYIE3+dyEy4+sdSvXarC1HC22W
	ebAW125w==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXiAr-00000009knG-3Ptq;
	Thu, 11 Jun 2026 16:22:33 +0000
Date: Thu, 11 Jun 2026 12:22:30 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>, 
	Andrew Ballance <andrewjballance@gmail.com>, maple-tree@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH] maple_tree: remove undocumented
 CONFIG_MAPLE_RCU_DISABLED macro
Message-ID: <5nsex43djbj2l53iqb4pqctzkkdqtcwpfemewhreuveahylvip@sinkvi73hmd2>
References: <20260610220905.99860-1-enelsonmoore@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610220905.99860-1-enelsonmoore@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4F7D580004
X-Stat-Signature: ftafb193fbid964gxi7adcxusj3wirzz
X-HE-Tag: 1781194955-993439
X-HE-Meta: U2FsdGVkX1/AegT5jYQWmDaDtcb2QFIZP6CqUCie/tzg1hjfit503Bu92t/HVApe2MlktH/rH0ZHCUpdoJLKn3TOR8nMIs2OdUDlj1nyFfVNjI/7qadTvOJga7Ec/VbttTZexSUtdo+Qx/e2+cSjGnSo0h8i93jAFxNUIkEk2VmHQ/cItAFBroaksIB8Q12YYAb6tUHvz5F208m8JxSxFRs3+kS+jTxogk2uiejBnG86uvPsyb2zkqloHnH7ic2VWErr2uzQJK2hSp23Y9KIL8TOyTqn5nOUFpVzCytmiAzWqjP0j3tFLAPGXEI2prRMa8EmsnxIuztPIpLEYr+FC5W/v3YYqysq2z7NcJsp5RJ8wivLoYjHPcmfFsZ3wVFxV1KkXIu3CVZsne+kCcnp2zMxOJcPulV6p7h5/cTi83/jnzp6wwkxswqBHV5LHuY++ZsM+ci8IKt4REsStDgVMUILkIxRY9vGH4WhpmwNSX8PwL7Ul61jQYJxEDXGGJ1BG2tSCYbn0U+ffsXzY8fAeaseJeCqsbBZc/UuXn+AEN9BPFZFLY/TwWOlhv1IoBjmX8pFV8LSyMplE3FwdtIvn1PoNUTF/+cvZvI8vRLUnETt0emqkjbndvwJ642TOvlJj0tpS10BPo4EAizhdUT5D2pTq9XPsVNA9DS4NBVJjz+3O6JEz7TplZZMZ65Ol1QoYCfLAWg0SkB1xFNcqqBTPaa3YM2mPnnqmikTx/TzH8CU39alPhu/XQCchSEhwb3Dw3h3lVhiYc2LYDmW3Ml3Mi9K++Mw4W7DB2MLIKWHqN8CywMY2xYRg8yiBg7LZp87GDLLO5XKSFxPf7AjQO3V1ek+tjhR92KHiy2dyxwxHfBk8YJYXeDaMU6zdaiwr1QsMKfn0PDGGdiGawNRiy/E/0K8hBGiSjHYJFRQPWWwlLbh+RmUX4aXrD9kb69BN1XKlDA6LQ5s1ZcuCRPQVaq
 PII4ukwL
 2T4bD2BbXClC6NqXqEM5wNjyEw6N3fn6lHBB052pvv7nM0cC6oWRVvfdKBZdQbUCVGkEcp0KNPvnkEDlMuNoky123IovRI3MFxmoasUpx5dE7LgB9zKil2AZUTTDLzzY0VA7uAUcc1P8T+rmLYWfbq6JmuO8xRBw8+02e2LhO/9Al+xZ7tJQLRFSLWqoBDekxChZJ7JVD2uI5bfK7Cr3VaWLpVR4arqMZn5gNGfC11ZEXpRh8H6ljGanndFMhIKu+HxFBgMHusZl0tAp1H5Fl3u6JXtQT0f9tGQuLEs3xApOaFtX+1PTIA1NbSlgRSA95EbFwa4P0gB2BpPo4cLj+/Rrkd0OGRXjCi3GiNoYgd+awUGcix0M184tbSJAnfkzDLlK6OV268KJ3Eaknt6WvkA3GseJwVaK0ZoofhXg5DaWbYvefkeAm4KrImQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/06/10 03:09PM, Ethan Nelson-Moore wrote:
> <linux/maple_tree.h> consults the macro CONFIG_MAPLE_RCU_DISABLED to
> determine whether to disable the mt_in_rcu() function (by making it
> always return false). This macro is not reachable via Kconfig, despite
> its name, and is not documented anywhere. Remove it to avoid polluting
> the CONFIG_* namespace.
> 
> Discovered while searching for CONFIG_* symbols referenced in code but
> not defined in any Kconfig file.
> 
> Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>

Reviewed-by: "Liam R. Howlett (Oracle)" <liam@infradead.org>

> ---
>  include/linux/maple_tree.h | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
> index 4a5631906aff..1b3014377105 100644
> --- a/include/linux/maple_tree.h
> +++ b/include/linux/maple_tree.h
> @@ -11,7 +11,6 @@
>  #include <linux/kernel.h>
>  #include <linux/rcupdate.h>
>  #include <linux/spinlock.h>
> -/* #define CONFIG_MAPLE_RCU_DISABLED */
>  
>  /*
>   * Allocated nodes are mutable until they have been inserted into the tree,
> @@ -864,9 +863,6 @@ static inline void mt_init(struct maple_tree *mt)
>  
>  static inline bool mt_in_rcu(struct maple_tree *mt)
>  {
> -#ifdef CONFIG_MAPLE_RCU_DISABLED
> -	return false;
> -#endif
>  	return mt->ma_flags & MT_FLAGS_USE_RCU;
>  }
>  
> -- 
> 2.43.0
> 

