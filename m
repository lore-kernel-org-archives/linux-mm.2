Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF98A606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 02:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q15zNXKK
Received: by kanga.kvack.org (Postfix)
	id 06E966B0847; Wed, 21 Oct 2026 22:23:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 046F36B0848; Wed, 21 Oct 2026 22:23:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9F6A6B0849; Wed, 21 Oct 2026 22:23:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D0BAF6B0847
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:23:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6F473A829B
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:23:50 +0000 (UTC)
X-FDA: 85348666620.30.3D3120A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id B781E20005
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:23:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q15zNXKK;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792635828;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mBLFTHurzlOVyM6uH/HHo/O74KxQ81dFv20NSPnPgsE=;
	b=N/YUyzsSzxzV0wXeRvANz3n7Lz0yL7nxuWzicZ4hsIHRSv/3Caw56wVqWptZDQWZqYOBDc
	oMH0UsL7QF+I8xfu5tE48DBexDVgdY49vdachMzmy+lDSP1HPc5TC7A1t+2zMhxEMZzWyB
	9kiTFjgj+rEEXHsDc5OkOFsEYqwAxbQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792635828;
	b=LPGZGuMGodwUZDGm/stvj969b01nVhCq5V95E49KecchCgoFy3oYlRgcuYk8UpWnszRjww
	utUmE1MfEKfYFrRJfIigGaqgmSUdyf85cb6/3z0qQxr5vDwVAjwhMLYF4aGCEYtesyR5M7
	kd84kEXtJfibg9Tl9p4AA129m6feTqs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q15zNXKK;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E6A8B43ECC;
	Thu, 22 Oct 2026 02:23:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D9D1F000C1;
	Thu, 22 Oct 2026 02:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792635827;
	bh=mBLFTHurzlOVyM6uH/HHo/O74KxQ81dFv20NSPnPgsE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Q15zNXKKzoqGf8aAZ5Pu3S3PrJGW0I6NP4zEdzaVJ3YREoUIdN7leXcVKZ9DnnQfH
	 eRk8fLDOhhNB/3DyUYR2cfpwOF0o7BKb/Z59liUY/1fdQQRa+4ptJJr5g+5J39TlI5
	 i7tKgkQcwBwdK9fike9k6Qp59yQ5qWcTVRGpLSPW0x2kdVyxkSvZl1CmvRMSiYTTmj
	 d/EDpLB3WMoJHOvJDw/UiSROEimsHsNOc+8tjCEU5UN5Z1WgtUcceEyN3xPMzoH1dU
	 q1suCFGadz+fcFEtwQYF2ZjRFYk8i1XTuZdB9E+PuKqUwgR3yI1tb8DNlPrUr1/sd0
	 6OTs6rHF7br2g==
