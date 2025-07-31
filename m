Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CDB7C87FC9
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 02:41:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B86236B008A; Wed, 30 Jul 2025 22:41:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B370F6B008C; Wed, 30 Jul 2025 22:41:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4D556B0092; Wed, 30 Jul 2025 22:41:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 942836B008A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 22:41:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DB1691143F7
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 02:41:31 +0000 (UTC)
X-FDA: 83723008782.08.706F6E8
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf08.hostedemail.com (Postfix) with ESMTP id 089B516000B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 02:41:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qUnVHuy3;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753929690; a=rsa-sha256;
	cv=none;
	b=wHW+OJPhYR+NkH2pgo+SM3zvxUN47o5uOTtLfqt+osI0zcleIDc6RHRRxzYrs19R1jRRhN
	rDyf3T8T+7Gccu7GxVkKAwl1XMaHxR31g9enjra9fLaADGd9wGMFWv/iKS7EAtlsUMqNcm
	rte5C+wlI+pNkav4Ddd4LUKofEObmzI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qUnVHuy3;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753929690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gqxVT+RbD+xwh7/14ML2dYytB9lSy/1Uy05C7j5gfdk=;
	b=N14bInggoejuvTJmb8cBrfoe2qPPyHFTVaNAIeqjd5T1dCfkKZrzRLCyD9T+pFbc5Oex91
	PP7oFmLBzcG4A8WB5XPdxEx91Wfn0OR78EeobgCV8ueqOXS/6Mwk2USlauYCMcmK1SZzCv
	w/bUMg0zcNteeUv598yfHoy5jR4bEIM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1753929686; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=gqxVT+RbD+xwh7/14ML2dYytB9lSy/1Uy05C7j5gfdk=;
	b=qUnVHuy3wA1yk0fszs3uONb6a4O0eBA4iG9DN3L+XiM09Nscv2T32EJfQUJuvfvue25o3zJ23mbjFVwK9E76pxRFhavwE7ZDRgw7WJPflGRkBzlXHDX/M1POrmxezNRcpAbkQy5nEcG8DkwMvitj66iZamfE+zTCroUcmq8hz60=
