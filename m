Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4C49C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 07:59:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D5426B0088; Fri, 10 Jul 2026 03:59:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9862C6B008A; Fri, 10 Jul 2026 03:59:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 874FB6B008C; Fri, 10 Jul 2026 03:59:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 660A76B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:59:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E4500120325
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 07:59:01 +0000 (UTC)
X-FDA: 84972116082.27.67C965A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3D35D20007
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 07:59:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XT9ruq9V;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783670340;
	b=h1v1+uWnPBzEcq7uRIA8ot5f9wa33ZwI2Wya25cabQ7kj9PbGP52QOz9967RBGzW5BXXWJ
	IYbNKSaI0c7/dG747Z9I2Q7wob+LBhXsBze5dBvPa3mMpjD4DXVKDAir+a5dOAuABwXzTI
	OLMf5NPzhlck6TDtiMt+EKm2n51KEU4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XT9ruq9V;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783670340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7z64Yjh6oprdYOkOccqXqa+zyIEaBTLMckJTU03fgvM=;
	b=Rt1BRxRKUGPqdBRvWRFWGOI1aB3qjpOh+77d+Q9dE8ULriB27HMBbuZljPLpuziDLSyXzt
	vBYr/cYdcZNq1flE4bwiSptIrcmc9vqO6mC7rLsZoUs51/wo05cHrd27+fneFIlIb45Gq0
	QETuSeqNEnXDc+PtN1xvJC6kzWBKQYk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AB9B16001A;
	Fri, 10 Jul 2026 07:58:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39F11F000E9;
	Fri, 10 Jul 2026 07:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783670339;
	bh=7z64Yjh6oprdYOkOccqXqa+zyIEaBTLMckJTU03fgvM=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=XT9ruq9VLPkDmgX6GaPHCeU92R+VAHAxOgUyPGuxt/IgDJuTSU+rJO8dxJUNP7oWm
	 f4qi9Wt1H8sn0KRTRJoQHNDNDF5YgfZnE1XEwPFLQkGwimI1HMTAcFRFK+5zRT+cWt
	 DzlY1CmYhH7cncVFJhzjeNYgKGWjxrh5SjcvRzGRX+XNirRHPgnU59ODeSJ2fyaGfB
	 k75/kXY3FuJedD7aZEXU0cpMRutjOM4MHXuNINZ20BnW+Spgu8OrEV9gzCsz+T1s2D
	 Bpb2Cj+6bEH2zMEaovvnpBRJt6d8H9aaUYPHYl9hxnRSjc6xmzqwct99h8wIHWG4EF
	 zz1TnhESfcQHQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 00/23] binfmt_misc: write access fixes, RCU handler
 lookup and cleanups
From: Christian Brauner <brauner@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
 Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com, 
 stable@vger.kernel.org
In-Reply-To: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
References: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
Date: Fri, 10 Jul 2026 09:58:54 +0200
Message-Id: <20260710-holzweg-berechenbar-unbeirrbar-83c525ecee0a@brauner>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=5229; i=brauner@kernel.org;
 h=from:subject:message-id; bh=i+9k/qCZC42axD9e/Q5BsbX8vqk8Mlzz3oda8wQw/FE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQFLHOMVJHT6usLvxh7edclrWmb14Qe+vnAVnrDj3vzf
 wgdP/f1U0cpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEzNwZGc7v+TShIvdgeWX9
 Y5+dTdJdU1er5RoeKl8gG5ilGOnptYeR4R93y7wHErWqnr/9uHa+keKK2iByu+vSutdxhzhWLF7
 yjxcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3D35D20007
