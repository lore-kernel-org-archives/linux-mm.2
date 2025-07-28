Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA49BC83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 20:58:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48C086B008A; Mon, 28 Jul 2025 16:58:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 463E06B008C; Mon, 28 Jul 2025 16:58:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A0C16B0092; Mon, 28 Jul 2025 16:58:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 29D336B008A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 16:58:57 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D67761A03DE
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 20:58:56 +0000 (UTC)
X-FDA: 83714887872.22.5280192
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf05.hostedemail.com (Postfix) with ESMTP id 19395100002
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 20:58:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XB8Hyc0j;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753736335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I67MA1NrgQeYuW+a0AyBY4rFKkRM8bpDcNX2nSCHJXE=;
	b=W/+QtVFrkxwV70+7Pqb5RL5JVemo110QsF3wXE5gIM0q+AYXHkdn7XcGBA3btkdUPzdBD6
	KQUNLQAP6LG7Xu5d2Pd1Ch2nPsTY0wh3Px8tmVzVLER3bguFFcAjBwZ8dvSsiYbA6D0Znx
	yNjB3mZzs62yr5MEmaw2RcHE9Z87UZw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XB8Hyc0j;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753736335; a=rsa-sha256;
	cv=none;
	b=S5aVipZ8cWl7IOOt7ugTA1THnWeyoGyffZvMamvgBh61ln9hhOwbQZApMqJIsqKKuIqBJ3
	uGiz7wqW/TpBWRnRwSvmCvR4Y1+z//g+UCwb3veDwsYXoPP6WTcG7SeQDbFzrZCBzYg+Us
	54HrTNb3XXXJ7Drwtag1EL/Scc3YHVo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 188475C48DC;
	Mon, 28 Jul 2025 20:58:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F5EC4CEE7;
	Mon, 28 Jul 2025 20:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753736333;
	bh=PLzM4UumP/OoUpTWArSfsoC66j4BCJQV+EkLiWusGss=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XB8Hyc0josg3kRfBL/TAuWzvNjY4I1quwAvLgSXlghfiz0tZuhh551krkBpbBuI+s
	 dQuM50o4a0+3LX4tHYGVjw3wdt8yw1BprjUVKWYIw8kf9+kHN7KunShyFnoFOwc5oP
	 7ahl52fn6VDbtxAc+yE1YmQUP6NW1oORT1YDStek=
Date: Mon, 28 Jul 2025 13:58:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: jannh@google.com, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 vbabka@suse.cz, pfalcato@suse.de, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] mm: fix a UAF when vma->mm is freed after
 vma->vm_refcnt got dropped
