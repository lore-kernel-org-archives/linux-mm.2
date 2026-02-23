Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5656EA4FD8
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 15:58:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9A2F6B0089; Mon, 23 Feb 2026 10:58:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C48016B008A; Mon, 23 Feb 2026 10:58:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B29706B008C; Mon, 23 Feb 2026 10:58:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A00366B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 10:58:51 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 560E31B526D
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:58:51 +0000 (UTC)
X-FDA: 84476179662.01.787192E
Received: from mail-qt1-f195.google.com (mail-qt1-f195.google.com [209.85.160.195])
	by imf20.hostedemail.com (Postfix) with ESMTP id 412631C000D
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:58:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=HygMaQbI;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.195 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771862329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gJlVVB4cdcMuEQ3h5OcyXP3aNJfq5CueqYlheuqsqJs=;
	b=YDjvWpZL820TpafAHMEvl7dkNOuvidAN6BtS6Wgf1RzaFpqgIcC2tvgHTykWoUrGKm1yVI
	TcvxcNfFL6oQp5fjvWmZpjtyBM5S79TQJXlnl0pI6LqtxvuuDkehHSQTl2Sf+h4IW1hSmm
	V5aQESggls9lxrxg/nMuNNCO/uXAHA0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=HygMaQbI;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.195 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771862329; a=rsa-sha256;
	cv=none;
	b=P1XOGidTnUBfpaHS8Z2Z0kxnVCQY4rXfEZxdIedJeO/nSMifAtdH8NWfE3xi1k6pYuh9p7
	CysD4nElPbGurAy6x2sIRPlGqwmkXb0imIaWtPFLfbnwciIjXdbm1EyKunx0oa8Fn/zKb/
	Ot3I3IXcm2xvIvtlpFxLge/cB2cns3w=
Received: by mail-qt1-f195.google.com with SMTP id d75a77b69052e-506a1627a09so25739341cf.1
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1771862328; x=1772467128; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gJlVVB4cdcMuEQ3h5OcyXP3aNJfq5CueqYlheuqsqJs=;
        b=HygMaQbIAmV9dDTa4d+Iz9FV2HJztbzRdPz0w8aud75jGKmKOdS6e4tsp5JmbVuBIu
         izbNWgurE6b5MtaPHd/g82UC0fZ8vl011mp6vxcz91aKRdTsUr5M7/MwZYRyAPqzAVWe
         w1fJMS8OYoEXNh8o1SytWZWvH1zDhAviP8kehAyew1fQsf5+FmQNrbmQF3qvZTXvOLNl
         BM4IGULNL0MBOAGXuVEl2qK8X6pKDd1qcAr1yMXc9120KoLe2X3nS8HH6Jd6fe7e3lmb
         dIJJ44gGf4dZNRqqETP2+JV/IYEQd7OMDNRNg2HBtKHXTDvxyfF3+p4FMQ+BpwtNnv69
         c3sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771862328; x=1772467128;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gJlVVB4cdcMuEQ3h5OcyXP3aNJfq5CueqYlheuqsqJs=;
        b=aJuJah5Kw1BhKLkPtj3YzI0mZudzta6u+PsE51f8kN4/yewU+79rzrrjAGAeXMSNlL
         PxDunVCtU7/5G2uHu7RF+Mb298vFHNwPqTlDK5964g7dVWpImK1D3AdBZcwNKTauVbyi
         QBY9c/6jDfxoOynp7UnVir1fmbsEejqRCg+vM6ds0RF6pgKezNDUv4Uq83T9T9j46yn0
         GGkeOvj48+Xrye9uKeWI+fXciTP5zpgG28c2bDbUvNhkVCLmtBMUl/CRWAlufWzEHAR6
         jTecErzm6YrAcNdCjUf6mnRF3znzMIHWpLOKToPv/5K9n0nfRA/DQf5+wwOYCCilcibk
         stJQ==
