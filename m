Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79FEAC61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 05:18:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70D2C6B009F; Sun, 30 Aug 2026 01:18:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BE9C6B00A0; Sun, 30 Aug 2026 01:18:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D4696B00A1; Sun, 30 Aug 2026 01:18:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3986E6B009F
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 01:18:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9D5C912026F
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 05:18:44 +0000 (UTC)
X-FDA: 85156780968.03.7DAF254
Received: from mta1.migadu.com (out-56.mta1.migadu.com [95.215.58.56])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6A1E81C0007
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 05:18:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OUfzD71g;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.56 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788067122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n8ezaL9icbU9C7HIFQvgdZQO2Wi8VddFCHPu5jqFmjU=;
	b=3poSq02UVLHzydA+H77EgqI/CikJ8AQ7cKrf3cAMfH47E8XeIA9T8ceVU2khtfAW+6gzDL
	JnPj+zVVU704GhLsDg9otj1L04azXuG5x/rW18qC2eobvdbnSHYrVlWKkj1PdDdZPcPEmQ
	6gxpMVFX3qO/12Mg80PGr8SABinVzCo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OUfzD71g;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.56 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788067122;
	b=1AoMG3rJ7KSw3XkAZWERYquI4z/Nz7TJopJcjCJ+aI0fB+8KVKAXKBdy63Ni2n4B1Ft9uR
	+nwIR0xvkMZnnkFXqFZpvNet94ClKtDmYCJgbzujdVTL6GJG/JCdbvUpi6XjWPvzxOTBke
	/IcPvir4UDqKIN0mtLkYiqyubyBxU8c=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=zpUnzyomNCkMBgYKtdeC/00VUtDf38xmo/shun73kSE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788067119; v=1; x=1788671919;
 b=OUfzD71gsBHVbLwuzg5cFSUCjzA+5Tj79KnYt6pmfMxrAWGvYUREWb0H/MOx36qj3vQAeMOl
 NOKMbQLTZR1QIrElQM8y3bW2SpaDfdOPxgU0P3KjzcqO2nOPMW09WF5xYaMVrBa1CSlK10aqo+s
 g0GtYJTZa82USoSkMv7sFNDQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 82afb8ac5ccba36e;
	Sun, 30 Aug 2026 05:18:39 +0000
X-Mizu-Trace-ID: 82afb8ac5ccba36e
X-Migadu-Flow: FLOW_OUT
Message-ID: <c2577ec5-acf6-466b-ba66-0b3bcabbef7d@linux.dev>
Date: Sun, 30 Aug 2026 13:18:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] mm: reject zone device folios in more folio
 walkers
