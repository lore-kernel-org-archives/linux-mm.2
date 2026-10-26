Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 321C3606A320
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 17:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ABc53r48
Received: by kanga.kvack.org (Postfix)
	id 493916B05B2; Mon, 26 Oct 2026 13:19:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4441A6B05B3; Mon, 26 Oct 2026 13:19:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 333046B05B5; Mon, 26 Oct 2026 13:19:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0029F6B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:19:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6F4311C2304
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:19:28 +0000 (UTC)
X-FDA: 85365438816.15.F446DD2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id A2A4E14000D
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:19:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ABc53r48;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793035166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y7D/pdzVN/EOHLF1gwbwRGUqI6dGzbr7tUliJl/6fgo=;
	b=jGBK5F8E/9MQqC54/K/vF3Uxpv9tibuWZpUTQ2JZVmOSUpeYYqvfxpNKQ5c/w2XN/p3SRT
	hFUuseLCC9HWvJnwWFWpnyVHxiFNI42f8yibkZSWObtChRgiq7gcPeb/331BuLzpLuapqd
	0Gb/4o7r03zwu/nSfJjnWYetpZN7pGk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ABc53r48;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793035166;
	b=xI0wZQp2+PLwd0RtxwBIhp5V6RbrjzmuJCKvs5IzBMTfucK90q2CjEcGPd8YSYxqf9w13+
	r0qAppsRVOUl5sCX8dbBvj+eXo8+NTx51eJ9XnBsdn9F+6y1aA4XMaVoiYqM0yBZZeTVjZ
	CmQfI7BKYArD4Mmnof1IBBM5+qFi9Y4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E4CB6601F9;
	Mon, 26 Oct 2026 17:19:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1700C1F01825;
	Mon, 26 Oct 2026 17:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793035165;
	bh=y7D/pdzVN/EOHLF1gwbwRGUqI6dGzbr7tUliJl/6fgo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ABc53r489ndRB3kIsExwwubwn6BqoifdFxeF1V+6mq9C7La+CDHEtMJsqgEEPoSND
	 8vUaIBWAZh58EgGBXLGaH0CqTeEtQVtVnOZ3msKhpQnjFswQWULV8YPtS3I+otpqxK
	 /5aUBOFZfYFSniG7HO3v+Bjovn3HoHc/s2iL9OPHtHBHugWWuzTK5KLorEyBm87JXr
	 zbNyqybGDw0b8DwJbika7xM4e1ZSJrqdk4ef4rOIQKOfEwCPPl8xGCFN4q7LqiEHbY
	 7qR8Qv4YWaiChOlyAmpq9ADrjRahNKDRT2aPT0/BjCzB7SLIv1a1ApZFkTFrh7VmTO
	 PE5ISzb4Lg8jA==
Message-ID: <8c5a8fb7-233e-4433-af45-b67cb2528b60@kernel.org>
Date: Mon, 26 Oct 2026 18:19:18 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/proc/task_mmu: fix missed VMAs when reading
 /proc/PID/maps and friends
To: Suren Baghdasaryan <surenb@google.com>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
References: <20261025-per_vma_maps-v1-1-c4eec45b9387@kernel.org>
 <at8-42OwXk2z6-HB@gremlin>
 <CAJuCfpFaxo06yHdVKsEEmFf9qoOYS0DbMvUuAZEhNfDe7dcwJA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJuCfpFaxo06yHdVKsEEmFf9qoOYS0DbMvUuAZEhNfDe7dcwJA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A2A4E14000D
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: top8x8dqzag531gmog73m844pktwrtsh
X-HE-Tag: 1793035166-66835
X-HE-Meta: U2FsdGVkX1+KLFtw9D/q0cIjvoN+oHSTjOGl8Jl+sy1EsnEYpdM0N4MgC4SN9tutto9UVpsE7J0IONbuWRpT55A0HmKpAWA0tkbKrjol6Qg9bQkQriFpqbLdmWwc0nPFwQp+6/YdAkLwq1eh4v13Hyde9+bgMYC3hJSBD5cQK5fic2amiov/H+X357T/W7TzCSiy1gmxe1Rmhto0JBEc4ZHk/5FDMFIJBW0uEbTXJgHwRvVH5ko3DdOwanFynluYKTXLdWZJXLePYtUg3cgdSiOwo6haMVL/rwFChuCDeHwpMYVZKiy0Ml1idciLocE07uy5QChsgYiWDyNlv9iEJC2YTE4RnqcUAgUd1JqPsu6NOAQCLoTOk4q90sdtTWd0wIKwUpiB/kgyNj9kD7Nf6NpjvJXsZHtXUmhe+H/Lu4fLpY17mrAyOHt/66B6s1eOqqfYEaFLZlDXSmofA5PAX7Nv0HBwTCELsCPq+xQHeZIBl8/8podt9C1jUUtH7u0z9lbAthW1KuocqtJHQjs06SvzsNh7GT9xWhlFTBh9UN+ZeWAP165d/2qVUkz6Bjg6mtKHATz7cbxLJoDbP+3+ijqsfd4TmN17DqlmdXZ/zMJt8E2LPRi/K+sByINNvGEDkKy2J0ON77qj0QPTUysdbV6VKxSOYQ9HGD5qJBXmZy4Im1EkuvzUFugJhpKjPQVsp+A6KiHDKyat1g6PkRkx/MrREXYoGz2IyIBtLObK5i0owZPrdxYUQlqbK1aAZETu5q4CYyX3wfuKCWpznk2meiyu2ZAJPD/iy5u3EN/jWhhoxHlY5Ap7gH6KKLvvSUGijocEeZBguj75kiVBN/rUB5Igy1Hi3c4e+XzDRMNS2YuixsWC+R/hLyGwTIN8hvQnyAU5cE9Us18BiY7RSTiFyQN4M8WyJjmGrua6laWHJGU7DMlRKtNt1MokanFXM35fBpXl6nKmleS3MIUQ1oL
 irv5KJL0
 cAgVQNT2tNj45DJuizNu9UBuTMLc6wNU1rYzWCremqyW/T9qwAKH3k8JomSyJtL7RfLWkM79eqp4Vf3c7mHBBZN3194pXknNYD3f8V1OZBG015qpJVBiXt8Ca2xe6uDA8cpZGl0a9u1vb727DdaoCZTQFfySlHVPnaVQaHJi5piTw5C9/ePPn1naGV7ApjlhzgrqNkFqdxjk/wcn7cHFbWOnYfGhQoauyrNomc1kkKb4EFjchI3ryX3if47oHIrz3WaRxe3O3Abs8wYxlS2Cw4RwaAk8ouJ+lqPNDne/NoWf5RzONFaFkwch7q6k7Ndzo5J6CZVlzn6rabPo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

>> +       /*
>> +        * No lock was held since the last call, so the iterator's cached range
>> +        * may no longer be valid. Always restart by address.
>> +        *
>> +        * The vma_range_is_empty() checks below avoid unnecessary mmap_lock
>> +        * fallbacks.
>> +        */
>> +       vma_iter_set(vmi, from_addr);
> 
> This is clearly simpler but this unconditional vmi reset is not ideal.

Yes, exactly how I ended up where we am right now.

I pref my current fix as something to backport that avoids performance changes.

If you two disagree, please take it over and drag it over the finishing line in
a timely manner.

I wasted enough of my weekend with this over-enginered piece of software. (had
to change one word before sending, can you guess which :P )

-- 
Cheers,

David

