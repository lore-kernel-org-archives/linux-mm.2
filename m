Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D411606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 05:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WNn3QJ6Z
Received: by kanga.kvack.org (Postfix)
	id 413846B040E; Tue, 20 Oct 2026 01:55:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C5236B0410; Tue, 20 Oct 2026 01:55:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DC0A6B0411; Tue, 20 Oct 2026 01:55:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 098146B040E
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 01:55:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 819A81208BF
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 05:55:54 +0000 (UTC)
X-FDA: 85341943428.02.5EDD8D3
Received: from mta1.migadu.com (out-129.mta1.migadu.com [95.215.58.129])
	by imf05.hostedemail.com (Postfix) with ESMTP id E1DF6100004
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 05:55:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WNn3QJ6Z;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.129 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792475752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IJw3AdrV3TppvzYxPg9enasdEBHkQYF0+BiTA1BbFVE=;
	b=JW2R4QOEWnrw0xOHZv/3iXrEp+BD7QDmIn4o2JJRqwZ6cdMQnxWQtsPbl9Eu/DIGz6m5Ps
	H2c4j550Wgc4TTVVrcK2adieIUp8U+B+CYip10ComPNymGIAAHuW5hoD3k98sYw/ESIL+e
	XzdrXEsaLymafz332kiqbAm4aaDp0HA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WNn3QJ6Z;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.129 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792475752;
	b=oxJ0PgPSTSv3eDn48dG+Hzkf4uE5ULn9L7Bq1QjDSrje3Csy6TeRRoGmh/IA2tHwI7AMAE
	n5R62M66+EihqiKZF0QZPDCNMmSPYld23O9WqHyVr8E0aYanznEZ4aOh7yswxQNnG58qXq
	+na27Edcygiv6aGMcTxEmeAp3IBG+nY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=C5+9nPezz3Sstm3YSed1zRvKh9tUg6y9C6lbamjjq9w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792475747; v=1; x=1793080547;
 b=WNn3QJ6ZwXnvUZHoiJ0qChAwy37lgAnsBH0a6qrWQMT4N96cJoHCxn3lBBw0uYTzzDXwGwhN
 N5eTjm2ZLz+KXghZZeJXNRW56UHX1lA6TCNUBDkh8YaXGlaW278fnFh+4u795SCcZXvl/DuAks8
 XWJ7hvaKTzptWCYWki1yMRPk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6cfc978d2090e393;
	Tue, 20 Oct 2026 05:55:26 +0000
X-Mizu-Trace-ID: 6cfc978d2090e393
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: samarth.colleges@gmail.com,
	akpm@linux-foundation.org,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	peterx@redhat.com,
	kas@kernel.org,
	rppt@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/ksm: keep soft-dirty and uffd-wp when merging a page
Date: Tue, 20 Oct 2026 13:55:18 +0800
Message-ID: <20261020055518.36087-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <efa6a28c-f0f9-4d1e-9cce-fec2c08e7d9f@kernel.org>
References: <efa6a28c-f0f9-4d1e-9cce-fec2c08e7d9f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E1DF6100004
X-Stat-Signature: x9px8te64ucgu4exkwncoz8ak81excsr
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792475750-744614
X-HE-Meta: U2FsdGVkX1+GXwHDKXPcy/MeZMVFL/HH+GwUzMW/Qxt1b4b+KQ7EoWWyAMZN0eff0kTZU07C09SlCO6tU0x9mqL5B8rfnHk2v7b1x6SsoiQ+r9XxYglSyINd5kmQfk+zqwxLmhGNFZL2mBfFFNrXO8HjFGmTwd9UbjpM0ZQJxY9QhStYUWCqiUrWOeJsef1OLEO2YY0g1+KBIqxBcyZTWWdgUXmP5IY1FY2TKs7GmMWgjCiFwEmk2qjVXp7cgv4AmSl2WtgQVPF/l/GJmQNieVPnYnbm2GupfjHfBtfVgC58i0F9KedDic7UUs8g2fijaCGgEq38l6dYjtTEGR3WhmgcHdoUdoRntc7Q2KqiRv3q4UsKdbTO+nXM5OzFRAnEGIMHxsQSNqrcFzywzNBK+BYxI5c7fevokDEQ3iBkwN4bjcdcSOrWK9i3CqelJixeVZytgM2pV1/nQ+kx7cGAQvlcJY7XmVBvT7mxRB8eNz4ikP9ODb/ywV9uda+yWSWPaiE8uCvMSKgDLeK6fW0wuTWkVtgThjoqkE4xLz21LpI43hbAveY2/fwGoDeQNhaQWqQVVwwh4Wh90s/P8ITEMtOFMCVebY6LH4N43T7x7GFM9Zmmw72tKfI7s7igu9+fdi2CT32+9cvCvKwXLeuXgDYKCRbDAdaLDov5qIQtD0dUTbYDKWys+n6vnWCG5JUG0Cv4Xr00yiShcVhQJnfU3gIx9xs5btoqzJa8/DzbYHZMcpZsWBvZrW0wiJk6ZD4RzQ6nG+qqPAtV0RsRrEm48Wi7axhv/+ohkzwqraRHgN0glVi92HWuQkyT4HaZWooxlirMH8a8RuUjd2wKReG6B2iiC5zhKBzr9M6XjvmC9emvF7zPSCUTFNcaqTLlRwlb9fxPQa4syLRQ5qLa129KjmF8pE1DTKT6tGH2e7jIgdNXbDIMO5x/jmWVrBWEOX8EV49xhg4ZCG5rYWrOE7D
 b8R/fkl1
 ig2612iwSj+unzpQlzznlNdmTqX7J7woKjIKCJZIprHd5wQtCMuPl0Yo6BJnFnZGJAe5qIbk11im5gTClaDZcTyWvqOSCK3VBFtnLn0Smo/yIJwVJKCHGpqzKb79Dqc6eCej6QOdEQcloeAv1FXG3jW3n2JawB/GyqsbumIgdUH9k0jJnlGT5aGQG5M1yaMavkqMV1pBzZdth8ZQeloerMKyBEHMGBtgegP9qwzN5FmH2qV/4fkF6u0YsnC+NM8lXtDLYocysaJ4SzWgFGrfk5iSNIec+NA9hFR+cy1Ai92LBcXxa1K0JDFPz1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Mon, Oct 19, 2026 at 03:24:11PM +0200, David Hildenbrand (Arm) wrote:
