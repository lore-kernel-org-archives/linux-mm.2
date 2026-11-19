Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F2FC606A331
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 11:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GURvDvKB
Received: by kanga.kvack.org (Postfix)
	id 756BD6B05CC; Thu, 19 Nov 2026 06:33:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 707586B05CD; Thu, 19 Nov 2026 06:33:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F5DB6B0618; Thu, 19 Nov 2026 06:33:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B77D6B05CC
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:33:17 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C9055140A16
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:33:16 +0000 (UTC)
X-FDA: 85451657592.23.2B505B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1DC7480002
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:33:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GURvDvKB;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795087995;
	b=Yos4WsKgp9ehncxomUgzTJWJgL/5EWea8HpXKdL5XvVncTTXa24RGHrp7HnxywYLf92zkr
	zp4Q6YrIhbnLZQAhkQ9STDcpD8+fQNX991nblHhSirKtsE5NwZI0VysjYs6XQ/XYQ9PPJn
	zYa3zIIZDhPaUxy3cYKe3hrIOg89ajU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795087995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3jA+oZ+5iHu+6qDUVQHLEuIm2QvBD2uST/vEYY3WW1M=;
	b=0P4kupVUmD1XrdgXtqpyxPQ6eBnAUZdfGvXElxAx3/3EpBW+XROpvdtJd6gQ1Y0ifnNDcO
	BXoQjwmt/prD/5ajRVrb+Y6t6ZunSX2/YbuCRU9gFgSA4tggxgvGeV8Ft8D05uHsMd7bEq
	ACZA6qQybqe6MZ3Vk2sUB9wbRzX4yxo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GURvDvKB;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 151344785B;
	Thu, 19 Nov 2026 11:33:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52A61F000C8;
	Thu, 19 Nov 2026 11:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795087994;
	bh=3jA+oZ+5iHu+6qDUVQHLEuIm2QvBD2uST/vEYY3WW1M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GURvDvKBbWgEGx0orgwtNauW3gLt2TOPbl2oLQ797swNjSd+tOF6ti/U/myWq/oDx
	 OePh4v1sE3qP1ttZduAMVjZ3daFXGbkOnFmcsG7H5GKN4Esr7lRaguphv57fT9Pj26
	 JdLakKqfdjvkVXCK3p1JP0N0RzLjlN83OO8VtiUglo+sQgyvynPVbmkwoUHUk4uSsM
	 Ift8s/gM+NRwen4hkUOyiCOaieIAW2pT05wgbPR9X88d9J/7+iVKlTp5q6G0EDf2Rp
	 UGkDxNavpvDyMYUtJsegN6Qw1IgLo2+MKMZnheS68iS/R/HhFaQ5KrzA0cZnDBtGZx
	 XRxCk8VoWdy7A==
Date: Thu, 19 Nov 2026 11:33:03 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Kees Cook <kees@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, Alexei Starovoitov <ast@kernel.org>, 
	Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, Ingo Molnar <mingo@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	Chris Mason <mason@kernel.org>, Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] fork: clear p->mm when copy_process() fails
Message-ID: <av7b64FqD9Op5Avz@gremlin>
References: <20261119-mm_failed_fork-v1-1-b3019f43d197@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119-mm_failed_fork-v1-1-b3019f43d197@kernel.org>
X-Rspam-User:
X-Stat-Signature: ocxjm3rdtki617r1zy86z8ejud5eoru4
X-Rspamd-Queue-Id: 1DC7480002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam08
X-HE-Tag: 1795087994-846467
X-HE-Meta: U2FsdGVkX1+dBrD4f5IHVbMTF/9ZrGXXAYJRbEGQMh292Ivv3QQjfzH09FKUiBZlBqhUb3H1WD823ShGr4WUP8JdhjOxa70nA+6gc0JysCp1Dft9KyMwoA5hC5Hh/s4JuZHmQi/N/Y9sHdlNsXOf9hh+LqUUzVVfpVwqBeJw4R4zGHIc5E7Oxef9p8QsYwm8vJs4IET8NdqplxDx+Z6u+MRHYcF+S1SiCrHlPdkcvcFgKJeFdLecgeR6LIZDvfX6g1gl4HDKpnAf0wtDcIkw0oActUVkv3/hckGBLh9uATVpey5XzwYg1TrOoCLvkIHJEr5dZQUxSRwKtmDhZu7hliEB8w7B4busD6eZPvPkVkQNwtL1FLJFwReYZZJNI89ss0kNHc0FbXKHY/hj5CLa2ryiyGTaHh4R0MF+shnMLk6T/tBhgKb0/uhoczhTdSBPaSvoHVD5jiNhktnkPF7+D/Z3kmDuBeisbAwxjnAhXSwBAi76a/UINWy+L5+Andz1F20ca93lW3TX2zOimwBE93dhfpoo2HDAbi4ikw6iZuD681uBHXtBC0n3Cb3RKwBNqpsk6UPmJpfs8/XTRoGEOsiby/tG4SYwSA/+7ue+rRAwcfzYFvUNW08oyiYOZKmIvWStSXEOiiFa9Ze3jTZAZYGSd47CrqEppUr1HlSDSUONDK7dy28mUQwy9N7KLXuGWT6Plo43LvLtcKfch4f4givlF/xvaEjDOcxF0IMQ34mdSRD6tEqfHcM52mMhHO4X1suP4g8mlVkdBYHSGhjl456qU2xC3/2dtPMUgpuvC1OYBr9oO/yvbddswO3GXuU/5QAIYWBDhZfG71YLoFWVVWtVfeSdHjC/Dty6RT5lRsXls/ERBcE+fZEpFD2h/Wkf4w0pmByUAdm8ELWDiZOyThUdVOgJSj69gt2xfNs9+Yc9YVKsJ5WYRNVvNnh67CNqnKi4VIOS34T3yaKRs7i
 4Qmp45/B
 5lTHxZ32pnw3oYX7M6GeU5+D7UHxcqeGP/XguCsFHoPC9XixTaqAfQzp0NXdIXK1miNOrvUIsRqjzau2DQnw/FQzoXgavvXSG/sGtH1ZGRb9qfW7IjS0V7iM3VtHaeEmTLix6GVutlxcSgpR4qGMkvwoZYOst4z2o5Erp5/VDkn5DGgqHGHFFhLUlfRo5VvMMh+jYOlbC2NTeB6peLoo9qEDoXU/DKY9De5X7tLwY5cIg87VfsgVVFaCnh1JXtZT3qiU+73Jg8hvjpU1ljUH4YEx+A9esYTCIvU5pNQqZsxZJ1Kxag0e24f8Lut6orvCIoQaD1OuiaFqbzuUPlGhrdjax4Ul00PGOIiWrjg4pmo/AkHaqIypZoADyaSfrH5L/YZuW/DwlK/mSl2HUO7T63tBprs88TFX69xIICBlhWJxX7QNaY2sXyIV4EMMMu5oNRWmIfpcdAZxuQ7Fya0uHHeUwENldxdI6aloIRrcjkFczOns1VkSaR1ykCifFJHfKxve0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 09:04:58AM +0100, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
