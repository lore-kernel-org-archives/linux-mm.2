Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD9B5606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 07:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=MbaoWJUv
Received: by kanga.kvack.org (Postfix)
	id CA9046B05B1; Wed, 28 Oct 2026 03:02:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C59A36B05B2; Wed, 28 Oct 2026 03:02:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6FF66B05B3; Wed, 28 Oct 2026 03:02:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 951ED6B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:02:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9C43A1C4649
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:02:26 +0000 (UTC)
X-FDA: 85371141492.19.546DE33
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7E9954000A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:02:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MbaoWJUv;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793170945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YqMDWZaaRapM5JJzBgdWWKkQQCkL8Mdt/SJ2Z6FiaTw=;
	b=HZnT6GVEx/aCdlAOk2LyLtXAsyF8BmvpA7yHeWFaZbt6F01/owsYzBJH2oxNCPmGWADrut
	FI//W3VlHcL4H81swGgcHmUofHEt8WKz2JL4bu6aH0Z77tgVxYCVtEbDnlBXNadwjooSaU
	3ytGh7tn7zjyIYt2yCnylS+7V31tFFc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MbaoWJUv;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793170945;
	b=0SjLtN/+6TnhC+2dHLjN4ebGu6PY+UUgsOysAQuW/TgB8scwikKemyN9LinpPH8YC/i1La
	mSrMjM14sG9wZTh+YJhHL0PkmBlUifTEkyYu9P5hpZFT+afoJ5qpKZNvE8tcNjyiTG4HVS
	5lMuQNjd4erk/kJaqRou0+PrCH5cnUw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 29D7B1756;
	Wed, 28 Oct 2026 00:02:20 -0700 (PDT)
Received: from [10.163.164.200] (unknown [10.163.164.200])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 496EB3F673;
	Wed, 28 Oct 2026 00:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793170943; bh=pHcA5AF4V+BVk2kWzI92VbLUecJ8ewRtrlSehqaLj/s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MbaoWJUvhJDQbHFVrjpOxDE3CyORMGTd3NpdK/61gpkc0W6MuOUM+EZjeoqpLLM74
	 wiHQ91S+/66UxUQoh8QNkfwPgxgFta+DxLovi1npFjhDzue2RFhZH16rMP77tXmAd9
	 WLBbYQsnwaWmIv5l3Tz5js3XaGuXuNUGXp6hND18=
Message-ID: <adc41db6-16b7-449c-b883-8b093309db8c@arm.com>
Date: Wed, 28 Oct 2026 12:32:14 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: page_alloc: make defrag_mode retries follow the
 promoted order
To: Kiryl Shutsemau <kas@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Harry Yoo <harry@kernel.org>,
 Usama Arif <usama.arif@linux.dev>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Zi Yan <ziy@nvidia.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 kernel-team@meta.com
References: <20261014202936.GC371161@cmpxchg.org>
 <78238103-3a7f-432c-b1df-bd14d7cf4bb1@kernel.org>
 <atDMN5MoGrwJNpAj@thinkstation>
 <4aa14b41-9b89-494c-8825-55fffd5a541c@arm.com>
 <atiCG2iPrHwDznSZ@thinkstation>
 <d2b8edf0-39ab-4a44-bd0d-58230dee2fad@arm.com>
 <ats7oFM-fsYdUS8y@thinkstation> <attOFXch_TchIfEv@thinkstation>
 <atty0n4UzTfI46eN@thinkstation>
 <0757f1b0-9af6-417c-a4cb-eff0b05ba277@arm.com>
 <auCDnqJc7fsBpUW2@thinkstation>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <auCDnqJc7fsBpUW2@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7E9954000A
