Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4862CEB4913
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 11:52:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FB9B6B0005; Thu, 12 Feb 2026 06:52:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A9C26B0089; Thu, 12 Feb 2026 06:52:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 260BD6B008A; Thu, 12 Feb 2026 06:52:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 156296B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:52:52 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 51DE41BC34
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:52:51 +0000 (UTC)
X-FDA: 84435642942.23.35BCD3B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id C54F81A0002
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:52:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dOJDguNi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FETaJrdp;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dOJDguNi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FETaJrdp;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770897169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6BtatYL7qZoefALqhfawiID8QpBEFM7BqhWoHgJI9ME=;
	b=OKTaiOrqR1AeqpryiSpLyRnE3Yq3Y66opqurAuvthGn26QHbUbbK/HzJYWTai4x6pNB1Ey
	vXWxcligIxxUQbG0HiSRjpE9oB2JtRHkOnyV/1WWT98GbHErH1AOwTAJmo4VGeszChtfle
	Ho5zw7zqjaU+qSJkTH+Y9ENglW6/jgk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dOJDguNi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FETaJrdp;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dOJDguNi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FETaJrdp;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770897169; a=rsa-sha256;
	cv=none;
	b=G3AcjZGt3Z5p3CuomfHPhqJIW6b+hs1GT9iFc4eYS6RmDcPXwMud/Rh3HxgxYVd3YyRecU
	pAgyqXXIibfLWlbfiRCll2+Ha9fr3jEfClWsOwBzdNTFClecxU9kwqRVAZMc4xySGVNAzc
	JpzhbUrxBwt9mysPoUawlMbufXh8Tz8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2B9A03E715;
	Thu, 12 Feb 2026 11:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770897167; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6BtatYL7qZoefALqhfawiID8QpBEFM7BqhWoHgJI9ME=;
	b=dOJDguNibBHlqGRcY8iRFHO340/vZF8fnbpv2bhnqIkJgrrUQ1MPeHZ07/XsSFT22W31d5
	JKL3dCBtsXQtwopquZOnVu7QkOivS7a7UzjqBI0ND1KwZTM1gVtUbHtYQgHjKaDnzuev+9
	e/9NgW8oamDL0JCaU+tVnoBdEDOp4GY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770897167;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6BtatYL7qZoefALqhfawiID8QpBEFM7BqhWoHgJI9ME=;
	b=FETaJrdpoHbblRB0eKOdfzPBy31/chvwhDnf4qq8rGIiiMhGnZungNWbbypJAiponZLASB
	+sopEjeSDTnX9yDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770897167; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6BtatYL7qZoefALqhfawiID8QpBEFM7BqhWoHgJI9ME=;
	b=dOJDguNibBHlqGRcY8iRFHO340/vZF8fnbpv2bhnqIkJgrrUQ1MPeHZ07/XsSFT22W31d5
	JKL3dCBtsXQtwopquZOnVu7QkOivS7a7UzjqBI0ND1KwZTM1gVtUbHtYQgHjKaDnzuev+9
	e/9NgW8oamDL0JCaU+tVnoBdEDOp4GY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770897167;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6BtatYL7qZoefALqhfawiID8QpBEFM7BqhWoHgJI9ME=;
	b=FETaJrdpoHbblRB0eKOdfzPBy31/chvwhDnf4qq8rGIiiMhGnZungNWbbypJAiponZLASB
	+sopEjeSDTnX9yDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DF6C53EA62;
	Thu, 12 Feb 2026 11:52:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9+vXNA6/jWlXcwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 12 Feb 2026 11:52:46 +0000
Message-ID: <3b9be1ce-ef00-481e-b36d-5b843be55d10@suse.cz>
Date: Thu, 12 Feb 2026 12:52:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/7] mm/slab: introduce k[v]free_rcu() with struct
 rcu_ptr
Content-Language: en-US
To: Uladzislau Rezki <urezki@gmail.com>, Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, Hao Li <hao.li@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Puranjay Mohan <puranjay@kernel.org>,
 Andrii Nakryiko <andrii@kernel.org>, Amery Hung <ameryhung@gmail.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 "Paul E . McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Dave Chinner <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Muchun Song <muchun.song@linux.dev>, rcu@vger.kernel.org,
 linux-mm@kvack.org, bpf@vger.kernel.org
References: <20260206093410.160622-1-harry.yoo@oracle.com>
 <20260206093410.160622-2-harry.yoo@oracle.com> <aYxXE6CC0XQr1KNK@milan>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aYxXE6CC0XQr1KNK@milan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C54F81A0002
