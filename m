Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5EDFF436B1
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 14:38:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 092996B0112; Fri, 17 Apr 2026 10:38:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0435E6B0113; Fri, 17 Apr 2026 10:38:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E74886B0114; Fri, 17 Apr 2026 10:38:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D1A606B0112
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 10:38:10 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5CF01140228
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 14:38:10 +0000 (UTC)
X-FDA: 84668302740.06.3E6D901
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 774E01C0004
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 14:38:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qhWujADd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776436688; a=rsa-sha256;
	cv=none;
	b=YjcDqm9+T8yDno1cRbeYh9QyJGl6ceVkm0p4BCsfQEQ692a3rYfAKp1G/ho+2YgztLdGHF
	Zj2H533qk6u3BLyMYedGmJLDeKnyMIJoJmV4XBAeZCo8VGNeykwXK1GtYr28NuXHDIbLR/
	heUCA/2v2HKTZ59FlKv6xe7pLabO1ds=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qhWujADd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776436688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hg2ltvWZcWrq0NSxfyQlEt416hVNkQB2bTM+mhiTYlE=;
	b=gyBuOEGLx4ujl624+7RQuFCFAaOmy2aYm7aQ+/+WR05H1YUSKPfnHr1CS/M4DRBgfMIcGf
	nMrIvCBnme6L4ruCY7pjL/QFt4MFld0qVHof8qysNUUv5rKUFOs8vpJBBTQazJMKkBSZ7K
	em3NKV40Sx3TkyPo29H36ga2bjwsrdo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 74E3640BFF;
	Fri, 17 Apr 2026 14:38:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B2EC19425;
	Fri, 17 Apr 2026 14:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776436687;
	bh=71fI7RYCKU2/+pXbICCBe4Ry1z/5h9g3tXZ1OoB1U/0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qhWujADdKcxaZq684kVHsaixqi43r/+f8Y1XaTTTq0IwyZ1W8nBK3UeRlRM0uD1uJ
	 fqC8lfgLKFwv9mL88pW9wUWubXkwgxoNc1nUFE/KuuZ5kkHdvYSaj2uMPk4v/6SBBv
	 4txQqVgAu3KAqmGjtbj4R+96nromnLjZEMjnjXYM9K0FpYVHZdU0pwOKAisqNhm3qz
	 jyTOHmjPpWKs0hUO4y4T+SptGdjS8GWMR8i9xS4ylx/9AK/Ac49ghXdwZJUcv0rpqj
	 mOwZ9DEkTWYl9yCe9TZTgKMZD3LgrupjSR9NB52nHpKDt7Fz3l3IUzRH7rohQsAtni
	 NO+5o5ZDjWo7w==
Message-ID: <00b24db8-0063-48d6-8bc4-e8b670d8f0d5@kernel.org>
Date: Fri, 17 Apr 2026 16:37:58 +0200
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260227175518.3728055-2-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Stat-Signature: miqe3g3nqunaq43q3g96g93xtg8tq8k4
X-Rspam-User: 
X-Rspamd-Queue-Id: 774E01C0004
X-HE-Tag: 1776436688-794676
X-HE-Meta: U2FsdGVkX1+2Ez1L9ZSdrARtI9FXf5yD78070u2X754Cguyv+RBfkgdkDFueqeNNBq3SBJwu5bdH+IwpfMWvfzNp/7DnDDAaFz16pjeNyJNqwkOjHpL/esDH/PNsCFiPPWnW14f6vKqtS7bczx6u8WobNBOgu5aLXNX4vKvVeWNXYUX5hI9rDKAZ4BTVfWspklq054FBEmxRd/bt3utE7YuL9HcyslxGWku5aq7pIqpUl0A89zIEM9qUL7lZsW0f8Kv25KP6hJHuVQTi/kzhNnAUuWVHHdx2z5o1OTRR3hBBpiBQKOGVKW0N302W9WSZtl5qwlTYyT7iyf9NFxllNAWgMEU9dkAh2qVuuU8bLzqLoJB764dlXCUYGFz8XZqqtLpt2DIAxAEQISxrU1699BL4ptTkGHZqkwXrM+uZmvYtt76GxuLASuroDRUkKv7ldejzVRFLGce6f6ayMMSA5U7LcFZrgTdNyPCAjuc7kYwlRtLMc+JH8Y+5MwlUcXPQkw0aWRCjW84IPB/JI+pohannKgZtNqL0XBnv69O4u17r7eWPT+1WOcBIWmdzEZBIXO2JGz2SRxB9sqe12xkqq1OJVtjcUgkBpsRwWZf2dzjvabYgQwBZtXPKb5ptO1msVXa7q7M1JDkkxYhaj5hfqYDkcWsmO5qLIBJyIAW4ntE4glM0p0ATDjkOW26LfIt2eiHoZITSXEerMejB1cSIF4L7z4QhbIfBMPEWOSjtQDGuiSvJ8w/t3SOWuQ7lTKAfHjuC/4UacboVPGQESXJ/h3xM+bniktvfvN4IAf6A9hh6FKfC8jraKqCfQdI/sfcK2Jv9oLEd9oR3ehz7rRJ6T2T91Ct9DMQ0lkiMKM5g05trcRymF1Pd7rIyrFAOcVg+EErBUR5swI1xqs32By2xIDFhWHmGdkc2oTAU1rImxiy0/kXRUnVc8jGYOJSZKSYX5WIclsDG5Bxx4eEdKFo
 LdRTgqFT
 I7wjCYPSMOnnCzHtQLkIgJKILBj0j+5tsA3xhNNPNa7laJypuG6bG6Q1/5GhIJJl6Yz8Btzs7qdS7Z4QON+gEi3WGTJxkOz6IT/WDx8o9FmYM7wWS2kjJ7InugKC5UWMWDm7BdtKf2Rfvsi0o7h8euDsHEAKMjj1GxFX/rDBxVGfSnuM5ASGmzKMZw7hGZQ570Nqb/FqfDC9QSZmNnXEeyJs8gSUUrVmwxmI6//18n6UXqaV2YfsICULZ8LP6dt6XmIrD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 18:54, Kevin Brodsky wrote:
> kpkeys is a simple framework to enable the use of protection keys
> (pkeys) to harden the kernel itself. This patch introduces the basic
> API in <linux/kpkeys.h>: a couple of functions to set and restore
> the pkey register and macros to define guard objects.
> 
> kpkeys introduces a new concept on top of pkeys: the kpkeys level.
> Each level is associated to a set of permissions for the pkeys
> managed by the kpkeys framework. kpkeys_set_level(lvl) sets those
> permissions according to lvl, and returns the original pkey
> register, to be later restored by kpkeys_restore_pkey_reg(). To
> start with, only KPKEYS_LVL_DEFAULT is available, which is meant
> to grant RW access to KPKEYS_PKEY_DEFAULT (i.e. all memory since
> this is the only available pkey for now).
> 
> Because each architecture implementing pkeys uses a different
> representation for the pkey register, and may reserve certain pkeys
> for specific uses, support for kpkeys must be explicitly indicated
> by selecting ARCH_HAS_KPKEYS and defining the following functions in
> <asm/kpkeys.h>, in addition to the macros provided in
> <asm-generic/kpkeys.h>:
> 
> - arch_kpkeys_set_level()
> - arch_kpkeys_restore_pkey_reg()
> - arch_kpkeys_enabled()

Another thing: why not simply drop the "arch_" stuff from these helpers?

-- 
Cheers,

David

