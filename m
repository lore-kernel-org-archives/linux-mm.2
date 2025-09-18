Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FC99CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 11:46:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 775548E00F9; Thu, 18 Sep 2025 07:46:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 725D48E0093; Thu, 18 Sep 2025 07:46:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 614A88E00F9; Thu, 18 Sep 2025 07:46:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 512008E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:46:51 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EB28A51C18
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:46:50 +0000 (UTC)
X-FDA: 83902194180.29.6F79F4F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id BE14E40005
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:46:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BUN1cpH7;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yLverfxC;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KVItu1d6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=VH7pas99;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758196009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8DePXp4fUzj2VkRR30Ty2gOyQ/zyboG3IhS6cWHdUzY=;
	b=bUuitHiaRTqaQ6d3aqnDRmmmSeM7/+ya/4Pe0qtVxwxGnrnBbXUW/HR2VzRO0PFE+YMNLy
	Dx7lKMWNxDi+RLBPj0cR9RcmfG/tuBvUwSTwpr0UKV0dcSrr3vfZCVcMLR/O6GljgcxYQ2
	qsTVgBMTetmwwYudezuHMTW7TALzvkU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758196009; a=rsa-sha256;
	cv=none;
	b=0Mo7d/q87UK1j3z9QuI3S+BjDJlOVeaYdDJwT0mp46TVHas8G1D88WoiI85YcEkmwG4QKW
	mWNM3OZTthrMYcxVy1jLBWaqOcFTanxgu3FmTd1WIaDKy4/W2P9JfEfOG8SnFYE/6KxjkN
	lMvKvVvIxBEyxb7Y3og5cGCPNtWuqYA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BUN1cpH7;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yLverfxC;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KVItu1d6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=VH7pas99;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CB50F33783;
	Thu, 18 Sep 2025 11:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758196007; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8DePXp4fUzj2VkRR30Ty2gOyQ/zyboG3IhS6cWHdUzY=;
	b=BUN1cpH73R+4pwL4YvAboha/rA3SwWwimEZmuyFYreBkVTFu6BghhR7c5u3oR/292QP2Up
	0fBYjE/NQtdYbdFqOHptKcfM3gbujaXvfDfImp4Kz/7bHNXVp2ARMu1CK7fVn3kJo30WGB
	5HPN8nJ7yBAA4oAivjdtf1e4HkKZZWk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758196007;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8DePXp4fUzj2VkRR30Ty2gOyQ/zyboG3IhS6cWHdUzY=;
	b=yLverfxC6gdH8nqT9c//5OCZya0JswpzHorA2ek4beIQzR2EKbqRhrVyJaWZmroT7nplWe
	km8zkuLWfZc/XiAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758196006; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8DePXp4fUzj2VkRR30Ty2gOyQ/zyboG3IhS6cWHdUzY=;
	b=KVItu1d6W0M5/H3gn7D8KZhdqxTPVoZppIAa2RfGgnv0JDSt+IFAeN8Tlug9XDDUKp1yAG
	2fyKs5wl1jivweyuoxlKeRSDMelNmdsaQ26wH4AaV34UZvHDwiRkjlgqqtFuAK02ZdPZyS
	lUhKkjxvup8IFi8Z8Neg3zgUQhQqiuk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758196006;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8DePXp4fUzj2VkRR30Ty2gOyQ/zyboG3IhS6cWHdUzY=;
	b=VH7pas99xZm52NkBWoqw52EGBDdJu2pK1U5cTZzZg7cTniiRenPV86oAlJAbg+abSHD7dd
	Nsj/GrMZcw3eIJDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C20DB13A51;
	Thu, 18 Sep 2025 11:46:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QCCwKyTxy2huCgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 18 Sep 2025 11:46:44 +0000
Date: Thu, 18 Sep 2025 12:46:34 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Kalesh Singh <kaleshsingh@google.com>
Cc: akpm@linux-foundation.org, minchan@kernel.org, 
	lorenzo.stoakes@oracle.com, david@redhat.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	kernel-team@android.com, android-mm@google.com, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 4/7] mm: rename mm_struct::map_count to vma_count
Message-ID: <2t6asetuopq2wtj7cki6qf24i5j5slhi3palturmf62db2qddg@zfdbh6nivya5>
References: <20250915163838.631445-1-kaleshsingh@google.com>
 <20250915163838.631445-5-kaleshsingh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915163838.631445-5-kaleshsingh@google.com>
