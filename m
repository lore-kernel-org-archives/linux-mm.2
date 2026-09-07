Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96530C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 15:49:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A44066B00A6; Mon,  7 Sep 2026 11:49:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1AC86B00A7; Mon,  7 Sep 2026 11:49:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 957F66B00A9; Mon,  7 Sep 2026 11:49:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7804C6B00A6
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:49:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1CDF41C09A1
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:49:55 +0000 (UTC)
X-FDA: 85187401950.27.3246E4C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id DF06A40002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:49:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=X8PrVsr7;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788796193;
	b=5NkIucD6fhOe6jNF0hkSGxTQNuc1Q3t2gEXmdlidWoro5EmZyceYCepxsD/4ZCMd9WvfzW
	BFCwLZ32KfQQSakqsB86UjfJNNETsj9SMtztqQJnjdj5Ta3qjdyiF+w0e0CwaV/ROCQEA6
	ekIAP2NGlLjXFNKG6uPQQqrMXwYQduA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=X8PrVsr7;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788796193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NgsqfI4UMPdAKy09BfAtIYj/ju7Uvf0+W/vr1pDeSmE=;
	b=0KZbD4PtckOoy1I69+NQLA8aR5U+oYM60g+Tdt6kfKduUqql/xwwPCoTJSuvICz5FPZG50
	5yjIzNkRhT4bmsIbnjTDD42uo2VSZ1rw/9cvKSbJXC8+KzOf2XFPBQxFVnUFWc32VXzDm2
	Yxjh6fDFMWdIGVjGoZBKxF87JLiuHj4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E8D891476;
	Mon,  7 Sep 2026 08:49:47 -0700 (PDT)