To: Andrew Morton <akpm@linux-foundation.org>
Cc: gourry@gourry.net, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, david@kernel.org, ljs@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 usama.arif@linux.dev, vbabka@kernel.org, jannh@google.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 balbirs@nvidia.com
References: <20260817220810.1175596-1-gourry@gourry.net>
 <20260818043143.22297-1-lance.yang@linux.dev>
 <20260829171819.e1e8910e7e9a8a46b87c870f@linux-foundation.org>
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260829171819.e1e8910e7e9a8a46b87c870f@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6A1E81C0007
X-Stat-Signature: mw58qn3r1g7qzkinsqqdjqzscts3cb61
X-Rspam-User: 
X-HE-Tag: 1788067122-162304
X-HE-Meta: U2FsdGVkX1+utvkc6Fg2L/OAQx9Q5o5/0hrKkZlEBnkV+W7PcrfW0Y6f3RT2mJGrbIZwsWIIgDDneoJ1e1bopy0uy1HmuracJWXnjHTQxxh5lkKPeQ01TnfXaOzJ0YnNsXu/lc9PNBlSvhUBCXR1PNZflDyA1SyCAbEXizNCEEl996SQHIhYTtO8vE/0LjREyM+0dA756FcBWG3ItQj8QhTOokzv32UtWV2dlDTtGNPbnkyefkg36YNdbipaOAlzziXI2nvGQsqwhYn1TiMSGsXxNCPLZjwwcOAy69CrME8gXh1tA7CzcQ331sJ4FGZuBiBr9shwL1THI0XIdvDCqbBZVSh9WVKTZq4mrUARtFWjgKaN0WDwrQLdevmreOrGnfRm5dONImZeag/OeDorVZinZuMjz0wCPmH9FE3JAfmmt056B+tb3hGNAi6Bs+PgwGoJhkzAXRsCwDLYoiunl2px+YYjYgjHI4orbnlOXT0JVf7SF9XPK+f9nw7Xic1ae7ECyXr+4r+21Pa1MBA9u5l6BCHvCW0Z0Tc2v+BHJBOoCqoxqt4qNqDZRoG1C5LQk5zV39+fGEwd/f+bvmi+4lqUCw6HQFKM+5jYNm9fuINCUdaxm6wq9MBfwaPVCuudgY1q3jrsEMqjSWyTuQokDeRK2zw1ODqELFh3inOuOnihddfeM4qp3PtelLMCnX394JnsFWhXbJDp33z3aE32FDCVjn4D7MpWrZw9N1Q7zR9iathnuPcDmISe5c/aY7TfuPeFJKbn6FuZQY94wOAwndc0Kyhq7IO2PvTy+EaSTjsuwKp8yppG8ihomtbWlCBV6IoqEluJS27L/YkC6iAYwqOA483BO0+SzbQzefzJSoPnXdPjAJzkmVYehbvFrnqetlzzlpQV+U6q50hvxn+rew91Xm4iv1mp4A8z3awcNHSMv3E22FpsiWMDOfwWOiruB9t2CdaeFhhs+k+0Y9I
 9OTJnqJR
 AEldXwczypTxBOup6wxfBSjYBsXgnZAN+L7hR0lPaLf9y04bJrrcxK5DokyxUp3pw9GJoRzfIc3p+5/jBdN7lMR/W5MpIpAGw+udBHRCsarQ3JUBkm34Gt2BFl3Rz9gNKhBK6tfVzpKkxvkWQIiRu8ZOvD9dzvgpy4mM0BaYii2LNygIdfP03iMQTbQIPT8mUcVMQg10yVwehDGzFj6/qGtS9TnItwmK0NBy2O+aaxiwk5OQKtWzs93K2Dpic2X1ukQ0u2JcUPS0vmY57rdL5pPJGmPvCIlqaGezpcZESmypQWrWVv7+nGp6sx+LlFrdesvD3UfsxXsG73/ul3IDKPbqhr2UvohPBCJZonz6l4+uLRZGPg6UbpXSotIhX7g3n9ZiFV519g3jK7Hk/3rg1rSdflneuFTbAWsBbdijz2X+ASTg8baG9LuNk4a9HEr3fwOy6pt5xAdso3sCEqa+dOyM25N/VlX+FakId
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/8/30 08:18, Andrew Morton wrote:
> On Tue, 18 Aug 2026 12:31:43 +0800 Lance Yang <lance.yang@linux.dev> wrote:
> 
>>
>> On Mon, Aug 17, 2026 at 06:08:07PM -0400, Gregory Price wrote:
>>> Several LRU-oriented mm walkers resolve the folio backing a PMD entry
>>> (or a physical pfn) and then reclaim, age, migrate, or lazyfree it
>>> without ever checking for ZONE_DEVICE memory.
>>>
>>> This series adds missing folio_is_zone_device() rejections, matching
>>> the checks that comparable walkers already perform.
>>>
>>> - mm/huge_memory, mm/madvise: the !pmd_present branch above these sites
>>>   only filters device-private entries (which are non-present).
>>>
>>>   A present zone device PMD (e.g. device-coherent) would still reach the
>>>   folio and be lazyfreed / aged / paged out. Add an explicit check.
>>>
>>> - mm/mempolicy: queue_folios_pmd() can see a present zone device PMD
>>>   (e.g. device-coherent) and queue it for migration.
>>>
>>> No crash reproducer - this is a correctness/hardening cleanup found by
>>> inspection. All checks are placed after the folio is resolved and before
>>> it is acted upon, on paths that already hold the relevant page-table lock,
>>> so no locking or refcount changes are involved.
>>
>> Cool!
>>
>> Gave the whole series a spin on x86_64 QEMU with a PMD-mapped
>> device-coherent THP. Without these patches, partial MADV_FREE and
>> MADV_COLD reliably hit a kernel panic in remove_migration_pte(), while
>> mbind(MPOL_MF_MOVE | MPOL_MF_STRICT) returned -EIO.
>>
>> With v2, all three worked fine, PMD mapping stayed intact, and data
>> checked out :)
>>
>> Note that both kernels used the same small change to the in-kernel HMM
>> test driver, allowing its coherent device memory to be allocated as 2 MB
>> folios so the PMD-mapped test case could be exercised.
>>
>> Tested-by: Lance Yang <lance.yang@linux.dev>
> 
> Thanks Lance, you're so diligent.
> 
> I'm wondering what to do here.  Gregory told us
> 
> : No crash reproducer - this is a correctness/hardening cleanup found by
> : inspection. All checks are placed after the folio is resolved and before
> : it is acted upon, on paths that already hold the relevant page-table lock,
> : so no locking or refcount changes are involved.
> 
> And you had to tweak the hmm-test driver to reproduce the bug(s).
> 
> So when do we push this series out to -stable?  As a hair-on-fire
> hotfix, or as a leisurely next-merge-window thing?

Thanks, Andrew :) Yeah, I'd say next merge window should be fine :)

The crash is real once the mapping exists, but I had to tweak test_hmm
to create that PMD-mapped device-coherent folio, and I couldn't find
any in-tree production driver doing that today.

So no need to rush this one, I guess.

> 
> And Sashiko was clearly having a bad day, able to find only nine
> pre-existing things to shout about:
> 	https://sashiko.dev/#/patchset/20260817220810.1175596-1-gourry@gourry.net
> 


