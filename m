Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 502D5606A330
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 12:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=wUFRGu+T;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=9YoYJgJT;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=QuuBnnDu;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=qGFZuMKR
Received: by kanga.kvack.org (Postfix)
	id 70E306B05B1; Mon, 26 Oct 2026 08:49:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BF386B05B4; Mon, 26 Oct 2026 08:49:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D5046B05B5; Mon, 26 Oct 2026 08:49:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 33E096B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:49:39 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C43C680738
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:49:38 +0000 (UTC)
X-FDA: 85364758836.25.DB6BBE1
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id BB7B84000A
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:49:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wUFRGu+T;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9YoYJgJT;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=QuuBnnDu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qGFZuMKR;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793018976;
	b=2kxQmM8R7dll2A+HAexvowhMd277OcyvQcDK8vL6bJzCdGdWNI9BbfXGFxnbmq+bi47d7t
	QPlAhzL2ziN74+LjGYbMcH+08sv8RDWdwgbIyN42DMOC4L9eXgYBeSBaLxj+QVRcI4j7Pw
	IMGzkjLsLucuijdbojTHCYwWrsW8VbM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wUFRGu+T;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9YoYJgJT;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=QuuBnnDu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qGFZuMKR;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793018976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=afZGfCekX7UpYo8D5sYQDVlkG6MmuiaVKNxybV7UkSE=;
	b=P1UtZBnh7JqeaFpaWjn/vIgyVsmApNhRAPmHtSJTGzxExAygdtyuL8dydVfGFbaKOykd5t
	X0ZrdCwg+d+FP7X2wF1wYTbiPAX8dqhaHPzOtoXFxsSNq+xBnV/0WgakCN6LqDHrye5Qgy
	awic4E2S30GCIAuZVaNTmRAt7oAHKkM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 30C2F1F393;
	Mon, 26 Oct 2026 12:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793018975; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=afZGfCekX7UpYo8D5sYQDVlkG6MmuiaVKNxybV7UkSE=;
	b=wUFRGu+T7ZG1KLWrWTEi1iqlAMO8cOnCo/vns6t0g/XH4cywRhW19Wu/iOgTV5sLs8tVCU
	9NopHFKoCBGlkuYt2t++A87UOvqoIyUDjBFopCWxN7SQTIWQedFZW00uYe2Q/bbkKy7syn
	O0mrAagysF+M3JNTZJk/gYbyNL5A9+M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793018975;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=afZGfCekX7UpYo8D5sYQDVlkG6MmuiaVKNxybV7UkSE=;
	b=9YoYJgJTLi01TIwUPENmL7JIUaWTs/kVTxy/HUSDYU4Ro78f0q8eYgMQZYU4UDbGu8Fcck
	8Rpmme2dqi2Y5sDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793018974; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=afZGfCekX7UpYo8D5sYQDVlkG6MmuiaVKNxybV7UkSE=;
	b=QuuBnnDuCAKNGbkKz3wvOEQ7Wx1d6Gn69LyR+kxzV73Mce9lPwCRTZJRrsy2ew4pH0rNNo
	N1yqxjcbBTB0L5ogtOdY1YE6+gKOinW/nnjsmnv/ciOMhOqEAqZUw07/LnoRMNHehUvU7l
	unZ8SMKCR3DhVHQAKsUObo9KEY/MfX0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793018974;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=afZGfCekX7UpYo8D5sYQDVlkG6MmuiaVKNxybV7UkSE=;
	b=qGFZuMKRVbI1lalLA/w28T0RpFPpYwec0rWBlWVGUXpRFYB0AEepiV6m7vhtvVGG2vjn05
	Dc1pCf9OeJEMaTDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DABEE13319;
	Mon, 26 Oct 2026 12:49:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id a5SyJ1xM32rFTAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 26 Oct 2026 12:49:32 +0000
Date: Mon, 26 Oct 2026 12:49:30 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Davidlohr Bueso <dave@stgolabs.net>, SJ Park <sj@kernel.org>, Kees Cook <kees@kernel.org>, 
	Colin Cross <ccross@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 1/4] mm: do not unintentionally overwrite atomic VMA flags
Message-ID: <at9MLiqTg7jLSp8k@pedro-suse.tail5790ac.ts.net>
References: <20261023-fix-vma-atomic-v1-0-8ff4fae1fc85@kernel.org>
 <20261023-fix-vma-atomic-v1-1-8ff4fae1fc85@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261023-fix-vma-atomic-v1-1-8ff4fae1fc85@kernel.org>
