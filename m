Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D01BECCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 13:03:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E24B8E000A; Tue, 11 Nov 2025 08:03:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B9788E0002; Tue, 11 Nov 2025 08:03:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CFEC8E000A; Tue, 11 Nov 2025 08:03:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F215F8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:03:47 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BA0CE12D645
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:03:47 +0000 (UTC)
X-FDA: 84098343294.17.3A4102B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2E394160006
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:03:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nx4cjvlP;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762866226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oeet2MfqPeJUMhuAI+TJhp3djZ7JBxlA/AaPoYju+08=;
	b=8YQs+a0QPSOucdplsaeRjluJOFpT3mxRqIEWAIpYWpW0YR5aTKQyridBPpvFBfX4lDb0aB
	CPWZSUIquTEc9xpF6KySZ8aIoF8ESypsVBxVJIPcQ89mTzow7f3xOnfaTum2ucP/A8ktSD
	fqcDDID41hlZIJVjHjGYPpYfKfm1780=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nx4cjvlP;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762866226; a=rsa-sha256;
	cv=none;
	b=xNP2+v5IPc4pkVBMiKk0XsqdHV1ZyJGEXT65XUIIHFmviHVVC4WkTf1by6Z8mY3KKUghUT
	eBMV0gJ2xPpX6OerIenkrhDJCXMxdyOgy9Cl1jHKu9B3LeymFMFSGbuxVMpu7AVe2b5Vc7
	5CFSuplgsJvTGLzKqHFFhN9NyPdyNEg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 27EAF61909;
	Tue, 11 Nov 2025 13:03:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D0BC19422;
	Tue, 11 Nov 2025 13:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762866224;
	bh=MnQGngUYZB/AuquYMcvngj/vv0fvRZTP9N1ik/AuqZ8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=nx4cjvlP88r0deet2wJMyBpLgRhoG5z585/MuON0PuaxnYs55RYvZ1IzQY6H9JByx
	 8bGGRsHDFEvVTPi1GFJlU1oIwYPn4M5SdsrRJX9Ooy1u69MchU64Wfpv/JPxpTWG9G
	 Jd1uIKXHmujcrw3CK2LUloly/bMW6Kp56MhenOxEz5AqeC4WvXoDBmB62K7MIbcOr2
	 h3C1DHdEyZHl7Lgag9Xlyn8nJ0JAgy5Jqng9hzmKIWQeVkRyD6exr1QQxCHV71J19m
	 hTyHcpPVc0vcXqTTz+mZd4mabIbcZX23RiHeq+5QDwdiewLoAsuK7FiLsyaYQ/tQg+
	 EL34ZgyDgZJCw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  akpm@linux-foundation.org,
  graf@amazon.com,  pratyush@kernel.org,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org
