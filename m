Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E800CCA470
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 03:31:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D4678E0025; Wed,  8 Oct 2025 23:31:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 785638E0002; Wed,  8 Oct 2025 23:31:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C2078E0025; Wed,  8 Oct 2025 23:31:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5E08F8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 23:31:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 21160160989
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 03:31:15 +0000 (UTC)
X-FDA: 83977150110.20.67E0B21
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8048E16000E
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 03:31:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SYNWnuJD;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759980673; a=rsa-sha256;
	cv=none;
	b=ouEGHRQFKbcFWebKSvturAGOYKcqdirPTqRUYfcm+hwt0f9vtlK4pgwTg6B0lVJaV7fPuG
	ccYtCyNmp4WuXZrGOg0cQVelwKO3yZFwT82aBEam+S7g2Gvuf5GISZtDbG4HzfgZC2ysVP
	JVUB0egiGOGYwA/YwOrB/XAoEU5QCh4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SYNWnuJD;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759980673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GPyJ+XxDSeeUab2Vl3VncVhD7wMmFqzNrLSUKqmU6m0=;
	b=tkUrp767M1e277hdsGTxFzIHV7HMERRxXiuD/XUt5YnuMcl+txm2WXbr5dndbBjIn2CF5N
	HhG39aZYMgmVaGu6j6IY4VwpojvudD+9Hnyn5Ql98UJkISRHoOJlmD0QgP6HLfarLpDbDX
	guDkRztAyhrnKJE4PTGzmpjKWyipvO0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BCA76611E9;
	Thu,  9 Oct 2025 03:31:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D026C4CEE7;
	Thu,  9 Oct 2025 03:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759980672;
	bh=clhg3FgfH2TU9dqly+qtqS8CLbUif4SzcXFPqfUobns=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=SYNWnuJDyPWSTD0a6vStnPhRzdR/bAngJ6LoxocENe2iqmrvnJEj1OoFxb51dZPdL
	 8OVnFtbXO89kfJ0gvN3pjuAm1NWbKfc2NuuOyLh5x+7Kz7Z0Gw8BxcxI3LBh7Oj49S
	 bqQVZyraZ9tk2vgx1p9z4JA75RzZJgy8GTbX7ugs=
Date: Wed, 8 Oct 2025 20:31:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
Cc: Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Ilya Leoshkevich
 <iii@linux.ibm.com>
Subject: Re: [PATCH] mm/kmsan: Fix kmsan kmalloc hook when no stack depots
 are allocated yet
Message-Id: <20251008203111.e6ce309e9f937652856d9aa5@linux-foundation.org>
In-Reply-To: <20250930115600.709776-2-aleksei.nikiforov@linux.ibm.com>
References: <20250930115600.709776-2-aleksei.nikiforov@linux.ibm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: a5s3991ykgoyhktqcar7n8gnymhj4zyu
X-Rspamd-Queue-Id: 8048E16000E
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759980673-506437
X-HE-Meta: U2FsdGVkX1/pYosencrXP+eXbbgngNPDKwDVD2Lnd3oxPcJ8OGbZ7z42pdb44Ux4P9BQOHryT4UCrjr4HhAnZpQpUm4sEKtbdl1vjNsrPXjyyXZLsCc6BQvKrWY40cPFD/7fiqav1s7ND4DitsfTwP22SF0E2cAKymio4/udgbGW4Rckqs1j/PBaaVCat/xG6y2jspflf8BfqzgSB5A8ToSYcnlcDuUd6+nfXHY4UUiX1XRxBT5LiqncUlG0rkrywMEJ/7DKeqaDyysa/4uRLp/cU2YWgTxyK9+BYh/DApzKBciZAgiv9Xu0Q7FJTTFFn71srLzwIp8EAtY/cH4AcSDyoyqSZhpjQVi5vdFwG+Gh2kiL7qh993zXaraxVVgfnu5arX+KcfmJboxaS6fxfngr+AQOtOSFVfXAoOcUXAwNgHV70TkV4ry6L8Him64gWA43aYKXrV1utBlEsg0+1/8YnRd0V3mPeM4zrmL1+yL1xzasSdNmtq1RDjTH25uxRUNJOrEf+zOBdxHqOLNZnjq/tsaWq4SJn479Su56rJqfmXpEy1/Tw16Y5gMS7DmSS3X6EJVjkPuthVxNhPuSwH3Gq/xEOIwWxr3cTHU5tahRSjhAYVwiYwW/jGVBoOBkZ+LhYT+9T3vbmPbmxt+WtDoAWb8a2b1+bM2pQKbq2sbCprZvk5NzdFEkYwF0OTRVuawBUqc55DuJ1fLBMQ/EYCpaKGcEd7FcVFd875Ycl5e11QAdyuGoVG+huL4U52t6k8FgWdUlFTqzeoVsprlnACe3dQuQ9FPqCM4q7tz/65+ilV5irIKGaT+V8JhmYiyxjxaq6kf/1pDMx5dsx7Nq/vfjaa7cuVbaJf+IuywreHyhaNTvSiwsOxj/ThSGMKWN9Jq402W9mQN24IbGVdccNmgPAiWC6j23VD+l8j8A0NtRc2NJ+b3kSwl8wYDefhfGU72shieGpUjsRy8xC4t
 ZmtuZGhn
 JuhIvutiN3kem+WIhvmJnOCOvnE1+bRFx8LyiwGV7xzBASngku33hTum+1tMcTs2+aBl5nixCXTxgVMK88rK4U0f+krLvFu44LNGJTWnkDYvmcIkIqDBDpuyBElG+yp3lugmpX4Ym4o6nJQesHBEcmvcqM6wXPu7FCxGnFrrNCkQg56T1OTat7RE0zcVDmbITQJVb0xQgx8Z+ZMWgA2rvi7Z7WIlADK7xElJfja+2ehlvdc61yxK4Gte9ZSBgHWpDpZVypqZURhurwVM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Sep 2025 13:56:01 +0200 Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com> wrote:

> If no stack depot is allocated yet,
> due to masking out __GFP_RECLAIM flags
> kmsan called from kmalloc cannot allocate stack depot.
> kmsan fails to record origin and report issues.
> 
> Reusing flags from kmalloc without modifying them should be safe for kmsan.
> For example, such chain of calls is possible:
> test_uninit_kmalloc -> kmalloc -> __kmalloc_cache_noprof ->
> slab_alloc_node -> slab_post_alloc_hook ->
> kmsan_slab_alloc -> kmsan_internal_poison_memory.
> 
> Only when it is called in a context without flags present
> should __GFP_RECLAIM flags be masked.
> 
> With this change all kmsan tests start working reliably.

I'm not seeing reports of "hey, kmsan is broken", so I assume this
failure only occurs under special circumstances?

Please explain how you're triggering this failure and whether you think
we should backport the fix into -stable kernels and if so, are you able
to identify a suitable Fixes: target?

Thanks.

