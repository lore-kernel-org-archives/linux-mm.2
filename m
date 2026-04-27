Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95FBAFF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 13:58:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C62136B008C; Mon, 27 Apr 2026 09:58:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C12376B0092; Mon, 27 Apr 2026 09:58:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B28036B0093; Mon, 27 Apr 2026 09:58:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A28AA6B008C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:58:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 031BDC0D9C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:58:34 +0000 (UTC)
X-FDA: 84704490990.06.59172D7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 99F38C0014
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:58:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CtctlwmF;
	spf=pass (imf10.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777298313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7bJlAzc8fYBDj0I1ZQ8/R9ClLOZN4MjEen4J7YfNeeU=;
	b=rratixNp8RXxsoYzgVCiHnTCGQyOqaaN8bmdkIPLBsKFw5DEa+55Nn1L3rWc9BqZE7BGBc
	rIDJdTEkHrLfolCueMPwsCaifvg9keMxsSvBakUHxDz3WpAWwN6nn6yDiCq1GmqQhrg6ZH
	prolfjhVO8W6VKxQp6yXP8zS99ndOu0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CtctlwmF;
	spf=pass (imf10.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777298313; a=rsa-sha256;
	cv=none;
	b=p8NhHWb0MCzaWpNePmAAEiCiRJdT4ADbaUwsb9Fg7ykXjfxCok7iQVn3NR3SdaNtUQFRbs
	LfEaPoqxTW5LLHCmtxFSC3QGEDBC8ErOK3ge9I4/29VYrOBxvK81ck2cghqH1BrGCUsWXP
	wQ+xinsBjOG9sZZuIonkYxeEs+i+nxk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B94611FC7;
	Mon, 27 Apr 2026 06:58:25 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2AF733FB90;
	Mon, 27 Apr 2026 06:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777298311; bh=orleSLSlf3l9j3pRziC3s+6HLkjk4eXeS1br3lRPT50=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CtctlwmFIBjxPKtPWl8Sl4V4HzD7XqPAdApbI9jcGLQ64wDTOoBdysqmJERU9+vr0
	 S7cRKsVgtvnrVDijn23uqGaOc7LvoSDQ91+41Pj5ioccOn8sNoWx6SvjN2dKRFFXai
	 ODjV4r0otH1XiS0v4EOuVeZErBlC6u5Nfqnahbt8=
Date: Mon, 27 Apr 2026 14:58:22 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 1/2] mm/kmemleak: dedupe verbose scan output by
 allocation backtrace
Message-ID: <ae9rfnaPp10bNfFr@arm.com>
References: <20260424-kmemleak_dedup-v2-0-8bea649b2a92@debian.org>
 <20260424-kmemleak_dedup-v2-1-8bea649b2a92@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424-kmemleak_dedup-v2-1-8bea649b2a92@debian.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 99F38C0014
X-Rspam-User: 
X-Stat-Signature: 9nmuseaq3nbm54ogzrrj9cdtzoxwyh8s
X-HE-Tag: 1777298312-138188
X-HE-Meta: U2FsdGVkX1+puaW5GZMEEzIZR+bnWxzJv7inH58kWoDIk1+9Z4hKJ76Wex3Sk4P49bWNbSnnLrI5P8ltJd/TngRwJbAda2W6xeq17OlrVa2h+Q5AqQ8j++1WNOnZ4DEPavUbc2eZrfaAD0YG/lb6+l96zuqSrgb9MdDXyGPKjSGp/9TWSpS+si49jOVfxVs8hDiGoXEKqya1yZCRGUDSWfgUhAnhTQchpt4TFZghLsZg5RLlqFVor+msNEAP81NQGhgMr6fSY2U1VuFy/xSdGJtDK3YOeAjmJiAJnUzKG4m2Cr8wQWXjXCcQcRc8iaiN4JHFhyEsQDtUliFh+zcvHLYJCg7Rk94/VnTPoJYop93LlIQlEZLx0NKUuO0duRJxaiBpp4zO2GL0wCzVLSBrzbubxUxL0o5Vcyz68J5UqArMZNLLR2O5Q5PYRcg9UwnIsUUNCYd3AKr+NzXk5bUKmRho4JPXPA1DOXwbHGqSRahd6zYO1/QNgVpvVaZk8sLACwkZNZqjtOxgAtDiT7L+Vv/FBsFrD2cn5jMb1OGHWB2Q3UWomEJwqREDd3KhYQLW+wpy1OD4HTDbzbyARhF3QnWmGIJfKsZLUvFj2pMNVYDVa6kK2523lWvbuz5hhwflXZmIDGNd117jVAQLFb9q18yhN+vttNhcPfns+xITB6y3AyLalAMSqGPo/h+jQNr1sPmAKGA9AJYf+v71dUUb8zNbp7qQamfJ+8f9F0otIGyyRI+pF70k9cDnwIJJ8gY9bV5ExoXM48yQWClaIu1etCr2YSoQtJOxPm3srJLF63iQPiWAql7IJ3RcWrp6WqR196b5CaWFZGiJhyMicMqHtqsOL2c/8PGZnVCjIug5GYRV5efhl2NJCWvvv1ywamNeMkdxo+XnsYB76HwiVAhCbYbu/2to++8FpSr7Bw9Px0OqvmyI6uRGe8+ZVa/PJ+xlMp6chI1fAmsGQbd5wAo
 +qaSLQHT
 InPfoW2fPqklWukaaj17mstW6ssWjL/cv8THjY2DwnGN4Zd61G1Y8SgFrHBm+ipmI3PKc00dkcUdmz3LRu8/kd8/9YSeHmjlMooC0B6B/4rIuBTjwfoHaBWcm0BlsclwwKBHRAfm48zUjz47yy2D/bGrXr0TdFC3LFG34UcCrtztXgfXX2PGDeM93WdMTeLedyOw57EhFEzJwLwa6NlRD0wqCXlwYQnzmgrZ/PnRGgq9USYSRuIy0VMQvtKdoqJGHKeDwKG+f06Wbidn/JtRmzbvjd5fUszvmN6xkpxrkJ7lzvfmbpJEMbAHkhs+LExvMAvWs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 08:03:36AM -0700, Breno Leitao wrote:
> In kmemleak's verbose mode, every unreferenced object found during a
> scan is logged with its full header, hex dump and 16-frame backtrace.
> Workloads that leak many objects from a single allocation site flood
> dmesg with byte-for-byte identical backtraces, drowning out distinct
> leaks and other kernel messages.
> 
> Dedupe within each scan using stackdepot's trace_handle as the key: for
> every leaked object with a recorded stack trace, look up the
> representative kmemleak_object in a per-scan xarray keyed by
> trace_handle. The first sighting stores the object pointer (with a
> get_object() reference) and sets object->dup_count to 1; later
> sightings just bump dup_count on the representative. After the scan,
> walk the xarray once and emit each unique backtrace, followed by a
> single summary line when more than one object shares it.
> 
> Leaks whose trace_handle is 0 (early-boot allocations tracked before
> kmemleak_init() set up object_cache, or stack_depot_save() failures
> under memory pressure) cannot be deduped, so they are still printed
> inline via the same locked OBJECT_ALLOCATED-checked helper. The
> contents of /sys/kernel/debug/kmemleak are unchanged - only the
> verbose console output is collapsed.
> 
> Safety notes:
> 
>  - The xarray store happens outside object->lock: object->lock is a
>    raw spinlock, while xa_store() may grab xa_node slab locks at a
>    higher wait-context level which lockdep flags as invalid.
>    trace_handle is captured under object->lock (which serialises with
>    kmemleak_update_trace()'s writer), so it is safe to use after
>    dropping the lock.
> 
>  - get_object() pins the kmemleak_object metadata across
>    rcu_read_unlock(), but the underlying tracked allocation can still
>    be freed concurrently. The deferred print path therefore re-acquires
>    object->lock and re-checks OBJECT_ALLOCATED via print_leak_locked()
>    before touching object->pointer; __delete_object() clears that flag
>    under the same lock before the user memory goes away. The same
>    helper is used by the trace_handle == 0 and xa_store() failure
>    fallbacks, so every printer in the new path has identical safety
>    guarantees.
> 
>  - If get_object() fails after we set OBJECT_REPORTED, the object is
>    already being torn down (use_count hit zero); the leak count is
>    still accurate but the verbose line is dropped, which is correct
>    - the memory was freed concurrently and is no longer a leak.
> 
>  - If xa_store() fails to allocate an xa_node under memory pressure,
>    we fall back to printing inline via print_leak_locked() instead of
>    silently dropping the leak.
> 
>  - The hex dump is skipped for coalesced entries (dup_count > 1):
>    bytes would differ across objects sharing a backtrace anyway, and
>    skipping it removes the only remaining read of object->pointer's
>    contents in the deferred path. The representative's reported size
>    may also differ from the coalesced objects' sizes; the printed
>    trace_handle reflects the representative's current value rather
>    than the value used as the dedup key, which is normally - but not
>    strictly - identical.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