Subject: Re: [PATCH] liveupdate: kho: Enable KHO by default
In-Reply-To: <aRIwSEF8Y0I6q8Cy@kernel.org> (Mike Rapoport's message of "Mon,
	10 Nov 2025 20:34:48 +0200")
References: <20251110180715.602807-1-pasha.tatashin@soleen.com>
	<aRIwSEF8Y0I6q8Cy@kernel.org>
Date: Tue, 11 Nov 2025 14:03:42 +0100
Message-ID: <mafs0cy5oafgx.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 2E394160006
X-Stat-Signature: kkiwjcyouruh11jhoq5gnpf48oiwmzgs
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762866226-23173
X-HE-Meta: U2FsdGVkX19fNp78hHcugVvjUIqz5dhsiwl2DEJWFXcxSq8pc87Tv5LBTIEzR+kFudR+e8IS/z5hJ8co37VWZduXdy/5+DCDoLYjPdU+w5g29SWh4fv7JRs06MWNhaFsPURsRsSr5nUZeOCrRGtrdCc8eWDOwsjvkw1FjKg9bS4vyZSlsJAVMhobVqv6qtu1xv0LGOsxETCfELoel+QGMR68Vlulw0xgL6ijN/k9TK2gF9pDUnRlz8iQIJhSyX3+h5bbr5PO5V2Pzduj9B5by0HNDD0bZR6sapMQwQ+Gj5cUAjs7BIcK3cJUytz0slwqWXBpaAEE81iOiqmJgDIMitpY5vFPp5mVWF1u+yUP8AG59R9rSyJc5TIHag+t1YYeKvv/bUU4Nh9UwMDjrnCZLE7e/45A2lsJomZTLXnbryLizXG9W+VBjBU9TguPgzy3lW0IQC1yzJ2madUjwkWXud1yGtZARIoQZIIX6gAtz/JlzAE1lB3mxuI3eFcWk4JiQCDF11MaZoA9sv/i39h/2uPbDWLXcP4E50INrsW+TbXynpmRomaN0+9URhb1/jFI3QpzS3k9gcDy7Mcwb315PyvTotlubP7Ym0vvuU9I4sunqOYCbXlImTuKDGdCUSSeQC3csPujt1t//io4KS0b8H704tthksJXM7Dp7S9tpi+/KshryRsHuIA5525qDVtR2MYQrftqcYpzgPUClSoNKqURACtQH0KSNsIwiO6usHKmCU5xkTlZwJLsoliwIp5/be7xWIPW8UuJ9RzKZ/JgDwH2foIuDOddTNeHojzG9nbX+Kh9QNAzQp1fB0PP/O7UdvWF7aUOzpPOWVGfbdUTZgg259QRi1Psr4PVNS5VjS/dYAD5UdLrtzK0kphTP+DBV1JnzyRCS2LWqc9YOjqfjl1ZbpGBwvoPFMb6mic9o/V9HbdkNckoytlNdOa5+0N1tRgOvG9DsBVRW7TmiX/
 a9FYzrXF
 WVym6EylLdyzMMtdA4vvQqY39UY3qp6JLawbCNVuMOAMnQ08ckEGSQAkrRNNNupVbcLUaqwAHQSFv8TL9NOSmJiTtmF06R6RrQobSF2rDSBJZK24dnrhrKW2Vq0P7mwLSDYqUQQk2kNKdZhl1GSybqbD0uKcoAyanfx/JZeAo6e6CY3xws23dwzQnHj4tC1W49hpJ1phHenJousXI47mAfCcjPQcIYiik91ulmrj+h+TAbfzI0DnJH1O2wg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10 2025, Mike Rapoport wrote:

> On Mon, Nov 10, 2025 at 01:07:15PM -0500, Pasha Tatashin wrote:
>>
>> Subject: [PATCH] liveupdate: kho: Enable KHO by default
>
> No need to put a directory (liveupdate) prefix here. "kho: " is enough.

+1

>
> With that fixed
>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

>
>> Upcoming LUO requires KHO for its operations, the requirement to place
>> both KHO=on and liveupdate=on becomes redundant. Set KHO to be enabled
>> by default.
>> 
>> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>> ---
>>  kernel/liveupdate/kexec_handover.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
>> index b54ca665e005..568cd9fe9aca 100644
>> --- a/kernel/liveupdate/kexec_handover.c
>> +++ b/kernel/liveupdate/kexec_handover.c
>> @@ -51,7 +51,7 @@ union kho_page_info {
>>  
>>  static_assert(sizeof(union kho_page_info) == sizeof(((struct page *)0)->private));
>>  
>> -static bool kho_enable __ro_after_init;
>> +static bool kho_enable __ro_after_init = true;
>>  
>>  bool kho_is_enabled(void)
>>  {
>> 
>> base-commit: ab40c92c74c6b0c611c89516794502b3a3173966
>> -- 
>> 2.51.2.1041.gc1ab5b90ca-goog
>> 

-- 
Regards,
Pratyush Yadav

