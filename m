Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BD0ACA0EED
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 07:31:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91AE38E0003; Mon, 25 Aug 2025 03:31:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F30B8E0001; Mon, 25 Aug 2025 03:31:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82FF88E0003; Mon, 25 Aug 2025 03:31:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 715A18E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 03:31:57 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F2EFE1A02E3
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 07:31:56 +0000 (UTC)
X-FDA: 83814460632.15.F8FF6DB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id BDF2E180008
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 07:31:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756107115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r50dDkvFDO+w+5+hTwJQC3IZEVejQAJBD9RW2mT+j/0=;
	b=yAP6prpcScotA1t//ra6zv4fMWth8y7HQfuiyyohwHiNskBVoYqB3AKB4rjcYnsx9wzWpr
	mlcF+/R03aKgOjcPCCyY3Vw7M3kLxdXFuTwxawzSDNrvaj99t7YmbxLsNGYP8p44O8bHDJ
	zcR2JBtKv5PKdqniqoA+N1HGIMpa6AQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756107115; a=rsa-sha256;
	cv=none;
	b=RpTzss1+YWO2ZQ4+QK1UocnK0Hhvsg+OzWGex/bJ1u+6+glhAYAGDP/rKzUGigKz7xjZKR
	QP88mLAglz3a8O6aa+Zs8B41eLD0+tlK0SiSgVygnrAu1+RJEDsVv7+SmzsqjmvL14TjVw
	ZiQD+ccypluqUe/uh9wOeBPZSDvQpIA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 601921D70;
	Mon, 25 Aug 2025 00:31:45 -0700 (PDT)
Received: from [10.57.89.148] (unknown [10.57.89.148])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 366D23F738;
	Mon, 25 Aug 2025 00:31:47 -0700 (PDT)
Message-ID: <8e4e5648-9b70-4257-92c5-14c60928e240@arm.com>
Date: Mon, 25 Aug 2025 09:31:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 00/18] pkeys-based page table hardening
To: Yang Shi <yang@os.amperecomputing.com>, linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
 Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@chromium.org>,
 Joey Gouly <joey.gouly@arm.com>, Kees Cook <kees@kernel.org>,
 Linus Walleij <linus.walleij@linaro.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Maxwell Bland <mbland@motorola.com>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org
References: <20250815085512.2182322-1-kevin.brodsky@arm.com>
 <98c9689f-157b-4fbb-b1b4-15e5a68e2d32@os.amperecomputing.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <98c9689f-157b-4fbb-b1b4-15e5a68e2d32@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BDF2E180008
