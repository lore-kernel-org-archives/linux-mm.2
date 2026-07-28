Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 900B0C54F54
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 19:06:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46EE16B007B; Tue, 28 Jul 2026 15:06:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 420926B009B; Tue, 28 Jul 2026 15:06:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 318AE6B007B; Tue, 28 Jul 2026 15:06:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD4E76B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:06:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4919816049C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:06:51 +0000 (UTC)
X-FDA: 85039117422.23.C967D6C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 75BD6C0009
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:06:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jx3hyKmp;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785265609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kS5Ahv5hQkigaERDueET9kXWoep0bjurNYYMquRhpgk=;
	b=RUhOzLDKgv3K7aAsp+G4yvMhZ2WtYTcZ8cp9NnDUalEBPYA5vwoh/P44i2A2Vpc8RQ06xU
	qvgoX4yU0XzPlsok+FltBgGhPKSgU4Iqm1AoqrEtY4hRYTlXaSpEj6douVxqBP99xDlq7z
	lgxui69/Qgi80DmgoGk/Qi5zTTUDk4k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785265609;
	b=FPt3wGHl5ewZ1fNMWxTuhXRNsGA6eebAVOJODg+wpk3vXFJHAHQ+t5gT9spZZz69Klttgz
	U31qJ33fyLncQsTVEOz9h3ID6tVr2SEeVMIhyi7a3ROG8/LD/Q37HF/i0THjRCu57Vl9j5
	T9zF32z/U1WQDfkAcpnjyWlxWc47Ox8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jx3hyKmp;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 94F58600FC;
	Tue, 28 Jul 2026 19:06:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE0C1F000E9;
	Tue, 28 Jul 2026 19:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785265608;
	bh=kS5Ahv5hQkigaERDueET9kXWoep0bjurNYYMquRhpgk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Jx3hyKmpQyVSEPuGQT9uPq1Lhrnp5I1P7jdiGbpZ2JXtgPmWmdk7NZbALHV7ckZv4
	 j/8c/aRCOL7zhaPU6PfmpYlv3Qzj0xlJNHnSWwCq7CzNOuQILedY3apjyT7kW0UHIF
	 y0RGgeN1NpGcd3TUD36gKEuOo2Y7LOAONG3V1nXpnckDyon+j0tceMFi8jctAYXHia
	 +vGqoE/pMeIPX2FP5VLUwoUfxAN0u2Mwv3OqaHpI50eZkm4pPL+fjU2XPeBEv4ZDvd
	 VJ72GNPROgSCvNmXhVda6VBbBII48KMFsYL77IImvwjr6f7Krknr28Qiodelc77/wM
	 Z/kZrU1iLCCBA==
Message-ID: <744290ab-b5b3-40b4-bb70-006231fcb328@kernel.org>
Date: Tue, 28 Jul 2026 21:06:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: unpoison pages in memory-failure teardown
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
References: <20260727095415.385026-1-usama.anjum@arm.com>
 <a811c371-ef3d-4932-a9d4-2390a98e1382@kernel.org>
 <9a289152-70c1-4e13-a0d5-f77bdee72d8a@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <9a289152-70c1-4e13-a0d5-f77bdee72d8a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5os6orbduwnjz9gwsnsrcjg1thasbedy
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 75BD6C0009
X-HE-Tag: 1785265609-529102
X-HE-Meta: U2FsdGVkX1/hAo8HassdG+T8JaB5R8YXbp40EdYQA60U2NeFGY0b44qqSZx1Vp5B8ZF3DsbCx2mEKLkwkW6jl3dAg2kWz7+QzNvcG2xJqLeWgeJ5sH/JEhEAS5R+jxGiFQL+vawULzHQGeewYLATVhltY9PydbQSNLa8vqu1I0THyTT/Ip9vj9qUFyBb8qLVThUpytwWHMrPb+ZMwpPS184HDdBKFTgqOqCbDOHzR5OleesYSx1RuJiFeCKhQL5Ftv2VDiK/BUykW4yPeNoOtDpKMqvitD8KiOewq2/sWJhoNtsiy/6OXA46fp5YI4ylb0ZI3Xsj1PfgdrBk45oA1KSfoCIAVOT3vmtlqVdtH0GuuRIFawR9LCMFg1pYvfVmKhB56LobmULCPrCLSF88CFIi7quKj8Yt0sOoNVIqDLTpJaoubYS0lubwXhVyYCFseWNyUaP+8grXzHOPKy7vBVE1Q/gX1ftddsIOcH8RB0eZvikNEIIiH5JB+bD8i/XZbkCmQlzN3xnTj9qXh9/l3G7/4WZPJZJdfI0LKB+ORd7NNFoTJqbfUpM0fjrJIfh1HXgK4bNLRwgX3fUDMjhMboQh3GYv5D514Ss6EIVXtrhblSO0MpCJ5vWRGvELFSZwiXexS059nITs4mCeDe4l+g5cjTexIhwclWO8hhqPekqFNJPjIsbTPzXFDqS6keXmagvbzQ7tm4vg/mxpxFtVZ96EROoF+ob3kEZa+sq7nb9ALJb6Q8FA7MEMHLo4hRjeRH1d4zf5+RgtNcSWye6z56Z4j8E3KMQctVc/Rtbzeq6BjRyAyI8Pnm99Z0pzMttwo/ktHFRVTzAePO0T93vIMGh3pXHo1ErhgL+ib2I7NT3BcGG2bRASjs6UXJSlEpAPRcWh8bZKm6yLn1CQ5JNvvV8rsc6WXtEZuO4m/rojIJQBArehpaU3zk02lMTQ4x1fcnvSW2oc/5Om/4iiidT
 EeP1T4tS
 j9pHuYB3upbXLdIIQWVMEMeHns0GK9uPmPPoz6yXoHs3HIgbFr4aD+RTG12oeDAoZJM+R2nqxHSqaImo2pzVN0Tl76CuoHLwByKRAMftdprc7gVZJntTcFNat0YFPN5JzsK/QquE/XpFOUSf9e6fvcumaGjImE4cQ49Hg/97KBrvlkg+p6g0/LYL567fGNS4MtGTCM9nW268ChAuDQmTQmp2TePIwxPcIBri3ifx19epAlvdAHSbFWyibarPc85sal664J3i+qTzEFFNjNiCWKFJxu8N5V7LzcuWdAB0+tNFIpU34RQcAyiA6roVutBiCZclt/WHeXI42q+A2EJw2bb+CdAuaCQFIntJeGtR9f4nRnbt1qT9QHQiCEfz97CVPjyP6FYkBjR3qPZaGknY9TRIZ2MiyK8uGz7bxpkDtICpFFItBYTXM4h3qRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/28/26 16:22, Muhammad Usama Anjum wrote:
