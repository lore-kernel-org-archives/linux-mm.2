Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B1C5C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 11:10:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB5D56B0095; Thu,  3 Sep 2026 07:10:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C677F6B00A2; Thu,  3 Sep 2026 07:10:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA31E6B00A3; Thu,  3 Sep 2026 07:10:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9BA726B0095
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:10:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3D3E91A04D2
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:10:08 +0000 (UTC)
X-FDA: 85172181696.22.9D3C66F
Received: from mta1.migadu.com (out-244.mta1.migadu.com [95.215.58.244])
	by imf09.hostedemail.com (Postfix) with ESMTP id D8CFD140003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:10:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WJnmmk4K;
	spf=pass (imf09.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.244 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788433806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iD6PqK3AWzpmfSGh6nBF5Hx5p7HsjyZPdAv1ANq0098=;
	b=IHKCxHWJDuaXRY84WAIjVjbzYhs+DUQLqy26VxXgoC9ycOZ8R33AyGdVNb9hTftvoOAVC+
	L5G62f/t0C6YmgWIXo6hN1znJufC1j/oKqbNxcwmonSTXZtqLlxM9mIrzgb+dslwYNm0Gc
	7JNQNB9QfB1RrquvTnfPURu99cFWwsM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788433806;
	b=5VXf2lynHfaABkKXwFIsUW69xJz59FXezMq2YS9IMqlCSPXhqdSRckrBBNJUBMIyPRYEdb
	LH3swdBIoQCGIRZO5qKWo97o69IfYEp8LL2ZmGEok2JMc3/kq67FOvV6h/CYJD/2p6QASN
	3/WtAs9Wlc46ypukJ4a2SgAoGkHh56c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WJnmmk4K;
	spf=pass (imf09.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.244 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5otrudvUze2byo+X815NSeEZwrE2DUwXDl2b42bC0BU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788433804; v=1; x=1789038604;
 b=WJnmmk4K1lwD+FvxZTxhXQZPoHsKevN9Oe4TBRwilQeaLhmIS3FKK0VFOi3kO3aMvvLZiItv
 qztMjvUWyHvrosq08vraUTBD2lu8R1U17yOYhIT0MR7FSfr/vqlXh49fm9koDg+eKJsyP8DjBDc
 /GCPpgnh43OvdbKZIORyNxf0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id f00607339005c6f4;
	Thu, 03 Sep 2026 11:09:54 +0000
X-Mizu-Trace-ID: f00607339005c6f4
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH] mm/hugetlb: charge folios to the target mm's memcg
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260903075048.3316-1-zhoujinmeng@bytedance.com>
Date: Thu, 3 Sep 2026 19:09:30 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Nhat Pham <nphamcs@gmail.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
 Jinmeng Zhou <zhoujinmeng@bytedance.com>,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <A65A41D3-3C00-4EC4-A34A-716C7FFCD2FA@linux.dev>
References: <20260903075048.3316-1-zhoujinmeng@bytedance.com>
To: Jinmeng Zhou <jinmengzhou22@gmail.com>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Stat-Signature: t9t3dcqnjcn5s5xgqfxbwowbbt9gb9wu
X-Rspamd-Queue-Id: D8CFD140003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788433805-407093
X-HE-Meta: U2FsdGVkX1+kRlW9/au9HzVn1yDIscqBo5nd52mE04fChkbrdY43QzTjMMEhwcyWCpFF/pQdG+oM6IQlgj6YbCNex1dwNNb6gXkR5ZAYfHt9kC8KKt1zO5AHEc1vasPpak48JmSCEQGLYRdvwc3jVy4oC5Ch8fxMqA5e4oY9ZXjtKTYM7Eu1plh3JQlHI4Hp1kPYabYMwp2mqOwaee9QG4fRi0Wffc74K5cFTVdM430atLM+F1BVOtmPlbSnK24J8G9GK14nJ+VD5UqJabBKAMPtrkJYmS9F4QJnh3vjdU6O6X+xnq477GgvKobfMoaQ2mvB2rp+FqQ/9k/HyWUmYjL6SLzL0QrZACxJUmSkewGGx82CRhi+szbRDcQGazCinS8bmeiPHmA4Wh9k1klS8D9TkuoxPV6weIatN4X2GWhKu3YgkZmQxCi0fOe8ndfRzHkwcdxPX9V7x/LDpp9jsgyL2hQ8APX/ujwLZd0lyk0nIZ8si6g7fljZqODvh0dlVxwdXcra8BQUAZEYNiu8kBR0tQPsXoaJl2Vr/l+t9GfTdRzIcND7hnV23nRZpsrVaz1wgqF/QUNJHhTi1IY0ukjfehHTklrDrBXl6mRvKPUPvluNafqEHjX4S603th+N4pDLJx5a0uiArFnhW+A93sv18En4uErDb2W8OLizFkXWZGbEInpPpRlFGCvWlYCmTcgGRn17F42RrvyWhBGhMVce7ysNMIYJXZuvXL+JHqvFL76tb8O+gxIYbLyeeCLH8MHqjyAi+sx0VlYEgxJgKyxcZe/W01Xkv3LgKJhSgtI0dxbru+kGywJvZT4gAcnWp8ptiAXYu1RPC8i4F9qTX+hupsZdzvC6893z1n9JY/Z0A6qZKRVGy1wuKG3gRElMN/t8lXKqsut2QDk+gculDR2XiQYmrEtABIrzweQqflyUUS0bXWPDYE9q0UR0r67cPGq+jh5qa6S1rcu8UzS
 YzUeURJ7
 O0OSOBmVJCg1J5fMBu7oXqDf+AOgki0n+S8cwFdZf6OtY+Q0/OXKItXe3apApBHoKqE/AYyhm0U9HU0Qr+JLLuu22k5RCTKNmix9rHhL7nMJuXqUQnYKFL5D6xRvbLfSeEpIAA4Vm6iBG0CLzTkIYx4jMez2P9HR4r+X/qNcNetdj2FIXfIcp7ClcD/7GOcBA2Ru4WLTsn38Xho5NNWdKdBWxqKLahAADlLrAxdwq9zRNeoZK4B+70MbbZp6BBXlrE4Zg4qeCT5f24FwoseLcykxWXeO5czxQMo43G0gJDZkZ4r69vtdf3sbKPnMzMNW/RoNL962BwCWXML4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 3, 2026, at 15:50, Jinmeng Zhou <jinmengzhou22@gmail.com> =
wrote:
>=20
> HugeTLB folios are currently charged to the memcg of the allocating
> task.  This gives the wrong result when a userfaultfd handler =
populates a
> HugeTLB VMA that belongs to another process.  The UFFDIO_COPY ioctl
> operates on the userfaultfd context's mm, but =
get_mem_cgroup_from_current()
> charges the folio to the handler's memcg instead.
>=20
> This can be reproduced by placing the faulting process and its =
userfaultfd
> handler in different memory cgroups.  Have the target process register =
a
> HugeTLB mapping with userfaultfd, trigger a missing fault, and let the
> handler resolve it with UFFDIO_COPY.  The hugepage usage is then =
reported
> in the handler's memory.current instead of the target's.
>=20
> The generic userfaultfd population path avoids this problem by =
charging
> folios to dst_vma->vm_mm.
>=20
> Pass the target mm through hugetlb_alloc_folio() and charge the folio =
by
> using get_mem_cgroup_from_mm().  This preserves the existing charge =
timing
> and error handling while making HugeTLB userfaultfd population =
consistent
> with the generic path.
>=20
> Fixes: 8cba9576df60 ("hugetlb: memcg: account hugetlb-backed memory in =
memory controller")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jinmeng Zhou <zhoujinmeng@bytedance.com>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


