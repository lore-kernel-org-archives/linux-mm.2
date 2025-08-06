Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34B2FC87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 15:59:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A62058E0006; Wed,  6 Aug 2025 11:59:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A393D8E0003; Wed,  6 Aug 2025 11:59:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 975D98E0006; Wed,  6 Aug 2025 11:59:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 881AD8E0003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 11:59:11 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 170A9BAED9
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:59:11 +0000 (UTC)
X-FDA: 83746791702.15.FE65F7A
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf15.hostedemail.com (Postfix) with ESMTP id 56826A0013
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:59:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UPHj9FtM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3zHuTaAYKCF0NPM9I6BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--surenb.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3zHuTaAYKCF0NPM9I6BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754495949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zAHdeKYizePAgk53VMIm61MpWp5aV7NGmFxaAW2qcsU=;
	b=DaJ69aXDGrqScK0zifzgDplpWpOw5s2jj3ONTNG0XglgsSv9ibmi0pjVtVkz1+pil3+yH9
	Ppi/K56tsvWAWv//Yzk862x5LcXsZiRA611WMTjYzkYDinV+aoxq9nJa4oXNyoVtDpcduZ
	v+Mew2LECZ+i8USLWpEBAo3b6/Imh+4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754495949; a=rsa-sha256;
	cv=none;
	b=WlNbSMyqDn924vIDxERNhcCzQylZ7tU9O4Bg/QHUtuESiVywP0GFT3o026+oWptpZ9oC+4
	wB+oJQK8pj6dO3G+xsz+XO9Efr90skZKwdzLyRF5CoJLAOCmg+yERhdokOExsbZC20YYkr
	ZhyWuc01Yh2C2Iqghx59GCQ+F6sbyBg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UPHj9FtM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3zHuTaAYKCF0NPM9I6BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--surenb.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3zHuTaAYKCF0NPM9I6BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--surenb.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2403c86ff97so80687045ad.1
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 08:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754495948; x=1755100748; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zAHdeKYizePAgk53VMIm61MpWp5aV7NGmFxaAW2qcsU=;
        b=UPHj9FtMNd72PUVel3kYnJhXeCyiY32S6bY2ahk0WIg/V/ygTBbxKOK0wXR3z7ee+m
         cxel2SpgO/8mmLhLz5hd0wbzYEjJ8RC8SdGxm/8qAY6CiWZZ7QJC/rIgxx9tyB3AkCyp
         +SC0WrRO/hJjDq1dB4z4LF7QF9/5DMs1ZuCso6cJakSpwYDEqJfV5erOsbMAFQYJlhHf
         y08M7V3ORvidxZmxUKvWfv4kbpEgE90bmqu5VoIfzCeKoy8msTC0MDOrg9/iXrcTpAhp
         BsclLG9lLExOkx7QSP0lvhgfEobofFgHM9k3GXM99HHBTbv1YeolTvScfTQ5jRxwiyTh
         xJ2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754495948; x=1755100748;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zAHdeKYizePAgk53VMIm61MpWp5aV7NGmFxaAW2qcsU=;
        b=j4YoP8YZufIW5owYXmtt3FG4y4SzQsWqLxMfSg/pe8fKV0uvAtwSezkLJIpxVjDngW
         UQWiHM40TSGhE4mOl7D2RTlI2Zf5ahDFMNVKxjloa1OhY+dBKU/C4czDpLdaVU5h462r
         0uegZZpWmxKDy6sOmAMVDWOsmiG7R+xa+AemSpO6KcyepsxJLWjpwnmiQWeKGCQWTfCj
         Qq9ny0CsNligx7gfZYR2xXQe4T4CmKxqIOtz/o9FXjrhBmWLcH3vdZ52WehlVwpsMCoH
         CwdSdNwaVS03EuXmuZNWrLBzpvHhW983gwB+/rx9dPxVkRcKkw3k8m3SoMwIhLTN+9m6
         zZqw==
