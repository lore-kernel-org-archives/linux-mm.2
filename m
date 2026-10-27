Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1CB960A2608
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=hfXrZmdt
Received: by kanga.kvack.org (Postfix)
	id 0A81A6B07C0; Tue, 27 Oct 2026 11:34:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0808F6B07C1; Tue, 27 Oct 2026 11:34:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB21D6B07C2; Tue, 27 Oct 2026 11:34:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C8FFA6B07C0
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:34:25 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 33A03C0142
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:34:25 +0000 (UTC)
X-FDA: 85368802890.18.8D380A3
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf11.hostedemail.com (Postfix) with ESMTP id 37B2E40011
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:34:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=hfXrZmdt;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793115263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3BCqo9DTVlGvGGt63tyjWLqgcTRJp5lddshmK2HXV3Q=;
	b=pW91gLl+CXW2jfRTwi0ZJZ99gXVM/szBpStwOnVmVc1e+dZukPLGMHkRNdaZ8kcdaAP4iW
	bZ5hByplIAvhAlmqJDmCHnW0zzWFpU7XALTNPTRz+PVY0w9O1rv2et23xYGhFPmQIgeXSi
	nV7Wf5hUKOBkEzX4k8SBpVoXyUNgPmo=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=hfXrZmdt;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793115263;
	b=tmIM4gFGSjcFJAu8jiA+IKF5jgN/N9rSW/42bzRCX5k3qZ8b+tXlRT7xmSOZuaIQRBHnGX
	mi5nFa2394ngSp/OE9NkinM2KVQGEwF30OvoJAdFS45MS4WoKJqWYku3sqYFf1Ng1xCnMV
	XooJ5gPXamPXocbKM2QwS7Z+RnGH4ME=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5383c97c8cfso324561cf.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:34:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793115262; cv=none;
        d=google.com; s=arc-20260327;
        b=eCuU4AH4uj2e1IO/8HGupTZux0FslJMoaeTLhZjLiQd54xZp6xHdfnSre4Iq/0DGsL
         sOeX86/dQ09D0Jq83Sd4cvL3BFzQuMASjII9D9ORK7xNa10tuk4q+uIe16h2x8SEmu0B
         D8iowpqBK5Ks5LKeBvy36+6F+WbpdXii8v4ip3zLSBE+Gmsgpm3k+OucAmFM8jrZza5j
         yj5O2B1rPNZDb6QVOX9LdvzcMEFYrBKV2PTBLvLuclsb7JraCZVD3nbfKNDMDg9PWxui
         SUoePtzgV4/V2JUH+Fk8/srJL8N7b1xiBNU7IdLVPM6ekqNZWm+AInOiyId3QTcfxoEu
         HTEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3BCqo9DTVlGvGGt63tyjWLqgcTRJp5lddshmK2HXV3Q=;
        fh=Y0/w6SuO4cPBJ6323qZL0bbE5VDYiNsKk2KXkJr6jPk=;
        b=WHVZqqO8eS9y39xXTR8cgYZlheO30I21DBXhAVcRVe+qsm229yz32WjZc7YZOqqXg1
         xliSR+LjSBfrbz30tb6r4o0XJGs7tHeVCHpVR5KGoIIivnGmwfxaiEr3AMGm1iwErrCU
         xkVmuA3j/j05bjRSAtiH0M8jZJroEP+g8ge7NJ4Pltk+URXkVyg02QqJdg4SNfnQkqXP
         5Q0rfAqR9HdLFznUtRKONlZ49dOKHWQ8nDxuoqxpBpRn9qXVrtuIysJN6g45qpl9O9zd
         In84+Ib9LRf5Dfpd3LaSTFowf/zKaUFN3JJ71MCW2NbRWqorBMM3y1ZAVz5mb9+sNPW6
         A+kA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793115262; x=1793720062; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3BCqo9DTVlGvGGt63tyjWLqgcTRJp5lddshmK2HXV3Q=;
        b=hfXrZmdth7lH3R/gosNhJ0NC2Vn1kXRdXesgrhIVE9GCxhmopbrGdLB+pTHC2BquCk
         OfnFwaYMuzaLOe3XY5rYTZrEc5vTCWteU/c1smY9NGepLlmEgTukEi3Yv/1UqlAVnrFG
         s/kZO8xlVIcCoH92hU7hY5ZYlUR9z2Ke5cHML88R3l6UoumRkiiKY5gw1Msm8N9IHzDv
         fqyVydPwxCk7KkJhDLNBsbHnKL5Ah4XoJnkw1n2bz+KafweG37m4l6BbPksGSPF0KXyj
         UxtcLsNMySNEiSzqgHJLzUSxHKbkNWq6OeAM0CLcpcUnXSDLplB2vQOTWoobGxE+HVGb
         NELQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793115262; x=1793720062;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3BCqo9DTVlGvGGt63tyjWLqgcTRJp5lddshmK2HXV3Q=;
        b=0avfdH2OaK3A/ilbgPDx3OQ2ziYXegXWHcYsKwtUKOv8CSYrtwWRu2ApR0BNPmOkKV
         ZI4waGK0YNW1uQuUcAfzEOyZOPjibaLiLkgo/8b1nXUxZj9VqSpr0qxcZRUVyUAq72CQ
         mmag3jnXyDmdK5abVS6S1hzKtH7nCwsAbpEoWdbJjxgyW2M1TefokDE7U0K+EPlhWYCW
         iu7GfzsgHLwgjz5oQVgx7wSFfWU0UPsWbQ/P1kkTl5qVUmacdE6WRufoOI6aY+4vA6JE
         Cq+WQiewKN9TUB2jThiO3JbgLmbQ20IXNrybG0eF0MjaXbhvx6YUR2H0/YD8E0ngLTAI
         wzww==
