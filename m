Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80917606A323
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 13:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=blGkVaK8
Received: by kanga.kvack.org (Postfix)
	id 8B3396B05B7; Mon, 26 Oct 2026 09:25:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 889A76B05B9; Mon, 26 Oct 2026 09:25:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7792C6B05BA; Mon, 26 Oct 2026 09:25:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 52C866B05B7
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:25:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DAA3F1A0744
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:25:50 +0000 (UTC)
X-FDA: 85364850060.02.F24E88B
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0040D140002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:25:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=blGkVaK8;
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793021149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JTZ/P1YmJ6IZNJ6lk8Cg6Zigprwxb6S7rjKWG93e8pw=;
	b=BrGFIgk3S9AO7cfu5uxpg928raujjV1YQkrhWqqqNy4J0EaIVj08lLMI6VJrd2D3ArgDIm
	ZOAAS0jg4sSG5U0SIPsy1rxtWsVUfHowcaBz8WRraF1f/5yJl3bdKbglziTT7BdJrJt8L0
	dvlqpGnmILD8ZqL+8Xwh92pjH7kYCv0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793021149;
	b=DA47IgVKPrS/Tqeb02jPI183zKOTE7GMcudquG1l1cmuzB5pV9Y51xWSbvPeF+Su+UqGly
	7qbwrN23APJdtlGT5x6cOo6ryNs7aaKOupcwOXocIOo/3Y6oouhZbaf3bvp3xa9e5bI8sG
	xrllCuFBW7htNXymVhddtjUUP8Hd5I8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=blGkVaK8;
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a35a60499eso16789185e9.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793021147; x=1793625947; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JTZ/P1YmJ6IZNJ6lk8Cg6Zigprwxb6S7rjKWG93e8pw=;
        b=blGkVaK8CQ2Z/S3S8Jbf11vvw+fLpKbgkftM/NAsNuvUq8Det4+iFdypSqV+TV585K
         g1sJS0PlLSmI9HhJlynDeg6E3T3fg3Z0ozMhpxy9iwxo1/91+JmfVI5ZyGyqNLfE+g/A
         rQtMbBMfOQDqohxK/+X7CanMPIQFEyykX0jCHkhWxPelxul77CUNAWTYI6+sh/3sVe+z
         WIrbx5boHs7zeXxulILUVkejQz6NgEMI4eo39sclEs/74iN5y1z/JGg8Z9GSn7HSs8jU
         dvOwic00Xf2knMmrVOHOkIxK+uLXiAp38W9QIG/LR6L7mDAAVvVMh1XoY0oOm1l6zTi5
         Wu/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793021147; x=1793625947;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JTZ/P1YmJ6IZNJ6lk8Cg6Zigprwxb6S7rjKWG93e8pw=;
        b=hbHvy2mZpEu+kzh1rSLmCP6cirmOZwMKff0LjMjq9eDnfjmQdXIsapbHR+5sJRMZYr
         KizQOS1dmOZPuN//IW3MSYwFwD97FImDrdC6Vw2p7W1L2q6gxNzt1cAfhl6BZtMpUmaB
         2R7UJzou4zIM4wD1FDR2dj1YOCXMEymo1Hxe8Ldp6XmOf9aK5DuQBLuvL9wmMukOQNNS
         gvSWjC2DRg7ac4/jONku6Iz6kKLpfMjB7XP04dmVqt32CsxS10pCKqZXOXLEqjSpySi3
         pNZ4r/uqkNPFheAGnwsBJGTvlWeIPZJ9H+opECzpdXedVTgN13YWDNuSng0oyqYzzhRs
         33Jw==
X-Forwarded-Encrypted: i=1; AKwUvBzoXiPW522qnGuO7PNSd3oc2WeyPom8mS4ljpdrpaCIWiU6sxdUdLlD1smOykbFfIk6I1/FMgDu7w==@kvack.org
X-Gm-Message-State: AFq9FYIuO3alJ+oFpUvUwNH8TLxB0gOK7eVziaMNXFBUTLPd0uEnta2y
	NWr9KrBybRaDStCFH1WxffwPNNWa+y2MISwv/5kDRlrzdJJGifmuca2wj2hhfRxs6K8=
X-Gm-Gg: AYBFou3vDGHON6CnnQ0gNgHsnAfd146KQuFuTX6dkn3r6kzT0qKqoQKOK6Wkcqg37Ju
	tJ3W0WjY3aBHazfCNCguMZEgH7GP9TmnEEFz1Ein4uLH/dYs/fOcpIf3UWV0Nvw5IH5NtSczk57
	g/A83iwqqjYAuLgaYp+AbEdgKb+R1/AXe1MlM4RcoFY8+xypOp6Pl/4rV8H28P9GoljJDx8Lwh/
	jWewfKlKRvgQJEWY/ZyphFrKKZc3ZqdN7CnCz71fVr6GchPl9whwbIblcKuUybFW5pkl9GL8tRW
	U2Tk1rbWNiikkFXi410PJ21n+79L0xmzfpofkCJ17FoGUMAWbOoTd6vhMnr7A3pxFwaj2uxf2Gt
	f0f62peRAJicC298/GnmopsBZrgMoU3fEroS3gow/92EXvyQ8Mv4SP/QKfQTeGCbh8fpi+Xkfmf
	FryXNpE6IC81VwZgx/OFJ2rIq3TKl9Iwe8pCj11K5pzoGA9iKBLnL4jVi7KgMmojmBXjXIvFvdn
	5iKxeTj4sC++J8jAYJg8qfsrg8Oaubi6VwcEW7xJ9xjyWoTe4nKTmawiyeRSAv+DPf0cw==
