Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42D4CEA4E24
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 15:36:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 633EB6B0005; Mon,  2 Mar 2026 10:36:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F4956B0088; Mon,  2 Mar 2026 10:36:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 521736B0089; Mon,  2 Mar 2026 10:36:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3FEFF6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:36:55 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9A2C6C0F47
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:36:54 +0000 (UTC)
X-FDA: 84501525948.21.75DA773
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id E210F4000F
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:36:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f4+nonEc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772465812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=brA/xNCtwUonI/UbpO/euCl/doZgRm4Y/NBiOsnmJlQ=;
	b=IePaL0WbYRup/tCHM0baQmugM9aiHGKJeQmnOV4z03i9NaVCPwbvp8zZHlHrkQa2wzQvBJ
	ByGbAXyxP5dudSdxDn3NGcD+j77LSBpaMgjyadT025djqKHoHHX3kNBcnOCzfCf6AGf6o+
	LoNB5u/iOfH7sBHBFHPvw9anAKkXTP8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772465812; a=rsa-sha256;
	cv=none;
	b=IhU+38lduyLB0Yz0KeY6F1jqfav96sERSKsomgHEdGvw825+gfa6BqpSE76xwKVSYqEOgZ
	fmzq7ZuUxuYNcrbB0T24xmDyIaxJ1jmtytqgIWHTStLB5sPJmfLQwirf7tCbY07To5xj6T
	/rlunYhgL7fUFkwRtNt+bPLJvEhklyY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f4+nonEc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4E1D0600AD;
	Mon,  2 Mar 2026 15:36:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1565CC19423;
	Mon,  2 Mar 2026 15:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772465812;
	bh=9oBA/2HWEPQ4Pcn2lNxOtCWpLciqSBzhtAatzajFUvU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=f4+nonEcvflPxCbCVfZuhIasP43yQlqIp79hgdYqHMdvYouDwGbtcF06EUjEM5S01
	 V0rGv7TaM3M4wlnkdoVtmRVNh/6WB3ekv5qFtRs+EOIb6cw8QwXSwQ40eLN/aIZ1yW
	 K7KKesFUpRGc3KiAa2GLm2HxmtzYmtGAeL9PEgPfJHb1RtWm2YAJ7v8RT1wHQEQCqc
	 Eq0WRsSdi6yWeUUnjurAL6MtTjFDgdq5CPQlahvE5V7VjR0JKDPmYhciZQg86Onaoh
	 PwThto3B0pBJnOqTMVQzwUsp9M1lz3zSgYvIGnx0DKiFj8RsMZTTjxgWUZ/Qqtthru
	 BnPf0xgC1dMmg==
Message-ID: <6206d021-e6c2-4899-b426-cacd71ebd5ef@kernel.org>
Date: Mon, 2 Mar 2026 16:36:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 00/19] mm: Add __GFP_UNMAPPED
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Wei Xu <weixugc@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>,
 derkling@google.com, reijiw@google.com, Will Deacon <will@kernel.org>,
 rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>
References: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E210F4000F
X-Stat-Signature: n8qfbc79m4cuiyea5tf3tujoqappdn16
X-Rspam-User: 
X-HE-Tag: 1772465812-443488
X-HE-Meta: U2FsdGVkX19TZ68Xi7kpHDv/GLR5lDBhi9jIZWne00Tz2pCycXjogNX68ALYZqI4738wdEcOZSki31wpuRZe4WuFVE8SSG3i0Cx6qZS7pr73We07YtkYc5JqAMbQNxzfBR5aDCOPgY11xJCGMWApBi6s5LLlOqnOOPAA21BY9SjgDkR6k+JPxnrBUChmwLoV2c3bf4hMpg6SFo24xg1WsQgn2hH/4adOA0P0IEVandR2yweuaPiElnEENWOxQluu0p9kSbc9wBEw5jD2oK2J9yjjN6f19ROMC450gk3/utpK4jDWkSmbWoqgt2W2GJuiStudnEWCfKnM8P9MksK+9zqhfFnZQQ3PD7CkJazh+G9dPRUhP3uGXWzGoTCP4LzlnGIqcwVSBgekpt4q/fTsQe7ndr7x88wyD1mGggp+PldWQSjbxYaCHCmVBI6k8YIx8WcqiWW5ZLdSqy/svGctzWTfQ9Q354wiDqTxLwGD1ibv8l5o+A3KGzI0aU+HHclplIw72YClSxR3f2s/dnoaVLz1WuT+tljiiMTSMumaIYOfeJk++uObc7HaRcA1lKtVJGVJY2o81HQWv/bqoqZqaa2097aANxSbZoWGmHTXNa1LLEuEierC7pX3+8GkiaetPwtbtunT3DggFzj0xaudMKaNqC2pS6vOMsuaaCIMIvgGqzkMa5aR+QEvZEbiOFB+n7jo99cQkA4MBriyklNGheZbesAvHS1OKMbLOwcC/XKaqcteosXB1jPcaPAnEb2w030PTKMys21Mt7DoFtfUldIdMK78uFpw2H+RcOh+DjvUBmjxNkrZEm14dUc5nQcrDdti8IJcOIJ3JUjay53bMzDy72tPykB1M3mhLr36b8VeEslJ5yesm9xBr5ZevgqO+ok18C6IqSfCpULkNAKNQS3N48TfXxrIjB3IzkWchTlbQuE3q1bsNwWhCmx/UCnWFjZeC23Lm5GGKnGSk/8
 iFUwk+Ga
 auKVqB6YDJp9FWHwWpewVgMRe5dL/eoeyxOGBTLjTRbCs0uZFYJ8u/TL+ahu5hdSAxT9iu0woW/BMtc74xB5v+COkAiFrz8VRCV0EkjmN27uF9g+fhj0VhBy+cMDCWOSpHnw9S+piWp/hOJELDSXXkQTcMLgAt0dDX+NnZCg1d1ubCMzTyRSLSRqyS4NTadk+Zfro0xP2Ju9hZS1soXe9pFl1Hlyaat0DP3a9KZPUxZJJ5JpqrIu3vCWtRUkJ5nuyYy7wHTW2RXddn0r1Dz18G72cebeG9r2oAk1qrG6V2XmbyJ/m/HjJiTm6mA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/25/26 17:34, Brendan Jackman wrote:
> .:: What? Why?
> .:: Why [RFC]?
> 
> I really wanted to stop sending RFC and start sending PATCHes but
> getting this series out has taken months longer than I expected, so it's
> time to get something on the list. The known issues here are:
> 
> 1. __GFP_UNMAPPED isn't useful yet until guest_memfd unmapping support
>    [0] gets merged.
> 
> 2. Apparently while implementing the mm-local region, I totally forgot
>    that KPTI existed on 32-bit systems. I expect the 0-day bot to fire a
>    failure on that patch.

I don't think you mentioned (at least in the cover letter) the mm resistance
to add new gfp flags due to number of them being uncomfortably close to 32
already. But I see you've put the new one behind a config. Together with
point 2 I wonder if this is where we can start making some flags and
associated functionality 64-bit only and change gfp_t to unsigned long?


