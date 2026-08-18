Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 367FAC5DF82
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 09:24:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 396556B016D; Tue, 18 Aug 2026 05:24:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36F176B016E; Tue, 18 Aug 2026 05:24:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25D7D6B016F; Tue, 18 Aug 2026 05:24:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8FF56B016D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:24:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 594D5140B7E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:24:45 +0000 (UTC)
X-FDA: 85113855330.18.68E6C2F
Received: from mail-pz2-f0.google.com (mail-pz2-f0.google.com [74.125.228.0])
	by imf26.hostedemail.com (Postfix) with ESMTP id 65C91140004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:24:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PQbCJ9Zo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.0 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787045083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vgrzyPwZN4L7nqoNRJuB9G+jUytRArcpJTaiildA9bE=;
	b=5YiQB8eVLLfm3hb2Ud0055Cau0vwcJTsMPtYg+0uDWjo5d3oUpwksTMNwZoZeR+N4G020v
	aY6XpzrUGJNXicJm00+UjnxK0DPVZzlLjI8HloAqwKas87ww2c2Px4Urvy6I6yHNvJSoiu
	5BcVnnkoE3FncP7VNxlVl//8S3rp4e8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PQbCJ9Zo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.0 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787045083;
	b=Hy+FzXHuP0qBdBDvqy3j/BLXLWRcXM3JF8VkKgS3nJmx7bbdblWpPu4odHa+nFk/f9SzbH
	tqrSaT2/IzdallaRCq9YFiVqjbS8lvyUYvMvEaV3Ji17i+SA+plEEubk078UXYhBrLrXuw
	siRlGYeEzdxz2zCaXHF1NFQMfmmqy/g=
Received: by mail-pz2-f0.google.com with SMTP id 41be03b00d2f7-c888c001628so2630060a12.0
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787045082; x=1787649882; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vgrzyPwZN4L7nqoNRJuB9G+jUytRArcpJTaiildA9bE=;
        b=PQbCJ9ZoBIgAYMrsen8oetdj7EniyR17AnE0nYpfavjexNj/j+apOX8c/8C7ghQSyr
         MZPksbaVwuwkFa8tvTg9vTDOd6KZXRoPmIjhoF0hglINT9+nntK0YnHxXLgZhgJPtfeK
         X1laDjeKwRBMPdv0q2MiGI15WA5kVGItPHJ6OKqX2Dp8gtnPCzpuBw5y6VVrl01H6PQA
         5hwmzb93qGTh5aFhtTiZXlQajQn38ZDOqWpiUbx3i1e9PHkfJ4GUPCG34mwAnAvZwQUu
         h20MvGpE2HdkOVd9XeKjQKW1SmH3JEHnjQiWsh+XYZFWTdZpaHzrkG8L7QNAp1ppC61B
         1tEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787045082; x=1787649882;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vgrzyPwZN4L7nqoNRJuB9G+jUytRArcpJTaiildA9bE=;
        b=bj7QZYEk5h09S7MlZoksWUvcMwjss+FbCEJMaNK3c1qGHaUmzLBtNFQsd6hNVvdz6H
         trP9EzGWg1x2fiNb+7bk10BZsUQU7KHUavqa/LJdDXF/TPd9jCz2ms0w67ggmvdRShhe
         bUw0+3ENbPpPzkKLlJcsKXbfTSC3Oww5VK0QksDVk5EYCY5G4KrjaLomtHT1DjH+bpZw
         C4Yf1VZADLwzQd24AE7CHAMW9XqWYs8xRmec5SeSKhn/j43UmxDslyd7TAIsel4aTF3H
         kyRastxTvFdUxLu3HmnppemuAZ+c5kiPRh6h/wIRTHF8loLZ6UvgEVpsOP7owwVZXy24
         C+jw==
X-Forwarded-Encrypted: i=1; AHgh+Ro/Qqg02sNgYWzw7CQ4I8Qvn8Ed5/AiBWbqGOkyGsxhJz7QmxGEGywKAc7M/B+HXLOCb4MfzLWGVQ==@kvack.org
X-Gm-Message-State: AOJu0YxfDosa9tKJokmhjTfsjCV3w+zbubE6EA80ZCCUw0TCIdYpHx0E
	6E6K1oz8vpAXCTUePLqaF3L3PBG4AZNqomVG2gIl/pEv5WoPb5VY5QRZ
X-Gm-Gg: AR+sD11fP4vHdwta2h3rc2En2QOrLdig4rwnIAlT30DEyJKNBGzfxArE7ZLYmCR0cB6
	v8ySRmWG4LNhwetdJBHioMkreJSr4crLnU5DBHQdu5PGzN1ZQdrkgK+Ih8SHaKE7T4UTgv/zaJ5
	kIV9imws0IQpV+F78i/X6NPeD7hHnsf5FKKqP4xhc4FNKTq4oE/s96yoKL/mJY70YaOp0RTKly2
	d6iPCCLeCJF53uE2e133YeiKRXuI1cbxU1npt86r61ClGN7mt3tvE7FBtRw/zM342afkF45Mngo
	8nVam0VgTXZ7MdZm+qJRk+Uof198FCePnvGcaWEI/2/TkT8fVAvZJyW8Y3gavoKzUnGtzCQvJQj
	NwjYMLdudfLg2FBLdAFH0O5HJN4mt9U48V0EprRT1PSTb+GkioyMOCzjbPc9Vd6J+O1xZfBHKdr
	oDRDo68nknauao7yLZMwpv1uOE3J98LAJ7p0oTr0lMZfCjtMnPcwc2Rxx3kD1uVOtzLnutowKN
