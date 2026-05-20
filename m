Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92E6BCD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 19:47:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE7496B008A; Wed, 20 May 2026 15:47:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBE956B008C; Wed, 20 May 2026 15:47:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFB876B0092; Wed, 20 May 2026 15:47:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B08106B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:47:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 65BDD140427
	for <linux-mm@kvack.org>; Wed, 20 May 2026 19:47:57 +0000 (UTC)
X-FDA: 84788833794.25.B48FEA2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7163A4000B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 19:47:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="X2/cIQCK";
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779306475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8BS1/UVzCCKd7EPMf6fEBTk+l7kXcCicsWBViDYGQxA=;
	b=O51U282QhmdVQul743X8GS1Jxuv1ZhnybMAozHEnr3XUzJwdmb+9CT9LihjrUwCJ0jyls8
	Fo4sYTxQ2pJg718CSoSMejNLfmfqHvg5jTRcxUfKmXzpLrKqOODN1DvbMoPpJrlkaLJxXS
	2pGhf6NPcLXbiL7j/zChEUza0koYri4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779306475; a=rsa-sha256;
	cv=none;
	b=a/q+1YY8H+G63SZnA1k5PXkII39n5SGg4jTifgbd8uC6HzMTWCtc1IXGMsaggmcA5WjkSk
	K/6XieoTTTJA3AO/GUXeMlCLuVDveg4VOr1plE7mRE6kxL+MLA08YatlW1RODwyABkAm6W
	mMbaLv3bLY4GI0whnKUAp7uKYTIIrR4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="X2/cIQCK";
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9409544389;
	Wed, 20 May 2026 19:47:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC7E1F000E9;
	Wed, 20 May 2026 19:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779306474;
	bh=8BS1/UVzCCKd7EPMf6fEBTk+l7kXcCicsWBViDYGQxA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=X2/cIQCKg55P7nv6XwRJMznEpu4INfkt09dIPXawZvDWeYbJSqbymAKyda/NT9Pat
	 7DiB4Pf2sWss6+j5fvnSxw0c1oDsi8NvqqBKUkdzv/z4mp4RZ7ogblFKZITKL6CX/R
	 Q99MU4XflfH3h1ETvtjIOxIzJ6YKF1MQ6MZWHfClUxmLDg5+cfe8K3IZi0zDg1Fmve
	 tJvKhXee4flZ8BFx26fjxOczWQDHweVPDiCDadAZBYIi5FkpbmH4upAp0a0glSaPdA
	 0O9Rj9ut/k0Q6D39w4N29rJYWuFJCJZlsMERM5tn7Hof+V6oBHkiZD0KjVPvaaCEDs
	 s3jGoSKkCoQfw==
Date: Wed, 20 May 2026 21:47:48 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, 
	Oleg Nesterov <oleg@redhat.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Qualys Security Advisory <qsa@qualys.com>, 
	Kees Cook <kees@kernel.org>, Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, 
	Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH RFC v2 4/5] exec_state: relocate dumpable information
Message-ID: <20260520-hypnose-porzellan-a916c10cb548@brauner>
References: <20260520-work-task_exec_state-v2-0-9ea88ceb09e6@kernel.org>
 <20260520-work-task_exec_state-v2-4-9ea88ceb09e6@kernel.org>
 <CAG48ez3QGgSuAfXxF9C9qH-PoUDwBEJ8adTRHw10cs0tqdp8Pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez3QGgSuAfXxF9C9qH-PoUDwBEJ8adTRHw10cs0tqdp8Pg@mail.gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7163A4000B
