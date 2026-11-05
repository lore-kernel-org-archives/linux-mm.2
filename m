Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C44ED606D82E
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 12:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aZgw5bua
Received: by kanga.kvack.org (Postfix)
	id CBD986B05BB; Thu,  5 Nov 2026 07:11:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C47716B05C0; Thu,  5 Nov 2026 07:11:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B35E66B05C1; Thu,  5 Nov 2026 07:11:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7EFC76B05BB
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:11:18 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F1EC6120971
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:11:17 +0000 (UTC)
X-FDA: 85400950194.09.E41239A
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf05.hostedemail.com (Postfix) with ESMTP id 16F0C100010
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:11:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=aZgw5bua;
	spf=pass (imf05.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793880676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hcJOLUQQfftD1WGUXaDjd9QGjP8wRNkM3DnlrO9gmPI=;
	b=y4MFMAroVTIcudZenjFZSEKM6xu1eUhDbDpvX7TTTaRGYXclm6G3YhEnMNofiPnAgFWk/u
	ab84Rv7ihP5FQxpo1BDsEbtWWMYKjIy3Lze2gH0Tr/YEdjAZWRP6Td/mM2KxEPZw4k8nsZ
	2v7Ttp65WS/f/MkO2gd4BfE9uwFIi/E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793880676;
	b=ySIHoPdcr9+blBiD3mMzUm5pRQBaFQo1Pb2EfOABrEoORXd1v9nw5hJN/R2OcGbNYWSQKn
	3/vtxWx2EAudJcIXj3tkCC7iRX4T6dLSuUmTjdSC7qnkRoU60PTCRmn5gItZpTpkeMEimD
	z42NOWiheWtfdKNTtsz+O0xKRN4mGYs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=aZgw5bua;
	spf=pass (imf05.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a214c5c4c0so16154475e9.3
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 04:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793880675; x=1794485475; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hcJOLUQQfftD1WGUXaDjd9QGjP8wRNkM3DnlrO9gmPI=;
        b=aZgw5buapYnsIaKKKBcfBQ+UAHn0BJpk/dJUKrO6Il71vmtbnlDhJf/n61n9belldp
         TUWOHNEkvIPGWrCZ4wdYc4fKPGHcFfwCpdmBVw8SkJth8CIL8os0sZcZiU8Qx3Rm9jk2
         JW61mld5bczTNSKAmsfzxjVu54wFG/MGXtTa19jisngdoGXOYcXS+XeL0cXNF/f4Cmp3
         Oda0vb4BX3uyBxmq8YQ1EDdzEev4/RkkCe2t4CBPhsfv96mU0Td3yWDLfFicPrxaALr1
         crWKx2P9nSAFmXJOaq6kGXU0HDbboSu+QGlTK4NtPlsdMsrVy6LH/OCBLrVSvNsiQWyu
         09aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793880675; x=1794485475;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hcJOLUQQfftD1WGUXaDjd9QGjP8wRNkM3DnlrO9gmPI=;
        b=a4T8SFTssPIbIR4Utma9k4BXKVNEMKMXFLfeL1t8dQRxbOmdbqNPrkxDyJqyZ5/PVD
         HsUdxwSRL2obIjbq+xUTNEC/tWJd/ncmC+CCX4SbEzSunVmOS+fOHKrLymknir69ybPr
         SJmuZOwUfiH/VQvQreuB3LokrSzbIraNAH1Kdh3DtaY9Lwpoqnp+38l6Zl3kaxDRsaln
         5G4LPqdFyK82HQqdOFlD6Wf18IdSFSS2dI44chbDGIHFQZ/4fTXkp1q2LCwoJZ76Kw0X
         s5qC6pISzjapPXMdwrpyRvRQq6KtfO3OjhckVXpv4ZVxRpoRU5MtovrBtrl8hXcYH1qv
         9lxQ==
X-Forwarded-Encrypted: i=1; AKwUvBzNwyApkPUxvudX8yezckH0f6cWBUlHUFvmoKGyny08PAC+O96ZGe0MnuFiMyEP/34q7yTw7oP2QA==@kvack.org
X-Gm-Message-State: APuU4Z/HAsZW+dQUTDIxB0PvgJCSUZNpxmDb6g7TKZXxypLun3SLCysJ
	IbgLjGl5drmXAWfYL2WCW5yaAQRE2bXe+1Wb0K95fxgoeXDFYZul5KN9
X-Gm-Gg: AYBFou2vExlDYElZX+i7oU5pf0R2QQk36mBT3ueIrWUdkxax/Emccfmy8cSV2ZvrB3C
	6/jAeloIJ/cvqfHS5LC+ICY/5XAKd6RlY0XJ7gmT1W+WcmK840yrQbp/ig4TGzRYVs88B7obwqu
	Jo9yVbesIUHJnob44DfFla3p9c1V4FyLIuKM+BKwzzXt3SNk5xirBrMd5XTdYCfWbZ7zDNLfIhR
	NF8f/KiSxnQjpzh1X50h3h2VQ6gzJGQccAHJsAQcu8aNr/DqcdvG6KPoQXiBho+IiA0cqfuyTNh
	r9bUY8ylhEiP00tOrgQfo8drU7YDRp38ZpbX5rShAguavrNlqSEF+lFUFfozKGYIUeLl4VI2LO9
	sMbdSTRmv5fMBZ8i17QEsj+kcAfWwjVsXGtmiJxlELNkG9sLacGpKioAAMsXV79yvPf1u3/cUJB
	rFeDpuqRh1GfTeMuYCqqjysGTDIRd9qvoBFa7U7rpg4heTKYd2h4P8XI46frc+wWMRVTBmDT+3e
	Aa237v8di22nb8VXUsB2WBV8svCDV24hfjyL7FWu8Tdym/mR/7Ns1LKxXeKi5dQcqnWn0cEoINm
	92QJ9WXM7cnYVzQKGDZ+MUE=
X-Received: by 2002:a05:600c:c0c6:b0:4b6:5dac:b61e with SMTP id 5b1f17b1804b1-4b65dacb8c2mr5581095e9.32.1793880674123;
        Thu, 05 Nov 2026 04:11:14 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b573366ea6sm64216055e9.14.2026.11.05.04.11.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 04:11:13 -0800 (PST)
Message-ID: <8e353a2e-fa06-4211-882b-08fb81d07802@gmail.com>
Date: Thu, 5 Nov 2026 13:11:12 +0100
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
 <75540cfc-0577-4d91-9369-d1c4fe9c3096@gmail.com>
 <76431b4e-27b4-4922-bc59-bf97516b40fc@kernel.org>
 <e5865932-ccd9-4f7b-bb64-e05a6f7a60ce@gmail.com>
 <b45f79bc-5a3a-430d-8a64-5a1ac6097d25@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <b45f79bc-5a3a-430d-8a64-5a1ac6097d25@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: zdcuzmucm4s43wz4ctzjmtuw6xfqmh3x
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 16F0C100010
X-Rspam-User: 
X-HE-Tag: 1793880675-407023
X-HE-Meta: U2FsdGVkX1/AMhgkU5YkY3Zv9NcdgFMvPX9eCHLN1Mi/uW1ZrBo/sgfP6FWYFAuvsc0o//YpGZeaXxmL+TZS3p8DPsjulDn8dvtXErE/p1fdayT7KUQA6xXjvmMMh9Kl3N/gFR5omU1Ts7ZVJbo5GQKgLWyg7+yUBF8GIlRdXSDes0rE3zuKLAlpfg58IOhNQPpA9mr8xNv1NtYOx3prHzRNOmzcUdGbTyIZ6onC4W+UbMm/BZO/TpEXw83wAOOIAYlSF1pKeIoNIXL4/jnEFJS6H8ngCcu2dzC/vugrPcWpJkYDZpDOxnCRXtugThNlwZXntm9TEJIsOx/VoVV5ROQ1Z2iiciNJmcqcxjJFtjW07K6n1/P16XuH23xG+cER5vIVHNHD/lqDik3F40lGs4UPglWxc0WVQwAGzpstC8TP++uXW+xu9ijFgXEzpntr62E9DdhK+lxOCiKNR/SaufijMh+4SJffKwNxJCsYLi2KhBSoSpswSyiov92tjR+6VzI1tfVpYNbQqdGtzQcLUDU0AEYZ37PugJl39yVETDB0PIOrXXVQD6Sd8f3DnrxrJscDPb0tbfQQ9oRCO0FXIJbT6s+T6gjFNe3CMezg9R8WmrTFZ5CST/1VGoAgeA/sV+RnlxBlm0XDRqKmedlkJfvpP/vzYd5e/QrAoWvLDQTZrLomToV84SCmZsGKExXk2er5laujcFHyFZsMBJM2nVFcCYJOpTomxKUpdPHoOe6NAMngppoLkAYphKRhfRCstSQSHCpGAMMnFqeZy9Kbxb+C56PFZoUauvoxmAzKSNUz1gczKHo8WeeWfywQdyN+/2/lKRSOHAM4/F8Ue/tkirKzH2j5LNTCnrnHqbHSq0uvmrTBQD2sK3mQ2M+cxh+Hlz0Z/mCqpp4MUnB9djJAotYzPX031dShichWkfx00WhdFBcvoghiFVZZqO3ewy7vxj3vCb4pqi/czdo9w8S
 jUL45K5s
 4tPiGwFSrnJiVaz1xXjZeX3hSV85rwKzL+EKVc60FLKLBN5iPVmcwQYyjRfMhDzFzDwYrwDugBsUWUAvC4U+QSLEXGZjJoBUT7zvhOfrNwDJ4Gy7eMQG5XlToRvNmWvOSBolCCa/zc753O3pcInn8CjOM+EXCVbPwsJ/kPcIluL07j2uptAXzg83vrwNPbH6N93SijIAirIdHMkXVZ7jHfwwF4BIBhH16S0mri9jlheoqqKYggL13KEtiiTr01KVHHjybZe0fmujDk+xUzi52hEnsZuvdYdvbk3ZJLGnSJl9mUL2ctkvXPjP/NArvxiWMUpFlmepflZun6tz/9vB6oM3PC+DKqbtV8iaqVEkjcShc1dt0iqpowRmF9ORz9Yk1/PgF0rY2dt3YGk4dmprOQtFeJMudvpYtN8H/3uDWdyWFt7b3yShgstikgqU/Iork4Kxz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 12:52 PM, Vlastimil Babka (SUSE) wrote:
> On 11/5/26 12:43, Jose A. Perez de Azpillaga wrote:
>> On 11/5/26 9:02 AM, Vlastimil Babka (SUSE) wrote:
>>> On 11/4/26 22:56, Jose A. Perez de Azpillaga wrote:
>>>> On 11/4/26 7:38 PM, Vlastimil Babka (SUSE) wrote:
>>>>> Hook this highatomic unreserve to the moment we are increasing kswapd
>>>>> reclaim priority, as that is when kswapd is struggling to make progress
>>>>> and it should roughly match the case of direct reclaim failure.
>>>>>
>>>>
>>>> isn't raise_priority true after almost every pass at DEF_PRIORITY, stuck
>>>> or not?
>>>
>>> Can you elaborate why? At least at first glance, kswapd_shrink_node() should
>>> return true if it scans the requested amount of pages. So I would assume
>>> that although balance_pgdat() will do multiple iterations to reach high
>>> watermarks (because every round of kswapd_shrink_node() will limit itself to
>>> SWAP_CLUSTER_MAX per zone for sc->nr_to_reclaim) this should not be raising
>>> priority if the rounds are successful?
>>>
>>
>>
>> it's max(high_wmark_pages(zone), SWAP_CLUSTER_MAX) per zone, so the sum
>> of the high watermarks. by default that's at least managed/500, while
> 
> Ah thanks, as usual I got the min/max logic wrong, hehe.
> 

don't worry :)

>> DEF_PRIORITY scans lru >> 12, so it can't return true above priority 8
>> even when every round is successful. and sc.priority-- runs before
>> pgdat_balanced() is rechecked, so a wakeup that balances the node in one
>> pass still unreserves a pageblock per zone.
> 
> Yeah in that case it would probably be safer to perform the unreserve only
> after reaching the highest (lowest numerically) priority and still failing?
> I think it should still be enough to recover from the pathological scenario,
> which should be rare (but not impossible) in the first place.

makes sense to me, as long as kswapd reclaims something. if it doesn't
it goes hopeless after MAX_RECLAIM_RETRIES runs and stays that way until
the node is balanced, so that's only ~16 unreserves per zone.

-- 
cheers,
jose a. p-a

