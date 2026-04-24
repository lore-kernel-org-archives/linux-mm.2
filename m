Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4750FE5206
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 10:42:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E78786B0005; Fri, 24 Apr 2026 06:42:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E011C6B008A; Fri, 24 Apr 2026 06:42:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D177B6B008C; Fri, 24 Apr 2026 06:42:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BD5FD6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 06:42:46 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 684ED1C090B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:42:46 +0000 (UTC)
X-FDA: 84693111132.10.236C429
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id A0E961C000D
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:42:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IWYBmbai;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777027364; a=rsa-sha256;
	cv=none;
	b=8h67dbDg0IaSXVPPvSzxXv0bb0bjxqkmlhSzE7CTopP8cOrNsSfMFHRUkfNlHzVyCho/m4
	evwiWhUjwo2OaMpxr4oLdurl3AqTvNxOsXGqqbtKlM+PyK+dGylWFzWKBypp53iig8bMAp
	yvcD5M+G0vadHKHzS75wol0l2dNUjss=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IWYBmbai;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777027364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VmJ2bbGjMjBIB1Pdux7s2h+Oo7GCj4QiX7G6vCiLhIU=;
	b=QcEN/mXY+EiIPyCW4Tu1APKmABra55RP2SjBMrFQ+fbeDZaff4K2GvDJMNMmFfHJZQJhhr
	HvnjzV+VUQMnpoag04MIaGHue2Vfza9oe6hmIKMxlrUhhST0rBgQm7U9t2TIz+SlM7mXQh
	N/hPh5MspXvUFwLlqY/SYXxx7iYyhZw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 75CA941AFC;
	Fri, 24 Apr 2026 10:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2534CC19425;
	Fri, 24 Apr 2026 10:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777027363;
	bh=nR0iuS/CKyKNZLyYEdgABt6XJMQmCKdEOGfa5uTpvkA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IWYBmbailcCty1MPeh6h9jE9H5U5hJVIncLh+4HoUsE7ZZOyQJ473Kf1OS54kV7V1
	 XM8cfvQOCkb0WSdaGA0u6f/inBwvuHPD/BbNkfRq5J7j5jBcMtbbZdKljHrbUs17gw
	 aO77a7biIJ9LcJyYYit35g5pidTPBUAHq5bsHWRs=
Date: Fri, 24 Apr 2026 03:42:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-mm@kvack.org,
 syzbot+9722a25de70a85ff48a1@syzkaller.appspotmail.com,
 baolin.wang@linux.alibaba.com, hughd@google.com,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] BUG: sleeping function called from invalid
 context in shmem_undo_range
Message-Id: <20260424034242.b3e888872e8af6bedb882c1c@linux-foundation.org>
In-Reply-To: <20260424023524.322251-1-arjan@linux.intel.com>
References: <69eab803.a00a0220.17a17.004b.GAE@google.com>
	<20260424023524.322251-1-arjan@linux.intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A0E961C000D
X-Rspamd-Server: rspam12
X-Stat-Signature: doyxxpfjwo41nu18g8qxxt134ja6m5p8
X-Rspam-User: 
X-HE-Tag: 1777027364-698696
X-HE-Meta: U2FsdGVkX19LzPFN+HZlejmt6kjq7OwwnoyATaaeM7GTexpPiocTNswCG2AtaCQl0A93OcMJstt2vPaQB2eI32gfB3rQZsDPrto7iYzlLelUxbsQvQvAJ68KJMhpOeoOHvxjI5MqGne2JJWztnNFSVbcwzpBpeD5PYN89O6/50cEz+Pjwt2dN79MS/Y9Fz5VlDPwyhfxGIZKEuRGUva+SmsaGYNNRHE//n5w8xN4sX6ze+m03MxTxPBWtO7zSbwR54vrntDbD+RB85VcucLCPoetgraqnL8QXA+8imaTOZkAju39VrfuF0HM0M3Nyg7EarwjLni99vbcDq9qCXOxAAS3I7iJvyto+89fCUK6HsxF6/uUWBb0iwoWQwhIa79b+p3dSRDp8TWAjTYoqPhIIRWaq/OUTBcg8noq8iMs56GhhLNRnYEHiRE213OnB1iVnsfMRf9+N1ZkQorKuzyP4PInQ7IoCk4MPl103zNb+W7hA0YLkbbbcLyW/xlHmuRDHqecNiora8uKWDsOEm+FWymqAfFspxjiCrLlouD6qTPI63eKk6Apr4UGEqsCpKmw4rWixG4XQR47U49WpLCMwWmln/0NPfjuaakLZCuagCxRK0cPd0vwtx1uer37gtP7s0ii//6APo8carxfYAgQHeB9qBIE6XJBuqqkGPwHv8PHrAwJQjlmsJZxNa8KiKVBfL2Tj0t4U3rrqKuG2Zu53XiKCaV8jIrKqDilpMZFX4V6lifMc5UAEcypaiTptx+Q1ZOEamLnXnogK2DOr6Yj5VO9mVK4zCc2FjlrWiNUQVbMay2TeGRJYs5f1038NcgZlCUZ5dLm68w1FbdQTNiR/kanSKGKEk2DYkap+/u0dACgq648S378p8PojIsXRnQrYfTSvelKs9u0RF8Ji3LLZ/B29CJbGvLt66nCO0eixobeicBALpqqvne5+I6Nph8B/LyedW/5yVoSWP7YfXQ
 NFAM6Q2D
 1cAq5dDMx6eL5YqCCffQl3W5FtgUpb+GwiSLZGczVwC9WcmAEINgqy6MLCwge0Reru1FkPZncd4QsOwYpzAMGfa0ZP0qJ5RPZ29glZ155tOLzvMOfMpzp5sbtws5vbwiKdEa2a1fgU7pwr1SABDrYJv8NsbH1e0e6AfV9K2nPgPk3FtAOknB7cV7VN5S7xzzES8M1nIt0t7tR7xJZS6RMf/Srp4DC8QN3kpfFRqUaNgGx8pUseDk4SdPQrnBY/4+cLhzfiY65v+8NhsdpVLS6JANChoyZwUXU0BJDK5A9S+i4J0apFnuEgpHbukCfLxfX/ZYjxN5HQjIkaUWr2is1dGX1qYzyGZ3joBmbtU8OuQNm+Dx6LkHyOr+aJKomquWHQcitPThld3C7dQGcgMb7YiEth6alziKzJ1TB1rAx26mHg0hfnhSPz1S/RLrEQoPxjoQtVQypzz8ZfHo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Apr 2026 19:34:54 -0700 Arjan van de Ven <arjan@linux.intel.com> wrote:

> This email is created by automation to help kernel developers
> deal with a large volume of AI generated bug reports by decoding
> oopses into more actionable information.

Thanks ;)

>
> ...
>
> Potential Solution
> 
> Find the rcu_read_lock() call that is missing its matching
> rcu_read_unlock() in the vfs_unlink() / fsnotify_unlink() /
> d_delete_notify() code path.  Adding a WARN_ON(rcu_read_lock_held())
> to iput() (alongside the existing might_sleep() check) should produce
> a backtrace pointing at the exact acquisition site on the next
> reproduction.

yup, if we had a reproducer!

What's missing from the lockdep report is the one thing we want to know
- where did that rcu_read_lock() occur?  All we have is

> #1: ffffffff8e7e5260 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire.constprop.0+0x7/0x30 include/linux/rcupdate.h:300

which isn't very useful!  lockdep records the stack trace for the
acquisition site, so why didn't we get to see that?  


