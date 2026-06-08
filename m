Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F030CD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 22:20:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5534D6B0005; Mon,  8 Jun 2026 18:20:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DCE56B0088; Mon,  8 Jun 2026 18:20:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CC646B008A; Mon,  8 Jun 2026 18:20:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 282CC6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 18:20:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D336DA031A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 22:20:39 +0000 (UTC)
X-FDA: 84858165798.13.94E93C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5743F40015
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 22:20:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f7JYR6oA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780957238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pj4zDASXAMVVqBLSsY3DUyz/qFy1Cgs1DkPKV67407I=;
	b=k4xhsDRWauZtdGUSUmtd9IjXyPs3QPBZa340d4mXvHwYdqTAfRjot8f1EvJKGSBWHjMPed
	Hkf/G5XHzTj5xMPj4kW+fRJE3FU8K1wl/VCWEVNM1a/nYgagAHkNR+JjSPnkKYsPUGeaFX
	bACIgUYOaJQuiFFFIvIVkMw6/KNDwrI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f7JYR6oA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780957238;
	b=40KWZCJtK7pIp5t+CCAzirYL9fpDvQIRR9XQgtJIxnVakPi6Cb8Srpy1d6sYRalQOBAukI
	X6meSJ0U+v9ZRmILZ7xOwhu/i4+vJMDMU/83BkCdwn9yoWWdk88yTW/j1CpaBRT8SISDi8
	VI/rLQXGPOOi1kDIDyzDfl4X9bf2YBg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AAFCD6001D;
	Mon,  8 Jun 2026 22:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B29761F00893;
	Mon,  8 Jun 2026 22:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780957237;
	bh=pj4zDASXAMVVqBLSsY3DUyz/qFy1Cgs1DkPKV67407I=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=f7JYR6oAy8KAeO+iTwXmQ9xwNVNMpDX5V/D+2ivFxaS4yfhM7h/SJxTGiUk8y0o1i
	 4QzgzwsNilI8AeZFnNPbDMY4jhyXgfI3uxYK9d4EbaFHTgHreAjjBTxeOvCXwTBgwA
	 abVPZPI8ODcUEwsKJVv78z7kmG4CsdK/M5c1b8zw3MdHrxgGL8qQTgWS4AN+VFkBn5
	 1ex55s0XaDQUz+bzMlSLt2HAU6cLBgYWr+9J4PcJW6G6ahCJDcLSI/U3ZBrJWxsoya
	 7m85ka535QGgnZDxv+se17Egh5iyXou0smZvydULJERheKMmg5txtM1mHyw4gF5m5+
	 cM9iEDyd1HWfA==
From: Thomas Gleixner <tglx@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Yuanhe Shu
 <xiangzao@linux.alibaba.com>, Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E . McKenney" <paulmck@kernel.org>, Boqun Feng <boqun@kernel.org>,
 linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.com>, David
 Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org
Subject: Re: [PATCH] rseq: don't promote transient TLS faults to SIGSEGV
In-Reply-To: <22819c09-8d8f-4448-801e-742282e50693@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain
References: <20260608021553.1037128-1-xiangzao@linux.alibaba.com>
 <22819c09-8d8f-4448-801e-742282e50693@efficios.com>
