Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C496CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:34:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 587AE6B0096; Mon, 28 Sep 2026 13:34:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55F186B0098; Mon, 28 Sep 2026 13:34:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49C1C6B009B; Mon, 28 Sep 2026 13:34:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 18C1E6B0096
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:34:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 962D81602AE
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:34:33 +0000 (UTC)
X-FDA: 85263870426.07.DA26EE5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0227C40004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:34:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H+w+Z9wE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790616872;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QAKyyibYUeejb8Whf31Eer9u3DhP0lRlPQeFXRFIdSk=;
	b=CnYTSjsqWxgL6rkH5V0DAGTjxtifEO85CL5dDIZ+gED8x/qVR5zivXeR+dQLJSZezzzRHU
	okRPCgSSFKnm4V4GFfQUB/1hXfy2xFskaACRLOQkK64ZOgH0XVJrhVciXokcwdFOEuuTaj
	Mtx5cGswnNK2qzUfq/SR+FFWi0x4hQY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H+w+Z9wE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790616872;
	b=z06nJwtOBY2JiepZ3QA7ltKewfkoMgPoQ40H8QhRH+8LwOYdn0Hdi19Td7wMymPcBSilX7
	FICxo/x3hsD5+mfZoZKRnmGHK260RVhVBgmfjfCZAy3nenCN/4Sn+4J/2ZS48DGmjWqKMm
	DJPTzLNVcciHZP+iQ65pyZ9MOcNf0U8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F7C2601FB;
	Mon, 28 Sep 2026 17:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F581F000FF;
	Mon, 28 Sep 2026 17:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790616871;
	bh=QAKyyibYUeejb8Whf31Eer9u3DhP0lRlPQeFXRFIdSk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=H+w+Z9wESnUyUk1z3NRUG0aKCTTmaliwJI3UJqNW92EDEx8yWt5IWQ7pyBzgIWwpf
	 edziuZ/MPBo4XgajXrK04hsrEOa/zvy+Ot0IOy60OhSRWI2Td9beXuchZesaQMJd5b
	 Rx0cT24384Qwv2um+9adZ5rPfGE9gkhKL3XL4T7h46kvSYWRzvBblgSqMGdYAp84z9
	 aY6v/2Uk75AUlow9mwHVkzL9YGx+gShh09W6Nwo3BqNgD1a8qNofxUq2ZVccFNV60v
	 nLG95gBh5yDckaxi0qJ/k1pkDigOBbNcvJ6/0B53eAbdssIAMPXl8HHzmteeMssO/b
	 a062/NVRAXUPQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 08/12] mm: Add VM_CRASH_MARK
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mimi Zohar" <zohar@linux.ibm.com>, "Michal Hocko" <mhocko@suse.com>, "Mikulas
 Patocka" <mpatocka@redhat.com>, "Mark Rutland" <mark.rutland@arm.com>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Jonathan Corbet" <corbet@lwn.net>, "David
 Howells" <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Usama
 Arif" <usama.arif@linux.dev>, "Arnd Bergmann" <arnd@arndb.de>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Saravana Kannan" <saravanak@kernel.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Muchun
 Song" <muchun.song@linux.dev>, "Benjamin Marzinski" <bmarzins@redhat.com>, "Will
 Deacon" <will@kernel.org>, "Nico Pache" <nico.pache@linux.dev>, "Alistair
 Popple" <apopple@nvidia.com>, "Suren Baghdasaryan" <surenb@google.com>, "Harry
 Yoo" <harry@kernel.org>, "Rob Herring" <robh@kernel.org>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Pedro Falcato" <pfalcato@suse.de>, "Oscar
 Salvador" <osalvador@suse.de>, "Lorenzo Stoakes" <ljs@kernel.org>, "Zi Yan" <ziy@nvidia.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Byungchul Park" <byungchul@sk.com>, "Peter
 Xu" <peterx@redhat.com>, "Baoquan He" <baoquan.he@linux.dev>, "Mike
 Rapoport" <rppt@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Barry
 Song" <baohua@kernel.org>, "Paul Moore" <paul@paul-moore.com>, "David
 Hildenbrand" <david@kernel.org>, "Gregory Price" <gourry@gourry.net>,
 =?utf-8?b?SmFuIFNlYmFzdGlhbiBHw7Z0dGU=?= <linux@jaseg.de>, "David S. Miller" <davem@davemloft.net>, "Jarkko
 Sakkinen" <jarkko@kernel.org>, "Herbert Xu" <herbert@gondor.apana.org.au>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Alasdair
 Kergon" <agk@redhat.com>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "James
 Morris" <jmorris@namei.org>, "Randy Dunlap" <rdunlap@infradead.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Mike Snitzer" <snitzer@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Danilo Krummrich" <dakr@kernel.org>, "Jann
 Horn" <jannh@google.com>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Dave
 Young" <ruirui.yang@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Rik van Riel" <riel@surriel.com>, "James
 Bottomley" <James.Bottomley@HansenPartnership.com>, "Matthew Brost" <matthew.brost@intel.com>
