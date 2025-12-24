Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69504E74900
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 01:20:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A6826B0005; Tue, 23 Dec 2025 20:20:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 729DD6B0088; Tue, 23 Dec 2025 20:20:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60BD26B008A; Tue, 23 Dec 2025 20:20:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4E86B6B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 20:20:12 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E4AA01405A0
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 01:20:11 +0000 (UTC)
X-FDA: 84252608622.27.16B11C0
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf01.hostedemail.com (Postfix) with ESMTP id 11B444000B
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 01:20:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tpin87oN;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766539210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mFObj5r7cwRvtCEi52qvIAAFXzZpppZhq6YoRYQI4aw=;
	b=ZK1LU7i8XUOqHPlwulBLOTUyRB+RHUl/7pwBWm2h9hAPbjWaMwWpV0wqoo47AGfJtRWMgY
	CZ3qqgsjumQvEOvNlJI6A5pGSrOrE5ZiZ+6Qr9yVY3IFg6zsAPi2j8QCcW+Ac2R/eWgZ8U
	Bp9j7We5VUsNLE6/txuytScGeCT2bwE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766539210; a=rsa-sha256;
	cv=none;
	b=Dr0ptOxM2G0K7+ZY/KYGCqf56d8CV9ORuwBIVnWVdK3vvqslRr2rbm2dnW2UmtbFaLI/EC
	znvSDOiW1t4nk2hdN4bAd/NhNHj3KVHPA0FBQsRka+KXqRfa2ubAhehwosEHj60t0XYHgq
	fCbXxs0RdD3K1UgP6d3/Lnt5UGHLUdc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tpin87oN;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8bc53dae8c2so826648185a.2
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 17:20:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1766539209; x=1767144009; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mFObj5r7cwRvtCEi52qvIAAFXzZpppZhq6YoRYQI4aw=;
        b=tpin87oNbCko9X9u6n8oATJ9jdvnvJAdW6xw9I2y2U/Dfzqm1UawpjvULgVUSQkN38
         fNRiK5l8LM2b4aa1wFnNZHq4wEVcMe+T+xzH6uhHjuqMvkmYJDrjbgrUIeRVxD2I8Bpi
         KUop9rEVDnnPShOOVQZ1iZNMQlkitNeY1dV71eJGwYfhckUPGwjluATRp4CIAYePHdEm
         zZQLPaJ152c7bk89ggjMsvonYGY/KmTSAYLOpslqlPEiBwPfQEz5gtFZwTdb+Mssb0Kv
         Lb66pXYQEPavL2HHWVgerK4rtUO1s89am2uatkCQzlsZWtkdv2XmWF7YLQ1n+q6X6m+3
         7SUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766539209; x=1767144009;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mFObj5r7cwRvtCEi52qvIAAFXzZpppZhq6YoRYQI4aw=;
        b=nkhbb0MHyrbtQM/XJtspwv5f+io6Ty1ZkwHLRvXpgryrLYbwvQgBUKO+p35qIgZLJ5
         +QY0voacHY996JfRvDVds0qUc1XkFof6yxrkAxf2rv/s1QMmENKyusPxAKoWbXnEuPkf
         o9xfH4flJJJAmJtHANER7wYPWoKicUYwbOxvjs92boL/+H0EU2D7Q2c6UQYU9w1cdSTD
         WOXPVfxDlhMWXL/JcmTsnh6PTYI1ZWT0NJysHr0IookwCe+CVWyN5XBQ64FMjjJdBT+m
         PYDvCTKEn6scPQZ7GQJMqKBiiOQzAVMdtRbYvvgfr483hssrsTGR4his4oq8R68JITJS
         QgiQ==
X-Gm-Message-State: AOJu0YwgPvETCjOo7JBrLwEePqsWaXA0p1ksTeWCB43QGAd43TPmVZjC
	IRNxBOgLGEzV54ErkLRhrvJOI/SfsScrJTt+EGCgpq1h6Rrae1pj8JctkHAjsyRIFGM=
