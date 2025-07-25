Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5ABFC87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 16:23:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 846916B009B; Fri, 25 Jul 2025 12:23:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81F2D6B009D; Fri, 25 Jul 2025 12:23:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E6616B009E; Fri, 25 Jul 2025 12:23:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 59B826B009B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 12:23:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8867A1DB6E6
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:23:05 +0000 (UTC)
X-FDA: 83703306330.29.279998C
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id 75E8A4000D
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:23:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lt0N2Rn5;
	spf=pass (imf04.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753460583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z57Bp7fcgh9mpw4Mw69raPU+Ddkv3U7TmKT9VCG6aHQ=;
	b=Qtcc5c1BwZTvqvXGY5DrhuEaLpDJbfYkk8IqG11gB1IQVjf+Wkr9rR7W+cu2XvUImDTsP+
	01nZgNZVoybBR64ltQK76qV2j8ej6s8/nE63ntk/T6lNmUtuUg990zzcKJ/+k52avRb/qF
	Q/+hJCd4/VkXbHRsEnKvBfvi6e56RMY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753460583; a=rsa-sha256;
	cv=none;
	b=0LRgH+5QXK6EJRksIc/D0KNtSKFSynd9uPhBHRXlD7GcsLBBSiWOzqokhQ808CD2W5JFJD
	N0JbUW56nr0yelqWri2KUrH5XshyVnRS0TE8iRIdNktu4I1G4MY3Hd1Dm6VWCXOUXTOZ6R
	arQuTJMbs7hl3KqwwaPfKB8pc/9KpLg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lt0N2Rn5;
	spf=pass (imf04.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7e2c920058fso331248985a.0
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 09:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753460582; x=1754065382; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z57Bp7fcgh9mpw4Mw69raPU+Ddkv3U7TmKT9VCG6aHQ=;
        b=lt0N2Rn5meLHTPWgAYkWe+/01k91BA6r5ZAPDpbT2hbY8SovtVipjugm4WH00y0sY9
         LKJ3yRQa6LudAwrYAFgm5KhlOk8QQn/KioacWVtbsIZ99dZJIuWCgohLrzHHfF0gN70G
         zdzAAb8Q51+66GK2XvWscHrUekTqD3lZL1rpKILNvRSIKOE7HicJtUpuc8QNDkW0LitH
         E588CvCI/ylaKcXqxL4ULmNw+hhb8H/ecMRWAtXmdNqJuMV20kKrjyrODwXyib/RXy4X
         V4811lskv+RCuyo1izn4wXRTjCl3jUzDrO/YRSJ+nOZc91tsp/s0GEAvKnqcYxsyc7D4
         4URQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753460582; x=1754065382;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z57Bp7fcgh9mpw4Mw69raPU+Ddkv3U7TmKT9VCG6aHQ=;
        b=IY20zg0M7UYGmu3ZHuDwzwHbbO1/30TODbEVZlygpYrcwCLvlPk/xfhJJ5LrIRh68R
         w6tawYGi2uXJf9FFMejqmUb2hF8LiRO1lEElyJN/kbL944x8LQonVVxnji7azjnMeaMu
         F57Uiq8ZfArHHEjvdf/xGoB1+2TZMoAm80D2gmi1p7G+XQA78GSncshEpnK4KIwRJRS6
         KxEPjQBTaL11iLVF3vlUXGF//ZgbvXk20jYW8dhpYugDxqycnjn8LyKlX50xTwtsgP6N
         9IvUNUZaXfsX7Ub2echbgQvvedix6s/AWtMgGMKm9nNMI6N/pZy1QQWEx1JYnCHjWgOg
         RJ5g==
X-Forwarded-Encrypted: i=1; AJvYcCWm2KXb910Lqyss38UlSFButqIL9E5pEQ5sg1/QNHMz44QptyZu3P7cUkvdUE5eq1MfJnSVAsheZA==@kvack.org
X-Gm-Message-State: AOJu0YxjshSd1h299Rj1RYbjv+LsUAjkT1bquD5j6HfVB3LN7Zj1tbmF
	PcS8zqSt1hi7V0MNIytEulvEuEjRV7siTZMaW78QXlVp+SkXHgkEGTF5
X-Gm-Gg: ASbGncsvF22OTtPdb3QXg/DtO5JhZQhtWpBrad0W1jJbYcBWwNwQudTUICzEd4UVLOs
	A1ICtdsK7gL6Pu3hkPuqoyMA0Mlp98HWjKws/AvaKVpxkPzdV6T0wBTPWBv5VH0IN9S2Eo42tHe
	DDuXmEafnWPSjGrgxMcJuojAbanOV/pVyW/IRNawHpU0pTfvY3PC/hkeUFCCW3BmsaN7thfty6Y
	31lsRznilKaGPlJXghBHuiMNI0OR62bLbfTcOImF0IccLqEMeBqDkYWNmj0o9iYsQDMwLLMOAFS
	kULcT5Bhkiqml9CdRyfoaen2WaxOb/+2o8CC12wmqQi6dVpSzaV+wtAmJlpUAk0o/RlN/7SIMqX
	l884BoZtGxVHvowYAPJRk
X-Google-Smtp-Source: AGHT+IGCeNke0SeM9Ispg/d02iGrJuhljbXVRw1O86IJ1A7bjFuImtZGjecGyafqaBCHYBK2FmMnNQ==
X-Received: by 2002:a05:620a:2683:b0:7e3:340c:2f12 with SMTP id af79cd13be357-7e633ce53f0mr821330485a.0.1753460581900;
        Fri, 25 Jul 2025 09:23:01 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:72::])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e6438a61b7sm13048985a.91.2025.07.25.09.23.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 09:23:00 -0700 (PDT)
