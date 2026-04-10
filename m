Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E8A8F459FC
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 18:37:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EE806B0089; Fri, 10 Apr 2026 14:37:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C60F6B008A; Fri, 10 Apr 2026 14:37:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0031C6B0092; Fri, 10 Apr 2026 14:37:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E51A66B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:37:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AFCFB59A80
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 18:37:07 +0000 (UTC)
X-FDA: 84643503294.16.71E1F0F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 08F9E180005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 18:37:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QMQvUPjg;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775846226; a=rsa-sha256;
	cv=none;
	b=hmYYE4gVhivKHQoWOmFizMEvINevK4A7G2OLYYXN7g7Nu7ygXn2GukYLFZJg0hXZ7vhA9T
	j6eZ2C06uhSsPKSyV2REU8yCaLu6kW5j4hhAB3ahuGRZLQDayWFPLKDNiDZqw/7UAygL7m
	XSWaX6Re0hZ+AD/r8kgT4563tQXtky8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QMQvUPjg;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775846226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SSPpBMP9eKgBD9juiYFLqiRIuyb4EcNmRRR1kqPy8+g=;
	b=n7VmSmaTt7RgwK8uKT0hrv87dsuEgEVZVaNgplqaio8HScaxR4oigr5Dr454b5cAVWRdt1
	F8ZYKaRb6UpjA57FlPFxH7fPWLxTtTDVj2QscTcORJAQlnNNEQw5wSaTYNsFWmzjv1n40A
	BSieZsFxXB4ZtzNnAusjrdcmYu8+ozo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7006C47E0;
	Fri, 10 Apr 2026 11:36:59 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D245E3F632;
	Fri, 10 Apr 2026 11:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775846225; bh=er8Lk2y7reXP4++X5Sc35l4FKj9mHmvIFq8jXXRDfFQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QMQvUPjgfeyLuB/485mMx/3GHF1ky2aQNxTM1JIHTQ5ql0H5z4anq3Y+ovhp6rg1/
	 CafKVxr6xm/rkQGOM2K4SrZBnmR3oTFtS2b/LojZ/SneD3d4ANbWFlM86a/4uEJTjm
	 thNXSFKO8POWl4qlbgcvzJVEcKvjrmJnlN1/u5Go=
Date: Fri, 10 Apr 2026 19:36:58 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>,
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Andrey Konovalov <andreyknvl@gmail.com>,
	Marco Elver <elver@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Peter Collingbourne <pcc@google.com>, Will Deacon <will@kernel.org>,
	Ryan.Roberts@arm.com, david.hildenbrand@arm.com
Subject: Re: [PATCH v2 2/3] kasan: skip HW tagging for all kernel thread
 stacks
Message-ID: <adlDSiuBeSduK0mj@arm.com>
References: <20260324132631.482520-1-usama.anjum@arm.com>
 <20260324132631.482520-3-usama.anjum@arm.com>
 <adlCN9sUcQdWbf_i@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adlCN9sUcQdWbf_i@arm.com>
X-Stat-Signature: rw3huikpujze5zati5wxs6kh5mgomkrm
X-Rspamd-Queue-Id: 08F9E180005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775846225-317317
X-HE-Meta: U2FsdGVkX1+CIMTmYoXIftXs++/26XWdCvzb3NhMbHtSwYottiXTPe7JToMfksRPTkuq831YvuJAJ66Sciq4W9IrhMcLE3ND84T1ZUcUVPj33c618qHj5yQ++GIVwgByaJCyiNi+4DE7O9TpL9+dvRkXy1I3gMnHm7jbEw9v7LBP4nVS5qJyUvuvNrOo1ase3HficnoqKM849tQnNNTqwkj1E6FpaW9DtQtLijwdfg9ZUHeazMPUs5N4j8pr16tPXMlQ/T+3Wr1P6gkoEKBdWGRYowVZg21gpubEDdwtHCsL99EhmXB5L94ztCvZXHzFaLD/NLRWILxJbN5kvomEIKuF/mVMGDfvv7/+/nFOA71aiNo+72xaxAh64KsKJUZ28vqthmQtiXNyzXIgKXzSi+ukKf8vXBLYNfnOUS9bXqonQjD1oOuX2TCSG5PN2H6WnJIAuuOIxwMx6jEBNzrBs5TFnthw5oNEkqfXPquqwQ2wgTS0k81QulDVXNLD/zzWmx+ypRMP3TVgC1lcTuzEc5voXgmrolYhME58jdnWx5TmWgxEZQ7Fjb3t0PZmF8wlmVLRGsikfPGLq3dyrub+lk7GXLkOmXYPgcPGL4Rx62zvUE9uLWU1IdzC4VCyRrpY0A2NTEo/+J2EbZQ1Gg/sv0W9OhzU5PNW4ozdICxrZ1ri+ydkISK7NIHLUXTUDuoiCd7cvCghADd8yKMpn+eWFfBr9B/Pyv/yATzpfNr8BHuJuVfKLRopUHpuJD3b07IIt+RxpCrQxHxxxSiTtwmhGIZdDGybQCKXXGOA6GBbvi4vF7yRVnGytxqnGZ2pe4sSSz1DQSn1RrT2W8lsb8EsYuNa4nmmwwDtQPkMk7EZC4OQwHuwkq4kFkeMZHauTJD2PjXkrBQkpOUdZt4SgTo5mDXidPrX9+De32ZoPrkoNvRyqvzDx5xkf0v8PtH+zJUpeRxUJ3TO2BlS2kvH7mS
 7hMRkz7b
 MWktqQ1v1Oq1YCLuxH6i5UnpI1b97VF3XTKjvxjG4H/b/EOBt/Z55PxdqOJlOkrVY95l55iORKoW1qseyjbdjmuVqIaAlG5rpvah/zhtt0IbOW5udliBr9u/NudixamkRY4Xlf1wdtIGMkPKJw6Vvq+uOZxfbS++gWnbtEHb2w7Wzjk9MRW4aGx6KvP/ip01uy4hMB6xy1FNnLQhC5vpVtKKmWzURnAlpau07tEwbfYeIvVHIr1MHEAIGGG3ztXoTLLu0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 07:32:23PM +0100, Catalin Marinas wrote:
> What the original approach might help with is use-after-realloc in case
> we had a tagged pointer in a past life of a page and it still works now.
> Oh well, that's I guess for other types of hardening to address like
> delayed reallocation.

Another thought (for a separate series) - we could try to map the stack
as Untagged (unless stack tagging is enabled; needs compiler
instrumentation) and enable canonical tag checking (newer addition to
MTE). This way, any stray tagged pointer won't work on the stack since
it needs a 0xf tag (canonical).

-- 
Catalin

