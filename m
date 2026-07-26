Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 696A9C53200
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 12:21:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 475166B007B; Sun, 26 Jul 2026 08:21:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44D056B0088; Sun, 26 Jul 2026 08:21:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38BEA6B008A; Sun, 26 Jul 2026 08:21:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 052666B007B
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 08:21:34 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8A5521404B2
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 12:21:34 +0000 (UTC)
X-FDA: 85030838508.13.472A386
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1A74B1A0007
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 12:21:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d89Pqlwq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785068493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vWSA28c+phiRczYil+vgn+l5LYE6qbksBZK7jStIYfc=;
	b=1ipOPEJrEP/ixjzndo3v+btbjTPNAVvAxS0XmcwwNPgFf6XTKHhpBW3cNk0KSHzCb6URmS
	wIYZZaoMLs0TumzsZNXzm5TfRZIApxMR0t2hHJKf97hhpifDSbs3czdxz7BGGgm1ci0XU7
	ydht1pRGDX5BShkDO1tfEO4epso4j4Y=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d89Pqlwq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785068493;
	b=T7bP5PB6OBjxLC2jY6s58lCnnkqVOKQAhn8O+UwYTCrNqWyfXdSyXRtINoNiOSSolBGAIw
	Dj3fuqnoKQXk67kCG6AN7MhhI+ksiyy2GKK7CXsP6uOoT/eT+C2EtfCvjVSzlbOqf8GC2s
	yR4/OHCG7gV9kIY2MoHFP8AaDzegZBc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 288DE60008;
	Sun, 26 Jul 2026 12:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F03D1F000E9;
	Sun, 26 Jul 2026 12:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785068491;
	bh=vWSA28c+phiRczYil+vgn+l5LYE6qbksBZK7jStIYfc=;
	h=From:To:Cc:Subject:Date;
	b=d89PqlwqaDTJRSkSQHihn3XxMcHYpjvb8tCXxWVmn95o/B2UfwbRVO2fz80o5e7O7
	 ia7IGCGRTd13L6PMGkpIboEeeoFbqMm/ksHPDB6rAlZUCU7l9E12o0FlrrMQuGQQRR
	 sbkMF8qhKMqYL7rVYIIcHE/sbdP8OlW2a5JEmjbZSQud7G+6WZN21Tz6UOqHMFrrHf
	 Qtscn3HwiQdr1gZjmqRR2gpFbhls7cMjYAZYvo9W0BiNzKhYziXs6hOgNirughTCSy
	 gFDSxOc4rwOINfJ6p64dlRrgTzHsoNPMz9gtpcEXWn5nQoR6sgTOsKynQLIHamfJIp
	 DFOjAmJWp+RYw==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	linux-kernel@vger.kernel.org,
	lyugaofei@xiaomi.com,
	stevensd@chromium.org,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH v2 0/5] mm: mglru: fix swappiness behavior
Date: Sun, 26 Jul 2026 20:21:18 +0800
Message-Id: <20260726122123.7614-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1A74B1A0007
X-Rspam-User: 
X-Stat-Signature: u35gbs8ux47a936e49d9pankn3qxznc7
X-HE-Tag: 1785068492-989770
X-HE-Meta: U2FsdGVkX19IS12DDzof+h1mMl+O6hcYkJC7+PhI7MGRxHERJdj+XjM5vszRGCaRuZwW8+/USKVCPT+Uu6oN3MrTjtqNUkjauwTg2Zu5OuQvs5wJp0/YV261IWOOEbqNNaZC1bHU/M1z6C0kCL3zjQuxq8vBjg6Aaq19A4My543ow6oM5PNgO+WvZa7LFtE971diEfCUmtMZLLiSW4Q3NjHe7yuerteeQDrFgp6t6Nb//X7KGEiz2h0hm4IUivKIkeYITOrsSQ6whh5lGVfgkMSsJ9sje1A5RklPemiJGbu8oBUmlCFx30dcrxUDT/S5NarfIB1CqS5A+WQVmexQhTcARAJgermcL8DG+nSW7O5KXkHeTxiP8jm2h1YT10Z4XCKkWiHk96hNABCHE2r8TEmGrROQSlk6dKbbJgbUN4apjuQpIXBMJAnBJOs671I02ufcVm3S2nV+miJxz4/YuED2Ans95EQBYBur6f03D3OiIMMCzi/NwyO4qBg59ND/ovdCOeSdhKijV5erKyp7SCHPFwN3nnz418aZc7TOyzy2en9a1mIbW/cpCj7we3jZQVDwFbCDwNHv/jhHxQ51IRo95PRimERC5GoJRWzqZDQ/TdCgCItykwnbECkbrg0KSUdqfjUQdhq4XD6qTZYSwqfTwowCl6TYwgumlfZj9omf8JdGu2e5A6e7Of6NnuZULsnLanjRooaKN7zQPQkf5Zl6vXHgfqiDutSWwPNRixss6qU0ZBc01rS+c58C3aOmVXtpLLP8DWSwHJwhYY7IgUeFpdYyjV9PxHMviMJnZBx4b2KwiITvHiEWnQsgY86LbUIwlddh4ALh6Eh6ARoDK6wIqDB6kwSiC+l5RB6LHkwEhJB7ilWFdhGeuqaAaHOOMTBh+OIezPf/qu9c6oGmBuuNck3odQCz+dIa/6XvBy1jCrZklPsLG/NqDNVsxVy+5NS8jQ4qMpMwtPqQKC0
 7exa+Qk+
 91FgZ/oY7Y5xQIm2DJuay0HN3B5E6w3Aeod4QXn8CHfbmldYgLy1lJ4VCgLJqQNw+p/2jYtiYpUL/j4NemR0BjyNk+cpst160hHSHlAQsoEAKg2YoS+kbMiolQohQcbsFRfNWV41UfRBmEA7Di+WlQ6XYq00aq1NMvPNC8e3AmaolhY7zCesAWzUCEMIyeSyFDGWHO6n2bMTOcvp+pbNAdLP0WADk0BT5HkAAaP3/V5n+nPY9ufaBvllOZvboZ0lLFzq+G1Fmk/TZ/3PdibOWmB1l57KPEZdhmpi5p6VHunEhnlmqTrS4LkXfV5OO/adxgosoFS9pfVF5e/ZoKiCxr7+iu5Qb+lO6kGSzK6EaPpo2ZwSQjxwkdr/f9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

