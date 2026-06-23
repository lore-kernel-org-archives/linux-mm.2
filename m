Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A85ACCDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 11:04:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 796016B0088; Tue, 23 Jun 2026 07:04:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 746506B0092; Tue, 23 Jun 2026 07:04:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65C8C6B0093; Tue, 23 Jun 2026 07:04:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42F716B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:04:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8E6211C58AA
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:04:41 +0000 (UTC)
X-FDA: 84910894362.11.5AF19B6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6296840014
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:04:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="uJO/NSPw";
	spf=pass (imf01.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782212679;
	b=h/3oSrcf4qrLroI2DJrkvQPs2sfUzr9LwrInkKTcWAdh0ZCukFDYNp2VxXedsteqx4RuW7
	ehd9vG36f/iTtd3SS10ZoNtBt3SZ+w4q+2EUuvzI6/sOoV8OJnpZ0HrNeB16RmaXsijwMo
	vs1meg6Ea8zeDzki4U+nb3sq+Hr8cCo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782212679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ECNV8ax8Hsh3Nn75cE7WAvXQBednnQ4wmgobByUsQSs=;
	b=fJO2paKz20cc42LqCRUtHCzT9j4UqLVnkoWXht3Vj4D5iiYnInRSle6+tFtUIdt+oOyVPj
	HoNiR0a7iHOYAxMhNy/ZQ8Zc4alrRRAKjBffnfhTgP9vUV8+jgoPlrT+ESmbze7mhFY4MH
	LH4ejJlYpaexN+vjJPBxyAizqExpBFo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="uJO/NSPw";
	spf=pass (imf01.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 853AC1A25;
	Tue, 23 Jun 2026 04:04:33 -0700 (PDT)
Received: from [10.164.148.38] (unknown [10.164.148.38])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 07D953F62B;
	Tue, 23 Jun 2026 04:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782212678; bh=f0gGtvxOEphT2DUNUoQMZGrP+QDdes+x+kNtkL06yUo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uJO/NSPwv6i1UphGcwTSZJ6nX2IfgfWmiJvtlQQGGrD8WgwEUXr0blhXQzi0yurXx
	 SfVHkZTryrdUqUzj7FHHz8RrLGu823kX07BHyaae8XpbMWbPLosXo30EVBHgKz7L6H
	 /m152kwkgTT3Hlh6bapGhDb2PzWrf9b/rML9ZcWg=
Message-ID: <93e3ea2e-336b-4cb3-8be4-efdb353ff236@arm.com>
Date: Tue, 23 Jun 2026 16:34:27 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/12] Optimize anonymous large folio unmapping
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org, chrisl@kernel.org, kasong@tencent.com, hughd@google.com,
 liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
 baolin.wang@linux.alibaba.com, pfalcato@suse.de, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260526063635.61721-1-dev.jain@arm.com>
 <39e1a740-1126-47d0-b5dd-d711c04c6af0@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <39e1a740-1126-47d0-b5dd-d711c04c6af0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 551jwmxspdz3gm153ukhmicj8xthyey9
X-Rspamd-Queue-Id: 6296840014
X-Rspamd-Server: rspam06
X-HE-Tag: 1782212679-854800
X-HE-Meta: U2FsdGVkX1+aNzaVAMdKDa/oq3H/cPqMm3zV5xyHB+PWR/3A9ekTOuqqUO3xScPgOYpuZjeJ3Tem8IMUjmfnj4wfd4vzzDF849iXEqbyOQXZHC73DeT2IAsC6XCmqSEhL0cnHXOCoQjb7I8z3/hbKbADU/oJKKDZrgdZ3LuI7gFL6feGgB6lIljEysxe/040w4XzCVNvhn8dXyw/sDG8onPPJdi5pigdo6sKeCYA6fO3uBrXi/4sm71yxhfnmISrhhhZ6l8Cv+Zcop/YemJoE8AJPR1Wkk3tsEdUV0iqX/w4sgyCDszd9Yev//pmnONgKZz3d9f+B5jOOP68QIafQb7i/ZW6MCrxKOxaTyp6lnvEEcyuBUgL9/JrlRg2v3hiO7gHKZxqA/7EVNj/hO4QluULqcGkQNocrhCLeWQKxv5CL8qpQaEtjZMv3+8AGDrw+bRZd5lnIQhxUH5WgMNkwpmh/VfCQc6v092DfCf9n9EXId9s/xHQSsx4XGZRROsn56pvGWDCvGZ6in+8JV+1kpW9Mc6J+6nlQT7H4K3w9aJ5lWvJJFD2+CFbIdNATKowp0QARMhKRfjYfy6JhduoQDLMC7MufcNhrAOm9/dkJvzeW503xDKVYXZUekAL2nvpfLBXidwOZOINHx0TnTE4JLROVOuMu82D5LUu5Bi67ayvS3tAvI89OLXTwXe+BbDEGtTpfTqq1aPtT20evGU2WeQGnBcC0WhPktZz4KLrRqZhnbbphud7fVT1zrQk04ug5i3ni2mPIo1zhRpQ9f4KT54ba/iZTvpo3Qfj5oNAcyirMktsd1tq00WtyMWGtB7TupG8xBx/omlnZq8OF+Ku+61JVxHeEq3Zc10GBmFvHZU8EYgiSoc2Mi2TnQUZOSpikySFUzo6p6LoWFPGKYX+jfKlA6tT3eU9E/4fJH7XtuEsjPWGt87rmLwsnyFhvo9FKPuUSJboAX3GB1+gM8B
 QbjFYvZV
 kSyCGBEilccFNnnCK0kRsNeguoAQpEAS7s01zGXISBnEAKnUdf7LjPr6RpOP7/51tYbp7TTpdEZ7sr4mZN1IuIQg3DZZWxd17FC0xWf08jUbcAyvDZW/ZFKp9qicGbcDOwToaASOZpjvQoYr5jHEZ2EKPgQ3Gl0h6z5iIeyeAsj5ZWVqDMrz8UdrbudrUfvVd4ADeMT/lhXz7Z0VU5bomYsHh/+hZk8DHZLAI5/KJKd1e/XY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 09/06/26 7:48 pm, David Hildenbrand (Arm) wrote:
> On 5/26/26 08:36, Dev Jain wrote:
>> Speed up unmapping of anonymous large folios by clearing the ptes, and
>> setting swap ptes, in one go.
>>
>> The following benchmark (stolen from Barry at [1]) is used to measure the
>> time taken to swapout 256M worth of memory backed by 64K large folios:
> 
> I suggest sending out patch #1->#3 ahead of times as separate cleanups, so we
> get more targeted review for them.

Okay I will do this.

> 


