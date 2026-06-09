Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C4EBCD8C92
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 12:59:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7F5B6B008A; Tue,  9 Jun 2026 08:59:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A575A6B0092; Tue,  9 Jun 2026 08:59:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91F816B0093; Tue,  9 Jun 2026 08:59:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 826066B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:59:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 46B52164AC1
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 12:59:44 +0000 (UTC)
X-FDA: 84860381088.23.E74A9B2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 750D418000A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 12:59:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J+U2e8kT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781009982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4w956L4EhR0QlZHP3ZI2+HoYF1hO6iuotkeOW/qWa8o=;
	b=rJBBz50Ok/Hmv7BYZDP+UgJccGuxy9Tc1BvoX1ZJGRvQcZr6PBebuVju0AHB+Sq/Nnifin
	wNdn/afjpEJW1wWlahpwhLKkIubamsqL2aBhMCzGilUwevu8oO2cv1rRfmtYro4FaLTsKa
	5/xmz94Wm1DzQXEztd3SIlEp88nK9L0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J+U2e8kT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781009982;
	b=407XKHJGeaObg6t05e58xZi5m7c+M4JdJ/KkGZCRK0477AIk+a/rGG4AJBRpoWIpVvRZ0N
	a60gJO8HtgwZ+DEnvUGJA2S9qPgAxQOFJhpwG19+9YJh6KVsBrv7FPYeNv+JKlH6yp1oSY
	KzOx5AkRilcWDg2A7jE9Qg2M1EbZHI4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 00BE8601D6;
	Tue,  9 Jun 2026 12:59:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C901F00893;
	Tue,  9 Jun 2026 12:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781009981;
	bh=4w956L4EhR0QlZHP3ZI2+HoYF1hO6iuotkeOW/qWa8o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=J+U2e8kT9BYiBG+FapB4TOMQjAdnkPeYBWJ8i9g/qghLw1NgV/iMSxiPAZ0WuVLhZ
	 fial1QCXeMyNJ1DwplSFrrdCqAVEeoNMz9SAknqE9czp4JRMQZlG7gPBicTakhXyYQ
	 Obx5yaMgbp2NuBoZoJm8YGxnP2QaV4XEFCl6cZtRyq+fWvDqaVBzMofAGGne7zrHkJ
	 jO5duelZY/kLy9X32rFOWZiLdi6F11K58SCvQuxDkcqTYkQpF2vH17LYCxoc3hBa6N
	 Tquq+wRPRXtbIr6xzfFuvDdvmUPW5g9+VKgjpXYyU4SKo6HLX2NXdpgvVZZfZmmFLW
	 BtUqGbdSQOKNw==
Message-ID: <c3e5a184-6e4b-48e9-abb8-1ee73dce37e3@kernel.org>
Date: Tue, 9 Jun 2026 14:59:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v1 2/3] mm/migrate.c: Prevent folio splitting
 from interacting with KSM
To: Nico Pache <npache@redhat.com>, xu.xin16@zte.com.cn
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, usamaarif642@gmail.com,
 yuzhao@google.com, aarcange@redhat.com, akpm@linux-foundation.org,
 chengming.zhou@linux.dev, ljs@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com
References: <20260609114619.144416-3-npache@redhat.com>
 <20260609201202615oT6yd_LtIoKkGLksFaCha@zte.com.cn>
 <CAA1CXcDv8uXN_yZgCqbGUJ4LG-kxFMv1P0yz5exMMAyfUS6N_w@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAA1CXcDv8uXN_yZgCqbGUJ4LG-kxFMv1P0yz5exMMAyfUS6N_w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 750D418000A
