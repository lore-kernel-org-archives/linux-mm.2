Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E3FED4336E
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 07:10:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB8D16B0006; Fri, 12 Dec 2025 02:10:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6A1B6B0007; Fri, 12 Dec 2025 02:10:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7F8E6B0008; Fri, 12 Dec 2025 02:10:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AAB806B0006
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 02:10:27 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5BE5B13B062
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 07:10:27 +0000 (UTC)
X-FDA: 84209945694.25.893F035
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id B811440004
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 07:10:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f3JaFo7U;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765523425; a=rsa-sha256;
	cv=none;
	b=bmzToi2lUAU9fgXTsn+BCgVyQUFuainNRs9gfPhXsPuUnjKnfc5Sep+lyxzLoAw43sZm5b
	wS5C1T0Mm1qi6fI6/xWV/o8FqmRWrYvhwAtlbBLMrf2F9B6v6nSb8bZdqVvW/znDK18REQ
	AM18Xq7tTuCsxSXXXg2lBw2LTWzeCyU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f3JaFo7U;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765523425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2pvdkMLWPdG5VVT7KfXe00TlErXl7F/pBUH6TeedTlw=;
	b=d8eGJ3BcdZuJ0+a1hSoLFuGPqz4jIfhfsowWok4P4ijb2EFAMADi+fEXgVa2eVOvGMRiIu
	WZ1ChHam2d/dAGpIhgIU/h3INpyuuKY2daf7VLXS+UQV1kb83uhE6r/8/+uhCDqEZhyc2L
	w5jog2Z0e3QdUx9c020NMQzE/03yukc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 83DD64415D;
	Fri, 12 Dec 2025 07:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C211C4CEF1;
	Fri, 12 Dec 2025 07:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765523424;
	bh=dqVIubbkQVRJernqv5F3ELaqr4N3SUKjeivqxVsqbc4=;
	h=From:To:Cc:Subject:Date:From;
	b=f3JaFo7UNgQ1cS+tGpxQlQlH1Sdo1Fg6Esq7jGLZmQx4SnuABcKWUEiiAOvNYl99G
	 8GMkZzyMNFS8wxZ5qdAPs6tbEevDiwFqkhD3xQOieDms+iq8ESZqxQ8PuJH1M68h7r
	 R79RosnaRONJ+nN3JYvRUQ5V78dgIF1gEg2Ak5EY2iADIk8Q1qU9B6C2v2aVCimv0w
	 7+BRkpmK53dtEDF45oj//0VTQsqmtyYCegCUMUbV58F/xryXFrXxM8+iM+kio4pvy/
	 an5aeJB30efMoSJ1ijOs1Z1cR1IJGaRbl0+i1f6caBQXTcvfz9RPPPodCeOXEJltk2
	 hoYGctWHYUbIQ==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Laurence Oberman <loberman@redhat.com>,
	Prakash Sangappa <prakash.sangappa@oracle.com>,
	Nadav Amit <nadav.amit@gmail.com>
