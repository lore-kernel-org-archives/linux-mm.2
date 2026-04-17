Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 228B1F43693
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 12:01:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 799376B0089; Fri, 17 Apr 2026 08:01:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 770B66B009F; Fri, 17 Apr 2026 08:01:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6868F6B00A1; Fri, 17 Apr 2026 08:01:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 584516B0089
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 08:01:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D7DC0160151
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 12:01:05 +0000 (UTC)
X-FDA: 84667906890.23.5907FCA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 185664001B
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 12:01:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gixXRhDe;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776427264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o5i6ZwwLoLQhesYYrf2MVqwthd8ZBbpIOC2DaMlIh4k=;
	b=Kmm5Ks4DZ2WMsJfShN9MQcm5FY2io2ymg4HhYvoiIM0yU6MASBrSoba28e4hSzTAIvZQDE
	dQaMP2AvmbQzFXi22q0mur8yf6uz+91iDw3frc49k0gaLZEqnyuohV2MZbrJC0G57PbZ3N
	oKzVRDr1L8rCBCG4uugLG3VDHZTjYhg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gixXRhDe;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776427264; a=rsa-sha256;
	cv=none;
	b=L+/4h9n6fYqEYTVngEJP/stjWkNXAOotFUC7Hp5cKMyH66SeHpCni6YNJUQBv9loplJemF
	ZktkgtMDD1QP5OVAM42970NF1IJh3Ke8Cp/iPhzn78XZFyfyZygg9orq60aKFU8LrR+Y3p
	uSTKXq9pF5Q7Vro29YS8ZnLptCUF4/E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6076C60128;
	Fri, 17 Apr 2026 12:01:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2638AC19425;
	Fri, 17 Apr 2026 12:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776427263;
	bh=mU3rZj67IqrTTnj++/n+dIVHR+LNXGChH2TwgHtrl7c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gixXRhDebXpKk32RlamutnzhZ1GLLADsv69hPJWEWYEjKtp3w8dF8lF6PgtCGdwZM
	 tHyhMMIUE1WhuCUXAIevFo9WCqiNv6W5zqdELOSVxL8JkzeDVQP/bUGzP00tcpX5Me
	 8noj3V3GvefKdJTw10NZe+Dl1Qh7flMuer7J7K+UfzlR//frRT9NBnPz7gyBws+jj5
	 xD5K/9xYPH3+BjB4PtpVCdRXZvdqpJXiJtSCkbniaMGj83hycL+c6WB0+res+2nkir
	 1EB5YpMtEuQeKnM0Z7JXWRYUpCp3tkdfiWJmZrf6xu1CNqzLIqcS3OMLbBNOnef/jQ
	 OoJolHOLfmzOg==
Message-ID: <cf9da9e0-310b-4dc0-81aa-3154077fff85@kernel.org>
Date: Fri, 17 Apr 2026 14:00:53 +0200
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
 <eaca640b-5006-489b-8b2d-148a3c4073da@kernel.org>
 <fea9c939-f955-4020-bed6-427e592f0024@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <fea9c939-f955-4020-bed6-427e592f0024@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 185664001B
