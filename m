Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17218CCD194
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 10:51:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E1C18E001A; Thu, 16 Oct 2025 06:51:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 692718E0003; Thu, 16 Oct 2025 06:51:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5816C8E001A; Thu, 16 Oct 2025 06:51:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 461D28E0003
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:51:22 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DFB681602A3
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 10:51:21 +0000 (UTC)
X-FDA: 84003660762.18.91FFF63
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf11.hostedemail.com (Postfix) with ESMTP id 555EB40005
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 10:51:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y8dFtMSF;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760611880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9mltHsNfESF6l4m5rH9ATu3tuf/qXFwaXLTvvIMtUic=;
	b=VFeT5nB9B9zTVAXVno1fvx0w2a3kniwAOh853okgqb8t9NFGM7CU5eY/D9E4CspdC8qRUH
	yvn3fttyJb6nbNGUpoZcLZppOGsVVcJ6vmYwogKUvFn8+icDsKMcYMqkUB3cjLD8c5e7Va
	4MYmzzo0xtwAHHZdlhJcP16gpqpvdhs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y8dFtMSF;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760611880; a=rsa-sha256;
	cv=none;
	b=HU4e7QJJx7eG9Wd6NDd2A5341JRwamshNFdhQqPz/i4tWmYh9raCG0pHUPNcIlyRIn12Qe
	11BRUO0+wm8s03+B757t+TW3SjzkTN0rehnAbusmXr7fzaXrjDnmhXPTQ48R5pzfNUj+Df
	kecN6F438DgE5mMeGpwag9NPNlfY2tk=
Message-ID: <d288fc83-a1ee-4409-a457-83bc21356306@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760611873;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9mltHsNfESF6l4m5rH9ATu3tuf/qXFwaXLTvvIMtUic=;
	b=Y8dFtMSFd2GFUHd/xc6W8OPZmvtzDWg8pzpUHsJvZ0LD7wjSiAGvP8TTPwSluyfDINmjgQ
	HcsIAZVUH3iqf9VJvdnkmMCmOm4N1nUk0FUC5Sr/RdFeOfieW+x2mK8qys+WJJRnm33ryb
	V8NrgyCfkxYfXuvDAYi4LGm8FqoPF9I=
Date: Thu, 16 Oct 2025 18:51:02 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new 1/1] mm/khugepaged: guard is_zero_pfn() calls with
 pte_present()
Content-Language: en-US
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, ioworker0@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20251016033643.10848-1-lance.yang@linux.dev>
 <20251016093310.rilvenglgnr65ojq@master>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251016093310.rilvenglgnr65ojq@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 555EB40005
X-Stat-Signature: 798moqjc4opsfifrj7h3sj6trb5unn68
X-Rspam-User: 
X-HE-Tag: 1760611878-551935
X-HE-Meta: U2FsdGVkX1/NaG3ZqZah/t8M3gn7SqffzZtAHz5if6uWufKsKbDNx8KiWwd5HatPrw83Uyp7heMPxYH4CuU4Q01p47uw6Vi8EcLRShMUFc+ZAewhWjDlXh9ltZ095TXxDaKbfXfVuUZuQzjUV/CN9SHs0ExcBmKTEZB9cz2pQZm7o6jntSF+6PCW5btRwTQWX0p+jiQHDCWeHTphPBRv+Yi6exKYwS7XNBbvQ2cnk5J8TKbkmptGaxJWWtOEmnNFwyEVHy83zTt1VK5wMpCFaFfUslb4ZDD4rYmvVTRv3dB1fuBibEGO7GogiKrjqQojcsVMJ9SumzqJ0AoXt39kj9mo1deSz6lGAtqQh1jO6n11+PQuYkUsn6UyFUxT6nHfvVgOR17OH7VCW0mXlDoadkVNAPbTIEfva+7XvV+9VB37J7k+aBRFQs6gUAzZc0TSxFAEmBQPEobuC8Ym9BuWo8+DwhmKfUaMPgHKBMEc7VRG+TOlWh6L0nGmR41qIC+aP6eXHfJ0B3QM4FPYO2+3lsSbYOXprhLLaofZP/kKBTHPTkbiMQjeaxZ7YLuMkglc7XHdxlC4rm8uc9g8hht3oz2SlsKFLf1Uzv1qsk8CHmCivPf+KTh4fdM7lQYLCHl85SIUAOqNnKXnFn1o0i0OKuRcCvWkRFbs7I3+Ivly7W/ktRsJYYfK2XUbWSoVehJtrhVWyJG1Aru+J1ATKgxKNZEF5VgZ2+X6W76Fg4c87K6x8Lb+PDlSn56K3GvLNFOqO4BgUkz31oJEQ0bZhe8/e1zCSGIJTguBm8IQ+utKAlJS7y4wsN49jhTWD7LiXs91ktRxfbKBJVl7zzImOpcGApzN8kiF42q7OSM1+1DMH16kNEicfW0iDYOndYASpKFgLt5hWom1PIJ/FdyLz3idTF+nYesZTDB6Q8D34ma0vBfq6/XCbjy3SAeE5I36B1mRfNwBfYfJonJ77wCWPNt
 eWSTmO3D
 8MiuMOOXFWGcyn7XA7wkoQpvvfarSvCThSHkBLyACZSy9t6/K9+X4blLQBbsqKpckQuY1NYkRx1hXInRJAlO9Zj9iJ9eb8THjkUFKBfP5vZvE5lAWjL1oCt1xMrPi8kxtroilZMDwiRMd81N4TcZEBD3nHNq75l8h7MnBtW0+wjPIrSAi0/fqrg6WC7SuP7PzWXsPXAHiuhTfaq79gMM/GPBYpwarHUBk7wUlRhJU1R1UXCqCS/4XmqGFdMGhIjDvInugktkK11sdjGxwkwPOXPmEMtHmVeFB8VdGs8XykETZsBYN6N5qjiazu2uYcygcGYMuDwx5JKkhbnkmoRFMvpZ/eutelj15oYmE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/16 17:33, Wei Yang wrote:
> On Thu, Oct 16, 2025 at 11:36:43AM +0800, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> A non-present entry, like a swap PTE, contains completely different data
>> (swap type and offset). pte_pfn() doesn't know this, so if we feed it a
>> non-present entry, it will spit out a junk PFN.
>>
>> What if that junk PFN happens to match the zeropage's PFN by sheer
>> chance? While really unlikely, this would be really bad if it did.
>>
>> So, let's fix this potential bug by ensuring all calls to is_zero_pfn()
>> in khugepaged.c are properly guarded by a pte_present() check.
>>
> 
> Does it more like to guard pte_pfn() with pte_present()?

Exactly! My thinking was that by guarding pte_pfn(), we're ultimately
protecting is_zero_pfn() from acting on a junk PFN.

So we're on the same page — I just described the end goal ;p

Thanks!

