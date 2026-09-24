Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7BDEC9830D
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 03:26:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D84286B0088; Wed, 23 Sep 2026 23:26:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D34D36B008A; Wed, 23 Sep 2026 23:26:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFC766B008C; Wed, 23 Sep 2026 23:26:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9CF536B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 23:26:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A2070A0229
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:26:36 +0000 (UTC)
X-FDA: 85247218392.17.8EC3DAF
Received: from mta0.migadu.com (out-190.mta0.migadu.com [91.218.175.190])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7B0434000A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:26:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=boaSQqLh;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.190 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790220394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R3BWZhH71CkI6kIjfqREmsVNahheMeRs+lPAGQsvw7A=;
	b=1ZCaWFzq/H0mh9c4SPHASNt79X/M3cFtep1wXcRo5mCa8K81B5eWRFeBi/1EzKB/MJ6LWK
	w4YgXnwu9slP01cF7K2WNnZwfe2T/HlUmwZ0qzii/SN3heULEEThXfkfRM9eOvh22cQ4cV
	/JOeKNBV8ThiLmcYipb3MvrQTg7oSkM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=boaSQqLh;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.190 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790220394;
	b=czkjwIi9puHySO4T2GyMDHblCIUMkdg+CHHkXkZbZjTWMgrrX0rR2A+DR7ErHfK6j4shri
	INUxBJ9KqHg4+AZeExacaMQjz79Wi1W+VoZhoKnDZnwlLNGPmd+0g2lLRBGkP/3m7Y7Vwu
	QkpeF+YoSThyiTWuovFr2/0rUkPoQNQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2yvE0h+QEBEUSGV14adujKMIHz+x1ZjAZUB9qMU3ScA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790220393; v=1; x=1790825193;
 b=boaSQqLhxWeav01vI/cRBCmj7Imq76eq9HXWt4jpqNRTGVWvv1DKDO6hzjOSa2/B+6hzS9pR
 hTEcd2srgXUitB5PEXuEljSVGpA1n3oTYxPYD5EKtwaZavRbLqQlLy6uudJITOQBTKMDIsndvpp
 S2hSvZe7P62W2fl2POGh/rao=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ae8cc7886785f523;
	Thu, 24 Sep 2026 03:26:31 +0000
X-Mizu-Trace-ID: ae8cc7886785f523
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: ljs@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	guoren@kernel.org,
	bcain@kernel.org,
	geert@linux-m68k.org,
	dinguyen@kernel.org,
	schuster.simon@siemens-energy.com,
	jonas@southpole.se,
	stefan.kristiansson@saunalahti.fi,
	shorne@gmail.com,
	dalias@libc.org,
	glaubitz@physik.fu-berlin.de,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	linux@armlinux.org.uk,
	vgupta@kernel.org,
	monstr@monstr.eu,
	chris@zankel.net,
	jcmvbkbc@gmail.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	davem@davemloft.net,
	andreas@gaisler.com,
	richard.henderson@linaro.org,
	mattst88@gmail.com,
	linmag7@gmail.com,
	catalin.marinas@arm.com,
	mark.rutland@arm.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	tsbogend@alpha.franken.de,
	James.Bottomley@HansenPartnership.com,
	deller@gmx.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	chleroy@kernel.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	richard@nod.at,
	anton.ivanov@cambridgegreys.com,
	johannes@sipsolutions.net,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	ysato@users.sourceforge.jp,
	shakeel.butt@linux.dev,
	corbet@lwn.net,
	rdunlap@infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-csky@vger.kernel.org,
	linux-hexagon@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-openrisc@vger.kernel.org,
	linux-sh@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-snps-arc@lists.infradead.org,
	linux-arch@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-alpha@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	linux-um@lists.infradead.org,
	hughd@google.com,
	qi.zheng@linux.dev,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 12/12] mm: change the contract for free_pgtables(), update docs
