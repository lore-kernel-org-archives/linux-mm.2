Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18FC0EB28FE
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 10:01:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 438776B009B; Fri,  6 Feb 2026 05:01:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 406DA6B009D; Fri,  6 Feb 2026 05:01:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33D4A6B009E; Fri,  6 Feb 2026 05:01:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 20AD06B009B
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 05:01:08 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 862FB1C7ED
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:01:07 +0000 (UTC)
X-FDA: 84413588574.10.B33D19F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 77CE74000D
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:01:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770372065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SS/I75z7oYhuNvKD6ygSLj5fvp0pNhf0sV+nD0a7oZA=;
	b=Z2I7Pxezy2yABYfgMwDlW11NR+wBklWoyvrUjUVkxhKamUehsZ+eVEv56MEd4ncDaINvo4
	bKsWyxBiBGm3edmTmC38hd4Z3V7GRxD3hEGF7OhA2RPDQs7SJ76d2jGXeOU4MOYFKJpVGs
	Nds0nXk6EpsQ2usaTHMSiao3LZGfZjs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770372065; a=rsa-sha256;
	cv=none;
	b=xeYzIKQZgBtAjw38+X1gmyP3Y1LDP0moe3h99kFB7JKUwg7NnezXASBLIvu5VdpVcNtABX
	CK520axSWo3vFnyy1lc6tnGIA/1FQfL1F/uet+u6rRRpu6BssrXsVzGL8uRYgHRNYnOIBH
	4haHhgR3oxdITFL5IJFA1SJnfDJkIa8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 10009339;
	Fri,  6 Feb 2026 02:00:58 -0800 (PST)
Received: from [10.164.136.38] (unknown [10.164.136.38])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 591633F632;
	Fri,  6 Feb 2026 02:01:01 -0800 (PST)
Message-ID: <15ddd3fb-abff-4a95-9670-06622bd90e1d@arm.com>
Date: Fri, 6 Feb 2026 15:30:49 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v6 2/5] mm: khugepaged: refine scan progress number
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20260201122554.1470071-1-vernon2gm@gmail.com>
 <20260201122554.1470071-3-vernon2gm@gmail.com>
 <fd67a91f-3930-4bd8-886b-13f7783f4aec@kernel.org>
 <CACZaFFNGFWv3FG8spJDLfLTe=0QWuBWL+Lbs+W3h9vGL=jrT6Q@mail.gmail.com>
 <85e8ded9-a9eb-4663-9c96-93af60006fb6@kernel.org>
 <9508744b-e5d5-49ef-825f-eef683892541@arm.com>
 <1a6d8295-e27b-4440-a367-af0432a7af4f@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <1a6d8295-e27b-4440-a367-af0432a7af4f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 77CE74000D
X-Rspamd-Server: rspam07
X-Stat-Signature: wfr17umh6a65je1dc4omxwrdcfuzihto
X-HE-Tag: 1770372065-327476
X-HE-Meta: U2FsdGVkX19Hy+j1zfP59lMwGjluVPKBEFv2HjDUBx98SC3Z+CXQ+GG+dxkpUmmPABZgGazT6Rq9Va3ivKlvewheTfd6Hn0+ohCsp6OBkIzCDP35UrL5zXnnUaOjiOncZlIB1Q3kRCPhNUKisPJ6EwP5Clx6ftqxG9i0YArvaDxi56BGf84E99iYTkTpzoUWM5+sbrqx8AlOukrl9nCOChtThIqHRtcwNWfv81gzniFGVlEOCnzKBgLMXg/WMwqHqj45zLqJIayF8xGTapsx2wywz6Dgc6BG30KZ/tlMU/APdAEVV8eWwOu+zchbIMEa2BxciElUomw78G0c1N0sNqcaoCdbvU5OYBD/UHtD15i4lBQzrXmly6qqccll0MtI04zFcNVkgYP+O67/uUpJtqw0nDslCe2apTBLjuEsL30ZhElC6wUD1tPawQKrCEnmwcHaw1bFS2poavMUyUkYN0d2tJVLcU154hXhL9hDDegRtYfmtkXagoIFvoOnCyHG9YLpDSWtX/1juXG0Wbu2r0uuS3TvD9bJxYa/E9ToiEJl51zCpTR8wEm71Jr0vOTQnvUy1O/MLCVwS3wQRwN3f+pd6VSXFWZt98NUXPJois4hZv1IOYdE0s/MxR2/gRRLtGarsh641Ijyxf0sfQlIUAD/wnLuEDBsFX17etSY9m+RsIZvHkqhROiynwJ7eyaA53aSzeng6AkBV2L8DVuVEMVxdAa/wFrhpGWjyXcdljb+D597evKNsfHva/m3BI3AkL6l+xCqjMXaOCOD1ylWcFjWSp6L6LcRN+U3N9lOrBFUaeIjDe7dXThp+gg8KoL3Ml55qDvbub79wxdMMLoOoeXmzYvrJ2ewVCfkSsb8Iy7C7gs3rgsl4gGz8sHY+FlmT2Rspjz56Jj5GW444RaRa/K+Q033XZWe8QZJMyK0u95qrLR/StGrdsPaUymKX0h3gHDqk45QfpQ6vBBLR7u
 oGzVamY2
 djSiI9BJZOQ6Py+Jd/DK+LL3PgvfjVSR158MxBVpohykkeexXl0FvEgEhyFnuHHuKX4MSg4tzwwJQNdWZiYofWZajTGw5uh87J5deSDM+T0k2dYTxb3BuPMhNxbQSqOMKkhFqAIznM+SEPqMQjxAUI0rAopLs27t/QT/Yt1I6TOuyqhNy2nMH0dAg1BBSMnpVbOsl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 06/02/26 2:32 pm, David Hildenbrand (Arm) wrote:
> On 2/5/26 15:25, Dev Jain wrote:
>>
>> On 05/02/26 5:41 pm, David Hildenbrand (arm) wrote:
>>> On 2/5/26 07:08, Vernon Yang wrote:
>>>> On Thu, Feb 5, 2026 at 5:35 AM David Hildenbrand (arm)
>>>> <david@kernel.org> wrote:
>>>>
>>>> I guess, your meaning is "min(_pte - pte + 1, HPAGE_PMD_NR)", not max().
>>>
>>> Yes!
>>>
>>>>
>>>>
>>>> I'm also worried that the compiler can't optimize this since the body of
>>>> the loop is complex, as with Dev's opinion [1].
>>>
>>> Why do we even have to optimize this? :)
>>>
>>> Premature ... ? :)
>>
>>
>> I mean .... we don't, but the alternate is a one liner using max().
>
> I'm fine with the max(), but it still seems like adding complexity to
> optimize something that is nowhere prove to really be a problem. 

Agreed. Vernon, let us do the increment in the loop then.

