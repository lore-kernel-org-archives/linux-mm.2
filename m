Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8115B105F78C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 11:10:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E68E16B0089; Fri, 13 Mar 2026 07:10:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E16CF6B008A; Fri, 13 Mar 2026 07:10:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D49B36B008C; Fri, 13 Mar 2026 07:10:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BFBE06B0089
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 07:10:01 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 150631A0943
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 11:10:01 +0000 (UTC)
X-FDA: 84540770202.02.72D23C0
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7AB764000D
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 11:09:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="k3/VMmrW";
	spf=pass (imf01.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773400199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=h6f9y1Azogy+eVSZvA21A37bR2iFuIMAMTEPkCYBI8c=;
	b=IDTVxanJHr6E72Ad2NXNcQGFETKC+UMR4Rcfkk/IIbLIWdbHiumIcLvoVH6i5eODQBO4T9
	KKejBopkR/kuv+RYl1GqxZuuaZcOqwfC6PdW7BHwM90iEL9JGCApJ2LzIN2LZS4oXXaCj6
	UNpGqx6lSAOjUjqdcp14NxvUL8ELDf4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="k3/VMmrW";
	spf=pass (imf01.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773400199; a=rsa-sha256;
	cv=none;
	b=AHUtpzgwjJQ3Qf8pTCjbDe1EenXsKXfHE3aFWazvQ2gchHQyWujICAclyjcpj/oi3pRJRy
	51bMTugBW3XdUTUFkBKuXzbzZZY0NGhPOp59W3H0ucHoy2MvkieDorygysmRzoi31kjk3T
	seuIb5T0ErvmyUH1pO13LjrOPC0KYHE=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-829b8b6c4d0so1742255b3a.0
        for <linux-mm@kvack.org>; Fri, 13 Mar 2026 04:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773400198; x=1774004998; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=h6f9y1Azogy+eVSZvA21A37bR2iFuIMAMTEPkCYBI8c=;
        b=k3/VMmrW4sFi4T1yieqXvg2efCjpeGcS+ySNDlXNuTLaWfW0aKvmPQBbxm/GbJB19D
         MllsyYYnG8VdHE/xec6wD6Tw3LRaeD8o8rwMLQzxOFZkvUwggkZBsVJgWlpS3vrYiibp
         2Wth9HNuIouqxWc91EKC7unUFzmxsDyIxvChrUk0CL43fAnuXXwCxcJj0LsdPLXPidDA
         4fODNlOgzBSvw1AfkihcWc7MOp6Js6dM/37ZpKjKpOb3/QN9CINwYDLOIsLiaI6F4yeV
         2NnxO8iiGs73QoPS/hSVRiajS3AIvTBjKpjoMfubRbq9MKqeQRZQvv2jANlu52XzP+aP
         enfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773400198; x=1774004998;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h6f9y1Azogy+eVSZvA21A37bR2iFuIMAMTEPkCYBI8c=;
        b=nK3mrOsY8s4f2V2umM2csTOnCKF/FPIu7NfcfkStjDXAtZu5EzipBwiqImKfdFz8Zk
         zuPIli12cK9NNgfI0VcjGcK+L/pgc+FW3fbh/BObcNL1dqAn+0BQWKX6g4wYBbbSVIe9
         BKpERQV8NqVDsRxBPGEo/CugWo3JSUi4TRhZJkP6DHhIqzJvmC7fOUhXhdN6lCjiDUFx
         n9rRM4qtLSpHSB1XXoAAxbuT0qFOKyy8nbqCAwoFc4sy/YuQYQcBkZAA0guv8pI9YHMI
         VeZeUbCG6CWI3giv9W8Dkmwb4MS4ih56vX8SvgRgQGRkhCkspBA/0S9uapgIATEfR4+l
         KY9A==
X-Forwarded-Encrypted: i=1; AJvYcCWeZmV1V7SikDFOpNe3YeP8H9AWk9hiflE/tRHLUwQgBUJbQnmjeCYziMfpbUopADbrQyrrrunYRw==@kvack.org
X-Gm-Message-State: AOJu0YxDZrZ5RzOGn02iLov36lrwdz0flX4V5dqFjpFWmfGbJ1LKYDv1
	78TGB4GlhUlbTUQIAJaJq0DQ8xqNbPBLpz3JQjqkwP8T7D91y7dP+PbrY+tbZLc5k5A=
X-Gm-Gg: ATEYQzwFbnw//LlNlhZ7ta4X9DltMns5QkPQZl71Rk1XrZoQfUnu7UIw0Qak90F7feP
	fHL5eHbTujEYyVYqIowiH7X1934i9lqzJpPEMCZiMGSP2HY90/bwgXLgUnNdC4WMXDIB7mfUvWV
	DIMV08mg1035mFSJuPRnykxvhCTb34yUdPtYNmFMQaSvFXCuW4OuW8zUi47IU6s8v01L5mxHacE
	R4cNQ2P/zB+GJQulm9CsLyFS4cKYNBATgJRkG/DKZCHdWFTxROda8/CaYKo8EkqAvY+6JbMGIq6
	CppW+fD6K9i2rfEkTg3AU6MBA4KwxB8E09rWrWbezOI9NHFDqg/GYHJmWKS6tA1dLGv1I7kMyVf
	RpcBFpIwWMT+IiSl+2Nowk1lHcpLQiV3vqYMBz6SKx6GRniRmap0YQIaWCSkW6uTHPbkdKu95Rg
	1hqcpe8h81jQzRe3Gn+4u7xxQ26effb0f94ct7aS9u3WavcqclfM4/6Yonsrt/zew=
X-Received: by 2002:a05:6a00:987:b0:827:343a:a1ef with SMTP id d2e1a72fcca58-82a1991bc2amr2914921b3a.52.1773400198146;
        Fri, 13 Mar 2026 04:09:58 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:89f2:c7ce:9a60:1bde:300a:8fcf])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a07340439sm5679444b3a.31.2026.03.13.04.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 04:09:57 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: damon@list.linux.dev,
	linux-mm@kvack.org
