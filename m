Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04C4E606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 10:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ahkG59L9
Received: by kanga.kvack.org (Postfix)
	id 1AF846B05F3; Thu, 19 Nov 2026 05:51:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 160AF6B05F6; Thu, 19 Nov 2026 05:51:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 076C36B05FB; Thu, 19 Nov 2026 05:51:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E190E6B05F3
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:51:04 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7DFDB120A3E
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:51:04 +0000 (UTC)
X-FDA: 85451551248.09.B3D40CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id C2DBC20002
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:51:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ahkG59L9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795085463;
	b=u48O8XxwbXSduiOVvqQcYC9sKOPGp/8cyONcs9UOLa8AmdZ5FKGKHpog4BLkWpcFlSbRqD
	kQo9Fb0cNoq0/jOxFRNd7KDOWKl2MxXrbV1EQsM+QsEN3wlwbUm/2/01wI5l2fsOIJX59g
	XxcTmz0mvzgBSzmilHKjj6tg7Eewemg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795085463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yfuI/yQuKLje7JCp8sAUMNEURSvgN1RcCGOMjucNHBQ=;
	b=VfnDXEvsZjqzqEILfEDx4LepaT0fKGA97j4FyUNMiBaVxIdU0l0N66WFPh9J0QQ3Mtgh2H
	P/Nzm6RXld5saRRFrX8HB5DopwDvzliqYYA+SX5tKd6LjC8pg62PgPnN0fr+4cdmOsOx35
	fd92S4goVeOl9prqL9u5+5YgsEFwwlU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ahkG59L9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5DDB14571D;
	Thu, 19 Nov 2026 10:51:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC8C1F000C5;
	Thu, 19 Nov 2026 10:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795085461;
	bh=yfuI/yQuKLje7JCp8sAUMNEURSvgN1RcCGOMjucNHBQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=ahkG59L9dcE4oY2xp+HrfLQSf7g8rFpsotvFwG75x/1ZyP/Bh85uerHgyhAly93Om
	 cKdmDBP75o98gpk588HUBuXcp79fJM/peujxMHMVas40lukKb+jfeDn4xit2/bJBSE
	 uzBOtyeEAoXAqZRcgzD75C5z0JpcYs3MbGDNWuu8eLHD14e0+UxgvckXHejIe8RxXW
	 EhEL3GYn9D8TATyT9Fo2j0vR8+sUjJmbkBcpee7DvX8IjR5cli7tXojZbj35AvEuDe
	 6jhNPmjO3eDcDe53iTyFvAyMFjMlMhDMb8G3FVZmjzeJ8Lz7dC5g0blte6gHdrE5LM
	 2kWOkOWV62mRw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Long Wei <longwei27@huawei.com>
Cc: <rppt@kernel.org>,  <pasha.tatashin@soleen.com>,  <pratyush@kernel.org>,
  <akpm@linux-foundation.org>,  <graf@amazon.com>,  <leitao@debian.org>,
  <corbet@lwn.net>,  <rdunlap@infradead.org>,  <linux-mm@kvack.org>,
  <kexec@lists.infradead.org>,  <linux-doc@vger.kernel.org>,
  <linux-kernel@vger.kernel.org>,  <hewenliang4@huawei.com>
Subject: Re: [PATCH v3] kho: do not expose incoming sub-blob contents in
 debugfs
In-Reply-To: <20261119095937.826980-1-longwei27@huawei.com> (Long Wei's
	message of "Thu, 19 Nov 2026 17:59:37 +0800")
