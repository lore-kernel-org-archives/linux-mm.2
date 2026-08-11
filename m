Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 436A5C5CFCF
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 11:22:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48E756B0095; Tue, 11 Aug 2026 07:22:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43DFA6B0096; Tue, 11 Aug 2026 07:22:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 353D16B0098; Tue, 11 Aug 2026 07:22:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 17A3D6B0095
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:22:40 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 286D31C1095
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:22:38 +0000 (UTC)
X-FDA: 85088750796.09.1EB6A7B
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id 76D81180008
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:22:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ipt7oZhL;
	spf=pass (imf24.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786447356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jRhoQjSmC8GBNmfZgN7psXLs1nzRsY572TR6apNX5Ls=;
	b=aUGf2+4VAz7bfu+lLCs6d/leK1xNwfMxeHdLmN+qkhAKPxusEYrSaQ6lL3ocVK1gZV0OFz
	WnG/V7z8w95+/9thjJeojE63kbQH8YVWum+3FJYnAz0TXXkJ5gEbCTw04y+l7g/TiRHJ6Y
	DQ6rSn/l19rMLcrBBsL9kPLh3m6p5L8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786447356;
	b=h9VNW+XURbiGi8yLVI/x0SA2leYMNZQ48uDy2Yinf3tL9v/QAXdYfja4q0zcLUdwssfufj
	i9+rH6w7D2TSz0jFEQllAjg8wvR2NPPxLGOivUrwkhBBAwGvET/dXdbtNwKu8y7+pe41Io
	+ztppNzVOU20eI151MUN+VPyNBXK+sk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ipt7oZhL;
	spf=pass (imf24.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4956869750eso19760285e9.2
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786447355; x=1787052155; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jRhoQjSmC8GBNmfZgN7psXLs1nzRsY572TR6apNX5Ls=;
        b=ipt7oZhLjiLU2aRxydKH6XDayTAdBjC9n+9mLU9bAQpnE5EuDEfDmuWDgI0LLpljoc
         GANdlhUGSo5hzbFwvuMtJzILH5XYktMs10usbC/F9KLg0NlF12cDnelSkJ4cUhBCM5+W
         htGSL/5c7YbjD9dZok8fGpFbuakYcBBODnQRMQAXKA+IgAnn1Br+O9Ci/qJznbb2gFjw
         g1/P3bACps8l2MaI6okKCZqnBQE/9MkzY8KxexlZs5D99JEn4JRd9+LVY2TgdNJXK3U3
         lyP4jV5CwTuy1gpVlKos4oGKeazXtzHoSv7ybH7XV1A6ZgZ7ZfX4keNdxGVZsrMzyxrG
         cTSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786447355; x=1787052155;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jRhoQjSmC8GBNmfZgN7psXLs1nzRsY572TR6apNX5Ls=;
        b=Ouxn/fQ8IDXhRWR9UHG8NtX6F4nqYsQXjqDEnmJkC/b4leqxA4g0aRo3QbRcc+bYJF
         5eKb7X0DND/2oIpiD9nJ0GjXleOBkX5RoUY3tFysFuVhAFcKEwK5rV0vEnf1JH5h7kMO
         phs90hG78YwqP97zRQogkyqTGqn+SV/nYxCgdDhGKTmViogGJUbsu11PTy+FWOi4bY2W
         wTdge93VL23qbeWSljl4ORDTcA/D0FCO78UF7mAlc9+CIwj3xvf9LoPSSre535jwAefe
         HZFyPpoprkyiWB8RxRsAFK9u6olVcp+Ir/WASncUXDddC9bsfpw9dbt+6/N6glO15tFI
         Tqng==
X-Forwarded-Encrypted: i=1; AHgh+Rp3sdCSqHsmSyDd4Sh81uQAWaVhJcbNIpIRR1pkVkkUdac12apASBblI0mZN9y1s4I8tq90NMFv7Q==@kvack.org
X-Gm-Message-State: AOJu0Yz6eIBOLdY+Sw/mw58JoDJ/yeoqide/fbwj61TRAOyxUXnje6J5
	w9W/FCUKfp1JUM22FINBy31mnFZD/uCqygjdYGeDENlbJciB1Hc2aEmE
X-Gm-Gg: AR+sD10c50SWYh0G4UhmT8815Rpr+K4zH61KIPUb3c8TZYQnife7JJZu2XI5HbCIHIj
	ph1OmURy0PQfHj0ZPSgKamD34eLG48/H8yS7UvaR+iEHXxEg5x605UejhgQHK1FT5reU1Ygov5q
	MFQUoTjcmP8f1FiZXkwhzw/K8jBbHDJ4RtLQAUm0rnVKZ92DHijcY2nnDmkS1UITrcccyp8MzzH
	3tpAYmS+c/3TFeU6OUGdpjO31GTpv2WE+PjNr80Zx/aAbv+RGKkgI3l+baWAMY5VxQ3WqmwmIup
	6eRhRljU3V7bDsfjmcH8hEZIkMq0I+DXHJLc9pV4vrIT1SoVk8+MUgGeiJJeLoO7vQzBkKyoB6r
	tbZVH/5+x3+XjIAN6HWQtAvntkQJdi7T/wNzi3UzKHy7sq28MdoNrUdliK7nMe2CO2RmgpSoUmi
	sf15HBkcyOxcW+rMOgpVSlRB/HTNPApbSh5lfB/oYXXJMm0bKNGGpX/c5ht1BEfk5EujTewmxR4
	Nzx
X-Received: by 2002:a05:600c:34c3:b0:490:e5c1:b8bf with SMTP id 5b1f17b1804b1-49978465fbcmr46941675e9.13.1786447355005;
        Tue, 11 Aug 2026 04:22:35 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5e:1100:7303:647d:7cc4:8552])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4997889c2bcsm47547665e9.3.2026.08.11.04.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 04:22:34 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	kpsingh@kernel.org,
	matt@bobrowski.net,
	song@kernel.org,
	tasos.papagiannnis@gmail.com
