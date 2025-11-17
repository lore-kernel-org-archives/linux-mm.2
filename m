Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A516CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 22:54:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72C358E0017; Mon, 17 Nov 2025 17:54:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 704938E0002; Mon, 17 Nov 2025 17:54:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 641318E0017; Mon, 17 Nov 2025 17:54:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 52DD18E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:54:20 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EB68B13A78F
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:54:19 +0000 (UTC)
X-FDA: 84121604238.21.E9937C9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4A60E180008
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:54:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="XgtT73/Q";
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763420058; a=rsa-sha256;
	cv=none;
	b=kJnLRbkyfG5Vt0P/XJ/IXIiIVyrp7htqJ3NYyxA2vpHvI9OeCEtOIZMrc8Be/f4jPzcuW1
	R5zx5X/fRa+/+7c9WzmaUznwono3z7dxYkYvrwSFXxSvDs3zC/nsP9SpUDOPL7mWg1Datk
	UyzVZQzVqWa7nqj3sZYfTFDSgy7vJ9Y=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="XgtT73/Q";
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763420058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zx4L0YokpLMZXd47xL6namEvjwVpS/CdZkyEmvV+cIA=;
	b=UKWDXhPMOtwaBPxGpmWoFZffNeFjiddQu5ClG1Yk2Gk/t3AJEnKw47w47j9zkSo72zCX6n
	duGm8mgetWB9ca+X1psjEfHqhUdtN5RQItRuz2AfZen9JoBx8Qh51jZWS03lttDOdxC+lR
	uAaa/CzL9EGYKbEfs8LY2WCjv8h5tM8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0873943D7C;
	Mon, 17 Nov 2025 22:54:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3734C2BC86;
	Mon, 17 Nov 2025 22:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763420056;
	bh=vdqfGnVe7I9MHRJbwZ176INY948zJgxrzjBYmugLPk0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XgtT73/QnbYISnm8iHaknziIy67cQI178pnbw/AH8EuC9gNLsgmyDdejPUFjCLp0U
	 dRG3unJ13wfib4+NbSaPhdbaDi+RPgq3K2kv3z6eFwZ0SItdiY1/faxqSt/iqceX91
	 YnQ4mdoYwAhGVECLJmNwNmrmRLqgQL5uLUE0cuDo=
Date: Mon, 17 Nov 2025 14:54:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm: propagate VM_SOFTDIRTY on merge
Message-Id: <20251117145413.badc72b4bbddc0978c64c3eb@linux-foundation.org>
In-Reply-To: <955478b5170715c895d1ef3b7f68e0cd77f76868.1763399675.git.lorenzo.stoakes@oracle.com>
References: <cover.1763399675.git.lorenzo.stoakes@oracle.com>
	<955478b5170715c895d1ef3b7f68e0cd77f76868.1763399675.git.lorenzo.stoakes@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4A60E180008
X-Stat-Signature: 1ohbfb6snh56o5nu95qxq93qn6ry6z9h
X-Rspam-User: 
X-HE-Tag: 1763420058-913311
X-HE-Meta: U2FsdGVkX1/BpybcatSYehE8ZAZ8EHxCURYu3fC6/ZmYIzwCcC30QEcikeeUhcukj4nFuxLrw19WTy3Q9OBXwU5GG/MTdU/SrQyy3x1pCT38dBrnixgOrj5RLbZS+fJJayQQ6e4a1MnCYuQCz3lXp8Sx2EPPx0NVwhlz1lekubqNP8Qokh6TkLb22m6Qn732Nz0khWhYjbaL8eR/ePteS098eVcH/zPgKbHBH9nAIbIcv9O199sHyhwBzQbzT360CNe43Yz6csQ3IsGxszf7JityoC0M5urFJ7pQuc7biu7tvmH5WnlR/qE4V+N8BJ5e0zL0f2eadGUlAKKGIzZvZA1qgiwf+N5Gv7vujDIwd6+4lm5HQs5iCUOeOJPE8FlkentX0G0nqsK8seT4c7plCSGXJU+Bwbc2LvzsNHpyqp79E53EJFHJBZeo8npAbnyLHTN2CJ022pg6EfErYrf65WBkE0Vvjde3YgidsssopBZx52P1BigwkzApx6XmNBAtBZhYuwv20iO+ddcQYG4NkH8vm3u5Z6TEZVBdVnpmqi8kEDUVQ4wjOxhhBRZr+eFQ7AuG8YRqifMo7Sd1pDsFLAfP0Fwauq7LKKFolQTzZ86LiXT7qmQRWxfN33Za0aXwsWrLtSzVBOwSdMujQSE9X3md0Yd1MWwXK892107a8Y++CmjuMacC7EbwygFLw/Hbrqh9zxkQLvufDFkLMZGz7EJG/w30v0867F4Kiw2RJevMIPXvS/VWndb/IH2aEzXmAtW+RL6pQ4QFm7GB5opCxBBqA/JKfy5z836b0H3LiyI3mxhuUFwLMc9vU3ToAq2k7kh+/BSZtEtWWuy/AQBR9Hl247y/NOSfhF7qwbdYYoTKxMgW4zvcaXbLAFgVIUbF/4gU9ijdKvfCd5UGE+FiN7npOZDDs0eVvwWSL6BONAEbxq0GXjdS01IIjH2dqk57sUrnE17TyPoPmsYcMON
 7hEKIH9h
 XmitB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 17 Nov 2025 17:33:38 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> Currently we set VM_SOFTDIRTY when a new mapping is set up (whether by
> establishing a new VMA, or via merge) as implemented in __mmap_complete()
> and do_brk_flags().
> 
> However, when performing a merge of existing mappings such as when
> performing mprotect(), we may lose the VM_SOFTDIRTY flag.
> 
> This is because currently we simply ignore VM_SOFTDIRTY for the purposes
> of merge, so one VMA may possess the flag and another not, and whichever
> happens to be the target VMA will be the one upon which the merge is
> performed which may or may not have VM_SOFTDIRTY set.
> 
> Now we have the concept of 'sticky' VMA flags, let's make VM_SOFTDIRTY one
> which solves this issue.
> 
> Additionally update VMA userland tests to propagate changes.
> 

