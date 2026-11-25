Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B187A606A323
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 12:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I+rG8oon
Received: by kanga.kvack.org (Postfix)
	id D13A36B09D9; Wed, 25 Nov 2026 07:00:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEB3C6B09DB; Wed, 25 Nov 2026 07:00:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C27E16B09DC; Wed, 25 Nov 2026 07:00:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A41756B09D9
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 07:00:08 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3AB1740EBF
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:00:08 +0000 (UTC)
X-FDA: 85473498096.19.CBF9005
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 887EF80007
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:00:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I+rG8oon;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795608006;
	b=0GPFOod1bliIDuOUz6iT5W0gNgA8g7LXOwboMMyrb22Yvgygj78klMZ1/Ib1ysMi1zX3fS
	I1rzy5zWvNZyza27BCIY970ksr3HarOo/uKpc2qv4Z8/P0cEDwVnNMLJK2Q8vsfdtTU2vg
	HmKV7FrqxiPETv+a7njo3pP2oKGgkPY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795608006;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N+0941lZ9Ku00UFWxiqe00YLcQOH401IxZ17Yh31ioE=;
	b=3PaIJkgjd2zISXO6dLiUTCQP4Wl/ogZTirx5jnBLWtOPFvROhy9me8DL/ZLRto6FDG1NmA
	d24HVWOSWyFiuA5DHY4MvObu3qfpteEIqu2LkRVyZVmS/s0BboUC6K/XFlKytOJ8OzbfFK
	Nz37jiJafd87qdupgZQivBTqqrGvxd0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I+rG8oon;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2613762943;
	Wed, 25 Nov 2026 12:00:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F151F000CF;
	Wed, 25 Nov 2026 12:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795608005;
	bh=N+0941lZ9Ku00UFWxiqe00YLcQOH401IxZ17Yh31ioE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I+rG8oongtOP7aY9p0pNkIbNGJDqSF8qQ68JrK+Zzl+W0Ma4xKMTR8Cr243W2xqK0
	 2ZuVW03IlliB6MX5fGxZMC0M+1UcMjxXe7UDClufmBpdpuuPpsskoCfG5Q7A/+tBQo
	 M20vAmW2j36KZJwPan0SefI93YENbaHSzut++MP58er7ZMLS6Q0biJO2ohV/vtwkPF
	 f6ptry/tqbGVyw8ybO9eCpK4kXWDVKonwvrjkhkcQ91bdHeOBOzzati0n+uoBg5way
	 G1I3G9w2+pRfmuuixHT5WvOGEOYckpgq3PO4FW5zNLIhbKDkcYuDvqsBiuBeBB3/gf
	 2qPR5SqeTssEA==
Message-ID: <sashiko-outbox-233313@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/8] fs: Defer reclaim of unlinked inodes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Kara" <jack@suse.cz>, "Christian Brauner" <brauner@kernel.org>
Cc: "Christoph Hellwig" <hch@infradead.org>, linux-mm@kvack.org, "Mikhail
 Rudenko" <xyzzy@yandex-team.ru>, "Andreas Gruenbacher" <agruenba@redhat.com>
In-Reply-To: <20261124115850.3512-12-jack@suse.cz>
References: <20261124113450.3451-1-jack@suse.cz>
 <20261124115850.3512-12-jack@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 12:00:05 +0000
