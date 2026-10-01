Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2764FCA5FD4
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 15:45:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC2A36B0098; Thu,  1 Oct 2026 11:45:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E72AD6B0099; Thu,  1 Oct 2026 11:45:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D88836B009B; Thu,  1 Oct 2026 11:45:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B0D1F6B0098
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:45:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 52E15A6F76
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:45:46 +0000 (UTC)
X-FDA: 85274482692.11.BE77B07
Received: from mta0.migadu.com (out-130.mta0.migadu.com [91.218.175.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 20BF31A0007
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:45:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YFaUIhte;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.130 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790869544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ReqqWbGMvi38gydPXELZRUBZ4FjpERF4lS/+qM3aO08=;
	b=T84dkJ4dhvoI9WUnFl4OJMBenueLLtdrmDBLydisaCSr49/0bhT56znPM6Xs6gUHwmQlTZ
	Y+XnRirFnq+KCi5nUS8YQdXwgmmHE/8h3CGbT7GdWuOCzMRoVcLKMurWtMnf3hNVcHT8RL
	x1gPBwaP6Ns/wdJnm5OT7FuS1WRrCf4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YFaUIhte;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.130 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790869544;
	b=3EC7g7mA/R/gp9NrIVCo8mNWI+9/K/3IkPkfDsnHeSMYVZ8KkhkTtsjg/ggNsIOoImPYTD
	CVbS1MbfqtyjqhFX5BcxZBgcJ76gRISNcQRog7/TGq1H3bu91l9U7nNrh8VYCIwpy6iBlD
	2kjzD52uR2371MY4SJP5fY0h4PBJgDg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JOy7DkelCAeiC88nHfcYGEwixQThCGsgfdS2goti7zE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790869542; v=1; x=1791474342;
 b=YFaUIhte7dfArGHra6wbDTlhEK1SEX3zH160EA5Dvjq7HOgA14xtI4gQbUWwNaI+GGbSMJeb
 tIso/aVRxtUVH8c5RWWZyBNB28cG4/QP43Kux66rKYSxFhhHfmEeT5We5sUvHPnk0mW9JY5ggRY
 hRcsnlAtPqe0DKgPMTb2Ls94=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8ca44e7eeceaf043;
	Thu, 01 Oct 2026 15:45:25 +0000
X-Mizu-Trace-ID: 8ca44e7eeceaf043
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: ljs@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	pfalcato@suse.de,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pan.deng@intel.com
Subject: Re: [PATCH v2] mm/vma: don't remove VMA from rmap if pgoff unchanged
Date: Thu,  1 Oct 2026 23:45:11 +0800
Message-ID: <20261001154511.23931-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260930-speed-up-inplace-rmap-v2-1-ac1aa19708aa@kernel.org>
References: <20260930-speed-up-inplace-rmap-v2-1-ac1aa19708aa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 20BF31A0007
X-Rspam-User: 
X-Stat-Signature: 7hddco6wdegw3x41oi5ysujme6y5rmrj
X-HE-Tag: 1790869543-695243
X-HE-Meta: U2FsdGVkX1/VyfxmUZhdv22tDuzFtxvt0nUTOahsOJWdOrKfLk0wXv/81AXbDeyYjrYF06kdcESi/gvjmRuHor4P0DoG2ZOVBEGjzcPPtGf9d8eEqtDgLCR3Ojn9k2uzkX6IKGQNyJo9w332j7dpDob7RIVUtatQpzQ7HP7g5Jp605uPW1sC049LyYeP9rSUU94j0ev1z0nojKfvWgXMiQgYb2zuQwDiRN5QdD+SRhCf5Dzm4BVJE6BIaRZFTqHAxF0v1w6HOQpeVcznqwwu7mTDSKYkHmk69UK3hITlIOU2ZYdFrtas7ibUfc81DEPFNKgXPkZubfPbCc41i9YWCC2FuwsZr+Jjva4oe36DtpNZ9XAhasqjDsIX5JvNfkyTMgcUqOWFWoTWCgdW/aRA6mnIrMJY7yqeEqdEEbjmrmyG0r4pGBsfiWjJKQGmX3ehKbiqNUIB6mfzWK0J5tkNTh2ZB9ApkPNwv7BQX5ovqoUjWvE8BMluek52ch7g+6yVSGWruJ3u7yLKFoMTPf4LBGTD62i9FZ5KkO7YQ3rbbYpnEsW3hwdmAKzPUgrgJ9+EKQlrPTnNy24Ssg2nLOj6rA3fLoylggy7mvaljp4qFu30L5SWS5aY9I7jfuZD4fhlDSPz/ycigm/JDbiJ4rFAs9X24tgpcMXhF/YK0KnHxmVBd7xgKadcrp0Y2fGWN93T9/cLFBA61YilIkoybMOxBELTn81FpWb+lntjBtQKCT3xFA2fuc1UmaUwiXyUaVO2/ZSCh09G4vd8f6He038OrYXsmgilO/P+xzb5hEWjTAwhf+6FzV4KXzcf/SO75ao6D0vxbJQExhak0na+rmQkineObJP0q4WCsq3qwP7ps8Av0LZGktf8qFYfrZwYKdh9xbnaptwXzCaQQdNIqWsijNBKgrL/S7wa3iRuc1xdPhawjZ5WhXKMoYbvZeshJWiygSdfM6qpr0qp6Xwhq5r
 onqZeB3I
 uTfmx9aTh9TBVQMCh5HR22gAc4odwDOiY95r0rmzYx3kDRv9ZPx8pCv0R865GHcztlJZK71fqYkGHkd/CUkSCmGHCGcghjO2JOvE4r6D3aE8gfev3PCVRHPSeey158FDnlVs0hUIgcSnA0lw0vqg0WOoHuEBzE7aFLDEuNpkOHiLp+AygCRH0j6iU9gh/Kvznis2UhbXasCVXnBxBSCyMKOiQ15TR/ykZDvr8Mj1Z24gDnbviGJV63LMMiLuA63S9xOttw7tawtbIXBNy0qcDqXlYbTXmQZ1yq1JfSxwPB+qts97meMeXIMd5o8QYJ4rVePj4vnvsuB+1sxHwHrKpi1fxNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Sep 30, 2026 at 06:53:36PM +0100, Lorenzo Stoakes (ARM) wrote:
>When updating a VMA, vma_prepare() unconditionally removes it from its rmap
>interval trees under the rmap lock, and vma_complete() reinserts it before
>releasing the lock.
>
>This is wholly unnecessary if its page offset (file rmap) or anonymous page
>offset (anon rmap) is unchanged.
>
>So, track whether they will change in the newly introduced
>vp->file_pgoff_unchanged and vp->anon_pgoff_unchanged fields, and use them
>to determine whether to remove the VMA or not.
>
>The rmap lock keeps things safe as no rmap walks can concurrently occur
>during the operation.
>
>Additionally, some architectures (arm, parisc, nios2, csky) have dcache
>flush rmap walkers which take only flush_dcache_mmap_lock(), which is
>likewise held across the operation.
>
>If the VMA remains in the tree, it's necessary to keep the augmented
>rb_subtree_last field updated to reflect its changed range.
>
>Provide mapping_rmap_tree_[pre, post]_update() and
>anon_rmap_tree_[pre, post]_update_vma() (replacing the existing logic in
>the anonymous case) to handle both the changed and unchanged cases.
>
>For the anon rmap case, with CONFIG_DEBUG_VM_RB set, avc->cached_vma_last
>is also updated when propagating in place.
>
>When performing a VMA shrink or a split where the VMA is the lower one, the
>page offset cannot change, so set the flags unconditionally in these cases.
>
>When merging VMAs the page offset is unchanged only in some cases, so
>update init_multi_vma_prep() to set the flags only if the page offsets
>remain the same.
>
>Finally, while we're here, also update expand_upwards() similarly.
>
>These changes ultimately result in less rmap lock contention.
>
>Pan Deng reported results using the UnixBench/excel benchmark on a 2-socket
>192 core, 384 thread x86-64 system for v7.3-rc4 with/without the patch
>applied:
>
>Execl Throughput, index score:
>
>                    avg    %stdev      min        max
>  v7.3-rc4        3511.5     0.44%    3494.5    3543.4
>  + patch         4069.0     0.48%    4047.4    4109.5 (+15.9%)
>
>Average wait on file rmap lock in ms, 5 runs per kernel:
>
>               avg      %stdev     min       max
>  v7.3-rc4    9.470     2.91%     9.070     9.820
>  + patch     8.420     3.34%     8.100     8.770 (-11.1%)
>
>Profiling data obtained during the operation highlighted the file rmap lock
>as the primary source of contention.
>
>Suggested-by: Pan Deng <pan.deng@intel.com>
>Reviewed-by: Rik van Riel <riel@surriel.com>
>Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>---

Wow, pretty cool stuff. That's a nice speedup!

[...]
>+static void anon_rmap_tree_update_inplace(struct anon_vma_chain *avc)
>+{
>+#ifdef CONFIG_DEBUG_VM_RB
>+	avc->cached_vma_last = avc_last_pgoff(avc);
>+#endif
>+	/* Propagate all the way up the tree. */

Nit: propagate() can stop early when rb_subtree_last is unchanged ...

Maybe:

/* Update the subtree maximum and propagate any changes up the tree. */

>+	__anon_rmap_tree_augment.propagate(&avc->rb, NULL);
>+}
>+
[...]

Acked-by: Lance Yang <lance.yang@linux.dev>

Hammered it with VMA churn (split/merge/mremap/madvise/fork) + concurrent
rmap walks + hwpoison injection. Nothing complained :D

Tested-by: Lance Yang <lance.yang@linux.dev>

Cheers, Lance

