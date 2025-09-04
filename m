Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54E99CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 12:58:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B26168E0019; Thu,  4 Sep 2025 08:58:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFD588E0013; Thu,  4 Sep 2025 08:58:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A18848E0019; Thu,  4 Sep 2025 08:58:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8ECD18E0013
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 08:58:57 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 58F8B56385
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:58:57 +0000 (UTC)
X-FDA: 83851572714.03.F68133B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id C1AEA4000D
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:58:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756990735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vLlXfKPxMlaUvMb/as1DeaEQrf2xWKKiAo/9OSQRFtg=;
	b=BUGUboriHUWUy/mgHMPaDAYPYj9Q4GQGGsSWM0Ne9QOaXoZl1roAZC+iJN3Cu+BxrlamN6
	fxUwH1vRJFXG3mAvZt9BsyZMwMH1RDu4h3hL91i+yGvEKGm9HcvNj0ffqNCsmF9Wqfk09R
	S2pqVVE15AwIGCrOYRxPtSe9uSk1O0Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756990735; a=rsa-sha256;
	cv=none;
	b=X38gjOfvPJDZ/ZhD+73CXW5VHJpDAJaesFlu6f5lJowCQbaJR8GZhgi4tLJrVajyKRQ02y
	Ncr8qPXCd8o9/Oyg9gtkhL36SOiwE2oJTTbyJCAPH0XFQdpB3kNTxTW2j5Du3j9dZ8W6dE
	S4oOh/TyqWyphs7LSUqRJJixiPFHtFM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A725E2F28;
	Thu,  4 Sep 2025 05:58:46 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 757883F6A8;
	Thu,  4 Sep 2025 05:58:50 -0700 (PDT)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jann Horn <jannh@google.com>,
	Juergen Gross <jgross@suse.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	xen-devel@lists.xenproject.org
Subject: [PATCH 7/7] mm: update lazy_mmu documentation
Date: Thu,  4 Sep 2025 13:57:36 +0100
Message-ID: <20250904125736.3918646-8-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250904125736.3918646-1-kevin.brodsky@arm.com>
References: <20250904125736.3918646-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C1AEA4000D
X-Stat-Signature: o9u7jnbwz95tt8ckw153ir1buf6rctyg
X-Rspam-User: 
X-HE-Tag: 1756990735-227346
X-HE-Meta: U2FsdGVkX1/60zBsfH43pYyzAwh8DKR2m46aWddOKzcDarW+oq72uzS5iYJzXSvjauhrh0PoDd42RMXMP04nWmQ0pFnrGSnARDEIDuXG70329LZhocKqBIf1v7B+zLJfKBS12ii4P/ewwkJVM82PySWS2BOQES5uFTda31zpB7ARPGu+PINUT/On0jbEaY0WCjUGU5Q7sKmUhaPYnAnGbDLlBLAlwPvtYxp5+U+Q7vmkkftrDeT3sE5AmgostLmy/znahcdCUIsm6f7PRx33oZgMtNVwsHjgFjFo4weBiqALxlA6HAyGAipe2XGqcd5W/omnus2suKxx/TrcfoKMTn/P30Jih6nkLdN2k/rn6uf7YXOnPn7uqTbE53f4zgvRCNh9CWrf2FDlwn4EdIbm2eCew33IhL504sUmuhjq8pXldD14dYXNsS77KX30q1AADe7rWqhnC3F0P/r2KGCZZaehiBnriZyYtwUCccS1ZcOTgSEbJDzIAxbY8/W2UwEaNdCkVIELae5CeYGZYL0VSoWxueQO5v4cxzcate7J0IgkjMsmBA37/rh1sVsDMtfDFEoRZNRsqevJj7eP1RYZt3VvLPEG4wr0gKzVS88aLStW/eo1cKnSgXpPpPb7g8FzWH8uP77/pcxaaRnWbWBj9iwmToEj/6To9CuNV6Wi4Mz0f/H7vpcOoJ7mdyHoLooUBQF9svavfjNOhL94zyvqDQ9bh1doced1lMVYRcZ/kiiMGdgMPm2/Hv4l89HlPrSsoE57lbJ1Jj2jdeHOAtObADvwNzojO4JLhveu+P8xV5Ee2EnjYjPo7A2Ss/7Q3rFkFAdsSMLZVshM8JSisDKKZegfZgFu+CpA4zQtXaJwCIEdNM9/07GANvQQ0L2XBJ+WcgikS5MU6Gp5BLLy3GQC/IV+6shphLwB8P4Tv7Qd6e/k3p3J/y3MIgtZorLXX6DYHxOnI4JhhEhLDOPFpuD
 O+JcDBJu
 JQY2Xl0jzuWeXUW/dKEbubdbGVlx3XmWiYX2i7YdExnY+w5VAuP92zl3EyzLclnyWvxVzPFsrVp9ZmnjBPbJoL8iGfuJuv8o5enA1p5VbcS4gQJLuRMNXdrEzx72KA1cxmCia7Z5u+NZS7KOFQ788JRt6WMgNFhrdAnJxdB0khczlb2t54P6PNnFxuLQJwaCFZP5lPbEOOFafbnjdisOxIpP1N/HX9ZMBHOoW7O6FQAo1+QA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We now support nested lazy_mmu sections on all architectures
implementing the API. Update the API comment accordingly.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/linux/pgtable.h | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 6932c8e344ab..be0f059beb4d 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -228,8 +228,18 @@ static inline int pmd_dirty(pmd_t pmd)
  * of the lazy mode. So the implementation must assume preemption may be enabled
  * and cpu migration is possible; it must take steps to be robust against this.
  * (In practice, for user PTE updates, the appropriate page table lock(s) are
- * held, but for kernel PTE updates, no lock is held). Nesting is not permitted
- * and the mode cannot be used in interrupt context.
+ * held, but for kernel PTE updates, no lock is held). The mode cannot be used
+ * in interrupt context.
+ *
+ * Calls may be nested: an arch_{enter,leave}_lazy_mmu_mode() pair may be called
+ * while the lazy MMU mode has already been enabled. An implementation should
+ * handle this using the state returned by enter() and taken by the matching
+ * leave() call; the LAZY_MMU_{DEFAULT,NESTED} flags can be used to indicate
+ * whether this enter/leave pair is nested inside another or not. (It is up to
+ * the implementation to track whether the lazy MMU mode is enabled at any point
+ * in time.) The expectation is that leave() will flush any batched state
+ * unconditionally, but only leave the lazy MMU mode if the passed state is not
+ * LAZY_MMU_NESTED.
  */
 #ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
 typedef int lazy_mmu_state_t;
-- 
2.47.0