Received: from 30.74.144.125(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WkWRHUP_1753929684 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 31 Jul 2025 10:41:25 +0800
Message-ID: <78c0f8ba-7e71-41da-9ac8-bcd26717dc71@linux.alibaba.com>
Date: Thu, 31 Jul 2025 10:41:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: shmem: fix the strategy for the tmpfs 'huge='
 options
To: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
 hughd@google.com
Cc: willy@infradead.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <701271092af74c2d969b195321c2c22e15e3c694.1753863013.git.baolin.wang@linux.alibaba.com>
 <0a689e9f-082b-497d-a32b-afc3feddcdb8@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <0a689e9f-082b-497d-a32b-afc3feddcdb8@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yksy1arhcsydmr1pbmbxbpbefbz4k9nf
X-Rspam-User: 
X-Rspamd-Queue-Id: 089B516000B
X-Rspamd-Server: rspam02
X-HE-Tag: 1753929688-426809
X-HE-Meta: U2FsdGVkX1/rpX18seKMEyfEGUzFjEv7S6xvgk85wkfyl0crrR1wQfH3nV/8WR1oO/l7dco3/MfRZLrKepLSq+VhlJIT4Eymmeg6Y6ZGe/meFt6UnNE5Wlf0A8WKChJmKTj7UzvkkRd8ajY7Ctz2n0ZHzABaAoZ/f04V3FFC2BKM8AEklMV3u0pDjT1wXB/VYG7oUudZdhjf3gZF7BBzTJ3NIKTekjKxtQFVqTaAAKN+Yp0HpD2hNy95lcXybOQ1QnSkcB8Eo7csYfSM6OvIqWfhia2VP9IRs/H9A/C/dPgIGtQEBq4zaj++LbQAdzAb+VSKrlwAzCs0Fa68FzVJNDwJrzH+GbnMHw57HJh6jVasWnvxLUz5OOqQMwZTF3S7HZWCZNPGqQcxZbk3TuXBYa6KBGdFkTR32y3QU/dWPrBuf65GPt8LA3kXeCprHR9yC7ieT2QT2h+WE9t5VcwQsBkeG+C1sa6A9m3Ygw857sEwRUrbLs280hPRSeJ4JPo4ZY/BzPgpRo9JsQu7dYasMp03ME6NutbSOEkn7e/YnXaumRYK81GGdjMA3cBIBIJDHKgZGnmovvu+znuiv1mEk4LjzLFE/2FYdEvsIsgb0LJoE9fm/0dHlYVXrFj+cOOfOwTkC5rk1Lhp1cxhwMg1gXrZrH0N7j0fDas6AM9SJD24565ck6g5g3YESvByHS3FJkCUch22lEM/Y/Okg5lFPS3RGpN6HOguc0YJW8IHbQis9HMiScNPdlif9EKYZVO5DUkydn3mo1/ijrKU/H5gO84YEgwyrufM6DV8KrnP0adYhqi/Y4s8MHZm17/TJOkrXA0zoPcSGoi/o2StstcU2g+49pjV4EHpZl5/X4XjXPW2Mr1/gP5RxpbAeMCfWsJQAvt2KRRCDmJCFJW/Vd6f2iA04NioSLCbXPGwhaAdcq/VZ0KF4mO9wOKIe+h91eB26E+HoK6QY/zUDmmx6uE
 60brcWkb
 3xJ6FwzsxNaSPpA4infgW3W5JuouHhL3TVvgQxmnvuoj100K052l6P/J7aUQ87aNpIxj0ulKNuOoLL76uZxQxuiBeM47FL4LaH045Meh3CrnKuAWZq4Qv9142mWxoSRmz8cbRmm5WF0R0HUrT7P7tQnMY7F7UGcXRVEqrXKDSuPnQAle5caC8U5Cs7mfMSPO5bIttKcwT5o5Wij0n932cidd8aJ/xbG/wlVuUobTBy6ah5aaKkDBxSdMcliwIEFSpM22Dw7jVZ6M5OQGxQFwpCuhaD9HnUmOogJZhV31uYZRpb56fEh+iUonQYWxv4LPubZDnyu3qSrtsNmW+2nazFUyHAg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/7/30 17:30, David Hildenbrand wrote:
> On 30.07.25 10:14, Baolin Wang wrote:
>> After commit acd7ccb284b8 ("mm: shmem: add large folio support for 
>> tmpfs"),
>> we have extended tmpfs to allow any sized large folios, rather than just
>> PMD-sized large folios.
>>
>> The strategy discussed previously was:
>>
>> "
>> Considering that tmpfs already has the 'huge=' option to control the
>> PMD-sized large folios allocation, we can extend the 'huge=' option to
>> allow any sized large folios.  The semantics of the 'huge=' mount option
>> are:
>>
>>      huge=never: no any sized large folios
>>      huge=always: any sized large folios
>>      huge=within_size: like 'always' but respect the i_size
>>      huge=advise: like 'always' if requested with madvise()
>>
>> Note: for tmpfs mmap() faults, due to the lack of a write size hint, 
>> still
>> allocate the PMD-sized huge folios if huge=always/within_size/advise is
>> set.
>>
>> Moreover, the 'deny' and 'force' testing options controlled by
>> '/sys/kernel/mm/transparent_hugepage/shmem_enabled', still retain the 
>> same
>> semantics.  The 'deny' can disable any sized large folios for tmpfs, 
>> while
>> the 'force' can enable PMD sized large folios for tmpfs.
>> "
>>
>> This means that when tmpfs is mounted with 'huge=always' or 
>> 'huge=within_size',
>> tmpfs will allow getting a highest order hint based on the size of 
>> write() and
>> fallocate() paths. It will then try each allowable large order, rather 
>> than
>> continually attempting to allocate PMD-sized large folios as before.
>>
>> However, this might break some user scenarios for those who want to use
>> PMD-sized large folios, such as the i915 driver which did not supply a 
>> write
>> size hint when allocating shmem [1].
>>
>> Moreover, Hugh also complained that this will cause a regression in 
>> userspace
>> with 'huge=always' or 'huge=within_size'.
>>
>> So, let's revisit the strategy for tmpfs large page allocation. A 
>> simple fix
>> would be to always try PMD-sized large folios first, and if that 
>> fails, fall
>> back to smaller large folios. However, this approach differs from the 
>> strategy
>> for large folio allocation used by other file systems. Is this 
>> acceptable?
> 
> My opinion so far has been that anon and shmem are different than 
> ordinary FS'es ... primarily because 
> allocation(readahead)+reclaim(writeback) behave differently.
> 
> There were opinions in the past that tmpfs should just behave like any 
> other fs, and I think that's what we tried to satisfy here: use the 
> write size as an indication.
> 
> I assume there will be workloads where either approach will be 
> beneficial. I also assume that workloads that use ordinary fs'es could 
> benefit from the same strategy (start with PMD), while others will 
> clearly not.

Yes, using the write size as an indication to allocate large folios is 
certainly reasonable in some scenarios, as it avoids memory bloat while 
leveraging the advantages of large folios.

Personally, I prefer to use this method by default for allocating tmpfs 
large folios, but we also need to consider how to avoid regression if 
the 'huge=always/within_size' mount option is set.

> So no real opinion, it all doesn't feel ideal ... at least with his 
> approach here we would stick more to the old tmpfs behavior.


