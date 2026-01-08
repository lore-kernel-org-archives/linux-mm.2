Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECFA5CF6AB9
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 10:16:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 445956B0095; Thu,  8 Jan 2026 05:16:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 419A76B0096; Thu,  8 Jan 2026 05:16:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 333016B0098; Thu,  8 Jan 2026 05:16:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 208086B0095
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 05:16:18 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A8B3D59DAA
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:16:17 +0000 (UTC)
X-FDA: 84308391594.11.14D040F
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf12.hostedemail.com (Postfix) with ESMTP id C3CDF4000D
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:16:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LiYSBjWe;
	spf=pass (imf12.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767867375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dfFwLlC3N0TVxIzNvzK+kY/3KKp6vwFx6CZlJtWeVto=;
	b=ltdMhwgDNm0PybUcrFgWF23WQ4tnEBnul8U9Go9zkV8Hbx238cWmiSYcOxCclEz6GwOgdy
	L1QBYkK9oRB3cc9w9joqVxuIb+vYof9ET8QjiWAvxHesR/f6O34mJtn/fOsYy0ZCUpRmui
	YNIqfhVWdm3lp8JVE2RdSzxup8XIir4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767867375; a=rsa-sha256;
	cv=none;
	b=xglp078sYrFYTJQu2or4cCU4V7OE/HvDmZDtZCXNtGnfoWz6W9FM6N1KIFrIc6Y9Qr7nDy
	XJocYvf7LqMrHSWv1oiilUmJKQXI++qJjVNEKZYxHaOj/vm4l8cOIUQe+t36gPakj4rOi3
	F1g9TeaPO8XTe87ozzJtI1EPvDCRJHw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LiYSBjWe;
	spf=pass (imf12.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2a07fac8aa1so24852975ad.1
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 02:16:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767867374; x=1768472174; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dfFwLlC3N0TVxIzNvzK+kY/3KKp6vwFx6CZlJtWeVto=;
        b=LiYSBjWehynjwlvl5IpaCjCD3bbKtmjiDGImh7JdyUk/iY9AnybuWVEo5vTrFGOC4l
         sBkB7Vux9+3gMiVkn0wtqa5ey4Rdi4kmXGAgLMrzPHz8myBFiDhg1E6fqYjt+A7n4Y7b
         n8++CSsdrtAunhQpnP35Ee4c971uFlLneBD3voHLROUteCgCsPlaLzfHin8kG0ag8geR
         ieBwmX4Y9t6Agwu/SiAc0sqRAhdtxOfMUcDVQV9p1KElkpHaRlQ6jgwS7Fq0FOLe1c+d
         RlH5etAnfValae/RDK5y2BRD9pggSCDnPQ7r9iCevqqv4bNGYja2LyXrqfZtaWbbuDwf
         M8qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767867374; x=1768472174;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dfFwLlC3N0TVxIzNvzK+kY/3KKp6vwFx6CZlJtWeVto=;
        b=k8Gh+JGU9UodmXKCrNhOem1B8vZRGYas/s2tO8KIQ4O44uCQuHdM52RbctAumiXSFp
         Yx0mUp9036rAq29ljSRmECEjy1Mi/B8GdQzodpOMgs/1mR4OaBijfGxvPJybPvMYh32P
         VhveTdD6Av4EpfnA62QQd4f9BCv/VZWufKlpqOU2PydLPh06MkPvFPmLTVGxqCbwoZ0/
         jQkZIHFxLRisSF41nnY/laqJqslp+aBiN/WcOiL0+tgyVcuP7NkAIfKcK5yIPSxpNpeW
         23e/1vzY9Uqid9mfKYYm88DvoRb9M7MND0KBXAL0cLzmmrqXcMUTPIGQqI1skrZFt02g
         QgTQ==
X-Forwarded-Encrypted: i=1; AJvYcCWfSpm2Fs/LwDn3uI7sqLqD7iE9P2OEpoKe2wrcCjz86HSdGKzTdIAGjMincRI8UtgShlgsRd/xlA==@kvack.org
X-Gm-Message-State: AOJu0YwRTl9+CjeOCsxrutxzbsOnPPy7+X1d98hzZNVCNUvwQwW70C+F
	d9wZIHTPjbQ4/s+hQiy92CkVmFvxL5AOxP8bITY8qt6TcHqbBiSnxQsa
X-Gm-Gg: AY/fxX7OtZpSL0LnNBI9dn9Lb4As4N0dHZ4xBUVtC9iHl0R/D2nEXKYI9VcsBndSj+6
	2SiWcHrAC6FvTxgtkalPzFOM3ctP5wno/F/rqsWNJ/tCwQB7VuO+lx08AOgdhPwQnH/4XG+op8k
	8JXF3Ld2f8D3pGZSWLzRSHNU+Rwtib3CylDlVkgCh7ruPDD+5bNO5POU5UHnfDUyBZcs06vJsvR
	4jYbgR/EDwblXC8YccS6iHoAxrlORvxa43xfmvaVNzoEEhc4dUsz0oC4W+lBPMkYy4dH+S3IOFM
	4oOu1oZO0a8j/BOZmWG67Cr1T1QyClZWzOfQWUqSoljc0xI7rJAWpGHn+8+eI9j96X71/5jS3Vt
	xIHaIJP/EFxk+2bef9vUMU9lywBv5RGnoaxNiVv/aPTk/C+0XmiodL6UC2Xl17eOQlOwFj/b4di
	yo0LHcTPIVIU7oDKKGZ4s1cHVB
X-Google-Smtp-Source: AGHT+IGox+E55AcnFF0JcQGHkGkBa2XTHv5X/Fo9zj4DPlIf6vmy/GfrU6ehPXT8j2mvIbbMcz5iqA==
X-Received: by 2002:a17:902:daca:b0:295:8dbb:b3cd with SMTP id d9443c01a7336-2a3ee460c5cmr45231575ad.27.1767867374481;
        Thu, 08 Jan 2026 02:16:14 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:8352:dfa:3b18:eb4e])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3c49299sm73785245ad.42.2026.01.08.02.16.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 02:16:13 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: akinobu.mita@gmail.com
