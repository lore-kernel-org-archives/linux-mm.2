Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B132A606A327
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 16:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Zt7dsEmC
Received: by kanga.kvack.org (Postfix)
	id A8E676B05B1; Fri, 30 Oct 2026 12:31:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A18806B05B2; Fri, 30 Oct 2026 12:31:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E0756B05B3; Fri, 30 Oct 2026 12:31:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 596E96B05B1
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:31:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BF0768072D
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:31:30 +0000 (UTC)
X-FDA: 85379833140.20.D22A4B1
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf26.hostedemail.com (Postfix) with ESMTP id C533D14000F
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:31:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Zt7dsEmC;
	spf=pass (imf26.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793377888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=trsHnVMI6YDWj7rsoQPF0JN2z6GWW+nTgXWERqdG0yk=;
	b=v4hS5uD7QAqwxS7brXJ6dN0VPIP/PVJv7h6OyxTDVUm6CbVon082onRFMPK8BAG8kYAH0h
	mbF+37yzbmFV7WSE7jZsJKhkSKRCQe4w7JfB+ONiNdgfsePWT4mlu7FXXs7lmsJ4v4iqsz
	2h6Hpv3PZVPA0FVw/IEkK3rfXpI4Ykg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Zt7dsEmC;
	spf=pass (imf26.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793377888;
	b=6bxtTrjHPW58TQKtc6rMk6ZSoYYXESDolIIyybxyRoQYBeihYqZYcIN+dX9bkLq0BGeE+w
	QjBeLEdD+GJveb27z2R66yaz3D5A/kadGPsA125BLw+VqRYTbRimb9DTmG/zTqENfYmJOr
	uCy/PTtnL41j+lFHOQQ0VKSKRekNWBs=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48bbb06e746so469627f8f.3
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793377887; x=1793982687; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=trsHnVMI6YDWj7rsoQPF0JN2z6GWW+nTgXWERqdG0yk=;
        b=Zt7dsEmCZicF+zyKY7LF6Sov4JuYrxz6LEY7HqvNEjtHShmNZnvWYjaoBf5BAxF0X1
         ZOK61t8f2RTVblJJz6DNrmffxQx95Pkzakry7GY3XZqtoZjXK2WOHegxjo1yFTfmZPKR
         o6ktQXqzbwHjbvY0Ovgk3UqZQ+84lTGVPCv+my7dxwyCbysHzhRuW8DDtAvWe1QCTx4O
         dlC1w4yCqECwS92cqHVnWfZbFLzYJ4Tfdy1le6USDvKPaMfljtlDGF6fmqTM7kuWtRBy
         o3rmfy6NBl0WkXAajZPccd0nBiaCMrHGjeMDnQyV7u4W5NXDA1GghPf6h5pFvTpQOUFn
         UpMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793377887; x=1793982687;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=trsHnVMI6YDWj7rsoQPF0JN2z6GWW+nTgXWERqdG0yk=;
        b=f3B6jJP1Y9StsBTbi4KZ4aOj0vsTTrYtGmYl9W1Wkh4El4sR9ZLdl5gz9E6MSLn1gX
         ddXKhi5pFSlZTflz0k13PSjbaUYZswIpkYr//LmWJc32ODlGg6wMi8kIN7IXzXbweoE1
         Ohj1ucWnSE5H2DDacHvM+4E+f0mgrJqja7Cl8KIIC0gzOMsvG/a12GfVuxVmW27sPDcp
         ykoqMMj4CvT7epLm8f+g01CCDOWKTw85OGclxW9OISaRmOPYcdj8lwsbNlat5lJBbEZ6
         tGO+8mMfNG+qdXatjDE6n3gp1OqzvsmuUQW27BEC/YUZUx3ts1Mex9NUDF1LJ5tfoXiJ
         aHcQ==
X-Forwarded-Encrypted: i=1; AKwUvBzoZeRe0mbysd3NwXJVpl+IdeC2xKxI8Mk8+ByOP12vKyx86ZtsZzUZmV5Ji5OHht6AH1iRMVfDsw==@kvack.org
X-Gm-Message-State: AFq9FYLc8u+u2rd5sCmKDIKQm5gyiFcpEOglq3EmCtz6ip9tm6U4Pw6L
	ygCQFkSGfhUiEzzLchuf9wt3s+8I7q73bCHZUjAY3HfI5cOd1gocmrTx/ts6ML2oUik=
X-Gm-Gg: AYBFou1Pf19C32FWAhvaRsMK00Mm2g3Gu0yGhn1UYWiseF42FNkBxymlNNZ4PnPStgB
	lo5EC7JMuwSzgrI8QnJ4Hx1//cUiNEguzaMoVbhlwir9eOCcdyvFTW5lBQ6XoJCLensVQpsPtC/
	jJkn7rzgnCIOHS2EcXD3Xjc9j8xlx/a1M5W5B3hISVx2K/LW3LtpFCmd/ez7jntr/Oocqm3myRa
	wc06WmzyCLHyd/TJSgJm+hdxPBGd3LjCf7ZpN+/Zg5UfSf2XTAyDeBi9ZuFgM5ITedxLzoGCsRw
	nV3jhP5AX123lhl9D8WYr6ZNg4J7/6RF0qsgAyZALUYok+vdgD6HEs5AcXauMP24Uyejhy1RSEP
	1hO3AYgjG7FcmU0Y+8N7XRWcmcnAiDuBFCnlZAG6ELSZPiqNqYfTLzZr3W9C0g8A3R0oOBdnvPA
	vCIPtdjkArnx0COb55ktojZDKfYc6pepDqSJdGVe6nRVTVhbSCm0M6c++eDa7oXnTuzXMWUotKg
	mrVOVhfFaqHMIvLj3I5ta/WTzb/dP5uL30WDKEtV5SPgesc9w4tP5hadlLX/qlwSuSMOvA2GGU9
	nHUW7iU+nh8sxkQlyJF+Bs7vT2wcDHLmD8Hi2ajJk0AzzUCnIpt82PBxKEWBJ3+U
X-Received: by 2002:a05:6000:2282:b0:48d:f14a:9188 with SMTP id ffacd0b85a97d-48e73851611mr3804299f8f.17.1793377887133;
        Fri, 30 Oct 2026 09:31:27 -0700 (PDT)
Received: from localhost (109-81-92-234.rct.o2.cz. [109.81.92.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b728ddsm4025629f8f.9.2026.10.30.09.31.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 09:31:26 -0700 (PDT)
Date: Fri, 30 Oct 2026 17:31:25 +0100
From: Michal Hocko <mhocko@suse.com>
To: "T.J. Mercier" <tjmercier@google.com>
Cc: hannes@cmpxchg.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, zhengqi.arch@bytedance.com,
	jp.kobryn@linux.dev, akpm@linux-foundation.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] mm: memcontrol: fix NULL pointer deref and UAF from
 high_work_func() on dying memcg
Message-ID: <auTGXWh2uGK_slxF@tiehlicka>
References: <20261029201858.2932905-1-tjmercier@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029201858.2932905-1-tjmercier@google.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C533D14000F
X-Stat-Signature: hsbgcb369rpooitjskz7d5t9xnkek4gx
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793377888-96756
X-HE-Meta: U2FsdGVkX18skf5w1hJppSK9R0J6+xfY0f0yYzFiMjcA3rPI+P5dKpU7wtvWlYanYaBf9NViqAh7I/+Lgbs1ejHQlTL9z0kCjWAzUz4qtWUPehCN2PKfJsM+TDhUFTEgmZQRmp15/OR1aWv+H7IrZmE5OJPoc/KqDwHRBZYFOdmMXkphsKWQN7h7ZkcNJ8OHiFysD3nRMZ/bK8jBEE/JeKjW9KiriNk2L2ic4BqKbUrLnNRkEYxkZETGvLr+XHeTDPXv18acgbha84kVyn8pSuao96/KqTiR6ru9San2L13g5s4Tr4v6svb+2avN32ltVla6k5hFq3ex2VBqW2Nhk5LA66UawNnU8XjYiQhThJdeBPYhxH1P+b/w9dwpfvC9uNsEWzj25dCJhbLNKW9FzGzX9lJeNch6l0XQcvb6Z1wq7NCt5Vjbn6ge0kQaZuHmrHa8gzGRkBvZU9ggZyVyrk1ZP2QAAPjyA490NtjIJVEmqLjK2JowUvQwGlxuGlv1Hcax9KFlPfRRGIMLNGPpbFkKv1ICeNklc+x74yfQZdHOiCoF1YT37LLkkdpQnmp7AHgvQVkO55rB0jrTxFTFnOKv8xosDi88JNmhrj2/0DH/xHlzi0uHrRAzP369w4gNm1Lu4LQiAgpcdgHAeEoKQBkT1OAqUA8kM6D7djpYOtblxA/Ij+izac3z1QGbb/r4e/r025VZ6SGhjQXX0T1Y2bmHEy4nDA0JWX3MSxZgXnDUZ5Nt7IGLzP+wsJPdNbiQzFDFXfBJAliqoZhLMgqY2eth5vbif6i/iFSdNdC5bkt6P51aYxlEtkYS4n3Zi2FxXlEZFhMCU0baYEzcZ3d4clVcUCpqf8LUpr+2XRITDcJHVIPFlVVcazfrkpuOvkRYOyMCBB4gRZOc/JOoscN1J5KVVkEz/vVu0Ts8/tUduhEU3QhakAAYGAlicIOl5i8/WOSMK7T4mYJ3STNavZz
 pyJKLbV2
 QE55z9fwDucEHi41iE3hQencudbKBkfhLsr6ndgSRZH5hKL7PAVVK7cjV/jVr7eLNieLSc6YKnKGqfaGAwhrOITJq639crzli46Jt9slUva5HWgaSuXwnTeDcjoiLMlLLEgPKJGt2tU2lfz2we7ViyNbgak6sWaXTpE5FPo2VSyL7mFZborexiN+7IgloC+17Q3nJhJArvraOXM+2o47K6CPgCPQn7L5CdZk+oGkEgnMzLVZggpe7DXsaOQk3t8E1bpjd5wf0RB8ByEIyeG3D2fp0/dKNmxAfcvwG7QavRAexo/AwPUtnjwptrghk30SoIKr7klgjS67fYeFI0UExVEOeo3+yjJCkzUT+WbTWWU0nR1t8rZNdwYdkDdB85ilEsuJiR3iyIqkIwGCj6iGcE9EW0582XhuY+yVwWJR3M2cpthb/BQYG6Q8JLZzKs/0CYiPA2pENbneBkXcXi8bQJLWFHYta+Cn226rl2VD/X8SeN0qhDyDw0eJPISMcp+NPCAbuzcwJC+ZBe0VRchIXp2e/3HMB41EXF2DNS7PF5QVg10ORiIcjPlEjEyQWYUswSbQa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu 29-10-26 13:18:58, T.J. Mercier wrote:
> When memory.high is exceeded in non-task context, try_charge_memcg()
> schedules memcg->high_work without taking a reference on the memcg, and
> high_work_func() invokes reclaim_high() without pinning the memcg.
> 
> With obj_cgroup reparenting, introduced in commit bf4f059954dc ("mm:
> memcg/slab: obj_cgroup API"), objects charged to a child memcg are
> reparented to its parent in mem_cgroup_css_offline() instead of holding
> a reference on the child until uncharged. Subsequent uncharges of those
> objects go to the parent, which can leave the child's memory use
> permanently above its high limit, so any later charge on the offlined
> memcg in non-task context schedules high_work. This was later widened
> from kernel memory to LRU folios when commit f1cf8d2f36dc ("mm:
> memcontrol: eliminate the problem of dying memory cgroup for LRU
> folios") converted LRU folios to use obj_cgroup reparenting.
> 
> cancel_work_sync(&memcg->high_work) only runs at the end of teardown in
> mem_cgroup_css_free(), so high_work_func() can start or still be running
> reclaim_high() after mem_cgroup_css_released() or shrink_many() has
> called lru_gen_release_memcg() and unhashed lruvec->lrugen.list. If
> reclaim tries to rotate the memcg, lru_gen_rotate_memcg() dereferences a
> NULL pprev pointer. This issue is specific to MGLRU and was introduced
> with the memcg LRU in commit e4dde56cd208 ("mm: multi-gen LRU: per-node
> lru_gen_folio lists").
> 
> With either traditional LRU or MGLRU, css_free_rwork_fn() calls
> css_rstat_exit() which frees per-CPU rstat data before calling
> mem_cgroup_css_free(). If reclaim_high() is still running, rstat updates
> via mod_lruvec_state() -> __css_rstat_updated() cause a use-after-free
> on the per-CPU rstat data. This was introduced when commit 5da3bfa029d6
> ("cgroup: use separate rstat trees for each subsystem") moved
> css_rstat_exit() ahead of ss->css_free().
> 
> Fix both problems by acquiring a reference with css_tryget_online() in
> high_work_func() before calling reclaim_high(), and by resetting
> memory.high and swap.high to PAGE_COUNTER_MAX in
> mem_cgroup_css_offline() so that charges via references on an offlined
> memcg do not trigger high_work on the dead child and skip checking live
> ancestors in try_charge_memcg().
> 
> Acquiring the reference in high_work_func() rather than before
> scheduling high_work is safe because mem_cgroup_css_free() calls
> irq_work_sync() and cancel_work_sync() which cancels pending work and
> waits for an already running high_work_func() to complete before
> mem_cgroup_free() frees the memcg. css_tryget_online() uses
> percpu_ref_tryget_live() and is safe to call after percpu_ref_exit()
> before the cgroup is freed unlike css_tryget().
> 
> Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 1 UID: 0 PID: 27 Comm: kworker/1:0 Tainted: G    B   W           7.3.0-rc5-g2bba28e98578 #284 PREEMPT(full)
> Tainted: [B]=BAD_PAGE, [W]=WARN  <-- Taint from lru_gen_rotate_memcg() VM_WARN_ON_ONCE
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-debian-1.17.0-1 04/01/2014
> Workqueue: events high_work_func
> RIP: 0010:lru_gen_rotate_memcg+0x1a3/0xe90
> Call Trace:
>  <TASK>
>  ? read_ctrl_pos+0x22f/0x3f0
>  shrink_lruvec+0x16cb/0x1b80
>  ? ret_from_fork_asm+0x1a/0x30
>  ? lapic_next_event+0x15/0x20
>  ? clockevents_program_event+0x2bb/0x6f0
>  ? lapic_next_event+0x15/0x20
>  ? __pfx_shrink_lruvec+0x10/0x10
>  ? __pfx_clockevents_program_event+0x10/0x10
>  ? _raw_spin_lock+0x84/0xe0
>  ? __pfx__raw_spin_lock+0x10/0x10
>  ? kasan_save_stack+0x30/0x50
>  ? psi_group_change+0x381/0x740
>  ? __pfx_sched_clock_cpu+0x10/0x10
>  ? save_fpregs_to_fpstate+0xc4/0x2c0
>  ? finish_task_switch.isra.0+0x1de/0xac0
>  ? __schedule+0xf62/0x42c0
>  ? __pfx___schedule+0x10/0x10
>  ? __pfx___irq_work_queue_local+0x10/0x10
>  ? shrink_node+0x626/0x31e0
>  shrink_node+0x626/0x31e0
>  ? ring_buffer_unlock_commit+0x11d/0x5c0
>  ? kswapd_clear_hopeless+0xa0/0x150
>  ? __pfx_shrink_node+0x10/0x10
>  ? 0xffffffffc0000095
>  do_try_to_free_pages+0x255/0x13b0
>  ? ring_buffer_unlock_commit+0x11d/0x5c0
>  ? reclaim_high+0x10a/0x1b0
>  try_to_free_mem_cgroup_pages+0x1f9/0x5a0
>  ? __pfx_try_to_free_mem_cgroup_pages+0x10/0x10
>  ? irqentry_exit+0xc6/0x670
>  reclaim_high+0x10a/0x1b0
>  ? __pfx_reclaim_high+0x10/0x10
>  ? process_one_work+0x5ff/0x1030
>  ? __pfx_high_work_func+0x10/0x10
>  process_one_work+0x6e2/0x1030
>  ? __pfx___schedule+0x10/0x10
>  ? __pfx_process_one_work+0x10/0x10
>  worker_thread+0x422/0xbb0
>  ? __pfx_worker_thread+0x10/0x10
>  kthread+0x2cd/0x3a0
>  ? recalc_sigpending+0x15c/0x200
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork+0x368/0x590
>  ? __pfx_ret_from_fork+0x10/0x10
>  ? __switch_to+0x588/0xf50
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
> 
> Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
> Fixes: 5da3bfa029d6 ("cgroup: use separate rstat trees for each subsystem")
> Cc: stable@vger.kernel.org
> Signed-off-by: T.J. Mercier <tjmercier@google.com>
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Muchun Song <muchun.song@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

-- 
Michal Hocko
SUSE Labs