X-Stat-Signature: earh36fddsib4fo7dn6ssozy863ojozh
X-HE-Tag: 1783670340-104349
X-HE-Meta: U2FsdGVkX19ZMALTvVAo7kPPu68Iaay2CkKhfkiSLDxbozsCUcG+xOwXb2tQh6Sfzc3UxtLZvPbzfA1xoV6PWn11f5QbM/PI49TqIYuE4DbmOp7ENI2liYA3f1oXNkMrr0ei0Iow6XtOAnUVnOp85dzG6bbzVQB81qBhLNJAIrf4n8mDAP8NNfeAn9efATw6wJaTe2uE6aXtTFvIYY56TWWKpzLwku+Cu2PHl2ztwdwjDJGpi9RGoijaF1LFaK24Kqq38BArvKvnk0JOqaVItuRDMqvxepyvyhu6WwWRpgqISuDiUpH+kEGaFIS1rC46aZh2a7y+PqRF87KEdwloORrdE6bKkj266vExNNCBonYrtCTjfNLNWL7mT8W9QCjgaEsMIF04sKmqDy7H4xjdbtDql+4NuVWMajzN3wr4ndXMNYXrWc8NJX/wYOH6VSagr5q3FfkOzx1eqb7Ldpq9m4buN5DO3px79PS/ljiehWRAfpq0pH5HomG0UcX+BxiCd3KWE3B7StHeG+lu1D/z/GDQlhevY1VAvHG8yMWsDdV1sX7sp7sAZv9fEg1XIJqRS5+IXs08lRtcJX4cOxo78UcqdHrAWAs8qMj7W8x1Ct8bkmYNNhDsvjQnK7At/DREPk09e8zmBof2af+Yfoo6FMDwayFKuDwcLiCrAu5xbUHIfERWYnsL2DS62ODJnckA1KrY8/IPIym6eQ32AWuKARJOeGzwe6ZO/JgT23IgIq62R2yXfzqSR69wK7ZAAFl3/b7881hDqz7fudzHTmxnSZAmxzyIg5O0/G8VvAvjyiADjz9ZPvniZxV/a7la3ih4hV3zZghc/dLQMWaBuUjigpFQLSD9hlmCvXUsdReuvvSj6Atlt/c2kGbnSFAo6P+Q2lhjE89BmzQhtYIAaCSaBk5J5THf+nyA3hNNAq5NTtHbYx82aU8wlaYRs2SK29zKx2YcjMjxA+wZshtEAwG
 8gDrfpK1
 HwK6QQHfCzhoJ7MN8PAfGMPTR3FZz9kMG6urgi1RCBhcBNLYlbDdDCHxMfLWfhQ+p+4wgSO0JG2k2i4YG8Z7tVK26BH5XnfaIrfMCr3S+zP2IzBT11+hV+TloxTuN9cxp8O5U4omv/RV6ehbYWbCc+yztpkXORpAlxDMksDcYRiMBqEmGVgPFH6loqAfODdx4+TJJa99OkaWF0ZwabL4pdDs+2c6ktQkNAFqfVstVw6SlodCFaRwmWlb13XdIP2QSd8SMb4v2XsMf211N6DfVveVBBpwYY5utjRJLWs4/pDke3sn48Tf1jlyJl8L2Yz68D/Un0nrdEWk0c6Vix/nPQomzjTRu4z7LEhU5s1oqIG7s8wcoUzLrLW6fZCzgXdPQLgUUy+qnFD7fHzWNDtYwKI9vLFFlOTAaUV75/94LFu7X1AC9SEl+yzZVw0+OelELmqABAheFY0Tou8u47ulDdLw47cXdvA8Oc5xqctzPqekT1N7b0jWTNq1zfdRbr5tZ5Dx1PMCZ7D2a+vs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> The first two patches fix two i_writecount imbalances on
