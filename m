Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A01136083631
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 01:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AcuqEqEL
Received: by kanga.kvack.org (Postfix)
	id 9031A6B05B0; Sun,  8 Nov 2026 20:23:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DA986B05B1; Sun,  8 Nov 2026 20:23:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F0546B05B2; Sun,  8 Nov 2026 20:23:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 502DE6B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:23:01 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BA9851A0418
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 01:23:00 +0000 (UTC)
X-FDA: 85413831720.22.0EF2EDD
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf18.hostedemail.com (Postfix) with ESMTP id E83871C0004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 01:22:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=AcuqEqEL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794187379;
	b=3qlq0rB6lTobNDNwCwPyi34NqHEAmS2b03UomqdRLkE3FVrtjHCSCx/PLPmBp03wqSyduf
	mRcCjksuTpgqprdKZPrsVvFU/wQ1TsnZ6o5kgTRIwtgAg2OWqKi8c+a7dEdjkN1xlacW2K
	5bIr7/RiEiv32YaOV2jOold65XI6Hgc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794187379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vdbzkytGXRhHN+l/mE1rRdmYyXtT3CDBuzLxY9K8xVc=;
	b=HRDfX1U9bQtES9CYYk4o4ZySTE9/knjp7C6KZ2TTmV0CDfR1HDBE/5C0vMRZxj/vq8goq8
	+kB3W4yHWzOW6hc5CIZKOej8IagJsOdrmNKHYuHBatAZMiPlx3idnU1XMU2H2EfBnsdKnz
	D0m4DR1Psc3WzPhvbEHkX1GxTryURis=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=AcuqEqEL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1a3c08d6928so636236c88.0
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 17:22:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794187378; x=1794792178; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=vdbzkytGXRhHN+l/mE1rRdmYyXtT3CDBuzLxY9K8xVc=;
        b=AcuqEqELdLIghCuY/+UuHuhiLHudZH59gWoRcEPCMY8XFarxzZd6pv5Xy79y1KwVAW
         l+echV0Mtf8dffn7Oe3KzkFoRbko/2B99+EIdS0pi9MPtivmQkl5eMvOvTN/J4x+FFCf
         1p4du90+WV/FBAyJf9X+bmWKXjlHiQoOimHcHJT+le8Pylcqxvt4UDZN5jC3em02jYjh
         6wPugCT5T+6ZVPxc9HcXr/obQKsMz3tHXEVJeoQBMTf2FODpiYlXVLlsBKlH2jYZXODx
         jozaL7hf8Aw4fTnrb7qWYdK0740x5JDW2ITAT/rts6b0qCikoA2lXVeNWdZU6DI1GG80
         lM0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794187378; x=1794792178;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=vdbzkytGXRhHN+l/mE1rRdmYyXtT3CDBuzLxY9K8xVc=;
        b=WcC8yYAaaOad/Zu7g9CgJTeX06b1fcSuaRTncL52YhtU2SMaAcsmxFLjKtk2xbheni
         HQ28H8n6A9Y5yHcJy0iJ9+DIliMQVc3a5weiALzGurBnEzqyE9LjKCIAyPLYDm5ycFpx
         hxY6LpL/Ls/AmzZE52w5mrEEi0i13W1araRwOjQTXJVppzWq+Ifvs64n1xGxQggQTeUV
         b2gWwBvMCcCsRvd+3IWtQQdr6Xoe+aOjlGyIk/YuYckkcxueRCSnETXrubh5pmYxnmB3
         IpQQ5wEFs5NpOv3oPkLeez6X4JjN8xDQdOAglSqT7QJH3R8VMIH6Z3EfluplQK7zYb75
         9KBA==
X-Gm-Message-State: APuU4Z8T0SDRvvC7ITFmmcmJMsBw0YzFLIm0vtOidHRnF/f6i1L/Li/9
	/+EBWuqs+PeSyZL8WznCtI65yJiqD1R3/HeKArDLqdGn8OG01xKThY9X
