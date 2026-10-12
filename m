Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C54CCA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 10:13:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD4C46B008A; Mon, 12 Oct 2026 06:13:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AADDF6B008C; Mon, 12 Oct 2026 06:13:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EA9F6B009D; Mon, 12 Oct 2026 06:13:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7F1596B008A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 06:13:48 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1137DC0A68
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:13:48 +0000 (UTC)
X-FDA: 85313562936.27.21A9894
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 18781140008
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:13:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DHR8Iput;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791800026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ylW2MCacCBTJ8JHBFYtmDGO60n0cdHH4RsdTLHqlwkc=;
	b=XeiRf0vkBS6DRvAZq7RQVfQxoUtk+R8jjZtPEsg/mpR4AtGAvPKxktUNrrwgeZDlNb3xzh
	KYXrHZz9aiTrXCuEr9r+bdG2IhnvBZ4dHPlMSunA0DFfuaHMPx7nwUg6CEGCrLe+1bff+P
	LMQnk7nFp/uw5cmXJqum0eSyPHQnKmg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791800026;
	b=YIlpEjgLDaUx5IhxKeUQvbKRU2EILfBPr/o7MRS7siiikQ12kgmHsKMm4g6gW91Zvs8rlk
	gIWEe2EZ4IJa+9ZErLl/GmeYc9L6j91Eq6b8vofzty6RBt/vhdnz0bnkNdi/JgWP44YaO6
	Bz5WM/lsphQpm0UwCq0Eoc6IJPmc42Q=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DHR8Iput;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DC1A41655;
	Mon, 12 Oct 2026 03:13:41 -0700 (PDT)
Received: from [10.164.19.62] (unknown [10.164.19.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A28683F66F;
	Mon, 12 Oct 2026 03:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791800025; bh=DZYdnMPeCPCWuZMC+2A5Kvn23lXKdPJQkldqykQeLRo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DHR8IputLfKZiOG/Cr147bz/6e2FKghaMsaanyvD0RL2vM9SoSsKoqC2Hj38TMcDN
	 THEaR03KepS1PrdqWT3oseA5r0gXnPw7zAGqseAuB6yQ/zGmvmNvVtYQD2LJRymCcl
	 rOehn6TnHZzJdMuiPxoPmPw90va1+pRqWssBBilo=
Message-ID: <dcf15f02-dc4e-4c01-909f-5b1983168d03@arm.com>
Date: Mon, 12 Oct 2026 15:43:37 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC NO CODE] [DISCUSSION] Anti-fragmenting ordered buddy
 allocator
To: Rik van Riel <riel@surriel.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, kasong@tencent.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, hannes@cmpxchg.org, brendan.jackman@linux.dev,
 ziy@nvidia.com
References: <20261011215412.1181172-1-dev.jain@arm.com>
 <16a9c5ef3fde0b7693e52dac91a2d397526dd99b.camel@surriel.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <16a9c5ef3fde0b7693e52dac91a2d397526dd99b.camel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 18781140008
X-Stat-Signature: z8npzu45kqouk1pef98b3b1dba3ahqt3
X-HE-Tag: 1791800025-969593
X-HE-Meta: U2FsdGVkX18izlBT3vwRg1Ya5Ho7btLoUN9/t384CEu3YDP/vwVKJekWZbvMfO4RXZ3HNNK7nCA1DQR56+5f74lA4gr6ykQRZn8yA9HlhE443KZR9Xe28S8Tq0MVrdN00xhVA19gjqcRjjQl2GmzNuLYDnOmO5mNIo4DJtmQOvYahWxDIW3QFjRane0WvV2aFl2d4ilDoDnCTT7jYmHYz+5jbNN2mXdDChiFd6rgsw0NsmUs5NsuWAoUvHxKq1PH+zOvUgh/8L+cTWuKPuJaBUzKSzOLNRzOy4APjYdRdvFM5+HuSCUGFbyim4G994PjtGsphey+13e3U3vE8o+cLzBTsIZECOKOzkyJLu6KwHmddngkbJbtqBtJnl8ZmNsNr+ImLlk3PCsZchpvJvMzZvKBPGhl2eoP+F3+cY4iuo1ispupmYuMoRXhJ1cLEur8Qr34pp3RPDSBtozkRj7AxdjnstHy3pwtVd17Pqq8aFsyuYZp6XhuBhni4bh9NgZWSTVHpWFYq9D9eaQHl1UUg13HlkhuPoXLnVf3PXMKQnPBpX0Gj7s5upfdOmdkXF09NWiNIcrM1JyaHiOyyXquTLjAtQPvD3kzwRaRI+hHUCoIxMs3ijsSt2Kw30pooX4VREr57XO2AJbGWpCdgv1wbLmL2ee1SN5eoJmn8uSWPJk17uzKQrwS4hBqWvBy+ExAvBT6HQitRYZFVq6BALPz3vnMiNjQmmre/1csxaKI5lz17pskgvCb4L25TVBDRJOAG7eyPwDUhn3KB/BNKziL8m29wQbIgwQaANFovLCjzR36HI4hKR0j726ZBMS8dC0RBOSEbFXoYyKP94qkkfcUPTj2Ng7lMqiM0xsJ+u89MrLR1VbVHz6SWoQjT76ZhI2jAPc1Cu0gDcHVxjdQRQLnDZBeR1eF35EuQWcZ/KoADK+j52PCHZHsRhe/asRkhKK2k44QU09m7zajLQjXkLl
 Xx/eGqhl
 /PSla0bZclHgDsGdwTr8CWTfb4VP0hVywd2cORtcovTbt1lKMZ0i4uTcuVGLqcVTXoePt4NaSuh9WQTQpzFYy8NGV3DmhP4zDNnY42466vkJmDpioH0QbL2gn+r2EXtMhBSA6insFL6tiecPtGwYSq05fszP+iVD0iR9y7xuEcKhCWt74takhw9mggeZq6syJCefQwekBfKfRoEDzKGOJm5UEQ5NyKzu0r2iimlsXc+F5G8Wvxpt9cy0hChJb3GYfpgoY1z25kMRZE4KPwuYc7iYWfK2YIj62YEDOESikt5zGSFDwT5Yi0XXUgGY8uNYIUcH3UUl8BfBWR1MOa8v/KMxfDXpAlayOweXhrjoynUyENcQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/10/26 3:29 am, Rik van Riel wrote:
> On Sun, 2026-10-11 at 21:54 +0000, Dev Jain wrote:
>>
>>
>> Apart from dividing the freelists between migratetypes, little
>> attempt
>> has been made to change the algorithm
> 
> Could I convince you to take a look at these
> patches?

Thanks for replying Rik.


> 
> https://lore.kernel.org/all/20261007021250.1665929-1-riel@surriel.com/

Indeed, I had seen these patches and from a cursory look I liked them.
I will eventually try to get into page-alloc review.


> 
> My current plan is to first improve the
> fragmentation at pageblock level, and then
> add some slow path code on top of that
> which can steer the allocations by physical
> address range, to preserve the potential
> for gigablock page lalocation.
> 


