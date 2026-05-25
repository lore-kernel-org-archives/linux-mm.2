Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67F80CD5BC0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 07:33:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9C516B0093; Mon, 25 May 2026 03:33:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4D226B0095; Mon, 25 May 2026 03:33:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8AF86B009D; Mon, 25 May 2026 03:33:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A5C726B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 03:33:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 748731C003F
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:33:17 +0000 (UTC)
X-FDA: 84805126434.29.7DD94B2
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf15.hostedemail.com (Postfix) with ESMTP id E6F3EA0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:33:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="r/SBF14q";
	spf=pass (imf15.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779694395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yqm4rDNS2ankd/7t9g3YNTaGGMsLoyuj9qmOESSwm50=;
	b=q5ARQ1hDim/0CjCyYrq8VQ4iF+NHOFpzoOTCEHgMziwiL3VrMIEOY1jYawFfBR0XlDqyTZ
	mPFElxHevSkjzsiA6FNoAw3y85v/B8JLj9CTAs7RKxxsvr6E9HU34gzCu0zVNxJfND7uFE
	REr370mk7rU2qEvJAhZwtQpeWs3REig=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="r/SBF14q";
	spf=pass (imf15.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779694395; a=rsa-sha256;
	cv=none;
	b=UQKeoMX93EED0gs5MbeL98kd/0dixBvNpZiYdNgf8kkvlZCIAai4P9c4UCk4Vy9JS/dPDw
	KopeMzE+74F4Lke4WWIYBSYSAaEFU3Ls1pmZDUA8TO8xDjnR65SlvCZTVrtHudGh+72Z9x
	MDT9+AUaQ+d1sDD7vPELrrFAaqtjOQ4=
Message-ID: <4ae038f0-cc33-4a60-b59b-ae86bb541735@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779694390;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yqm4rDNS2ankd/7t9g3YNTaGGMsLoyuj9qmOESSwm50=;
	b=r/SBF14qubxprE8KtVNF0U6NxZfGNaN4kuZlJQaoTggj+nElvUGC6F/tdOwKbervVT+WQW
	FcHRP4lgkt7/yzigSfKqaFwAhT7WOQz1FVDDpKJWQ/DAYX3jnKU1yMdsp32nsf9NLzNr9k
	ZqKWM+EXClfz/oP5kcTDAeUIYGzpKGU=
Date: Mon, 25 May 2026 15:32:20 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 0/6] alloc_tag: introduce IOCTL-based filtering for MAP
To: Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Sourav Panda <souravpanda@google.com>,
 Abhishek Bapat <abhishekbapat@google.com>
References: <cover.1779471082.git.abhishekbapat@google.com>
 <20260522131108.f972659717367c67082f3766@linux-foundation.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <20260522131108.f972659717367c67082f3766@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E6F3EA0005
X-Stat-Signature: qft3t6e4ywduadztaphc8aan9ndeojpd
X-HE-Tag: 1779694393-375704
X-HE-Meta: U2FsdGVkX1+dn9k1lMtXhJmUQtrXFgt4E0EB74qVu9K3VujG7ga/y+fYwPe/AyCnCeEfv5w2n0lMUnkpZzfvP+vNO1sh3QPSdejI/kjdnhQjxZ5fXFjnlJT0tB+u9uvt73f2S2MCh97O4hpg3fy/IylyFBoxJ5lph0u27Hj2Sa0EJIm9hfYH9g1lArZYMUB90AsMnp7GDjnP1oAyEbitx2d68wba9YTMrdzYFV3ioizIvfBqmd2u/NIuvvbm5yIPkmwSraYz2dcDGuIY0MeEJOWtElHQwDwZ6gUqlIIXM5uK50xnKnH/4/4483EUyngleMXk0gj+HIbpA3WQPGehNvtV3Tl2ywZOJYhUkBmMiksLxHaTv+q43qu/bEjWJV87UZ69eILF+/kiZq1pmrUeMF1jps0N5bdWUq30JZKCh81lahaAyeailkiT5XfJlJJDz05lSSfAEO3fSjzNyeseOkhXhdNVWyjVeF++pxMtdh8auafh+W9qQR3og52FFWzmhrR2V4423So3B9H0BDYiTk25dgc+wee7U8HPQ9rKdrXindnW2xbOgqNtKmxPq+6UPgBwAxF24yHYumJZ14QshTynLV8adqrIpKE6GweN1fk+/bANZ0ZyFAwwQXr7Odd+SiQhzqjRggZMyZWeKiCG6OYS3aThySsNSRmrI9OHraUTj8PQJWloXiNPKJFLcOVClxD4BQbhV9sqgMDWjtTWtqNOZT89vSD0RWJlXDLpucUCPBy7loQIB6VCUSrNa2F6hzrlH8rOU3CFLnYlW1FfPXo4wVbNgZnyAA5d39T2Q9E2dphUqU50lzEhD+mZN4bIcTNT8YyDtPeHb2l97DBdzh+983MHVvESUX2zQF9IlDhcSQv5oxj5sB9MKI4RUrNzer1w2+fQ067iSyhRo34gL+Ss/S3QAEIjy+0BBzk5H6qUOzzfA0a1Pa7icdJo0lYEj33l1e1VDHK9Pq1vmcR
 lZZtIhjg
 n/mr7oUe/TxgNaAF2ExzyitrnNu3PhWtgOZdnRnxumUmw7ojkhkWrgditpsUHXljxRtD5Rh2YECOoh5qkwagZ0z2IxzkPhRN5jutMZ+SRxn3VvEB1/ZF4bpnQXCfLSWv0lVUqd80oc+CRMtn8XYveLpAm51aONbP6gRtawKun+5L/S2I3Or9Q9yTI3LQDzp8hTYk/lgcqCzKI0XcUpN8CL4HF+fqUVEPy5x1ZfPxJkLn+YRJTRYv6kp9JVg6RW0u83hSWyom9NYT3DowxQ3szm5Po52L+h2R9Rz5G+gz7FNO8sNJzr1mjsg6e9jcUp2HJtSoal5OdzPpHV/r7oyBwNfhZ6OWAR4AKUpvFuWmYx4xAgWsvH8uXdJjeB+TVX1D2A/FA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew and Suren


On 2026/5/23 04:11, Andrew Morton wrote:
> On Fri, 22 May 2026 17:45:32 +0000 Abhishek Bapat <abhishekbapat@google.com> wrote:
>
>> Currently, memory allocation profiling data is primarily exposed through
>> /proc/allocinfo. While useful for manual inspection, this text-based
>> interface poses challenges for production monitoring and large-scale
>> analysis:
>>
>> 1. Userspace must parse large amounts of text to extract specific
>> fields.
>> 2. To find specific tags, userspace must read the entire dataset,
>> requiring many context switches and high data copying.
>> 3. The kernel currently aggregates per-CPU counters for every allocation
>> size, even those the user intends to filter out immediately.
>>
>> This series introduces a new IOCTL-based binary interface for allocinfo
>> that supports kernel-side filtering. By allowing the user to specify a
>> filter mask, we significantly reduce the work performed in-kernel and
>> the amount of data transferred to userspace.
>>
>> Performance measurements were conducted on an Intel Xeon Platinum 8481C
>> (224 CPUs) with caches dropped before each run.
>>
>> The IOCTL mechanism shows a ~20x performance improvement for
>> filtered queries. The kernel avoids the expensive per-CPU counter
>> aggregation (alloc_tag_read) for any tags that fail the initial string
>> or location filters.
>>
>> Scenario 1: Specific File Filtering (arch/x86/events/rapl.c)
>> 1. Traditional (cat /proc/allocinfo | grep): 22ms (sys)
>> 2. IOCTL Interface: 1ms (sys)
>>
>> Scenario 2: Compound Filtering (Filename + Size)
>> 1. Traditional: (cat ... | grep | awk): 21ms (sys)
>> 2. IOCTL Interface: 1ms (sys)
>>
>> Scenario 3: Size-Based Filtering (min_size = 1MB)
>> 1. Traditional: (cat ... | awk): 21ms (sys)
>> 2. IOCTL Interface: 14ms (sys)
> Yup, textual interfaces aren't fast.
>
> And ioctl-baed interfaces aren't popular.  One would prefer to see an
> interface which uses read()/lseek(), pread(), etc.  It would be
> appropriate for this [0/N] to have a discussion of why that approach
> was not chosen.
>
>>   .../userspace-api/ioctl/ioctl-number.rst      |   2 +
>>   MAINTAINERS                                   |   2 +
>>   include/linux/codetag.h                       |   1 +
>>   include/uapi/linux/alloc_tag.h                |  87 +++
>>   lib/alloc_tag.c                               | 303 ++++++++++-
>>   lib/codetag.c                                 |  11 +
>>   tools/testing/selftests/alloc_tag/Makefile    |   9 +
>>   .../alloc_tag/allocinfo_ioctl_test.c          | 505 ++++++++++++++++++
>>   8 files changed, 918 insertions(+), 2 deletions(-)
>>   create mode 100644 include/uapi/linux/alloc_tag.h
>>   create mode 100644 tools/testing/selftests/alloc_tag/Makefile
>>   create mode 100644 tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> At some point this should grow user-facing documentation, please.
>
> And the right time for that is now, because such documentation is
> useful for code review - it makes that review both easier and more
> useful.
>
> Sashiko had a few things to say:
>
> 	https://sashiko.dev/#/patchset/cover.1779471082.git.abhishekbapat@google.com

I notice that Sashiko has reported a pre-existing issue, as described below:


 >  static void *allocinfo_start(struct seq_file *m, loff_t *pos)
This is a pre-existing issue, but can resuming a sequential read on
/proc/allocinfo cause a use-after-free if a kernel module is unloaded
between read() system calls?
The seq_file read operation updates priv->iter.ct during allocinfo_next(),
stops iteration, and returns to userspace. If the module containing
priv->iter.ct is unloaded while the lock is dropped, the module's codetag
memory is freed.
On the next read() system call, allocinfo_start() with pos > 0 reacquires
the lock but returns priv without validating if priv->iter.ct still belongs
to a valid module. Does allocinfo_show() then dereference this dangling
pointer?
[ ... ]

This issue is unrelated to the current patch series and can be resolved

by reverting commit 9f44df50fee4.

Therefore, I have submitted a separate patch addressing this issue,

which is available at the link below:

https://lore.kernel.org/all/20260525072117.112779-1-hao.ge@linux.dev/

Thanks

Best Regards

Hao


