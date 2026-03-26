Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D50710AB82E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 23:23:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47FAF6B00B5; Thu, 26 Mar 2026 19:23:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4309E6B00B6; Thu, 26 Mar 2026 19:23:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3469C6B00B9; Thu, 26 Mar 2026 19:23:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 234CD6B00B5
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 19:23:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C9AD1140B96
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:23:46 +0000 (UTC)
X-FDA: 84589793652.04.0A1C2D0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 14FB0100016
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:23:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bXZehikS;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774567425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OQ+9vnYotY3DONXzWRCmVazKV9uZH+sc1uEoa5gi3KA=;
	b=7iSXr9PlPep3jDtbiu3T2h4Zzxs0Anh3mg3YGXP2cVWXKXNm0dzacNXgJAgHU2cSGLaXVM
	wVfs4GP/uH6+XbeQxERBylKg3XyBHqkWrnpsKq/V/M+b7bJmcts4rBM+yrOMjK2FULN431
	WZYmu4gvcFa0o8TkLQVZKZDt54VYBG0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bXZehikS;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774567425; a=rsa-sha256;
	cv=none;
	b=yN5s4J5J7bg7qTEvnaFz9MuqGRMSsA8/7L9pYqsKkfoH19PXH2qRdhP+jkr3+WUnhZF9pC
	x8gJIBzOAe0c3ki+ItyhK1XWy290EZEnh6AEW3PUyubHiD8M6a3XkpU3lr4PUd+H7hC8es
	ZpUacbp6cf55d546XJ2ULUPzu2j+W3g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C0C5A44511;
	Thu, 26 Mar 2026 23:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57D4C19424;
	Thu, 26 Mar 2026 23:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774567423;
	bh=ywefAlrhCimBtUrBIPGiIi039tfFwchTq617Tcwm5Zg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bXZehikSOnzJCjqTWi0vMkzNfGuZk/eIT/VwIhjH+YfQJA7FfwufOkVdraXZLMtit
	 UFempOXqyIbWdgsdvIhVsdje87SqXt0LakogZA+AVEscO5nxcNvZivw0Js6Ko2SmCv
	 WXz3MnsabMlyPLfXxSQ4Yi2IA2HAJPnOJ22/LWqk=
Date: Thu, 26 Mar 2026 16:23:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Axel Rasmussen
 <axelrasmussen@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>,
 James Houghton <jthoughton@google.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Michal Hocko
 <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, Nikita Kalyazin
 <kalyazin@amazon.com>, Oscar Salvador <osalvador@suse.de>, Paolo Bonzini
 <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, kvm@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 00/15]  mm, kvm: allow uffd support in guest_memfd
Message-Id: <20260326162342.b8178cb8940123324c1c9211@linux-foundation.org>
In-Reply-To: <20260306171815.3160826-1-rppt@kernel.org>
References: <20260306171815.3160826-1-rppt@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: eo9dyqni153ir4t6p1ofz15ceht54q1c
X-Rspamd-Queue-Id: 14FB0100016
X-Rspamd-Server: rspam09
X-HE-Tag: 1774567424-822385
X-HE-Meta: U2FsdGVkX18k9TkvEVnajSOntb5186koKn8EsveLXIGdRDeJu12mqNsOpmxwp6y8HiWSJCHSavzArL8dNEEpcJIfP5zOTmZ52pa/w2s3gvtfLdam48QXCHxoJ5Z1+Yrofrw5Fe6MqnkyYGOZHngLViXOEaOUs4w/nCNb4rl+d2HeXDDwuTxBaE5XI7S0WDVirZQkJPiLqVB2jvprXtV6aQKl+vP98pD8PP/iBb3S7OwzFn3Bgk7sZwE8HAb6dfE7O0x7NguJWG4aXYi9xV9AzLTH/RMl2ORvUjhFd2RXkDAEP0Uv/RLJbXjYwrKQ5PudG9zYR5FBDVHtNNT5ji4C0t7DCapzSwC9rq8mCezwTrxQIMFLX5OPVYv1NNeyUgKSp96aBGwIW+FvpySyZeugSNPTDHibpVao0TgE+UY20KvvGEeHMrf40o9wF7lv58plX5wGqEbDQLHn4AoJfkHWKkopJipmNBgUTG42/0jqarwkMf/R8GneF5AGW/QLG3H6qVHoipJ1MM4+fDCsCVg03vhWYKjTXEUtmJq29FM+ozAGicjvA6cG49ei4tX/Lj1SIwbAuwAQK/2mpKIwYj2/arX9d4x/bQEtXJsVjLf/KPPbUr9rPAAvKjE+ZOgvhECM1xKG6BtxStAnE2tglyFUB4I8az5ZSdE6a6jZ3piEK6+yhdtLf3MEZN82fv74jdhd59gzxMvd0/FX6l8a3XlaT7AX/J/NxaEQf5t2pNrhz8wsBIgvgv4aF7iFneGssi712dKnAHnuOoOSBXjJYOyAYUj3wfnnN3haEwSnM0zWoisU3nKzoY6VAR7MGyqGPKkC2b1jI9XQVV18biNFHmGVQe69yXnDNhNN/sNyj3ksTdJj9+U0Ys9Rvhzbj7G3XcD+zFQ4UT9WXga2V5bMAA3qsysOrnylRx9A9+jnM5aF536ogoT/lK5tfvdGdZ5bNzKJrFz+gf1KXAP8CXviLDe
 jSIs+glA
 +2Y2ohtz2cTqWz2cVGJx7gQwy345QuR2taAvS83lUsYPb5d40UyCyGBND3RTN0TRCEPKw9WbKaQq5veenFp+Yryh3f0ZcMcmmO5k7+zj8nVCYLLtdencI45zCYlh3iqep4NnMx3cjZ6WPWew0BcZcrkhJN2XtSIWj/nNJf6fRCXY7tNJ1d/GbaAxpV6Xfg7XvTdeBgCdVOgoMHylLL/pPO1DwxE19WnFMEcYAldbFp+zo12dtjGOGoLBM2YNymzLeZjOfqJLAtjaN4fx72YgqDcgmnFwaEE2N6rEPN269ehz9mxjmSFKuY1qdKwI9PVQdYMGB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  6 Mar 2026 19:18:00 +0200 Mike Rapoport <rppt@kernel.org> wrote:

> These patches enable support for userfaultfd in guest_memfd.

Review of this series is very thin at this time so can I please ask
potential reviewers to spend some time with it?

To create additional time for review I have relocated this series to
the tail of the mm-unstable queue.  That probably means that movement
into the mm-stable branch and upstreaming will occur in the second week
of the upcoming (7.1-rc1) merge window.

Thanks.