Message-Id: <20250728135852.1441a6fd58f7171ac2a3dedd@linux-foundation.org>
In-Reply-To: <20250728175355.2282375-1-surenb@google.com>
References: <20250728175355.2282375-1-surenb@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3m1wmcy8x7qmgcfrqykuj6998ojoiai4
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 19395100002
X-Rspam-User: 
X-HE-Tag: 1753736334-309495
X-HE-Meta: U2FsdGVkX1/9Jha93r53W0o0NrYAirEwjx4fKjvICN6EZaLOMGxGAEdp9fOw6URfdVibBeUO+1UO2PV3x8UwYVdSVUPeHv9Ma99McJNOZ/wWovgaEm1vCCfXjN/bB7CHqRkLnkrMwjkZrdTz1uSoUFXkfued/FwZyW+8sZ/LX0C1eKh/m39BTGlCwi1fF1dpCFEZ4jVKR9e5QHY6Ec+C/J4Va5aAW1/E/ZzJdLdA3wwxMiq/ptuCDsdxp/xGWe6Fc9BVgUUgAcQb7O8csL0ZQ4SmGi+cFiPR4rG5+MJsehunaGDFyaNWOeHwmo3FHkF4Ats7YVxcSezf0C3Ql1H3t+W642GcgzBQrEzQoQ6ug/fEQdydGQD4EFF9QH3WpSYzjX3cHJ9iTX7+H4DBr59J5mW+0v4ux9QjxcK0Rmzn90jbVxi0eLRblZYtZN4DiugYuZDOkQxM+pFitq99ZkZYtqrpZQhAqg56o8xzRnT4clYhJZiOj+ZUe0QnoSlDkvfYa80l7sVNKon/qxUmR0cWyeyZtleZQaxKWlvvaAKK27kvgbOFWxbsMiX33+vL8VLO/SPM72jWY+VMLj80Ino5Hj2koD9KQsBmQy8Mdfu6y0j7z5UiXwXgngjpMd9op/9uX7PY4qeFKb4Vf4n6JD5JXSMUJk+5bgKTfzLvnpTSCF6BXM82wGqGkrbL3yTDv7LUQI08Rkrqr1phEQqcVFvYVU/mqsG+p1TtjWoiL6321mjDhQPto+ETlu61Kn03E0U+JvffHJEFCVCTK3Bsmr2CZV/BxR9IFrcQdsoKw78jYW0geu7flla5UNmj6LRbuI5vPggow/1J78Z9yKujukcgEBvnqfKbqMw+4h6JF2xCGSlMlXmyyoGlLKKOomnjLHHkqG5FA3ZcKvEndKcjB3i0u7lkZsjYrBFNzJA0RsUZSwPfJ7V/bJbkgbTNr/DdBD6fk7MMVc+bP6XJlMcevIC
 vultxiwA
 KnyrUDBt4Twv8yua1m/RhCr8x8fr2g/kAVdYSpFLPASTbsaLeXEQPay9Qx9a9S0glKQBMtpMppBslX4XP1hhjQ+eDBpncFxLMDvQxMxgeq/xJUj/JY49sVKrO5Pj4WxT2O6gLH9sR25HREV3//EW9WCJMlOg6mfXQlQuvzVopTiqf7zrNXmN9CDSEXLJhvLIxzVYu1v0Vc0B+m5YC5F85LenWWivpMI0kuUczBdnThmV42ke+kiY+kG8BIuzeO12QOMWl0r2n4hCTMCrK0681SZrgV+Qk4vN1pYn09NTw8x1lc+RnEDDoNjliLziqAPJ9vkA4g550W4pCRX8x/Wu84Kw9QQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 28 Jul 2025 10:53:55 -0700 Suren Baghdasaryan <surenb@google.com> wrote:

> By inducing delays in the right places, Jann Horn created a reproducer
> for a hard to hit UAF issue that became possible after VMAs were allowed
> to be recycled by adding SLAB_TYPESAFE_BY_RCU to their cache.
> 
> Race description is borrowed from Jann's discovery report:
> lock_vma_under_rcu() looks up a VMA locklessly with mas_walk() under
> rcu_read_lock(). At that point, the VMA may be concurrently freed, and
> it can be recycled by another process. vma_start_read() then
> increments the vma->vm_refcnt (if it is in an acceptable range), and
> if this succeeds, vma_start_read() can return a recycled VMA.
> 
> In this scenario where the VMA has been recycled, lock_vma_under_rcu()
> will then detect the mismatching ->vm_mm pointer and drop the VMA
> through vma_end_read(), which calls vma_refcount_put().
> vma_refcount_put() drops the refcount and then calls rcuwait_wake_up()
> using a copy of vma->vm_mm. This is wrong: It implicitly assumes that
> the caller is keeping the VMA's mm alive, but in this scenario the caller
> has no relation to the VMA's mm, so the rcuwait_wake_up() can cause UAF.
> 
> The diagram depicting the race:
> T1         T2         T3
> ==         ==         ==
> lock_vma_under_rcu
>   mas_walk
>           <VMA gets removed from mm>
>                       mmap
>                         <the same VMA is reallocated>
>   vma_start_read
>     __refcount_inc_not_zero_limited_acquire
>                       munmap
>                         __vma_enter_locked
>                           refcount_add_not_zero
>   vma_end_read
>     vma_refcount_put
>       __refcount_dec_and_test
>                           rcuwait_wait_event
>                             <finish operation>
>       rcuwait_wake_up [UAF]
> 
> Note that rcuwait_wait_event() in T3 does not block because refcount
> was already dropped by T1. At this point T3 can exit and free the mm
> causing UAF in T1.
> To avoid this we move vma->vm_mm verification into vma_start_read() and
> grab vma->vm_mm to stabilize it before vma_refcount_put() operation.

Thanks, I'll add this to mm-unstable with a plan to include it in the
second batch of MM-updates->Linus next week.

> Cc: <stable@vger.kernel.org>

The patch won't apply to 6.15 so I expect the -stable maintainers will
be asking you for a backportable version.