> MISC_FMT_OPEN_FILE interpreter files that turned up while auditing
> the file for the rework below and are marked for stable: removing an
> entry never restored the write access denied by open_exec() at
> registration, leaving the interpreter unwritable until its inode gets
> evicted, and the write denial taken on the interpreter clone during
> exec is not paired with the FMODE_FSNOTIFY_HSM aware release the exec
> machinery uses, so pre-content watches make execs leak write denials.
> 
> The rest reworks the locking and tidies the file up.
> 
> Once binfmt_misc is loaded load_misc_binary() runs for every execve()
> on the system since binfmt_misc registers at the head of the formats
> list. Every exec therefore performs read_lock() and read_unlock() on
> the entries_lock of the relevant binfmt_misc instance, i.e., two
> atomic read-modify-writes on a shared cacheline, in the common case
> just to conclude that the binary matches no handler. User namespaces
> without their own binfmt_misc mount fall back to an ancestor's
> instance so on container-heavy systems every exec on the machine
> typically ends up hammering the cacheline of init_binfmt_misc. On
> PREEMPT_RT the rwlock additionally turns the handler lookup into a
> sleeping lock on the exec fast path.
> 
> The lock protects very little. Entries are immutable after publication
> except for the Enabled bit which is already toggled locklessly via
> set_bit()/clear_bit() and entry lifetime is already handled by the
> users refcount. The read lock's only remaining job is to make "the
> entry is still linked" and "take a reference" atomic with respect to
> the unlink sites.
> 
> So make the lookup an RCU walk that acquires a reference via
> refcount_inc_not_zero() and free entries via kfree_rcu(). The removal
> paths need to detect whether an entry has already been unlinked and
> rely on list_del_init() reinitialization for that today, but
> reinitializing the forward pointer of a removed entry would make a
> concurrent lockless walker standing on it loop indefinitely. hlists
> support exactly this pattern: hlist_del_init_rcu() keeps the forward
> pointer of a removed entry intact for concurrent walkers and only
> zeroes ->pprev with hlist_unhashed() serving as the linked test. Hence
> the third patch converts the entry list to an hlist so the RCU
> conversion in the fourth is a pure locking change.
> 
> Writers remain serialized by the inode lock of the root dentry with
> one exception: bm_evict_inode() unlinks entries during umount without
> holding it. A spinlock stays around the unlink sites to make that
> exclusion explicit instead of relying on superblock lifetime rules to
> provide it implicitly.
> 
> Handler removal semantics are unchanged. An exec that acquired a
> reference just before its handler was unregistered already completes
> with the removed handler today. The read lock never protected against
> that, it only made the window smaller.
> 
> With this an exec that matches no binfmt_misc entry no longer writes
> to any shared cacheline at all. The fifth patch annotates the
> long-standing lockless ->enabled accesses for KCSAN and the three
> patches after it make the entry flags proper enums and give struct
> binfmt_misc_entry a name that isn't Node.
> 
> The remaining patches are a cleanup pass over the whole file: remove
> the VERBOSE_STATUS and USE_DEBUG compile-time toggles, convert the
> entry file to seq_file, factor out entry matching, entry removal and
> the register string field parsing, make the entry/register string
> allocation a flexible array member, give the parse_command() results
> names, let cleanup.h unwind the entry registration and exec error paths
> and prune the include list down to what is used. Aside from
> seq_lseek() now bounding seeks on entry files and the ETXTBSY
> propagation in the second patch the cleanups have no user-visible
> effect.
> 
> The last patch adds what the comment in remove_binfmt_handler() had
> been suggesting for years: entries can now be removed via unlink(2)
> in addition to the -1 write. The status and register control files
> refuse removal.
> 
> ---
> Changes in v2:
> - Allow removing entries via unlink(2).
> - Add two stable-marked fixes restoring i_writecount balance for
>   MISC_FMT_OPEN_FILE interpreter files, first so they apply to
>   mainline directly.
> - Turn the entry bit numbers and behavior flags into proper enums and
>   rename Node to struct binfmt_misc_entry.
> - Add a cleanup pass over the whole file: remove the VERBOSE_STATUS
>   and USE_DEBUG toggles, convert the entry file to seq_file, factor
>   out entry matching, entry removal and register string parsing, use
>   a flexible array member for the register string, name the
>   parse_command() results, use cleanup.h for the entry error
>   unwinding in registration and exec and prune the include list.
> - Link to v1: https://patch.msgid.link/20260708-work-binfmt_misc-locking-v1-0-a009dd5b56db@kernel.org

I'll send a v3 in a bit with one more fix.

-- 
Christian Brauner <brauner@kernel.org>

