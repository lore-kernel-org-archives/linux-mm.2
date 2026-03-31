Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C0581061B21
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 10:27:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4DA76B008C; Tue, 31 Mar 2026 06:27:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFE046B0095; Tue, 31 Mar 2026 06:27:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BECD76B0098; Tue, 31 Mar 2026 06:27:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AA9206B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:27:18 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4717E140C81
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:27:18 +0000 (UTC)
X-FDA: 84605980956.20.90A0A05
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf13.hostedemail.com (Postfix) with ESMTP id D062C20009
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:27:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o7RBAi13;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774952836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a18x6ZQjYkqeWxFtayZuE5Lz8yKC0RDpl9ExxmZO+X0=;
	b=qoDQ7JvT40UjXZIypVN32GFp7q1MO9/qc8/STHwVWZGB0wtI1/3FRgGGOk4MDKuC1BL4bW
	yEerIf3s0RyrPsF05nsXNH5gMDWwHEl+zWm/G5d9nOewlcI4yS1Ss8XTl7PHFN1koRxJJL
	zgiS28kC7PKS71l/ujnT+RoPxpl6hU0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o7RBAi13;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774952836; a=rsa-sha256;
	cv=none;
	b=C1vA1Xdzr4eGt+n3mj9BuHp51kxVgMEyHiy1ExbMN1XWi6U+VKFedxO4JldMMzzrSUuGZc
	f2B5qCkX0kRw813ytZu+CegzohSWqF+F4e7mxLOyy5i7WBaa7/+E3cfkR19mPTxyU0n9I7
	KlKPznSfn1Y4/4V9LfksgzMmG4P04ko=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774952832;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a18x6ZQjYkqeWxFtayZuE5Lz8yKC0RDpl9ExxmZO+X0=;
	b=o7RBAi13M3ymJIxeIcVVcVU7ArACtE8dCrjJjGz5z+vEZYGgF1B1ZaS7f35w+NpdDX2Unp
	f/ElyU26K/tOyOtBeLLhv7VbxMV4S/xMG+FcVulhOO1Crwahfpdetbbi4j8NsAeXAtuv9D
	TtMRPMhTEuuHOtV/fbSvHdHBJxbrGZs=
From: Usama Arif <usama.arif@linux.dev>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Juergen Gross <jgross@suse.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-kernel@vger.kernel.org,
	linux-mips@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v4 0/5] locking: contended_release tracepoint instrumentation
Date: Tue, 31 Mar 2026 03:27:03 -0700
Message-ID: <20260331102704.921355-1-usama.arif@linux.dev>
In-Reply-To: <cover.1774536681.git.d@ilvokhin.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D062C20009
X-Stat-Signature: 3z56zh4uiy7aa7rcb4mtyezbd78c5bx8
X-Rspam-User: 
X-HE-Tag: 1774952834-827477
X-HE-Meta: U2FsdGVkX180udRTDuea1t60oTM3NGb/7xpxJV3uQM32A3FzThqsYxMdgshbc0f2HIUbu2/mXVOp9wPTZLEq2OMEiH9yO/CTROOmnA/0gm2hzTBA/PXbcIAO6k4JTmYMODIwOOR+CXBKxEiQ4o6Xv39Z7qKLXuM3Sq/+HKsQ1gXTgvNYJIxPKTAfaWhCuhvZALnbqy3L0EagoA6B1cHDUcECfnyR5lUVHE8DAQkG4CRwPZr0Oi21Cj9i/IHJRAonnnGnGU/snuYrnGdqvNLoFqhMLKCf7UhIWPoGgV1jorPoejlftXmHhoYG26Xwlp0lLs89jYYQdcKxpsXKuIYyjIypvU5wZdQSS+yFprraKJKzKLgg6TZIMyoKFTA++s4oa1WTmSIIdRFP0zY+Up84E5vQU+6MdHN4qc/KBFlQ2RtD2S4JiE3cbjXyGxE8ySP7WpOjm54wHVOjRQWD5Dhxj6RSxaUzIVJrj/m6gbV5xckSCjHNEQ7LB6uc+e7+SsYc4FgcrkWBeTcRBkZPXi9JofRpxWgBmJmyl3ILu4dkeR52BpPT725rMdIUMJMLxpkaCcdYbh+ABDRZWvYxCa8DoLrNVbfDdBIfszp1B3T+vVfTr0MabPQPXaSDsn5VPSdgvWYBQcXZ4ovc1WGof3orrSCvB/9D2eNWv2aCGtWPK1HpoNDSB9Pj40h32MbynaO9KBfeQ4kagVjGzSHUrpNI0IxggsaYyBkSljV9ril8SOX6Lt8mUtQ/x1TwMrwKHNfSCyapPdqGXDxt676iMxPJg8tyORpPOebaDzeH7ut6r+zLoZImgpac9F62V97XI9c2RcK26U26XcRcpgv1oNeWn2LSXw0Ua3RYzVzrq9WAtGPv09Hx0QABV34pyf4rUKjCwp3h9Zt4bE6QYmCs/7HClhEeC3aGs4eqMb4Kdx/DFfGm1Fvth6haDgieL6mKbDq61046uH5UaROT4oLgf/e
 4letNYFo
 GRukSCeyDX/sPd7d/Bv/NnZg/siKXaIjhzm1sjC/NQWfaEoLs5QYIuHFBQa/neM734OvtSkhW9peLCL5FEmAZisfMkPEtewJVBJdhV1ogSFj92bQ6o+AYOqzp3kBkFiz0n0VnQFwCkKZY8YMHpOin6fYAQ23zEK+KXuz2cL3aJxB5phqXFhLB5uhmjbFoNLSl51IvL3/NxRuNaRSc8VOTevl1PJfaBoNPjZeq0W1iH4exsQ9ukfkBVWEu81QoOlig/Xbq1pFRsUIpiaSttYrco1h1WoPGxniteRuLb59QsF+QD6fGbTfNGBNxFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 15:09:59 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> The existing contention_begin/contention_end tracepoints fire on the
> waiter side. The lock holder's identity and stack can be captured at
> contention_begin time (e.g. perf lock contention --lock-owner), but
> this reflects the holder's state when a waiter arrives, not when the
> lock is actually released.
> 
> This series adds a contended_release tracepoint that fires on the
> holder side when a lock with waiters is released. This provides:
> 
> - Hold time estimation: when the holder's own acquisition was
>   contended, its contention_end (acquisition) and contended_release
>   can be correlated to measure how long the lock was held under
>   contention.
> 
> - The holder's stack at release time, which may differ from what perf lock
>   contention --lock-owner captures if the holder does significant work between
>   the waiter's arrival and the unlock.
> 
> Note: for reader/writer locks, the tracepoint fires for every reader
> releasing while a writer is waiting, not only for the last reader.
> 

Would it be better to reorder the patches? It would help with git
bisectability as well. Move the refractoring work in patch 4 and
5 (excluding adding the tracepoints ofcourse) earlier, and then add
all the tracepoints in the same commit at the end? It would help
in the future with git blame to see where all the tracepoints
were added as well.

