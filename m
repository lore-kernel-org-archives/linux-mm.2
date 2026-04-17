Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA631F8DFF9
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 17:39:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CAA66B0132; Fri, 17 Apr 2026 13:39:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 180FD6B0133; Fri, 17 Apr 2026 13:39:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06B796B0134; Fri, 17 Apr 2026 13:39:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ED7E06B0132
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 13:39:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BB190E3C40
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 17:39:08 +0000 (UTC)
X-FDA: 84668758776.23.2645BDB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id C35CF40007
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 17:39:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="u2/EyyMb";
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776447546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7WWr6lypVC8qj5jprz8sxlcynFb0mVf+8b8FtPZZgzk=;
	b=6emYr6QF1jez8y7+Ki7Vx6HGHwAEH31Pg8lsoaC4rmwi4Uj9oS44KFFoXcBDunhPBLfl0K
	AykVuZj5+4CtQ1m5ajN117iogsEFn1tdDK6ipv0TK6dgs/bv5pSFi6uvdiNEPIIaozHSsQ
	LsjNv+60DvOVrh1XsoWm4xjVCpkWCqA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="u2/EyyMb";
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776447546; a=rsa-sha256;
	cv=none;
	b=XjxIuUMj4yQeNlc+ELgbee5wtJSjZbk7hEzhazdziX2+V/zn3FdziCdXH9toPy2fDBvXn+
	+UGQhdCuMwefKI57gt7Q2kaPR99WfbKmhypXJ3U+/HCGpvBTEoGMrBhufCevMxK/kfg1jP
	UhNlUmSYxFdjtoHJvOVbbW90t5QqblE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B85D439F0;
	Fri, 17 Apr 2026 17:39:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E384FC19425;
	Fri, 17 Apr 2026 17:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776447545;
	bh=rtaHgFZXQZ78ik4SRZtEsybXv6W9bNkHH0T25TFSeL0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=u2/EyyMbkNoksqyFV6DhyMLgjgwjvgYI+oEXVsEeJHbk1ckE8Z09qoH0k6nFGQFm9
	 cY75hCwPK09VXs+Xm520/ICdasDxYK+68y0wlLNPceDO8WaB2iNuZu5lBnyugyK8mH
	 FtC7u0OpIzmBSwpTZQYHkrrhJLkHKDaQ/uH3RpDJYHzA/vrhG/xwVSk7i4jOMnmtx+
	 kfIciHnRXI8LXvxbZUpxFSrLKOnTtcOJi+GpcJPKkJzPjyI29rI5qjq57rjoiI3FSj
	 56GoJa6eh3WUF9kwy5eyLXswYoVwGrq+EKOl7BDlJQuKsL7Catq5Czvt+C9MJ72ICR
	 qXUGtyz6RjjMQ==