X-Forwarded-Encrypted: i=1; AJvYcCXXGSYife3kEcrqc9JeCO1BWTbKRl1NvAxq5PKhS6+YoU08psU0GNvyjZZri6YdDLhutt4TXpMKlA==@kvack.org
X-Gm-Message-State: AOJu0Yx/0lopDerBV/W8cQG2JkFgSqtZW/L7KiJw4YFVBclx/84/nKMk
	KyaAM6ceH1wQRMerAei4isyAJ7jS4vWPgflYfnm6ZWrftlYSvnzk70C7nZfKEy+GsyWZhYVbpSG
	v77EQiQ==
X-Google-Smtp-Source: AGHT+IEoRLZr8fswQu/g25yORXPM7roxpFOr4Rm1EYCkeCXzeC1BTvV4Tg3ArHbfD7/3gKCei8+KcI8zLGk=
X-Received: from plbkz11.prod.google.com ([2002:a17:902:f9cb:b0:240:3c17:a5de])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:350b:b0:240:5549:7094
 with SMTP id d9443c01a7336-242a0ac2da9mr39592665ad.18.1754495948156; Wed, 06
 Aug 2025 08:59:08 -0700 (PDT)
Date: Wed,  6 Aug 2025 08:59:01 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806155905.824388-1-surenb@google.com>
Subject: [PATCH v3 0/3] execute PROCMAP_QUERY ioctl under per-vma lock
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, david@redhat.com, 
	vbabka@suse.cz, peterx@redhat.com, jannh@google.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, paulmck@kernel.org, shuah@kernel.org, adobriyan@gmail.com, 
	brauner@kernel.org, josef@toxicpanda.com, yebin10@huawei.com, 
	linux@weissschuh.net, willy@infradead.org, osalvador@suse.de, 
	andrii@kernel.org, ryan.roberts@arm.com, christophe.leroy@csgroup.eu, 
	tjmercier@google.com, kaleshsingh@google.com, aha310510@gmail.com, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 56826A0013
