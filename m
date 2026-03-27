Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 391E610ED674
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 14:38:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A039B6B0092; Fri, 27 Mar 2026 10:38:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B50D6B0095; Fri, 27 Mar 2026 10:38:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A4686B0096; Fri, 27 Mar 2026 10:38:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7523D6B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:38:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 23DCA1B6CC4
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:38:29 +0000 (UTC)
X-FDA: 84592098738.08.2304262
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4199814000A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:38:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j+wZub0x;
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.171 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774622307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qVAYAgb5FKWZkJuctDg9ra0Rbmkh6Srijd12FXQPO3k=;
	b=mr/MdMD+iBeHdsJsxM9OUCunEFs2uzFfCj5Cn9PlPRHkxnrkjJLqPLCZfTxekvwoHF9eiL
	XDQmG0XR2x2qYgFl86Vtlw9KfTHeU1OvKnrix8j1JkCJ6axaWDCJEZ4C/KhkMCrTKbSD2i
	0//F6irQpBUzD9WO031zhO88OH9JRrE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j+wZub0x;
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.171 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774622307; a=rsa-sha256;
	cv=none;
	b=ddEX0n6/NCdgQkpzyqpFIdMZsADmh1uxEbVB/Hq9sRaGBPBwU7YYxvC5oR7B31ROyJa/CC
	p7YxGpVhCwnhLn+COwkvbzSUVWonae4RW8Bn811jFLvLHIbMdxmkOgOKfU7SO4biuRlfn/
	9IX7rEsU2cSXRN5EBnPLlIdbzVBa/FQ=
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-46701f2077cso2478172b6e.0
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774622306; x=1775227106; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qVAYAgb5FKWZkJuctDg9ra0Rbmkh6Srijd12FXQPO3k=;
        b=j+wZub0x+rZu57qA/KX0Fl5e58VD3v4BasAYj2F+8x/zvR/3unf2fKAlKfI4sdN18n
         x0DqLJrPo5ai0/ZWiMGYee1FKLY9u1HgbuguAT0t17U/yc5hGa80Lhf2EmGhaN/bbpqk
         A0WnmjFJT3/7lijzdubOuiF+jsx2V1R35L3igBANrenbxCd0RkdvQmJVaGt6k6t/0z9A
         1X2srXn4JQNXEq9lwy4SBEDuPREM8y/xgcIVBlJfpm8exxexSmIygr6Z5ZZN078b1IUT
         q5fiq2b+nwT6W8404qD2dJSB1+5ZcOsZAfu09HPklhPtBd7l7FIh+FbZjS0OOuhwx6wo
         lXbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774622306; x=1775227106;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qVAYAgb5FKWZkJuctDg9ra0Rbmkh6Srijd12FXQPO3k=;
        b=XV1u+SxmFkl87mnHvppI0D8Q5IwRxMhJLDAyoM5NhDYKT+hHuFWgU9MD2Bu8fowH/b
         7u088ngZz8/UfB+n/OUSKtcpUqZlzhq26nRBg6zmfEOdrFM7me7cWGqp7s5DQdM6VC1j
         zq/9Qfz4hBq8oqGPhSGBqvz+WJHReUxsAPPMAIHnkhcjtBK01K7XAxdTAgUPE0LgdUMk
         v+04AUY4XFNjs2nsIoFgZ7dqaXyxfOw565nEThAy58PV0YqARobUG2uNlCReHl6zD40j
         X1+wEqMpLXAck5fFcZceqS4I3ldf3wU8qd5uVLuIG3U5jz67IVYNlGLIwYnECZvMTsZh
         h0WQ==
X-Forwarded-Encrypted: i=1; AJvYcCWf3+f7cWw7iNo5Sn88x6Q5eLY9od9pGMhPwtgKDVHxCfUdqcPB/QR8b2+JwDBxCxZbLPBYQgG15w==@kvack.org
X-Gm-Message-State: AOJu0YxL3MwOdCExhArbQgDelix9gC7o6JZmiMYIUvaLkomjcgdlrmDS
	PNmF5M+JLh8U/EIt9R6IkqKV1NrBHo7Sf3ioCNuQT56aT+vBSQGnsQMI
X-Gm-Gg: ATEYQzyUjEpfcBZRCf3IJk4qyYutLsvNkgcrg5skE0BUt2+lo4zUyOivqXamuLHx8Lr
	SsUdFj04OdR7mnJQyPVdabPSsMQ7bzuOlg6qomxYyJqJtONOwMOgF1wNojXYJrqijnvecmcxt33
	xPx6shwkiBw73nhBgdAz5eWLyjw7LQEi3BjQJiY3rrfepsg7+b9DxXvCooDyLt97/XMVVEHiBPR
	KK8JEA8Cw/ynfEKjdndLeNy0dbXjXtdgyKqIH6jniyMyNDjX3pfEUOjdt53i7Fl2xkDklmnekao
	FKoGcGnUui2gvHaBu6YSzsDjoVj6EcD9VWxg5ypizKDKLlUw7GtnLEyPyVQomVZ1fkxvZuU0Kbk
	EcCPi9J4m8e657g/ox7h1aKpLjAza0gYUaFEeq6GjBTI9f2Pcj7+f2IxXePF4DwNDCbb4xxN5bG
	wqo9TCKbpFA1G+vIrIG+hluQ==
