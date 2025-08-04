Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93280C87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 15:43:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 363756B00B5; Mon,  4 Aug 2025 11:43:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EC4F6B00B7; Mon,  4 Aug 2025 11:43:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B4D46B00B9; Mon,  4 Aug 2025 11:43:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 00A736B00B5
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 11:43:40 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9A36E1A00C5
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:43:40 +0000 (UTC)
X-FDA: 83739495000.10.173A0FD
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf21.hostedemail.com (Postfix) with ESMTP id B37311C000D
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:43:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hJRqTW9q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754322218; a=rsa-sha256;
	cv=none;
	b=Poh6w9hR2aDfz193ZlreRHkUIrpXpUIF/p7uNTqeUMkNNO+i/+crZ93jbB2K0mCIEFKxgP
	hRmKzDXeY2ZZbkWy3T4BnK9UBNmzxlzcBgolow4IWb/ric2zd4+/OdYTRkD1gip/OIo+/S
	8X6e4FHc5Cj7sXFZBsp/M+YzHupw7CY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hJRqTW9q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754322218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J+C2IODosZScGy+0doONVpJcp9V/juhJoEj+aPvP1R4=;
	b=Pn6dVaTlKKnRcdRWmlmn+El9oStIYL1bggUMHJ1cEtn/N7eqnmKo9z2DRAPHJhoUVlbLcd
	Uib9cY+aEaWFUW6hE3tvV6/7UuYDC+XfvcCPXDhFvyYHDExAYe0r1GJFlev98//WsNWgKt
	lUkCVpVJsObc34aTxDWOIBc57x52rQk=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4b062b6d51aso14855111cf.2
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 08:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754322218; x=1754927018; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J+C2IODosZScGy+0doONVpJcp9V/juhJoEj+aPvP1R4=;
        b=hJRqTW9qy7aDOYFOMOg9dU2bHaZXlHPiRLIki1FotgegP2rgiOvzCBwPbfa8PrvqD4
         A8CFIR1RPQO2kWQsf7VF6vqsxzFurUoI16QeCr/y9FxaPeoMObeN8UGjP0PxQNPooiLr
         5dB3Bc8gi00xaRV/rOeoM3FRljoVTtnmvBB21mrQrU/ZxeoYZYksjsGQW1zykV43UGgo
         weYSIvbFm8uqP2tHsr41qxpCpa67lPzNA9LlJGz9mJMJPy9voqCNRGtxhSWEcw+9s6iJ
         XevehtOTmAll5yaQFkUuSqEiN96AgygoiFVEMe6z9+QYLH652Vy2yD6l28FkmEnrXMOl
         VVXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754322218; x=1754927018;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J+C2IODosZScGy+0doONVpJcp9V/juhJoEj+aPvP1R4=;
        b=CAJZ+o/nnG2Zo1WCWN/FJlUUv6mOk+m66BGCo/aL+2T7cybpXZsOUA4Eq2tr7m3lqf
         h9DDHrcWU6pFkFdJG/tXAM0qKSlXjGmeCaaZYihGXuCO/+L0DOT/sxCa+RY07oJqWntP
         p2eTMbLlnSQDkMfrsZFBpOH7Dn+AW8mYij5VyWgyRMLepBe4a5otZs04xaUuFT65DWHY
         tWkTp1+Q1W6Wzj//ZniT8D8A6gisL/bOFQY/A4YzctW4kUEeF0mIPgkYNWajuoL8co/5
         FxhwF+bRxrVTwqxcRxH/TazDJMD4AH36WK5VyKOvjSiZfVwrgS7I0lf983VG+YtSSbVf
         5mKg==
X-Forwarded-Encrypted: i=1; AJvYcCV4lvxLuZnC5SdCIC786r1qz/K2pN+Y8+PmOA9avJN/6F1vlv+0E8ZydwQUxWjAtAoEKBoSBcH1NQ==@kvack.org
X-Gm-Message-State: AOJu0YwSS9oiHIv78gEuJ7uQGIkr4kfxf9DvTmRgfHl5xCX/z8JDBewD
	201FBhpali/4flxUW5AKp9jpJe0z6MSC6KFaiAYn5SlUA1VIOuXgVWOP0LoiXcmZ
X-Gm-Gg: ASbGncu3aolMSjtiz1WKT0GSkQEu4jE9mzgLeaQITNOadUxyYbcAaQ/itVE4QQtEbDR
	810ES8i0O0Dl21QAAeI/28vvII/p65xvl1awep25VKiGj9PkwARyUkZ3hc6WzbQSA7/1QECDmAw
	2YaEJaY/jzGvw+y/kvtcaaxmz23sd3jY1/FhTodG7zBOQeikzGXsBrdJwyBhayjpd5udKxyGE1q
	WCO8CgG3W7JJzu8lcHOGnd1SIBavwBTSyGtd80YZQ/UnV5uNDZIzp4xJIZjuS6tRXaU4WO5kLKu
	UcwSi1vZLMhGh/knx6eAFm//Z1Il03weR0o1x7qtg/p/LEJj1RDHDd2Tfman7CwhR9DiWv/3GH5
	WLD2UEdei2R9gDxk3Uyc=
