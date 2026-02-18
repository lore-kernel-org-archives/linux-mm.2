Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF615E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 09:18:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 100776B0088; Wed, 18 Feb 2026 04:18:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B8226B0099; Wed, 18 Feb 2026 04:18:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3A4E6B009B; Wed, 18 Feb 2026 04:18:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD1036B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 04:18:53 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 985155739A
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 09:18:53 +0000 (UTC)
X-FDA: 84457027746.07.9B5C435
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1173340002
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 09:18:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771406332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G5PhA/jFK6VAst8fcBhxrpBgSelFc5ok/C3TwYrpw1o=;
	b=QaAxOesXHTcrjNYR4IBV67tW14UydQL43A2OhxcwkPyRJT+QdnAkM8+H3n2oOeYOL09vAj
	MV9A40/xLB8/UOMt/9ozDeBlSUBY5UkXxbjTCQD4R4r1yceehHbBTD2GDKealUMhJ7Ll1u
	m0wu4sCODLxk6hYxayzEG4Vo6TjUz/I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771406332; a=rsa-sha256;
	cv=none;
	b=Vnxnzktm9xtgrmK6hVLj1SXLuWuAGfnm86kuDL0YXJk4xZ7L14TH06b7NYhC8APoNi0G+S
	J4BAznzDlW4rxQpY4ilE5lTiSbf8zEDLjiJDvX082pJ/9avqkoj8qp15Cv9k4a9pVG3PXu
	j0cBny/kumqBlbbkENsQ+XA328cgRdk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B7FA61477;
	Wed, 18 Feb 2026 01:18:44 -0800 (PST)
Received: from [10.57.81.199] (unknown [10.57.81.199])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3B3D73F7F5;
	Wed, 18 Feb 2026 01:18:49 -0800 (PST)
Message-ID: <401402d3-fcda-456a-8fb4-800eb918dbc7@arm.com>
Date: Wed, 18 Feb 2026 09:18:47 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Improve this_cpu_ops performance for ARM64
 (and potentially other architectures)
Content-Language: en-GB
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>,
 Catalin Marinas <catalin.marinas@arm.com>
Cc: Yang Shi <shy828301@gmail.com>, lsf-pc@lists.linux-foundation.org,
 Linux MM <linux-mm@kvack.org>, dennis@kernel.org, Tejun Heo <tj@kernel.org>,
 urezki@gmail.com, Will Deacon <will@kernel.org>,
 Yang Shi <yang@os.amperecomputing.com>
References: <CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com>
 <5a648f49-97b1-4195-a825-47f3261225eb@arm.com>
 <CAHbLzkqRjuWg7ybdkuv5xdoPz7z_q2n+0Eh0pRNoVxq-WskRvA@mail.gmail.com>
 <aZMCAWiA7XHYLIE1@arm.com> <c095a354-5b71-76f5-d7be-536216bf7321@gentwo.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <c095a354-5b71-76f5-d7be-536216bf7321@gentwo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1173340002
X-Rspamd-Server: rspam02
X-Stat-Signature: pmp4j7eor9o1dxwepd8k5jmzy3eo1kdw
X-HE-Tag: 1771406331-209216
X-HE-Meta: U2FsdGVkX1+b0UnGZmjCpwpXrWaTaVd9tGpglyC+P0LrQlz8tOy3FtgpNu85PMiPvmKkLrpWkB3tB0pbcR1PcQivc4lGclyaLORR5zJ2TJK5qpyk3v8iyeS1s1TDYHL9jdgbMC65tcguthQ+InO+xqJX7qm/KXsZ9cq3wDfUovmer0ilqbEA5MGssjs31njWPrDKPUw2YY7uSGZ2UZ24PPk16pGdIS3sf9ftqOYMSMOesXkAC9SOGgayfzTfaroY47bVBPs4/Xu6rjM0KGMEslhAhQPAG60TTm0z+Y22Ptp7v5GmQ9TejYqnZoS6o+5tkIdM5vdLW9oYy9umBn4GOa/1pFB+g5lgfbKigXvkAFjui9TTWAiCLp9iLlYBseRVuNWsg/hWDmSD4/qeCyI64GcTxvS9UY59BxaQT69Qhc4n3OknF1Qtl+ns13AW/qZTHIYLM6rqDNPiXqijsP0yfGA8+0ZktytpZ7gO2hwkETMuB8LNJMgmKI1P9XQad8mnr2Qkbm1aaaFY8uz/FIhik1RTSAx7r94sBi95zTf6N0TZ8xBeLnXNAxjUIaaBb+hfaaJcrH7qjf3JTH8XmWkSqBZB63iZoQyLa9oUJw/3qXwp7T7S3Gt0zmmADDZLecchdcVgvD+BnktYBtXp7RQ/26naaIiw73AIfDAjLeGsqT0d26oxTRCuQPYGPddAMcRmdQYcxR4VS5HD1IdQDSKKG77gXcL6QVbUTZYZ6toDGm8DWJCIt5iycm2T72EAEaiJDJE4rLeX5BDmVNc9AGvkR5M6HrVToB+46GzO27nlVF4obhCc0HF6c9Gdx188+M6C6ofX9mFEfMfSr3e/pTtdmpQ4/P5GekeVg5gKtcGqRU5rzp1Xa15DLgGrIoZVRq+bLwgMO9DuFeAiVlHHr3PVq9DSwh2XFuCgjUjG4zV8VIM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/02/2026 17:28, Christoph Lameter (Ampere) wrote:
> On Mon, 16 Feb 2026, Catalin Marinas wrote:
> 
>> It's not about TLB conflicts but rather using the wrong translation for
>> a per-CPU variable with CnP.
> 
> These conflicts could only come about if each PE would not be able to have
> its own page table but share page tables between processors.
> 
> That is not the case from what I can tell. The ARM64 code does not
> support a shared page table and if I remember right Windows actually requires a per
> processor page table.

Each PE is able to be configured to use it's own page table, I'm not denying
that. It is definitely possible to implement what you are proposing.

However, there is a feature called FEAT_TTCNP, which allows SW to hint to the PE
that the entries in it's pgtable are the same as entries in another PE's
pgtable. If the hint (bit 0 in TTBR1) is applied for multiple PEs, then those
PEs are permitted to share a TLB.

Today, if the kernel is compiled with CNP support and the CPU supports it, then
the bit is set.

AIUI, there are a number of CPUs out there that can share TLB to some extent and
do take advantage of this feature.

Your proposed per-CPU pgtable would be incompatible with CNP because if PE0 and
PE1 share a TLB, PE1 would end up miss-translating a per-CPU VA to PE0's copy if
PE0 previously accessed it and caused the (shared) TLB entry to be created.

So I believe there will be a performance cost for some CPUs if we take your
proposed approach and disable CNP. We would need to evaluate that cost and
decide which of the 2 mutually exclusive features provides the most value.

Thanks,
Ryan