From: Usama Arif <usamaarif642@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@redhat.com,
	linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org,
	corbet@lwn.net,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	baohua@kernel.org,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	ziy@nvidia.com,
	laoar.shao@gmail.com,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	vbabka@suse.cz,
	jannh@google.com,
	Arnd Bergmann <arnd@arndb.de>,
	sj@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 1/5] prctl: extend PR_SET_THP_DISABLE to optionally exclude VM_HUGEPAGE
Date: Fri, 25 Jul 2025 17:22:40 +0100
Message-ID: <20250725162258.1043176-2-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250725162258.1043176-1-usamaarif642@gmail.com>
References: <20250725162258.1043176-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 75E8A4000D
X-Stat-Signature: gmgfx8bx8omououk1yj9z69onxsw6ga7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753460583-211371
X-HE-Meta: U2FsdGVkX1/fUk+QBMODJ7R5vpeBluiivcdrs8gBlaB+69A1I/viWaMh1A3W9Ndo0Fiu9xkGeinTFgkHFXa6hgxoFVagIuHoFmjkFw0WEAMLllt2K2icBlNLMZe6zT+PtuAr+C5CiQ55ytYsGHDU4fg4mZAK47Rzrz57X2pBqNj6nzQwhmeZbYSxigqsHJw6rAtBWrckmqYvz0wmHaBr0BdWyzo/4fDsd58sl3hVbRY/uSBGsB1RdPAD24B/H7UuTrL6I9QHksTdP+Yfy3QUP74tJIvUsANYznn9+ZXG/HMpxojzqJstX9cEtz2JmEVu3i4SgXcROnPEnNNSz7I1tZcXl1Adlp9U/YkmNm5rB5rRVq2CUGMf/9VMixr75ca6yXCfX3agwLvZMDWS32dBGu+GYZwTHbFN5PdOR4q2Lgii8YHU+lieeoEvQS5dspaGc8vceIXja2Ohn340egN1rlb4TYNos8yk+knBLZ1e7ymye237l2JMZJCnmEk/Ju63QOwxzLSuPAkVZuBOMKIOeLOVOUqXsNPBW4pAL3DrBSYB/xhsMQaBTpq9li2JEOE+8OTfkiZDdEV9JGKdso/+7TqNF9iRmeUiUnQBmUeQzSG6qmFx02janLWQj3PZe2If8xulTP6nyvDQc4l79zzafcufWqBj143DdsDrbmafaSuhw064rGDk8wygppNFWDzB0nBTWSvNqAxmCY7qugPicW0m2JOkrlmDDxf9+C2YOkUOec8lZEmHo9qGhpmCDng3e6HTPTYR8zD9VXNTttfGK+c3Dvlt/HtgG53aJreIyfELrNSyOtyRuyvCiDCLVjWVqs0d+k0KM8CKfyh5qT2G8zmpRDYKMYbAGsrJs2XnW35SLlLpvCZlJzvQZ1L7M5clE0RKAfdcXDKjJc527CJp45ASzpRw0z5PwVR6hXuBmvELZHnJii9A3HKBnTmImD6cuPe4WQyArezWXxYWeiZ
 3mwW37P7
 j8paTuM3i3WTEcPghDsfocUhPQpYIXPQ8sZekRyKRUr7fBsOoIKda/h6vMT2vRKqFrgAELZ/cWBLyok6TcxHCXs2mjP+CHTtvWANWqurNsZ9Rsk1fMiKlwleG+nJQexu1PBQB8LEGM2XMNDbE7hLS1qMKcBe5FArvKba+HumfPQ5xq6xSe+raBYrrCUjlsnTWIL15gIhfogdmuCyLIYfA5okEtHwU3+15VGlE3L0pNB4APYRZFIF34Av0TCdG5iHqVqvaZH6ZckIe7MI9pfwj8Hu11dQW7dU8gwALawNU0LqLQRErrl3VqO74rtEk+5C0FH6sEGP5jtmzaPakZMY5CaAsm24qB4DmqXnXyyM4UB9CPbHIKwRrocZAFFWfZAIZBd6ztDs/DwB5I5mCrWl4gJoMPHa0zyi/rs7futN1qTjEdN4O+xCXTgZtUs/TtfUVy7mIirfJWE1MRfKikezW4ldG5Ikg6BbD9ed0O9TwrlrdWOtNgH4UHwIkS7hvlrgbUfyPYTPbjr74aNMvmDCny6EVdgxSw7sPQc0Fx8loo0hZ8UO473eYoGnUnaB132WoyvQ5BSao3w1a+jpKPtTxxDJHxECTikPKJQGeX6HqxW5+xsLFeHrlFKptMnWJM9R91uezAcXvfacalUyBmR+hdG5on11W1WtEmcIHkCOjiEjaLcEhG+jjK76zmq9IsADs4gjBW6E856zPa6WPTcwuZ+PEIDcgE0kbf+X5wKbobKr1zjH0Yn1YcKgFmHy0SLZ0ochFYA2DyoWsdiT5KZGN1YOnu2sKbyVlW/HHDoVyxQmkIU/x9oVneWAB0DGjS7RuUUhLu475i7nauYKU59JRSqoT7wnQhA9Vd6nim+Z6Ml0rdkhq7zQZsADV3bM2VaAe9afWW9g6m/HSPTdIudi+4HRZjHIba+mXVCkF/5tE5SggYce6T7ZSlriCiipU5CrCb+8Wuad7GJ/KRKAN9qaAOjxQ8GS+
 JMhozpBs
 vEKytZWE0GCtYmPM2IdlYodmDJIqX3jj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Hildenbrand <david@redhat.com>

