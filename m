Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF6AFC5AC7C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 07:56:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF4786B007B; Fri,  7 Aug 2026 03:56:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA4896B0096; Fri,  7 Aug 2026 03:56:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C92EE6B0098; Fri,  7 Aug 2026 03:56:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AECC76B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 03:56:25 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CB6F5160320
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:56:24 +0000 (UTC)
X-FDA: 85073715888.29.E43174E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1D0852000B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:56:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WFXQZd0H;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786089383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DuTbhGDESxW5SYdiKxOKeo8YSHlG74hc713ySFoLcFo=;
	b=VVegvcZBcRlOxYyY3YsBczl6vrPMb5kx0on310VHfMKe4Vnat3EMKMOK4kmCARJ/EQf4b2
	OYi6AF4RPOHLXoOt9lzxOg0/amXrIyMaMDFfap7jOdNdP7tQDdCxyGOZXTzv+5CiDSplzl
	LZitTE7j2+KEmr/n8rVHn/70uIv43OU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786089383;
	b=EHHFRofQDp0KVU7Ekp4ulQKHCLH3e2Ua7YAkTJrWcKfP7p5fFISGophTECPnOF3tDMwvf/
	JTF0zZljcU6H3tt6mx3CDviVhu8Xo8s23Rg7t38szWf8XUz5aqC9+rgkoaUrPW1q6xO7UA
	Hibu4cH5/kIcosALY7WS5n3oxdJmAwc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WFXQZd0H;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 92B054069A;
	Fri,  7 Aug 2026 07:56:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EAEF1F000E9;
	Fri,  7 Aug 2026 07:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786089381;
	bh=DuTbhGDESxW5SYdiKxOKeo8YSHlG74hc713ySFoLcFo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WFXQZd0H/P4+IrzmV6PaAKS6CyT5AJQfsoz4uiCaF3x+xvt4bVJECwmT1N0lb3Vdl
	 RwIEZt35x273RjdXUJmkj+LDrJjBSxoslF0pePvwk8eU0Ax9grn44Nkdgj20t46Euf
	 yy49NXGwW5uvAqj/+y+lGf+fepncckkzq2BGIc25GUTbzK4BanJE+CMucR902Znlsd
	 WKuCHDexYjoOh/xA57MISforYypGuEK50fStw3ZNFK0PIXaPRhjYpKbPCxA6qQ4W0g
	 8srIHFw6Zm9HJnL6wtUoLhaw8MkR1cqZlTOLMq4Km0mLe6VtBjN0fcUFlSFyhifrl3
	 d0wy8LHaIQpgw==
Date: Fri, 7 Aug 2026 08:56:00 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: sparkhuang <huangshaobo3@xiaomi.com>
Cc: akpm@linux-foundation.org, bsegall@google.com, david@kernel.org, 
	dietmar.eggemann@arm.com, juri.lelli@redhat.com, kees@kernel.org, kprateek.nayak@amd.com, 
	liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mgorman@suse.de, mhocko@suse.com, mingo@redhat.com, peterz@infradead.org, 
	rostedt@goodmis.org, rppt@kernel.org, ryabinin.a.a@gmail.com, stable@vger.kernel.org, 
	surenb@google.com, vbabka@kernel.org, vincent.guittot@linaro.org, 
	vschneid@redhat.com
Subject: Re: [PATCH] fork: reset pointer tag of vmapped thread stack before
 vfree
Message-ID: <anWPTt4DE-Q8PKry@lucifer>
References: <anSVlVpUXrA8ra_z@lucifer>
 <20260807065351.93659-1-huangshaobo3@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260807065351.93659-1-huangshaobo3@xiaomi.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1D0852000B
