Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02B3DCDE002
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:09:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4B586B0088; Wed, 24 Jun 2026 10:09:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFDEA6B008A; Wed, 24 Jun 2026 10:09:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC6286B008C; Wed, 24 Jun 2026 10:09:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 880686B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:09:15 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 111AAA0367
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:09:15 +0000 (UTC)
X-FDA: 84914988270.21.C2ACA9E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 02FF680011
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:09:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OiNFnmXN;
	spf=pass (imf02.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782310153;
	b=QB89rrnziYzWqub0fN68sidGc0NF2BaYBk4fxZNsDX92x5GKGAPWyj4hgNmobSLYH/E9Je
	HrFlT+9Zt2SK+bZHF8KHh7xBN5ha3M6AJX/ELmMDK0DOC48lxk2UinErVFjnLBwDeKkvle
	uU8cm71hOj6bb73XhGcxAnA5WN9h+x8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782310153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DCLmR55W2y2LcSwcefjaxs66OcgM2Bl6pzHm0IePw4I=;
	b=eiNXKG0d2WKSLFwymyfguDlNzRZP1+OirndPjv7UnFbfQhZAI0t27FgmU6BMgm9eoQoMJb
	uJBRZrf4SK6wyg2IB9kkNVe9HnQNGvIqOUDjpRZz+NMPFLdtCM65fGdSffl3GVOwt60CJ5
	JlAxSsEK299Z4hpfV+b/zlL2iIW9T4M=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OiNFnmXN;
	spf=pass (imf02.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1FB271E4D;
	Wed, 24 Jun 2026 07:09:07 -0700 (PDT)
Received: from [10.2.198.93] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C4CB93F62B;
	Wed, 24 Jun 2026 07:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782310151; bh=w4/5Am6wou3JOsUXE2kUVgm79vny+93dIdQA8wNcKUc=;
	h=Date:Cc:From:To:Subject:From;
	b=OiNFnmXNtLXavewQIhaLvL+L4iTjRXShbqIIuYDnv+MORl8xz3QYtigtIv8ACszD9
	 oFKXRHjRFjnqtGe4ewvOW9Gszi3zt8j3sz5vkpJOiQJkCtV9E6JCjwWRb4P87igMFB
	 nxt+LdBme0INFrj+HgX2KsZwYmZaL1hwixjWlfmg=
Message-ID: <74182e50-b54f-4d2d-a27f-3a59a538d6bc@arm.com>
Date: Wed, 24 Jun 2026 15:09:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Language: en-US
From: Usama Anjum <usama.anjum@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, David Hildenbrand <david@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Samuel Holland <samuel.holland@sifive.com>
Subject: mm: opaque hardware page-table entry handles
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 02FF680011
X-Stat-Signature: nxg76uaqo685g9w6tdjiooaea43qfxnt
X-HE-Tag: 1782310152-905342
X-HE-Meta: U2FsdGVkX1+fmknyLZiZv8x1f9c+IIbkiQqt+iHfp48tFWFlQrqkb32JmUr2rbEQgCxwr1/8bqRCV5LOn0jk1PlTZD1sCrQwc7uJXGy3S9HrsWAmdLiEDOK7lZNk60HcZlHmflbt/K+bv/a+RWe6B1CkJbP0C6QX0TMJOh0h5yBoe9BW64U6id6axu1GPWe1H3lmlXNvaolB/CnycO5ofKwbtBtBrPzia0HB6nH8WTK2l95a9wwiqguhnu4LStW474cm3FnAKX1C/Qyxw5OqOrFz2ifoubQqgsirH+0boVS84Q30ohkpXtvoNOcfb/eWjXE1vuNKVGM9r6s3o+hz+rIs7VtSsT32hjwe8XIvvEtm4WqSz0Q175k8uoYvKvI/c0mTmoCRxkvTeR+eAxfEUzu7leqFOMy5T71Og1PqUNwFO6wiwVPhJixMAZhMuALHX+esYoPOo51HXUXm6swwWdwTHJ5b15/xR9jnaZ7elGOxTuo2wvngj3FW6CoCaywUKo8sEHdATzG95t/VwQ7yPrl/pbUrRSbDbaqqOyHEP/Z1sb2Gm9l+K/z3YfLseaPdFVhD6N4xgPu8CdWq18J++DI9Xp4zHTNfJVeC+jytZRlKjRColKFidnZI8RFstJ8n/eAPdsD37LdWHdEmo3KR9jQpmPlnhSIumabTZqqQqnzUmOo0JmMT8P1Q9WfgjYuvQUri7yZkO7LwHSV8J72c8CH4l4//6v5Eu6/cLPCwbOWNqWB3ewbYaIUtaj0AmghfLUnywdGPw8dl2PGsy/76wI/juIoREJH0flfEINQX6/oisqdLqTdjIaeMy6BjdfvsePr2INFwwu5fjKxeSekzz4RfSvkWeWW5dKBIkt/6OkaCkPwhXvEwns6a1BWPBtSFZXtV07Wn4sdoMTpTHu1dW7UNkWeJwfOtCNOs4DXMrVbGmP4WOL9W/+D4dgv/qlcjPdhPYWzUveTlDiSzR32
 iG3Ff9ZG
 Y1uUjK4CDLahKqRhzbuCklmA50sLaAsPvH5qh5dFoSSh36Iv+K8xbx6YWgPmO3xawYdTiDqU+iyrGExgmM8cPvArtNmgnaanT5rE/L8QLd7BVom5RhdOy/WBgrwxD4lJbPhCIAbG9PZ7XDC/aU2C8yQXg3l7WV+4LdutPFPu54s4XniX+9SGVTlqGMrweEk0KYL0yf+sEK0kDwHNUGTW8xrzVc2XnyeWcACtLlNx2DCfnFo/5JpROX4yaOQ09H66ssnS/gWuQDNQWssCPvz418KPfJCsXGuzoyQRV6En4FYExkCBhja/SOI+bOLaAdi5QIEg4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This is a direction-check with the wider community before spending time on the
development. This picks up the idea that was raised and broadly agreed in the
earlier thread (Ryan Roberts, Lorenzo Stoakes, David Hildenbrand) [1].

The problem
-----------
Core MM code reaches page-table entries by raw pointer dereference (pte_t *,
pmd_t *, *pud, ...) in places, implicitly assuming a single, uniform
representation. Sprinkling getters wouldn't solve the problem entirely. The
problem is one level up: the *pointer type* itself is overloaded. At each level
there are really three distinct things:

  1. a page-table entry value (pte_t, pmd_t, ...)
  2. a pointer to an entry value, e.g. a pXX_t on the stack
  3. a pointer to a live entry in the hardware page table

Today (2) and (3) share the same type - pte_t *, pmd_t *, and so on. Nothing
distinguishes a pointer into a live table from a pointer to a stack copy.

A pointer to an on-stack entry value and a pointer to a live hardware entry have
the same type, so the compiler cannot distinguish them. Passing the stack
pointer to an arch helper that expects a hardware-entry pointer compiles fine,
but is wrong - a bug class the type system makes invisible. It also blocks
evolution: an arch helper may need to read beyond the addressed entry (e.g.
adjacent or contiguous entries), which only makes sense for a real page-table
pointer, not a stack copy.

The idea
--------
Give (3) its own opaque type that cannot be dereferenced:

    /* opaque handle to a HW page-table entry; not dereferenceable */
    typedef struct {
	pte_t *ptr;
    } hw_ptep;

With this:

  - a stack value can no longer masquerade as a hardware table entry,
  - a hardware handle can no longer be raw-dereferenced,
  - cases that genuinely operate on a value can be refactored to pass the value
    and let the caller, which knows whether it holds a handle or a stack copy,
    read it once.

The overload becomes a compile-time type error instead of a silent runtime bug,
and converting the tree forces every such site to be made explicit. This gives
us a framework where the architecture can completely virtualize the pgtable if
it likes; and the compiler can enforce that higher level code can't accidentally
work around it.

It is opt-in by architectures and incremental. The generic definition is
just an alias, so arches that do not care build unchanged:

    typedef pte_t *hw_ptep;

An arch flips to the strong struct type when it is ready, and only then does
it get the stronger checking. This lets the conversion land gradually.

Beyond fixing the latent bug class, this abstraction is an enabler for upcoming
features that need tighter control over how page tables are accessed and
manipulated.

Getter flavours
---------------
While converting, it is useful to have two accessor flavours at each level:

  - pXXp_get(hw_ptep)        plain C dereference (compiler may optimize)
  - pXXp_get_once(hw_ptep)   single-copy-atomic, not torn, elided or
                             duplicated by the compiler

Keeping them distinct simplifies the conversion and avoids re-introducing the
class of lockless-read bugs seen on 32-bit.

Example conversion
------------------
Most of the conversion is mechanical.

  -static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
  -		pte_t *ptep, pte_t pte, unsigned int nr)
  +static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
  +		hw_ptep ptep, pte_t pte, unsigned int nr)
   {
   	page_table_check_ptes_set(mm, addr, ptep, pte, nr);
   	for (;;) {
   		set_pte(ptep, pte);
   		if (--nr == 0)
   			break;
  -		ptep++;
  +		ptep = hw_pte_next(ptep);
   		pte = pte_next_pfn(pte);
   	}
   }

The bulk of work is this kind of rote substitution. The genuine work is the
handful of sites that turn out to be operating on a stack copy rather than a
live entry - those are exactly the ones the new type forces us to surface and 
fix.

Estimated churn:
----------------
Half way through the prototyping converting only PTE and PMD levels:
  77 files changed, +1801 / -1425
  ~57 files reference the new types

So the line count will grow once PUD/P4D/PGD and the remaining call sites are
converted; expect meaningfully more churn than the numbers above.

Introduce the type as an alias, convert one helper family per patch, and flip
an arch to the strong type last - with non-opted arches building unchanged at
every step.

Open questions
--------------
  - Is the type-safety + future-feature enablement worth the churn?
  - Naming: hw_ptep/hw_pmdp vs something else?
  - Should all five levels be converted before merging anything, or is a staged
    PTE-and-PMD then landing others acceptable?
  - Do we want the two getter flavours (pXXp_get / pXXp_get_once) at every
    level?

[1] https://lore.kernel.org/all/a063f6c5-2785-4a9f-8079-25edb3e54cef@arm.com

Thanks,
Usama