X-Rspam-User: 
X-Stat-Signature: mgyx7cpkjgnx4kgnuop8pdzd7dajbzj9
X-HE-Tag: 1779306475-903954
X-HE-Meta: U2FsdGVkX18kJBiVRXAPyseS3hm/DJXQXhkXUbN5zQjPK3tunPUYPfMDu7cfw3p1ZmT4TBbSvCPbml8XlRRJa7DdLgYCBnVVjX/mSXDppXKYSNIFoaC/tAElmoo7Wxp2oTES8BSFT7mlr4th3lcAvSz/WXhub3726lQkHwOL6VLpzgK6Jn/QyEAQ1v6GfKJbqGr/NOWvD4J+mEg/MZep3Fk8jSO+j5N37I3dECegHEqzRY1/AVCZ4zQ4SfowJal3V1NJujMl95mrJqMu5IA2aKkPDtpGX4BPg3CvfmWK258b8hlTsMdMDKTQ9k5Rk/GecmN4QDiitXUssd3LeUgKt5fitSreQn5s108nl3iWUSFw0BtmUZ/S5BcxLaKqoF0G5UPy1BwgCjmLcnPFx4Xqg0A8T0bWibhtvjnMtIEEJetz70tk06utkvtUQQiXtWA3JdB44+t1ErrSb4bm3hMpHR4BklZjlDufYm+4ATenQZnOJBldZBA/yM0VMdz3i4ZcBOn9uaOoWGAtUsp5aBA34JBriTbnh2tIfrbLO2M5+31zDrxsqsOt4mAHRBnECsqHxxrlDLY1ZH5gDwB06Yyf3fkHMVoXR0cTsiGVcgXzyXEfwZRQwnRWF7er2pNTiYtbku7fd5vaL6MIyWYldxNsnLObMEYN+xgp4QgCLmE4L3hlbnFKtmcpEuYc9ffYhS6yToKS093H2Ke+WxJYhXCbjV/iVpMbAeleGFAGjumSpY6IQss032fIzgI6TFTu7F7KU/9rLMnLDCoZv0vBs09LwjZzrsF3jKtlLi0ta/vaStRLHafHThmHnSB4Jz89t1ZjgwvC/KeJxzjtUFz6You4RTWD/eVbBdxEzAmfgoAFLUcKvfbgdS77IhuKYpSpKGlEzx1mZ9lst9YDYR3nU+FGEUqQ1HTFLNLhTuDWB9mC6yYnILzulbTc3PnHPmZxCV7v05Luxt+WmRSTnY6VwOn
 pQaJW8Dc
 SHd5KwSAHqwzvtEvDvbCVjGUokr8yXaB+8NizTM+Dgwe0+DCNo8947NSQ93m6p43Qk+/Ak1oVZf5OQvZQLu+ljWbOR9mqSCoat3aWtkMt4qfX8ePbPnvPe2AEDkukGyx3gyKpg2UEHPIgvoMEd5+UgWZLHsE5yqTZ9dy8ndmz8wDdtU+tQKz0G7DuBP6znKvgDHqEluKsXl5LAxmoBMV139hWgkWRVx+82H1pJGZrNiS16kBYpJJ8O+uHDOyqkmRFeZy06M5MFfTYJLRzsdMCNp59+L2lgI/UJaWMJN8M6AFUCOsVeQLOcS8bmTur14v+BEnatBE9f7VoiEiCrZDIhpfHFva6Nb5S2l9kS2wA8Xxx2fxbSKFuCCExu5KqfHQyK/HF2hiJ6yT7ygCukAo8l58pyLlIDGEcDlSEgjxrM7HHAGbD7bP0eDvAsN+MOYk+pf5R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 09:21:19PM +0200, Jann Horn wrote:
> On Wed, May 20, 2026 at 4:43 PM Christian Brauner <brauner@kernel.org> wrote:
> > The dumpable flag captured at execve() is consulted by
> > __ptrace_may_access() and several /proc owner / visibility checks.
> > It lives on mm_struct today, which exit_mm() clears from the task
> > long before the task itself is reaped.
> >
> > exec_state is anchored to the execve() that established the current
> > privilege domain. Every clone() variant refcount-shares the parent's
> > exec_state via copy_exec_state(); only execve() allocates a fresh
> > instance (via alloc_task_exec_state() in begin_new_exec()) and
> > installs it under task_lock + exec_update_lock with
> > task_exec_state_replace(). init_task uses a static instance.
> >
> > The dumpable mode now lives on task->exec_state->dumpable.
> > task->mm->flags no longer carries dumpability; MMF_DUMPABLE_MASK is
> > removed, but MMF_DUMPABLE_BITS is reserved so MMF_DUMP_FILTER_* bit
> > positions remain stable for the /proc/<pid>/coredump_filter ABI. The
> > task->user_dumpable cache bit and its assignment in exit_mm() are
> > removed; readers go through get_dumpable(task) directly.
> >
> > coredump_params gains a snapshot field cprm.dumpable, populated from
> > get_dumpable(current) at vfs_coredump() entry, replacing the previous
> > __get_dumpable(cprm->mm_flags) consumers in fs/coredump.c and
> > fs/pidfs.c.
> >
> > The user namespace recorded at execve() is consulted by
> > __ptrace_may_access() and by /proc/PID/* owner derivation. Move the
> > captured user_ns onto task_exec_state, which stays attached to the task
> > past exit_mm() and across exit_files().
> >
> > bprm grows a user_ns field staged in bprm_mm_init() with the caller's
> > user_ns, narrowed by would_dump() to the closest privileged ancestor,
> > and consumed by exec_mmap() via alloc_task_exec_state(bprm->user_ns).
> > free_bprm() releases the staging reference.
> >
> > mm_struct loses ->user_ns entirely.  Initializers in init-mm, efi_mm,
> > and the implicit one in mm_init()/dup_mm()/mm_alloc() are removed;
> > __mmdrop() drops the matching put_user_ns(). The kthread_use_mm()
> > WARN_ON_ONCE(!mm->user_ns) is no longer meaningful and goes too.
> >
> > Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> 
> Except for the discussion on the cover letter about whether to unshare
> on fork():
> 
> Reviewed-by: Jann Horn <jannh@google.com>
> 
> > @@ -434,13 +434,9 @@ static long pidfd_info(struct file *file, unsigned int cmd, unsigned long arg)
> >
> >         if ((mask & PIDFD_INFO_COREDUMP) && !kinfo.coredump_mask) {
> >                 guard(task_lock)(task);
> 
> nit: this can become guard(rcu)() now?

Yes.

