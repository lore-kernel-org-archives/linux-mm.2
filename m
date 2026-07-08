Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBF32C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 15:44:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D88606B0088; Wed,  8 Jul 2026 11:44:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D315C6B0092; Wed,  8 Jul 2026 11:44:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C47DE6B0093; Wed,  8 Jul 2026 11:44:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9BB5E6B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:44:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0C9788C200
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 15:44:28 +0000 (UTC)
X-FDA: 84966031416.01.1C1A989
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4D9F814000B
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 15:44:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=gD2LbyFU;
	spf=pass (imf23.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783525466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GSWfbulqSrBo9Aqd7HgrfFBKoFGaoPICpJEsQJ+UIgU=;
	b=DerciE9+WAnjCZmRWu6EKLCE7VLQ77xKPh4QbSbMjBTu3u9shrSE0UX30IclidRXvBmguM
	5pWhNnMt081coOlhMNgVvz0AMaEFHg2uLMl5MecQqmnSWD7G3y3pEFrJAnpMiUNEfh2Qgu
	XyChqcRO/assVgZ/aL33Fhng0+oy7n4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=gD2LbyFU;
	spf=pass (imf23.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783525466;
	b=oFK9oas+t0ABDdHynZExla1lmkCzPqkvBw9F5EsBcp0LzyrRsdb10QxGANqFG0hkjwEFhu
	ae7s+KHDn1ioY1l2CwDuuNXz3Zu7Nbalu5sF38CpCqKzNJTLbQTSxF/yUtfAMLwRwcwh7/
	2mrkylLwxr1Jb/czcv7+RiVCosck794=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=GSWfbulqSrBo9Aqd7HgrfFBKoFGaoPICpJEsQJ+UIgU=; b=gD2LbyFUU/rJB39UftdTVK1Cja
	q3sdym9kOxqYAMbmfziKPav4nzPT4JSbMtHvxwQeDx3ytcuTJBwFJwBc97zAzeMlCXiyDisguVtvt
	wyyHy1z2GcCskAoHo8RDzXAAOtQGKLCIPaOdRkr7eDMZuk8+fUGnMHJ7MvXRLpHfoEu7OEL1wLRy5
	lN667xO9g6OfNMUUIz8zasgC9pjdLWLb3eK88bAJv7suItiY5MbVfWXiaLSaTz/OaVAHgDn39nxQ1
	xg2Ys7XLRA8p1v3s/W22OY8/VYkESKQVa9/sGygnZW9/agP95YNlCUtukBVeY81mBjinJDsZo1Rs5
	vyyWo6tg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1whURh-0033JE-0q;
	Wed, 08 Jul 2026 15:44:21 +0000
Date: Wed, 8 Jul 2026 08:44:17 -0700
From: Breno Leitao <leitao@debian.org>
To: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org
Subject: Re: [PATCH v2 03/19] maple_tree: Add write lock checking with
 lockdep sequence numbers
Message-ID: <ak5v9UDuieA-dNUh@gmail.com>
References: <20260630190843.3563858-1-liam@infradead.org>
 <20260630190843.3563858-4-liam@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260630190843.3563858-4-liam@infradead.org>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4D9F814000B
X-Stat-Signature: semxiyjb6zmgwoq5fzhju5iawqra4hmz
X-HE-Tag: 1783525466-229959
X-HE-Meta: U2FsdGVkX18kEYsOAaESSRi9l77Zg6sliuI/1SvyJXKFG0fxUJMzro5bzQtmHwxKsJPExxBwURA2ctUYSdzFro1jLPvcV6HWP5riAcM8CL5cZUoo91Vfs90dFFi4Lv4RwGsgE6E7rYGVe28y/pC7BxVM1KOLZ9SBa35+L9FWPt/eNR3wTSFWoJGRAAQYhoYfuy4sTrA2DW+LSzDgKMZbJNP+/9p+OxgwFH35JCLXaKNO7L3+LhjIEy4MOgO5wNr/UEYRGBHii9LidgZZQRU/sSRRARtkBVwJ54NtRawYQGLa3ngYhqGlAQBpyDx9wJ1Kz+8wNZF829PLtbR4c0BDO0mdYmLwQ/RdTDVIO99vBR8dmTDzmHVRgTLySFh0L5WteQhZl/YF002IMDvpGvoqAi7eQ8LtozUE4OKVywsXJ7koci1v5Xm2+dfMoasCWEKeNpMa4yR+PgvQgfcpcauZ4qD7RXKwcBCEir7NOlUwbYDG8NQQBzDLZjuX828EQR9DejmFQw/krNNjtTg1Rj4g0NG690wb9KMwxCxf8cbD4uVkvgHyx22ZF0fPbe1ls/fH1ZtPyncwjKNF1joI684lRxl9Pv5CmphYirFqWI8AMceCplZVfGGQ8gCQ5jc05NXoT6HM8gDPxAaBGkYDY8XuLA4y2hRRZ0brHKixWFaRaE4tOIGtNpMNb0XcprfNP7O0AWduUTtM/yYx72FXrroixAyQucprnz1ubtKkTqWCO7USiMvFgnH75LKhyvLsIMMtMyhx8YPRWu1HNAgama7+C8UYGLXkF1+XIC4emQDh+Iu/rRQd8oL/SjjAYt9EkeUMt5MkElevu75u2uH8j6qDPIvtkmO6/q/UZFy19K2ZrO7cmftXVqA2n/3xuZXAKMY0owgULtfYGpo6NxvlwwoeUhVQcQV9IABO7oIFEl7Ux39JZsROihEEy0I0O30M6FKtuNtzGJyVj7Bnei7fLBO
 4+D7OtuS
 1EeFlcK4ZMbWZ2i8GO0xjS9epasVMvXAGOtCl0Kzod9uhPtBwYGzpRl97kIzLTYchbWbA/sqlB/A0CYAz/GRxh2y2gogIEjjbghousLbm4yhV42xkjsOkT8L1bLXNKRkvPSlsdka4MH5YdvGN8CStJ7CJqA9aPn15fkmNji+JtT0llcOuJc4RmCBO0T8CcNt4u/m+b8qeJy7bvRJFFU5Ae8VnU26Z/AHh30RAXmXMcBSQ7zjLFVOFCcd8dtUdg4nK5uuJzZzGch5SL5uLcDR5Q5jSU5Gd2blxeCVsrfVwYFiiPW4Zla3R+/bq6dPq1qQqFbRs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Liam,

On Tue, Jun 30, 2026 at 03:08:27PM -0400, Liam R. Howlett (Oracle) wrote:
> +#ifdef CONFIG_RCU_STRICT_GRACE_PERIOD
>  	if (!mt_locked(mas->tree)) {
>  		if (mt_in_rcu(mas->tree))
>  			WARN_ON_ONCE(poll_state_synchronize_rcu(mas->rcu_gp));

Testing next-20260706 on arm64 under a stress-ng + fork/exit/mprotect workload,
I'm hitting the new maple_tree write-lock sequence check:

    WARNING: lib/maple_tree.c:1188 at mas_store_prealloc+0x2a8/0xac0

It fires from several core mm paths — fork (dup_mmap), exit (exit_mmap),
and mprotect (__split_vma) — across multiple processes. The two cleanest
traces are both in the mprotect path:

    WARNING: lib/maple_tree.c:1188 at mas_store_prealloc+0x2a8/0xac0, CPU#67
    Call trace:
     mas_store_prealloc+0x2a8/0xac0 (P)
     vma_iter_store_new+0x2b4/0x3c8
     vma_complete+0x258/0x7c0
     __split_vma+0x64c/0x770
     vma_modify+0x11fc/0x1808
     vma_modify_flags+0x18c/0x220
     mprotect_fixup+0x22c/0x4e8
     do_mprotect_pkey+0x558/0x720
     __arm64_sys_mprotect+0x88/0xa8

    WARNING: lib/maple_tree.c:1188 at mas_prev+0x160/0x1a8, CPU#67
    Call trace:
     mas_prev+0x160/0x1a8 (P)
     __split_vma+0x658/0x770
     vma_modify+0x11fc/0x1808
     vma_modify_flags+0x18c/0x220
     mprotect_fixup+0x22c/0x4e8
     do_mprotect_pkey+0x558/0x720
     __arm64_sys_mprotect+0x88/0xa8

Is this a known issue?

