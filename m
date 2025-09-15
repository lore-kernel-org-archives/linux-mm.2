Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5DD3CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 19:52:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E36058E000E; Mon, 15 Sep 2025 15:52:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0CDA8E0001; Mon, 15 Sep 2025 15:52:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4A618E000E; Mon, 15 Sep 2025 15:52:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C37248E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:52:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 70E44BA166
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:52:20 +0000 (UTC)
X-FDA: 83892531240.12.261D8BD
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf03.hostedemail.com (Postfix) with ESMTP id A651B20008
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:52:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4wIq8sxb;
	spf=pass (imf03.hostedemail.com: domain of 3cW7IaAQKCLwhxfniqqing.eqonkpwz-oomxcem.qti@flex--fvdl.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3cW7IaAQKCLwhxfniqqing.eqonkpwz-oomxcem.qti@flex--fvdl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757965938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=MhJHKPv2MqpneSVyivCmQMh/OX2F4LBu0RtU4TyI0z4=;
	b=zwtkLc3W61332R1Vug4cYJptweHF3Ifde1dZ1weKHRL/JSU/U+XfMtKR+rV1sxvClDxrsa
	yfWk3cwvxuIk8dcdY4QkiPDHwZupKJhz2AvYn6DEwnqB7G7JtjacxJYbxVAUIFAJuXIwdW
	mjvJ3qtGaEAPvRxNoCwo6HBaEP2G1aU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757965938; a=rsa-sha256;
	cv=none;
	b=EW0dTTesq5Yar8kQWK3700wZwks9IGMclDykrnbGPFfGluXkplFM+Uh43b3PXINJYuXMuz
	tP+nwMkknukCgq61Cu7GvolLUjQgZB9ZmctgQye27ygaLt/i+Ml3fvpafVQR2crF22Llxv
	XHvs7j5U800xed6D6Tki8faSOwxaNG0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4wIq8sxb;
	spf=pass (imf03.hostedemail.com: domain of 3cW7IaAQKCLwhxfniqqing.eqonkpwz-oomxcem.qti@flex--fvdl.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3cW7IaAQKCLwhxfniqqing.eqonkpwz-oomxcem.qti@flex--fvdl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32e120e0e48so2265864a91.3
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757965937; x=1758570737; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MhJHKPv2MqpneSVyivCmQMh/OX2F4LBu0RtU4TyI0z4=;
        b=4wIq8sxb06Kw8kQB7yi1c7S7g1716r5THF5TTfa8c0IrTHBpEX833rslRjav9mCNIf
         3oIvfaN/lfWjgVDnm4SyEeAeSJdKX0qXaDsDkS6fMrw581IttGUj8RBSxCsmYzPhhz/d
         aCerjQi2GlqQyZZcThFhllx7b44fu9DR1rFO11UhVN5dJQzayBqH578J7yiTG/NLThJ+
         2N1LQ0LBQQtlIwOMnJtWbLi3YRbs18aMeXc0+2vGbY+NQACYjrjB+pDhI8oU5beb/j4F
         VJeouT+rSlBXFtY0ZjnUqRx5j+m5auk/PypRozci+/n/e/jdgihO8fF8a/QrqwSNOG9i
         NZCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757965937; x=1758570737;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MhJHKPv2MqpneSVyivCmQMh/OX2F4LBu0RtU4TyI0z4=;
        b=u3P6KotonN6HsQwIGZpTvLCB82n/6B56Ksskkdvi965av8X9pm2m934NDKaziXUzal
         kG0MGyYQSb+UJ5jqttdVZ3P66tZrShfA6SCts5tEIUbFhJeCy9z0qHuJUwKVnFdpDYuU
         IunX/kbLyU5WuidM9xtiGM5UeCsupcJjzvlw9LDics+utqjLc37TZn+RAnjRUP1qOcRt
         XZjRpoR07qc5ZSbVmxF5jeFcqxBf0YepxmR/ar+jZ8/rqOHeC2fL267BvrlL9/1Gp1XF
         VmSUHDV84idkA9fhM4frylVzVDPtfKZv/TBfaiUjYEpcATkHsBLfNwuYNQfaWWW1ekcd
         G3Bw==
X-Forwarded-Encrypted: i=1; AJvYcCXsSTNSzsiGNEb3rpkdHuvJK55xNOkf8/wdUs7+AM6sqC4EZVEfixy8WhUM6hiWxADNE/MANCV/Ew==@kvack.org
X-Gm-Message-State: AOJu0YyBBA0cHjHozeVSi0PtVzzH7cUVga/V74RonvQu6m2tHEZjy2uh
	9cY7fkl/5eSMj3SMrJ6JP+G0t0gxISQ3EWfjgGcYNS11G7W0RMW/p3zmR8JNS7U9hLX2DPPA3A=
	=
X-Google-Smtp-Source: AGHT+IH443Pb4Fka+zvTA5ISbMaozV02kT9kJzPLosmG6Oq62zqdFEn6rcQHRY5FXaXgRwsk70oLGZtW
X-Received: from pjk14.prod.google.com ([2002:a17:90b:558e:b0:32e:27d9:eda1])
 (user=fvdl job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d0e:b0:32b:dbf1:31b7
 with SMTP id 98e67ed59e1d1-32de4e7e37emr15999610a91.2.1757965937444; Mon, 15
 Sep 2025 12:52:17 -0700 (PDT)
Date: Mon, 15 Sep 2025 19:51:41 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250915195153.462039-1-fvdl@google.com>
Subject: [RFC PATCH 00/12] CMA balancing
From: Frank van der Linden <fvdl@google.com>
To: akpm@linux-foundation.org, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: hannes@cmpxchg.org, david@redhat.com, roman.gushchin@linux.dev, 
	Frank van der Linden <fvdl@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: wphxnioqqo1o6tinjkau3w9o54msjq9x
X-Rspamd-Queue-Id: A651B20008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757965938-764187
X-HE-Meta: U2FsdGVkX196CDt8Bp987Ft0MtiYF33s506uGqabQog4SS7hwxDFM8MhHkKE+GE1TtreIJ22XFk6PiXO44T/MEuiEXOo4FkRrS2M81JaTnkFkA/+JImKEePsjPIeCD/MNMICeGrN/Ozb9k8xDsHtnu0br0CIYNKO07PFFyW5Z+QKqR9fB9cMYM10NTBL2/Cj+FFeohhw3VqmPcaVJOhKYlwn93kFxBSn7vPoP6Djd8o77qLYueKO2g0h7fe/+jSLCJyR/5UcyS/0BGqLcl7ssa0NYI5uSxyqjbS8XQc1pXUx+K2Gmzsk/EKhRnKKkCCs+HFm8y7E2f7BV13Iml1mzrU2yQHQ5VElMqMBTGbu1BZ0XDQN+usI1uePwMli5puBE10XUaTnX/LrTvnhgvCHGied5Nv5MvWouLDIEAM6zfu7Z1uBF3FL7ChLIF/uI8rpiQ2OJwLyQSTX0yPkgrb17onnLvh3G/lfPREM2PX3+uZQ+3EG2EOv01k5dWOim8aYYr7AvvMF7yZ8n8lxQv4kvREGfukI0lrzyt8Gvtu5v/WPg3YpnQEQ9ZxfCU8+P0Lbq2QIwbS3KwtvZ0g/YS8A5D1xWZNn0PScg+v7yXh9W6Uwk7kN5e+vqXInbMAYea8AQlWj9uy4lT70DHs/6TG6W8FWz68yc27uxDPzhI9ubd5LrnQCANSn5xqCa1w49oqa0KCeQPEJUvHCmQOd8MvDt0lEhNoERdvcS7AiZrN1bLh1O95xFIbpYE8VyYA6DuRdbdkaAaf+qtGP94cdb9mhDbCpvXyOEsBfW7f5WfkNKdBB43HOx4tF5UcHBdhYkRDFhzM1txAvPkypTSuZC8DeaMglDfR9HOEKF+9buFqaGdpuwDx0nyvFfqkI0DIVK6Y9SKWJGn+uMTKBvvxlM81mgzf/rlxwn0X4ESMxe/Tlb90Q1CtoORUxBYV5bZQbL3NaIMcox6eyqEpXUvnWSdJ
 nrGOcUFd
 N+oDXbjyjHPfpP9crQfFUfhABAt7johZXSXczQNTiorqzkqFi0gbbldfEdMZ+Wna0EEtgcgR6JmdjLswRcYjot0mSQXszyEFXnjAsBxv6JyO0Xvrq8S1FptSWqvpVIxQntrZ/0cioR2yITMAXKk3bMiwKP3fKKN5CtZr+306jTQCT59W0xyWGjWXREutRDTMVLXE5TKptMJNRCHW/L7TSgwcN7ySINzANjT38ZFWtDlvUX65RlH0ym++BR3nlUT8r2ZVM+BC8y0VcPcGt++ZXnCSaD3u/9SFUj+4FgrAT5RYs3Tt9Un9tKBGS5oqwt4Zy45uApJx373TyUePNgfpWHayfX7RyB44ZQ+IvC9jN65ZRTM/TV0GejskZQyRczUUjHUW/6/nUcsrNvHe6rYfcO3wxVWU78dh6dn7OxwSKqnwpFSA87A/d1S0jHCy/ZQUOwFwwqIEqtt9PygWa33/C0MW1vPC4xkUirlsuYaje9Ud43NDW7dysmD3G7b83FhVgeb9pBYRE9mraSItaOCX5Axe/OMXVqL8vu17M
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an RFC on a solution to the long standing problem of OOMs
occuring when the kernel runs out of space for unmovable allocations
in the face of large amounts of CMA.

Introduction
============

When there is a large amount of CMA (e.g. with hugetlb_cma), it is
possible for the kernel to run out of space to get unmovable
allocations from. This is because it cannot use the CMA area.
If the issue is just that there is a large CMA area, and that
there isn't enough space left, that can be considered a
misconfigured system. However, there is a scenario in which
things could have been dealt with better: if the non-CMA area
also has movable allocations in it, and there are CMA pageblocks
still available.

The current mitigation for this issue is to start using CMA
pageblocks for movable allocations first if the amount of
free CMA pageblocks is more than 50% of the total amount
of free memory in a zone. But that may not always work out,
e.g. the system could easily run in to a scenario where
long-lasting movable allocations are made first, which do
not go to CMA before the 50% mark is reached. When the
non-CMA area fills up, these will get in the way of the
kernel's unmovable allocations, and OOMs might occur.

Even always directing movable allocations to CMA first does
not completely fix the issue. Take a scenario where there
is a large amount of CMA through hugetlb_cma. All of that
CMA has been taken up by 1G hugetlb pages. So, movable allocations
end up in the non-CMA area. Now, the number of hugetlb 
pages in the pool is lowered, so some CMA becomes available.
At the same time, increased system activity leads to more unmovable
allocations. Since the movable allocations are still in the non-CMA
area, these kernel allocations might still fail.


Additionally, CMA areas are allocated at the bottom of the zone.
There has been some discussion on this in the past. Originally,
doing allocations from CMA was deemed something that was best
avoided. The arguments were twofold:

1) cma_alloc needs to be quick and should not have to migrate a
   lot of pages.
2) migration might fail, so the fewer pages it has to migrate
   the better

These arguments are why CMA is avoided (until the 50% limit is hit),
and why CMA areas are allocated at the bottom of a zone. But
compaction migrates memory from the bottom to the top of a zone.
That means that compaction will actually end up migrating movable
allocations out of CMA and in to non-CMA, making the issue of
OOMing for unmovable allocations worse.

Solution: CMA balancing
=======================

First, this patch set makes the 50% threshold configurable, which
is useful in any case. vm.cma_first_limit is the percentage of
free CMA, as part of the total amount of free memory in a zone,
above which CMA will be used first for movable allocations. 0 
is always, 100 is never.

Then, it creates an interface that allows for moving movable
allocations from non-CMA to CMA. CMA areas opt in to taking part
in this through a flag. Also, if the flag is set for a CMA area,
it is allocated at the top of a zone instead of the bottom.

Lastly, the hugetlb_cma code was modified to try to migrate
movable allocations from non-CMA to CMA when a hugetlb CMA
page is freed. Only hugetlb CMA areas opt in to CMA balancing,
behavior for all other CMA areas is unchanged.

Discussion
==========

This approach works when tested with a hugetlb_cma setup
where a large number of 1G pages is active, but the number
is sometimes reduced in exchange for larger non-hugetlb
overhead.

Arguments against this approach:

* It's kind of heavy-handed. Since there is no easy way to
  track the amount of movable allocations residing in non-CMA
  pageblocks, it will likely end up scanning too much memory,
  as it only knows the upper bound.
* It should be more integrated with watermark handling in the
  allocation slow path. Again, this would likely require 
  tracking the number of movable allocations in non-CMA
  pageblocks.

Arguments for this approach:

* Yes, it does more, but the work is restricted to the context
  of a process that decreases the hugetlb pool, and is not
  more work than allocating (e.g. freeing a hugetlb page from
  the pool is now as expensive as allocating a new one).
* hugetlb_cma is really the only situation where you have CMA
  areas large enough to trigger the OOM scenario, so restricting
  it to hugetlb should be good enough.

Comments, thoughts?

Frank van der Linden (12):
  mm/cma: add tunable for CMA fallback limit
  mm/cma: clean up flag handling a bit
  mm/cma: add flags argument to init functions
  mm/cma: keep a global sorted list of CMA ranges
  mm/cma: add helper functions for CMA balancing
  mm/cma: define and act on CMA_BALANCE flag
  mm/compaction: optionally use a different isolate function
  mm/compaction: simplify isolation order checks a bit
  mm/cma: introduce CMA balancing
  mm/hugetlb: do explicit CMA balancing
  mm/cma: rebalance CMA when changing cma_first_limit
  mm/cma: add CMA balance VM event counter

 arch/powerpc/kernel/fadump.c         |   2 +-
 arch/powerpc/kvm/book3s_hv_builtin.c |   2 +-
 drivers/s390/char/vmcp.c             |   2 +-
 include/linux/cma.h                  |  64 +++++-
 include/linux/migrate_mode.h         |   1 +
 include/linux/mm.h                   |   4 +
 include/linux/vm_event_item.h        |   3 +
 include/trace/events/migrate.h       |   3 +-
 kernel/dma/contiguous.c              |  10 +-
 mm/cma.c                             | 318 +++++++++++++++++++++++----
 mm/cma.h                             |  13 +-
 mm/compaction.c                      | 199 +++++++++++++++--
 mm/hugetlb.c                         |  14 +-
 mm/hugetlb_cma.c                     |  18 +-
 mm/hugetlb_cma.h                     |   5 +
 mm/internal.h                        |  11 +-
 mm/migrate.c                         |   8 +
 mm/page_alloc.c                      | 104 +++++++--
 mm/vmstat.c                          |   2 +
 19 files changed, 676 insertions(+), 107 deletions(-)

-- 
2.51.0.384.g4c02a37b29-goog