Cc: robh@kernel.org, "Eric Biggers" <ebiggers@kernel.org>, conor+dt@kernel.org, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, linux-security-module@vger.kernel.org, linux-arch@vger.kernel.org, linux-crypto@vger.kernel.org, keyrings@vger.kernel.org, devicetree@vger.kernel.org, kexec@lists.infradead.org, linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, driver-core@lists.linux.dev
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-8-e511e9ee2329@jaseg.de>
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
 <20260928-crash-memaction-upstream-20260921-v3-8-e511e9ee2329@jaseg.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 17:34:25 +0000
Message-Id: <20260928173427.06F581F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Stat-Signature: 79xj1ktrwjotxnbtyfa13safeit7y8wh
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0227C40004
X-HE-Tag: 1790616871-391156
X-HE-Meta: U2FsdGVkX18Zny8ym4K1Q2JA2r5nNWGhLz/rKMokknbqp0YIhI949ohi4PSTxCwubR+RDTyRK7DgNlqzdSwpoZulTCf1SMjv8zpmXKH0pXFLpZ6clTaDTEgp8srwj1bJgO8QYXJjOKQVIhKkNU5iEh8JlBMdZHoqG7PshJ3U1MuiDe2ZHQ+9gWCZWfdQ6U5zuK+xnGAMLIAFyTYUJ9NEtee8bxVGFtnP4fmt/whYdfTqInoNWMzKtsgqyyzNtLIg5LbB0oZ5XfZx8GQ7TErmbOcqZep5HCCS+k23Iqok8RBPXethiredIFA/ZSvRBsOPN53Jf3hSm9528X+FhB0FULjvqIC34/jGBssyLLKex4oe834rOqSk/B6JqzAO7TnlrZDq8K27fBpUEPnWcps2lmGOR0G844jtidDfjCZyFoFnmf/yX4G0rjB64Dnigcd5CIhy0LYfjkwaI3/sUAY0/0mCDTdFryd+KjK3y90NAGyJVNakHivwabFClmzekZLaunyXEUWNOTslk+oL7KeazuizKxyYxTZh97WSpb3CEHL3yJRQmh+h4qcFin2m4sVltJRydE7ayVE/DzqDjd4xN4sIxyZArEtc+wWldzNWmh7Cvtn+jnAHR3OpuA85TQt60FhhfoEJajNUAW4xGeHlUoK9gxRRepofLMJKi/Fu9hTBFXV3mZbtuMPKfu5uxcRLWWAbZsvIe2fMsxpbrFVzG0k8miXL9n9FHaVLxgzBODoVAqBgnUwv3TCw6MtTv0jXgY0hmfIzU59wOx+Yd/tzqKRt6lJ8TNq5cJeNid9g4MV4337iuFcHkJc5UCWLY44Nhm7Mqk+gP5wbU5Y7c/+K8GJvfZHCGB66OlTYf9jYvFOPLtonL/qwXMj5yAV/ybX9gj7wIKG8BnGZm8rNGaPgDlaWEkJc4ZMa+h0fVatsrqELdNbfMeCBQ2sXhfBIVSDFnNpcXHwtBX59Or3Vwt7
 xmmr+1TL
 9q5W9ahQR+Gkv8YxHPwwloiUTQPemfPpoiYJphyViskg2IdAiBL6gXt5+biyTMc9j0ShjUHfL9lkRGVXIRol4s2zvwLWXog13pzfg5m0u+EZzYV5HH6jPQJkbGj8/r5EcgpTiTRRo8yCKqQvS+283iP3XjkfanPybYti4H0q7v97SWg5ZRIuQSI+TGc2Z6NKGiZ/+KFAZm7gA26C6GC7biZ5cmmf3P18lOlwWquiu1r8Xkh/22/FGBgumMoabVfi2EFYQI2O121PR13P/vUfLWEOOrCkE3GXVY7feNAX83Oc2ZmEReliyLF2jfQ0aNz50756oDOCiIMs3Uu3QqULpl/UkdqlDp56cgR4ngOEsSGBrsx3f7SGqNBNBeGtAY8JsscDUCvHSmFgun7pnzX3QI55cxBpDQmH8JgAad7+zhW2Fus/wbjPxe7JiCzpfNMuYseXKqdduiCx5k8tIGwwty2LY08s1lm1j5npSZJXK7uALgWwrDD7fSOkMcIhJfwXZlTpCukvu66VRHSjQH+dofX0sQg5DwxxNC9PMmjTAOPr6MhkwvCjk90DOnngaw+6TwzCtepUSEFZgUen6YuH/d9iCur2Q0em3QcEkgb1M1dfLQlZpqojq5AcMo5z1BEPvEHK9fK33BZ5BbFp60HZmxvy3C1K64dOKSCBMhrfQadZCpspLjrz7T6G9biBvOthaylA9uiXq2M7+GKfMVmTMaxKkhjD7qbrMFfpD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Low] mm: VM_CRASH_MARK missing from ftrace mmflags VMA flag definitions
