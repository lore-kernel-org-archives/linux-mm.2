Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BB81C2A070
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 23:07:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CAFD6B00B0; Sun,  4 Jan 2026 18:07:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5722C6B00B1; Sun,  4 Jan 2026 18:07:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ABFC6B00B2; Sun,  4 Jan 2026 18:07:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 386666B00B0
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 18:07:43 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5D1545FC31
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 23:07:42 +0000 (UTC)
X-FDA: 84295820364.25.592B557
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 84DF9140013
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 23:07:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="nv4/MaqF";
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767568060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7VRGC19qonNfvZNXqeFI6tZweaNwjzOAaVqnrX0bHAA=;
	b=lZLVNN/giFsn8vwhC4cNaPBnas7V655qsCpRgkjgs7XXLwtRN91JbnEKm+h4AHPgktOgQP
	CPPkkpoQLNuA2nhcx9S4mfoKN6S4l8dxvGV8mMb931qKZ98ALnuL4Iw0/gtQQGIMdJsSgE
	bQqjR4GEBiHxLq9O5+zVHVuM9MyeXDE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="nv4/MaqF";
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767568060; a=rsa-sha256;
	cv=none;
	b=pIMHxvQZ4kWZqevO/5c7YxPHWh3dPbAThJttJfanROMIaexKdMTsjBxc06MIA64l7OByf/
	wJN0LSuRfwRkAI0V+QDSV6nmUb8Bes7UWQeh8e1u78SJPXttcySnou/N0m2xaj4sTv3mHc
	JzGFC51ZYwNeVyyP/VkQ9gg74TqNTFg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 87D1B41A18;
	Sun,  4 Jan 2026 23:07:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51841C4CEF7;
	Sun,  4 Jan 2026 23:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767568059;
	bh=VjS3WbR+m1PlUG+vqvTDHxuJDU7kaIokVpYcq1mV1O4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nv4/MaqF5xA2NXG/j2hRDkX5Yy2qSd+HYWjSA9aN1U1TQHUSsqKEPfOB272mlQsZd
	 E6e6yuwSzEJmVMCRNqHyM+hrjNamWjNwEAkFiz0Z7Bb4NDOpgM0LyW4G4qhPewZZYK
	 diPcsxDQqNFFi5s1tWJFTMiRWn1BiOkcug+ssiLhyHL5l/x0ce4pfgwYjlX47u58QH
	 Jikc1Rc5fqLmol2qAwE/fvc4Fwm0ZK3A+AbimX4gbIuGvhRSZuba2LAslfBoqQCpIr
	 JBHdRhkY7VqjRypsRJnDcadGJfYM4LPnUKoFploHb5NM5K1mPd/okks1GN/K9DqKY7
	 FlibPEnsFLfpA==
