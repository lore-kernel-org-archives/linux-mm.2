Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 551A9C44515
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:48:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 422856B009F; Thu, 16 Jul 2026 10:48:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FA176B00A0; Thu, 16 Jul 2026 10:48:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E67B6B00A1; Thu, 16 Jul 2026 10:48:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED01C6B009F
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:48:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7EE5C1C012B
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:48:01 +0000 (UTC)
X-FDA: 84994919562.19.6FC660C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id B1A7840007
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:47:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="o3qex/Op";
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784213279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gqih1PWPLfrxUcGFx1xd859LCOuVLJkxmPXs0LVVK3E=;
	b=g4G2DLGzf4/nR83NHgmKMWTw1fNFJmNqHaRb6/nfNG+w15cXUbUrOVIYaMznchcFynuRMN
	y9IKFnjm0Gx0T/+TYjb1dRa/ChjUv3fo81kVdi2ougD8lbVpycuz7RN7blrEUL7azzdP84
	y9eL69LwwkuEv8yweaoanv9Fb3Wu3pk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="o3qex/Op";
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784213279;
	b=7TRAqhXqV6nrn1IYK2yWCRjWIk1mwBX/uPiZLEednq1CEez5F9gZ77IFghcS9wtYK7TyNT
	/WMFVhFcp3zbGQl+aoGnY0sr0XdrQBlCl4qP+dWMCjhKZ67H1W9awrLrcOUSzarOSL1EU1
	Wx0mQ0ifWcw7ZHtkXGWI9nTQtHj00eE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 80BAB41680;
	Thu, 16 Jul 2026 14:47:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95B61F00A3E;
	Thu, 16 Jul 2026 14:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784213278;
	bh=gqih1PWPLfrxUcGFx1xd859LCOuVLJkxmPXs0LVVK3E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=o3qex/OpMM8/2lZGb3DNxYt2UeWKGoolYnOmw3tnZp1VaRLMON3v9nZusDk1IO1Cl
	 79sp7ZYixCuEMwQ154T9Z+DDLUH+ApRnc/HyOgpySTOy0xTOtetN0DYx6NHwDfKKyw
	 bwFh2sslOwUNVzmOGtSmmKozYC6N5q6nGCxi48yXEzLTO0fxYza2oSpEW43Nk1KOOs
	 CaoMfA4O/ElaZP9OVJMi1CTJcMhrQoxTdeuZOe97vQ3Oi9/OkQOhh1uA2yZfHX3bXM
	 JYzuNJNw3uzMn/nD1sAG+HLMCx3eJZfngyMlvxDZ7noiuYfTOVKsWbUxuQce4u6xEY
	 VQFN3QiVgX3hg==
Message-ID: <076dc6ce-4895-41d7-b9c1-9ec872e7c8b8@kernel.org>
Date: Thu, 16 Jul 2026 16:47:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 09/12] mm/slab: introduce slab_obj_ext_has_codetag()
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
 <20260715-b4-objext_split-v1-9-9a49c4ccf4c3@kernel.org>
 <CAJuCfpGkpe=5O_vW9VKqKFxrBO+QquCD+mXth_qeUSqcWcW6hA@mail.gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <CAJuCfpGkpe=5O_vW9VKqKFxrBO+QquCD+mXth_qeUSqcWcW6hA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 771qo867uztw84j9hxadnufhkijbdsxo