> On 27/07/2026 1:31 pm, David Hildenbrand (Arm) wrote:
>> On 7/27/26 11:54, Muhammad Usama Anjum wrote:
>>> The memory-failure tests call cleanup() only after all result checks.
>>> A failed ASSERT_* invokes fixture teardown and aborts the test, so it
>>> skips cleanup() and leaves the injected page hardware-poisoned.
>>>
>>> Invoke cleanup() from FIXTURE_TEARDOWN() instead. Guard it with
>>> self->triggered so tests that exit before injection do not try to
>>> unpoison a page when no injection was attempted. This runs the existing
>>> HWPoison and HardwareCorrupted checks on both normal and assertion-failure
>>> paths.
>>>
>>> Fixes: ff4ef2fbd101 ("selftests/mm: add memory failure anonymous page test")
>>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>>> ---
>>>  tools/testing/selftests/mm/memory-failure.c | 26 +++++++++------------
>>>  1 file changed, 11 insertions(+), 15 deletions(-)
>>>
>>> diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
>>> index 5d00aab31f9b5..eaa8b9bd401a1 100644
>>> --- a/tools/testing/selftests/mm/memory-failure.c
>>> +++ b/tools/testing/selftests/mm/memory-failure.c
>>> @@ -122,13 +122,6 @@ static void teardown_sighandler(void)
>>>  	sigaction(SIGBUS, &sa, NULL);
>>>  }
>>>  
>>> -FIXTURE_TEARDOWN(memory_failure)
>>> -{
>>> -	close(self->kpageflags_fd);
>>> -	close(self->pagemap_fd);
>>> -	teardown_sighandler();
>>> -}
>>> -
>>>  static void prepare(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure) * self,
>>>  		    void *vaddr)
>>>  {
>>> @@ -200,8 +193,7 @@ static void check(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure
>>>  	ASSERT_EQ(pfn_flags & KPF_HWPOISON, KPF_HWPOISON);
>>>  }
>>>  
>>> -static void cleanup(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure) * self,
>>> -		    void *vaddr)
>>> +static void cleanup(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure) * self)
>>>  {
>>>  	unsigned long size;
>>>  	uint64_t pfn_flags;
>>> @@ -217,6 +209,16 @@ static void cleanup(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failu
>>>  	ASSERT_EQ(size, self->corrupted_size);
>>>  }
>>>  
>>> +FIXTURE_TEARDOWN(memory_failure)
>>> +{
>>> +	if (self->triggered)
>>> +		cleanup(_metadata, self);
>>
>> If the variant->inject(self, addr) fails, self->triggered would already have
>> been set.
>>
>> Wouldn't it be cleaner to have a new self->poisoned that we set only after
>> ->inject succeeded?
> Setting self->poisoned after variant->inject() returns would not cover the
> MADV_HARD signal path.
> 
> The call path of madvise(MADV_HWPOISON) is:
> 
> madvise() -> madvise_do_behavior() -> madvise_inject_error(MF_ACTION_REQUIRED) ->
> memory_failure() -> hwpoison_user_mappings() -> kill_procs(BUS_MCEERR_AR) ->
> kill_proc() -> force_sig_mceerr()
> 
> SIGBUS is therefore queued while the madvise system call is executing and
> delivered on return to userspace, before execution can continue after
> variant->inject().
> 
> The test's sigbus_action() then calls siglongjmp(), so an assignment placed
> after variant->inject() would be bypassed. The flag would remain false and
> the test would attempt the injection again after returning to sigsetjmp().
> 
> Also, memory_failure() sets PG_hwpoison before several recovery paths that
> can return an error, so a failed injection return does not prove that the
> page was not poisoned.
> 
> Maybe renaming triggered to injection_attempted is more precise here.

Yes, that would make it clearer. + adding a comment that we want to cleanup even
when injection was attempted, but failed.

Thanks!

-- 
Cheers,

David

