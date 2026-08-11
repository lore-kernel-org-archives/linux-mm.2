Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C197FC5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 03:52:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C7096B008C; Mon, 10 Aug 2026 23:52:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 250896B0098; Mon, 10 Aug 2026 23:52:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13F9F6B0099; Mon, 10 Aug 2026 23:52:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E69FD6B008C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 23:52:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 734B8802F9
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:52:54 +0000 (UTC)
X-FDA: 85087617468.19.80BBE12
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id CF12D1C0006
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:52:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DaEru8YP;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786420372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tQ8MTXU7PXH/k046gdgNu+2KYPZDiwOczpAepdH9QcY=;
	b=xEQ5jV4ByC8ffYxE8eyiklIYr7BOMarLbQyfhZUPD46BUvmmWk07Y2KRwikzSX5mmGiCUY
	P5v5wpgY+ZjWbW8klpIls9goBsjG3achGnB+jmxYBWfBr6f1opREdLaiNvLXSgqprrSSHp
	Q/V90YBbICIZspBdiVwGyRgF4cVjpAE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786420372;
	b=sQcqddBQ5LCIDHLs5yOTPPz0vHZ8FzwVkWsa+UbGLn360w5+lXFclwfZj5fQ0E/5FRcht6
	u84nJE9P4j4hdjfxibsuxvlCNdx7E6UIouMkoRuAGxiTnAHFkkhic1IyrTb1o2jkFqnhVe
	B9ByDShYm0gQjkMWjA7wF1prxIODBRw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DaEru8YP;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 362F36001D;
	Tue, 11 Aug 2026 03:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 900151F000E9;
	Tue, 11 Aug 2026 03:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786420371;
	bh=tQ8MTXU7PXH/k046gdgNu+2KYPZDiwOczpAepdH9QcY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=DaEru8YPOYGZZ6RTXqtSimMxPDe90BY2dH0YrIJI1Y6AP6qOdJn23xuERg9ByK+n0
	 jj/KDEDzHxxC69nBa8lwtpHndN0ygmu1lIdEuA2mtnKgm1pRfGsnHE5UpLPdlEgILn
	 bN+aN/0bFsp8KhGmm08kgcSaiq+B8P2IqQcE0eZQ=
Date: Mon, 10 Aug 2026 20:52:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hao Ge <hao.ge@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>, Luis Chamberlain
 <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, Daniel Gomez
 <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, Aaron
 Tomlin <atomlin@atomlin.com>, linux-modules@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 0/2] alloc_tag: fix undetected compressed tag
 overflow when profiling is disabled
