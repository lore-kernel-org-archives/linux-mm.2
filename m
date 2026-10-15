Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5163BCC6B39
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 15:33:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C001E6B008A; Thu, 15 Oct 2026 11:33:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD8D06B008C; Thu, 15 Oct 2026 11:33:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC7AB6B0092; Thu, 15 Oct 2026 11:33:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F6256B008A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:33:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 050C2A88F2
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:33:39 +0000 (UTC)
X-FDA: 85325255400.17.2226B0C
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4303B40002
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:33:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=eNk2Ejkn;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792078418;
	b=n6MMUYUrvfFPZqhsBG8hu9HFIay1iAE0RLc4PdZ7L4+aGKC7qDLQ0YSTKOBFOGvlVbX6zL
	x8hOQhgD4Q+C5F2963GbZ4xqW7Mj91iOayPdgsvWL3aLB0IhH6xnnDDpZWPRg1nRPwjfwP
	2zBzak9qn5SAmRxAKHY1dZkAeAn8qDQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=eNk2Ejkn;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792078418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=imriAKslpKmc2rOuduOVfwOSxXiBTlYDccI9fjTDxi4=;
	b=I41x7NSilN//Pv3W6mgIrxqmwSmdItA/zuiZp0LKAGsQ5dFd2F4SZGekqnIFcAu6pG6yxn
	ZjX045NLKIq8iM0XIhOoUFMr0tn2uZT96xbx1r5xABJpxgAPVL0TZ8sC5Qjadm92wqGWDM
	Q7B+iVK7qE3li5D5D4ijMzBUzo8zx88=
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-745497ac8fcso1696574137.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792078417; x=1792683217; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=imriAKslpKmc2rOuduOVfwOSxXiBTlYDccI9fjTDxi4=;
        b=eNk2EjknFbM1nhTx03zTTaJK6Izym+3oqg6oxefQPo9sk8uhxfiN5g91meLj/L0Ynk
         puhv7atR/ZVNEtUsotllj9IIMtWV7RurZGmx8gjn5K9UYRqXqcsgXpfyd0cUQEtjFul0
         5kGl0+yMHlijRo81LnXzXsYCbQNsxQpELQElWSf0iEScLYS8eCHwzKX0AtKhY5xloYwj
         e2LqqQMe4cc0xmNGAuR00rlgzhGHhdMDhKNaNjntNMLIOV4r2RBX7AZ9IXsWM1eCrpU/
         0ldPjhomouHlVwosifJorO7PXkG2G/jwYSPIoJZ+Xt78U3XMRnidkJEMf5IORlHBcX09
         2RQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792078417; x=1792683217;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=imriAKslpKmc2rOuduOVfwOSxXiBTlYDccI9fjTDxi4=;
        b=bUvVbLs2FUumnrbvHWG24aXChKJFDPIaQwXO3abR3kOJJBsi5b4qa9arfneQz93/Q4
         khoXHxlqGDSZandVh3mjuLLJry4tzyoxoHYa42VwKmoPOdxqFulkMSp+Oe5al7ZAaGjL
         E+jkSv1PIRClq/9HAHQL+CIpBOkSgwpB4xzykmqugeSnil9ZEFp19tQnKX6lq/PXJPxe
         BiyxrsTav+RFxsXziGV9JLR+kBSN6diGFLZABbbm2IyAHtpnTCD2ryjrBONzxtZ82SK9
         kr0upEnikVUlyFMeItkBYzm11cP8ATgttGWPr3DoYd7JGBUg7cn8phUJ4jYh2OYlr2Cd
         BT8Q==
X-Forwarded-Encrypted: i=1; AKwUvBx2qa840Vt9aJ73d0hwal6XoxBqcS7y61p9KYT7F82RJAWUDdziTypXM1uVITFV98ZTf6BExOE+bA==@kvack.org
X-Gm-Message-State: AFq9FYIOKEaGnVfWopaRyPaI+mo6j67kDpjcWMsvhjZfmQ1rCsGQRtVH
	TipoSm4I9aWgQoToJ7oZCB8yzCP+10xozo3R5L5Q+OufPvhCZq22FSBcMpFFeVIFOmI=