Cc: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	bingjiao@google.com
Subject: [PATCH v3 0/3] mm: fix oom-killer not being invoked when demotion is enabled
Date: Thu,  8 Jan 2026 19:15:32 +0900
Message-ID: <20260108101535.50696-1-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i3g3mndbnzy9sjnkaoq8ku3jtzfdk6j8
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C3CDF4000D
X-Rspam-User: 
X-HE-Tag: 1767867375-700910
X-HE-Meta: U2FsdGVkX18KrJwPuLLbyZRGfIvvNPcl+aP13Q6nWOzd6kkLGDSxXrdL2TXQS/xLpnaK+fShmSCtaTOsopiSoBUkNXPgDH+puVosCvv3cqrr4fNxZUfCEm/V7HcfW9q7uqVwiMxgjHs9calEyp/RERaHhk5qdMJ7ZViRxWohX1YNmT0YZa1vA+demZHK9h1A1VeATtx9KnS357tK/KeX4uBLzSIPj3o76SwddHxyF1C4HIsH9nzVf4JqeIEXPOY84XpAnCVCn0IjlzrjdefI2ZEi4FUD+9s6w4tGWG0VgcT+scivF3ZKhIv4tDNPO0Oir/jLATXAyG2VoUYXTi+ryuuvQqudNCO8++dEaszV6GRzg/Bg74gabJCxy77YbdxcZL8Z6We4bO3wljbrrT3Sxvo6Jlm9+IBZs0MnF4aZk+7hs8dFLyF5Cy9HKHIcxKxkRrORLXPlu/6v7nO2HdDlCsPdr1ov5yPBcgBZ0eAL1yoreEixSvKCUIhv/FFge+m9JpGsJU4HrcaeEJDBGDoLxKBNExGQ86+/47wQhX9gSpwoByvq3Y9Lq4isnqWKGqAMHuS2Hc2N9HK2UcU3weJN3eoR13mM+eglOmttl2iXf0XR/ldbFdjM5I2s8bEiZUuSa+c/VEIxrX67KvgRhow9pS0ZIvnnj70qQBPBY1N1T2QZv71V9vZ7OBKgbdb/g0VGHnm9xkabz/jVwLAcnjr5woYXEBuNwMb/3Z824XpQrGcX1zbrWNeysuz2F3If+90/vp5J+zuCT50zVIUDlrBjO7Un9nPZYIxMMNtPgO01N5NyhJ4Aa3g7ClkSc/M7/viDULHFKR9vAs5H9lziP/h92GmDryZg0C7Huv30LskSmB4PkvugNXQuSBPR1f4/XFUl6Z1RN5SPEzgemtHH6FN27hBJgsFCrtt60Z7OL8rBf0vr34RS2i+v3lo9pBVwyCrvc9hEokrGmIGuniwHelj
 /xGQYAmC
 TTRJ45fDO+84TCBaUjrHL7fR+/ti7ucRxW1gJE9CBFCBVgLcOU7+dw7Vy7Q7yOF3sVrgtI0devSMelmSzeMxjr1jSQ5SYQhCeIJuAiNI7eFtFucXXfEoCLGDRNA1mUGGUEOTH3irOxM37FKbJ35KDGKPZeuFByuCWYfQLobV2mCN8oI+EPkfjuYUJCGKVevWyexdt3/sxPiiO3Q3X6WbbYTTE96ebffKAnEUc1gTUr/8WQMaa8QG+Se6lyy1gsTLRcbHe35ICOLk+qyFzYluALsg2IRHvjE/K7jXQr0JUycpIFY4YiNIv4Athdt5M+8x9i0/vLVOMQ+7tcJbSsTtv+FbRjch014cenedXK4QqJp1xi69e7xwkkGXNHQLkj6eIjAn88sOgF4n9mQ48mrziHaFTe+zlkvGjCD2LKrj6vK/gokeBbWRy58yRWnbxNuGxOyEMk50coZgGOm8pAMlb7d+u/dQKB9aPzeLDef0Cn1t4zo8IgvwY9GWlu2UxifAI4gB5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On systems with multiple memory-tiers consisting of DRAM and CXL memory,