X-Received: by 2002:a05:6808:1918:b0:45c:85fa:5a3e with SMTP id 5614622812f47-46a7aa021d9mr2688406b6e.25.1774622306023;
        Fri, 27 Mar 2026 07:38:26 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:73::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d9e71f5abdsm4847756a34.13.2026.03.27.07.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 07:38:25 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Hao Li <hao.li@linux.dev>
Cc: david@kernel.org,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	vbabka@suse.cz,
	harry.yoo@oracle.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org
Subject: Re: [PATCH] mm/memory_hotplug: maintain N_NORMAL_MEMORY during hotplug
Date: Fri, 27 Mar 2026 07:38:23 -0700
Message-ID: <20260327143823.3063541-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260327124412.469833-1-hao.li@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ym9n8ynhjxu19ei46xh85he4nzb57wx3
X-Rspamd-Queue-Id: 4199814000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1774622307-453908
X-HE-Meta: U2FsdGVkX1/nWLHVvvmHG/IFT2b30ScZFMYj/vam/fo8smY4Iyq3dk4tNxQYLh7/p38+c9A0pc5pEhHnCTWpAL0yuan+GcpkAJm3mU2w6FOzwNDoHZcWPCchFrG1nxJ78COVPlpLjUf6FhL+BXUUTKPearYyd5CVaN52+zFG7p2ZtxDU3APTDujUT7dbUFxKY6Ezy557mi4sH+uvSTuBUsKljlTbAN7lJYYUC0yD/BdgttbeLLc4mI/uJL9fdgFEu91oZD7cDwOIig18Sv6Dg9vHUXXfLVW4ggcIVfyRKKub4Vx1SbfR5BhZioSRxkkgVITRZX+XLZzz4iytRwzwrFPp+asSKkTLCNuAowQTVAyIq9M8UlgfBqkmSWVL+IPgFVn6Dhb/kEaEt+5qMsMwYNHYl28xtqcKeaSm7n8zI/pD6Y7o2C67OJlDx3h9fgUdPRFagzzSZIAECoL+wZg7AzApMTFeP87oBLh/QJ9tP8YJC0JJS5T+gQaq70fZ1EKogQj8bcAwcGx2kxY+vxjfp1ijZeYMIh6oy7ZFcwFrHmSxbmYHoMfP/F7hatRWjEpxPMDl7LM2X5x8Y/yqXp2B89QAtFNvn1+cZWB3n9HqeddBbf2a4SumqpjBdBCWhnz6A/0gLwb2ukPE26QeYumeCC2nmY2MCvvWi3Gznp28II6BVeXzPjz8fLb/3G2sICtk1boJeDLAUx0WmD0zrNTXDLxH9isfr7VCfuFf21HwCoGQahZ6G+qnaLB/D3GDHmnKajn3tUIjYB1LdT0qKHg1GIhA7H/mKrH/r5x6rZP4kbnqeHXeRMJnBmSkOVU88a+WjlzJ+8/q9FBdhBD3wF0WcG88Qh+C+5iMaH2LusZ6OkTvQfGg0f62hvLRGpm5JqDCP6N0i/kIRZtvb/H8zI66tp4sQDIpOTOsPxHzEZ9yxyjNVHYDl10edSxh9TVUW4UwrDcmm7ksV8bBzH81VHa
 38HjDC/l
 zI1umzMefjmhsf/hj2j/F2VDGA4HHfQfZCt+bO4+m5DMhcqAToLCjLS/VEkl3Q1qs6l7UKZ1gnPx7ZFyyiDhdmOosB1A8D39HRiO47alfGzLFNkSUHfA6E04j9heRdoKNLNeZgb9sY1Yam2gjy43jK8ih/Dregwjr9KMLNZeUC/zGEX4A0Y0vw+3gMsQUMagqiLkBvTq4TEmhG65oTvDMJzLDQjYu/GHUOMO3iVB9p9XUypqCuvLMB2ECOQJBacIZihseDF4dpzNLBo00Uwp/WOPbuvcLKViAmPDV+FYV9HTrj8+987FdSjsvzCfwb79ot89XggYC4iH2SNX9n77vrUNZJ+ZhecNM8wU69ku0u2FVzicm3Yk+q7QWHmyCiFn9vFhBCkC0CHqYVxWw3Ukl22oZA4/UK1pgsuvME2bvJEHJFFlbX71hPTu4KheG29yo5mQa8d+ZzJxdlQISN5vcxfNxoXyVui6J4xjBe8JBXX7CxA+MVO8fFrNPqmyTYxf7gHoGNhX9gtsXJpVuRn9prS0oQvYm7lJTbYlJbKwh/AwhDgr23+6fVhwb3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Mar 2026 20:42:47 +0800 Hao Li <hao.li@linux.dev> wrote:

Hello Hao,

I hope you are doing well, thank you for the patch!

> N_NORMAL_MEMORY is initialized from zone population at boot, but memory
> hotplug currently only updates N_MEMORY. As a result, a node that gains
> normal memory via hotplug can remain invisible to users iterating over
> N_NORMAL_MEMORY, while a node that loses its last normal memory can stay
> incorrectly marked as such.

The second part feels more important than the second part, doing a quick
glance through the code I can see a few N_NORMAL_MEMORY iterators that
are in some hot paths like shrink_memcg. Iterating over nodes that don't
contain any NORMAL memory seems like an inefficiency rather than a bug
though. 

> Restore N_NORMAL_MEMORY maintenance directly in online_pages() and
> offline_pages(). Set the bit when a node that currently lacks normal
> memory onlines pages into a zone <= ZONE_NORMAL, and clear it when
> offlining removes the last present pages from zones <= ZONE_NORMAL.
> 
> This restores the intended semantics without bringing back the old
> status_change_nid_normal notifier plumbing which was removed in
> 8d2882a8edb8.
> 
> Current users that benefit include list_lru, zswap, nfsd filecache,
> hugetlb_cgroup, and has_normal_memory sysfs reporting.
> 
> Signed-off-by: Hao Li <hao.li@linux.dev>
> ---
> 
> This patch also prepares for a subsequent SLUB change that makes
> can_free_to_pcs() rely on N_NORMAL_MEMORY to decide whether an object can be
> freed to the sheaf.
> 
> ---
>  mm/memory_hotplug.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index bc805029da51..5498744aa1f1 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1155,6 +1155,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
>  	int need_zonelists_rebuild = 0;
>  	unsigned long flags;
>  	int ret;
> +	bool need_set_normal_memory = false;
>  
>  	/*
>  	 * {on,off}lining is constrained to full memory sections (or more
> @@ -1180,6 +1181,9 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
>  		if (ret)
>  			goto failed_addition;
>  	}
> +	/* Adding normal memory to the node for the first time */
> +	if (!node_state(nid, N_NORMAL_MEMORY) && zone_idx(zone) <= ZONE_NORMAL)
> +		need_set_normal_memory = true;
>  
>  	ret = memory_notify(MEM_GOING_ONLINE, &mem_arg);
>  	ret = notifier_to_errno(ret);
> @@ -1209,6 +1213,8 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
>  
>  	if (node_arg.nid >= 0)
>  		node_set_state(nid, N_MEMORY);
> +	if (need_set_normal_memory)
> +		node_set_state(nid, N_NORMAL_MEMORY);
>  	if (need_zonelists_rebuild)
>  		build_all_zonelists(NULL);

Do we need the flag here? As far as I can tell, we can just skip this and just
directly check whether this is the first normal memory we are adding to the
node here and set the bit. Then we can remove the flag and the extraneous
check. We won't do any notifier work so I think it should be OK.

> @@ -1908,6 +1914,9 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
>  	unsigned long flags;
>  	char *reason;
>  	int ret;
> +	bool need_clear_normal_memory = false;
> +	unsigned long node_normal_pages = 0;
> +	enum zone_type zt;
>  
>  	/*
>  	 * {on,off}lining is constrained to full memory sections (or more
> @@ -1977,6 +1986,13 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
>  			goto failed_removal_isolated;
>  		}
>  	}
> +	/*
> +	 * Check whether this operation removes the node's last normal memory.
> +	 */
> +	for (zt = 0; zt <= ZONE_NORMAL; zt++)
> +		node_normal_pages += pgdat->node_zones[zt].present_pages;
> +	if (nr_pages >= node_normal_pages && zone_idx(zone) <= ZONE_NORMAL)
> +		need_clear_normal_memory = true;
>  
>  	ret = memory_notify(MEM_GOING_OFFLINE, &mem_arg);
>  	ret = notifier_to_errno(ret);
> @@ -2055,6 +2071,12 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
>  	/* reinitialise watermarks and update pcp limits */
>  	init_per_zone_wmark_min();

Same here, couldn't we just iterate through the paegs here and accumulate
node_normal_pages and clear the memory here? We can get rid of the bool and
also keep node_normal_pages defined inside an if (zone_idx(zone) <= ZONE_NORMAL)
check as well. 

> +	/*
> +	 * Clear N_NORMAL_MEMORY first to avoid the transient state
> +	 * "!N_MEMORY && N_NORMAL_MEMORY".
> +	 */
> +	if (need_clear_normal_memory)
> +		node_clear_state(node, N_NORMAL_MEMORY);
>  	/*
>  	 * Make sure to mark the node as memory-less before rebuilding the zone
>  	 * list. Otherwise this node would still appear in the fallback lists.
> -- 
> 2.50.1
> 
> 

Thank you for the patch. The rest looks good to me! Have a great day : -)
Joshua

