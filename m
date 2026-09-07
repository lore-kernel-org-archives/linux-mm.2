Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 331FBC79FA1
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 15:50:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B4F96B00A7; Mon,  7 Sep 2026 11:50:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3655F6B00A9; Mon,  7 Sep 2026 11:50:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A2666B00AA; Mon,  7 Sep 2026 11:50:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0EAE36B00A7
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:50:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9B7A4A3D44
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:50:42 +0000 (UTC)
X-FDA: 85187403924.13.621EBC4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id A12AA20008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:50:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iqQG57G5;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788796241;
	b=0GoIegW2sX6cCIJCiDanHaDdKfaZQLeFwNpLekdKPbscBAQe4B2IOttrNT/TVcxXpm/BzB
	fGUUnWyFoBOaq3swvLag2vhBTRK0ZZUQt1BSpCgsFjDgKEmRKxExn9YaUyENgwM1RgbRsB
	eYgeMre2GLXUg/8UyJ+M24NwXF/+4VY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iqQG57G5;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788796241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SlilMlpGicltaebBQ8I/GC+iE4frt6Y1f/gAHvySSDQ=;
	b=h2/PhYuMZp3RbbUpjKU8RCzto/LLFnK6Dqsu5zmH7LcsEsk8onGRRQvMJikbl2HpqRsHN+
	3GKlrTB4/t5KzwUxKF3eJLQ3ByCt9PLDNmxgDpPCTEzgsa/neTQ06W27s7iV82iw17NC76
	3kR6v7qIAyZWP3DEYTS+LcjXW03lrY0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F17421476;
	Mon,  7 Sep 2026 08:50:35 -0700 (PDT)
Received: from [10.57.6.26] (unknown [10.57.6.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 84DEE3F7B4;
	Mon,  7 Sep 2026 08:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788796239; bh=SlilMlpGicltaebBQ8I/GC+iE4frt6Y1f/gAHvySSDQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iqQG57G5PDVhyw+vfLok9WQkjMSwIU3sN60egn04GlddymBAdaexzT4zstzK5PxY0
	 28Bg4YQ63K5zQ+At/Qb/iDsJW7qSK16xoEp8sCDBbDw6BZlhdLqg23swtYz/GX344K
	 +AGPNAn1CqfVXdKotmnH1oNQu3GUWshCTEXPjLlQ=
Message-ID: <37bfd819-2bd4-4893-9d58-48c7e10880a3@arm.com>
Date: Mon, 7 Sep 2026 17:50:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v9 11/25] mm: kpkeys: Introduce
 kpkeys_hardened_pgtables feature
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
 <20260818-kpkeys-v9-11-743ad31b2c8f@arm.com>
 <178877845406.3691569.11239630051799000768.b4-review@b4>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <178877845406.3691569.11239630051799000768.b4-review@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 9smghc55rzn9a8dstjbz8odxsr5ku6yq
X-Rspamd-Queue-Id: A12AA20008
X-Rspamd-Server: rspam06
X-HE-Tag: 1788796240-149237
X-HE-Meta: U2FsdGVkX1/rOFSmNOscXz0fgoYi/W75JiLDChePs4LqkKxLbepxRN9qAl+rAhbs2DNMmuzj7t5zyUjB1M40BklkmpthLfzZp8RE43xBOz9xt48+FvgSKgRqzZO9zToHv5dJGHrNnZd2Ir3IrWM0TteqI2vvO94jR5skrzWlF2f46xCyiV71bE/MvgDotLjU6J35VqrbdB5VqLIIkvGsbVlN2e4LtzBc0emXB1eIvv0p3RbBEyzMuhr/g4HeHNDwY2qR0s0A/uzGJrxVm4kUiFhe7Tyk7wGomIoTuNnEuB6Jdl9KzKqSS63IvhFYKkobUrxmmgS1CHdq5fDExvMGeafsswqrCKxGsoExhGLB5Q8Hl86dvDVC2hy/kZ3GLATLDL4wKQY7b/eHjQBiIuJ7QFc1bkhv3ckfT8xMiKft/DDy9U3qXJXheKPwAdyj6i7vkrAQup4Hk44BKNwcobAzAqETU9MlsTi3PxkWCSr+ugRN1ewSR/Zp940cQFQJ/mw1M+9qDrb6E5ZYE0ZQ8u7mH9kxwFsH4Zy4GWrPRG3zIb5jll/pXVIRKvBQp87LPxfti1o0OxIEhQxK+exAfWCCBGLZUJBN11+2naYjDbwGVxWXdOeb11bGY/yv6tvZmZglo/Uj4nUg5ot6yLc0cPhJrUdDHNscWQaNCmo/q999lAdg/w96jBrcflpAoD8L+ULl0W+aYsKkBH7caS7vdrurXMZLvIW1V31bdOFFK57q/hkMzEVg/0jxsz+Ib5BiIY+jt0c6/E4lTpxmKt31t+ZUAU9QcBqORbac6tZ/MDJJo29IuX8fWHBDh2Of4qVLoInuNNOTaPekXcQWapLArBlLYhnbKQdfw6NtEn33q7nEoYYSdNkl9DZQDKLEpFLjYWMwcQ6JPFYRwcTFuIbVJNVKlcI89osbhLFSjEw2W23XMdzzWs5MoWdMwK0iLNv2BeMB9fETMM/cYxMJ0I23LeE
 sibVZxft
 D6gz13jgXRGmEs9j55Xgs0EDTbU+7TfQqVVo9bhJjunAYQicUJeo5N5MapBa1vDltr3bETNhZoGMKG++Inrbr8GqZic304hOTNeexzf8nYO0Fn+muLONel3OEGexRqaz/NBpHDaPrM9fHa/e9PcXrFL4V+8Npg4688FjXP6ZLEiGwutXF6FPUHVOfJkJiHXx79Ov4/RkFrh5DoDTMk0CmSt56MgQGXEHfNaBN1wXY/+PxX3EAonubWLi9r8puvLfwz2GWUp2yjV3UySaSuuLH4ymJKkLmnDR/ID4p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/09/2026 12:54, Mike Rapoport wrote:
> Hi Kevin,
>
>> kpkeys_hardened_pgtables is a hardening feature based on kpkeys. It
>> aims to prevent the corruption of page tables by: 1. mapping all
>> page table pages, both kernel and user, with a privileged pkey
>> (KPKEYS_PKEY_PGTABLES), and 2. granting write access to that pkey
>> only when running at in a privileged kpkeys context
>> (KPKEYS_CTX_PGTABLES). This patch introduces basic infrastructure;
>> the implementation of both aspects will follow.
>>
>> The feature is exposed as CONFIG_KPKEYS_HARDENED_PGTABLES; it
>> requires explicit architecture opt-in by selecting
>> ARCH_HAS_KPKEYS_HARDENED_PGTABLES, since much of the page table
>> handling is arch-specific.
>>
>> Because this feature relies on kpkeys being supported and modifies
>> attributes of the linear map, it must be inactive on boot.
>> kpkeys_hardened_pgtables_init() enables it by toggling a static key;
>> this function must be called by supported architectures in
>> mem_init(), before any call to pagetable_alloc() is made.
> Presuming other architecures will use kpkeys framework it's better to
> call kpkeys_hardened_pgtables_init() from mm_core_init() rather than
> stick into each arch's mem_init().

Ah yes I was wondering whether it was acceptable to stick another call
directly in mm_core_init(), but I suppose it doesn't hurt. I can move
the call to kpkeys_hardened_pgtables_init() just before
memblock_free_all() and leave mem_init() alone.

Thanks for chipping in!

- Kevin

