Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B03FCFD376
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 10:51:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DFEB6B009B; Tue,  2 Dec 2025 05:51:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 590D06B009F; Tue,  2 Dec 2025 05:51:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CDA36B00A0; Tue,  2 Dec 2025 05:51:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3DF5B6B009B
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 05:51:07 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F0B0812DDF
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:51:06 +0000 (UTC)
X-FDA: 84174213732.07.D2A8CFE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7C3EC4000D
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:51:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NCd1yM3Q;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764672665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6vn8qoClqdZtr3fRSmEswq/ozA+0NVPjVY/g5YOcdSA=;
	b=UARzq6eyNEM++RG0S7DqUesXfgpOfbbJO1FBws3iM8dGkqldJg6X8BnSWWAjEo2K2Gwawf
	5kn/Pay7jevjo2TR/UzxANWyUdLbj73DgOOEfa7RbfpuR006ogDpjUCkXtazXh6HtLqCuv
	XgwfcYKi+NMsRIxPDBqzCK73Si52t14=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NCd1yM3Q;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764672665; a=rsa-sha256;
	cv=none;
	b=1E0gpJEWUx5A4YGqhrpXeJ/zkr6aenfXHscma5IOVWmCnM125KYRk5ZMj2XRD002BuVkdw
	DgS6BOIyNpsVVWhh8wljC0EZttN+2PHpLG8HyU9+WvQYvYfAoNGrfVoB81CZOK+cIPQkrR
	tZJFe5rGNCmIhRRvQr9sjWKVRajXlBU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CEAD960017;
	Tue,  2 Dec 2025 10:51:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A24C4CEF1;
	Tue,  2 Dec 2025 10:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764672664;
	bh=90lsWaeNJmpMVHdssqjw9Hi4PwEk2F90+PBNDk6Ln24=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NCd1yM3QoEVUBJvgqQR9JjnTFRw7YOqbY8JftMXSCPIAjP1JzutD8fI+aGoFbyXa2
	 uL/st5oZOvI9/JX8mV1aGH4jcxIErmiD7jxpZsR3aCV4617Sge2CRLRngHqzqZe2nZ
	 AgBGTgL32+QvlzfbKZuqpLllgQtPJaLtkn/eV+QucHBIUXv3JMCUG3mug9ktUUxkM6
	 mqKhgM2YCEWjJrMn3ryjFlD5/D6YAHM/l7J6cvR0PGahskkDw2OgWlty5bZkZVQZFk
	 jfHr+ZbMFghUim+228H6Itwr4T6oZUyxWDOmvFXHE2srizLrJehWy/ei0kXYvKXBwI
	 EI58493AYr7SQ==
Message-ID: <2149802c-b7cd-430c-8af0-99d26b0b7330@kernel.org>
Date: Tue, 2 Dec 2025 11:51:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 04/10] drivers: i915 selftest: use pgtable_has_pmd_leaves()
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <cover.1762464515.git.luizcap@redhat.com>
 <297c6fa3dfc50c28c05c0974c86a205984d752ed.1762464515.git.luizcap@redhat.com>
 <8c745e54-1cb1-44d4-abc3-00e6511cf67c@kernel.org>
 <21386400-9a67-4fcf-b686-1e7c9678d123@redhat.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <21386400-9a67-4fcf-b686-1e7c9678d123@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7C3EC4000D