>
> When copy_process() fails after copy_mm(), the error path drops the mm
> reference but leaves p->mm set. Perf and BPF can still reach the
> task, and take a reference on the already freed mm through get_task_mm()
> or bpf_find_vma(), resulting in a use-after-free:

Good lord :)

>
>     copy_process()               PERF_EVENT_IOC_SET_FILTER
>     ==============               =========================
>     perf_event_init_task(p)
>     copy_mm(p)
>     a later step fails
>     mmput(p->mm)
>       /* frees the mm */
>                                  perf_event_addr_filters_apply()
>                                    get_task_mm(p)
>                                      /* use-after-free */
>
> Similarly, a BPF program on the task_free LSM hook can call bpf_find_vma(p)
> before the task is freed.
>
> Fix it by clearing p->mm under task_lock() before dropping the reference,
> just like exit_mm() does.

Sounds sensible.

>
> Further, if copy_process() fails before copy_mm(), p->mm is still the
> parent's mm pointer copied by dup_task_struct(), without having taken a
> reference. While nobody can access it concurrently, there is the
> chance that it might get accessed later when a BPF program is attached
> to free_task().
>
> With CONFIG_MEMCG the task is freed after an RCU grace period, so the
> parent might already be gone and p->mm in the child points at something
> that was already freed. So let's just clear p->mm before freeing the
> task. No lock is required as there cannot be concurrent access (and we
> might not even have the lock initialized yet).
>
> This has medium urgency.

It sounds... horrendous though :) but I guess possibly hard to hit?

>
> Fixes: 375637bc5249 ("perf/core: Introduce address range filtering")
> Fixes: 7c7e3d31e785 ("bpf: Introduce helper bpf_find_vma")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/sashiko-outbox-180866@kernel.org/
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: simplify description and comments ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> I can take this through my tree (rather soonish) unless someone else
> wants to pick this up.
> ---
>  kernel/fork.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 5efceb8d58a78..77d6c8fc38c66 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -2628,8 +2628,14 @@ __latent_entropy struct task_struct *copy_process(
>  bad_fork_cleanup_mm:
>  	sched_cache_fork_cleanup(p);
>  	if (p->mm) {
> -		mm_clear_owner(p->mm, p);
> -		mmput(p->mm);
> +		struct mm_struct *mm = p->mm;
> +
> +		/* Perf events and BPF programs can still reach p. */
> +		task_lock(p);
> +		p->mm = NULL;
> +		task_unlock(p);
> +		mm_clear_owner(mm, p);
> +		mmput(mm);
>  	}
>  bad_fork_cleanup_signal:
>  	if (!(clone_flags & CLONE_THREAD))
> @@ -2663,6 +2669,11 @@ __latent_entropy struct task_struct *copy_process(
>  	exit_cred_namespaces(p);
>  	exit_creds(p);
>  bad_fork_free:
> +	/*
> +	 * If set, p->mm points at the parent's mm without a reference. Nobody
> +	 * can access it concurrently anymore, but prevent later access.
> +	 */
> +	p->mm = NULL;
>  	WRITE_ONCE(p->__state, TASK_DEAD);
>  	exit_task_stack_account(p);
>  	put_task_stack(p);
>
> ---
> base-commit: 4405c18c95d2d0f99f6c581ef0ee8591a1aa6ccd
> change-id: 20261119-mm_failed_fork-a46141b503d0
>
> Best regards,
> --
> David Hildenbrand (Arm) <david@kernel.org>
>

--
Cheers, Lorenzo

