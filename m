Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADE54CA0EE9
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 13:56:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A6048E01F6; Fri, 15 Aug 2025 09:56:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E1708E0003; Fri, 15 Aug 2025 09:56:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AA418E01F6; Fri, 15 Aug 2025 09:56:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 136AD8E0003
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:56:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D88821A0170
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:55:59 +0000 (UTC)
X-FDA: 83779140438.24.BCBF577
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id E8C5540005
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:55:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ae7odF0l;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755266158; a=rsa-sha256;
	cv=none;
	b=AU699MjEV4RvVYfLp00f0gSBlUB4HYurR6iox6JSzIbwgIGJCwTiqXzsrtCZ9ezal55Mp5
	XlxWY/EnG0jRqq7hm+GuZjo/LGZm90LzTCB+UTBIfOewG8W6ue2lx/gQ5H6C98cHrsAG4t
	fLqIsJ+O1hsagpVEcQqPJK52N+c0v/0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ae7odF0l;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755266158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MFkut+jxkX2kCL0o1G+AwY8Knubz8aROAdKPd/K2Kek=;
	b=H7dBJfL7I6+cwKr/xB5fSNjHdPzd0LKoHHtCXzAczUBXyJKpex8hYfwXVBlpbQmwNvfbAs
	qi4SMm5E19YkBk8vEnqQju4IFbJFOX6VE+PU8syczm3lpQEhE056NIrj7kkyWFYVNPG455
	8swflBYtJirVE6tTzs76vihgRMuJUm4=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4b109c63e84so21530431cf.3
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 06:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755266157; x=1755870957; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MFkut+jxkX2kCL0o1G+AwY8Knubz8aROAdKPd/K2Kek=;
        b=ae7odF0lJp6c6tn6KFWtIvfo5msoOiqWJS45dmLbF891IwiMK2AczZOK8MQsocW/Ha
         ugA9B1zbrHT1m0W9ARidscg/4XPGANEJWRTw3V+BM4rAsUYeTNQUI4YnTGffaWaDJ77t
         nlIJm05heGMq9hD4S2Guru3+JWG5Wkz3EdHOTlq9sZi2NAZPfhLPKgHJZ+iDr/yeFm4a
         d+JiWp3bJz/VOAhhdWpoIfZycaeiZaOFSol+miZRkCopStIYK+TUXaIt4/jp7w7hSbkM
         4xAE+YWG+CsK5a1iJ5/xoEibRiFV7cVukhWSATHDDJANdRwfG2wbYYyPT8C9WnEkB/uF
         P9Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755266157; x=1755870957;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MFkut+jxkX2kCL0o1G+AwY8Knubz8aROAdKPd/K2Kek=;
        b=fkzbqF14wmdh5Wd3+eK9rVnEJ1H6S9YIpcyDKgHfD/g7vq/RKXfOuKJPe4rzT4k4jx
         UKPh01/m92lPe27cYdpz9TmFpiFIWwbpbCXDPO3GexRfzzJhxYeDHsEdoBYpHjPvaASu
         mPuw5mEd9sR2w3akNDXMdqGKiEPYhpY1Hw9JwXU8394c8VuSrsX21koq7luIYjzdTuyu
         mkXVlSpdKGMDZPhr23f3tSSr3jM7VrOPju4B/V6Ly56LMazYQ+eAklWmkJNJYubF3Ukt
         GbwXz8pA4fFsGNMFg7KA65TlFzj2rKaDZ+T4RdG3fr8HDfwJrSigsQywz5NawFDfJ1bG
         fdPg==
X-Forwarded-Encrypted: i=1; AJvYcCXf7djGCfaSch2DgxYbqeylAYlrPZyNgufJOX6/U54H8ovFvZvBmRsSS8RTU8jYGGwKej8bYFBerQ==@kvack.org
X-Gm-Message-State: AOJu0Yxb4JWCrsU2QwJSsOAWvXyyUGxf+jEnp5oA9ZcyS1xyChUgphsW
	vQJH8GHZ6JS2k5Z/xqQjlxLt2c+/TNbYBC6hOw1kIIS91Kj/9s2FFmWx
