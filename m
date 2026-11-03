Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A6EF606A32D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 12:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WdFlpf65
Received: by kanga.kvack.org (Postfix)
	id 72E996B05B4; Tue,  3 Nov 2026 07:25:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FF206B05B5; Tue,  3 Nov 2026 07:25:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 615956B05B6; Tue,  3 Nov 2026 07:25:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 37BAC6B05B4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 07:25:02 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C8E031A03C3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:25:01 +0000 (UTC)
X-FDA: 85393727202.03.74749A4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2D86C40002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:24:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WdFlpf65;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793708700;
	b=v/eCbbFqTf1SNkIetMoqIwfrp2XRGCfvjnYPSYVatM36nRbHNS09V0pe/33zRz20yBNe2d
	XYxLqqimN0x6QQdmQIjevvgO8PYCjupeJXZluqGI0p7k3sAp7+ETHlmzsbKapKbYeZUYKf
	2igh/mKeVm5hAFMbA0ZuYW+jD8zvpLU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WdFlpf65;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793708700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ib1Dni4qza/67GkuIbDzSdhClKYEF4f+ldPyq0GWH5M=;
	b=Wv5ItzeX2F46UD+F1tfPJARJoTslViktlacD+uQ5okO/nEar/5LuUEAGbIduGaF502cJm2
	3cjo9v1CcWtNiykaBdObu7+Rn6WE6718EnqzcgF0XGDQJr2Vr4G6XXrpGtm154/eRd2YBC
	74b8zaUCHUP/eNEmdW24UAFbb1oJnXE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E14E4181B;
	Tue,  3 Nov 2026 12:24:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D972B1F000C1;
	Tue,  3 Nov 2026 12:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793708699;
	bh=ib1Dni4qza/67GkuIbDzSdhClKYEF4f+ldPyq0GWH5M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WdFlpf65xK4cXe3wKfv8T1cOVbNZfDm8uIeit8eITrirURwfPiMoXltzFF3VvNVBp
	 Y81d82tZK8zLrcgUSrApu/yeRvQLJqEbcaDEspTm/jctPS0HG4Zt9T8Ub0zn8NUj3l
	 GTWfhPL4f70ouNNddBJq1Iikp8+JRJJ7tHoagPpPhP2o0Rkum9zpq1rRBtIzKchIYe
	 UIxqEGQKaemTEND+2Hum2H/zXbd7Y6xYSGUMm7n75wJcvZiqLJO7/f+R7x6i0yADEc
	 MLkYLXWaxiTax5uzo6q51ee21eYAYeUmkVu+9FK1K7s+4LPy6i2w10BADZDSXTO7uE
	 h/oCA2ZsMOS6w==
Date: Tue, 3 Nov 2026 12:24:47 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yonghong Song <yonghong.song@linux.dev>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Song Liu <song@kernel.org>, Jiri Olsa <jolsa@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Ihor Solodrai <ihor.solodrai@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 3/5] locking/rwsem: add down_read[_killable]_nosteal()
Message-ID: <aunLcWto870swo38@gremlin>
References: <20261103-khugepaged-latency-fix-v1-0-a07ab16ac860@kernel.org>
 <20261103-khugepaged-latency-fix-v1-3-a07ab16ac860@kernel.org>
 <20261103115159.GK1813469@noisy.programming.kicks-ass.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103115159.GK1813469@noisy.programming.kicks-ass.net>
