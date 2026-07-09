Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A53EC44501
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 13:15:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C8326B0088; Thu,  9 Jul 2026 09:15:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 379706B008A; Thu,  9 Jul 2026 09:15:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28F4C6B008C; Thu,  9 Jul 2026 09:15:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 060F56B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:15:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 91B72168455
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:15:15 +0000 (UTC)
X-FDA: 84969284190.26.AE9728D
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf01.hostedemail.com (Postfix) with ESMTP id D049B40007
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:15:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=hcHM9UjY;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=50jcczpJ;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf01.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783602914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2eWXoJbsmPACrUiEI6Qes7YghoFFmPaabwm8a5YUjvg=;
	b=iEagSgwWRSNqVxlILWktXemenVKyGPQuSzK0844dUGxXABfHKzZIj9lov3+pXcqKeASHYO
	veoXjpNcmfpAG0DQgVba88vPokU50J1oH1zP/FUHtBNJQw1NNrB8v1QKCXtfOFbylcsCSZ
	cbHTsiVgqmIJhA5iT1ooPMCAiiYx/MU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=hcHM9UjY;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=50jcczpJ;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf01.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783602914;
	b=wkzNivCtPyjlVmsMsA3N+pqfgNGByDmggLU0iqn44t1lW5PWLgKcRNLcOn6XucXxVOaCyC
	SpHVk/RqXLY4y/TiyvF+tAjkiFllOK4N+OKLFDxMlvJlWqSL9jyJ8bCJ1B2PYgHh5SAv5e
	uR+e6yqWJX3wWuyoBKeCvTiqaWKI8Ww=
Date: Thu, 9 Jul 2026 15:15:09 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1783602911;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2eWXoJbsmPACrUiEI6Qes7YghoFFmPaabwm8a5YUjvg=;
	b=hcHM9UjY2WcIxUhWAQ5bfTfhnUDaIvNt0zTL1QGxytCGn2/Pt1JuQgl1O0B0c0Fh/k8xYl
	oozFDDllzS8gho4Q4Og9D95QhNfRy1QGX8kbN1RLp3JQnpqqz+1U/c8eQ6A/QKdH86EyDK
	Z8/Ka4vBvFI7rJ5OHYy9hYwxrAs1ZWQDgzvgA/O8FDPKWfN773GNs5xexJBWmmDcrMWIL6
	nhA9a5OhYmcZtXqQoKodZEp5jhMY7ck++PAE+6JX0vNZyjBZrUGr5BbqVBaaeWI49oouyK
	cKHUfDWhXC++QmyZeOfYpSAtcDA+dqPTQuT56KkV7istkRc79R2Iz3GVAyWVxQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1783602911;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2eWXoJbsmPACrUiEI6Qes7YghoFFmPaabwm8a5YUjvg=;
	b=50jcczpJIGp28/Y+rrdo2bcKZ4fBBALge0z10UabFspXx1idCA3exxs+6JwKQ4tQ1HdLry
	TRfTEYvVRqMHTRDQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Wandun Chen <chenwandun1@gmail.com>, vbabka@kernel.org,
	rostedt@goodmis.org, mhiramat@kernel.org,
	Alexander.Krabler@kuka.com, hughd@google.com, fvdl@google.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	akpm@linux-foundation.org, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	ljs@kernel.org, riel@surriel.com, liam@infradead.org,
	harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	pfalcato@suse.de
Subject: Re: [PATCH v2 4/4] mm/mlock: migrate folios out of CMA when mlocking
 a range
Message-ID: <20260709131509.iIPP2VBh@linutronix.de>
References: <20260707125925.3725177-1-chenwandun1@gmail.com>
 <20260707125925.3725177-5-chenwandun1@gmail.com>
 <9b227263-56d9-41d5-ba8e-c969d8d68785@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9b227263-56d9-41d5-ba8e-c969d8d68785@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D049B40007
