Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87C29C87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 20:54:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A65A18E00B9; Thu, 24 Jul 2025 16:54:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3BD18E007C; Thu, 24 Jul 2025 16:54:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 951C28E00B9; Thu, 24 Jul 2025 16:54:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 841078E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:54:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5AEE4BA049
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 20:54:53 +0000 (UTC)
X-FDA: 83700362466.13.E197EF8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 986241C000C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 20:54:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fuRKHQ19;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753390491; a=rsa-sha256;
	cv=none;
	b=yQtrZwkMC8JpXLJgNZpLa5BPh4HHTWh84qJYlqeYFnwrrIok7jRrybbf2wYCccnJcVgzfl
	GRH6MIg11pLO8RxSE9KQr8n6t1sgCBhxqgA018XedDPbX+7l43eFGRP8EtQJsyeBXjyJE2
	1U+Lr8PNxY1MzuRN4jMlXlPwbIXlYw0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fuRKHQ19;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753390491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IYbIH1+sQsuCNw1RgZBK3mZzhAsvMeOkV9hGhp9kcXk=;
	b=kKoLr5GoIRfJOogyxsIyX/9Dajq9mFNStERxaKIffyrmWrt+wv46EHw8gJz4SiOV5+HT/j
	rKup7yA2yznkbQqh6E3c/yDDp7qAayn92mmfkuRNjIXYpCqLXejGRTJE0oUEQw60p7rJ6l
	rIyHqqWHv5QT4I0QWGrtHZiYj4H7R6s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5F90543D28;
	Thu, 24 Jul 2025 20:54:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4ADC4CEED;
	Thu, 24 Jul 2025 20:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753390490;
	bh=333eNMy9efQ52/OsrjZbRQ4qrnhtfhiNmmgOwpbdFCY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fuRKHQ19U4p1ELWKTJP8ERI1j7+vUo99yHH7Y1Gy/Rm8KxZ65RkaDw7OMdJZA15tE
	 7rFv75vdk/9dfYgXSqTJdAC1ujP1IMf5j2bFr4nb//bWcIgnxaYu1byM8iwoNwCWnd
	 7uJE1QbH6wta6xsOGa8cb0BwrsfGsn9CTIsH3u9Y=
Date: Thu, 24 Jul 2025 13:54:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Uladzislau Rezki
 <urezki@gmail.com>, Danilo Krummrich <dakr@kernel.org>, Alice Ryhl
 <aliceryhl@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 rust-for-linux@vger.kernel.org, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcachefs@vger.kernel.org, bpf@vger.kernel.org, Herbert Xu
 <herbert@gondor.apana.org.au>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>
Subject: Re: [PATCH v13 0/4] support large align and nid in Rust allocators
Message-Id: <20250724135449.2cb6457b90926cce1b903481@linux-foundation.org>
In-Reply-To: <20250715135645.2230065-1-vitaly.wool@konsulko.se>
References: <20250715135645.2230065-1-vitaly.wool@konsulko.se>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 986241C000C
X-Stat-Signature: hyahmgpk3of5hb7drrso7aw5bbsjqhnt
X-HE-Tag: 1753390491-542370
X-HE-Meta: U2FsdGVkX1+uI5a29yaHkJdCQAiIwclb6HWQI62jE4OcK9Vk7dNLF9rEyUHrrNUMhdDidzLt5KhT7ltAdqdXMUXog7lN1x7kqCFLW+lXkWI6zYC3ZSmowZ5WnA/lgEhUsXR0uh1saG5Ok4PnfBZWI99SCNHAi2o98Hs/6n0zZAAffPfvSJHIw8ZHLpQCsx6SlxvH4d+ovb7fjvkJkjM7iVRocwMrj0dhBrhC+whSGGvzWImMddIVAlID+PlZzSQLediEGYEbuqHM9CD3a7eunobT1guT07B52cBmMPVfdpjM3FzPkf7rD5y9sk96GGmXmBzR9zxPGZGyqBxTYPqBU9M6CqkIkw+JfIgIQ+C2v7C2fg16YfoozXXjL1W2mwTSFF3+0e/KwXW9O910jTiv3dIfEoP8j4wCvKjSVniOM4YdDTo2LMTgUifwyaStloa+6WZJAcVJtFAyi8qpJwhsmt1CTCt6D/UUlYLfVhWwfCfgEl7FSRW09EZ81jUY9XozY5jBzGE6/O4tRznNXY/mc4sZdTf3Uc2U8fOg8MC826l1/M5+f2TzLng1PcvPgnN8GpfAgzO3rBJafcV2909tY46TR8oBeQQFbQkocoohlRi2KFpccvzJCs46VwLs0dNVK16McKzDE94OOReVbjbvKkEWFAXno55kQDdyYieS8rH37SCtY6C137Oz9eVoOLDtxomXH16bQ9EWZQzOii6HYK8cUe7OYxTDtcdeOmx0DW/rIopeJum1Lt7BOcv2ofkMHXwe9G7H/Guc2IWm9HWlGSs80x2lgBOgsD6y2oApW/x9bgy2m5gRrLf/iLTTT/jBk080ASseCxz/S9D4/iMmS2FU15kSvVBnU4KkCVAJ3jwmH0Yf1sWQyJq1OPnCv7dq+tfqM80x28wCuTTHEr8sSdL/62ruaCvEC+Y8kz8bew8wzf3d00IL44xndUCowARbl5fz0KBYLcEDTHRWh9L
 bEjHnL+g
 N8bpn/VH24JpxoUuwaH8t19Njy/5hYiXDhUXBvwZn4sPT2t62RMCyS1Ekdty+vHf08EryIKDbbl5d4mXDsHXu0781XhQ+fHvIhx1rMl8xqx83DlUmMv4B6tJypusmekhX8jajszieqNxGYfD5i100tCQdl23fkrPT68oBXetmkb6VbFPqBXWyEai0102bAIgGnE9vkoZNhvJaM6JsbSWkXaq8XQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 15 Jul 2025 15:56:45 +0200 Vitaly Wool <vitaly.wool@konsulko.se> wrote:

> The coming patches provide the ability for Rust allocators to set
> NUMA node and large alignment.
> 
> ...
>
>  fs/bcachefs/darray.c           |    2 -
>  fs/bcachefs/util.h             |    2 -
>  include/linux/bpfptr.h         |    2 -
>  include/linux/slab.h           |   39 ++++++++++++++++++++++---------------
>  include/linux/vmalloc.h        |   12 ++++++++---
>  lib/rhashtable.c               |    4 +--
>  mm/nommu.c                     |    3 +-
>  mm/slub.c                      |   64 +++++++++++++++++++++++++++++++++++++++++--------------------
>  mm/vmalloc.c                   |   29 ++++++++++++++++++++++-----
>  rust/helpers/slab.c            |   10 +++++----
>  rust/helpers/vmalloc.c         |    5 ++--
>  rust/kernel/alloc.rs           |   54 ++++++++++++++++++++++++++++++++++++++++++++++-----
>  rust/kernel/alloc/allocator.rs |   49 +++++++++++++++++++++-------------------------
>  rust/kernel/alloc/kbox.rs      |    4 +--
>  rust/kernel/alloc/kvec.rs      |   11 ++++++++--
>  15 files changed, 200 insertions(+), 90 deletions(-)

I assume we're looking for a merge into mm.git?

We're at -rc7 so let's target 6.17.  Please resend around the end of
the upcoming merge window?