X-Stat-Signature: o7wh1rjg9n1umagk5zbo7hcohhz9d1mk
X-Rspamd-Queue-Id: 2D86C40002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793708699-434403
X-HE-Meta: U2FsdGVkX18tDvx3saDlne7GNHGuGCAu9ety3UcoRcFKtjFwAR5Hz+xt/PzqxFo/IDHp+CS5rXc6aFS0ZIIplhBkszcrp/YQOtAJ5oNCAnGcVQAMOLveHADrqC6wjDVMXRAXCCzhaV3r++GwHWPUbTpkChrIvo7FWCmWqObfM5yoN1mYjdCMa9YnHrSBbVsGpzPBAPDi31lMsflrFX8ym0EFQ5a4+MQLHE4tz85v6vynO7M3Ytg5p+IbiPljuLCPzyIBS6d+YkXljJssNqDx8ekSZyUmm1s5UtgoJGSL9y3TJVBUZNvAT9Cre2Pg8urHMH9/icOU95BHjQwKKgEyEDpiLWkoAGwv/+Azont/yZhYRsxq6XklyvO4JOgZzoz3Pms3zubwzE7hoStoTdNtLTILdpOm4gG1q1u2AwVb+GdXNkWfxvQ1biRLcK96OCyYjTEMAOzLjgcXPVliUeNsj6BlKBIgTdER1dhh6p74OHw8k9jdlNq0ylhRUguA9DlVSDzE4Kb1kxOmrfn2DnngREBNIxiIlitfy5o5nhLIqjv6/pjiG2fwCkNAwsEwVPgaKC+DgalysS65V77OJ1U7qUGwJcFA57aFwTXzNZqlEdVxyDT4JfSBRJIk745T2a1g7Rjz8ZZv7s5JbhTQxe69y9PsTfQGF9UMQ/r/kEmzGsTmBKzGuSEEZiZjHDuLYa41vO60EX7KgYAmBF7nfVdUz+4pEKfjmWfIggouknepJ48rt+QaQMwYFT/W9TYVsjMxjz3AO1wsyY1fCuLdF9wrNXU0hc0cVbvDZ1avpifxWE+epbsaePz0RjEjqvuaueUszbLoo8pZM1IKi3F7o3rJibwi5A+TPiklCU3N8a2qf7U5kFUB2fMaZd6HKvfLsbMwCK+fHsz2pZtLSZSLpTCWWyDTsOKgRYRQoA9SroKoDvk5/NC5tnPOD6K1GHuBEIIIXYtRNL+V/npSZUtVINc
 J0Zec7kX
 2Zd1NiihXhepNDisXwUbm2/kROWNcs+rFeNhue4nq2RftfAUnDLJ4I7CBBYft4wexnLlZcP7BZN3qcWaXC+E9MgZ7jSo1Buq1xBKy9iugMwj/fCg9/HdUIMrO4W12BcpewaeeemFgU5Qfr6I6MaI71gYkuT7Pfke+Avfbx116HO8pQxw6fWGpWlet99oc4gekBe0ukq4inYEkhi7NYWyVVH/yDBoHXuLLBji6iHAlgmKY3PWk03Wav7OmJbv45V4xeQalXzyjt/V1xmA7wUw3oPdqCJw1Tpy4SSj92GyH2BkvYPg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 12:51:59PM +0100, Peter Zijlstra wrote:
> On Tue, Nov 03, 2026 at 08:27:44AM +0000, Lorenzo Stoakes (ARM) wrote:
> > Since commit 1a728dff855a ("locking/rwsem: Enable reader optimistic lock
> > stealing") a sleeping, queued writer whose handoff timeout hasn't expired
> > can have its lock stolen by a read lock issued before a woken queued writer
> > was able to acquire a lock.
> >
> > To avoid write lock starvation, this is only permitted if no other read
> > locks are held.
> >
> > However, this behaviour defeats the purpose of a reader periodically
> > dropping the lock to allow writers in, as doing so only works if the write
> > lock is acquired first, another read lock is held, or a queued writer's
> > handoff timeout has expired.
> >
> > Provide a means of indicating this intent via down_read_nosteal() and
> > down_read_killable_nosteal().
> >
> > Implement it by exposing a steal parameter to rwsem_down_read_slowpath(),
> > update the starvation logic to modify this parameter and modify the steal
> > branch to check it first.
> >
> > Also drop the duplicated RWSEM_WRITER_LOCKED check and remove the
> > goto as the steal condition makes this redundant.
> >
> > Exposing this function is safe as it only makes the lock more pessimistic,
> > so does not impact lock contention.
>
> Not generally a fan of this -- can't we tweak the steal thing to never
> steal if there are pending writers?

Oh, well, I had assumed I couldn't fiddle with that behaviour across
rwsem's in general, so if I can yeah that's preferable!

I could send that change separately then and drop it out of this series.

Something like this?

diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index b9c180ac1eee..d6572e207523 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -1034,22 +1034,29 @@ rwsem_down_read_slowpath(struct rw_semaphore *sem, long count, unsigned int stat
 	 * Reader optimistic lock stealing.
 	 */
 	if (!(count & (RWSEM_WRITER_LOCKED | RWSEM_FLAG_HANDOFF))) {
-		rwsem_set_reader_owned(sem);
-		lockevent_inc(rwsem_rlock_steal);
+		bool steal = true;

-		/*
-		 * Wake up other readers in the wait queue if it is
-		 * the first reader.
-		 */
-		if ((rcnt == 1) && (count & RWSEM_FLAG_WAITERS)) {
+		if (count & RWSEM_FLAG_WAITERS) {
 			raw_spin_lock_irq(&sem->wait_lock);
-			if (sem->first_waiter)
+			first = sem->first_waiter;
+			if (first && first->type == RWSEM_WAITING_FOR_WRITE) {
+				/* Writers always take precedence. */
+				steal = false;
+			} else if (first && rcnt == 1) {
+				/* First reader, wake other readers in queue. */
 				rwsem_mark_wake(sem, RWSEM_WAKE_READ_OWNED,
 						&wake_q);
+			}
 			raw_spin_unlock_irq(&sem->wait_lock);
-			wake_up_q(&wake_q);
 		}
-		return sem;
+
+		if (steal) {
+			rwsem_set_reader_owned(sem);
+			lockevent_inc(rwsem_rlock_steal);
+			if (!wake_q_empty(&wake_q))
+				wake_up_q(&wake_q);
+			return sem;
+		}
 	}

 queue:
--
Cheers, Lorenzo