X-Forwarded-Encrypted: i=1; AKwUvBzGGHG1iP2rx5rWzmlhPVGZKf5aal2woC2j9+D1COSBTIbivLJEw3+ABHZ1aAcW8g94fh+rSdGYbQ==@kvack.org
X-Gm-Message-State: AFq9FYLX/SlspFiLXZPNJLtk+vSNgzJM8E/wPy5jk6vHIEtlj6N8cdzr
	E+/HZBUZkDfse8qNddPFoATJG2+hAHSpqsWg4C47vK2peGz4SJcLWo802ambvcLaZkymzKAo1aV
	Df9vS57DT8YKdyxYZ9Y0FjHnyGmyY65JX7nwbhV5U
X-Gm-Gg: AYBFou1CqotvK6ZZl7AFUy4sTcSMlok9YR8xjmzvhOrlzRwBr9KXr7LGNvNbBfOHMRk
	q18T9t0btn5c1bE6dB6C08ZdJHUgsy5Z0l+HduGEPk5aWP1lcGHFwRgIrZFoRvYcmYyPsY5ObQ0
	jD8ETBWaU6WEM3f9HHYgmVieUEhUfqH8ga/QzZLcKtdlIoxaUboH8ynPPYzgskdS6tPOhSOLhOc
	+Xx0kpRrcpd7X4TYHJwQ4up5vbFDIqQsaZepE/lylFvVKDDEZZVybzyPLEujw2GiDW5ClHhoL3M
	QQlsEzXVLdSiDfHTnG7yPbTU4bvRJOyZJd572YoQ2sTa0WeRvVWvLRlTIbtw6wftdK2ryWQ3oz9
	iTGWSDsTIrnSxtJXlNtjli4Fbrv+l7Iw0QMHfh5Rxj+MfhM7i8q4G9lLbKoS6QXvtcA==
X-Received: by 2002:a05:622a:2616:b0:535:9aa3:5ebb with SMTP id
 d75a77b69052e-53e75218a9emr18868671cf.8.1793115261144; Tue, 27 Oct 2026
 08:34:21 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261027-fix-proc-pid-maps-missing-vmas-v2-1-2791cc9fc95f@kernel.org>
