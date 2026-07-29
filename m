Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4023FC53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 03:38:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D7D76B00A2; Tue, 28 Jul 2026 23:38:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 588916B00A3; Tue, 28 Jul 2026 23:38:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 478A26B00A4; Tue, 28 Jul 2026 23:38:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E8876B00A2
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 23:38:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B1DF74056D
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:38:10 +0000 (UTC)
X-FDA: 85040405940.29.5A96234
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1AE7840005
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:38:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=kMRhhoag;
	spf=pass (imf12.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785296288;
	b=F4tmpzRFFwcVxuq+XJs+wz+gSivcV8z81fyYOKDAaw/dzq1ckY9SlnfhHp0HRG2YsQk8r0
	35IHiR6V277nke4ggCx8nT7AJ7VpKxyywywK9USmkSDioiiY+6U+HQSDW5mS7FSW0FVdYj
	P+7VG3quwUhBl5aw1ncaVxTI++pzXvE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=kMRhhoag;
	spf=pass (imf12.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785296288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5dJy2BwEn0kVulvVpmXjZDrR67cWI0QsFRXsAfEbQCQ=;
	b=shDrwK+nXDaemyJPSxDpBQsFETEzYVvFLdOIegUrwAaTq6Amsu6ndQGY72YV1YPMM4VFet
	/tVL+gz6cMDBDcAeRw02PrNUOfhmhFnOZUmZZs+vV9APkeUxzDVfOxpY/qunF7ifjd76qS
	ZbM0vS/pSmb0R7mKi0iscpuQUoPEqyo=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=5dJy2BwEn0kVulvVpmXjZDrR67cWI0QsFRXsAfEbQCQ=;
	b=kMRhhoagZ3otRMIf6kVu72AEYqW6j4kJExP2OKvQ8LVdfaByHgDZGXGqB6DUQ128C+hjZNlp9
	6i5HrzB+QDsfE0WMkbZgn1BB7hrtsh36w85076AfThZTCJ4/UVw//h88kVKw4wZpMfr3imTopFN
	azTxVo7N6hB572NKfDT3l28=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4h8yTw28Ffz1K98V;
	Wed, 29 Jul 2026 11:28:36 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id E799640563;
	Wed, 29 Jul 2026 11:38:01 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 29 Jul 2026 11:38:01 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 29 Jul 2026 11:38:00 +0800
Subject: Re: [PATCH] selftests/mm: unpoison pages in memory-failure teardown
To: "David Hildenbrand (Arm)" <david@kernel.org>, Muhammad Usama Anjum
	<usama.anjum@arm.com>
CC: <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
References: <20260727095415.385026-1-usama.anjum@arm.com>
 <a811c371-ef3d-4932-a9d4-2390a98e1382@kernel.org>
 <9a289152-70c1-4e13-a0d5-f77bdee72d8a@arm.com>
 <744290ab-b5b3-40b4-bb70-006231fcb328@kernel.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <067fdf0f-7322-c011-0f2a-882dc63f0964@huawei.com>
Date: Wed, 29 Jul 2026 11:38:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <744290ab-b5b3-40b4-bb70-006231fcb328@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1AE7840005
X-Stat-Signature: juwmyqbd4coi79icw3pa6f8r4jdsj861
X-Rspam-User: 
X-HE-Tag: 1785296287-255865
X-HE-Meta: U2FsdGVkX19axnGKceotOfrlowD7cpcySosSWAqfVQZfjGo/LSYMv+CCr48cFiWzuRfdUjLjcm1xAO6mwzIXbvJWzbyJkTOO7tTBj5G51nTGUAO/zs6HbUaCLFrBjxjPaEZeJfHM5dtlWfDXBb2VY3CP4Ov/+dGg/rH1wbrgKfayr7kLug2ipmNikKtxDZF0Vx/waVozyMrhTi5qg9Rcc2gtXN7fykBwbfgQWfaxHYpy1VvDvieI8zZ04igYW3SLCk85SBcpjCQQ3Y+ORjjsA1400vaGC/sBLNZnsS80TuB2zyOP8VgjmRW1wsDAmaLqDpCXuKAqiX6oIbcIEoPDUaQIhzX0wybRnWP76rts4u5Gp9VtKlY4W7f/E+/+4cw6r3ESYOJoNXHexDOo184PKAqcl2pshkoKO9gyxJzsfipAIBk5igTqxVf9ktnoH31geMSay0usFAT5F+5zVCIWe9wCSQrZ2OKOdlO/ttXJAMopflCX19JUhA6G15PSZu+Srd/ihEik6BfvV1wfEgbWmwE7b+yBEuJ/F+1sMaYz0c6s4nnMJYrhvBaQzvOZkhC0SrAca1+xgsrLkApayLfMttRk9F3OvvvTEWUKSzsZOL3YtBo+fPWqtm188nHwyJW9zymA5VqR7rMIdyloNOt4Lx3k4/Q+uGoyUTh/GHBSnN47xL0Z6Nsn48Bx/Fg/wLi9WcV/uzkOiLorLpGy9z41nzfU5zVOpCM9UdFm1CFCxx1RvJWQvJu13PkBOSSrQ9kn4FBj4H0EVwmGpf9iXisw9zNagjqPPLtX34nnan+Q4xGbQ/EJ/w3xCJz/kguOswEmPLRk5+11SgO51lWeZNkOZEoeSDJa2ZEk4sdc0AT1agdhT8Wc9oEHO35VcM1o7aWZZxUF9x5iyPWI4duIafJIncYQLmIL31X9qRGXH6MYSz+xqcT3jtQMbNweTsBjJvvTSdPsg0tXRlaMxZ2Rg/F
 PUkatuDw
 HSgppc72FG6LgIuTi9My/MAxEch/TDxmpnsUdTC6eWOC36hoBk17f7JawnWkTq4FhmChv6g9DLxphUaL3AbnsoTk6LB1LxgLEDe3DAeoAPVW4f70mI/8c0iFayZHupMDnsoc7rk0s3jOuNzyobyPZJ5wsKXpgb5vMF2RyLYMTRn4qQu8/65kTgYu3RjOrT7MjnsNztTuhIxkrO21As87V46V50I5nM1v2UB+v4cn+75w3uRQKtNvD6qUNTb5X9PI4gcwuXTVRPNCRrQzkkT7yKDyFKYbDC+oI6HasxBIZPGnzoJwJUjKdXgIf2sarnJX6QwHLssPs6wK2+YupyN8e8KArUzh9Nf+MM6QIXcUCbmFL4rSitFGTlwF3I0R0EzPH3ga4zzfk39FdBgBQF1g6hHx57Hru9hlNvLem
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/7/29 3:06, David Hildenbrand (Arm) wrote:
> On 7/28/26 16:22, Muhammad Usama Anjum wrote:
>> On 27/07/2026 1:31 pm, David Hildenbrand (Arm) wrote:
>>> On 7/27/26 11:54, Muhammad Usama Anjum wrote:
>>>> The memory-failure tests call cleanup() only after all result checks.
>>>> A failed ASSERT_* invokes fixture teardown and aborts the test, so it
>>>> skips cleanup() and leaves the injected page hardware-poisoned.
>>>>
>>>> Invoke cleanup() from FIXTURE_TEARDOWN() instead. Guard it with
>>>> self->triggered so tests that exit before injection do not try to
>>>> unpoison a page when no injection was attempted. This runs the existing
>>>> HWPoison and HardwareCorrupted checks on both normal and assertion-failure
>>>> paths.
>>>>
>>>> Fixes: ff4ef2fbd101 ("selftests/mm: add memory failure anonymous page test")
>>>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>>>> ---
>>>>  tools/testing/selftests/mm/memory-failure.c | 26 +++++++++------------
>>>>  1 file changed, 11 insertions(+), 15 deletions(-)
>>>>
>>>> diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
>>>> index 5d00aab31f9b5..eaa8b9bd401a1 100644
>>>> --- a/tools/testing/selftests/mm/memory-failure.c
>>>> +++ b/tools/testing/selftests/mm/memory-failure.c
>>>> @@ -122,13 +122,6 @@ static void teardown_sighandler(void)
>>>>  	sigaction(SIGBUS, &sa, NULL);
>>>>  }
>>>>  
>>>> -FIXTURE_TEARDOWN(memory_failure)
>>>> -{
>>>> -	close(self->kpageflags_fd);
>>>> -	close(self->pagemap_fd);
>>>> -	teardown_sighandler();
>>>> -}
>>>> -
>>>>  static void prepare(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure) * self,
>>>>  		    void *vaddr)
>>>>  {
>>>> @@ -200,8 +193,7 @@ static void check(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure
>>>>  	ASSERT_EQ(pfn_flags & KPF_HWPOISON, KPF_HWPOISON);
>>>>  }
>>>>  
>>>> -static void cleanup(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure) * self,
>>>> -		    void *vaddr)
>>>> +static void cleanup(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure) * self)
>>>>  {
>>>>  	unsigned long size;
>>>>  	uint64_t pfn_flags;
>>>> @@ -217,6 +209,16 @@ static void cleanup(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failu
>>>>  	ASSERT_EQ(size, self->corrupted_size);
>>>>  }
>>>>  
>>>> +FIXTURE_TEARDOWN(memory_failure)
>>>> +{
>>>> +	if (self->triggered)
>>>> +		cleanup(_metadata, self);
>>>
>>> If the variant->inject(self, addr) fails, self->triggered would already have
>>> been set.
>>>
>>> Wouldn't it be cleaner to have a new self->poisoned that we set only after
>>> ->inject succeeded?
>> Setting self->poisoned after variant->inject() returns would not cover the
>> MADV_HARD signal path.
>>
>> The call path of madvise(MADV_HWPOISON) is:
>>
>> madvise() -> madvise_do_behavior() -> madvise_inject_error(MF_ACTION_REQUIRED) ->
>> memory_failure() -> hwpoison_user_mappings() -> kill_procs(BUS_MCEERR_AR) ->
>> kill_proc() -> force_sig_mceerr()
>>
>> SIGBUS is therefore queued while the madvise system call is executing and
>> delivered on return to userspace, before execution can continue after
>> variant->inject().
>>
>> The test's sigbus_action() then calls siglongjmp(), so an assignment placed
>> after variant->inject() would be bypassed. The flag would remain false and
>> the test would attempt the injection again after returning to sigsetjmp().
>>
>> Also, memory_failure() sets PG_hwpoison before several recovery paths that
>> can return an error, so a failed injection return does not prove that the
>> page was not poisoned.
>>
>> Maybe renaming triggered to injection_attempted is more precise here.
> 
> Yes, that would make it clearer. + adding a comment that we want to cleanup even
> when injection was attempted, but failed.

self->triggered indicates whether the memory failure injection has been performed,
and it has the same meaning as injection_attempted. However, injection_attempted is
indeed clearer. So this change makes sense to me.

Thanks both.
.



