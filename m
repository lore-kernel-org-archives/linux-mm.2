Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9A29CCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 20:58:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D8E88E014A; Tue, 14 Oct 2025 16:58:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B0B98E0090; Tue, 14 Oct 2025 16:58:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE1568E014A; Tue, 14 Oct 2025 16:58:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DC1648E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 16:58:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8113A13C0B4
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 20:58:30 +0000 (UTC)
X-FDA: 83997933180.02.38EA46D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2031B140004
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 20:58:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oGN+o8wC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cOtFzaah;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oGN+o8wC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cOtFzaah;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760475508; a=rsa-sha256;
	cv=none;
	b=NDNFDRPFHkna9l9KEcjNDAKK0K/mHCfaH/axnYoEkTIsRix7fJx+LtS7ywYNuuzjky2oQI
	ZP+AhIcbcV9/lobDA9zW2kTTiHMsTV98Pk11pm5hQNW9eUAk4l53dZSCnbWl8IuOdnVU47
	fLTV16KKKAcXa6yuB9pey7LdIZfPWr4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oGN+o8wC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cOtFzaah;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oGN+o8wC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cOtFzaah;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760475508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wO2GtN18Qmp1TJ+fhrVaxDRydqucSSBXteFXigvaals=;
	b=3E4rDWh1lnx0QfDYkjFXVFSkSof1tpjIVls3Gvn5qrCb+0Wx39y1l/nUquBnXJJC5vDMlJ
	9+EUH+sL0vSvc7BugBHu5Glb02HubvyXr+S87DmAXwfyT75A3PI34+8dh7TFB75NjtaIUJ
	mdnRwbrEiRl/Uql2vFcaw8m8400fRII=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 26E7921D3A;
	Tue, 14 Oct 2025 20:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760475506; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wO2GtN18Qmp1TJ+fhrVaxDRydqucSSBXteFXigvaals=;
	b=oGN+o8wCTZu50UFQiLJIUPnZriYTW67WZz/JqznCfBnaO5glSd4yF0o28DPxvDQtFcpNyw
	UvnQ5YOus1AucermzoR+QMm7MZQKiQeSDmHyj3UPLGgrVRkOcPLDVmyJzEOd74t+i8J1gT
	I3CMYWBXuLtT2QGB1M2hLHQfXl2Wsk0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760475506;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wO2GtN18Qmp1TJ+fhrVaxDRydqucSSBXteFXigvaals=;
	b=cOtFzaahIYrB+AYOJaPPs5jYup7eSOMfh94OTroNz/Y922AC/yGFaRKKZnNhFsXMAkWJ02
	R4ROTZBGOxz3/zAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760475506; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wO2GtN18Qmp1TJ+fhrVaxDRydqucSSBXteFXigvaals=;
	b=oGN+o8wCTZu50UFQiLJIUPnZriYTW67WZz/JqznCfBnaO5glSd4yF0o28DPxvDQtFcpNyw
	UvnQ5YOus1AucermzoR+QMm7MZQKiQeSDmHyj3UPLGgrVRkOcPLDVmyJzEOd74t+i8J1gT
	I3CMYWBXuLtT2QGB1M2hLHQfXl2Wsk0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760475506;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wO2GtN18Qmp1TJ+fhrVaxDRydqucSSBXteFXigvaals=;
	b=cOtFzaahIYrB+AYOJaPPs5jYup7eSOMfh94OTroNz/Y922AC/yGFaRKKZnNhFsXMAkWJ02
	R4ROTZBGOxz3/zAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0AC2913A44;
	Tue, 14 Oct 2025 20:58:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PYpSAnK57mh9cAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 14 Oct 2025 20:58:26 +0000
Message-ID: <df175b09-c0db-4dc3-a0de-e1c38f70147d@suse.cz>
Date: Tue, 14 Oct 2025 22:58:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] slab: Add check for memcg_data != OBJEXTS_ALLOC_FAIL
 in folio_memcg_kmem
Content-Language: en-US
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>
Cc: Hao Ge <hao.ge@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hao Ge <gehao@kylinos.cn>, David Hildenbrand <david@redhat.com>
References: <20251014152751.499376-1-hao.ge@linux.dev>
 <CAJuCfpGBxUmvWoe2xv2-bsF+TY4fK-m1-Z_E3OcyTiSYz5KeAA@mail.gmail.com>
 <vdngz65wojqalim4xb6vxb6k7upbzmkfoogmbuswc4lowju3ke@32hgwjlzxibr>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <vdngz65wojqalim4xb6vxb6k7upbzmkfoogmbuswc4lowju3ke@32hgwjlzxibr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: 9txjnkt5a6mujqrjq98wdmboft119uqc
