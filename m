Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0EA1CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 22:10:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF0E08E0005; Wed, 10 Sep 2025 18:10:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC89A8E0001; Wed, 10 Sep 2025 18:10:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDDFA8E0005; Wed, 10 Sep 2025 18:10:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BCBA58E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 18:10:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5FC191402F7
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 22:10:45 +0000 (UTC)
X-FDA: 83874736050.26.EC9C79B
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf02.hostedemail.com (Postfix) with ESMTP id 65A2C8000A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 22:10:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VixnbUEL;
	spf=pass (imf02.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757542243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ud8/LjX5tWIW9/pb4uJHFmXYj1ABUwohGw3Ffq3cLmU=;
	b=C7QAxldtvNGbz4iwCj3kd8xkuQFTbdabuJSp7urtQZuJRikFVWljn1eQeC04rG4WtufI7o
	O5ILjG8TksvcRKTZP8UgPdINMJ5ubPEok8ZgguZqfRNqMTsScc6sL9H18WMAqR9yowxB4Z
	qhhnul/d94kn+2Ymqmjezy5JFIq1gHc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VixnbUEL;
	spf=pass (imf02.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757542243; a=rsa-sha256;
	cv=none;
	b=lQJ+UomrVfR/jovJxJo7ieRSCDBrobyYUBFTQ0yaiVdKX2mdaBNj3m2QrKVp20TkZCZyBg
	V7TuwJgjIQPsJWWOobKv4T8uh0BCSxeX38ONhQ4jmkVNnlCgI/qxzErMRuirTfV8tVL7++
	tawdPFupb7qCR8Jmf9dWYXicVD/TSXI=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45ddca76f22so11535e9.1
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757542242; x=1758147042; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ud8/LjX5tWIW9/pb4uJHFmXYj1ABUwohGw3Ffq3cLmU=;
        b=VixnbUELKCLZ/Ph1cWY+wX2V2R+EDAftlsdU0+wUBnyTCQaz5Wd5OttBdDovaMKGIK
         N/9PLGvUTb6rp3m/DI4FtwN9cCywb4Y3hgdrEVGoIMorW4fo/f34vts335s9Yu13AaNK
         +qeDj9VLOalQRPBTJ1K3CYHra1sPWXU7iXdLdR131yM3SR38Fk1i8YpJf3LkTIFB2z5R
         wWLRXkpZaDXyjYQOlxMlgLcjVZXBfCN7FPAyaPOnIgrnj/tV1bGSJCL6grxeg3Y9hp3h
         /Lqoh1W19qhtQgJWHtkmXnPGefH6wDqQ8uiUnKzYtkJ0CpSYN03hQCS/DKy4bA20opbc
         qj4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757542242; x=1758147042;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ud8/LjX5tWIW9/pb4uJHFmXYj1ABUwohGw3Ffq3cLmU=;
        b=nkli1/KdgD1Zay80ofgm7dGKoXUoCExOwvjAV+uHD7mUP7Em6aQR2PMgQEf0YGSYj/
         yXhSEmJwBHXQ6+EEVyTi5QWp4wh2tYvNxpjXxy5J/4cQGsdo3EQYBdWwTBN8TomHuXIO
         al8APTiRiN0f6DttbVt7OqjNje3n48yOH9u21mtJg5DQc5kPpBGPTCqYKMTtWMV9LvWi
         VuZ5Eu2TBhb1kXxNFchIL2Zw+AUTPKdQFReliVsQzmMxzzwImOrICh9lfkODpwGDhX39
         DOODuEl5Di2GaQgAbubEsxRju0GJtIeWjuJzQlH6/sIqkGpsKiOKKzdwBDlqT9Gkksxt
         Ux+g==
X-Forwarded-Encrypted: i=1; AJvYcCUFGVfYbuVbRcdKOSsBBHRy6cegbTC78oH9bM0iBFLVj6wrF55adPuGHquR5PhIX8StpDmGQuLKZQ==@kvack.org
X-Gm-Message-State: AOJu0YwQui4msaT7/FBVUOoZuzUEnv9MEYxFhMSEbpF5O6DFc4NyhiZM
	XUm/zbrgvxpYuyUjnw7bSgNMRXKstpo+bwjL/lvkbZlPHNeKlgLrBm7artqs9Pyb13ies+zpSav
	jluzqlSieVZMBqU1s08iluUrb255uIYM7AvoLbejo
X-Gm-Gg: ASbGnct3v4nhtFPmxOwshaqqYRhF2UOVfyjvRMs6Lra0UJ/NQPhrI0SBIv5qOB1sPLG
	No0Gs+2V8rJ9cMSCkkATqJSi6EzkDO6MqiWkgDLyK8J/KRhxTBNSRnjhSXqbb5xXygsfStJQ+8q
	GeYNrFkysfliDacW4514EgoDZviOBzv4MTYSSNTtFdSTq9fw91ny/kdtK2Vevg54c1bU2kMBR3L
	Ogw99KC+i0ZLB9jRffiBCQeDiZmarEhI12Hvf6lkxzw
X-Google-Smtp-Source: AGHT+IE3cor2ZFx47kcBwK+FPBD50LrvoMIv/c7Fwfd1Jpre33Ol/npl+FUbI0aeN+ZCL2YEHcjgddsm1h5zK39jj+4=
X-Received: by 2002:a05:600c:8584:b0:45d:f6a6:a13e with SMTP id
 5b1f17b1804b1-45df81fce12mr2007125e9.1.1757542241661; Wed, 10 Sep 2025
 15:10:41 -0700 (PDT)
MIME-Version: 1.0
References: <20250909065349.574894-1-liulei.rjpt@vivo.com> <fszpgct7ywqy6qq3qnjflol3theovmgnau2wgdqqdxin4q7ezm@zumgw533hxon>
 <CAJuCfpFaTj8PsXkoYRQKQ0sOu+mKikUAE8Wbcx+YpZXZ4M7cMA@mail.gmail.com>
 <qisfqncqgkgxh2nj5axafunlfjen6oiciobcrmpus6l3xwrbyj@blxv73pbhzez> <CAJuCfpF1deAfZfWQZkAdws9FDNsmZp3KMQap-LqcX1NzOoknhA@mail.gmail.com>
In-Reply-To: <CAJuCfpF1deAfZfWQZkAdws9FDNsmZp3KMQap-LqcX1NzOoknhA@mail.gmail.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Wed, 10 Sep 2025 15:10:29 -0700
X-Gm-Features: AS18NWDgkOOVxVEJ5m_y8MH1I0nxlUuRqO0CwbrMLM_l8GTe9AE5nrTwvPrjvCI
Message-ID: <CABdmKX2386gYbF5BXzbJ3awybF+edGAfGgFguhAbppejYMKGZA@mail.gmail.com>
Subject: Re: [PATCH v0 0/2] mm: swap: Gather swap entries and batch async release
To: Suren Baghdasaryan <surenb@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Lei Liu <liulei.rjpt@vivo.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Brendan Jackman <jackmanb@google.com>, 
	Zi Yan <ziy@nvidia.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Chen Yu <yu.c.chen@intel.com>, 
	Hao Jia <jiahao1@lixiang.com>, "Kirill A. Shutemov" <kas@kernel.org>, 
	Usama Arif <usamaarif642@gmail.com>, Oleg Nesterov <oleg@redhat.com>, 
	Christian Brauner <brauner@kernel.org>, Mateusz Guzik <mjguzik@gmail.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Andrii Nakryiko <andrii@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Fushuai Wang <wangfushuai@baidu.com>, 
	"open list:MEMORY MANAGEMENT - OOM KILLER" <linux-mm@kvack.org>, open list <linux-kernel@vger.kernel.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 65A2C8000A
X-Stat-Signature: hj95pmpwdi346ozh4ycnmci6xiy6nhuf
X-HE-Tag: 1757542243-782343
X-HE-Meta: U2FsdGVkX1/jL1DfrW825zJiL2BchLuwEi8ZHfvl6bogkwZiUmK5MRkzc7qegx+1l99j975Ju28s9wrj9q9cZ5r82T+lNynlDbsTQmzyhknVgOAXp2MiN8OtKYkaZtn8M7vhpdLGw0t+cYI4IvuaKa6mABiOSH1dFU28974rtiwCUsIS19xu3C1INWPqS5BxP//YfGdr0pTkwtGzHEcW5Y/RScUTtDDVztoracBTiPj2xfCQhtN4T/4ya5SnH6abrHwS70E16SMqtiQxF6c+dwjz3ruAc28gSE5qZEv2g6AkTZ7JUDqE5MZ5lyYWQ7ypZUGNPh/rAGaEB1v9G7H7owD6pU/+Me7zVV4QoNs2OSOB1V+k+QxPP3q/fqXNKbNLO7XKlJqZOmn0J7JGPwzyJx6+BmTROF1iWM2ISriOabLB36WwnIsDB9tFW5pZycMPH53nurW2xHZcu6yqlmBQFXYDJn2o8mXP/N6CFkUtV9d1NjN0Ski9kAVF/Qad+ezzqJxx4uLqhFBPI8XHnQf/ouwv7VkOT6JDPCspGS4WcFUWthMe/3SDgHmqxvDjIZuvxCipJrxrUiUTmuxwiVPDc2yYvoBLow/5Kl+8v0YtavdOizCQM9Qzu5TjMrVuk+fvWxv6LZaZ1qOb4EHJBkqmZItgi78/PxrPX1EUj8ApnF3D23WU+mBPSltMyjEVgMLM9l5voSz1jYnsjII1ovrPXuETAWUnBvreaZ+sKafA2qO/ZfcHoZQGywLiTFPObGLeu1PJiawMpFc2ojloUQLbje5DPVigEC4RxVe6LfKXP+k5eWqDgCQ1kw4PY2O+70rso1YMM4Dgj3yRtRpAYsNxqVV2iOA4/pBiE9HeN7/kBEPjXx4tJKmj4voa2QFfrNd8zSh7oT/390m70BRetlPngvl17oMSlbR2t8pJ13goPspyJiHpFKbRNfam2UPi0xNX2uwGi29R40nyaKG5vYe
 4KQLhcli
 pcWmEffx3SF0VFc3H8+2ychKSc9triM7Q9s/6ngotKg3okDAhTQJnS2UsfOApQ/G+jRETyBIZRfbF+8M3vV8Ucg5YWgeDOdOdowsZNp5J9IZ5jOYUmh5poCY68k/t4DIplc4YYTXfoeXg/A/+4AptK0iJWqD1vpBVtga+PhgUAVEUhEicNpDJG8DXxzMHBKrIkQzN/DblW+XzupefOI6VAtqLa/AIYj9NqStSZRZik86X9cON0/PhICn+QQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 1:41=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Wed, Sep 10, 2025 at 1:10=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.=
dev> wrote:
> >
> > On Tue, Sep 09, 2025 at 12:48:02PM -0700, Suren Baghdasaryan wrote:
> > > On Tue, Sep 9, 2025 at 12:21=E2=80=AFPM Shakeel Butt <shakeel.butt@li=
nux.dev> wrote:
> > > >
> > > > On Tue, Sep 09, 2025 at 02:53:39PM +0800, Lei Liu wrote:
> > > > > 1. Problem Scenario
> > > > > On systems with ZRAM and swap enabled, simultaneous process exits=
 create
> > > > > contention. The primary bottleneck occurs during swap entry relea=
se
> > > > > operations, causing exiting processes to monopolize CPU resources=
. This
> > > > > leads to scheduling delays for high-priority processes.
> > > > >
> > > > > 2. Android Use Case
> > > > > During camera launch, LMKD terminates background processes to fre=
e memory.
> > > >
> > > > How does LMKD trigger the kills? SIGKILL or cgroup.kill?
> > >
> > > SIGKILL
> > >
> > > >
> > > > > Exiting processes compete for CPU cycles, delaying the camera pre=
view
> > > > > thread and causing visible stuttering - directly impacting user
> > > > > experience.
> > > >
> > > > Since the exit/kill is due to low memory situation, punting the mem=
ory
> > > > freeing to a low priority async mechanism will help in improving us=
er
> > > > experience. Most probably the application (camera preview here) wil=
l get
> > > > into global reclaim and will compete for CPU with the async memory
> > > > freeing.
> > > >
> > > > What we really need is faster memory freeing and we should explore =
all
> > > > possible ways. As others suggested fix/improve the bottleneck in th=
e
> > > > memory freeing path. In addition I think we should explore parallel=
izing
> > > > this as well.
> > > >
> > > > On Android, I suppose most of the memory is associated with single =
or
> > > > small set of processes and parallelizing memory freeing would be
> > > > challenging. BTW is LMKD using process_mrelease() to release the ki=
lled
> > > > process memory?
> > >
> > > Yes, LMKD has a reaper thread which wakes up and calls
> > > process_mrelease() after the main LMKD thread issued SIGKILL.
> > >
> >
> > Thanks Suren. I remember Android is planning to use Apps in cgroup. Is
> > that still the plan? I am actually looking into cgroup.kill, beside
> > sending SIGKILL, putting the processes of the target cgroup in the oom
> > reaper list. In addition, making oom reaper able to reap processes in
> > parallel. I am hoping that functionality to be useful to Android as
> > well.
>
> Yes, cgroups v2 with per-app hierarchy is already enabled on Android
> as of about a year or so ago. The first usecase was the freezer. TJ
> (CC'ing him here) also changed how ActivityManager Service (AMS) kills
> process groups to use cgroup.kill (think when you force-stop an app
> that's what will happen). LMKD has not been changed to use cgroup.kill
> but that might be worth doing now. TJ, WDYT?

Sounds like it's worth trying here [1].

One potential downside of cgroup.kill is that it requires taking the
cgroup_mutex, which is one of our most heavily contended locks.

We already have logic that waits for exits in libprocessgroup's
KillProcessGroup [2], but I don't think LMKD needs or wants that from
its main thread. I think we'll still want process_mrelease [3] from
LMKD's reaper thread.

[1] https://cs.android.com/android/platform/superproject/main/+/main:system=
/memory/lmkd/reaper.cpp;drc=3D88ca1a4963004011669da415bc421b846936071f;l=3D=
233
[2] https://cs.android.com/android/platform/superproject/main/+/main:system=
/core/libprocessgroup/processgroup.cpp;drc=3D61197364367c9e404c7da6900658f1=
b16c42d0da;l=3D537
[3] https://cs.android.com/android/platform/superproject/main/+/main:system=
/memory/lmkd/reaper.cpp;drc=3D88ca1a4963004011669da415bc421b846936071f;l=3D=
123

Shakeel could we not also invoke the oom reaper's help for regular
kill(SIGKILL)s?

