Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A89CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 21:55:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21A188E0005; Mon, 18 Aug 2025 17:55:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F21E8E0001; Mon, 18 Aug 2025 17:55:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12FE38E0005; Mon, 18 Aug 2025 17:55:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 017338E0001
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 17:55:42 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 54274114DD0
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 21:55:42 +0000 (UTC)
X-FDA: 83791235724.08.EECDD4D
Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	by imf01.hostedemail.com (Postfix) with ESMTP id D058140008
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 21:55:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=codewreck.org header.s=2 header.b=moSNTz60;
	spf=pass (imf01.hostedemail.com: domain of asmadeus@codewreck.org designates 62.210.214.84 as permitted sender) smtp.mailfrom=asmadeus@codewreck.org;
	dmarc=pass (policy=none) header.from=codewreck.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755554140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=auLOhWoJLzMo5J4E2hQaw+rrZVFMM1bMgBRMGY/PL2o=;
	b=R9rTlqFETBQPKanAnUC7EF425mRQ/xuZfr1gYwRbVkhUXGwpgbpE4DVA/EWWEJGWYqJszN
	SimFaVnduFe6y+NSbYIXxbSeqSqrKCrIURvX6YjfZC9px6HZiah24DzFogXshHnyPXp/cf
	bl/bBmgDBilinx8H4Lk/eeDsswuRufo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=codewreck.org header.s=2 header.b=moSNTz60;
	spf=pass (imf01.hostedemail.com: domain of asmadeus@codewreck.org designates 62.210.214.84 as permitted sender) smtp.mailfrom=asmadeus@codewreck.org;
	dmarc=pass (policy=none) header.from=codewreck.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755554140; a=rsa-sha256;
	cv=none;
	b=PrgKVVGq6p6W5zRbz1oXOaqyXcuG97j7z7s5IJcKVv6LIBQrt6/sBknxaE083qjbSXXhK0
	FyPLZV3fu129PEju2mVxfUpfQcLyccdfDoWdD0XWhPUEPjK5RrvJEFKWDwxyVxxbz222Pl
	bG4Vi5LI1wlGZkxChXoM/ZTFmLBt0Rs=
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id C157514C2D3;
	Mon, 18 Aug 2025 23:55:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1755554135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=auLOhWoJLzMo5J4E2hQaw+rrZVFMM1bMgBRMGY/PL2o=;
	b=moSNTz60+w3p/T7Zd9IShd1kdgP0RV90fFSfnL1+vsHRSeh7tj/xyJii/z3OkUe+FH5nC6
	nDIO9qHEMECFFjhGZMOLkqH8yUAM0Ai8uTeYNHFA90EYfsqxqbzBhPJ+TK7a9bv0eiGMuP
	81V/4OSzpxsKhGaX+yZzdQ9VeD8rJB4c17ywfQUb2sLa7sGbm6H1iJ4i7zTPzIdcG0EAD6
	q6aVhSJDZeodIqNpr0c6vxMg/IC8+57UCNk1ybDfE1powYj1yG2Q1Dxrf1CCkgRkQCX7YC
	emBsonRLxlE+KQdqi/00x1h+EfKsFJb+q1hvEaIK9T0W8yoWtDdh2iA66ixJYw==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 05349875;
	Mon, 18 Aug 2025 21:55:29 +0000 (UTC)
Date: Tue, 19 Aug 2025 06:55:13 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: syzbot <syzbot+d1b5dace43896bc386c3@syzkaller.appspotmail.com>,
	David Howells <dhowells@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>, akpm@linux-foundation.org,
	brauner@kernel.org, dvyukov@google.com, elver@google.com,
	glider@google.com, jack@suse.cz, kasan-dev@googlegroups.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com,
	viro@zeniv.linux.org.uk, willy@infradead.org
Subject: Re: [syzbot] [fs?] [mm?] INFO: task hung in v9fs_file_fsync
Message-ID: <aKOhQcVwLd1Kvt6N@codewreck.org>
References: <20250818114404.GA18626@redhat.com>
 <68a31e33.050a0220.e29e5.00a6.GAE@google.com>
 <20250818125625.GC18626@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250818125625.GC18626@redhat.com>