X-Stat-Signature: q4eib73ddq6o9wec1g8515xsfzxk3de3
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 887EF80007
X-HE-Tag: 1795608006-812754
X-HE-Meta: U2FsdGVkX193cIz21dMV/FrKRvTLZLZBNjypj9SxRW+/JCMA2ic+8jZk/7Avae6aF3BXcYXuRSVZRh5C94vO+9oulvBxjSq3xqaKNnxqRUWicMRyDfGA7EWXKgJvL4VycKN9BTIwGw0G1UKwAHMv6/MJEeqwhE0hKfkchqSpwQ++vKKMiHLoUdPmZ6fLvWXnom+xeuAZm5AnFBYdjrabG7TLNIU2PC5d1HhArTB1Wau7072F7niGgdEMtkHVF9Kh6TcYOMhBWMowEx7jAtI/O00u8MSPMGHq1NQCe0rCD5RjE6DTJPGDBUR+FIF2SxohfLo2RcACrEKxZhNxFA7TKiETGH6GKaXEBHyC6U0gzEtNvY6MiY414Zqb1aTLgs1n63MLGxzjle6FD1o99ByRIw3N2VWJDT9jdgHYkyJG/R6DtJ46T5OAg/wAGyNA9zYvb1c7WrE71Pwa/AmB/u2/h3lgGkgnVBBweubQyKbBFXhWd/pBahU3sthk9bGrHAkIdZnJVMfuDuc9ZCF990gYS4O8zv+bqjfXEd0Kt92spNc/WOOzKt/RZNa7OX1u1w13Th48bZy8Sh/k942UyDX41/SAXCTv/4z8IyHEvOqqSTm3cQNUFmBlo99FzNER5NYrKx/xPEqsb9fNONC3gZuXPJ+cIuUvxFJRedDYXMokh1f/aR2brbOcuDxsq+Y9MDM4L0jzIRSPAOrClSqyjxWrW135YcK1R/J3x5SMBUJhEV/oy6ZvjJvDpfs+JGwde4v5FndOxJQ+6gz00ekV/oXXY7GA+D0sv8mv7qWFIMZ/FP5ooFaD9hRis9VL4kLov4u6CqvQVEmQzID7dvk5Bs5/HLYyCA57sdf9H/gLEeNzQbdwPgWUx8Y7QjbPfSAz9DJA7OmGIhmwYu/wNwe5j9JTY6HsgZ54fZw74m6Ah21OXZQZk2FzA2d0l67ynvtFX58SGBlPOVh/Mhy6ACVEHgF
 GWN27iLA
 HjVlLi+flKRiaJHYWExpYIPZenviy47r2HllOELr+KfN9ceT8eV52PFO58uCd+aE29YqtZonMzRyYCdhxwEEa1r8j6eNlWWWNT+HE7nQciZZompwj+wB0OKCU5Vj/kQIXkji5W3L06hZe1u5qEvvN2CgeD6tbZ86s/ubkumI7tm4Va72vxUE050IL/0jifyT3fiQKvybcMETKBLMfYJNR/Viz/bOOjL9OdoYbJPP3i54HS2eW1yKdQMP36QY1Y+IuHiz/MgWDBSmNSqm1qw1vMe5HYIUnJg8IIsXVRGyAA9o3icciDHJnbzbjsYXNp21U33E6qm4RmtT60XZdSLjmVOwUNXBiq3tIQiHEW+DYyPZJ8MTrMrgEKMY7Mq8ZTiSr7wElmR82tfbg76j18Sh68q4fHP1tMwPYWrKbFjJyww7Rts5XqKnEyKH9mU90PSbqiB5yLpXYq+uRMl/gLmqUO/89z2dsFN8OFHTwjE6pyKJH8ZrOwKChfwtkgLIo+fDboj3xoTODUOYZ65u9BdaZ8cDK7oGNn5tBbMxo4/EkARXUl9hKc3iwsVfvjmNj3Lf2m0nKaDk7rEtzNiF3B0kDpRZHUYlaXsOhXkX7kHh2kOqXpshJrAP4EYR7PKxp6xwfBGu7UfMYfsGbd4UMf1XFAdSrUwlaEMaSkAnch8Z5tih17e5Mjfg+IABfWxg9bZd49pBoNdwRlJTGh5AJjMgYP1WDKN1EMW1kl9Oay7UZSjgcKE3mgsrYs9LleTuQR7uCaobs+35nQfNA2H20g5f8xHGhA3fy46gFr/RY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] fs: single-worker serialization in iput_final() via
  queue_deferred_reclaim()
--

commit 8449483727b2bbcd575fed1bb97c8ea7882097a9
Author: Jan Kara <jack@suse.cz>

fs: Defer reclaim of unlinked inodes

This commit offloads the eviction of unlinked inodes to the deferred reclaim
workqueue when the last reference is dropped from a memory reclaim context.

> diff --git a/fs/inode.c b/fs/inode.c
> index 8853eb6015dc0..2977d5f1382b9 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -2240,6 +2240,23 @@ static void iput_final(struct inode *inode)
>  	inode_lru_list_del(inode);
>  	spin_unlock(&inode->i_lock);
> =20
> +	/*
> +	 * Are we going to delete this inode while in reclaim path? Likely
> +	 * reclaim of some object (e.g. overlayfs inode) ended up dropping the
> +	 * last reference to an already deleted inode. Offload the eviction as
> +	 * it's likely to require memory allocations and block on IO. Since
> +	 * this eviction was triggered by a reclaim of unrelated object, the
> +	 * inode is already outliving the operation that originally deleted it
> +	 * (unlink, file close...). A slightly longer delay thus should not be
> +	 * observable by userspace.
> +	 */
> +	if (current->flags & PF_MEMALLOC && !inode->i_nlink) {
> +		LIST_HEAD(defer);
> +
> +		list_add(&inode->i_lru, &defer);
> +		queue_deferred_reclaim(sb, 1, &defer);
> +		return;
> +	}

[Severity: Medium]
Does passing count =3D 1 to queue_deferred_reclaim() here serialize all
deferred unlinked inode evictions for a superblock onto a single worker?

queue_deferred_reclaim() starts at id =3D get_deferred_sb_id(sb) and comput=
es
how many workers to wake from the per-call count rather than the total queu=
ed
inodes:

fs/inode.c:queue_deferred_reclaim() {
	...
	wake_count =3D DIV_ROUND_UP(count, INODE_RECLAIM_BATCH_SIZE);
	if (wake_count > deferred_reclaim.workers)
		wake_count =3D deferred_reclaim.workers;
	for (i =3D 0; i < wake_count; i++) {
		queue_work(deferred_reclaim.wq,
			   &deferred_reclaim.work[id]);
		id =3D (id + 1) % deferred_reclaim.workers;
	}
}

Because iput_final() queues one inode at a time, wake_count is always 1 and
only deferred_reclaim.work[id] for that superblock's hash id is ever queued.
When reclaim (such as overlayfs dcache/icache shrinking) drops the last
reference to many unlinked upper inodes, the remaining workers in
deferred_reclaim.work are never woken, throttling background inode deletion=
 to
one thread.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124115850.3512=
-9-jack@suse.cz?part=3D4

