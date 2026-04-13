Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C31CDF34C5C
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 15:06:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D61396B0089; Mon, 13 Apr 2026 11:06:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D395B6B008A; Mon, 13 Apr 2026 11:06:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4F6A6B0092; Mon, 13 Apr 2026 11:06:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B543A6B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:06:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 62548C123D
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:06:47 +0000 (UTC)
X-FDA: 84653859654.26.11C082F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 707F420018
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:06:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ebbqxqc+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776092805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h1f0AX+m7umKjiV/9Jhxy5W1gpxY8jklxS/rJTj2XVY=;
	b=5CytdE/X68yEdGIte7EI/8NBRiVOuLMgQc7l1zZFtFeGyBMgg2omfC6pVoh1E0S6PFB70t
	XFwBiqAQeo6y+l1FX/qJSz7Y9p9oq/x0AbD0qc0e4kUYuI4/usAmLpS4ZEpt3I7me4oTIm
	sipfO9IMra9wDtBeBJn2RAsJA3T3IzU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776092805; a=rsa-sha256;
	cv=none;
	b=GEcC1m2NeX1RNE6rgPLMy0OO7UKhlIyygImvmNTjDtWtP3ApIAARCbdcZzGLqEXkRg1uew
	BY8j8XszBjOtktwnUK/VLDp3LG0tDB+LHoluRNiP2MdVMHjQsfxfDGPwjDZzSEhZNaImZC
	Lzga1PxJSKi3C1T5wtsxotSloWkjm4g=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ebbqxqc+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 41A0C42A8F;
	Mon, 13 Apr 2026 15:06:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB59C2BCAF;
	Mon, 13 Apr 2026 15:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776092804;
	bh=TD6ShOQz4Nkn+ZNt66HT4jCoXRRW5WRA+BumLhrc8fM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ebbqxqc+R4FIvsVY6sm40MMaHyoodjWD7ZsSW6ZHQqtYugUNdo141vEnDcGjNugPf
	 Sw5bl1dKACwqFkek6obR6tmWue/gxRiDQ341vVyINQ6PkH+7ARRJFhPHRo7NlERTtQ
	 6MRhcQ0lvpYCbgO3hlxSGT9rpGZ6EnQjftMhg0i07Heoz9g+OvfTohhOFMU8E1ZaRG
	 OTjlgEqLz0GPEo9XxCDJ+IoAHbWPlO253CT0hn+1Rdg7rDWk26tnBGzOMt2/EBrAB5
	 DRLF+wISJ5zC+4Ar/jKZ22o9LiCBmUuWlr6s9fxYPcLkl2hG40/GpqyTx+ZXBg0peX
	 HIhSalvQ8M4Rw==
Message-ID: <e0e48659-8ce1-496d-8b5a-f6d4416f2ea0@kernel.org>
Date: Mon, 13 Apr 2026 17:06:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] mm/memory-tiers: consolidate memory type dedup into
 mt_get_memory_type()
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 vishal.l.verma@intel.com, dave.jiang@intel.com, akpm@linux-foundation.org,
 osalvador@suse.de
Cc: dan.j.williams@intel.com, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, kernel-team@meta.com
References: <20260321150404.3288786-1-gourry@gourry.net>
 <20260321150404.3288786-2-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260321150404.3288786-2-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 707F420018
