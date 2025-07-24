Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FFF6C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 13:56:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C8286B01F0; Thu, 24 Jul 2025 09:56:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF8F06B02D8; Thu, 24 Jul 2025 09:56:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D980B6B02D9; Thu, 24 Jul 2025 09:56:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE6E56B02D6
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:56:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5B185803B2
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:35 +0000 (UTC)
X-FDA: 83699308350.21.4E7E945
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf15.hostedemail.com (Postfix) with ESMTP id 738F4A000B
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=WgnADf6+;
	spf=pass (imf15.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.50 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753365393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rl7MPjMQQR9YynEjNt+gG293fesASKmyZt5GnlBVdKk=;
	b=H3XjnMpXdzzSJo5kK2T2DkL/dXi+MGChYFCAclHVD1mBcy7rbVeaeRRrDwA9tpFIK7mlNe
	IfPgNpxRAcT1zAoHCsHLTEZHpRqinQiPp4DSj3XnxJWcfR4NmStYwKxQT3Fh1e66igWcjs
	hmIJ3CiALxK9T+BCCd/h9cmVZHrVwg8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=WgnADf6+;
	spf=pass (imf15.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.50 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753365393; a=rsa-sha256;
	cv=none;
	b=cMNLS7izfZEUU2qaTLl6yP+PULxwV4sf3FnuytbRGzfudgAcqqydIbzLgogiUy1x/SJ8Uj
	7OI4OEzzLWGHux48IFw1aIBlAh7LEQql8wSI88teHGMBqQ6rqRm+l3AkwAqJaxbGhtyFpr
	h6gGUWSj9EmjF49gQy+/1SyBNrZSKjk=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4550709f2c1so7761635e9.3
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753365392; x=1753970192; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rl7MPjMQQR9YynEjNt+gG293fesASKmyZt5GnlBVdKk=;
        b=WgnADf6+dZw+3jQNAd11lYEFqhKRRJHfBLHWoX5hKhGNL6eyq2Kq5Q9u190OH/zGW+
         kJ3nIDOy1JyoYfzTq3jOTo9b7qJ1scpuUl79mIK4J5vPpSS62wfbEeuWJSJvXiPCg8nt
         sKO66g7hv5lbVSFccSMX0+fMw9VtPoE8BlHNzVT6oYYm/Pi7ANE6HETPB/GObYC94xEV
         B+B6KDLeX/o46NWrzIDTKfXhuezivzmZuYs6+V2dK/a9A0N/npNPWSmlwW5x2l3VDBKl
         C+ywGRn7KisFzs1OG1UQhpRc5slAivNG1co/vnOyt3V54KjGPcmCIaLCsDhKc9jkzVeO
         I5Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753365392; x=1753970192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rl7MPjMQQR9YynEjNt+gG293fesASKmyZt5GnlBVdKk=;
        b=JphEM4uSkA+k+u8tAgwu0KbsOcZb7BS1oRk47TeT78MiWPbhLvLPlTJjADxHt7sQjY
         ScQ8al2Rd16HcVv8gHh+1xcIPIJG1cBtAhCdhMPe5IiGvcNDRJqgNkUZFlUmJ6bMuOb/
         ElNYRKKaItXLPIYJlAmOlJJul/ayXzEKgp6XVjPK9lhyhYBgc8XUXbm7LXDW0uF52EtV
         SV3QQBzH6R7pciTmpGCrL/cedtbELqRsEYUWowDP2cIL9HUvaPjX000Swb/4I3In8BAB
         siAUKW4CABUYtq+GnjPlUXeLe2z8oF502B4gNsxEicZOuOeX69Xs38egqZxUYIqkQdmQ
         A3wg==
X-Forwarded-Encrypted: i=1; AJvYcCXWNZXNYjFx5S9fhLGtKbJqS79yHWhJuaFCWSfgFm0hDhHe8NljITtAAHARYOt0hvzZ5pl2UBLD1Q==@kvack.org
X-Gm-Message-State: AOJu0Ywq89Lj0lYIppGeQTIbyLLqJOymwJ8BjoPO/crMRTvAtgW2nTpU
	pVSS8t1pdBzlmI+ArNmjnRO+TPWJz2OKAOp3WQHBTsnZlg1YwYshHYk0Z+hiSYlUIZE=
X-Gm-Gg: ASbGncvpQ9ASW/s2/V66k2/4FCbJq2yRY7QA/yfRrvaZ8AUtTXVJnmCoySkyanywVfS
	jSlpR54kktrV/YASvBbow0fiq11r9eIWdXFSu+YxOv5muDgxHZbMJaiiUbxhrVZN3oLNVq+oMzX
	Ib25xxELywqvkLWF69AfkSagB03bZgvViHA/5vHRlotUovtORdj4owuMcffk+EU+pCXSBMOlm0T
	eNigdCa3u1VzF74RqN1fgrCp2LT4x3C+U10ir/pm6YrMjxUYxXP3AXEwd/LGdzeD8RTiqnDWUOH
	v/nPvhHei13K4ZMz4PHufPwkdlmxlLIz8xbhhQ0Rr/BGVbQZmSOSA3dPM929Yv/F8jI+K/vJCLQ
	CyCwJIeh3EOXa925Kkn/BMDoNaC5J/SAsrb49Wq39TCdCddej+B8LG3328TltL1C9JK8/LNKP8d
	QRUYZVdDD1cHq+
X-Google-Smtp-Source: AGHT+IHonQ82jnLO0p5HYq/pDMzB+6N1t6DWFVzcA1CVX2U3nXqH6sJ8SaBoH0rb44h0xr8LW+w4sw==
X-Received: by 2002:a05:600c:6992:b0:43d:46de:b0eb with SMTP id 5b1f17b1804b1-45868c99c85mr63756925e9.12.1753365392038;
        Thu, 24 Jul 2025 06:56:32 -0700 (PDT)
Received: from eugen-station.. (cpc148880-bexl9-2-0-cust354.2-3.cable.virginm.net. [82.11.253.99])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587054e37dsm20889375e9.14.2025.07.24.06.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 06:56:31 -0700 (PDT)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com
Cc: linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	eugen.hristev@linaro.org,
	corbet@lwn.net,
	mojha@qti.qualcomm.com,
	rostedt@goodmis.org,
	jonechou@google.com,
	tudor.ambarus@linaro.org
Subject: [RFC][PATCH v2 11/29] sched/core: Annotate static information into Kmemdump
Date: Thu, 24 Jul 2025 16:54:54 +0300
Message-ID: <20250724135512.518487-12-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250724135512.518487-1-eugen.hristev@linaro.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 738F4A000B
X-Rspamd-Server: rspam06
X-Stat-Signature: 8ohpf3f791s14jmkkj16ujxmnxp4ugch
X-HE-Tag: 1753365393-971406
X-HE-Meta: U2FsdGVkX1/iKyXZmMOpUwC+s5T9rslKhRDcE1VsAoDo4PYGgJDA6D+taLRssjTK2DCLEGnkZ5y52XF9S44OEc+jDXZW+NhIYV6nrF7Dz3hqQy3x6EhOOlCjnVZHYctSlH+l0FISthT/nPmO9R9uuanRJ8jy3SHS7lXQLS8OVm2k9tRJy48a+WzRr6j4QycwS9iGnUPmQokH8N1aQOdu6xeyEkybnKv6YlC0uRJx0KaQTaOLbrfhe38a8bHVJb7iK08VaCB7ZQ7gSKWE3+5+YfE54/5VXdHuRWR3TN7fB3EofZy6cnRJNsYGmM0IsVybksqQDB45visuU9DRBAYqDPKPKLOhkBrm78nsR3XLGajbkXi1sb0DTLEauyKh/Ki062O1NOQh9LrD7ewJD0N3M8i9EEfbYQQueVexKXlqEjOzW+JIQdKstgZfcNynKicpnPJhH8NiIAuydY7eH4PPh9uWMhuo9lG01CALfAW21bIv2td/mENjgaFJgg2TjLbH1qGXVbqb1dRSfPOBVyxhSGI26uBqAiAE8bzFoB3rWhzG3PvDfZ8FixzIKKAlsOEwypKr0Us5gewv1ygihKLgqy2rdQkxtDr1XMgFE9Kzzigt/AjJXuzxS09YD9w2KKcpzc/R13Vq82nUck9OXV9hxlP5LtDwbBTliiFJ5OYQ5NA5DP6K4+wLm8M7JjQcIipoeYxYUkrHk/LUpqeLEps3OriIUx9/mGYoQyPmFJHm+7ngW5vhVRIFDOyJbK2mNJFOE4EgvNG1rCsUnJ9+NHqfRKxP+zUN+t9k0cn9CyyraR4Ked/DEzEjzyZit5j/JwQ37uaSEJZk93gtDMCeteOJDe0HRrgFTdITkCHPADqGXGbogMV0xn0UlN+8t4CWrgALyG6ROklJzNaLVjX0aVaXTcAaPm9oKAwYgW5aUBzPo5HzDNtPn6PByYGZu6UI8XmhFWjpf44z8OUY6w5O/PG
 zMnso2TB
 bba89UX5oqBUapooRNdkAf/dfLN+Pi32bvwfvzmHWfl7sEwtIbsZHKx6kzqv4CQF17QUS0cx0MLaXXRCeoJGy3ggmIW4KPeUWh1Vea3j2XWLRZj3TwAhU7cu29zT1N4K5akkVs2wHxTJnYHoOvk9rUEjM+F9hMaJuaclZQ8FziKulT8cs1x1NwqoJoB/hJNQJo/nvt9IsST+wC3ByQpBMwNgT2bm/eieW6AK5HvP+8LYTFI2O+t4DpeYhnioRt5q03m6pOTjM0CH6nLNZS1OgZAPbgLmFcHeQKzkSrOTBDMBl6mxhrAZOMDTBgJbkKlcgJeaGa2dN91erGbmFowXDPXTcaTjVcabpuP0yXR7k6fNHlx/09Guv8wMcwmrTG3uuqEOChRybukTpj0YuYHrWOuZZoQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static information into kmemdump:
 - runqueues

Information on these variables is stored into dedicated kmemdump section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 kernel/sched/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2343f5691c54..18ba6c1e174f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -67,6 +67,7 @@
 #include <linux/wait_api.h>
 #include <linux/workqueue_api.h>
 #include <linux/livepatch_sched.h>
+#include <linux/kmemdump.h>
 
 #ifdef CONFIG_PREEMPT_DYNAMIC
 # ifdef CONFIG_GENERIC_IRQ_ENTRY
@@ -119,6 +120,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(sched_update_nr_running_tp);
 EXPORT_TRACEPOINT_SYMBOL_GPL(sched_compute_energy_tp);
 
 DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
+KMEMDUMP_VAR_CORE(runqueues, sizeof(runqueues));
 
 #ifdef CONFIG_SCHED_PROXY_EXEC
 DEFINE_STATIC_KEY_TRUE(__sched_proxy_exec);
-- 
2.43.0