From: SeongJae Park <sj@kernel.org>
To: Aaron Yang <yangqixiao@inspur.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	damon@lists.linux.dev
Subject: Re: [PATCH v2] mm/damon/paddr: initialize 'folio' variables to NULL for safety and clarity
Date: Sun,  4 Jan 2026 15:07:33 -0800
Message-ID: <20260104230735.67401-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260104013255.16962-1-yangqixiao@inspur.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: cyzg3afnxi6dbc854ro6qbo6shydnq39
X-Rspam-User: 
X-Rspamd-Queue-Id: 84DF9140013
X-HE-Tag: 1767568060-170743
X-HE-Meta: U2FsdGVkX1+U+hej/uKKytPWOtaumlK4IaC6HT/g/DxIzXd+Q4aDwKPCuedAiIzPx4aQfooO77W+vPe5/DIG2ckMufAjTNa6Ii39mMA6t4Gs7nO1Mw+WWzIpefyS8hd1HYyPhxwiFKSm7ZmH1j5Ary2XmpbshBgXF7TGxJHtKM3Am952QdtjVxYM1R+aLze73te0rLfUUtl0GWrTZ+WACvhBXvX5LhtmqTqli2nX7emYnS460ohDyk35piuLA+r2zIPs6tJtVaZckC1H+oqIeeEfFjpJW7XgzsyVVOQZ6oQ6BPrhaAfqfNIFzGsz1+U/H0o4zK0v+wA0adrzoBAyiGZM4xf2IJpcKAz2jC+44DV7rizEZOKAOT1FgTSPZ/dHNsbUY+4A3woeCCArr82eTt7gKMqdJFywLfikYKMWcvazd7vdc3CwCGYVpBxmtuIOTB/B7BZSIsQDWeMx/3m7ihhMvnRh0d5JJzacYK58qnd81U8FSJhf4ZStDWdgMfrd+lMsvmOoMbAtsqv21Bs2ajqvY8ezkCOZOG333DBYlTViOC43jrqHmU6cHWogTAf6uqT2ECvbQPt3dRyFE08v+zdtu7Ub+qmi0YdgQ0yXXtlh17E5w1NPV49ipfXJtQJAr7iI4ydzY69DWZbhwk1afuu6kTMWCHjsDCcTRKS6NXUrlPoxhoTGU1sEf3NZ/AZstF3AptFHoLky4ZHjYULskfWkPvdpuhOtqZjP5pxulRVUfeI50VAKsgPmt9/P/HTNrpY9mQyKwqUnV59IEVrLqcXC3ROBX9uebwVSrjsNzZ65EKQh//WKeIx+DogARtQhUAoeh4ijpZmP1IwStRS42creu1xIuTJbpE0p9/lEDpAG3z+E5vNrJdga/0en+e/VS1/r/S/64Mz1hMGhRP5Sl42S2qm8VSsFtYN1GB8nHLIzviHyNEUBStbhNlWrctx3kxJnJqNj9xHZ5x416DC
 3kqNdCUe
 zDjoRC2EdhGQiKJN1IVQfKhSfzvZ3+WlLtLDOb2ksdbZJTlCduGX9D32IYrbnafGB12DClgvi5TGVeTGzjb/mQL9O6NrxOPHK/NQbwce+vPaAfk6JI5mdaPq4o63RIl4G2jFtJqRL2W8BdOgxq0NYbq9ZTQlgdDZybVrmWqY2KNocdx9byatuXfHJBo0LknORc4Ioj/tC73vXz9nsJY02sHwoeN4/kZcgkVDOk8QwSpurRtTLNC9Q8lTj1ixJO0aeUG6k936OsDF/7aK6N+I5z2queHwFeDJPebQYqQjJ8MVQZeuNvKoSf1S76g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun,  4 Jan 2026 09:32:55 +0800 Aaron Yang <yangqixiao@inspur.com> wrote:

> In damon_pa_mark_accessed_or_deactivate(), damon_pa_pageout(),
> damon_pa_migrate(), and damon_pa_stat(), the local variable 'folio' is
> declared but not initialized.
> 
> Initialize 'folio' to NULL to:
> - Follow kernel convention: uninitialized pointers should be
>   explicitly NULL

Technically speaking, this is required only if it avoids unsafe code such as
use of the uninitialized pointers.  Because zero-length DAMON region is not
allowed, this is not the main reason of this change that we discussed on v1 of
this patch [1].

> - Improve code readability and maintainability

This is the main goal of this change.  This change allows readers be able to
know the function is safe, without have to know the fact that length DAMON
regions is disallowed.

> - Provide safe fallback (NULL assignment to s->last_applied is harmless
>   and callers check for NULL before dereference)
> 
> Signed-off-by: Aaron Yang <yangqixiao@inspur.com>

Because my above comments are for only clarifications of minor details:

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---

FYI, this is a good place to summarize changes you made from the previous
version.  For more details, please refer to the doc [2].

[1] https://lore.kernel.org/20251231055737.73325-1-yangqixiao@inspur.com
[2] https://origin.kernel.org/doc/html/latest/process/submitting-patches.html#commentary


Thanks,
SJ

[...]

