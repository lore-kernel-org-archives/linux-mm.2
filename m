Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84D4BCD3445
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 01:15:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B33796B02DD; Fri,  8 May 2026 21:15:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE4496B02DF; Fri,  8 May 2026 21:15:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FA326B02E0; Fri,  8 May 2026 21:15:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8D57E6B02DD
	for <linux-mm@kvack.org>; Fri,  8 May 2026 21:15:04 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 50910C1B3C
	for <linux-mm@kvack.org>; Sat,  9 May 2026 01:15:04 +0000 (UTC)
X-FDA: 84746112528.15.BF7C34A
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf10.hostedemail.com (Postfix) with ESMTP id 538FCC000D
	for <linux-mm@kvack.org>; Sat,  9 May 2026 01:15:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kE+1WHJ3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778289302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sarj65PYwDnpWFGzTavLfX9I3MyvSLzMLM5BZfpx3ww=;
	b=I+CNkL4nNj8XEAdpCAJhVtxbxsxgeiSE4s0/fft7lcYo11SIcswCac3L5piFFWKFAu54L+
	iN58azfStPaT9XHTj3RgCZQnf+2hEuoOAj5Ggnw88IdbiY5+8uu2ycGWIptddXlHvuc7UP
	4WPIIzBr1mFhQQ96N4+Q6mNujs8oEWU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778289302; a=rsa-sha256;
	cv=none;
	b=WuyZSFcWblGc491FMH1b5oQqg63dZSskgJzc99XRwvMvdNKQg/t6Jf1A/zs58YL0Bye7fl
	Hew8S7JT+qXZPopkF4GuuiiWX/Ld0VZZoODon/zbi0DsYN9/VTutE6y08FVAHmzeIAZydO
	txGNgv8be8wSr3/9xMKvH5fYvImDA50=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kE+1WHJ3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
Message-ID: <00e55713-c79c-4389-a6d2-aaec95b3fa61@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778289299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sarj65PYwDnpWFGzTavLfX9I3MyvSLzMLM5BZfpx3ww=;
	b=kE+1WHJ3l7qxs9SYsCeS5loiB7c1IS+rfUUzbf9tBfyAB7NQoAi3tNKKY2haeEvod2MFra
	qhUzWo/KxOqU8qi8OWd/U+jkmHXmfx3My9JFhjSutM3UIYlqzFuDu+auipz7CiTHByvhrJ
	HYk8RvEW5iZl5XW/cAd8Ammn2qgRCps=
Date: Sat, 9 May 2026 09:14:18 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm/balloon: expose per-node balloon pages in node
 meminfo
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
 virtualization@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260508094736.142467-1-hao.ge@linux.dev>
 <20260508113123.c8e653484d39e76cdd6e142e@linux-foundation.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <20260508113123.c8e653484d39e76cdd6e142e@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 538FCC000D
X-Rspamd-Server: rspam04
X-Stat-Signature: omcjf5zyyhnpeeq36n8fod1f9zdhgmza
X-HE-Tag: 1778289302-310534
X-HE-Meta: U2FsdGVkX18I95G3ZAxjWNvqll+ldCn929G1B0ZczeLLbEUUzlhEiO1N9Ojvo6Z4J8JDzr8EI6p8OtKaHsCKVbUEVzo5jlijyrpmh7GMAZ5/BQAI7lpEV8ZRjxBCOS/kJk1S9PXB93hDe7+SAcoiAtAWIwvfrNutbUI3K3ExuVA51V6e6K3/JhxmGnhMMFY35lc5zjZZe/6TXOeuTsvalnugC7KMojzAl2S81HNP+NHw0lkX9NJIuGEsQFRiaedWBtscgejyL4Nh7rtqZB276VAvZuZE0d6SFCCsy2aypCuxsz1dqga36psbyekQreFgtnF/YjW1JFYHRfU/EWGZas3aCqHUIAS96XAeNGYHgAGbQb/WJYEURXqpiZ1VzfaURF6VPszrapAGxC3OZehGmZOBlnP3MgmWnEdzlzGkaVqfrJ2ViAonWk8luGE+MXa/EIdgjjWPAZdVvObqW223R+Q0zkRFLELwBQxc5PEn9vp50cv+MiyLTpc2yd39JjGQBYlY4WXnlQmzXmkGsJOutq1ht3161hGQZXx+idr0OC/ocDE3RDE6Mx2kXfLZZ8WYZpAhuDsG8d+4O+LAsGl1KEUEmsoAnJ2Pt3rDUw+176LD2godSJFwtzJvKPqQq9mWApOTN5sxSD0TfOvRmSm/sJOi7ap7Y8EOYZq55QmR0aEW6yyFmvrqNYGz1fs4Rkc88YGoEdR5bHfjJMJkvyZFh7lyRX6Twp+neQk44m+VbvmqTIznqQORQW/1fsn4DpgkAWPkNMvb32/2qN/OlsaDz2kRJCrvmAFHixk8OroiUEmtYZLOBC1HdEpK2zLvbYLcvgIMetAzarEJyttTOfGQDOiCHultrE/ywH92LfKJRq0q7OPJpE55ZtyKM+LpWvvaH409fIHxMWEzwg7sZlhuC08s3qaZfhxlr6zjbAAB7iD1sKqZj9ZxDAp9O4dEQMk92L0g4O4V2LcU5Om3IL9
 JpUfgYqY
 4vdm7BQg4CL/EJBSF2h40VnMWM4q0P1Td/FOr681aArjntBqhdKRv1oKZEsEIOC9DOhbZoSJ6darv32VJWVCXvZRup6kgB88EuO2KuvMszMCgjoAQinVJndMtrlpmo/Ugxyl2ZsRMiNSQzsOgHqM0TSVvKWh4Nz1k9+YcahzSa5uDf/ak5MOEPpHQBUze5YLbEUmBGL1TiHnnP8e7PWxolv172Pi0jaWC4CO4szWCWIpakwoYCgd/JcwHLXwNVg5PeazH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew


