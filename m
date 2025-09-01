Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ACF3CA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 20:34:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97FB98E0001; Mon,  1 Sep 2025 16:34:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 957AB6B0007; Mon,  1 Sep 2025 16:34:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8465B8E0001; Mon,  1 Sep 2025 16:34:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 70EF16B0006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:34:38 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 14CE0BC73E
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 20:34:38 +0000 (UTC)
X-FDA: 83841834636.09.0272907
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7DC4D40009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 20:34:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=I0OuUyub;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ykD4WBi+;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=I0OuUyub;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ykD4WBi+;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756758876; a=rsa-sha256;
	cv=none;
	b=39m51i56snr4hcLr99QPymAnYdhHt1uv1Odps/tD2xF/jNqNB6q0qDmba0u3kkmatAhFsI
	1EgIAW9G6v0gwJGADRFXOJ5qbfVQ4kYuJMAB7eI/PBDHn1SgoioR0N1M3g7pIBp9lsqBXD
	SKXfEXwg3UcMQWjalZE7eT8gd9oBRDY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=I0OuUyub;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ykD4WBi+;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=I0OuUyub;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ykD4WBi+;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756758876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8dcBIcGOTls1ytHHhv5Oh0JDQHI8/8jhSi/d7/t8aA8=;
	b=UhLZ6H/XStqmfkioxORo12sfGIxNDzxC/bOkJQur0ysAuDZo5G1ZUQ2ADUN8RxNPZQdyEC
	IWThKj2mMOgbL04E3XgPlk9YO4RkU6n4ANOq7GYYmAjoyr51uFchB62stqBgzCx2z3NfYc
	H/Z0EirORli3dXmaakQozuHKZCfq2Rw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 701211F397;
	Mon,  1 Sep 2025 20:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756758873; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8dcBIcGOTls1ytHHhv5Oh0JDQHI8/8jhSi/d7/t8aA8=;
	b=I0OuUyubcdYkMHYcJ5Rdj7qiyuZauJOpXotZ1c5cGyKMYqSx/4xOfnRL/BkfHrIjDi15GD
	/jafyJ3ygWmOOJ8+Td7q8rIJZrWvyrMQkPUr+cN63eQih1RL5aDPJkesQQYAOm2vrjMoFE
	sH+zJ2ercuv6HviXS7KiX4o6wLcDx1w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756758873;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8dcBIcGOTls1ytHHhv5Oh0JDQHI8/8jhSi/d7/t8aA8=;
	b=ykD4WBi+G4faz+l8DrI8zBYZmWh1/bNb+yTYqT8vliGLHnTawoTJ1rp1TcwaQee+CF2GWl
	7RRiZQpEhcMtmyCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756758873; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8dcBIcGOTls1ytHHhv5Oh0JDQHI8/8jhSi/d7/t8aA8=;
	b=I0OuUyubcdYkMHYcJ5Rdj7qiyuZauJOpXotZ1c5cGyKMYqSx/4xOfnRL/BkfHrIjDi15GD
	/jafyJ3ygWmOOJ8+Td7q8rIJZrWvyrMQkPUr+cN63eQih1RL5aDPJkesQQYAOm2vrjMoFE
	sH+zJ2ercuv6HviXS7KiX4o6wLcDx1w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756758873;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8dcBIcGOTls1ytHHhv5Oh0JDQHI8/8jhSi/d7/t8aA8=;
	b=ykD4WBi+G4faz+l8DrI8zBYZmWh1/bNb+yTYqT8vliGLHnTawoTJ1rp1TcwaQee+CF2GWl
	7RRiZQpEhcMtmyCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1320D136ED;
	Mon,  1 Sep 2025 20:34:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6xsTA1kDtmhlOQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 01 Sep 2025 20:34:33 +0000
Message-ID: <63a6962f-6ffb-47cd-806d-ec568f0b2df7@suse.cz>
Date: Mon, 1 Sep 2025 22:34:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: memory-tiering: fix PGPROMOTE_CANDIDATE counting
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>,
 Ruan Shiyang <ruansy.fnst@fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, lkp@intel.com,
 ying.huang@linux.alibaba.com, y-goto@fujitsu.com, mingo@redhat.com,
 peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 dietmar.eggemann@arm.com, rostedt@goodmis.org, mgorman@suse.de,
 vschneid@redhat.com, Li Zhijian <lizhijian@fujitsu.com>,
 Ben Segall <bsegall@google.com>, stable@vger.kernel.org
References: <20250729035101.1601407-1-ruansy.fnst@fujitsu.com>
 <20250901090122.124262-1-ruansy.fnst@fujitsu.com>
 <20250901125917.e9792e5d0df12ba1c552c537@linux-foundation.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250901125917.e9792e5d0df12ba1c552c537@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 7DC4D40009