Received: from [10.57.6.26] (unknown [10.57.6.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 634F93F7B4;
	Mon,  7 Sep 2026 08:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788796191; bh=NgsqfI4UMPdAKy09BfAtIYj/ju7Uvf0+W/vr1pDeSmE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=X8PrVsr7qSGJqrvABBYQzM/DbPiLBfiIRsoRicV7kmHmDk4fvFg6Gl0y2kzAN0Etz
	 Ea7Gi8wO+37xss8GQ8X/AtXdULivI4RHRx1t2vIjhRBNjqhWUfYrjRpUJ+dijf2Dy4
	 Yv9O0nkLGvLbp7EhNWeac5e0DU5XWNx23239QUAw=
Message-ID: <3f6e7678-0784-4ac1-acb4-b128887803c5@arm.com>
Date: Mon, 7 Sep 2026 17:49:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v9 01/25] mm: Introduce kpkeys
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-hardening@vger.kernel.org, Andrew Morton
 <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>,
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Maxwell Bland <mbland@motorola.com>, Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
 <20260818-kpkeys-v9-1-743ad31b2c8f@arm.com>
 <178877845406.3691569.6930315020588094755.b4-review@b4>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <178877845406.3691569.6930315020588094755.b4-review@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DF06A40002
X-Stat-Signature: oji58p1scdph1gahho64hypkw777fbos
X-Rspam-User: 
X-HE-Tag: 1788796192-771479
X-HE-Meta: U2FsdGVkX19ePk7wYCxBLOT2akkDcBb+sxqFjSqha/qjS3VP/awC7yMrj5bXP2knhDWgAPwY21/N4W+MPXlDF9ZOmRIILqDC4UbW58aELjaMvXoDldIEhRT2oEeWCUNMBcm2GKbynEAi1m8if5E1SQBZKI7Bqw6DubU92PArPmhPJcIdsecFfj4jx+bfDbUv30mXxNMc7q56RAqG+idejQX+rdmMJnzHdact3Vf+opPTnPrFcoUoRoNDki7eKSpqdbrplmTP8I5ZuTjRkrJ+JXHsIqaJ0wVjZ+iYx+VA/sjmcBtqtAXelqj+wm5L2J8u53J1GGnaoQ31lZEKovV82FbqQiH4w8nKd29DQWg/iT0JD1TjKen4jo80w3SxZwqyYoK1Bh6n7tqwcH18jY9UAcVESHyc911RBkVF1xujSguV2nJ39K7PXwnNCCYm7hVPrTRU2w/feqbc1sq171jlHQ+Q/LXuwofZoTKsp2Qoy4UpDW62ScowaRHRZEVHnIao56zh4mRBe/cX2KVidjJk5JqpC/xKlsjD3JUXnpLykPn3dqp2LVFsZ1aBS3dRV26K/nudTZVqGsGDOLZESo5w50piutFPClWewDjlGeQnw5FYAEbuXCqnlqzW8U4l+8hD+TdfUmIn5d5o2tBG9sdvH5obOoZB60PXQclibpulhKcv/+yczdhDtwLKYDNtdVtBvKsyYdlVAGiRfgv5hsGfXN0gnNZgxMwzwyH6ATPWc4TyvY8xZNzkkwrZ9lyR+m8+S5osDPLojsC4fD6dG5egJoMFdbJfFQ+vpVqhDuOoWaCfKuomV37x7dT6rZkQTGyspnzcPmu97HN/gnrRU1Az1WA565OLTKGyMG1YrMVwnLwwfQGL1bqy6mWAbuLSN2Xl1b0m+CIQe458n6Qli9FRiSefSNIJ0yx/SSZj0k7Ictr1cBIP7Xpb67tHy8SbRAxQxlHEgkHHWb1Sozk4q4s
 SYbLTmqJ
 8tgLsRdnOM3p7CaKExvUujZmdQPCiUvNSPVG23b5Hykf9ma6AsfzaLE43wuHBZQlvh6/McTx8Y6WosMZyuefwisfh3GMyZsK/U9FGbUKq/sLwAPlGs0WpgTFiPGQKyVzBZWXDqiMGx8+H4xiiWaatKvNV4AYAdl3VfmSgQNMylbIyRXf/H1FtFOWhHkTSwVVxmsUIbJcGcA5UTwFw/Z2V2BI+V4XHiFQS4VoLYr+zF7fNtbemNh2QYw45lsZy3iH2S02OpXVAF5pZfYG4k+F7s2kMWJBeB8Ikez0BI6a4EnWSnYemUi+/Cjvr518Ofn3twvToMQ77Av1Lj6M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/09/2026 12:54, Mike Rapoport wrote:
> Hi Kevin,
>
>> kpkeys is a simple framework to enable the use of protection keys
>> (pkeys) to harden the kernel itself. This patch introduces the basic
>> API in <linux/kpkeys.h>: a couple of functions to enter/leave a
>> kpkeys context and macros to define guard objects.
>>
>> kpkeys introduces a new concept on top of pkeys: the kpkeys context.
>> Each context is associated with a set of permissions for the pkeys
>> managed by the kpkeys framework. kpkeys_enter_context(ctx) sets
>> those permissions according to ctx, and returns the original kpkeys
>> state (typically the arch-specific pkeys register) that is later
>> restored by calling kpkeys_leave_context(). To start with, only
>> KPKEYS_CTX_DEFAULT is available, which is meant to grant RW access
>> to KPKEYS_PKEY_DEFAULT (i.e. all memory since this is the only
>> available pkey for now).
>>
>> The underlying representation of each kpkeys context is entirely
>> architecture-specific. Support for kpkeys must be explicitly
>> indicated by selecting ARCH_HAS_KPKEYS and defining the following
>> functions in <asm/kpkeys.h>:
>>
>> * arch_kpkeys_enter_context()
>> * arch_kpkeys_leave_context()
>> * arch_supports_kpkeys()
>>
>> Additionally, <asm/kpkeys_types.h> must define struct arch_kpkeys_state,
>> which typically provides storage for the pkeys register.
>>
>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>>
>> diff --git a/include/linux/kpkeys.h b/include/linux/kpkeys.h
>> new file mode 100644
>> index 0000000000000..eac522f552141
>> --- /dev/null
>> +++ b/include/linux/kpkeys.h
>> @@ -0,0 +1,104 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +#ifndef _LINUX_KPKEYS_H
>> +#define _LINUX_KPKEYS_H
>> +
>> +#include <linux/bug.h>
>> +#include <linux/cleanup.h>
>> +#include <linux/kpkeys_types.h>
>> +
>> +/**
>> + * KPKEYS_GUARD_NOOP() - define a guard type that does nothing
> Nit: I'd suggest to drop "define" from all the descriptions, they would
> read better without it IMHO.

Fair enough, but if we say just "a guard type that does nothing" is it
clear that this is a macro defining a type, and not a type itself?

- Kevin

