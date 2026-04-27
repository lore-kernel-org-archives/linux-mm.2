Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27E8AFF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 11:31:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93B4A6B0088; Mon, 27 Apr 2026 07:31:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EBFF6B008A; Mon, 27 Apr 2026 07:31:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 801A66B008C; Mon, 27 Apr 2026 07:31:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F3DB6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:31:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 12973120158
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:31:54 +0000 (UTC)
X-FDA: 84704121348.01.A770FBD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 40760C0002
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:31:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="YgCAbI5/";
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777289512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e+fG8ZfBTDJSUoDzjYayBxRy67LkPztdITyPoRKc3Ug=;
	b=CT9fKCku+UjMqOO+RNFlpasEbPPJdC+R02Xby0QbZu1ZTgwPB14L+mcvU9f2xMzpmSAGJ+
	PvO84twBcbk6lV86yaQse9vozJ9Ba0a77/gAqkV/mBvsUZYck7lCck2A81dG8/ysICDnnp
	ZMEfyFhFnxLEPpqbB82b1LREAiICkZ0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="YgCAbI5/";
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777289512; a=rsa-sha256;
	cv=none;
	b=FEmc7pmmWnVi9gS7CcppfgIR+08ireyOaE1Z7rSHlsgaPfmJKRhAUy+ext/FZunHAq8eOj
	uar0a8s0FBN4cZ4F1xBUmGYwQyZ1hhUobF537Hd2Suzkr5S5IYH5+718FHb95x8r7MIIGX
	zbVIi6PDqTtF3tHQ88+l5/u3uOx1Nts=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DE1C544251;
	Mon, 27 Apr 2026 11:31:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57AD5C19425;
	Mon, 27 Apr 2026 11:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777289510;
	bh=iNslZoTyQAg0rKSwDznTtdERDBUeqpLTEMT5UjUqXQ0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YgCAbI5/49351SMViTuoAykJaAlMsQGsGGuhnM1gQBqXu9W/qJxHJse/OfV2NQiKe
	 r1a1bGncfNUOi3K7DzPUclTfGl5L0gt0BgDd4ieGd6NbozoFUXpgGeb4uRZPu9YXWm
	 Os/Sya5U/QdzAngUigeVrTP8Zsix0Fm3LC2mF/Bc=
Date: Mon, 27 Apr 2026 04:31:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Thomas Graf <tgraf@suug.ch>, Herbert Xu <herbert@gondor.apana.org.au>,
 Vlastimil Babka <vbabka@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 David Hildenbrand <david@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org,
 syzbot+5af806780f38a5fe691f@syzkaller.appspotmail.com,
 "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: Re: [PATCH] rhashtable: give each instance its own lockdep class
Message-Id: <20260427043149.e8fe46494d92d561175861ca@linux-foundation.org>
In-Reply-To: <20260427-work-rhashtable-lockdep-v1-1-f69e8bd91cb2@kernel.org>
References: <20260427-work-rhashtable-lockdep-v1-1-f69e8bd91cb2@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 40760C0002
X-Stat-Signature: rphurw3c19g7fb8apoj5pe34coic8h9i
X-HE-Tag: 1777289512-810542
X-HE-Meta: U2FsdGVkX1/E4oR1HCHjf26FaDIHVenvCqYRm0jTEIWjPmXkUrw689ws2ThFtozhWw2fftldaYWmwzUO5WcleC8HcA0C4Fl3bS7XfMUSZd6JtB0vH7/XRUVFljIbyUD1U7qDwnAw9ZN9EVMEbkVPHXYBtKTWqB+XzPiQXiZ78lOUditxO+9FJy9MzJWRVxkt0Xl3mVI2vh+oiyEIABfnEbIiT/i4lIWaT5VFuNm1vaU3Bs+tA4fHqBIWXMNkKTkvakXd1tYX9b0uMe0R1wSc+TB+3vcX9jtMPSjoj7Hl1NLopPTQk1H+lzx/EX8UQcVZu0n0XE6DZkNICK0GiRxvXnHdQd2QPW3xA9SOqxb63iENEW6ddFslp+0gaX878CwMAHP8dGPPzI1lm2QnAhq+jLR9WUsqfhK4Lh1uWBQqrtj25wMWl1QMR5DSJentq/DM72qcE1nSoIcJSP38W9pqttB/i2ZyN0vyiPZJUGKkHcrvm/L6zMXH/etxmV3Rfy0HWl6al+RW2SMHutGatcpGHlFUyybIGe4jAMXF/Sy0b/i+j2ps/cxORGrS57imGdjW0Hshr3FmMAi+M/3BDlxHmhhFXvVaIDJA5iH2+iqPOFe1nkz0FlyGZ6I6Mspf4VAzFUDRftkDgeeVRmYOx+JnsJLEwUxMv4b1LtXhvxUY7ML/tOmI5PGI7NuIrAGQakQd1TZ6yPsU5AhIIIiKzrzF6SX5u/ovW6kmfjXSZm7Jy2B/Fc6rTalq+xqcxnNnHgI/9/bF7XzAo+bQN5ooXSxtdbG4Dgso/K+n6H4E542KVz/uzZXdKFpqwCbO5iqV1UeobP+uwK24kR3EqP85SPUwq5dYtYVzWo6VJ8bpMWn2pNFGas8iFwBILVUgbfTTiYFt9ZGo+usXUpmhA0I38p7kK1+qAYfRYKNiZG2+vK/0a21ubWJMtnIJz2ZYwMgTq2wiuJhl1dLfKxbTxgrXbOx
 OP6PEjjz
 ArUSbjGaDybJxEL6/uWMxj4zkC8GVaFuBefyK3b13MGiE4WGZEXqQAM2t8T9vFupSxM+2CF2rFu+9iGirts63gWRkQkYJ1WLHK5P/NKt1n8mREE/Mao266c3Gr9N9gId8myQr/Qhd7grEYAgzvBMLzy0Y1eQT0saLf0TN/UoLrC7n3XFJLmFv5Ph4636K7ZKRovpOy40iHr7F2pyO8/rupqArWsEYzkfwKAS9XmA1ZSlxUf3vQriY/mE6Oe8czHZ6JvamtzIGf/en+Bg5P6NP+kjtcLzG8iDYnZVBntgsSQX4rkORDegD2Pk8DBvGUtQ3SPpfKZuBmPWELzDfx5WGYZpTanqc6NYWzCUXK6SiRY8U2Mk+xYNN6UtzwbrNNST0b+P6l4kyuynGBRTNBmkvGjUMnz4ZA/bpFA29FLpyNKGFLH91X4WmFGrnAb4xukVEQ27b1zrnnbZ+DdHIzz9UIEADrcjadwVfv8rb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Apr 2026 13:09:57 +0200 Christian Brauner <brauner@kernel.org> wrote:

> syzbot reported a possible circular locking dependency between
> &ht->mutex and fs_reclaim:
> 
>   CPU0 (kswapd0)                    CPU1 (kworker)
>   --------------                    --------------
>   fs_reclaim                        ht->mutex
>     shmem_evict_inode                 rhashtable_rehash_alloc
>       simple_xattrs_free                bucket_table_alloc(GFP_KERNEL)
>         rhashtable_free_and_destroy       __kvmalloc_node
>           mutex_lock(&ht->mutex)            might_alloc -> fs_reclaim
> 
> The two halves of the splat refer to two different events on
> &ht->mutex.
> 
> The kswapd0 path is unambiguous: shmem_evict_inode at mm/shmem.c:1429
> calls simple_xattrs_free(), which calls rhashtable_free_and_destroy()
> on the per-inode simple_xattrs rhashtable being torn down with the
> inode.
> 
> The previously-recorded ht->mutex -> fs_reclaim edge comes from
> rht_deferred_worker -> rhashtable_rehash_alloc ->
> bucket_table_alloc(GFP_KERNEL) -> __kvmalloc_node ->
> might_alloc -> fs_reclaim. That stack stops at generic library code:
> there is no subsystem-specific frame above rht_deferred_worker, so
> the splat does not identify which rhashtable's worker recorded the
> edge -- only that some rhashtable in the system did.
> 
> Whether or not that recording happened on the same simple_xattrs ht
> that is now being destroyed, the predicted deadlock cannot occur:
> rhashtable_free_and_destroy() does cancel_work_sync(&ht->run_work)
> before taking ht->mutex, so the deferred worker cannot be running on
> the instance being torn down. If the recording was on a different
> rhashtable instance, the two ht->mutex acquisitions are on distinct
> mutex objects and cannot deadlock either.
> 
> Lockdep flags a cycle regardless because mutex_init(&ht->mutex) lives
> on a single source line in rhashtable_init_noprof(), so every
> ht->mutex in the kernel shares one static lockdep class. Lockdep
> matches by class, not by instance, and collapses all of these into
> one node.
> 
> Lift the lockdep key out of rhashtable_init_noprof() and into the
> caller. The user-visible rhashtable_init_noprof() /
> rhltable_init_noprof() identifiers become macros that declare a
> per-call-site static lock_class_key.
> 
> Reported-by: syzbot+5af806780f38a5fe691f@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/69e798fe.050a0220.24bfd3.0032.GAE@google.com

Thanks.

Is this related to https://lore.kernel.org/202604211323.fac1b29e-lkp@intel.com

Are we able to identify a Fixes: target?

In the above-linked thread Herbert had
Fixes: c6307674ed82 ("mm: kvmalloc: add non-blocking support for vmalloc")