Date: Thu, 24 Sep 2026 11:26:25 +0800
Message-ID: <20260924032625.28555-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260922-rcu-pagetable-freeing-v4-12-fe1ad1f1e303@kernel.org>
References: <20260922-rcu-pagetable-freeing-v4-12-fe1ad1f1e303@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7B0434000A
X-Stat-Signature: g47cq3iw64fowgqtbbuawsc59cfj3mca
X-HE-Tag: 1790220394-229661
X-HE-Meta: U2FsdGVkX18Bt8OaT30bkE2Wl1f+ka6zgzr8XYGRz77HXnxQj3EjyEaLnA4zS+Y3xhRaoiycIeOpWQ0QdMFX8kMly7FNRV/z2WPMj7kcSuGx5eHXlk4THELUGfmFuY1A0C2CAuhSqcxg04YdGSiPL4HdeoJd53DaxyTUkPWEeNgIJqkj/qCWn/+H784HOlMbcfKVFOURaf70s/xAbc/OZJNuA3WDyJTYEBhogGacimCni2fr+0iTv1/YEd1TWb2AQXz31g70eFyQ7f6CEG2+3sEyKlV2C+MJbKwiDQ2wk7lSjJqFqfXpDRDYmvAmSvmGs+d3H6HyXuAZnlvP1xEhSuHRN/DT/mXtUC8dlUpWD+R10cZVrxwjchDrfdleCxdbQONpwrdljk0zC7BqozN/zUyU6AHLv8AcwleoJXTDpVKPnxrNbkU+VFNruqy97M6j3HASpRDRAnw7LwQlUMCo8PvyZkWh3l2P7B7bqv+Tn6mfLcZVOjHdu+wBZInX8WLSxI/7C/wydxUjoryhMm3Ws1sieTvQHlP57QW69AK/IFAE7yM/OjBI7V/IRwQvrS+fz9f2sgQta/SkzwHOO5WOsOifArxlkD1urbAS+kpEMnBxUUsMhE4nNEm4kQMCYtD3HFSzhnk4kTTrW+PFE6i+1PiANXk06M6kiwS+3km88VrEzdY9sfrK9C/UOmNNPWe/WKLchvy7u0jqwiSKHFjA5BCHgCqxmBl+YaM6cYqiom5w50+Q5ZsCAdnBmlN3uFJ7/8+qkP3DFIah4jFleLR5k+S9Wg7OfIz0kXKngHxjiixxgu9Tp/7sOIkCHttEe+s6AHTPf/3dIWuBErPdAHmJqxQM+zPf7wkfliycaW7FKPpvKeYy8PbC6jkrBdQ9GTzLKYy5hlknsinenBc4cRUJahJQxUAKAHKv6/fT3UMee68WNWn7tLgW6iMbbx6w6M0hK1s8YBD39/aIs753H6m
 Q/POpTzO
 NiTq8jy8ePu1MRjWZPgeYJwMOibzHU7fYkGwuRuHn3xIyyuc/hL4BzBdab9ZYik420+/tJmdgPj1K704EoZl87/pnOxBCmoxWx4IB+62I36kG8TEHufgDo7L/sva8Eiy4gXDFdcbq5KQWkNRN0sUIEPJ1P+6Q/FSS2TnFGpSPP0EhcLsJKF4fdSb64eLNW7YAf2sD3Veo1Kh4PqKUsfWmOhsem1S2rPUaT4yXDD/M8PtffpDXmERUxaOnkri3rpzAqo+KWQbwEkmD3r4Spmo85om957jEDBVw7Sw9i6ZlTFoRrxAo7Y018QG1JNZiYGRZMEuEYERE2hqdwPIw8AZpVEnsi/ROFSGGFqEzL7Vdfgih4MnA4eClbTaf9/Rd6fdYS4fz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Sep 22, 2026 at 04:35:43PM +0100, Lorenzo Stoakes (ARM) wrote:
>Now that page tables are freed after an RCU grace period, it is safe for
>read-only page table walkers to walk page table ranges that are being
>concurrently torn down, provided the mm is kept alive via mmgrab().
>
>It is however unsafe for writers to do so, as they must obtain an
>appropriate lock to do so safely.
>
>Update the pte_offset_map_lock()'s comment block to reflect this.
>
>Similarly update the process addresses documentation.
>
>Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>---
> Documentation/mm/process_addrs.rst |  6 ++++++
> mm/pgtable-generic.c               | 15 +++++++++++----
> 2 files changed, 17 insertions(+), 4 deletions(-)
>
>diff --git a/Documentation/mm/process_addrs.rst b/Documentation/mm/process_addrs.rst
>index a7296f251799..b1f4f44d75eb 100644
>--- a/Documentation/mm/process_addrs.rst
>+++ b/Documentation/mm/process_addrs.rst
>@@ -537,6 +537,12 @@ We establish basic locking rules when interacting with page tables:
> * When changing a page table entry the page table lock for that page table
>   **must** be held, except if you can safely assume nobody can access the page
>   tables concurrently (such as on invocation of :c:func:`!free_pgtables`).
>+* Page tables may be *walked* under RCU alone, as page tables are freed only
>+  after an RCU grace period has elapsed. However, any entry found must be
>+  revalidated after the page table lock is taken (such as the
>+  :c:func:`!pmd_same` recheck performed by :c:func:`!pte_offset_map_lock`)
>+  before it is acted upon. Changing an entry requires the page table
>+  lock and one of the locks that excludes teardown (mmap or VMA lock).

What about rmap walkers? try_to_unmap() clears PTEs under the rmap lock
and PTL, without an mmap or VMA lock.

Cheers, Lance

> * Reads from and writes to page table entries must be *appropriately*
>   atomic. See the section on atomicity below for details.
> * Populating previously empty entries requires that the mmap or VMA locks are
>diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
>index b91b1a98029c..a127e3e8f9b9 100644
>--- a/mm/pgtable-generic.c
>+++ b/mm/pgtable-generic.c
>@@ -385,10 +385,17 @@ pte_t *pte_offset_map_rw_nolock(struct mm_struct *mm, pmd_t *pmd,
>  * Note: "RO" / "RW" expresses the intended semantics, not that the *kmap* will
>  * be read-only/read-write protected.
>  *
>- * Note that free_pgtables(), used after unmapping detached vmas, or when
>- * exiting the whole mm, does not take page table lock before freeing a page
>- * table, and may not use RCU at all: "outsiders" like khugepaged should avoid
>- * pte_offset_map() and co once the vma is detached from mm or mm_users is zero.
>+ * Note that free_pgtables(), used after unmapping detached vmas or when exiting
>+ * the whole mm, does not take a page table lock before freeing a page table.
>+ *
>+ * As page table freeing itself is RCU-safe, page table readers can safely run
>+ * concurrently with page table teardown.
>+ *
>+ * However, writers CANNOT as, without a lock being held, nothing prevents
>+ * concurrent teardown.
>+ *
>+ * Also note that the PGD itself is freed at mmdrop() time, not under RCU - so
>+ * the walker must keep the mm alive either by pinning the mm or the VMA.
>  */
> pte_t *pte_offset_map_lock(struct mm_struct *mm, pmd_t *pmd,
> 			   unsigned long addr, spinlock_t **ptlp)
>
>-- 
>2.55.0
>
>

