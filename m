Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B121FF60F4
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 17:43:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6642D6B008C; Tue, 31 Mar 2026 13:43:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63BC96B0095; Tue, 31 Mar 2026 13:43:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 579BD6B0096; Tue, 31 Mar 2026 13:43:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4B06C6B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 13:43:21 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ED2E9B806E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 17:43:20 +0000 (UTC)
X-FDA: 84607079760.01.6BFCE1E
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf24.hostedemail.com (Postfix) with ESMTP id 02740180005
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 17:43:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="AU3yu51/";
	spf=pass (imf24.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774978999; a=rsa-sha256;
	cv=none;
	b=WJYsrLmkRaFWwHkkYxTGunzyFiORhy82bgf9Q5/XiqylqcR5yeXkt6eT5qHzCbtfYGDXWT
	L1aWU1oM7biUqaqXmaOdVeuzpOU5DED8w6sWqN49WIRWgF0NnkbNIfQ0xsoCN1Dqm9uXmY
	XJ/rW0tt/ImoZ6XHaCAahKhPRzJ+GlY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774978999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nSwAkFr6yY2Ua+7QC/2fypo+mnk8RtVfMIkrusL4iuk=;
	b=cHrZDDGRhWZrcZY/RDSI3GWihdwF2RFy90TClxPc/xiQuT8LuWuvz4EE9BacGnClP8QCxl
	rxYLCiAp5ifMDBgMJTcO7wVCjlkT7elr7p1Tv3ssTTHP4ueGTbwRL/QLgI+SDiLSEx15jH
	p/Lv5As0Rh1eaQvAo/jtVTl0QjQuYqQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="AU3yu51/";
	spf=pass (imf24.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5a27daa652fso4902663e87.0
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774978997; x=1775583797; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nSwAkFr6yY2Ua+7QC/2fypo+mnk8RtVfMIkrusL4iuk=;
        b=AU3yu51/377FVZAWMKb8Fn98rXUMeoP0yxR1FnBb0toZLszOg+9OPE3Dsa5DvqhAre
         2kLeHhRKHEpZeZuNWtUa2+/vHgu9xJctK6QnImdFpkgUzxCAV3yscxh/tMEFu/QtfuN0
         tF7LeUkk/0+4SWnkW6PPEP5yF08rCnrb/IuiSESsqbXj97TfDPMAQjpBoazZdA/yQ2+T
         a4/PiFNUR0g3vZxmnQ46ALGh3N08oh78uDqeWkTc13AbmRoMCx5CPnxt2HjoEKk8rlas
         oNviHftZ7lDL+oQy7QtkdXPuzXq0qsMtSD6+EjmQzfetL4y8vdIpnN7LktgGTGbzWPH1
         wd3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774978997; x=1775583797;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nSwAkFr6yY2Ua+7QC/2fypo+mnk8RtVfMIkrusL4iuk=;
        b=G0xAhEa0QETdkJ3rYOutmCeB1A2EhYVaGAs5KTaPLnJEy2P/DKcav3mCzSUAYtzX1U
         n2dMg0AB7JnT7L1pNqSuey2cchNQo76ahxbvVtTTc5hEwsJICxpBvebQmmWKHQvDfOUJ
         IThuCBmCGReiig/tE2GuKVwthyzYuXMlOK7XxJjOTjWVetQjBhI2MQ7e99r3CgiZwOLH
         2u7LWO3gnBmjHzjuuIPOSYdArqcVXOKxNRLwX3UWFBURNELhXPu92OA09CxfcWLJq/am
         H8ADMOZciwnhOXnyWp9jD/JE8wl4dtyjrY4Q6vojuK/K7hLC8rEJvumUQxh3adBW93M/
         LYkw==
X-Forwarded-Encrypted: i=1; AJvYcCUiwdg7gzIOicFGPVA8Jjj7DqwRv64VI8eUxZBN2ExY3LmLSLZ2FQNMQuEmncmdKm12kbhugv5+4Q==@kvack.org
X-Gm-Message-State: AOJu0YxVEFfJ4yANTbJogkllMjGG+dNd740ixTSMSx2clKvqj+d3tItu
	WU/RiNdpLxq6yGhTs7gl+9vaCEXDshqz5z5TGQkQ/OYhUokmI94DIBW4
X-Gm-Gg: ATEYQzzTPd4TvjRJCM58H3YI4JIqjISfkgZ/FuZ2tBvejqJygUTo/I3AjFQrr9HgwMh
	RFWMxJx0kL1w1IioaauGcJp0VevVXQKJLzXwb85FcQxJnO9Q2Um4Ik6hUHJWsqhaB5lm22NEsKn
	ML9I3OpxU+imhJkV37n/VwJ/bj5jfCNoGONc/lqV3zmZEmNntT7M6KuzjG0jNiLUPrXo5zcHM0k
	ThJOViDs7b3ESOlbQlbCsScM6LI7GNE7zeUWxTZ60WF82IZjWY7iVROoj7MkEhzZZkICpnNJ12a
	VbfIIMnbgxKXqGjo9xu6/7ULhRphd8cAGJJhkGWlBwjIbdqVfZjL9+Rj3QCYHWBR5tfsWQZEfoT
	Sf9Y5C0Sa4WbVtDQ674WmuqbQ0e0KE+V/e9byCisHuLgmI1dUrPpn4O3xQFeHzkTa4FUiZh+SKW
	U=
X-Received: by 2002:a05:6512:1381:b0:5a2:aa50:4c55 with SMTP id 2adb3069b0e04-5a2c1f06cccmr129486e87.8.1774978996672;
        Tue, 31 Mar 2026 10:43:16 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a2b1456eb9sm2579159e87.69.2026.03.31.10.43.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 10:43:16 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 31 Mar 2026 19:43:14 +0200
To: shivamkalra98@zohomail.in
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v8 4/6] mm/vmalloc: use READ_ONCE() for vmalloc nr_pages
 status readers
Message-ID: <acwHshfg9vEUFaer@milan>
References: <20260327-vmalloc-shrink-v8-0-cc6b57059ed7@zohomail.in>
 <20260327-vmalloc-shrink-v8-4-cc6b57059ed7@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327-vmalloc-shrink-v8-4-cc6b57059ed7@zohomail.in>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 02740180005
X-Stat-Signature: a4sh4a66rsnsbchf4crwc5666jcqni4j
X-HE-Tag: 1774978998-4382
X-HE-Meta: U2FsdGVkX18XBPtwiBoLWXY2LB29sAsiFY6sGZjYXJk5gariCkbpTSsYad1g4Zv9Tf6Rs7BJ6Uy8BSKT1TBJiijUwCZx+VVnNamZTHnkal3cPSautz2AiCBpkdEEsRvtObm2ninnYdoQ+YaBBRaRP+Gk2BdGEgZiBMIgwGUVG3GrQNp77ce1YUV26Nex7xzBP1fLNbDl7+UWhVGXlTxnd3c1SkLThOtKO4zcvYvJRCozrEdCcAGZ5mc1JxqQfGB87abp6Zh+an6iO0GEfl3esAp1+YUTz9YeOR9ROOplcBAAxSgr3SXDDQ5S5GGciGjv0dZrx221ifdkiHdGxU+9sEBYpQ1zKqmO5fkdBhhpqSDlW9SVqQYQ2j8Tfd1/snbqVGlfncuSRP6VgtPveIYIM/fRY79bHRRY0QoANo6ZpKSBQKSPvW+WIsHLRTNG9BSn19x+y8lbevW7b9ZUG49B1XfehXagvHqDh995O2r6Gg10wEAqCwtgYI+InG3/oTS04iCPOVagH21gdkoYQwoqFnrCFuYi9jO9SUTKZTlOlVeCFWKJ9jGr9zYLHWTSEfUS3rGwkBjNLd+nK+HcieaUQwoUQCL87sd83bB9vShxLi8GzwO4AdLMETFT/zB4+ZjsTI74wAZq/XHhy/HBGs3K+f8gHl60IKb+VsttPwq+asbc1uBwI7fymxZ+7yjp4/Unifdy+2hiec7TbbSk77qnh4DYK73k+YjKXkUIredCmMtd1GVTk2vCLltkcRl7uhabmiIkWF6htCes6eyz+zi1LLvADzlvNiI3mbGlWvKgGjZIFBYY+A4hBn6p8rbomM/CzNAO10QWxu8ASZpUbOgRGUA/jKq5oTQnwhxxPjhtK8y4ar5V+LMqQ2rM+/Zpjs+gK/OCw25ULb87BqnQK3THj0zskCrZ5yLagEvzrcXYhX5Mjhbd3HU0A/4ZdGYBnV64Y/G0ituuE0SkvOHrbAO
 /hV7Dsc+
 v5/R3YEyMWLGUMDY0yJi60jgdKnsgpEW2uPa6uGN6Ppt42eNa/4L6fUat8FsaFaL7QRzHCpmTQzUvwdaQre5KuvbRcbxH8LAO3bYX8tgt7GaSvNWvO67HB4DAXTvoDssJk4YqfxQHmqXbxmKzmWPIJV0wK9aUvQVTAh+y3iubdrHctF14dWgLlmmqrXOsIxiTE4dZD6ah1i9I8Gp5rSLW1/kaz3wmilEtR10fHz4cDIlEcApUDG4bLE8At+vAHMzhdwHeoypSmjzFiKDD+QlqvxYPpJYcnyQY2cP43sUGQCLmBYjqunaVDzJi0FPRzAejIy1OXoy2NTHNpsMruJZx2cuamLj9p1LwLY960OyD68o+SDdU3vK1QJH8+t4VZa/gOTw2wfEWxlpOkx+3yrzX2y1pXtcRry/DEFCyzmcBuR+rr9gEMJ7UGnawAWkb4/zKAr22IMcMs2mdocjUUYEkRU3FdgTggYytHE/MsjFRw7qV7pYHdFwPVfFdeUuZ8Ik34M/RUTsnDVDJNAc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 03:18:40PM +0530, Shivam Kalra via B4 Relay wrote:
> From: Shivam Kalra <shivamkalra98@zohomail.in>
> 
> The vmalloc status readers (vmalloc_info_show(), show_numa_info(), and
> vmalloc_dump_obj()) currently read v->nr_pages and the v->pages array
> without any concurrent protection.
> 
> In preparation for vrealloc() shrink support, where v->nr_pages can
> be decreased and entries in the v->pages array can be nulled out
> concurrently, these readers must be protected to prevent use-after-free
> or NULL pointer dereferences.
> 
> Update these functions to use READ_ONCE() when accessing v->nr_pages
> and v->pages[nr]. This ensures the compiler does not re-fetch these
> values and provides a consistent view of the vmap area's state.
> Additionally, in show_numa_info(), explicitly check for a NULL page
> pointer before dereferencing it to avoid potential crashes if a page
> was concurrently removed during a shrink operation.
> 
> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
> ---
>  mm/vmalloc.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index ddb689bf9ba5..c6bdddee6266 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -5189,7 +5189,7 @@ bool vmalloc_dump_obj(void *object)
>  	vm = va->vm;
>  	addr = (unsigned long) vm->addr;
>  	caller = vm->caller;
> -	nr_pages = vm->nr_pages;
> +	nr_pages = READ_ONCE(vm->nr_pages);
>  	spin_unlock(&vn->busy.lock);
>  
Here is it protected by the spin-lock.

>  	pr_cont(" %u-page vmalloc region starting at %#lx allocated at %pS\n",
> @@ -5210,7 +5210,7 @@ bool vmalloc_dump_obj(void *object)
>  static void show_numa_info(struct seq_file *m, struct vm_struct *v,
>  				 unsigned int *counters)
>  {
> -	unsigned int nr;
> +	unsigned int nr, nr_pages;
>  	unsigned int step = 1U << vm_area_page_order(v);
>  
>  	if (!counters)
> @@ -5218,8 +5218,13 @@ static void show_numa_info(struct seq_file *m, struct vm_struct *v,
>  
>  	memset(counters, 0, nr_node_ids * sizeof(unsigned int));
>  
> -	for (nr = 0; nr < v->nr_pages; nr += step)
> -		counters[page_to_nid(v->pages[nr])] += step;
> +	nr_pages = READ_ONCE(v->nr_pages);
> +	for (nr = 0; nr < nr_pages; nr += step) {
>
show_numa_info() also is protected:

	if (IS_ENABLED(CONFIG_NUMA))
		show_numa_info(m, v, counters);

	seq_putc(m, '\n');
 }	
 spin_unlock(&vn->busy.lock);

> +		struct page *page = READ_ONCE(v->pages[nr]);
> +
> +		if (page)
> +			counters[page_to_nid(page)] += step;
> +	}
>  	for_each_node_state(nr, N_HIGH_MEMORY)
>  		if (counters[nr])
>  			seq_printf(m, " N%u=%u", nr, counters[nr]);
> @@ -5247,6 +5252,7 @@ static int vmalloc_info_show(struct seq_file *m, void *p)
>  	struct vmap_area *va;
>  	struct vm_struct *v;
>  	unsigned int *counters;
> +	unsigned int nr_pages;
>  
>  	if (IS_ENABLED(CONFIG_NUMA))
>  		counters = kmalloc_array(nr_node_ids, sizeof(unsigned int), GFP_KERNEL);
> @@ -5276,8 +5282,9 @@ static int vmalloc_info_show(struct seq_file *m, void *p)
>  			if (v->caller)
>  				seq_printf(m, " %pS", v->caller);
>  
> -			if (v->nr_pages)
> -				seq_printf(m, " pages=%d", v->nr_pages);
> +			nr_pages = READ_ONCE(v->nr_pages);
> +			if (nr_pages)
> +				seq_printf(m, " pages=%d", nr_pages);
>  
>  			if (v->phys_addr)
>  				seq_printf(m, " phys=%pa", &v->phys_addr);
> 
>
vmalloc_info_show() is also protected.

I do not see why we need this patch. Am i missing something?

--
Uladzislau Rezki