X-Stat-Signature: os3pw8ynb5u6b9ap5f6b5z3qyie7i1r6
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776092805-31192
X-HE-Meta: U2FsdGVkX1+WFeDwPnHSq8i16Fy862eEiSeDS252jl4kzk7A/vaz7RfsdEX7Tvm3XZul/GkF7igXabcQIr1+ZdZBnnwccXPJEnhDnZddjKj8UTBgk4U2SbDWQ2StYQWSmerQAoRlf+H/BQP2cm9Qh/0G8pJVE2iIhBtT4PT/CNwPan/vuiJaYFQEoXEPVQllUkRt44F3fUFKKVtAZAeg2y8EofsLsDGOef1OyJOLPrs9QqYBKpiag7E5bGHmALQc8x+/AtjXvzdsQ65cLEe1Zf0VlihBvN28pVlPrms6adAJDgLZ2qQAvsRil2Bo2oAiq3JyytXJ233dlvMtlXesn64V0L888QXhb7Ci+YNioPx5r7v7wItv9enn9RCgU57YZ8Vm+oAWARML2Z8gQQe5xeB/ujeOxgulsMzKryhTa/CrbzSJUodOjCpIL8WMlI4Ovgf4GbNeyH/tNLMsj9dmKXKsAlc6zsYZCNEXYUTzpAaZWC3/coCOPF4JbE7+W1hoqPdglPH3+Ij3lnE4vkB0qOVWqmmudHHGmf8oYz1pgsfTmgGtMSxOf+jyQqkERNT7SNukW8MEhH1lbUOFAVH3o6Lq6bZvgSKUMTV4WshRdgB+rmDaDLOPBhCoalQyitluzwVW3VYSkpyxDh7qn2AkJXeb8j0VnpClC1iOSOqU+/6zGn3rYlUVIyqy8Sg+TCK2bsdRGr6m8ZkqCpNaFLYmPQl58zVMDM12YYgg9HCQROo3cqsoCa+fmz4Zd+Ndvt97AkX9O51Ih21pVz0Jw2DaC0I4lkVinJ/lc5ZQACC+HujA6Ss3K8wgSPUOuLMAQ2XZSZ+SNHjIxVGOcR+JjstJs5BgrrKHvmRYsEhjinOfafGpJmwCVhHLnLvxVPVHbgkEFZiDcggCo/Iamlf77SR4iCD7LrS0EwRaj3H5sJU7rVEK/1pn+1jA1FVTf1M0GuFZZ4we/ow9yhRtrZk8v8j
 QFs2nbSU
 JfriVUBgRNHPGwAeQETO0HbKwT7bzvmD3/7BOW7J0pNYpq/YK0agiacPJ+mBOPXJxPdp4DlWYsNS7iXXEfm+g9Uub1qaXJS9jTTNv2qQvZzJ+bd3UDCqHiAuq4KJmEjftWrDqNHsjNq/5uTGO+QO4MQFix8Dj1CnKbF/nbm4mMPuk52/IC0SbUwBtjgpq/1ner0aIciBgE/M4/fV2h+siin/NQbIa6UJ28D1kzBtOXkuMN+iNJVunhT3N7MWuv3lTzrBIfTXHxwIBlrad1hpNfKcY74oCGCwlE38gF9ig1cxMkb+n50A6NRx8cg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/21/26 16:03, Gregory Price wrote:
> Replace per-driver memory type list infrastructure with a single
> mt_get_memory_type(adist) that deduplicates against the global
> default_memory_types list under memory_tier_lock.
> 
> The per-driver lists (mutex + list_head + find/put wrappers) provided
> dedup within a single driver, but not across drivers or with the core.
> Since the number of distinct adist values is bounded and types on
> default_memory_types are never freed anyway, the per-driver cleanup
> on module unload was not useful.
> 
> Add MEMTIER_DEFAULT_LOWTIER_ADISTANCE to replace the default DAX
> adistance, since it was really used as a standin for all kmem hotplugged
> memory.  This at least makes the default tier relationship clearer to
> other drivers and they can see where to put their memory in relation to
> the default lower tier.

Very confusing code.

What's the purpose of kref_get/kref_put if "the types on
default_memory_types are never freed anyway" ?

IIUC, init_node_memory_type() is always called with one of the types
obtained through mt_get_memory_type(). And that one always gives us one
from the default_memory_types list, no?

Why does mt_find_alloc_memory_type() now even consume a list, if there
really only is &default_memory_types?


Is there even a need to expose the "struct memory_dev_type" to kmem,
when all it does is effectively passing a reference to
init_node_memory_type() / clear_node_memory_type().

IOW, couldn't init_node_memory_type()/clear_node_memory_type() just
consume the "adist", and lookup the memory type itself?

All you'd need is some way in the driver to verify that there is a
memory type for the given adist, as some kind of prepare step.

Alternatively, let init_node_memory_type() return an error to get a
clean interface? :)

[...]

>  		mapped++;
>  	}
> +	data->mtype = mtype;
>  
>  	dev_set_drvdata(dev, data);
>  
> @@ -253,7 +233,7 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
>  		 * for that. This implies this reference will be around
>  		 * till next reboot.
>  		 */
> -		clear_node_memory_type(node, NULL);
> +		clear_node_memory_type(node, data->mtype);
>  	}

Likely clear_node_memory_type() can now be taught to not handle
"!memtype" anymore?


-- 
Cheers,

David

