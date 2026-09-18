Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FAABC982DD
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:23:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 876826B00AA; Fri, 18 Sep 2026 16:23:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84E586B00AB; Fri, 18 Sep 2026 16:23:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7166C6B00AC; Fri, 18 Sep 2026 16:23:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 36D296B00AA
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:23:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8DDD61207E1
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:23:18 +0000 (UTC)
X-FDA: 85228007676.09.9B8C00F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id D5B0D40004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:23:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KRO8mE4Q;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789762996;
	b=a8Gk4wwXS25ODc+DtJwfhNygh9F2nqlwHAz8QA0KEtsozKn4Jc6Tknw1lWGCfumr8oA8GX
	3IZsOm4rQW2F7UglBWqOBz6Vi+TaewMNsvxSaloCI977ktf4PSZJ0gm6rwbASrLqxK4cJz
	IXC8UhbWXueo5UJkw1aMxjiKdC4ZmZw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KRO8mE4Q;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789762996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jMNQNlEwmiuLJhmuM/5YUT/yMbKaucQuszeHmhLwONQ=;
	b=8AkjABDYt25pQPRU9j+X/lclqhwJwrO0FM+YF2f4I7kFCUkbXQGoFL0c4mR3+IjLumkAhg
	Mt7owWNrbuQX2HCAf6AboAAiS5JZwUpbEfCi87hdgI6Q2h8fVPqZdpNfigZPGBvDqvjxl2
	T7F31RI5Z15+bz8xrIuoLCVbV+ZFnZE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 630C16053B;
	Fri, 18 Sep 2026 20:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9135F1F000FF;
	Fri, 18 Sep 2026 20:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789762996;
	bh=jMNQNlEwmiuLJhmuM/5YUT/yMbKaucQuszeHmhLwONQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KRO8mE4QI67Tt6rV1s06qXUHa62HU5/c3vJdk5Kvt4K3j0K5o2TVsxOrGu2Yxmaqo
	 5SShVgxZl+gxU5lWsrFbEoQXw5DEKoQPvT1fgfTvNC8LnIlEm7Kq766oJFDPBoJTe6
	 3WKxEYUmchY6Yh9SQ9LP8FDiicFYMo1BTf2qKzvJIzXEj61VtOjSgHEm7pm3vcy2rH
	 /T52FJcA77bfDgOtl7fJL+kwn1MUi6qmYOp/enaPBcsamt307qP0I9F+Op+o+Tyh+X
	 nOBD/gsStGGdqZEztyNYLHllBv51Ww8MFz8lHTosZQW1S1UIXX9heNvUTNPSNoueVW
	 nB+hzx5ZKV/+Q==
Message-ID: <cfd9c86f-26e3-4914-b148-8202b942e5c6@kernel.org>
Date: Fri, 18 Sep 2026 22:23:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/14] mm: thp: always enable mTHP support
To: Luiz Capitulino <luizcap@redhat.com>, Usama Arif <usama.arif@linux.dev>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com, lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 dev.jain@arm.com
References: <cover.1789695931.git.luizcap@redhat.com>
 <ad25b99c-d9f6-4e52-819b-81e08eb2a131@linux.dev>
 <970c8f34-3cf4-4c6c-931c-b132e3bc6838@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <970c8f34-3cf4-4c6c-931c-b132e3bc6838@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D5B0D40004
