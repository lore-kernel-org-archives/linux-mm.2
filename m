Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16634CCA470
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 07:51:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 718ED8E0006; Fri,  3 Oct 2025 03:51:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F0D58E0001; Fri,  3 Oct 2025 03:51:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DEE08E0006; Fri,  3 Oct 2025 03:51:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 462308E0001
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 03:51:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E1F2813BAD3
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 07:51:55 +0000 (UTC)
X-FDA: 83956034190.30.B070BAB
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id 96C4214000F
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 07:51:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ETHyvFRD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=55F87NwC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ETHyvFRD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=55F87NwC;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759477913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jyD5TCL95BfJRg3fvR2k1fsUPBPmEbdw11jWmd4nsj8=;
	b=n4X54p0EHoXyr4kZlRZLB/chft1edh2FIvWcghzo/gUp464h1TbJz8O+SP+62WtwAMt5iM
	EcO3nmdOspMvvZV/e6m/84aXOJK2nLbMw6n1miiMeZE2bB5ZkYbJFVTzSyTtSB5bVG5Yif
	1YVvixQQ1bYCrrJX+SKFKBmsIk6c11Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ETHyvFRD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=55F87NwC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ETHyvFRD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=55F87NwC;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759477913; a=rsa-sha256;
	cv=none;
	b=YrIMdrgSsyC2V5HwcnD9QfF6Z7/JtVBqlXdOV/fOBeab72bDfAR2idYWOLfftwMXNKEQ8w
	mCDop138EZbj/pSuTwduQGkTcqIW0prx3Jd5nMJD0weWpooJvYfnpIuVsZ5zqrfHOq/gX2
	cuWBnXOHfsE9juRG78ou0TRvGKZJKgE=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8B4B433735;
	Fri,  3 Oct 2025 07:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759477905; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jyD5TCL95BfJRg3fvR2k1fsUPBPmEbdw11jWmd4nsj8=;
	b=ETHyvFRDBZqxXlCbXzsFq+9upFzy/RsriaAFyMv9RVPnMOcpdOp8Icu2Ux0XThQSmPsdn6
	wO2J2SWjG4BKoorfhu3js2cBSTfqUE4TM8MzciAf43YaJ8yUYFO59h5qzxJpwQh9CQCeHv
	X7UlAW6oHuHVk6WYzfFSTDpN8EkGqVM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759477905;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jyD5TCL95BfJRg3fvR2k1fsUPBPmEbdw11jWmd4nsj8=;
	b=55F87NwCcfyrL5Ys8lYixDg7q/7LMtWTCVoPpw513rK1Z+aSqDs2T0WJfXb2ZwmZDkNsSL
	DMPKzKKf3VR44rAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759477905; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jyD5TCL95BfJRg3fvR2k1fsUPBPmEbdw11jWmd4nsj8=;
	b=ETHyvFRDBZqxXlCbXzsFq+9upFzy/RsriaAFyMv9RVPnMOcpdOp8Icu2Ux0XThQSmPsdn6
	wO2J2SWjG4BKoorfhu3js2cBSTfqUE4TM8MzciAf43YaJ8yUYFO59h5qzxJpwQh9CQCeHv
	X7UlAW6oHuHVk6WYzfFSTDpN8EkGqVM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759477905;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jyD5TCL95BfJRg3fvR2k1fsUPBPmEbdw11jWmd4nsj8=;
	b=55F87NwCcfyrL5Ys8lYixDg7q/7LMtWTCVoPpw513rK1Z+aSqDs2T0WJfXb2ZwmZDkNsSL
	DMPKzKKf3VR44rAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 72CE213AAD;
	Fri,  3 Oct 2025 07:51:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pFewG5GA32j4ZQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 03 Oct 2025 07:51:45 +0000
Message-ID: <b23bcee1-bc5e-427a-904b-7f3b1f4766b1@suse.cz>
Date: Fri, 3 Oct 2025 09:51:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: Add allow_spin check to eliminate kmemleak warnings
Content-Language: en-US
To: ranxiaokai627@163.com, akpm@linux-foundation.org, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, harry.yoo@oracle.com,
 ast@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, ran.xiaokai@zte.com.cn
