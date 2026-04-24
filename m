Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F96AFF8851
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 21:13:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 532866B0005; Fri, 24 Apr 2026 17:13:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E3666B008A; Fri, 24 Apr 2026 17:13:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F9496B008C; Fri, 24 Apr 2026 17:13:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2E3496B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:13:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 460DB1A004B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:13:29 +0000 (UTC)
X-FDA: 84694700538.11.7B37279
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf11.hostedemail.com (Postfix) with ESMTP id 82AA340008
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:13:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iuI8Aat6;
	spf=pass (imf11.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777065207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3s/reOiow6cWcetSWjs5GiKOk/PJ/Crj+r1G//Avpjc=;
	b=kWQcVZrGjYNFPnghuaqJtjMuj4gljSoUBClLp4IgakblZ4H3jR/wOzKh/0V7bNSAHOZapE
	KViRS4Wy/BUVpNOt2+oMXlg2/+gW2W5gN7zzBi64Ey/yeLY9R1H8PNLVfaImqnV9No+akV
	10uwYVT64Qtx0gqGoJ2iVfh2i+e8DQI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777065207; a=rsa-sha256;
	cv=none;
	b=JprEw7khejzGdYMpL3LLeAO0PA54elCDAEkRtoxyhbS1b1aTdHlGVaJmPRZX7soBcACLfi
	OWMLH+stWp4mNX8Rp01/KGIzMVFRnIWrCLviyYeabepGW/2UPDw3lxNL8NOqT7NAFsiJhh
	Bh2oAWw4zkTvygR9gJDVlbMNtghTjSI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iuI8Aat6;
	spf=pass (imf11.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-43d76dd4ee8so7491964f8f.2
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777065206; x=1777670006; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3s/reOiow6cWcetSWjs5GiKOk/PJ/Crj+r1G//Avpjc=;
        b=iuI8Aat6HIh5hJyb+2NYAM0N405imTaqQ+PulpcmTfKCKz9KC3Cl6nK8O68Gjaldgb
         Wc4EZBEhaI7dQyzfI9OJncFC+CT7LoDiH8x1YX0APc2OUhz3WEH7rmHbaKMoKuTbei8h
         U9/1KrjoOfsRQY9Li72tedNnGvLLJL9lHq2JJ7gklCcdgdh/eff6AylN/qcy/dYsfaLp
         7ufuOWK3pFER2Hta4kwikV1dr7492yyznvtfoHVFyHhgsulnBYAKQFtC07MA+CP6GWsT
         TK70DyAKaImNAt3YVhFT+zIzm3PH2dKxw1ibCM7sYx0iNT7zzfk5fkEVTnKlwXzMBB0O
         rSVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777065206; x=1777670006;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3s/reOiow6cWcetSWjs5GiKOk/PJ/Crj+r1G//Avpjc=;
        b=agDzKY0g00rqvt+P9AI8BIpwediaa7VrBfpTXYmqcwZgAZgqnbf4oaYwNm1M/Lk1PA
         c1iPGmG67hVYJyZex4bZwJNdNFWK73HVeA58lG/gnx1bEfUYWGdBauOrsEprQplJE2Xf
         pka6EMfpfSoaBkkuz9BpQ9OOX/aAt8lSBy6fHU+PR0l5IAqtkb8dOcBpj4lpvigt2EYk
         bOxNwP5kVezI+vVBhmVis2IFFEdN/Pv3864ZP8wujYQlWEXuB6+iSX0wj6nhbhK4Ac+E
         9vapjCnU1AapSQ6z5HV+hxPDLfFjZ2VAPfXqoCJRLUvgUgwEyOH0Mn8NWXcWTkTilnXv
         s8Cg==
X-Gm-Message-State: AOJu0YzQE+/VCqHf97R2JvcwmX+KTmZOCeexVoQ0e/pDsz0JDc3cE2Al
	iZgRqrUWKmn8XlDpsJddxmUvfOsH1ObXC9mfsLK+hV5qXpFVpi3NxIAP
X-Gm-Gg: AeBDieuAj9WOuAV3uz1PQYbPNBlEA+VF1pSG7rx3Eb4zY55xvbJo4b99skKUKOwdwnK
	dSu9GpgrezIVTHPTcZkO3ZJDMKVnjwIop3qal5K3S+uQlaNh80f0skLHiy0U3td9iwE8J/UD7ra
	pdOFCkB5Wg0RjAMT2VDLVWJS6WLQaNLieNC5mZ0VdaYCJqhfuRGJdG8TviBy3s7ciKD15+Jiwo+
	s9apVIvgQIuzhUCEO0ndHnRo6w3Crsa+j0+y/DfgI8F/7AsDwJiQhviW4p/NHXQveBF3HtAJCIr
	y0SU69gSU5qz2rw7weZnNgc5X+RNR3SxiIWHVLyzXDVsW0LPwDs67t9+vmukne+Tg5Ay453j0ii
	g1XwrDIP/2LsEGMvM8G8PcNPN42nsBTka6PmNlb1aK44P+iyhB2YnYivcRyVrJ32XsKmPwStRyY
	uUFH4oFGmc7KYZPFvo130Tn9pPL8pMng==
X-Received: by 2002:a05:6000:2508:b0:43d:7e6f:3816 with SMTP id ffacd0b85a97d-43fe3e14ecbmr50458410f8f.40.1777065205591;
        Fri, 24 Apr 2026 14:13:25 -0700 (PDT)
Received: from fedora ([156.207.128.125])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cb1176sm63845677f8f.3.2026.04.24.14.13.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 14:13:25 -0700 (PDT)
From: Ahmed Elaidy <elaidya225@gmail.com>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com,
	avagin@gmail.com,
	Ahmed Elaidy <elaidya225@gmail.com>
Subject: [PATCH 6.18.y v1 0/9] mm: backport sticky VMA flags and soft-dirty fix
Date: Sat, 25 Apr 2026 00:12:34 +0300
Message-ID: <20260424211315.1072123-1-elaidya225@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 82AA340008
X-Rspam-User: 
X-Stat-Signature: kwfkrik6d89nuuaimteyf1kwjr8uuyxz
X-HE-Tag: 1777065207-327845
X-HE-Meta: U2FsdGVkX181Uwhg5Ui3EsN9BHWRvI4cYym1Y1+aD2Pc+1AVncnLq5bOs+wCgzXHuU2IZRO6yN5Aj74HcgVcydSa6nADXxmBkExED/Oy5TPAUZIvc4KQfnicRq+wQQEiKIU42JFLIDETEXwA7AbjNTMTrFeHrG9XxlESnrcWP9xeWBq9MOVRV4ocBejSmwZRBU69UxMkzmm1ASC+czT1jBUrbjVACW2urdAHzqBNnVl3ylWaaB/h0k8DtzLUeQVcxbVoWPZBjwi9kjL5o2uLJYLk4iaUui+9wkEA6ZheHE6m+1VaLFRInl8K4g2bguHKbSqh6xd08MmRkSW6Zskrggbcp8Ch9vmCfN09wv8PBey4BApV83LESYIadRWaAuL+tA0Xx7jAgqxXvEJsYf9gO/A/KQE63kI3nLU3LNNA65VSk+5WpKL1UJvleiiZ1qfXEwGJ+zJBZ1O/2X+O6e7+2goCyXWGVz3ahWXedYIjUcH8EuPdkVm5cToc0apdRHsVUbGENAy9EosSboOiGik/jfnS0uKSO+3OnL37z62dk0XdcGyTrnNQUTieUV9eW2prUie+vDqMTcsVd6+/kcokLNVVFhGw92gJxBcmQWu2hbttumM/5RFNNyGadPhNkq/bNtcTwmRiKICdn1slODxe4exC+f+dDWCSPGQY8DIL3ABJsTGxkdNzvl9uAG/Upk7rm8pHNdkeyxwfF+XyP8Kv8eLzfEgl8K6btIQQFVM07VfW5Wo4Yy0pXhxvCjHPxrZxyYVaE7yoNiB52m8mexgiQEK3L3XRQyeB7sYVCfyYktwn7HVe60/YeWIyAFg4xJZgTDzlXGO3qI26+b4Mp5iTSLu92vpKWXd1G3wMUWqQBySfY4gqlj+RK2V7+ayX289C+u1RuZkGvj6ITN2YaUPCC8EPWVksKTg+rRVl7/Jw39xUkK4vZgTb1C7m/5XW0WxlCOIKPDNWu+5wYfZa2eO
 QZ8YFc6Y
 MHllqTk4Ba6LTXmNGW+kGZXBIbUCUB9N3aU+0Jacm6CfapDDm+7rmOD/6xA1JcN6wfQCOceX3KLdOdxQp2X0jMQVosViPHSTgxPOdO0Cd/xBi9vSyS/AGmYZlsAD8nX1s9IAOYsz3jXXANrEODneakweZjxTMxcjDssUeoEi+w5NrXd1iIt2m2TCthactfNoWM7/C03uBshIsikqJmLfGX1QXIiQZIhQBFgZKOI2ddg9qpzxOC/ysmj+2r1vah4ntdIxrFtEHgeyr2jeNulMGyAedbcfwbreeXboJlKVMtXWHS76Vq4B+3sxCVkkqeYZItusSAFNhIJjwqSaQj5pvU/2YNL7eFqBEtUa7XDLvSkT/5qNqPQhDhY6FTNMfGqBsWgFZ2MOf3iZNDzFkBy14ahVGbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series backports the sticky VMA flags infrastructure and the
VM_SOFTDIRTY-on-merge fix to linux-6.18.y.

Motivation: CRIU incremental dump/restore can hit a missing-parent-pagemap
failure when VM_SOFTDIRTY is lost during VMA merge operations.

Patch 8 is the target fix:
  mm: propagate VM_SOFTDIRTY on merge

The preceding patches provide required dependencies on 6.18.y and are included
to preserve upstream behavior.

Backport notes:
  - Non-trivial context conflicts were resolved in:
    - mm/mseal.c
    - mm/vma.c
  - Conflict resolution keeps upstream semantics; no intentional behavior
    changes beyond context adaptation for 6.18.y.

Cc: stable@vger.kernel.org



Lorenzo Stoakes (9):
  mm: introduce VM_MAYBE_GUARD and make visible in /proc/$pid/smaps
  mm: add atomic VMA flags and set VM_MAYBE_GUARD as such
  mm: update vma_modify_flags() to handle residual flags, document
  mm: implement sticky VMA flags
  mm: introduce copy-on-fork VMAs and make VM_MAYBE_GUARD one
  mm: set the VM_MAYBE_GUARD flag on guard region install
  tools/testing/vma: add VMA sticky userland tests
  mm: propagate VM_SOFTDIRTY on merge
  testing/selftests/mm: add soft-dirty merge self-test

 Documentation/filesystems/proc.rst      |   5 +-
 fs/proc/task_mmu.c                      |   1 +
 include/linux/mm.h                      | 100 +++++++++++++++++
 include/trace/events/mmflags.h          |   1 +
 mm/khugepaged.c                         |  71 +++++++-----
 mm/madvise.c                            |  24 +++--
 mm/memory.c                             |  14 +--
 mm/mlock.c                              |   2 +-
 mm/mprotect.c                           |   2 +-
 mm/mseal.c                              |   7 +-
 mm/vma.c                                |  81 +++++++-------
 mm/vma.h                                | 138 +++++++++++++++++-------
 tools/testing/selftests/mm/soft-dirty.c | 127 +++++++++++++++++++++-
 tools/testing/vma/vma.c                 |  92 ++++++++++++++--
 tools/testing/vma/vma_internal.h        |  49 +++++++++
 15 files changed, 579 insertions(+), 135 deletions(-)

-- 
2.53.0