X-Rspamd-Queue-Id: 2031B140004
X-Rspamd-Server: rspam09
X-HE-Tag: 1760475507-855932
X-HE-Meta: U2FsdGVkX1+nglvD2pSzLQPPv6bwQOg62/WugMlyIIiFaxsyfsaZO3bWHn1uikujxm7C1gPcblPjNHxV8ZdxLwnUsWmejRqgrAnljO2muuAdLn2jTaZf+KeBFhMbfh/K5jTPPn7Jn89srKhmDyLiDHNvKeMo7hUQOViJXENIHBr2/E9rpBjCQNyCt0N52+BW7iD5/bAONxqv/Lx98Nm+p1UqzfbG7xHzMPsS0MGXvI2CUxKjiw0VG+89vduEozWC0FfUa/mv++PxPvx0Kfz6C8FQFjssQ4iaW3Wx/lHFu1B8rNlB5pPuhT1bJNj6cbK8LTJhcVoiTGvqvYm7CSaPvjilmfscY5w8lr+qrrukAKMJb25TZJT60BwZOXDBwWtd3WNNoLOYwF2kdpKxUiTgg6JfafHc9uqQVaoVcGzJl5GcXxstqYJkAZIAiq/oRxoH3gm3m9kpxp95iDiHfg30TUklHVyN7/zqVruDzkURRWfCmPn4LbU8buuo6wCFQ3Vfwb7CkEBcDGJUb2u3nyrwYeXSZg9ZIDH4zW5WHGbCbvYCljkwYn7AOanXAk/p5cgGiGH/D+NIlKM/adk2Vgb6PYxtwAQi/gm6QF8MOFzwtLe5Ep7MvzVZ4Q6UfH7g+dY95KD70pNI2I79WP17mRaCWDZeGlZDB2diRKc0IMdWYDK6TBQUwDkSU9sIqyUeyrdU9hqUiRQbBjE8sX6v+lA5B+pB9Qojz+Xs22zx+b6VSWPL3DG1OTOMckW6NXrs6Pl8F8MsiJKk8ClOt35qktsox/7UbD8fXb0jPoOR0QN4bqptP/N9GuKWD4KTw7FZ0x3hVVPxk7zXZnPyRjb2Ar+AJDUoAPs6ZfNsyXE+KXE/PZ45ToIuzSrO4iwc9MI9Pzn4bMIOBnYKN0nX3B3jxh5qYT1/3+Y/ylTfh0pn39l+s8c4VlUEPZWUVmuWm6aJjtHDTl2PG0832IgELmGWl07
 s3ZoatjX
 peA3D4MkPwqo61Gqwk4+uJEmbDizSgseYgTZ8oeXnPHsbaqOd2sU6rHhGMKXLLMy7oj8zg7xy/E2igUnZjeCIpAafddAjaM2TjCQSXzxq0vvB/w5ax4sQsHAkxrmwD65RP+bbu4t20HziJnhnfvArp+at5HaGd2hniDN7e1lCUGz18OE63xvcBMBrdmv+kQF+GJz3cso8e/E6rTv+Qpq2qbI4woMcJf+a8O5l1WZVyC+sN/lBAh0jPPbWTaqe1fb4N4zYZFk6SwzRgHiLiWbr08r0hnorHlQF+rbE+IjN978vGGwMUdmab37IZ87v2A7vWVV8WGNqYjUx6p20OCK7Tc7Zu+S3T7rD+XEND5mkjDkv5R2iFhrdXAKKzo1oc9LRxMhmnwWuiqUo77wmQFvQ7cEz+3jNvkADXC83UD3smTuvRYpazpTvlG/TLAMnVLArBhyg9GDYBo3+VhZF8Uyh86lkMQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/14/25 22:14, Shakeel Butt wrote:
> On Tue, Oct 14, 2025 at 09:12:43AM -0700, Suren Baghdasaryan wrote:
>> On Tue, Oct 14, 2025 at 8:28 AM Hao Ge <hao.ge@linux.dev> wrote:
>> >
>> > From: Hao Ge <gehao@kylinos.cn>
>> >
>> > Since OBJEXTS_ALLOC_FAIL and MEMCG_DATA_OBJEXTS currently share
>> > the same bit position, we cannot determine whether memcg_data still
>> > points to the slabobj_ext vector simply by checking
>> > folio->memcg_data & MEMCG_DATA_OBJEXTS.
>> >
>> > If obj_exts allocation failed, slab->obj_exts is set to OBJEXTS_ALLOC_FAIL,
>> > and during the release of the associated folio, the BUG check is triggered
>> > because it was mistakenly assumed that a valid folio->memcg_data
>> > was not cleared before freeing the folio.
>> >
>> > So let's check for memcg_data != OBJEXTS_ALLOC_FAIL in folio_memcg_kmem.
>> >
>> > Fixes: 7612833192d5 ("slab: Reuse first bit for OBJEXTS_ALLOC_FAIL")
>> > Suggested-by: Harry Yoo <harry.yoo@oracle.com>
>> > Signed-off-by: Hao Ge <gehao@kylinos.cn>
>> 
>> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>> 
>> nit: I think it would be helpful if the changelog explained why we
>> need the additional check. We can have the same bit set in two
>> different situations:
>> 1. object extension vector allocation failure;
>> 2. memcg_data pointing to a valid mem_cgroup.
>> To distinguish between them, we need to check not only the bit itself
>> but also the rest of this field. If the rest is NULL, we have case 1,
>> otherwise case 2.
> 
> With Suren's suggestion, you can add:
> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

Thanks, I added Suren's suggestion and pushed to slab/for-next-fixes:

https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git/commit/?h=slab/for-next-fixes&id=711c435c89e59ee32bf8bb1c0d875a07931da5a8

Resisted the impulse to change the single VM_BUG_ON_FOLIO to
VM_WARN_ON_ONCE_FOLIO because we're still going to do that systematically,
right?

