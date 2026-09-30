Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45385CA5FC7
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 15:33:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F5BC6B0093; Wed, 30 Sep 2026 11:33:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A5F96B0095; Wed, 30 Sep 2026 11:33:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BBEE6B0096; Wed, 30 Sep 2026 11:33:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 055756B0093
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:33:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 81273160117
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 15:33:19 +0000 (UTC)
X-FDA: 85270822518.01.5B1EFB9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id D03221A0004
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 15:33:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VTD5D1us;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790782397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p2flYhRhbQtLQjkb4F9DovxNqyIJkhi/OOFcNtiaROM=;
	b=eoVKeo8SgVbqQcvC5zEftjMDtwskPJZExL2dIjM6DIuywxbIiuh1z7zxkmlSqyy4CyIXGe
	Z1ps3a7huNwWDFN7N402/nVxvLreVxlvMQIhlcByyDASKE6dPbY5+7kX070xu358/kXhp5
	lu4eJPOH5OsJQempe58tpkCu22p5+tE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790782397;
	b=H7tkHIL8ltWrp4ZNt0GRpnBSv/YLpT6iY6N9P5mTvu+HlmPq0pPPJna3Z0sNqt3k+mhvWf
	dOo33KjHFKXrPv0qPfwZbtdMY5WwMfT3AziEIJhz9ty6RaOhn0zIb+LdkN72J3jKc9G4LI
	Mi7aik1Vt6oQDHqG2vkVGvgN31gGhKY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VTD5D1us;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E50740B3F;
	Wed, 30 Sep 2026 15:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E3A1F0089D;
	Wed, 30 Sep 2026 15:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790782396;
	bh=p2flYhRhbQtLQjkb4F9DovxNqyIJkhi/OOFcNtiaROM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VTD5D1usKNsB+hEJiS2kC3xYC5Pggxaus6texvtAHrKHVEm9Qy1GdmOWiNqmwlXw1
	 thw4oVXOYj4r3gZ3PJfRJZlZcAEdq+OygbVJRcxw3zsZtE0fzxfm4IXIHomHuFcRLt
	 M2SIj0we2XT0p64oY/gNwLn9japMMnUGrtmOBswxWvbh+FeV7XBFgGYcPcbc/tOeSM
	 VhrDg5qZsaQiAC3pi/LGMN602vTsG7f/1uTVxwYn3jqjx/BA/olzBepyT+Tyqlhxqp
	 qoIH+nUzb8m5uzzMp8SeLqS8gXql1IZnfqZbr2Mex/erIz9pCduosu417Qhm6zmFlt
	 Ya9va1Jmf+ncA==
Date: Wed, 30 Sep 2026 16:33:11 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: =?utf-8?B?5aSp54u8?= <rockeet@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>
Subject: Re: [RFC] madvise: best-effort deferred writeback for shared file
 mappings
Message-ID: <ar0mdJKLC0cHBoKM@gremlin>
References: <CAAE3jtfeKJLSypScqRAEEgvO8En5kJfpbcFn5X+LQ2YL+xz_vA@mail.gmail.com>
 <85aff663-2131-47da-ac04-8f0799a49b91@kernel.org>
 <CAAE3jtcRQ407P9LTbg=JOwhABQRViSaq2XBefnDdNWiD7PxvUg@mail.gmail.com>
 <1ce9cf3a-15dc-4815-ba29-2e22b05206fb@kernel.org>
 <art8EKRKMdwSDCkr@gremlin>
 <CAAE3jtftxMkCfWJ77W-xvV2x7jdAN8C8kyofYC3fEivM-Cq6UQ@mail.gmail.com>
 <arz0auULA33fqoWu@gremlin>
 <arz8Plu6J4YOTi0a@gremlin>
 <CAAE3jtcanTUrV3xfofwrvYGCFe5o=Vn7gS66bDzuxzeGg6c5=Q@mail.gmail.com>
 <ar0a9y2E0nDTIC8V@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ar0a9y2E0nDTIC8V@gremlin>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D03221A0004
