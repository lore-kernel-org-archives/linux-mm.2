Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EBD4D37E4F
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 15:39:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6397D6B0005; Wed, 14 Jan 2026 10:39:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 611C16B0088; Wed, 14 Jan 2026 10:39:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F3476B0089; Wed, 14 Jan 2026 10:39:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 40BA56B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 10:39:06 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F29A6140586
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:39:05 +0000 (UTC)
X-FDA: 84330977850.01.03F41E6
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf25.hostedemail.com (Postfix) with ESMTP id 25B5BA0018
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:39:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=T7fVHLaJ;
	spf=pass (imf25.hostedemail.com: domain of "prvs=94744532ae=clm@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=94744532ae=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768405143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pAL5cu5jPGbLJVgoDHq3JNHxEt+U9LIWKPFnXJkix+s=;
	b=ngqb2YQePpfVkFXBDm2Uh3nPI8uWDZiEKFPD0nSU6bOmxp8ahDRS6m9WtiHWf73cX7aK/W
	MYBlXSdoUVgzJQwM9ZJjkRz5BfdGysJ+zfQ8+FTAxx3xgdyuZZSrSHFSKs8Kh6kS88PCLx
	8sQ103LuANmiYAahqPGgrD7DBFXZsWM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=T7fVHLaJ;
	spf=pass (imf25.hostedemail.com: domain of "prvs=94744532ae=clm@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=94744532ae=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768405143; a=rsa-sha256;
	cv=none;
	b=l9CR7K+Bh2NVR0gGMCXNm09Bdg0LOYng7QRBkZjLTQ6hiiA+GUaoRczQZiJ6VJguMVQ/5Y
	iCENA/d4+5+BMHRtZc5MjN+OoHzCZsMIriVqmYWYrbCD9qL6ibMiwc/3IEedAHDiQEIgTZ
	G/SOgji7Diwsd9XqWnsVVTHxcWhsU6Q=
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60EETBUs2381891;
	Wed, 14 Jan 2026 07:38:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=pAL5cu5jPGbLJVgoDHq3JNHxEt+U9LIWKPFnXJkix+s=; b=T7fVHLaJqFWb
	qNp7T3jGnrH5DaOOZo8/WmdNic9a8xNKfY4+lZqVUP2EOh874OsP8CDYOPtknVJj
	intIllHZObsNcomFNdFlw5kpYZsaoJ5B+eSPwJsJ0mYB3VDKGTQzFqaGr5YAR4t7
	5m0OtJTBDgRJoCkQxr3CwDi64iOUCzOlJmkc4pnr2oYEtRhA3r7T680KLEjXdSJk
	3Sy4LbKlEDw5yiPJ8VrNx8ptYQT8T/A2z+boNSwgZcDEUgs16k4H18tSmgwlPycA
	V3zizZnga+kwHDe9DJpILu9iL6/Tx7dqMIXhti7xpeLJJN8eQMRrDGJ0rofQOP9C
	aYRIURueJA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4bp0fywpv9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 14 Jan 2026 07:38:40 -0800 (PST)
Received: from devbig003.atn7.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Wed, 14 Jan 2026 15:38:04 +0000
From: Chris Mason <clm@meta.com>
To: Jane Chu <jane.chu@oracle.com>
CC: Chris Mason <clm@meta.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <stable@vger.kernel.org>,
        <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>,
        <linmiaohe@huawei.com>, <jiaqiyan@google.com>,
        <william.roche@oracle.com>, <rientjes@google.com>,
        <akpm@linux-foundation.org>, <lorenzo.stoakes@oracle.com>,
        <Liam.Howlett@Oracle.com>, <rppt@kernel.org>, <surenb@google.com>,
        <mhocko@suse.com>, <willy@infradead.org>
Subject: Re: [PATCH v4 1/2] mm/memory-failure: fix missing ->mf_stats count in hugetlb poison
Date: Wed, 14 Jan 2026 07:37:47 -0800
Message-ID: <20260114153749.3004663-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260113080751.2173497-1-jane.chu@oracle.com>
References:
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c0a8:1b::8e35]
X-Proofpoint-ORIG-GUID: 0eQgpU3jhXliYXyCog7oiydOA_WFBhGB
X-Authority-Analysis: v=2.4 cv=QKplhwLL c=1 sm=1 tr=0 ts=6967b881 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=TZCTYgXrSeyIqYBwcG0A:9
X-Proofpoint-GUID: 0eQgpU3jhXliYXyCog7oiydOA_WFBhGB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDEzMSBTYWx0ZWRfXwribbCof2dL+
 wsCpW9qYgWRbKngq9oNe1iNWe9pEa+q7VC1ZstItuI7wUB3PeWdiZEskNkHFWm0LyKlFrvFtUt3
 0W8V/QmrFUjLq0C2ymCa9xcH0dI/QVS9QLVCW8Fsf4uX5FBDRYZIVG0I1fg/GQRsCOm3RonKtqq
 vm060xEGZs3F8wMSbJrisrwWPGn5SWG8i9mSEQb/cgjE5aUyqJy/kaYr/ePWA7P+qX7m1zr7otd
 msQ0vq/25VMXTn3KSKGtnByMGayThaXUySPA0Npeyrm1MWz9b7ThWEbTkUH9xjBj371HczlufFJ
 g8mk1H0zWk6F9n0iXczj7vZqfxsDsvZMW4hCDi2Pn30dmg3jQyMHY+lQGQDUkNCoMf+Y//VKItb
 AoCIgdENAkfJDIiH8E3ucH84eHQ6HnPPMNwWSxbozAVLaleBWZWLccW7gbNQfTBnPjx3A5exEpe
 fHWkduDXAdWDpLdABtA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_04,2026-01-14_01,2025-10-01_01
X-Stat-Signature: qa9hiwi968ra6q8s85sxead1apx3k7bx
X-Rspam-User: 
X-Rspamd-Queue-Id: 25B5BA0018
X-Rspamd-Server: rspam08
X-HE-Tag: 1768405142-897813
X-HE-Meta: U2FsdGVkX18UDPSABESpXQlwOjBVzaXgQJfORQpd/ben5WBsddJVin62AcLCTrGnfxmPheZ1y2lsCmCsW5FaAJFBx2HapMlC7MM9klCikxiAGoTmEOrHH0fcMQbFHWprK2pI72L7YFJ30QUUzSHF+ZAHkgTtgxnMJLU/o4gmf6iCc0ytN6cbEC5UDUQa28yNLbXcMsgOarJGws6+KSLaFJK0/zB5JbVf4Djad4Xgv7zZUR9ENipMFpMA6fvczLcY4XBQPyhwiB6i6uiRmeClNqvQshePXHrOTCx/IGjmKouVknqdL0lv4HZGDTMBXEmHznAqIulfv61W7/G3akRiKa3mhHOnND7obdrPAIVvrrS0dlg1V5bM3wE70dASfHcCAGjIyFT1tzeRox5XQZdpPvbo+djWsE/CRKct/XDIPlym1TrZ4JEpMg06tPY3TS5wuSWMYMBfjWbZLsLbrZCqZ+AUzV4JWqJ5IPPXbVAAtW6rdFqIHMZkra6VTY+Bv/lIphOchab1aTgZ9gG3+LG8h7gUqDe3BLne0d40ysOrEaPXZmEK0eJsSnOwlycs+5tF7nidDnoPAxT+YER2oPm6fMFOQLhGIBn/K73IQOQAjJdfy/O2Com3FNVMam8lgs04WuHZe1B2LzcE/pIj+ysICqQF7awNFibJwuStOBEjDbpcIk6sgWlWDFWSdobdWMfc1aVZm4x9aJo1U9cBgo0x6oP6FgJtdAlAgl8VrZfzLRsMdBvkjkqc1D0jZ71e0NIOuJI2wZ3krYJOwpEdrGNkDvd45eDYdmof+bWL05Ha57IujzgJjAa3K673z2tzChgy/uGW0vr6mLQcXWdNhpVlnfU784JZBL3BJjCk3xx5reGPBIAjQFJi/l5cLp/4AcDsUgqROzvsiUtxtc5h9hLKd/cU+h9HvNLvryai7lYldE7Gdlv3lfKmailw1KBBXMYeOJFTQS/HB/VYbWbGU6l
 vzwn/CXE
 g743xVas+p9x0kxXz/AZIdydry1WlKJygi/IXfHnob0jiaIM1pxBHwmrlQFTpkYVucndeY1kbBGmmCyueWcfjgXWHNGLlRt9orIAw0wUgFu6OETMynI5tCYZMV3Tgt9dZhE5h/2MGaIdkJprgwEMQhzxqGApjjSQPdhJ/U+3IWJmNWuGurVBBnW7y7gjgZT/KeO2zlRb311SduxfG7LJVGfoQV8mz4T8d75iZO6PQocObjN1sn+ej1z7Ren0TswQWUviZ71/y+nydI4Xe8BETgha3aZgtK7LoIPFlxUu6n7G3q42gpiG/Ht0bsJ9wuHAVmXMNM6ky4lFjlQYyqVk0VWxux/9H4YVwaQI2LJJMh7EA1Fmxi4tgPRCM3vkQNYXxH/tk/V+F7beRczFK5uY6AReg5kn6FULS6qDXaAvld96P4HRJoy0JyG/Zf3wyeWjiFT/r
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 13 Jan 2026 01:07:50 -0700 Jane Chu <jane.chu@oracle.com> wrote:

> When a newly poisoned subpage ends up in an already poisoned hugetlb
> folio, 'num_poisoned_pages' is incremented, but the per node ->mf_stats
> is not. Fix the inconsistency by designating action_result() to update
> them both.
> 
> While at it, define __get_huge_page_for_hwpoison() return values in terms
> of symbol names for better readibility. Also rename
> folio_set_hugetlb_hwpoison() to hugetlb_update_hwpoison() since the
> function does more than the conventional bit setting and the fact
> three possible return values are expected.
> 

Hi everyone,

I ran mm-new through the AI patch review prompts, and this commit was flagged.
The review below looks right to me:

> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c

[ ... ]

> @@ -2029,22 +2037,29 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb)
>  	*hugetlb = 1;
>  retry:
>  	res = get_huge_page_for_hwpoison(pfn, flags, &migratable_cleared);
> -	if (res == 2) { /* fallback to normal page handling */
> +	switch (res) {
> +	case -EINVAL:	/* fallback to normal page handling */
>  		*hugetlb = 0;
>  		return 0;
> -	} else if (res == -EHWPOISON) {
> -		if (flags & MF_ACTION_REQUIRED) {
> -			folio = page_folio(p);
> -			res = kill_accessing_process(current, folio_pfn(folio), flags);
> -		}
> -		action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
> -		return res;
> -	} else if (res == -EBUSY) {
> +	case -EBUSY:
>  		if (!(flags & MF_NO_RETRY)) {
>  			flags |= MF_NO_RETRY;
>  			goto retry;
>  		}
>  		return action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
> +	case MF_HUGETLB_FOLIO_PRE_POISONED:
> +	case MF_HUGETLB_PAGE_PRE_POISON:
> +		if (flags & MF_ACTION_REQUIRED) {
> +			folio = page_folio(p);
> +			res = kill_accessing_process(current, folio_pfn(folio), flags);
> +		}
> +		if (res == MF_HUGETLB_FOLIO_PRE_POISONED)

When MF_ACTION_REQUIRED is set, kill_accessing_process() overwrites res
before this check. kill_accessing_process() returns either 0 or
-EHWPOISON, so the check for MF_HUGETLB_FOLIO_PRE_POISONED (which is 3)
will always be false in that path.

This means action_result() will be called with MF_MSG_HUGE instead of
MF_MSG_ALREADY_POISONED. Looking at action_result():

    if (type != MF_MSG_ALREADY_POISONED && type != MF_MSG_PFN_MAP) {
        num_poisoned_pages_inc(pfn);
        update_per_node_mf_stats(pfn, result);
    }

Does this cause incorrect counter increments for already-poisoned pages
when MF_ACTION_REQUIRED is set? The original code called action_result()
unconditionally with MF_MSG_ALREADY_POISONED regardless of whether
kill_accessing_process() was called.

Should a separate variable preserve the original res value before the
call to kill_accessing_process()?

> +			action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
> +		else
> +			action_result(pfn, MF_MSG_HUGE, MF_FAILED);
> +		return res;



