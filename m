Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27BA8CD5BAF
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 23:46:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 493546B0096; Thu, 21 May 2026 19:46:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 443936B0098; Thu, 21 May 2026 19:46:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 333266B0099; Thu, 21 May 2026 19:46:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2181C6B0096
	for <linux-mm@kvack.org>; Thu, 21 May 2026 19:46:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AFF5116174D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 23:46:27 +0000 (UTC)
X-FDA: 84793063614.18.5937DE5
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf26.hostedemail.com (Postfix) with ESMTP id D319714000F
	for <linux-mm@kvack.org>; Thu, 21 May 2026 23:46:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=TutZTcmx;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779407185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ALlc+rSkkMdtbljNag13qxzB8Q5Vali1I2lgtUdeRqk=;
	b=QCveglgw0/Ksfbu6JThXHNeUgkCL8cZBzfkGNH1CFTia32CRnR7XQrfusmrQHQNeV9f1P+
	VbcRVQy5R8Wcsrw+TtQoVp4PKEaocOTtREFrD+wNdHmzWR/wWt0GMl/fK9qKH6xbfSWODE
	ad/c8nDppK0hEm+7NfGDm3Xn2EQYq+g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=TutZTcmx;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779407185; a=rsa-sha256;
	cv=none;
	b=MTJxxn5bZswf/99H7lh3ZTTc0eB1u+pLWpf70RcfzwllshgOMbb2KOcauJilaZfDVlLSUr
	dQtMPhf9l66cJ1AbkMp5OFVINLZdoXT+T2z6qfjLxWU1bXTBxvgO9iwWYBXRzVyLwP6U62
	zGPMtYnElKh6SuBcr0tauLsMRU2+ydI=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-5165195c8b0so74835901cf.0
        for <linux-mm@kvack.org>; Thu, 21 May 2026 16:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1779407185; x=1780011985; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ALlc+rSkkMdtbljNag13qxzB8Q5Vali1I2lgtUdeRqk=;
        b=TutZTcmx5qaDDrue5HpwEdADURq/bT570sXLC81wcNMpYWgh8zL3VuSUaFN1m57TzV
         iW0lavF/a+SJ7ortw1dwPpYlesccU2ZBMt9ddRVcVWH9SBJXcu81RhLozGXpDIr26UhM
         jbWnU8BUO8U4OGUsNtvTkKJfyqspV3wN+r7KWqoHSMaDIj921cziQh9hpfwfEH5Ro8Ys
         VC6g3UGlatGLz1wtIqyw8n3YjWNjQRqiQwLkltM9SwMeJRm0zR2jTITQc/PheWFx8Y3H
         WkMvG1f/hpsZcai0vSWqkhNtIDu8C1t/QN5fFU88WuysV9CYss8yMbNlFXa7QmzOq06c
         LDQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779407185; x=1780011985;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ALlc+rSkkMdtbljNag13qxzB8Q5Vali1I2lgtUdeRqk=;
        b=Pln2tYdS2Bf6KEbylc9jO2nZ+OThGe3RIOgStxkLpEVXUfgMprmi4/gHm0ahX0igS8
         eEI8rA6rWYo7mj3hwjiUhzNxW+q/XCzhaYVAD7T1Z1pbOd/Bz5EoiqtkXYVh7WSugIU1
         li3lFbJN9RbTFg/BaHPke7e8VgXAfh+0CUGh1JV+qBh9vo1cnUmZaIQLnEHTaQNEWX7h
         lUqLeHI0E2X5B9YCLbK9XWigXAOuPQWm7dYW4bPdYUUNKffM+3RNUQd+sqSipNHALsBc
         eBDj/8etec6FC4zvAvU3uUinnfvKbIaMw0h+/xUSf4JIZFktN1KphYfex3oBEn8P6HfL
         SwfQ==
X-Forwarded-Encrypted: i=1; AFNElJ/7sUDDyCV8GuXKBJ69h2ot4q86MNj14Bi3sTgTMKriXbMvYpGHKgZy7FkA9dWF/+TwXkRJBvYB+Q==@kvack.org
X-Gm-Message-State: AOJu0Yzh63PC4wA0aTBEvTuSdXfyGzJbea6ZrOJuEy0IWpqV0GnnJkJf
	ywnHykDS8N5hJkDvcHT43v3AorNvcPy+K9d7NSy3ayMRpGcdbItLy6g56+b8H8sqXv0=
