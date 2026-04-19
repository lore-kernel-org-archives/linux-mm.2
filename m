Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55B1CEA7192
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 08:12:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FC756B02FB; Sun, 19 Apr 2026 04:12:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AD9E6B02FC; Sun, 19 Apr 2026 04:12:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19C586B02FD; Sun, 19 Apr 2026 04:12:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0B2196B02FB
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 04:12:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 977D613B77D
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 08:12:34 +0000 (UTC)
X-FDA: 84674588628.05.F80774E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id B2D1640007
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 08:12:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KF9lgz0L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776586352; a=rsa-sha256;
	cv=none;
	b=d0e2lnohV6jGZPLBLV/AXDD75jOuc+1xSX1M/fFZNv7YL5lU0cssNNUCSjTYtYYm7Ya1nv
	HeYTrosIJ4cqonYqH2+ias3GQRMUu/zgxE3sVa9v2tTzj4Z3AkeQcg2ZCvvKUf+1sSFtF9
	cGB5EMpnKRzyjilqF7KObTCoQjAVXJY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KF9lgz0L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776586352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mfjhiCbP/Jj8FjbSI/ahsoc3qMsGWjRLS7m0J89wN2Y=;
	b=s1GYeHAo5/pDtN8H7J3ru7yHP+Z38NcT9z2Xdb+h3bflZDQNgNPKJohRz3oEOIPQHY3XTj
	UJSuKZ299RvGdaJlFQOMe7rU7CUijMxR6k5RvYzfaOz9hWnetvzPrhSrAShMBz+ujRAWHv
	HAL24URJsXPdX8YpdT9u/ZWCAXYo3tg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4FC9642A91;
	Sun, 19 Apr 2026 08:12:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5BBEC2BCAF;
	Sun, 19 Apr 2026 08:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776586351;
	bh=ig7jvjkZ1QbRCAw8nCdys/c48+Ls8Xu4gg+weYKcuIk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KF9lgz0LZGMXEnJIcgltyWgzbLX4A9odPYqujzVbciAfTyZweVjXlmVQRV8J8VjFk
	 jJW6B2mIlb/YrSeo0eKYKQFebKATSh2h0GOvPyuXrsXeKaimXRwqLJaU9CTP0EFequ
	 Gw8/FEHQrxkPQGI7mu/4Q+fC8q0LgYcYer2WrSC/r9l7hL5hRLXWY8N4obXN234T+7
	 vJGo0jBx61PAjWJx8mSFMAmDm5AwlKHMG5CZ2TcenCoC4wTX5ZQaTZneEpwhtTn650
	 XLM50Nw/DYke8Gu6z1yFfF2Tq0CVB+r4F2sXSfXRDybq1qLjtVLkenndZoTpYI21Cn
	 eiHE5fpKT5bMA==
Message-ID: <c4355c68-4c23-404e-9368-7120f6467ad4@kernel.org>
Date: Sun, 19 Apr 2026 10:12:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate_device: Cleanup up PMD Checks and warnings
To: Sunny Patel <nueralspacetech@gmail.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com,
 gourry@gourry.net, joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, matthew.brost@intel.com, rakie.kim@sk.com,
 sj@kernel.org, ying.huang@linux.alibaba.com, ziy@nvidia.com
References: <82193ab8-e6f6-4664-8b4f-e30d280d8b1c@kernel.org>
 <20260418171806.11615-1-nueralspacetech@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260418171806.11615-1-nueralspacetech@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B2D1640007
