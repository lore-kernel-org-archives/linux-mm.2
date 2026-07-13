Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D20C2C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:14:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E7CD6B00AA; Mon, 13 Jul 2026 12:14:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 297626B00AF; Mon, 13 Jul 2026 12:14:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 160716B00B0; Mon, 13 Jul 2026 12:14:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E20B46B00AA
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:14:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C8EE31401D4
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:35:02 +0000 (UTC)
X-FDA: 84984151644.03.AC2423B
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf08.hostedemail.com (Postfix) with ESMTP id B6588160005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:35:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Wx3B/cbR";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783956901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b84zbAj0IOT/rrLgo+xScwsyz3Svgs2ZwEIPB28c6z4=;
	b=U+J7MUTpYPE8uUkaClmwpHBqf64dBdajr/b9E9LhouJZ0SZBofNIDPW0WE3MHLeCqASuDH
	BHRbsEO9C3xTRhKcjKubKLPAUznIaLJMwiEuDZAb6BHX/MpoGHL2bSq0SYHHME0HprRRLS
	yirxw5iZE8xbLtU09/tUbjUy/FC5I1I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Wx3B/cbR";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783956901;
	b=KywpISLU45w4uR9ca/vf/uXdYK9MpmB9eeYNwiCGs666JCRi4iAIo3uro3dxIms2Vuk0gI
	SwosUaRDlGun0akeIXedL4FPcePoxs9D/hBH1usrMFA+gmIee/ntdbBLEwREZ4OSoNV7a7
	/+kamH7qJioKk8fcCEj2SeKHrxANkdU=
Message-ID: <a0c0a578-9334-4540-b469-4c368d07953e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783956898;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b84zbAj0IOT/rrLgo+xScwsyz3Svgs2ZwEIPB28c6z4=;
	b=Wx3B/cbRzN05smJAh6GSYPpBR4jesd05hADHLSXO/xF0g529OR0897flkhNFWq4Y2Vd3av
	gjh3BfX3OYXR3quWsagN0aQy3VM21xnbUubOHy/lCfIwLxLDA1S5Yl6ng0j9DToARLgiF3
	Voq/CzzM0ypaW293o8LK/soo29WJzOM=
Date: Mon, 13 Jul 2026 16:34:52 +0100
MIME-Version: 1.0
Subject: Re: [PATCH] fs/super: skip non-memcg-aware nr_cached_objects in memcg
 slab shrink
To: Qi Zheng <qi.zheng@linux.dev>, brauner@kernel.org, jack@suse.cz,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org
Cc: hughd@google.com, boris@bur.io, clm@fb.com, dsterba@suse.com,
 linux-btrfs@vger.kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
 shakeel.butt@linux.dev, hannes@cmpxchg.org, riel@surriel.com,
 kernel-team@meta.com
References: <20260609123047.1948242-1-usama.arif@linux.dev>
 <4752c658-7b61-4636-ab5b-bd172e11a42c@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <4752c658-7b61-4636-ab5b-bd172e11a42c@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: B6588160005
X-Stat-Signature: pubff9bsgz38qxxuqbxajb7ohe1nkemj
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783956900-240173
X-HE-Meta: U2FsdGVkX19oKmq+4qMLTZCg0o41nxEk8Qw1eYd7tFTyeyZGnA8adCdYHwccFAFojIC6fW/UBM3kIXKenZXzFL/Wuaj5Sq6ru5NR/Ige/1LEVBwMhqMuzasztuZkEge7E3yQd7Ci4oVq22ze2a8c8VtbjfeFNJpzeqG7hvY+9VEry8fsLhKUTcGAQCxhagUOsUpWpBZC9TqB9nDyaMoag846U5F/2GricYvrLm75fYbWNs03B5Zyf4vxm5X6r4yvaEOVL2kRBM0rW0u1YQnGXvJGvnZY+iUOKt0UDBlgsBanbtCfWvp5jCNuEAhMGlahdSwdfvkKWgdyR68tNc0he036MlPTIVG6idVp+aUfezSsIDXLv8/N9jm06ZoonOlUIE2Bfx7ng39QxXsrpdWvz2Y5KJu60SMxJ00H1e3iHMEhR83zvOyd6VMUzYiC8JvbDIP2lJSC5/QP3WI9o2C3rEBO2Fpxe/PBA6Y1KD8XpcmHr1QrRb4dqb6hvnB0sjOsitrcQ/RJ6WUnk0/TX8P1jXdPz8b6hcZLv0hmUm1CuAQGUdcLf8mKDVq0mKJtYrRzl1rjxYSpEsY2YYx53M9jPRQf6wqZFlx9Nqqw41+9GR9jUSuZB2i5B8IqQRT/YOFsEshX9D7zoGNMsuxJ/esv59ja2Z3kc03eFcsuTADbFEKa2IL+ZqbzwG16sU6eNdA//hBAQHHivNvbRiLN5TIyWuh1Uz91Rb3lt4xvxQ2Q+ZC8LqYAtsBMTSF+7QiEdo2IgPUPMZ+w3eeprQga89NIF7EX61Kj8fJoNJttFzgVzjmdRk9oWhp8IQ3nc4s4bm4ZA5GhlHFLkqA2UKai8ZlOkCAlnc459ocjm+Hw5Qmb0aWxVNETrKl28HOcz8CzlHQ5uhfljG4dgEyYP71mFjNOxT0B5bGDLLCZkcOFFTY3I5hlRU5H7YKXVk69XCSuIkVUVA2z5+g4Gi11QJhq6fo
 DkjH3l68
 QqeDDGBNGTkdVZ16kJHFMPCzn2lPK7cE3Z7xx0v3NOeHo5s0uJyUuzjgcpw/IHMy76LAdhpiBfY3wyPpGHM/kWaAgDS3qn+YPWlmBiHbmkMcwfDXnxz57gQUUrbYUg9j2sUGdt44fhJxPbILapvXqOBS5Jt5VbgqypsXRyOKnuJ6ohw/76iNAgL3Ma+EHB4D+6NiXGhvIsTsaNAqRQlvQ9uPWAyHk+3PI267off1LK8hvO2qpWCU6mFp5N/Ta+BdkSl5hgzzcIm72/Gv4D2BpGnU6vQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 13/07/2026 14:12, Qi Zheng wrote:
> Hi Usama,
> 
> On 6/9/26 8:30 PM, Usama Arif wrote:
>> The super_block shrinker is registered with SHRINKER_MEMCG_AWARE because its
>> dentry and inode LRUs are memcg-aware (via list_lru). But the optional
>> ->nr_cached_objects() hooks that the shrinker also drives are not memcg-aware:
>> btrfs extent maps and xfs inode reclaim operate on filesystem-global
>> state, and shmem's unused-huge shrinker walks a per-superblock shrinklist.
>> None of them filter by sc->memcg.
> 
> This makes sense for now, but how should we handle this if these
> shrinkers are made memcg-aware in the future?
> 
> I've recently been working on making the shmem huge shrinker
> memcg-aware, but noticed my changes broke after rebasing onto the latest
> tree, which led me to this patch.
> 
> As for the shmem huge shrinker, I can work around this limitation by
> making it a separate shrinker. But this feels more like an overall
> design decision, effectively meaning that all nr_cached_objects are
> precluded from being memcg-aware.
> 
> Thanks,
> Qi
> 


Hi Qi,

Thanks for raising this. I think the alternative is what I mentioned in
https://lore.kernel.org/all/cfdb8620-ea55-4226-98bf-d006820e6270@linux.dev/
move this down to the fs own callbacks instead of here. Would that
be better?

Thanks,
Usama

