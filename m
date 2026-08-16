Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDA30C5DF66
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 04:11:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D1B56B0393; Sun, 16 Aug 2026 00:11:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A9D06B0396; Sun, 16 Aug 2026 00:11:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F282C6B0398; Sun, 16 Aug 2026 00:11:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A884D6B0393
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 00:11:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D3B07120339
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 04:11:56 +0000 (UTC)
X-FDA: 85105809432.26.3981FF8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id EB52F140002
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 04:11:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y626Wpze;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786853515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cFHs8gvxJX+p37ht/u6mq8BW9d9iCfeT6c4xmXd4hIo=;
	b=o5eBACb8sMNWD14XVoSgKMcR/FTFLLrTvrtrKDXEnNyS1A/ZQXfTzzJxk570/nv3L5tMIm
	vAl6RHgJa5OuaRQ5++9x4UjMUob6BHG3Tg1n7fS+TSfWUzxHdSrJremiHgigIb1iN80y+2
	ew88a0cNEFvnyELC8YJiyYlRzriCTXA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y626Wpze;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786853515;
	b=o3sKl62P1N8UvsP4gAu69SbNqpyuuEItbffvG7LQfoCvftD81mndj6IEO9194OMzHV9hoE
	QVUjXZ3KOmUTdeR/d9sCWopHtq0cpiKI+0gOjMjx/a0nKSrDXwdmoq6MjGNjLr0zYPuLOl
	6PbJHYuGDnFxrTY2WNqZdlNMLsCAvPA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1467C601DE
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 04:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4C91F00ACF
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 04:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786853513;
	bh=cFHs8gvxJX+p37ht/u6mq8BW9d9iCfeT6c4xmXd4hIo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Y626Wpze5eush5ifesQlMpXEC+DZ+SYMxPDh1c/gdX6JMAVrOzh84A0RPXO84FrIc
	 +QUNB0m88JUb5shuHgka5W9YxR1k1riSwdzWNNMs3CbQCe+ircgB2uEvvu+QPFpu+X
	 aLsU6FzFU4sygvmMnAFLzvLVHGEdOqVpnnfV6lmvaE/UGmevtAvoedMtZxTHYal1k1
	 /ERR09Lp+Af06TDPHCogWWCbaj0GztIfngM2ONMOIVX6FGqnwPjrIRqOpjDJCuKOyi
	 YtJQrt07/fE+F+3nn3GvSiK+Eoi6ZGtFAwxHv09mFwL5m1JZLIeQO0uY23SOk+1lHw
	 eo9bZQWlY2HBQ==
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8fcc43c48f7so23776846d6.2
        for <linux-mm@kvack.org>; Sat, 15 Aug 2026 21:11:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RogzrvmZtuWP3UNvIw3lqK3UFt+kapCULhTR9E1+IBHX2aOIiB5Jnjbeq5xn6MCPMsxMAgAU12iYQ==@kvack.org
X-Gm-Message-State: AOJu0Yww/VfANcqd/zmA8UsJcJSRM8Yv2PO6IMS2zwa/+82c0p4FrQiQ
	Uy+JpHRo3D+bvU2IDS16Iw4TZm3F5wh/ZE/wm+9uhiHWobxpYjU3B4aoYqVyvYP8QPgeY0a7i0K
	jitLGfykw9z/mkrVfPqdwGQ8NYrsWudA=
X-Received: by 2002:a05:6214:459b:b0:8ee:fbc5:8110 with SMTP id
 6a1803df08f44-90a91e850e0mr202646836d6.32.1786853512973; Sat, 15 Aug 2026
 21:11:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu> <20260730-blk-dontcache-v7-2-3e8e6850068d@columbia.edu>
In-Reply-To: <20260730-blk-dontcache-v7-2-3e8e6850068d@columbia.edu>
From: Barry Song <baohua@kernel.org>
Date: Sun, 16 Aug 2026 12:11:42 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wUvLoKGafR3U-ji1kUUaz6K_QdN6QxMT-apSaO5tXp0A@mail.gmail.com>
X-Gm-Features: AcwNN1WZkB-TbbPYLGbQZDybzjU1BQWX9MmsjrOiq9haH_bC38JheVA30gQpXP8
Message-ID: <CAGsJ_4wUvLoKGafR3U-ji1kUUaz6K_QdN6QxMT-apSaO5tXp0A@mail.gmail.com>
Subject: Re: [PATCH v7 2/5] block: add task-context bio completion infrastructure
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Christoph Hellwig <hch@infradead.org>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
	Chunhai Guo <guochunhai@vivo.com>, Dave Chinner <dgc@kernel.org>, 
	Bart Van Assche <bvanassche@acm.org>, Hillf Danton <hdanton@sina.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-erofs@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EB52F140002