X-Rspamd-Server: rspam12
X-Stat-Signature: ugnehawfz8strwuf86ku4h7s1eajbsgn
X-Rspam-User: 
X-HE-Tag: 1776586352-595919
X-HE-Meta: U2FsdGVkX192OXGjNYZhkKHBl/tsz9IwbycVCNTOHeCIPlbPuxrx+SvCaC/pt23ZyLMBJFDDaSakp5R1XcYHjy/VmQCiBiaSY5Bvh8KrXM4jkzrj1c8s1VrVjEgFK/GU2zsTRf5QnZOMgDzirwSenCxfDax1ez3n2Z+kPq+XeySGZHajMmbXyEd3VxkuIWarDYbvEUA0m64PgQwkUEDJ4O9HUe+iD6Zcnb5ihVCfu47RWeSXCUw5+fuxjh3wTvuFdXds8IKXYo4lHpc2H1zL0ZYMZaYmbGnyZgQwcIA0XF7Ps2cf/JCqQOV2gJEeR1+HmvzD7UlWOY802qENbdglWoGeBj0y7xeRviipL5zRG20kyOVwj+e/JPrU4bq99Svi5pPhQlqPyGyeyaMteexGYmiu65O/p/qz3magsieI9ic0VbnTVrDwbCp3ICTgubgI9y29jEuVOQvUpBjfsmwVOOEkl90sQrCeyDy3EBxLe1UJ/j9onA/2JGuu5XxVBvzVnzu4fWeT4Ck4LHACKcyk7mMpdUCxpEyHB15DtM5wbioeWIQiFDgI4w8JeE6RkIs1JWI9vdg1UGbQEmjJOSG5L/5yYHDn6NHi4EqC0ienzGidXU7l/wpSY4KgrFJTwoL6LK1gQ60dr+K4Fje58PSrWHqfOwQdgRcRFTolQfuNMyItirHvKutCoSGL6fgBw1zhjWVVj6dbPOQDJN3IPMQlGeI/JvwxqSM4GdM0IYEwyRtq0Huwah1M3143v0pqQSlVVQXtm5pBIkPRW4m0eBtWGPpF6BRDJWhN18cS7Rlw+5aTHJFacP4fut8az9iKmDnOcSG8MGjcNUvyFWQC8P00pvTQjFqoT2KPcrlgbU3uRzTB1FDD1rsq91kA94M46npxtyWkHgXxlALJt3NGWEuHFjsF95jBka5YQGZ6VOzbaVWD/uU4SUJPKSs7bAV7RmQxNFVXrxqVWjWt98HTmyL
 dBIigj/K
 aRAAbcCR6jLT2e3nwG5ucEqAH+b8WiA4oOUmTuQdT6getTVRP7R5gcXtgqxBoEAQAxPKSJrgsPn/RZMU/oaKrhZz9kUvMNTqrYhvwZzfj4yCEfzp5NFhGy+O4iReDQBNBl6mprfTCpO8Ci5Ubm64Ptg6hhsTkd2zN1qPPT8oMeKP4gTKWsdsgQ30/toI8MD/dyYN/VjHmQONr86bRQKjNcmDkm8YpzMJpYiMW5ZStkPfDRJABHvGhVeZXAOPw03o9Dnp9GC5oh/x5QCRqoM6tm2tzq3dou33pQwxAWdmhy8nXpOWE7G/28bQrNlC2BeQyE4rSXJgvtT2A2NAlVo8f5TgV+lla9/9kOL8cp9+mcFiBuX8FhUJG9xmf+E+SfzI3v7Qu2i7CL1MkaJsbETd/n1hFOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/18/26 19:18, Sunny Patel wrote:
> On 4/17/26 01:52, SeongJae Park wrote:
>> On Thu, 16 Apr 2026 21:44:15 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
>>
>> [...]
>>>
>>> is_huge_zero_pmd() checks pmd_present(), so we didn't have a bug before.
>>>
>>> We could also do:
>>>
>>> if (is_huge_zero_pmd(*pmdp)) {
>>> 	flush = true;
>>> } else if (!pmd_none(*pmdp)) {
>>> 	goto unlock_abort;
>>> }
>>
>> Then we could even further remove the braces and reduce one more line, nice!
> 
> is_huge_zero_pmd() didn't check for pmd_present as of now as per the current implementation of it so additional check require for pmd_present().

I don't know what you mean. Here is the code in the tree:
static inline bool is_huge_zero_pmd(pmd_t pmd)
{
	return pmd_present(pmd) && is_huge_zero_pfn(pmd_pfn(pmd));
}

-- 
Cheers,

David

