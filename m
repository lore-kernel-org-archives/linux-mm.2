Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B55BCD8CA4
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 19:50:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F0946B0005; Mon,  8 Jun 2026 15:50:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A1F06B0088; Mon,  8 Jun 2026 15:50:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B7CA6B008A; Mon,  8 Jun 2026 15:50:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B1036B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:50:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 20C571402BE
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 19:50:29 +0000 (UTC)
X-FDA: 84857787378.15.7D030AE
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf25.hostedemail.com (Postfix) with ESMTP id E1F7BA0016
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 19:50:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="c2/gonYM";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780948227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gpMcdQqQNsSXJkHf7o33LPCAH/sDumLYvx0osSZwQns=;
	b=euB5/qQBSyIHYc2s0jmVodXRk4rLgg/VYyCN6dtUDH0O+BkDnASgcgfS0UALGAyXlnJMhW
	3T62DveQB/cxm025IAohkn7ZC9JbpUaQZ0962X+CEZDIb+DyuW1XCj3evbTxKyNyMbZ2Wp
	m7+7aj0KXUJw/eplsKBqtX6LFvpWzsY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="c2/gonYM";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780948227;
	b=BMJ07j+0bg5moBSnef6TQ4Bun28if3j0XUuGqyAvBIXnMauROB444yaCv1tbejKQdoCLNK
	fOkykwgWdZAAw9Rd/aO0ohJctD1/Hlo5VDiRzv/JHD7NcanZYTnQyQnrcGLP0mYF5hZF+9
	5J6x+UzG+ZynORF9OPcbv56wgDBIvHc=
Date: Mon, 8 Jun 2026 12:50:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780948224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gpMcdQqQNsSXJkHf7o33LPCAH/sDumLYvx0osSZwQns=;
	b=c2/gonYMrRlOyUbx6j7slsmXtXB/NhjBZq7g94qgLh/kp1ZYqDCE+V3jnmCSdBXVF9PVPq
	jsm3Fnnh3v1Xi6aHkZM9o1sgYR2Thfk/7YUjCIPUFQBqZDQ3YQ8qjkvXsR/Lend79SC2X3
	tHEq9iEQPu6KM9KQ7LjZiPKoUudHkUk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Hao Jia <jiahao.kernel@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, mhocko@kernel.org, tj@kernel.org, mkoutny@suse.com, 
	roman.gushchin@linux.dev, Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>, youngjun.park@lge.com
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
Message-ID: <aicZ-5GX9De3MAU7@linux.dev>
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-3-jiahao.kernel@gmail.com>
 <CAKEwX=MQe_KFZe2vBXQYh0aa-x+E8AzNwmyjJGJk4tDoS9ML3A@mail.gmail.com>
 <aho_VtLCmIRsNyvO@google.com>
 <6deeaea7-3cd1-4403-29fc-d2dc55c297f8@gmail.com>
 <aiBqzOtEv5iAC_qC@google.com>
 <CAKEwX=OhxUxRCEfvZMnWzXy=Fa4jgzL3DuP-RmaVzdK65m4bew@mail.gmail.com>
 <6db27a22-cc7a-9a94-db3f-c912fd39aa32@gmail.com>
 <CAO9r8zM4SDdTgz9L2s1VfXL8K2VBjMD9ej2BTDxaGge1t2+quA@mail.gmail.com>
 <aicJBVT4pBvmyooT@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aicJBVT4pBvmyooT@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E1F7BA0016
