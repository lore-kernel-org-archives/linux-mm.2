Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84867C2A07B
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 09:56:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACEA36B0112; Mon,  5 Jan 2026 04:56:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4AB66B0113; Mon,  5 Jan 2026 04:56:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F83F6B0114; Mon,  5 Jan 2026 04:56:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7CF066B0112
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 04:56:15 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0F2191A0EC3
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 09:56:15 +0000 (UTC)
X-FDA: 84297454710.21.51A2FD5
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id 879F6100004
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 09:56:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E7i5Fpwq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yEIVvlmN;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="R/ywBHxS";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=I5nxatXx;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767606972; a=rsa-sha256;
	cv=none;
	b=5wmO2Jv2FFxtwEXEEVFLe/yFs3jhczRFwxfEELAi/EyuiWoEOh8MFYWzc6878fM0HP51sD
	wAR1TxdHeC+qqc4dXIwMfBR2Oku2UBpx9/6KZJo1xdkZgce1puw+QLBPssSSyISdWQAzho
	oTtCT2akOAQ19MDpxqDnxrWyTRZ0tcw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E7i5Fpwq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yEIVvlmN;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="R/ywBHxS";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=I5nxatXx;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767606972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tyzvGt7ijyC3iXfUIAbqPhVhe1mSFkUEVg0NYFf04bY=;
	b=yC4evzxMc1XW0kX9adAEHco0BQ+RllfKIK7VFJxFIcHfYGEZIALmNKWaBa2UDBC8+TNStr
	wO7crfM4pnx/Gqj0OIzoflhGmF9eeTZQqkPcghMdFctO6PdGZcKpbk62ZDGvtK4ArWK9E1
	BC4mA7kMQnpD/YNTSP+0yyzlREyL7hg=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CDC695BE34;
	Mon,  5 Jan 2026 09:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767606970; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tyzvGt7ijyC3iXfUIAbqPhVhe1mSFkUEVg0NYFf04bY=;
	b=E7i5FpwqEfF3sSQzIGa7nSu9OuUjOpt2iscA238PoyrAhEf0SP/BNkLbXTdbL8pSyzkLne
	VnSoyAfskyeFAygapvCLDTZGiEUvlx4V2/N5ue3AJ4YbQKnT6ZC42LKkdF9RjbNdFepuDO
	/8A5WvlsBta30yu04B8EYRX0V9WTpXA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767606970;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tyzvGt7ijyC3iXfUIAbqPhVhe1mSFkUEVg0NYFf04bY=;
	b=yEIVvlmNnvo18hfLm2a3k4uNcVJEXakgPgy1H7UCpIiiUq/3b9uV+jrxvt1j3caDxM6K9h
	kS+FGMxVmsFz7ACQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767606969; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tyzvGt7ijyC3iXfUIAbqPhVhe1mSFkUEVg0NYFf04bY=;
	b=R/ywBHxSUrbqAa6LMzFpOwqn7ztTjlGhqqXaBOCRfjzBE72tHH5F35oeu951VGzup7HtQH
	7s28lP+KUyZ/fFTO1ff84LyHDm9pkuvPLsSL3bMXjNVkPP5t0pVnLEgh7RYNua7M1EkVJY
	dKmriE83g57xtywbiXkyquxoM5uAHoI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767606969;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tyzvGt7ijyC3iXfUIAbqPhVhe1mSFkUEVg0NYFf04bY=;
	b=I5nxatXxr3jOMvQJ250fW1nLDZvTWQvOtiXKQ19T/YG9ClyH/d5YiuzJLkEb5IPgTLA9RB
	RT8kX7b9rAxMqhDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B27F03EA63;
	Mon,  5 Jan 2026 09:56:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jc9CK7mKW2l0SwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 05 Jan 2026 09:56:09 +0000
Message-ID: <ccee668c-88b1-4b06-ba33-1cde63c61ade@suse.cz>
Date: Mon, 5 Jan 2026 10:56:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm/page_alloc: auto-tune min_free_kbytes on atomic
 allocation failure
