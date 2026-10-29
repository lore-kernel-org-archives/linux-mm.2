Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35EA6606A31F
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 09:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=SKkaSY8C
Received: by kanga.kvack.org (Postfix)
	id 5E8886B05B4; Thu, 29 Oct 2026 05:47:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 599806B05B5; Thu, 29 Oct 2026 05:47:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AFB46B05B6; Thu, 29 Oct 2026 05:47:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 285556B05B4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 05:47:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AA2BDC0339
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:47:14 +0000 (UTC)
X-FDA: 85375185588.09.BEBE776
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1E161C0002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:47:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=SKkaSY8C;
	spf=pass (imf22.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793267233;
	b=vPf8ovJzmrrQcRLEF5h+yXq1pCjpPa/9nTGkRuJAo3Op9A8ZeMcobdWUGWIj5LWrCcHZ5g
	hNoAHzc0tEueHFXsgIR3bJAjKsVnu95L21iIoKg4glx9c91FmiV9XTQ0QK88uhdBPbMDSR
	hpOvWcPiejCwj+cVkV1e/vCfkXOwqJQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=SKkaSY8C;
	spf=pass (imf22.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793267233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F4gvnh7LFe+Aif3PBPP0ropSW63VFqrhI2+JK0JsQWE=;
	b=nnexWYPqOhvjlxxL4C36WANbZAvdbdchRXRXKQfT+CfqvGHs49m098DgzaZi5+YRD7nQ5c
	RcEn0lf8yHwd990uBjOH3eVng3um62vSFQaGkOzRP6cqLjGmCMppuN0dvGevOczepE/ryt
	0X/T9EuMeFL7Gx4lvUm4bwj/wd5FQkk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793267226; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=F4gvnh7LFe+Aif3PBPP0ropSW63VFqrhI2+JK0JsQWE=;
 b=SKkaSY8Cr57dDZjYFbF5aGDtSPstlNfCSFJedb9DWTWJx/fSKdPW9k+OwI11XLfztD2olT
 arW7Ec64JknSolPL2Kp7kHZSMJ/Lzoz5Pd+Xrj3jUNJmey+MG9INMbMdoKDJ7wWLmkyKWr
 WBC+eGghbzKf6K92PnJjh5LUeYq+4L0D8CbQCwz2T8LTi3FZ4Kc7KfYj6ovYShTrZGfDLT
 caVNuUwcj1pgcN0gcKqm1cmNfTkxww8sHbNAeeJGmVu5krU9afy4gUPXOHxNoojo14ipAF
 DCBsRhXCj68LjFXMk4IijV0ROBYGXaKpcLYTjJoHvRpZGaw7lheGG6ZY0sHhpw==
X-Lms-Return-Path: <lba+26ae31618+a88bef+kvack.org+lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
References: <20261028041253.74839-1-lizhe.67@bytedance.com> <20261028041253.74839-2-lizhe.67@bytedance.com> <0676993f-c04c-4e4e-9f8d-1650c8fd6d6e@amd.com>
In-Reply-To: <0676993f-c04c-4e4e-9f8d-1650c8fd6d6e@amd.com>
To: "Bharata B Rao" <bharata@amd.com>, <akpm@linux-foundation.org>, 
	<bsegall@google.com>, <david@kernel.org>, <dietmar.eggemann@arm.com>, 
	<gourry@gourry.net>, <joshua.hahnjy@gmail.com>, <juri.lelli@redhat.com>, 
	<kprateek.nayak@amd.com>, <ljs@kernel.org>, <mgorman@suse.de>, 
	<mingo@redhat.com>, <peterz@infradead.org>, <riel@redhat.com>, 
	<rostedt@goodmis.org>, <vincent.guittot@linaro.org>, 
	<vschneid@redhat.com>, <ziy@nvidia.com>
Cc: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>
Date: Thu, 29 Oct 2026 17:46:40 +0800
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: Re: [PATCH v2 1/3] sched/numa: make free-space tiering promotion bypass configurable
User-Agent: Mozilla Thunderbird
Message-Id: <010b2b6c-8f1b-4c3b-913f-cc2e8b957759@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E161C0002
X-Stat-Signature: 3u4sh8gd3cg39m11sfaa8girgtogufzb
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793267231-748689
X-HE-Meta: U2FsdGVkX1/dPBgMbtXjZvNtkFMeoHWIpK/S3QZYSn+eRmaCSoOQ2Kr8NcKQyuS+zZpku9npqlz1FW4n7qEyPz/6+2+zyNkyrHaBlElEbynEYq7mw86A7YKrgR1URT+8Op2sOahuZRrXrmJ9FCd/WwaeIIOS50lYY8KPHtf+9NTSVb6WouOCrHHD96b3nWlgeAqqvHCnGj6os7kXm8sP6rWpbuR9v030sCM5h1HuAEvgmovTpK309jKad9rCfWzJezotwn2P7vHALlOSmRRN+e4tI0tdu+kt/ZMPJk2ZaRr6pgLvbg5JA0+S5Rspm3NnNIZOU0M9iQ53sTxuijG+ms37KQCHbgitvQGhisyUe+NGSZSKixjPRMma0KRE0iREnibv013d8qOzx5f7glF4kM6NTYfJ/PD4cLZZHU0JnSzxtoFxBRk2OSb7wII81YVkPVbzZdCcOygDu9JTopvuglUmff+SZJn0l6RbEK7DHAbdKseKgIu+w05J0qmZLPDKieXtWVYGkqQILbjhLj79Ylohq1yymoepOzUdo4MmzRjTzfqOw5bBj232YlwIBuVJ/HPGi/W0xRpWUxfJHoH3/snrfDPm0/k+Jf3xL0+FbDGZ4WwscCzc8W+CPANGl4T9guNvNUwnZYJR20g9Ypq2gFe7bNziahn+BVW19XmDAFfQnKYFOMnOG2zRxq/TnhGnF4cmNzICQcidDSJI8NDbFwpKwAtkGfPyTJqX1pXhd0XvxuDkPWfAm0CDaFoIZwpcclLAYssqQyleN7udvlbkY2Y1Q2mMsS76W6dCSDpzZG9vcJtoOFYs5uw40ERKDSGyZEgPneF8LgJ+d010cDDZg6lMHXH+q7Yo7VcCGrDybxjJX7JBBF8mo5VuAp2EGNnva+HBSsrwF3IrqGo6X4auuG4a66nP6goB1P1MzgWihBK840um1US7kB/5cXOnRmmSMLpkH9wdpE5/8ZQzsQ5
 3JERAiy+
 mFa48d6aYDrHC+uW2iM5xP+dqkVSII4zRqGbjyA0xOX9+snqYx5LPoHP4FGJeUA21q9gq3q40S4HgNRxcH7IjsTCZq1qJWc2Yg4PkniFLduWHOIuTGv0hvTl2fo+jt/XF0Irom9rJnlMKcnh1gVoNDI1DiWACTmR5iBIjTBnKg0n+bTiew6mTHQz86hJFEfXR4jZXXFUZG1ECova8IZ7n8N+Lb5iaJGRaajHFC6W2evlu/nHvpGAn5PPtW07EISY+4IBCk5TGKYMLxblToycGjQCylJXRhZyxhsI442TjOJXlnbPiXhW5sW7UmN7P1Z8d3RecYZULubtIPafEPbstar6JaJFFJQmSlUFV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/29/26 5:34 PM, Bharata B Rao wrote:
> On 28-Oct-26 9:42 AM, Li Zhe wrote:
>> Memory tiering normally promotes any recently accessed slow-tier page if
>> the target fast-tier node has enough free space. This preserves the
>> existing policy of filling available fast memory before relying on
>> hotness and rate-limit control.
>>
>> That is not always the desired policy. Some deployments may intentionall=
y
>> keep part of a workload's memory on CXL-attached memory, for example to
>> preserve a desired DRAM/CXL capacity split or bandwidth distribution. Wi=
th
>> the free-space bypass, short cold accesses and bursts of hot accesses ca=
n
>> refill the fast tier and pull the workload away from that distribution
>> whenever DRAM has free space.
>>
>> Redis testing exercises this policy issue. On a CXL system with node0 as
>> DRAM and node3 as slow-tier memory, a Redis test was run with
>> memory-tiering-only mode enabled. The test used a Redis dataset with 12
>> million 4KB values. It reclaimed memory until about 85% of Redis
>> anonymous memory was on node3, used a Redis benchmark configuration with
>> a 10% hot-key working set, and then issued a short 256MB access burst to
>> cold keys outside that working set. The cold-key burst mainly touches
>> memory outside the hot working set, which is expected to remain mostly o=
n
>> the slow tier.
> Can you please clarify if 85% of redis memory ended up on lower tier natu=
rally
> due to overflow from toptier? I ask this question because, if it is a nat=
ural
> overflow/demotion, then it will be hard to find head room in the toptier =
to
> allow promotions that bypass hotness or rate limit checks."


It was not a natural overflow from a full top tier.

The test intentionally reclaimed/demoted Redis memory to the lower tier
to model a deployment that keeps only a limited fraction of the workload
in DRAM and leaves the rest on CXL memory.=C2=A0 In that setup the top tier=
 can
still have enough free space, so the current free-space bypass can promote
short cold accesses back to DRAM.

Those pages are not hot enough to be promoted by the normal
hotness/rate-limit path, but the free-space bypass can still promote them
when the top tier has enough free space.

Thanks for pointing this out.=C2=A0 I will clarify this setup in the commit
message.

Thanks,
Zhe

>
> Regards,
> Bharata.

