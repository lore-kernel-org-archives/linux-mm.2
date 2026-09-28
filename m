Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33A78CA5FA3
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E3756B0088; Mon, 28 Sep 2026 13:27:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BADC6B008A; Mon, 28 Sep 2026 13:27:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F7A66B008C; Mon, 28 Sep 2026 13:27:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EEF7D6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:27:36 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 81B1E160284
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:27:36 +0000 (UTC)
X-FDA: 85263852912.28.AE458C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id CD139160006
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:27:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PMF4MzQQ;
	spf=pass (imf08.hostedemail.com: domain of nsc@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nsc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790616454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bYY6SIuB38pNpvOXnuI019MieEUYiynUJJ9aqYbDrY4=;
	b=pXKZzZheubmBONSCj9JASf+yub/XKU1JiJpi6XwchZg0Z+s9tcc8x6BelCx0nga3voAqcP
	6isR+T7McrG79Gh4ecZBQfS7dfBti46HJSZCThJLJ4D4CJHb1jNSU8Q3DkMFUNr234o8VG
	ef1BcTKMG21I7wwNknYrxM/LiGQJe70=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PMF4MzQQ;
	spf=pass (imf08.hostedemail.com: domain of nsc@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nsc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790616454;
	b=byZnbWWuVXf94piPT0DFk56UOYficfoINSYL68JXVFWyRO4mudJ1hDh18EVAzFeNUx7RrV
	vINteHFinnoc00RAhySyB63xqIPFDaNo96lEA4AlOs808qBubLhqmWUQpB4LzDS3Dr33Za
	YvZ7OvjUaFLqsLtu7FlQhaZxj/UhTv0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 1B519600CB;
	Mon, 28 Sep 2026 17:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 555441F000FF;
	Mon, 28 Sep 2026 17:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790616453;
	bh=bYY6SIuB38pNpvOXnuI019MieEUYiynUJJ9aqYbDrY4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PMF4MzQQaBO1S123rLATz7lD7J/3S79MF4F1iuNOzs88eZr9hChaxqvOeeYV/q6PW
	 CUo5hRjsrTwhTnA9VFnZ/YLT1rAS/LLuWTfTi+r321ElD6RZFkwxvOrxqESVvkX2G/
	 rkXOaNGG/CUIhSvkIkBhNq/hbUZy8jgWYxVZc5ErX+du+7cruK/f9tYoyilePUgOuM
	 KTjDceMzVZVR/0cRH5EAtEZ4BIsNS5DJ6H7bv9NMP+b4dRzdsAFTzDG6a/jMebFu6R
	 K0J0VS5ArMRQARYfpVFXhnCwhQNfiF/fu+52s5O1LxcAOPLZuOzEVRHNJn2CzkyzZ0
	 ypIUc5Ir8JYuw==
From: Nicolas Schier <nsc@kernel.org>
Date: Mon, 28 Sep 2026 19:26:57 +0200
Subject: [PATCH v4 1/2] kbuild: Mark usr_gen_init_cpio as
 no-dot-config-target
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260928-move-gen_init_cpio-to-scripts-v4-1-f437a33c40ac@kernel.org>
References: <20260928-move-gen_init_cpio-to-scripts-v4-0-f437a33c40ac@kernel.org>
In-Reply-To: <20260928-move-gen_init_cpio-to-scripts-v4-0-f437a33c40ac@kernel.org>
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
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1117; i=nsc@kernel.org;
 s=20250924; h=from:subject:message-id;
 bh=DREW0pnsHVnYIRYZJD9DChr73EUt3Hcbs4tKegeuVNU=;
 b=owEBbQKS/ZANAwAKAQdSCnAWJhJpAcsmYgBquqNnSXZkN50m/3I+6jr4xgQZQchL3CmlL4kEv
 i+EigEvgyaJAjMEAAEKAB0WIQSHQTenhzckp4G+wsYHUgpwFiYSaQUCarqjZwAKCRAHUgpwFiYS
 ae2zD/9RtzfbLSq2k0CTp9fSMzaHgvIq9PoA0g6ReAplrJoADU/2bqSjWLjJPd5c9RuqfuAHgp4
 fHW7Kc6on2hwnObtpbvt7w90j83hS1KOni88O9ez2ACmdmYyz7ZuQYbtDw0TqFgP3xz8lJVorTv
 vtsXQS/7bIVX4rhIY7CX41T6yc93jsVHgMOuXgyBjM/dPRWXJpWTysvgRBrDFRO9z+a9QEOJXiB
 V9cbYfZAGpdKHphXhOlXCpZG0tftpvv6FUv/ruB0VBSJS9WccGl8dZRdCrMnCHS5Yc3iqNxhuua
 GMIwwaxiHufFAFS3BDQOHfd27k0t18Kx3VT3hsam8a2bp+3Ic8uMWB15ZbCatgalDbIufOAt59R
 kR3fSmYKau1A52n8L7ChcSV8vFhkMBkNoclyibapUbreuliExvScTFXtUHPa9IBF/yYVsd/5NT0
 gjaYUihtoKQz0jzX7KZKLPzxAVLD8C7rCcHT6Wko6YgDFUJNSdPubrLbCreF5aRTFsZsUk1Ph+P
 yqJwaam6eZX2Q18p+BLbEvYPJg6A4PK1ryUh+4HRzeRAVwvhuE5uyRugm1ihl0VSC9JNfMrYudt
 jQoY9lo8YjCTd9IgJHWtd+H1IjcMhmG8we+W5Wui3EHheGGBmvXvWQoWIYhkrAKB+ly6TwAlCdV
 Jqz/BL+0xKqSI6g==
X-Developer-Key: i=nsc@kernel.org; a=openpgp;
 fpr=18ED52DBE34F860EE9FBC82B7D97093255A0CE7F
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CD139160006
X-Stat-Signature: 5fyrdzw6srz7wuzywqxoidigfhcxcmpb
X-Rspam-User: 
X-HE-Tag: 1790616454-308375
X-HE-Meta: U2FsdGVkX18H93ks84Vw4uZlHUz0ZvJItlcOHAA2RD6pkFeX2VoIQNm/nmN/qFY70Av6KdZuIGZuDES4iEc9eZtC1ZCfHOZohKV8a9voWa4VdxKG+J4K62SPRRWoSE6SyyF9NUu1jZJ8Len/2nDrgYTerMLmcZtVErWa/w3a3TgdqQvtvF6OdQvVRbYdvfNuDWpuHTtjmNtlHLBh5+VMTgAJRdUTafP6pGprH/B4TGWVM2cejAaI/JToohAVqqwAnSI95JZ41feUdKcXVotq8uhtbYXYTJrp7wNLwjxAt5UiFeE/0yF9cdizUCSNnqdujNJScjDLWDwr323XN22I2kvuXTtvAMFsk/eW/J0MWBctq92TD+oO8duRAf4JoRFzqrUS6CSn2o4GdVm+VKMwJm1tveJQ7s+IuCHYTKF4FDZca0ir0Q36EadfJodEoNMX3L/3pOcLIa7c8/Cq3xtwfSVjXTYv/BmFG7mic/wMaaSMoC8MzvnJhs+vcHiELWddqPoqudalumCQr1ZXr35EMwxEeCHaPVF9ox+XUkBxFXBayueula3CPz6ojYfu2F68otKVO+VeDL2NHtKHlQu6L7nRkDxGXrUIB8R9xuMuC7x+i3NPRCe0co+rhYRdQTTPL3hAluHLdoQfkoHiQn+Gc+zD/6w6Y5d/zy4TxefZTqo1EVaYzK9nDsrv6AbcarT7v2o+rpeWje3OMacuQ8cymFUNxDXKkDpTDxUlrilVEPQjKI8NY1OKJ6cCd9RzyfJh7jvV7QaENyGiCSYPMUJcCjoUL3C4WFRzH/WZ2o1SZd/Gspscvkvm07yF1O2Gyr2DbaFSbQNmi+k/BitApWR1tErNppWGG0pizneuZWPptjXvGQel1suIgWQb83OafL/wzd9Dg5PQ0JtzE42GwLzKR+Y4cAGf+FV/REbYLNwj5hUrmFdcwUpY9oS/hs05JgBDvHlG4ykdkItTloptaW+
 hBxLJB98
 l6gPcB5B/BCWk0PxM2POJS1gU/J0GhFbEbDC+iuy2smggu2SqO+NZXfxNV6jWD0SK68nC4eBbWOTXyey3QwOdpGmlzGpYpN4+mqMv/4hgf3FJvoCe48T6HrLBQUGK5b/3HTpFf7FwOA3qdE/ZlFo4Mz1zE/4qW1ozagmfsQVWs++OQOWveG2MSqXrwhMelMqYccoQb1hXuoTcfTJE7WEWfal2E/GLJ192OhoWN9I5Fqg9fuOupAiRRP7Nt1jmUO1KzQaBm0JgOC3N+p+gD/sHTZZykA==
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
index 751a08643bf85ccfd05060a3f574980f73b3a97f..51fada9059d68a92e6f5725e45ff9a594bfd9645 100644
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


