Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71FDBC88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 12:57:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45DC96B0092; Fri, 11 Sep 2026 08:57:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40E776B0093; Fri, 11 Sep 2026 08:57:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 324116B0095; Fri, 11 Sep 2026 08:57:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 125C76B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:57:01 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 702611401EC
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:57:00 +0000 (UTC)
X-FDA: 85201481400.02.52A0873
Received: from relay.hostedemail.com (unirelay10 [10.200.18.73])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9FA3B80003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:56:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789131418;
	b=eG+lnJNWYXxEbqOkm54yIL5W0+E2x1b7QUYntwnUGD+K5jvVkBFl3i6AY7oK6WUeSEuWB8
	vNY3PkTT0Z2lJSeNexh7sQT8JwSVm/mNmYGbJtDdQuLzO9NJW3rOPiUDd7tdFjbfKsbJeU
	sAfNXS7xRPsOx1IeJGZ0QC0uvNKugTw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789131418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E0ssg816zZqGUemHya07FEZhfM/BCVla+Qd4d9ec2gc=;
	b=Wgns2/X8ksnT7Xaje9CA+bng/V0RUkn7Uc/6zq1SOqDdrZZgLvSjbbV7VcVMGrX2walLon
	xSBoeod9oeK+DieAwOQvKJ4BwNelGyhKDVIIQL5d88tGZnLp0a1sAYueGPJPUQHszeM2WS
	AE2r6SzFAmDN5hqpjOzFd/gNgbMM/z8=
Received: from omf11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C68AFC020E;
	Fri, 11 Sep 2026 12:56:53 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf11.hostedemail.com (Postfix) with ESMTPA id C51C42002A;
	Fri, 11 Sep 2026 12:56:33 +0000 (UTC)
Date: Fri, 11 Sep 2026 08:57:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Ye Liu <liuye@kylinos.cn>, Michal
 Hocko <mhocko@suse.com>, SJ Park <sj@kernel.org>, Lorenzo Stoakes
 <ljs@kernel.org>, Oleg Nesterov <oleg@redhat.com>, peterz@infradead.org,
 paulmck@kernel.org, mingo@redhat.com, mic@digikod.net, tglx@kernel.org,
 akpm@linux-foundation.org, david@kernel.org, linmiaohe@huawei.com,
 nao.horiguchi@gmail.com, rafael@kernel.org, gnoack3000@gmail.com,
 gourry@gourry.net, rientjes@google.com, shakeel.butt@linux.dev,
 xu.xin16@zte.com.cn, chengming.zhou@linux.dev, will@kernel.org,
 boqun@kernel.org, frederic@kernel.org, neeraj.upadhyay@kernel.org,
 joelagnelf@nvidia.com, josh@joshtriplett.org, urezki@gmail.com,
 juri.lelli@redhat.com, vincent.guittot@linaro.org, tony.luck@intel.com,
 reinette.chatre@intel.com, x86@kernel.org, paul@paul-moore.com,
 jmorris@namei.org, serge@hallyn.com, pavel@kernel.org,
 lance.yang@linux.dev, mhiramat@kernel.org, pmladek@suse.com,
 longman@redhat.com, mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
 qiang.zhang@linux.dev, dietmar.eggemann@arm.com, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com,
 mark.rutland@arm.com, Dave.Martin@arm.com, james.morse@arm.com,
 babu.moger@amd.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-pm@vger.kernel.org, rcu@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-security-module@vger.kernel.org
Subject: Re: [PATCH v3 12/15] unwind: convert process/thread iterator to
 for_each_process_thread_rculock
Message-ID: <20260911085728.47d3b351@gandalf.local.home>
In-Reply-To: <20260911075800.491472-13-ye.liu@linux.dev>
References: <20260911075800.491472-1-ye.liu@linux.dev>
	<20260911075800.491472-13-ye.liu@linux.dev>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/KtCaZ9/tsi0hxBkYuIS2CFwjudzULElM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=E0ssg816zZqGUemHya07FEZhfM/BCVla+Qd4d9ec2gc=; b=gh7JU/bubZhrpxGBgrxho2alJtCMELUzto5Po0cae150cpl0BavJgC2dRHwU4FvXJDWgj7yOyyuU2Stz8X9XeWiOLT41yNeO3tUvFSw40L8rqSvkkd6r1CgWOdrbH+uscOfxXomLGGWuLAhDqRhufkG1WPXyO7BUnbgmm77KIMY=
