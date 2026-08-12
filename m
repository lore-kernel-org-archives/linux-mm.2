Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3D3BC5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 10:50:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 173FC6B0129; Wed, 12 Aug 2026 06:50:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14B246B012B; Wed, 12 Aug 2026 06:50:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 039FB6B012C; Wed, 12 Aug 2026 06:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DEAD46B0129
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:50:57 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 81130160245
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:50:57 +0000 (UTC)
X-FDA: 85092299754.03.28A4D23
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id 73C3B40002
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:50:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oGoittdM;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=scBGa8Hd;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=S6lOfvp7;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZThrv6N3;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786531855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YtE6Yx2HNNmNt17xsrGAWYsQEss7hpz4O8ku3vflf/Q=;
	b=6Yo7DtNAyp1p/naRQtgrfk2X70SkG7K+QuoQ18TKtTOWhlRG4jYUJ/GRqXRNgDK8K6Y6b+
	OA9+D9vzk6kuawVe8DlwGd27lt/ig097ypm/a1jAla/+q6sOY9vaBU2SMVfSIgs+Ygy7st
	tYdhOH4FQL3sItSRcrOs0LFdYtRGPlg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oGoittdM;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=scBGa8Hd;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=S6lOfvp7;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZThrv6N3;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786531855;
	b=mNqThKLq4Dc0npc+Jo78nVnhwi36KMW0vCKqUZ4xFd5Wxsbzhl5vdg4KZ1UI8EYMHEddYR
	RVKeL+ThLYPsmd4wrph16cldRmoG+8eSzxaJNrO0rFJ3Vxcb/VESxhi1aifnIqGHP3tPmm
	hIZK7bj47JJ2uXPD5pWGdtNEyBYJSYA=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BB2928224D;
	Wed, 12 Aug 2026 10:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786531849; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YtE6Yx2HNNmNt17xsrGAWYsQEss7hpz4O8ku3vflf/Q=;
	b=oGoittdMDb3ThZvRf9L1kywp8nX5c9YIpHpax1LVFmkCKJ/In4n/0Ygc/Xjw7/SKJTmajr
	uGuV7XOPMslMBITAr1DMpUkxlzVzSuqdKiFEMeXYuHwYshY9v82nSn0GWQlgP0bREyMgSI
	0ieE0VYNKXZYIQ/i+qeB6x876ZZc3U0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786531849;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YtE6Yx2HNNmNt17xsrGAWYsQEss7hpz4O8ku3vflf/Q=;
	b=scBGa8Hdhv42zKidMn+WeSsbTq5cPNn1R7LCXcaN/e6Hyv5R6sPYvmQwr0H18rTxV+IXIq
	PJsEDctSqTppAUBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786531845; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YtE6Yx2HNNmNt17xsrGAWYsQEss7hpz4O8ku3vflf/Q=;
	b=S6lOfvp7PwSIadMy+hGB33tMwS7ZlFJWxQ6pJxyIe6pdv00uAOEPXCk1wM9y+ku/nzlKMS
	mbFmScm8JP0jVBGCgGV4Bijfl1Rngsjcpo5PL2M9W9befArJVGYLxRx0Godyn4pE7X/aq+
	rSy++d8SP6cLkc1JXsUxbwvlBZoWpro=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786531845;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YtE6Yx2HNNmNt17xsrGAWYsQEss7hpz4O8ku3vflf/Q=;
	b=ZThrv6N3Df9nPUuxRFgXRoxh75MI9vcqRejU99vJTmvLzwHIUnPYc2Xbp9Z6UxIHDCICRX
	OkQoUj/Er1NNuIAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6FBCF779B1;
	Wed, 12 Aug 2026 10:50:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JNP5FwRQfGquSgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 12 Aug 2026 10:50:44 +0000
Date: Wed, 12 Aug 2026 11:50:42 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v4 5/7] mm/khugepaged: Refactor the PTE state checks into
 a helper
Message-ID: <anxPu3TBiI9bi53x@pedro-suse>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
 <20260811-khugepaged_pte_refactor-v4-5-ddac39d61c4a@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-5-ddac39d61c4a@linux.dev>