In-Reply-To: <20261027-fix-proc-pid-maps-missing-vmas-v2-1-2791cc9fc95f@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 27 Oct 2026 08:34:10 -0700
X-Gm-Features: AclHuK_escKhxIfcgdWHS93RIjhc6nNSVRM5pRyb491eVnaMJqYuWsz74l9RKRk
Message-ID: <CAJuCfpELhxhyVQANspX14OBLbghiAqndYcfv1hnmh4Nvo=1vAQ@mail.gmail.com>
Subject: Re: [PATCH v2] fs/proc/task_mmu: fix missed VMAs when reading
 /proc/PID/maps and friends
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Shakeel Butt <shakeel.butt@linux.dev>, SJ Park <sj@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org, 
	"David Hildenbrand (Arm)" <david@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 37B2E40011
X-Stat-Signature: x6t1magnyfcjrh9eba3gct1ufky46zr6
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793115263-109173
X-HE-Meta: U2FsdGVkX1/vlAq1oqGvzcLB7+derE781BEtx6cTZ+JDrZN5ZJZwBFxMJp2AwaQOs5g4QA55Qv6PkDNvN6bUcPtDpQLukSP3wHzgSM/HDRHV43BqkKpjrSqQZacVHvKHNQGVHHF4cSk8SmLDUF2YRC4RNt5VGxDWkedY/du5lWJO/ermRRPRn2n2sYeyUe3Utc8CXUtTiyOIjYyq32TQcI6ZI3dZddx596wn3TyVr8lLo0DLJkAzQaJu8/hNES4afLKOVrCtDoFhd63TOd2Yahe82Kx4cOikemky09XQA3JK2WGEclErCeYrwJkvS8F0WeFV8clUgyPV4XGCjL3P2tFYzvJ9UMBh+cDetR4rq9JNbqjH/HCpPOObctr7PWWOqNq+cnHvuMGtN8kz3fyvtiBcCANxKQo5M4ZvLEwxbpt2oH0YsrOUGSmBt/FSETW4k+sMJ8Vrl28UOlosIbyOMMYiU1lrEBOL4+9gtxNBMbuNquhIdmCgNKi1Qob7u3jjRsKexiYyqAH8R3fC+s3BBQSROWkFMpFZUf+4TGcb321FpVtAJj97g71M9exeiFl48zK/pmX3HN+QJtRqTCK4SbMp6/aEI9WAXYwR3Yz9CA68y3p0RkcEl1jlH2h2NSA/zhNkx4gIg/Asf/rLwjw88zeJlTvc/olYZY/QFKtnDbwnmgfcWsccW/i7tCCwfvVtDRQqfseRFsknjIMRXngylM2uVx1qlCDK8UhT3X1b3e+fHsMadacx0UVc3vz5HYzulNKAHRADpqTNsItZB8Fh0cDskApEyv1Jhru9NinZFCjrMXQJKGn84csOX3Buq/z8F+5iGMHkHiJ1uVXbmT7dQtY1xeIJJMA21PKnvjqqS6TheYcUAUz77krD6WwMy9+qy4OE76E8zF4x/glTR84IFYtPzWbbWmrE2pHys19V+mf1D87s64ZamgytJGrVLCFwX1EUiVMhuGzRTvc3Awh
 3SxKlRqT
 tfRGvi7e31PZ9WXOwljwe/wSZEowaixrdCC0AuQPvIV5XjjnS5xSvP1dkhaBCU0U2QF+5NQcsYH5qyPt9Y0VUhXSYHqQX/HxkoVzo+EbER21CS9gFbrPdMc9tEDLILkTHNtsCECOf06ePU9T+zn2w5+tW8QPvBUhyIchrFx5hfC/fqDrHLUAG13AOT7d+wR7SLunDmy9UYLHHXDWDY3Hc5VN6lztlRZ9uoZLzkVsjs87DHUKcfXNG6o9kXJFJ9v4BxCnTaHbv1NBLDwWfNYAjlxDpAz53VxdyqD3MpQXF5K268SdxgFLI3+m3aQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 7:08=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> Reading /proc/PID/maps under per-VMA locks can skip continuously mapped
