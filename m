Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CEA3CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 06:53:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9BBA8E0009; Wed, 15 Oct 2025 02:53:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4B618E0002; Wed, 15 Oct 2025 02:53:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B615B8E0009; Wed, 15 Oct 2025 02:53:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A51F58E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:53:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 597371A0B32
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:53:09 +0000 (UTC)
X-FDA: 83999431698.03.94F1BC2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 36B9FC000B
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:53:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760511187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vu9J+yL0LAIt/y73bGU7MSCpwr4SHfKaZaqmf3lX4uw=;
	b=w9CLIrZjimlGgCLbu1zEqIp4eKWP5gBqzV1lZmy1VS8KM2NC9kCYDZJ4LirVZL5Qcm1EAq
	z5gomWbmO0X7JomropcBWqjnGVOupeZrNDZqtlTSJidTHHIOsWWpEmlrx6148AAYSHNr0r
	zG6jDJe7P49MB9vXSb+iBYsug9YP2hg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760511187; a=rsa-sha256;
	cv=none;
	b=scLs64Y1csFDBXXfcDjNLRB7QvKjLGBQ6TUoFu921B++GcgjdhPP9ismK1a/9aCmxH58/x
	uZrduBHB1b6jseG5QBRhXiWao6kYWvG7vlZcwf65NhPuh0CxfCzQAfJd/ofcIZInN+YqnO
	ukq17JGYAAfB261GCypYJVS8+9gVR6w=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3AFA21A32;
	Tue, 14 Oct 2025 23:52:58 -0700 (PDT)
Received: from [10.163.67.182] (unknown [10.163.67.182])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 627503F6A8;
	Tue, 14 Oct 2025 23:53:00 -0700 (PDT)
Message-ID: <32ad68ef-a306-4572-9554-7200e06f78e9@arm.com>
Date: Wed, 15 Oct 2025 12:22:56 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: fix comment for default scan sleep
 duration
To: wang lian <lianux.mm@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Andrea Arcangeli <aarcange@redhat.com>,
 Rik van Riel <riel@redhat.com>, Wei Yang <richard.weiyang@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251015064333.31274-1-lianux.mm@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251015064333.31274-1-lianux.mm@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 36B9FC000B
X-Stat-Signature: az5htpweonbq44rresbpzsmida6prg5b
X-Rspam-User: 
X-HE-Tag: 1760511187-96309
X-HE-Meta: U2FsdGVkX1/7B/9Sg9NarNgJvO2S1Ur08j1yXVisQ5yAet89lNvPfzvm+Bov57brxRGlUIq1zMsKPQxIgPUIetCzLViqmfKMjwGgv7P/2j22pyNiLcnnABCgrfQ9I3OCHWkL4430Fy9l9cTTWh+rxYBfObFuhQbD+K8ly/gkhM5sH3rz5hDQIdsHlNIzJnvBFEQKq1JR07w2owHqemH5mGCYLimSvrcj+qGEMRuplC4J12OuFDh8VXKhFLHZY+EZJKMQTjkJiY69z4cyq7QfLO0hOwX55ZlRwZVEZD6gDldMkUCQmNkLJp55mezPwkA41LFUki3AbZMWlwo4eFZaUlduOCo2XNarF3HcCv+YO5J//Kfc1NAV5vHummQOfB5BnMq7o87zlbzU4G7cGa+cf21Xempv0E+JTHRLB1RLRjUW7QEVp1wkXR3bBYwHRp5Ue3lIseV8w5KxVjf+nxa132oqEGRn3zKp6cn0ZF92B+EA4vYeMdlAhFP9++sLTADUYE0N+PRuyIIGN2kw5h+Ghopu0VP7BD95IZfYSoF5sCk0BWr6Yq6Opyq7M/zSGR1VQ+s4JGEgZ4iW1E+D0DCPVq+dA7/PGeGYm9SUK8S/bgMJL9ofvXG61wV5kXAyil49FiqYb3iA0JkHtX6cRHjAWZEgG1R3R6NbRwwaSOIrH44lmKsTX7/dWcWycJuPuYfnrNudd1WFTFq3i1FzYosdKkV4Xn1K0BxLv6DND0y8BY/NPQQ87TCHiUB825sgJkerVqdn2gHxmGqzxekxHwCpGxYQkj2djrdVqyhGEHJqpSImat5yeZeZPlryXYBRyi8jPhTO6zMDaj6z7mlfwp/Xkcst/0uZy31MFLzVJQcdnnowiKxJoPWflW8aL89c3hmQynTuQ3masq9rSVyo9bEBNPl52Lq5DmQxkZv1wcYgPMMmXAAOkBTe/TfiFcwFTxllGpCCTBw+TulwfCGgg4H
 XC4Fjc6L
 HtKjfuk7EM7dmjwnimkGhyGUGn89GZxsTFXxVeaHJX0sJiLvPpHzC0O/LImt1jyuc2zOq7rJJP5UNOm8obB4A8L32H5NA1PM4xoB5y08IMB1Vhw2WsAxcTQuMHgiN3ttncw5R5sB/6TM2jX1Zx6wGO2nFvVe49m4rgo+gjQW7lHn6WR62/Von57sfPGtB5KvePYVQbCNLMem/RB7t1jmaesbzIeuZtUe1rK3NOqCdtNqBeftuoyGif5oEWEuLj7R3dG2uf9w2cRZre94NfkCDBiW4zVr0agsvTCm+4+p8tIsucRg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 15/10/25 12:13 pm, wang lian wrote:
> The comment for khugepaged_scan_sleep_millisecs incorrectly states
> the default scan period is 30 seconds. The actual default value in the
> code is 10000ms (10 seconds).
>
> This patch corrects the comment to match the code, preventing potential
> confusion. The incorrect comment has existed since the feature was
> first introduced.
>
> Fixes: ba76149f47d8 ("thp: khugepaged")
> Signed-off-by: wang lian <lianux.mm@gmail.com>
> ---
>   

Reviewed-by: Dev Jain <dev.jain@arm.com>


