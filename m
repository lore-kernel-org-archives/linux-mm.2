Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10492C83F17
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 12:28:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DE278E0003; Thu, 31 Jul 2025 08:28:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9688E8E0001; Thu, 31 Jul 2025 08:28:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E2098E0003; Thu, 31 Jul 2025 08:28:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 69ADC8E0001
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 08:28:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D5900140725
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:28:34 +0000 (UTC)
X-FDA: 83724488148.24.8FDDE0B
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf27.hostedemail.com (Postfix) with ESMTP id DB9214000D
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:28:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cSFNrfLb;
	spf=pass (imf27.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753964912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IE+REDzqvLKoDrvawnxQmNnKD+qsH5pazW//69VuTHA=;
	b=0LD52nq8v34bjgHE4aEpP/c1RrG1uv022rakvfdMBFsGgKfAITASQU+GAqKIT7bl4eHQ09
	BSfoBDAexyUBQK9WJi08LHWxhR9dD+m2dzayG2xMu+5T6MH3SeInW8zyi5Qq/FKWIzU1n1
	bQ0or1mxHZdK6hu0C7K+tNsPedykbM8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cSFNrfLb;
	spf=pass (imf27.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753964912; a=rsa-sha256;
	cv=none;
	b=iWlPvYa7wo0hXBv1jOdD2eQ0Ce2DUiCNcPKwZ8neP2feYuzihvr8oOZbQwyE4Hv5ir+5HF
	oyzhKBN78iHlVbrb40N8Z7VrSPGSr1NlBX2EYsHdH6q3Zp/qJ/aXBrhU/oGu07THV3b4w5
	0SmSD1kn2RVbM02V+ogS2RTtFq2pBio=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-7e346ab52e9so35409985a.2
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 05:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753964912; x=1754569712; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IE+REDzqvLKoDrvawnxQmNnKD+qsH5pazW//69VuTHA=;
        b=cSFNrfLb51GEnkYkLw6Q35cY+ByKEZq3nSLXIsYGOvbY7U0H0f/2bailMGIDTJ7msU
         LsGAuR8sonsbNUPwEGH8dq/lPZL2+9RpDyjHqBnO65w93uajB7Mln6LkFaHetPuDXGJK
         nYxyQ8Vrh54jblG5bji8SxVKOuX755HbL3CMhZf+p7pxVIMnFVRyryx11ef/srmSOTeZ
         ikSsLtwGe4iVeZ98Omd1bDbRHUOtjLwQ/n1HpzWC7Cmu0NoYCNEbzsGPhpgAWpYtpKLc
         cxEJDADjSY/09RtEweiZI5K/ztPo6iMS7DWug+RqRQ/2/70Hd9GT3H25BXCrrbZ8upU2
         jPsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753964912; x=1754569712;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IE+REDzqvLKoDrvawnxQmNnKD+qsH5pazW//69VuTHA=;
        b=aODKSQS91whdDkwU+pVlwTquj22V3ZM5tQqN2AhsHMTC6n1EXQgPOPSoaI0ScPzXqC
         hAnRYRYO7/LVoCX97Ujn/+DbZpPtj6ClwE08mMD5iNVX+zvk3KM7bjyllB1PLTBLJ6z5
         wUik07uy0EKe3xNw+fc2FC5z2VYUiw1Ftwz6anYZ9aC0PDs42rsOqssjIBym1SsHCCUv
         xdN0n642elWkU3P6gfysDXB0i3dzHIJmkLcslS9e7p+kRj4z9Kq6MoQE4KN4Eeix1Qmh
         YQpC/mcnDzL3X5ASmDxhcIpMWJes691ZqzPuAlTn7bTjk8vsdnKL+bDkoA5trYtOytcj
         eFUg==
X-Forwarded-Encrypted: i=1; AJvYcCWWBws1W9Rcekjf/Iifv1XvpeaOsg+MqEob6GlI1XnKsYeZ1rumPxe7opq19o0TWD77uUKOUT2SEw==@kvack.org
X-Gm-Message-State: AOJu0Yx6PWgWPap/sv0Cnp25J+22Yvo5GK6J7/+T/gFQ7MeWqH5J6iou
	K0A7Lo2nGeFTS5pVKpfXRknpSWkb6eQ9jSbNRgyYeFfdp4SoCwiT3Dle
X-Gm-Gg: ASbGncsp7arjHaFWIZdXryEaWQwnjH+J5nw/oXA3X7Us3bc4MLcljrDyfm+H4YWKfwS
	aEgILNf/wTrh8WrDetZnon8ISHIJ6MZEucaI/egRV7AosnPTjTq6i4B326YtDs8ssA0Mutuo/YM
	FiiYANZjjKgUSO7ioPM47974zwLyVeea1NxQJmJlpcu7BZNYg5IaHt57R7rmEVKsfhWs4amz9eV
	4oSmv9UilHOKAFcRgoj+y4cinWYFvo4WppnVGI8dZOJzJXf0pGNvWgrEX4iN7ttkiiq3O0K+2Fr
	HyzsNRJMJu+WWWKEA6SAiqG4Tz6AXpbprNTqW2nQYyl5NPh1jFQrB7j0011VhvvWVQvVhZTtJec
	o6fMlmlZeQtKn907Q3wD7
X-Google-Smtp-Source: AGHT+IH/cBB9x74cpkRu8HPZ/iEfhO8KlkDxbrmTcVNP2rihHZS8nQJ/U5x1SDYWYPt6bAWgldxMyg==
X-Received: by 2002:a05:620a:2846:b0:7e0:6402:bece with SMTP id af79cd13be357-7e66f0143efmr801145585a.38.1753964911599;
        Thu, 31 Jul 2025 05:28:31 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:73::])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e67f598a0asm78995285a.6.2025.07.31.05.28.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 05:28:30 -0700 (PDT)
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
Subject: [PATCH v2 1/5] prctl: extend PR_SET_THP_DISABLE to optionally exclude VM_HUGEPAGE
Date: Thu, 31 Jul 2025 13:27:18 +0100
Message-ID: <20250731122825.2102184-2-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250731122825.2102184-1-usamaarif642@gmail.com>
References: <20250731122825.2102184-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fau5qw9uj4m9b6s5grtk4su5bd5isap6
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DB9214000D
X-Rspam-User: 
X-HE-Tag: 1753964912-742211
X-HE-Meta: U2FsdGVkX18lBjxCllyIROp16vVZ8Y2hejijBW1B5POaH04VaBpfQZCzZoq3njQuPBAylBaEBTogia7HOGXtKWqio4LWsr3N0HY3oEFkWjwYFRh4b78OXBuFuXh8FjV0Sm77g7gvCZok61Qh141+WADL0T8XPek8HckEMAldCwotR8JSb9QOIHcCBm1t1qAjZn2UCtj0tFG57t0+/K/v2V4SG30eRAfDYWiMyP2FjhCK+bRlE8AZtHB81efVNDZVA0Trjr6AA/a1oxFvNo3EV4qJHibagNoCoXfuiBgdVtpMb2f/MuurAdnAxafpPg6Ict4xMT8Z/QYTgCsHklgUm0bI4F9Olab43pF3BieWPxAe90c98y7kYZZbdfQygICb+9oDdoGPjiMIiweICyxBb4wnbk2V0tU3NWhOM8hc9ttm57bbFdBianef4Pa0TAHkW4HMTSU8SkJDN4eFVW7rgNN8czUsddSpfhihpVMvvlt0/ykRzvKG1uy3PJ9ggGxtX7qDQJhjMhcaV3JA2ZNzRSqSP96ur2Hek/zGFmQcfLBG75yzwZQPKOaqadBztKV0rwRFNNwLO5f7wn4brzHS4udTqW6dVwjBSV4Rty60wD1MEcqqK0W6eUHUsaNY84S78RhVT2ydQVqP7rcmusfbCkvydMIHHEcw8zBupYDer5OWjvrVVi7FTovmtYAUsbaTCuFJxkesi+vGGxyI6w2cdCE9evPrJrb6UKYsSLSnt3FEeGJ0RCqGfa07nlpjRX/k7P/deY/ZT2UBKe8jjAxjTjFk/5uqDSJksqesJ4/SNcvhuusAv4duo3VmJsk2Qjh0dkFXZAWAsSiV1pkUTeAvxOCt8JVctvWy2SyM4c7uzKK6ZCDWYyEOVoyGIEcN/Z6F/0Y0LtJG0iVc15jDU2PSdM+SmKEZEoOKzZj7oaFr97vDT9A+1ka3VNIQfQjGXa6qSQe17S3bCPieDpEXoQU
 qxZ16DIa
 +nw8GGqwmFsbwrSVg7FaWjpO3kZqWlW2dED96aIhmsps+nO4P29U1m+Hv//sQSazJXbxN0Y7XtMOIxk01ub/D8C8TeHoNOVEISs6a2f7rAke0rhhz8TOw8mGXrYQ6Qv3nsawsaZzmfwBuo4a4hxzpb5LbJ3yaUH8Nu1ClOkxdjB7TlTPzGA1fwb3tlErlLigonV7E9BMVXAxGfcz0BDJVMC8CV59UdpwQrWos5wIkAK0Yu1Aq2tREkoUD0vWLR4xSg2ktOZ9+KOv4l8BSAm/GP0I876oZNgq9SL6wxqxXDwNTMqkoSe6+idBqwaBNv5GhkzVbb4vKbl7lIUWq8rkcnRnWAzc1gndjluhKQ+sN/SRfz+rIpfuIdTRWXNhbPwa2f0bzWIHlmurpA6GfeHX/bBbltyueX17uNakUYFcUTak0EGf44/ivNP92+m+cU/WkW/yMM+y/skq8Xbc5RP62bdQ0Z3qQlS/A2WxO46fi0XxBNEOo/2nE5RK6xyxZbCOCb7Y+KOup3zpp0vdzVYaZ1VU/mJ/NpgHL9fGUCUkUvOr16SEdtb6M+ygfxpOuTD6xL6tUZve8wYxLMKZtxGS3/vIjc0CPqBOuzPI66QyE4zS6ZkbLFBFF2xSTBe4dXjCGbXAMM8JDTf728AnPkIj/y78gvtL2GY/h2Xjfvd9y6GgVKIjo99QCubh95eejBzVA+etSlb8hJ/qoVfLxyh9lePAJGSkQZbfwX8xErqhrJpPDd1de6AzrYa9M2/X5G+tVKZoalnuHw8JvDEXrPDmgarU6pkujq5hSzMAmOWrIfDwbRAEQr5FOK8ONLvVHOkWM1ktd1mtam1D/JNXPeDLlA8mESjspyoCldj8IoMj5+nX/LZjHfgsmGV1bZhAumayv46DPwIRzrdwkwvoX2mJ1gUzdkM4VWCyJUBa4otPQffwoFEZuwJhO1RIfLh5m5EbBtcsHsw8VmwuDEnD6mRUhu8NNZo0r
 fOWxph1q
 PK6ZOgcT9RMW1YwROZxW1tKBWk+X9Ih3
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
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

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
index b153fb345ada..932a8e637e78 100644
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