RFC v2:
 - Quickly address a few issues raised in the Sashiko comments so
   reviewers can ignore v1 and review a cleaner version instead.
   https://sashiko.dev/#/patchset/20260726012946.18684-1-baohua@kernel.org
Thanks, Sashiko!

The active/inactive LRU respects swappiness well. Anonymous page
scanning and reclamation increase roughly linearly with
swappiness, while file page scanning and reclamation decrease
accordingly.
For example, when swappiness reaches 200, both pgsteal_file and
pgscan_file drop to zero while building the kernel in a 1 GB
memcg. In contrast, MGLRU shows almost no change across different
swappiness values.

                   pgsteal_file

Swappiness    LRU         MGLRU
--------------------------------
1             10567455      763612
36              990706      480205
71              688170      415848
106             446294      386164
141             286307      359196
176             201733      351686
200                  0      330093


                   pgsteal_anon

Swappiness    LRU         MGLRU
--------------------------------
1              4410548     2726362
36             2465268     2762859
71             2677908     2885124
106            2737227     2841796
141            2984276     3035015
176            3381338     2938302
200           13116359     3113499


                   pgscan_file

Swappiness    LRU         MGLRU
--------------------------------
1             17997223      923094
36             1325674      539571
71              852345      464222
106             538207      464477
141             357253      412277
176             217536      399446
200                  0      375902


                   pgscan_anon

Swappiness    LRU         MGLRU
--------------------------------
1             31639423     5987136
36            23441521     5753224
71            26067110     6101780
106           25619448     5782919
141           26842088     6234264
176           29200021     5980292
200           62193924     6413125

This patchset respects the type selected by positive_ctrl_err(),
which uses swappiness as its gain. It does so by:

1. Avoiding premature fallback to the other type. Only fall back
   when reclaim is running at high priority.

2. Running aging when the preferred type has few or no
   reclaimable folios, so more folios of that type become
   reclaimable.

With this patchset, swappiness starts to behave similarly to the
active/inactive LRU.

                         pgsteal_file

Swappiness      LRU        MGLRU      MGLRU+Patch
-------------------------------------------------
1             10567455      763612        2276977
36              990706      480205         485771
71              688170      415848         425893
106             446294      386164         391528
141             286307      359196         371844
176             201733      351686         322634
200                  0      330093           1343


                         pgsteal_anon

Swappiness      LRU        MGLRU      MGLRU+Patch
-------------------------------------------------
1              4410548     2726362        2212243
36             2465268     2762859        3036395
71             2677908     2885124        3111459
106            2737227     2841796        3021429
141            2984276     3035015        3341110
176            3381338     2938302        3232294
200           13116359     3113499       14144584


                         pgscan_file

Swappiness      LRU        MGLRU      MGLRU+Patch
-------------------------------------------------
1             17997223      923094        3243420
36             1325674      539571         595233
71              852345      464222         523441
106             538207      464477         457391
141             357253      412277         434981
176             217536      399446         369302
200                  0      375902           1344


                         pgscan_anon

Swappiness      LRU        MGLRU      MGLRU+Patch
-------------------------------------------------
1             31639423     5987136        4136386
36            23441521     5753224        5489636
71            26067110     6101780        5699571
106           25619448     5782919        5910594
141           26842088     6234264        6511215
176           29200021     5980292        6286023
200           62193924     6413125       22582174

Another possible approach is to decouple anonymous and file-backed
aging by maintaining separate max_seq values for each type. This
allows anonymous and file-backed memory to age and be reclaimed
independently, enabling the swappiness-preferred type to be reclaimed
more aggressively while allowing the other type to lag behind. This
approach has already been adopted by projects such as CachyOS [1] and
Chromium [2].

However, this approach requires substantial changes to MGLRU and
fundamentally alters its design by breaking the shared aging timeline
between anonymous and file-backed memory. This timeline is the
foundation for mechanisms such as the PID controller and the
min_ttl_ms thrashing protection.

That is why this patchset aims to fix the swappiness behavior
without fundamentally changing MGLRU's design, with minimal changes.

[1] https://github.com/firelzrd/re-swappiness
[2] https://chromium.googlesource.com/chromiumos/third_party/kernel/+log/929932351492d01f0aee37a0ac3be8c7bd88f80d

Barry Song (Xiaomi) (4):
  mm: mglru: avoid scanning empty generations in scan_folios()
  mm: mglru: only fall back when reclaim is running at high priority
  mm: mglru: prevent min_seq[type] from pointing to an empty generation
  mm: mglru: run aging if the preferred type has no folios in
    reclaimable gens

lyugaofei (1):
  mm: mglru: run aging when pages are severely imbalanced across gens

 include/linux/mmzone.h |  6 ++--
 mm/vmscan.c            | 66 ++++++++++++++++++++++++++++++++----------
 2 files changed, 53 insertions(+), 19 deletions(-)

-- 
2.39.3 (Apple Git-146)


