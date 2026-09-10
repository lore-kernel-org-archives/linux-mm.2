Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44B4AC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 12:12:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D3D56B0092; Thu, 10 Sep 2026 08:12:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 383596B0095; Thu, 10 Sep 2026 08:12:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2733B6B009D; Thu, 10 Sep 2026 08:12:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 060C46B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:12:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 379961A04E3
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:12:29 +0000 (UTC)
X-FDA: 85197740418.06.9F8BE81
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 37FC7100003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:12:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sHhJordf;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789042347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gXu4m3gDzx7ypk7jhgtSGQsaUhJfQXmgs1ehgxJPhuY=;
	b=7eDmlRuTaoDgHLjP1JhFGF10JiSDBBecttUIrH6/AFklOrWhRKY1N0PzGcgh1lKupfliHF
	ZjlG3XVlwQkFW0u2IH2Y5UGBzjTYM0EQfS5zoBYMJaNNun905BhWn28FFJfCHiVfcI2cem
	Ajb7xPfKQ8dNgeFP5e5yo/X1nJWFNTY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789042347;
	b=YFg+K50PHY2m4cUkr6P8ZMq0ToO75NhdQzgmsWsrzodNs7hch1YO19zxxvwNKnPaWSqbsw
	iF7bSkMYCKfbuivRPwqaw3j+Q+RN/26f+52L/sjZncXaraqAttVPwYrHVKU6SBdBdQp3ki
	AnmKimKky+5FS6gqnzVjNgQjFXeVwKg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sHhJordf;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6D321153B;
	Thu, 10 Sep 2026 05:12:22 -0700 (PDT)
Received: from [10.2.198.93] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7647A3F7B4;
	Thu, 10 Sep 2026 05:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789042346; bh=LFgg9NvNbLg0JHItMJrXrnYTc2H0SFmt0xaGwrerxvo=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=sHhJordf19MingqIsOLLBqUEPjFQkoeNghwwf0m49YNNGCU5Cj68L681KYb2uV5p6
	 t0nq02vgM486v9GheUTxY4bQMRaTuMX7cNPWSSQtH1Aya7HHmGyI7ZkWzusq/GtwCh
	 5LC1YO8K67r2RaN1iKKVBKBv6aat47ZazF/PcHGo=
Message-ID: <8936784e-9ccb-4c33-9b30-f99552e10f87@arm.com>
Date: Thu, 10 Sep 2026 13:12:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Sarthak Sharma <sarthak.sharma@arm.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [patch 0/3] lib: add synthetic MM benchmarks
To: David Rientjes <rientjes@google.com>
References: <d6787a7f-3213-2b2c-2de5-af3b02daa21f@google.com>
 <cec6f48d-8857-49d6-a24d-b072482bf0c8@kernel.org>
 <c76621a4-cc8c-b6a7-732f-633d372477ff@google.com>
 <707b26ac-7f73-430a-a473-cd3409c4505c@kernel.org>
Content-Language: en-US
From: Usama Anjum <usama.anjum@arm.com>
In-Reply-To: <707b26ac-7f73-430a-a473-cd3409c4505c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 37FC7100003
X-Stat-Signature: miaad35wfjdgf9ppk34npq4oafbn5y6w
X-HE-Tag: 1789042347-512454
X-HE-Meta: U2FsdGVkX1+mrGffuQd1ItkkRAxV1YB3E187sCkvy0KHWVH8Agnk3KKWdfnCehQ96z7TbnlRwT5PaoxKkTFkA6Bd9Pu5dKbu/kSJxHostF83WQhBpRADcUZLCO5uIHhyjTsmewejuXWNApurE0qv2fCmH1k72DyJE2xGMZWfHB6Zm/sgHIhqu0yDSeURnfiNP69FNqTq1sXFkv4w5a+ja9p3j2589Ld/fWXFUGAH63o+73hSSO5O0XmAvB+YikkVveYqPN/8vDQpP+JVQzlh2zYtqkKPneWVD2SjL3UrEMxOXq0vRKghFwpnrncq004+B4HBSV81wiPpeojwnmLvMGSo7Ik+rjG8HZ35maKuoFzy5gM1St3/DgQNyR/7QmBf/9+2issSjCtIpRGIv+mss5K+NdXX4u64rSli8B3ozPEGdV1d+XMv/b0H0B/0rw2vPQiNdeYmjwVhALyNj6v+NMumSa3TmssfxyvLtuP9un1L6a2v0gsm5bh+B180ncq+ctp8c1qfLIHGW3zTUeGerygxQ+qiAo6Pcyeh2x9NeWi0i4x0vTKHHL+Z4KdWsGJXd7fUmBw7ZVzRr2VTc2Jc4p9elSgXro+S0A91pPiEzEaX/3oIf6l1/DNXQbiv0P9ImxG1xLogYnHXuQOjjgl6wHZP09JN9sR3tlGkGzFAMruWiY3C4iTIW0rLDnya7tO57ABUeGE4wLkrsf25sr8Mod4ai8pDbc+QVWF+Tc1ucHiuFudpdgfMP4oixvoAyLm+LDmySRkdgZsd8b46Dwng6xGDC1da9TgcI2zpvWTsGBsXQFgbynybOu3UA79Zq4HDOZi5RZ/OwbPh8HJkJqGLe7XZVpgyez1uA8xZMIiUASahC2gfd2kOtftmuVmr4wYiLgAgtH436F7/jCQf0+JkOoUZAfs2J2gaGfSTvsY2lJHi9bPYCgao2U5U9S387ddedEEvwjUAwwitX+gk6Lu
 8emNl3SY
 jguFpU1WkLrwXZ3+OxrPAccLDSryLrgyEpuTE0fov5gQLSn8h/Hski7HtuVJ8N8NSSXSdmT6vqt7yoDT8or2m0Y2bYzajRX5M3Sxa5TzZdNfFnTmooZ3pw96tev9tF8SxgDeHodx7+3kigIDnyX5kyr6OaM12MJ7ufHY+cL+UkeeG/I30u4ZJRRDfS/uG7iLnOuaQIZvfZioZtadGKxVcbLyoOrn09M6VsA5OQlSRAKiAf9o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/09/2026 10:38 am, David Hildenbrand (Arm) wrote:
> On 8/3/26 00:19, David Rientjes wrote:
>> On Fri, 31 Jul 2026, David Hildenbrand (Arm) wrote:
>>
>>> On 7/31/26 06:26, David Rientjes wrote:
>>>> A blast to the past :)
>>>>
>>>
>>> :)
>>>
>>>> We've been carrying these synthetic benchmarks in our kernel tree since 
>>>> 2009 because they've been helpful to identify regressions in hot paths, as 
>>>> well as quantifying any improvements that have been made for new changes.  
>>>> Hopefully they can be useful to others as well.
>>>>
>>>> The synthetic benchmarks are run by loading the module at runtime.  The 
>>>> modprobe will fail intentionally so that the module gets insta-unloaded.  
>>>> The test results are emitted to the kernel log.
>>>
>>>
>>> Ideally we'd have an easy way to actually use them in autoamtic tests.
>>>
>>> E.g., loading fails -> error, loading works -> no error (and unload)
>>>
>>>>
>>>> Proposed with permission from Christoph.
>>>> ---
>>>>  lib/Kconfig.debug    |  30 ++++
>>>>  lib/Makefile         |   3 +
>>>>  lib/test_pagealloc.c | 337 ++++++++++++++++++++++++++++++++++++++
>>>>  lib/test_slab.c      | 375 +++++++++++++++++++++++++++++++++++++++++++
>>>>  lib/test_vmstat.c    |  95 +++++++++++
>>>>  5 files changed, 840 insertions(+)
>>>>  create mode 100644 lib/test_pagealloc.c
>>>>  create mode 100644 lib/test_slab.c
>>>>  create mode 100644 lib/test_vmstat.c
>>>
>>> This looks similar to tools/testing/selftests/mm/test_vmalloc.sh and friends,
>>> that can actually be executed as part of our selftests and do a modprobe.
>>>
>>> Can we have similar scripts to execute them?
>>>
>>
>> Thanks for looking at these tests!
>>
>> Good call, I agree these could be loaded with a wrapper similar to 
>> test_vmalloc.sh.
>>
>> All three of these tests don't take module parameters (yet?) so right now 
>> this wrapper would just do the equivalent of check_test_requirements(), 
>> usage(), and run_test() where we'd pass in a single option for now, 
>> "performance".
>>
>>> But I also wonder if these test modules could be placed then in
>>> tools/testing/selftests/mm/ instead (or some subdirectory for test modules).
>>>
>>
>> I thought about the same and just followed what appears to be the standard 
>> convention (like test_vmalloc above) for lib/ for now.  If they should all 
>> be moved under tools/ somewhere, perhaps we handle that in a separate 
>> series?
> 
> Yes. lib/ is just absolutely the wrong place for that.
> 
> Maybe lib/tests/mm
> 
> But then, I wonder if they could just be somewhere in tests/ directly ...
> 
> Anyhow, it was also raised whether some of these could be written as kunit
> tests. It's been a long time since I worked on these, so just mentioning it.

I also think it would be best to try to add them as kunit. I'm not exactly sure if
kunit would accept such benchmark kind of code. Some research is required there.

Thanks,
Usama


