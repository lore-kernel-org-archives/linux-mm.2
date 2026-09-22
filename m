Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 282D4C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 15:55:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44DCE6B0093; Tue, 22 Sep 2026 11:55:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4257F6B0098; Tue, 22 Sep 2026 11:55:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 314456B009B; Tue, 22 Sep 2026 11:55:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 03AD66B0093
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:55:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 83D0B1A052B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:55:22 +0000 (UTC)
X-FDA: 85241847684.03.2115A54
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 980481A0004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:55:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DjnjMtgT;
	spf=pass (imf19.hostedemail.com: domain of jannh@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790092520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3CnAMf3rYfISbFoQbxUQPDoCBSAVsRITBKeQGlh3KBk=;
	b=dIdXEK4zH/aGf9920GXGhMse++kdcPBYPiy1UQwiTysh4MgJhCYgXif987wr/847aXih82
	zNTuDZwXgGdHqkrbHutJ4BNzsqA1qD68A71oa0ghFRlWNNkSuLuIa7m1Fn7wII7de912i/
	Mg/6uLE7fycRSrOvDI2fGTu9uYA28ow=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DjnjMtgT;
	spf=pass (imf19.hostedemail.com: domain of jannh@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790092520;
	b=mwX6vbZ0cqZZJCC6277Xm6r6U4lZQFE+RVaTM9+r6tAH44wdH2SSq8SqhB5yLoXzdWmbaX
	3FioNkjSyVx+hqsTAvGObv2txYBSWheCDC6cCCDN8+qJEzesRZXZf3d4u8cXJVNCk2VM0B
	1HLqhxTj9jGifKGSY2sGHk6DqP2fmlY=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2db33db4de9so134885ad.0
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:55:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790092519; cv=none;
        d=google.com; s=arc-20260327;
        b=EI4g5mehG8OBW2cO8X+VQyYezjfj2LDTDeexAqBZL35pmGJCG52Osv8DYqkJ7YLa5Y
         on8pBKfY9CcK2oao+SsS5caiegN23Caa+z0UjfvNADPKOUEzOM3R9Z2uV/oY9qDEdoS8
         3kqw6FCToT+iCDnOjtRXY3ax3u9HkbdhNNjXGVlZJ82ZSNae+yFb6U8KfpOujCtJD8QJ
         63Ig2nC3Zr6nt8ypL7sJ0RcHfTTnxEVasXvc9zAerAoNvHXOkUeGt3a20osR+q6xrsdF
         ZUk2b4ehFlJ/k6k9f2eZI1coGq8c3QC+IGRYUp4v5RdHiYCfARiFQtNshYXyrFIsKcge
         99SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3CnAMf3rYfISbFoQbxUQPDoCBSAVsRITBKeQGlh3KBk=;
        fh=J2fyv+yOc52IK7nI2QCtnK11K3JyOJbHnLZ1u3i9Yj8=;
        b=IPK3t8SYW66RUz771N9e7uFQJroEUG9Rm8G/f3SXDqbGa18ICtQb5O3Qkd6K2+QpD+
         pGzB8J1zOE9NUGsev4tcgiKcfruMhOH6pZCbTAc0msvew2IwWJfBxOrMIYtYjKetAo0b
         oDP+LNXUH+sKCZm2xHgzYMYisCBciKaRMR0FfBCo6rKRws3Qr/9m3ox6Pp1NFA9Ktsgw
         RRoO9VKjbmOCSuYXNa7Nvxj77aHKXFiLL1k9R3D7pH4uFSKkU9YWYv46bTydfnEjPUAp
         AXb6XDuQZLnAZkgIqQG2ymRvfZ5iVjEiPzjnqc/D3GB8PVmyAl8ldgzSdHV9/ZkG6cOq
         mAnw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790092519; x=1790697319; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3CnAMf3rYfISbFoQbxUQPDoCBSAVsRITBKeQGlh3KBk=;
        b=DjnjMtgT/B5zNkjAu0clxwixHPh7bMyvvy9MeM0dTdqbJN3g5++naKM7QB3gEQ1odH
         Cz9SNS31x2NQl1cVfhDDLCGwUwDKNovfR61yy4mYQn8CPYQX7qPtwbHEYuRJv4WowwVs
         bBDamS8fdUyYazSxhuVK6Qlg/xR+hDOFHqk/VM/LDZl1i8MBrBCFQmkFlmL4cKyab8ca
         HkHgJNfTR0rdiDXCCDhlJ5UrdFMAZ1c+d/Q+XOhVCTfsxolPTvJXUvB8ek/5gxBP5DC7
         cbbkyE7LrWTVlhvf4AS4raaD4z9mxluah/CMrMYhbFk0DHmeulferfdG1LI9jFtx40lB
         mH2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790092519; x=1790697319;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3CnAMf3rYfISbFoQbxUQPDoCBSAVsRITBKeQGlh3KBk=;
        b=n/qg5RESUFIV7kCyq8T5HPDdU8BTysTVTZ78a191I4u0QlBHZhhgID1xv9TiSJYdat
         KksFaO6gXOqwWR+fyPUr8InINN5iUcS+OlWqwHvCyW4dk6r8i7KPnlo4TbN+HfPoCv7b
         iOPD0urRDJVh7AOlxtKoW2HfS1F7LGLvb0T9x7bjn3SlgNOaoF8XKABF0CXYqMLWbeAI
         co1hnE6tTNyyxunG+mF4St6v2VsTi0CG3xA/tZg28l7ue9JAGdb3h1jv5sGhWcrjfRne
         BICkojIx9bFFOYdVpfaOTXoimnRSAcCxwFe6BM3OjYbGJ4UY3AhP/pS7soeU/T7zbwTL
         qjSw==
X-Forwarded-Encrypted: i=1; AKwUvBzWpjE/l7/gcCZYzWMJAiakIfU6HoAv0BYEgJjkY8YzpSLffxnVSDl/YQbauDOSjXmJf0KzA9NQSw==@kvack.org
X-Gm-Message-State: AFuF++nD6nMbv4urcMq7DAXUekngHXpU/7yy/stdvSGwKz27v09WW5oi
	CiPZSlGXrKsB5R6jZxmOeziSzAtdUAvi84C/C7KVO8KZX59pf7wt3ho7qAbwJX5ZubRBtDeZeUb
	50cqxJ7qjWSsq/QG5tskzeKigJhNdzI+4pPMVkaZN
X-Gm-Gg: AYBFou12T+XyQwmE2J67nx0fcyeAcyryx3tAixWsBvTZhvdQrlcFflTC00cvWsyx9Z1
	SZF7K8bfwY50pEbe2/XW4Ifqr8UpRmGIjZmwKF22uhqUprm7uh6cmwOfWO7HRGDB0FYEbLTqcxo
	HY2MIuaMHcGemRNEHtClHFG+SKvg8nexzK9LYKQOdNorRjftyr/c2UCsDe7yU06E/vXEmDCwtGf
	BKSfVVt0RACHENm+5zkEwxivTmJjoY8CP9N9S3EFP1YzvQMxQnnmPr8CQlbVVKJZ/zaRosEilbX
	4yaLql/rIBNhGbptaJ1L1ry/iLCM+nKPRAUEnFHNiRsttee7fvwDJV5J7k4iwpQxGVtmb4UA96o
	UKD44LhBDFyZSrDE9RRMXCD3IaQ4HzYeR4nWyHyBUdg==
X-Received: by 2002:a17:902:fda3:b0:2dd:b837:48b8 with SMTP id
 d9443c01a7336-2df6649017bmr1392335ad.14.1790092518734; Tue, 22 Sep 2026
 08:55:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260831-pidfd-get-paths-v2-0-c59ea6a21b72@black-desk.cn>
 <20260831-tauwetter-werkbank-dramen-b37eb4025283@brauner> <CAC1kPDMK_D4nhyRmBHg6KC7SmmCkH73Xtc5DhXeJbSvf3LcqcQ@mail.gmail.com>
 <CAG48ez1T5-tUHVK_iHsgUtWa-inVdrZxA3E-ZCW0iENJvasKfg@mail.gmail.com> <CAC1kPDNamG4BpfsX0mn9E-Y+ujGTLe-oU63kJFOjxW6bDmSLnQ@mail.gmail.com>
In-Reply-To: <CAC1kPDNamG4BpfsX0mn9E-Y+ujGTLe-oU63kJFOjxW6bDmSLnQ@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 22 Sep 2026 17:54:41 +0200
X-Gm-Features: AcwNN1Uevf7qvaoQ92TUBe1sUrMlhIbUuw3ph8s-vQAhL_GIcCXy5aT7MdRHJGg
Message-ID: <CAG48ez0+kYEdLm305xY7HsXgfXxeqFGYQB3N4UY7ppoyQ4t=9w@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] pidfd: add task path ioctls
To: Chen Linxuan <me@black-desk.cn>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 980481A0004
X-Rspam-User: 
X-Stat-Signature: kf8wrc6ba1iaxqbqdf95nscfsc96muz8
X-HE-Tag: 1790092520-108897
X-HE-Meta: U2FsdGVkX1/w9Z0JUYbphUKgPTFmYAGO66IHab2nPAqQXR5lKK5/2raYACmoszUc2+MOdkUHQNZHuK2nM+TNH4eojQkW20sMSN8JKgMkE7RC/9CfbEYLoLT/SqTSiy/dMwhNoy74dt1ll7WyWj+8/VBxSjAH3Z+FGD/SvcfxVjocWXcTtyS+M7Mm30ZiTGAiRuLi+RXdZFRIru4nxBHVUWFZKB1a/pl5C30CdcOReCpLeDi8kx+aixEffIiaOj3jH/koaoZbkkT6ogeNE2+AH3QlDu7Ey3bF43Q+nR8bJ57Fn8XiCtLHJRXH35vUZ3yzI3Lkvngdo4F6Ry3l5MaZCtJZrO8kp4xRJft9exz2YNtEUa7E7xzmPgXZYgtSMFzH2jNisLanjpVWsbuBRtpPlOZlAWfA48nIlYuyKBDqZkOD7lwb3idvBvAzoLpU+jyg4a00Wro1bATQOctKgvdUMflNiOJx1k3rON4vlHcH6TD/QjWwiSCXltTKTWF8KBrvJ4co1b6LGKuRfp/uMiJqbTNe8zRFa6G3QwxmvFBtxq6m7R6XZ7Nh/Muzyi6n2X8X3v/wXwAExVHE08aevq2JLWm8KdrPrLaerNtDCKsXE9ARylEjYdSCvAvnGE8k5ZDPBEFpelOVmaGln3udopLPjjdRii7+/rGJTPGd8bfZXgLe1odO6csR2agxL5ZwXXeI09iUwBjvsuzuiT9k+ydCp+xhLFPs+IRCkRgWcYCgDcjkUxIg47K7U2pQN42+aS5KHttx2OTgfx10Zz6ej7a+y6oD3CyfSxudAuP2kwP2BuooNCZ0pu/bnndJv2DDDdgNN4PXurrdRJT8tm3Q7bGGS3Jxbb9aL9GGaUcIgeLkesQyL2ARaWPg1a4vjpaAnE4ef9SJPLryA1Z6d+jnJgBzc8s9cjpyOHKwysEuZ3fTULd8AfYXhSqoRYAvBfEWg+QYba6Hy5JHT6FkfuYOleJ
 I/bBKyFO
 KIqiRBjcOpfCaypPZA0lIn5aTv14cv/FjwIPkdOzDg7X1IFKVV65Za1b3MPB/Ae0Y4AV0mQfommeNrsZ4ZFn4tgN6mZtSS69bmVeiMj2K7XgebOh8/Z/JYoER0AZ+Mpy775SfEGtqOt/cgKcS3O9emnlfiAlB3SEU5eC5xhyYWU51Gxa61R38DKzPbVlVzTB1ShQrj6p4pfBA2OjEiOVqN+atlETPflCvWphnJKoUs76qhQUN8Isrb4+TUUUHQlRlPiNP/MyJCb7Ys9ysKNluZ257HG1hhUUOCleU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 8:08=E2=80=AFAM Chen Linxuan <me@black-desk.cn> wro=
te:
> On Tue, Sep 22, 2026 at 4:22=E2=80=AFAM Jann Horn <jannh@google.com> wrot=
e:
> > On Wed, Sep 2, 2026 at 8:47=E2=80=AFAM Chen Linxuan <me@black-desk.cn> =
wrote:
> > > On Mon, Aug 31, 2026 at 4:49=E2=80=AFPM Christian Brauner <brauner@ke=
rnel.org> wrote:
> > > > On 2026-08-31 10:59 +0800, Chen Linxuan wrote:
> > > > > Obtaining a target task's executable, working directory, or root
> > > > > currently requires walking procfs symlinks such as /proc/<pid>/ex=
e,
> > > > > /proc/<pid>/cwd, and /proc/<pid>/root.  That makes the operation =
depend
> > > > > on procfs being mounted and visible to the caller, even when it a=
lready
> > > > > holds a pidfd for the target.
> > > > >
> > > > > This series adds PIDFD_GET_EXE, PIDFD_GET_CWD, and PIDFD_GET_ROOT=
. Each
> > > > > ioctl takes no argument and returns a close-on-exec O_PATH file
> > > > > descriptor referencing the corresponding task path.  The new ioct=
ls use
> > > > > the same ptrace permission check and nonzero-argument rejection a=
s the
> > > > > existing pidfd namespace ioctls.
> > > > >
> > > > > The target task is sampled while holding its exec_update_lock. Th=
is
> > > > > keeps the access decision and the task-state read in the same exe=
c
> > > > > critical section, preventing a concurrent execve() from changing =
the
> > > > > credentials or target state between the check and the use.
> > > > >
> > > > > The first patch factors out helpers for acquiring referenced task=
 paths
> > > > > and reuses them in procfs and AppArmor.  The second patch introdu=
ces
> > > > > scoped cleanup for privileged pidfd task access and separates nam=
espace
> > > > > lookup from namespace fd creation.  The final patch uses these pi=
eces to
> > > > > implement the three new ioctls.
> > > > >
> > > > > Signed-off-by: Chen Linxuan <me@black-desk.cn>
> > > > > ---
> > > >
> > > > I really have difficulties forming an opinion on this. So this soun=
ds
> > > > very useful but it has implications.
> > > >
> > > > Right now, pidfd ioctls are available even in situations where the =
task
> > > > in question would not be accessible via procfs, e.g., when procfs i=
s
> > > > mounted with "hidepid" options or similar. So this would expand the
> > >
> > > One point regarding hidepid: for callers that can pass
> > > PTRACE_MODE_READ_FSCREDS, hidepid does not provide an additional
> > > restriction. With hidepid=3D1 or hidepid=3D2, has_pid_permissions() f=
alls
> > > back to ptrace_may_access(..., PTRACE_MODE_READ_FSCREDS), and
> > > hidepid=3Dptraceable uses that check directly. In addition, the
> > > /proc/<pid>/{exe,cwd,root} links independently perform the same
> > > PTRACE_MODE_READ_FSCREDS check in call_proc_get_link(), regardless of
> > > the hidepid mode.
> > >
> > > So for these specific path lookups, hidepid does not block a caller w=
ho
> > > would already pass the check used by the proposed pidfd ioctls.
> >
> > Agreed, I think with regards to hidepid there should be no issue here.
> >
> > If I try to come up with scenarios in which this could introduce
> > additional danger, the main one I can think of would be: A task T1 is
> > running inside a pid namespace and has a unix domain socket connection
> > to a task T2 outside the namespace, with both running as the same
> > EUID; T1 sets SO_PASSPIDFD on its socket to obtain a pidfd pointing to
>
> Does SO_PEERPIDFD matter too?

Yeah, I think that would have equivalent impact.