X-Stat-Signature: j6qfgq349bfmr6qgnqzztzi7kkha3yk8
X-Rspam-User: 
X-HE-Tag: 1770897168-845216
X-HE-Meta: U2FsdGVkX18yMWSf8G3A9jC3Uq3VLZQkDoyQ/T3bZZ1Jtd15p1gWF0g0+XkQT3ghLfgiYG0xBfimEaxLTE58pBSf2zeWQC0de1IFEEEWUZVZZCydsmgzyq5FrBd/9WbxZN7SjB/KOvzfmesCPAN6plEYZEFJ5gGs02yVrV5iMCUIu7nKNOCj959tllj/RQUdDSH7RoNkyDBbwA+KYVKgtsYnN8fwth35nz6L3dCsbUHo+ZQ6dDNnIwdzBlNhl//kauk2J43yybwbFTKb7dYTZk8inwMc6TxprF4kqL2g2sC9GYXzai+caGSGT0PZZnnc60J+mXvaCWKph92aqrCibQ639PwTCCvctLrOPJhOs+ksgm2ISJrwyGc8ibiAubHzBOrSHLDYuS04NVpSajr3eTc7RCoUOWSc0oKTZAH8JrSRLIMT/REPsb/AGkff272IpUXC5JzRNSkpXhNK1sLQrZDy6g1O2O62WY5E15bEAzFemyEQmE79jg3t7nqfzGboeUM+7BR72daXKd5j+GvSFE1IIWQ9nAAfoO/HdjWp4Id4D3MC8lko/Sa1OmjB5GtojcHuIyqNteVL+UlkWIyEGdME8nN9sBOxPaO0hPmOHxNbOOjVJnw65BWuDaov4y2eP6o1mx5OCrXLqGisvRfE3n0E53zAw3scSCCeLQBMjMIO0Fp64Xs2G0fywd1guHOUTUFZrJmAhIP79HAQ+s9OsxgbuosJbL+gEGYbVLc36ytfamoR0Tzd3YFR580sZoCUSsq/CvSqvG8uE+35IWtYrgA5fUOlwd251X7HfoIx5x15WPmVWZ7gQNCok+vvB8kGDqAEcJMYevzdsy1HgZ11Z5iNAVtp+k/MHcvMsRt+1PVXGkCutyw2G1tc0LStmA454/QoTeF+Dbd0u1zobbctysT66tiuCFqEtj3qkZoGfcQ+ZKsL9K7S07MBiI4fMGeaSLarsCn65pH6twYQdpK
 35guhUIj
 b2CPXWl4WlrMfLc87RuxQTaSvrBfPYNlmclHV578NsUgJXrOJLtqG8Mxx5DhN0VXuqa62H2P+dYMTcEMatGXIta3naW27vEHxjvbsbHaNvCLTPjP5keoJEB4daoLGSYvj6z6lIDRLY31v86b7C/UMOXJzTlv1FdYD1qwFsPkzTR0QMqkEwK+AGMlR5s00kYlIcQgwjCw/boAOAw/+yfcGJj4O4btVWjEuxRQs/1o2MbPGstd2yRxmwzVz6AXaS6e2M10QQlaMWsovJ0y/f0vQ84wkbYxbwe/+OuraftyFyIeEM2L+kbBz7mmTCDVd3dhii4Fn7YwX5XGUjoD2MlCBPYt21rsNpc5WZhFVKkDIqjR7eW1i0Mtssm5sRaTU/nKWzHhQNDr1bwGPr64SnnuCV2lejQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/11/26 11:16, Uladzislau Rezki wrote:
> On Fri, Feb 06, 2026 at 06:34:04PM +0900, Harry Yoo wrote:
>> k[v]free_rcu() repurposes two fields of struct rcu_head: 'func' to store
>> the start address of the object, and 'next' to link objects.
>> 
>> However, using 'func' to store the start address is unnecessary:
>> 
>>   1. slab can get the start address from the address of struct rcu_head
>>      field via nearest_obj(), and
>> 
>>   2. vmalloc and large kmalloc can get the start address by aligning
>>      down the address of the struct rcu_head field to the page boundary.
>> 
>> Therefore, allow an 8-byte (on 64-bit) field (of a new type called
>> struct rcu_ptr) to be used with k[v]free_rcu() with two arguments.
>> 
>> Some users use both call_rcu() and k[v]free_rcu() to process callbacks
>> (e.g., maple tree), so it makes sense to have struct rcu_head field
>> to handle both cases. However, many users that simply free objects via
>> kvfree_rcu() can save one pointer by using struct rcu_ptr instead of
>> struct rcu_head.
>> 
>> Note that struct rcu_ptr is a single pointer only when
>> CONFIG_KVFREE_RCU_BATCHED=y. To keep kvfree_rcu() implementation minimal
>> when CONFIG_KVFREE_RCU_BATCHED is disabled, struct rcu_ptr is the size
>> as struct rcu_head, and the implementation of kvfree_rcu() remains
>> unchanged in that configuration.

Won't that be too limiting, if we can't shrink structures (e.g. BPF)
unconditionally? Or acceptable because CONFIG_KVFREE_RCU_BATCHED=n is uncommon?


