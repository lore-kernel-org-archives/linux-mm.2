Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D3DDF34C5C
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 15:45:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB1A86B0096; Mon, 13 Apr 2026 11:45:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3B316B0098; Mon, 13 Apr 2026 11:45:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADBDC6B0099; Mon, 13 Apr 2026 11:45:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9C77B6B0096
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:45:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2B23A1A023F
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:45:37 +0000 (UTC)
X-FDA: 84653957514.20.74FD6C8
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2CEE320013
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:45:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cLPw9ob1;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cLPw9ob1;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776095135; a=rsa-sha256;
	cv=none;
	b=kJW7HGw1ovqO14q48t3weLyudU3yYHNEBwK/v9c3MRdQshSj+ji1gZwPlBFjwEigfZgFir
	qBQuFLjom+wY6IN3+V705iaf5zxoKjgmtFrU3i/P5UiX5Z9KAE0XwySckvNERwMq4avDfZ
	E5QQkcPkdkRlytJ2LhAx6fJbr9oPWVo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776095135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ys8CmhQ7tTcwE6cYI4Tke5lYbAx5Yj85GkT45RjDRjA=;
	b=Vy3WD9q6oXlEUPzF1NsjOMIBigExeJRG3leLyVtZz0PG9YcDzrIqt8aEVkPaSpoKeGEu2N
	yLaOwQEAJpvHhBe0ncC1H0V12yio7QZnpgJFzcFq48Id4M6WN2iELcxGd/FbMSnZMsI7le
	aobiwfm7vaLDuSifqd2OdpcZ08+wvgc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776095132;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ys8CmhQ7tTcwE6cYI4Tke5lYbAx5Yj85GkT45RjDRjA=;
	b=cLPw9ob1rZg8ye/toE5dQC6l55rDaUW+JG6LxMA9Khl6/hzAO1XFwO9ADSskcRb4u6of9N
	xd2ZPo566poANe/pzSrmGxHvs4WQyYtQtpkmZUALLbFz8bHBo+PbsWkPl0uKVrU7pXzQTZ
	8X/kMHUYIJQUd1hxS7sXiFdTlrMK1aM=
From: Lance Yang <lance.yang@linux.dev>
To: luizcap@redhat.com
Cc: lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	dev.jain@arm.com,
	baohua@kernel.org
