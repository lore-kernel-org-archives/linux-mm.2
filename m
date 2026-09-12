Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43DCCC88E45
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 07:24:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 968AF6B0088; Sat, 12 Sep 2026 03:24:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 919386B008C; Sat, 12 Sep 2026 03:24:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 808236B0092; Sat, 12 Sep 2026 03:24:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6738D6B0088
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 03:24:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6B5E71C21FC
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 07:24:40 +0000 (UTC)
X-FDA: 85204272720.04.7433E53
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id AF436C0006
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 07:24:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=u4T5MVu6;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789197878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0cVaMglGGiME75tsb7SvlcJkfEJutw8BxSeMbD4GcdM=;
	b=1CgWA0JyL6l1g+PKgvVUR/3t7NQN3paNG0BIcKqJVXRe+59XelGCaiPUrMo50NXKD33Emg
	chzSk03GRWuHbJBb7vKd7bj6oXm3pYJonSaqkUUxZLuPOWLzKSnaP+nJ6UymR+zarJRNlK
	bCl5btDSw6qycf4WmXvMZhhcxGEQEqA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789197878;
	b=DrBbhSZe46iqDqO1r3R4IY2FYsXIPmlBzxQAEwFeBV/f7TcuWvgCLs2lBkaF26G6h9sEX5
	4LMdYDnKAhAsizZTBKIz9/KGS9QnHpeZCxRYounpLTbw+kqZdBmzTwlA+hy/KRd50GTEMB
	MZ8eCXpqJLe0/UaTQ3fAA4drytJ2vm4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=u4T5MVu6;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 63EB660204;
	Sat, 12 Sep 2026 07:24:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D351F000FF;
	Sat, 12 Sep 2026 07:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789197877;
	bh=0cVaMglGGiME75tsb7SvlcJkfEJutw8BxSeMbD4GcdM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=u4T5MVu64uZuawXIlBM7drVa70yy5BYJ2yh6jb//uLAo+4ZfEmFSzfT4UXOu0bmUw
	 es5sSjwkUQXaXwOvvFFNNDQkkU89KRv/JEsdfiyyh/5Wyxb8NCRP0IkdEQyXedTZgf
	 A4WLQ22J62HhIKJIa3X+2u738nfNxA9PATyYjSfw=
Date: Sat, 12 Sep 2026 00:24:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@kernel.org,
 willy@infradead.org, jannh@google.com, paulmck@kernel.org,
 pfalcato@suse.de, xueyuan.chen21@gmail.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v4 0/7] read proc/pid/smaps_rollup under per-vma lock
Message-Id: <20260912002436.0605a85b912eb8ae406cecf0@linux-foundation.org>
In-Reply-To: <20260911194145.1781926-1-surenb@google.com>
References: <20260911194145.1781926-1-surenb@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AF436C0006
X-Stat-Signature: wg1jx8tcnkfthib5eg1cq64kgngb1npr
X-HE-Tag: 1789197878-271687
X-HE-Meta: U2FsdGVkX1+c74BSCBb3zasddqzVlHTcsKCGHADfVH+jT8/pvuR/xC/5TstFndTWSfroCO1iRjfpD6hdkKQzQlgiGbv2ECb0azyGNvySscVDQ+EotH+J9Fot9UQ8X2n2C0kgN6uRVCX9uTI63sxuNLv0n7eVIxQADCKLjcYPqT0BqdHxr703jZ6wV2Hh7u0PCrdXeF1iKaplJwYq2SBn7/B/R9eYwRuGjpCo+5CNW9qjsc+CBgpDPlX9KVDAulwVVHw0g5vdJMuL20UCAhG/CCQF87NlbqTBgDi7a+jjM+zYRsg15z9+Bqdz/Z8jIDxYn789+7hK+eNfb/8D/ZCOpRTzL0aKqqXKSJqlkZG1IInZmT6L0DZ+8rlG+WtOfNUrj5eJDrIUQvIy/6UAUMigodA2agJSaqWNWBVWx5E0f7Gn753RnhflBo5SPUfh5EheFVInqxc8Z3FYM6tN8i/7PVnexF830edg5IVmTFqyDYjPSUm0i1qrmd5rNGx2I5Pn1g2Flla/bwIWDdXlrV875qJEBKAqoMqao+MBuEPbDcQx26412zfCj5C/4OR0gRzgw9OXKgmrH+TkSOT3Zz1JEMbYaUw1a59I0aVACgcqAZdq/i3zC00t6wd5fVq17bKAXqgLPDKi5pWs0Nv3OxQFVT2K7JXaF8Uc0+bHYMpHLKQWOc2AOsAkOh+GfppkF7bhLFVZqYnxyz2Y0ah18RX0kh6QyojIiTAL+FF08/8TqQC7roybYfgKbwO0L4Eo6GWrOpTw40a6bxph1b+k0b7u6svxrZ/vLdEj2MW5Iz4YNZfB0lsO+KlgV8VXhp78eAtIxFOTLIMuMzxAerBMQyPrcMJbyFQQOQcWwMht7MT7mTfEa0ao68lAlg0J4l6kuUPjDXK7l4OAAWaOQEya13hW7R8/dBHDUoQ/o+ur3X2m7Oaze8gUiFJ+NxA9dC8sOXe+v/xEbz0iyKfF5MZyDax
 sLwPZu8r
 YPnqXLemySE8xg3brrNgH6ziUT5WkAazMWuW49Cr7j2Iczh23fGcKmhQ06FfHQrBWOspKtjQ38cbacBOZhNf+vLaOT3ikgK46hMR0KWkLb9MEYf1hgQdGLPR0d2ZiTqEAWaayEzOXC/V8LCyRSroiiey0XI6wjbNKRCus/Ycs0v1ANA1YHi3om1nYpvINDuSi3D+uc8sHYdSC49la7OPZyF5lahKf865mTNcJhqGdJk7Oi84zBeu+ZbrgAinmcaiqhYKgZnZHALwuoAffrEfK0QF6gUWZXvaYV+GMZQWDqJ9RJgtu35Ntv48IRfsYzjOC7biesrGGDZgh2qE+iPLznK+aukMAIxhgXj6KpFgzZUsfIEievNlo0mkSDkahlD+q4zZcodcg445Y8ZK8TdlneENr/mgl/6DrZZAL+3SykVSWMWX+32hqOj6J23Ts4yspkRhmvGSoDbbmX0U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 11 Sep 2026 12:41:38 -0700 Suren Baghdasaryan <surenb@google.com> wrote:

> proc/pid/smaps_rollup can be read using the combination of RCU and
> VMA read locks, similar to proc/pid/{maps|smaps|numa_maps}. RCU is
> required to safely traverse the VMA tree and VMA lock stabilizes the
> VMA being processed and the pagetable walk.
> Note that we have to keep the logic to drop mmap_lock on contention
> because even when using per-VMA locks we might have to fall back to
> holding the mmap_lock.

Nice.  Queued, thanks.

The speedups described in [6/7] are significant, although I don't know
how representative Paul's tests are.  Probably not very.

So I don't know how much improvement our users will be seeing from
these changes?

And I don't know how much usage smaps_rollup gets in the real world?


As I've no doubt you know, Sashiko is saying things.  About these
patches and about the current code.  Its pre-existing
clear_soft_dirty_pmd() driveby find looks significant.

	https://sashiko.dev/#/patchset/20260911194145.1781926-1-surenb@google.com