X-Gm-Gg: AYBFou0wE9Mb2cAd71VwXCywWnl6Y/4QUGcdEKMUaaRBYW8lu+n97z/bENvxkIG/i2z
	lsLd4Wn4dCnF3tRQ0atFHbzKoqn4dR3WLYct4FW/lxv1/brtPaACYkQjc7feEfcoU4qCPerhvYr
	9z8Wbb+1wVCvHGN5gcXnYcatAr7ddUNH1+4Jpl6bjOpARNL6BV3pxT9Yb0TTeI+E+600AIEieFB
	mqxd0iEVcVEUe38eXr9ndLWpMehLkaYy/LqwvYnVtElnqbUrzonjoNXfaOL0BbjbbUfb4N/5wRn
	0ydD7bJpQTth2bhZ+R9FX8yf944YlltxP1/raB27Hk5Y2PKLIKQsBaF4ZLaktj8L0HcYVEWEWZn
	UhHUnO5kzDnhBGZZfiKg2TmFxT2c8Q6w/58XU3kwt2gegAPE+s06ULWVbdPZPv3GVpwk0HynIEd
	RH7grUpEZC0BTvTJOxV/qdXy2I36jLDnDUDNSb9QIlyWbRsVTSrFVfHdzXFyHOscCXt0EQvc+AX
	AKXhHd/X50wlKol7HAgzF8x1axS36eRYwdvjJxUf/hXW5loFNl78EtK6tGC6zCqIpzXCpdkUfKv
	Tb5xy7r4xAunvKDs4X3i
X-Received: by 2002:a05:6102:441e:b0:7c3:263c:511e with SMTP id ada2fe7eead31-7cb36989716mr5308286137.3.1792078417340;
        Thu, 15 Oct 2026 08:33:37 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-99003f66ad9sm12986347241.10.2026.10.15.08.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 08:33:36 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: kees@kernel.org,
	rppt@kernel.org,
	juri.lelli@redhat.com,
	nik.borisov@suse.com,
	tglx@kernel.org,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	vincent.guittot@linaro.org,
	bp@alien8.de,
	thorsten.blum@linux.dev,
	cgroups@vger.kernel.org,
	tony.luck@intel.com,
	david@kernel.org,
	mingo@redhat.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	seanjc@google.com,
	ljs@kernel.org,
	zhangguopeng@kylinos.cn,
	dietmar.eggemann@arm.com,
	mhocko@suse.com,
	vinicius.gomes@intel.com,
	tj@kernel.org,
	vbabka@kernel.org,
	linux-kernel@vger.kernel.org,
	peterz@infradead.org,
	surenb@google.com,
	hpa@zytor.com,
	x86@kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	tim.c.chen@linux.intel.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rostedt@goodmis.org,
	gmonaco@redhat.com,
	jgross@suse.com,
	mgorman@suse.de,
	graf@amazon.com,
	linux-edac@vger.kernel.org,
	liam@infradead.org,
	ridong.chen@linux.dev,
	longman@redhat.com,
	bsegall@google.com
Subject: [PATCH v1 1/8] x86/realmode: Remove unnecessary WBINVD from AP startup trampoline
Date: Thu, 15 Oct 2026 11:33:24 -0400
Message-ID: <20261015153331.1872641-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261015153331.1872641-1-pasha.tatashin@soleen.com>
References: <20261015153331.1872641-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ftedae1w6jxwijes7h6gnswx5pb45o3y
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4303B40002
X-HE-Tag: 1792078418-3561
X-HE-Meta: U2FsdGVkX18V3Omh5H9Ko95julSBSim21uwnQo1Gej0sgqhMaRhk2J0J5+R48UcB0xAEpB9AB8rzpi4bvNIdLMnAurmPRIKYNqTn8o589EzeD5bsLqPzUXDnKnnwwqOrD0WKLmf3FiV1wg8QbDAnAZ/f0fFT6IaPCuByYjL+JkKq4ttP9fAaIXEDLALFkvoD8zVGekpKby6mCW611/1Ck0j/gs150hWOmtOyyyP8aJ4yk5xlG4d+f9FXBd6v77l9TfQQu+l3LL2HPEt0sKFlWOryTUEW7jzuDii7zb91/7fJJzcSTSICiH2g2mt+KhY9KqO39UETERnVzt2ypBzIsQd6PMkfart6mRjS0wG2CoAD6DYwV2GOcgSLaR0xqu+H+Xy2E5TN28iYfyVSIskmF5T1h/T+20cbBflPCmdk/25svis0qzXX9zoRh8zdz9/rvGKJQMDDeE0ZvDohjCoqnPU63dWkaMVl5r6AEaZm9mHdncsqPBI8rBBTmwKPMxSgg3abCqjomaQ4d4DvPSq2fYPWcvisrE55mkTljxtdw9H9CgjNNFJiy3HeJh2QRe5xVozyZFcST0pfZv9igXboPMieJAB7XcMPHlwQYg/AyjPOKPmMDkmcKiRYjU4NU0dkykIEySgMm1IN1Y5v7UlqHdTnCr5pUgruus99vw6I6QaZYQ6DXu4ktG7UwUkNX6lgjVlmnQ0Knn3Zw91HJg6p+j0KtjxR4OXk6Y1m4d7O7A4wrJ+8di17qksMilwO0Socw72vr9bacEFV/7HIqFmkuU632jNlXttR30hqlU0HnMLeYuPwdNmkpbSmFHq022Ztwa39EbpV2YpEP4DhINX7eC+tUMhzLcmFSjVHER9ZcrRa6LHpINbmGrPcOVua/JWsWhHHaZqXeAt2ugXMpihqXBZEsES0VH9DbLPWvPEDklrNwOhXtT0381RUTRMBpxPnUmF2+N78w+lYzMYfHle
 wCUW8mU3
 5NmJIJzJu0VjH8gfdC3BOM7MXZ66V7QKKKWc3La+OamRUkv1e9fs3WFEWcPOGWZ8ylJNBJvC17phjC+ZcX10S9WQrCf68n0UcTMmP3/JC7PrGLxn/ou3zPeF5Ao7KIDATQibwRkU9k/HJRRWfQx7/0fdZ5PXN0b0D8ruJc51Vpk/epecsRHVxiBMCkcN9mGvbLUFjtANavhNxlMp3PQ2Q3xYwgIGLjyB1lxHoZRDRi+5hMtKTnyWeaUhaLOofF46D6QEPz8db63+GBTfi+rQeUbPVbzYhY4lSbCmslhtuThb14onpuK08kNi1cUiqNgaxKO0yqpB7pSFlU84=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

