Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB0A1606A32F
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 16:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UiJNVrqK
Received: by kanga.kvack.org (Postfix)
	id E67076B05B0; Sat,  7 Nov 2026 11:57:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3E536B05B1; Sat,  7 Nov 2026 11:57:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D53E26B05B2; Sat,  7 Nov 2026 11:57:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A020D6B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 11:57:13 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 33145401A0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 16:57:13 +0000 (UTC)
X-FDA: 85408928346.04.2669C06
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6BAB1C0004
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 16:57:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=UiJNVrqK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794070631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1IdYFHcguOld1djjobDM98S66C+vPqesPppAzQD9DKs=;
	b=gMHefnZhAv2vxgB+XtyJUTOCrK7RMbBGUhXns/Z8vL1Vt7cg3Tfo2ni8CaAdVsAeNMPEDM
	T9iKqUZuHQYQtSZkfwSSMesyijFinqL2illBf9uWgViA7GCwGZNVLR+8Xo98tp3LyH/oFv
	WTEJ1NkXez4Tj/6NcyzwCdc2swKBhRw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=UiJNVrqK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794070631;
	b=qB369+xkw8IftohbUNgo3lxIYXh2ElxLAV5e8gvxXGVdOWHLeE/wE8q5wbUnq/V34L0/D8
	y7uoPajJrma2H96STJS7EzOf580xqqWaM6TqUlXJ96NMO2LC8/fp+51Op4KptoCPy15Xp/
	2zZwY6B+LHSnpXZVtJWigMM9EZcgCTw=
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-1a3c08d6928so2896447c88.0
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 08:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794070630; x=1794675430; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=1IdYFHcguOld1djjobDM98S66C+vPqesPppAzQD9DKs=;
        b=UiJNVrqKoZiWHbha/X07sxEMqj7Vw7RL/Dxkoc/qz93X3TMTVkIQi1tTWW5tuUxxeM
         aEHte1Vu48OX0vYtGWN1joAHiakO2k+FeMdJRkcKKmmtRlh5rPk3ofGNzl1yvYRvaE2O
         Z7i9U/41+iLJ631ZVzge3z7mUVJ0Ajeao+/Jmoh+/DRYumsbyh1wOfhYRxtD9RQaEmcL
         lA/9NkbBCu9aUb7qLnj3PjpfAXfWxQEtuUDYbIodm1J3Oi635GgWst09pxkCPicL5jHa
         IwHbzyeMFPvogJj/Vh024vEK3hSAxeMgQheJWXCT2OWFdFX+P1oicUr5WC4NtSsSr+K8
         UH4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794070630; x=1794675430;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1IdYFHcguOld1djjobDM98S66C+vPqesPppAzQD9DKs=;
        b=JwfhUJaKs7Wa1PXQLzc4KMiToDqnvvJL7uYbLhAOIh8ATQKW3txWxM0Mqmkp3MKJry
         X+CEjwMkMNDjwWi1D8aSapR5bbXIGQVD9YXQ4QrCbP+ADRk/kgWVVZF/XHmhMz8So9QP
         UVC0D7P1brCztFUkJmgSSx6ojUWlAAM/WzxinBEf0H8c8o/AKYFINtkDO9gXghhNY/CD
         Z414jtHWV4zXvnLsjxPmFCGRSNrrRBYlMmocFnwhB1EYi66s0UVxFMG/QJDw0BsoUOgq
         cCRUCY5vXHHZ8Ru1u9ZT47Zjs3VJTCoT3+ykfYu5QqdQcm40/Q+6wOZLiC52BRhW6dSJ
         PZTw==
X-Gm-Message-State: APuU4Z8rI6ZF7kx9rrFKQA5cZQzdvkbTp7G20ziJMRgwexjU9ZMucl/H
	cIO4HesrjUil8R5mrcVPNJTCH9wZ1POsUU3Kb9IDsq2sxuBcsweY/n0f