X-Gm-Gg: AYBFou18JvjrS4Bnzyu70f6rlk9B0TUJHEzWau0h8K+DLyqTNcyJvYyOnBrOGCTIB61
	1r/QbPJDdy+5/2wD0TKPc+EYbZGKQv5MKMv/XfaOjxiEoCkqmpx+Ay6WcSim3NFzXOolSkpV0xF
	mhDZbpdV00F3BEhHhPlVQdIiZ//eP453SygZwO8YfzHh7wmBdj/ammRLHVEMl3leyvLwxWRGoRp
	+NBSYTkvITye7y334ETzxGjJCoKPsQFwUmWBIl9BBCY5n97LztArjVc+M/SdFuw8xzkRw2GHcBv
	QrzVfvG6/zd+2IssV4HX9GRrJ1lgZxU7US6g+LdFQbP+LyBbFDsj5wFNXH9MwTTYJzQJeCNF4ye
	6+sHIAwssH9Viwg+uu+B+FssiZfjOcm5lCHpiJnmvTnxbJuODTozkJTZZCx9zivh731QQj7j11h
	uL4OzaBclkfzhjM6Zsf1gj72iYWOM1qQrITEP26KppagWUE/Xphg6A6pV9KJbE8o5VAhnOy8mLS
	cC2jEHjrIDWEleKUQyOPU+3N+jD7nSSTSaqup577Zszaq2ZVTQJ9V829lLs7X5FijWJky+DYtNm
	V9MG3UBNKJf+jb8KgyeMvDBw
X-Received: by 2002:a05:701b:2702:b0:1a9:f3d2:6262 with SMTP id a92af1059eb24-1b39ff04e7bmr4005319c88.36.1794187377412;
        Sun, 08 Nov 2026 17:22:57 -0800 (PST)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3771ea85bsm9428226c88.18.2026.11.08.17.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 17:22:56 -0800 (PST)
From: Qiliang Yuan <odys.yuan@gmail.com>
Subject: [PATCH v4 0/5] mm/ksm: keep smart scan from losing duplicate pages
Date: Sun, 08 Nov 2026 20:22:49 -0500
Message-Id: <20261108-bug-mm-ksm-smart-scan-align-skips-v4-0-86be8fe77e7a@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGkg8WoC/5XNQQ6CMBCF4auYrh3TqVCKK+9hXJS24EQLpKNEY
 7i71Y0mbnT5v8X37oJDosBis7iLFCZiGvocxXIh3MH2XQDyuYWSSqNEDc2lgxjhyBE42nQGdrY
 He6KuBz7SyOC8xFDa2pjaiuyMKbR0fX3s9rkPxOch3V6XEz7Xf/QJQYJqa/SVLlA3YdtFS6eVG
 6J46pN6iyjLX0SVRWPryshGm6L4EtefYvWLuM4ial+6YJqy9fpTnOf5AbYWliB2AQAA
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
 Qiliang Yuan <odys.yuan@gmail.com>, stable@vger.kernel.org