People want to make use of more THPs, for example, moving from
the "never" system policy to "madvise", or from "madvise" to "always".

While this is great news for every THP desperately waiting to get
allocated out there, apparently there are some workloads that require a
bit of care during that transition: individual processes may need to
opt-out from this behavior for various reasons, and this should be
permitted without needing to make all other workloads on the system
similarly opt-out.

The following scenarios are imaginable:

(1) Switch from "none" system policy to "madvise"/"always", but keep THPs
    disabled for selected workloads.

(2) Stay at "none" system policy, but enable THPs for selected
    workloads, making only these workloads use the "madvise" or "always"
    policy.

(3) Switch from "madvise" system policy to "always", but keep the
    "madvise" policy for selected workloads: allocate THPs only when
    advised.

(4) Stay at "madvise" system policy, but enable THPs even when not advised
    for selected workloads -- "always" policy.

Once can emulate (2) through (1), by setting the system policy to
"madvise"/"always" while disabling THPs for all processes that don't want
THPs. It requires configuring all workloads, but that is a user-space
problem to sort out.

(4) can be emulated through (3) in a similar way.

Back when (1) was relevant in the past, as people started enabling THPs,
we added PR_SET_THP_DISABLE, so relevant workloads that were not ready
yet (i.e., used by Redis) were able to just disable THPs completely. Redis
still implements the option to use this interface to disable THPs
completely.