X-Gm-Gg: Acq92OEHcy8ekdgSNfqtXi1tiY42LYoEsLxftTHoAeedJihZneW8HCgTp2JILluiq5h
	Vp4mb33Pkp+NLDooR0GP8SiKW9QYkdLrM8jhlV7tLrjz7Gi3pXyvCG3EK2yverU83tAbdRTzKF3
	YR+dicDd5Pmtiqi6NtDuBHqqdP99stWk70enx0NlO2iKs9h+oRjlDuAEK12bB1lLX6L4rhw07I7
	8zT/aBBWEnbK34luPjQa7cvAgFxdUcr1WgrljXELQ8p/HWTYnJ5GmFOpBfuer4ttheyXVDO0woC
	SCCnfJemgOlbtFz8lN8FZcWjfonAb0Qc3Lxq7P4LSoQLqVI6bJkm1lvsw3wekcxK/Ol/y4du5mD
	+eWEqtQX7I1kN/gfE68jjMayFK7Lpyg7M6FS2ea6noV/oX56K2N4SFv9BCyxtbxGJa4qaOLW8bm
	ZZXnqkihj1h2jbQUYcnrFOfiUNkK3qK6Rm7+Wl4hLgOYOuFgulQcDlONSQ3gmlgg==
X-Received: by 2002:ac8:5749:0:b0:516:d191:f006 with SMTP id d75a77b69052e-516d45c9215mr21944911cf.42.1779407184872;
        Thu, 21 May 2026 16:46:24 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516d6438635sm4789871cf.17.2026.05.21.16.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 16:46:24 -0700 (PDT)
Date: Thu, 21 May 2026 23:46:23 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Alexander Graf <graf@amazon.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Jason Miu <jasonmiu@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/12] kho: allow destroying KHO radix tree
Message-ID: <ag-Xa-bDOouXAFXb@plex>
References: <20260429133928.850721-1-pratyush@kernel.org>
 <20260429133928.850721-8-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429133928.850721-8-pratyush@kernel.org>
X-Stat-Signature: asa5uf3gpeznxp9jbwytypxwb97miqyf
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D319714000F
X-HE-Tag: 1779407185-437808
X-HE-Meta: U2FsdGVkX1/YLKGEQTo13CllmGfHLS7Jwe//SV51efN6qoVQjTy+ACSZ8wJoxNxoUKxCm/Kbfj+Y/U+C1DKTShJklit4ele+kqQ2nlVJ/KR0tq74NpLYB+EdRZ0yxfoy/qOPqtZDtz+5Yj8+Nxpyu48C+cteh6oEjcUH3s0i17LzK86jz0BrmYzMcY2QikWNdBo7iagkVU/HSTiu/nZ/2XPasgMnljK4MobtLj3XTKN6ATM2x9DViZPgyPfaRw3JzAblhWStv9hrT+Rql0LNo4Mvuew09qsSg5cmJvfzdA/I6ubc5Jf/N9p1CtyQnp4H1buPsijdtIC3ax+q6Qy02fwFOhu5CHhUy3bfV8cYeJgf5kJyJr1T4kV+zgiLXmVwxRdpvK5OPBmd+drGbMwF0FepY9lJf9Evl+hvvNDcSCCZEPVtzgSXdeihY45Od4nc+qfLbu+hYUu782P/ID7OJGkrmKNenCP4MeMXH+oEJ9mh6Yx+JtiMsYRW8PYEs67AEsa2lOIXGd2bgZltdP9RKdN8bsQbNTnVtTEhUEBWFcGzohFL3yXdwvsj2fAP5AhgctrQpFZOgROvxdjuvWwKsDFizA9a2FrC5A1Y8WhTVFnrpgWwWp0/RHpJIm4a4GrA8KNKn6HCn7Xfdfknu2k1E2nJrmUvFE5qhIvBCtgWBbj5gPUD9UF9MQ0LoHIWdJ76H6Y6D3XnMysZSWeq6VuKDnNM/54ZeDQUWSt77SvU0mAkRdUvOo11JJl9t4ag5R1IPI7gdjhFzbqndS/mlq9DnkfsFCpNXzZJ27OJ5cQN0Kq8PeVCo8RyzTkJS+YZLAoV22qmUUNG5zw2nf6imQ2zv5vitT/0S1gv1JWkenOJFRg4Wj9UJV1f0NzrRh7l43vqVO0IgKN8E178M2xbFeqArkpDH+QNMaY4+AjEE+hbg5kNZJtGBeWM1ceSvvD5ErGS9JCyVqfGKPQNchjDd6a
 gibZ4w6X
 4/1iLprNhZOTB6w+cz6rVDc4rm52UU2U33QuGg9/jFWfqXJZL1CzmzylKV8pv+XBvp3RUEeNit53Prx3nI5HqSIkHdRd1bFPgu7nRbuUDbIpQPx2JDHrkUYe4nFncJ8zAyaCMtfAtNrmYMAVd+6moR4d0pNdxhf567GhDM4rb7pLme1T19gxmq2Bi5ZyRdiWoAS506Ymg3hoHwMFbKsFCkG5gc7jJJwU0qQ1UIcb8XIMOf/5m5GljBtYL9xhRHJDcVnpZzYsSP5kUGnRIG7I7fnkyoHzqeSXPGDCNG7RLnlmkg3JZdRc/cTdXfwqAVQrlRxHxhOrqZ/bGhabCooVk8SsqDUfPxDidZn04PpLSbIgmMBZqVKncEW+mGNtoGtalJAW6PpGSM/8eVL/dWQ4KaQ0bJCpQWrX5ceq4NpApIob7cUE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-29 15:39, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> Add kho_radix_destroy_tree() which allows destroying the radix tree and
