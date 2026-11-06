Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E25DC606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 14:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QZiZxI9G
Received: by kanga.kvack.org (Postfix)
	id 1A3556B05BC; Fri,  6 Nov 2026 09:14:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1549E6B05BD; Fri,  6 Nov 2026 09:14:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 042D66B05BE; Fri,  6 Nov 2026 09:14:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D5A196B05BC
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:14:37 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B2474160DB1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:14:36 +0000 (UTC)
X-FDA: 85404889752.09.F8EF32C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 27FAB1C0009
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:14:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QZiZxI9G;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793974475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RDov0eoVo/jXZsEH8waw4PclHfxr4UeOoI1jJZ0wFVU=;
	b=cESxjWx6y1aZlVyW691iDJ4naJtHz6QwlxPpP4LDKn6igNrUa9VwbQWviBWGsyNCAucE+q
	MeZu5yBUViRC3dhjk4KoKp5VrcivI+8uSvlTYqvaHcsyLjuoc1nGyLkXx5zaDViH7oWK58
	h3EcAmqX0luSqkRzHd9IowAp4Jtwvx0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793974475;
	b=PSEBzlCQwl+7e94dUWrU3foAOgVElnSYkMC25eJ2+GfKonvTL6zKUz+nT9ZOPSAPkI6pwq
	ApM0etAdTwdJWsX0+HJBf+ip6AlXaOjK0Z2y/T3knUSf9x0wQNoNHTeSmPe2pzONpp61rj
	vbnaXindvTJtww8hAggITO0CLUz7WOA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QZiZxI9G;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BAC4860204;
	Fri,  6 Nov 2026 14:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9485A1F0089F;
	Fri,  6 Nov 2026 14:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793974474;
	bh=RDov0eoVo/jXZsEH8waw4PclHfxr4UeOoI1jJZ0wFVU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=QZiZxI9GAjrir92IAFfKGitZXVtY1jvK5zvkVio451cKaNQy+4alLSBiO8n4IXk5a
	 FeU8B/aZpr2kFUdrrLErUTcJxOy0VJSqfsasS4uw81KAuNjyZAdjxKj1wiOj7JAxBR
	 mbCHQFfN6Q4wIrn+IpBW0KIgDBUhwENIZc64nO3QfIl87WE6M+kj1UTV6sgxuXYxMn
	 NBH9mBHcgEDIzbAvb8xyON+HXQ/hi5v/jPOplklBmwp+o7m+ZKVqOoBmQIYtXJQb1s
	 3Or4fuYh0VQ6PHIfJzhif/V26peoD/pmRt4Txg9M2arpzKsXqRwdmfeKOE1qfqnC9v
	 wxbaO2Ww9a69A==
From: Pratyush Yadav <pratyush@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  kexec@lists.infradead.org,
  linux-doc@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-kselftest@vger.kernel.org,  linux-mm@kvack.org,  Alexander Graf
 <graf@amazon.com>,  Andrew Morton <akpm@linux-foundation.org>,  Baolin
 Wang <baolin.wang@linux.alibaba.com>,  Christian Brauner
 <brauner@kernel.org>,  David Hildenbrand <david@kernel.org>,  Hugh Dickins
 <hughd@google.com>,  Jonathan Corbet <corbet@lwn.net>,  "Liam R. Howlett"
 <liam@infradead.org>,  Lorenzo Stoakes <ljs@kernel.org>,  Michal Hocko
 <mhocko@suse.com>,  Mike Rapoport <rppt@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Randy Dunlap <rdunlap@infradead.org>,
  Samiullah Khawaja <skhawaja@google.com>,  Shuah Khan
 <skhan@linuxfoundation.org>,  Suren Baghdasaryan <surenb@google.com>,
  Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v3 06/10] mm/shmem_luo: Don't make early retrieve
 failures permanent
