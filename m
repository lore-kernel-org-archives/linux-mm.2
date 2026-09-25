Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F678C9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 15:44:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10EF86B0093; Fri, 25 Sep 2026 11:44:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E7796B0095; Fri, 25 Sep 2026 11:44:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF12D6B0096; Fri, 25 Sep 2026 11:44:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF4FC6B0093
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 11:44:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 48B351606E4
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 15:43:56 +0000 (UTC)
X-FDA: 85252705272.21.118D303
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2ABBB140003
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 15:43:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UrTBj5DO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="XJ2ng/tm";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Eu6JG8yN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FIV7hAVN;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf09.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790351034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IxoD1TfpMnlHhB4OJ4JkkWL7Kpm3ztSu4F+OAJdGJJQ=;
	b=GQ29JmqGf9SuHkZFAgygCmer7MFhkxlTlTzVgK946xdxa4UksVOwrzc69+06uCC0QEUJwl
	vgJ9EgYj/wNnVeQhitVuWtwci7Hy7JAVnLsLw5CqwEz/kd69PCfmfnCeUaxITz7Nu5sLVr
	+Zb1jzmN81rxG+m6eWHRMmFYd0PAWwo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UrTBj5DO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="XJ2ng/tm";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Eu6JG8yN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FIV7hAVN;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf09.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790351034;
	b=jNwpO+RZUgY00pvg94mrv2EPDQTWI11Y9QEbrTE9PGc6dcn9jQKKQzub7PBBgSnGtF2nUo
	sLfOj8rl88223e7/HV5/3RpatgTVytQEDgf8doU9Su1vEeY9mE+RY+mvNIF3+ot+ti36oa
	F/tC8pORHNpKo2BeYvC75e/BrqMekKI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8A3331F7D3;
	Fri, 25 Sep 2026 15:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790351028; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IxoD1TfpMnlHhB4OJ4JkkWL7Kpm3ztSu4F+OAJdGJJQ=;
	b=UrTBj5DOaKy8ZYe3EDblH3vg+C+j6dbaamPZjXrvv7zSBNriO+URS81wolaSKxr2jBFiRE
	Xevrszki8ag3T6W8ZtAcvx4XrGbblo3RaaBu+Jq6KHPi7DEm+j6EmF5nWQuwhv95dgYjYt
	UoMkiHRQr/mSmDCZtZz/6EHBwt1GzAs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790351028;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IxoD1TfpMnlHhB4OJ4JkkWL7Kpm3ztSu4F+OAJdGJJQ=;
	b=XJ2ng/tmOeARv54gnA9sJCwwXh3G2isJ8zW/6O/Tw1/BQdw7/H8caS5bR5dRApuElNwgXC
	IA0JipJvgLx3StDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790351024; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IxoD1TfpMnlHhB4OJ4JkkWL7Kpm3ztSu4F+OAJdGJJQ=;
	b=Eu6JG8yNIU0VVstgCa5gl74tXGp8A6ZXjvuBUo7OKEBPKPS4/A5IsA9PDysWuKIVi6hr6R
	q/GwscQnab/osjlQxT9ZiELHA78pCLQ0T1rCIOoXjVXixvGgTWogiR3rCrcYs/cMWIJ9I+
	Cm0IpEtImDZ+X/ZBkOx2vmKPihH5IV0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790351024;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IxoD1TfpMnlHhB4OJ4JkkWL7Kpm3ztSu4F+OAJdGJJQ=;
	b=FIV7hAVNvn72bus5pVlQGvbAWf/OYQVEN83+kSYzU/y19plCj+QKR4Kj7QZgZkzdpXMqs1
	Dz+R+0gJ4WDaiAAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7156813274;
	Fri, 25 Sep 2026 15:43:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Aq7GD6+WtmrAPwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 25 Sep 2026 15:43:43 +0000