Message-ID: <sashiko-outbox-180866@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH bpf-next 7/9] fork: Let the new task point to its mm
 before uprobes can find it
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>, bpf@vger.kernel.org
Cc: daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com, oleg@redhat.com, peterz@infradead.org, mhiramat@kernel.org, jolsa@kernel.org, akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org, surenb@google.com, david@kernel.org, vbabka@kernel.org, jannh@google.com, hughd@google.com, kees@kernel.org, mingo@redhat.com, tglx@kernel.org, x86@kernel.org, linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org, linux-perf-users@vger.kernel.org
In-Reply-To: <20261022015712.1297331-8-alexei.starovoitov@gmail.com>
References: <20261022015712.1297331-1-alexei.starovoitov@gmail.com>
 <20261022015712.1297331-8-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 02:23:45 +0000
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B781E20005
X-Stat-Signature: xs1hiud8g6wu6b1sd3ywsa1ptpbgs7hr
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792635828-105662
X-HE-Meta: U2FsdGVkX1/0qdGfLCTYEbq1zojFQIl9uI/jx71+fYQVD5L81CU7h5cxCIU0bW24y6zkHlEgK25nWysqrZG1hTf9Rh36v3T65Hd7RG1bbzFRCpVpUmGZyPp5NfZEp6eqg4Fj6azjwFnM4Pjw/SequGfbjPwpMXcy+3p5pfLQz/6IQ0x70x/RIQUA9kTraDGt62Zm5da4ae8xpl3MskATIvoF2SM+nYAM9O/byTkvOxvehb1vd0vfHF+8vS8ttom9sbwhttXy+nLyMujWWWt9eJo5fm/C716AlYWsDTUiZbFSQwd4j0z2i6TO+XWawijGqf4KpkK7IBGiAXbiGBUfz30+wbr0OwSF1oPHYYTEUB4MP73M2cnv2GabFmObmNy26ozrCU49OqnCjFgFWEEVQMn13G6mi2iYIDSJvkvRFp1qPKa2DIuue7zs1GF7Wwwlcpp6e/+8rMDxRbQkF+FJSIb7cvEJg99QqRSaZ3jNgFxU9VyZhNuqVtfEDrwCa6AhWGe2wMaED89F8R0XfF1jyAwWHX7D9KgYwHai3OFEyw/qa7jqURziLkLyds0b41s6NF//HkmDDZs0FDgIU61qlvf2Rp369WmD2XtLmKM4gsc97cZFQoNimzaWOa5qkn19QxfTH+AfOGm8NhDVdju3OpoBBgmmQePFYJLoqrEc8SNp8VoFPg3XlnfHC4My/XRFS8s9XJd/CqJk0cxRkHWq7NXjdVY+dKylN+Upk912VXuYmQ5I+oXaRGuixfCwC3jPEXkj/td0r1DDRN6oA+qF/OOObc1MBcZ/Fp6VX/lVM6K9wwCjLLsckkSxO1RJQ0UmzFPFFWA3eP+1GNY3iIsPm7BP1cGa3dXoJT1qTbcsDmB1AWf+pVsjpxFcBEnIwF4UQcTLfU+cZWoMwzX8q5Cu0Y70H+qE6AReN4iKzdWGlDu4YYRMiqlsF4osgAJx56B13gy8YK4P4iKhMJwdqch
 /WHl62HZ
 hk9csOR42CLzi5tYjm88Oe/AO3KWnkvgFrc0Iz6UCf386YmbGQwxJRBRh9UlM6OopN1U2hWDXYBw98AJOZNcu528iUWNIZHVfFkUEkY7S4ZguRT3rHK7NaCSGH2peWKiNXlXMIF3cyGvAFjslAE3CSqsW78hR5msghsOuLwgbHidden7NhtBw2w6jB8HA67T5vco/yPMkzWtHeQLOwgFe/yuDd719uXjWb2fWAlA3izk8u+hGPJJOg6VmQmlFbbNvuL+BuSKl7gmYViAleskB7ffj3kjsQnp6AwL5JQSuKKsYhNXuLDDWwaTGav9+qzEBAzVvC2p32+NgWW/6zzI+Pf81kXofNvFKnVbmoyvV0w+vbFEcat6MoKvoDNtRBR0JLdRdQajgtkUOPpngaxoPWGMGTDWJWpRMfwsaKC8hLX9JSdTK47Ivmn+WJgU+CgqQow5gNSeTQsILDtR3jBRBYCWsQo3vLzTU+ORFHQyObtZ/yrPhpo8HHyEYaiyH3beSMEFRqekoTWGP7dib8FeBIyL5vIiylQvtZcyAiTLb4ZTHu5X8WcOVfM2LnM7iZTvHIxiduzU1ErwBYgtpxGAX6LiXjzu6xDw0bc7/K/shRV/pJu/2W//Xn4MNi1vtgItToT9qNjsv9rXYJJWxTRzJRu149p5dKiyWjWDoCC0jX04wIUgCL5WVDl18P555HKDP5RU6qoqBijvtvbyIqopr+NwHiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] fork: clear p->mm under task_lock() before mmput() in bad_fork_cle=
anup_mm
--

commit ec1e952207350f8b07e6038358df3fabd0496801
Author: Alexei Starovoitov <ast@kernel.org>

fork: Let the new task point to its mm before uprobes can find it