Subject: [PATCH bpf-next 0/5] bpf: Add user memory access kfuncs for mm_struct
Date: Tue, 11 Aug 2026 14:21:49 +0300
Message-ID: <20260811112154.94053-1-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 76D81180008
X-Rspam-User: 
X-Stat-Signature: s5c4jr1yxy55q19pchoim6hg3uwke55f
X-HE-Tag: 1786447356-643344
X-HE-Meta: U2FsdGVkX19T8jQBNyxSH51Nw5G50OHsL9JQnJNT9gFQ+MdP8nwh0z6qcBWSBfSapuuOx+tziwIsS1s/weitGhBxpDsnCG1mWeYAE9XJtNpB9hgq7sNON1W18TzAUTAjzJ9uuCDGT7DG5motZdNxTTsvWZwROy61zFt2NFR0J6WjvtKAP2fLTMC4iAHYJ2Avj/sPsuqByehyGM61anHuoZFWaqp6ZYRAgqFwZpRRyj0LQJyXgPhioMA5rdERQk1zsDbFPKVCI9B8j9E5SiIpSWq7pCh3FwE/WlSwCQiPowNHlkka28BRfstmJaJEFz915L5Nyff+AFrBVRjXRFoHZT6lQa6sacaV2YHwdYRPBs2X3QF9ysRhrHZ0SC2Hk74jLM+OgTuBjPeMdJJDQEoFtXTl0WbWjktY0QYijOYFzDGEe4e69f3zXDtNONOTOrMQPoPOb6axXTasi+VR8MvPPZcof1NLCEoxzKDeIrnbzyKPR9KCUP3iZ/DA68kCmvipPab/+D8+7X49og6f9T4LV+VDsLxANymvMJ3W5J9Ag/AIv0KedL7gs9bEPKE0Sp9vLDcnc+kP3Vttd2NQf6RG4lB7HdNvo/dylLnb/Ov0Pe502SSoAmxxro6GsVHYvSLIAALpp8KE65OYf6TgBMihzUNDPZlKUR1DlNMnDZDkh8MpXZ5gkUUPFcq8xmTB5+LQAy9gL2GJZuP2ySj3R/69gVueDxRU/KxHDdwBTDwfa3Q5VqVy/tL0MFuMvVxvr2M4kX9y4xscSTeplSZK5iqp+nHLfTYo8c2anKPloQIRwUOUZhvdqbpQo8wN6XMwaYq4WAGvfMhgoK1gGlMJb1xczTexKMImSJiodzE61Ki9hN9Qql8KrMSILKFy0/anADcuVAP4X1e68W1KgAzB8bO9UTCNk/WHvMTp4o3I/OumKptN9d+FkGqF+LVEkY4fS4BhgQy4HDmQq88tY2Vn5Sf
 mCJrKtTs
 KTBIku008fqr3Xw42c5AKd0+1df43Lvj8WZDkFcd9ratJr/Nilrq6x3hfZQWz0niTEg0cPuLOO4PBiTD7Rn9tWGeLwsc5A1oH2h/bqiwkKbh6IKVeHzxSkEoh46eGBsu6X2MQTXNmGWmpAs4ZyojkYjd0gl+sFSTqXdHT7s10Jx8NAROL/EQSIieONRBS2N3nfcBwZWw4DugAdplMaH6tsSyq2V7HrxFV07inrQUmSO1IXMworJQB+xsyDeDKBVl7dNJIsudc8MN5OORxi1RW4CYhatl+fbwfNf7xXDobRhoijDulSzDUTMGgVjEVn5FjKMupKu2eyP2Ohi8+Zz5ref6tSQp2gDoUnQTutUWaU3M+8vkpeiFw/5mm2AmTF8U3hK6P/SZdP10Tr6+R0lNAMnt0wP0u5oSl5+0Zzg9myJ5YUDGvzNYTQEiWr6GIVx/x48slpu6NNbazOpPWnOz7IiJoodsLxz1qH+LBQ7DvlMDcAXMn3kJm9AO6TxrZYc93L0zHR1jgHTDG54lar1csMu9ziPHLWKzJLG0us7AtYWWfomKxbqJx8h2KBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During exec, argument and environment strings are copied into the new