X-Received: by 2002:a05:600c:a306:b0:4a4:fc8c:cfd9 with SMTP id 5b1f17b1804b1-4a4fc8cd1edmr72049405e9.25.1793021147467;
        Mon, 26 Oct 2026 06:25:47 -0700 (PDT)
Received: from localhost (109-81-20-177.rct.o2.cz. [109.81.20.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a30e11bsm232464125e9.1.2026.10.26.06.25.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 06:25:47 -0700 (PDT)
Date: Mon, 26 Oct 2026 14:25:44 +0100
From: Michal Hocko <mhocko@suse.com>
To: "T.J. Mercier" <tjmercier@google.com>
Cc: hannes@cmpxchg.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, zhengqi.arch@bytedance.com,
	akpm@linux-foundation.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm: memcontrol: fix NULL pointer deref in
 high_work_func() on dying memcg
Message-ID: <at9U2HvyUP-iYOCt@tiehlicka>
References: <20261023222313.3979455-1-tjmercier@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261023222313.3979455-1-tjmercier@google.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0040D140002
X-Stat-Signature: gy789jczi6eqp9j94drfr1udufpbafni
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793021148-618582
X-HE-Meta: U2FsdGVkX19Y7N6pMe8jZKp+m2YM3NbBhJtb41KtW/WtKp9rtdyY401ZibbLw6fpD8/fUFshwrqcX5uBRdtIclENnpoYh2GSrOYLqEqCUZDHwP398LnrbB+DIsTi/cPtXQkgAuB99wXUfzPRNUZiYGWfFtExVsye9xY0jWFq5ddKbtDazYexghcvRAwbU0SGx6gr9oTD/LIMvPGcsffvD2DVk6wr5r5oB5Sx6k5Y+pL+WolH0+oEToiT33vxlgQG3rwk0ECHt73NPKScl8sWpOJBc177w1G06OwEXT4w0LE/fW9m/fXftuWae1AF+3k5wDIax6+z/wUiEkIZhiN5IlhGNZYN9PUkmTPAPjBhhj85rpeN8oTxTb+wTlZHPZtoCvgJWoK8pgW/M5bKD4hChSddWEzTR9ctyV5+hju8uLHzgXN0ZgFqXc7VZgzccvnP2bTlbLCt5OBaQItoNDcrkAQfZsgiRSlRqwkD3HwquE7QIO7XhBSfPl7frXhyoGhjkfkhHW6S56HtFWD3n2HaRxCTPhOen1G94T2QNvZaXd5SUp6pTyyo4jURkUuaYm1WbRLF/J/j6hCvfuuMbvczLuQsICbrZDXuab3kBFLyrmRP4uUdlME64NAcKL8FxN+nHaPY4e3pEOAQ+qjr2k1FZcQA0NQxFaNfbhbUiP7Yy1EihjEf/lfsBabZkNzCJr3FvYhCwGiARUtZ0J1JgtG67spZAkX3rry/ZKsiyZ4VGr2AmCaWur8OUeAlesE1tpserlC38yuhtihsLik4S0/mqCW94Cs2fLjfw62bBj1EViWDiu3jlNqgRhlLF5WUuxAu8CHvXuTvoV8DazA/x5WuwhRUbohsY8dFHHBnubhFHLonc6epDCfB52QqgYFmFNu722koWa2bLKk7nFWfWa5zIue5qZhUp3Jt4ePnQ2UW1MT80gUvyO8dcmpSuL5WCvIOzdMHCsk0m2B1NV13u6T
 TSBSNlpK
 dHFwK5LKGUdknsOX6duHZNKvvyWSTyOVz5xy8YtnJn7VeAZzJVyRKq8868N/k/mGg1sLnF26Thsq99CdSnZhiEa1tphpg1WEQj71HKDarIC63yO9KP/G/bWHiypgeXGsmUYlJGPl7wBHkeMQ2KuFxNAOjDSixiCWeiU+MTBAKDWhPk+/+RCpse9Kt+K0t1FM5/+dvyWoWxk2W+S6lXjHs7bCB/0cgt9p1BYLn0dKNkSCLvLd0DXx1guqBJIuV3FGFkhQen9tKTIsKL9oeusOFZ2d9mLFVJhl3FcsvXL6JYdDv798yDiciwSXt38pJuoQRMN1+3gPvszRZy5Mbs7Iq1OiG0zQLbfG9lW59sgovgKpDTOZ34A5LsTdz/2APCDhC3Apr3FMO6nYSOmq3T5yDrPlq6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri 23-10-26 15:23:13, T.J. Mercier wrote:
[...]
> ---
>  mm/memcontrol.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a05d9a8baa1b..84f4a8fd4d16 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2457,7 +2457,10 @@ static void high_work_func(struct work_struct *work)
>  	struct mem_cgroup *memcg;
>  
>  	memcg = container_of(work, struct mem_cgroup, high_work);
> +	if (!css_tryget_online(&memcg->css))
> +		return;
>  	reclaim_high(memcg, MEMCG_CHARGE_BATCH, GFP_KERNEL);
> +	css_put(&memcg->css);
>  }

OK.
  
>  static void high_irq_work_func(struct irq_work *work)
> @@ -4463,6 +4466,8 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
>  
>  	page_counter_set_min(&memcg->memory, 0);
>  	page_counter_set_low(&memcg->memory, 0);
> +	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
> +	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
>  
>  	zswap_memcg_offline_cleanup(memcg);

Should we simply disable_work_sync when the memcg is going to be
released instead (mem_cgroup_css_released)? That should both prevent
the run reclaim_high during the memcg shut down and and also avoid
plaing with limits to work around.

-- 
Michal Hocko
SUSE Labs