On 2026/5/9 02:31, Andrew Morton wrote:
> On Fri,  8 May 2026 17:47:36 +0800 Hao Ge <hao.ge@linux.dev> wrote:
>
>> Commit 835de37603ef ("meminfo: add a per node counter for balloon
>> drivers") added NR_BALLOON_PAGES and exposed it in /proc/meminfo.
>> However, the per-node view at /sys/devices/system/node/nodeX/meminfo
>> was not updated, even though the counter is already tracked per-node.
>>
>> Add it to node_read_meminfo() so users can see balloon usage per
>> NUMA node without having to parse the raw vmstat file.
>>
>> ...
>>
>> --- a/drivers/base/node.c
>> +++ b/drivers/base/node.c
>> @@ -523,6 +523,7 @@ static ssize_t node_read_meminfo(struct device *dev,
>>   #ifdef CONFIG_UNACCEPTED_MEMORY
>>   			     "Node %d Unaccepted:     %8lu kB\n"
>>   #endif
>> +			     "Node %d Balloon:        %8lu kB\n"
>>   			     ,
>>   			     nid, K(node_page_state(pgdat, NR_FILE_DIRTY)),
>>   			     nid, K(node_page_state(pgdat, NR_WRITEBACK)),
>> @@ -556,6 +557,8 @@ static ssize_t node_read_meminfo(struct device *dev,
>>   			     ,
>>   			     nid, K(sum_zone_node_page_state(nid, NR_UNACCEPTED))
>>   #endif
>> +			     ,
>> +			     nid, K(node_page_state(pgdat, NR_BALLOON_PAGES))
>>   			    );
>>   	len += hugetlb_report_node_meminfo(buf, len, nid);
>>   	return len;
> This was prepared against a kernel whcih didn't have 2232ba9c7931 ("mm:
> add gpu active/reclaim per-node stat counters (v2)").  Which was added
> in February, btw.

Sorry about that — I failed to git pull the latest code before preparing 
the v2 patch,

so I didn't realize commit 2232ba9c7931 ("mm: add gpu active/reclaim 
per-node stat counters (v2)")

had already been merged in February.

I apologize for the trouble this caused you.

> Please check my fixings:
>
> --- a/drivers/base/node.c~mm-balloon-expose-per-node-balloon-pages-in-node-meminfo
> +++ a/drivers/base/node.c
> @@ -525,6 +525,7 @@ static ssize_t node_read_meminfo(struct
>   #endif
>   			     "Node %d GPUActive:      %8lu kB\n"
>   			     "Node %d GPUReclaim:     %8lu kB\n"
> +			     "Node %d Balloon:        %8lu kB\n"
>   			     ,
>   			     nid, K(node_page_state(pgdat, NR_FILE_DIRTY)),
>   			     nid, K(node_page_state(pgdat, NR_WRITEBACK)),
> @@ -560,7 +561,8 @@ static ssize_t node_read_meminfo(struct
>   #endif
>   			     ,
>   			     nid, K(node_page_state(pgdat, NR_GPU_ACTIVE)),
> -			     nid, K(node_page_state(pgdat, NR_GPU_RECLAIM))
> +			     nid, K(node_page_state(pgdat, NR_GPU_RECLAIM)),
> +			     nid, K(node_page_state(pgdat, NR_BALLOON_PAGES))
>   			    );
>   	len += hugetlb_report_node_meminfo(buf, len, nid);
>   	return len;
> _

As David suggested, the node meminfo fields should match the 
/proc/meminfo ordering.

So in the v3 I rebased on the latest tree and put Balloon between 
Unaccepted and GPUActive.

Here is the v3 patch: 
https://lore.kernel.org/all/20260509005631.17183-1-hao.ge@linux.dev/

  Sorry again for the inconvenience, Could you please replace the v2 
patch in mm-new with this v3?

Thanks

Best Regards

Hao