X-Google-Smtp-Source: AGHT+IEWW7x74o0jlBxrSdpb3OsZc/AudWmYTuZYvvkT42ttIIvkCt5c0qYYcTXY1QVVDTvZSvHgnA==
X-Received: by 2002:a05:622a:229f:b0:4b0:77d4:ec1e with SMTP id d75a77b69052e-4b077d4eee9mr26092401cf.3.1754322217552;
        Mon, 04 Aug 2025 08:43:37 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:1::])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4aeeed67051sm53874291cf.35.2025.08.04.08.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 08:43:36 -0700 (PDT)
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
Subject: [PATCH v3 1/6] prctl: extend PR_SET_THP_DISABLE to optionally exclude VM_HUGEPAGE
Date: Mon,  4 Aug 2025 16:40:44 +0100
Message-ID: <20250804154317.1648084-2-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250804154317.1648084-1-usamaarif642@gmail.com>
References: <20250804154317.1648084-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nf8r1mjan4u9wqjsn95suykxuw1nwic7
X-Rspam-User: 
X-Rspamd-Queue-Id: B37311C000D
X-Rspamd-Server: rspam02
X-HE-Tag: 1754322218-67797
X-HE-Meta: U2FsdGVkX19/zQr+j7ZIVFeWA+kGEmIq3zWDxRBCVFC+22kElQlCDJUaxsH8jzUqqig/sTwg/E2k0xQy45nNrZd5Sqd5+u2gLx53rdSRpBnWVLaBh0UC9Cj2Yzz8UiqWNJ2gWEUKOYI1yCJcElxt9yjgIwbr/lma8uJWlMzCZdfl0P2w2wHUrfyVwBUAxpnic7p0atUoSuLVZCqT5cbMCICBKmXoYnkosOUBbsvFlfbRhy493lXB7qqzqd/ZgsZ9wJjMBq4EsjMWqaofKPPf0nOge0W6nnSIN6M/aLHjiaEMiI7kE9TS6T/0f69/N26nvNuuh+p2M/P4Qze53KhO/zqpilbTBhM+/iN4re19aSR3IG3v7SScHPik2YnYh87OBQElibsX5Wjxb/Xi5nakxuJzKx5TkANm7n/U6RR/foDWpIDtHogo0+G5YAKnM5u6w5mxZ57MQxM0vfufVGgPTGPJWaM+IzZkdrUCWc1598SjFBr2p84xPHuhY6J6Ecxgpie8T7FghFJfAzumKS2OKIzmJWDDGidsyhIl3EJCpnv25oTIos5KtknZR7krwMkvlUp/7mEA7sfGvnwaR3G6JECjrElN1t553MIoqvgK2i4hshZcm4DRPgIaTWRmwQ3/mklF+xbV7WYhukBKdgPYlY4ZFG5xyGD7263Qoiy6XJxhxw0npu5OlVXVS2ABYxhTBK+LGRjcvxSwxzPfNe39SOrNzPrVd4b4eTATydeD2dZUiPvbyyFSxKlgESiAcCmZG7m1a+AmydZ0DYr+sTfKSPBQFQg4eet6IXKDFYm+zg6ahBxUWP2xiOfnif8vkeSxAtcSp3PRitb51n5eYDZtsfl/jzgXn1PYMXZrJIdFQfwPg/dB6hYDtdf8unNyplK82YCsCKGZVF/PutGtNNrF8qFXVGxGkblXOXmxdt6Lyml2wWiBIyMB4v1ms6U/CJ06YQVcjNwfXullMTz3Bwv
 2kLhYN4M
 L9J2olzIQy+ht1vcOS7K0dN+u8jv1xwZJfpaVCNXbf9/IHNOyEzTqlfOv1TFwBuPfu+obGNonHq0dQQC0Um85NFuXoZ+RZOW+Zu6qlaJjbv0bu1NoFNxoRGbrUMMHj+V4q1ukQLyjnaTh0VSo1jmobm7PRHAjwNw4qOb8GpLN+lLUxdxvmVdSUeePlWeDZ/HFPSJq8bpxcl4WpHHO5RcVIF/1Skr9AJndvLDC6M3yhNUYRlXTAUE1KPtKOulL2b1Iu63uZpcpTNVpYQjydejZNf2Zh5Mrwe9744Lhse5GFhSfKKUYH/RE02vJwDn4BhWp3YG2miZDjH6LTF9xI6iUkDYgUItsbbrwTo3Uq2Q7aT+QNFfNyUmgKNLcSt8G1aSB2JztFVO2yVq6tNV+VPAWGN4HeQV516LThZRGCV7Icv6LRhAdF4zzUBpg86wnBSz1KXiznIxKwRhebQnVvv5RfXhUD9KZQaDvs0qmsQYSYIw6LfaAq4OcPo7DUAlVZEJXOULPG+cA2r8v17Sosekp6IrxKzFTexvHvAp1kHWkyRLMcpUD3FgQs+lvZt+7u3hOpWuSzWq/dpiyoeCoKyrV9JYKJjONISsNI1JGPVgkjuU5EIIwYYhD/Hq44ipvmCbKFCgh8ZJBMzMAoZ4l64AytTYD699cgupGw2XrPqp+oNEJjCg=
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
 include/linux/mm_types.h           | 13 +++----
 include/uapi/linux/prctl.h         | 10 +++++
 kernel/sys.c                       | 59 ++++++++++++++++++++++++------
 mm/khugepaged.c                    |  2 +-
 7 files changed, 82 insertions(+), 29 deletions(-)

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
index b153fb345ada..5b6c80eafff9 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2423,6 +2423,51 @@ static int prctl_get_auxv(void __user *addr, unsigned long len)
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
+	/* If disabled, we return "1 | flags", otherwise 0. */
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
@@ -2596,20 +2641,10 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
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


