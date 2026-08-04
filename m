Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89909C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 20:06:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 976C56B00E0; Tue,  4 Aug 2026 16:06:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94F486B00E8; Tue,  4 Aug 2026 16:06:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88BB76B00EE; Tue,  4 Aug 2026 16:06:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6484E6B00E0
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:06:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DD970A02FE
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:06:09 +0000 (UTC)
X-FDA: 85064668458.23.129CE4B
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf19.hostedemail.com (Postfix) with ESMTP id 417941A0003
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:06:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cUkCVqFD;
	spf=pass (imf19.hostedemail.com: domain of 3LkZyag0KCN09AGHRGDJA9O9SFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--abhishekbapat.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3LkZyag0KCN09AGHRGDJA9O9SFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785873968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=eQhbFyKvr/ksFI2xyvWzjFX+sMde4ZiHz3r5KlqPdxA=;
	b=ygtUZCyiOLZ1bDWovfa7tyMqFxn/BjMtEJgEq6YoCXk6gEITrMdPEnXJrPkytXT3YYV58c
	bx+dkAcwrWbPXGFrxzKOaH2PGV9sk6eejR0PUjrpJLZlR+Bt2VnUOBEJq0Z4Rcofgkd0mR
	7fgPQ80MojAPFReZO8lyrTWXP9568LY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785873968;
	b=zfGq1fGRz9fMo8zlLVyiwxhsl66eS/c0EPgxXMMk8pB+tfpxIfBOSMQVyImZlTR3CH0WIR
	BDqGxkg4LFxlc00/yh8uOT64XBRmexnzBjmI899tq27mjEoupppzbl1AlSSFfzO3r3i4NG
	rcNoomuq99tcx8PvQeLqTdkK2AKBOkI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cUkCVqFD;
	spf=pass (imf19.hostedemail.com: domain of 3LkZyag0KCN09AGHRGDJA9O9SFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--abhishekbapat.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3LkZyag0KCN09AGHRGDJA9O9SFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb6ef846b33so165849a12.1
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 13:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785873967; x=1786478767; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eQhbFyKvr/ksFI2xyvWzjFX+sMde4ZiHz3r5KlqPdxA=;
        b=cUkCVqFD3YRH0pm01QkLKL2lBqyGGgUaa7g0lq4ZjGQs8ntt0U7TttxCdUD54rX3iD
         dK6ySPzRQovZdumxqVvvnHGFn474zmfMLbdZkpguF/fGoqq6bilCVkVhKdB0qRiScmwO
         TMb59f0Ia4+IYqrBXm+Wcy64KQa32eeYrnJxKlKhT4UKx2vSRaeD7eJqU+G+BJoFvZAk
         V3ak4n5/ZqVn/mHLtjNkUJZpapFoz2KMhoODFEaxHIFdn2JwT9wULD0gi6szOAAAZMpM
         Qo+Sc1fShu5AB77wHk6xOTg+YAyCI2ZC72zFj0KqFPQHAelyhKdHFWsc+iKzZFtOjaCF
         DCAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785873967; x=1786478767;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eQhbFyKvr/ksFI2xyvWzjFX+sMde4ZiHz3r5KlqPdxA=;
        b=s24QdahSmngGrbTWTThBIecQdUbnTHuRmbF5i7XbXcaqTMuwoUiDGSasXQSMp2thKs
         f9IUvU0xHQmjq9Tntc79r0gPZlxub2QSIwXmngvDU6L6uCZF4xxcknl+pB9fN+l/362t
         L8YU4T5MRg188TgSslUxboEfM6lfYAoo3Vr0ySDLb4+XKvwHpFBoLMrNJKgxxxQKveM8
         gJ5qO2edNL6jqi11VWv/r3z1gaf1g+OLqM7XxuqjXtjGOodNydzyh0rS6Rjqhm5FHuDr
         LAS2YCPd1t+BYRGFvBHMQHvex8rGccOr7UvNVnkHzexDGsWUasA0cWh5t//SPgG9gPWI
         nUKQ==
X-Forwarded-Encrypted: i=1; AHgh+RpY0OYsHODStRRA+XyWJyqP4waVAI929UrZMF4q2fvMidLK+PHZPLVuWW/jLBfyXi1blcRMVOKKQg==@kvack.org
X-Gm-Message-State: AOJu0Yyro3MoEwiTU/nYyYaGc5I6Sz8cBu4XzWGnBnlDb/TDpePDKYrY
	HIaPLPpFh+iBDxSMGCZF2ok/hHWa+YPspkot0CyEA/FIeZkPx8DRmAGdR6frszeMii2YivSMw1S
	yJslquFnNV8LKcC3mPdTxytjDLh8hcQ7DlA==
X-Received: from dycjx24.prod.google.com ([2002:a05:7300:fd18:b0:314:7337:26d9])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:329d:b0:3b3:3506:cf3f with SMTP id adf61e73a8af0-3cb6c7530abmr5445770637.1.1785873966841;
 Tue, 04 Aug 2026 13:06:06 -0700 (PDT)
Date: Tue,  4 Aug 2026 20:06:04 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <d779f2cf4105448e0fb04eeab82acb20dd05d6ed.1785873902.git.abhishekbapat@google.com>
Subject: [PATCH v4] alloc_tag: expose boot-time compression configuration
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Hao Ge <hao.ge@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 417941A0003
X-Rspam-User: 
X-Stat-Signature: b5xspg8w41m73bea33ymhfebg7im1kck
X-HE-Tag: 1785873968-237199
X-HE-Meta: U2FsdGVkX1/PYcD17or9XJuA6ySEmFpMX5IUZPqOktLU8v1MsJNzVZqfVroze5E3ZFfk2Ob0Qlb+bczZ9bBZ4yNfH0aMWmG9jKza/jaW307DPysM7rvXCMKVGGBDgGaeYMCMWQ8IRFolOuW4xTXmY+xomATeiL6ghwU7SudBu8Rh6CHfgZkbBV+TZ/5Rs9ry00C7er3DT2G/rzAgDf6gfLCRqbDuRRM0/KPKlrb6STn8TPvK1Av5crgsK8dtqWGkA4MI+ajmx5PwlfW8HWV5qoC1AqkbFbCldF1CBYTuIm5I3BNLhOvlc+9kFmxxy+eJCNbEg0mmvnOfIk0Mk6q0GeKx/2np2AARAWStk1VX76fk1XzEWNoeFdlW3Viq4+2vkUVBUFo0KoCnZojAKwmjbW1rn6ZWOFU0D2LAQfEZApC2Ga2TcRRbzsR8bQhDKTzqqaClTdH/EPk+38J7U14Lo/0hFtZrCbw3GqV2ymieKPbVFhbSWSMUabbliJ+whIpCT0TufMdQYoukEp+BHrJjiZE8dixNl7D2e6YUEqQCcdF8E5vyQBJct+tC5fjE8C0Pt2uKUrjnDEgYzMSmU7ycqkgRoPGtcVvMfFFarnfcUaMjOAsVnqbWZecJeV+IV0vKvBbtFpWCr35bgODfwWeiRXmG8iGgn/wU+Ew9Uyv6zwFUSU4/0MBRlLi1q88Nk4MePVpeof7iRdx3+0xTteZ6iw8iE7j7ZIrXCLcKpimVQC1oet5t0PQztSiuymOwjD4tdvrzAkYqTO/FcNOxKNWkSXItFhWM/5zN8P8U5V6jS40MFW+tqB2xM9XDPFSVyUy5C5eGl0eccN/s3CntcHzu7AdzuiWYwPeGLA9Pq/nZHcD8kLDQ21y8u5xkWZc0e7Jb/fvLuXSQRDBiLJQcP7xnc7Jlq3JIs8qz8iajZsrIz6MyrcC6Y0iO0u9PUqz5sUOn2e3wnZn2Z6wZ23TONZK
 ZPfN7U8m
 oZ1aG3Vtwnn9XJquvKHe9x8nbaJEemj7GHW8/MN1HsSW/Oso24Fq5P23DhgawUkfWk5owcVENK4Pd71tJVkCeTXpealjpAayC+4LJQdoBStGBL4j5rEVuotDwe1bZeVmmtxEAi3HoJcF9yZrhbadXEeISNr21HY5OID8Ah2R9GJMdP1TLbdL2FOhOUKV+YbXHd2X4joj6b1iAVelQZimSsKu8kTHuns8kOX0lnCq6VaQNrUiNzScFBIpJxsn8Yjc4jOPQ5m1oRqF44qVp4/Cib3X7iEfmuYPg2X/KaTVk+rE+D/Ai4+OoSU8zCW60FiYwKaXs4HixVYTzAk4zCKn+pmHhrRTdPa14seon8fegiy+jehEkf4Dm/QejxNRtz59IiMW7Hy4DeI6toXSwNV7cihVuFsH6FV53O9Tsn7/5lxUQP42kL7Rj/sZqDZPrgQO80etQAvZoAP1Yolv7oY7JzHsCuNfoIKzrmnOPz9nWpL0d9YR2SQ2rj8R6V4+7LtP0+vQ5LSodWD8dIbS3IgE9DCpXY/XazgI5L1H8IFaVFqXLUMttIHOIPAdegC+ucJGSnVPFTOgIfRGZT7TENChyW1UI6o16Vs2CLn26CzKr3FD70GTk/WB51kES+m+Xj03a5QuJmXMrzoMupJEUi6xgI0Z6q6xcS7UWfrV/o7AkAHYca5w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, userspace has limited visibility into the exact active
runtime state of memory allocation profiling and its page extension
compression ('sysctl.vm.mem_profiling={0|1|never}[,compressed]').

While reading the sysctl provides basic on/off status, it is currently
impossible for userspace to natively determine whether page-tag
compression was successfully enabled without scraping dmesg boot logs.

Resolve this ambiguity by exposing the active compression state by
adding a new read-only sysctl `vm.mem_profiling_compressed` to output the
state.

Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
---
v4 change:
- Documentation and commit message refactor.

v3 change:
- Added documentation about the behaviour details of the new sysctl.

v2 change:
- Moved from displaying the state in /proc/allocinfo to a new read-only
sysctl.

 Documentation/mm/allocation-profiling.rst | 11 +++++++++++
 mm/alloc_tag.c                            |  6 ++++++
 2 files changed, 17 insertions(+)

diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/mm/allocation-profiling.rst
index c3a28467955f..f28358af927a 100644
--- a/Documentation/mm/allocation-profiling.rst
+++ b/Documentation/mm/allocation-profiling.rst
@@ -43,6 +43,17 @@ sysctl:
   warnings produced by allocations made while profiling is disabled and freed
   when it's enabled.
 
+  /proc/sys/vm/mem_profiling_compressed
+
+  1: Page alloc tag compression is enabled.
+
+  0: Page alloc tag compression is disabled.
+
+  This reflects a static boot-time configuration of how page allocation tags are
+  stored (in page flags when compression is enabled and in page_ext when disabled).
+  Toggling `mem_profiling` at runtime does not change the state of
+  `mem_profiling_compressed`.
+
 Runtime info:
   /proc/allocinfo
 
diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index 52aece27b00e..877068241f06 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -1303,6 +1303,12 @@ static const struct ctl_table memory_allocation_profiling_sysctls[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_mem_profiling_handler,
 	},
+	{
+		.procname	= "mem_profiling_compressed",
+		.data		= &mem_profiling_compressed,
+		.mode		= 0444,
+		.proc_handler	= proc_do_static_key,
+	},
 };
 
 static void __init sysctl_init(void)

base-commit: 486855239e38a91d3eae26618ccb7845c1764625
-- 
2.55.0.508.g3f0d502094-goog