address space held by struct linux_binprm before that address space is
installed on the task_struct. Existing eBPF user memory helpers only
support reading from the old address space (i.e. current process)
and for this reason programs cannot access these strings from the
bprm_check_security LSM hook.

This series adds two sleepable BPF kfuncs for copying bytes or
NUL-terminated strings from the address space identified by a trusted
struct mm_struct pointer. To support the exec use case, it also marks
linux_binprm->mm as trusted-or-null. This allows BPF LSM programs to
read exec arguments before allowing the exec to continue.

The series also adds selftests covering both kfuncs and the
trusted-or-null annotation.

Anastasios Papagiannis (5):
  mm: Add copy_remote_mm_str()
  bpf: Add user memory access kfuncs for mm_struct
  bpf: Mark linux_binprm->mm as trusted-or-null
  selftests/bpf: Test trusted-or-null linux_binprm->mm
  selftests/bpf: Test mm_struct user memory kfuncs with linux_binprm

 include/linux/mm.h                            |  2 +
 kernel/bpf/helpers.c                          |  2 +
 kernel/bpf/verifier.c                         |  5 ++
 kernel/trace/bpf_trace.c                      | 83 +++++++++++++++++++
 mm/memory.c                                   | 25 +++++-
 mm/nommu.c                                    | 25 +++++-
 .../bpf/prog_tests/copy_from_user_bprm.c      | 52 ++++++++++++
 .../selftests/bpf/progs/copy_from_user_bprm.c | 77 +++++++++++++++++
 tools/testing/selftests/bpf/progs/lsm.c       |  5 +-
 .../selftests/bpf/progs/verifier_lsm.c        | 31 +++++++
 10 files changed, 304 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
 create mode 100644 tools/testing/selftests/bpf/progs/copy_from_user_bprm.c


base-commit: d114bb98936770c501c958bf2bc5fb6b7c0bad7b
-- 
2.55.0


