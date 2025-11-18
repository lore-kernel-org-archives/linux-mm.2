Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1465CEE32A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 15:47:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16C686B0027; Tue, 18 Nov 2025 10:47:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F6C26B0098; Tue, 18 Nov 2025 10:47:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F265F6B00A7; Tue, 18 Nov 2025 10:46:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D9A476B0027
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:46:59 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A5D6012F3A0
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 15:46:59 +0000 (UTC)
X-FDA: 84124156158.25.4EC9AFD
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id B936180009
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 15:46:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XCo5NvdN;
	spf=pass (imf30.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763480818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iftpghmgjHK/qlUmjNQt15sHZAbCGUymJIcA6jMTKOY=;
	b=E5A+tRr50iLgWlXB7qZ2iABcCR2CRJC9jUO/LvzdjJNgXqD5W1x+DRh+gjJ8jTMz7ggzEk
	FbwSv0GxtW4ihQv4OnzgQ1SU2Dt2E/pitoIHL4+4Wb+y6rqUu9zG+wwzyv++55au8B0knh
	R7kh5VZWVu7RAk/QTqfyLtno2ciiIaQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XCo5NvdN;
	spf=pass (imf30.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763480818; a=rsa-sha256;
	cv=none;
	b=UtfH/PsIqtZSdqOjnxx47Chfwnu/8kyFmo9SPRlkVCqy8cjcA5pzbtMF8HGbquHLoDaxmf
	1bNNJ3JwV2EjepWeI/mwjJVPKxSuBI8gJzJ2CDhqZUepNdZ3VtPYMgUNAAQIBUs8m6s2h8
	wBKRaxleHRs245AeK1qB5nN0pSTswVY=
Date: Tue, 18 Nov 2025 15:46:26 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763480815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iftpghmgjHK/qlUmjNQt15sHZAbCGUymJIcA6jMTKOY=;
	b=XCo5NvdNn0WSd8lf197dhB6V+YmNH3RyPCdvt8JC5xn4kW2cPJS+7PqzuYuxa6zF7i73ut
	+bFsQrTuEZju3NAN8pueuz65SG/iQlwkq2wJBEQc3C07kTPb4wE+w7mQmQ5s62hfF7y6UN
	JFK6Q4c4jviESpx/yQRFGsnw4mCD6Xc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sahil Chandna <chandna.sahil@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, 
	lorenzo.stoakes@oracle.com, mhocko@suse.com, vbabka@suse.cz, rppt@kernel.org, 
	surenb@google.com, hannes@cmpxchg.org, shakeel.butt@linux.dev, 
	zhengqi.arch@bytedance.com, Liam.Howlett@oracle.com, weixugc@google.com, 
	axelrasmussen@google.com, yuanchu@google.com, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm/zswap: use %pe to print PTR_ERR() values
Message-ID: <dqmiid7ep4b7lchv6qwniedftoqzo6qit5py3dwo6whrcljrbr@kydq6avtuypd>
References: <cover.1763227530.git.chandna.sahil@gmail.com>
 <555cdbea3a51898e4c84fdc0f444dae0c2e20f24.1763227530.git.chandna.sahil@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <555cdbea3a51898e4c84fdc0f444dae0c2e20f24.1763227530.git.chandna.sahil@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B936180009
X-Stat-Signature: 75fmhefhy3s98mmiwzbin353n79fwjyy
X-Rspam-User: 
X-HE-Tag: 1763480817-385840
X-HE-Meta: U2FsdGVkX18IpNeyLvO4WIAMYXiUkQJHdrnU2XrLUNcc6iSV7HonjSN3MFGKsdR5qTpWicHFYHqeW9YxQZtN4So3fATDHjm/aC1w8mzVjzih/3u+PKOvZCk89fE3gj+1dXSbUdeNJrigzLri1huqbvxoRe9YHhtt0idX6QIiTBwR4Khbjh5dUdgCSGUrpCQzQCJQBOXYAhWutnuhtFK5Vb/CTNj3jhcrKncWZ3hC+OrUw/qpiHCAukZrH/1irtMao3NSLpfGfLTMnFG15m+nlyjgFnzSXPVi8pRp52BE56bmcrNumT5xTTrTtgkpKQvywu9uUfINAqc61SYKBUsZjXkIQnef0VVU5c542vCCQ+OzbPq77cPr2+wbMh9RiSEumLetW6tlhB9dkgBmEdWX4e6OnltxD+VPtQN4/6KbywTR/gmI0dldveYu3HhTqiXQMRpfNu1hE+1srwT375bJOHWBpJG+htFw/pwxWnfgD9icqZdcD66BcRdIyg5X3G9wA4IWOuj9tLrUBeWJfEH70Pvo6WTLCjUbwtZ5zty3NmpQr+tX5KG8s57OVUsdhUuuX7jWlPeznu/kFQNw42B9qZ7vlTcYvBPWmZeWir6lHIEgTeX7LQ03v/GbZgetyUNx8WK+e3QR4EMvE/L7J7wBbH/rQQADH7CpQ9wsx0h6l4iSPsax7c6ckXNHndjLpLUUZRuYXZ3mqfX6IJglNRZ0oC6N56WV0GFHTNvUORkpl8BwVm7Uevclph/lbrGzzdfiqVFiBw+diX2bZHVGMq3b9CZCbNK8QrMNWWW3AotYxorBoLz+VFckRErZTG8qOWXvZLsKA6w6RwTvCgbjCl+B1OnHBB0zrlskN/gSno6b9cOKporLRmpQfpsrmRtQIxOghg6QTLGhQ6SFUz9seNvfMneOLbtPoZb9X0zM2ph/CoDlZDBbGHmmKOjs2YWhG4pAIwR/z4inqpawYkMP7aM
 NX474Yf3
 rw60yG0uJofhCqJ2TI7VydWL7TbA2vuMLHUQrH70K6lxIAVjdA1c9tTSxpSgEcPVgbpayNtedDnPEcYUxk65v9bSvX5FdMyuKI2TQgdSLCnrl2ic04ThjDnfboy+Kdo6a1Yaz2/zxdTc5vwxJOwX5X87JMLoLG7gUBpGHqeSslxJbZV8ozmbrAEAH2qJX2eQWa9JEI0C/aZT7GacX+Fbls8Z33Ybk4CJsOBOHasABpzlewAT+CM61FG/LfV1MvO0GFuMDOmy7FL8U3gXraS4McB18/kSNTzMmX/wXQlUOSAyLtOEEpql2uuD7t4/KYNUZxRtW1K8X7Q1etJxurtV9CtA2E9nLuezyoEcn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 11:38:51AM +0530, Sahil Chandna wrote:
> Use the %pe printk format specifier to report error pointers directly
> instead of printing PTR_ERR() as a long value. This improves clarity,
> produces more readable error messages.
> 
> This instance was flagged by the Coccinelle script
> (misc/ptr_err_to_pe.cocci) as an opportunity to adopt %pe.
> 
> Found by: make coccicheck MODE=report M=mm/
> No functional change intended.
> 
> Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>

Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> ---
>  mm/zswap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index c1af782e54ec..c35604db32ad 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -749,8 +749,8 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
>  
>  	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
>  	if (IS_ERR(acomp)) {
> -		pr_err("could not alloc crypto acomp %s : %ld\n",
> -				pool->tfm_name, PTR_ERR(acomp));
> +		pr_err("could not alloc crypto acomp %s : %pe\n",
> +				pool->tfm_name, acomp);
>  		ret = PTR_ERR(acomp);
>  		goto fail;
>  	}
> -- 
> 2.50.1
> 