X-Stat-Signature: xi8k1mg6zzupb93rpb3qzm3s88wrumxu
X-Rspam-User: 
X-HE-Tag: 1790782397-369810
X-HE-Meta: U2FsdGVkX1/4ZkSHrXkJDzboi10p2rPzIUKIUl7Gbsat5+1xibVwQS6UV5hBbo6cOLGI+wdUZNLEQZVnTRRruyqmm9TM3qaMparAlx2Iyvsn8ZCJaU5LjBI6/pAxewE/ifp69ldIVASrmT803uQrQhCROoG6tYOBcrmA8n4VhKrsFjauIqQ5/lBvSYV0LiuhV4W2uDoKauQUiAwaMaHsgQaINR2fFL5uXvDO6YbP1WG4MfQve9PlsP9kDN8AxrNKq0UyeJ5/u71Pdt3a/okh/10Y2I5q/hSFeIEdZIUV7ocuiTKwz7p74ZrtixLO5EBx9RrnFs6LUqxLqfWvV7T7TdlVHogHwQ2sBtS6BDnN2bgA0pYpNpGTx3knthhC+pLFS2Mf9FSPbimD8xftWKi5REBcFRg1W5zIai8JGJgirf0up/IkOkyH1FvKJAk3ADWw3OwdG3vAnKyiKtU7XxJ/WT2cSlhuDOVBAtXCOkWXi3DlBAlWSV6gJGSAAvb/wQ8MBDVUFs2IsbZY0hWAFCOxLbnIqhcQUBt94q0HMwWnbb3ttUk4oGqTk/o248SAivXnIp7ddO47/geUWfIXxqhPDWWDM+0PMQcvdyUONFByez476eJM5NBaE6wsz5NvCe1nm6UHzmT/eISBcwujoIxMf3a1PKB6ITAvxXAk+z5PVlFNSaWIMAPl760AURIx72N2kfGk/UEgXW1sxKfPfOLNKPSZOH9dKVbnn50JTGj0Wgp4OkSNqxZUP+d/ph8yk4aJRY5AFfyU0+xHmg4UpiE0yaxOFaN/VMpni3BtQ6fhJyjwNyCVMkrNwFKaH4VzTxk1J9UtSMYHg+KedG5AD7cHctHpNCpFQEgAg1eeYtuvIAgESq0rl77TAVJ23huiLV6TTIVVZzRYNbnj4H8ogDdj6O42E85YyJcen/PdmD3BUK166W/2qMcYoCLdSYElRiNkBbALg17+67J4ddY0la4
 UBKclZL3
 g+vsAppCSg7kQtQS79ywHDPid5H5a6WwwsyOgl/Br72MK1TcyUwk3IcgBrllPLsFKWxhAi89kZw0h5bfOMzQ4pyOijq0t4hEucy2ZLFg7dllthMw8KLBlmVohFLW+PuoI/R5lIyWq/O2febW1qnO+M8EC8TFLyir1H86zguARygYlzJ/ep7aGHQp3CVjSG8MyaDgtbUSrfew6QLaTMWNYp0W2btCz/grh6GBH61ROqe3FpLvCxEZB1+5xYCxxuhI1KCYi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 03:24:53PM +0100, Lorenzo Stoakes (ARM) wrote:
> I strongly recommend you look at a shmem solution.

To expand upon that:

The general structure would be something like a minimal process, with an
oom_score_adj set such that it can't be killed (or is at least very unlikely).

Have it do something like allocate a memfd.

Then have that be as minimal as possible - it sets things up, it hands off
memfds over a UNIX socket for instance, and is set up to periodically write
back to disk.

That way you have something that should never crash/exit which gives you the
guarantees you need.

You can then also control how to synchronise things between processes, when to
write back and how much, etc.

You can keep it in a cgroup as well to isolate it from the rest of the system
too, potentially.

Then have anything that does anything non-trivial be clients of that.

Everything works as before, you can ensure that intermediate state doesn't get
written back through whatever mechanism you want to employ, and you avoid all of
the pitfalls of writing to a MAP_SHARED file-backed mapping.

If the memfd isn't enough for you, you could also have it establish a tmpfs file
which is then shared between all of the processes. That will survive even the
establishing process dying.

The main win here is that you can choose when and how to writeback using any
mechanism you like.

For instance, you could have a dirty bitmap be part of the shared memory and
atomically update the relevant bit when it's ready to be written back.

That kind of approach gives you total control over when and how things are
written back.

And avoids the known issues with writing to a MAP_SHARED file:

* Terrible error handling - random SIGBUS's, network file systems in particular
  are very problematic, writeback errors are hard to obtain (fsync(), msync()
  needed to even get them) - note the tmpfs compromise mentioned above has this
  issue too.

* No control over writeback - Exactly your issue. This is what you're trying to
  work around.

* Writeback stalls - as above. The dirty writeback balancing bites there.

* Reclaim - dirty pages can't be reclaimed until written back.

* Fault overhead - every fresh dirtying write is a page fault (that's how dirty
  tracking works) and you have that overhead throughout. Once written back it's
  cleaned and causes the same cost again next time.

The TL;DR is you're trying to manipulate logic whose whole job it is to
writeback to not do that.

So stop doing that :) and life is much easier.

--
Cheers, Lorenzo

