Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71071C982DD
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:05:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 659FF6B0093; Fri, 18 Sep 2026 16:05:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60B386B0095; Fri, 18 Sep 2026 16:05:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 523366B0096; Fri, 18 Sep 2026 16:05:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 307AE6B0093
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:05:45 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 715FAA630B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:05:44 +0000 (UTC)
X-FDA: 85227963408.09.F752478
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9DB7C180004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:05:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wZ9w+V9p;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789761942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/9eCkd+/q2YFDNvV3tExteb4O3KYk7MFOgoJKuvoKVs=;
	b=gxRnG6D1rA5GwuorEd9kKCn1O4bRBTPkNKPPkVHMl0rx6Z6ochxupLjMQ+u0MXgC1RFodA
	/i/USvusacA8g3THM6D9xmZWle9Cxdx36pE/PlQLRmzhxdlkpGtlrGyEvvOj8ossW9+nWZ
	yBCkm3qT127p5JKvIuf5dIUi0kDojZw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789761942;
	b=opd080hRZjKq9G4BwojImBglmLx/Irx27K4KRrq4tLudDJCAb5+4XHUL2/8OMqh8noRpep
	M+qcz70hMbwRhHaEb1B91JIX3cPK3zDbma9k/UCfZljysnE3i6z0k7I+5MkKQ4a4U0iFC+
	G96yCcD5deAYexKtzmguLUjNU1npXh4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wZ9w+V9p;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CE07B438DE;
	Fri, 18 Sep 2026 20:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB771F000FF;
	Fri, 18 Sep 2026 20:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789761941;
	bh=/9eCkd+/q2YFDNvV3tExteb4O3KYk7MFOgoJKuvoKVs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=wZ9w+V9pcKZq22sMAtKM9V1siY/Ju7L1ZFx6jrTHphsJW9YGHAj81/7DhlOwXgsbW
	 C7tkV2qHpO6L2Zm61Pdlw8hUZ0qEA5HmK7jx1/RyqY+movb/GMJBItRZx3Hh5+e2ap
	 N4MSIZ6Rp8vON+hdwtpa0fvH6pYEBLgwsj9M5od4=
Date: Fri, 18 Sep 2026 13:05:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-mm@kvack.org, Uladzislau Rezki <urezki@gmail.com>
Subject: Re: [PATCH] mm/vmalloc: Use %p for pointer formatting
Message-Id: <20260918130541.8962a797eeb80cab07b18f19@linux-foundation.org>
In-Reply-To: <20260918105013.UpdykT6j@linutronix.de>
References: <20260918105013.UpdykT6j@linutronix.de>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9DB7C180004
X-Stat-Signature: gc764is8h5bfs4c61usb6kitgo5drqpx
X-HE-Tag: 1789761942-267912
X-HE-Meta: U2FsdGVkX19UufpTyoUl5hY7yM3AXjeAzheXZ6Ea5DkeCIz6+VBedATKcPGEyThz/xbh0pOiQ3+wXe0BFOoPE/h+/qWrI6JE7mWTIGfiNbT2CDx+Jaq+2rSvhh8A2sAxjDZEENjaw2HZf4azaJb+079QP5CLiJ/GvLJGBWL8h51x+6BjeOcf3zOCy8xk5YvG+m1WuSGzfg6aYpKigwF756aqfYzilNp86njfNKUxdRk86UllGEssZ/HC6sw6PiF41QOD9reIt5oSDvZa0que7SwBCQ0U67dxlrUMYwYnck+D27bPfNNWwp3xYAPgmXREMiZKIhiIxvUog7hK3zOp9bIoGSCjJIqXJRMxShsFhNmAeb/eqUP1fmJlyc9jDDzFlDPRzGbDhFJ0Nc+HyEzp4mD49TRufIRbEevdCnQ1nFAiXTYEumNLnCF9ATj+VvW+R4Ud1xrod5oYJam1lBf5ZbHhvOlzDs1wYxZl32ykvQjDp5rQ3NEJGM3nXa7mmWujK4/jb1FCtiW96VzKeiGQrVJucBOTW5276TtvClVFm0zClt6fFxxw+AR0dW+VmZPb0EbLDlbeoqWBOYjX7PqzRjUkZeqonuzBaZOIc0RtqKe8e7EJZwYUtDhslWerVYEeWCvYS5Bc1/FxwTPtb5dWfVb3Q3QpSdTpQPlYzN26QRxdnKuusvS9dhjjfkauIX2VuOjTG/TIdAloy5kvZg01ijvwtWc4ushMg13fhZYzQJTOej5MN3AOEq1uv1ppRgECi/QTyQFN01VoOiF0/7/zb6paW6V1nrkfnqwm9Dbh2EXFQnH0hU3dHhdGXcxyG8wdPwTXxp6XfitGYVOdrf0bsCi4FU1GQSRCac3iMuchz1rLR2GArACssMbASFdPqyYNneVU+dO645wE+S9vVOv/7XckajLvr5DafZGUJ1YDrzfoNdjkKlTPd4KKMbVMmbP3W9BjwraGzceVgkjJvdH
 CPJMSDGb
 iq7JFdKvK+W1WEu1tk0FpgqjB8xVEsR8yozN97TOLhQU6YmkCs3dDA5Oos7xzY+dZAK9jqQEbz9W38b3cUXsmn8shnBMngD1xvzKOkvppncwbfRXwIv7bAGm7GvLkrkEgyVeZtqeEJYbejXOCJfs8RvKBRo0D+FDLqwWNBG/LZ+V9uSZsdPfjcCjqb0UBkKSYOgX/1ca2C9PQZb4+kx+L/fvuk6dWQ2dyExjOadZVCV0xlXQYu7lDs4xKB+lzRlJL3rNpaFiX4uZdJncLq3r1ECnAS9rple0O4VLOBYwuwt+FZ+Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 18 Sep 2026 12:50:13 +0200 Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> Commit 45ec16908e84e ("mm: use %pK for /proc/vmallocinfo") introduced
> the %pK in order not to leak kernel pointers.
> Since commit ad67b74d2469d ("printk: hash addresses printed with
> %p") pointers are hashed by default and the behaviour can be controller
> by `hash_pointers' boot argument.
> The policy on %p is to not introduce new ones.
> Removing %pK makes it possible to remove its handling from the library.
> 
> Looking at the output, having the pointer in the output makes it
> possible to distinguish the individual entries.
> 
> Use %p instead %pK.

Fair enough.

I added this (important) info to the changelog.  Please confirm its
accurary.

: /proc/vmallocinfo has mode 0400, so this change doesn't make kernel
: pointer information available to unprivileged userspace.



