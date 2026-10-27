Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36268606A322
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 19:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YLTdJU5x
Received: by kanga.kvack.org (Postfix)
	id 29D536B08B1; Tue, 27 Oct 2026 15:18:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24F276B08B3; Tue, 27 Oct 2026 15:18:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1168E6B08B4; Tue, 27 Oct 2026 15:18:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D04F06B08B1
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:18:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 55EA3160B15
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:18:37 +0000 (UTC)
X-FDA: 85369367874.12.F327F00
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8052840007
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:18:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YLTdJU5x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793128715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RZNM0QAvkjv2toljsz6cT0DUeLHvWGObkljY6MMux0Q=;
	b=I+wV66xa3h9jLLKs77Tr0hp+lSbn40E5wYFrVc4KyRuGjPLVrmk0X0QW+RqjbVDoImmFNY
	M2HBzVSigRxMN1D6V9NhM2WLg4bsGTp16cHGVFbT5D8WvEkSI49XksnHBEa1NgDXSFH7nN
	a4S1qlBHEFWyvoKEwuTNVUlww5Zst2I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YLTdJU5x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793128715;
	b=pDCfZP8NAwdwQ0cMmBJUTrrJsAyXKDNmODOB8OZq65PlpK+/3YO/dPRCG08sjsNVkNfbkK
	wRGAhaGL0K3uKcSnjjRpfZOTID159lgdOS8k7PMBR//eyoz4VQvOe7b3SgOHRmIilCg3k0
	n8XcJNh7b0FLHztnoA25GJb5Xj0e9+0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A989140A09;
	Tue, 27 Oct 2026 19:18:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F571F01828;
	Tue, 27 Oct 2026 19:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793128714;
	bh=RZNM0QAvkjv2toljsz6cT0DUeLHvWGObkljY6MMux0Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YLTdJU5x4o/hyyOxOFwqDIU1Y1ZNR6KV42KTsOrPC3aE7fsc7yxHnDHmlusk1ZAbc
	 7WbghDU5l1NvCkEtJodjasUhWzXCgfr9Vha9UktQimiDcYzzLg0LinN4/zyoZDs/d3
	 xfVJdoPYVZikMrjRBlxg3rIShOQQ8xtdT4qpb5cOTugMevkB5DTpGK+9lx5QKKrr3s
	 RyHvkSeezsGEWBuWOGF0Wz9rAaW4YKD2jM7O1WA/e7eicq1Lz93J6oO28CTPO/D4Pd
	 RVDg5X3Wj+ZwE0ZbdDEia09ullo9NdzzRIZxY/uH0ERFDqHqyUI36UAodcWUnV9aDO
	 Dxn7IlIn18beQ==
Message-ID: <11b91d57-85e6-47d0-87ab-5fa8624e8068@kernel.org>
Date: Tue, 27 Oct 2026 20:18:18 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/46] mm/filemap: don't lose a folio lock wakeup to a
 signal
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>,
 Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-cxl@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
 stable@vger.kernel.org
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-7-6f74bec9a5bb@kernel.org>
 <auDM5mvsb5ilIdsg@pedro-suse.lan>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <auDM5mvsb5ilIdsg@pedro-suse.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8052840007
