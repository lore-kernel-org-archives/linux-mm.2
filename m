Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53841CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 08:57:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADA228E001C; Mon, 10 Nov 2025 03:57:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8A268E0002; Mon, 10 Nov 2025 03:57:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 952B08E001C; Mon, 10 Nov 2025 03:57:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7D58F8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 03:57:45 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 45059BDE7F
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:57:45 +0000 (UTC)
X-FDA: 84094094490.21.8DE5DB4
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id D2BD0180009
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:57:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xJ4JLcO8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UonIxuOO;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xJ4JLcO8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UonIxuOO;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762765063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=siZRVH70jFKzKR490A0VZN08CJotwp+m2xqJ3CjFvic=;
	b=TtDDmyZwDNIMAxsaQuzy/zlDU+ib/P4UESD2uOevp5RqzeDdeU/t0SWpGext4odi80tTFc
	fCH/7IqV/QOOxVBpJIp3j5IUk+CumNG0qIigAah/9DyKbKDlQC+aub3p3R02bXyHC/siO+
	mYrzP5MIXAdEqkOijLwodP0JZJaqM40=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762765063; a=rsa-sha256;
	cv=none;
	b=oSQ4RJQKZWjliVe/hZe+Yk6PkLz23YHDi8zb6Ox2tGCRFAHviCqFy/P294+IOsDsy9HT0t
	JU2k+0b4/aBfiUXjY/n9KsaEZ8FbnHCiCmKQydxTJTIMdm6gWgJFSK4TN1WkmdUeWHffeI
	Pp3ZceErB0LcF62XJU+/zMNFwdSrIb8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xJ4JLcO8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UonIxuOO;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xJ4JLcO8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UonIxuOO;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 478D91F399;
	Mon, 10 Nov 2025 08:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762765061; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=siZRVH70jFKzKR490A0VZN08CJotwp+m2xqJ3CjFvic=;
	b=xJ4JLcO8x28CraL5R6Q64huVUOrph3Pwm32nv+eUvApWcUKQuLRmp85Q1BsSeUB1fJQasT
	O/mmdZ/KhPEacYuPo/H9Gl4vbClSCWR7qeslHCK51awvaGP1HEQ2pMOqiWxM7C+wCs9NUM
	koM9D4IISA84n6X8lUYH55WEun+j+V4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762765061;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=siZRVH70jFKzKR490A0VZN08CJotwp+m2xqJ3CjFvic=;
	b=UonIxuOOV7xWL0FJW6uBv67cBpSDSg2R4yzHuc5rwFn7uqq18aKyhVEaKAMU7RwUNdswIa
	2p/hYY/rox1EEjBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762765061; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=siZRVH70jFKzKR490A0VZN08CJotwp+m2xqJ3CjFvic=;
	b=xJ4JLcO8x28CraL5R6Q64huVUOrph3Pwm32nv+eUvApWcUKQuLRmp85Q1BsSeUB1fJQasT
	O/mmdZ/KhPEacYuPo/H9Gl4vbClSCWR7qeslHCK51awvaGP1HEQ2pMOqiWxM7C+wCs9NUM
	koM9D4IISA84n6X8lUYH55WEun+j+V4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762765061;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=siZRVH70jFKzKR490A0VZN08CJotwp+m2xqJ3CjFvic=;
	b=UonIxuOOV7xWL0FJW6uBv67cBpSDSg2R4yzHuc5rwFn7uqq18aKyhVEaKAMU7RwUNdswIa
	2p/hYY/rox1EEjBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 241DB13BCF;
	Mon, 10 Nov 2025 08:57:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id l8VxCAWpEWlzSwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 10 Nov 2025 08:57:41 +0000
Message-ID: <ba25b398-b63e-4bd2-b613-ee1f783524e4@suse.cz>
Date: Mon, 10 Nov 2025 09:57:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: memcg: dump memcg protection info on oom or alloc
 failures
