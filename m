Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C3C7C982D0
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 09:29:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 596FF6B009B; Sun, 20 Sep 2026 05:29:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 547B66B009D; Sun, 20 Sep 2026 05:29:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45D4D6B009E; Sun, 20 Sep 2026 05:29:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 234F26B009B
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 05:29:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 918FE160404
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 09:29:07 +0000 (UTC)
X-FDA: 85233616734.27.7FC41CC
Received: from mail-pj2-f10.google.com (mail-pj2-f10.google.com [74.125.227.138])
	by imf16.hostedemail.com (Postfix) with ESMTP id DCBF3180002
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 09:29:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pNGUClC0;
	spf=pass (imf16.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.138 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789896545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PUf2wiOoUG9R7t6MRcmAciYWufgeLE7ixeOR2Gw9uJA=;
	b=3kOU0QOWFJvSniCqNk+BGYnOPSwYU6/OEsn1QRy3BDtz41X28oP3uVsDZHlejpiKb3up7c
	AO1VbBIAg4FIUuFo0BuFuMp/pugOA4IpZ3gv8v6VWV9FFO/5MbtaNYWoWbmrQvWLgvUAKk
	DII+Y+fdGw9ryhasCa1mtdkQ5xgayKE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789896545;
	b=FCB5rE5FwgIjGBg3SwrwSExUnZOS2prLB+yxfWVJoC1LXdaM6EUTC5fojuJVzoDsp90spb
	DJV0PpETUCX28SSKNl3PFQ9O3xFaU30tTfiVR0h0XhZ0swYWRQrQlVvD/+nqoClg22dv/4
	VtR58WTJ422d9MHiruAz/8SOTOiegoI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pNGUClC0;
	spf=pass (imf16.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.138 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f10.google.com with SMTP id 98e67ed59e1d1-39e249c766bso876838a91.0
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 02:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789896544; x=1790501344; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PUf2wiOoUG9R7t6MRcmAciYWufgeLE7ixeOR2Gw9uJA=;
        b=pNGUClC0vOBPGH2MH6Ba9hoRH2/8ZiEASceXSipIW4F1ysoAMg5DFMogyf6cCmXg8p
         SjpmR4/IC5PicrskWt0UE8uPynKcB70U9UUTJNKSw09Zuk2ji8qcx+2Lq02YO0W60DSl
         Uk85Q/hWRTcFRyt3ph0n1tZBO4apP5OnmWcWoVEsRk3FgiSwr+ASj50dlHEmOu05UfoH
         33TU0P99UJDghwjtXjmNS9rg2CL4RitJm2wsVuhjkL/D53kseh8LwlmlPHep5z5XXX5Z
         Mw+1BEGEnxRZCCDpuyi3TO0D8jLcWVg50j1ItZcMMB+UB5ykFm9GDc2156fa0Gj9sPyH
         aQww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789896544; x=1790501344;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PUf2wiOoUG9R7t6MRcmAciYWufgeLE7ixeOR2Gw9uJA=;
        b=bDik5GgEuJT1y/Xn/4KOGa05P1qUdqfOzRysG/Gp+UdYJFs1jpEDDlJeSL6NLvlJS9
         mjljAURcoOUdEpRTWkl2tHg0VOgrmbiX/VJjl0faffaUSZVug4vNWbXa/Sk29VnQFSkr
         k8N4QaFwbtzkf6qnmg5a9u85lZLWpvbp/Ms3RbAVyzPWGL2AzHlHdLEEbacVdUZi7+mn
         Gd0O0vL12M4zxw0yjifTz1wnPpenhEDIECIBxe9QauIGX1Olk48emIqd7UPj0oTXKpaO
         dMfzq5cZZynaey9kRyqAW+tLXnnDU1WdkPxi1MEypPDLfhMy/2TH7ifg1WpyCO5rD4ZF
         xLmA==
X-Forwarded-Encrypted: i=1; AKwUvBxNfn9NhC1fbdLjFNHo+lxsRSwLkC1Q02xWBJWCvzFL2eK9XQmZHJgQ3ANzVl+sZoVnWI3ZQJRyMA==@kvack.org
X-Gm-Message-State: AFuF++krzPpUWSD9QAsjATsgl3rAyPUN4+nrLL8MIxwUjOmAWbL9b26Z
	TWo5vtCp4j8Yr9YfZdcxo+AGybMNXgnToFgReXrGS6cTQ5IzRt1Isi+u
X-Gm-Gg: AYBFou3bo/z5zmsBtwojlRpOT+dnhZfJOudzCuG4BDMvLOBG8h85yz5GUi4QocfY8oX
	AGuGkKsi0noqXVDCZn6khU7fgOVFLYOceWCU8aZU3eAUZJqJEFGI1sRLx3JQaSsV6s9qmcdvwuZ
	+ugcNVYvwI+DuGMoCDoFSPIiNkAjnS/KCcyUP72sarzH6HBTQT5iOfwmnkHNRG1aYNfs9BQWshF
	mwakKfZ6Q6nRac2pRoBtE8i1MUJP0tkJfkV4xmx+LyHjWE+Z0Nt9yJLanA7aQrgzd/FyWJPtmwo
	DBD7OPLu+lSaZQ56c9NKuNocwCFc09cCQE9TujVZ4CR0GHZ1ocOW/481aIAyZ6xJJ+iH0rPsRMG
	N2CV9E2nVx0Y4nYZ7H6okXUZia/HMbV96adwyPV2E0lAf9tw8YgnCuv1d2w6A7IM1F+9IoSPKGh
	3y8dzi+PjYrCnPxyplSdqbE4wE0yQ3rl9hUx4hiihWMMed9FdY6pv4FJzEMrXyZD7Rl93nY3c3j
	te2hBmVUGY=
X-Received: by 2002:a17:90b:448e:b0:3a0:22bd:6ee5 with SMTP id 98e67ed59e1d1-3a022bd8582mr4720656a91.14.1789896544491;
        Sun, 20 Sep 2026 02:29:04 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6c37c64csm8154917a91.10.2026.09.20.02.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 02:29:02 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: robh@kernel.org,
	saravanak@kernel.org,
	rppt@kernel.org,
	m.szyprowski@samsung.com,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: akpm@linux-foundation.org
Subject: [PATCH v3 0/5] of: reserved_mem: several fixes about reserved memory
Date: Sun, 20 Sep 2026 17:28:47 +0800
Message-ID: <20260920092852.614973-1-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DCBF3180002
X-Stat-Signature: rjposd8zobnubzuus4ndhbasmfz1wrxa
X-Rspam-User: 
X-HE-Tag: 1789896545-810108
X-HE-Meta: U2FsdGVkX18H4KIng6HWFnEaqypOMKJO+7WLBerw1U5aR1uxjMbsKqiMzYx6e9dDCCNOGSvOresQhLyOkTlTWb9l6jSXkEerLV54AL0W/l2QoCTMV3INOyfqd3b90iw7XqjXKXbRw0RGvgV4G3LMQTvcJkQcSgl1PkXHH4JjwNURDZ0eZJWSLNVxSqdzxgu76qp9c7+vvVOvfgv17T3XTiNiguqet3aP/JV/+C1PFTV74fJ4DtC+lRMAZRtSDllBbRbkz19vZR315McQLnDeMfUVQV5Kf45pPZJMlv3OBKphKoekdGi0fGTIfJjuHJh2NxhQCvlY3razH8D3GyP61AUEaLdJidJ1Mj6d3BvrhmZRRXuPobxuuNqZmtOscimiGeXBpRv29yoepuJ5P0ehBGwJG7oROaai9Qp+1+Xy1RwsLAb/XvMGtYe1WZS8HQnjPJEkngWQiK6q/CLrm9uzEXPChH3vpzeGrqFAFgNoE+HIkLwnuM1Bh3fBznAjZt5BXn/BNh3h6LuuK+aKmxvg63AiiUTZzdqM2uDxGLNrOC+y/f1k0SRhv3fFEYvr9eWj9tSD7PKgsfyOti3E0nPNrwDSBMJS2k1GK5WTAeWsU6PeW07cbKFgWjD8wadV1uJt21AZztw+U3Wv8RaTSrfCBeHE3V5ZiUcispfjViCZ4rOnnXgd0aZeNbmeHiTCqnRCepfyL/v2ZUJSs/KbwFmZMFjIqvT/CBp12hhXnTLkZic7csPjkYfAKkO+jIqYiQKTUq2ddsFwjhd5o8US2AkYiER3brSlOhqeX9qOhdX/pSaaVi9eG2y1IV1wgI2Ih7x742dmbomt1aIvFzvyFQ7PcV8OTCH63dpkZXCiS8xM1keNYJHZYtGWK/zDZP6kNBgKAR7ZWUQ/QiMX0U8mqmGmMCN6Qd7xq8qRqB8iprna/wA2WZTkBoFAqZkotVFgD6dHHgVemcqk0eZCWXTtYCA
 Yqhg3E+l
 yUhFUvxhW091PF1rMefVlpLZnSD8Gnvm7vPIELpeDQsYTBuQErSAOz2adOGbaM3ktm2lUdpgRpJ2VMTikIaPrq/a7v7aqeWAuVxvR7vKOH5NWW4I1hJlortDYLid+cxJnhqLGx48iCs/CDu2r+vG+7TnzNgHURe7Ghy9rY0QabFrxj56CAsK7e4yc4zqq97dw+G5WyrBBXO+78iQu9Vt2OgdmRfysDT+tjwyXhG5/TtyHIZ+IKioJo6BNLJGMoxRGtZL1fregioJzSrP7FVbCKbEwVIH4XBOKPzjFBdo84CJtCMnoQOozKSZLhLNpM9sayD/nk2mNqeZlX49UmF5vzvJ4kXhmADEHXQUdIQkn6QNSmsJyqaHn+vX7bP1C8IyIwQoBOITAnKGQvs24ep+gkL7JyuIMd2HS8gzL6OSy4Xo2VXX4i20YNqafsrNId8s8Mk39wxau8W8VI82t5bjRkRM8sDD8PBl3tte6gyxf7stm+D953YiPb2Ucdl4AtYVpefrZarab8RdsUAK1Bxze4fguyNtn+8rlaWOX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

This series fixes several error-handling issues in the reserved-memory
initialization paths.

The first two patches fix cleanup of no-map regions after driver
initialization failure.

Static reserved-memory nodes are reserved during the early DT scan but
initialized later. The third patch tags regions whose early reservation
succeeded, so the late scan can skip the nodes whose early reservation
failed.

The last two patches reject overlapping static regions. Without
these checks, overlapping nodes can be initialized over the same
physical memory, result in data corrupt.

Sashiko reported these issues in [1] [2] [3].

[1] https://sashiko.dev/#/message/20260814090305.4C8741F00A3D%40smtp.kernel.org
[2] https://sashiko.dev/#/message/20260814084718.29C341F000E9%40smtp.kernel.org
[3] https://sashiko.dev/#/message/20260806100605.2C2C01F000E9%40smtp.kernel.org

v2 --> v3:
1. Rework the mechanism that checks in the late scan whether the early
   reservation succeeded (patches 3-5, suggested by Marek, thanks).

   Patch 3 adds a new memblock flag MEMBLOCK_RSRV_RMEM, which is set when
   the early reservation of a static region succeeds and checked in the
   late scan.

   Patches 4 and 5 are reworked to reject regions that overlap or are
   contained by an existing reservation. The code makes a little different
   from what was acked in v2, so the Acked-by tags for these patches are not
   carried over.

2. Reorder the patches: the two cleanup fixes in v2 now come first.
   In v3, the first patch now introduces the 'dynamic' distinction in
   fdt_init_reserved_mem_node(), which the following patche 3 build on,
   so the series reads more fluently.

v1 --> v2:
1. Rework failed-node tracking in patch 1: do not track zero-sized nodes,
   and keep a reserved_mem slot when tracking overflows.
2. Reject static reserved regions overlapping existing no-map regions.
3. Keep MEMBLOCK_NOMAP flag for static no-map regions when init failure.


Wandun Chen (5):
  of: reserved_mem: release dynamically allocated no-map region on init
    failure
  of: reserved_mem: retain static no-map memory on init failure
  of: reserved_mem: skip init for regions whose early reservation failed
  of: reserved_mem: reject static regions overlapping no-map memory
  of: reserved_mem: reject static mapped regions overlapping existing
    reservations

 drivers/of/of_reserved_mem.c | 86 +++++++++++++++++++++++++-------
 include/linux/memblock.h     |  7 +++
 mm/memblock.c                | 95 ++++++++++++++++++++++++++++++++++++
 3 files changed, 170 insertions(+), 18 deletions(-)

-- 
2.43.0