With PR_SET_THP_DISABLE, we added a way to force-disable THPs for a
workload -- a process, including fork+exec'ed process hierarchy.
That essentially made us support (1): simply disable THPs for all workloads
that are not ready for THPs yet, while still enabling THPs system-wide.

The quest for handling (3) and (4) started, but current approaches
(completely new prctl, options to set other policies per process,
alternatives to prctl -- mctrl, cgroup handling) don't look particularly
promising. Likely, the future will use bpf or something similar to
implement better policies, in particular to also make better decisions
about THP sizes to use, but this will certainly take a while as that work
just started.

Long story short: a simple enable/disable is not really suitable for the
future, so we're not willing to add completely new toggles.

While we could emulate (3)+(4) through (1)+(2) by simply disabling THPs
completely for these processes, this is a step backwards, because these
processes can no longer allocate THPs in regions where THPs were
explicitly advised: regions flagged as VM_HUGEPAGE. Apparently, that
imposes a problem for relevant workloads, because "not THPs" is certainly
worse than "THPs only when advised".

Could we simply relax PR_SET_THP_DISABLE, to "disable THPs unless not
explicitly advised by the app through MAD_HUGEPAGE"? *maybe*, but this
would change the documented semantics quite a bit, and the versatility
to use it for debugging purposes, so I am not 100% sure that is what we
want -- although it would certainly be much easier.

So instead, as an easy way forward for (3) and (4), add an option to
make PR_SET_THP_DISABLE disable *less* THPs for a process.

In essence, this patch:

(A) Adds PR_THP_DISABLE_EXCEPT_ADVISED, to be used as a flag in arg3
    of prctl(PR_SET_THP_DISABLE) when disabling THPs (arg2 != 0).

    prctl(PR_SET_THP_DISABLE, 1, PR_THP_DISABLE_EXCEPT_ADVISED).

(B) Makes prctl(PR_GET_THP_DISABLE) return 3 if
    PR_THP_DISABLE_EXCEPT_ADVISED was set while disabling.

    Previously, it would return 1 if THPs were disabled completely. Now
    it returns the set flags as well: 3 if PR_THP_DISABLE_EXCEPT_ADVISED
    was set.

(C) Renames MMF_DISABLE_THP to MMF_DISABLE_THP_COMPLETELY, to express
    the semantics clearly.

    Fortunately, there are only two instances outside of prctl() code.

(D) Adds MMF_DISABLE_THP_EXCEPT_ADVISED to express "no THP except for VMAs
    with VM_HUGEPAGE" -- essentially "thp=madvise" behavior

    Fortunately, we only have to extend vma_thp_disabled().

(E) Indicates "THP_enabled: 0" in /proc/pid/status only if THPs are
    disabled completely

    Only indicating that THPs are disabled when they are really disabled
    completely, not only partially.

    For now, we don't add another interface to obtained whether THPs
    are disabled partially (PR_THP_DISABLE_EXCEPT_ADVISED was set). If
    ever required, we could add a new entry.

The documented semantics in the man page for PR_SET_THP_DISABLE
"is inherited by a child created via fork(2) and is preserved across
execve(2)" is maintained. This behavior, for example, allows for
disabling THPs for a workload through the launching process (e.g.,
systemd where we fork() a helper process to then exec()).

For now, MADV_COLLAPSE will *fail* in regions without VM_HUGEPAGE and
VM_NOHUGEPAGE. As MADV_COLLAPSE is a clear advise that user space
thinks a THP is a good idea, we'll enable that separately next
(requiring a bit of cleanup first).

There is currently not way to prevent that a process will not issue
PR_SET_THP_DISABLE itself to re-enable THP. There are not really known
users for re-enabling it, and it's against the purpose of the original
interface. So if ever required, we could investigate just forbidding to
re-enable them, or make this somehow configurable.

Acked-by: Usama Arif <usamaarif642@gmail.com>
Tested-by: Usama Arif <usamaarif642@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: David Hildenbrand <david@redhat.com>

---