Date: Fri, 25 Sep 2026 16:43:37 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Pan Deng <pan.deng@intel.com>, akpm@linux-foundation.org, 
	liam@infradead.org, vbabka@kernel.org, jannh@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Tianyou Li <tianyou.li@intel.com>, 
	Wangyang Guo <wangyang.guo@intel.com>, Zhiguo Zhou <zhiguo.zhou@intel.com>, 
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH] mm/vma: avoid redundant file rmap tree re-insert on
 new_below=0 split
Message-ID: <araVBBBVY-jafePL@pedro-suse.tail5790ac.ts.net>
References: <20260924054301.2330822-1-pan.deng@intel.com>
 <araI4WsI0XMXOR10@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <araI4WsI0XMXOR10@gremlin>
X-Rspam-User: 
X-Stat-Signature: ww1u9tmee5y96kc6s47i73wd9of6d1yz
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2ABBB140003
X-HE-Tag: 1790351034-900526
X-HE-Meta: U2FsdGVkX1+20943HYCpQ2EXxOUDkRLMkb5pQeDnn2eqjY+bUvaMb6DKkonPj/0A2q8e+EIoAp+gKwokNwiKSDzUmSVm9FFzUnRDfBtw2iFHR936kUCPPtLKdVPv5HKlNThZluS3KOi67ldu9IMsl0XkZxRyLNDRoLkMqxT51OSjydklyAeFIer3YpQK9svvcAQdfmXYUh/brORu7ZHpgV9F79DxbeUj7RrA+rp9wBxF2rkGFbOihi3swB06W2J4FZM4Fr6BTBjBGk4SFS6O1k0xHJjzcSDU9Mrt7+LGnx2VngF9/rSgagCGLqLgV0Fmp2SaAoiXzimB65HMhUCoOAI+f/1T1ClNT9ZaoFTRoU2QqAmQye6JV1QHPXvzs8HIHrduswxxyshD2DXCV4flDwFBNHQjVPbjj/A57voTpo26D8b8iCEJNjU1u0mciOA8gqSsgdZVXlC2Vf7LbOxdUauYdiVpO+/uNKbE8wOET2ur2MEKGqH6hhnIYmo1UWzLLQNHp9GhA79l1LLxycgBik2vKg4EdpdxBQ21kCXR3jbdnGJ9N1vuVMPvinNAoGGKMLYnsh4PsS7o5GTW8+N+Voooxzmd3qYtQWmqSTkz6DGhxzsb/A9jS08XdD3Wmzo7uJ/9yZOOqXRaMeQK1N3m+OpVsWBlK4SnOxQjEuUP1pRndSKb5dMipZC/rbFN5XWnUZdUP+nC9zG3o8XvqAhMSnPZkRDVk1fZWyGqZ0V7k6UgpBZgPVCY3kr4QNbRlvGBgSStxHE1+q4ccl8dslseHUhp6YknSDpuXgYR3c3zVOqacsHHMqhjiklJJZBhZzuzAA6zyVrQUGVLxL+Ygpp+++fqwC5MxpHhXBIpJ1bZ5eKnUIlUpv5n9/WYT7iFiSfCGO9uTxGokQ1eAkhSl1M7XIO13o8qdl6z/W1jQAkz8uoH22nZKiM99LBcEF/gwNRkjdHghhmZw2sJhFuQFFA
 D8qBzi97
 E3PHZXUyFBEROMK7dndIeMJhd+7AtsAmMeYUTyV2qeBqrQNUTctbPa8IjGanYbs8S0L/7ShPKAy6RtIzeEOO1JGjRpIE8koDQWO+3UljCqabvkKvx8I8xWlvcpd8Bfgfmj76vXypNyXnsHcpIX7S82AolLfvvgch0lht4YFaFABvOn4CdkPwHDI+KjHMUkVOp1OyqeufChVhQ8Uy78OtanreWmlQkFPAN5cSoCkek5oUt+NKvqIl3XsosB7R4WrxqfqifCFDjGYyvN1aINrQdQA1l63MPI8XqGMRistY4xViKdgT7ugDT64xa9DMy+7hnrZ2OrLZl8M77c2DZIg8ssANIWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 04:27:44PM +0100, Lorenzo Stoakes (ARM) wrote:
> > This change skips the re-insert for that case.  vma_prepare() no longer
> > removes vp->vma from the tree; instead vma_complete() detects that case and
> > only recomputes shared.rb_subtree_last up the ancestor chain.  Everything
> > else keeps the remove + re-insert path.
> 
> This could really do with a diagram and a simple explanation.
> 
> In general you should rewrite the entire commit message yourself and not
> use the LLM output at all.

+1 on this. Even with the Assisted-by, this needs to be understandable by
hoomans.

> 
> >
> > The case is detected by comparing vma_start_pgoff(vp->insert) against
> > vma_start_pgoff(vp->vma): only a new_below=0 split leaves the former
> > greater.  __split_vma() adjusts pgoff via vma_add_pgoff(new,
> > linear_page_delta(vma, addr)), and linear_page_delta() is
> > (addr - vm_start) >> PAGE_SHIFT with addr strictly inside the VMA, so the
> > delta is at least one page and the new VMA's pgoff is strictly greater.
> > For new_below=1 the two are initially equal and vp->vma's pgoff then
> > increases, so the comparison is false both before and after the caller's
> > endpoint updates, and the original path is taken.
> 
> This is useless description of the code in English, it's not telling me
> anything useful at all. Human beings don't have a large 'stack' with which
> to hold things in our minds.
> 
> Write with humans in mind please :)
> 
> >
> > Inferring the case this way keeps the change small: struct vma_prepare
> > gains no field and no caller changes.
> 
> I don't understand what inferring the case means? I think this can be
> dropped.
> 
> >
> > Moving the remove() out of vma_prepare() leaves vp->vma in the tree with a
> > possibly stale sort key across the caller's endpoint updates, so
> 
> I mean what?
> 
> What does a 'possibly stale sort key' mean? And what does 'across the
> caller's endpoint updates' mean? Which caller? What's an endpoint? What
> updates?
> 
> > vma_complete() re-keys it *before* inserting vp->adj_next: otherwise that
> > key-driven descent could place adj_next in the wrong subtree.
> 
> Re-keys what? WHat does re-key mean?
> 
> What you're saying here really makes me nervous. You're changing a very
> sensitive part of the kernel and talking about intentionally leaving stale
> state around.
> 
> This patch cannot possibly be considered for upstream until I fully
> understand exactly what this means and that you understand what you're
> doing.
> 
> >
> > Measured on v7.3-rc4, on a 2-socket 192C/384T system running UnixBench
> > execl (384 concurrent execve of the same binary), dropping the redundant
> > remove + re-insert yields ~14% higher throughput by shortening the
> > i_mmap_rwsem write-side critical section during the file VMA splits that
> > execve performs on the shared libraries.

For what it's worth, I'm vaguely accepting of a similar change, but this needs
to be _really_ well commented out, and ideally in file rmap code, _not_
spaghetti'd in VMAs. The interval tree is complicated and some bits are not
very intuitive. This needs to be robust. Not LLM'd into existence.

This also reminds me that I should reboot the sharded file rmap effort...

> 
> This is really unconvincing I'm sorry. Real numbers please with statistical
> evidence to back them.
> 
> Additionally I notice you have not made one comment referring to locking
> anywhere.
> 
> This part of the kernel has VERY subtle and sensitive locking
> requirements. I am not convinced you understand this, either.
> 
> >
> > Signed-off-by: Pan Deng <pan.deng@intel.com>
> 
> This patch feels like a hack. You are creating a whole new set of very
> fragile assumptions that have to be maintained throughout.
> 
> Again as above, a member of the core team should take this over.
> 
> > Reviewed-by: Tianyou Li <tianyou.li@intel.com>
> > Reviewed-by: Wangyang Guo <wangyang.guo@intel.com>
> > Reviewed-by: Zhiguo Zhou <zhiguo.zhou@intel.com>
> > Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
> 
> Please don't do this.
> 
> Upstream is not interested in private reviews. Review tags upstream are
> based on review done in _public_.

Yeah, this too. It's just noise.

-- 
Pedro