>On 10/19/26 03:09, Samarth Narang wrote:
>> replace_page() maps the KSM page with a PTE built from scratch, so the
>> soft-dirty and uffd bits of the PTE it replaces are lost. Due to this, a
>> write before the merge no longer shows as soft-dirty, the next write to
>> a uffd-wp page raises no write-protect fault, and because the page is
>> mapped with the VMA's normal permissions, on a uffd-rwp VMA the next
>> access raises no RWP fault.
>> 
>> Copy the soft-dirty and uffd bits from the original PTE to the new PTE,
>> and restore PAGE_NONE for RWP VMAs, as try_to_map_unused_to_zeropage()
>> does.
>> 
>> Fixes: 0f8975ec4db2 ("mm: soft-dirty bits for user memory changes tracking")
>> Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
>> Fixes: 2d427bb01639 ("mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP")
>
>I would actually split that up into separate patches.
>
>Over-indicating soft-dirty (as raised by Sashiko) is in general not a problem.

Right.

>Losing WP bits is.
>
>UFFD, the gift that keeps on giving.

Haha, yeah, I stared at the code a bit. Say we arm RWP on an existing KSM
mapping, then do MADV_UNMERGEABLE. We're just replacing the shared page
with a private copy. That shouldn't count as an access to the mapping ...
no?

But the protnone check sends us to do_uffd_rwp() before the
FAULT_FLAG_UNSHARE handling. No FAULT_FLAG_ALLOW_RETRY here, so sync RWP
gives us VM_FAULT_SIGBUS. Then break_ksm() does this:

static int break_ksm(struct vm_area_struct *vma, unsigned long addr,
		unsigned long end, bool lock_vma)
{
	vm_fault_t ret = 0;
...
	do {
...
		ret = handle_mm_fault(vma, addr,
				      FAULT_FLAG_UNSHARE | FAULT_FLAG_REMOTE,
				      NULL);
	} while (!(ret & (VM_FAULT_SIGBUS | VM_FAULT_SIGSEGV | VM_FAULT_OOM)));
...
	return (ret & VM_FAULT_OOM) ? -ENOMEM : 0;
}

So we report success with the page still merged. Async RWP does unshare
it, but only after clearing the uffd bit.

I'd let FAULT_FLAG_UNSHARE skip do_uffd_rwp(). We'd still need to carry
PAGE_NONE over in wp_page_copy(), though. That PTE is rebuilt from
vma->vm_page_prot, so the uffd bit alone won't stop reads.

>How to deal RWP properly is a good question (see Sashiko review). I feel like
>some more stuff might be missing there to handle this correctly.

Tested, this is what I had in mind:

---8<---
diff --git a/mm/memory.c b/mm/memory.c
index 976cd03954e3..d99f5ef1dd8c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4119,8 +4119,11 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 		if (unlikely(unshare)) {
 			if (pte_soft_dirty(vmf->orig_pte))
 				entry = pte_mksoft_dirty(entry);
-			if (pte_uffd(vmf->orig_pte))
+			if (pte_uffd(vmf->orig_pte)) {
 				entry = pte_mkuffd(entry);
+				if (userfaultfd_rwp(vma))
+					entry = pte_modify(entry, PAGE_NONE);
+			}
 		} else {
 			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 		}
@@ -6656,9 +6659,12 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
 		 * VM_UFFD_RWP VMA, a protnone PTE without the uffd bit is
 		 * NUMA hinting and must still fall through to do_numa_page().
 		 */
-		if (userfaultfd_pte_rwp(vmf->vma, vmf->orig_pte))
-			return do_uffd_rwp(vmf);
-		return do_numa_page(vmf);
+		if (userfaultfd_pte_rwp(vmf->vma, vmf->orig_pte)) {
+			if (!(vmf->flags & FAULT_FLAG_UNSHARE))
+				return do_uffd_rwp(vmf);
+		} else {
+			return do_numa_page(vmf);
+		}
 	}

 	spin_lock(vmf->ptl);
--

Cheers, Lance

