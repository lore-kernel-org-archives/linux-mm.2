Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B14FFCAC581
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 02:22:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 137B16B000D; Mon,  8 Sep 2025 22:22:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E82A6B0012; Mon,  8 Sep 2025 22:22:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F187D6B0011; Mon,  8 Sep 2025 22:22:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E017C6B000D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 22:22:44 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 578ADB8DA5
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:22:44 +0000 (UTC)
X-FDA: 83868113448.07.A97615F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id D39C540006
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:22:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KGoYLtFY;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757384562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=eJIaPVkhIzsx/PICR7A/dZtKFu7kRVHk1DIdnNtIA6U=;
	b=LBdlS8FWA/NcGwMy+4R+LGCALxeKHRUasOUQb+G/Nr27FnaKhZhYMpsUTJK+LUua19pXxQ
	gXpmkvmTQGRHIkeeritnj71gLYwQUAWCEDnigL30fLgS/45GRr3h/stjhtNasjIq1gpuDm
	y2v8ZQM4Tvg2SqZJ+klnCsV6dV6DkIE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757384562; a=rsa-sha256;
	cv=none;
	b=ZoKq0WaOeguIkM3AEU+B6exV+TF3fQ8tYD91bqQ9QNRaqlYOOKd9rbl3mwJ3fBzUcEQ+Lb
	2zVTyiBS1WCYja43wdidsZZunh3iyWyGTAOIc6iLThRgV+0+E+rr0znOVuCZEB6lmPYEDE
	8Fb3sY20CtNJE8CYB3GwbxsbWDB+MEU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KGoYLtFY;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A08160140;
	Tue,  9 Sep 2025 02:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA16C4CEF1;
	Tue,  9 Sep 2025 02:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757384562;
	bh=5FcWvlgWyOInwHI579PO6gvjZ+U3iPu1CVD7USdbcBw=;
	h=From:To:Cc:Subject:Date:From;
	b=KGoYLtFYjHjbWDmLJGQO81FoqOdz/d15SfaS+VVI1GviATuBnf92TxqZjYlAriCH2
	 z8XI+OOZx2YEXZuh+D92EnvR9Wt/wvjo+xzMh+zVeoIch44J3tRVGhYcUnvspuy5WG
	 i9PfFTIFk/DIJXhy3MJgq/HIR9v6nhuFfxQ8cQJs59vxfcpnIQuOHHWixNQHnaypL0
	 YN5aNXRnGlMSZNBnPBEyW4kVpPD/mQRJyGuu5tXUo0ELl4mmyBaumg0U0gcmR1vwbF
	 +voUh6OOueya2hBF+VdCY1ikYozmElJKr7A+aozzURM5xLm8SidmGV6l6LKlV+OnOB
	 kBc9WMbhDfqqw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 17-rc1" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/3] samples/damon: fix boot time enable handling fixup merge mistakes
Date: Mon,  8 Sep 2025 19:22:35 -0700
Message-Id: <20250909022238.2989-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m7s7sh4nzaucfyofute3uuw9yrfdp59f
X-Rspam-User: 
X-Rspamd-Queue-Id: D39C540006
X-Rspamd-Server: rspam10
X-HE-Tag: 1757384562-6283
X-HE-Meta: U2FsdGVkX1/Vz6/7JIK3al7UUgy1Ox3E099/1KMxuubT/yYj8AIVVPz18OzROWZWPi9e33QaOW9ssMBTVMOW3krZoCNjGVQMq388ikMJhqJZMfBtWPvNfZX24uZgZ4ClgDXXlApvcOdtotbo6W3MZBlCVZyR5FPugXMRxOO+XeBWXrNpcsyfN+4B4RDUlihPg+Cd+5y5uW83uM1mMvmNViP0yuepN2xO79ykU7PKqeNz/nM2ncxgp6q9CVHN2zzn4tkAa9AJIOzWxFVMHXXmHYjpdz0W27zfSPenscxRKGiziw1JT8U3/QkhqVJmB5oToA7AwTdZRzYBRXDOwujgr0pQEF5BccRL9wsqn4M/sG9PXnmAD1PTGLIKzn+X0r28Omf6UWZJhbbPA1oDWoW6llQ6xRE95ssU4I3VpkK+M+OhP4iqmHnAVeVauCOiQhEhtdVjSw0F4pUawm15V8tRFG2ESAGIQHvttwUerUuJuB9Ad48xyrDCfZTEi/Twa2t9pgSoZla3G2NGsSxoRI+PAO1fWy7wVFTnap+CU1Kieo6BV5Zhj/LYlhHaHXb5WfBdJxcF/1wWS8gc6oWvcIMwlykl1d9YkUGN6hHNCTiuKymq34X40Loll+kiWm7vcm+g5qyziuWxWEgvQ+rZopp03XjhpqOYI9xH++VtwETYw/tpD8uGVW45oFlx3vD5FS/5XUtVv3zc1FNnA64Sd1VgZs/H8flY+oMwG6g4M9YxaT2FiEn+xFy0NbIlEDwgP1XsS2Sg6DPI8zZ2qvgo3EZKsVo2KsD7+4AAnJForLjGYNqf/7fCddynvvNYrjdxmXRfb3FmC2ik+Xaw9FxLmpsg+ZcEs3UQQYf5MqDEQdsUk+I9qwhFWInUYAZ8f1MC1qsF/9K6bVzF4TO5iSyOW8hXEul7ds6/+mpdyKmJa4HjZi82LmQm1DtO+XWTWbgezy62qvNY2nv9jkADfU7iQac
 Wm7IQLWv
 N3sBemtXAJJ0Yc1+JxCVlxFlbktlpEXmkidP8CiSlR83UQEvNv6wZgn2VWC4LO1t7zwY06SG5wutbruAR7/L6Qn3UVqmzxRyPz4aQeliMg9KIlcKSZU4WQ26jMvastwVC20ecjShcpQ/7sUruindDNw6csBV8K+q1U/RZTTUDIACqDGkWLB+WrEfMrro/eXTH19EDiaEPYKypW3XGruF9Bd/UAv3byqNdmLcv+y27QfjyFC8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

First three patches of the patch series "mm/damon: fix misc bugs in
DAMON modules" [1] was trying to fix boot time DAMON sample modules
enabling issues by avoiding starting DAMON before the module
initialization phase.  However, probably by a mistake during a merge,
only half of the change is merged, and the part for avoiding the
starting of DAMON before the module initialized is missed.  So the
problem is not solved.  Fix those.

Note that the broken commits are merged into 6.17-rc1, but also
backported to relevant stable kernels.  So this series also need to be
merged into the stable kernels.  Hence Cc-ing stable@.

[1] https://lore.kernel.org/20250706193207.39810-1-sj@kernel.org

SeongJae Park (3):
  samples/damon/wsse: avoid starting DAMON before initialization
  samples/damon/prcl: avoid starting DAMON before initialization
  samples/damon/mtier: avoid starting DAMON before initialization

 samples/damon/mtier.c | 3 +++
 samples/damon/prcl.c  | 3 +++
 samples/damon/wsse.c  | 3 +++
 3 files changed, 9 insertions(+)


base-commit: 186951910f4e44e20738d85c0421032634ddb298
-- 
2.39.5

