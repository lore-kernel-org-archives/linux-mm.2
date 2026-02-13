Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79158EF48ED
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 08:54:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B90386B0005; Fri, 13 Feb 2026 03:54:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3E226B0089; Fri, 13 Feb 2026 03:54:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F4E56B008A; Fri, 13 Feb 2026 03:54:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C7986B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 03:54:44 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 017F813AD41
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 08:54:43 +0000 (UTC)
X-FDA: 84438822888.30.783A835
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8F1FC1A000B
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 08:54:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CFdSP8lZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mDiFuDQx;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FgV8zFMa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=U+0RTVn2;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770972882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R8IMx2PRe6DO7hTr/0m0nRiXAWYpDypxsMIyjb6YLgs=;
	b=4EB07ZGs2LcG/KrajwOP9IRjaDS5dpchD2mL//ZgR3onmHF8qKZa6LlUO3rt4vCDrJA51m
	L/1/Nywy9++ysE+WDJLNau62a2bWXDRKQbNinXReRUshSHAjCAVvEWATT1qSLfoPy3fJIz
	mRwRMsoZS87VtsfD3nH6WsUdvmeF5Qo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CFdSP8lZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mDiFuDQx;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FgV8zFMa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=U+0RTVn2;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770972882; a=rsa-sha256;
	cv=none;
	b=LEdHqq3NMzA3HbtGssD1JqkQXtaFD++CQx8qlVo1Mkzkl+AUOpbtNrvCOq2xL8YgW+7HrP
	Q/++CDFalizpRejMAMkx7dC1Bg2O94HCNOk5lo7/VbU+z0clgn7XU1rL3YvsCngyZOXtBd
	paN8a8FfENnLbuXBnEKeByNoE6QGYwI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DF6633E6D4;
	Fri, 13 Feb 2026 08:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770972880; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=R8IMx2PRe6DO7hTr/0m0nRiXAWYpDypxsMIyjb6YLgs=;
	b=CFdSP8lZ1U/Ohf629Fb0N7KS7TBjNuJMRkLKlv62bktH3YUZXsIzesF+YF2QpiykquXnB1
	v3QasxYb4MJkKft3eLYByNj8reZ1AvHh4Qhji2he/aJ8WI2Csuygk51lUEqzzcMzrRkRm4
	srR775WqDmVLvOWQjwPPCpeCZAPzHiA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770972880;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=R8IMx2PRe6DO7hTr/0m0nRiXAWYpDypxsMIyjb6YLgs=;
	b=mDiFuDQxjJQZxli8cIVx2MERCTx+wRdZXox8cc1b9dSxjf3LOEQ4A3m0bTMvuW3kGPahj+
	A+y7ZY+y8H61K2DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770972879; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=R8IMx2PRe6DO7hTr/0m0nRiXAWYpDypxsMIyjb6YLgs=;
	b=FgV8zFMauwUnsS7NGZXy8kaOpJHOwGvBU8huqcbOK2wRjLQI0eAADnfN4zCt4QX9SHWyHd
	ZBWH2bKA7oqhYRCxV6jGvwJF3xFGTr96YuJpyu4QKf4bgkj2ZJwnDcEgrcjXUXZMQHUQbP
	zAVSiYy+aOIJVLqswlbgjO4b4WCp9mg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770972879;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=R8IMx2PRe6DO7hTr/0m0nRiXAWYpDypxsMIyjb6YLgs=;
	b=U+0RTVn2D2ptoWrYQB70sZ/KeJtHoVdJuz/aVR9oJCn1CNoLJXAdFQGQvNELjNex8L5Oj0
	8KsqOLBO0blm6nBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9B56A3EA62;
	Fri, 13 Feb 2026 08:54:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NE+XJc/mjmkHOQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 13 Feb 2026 08:54:39 +0000
Message-ID: <d52066f1-c83e-4406-adca-5a403adb4f44@suse.cz>
Date: Fri, 13 Feb 2026 09:54:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/mempolicy: track page allocations per mempolicy
Content-Language: en-US
To: JP Kobryn <inwardvessel@gmail.com>, linux-mm@kvack.org
Cc: apopple@nvidia.com, akpm@linux-foundation.org, axelrasmussen@google.com,
 byungchul@sk.com, cgroups@vger.kernel.org, david@kernel.org,
 eperezma@redhat.com, gourry@gourry.net, jasowang@redhat.com,
 hannes@cmpxchg.org, joshua.hahnjy@gmail.com, Liam.Howlett@oracle.com,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 matthew.brost@intel.com, mst@redhat.com, mhocko@suse.com, rppt@kernel.org,
 muchun.song@linux.dev, zhengqi.arch@bytedance.com, rakie.kim@sk.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, surenb@google.com,
 virtualization@lists.linux.dev, weixugc@google.com,
 xuanzhuo@linux.alibaba.com, ying.huang@linux.alibaba.com,
 yuanchu@google.com, ziy@nvidia.com, kernel-team@meta.com
References: <20260212045109.255391-1-inwardvessel@gmail.com>
 <20260212045109.255391-2-inwardvessel@gmail.com>
 <96b63efb-551f-4dd5-b4a2-ac67da577431@suse.cz>
 <b5927ae8-3108-4d65-bee9-be306fb697b4@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <b5927ae8-3108-4d65-bee9-be306fb697b4@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8F1FC1A000B
