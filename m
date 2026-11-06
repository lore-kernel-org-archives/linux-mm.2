Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CC64606A32D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 08:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bQggY6Sf
Received: by kanga.kvack.org (Postfix)
	id 56C636B05B8; Fri,  6 Nov 2026 03:59:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51D196B05B9; Fri,  6 Nov 2026 03:59:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45C3A6B05BA; Fri,  6 Nov 2026 03:59:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 211986B05B8
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:59:07 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6142B80CCF
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:59:05 +0000 (UTC)
X-FDA: 85404094650.27.1321CF2
Received: from mta0.migadu.com (out-19.mta0.migadu.com [91.218.175.19])
	by imf19.hostedemail.com (Postfix) with ESMTP id B8B871A0006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:59:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bQggY6Sf;
	spf=pass (imf19.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.19 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793955543;
	b=W7UNhBgbK3yPVTXKduvFjhKKLd4a+gyeWDQH2XqZQL7AYEUkKpjYBP6376xC9z08PlpCMI
	sO6CUDesfc6cPEv+7BP6aUCSFHzvr2hc1hIosx4QQfJkuEqodheIYiHaxEbF3A2hCpju1J
	wuP8Ftne4b80bYXe193rE9+6fSJKJsc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bQggY6Sf;
	spf=pass (imf19.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.19 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793955543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yh+ePy4k2Ej6351I944wQj3itVcd2iIkRAI/E3uzaMY=;
	b=kDbDUwPdMBU5t1uVuX54KLkMxazeK+ik0fxXMczqs3sv+XCNe3BblLACQnPbNJSC4ZTyu0
	hm+8XQFy2Rf7WjUn+kc7+iZNMWCyQGEsD2xqLzmU3zlxRZRx4fgvCudr5jEWsOFeRfD1Ls
	bPJSmRRy1BXLmSUSruYB4mbLM4i0Hv4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ragY6FzqrbiIYwHJcjk3800TKOnL9b0LX6exoGgGvrI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793955540; v=1; x=1794560340;
 b=bQggY6SfCbxRY2UHK2EIOX4BV1trzD6hlgH6mA9zcyurzJ9/BA4o5GjbMHM5adXG6nIV92m6
 cMpxhlILSSBPmZnBzNWQYjYznBzO43Uwvukss0Pt0BJJekCqsBaguJ+TuO8AxP9uwGmW241x297
 ZyB076wfrRFg45F4MemmEz78=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id b07fd71a6e5f18a4;
	Fri, 06 Nov 2026 08:59:00 +0000
X-Mizu-Trace-ID: b07fd71a6e5f18a4
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v3 04/12] mm: hugetlb_vmemmap: generalize vmemmap page
 allocation
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261104023510.260766-5-songmuchun@bytedance.com>
Date: Fri, 6 Nov 2026 16:58:46 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>,
 Lance Yang <lance.yang@linux.dev>,
 James Houghton <jthoughton@google.com>,
 David Hildenbrand <david@kernel.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <08143A6C-D96D-4E6B-B7F3-359E9311B272@linux.dev>
References: <20261104023510.260766-1-songmuchun@bytedance.com>
 <20261104023510.260766-5-songmuchun@bytedance.com>
To: Muchun Song <songmuchun@bytedance.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B8B871A0006
X-Stat-Signature: zf4rfiqujxzb4soiwp36mc33beitied9
X-Rspam-User: 
X-HE-Tag: 1793955541-868092
X-HE-Meta: U2FsdGVkX1/mVOSCUKR6w7ssSZd8Aae1zS3fY2gfMOSBxf+DBWNjUaErCy9AdyZHKsS0VqbG1zhocg3gypEl4FRx7lqjH34MWFngUEmZ1OQT58Ijk9tcvceQZ3MXhfgEV9NMQ7xaFziH4Ri7bDhcQWZFb+q8rKubDHOPEQk16OtckOmdPStbjIy1VtGJn8RTmvyugKIavGY1qKrUH11SPyRGXe9VZGKc9VsHu+x7RpNKgSREjS6VcAWVSTpp59x/vBsn53GkKsgRm3Anb5hIkza83VtkWks06jXzd9KCjIaL6lR0gKFUIJA756s6pQWDFghfh8iV54T9GXvcK9gJxzKtjPvXZPA13UYzSr3Y2eMicyAe49tQ88w2VeBCudUDVIqB1xq1ArtG+O4w715le8taFPbTtX71m/SyqPgdL0P1pLX4rBwc6v2HQJJeTFPJmfPjEUbsmrG+3ORGlwCedTPkP7HJPQQJt5NiBUyjqNbGNPDcCxW5cpSq4uNZHOQAVivQ3TBarp00XZneOWur7gLgUpG4NABXpmvqtPc/VKkh86yGCTPUMezAdsTCxPtR4VufUsNg8YAdxHGv4I9n4eF0OBRh6+dbu5KL1ohKWkcjdVD+ae2YKfE6eySz6vHmTmvMbYmEhbwrPZbCFAHyE3wjGDy14YY1iC4Ew7rH8FB4Uce3njYfocpb25uNhzECcjAltXIw/QM625pOURObr0itDEQrwq9grsfmQ+Y+oL4/1WPLveItxi3unrBrHskXggV+BM+AuqRpvvLEJd/lrLNvMlEZCSlBRB2FSJe8rQmFyp7iLSxdh3PwwjE55r2vpXbW4wce07WsX1ijtidlEyY/CwXQQifxRSNQh8ZIYorJLTiscZjbjQrOMdE+OvSu2y9FfaiH3ZNY5+faEK/kscHf3C2GPrn6dgSlKXoiWjV4tPbRDY0gaKj+sH0Ov8+uMj8q6AgDKugkQgt2nh9
 wY1OgvLR
 INtHIAowTtV3UGsZCg+/AF6YxL0+1F8cF4c0bHBVFsnbmT0I9zH+bb0uSPK+iHmfqFD0aoECBh8fr9sw9XbfV+/M6BjuietEECGGw3ODNoqoyMRuk+L4nUiOIq+Y8EBtQbZHU3G9x0EHo/RyIoY7og+wCEvRYZdjS6jRIo+wVeVL8EBzVtlhOq/tVgRmtiklSHkRkcZonXcW/hYu03Osqgft06Rg0px8ijkHS7Kmh599XjssRQ5wMDaCrrKbEJqnIC2Q9gKxRarRFM9WW1fRzIvJdN8e9jY0alVxwQM16gs5AEN8lsXXUJP2+9csDsOi2y5WuIkEsIrIWYfaUlF8ocWIMij9VahZCywLCB4dCGk9fqlWr3kZxC5m173nKfyHDvWz7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 4, 2026, at 10:35, Muchun Song <songmuchun@bytedance.com> wrote:
> 
> Vmemmap page allocation is currently tied to restoring a virtual range
> and assumes an empty destination list.  These constraints prevent it from
> being reused when pages are requested independently of a vmemmap range or
> appended to an existing list.
> 
> Generalize the allocator and give it an all-or-nothing list contract so
> the restore and optimization paths can share the same allocation policy.
> This also allows HVO head-page allocation to fail gracefully under memory
> pressure without triggering the OOM killer.

Before this report [1], I did not realize that this unexpected behavior
change fixed a real issue. Therefore, in the next version update, I will
extract the GFP_KERNEL modification from this patch as a prerequisite patch
and place it at the very front of this series to fix this issue, so as to
facilitate backporting.

[1] https://lore.kernel.org/all/20261104133938.50974-1-zhangyili01@baidu.com/

Thanks,
Muchun


