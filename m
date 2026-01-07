Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C691CF6C1C
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 09:26:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C51C76B00A5; Wed,  7 Jan 2026 04:26:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFFB56B00A8; Wed,  7 Jan 2026 04:26:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2C386B00A7; Wed,  7 Jan 2026 04:26:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A13796B00A8
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 04:26:08 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 62557140223
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 09:26:08 +0000 (UTC)
X-FDA: 84304636416.06.4C2FE7B
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	by imf27.hostedemail.com (Postfix) with ESMTP id 48F844000F
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 09:26:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=WotMMt1L;
	spf=pass (imf27.hostedemail.com: domain of michel.daenzer@mailbox.org designates 80.241.56.161 as permitted sender) smtp.mailfrom=michel.daenzer@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767777966; a=rsa-sha256;
	cv=none;
	b=mh1gNYlF2dESL0LPJxkK/taFP9GjzaBmYecxBEAmomqywLEjRSirCi7EjE8Lpx5TGWzmGb
	8d7UfaizWPpGAw3r2kJAG1KNVR6E3grx1gMUV0cbStTMYS43pTw51oDIBXEOw71yaG3E5h
	es9/WBNpwnKrZEGpPvvG3pp+wZxYX3Y=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=WotMMt1L;
	spf=pass (imf27.hostedemail.com: domain of michel.daenzer@mailbox.org designates 80.241.56.161 as permitted sender) smtp.mailfrom=michel.daenzer@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767777966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IkcN9yr36Tdc4k0VIXN57D0NnZ4/zhZ0850Zx69uq/8=;
	b=jrKEacXp9f5Wg9bkFCrXnijaJraikW2zYZTnoHJydSWFOiL2QmPmxRLAODC5DRcKfaJyrT
	9X6izKx7GLTt+88LKORdXETikn4Omr6RGzum8lu+/Sc+vLZxpxzW31Z9zVqVmw30WiVl1a
	oXZYve7iL1YKsrbgrGxNqPXOUnvZhGA=
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4dmN213yhvz9tHd;
	Wed,  7 Jan 2026 10:26:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1767777961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IkcN9yr36Tdc4k0VIXN57D0NnZ4/zhZ0850Zx69uq/8=;
	b=WotMMt1LP1uSfCU/khv2JRIrAoUkuUdjdPeW2GGuNesm+b7aaWZhn5hOkD5VZ1rXA6tut+
	3yKD1I5RIcwQpMZZUQL9ulBdsFbeQXzOu3FxMJyzyS7OPwuathrvARi/mNtMhHmD56w18v
	uUXRArlKaIuh/MCpsY4mWWifxNzZiokzAF+rnLHa2sdpWwLP/Ux0KnKymfS7O6DQY145j5
	/1HfEa/khRY5IDK04mSFrwMMV6lZyCXlhyp9LekuUcuTfUhJozD7C/bX6AhSN/FD6otd3F
	AprRji4xCeaErHhFoQ47ws63y3inpEOligIneaEO4b9G/HMM6UCammw+cedCBA==
Message-ID: <fa6a1cbf-2853-4add-94c6-d5c2e0a3a2b7@mailbox.org>
Date: Wed, 7 Jan 2026 10:25:57 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v3 2/3] mm: only interrupt taking all mm locks on fatal
 signal
To: Mikulas Patocka <mpatocka@redhat.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org,
 linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
References: <b672e17b-461d-16ae-e7d3-45d3c1aab142@redhat.com>
 <7whbqlfrwjr4z2d4bpny3rjyl5tetdyx7ccf52uvby7hgywoym@6l6m2xcytez7>
 <e60858c9-12a6-2b04-35ae-9d676f14db2a@redhat.com>
 <j3dy3g5mchtdzxldtnqu5nwaalbr6ec4ceim3nuu6nwcddmqjc@7dgzr4m7pli2>
 <6633f8ed-f432-f4c4-3fe2-8c14248cadab@redhat.com>