X-Gm-Gg: AY/fxX5hY0i+NeHme9ZUUEj06mUvzp2oYqqY9HisJrMqgGuQ0of5iydAa/FUyYROvT6
	aFv+co5IAsEAXZT/NFHil3GMApKp76rE0dGQ+AKl/GyRYmiEsOFDHxyt29vHkdo/CgDwAyrHK98
	WlZyFPw1cXaH3Wj133dctMO1upJripBYem6ujCoA7trjt/IPchkHOnmlhiOAAmeUoyGDgb7BU9H
	lM6cVxgCz2Q1BYAQXvTZBsEOGAQ70rRjFnCxeGyRz1LZzef2aDdF+7Z7dJF2CzlkJdxE6nqTQK6
	hWyL3uP7/Xc5F/hWC07tqImOQ482sorh55Xr8bMkt8JGp80jxZ8B7HdxSXL6aCzLqGB60Xr1cap
	cTkVOVRvBS9251q+64Zqg0DWEj5M6OBjBuQ167jNDVtmvGJQkNHqHlSAcJHDWY5ihxc/R/kETy7
	5UrPQRXqtM2ED1GC7AzhApcfHZoGxsD+c9c+Ycy6OsWZXJojUPw/lw/x3IZyMiU6wWhPE/aIw/e
	GwMf/tW
X-Google-Smtp-Source: AGHT+IH83buBAwf70kUxOa87xFJIKSb6f+lCqy7gWQ1Yx6Bx1CKse53IrzVNP6DC3zlxCVvPSHTOaw==
X-Received: by 2002:a05:620a:46ab:b0:8be:9050:8548 with SMTP id af79cd13be357-8c08fbba66cmr2422303085a.33.1766539209066;
        Tue, 23 Dec 2025 17:20:09 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c0973f0807sm1195174785a.41.2025.12.23.17.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 17:20:08 -0800 (PST)
Date: Tue, 23 Dec 2025 20:19:32 -0500
From: Gregory Price <gourry@gourry.net>
To: Bing Jiao <bingjiao@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, longman@redhat.com, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, tj@kernel.org, mkoutny@suse.com,
	david@kernel.org, zhengqi.arch@bytedance.com,
	lorenzo.stoakes@oracle.com, axelrasmussen@google.com,
	chenridong@huaweicloud.com, yuanchu@google.com, weixugc@google.com,
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3] mm/vmscan: fix demotion targets checks in
 reclaim/demotion
Message-ID: <aUs_pLTcsVK8zf0g@gourry-fedora-PF4VCD3F>
References: <20251221233635.3761887-1-bingjiao@google.com>
 <20251223212032.665731-1-bingjiao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251223212032.665731-1-bingjiao@google.com>