In-Reply-To: <auuxi10mmCQrq-y2@google.com> (David Matlack's message of "Wed, 4
	Nov 2026 22:28:27 +0000")
References: <20261103010216.3447716-1-dmatlack@google.com>
	<20261103010216.3447716-7-dmatlack@google.com>
	<2vxzik2ck5dp.fsf@kernel.org> <auuxi10mmCQrq-y2@google.com>
Date: Fri, 06 Nov 2026 15:14:29 +0100
Message-ID: <2vxzo6c2hwsa.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 27FAB1C0009
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 6goiczu4d5y8wjtjx3chq4ttickdmb7i
X-Rspam-User: 
X-HE-Tag: 1793974475-996822
X-HE-Meta: U2FsdGVkX18zdfBGtAXdj4UAoMLdziIECta9YaxovLY4S/xhk9SwKoBbu2LAGXFh6G7KyA7IiN64N3Pah6RjCED7F2JKj6nyJiniinr4mOXh760wtAiGxsANtJ7hjngS5D2ZauvLylbKp7b/1r4Uoj6I18RWPcCDg6b5c0Q4OD8wOlJJx9OJzZ/ea002Rkq8539uvO5mer04V89pG01arrJ82rlhTQBCa8AKckbmQpZREBcdrvFZC2dYNeYcbpU2X7HQe9Z114pUT7aBfjp+Huj9o/Dm40NRtdhURlbD4rgi3zWccSEIvGOgBnBn6rWiJoS1qsWcm8Sa1SJAZ5YxHupjHywnuBrf5L4YoU2Ue6ekizfrASyWKpNRlmOvHrULRBuvDYyD8ujRKw2z1N30n3g5rSQPBC/A49X3FquYK5ZZrFbhixttpnyWm9gTBEFGC+kucP4FbMgHSut5kFlvLSkuElLZge6KsazwYbxyMezWI1Jx1rnb6FpJB/LtHtbG4Jw7sb/76/6h9NZRbQwMEB4KNbUCeLQ0gS1HrfVSULRoGADLesJZbH4WBSvz6blQb+CVV7438ymxz65DYHNGp/cQ2dkDhioQA4smB09BEQke2Rrxyd7KbSBwCliQfoj7kkYoScB7OQldKsr6O5fLzFcJ2KfwEZNaiq9ssHYOm6vFE/zLuoF57LUd9hMbAr7IuDgT2DVmJZSYfzrB3r83SxV1XY1bpaJNPn7tixHhOG7wcmDjQvHrkFqIYbgPpZ2IU+lrW0YiauzD/2LoKeqjoEFCjL+toqLFRm0Wz96fZSbmeD6ZkFGVYQwrO4+KyhDUHZBXWi00V+GjBgZIGS/7IA4wrqcqQwWmXzBcYhZdHFWCYSfaEht7oDcDPZjpCN+idsyz0uqIzRQ06mekGWfKVcF3oWerhHGmrivpZjbpCmdbZ5ojpZ33WOx+77IYWg03/KNxTJhCkJnjz/l4F0K
 23OVAnWr
 eNbTQbiy+lhmI8GqmYwCo6vVbaKB1N1b5MRs8L6ZiQr0uogvdcjYShbxgF4CNXUWfh+7zfZ9FurenI+pJjOFSJtmYziOtfONLbtUz28Bi5KKgx9AbhX+SO5+cK7Pst0mtJkfha/AR4luIIjDIcwpC1OSpemKNDUkvT5q8vL92VSC39x7U75Hefkl0Xum1YwAJEX7rm6Hdpx7zDrctFSeTdexbFzzHYVm2RHcYdS5W8oy6pcy/WFUgc3x7hskkkdpBSrch
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04 2026, David Matlack wrote:

> On 2026-11-04 04:01 PM, Pratyush Yadav wrote:
>> On Tue, Nov 03 2026, David Matlack wrote:
>> 
>> > Mark failures in shmem_luo_retrieve() before it starts restoring the
>> > folios as retryable, and return the error without freeing the serialized
>> > state. If no retrieve succeeds, finish() frees the preserved folios,
>> > like it does for a file that was never retrieved.
>> >
>> > Nothing has consumed the preserved state before the folios are
>> > restored, so the retrieve can be tried again.
>> >
>> > This also fixes leaking the preserved folios when one of these early
>> > steps fails, e.g. because the file has seals that this kernel doesn't
>> > support. The retrieve freed the serialized state but not the folios, and
>> > finish() then skipped the file because its retrieve had failed. There is
>> > no Fixes tag, since the fix relies on args->retryable, which was only
>> > added earlier in this series.
>> 
>> If the seals don't match, the retrieve is not retryable. It will always
>> fail.
>> 
>> I think the only retriable part is memfd_alloc_file(), although even
>> that is quite unlikely to fail. But I think that also fits pretty well
>> with the most important type of error you want to retry on, which is bad
>> arguments. In later patches, you check the argument on
>> shmem_luo_create_tmpfs_file() or shmem_luo_create_memfd(), so perhaps
>> set retriable in those functions?
>
> When retryable is set, LUO leaves the file unretrieved and finish()
> frees the preserved folios. If the seal failure did not set retryable,
> finish() would skip the file and the folios would leak.

Yes, but in that case you free the folios on the error path of
retrieve().

>
> In v4 I can move the seal checks into shmem_luo_create_memfd() and
> shmem_luo_create_tmpfs_file(), since the valid seals differ between the
> two, and reword the commit message so it doesn't suggest that a bad seal
> can be fixed by retrying.

I think it is important to signal to _userspace_ too that bad seals
aren't retriable either. So I would really suggest doing some sort of
non-retriable errors for bad payloads.

-- 
Regards,
Pratyush Yadav

