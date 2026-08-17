Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D6E9C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 09:25:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2CBB6B00A9; Mon, 17 Aug 2026 05:25:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDCC46B00AA; Mon, 17 Aug 2026 05:25:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCC396B00AC; Mon, 17 Aug 2026 05:25:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 945C56B00A9
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:25:15 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2C727A072F
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:25:15 +0000 (UTC)
X-FDA: 85110227790.06.CE31C8D
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf01.hostedemail.com (Postfix) with ESMTP id 87CCB4000A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:25:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=efFaE3FZ;
	spf=pass (imf01.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786958713;
	b=xiqfpZgPgDnu7rkHjdq6SNVKGaeipA4xv7zUUHQBJ9IoaGI08oKbKHnK562tr8GWIpfvYR
	bdQiwBRhyQryhRgIh5vGOq50eyydOPJnfEYilPm+GlyShfQBWnc1q43Mpqi4jRYRZZdnJf
	b3Z1fc1Le/pOv83x/JSHPW19p33zA1I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=efFaE3FZ;
	spf=pass (imf01.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786958713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wfxXdDZyvlR7gi3sGdbS2Ktcggw0+UdswiSDH3i1yZk=;
	b=616HO4EC8zagvhiLTohhwpdcNHaOW605kCr/Fjd2hoJke0Q3UD13vxwAy2pXv7JhR9uBqK
	IfeFsKvbjzjZNtAqLWjIFK1YvSPrX9aS08roChvtN6k6sGQf+fIO05ABXR1R3DEghJXxpK
	YZ9BuhmlElifWpmYo+1MQVklbTidZtw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=wfxXdDZyvlR7gi3sGdbS2Ktcggw0+UdswiSDH3i1yZk=; b=efFaE3FZCI3aY/RoCYLc4/S1dD
	+OFGkjBOUkzB6OMZS+4bmrQtnzT3moadGXO4gVWLajyRrd1YifgYiasq3c4eYTWIDo4sg1k1Ji1Sk
	1/CrVEBA7m+30I9sFwI+Ik5LrGlXLTZqvxQIEeTB3Pu0YBo7uIFikp7vI6iFWO6c9BCHo2L9h0tqv
	nC3/IfiQvrZgk9UF4xwcBLiiSOv582i1WvHs2JwXAo+UGzsYEnBbFSOxd6Ykgkgj9Zgc5vTsB3/yQ
	LE6d5oRTo3S/6d1YTbxRtZfXuQrGM3cQfChz4BZNuTTG79UZB/WfuT7YFLjCzL6UmvUxfJ9F6g7Th
	AUbTVKtg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wvta3-0087nk-05;
	Mon, 17 Aug 2026 09:24:31 +0000
Date: Mon, 17 Aug 2026 02:24:23 -0700
From: Breno Leitao <leitao@debian.org>
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Peter Xu <peterx@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 2/3] mm, swap: distinguish a malformed swap entry from
 a dying device
Message-ID: <aoLSYE2Pft7kRZFA@gmail.com>
References: <20260813-swap-v2-0-4a625ccabdae@debian.org>
 <20260813-swap-v2-2-4a625ccabdae@debian.org>
 <CAGsJ_4wHxYvU2j8Jon6yv=7dGhwFEHzvFB+yYFhn_PFSseT2=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4wHxYvU2j8Jon6yv=7dGhwFEHzvFB+yYFhn_PFSseT2=w@mail.gmail.com>
X-Debian-User: leitao
X-Rspamd-Queue-Id: 87CCB4000A
X-Rspam-User: 
X-Stat-Signature: p1bnmd7r7sgz4a7wkrs8w4cfw4sdicxz
X-Rspamd-Server: rspam06
X-HE-Tag: 1786958713-294690
X-HE-Meta: U2FsdGVkX1/qeH53TnwX7Bj+6xrKGVGNYlycBHR125kSLZqjI2MZMySQT/rLj68jc02cbnmS6+NCojMztEbNDIkRXDmeatsRjbSxtDG4knEUhZ7jdvTMQxKFE3Qxx+TqRJAMW4Qlf58cpVExje/4z4U68EmVh2ObbJenj2Adng2HiHlUcIVnorZC5w9rrAPl7bJHhVsRWwaZLUP6z3y5dq9ZVfHpw/oTPttioK4xr7j6ce0OFocNA35gA9B5L5isY+oJDYTonQJ2+zHicSwNzzvhAEPr9sR7tl4SfLOUZNsC8VfKZ8S/WiP2xmPEkpC5EvO+aEQ87JTDrK7tJa6Lvxu/g04k2HDAj/tUKALYt675CF+f84IBsrwkDiRBjWm9MqdjBabumYWl1tU9dcO+LC/8uOTRmKTgNbUU8FJ4fnDfUVUUwnh3n4AkKSLhdPYws+oYRPvzNxj8d3kGl/TTIWCWf/kqnHgWiuxfpEM10a2orzrESpW8tmI/4/FAF3T38Fv8shOO2rtf7YxBRPdGjrLKqJKfps7vJSNI86XGfShYNWVV72/geMeKtU1OzxqPx/tU6itKEpDwc+cWvJD7LmeEWYiB4QU53Qlh/ItF5Ys1I+MumpsE+hNbJjaFS8TBtPjyApzAHCTTobPCBowllB8AgjxfdnY9h0DRnI7eYxqRWgnXJsATWhIARfP9iN7xDInlCgpuyCzdzmHb8w0BE6FcwtdbYy7HaUyQrZuLKlZsE/KyY8eNeGRz1rjfP5r2YYvQLY11jMd8v3QGMkzZ8VNE28gIC3uT57CnizOYU+MduxIF/CTta6irLsgrhdKd6b5jrUbbt5aHGqEPCKAggu/jqFEQWPnBey0GURg7CQ802B4x49GvLpiS/zMGBgFLr2bVqVM7mblDkES/nZD8XlbYROUqT9Vg3d3EpI/sLWDS9VwmUvo9RP3F9hnrilJy6IIIx+M7yYfe5iCGpOF
 8Vnvscpj
 qQyc5ZnWADhHNTkzEMltuPQ59ZALsxhNEgPGSlyf56xZCLGchswE2GsMm0h/1+v+cF3BkACBHaUEtLRGKzgrQgF+/oR+SDZwwi0Jlo+ui9gGJCtxMdP+hX5ZEoIwWFzpI2px24dmiKreoFHeLiXeuIkJaVIZi6/MHHxgblTJMp/dRyisixQAz65SzigWbMgeC4zvfbySVVH6Yqlxr93ozhkLwPIhSaDV+4sSx6BToF7EWV6L6o3xgPvHYKbUvzdKepsWW6uQCvifNbiNYpvorelPnnX8xc1X3NOtDNgKzNmfcUfU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Barry,

On Mon, Aug 17, 2026 at 06:20:22AM +0800, Barry Song wrote:
> On Thu, Aug 13, 2026 at 6:02 PM Breno Leitao <leitao@debian.org> wrote:
> 
> Do you know why we’re seeing corrupted PTEs with `bad_nofile`?
>
> Does this issue still exist in mainline?

The problem seems related to the problem fixed by commit 366a4532d96f
("mm: fix the race between collapse and PT_RECLAIM under per-vma lock"),
but, I am less interested in that problem and more on the behaviour of
this code path when problems like this exist.

I've got this into this issue due to an overflow in the kernel
monitoring subsytem at Meta due to 7 machines getting into this state.
:-|

