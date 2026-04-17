Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90E58F43680
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 09:11:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B78A76B00B6; Fri, 17 Apr 2026 05:11:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADBEE6B00B7; Fri, 17 Apr 2026 05:11:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A3BF6B00B8; Fri, 17 Apr 2026 05:11:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 875536B00B6
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 05:11:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1EB091A0BBC
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:11:26 +0000 (UTC)
X-FDA: 84667479372.19.C17035A
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4363540010
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:11:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=nLjA7rCB
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776417084; a=rsa-sha256;
	cv=none;
	b=gDpX8DgGVyt4XgB2sDXoPln2P20ym+XymP9a7Qb6TNfEk8vMQPn7ot+SHvDYI8XnSSkrEv
	C7JQAr8AW7hHMzOs7Oy419/pnmBvby1UKIHecNyWd4TOWRA5DTJUTSzdDozBMOoGoUcVAl
	UAYq5CDJ/QlaY+IZBfuxQtA07bAFr7M=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=nLjA7rCB;
	dmarc=none;
	spf=none (imf11.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776417084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OtUmsssVat6H5uUWOGAgIMHCFf2EzwnMzi7lYMo5hwg=;
	b=pum1yWQY+Neay/1cWsS1VcPUu0L4jr1EVZNXHAqRBdcrmIMSf4c252JvRZwerEXCP0EROd
	FuFcG565GcXN7u3UdcWbMl62+A39+6ifiMhJeEu4cPArz7stXKEXjUshX1nqx+fYvFvr5e
	VKkcNebSgyDTULUtymLl4j75Hj3VRd8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=OtUmsssVat6H5uUWOGAgIMHCFf2EzwnMzi7lYMo5hwg=; b=nLjA7rCB3i9XrrthI/d/2fWiqZ
	ByYEGdrrSLzqHMI+J9GEf1NxH2Q2a+W2J64WXkJNaYYLfAs9LnwitL/BtKi6FOxWxQ974SbiGUEgb
	uWoMSAteewAwyGp5kzWuofHPxyUsk2Nff7u5DxzZsUyWkjuF3oYO9s8xK2RlDtdbPiijnfSyEnaqb
	QAeYC8X//4jAS7helEgl1srQURzS3ArVSDTnjHF/BVNuP7wuDdqc+OnMx2sMvEOsfj4jjejBP1GPM
	Jy2KbBW9NWcUPSWU2gwVkFiX2GUfLLHuerk3DjalmVCl+keRXqRyv3VGuOb3gDxP+BPGofUE+A6Cd
	yAKIc4ng==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wDfE5-00FH6o-1a;
	Fri, 17 Apr 2026 09:11:01 +0000
Date: Fri, 17 Apr 2026 02:10:51 -0700
From: Breno Leitao <leitao@debian.org>
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v4 0/3] mm/memory-failure: add panic option for
 unrecoverable pages
Message-ID: <aeHy3-vQTQYJlGw5@gmail.com>
References: <20260415-ecc_panic-v4-0-2d0277f8f601@debian.org>
 <CACw3F51PC0iB6mfbiceQ_Kh242FN8zdXOfTyE5Pa_5+gjTPPGg@mail.gmail.com>
 <aeD6hpM3t0RZm5mW@gmail.com>
 <CACw3F50WYH8Vmd9EXx9+3yM=FU5-1WBkNffkGucC+wSjL+=wFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACw3F50WYH8Vmd9EXx9+3yM=FU5-1WBkNffkGucC+wSjL+=wFQ@mail.gmail.com>
X-Debian-User: leitao
X-Rspamd-Queue-Id: 4363540010
X-Rspamd-Server: rspam12
X-Stat-Signature: rz8hx8rhuhgef3j6k77qeqri7cs1mr88
X-Rspam-User: 
X-HE-Tag: 1776417084-249272
X-HE-Meta: U2FsdGVkX1+pWPjMOJIg0dnBhTcA7NVinxiYiUbVNqMNAEbxqFyBZA0YaRM52HDTXomsDzXyn03dlBZg7THNaKgMAwZpsCON3GY4QfdJDVAsOOXjM4VcFGOLSlNQU+Ac7l5uVMNhbCvQHcbkuFEHSwxaxgb38awvl8CUUSM8Hfrm2IBfbIPKe82078HbMwvmlTseooc/PH7YVBW72n4oT8qfqotbVLlzVvqenvW3fZ1axq1DBmtmsiE1zmGfdXsKYCix5Bo/He6KcoIiaUTfaAqE31u1RIJ8RJAxmBKHmT3i+YWxdA9C0Xus0QHTKi8uZlfRPXamAbxYKTu0dceW1JMapzqdxwSDpOzTJaKt4zksMzcEllQOwkhK5bM/HBBsGqMQsICTyDpI3jF5Xd0eYdCwdA2ui0x+Ll1g89qagRa03ajXPk1w84ak7XKRsALhKm+Zw3V1AZrHjJ9WUROIm6i9yGYidJoTXiCBNjYjmGXZ4i28BT3YFiivK+nbvbuPXSzxS+Eim/xD4+d6fRUK0ZuN1Qz/ewh3Ui+MjoBiZlnOJEwwZd3y4TQFMB+H/50YzzHD7Gu2bSNcKFcABrXi0zeHSKQweQwdM5XdWIKL6pxEk5spdSayrkgA7Bt3waj0R0a7uxBYWsB8I01OaUFVjEYD1yPSm0pN3l1jp7k8dHFwu1lXnSLCH5MdTtc+CWd+Un9o+I5re9fXFihbgFWQohRXNhxz9Cq/hLE6YQUZrCUFW/P3KH4Jau4JZEAzjgNZLxGfU4cqnTieYIMAnwEde3aH7j4H3lAjFHn0wdy6fJfW7PzX1SqWTry3afKlFIki7BjR5bZRCRrSCMeuPtIOuNQXn2C+emvAtF93y3BY/S0rPk4YgYmBtjhJvNj76puKOk7eXURLEE1WP1eHoFiJFt/gO1LblJV/l+klaVnhxKPIHMJ2Kt9z4oq4hKlflErc53bEjhdX/kPtw0VNjrJ
 WaFanDdN
 Dm6hmjbHWXVNE4vlyINSLLSrV+Tr/jNmyG9qNy/5VrwOd2ZG+h3Nn+vkzcfo2KJ+45rBTcJ9BymHphpURgKbQPwLF2C1lyJCKxxW++rwgc2ppKTyhRpBC1Y2+miN0Ou9LIQvsX4sgENSc0X9eokMDOtbKSzoyE1rMQgQi+W1LW6BWP5uRBsRlQ32R9mICXuUeYkQIK4uvSwamOI1HNEFBrbliNb37uMZp4OUn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 09:26:08AM -0700, Jiaqi Yan wrote:

> So we will always get the same stack trace below, right?
> 
>           panic+0xb4/0xc0
>           action_result+0x278/0x340
>           memory_failure+0x152b/0x1c80
> 
> IIUC, this stack trace itself doesn't provide any useful information
> about the memory error, right? What exactly can we use from the stack
> trace? It is just a side-effect that we failed immediately.

We can use it to correlate problems across a fleet of machines. Let me
share how crash dump analysis works in large datacenters.

There are thousands of crashes a day (to stay on the low ballpark), and
different services try to correlate and categorize them into a few
buckets, something like:

	1. New crash — needs investigation
	2. Known issue — fix is being rolled out
	3. Hardware problem — do not spend engineering time on it

When a machine crashes at a random code path like d_lookup() 67 seconds
after the memory error, the automated triage classifies it as a kernel
bug in VFS/dcache and assigns it to the filesystem team for
investigation. Engineers spend time chasing a bug that doesn't exist in
software — it's a hardware problem.

With the immediate panic at memory_failure(), the stack trace is always
recognizable and can be automatically classified as category 3 (hardware
problem). The static stack trace is the feature, not a limitation: it
gives triage automation a stable signature to match on.

The value isn't in what the stack trace and the panic() tells a human reading
one crash — it's in what it tells automated systems processing thousands of
them.

> You can still correlate failure with "Memory failure: 0x1: unhandlable
> page" and keep running until the actual fatal poison consumption takes
> down the system. Drawback is that these will be cascading events that
> can be "noisy". What I see is the choice between failing fast versus
> failing safe.

Correlating the "unhandlable page" log with a later crash is
theoretically possible but breaks down in practice at scale:

- The crash may happen seconds, minutes, or hours later — or never, if
the page isn't accessed again before a reboot.

- The crash happens on a different CPU, different task, different context

— there's no breadcrumb linking it back to the memory error.

- Automated triage systems work on stack traces and panic strings, not
by correlating dmesg lines across time with later crashes.

- The later crash looks completely different depending on the
architecture. On arm64, you get a "synchronous external abort". On
x86, it's a machine check exception. On some platforms, it might be a
generic page fault or a BUG_ON in a subsystem that found inconsistent
data. There is no single signature to match — every architecture and
every consumption path produces a different crash, making automated
correlation essentially impossible.

- Worse, the crash may never happen at all. If the corrupted memory is
read but the corruption doesn't trigger a fault — say, a flipped bit
in a permission field, a size, a pointer that still maps to valid
memory, or a data buffer — the result is silent data corruption with
no crash to correlate against. The system continues operating on wrong
data with no indication anything went wrong.

Also, I wouldn't call continuing with known-corrupted kernel memory
"failing safe" — it's the opposite. The kernel has no mechanism to
fence off a poisoned slab page or page table from future access.
Continuing is failing unsafely with a delayed, unpredictable
consequence.


> > Isn't the clean approach way better than the random one?
> 
> I don't fully agree. In the past upstream has enhanced many kernel mm
> services (e.g. khugepaged, page migration, dump_user_range()) to
> recover from memory error in order to improve system availability,
> given these service or tools can fail safe. Seeing many crashes
> pointing to a certain in-kernel service at consumption time helped us
> decide what services we should enhance, and which service we should
> prioritize. Of course not all kernel code can be recovered from memory
> error, but that doesn't mean knowing what kernel code often caused
> crash isn't useful.


That's a fair point — consumption-time crashes have historically been
useful for identifying which kernel services to harden. But I'd argue
this patch doesn't prevent that analysis, it complements it.

The sysctl defaults to off. Operators who want to observe where poison
is consumed — to prioritize which services to enhance — can leave it
disabled and get exactly the behavior they have today.

But for operators running large fleets where the priority is fast
diagnosis and machine replacement rather than kernel hardening research,
the immediate panic is what they need. They already know the memory is
bad, they don't need the kernel to keep running to find out which
subsystem hits it first.

Also, the services you mention — khugepaged, page migration,
dump_user_range() — were enhanced to handle errors in user pages,
where recovery is possible (kill the process, fail the migration). The
pages this patch panics on — reserved pages, unknown page types — are
kernel memory where _no_ recovery mechanism exists or is likely to exist.
There's no service to enhance for those; the only options are crash now
or crash later, given a crucial memory page got lost. 

> Anyway, I only have a second opinion on the usefulness of a static
> stack trace. This fail-fast option is good to have. Thanks!

Thanks for the review! Just to make sure I understand your position correctly —
are you saying you'd like changes to the patch, or is this more of a general
observation about the tradeoff?

--breno