This commit sets tsk->mm under task_lock() at the end of dup_mmap() before
uprobe_end_dup_mmap() releases dup_mmap_sem, so that uprobe filters on
inherited perf events can match the child's mm. It also clears tsk->mm under
task_lock() if dup_mm() fails after dup_mmap() succeeds.

> diff --git a/kernel/fork.c b/kernel/fork.c
> index 2e125623cdbc3..a1042e370bdb8 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1537,7 +1537,7 @@ static struct mm_struct *dup_mm(struct task_struct =
*tsk,
>  	if (!mm_init(mm, tsk))
>  		goto fail_nomem;
> =20
> -	err =3D dup_mmap(mm, oldmm);
> +	err =3D dup_mmap(tsk, mm, oldmm);
>  	if (err)
>  		goto free_pt;
> =20
> @@ -1550,6 +1550,13 @@ static struct mm_struct *dup_mm(struct task_struct=
 *tsk,
>  	return mm;
> =20
>  free_pt:
> +	/*
> +	 * dup_mmap() has set it if it succeeded. get_task_mm() must not find
> +	 * it after the mmput() below.
> +	 */
> +	task_lock(tsk);
> +	tsk->mm =3D NULL;
> +	task_unlock(tsk);
>  	/* don't put binfmt in mmput, we haven't got module yet */
>  	mm->binfmt =3D NULL;
>  	mm_init_owner(mm, NULL);

[Severity: High]
dup_mm() clears tsk->mm under task_lock(tsk) before calling mmput(mm) so
that get_task_mm() cannot find a freed mm when dup_mm() fails. However,
what happens if copy_process() fails after copy_mm() has already succeeded?

In kernel/fork.c:copy_process(), perf_event_init_task() runs before
copy_mm() and links inherited perf events (with event->hw.target =3D p) onto
parent_event->child_list and uprobe filter->perf_events:

kernel/fork.c:copy_process() {
	...
	retval =3D perf_event_init_task(p, clone_flags);
	if (retval)
		goto bad_fork_sched_cancel_fork;
	...
	retval =3D copy_mm(clone_flags, p);
	if (retval)
		goto bad_fork_cleanup_signal;

If a later step in copy_process() fails (for example, copy_namespaces(),
copy_io(), copy_thread(), alloc_pid(), cgroup_can_fork(), or
fatal_signal_pending(current) after waiting in dup_userfaultfd_complete()),
execution jumps to bad_fork_cleanup_mm:

bad_fork_cleanup_mm:
	sched_cache_fork_cleanup(p);
	if (p->mm) {
		mm_clear_owner(p->mm, p);
		mmput(p->mm);
	}
	...
bad_fork_cleanup_security:
	security_task_free(p);
bad_fork_cleanup_audit:
	audit_free(p);
bad_fork_cleanup_perf:
	perf_event_free_task(p);

Here mmput(p->mm) drops the reference and frees the mm, but p->mm is left
non-null while teardown continues through exit_fs(p), exit_files(p), and
security_task_free(p) before perf_event_free_task(p) detaches the inherited
events.

During this window, can a concurrent caller of get_task_mm(p) (such as
perf_event_set_addr_filter() -> perf_event_for_each_child() ->
perf_event_addr_filters_apply() in kernel/events/core.c) or bpf helpers like
bpf_find_vma() and bpf_iter_task_vma_new() in kernel/bpf/task_iter.c (for
instance from security_task_free(p)) observe the non-null p->mm under
task_lock(p) and call mmget() on the already-freed mm_struct?

Similarly, when perf_event_free_task(p) -> uprobe_perf_close() runs (or a
concurrent uprobe_perf_filter() runs), trace_uprobe_filter_remove() and
__uprobe_perf_filter() in kernel/trace/trace_uprobe.c read
event->hw.target->mm and compare that dangling pointer against active
mm_structs.

Should bad_fork_cleanup_mm in copy_process() also clear p->mm under
task_lock(p) before calling mmput()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022015712.1297=
331-1-alexei.starovoitov@gmail.com?part=3D7