trampoline_start executes WBINVD in 16-bit real mode before switching to
protected mode. This WBINVD was originally added in the 1990s for
Sequent NUMA-Q hardware (as noted by the comment in trampoline_32.S:
"Needed for NUMA-Q should be harmless for others"), whose cross-quad
caches came up non-coherent prior to OS initialization. Sequent NUMA-Q
support (CONFIG_X86_NUMAQ) was removed in commit b5660ba76b41
("x86, platforms: Remove NUMAQ").

Per the Intel SDM (Vol. 3A, Table 10-1, note 2) and AMD APM, the INIT
IPI used to wake secondary CPUs preserves cache contents and leaves
CR0.CD and CR0.NW unchanged (0, as already enabled by firmware or the
kernel). Neither sev_es_trampoline_start nor trampoline_start64
executes WBINVD.

On modern multi-core processors with large shared last-level caches
(such as 504 MB shared L3 per socket on Intel Xeon 6985P-C), WBINVD is
not harmless: each execution flushes and invalidates the entire
coherence domain's caches and takes ~85-115 ms per CPU while disturbing
active workloads on online CPUs.

Remove the obsolete WBINVD from trampoline_start.

2-socket, 480-CPU Intel Xeon 6985P-C (N=479, mean of 10 runs):
  Offline:  40.40 s -> 40.46 s
  Online:   65.83 s -> 11.14 s (-83.1%)
  Total:   106.23 s -> 51.60 s (-51.4%)

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/x86/realmode/rm/trampoline_32.S | 2 --
 arch/x86/realmode/rm/trampoline_64.S | 1 -
 2 files changed, 3 deletions(-)

diff --git a/arch/x86/realmode/rm/trampoline_32.S b/arch/x86/realmode/rm/trampoline_32.S
index 3fad907a179f1..14e56ea954160 100644
--- a/arch/x86/realmode/rm/trampoline_32.S
+++ b/arch/x86/realmode/rm/trampoline_32.S
@@ -30,8 +30,6 @@
 
 	.balign	PAGE_SIZE
 SYM_CODE_START(trampoline_start)
-	wbinvd			# Needed for NUMA-Q should be harmless for others
-
 	LJMPW_RM(1f)
 1:
 	mov	%cs, %ax	# Code and data in the same place
diff --git a/arch/x86/realmode/rm/trampoline_64.S b/arch/x86/realmode/rm/trampoline_64.S
index 14d9c7daf90f4..e5a3f03d62217 100644
--- a/arch/x86/realmode/rm/trampoline_64.S
+++ b/arch/x86/realmode/rm/trampoline_64.S
@@ -60,7 +60,6 @@
 	.balign	PAGE_SIZE
 SYM_CODE_START(trampoline_start)
 	cli			# We should be safe anyway
-	wbinvd
 
 	LJMPW_RM(1f)
 1:
-- 
2.56.0.385.gd3acb90ef8-goog