X-Stat-Signature: kjcmxfn8idcx7cotssbb177nfwrewwt1
X-HE-Tag: 1783602913-895419
X-HE-Meta: U2FsdGVkX1/g1YMCYsIlPRQz23Unz7DY1qv2fRUsoELNktEdgkk7eTmV7joV87y13c0GtAhcEu237hAIuTbe2KYDx65O8wqSSwCGJf1eo8gKINX+kPNZGBfW6O6k47H1qg8SYLG1tivUjpnG9veQ5w7YWmbNcotDMtRiQ7o2S+JbFpqIudNLUKMM3+8WgD8pOZ3rP58Guqdh0S70PDH5iLCdUlle5+osH7JNZE185azT6fZrCR35HiuB1i0iXED+1C5viVVFINeAJqdqfKpFRffRhqGcglnoEaOi93wvGMgbEsf1Z6iWPbPWNdwoDLVm0zz8VoWdufwTcO6YtMa/1Te2AIOMu9bY/bwUpWRMwlB1hPZBl/HzZgi2v49WnUfIja5IqAsiejnNc49FlD5snaI1wx8wqTJF1J5oWBzNd2twmXarCu7EzMy4S9thMNyxM8moqymstP+SV3p+KdRSNw3PU54m/UOSDVN1UgIMQSXyGCbHdv32vFnMdueSHh/t3H1o4OT9+cpYcrfXIC80OvSBrljoHEdc33CLFWGX7z5yYRsompsiP76IxM/uRx9n6Q8Yz2yDUCqWOKdkt4ljg4r8Tlh3mD2WfTfhialIyJmCemTIn65FUABdbMxYWM1KhP+2stlTaqYra8UAnWMhV8toxuuEcY3MpuJ+9bqJl5Ob1aeXWvuC6/iEUKr8/hsUk1gawhmS6vjPIP3gTQbOc+BNpVMLKAWMIi03iyZPD6L2Piuvj/hKH3JI7XZ7C7Oa4P5LHHOIhsOdAzfRi0MN5MfkOSuDNmbvm35yIy6m0JIeJvJGmz4i3Z4cVrRncuVh5Y9niHUnH1oOXRiKsfuopL7edWOe2tZc+lzHm+r9ZHV+hWeTsBmvaI68mdbR+4FewxAXSj9gDs/gp4EszB6DrcMPxPNWhSDGDZmdTrgP4p1kKynsbydUTOW2hprDN26RpD2vlozH47r4Ewu0ZJu
 F4KXhEce
 nEFJnGaG2rMXwLtmZf8qzApz0cMf/NHgjvUGoVH2TdBvk3mUWjElSOR84TksgC1UoDVoaISOdRPuEzThvuqRRFFiWKnjug5vXa2Q+jZpdJ3Bw/wU/DRjEFFQBJTz/kdYcCPRgWrIgUMMVLJPBvRrDhza49I6XEZ6tRzv8meBtEck/RCQeMp5ularXB9RFymq/tTDwmWEzqiNcgec6hOUM25E4UD5n/x5d7TcawyCxd9g3zEFL/1CeAj0XhLv8APIHN+nM8neeHb6C6JpFfevToN4g3sJKAvdHcqrv2diLho7/v7tNAK+dMZti1bONGz6Q2wLGcb8f/w2BOKg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-09 12:04:33 [+0200], David Hildenbrand (Arm) wrote:
> On 7/7/26 14:59, Wandun Chen wrote:
> > From: Wandun Chen <chenwandun@lixiang.com>
> > 
> > The region covered by mlock[all] may contain CMA pages. cma_alloc installs
> 
> What about ZONE_MOVABLE where memory is supposed to be migratable?

Would it be bad if the pages would not be movable anymore? Does this
effect just memory-hotplug or something else, too?

> Also, what about drivers that mmap() CMA memory to user space, and
> __mm_populate()->populate_vma_page_range() would actually try mlocking them, and
> they actually must remain on CMA areas?

It should be safe to skip those. They belong to device and they
shouldn't be affected by anything including getting swapped out.

Sebastian