X-Stat-Signature: 7niz9dsezicybke16ywe3q4ipps9i94e
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793128715-489750
X-HE-Meta: U2FsdGVkX18uLkvkCgTUzIz6Mhmiva1SQ6185k3SYfc36SYNx1Tzg91H6GsaAKaJjDWDj3k9k7HybmygIsAtnEkCCKRcZamvP3B0fs/JuM5eez3kkb+tAGpxRgHlujSV1H24vZ/UfJHX4ySkYgC5boQfM2FmBXKjESQiCqoESZrObPfV3Ve3eAQ7dUXJu5bHYZiMeUOdegiTq7UtS62yhS0rSh391+crSYG3c6zzsqL/v40sbHnMPyiOVZgUy6avtLpnL75Hh2HSboEV3EGuP6rxsAnPRZ38rn/6u2N1eUSmI+5mxaSATQXKdZCGBr8TAvvV/nMZ7mvngN8muRfZvkeBQiOss5xWJSys7k25KtTU/IfjUEDqftgFQO7i6uneMnEI8aDUwztn+YttcBbofAVzGvFcNZg8jJ0TJc/pvydhVonRo2EFQuzVkBIxa4xp5L+3GIL80FrlvAu5d6C13McEBrHVIiWrjQO22NVin58RSjkY6/rSctZdqgzgZv2jx1sjWJG6uGxdGrQP0ZtVR5WiP41wxgO9+uu5iRRmhF2Ex1pApVO/TgR3Zr8pzpoCiwC0KqcGS+T/uYyYFVF9bj/YxIDPuTivT4Am61NGUWGUCpoSt+QCTHKMMHSGjpJ4DgraTDruHIIPa1xnVbMe8Lz8c9+SRHJ8ZWmhjd7mW7RgTMcplFpyDgtpxlL7yIEa+Kr39TRU+FdapSM1SMkNmeHXGUIyzGzaNQ0NgT7UR2mvNKbrkcWxWqcT7HJLI5Jgi9iXkrhGMGXJY+PRUO6LsY68jTXoO6PmW1euviy8UCs/FBu2CsT9pCIBVPt2PfWMw/vwOAl2A5M8op3riYWq6BAYccI0ZqfrWZ6LPPmjFtUuBvkQsHNltKX20bjLSCWGlY1GM9Climm2gQQW9etgh7OFNaFJxebhUCjMPxoci1FwpvmqKLDPH92MAQWQ11WAMPmFJMdK2W53p+23Gpr
 ib3kbhvo
 u30+mjS4AfYr/L0788HRB0iAYQSH+oCkb50rfr1upNzyBTh47V00TVFJgQfHVtzo5LfvaKwOxga6oSaqUudh9kWqGt0Ggdd7hP6QEns7GvVe/NoUUT6rOzEqX1ZatxqZoIWlId/k/xFNsdO3nOWEPfbLkqwVZcMHT3YcYdyC4jsbETYRM5lB4mvMgu9MxERAjFRb91X+dSa6FZeo5kwjEUWILBiFnsrQXAaTdXzDlpYQK3+dgdzIhY/iOLXM4PnqmciHSlVL70KN1COj1YTTBQFq6w8/dmk1rNKPbB0sNKbCkZ671fsU9HzWTEbIIiOXWd/uC1XgTqcgL8B+rsP22RfexDc9fjaFL3JdLsodItXMREcmq4XUhYFgkGHnCUFBdhOkACV2ejx+JUWU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 17:10, Pedro Falcato wrote:
> On Tue, Oct 27, 2026 at 12:17:27AM +0100, David Hildenbrand (Arm) wrote:
>> From: Josef Bacik <josef@toxicpanda.com>
>>
>> An exclusive waiter in folio_wait_bit_common() can leave the wait loop
>> because of a fatal signal, then be woken by folio_unlock() before
>> finish_wait(). If the waker did not hand over the lock, the waiter returns
>> -EINTR without trying to acquire it.
>>
>> folio_wake_bit() stops after waking the first exclusive waiter, so this
>> loses the wakeup and can leave other waiters asleep indefinitely on an
>> unlocked folio.
>>
>> After finish_wait(), let a waiter woken without a lock handoff try once
>> more to acquire the lock. If successful, return success so the caller's
>> eventual unlock wakes the next waiter. Otherwise, the current lock owner
>> will do so.
> 
> Has this been reproduced? I feel like this would've been found out by now?

Let me dig ... I don't find mention in the notes, but I was told that most of
these things have reproducers.

I guess it's harder to hit in practice, because you need a fatal signal and then
keep the other waiter alive while nobody else will take that lock in a timely
fashion.

I asked codex to try writing one but it refuses for security reasons :)

-- 
Cheers,

David