References: <20250930063831.782815-1-ranxiaokai627@163.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250930063831.782815-1-ranxiaokai627@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 96C4214000F
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: x5etupdoygpozeac4zkpwqi4y94jhyoo
X-HE-Tag: 1759477913-471326
X-HE-Meta: U2FsdGVkX19u8b06ceg4xlTCFia6k7Rl6H4R1XB40X7vHRaW/d/EmHKOvjIqVDqddJnKMSV//d/Wb7EYoEoP+JkD8zjpfmCVeqNMSm+vk1N4z+koHqTU4hQHvqRjAy0FTn93fn0zMv3koGUqXLJC02Xf2cOVMJEOh8giWQNvUK09biA7smxCt1kBbLsO5G1M3YRBR5DK9erPe2TVsx0pG5uBin2rncqWpMGlZFJbvzdRD6zTpStXRrs6G0eUMsR6eTT5rS2bKk414pK4aQmgguNQcNa3PWdQ8AKFpc4AwO6uRUrbUVlbSsNoyxcRvTnsCM9TE5zBpEHjo5STiQDn7pmyeDH9jwAGEfO02hCUJcoTx3lA119L/hhp8gaa9KLju/TFNlxDnP1eXPv0Tozeg9quLmXfTR/CKwq+23tmCRvfZtk9Kip37dpJCP8sN8xHDAlqZqGQTr0nbgyT3jDGkpsqUaMPJUTWneznnilrKCoFUx1b8btsbtF7kt86kcVOjj8IDB2vzFLNCbjZuWIqig/p0vGpFx/ezLU6KFnXh1hNHYbQfvEoNk/Kf8j7xuDYAIH6i6xbFl77J0jPyZG/Cn/TRXn/4hcdKc58V01A27FDz6Jw7w8huYQnUHPhWRxcajoRKSvmU/AlBuBmV4giUEIefmQdg5ESIdVONQWd6lntJR56/04WoI7SlOFYgcAtBNTZIxifqvPrQhzkJWjIDDs2R0JDGK5HjGL0xeM36DUzrJyB/9PSmysauAvzZiYbVILt9xE7+ylgg8G/2jFuWitVl6Ihky4x+E65a8WBB7rzZNMLmpSIjAIGWxMzKE1S8Jds+hXll062c1HPF+JkBlHK513/7+W8smXMryWv2Ysm4j3s2+kf1+OHua3XQpsgiHgOx8axW2TO5JVrgxe8RWjBh+GV2IcyaQ+Im/dRSPZi5P28KSnWKfXid7sGzD4sVx/FJesu8zju0bc/3se
 0ddsRgRn
 zbOOok86J3eliOZUWbsiICShUZmhJlD4gCBU7BWWnSEfIUWSbTekb3178qPwqjKxnHjwWRYGtspy06Mpt94hhCOvIXXCYVpCYyXF1LLMcV02ijYu5Iua3F2dC1J5Z+qKUG8JbfdHX6KuBIOGX+Jxt+Wm59IO18cX5vQzMvxp5JyGISMANzcQvBjCELD2CBfewRLwFR2rUB9OZyyMBDO+GAkKoOls3S+XZ7Vkj3gi9hN1AGgN6BMxSeapmAZGuqvpARACbcFnc8GQgf6o/mI6lu0oGNdBHSup9dHBK/DOywlvlWsvEM7j3bvLhEhpEKjbeYj40JC8uITwi8Iq4OmOK/f3+8YjQMcH4sh565sn2JuJ20PwHvU+CgVkZPP4DTJMFJIEDBGQNgIUyxafZtgEVucoUBi8f+IF6ODlB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/30/25 08:38, ranxiaokai627@163.com wrote:
> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> 
> In slab_post_alloc_hook(), kmemleak check is skipped when
> gfpflags_allow_spinning() returns false since commit 13d872ade8be
> ("slab: Introduce kmalloc_nolock() and kfree_nolock().").
> Therefore, unconditionally calling kmemleak_not_leak() in
> alloc_slab_obj_exts() would trigger the following warning:
> 
> kmemleak: Trying to color unknown object at 0xffff8881057f5000 as Grey
> Call Trace:
>  alloc_slab_obj_exts+0x1b5/0x370
>  __alloc_tagging_slab_alloc_hook+0x9f/0x2d0
>  __kmalloc_cache_noprof+0x1c4/0x5c0
>  __set_page_owner+0x10d/0x1c0
>  post_alloc_hook+0x84/0xf0
>  get_page_from_freelist+0x73b/0x1380
>  __alloc_frozen_pages_noprof+0x110/0x2c0
>  alloc_pages_mpol+0x44/0x140
>  alloc_slab_page+0xac/0x150
>  allocate_slab+0x78/0x3a0
>  ___slab_alloc+0x76b/0xed0
>  __slab_alloc.constprop.0+0x5a/0xb0
> 
> Add the allow_spin check in alloc_slab_obj_exts() to
> eliminate the above warning.
> 
> Fixes: 13d872ade8be ("slab: Introduce kmalloc_nolock() and kfree_nolock().")

Updated commit hash (also above)

> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>

Added to slab/for-next-fixes, thanks!

> ---
>  mm/slub.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 09cbe580842c..a76275f4870a 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2145,7 +2145,8 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>  		return 0;
>  	}
>  
> -	kmemleak_not_leak(vec);
> +	if (allow_spin)
> +		kmemleak_not_leak(vec);
>  	return 0;
>  }
>  