To: wujing <realwujing@qq.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, Lance Yang <lance.yang@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, Qiliang Yuan <yuanql9@chinatelecom.cn>
References: <20260105081720.1308764-1-realwujing@qq.com>
 <tencent_6FE67BA7BE8376AB038A71ACAD4FF8A90006@qq.com>
From: Vlastimil Babka <vbabka@suse.cz>
Content-Language: en-US
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <tencent_6FE67BA7BE8376AB038A71ACAD4FF8A90006@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 879F6100004
X-Stat-Signature: 4o7xqyd8tuxb3fkft8ciaadoajuhufjc
X-Rspam-User: 
X-HE-Tag: 1767606972-898804
X-HE-Meta: U2FsdGVkX19JNqaBGcjIKh6cMnl6ZHb0jqnFzs/U/lfuu3ZkbADgUB90HLSCeUi3aP/WfxrL8rlqM64MiCmH1S4bM7axtLdxVhZoW4XTdbJvE+dfatv0dKmuOxhoF33ufFVI41Ok85cnXFAJJInQJcj0t5rexWD8Ewgm10rENc4Bo52JL4UBuV5VYuWtwH2PFocNkRR5xShFsO0QTOiLNnVZqOVpV4Hgp8WTa506K3LeP+9aaq5smLAiAezNycZgtHTuzoOvXXSmIDkn2/pkbe1q1++J7wPpjUAteoOhXcB+WYEZLkOO/uFEl6Rr26BxpINfAz6MFDd1/m2ZG7c1SNwV9Crtvv/F0zwKtQrRAQ3UqoIU75SxfCYQMp6c0ruW8ZVUSI9WWb8QLHL++chzfSWGQzL9Psq7QlLkRbHjmFYxzNk8hhATtcUUqDDwhuQ9Dqhf1AFvYNOaI8IIybTDknv6657rxopAWiY8LmQcKZjPlSs2eGbc2cZuBzZygE91pIZma83Yv9T0HgvMTl6gp0Jm3UxPGg9iHrb348wlpm3H/ZHx18tIjvOlVdsuwgQxpaIj1dCGxZmr2BsKv5tfM2rwcA4dgMBu9y2O91itaqHBgqCdhcnlNMPwV1nEBK6riCNmIt61bNVahldiW93lJPo2eYcDGb8fNMqOEzb2XaLC/YLYgA5do0oZx6dXWoFlOdSzaC8mRq1czBGhgr9sc8HOp45pi2L5MPIgQ5lYMrF03vn1Iswea/yeRCmTaXIoFAQThdtTNoYrLwJAd8lLm1pFR6s1w+on0cWhJQOHhKQZWHGjqSF0LfPhj5K2/V0rqUrNVDEmiPx9hP7ZRLCYkofut289xwViQG20hKYDXegw19okCQGfEvSs9RgT5qPN0Yc0aiAiYh+rSOZf4gKAdjRsuWcd3NqXSQMD7QbFXNKQ0fSacNADgSejRP8p4sGx0T77vto4IDV1l2Ib165
 tMbQy4jn
 qypwd5cT5xzWFTu+PXyeZg38kWXIbcH7U68bKtCp3ylwqqV4/89hmnVZxauFcmfUO/ltfUFARPqtF6s3AlvMoAHlOIRCi4GHuuqAEpzry4A2iMbdSROFUFRKDB/VU6uv1mv7s9bJCDGPAB8mp+YZDPYjUEHR0fpMcl3tO/OR/GVk6UycDNp7HFXotRevmr/TiYExmDoIotj+WNk15C2ijCbmKPSd6GSKR6VHcHcgIMDXAfxz70Hg1SOXEjQyBmWlGegMZpnI+pJmdysMazEoi4Mpg1o4DtIrEOxcsbbGTOZnJl/yVWMw8rYkNso/PcE4h38PdszosNNCjdxIV6s5GJTsYBrHWQ0fwgMdG2r9ulGtwjlQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/5/26 09:21, wujing wrote:
> Introduce a mechanism to dynamically increase vm.min_free_kbytes when
> critical atomic allocations (GFP_ATOMIC, order-0) fail. This prevents
> recurring network packet drops or other atomic failures by proactively
> reserving more memory.

Were they really packet drops observed? AFAIK the receive is deferred to
non-irq context if those atomic allocations fail, it shouldn't mean a drop.
I also recall the main source of these GFP_ATOMIC failure warnings was
finally silenced some time ago? Maybe we just need more silencing.

Thus I'd be reluctant to proceed unless there's confirmed benefit and
interest from netdev.

As for the implementation I'd rather not be changing min_free_kbytes
directly as that could interact with admin changing that in unpredictable
ways. We already have watermark_boost to dynamically change watermarks (for
other reasons) and seems it would be better to expand that.

> The system increases min_free_kbytes by 50% upon failure, capped at 1%
> of total RAM. To prevent repeated adjustments during burst traffic, a
> 10-second debounce window is enforced.
> 
> After traffic subsides, min_free_kbytes automatically decays by 5% every
> 5 minutes. However, decay stops at 1.2x the initial value rather than
> returning to baseline. This ensures the system "remembers" previous
> pressure patterns and avoids repeated failures under similar load.
> 
> Observed failure logs:
> [38535641.026406] node 0: slabs: 941, objs: 54656, free: 0
> [38535641.037711] node 1: slabs: 349, objs: 22096, free: 272
> [38535641.049025] node 1: slabs: 349, objs: 22096, free: 272
> [38535642.795972] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
> [38535642.805017] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
> [38535642.816311] node 0: slabs: 854, objs: 42320, free: 0
> [38535642.823066] node 1: slabs: 400, objs: 25360, free: 294
> [38535643.070199] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
> [38535643.078861] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
> [38535643.089719] node 0: slabs: 841, objs: 41824, free: 0
> [38535643.096513] node 1: slabs: 393, objs: 24480, free: 272
> [38535643.484149] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
> [38535643.492831] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
> [38535643.503666] node 0: slabs: 898, objs: 43120, free: 159
> [38535643.510140] node 1: slabs: 404, objs: 25424, free: 319
> [38535644.699224] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
> [38535644.707911] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
> [38535644.718700] node 0: slabs: 1031, objs: 43328, free: 0
> [38535644.725059] node 1: slabs: 339, objs: 17616, free: 317
> [38535645.428345] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
> [38535645.436888] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
> [38535645.447664] node 0: slabs: 940, objs: 40864, free: 144
> [38535645.454026] node 1: slabs: 322, objs: 19168, free: 383
> [38535645.556122] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
> [38535645.564576] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
> [38535649.655523] warn_alloc: 59 callbacks suppressed
> [38535649.655527] swapper/100: page allocation failure: order:0, mode:0x480020(GFP_ATOMIC), nodemask=(null)
> [38535649.671692] swapper/100 cpuset=/ mems_allowed=0-1
> 
> Signed-off-by: wujing <realwujing@qq.com>
> Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
> ---
>  mm/page_alloc.c | 85 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 85 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index c380f063e8b7..2f12d7a9ecbc 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -30,6 +30,7 @@
>  #include <linux/oom.h>
>  #include <linux/topology.h>
>  #include <linux/sysctl.h>
> +#include <linux/workqueue.h>
>  #include <linux/cpu.h>
>  #include <linux/cpuset.h>
>  #include <linux/pagevec.h>
> @@ -3975,6 +3976,16 @@ static void warn_alloc_show_mem(gfp_t gfp_mask, nodemask_t *nodemask)
>  	mem_cgroup_show_protected_memory(NULL);
>  }
>  
> +/* Auto-tuning min_free_kbytes on atomic allocation failures (v2) */
> +static void decay_min_free_kbytes_workfn(struct work_struct *work);
> +static void boost_min_free_kbytes_workfn(struct work_struct *work);
> +static DECLARE_WORK(boost_min_free_kbytes_work, boost_min_free_kbytes_workfn);
> +static DECLARE_DELAYED_WORK(decay_min_free_kbytes_work, decay_min_free_kbytes_workfn);
> +static unsigned long last_boost_jiffies = 0;
> +static int initial_min_free_kbytes = 0;
> +#define BOOST_DEBOUNCE_MS 10000  /* 10 seconds debounce */
> +
> +
>  void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...)
>  {
>  	struct va_format vaf;
> @@ -4947,6 +4958,17 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  		goto retry;
>  	}
>  fail:
> +	/* Auto-tuning: trigger boost if atomic allocation fails */
> +	if ((gfp_mask & GFP_ATOMIC) && order == 0) {
> +		unsigned long now = jiffies;
> +		
> +		/* Debounce: only boost once every 10 seconds */
> +		if (time_after(now, last_boost_jiffies + msecs_to_jiffies(BOOST_DEBOUNCE_MS))) {
> +			last_boost_jiffies = now;
> +			schedule_work(&boost_min_free_kbytes_work);
> +		}
> +	}
> +
>  	warn_alloc(gfp_mask, ac->nodemask,
>  			"page allocation failure: order:%u", order);
>  got_pg:
> @@ -6526,6 +6548,10 @@ int __meminit init_per_zone_wmark_min(void)
>  	refresh_zone_stat_thresholds();
>  	setup_per_zone_lowmem_reserve();
>  
> +	/* Save initial value for auto-tuning decay mechanism */
> +	if (initial_min_free_kbytes == 0)
> +		initial_min_free_kbytes = min_free_kbytes;
> +
>  #ifdef CONFIG_NUMA
>  	setup_min_unmapped_ratio();
>  	setup_min_slab_ratio();
> @@ -7682,3 +7708,62 @@ struct page *alloc_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned int or
>  	return page;
>  }
>  EXPORT_SYMBOL_GPL(alloc_pages_nolock_noprof);
> +
> +static void boost_min_free_kbytes_workfn(struct work_struct *work)
> +{
> +	int new_min;
> +
> +	/* Cap at 1% of total RAM for safety */
> +	unsigned long total_kbytes = totalram_pages() << (PAGE_SHIFT - 10);
> +	int max_limit = total_kbytes / 100;
> +
> +	/* Responsive increase: 50% instead of doubling */
> +	new_min = min_free_kbytes + (min_free_kbytes / 2);
> +
> +	if (new_min > max_limit)
> +		new_min = max_limit;
> +
> +	if (new_min > min_free_kbytes) {
> +		min_free_kbytes = new_min;
> +		/* Update user_min_free_kbytes so it persists through recalculations */
> +		if (new_min > user_min_free_kbytes)
> +			user_min_free_kbytes = new_min;
> +		
> +		setup_per_zone_wmarks();
> +		
> +		/* Schedule decay after 5 minutes */
> +		schedule_delayed_work(&decay_min_free_kbytes_work, 
> +				      msecs_to_jiffies(300000));
> +		
> +		pr_info("Auto-tuning: atomic failure, increasing min_free_kbytes to %d\n", 
> +			min_free_kbytes);
> +	}
> +}
> +
> +static void decay_min_free_kbytes_workfn(struct work_struct *work)
> +{
> +	int new_min;
> +	int decay_floor;
> +	
> +	/* Decay by 5% */
> +	new_min = min_free_kbytes - (min_free_kbytes / 20);
> +	
> +	/* Don't go below 1.2x initial value (preserve learning effect) */
> +	decay_floor = initial_min_free_kbytes + (initial_min_free_kbytes / 5);
> +	if (new_min < decay_floor)
> +		new_min = decay_floor;
> +	
> +	if (new_min < min_free_kbytes) {
> +		min_free_kbytes = new_min;
> +		user_min_free_kbytes = new_min;
> +		setup_per_zone_wmarks();
> +		
> +		/* Schedule next decay if still above floor */
> +		if (new_min > decay_floor) {
> +			schedule_delayed_work(&decay_min_free_kbytes_work,
> +					      msecs_to_jiffies(300000));
> +		}
> +		
> +		pr_info("Auto-tuning: decaying min_free_kbytes to %d\n", min_free_kbytes);
> +	}
> +}


