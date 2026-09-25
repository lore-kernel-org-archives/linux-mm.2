Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 761CAC98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 19:30:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E6A36B0088; Fri, 25 Sep 2026 15:30:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79AAE6B008A; Fri, 25 Sep 2026 15:30:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AFDB6B008C; Fri, 25 Sep 2026 15:30:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A0CB6B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 15:30:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CC899400B0
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 19:30:17 +0000 (UTC)
X-FDA: 85253275674.07.F632820
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 06BDE40010
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 19:30:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RTC9Gu0M;
	spf=pass (imf01.hostedemail.com: domain of nsc@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=nsc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790364616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N33tIU6kIygB4VaarKLSX0TT1aLAq6k2sUWPy0f726s=;
	b=54R1pa2hp/g6fZw+sw/8hnQTmA3iBup8zpdgKjhV/i8DiPdGuc+uesW7NExeMv1Y7lHBKA
	cRzJvutDCXb9JNcYcYSfyFiz82i/YmOSXD+3BZiMbC14ujSOkClpSDnh5ypqVz30PEYxej
	IgbqBoGhmwJ1/1jwCF91i2dLQ0E34ns=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RTC9Gu0M;
	spf=pass (imf01.hostedemail.com: domain of nsc@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=nsc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790364616;
	b=Rj1X8RhQNPbWNyEkXW8kj5rfP7cQBV7ESZbCMv7ow5lxRP7+kwAWrXetoLNeSmDNvTKnz2
	8cuFRhwX0zHWZvVi+CNtTbRSozSQS0m1VsB7H+Lf9UW+//Q0SikS++iTzHROHJd4uT5xgM
	RZXBalfrDnMJmxRtHOnaeYi+YPljPWA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 22958404C8;
	Fri, 25 Sep 2026 19:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8A2181F000FF;
	Fri, 25 Sep 2026 19:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790364615;
	bh=N33tIU6kIygB4VaarKLSX0TT1aLAq6k2sUWPy0f726s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RTC9Gu0MrN5Xg87sZMqOE0Z3mbbvQY0/9wA0REwAIJQdcozHOCmPqrGXEfGInvMkC
	 vX32v5/xhxgdPSfTFOrk2J3qPyMaNQeVq+OAkPbpleMRJoDbvyYP6ydAm/PpdaGU7Z
	 +XBumrWmscx+B+WlAKKHaP59v/u27QXVv8qofSvwtYfNxNm+nMSshYlJ7lK2WlPZH4
	 tJAaB0av7CXmY7daGxq4Js7rugJuxbwErPTYBAEOweudczvXFKeVJ3cwfXcHQc7utQ
	 PevrKWCKXJ2MRmTV/pcalcQH/20TbgV1S0xbmp//M83zqQsULTTUMAkbOKDMlQln2h
	 iaVcnYRKAVq1Q==
From: Nicolas Schier <nsc@kernel.org>
Date: Fri, 25 Sep 2026 21:29:30 +0200
Subject: [PATCH v3 1/2] kbuild: Mark usr_gen_init_cpio as
 no-dot-config-target
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-move-gen_init_cpio-to-scripts-v3-1-99c493f76722@kernel.org>
References: <20260925-move-gen_init_cpio-to-scripts-v3-0-99c493f76722@kernel.org>
In-Reply-To: <20260925-move-gen_init_cpio-to-scripts-v3-0-99c493f76722@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Luis Augenstein <luis.augenstein@tngtech.com>, 
 Maximilian Huber <maximilian.huber@tngtech.com>, 
 Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
 Willy Tarreau <w@1wt.eu>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Askar Safin <safinaskar@gmail.com>, linux-doc@vger.kernel.org, 
 kexec@lists.infradead.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org
X-Mailer: b4 0.17-dev-1f2f7
X-Developer-Signature: v=1; a=openpgp-sha256; l=1061; i=nsc@kernel.org;
 s=20250924; h=from:subject:message-id;
 bh=zT252H2Ho87u3KEN3XgUGqqVJMLoiJ1cFQMrKMVc2VE=;
 b=owEBbQKS/ZANAwAKAQdSCnAWJhJpAcsmYgBqtsufsfYeYT1sBDoLauwLKFoPXwsN6+APpXnyU
 o+A0B4KUOqJAjMEAAEKAB0WIQSHQTenhzckp4G+wsYHUgpwFiYSaQUCarbLnwAKCRAHUgpwFiYS
 aYOvD/4ygVvWdPjef/U4fr0RFblazzSSsOqSdO+uo2M7hgRgpunel7QTDmY72T8zjdamYOj0Thc
 6h6zpfP5PJXV3NQY2CW+2iYMtEieWxmXjAYuC6TrZfUiIbtbDiia4da5fD9j5tH1UVpAzX3+CRe
 BktrH22N6MU37cUWzryZ3AK1h2RM8WZWsaV8dotOtuak7tv0aR25fkOXyK+05O3ZLWA0croK5I+
 syqnd5BB7nyb4J9Ru1KWd+DWIEXg7ZUZ6HOuWvDF/Y0JOpl33FZdo8iDHhmvcljfqVNqr4Mbm2B
 Z5uU+gGmcluYOGdxsNZZI0y86+WPKfC7CVaxa3jtpFH/JQncKx7VGMlZpGEUh9PJszty+qe+d+S
 zmPmUO8OQjkxNHKbf/S99ihrfMouqV5PgjvAkfuHQ6cUPUEYApm339iJzGqkI/nUAGPrn+rQzeY
 zcXnYa+PBq94VZpo53cAFdl+P9U5cCLuCap7GfGDVdCVORjSPZNYAO/0OS8z+qz+L+Fu+BNjkHK
 lBoAHwFGmpBMXvY9oSSpWKaU5rKzwNfckSVkJ+GkNq8ZobeFjQiG7xMHRy1efPx+7eFGb2APolg
 tsKvJUd3i1eHI7PyZxr6P6ugoRT0r8ppOLfXU2rmh7dY3ZVdaqfMJPUGPTXs2sBqs+6Y1aSjxY6
 bh31QprBv3oFASg==
X-Developer-Key: i=nsc@kernel.org; a=openpgp;
 fpr=18ED52DBE34F860EE9FBC82B7D97093255A0CE7F
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 06BDE40010
X-Stat-Signature: d1u1s55ooswazfqidwzdc6z74jx18w6s
X-Rspam-User: 
X-HE-Tag: 1790364615-284898
X-HE-Meta: U2FsdGVkX1+3y2KxJJzS3iE3Tv82iMJh76sk89kFx6D/66TWEOkbW5t5nee3XNJscZYod2jW1mAG/MMx0Ur2E8faWaBTT2GTlCqY5ZvP40REwm5C9z7ToY/Z7GeOLmLo3w/BArHOZGFQtaXKJ8T1OwRN2FPD0xM51Ux+lgLO3Hq56Q8R+M5gcAbtgq/2RUquIJxDEtQ3ApDgNLPhIQ0oQTIncbEJOauOW+E3l/ilacVCVIb9Ye/xHgtkrCsZOHPVFb+ULY9vVgHRqgZ0sOYHH5tktoY1WwK6g1hWAUTqg8iY3TMXwHuHR0arRPDgWLOHiSs1qa4vIcABv6n9RFC8u1x7o7zz41p3ZhwEYMniGWnC/SDI0mCz1T/4OiYKtBXN6PW95yxep+GkpSyG967KOw8PvU0rO1aTOXySA/sXA6qPHNLJ2TrgEavfNEjY/Y9hpX9OLMhzIQ4PKzFppe4JQiBswc5FrNwxIyiqRqpUq+yT85cnyerUsWpV2q3DaAkBNV9wHx/3GBQRZCPKD61YbsQkG+0s9aylwc10mnQnPbYzzgMiiRm2n4v3HyqlCOzvPvd+6r+MxrsjiK3uizanqVr/LQUj9arYFnqtSwJCEDi09Xqst2+rhapZ0OxCFNvSYTmSO/qLlnXededVcneMq31OsuGzb33CNxB+qTKghARce1FJTRoZg77WRj+lsHSqOPILsqh+Q9UfPTk5F7bYSTg4wlGaGw/IspTxSCgHF8bpxkpKuc5ipmEzdoKxI+wuiTKDryLRdkeY010XnAHel9H/UVOUdJpO8Dh3cIXPwAhBCivaHjk+t286Pj6NSoVDH5rVe5ahz/vsCKhTWRTDHScjNUfwx7Imw5LW5PJKWMsk8i6dj5MkhEBEg9hMFuY1kjJLFNgZ2purjTp/mqOxWaduFX8atxnB3yaSm6mLy25ij7/Hg2q8EvkXRsAYocSUoOqzbR41PLumDJfqqF7
 C6P5sqA3
 zlCvYql/LzuxZrbp1ol9O5T+wq9dSDVZRzVR9f5TLvktHehBPmajkR+oLlo0/9SFNAoVWdXjriqqqNrXUqml9XBZHDRNgdygw/Se+yXJeCgjq8NROXi24UkFrUlsqvf4bFf9gAzQSpl8WF9emfU+m2kchdbkykH2Ap0/hccde5J3GiyRejgyfpre9iJl+NC+8cZdRCfdxT4X/ymQU+zR1X12CSsNVjLcPilFxkvfejynXkti+z/MrDo5q7XT7xPls1psxWbEVoJoliQITFLqdO3kPtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let usr/gen_init_cpio be built also if there is no kernel configuration.

Askar Safin reported that gen_init_cpio may be of use before any kernel
configuration is available.  Add usr_gen_init_cpio to list of targets
that do not require a .config file.

Reported-by: Askar Safin <safinaskar@gmail.com>
Closes: https://lore.kernel.org/all/20260220191150.244006-1-safinaskar@gmail.com
Fixes: f8e05c10631e ("kbuild: Add top-level target for building gen_init_cpio")
Signed-off-by: Nicolas Schier <nsc@kernel.org>
---
 Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index 751a08643bf8..51fada9059d6 100644
--- a/Makefile
+++ b/Makefile
@@ -298,6 +298,7 @@ no-dot-config-targets := $(clean-targets) \
 			 %asm-generic kernelversion %src-pkg dt_binding_check \
 			 dt_style_selftest \
 			 outputmakefile rustavailable rustfmt rustfmtcheck \
+			 usr_gen_init_cpio \
 			 run-command
 no-sync-config-targets := $(no-dot-config-targets) %install modules_sign kernelrelease \
 			  image_name

-- 
2.47.3