X-HE-Meta: U2FsdGVkX18a8IZpiamWSNHMOGJqi766L2hoU7BxJ2jc1mbGcETaj4OLytypvLF1C/8k4P6eKXvas+lrJd2fkaPBqv3KUx75daqT4beXqnn0s2TYyKccRHJ75eB75GbvBLtsIiHrPJIERzvArIitexLxj/cO9kvTrTnKbk61hiBe7r2nGDYiIOb1LXm9ZUaQdU3q4M27XcVbYDqNe8LJroq3pRtqtAzUxadzwfvnx2yAElBekjB5HsCjqmT+iIl7VHmhuoQbgdgPLcfu1uuZPVtwqwe4tPyVIqWTA8JTY+/xeG00csaaYSlhKyUuwM4zCh0hTIx4hiAhC0O7Hxmc1L4GgNlGmvWrkiJxOxCWnZSjVtEWmHLD9bmVh59kOkTIR4M5NtVHKoy0W8PLA7ap0pa5fEVrBPjp3LVjOdSzjgHtfss8M5cvpx2hDQTJ21CwWfHIl/mD6Xc5kDP/SGon2U9aC1WoX7LRXWG0diJrZik=
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9FA3B80003
X-Stat-Signature: hqhoj1bk96b3okw6yn9sw183sqfwkh4q
X-HE-Tag-Orig: 1789131393-869492
X-HE-Tag: 1789131418-676354
X-HE-Meta: U2FsdGVkX1+pZPvVqPMaa3eZ3/NydHAvlCMRazy5HZFcJmgnYm6s+RtxvRZbxB+pmI3QHGS58fptAFqid/ng2BUmQhXbD7VofLZNfjq1nXo22WS2N0TqydtkucOKvOGcHJeMFuKotxZGzB+caRoPkcmGUD2iMh0jFeCM6tDHywkGLFS0kyNTm+65G5GVLqkW97G8stJh1RUX31nEHlY3doe+Oh2i/OhnS8qBgpSkQ4eYcNqL56yOL1HAobJ6p3/8vqc0I/4N7A3nMMZzm7QChy5eUuFVVwqRiH+DsADKl6PnPx55pDyTalR/0VvfeX6BfUUoTpW/+xf3h2YZWty4QSgUfQqgycfwoS+D0kUaqTXFK/ha28tnKb48n5VLR5kqoYxJybURtTLhmFdZNOOJb6VOhPhPr/B1KMf+ABYWy20r8spaTKlmwquya9K1KTymDOvScoaukbp8rKfvSrUqaroU1rKRoM9uewLCteViK3S691jfJfEE6bst2ueKlOqS9nunnAt7yGE3Fco1+JbBi7A4rVyt5y9X0qmfHJLLBPMbB3OoeWSeqlwEt1NG2oNJwEbyxW9V9tgvdZJ19wQhRzmMl+gCsvTW1wUTLkaRvP79FOUu42dgduG/PP9zgGT74I0UVX9LedF0VE/BeZIOxBjPQvwu8YKa+0sbbb+kl+pA1FmfSM/AdtvSBNntNgzdPiCLaaUzb2HKQ9oHKmeQHI5Ae1EPlqaLyRe9rkXa+pCrME8EgUG5FyahYWDerLv6XOaJ/S0ZMgRfljuNMM0NIeAaUcdY5s3pDTXz2u6Pi0rjL2MK0m8nGOXizWZs2P/vm4NbHNr1AjRV9dE6x024V/n/nRxpL1H+FeUrRKC4Noif4wHsjf+TssmZT7Ml8UarpZJ9rmxgyn6epmxo5/9oJ7RmDk0SnEX1rTCDweZn4Z4J2z8Mdl3oxp6wfRkTL6R5xjTRy4tCrY8pFNBx09T
 4lHA0lTE
 GfB83D5d7ytd0ldNVkQHDl5SMLHEjzwo7EFBqfXpc0KnruIbHfOvMS+BVzKz7SEv/SII4uU0Xf3fKcJDnGs8SZ+efFzqtnmaxYVYN82M7Yi6GdG9QdzCfYa18NEnP3UaoQSTvkUUK82QJMzGuD7d5JzZi1or/bNvGwYP0tsLQTI51qCpVcRcognpf5PsmLkenqi2t57IIDNmoiJbUclo2ousUZgd5CBqhim/VICtSTOQa8bYl9KfPCnVNz5KR+Ymo2VzYgcWYe2xclt5u38oipeMl/zh95nCtIl9zU8TunjL3iuPsaRs74uDr/X9Ny8VNNILmM4EbyXJHMWl7pAVJzIHQvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 11 Sep 2026 15:57:57 +0800
Ye Liu <ye.liu@linux.dev> wrote:

> From: Ye Liu <liuye@kylinos.cn>
> 
> Replace guard(rcu)() combined with for_each_process_thread() loop in
> kernel/unwind/deferred.c with for_each_process_thread_rculock(),
> which scopes the RCU read lock to the loop body via scoped_guard(rcu).
> 
> No functional change.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Reviewed-by: SJ Park <sj@kernel.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