Subject: Re: [PATCH v3 02/10] mm: introduce pgtable_has_pmd_leaves()
Date: Mon, 13 Apr 2026 23:45:14 +0800
Message-Id: <20260413154514.94193-1-lance.yang@linux.dev>
In-Reply-To: <119dfe3d-4cfd-46e3-a539-8ac9af90f940@redhat.com>
References: <119dfe3d-4cfd-46e3-a539-8ac9af90f940@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2CEE320013
X-Stat-Signature: 8ba3o6xtx51zczztpawtes7mtx4xf1qw
X-Rspam-User: 
X-HE-Tag: 1776095134-636340
X-HE-Meta: U2FsdGVkX1+lhfNmJArUp1Ahv45AtIrfJP+U7OiLAXaDCMjZUAUNsfENS2wAIs66Y8A7LcZqEAh/B2b4g1T6f6dDR+GJGbSPT2FheeQxbzP9HcSfYeh8KaHxUcq11JUtBl8lEuj0umskXZejH85GWFphdBy9+xs1T7Hw4C3xAlUGnZMeDfmDOsu4A20ZRa5B83/0Q8JT74KjsKo0Z9WHuPxysVRa+UXz/bUv588Ut0D7YHNEpjfuZ0omLILHszReSzVKGyBWDckeEllGWM9e3KRRmlKTPZZrxvjYOGsJN9xu33SvyefBNp/ouD8U4tK1vvIoqS/tLXuYHJo9WGl1Pc3QLfAM19KVm2PycYrwhyMnesqk1tapFILs8Roaf9HMFl1PPZRqvzijsov4HJxWM5CWKU5H3vaMr+We/YMRc/4KRKLxJjtdT4oh9HdV0ZU4Y7mfvfwHdmItKO3LM5A7beQgHIXckuDRyG4C3x6lcpxCAUbgQC6aWPptpPuIqDURgd/gzuCarq32C4SCIQnm4ahprVp7WxwYEe+YnREfJ9V3zxMJFDSXKxJMqC8l4OFaq5g1Gnfpcwik+fh9S5dcldasZT7FBHjuaheSUD/8xpqY0uKDTQLxfMw/MrYZCDe97+uzTpzovAHL/3DzTp/kRtZL+3eGBS/RogM469L198MShKUUQypUTe1YJRrt9IaEHyvDXqcRxkcqBpvN1UEm7EyOBznLI2onxYk1SLXMVf0mHpw7WZ7rpq2Z28wZlOokoJeyMqD7PTkhVle5IZRJxaaQxvdLvBEdM66/4tX8tc2apGMlc+XYSbMb4gfIaWKYUHok2+EJosZXlyRTpgfKTROHk4jfAhz2JQ0pMzd01IPa9PwcudZJlso1Iuora11v3Dh4w5NrqXMi/6G7W2yj2waP02AITImZxcSGZz4F6v3MWwqk1SM/YnNmT2LG+GGrK4XwzK36GHfaJ8CTjh+
 5i1fD8tb
 rv3ZwKfje+x2fPimQshnRyxYlvEvhWqQ6hl19eu1azvEAuZVXyv+P9z9oIptVXHhXiH2z2+OkoZ6RyJ/QN2YgEGF0xXEyogQlI/6ONWge8AZpEGC+FQ1elBPNDu8tH9kfR06ItMVoVMiubSA5dGtHGstV9S5Fw9b+nw+uS4YOzJLpDzEFjSQSVaSC9ZLNrC4DxkelODWZLx4hNi7mFuRNdcRQACHupgGjhc4ZqOeq8cIWfmTJOgFLdyzYEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, Apr 13, 2026 at 11:24:22AM -0400, Luiz Capitulino wrote:
>On 2026-04-10 04:19, Lance Yang wrote:
>> 
>> On Wed, Apr 08, 2026 at 04:22:57PM -0400, Luiz Capitulino wrote:
>>> Currently, we have two helpers that check for PMD-sized pages but have
>>> different names and slightly different semantics:
>>>
>>> - has_transparent_hugepage(): the name suggests it checks if THP is
>>>   enabled, but when CONFIG_TRANSPARENT_HUGEPAGE=y and the architecture
>>>   implements this helper, it actually checks if the CPU supports
>>>   PMD-sized pages
>>>
>>> - thp_disabled_by_hw(): the name suggests it checks if THP is disabled
>>>   by the hardware, but it just returns a cached value acquired with
>>>   has_transparent_hugepage(). This helper is used in fast paths
>>>
>>> This commit introduces a new helper called pgtable_has_pmd_leaves()
>>> which is intended to replace both has_transparent_hugepage() and
>>> thp_disabled_by_hw(). pgtable_has_pmd_leaves() has very clear semantics:
>>> it returns true if the CPU supports PMD-sized pages and false otherwise.
>>> It always returns a cached value, so it can be used in fast paths.
>>>
>>> The new helper requires an initialization step which is performed by
>>> init_arch_has_pmd_leaves(). We call init_arch_has_pmd_leaves() early
>>> during boot in start_kernel() right after parse_early_param() but before
>>> parse_args(). This allows early_param() handlers to change CPU flags if
>>> needed (eg. parse_memopt() in x86-32) while also allowing users to use
>>> the API from __setup() handlers.
>>>
>>> The next commits will convert users of both has_transparent_hugepage()
>>> and thp_disabled_by_hw() to pgtable_has_pmd_leaves().
>>>
>>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>>> ---
>>> include/linux/pgtable.h | 15 +++++++++++++++
>>> init/main.c             |  1 +
>>> mm/memory.c             |  8 ++++++++
>>> 3 files changed, 24 insertions(+)
>>>
>>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>>> index a50df42a893f..c4c5282f795c 100644
>>> --- a/include/linux/pgtable.h
>>> +++ b/include/linux/pgtable.h
>>> @@ -2192,6 +2192,21 @@ static inline const char *pgtable_level_to_str(enum pgtable_level level)
>>> 	}
>>> }
>>>
>>> +#ifdef CONFIG_MMU
>>> +extern bool __arch_has_pmd_leaves;
>>> +static inline bool pgtable_has_pmd_leaves(void)
>>> +{
>>> +	return __arch_has_pmd_leaves;
>>> +}
>>> +void __init init_arch_has_pmd_leaves(void);
>>> +#else
>>> +static inline bool pgtable_has_pmd_leaves(void)
>>> +{
>>> +	return false;
>>> +}
>>> +static inline void __init init_arch_has_pmd_leaves(void) { }
>>> +#endif
>>> +
>>> #endif /* !__ASSEMBLY__ */
>>>
>>> #if !defined(MAX_POSSIBLE_PHYSMEM_BITS) && !defined(CONFIG_64BIT)
>>> diff --git a/init/main.c b/init/main.c
>>> index 1cb395dd94e4..07f2ddbf9677 100644
>>> --- a/init/main.c
>>> +++ b/init/main.c
>>> @@ -1044,6 +1044,7 @@ void start_kernel(void)
>>> 	print_kernel_cmdline(saved_command_line);
>>> 	/* parameters may set static keys */
>>> 	parse_early_param();
>>> +	init_arch_has_pmd_leaves();
>> 
>> One more thought here: I don't see why we need boot-time caching.
>> 
>> has_transparent_hugepage() does *not* look expensive on the common
>> archs. On x86, it is just a CPU feature check. MIPS is different, yes,
>> only the first call there is more involved ...
>
>The caching is not being introduced by this series. thp_disabled_by_hw()
>(which is used in hot paths) is checking a cached value too and this
>cached value is also set at boot-time by hugepage_init(). So, we keep
>the same behavior while extending the use of the cached value in the API
>(which makes sense for consistency).
>
>> But if we *really* want caching, couldn't we just do it lazily instead
>> of adding another early boot init step?
>> 
>> Something like:
>> 
>> bool pgtable_has_pmd_leaves(void)
>> {
>> 	static int __arch_has_pmd_leaves = -1;
>> 
>> 	if (READ_ONCE(__arch_has_pmd_leaves) < 0)
>> 		WRITE_ONCE(__arch_has_pmd_leaves, has_transparent_hugepage());
>> 
>> 	return READ_ONCE(__arch_has_pmd_leaves);
>> }
>> 
>> That would avoid depending on parse_early_param() / parse_args()
>> ordering, and it seems much simpler too :)
>> 
>> The boot-time init step looks a bit shaky to me ...
>
>I understand that caching on first access as you suggest above is an
>alternative way of doing this, but having to properly order
>initialization is very common in start_kernel(). So, unless we identify
>a case where the ordering is tricky or undoable, I don't see an issue
>with it. Also, note that this ordering exists today but it's implicity:
>thp_disabled_by_hw() can only be called after hugepage_init() runs.

Yeah, I see that, but I'm not a big fan of carrying that over into a new
generic API :)

The existing implict dependency does not really look like a good reason
to add another boot ordering assumption in start_kernel() if we can
avoid it.

I'd rather have the new helper reduce such assumption, not depend on
another init point ...

So if we want caching there, I still lean toward doing it lazily. But
let's see what folks think :)

>In terms of simplicity, look at how the resulting code (using an
>untested version of your static key suggestion) looks in comparison to
>caching at first use:
>
>DEFINE_STATIC_KEY_TRUE(__arch_has_pmd_leaves_key);
>
>static inline bool pgtable_has_pmd_leaves(void)
>{
>	return static_branch_likely(&__arch_has_pmd_leaves_key);
>}
>
>void __init init_arch_has_pmd_leaves(void)
>{
>	if (!arch_has_pmd_leaves())
>		static_branch_disable(&__arch_has_pmd_leaves_key);
>}
>
>

