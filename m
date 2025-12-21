Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 810D9E66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 20:43:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF0B16B0005; Sun, 21 Dec 2025 15:43:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9EEC6B0089; Sun, 21 Dec 2025 15:43:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C555F6B008A; Sun, 21 Dec 2025 15:43:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B2ACA6B0005
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 15:43:07 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 63FD413344
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 20:43:07 +0000 (UTC)
X-FDA: 84244652814.23.730A06A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id DE0C140005
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 20:43:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1kgWs9wn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ufetOYAI;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ybEydBSI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="JCG4Sk/m";
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766349785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=boLuaw1unK45fKbpB1XGKzYWrKDHJnzdks4RpU1QtjM=;
	b=SbT5nYdOv1pNvy+FmxnIKyt1aT65z/IuKRJQuLsgfSEqsGB2Qv59ye4OPuBkaKstBcp8Fw
	/+CAM+fdaBqT9PPGWil+KrIX2+xtSw/wp0pqwZ62lyJxjUO4P2qECd+ZSi3jQ0m57osuxy
	xiQ948dNLTyK79DiI/UF+2prPaYes2I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1kgWs9wn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ufetOYAI;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ybEydBSI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="JCG4Sk/m";
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766349785; a=rsa-sha256;
	cv=none;
	b=y+eLMKotEgQbibOn++dMQ4Z57RXfzhrZDEtyf2vaY5nQCfMCdrTOParxbFSrkkmbuB8Cww
	4p2C+NR7ExCYHroVn03P6OgY6USHybmy6WvEEOcCNQhJEJXi1JX1nWppZDuZOFTMSRdiTq
	sE3wEnKW2P2HoHGF5w1c7b9kw9XLgI4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F152133691;
	Sun, 21 Dec 2025 20:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766349783; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=boLuaw1unK45fKbpB1XGKzYWrKDHJnzdks4RpU1QtjM=;
	b=1kgWs9wn2P21osXBHtWKd9GspxmejJnvmgZzf8I7m+rjBRgNvhGfYS0wt62iYjUFy+F+dl
	ctuOb4b6z9w7HwpUBSWeEw96w4XhuQ2inV+8FZKD42ohE2uI+TmpcHNdf1RrL6a/pxJFny
	voayzrFS13uLthYP3Z449oNt6f1xfgs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766349783;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=boLuaw1unK45fKbpB1XGKzYWrKDHJnzdks4RpU1QtjM=;
	b=ufetOYAItjNAy3Wrsia+pQAvvLmixoYRxoYaHlq+DJscQECQV1ZkRb/Zl+xrLxOH4yWH3A
	IrmJ+LCmb9HiVgBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766349782; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=boLuaw1unK45fKbpB1XGKzYWrKDHJnzdks4RpU1QtjM=;
	b=ybEydBSItQLF+A25xshpwpY7QWAg/3cl/uld7iSYlQuMaIvYYKBiPXyqYlXlo4DjVy1xzP
	aYw+wc0hl9x7Z+xK7vZwqipqr1sRwEDSKjdMVEG34Bp3dvMJXQnZmnBjnQg7Dnat9MKxxl
	ZVOlaXQNsnfcu5AW/JdVJj8VxZriO4g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766349782;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=boLuaw1unK45fKbpB1XGKzYWrKDHJnzdks4RpU1QtjM=;
	b=JCG4Sk/mDvYuZjFF4x+ofg27WtjuCwnydXVZ8r2ArG0JmohYD8QbqIJq/3kWFnz4MxVGBh
	vX4EiTJxV+Xs+BCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C891413A54;
	Sun, 21 Dec 2025 20:43:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZvoiMNZbSGnnXAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Sun, 21 Dec 2025 20:43:02 +0000
Message-ID: <9fcd1188-8ad7-4c7b-afd8-647d97b7aae1@suse.cz>
Date: Sun, 21 Dec 2025 21:43:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm, page_alloc, thp: prevent reclaim for __GFP_THISNODE
 THP allocations
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, David Rientjes <rientjes@google.com>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251219-costly-noretry-thisnode-fix-v1-1-e1085a4a0c34@suse.cz>
 <20251220141601.e6694f904167bf12fa319a89@linux-foundation.org>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251220141601.e6694f904167bf12fa319a89@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DE0C140005