X-Stat-Signature: wz59nfotnhhsb3hjeoxxqa4ktbcab51y
X-Rspam-User: 
X-HE-Tag: 1786853514-515229
X-HE-Meta: U2FsdGVkX1/ETNp3sDPcQAr4Q0cgnu/hf6GW8OJnNnnYt7zsto5TE90nwBHBKtsfoWDjagfmFyc8TJ0TRpm4/KjF8Cj594hQbLeyZ8tT9Vu3f9EwJcY9ixtAKn1a9OxXmgaSAzC2Pe8ew1oZTrJ63Ccbl99OmdWFi+Y6Fd0AAstGjnBW28a8ZIdwn+z6ISkkbzAuAZ8ig4IF0hfsA6OB3pjjVYg5aZGPiGZXqmMaIb83sMap7ThfBQ32AqOEXWmv2/D6u9guzFx0q2e7ZarwU2dVlrxt2eJLVEzS1QDSUWqFiBpHQCMEXnuzVtdbLVnLbzcQvUQENK5Iaxpuv3dVvhnrXIyeWou3Br4RGnGKbtls873/n6doGztBI5iCpxsHBq1JC83ErTdjESD/FXX6g+HmYEtqp4tF1S3rtbMmx9q0wzeNdIeAQPSFPz0rHNKQz1BNjht7QtWJZ5QJAeFeOO4/jTEwU7GPLUQ9ROuWTkYqKI/ExFQg2m0ALGVX6HWMmPPV8rrG/zilza1gYcYdE4jRNTFPocaWNcRsrk6TR0NvnZwG2VwFkoV0JCtPltyWCnKEXe9qxb+i4q+51SJlKFZQ+Ae8Jf3ne+bLwCv/f7aZlL9q0kg0ZZcVMhMfWE0h1FPBNe9qjtQ1Dscpd814bkoP3IOufvx5O1cuxSiq3Yu+b5v9Nqj9xuIjRcqiDS7dxeXXpJ8CnBxdygHhX8lWEGpmnluy2MdDeeYadplI5UeGzki0pUSVylvC93TZO32WEfVkazjJJgekd7CVmcouS4ZxJ2yZFmNeBvu3LEoCH+t9PZysUsjxW1EeyuoFR0T6t0d8nq73WYUece04a8Zglrgq8ZAwCi9KGP65aPxPSwpwCq0MGJBN0or1YsrOWuWUgexe1zp3IBHxGGeFwR2lq8A74E+uKdZ4sF7wZN1/osqzOorRDljCK2SSHQN6YnnQigZjkKeDK/Q0G7UVxBy
 DqQnZ1tx
 x6nA0BFyM47ja9sQMWN6Qz+jqyaiQ29Yrqq6Vlp0qyqhq5W5zpfO8OzC3KCqjFlxCijb08YN7CDkTm0An7z7Z7S3kc6hKfwwodJwcVqBPPuLkbKqgA1zpYaYJqtC8YYDchxQJe9PqT+X/V7NyvLU2ovYUsq5ubVtOHGEyQtXOlXfCa3QIKjEXfv713xIZCNZBRel+KLF7N2Evu9aT6ueyB3hw22ZB1EY/ifx8gDMMU9J14bXG4imeIOD8wxT4tBgNgeNst7q7tVZvrtUhVf03SiMQbKaBYdH07Kfs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 3:37=E2=80=AFPM Tal Zussman <tz2294@columbia.edu> w=
rote:
>
> Some bio completion handlers need to run from preemptible task context,
> but bio_endio() may be called from IRQ context (e.g., buffer_head
> writeback). Callers need a way to ensure their callback eventually runs
> from a sleepable context. Add infrastructure for that, in two forms:
>
>   1. BIO_COMPLETE_IN_TASK, a bio flag the submitter sets when it knows
>      in advance that its callback needs task context (e.g., dropbehind
>      writeback). bio_endio() sees the flag and offloads completion to a
>      worker automatically.
>
>   2. bio_complete_in_task(), a helper that completion callbacks can
>      invoke from within bi_end_io() when the deferral decision is
>      dynamic (e.g., fserror reporting).
>
> Both share a per-CPU list drained by a work item on a WQ_PERCPU
> workqueue. Producers push the bio onto the local CPU's list and schedule
> the work item, which then dispatches each bio's bi_end_io() from task
> context.
>
> Both methods are gated on bio_in_atomic(), which returns true in any
> context where a sleeping bi_end_io() is unsafe, including
> non-preemptible task context.
>
> Two CPU hotplug callbacks are used to drain remaining bios from the
> departing CPU's batch, while maintaining the per-CPU behavior. The
> CPUHP_AP_ONLINE_DYN callback disables the per-CPU work item while the
> CPU is still online, preventing it from running on an unbound worker
> later. CPUHP_BP_PREPARE_DYN then drains any bios added between disabling
> the work item and CPU offline.


Hi Tal,

Thanks very much for the patch. I=E2=80=99m just a bit confused that
folio_end_dropbehind() only requires in_task(), and nothing more.

void folio_end_dropbehind(struct folio *folio)
{
        if (!folio_test_dropbehind(folio))
                return;

        /*
         * Hitting !in_task() should not happen off RWF_DONTCACHE writeback=
,
         * but can happen if normal writeback just happens to find dirty fo=
lios
         * that were created as part of uncached writeback, and that writeb=
ack
         * would otherwise not need non-IRQ handling. Just skip the
         * invalidation in that case.
         */
        if (in_task() && folio_trylock(folio)) {
                filemap_end_dropbehind(folio);
                folio_unlock(folio);
        }
}

But we=E2=80=99re applying a much stricter check with bio_in_atomic():

+static inline bool bio_in_atomic(void)
+{
+     if (IS_ENABLED(CONFIG_PREEMPTION) && rcu_preempt_depth())
+           return true;
+     if (!IS_ENABLED(CONFIG_PREEMPT_COUNT))
+           return true;
+      return !preemptible();
+}

I feel like something may be missing either in
folio_end_dropbehind() itself or somewhere in the
filesystem/block-device path.

Do you know why they don=E2=80=99t match each other?

Best Regards
Barry