References: <20261119095937.826980-1-longwei27@huawei.com>
Date: Thu, 19 Nov 2026 10:50:56 +0000
Message-ID: <2vxzik1t3xin.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: prf9dzyc7nnf1g3gqranprqetfnymdrn
X-Rspam-User:
X-Rspamd-Queue-Id: C2DBC20002
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795085462-303962
X-HE-Meta: U2FsdGVkX1+ArB2wUDnEg3FJ847LyGjMZSrFYjgcYgzVXM6KOQ9x+OeMzHCV97Zp0QPWRuNcpR2DHWc81hJxpggN6/+qxcQ7k9n72AeZaaugK0Tw7rkKJxzIcx03xocKHLSFvbUTswTPZGfV9gM3YIbLTmDwCUa53Yw3bX3iyW1J/jWROdsMOrwNzjZQlArqK+nE/urqUJBi2P5qgloygaTBGQ2WWCUPI1w2+QvvHe8sy17LSW2di8IYKB87EcEV065xQRFYAGQVX72jse48AKjCo/W6XynCjdx7opJPvewkj/YOEv0QXVNuMk7+ZkloHyN1IlpdJd5oNyXPKgBc6zwOnDzIwq4Yzh5AVqFNF3V1bECajxhK/r3GRzJ8b/wsD+wiguY3iJJqsukvZAOzGAcRqsT1IhwfRPcRTelxosgRUvp43J6UAhnzNjPUhTodHdVjOPR6Y9mjvCp6y0SoZP1cevAoaaf1RNPgEwFSd6tG+JpoSKbLSLMl29UoB4gR+c0/8CDDRU+0HUJipijVcABEpSZCvxSgJGBz99gSnQQJ2QzxgJzd9ZVe+EDfcWnk04Px3sHlCsoYv3ecyKcqn2mJFF6IxMQ8nSB3r/zw2iJU2pgLJqERSnJaV54anaojr3hF6cDBn5kBMIMb+AiWQmDIG/Yl9NDRq3VMX9jKCiON2hsRzK5t2TrQVP32rvp42cA4aBKaewoxxdVSantLhRWzf3JD9FN7bkwqnQ6JiXUIoZEMLIuP9bey8cuRqFJhyN0vve6VcxMau8MdP65SG36qpnBcE/6L5Ls08mwTMb0XARZKBfYbn06K0GsJyXectCM2eaKcP8qLQnMGaSZQevZJC71oan0G0rFvH/WjvVhJbAD6iIZHaQ/xd5okBRKJy6BDafH67byaiI9Q1+M6J+KfrkIhZX88fb7ir7+EKyVWT/gFcac7AvC1SjYr9kql9CZca6Z2GsVpZokqToL
 /TQ/THBb
 cqXnrP2G0J19GWqwGGEiCGg7SP+qzK5JKJaaSYPT5DGkKs5pXZZVgmCX8IGr89FqmccuwKs+P2PXYxH2csqehnLAo72yTZdOJEGVlrQOCyZ0qL2I93+vgn98rs7g55znRS37gGl5pqLA29oqFJoL96/PkzIP9CG5fOkcVlXnX0aN69XUj/dqHuW93KQuukojbKNCnYhgyRm8WhtaC3eS8y7GoLs7NYg2KRPbdFOlCJ/mHl61atL1NpOtZwzob/HekzRP8EnRJjPFBdORBzDQe65Fcdrses7QBqiZMkR5fwhUTJ6qjUr5/zHJvXx7Tckxva7pvPlOlW1PqpS1hE+sxZGbS8cLlxU6w2jBPcwIG2spRcU/DFrDbcpw5B4qy8TCB5a4VquzT6FtDq2e/4fGDnRJ5kiPdRvBaGzwfy4dMpWW1rdV5ajl5kRVG8prGXs3gPPDJK6ziUlwlFQzeg5Hkp0epbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19 2026, Long Wei wrote:

> Incoming sub-blob pages are owned by their consumers and have independent
> lifetimes.  Some consumers, such as LUO, restore and free their state in
> early_initcall, i.e. before kho_init() (fs_initcall) builds the debugfs
> view:
>
>   early_initcall: luo_early_startup()
>                     -> kho_retrieve_subtree("LUO")
>                     -> kho_restore_free(luo_ser)   /* page is freed */
>
>   fs_initcall:    kho_init()
>                     -> kho_in_debugfs_init()
>                          -> phys_to_virt(luo_ser_phys)
>                          -> debugfs_create_blob("LUO", ...)
>
> debugfs therefore ends up pointing at a page that was already handed back
> to the page allocator, and reading the file triggers a use-after-free:
>
>   # cat /sys/kernel/debug/kho/in/sub_fdts/LUO
>   ==================================================================
>   BUG: KASAN: use-after-free in _copy_to_user+0x37/0x60
>   Read of size 32 at addr ffff88810309c000 by task cat/27436
>
>   Call Trace:
>    <TASK>
>    kasan_report+0xb9/0xf0
>    kasan_check_range+0x100/0x1b0
>    _copy_to_user+0x37/0x60
>    simple_read_from_buffer+0x77/0xd0
>    read_file_blob+0x75/0xa0
>    vfs_read+0x12d/0x520
>    ksys_read+0xc3/0x160
>    do_syscall_64+0x97/0x4b0
>    entry_SYSCALL_64_after_hwframe+0x76/0x7e
>    </TASK>
>
>   The buggy address belongs to the physical page:
>   page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x1fd
>   pfn:0x10309c
>   flags: 0x17ffffc0000000(node=0|zone=2|lastcpupid=0x1fffff)
>   page_type: f0(buddy)
>   ==================================================================
>
> The page is already in the buddy allocator (page_type: f0(buddy),
> refcount 0), which confirms it was freed before the debugfs view was
> created.
>
> KHO does not own these pages, so it cannot safely expose their contents at
> all.  Drop the in/sub_fdts directory.  The incoming FDT is reserved by KHO
> and remains exposed as in/fdt, where the same metadata is available.
>
> The incoming sub-blob debugfs directory is gone, so remove its description
> from the KHO admin guide as well.
>
> Note that in/sub_fdts has exposed memory KHO does not own since
> commit c609c144b0e8 ("kexec: add KHO parsing support"), but the
> use-after-free only became reachable after commit d376e4b55c9a0
> ("liveupdate: centralize state management into struct luo_ser") which
> added kho_restore_free()
>
> Fixes: d376e4b55c9a0 ("liveupdate: centralize state management into struct luo_ser")
> Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: Long Wei <longwei27@huawei.com>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