X-Gm-Gg: ASbGncuJbZWwl+Ulh4rj6DWYOilY0uCAqnfjqZPAJMocHZgHJxLgeS5+ImNXHiSZfJs
	qc3Trfb2vLQ00Xh11UJwSgL4ddH4G8/CQPm1sO4jqCyouxkwk5IKxhccxB1Gvvw1gfLliNkV05A
	u+6r/zvmFvJNAa+fDWUaP5Upoje2Y8VDyfUjVPJ/6Q9mwSqGF1IIxMMa/JUwss7NSoxvr52BQCN
	+d0IqGj+/d+T/t6SRGX2GEQeOKJhN6Eu1XMw7/MsOHJveVaV29cE2j2Z8j0DJS08N0l/rGDR4md
	JfLnscVymGGPqGG/xP7NSmD6BlOTbvFjvO6O+zOuxkMUzyV+9Cp7kazi/u9DKWeMlyh7iPvlv9b
	rniIO0aWgj6VYvGzeBKvHFKeTD6Cgxw==
X-Google-Smtp-Source: AGHT+IGLy69e4IdVsbA189ZVbc6fQsA9PMvQiTjGOo5VRMpt/EUuAyATZ4S2zwc6xkvFgSRT+eDxfw==
X-Received: by 2002:a05:622a:1e95:b0:4b0:77d7:c8b4 with SMTP id d75a77b69052e-4b11e0b9c29mr26892461cf.14.1755266156802;
        Fri, 15 Aug 2025 06:55:56 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:4::])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b11dddb0e9sm9442771cf.32.2025.08.15.06.55.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 06:55:56 -0700 (PDT)
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
	Usama Arif <usamaarif642@gmail.com>
Subject: [PATCH v5 1/7] prctl: extend PR_SET_THP_DISABLE to optionally exclude VM_HUGEPAGE
Date: Fri, 15 Aug 2025 14:54:53 +0100
Message-ID: <20250815135549.130506-2-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250815135549.130506-1-usamaarif642@gmail.com>
References: <20250815135549.130506-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: E8C5540005
X-Stat-Signature: uqzxaq3u39drmctj7bhke13fmx15uxtr
X-HE-Tag: 1755266157-731277
X-HE-Meta: U2FsdGVkX1+mhY2qOLOVN+KJsyf14Qw/qHaWUm0LPK3ZKteWUpr8yT8lwgyoy9gjFBrlD32YCrk++6qcEOch29cCdjsoF/RAdwEjYtFE92fyru/zolqAPV0960vt8pIQfk0Ze2PL7rbNp6AoZFzrskYsstYfp+KzM0joqUOzrOhKDemNeGFzHzNxmAF49/dul2EKukCtfaCLOUautiyiBq8OoM/Gm2tD52jTfBUpJu2yyzB9vD/3U8faUTOq9PV61R1nnBJ2SciNOQUJ/WYurAe1TeygcZG9UzixFjR8gitcRa3WLjYI7o6Hr89LSli4v8TKcU6gbRi6RVyXndW6bqBUzMrHk7NNHOn9alAsGBUsKqy2pqZctqo3lbSEmtL7bgT8jagEfgjQPMnzfsSILWUx05dgsO1p9ohkRzR+P6O8HINueFgm5uQrSPbXa+pIjhW8+nQTdCuTRHNFq8mQzeVFS3eMf+3rJjwRQEpVehN5RyDgOjWCBpaGIJUwpQsEacrCgnpX5EJbI2Yjr2qam+S3y46rZdDoTm2uwDOQNB2xVFmYGrZBGVvDZMblC2ODfLJDsk9KF6ZqBnl6D3Fb4BH2+0uJpwRPAd8NVv3bccVbXZI7TyHP4jIpKED6QpcjgsiZ2J1P3icu6p/i7JdrTGg4f5W2wWBZmiCGLvt/9Y/ekFTg1mvp3eZTGyvdj6N9XQ14Fx+/TJ4niu3lNQyQW+CcBQBdhhrue3nQT76kmTwN2bZf1GnVrx9KM65jytRFKK9RzctjWHVNzPF8cUdYlPBHjG57ppCzgyG5g0FwouKy040ykq600K04JX2dvtAhCodMRFniILoiTfue+67WqgtsbJJ6AM/3scvtPqBpV8UjcumuAuMldhIwW+42H84oKLXVHwzO8r/7PIeUfHZHalsZ6KB18XMZWK7fSmpYXOp5F0gIN9ZbVqpJSaLFr9bBlqCRMadmsNoectjQzvz
 lmHEOngC
 NEBior1wj7w+CzVrBdy0vV3sTnfreVewmvZ00vPQQFN0XoMj+eI1MaZ+OPjOYil+6EL7kLdlHuc4PVuWzDTdEd/3FG0LamNkEFVIyvjbbeWhulxLVHBsBYLDGjdItUeGbnsLif4wvl4sbC3DiPd3KR+AqgDsgIj+7ndfZhS7cFrilogL9KP5Fq6z1Snw1dhHNoWzd7+ethwdhrVJHTAw0QUFeCUV0gonhsqBmni9c+kivSdvjpjn7EuRM+twZlZqUBYqzrz+P32VHnLZdGnGNrVAcGwd/LhHhNekhyzGy7TdQW/FEkC0gApnoBytVyJtVsniIRY6Ni5Tc5a+byBw3YAhXAS+4pxVf7/mJlPaWeE9BpS5rWtwAZ2Lhf/mJQ/lcFfoLi2OLLOszlEc/rWY+NoKHtSk2DNXEfxx+yB1kpixk1ovkEaHEt8WrmQXRIpS/KDSTUoZ0SOJ6cwgCSdRZG2o54FGOKq9hKX1mUkpZnWeVYgI/xS5cEmWt4sypLt+7AiPg/pc1hoOgMUX3SxG/mj4zJKOPxobNjotfb1XCGRKMRiKROL5uVVo+aCVp/pO/FN9vhR14tIz+cevh4Y5y2Pl7ilNM0SNzypYbx4O+dRkWiB49tlfL2xbX2Ck0WWm05LXBVom3M/qvwXItEfEfkq44CZBN9ZvTBuOjGxJre+OXhxU=
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
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Acked-by: Zi Yan <ziy@nvidia.com>
---
 Documentation/filesystems/proc.rst |  5 ++-
 fs/proc/array.c                    |  2 +-
 include/linux/huge_mm.h            | 20 +++++++---
 include/linux/mm_types.h           | 14 +++----
 include/uapi/linux/prctl.h         | 10 +++++
 kernel/sys.c                       | 59 ++++++++++++++++++++++++------
 mm/khugepaged.c                    |  2 +-
 7 files changed, 83 insertions(+), 29 deletions(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index 2971551b72353..915a3e44bc120 100644
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
index c286dc12325ed..d84b291dd1ed8 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -422,7 +422,7 @@ static inline void task_thp_status(struct seq_file *m, struct mm_struct *mm)
 	bool thp_enabled = IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE);
 
 	if (thp_enabled)