> freeing all its pages.
> 
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>  include/linux/kho_radix_tree.h     |  3 +++
>  kernel/liveupdate/kexec_handover.c | 34 ++++++++++++++++++++++++++++++
>  2 files changed, 37 insertions(+)

Generally, in Linux, recursion is avoided due to statically sized kernel 
stacks. However, here we are bound by a relatively shallow KHO tree, and 
kho_radix_walk_tree() is already recursive, so I think it is alright. We 
just need to be mindful of local variable usage (frame sizes) within these 
recursive functions.

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com> 

> 
> diff --git a/include/linux/kho_radix_tree.h b/include/linux/kho_radix_tree.h
> index 6c0f7d82716b..617395a6647a 100644
> --- a/include/linux/kho_radix_tree.h
> +++ b/include/linux/kho_radix_tree.h
> @@ -54,6 +54,7 @@ int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key);
>  void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key);
>  int kho_radix_walk_tree(struct kho_radix_tree *tree,
>  			const struct kho_radix_walk_cb *cb, void *data);
> +void kho_radix_destroy_tree(struct kho_radix_tree *tree);
>  
>  #else  /* #ifdef CONFIG_KEXEC_HANDOVER */
>  
> @@ -71,6 +72,8 @@ static inline int kho_radix_walk_tree(struct kho_radix_tree *tree,
>  	return -EOPNOTSUPP;
>  }
>  
> +static inline void kho_radix_destroy_tree(struct kho_radix_tree *tree) { }
> +
>  #endif /* #ifdef CONFIG_KEXEC_HANDOVER */
>  
>  #endif	/* _LINUX_KHO_RADIX_TREE_H */
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 47f7c4a2865e..29479534f65d 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -286,6 +286,40 @@ void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key)
>  }
>  EXPORT_SYMBOL_GPL(kho_radix_del_key);
>  
> +static void __kho_radix_destroy_tree(struct kho_radix_node *root,
> +				     unsigned int level)
> +{
> +	unsigned long i;
> +
> +	if (level == 0) {
> +		kho_radix_free_node(root);
> +		return;
> +	}
> +
> +	for (i = 0; i < PAGE_SIZE / sizeof(phys_addr_t); i++) {
> +		if (root->table[i])
> +			__kho_radix_destroy_tree(phys_to_virt(root->table[i]),
> +						 level - 1);
> +	}
> +
> +	kho_radix_free_node(root);
> +}
> +
> +/**
> + * kho_radix_destroy_tree - Destroy the radix tree
> + * @tree: The radix tree to destroy
> + *
> + * Walk @tree and free all its nodes.
> + */
> +void kho_radix_destroy_tree(struct kho_radix_tree *tree)
> +{
> +	if (!tree->root)
> +		return;
> +
> +	__kho_radix_destroy_tree(tree->root, KHO_TREE_MAX_DEPTH - 1);
> +}
> +EXPORT_SYMBOL_GPL(kho_radix_destroy_tree);
> +
>  static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf, unsigned long key,
>  			       const struct kho_radix_walk_cb *cb, void *data)
>  {
> -- 
> 2.54.0.545.g6539524ca2-goog
> 