- [Low] mm: proc.rst missing documentation for 'cm' VmFlags mnemonic
--

commit 7b00e78975a449ed080eb0472f9ec80a85b781f6
Author: Jan Sebastian G=C3=B6tte <linux@jaseg.de>

mm: Add VM_CRASH_MARK

This commit adds a new VMA flag, VM_CRASH_MARK, to describe folios mapped
into a VMA to the kdump kernel through crash_memaction. The flag indicates
pages to be handled based on the cmdline param, such as secret or cache
pages.

> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index c0d228036b8a6..880946edf4dfa 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1161,6 +1161,9 @@ static void show_smap_vma_flags(struct seq_file *m,=
 struct vm_area_struct *vma)
>  #endif
>  #ifdef CONFIG_64BIT
>  		[ilog2(VM_SEALED)] =3D "sl",
> +#endif
> +#ifdef CONFIG_CRASH_MEMACTION
> +		[ilog2(VM_CRASH_MARK)] =3D "cm",

[Severity: Low]
Since this adds the new cm mnemonic to the smaps output in show_smap_vma_fl=
ags(),
shouldn't this also be documented in Documentation/filesystems/proc.rst so =
users
reading the smaps file can understand what the string means?

>  #endif
>  	};
>  	size_t i;
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index b9ed4f569b75f..4ffe6350f8655 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
[ ... ]
> @@ -526,6 +530,11 @@ enum {
>  #define VM_ALLOW_ANY_UNCACHED	VM_NONE
>  #define VM_SEALED		VM_NONE
>  #endif
> +#ifdef CONFIG_CRASH_MEMACTION
> +#define VM_CRASH_MARK		INIT_VM_FLAG(CRASH_MARK)

[Severity: Low]
When defining a new VMA flag here, does it also need to be registered in the
__def_vmaflag_names array in include/trace/events/mmflags.h?

If it is omitted, tracing tools capturing mmap or madvise events might outp=
ut
an unknown hexadecimal bit instead of the human-readable crash_mark flag.

> +#else
> +#define VM_CRASH_MARK		VM_NONE
> +#endif

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928-crash-mema=
ction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de?part=3D8

