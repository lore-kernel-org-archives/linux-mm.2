Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A81CFC982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 06:02:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A08B46B00A7; Tue, 22 Sep 2026 02:02:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E17A6B00A9; Tue, 22 Sep 2026 02:02:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F6766B00AA; Tue, 22 Sep 2026 02:02:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6D91D6B00A7
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:02:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 10C93C03B7
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:02:30 +0000 (UTC)
X-FDA: 85240353660.17.5E2DFAE
Received: from mail-lr2-f35.google.com (mail-lr2-f35.google.com [74.125.230.99])
	by imf10.hostedemail.com (Postfix) with ESMTP id 185B9C0003
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:02:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of clx814727823@gmail.com designates 74.125.230.99 as permitted sender) smtp.mailfrom=clx814727823@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=black-desk.cn (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790056948;
	b=omMkVSZKBPd9mshJSU7epZutlfySwvnDkEbLJIgZKNPQb+qGzPlyJXn2pK6qjBDpNC+tlk
	oQjtWPDzN0+CN/pOOKXCyBBJSC0kCmAIT4NMjekO6LLoA3eeG29FLP9aHUpX0yA7ll2grq
	2qhQgrjzPHQWs9rMH4CFF36L0NNdA5w=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of clx814727823@gmail.com designates 74.125.230.99 as permitted sender) smtp.mailfrom=clx814727823@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=black-desk.cn (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790056948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=51dqkeK+6HTCaJdD0DRXH94PwuZHWhVc5MOITOLNdLE=;
	b=GdlVX4YOY8OzDfF5QpimHjaLzJ3VfGEEvvgEL6TohlRzEqTFmU2hLOPWPEOG8Pq60ei03X
	+3NYxKkIKmyRKiLGw69mxYOkscCswUb68RiHW2h77MfR+KszBkWccrnpaLHX2xTcRZRXUX
	SspmXpgr3pcLbtB5ylEJ8dPJPjfUZ8s=
Received: by mail-lr2-f35.google.com with SMTP id 38308e7fff4ca-3a6287d59b2so1733261fa.2
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 23:02:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790056946; x=1790661746;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=51dqkeK+6HTCaJdD0DRXH94PwuZHWhVc5MOITOLNdLE=;
        b=FiF/qZDoFxScGckPEYu2WxV5EP8/c9WNvvKV7u4twsYcm8vGWWe4U5b8jQ0GqeyA/4
         szhunbUKn7q3itaUbbgy4QP+kNSyFtV++EXIm4VEWXjI7lXiiQrDQl1IP3IKVRsgcO3e
         mc0IWEeQo3aAcRjgoGsMhqRqm9FiWbOcQTj7M/Dua2ueG561TuSHeJoSjlwGFRtwIi86
         HhHd78YhgujKrxQVvddrD+q02ywbV3cnyNJS8RcHM0Ev0tNU269JOpNF2/ieas0oQtQS
         TxLjoMTWbYwzg0czaS32pMELhYqIO9MGHO9F8FlH3Kg4hGhUSgDNAVvZcWOhOMixic0L
         Wzjw==
X-Forwarded-Encrypted: i=1; AKwUvByUPUs4+Svh7+GUN01vOgb9hfUgW9Zpoyr9VzNhEyX/olQBN77bSG3/tQMI8pZIlPonGj54/8WOLw==@kvack.org
X-Gm-Message-State: AFuF++kRpAiY3J12yxuoAFg70nCCwsDf+vFYLlsP5dtDFFUr/kUJNqPP
	tb3ycPvLVBwwfcPYG/n1NdGDmLkB9Lpp/dz9SOtexKDj1GIGSsXyiXp9HPIQ+oVZTW8=
X-Gm-Gg: AYBFou3sqY1FkxLzNi/hWr8tSqwnAH18a1ZYkA14eSDgxsxM1UUJZrvaTIMPFL72R9B
	V9sMpbtJVvnpycK8WoaDjJOmxBJ8QBh/6MMz8kVjjoOoaEMElsIOdDWeRcOTfXj+jMMihpFPc2C
	gDbf0q/waA7BzFT+0+0yZrmNeLKZ9fLcGZJL/Gfosdt4Fjrd59dLInRf2vG1SyluvDM+ikXGE2H
	GYNZDYu+SS4phlsSaCtk2M/Y10SWIDi758i2OJHo9lsLqqs58K0TqW9UvVPt0M+GbHs/UO3Om67
	8CwetyfVMdYdmrg6ldbD91xUahAxhxyy8QwWo/yh4aLyamGpkj8VVDjp5kpFy6iZOqPog1mLQxu
	X9MCtB1H+muqcdyFE5qrIiQiEMU98ekb/GYfQ1N+bgtLtuWI8n1IxK9FbPWOmdA0cqsUGV3iy69
	AkQ9czGd1anZMg0Zn3V1NgVgv0rMurZ3ELgxnWLcC2/jjH25DJwHwJUOWwAT0D3Wjo97218ZunN
	QBoVKOesARFDy/KbRa5Gp6Jwws0tzHPQD9R1pw4VdU=
X-Received: by 2002:a05:651c:31d4:b0:3a4:8913:a259 with SMTP id 38308e7fff4ca-3a5fc077d21mr30287341fa.29.1790056946176;
        Mon, 21 Sep 2026 23:02:26 -0700 (PDT)
Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com. [74.125.229.205])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a627d6f5fesm2454681fa.26.2026.09.21.23.02.26
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2026 23:02:26 -0700 (PDT)
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5b899413537so5681494e87.1
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 23:02:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzFb9ejfIEt7QcA/BS/z88ba3hKS/DqJvwrMA5EjnotSBTf0FH/yIgXXZ+5ZOnOjhOvsbQoCwjp/A==@kvack.org
X-Received: by 2002:a05:6512:110a:b0:5b8:99a5:5162 with SMTP id
 2adb3069b0e04-5b8c180e6cfmr3759117e87.26.1790056945794; Mon, 21 Sep 2026
 23:02:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260831-pidfd-get-paths-v2-0-c59ea6a21b72@black-desk.cn>
 <20260831-tauwetter-werkbank-dramen-b37eb4025283@brauner> <CAC1kPDMK_D4nhyRmBHg6KC7SmmCkH73Xtc5DhXeJbSvf3LcqcQ@mail.gmail.com>
 <CAG48ez1T5-tUHVK_iHsgUtWa-inVdrZxA3E-ZCW0iENJvasKfg@mail.gmail.com>