X-Stat-Signature: ynsm7pju6jebbszkiprgq66aiwzw4dwt
X-Rspam-User: 
X-HE-Tag: 1756107114-398542
X-HE-Meta: U2FsdGVkX19QZYSeZxfy4jE+rNkmPTDoiqis086FvmpNtwetUqTrRr+lecgDzNw6XG6TdMkytcsOAWhP7xlXJUsele1H8fHbiK4G5LkHrILQjQwMi/Cb19BDGZHBUUFlRGZ360Ag7GmgYfG7Y5yIcuW/u7t79qwZw5MyOaLgzWbGXjjCxX55DgdZ7JX2zDe31FH/NhGLmF1fWH0MgtErO6NPKLl91RzSUBlbz+vupqDKJWGYjhwWKmGZuSFp8RlJqeNtE7iDbfK1atGIVm2ULhf6QKTMHVs5MbssuW1Yj8LovwQEIX4onwDFYNH1um5/HTEhaGxHqlZzXyfulwTvUeCB7j1bqeJ57uTjOycqgH9zC2FsWcWA0D5KeubxDkCQBl3+yEcbp4kwQJMzFfD7uz4ux90rhPyq5kdx4ANc+JiPJEHOxoa8Ak61qDl6xrRpbtn0Jd9Pd/hhBJS4ZFCR1Z4ze2e/IWUsuwjB9kOsyOJGl/rU0YV3SkTxV9QBIS/erJ/PBlY0Y5R9OD/LFtitIaPYWKkJJ3pSCw5jhLfYRPn5ZpnMyNL8OvVBlJoDbFA3HBi9cLhfiiXodPaUQsxyfHqr/2Rq+veSYiFp++qsq52OFByoJ/KpmCOQ4DNAWS68FV0p1Yfg0kGxQWbYmI8LJhDHz1jJgYll7wwEzLxK/QP1QLYoG6j/20Le7LJAGMMmHbo91ufp0Kx7DZLScW/RwUD9F5m8rvIZeRTh3Q8tQHyGLkLzQkXgLzfOaT8uRdAxT2RE1IllSUY/r1YHL3ndoWI0oxtukxx6sEOTZQDq07FkQMsIvAa56KHCfaemAma/tn1GK+TvDwuz1sLlg3zN/S3YWbk2NezEbMrj5QqO4MtFRi+iBuRtrh/ZvCNNlNkZ4w2VekpxMU/mImbNle8dv9Gv3eQy5HuDME5aNm8XP18NSStTo8BF1Fj7Wch6BSt4eMB/JoH1CULJIXai9df
 eLlfA81x
 gO8d0dN9zlhAWkg5nz9R2wN3YxtjMBftaPYe6ZADqP9WxJRHflSnmwcF81R7edO3r+sWn80PTlsTPpz8kdgAyu71ors1iFTEVS8wrcC9MsCwrOLWDVfClEf+0zDmG9Iv47Z2/O2My9h7k9T0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21/08/2025 19:29, Yang Shi wrote:
> Hi Kevin,
>
> On 8/15/25 1:54 AM, Kevin Brodsky wrote:
>> This is a proposal to leverage protection keys (pkeys) to harden
>> critical kernel data, by making it mostly read-only. The series includes
>> a simple framework called "kpkeys" to manipulate pkeys for in-kernel
>> use,
>> as well as a page table hardening feature based on that framework,
>> "kpkeys_hardened_pgtables". Both are implemented on arm64 as a proof of
>> concept, but they are designed to be compatible with any architecture
>> that supports pkeys.
>
> [...]
>
>>
>> Note: the performance impact of set_memory_pkey() is likely to be
>> relatively low on arm64 because the linear mapping uses PTE-level
>> descriptors only. This means that set_memory_pkey() simply changes the
>> attributes of some PTE descriptors. However, some systems may be able to
>> use higher-level descriptors in the future [5], meaning that
>> set_memory_pkey() may have to split mappings. Allocating page tables
>
> I'm supposed the page table hardening feature will be opt-in due to
> its overhead? If so I think you can just keep kernel linear mapping
> using PTE, just like debug page alloc.

Indeed, I don't expect it to be turned on by default (in defconfig). If
the overhead proves too large when block mappings are used, it seems
reasonable to force PTE mappings when kpkeys_hardened_pgtables is enabled.

>
>> from a contiguous cache of pages could help minimise the overhead, as
>> proposed for x86 in [1].
>
> I'm a little bit confused about how this can work. The contiguous
> cache of pages should be some large page, for example, 2M. But the
> page table pages allocated from the cache may have different
> permissions if I understand correctly. The default permission is RO,
> but some of them may become R/W at sometime, for example, when calling
> set_pte_at(). You still need to split the linear mapping, right?

When such a helper is called, *all* PTPs become writeable - there is no
per-PTP permission switching.

PTPs remain mapped RW (i.e. the base permissions set at the PTE level
are RW). With this series, they are also all mapped with the same pkey
(1). By default, the pkey register is configured so that pkey 1 provides
RO access. The net result is that PTPs are RO by default, since the pkey
restricts the effective permissions.

When calling e.g. set_pte(), the pkey register is modified to enable RW
access to pkey 1, making it possible to write to any PTP. Its value is
restored when the function exit so that PTPs are once again RO.

- Kevin