X-Forwarded-Encrypted: i=1; AJvYcCVhXmjwy103vrT3orsxUR0fMMItLVln/qIdQmYXF/0wS5UM0eM46YOtDy3jgDklZUXmz+31QA3YvA==@kvack.org
X-Gm-Message-State: AOJu0YyL95KcLv6JVPqQRar3aoKa5CtUXgkmlo1doauIcU+JP60zW5xZ
	fUokQX8t7+dnBqaH3x4A831bITAW/aeWZ4x9nOEOyXk276u+Xt9bTkTyzgSEQyPCC0Q=
X-Gm-Gg: AZuq6aJbYYfs01pWC4ZgDZ5DFHaorBFnltlghvRMDOegh6gjeGmQAz9SUK6CP22kZYe
	gZ7rINaGvF0MsxQBRKPFy747tFT5xYzReq0g7sN4k3M80IRwibpMZL5RLdahjur2/G7/7knN7r6
	8O+oXszlWXeOOLUo3jy8MESs0fWTimpBerlNHMYQxZ8ZU83MMJ0SvjqljlQHzWrjQcYy1rFlMwF
	vm+vGuuc2mQzJKw+vNxVDc778l2s2ow1ZFI8BUue+PfB10WN5vUDFGTbKz9DlXsa4wXhuHBpvdu
	THjbEh4jjcE/9EKbDKkyOVHQ6KZJdWudo6DJq2aEKLXwa7nIFNDa9LnEy07QDrHFR41+9qzLRaB
	du982o5eR6Qh88FjBz0+jfMS+BPl4krRNPuoFA9hLNS/gQXiXUGXWF2ysuqnPCSPp4nCY4IbdWA
	uXa0wmS/AJ72fSfwFjS8ndDg==
X-Received: by 2002:a05:622a:181b:b0:503:2d06:8e1f with SMTP id d75a77b69052e-5070bbcd9b4mr109231921cf.19.1771862328143;
        Mon, 23 Feb 2026 07:58:48 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8997e24627csm71706556d6.29.2026.02.23.07.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 07:58:47 -0800 (PST)
Date: Mon, 23 Feb 2026 10:58:43 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: vmalloc: streamline vmalloc memory accounting
Message-ID: <aZx5M2WYMK7pKhC1@cmpxchg.org>
References: <20260220191035.3703800-1-hannes@cmpxchg.org>
 <aZjaxAi-AzyOYzNT@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZjaxAi-AzyOYzNT@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 412631C000D
