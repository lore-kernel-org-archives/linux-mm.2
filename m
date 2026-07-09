Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AF85C44501
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 09:37:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 734E36B0088; Thu,  9 Jul 2026 05:37:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E5766B008A; Thu,  9 Jul 2026 05:37:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FC436B008C; Thu,  9 Jul 2026 05:37:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3EFB16B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 05:37:07 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C66AA12045E
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:37:06 +0000 (UTC)
X-FDA: 84968734452.09.0BB341E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 34C0510000F
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:37:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bjua/1Hf";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783589825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hNakBsw4iweOcBS9zSwRAtoEnClMELbyw+JCpMLKSfs=;
	b=xTkKfz1NFeqfwBHUCeDhKQmhap0bXsOdDBcJrKqaQkIT9bUhHRd2QpsTNsIB4hAuc2m2NK
	yzMr7qMHQm8NGZer6PLJoDjeQPrmk1mrkaES4PPf/DX3bRE3pvGqC+TkE6B/hXq9kJR3YU
	QgVynCwRXNNZe6N7SrUWOeLR2qUd+R0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bjua/1Hf";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783589825;
	b=WKbCtF0ko8defMwm5Ml5XuDNY0wf5etrzTLIe4l8s0XM5xQUC+95k5cXiRGPRoMXc4e8c9
	AuOFM5nDBB22lyjQg2U3zA3zk+pfHxOgBQnCu/X7b3MNQJiDRvYVuesEnAwA85WZIuY/Rr
	CFo65YLQaJdb16s9Rra82zSqggzqnuE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BBF6D600C3;
	Thu,  9 Jul 2026 09:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136001F000E9;
	Thu,  9 Jul 2026 09:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783589824;
	bh=hNakBsw4iweOcBS9zSwRAtoEnClMELbyw+JCpMLKSfs=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=bjua/1HfoFc53QViTJ0GuKCIL/s4jlPhIMR5FVcgg5aYp6ckAQohiJebCD3ra868K
	 YWz3M60GQUkcCfJexQjsivc/9YWUqnr5nHOrN062Yjbb4j6+YMLpdE1f9US85KvTSw
	 KUOsC/FhWTNkTvFHkus9LgaGhl0OxBBmOWU+DaYMFHCGRNHxjSC6pz5tLPwqT/EzqA
	 V3hwZ0Jd2KNEKiUDvTxgwoG7vpUYova251bMq8WAYNiPhyGSHjrLc+k8UwBoaAAqhT
	 FuzpAEm2zmQIKC+EVWHrqE+ai+iuKhji6sAmV6gskFAefmh6vehlUe6PXK+3B2ciqe
	 NKlKRpJsOcO8w==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 00/10] mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE (Part
 2)
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-s390@vger.kernel.org
In-Reply-To: <20260708-bootmem_info_part2-v1-0-156ce4986598@kernel.org>
References: <20260708-bootmem_info_part2-v1-0-156ce4986598@kernel.org>
Date: Thu, 09 Jul 2026 12:36:53 +0300
Message-Id: <178358981368.3970180.15161129072189513624.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 34C0510000F
X-Stat-Signature: 54cb96puxh6ex1s3f8sbnhzejkei7hzp
X-Rspam-User: 
X-HE-Tag: 1783589825-449056
X-HE-Meta: U2FsdGVkX196eE8ZcbaR2FrLlmHjxOIqXxRNCW3kxMe4MDrqcXDkCWc9QHwRzErUv9O0L5Veg8XqfyhiPv5aRe494xUTkE2iZ2m9otSVnkVUSdDje2NFUgCdIJ8/DdCsaRzqH8/4QIqMgSV9yReKEFBpXkLn26CHc3CulH+rXtr144fd/1zo/PG+wZDfjqziajSH4+27z1Q3uuoXQxXOqnppa7+FnKVgUaeDa4OzIlY1tJQ/t52IfRaeY2DsorDaLALcJOT64hEszyPl/9/IIJalNfWfw1Skz1CdrV4rlYInqWWCgNYxJ2rbK44SccjWfY16PuYfcSCYyIUoiu6jdvszAWQGECEj20z7eLUxSZrOFCoaK/0doeKFO7Bk4xnGqeLMMz0xMhwR1UBEe1DHfcZ4JpzzSWrSa7FKOy7pwew2FIVVwCPOEBXIOtLvxI3QP95MAk6ISe9uV67yLnqGrKZ4LLxjVrILJbKrr8pdKGROYkMVruu9oV/rEX80hgP3n+NfYB+lOVQSd5VGheFc549i8j9FHuwQK6CarxQ6ZpV0AlAYaXkm/6SZQ3EorplMxi7JI8fwNmK+b6Vw+FBDaoDW1mRsmpauXxWFbgybbbr6yYUYufFDcXk/+ZxZPiQno6CYDrap7e+6MaNawYSmE5UzK4jX+1RJkvRoPafhK1ma86KHrt1OQZcLXmkl8az/Doj6EHHmAsOgf+1Tk8TdWDskmv+wGUJG7m5VdgKuOHxLgQu9z4HP4zeKRxWAdyH88ndGMSX7n2aId8H10HUHJC99g07NsR6Kg1axu41tdcmu+fXlH3kAXRhILgzMAsOd+1mIZd/Yq7f3IW90aoaKH3et3RwqxnyCVScno9HDyQDdbGT2g3NUL6IF2iH5UDICd4jp8YTCdQcprbndUHj0ajqQ08Ld17aWiJs7L8RglY6kB3/7Q+Hj92tCAMb1lCtTC8eHbONhwbe5u+n2KT5
 yEAkHOK3
 7AXYOcEu1R0Q7sxsxJuxnGGyznalvjvsA1bHdw470l7XvCW5ImQr9IfAnY6HP80W1g4gSPkZmvsEiKsgbF4s45Q0wYuGxV+rdRTbQ5pU2372ATf44iWrGZXu0VivR1/awlmBv6MmCPfJO6a0ertdwu5sDqkpHx/Aiv3x8i5uV4Uzu1CCZ/gu5YLpdwUt28zQWq2T1Vy4AIQTAt31AHt3cuIJhKifSSreZH14lnVDx8zQjt7nEJZ2rlett1GcD5ktrRdpm307W5lesZVfLvnkoDaPEMSVprQieUJ0j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 08 Jul 2026 16:10:55 +0200, David Hildenbrand (Arm) <david@kernel.org> wrote:
> mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE (Part 2)
> 
> Let's remove the remaining pieces of CONFIG_HAVE_BOOTMEM_INFO_NODE,
> performing some smaller cleanups around freeing of reserved vmemmap
> pages on the way.
> 
> Tested on x86-64 with hugetlb vmemmap optimization in combination with
> KMEMLEAK. Heavily cross-compiled.
> 
> [...]

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


