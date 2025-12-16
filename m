Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D891D5E13D
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 18:50:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A3546B0088; Tue, 16 Dec 2025 13:50:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75AD96B0089; Tue, 16 Dec 2025 13:50:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 683D16B008A; Tue, 16 Dec 2025 13:50:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 560356B0088
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 13:50:23 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F050013BA86
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 18:50:22 +0000 (UTC)
X-FDA: 84226224684.20.CF1AD23
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf10.hostedemail.com (Postfix) with ESMTP id E7079C0013
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 18:50:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o5EDx6I+;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765911021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZoRglrMxu+eacAPa08o6kdXKC07L0bqVNlSWnxZl7SA=;
	b=tpI0U9aFbHXUb5jM+N/04WC22N+dDVv1RKyIBBIlYeLgk69bXQ2YdC7xxEIrbIjoU6V+du
	OeQHYsSjLv9xQmWvFje8PrKTZGGSM44mHFIqnN8RLnQ1zonItGN7w+eoSUU/v5pgXi8aJ7
	9U8RhfPQLcgIdB6wcsNnXGNypzbqSaQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o5EDx6I+;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765911021; a=rsa-sha256;
	cv=none;
	b=t7T3+ShItuHWPsI8l+WHiXQwIW0Kzga5hs+eJfPDziNmokVls0sNpjjVeGfDyTo4LOvNKd
	bYoKxggsR7iqBTDwkg9fiHI4guH9TMxpSylScxSj1SeCFjdWNRHg9I1/CvUG2HgyuJzGSm
	MsHEj3hbP93bxtagWIM5s1Yc6iBfZNQ=
Date: Tue, 16 Dec 2025 10:50:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765911015;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZoRglrMxu+eacAPa08o6kdXKC07L0bqVNlSWnxZl7SA=;
	b=o5EDx6I+vAidYIyuKW4KOdyNctXcWwX5Au2gYnCqREfUxuVpua0PrSrtTTEu6PfH+n8okX
	IsHY7qYBvws10cXUE2ZgH1gEhlsLW/PpFJJydiKDgcA9JKxXwbo2DoD8BdCIluJYmfxLN4
	iXvza8+ptelhHI74JQt9PkrUR97w2OQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Thomas Ballasi <tballasi@linux.microsoft.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm: vmscan: add cgroup IDs to vmscan tracepoints
Message-ID: <stm4ixcvtc6bwr75fos6w6anfaqfgjpe2mtt76zfrb2y63bat2@grvm7kzfz47n>
References: <20251208181413.4722-1-tballasi@linux.microsoft.com>
 <20251216140252.11864-1-tballasi@linux.microsoft.com>
 <20251216140252.11864-2-tballasi@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216140252.11864-2-tballasi@linux.microsoft.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 11j636aqx94s5meefdfpjssumuwtspwi
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E7079C0013
X-HE-Tag: 1765911020-307530
X-HE-Meta: U2FsdGVkX1+1u+l9y7Gp6Ytb4wMGalTj586vdYLd9Ymv4Jxtw3Ux13FfCp9U/N+Vw4yisdwuRKTY+rXAJGYgGyL0ZV02s7syZnsDpsj++Iy4/TDjODn13m3CKIBq5SU6n909evgrD3YHml5fw40GpArXuqesVd14OWfMyvgNi0fXpFwkv5LsADr9g+bZHfqhkU38GZbYy5FZGFmHelH8WW4VoD3d2rMDUNglsL2lhByK01AbxPafIb1jT5Do09FsuYHv+Zn9FApDFPOv4TE/otW1L/1M3SulE5Jym8OpLcFR+cgvEnBsEuxF9wkM3rPnKyPFWu/Q2KXFd8XsClbtq96TCG2Pi3zAny6zxTjOBLewdnK2EAZs75QDPi+taAsy4hkn8IfVAlBYIcveihfF/RIAc/2ZKaOXkeJahRfIIkVgEr0j98CrzfgiexL+PYGDfuGAAnW81YeMSQ08635eSLbuzVLjEvmdSbGgtJO7GDDb7uCUKMs17KAe61XKtEd7hJOeo4JQrkpWjMYgxXSAiywTLfU4Se5aBqfvW3VK+Hcs7kKIcj/KxWR0TM55qQXkf1FkZE+f0g3v88joW46JIxZYfJOdo8SCPKMDyHnbD6VvI/4SpEq4/ow+6oKGppSijSuQpkEptlkqJVYA0uQt16NisAB6FrSXANptXSMQjWfqF2JFPG1JuFF/PatfO8Ety4v++w1gAxfR5tlq2DvwIWJu05QNNMaILTL0OCgEfbk5oSGBKi+K8Eco9Tux82xtGVI/zxbSBtAScu4z7C/Ipt6LTSKiZeTfb+qt9C14/UaBP2j7CPFafqX5LsgT8lHrOQz7jvt53ptoyGt78UY3Ic9eDHpgL91djfK7OdCKJ+Yx0+EdaWzmR7Wn0gtRm43dYk67ZH7fGdoK5p6Vl0Igwx0nftUStL0XGqA9D829dy8PM7q/NkwDTA/F0mxdqkZdx66lFUdTos3/rfUvnle
 FJQ99hHJ
 BxAkO7n6fK01Wpiqu9/Xt+FEfyqlJQeU38r5OdJ+WdvefDeKv/pi3r6N8ghu3ibMejMdvvrV16jtYIs+Dh7YzThccYtiBJ8DtjjC28pEHt78Vl4K59Q2RX7obssQI/Dm5Ki9M89RSSScrNyAac4pLr8Vn6RnA4LVKmmK3CBeRT9Xb1goA5RYz1gmcZLBUItRo92oMvbbDknxBcWa0OUkek6Ilj3MHtbl8UaBq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 06:02:51AM -0800, Thomas Ballasi wrote:
> Memory reclaim events are currently difficult to attribute to
> specific cgroups, making debugging memory pressure issues
> challenging.  This patch adds memory cgroup ID (memcg_id) to key
> vmscan tracepoints to enable better correlation and analysis.
> 
> For operations not associated with a specific cgroup, the field
> is defaulted to 0.
> 
> Signed-off-by: Thomas Ballasi <tballasi@linux.microsoft.com>
> ---
...
> +		__entry->memcg_id = sc->memcg ? mem_cgroup_id(sc->memcg) : 0;
...
> +		__entry->memcg_id = sc->memcg ? mem_cgroup_id(sc->memcg) : 0;
...
>  
...
>  	trace_mm_vmscan_memcg_softlimit_reclaim_begin(sc.order,
> -						      sc.gfp_mask);
> +						      sc.gfp_mask,
> +						      mem_cgroup_id(memcg));
>  

...

> +	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed, mem_cgroup_id(memcg));
...
> +	trace_mm_vmscan_memcg_reclaim_begin(0, sc.gfp_mask, mem_cgroup_id(memcg));
...
> +	trace_mm_vmscan_memcg_reclaim_end(nr_reclaimed, mem_cgroup_id(memcg));

Please don't use mem_cgroup_id() here as it is an ID internal to memcg.
Use cgroup_id(memcg->css.cgroup) instead which is inode number and is
exposed to the userspace.


