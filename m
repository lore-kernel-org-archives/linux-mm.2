Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DBE8606A32F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 10:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aZP1KsOo
Received: by kanga.kvack.org (Postfix)
	id 4A41F6B05B6; Tue, 17 Nov 2026 05:54:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47C416B05B7; Tue, 17 Nov 2026 05:54:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36E396B05B8; Tue, 17 Nov 2026 05:54:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0FF9D6B05B6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:54:40 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7D20F16039C
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:54:39 +0000 (UTC)
X-FDA: 85444302678.17.9CE51EC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id AD8072000A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:54:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aZP1KsOo;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794912877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Tfg1ibNVybgEeeF48UPE9BTEozdfEvCnWQy9W1oTw4=;
	b=ttY03xYpnAgRWtnukKEBMOByTBC8sp+RFatZsyUI57bH5uIdlKr+4LidgTfCXxcmPHNB+E
	CjkiueNPGeGfNS6ChCbOcIq724KRgTwLLplA6A0EhSyqvkqrn/PhaRK22I1utXe0d6FYON
	JB1J8Ve8cNkQNx0u2hvMeIx1YAZ+NlI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794912877;
	b=Gl9gOxZ8fFJoj7m/+xxgOD86HSEez/Am6eCDOpBNpngJ9s/UGZaFzxcvfwxbDFEXmYf+RN
	G/gndHzTaDqn7lQgX4tpYfvw7iRcb90j0fDSaBhqEctaPILwWu/ySVlrRWEO7YlxoJxCW6
	+AcSSNS9l0gT3hp6efsF75jVsosA9KI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aZP1KsOo;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E7EAF40575;
	Tue, 17 Nov 2026 10:54:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C6E1F000C8;
	Tue, 17 Nov 2026 10:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794912876;
	bh=+Tfg1ibNVybgEeeF48UPE9BTEozdfEvCnWQy9W1oTw4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aZP1KsOofZXA08D4wdLGepi9PdvJLppDJzJsU6p+skQN1H20zQrbdw43C8f6G8S8i
	 AibDf1dGAP/t2RPsnkYz9X4moOWgFDXV2/6th8B41ZkkvJklEDopaBUXqD6KY1AaeA
	 OvPQNq3RzuMOVkUgdlRBlbIOTtl6FUTtLyfVlWJzsUtR6dYLO2tBdqdijCchh3+h6g
	 moj0KiL7FFnR+o760bFIRNDHGLRXhhnaFq0FhXidI8tEcDswkKnAtnKlvvXmdSes24
	 tYkGi2wjsWCa5ep+HjhgGKItZB/zBQ9SNKN2BUjF88bHay7fAMWDevuxIR7IugmdL0
	 FqrEZOV5Hpv2g==
