Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A1F3C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 11:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 605486B00B1; Mon, 20 Jul 2026 07:12:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DCC56B00B5; Mon, 20 Jul 2026 07:12:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51E006B00B7; Mon, 20 Jul 2026 07:12:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2EF726B00B1
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:12:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B8EC4A0134
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:12:55 +0000 (UTC)
X-FDA: 85008892710.14.D89CA34
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf27.hostedemail.com (Postfix) with ESMTP id E07F64000B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:12:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZpAtUeRq;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784545974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MDxvOrx4DVj0VV+Y/wV9iOjtsl71lHDlM1UPvEJ30HQ=;
	b=4yZy6ewxqWZpfxzuu5tUyXNnkU+3SoAHY/fQPD5QZ+nxKlbcPGNQEzWrqzG6mS1nk69irI
	+7SNwrtdrqvFL7G7XUUWDCVCh4wx874ANmk0E3xWnx5lFFb5htYFVPuoBHmXrcVyqEjPee
	Y6md8pRsjQJ5UtNBTuNJKGR4CrrJU70=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784545974;
	b=Uk+ibCcSFBm3333fvPEbgnbaYohQmUfAvwl2szuEb1PU51IjgDXly4al2p2cUVacPpL/y5
	1ueDBrNSIIM4iPOO3owps7seEGKVKvnqFzIAKW5vCV1r5iyb8LSQ/6RSIj4z88nmm+TJsc
	FEuVyDTwBavs4XtVzIokGRr2vRmsCS0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZpAtUeRq;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784545971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MDxvOrx4DVj0VV+Y/wV9iOjtsl71lHDlM1UPvEJ30HQ=;
	b=ZpAtUeRq8aKa+BH6qVMMoCl8ndmZrk4t43VZkpCSSsf4Gkh9xQkZVmZdMY3bOD4eVC3BEC
	2VWFSY6QKabWvc8Ax3La9JxEM63qz68wXHlsBAfIP4EXKGoSNo6c1LKcUOCZgebbcXmzzC
	8pyU2R9O7vhHAM+z6TIsWuNURFOf/M8=
From: Usama Arif <usama.arif@linux.dev>
To: Rik van Riel <riel@surriel.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	kernel-team@meta.com,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Usama Arif <usamaarif642@gmail.com>
Subject: Re: [PATCH RFC v3 1/6] x86/mm: add untagged_addr_remote_unlocked()
Date: Mon, 20 Jul 2026 04:12:37 -0700
Message-ID: <20260720111238.3313021-1-usama.arif@linux.dev>
In-Reply-To: <20260717170036.743149-2-riel@surriel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E07F64000B
X-Stat-Signature: 9mdj3uxttyr96zm5sw9heg1t5fn86um1
X-HE-Tag: 1784545973-342564
X-HE-Meta: U2FsdGVkX197FAkxTzrZXwmfERbFf7t/6FwWvJ7u+7cwM+F6iBrLBHIk/37OpN2rKBQmqrB39jsoiX+3fBZePzRCr3pIwcJYTqzaZ3teFrVOU5xssbF2cq+klQbw8lyOOqQWFmTZnv9lXT6fwUQ0MB7Zaal51TPCD8HTN6ysW7Bc7axrwTXkpITszdEnbfbSXxg74hrkW8HMF6iS4LtXs72hFCWWjTIFKNY1oVaIxd8Sggo55Ds59lUV5qAXCmctwK6cQ22a/qjBXaiOZ5P5q6pcW6L8178hCNh3j0oOd1gbTKSjdYjDWjV0CcMg5xowTxprO/NOeWTSnLAbVaUHOstMenstdzLnllS9L+5x5bAvq93WWu8LnoZgbl0TY5gZwq+gbVVHByXS7T6skNGgLPHtcSefU7PTLe15iSbWIcMtpeqq/UK7gk3ocb9Q3t+o0D1DGzAhEq//oJmwRk0Ur6M9PsmBP9SbAM+xRdMQkrjskhG3cRsbhB+HnhYWM5IxMoZaUJtcl23gdtbOgUcCnoEk3TbGXhrkHw2QOacGTWYEOqDeVUawV2rkcd7DP1PDPYMrDJDSoVDYANikr8l1cFrS2Qxajc1mwhA42Wmn1ippY8PFFYSQb6BuKMPy9de7b2SAkXIpMrFolLuwzefqZ9THLY7HrlHpTdcdzXEFayQbJFcBay2f/zrpF1UKy39exOpSix4fUMh7/l/HDxh3+ZSApYtw1B+/XY+VS9Tqv+ntipgpbMpxLtzyGK98Cqr6VexvBgXz+TIFa7/8GrddfVLlt31NhiDSKjOoHc7SfesrUB6qavSroELpuzB/guz62o6+EAyqbsimkykRqPw3/A7LziurjVZykYZtXGJ+58z9dSpDvumV6PUoXdXpBsC8S+eux4srBzB6L2NlCEil+g6hnUZ8RqB7IKcrb5/3flwti9aVmPlGGLu1/hfIuSIyrZIaHV2Ofbp2Wd3ZdyE
 C+K65uwW
 LbSR/1ZWALmXgpXsSBy9vZn+qxrmdxVatfTDEEdQ6giKAn98bX7rkCwcnf5kHSwqf6deDSKYFWGA0vPre9yoFXw5xR7DAUCglWEwepoq5bu/+OiCsvHMEmquVmOO+Q6p9uHWMJkwLCCrS1tyGxCfU+Zj3GFZiuCup1qgszUwxTuaAgX+59KBZS2rq6w4W18mGoEUmWXuNBU4r6TEsCITPCUt88gU6JqwBOab++w8L5Ki+GnDAiXoIemzTA4Rq9168arUsrbNN/kASHb5AWB5BRvK1itZ02H3K0mqoBOg+t7BTGEI4TDr6AdbKvGvqGxylMHxpvKUttRMKg4s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Jul 2026 13:00:31 -0400 Rik van Riel <riel@surriel.com> wrote:

> __access_remote_vm() reads another process's memory under the mmap lock. On
> large machines that lock is contended by tasks polling /proc/PID/cmdline,
> /proc/PID/environ, or calling process_vm_readv(), even though the memory
> they read is almost always resident and could be reached under the per-VMA
> lock instead.
> 
> Looking up the VMA first requires untagging the address.
> untagged_addr_remote() asserts the mmap lock only because it reads
> mm->context.untag_mask, which can race with the write in mm_enable_lam().
> 
> That mask is set once, when LAM is enabled, and never changes afterwards,
> so the read itself does not need the lock. It is already read without it,
> from the context switch path and /proc/PID/status.
> 
> Add untagged_addr_remote_unlocked() for callers that have not taken the
> mmap lock, and annotate access to mm->context.untag_mask with READ_ONCE()
> and WRITE_ONCE() so the existing lockless reads are explicit and
> KCSAN-clean. untagged_addr_remote() keeps its assertion and shares the same
> code.
> 
> Assisted-by: Claude:claude-opus-4.8
> Acked-by: Usama Arif <usamaarif642@gmail.com>

Hi Rik,

Would you mind changing this to

Acked-by: Usama Arif <usama.arif@linux.dev>

in the next revision

Thanks!
 