X-Mailer: b4 0.13.0
X-Rspamd-Queue-Id: E83871C0004
X-Rspamd-Server: rspam12
X-Stat-Signature: 9abhtjraq31kheqdper65ggs8w1sde1m
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794187378-762263
X-HE-Meta: U2FsdGVkX1/vtXJBDFXMEiVP5paJ5RFCvVVVWCc9alkSYs5PAh9o3F+7M4bL7W9IwTquPEJ1g7T68XAP03iWyU6oghGmVt20OQ1tZo1IG55MzFMdUGT128/kgptbgDXtkpBQseXGj1ihXEq6eWmuHUMzC2dHTId/TtkR9O2cJFtJlfp0FjZ50y9Ja3rDw9Zb+/pqa7jv/KbTZ6rY9vHV2YAOKhiCxKPQ8a2EoT3aK27OYy21VpviYSR9D5dDTWH6dNGdnpPPRwyl2Ali6mWcUWftVKdrxZ8wBBcxC9PU5i+nULKaCND4wicSGQlnx6XgSZZF/KwmsXGzdlYlTnCv72XGLuDICUV2Hx+oqfSjpUrliUCMYzRevJoAw+REUF4wXrK0J52Rqklp+JD/R+IhSCe4H/qrrlh97rFpHOHXXC1H+9eL1B/3xlPv2H5/zsXhHPKDJ/79mKlhDFtx69ATWEDg4l+F1yRXrQ09eY06mIh45uJlOih+bBxXyHOnZDE3GIq0+XMVpBLLw2LxABlmLjRqq2quj0lV2dAX7casg05xv3M1BtTa5zKTQxQqsTW/+P1sRh6nAkaYHHjjvaQno/oI4syoger6WjVMgpVXnzHh9LtseAT+VSU3HYkzRkxOvYcEVOY3Ij1MecZ7dk6qSoFngage3RjHkDoYFZ1KhsLfPqzv8KcrpQxkCDPtBucg80M7LTtprxuoJts8S7hjv97pU4PjNPIx6B4IvkHK47tFcxlJovprTH89zl6L7EYaNTSCDAvrSaiRI7+DLmyRHndc/3IX1B/L0voVNFy/UCH/zSg6sVSOe7p/2w22KQXUv8dqyOy7+/HbFXsKyn/f4LlCsvmLEq7P+MoDhTeZf52UmK+35qf42m01lX9C9w02xd8pKoqQEer2+hEWbXduYvAGAPDAGavtZSpAUhf+XK/gVjnHH1Al3286M157KkvcJXnye85wo5s7lZMjXvG
 RRbyy9KX
 q5ZxLwxv7QxwG8NrgsG5Hjjcty7g7PcyPjZP4FCr3WpqCnjjEEkDyC79+5eZSsoSJseUrbBoIi7N4G09jCHetmrLsfzPFc8A+ti6AXPjL3/pxhBG+9K6Szlzz1vgM9dZyLr121k3863cJfTJJ2kYnrzlTt1c/YKAKz5fMZL0FdtAoJaEHqT+NF5q85mOF72GjfFAyzTtcXV+MVxyx0GahJKcVzleAOrkJMIuOyA5w0ifgeFbAoBgliduah8DoWt6jRgOZSl2vfYgO3mmRk9VOGewdTbyj8uLtmWpHFskp3DaSOjZXFF44DcjJcmtFEDmMJO3nKCHYCbxGDxyiPX2fDOn352Mjm19GDIkUtUfAvqpiHM3JOUzbj2nuuW2/jjNJYfGtJEsB0Ih/7NBkcIrfB6KG+u46eMMRtLC/A0BWJozzW9lXlwHu2B8jVwVdSyNTwxnS9HfncjuzZU+wN7mmLDT8gaHA5q1H+nI6fWgdKqUsQac+vqAqh/8rzm6zmqWCOlFG/rrCkTbqNj9PpY5GFiEYDEoCMpXFvSwHUbd4vysZ6/YdvsEiON9YOSoehrokLsJqfLuiv1VJ4F9afiajqv9y2wQs07YQTMNaRn8JoriavwtEPgGxuM/2yunUUSmFNhGm
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
that never merges. Pairs whose pages are both old before they become
identical fare worse: of 1800 such pairs, 200 merged before, still 200
after 256 scans, and all 1800 within 32 scans after.

Patch 2 documents how smart scan picks the scans to skip.

Patch 3 makes the KSM helpers in vm_util fail on short reads and
writes, which could make ksm_functional_tests hang or fail cases that
should be skipped. Patch 4 moves waiting for KSM full scans into a
vm_util helper, and patch 5 adds a ksm_functional_tests case that fails
20/20 without patch 1 and 0/20 with it, on both boots.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
V3 -> V4:
- Make the KSM helpers in vm_util fail on short reads and writes, in a
  new patch 3, and the smart_scan helpers of patch 5 likewise
- Add Cc: stable to patch 1
- Add Reviewed-by and Tested-by tags

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

v3: https://lore.kernel.org/r/20261107-bug-mm-ksm-smart-scan-align-skips-v3-0-16d5ce8b5fd6@gmail.com
v2: https://lore.kernel.org/r/20261105-bug-mm-ksm-smart-scan-align-skips-v2-0-8a9780b6844e@gmail.com
v1: https://lore.kernel.org/r/20261016-bug-mm-ksm-smart-scan-align-skips-v1-0-2f91d76416be@gmail.com

---
Qiliang Yuan (5):
      mm/ksm: align smart scan skips with the scan number
      docs/mm: ksm: describe how smart scan picks the scans to skip
      selftests/mm: fail KSM helpers on short reads and writes
      selftests/mm: move waiting for KSM full scans into a helper
      selftests/mm: cover merging KSM pages aged by smart scan

 Documentation/mm/ksm.rst                          | 16 ++++
 mm/ksm.c                                          | 24 +++---
 tools/testing/selftests/mm/ksm_functional_tests.c | 89 ++++++++++++++++++++++-
 tools/testing/selftests/mm/vm_util.c              | 89 ++++++++++++++++++-----
 tools/testing/selftests/mm/vm_util.h              |  3 +
 5 files changed, 188 insertions(+), 33 deletions(-)
---
base-commit: eedaa7d61f1ec8ae053a9ece0d553785350ac486
change-id: 20261016-bug-mm-ksm-smart-scan-align-skips-cd01e5a9889a

Best regards,
-- 
Qiliang Yuan <odys.yuan@gmail.com>