X-Spam-Score: -13.30
X-Spam-Level: 
X-Stat-Signature: 6pynbysrkztrxa9oj38o45he38dp3ck7
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BB7B84000A
X-Rspam-User: 
X-HE-Tag: 1793018976-324073
X-HE-Meta: U2FsdGVkX19SAurm90r4jd2/t/Xdc+dAlUBmmgAtgIRiM1fpXIURmz9aPiBQcQ25KRLkOAqozhS0AU0b2VRN5DYoy82KERUCV4NJ9l/dcl771h3v/4I+8bn9XvmksTlxbd66YY6wEkvwH5OMMCpqGCF0rZPJbY+nz3QEVfDOzXGeLP96b66FtdB2TZnYFg+hKsebO0yof21RZveDHLHm+4O+rrIDwdKZ5Ctm+bVaDCSxPgyJc0kZ5hWyNGh2zCzYy1tlka1jdMe0oTlw/H/wRM/pktoi2kH4M/rmEZPKIrbSLItPTdWh8j9gArbeVCeeXQh8tXHb1seS6L0sRbxqb/QnvyQepB7MHSYZ2aXZkxXM3HkUY2P8UXsPMlDzLAHnC8MNckwGvhDrWJftDHlHTuGVrY4A02yr7DpOHuWBPdw2rmYi8EHTXPLGazLbc3IF6f1OI+s+afU3XjoCBzxsF6vCv6k/39+IramMYaKn8j7U1J4fmV4LxpMVSzNKegvMYdYbHHulO1+7u3H/PJETWZfEqqh9NC397UIa17IVuneE3zFgM3gf7iJCB8ZR71ke/UCntKvcQwe7Ff2rK/ya89k0HrPAHaUpXIYJDt1pHbCJEZgcfZX/6nHpQZzGrcLmOeiehGI6FMa2eHnEeVzIQO39XXBftFrrtERU58tqtSOqJvX7i4pKpIHvPqyLd+w1sCFA28jdUaw70srj6yeQLb07x+cmzZcJ+gKpjWWDQiwGuevuteCg+iGyEWrDMAN+Wcg5ULtHj9qnKiHFCB9KxI5fvyqeuULXyfHODVrfjlaHBIMnWNiJvZ2D1mEXQfA5ol7ckyVzSOwnLRHB6XFnEpuWJX43n5rHpOqMidae+fX76Y1XJBwnVjPja5CmLk+0Lx76O/SB95ZuluOE23Dr0FJFvaQsisV3pNQ2dO+B9IHK/qG5+djqzmJOEdCFZ6XFbkm5I4VhEhLpD4euOhg
 +44wA0yo
 4zS3mg1h8ZJ4SONu08zteoQaNbryI0wJYDcEQY0B7QdOFM0Sp1rdG7tP2kuy7CDZC3fkuAmwnMiwr0wll51dpYac3d6GhYnJ61SsMG9MNn5f44hYH4qB3RCD9GwOUmvf8VTf/3au3JQVGQUilETVY68B37qBynaHtI9Q4zRlcSpMEjVRbXql5aTbNK1xucbiRJct/vgBdYWsB8RAmCrM5a2TBbQWfa3K3r0/NHvE1WFqjkXIoPFBhvqmRA0l/nTX5G6c8LD4prz/qzIpx+Rm6PTfkb3AYMXRodXA/K1+yfTFAl1XNfFdJ8dpAEDyrB7Jmcx0cs9IhSr+v4rY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 02:47:27PM +0100, Lorenzo Stoakes (ARM) wrote:
> madvise, mlock and mprotect take a copy of a VMA's flags holding only the
> VMA read lock, later writing it back under the write lock (in
> madvise_update_vma(), mlock_fixup(), mlock_vma_pages_range() and
> mprotect_fixup()).
> 
> This was done on the assumption that VMA flags cannot change with a read
> lock held.
> 
> However this changed in commit 2ab7f1bbafc9 ("mm/madvise: allow guard page
> install/remove under VMA lock"), which allowed VM_ATOMIC_SET_ALLOWED
> flags (currently only VMA_MAYBE_GUARD_BIT) to be written concurrently under
> a VMA read lock.
> 
> The actual write itself is safe as this is done under the VMA write lock
> at which point no further concurrent writes can occur, however at this
> point the stale flags mean that these callers can unintentionally overwrite
> atomic flags incorrectly.
> 
> The consequences of this are significant - a missing VMA_MAYBE_GUARD_BIT
> could result in page tables not being copied on fork (the vma_needs_copy()
> check can return false) or being overwritten on file-backed THP
> collapse (the file_backed_vma_is_retractable() can return true).
> 
> Resolve the issue by always taking care to retain existing atomic flags
> when overwriting VMA flags, replacing the inconsistently named
> vma_flags_reset_once() with vma_overwrite_flags() to do so, and always
> invoking it when flags are overwritten like this.
> 
> Reads are a problem too - madvise, mlock and mprotect all compare VMA flags
> without a VMA write lock held via vma_flags_same_pair().
> 
> This has more serious impact, as concurrent changes to atomic VMA flags can
> cause two sets of VMA flags to be wrongly considered different.

I really wish we had a new field for atomic flags :/

> 
> For mprotect and madvise this causes a useless split, but mlock is impacted
> more seriously as it can result in mm->locked_vm underflow.
> 
> Fix this by updating vma_flags_same_pair() to disregard
> VM_ATOMIC_SET_ALLOWED VMAs - VMA equality is the same as VMA mergeability,
> and atomic VMA flags are disregarded when comparing VMA flags for merge -
> so this is justified semantically.
> 
> Additionally, remove the redundant vma_flags_same_mask() and the unused
> vma_flags_same() as part of the change, and replace VM_ATOMIC_SET_ALLOWED
> with VMA_ATOMIC_SET_ALLOWED, using the new VMA flag API.
> 
> Finally, update userland VMA tests to reflect the changes.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Fixes: 2ab7f1bbafc9 ("mm/madvise: allow guard page install/remove under VMA lock")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Anyway, LGTM

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