Content-Language: en-CA
From: =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel.daenzer@mailbox.org>
In-Reply-To: <6633f8ed-f432-f4c4-3fe2-8c14248cadab@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: 53gdztw874atruuukg3n3nw118ikg3tf
X-MBO-RS-ID: a72ef34075f8cc7d704
X-Rspam-User: 
X-Rspamd-Queue-Id: 48F844000F
X-Rspamd-Server: rspam04
X-Stat-Signature: jjm94p1nzrambukqei486exqpricnnqa
X-HE-Tag: 1767777966-583171
X-HE-Meta: U2FsdGVkX1+PcvDvTkZCyLweGtWlfADiZA1tTDmcqVgpv4M4XqbTJtzEmhSH0L3Jw2UHjGmcm6RrMfg7LRr4E9DJf3yhC3w1Yvyv9AwEk3Q81OG+TYZpqipyOl7jEL3S6z+lxmd75V4t2JrpewmtAtsNmgmYunjK++YSioDJ4f/uwP+T76/SQRcw+CwK7oodvbGkcyRLPxEugzkGTym462XHUM96tNRamJzh5lD8wJ4Vh2Zac9B1PLeJ/u6wclmsmo45/EP+2Bowbg89Szv1JKUti1KvtHUwjU2E1zLX8cZdqRp/i7iMl05ujXuRakjTyK1o7KByeRkbKIRwcgNhzuQCO8TEIUyp8n0rf9Tir5rwuppHRyDmcyXJCCLLhrZmK5ifon25tVN2Ew29Z6JSuEGbOTRIaIkxp0eV9zUGF4x+soZWFrxj2trxEA4kmRRVYTlv76RwK8LE51R2hakdm2GXYFhGgGzmO4WDIvyWQgHN47zGllyll1uj3wqJBxEPw4ZGey6Xt2rn/M4vrAWl8IbtnwbiUX2dgIOVPaFGbNZ5Wuyxl1IFs5O7ejXMf2d0sYruVEZKTGjGs9773rdX9WAHvZ0tYqo9JAQZgKVe/Zc3mUOv0hgtHKxicFqOONrnFZM/CR2uAQmb+koqZ13eDP3iz3WcqOFhzVs+LMAApU4FsgRwvyA43IpZ7XnIcH4LhxYly7frV3jA7Zq6D+mCPPAVYLFO9eGfGsv530KYX9COpLimfVNBiexc68q1pby0y84wk50wdY4T/V3kIUgCeWIp/9wxlHYPXX6Xr9AN6OY2TtO3hHOKtI9YS9aZ35YEd5tH42aVDjuOhl11DqA9iy3vQX+LqWq1seq21Cp3WqfUajMWNmVTfbUfpZljm4BsSGXaXSB2LLGNTVeRw/zbjWwy9yDMI4cysjwQfX0tvDRqNjJx3QpGGTQ7sBM7pOvgcMTjlkKYA6J9MFqKznp
 iszVr2Vh
 jHY4kbVlWvJcrg52pEPJLjfeBq2yFr4/W8etc4sQDKWZAlAuzH6rc6Vg4R/wUVYsagIwZEpei7GrPhf/jZHxVQrN8yrVczMVhj1Z8tMaI/udKzy6Yo/qJsPFjwQlWfDfk9swzVJJld5xlRAwUbPGGpru7iqppulhJCilQexXQD+HdUT3xoazqy4M+HYFu4bUmyyc2/lU6wFNUCU4OyZYoNF7fqc9I8RK/ghQDqMK+Jpt0LzpBH1Hy3Wug3QPEnjTnNY1zoIeBTh8u99UaXhSLW+O3Unh6FIpJMNQfJRb+gkYGajlTpzOYaZu5cX1iOrcLZ45JIJaw3b5ynVygpF5QcXrf/Pd4AI4oLp9S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/6/26 21:19, Mikulas Patocka wrote:
> On Tue, 6 Jan 2026, Liam R. Howlett wrote:
> 
>> Any other -EINTR system call will also cause you problems since you
>> continuously send signals to your process, so we'll have to change them
>> all for this to work?
> 
> I use SA_RESTART for the signals. And I retry all the syscalls on EINTR 
> just in case SA_RESTART didn't work. So, I don't experience random 
> failures in my code due to the periodic signal.
> 
> But there is code that I have no control over - such as the OpenCL shared 
> library.

AFAIK all current OpenCL support code for AMD GPUs is open source. I see no reason why it couldn't be fixed.


-- 
Earthling Michel Dänzer       \        GNOME / Xwayland / Mesa developer
https://redhat.com             \               Libre software enthusiast