X-Stat-Signature: rz3byun8xewca7usky6ifuuw8yzuup1w
X-HE-Tag: 1780948226-915917
X-HE-Meta: U2FsdGVkX1+PdOtM+39lO5GARCFX/Six6fNeeTMCOFSuQGhGb15U6z034TU/uoDFQvG52erqyahIjN+FYWOvDGnrqCm5VNde0HQ7jNdnbR3aKuP5irjzLQmoccm5X2EqeI2XuGwvieogO50U1i29iaZnNMA+xiY+48+PJ66zdWbOsqwYKjZP/WeIq090hhBt37o43l8YwesJl1vc1V/zBY58u4UkBul5tGZ1trKYW22I9pwluHXxK5FacqQ6l0nAVkFuShQOOtEboYTqYBn/p45ASo5Gs4bqz9gNFSH79/s7i70Ytun0XHhh2veCZnCURp3fEDnZNPqTcHAAAQLzmwr8C3BQFzUKSjg4GkVtX5ysnjo8wrtL7YYUSkP0F8kKQ6TJ/foKJ7gJ/VQfwxUYm8H5oPVI2haLEyUZGWcpPCLHpwOkepMm1BfWPGNMyYY5QGjMnu946CuqvTHeGSne0dTtRZfZ1QhJewlRvBtBMVTz6Sjj/430e5WgjmS8izpaTjZkhpiMS6nbbbfUCmFafVdnXGk6izMZzfpTQFGuntNhsZ6J+U99ihs9tNPXOXieFLW6xD+LHCZ2zlhEfbikf9+cRiWrOylkPmTRQdRH/MBoKgCXoSK6VfvxNc0Nzql8KT0sgUpDJQwttPrXB7Sntwfyo2b/PgBj4jKDeXa+RnOuSm+4x3zYNFbVgz2c6Rt2pxe1pEnvjyuCaqdyOP8+D+mocEWFsgHytME1wFQRWff+K1GvdqfZUhymeraEH5UjVtg4bkjXH+JKOO2BUqCpw7GHTu78D+eNDqeYtfJXIKVTou4364OVJjpq/OPsj27HDRsgv6B27Sr3xNB/mB1hgPCYr7jaKGzALWpNh4Tod6wNHMOUP1Dn1P5IAuhTELh3x/BOaLZMnWLCMQWkz178gsxCySKbZ0TwvGVWDyjcaPXGxTNdga8ohrq2Apf6dEcqoCwu04Owsh2U3ODNK5L
 WorGWcCo
 xaJoFJ5EpUrpo8us/OYDw2qlASoWxppRoWQZiVuc+mcRWIA29EUS5g515BVG4yhvprLmrRRExReI46HZyOaoU1zchPJ9zFahYmohmoxyEomtJnn73DAqLHKQsx3Yu+g4eNn8TAy+1vGbpOj8EYb3RTOYRkjZwFqnN0AkMMsl5uJphzlJMI3zLDOfmnMFN7OMAFWqKDyBxJS7FXnmqsybn8mnupkeBRyw+S8tGJJesOHfAJBrlrh4Dm5JfaQfOBzp7jqgz5KzzGpOLEdMdmuvfeG5uONTTB5ig8Z0g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Youngjun

On Mon, Jun 08, 2026 at 11:30:30AM -0700, Shakeel Butt wrote:
> On Wed, Jun 03, 2026 at 10:36:07PM -0700, Yosry Ahmed wrote:
> > > >> But doesn't it make more sense to specify the compressed size, which is
> > > >> ultimately the amount of memory you actually want to reclaim.
> > > >>
> > > >
> > > > I personally prefer compressed size to pre-compressed size. That's
> > > > kinda what user cares about, no?
> > > >
> > > > One thing we can do is let users prescribe a compressed size, but
> > > > internally, we can multiply that by the average compression ratio.
> > > > That gives us a guesstimate of how many pages we need to reclaim, and
> > > > you can follow the rest of your implementation as is (perhaps with
> > > > short-circuit when we reach the goal with fewer pages reclaimed).
> > >
> > > Got it. I will change it to use the compressed size in the next version.
> > >
> > > Yosry, Nhat, should we continue using the zswap_writeback_only key to
> > > trigger proactive writeback?
> > 
> > I *really* want the memcg maintainers to chime in here, it's
> > ultimately their call.
> > 
> > Michal? Johannes? Shakeel? Roman? Anyone? :D
> 
> Between the options of having an explicit interface (i.e.
> memory.zswap.writeback*) or a key (i.e. zswap_writeback_only) to memory.reclaim
> interface, I prefer the key option. I have not looked into how much proactively
> reclaiming zswap memory or proactively triggering zswap writeback makes sense
> but from the perspective of memcg interface, I think the key option would give a
> more clean solution if we decide in the future that this whole thing was a bad
> idea.
> 
> Next regarding future proofing zswap writeback trigger, do we expect any
> potential additions/changes/new-features for this interface? For example do we
> expect in future we may want to trigger the zswap writeback only from a specific
> node or lowest memory tier?

Youngjun is working on swap tiers. At the moment he is more interested in
allowing a specific swap device to a memcg or not. I can imagine in future there
will be use-cases where there will be a need to demote data on higher tier swap
to lower tier swap. What would be the appropriate interface?

BTW does zswap folks think of zswap as a top swap tier or something different?