Message-Id: <20260810205251.3fce0ec86ee20925fd577c26@linux-foundation.org>
In-Reply-To: <20260810093955.153015-1-hao.ge@linux.dev>
References: <20260810093955.153015-1-hao.ge@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: rk57rnnynnkz34kga1n4cpa591u1dx7t
X-Rspamd-Queue-Id: CF12D1C0006
X-HE-Tag: 1786420372-397341
X-HE-Meta: U2FsdGVkX18JavVapqbVpJpuLUTtebU+TWs/Roi8i7YnogDDsFx9qd+2wotQA/6H3ml8r1kV/2xJ7Me0JWJ2FyKIJrpnv0nni2Vi3DCS5kgqaLrOGiDDanEfYVIvDO8f+726eMkPAW8QWVZu0u6U1pTC/Hts2Lyz/wTTnYGKx4Vmx2UFeOkrqn2fcCfj9cYF20oXlCSjdP9ndWNYCIRS2ELrJkDccSXrIb9JTLkDH6iUrnkkPO5LUohY+JlrV0d65AjuTGdBiwPnhpZIjnK4ZScusFhYtlT6g07ZHR9tD/m6tn6EMRSaSW3nF9voKm6MlMZ6fGFApxzeGGc5Y9CelQG9xsGVkauBTxrkVhsx+lhjs+Lyy5InPe6M1qau5vwYhBUdjfrNUe7UhfFTDBQPXd620ttsDgGac2D2X/HDAJ95VsrLRehrllgkPae5wP+tlrH5KL/FgfzecedAUy2l1DZjGEW4zq17lSmaZ3bTFZo2blF54nYTlkLCQUVWDTa4jFzH11ohSragmSz2UJCCLlmSpyMgai6moyWWIs4etGuGcrWbYddpFGkHtUWSJ8GnbXYnp0/TyItKrvaeF+62GQwEqUg4XC/DTQDaLxtc6lHrshaL6tv4V4wXMPF07fHRY7TB2dyw3aj2jLh+FTM2yrE3LMca+s76gmpiN9ep4jZ8lp3ftsdabqOTPJfIbGFl+PAkF+e/PvLrmHMbvNEuVN8fCaxUjzGbChAOlfJGDp3F258696ceu098sPhtRXW8fgo177iB4gIr5Mv4gTf0vr/01Mp6HhB4iX8hOa1TKgA55evKJ013V/E/on7BZvCLOA/hhCMVo8Y01ogiZOrwpeBfIiG9C6WRDxVfgHcI7bZJpHS17WApKE2eZyDL+XQdr3xUzbPGmKCK0rt7NgcYQ6E2a7xM28X/v53ehLH7Mou08z4x7rurXU5ORS3yYXldJo0bha1FHHjmppWeq9G
 VGHZVQGi
 +lfEKmkYq4RamVkRJx4LScPutgUCp8MU3+vha881DT0zeibRk9mxwrjD4p42QeefAwEOzk8pyq9782jp4DVY0dTJZvGGbI+jU45cUO24SCaXFM2XwhtN4BN+r0jH8v2kGA3AkxeWjuHq6NuOT+V2vS4y8/iWfeZTAmgX3w5l6NtpIzfiGE6qcWt7YfRQd0g9ql37qcQImqn63l9ufAH6RGMjOggULG53Zc/CRXjXbx0O4dAxuAWmSZayx9PyNp5O9p6yRFhTcmMfjKLjcT+FOf78AmdgCXvadgR+mQOj4maOE6rYlYyPSFX1Bvj+c9er42GkLzJwlkUmY9h3jfG1TNurDxvzy4lIxUqvi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 10 Aug 2026 17:39:53 +0800 Hao Ge <hao.ge@linux.dev> wrote:

> v3 was a single patch. After discussion with Suren and Andrew we went
> for a more graceful approach: rather than failing the module load on
> overflow, let it load without profiling. Once profiling is disabled,
> codetag_needs_module_section() returns false, so on retry the codetag
> section is placed as regular module data.
> 
> A new patch (1/2) is added to move release_module_tags() above
> reserve_module_tags(), since the overflow path now has to call it and
> the helper sits below it.

Thing is, [2/2] has cc:stable but it requires [1/2] to be able to be
compiled.  [1/2] doesn't have cc:stable so we're asking -stable folks
to backport a patch which doesn't compile.

Resolve this by using the same Fixes: and cc:stable in both patches.

> release_module_tags() is what module unload calls to drop a module's
> reservation from the maple tree. By the time reserve_module_tags()
> detects the overflow it has already stored that reservation, and the
> -EAGAIN return skips vm_module_tags_populate(), so the backing pages
> never get mapped. If reserve_module_tags() returns without calling
> release_module_tags(), the stale entry keeps pointing at that unmapped
> range; when the module is later unloaded, release_module_tags() walks
> it and panics.

AI review had a lot to say about this patchset.  Some pre-existing, some
not:
	https://sashiko.dev/#/patchset/20260810093955.153015-1-hao.ge@linux.dev



offtopic: alloc_tag isn't getting allmodconfig build coverage at this
time because:

1: MEM_ALLOC_PROFILING depends on !DEBUG_FORCE_WEAK_PER_CPU (why?  I
   can't figure that out)

2: x86_64 allmodconfig enables DEBUG_FORCE_WEAK_PER_CPU, despite it
   being for s390 and alpha.  In fact it might be alpha-only.

Adding

	depends on ALPHA || S390

in there fixes this.