X-Stat-Signature: h7yqkaz965337no7ppucohqphb544wyj
X-Rspam-User: 
X-HE-Tag: 1770972881-50304
X-HE-Meta: U2FsdGVkX1+4u4Td888OFJNR1u060Gtsc0VXgPDOsYmiek0V3lTJJbPIyTP6ZPM8RidAYQ3mmPBESOy51cOmcRmYZ+Z/7D38YOZJF6nMe2q/CkhiFu/rf7ZXfsIXAegcLD7RV4SC4sQLVsnEhDGu2qv+4WrV6gQ+vePMb2/+aE5fJpKGTX4L6djDbzi6i4uBiDyf0d+tUs1/CNWynkisgOdk3RP5c/lCCppociuppiUBCo0r2N/cAYeO6VzrDkRi2EecF4sGX5DkA5iDrTbx+EMvYiHYtr7i9GYglE1e7K+Mj02baiToXlV5Hd7Z7yNvkXl6utu8AF/Hk3qhSujDwEwjJssDiEW2ytTlvsuFMxljuyL3fQTraKHB564nzjDvkvgPUU6kD8qD9ARFdFwpUQsLW2dyLMTHMGDHiMu0twyKmtq4D/YJncumyIv5YugABxq4++CQyUCE+KmUfz0JWU7ocEKvsGb2o07cHq2IQA/CBAitOKV3tYyLH9DHF3M1BpDxp8+hvlM6pzIWh9GvkM06oakYYO/tsQsmOfDyo8yqU2KtphKXvRytE6fBjl1Gw0jSsWHsBa9Qxf/y/WKCvKSgGAHQBcUZEmiNCYJS2EYr2EwZjHvLKYVSHPinKm2XQOlZnOYLIELKTH1/xMuSQ9pXl47qSlzQMsrtSyLodud07ayM8uURib/J1FjA6gMaD4ucRCYafZAvqPgYVCQLqLM6SOxwqquVlurOGtGUkD8ti9Dwpabmx+at2vUEao9Ac7o73ryTWIt+0wEqjRoZfC2qollR65m0oB/ryzE288FjUsCYxpFd7PPDO34HJAMwddiuHn3GuCFf6ynjd1olbmQASoSqc2W3XYTTgWpEkUgMVctLHOka3tt9S1qYhCcrW/c15DQUGiMeETzExlWflUbb2+Z3bq/esQO9XDyKXimHNSs6SD2IZF59SAYrnYvqmJeSWwNUKNsk7zjc1oF
 PyB0waf1
 E73WYrr9SfiID9A5aOK6uc235c37cNxnwVqD71ylYwlV6Nmo+/slDFWk1SbNEWjVga8QCyfGicrnyhuiY3OQYek8JYn7sLzqgPnncDyJwCL68S7HP0O04IGRiSX+o1zhfXUUjTV9JoJwibQdBpxMsaBXLnBSrgZzl/mYu4RGBSbdMaMiZWNVbRjzOolR/+XFql0zuKTh/YD/aS+laBPa8pEbYnVXVhiLuHOefTUsAEPrDGW+FoP4IVjKkKLiSdoOgeV+HweaEf6ena52ddb3VJA6QtH7o92fc81zDgEatQr+Ryv6Nwl0Uv5GpICjL+DGtd21QMpjzPAXmJhYUTtfcpyk29U29LQUZ6Q4VK1RXEdaC9FnuP3Nlv4/62H6WBMNbw8sdyXv9gGQBJbMDBc8I7oIcuU+Riby1Omgy7yaZ3I3mksgOoq9NFYxiMSGGlglFGRK7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/12/26 22:25, JP Kobryn wrote:
> On 2/12/26 7:24 AM, Vlastimil Babka wrote:
>> On 2/12/26 05:51, JP Kobryn wrote:
>>> It would be useful to see a breakdown of allocations to understand which
>>> NUMA policies are driving them. For example, when investigating memory
>>> pressure, having policy-specific counts could show that allocations were
>>> bound to the affected node (via MPOL_BIND).
>>>
>>> Add per-policy page allocation counters as new node stat items. These
>>> counters can provide correlation between a mempolicy and pressure on a
>>> given node.
>>>
>>> Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
>>> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
>> 
>> Are the numa_{hit,miss,etc.} counters insufficient? Could they be extended
>> in a way that would capture any missing important details? A counter per
>> policy type seems exhaustive, but then on one hand it might be not important
>> to distinguish beetween some of them, and on the other hand it doesn't track
>> the nodemask anyway.
> 
> The two patches of the series should complement each other. When
> investigating memory pressure, we could identify the affected nodes
> (patch 2). Then we can cross-reference the policy-specific stats to find
> any correlation (this patch).
> 
> I think extending numa_* counters would call for more permutations to
> account for the numa stat per policy. I think distinguishing between
> MPOL_DEFAULT and MPOL_BIND is meaningful, for example. Am I

Are there other useful examples or would it be enough to add e.g. a
numa_bind counter to the numa_hit/miss/etc?
What I'm trying to say the level of detail you are trying to add to the
always-on counters seems like more suitable for tracepoints. The counters
should be limited to what's known to be useful and not "everything we are
able to track and possibly could need one day".

> understanding your question?


