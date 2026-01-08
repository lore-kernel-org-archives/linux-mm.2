Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B562ED14899
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 03:32:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 211BA6B0005; Wed,  7 Jan 2026 22:32:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E8876B0092; Wed,  7 Jan 2026 22:32:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11F426B0093; Wed,  7 Jan 2026 22:32:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F23006B0005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 22:32:52 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 99D0E1A058C
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 03:32:52 +0000 (UTC)
X-FDA: 84307374984.10.2EE0108
Received: from mail-dl1-f74.google.com (mail-dl1-f74.google.com [74.125.82.74])
	by imf09.hostedemail.com (Postfix) with ESMTP id F1C27140007
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 03:32:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=okRjNIYq;
	spf=pass (imf09.hostedemail.com: domain of 3YSVfaQgKCHoZglehgYmemmejc.amkjglsv-kkitYai.mpe@flex--bingjiao.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3YSVfaQgKCHoZglehgYmemmejc.amkjglsv-kkitYai.mpe@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767843171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ESVCnXmqmRAQ5ODTER3FAbfmr9FGldplMCss/ukq60A=;
	b=s8bqK58HzzgsTNWgKMiOX0qpVZ1v8MPaK+1TyOtlWR10aizA6mnSwtHYIe8HHCsOvXaRPO
	TSX88Sqh77XaIVLaxcZzTE+gOc7FYVe0pyuhpoHOMAsgTfngxIPQiFduT751wmDBcnXEoH
	QaUOj8saOLcSVjUuRaUvHo1RO4+2GiE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=okRjNIYq;
	spf=pass (imf09.hostedemail.com: domain of 3YSVfaQgKCHoZglehgYmemmejc.amkjglsv-kkitYai.mpe@flex--bingjiao.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3YSVfaQgKCHoZglehgYmemmejc.amkjglsv-kkitYai.mpe@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767843171; a=rsa-sha256;
	cv=none;
	b=JoDEHkQM/mpWd13ytUUywgn9uLfCusqkxSk7lzSVHafX0IbauxszGbat0ObFqbVI5CxtRK
	iWJU0Gs2LrrhsGqftBhdAwAigAh0coPIhmO/c+LXIOrgGJ9LanC2vorI/cyBbq5xfaAUM/
	yvMY4I3f5beMXj4Wj8Oa16Cjnh59G0U=
Received: by mail-dl1-f74.google.com with SMTP id a92af1059eb24-12055b90b7bso11793839c88.0
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 19:32:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767843169; x=1768447969; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ESVCnXmqmRAQ5ODTER3FAbfmr9FGldplMCss/ukq60A=;
        b=okRjNIYqJi9frPfxbIDpWIRanoJocUoX2sJgunsH/1osggPNUOdbWqVTJ2YDmo7dlG
         n9N6JOMILz+oQ2CXpcZjD5osx/qvQ5FJoeaM9adbe4HxZ7VLz48V3ouuL60rCf+Hy84Q
         WRB1YteK48vIdIsOFxoPAtcRs4jEsFZdIivb7FKXlP1BNTEH3HFHAEB3LcTCeyR2fYSo
         3WTENBkuSv0cdCo46FfooklXRjmwNGyGmd0SqzmkUK9sThx0jSGLb92xy1mYqwd27X9J
         voV2xE7yo5pazxMmHf69hrOi48O0Rz8nQAeX8OE7vuN6MZyJh/ykiAHtHrjbsYHzSsM1
         wRgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767843169; x=1768447969;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ESVCnXmqmRAQ5ODTER3FAbfmr9FGldplMCss/ukq60A=;
        b=xI82LMNGv6mV7ogrP523uBkpKMTrRJ3HjzA/GYuf1Xmi9LPKlxpgmpr/wLUT0B0OMe
         DdxZNTiSDfK3H2DW1FRfocQo3ZK3JvUmDpxl9xZG4RjWyzBqIHDBxu/7UwZ7VtqrhDOz
         LUXnFraHmm0KYJ1cKtWhAL0hvCdRAaWjxSD3HYTgXb3yeECIyddigO+YpxuFPWj/BGJW
         tqP8PeP5sj2Ys0p77JMTGchV2zwLz8UrVKTqk5nWvDFepnH5+kmTHi/lbDYHhkiv/Wl3
         5qn/fV+RGyk7ElQ8Db41Nd9SbQDxgyREwoyPZ803OnMrvp2AyN1c1TB1cy/5EVcjbX0d
         qLnQ==
X-Gm-Message-State: AOJu0Yx+2CW2tz+waXZsaAQ0Qk+RAxfow2rsFLJaEgQDiJgVyRHFSB2G
	Bf7A7bjIrpOiibqYATSvQ52kcLYreAZWa+Y3Ziqf1KFnFp7K0yto+RKivOUijE/kCr418nadRCs
	p8DNQVCUa6nvtXPSYXSSKBGyhJaPj5zWcmgmOSqoLKXDc74cMvOgxBZ2VGEq/Kc7NgpriHW7qJp
	BGEalWEDQhnpMyqK2koUzymiTSttEfvgIcd6CBqgsoqA==
X-Google-Smtp-Source: AGHT+IHrHf9fQdWJM0zf8KVA8vtxEJSCgjeMUhdBV5auR7muROG41/P3KxOzRQbybgRMtKfRwajiaD1GuyIrkw==
X-Received: from dlbrs6.prod.google.com ([2002:a05:7022:f686:b0:11b:b064:f5dc])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:e08:b0:11b:4351:2687 with SMTP id a92af1059eb24-121f8ad0889mr4234493c88.17.1767843169334;
 Wed, 07 Jan 2026 19:32:49 -0800 (PST)
Date: Thu,  8 Jan 2026 03:32:45 +0000
In-Reply-To: <20260106075703.1420072-1-bingjiao@google.com>
Mime-Version: 1.0
References: <20260106075703.1420072-1-bingjiao@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260108033248.2791579-1-bingjiao@google.com>
Subject: [PATCH v7 0/2] mm/vmscan: fix demotion targets checks in reclaim/demotion
From: Bing Jiao <bingjiao@google.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, gourry@gourry.net, 
	longman@redhat.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	tj@kernel.org, mkoutny@suse.com, david@kernel.org, zhengqi.arch@bytedance.com, 
	lorenzo.stoakes@oracle.com, axelrasmussen@google.com, 
	chenridong@huaweicloud.com, yuanchu@google.com, weixugc@google.com, 
	cgroups@vger.kernel.org, joshua.hahnjy@gmail.com, bingjiao@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F1C27140007
X-Stat-Signature: jzsj5r43pnc5u3w7du8pcboyeaqkw133
X-Rspam-User: 
X-HE-Tag: 1767843170-162317
X-HE-Meta: U2FsdGVkX19ODaW2Uq6eTUgIzoYP5K3sJl/UggMReA05mw+krqdQkFpaVywQeyrUTxKuRcQ/vyBJavTyXfLk8E+uLaU1KMPwHoTU03XcfMXJVs7vFK/89z+OlHu3oJCKWbWWdkzVxCeswEmjWCwq70CddI713RqINAaL08SxjmNuK2VhuciwRmeCLLI0QhIJQUqzptUjAks+Y2WT7CLd9sCmUwUWi2Xvy/0jKFbDwbRLWXrUKuBe8QyciP52p68Md8f4y4C16d8rlueYCMMxIEwt82ouFGng7vu6YwjFvuR/4fLJxGtG15O/orYQl22OWYc8KdXbdw8+mihG+Ju95AKL6mmxb9PD4DVcYNFN+v2vuLHlZk/Tt2m97GIxx5b6BZP+hyXeeiJm/ZdEu5XSFVI69WWdhojmoleoaDBG/AbvV4pzcpQEoBPD2wVEYiKlYUQJDDYcT2PuL8szznq6dj+gQ2Skgp8ghGUI3MXj7MnkAT4kGbhMAsIFAz8Jy7aNMqr4GHdzq80tYjfRPu2u65t8kIdtnSm7PMe4WAJ7WgOVpCrpObZyQcfrW4oQf2SWJEzWfeDErXHoO2ulsZqR+SiYWcRsqvAVaOuGBByQENjo8BqHeqlHtukpN0xUE1GJm+lLv/XLYTXzZvjTzfsD+PIYrv2XExhruZYiNfsoN1uKY99lk8CRlrwFAdzjGzC9289HH1oT4VhvgTEMTyZRuUUwVlSMnecYWD1LBL8M+t/KmKUYhEUAmQf/jU2eShdr9qp80jOmWcdOV27tSySjsislkkamaH2zuNv+G6SZu/C8pDUtgLbOXiILgrlCrxIZrwTge7INfOF9clUS8kG8PsSjZvOJ+DHDlay0eOecfEZHGNCZ/aYSblKFo0Xegif4EveepuczXHsKdWWURhM1Tm0eu6gN/RpSuE4QVKKSArYUd695bZM2YcVaaQD5O9+5EwL/Yh8slce9C5zBF2S
 yN3xjby5
 CZ0PEM4uWIiY71xLpOXHiJWLE5H1yZxzKHFiThm7W9ot7EdPCsQuzSNEzzpKKOQxjxvKEIgy4Bz0X74NVCJZj/ru52LfXp1Zp1Cf89mDuC2a/C6+Bh6af/QschgzVEesLLZqS7l5+h8aQKOisjPSJ1gHLyZoVrbDcPtfJPEcZN1LPWF4XuI6uFPQW7mDDnj76qHA5FaIGQ8pP+lnO2k0m0w8qAL7sDKyXK6ImSbpx/sS0fGK5s0uSgv/FD59Ngzx8r6iNs+YigMoCi0DDCJmReclqJW5X5m6b9UHRWAx0ZGQtunCf3NFNc7uNRNMeEPBJNXTcapebiuh4WiR+rzJAU5mPmA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

I am sorry for issuing a new patch version after v6 has been merged into
mm-hotfixes-unstable.

Main updates in v7:

1. Fixed a bug in v6.

   Specifically, next_demotion_node() may return NUMA_NO_NODE if nodes
   were hot-unplugged. V6 directly checks
   node_isset(target_nid, allowed_mask), which will cause out-of-boundary
   bug if target_nid is NUMA_NO_NODE (-1).

2. Preferred node selection.

   [Patch 1/2] originally implemented a random selection from
   allowed nodes if the preferred node from next_demotion_node()
   was missing from mems_allowed. This behavior contradicts the
   purpose of migration_target_control.nid, which is intended to
   identify the preferred node nearest to the source.

   To resolve this inconsistency, incorporat the preferred node
   selection patch into this series.


If there is a consensus among reviewers to backport Patch 2/2
alongside Patch 1/2, they can be combined.
Otherwise, I will post Patch 2/2 in another series.

Many thanks!

Best regards,
Bing

Bing Jiao (2):
  mm/vmscan: fix demotion targets checks in reclaim/demotion
  mm/vmscan: select the closest preferred node in demote_folio_list()

 include/linux/cpuset.h       |  6 ++--
 include/linux/memcontrol.h   |  6 ++--
 include/linux/memory-tiers.h |  6 ++--
 kernel/cgroup/cpuset.c       | 54 ++++++++++++++++++++++++------------
 mm/memcontrol.c              | 16 +++++++++--
 mm/memory-tiers.c            | 11 +++++---
 mm/vmscan.c                  | 49 +++++++++++++++++++++++++-------
 7 files changed, 105 insertions(+), 43 deletions(-)

--
2.52.0.457.g6b5491de43-goog


