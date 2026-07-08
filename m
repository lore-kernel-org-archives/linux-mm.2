Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EB8DC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 04:54:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 488616B0088; Wed,  8 Jul 2026 00:54:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 437976B008A; Wed,  8 Jul 2026 00:54:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34E226B008C; Wed,  8 Jul 2026 00:54:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 03E4A6B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 00:54:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 68ED6169167
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:54:17 +0000 (UTC)
X-FDA: 84964392954.09.D6CA0FC
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4E89120006
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:54:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wpIfPKz+;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783486455;
	b=ra1RBW5LgQ/t0+PgJCUpD72wKPtSymB89AOL8+VqKZn+HxW50bU0OMU5QAFYfug7qCO8lL
	cil+gTztY66UaVqc7NM0L4X0Fxmi0viwWBOxvA65NqbIlY7JZaiQOoPFVpK53Od7mqtMgm
	ks58dDvU4WgCiIk66Smg3ThEJYJ+qz8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wpIfPKz+;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783486455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YYJF3gA/1Ye/A90bToo6yX1kaFD6rK2JjvsYHqITlZA=;
	b=1WHIJN5pBRTeyaaw9ZiImfasznsbk2v+rVbPOpG+1h1HNVB74xknXo6TmfjvjV7h2h2Csx
	1kVTwkbdvtp8O8thYtFYDmwFvcEzpan+s/RyvVeqpUsVRpZUdzkZh07BfBBZX6ILCHr+9L
	lUly9pHG3CaZ+NwaHB5D0uyS4Y2sXsU=
Date: Tue, 7 Jul 2026 21:54:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783486449;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YYJF3gA/1Ye/A90bToo6yX1kaFD6rK2JjvsYHqITlZA=;
	b=wpIfPKz+65mMx+GejlSLjy7zupKfEQey6TPLi8ZdE+n68enKygIVFU7XjVkvpZLcaz3TuQ
	eyNaq3YCbZXEJlJOAjeL9G3BxUD/TxVJc0BykRldgXTFWVd4YAlILTGTgf7c5aDSjA2mVL
	2qzZKh0nBfLXi6bL0ShDCdNIv56++0o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Richard Chang <richardycc@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, "T . J . Mercier" <tjmercier@google.com>, 
	Martin Liu <liumartin@google.com>, Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: vmscan: abort proactive reclaim early when freezing
Message-ID: <ak3Xtrtm5iVayEx7@linux.dev>
References: <20260706081218.3438762-1-richardycc@google.com>
 <ak1XzPxbwBF72d1m@linux.dev>
 <CALC_0q9=KNnkQBE_7gC60jZ2Akj9jgL+VaDMFd7yGvqyfTJbYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALC_0q9=KNnkQBE_7gC60jZ2Akj9jgL+VaDMFd7yGvqyfTJbYw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4E89120006
X-Stat-Signature: ju5reg84hku8meq9oat8nf8mzjb6uo64
X-HE-Tag: 1783486453-708062
X-HE-Meta: U2FsdGVkX1/f+gMNZuXMDZpMWvQhP+jnZsFB4isBeeOihedlN+6d5U01+cb11sLEsmyouoL45PIrW/IqxOkMjUmki4LZ17cC7XaH115qYsXrMueOyuysHkAbcqYxLVNwNupjTWr6D4kq9GV12q1yFihgA3ciGG+DxPuHtTpmxciYZQaVC/gRKl7MbfOrHumFCjE/TOvYrDvFmoQEcRxG/bpe4QsX7S1TF94Gfa4o3t22YUJ3BxVodZctxn8GKBHb7o05klDcOObezdute7jdG/bZjQMkuhiRhSlNMgEWfcs8xtfQjfxdjPwdGi8XwVzArGrmEEa194Yzf8dX5O+lcuVPnXal0J+KcTTnr/mURY1HzSWo3ps4CWocTgfy1LickhScEeokBVWDc6K/uvel6FBKB2TGEyzY7CYbirOLVgR4MMeXyPR83FQFHlbm9mU76uT0IZbnlW/3ZEH91G4ylKuYASvC5YHXQF61qZFOargd5By3MjJk8WNa9ue4NnzcxZbT9CK4XfNmqCPkL894pU/KOTLsjDraQQscL7OlKoFeGR8ZK83/57w4luK8qPRwx0qoFkMzNxsmVvryXZpM8nlNV5yfSXmwvpT8KvXfuVdEGRtD9YpP9q1k4yBk4cE4MaafFjrZ73pNsVXAHERlzdxrluv7LtaDO0bpGSvm68Dv7XAGmD8mgoAW62x+CUxKBU6N9xg59B7eWC6zJ+PFzbioU2uPVrISn3m/+TXJlmwR35Auq4bq+xwkfPDOVRiHWSGvKPh6+lqKBLmrTajv3cxK/8bTHiK3uq353jo93w227myPj8f+0bld/hkC2A27hNwUxuu+Z18o5eRefqSt5nVaJwbXTKo6MBX/zZU4J36SoGxwS4O61RGkl1vTNhBiWUB57EvazrDv9ksadT3xukMhynYY7JxYupbLAXclkqCrkov1ZW+IxgqgeWG2BGlRy7k+qhrqGvt1zX2XmVG
 53I1xJKs
 SwCJ52FCJTLlL/1DVkXw5E8phGqAvYyc49VRRXSftJ/g9b/jk7NFambc1hgezHFEuhV3EwwE5kuR+0zX67r9Lr2upHkQGaa9SI5Zl4gO6OFu33DMtQgo+5t/Pw8/JZvY7wRujAXa2h+jrZVJAxP2NlBXv7N2yHwH0fNiVfHWeTfNxcDZgsH2/Zl7lbirMoSErvHLv+TYZA91SPaukvsI5OL8PEjJe/jolNBsUwGSo6Ulnqjc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 12:14:50PM +0800, Richard Chang wrote:
> On Wed, Jul 8, 2026 at 3:48 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > Can you please explain how freezing operation was delayed due to proactive
> > reclaim?
> >
> Hi Shakeel,
> 
> When system suspend is initiated, the Power Management (PM) freezer
> attempts to freeze all user-space processes by calling
> freeze_processes(), signaling user space processes to enter the
> refrigerator. When a user-space task writes to memory.reclaim to
> trigger proactive reclaim, it executes in kernel context and enters
> the reclaim loop. Currently the task does not check  signal_pending()
> within the inner loops, it cannot abort the reclaim pass early. It
> continues reclaiming memory, ignoring the freeze request. The PM
> freezer waits for all tasks to freeze. If the proactive reclaim task
> remains in the inner loops longer than the freeze timeout, the freezer
> times out, and suspend fails.

What's so special about proactive reclaim? Why the same situation can not happen
for global or memcg reclaim?