X-Rspam-User: 
X-Stat-Signature: pinxmq5ftrchuu7gj8t6pzabou6hhoh5
X-HE-Tag: 1786089382-908076
X-HE-Meta: U2FsdGVkX1+5Cr0k2JAEIiMX+KfGTuLnlXTNTONIBTZHNs4ACRsRWBoloQEa48GC9+irnhK96+9p+SB9IChlzgZBKJB82As/IDIZVF/jUmTa0d8EXJAcMh+InWViueU5JShilazILnk6SaI13zslFChQYB5HToHIRmf7mvnZYV7Lyxh4ymXeT/gLNJNHWCjfGSgmq2y3ohKtx16A8Byfim8ki6HA1c3ECcwyzCQR+Q7d12nj8aQkYlEguKm/gYxVdzjwy1VB5z4qBKXnu2dtj2J/4HIclOdmEcHUo2mwakHWma2Dt+shCJUohVlxrMrdscdTrLewxMGSlBlVktzjjA3o87CZNUXTArNMkXSUWIlkEqq8F9Vpxy/Bc9iqZLPvqskozWkOvqs+zbZOYsfWstrpsOYmwWD/KeQXtbowQhh6ZGhri2f5w/h7wVPnhGcGkGQySTAq55Jhev4g91gfjonlx7umWEBUtOBFPfTgF1uNVM7V8DTWDrAGei6BvEXAyXE9Bpfzk3D1bG524i5ZohookEOgqiZuS8tPB52Ae/BUSM07G5xeY3NF7sPpIAgaJmw6sCH1t5B2WMkSry2AhIrtGeFT3vVK2cFNUY+GqJjzqqjEQz2osNyPIgqivhivow2eEnlMNLLkzhKSSC6jG0sYM69mZJ7zlGZhBuqDi+Ud9+msQnrlWWYXV5Hxm9n6wlTlkUUGN6e+3LGokxc2uuo56o3VkeRSFND5/1VYITBmXHsWURoCCOthdoX7IiED+Vx6CBzcW7izdlgu5rsPpeJEtqvU9YSQrQmmQr8Z+q2Ysfo+0WnB39Q1PjfTv+kzgxJgm+39Po6bLB7Y4LObw5Pbpumsfyl2bf+pxkhEm/LQJr31jyAH2PMaoovDyxiHM3tT8zjhPo4ALJ+hBcb5Md7uy/FjtxQC8LpoKDlo4Cc2FHEawdlw3eGqqPgskmKk0SJ5EGv5C3kZGjCCOk1
 vpXWmacR
 gAdrafUOe3kZmFECHn2g60ckTQkvJg0Znng4jRhrGSeAypU1DAnMoDRskT/TaE8vuUGNqLyQTQVrFt6239tNDBFIiML4JVTFvG7FzKARsm4YKrm7SfNajSWkUXRLX57CpGo0He5X2d2LXW7zY1SrlAnHd1G7hdjFs/KcSnvEZI+1SP+/r2Ter8J6S9NvW99ff35DlgsadWFy8Uf1QZHXJAUixV9giXJDy6TD7x9AvtzbF5uKrdU27VHhmfsynOUjS2UUZRiu4ZbERNSNrLoxm16maWG5bV+K1QWs0B1aln0TjuHdCnfHZGT9BQQmbs2qEaNmyC3uPWf7DeH8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I'm sorry that whole reply is more AI slop and I'm not reading it.

I have zero interest in chatting to an LLM via a middle man.

On Fri, Aug 07, 2026 at 02:53:51PM +0800, sparkhuang wrote:
> Hi Lorenzo,
>
> Thanks for the review. You're right on the process points ??? I'll fold
> those into a v2 (real name, Assisted-by: tag, drop Cc: stable, trim the
> comment, correct the Fixes: target). I won't re-spin it just yet though,
> for the reason below.
>
> I want to be upfront about where the analysis actually stands, because
> I'd rather not push a fix whose rationale I can't fully back up.
>
> The one-line change itself is sound and follows existing precedent:
> c08e6a1206e6 already resets tsk->stack to 0xFF, and 528a4ab45300 does
> the same in scs_free(). A 0xFF-tagged pointer bypasses the KASAN tag
> check, so vfree_atomic()'s llist_add write to the freed region stops
> faulting regardless of what the memory tag currently holds. That makes
> the reported false positive go away ??? that part I'm confident in.
>
> What I have *not* nailed down is why "memory tag: [ff]" shows up in the
> report in the first place. On the 6.18 android-common tree:
>
>   - At allocation __kasan_unpoison_vmalloc() tags vm_area->addr with a
>     random tag (0xc2 here) and sets the backing memory tag to the same
>     0xc2, so they match at that point ??? the report is not from the
>     alloc path.
>   - c08e6a1206e6 resets tsk->stack to 0xFF (SP can't be tagged); its
>     commit message explicitly notes the stack *memory* still gets tagged.
>   - The only caller of kasan_unpoison_task_stack() ??? which would write a
>     0xFF tag into the backing memory ??? is the idle-task path in
>     kernel/cpu.c. It is not called for normal task stacks, so my earlier
>     commit-message attribution to that function was wrong.
>   - page_kasan_tag_reset() only touches page->flags metadata, not the
>     physical memory tag, so that's not the source either.
>
> So what flips the memory tag from 0xc2 to 0xFF between allocation and
> the RCU callback remains an open question. My suspicion is the async
> vfree_atomic / delayed_vfree + page-reuse interplay during the reboot
> SIGTERM storm (the trace also shows page flags kasantag=0x55, a third
> value inconsistent with both), but I haven't proven a specific path.
>
> Accordingly I don't have a deterministic reproducer. The report is
> reproducible only in the sense that it shows up during reboot with heavy
> thread churn; I haven't been able to trigger it on demand.
>
> Given that, I'd like to hold v2 until the 0xFF source is understood
> rather than ship a commit message that hand-waves the root cause. If you
> or the KASAN folks have a view on whether the reset_tag fix is acceptable
> as a "stops the false positive, mirrors existing precedent" change
> without a fully root-caused explanation ??? versus waiting ??? I'd
> appreciate the steer.
>
> Best,
> Shaobo

--
Cheers, Lorenzo

