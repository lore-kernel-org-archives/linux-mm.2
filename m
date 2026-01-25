Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B10BE63CB1
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 17:58:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFF6A6B0005; Sun, 25 Jan 2026 12:58:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAD266B0088; Sun, 25 Jan 2026 12:58:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB8F96B0089; Sun, 25 Jan 2026 12:58:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9A936B0005
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 12:58:04 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4D814B7872
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:58:04 +0000 (UTC)
X-FDA: 84371244888.24.AB67068
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id 643771A0003
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:58:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ci4FdMB3;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769363882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HfwKtU2seymlppcOC0RwSpKtRsIq3Fv3RtXUlcD+w2c=;
	b=foz4xmv5TJQE4qhoxqka/bKqGx/xTO7QRvX5beBBNiaIUWWF43qiRYTzkYOidkr71KbtT/
	0bmC4ev1a/caBjqPhHh8FpAkB6DKZG+byhoVFPT1Zan9pqYNueUkVErO5s61mR+IqR9RYq
	AQfSYcJXLyJaJU5bRnGuj30XY0I+MtI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ci4FdMB3;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769363882; a=rsa-sha256;
	cv=none;
	b=jMwWrc24jI/DxaIZrRh548/mtNI1v7r0VBztTLC6K/5v1gbpitOKv/5NgV1ahn7nezypBB
	c2te5UiHBFzCyELcEqPnI1FA2CgqSMUT0YrV0b6S6cn01nzrRYIVPdCk6hxGaAuMCc6CBc
	oElVHcNsJRIwt0qtlChf3SSemXzAvaI=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8230c33f477so1526466b3a.2
        for <linux-mm@kvack.org>; Sun, 25 Jan 2026 09:58:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769363881; x=1769968681; darn=kvack.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HfwKtU2seymlppcOC0RwSpKtRsIq3Fv3RtXUlcD+w2c=;
        b=Ci4FdMB3zO57s1Iarj8zOUKG1NPQW1HoACex7KHybs3oYhGrOxfYdNJPWtp+RziTxK
         nzTpo9vLSJ5VFUatWjdeW3tQRQVPGf4PXK0zgFujffUBjKX7h9/Ate1P8lGRHGnF+TyZ
         02rG36vCRw9b9EkK6O/cth6MsCCHbFP/mksVNuyaFBtZRwmHx4//CP6LaHso570FXZrj
         CFEQApZnBhDlVRafXy9db3oJ9Tih7i8Q628nc+3oX/ypbor66QdIyYwb+X3w9c5T1uHO
         1v0EE5FRVfKtv9H0b80z7Y4kWFL9yfkXlgZveIpFavWu4Nui0kiAw4zgq3WsEUw74wMV
         vbIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769363881; x=1769968681;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HfwKtU2seymlppcOC0RwSpKtRsIq3Fv3RtXUlcD+w2c=;
        b=MwN4GV9/u9F8r/mHb7fLbKGhO8hz/hRhehJhoZ7BGThzlO8s2f6vD7u4QIq3Ces6pO
         9ekxpEaFulkCOQogrfxo6SN9ajUAkGZGrV1WWLxHLAM9o76WtBrgbH1byzRkrNnmFK+0
         1Mc3izH46U+6vNo52OKjNNsBfPcmzY35rS5Bfy/VMnz1LejjwYT+q7bVsE4QSfyJ/dTR
         uP7gk5w13Naywp+8rs75cHpPY5gu8do9o1//A8d5uponrWJirJDWPrH5my83sCj2wJiJ
         gl9AynxqMGiR8uoq4mqAsArZ6FN4EGGZtswcpGngAq8KzHz3/xqa830+RYUaoiO/emUk
         3zXw==
X-Gm-Message-State: AOJu0YziLC/S3hvMHl2gzECDM1hDrAMec9OQ/vViZ2OemTVUEOgOduOD
	qklj9bziBC8lYTtJpSAQ078TE4bv8LfrEo7l+WeHIQKBFZkn+X5LiJ5f