X-Stat-Signature: gierw4wbz3986rabrkp76f6kzj9prgu5
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 11B444000B
X-Rspam-User: 
X-HE-Tag: 1766539209-48611
X-HE-Meta: U2FsdGVkX1/xCZSzygq+zEC38foQgsTnkpEBgz+RFZJvMnz8osR2ekxl5wR4p27UrspCPnbNL4r7mSgY5EfDDYB3HGTxXy8YGf8Cnl/0N3LliByx1ZD2QhiVpbB1ZKvZmtuJSVAmF8lXCNxMQQHHy0UH/YQgfAYEnCfqXPC7mHztF9hRDSyXujkxBvIEplQz28PjT4LLT2bVgWtUGAWmvijLSFyjQz85Sgr86R4oRaQRi1UCobTs+/2wjO5AZIuZSY7uK5IHA0GqzX8XgYbaPKOyCoqnd4sp2U9YoPZxnWJLVRqDLWcZZB+Ap0vQ24TXOIRQ1GeP+Rh6YLfp48s+QqDGzpiVYZcvgADPAGIFbPovNPsNbu1DuT+c6+LRr3LGQphfnLCBcAa/Uv4V4oKgsk2MlrMN4YJfpUtIQohBe1WB4qKhHu+cXd1euas1oRArKVz3z7in7DsOVzhoi9MjeIWi+e9IDyitQ0U5wFy/eLzh8BokOIE/lIFFBmC26R8ISdsIpml4h5BC7SSe2u2EWRCcgB+cKTQKMcIbyPy3jOawCYP7VZHMUPs/L76uitPFt51FeAAS5PbZkKtcFA2a5ii5Nw7rekWzMnQdNt9aSBasRXXrBpepT+G6wITEmZRqOVo8v5LNiBZTtlB6hXU9lxZox+ua7vYRI5sWZVfnwWbIjX1y+cBgud2BY0SSD/rc1xkhxXIeN5bU47Dc6fWqi2/i2e66+TNMiSNTURKCa7vDFgMzGxewzXe2mFNZki41xMBnq0lKyNIliSLgHSXD7Ooy9ZkfWzYwP7nTqCx1Ia179mUtcGGz36h2cGcxGzSUwSPGRw0dmCTrsHMKGR7kEyT2XYZVbu8+qou4fSs9JaAysP7OB9VkfCAkM4yvNBfrfzw90n7NPqHtbfOdXqjFiHnXeU6KCNivN+HPXOlsfhgmJujBe+vD1ey4CQ3JCY7icYps9pVs/VCubqY6MZO
 5Sd0bjXN
 CfXdE7LlAMfQk0qFkFx14xMDDRHimXtlKGKJPMvtm0aIaaVLzFAy/Iups2JbfPVcjq5bQFuXrCgSuzPDJspdx1kyT31Vlc5acrdpyXihUZhYglM42keQe+F8TfipkmqtpZAfe//aCgGrN2ou9PUzyrAlVuAEDOtu3oxRqJ86MA1dWA/qorgPzN825591spJr6fwlFeZw2HWNyWnaARDMEw2SnuIy1ik243t0DDTXpN14/SV/9cMDPdvpFqtnOWa78/a9WXydlurZSultwsa8J3DkoLJsyIs2ePXQjHGNt0XGCOjvH3dPZk0a+wcXM/uTUptxjW0+G8s4Ri8U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 23, 2025 at 09:19:59PM +0000, Bing Jiao wrote:
> -static inline bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
> +static inline nodemask_t cpuset_node_get_allowed(struct cgroup *cgroup)
>  {
> -	return true;
> +	return node_possible_map;
...
> -static inline bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
> +static inline nodemask_t mem_cgroup_node_get_allowed(struct mem_cgroup *memcg)
>  {
> -	return true;
> +	return node_possible_map;
>  }
...
> -bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
> +nodemask_t cpuset_node_get_allowed(struct cgroup *cgroup)
>  {
> +	nodemask_t nodes = node_possible_map;
...
> -bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
> +nodemask_t mem_cgroup_node_get_allowed(struct mem_cgroup *memcg)
>  {
> -	return memcg ? cpuset_node_allowed(memcg->css.cgroup, nid) : true;
> +	if (memcg)
> +		return cpuset_node_get_allowed(memcg->css.cgroup);
> +	return node_possible_map;
>  }


node_possible_map or node_states[N_MEMORY]?

The latter seems more appropriate to me since node_possible_map will
include offline nodes.

> -	allowed = node_isset(nid, cs->effective_mems);
> +	nodes_copy(nodes, cs->effective_mems);
>  	css_put(css);
> -	return allowed;
> +	return nodes;
>  }

I saw in vmscan you check for returning an empty nodemask, may want to
at least add a comment to the function definition that says this needs
to be checked.

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index a4b308a2f9ad..711a04baf258 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -345,18 +345,24 @@ static bool can_demote(int nid, struct scan_control *sc,
>  		       struct mem_cgroup *memcg)
>  {
>  	int demotion_nid;
> +	struct pglist_data *pgdat = NODE_DATA(nid);
> +	nodemask_t allowed_mask, allowed_mems;

Only other concern i have is the number of nodemasks being added to the
stack.  Should be <512 bytes, but I've run into situations where builds
have screamed at me for adding one nodemask to the stack, let alone 3+.

Have you run this through klp?

~Gregory

