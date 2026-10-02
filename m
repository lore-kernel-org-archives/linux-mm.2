Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E631CA5FDD
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 14:05:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EC0B6B0088; Fri,  2 Oct 2026 10:05:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 476196B008A; Fri,  2 Oct 2026 10:05:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33E4E6B0092; Fri,  2 Oct 2026 10:05:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 05D1F6B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 10:05:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 927251C39E3
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:05:49 +0000 (UTC)
X-FDA: 85277859618.09.3555BDF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id DC401C000E
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:05:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BzL9+gmd;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790949947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+FshdbFcRS26J+ImTe89KXGx/RtDW93OyZ3S0WO3Vcc=;
	b=BYKDwpMj3eNlnFNkeVToNuIwxEF3KF3hUwLR3f6gPamI6V7AK6X5ktWo8r8a+5FErTp+KV
	sAYi6sFEae+jdt932FaRi7JUd3E776D48hD4XzDp4da8C8NIZbPTSq/jy57taYQB1BRDc9
	mjK/UUtInBNlBI4Jgc+rSsTfnODpV7U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BzL9+gmd;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790949947;
	b=orJO0EI28u6LHOrjl9H/AZzmcssuAVz1vDJrqSLTyDJq+xGNP9HKRNQTLB1+pAHEabVVrk
	VV4lf8yYuAnx7uxVfWSLaDfPC8V1LLn/kdSpRx9UahmT5SPRJ72vJYtIrj5GYnDDEpWNv1
	RzSu1ZErD4zUNKUBY86KgvKLOVajlf0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 657ED60A8C;
	Fri,  2 Oct 2026 14:05:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9821F000FF;
	Fri,  2 Oct 2026 14:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790949947;
	bh=+FshdbFcRS26J+ImTe89KXGx/RtDW93OyZ3S0WO3Vcc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BzL9+gmd9N6h8eSey50fAPxWVLPFEb/13hKgPmyMG2b2iMYVub1rGNlA8/cePHWyN
	 oVL5TuXPNTZVMBgtPqejcdFfVtJWAg3LZGUxu9Y/VNwzFFy/Tmk4szJNhz2dUFCQci
	 wYzuF3dOSVwmj83cuo3WaC/+hGVbOAY0qeeTw4jyXUiAw0eqYcZ9rGNPCOCKa15l57
	 ikKCQJu5TBOoArLuRT55AtzXqSgf/JWB6BScEEVMgvpoPU0eHWPl60Jh56gKngGlWI
	 hRx6x/swcOXYDU93xGjyOZ0N6922EFp+jQ+hQvQAvXRCdxH2jWv4glrrFwbHhGa2iS
	 Lx4jJtPz48rcw==
Date: Fri, 2 Oct 2026 15:05:41 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	riel@surriel.com, harry@kernel.org, jannh@google.com, pfalcato@suse.de, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, pan.deng@intel.com
Subject: Re: [PATCH v2] mm/vma: don't remove VMA from rmap if pgoff unchanged
Message-ID: <ar-53boTrPQijDUt@gremlin>
References: <20260930-speed-up-inplace-rmap-v2-1-ac1aa19708aa@kernel.org>
 <20261001154511.23931-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001154511.23931-1-lance.yang@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DC401C000E
X-Stat-Signature: gtptjx1emnd6auxnc4q4y3touczzidym
X-Rspam-User: 
X-HE-Tag: 1790949947-119208
X-HE-Meta: U2FsdGVkX19txDrVPGpSnjtv9Rn+WUqith6vWYhFJOcv8SiHbHdk2YeP7MC4NGYYIyRAg2HgLmwrL8kZY1ZZ7Ak7yzb58/mVQTa0EOSkV6dYs62N4KtrqmNd2fIK1VqZR9HoUj6l2mNuiH14Mu9nWGJVXXFkwJvkFxdyc+2IYlNGGrXoJmsPJMbdkaycM8uHrjGlvDTSNoCsTAtA/CugSENE0FubXvj92rVx8LV2kM6d7WZBY8wkhjIRCAjHzOKIzO2s8P9xV2gq6vS2RRyrzbjPd7xJaIHG4q9MczW0+GXMTrFC3OIq+s2TzfJN3bsTVY1qXHD9G03+zQ3C+NJJx3CFBOfCBng45KtXeJHjUHD2rWLYYHplbwZyiLo31SLmKZigNl09OyASYIPDHAVqfNooU0v5oI3fnKVBypElSAlkY1cVCGYwvPlxd2e3TA/m5QHLEy4iGGKiBCX+7ZmIG2fn8YV6OVLRB96r9gk9ju3z7D+Prqu/iBNuJCFOF1IYKye9/VvnjSP3Wn74RQjo2WkVMAW3L4DvC+fqn4B7IKvllEGxRERddw5VD5h7z9G+TKn1fnalAFMqH7qmIi2S9L1otNhVf5hnKSjGtWnwb/eQbrHwzO/4CsfpMqd1X082kRgP0nB6MFsqDmNclAbSlP8K4DNfLJx+OtAARD4dZAboanSEnwn36HpzZ4bh7JOa4i8BVmYETV/YCfTGZKVprJwFJiW+3NiAEqeWhnkEeaTfnw6jvCDD8Pbrh6iww/kb1epxZJlLC3WIKFhEw8EhVQUcqQE2B6iSY2ipvj00c+YPWb2uEB6rJxUCuRK5VmxeqrBY4xchgRbZogEbr8B1J+sTtUtz1aMqux/UKb2VfOuFZnce+Muq8DrMvB5pes7zkOFk3kt+WD3p9VO+VAxY6y5gLkbxyw1RCa+4mJfitjWR19eFK62BgDu3X83TVPs8aSEZ/j+Quwqf1JWfH0U
 Ip0J4t4M
 MygvzZtb8zxpMLHUKLAKthkM3/cZwuC7kOrd/HDi6pMRsgjvhipGZQEauj22wZmt0PSGgv5fb95wwVT/MK8jZMh8SsVMHVqf/jb7Dd0xmxHnauSxn5XANsLIExZE+BOCXmR9GH5xsNTRIsGVQpue/CTRIbnO7yLvP1ssmSFYdvIdDh0jbBM9xoOa+7hc9Z1C8qTw83maqChQac639zZumfyqBMWFhfQuZCiq5Y74m/7A1WV4xTH6fcqC3rXCuZrd5a3bhSwQU9u2bNlRVSLBXNjfjibizWVcajREqCk1FAIfxp7TqAJil9LNf0w2raf6EnUPY88xStxrJOluk0t0uvxpx1P0Cdpo0dGbgoJ2OeKdxxSA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 01, 2026 at 11:45:11PM +0800, Lance Yang wrote:
>
> On Wed, Sep 30, 2026 at 06:53:36PM +0100, Lorenzo Stoakes (ARM) wrote:
> >When updating a VMA, vma_prepare() unconditionally removes it from its rmap
> >interval trees under the rmap lock, and vma_complete() reinserts it before
> >releasing the lock.
> >
> >This is wholly unnecessary if its page offset (file rmap) or anonymous page
> >offset (anon rmap) is unchanged.
> >
> >So, track whether they will change in the newly introduced
> >vp->file_pgoff_unchanged and vp->anon_pgoff_unchanged fields, and use them
> >to determine whether to remove the VMA or not.
> >
> >The rmap lock keeps things safe as no rmap walks can concurrently occur
> >during the operation.
> >
> >Additionally, some architectures (arm, parisc, nios2, csky) have dcache
> >flush rmap walkers which take only flush_dcache_mmap_lock(), which is
> >likewise held across the operation.
> >
> >If the VMA remains in the tree, it's necessary to keep the augmented
> >rb_subtree_last field updated to reflect its changed range.
> >
> >Provide mapping_rmap_tree_[pre, post]_update() and
> >anon_rmap_tree_[pre, post]_update_vma() (replacing the existing logic in
> >the anonymous case) to handle both the changed and unchanged cases.
> >
> >For the anon rmap case, with CONFIG_DEBUG_VM_RB set, avc->cached_vma_last
> >is also updated when propagating in place.
> >
> >When performing a VMA shrink or a split where the VMA is the lower one, the
> >page offset cannot change, so set the flags unconditionally in these cases.
> >
> >When merging VMAs the page offset is unchanged only in some cases, so
> >update init_multi_vma_prep() to set the flags only if the page offsets
> >remain the same.
> >
> >Finally, while we're here, also update expand_upwards() similarly.
> >
> >These changes ultimately result in less rmap lock contention.
> >
> >Pan Deng reported results using the UnixBench/excel benchmark on a 2-socket
> >192 core, 384 thread x86-64 system for v7.3-rc4 with/without the patch
> >applied:
> >
> >Execl Throughput, index score:
> >
> >                    avg    %stdev      min        max
> >  v7.3-rc4        3511.5     0.44%    3494.5    3543.4
> >  + patch         4069.0     0.48%    4047.4    4109.5 (+15.9%)
> >
> >Average wait on file rmap lock in ms, 5 runs per kernel:
> >
> >               avg      %stdev     min       max
> >  v7.3-rc4    9.470     2.91%     9.070     9.820
> >  + patch     8.420     3.34%     8.100     8.770 (-11.1%)
> >
> >Profiling data obtained during the operation highlighted the file rmap lock
> >as the primary source of contention.
> >
> >Suggested-by: Pan Deng <pan.deng@intel.com>
> >Reviewed-by: Rik van Riel <riel@surriel.com>
> >Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >---
>
> Wow, pretty cool stuff. That's a nice speedup!
>
> [...]
> >+static void anon_rmap_tree_update_inplace(struct anon_vma_chain *avc)
> >+{
> >+#ifdef CONFIG_DEBUG_VM_RB
> >+	avc->cached_vma_last = avc_last_pgoff(avc);
> >+#endif
> >+	/* Propagate all the way up the tree. */
>
> Nit: propagate() can stop early when rb_subtree_last is unchanged ...
>
> Maybe:
>
> /* Update the subtree maximum and propagate any changes up the tree. */

I think in this case it's ok to be a bit blurry about it :P it deciding not to
unnecessary work is fine but I don't want to put too much in there.

The point is as a simple sign or pointer to help somebody wondering wtf that's
for even if it's not quite the full story!

Hopefully that's ok? :)

>
> >+	__anon_rmap_tree_augment.propagate(&avc->rb, NULL);
> >+}
> >+
> [...]
>
> Acked-by: Lance Yang <lance.yang@linux.dev>

Thanks :)

>
> Hammered it with VMA churn (split/merge/mremap/madvise/fork) + concurrent
> rmap walks + hwpoison injection. Nothing complained :D
>
> Tested-by: Lance Yang <lance.yang@linux.dev>

Thanks, very much appreciated! :)

>
> Cheers, Lance

--
Cheers, Lorenzo