X-Stat-Signature: bpwa9kg1ysexxcq841ox6nijue989g7m
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754495949-203579
X-HE-Meta: U2FsdGVkX18jncL1phX7mjbhyGN4HPptQ8ekEnpo9Xodx3sNNMjfY2L6CqSo+dziysKeum+/d32UjuX3n6LH0xCuqiT7yw4gPLBwqsJZCk0i5YM89iwJln0ubBJuRdmyO2WBEDrjbVPwdOWHmAkLr6tpxZ3oH3nblYP1X5yKXqBCVrugs9yLHSAUHp++oKRoXFazi48vyOEtQRyVTwDyf9w7zAgFOKoXQMvsCIKUIl9m+sAPLLx0kZWCKwLYqhH+cZSic3Oc92FrsZ+UxzUf274k80xl8+Fs9qsTwJ5iPq2/qItNbpW+vf1gX8Bq40+gQmXXbkJ/my7stk4OBWUI7+9gUvuZkBhsZnDDYSYD4A2FPvc40zjv50Mv4cwj8Lq+wE64tB4ZK14I42nj+gKDPTlwUhkLiLB3+S8dmkvUFwgpSUrmVDIz0n6rMfXRqAGJNuSWaoc8faPSDBfRMvYpEUPInW6xA8mmuVpSEVP2wkkOxSY6TR5Fob6uN0P5L+v8lpEXbSGpepi8YxQ2BJGnajQ/IN9/zOjRVaHuP5eTwBOGt1xl/hFtDohUh730sWRD7YTJnnYXNDyytnDDfIdp3Cvi5sl8g2p+wGFBe0udGWTeCw47wAw25GPJ8l1Enr8vBlQZfRE/kMlk5/7Ml+rsoCI0i8uLum5HcDcTAzkUCrtUiBh8x3PXJtebczghgwfZuIi4dbubFkZ5Z5eO4B2TReWs+I8AAWmtRgi3fZcZqaaJwVxreX/aAl50JZ3hffIZBwoIWXfFYWOU+3iPka+LWzvvvgnwG5gn0nM4gMicXyvKgBIPLl5NwGrNLQdSseQQwq6X2e+HAoPL+kbWWcjerrk+Y13op5w8X0m+DCGSWiWOlyU6lDzfC/aUNjIdbtxZTT0OxN9tRt9DHsQTi0elCSe4i+BfhARkbsuVLlB5fXMbBVrLe56ZBkLO2Y1zcacaHrZTJ5WbTbzhkDpVgvB
 xqbHPxGf
 izUVOAcvpTcZrgGdlcnAap9I29e8PV5Wmn8pb8PmahhvAOyHdF4psCTdjjg2cxx+SvynAtgUWxQ+4w0f3ugbcISLoyjCho8R9YP5IkvcxqqG6JmfFha5md+NBc/VXSbs4jjVPy0po4eVzrqfvC0IEcPd2ZuRIw3xKuO1SBSAW4KSeABfdugNpyKxUTi7t01nY+Mt/egn5zjO5KX08upU68W+rAIW625xTQYIfaduuWOZrWe61hotmXjtEenf6b2yH5pSuQ5PQopxrtuaoakCj+OlXkRAEUpr4B4b9Z60iv7/NHg1xzLfk692JOO+P8L4RBcycEje+q9brNqfIj5mgb7oBN+xsCxuRbOhCR+7oZyLeg1/6+ht5lCzmPtBkR8gouICD8zHVE0u4TpqoqVcmf/6ewXEVwFUNU4p2IjhMPvdL15lyuUmcw8fMoa8tf0PnuRaB7cJecLpEQvVkDp1Q5ivi7Z22aLp64BppWdNaInALk+8pd4Z95Bpr2WgriGEQHtk3AIxUSzNv/Hx8PFN3qFFARaU7yyvVziuPXL8Y1GHDIzIzu3sboKkrPF/qT053Z4Oplij44Cn04KMMYYXFS23tkKs2feEya7cNjV3PaJeFZNA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With /proc/pid/maps now being read under per-vma lock protection we can
reuse parts of that code to execute PROCMAP_QUERY ioctl also without
taking mmap_lock. The change is designed to reduce mmap_lock contention
and prevent PROCMAP_QUERY ioctl calls from blocking address space updates.

This patchset was split out of the original patchset [1] that introduced
per-vma lock usage for /proc/pid/maps reading. It contains PROCMAP_QUERY
tests, code refactoring patch to simplify the main change and the actual
transition to per-vma lock.

Changes since v2 [2]
- Added Reviewed-by, per Vlastimil Babka
- Fixed query_vma_find_by_addr() to handle lock_ctx->mmap_locked case,
per Vlastimil Babka

[1] https://lore.kernel.org/all/20250704060727.724817-1-surenb@google.com/
[2] https://lore.kernel.org/all/20250804231552.1217132-1-surenb@google.com/

Suren Baghdasaryan (3):
  selftests/proc: test PROCMAP_QUERY ioctl while vma is concurrently
    modified
  fs/proc/task_mmu: factor out proc_maps_private fields used by
    PROCMAP_QUERY
  fs/proc/task_mmu: execute PROCMAP_QUERY ioctl under per-vma locks

 fs/proc/internal.h                            |  15 +-
 fs/proc/task_mmu.c                            | 152 ++++++++++++------
 fs/proc/task_nommu.c                          |  14 +-
 tools/testing/selftests/proc/proc-maps-race.c |  65 ++++++++
 4 files changed, 184 insertions(+), 62 deletions(-)


base-commit: 8e7e0c6d09502e44aa7a8fce0821e042a6ec03d1
-- 
2.50.1.565.gc32cd1483b-goog


