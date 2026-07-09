Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6AB2C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 10:24:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEFD36B0096; Thu,  9 Jul 2026 06:24:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC7796B0098; Thu,  9 Jul 2026 06:24:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D907C6B0099; Thu,  9 Jul 2026 06:24:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B80AD6B0096
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:24:16 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 33AF9140458
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:24:16 +0000 (UTC)
X-FDA: 84968853312.03.88CBD1C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 87B4F20002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:24:14 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bU+hyQjU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783592654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wXUi9iS7a16C976jNFUWijTW73Ll9wqEqZ9JDDOWg4E=;
	b=DOGmyFAMXy+EFOEWdPr5HEYrPJhMcxjpSgSfgx7xok97n+jKS/FinHpqCQdbbDJqPtWvzb
	Zef+pkEse/iA0QaBZ8HWMO+ugoFDjvCGYQJrXvx/8AW/5qSNWE9HFZxMHEFVfCpbTZclkd
	8bncmKsjcGkBcuTxl3rK/xZQuj6NSuc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bU+hyQjU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783592654;
	b=CzUhTb/qys4LGp5T04kANtDot/npnKmKDl/fE9+ykuDF3sJSBZ4UF5NSfC302KAW/Gv4Fx
	oN43LJvXK25WSAByQqTC6znlSGoA5TSKZiBJx5nD23HKNJJ9pLh+olsMTU0mMtwADTyRxG
	rVkNo1zzozvBmMDYJTQXJG8bQg3FB+k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0766E6001A;
	Thu,  9 Jul 2026 10:24:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0613D1F000E9;
	Thu,  9 Jul 2026 10:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783592653;
	bh=wXUi9iS7a16C976jNFUWijTW73Ll9wqEqZ9JDDOWg4E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bU+hyQjU78/eOT/gfLPvhkIcfbHJkNYW1Qpj5bxGIObFpFVBuyk5ATpjhGmBPP84M
	 kiiHUy2jV+SKSBc2JOhA9XtQefGqsuvYn0ul+KMOxUiD5FmeatAuSbpMnCv6BW9yQ1
	 vZKuTUIRcD4Ru54KmWrPhorXxaAhgBS7Ipkpra2rPY7XaP3BEASlTYyWIwKDvqnZgN
	 69PqGq3gX/luCFyEdUUY/LOCYamwhFYarM9HMcrMZh29EAzPdZlIY0uIhhrOx369VQ
	 3ULeDdQn2rx7Hslq6PQjRqLMl5X491fGlpYiPiu0n7lnGjqXN5pCHeS8fK9jtdoRmw
	 RikxDgE0q4kYA==
Message-ID: <a23c0ace-b52c-4f28-9f40-d0b6dc4ca2d3@kernel.org>
Date: Thu, 9 Jul 2026 12:24:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3] mm: Standardize printing for pgtable entries
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Petr Mladek <pmladek@suse.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 usama.arif@linux.dev, hughd@google.com, willy@infradead.org,
 ryan.roberts@arm.com, Andrew Morton <akpm@linux-foundation.org>,
 linux-kernel@vger.kernel.org
References: <20260709044334.1741263-1-anshuman.khandual@arm.com>
 <ak9Qe1G7Rv3HF6ZR@ashevche-desk.local> <ak9mrw37kTORZXmc@pathway.suse.cz>
 <ak9z3ZRdRqGoOu-T@ashevche-desk.local> <ak90WW3I4tmg7Pwz@ashevche-desk.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ak90WW3I4tmg7Pwz@ashevche-desk.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 87B4F20002
X-Stat-Signature: dgkbq8g6iyxxjbs1gh8g87ux6p5iys6u
X-HE-Tag: 1783592654-692571
X-HE-Meta: U2FsdGVkX18eUd5Lr8/gGlEGu79W4GLL/m+9Ns+O7PTUUqergxeKvKmfx25pSUBITLT6ZYWYHqGlFo3snr1iGiOkBAPB2IYuyRu+GgHeK7hcnxdZWTnUVQeB0uB2nqg2arA6hYVazQOvR8gDndkxtLx5idsxrD0lJ9aYIZI54BVPdBlt5xBEN/r6Fm2YACbELS34RBXK8MwkwIPOzRAniLxq55AikV/g66/LSHeB/JjnxMQr7/MokYGESWtNTuLT3Ag9lKBpBXEGM9mg0AgaLECc93brp+iu+YhAc3wz14UQWtiXnOAamQVYc3LICTnERhQ8+T0QMURo0cZZ+pZJv1p+COTKMjxJov1hictXLLJLZjEnGMFgyLZ0CZ2WE/fLbyIerJifu4neFQDDOWqG01RSuhMH4oh15HYs1RGBRFX5yUd7FR4yHVo8mhRsMJPwBkfToSphDHiv5+Tu2aKAtwVFM3on+x6/loJ0DEGdwbidSHSNTdK9P8LLsnxTxyfh/Jta5Zr1SetLcsXaR3nb4aOc6mOVAmvXJ378L4YWhB1A94zkerAHJrNMxRVsj4HY4Q+Indl7o4HHc1vpLvlUYpcUvqnhhJGfli9Dk6oM2IA2A/j6Bs1k2NCwmJrT08a5pLmAenRTWtycpZOAHdMIlsEt8NL3tYr5fUdoxQiuex/abOSi9CPrvM1TP15bPB8LOXn/JHLmNXkLJJKwY7kEl3dp0WxJIOuuW8jjN90f3A2nJejP1rN60AibtzO4GfPopQOuyR+N5pggVX7QOykAktN8ZkbhjX19kbGv6XBF4UcGO+uBFwqCySr/rorqnghylD0bG55farTzqtsoEuYYOKUGUxMUB1JeV1YEACFXKQIhvge6maj9d3kCvzKHjWrFh+FMwnMmbg5BfqUPJiaRcHMu7EtWo2gzIHYB7sXgbo8Rt0Mydgn39JvovmrsTRU+jQY8Kz5lX+IkFm2vktg
 OTKB2ZGA
 1Mgb4b3wIGwgaYR08BQJuC1Rk+NLRDG5zARwNss/9fpkIneeteegAgo0klwB2Zk1rAy9rQ7GuuTXRhkeXywhc29JtXQiEURTxHRguz45UccUgyBBoCuztxEY4CPSwunAs3HoLCDBjOfI0iB1Nz5O6np9/2f3yvLsM2cd+3ZAhJ8e/fK9VHTWdKENotYYMBwDHZtberSNSoUpCLQqPCTDkMqJmAKgW71jgZeIA+7E8hBI9mDymhjv5xx3Ku9+DPn/t2TY8udlGvA37frkohw1WfZRBrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/9/26 12:13, Andy Shevchenko wrote:
> On Thu, Jul 09, 2026 at 01:11:46PM +0300, Andy Shevchenko wrote:
>> On Thu, Jul 09, 2026 at 11:15:27AM +0200, Petr Mladek wrote:
> 
> ...
> 
>>> But maybe you had something particular in mind.
>>
>> Yes, I was thinking of a wrapper on top of special_hex_number(). It takes size
>> as an argument and hence will work even for 128-bit cases.
> 
> Okay, the argument is limited to 64-bit in there. But I don't think it's a big
> impediment.

Rewrite number() / create a new 128bit variants to avoid 3 simple snprintf()
statements? :)

Hm ...

-- 
Cheers,

David

