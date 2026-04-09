Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 806E1F31E24
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 15:16:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDFF56B0005; Thu,  9 Apr 2026 11:16:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B90836B0089; Thu,  9 Apr 2026 11:16:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA6AB6B008A; Thu,  9 Apr 2026 11:16:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 971A46B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:16:24 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 00A2AB8947
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:16:23 +0000 (UTC)
X-FDA: 84639368688.22.7ECC680
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 15B894000E
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:16:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=t1sJz8BS;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775747782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9LViphAnsyTz1I6NktxxdXW8ZLG0AdJGKa/bN6mTrS4=;
	b=NkCiSQ1TULmOxAFkiLzxulAzvFWb6/M5GzAE/s/Tn7hq3N5NGgeVHUhta6cnF2m0zPdyWy
	Y6rityWtGQjkzf3YdHFIWf5YilBxIw9cUUy3eTiOhnRjEZvQIXioNviRvvnjEz+OqvRcp/
	dI5XVYEKjNC6yrox1xEuGSounSoNzA0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=t1sJz8BS;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775747782; a=rsa-sha256;
	cv=none;
	b=5wJkDYNXVZ3eOp+cF58avSN5GVpEclqe4X4qzrqZxxiT82Ej+2AxIFYsONUizeDrx9Ft3G
	NbzbgMJRPC5fOMtMjySorLLug7ddLzlqx7bUhrly66rHWM5pN46tAZ5K2wvVK7bjXIsp30
	bJA2YHVt9QiE6xHbBJYCroa11oQ4i/U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 62F3760121;
	Thu,  9 Apr 2026 15:16:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DDA1C4CEF7;
	Thu,  9 Apr 2026 15:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775747781;
	bh=NRKq+/N1Oan7jLyZ9+A5D8ECK5bq2ALFcqnhvY5EmUU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=t1sJz8BSJcak3wgyLS9gmnPb53hxdl1aFIn0qiFxfKSbiF1DIQd/YYQQl1TqertD4
	 AykNet1E4uw57tGQ7QGENlEqT8TNCGoR0HLfRDVMtU0intELEdFeVIRHM8MMZO4imE
	 v2CN1FGyLvpmAKmNbfOqU00F1gZx+28qYI0R+utU=
Date: Thu, 9 Apr 2026 08:16:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>, David Hildenbrand <david@kernel.org>,
 Christian Brauner <brauner@kernel.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Jan Kara <jack@suse.cz>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH RFC] fs: drop_caches: introduce per-node drop_caches
 interface
Message-Id: <20260409081619.34f172dad0e5a56923b7eb2d@linux-foundation.org>
In-Reply-To: <dbb92553-58ba-42e1-b7df-b8450bd69d33@huawei.com>
References: <20260409063503.3475420-1-wangkefeng.wang@huawei.com>
	<addP4MKmA8zfSN1o@tiehlicka>
	<dbb92553-58ba-42e1-b7df-b8450bd69d33@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: cxrha1hmhsfmm887p7ffwapqde8i8hn5
X-Rspamd-Queue-Id: 15B894000E
X-Rspamd-Server: rspam09
X-HE-Tag: 1775747781-591506
X-HE-Meta: U2FsdGVkX18gLAcVZizlNpaQt5g030/5099aGH3f3XHl0mXGIOU7cDjhzrh2w2nc7LpEDr28h5V4ADbb14YOAgiAnfoNaCBCxnhr9SHUXRRvb6DXLikug/zZ4rffq5bogyzn6PjWS1epdUEv+vTKQxR3YwV6A2kQPJiYWwPO0WV498Y+cnK/TGlCXpVjOLokwri3G9wGxMYhZR6GC+7W50TwbBbRViKlst0ZYCk39WM6m7XqLHI++I5/lwg6ndkyYGUpT+4kNNjqbUbWgrSDb0swMTq49wV4hFOV1T3l5jv4/k+whBmGu7rwq7gmTp5bdqLjKDV1CGKEYtlO4Bj2Y3aBJeVPytksmtiULxgbtuSuZQ5ARAuOHyY09m1BfuYMv3u7dmb/5rw0LIkCGH7sna/fNDb1PMhYtHzmxskBKab+s1OjDVgSSdCpKD+CGtDdENSp5Rpr2u8iPtJ7yIPyFM9G/6qVabqV4dkr+sdDgeU9UyfHlnANcPOseiYpQA1hHNrK08Vzsik7VXn5lc9vdCmic/EKxLodAzCQ5ELgu4fjgt+zTwmXcCvVuPTjXTZrnLt0o4aoxEKx4jS/qkeU4dQt5l3OpmZIHpT9tiNSn6aYcuBxf2ugw19ixqjVObLWLtaYXPy9gU6sWPAfETqaaUGNYGGadA1cEMvnr1fl3VYL+FlBDlxIqgDKW41AEz58rolss2lEa8OKC487Td0qgcNQPKkDSiqpF7AEgtBz0ZmJL8ZLjZHER8vKXl9j3ZjWJZifU3Fwo3vDvym6Y8ZfyRdqlng0bLNGlvTl1h06KZzMWAqrCN0BPRhAYn2mGI3kWe05JXFYs8NzrbNNrETsjDLhDIbvI2dCpnVyk5B+HyU8Oy40T2FqLDckN6EKZZe4KWX0dZGJpeyOrsUHdkoy4e+hXDR6IGyC2sSP+FSy6SegChx5vAVncBzv360Ao931PLR9VctJg2HLETnI/bQ
 OczJwpY8
 rbfaX85F4hb8oiBvtKU0cY+wA9ilUFmLQEXWyYKO4ScLBA0+JQ/w8Q+cMfQg7Lym/60b3NWaqLTww1+J4f2UFCxmVkd1EQxelUYu45rLcl12sln1dDioKO0LIy2bIo1sNn7byvr9/0bxCC3i6ocjBXlHznS2yIwoCWt4QnO8BBj/B2KfWnyiomnzci3a9iTWS27FCXzdh1puI/al+D5/1SJq0jFgYBlqOwcGs/DR2jV5c981b2Dfo9QRJRQeYoWtiUEZnnHueYGe5K8ei4bJRfr5+aE1EBxv3H2hYZQSCGc/6HRCynSFfiNTEfxK3Kq6wpA18
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 9 Apr 2026 16:08:37 +0800 Kefeng Wang <wangkefeng.wang@huawei.com> wrote:

> > Quite honestly drop_caches is not the best interface to build any new
> > functionality on top of. It has backfired a lot in the past and we have
> > tried to make it extra clear that this should be used for debugging
> > purposes only. Extending it further sounds like a bad step.
> 
> 
> I am not clear about this history of this interface, but some of our
> products do use this interface :(

I added it more than 20 years ago (before debugfs existed) as a way of
exercising cold-cache testing fs/pagecache code.  My stress-testing
code was previously using umount/mount but this was inconvenient for
some reason.

But the damn thing because so popular!  Mainly because our caching code
has always been problematic in various ways and people found that
drop_caches was an effective workaround :(

So it's an unhappy story.  Caching causes people problems, caching code
doesn't get fixed, people get stuck on using a stupid debug thing which
I guess I should have just kept local in my tree.

