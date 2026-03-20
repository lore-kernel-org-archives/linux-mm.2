Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D94FB108B8F3
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 10:51:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E3566B0005; Fri, 20 Mar 2026 06:51:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 094846B0088; Fri, 20 Mar 2026 06:51:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC4566B0089; Fri, 20 Mar 2026 06:51:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DB0736B0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 06:51:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 83BB51A0173
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:51:24 +0000 (UTC)
X-FDA: 84566124888.23.9B165FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id BDAADA0002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:51:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fvQ6q+Lt;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774003882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DKbCoQ3qBquckvlp019kFw7hXpGdetOvucEiY8aIUmw=;
	b=8I+QUisPMiDotrc2JnQAvsNpyfEKgdxdcb0RNk00G7DsMs1hIxs9aMCQ0QxhbEfv4fqyvm
	tLlWUeHGMJpyNK6Lc19SCzAYim+OgG/Z40w0hSrWxEQyawLiBRlyg8myxc4iBcHLHlbKzp
	V54hO2d78bqARk7Z0DN5pr4/XG7bJ/0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774003882; a=rsa-sha256;
	cv=none;
	b=hdl0SCi/Nw7SogqFCS4kXecaJzMQvFdDb2nsM44cvujdmVQZF3d2jCdPj+QzZQWigoA3f6
	HuP0Dsdps4ehh9CFoOx6BFAUjDfJW4ETqHvw1WyoZRjULxf7LWi+w9uxDBCGNa3WDGb/nD
	BaG+FPEKnkKFnUve0+3oKNXoxvZf+70=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fvQ6q+Lt;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D6D6F60132;
	Fri, 20 Mar 2026 10:51:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3393BC4CEF7;
	Fri, 20 Mar 2026 10:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774003881;
	bh=1kycPrv8xITwEF0VVuzOopEOMjAdBs0UtmKgTytYl8w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fvQ6q+Lt6csXQ3LFLwYm6cnCeDtBGCr02CIsjl1UXjYlr3fZ8BMsG3AFhxo458ZCa
	 +qYpGTorkZJUoSz2KLgM+8v53n1WJOnltl6z07l5stKzZpUnrWYEz5FYiN3Nd+Jdmh
	 8SClfiC2LO/qPw7ZNAT9I5oEK8JjSkMNRE+Nrm7ekRgipBjhHQB3OmHjgPWwn3piDZ
	 h9DkUtF/Zkavrff/L+X9y6IoV/GXTCjuHOFy4E/EZLIw/I9GYQQxnoeqCJ4GJE74BD
	 X+Z2q8v5Urpdb/OoxHDRr56qpMqMhQXXZ8oYFfyAhWL2CpRfz05crij8p1GJ5Qo9Ia
	 XZOMGmHBKHSXQ==
Message-ID: <077b237c-32ab-46a0-947e-17657cca5b54@kernel.org>
Date: Fri, 20 Mar 2026 11:51:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 23/23] mm/vma: convert __mmap_region() to use
 vma_flags_t
Content-Language: en-US
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Kees Cook <kees@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vineet Gupta <vgupta@kernel.org>, Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Brian Cain <bcain@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Dinh Nguyen <dinguyen@kernel.org>, Madhavan Srinivasan
 <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Michal Hocko <mhocko@suse.com>, Paul Moore <paul@paul-moore.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>, linux-snps-arc@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-hexagon@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-um@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, selinux@vger.kernel.org
References: <cover.1773846935.git.ljs@kernel.org>
 <c587f5ed177fd4f62b66cb8d5321fa56eeb6a69a.1773846935.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <c587f5ed177fd4f62b66cb8d5321fa56eeb6a69a.1773846935.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ytmwcyw73tcogtfe5heaicaxhqe71ord
