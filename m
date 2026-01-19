Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFC5DCCF2D4
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 09:58:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0EC16B0159; Mon, 19 Jan 2026 04:58:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE6976B015A; Mon, 19 Jan 2026 04:58:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBE196B015B; Mon, 19 Jan 2026 04:58:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA5B66B0159
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 04:58:48 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6E620D229E
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:58:48 +0000 (UTC)
X-FDA: 84348264336.10.134060D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 93941140002
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:58:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mCTI++KS;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768816726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1k4lGFdX8lvvrhxzk5FHdPVi+xmCXgpE4qRP5xIVqT8=;
	b=xX6kTS1UvaJvmkLNivGVbqSGeivQXwnPz/JKKVE6zhvZiB71VAEi7yCVJV0lbqCZo8tuD3
	v9Wd93dmgFcaiDeW6PCIfr5iI9hJYOy8+jNt4/dAJ9BVIaiqlrjRYqcje3UBY+7Wxupjnr
	2gcvHmRGPXGg3wjibjkjsAsd12hiPSo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mCTI++KS;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768816726; a=rsa-sha256;
	cv=none;
	b=blFkeoagq/5HmTAKOpx6molMquTGzNSRQuEJz36zzM5vQE+ke4hABuMTlc8716CGwQcpvO
	rJAXfvelcjIKYIo7G+JP2oI+QKJdi04Vlmayiqgx9MhJqCqmvfqxDfXI9di8gMUxIZPL3w
	m8z3XCNpnvzHOOkqGZoTunpf6gG6n8o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A018443AFE;
	Mon, 19 Jan 2026 09:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2771CC116C6;
	Mon, 19 Jan 2026 09:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768816725;
	bh=Zsi1qPdOMD+ErrBY6bIANoezkKlNDWSRtk7EwJJVjYg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mCTI++KSyzq4RiwthjEmkDupntGGr9peSpAHhr7+gs48rQ8HcSlHmBxYT93v4imLX
	 0nmXpGdOGV07+qkmJh6EMXbUf0LMP9lz6FxEejsqeSM+lhqHfSO7rimeNoZWJgEIxW
	 6mRRklCbHCEk/R5NkeZzmKvjPHEb+15eXpD4jLtoQVe1cNfeJVWCriP7ML7s9can2W
	 TlVA9yutXMas6xX4MAnMwViVVe33ze2eHc17AqSpkgqg1CQeQ3NNA6aHiW6XbhPKUq
	 HlwLjNsOesXPrZZuCeGG6exZyq2WGpGflVJxO+vQ1tZisSxotIblR2gSKU/oFYlVdh
	 zVwRfXKYeci/Q==
Message-ID: <c63df10d-c61c-4337-9c88-ed1ce81204a1@kernel.org>
Date: Mon, 19 Jan 2026 10:58:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 0/2] mm/khugepaged: fix dirty page handling for
 MADV_COLLAPSE
To: "Garg, Shivank" <shivankg@amd.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Masami Hiramatsu <mhiramat@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, linux-trace-kernel@vger.kernel.org,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
References: <20260118190939.8986-2-shivankg@amd.com>
 <20260118122229.dcdda884bbb19a9c30ec6f1e@linux-foundation.org>
 <12b6747e-b844-4931-9918-fd095a6d772b@amd.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <12b6747e-b844-4931-9918-fd095a6d772b@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 93941140002