At first, I thought of "why not simply relax PR_SET_THP_DISABLE", but I
think there might be real use cases where we want to disable any THPs --
in particular also around debugging THP-related problems, and
"never" not meaning ... "never" anymore ever since we add MADV_COLLAPSE.
PR_SET_THP_DISABLE will also block MADV_COLLAPSE, which can be very
helpful for debugging purposes. Of course, I thought of having a
system-wide config option to modify PR_SET_THP_DISABLE behavior, but
I just don't like the semantics.

"prctl: allow overriding system THP policy to always"[1] proposed
"overriding policies to always", which is just the wrong way around: we
should not add mechanisms to "enable more" when we already have an
interface/mechanism to "disable" them (PR_SET_THP_DISABLE). It all gets
weird otherwise.

"[PATCH 0/6] prctl: introduce PR_SET/GET_THP_POLICY"[2] proposed
setting the default of the VM_HUGEPAGE, which is similarly the wrong way
around I think now.

The ideas explored by Lorenzo to extend process_madvise()[3] and mctrl()[4]
similarly were around the "default for VM_HUGEPAGE" idea, but after the
discussion, I think we should better leave VM_HUGEPAGE untouched.

Happy to hear naming suggestions for "PR_THP_DISABLE_EXCEPT_ADVISED" where
we essentially want to say "leave advised regions alone" -- "keep THP
enabled for advised regions",

The only thing I really dislike about this is using another MMF_* flag,
but well, no way around it -- and seems like we could easily support
more than 32 if we want to (most users already treat it like a proper
bitmap).

I think this here (modifying an existing toggle) is the only prctl()
extension that we might be willing to accept. In general, I agree like
most others, that prctl() is a very bad interface for that -- but
PR_SET_THP_DISABLE is already there and is getting used.

Long-term, I think the answer will be something based on bpf[5]. Maybe
in that context, I there could still be value in easily disabling THPs for
selected workloads (esp. debugging purposes).

Jann raised valid concerns[6] about new flags that are persistent across
exec[6]. As this here is a relaxation to existing PR_SET_THP_DISABLE I
consider it having a similar security risk as our existing
PR_SET_THP_DISABLE, but devil is in the detail.