Message-ID: <f75945f7-82bc-4ff2-92ac-9ec057347a41@kernel.org>
Date: Tue, 17 Nov 2026 11:54:28 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fork: mark memcpy() in dup_mm() with data_race()
To: Muhammad Haris Awan <m.harisawan@icloud.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar
 <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Kees Cook <kees@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <179489519663.1444496.15875846661591982934@icloud.com>
 <0b565b9c-1462-4fed-8836-9a7d08e4b861@kernel.org>
 <179491109101.4015489.11185824873441987133@icloud.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <179491109101.4015489.11185824873441987133@icloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AD8072000A
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: x6kda4tgxxcnk3og5mhaisqxwo8uqsfr
X-HE-Tag: 1794912877-582012
X-HE-Meta: U2FsdGVkX1+2nmUrBW3yBJchoMquPXyHVDFmWOCGZ/2wyEZt9+/RGZyc3WdrhXnFhH/iUdzwJNo2U+rtm5UntoSMOln0c3Y61iL3w4m2zNTgcwqK3uCbsvFG9qPNwa4zU34gVQTANb7oqIy7aH48EA9MadbTuVrqdQsrq6GUFUMUIikHUObmrip1/K8aGT9A7+/7hSDWZMyaVD25osL8aqPOcdChcdvmRNBMUYYQ/1g0zc1QTayBKdJlCA+BmdPNucMQwqOj3gR2q5b6DASniTNrPSPpjNiMbT4l4t4SR8oqJnYpdf1whULPhIg1Cmvj0+cF5P3l4Qg8dJN+j/I3tNDLUT6uAIuHbdZq0LHM+RfIoK2TAcFdUO/1VXchKy2G1Dompjd2AHBaF0cWwSzmam1feWBhrhd1F3aX5tUn4apkc/P/+36nPxTP2HAY48QeTqLG7HTLiELaw57X43DXtMsnBfp4NxZ7aejqUN0wewWzAClZ3OueemLhiF+sYvGEihtHt9u07lyeDwF7WOV6uZK8tAtZ7amNpApv5bqB1tQj2kWjznZi5Hn+rLD90VRjBde3CVQqTd+oPpAN8c6xlE1qrHk15YoIvLgjCeF27uqYmA3uc/Yu1oKM8gMMSIRiX1Ipg/sFKrOXbEP+FR14luzh2ZsZkUWz++J8HOIjsg1mQvHuSuYU3zjSfL9IW9xBjdY0G/ZLEFcPN1gU8sPxzIbal4fYCoTLGH9AmDQ7FGTyUzIsi1uYvGO4rwF85/zHHBIgfmIT0I2S++RUSSquV7Qk+jZUSlqkE6FSo50lSzkGrwWGGELXfXKyrIlneWYk8m1wrxOisl/IPAbHWNETOkPbBCyquQApBnFSOFr/J6L2UcATa8j9O7s+zjSJ1AxIdLv/8UktFaa+sxSXzmbzuexe+Rn0sEOIfGRFFQBFItgIp9FOrrG+0kDP5IvDwobh1epdIkFpBDJaPL59qQC
 tEhAq0Hl
 dz/E8VGWKoBySosKncDXaDaUW05Y2RIZPsINX71IJ2xRpJu6u0OlWocup2sjjQlPXtcvpYqgsX2GPGUETkWMwQ7nkGsUq9JDM5+BbMafM7fRKw1CX9Egi5iBuKCxcQFMBoEGqVcbgRqBDfps+dHyXEPMutcBst4NnxQ29131ff5n6x0qs659+EiIkozPQ1LCJrxI6xf+2pBG7aotqLBVyNTo9Z4sjMqlaxERDusxKpC2JfViPaqrF+KoNGSwF80SaOFzX82oBNgFA2aIIML18G/tokR89b5v2qsAA7iacQy0e8fiV6KisxsltMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/17/26 11:24, Muhammad Haris Awan wrote:
> Hi David,
> 
> Reclaim isn't touching the new mm being initialized (which isn't added to
> mm_list->fifo until lru_gen_add_mm() at the end of copy_process()).

Oh, that makes sense.

> 
> The KCSAN read is on oldmm inside dup_mm()'s memcpy(mm, oldmm, sizeof(*mm)):
> oldmm is an already-live mm sitting on mm_list->fifo, so when an adjacent
> exiting mm calls lru_gen_del_mm(), list_del_init() updates
> oldmm->lru_gen.list.next/.prev under mm_list->lock.
> > Since oldmm is live, lru_gen_del_mm() has to update those list pointers.
> The alternatives in dup_mm() would be taking mm_list->lock (plus
> mmlist_lock) during fork, or avoiding copying oldmm->lru_gen / oldmm->mmlist
> (awkward because struct mm_struct uses __randomize_layout). Wrapping the
> memcpy() in data_race() avoids locking on fork and matches dup_vma() in
> mm/vma_init.c.

Yeah, the only concern I have is that this is the big hammer for any members,
not just the ones where we expect races.

We hold the mmap lock in write mode, so one would assume that nothing can rally
modify it. Well, besides these list exceptions.

Let's see what others have to say, but I guess this is fine then, although a bit
suboptimal.

-- 
Cheers,

David

