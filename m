Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDA47606A85D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 21:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ngkkiGvf
Received: by kanga.kvack.org (Postfix)
	id 0852E6B05B6; Wed,  4 Nov 2026 16:57:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 036146B05B7; Wed,  4 Nov 2026 16:57:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E667B6B05B8; Wed,  4 Nov 2026 16:57:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF6786B05B6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:57:02 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5B8431605A4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:57:02 +0000 (UTC)
X-FDA: 85398797484.18.386CFDA
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7DFEB100005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:57:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ngkkiGvf;
	spf=pass (imf05.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793829420;
	b=I+TQA3REwfFDVR6KV9w/94oRnULcGw1hanNccb53orpci/LNd2VrAUZ88L+WcibN9zBHaR
	CCRmChsxrsAxWg13H9FZnC/6WaQgFXMLgkH5r8feNVBarrSXnkgRbK5BixfEKzqc4Vur9h
	gMGtllE72D8+1WOVWkmJJaFHwETSTuk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ngkkiGvf;
	spf=pass (imf05.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793829420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iieLdBkwQ6wRvtcuZtWp+Lo8dgU6lmnVCXawi7PwXUg=;
	b=fT+Diq984MbPWxl5/MVhUM17UzVbrjWO3vc7EvcoPa9mMzRbhIH5FqRYfuA0eZp8MnHTuL
	TgnOpLhWczKHXOPXHVUZdc0XeNvimS+5WlOsFmVV23i8fkqqw3WUxKSzc0H3+77hrR27zo
	YYjFV+6fzZxmMDSxZXYt2t4xwNBSbac=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a35ac4475dso8127975e9.2
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 13:57:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793829419; x=1794434219; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iieLdBkwQ6wRvtcuZtWp+Lo8dgU6lmnVCXawi7PwXUg=;
        b=ngkkiGvf6QrWaE5xSfBvgzrUbX836bnAfu/D8xE3bsdu4w+SbCH7l639w/ywRkzOpv
         pX5IIMoU6ITIYiQUWtS70JZblH60IEss2B/Ks4Coe6MAwO9v0dCPa3nD2a5bq5h5ON99
         yiUks/BP01+biL6fWsQ9y56Fb54yzuwtqvvcQUQ0vvuskVh0ng+47CIiJGNDT7t8DPpa
         mytF/0GKKIpvmVABiavXldFdnLx/00WjcTn2eG3IBoO2KHS1/iPNwCq9KzAWiKhlQSKN
         ZOz7vvt0vfc0Y0xW+32P47p4dzcNlnhGHqyGAXLYL3Jn7OLRHnAuqmt6ZnR0zAC5MDRn
         Z4yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793829419; x=1794434219;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iieLdBkwQ6wRvtcuZtWp+Lo8dgU6lmnVCXawi7PwXUg=;
        b=sZtMBEnNlQXHnT8J49gLKpOLmPPap4TmhAEIJN7nOCmODVckw7WYrpdw5uwjERDWvO
         nD+nijXF0mdspZ5GhnizsjRt3o4hNxYj/CxogKOYD7DkWarVdgErgScQyo1S4mwAQI/f
         WJvwQnvtTcvNh8NYNOdNPQf8/hoe15wdVwJwra0rJW6GHrGUrNTH4K0jd8MPA/Ks+rhn
         XItYSrgAj1mCicS/NFKFKzIABHOB0Qb+8j+asH217CnpK+p00D2bQDhiTnacY2GSulzV
         IWVNU3cFpbFt0+FbGmD7+XjynVG91XdrChgwIIDvElGp+Btqp5pBE0kaGzXWX+aLWAEE
         R0eQ==
X-Forwarded-Encrypted: i=1; AKwUvBw1gj8Ro8eUy3cVTMiljwG3GeAMjOpze8G5B68SXIdg8euPrpXePqkYIN2hM6+x2AufJGbhotJGdw==@kvack.org
X-Gm-Message-State: APuU4Z+be4qeJzQWoEm4ZoRuHLAfGSaN9i0uoM0IHAN69l9QK1ez6e+E
	y9yWAQyuvU6Sy7YH7d3DwdQnDO4Rc6qL2IURHzGCSwiF+wR95hfwADvx
X-Gm-Gg: AYBFou1Y1tsALxxXGAZqXYts0ljeBXw71PD2kCWLo5lyxcuV6EMeO6c1ERM3hTzMsVs
	UzgDwR4xtT4iz6vaZrtIfc6VPD5B0gihmG+E7/lWx3VSjHAveqbkZLYVDmEvO+Ibm+U6V5ZHB7r
	OrjXOJc/OtZ5+VnVGZMC5xrCQFiri4LMCtsFiEukr0DTtcD3k2kZMoU0wGGJ858zoO8f4JcMxCS
	ohUqS1blnmRx51048s/ksizUGskYog6OGMeZKx1ip9/4lo4BRzouBDv0PB+qomcBcItckE+BHhk
	D42mejLEBVV03eEKHiYNB5p/M3hqXAD5e5HU0aFP1lGQJb/nocLrkDSAf4Ce2y2kr7ZaMXDXviI
	R+FnToGB8gCIWELs303Lia568ZSNOTuB9vapDjqoEyNNcVSibr34NtlXLKbYLxoT+Dnv7jpPvLh
	f3XsSDFtRx8Zju5YTaW9yx12UGsDtNW17kNf0wbTN71jkW2b2YOf1oQS3y3j/sur7IjaOx0O3TF
	QBWNxCW3mC600fTtKZ4IebmWQXQx5da+K0zIlbA8FeTIJyWg5Pbuk/yg8eIAt70QKSUs/jnBbWr
	qWl/XM6NH7Y2tt9H9rNqJcQ=
X-Received: by 2002:a05:600c:83c3:b0:4a9:18f4:925e with SMTP id 5b1f17b1804b1-4ac174711afmr374011925e9.18.1793829419086;
        Wed, 04 Nov 2026 13:56:59 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b57373f7f1sm15184095e9.15.2026.11.04.13.56.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 13:56:57 -0800 (PST)
Message-ID: <75540cfc-0577-4d91-9369-d1c4fe9c3096@gmail.com>
Date: Wed, 4 Nov 2026 22:56:56 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm, vmscan: make kswapd unreserve highatomic pageblocks
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, JP Kobryn
 <jp.kobryn@linux.dev>, Frank van der Linden <fvdl@google.com>,
 Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261104-kswapd-highatomic-unreserve-v1-1-38be5106adf5@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261104-kswapd-highatomic-unreserve-v1-1-38be5106adf5@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7DFEB100005
X-Stat-Signature: eqwr5uyeriri4cxr7j5teu89izeeudz1
X-Rspam-User: 
X-HE-Tag: 1793829420-407762
X-HE-Meta: U2FsdGVkX18AZI0HD581AAHwpRGjne3wXoRovC6n4I2wW/2+UxRI/H+FlboTW/pSaodZlsYv1COx1ydSBlh32qZW4WhiA0z9arPsPbNDtHxaRlmi8q2M1yHYE9hGQHwewklnHPG0YyYrxBeHsu4Pw+0uJ+2YP+65XYJ0gozJSGqGOts0MtBU148RLIYDGCbD5pzNGEEx2Po5QpJ5n0JV0YAeh84QhteqSnCIlBH0g9YDapYLa7oEgFdI9uMq8aSHtp6qHCZdFGQpONAf/2GcD17K1U21F3/VoC8Grdzh+z9+FU5J7NM1QTjJy4rDBBB8OjQgiGgFV1BjjGRHMiQ3QEoL/JwPog37TmeP0Vk9DV2i8m9TAkOP5OKiv1qYkok029oeNnhSS3kbKHllIKYQgwf5hUeJAeA0rGrM9/bsvdtrkSu2Ivm2cLZVCrKjJDzOikkazDT1Im1clbD/wgVchLA4Cl7DkbPntnmAfEOoqofJMFGajr1C3+Vxp6gUcEIhDf71Op9K7Q/e6xn8RxDG/QaNdjGtkg8rfxVsLF4mPv/3YrkmUaAsjaB2+XLMfBbmxwKRdFejBCvXs6h9Qg6KsfiX43ppScvHuW1cxRnaD038zNyu3rmLZc8/zs7ngBW9AmEy1MFN8z6blYbhlSMqYoUGKTa5wdrB2+mdwMEDabMgOrhbvh8lMtA25g+60azJ93VGx1vR2V4Lx25zo+BCg5VMvEzunBzHnHYTt2BCc6r+3++DVleMqiltzOnsl6rBVJxP76QPrY2VUJUaC+7TjqzCFVWyiPlvZKftqi0wEQ2dOojUamqyi2HCUd6z+pHq6ZqQpB/1BNPFh0bedslmNTjUezThnWbV4YWzCoUG/2+oj00RmH9Jbm7KySfCzuZonwevo6PrKNKy9W7LHlGEx2dtO8WPP78jCbGloQUSpeaG8R3sF6MVXOJrPyKjOTNCNZ40VC/Cuk2E0H7hptc
 ++hko/6i
 3NgCZXEd2lSprOvdWsZx9pgmCbtBeaVdo7lD13Sv2+DT+pDSA2fw+92dS7/GrQG/yOZoqmj1baGq9Uk9nXTeTti+4P2OHdL/LEE1oCXS8oTJYEW7I8JZpubCbA+gbetcHF9saNeY9Uw0bo2RswZrFsqddj3j9cRqFwbigcal/5G8ypUaF2DMix69fpukN8MOrQdEXb+EwdilDF5TqpQeye8X+Dy6/beNlo0wD9+kvbdFrThVBRgGQvv1HQyVlB+ymAWj9NYgaMNM4QPqZHncFNXhd4AlhrghlsZCMmf3kW5DW5FOczsnc3lttUo5t/o/3pLf11RzmGqm7IyX5yADnML8qLWM9uKMtMBUlVhMtTeeUXHe9NI8nSrQVSOqiJGFqRaHtEfFhvKoRJ3o4R5sglJ/2OaimZLKyQBn7W8agKQdymYp1bvTaWt2pk6Juv3D252FL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/4/26 7:38 PM, Vlastimil Babka (SUSE) wrote:
> Hook this highatomic unreserve to the moment we are increasing kswapd
> reclaim priority, as that is when kswapd is struggling to make progress
> and it should roughly match the case of direct reclaim failure.
> 

isn't raise_priority true after almost every pass at DEF_PRIORITY, stuck
or not?

[snip]

> +		if (raise_priority || !nr_reclaimed) {
> +			/*
> +			 * Similarly to when direct reclaim is retrying, try to
> +			 * unreserve highatomic pageblocks on the node. Convert
> +			 * them to movable ones as kswapd doesn't have a target
> +			 * migratetype, and passing unmovable should lead to
> +			 * least permanent fragmentation.
> +			 */
> +			for (int i = 0; i <= highest_zoneidx; i++) {
> +				struct zone *zone = pgdat->node_zones + i;
> +
> +				unreserve_highatomic_pageblock_zone(zone,
> +						MIGRATE_UNMOVABLE, false);
> +			}
s/movable/unmovable/ in the comment?

-- 
cheers,
jose a. p-a