X-Received: by 2002:a05:6a20:4321:b0:398:7ed3:a001 with SMTP id adf61e73a8af0-3cc71af5f13mr34124324637.2.1787045082245;
        Tue, 18 Aug 2026 02:24:42 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc13c036c50sm1855975a12.26.2026.08.18.02.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 02:24:41 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: robh@kernel.org,
	saravanak@kernel.org,
	rppt@kernel.org,
	m.szyprowski@samsung.com,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: akpm@linux-foundation.org
Subject: [PATCH v2 3/5] of: reserved_mem: reject statically placed regions overlapping existing reservations
Date: Tue, 18 Aug 2026 17:24:18 +0800
Message-ID: <20260818092420.2859026-4-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260818092420.2859026-1-chenwandun1@gmail.com>
References: <20260818092420.2859026-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ciikksenhr9togtcxotz4wurhyu7ntej
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 65C91140004
X-HE-Tag: 1787045083-249567
X-HE-Meta: U2FsdGVkX18m2UJv9m7EpKHU8KpcEnSrVhzy5Dy2oWhu6LDClMtrVaBX+A24dnQriUSBJpu6HVSYNHE2DRFNjj/61YM8mUExUwNhwdyolJggQ1Mc87lRAnLQ227GABO0Te2ZsCKURtkEzK4xNfq/wP5lDl2zZo21dm+RxCaIMR6MycpL0TNls/lnukf4h4mkMzBX98FVMjFp7UBEW3546oQch+2+z80CfvTEMLGw/j14bWcJKO8V+MWVDVJUbO4hbCsxvAaZoRAYSZXNeBndHE9BwcB+MGH9Zgudmq5ffZ/YX3Trga1njbjIB+AnJMM3Bm5ERSGg9DFmJpsKWJNrQXevZuoKvfB4idQ3A69X8eZtAGWakLFemCORweZAcHvKg2bzGmjha/1R/WG/xwnVxgNnnGdR6VVRd4cDmq7mHhWVLWSCJtFpYVNJihrSmzx0d+VQX48biu0Fhp/7CkJzw9I9ctDj0lIGTqdM4aBXr27+CKomAgsY26bLwNXbuzM6AlCVEul0Vwy9pbXManVg3CgryCJy/88+UF/2WrRYSDwU+MUQyc97r5B3T2EBiyRI+sGmJPbPjkqcwFC+7zV5YDN2bTMjaw6LZ4oH9KftzAmXvgrF2a3ZweFE3wCU0+0RfDYjCnunI3tMtkStgiE3lYcwe5qOTEifubBSFp7W1dFPsV7wIon3JO6GF84R/lLw/zCHMq4fPWiVC9dMnFpPeJwU1nxs8c+YTz8DG7JH5b2+nSlYRrlLlKIuxdS7WzSoZeMAYNJubXQS5wssxVlDTxkzkEBycCKywZ7ZoXxCtrchy/EojPw52TrRTzKq0JgEcSLh0VzT1X8dbtKO+i6HYd4G8u89Yokky5YTKYna8vzfSBhWcbnR5bhP/BBYNO/axVs3b+F5HCKOEr9Z4fUGBXTzl2o4g0GH0GedpCWEtRl+H4dt6qBvsYqetHGK2AZDuiIjJv8gv25PR99D+01
 rkWhS2Pk
 6i1xZyZGsB5/Ao5bnMuih/CLiHyzpaEUjTmDRL9QE+PFvBR3WQh4vtu4XMaUX91eD9Q2/YgrVnb/KaIgBRHn82mrB8tu2IcyZVuGqII2FsdvCdx+MmPWIrqKw5S9l9i/vk5CnDVwI9G62EjJ8ZIFB+UjRegthTaE2PY9TlpNL8xkYG+7SRamaeV7hrB3Lo4jOwPEohqNxvRPrFhhnUQ5rulA2heSJJQGy9bqJF7nLKo9KtSAf/kQrVQLpcp7MrBr0zevSiJolaR1+rfXe4WlSv6EC6sM+Lexrlsfll1JBxSdUETkZiJsqWUrTUbxkyXPXEmaVgiNnnBRXFu2/vT/nq3LfBl+u9/8k4JoIed61b9BWW08uFJxtmMlcsNf3DdJHa0E+5W7SrdRX7qf85i2bGOrpcMj/RpzVjIekJzAplNIXpS6I8Hkwkr20eJ+sIbh8bjQQd0S3G+ZOff0rlKtfZjV2j/SHdHL3DijtC4sBAmbyhBjhnlAkZAhfs7RJxCGmo4OETi4AiIVHjOlyMyT7s+i2WUvD+n1AaaX5N6+M3Z2N5Rr1iB22kRh4jwhv2Z1K/OCd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

memblock_reserve() permits overlapping reservations, so a statically
placed region whose 'reg' overlaps an existing one is accepted. When
initialization of a statically placed reserved-memory region
overlapping an existing reservation fails, memblock_phys_free()
returns the overlap to the buddy allocator, corrupting that memory.

Reject the overlap up front. Dynamically allocated regions are
unaffected, as they are allocated from free memory and so cannot
overlap an existing reservation.

Sashiko found this issue in [1].

Fixes: d0b8ed47e83a ("of: reserved_mem: fix reserve memory leak")
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Link: https://sashiko.dev/#/message/20260806100605.2C2C01F000E9%40smtp.kernel.org [1]
---
 drivers/of/of_reserved_mem.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 9fb2e4c29443..767ef702392e 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -158,6 +158,11 @@ static int __init early_init_dt_reserve_memory(phys_addr_t base,
 
 		return memblock_mark_nomap(base, size);
 	}
+
+	if (memblock_is_region_reserved(base, size) ||
+	    memblock_overlaps_nomap(base, size))
+		return -EBUSY;
+
 	return memblock_reserve(base, size);
 }
 
-- 
2.43.0


