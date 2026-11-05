Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39A5C606A32E
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 10:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AWA5EUum
Received: by kanga.kvack.org (Postfix)
	id 4D19F6B05BE; Thu,  5 Nov 2026 05:25:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 480ED6B05BF; Thu,  5 Nov 2026 05:25:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 388AD6B05C0; Thu,  5 Nov 2026 05:25:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 092706B05BE
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:25:38 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A5056A8758
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:25:37 +0000 (UTC)
X-FDA: 85400683914.07.1CE8353
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id EE27F40005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:25:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AWA5EUum;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793874335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CTZjVvkIUqA1hYxbAMBN5D0S+bQTUaargjdOqGhgIgw=;
	b=o7v7Jc+SuPsb6T2S/Zjf/nU0GuT7/aSkbRbzvWGykQOqhbRXsbD5dbcL9Br4TZImku6geQ
	hR69iPYleiebLQeXWLczt/BaW3kPEqTEZ+cqHTRi5GmVKogsytBHvMq5VPY2AgHZwo5iAn
	C7/EF8ePuvBesm9nNhc2mC32WO4saHE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793874335;
	b=GoHAzOkyUTDBQvAWvGTXFTW/SgA01y/oahu4dQL8UdKWFX/cKTOxM9bUa7Yfpi3PSjMm1c
	5Nsfd0ZLnAe0jVsN5QY2j3hRvFrJWHu1E9DIlsgmP494TYt21UIsHe7N/49aoZuoBw/Qit
	HN1xUL1WdhKM9w6hOSwWJbBYLaZ/YK0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AWA5EUum;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C3A260267;
	Thu,  5 Nov 2026 10:25:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3DA1F000C1;
	Thu,  5 Nov 2026 10:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793874335;
	bh=CTZjVvkIUqA1hYxbAMBN5D0S+bQTUaargjdOqGhgIgw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AWA5EUumNdwSBWn4g6tCydb8yT3P9NIpU1AhnI/l68ypPPQQjsmlpmZcmjqP0LN7w
	 N27be4rfuMZiWwBCq7her7lB+sc11HSH4D/It973/gw2n+J+yJdXPUKAwXRjqOXG6y
	 +3pvrnmk/IkTbMiVT+f7swrdRCPqMW2Hvq2OBNpXeaZjFaLDXFyS2ZLfADRs+mUY4L
	 zAGr34i+l3CSk3NcxiMWRysp3rMsXyT3OAyIDd0GQElcCJpX8c7qsNkVzOhFqRdS82
	 7Ro2+vUiGHSoWSeJ0BfSs4RidofOfhFtdjMtqubRz5QJeJjYyTeuR/NxOeDYB3wbBP
	 DHBSE9YQBSBJQ==
Message-ID: <9c367177-1822-4b6d-8bee-d283eef7b895@kernel.org>
Date: Thu, 5 Nov 2026 11:25:25 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] locking/rwsem: add down_read[_killable]_nosteal()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>,
 Waiman Long <longman@redhat.com>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Yonghong Song <yonghong.song@linux.dev>, Alexei Starovoitov
 <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
 Jiri Olsa <jolsa@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>,
 Ihor Solodrai <ihor.solodrai@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20261103-khugepaged-latency-fix-v1-0-a07ab16ac860@kernel.org>
 <20261103-khugepaged-latency-fix-v1-3-a07ab16ac860@kernel.org>
 <20261103115159.GK1813469@noisy.programming.kicks-ass.net>
 <aunLcWto870swo38@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aunLcWto870swo38@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 58cdrxfesuapfnfafgxxhu6owdowpwrq
