Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 015C5C531C7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 09:29:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB88C6B0156; Thu, 23 Jul 2026 05:29:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B68E46B0157; Thu, 23 Jul 2026 05:29:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5AE76B0158; Thu, 23 Jul 2026 05:29:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 75FBA6B0156
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 05:29:17 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E3E3B8041C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 09:29:16 +0000 (UTC)
X-FDA: 85019517912.04.23B4952
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf01.hostedemail.com (Postfix) with ESMTP id 31B8240005
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 09:29:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FaKhkTpJ;
	spf=pass (imf01.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784798955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PZrPBqYijdzfKMBuONSSs1WTwIYrhiqirWSevn+t5ro=;
	b=ieGL8maSRHdmr0B8XFEG10oBkhbYmh2xJsI6okym3zEmDe+tm6Vu1xc+k/6yHGHj2m+kEL
	drbcOxCqhfOSZwlM+Brq76cPprrcNs1Y1e+N1lM1T1W96sxKm+d9uQfCAdbFdWPpDrnNPV
	fWC3uoNXgV+NFRfGz2fbOsnMdBlDemw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784798955;
	b=AhoPfnF4bVBoTM7KFoLAvU+uh9c9489I8NTIxyvUZieA2GiY39PaCTsGbcYYrBYIl0fzgQ
	lxMAAINwtO/iSNCgrgc0wAxriok77a3UGrBglO6laJkeGHnju0LRyGTlmmuaLvlhAwFzLZ
	XF1HAkAA6xpnALULTg89GCd041B+5D4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FaKhkTpJ;
	spf=pass (imf01.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cc7ef7ec27so4673885ad.1
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784798954; x=1785403754; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PZrPBqYijdzfKMBuONSSs1WTwIYrhiqirWSevn+t5ro=;
        b=FaKhkTpJCukW9Kl6dc9chBDPUWkNZMKxDWocwD9N+4MVTCZg1ipk1NaZSfV8tEYLSK
         USlshpyoNB0k+sQcBNEQm1GPW29JNbyWcU5H/khPQn3yuacxlwZsk2BQgBWQ/GQblTuE
         9roofkPpRERdcS20flaVEpKMt19PVf5BWBEtI2HM73VPzdP3bqLaxDLU36q1XdSGJDAU
         /+U+BTQFhBD25uVDz6Oltzzkg4GJXdTrgC+6UgyJ9KRujMNJ+UTra/kkBp8ETS8Q+qMG
         x29m3FLlt50d56r0Fcy8ghiiLtcD9pjeCiSsoRSNjEr0jnCkAGIdRvLh3M1EYFiP2/Fg
         zaTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784798954; x=1785403754;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PZrPBqYijdzfKMBuONSSs1WTwIYrhiqirWSevn+t5ro=;
        b=g4+2/E8uVJ1Xf2ltx3Pec9eJeaNXpmEYQOm6frr2Nw353dFK4YcgVyyCSfUy5EWgir
         9wcUpBMRTmVmSRl2dsg/UQRotyYmvMFfnvwihnpkBad4Bq++37FqOoEo20oD516R/NoZ
         HTuH4lEmatVm/hv2taU+g9x0zi2k8U88EGvp0zfzeAP5yTfP53SHftqNuyExWJoojpo7
         ZjSi676W39pCavlwz/V/LTanfoQC5pXY0ahc3ctOubLPEbo0rH9rj5ZVphobAK3IbZLl
         T01tW/9xAw4fdXK+gNBv2FxjxGbGRUxrT1ARizu8zbS3sCu16VXMOwEg6wwaMmgCLXXl
         sCxg==
X-Forwarded-Encrypted: i=1; AHgh+RqUYidrOzGvbR+2lM9Cues1ZD/Yf82qyyZNTxdLRKwyHJIK9LbTkkSDAt0F3SMSdq3dwRNK/V8bGg==@kvack.org
X-Gm-Message-State: AOJu0YxpFSbyJpcqQdVGgYIk1pYoSya2M6GovnzGibzM1UJIPwWnJ9Xy
	M5lqqgzMNapkzq23dxbPFgohQ28D7s1D70BeUXeuCEbqnaxN8RghGqvz
X-Gm-Gg: AR+sD10uFd6PFBgM4b/OXzcOGS4TXRqU/T+spOJamCqdTegr8pcJLtLbJmB8+RmealL
	cPOWLY5zHr18EQaVyncMI051nXT0lQcgtebUCSDAMK0imUcCA5g9/Acyzanmmqh+vrEMSK3YT4s
	RLS8LIMvnYfKq/Oay9Qh4Osemq9GYc3j9OJPHSbCuNtj+elnDw6Dh+5iZm89ccLqoPYOQnvRYbn
	/hoGSvPLOpjMyXsgSm6Q1E8j4OJtkD5snE4I9WNKA6wUeh9MdGZ4IqREGTaySBOn7f3R6WBOEdl
	BZcGBcL4Xl+o4Z2WGgTizpfLi/WnMbgOBVdIO34y4pMDXxq3KRQe4L+h9/Y+enHNd00vyn87E9y
	/ae8ltcVbdV0iLLay5Hzxh5Xiqsc66ekHNe0Wkwd8VVkotfqGEPRf1YhEV6qnJ0b8rjMcbvU33I
	QfhSDe2dBRT+pkViHWGA==
X-Received: by 2002:a17:902:ebc7:b0:2ca:ce91:f027 with SMTP id d9443c01a7336-2cfa6c875ccmr27647445ad.36.1784798954032;
        Thu, 23 Jul 2026 02:29:14 -0700 (PDT)
Received: from PC-2B0BA31200898.company.local ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8efa388fsm30298125ad.12.2026.07.23.02.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 02:29:13 -0700 (PDT)
From: Meijing Zhao <zhaomeijing100@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Meijing Zhao <zhaomeijing@lixiang.com>
Subject: [PATCH RESEND 0/3] mm: trace: decode architecture-specific VMA flags
Date: Thu, 23 Jul 2026 17:29:02 +0800
Message-Id: <20260723092905.761037-1-zhaomeijing100@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 31B8240005
X-Stat-Signature: gfr1cfikfx8kcccsbac35r9ksks1wtgs
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784798955-56833
X-HE-Meta: U2FsdGVkX19AfFiCp2dcEiNrf1G7ckbh382key2iHspNaj68zqtxKkkGsfoF7v4qJDOqeYYTW7en5Rcr6FJgXkCWw6PhrjA47tRqfUh/Ubl59OU7x9Mrgke7wxShaRx6JIY5Cm4dU3UXNbN7iLvhadh7UflmBsxlsfyBS+dKdeDuyVv1AA5lkvR03nV81HoCsGH3yJGItA4WSECYD1hu11qsW6vhyBDmitCwauzVqJlStP4Mxmuo1ml5e4dkbUdw7f4EOcBlKUIEwaPQwj+lGITNr1bbBSY7KwWvxUAMgl+VFK6GO06HybX5omPT4HZTk11Os5lVmR4AgJmYW9JOFjz/Dte1cYjp3O51l4MoL2tfjV6KRxrAT+9dhW9iaNNVPnNwlys6J9AF0Qd9Oz6NveF9W4dOJ7qEFwEGRKLXN3D4tpMlzqn2YwNVa0G8uJgw4QGiCkQeSaKVYLCQP8kW9WbC7vKoKpwY7kf22U0SeVO+iF8domOE//9TPkIK1HUpJe9ScJMJToHSEcKy/+tI+tsKl38HwOPfb7Loq82l7Os6o7reZcjvV5TK6heK0O/xgOxAiKDjSN1/396kA7BwPQvpJEwyQtxmlpX1BsedezQU1ERpekSIUsFUqhDdL3tCAbYaIRnyxrtmpYBl7babwJGFSpRhyIIuwtlj+FiaCJdpXRWKNDkB63jiovq47xZ7/VU2yJM8XWLKWl5JBW+cyqzteVjoOtrwoyA3QKacv9+uMRM/ueHIDHVff10/So1fRFKlffG52PxVPmhSmD+YEeBgNFM5jXw4le6lE7MNCafXGMIqzM/kZom81J8HJgbeieUKcMQrpucNUhkjp5b5xCNMaiHcKNPePNFv2UKD6XiqI7jr5xjt0ECinHMfjqrWiQtBRgAgZNz7Ar7G29GLkTSZPo6oatg9n8DJwmA492Q7JQHXAGOkiHAtzMz7/32VgHy782DbNdzXJA5YmeL
 7vBHr10B
 38M3C0vFNzhzRnSJ5nopD7KtFZEf8DBMF1+zHbORWEgn8GklqPzS0CNBawch+4GSajQmT3vnrkSm6DhifXmEXZXCB7PCGM3kz53Cyo5vAkPX8HNTuoJWo0mFlCGUi+P7ff2OPEpIbmrJG1v8d9UQ3Vq0awGQwYBJ79GVFxXR1WEHU5ob79YyTppjfZBwXyty8JvdLEOPDjwcmSGVu+zjJi/iuu2FcZvUGUyDhtmgB/47bs/LFZKzUCtiqit0mpCwg6atsWgHQZhdr0ZFk9a7Fi8x12PctNtVQ0Tz/WovKVLCCVkAhEE0BOu+/0gJEen6wyiEL4DI4vVMAJ9ancEdXQMrXWSab7UbjReMxUbKauc+rZZMIGkiPd/XRbXW5itPqLf5SEGMriWAiSKUwAoBShrhLtU5gSlMDgRt2P/FNZACspbAlclkluSLQ03iV6k895BLzbwbDLmS0ZnGwKPOwI6sjkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Meijing Zhao <zhaomeijing@lixiang.com>

show_vma_flags(), which is used by VMA tracepoints and %pGv, names
generic VM_* bits but does not fully decode architecture-specific flag
positions.  As a result, trace output and VMA dumps can show a generic
"arch_1" name or a raw hexadecimal value instead of the meaning assigned
by the target architecture.

This series adds symbolic names for the arm64 and sparc64 meanings of
VM_ARCH_1, arm64 MTE flags, user shadow stack flags, and protection-key
encoding bits under their corresponding configuration guards.

The original submission was rewritten by the mail gateway as a
multipart HTML message and had a disclaimer appended, causing the vger
mailing lists to reject it.  This resend uses a mail transport that
preserves plain-text messages.  There are no code changes.

Meijing Zhao (3):
  mm: trace: decode arm64 and sparc64 VM_ARCH_1 flags
  mm: trace: decode MTE and shadow stack VMA flags
  mm: trace: name protection key encoding bits

 include/trace/events/mmflags.h | 43 ++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

-- 
2.25.1