Content-Language: en-US
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, David Rientjes <rientjes@google.com>,
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Meta kernel team <kernel-team@meta.com>
References: <20251107234041.3632644-1-shakeel.butt@linux.dev>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251107234041.3632644-1-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: n1q85a1dq4byh3aowf74kd5ujzyfjh69
X-Rspam-User: 
X-Rspamd-Queue-Id: D2BD0180009
X-Rspamd-Server: rspam10
X-HE-Tag: 1762765062-669883
X-HE-Meta: U2FsdGVkX1+vJe52IXDXEHu9ddMwehFs2m0jIJI3z/fmFQDDKd3wPdgDxuouIqVMlX4ofv7eUvTKc7FtMmQT0RVOCR6K/moJIxBwuTiJ1+t6/nM7YVPEOlw9z4XMEJtJao/9wtIL8ROPCO7HFLWe3HLmFPrsIqC0JpoY1wRlKo9zh8N0Z/gMu9km5C6KBzOZ5nX/2fHdda1PItWsqG87fUUUbC7sY0Yp3Nj1+xIvgkQJZQbyjG5SodYSBA0WdKV4ToNDExQ6FcCbtz5xoYb9F/6oGvrEU1L3rrxvqRZCjTznr+DnXLghAtY7ILCyzNsValCsB2hp6fIAOCDOC632vfy5QOTMYyx9gSq3iu/qLxcDRoQ/hMQroeuBHV21qev44BClPxI+BHxULYKWX7230j1TCaBpKCa+4/JQdVjD/RE9F2qtAphgCW9yonURryVtNOOOkvFsn1V+K3wZxXpD82HOE6imdP0dfmogbOzRd7ihNTk1xdf3AZKP5TXRDheAeYK/WFh8r8ffftcER1RDZ7EmmTdtZ58a/qwzQG6g/M0eO+gfcrKcf/y161w+UdxVyA7ZIhHNq5RJpX4TOrO4TGqSO0ThQagtzumGub1Whz1yxGlAirNqwOqbRFlhRLclD6y+Nl1K546sMlDWvVj7NAyBaOw3l3Y0h8sprnKXmNmYQPeV3iOicENA5fYK6x/hVHdFfP0eqt9O+KORhgbx6y1/sXOPpmQudd/mhvEovtmgYkFNnLWcqhjjaN0kWfyc2FZxvmt6ywgJ6Q2119cQbn6lH2ClEOxnqcWbnZUEHJWO1AVYC9mZ0p43pESCmM0spW4S8yNRmqFL8gEPBN7ezcy4B3pEaQTBWUa21yxC5nAq+GbYzKXjacEECmcuwAWyKJ8kISNirZfSuLo29VHm7gkO1BObvhjOoge12IiMdqPWetO0fUmtQPfTNkpETF8UP6JMB6LewDaSKtwVRbB
 dLmFr2eS
 14Ku7vXJ75djkkvF14GBIio+O6nG4l2AjxAoRsLeFTH0cWqi5ew/pe+UrD5mAaW1AgcurNyOFe9UZZyf5PfJFPKDjeXgmF43ZfR3oOFEm0owwUhJTZcZgqFwCNbKly73qXtax2ALjg0iZ5ZnFwVWtvc5auKRThslEgAeLOlSROsExOwPHQAcUSwfknBNnNaFb23dSy4DBYb4AGmtD77xHsvAzn3SefEQaouUmLPKsVNxWDYjg7Bau625CtQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/8/25 00:40, Shakeel Butt wrote:
> Currently kernel dumps memory state on oom and allocation failures. One
> of the question usually raised on those dumps is why the kernel has not
> reclaimed the reclaimable memory instead of triggering oom. One
> potential reason is the usage of memory protection provided by memcg.
> So, let's also dump the memory protected by the memcg in such reports to
> ease the debugging.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Vlastimil Babka <vbabka@suse.cz>