X-Gm-Gg: AZuq6aKjTlwMCjeL5yiKn/pPWeZGTFOaocTV252LRkZRDf2jqTtpt7hMVJMCFfMcsn4
	dtrHI8d89OrLBfJwWWUrqbyiqIL1TXzdZgrRSCSZIOQ+x0/nOy2Tu1hG8wKuiHXx9/ovpoJeYCn
	Uy/8uy2vYa78ZQeyCxgq2le/dxsaF8zh1FXY1uxeDPd0D9ITLRtx926A+KPnLv9Jsy2FdSXRBUK
	dRDaBRGdTtWmn46jGvxOjQnhk/8xWnwi5g/o5I54Ff981VlkPaw39+dyvSydS11JrPgzvxO9u2Q
	XPHMKnEv+ya6w59ENqa9y5mPR+36ui0FzfPvCMKSvZS9JwWn8+SIqG1eHbmtsq8nyoPTXDhpnQ1
	wP+atqsKUSMCq+h/8LhrgaWLi1gvdLtjo0cgqqenAO7HJwt25bmWz2o4xRc5/ZBG9BVT1TJ8AGb
	3pOAi6TjQE7Eiq2+aTbQ/tlnDDAN/9plWx1Z7/vSnfJ6kzpHL6
X-Received: by 2002:a05:6a00:4fd0:b0:821:78ae:9dcd with SMTP id d2e1a72fcca58-8234120ac1amr1397845b3a.13.1769363881157;
        Sun, 25 Jan 2026 09:58:01 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8231876e718sm7405963b3a.62.2026.01.25.09.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jan 2026 09:58:00 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Subject: [PATCH 00/12] mm, swap: swap table phase III: remove swap_map
Date: Mon, 26 Jan 2026 01:57:23 +0800
Message-Id: <20260126-swap-table-p3-v1-0-a74155fab9b0@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1NDI0Mz3eLyxALdksSknFTdAmNdi5RUc+O01FTzJNM0JaCegqLUtMwKsHn
 RsbW1AK5unfxfAAAA
X-Change-ID: 20251216-swap-table-p3-8de73fee7b5f
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769363877; l=3858;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=huLDa8un5C6vRmWP03o1KHLIzmWyk50+wFZOq2REcWo=;
 b=FjANrUxyK+OFo1M//rfDxJgiThayWf5bCa79goHryuH1ul5Kq9y3WUf2lFQh2aBjQkM2h8xgr
 nSxfc4C2Ki7CTkVPMuVX72zklf+F6GLC8553NmVm4DUxCL2x3QSQnYB
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam11
X-Stat-Signature: bsybdjwowf16kzaz69343cpdoj3taafo
X-Rspam-User: 
X-Rspamd-Queue-Id: 643771A0003
X-HE-Tag: 1769363882-186427
X-HE-Meta: U2FsdGVkX193dcF6Ivnh19674o0Rr3r9suwHveAFzh6j1dcEBMeDQQ15Ww/bn82A8X5Y2wVM+nVoDcuQa1TXXGcskz8fKJ3QkMY+7Ti6v6tS598JU8HvCyy5f7KoUFI1qYfCu7hQ7dJsHS7a9bfQTkj7NOWUjreFZFTUkDMuEpdUizig9tSpT6BE3zqIHQ7xEldSNs79lBM6/QGvcisnJWIZquYjwi56IQgcYyeBBiCGlfN3dS51+09q5vGUx6Nm6113xWDe+rVEbwAFE+QVadJe6zdECcdnmUUbqkvGWDulU4axz/rGhhdF7jzZnRykSVxnfBzU41Ob2y7efs+gKqIUIgq6xk/s+/knDFQPWJfnIguYxjHixqlna/bDPWOcb0gBvznS5VEPzBV8lxlDMrQe2TU8dc1+slRC3JztOHqkDSWTqo1LAGGMZt7aumO3YMMmrwxGRes7rNNx3f7S0UNOGkvf+2QtZf5GAFT1FRYfkf38U0O/iUBb0IJn+nmagxsXatKrYb7dUMZ77Jc1daVFIPWb1DzL+sWmFpK1kBeCiOvSy8dvH1PojzvLsztb8qV7fxPwdB0mrlnHR/la+CueJnVj90WhOKLwDa2My/Q6IECDbJRlqnO46yywEXRmGE856PSnWz0BPFG1pwfrOqnZvy3fHzvOhhWA+JAzyLlv5QuzMi+rfptru/TMh22MtdkE8VPQyFmjOJyHVPspHtbyDQiU/NXAdZ1DJR4d8Mn1lw4yAxn98YNW7AmTCo6TQ+wwJyPQLMSSZnbt5PhqAkb2f97oTafp7ZIAvhr9sm6AjWQKELZXizMJVLtipDwpV/wMPr+X4BIe8IQwuWBg8Mw2Ld5/ygfYAiDD2l+AgvUuMTKoc5cWhKyn6XUNo8BAqZ7kf24cRvtTX15a1l4RH0khX7+5NVHfepq6BYt0LjDEBd634BfK6BF4HlPBiukAESGPRVVB+SoUqMvVSP9
 M2pdD9dy
 /Wh4wtFI5VXcqpHJfP2gkvAXcw12v92U59e1KEXiQTCijgEzLeTsETTU6Ty+IzOdxij6hRKD0IeRfyzYzS81b31rLcx/O9SCS9WEfFkuFyHyMFs2ZdqOQUnqLlQ8ECYnn8toBQpPaWVG7TvLjJ9UyknXd2qJG3eux5Pge5f6YqOHcfdcsY/zf0DrHacj59yb7TqLUeUMV/fgch1lBiVw3BfWdYMVaBMpgsE5IIymGkFk7M1XbeDE9Ot/TcYR+wbr0CMcugcee2QioAMSTgOSW7kmuR8ZYXM8I4dj9D/qyZ1uymz8BobC03DX+GA7XmaesMvl/W3PqX2tx+x+eVmVepsOBUPg+kfiPIVYwOdICTYNdENtR5kDajqR8gUCH4dK9neqhp2QrO8HuyitK8YUfRiC61DJ3aBdHIXMDtpLKpSNZFZ01yo/jaY3B8wUV2GFRq/wk9IthS1HNV49KrNpqXU9TWlGCTNHnfB4kSe110e/PQOmhpWFD6VPwGg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series is based on phase II which is still in mm-unstable.

