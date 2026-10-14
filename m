Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0800CCC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 15:54:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 019106B0095; Wed, 14 Oct 2026 11:54:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0B7B6B0096; Wed, 14 Oct 2026 11:54:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E21996B0099; Wed, 14 Oct 2026 11:54:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C122E6B0095
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:54:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 58D20C063E
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:54:01 +0000 (UTC)
X-FDA: 85321677882.25.42AEF57
Received: from mta1.migadu.com (out-162.mta1.migadu.com [95.215.58.162])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9127918000B
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:53:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JWi6jDbf;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.162 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791993239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MhN9D6NXrx9SnwQvvqNg5KTJovI0z9i5W6ocxUfyflw=;
	b=J307ZIcgLpPLK7rXyWDm0b5Bq6bFNFtkv9BaBH7E60mXqyDKtl2m7eA0fZ/qaxlKWl4r1O
	mKkC9lH5cf6dqwG6ylwt96rXuAw0mnu5oKOydTPSz4lX4s+gpFJbOzZTJMCEMldDF4fVkA
	i8b1vvmei5osQtAXmcDluqXU8iixhrM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791993239;
	b=LAFRt+oNOmoXT1WFCIKKRFYCUzgg62dFuWmSOTe4bad/JVBoLFRfFXyH6GFj4dVikvjPmU
	y9XOsT/PDaznOn548l80HO3tG/GvyIC08Z5NGVfhO1dZ6iUDOGWaLFqYaC/YKGgr/GCPvu
	qYUA0uUZt0YhHEnVidKKue6t+dQfcdk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JWi6jDbf;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.162 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=p+hCb4x/CFHYwH9yYx44YPMASd0huLS2Y6U4//JRKyY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791993233; v=1; x=1792598033;
 b=JWi6jDbfkkiKxiJT+LNK+N0Q+ku06M+R0Wt1SskBPpelXFgsycEMyt9XS+MnbE+g0eAtzfM5
 rx4gPrdptXFp19gddFYWNAAntyhOjzMPlku28voKkb+7jdNJAy1m5EOjiieen0tnIkLvW23aA66
 49GiVSVZKSJUk22pwJCXNiTY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4026790dd114785a;
	Wed, 14 Oct 2026 15:53:52 +0000
X-Mizu-Trace-ID: 4026790dd114785a
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	benh@kernel.crashing.org,
	a.p.zijlstra@chello.nl,
	riel@redhat.com,
	ngocthang2710.1999@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+49b1021becba70c1f3f6@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm: disallow ioremap'ing ordinary RAM in generic_access_phys()
