Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F167F34C65
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 16:29:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD0D56B0088; Mon, 13 Apr 2026 12:29:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A816C6B008A; Mon, 13 Apr 2026 12:29:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 997846B0092; Mon, 13 Apr 2026 12:29:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8672B6B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:29:40 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 15372576DE
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:29:40 +0000 (UTC)
X-FDA: 84654068520.10.386AFA2
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf12.hostedemail.com (Postfix) with ESMTP id 33A7B4000B
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:29:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dPYLrY9m;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of charsyam@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=charsyam@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776097778; a=rsa-sha256;
	cv=none;
	b=AL47Jz67m9L2wqqmTLYOFchyfh7AFOiNCqq2ngw/Z/I77C3Srxq0DRmBhow1ZXzyNKHp6f
	0MvaY9hPvg4vQBBQNvW+pazeav47wGug4mFsa3BTFHlN/TYSmCsghnQt6bpKGomHmBbYP+
	cbDGp7GLsRI0/3V1Cc0mFrSXO7DRAMU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dPYLrY9m;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of charsyam@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=charsyam@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776097778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GxOI/4URINQL23ceJIk4nIIA53W3WmBZxkLhHAUmWr4=;
	b=PQ//n2BKKQgoiIaFJ5IEP9vDwNm8VS07x7oAjBIFIevCBZmcCI/hDKPhUhZMHZtCAdPKby
	0L2YbOJv9YHbZ4QlvEtDEoROzWw9Fr2cJgsxobnKSTmq9jWMzag/jyXX0TEM4XNJWSR4Ut
	s5uWFCpy92szwjtmrczLu7UNQl+SBAw=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c6e85f76efeso263254a12.1
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776097777; x=1776702577; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GxOI/4URINQL23ceJIk4nIIA53W3WmBZxkLhHAUmWr4=;
        b=dPYLrY9mVJ3YsAYAQYg/iHvBMlQVzuHsUwNAFcw1JY3v2AC24w+RiIb1TVJze0kMb2
         a1Zgc08jHDxdxvQGFlNlTiLSBbI8yIJqfoQ3AL/iEHBgltpAcnlmrt4vg0+Id1CONGPM
         pVzpL/giNDJXjnHngI58NXg/ZqJJCZpD/OvtoUqyPIyZ+Bpj3l5fOgVUuvR+/iT4mqKX
         eyVCrvndSXET15CMw7a2kosKYhIdlErJa18DME7SqZG9o9F2csi1mB4X+hGPQW70fFfz
         cjTP5BFWQZGaFADjaeJ0VnRvVQyFADvCL6W2yXbQRAXAK8EnrQvj7g6rlbsXU7msuB6a
         og+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776097777; x=1776702577;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GxOI/4URINQL23ceJIk4nIIA53W3WmBZxkLhHAUmWr4=;
        b=hk6UXZSMwIDQK54PKyhlavyW/UoVAxw/OzpFIBVgeaahKbuh+jSFVAq+DFGVoljH53
         Wow554WGueVGSVJHjiwa5Qe86djzmQ3V2kYqDgGgLGa5I+/TwFuFU+B7WLrD1bqeX8IW
         ybXb8r3CX7l3GUa4xeCVmnQXcyZeDpuM9+oiQ9dP0XFsVBnXArn8RfIRq0mXBHfCl70s
         ecFWJdaqIymxKJvyB+e8IZ/oU3D7+0JC+/ZRdVO5CiMRz9Goa/MUxVni5dVZOyv+HwW6
         7SSPwWBrbjvrRXVwayTDI8c2HNoRE52Nu9/qxlA98D2lJISZGIGZl/HMx+zaRsGuD3Fh
         UW5Q==
X-Forwarded-Encrypted: i=1; AFNElJ/R4l1/Tujjd4Dd3X9J0VRK+Y50Y/yeRQy6dNVlYlf2Dgvb//kS/aa+CQOj5270uTaCTIBa+LR5mQ==@kvack.org
X-Gm-Message-State: AOJu0YytpjviEkKeXSQPkkY3wKMkr0PCjmGL8LBVkW2Z0eEedvZXwCq/
	GuT240QwOm0zL05EmXtW8Q3F0TWoKAW7PUOI1xf8FEncMfYbXUtlF3nB
X-Gm-Gg: AeBDieuXFG8JLncJC9rJ3u/1UcUA0ZXbmRgsE7NmxGUx/hPNBVB4Hck+iwac+I4U2FY
	XeTPhGnrR5oYo5Pry5t9a+GWZ9q7QkGkgylg/H76PGmnRJVIGLMFjIgVvK/AOzleoXMPulEHrhH
	M1bCr6LtQgwPIbfV+H9RwXxpbUkL7JKMfop/0cpB1/aSyemNj1QEGVVbkxsL7nQqCF+7N1t1Zrl
	WrQ2PtQwB0F54piwFC8kIVo5EgDFSFiBKDJl3DUe/BLYO8ZYC8HLRgh8u67bA4Cv9R+0D5jBQ1+
	8Ksrr29BdUAFUIAk5Hr4H5yEnbgVtgpqZcyUcfTgfBajLaeSIfNZZKmS+kAfzE1CU04Sfx1q9C8
	Pl/AtR8OGOfoxzO55BB4E3+aFEXPOhoOkxi7T5m77C2hEJxBk8IpR3fMqc83sB1vGHPtr4YwGEh
	3yduro63J9+OSHWNvjQKzgXckEg0w=