Date: Tue, 09 Jun 2026 00:20:33 +0200
Message-ID: <87cxy04qtq.ffs@fw13>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5743F40015
X-Stat-Signature: rdti8r4m8f4zgane3d1juho111w3nrbu
X-Rspam-User: 
X-HE-Tag: 1780957238-977883
X-HE-Meta: U2FsdGVkX1+meQvvUhbm++jhmZLkg1MY0/cOciD332yN41OptqG860svvjksJ03tUtEeklw7rmoGGJ91BgXLbPI8TDpA+ZjpyNXXpsf65suebkky2Z5ZZSDhvSGXmwjkFozZ6PcO1Ta/QmIB7yQhSB5nVgRjZnsZxMBjdPZrqve9ErX5XUU2cbsd6kylAykVxspm9owEJ+qz63DT02dqUQ4WT1LfaqTLAeHxKC8f6hoX0cr6uvivnf6g6sjuyLT8kLmmrXIoygEY2xihB9QeYSQvzkvLH+CGZ5Ejj2vwoM1JSFTkSGPNmJbdMmcIXl4NC81BLFThoWTgw37RlYaByvukHftvEFO1GRsCec/YjqigOPNNfm0OZ/TUdc7LK4OvImq+ycL5hjUWYMcdK382bra8l7SL0ncN6vrC3RwUVu+P1XK3tqsWxz1yPkxe7UJ3roLHe76Ucz5/KOUwL5JyE/apW87CPKER5y3SrErRUp5zFaq77Pye1WVcwfARwZkxgcb3Wb8BNznCpGJaY2t9I5bMmgdxdml1kgpNbDpm1883nwkmC1NsYmVUE7qZ+ea/YmJc0dX2zWn/xvT9qMOjuLtHMp542FGq0rJKGvmLZ9n6wqXVUnVqQzU2mi3sYok1JTLus/QUru0z1AkcerIq0o66c3jZP06v7Nw3uhH8uNU5bnmpetN1JFXXuRhcMSu/wScry5FWVmKt/fAF7EIQwt5WuBQtiSMa7ok8n0s2EUEVKfih1RGZEwX3RtceQ8BhU+8iKgdxIj5JpTxHgglteVgeKWGoCU5N3Za9XwxDR04L5Fvh0114kigCoPien6z8lqvs9LnL5mgBa/wxb97rXOmyPwsp9jJegzYC5c2niYmH6Y7gY6zy+eRmjXo1FnWi/TqroDfRZmP5v72/TAgSFwlFWsUFQXQNI2wD8eK6tww/kn7YRe3p/sY/sENzEYit6Ae3tRscIX4EAxG3pf9
 JLn7l99q
 lvhwGJ0cA1VrarY0JBSxv+nNSz7oEh4Ighj5eUDbxWdtFV/LO83o+ptD90VXyIgR2pZbvCaFZmY8JNP6hkUMX9Rq+96GA89yVY2NyMP7WRpL4VW34lv+e84/gedtp/BSZX39Qe2XOANGgBjDelwbOjaLyJl4BOcQXsWu2G6XW9D9766FldLFHEhH1L0YiBmiah3siBwL/lA0hymJuVanxH78i3E3JsQwqHcHgaJo3FkmoUms=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08 2026 at 08:52, Mathieu Desnoyers wrote:
> On 2026-06-07 22:15, Yuanhe Shu wrote:
>> With oom_score_adj=-1000 the OOM killer finds no killable task, so the
>> rseq SIGSEGV is the sole outcome; otherwise the rseq SIGSEGV can be
>> delivered before the OOM killer queues SIGKILL, and the process exits
>> 139 instead of 137, breaking OOMKilled detection in container
>> runtimes
> As Peter and Thomas said, this is not transient. We simply cannot return
> to userspace with an out-of-date value.
>
> It looks like an issue with the choice of which signal should be
> delivered in priority: rseq force signal enqueues SIGSEGV, and you
> would expect the OOM killer to issue SIGKILL, and somehow it's the
> forced SIGSEGV that wins.
>
> Perhaps look into fixing that instead if you really care about which
> signal is emitted ? (and that's a big _if_)

It's even worse. The proposed patch is actually creating an endless
loop unless there is really a signal pending at some point.

exit_to_user()
   rseq_update_usr();  // faults and defers the fault handling to rseq_slowpath_update_usr()

rseq_slowpath_update_usr()
   rseq_update_usr();  // Faults again and the fault cannot be resolved

   if (!fatal)         // Proposed solution....
      return;
      
So if there is no signal queued, then this will end up in exit_to_user()
again, which faults and defers the fault handling to
rseq_slowpath_update_usr() again, which just goes on in circles.

IOW, this would create an unpriviledged DoS attack - not a fatal one,
but at least one which eats up a full time slice in the kernel
forever. Use enough tasks, which register a rseq region and unregister it
after returning to user space ....

So no. And this comment in the patch does not make any sense at all:

> +		 * rseq_update_usr() sets rseq_event::fatal only on corrupt
> +		 * user data, which keeps its SIGSEGV. A clear fatal bit is an
> +		 * unresolved page fault on a still-registered rseq area (e.g.
> +		 * a CoW that cannot be charged to an OOM-locked memcg): that
> +		 * is transient, so leave the cached IDs untouched and retry on
> +		 * a later return to user instead of killing the task.

If the page fault handler fails to wait until the OOM locked memcg
figured out what to do, then that's a clear violation of expectation
vs. resolving a page fault in the context of user/kernel shared memory
with ABI constraints. But definitely not some transient failure which
can be hand waved away.

Not that it matters much whether the task dies from SIGSEGV or SIGKILL,
but that's clearly not a problem which can be papered over in the rseq
code.

Thanks,

        tglx

