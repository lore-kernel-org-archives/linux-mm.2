Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E840EC0461
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 09:14:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8950D6B0093; Tue,  3 Mar 2026 04:14:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8731F6B009B; Tue,  3 Mar 2026 04:14:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 782926B009E; Tue,  3 Mar 2026 04:14:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 675866B0093
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 04:14:38 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 226988B743
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:14:38 +0000 (UTC)
X-FDA: 84504191436.20.CB41AC8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6FE541C0015
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:14:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=USIKCcfy;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772529276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KZuqVzDEGOw2W7NhruoK8lTgwOgg3IPbUkjLHPiX18s=;
	b=dteEh4jGnClEM96kBoOrM8YHowOcAY78ddXdsmRNV2x4XkSG/zjig8839VtUNKSZ7N5x0o
	dasLTM1vD4ir9qLXhg+hrVaZK+gCXD7TN1F2w/0sAtR6Toczy36NrSr0XCw6qWAzkjA+c5
	lnNHDJVVBNj05mJEv3DtI7morNaO5Bw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772529276; a=rsa-sha256;
	cv=none;
	b=4tX7B+6GVmIrvddExe2XErUsJ2UvXmrf56YcwtwQ/TZtAlJlPoBV3fxVV+FwJy9B3aD8RE
	McVDF52+3xxjrPcGBB+nsHYPWsEsNHYzPilxh6Y7J/xJAHAgZqqdH+3MNqrmLdFSTaCucD
	xM8Mdp+oMB13qcc1xgojLMsPWU4EiBk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=USIKCcfy;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AA65860123;
	Tue,  3 Mar 2026 09:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A338C116C6;
	Tue,  3 Mar 2026 09:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772529275;
	bh=nebsKFxWHvDeWv6vkGuVxj34OakOd/ZaK0485ZaVzHA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=USIKCcfyjFtFEaPVC8INwn/QcxQzBv9WvXILYl0bv3+zd6y8o59Z8T2xp/96MuKID
	 WXVZwZyF+NQf8/5ZX6S/e+n6zPWca4NpWLPI6kRbuHsiBgX7ErEQi3YfKZ/LfimwFN
	 mVvchsuZzrCGBWgSXJ2y5izJF1s1gFu90DK49uZ3OFMa8xoIZt0V992O1p0v/MCK94
	 26KJu+ManA0/aBVrzhxW3lk55nYrcFmC3azoj0lYcgBcvYhx2IZ6GjYdiziFM/fM+I
	 fpzYoF0Q3TWWz2PGtN0woOOjuaJT8WQzmGty7LLIA7r9IfCK3fJJhcdRKQIr1iB0fd
	 XXe5719IHqefw==
Message-ID: <64d31de3-e838-4352-abef-cc742a5e5a56@kernel.org>
Date: Tue, 3 Mar 2026 10:14:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] binfmt_elf: Align eligible read-only PT_LOAD segments
 to PMD_SIZE for THP
To: hev <r@hev.cc>, Matthew Wilcox <willy@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Kees Cook <kees@kernel.org>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260302155046.286650-1-r@hev.cc>
 <aaW-x-HVQpSuPRA1@casper.infradead.org>
 <CAHirt9j-appZ+Mn=8AoG=SW3Lrqi2ajdZDGp8yYWiBWkzBbQ9g@mail.gmail.com>
 <aaZyg0GT4_f52UEr@casper.infradead.org>
 <CAHirt9ikm_n1KHtOSBcUpBM3nNRX90AZhr1K0PaLZuL-8ww97g@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAHirt9ikm_n1KHtOSBcUpBM3nNRX90AZhr1K0PaLZuL-8ww97g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6FE541C0015