-		thp_enabled = !mm_flags_test(MMF_DISABLE_THP, mm);
+		thp_enabled = !mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
 	seq_printf(m, "THP_enabled:\t%d\n", thp_enabled);
 }
 
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 84b7eebe0d685..22b8b067b295e 100644
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
+	if (mm_flags_test(MMF_DISABLE_THP_COMPLETELY, vma->vm_mm))
+		return true;
 	/*
-	 * Explicitly disabled through madvise or prctl, or some
-	 * architectures may disable THP for some mappings, for
-	 * example, s390 kvm.
+	 * Are THPs disabled only for VMAs where we didn't get an explicit
+	 * advise to use them?
 	 */
-	return (vm_flags & VM_NOHUGEPAGE) ||
-	       mm_flags_test(MMF_DISABLE_THP, vma->vm_mm);
+	if (vm_flags & VM_HUGEPAGE)
+		return false;
+	return mm_flags_test(MMF_DISABLE_THP_EXCEPT_ADVISED, vma->vm_mm);
 }
 
 static inline bool thp_disabled_by_hw(void)
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 47d2e4598acd6..3b369dfbbedd6 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1781,19 +1781,17 @@ enum {
 #define MMF_VM_MERGEABLE	16	/* KSM may merge identical pages */
 #define MMF_VM_HUGEPAGE		17	/* set when mm is available for khugepaged */
 
-/*
- * This one-shot flag is dropped due to necessity of changing exe once again
- * on NFS restore
- */
-//#define MMF_EXE_FILE_CHANGED	18	/* see prctl_set_mm_exe_file() */
+#define MMF_HUGE_ZERO_FOLIO	18      /* mm has ever used the global huge zero folio */
 
 #define MMF_HAS_UPROBES		19	/* has uprobes */
 #define MMF_RECALC_UPROBES	20	/* MMF_HAS_UPROBES can be wrong */
 #define MMF_OOM_SKIP		21	/* mm is of no interest for the OOM killer */
 #define MMF_UNSTABLE		22	/* mm is unstable for copy_from_user */
-#define MMF_HUGE_ZERO_FOLIO	23      /* mm has ever used the global huge zero folio */
-#define MMF_DISABLE_THP		24	/* disable THP for all VMAs */
-#define MMF_DISABLE_THP_MASK	_BITUL(MMF_DISABLE_THP)
+
+#define MMF_DISABLE_THP_EXCEPT_ADVISED	23	/* no THP except when advised (e.g., VM_HUGEPAGE) */
+#define MMF_DISABLE_THP_COMPLETELY	24	/* no THP for all VMAs */
+#define MMF_DISABLE_THP_MASK	(_BITUL(MMF_DISABLE_THP_COMPLETELY) | \
+				 _BITUL(MMF_DISABLE_THP_EXCEPT_ADVISED))
 #define MMF_OOM_REAP_QUEUED	25	/* mm was queued for oom_reaper */
 #define MMF_MULTIPROCESS	26	/* mm is shared between processes */
 /*
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index ed3aed264aeb2..150b6deebfb1e 100644
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
index 605f7fe9a1432..a46d9b75880b8 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2452,6 +2452,51 @@ static int prctl_get_auxv(void __user *addr, unsigned long len)
 	return sizeof(mm->saved_auxv);
 }
 
+static int prctl_get_thp_disable(unsigned long arg2, unsigned long arg3,
+				 unsigned long arg4, unsigned long arg5)
+{
+	struct mm_struct *mm = current->mm;
+
+	if (arg2 || arg3 || arg4 || arg5)
+		return -EINVAL;
+
+	/* If disabled, we return "1 | flags", otherwise 0. */
+	if (mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm))
+		return 1;
+	else if (mm_flags_test(MMF_DISABLE_THP_EXCEPT_ADVISED, mm))
+		return 1 | PR_THP_DISABLE_EXCEPT_ADVISED;
+	return 0;
+}
+
+static int prctl_set_thp_disable(bool thp_disable, unsigned long flags,
+				 unsigned long arg4, unsigned long arg5)
+{
+	struct mm_struct *mm = current->mm;
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
+			mm_flags_clear(MMF_DISABLE_THP_COMPLETELY, mm);
+			mm_flags_set(MMF_DISABLE_THP_EXCEPT_ADVISED, mm);
+		} else {
+			mm_flags_set(MMF_DISABLE_THP_COMPLETELY, mm);
+			mm_flags_clear(MMF_DISABLE_THP_EXCEPT_ADVISED, mm);
+		}
+	} else {
+		mm_flags_clear(MMF_DISABLE_THP_COMPLETELY, mm);
+		mm_flags_clear(MMF_DISABLE_THP_EXCEPT_ADVISED, mm);
+	}
+	mmap_write_unlock(current->mm);
+	return 0;
+}
+
 SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		unsigned long, arg4, unsigned long, arg5)
 {
@@ -2625,20 +2670,10 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			return -EINVAL;
 		return task_no_new_privs(current) ? 1 : 0;
 	case PR_GET_THP_DISABLE:
-		if (arg2 || arg3 || arg4 || arg5)
-			return -EINVAL;
-		error = !!mm_flags_test(MMF_DISABLE_THP, me->mm);
+		error = prctl_get_thp_disable(arg2, arg3, arg4, arg5);
 		break;
 	case PR_SET_THP_DISABLE:
-		if (arg3 || arg4 || arg5)
-			return -EINVAL;
-		if (mmap_write_lock_killable(me->mm))
-			return -EINTR;
-		if (arg2)
-			mm_flags_set(MMF_DISABLE_THP, me->mm);
-		else
-			mm_flags_clear(MMF_DISABLE_THP, me->mm);
-		mmap_write_unlock(me->mm);
+		error = prctl_set_thp_disable(arg2, arg3, arg4, arg5);
 		break;
 	case PR_MPX_ENABLE_MANAGEMENT:
 	case PR_MPX_DISABLE_MANAGEMENT:
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 550eb00116c51..1a416b8659972 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -410,7 +410,7 @@ static inline int hpage_collapse_test_exit(struct mm_struct *mm)
 static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm)
 {
 	return hpage_collapse_test_exit(mm) ||
-		mm_flags_test(MMF_DISABLE_THP, mm);
+		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
 }
 
 static bool hugepage_pmd_enabled(void)
-- 
2.47.3