X-Stat-Signature: 89ks9kiuwm1xx64snwxfper854m47rcw
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793170944-990296
X-HE-Meta: U2FsdGVkX1/dBlkDjsR3FsMjTGJvMca1TZTBRIDswf7pU3jWY1hKtzVNVyckhrKtbdE4roEp9b5netz12ZBS+RBUmQX0rcBIfe8niHPkfKMyML+A3pD2cUecSM7ARpdXJNXp2JluGGp4CS41qShJrAuHqnW+vfoIZ9vVLVOeCgHP9GCBSUR2EngpzEYA3MsQKeHQxm2NdvjY+koKxS6pb7+d7igadeufPwnrAWyYj0Ob2xyIzbB/4mjR+yAfZGPjogpKUQkvHw2/Y9RdD/Pe80gWqxqUZ/lXcxyB61zlyx72TFH2UU8zeVQo9vv2iWYYYJwgPm7Xs7NI511hQFrPKeaJ/PJ7VcwyDF4zwZTYvOBpsfeSBsOamDy9XISSjzYfaDL4qkgvgk3oaPdvTZOTrRFR3hJVq7fGu2sVxSC2E+7+6yjcMIF7s1EvVow0H+XPsiKl0S7CdPgGAcXVy8TmU2qazoras6pDJbLACWCD/MIaOwJRZjxcu+0TNEHirnKKNVkxVyJnq7cfGJ8uOppE3gUZU+lhvIercDldZg8Hl5nAaLuwmKuEXkWFNohaToH/Oqh+fsYApsXAJOrMmZWNJCa2ylfnfyXaZHRaWKbBfcyBaT75N/JiosRBb6qP0XqEcuh9zNYMZ5KT7lzaWe4P7GO1aXZUHs2kbkZX6JFpoK36txs1GMBsh0zvAXu/AsuRN/7qbeojf8U92HSgUusTy3G9EjpN+eP4ymL0go3drvPl5nqtdYdRlAbl+15k6AsTK4WiRrhTQjka5PFGxgVCzrAiTn4krdS1G9zEN2RL0G1vqq7Hh0wUrZIu290bUjfIGULSWvfvIOfyhW+4mgHPnzwlh8fIIeK5yt+DBKu1tYfaJ9zT2K0KU0srIiimXdK4bvSr99whgFaUC+Ej9JDIhUZ1Wl1tXF+HRA1jXu9ZIqz+mRkrCRHsnnDTpXVKAVvqCWL7pvpSM6bM2DO/7T8
 K/COoGOC
 THBvwifssB6Xybd3uQbZYEpw7e212nc8nByy8qkSAO9hMKy7m2CX4CPuqtCPezCppOf5VIwubSUW/x9BK9BU8OJnne1cXCGOISOeoKb+yzjUnjJdV1Wnd3MXkS43n9Bh9+DQOpoeFFsF1dGIgFDdN6zLr6k69DfWruzGTJfUgzr8h2WqA8GTUkc9jEpQ0d1Ap7IDXdCsoGo9VOVOZpCIiG9FW2xbcW5nkk/Gi5w6S7Nys8z2bCWDlqbovzLPKYGCUl2IdMiXWxzi5tP8K4JKneChoncbYKa0NLirth7DpBaswj6fI04sSknAEvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 27/10/26 4:30 pm, Kiryl Shutsemau wrote:
> On Tue, Oct 27, 2026 at 12:42:12PM +0530, Dev Jain wrote:
>>
>>
>> On 23/10/26 8:16 pm, Kiryl Shutsemau wrote:
>>> On Fri, Oct 23, 2026 at 01:12:02PM +0100, Kiryl Shutsemau wrote:
>>>> The diff below replaces the previous one. It needs cleanup and splitting
>>>> before it goes upstream.
>>>
>>> Proper patchset:
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git page_alloc/nofrag-watermark-v1
>>>
>>
>> Thanks! I applied the 3 commits on top and the results improved a lot. Your patches
>> make sense to me.
> 
> Thanks for testing.
> 
> Can I use your Tested-by?

Sure! Do Cc me whenever you send. I'll try reviewing if I am not on vacation : )


> 
>> But still, I see more compact_stalls and a worse compaction success:fail ratio. The
>> limitation must be by definition I believe: we still won't be able to use 64K blocks
>> from non-movable pageblocks.
> 
> Right, that is by design.
> 
> defrag_mode keeps the free space in unmovable and reclaimable blocks for
> those allocations, so they don't spill into movable blocks. Your 64K
> faults never take it.
> 
> The price is that defrag_mode needs more free memory for the same
> workload. In return, the system does not fragment over time: huge page
> availability stays steady instead of decaying under load.

Right.


> 
> The benchmark runs right at the edge: it fills 99% of MemAvailable and
> then faults another 20% in 64K. defrag_mode=0 takes the 64K chunks it
> finds in non-movable blocks without compacting. defrag_mode=1 has to
> build them inside movable blocks, and with memory full there is little
> free space there. So more compaction, and more of it fails.
> 
> The 64K fault count ends up close anyway: 20.1k vs 20.7k in my runs.

Yep, the issue is that Android folks may complain - they observe increased power
consumption due to reclaim stalls and compaction stalls and would like to
minimize them.

I would really want to see defrag_mode become the default since it attacks
the major cause of fragmentation nicely, but the assumption is that compaction
is a free resource, unfortunately on smaller devices that's not the case.