X-Gm-Gg: AYBFou3V+mn4kz7FPCoWRuPM1eCRa7d/LU6WJjmfKmpnFAOElSzpCeberiF5WdJcdYQ
	itgdaohgS1JGe4fGbrZ5JMRFR90ekkoiy01J1OBDB5Si21mA6KYHejznzMdE3y2xH52BR7OodQB
	XA1kxh0gjDeUG4mf4e03DwH7mrZAoLpUqfdXPndJmzCOOtVp8rWe4Opdaic5nP1MEC0C7UfoB78
	cF1WzlmrzUnKWo2p5MJLpGO89I3dj+tv3U+lZ1SrE4r+xD0QDWsN/YLEpKA+l9FkYHcZkno0c7y
	pCANzfBpC886M7NMSW4iPGEVStjW7szo/EQjaGEMjAkrE1I59nup9RyVKpv2/NLTMPSwkrEaHV9
	Jq1hL44Ch+7oXI5CyJys8ZVqt6+WhbVTL3e7rqJWOQARbWANDn4+c7kYUZoaBqqYJUQqQlMmfak
	JbzdCqBOtyabz/a6smBay4nlBDAlajTmjoQ2cfTbq4YmmH25JxqGIajk83wSEwfBEs8XH9BKyhj
	NA+0HzeMMkrZhQdyj8njm7yql0ixAuRzMHx3xsyBu6D8VR2709C1rFRTfCbTd1KZ92HIq34W9Z9
	/a4a58KpN0BsCwUB7akqrXKE
X-Received: by 2002:a05:7022:c43:b0:1ac:d029:70cb with SMTP id a92af1059eb24-1b25d36f29amr7174636c88.30.1794070628979;
        Sat, 07 Nov 2026 08:57:08 -0800 (PST)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b25e4b4aa7sm15456126c88.13.2026.11.07.08.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 08:57:08 -0800 (PST)
From: Qiliang Yuan <odys.yuan@gmail.com>
Subject: [PATCH v3 0/4] mm/ksm: keep smart scan from losing duplicate pages
Date: Sat, 07 Nov 2026 11:56:59 -0500
Message-Id: <20261107-bug-mm-ksm-smart-scan-align-skips-v3-0-16d5ce8b5fd6@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFtY72oC/5XNsQ6CMBSF4Vchnb2mrVCKk+9hHAoUuMEW0otEQ
 3h3C4tx0/E/w3cWRjagJXZOFhbsjISDj3E6JKzqjG8tYB2bSS6V4EJB+WjBOejJATkTJqDKeDB
 3bD1QjyNBVXNhM1NoXRgWnTHYBp/7x/UWu0OahvDaL2exrf/oswAOsilEnatUqNJeWmfwfqwGx
 zZ9lh9R8OwXUUZRmyLXvFQ6Tb/EdV3f/tmrZyQBAAA=
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Stefan Roesch <shr@devkernel.io>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
 Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6BAB1C0004
X-Stat-Signature: fgtyodd4q7ntp9n7q1a7hmj16aet8h6g
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794070631-145008
X-HE-Meta: U2FsdGVkX1+acK1w6rDoNXXH4NJhjVxEaq7KJY6ydttO9w1QyuULrOIrl1FEMnlY5Pzv80Mrd1aeta9/JUfPV2l0rx/xQLYTYPpdOb3ypbWVfhAVNrcF1AciqSdhANSc+rg7AQNH79FdGQVAPeP8MYXD57/OQAvQvpPlpxkFwzfIX5SJhaQiQFg0w0/qkuVV7OIZCZBUKoOL7H8ViLy/nYM7au84v0oni3hMaC9V2x44a/46ETPE514hVGqfHc8RHHBZ6JoaUGxEtOsiVmbD/Gp1HbUWFNicSLYNDJcTfSbfJj/RBkJRSFgaUJ6uXckoAWj+xetGRXLfdVl0Upzo0ef1Md6I15Mpa09LMHl72ZF0HpE4Fss32T01bWQK+D4KvP5sTSN5NjUWbWM4UWs2AAcelNHsxezeHp+T1EJmoFfzNQX57Ng6ZMkZxBO6EL6xV1Th5exyE5/EEBEUpa7P79T4n+zhQCMUhf+cBW7/SvnftXA0KuuAB6XwEX7qkBq+L35aTgltLoqnzxdC7fhG7aZ3pgDlgit21/O3iFwmu00M5YZIxQaSdkcDzw7LkB8XgFPbQqaGVCahi0NMQ35qzKUaCZfSJvir/3O9CjmvNWN48BUhTvAJJjxonMSilhr0i/BYggF0BFZxpvOSwHZ3g32PJLlaagBBCbd8E/T1EiZNYBiok7RwE8TwWUtQFHi0lPvs5iMK6bUuczi7U7NYelJNYPSNJjuzPTV6ZosXqbWERdsoxz9hG8n8+RHzFFw7krDRgXpRyV04Fpbc5+m5C1SNweqLtsYZaavaEtlcwS2caeqCOkZAv/8RyW6WSg1uqM/Ve/e5KnN+wLK8evWK+r7D5tp5HqatCIEJCTJc89V80VjgV/q7/+/i2SsR7RPR72r3eNhJzpdbY4aSIryTPoz6Jgj5Lyjymyx7VsrOu1R75jwFczVYYewFKUfszXIF8lWMvbHxWYLjWaJZ92B
 F0BG2xoO
 DdquU/kWdITEwXUBtG1KdS91dkxGB8ynBR0jpMoHIvPoBIiEf4sMh6Cgm8XTGIp8FYsqsb9dbPTSilQvhotLhihd+qbuKLXSmyeKb12aaHJA/xKejWBSh7QJ8at59VDs0AsMPVZIzf3TrXH4qoEcwjN2VmGoH7+GEa9TIg9KK8P1rNeMzLqPGFhRlmtC/bmhFoLomAIS/ZDZsaKN7QpmdD7JOSATQMiGaRvF2+gzBF81ub0W/hGjY5qk+4xEVl8kpnGlwHALafDso7xrNiZlXPGiasRu9IvT89GO2G6EXzp2Iab4DlY+c/2I//CHtQADlBVKszcrFKngQ90pB56wYCQFbCTZQWlN9nlZWGNMUwTe6Gz00kGxwTh2Oc585YtnxNVanr9XwfjjCBm1cTc2ZdfcKO4T7N9t75/QCeZebLK1Vl9kwbKcVMnf8eq9A9CZd4H7E2kItJK7sEc8Kf9m+uUB6T3XkEGTytrb22oID/bZUgI5NR38YZP+eqLVQNXb7ViRpnVxxbWZhIfM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With smart scan, which is on by default, two identical pages that become