X-Rspamd-Queue-Id: BDAADA0002
X-Rspamd-Server: rspam03
X-HE-Tag: 1774003882-43874
X-HE-Meta: U2FsdGVkX1/r5tA3if9Y4sjvAsa8oK5J2PyTlS35Hx8CghS0GX9c2cGZjIH3c/HCO1QFPkGTBsLiOwwa8cvT+uW2/r8CvFSolzPO/hY23kd58KUGB7RPEE5Y+XtrBff9YcNjlJOMfr0K5J7UxYhVyJtfy2ObKz3wV+Vc0h2OXKN90HhkEDpvWi6gCrfBmDBtWjjthaKyfZj/6BsQqJNP9uvx8vjEVUVe3gXfHfJjhVpucslhomv0bVU12ODKLLOsqOyravs7PI/IBlzLocp0DCzrJm7I918DNKCXur5to3TMDJAXYHSJKlWmEObxqoTKMiuEcPiXP3WK1Xaj/Zpv/fYw4KPSXo5K9giWR4mKp65jKz2KHT8yUaR4DtH9mK3NeUweNzRmFwZVIAhU+PuMLpBSYBFORvEU2ExCdvBufsWwaP/JUNrOvUuyrgQO0ipFkztlhJa28duvzL7fQVl6tnZLDRYGTQqNnXz4Tkgv0lNY27jhkBXn734WUU2O+tX61oiuPaRE0dVgPzPe3NKtaCU3J1uj9cWwYUH6Hbamskd1kcy2nnJVpNVvpnr9gQgB70ghxvT8yy914xXRD1HhRfEuqNnHfIGCUcGB7hajpn2+lb8eKQiUOSLvZXqRGWyOh+mKBCbvJghZTaY2NVMu6rDNQCJIgFQqwsiAjQRXCfaNJu9NnPA3pPe0E0uIx1b1jZD5EubRz8dB7yo+r3RUNZHtfTtFL15bBECqYLfWwtJlx3kk+i1iN7MAqUArQNxA3rk0WsTV9DVkQVHNjNxK4aYqx81OVsu8wejwlHLmaWlBRQojByFpxUdEUNtg6do/AGBNq7xvBExopbvvWq5jiwlghQK7qXXWM0XkNjmuFgZKQnMlJbkHmd3Vz37my58lbR4d2PYhmjvEi4MZBQTyj8iqwIminHaRgmWoP0rmqQXVwpArdfWhYRBX4bbLFZFh0zQgPlB/Vk1yaMwaPWT
 ujCddR1m
 QBZqXjOLF091/YCyX0IuJkS/cNs1jvAQNEARjMUZPL//bSberMLuO8BCxKMHbru4tnghV/QkuPlD8aziYmG9kQ/7ZEulfspGUTaTDKL49jHbzN82ZgubASrMR0C9rbonoHvb5gLJXGXIa+zPomWERL1hpyysvozcI4AaBBE3ZZKH3XO6GwXfDc7WUU611WwswtAiUQKHFwqDbAz+rzy7fN5C1yA3UAQiPOP2g454W5xi8/0qnk6y/FSUa1l0gLqkr2JloZJVczFCBMALfSBh1iFurFxpZdS/c/cm78M6k/EAxc6mwvXqxpDDfqCLbkdZtODm6Y7fdJllm0RlMAzIlRxgAAJan1AnJKE3BxEWklclNOiaInV0nNO1m2q9sJwVgFsKfzZd6SFsZI5bPmMYB/uoGnosao46TqWRfJw0xctEwNq8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 16:50, Lorenzo Stoakes (Oracle) wrote:
> Update the mmap() implementation logic implemented in __mmap_region() and
> functions invoked by it.  The mmap_region() function converts its input
> vm_flags_t parameter to a vma_flags_t value which it then passes to
> __mmap_region() which uses the vma_flags_t value consistently from then
> on.
> 
> As part of the change, we convert map_deny_write_exec() to using
> vma_flags_t (it was incorrectly using unsigned long before), and place it
> in vma.h, as it is only used internal to mm.
> 
> With this change, we eliminate the legacy is_shared_maywrite_vm_flags()
> helper function which is now no longer required.
> 
> We are also able to update the MMAP_STATE() and VMG_MMAP_STATE() macros to
> use the vma_flags_t value.
> 
> Finally, we update the VMA tests to reflect the change.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


