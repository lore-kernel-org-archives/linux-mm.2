Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B67E7D59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 09:05:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F31DB6B0006; Mon, 15 Dec 2025 04:05:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE3736B0007; Mon, 15 Dec 2025 04:05:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD12D6B0008; Mon, 15 Dec 2025 04:05:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB37B6B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 04:05:58 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 78B71140E6D
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 09:05:58 +0000 (UTC)
X-FDA: 84221123196.22.1DCAB5E
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9D2D3C0005
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 09:05:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Wb/EMmp5";
	spf=pass (imf28.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765789556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=aKdKKPDOWf7vzMrR3rtnaetbgHmOz7vuwp2dDNjboIM=;
	b=LrJDOWP/1/S84C2iiddqPxXGOgSRVc45jFn5TNGv9epJ3gPUjFLqJjDN5dsjLgZmexvxzU
	VCuFEGbZ3PxqgeIK0T/UxRgFFX5sTwILHJXCc0I1EmXU5c6LvtdD+nANynswJ9wGd/Xa1Z
	TUO7Yv8OicbIsztAoWdE8PJo1Nnmo5U=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Wb/EMmp5";
	spf=pass (imf28.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765789556; a=rsa-sha256;
	cv=none;
	b=q/cj55N/7UYcl6FSIsYZj/q2qhqRRBSKiKkBNCLHDXKR6Rbx1yaVBd7Vghvsaf69Z6E5fh
	wBKTkIBsNRcH0Lct/Y6PSSPGYdl/VqVRodPLKq2zZ0C3u0M9NpavRnsMVVIToLGXwRFga2
	G6ue32fr0muu55jOofgvydOEsMb/dY0=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7baf61be569so3826342b3a.3
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 01:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765789555; x=1766394355; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aKdKKPDOWf7vzMrR3rtnaetbgHmOz7vuwp2dDNjboIM=;
        b=Wb/EMmp5FFj96xLp6AdyrTiqHqjZlwkVOxQzLbP6T2LwDd26p3AhJ3LcDuQcGx5sjk
         utXEtEs+M4fGbbuK/MS9mgbGKKyHClkX2YjWqOzvUuDjZGGTrQ/JsDvbiboqAMEUXquk
         rD7q90Kmi2JbS1b4e7jRVTEKNsrTK4/eE8AtnNhiW+3cC6eLMni0pmTdZs5TCo+UHMpf
         DW+tQKY0FhqZ6J/Nl6Tev2knCryxZU++DOEQ694e4HFdzCRT8ZK+IFAjvS28dsHqtFoB
         g7pZargP99lUXVNCwWpSpXd0pEoWyy9njx7GJCWTqTYtq16kLL8qV53cDWhDxQ1XTVTU
         pJOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765789555; x=1766394355;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aKdKKPDOWf7vzMrR3rtnaetbgHmOz7vuwp2dDNjboIM=;
        b=GmSPsciNNpqPB7cv1lu7tWTmxO3y/Gcdv+0R/A4x+n9TJbz13E4hRhjdpbNWh1tBv2
         jekmIZpaFkmoTxyhIqu45z7xDtd322ElZAA3lssFY5+TXvqysjce4tuBUA4J4ZovKSj9
         O0cTigX+uKBjXRZcY0TaKXe82TfoQ1ir6vY6yqC6bjhjt2ejb7XKPkPFspxBajhCMjoD
         yc3M8PpzGFWJ5lvNVUYydBdybgceAEZeoAdPhN7X0zN0/gKFRLsx5g2eDj07WiDuKLm7
         6LM46bl9XKV4chaWGcB2j13ghhUlJHNmJpY1nVg2yBsLMnAOxfzMYaMTlObIBHm7xyLM
         qhVg==
X-Forwarded-Encrypted: i=1; AJvYcCUyGmfIW+BOHFazYuCYGatC8sLjPpxpJD/1rTrUT2gq7JPlgBx+W928Z6+SdtY6CdeSqvv6QYo8RQ==@kvack.org
X-Gm-Message-State: AOJu0YxS64sVvb+IR6ckljNU7Og6MDxQf5s2VehUq41zKi9Um4rdCvUd
	cCOnZ8AArusoDEtNb16xf+lSvnKUMmq+UjC/5X2dBE6rKq7/jECQLSXu
X-Gm-Gg: AY/fxX7HieOnB+pMNJEEkPEUf0z+IZ/UGRN+kXhdbCsl3uy6jiYr99QD7qGsI1fr7YJ
	F6QSyrA6D/YFcgLRHw0QtBZ+DxSunAjciC710uiYFQF1t9gWCE64Wb+pw1fWsmR9gwm0dTWP4Ka
	leA+kuJJqAx0/0KlUiFKJJE5VhVR5yKNdbjqvuxNYZdPZkJtEoOkQ5B0rsAP0sQg/l7chqb2fid
	Xtd/iQUi7HwCmL6flVuELRmtgYlowjPrUSlojUaGOt5Vd0gpfi8GYu/Lfa3/r2PoRt9O5MqyhPY
	BcqPIfCDpatKRmrMGSOcU4Q8+LFnDthpP5EIY9ORV7qvqX1xxE6o259JwJO5+u7yW05DmAH+Pr1
	0WdIFX8Uvz4QbI07oOS8O5jmziJum75/UiGk8Ze4ltZDm/y4rvxwcjDeB6KrBRfaLxa1SCTkcHl
	fgHgVN+SwCQqpwHcguGdDIPtog4gv+GQ==
X-Google-Smtp-Source: AGHT+IEgMNDMD5jTUj08cwufsuYstUF8DV2qQWsp5rLpW0mkw4JoP75AYmribzw7hS50zZNGkv4OaA==
X-Received: by 2002:a05:6a00:f99:b0:77f:2dc4:4c16 with SMTP id d2e1a72fcca58-7f667b2b708mr8238562b3a.21.1765789555313;
        Mon, 15 Dec 2025 01:05:55 -0800 (PST)
Received: from localhost.localdomain ([114.231.217.195])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7f4c5093a40sm11993160b3a.46.2025.12.15.01.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 01:05:54 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
X-Google-Original-From: Vernon Yang <yanglincheng@kylinos.cn>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	npache@redhat.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH 0/4] Improve khugepaged scan logic
Date: Mon, 15 Dec 2025 17:04:15 +0800
Message-ID: <20251215090419.174418-1-yanglincheng@kylinos.cn>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qh43wmttnfqs3xezsp7zeo4ynxewypdw
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9D2D3C0005
X-HE-Tag: 1765789556-656767
X-HE-Meta: U2FsdGVkX18yDuSWnfmbZ5ElxEpBD0IhilpTFX2l8I6K5X9HzLchF6DPkkVrhClaCz6kTzggbwUnBTAVVWGYJjqTXNGMP+gYPUhEUYRZTH33/UxeDcQfN6sEVJLxXRE0ieJf5/teShW+86oMn9L0ULsnYulYVBl75mJUXtMwG36DCw83wN+I78w6bIqHG9IcNLJXnGL6FNjL27mmNKj0yYLzxykvTm8A16iOrcegiz3ILqG4yhuAgrIeglaa0Vt+cniu6Iq7c6e3TmclYVlcubbpHD2TEyqkScTF/Em4F8mYDWg0NbR4YXHcKc61eai3u80aXgjgDJLF9ev263G6ShywE56aou/gG9dZVUBbJ8VDstVTBzaMSnb36tHfUbUPR+jI8j4kFwiV8obAVPhq58tq9LqoE8qFjq+9EFKNFc/WpA2XYBDZwDlYBE5TUfUGTqPgcAhzUuaCSaADhQ0sIxao516VEa2St9LpOv3YWVmYKU6JwGHdJIOqibb2uT31gWyV/6BkPuql3nFx5Zbuy3gplnfSzvva6cxUIY0MEd5I25kDiSx6PAeMlkn9lBLkPkpTQclrFOASj4Br29behSCLMRS2SWwFSHCtpYB6yqZYLcq381xfN/hjJZ/zdplhOiwKJCVNRegJJvI0BWFjj5Hg8SY83yzx4eWY9aJSYxd6SC85hJS+1J4qX4UVNMvSCUOwqZ8U8YxiuVoe7q8ejgjWMdBm3Xd4SinoaiqPYODFXGj1zyQZQVxVpEaD65+Qeh3JNBGtWboW4hgwXwowpm2B/0BuuTovyMFhVdookAKAt7cx1cQWre0jvyL3bDnNpxw6ttHv+l2xchw1RXMLg7PL1nEPc/hcCaFnwbgatJyFwl8ZHSREzIxKvcZ3WiVf6Ryal5G1HIuF5fh8VNGHZOFKOtIu5XgEtFITzUC8w38TR4VFGzHxi4ep8l/fn8KwIcMNltMPAFpwaxRhIYw
 F7P4tNCE
 84p271XDW9qF7mcTOOPnHX/6tIEZB9ywxVQt/yGjkUht5W7McIj99ygTEXhBCQ6/X6t7nsilIDMcd3V6YomjLaXe9BEIlcpn7gUOHQrpaIUnFstPakoU0tcIxzXbJX57b50q8PnhsARC1o11R3rmKPFV2+WKJ+qBA3p9fK0EOJjLBJx/uqLyFKIOFdn3GznLlJlzFg0XMgGKUV9PJ0N3UPT5WegSxPbvi7eRIVI8q31T9c6Fia6ZbgPR4BEa6KGEFtjDdG71LJ0E26vuO9hWC3ZOBrtPv8hVXILIORXffmxw/LZKnk838ukXzJldhvlAviKaRj5VdKt5aLNsezMDQJhUbD28v41PhW+SqytlRj1fKtfyD5HESvLuxo9pstI3nSsCNiEGz0jbyXCE6KKAtg9HizjtMRLafj9Wonq5IIl9ZzIeotMvrCpiXCGjwCReHIL3LkXtGcfK+MKgbgKnJqQzPsRKn1wzLnwnI5yHA2ToFGKe0lFr+PWucu0oLZs7NjERr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hi all,

This series is improve the khugepaged scan logic, reduce CPU consumption,
prioritize scanning task that access memory frequently.

The following data is traced by bpftrace[1] on a desktop system. After
the system has been left idle for 10 minutes upon booting, a lot of
SCAN_PMD_MAPPED or SCAN_PMD_NONE are observed during a full scan by
khugepaged.

@scan_pmd_status[1]: 1           ## SCAN_SUCCEED
@scan_pmd_status[4]: 158         ## SCAN_PMD_MAPPED
@scan_pmd_status[3]: 174         ## SCAN_PMD_NONE
total progress size: 701 MB
Total time         : 440 seconds ## include khugepaged_scan_sleep_millisecs

The khugepaged has below phenomenon: the khugepaged list is scanned in a
FIFO manner, as long as the task is not destroyed,
1. the task no longer has memory that can be collapsed into hugepage,
   continues scan it always.
2. the task at the front of the khugepaged scan list is cold, they are
   still scanned first.
3. everyone scan at intervals of khugepaged_scan_sleep_millisecs
   (default 10s). If we always scan the above two cases first, the valid
   scan will have to wait for a long time.

For the first case, when all memory has been collapsed, the mm is
automatically removed from khugepaged's scan list. If the page fault or
MADV_HUGEPAGE again, it is added back to khugepaged.

For the second case, if the user has explicitly informed us via
MADV_COLD/MADV_FREE that this memory is cold or will be freed, move mm
to khugepaged scan list tail for scan later.

The below is some performance test results.

kernbench results (testing on x86_64 machine):

                       6.18.0-baseline          6.18.0-test
Amean     user-32    18652.80 (   0.00%)    18640.85 (   0.06%)
Amean     syst-32     1165.09 (   0.00%)     1159.15 *   0.51%*
Amean     elsp-32      667.71 (   0.00%)      667.02 *   0.10%*
BAmean-95 user-32    18652.02 (   0.00%)    18638.11 (   0.07%)
BAmean-95 syst-32     1165.04 (   0.00%)     1158.41 (   0.57%)
BAmean-95 elsp-32      667.65 (   0.00%)      666.90 (   0.11%)
BAmean-99 user-32    18652.02 (   0.00%)    18638.11 (   0.07%)
BAmean-99 syst-32     1165.04 (   0.00%)     1158.41 (   0.57%)
BAmean-99 elsp-32      667.65 (   0.00%)      666.90 (   0.11%)

Create three task[2]: hot1 -> cold -> hot2. After all three task are
created, each allocate memory 128MB. the hot1/hot2 task continuously
access 128 MB memory, while the cold task only accesses its memory
briefly andthen call madvise(MADV_COLD). Here are the performance test
results:
(Throughput bigger is better, other smaller is better)

Testing on x86_64 machine:

| task hot2           | without patch | with patch    |  delta  |
|---------------------|---------------|---------------|---------|
| total accesses time |  3.14 sec     |  2.92 sec     | -7.01%  |
| cycles per access   |  4.91         |  2.07         | -57.84% |
| Throughput          |  104.38 M/sec |  112.12 M/sec | +7.42%  |
| dTLB-load-misses    |  288966432    |  1292908      | -99.55% |

Testing on qemu-system-x86_64 -enable-kvm:

| task hot2           | without patch | with patch    |  delta  |
|---------------------|---------------|---------------|---------|
| total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
| cycles per access   |  7.23         |  2.12         | -70.68% |
| Throughput          |  97.88 M/sec  |  110.76 M/sec | +13.16% |
| dTLB-load-misses    |  237406497    |  3189194      | -98.66% |

This series is based on Linux v6.18.

Thank you very much for your comments and discussions :)


[1] https://github.com/vernon2gh/app_and_module/blob/main/khugepaged/khugepaged_mm.bt
[2] https://github.com/vernon2gh/app_and_module/blob/main/khugepaged/app.c

Vernon Yang (4):
  mm: khugepaged: add trace_mm_khugepaged_scan event
  mm: khugepaged: remove mm when all memory has been collapsed
  mm: khugepaged: move mm to list tail when MADV_COLD/MADV_FREE
  mm: khugepaged: set to next mm direct when mm has
    MMF_DISABLE_THP_COMPLETELY

 include/linux/khugepaged.h         |  1 +
 include/trace/events/huge_memory.h | 24 ++++++++++++
 mm/khugepaged.c                    | 60 ++++++++++++++++++++++++------
 mm/madvise.c                       |  3 ++
 4 files changed, 76 insertions(+), 12 deletions(-)

--
2.51.0