In-Reply-To: <CAG48ez1T5-tUHVK_iHsgUtWa-inVdrZxA3E-ZCW0iENJvasKfg@mail.gmail.com>
From: Chen Linxuan <me@black-desk.cn>
Date: Tue, 22 Sep 2026 14:02:14 +0800
X-Gmail-Original-Message-ID: <CAC1kPDNamG4BpfsX0mn9E-Y+ujGTLe-oU63kJFOjxW6bDmSLnQ@mail.gmail.com>
X-Gm-Features: AclHuK8ITwQn4waky8resdLcCFExt5UoOF-9n53imPe55RkN7kQMS7sWnKkQWLA
Message-ID: <CAC1kPDNamG4BpfsX0mn9E-Y+ujGTLe-oU63kJFOjxW6bDmSLnQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] pidfd: add task path ioctls
To: Jann Horn <jannh@google.com>
Cc: Chen Linxuan <me@black-desk.cn>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Kees Cook <kees@kernel.org>, John Johansen <john.johansen@canonical.com>, 
	Georgia Garcia <georgia.garcia@canonical.com>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 185B9C0003
X-Stat-Signature: 4cffbk5to3kzt1g6xwmpsjabrebdxrp4
X-HE-Tag: 1790056947-24212
X-HE-Meta: U2FsdGVkX1+ArhiKzXBVgfInPq/gbUsZwlI7TV97nfOQE8HdQcVlOEAg+fHFmn2Ke8eNArMRLqQZxxudSBUpBK++e920rXKJRAJzAAYhM4Z2uBv5yUDAB+zmJwOLx8zoXNVnGB9GcSHJWB7eu0NQL+GFxNDX4G0TYrrICVdGmLxF+68My18CxTEur6+yoRnaADip910RNRUFB2l9FtQz5c6hTh7tY7VHrtq6qOWuOXwL8Oc7tKInxrw+jvi9q4LY7B/DNAyhegVs66lqzwaL9hj6ghSMDqEzJwTQfzCUP4tsSalEnHPpRn+7keXyP8Ws6VmP0+VS49RmHcMHCza7sSWxd5ujIisoJdfTYlndsCO/ZMvxUhsPTukI9J39wNKE4kmF/v0Qs3p4DltwlAdtgs3Nq5jUMZdaBBU0wexhv1uQaVlIko/2Ni5iWRAElzptHtc/kusgF8Z7q9mGv0nhDxliixVw2dNVfZzMQjwBbm4GWAzc4JS++RRQiUXdwHk5w3Rb6s6Xb4ioE0mz1iXZmozopFC1lWs450R9hmm253TUC7nzFP+phpH27+CZVaoozxmSaICX+6QUgnqf+fszlYj+kfEA9yb66k2ezHVOM/A/fo5QnyzW/X/8zvqOJM8HGeawEWaVAeMKgDHFdEakpMiI0fatQ6M5jJDtB9J+Yr6nOR/WEo6qs1VZf8QV2Z6GTXKCKjUMWZjV5kHV/unHgn7BLRVL81rBMBHIOCHFPyqveo3/cB9VmCut5eqy4l4vDjgPa+qBeqKGRBKJr2EtoYmaaotk4MZeektSTi7ndCpMViOpLFDMJyuNyXTa3mohN+8avqHAyZVSsDktiu0xY9RPpvEms96Kbnyx0Snm96TqIkMhDf0dvCfoe5FrZ3LQFwjjfFPkLdYdQeuHA2Gmjk3nInJK8oe91cO7MzF4xeQFxJoVKfixrG2WeDKLBPHZv8AAMeBB/1nOdGhfToK
 TS99z42Q
 Y2tMSqhi/YR+tFvoTMtCEBCWKwElmbXzTDYjKWOk0eAdV2iwVC9G2ojNKoNbjbngUDbqVp3YVgqNLQrQO3mloXuV908jCL6mUd2MeHzKwqTd1ucaUzY5KYJne6LDvYhfTeKX9E8ehSaC04M3MdsffZXXw5R9NgCEncryPG6F85gWvDxN3AetoRsLWrlW9x3pdgQ1jVVNI0EpKb9w7FgumSYk/fDEh/N9Jr2DoU0CWc+k8iKm6yNBpoRNgcpE3wKgxTFCTObtrvG3Uw5Rn1dS0anPUNfG8jm2M337u4HNryFXJH+tQVCRnEWTEtCfZGNlU5utEKS/QUBxjM5B3PXavMqaeRpKGvumWue/jT/pP/K97tgKqFnXy0sXOV5weGvKbMy9NcvNi+dUytM6/RHxir9Mag92kCzU30H7HaUnm7jJ7S28JgopBYbPQbpxzDIgKs0FAVxunP2Jxn+nfOChtjb+3ph5yYYJS+KviuFnmN0808Ow=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 4:22=E2=80=AFAM Jann Horn <jannh@google.com> wrote:
>
> On Wed, Sep 2, 2026 at 8:47=E2=80=AFAM Chen Linxuan <me@black-desk.cn> wr=
ote:
> > On Mon, Aug 31, 2026 at 4:49=E2=80=AFPM Christian Brauner <brauner@kern=
el.org> wrote:
> > > On 2026-08-31 10:59 +0800, Chen Linxuan wrote:
> > > > Obtaining a target task's executable, working directory, or root
> > > > currently requires walking procfs symlinks such as /proc/<pid>/exe,
> > > > /proc/<pid>/cwd, and /proc/<pid>/root.  That makes the operation de=
pend
> > > > on procfs being mounted and visible to the caller, even when it alr=
eady
> > > > holds a pidfd for the target.
> > > >
> > > > This series adds PIDFD_GET_EXE, PIDFD_GET_CWD, and PIDFD_GET_ROOT. =
Each
> > > > ioctl takes no argument and returns a close-on-exec O_PATH file
> > > > descriptor referencing the corresponding task path.  The new ioctls=
 use
> > > > the same ptrace permission check and nonzero-argument rejection as =
the
> > > > existing pidfd namespace ioctls.
> > > >
> > > > The target task is sampled while holding its exec_update_lock. This
> > > > keeps the access decision and the task-state read in the same exec
> > > > critical section, preventing a concurrent execve() from changing th=
e
> > > > credentials or target state between the check and the use.
> > > >
> > > > The first patch factors out helpers for acquiring referenced task p=
aths
> > > > and reuses them in procfs and AppArmor.  The second patch introduce=
s
> > > > scoped cleanup for privileged pidfd task access and separates names=
pace
> > > > lookup from namespace fd creation.  The final patch uses these piec=
es to
> > > > implement the three new ioctls.
> > > >
> > > > Signed-off-by: Chen Linxuan <me@black-desk.cn>
> > > > ---
> > >
> > > I really have difficulties forming an opinion on this. So this sounds
> > > very useful but it has implications.
> > >
> > > Right now, pidfd ioctls are available even in situations where the ta=
sk
> > > in question would not be accessible via procfs, e.g., when procfs is
> > > mounted with "hidepid" options or similar. So this would expand the
> >
> > One point regarding hidepid: for callers that can pass
> > PTRACE_MODE_READ_FSCREDS, hidepid does not provide an additional
> > restriction. With hidepid=3D1 or hidepid=3D2, has_pid_permissions() fal=
ls
> > back to ptrace_may_access(..., PTRACE_MODE_READ_FSCREDS), and
> > hidepid=3Dptraceable uses that check directly. In addition, the
> > /proc/<pid>/{exe,cwd,root} links independently perform the same
> > PTRACE_MODE_READ_FSCREDS check in call_proc_get_link(), regardless of
> > the hidepid mode.
> >
> > So for these specific path lookups, hidepid does not block a caller who
> > would already pass the check used by the proposed pidfd ioctls.
>
> Agreed, I think with regards to hidepid there should be no issue here.
>
> If I try to come up with scenarios in which this could introduce
> additional danger, the main one I can think of would be: A task T1 is
> running inside a pid namespace and has a unix domain socket connection
> to a task T2 outside the namespace, with both running as the same
> EUID; T1 sets SO_PASSPIDFD on its socket to obtain a pidfd pointing to

Does SO_PEERPIDFD matter too?

> T2 on the next message sent by T2, then T1 uses that to get access to
> the mount namespace of T2.
>
> Christian, is there some mechanism that already protects against using
> something like SO_PASSPIDFD to get a pidfd to a process in a parent
> namespace?
> Otherwise, should we add something like a "pid_vnr(pid) !=3D 0" check
> either in these new operations or in SO_PASSPIDFD?
>