X-Stat-Signature: 4xd4f9f8rb6kfme31bn4knmyusn9qyoh
X-HE-Tag: 1789762996-503964
X-HE-Meta: U2FsdGVkX19a3nQpD/z0/YBHhlaSZJIUGf+4ufdc22vDuW4wg5Z9np7PEHvwJw78hHGhMv9Wt0DMYOY2PUt2Bd21GMzHd9uUSN4D/PQen+PZjdmKs08n7PxpmNpRU3lJJrJxaMzSLnSyz79RWwDMk3ABpLuoBPPuF7PK6bw5WUF77wiQ/6aOQtQIps9gy53rqtndrQvzNBLzXo+waRR7vf7ktOZpDDwnqW8O0CezhlhpItNUBCY6pDCmZmgNwx68tYj4Vptn2YD9e7IGpvq2Epi/idk3rabBLwYfKBsoaZQMrS4pDXF+HstomIfNC9Ju4u8fjnc0/CE1xExCg3z4oyisjSkqruZ0pmu8aGUdfZ/iidaboqnQkJAuKicuSiVjJEMK1bnhGFMV5pqusRifRnnlad1OrA/2egdjvb06tD9Am0FE6X6z06i2z/5QFMJBEWMteabbjQ9oPB76ZWJ5BJJE0+2wDSA3wuuVrrIxv8eMC4xmmumAYzjcLGIK5Q7pXcz7aB/037YUXINFYOklxx4Q3UrHXbxs0ch+mMq3DlzurKiISdHe8+xp6kEto6NX0GHXUnG4XtaXqLAOPtduWB+JBgWdg/2gEbC9IZbmx0tz2jVThFvF3Rcs0Arm5R+WrQJcmFWnnIqjkkGU1pihpv1ky+3owddHw9Na88xCT5qvJPguSGYe5woqSsBOxlpwQPVmlWISOGh2z+Lf6SRGm7gRV6OEhas8PKKRVkgkuWyah1Pf0ddjdbv/UJNGjn52g/yNiL3/mO/sPATnWCZgKGDpWUwvFFxDEYlywfTV6lN7jOLqKksA6phZ0Gtr+/80iV0FzsvZE6DhGSjM65t7qA5KdN/vwjml4xWj9YXX0ClkpOtZWrVIwZSqYygmrxZJKf02UnYZ534qvaAw4UKv3Co5jsOW4xyq6ELVjYYtSe9j1iYWob9PpwwoJatEkedTYUl7AHRwHDOs8UWTl7M
 5+Qh/S1f
 /UuZlA4v+KEr9tBYXjKOlL0BulcL6GqutCGVQwAs+DEDM7ZLgxji5zrVoqoBLrE6ad0ugYfHxVuU1wCnlaDibtRgm/lPqyjDat2V3QpTbaobLbNrE39AyAuH8/hVjdgLFluli+17O94WkjZFCXzL8e4IbucpBgh6tKnemK67/mFUJq6V8sVAIiPhAlBL2N/qRS6p3XsCyLYk8YieKQF5nukpFxnlYhR0BQ5y+/snXeiDWYDPYssJBfZCnMqSkNF+qp9/L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/18/26 16:01, Luiz Capitulino wrote:
> 
> 
> On 9/18/26 6:37 AM, Usama Arif wrote:
>>
>>
>> On 18/09/2026 02:45, Luiz Capitulino wrote:
>>> Introduction
>>> ============
>>>
>>> Today, if an architecture implements has_transparent_hugepage() and the CPU
>>> lacks support for PMD-sized pages, the THP code disables all THP, including
>>> mTHP.
>>
>>
>> Hi Luiz,
>>
>> Sorry for asking this so late in the series, but which CPUs lack support for
>> PMD sized pages?
>>
>> Is this series mainly for PowerPC?
> 
> No :)
> 
> The architectures that have conditional PMD page support (ie. discovered
> at run-time via has_transparent_hugepage()) are x86, s390, powerpc and
> mips.
> 
> For x86 for example, even on 64-bit there are cases where the PSE bit
> may not be present (eg. some errata and by hypervisor CPUID masking).
> 
> That being said, the main goal of the series is that
> has_transparent_hugepage() is overloaded: it has different semantics on
> those architectures and is used to gate all THP support (which is not
> the right thing to do for mTHP).

Yes, and I hope that we can then follow-up with similar PUD support cleanup to
rework some of that CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD magic.

-- 
Cheers,

David