the OOM killer is not invoked properly.

This patchset includes a fix for the issue and an enhancement that makes
the issue reproducible with numa emulation.

v3:
- rebase to linux-next (next-20260108), where demotion target has changed
  from node id to node mask.

v2:
- fix the explanation about cmdline parameter in the commit log
- add document for NUMA emulation
- describe reproducibility with !mglru in the commit log
- removed unnecessary consideration for scan control when checking demotion_nid watermarks

v1:
- https://lore.kernel.org/linux-mm/20251208094028.214949-1-akinobu.mita@gmail.com/T/

original report:
- https://lore.kernel.org/lkml/20251022135735.246203-1-akinobu.mita@gmail.com/T

Akinobu Mita (3):
  mm: memory-tiers, numa_emu: enable to create memory tiers using fake
    numa nodes
  mm: numa_emu: add document for NUMA emulation
  mm/vmscan: don't demote if there is not enough free memory in the
    lower memory tier

 Documentation/mm/index.rst          |  1 +
 Documentation/mm/numa_emulation.rst | 30 +++++++++++++++++++++++++++++
 mm/numa_emulation.c                 | 26 +++++++++++++++++++++++++
 mm/vmscan.c                         | 16 ++++++++++++++-
 4 files changed, 72 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/mm/numa_emulation.rst

-- 
2.43.0