[1] https://lore.kernel.org/r/20250507141132.2773275-1-usamaarif642@gmail.com
[2] https://lkml.kernel.org/r/20250515133519.2779639-2-usamaarif642@gmail.com
[3] https://lore.kernel.org/r/cover.1747686021.git.lorenzo.stoakes@oracle.com
[4] https://lkml.kernel.org/r/85778a76-7dc8-4ea8-8827-acb45f74ee05@lucifer.local
[5] https://lkml.kernel.org/r/20250608073516.22415-1-laoar.shao@gmail.com
[6] https://lore.kernel.org/r/CAG48ez3-7EnBVEjpdoW7z5K0hX41nLQN5Wb65Vg-1p8DdXRnjg@mail.gmail.com

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 Documentation/filesystems/proc.rst |  5 +--
 fs/proc/array.c                    |  2 +-
 include/linux/huge_mm.h            | 20 ++++++++---
 include/linux/mm_types.h           | 13 +++----
 include/uapi/linux/prctl.h         | 10 ++++++
 kernel/sys.c                       | 58 +++++++++++++++++++++++-------
 mm/khugepaged.c                    |  2 +-
 7 files changed, 81 insertions(+), 29 deletions(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index 2971551b7235..915a3e44bc12 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -291,8 +291,9 @@ It's slow but very precise.
  HugetlbPages                size of hugetlb memory portions
  CoreDumping                 process's memory is currently being dumped
                              (killing the process may lead to a corrupted core)
- THP_enabled		     process is allowed to use THP (returns 0 when
-			     PR_SET_THP_DISABLE is set on the process
+ THP_enabled                 process is allowed to use THP (returns 0 when
+                             PR_SET_THP_DISABLE is set on the process to disable
+                             THP completely, not just partially)
  Threads                     number of threads
  SigQ                        number of signals queued/max. number for queue
  SigPnd                      bitmap of pending signals for the thread
diff --git a/fs/proc/array.c b/fs/proc/array.c
index d6a0369caa93..c4f91a784104 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -422,7 +422,7 @@ static inline void task_thp_status(struct seq_file *m, struct mm_struct *mm)
 	bool thp_enabled = IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE);
 
 	if (thp_enabled)
-		thp_enabled = !test_bit(MMF_DISABLE_THP, &mm->flags);
+		thp_enabled = !test_bit(MMF_DISABLE_THP_COMPLETELY, &mm->flags);
 	seq_printf(m, "THP_enabled:\t%d\n", thp_enabled);
 }
 
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 7748489fde1b..71db243a002e 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -318,16 +318,26 @@ struct thpsize {
 	(transparent_hugepage_flags &					\
 	 (1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG))
 
+/*
+ * Check whether THPs are explicitly disabled for this VMA, for example,
+ * through madvise or prctl.
+ */
 static inline bool vma_thp_disabled(struct vm_area_struct *vma,
 		vm_flags_t vm_flags)
 {
+	/* Are THPs disabled for this VMA? */
+	if (vm_flags & VM_NOHUGEPAGE)
+		return true;
+	/* Are THPs disabled for all VMAs in the whole process? */
+	if (test_bit(MMF_DISABLE_THP_COMPLETELY, &vma->vm_mm->flags))
+		return true;
 	/*
-	 * Explicitly disabled through madvise or prctl, or some
-	 * architectures may disable THP for some mappings, for
-	 * example, s390 kvm.
+	 * Are THPs disabled only for VMAs where we didn't get an explicit
+	 * advise to use them?
 	 */
-	return (vm_flags & VM_NOHUGEPAGE) ||
-	       test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags);
+	if (vm_flags & VM_HUGEPAGE)
+		return false;
+	return test_bit(MMF_DISABLE_THP_EXCEPT_ADVISED, &vma->vm_mm->flags);
 }
 
 static inline bool thp_disabled_by_hw(void)
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 1ec273b06691..123fefaa4b98 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1743,19 +1743,16 @@ enum {
 #define MMF_VM_MERGEABLE	16	/* KSM may merge identical pages */
 #define MMF_VM_HUGEPAGE		17	/* set when mm is available for khugepaged */
 
-/*
- * This one-shot flag is dropped due to necessity of changing exe once again
- * on NFS restore
- */
-//#define MMF_EXE_FILE_CHANGED	18	/* see prctl_set_mm_exe_file() */
+#define MMF_HUGE_ZERO_PAGE	18      /* mm has ever used the global huge zero page */
 
 #define MMF_HAS_UPROBES		19	/* has uprobes */
 #define MMF_RECALC_UPROBES	20	/* MMF_HAS_UPROBES can be wrong */
 #define MMF_OOM_SKIP		21	/* mm is of no interest for the OOM killer */
 #define MMF_UNSTABLE		22	/* mm is unstable for copy_from_user */
-#define MMF_HUGE_ZERO_PAGE	23      /* mm has ever used the global huge zero page */
-#define MMF_DISABLE_THP		24	/* disable THP for all VMAs */
-#define MMF_DISABLE_THP_MASK	(1 << MMF_DISABLE_THP)
+#define MMF_DISABLE_THP_EXCEPT_ADVISED	23	/* no THP except when advised (e.g., VM_HUGEPAGE) */
+#define MMF_DISABLE_THP_COMPLETELY	24	/* no THP for all VMAs */
+#define MMF_DISABLE_THP_MASK	((1 << MMF_DISABLE_THP_COMPLETELY) |\
+				 (1 << MMF_DISABLE_THP_EXCEPT_ADVISED))
 #define MMF_OOM_REAP_QUEUED	25	/* mm was queued for oom_reaper */
 #define MMF_MULTIPROCESS	26	/* mm is shared between processes */
 /*
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 43dec6eed559..9c1d6e49b8a9 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -177,7 +177,17 @@ struct prctl_mm_map {
 
 #define PR_GET_TID_ADDRESS	40
 
+/*
+ * Flags for PR_SET_THP_DISABLE are only applicable when disabling. Bit 0
+ * is reserved, so PR_GET_THP_DISABLE can return "1 | flags", to effectively
+ * return "1" when no flags were specified for PR_SET_THP_DISABLE.
+ */
 #define PR_SET_THP_DISABLE	41