Subject: [DAMON][Question] DAMON_STAT and DAMON_LRU_SORT module parameter conflict?
Date: Fri, 13 Mar 2026 19:09:53 +0800
Message-ID: <20260313110953.37465-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7AB764000D
X-Stat-Signature: 39o4f6c6ekcfockdqq3tb1fkftigotm7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773400199-190730
X-HE-Meta: U2FsdGVkX1+ufUgIhG8AXThWdk3L+9rlCKWlI9JlACQCzzLm+FT6ymIAGhm8egIVwZJIUBbVB0sSHZCVmsFc+3RjBW8drtbXddvsHm5Gx5xBIOBgKoB2fosCwoDU9dcCfE5dThMVugl3IF3uJ9LO1Wmt3+zKm75nZ//P2fXxyR+q0Xd1vu/s5DjFpW5QDXiAFpuKD62SF+PxA8e9LKko5v7tvO44kpWiB/6GJBlg7rSpqPY1NGRzxVoAotTcCgAbs6XJfruB+NmfhKi1Qdo+nex8b0wX2uS4+59ESgaDVA9ExtIXjJ+Ewc3gAMbUJOpfamPI4o028OKfW4A/RBIIRhxbe9OoV2rL9CHjwbUsXNizE53qapeo7VFsJJr9NZ6NlEB9DApqYANbyqqQ/KWSEFM/qgVJegDayI8JvHcAHRnIlg9B245/Z4v9T9BRN4diOtv7X7ZHYeEspebhGUQmsvyQ89wKSp/smqFKDXiCyHjPNP/Ikj67JZRA3FNqNujZyiNUUR1yePYCtFzsBhJFYRpnAQePWCy8I/Untt9NO6TckALhpDDbNJMly5699/99DJq/WT8QippsjxTRA6Lt/hJS7bAV07EQ+9b9Y7G4ZP3dmW/SsS1EoWRkCjgU+Sdux04NI2HQh3aG3cvSviv1Scc314ADqIFxZJyAcFx5HwZSzw0QVknByWdb1r6KdWruq6/ksJmAsll98sGJ5kmfnSrUVzgLcfMfVSN2GaFP9ygu2ZT7IBFWae9bxzVeI/AHrGvH+uFmlgGEKtfEJ2T3bFrJwavKRvEZOCCE3WquCngDniuTSXWgOfoBym2kZNCoDkUhJ9c4nr6ySAlegGUbl/P3VxOashajdYw4FNNKixZxqBE52ipASKHbxPTK1GTMZcwQHNwRkN1RDz/k/f+9Nt7K87CDWH88J6qfGk9vvt7Vuy452TJzauvTlQShcRDf7uJsgwqC8vDvOf9tncZ
 tTWniULZ
 gdNKf8jn5uw6d5sQHtlrLbwDfA8cBGWD+XPZOaPSLWgszK7Xr4uRHVm+gAY6laQmbRFsDxsnJEkzrg3ZY6umCyOER7kQd7DHSbxyOfu4HSrilaB6dAplDcb2HflhjFxujM/aKGNKBLRmvSZWjiT7HSywOCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL;DR
=====
When CONFIG_DAMON_STAT_ENABLED_DEFAULT=y, enabling damon_lru_sort via sysfs
"enabled" parameter returns -EBUSY. Is this expected behavior? If yes, should
this limitation be documented?

Reproduction
============
Environment:
- Kernel: 7.0.0-rc3+ (x86_64)
- VM: Virtme-ng (4G RAM, 2 CPUs)
- Config: CONFIG_DAMON_STAT_ENABLED_DEFAULT=y, CONFIG_DAMON_LRU_SORT=y

Steps:
1. cd /sys/module/damon_lru_sort/parameters
2. (optional) tune parameters: hot_thres_access_freq, cold_min_age, etc.
3. echo Y > enabled

Result:
  bash: echo: write error: Device or resource busy

Workaround:
  Disable CONFIG_DAMON_STAT_ENABLED_DEFAULT, or disable damon_stat at runtime
  before enabling damon_lru_sort.

Questions
=========
1. Is this resource conflict between damon_stat and damon_lru_sort expected?
2. If yes, should this limitation be documented in:
   - Documentation/admin-guide/mm/damon/lru_sort.rst
   - Documentation/admin-guide/mm/damon/stat.rst

Additional Context
==================
- On major distros (Arch/Fedora), CONFIG_DAMON_STAT_ENABLED_DEFAULT is typically
  unset (disabled), so this issue may not affect most users.
- However, for kernel developers or custom builds enabling both modules, clearer
  documentation or error handling would improve debuggability.

Best regards,
Liew Rui Yan