X-Rspamd-Queue-Id: B1A7840007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784213279-37316
X-HE-Meta: U2FsdGVkX19weE07DeqrPJkapKqG867TcTaQcxCUZnO0pGLm2BWVKGGQKdsjHEJPuwCnlSyl+P0YBAptzJmsLLsDG4rbHN1pIXOPDwL+TBKrS8IGU6/pJAfMfVj0B8d0/2LlfUmWyQ0Owc1vjBrKzCDbEdi1ZHAbA5mO4xkXHDwNwgsNTSGawopvDPlFQQf3JYBlnc0XNI2+B0zC1Fomlw1Sg4lE04ZorROQkTTL56gPx5+UfgWDArttWR2yaf0QM8ECF+YGRHH4V1sQnQdqjccUUQ9Y5hbvR4t/WTegXocXEyOkrusj13/GRCFKVetMKNUsAPPjdKL76vifL9qJpa15snVDtneymFDN9zrTSyJVzCsBxlBluobtfhaUZ8RQdGvYKNvIw2is4BmTgYoX4Fr8z+8FtLzewwJw/DF7HvIOupw/NHGuDO+P45I5OW3d+SVevrFaq5XYvVGfognOTmX0S4+xlQLiv0pU6VNyJkXdVzz1pvGTYm4wYq/3sCj566RbmUUgW6S8F9/0tXGS0/TzHOY7OYfBLOzp5CbZ7ogwpAUtpcoo+Z+dhXDADS6s8nPgrNRhjUsnPv/Om/3tB6UVA9vxps/t7Ux0OpfqsEFC3M+PeHagvHG+wzOUWzrLt2WHPOJfiU3p/iiRxsgeANLqNIM5xtO+tLwKJhpbb5zZOdTFukRl8LK3vcArtY/i1sqky0MkgUWYo8911V34wge2EkgWu2JDUZePPYpsQXJMa/27GVsg2nC8aPhp6hMlnO9rUXpXiozbdzNXD+AR/RplMr2DKm0POHec6ob//soyrXiUPmPzlMQ1mH5xONU3BY4M3ai/hLoGvJVzU/egX5vo2rY50w8jazQ79OI0c+G8PFmnDDq3+T7DPDiHcm+llyRRc1U8q8kUImLBufSfvZY4SGdwThLQxlugLhwiVS9/f6Wuln61yUr9xvQNCBHFajJP87vETRcnzbIUBd5
 CT0VSWKx
 PjDd43a8Pekoj90ubE+laCYT+3Yrzf601fGRpd1EnEKMSgQCcRibNVVzgx77kVfc28ne5dsQ7OgHKC/6piek4kXDBJdubG7zpfjqYQ8ZcdcW6Vy6DUgVIf4uY2sL/Fl3fsEZDGoUbMnRZ/9C7Gg5dkM2heK5s16qBTmFygjJvTdSihdoxenZFg+Z54RS1ImFKYYNfgLSa8RZ4rkeRaPB97+XF3SEQ9FZQZ63rjxYltPraUMiytBrj4bu3c8uUtefveoo55u9OQiN3lOQkgo2Y61wKTOFwtxkaV4mfEU2i7tww3LAq2PBfU04VawGLQh19YhoHxvtkJkA1ml8EAKqoIO5fIUg+QzRujKc+cvG5HAGrGmEOfeerXUhxBhkWuahNNIw7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/16/26 06:25, Suren Baghdasaryan wrote:
> On Wed, Jul 15, 2026 at 3:11 AM Vlastimil Babka (SUSE)
> <vbabka@kernel.org> wrote:
>>
>> mem_alloc_profiling_enabled() allows evaluating (with a static key) if
>> memory profiling is currently enabled. mem_profiling_support is a
>> variable where false means it's not possible to enable it anymore,
>> because the system was booted with "never" or it was later shut down.
>> This is possible to query by mem_alloc_profiling_permanently_disabled().
>>
>> To make slabobj_ext array size handling dynamic, we need a snapshot of
>> mem_alloc_profiling_permanently_disabled() early in boot, so that's not
>> affected by a later shutdown. We also need it to be static key based for
>> performance. Neither mem_alloc_profiling_enabled() nor
>> mem_alloc_profiling_permanently_disabled() satisfy this.
>>
>> Therefore introduce slab_obj_ext_has_codetag() with an underlying static
>> key for that use case. Its state is made to reflect the result of
>> mem_alloc_profiling_permanently_disabled() during kmem_cache_init(),
>> which does happen after setup_early_mem_profiling().
>>
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks!

>> +/*
>> + * Make sure the static key used by slab_obj_ext_has_codetag() reflects the
>> + * value of !mem_alloc_profiling_permanently_disabled()
>> + *
>> + * Any later mem alloc profiling shutdown won't be reflected in the static key
>> + * because obj_exts with codetags might already exist.
>> + */
>> +static void __init slab_obj_ext_has_codetag_init(void)
>> +{
>> +       bool key_enabled = IS_ENABLED(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT);
> 
> nit: This seems a bit indirect. Reader needs to remember that
> slab_obj_ext_has_codetag_key is initialized based on
> CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT. Wouldn't below code be
> simpler?:
> 
> bool need_codetag = !mem_alloc_profiling_permanently_disabled();
> if (need_codetag != static_key_enabled(&slab_obj_ext_has_codetag_key)) {
>         if (need_codetag)
>                 static_branch_enable(&slab_obj_ext_has_codetag_key);
>         else
>                 static_branch_disable(&slab_obj_ext_has_codetag_key);
> }
> 
> It might be less performant but who cares, it's __init function used
> only one time.

Good idea, will do!



