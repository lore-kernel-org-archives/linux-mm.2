Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49C69C79FA5
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 16:58:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A87F26B01A2; Mon,  5 Jan 2026 11:58:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A49016B01A4; Mon,  5 Jan 2026 11:58:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91DEF6B01A5; Mon,  5 Jan 2026 11:58:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 80F866B01A2
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 11:58:55 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3A07C139C6F
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:58:55 +0000 (UTC)
X-FDA: 84298519830.01.C0A0A6B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9EA391C0011
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:58:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RTjPzASm;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767632333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GKwM90KQEG2zxvRr1BMvVFG24XC9eNp4dSSf5Hwu0wA=;
	b=Zzxrk3n6vSf0CfgpN+dbyfRxdia1uo2h92VM9o2vWTzkWOImYqhn1m51jxPFvVTN1aqKhK
	jqR3BnQZmprXx8RatKWBBy/gJM1tjeDeEELluNFrMnTtepJPiZxtP5jACfRgVu27WTC6vc
	Blwc5ulYy5ouUC6yGPwHOQrzz2i+kXM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RTjPzASm;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767632333; a=rsa-sha256;
	cv=none;
	b=u1dyx+y7vBiTt3t9ycpJZLhHnqAE9qw1Clt0Uy+OJrgUkbq9j4UU8RDA6YSDRqt3Y1/+sU
	Mknok7drHDFLkjHeYhRKolDc6swaSkrD2pVtao03o1SPGUqDH5lF+RzqT80sYn/njT1rDR
	hJroxb2jgk3l0rQ4CutBZYA9nICyY3k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B9AA443E95;
	Mon,  5 Jan 2026 16:58:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0300C19422;
	Mon,  5 Jan 2026 16:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767632332;
	bh=YLscpyQU8GuaEXJSiTDfKmikNlUhxBYvvwRwG0MmlKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RTjPzASm/+SxsMK/4cdlJp5wMwOcjzLhry0vYrO7oo8nmmQbKe6vtidLorCIDj0XP
	 jvjkjfDzKc2sumECtl8YMH/QWq5/4/OgSK6L7LAAcpMwWM2TltyYa+xiiv7pbh2G5c
	 +k3Ib2OYQ2BsKcI+K4WMGg3+0XWR6cDbIDzea2Q3nh0QgciFy16dP31NXHFZ9C4tiV
	 iUUg0RXmxz6umgW2Psmy1ja5JCvwSfkqsZSUH1yjWFNbA7DBS7QZhQlDbVlRtiNRco
	 M/8IZZ3mjrlpq0XlYhvJuvT0jpIDpcFmXING8tRX1bHhPEtErNESHsudsN8b1MXe07
	 wBL3GGOFJihNQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Graf <graf@amazon.com>,
	Jason Miu <jasonmiu@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/6] kho/abi: memfd: make generated documentation more coherent
Date: Mon,  5 Jan 2026 18:58:35 +0200
Message-ID: <20260105165839.285270-3-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260105165839.285270-1-rppt@kernel.org>
References: <20260105165839.285270-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9EA391C0011
X-Stat-Signature: g9z5jp5ccpxkyctwtped7hzi74kgsmjz
X-Rspam-User: 
X-HE-Tag: 1767632333-94180
X-HE-Meta: U2FsdGVkX19F1ymyDTbZjmyhWWK+pXZLnWt72hS2ojoe6Xo32GCiczTHKRuPKA2O73DM+GSOF5ozZpO1YIDNVduOqlZ0fwBTXqfHKPPYal8x46k0GNW8fpfxhuapQxirw+z7k5LJmoaGbnF+nQxPe9mlDdUBP5kqsXlu1Hn9bTTmNrzB8HbcGYgCkerKBNtFv2aIskHcPfJQWmFshdHs8RMhFA+JhaZQysU4n5+vDJnmU/PBJJBkKWDMGL6CNdarc0rJkbCReCBlhlamW5bKceux0929WDJ/UYqOwl4nFsGOAdcdfIwYTrPGpggErVkjQVXI7PZnP3Bxg2tRyP82x6uy79pWuBmpUpx5TBSDvbcm3JYPKhm3ynIAxzxpb74cqnG+TwQc/5Br4jjyBaxfBJK1JwyNG3aFcDsvSDGxRrdHASXG/FSP4ofGC7tCDRUDkMi70kf2+p2hpgnsFvPvpsoqxe8OQPjJInETiM8zZ2n+c02A8a4u1j3n3VcX4qsurChK3oG4FgE9/Q/YEyH5yUfTXMSAShVodJ565FekwjK/UB+N9Gz7A8AgTTmim+dK837sNc9SBDErKNdq3tH8VD8NFSJgIqoSjlOv1elBBPA+RTKbpIqASaR+GYAT+vdBeth5CrBwx5AJWoFg2ZqCQsc4BvIxqPBNO7DN4UciYeB3T8b2/G/SqBSNzDHMrJXECNdlqSboFW8isJvQAsxfIszXsBYu89YjI3enX15XkU6u7aS5oYiGgGQZPlIAwCY2zbj7yiQaJNTUFMFFBL4ecTgTjcSjNB9V0RqpVpxUTVVMuFEI8bjFyx9PXMC27zHF9ELH7SzyK0qS35CIB16tASaGhIUNQ3rs+PJMdfwSChcel5Of5jsBT69RYwlX/8CUqG+Qzd0XuK/Sn4FT+4i9uz8EvM3g9GcHdNaspqi1SLeOM12nI/RF9twBUNQf1M9Csassa9HCThIkGGnBUVD
 bjH+Xoby
 oQNK7XcfmY5dZKFjSP6H053IwcfNZASekXQ9FIXIygIqxgMIbp8bkcQFOGERsmQrQWSux9heOao0FWQcnmPjk0md9B7XRlm7csLpoSsLx4ESVcO9u960ytmJDVhmAW4ENClxMHBjw0UwBpbuFBrr0hr1Q//xxV6RmLvukriYek/iO2zRdj152imBRqx5eBMqEz19y+XAWDTN5XGaLYz6beijEIGB6X35Ib8ktJSVyn2R6A9g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

memfd preservation ABI description starts with "This header defines"
which is fine in the header but reads weird in the generated html
documentation.

Update it to make the generated documentation coherent.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/kho/abi/memfd.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.h
index da7d063474a1..c211c31334a3 100644
--- a/include/linux/kho/abi/memfd.h
+++ b/include/linux/kho/abi/memfd.h
@@ -17,8 +17,8 @@
 /**
  * DOC: memfd Live Update ABI
  *
- * This header defines the ABI for preserving the state of a memfd across a
- * kexec reboot using the LUO.
+ * memfd uses the ABI defined below for preserving its state across a kexec
+ * reboot using the LUO.
  *
  * The state is serialized into a packed structure `struct memfd_luo_ser`
  * which is handed over to the next kernel via the KHO mechanism.
-- 
2.51.0