mergeable some scans apart can stay unmerged for as long as they live:
each page times its skipped scans on its own, and once both are old they
may never be looked at in the same scan, which merging through the
unstable tree requires. This was first noticed as intermittent failures
of ksm_tests "KSM NUMA merging" in run_vmtests.sh.

Patch 1 picks the skipped scans by the global scan number, so all old
pages are looked at together every eighth scan. Over 420 pairs made
mergeable 0 to 20 scans apart, 361 and 334 merged before on two boots
and all of them after, at the cost of about 10% more ksmd time on memory
that never merges.

Patch 2 documents how smart scan picks the scans to skip.

Patch 3 moves waiting for KSM full scans into a vm_util helper, and
patch 4 adds a ksm_functional_tests case that fails 20/20 without patch
1 and 0/20 with it, on both boots.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
V2 -> V3:
- Document smart scan in Documentation/mm/ksm.rst, as Xu Xin suggested
- Wait for full scans and switch smart scan through vm_util helpers, as
  David suggested
- Rebase onto v7.4-rc1-345-geedaa7d61f1e and retest there
- Measure ksmd CPU time with schedstat, which puts the cost at about 10%

V1 -> V2:
- Rebase onto v7.4-rc1-132-g05441d697f7f and retest there
- Drop the ksm_tests -N -m 1 numbers, as it no longer fails on this base
  without the fix
- Update the ksmd cost to 10-12%, measured on this base

v2: https://lore.kernel.org/r/20261105-bug-mm-ksm-smart-scan-align-skips-v2-0-8a9780b6844e@gmail.com
v1: https://lore.kernel.org/r/20261016-bug-mm-ksm-smart-scan-align-skips-v1-0-2f91d76416be@gmail.com

---
Qiliang Yuan (4):
      mm/ksm: align smart scan skips with the scan number
      docs/mm: ksm: describe how smart scan picks the scans to skip
      selftests/mm: move waiting for KSM full scans into a helper
      selftests/mm: cover merging KSM pages aged by smart scan

 Documentation/mm/ksm.rst                          | 16 ++++
 mm/ksm.c                                          | 24 +++---
 tools/testing/selftests/mm/ksm_functional_tests.c | 89 ++++++++++++++++++++++-
 tools/testing/selftests/mm/vm_util.c              | 63 ++++++++++++----
 tools/testing/selftests/mm/vm_util.h              |  3 +
 5 files changed, 167 insertions(+), 28 deletions(-)
---
base-commit: eedaa7d61f1ec8ae053a9ece0d553785350ac486
change-id: 20261016-bug-mm-ksm-smart-scan-align-skips-cd01e5a9889a

Best regards,
-- 
Qiliang Yuan <odys.yuan@gmail.com>


