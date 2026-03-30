Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 027F31061B28
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 23:42:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A8496B0092; Mon, 30 Mar 2026 19:42:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07FA86B0095; Mon, 30 Mar 2026 19:42:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFEBA6B0096; Mon, 30 Mar 2026 19:42:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DBBF86B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:42:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7ECFE1A08A8
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 23:42:39 +0000 (UTC)
X-FDA: 84604356438.02.33DEFAA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id B58EE20005
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 23:42:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1VYQ4zdV;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774914157; a=rsa-sha256;
	cv=none;
	b=Vnco5K6O8gpOPcrmP5DDo89S8jROdprqYx0nUBA8pDB6IjDk6dcgQAiX6iTutMXKNWhYlC
	KaMbmBOmozSKRQlwv2p+OIFunUToPQdAb2JXz17YPq51KCl/dNtDaf+IREiSAcs1qHILe8
	zihehl3xaXpjxeQVIqLf5tWrjVobTMI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774914157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aywA6gq5gIM5wia/LIQrNIso4QjwVI31Yg2Jevnv2pk=;
	b=w9Vqh7GzTMvUeP7lwnF72yKbFiETNm+thY+fYEu7VN75jt2GnuQe/0BvXj67+CliqEtwUN
	eZtAJdrexdfVRsIJuTdcAIwdLkjqg8v+xlYB204LOxkBY2T7wpTY+TJQRqkklSRwh0Zmdx
	PfE427nax6mqvsP+IzwaSW+Xbiw4v4Q=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1VYQ4zdV;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B6B6D43516;
	Mon, 30 Mar 2026 23:42:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 678AFC19423;
	Mon, 30 Mar 2026 23:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774914156;
	bh=jv6cD/q7SMBzZgAN/xegm3WLMkkHCzw2zMQnbm3fxvo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=1VYQ4zdVoyfMw3Nm2mUHwPV+28Ids9paCCz+j9OvZEYHP9XBbUK38E2Vnp/KyAlkF
	 zBW7+rXFyv9xYdpL0Wtf3Z57p+4GvZXNHOkzLLR4kVQK54KDts/3uGxFpfpxjJEpr0
	 n6xJgcOy5+khOAUdD7z4GyYzZUTbmA3XXQElmyIA=
Date: Mon, 30 Mar 2026 16:42:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David CARLIER <devnexen@gmail.com>
Cc: Peter Xu <peterx@redhat.com>, Mike Rapoport <rppt@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/userfaultfd: detect VMA replacement after copy
 retry in mfill_copy_folio_retry()
Message-Id: <20260330164235.1d1c8968993d5409f1922ce4@linux-foundation.org>
In-Reply-To: <CA+XhMqyZaOpSqCYpH-13eusaNvZDXmtprAy-93EsB+vFOpnqEQ@mail.gmail.com>
References: <20260330202909.136776-1-devnexen@gmail.com>
	<20260330134021.171441c4c236b03efebc9a77@linux-foundation.org>
	<CA+XhMqyZaOpSqCYpH-13eusaNvZDXmtprAy-93EsB+vFOpnqEQ@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B58EE20005
X-Stat-Signature: ywuc9ipxjdfunuephuryfzwzumjz9aur
X-HE-Tag: 1774914157-960334
X-HE-Meta: U2FsdGVkX1/OmFYklQxna48IkCTN8UKgh5gIgHeK3kcn1qFYSm7OnANwTM947zhVI+vBv+lqhMN2OHhMUzTmCQvDTy5X7DdR0+WZsub1oao4ibRcpLbXA1gVKWxTOgMKt3Fuy3fOp7pcIXYX6ILc2n+SAkjysRFNUXnB2gNcXccfY1oiiibspUZaTjuZQKWRW9qPBnhrBdNvyaGiY9TumqMahoAYpSxGZQyLIPTZJ+lrP/Jp1qppzDphJB0TgAKeAhoySs1ZTvxyTTvdLlHuls9yWdNOho0V+z2k2VLqvwd6Y2bwu4BcVm5eQsMFOMzit15FfsqJEDU+BYAd9SAP3t93U0N42AxhCSwv2+MYAbBc04KiajPnd5et13FJsme3hpyMrVZFz5/pcoOOPeQHgYL4gQ3jAOCbNIHiNo8RiTe8WyJAAhkNgiMSnNE9VDGTLH+WjGlOL4xL33VoyQ3wP6qpwM5adL6XklxZgle1nCH1oXoCYsgUUwi56Mi/jyYcJPO+caOfIU+rrGWB5VLwl7dTu7iwMdKMAtNgshnSR5UZBpmJnPtqT04auq3KPeJ6KuMmX0W8Ku7W1Y4wY++uroveLDcUQ0hhxmHWx68fahZzTXR6AbNO6yz+3i+MrDRdCn+/W5/I4UwQm/5O+GqOBE8ur9FrkSjvZtBIeImHsLfHeJN/ZkAkiBOXHL6ElldEL8fzAAOYssp/SjSCQ3jzJTs4zeStUYgf7k1FWgRd4w5/QSZzhUGNfLvRwIshqwaGoWxuBHw/4JL9V3xugvpwwIm9T0ZqmyDvtJyYS08nZ9CoGEt6dJA5EiWr3suR+Vg2afpaC7q2ePfY16e0eAoYMBqOn3wsAbWO/huy9wYz8eqYDklyYrZtTiAgEBk00l2cBwQfTmybVohfYsovu7A33qwbXi8KJrmbQsLzTh2PooiLeSTJtulsjo/zSqYkKE1TDJ0YZ7U5jNaA0QlxtoQ
 T6eujB1J
 XIDU439F5aT3bUQiZI5e51MzhDzu3xZSyF+z/9eoKleep9iAWU0xNA19L4WtAa+N2aW1S1NfV5CIxwuhPtnCXZJGGHE2ofXwd66P6YWtjxOww258M44sSWmubi5wbot9AgROCk4dJitSxTYpYgVze6MaFKerGaA1TxhqYnTcZP/qsRIAHp40lJ8HDVqTP0gBvGZUekkizVyzU9ZR4MsiKWTXq4hCO+HtVK5J1JDiJ1ApDwJiTzXunctIiqVkUSy4OUGNpnpYVUSKtvYNUxVXLO+Wxf+VKMjkpd5gfKgxhzqvvyME66LX8zMCk9yAQ2lrbKz/4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 30 Mar 2026 22:32:58 +0100 David CARLIER <devnexen@gmail.com> wrote:

> The userspace-visible effect is a kernel NULL pointer dereference. When
>   a shared shmem VMA gets replaced by an anonymous VMA during the
> retry
>   window, the stale ops->filemap_add() ends up calling
>   shmem_mfill_filemap_add() which dereferences vma->vm_file via
>   file_inode(). Since vm_file is NULL for anonymous mappings, this is a
>   straight kernel oops.
> 
>   The window is particularly wide when copy_from_user() blocks on slow
>   backing stores (FUSE, NFS) as it runs with page faults enabled.
> 
>   The Fixes target would be 56a3706fd7f9 ("shmem, userfaultfd:
> implement
>   shmem uffd operations using vm_uffd_ops") but that's mm-unstable only,
>   so no Cc: stable for now.

Ah, OK, thanks.  I'll add a note to "shmem, userfaultfd: implement
shmem uffd operations using vm_uffd_ops" for now, let's see what Mike
thinks.


