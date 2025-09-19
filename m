Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3066CAC597
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 01:53:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51C228E00E7; Thu, 18 Sep 2025 21:53:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F38C8E0008; Thu, 18 Sep 2025 21:53:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 430708E00E7; Thu, 18 Sep 2025 21:53:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 319D38E0008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 21:53:13 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CE662B9DE0
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 01:53:12 +0000 (UTC)
X-FDA: 83904327024.08.D2D72B1
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf12.hostedemail.com (Postfix) with ESMTP id 969D040004
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 01:53:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MnXK3Qu7;
	spf=pass (imf12.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758246791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LgbZj+hEehjjyVcd+jT3wqpfmb95ZNo+158s5pz+gIg=;
	b=Gig+zOoHS+bczRgAwfh2eWXxQcokeZQi0PyHxErDEag0YjY8Es+6XFLP22Tivy3y/DGvjZ
	AB1+m2YeWrgUjdbPYA5pQvDG1FZdk7HXo2SgkdJ5ZymBohX260mZkorW1UEi2+WPH5ooAE
	UJnZBu56yNq/pphRwceRdTkrIBZLeWQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MnXK3Qu7;
	spf=pass (imf12.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758246791; a=rsa-sha256;
	cv=none;
	b=ivk3KPyum99DyS/cjY3+t6AYGG0rVV2TTqlSRPr6LPWfvfWuwzkyM4X5L2bW4k+K+InCym
	ri/pe08CN5XCgK/C2kb97t3GCdAPHGgVxWJcBnY4iv77qYZ8QDkwuf+9w1oNJb27S/osc5
	KJ5usCS7s66jgsWkdvrmYd4mhF4VuV0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758246787; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=LgbZj+hEehjjyVcd+jT3wqpfmb95ZNo+158s5pz+gIg=;
	b=MnXK3Qu73vyCgHQWy/BXxWnV2KrEpXsYDaxs/2NtZNdL6khtsVmTI5U78IbB1pi/2g6r3JW1NBGQTezjiGxG/020802PXyr128IpzOqF3stCdNoMZpdKK+6Jex52rnUX8MF415jamNnRGcPDFuGjFrNOIoaQAw7AqBJzEg4wQ4s=
Received: from 30.246.178.33(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0WoHtQMf_1758246785 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 19 Sep 2025 09:53:06 +0800
Message-ID: <248f19dd-25e6-4e97-8169-96da1e860035@linux.alibaba.com>
Date: Fri, 19 Sep 2025 09:53:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: PATCH v3 ACPI: APEI: GHES: Don't offline huge pages just because
 BIOS asked
To: "Luck, Tony" <tony.luck@intel.com>, Jiaqi Yan <jiaqiyan@google.com>
Cc: "Meyer, Kyle" <kyle.meyer@hpe.com>,
 "jane.chu@oracle.com" <jane.chu@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
 "surenb@google.com" <surenb@google.com>,
 "Anderson, Russ" <russ.anderson@hpe.com>, "rppt@kernel.org"
 <rppt@kernel.org>, "osalvador@suse.de" <osalvador@suse.de>,
 "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
 "mhocko@suse.com" <mhocko@suse.com>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
 "david@redhat.com" <david@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, "vbabka@suse.cz"
 <vbabka@suse.cz>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
 "Fan, Shawn" <shawn.fan@intel.com>
References: <20250904155720.22149-1-tony.luck@intel.com>
 <brfqzhbipg35twgv22vnnotbv3t3grwh2dxugvtbgqduuhsvst@f7exibz7i7tk>
 <aLsHh70jI6BGHjaN@agluck-desk3>
 <bwu744g3qzbzylxvfgt7v4tnf2k2eosqbkg7alm6u5roa7j3bn@gmut2l5227kw>
 <aLspJ5Tpqp4qRDk2@agluck-desk3>
 <cf05bc8e-fc79-49e4-a90a-47e661b4ae69@oracle.com>
 <CACw3F538k+dshTs1_rxbpYoRdFyX3tLYzfaWj-_d7Lq5Dd2Jsg@mail.gmail.com>
 <aL8rIgSImDh7Nj7E@hpe.com>
 <7d3cc42c-f1ef-4f28-985e-3a5e4011c585@linux.alibaba.com>
 <CACw3F50hU3BCP=A++Dx_V=U8PKvsTvTa1=krULxfQdeK2kVBrw@mail.gmail.com>
 <SJ1PR11MB6083B887B3EE4DBEB6438C2EFC16A@SJ1PR11MB6083.namprd11.prod.outlook.com>
From: Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <SJ1PR11MB6083B887B3EE4DBEB6438C2EFC16A@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 969D040004
X-Stat-Signature: 733wxjodq1wrcp3cqmqq1xhhuk3krw9n
X-HE-Tag: 1758246790-24324
X-HE-Meta: U2FsdGVkX190htb9OVOS5L7LJbW+gc4yW9SrvDu4vqX4V/tsXMiXNMWOvXw4lR8lkebCsmWHIy6KGkD556EnaqvIc5BWoF95YEphU1GAeW7awfjizJgEOjWGbb51Yxsj0qT2RttmQ9DYMfodN7FX/5BFasNGkduKsQCdc2vHBWtpaOQypGPTrH/gvO+0Oeh4sOqUynVl7AVFE9bUGvdXEnAgIjSPNT/r4V+cyW1Fyb0uA25oe4B5NbjHWl4TwsrTHT2OqNz+xknVUi8h2ihEQp/ZMM5AEtZ3wy3nLxt0D50JNDguPiaeddcA4I4mY3yYOPe65X+6/TjAStCJvZv6P1OQDq++objChmGi32h94NXNl8K86WDhfq1XY7idRU0uBJM7gDKME4rb4/qm092hKDOH0yyU7FIUi3q8m/lIun41t6DXYmUcRdvw62/11BRLih+AUGwAsOsYhYifS99nEPI2A/Esf+CHoYVnjzQqJYoQ8VByljHt8HpLTJflr+3GE17Yk9pIBoaq3mnQGiKNgMOyr1Nd57d4ZNx4BxPmKI05Vsrxqj18N0BdWoN5AvTcIvO5H8PHPqlJZsGrXgeP8QNl8dw1MhwPwbro5IFbgRAJDA9sNmSyXr1/utQofmbkQgNOPK4gcnEvgfmpi5gS07dbufqcseZKK+lg/o3ypRtIztH3zvnTXiKmeXN5Vra8hkwshVDlRrir8AOyv86ShFKldgJPTLwmIBo1Rli4o2I/DmIIB264RJTu7H/oH1HV1DhW9xbsAKhdk9G7FTwnUMx5EBZVxNxuGNXWIFHR8dybjmeMwAMQN6eWT5DPkQhny2jNE/SjVqHZyoiypqFt9MbfwGgyU4W8XRFyUKpo5o0+I0qC7GNawJMTho2yKFffMgRbjkt5q3L2rMbU+tpcgMQuB3EqV+ZC/mXfPWHcQLABm4ZXRGENQ1FK9Jn4Yw93HN8FDuHqro2g4/TzDrR
 yrFZ7gRY
 cIVWQI6JIAdtoK2qzMoxEwXvvpPWU84rdid91Uj+7y8HwTOgVZ0JsAZ4seREOvTZsMQ4XNzJDChVewYF8g75OD2LAifmjLM5Ip8CWWltq50sh3HCG/CITUbrsyyKpazPx7ikIXBjT6QLS2YszbuNHcyAj/EvtrdMiXNO50EfIUA2A5SqALZbjBotWnOOtJxuLGKL+zCbJtgOnepcS7L1bJ7KGWiuDKVN6bQEbK2ylDxSpPd2GBORrvpLFqRb1jPjozgAov1mqPVQk1GBapWrYfnvDz3E4WnriECIvFwcYK11WxUBBXY7563JozyW72xkWhQK5gJNgqdYIWfNjosfjNWzew4q9msvUbubCCpUjDv8rR3DABKzTts6KtmlhDjUiDAO+fM/xxpm5QZE6P1tSqORCv0Zw6Q/SdcU9Ux9FpxS2VWeDn1oYKznuyAzh9BRVT5qJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/9/19 02:45, Luck, Tony 写道:
>> Thank you for your detailed explanation. I believe this is exactly the problem
>> we're encountering in our production environment.
>>
>> As you mentioned, memory access is typically interleaved between channels. When
>> the per-rank threshold is exceeded, soft-offlining the last accessed address
>> seems unreasonable - regardless of whether it's a 4KB page or a huge page. The
>> error accumulation happens at the rank level, but the action is taken on a
>> specific page that happened to trigger the threshold, which doesn't address the
>> underlying issue.
>>
>> I'm curious about the intended use case for the CPER_SEC_ERROR_THRESHOLD_EXCEEDED
>> flag. What scenario was Intel BIOS expecting the OS to handle when this flag is set?
>> Is there a specific interpretation of "threshold exceeded" that would make
>> page-level offline action meaningful? If not, how about disabling soft offline from
>> GHES and leave that to userspace tools like rasdaemon (mcelog) ?
> 
> The original use case was defined by IBM [1] (that division is now part of Lenovo).
> IBM BIOS enabled a firmware first mode to handle errors, cutting the OS out of
> the picture. But the challenge with this was how to handle a case where the BIOS
> identified a recurring problem on a specific memory address. The solution proposed
> was to use GHES notification using the CPER_SEC_ERROR_THRESHOLD_EXCEEDED
> flag to let the OS know that this corrected error needs some action.
> 
> -Tony
> 
> [1] cf870c70a194 ("mce: acpi/apei: Soft-offline a page on firmware GHES notification")
> 
> 

Hi, Tony,

Thanks for the historical context. Understanding the IBM use case
and the original design intent is very helpful.

Best regards,
Shuai