X-Received: by 2002:a05:6a20:93a1:b0:343:c095:c4d6 with SMTP id adf61e73a8af0-39fe3f7747amr8600509637.3.1776097776855;
        Mon, 13 Apr 2026 09:29:36 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c338dafsm12905368b3a.17.2026.04.13.09.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 09:29:36 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: pasha.tatashin@soleen.com,
	rppt@kernel.org,
	akpm@linux-foundation.org
Cc: pratyush@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	DaeMyung Kang <charsyam@gmail.com>
Subject: [PATCH] mm: memfd_luo: fix PFN conversion in retrieve cleanup
Date: Tue, 14 Apr 2026 01:29:29 +0900
Message-ID: <20260413162929.156163-1-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 33A7B4000B
X-Stat-Signature: mguwhu1ur7c1w9x5rosbp5t5z468dtc7
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776097778-208117
X-HE-Meta: U2FsdGVkX1/yQ6PQ8IEk/cgdwjzTXn9vNAF+rAVqBCAISAtMtbYISO5n5Dz57QsNfDSNz5/5NSayGlGSqJBUDXIV8NBjlLcvvuPpvFHpBJi2xcLw1QvltQsmmpDMOjP6qj/js2vXnAuiPNX7LeGJfk7ssBE5Bmo2BqcA2zbmv1GIWsChRtxIvvVTnONtQFGOEsUrAyAmmXEQ3/mE8XTUlJ8ASSsbPAOpWPEhJyYFFH7vvLwv7pm3MGQDEEPi0o6JZhRcDbdHjcsIE9YQZ7jhV1vYkZ92nYGOlAqt/HBY1ociC5Gs8tUZuuzeQy/ZZdiDAKMm/LolWXQp+ozcBWDM7FvjeEu0Peyy26fW+gN5q/RzGIIDTirAvmqHkXKnyI5q1ucQ4oGAWuuoSEIY3GTbTMiWaTPoSbcYXsFlnhRBNEniGMyQ844oxTxvhWVpqWODCnVMZoYEgg0y9yABc6F71X+o43IrX2lpzXHCTa6uE0M6bS521Qzq4mxjAIYepVYy0MNhRS7YVWEM7SJ07H+TMN8i7+4nfCZg0HLvO7VwJDbD6hs3Mf6f5IauK+BSvMOKlo8+skCbPHdYXgXSdbV+JRnm01VX3sBvIqPijHqX5CXWsEM5mWEh7fjSyDu2PhXQSTT3Si7cDh2RNVItU8oX2gJ19mw4nLEY0z0r666FD9yC+ujTBtznNx89yBNJz3xmKWs5kiNNVR6zexLMmWaLMOrQsuwcpWnDZmzB6x4dzHF0tIvoaMJE0BJ2vHMT+0SpQdPC7piCzjdteqgzToXFuiqmtBdvGEW6myI+klZubBTZerE9gl0Z4gFZY7yg9nrLiS027GavaGAQb8sFz1UWZXEnMNz/23NRo5JbA1Yzap2B+II8pxWVflRoP8BsalxeMcdjqsP45/bl6kLRnMQW2xCSD6iudp59Bs51eOSZhYj9dbuUKA0hwSmyukYSYp6doy90NL1i9ANaF0slQCE
 iREJMK69
 5OaF25aikR8sKGU12XwQs7rbKxMmGhrHzal4YC78hdXr+NXdT4BThiuG+l1HsoEAskJtW0uBzGPp29H8c+gW/VPfJxH2DETQ5aIdhSCvlczS/FA0js6r+IFk0X1myr/RKn5cZccoisi6bA8MP2XjCJXpUncCXGRLUpWc0YlOd7Fnhd3Gr9xyYt3x9TDzENpAH2hHPR0+LMhVQyhqEhmqHcW73Rg3CbW9un5hQP2GXrdPLyt1MWI3/zOnJa5rr825sCWxfCpma3CV7fgIawxLn2SHK3rkzUAQGtsG8VA3nAItVoPuy8eDJkbQN19HEs1AZeBchMj2fKjOHfKTSOtAaYEwGFDeEJwonNY2zH3ay5itBLNaoPt03dt2T2kyP51S/jtKs7Yjx8eKlvPhETdF0QgCupHmwpdwaVj5EZQ1FtrBWZa+j0iuGBqLAFa/2CrRWHTxL1NsotUlb2oMcsdpXtTQX2dCsZOf4VHqnZ3fnczTLwNxtYj3uoGv76g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memfd_luo_retrieve_folios()'s error-path cleanup loop passes the raw
PFN to kho_restore_folio(), but the function expects a physical
address. The two other call sites in the same file (the discard path
and the main retrieve loop) correctly convert with PFN_PHYS() before
calling. Without the conversion the cleanup operates on the wrong
address and fails to release the folios that were preserved but not
yet inserted into the address space, leaking them across the live
update.

Apply PFN_PHYS() to match the other call sites.

Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
---
 mm/memfd_luo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index b8edb9f981d7..6d8aa429f553 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -467,7 +467,7 @@ static int memfd_luo_retrieve_folios(struct file *file,
 	for (long j = i + 1; j < nr_folios; j++) {
 		const struct memfd_luo_folio_ser *pfolio = &folios_ser[j];
 
-		folio = kho_restore_folio(pfolio->pfn);
+		folio = kho_restore_folio(PFN_PHYS(pfolio->pfn));
 		if (folio)
 			folio_put(folio);
 	}
-- 
2.43.0


