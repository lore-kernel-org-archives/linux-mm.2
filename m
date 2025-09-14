Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2B40CAC58F
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 02:23:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B3B68E0003; Sat, 13 Sep 2025 22:23:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48BCC8E0001; Sat, 13 Sep 2025 22:23:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C90F8E0003; Sat, 13 Sep 2025 22:23:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 28E1B8E0001
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 22:23:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DEE1FB7620
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 02:23:15 +0000 (UTC)
X-FDA: 83886258750.16.310F3BF
Received: from r3-19.sinamail.sina.com.cn (r3-19.sinamail.sina.com.cn [202.108.3.19])
	by imf27.hostedemail.com (Postfix) with ESMTP id A8C414000B
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 02:23:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=Xvmd+d3X;
	spf=pass (imf27.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.19 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757816594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=soAVKL/6gGlvs7NpC/kFx/027hfgadBenVwkVqhKBAo=;
	b=XqegcjU0Oz60MfdKHvrfBsIDu65vP58+OJKhuTr+8r3HeN5UINOtmKutSA+rbp2UwG7Jj2
	/LrRhlNakGPOOjLFTrvLCUQmpjvITiqfpESDo8PS2Gm3UXzlj459ddNlAb5xZGOwf3rqRS
	vrT2vV7eHFr7quekUbqXBwOjOh2JmY8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=Xvmd+d3X;
	spf=pass (imf27.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.19 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757816594; a=rsa-sha256;
	cv=none;
	b=yyTaZiKEBJdopDibFpzoZWQzhedJbcv77o9hyow05f/JC/kGGBmQOohenaVPN0uf9/rQ6X
	Rr+T8ZnXooyrMI1/nVW4xOivaGVRNUAStZc74N62RdDtfmCEAw4BYJCCQ+Y1jMxd7uhKjL
	gZBRFz3Lk4fpLhSLoz0B1XB+vZ+oUGM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1757816593;
	bh=soAVKL/6gGlvs7NpC/kFx/027hfgadBenVwkVqhKBAo=;
	h=From:Subject:Date:Message-ID;
	b=Xvmd+d3X6s0AHpAqjAYnEE+pciecdGRQf49HY7laefxad+htY8SP7Dd68rET3O+Sc
	 veFvvOtpW0UhsE7IPImRpZpIidNHP7znVG/qViUj3Xy4ACx5nuaxCogX2G6GlqojRU
	 IaBL4Pg5GrEAeCFr5AxX9ME5cCR5vlviByXGvZ2s=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.58.236])
	by sina.com (10.54.253.32) with ESMTP
	id 68C6270A00007BBD; Sun, 14 Sep 2025 10:23:07 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 9737014456621
X-SMAIL-UIID: 2DC8645A57844B7B918BD48ADEA49B19-20250914-102307-1
From: Hillf Danton <hdanton@sina.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 01/14] slab: add opt-in caching layer of percpu sheaves
Date: Sun, 14 Sep 2025 10:22:57 +0800
Message-ID: <20250914022258.7062-1-hdanton@sina.com>
In-Reply-To: <20250723-slub-percpu-caches-v5-1-b792cd830f5d@suse.cz>
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A8C414000B
X-Rspamd-Server: rspam05
X-Stat-Signature: mfmu6r13fs4jocr8g98g55rnggdf8tfi
X-Rspam-User: 
X-HE-Tag: 1757816592-4637
X-HE-Meta: U2FsdGVkX19bJjMY706dWqYB38WAhVCdmaHaZ1q5o7ImZbpGUACu92UMD8IIXza7tzrDSmwvGbdPiz9P6LBZIGVLLhRyPRCsM1UGEUqJXinVo16aowsdMVY9v5X9WCCx9QSM++rT6Zku/0/V+emJGA711INER5U6lpcIla00R3PyKrxyZrCjGbywPSfeil4vl3bAbnXpm/mnrmC/HguB5V6eb1UccPvh566JZJdm6Pp2haT8ZPKYbEHsVjjpj9OMqy6WSePj0HNkqst8kAn1oyFMBYa2vCdLnAuUyvtnqXYe418Wp1T/1EikuSPL7WMARK2xG99zQIQCvepKaJ/gqOhTE6GfTHPtbH+vnoZ6w5/M3lmdPDWYCIkJzFDLa3sVti8GFjJmFeurXWHH966nUmkPtBmPJwakMCsXxCg3tgKLE1T1IALZ6juraJmlGOKKOS4Q8E2viFQ3y+xlm50N/H0clRPzPHEq2dSaDN5CZM+HKU920eHD9myTyw+O/iiG0x0BG+I1clMR1kSeQEm9qtX1zYxIsJvrVW2JOWOX/0/gUGVOavT2PF/QMKYk1wFHGijv/EyzModPEWu8rxnHfxibh4UWNe9qLzN6kKSsxjJvfuamZIACaugI5gip0f8nYgNpfRD2WHFt2oGyhho4Q/SBeSPtn22cIG4eD1NNAnFrNUP90x7OKvHPZWGo2XKOUdR5NjgWGd4y4yYCEref1As2/w6dIK6kM5EQNVA2foX608VuhYG2GmCstFZ+labq9PFaKSmVcoa49Fvr0KsFhsieO875CZQeT4lJB2wNyf873hqcUdfLcwa9etCzEKAxU4iZ/7Gs14QGNn32Otmy96KeMHub4Lp7IB1Wm/gfSw72U4887MXi1WJd5lFe/ufs8/sq5RNQNyPU17pG1fRmJi9mRosPcqWwQQN153Pt0KsJrmbqBK//XM2XoXWvyYKNxF855KSgvo6F2ALy0Hc
 i+1tnh0e
 Q4iAh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 23 Jul 2025 15:34:34 +0200 Vlastimil Babka wrote:
> +
> +/*
> + * Caller needs to make sure migration is disabled in order to fully flush
> + * single cpu's sheaves
> + *
This misguides, see below for a workqueue case.

> + * must not be called from an irq
> + *
> + * flushing operations are rare so let's keep it simple and flush to slabs
> + * directly, skipping the barn
> + */
> +static void pcs_flush_all(struct kmem_cache *s)
> +{
> +	struct slub_percpu_sheaves *pcs;
> +	struct slab_sheaf *spare;
> +
> +	local_lock(&s->cpu_sheaves->lock);
> +	pcs = this_cpu_ptr(s->cpu_sheaves);
> +
> +	spare = pcs->spare;
> +	pcs->spare = NULL;
> +
> +	local_unlock(&s->cpu_sheaves->lock);
> +
> +	if (spare) {
> +		sheaf_flush_unused(s, spare);
> +		free_empty_sheaf(s, spare);
> +	}
> +
> +	sheaf_flush_main(s);
> +}
> +
> @@ -3326,30 +3755,18 @@ struct slub_flush_work {
>  static void flush_cpu_slab(struct work_struct *w)
>  {
>  	struct kmem_cache *s;
> -	struct kmem_cache_cpu *c;
>  	struct slub_flush_work *sfw;
>  
>  	sfw = container_of(w, struct slub_flush_work, work);
>  
>  	s = sfw->s;
> -	c = this_cpu_ptr(s->cpu_slab);
>  
> -	if (c->slab)
> -		flush_slab(s, c);
> +	if (s->cpu_sheaves)
> +		pcs_flush_all(s);
>  
Migration is not disabled.

> -	put_partials(s);
> +	flush_this_cpu_slab(s);
>  }