X-Stat-Signature: juu8fmywbay7rsetbb3g8gixbgfoa8zp
X-Rspam-User: 
X-HE-Tag: 1776427263-753911
X-HE-Meta: U2FsdGVkX18J1IMMrelVzuUb7BDX8nw/L+98ka1bqKefCmLuVmiJc2IYHTkGCEwVDWhdMBN4Yb2o/Z7snCjDyVRzd4wD7DRZApB7A/6xU0COebsf4suj1KrfaIVb1nwZp8PGgzlf8KCKh5VQYk/sYH4u0s/tBxieYDPmVjIyjkOYqVeaMAsx6d/sEAb203QwtmY9N8Y8avb8L+jGxMtsnphcb776te57cvqwTmVKqYIQy8ux4cJarTywpgiX6XtL5+Lcg39f5zYf/nMnctc4aDV9nxc3tg6C2oF8JRc7a2CAhchgMzoDyJ+4yMHWMrLAqLAcqDn3U2faEhWGazncQMYkdXixms60CQdq8FEW2wjdYPDE/Pw1bM7URGy86iqWCipYBcrTJ5uSlU2kswXbE/16vE+fAagLJKKJudm8BtWUmwf/IZcX/TWslHci0nBnu+W8a0kbQ0z2mJOmTWScJlyEJAQhllRclUaXR9W/iT9/2xR9bubEjEF8eWm8q5PwwRr42Ft+AGa6n3ZvMQ6SvmcSuoC0KVPRivYH5ZV2Kv5nk+TT0tlbsUR/d3nwg33JFnTpcweEgbTQgm6DuRTOB4hNpewOQHVXASOKAMAXdEZBhbAWu/Mw2i8z8lHx03nRxt+AmZ3Sazx0c+LKnacTLXYUjMgHo0MOXalHhhB8m0KQiuDz1Zl8SPLeWk1iCogv5iZlwkUVNCvCHYYv9aVpkkhVF1l0bpwfZTVb1OpfR+LXjGlMXVwBJsgfofqBgJQ7eZOp48sOI3iNr9eRRVQUJVPLq6u9W7PisyyemNeE0Y/uiTgFmy/+hBoxOHUzcHMdni1T41Ey8HE6bo6U/pVLtNHKfDCz/DX+egLiBSi5b0jr953bUbxwuJ06S+pcRxhpiF2TmKVcJIdPZG6cknatxRTupHn3lNV6KqHAzMwYDf7CWASjPGwj0Hji9qKXFcnzuU8iXiWVprVJCz5pvVr
 4nWhWKeC
 c2pHJ3D5ddiffRPgmcvz1/m3kxNhzIjQclrRVGmUwWHPnIw6BPGYGi4N0w+pMk3CZXvkX/embGhcBj889jNq6PHHsCpUgJatquCIze6E5tX46Q20hu9dhKLw03J+lvBkmWkltfF8hf65dXV3FSfQzbNgkwRob9I8pSORCo7yUFlFO+onX5crpvACjCJFIz2PYvETTzPOOQy5/BTiWmK2C+kEovI72v1OPt3DBmnJ9iJQqQ3Ny7AKjHVFPmgUIaQukhKo1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/15/26 17:50, Kevin Brodsky wrote:
> On 15/04/2026 15:00, David Hildenbrand (Arm) wrote:
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
>> I don't quite understand the reason for using levels. Levels sounds like
>> it would all be in some ordered fashion, where higher levels have access
>> to lower levels.
> 
> That was originally the idea indeed, but in practice I don't expect
> levels to have a strict ordering, as it's not practical for composing
> features.
> 
>> Think of that as a key that can unlock all "lower" locks, not just a
>> single lock.
>>
>> Then, the question is about the ordering once we introduce new
>> keys/locks. With two, it obviously doesn't matter :)
>>
>> So naturally I wonder whether levels is really the right abstraction
>> here, and why we are not simply using "distinct" keys, like
>>
>> KPKEY_DEFAULT
>> KPKEY_PGTABLE
>> KPKEY_SUPER_SECRET1
>> KPKEY_SUPER_SECRET2
>>
>> Is it because you want KPKEY_PGTABLE also be able to write to KPKEY_DEFAULT?
> 
> Right, and in general a given level may be able to write to any number
> of pkeys. That's why I don't want to conflate pkeys and levels. Agreed
> that "level" might not be the clearest term though, since there's no
> strict ordering.

As discussed offline, maybe the right terminology to use here would be
something like a "context".

You'd be activating/setting a context.

KPKEY_CTX_DEFAULT
KPKEY_CTX_PGTABLE
KPKEY_CTX_SUPER_SECRET1

What is accessible (and how) is defined for each context. For example, I
would assume that all context allow for read/write access to everything
that KPKEY_CTX_DEFAULT has access to.

-- 
Cheers,

David

