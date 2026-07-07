Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DC4FC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 14:12:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 695276B009F; Tue,  7 Jul 2026 10:12:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66C9C6B00AA; Tue,  7 Jul 2026 10:12:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 585696B00AC; Tue,  7 Jul 2026 10:12:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3140B6B009F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:12:37 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B6B9B12045A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:12:36 +0000 (UTC)
X-FDA: 84962171112.16.AFE4F54
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id E0725A000B
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:12:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uquIvy5x;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783433555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mPDupzAMb9WmhXqlEKzwpF9K9qDLD4ZC2gztkeWi21I=;
	b=k1qUcWe5ujt83xLv4dNlH831wu1A/blKPfaFoM31H8uM/eulNvU65+muYGhxrkrKbjheSU
	Ro/S7s7iV5EAyDXAshhxsS98dqVYQXiAaPW4b/oZhGMLWxjrhh7prcb+/klGh4AzutBvN4
	rMry+XJ3ysqhaGShzLiYqoEmsaYs4ko=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uquIvy5x;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783433555;
	b=DWYr8WhBJVv3AYKt1LA7WLRcAKqFhBHgKhDM5tY/uemlaHso+nNu7S6Wc6jT47s6kfYWGl
	OepILcqr/LbEInwK8mFAWSv2V7Tzc4F+OZJ+jSSdTAraGm2v2Lt7HIrMENCqrCd3NuNUiM
	KTLLVhh27cClbhT8Hn8CDlSgGAK4pns=
Message-ID: <fde1372f-5d80-4a1b-8bbb-11441db9f55d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783433551;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mPDupzAMb9WmhXqlEKzwpF9K9qDLD4ZC2gztkeWi21I=;
	b=uquIvy5x6UU/stQiS20fyZvnzOaj0KnY8Q6Z0SPIzsLLe9yOc6UIs00a5XEEJhxePHE3l9
	I25qCrwejUAfvTq+okW2CGiyVjpRpLjcBX1IK8RMt9aqXD9JKmzOn0ZgywMtodGL2V/SGf
	3teHPq8lBC3/ho9Red9JK9j7xjtsXGU=
Date: Tue, 7 Jul 2026 15:12:11 +0100
MIME-Version: 1.0
Subject: Re: [PATCH 0/3] mm: handle device-private PMDs in walk callbacks
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 david@kernel.org, dev.jain@arm.com, gourry@gourry.net, jannh@google.com,
 joshua.hahnjy@gmail.com, lance.yang@linux.dev, liam@infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com,
 npache@redhat.com, rakie.kim@sk.com, ryan.roberts@arm.com,
 vbabka@kernel.org, ying.huang@linux.alibaba.com, ziy@nvidia.com,
 shakeel.butt@linux.dev, hannes@cmpxchg.org, Balbir Singh <balbirs@nvidia.com>
References: <20260707135255.292870-1-usama.arif@linux.dev>
 <ak0FtLIlTyCo_8lB@lucifer>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <ak0FtLIlTyCo_8lB@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: g3gs7y7fdkhcyduuu1r84k6gi8juwkm6