X-Stat-Signature: snb1t857uwobaru4shpoutf94zyp83gk
X-Rspam-User: 
X-HE-Tag: 1764672665-20186
X-HE-Meta: U2FsdGVkX1/RSSfQUE+qQkVYZlb+eyhJdLFN4Ci8xSQ/w6ccCnwvfcgy5Ts2WTNRjc0SDmRAX+tNBf2WfHc42BllS4LIqpJxuaE0hlCG5lzc2ntB8E9Z38E50ETMsx7K0s9bHIt5w9bKW5aHOBAo71RL7R5PRDLkrqkoKxxwllgvzNuDw17JwPnHHB90V079X9PpdPZErWA6OA/v54apP77VKrdiWJdHi1mKiGXa4+y6R0+He2pnxdzeNL/Uq9mCCVxrkCmBBBU5YiWB/SvfQtT2R+xtsI+XlwQjGBpR/BC9Q8eAtorbSO1jICt7qNRBvygarSZLW1TjhNke65rBGRxdIod12J37SjVLPAYt5q1+uc0bnXsmOr1pZ68BLemjXvvINPtRxlDpjCdPY8K7Y83Fy1x1RIWhmfE6iq4D7t+LmKRTmoZHFf9IHuC2pAiOyGzumUsPVHJKRUpHbmANK9uYlh3JmwK3g6Bvh78JD3IddbNhA5Qt5/GWzB3Tsu8+/E4haKlShroNNry1NCBsUCtv49lcbpUuxbFb3a78Hx7S4/KP1ihaWz3k6gvGT5L50tAW63sNqj41SYQZ4nagrAHMKSJDUNcgj15Xg09RmyTEa7E4rv4S4gUnr5zTFbbEMITwJY3/QzN6yj7JYiQVFl4XLRcBy9CGb5aJjlVlHCxsSz/9K8nn1n8VtLASs5Fx3Y72hh+fZZbYMjT/MqKZ56/At3Pa5IvWxF7vmwBKFXtrhCYmlBh4avrxxVQjPOXTj/EabCc39WZqO88Ole2EYbpZ7dEjwbcc6ZaRrBN+0e5xMhCuiHUYhulet+FjW+SLH94KJkXOIZRo8STtTLGnsfWwfhnxfzuHUvhgQpj59L83hklnB9e8g3tZVZgbmdH+rk/Qj09+zrIoCxOXQEpmFyQ5mlG8phdUBesQjo0U+TLXhbV++99XQAvEbH/4ttdI/jlw+dL9RN5x4KGTVcm
 6hP5363J
 LFT+P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/17/25 19:55, Luiz Capitulino wrote:
> On 2025-11-17 12:30, David Hildenbrand (Red Hat) wrote:
>> On 06.11.25 22:28, Luiz Capitulino wrote:
>>> igt_can_allocate_thp() uses has_transparente_hugepage() to check if
>>> PMD-sized pages are supported, use pgtable_has_pmd_leaves() instead.
>>>
>>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>>> ---
>>>    drivers/gpu/drm/i915/gem/selftests/huge_pages.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
>>> index bd08605a1611..c76aafa36d2b 100644
>>> --- a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
>>> +++ b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
>>> @@ -1316,7 +1316,7 @@ typedef struct drm_i915_gem_object *
>>>    static inline bool igt_can_allocate_thp(struct drm_i915_private *i915)
>>>    {
>>> -    return i915->mm.gemfs && has_transparent_hugepage();
>>> +    return i915->mm.gemfs && pgtable_has_pmd_leaves();
>>
>> On second thought, is it problematic that we might be losing the CONFIG_TRANSPARENT_HUGEPAGE check? Should we check for that separately?
> 
> That's a good point.
> 
> In this RFC, pgtable_has_pmd_leaves() should be functionally equivalent
> to has_transparent_hugepage() so I think we're good. That beind said, I
> also think that we should disentangle pgtable_has_pmd_leaves() from THP
> now or in the future. When we do this the breakage you're spotting will
> happen.
> 
> What about adding thp_has_pmd_support() which does:
> 
>     return IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && pgtable_has_pmd_leaves();
> 
> Then I can convert all the cases you spotted to thp_has_pmd_support().

I hope we can avoid such a wrapper for the time being. Maybe we can just 
keep pgtable_has_pmd_leaves() glued to CONFIG_TRANSPARENT_HUGEPAGE for 
now, and leave untangling that for the next cleanup?

-- 
Cheers

David