Message-ID: <cd2bcc09-2507-4ed4-bb92-2d53baedaf04@kernel.org>
Date: Fri, 17 Apr 2026 19:38:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 01/30] mm: Introduce kpkeys
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Maxwell Bland <mbland@motorola.com>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yang Shi <yang@os.amperecomputing.com>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
 <20260227175518.3728055-2-kevin.brodsky@arm.com>
 <00b24db8-0063-48d6-8bc4-e8b670d8f0d5@kernel.org>
 <913002a5-e002-4001-ad19-037102d1f97d@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <913002a5-e002-4001-ad19-037102d1f97d@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mdo7sy4mecampmfcohe3s3efq9zq85py
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C35CF40007
X-HE-Tag: 1776447546-585006
X-HE-Meta: U2FsdGVkX1907j8/pd1YIJzhA377p+76GB7m2PlIbgW1S5n4T/KYN2MqgqrMBIQL6FiZJk9elFHxM3et8y1gtDRsO4FuleqSrFE7z0xg/iQl6aqWWw1Y5QexCGhTKQoZqaP63l+OpF4+xuyoWn6QuJ7H1/aiz7vnwRSoq/RnguGyqQQ4mtoVzxFUTHSxr0W4J4c7iI35Z5e+xNaYTz3IfWaaBGw6WAu5mV+SMy7YROI5oq3J5kepBut6azDAwatlGfvaE2+sm0N37Sk5lIUGCowd/+G/9rXe3NBe/hN66awNE/vqnMqTlw+arLCAcBuzjV2tAv2X7DOk2epeyLyeudSw/Wgardq1x4SLWKfjaBQNHvAqp47qw3QMJ24mFHreecgfYvj/ag5h1D0893Utz/lpxzcsely4YJQU9oHluVuG1ecoMf7bqVpqEKSkyy2e9qV6L+5Kt4POwKVDvd78gKzDsoEe42eZwvnX4YgeVfBNtAmbh85MUqpL1AHF4MO97fphgkoI0pyDWiA5Bh3e3sQxdzHNE9oCKzXzwkmFuI2VWRJsjgjLf7SQgiqN8mPhV7pPY6oAE56Glmvis0vnWNP68X0tDAXcpz3ABiv4KoIu7MtHt/aV+vlYSqnwDOVHN4yLs0Jc/kQ8XbXdbFjLL20n3Rxlnm3Y9vZK+UkjJiu5q9XqzKGRfEzC0Tsj59fxcfz0dWM9J3ifdv99vznaNZ8v7gM8bk2+DQH+0DC9Ux0ZOUVEhXW3yTPiFLqsLzm84JDNDL1Jtzydw5944KXQZXPf+SU0HMuWQhR3B1c1hjgZUQ6u+91EE9w/Y5uYhis1rOQkO+6Al0SpQesrOULo3PMJajikeTGEmorNQmk2EoMMtGkKBgDbBbHRal820Ptv81zRUMiPl/1OQ+57OUuGd+AZQu7SVDenTASC1yWOfNtve9vgdvs2HWYa9upQVRoYsnWrLxOlwF1WjxXHQAW
 d9QyIcCN
 f2ukX8k39fypQYxW49Nmn5jhrhWSmtlNSpDqDJqd7z1JiXomS2r7ezUUz2WgyD0ShxQ3WpEn6aW/vBzS2WgT2kBjw0L2ofKTcEgWOteJMuguaxqKobyqVFNqBLGJbyEqd6+H71tmpSPpxGraJYHe9XQYSCzMckVDF+srJqp4g/dNnm1AM/Z/fvX2cwXx0zPHwa3tWz3J/10A7E52RHBZn319N4EqMPr9IDakuFDGchhZXUPkCtZBx4kFmXIpUkdZPd5AJsMZnuzWWAbCUADc+T7FTHCxB5I3N8sbC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/17/26 17:59, Kevin Brodsky wrote:
> On 17/04/2026 16:37, David Hildenbrand (Arm) wrote:
>> On 2/27/26 18:54, Kevin Brodsky wrote:
>>> kpkeys is a simple framework to enable the use of protection keys
>>> (pkeys) to harden the kernel itself. This patch introduces the basic
>>> API in <linux/kpkeys.h>: a couple of functions to set and restore
>>> the pkey register and macros to define guard objects.
>>>
>>> kpkeys introduces a new concept on top of pkeys: the kpkeys level.
>>> Each level is associated to a set of permissions for the pkeys
>>> managed by the kpkeys framework. kpkeys_set_level(lvl) sets those
>>> permissions according to lvl, and returns the original pkey
>>> register, to be later restored by kpkeys_restore_pkey_reg(). To
>>> start with, only KPKEYS_LVL_DEFAULT is available, which is meant
>>> to grant RW access to KPKEYS_PKEY_DEFAULT (i.e. all memory since
>>> this is the only available pkey for now).
>>>
>>> Because each architecture implementing pkeys uses a different
>>> representation for the pkey register, and may reserve certain pkeys
>>> for specific uses, support for kpkeys must be explicitly indicated
>>> by selecting ARCH_HAS_KPKEYS and defining the following functions in
>>> <asm/kpkeys.h>, in addition to the macros provided in
>>> <asm-generic/kpkeys.h>:
>>>
>>> - arch_kpkeys_set_level()
>>> - arch_kpkeys_restore_pkey_reg()
>>> - arch_kpkeys_enabled()
>> Another thing: why not simply drop the "arch_" stuff from these helpers?
> 
> The first two are not meant to be directly called, they're the
> arch-specific implementation of kpkeys_set_level() and
> kpkeys_restore_pkey_reg(), and those generic functions handle some
> generic logic.
> 
> arch_kpkeys_enabled() is directly used in generic code, so I suppose it
> could be renamed to kpkeys_enabled()? It's actually implemented in an
> arch header so I wasn't too sure about it.
I was skimming over patch #13 and spotted:

+void·__init·kpkeys_hardened_pgtables_init(void)
+{
+›	if·(!arch_kpkeys_enabled())
+›	›	return;
+
+›	static_branch_enable(&kpkeys_hardened_pgtables_key);
+}

The arch_* there can just go IMHO.

I'd also do it for the two ones used by the GUARD macros. If we don't
expect common code wrappers (arch_kpkeys_enabled() vs. kpkeys_enabled),
then the arch_ is unnecessary information -- IMHO

-- 
Cheers,

David

