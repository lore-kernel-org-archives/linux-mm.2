Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF7BCCAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 07:15:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 299468E000A; Tue, 23 Sep 2025 03:15:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26EEB8E0001; Tue, 23 Sep 2025 03:15:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AB638E000A; Tue, 23 Sep 2025 03:15:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A18B8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 03:15:20 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6C0A41A03A4
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:15:19 +0000 (UTC)
X-FDA: 83919653958.28.CC7FDF4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id A81B31A0005
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:15:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758611717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BRjzQJGjw2JJF6SecgP0kJUb+uYm0x+KVQlxHfAeE7w=;
	b=PTH65a4ZX+qbcwhP+OedudZCny+TRVXx5b7I4hLvlvKOZfMk3dYamtJgrJwFjxbhKa1X4L
	5I+zz3hji8g2WARA/L+952PkRumBsk4HbH6pyaWDatZ5VRimnCh6gpSfzf5QBaX+BFtHte
	eNohEj+y99yih341NTgZMt9iTpCOSNY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758611717; a=rsa-sha256;
	cv=none;
	b=SZNyq+we0XFXW0BNWtdYybdk9RLNsaM5fbWoNgIAt18LDQjtxrv7agjzol6BGBASxfWZOb
	aUvJwm6CJKnRLgBt8Fh1B1iTAkz6r8q3j02stK4raQWDYQ01fdTmyAREMqJCkltVBsAl9W
	LdPGNhxHEvatzOLrwLgA1igkm97+Ig4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BC997497;
	Tue, 23 Sep 2025 00:15:08 -0700 (PDT)
Received: from [10.57.81.133] (unknown [10.57.81.133])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6E7D73F66E;
	Tue, 23 Sep 2025 00:15:14 -0700 (PDT)
Message-ID: <3aadd340-f2e3-4926-8a39-69a0162eaa9d@arm.com>
Date: Tue, 23 Sep 2025 08:15:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/5] arm64: support FEAT_BBM level 2 and large block
 mapping when rodata=full
Content-Language: en-GB
To: Will Deacon <will@kernel.org>
Cc: catalin.marinas@arm.com, akpm@linux-foundation.org, david@redhat.com,
 lorenzo.stoakes@oracle.com, ardb@kernel.org, dev.jain@arm.com,
 scott@os.amperecomputing.com, cl@gentwo.org,
 Yang Shi <yang@os.amperecomputing.com>, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250917190323.3828347-1-yang@os.amperecomputing.com>
 <175822779944.710258.10028837182267037801.b4-ty@kernel.org>
 <fc43aa07-d4ad-47d5-8381-61d4a9b8c467@arm.com>
 <aM0-FQlepoxxGkRd@willie-the-truck>
 <ceaf604f-8ad7-4e19-812e-7eeace10d835@arm.com>
 <aM1E34lRjKg7nlRu@willie-the-truck>
 <38fa4717-9105-4bca-a2cd-914afc109570@arm.com>
 <aM2kg49jBia4VKYr@willie-the-truck>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <aM2kg49jBia4VKYr@willie-the-truck>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A81B31A0005
X-Stat-Signature: 5pikwytqwaxiecuzrg7sm57zt4xhwhwi
X-Rspam-User: 
X-HE-Tag: 1758611717-976205
X-HE-Meta: U2FsdGVkX1+G1C05aNcQcxWVmLYYArM8+XNSSyhsWowhTnqDCl2gI1DvSKNzwdZY2XRQQ8UdFiYc2LSaAQlQGN8/VpyVGPlgqJ6XIfhTwciOdGDmwx/sIV2QAM7l23OhNyR6/zdijPMnWQUWqFq5XNPhDW2501IyeqrbCT9K4oeb7j4NcO0JqqL+l2K8C/cja+MmDvXo01T9oqFVO8OKEnQXR1EXFmG9pxhTFWEISNVvJQK5L4uIAEPOihY8eOXZEhWSZQwh29ckN9AJ+C8Ma1goptv530M7OhvT0zt8Uka8lYk64euu+4yVEwZ9IzyI3fpDSVGEUyNy0pwdZqIhNXJZfJWZAECBeABqDzJuB4Ox4ggQ8lcqw02MKU9GD9K2ohefdctqhvqiagCgSq2t7LUMX2oEj89ZqAvgVWn6vLXFB5a2lx99I/8UBfAtgF0pOFEXAP4ti43Pu8nnYQeyst+LG0zXao3vJrKZkPtQ+WTlXApazSvI6l65ywkNV241oqigLRCEAnE7iMnz3qMWv0KwnRrddCTEeqFgVj9iGIPm7m0RyOCvIbxOv4+k7K3lYbJ9gnCz/XdmiLbOUd/1od04YqqsPZitiTvlUN7f00M0gw9SmwOEYAtTALhUpJJgikv3ueQVlUM6mNf2D/tHLLjO2rGmFuVDLy8w8sCh76uswZjUMM16be32qt+8sEL6iTime+jsllzMQm+o9K/HctNWmrK9VToXgYAdIiWIcmtmA+UyWWBY0s4ru6NFopIKDYby74/3fjyYpl5jWoy2wkurWReOM4t67t9AaTmIz+GRw0omxJRhxEljX7BIkg+foDOlJ1aocpgE64KZ0Myo+kpSdcPPsyytqIIfT+XvaRRXRDT35uiWTgw/RaWXoeKO1g9XwLGydguQDHtb0Eiz8MCbKMYU+U2IWgtDd2GvdOMULUTVAr2CBZiWeirqhAD7uqsFjFGqjqnHchWC17e
 8tFUwwvv
 gb5LYZwau96bmwKFqVwSjfnuU8gYV1kdGW0MUYLjfWzVoraaEF8ZQPBufU1YR4IunJjD2o1n20ppzYZTOS0Wy8ErQmBNH40QtuAk8uatWOswYXSB2NiTP5fmadNw1HGuOYs2qnWRxLhfrMr3WFU/M+0FdETJrREcyGCe0nTGaWnX3FIJZuJEvrY55xvF1XM+1eHYK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19/09/2025 19:44, Will Deacon wrote:
> On Fri, Sep 19, 2025 at 01:00:49PM +0100, Ryan Roberts wrote:
>> On 19/09/2025 12:56, Will Deacon wrote:
>>> So how about we:
>>>
>>>   - Remove X4 from the list
>>>   - I try harder to apply your patch for secondary CPUs...
>>>   - ... if I fail, we can apply it next time around
>>>
>>> Sound reasonable?
>>
>> Yeah that works for me. Cheers!
> 
> So after all that, the conflict was straightforward once I sat down and
> looked at it properly.
> 
> Please can you check for-next/core? I forcefully triggered the
> repainting path in qemu and it booted without any problems.

Thanks Will, I took a look and didn't spot any problems. Thanks for squeezing
this in.

> 
> Will