X-Rspamd-Queue-Id: 73C3B40002
X-Stat-Signature: j5bappxpdei61ajxr5mh191dq9wb5njz
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786531855-921608
X-HE-Meta: U2FsdGVkX18hrBrVNu+T7ic6f7VdIkU5Lw6sewWCm735HLQJvcxhx/kdkWdHvkscUkhX3l7tPVfv9jvsZGmfcZLXujOkO14LavEQ4MONZCDfUhRKzOQFAG2z8CSlB9dIOT9YV4K9Xgpk8Ev9tEokvl4v5Fe2bCCSRuprk8JHcxNqyCL3I97AT6vAjZMrdibiW5dKarY3un8r0/z8bIFfCPIsrKOnQqeQiH1aq9/vNf5A+eP1cMUHVu5KHbl9yOuckcJis9LgSfdm/Yfl0BOWs9zGEmDA0uCHgOVEL8ycLFyrwW6FVZgCWEQGiFTxLaCI9YmcPYCRDuHuWgGquoDDRpmZaxxVBP1ek+mJim3EhrGpsDKD0g11zWnQoZtjKSqJKPYU/GL6KAhgFQ9p8ZTaQAMh2LllOpFiFACv2ElXixw8R10fjBfPedXWk3qKjrcH6u6ex+m6VusoBgKe8VDZdOE+19E3MnfA08TM/PG7IbgGWmkTEJsNpZovZ2jxJhB/VXWe75fxDSEWq95FMb/mWvKZpwnFPPWaO9ttxCKi8o1rLISHGFYi3FRFk60oNynC0J6Xdusq7G56j+ZEfGK1sDBRo7XzJjhuMkFMOR2UORpBs3LIhzEYuGWl1C4uX5SNCAP4CaD7XKXzaE8raaU6P5UaxGxpraYtxVDaJe6ZcmXYG2nF67SDWN6iz3jw+d4U6FoLiFoHCTiTlKd+fumWQ7qttBbfkTesCfEn5B6Bjw1iUnMDfW9PDUGbRjIhq0aSKBqAi6uX/zytec6YdYGWUe8ltibl2zUdyrNVnmNVeNeYAMM77ZLRjtFrHirO1kmbaJ8pZ6hITAMFQ0mHGZeS32XO259zlh48itAR2iW7XxvfCiG2011gYWman1IpJShfB01m68whkNLPnVo1xxuGuLpMM5+ZSN9nXSEJe/m/Uw5jSKMj4J3eHJmJForj85TVYJiBNQYR8UsNfrqZNWP
 KymMYcbw
 EoPAJrzWk5LNPTzH9EZgKpcc28r9rhlRc9zf6YgbPBVJjJGk4m4UPKroFlep6zH1dTb9R2ZNcXOKcTASYUrT590c7GZ0AgLir/6AOc7C5vBAeJ4Ro+vW9vZTlBvwXeMb0qjg7iUZBC06a3tk6JDYwEdZ8vvXBGOi4Ze7zNL1OQVZsbKu0Wpc9PhY2wL+0l1CE7ZT7Bq5v/leJqrRzTiDYxv1ncdu9dLPJvmDxGpmmqdAyxbmg8r/u2u13fZ0E2ahlV5hcjnq3fjDfdDN3kN4YcSLdpgHQcguWDoMpI29/NHUQkmJnR9b2OkYIx1hjLuu7Dd7HlHPiO/+sISg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 06:48:37AM -0600, Nico Pache (Red Hat) wrote:
> For anonymous collapse, the collapse_scan_pmd() and
> __collapse_huge_page_isolate() functions share a large portion of their
> logic. These functions both check the state of the PTEs and verify the
> following:
> 	- max_pte_* values are not exceeded
> 	- uffd is not active
> 	- lazyfree properties
> 	- non-anonymous
> 
> Merge these checks into a helper collapse_check_pte() to reduce code
> duplication. We also add a helper struct for this function called
> pte_check_context which allows us to pass the required parameters in a
> clean and elegant manner.
> 
> A helper function is also introduced pte_check_fail() to provide a clean
> interface to set the pte_check_context failure results and return
> PTE_CHECK_FAIL state. This helps reduce code duplications across the new
> collapse_check_pte function.
> 
> Two slight modifications are done to the original functionality. We now
> warn (instead of crash) if the anon test fails, and we leverage the
> vm_normal_folio function instead of page->folio, this should be
> functionally equivalent.
> 
> No other functional changes intended.
> 
> This patch is heavily based off work done by Lance Yang, but modified to
> deal with conflicts and feedback received during the review cycle [1].
> 
> [1] https://lore.kernel.org/linux-mm/20251008043748.45554-1-lance.yang@linux.dev/
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
> ---
>  mm/khugepaged.c | 298 +++++++++++++++++++++++++++++---------------------------
>  1 file changed, 157 insertions(+), 141 deletions(-)

Ugh, this is quite a big change, can you break it down into a bunch of
patches? It's quite hard to properly review otherwise.

The spirit of the change looks good itself, but the devil is always in the
details :)

-- 
Pedro