Date: Wed, 14 Oct 2026 23:53:41 +0800
Message-ID: <20261014155341.36130-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261013-generic_access_phys-v1-1-b3963ef76e37@kernel.org>
References: <20261013-generic_access_phys-v1-1-b3963ef76e37@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9127918000B
X-Stat-Signature: bgz6cih1dphke3w99hioki8arammo7rn
X-HE-Tag: 1791993237-582049
X-HE-Meta: U2FsdGVkX1+ioF6fPPhGZRTQvBb+sujxxkdCt4oW5Anen75p77b606g+S8ujJVZS40fr9cJOgf3fIMVw67F1FNHGea8k8MI/m6qFEuGwHAT+CQsL+l+Wus9P6PuA8BpvSegwnMZYeITxzsRkhdK6Xezw0ZL0t8WfLKC9gZDo8AQsk/remIj1ZBKWg9gQYAjVCgwWdu40mH+1euqcRmTkChlwqUtiG4BUF07NcHOpre4DipMPpTuva1WqRcXk+fUIi6uRtiO1Dn6cT07LheTL3xArPimZnmSAL6N4kpKMvYVl5MXJRcGCU38h7ZfkfzaHreW93ySeQhQB0klU4w4BOv1kf0bkY2aZeInUUUeLSaD3JSimVlis9en4HaW22Ow1mCAN/S10Blx7eTJtbyKea4+X3jWphENQ6lUlDAXFsmnQqIutiLPwtMpV7OlWUC7kZQEnhNbPKFons+UyIo64D+n5rr8Y/59i8EB+luTGGwW43kB6Ej24QK7pOgaJBpKZgSDAz++X7aFV6vf2eYiFrf6vyWfn2+YxUsUUUtSJhtc3go0dqPu8+J+njgW0lRUfoBnFGkPx9LTi2Euq6Va2w5hJm7YBjxID+K72a+26Ehach7mdsjMp3dpuraaVBSlMzKbaJWul5nCxT661SbYuTWoYPAgIWI03wrkOniWU7/jpgO2PNmeEQNMpfVeXxuuF7hHXOWPIXFnZQu/jiUB2i10s0/HoHBMiyDiL5EAj35hzuDt+xuw2jTRNjzSxT/UwFnxwVdoROy11Zkka7Vu/aLELVQwMSzmeSm1Hll9JB7P5BaNWaWwA1h8+UNxe+7LJEF3rMLwiOaZjIigVWp6zVMnH2iwcAHyQyT8LbU1sSDuB9mJRenaXl9JrKdCVEHIdC7AJ6OM7GVOYglX/uA+j51Oj+IYW7c8nRG9dqG2M+fJ+F64i/Cq2tDsVJa2HfO+5FVGEHR7yWFvthiCYczi
 Rm05EVRH
 bG3CGVsiIKZtnuUoZbag7All+A3rjZ+iS7b90b9HrbAMb9A75LBveqXU5lFsxQFE08Wacgx/Y5Y7jN5wyrnLZtl5MUEz75yRhF3zPvLNO1cha+bVYfcfgKFY+jkKKyidh7NcQj3p7DNPMVhTEZdJ05bHFH59arbb2wQQWUleVy4zvY5dZW+DYzV+ckiA/veviAHcgp/emaJLVJ5XZ5It6ZM30/tPESS7MGc2a6oeH5NGxgTX1G2UE7ayvO8npyppnRgiuTayrqSQ9gWm/Qsyq3MZmrMgWv3zgdKu/tyAzqJ+VjDGRunQFyvZJaVWoJxdrPCmvNFxm+wwQwyLyjR7qeN08Sag2NuI6Yx2HTIuj+KzZUfilZ+bSPsObGqdJuTp5LaewFK67T4VVhYKBRJYb0jE0o/66Dvva4nH5Kot0d8aI4zFTNMZovdNft3YI42CxgMoFK51YopxXRkO5UEimFytChiaciL15/yckuVkwPJG6XGrGX1vvAd1iXDfO898qjUNF1TqS8BjuLnig7CkE8fbPZ1cCYvhz0HvbNhJaOgH7+77n17fr3dgCX9CD5faJyYi+JmYxmuf5xDY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Oct 13, 2026 at 01:41:24PM +0200, David Hildenbrand (Arm) wrote:
>generic_access_phys() can end up getting called on CoW PFNMAP mappings,
>resulting in it trying to ioremap anonymous folios, which especially
>the x86 code doesn't enjoy, and which is in general just odd/wrong.
>
>E.g., with a CoW mapping of a PCI BAR:
>
>ioremap on RAM at 0x0000000045623000 - 0x0000000045623fff
>  WARNING: arch/x86/mm/ioremap.c:216 at __ioremap_caller.isra.0+0x4c2/0x5f0
>  Call Trace:
>   generic_access_phys+0x130/0x4d0 mm/memory.c:7178
>   kernfs_vma_access+0x1ce/0x280 fs/kernfs/file.c:437
>   __access_remote_vm+0x58f/0x890 mm/memory.c:7256
>   mem_rw+0x2a1/0x670 fs/proc/base.c:912
>
>But more generically, we should disallow access to anything that looks
>like ordinary RAM in the system: including allocating memory (e.g.,
>alloc_pages) and mapping them in a VM_PFNMAP.
>
>For pages with an online memmap, allow only pages marked as reserved
>(PageReserved). This also includes memblock allocations, however,
>distinguishing them from other MMIO is tricky, and nobody should really
>be mapping them in a PFNMAP (except someone abusing /dev/mem, which we
>do not care about).
>
>So only allow access if there is no online memmap, or if the pages are
>marked reserved. Reject other pages with -EINVAL.
>
>Note that, just like other pfn_to_online_page() users, we won't care about
>concurrent memory offlining; mapping memory that can concurrently get
>offlined is highly dubious.
>
>Reported-by: syzbot+49b1021becba70c1f3f6@syzkaller.appspotmail.com
>Closes: https://syzkaller.appspot.com/bug?extid=49b1021becba70c1f3f6
>Reported-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
>Closes: https://lore.kernel.org/r/20261001152524.171115-1-ngocthang2710.1999@gmail.com/
>Fixes: 28b2ee20c7cb ("access_process_vm device memory infrastructure")
>Cc: stable@vger.kernel.org
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Nice work!

Tested-by: Lance Yang <lance.yang@linux.dev>

