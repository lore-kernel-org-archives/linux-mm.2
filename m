Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72CF5CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 23:42:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8DBD8E0008; Mon, 15 Sep 2025 19:42:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C65468E0001; Mon, 15 Sep 2025 19:42:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7B1F8E0008; Mon, 15 Sep 2025 19:42:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7BA88E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:42:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 63A631A0709
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:42:52 +0000 (UTC)
X-FDA: 83893112184.19.8AD476B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id C3AA8140006
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:42:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AnCtHntQ;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757979770; a=rsa-sha256;
	cv=none;
	b=cSBkvGrcamVd5+GMdyXL8n/GcJgZ7zIr3UaVsZgmBURGhLzllokZMESMXfMem9QUpkvJjH
	FENVU9lh7jHDDGihe2vhiaBIS94FRAdKRMVm0YHGR8m7iejvQCn2rszGh7/S8NLJHph93J
	lwoi+x/1aoqwTq98OlMDrfaQ5lDVeFE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AnCtHntQ;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757979770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uc0dRANdDrubGyJ2/j8ing0hrexKxb2x52oUX8quuNI=;
	b=uYB/JVhCPfn5Lq+dqUimacCZHwU9bm4P6HvEqqynaV+KZaqz6JObSg1MtAiCzXcy4//BP4
	nVtEqiCzn+9wAxfQ+AOSYMpN+fG8rPuecKBBcOQ5fh4OnR2rKpnCs5LWGgxUHLx1h2k/1P
	3Fqwfpq6wDq0KdXJLxWk+G4rSPLSz7E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D04C660054;
	Mon, 15 Sep 2025 23:42:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7EDBC4CEF1;
	Mon, 15 Sep 2025 23:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757979769;
	bh=jZaEOziBglpDbUCJBMp8aBXcUFCv9ylBZH717KvszyM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AnCtHntQV2wzjjVOmP7rYmJTYXrxHdpQNyC9lYZE3PU+JqtgKPEoQINB57cW+RvAU
	 N6E1+flXLdPkwdQGvd/3aobMeQFKOVIOXF4PA41hCKK4Dgw/SHpKYvv9l8NbY5c2zx
	 cF3Nj4j1aHnWP8rfbcVJEr79OfpmS7rIrYZNvvTU=
Date: Mon, 15 Sep 2025 16:42:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Donet Tom <donettom@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>, Ritesh Harjani
 <ritesh.list@gmail.com>, Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou
 <chengming.zhou@linux.dev>, Wei Yang <richard.weiyang@gmail.com>, Aboorva
 Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Giorgi Tchankvetadze
 <giorgitchankvetadze1997@gmail.com>, stable@vger.kernel.org, Joe Perches
 <joe@perches.com>
Subject: Re: [PATCH v2 1/3] mm/ksm: Fix incorrect KSM counter handling in
 mm_struct during fork
Message-Id: <20250915164248.788601c4dc614913081ec7d7@linux-foundation.org>
In-Reply-To: <4044e7623953d9f4c240d0308cf0b2fe769ee553.1757946863.git.donettom@linux.ibm.com>
References: <cover.1757946863.git.donettom@linux.ibm.com>
	<4044e7623953d9f4c240d0308cf0b2fe769ee553.1757946863.git.donettom@linux.ibm.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C3AA8140006