+/*
+ * Don't disable THPs when explicitly advised (e.g., MADV_HUGEPAGE /
+ * VM_HUGEPAGE).
+ */
+# define PR_THP_DISABLE_EXCEPT_ADVISED	(1 << 1)
 #define PR_GET_THP_DISABLE	42
 
 /*
diff --git a/kernel/sys.c b/kernel/sys.c
index b153fb345ada..b87d0acaab0b 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2423,6 +2423,50 @@ static int prctl_get_auxv(void __user *addr, unsigned long len)
 	return sizeof(mm->saved_auxv);
 }
 
+static int prctl_get_thp_disable(unsigned long arg2, unsigned long arg3,
+				 unsigned long arg4, unsigned long arg5)
+{
+	unsigned long *mm_flags = &current->mm->flags;
+
+	if (arg2 || arg3 || arg4 || arg5)
+		return -EINVAL;
+
+	if (test_bit(MMF_DISABLE_THP_COMPLETELY, mm_flags))
+		return 1;
+	else if (test_bit(MMF_DISABLE_THP_EXCEPT_ADVISED, mm_flags))
+		return 1 | PR_THP_DISABLE_EXCEPT_ADVISED;
+	return 0;
+}
+
+static int prctl_set_thp_disable(bool thp_disable, unsigned long flags,
+				 unsigned long arg4, unsigned long arg5)
+{
+	unsigned long *mm_flags = &current->mm->flags;
+
+	if (arg4 || arg5)
+		return -EINVAL;
+
+	/* Flags are only allowed when disabling. */
+	if ((!thp_disable && flags) || (flags & ~PR_THP_DISABLE_EXCEPT_ADVISED))
+		return -EINVAL;
+	if (mmap_write_lock_killable(current->mm))
+		return -EINTR;
+	if (thp_disable) {
+		if (flags & PR_THP_DISABLE_EXCEPT_ADVISED) {
+			clear_bit(MMF_DISABLE_THP_COMPLETELY, mm_flags);
+			set_bit(MMF_DISABLE_THP_EXCEPT_ADVISED, mm_flags);
+		} else {
+			set_bit(MMF_DISABLE_THP_COMPLETELY, mm_flags);
+			clear_bit(MMF_DISABLE_THP_EXCEPT_ADVISED, mm_flags);
+		}
+	} else {
+		clear_bit(MMF_DISABLE_THP_COMPLETELY, mm_flags);
+		clear_bit(MMF_DISABLE_THP_EXCEPT_ADVISED, mm_flags);
+	}
+	mmap_write_unlock(current->mm);
+	return 0;
+}
+
 SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		unsigned long, arg4, unsigned long, arg5)
 {
@@ -2596,20 +2640,10 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			return -EINVAL;
 		return task_no_new_privs(current) ? 1 : 0;
 	case PR_GET_THP_DISABLE:
-		if (arg2 || arg3 || arg4 || arg5)
-			return -EINVAL;
-		error = !!test_bit(MMF_DISABLE_THP, &me->mm->flags);
+		error = prctl_get_thp_disable(arg2, arg3, arg4, arg5);
 		break;
 	case PR_SET_THP_DISABLE:
-		if (arg3 || arg4 || arg5)
-			return -EINVAL;
-		if (mmap_write_lock_killable(me->mm))
-			return -EINTR;
-		if (arg2)
-			set_bit(MMF_DISABLE_THP, &me->mm->flags);
-		else
-			clear_bit(MMF_DISABLE_THP, &me->mm->flags);
-		mmap_write_unlock(me->mm);
+		error = prctl_set_thp_disable(arg2, arg3, arg4, arg5);
 		break;
 	case PR_MPX_ENABLE_MANAGEMENT:
 	case PR_MPX_DISABLE_MANAGEMENT:
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1ff0c7dd2be4..2c9008246785 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -410,7 +410,7 @@ static inline int hpage_collapse_test_exit(struct mm_struct *mm)
 static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm)
 {
 	return hpage_collapse_test_exit(mm) ||
-	       test_bit(MMF_DISABLE_THP, &mm->flags);
+	       test_bit(MMF_DISABLE_THP_COMPLETELY, &mm->flags);
 }
 
 static bool hugepage_pmd_enabled(void)
-- 
2.47.3