X-Rspamd-Queue-Id: E0725A000B
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783433554-573592
X-HE-Meta: U2FsdGVkX1+Zxyujbb+/TIoLICuc9tPlRKMtKSHvQAvCXE9kQ4d2GSGrtVPhpkpD34/k++ocwlr4W4XRSfNwM+g09+YCXuMlbpMnk51ELlas5QHznBdPeDOwex9wkGY05ruzDBl0+h0k6eWWq62yfEjvhkSoMaisJsl+I8B7/TR1TS9DdvVJKpno3jR8sYRm+/Nz04kjY22frpSLETQz3IVQrryqj0Wbw5nPxQfoSfvd+2p5SSQv1yHspiYhwIfM6bYwL3cPYRDDZN2rXtZy6RoeKxM3TzwFJNZkOHUj6aSEV+wl0yi5kQhcMFy8eRVr/wyPmheQQ/us+rZM72+U2r2DmJit/QPUlGxRTN0SKJoXy93l/n8Nh1Y7eLL6LRVFiAC704ReLtbm4OI5Zg4G9SA1wLR1nSVZBqVNjUdmYu50hYlSB5gGpufTkPq5q47T4AqYqLTI6W7l9g2MKkWngCiRjPmtBzSqcubdEkg8L5OqiAf15G7rXXIGgIOEhDU3yonqHdznemMia01CxBcg/12Zjr1xo7fsYOFJcMgHTnaqHAYNRWEgX7veVZilcsY0hKJRZ7QZg9uuJaVZxcFwjpqlk0wI+d39Iekr0kIUZfqQ+BevvTGchCFG9q6JEFrX8Wd+ZfHDIQYwReJWg1xclW5a+ZOOnw/Ct/tDVp2URsYZbYy1CpnMjrletFaGhhNrTGeZtspMDSyEtS1LlB32yo7j9659A8dnbOdI4efhjH1+rcX7PGjSWg02Tjc5tYQKhe6kBAJSfWt38MoBf9iW2APfRyA3Ro46PP/iy6kXYprMbmMOzDQZbxqkU0VFVP42GZepQ0h/KQ713hLtspM2tf4Ml5pBWFyNcZ+gaz7LljtcsHR4+AeewAJeuoi2KJrDoNE5tj9k/17a5m3wASj9STnYHMdqyZMUXpyDY8ncAQgFeniy93RPj6KhWl7zodmxNBLQweqWnvsxNTdLFgY
 DH1FJ851
 dRekPNKrkfMzjvyVeLJG0+bs1IQ5DZNUk9qQ5p9b/sh9I1tDlEvkEGhuXcfOnFl+LAp63w0j9DcB+iWc5C1texOmZ/MPdlWNYSS4RdGnHMRYpdhpt2/4MtVFFt4sJ27oupzY/aYTZjUnuJxp5/zIhm4O97+5SnmZ2ytHnOCQQprNqY+/0f4r7T1ac4Xk3DfaU8yjA6cUV1MozcGEb8SaLF5WpGTeSbRkA7T0g3DuvZLJjNbpuyiORFlVjGP1sX8cjJHc/0jG566Czz2kBpcAk2mOdH7jEJt7sf9sSIux00OF9ZEynOt91jll6ie45o79ph/gA1qnRkmYIDa5Zg/1BKjAbZfHCMJJLo8cw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 07/07/2026 15:01, Lorenzo Stoakes wrote:
> +cc Balbir
> 
> Thanks for the series!
> 
> I think Balbir should be cc'd no?
> 

Ah yes, sorry about that! I just sent the patches to the list I got from
get_maintainers.pl.

I think maybe we should modify get_maintainers.pl so that if there is
a "Fixes" in commit message, than the author of that commit is also
in the output from that script?

> On Tue, Jul 07, 2026 at 06:45:06AM -0700, Usama Arif wrote:
>> Since commit 368076f52ebe ("mm/huge_memory: add device-private THP support
>> to PMD operations") a PMD may hold a device-private swap entry whenever
>> an HMM-based GPU driver migrates an anonymous THP folio to device memory
>> via migrate_vma_pages().
>>
>> pmd_trans_huge_lock() succeeds for such PMDs (pmd_is_huge() returns true
>> for any non-present, non-none huge PMD), so several MM walk callbacks
>> that used to assume present THP or migration entry are now reachable with
>> a device-private PMD. The results range from a VM_BUG_ON() firing on debug
>> kernels, to an oops on a bogus vmemmap dereference, to silently isolating
>> an unrelated live folio from LRU in the aliasing case.
>>
>> The first 2 fixes were reported as pre-existing issues by sashiko in my
>> PMD swap entry series [1]. Hopefully sashiko won't point these out
>> in the next PMD swap entry series :)
> 
> Yeah I don't love these 'existing problem' reports (distracting from other work,
> add workload, really it feels like that should be a passive reporting mode for
> sashiko not arbitrarily added to other series), but sending it as a separate
> series is indeed the right way :)
> 
> These of course should never block an unrelated series.
> 

Yes agreed!

>>
>> [1] https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%40linux.dev?part=6
> 
> Hmm we've had a whole host of issues with device-private PMDs recently.
> 
> Balbir - would it be possible to audit all of the code paths and proactively see
> if there's anything else that could hit problems here?
> 
>>
>> Usama Arif (3):
>>   mm/mempolicy: skip device-private PMDs when queueing folios
>>   mm/madvise: skip device-private PMDs in cold and pageout walks
>>   mm/huge_memory: skip device-private PMDs in madvise_free_huge_pmd
>>
>>  mm/huge_memory.c | 3 +++
>>  mm/madvise.c     | 3 +++
>>  mm/mempolicy.c   | 2 ++
>>  3 files changed, 8 insertions(+)
>>
>> --
>> 2.53.0-Meta
>>
> 
> Cheers, Lorenzo