Subject: [PATCH v2 0/4] mm/hugetlb: fixes for PMD table sharing (incl. using mmu_gather)
Date: Fri, 12 Dec 2025 08:10:15 +0100
Message-ID: <20251212071019.471146-1-david@kernel.org>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B811440004
X-Rspamd-Server: rspam04
X-Stat-Signature: p4pajd1s1oc71ypp41yn8kw6og1t4fa5
X-HE-Tag: 1765523425-81714
X-HE-Meta: U2FsdGVkX18UnHCZRFa922CA9ZXpij573WHx2vMSVSq0RPikyjBrQf4G+ZroWAAyflVx07Bj1dhkG96PbQrwa5p8nn/BEf90WCQ9oNhnJxCSZ+pi3SR6R/OU7mS12bSSzev3SzNJ6rC3VuLXg2WWJ0Y5lNYtRpwJLrDa6RQVBurlVaporBAYycmvXdKxY+qyI/r4Xbut1R2UC0ljREYNXo+vAnH/UAwJ11YdAGc2j6ti7F1r+LrALwlWMqTpvd89zyay9NQVgvhlC58txjGpvu2KeMFdtRIE8LeslGU+NXk1qkXYfg9YQvdqcE8e9oL5cHnYmvvFTbORz0Wkz4AqXU26aLydpnRCtFlLPI30ehwuEkxG2NOXRFgdN8h2bka3T3265iXGrP90jRa4Wo4KnLcoiHUBnup9k5nhtTG4JvFzXHzpC79GI7k3vYZRE21H8QbkqVUJiJWqZRCQmN/YKhTVDjnNudqFSyJ9z6uoNDivBlI8ybHBgwGZ8C9f3JxXfJL7T7+pGVSgyiUD9xKU66CDYipE7xi9vPi3nZSaYREqHmOrQWGEmUBhMZCPpS2/BygsYsO2kg/GOKfSzSYtiFoLRSlV8fjtQd5nxBFQ0F1eaGFCfbSQ5nROE7lLUBkZm8QZMW2jfrzBqKnfWQy2s8kl1wlk9oClP73CFCgDPznadcsU79jjIPfbgQb32UPkD1AqOtzXHLjqYwdbUu1W/DNXUCdN56qCssbFgeakEFcId2diOUcEmE4D9RA+WmxNRc9ves7C7svihYhJ9jvTV3WVSC0CzX8KdUM36BAOpM7nqnpnTnKeb3Ez6sZSHz4sKJyPO5mOy6HEQCc78FjEGvVm/qCRcg6xbeKVZ4o+Va4T+X5v2Jl4lB1J9ZJNi7aO6UXiRIe7U9W8loWDKHkAwH6EjYp87z7SYO6yjGt5jzksMjTYM5ebi3fF8HufukWfqhUjFMtw0fK0GTgay2Q
 U0aMWqd/
 Ka7sLBX2jBlHpzrR5AFQE1oBOOMmklAzajiPpqZdiNZlg7esoJFFloG762O4bp1DdA/IFdY/OEArbeUzOdVa7T0iIzkvjULNF2Z43tiYGDZF0e2IjhO+WpJLMnoJwGcUW+JOJcjeopNNutCVJnIaZ8CHZ/DLCQYQOGyXUYgHbcyFKRO0a31VeDaTa2CrDlTxHm+/T/YtkBp0vvK/SlHCcirP2E6cftYngAp0it5OYPRPUaUnnualhBeV/DCkbjzZd+yXH8fnhNKP3qTcEwTjfrOQNIqYDLnjbNsU8LbPY3nue2h61fizHcMX0VTn4WRUEEKqTa+THPofoy4EqjS42Tq6lD3SP5St0y7gqEJOI54Z185fmYuN5DvM3/ke9U/jU1ADSxCUh4Npm1RsNeW2Ilm1tC0yUulRlmS2V+XJQ6Edy4KPdFHRc0tNTG8pjWwOAFFWFQnIVy5A/rdLefPPFHr/P31O2rLJBYHkfKQJOkvpjlqc2Eqv2VOycOsd3VvK9rvl2a0FevYCrdw8P/fZX7MXZyjWiINZ3nuVF1h1q11Ba9V/wFPoj3YyMhSGA58LJ7pjwZrY6EjxJUw3W1aipcYpuyxbhFZlZCfYNbTGoqTJjWiYSBEEL11IH3Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

One functional fix, one performance regression fix, and two related
comment fixes.

I cleaned up my prototype I recently shared [1] for the performance fix,
deferring most of the cleanups I had in the prototype to a later point.
While doing that I identified the other things.

The goal of this patch set is to be backported to stable trees "fairly"
easily. At least patch #1 and #4.

Patch #1 fixes hugetlb_pmd_shared() not detecting any sharing
Patch #2 + #3 are simple comment fixes that patch #4 interacts with.
Patch #4 is a fix for the reported performance regression due to excessive
IPI broadcasts during fork()+exit().

The last patch is all about TLB flushes, IPIs and mmu_gather.
Read: complicated

I added as much comments + description that I possibly could, and I am
hoping for review from Jann.

There are plenty of cleanups in the future to be had + one reasonable
optimization on x86. But that's all out of scope for this series.

Compile tested on plenty of architectures.

Runtime tested, with a focus on fixing the performance regression using
the original reproducer [2] on x86.

I'm still busy with more testing (making sure that my TLB flushing changes
are good), but sending this out already so people can test and review
while I am soon heading for LPC.

[1] https://lore.kernel.org/all/8cab934d-4a56-44aa-b641-bfd7e23bd673@kernel.org/
[2] https://lore.kernel.org/all/8cab934d-4a56-44aa-b641-bfd7e23bd673@kernel.org/

--

v1 -> v2:
* Picked RB's/ACK's, hopefully I didn't miss any
* Added the initialization of fully_unshared_tables in __tlb_gather_mmu()
  (Thanks Nadav!)
* Refined some comments based on Lorenzo's feedback.

Sending it out already as I have some spare minutes and we should start
queuing the fixed version. Maybe there will be some more comment changes
later based on the discussion with Lorenzo.

Cc: Will Deacon <will@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Uschakow, Stanislav" <suschako@amazon.de>
Cc: Laurence Oberman <loberman@redhat.com>
Cc: Prakash Sangappa <prakash.sangappa@oracle.com>
Cc: Nadav Amit <nadav.amit@gmail.com>

David Hildenbrand (Red Hat) (4):
  mm/hugetlb: fix hugetlb_pmd_shared()
  mm/hugetlb: fix two comments related to huge_pmd_unshare()
  mm/rmap: fix two comments related to huge_pmd_unshare()
  mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables
    using mmu_gather

 include/asm-generic/tlb.h |  74 +++++++++++++++++++++-
 include/linux/hugetlb.h   |  21 ++++---
 mm/hugetlb.c              | 129 ++++++++++++++++++++------------------
 mm/mmu_gather.c           |   7 +++
 mm/mprotect.c             |   2 +-
 mm/rmap.c                 |  45 +++++++------
 6 files changed, 184 insertions(+), 94 deletions(-)

-- 
2.52.0