X-Stat-Signature: 6xodo1r1z4bao5ynb3switg9dn6rp6jx
X-HE-Tag: 1756758875-801207
X-HE-Meta: U2FsdGVkX1+t267s8PHN63Rs4iFDWSLicNlfEIQ/oH2DnfddlOzP8m9StOwJzbrIJZm8VJuCD8NKO7dAooh/map1JDm0TUXBlPXakfovLIfOvhAl6gEB/nq9uJh43A+ok1RSauDXUHkQT6SyP2AZGUQXPPtRds3KczfZFfdwnm+PlWycYo3SEosKmeV3m8l+lDCpZ+EvuvBuxUivTUJEc9HkmPyq4xnZO1xx/jTss4bzpXVGEsJhOxF8kjbCBpiDOLav/J7y0/fPiN4EAfbinCwsOViq4Rc4gfJMP/3jZWbRAOVN/ar/6Mq//BQun5Jai75h6ryXH72MQWtqysuL/4xcHJY1kxo7cL3/d+D56HdhGuP+DbiW8TN5YW5VaOBNVOLnLhheyProsD/Vk66tmHCvm6d5EiYMBdAoaAkgB9rbyUiy33ODauF/vIF4uxh87WFvtc85s8nkci++HZSVG43ScLnkGy8/moMPpjhBJV2Tbo4/8NB1Ak+pMeilOndd0A4rBAQma381UtyDRV5rgJ4WZx1AwlnYJO12y3+99gYWTcuD+QTJ22WlHms65ntxyvczBOwSA8QT8fn5+75ihAb/YxTrqdqJg+Vk9dnruSuOUnhWwA8hWDB6nNwFAaCmciivFxzost+V7XkBqlgBnP5t8Wk8JigtDZ6WZZxev43CXnUsgPnql4ySp+ukc4KXbTKSr+mSx56WvyMk8ACnN1//uP8MIoW5wNR5O6YOo++UPJmBgV5AMNS2FlG6A4FO+HlaxeaLDQvkQ7SExYUIT4GvlMpyoxKfqC+lbddlh/99vhELpsZ4BWv4UIFSFt3b9vMieNlzYLhCVphnsLupaho9f0cyY1RPaqKj85V6wLVi0+YOHJZxs5BdY8SALm49gB3gd8LfAdDYtcwtqZfdf+g68PJh2h6ONHXpGT5bTuDOB0Rh/5atfzfH3cx/rJgJOPZr59pizHnb7TKaeip
 Sc3r6ir6
 55bKR6oRoMb5+c1zwKRUH37hf3NNle+PfM8EbBqfX61QVoh4RhcudkhEfv84xaUU9u9/OyMubDmFUgaKyz6A8NI4ZwOHUOe4AZtBFH20h6nmhbVqU1qgdgCncjq1xC+MySh0kJRdjOlmabKe2Sn944nU2bPwMV4QD3jwQTxvZ7PwXrA1MllagqbG7dPSzbTlbUgs6i0hXD1v1+BpwoZykYX0id0HGzOZv6w9PkYd2E6KaguCK+IgdlNYMqszdxxgSXyRaG9/LPnHb6gIqy9zjFNW2p5ePQDZRdBVVOAFdvKajGmpU4m9NRBTFeNLhVYvdcQ+jV69T7FxJ/2scW8LwGggcFlxd8HgLkXadpIN9YvPfi7w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/1/25 21:59, Andrew Morton wrote:
> On Mon,  1 Sep 2025 17:01:22 +0800 Ruan Shiyang <ruansy.fnst@fujitsu.com> wrote:
> 
>> Goto-san reported confusing pgpromote statistics where the
>> pgpromote_success count significantly exceeded pgpromote_candidate.
>> 
>> On a system with three nodes (nodes 0-1: DRAM 4GB, node 2: NVDIMM 4GB):
>>  # Enable demotion only
>>  echo 1 > /sys/kernel/mm/numa/demotion_enabled
>>  numactl -m 0-1 memhog -r200 3500M >/dev/null &
>>  pid=$!
>>  sleep 2
>>  numactl memhog -r100 2500M >/dev/null &
>>  sleep 10
>>  kill -9 $pid # terminate the 1st memhog
>>  # Enable promotion
>>  echo 2 > /proc/sys/kernel/numa_balancing
>> 
>> After a few seconds, we observeed `pgpromote_candidate < pgpromote_success`
>> $ grep -e pgpromote /proc/vmstat
>> pgpromote_success 2579
>> pgpromote_candidate 0
>> 
>> In this scenario, after terminating the first memhog, the conditions for
>> pgdat_free_space_enough() are quickly met, and triggers promotion.
>> However, these migrated pages are only counted for in PGPROMOTE_SUCCESS,
>> not in PGPROMOTE_CANDIDATE.
>> 
>> To solve these confusing statistics, introduce PGPROMOTE_CANDIDATE_NRL to
>> count the missed promotion pages.  And also, not counting these pages into
>> PGPROMOTE_CANDIDATE is to avoid changing the existing algorithm or
>> performance of the promotion rate limit.
>> 
>> ...
>>
> 
> It would be good to have a Fixes: here, to tell people how far back to
> backport it.
> 
> Could be either c6833e10008f or c959924b0dc5 afaict.  I'll go with
> c6833e10008f, OK?

LGTM as a helpful pointer, but I don't think Cc: stable is necessary for
"admin might be confused" kind of thing if that's there since 6.1 and only
came up now.