X-Stat-Signature: uq5yi51476a94doqxtenjpe5r8owxdzo
X-Rspam-User: 
X-HE-Tag: 1757979770-543060
X-HE-Meta: U2FsdGVkX19EaBYha2oDoleyV2QMP1+DTDUG0a5WdKcIbIhQ4RN3yWPYHAOtG8t1/HHIfa86YXXQj7rbNi8+9SFekVfQRZqY3L1WyE5JA5kTVKGgVgNKvHwUAczqetUtNOAcaTX3A2FD54PD3pxOsHQ5WvxyufdE/T3J1TzPigwVtse5uOLr/oZNVfM7vam3AsDy99SmB0441WnWLyPU/l9gWoacT7v9QsgghgXKdJstXb7lMBJNoquNjBwPUCAOsJaBG/USQEJTTdb+bf3b3oswKaoY0wEKGqaD7fyGvL3ZZXUy5pxbWtaXL/+0TIHqnvXcn6zlEAKjV9z7GR1tuV9C7wacCIhx3raqYDmNhqaSLzbagbw6jmrfYQwud67aKYSjuSc2YWgbBecpQEWxKFZ3Rf2f6MsQx5doAE6MDskc7MOgXyDpppFL7OBX01LY5Trz5AdEWHxXsspU0OvEGAgZT0geifsQxcuFkBBNC6713Ecs+Y66j8aLOryrs3IAJzJ/lZqcJqf6O7LKztDLfazMQRv5Tw+9nVe4ev8T+dCoZN+Q3/Sj7b3iAvibgqsskWGtRbqqih8drEpKBsRF/Qv5vLgl8j7rfNFt6IzT0nKyQSg2S1NJehj62Y69Jt24Wo4CtV54oubjdi+IbZBpn7uKLJdcfK/y3A9NLTjil7SK7SZwKFFFTsJoQ+/bj0haUUYk88t1CXv5QLGfBvtsIiwEoxjHyfZNpeatJo3z2KkvfRFLCLCmAcBvQ/XR/KzEMh2VgYuz1+IR7CqnfcyX42oNGQ/nUkfl0okjv/6ijyuhWpNjhLUdCtk51t1Iq0XfI1DNPKnm5vClLpJjgsnybEGGtX/bGNZoAUC4nE2MiHbu0Jl+Lk5oolrHHfWhCORFzKYY/hSaKQkpw//BhyIZUUJfXI0K3MA3Y9Q2oDFwYXSMBSRpjZDFMfeaP53/arSVkLGNYty6LTW+dWctgix
 FjRlpaTR
 mGyRHTohUNjv4dCfFVlQYdOnk1auVFYyGd4EbN1jIRbK/rAgScsbhGVwv8neDdJ3iW6jdxdy/WMOGXNe+fSHcZOmHcOhNjDS7h1Gh90O3sdgmwW/Y52GhX9mgEc6mhtw6r85NeqqZMUDKG/JIWIFzpY9ZoZOvnVcNRivZKhEP8l/hvF2FBn+t+X+TxRwLO+DWEEf5Y8uwxjN6G68C471rQK0VzvlQkNHM4OJV7WI7j7oNmAhZz2zEz+EgY4wQGC6RCSGTy11H9UYixfTa0dxwFWe+bCbu+8EYbkVurYI7dh3ROeJElIDA3XROsLbKcLhToHFbicrSyc03nOEQTHVf7BYcDD/ypsPF4z6s+MnJiP7ICWF9oem3sMGHI08Bf9A5JIeh2QmxW2swmXbdxJqktw03ZXOM2/Jq0B53
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Sep 2025 20:33:04 +0530 Donet Tom <donettom@linux.ibm.com> wrote:

> Currently, the KSM-related counters in `mm_struct`, such as
> `ksm_merging_pages`, `ksm_rmap_items`, and `ksm_zero_pages`, are
> inherited by the child process during fork. This results in inconsistent
> accounting.
> 
> When a process uses KSM, identical pages are merged and an rmap item is
> created for each merged page. The `ksm_merging_pages` and
> `ksm_rmap_items` counters are updated accordingly. However, after a
> fork, these counters are copied to the child while the corresponding
> rmap items are not. As a result, when the child later triggers an
> unmerge, there are no rmap items present in the child, so the counters
> remain stale, leading to incorrect accounting.
> 
> A similar issue exists with `ksm_zero_pages`, which maintains both a
> global counter and a per-process counter. During fork, the per-process
> counter is inherited by the child, but the global counter is not
> incremented. Since the child also references zero pages, the global
> counter should be updated as well. Otherwise, during zero-page unmerge,
> both the global and per-process counters are decremented, causing the
> global counter to become inconsistent.
> 
> To fix this, ksm_merging_pages and ksm_rmap_items are reset to 0
> during fork, and the global ksm_zero_pages counter is updated with the
> per-process ksm_zero_pages value inherited by the child. This ensures
> that KSM statistics remain accurate and reflect the activity of each
> process correctly.
> 
> Fixes: 7609385337a4 ("ksm: count ksm merging pages for each process")

Linux-v5.19

> Fixes: cb4df4cae4f2 ("ksm: count allocated ksm rmap_items for each process")

Linux-v6.1

> Fixes: e2942062e01d ("ksm: count all zero pages placed by KSM")

Linux-v6.10

> cc: stable@vger.kernel.org # v6.6

So how was Linux-v6.6 arrived at?

I think the most important use for Fixes: is to tell the -stable
maintainers which kernel version(s) we believe should receive the
patch.  So listing multiple Fixes: targets just causes confusion.

Maybe the -stable maintainers parse the "# v6.6" thing, I don't know. 
But providing them with a single Fixes: recommendation is a good thing
either way.

So can you please revisit this and suggest a single Fixes: target which
clarifies your reccomendation?

Thanks.

(Cc Joe.  Should checkpatch say something about this)?