Oh.  This patch messes with the comments which
mm-implement-sticky-vma-flags-fix-2.patch just altered.  Not sure what
you intend here, so I left it as below - please advise.

(also, I fixed a typo: s/most/must/, both files)

--- a/include/linux/mm.h~mm-propagate-vm_softdirty-on-merge
+++ a/include/linux/mm.h
@@ -532,28 +532,28 @@ extern unsigned int kobjsize(const void
  * possesses it but the other does not, the merged VMA should nonetheless have
  * applied to it:
  *
+ *   VM_SOFTDIRTY - if a VMA is marked soft-dirty, that is has not had its
+ *                  references cleared via /proc/$pid/clear_refs, any merged VMA
+ *                  should be considered soft-dirty also as it operates at a VMA
+ *                  granularity.
+ *
  * VM_MAYBE_GUARD - If a VMA may have guard regions in place it implies that
  *                  mapped page tables may contain metadata not described by the
  *                  VMA and thus any merged VMA may also contain this metadata,
  *                  and thus we must make this flag sticky.
  */
-#define VM_STICKY VM_MAYBE_GUARD
+#define VM_STICKY (VM_SOFTDIRTY | VM_MAYBE_GUARD)
 
 /*
  * VMA flags we ignore for the purposes of merge, i.e. one VMA possessing one
  * of these flags and the other not does not preclude a merge.
  *
- * VM_SOFTDIRTY - Should not prevent from VMA merging, if we match the flags but
- *                dirty bit -- the caller should mark merged VMA as dirty. If
- *                dirty bit won't be excluded from comparison, we increase
- *                pressure on the memory system forcing the kernel to generate
- *                new VMAs when old one could be extended instead.
- *
- *    VM_STICKY - When merging VMAs, VMA flags must match, unless they are
- *                'sticky'. If any sticky flags exist in either VMA, we simply
- *                set all of them on the merged VMA.
+ * VM_STICKY - If one VMA has flags which must be 'sticky', that is ones
+ *             which should propagate to all VMAs, but the other does not,
+ *             the merge should still proceed with the merge logic applying
+ *             sticky flags to the final VMA.
  */
-#define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
+#define VM_IGNORE_MERGE VM_STICKY
 
 /*
  * Flags which should result in page tables being copied on fork. These are
--- a/tools/testing/vma/vma_internal.h~mm-propagate-vm_softdirty-on-merge
+++ a/tools/testing/vma/vma_internal.h
@@ -122,28 +122,23 @@ extern unsigned long dac_mmap_min_addr;
  * possesses it but the other does not, the merged VMA should nonetheless have
  * applied to it:
  *
- * VM_MAYBE_GUARD - If a VMA may have guard regions in place it implies that
- *                  mapped page tables may contain metadata not described by the
- *                  VMA and thus any merged VMA may also contain this metadata,
- *                  and thus we must make this flag sticky.
+ *   VM_SOFTDIRTY - if a VMA is marked soft-dirty, that is has not had its
+ *                  references cleared via /proc/$pid/clear_refs, any merged VMA
+ *                  should be considered soft-dirty also as it operates at a VMA
+ *                  granularity.
  */
-#define VM_STICKY VM_MAYBE_GUARD
+#define VM_STICKY (VM_SOFTDIRTY | VM_MAYBE_GUARD)
 
 /*
  * VMA flags we ignore for the purposes of merge, i.e. one VMA possessing one
  * of these flags and the other not does not preclude a merge.
  *
- * VM_SOFTDIRTY - Should not prevent from VMA merging, if we match the flags but
- *                dirty bit -- the caller should mark merged VMA as dirty. If
- *                dirty bit won't be excluded from comparison, we increase
- *                pressure on the memory system forcing the kernel to generate
- *                new VMAs when old one could be extended instead.
- *
- *    VM_STICKY - When merging VMAs, VMA flags must match, unless they are
- *                'sticky'. If any sticky flags exist in either VMA, we simply
- *                set all of them on the merged VMA.
+ * VM_STICKY - If one VMA has flags which most be 'sticky', that is ones
+ *             which should propagate to all VMAs, but the other does not,
+ *             the merge should still proceed with the merge logic applying
+ *             sticky flags to the final VMA.
  */
-#define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
+#define VM_IGNORE_MERGE VM_STICKY
 
 /*
  * Flags which should result in page tables being copied on fork. These are
_