X-Stat-Signature: ws5sdc5z314h4e865eepa3sn5o1jsx7n
X-HE-Tag: 1766349784-361321
X-HE-Meta: U2FsdGVkX1/P0IEqrpXO+SNJsHpoz9nTYyBygEwHgViSzZioXzlwaaNaioJSBgDkVQdl5VmRxsmsWNT/AYwxjmAip/hjf/L7vsU2Ig9ipQ7zpJekgg5itXvsWD9w80GG628p/EnEd5CG42H2WRA9vIaJFoSPOHSlUZXT56Tf5Uqbbx4gbz+RroffgzjBhg0v48oSWUmghbA3v5JV21Qai7eO1vkqg09SbsHW5/1CWxp0XcbTWfZ1uxek+azpbMBznBIh/207ncGU2u9N4dr8va1kpdEhuFQxUJoPJgTqNZlkfPxxcNz4/XGYr1zvyVwbGpC1Cqv2zLlAvTEPoTqv9Y2ahh1hNCyHOsHcbAr3wrf7c+NQiPLNTIbi4zyAfAqfs7zRr/McrXbLdQ4KqS8e4nWo5zXQVOlFACK11hRFYGVkCJ9QQBeuAWV9OaArpaDw/TuBgE2PIjrEzgMfPhuGK4bg5pBA7WQrTU2Ln+4dX6ETdWRMsULrTKMxTD0TDxL/kk0S/2r2yow2SwK3T10UJtdSrTdiUVbh3/hnOwkuq6aSsU+iCFMPKQh6jj4Nv6+Yw/fjdIatXw/Si1ZaBJSqE9ONapzV+z3A1dBi2hnkcjZrR+NJKNmZFVLCmItUOhTZon9k83e4r4BDvH5wc2KQ6WbEtoZV6xqKm04NSYoAjMOIRFONHKL7rzI49U5TodIDgafgXNoissR15M7fFI+VkNT/srE7ABaul1ZQ3/piHylKls3hFCy/+irnTPq/kZOZMN9dndUn/TU1qevIaamzAbqL2K4VXMkkSkUepB1gEAbpnOGtsRpz6rKUN65Ga8S0BW8JXWCFSGEdYFgjY9Ivm2H1gOFyNznoS0V8GsDaT1leFo3no0n7c+/yngMdJ+fI4ZLfbpZULidEMlolsNnXO1v0WNL03crVsO51dAplalgNJWEmnMtHifAjpOpIdIIcjrfM9DWQXVPH992NJwH
 jo6xYjkt
 myqDLHN7aflYMDDYSwMAzvJOltiH6f9tQe5p+ntvmnSTfyinoEc5xwuyYZ6WFAEDBrhHQg3TgvQi2JtmPKx9Fk5Qv4w1B+4DXW0VkR2nowvcGkJeeXHUnZTyZEpAImy8WsQiJSA7CBc6O7xMRayOuUegkfFxSAqCpwJRHGwEJ0RlHWpBDFNmMR2E2Iddcy/5MbMvVULJbsH7rFrmdimPjt3ECiJU9ZtgDI3MWmFDDkYF6UkTcTZOwlOYUzZH0m4JDt0fhmiFpeSJ77Vvha5Y6bRd2Ms0buSdHa8BGWYn5niQtzqyhTs3yULhVPj7nsS4uqcdLBWvr4NAlV3pX7xjPGaTBHsSofVAG+EC8oy6gllkpFFUZKm0ARADOKQersCcBq1yD8eJ7dKpjtlyIj8MeYcvn2Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/20/25 23:16, Andrew Morton wrote:
> On Fri, 19 Dec 2025 17:31:57 +0100 Vlastimil Babka <vbabka@suse.cz> wrote:
> 
>> Since commit cc638f329ef6 ("mm, thp: tweak reclaim/compaction effort of
>> local-only and all-node allocations"), THP page fault allocations have
>> settled on the following scheme (from the commit log):
>> 
>> 1. local node only THP allocation with no reclaim, just compaction.
>> 2. for madvised VMA's or when synchronous compaction is enabled always - THP
>>    allocation from any node with effort determined by global defrag setting
>>    and VMA madvise
>> 3. fallback to base pages on any node
>> 
>> Recent customer reports however revealed we have a gap in step 1 above.
>> What we have seen is excessive reclaim due to THP page faults on a NUMA
>> node that's close to its high watermark, while other nodes have plenty
>> of free memory.
>> 
>> The problem with step 1 is that it promises no reclaim after the
>> compaction attempt, however reclaim is only avoided for certain
>> compaction outcomes (deferred, or skipped due to insufficient free base
>> pages), and not e.g. when compaction is actually performed but fails (we
>> did see compact_fail vmstat counter increasing).
>> 
>> THP page faults can therefore exhibit a zone_reclaim_mode-like behavior,
>> which is not the intention.
>> 
>> Thus add a check for __GFP_THISNODE that corresponds to this exact
>> situation and prevents continuing with reclaim/compaction once the
>> initial compaction attempt isn't successful in allocating the page.
>> 
>> Note that commit cc638f329ef6 has not introduced this over-reclaim
>> possibility; it appears to exist in some form since commit 2f0799a0ffc0
>> ("mm, thp: restore node-local hugepage allocations"). Followup commits
>> b39d0ee2632d ("mm, page_alloc: avoid expensive reclaim when compaction
>> may not succeed") and cc638f329ef6 have moved in the right direction,
>> but left the abovementioned gap.
> 
> Cool.  What are your thoughts on which kernel version(s) should receive
> this?

We could just cc stable and let Fixes: do the job. Should be safe to backport.