X-Stat-Signature: qkhoas1wd46ugcfhm598fu6e3zknt7du
X-Rspam-User: 
X-HE-Tag: 1772529276-423745
X-HE-Meta: U2FsdGVkX1+kjGGHf3D6V2fryeWtNG/PEdnyLnQyGJJZLTZvamZpEYqyLM+PgtDB0oozmHKphynP4pxJNqdvQHLAw8AAat+OpShYA6QOx8s1mNUFxAfAyNqMXGL8KEwZZkqql4soqfgzaUJc4VAR4mq+I3q64Y7+AoIDTTsDJH4rEaj0J1MjOUQZBKymiPMQjzYaYXXD/DZng4UEZIFrKpvuMVpYi3Axs1OgJTsjuOXkj5FtwvyUo+IfjRZmkFQeeV0SV3RQ6j0/4ffpAmWqyPi7UgncM+AMguAVeJLJ+aFIdB+D0/LB7Rurkm9h9NlAgG7AacW3eD8TZDPiAQrMwXs4FffY8pC0XiNtNJFvWAaDH4KPRM01EkwHDSNGw1wM8RbGqqQ5c56e+dUxXUuFNiW1AsjDqTbM21osiZxNMPnuVBEN3f34xz/PX/Tk1yBGm5Ba5L0gfNV37SSENPN+tufwK3WxPTYMTB4PT78a0Z6wY/j4r8B0ZE0Ryxg3dv/7eDzjOLcvsiQYzbPACyDD4RalWcz6AWXbxUqr6fdWP+65kUVUh7mRUEVPdHHM6DyKc4M1IOWCCM2UEbcV0q5q5w7W9/nr/zyjKdvoxzQXGTFS5idIlk/iL5BhbttziTc+JTA6ay3jXiXikrcebhO6b1zg85qL9PDkVFdFXIDnXA5ifwXgtclEz6SX+caerAO7pr+SIHJP5RnXYRh31G/ioI/z4mkyHCDiC+IdRNNSxM43QFjtjvfEZ86qqsDdqn0XOv7KOVHazl9xOnnYQnG6iLVnq5m+1rnFbpEHUlQsAUAf5eTKYseQGOzlXbEzLR6hLmQCkqNxAuVUQlLptdgyF120ghYBWRpRf9NiZPrvHQqE5nUJhCgIXiH16yjWLlERTNh4+aakqNVbSq2WjSlgl9rj0wnj01IAFHGkdLP55XnbgihvtAh3/CLXWl/vmPQkKjBVawYzMDnyRWLZr02
 87jujW6t
 cgt0ZJSNPEsaki1nkxxvA30StSPlOy+dqPzMqXRZqx/GTpJVLW4hz1pDLfuH2B08cf2w1mXOK2DouYFOjLvzzmRcb8Ea9fYDQV8+xQNOA+DHH79SJm+TuEz03OCPtSYkdxJ+ES+v9kExuJeRtGVHiBMdzuypQAG+iUE53EHUr2WNSt/KFdJ7Z619LCZjwX8RJKYKRZ61+e57Awc7H6i0e7uQqODDWDThewU5kCcZtZHSICmepT1KmXN8OVhLMWmXhsSSv5QJ4xuzVA6eVKf1RtfD6k+VyJxyQ/q2sI9Wkb6NNsEBRY+UUAh9eUzJaONG1TrvZiS3FwtPIlI7FukWsjha/rUsubeeqzihgtXl88aYJV5dd4/jOPbDoqL5Qn9p8yJIPUSj5yT8WcL4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/3/26 08:00, hev wrote:
> On Tue, Mar 3, 2026 at 1:32 PM Matthew Wilcox <willy@infradead.org> wrote:
>>
>> On Tue, Mar 03, 2026 at 12:31:59PM +0800, hev wrote:
>>>
>>> This optimization is not entirely free. Increasing PT_LOAD alignment
>>> can waste virtual address space, which is especially significant on
>>> 32-bit systems, and it also reduces ASLR entropy by limiting the
>>> number of possible load addresses.
>>>
>>> In addition, coarser alignment may have secondary microarchitectural
>>> effects (eg. on indirect branch prediction), depending on the
>>> workload. Because this change affects address space layout and
>>> security-related properties, providing users with a way to opt out is
>>> reasonable, rather than making it completely unconditional. This
>>> behavior fits naturally under READ_ONLY_THP_FOR_FS.
>>
>> This isn't reasonable at all.  You're asking distro maintainers to make
>> a decision they have insufficient information to make.  Almost none of
>> our users compile their own kernels, and frankly those that do don't have
>> enough information to make an informed decision about which way to choose.
>>
>> So if we're going to have a way to opt in/out, it needs to be something
>> different.  Maybe a heuristic based on size of text segment?  Maybe an
>> ELF flag?  But then, if we're going to modify the binary, why not just
>> set p_align and then we don't need this patch at all?
> 
> I agree that a compile-time config is not a good fit here, and I’m
> fine with dropping it in v2.
> 
> Relying on ELF-side changes is problematic. Increasing p_align in the
> linker inflates file size due to extra padding, and more importantly
> it cannot help existing binaries. The loader is therefore the only
> place where this can be done without ABI changes or file size
> regressions.
> 
> The logic here is deliberately strict rather than heuristic: the
> segment must be read-only, at least PMD_SIZE in length, and PMD_SIZE
> is capped at 32MB to avoid pathological address space waste. If these
> conditions are not met, the layout is unchanged.
> 
> I don’t see a reliable way to make a smarter decision at load time
> without workload knowledge. With READ_ONLY_THP_FOR_FS already limiting
> the scope and the THP policy applied at runtime, this keeps the
> behavior constrained.

A note that READ_ONLY_THP_FOR_FS will likely go away soon.

-- 
Cheers,

David