X-Stat-Signature: yb6t67cjj6ipzfq3zk9sscaukzujj683
X-Rspam-User: 
X-Rspamd-Queue-Id: D058140008
X-Rspamd-Server: rspam05
X-HE-Tag: 1755554138-825672
X-HE-Meta: U2FsdGVkX1/JFXxbNKfWFDnVuh+optZxtNwkkAt2MUKzShIJxLTr9sr45Aznnte2vt8jNIvLBedaDsNy9n2HtBailx+hYt6a7N6dCLGkzhgCe3iZLGS7bEXi3QdbQA27fB+OTzzMu/yQRft9HQcbBnfInMjXvX38Mp2sdVxOcYIfCadmOudtYDzExt52u6pbTdIPhAOzWV2x3pKE9onGSbxCXXnCIZXjKOvkn9FFX1eJIbgXABB+6H1Y+oc5ffJGX9STtUSlwfv0fnEw9zxVmElS8S3FI3jSwU81Sk03lMsvtdMz4NtodcfLpBTA2MJHyro1R3ENUo0ritt2ZFTw3qIVxcN1y0+C/auQBUvNnKUDf1TCksNzkLngaDt+m6UlqXVE8EuDRxrM/JKGc/DIyBjvjh0bK8w8ipI2uGUnLBXw1WOHJ4k4iDbGVlk8RYZn21k+GgeZlweiPF7fke6WBaL2k22ZR+N6ovh+7LOfqCGMAIPbyo6TcIkeh/A6aPBjp9dj5AKytKVDQ/uGFOuId8izxUpbup1NiG93WHi/hdWhl0CSU8WMKiQsYVAEBqpahlsj2lWtWWU2XgTctDCYoTGuyqxA1id0K+4uQXc26hZwW1UsdDZgRH4rTZFutcelZAVyB9q6A3YbWkTJidOuqhlaPt7LoOVGVRpBH6CJRPsBbT8TR815xA83cfeD4xgIpj4U+V9bGvm6deoFjrE3aWk+E/kb+EDt1kGYboKvCgLY/Ci8JLzB2pMAmUrTZoYkZvLiupd6aJhs1yQhWqsd7oKyaXZqevyRunwGglOalKWh6buXc868fRiTlPrNmL78GGMEa3GJK0vIvHy4mYROvDY6mJeEozjl8H7iWbJ84uG5YJn1pjUvtzyMx9suRRwbIP6O99c9UgPadgaz5lqVGr4Zz804gJyWBsT/WoWQ22PYp2HkxTAlgtMxgPmS23G46deR7i2dUe2bdd4Gd6D
 UNQPA+FO
 k0ZHJ/FvKZ6WlqI0fj3lKL5Wf31xqordA2tdH/8vSQ/jnwSo9tbiVprqik83RL7960WUWrJp84FU+I8rdvGRc+6/zfFbh25aGZAy+lLzEmK6Al3RhyjY+5pyZMCwc/McquJ37hiLRiQSLAByNQIVdOpjzbImht5XY4oZyg+77KcviBFz8ZJ0nOp63JzkGC0OCZdPy2pO0zb1QCR7k+NuTyDvYh7e7x9SprFA8JoLK4m1VXyCuxU+ya5lhKO3gZQ8nkIy95g1DBHUR4T9JFh2xqL0WkoKwQQfbmhITGMj+XG+l0DG1/qKlZposKbXZSJxJeWhiutJzN4v59i0WAPZHnNc026P2C8tsK9/1iO4dgnaWB3krX+O7WU3nS9cNCD9f3oIdSgQ11+yvJA9pxHs0On2ttZGRZP5ajuhc83etmmgnfxVmH1RaXC/FP0YhlwkW+s0PuMCZC5oBEKX9IgIEPtsNQ6NVdBypyh28Vqyo7TywEhO4TpLQqAbK5AnJR17yEs7d
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Oleg,

Oleg Nesterov wrote on Mon, Aug 18, 2025 at 02:56:26PM +0200:
> On 08/18, syzbot wrote:
> > syzbot has tested the proposed patch and the reproducer did not trigger any issue:

(I hate that syzbot identified "hung in v9fs_file_fsync" but doesn't
bother to Cc 9p folks... all the time..)

> Dominique, David,
> 
> Perhaps you can reconsider the fix that Prateek and I tried to propose
> in this thread
> 
> 	[syzbot] [netfs?] INFO: task hung in netfs_unbuffered_write_iter
> 	https://lore.kernel.org/all/67dedd2f.050a0220.31a16b.003f.GAE@google.com/

I've re-read that thread, and I still think this must be a problem
specific to syzbot doing obviously bogus things (e.g. replying before
request, or whatever it is this particular repro is doing), but I guess
your patch is also sane enough and the 9p optimization is probably not
really needed here

Please resend as a proper patch, and I'll just run some quick check (and
a trivial benchmark) and pick it up

Thanks,
-- 
Dominique Martinet | Asmadeus

