Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12546606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 14:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nsk7ivH4
Received: by kanga.kvack.org (Postfix)
	id 10B3B6B05B1; Mon, 16 Nov 2026 09:37:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BCD06B05B3; Mon, 16 Nov 2026 09:37:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F14696B05B4; Mon, 16 Nov 2026 09:37:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C5CA46B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:37:33 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 52F3580115
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:37:33 +0000 (UTC)
X-FDA: 85441235586.07.8B96C46
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id AD24140011
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:37:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nsk7ivH4;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794839851;
	b=H3Xv4ZFTFkspZ5wiZwD1O5X+GSPOe9A3emcUGzTlgo5NV8d5Lr7CuNGxjSOS6/geSsBimQ
	aholIjhc345q7ASgazR7Y12tx2WnswSJJratYEu175109XsCB4APVSH4UPps5I2PFu6mpc
	qoupYzWXoHunPAwu5+2ZpCvpDtl/K6g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794839851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cnLyN3SDo42Ts0cPpeRwTJ3OQjij9Avhcc7a74dY1sU=;
	b=cTkT90TEV6rFEFgBynrTeQ/khaxPJj3t9vsisRE0TKh9U1E2OM0JubLe2xp85aJt/zLoKD
	yvQ1Irp4BLQKi8KpR42s5/ALqJKIfS1H+1pAiVrUJ+/kycRFdACBQj4PcGyJSEgUQpqJ9t
	SLu+168Nc702NHyX4W5BoO3StVA71Qc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nsk7ivH4;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2950161D32;
	Mon, 16 Nov 2026 14:37:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17AD51F000C8;
	Mon, 16 Nov 2026 14:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794839850;
	bh=cnLyN3SDo42Ts0cPpeRwTJ3OQjij9Avhcc7a74dY1sU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Nsk7ivH4zkm3sL2aLEVd/NzHmTQ+e8khI0RzK2WdOavqoW3b/h9TAN2I9ALOjFQ/O
	 ZqA9jAR3LTdYwOI8tLdKz8BZMMTvDGXOxJGpDa8jFGgrLVgzWpZNdc9U9J7Tj46MW9
	 xEXFO38a7FUvY4lVKOneFogrww7QliuaboAQ5Iut1kxQQQPkdIjFMqeWt6kHeyEbpz
	 Em/Ka2DBF+heM1tTcfE3WWBDO9AltOwNOGfKgqCVu1SnCicLeJnrmym4/RoZ6d5eyn
	 UYxN1N17hzF9Hu8qd+ZraIi0Rz8rXtFAaGFp/3qF8AystJhelYUbykvkXI/Vn/lAmU
	 eumRjTEyOTfWw==
Date: Mon, 16 Nov 2026 14:37:25 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	ahuang12@lenovo.com
Subject: Re: [PATCH mm-unstable 1/1] fs/proc/task_mmu: advance seq_file
 position on interrupted VMA lookup
Message-ID: <avsQKLgi9bqD51W8@gremlin>
References: <20261112140101.647-1-adrianhuang0701@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112140101.647-1-adrianhuang0701@gmail.com>
X-Rspamd-Queue-Id: AD24140011
X-Stat-Signature: i9xmczuph4tdjs99rk8ktqf7kr83kkhz
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794839851-230268
X-HE-Meta: U2FsdGVkX184PkepUrYQ6Khb8dOsSn5HwaiDLHd+BdaVILvIF5Ui50hbgGexyLA3J7riQIW+NaaWM5Q0/Fe+Tnoqh08hLnoYkY2DBspGdoZxJ/s0TFjaQ5YLcDRdesgI/cCCcHis+sly2zQh4DLB3dU38ZIfj8XPS+GCee8RQhzu7KfHHSVsd0hzg5fZ4FP0urj/36PbZcWwaAM3s6Y5gz5k5rZGvqXVGOu5OENYlRCzYQg22/XJ7q8tMb7iHi7bP3vQ881bv6wBSsXQI6fHuurshG3WViKFawcouMmPTTgd1dvNQUCFDct/CmbOfQcO/Ofr81XDklNjuFsD83Q26LwR8TqHmfhaK7X5vdOnUxIHsUeZF7k+FtgODzRBcKxeNvJbhgj72OJJKr3vi8vr+V7EzbWzPLrjeouODHKvxMdOwTKpPlnTzRBe9t7F+qPPq4uYO3jB8EPnQxdY2FQ06oreBNBwQGda3N1fLAJggbxHL+9hyIc0BsUW/7cNmZ3gg5pRr51SmQXRWzqwC2J2UAckP1mnk5HgtmxwPThloDdbS8jrAKTgAwL7imNfVdGLxkhEcKq+i8VBVUepTNVVRN/1AyhlinyebYe73F6K6GXX3FMFAXl9kuut3nkvJVBYgfVxn7eGBWiPNhgz+oC0QT/7CkUr9fyongenwsTB4ZfOEIFOQ3qvtbToA8imCN49wh5BNxjACwwGGQ+3LeDZPq6GcMQxhCsVVvbrhtUbMKJ4qluG44COC69iIgWZ5uy+1k/8SbakhdeGlIfMat1P13lTrnfyjUmt5CrcMd7RLC5pOhRZelh9gEWkv+zNU2Gho2cbaWzXC7nPlxfrmBtIIpbaugE1fiR7vx5zGUMkPQFZfk1vR2VcH+HQWVyFb9ucMjcN0ZoeWWjagZimupIKHSnl0J8iCY7LRhMyxWM1KP+xBkevtrcZiP+dkJ+F4grDvCJVdPhsfFvQmhBfprv
 tdqc9Myr
 0CSSKVEJ+wDLoava3yZwyyy0nk0D038fjPS6efWpybZEtBFhLC6E834tN3+yfZIz/2YiLUbeulHdtKK/KxI6xkGpvXKl53Vabo8F5+GiiUF3tmSmSPbQI2VnDdCuZy8eVDQfb86lO1kneOATAufwBxgIdUvX87RUjv0F/zD3wtYn1j9U9lPfQEuzE/emmeMnt14xoSBOcc0s4KCUnT7TvVV6vXzQw0uWT6sBQRKdzmuLItawNQngg6eSbzWgbrxGpIbIsdJH/FQSK15fxBmUI4AcKx065M88PVvDIOFhT/p09DbIDSAvge+OUjnjzcAx7ZAIQYbMAVwMJi8uKrEoCQY5Oof0fj8saFE4shtFwCM0nwWPtd7MJF3j5GDqWj12XDwLf/+fvGGmUZI/xhuh9h+bWYZzJeZy6VzuWr/qIJUxFYp+NRZUrpD7W19+PH/+D95k2lfMvK6PXZd4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 10:01:01PM +0800, Adrian Huang (Lenovo) wrote:
> Commit 5631da56c9a8 ("fs/proc/task_mmu: read proc/pid/maps under
> per-vma lock") introduced the possibility of returning -EINTR
> from proc_get_vma() when the VMA lookup is interrupted.
>
> When this happens in m_next(), proc_get_vma() returns an error
> pointer without updating the position index. Consequently,
> seq_read_iter() reports:
>
>   seq_file: buggy .next function m_next did not update position index

What does seq_read_iter() 'reporting' something mean? It feels like you're
trying to make this into something bigger than it is.

What you mean to say is a rate-limited pr_info() output occurs, and when a
process that _has received a fatal signal_ (!!) somehow continues long
enough to try to output more data, you get an pr_info().

The relevant code from seq_read_iter():

		if (pos == m->index) {
			pr_info_ratelimited("buggy .next function %ps did not update position index\n",
					    m->op->next);
			m->index++;
		}

Anyway you should mention the fatal signal requirement clearly.

>
> The above buggy message is reproduced by the following command:
>
>   # stress-ng --vma 0 -t 60

OK I could reproduce the output locally. It seems that this run results in
fatal signals being sent to the processes triggering this output.

> Update the position index when VMA lookup fails, as required by
> the seq_file interface. Also save the original position in
> priv->last_pos so that subsequent iteration can restart from
> the correct address without skipping or repeating a VMA.

We don't really care about skipping or repeating a VMA for a process that's
about to die :)

We may as well do this but better to just hoist that to share code.

>
> Fixes: 5631da56c9a8 ("fs/proc/task_mmu: read proc/pid/maps under per-vma lock")

This isn't really a bug, it's really cosmetic to be honest. So not sure if
we need a cc: stable hmm.

> Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>

See attached suggested patch that makes the comment sane + hoists the shared
bit (dropping a silly existing comment).

With that and an updated commit message should be ok.

> ---
>  fs/proc/task_mmu.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 22361607020d..164b4efc5e09 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -221,6 +221,16 @@ static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *ppos)
>  		if (PTR_ERR(vma) == -EAGAIN && fallback_to_mmap_lock(priv, *ppos))
>  			goto retry;
>
> +		/*
> +		 * seq_file checks that the position advanced before it looks at
> +		 * the returned pointer, so an error return that leaves *ppos
> +		 * alone is reported as a buggy ->next. Advance it, and keep
> +		 * last_pos at the pending position so m_start() would resume
> +		 * the lookup from there.
> +		 */

We don't want (schloppy?) comments that go into painful detail about super
specific elements of the code.

This is asking for bit rot and is too complicated to be in any way useful.

> +		priv->last_pos = *ppos;

This is duplicative with code below and strictly not necessary for the fix,
better to hoist I think.

> +		(*ppos)++;
> +
>  		return vma;
>  	}
>
> --
> 2.43.0
>

Suggested:

----8<----
From 860d936c61bb641b72135e95c291aa6dfbf5fb0f Mon Sep 17 00:00:00 2001
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 16 Nov 2026 14:33:12 +0000
Subject: [PATCH] tmp

---
 fs/proc/task_mmu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 22361607020d..564e52f7ddc6 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -216,16 +216,17 @@ static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *ppos)

 retry:
 	vma = get_next_vma(priv, *ppos);
-	/* EINTR of EAGAIN is possible */
+	/* Store previous position to be able to restart if needed */
+	priv->last_pos = *ppos;
 	if (IS_ERR(vma)) {
 		if (PTR_ERR(vma) == -EAGAIN && fallback_to_mmap_lock(priv, *ppos))
 			goto retry;

+		/* Advance to avoid spurious buggy seq warning in dmesg */
+		(*ppos)++;
 		return vma;
 	}

-	/* Store previous position to be able to restart if needed */
-	priv->last_pos = *ppos;
 	if (vma) {
 		/*
 		 * Track the end of the reported vma to ensure position changes
--
2.56.0