X-Rspamd-Queue-Id: EE27F40005
X-Rspam-User: 
X-HE-Tag: 1793874335-417548
X-HE-Meta: U2FsdGVkX19HbGpv2p6zqWsIa3NiDZlVfBLQcaLuRTXvhGg5OAibv9XxcQLdPWaUWg+obKmctXndfTKS7NMnXHZIndRg9qFsH0ukWWthef9QrwWUl8XMGMsMoF/WixSUakEcE3/yq3/M0DiedmmIXOuF3FVZ4h0eId+Bm/L8CCFHK+HPs8f8HyjkbACdX8c7LZIMF1YY7atD7b/rIcLcqJ6TGFfzvzilwIP7VF3dnl+/3kFMEZGLpi8DGt7Xkb4+WvsM35+ps24DfScaUQJvcUIz2aD0lztZhO7EWyltr6ZcpqIGtILaIckyj2eK7caEW3PiDyvT8TVj/xC0bP8Da7Kgdh6a4UkBeVxsHM+ssNAOjkFr5+U0+lOP+Y8oJwHPGJ+qzcmV3nLuAyZj0uxedF0vQlAe28xh6slvKgAhNK+erinLZgi4M4Zq5nELteV4JUnBvk9qRK/OvGc2KreoEiB8L6q6bP4PAmQ6CJwNUQ8ymFSsojOxBIdj+cF5Fo+6BMTrP6+9zmt8nm0xVdU+1lu8Ssnt8HQsMBfWRSVH31pldKePUrx5Bn9Dg6QzzQi37kyBMNm2SLQ79riTw83Wktgv2WBWvz5ZptQ+mMj7H5C88rzx+oucfAma+1kRwZKDa3EU2GCTFQ0JRoIYK/u1S55rtYvO89AWFrRefNYIT/272GEAh3B4r+SISg9cMhZdowDnQi8ZBhVGgLcV7cGHBBot7roZHmB3W+/dk5N77nEixFo6MqqP8xDGIkZue9mGitj4GEpyrc/qQit81grFoaEJSfNaNWEEtWvadJiIGvbwYSIuWaHin/XnqQdviIy1bh7aBd3bVqYSr3N0DguplebBtn46Ov217zMFIug5MgK7mAvxwTesiJv2RaW4LMYIk3rcBl6d1kI+ZArdEX2kxekQGHdqKoO5kibMz9aClNuckEucen03B7EfB2vJ2jEuE8I8pp0NtqRRr98jPIx
 JrxEWD10
 Quca2Qqrzyiv2tzWzwNFrjDQ/+okBjm6t8xtIzDorLigiFqLRN9covHqOGuDmN5Ljxcu6GYiL8tw5tebmFMELTeSIo18yGWB1bdzvKUjtVTsj68PLCXKif9kC+pxAosoiuejv5Zzk2UBHTBbGjQWafmd1Bze9/tUluZz5jRQzrgWndQylCo4CYCOALSeWT69Yv55RCZ/6ncACc/4swZn0o31B0AKJ8PsEimI768jkDsRDIDp2pYXpFOEVFAPpj9EELgTHKgyIwhdGJqbVb8ZyLZYuecn+U9GOB+I0GzPoanRhJI5KjnvwIC+R8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/3/26 13:24, Lorenzo Stoakes (ARM) wrote:
> On Tue, Nov 03, 2026 at 12:51:59PM +0100, Peter Zijlstra wrote:
>> On Tue, Nov 03, 2026 at 08:27:44AM +0000, Lorenzo Stoakes (ARM) wrote:
>>> Since commit 1a728dff855a ("locking/rwsem: Enable reader optimistic lock
>>> stealing") a sleeping, queued writer whose handoff timeout hasn't expired
>>> can have its lock stolen by a read lock issued before a woken queued writer
>>> was able to acquire a lock.
>>>
>>> To avoid write lock starvation, this is only permitted if no other read
>>> locks are held.
>>>
>>> However, this behaviour defeats the purpose of a reader periodically
>>> dropping the lock to allow writers in, as doing so only works if the write
>>> lock is acquired first, another read lock is held, or a queued writer's
>>> handoff timeout has expired.
>>>
>>> Provide a means of indicating this intent via down_read_nosteal() and
>>> down_read_killable_nosteal().
>>>
>>> Implement it by exposing a steal parameter to rwsem_down_read_slowpath(),
>>> update the starvation logic to modify this parameter and modify the steal
>>> branch to check it first.
>>>
>>> Also drop the duplicated RWSEM_WRITER_LOCKED check and remove the
>>> goto as the steal condition makes this redundant.
>>>
>>> Exposing this function is safe as it only makes the lock more pessimistic,
>>> so does not impact lock contention.
>>
>> Not generally a fan of this -- can't we tweak the steal thing to never
>> steal if there are pending writers?
> 
> Oh, well, I had assumed I couldn't fiddle with that behaviour across
> rwsem's in general, so if I can yeah that's preferable!
> 
> I could send that change separately then and drop it out of this series.

Just so I understand correctly, this patch here would be gone entirely?

But #4 depends on it, so now I'm confused :)

-- 
Cheers,

David

