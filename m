Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF58D1061B1E
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 20:40:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6034A6B0095; Mon, 30 Mar 2026 16:40:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B4556B0096; Mon, 30 Mar 2026 16:40:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CA536B0098; Mon, 30 Mar 2026 16:40:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3E5F96B0095
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:40:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D677B59A6E
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 20:40:24 +0000 (UTC)
X-FDA: 84603897168.04.F560CDA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0EC531A000E
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 20:40:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yzsqtF6j;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774903223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a3G82bzJNMTjPlrdLObC+UGkeasYANwo0SRvpcsq5+4=;
	b=1oj4kD7fEDgPLRY5BFBhwtcrbRp1K+1dIupgA0AwmfU0dWo0AxD/ZKfV3LRDiWhLUjMY3H
	j3xcuxJnHUKmIqMoS9HqQHM190NKHaCblHha3SILaJ8H4SQU1vkFJAB+pdSyTV4nfP0jqY
	RPfYtxJ47ycpDJpikt7HEJZPqdF/3ic=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yzsqtF6j;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774903223; a=rsa-sha256;
	cv=none;
	b=WmgQ0VGwK+AEpZrf0tYLz22z7zIMMiKgryVyfbDpNeh6LGxPzz5M2JVa8inhQ6PFq5oyhx
	BNOEIBSRr744QrTpAxXyVCEPtlR7KNBbQ+48K2KQ9Y7v8V6IBfzO0TtiJkofe8a0B+/0jf
	sktIII7aw5UD/XeWjqMJ0imuzzTjg3Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 13C41435FE;
	Mon, 30 Mar 2026 20:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4997C2BCB0;
	Mon, 30 Mar 2026 20:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774903221;
	bh=K6QoBOHE7iajrxILRT8WbjPboIxXi6OCtQUz9pCgm4k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=yzsqtF6jiYGBZlz4SdvbqNPJcJ/LvRiQ3K68q2rH7j7zCoAMQNZxZ4k79hD7wIro3
	 qd9HFDL4FYBAT8IrxeShgzpg8M6E1cmVZy88IY9KhUuvHYeX37sCPVrZwSD1zYbJ3I
	 dNQ1gqUG95rncu/NCCOLwrGEYMztox5TSdNqdSA4=
Date: Mon, 30 Mar 2026 13:40:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Carlier <devnexen@gmail.com>
Cc: Peter Xu <peterx@redhat.com>, Mike Rapoport <rppt@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/userfaultfd: detect VMA replacement after copy
 retry in mfill_copy_folio_retry()
Message-Id: <20260330134021.171441c4c236b03efebc9a77@linux-foundation.org>
In-Reply-To: <20260330202909.136776-1-devnexen@gmail.com>
References: <20260330202909.136776-1-devnexen@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0EC531A000E
X-Stat-Signature: gtew6jfepzyfecxuf9f7o353ejmgscq4
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774903222-956402
X-HE-Meta: U2FsdGVkX1+Fg7oAfbCDLK5SsJLF34JjDleD1FX07ybmcAui22vud9dbo0ypqWzzJKPQROpyIBQZWL+hOVE0uFo5kCoy81u/QYhqoDsM5NUBU22+R1I3toxGP6sI83siluGPuw3yhFffi6/SnzgqQftgrv2yc4nfufdi/cBFhuVXCOjyo5HXYOTm4O5iG34+vHP8jRCk98/35gi8GDcs2jGbuwR4C47dq1p2/Ixrm8rVhI5zFUz5QzmbWAfzCm1HcX6ONQcY6uFsAOn97OPK/MKAK0KDXZ1ZuXyzKtMgE17lJWxV4+CBDc013+TnNaagJuSg2iBja+WgP887ilSx6Pdgbt8HqM65xTztmKXzLsQf56VEnj/zIO0njPNlj/JOtQf75IO/I6NKRQhfej+sizNqR0ufgBtUVu8AEQEiyK73LebSVk9ZVELkmK2aCbRmx5SpIhWjhPaeAxh7ETJkMweKXcPb9v9J9dM7CGDKykBAEot5JlnAWEaS9heP19hYdzxtNHh1EY/AWPSVXfgsGA1VwQ50wXtpUxcSJucBp8dguQEzRbYvCl5KJdrXh7ZVUNB1phg1khcgDLn2xJpAUkuciWqjkWQFp9IlOzty5qONLb+bsKf8d6M459S/1i+TPKz4Mt800tjlcos9E73p0cIlVtaJOtu0E8F+UkyP2Q0vUCVw+UGdRDZHVlaT/5g3kGEDa8TDQML3sMgUdtWbLgotERyw0Ypydvu3PDD70mTPp8Oxfy6AbwdS8ZfCAJgG062jonts5lFIs00sle7BPPewSXvc4eEMiKTZcxi8gT02wSWIqJ7HTgioGsKJ5hytgLODNsqse1/LdEHP7nyFzYZA9nRPrYNYlVB4/k5RP0oM8KVVpDx9ZOaNa2GGApvKJZJ1pHXgi4wWeBK7uwBtOvkDhuound1R/lWCHvAs2s3y7vGXnuWRHhoZihi41Vc8yFpJ2AWTzNyAyi/ewCt
 5TzTx4h6
 Gmt46GNZNgj+OD1S67jjUCEKv/49Vr4uvaiyMAhRrkDr81QF4kAGZWqYk+Tc+MSs7PbxUg7OYr3lBbml9FDfvg0uihxd+BjJNBy5+Y3jP0AFefFeq7pnG7Q8apTlKGdiP8Q3S9S7XitacEsReZqObbxgQUIII3uFHvM1P3oFvOoYzTJEFc0G0hYPTtHT9UBhZwFV0FCQlMNUCSnoY6qqr2tZuySAQasU6CUHsXgwIIdIt74ULUem+w/KmGkRCIu+cz4HCfCq/lLZmr+1zmDRpce+tHGGhxNqhBBi9h2zbtRL0uM8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 30 Mar 2026 21:29:09 +0100 David Carlier <devnexen@gmail.com> wrote:

> In mfill_copy_folio_retry(), all locks are dropped to retry
> copy_from_user() with page faults enabled. During this window, the VMA
> can be replaced entirely (e.g. munmap + mmap + UFFDIO_REGISTER by
> another thread), but the caller proceeds with a folio allocated from the
> original VMA's backing store.
> 
> Checking ops alone is insufficient: the replacement VMA could be the
> same type (e.g. shmem -> shmem) with identical flags but a different
> backing inode. Take a snapshot of the VMA's inode and flags before
> dropping locks, and compare after re-acquiring them. If anything
> changed, bail out with -EAGAIN.

Thanks.  What are the userspace-visible runtime effects of the bug?

If they're serious we might be looking at a cc:stable and a
Fixes: tag?


