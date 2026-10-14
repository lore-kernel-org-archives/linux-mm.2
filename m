Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11DF6CC6B2D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 23:58:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 269B56B0096; Wed, 14 Oct 2026 19:58:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 219056B0098; Wed, 14 Oct 2026 19:58:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1083C6B0099; Wed, 14 Oct 2026 19:58:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E11626B0096
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:58:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CE31716086F
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 23:58:23 +0000 (UTC)
X-FDA: 85322898486.15.5AC0ED0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 307AD40007
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 23:58:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A33F829G;
	spf=pass (imf07.hostedemail.com: domain of "SRS0=G5i3=IE=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=G5i3=IE=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792022302;
	b=Is+DrHj8QQPaPuTIMTHuIRDN8MEEXO8Lmkx69SyGWQeIjYvi7Qk/U+xxe9gAoaLX5GBOAi
	PMetjx1zLHYKA18fuoPzjjINbbM5ZWq7rhazll5PtFzSMjmC/vd16ysbXBVA9/9agb49mi
	djIqCZSwBy7+MyDghB84dBSCehPCa/s=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A33F829G;
	spf=pass (imf07.hostedemail.com: domain of "SRS0=G5i3=IE=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=G5i3=IE=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792022302;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+GQVMGiuWpacm/yY0sBxB5nCl27MVCd9qUh4v9ttBgk=;
	b=OoBwAtzBsq7V8HoYUsC8SRCEaDjgYjzJnMit6kFFN+a8oYBEfK1qk9bB+CZOUjSMuB0Hmc
	N8uLhyE1eKs6kW8gFMRvYei5Syp0O9gO79R9yCgd/a74v8aovTszSyVK17k6tUqqJj9oY9
	9LTPxngKv5p5MLUeDxlxPC/UW9N8zIk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A48F46022E;
	Wed, 14 Oct 2026 23:58:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 586C21F000C4;
	Wed, 14 Oct 2026 23:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792022301;
	bh=+GQVMGiuWpacm/yY0sBxB5nCl27MVCd9qUh4v9ttBgk=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=A33F829G1+QLV10Te1Z6d1QN9JhJOT1c2SfcOsQMGrXRuySms+ECpjPP3jgIVNZWW
	 wXzpMwlnGnABcjByC/5q2ak3l7LtlWB/Kk4zhLSpELzhfw3KIznYeP+JebZNVPS3Gj
	 VzAynwu4+DgjvNYfuBM06NIISVCpmeQtFCYG8nCtRhW3pG2gBZ+vaYkiZ/J5MYZfe/
	 9zr/BnKL+/q2zYszZOy9E57e0i1a2VNJEvcvHo9B0I6IC7xwt7X4fUZahpm2GMZUyV
	 AhcfTUf7luW5eVXHibhev+oj4jQ4PdPvQ+/vHwCP1MBj4lJOq/RYE3okkDWKaW+Kpj
	 Lrv+ihhwo+g8Q==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 16F3DCE0C55; Wed, 14 Oct 2026 16:58:21 -0700 (PDT)
Date: Wed, 14 Oct 2026 16:58:21 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	rcu@vger.kernel.org
Subject: Re: [PATCH 1/5] include/linux/rculist_nulls: add
 hlist_nulls_add_behind_rcu()
Message-ID: <7037ee68-5dcb-46ed-a73f-ed6ea58915f4@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20261012205447.2717801-1-max.kellermann@ionos.com>
 <20261012205447.2717801-2-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012205447.2717801-2-max.kellermann@ionos.com>
X-Stat-Signature: x8fx5xecdibtyudxrn9tdkxnfx9mp9zb
X-Rspamd-Queue-Id: 307AD40007
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792022302-562076
X-HE-Meta: U2FsdGVkX19Xwg9iDiay1M5+uNcK944JZnWjADz1tO9hvIJTewbGwMT6OWutnSHNZKmXZqf53ni48qKPdFnOfoOXWlTv1s9H+zbihre9A3KKoq96GCuty3tmLvzg5CU0bcf8jZwVuuLrMQ//YXpz0YjLPaSuInExytnQ7ub3fU5W/DeJePoCupb2EIbFI6fza5W3QaqHer+0vBaSMqSereWmySAUbJ8PR9dzEgFfuDUrvcLhlFrBc+niHLwGvZIkTmOHU6tKUBNQC2B8f6v2d7putHWTg2wWcUbEBrc4vqztOqBUgvYN7NXTOd27rPQwoZGL41t/meHGHId/ZW45imXd9uDBP4PR73yu/PdMGI1SA/rTXgPsC1+Fn9ciDqGjpmmYo60IIT2ureBa/bWWwuArT0ELtjiCl2zwt0wQ/ZNmupkil0oUfogAv8+jp8bsh5znaY4hgLoe8XfI1RiRgUmdf6KVZ0sMiYtMTTsD1G9RHPHUEKFme0lQCsWcHgsyD7bxYWUddkyrXgLouFdPP/xs1w0ZzHSw1PRVVuLJzrkZQ8HM6lCSnVksyjcxdGrPEftBYm7xWsEIXyrRlNdipb67EgL7scxSDWIeA9S/DbpSwlcj4FzUWssjAxp+G3JsuOYaQEVTl+CD66hdKP6gx/bnbCwKhm6Dzcw2US6BbRyF7tjF/BdSUv5kalsgs+4Bxy2x5WZXV5rgupkUTRgt61CLDP7xk4O0HoPBDOWOQ0859rxJAFxUS+kUFWP4Nn5MGaKY4TAqpZFp5Wmcct5SWL4cqnvH5eeUMYq19Q2Pz00NNv8Kx2nLefK3LwT5RL1Gb8ZEgUFpt7ti04N8smK9EOJ8V818ExKP7AZzPxXEHJsQalywXNavfvr7H86BgC7n7AgeI9s5qznORIQxtVCBRjNAFLmIeHigdhPJ6rqtNNlvTEUqN+iK6IL2sOqVIHsrHTG+O+IKAeIquZgEYQ0
 /YuaB5B+
 DhvoFtSYED1nPmEmrYNUhMi/IRExb50eFAC4UqFdZKXOaEM9P6pOd5Xtm+xCq/Yk3QtMVVybLmoWHVyfI0iEdc8T7dwKt82K3gMN8FO2pLQrNKNuTH9M09qUEtflUyXLmqc5jciSH/1rH2gEFcfDgqthWBOl94UdpVPenuVilC5CrwV/3E9ohsLOfda9Kv4x7o0rtRNOOIPqmg99p6k5pRThvS9I+aHJylsUsNHod+l4jlSF6tc4cce80E0E8b5UO8w1C0cqVE61YL4V/Mw70zOZX8sZgSEPPPzAl/DaVN0C/0EYSR7g3B0MLBGJrPgeanMyui5gTmsZJ0H2Us4cCLMNBq3QIAVS+3CKXqZ05wfCWoK1sU9y8rpYoaQoTfO9PdbyNYIkR9Sh4Qa/YeErdnNT0YiT2e8cEUlK1uzX9oCxDkdICBvAjPW9rzOHPZUZIdb/b7q9/qN9wSuUCLwZFfam0Okt76ldd+4v6Ryej7q16012OYP9g3GajZhfdEBjclLYbWRJIb3mayKHsgGMKCZpTqacREicakCdlDOepNWFesnnvYsm0571Fix9GNi+oVGUsY/NrziVby+hEbpBq1gTqvcTnM8Hd3VZ1kAaLbkDdqnbymO8/tRlWmqkaSgKOAuTIJZp6XA6S10l8l3hzUPBCPR3eFGVD8WZxCIgOpl6NLTBYhIdE3ok7D+jPqJti5/qMT307Cz6AGpBJYlRQr9lwsGp6fQSTznT7n4DwxgGVocwNLl+RU8X5j5Uo0pDysOSF4Ehc+K/57PDTpnL8pxhqv8pbBQ2uf98BhbJuO3ZU/ytejaFHVG8mSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 10:54:43PM +0200, Max Kellermann wrote:
> Move some code from hlist_nulls_add_tail_rcu() to the new function
> hlist_nulls_add_behind_rcu() for callers that already know the last
> node of an `hlist_nulls` list, to allow constant-time appends.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>

I am assuming that this commit should take the same path as the rest
of them.  So:

Reviewed-by: Paul E. McKenney <paulmck@kernel.org>

> ---
>  include/linux/rculist_nulls.h | 36 +++++++++++++++++++++++++++++------
>  1 file changed, 30 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/rculist_nulls.h b/include/linux/rculist_nulls.h
> index a97c3bcb1656..054e477dd093 100644
> --- a/include/linux/rculist_nulls.h
> +++ b/include/linux/rculist_nulls.h
> @@ -115,6 +115,33 @@ static inline void hlist_nulls_add_head_rcu(struct hlist_nulls_node *n,
>  		WRITE_ONCE(first->pprev, &n->next);
>  }
>  
> +/**
> + * hlist_nulls_add_behind_rcu - append after the last list entry
> + * @n: the new element to add to the hash list.
> + * @last: the last element in the list.
> + *
> + * Adds the specified element after @last while permitting racing RCU
> + * traversals.  @last must be the last list entry, with its next
> + * pointer holding the terminating nulls marker.
> + *
> + * The caller must take whatever precautions are necessary
> + * (such as holding appropriate locks) to avoid racing
> + * with another list-mutation primitive, such as hlist_nulls_add_head_rcu()
> + * or hlist_nulls_del_rcu(), running on this same list.
> + * However, it is perfectly legal to run concurrently with
> + * the _rcu list-traversal primitives, such as
> + * hlist_nulls_for_each_entry_rcu(), used to prevent memory-consistency
> + * problems on Alpha CPUs.  Regardless of the type of CPU, the
> + * list-traversal primitive must be guarded by rcu_read_lock().
> + */
> +static inline void hlist_nulls_add_behind_rcu(struct hlist_nulls_node *n,
> +					      struct hlist_nulls_node *last)
> +{
> +	WRITE_ONCE(n->next, last->next);
> +	WRITE_ONCE(n->pprev, &last->next);
> +	rcu_assign_pointer(hlist_nulls_next_rcu(last), n);
> +}
> +
>  /**
>   * hlist_nulls_add_tail_rcu
>   * @n: the element to add to the hash list.
> @@ -143,13 +170,10 @@ static inline void hlist_nulls_add_tail_rcu(struct hlist_nulls_node *n,
>  	for (i = h->first; !is_a_nulls(i); i = i->next)
>  		last = i;
>  
> -	if (last) {
> -		WRITE_ONCE(n->next, last->next);
> -		WRITE_ONCE(n->pprev, &last->next);
> -		rcu_assign_pointer(hlist_nulls_next_rcu(last), n);
> -	} else {
> +	if (last)
> +		hlist_nulls_add_behind_rcu(n, last);
> +	else
>  		hlist_nulls_add_head_rcu(n, h);
> -	}
>  }
>  
>  /* after that hlist_nulls_del will work */
> -- 
> 2.47.3
> 
> 