X-Stat-Signature: cun4qgxeaq66oddki85m6x1y6xop9axx
X-HE-Tag: 1768816726-285846
X-HE-Meta: U2FsdGVkX1/xCjCPQN5v5Nc71C58RIayYiT1n9k9oA4agoFnfko2EJkwhHzQkDiHqeBDZhyLmk6w+7/qoOiBAtp+lqcyKvybpOW/sVQo7W72Ku9SPu6A69HMAN3+gag/hDFvO7nk7x8V4a2xMNev0uEIRm5+YMSjGuwI41XcHx96147lJKI61hdXLaAE5ot6Bmix1/Wr+VZOlyGfnk3CkGmH8KquXM48CEXOjvhRmOnb8W8CKdPF/k1p+8a4ksGAir8/I69EKVaiBexWBTnMneLxgaUKS62wzxsTe9y9nf6CbKBVe1lDIZfS1dkl0IV2K84KEqpPAepQWag6cGCjiIGGeK7rcVm98QKZO/Ps1akmBYGUp7EBQannlU95+7OwpXzdDw8GymLh+OPOiNXYFaqMA0Ffglns/tVgQTpO7p0i3PA2S4DCrg4H5YU+Svh6vpF4+miuizOdFWfNCDQVWnrof00+T5FgBtAZYIE1UOaqFfB8ATxKngKtCaRhjCfoGWrvtI9PxzKp0JPfUCN3Cj+T4pgAyr1qL2Xvjyd+JSTe5f10Vw/Jaf205hBQlGdEqTPp9rXcCROMCc3s6+gDDaLUnJJrEoKyYuEyL/Ey+M+5UKqL0723FyrgxF71TsZzmp/5WIgFmLPMTZyz6l05lnQ7V8NM7solLr6SFNAPnyiehWrGyZAPzgKwHa/kM8eh3rUbmnAVfcRgsf4RW/DItqZEwUIoNUa3wAmS/2tMgEDHX5oXKTzsFZF7alERZ+pPNyqEhJRtn732rbC3c9DLRBg+yVzzW9ehJ12KwyGaLMG3/Jg8czaJx+/5R5/FaCsRnS40bpm/PefSYaX256bykMKhVMgCSAHSO3i2BsVLHRPEX6KPsKlKu70QMa8eeCCZEWEtrbTug3YQE6QoWCkdBDMgnsntNbVYE/q3Aq6T56GiWFEzyCSfVqic8kSaNwqh7Y9o4sLIV0Za/crzrfu
 wZ6mhS2g
 Osse5o6ZEImkHWqcHXWlfYoIdtfiJ9wq2Qm8hb4ANg3G1NLsF5154h4IDTYyTg38rQ7kjb/een4gha/A+N+lHgUFLyLBZjp8Dq9iG0QeIf3N2Q9E5xFHXLQ4WWi3/3WTfkitH0l159CRuUKRyAhA35iZ581sGsjhQXF52SUgJEHvTwFfgWy6/tR56AYr4XgEfk6B1rsPpeIKCDgFRWHpqzWKCDKcBXBRN1uJqioOGt0b6Bv702G+bmHttkRBe+7f88pns24ZOlruUujohCwwELNq6a7zciTZv7qVOjSIWDBcjxK3rLknjYW7Xy0guEaTvwdAgvMrsvx5w6lOxoymX/A1lp4CCEAF6WN5F
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/19/26 06:07, Garg, Shivank wrote:
> 
> 
> On 1/19/2026 1:52 AM, Andrew Morton wrote:
>> Please tolerate a little whining about the timeliess here.  We're at
>> -rc6, v4 was added to mm.git over a month ago, had quite a lot of
>> review, this is very close to being moved into the mm-stable branch and now
>> we get v5.  Argh.
>>
> I sincerely apologize for this.
> 
> I had this doubt on sending an incremental patch or V5:
> https://lore.kernel.org/linux-mm/7a42515f-ae57-4f4d-831c-87689930a797@amd.com
> 
> 
>>> V5:
>>> - In patch 2/2, Simplify dirty writeback retry logic (David)
>> Are you sure this is the only change?  It looks like a lot for a
>> simplification and I'm wondering if we should retain the v4 series and
>> defer a simplification for separate consideration during the next
>> cycle.
> 
> Yes, patch 1/2 is unchanged and patch 2/2 is the only change.
> The diff looks larger due to code movement but logic is actually simpler now.
> 
> I completely understand if you prefer to keep V4 and defer this
> refactoring. I'm sorry for creating this late-cycle churn. Please let me
> know what you'd prefer and I'll follow your guidance.

There is no reason to rush any of this. :)

Review was not over and due to multiple factors my review on v4 came in 
later than I wanted.

Andrew, if you prefer, I can start sending as a reply to every patch set 
that I want to review so you are aware that it is on my review backlog.

Unfortunately we can't have nice things (sub-maintainer acks).

-- 
Cheers

David