X-Rspam-User: 
X-Stat-Signature: j6je3cyd7pnjyzanq7eaxkxqd85hftyn
X-Rspamd-Server: rspam09
X-HE-Tag: 1781009982-808997
X-HE-Meta: U2FsdGVkX1+Q39pl6s0S1A1YbH8wbJ7rwYVd+yF15SD9RFTvE1EPTH/WBjJkqMXZCrT2N8mIe78VkJQAmzZYCFj2KIs48jJnV9wLYcA0OeVwJwNJpz93la1oVSqDKhjn2nwqW2utFxVoGZXUyJRZB3H6OjUSbUnKNwe4sqH/v6RDJyOfB1heXAzrBGvxeHqF7aT69+uefZr1G4X1UaZtYUroO62CsxpgH98mdNk+bdAuCuP3wiisBCzmXgxPFSFuPN1l2cUUGQwjcS1jw4SOfre/Y96er0KUStzmZ/UXIlTx8wt0SEkbvRMPbwhPm14fNtQRP+Y7vV+SuZiXlEnZmbPjWhZSMjJEF57bWIXGP5m7TYz7w2P4dknvqiyqG8B2R1rion7AskGQFGgbZRB7e8BaG/F2rQP1y+K9/w/W+OJR8D1SmvY4vRaDJnRtmP+4RAT52lbl1a+JtwHAMUszfFnRR7AhDaRcEFbrKSvqm/GaOhT47fiEHv3hZlfig5ngN6DZmUUMss8HvFmBOj1qATJOxb1q9YdZ92JyYRyZxywu++fhM6uXh3/6ZdZxGa13YJgdG4BzmI2Yt1vACHRqOYxxg4o1oaKEbbHwmYzB+/pcHOZYpBdEtc5KsFg6akmdTxcFDKwH3Zp3pJL8/Biu6gy/LL26T9NdJbWyd5tjprP3A00bDd1U9UfjOMUJqbMMRRnfixwwt1LxXtoxc62/XqraZk9tKcA/Q2zgEJ++qJ1dFfsckX/7Il3sQfTglyw8tDMGfmO4w4lIgI+TpEthp4lDu9I9E6pC6KBEsXbW29WWXaD5K7UrvgM8O6MTQaKiFna1DplFv/CmePY5vftzp6cUEhUUiOzeJqVrU6OVogmb1sGgqTg5Jc6abava6DGR4ixsO8wesM89HPOz1WHivstGWxNv6MymyGIkBhhL/qFArMhIbT7ipFbw++RT3t/6+66yowgvVYTcvz8/Uyf
 Z2p6PZNG
 guzTv81yijdF17Ss6JDm07PnyhQzIIcVpu+mNeULhTFDZCVrieL19M2e2UmWCq5BT8nYMlcErOaoHpmT/aFUOwhAw//JY7JV64B9fYunMrUzeVukdo4v57PJIusP4kGPD38eJEobEI1M+HHGArRw+ZFtaIlT/XJm7hrvo+mcHflSASDv49jy/DwdtpIN9bwGiBzhBUWU46NOAKupkRZEIs6lh97AbaduN+izC3rz6DqpOhjb1TUNczLRLlZGfurdQEkWE+RZEokDEcL1KCfNwV63T2TZImdn/rrX6UUrxnFc325I/mv5tHssn3Kmt3j++u/wT+1ZEJz7qiYHIiFZDtl7NDVWkhx8l7BAChNqd2l/ntF6CDW86/8VCIPtvX95j2HZftRrx+a792AmaTDON3PM3SyUIHQw/9dwcoTRFQ2Qni4isIGqGa9HBolxsi2714big
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 14:57, Nico Pache wrote:
> On Tue, Jun 9, 2026 at 6:12 AM <xu.xin16@zte.com.cn> wrote:
>>
>>> Since commit b1f202060afe ("mm: remap unused subpages to shared zeropage
>>> when splitting isolated thp"), splitting an anonymous THP remaps all
>>> zero-filled subpages to the shared zeropage via TTU_USE_SHARED_ZEROPAGE.
>>> This flag is set unconditionally for every anonymous folio split,
>>> including splits triggered by KSM.
>>>
>>> When KSM is enabled with THP=always, this causes two regressions:
>>>
>>> 1. use_zero_pages=1: KSM calls try_to_merge_one_page() which triggers
>>>   split_huge_page(). The split remaps all 512 zero-filled subpages to
>>>   the shared zeropage at once, freeing the entire 2MB THP when KSM only
>>>   intended to process a single 4KB page. This bypasses KSM's
>>>   pages_to_scan rate limiting, causing ~1GB to be freed almost
>>>   instantly.
>>>
>>
>> Why do you see it as regressions?
> 
> Since the zero-page remapping was introduced our test has shown the
> following behavior changes:
> 
> With use_zero_pages=0, the merge rate drops from 60MB/s to ~6 MB/s
> even after raising pages_to_scan. The KSM merging is now much slower
> and CPU utilization has increased.
> 
> With use_zero_pages=1, ~1 GB is freed almost instantly, and it no
> longer respects the pages_to_scan behavior.
> 
> Even with just this patch (1 & 2) or the RFC linked in the cover
> letter, the issue no longer occurs.
> 
>>
>> AFAIU, KSM and THP do often conflict with each other. THP tries hard to collapse
>> a huge page (which may contain many zero pages). If KSM is enabled and part of
>> that huge page is mergeable, it can easily be split by KSM, rendering THP's
>> efforts futile.
>>
>> Therefore, in our actual production environment, we typically avoid making the
>> same region both KSM mergeable and THP always.
> 
> THP=always is a global setting used in many production environments,
> so these features now interact very poorly together.

Red Hat documents, though, that both things in combination are shaky:

"As KSM can reduce the occurrence of transparent huge pages, you may want to
disable it before enabling THP." [1]

(for RHEL 6, but nothing should have changed in that regard)

But yeah, having KSM and THP enabled at the same time is not uncommon.

[1]
https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/6/html/virtualization_tuning_and_optimization_guide/sect-virtualization_tuning_optimization_guide-memory-huge_pages

-- 
Cheers,

David