X-Stat-Signature: z8ngh8rxpugajc1j3jueqbe6dac6z5c7
X-HE-Tag: 1771862329-339218
X-HE-Meta: U2FsdGVkX18aqSNHeQd0ZMNbXmXoKVrHMjGEQfVbuytQesbnJ/zvfwYiOIStBL3K/CyI5By7SPf6q59cNdnMdertcZBmEpQYhJy46C7aXq4Fen0KmKGN91GKamZzOZ09qRHd6N3ZU4PyAmKOhbpgsoWqSONkgTUTImRkhtvOhcQ/twBX5RjdukYt5NRfDtXYhHrW/vmj4rfc5cRzPCeJVfKP6WVQ5rQPBg5G36tIrqL6RLZUFYE/BhMC9dLiH+NIIYkz/JmGpz9LTXqhW/Vx7PD4DkkWn1W/oKkBxWu9LLnBfGgGesCcqDDXfpr+HivXzTVFm+NyKrn6eDJOzOOJesq69Q/ZZlmxP8NA6LEb1nSxIacS2CUa0peNEIQCHEWjOYSPv5m5k+iBgf3awJKQ+Ld6IVo96QMqlVzrWWjs+97RTxndpHwZxCc31wuceg1KwaBMfY2vRBIri+wFIdf8rp64VuQ8BDzKI3nM+x5HLhjLyOJArZaaRm8tSgc8IKc3hqTgWjl8nHek1SZjbsHBXwWte2uOsrA0s4Sv9PMCRIv6MsG2vW5XmwnSu1XWWotGZ4m+cJKniLY/6Trz7h6H8avgTVz9olsrpgrp2T2Oltz4CKHR7i/obsPL88nAPODxQPQrLHGcoV07VYX3Wf8kerVg2YGdPRUN5O7+Sp/eY06hLG8DtsfuQGugen5khrNd3S88/UOdqEsI+KNjnlqFkzG3WJUSuos7rSR4xP5qmjKcE49rscmiI5S7HoyXTN5X7rOoPlpY5Q3NrE+Nufp/45DqUTXPfimwivL3riPsKiSQgz9TPQtcFkgWI+fbu/Em4JHpWo2DXBfAerI1TTAoH7DdvdGGdpmkq+fJ/L/a7XugUqH1J2hhm/OMC3zCDhMbDBLqg+8IW/ozpotDRHTCJC4jCY3LsWKf1hhfYEHzdXwYd/9F51cR2U48lB9qEgnNFlbEH+rkLzVGq5Ho+ip
 pZPOicBq
 kzm2tZRx9D/MmTd9qQM0bDhp6P24H8ZNCU0Td8ZJEHQ7WSRWzgj9BABl7QQyItqpYz0Y5m+ZZe3uEIKULs/tp2VhrAyIGNjnF3opkTioErAdB6VmGvwnL8m6eMPbGGMqu6nl9zvxgN6IJT5/0IfGjxSv/Rnmtct0SkAJZdX7NuDpg0uPo+BgDCyGH5uHO620tr0GyeZVqWePp+stjd+MWB+pv26wYr4r8IdBLjwtxGNEXNMVFDmD5mJJ/ble/Rm+mNXEKbXWcH+eKGBIQaUbXNP2wYAOn1L29QrxkUlhLe7fpRtUQPNq2YT8miGr0C0+JRKKVdmXL86lgt+C9wF535DY2ea0iIbsQ3EKivig9qx2zV8UbO/FEqDUexopWzDjUKBkuYLAJI9VD6AMFe8CPuu8b2TQjxwD0vXMs5BRAQWHEKQ45tFEhh2Oe+ZyVhTclpM3whlAoeOSNWnRIE7Fjv2ZiVP1O0t8xLJc+hs3eGabgV1795KGuV3mbW8/wckyYco4iN1IzTmR+CPoI3jYiGpSKBlyqVCoEB3pEn+tLeRdDl+fjJruiW5VUTw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 02:09:28PM -0800, Shakeel Butt wrote:
> On Fri, Feb 20, 2026 at 02:10:34PM -0500, Johannes Weiner wrote:
> [...]
> >  static struct vmap_area *__find_vmap_area(unsigned long addr, struct rb_root *root)
> >  {
> >  	struct rb_node *n = root->rb_node;
> > @@ -3463,11 +3457,11 @@ void vfree(const void *addr)
> >  		 * High-order allocs for huge vmallocs are split, so
> >  		 * can be freed as an array of order-0 allocations
> >  		 */
> > +		if (!(vm->flags & VM_MAP_PUT_PAGES))
> > +			dec_node_page_state(page, NR_VMALLOC);
> >  		__free_page(page);
> >  		cond_resched();
> >  	}
> > -	if (!(vm->flags & VM_MAP_PUT_PAGES))
> > -		atomic_long_sub(vm->nr_pages, &nr_vmalloc_pages);
> >  	kvfree(vm->pages);
> >  	kfree(vm);
> >  }
> > @@ -3655,6 +3649,8 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
> >  			continue;
> >  		}
> >  
> > +		mod_node_page_state(page, NR_VMALLOC, 1 << large_order);
> 
> mod_node_page_state() takes 'struct pglist_data *pgdat', you need to use
> page_pgdat(page) as first param.

Good catch, my apologies. Serves me right for not compiling
incrementally.

> With above fixes, you can add:
> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

Thanks! I'll send out v2.