This series removes the static swap_map and uses the swap table for the
swap count directly. This saves about ~30% memory usage for the static
swap metadata. For example, this saves 256MB of memory when mounting a
1TB swap device. Performance is slightly better too, since the double
update of the swap table and swap_map is now gone.

Test results:

Mounting a swap device:
=======================
Mount a 1TB brd device as SWAP, just to verify the memory save:

`free -m` before:
               total        used        free      shared  buff/cache   available
Mem:            1465        1051         417           1          61         413
Swap:        1054435           0     1054435

`free -m` after:
               total        used        free      shared  buff/cache   available
Mem:            1465         795         672           1          62         670
Swap:        1054435           0     1054435

Idle memory usage is reduced by ~256MB just as expected. And following
this design we should be able to save another ~512MB in a next phase.

Build kernel test:
==================
Test using ZSWAP with NVME SWAP, make -j48, defconfig, in a x86_64 VM
with 5G RAM, under global pressure, avg of 32 test run:

                Before            After:
System time:    1038.97s          1013.75s (-2.4%)

Test using ZRAM as SWAP, make -j12, tinyconfig, in a ARM64 VM with 1.5G
RAM, under global pressure, avg of 32 test run:

                Before            After:
System time:    67.75s            66.65s (-1.6%)

The result is slightly better.

Redis / Valkey benchmark:
=========================
Test using ZRAM as SWAP, in a ARM64 VM with 1.5G RAM, under global pressure,
avg of 64 test run:

Server: valkey-server --maxmemory 2560M
Client: redis-benchmark -r 3000000 -n 3000000 -d 1024 -c 12 -P 32 -t get

        no persistence              with BGSAVE
Before: 472705.71 RPS               369451.68 RPS
After:  481197.93 RPS (+1.8%)       374922.32 RPS (+1.5%)

In conclusion, performance is better in all cases, and memory usage is
much lower.

The swap cgroup array will also be merged into the swap table in a later
phase, saving the other ~60% part of the static swap metadata and making
all the swap metadata dynamic. The improved API for swap operations also
reduces the lock contention and makes more batching operations possible.

Suggested-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
Kairui Song (12):
      mm, swap: protect si->swap_file properly and use as a mount indicator
      mm, swap: clean up swapon process and locking
      mm, swap: remove redundant arguments and locking for enabling a device
      mm, swap: consolidate bad slots setup and make it more robust
      mm/workingset: leave highest bits empty for anon shadow
      mm, swap: implement helpers for reserving data in the swap table
      mm, swap: mark bad slots in swap table directly
      mm, swap: simplify swap table sanity range check
      mm, swap: use the swap table to track the swap count
      mm, swap: no need to truncate the scan border
      mm, swap: simplify checking if a folio is swapped
      mm, swap: no need to clear the shadow explicitly

 include/linux/swap.h |   28 +-
 mm/memory.c          |    2 +-
 mm/swap.h            |   20 +-
 mm/swap_state.c      |   72 ++--
 mm/swap_table.h      |  131 +++++-
 mm/swapfile.c        | 1104 +++++++++++++++++++++-----------------------------
 mm/workingset.c      |   49 ++-
 7 files changed, 653 insertions(+), 753 deletions(-)
---
base-commit: 10de4550639e9df9242e32e9affc90ed75a27c7d
change-id: 20251216-swap-table-p3-8de73fee7b5f

Best regards,
-- 
Kairui Song <kasong@tencent.com>