> address ranges during concurrent VMA splits or merges. This violates the
> guarantee in Documentation/filesystems/proc.rst:
>
> "If there is something at a given vaddr during the entirety of the
> life of the smaps/maps walk, there will be some output for it."
>
> lock_next_vma() reuses a tree iterator across calls under RCU. The iterat=
or
> remembers the range of its last entry. When its node is replaced,
> mas_next_slot() walks the tree again at the last index of that range, the=
n
> advances past the entry containing that index. If VMA boundaries changed,
> this can skip a range that has not been reported:
>
> - A lookup finds [A, C), then mprotect() splits it into [A, B) and [B, C)
>   before vma_start_read() locks the first VMA. The reader reports [A, B),
>   but the iterator still covers [A, C). The next call starts from B yet
>   advances past C, omitting [B, C).
>
> - The reader reports [A, B) and unlocks it. A concurrent mprotect() then
>   merges it with [B, C). On the next call, the iterator resumes at B - 1,
>   which now belongs to [A, C), and advances past C. Again, [B, C) is lost=
.
>
> Checking the mmap_lock sequence only within the next call misses writers
> that completed before that call began. Also, a NULL result is currently
> accepted without validation, so a race can terminate the walk early.
>
> Even a fresh lookup can skip a mapping. Suppose it finds a gap before
> [B, C). A writer inserts an adjacent VMA at the end of that gap, then
> merges it into [B, C), replacing the node. The lookup resumes at the old
> gap's last index, now inside the merged VMA, and steps past it. The
> original [B, C) remains mapped throughout. Repeating the forward lookup
> is insufficient: another merge can make it skip the same mapping again,
> returning the same later VMA or NULL.
>
> The fresh-lookup race also affects /proc/PID/smaps, numa_maps and
> smaps_rollup. Resetting the iterator after gathering each VMA's statistic=
s
> does not prevent a merge during the next lookup. Fixing lock_next_vma()
> also prevents omitted entries and incomplete rollup statistics.
>
> Tie VMA iterator state with the current mm and the write generation at th=
e
> point of last mm speculation in vma_rcu_iter, whose values we call 'rvmi'=
.
>
> This allows us to neatly abstract the existing priv->iter logic alongside
> query_vma_find_by_addr() which uses its own VMA iterator.
>
> Then, provide helpers that act on the rvmi - vma_rcu_iter_[maybe_changed,
> may_have_skipped]() to determine whether any VMAs may have
> been altered since last mm speculation.
>
> Additionally introduce vma_range_is_empty(), used by
> vma_rcu_iter_may_have_skipped(), to determine conclusively whether VMAs
> exist in a set range, needing to be traversed.
>
> Original fix generated by an LLM and sent by Josef Bacik in private, then
> amended by David Hildenbrand, and Lorenzo Stoakes added additional
> abstraction.
>
> Fixes: 5631da56c9a8 ("fs/proc/task_mmu: read proc/pid/maps under per-vma =
lock")
> Fixes: ea3085dd7a4e ("fs/proc/task_mmu: read proc/pid/{smaps|numa_maps} u=
nder per-vma lock")
> Fixes: 0e985559d72a ("proc/task_mmu: read proc/pid/smaps_rollup under per=
-vma lock")
> Fixes: d9d1c2d81797 ("fs/proc/task_mmu: execute PROCMAP_QUERY ioctl under=
 per-vma locks")
> Cc: stable@vger.kernel.org
> Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Overall the code looks correct bit I have a couple of questions below.

> ---
> Note that I decided it's best to defer any VMA iterator stuff to a
> follow-up - with the abstractions added it's clear what's going on and
> easier for backporting.

Ok. But once we get VMA iterator validation routine implemented, we
won't need vma_rcu_iter and its helpers, I think. Are you ok with the
fact that most of this change will have to be removed later?

> ---
> v2:
> * Took over the patch to make David's life easier :)
> * Introduced vma_rcu_iter tying the VMA iterator, mm and sampled mm seqnu=
m
>   together, and update lock_next_vma() + callers to use it.
> * Moved the sequence out of proc_maps_locking_ctx and the "must initially
>   be odd" requirement out of the header into vma_rcu_iter_init().
> * Added vma_rcu_iter_maybe_changed() and vma_rcu_iter_may_have_skipped()
>   to replace the open-coded speculation checks.
> * Converted vma_range_is_empty() to use a VMA iterator to be consistent.
> * Added Fixes: tag for d9d1c2d81797 (PROCMAP_QUERY), as per Jose.
>
> v1:
> https://lore.kernel.org/r/20261025-per_vma_maps-v1-1-c4eec45b9387@kernel.=
org
> ---
>  fs/proc/internal.h        |  1 +
>  fs/proc/task_mmu.c        | 13 +++++-----
>  include/linux/mmap_lock.h | 22 ++++++++++++++---
>  mm/mmap_lock.c            | 61 ++++++++++++++++++++++++++++++++++-------=
------
>  4 files changed, 72 insertions(+), 25 deletions(-)
>
> diff --git a/fs/proc/internal.h b/fs/proc/internal.h
> index 623bb43ede55..1d95ff577a06 100644
> --- a/fs/proc/internal.h
> +++ b/fs/proc/internal.h
> @@ -393,6 +393,7 @@ struct proc_maps_private {
>         struct inode *inode;
>         struct task_struct *task;
>         struct vma_iterator iter;
> +       struct vma_rcu_iter rvmi;
>         loff_t last_pos;
>         struct proc_maps_locking_ctx lock_ctx;
>  #ifdef CONFIG_NUMA
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 74ffa5c99b8e..22361607020d 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -165,7 +165,7 @@ static struct vm_area_struct *get_next_vma(struct pro=
c_maps_private *priv,
>                 return vma_next(&priv->iter);
>
>         unlock_ctx_vma(lock_ctx);
> -       vma =3D lock_next_vma(lock_ctx->mm, &priv->iter, last_pos);
> +       vma =3D lock_next_vma(&priv->rvmi, last_pos);
>         if (!IS_ERR_OR_NULL(vma))
>                 lock_ctx->locked_vma =3D vma;
>
> @@ -270,7 +270,7 @@ static void *m_start(struct seq_file *m, loff_t *ppos=
)
>          */
>         if (last_addr && !addr_is_sentinel(last_addr))
>                 *ppos =3D last_addr =3D priv->last_pos;
> -       vma_iter_init(&priv->iter, mm, (unsigned long)last_addr);
> +       vma_rcu_iter_init(&priv->rvmi, mm, &priv->iter, (unsigned long)la=
st_addr);
>         hold_task_mempolicy(priv);
>         /*
>          * If seq_file had to flush its collected data right after m_next=
() set
> @@ -520,6 +520,7 @@ static struct vm_area_struct *query_vma_find_by_addr(=
struct proc_maps_locking_ct
>         struct mm_struct *mm =3D lock_ctx->mm;
>         struct vm_area_struct *vma;
>         struct vma_iterator vmi;
> +       struct vma_rcu_iter rvmi;
>
>         if (lock_ctx->mmap_locked)
>                 return find_vma(mm, addr);
> @@ -527,8 +528,8 @@ static struct vm_area_struct *query_vma_find_by_addr(=
struct proc_maps_locking_ct
>         /* Unlock previously locked VMA and find the next one under RCU *=
/
>         unlock_ctx_vma(lock_ctx);
>         rcu_read_lock();
> -       vma_iter_init(&vmi, mm, addr);
> -       vma =3D lock_next_vma(mm, &vmi, addr);
> +       vma_rcu_iter_init(&rvmi, mm, &vmi, addr);
> +       vma =3D lock_next_vma(&rvmi, addr);
>         rcu_read_unlock();
>
>         if (!vma)
> @@ -1421,7 +1422,7 @@ static int show_smaps_rollup(struct seq_file *m, vo=
id *v)
>         rcu_read_lock();
>         reset_lock_ctx(lock_ctx);
>
> -       vma_iter_init(&priv->iter, mm, 0);
> +       vma_rcu_iter_init(&priv->rvmi, mm, &priv->iter, 0);
>         vma =3D proc_get_vma(m, &pos);
>         if (unlikely(!vma))
>                 goto empty_set;
> @@ -1470,7 +1471,7 @@ static int show_smaps_rollup(struct seq_file *m, vo=
id *v)
>                         reset_lock_ctx(lock_ctx);
>                         /* Resume from the last position. */
>                         pos =3D last_vma_end;
> -                       vma_iter_init(&priv->iter, mm, pos);
> +                       vma_rcu_iter_init(&priv->rvmi, mm, &priv->iter, p=
os);
>                 }
>                 vma =3D proc_get_vma(m, &pos);
>         }
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 11b3ffef3966..9ccbbcbd7aca 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -17,6 +17,13 @@ extern int rcuwait_wake_up(struct rcuwait *w);
>  #define MMAP_LOCK_INITIALIZER(name) \
>         .mmap_lock =3D __RWSEM_INITIALIZER((name).mmap_lock),
>
> +/* Tie a VMA iterator to mm write lock state at iterator initialisation.=
 */
> +struct vma_rcu_iter {
> +       struct mm_struct *mm;
> +       struct vma_iterator *vmi;
> +       unsigned int mm_wr_seq;
> +};
> +
>  DECLARE_TRACEPOINT(mmap_lock_start_locking);
>  DECLARE_TRACEPOINT(mmap_lock_acquire_returned);
>  DECLARE_TRACEPOINT(mmap_lock_released);
> @@ -509,6 +516,16 @@ static inline void vma_mark_detached(struct vm_area_=
struct *vma)
>  struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
>                                           unsigned long address);
>
> +static inline void vma_rcu_iter_init(struct vma_rcu_iter *rvmi,
> +               struct mm_struct *mm, struct vma_iterator *vmi,
> +               unsigned long addr)
> +{
> +       vma_iter_init(vmi, mm, addr);
> +       rvmi->mm =3D mm;
> +       rvmi->vmi =3D vmi;
> +       rvmi->mm_wr_seq =3D UINT_MAX; /* Start odd so changed by default.=
 */

Why not initialize mm_wr_seq correctly using
mmap_lock_speculate_try_begin(mm, &rvmi->mm_wr_seq)? That way on the
first call to lock_next_vma() you won't be resetting vmi
unnecessarily.

> +}
> +
>  /*
>   * Locks next vma pointed by the iterator. Confirms the locked vma has n=
ot
>   * been modified and will retry under mmap_lock protection if modificati=
on
> @@ -516,9 +533,8 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_s=
truct *mm,
>   * Returns either a valid locked VMA, NULL if no more VMAs or -EINTR if =
the
>   * process was interrupted.
>   */
> -struct vm_area_struct *lock_next_vma(struct mm_struct *mm,
> -                                    struct vma_iterator *iter,
> -                                    unsigned long address);
> +struct vm_area_struct *lock_next_vma(struct vma_rcu_iter *rvmi,
> +                                    unsigned long from_addr);
>
>  static inline void vma_assert_can_modify(struct vm_area_struct *vma)
>  {
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index 83b7d3ded0dc..834bbf86e004 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -13,6 +13,8 @@
>  #include <linux/trace_events.h>
>  #include <linux/local_lock.h>
>
> +#include "internal.h"
> +
>  EXPORT_TRACEPOINT_SYMBOL(mmap_lock_start_locking);
>  EXPORT_TRACEPOINT_SYMBOL(mmap_lock_acquire_returned);
>  EXPORT_TRACEPOINT_SYMBOL(mmap_lock_released);
> @@ -428,21 +430,53 @@ static struct vm_area_struct *lock_next_vma_under_m=
map_lock(struct mm_struct *mm
>         return vma;
>  }
>
> -struct vm_area_struct *lock_next_vma(struct mm_struct *mm,
> -                                    struct vma_iterator *vmi,
> +/* Is there no VMA in [start, last]? */
> +static bool vma_range_is_empty(struct mm_struct *mm, unsigned long start=
,
> +               unsigned long last)
> +{
> +       VMA_ITERATOR(vmi, mm, start);
> +
> +       return !vma_iter_load(&vmi) && vma_iter_end(&vmi) - 1 >=3D last;
> +}
> +
> +/* Might the VMA tree have been modified since last mm speculation? */
> +static bool vma_rcu_iter_maybe_changed(const struct vma_rcu_iter *rvmi)
> +{
> +       return (rvmi->mm_wr_seq & 1) || /* Odd implies write-lock. */
> +              mmap_lock_speculate_retry(rvmi->mm, rvmi->mm_wr_seq);
> +}
> +
> +/* Could the VMA iterator have skipped a VMA due to the tree changing? *=
/
> +static bool vma_rcu_iter_may_have_skipped(const struct vma_rcu_iter *rvm=
i,
> +               unsigned long from, unsigned long to)
> +{
> +       return vma_rcu_iter_maybe_changed(rvmi) &&
> +              !vma_range_is_empty(rvmi->mm, from, to);
> +}
> +
> +struct vm_area_struct *lock_next_vma(struct vma_rcu_iter *rvmi,
>                                      unsigned long from_addr)
>  {
> +       struct mm_struct *mm =3D rvmi->mm;
> +       struct vma_iterator *vmi =3D rvmi->vmi;
>         struct vm_area_struct *vma;
> -       unsigned int mm_wr_seq;
> -       bool mmap_unlocked;
>
>         RCU_LOCKDEP_WARN(!rcu_read_lock_held(), "no rcu read lock held");
>  retry:
> -       /* Start mmap_lock speculation in case we need to verify the vma =
later */
> -       mmap_unlocked =3D mmap_lock_speculate_try_begin(mm, &mm_wr_seq);
> +       /* Only trust the iterator's position if the tree cannot have cha=
nged. */
> +       if (vma_rcu_iter_maybe_changed(rvmi)) {
> +               vma_iter_set(vmi, from_addr);
> +               mmap_lock_speculate_try_begin(mm, &rvmi->mm_wr_seq);
> +       }
>         vma =3D vma_next(vmi);
> -       if (!vma)
> -               return NULL;
> +       if (!vma) {
> +               /* No reason to fallback if nothing left in range. */
> +               if (!vma_rcu_iter_may_have_skipped(rvmi, from_addr, ULONG=
_MAX))
> +                       return NULL;
> +
> +               rcu_read_unlock();
> +               goto fallback;
> +       }
>
>         vma =3D vma_start_read(mm, vma);
>         if (IS_ERR_OR_NULL(vma)) {
> @@ -471,14 +505,9 @@ struct vm_area_struct *lock_next_vma(struct mm_struc=
t *mm,
>          * installed ahead of it. Otherwise we might observe a gap that s=
hould
>          * not be there.
>          */
> -       if (from_addr < vma->vm_start) {
> -               /* Verify only if the address space might have changed si=
nce vma lookup. */
> -               if (!mmap_unlocked || mmap_lock_speculate_retry(mm, mm_wr=
_seq)) {
> -                       vma_iter_set(vmi, from_addr);
> -                       if (vma !=3D vma_next(vmi))
> -                               goto fallback_unlock;
> -               }
> -       }
> +       if (from_addr < vma->vm_start &&
> +           vma_rcu_iter_may_have_skipped(rvmi, from_addr, vma->vm_start =
- 1))
> +               goto fallback_unlock;

Before this change we fell back only if the new search yielded a
different VMA (the vma !=3D vma_next(vmi) condition) while now we
fallback unconditionally. Note that the VMA that we are rechecking is
already locked, so it can't change. Was the previous logic invalid?

>
>         return vma;
>
>
> ---
> base-commit: 33dbd62d6ff310b8cce8c70101639a6eddbb1b52
> change-id: 20261027-fix-proc-pid-maps-missing-vmas-c870d14e1ca9
>
> Cheers,
> --
> Lorenzo Stoakes (ARM) <ljs@kernel.org>
>

