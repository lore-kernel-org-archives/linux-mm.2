Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2613EC982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 20:22:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F333B6B008C; Mon, 21 Sep 2026 16:22:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBC776B0092; Mon, 21 Sep 2026 16:22:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5D1C6B0093; Mon, 21 Sep 2026 16:22:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A846B6B008C
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:22:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 34BD0402B8
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:22:52 +0000 (UTC)
X-FDA: 85238892984.12.CDE3C21
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4413B18000C
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:22:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=v2AyopSc;
	spf=pass (imf06.hostedemail.com: domain of jannh@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790022170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZZjuQxZbTYuwf9RVKp56gufP8tt1Juurh+o7CdzjxoY=;
	b=0qbVHvJDvx2SRcexfIdKdxDRXHLzWjezrIvYjIWACCeobsKaLo/HcqsY8FFoelBfE7IZyz
	6g9P5ajVjiDzQ1/FS+1YcJ33/Lz9KLE/DfSLtiCuyvb4E+Sk7FCmWZ42fAis7nFSXd0S3U
	4Ko0rLMlzATrJxaI7rn7DKUkvfN3mis=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790022170;
	b=1qwMEmgkQe74f7pLjdkJYd8ZzIm7Zwri0MfYNQdum6R/zGHWHCb/1jjNox8RSvY3/B7AtA
	0HzYhZ3S/GfgDAq8ZWuGe8j9oIaMVsA2xNVlkMzQ6Qj+Fx6MMTjTmc4vwKq10dXJHpdMri
	otbbWdxwDAJUv+DWrOVQbsHZn3hY2GU=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=v2AyopSc;
	spf=pass (imf06.hostedemail.com: domain of jannh@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2d8facae850so11185ad.0
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:22:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790022169; cv=none;
        d=google.com; s=arc-20260327;
        b=IQdUZ6chdWTvDF/k51Yya16S21tciCD1uj2FwAMlFImYUuVz8eemFjn1B13Dfjmqs2
         XJrlIBrHx8FyetnSiizHZmhEBY7VhCXYaaOPzqsrqRxjRkI86gZFiw7aDeyNAN0areNS
         fZpEJkdCk6Z9XzgrZlZ4lrSL2tXUN5SdFZHWpaAqpQUWjS3XeCOQQjwKXqnQrCc8Pf/T
         PqCtTJcf3T21WB6rtvc6emaYAeN0GlgQXMQ5jRafpGXHJKt+fRDXvrwf+1pxQNqfZlkW
         rYrNKjyF3TX+uaDc0bG5FnkfJZMVKsU/pUk8F1DXBi1scOjl3KdwTuIjThAVROUjkzPz
         Ggvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZZjuQxZbTYuwf9RVKp56gufP8tt1Juurh+o7CdzjxoY=;
        fh=KG9Ag9EeFoNyuRYOImE9GJbWvPtvakHk7cFSITZ2et4=;
        b=YMt/g8wxRHy597pruS5orr1lOisnsB1to8N8PT9+sYAs6YSvWJft0RCgBLgtvqLsEH
         +bqfetUtpsZXSzIWF9sZCOnHhywJLngvspwHQgoKX7poGClU2T7XA6o8bBmKjLtFZQ0k
         LdxuEUGRQPif1qKUL/jI1NIXgK0B3+0d8dbfH+rGaMgIW0FTJrmVhEu55fUwKPxcYLYI
         9nKbWYl7cxQeDLNEmGeqyIpLEPltUrCbnZQilIdx2RY/H3L1NXY/O6WfA5xKJ/SB7FRa
         XXn3T7YHxxZlYiptJULo6U/ei/N/Ql0Id7mdhlsNxyQYFjtQsa9GCMRja7HcdWRcC64Z
         MXMg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790022169; x=1790626969; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZZjuQxZbTYuwf9RVKp56gufP8tt1Juurh+o7CdzjxoY=;
        b=v2AyopSc7Qc6px2Tv06lK6WccP1TGMKMokd7/vFOFtRu4W3WHvTxpOzfquNp3St7TA
         X0P6Af52hBlajL4pn+PKDEjUfoII6cqd53/56R6sWe2jQkrLXi/0prEpJvC89Jwqs/SV
         9/NANyU4aYN1PuEu2vhKyt+5Fj5VC89NthNW0Q8nn5XvfnwpGCN7nc0o7rZFVZvIXxX4
         bY+EC48250f5LvM2Dy6PO24tfL3MYqxY7TEiX8En2QWOaznEl9umRsiUXgJGKs3mQtwC
         nQ9sgu5qZh4v1Ae99FmFJ9f8HRvbi5pe8UbtOLQN41MxEmkbbJxDsBn9NMsIhQ0W6fp2
         kRLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790022169; x=1790626969;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZZjuQxZbTYuwf9RVKp56gufP8tt1Juurh+o7CdzjxoY=;
        b=cqMPQz/PHP6UU3S2l3n681+dclTUtxCyUij9S64r7zarPTBNJoI/jyMO/1s2HB8Weu
         GMgqxKGMbydJUciqgGPBEzZYaax3IhWSQZanjTQ0JruKQNmigdbFbxNeQRgxa3azJsR0
         +7JfWyx9Nucn20MPFKwciZw808uRKPL1wVQT9vgm3M7Drcw83VrkdUrN2Y2lQg6wYav5
         e2wyrlFGMoypsehGlb4QP4BzT5rZaCD03DE4qUPfG22Yl2KOfWtJ9FyRLCab8oIc+Wn9
         RE2YiI6pnK0EkQge/76gM/rJlPWIBq6KLh6n6zC98+BR1mBBudmFdJRJHYtXeskFK3HR
         Oc+g==
X-Forwarded-Encrypted: i=1; AKwUvBw6ElgPmb9WLh62gssdOYtAzu5W+LxKHWbi3cKKEJJVsJqtkCgkqETjx/h3XyCiKlgmgC2+Hbl53A==@kvack.org
X-Gm-Message-State: AFuF++kbHDVc7iK2RkAKXsVWctCYBAs2/b+682tPlHycE/BBKK5jmnD0
	za5W/S9LzkfKm/VMwPSSNgJtP6Tw0W+nqcA/jp4eSB/rACWmyHfG7Sr69h7lfIB7oRCcmkoJLNy
	4bzhfbAhWnNCFysnoIxfztGIvqiRR+cZb12M6C8hs
X-Gm-Gg: AYBFou00FfkMLdkkx/AmVjnGWP7QpaBVphYEe/sNxVALxj91iKzEsArulXs2kSqnPRD
	MsJ8Ww8A2IP4qYDdlXv6GxjYdbZPTu8DTu0t1pMT1+/L7nHNIprDRTIWB184nQ9l19SQqQ9TXU0
	mNnVeigKz8y1wOZNELQnS98w4+fHa4Zf+XoEJV2pS+KRyY6wfk8uRdcc1nDlUu0KQMThjua2d38
	22E50Oa1+y9+zB/srw4QZ21hkAAoOfb/DvaESDE0DV+eScpIlUT3dt1L50M7QhpmP98zVRbKMja
	kUeaLZzFAXFP0FWqe+l8hNCNJ2EO6gxo0GlFDW1k/VobMJtyI4tWnZIw0eN1Pob3rWUNpdaRskp
	IcM3wNBOC/1UVSIvEnoRfwNvyxHBHF/ShHk1M6rXC
X-Received: by 2002:a17:902:d98b:b0:2dd:280b:cdfc with SMTP id
 d9443c01a7336-2df5b83676fmr449455ad.17.1790022168357; Mon, 21 Sep 2026
 13:22:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260831-pidfd-get-paths-v2-0-c59ea6a21b72@black-desk.cn>
 <20260831-tauwetter-werkbank-dramen-b37eb4025283@brauner> <CAC1kPDMK_D4nhyRmBHg6KC7SmmCkH73Xtc5DhXeJbSvf3LcqcQ@mail.gmail.com>
In-Reply-To: <CAC1kPDMK_D4nhyRmBHg6KC7SmmCkH73Xtc5DhXeJbSvf3LcqcQ@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Mon, 21 Sep 2026 22:22:11 +0200
X-Gm-Features: AcwNN1UtR6M4RsRB1V4M9ZXr6hSPfcvgRf-Sf3BDBnWgXtSIC5rk0Yng7pQuhSw
Message-ID: <CAG48ez1T5-tUHVK_iHsgUtWa-inVdrZxA3E-ZCW0iENJvasKfg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] pidfd: add task path ioctls
To: Chen Linxuan <me@black-desk.cn>, Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
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
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: hp7wtga7kk39rgu5yxcquw3b1npon6ar
X-Rspamd-Queue-Id: 4413B18000C
X-HE-Tag: 1790022170-198213
X-HE-Meta: U2FsdGVkX18Fxk5T9UVSL4Ypkil5mTXMfbGtEGxAsXCSCv5olflGp5I7Qg5p3ZN6i5cpSYbRpcOLb1q2mgiWm7/MJXONib3R6gSHfpsTM61r/tNQDIyXvJHMgJPgA2XEiRlsD5rLnZhvvSozfGzk2+ij4TcnNL5RNIRledoD+45FtW9f0QL+wDCG18xK2aETTI76mGTHGFtNxZNOCdvSQ65MEGZmTOx2/B5gb8v+WJYCTOFkxX9v9gmrmItjHaprJ7kpKYxbCS1Ot4EWqO3m9JAZjhoDKTWOjPeSgJarbmTRE48MHhlmDVUgycXPWDI+IL5e22m7iqjCr7xIc3dg2uGTl/P8keFJzB88OB2agdBxOl/SnfTuMID84wLPH4e3euxwEyAPlXvHo5/9BCSe6m9ZocBoqngYYqlgfAoOZcBBl81Ge8v9ejxMdw1ch5e8vG/xvIe6wtuHs040DNqMQ+RWpmaFYKU4Y7wGWDSNvngLaWQLFRnJ1Rbpf+sQ2a/ZxufWeyroB4GdUF//J/1vcwoYJHyiGQ2F0mwAPc4xyc4L7Es3I59EeWBj3VvobE5sPXJOskqBOshkRbwkqZpGWy5HmCT7hmU18vdhCtt5eEE+jFsvNDgYp+OekAe3KXhWU6Z7LBaN5jx/jMq4uYOQUZGP6cVQMbycMTDYJYSpETMXyuZe9lF5D0uAAKRFktdXCRV0H2sv79cp1DCdGRHs2s04R4IPM9mXnoDOgPxNeQYVuee59kqfddNO7wB/UikJFEwnb6ylzjAAuj9IW5gSHUANDuxNZP9U8/vhw673ywyum0aExyKiPxjkZezEoB9NigYeNE2PIPsnVdkW2LqFKROgB3WuTzHxild5taSFnfH29hROt80elDSSi8ADeDjgm39HlDWlBfTBVXlNQmZvEKMjiv/I01xUCIQwmWpjYs+lzEd5KBVA49i6aHfTg34nzlEugAPUVk53Ys3/N3l
 tuFi+Lbx
 eYL378ZgbIZ4DYvTC4qHVbGJEuDjQMNE3aZ6d6HN5yMzCMdMcW0WaEdyZbFhU3jgDe6QYFwFhkIrZh7Ffn71bU5dGL7gYCADFn+wfHoQ/X4Mdhmr3STgZ4jd8AJirjoanTAJio89yEpWhaFoJaRpJIJ4Ms/dXPEOYdmD9p9DDAKPam8x+tptbqsXc52XtMr3j685+/4Ipgvl9IrcoGGW016+Hfn9lJvWACLdNtl13hwAI5pa1JJCGjuCCumAUdw5tht2NvhO1miRJ/u20WY2aXzwo/qvo7SbFpM3odUHsiSLDxcI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 2, 2026 at 8:47=E2=80=AFAM Chen Linxuan <me@black-desk.cn> wrot=
e:
> On Mon, Aug 31, 2026 at 4:49=E2=80=AFPM Christian Brauner <brauner@kernel=
.org> wrote:
> > On 2026-08-31 10:59 +0800, Chen Linxuan wrote:
> > > Obtaining a target task's executable, working directory, or root
> > > currently requires walking procfs symlinks such as /proc/<pid>/exe,
> > > /proc/<pid>/cwd, and /proc/<pid>/root.  That makes the operation depe=
nd
> > > on procfs being mounted and visible to the caller, even when it alrea=
dy
> > > holds a pidfd for the target.
> > >
> > > This series adds PIDFD_GET_EXE, PIDFD_GET_CWD, and PIDFD_GET_ROOT. Ea=
ch
> > > ioctl takes no argument and returns a close-on-exec O_PATH file
> > > descriptor referencing the corresponding task path.  The new ioctls u=
se
> > > the same ptrace permission check and nonzero-argument rejection as th=
e
> > > existing pidfd namespace ioctls.
> > >
> > > The target task is sampled while holding its exec_update_lock. This
> > > keeps the access decision and the task-state read in the same exec
> > > critical section, preventing a concurrent execve() from changing the
> > > credentials or target state between the check and the use.
> > >
> > > The first patch factors out helpers for acquiring referenced task pat=
hs
> > > and reuses them in procfs and AppArmor.  The second patch introduces
> > > scoped cleanup for privileged pidfd task access and separates namespa=
ce
> > > lookup from namespace fd creation.  The final patch uses these pieces=
 to
> > > implement the three new ioctls.
> > >
> > > Signed-off-by: Chen Linxuan <me@black-desk.cn>
> > > ---
> >
> > I really have difficulties forming an opinion on this. So this sounds
> > very useful but it has implications.
> >
> > Right now, pidfd ioctls are available even in situations where the task
> > in question would not be accessible via procfs, e.g., when procfs is
> > mounted with "hidepid" options or similar. So this would expand the
>
> One point regarding hidepid: for callers that can pass
> PTRACE_MODE_READ_FSCREDS, hidepid does not provide an additional
> restriction. With hidepid=3D1 or hidepid=3D2, has_pid_permissions() falls
> back to ptrace_may_access(..., PTRACE_MODE_READ_FSCREDS), and
> hidepid=3Dptraceable uses that check directly. In addition, the
> /proc/<pid>/{exe,cwd,root} links independently perform the same
> PTRACE_MODE_READ_FSCREDS check in call_proc_get_link(), regardless of
> the hidepid mode.
>
> So for these specific path lookups, hidepid does not block a caller who
> would already pass the check used by the proposed pidfd ioctls.

Agreed, I think with regards to hidepid there should be no issue here.

If I try to come up with scenarios in which this could introduce
additional danger, the main one I can think of would be: A task T1 is
running inside a pid namespace and has a unix domain socket connection
to a task T2 outside the namespace, with both running as the same
EUID; T1 sets SO_PASSPIDFD on its socket to obtain a pidfd pointing to
T2 on the next message sent by T2, then T1 uses that to get access to
the mount namespace of T2.

Christian, is there some mechanism that already protects against using
something like SO_PASSPIDFD to get a pidfd to a process in a parent
namespace?
Otherwise, should we add something like a "pid_vnr(pid) !=3D 0" check
either in these new operations or in SO_PASSPIDFD?