X-Rspamd-Action: no action
X-Stat-Signature: gsfggqx3zc63ekis81bbrkcyqemycg6y
X-Rspam-User: 
X-Rspamd-Queue-Id: BE14E40005
X-Rspamd-Server: rspam10
X-HE-Tag: 1758196008-286923
X-HE-Meta: U2FsdGVkX18JOuEXlZVLalIVJobZF/3ZsWLWQNvH0xPkScUdP3odR9vL0sRZ+ALxyQFKGqHOBR2yO0qIvLiRX/NJFIqFoP2tOX7t8Q9dSUnWv6kkqjvosSi9Vpt9rG5imFaEX5c6xCimvgABgRHlhrCvZ6ss8EJ9G98OMHkK1liFB4rHBQDED6NdzzDKPMntwsGpZf3Vq6rX17hJhYmM5eZ6Que2Sj14PBqyrxgNtW/3kSsL44ByHFHngxVAqfJrXz8zC3/KSCJ7N+XJqemxazHVmy3cFGpnPTXP2wSL22yLUwcT+kOFTufq6xBC0L/kOeDOJEdOHaWVsIqS2TvJNMH3YYVgBAiMoLMsPgSPGxwjRnkdlrUK5wIjgMHKf/fLYe7UPrr11TjhXw13sZgw6WzclPnAKiuiaIR1RljGnFKIFBODR6MW17xtdYLpmBllVaOoWkwrbQu4YMf9ggjI9my7McEtXaPPag0qoxOe8mOYCftw/CBFlzb827Kxb+AZvGFM7sTEMxVzeBYrAbe3/R157ZTnV73aXVklBYvpyKezdrltRAvlD5lcUosIOMXuX7QZZOXEk94QW3uIHs7RfY5x8soiEx/veLTxRuBSIpyK+QMf6bKGXIIWimYAw28X+pgGnY2/TRbqEC43hTsA7jFMzZBnv/iaDZ5EIjDWYe+Olj6fiGm8F5+7GnIFA7Fuva14MakpQszZpmzizEAqyxRQ7WwBiy1/Qz0CrKHteTdGA6Bsyfmin2OBoHC3sdxunr4g624bhRyk8GKcuRh+jC7QBffYXNzohahq7QqqTS4up7Y0RO0yRcThQFvu/WSLcOdYGqACsupH25XVEOSRvpYDz+aZXckvO+NHj36BErpzs8iet3a0r3qZ7dZTjr837LbdlAc+HzGiLOqQNTa6cmVK7pvy8fo7O2ZoFOq9MFgTw32+y9oF8ZDt8RpcNbbg+2dD3rh8amnIV9V4iPW
 EOHKnE1r
 LLhbPhG/jh/RQDQIHJqz1iGyAwd7xOqqz4U46zTEGeRxehb2VjOzK2MtVCGZDVGeUuqU0cqREySIBh42iMbMOSf6utEjHNVernDj40G8yOqv/jUclzqGKL953YVKczwTlUKOuQxYRPlDj+t1XGh+s8QDJsSltQnoyclWYK767laNbHCfaDrMnHj1/O5MuC3oz123DAl7Mp58tm1ZNk4h+9S55SzQJ8aDup1AdCipCQ7GWoIGRf0HTVQ3vKXeriVZMxkaDZMPP2PUQYIgajFJTlRi4LYAI2mJIKdNOLMyN4D6+qSdzqQ2dLzM//+x67YVDSMlLVXMvq/X0+FgYH5aG6YIQzxVoeGPhpF+xMIiatMFLn6lPXn1QS6IZiKk76dapqCkxOJim8e3bvyJgkrSQ5ijnsyIc+MSMF9uEf3lYnXa4FNZr9nZiTfifxVFzIATdY5UGtRYd6y+xk3uI88L31VCyQRUaw3oV4dByehkRT1O4Y/qCiwvvaLN4zoQwEt50enex
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 09:36:35AM -0700, Kalesh Singh wrote:
> A mechanical rename of the mm_struct->map_count field to
> vma_count; no functional change is intended.
> 
> The name "map_count" is ambiguous within the memory management subsystem,
> as it can be confused with the folio/page->_mapcount field, which tracks
> PTE references.
> 
> The new name, vma_count, is more precise as this field has always
> counted the number of vm_area_structs associated with an mm_struct.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

