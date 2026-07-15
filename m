Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EAE0C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 14:37:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12C606B008A; Wed, 15 Jul 2026 10:36:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DEA76B00A0; Wed, 15 Jul 2026 10:36:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0DB36B00A9; Wed, 15 Jul 2026 10:36:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C737D6B008A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:36:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 562501601CD
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:36:58 +0000 (UTC)
X-FDA: 84991262916.19.165A6E3
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf15.hostedemail.com (Postfix) with ESMTP id 97A75A0005
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:36:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KCS+KIgp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of gaikwad.dcg@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=gaikwad.dcg@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784126216;
	b=Wpw97/jevsLhs483H5ANnNqmHRm+xGF39ZnwHSwqss8DOB43+kgecOPX83gIRLwZcv/tuL
	932A4ZwYafnFMU9kLxBVS3irRMpBlyO1Vs6dgHuCgD2GaiwVVf0hVDGU0oH1hRF0bKUqVM
	U9vNBO1TbzrWxBPI5B3Z2z98qrXSuEU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KCS+KIgp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of gaikwad.dcg@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=gaikwad.dcg@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784126216;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=RvQ8OdPR9vpBhm+L/rEfAflfgo+Qjs2tqwr6l/qMLKw=;
	b=amArFY6qx0B2VSCn0yY5On/UlVffXk5A0Wfo5pR8kFrVy8x4ydmIRp2lt9WvyeLzo5rGPv
	gIax6pFRN+iQqZg55o0KlspDAS6MDO5qBlqOgX7idmS9Z3yW9EA9hEoYWRjTbKHXrJZps2
	atqb9LcWue619I/7e8p3zFb5b1gTihs=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-381ed661712so5973205a91.2
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 07:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784126215; x=1784731015; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RvQ8OdPR9vpBhm+L/rEfAflfgo+Qjs2tqwr6l/qMLKw=;
        b=KCS+KIgpXFyb1B5t3p7gLGxLh2oR1YVlCJ91S0+ASqfSlTXGfbu66yNQf2Ef61qNlm
         +Fbn7TAjLUVQQ2FgAnuXtTOqWvWwVgDXw+6TwprQ81Dsvh7JrodCWE/ZfaSBvt3Crnbj
         wAdY0l7jL6T+QlM2EOtwRpTXceD7gbCfy/URJ4/Xd00qRFoPwK7g889Vy/HCXlZoTKZM
         DeFNUJXdU/07NgKzp3MpjIfGFKtfsPjhELEyCJbeFLw9l/RuIu/awYtCHPkzSb/Z38LQ
         gVkMxpX8HAkE4octIkzl4Otzlt0IU/YP/RHyU1fvkdy/x83kIji2DhcbwaWmov34BfvV
         wd1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784126215; x=1784731015;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RvQ8OdPR9vpBhm+L/rEfAflfgo+Qjs2tqwr6l/qMLKw=;
        b=DNIM8mujfvMLtuOBnrPJ3WWZaKwd1nJNLmfj6qyCZ1qk9EyCQbVUEXpR1qUoVOeL3I
         fXrfQyCkCYaXFuFhK/cDucbCx0Aw/aUcZyzK+yuQgaqHb+DMTjX9noDHE6s1/EomhAFd
         0pTeUPCkK8yj56eZELfOECZa3z3b89ETAKAlf4EiDk6/OdHBC0Xab9LZoL3lEEZrTGCW
         NnhNoBqq5Y3pWH15EWmtNc8fXxaxFaHCrQE9HcXg/WORE4wS5BqPaL8Q9GokDwugjjXx
         Len+irbOotpEzwQDMqAThEyh5iYDm7QYvIbm2Bd2/WCC3iokmqi+moAF0nauh1+jYhKZ
         miHQ==
X-Forwarded-Encrypted: i=1; AHgh+RpQWM57HlCZ0kfK7nFlQi+omy8ZT/1G49ZFm+h598j9SentyWNXmE5NjoZlaqWq6WgOX1bLmT+veQ==@kvack.org
X-Gm-Message-State: AOJu0Yyvgf/z6bkdqD7/MWDkaSNmEbxAfg9WbLvppB1imGotXIAT2QL1
	fxnf08yDWvgrgKWtfHUWnh7lQNW3KX8ZX05YE/9mBH/uxxOGx11Uwvca
X-Gm-Gg: AfdE7clk4ETNMYeaZ9glMAheYoCmpgbvdoQKRmPSHxXFm3g2urVWtGvpSFb1qkrulh0
	fE5/iUYjb6uNu324lS4di109pHDsPhNCyR5bYqnsX3E2+kk8F+9jXiPyOPSoRnzsmlVLZ1po9J0
	XElrRVTGNx6cYXBhtk3iU6NUc/POWEc1WInKXDxbOkd+NwDg2/reSDzhVYU9vIaHP+wt5YKdYFr
	t3875RJSLbKj9yO2caKHiafnefe3hwfgOAB8ip2g6y1+cq6UnNqA80yUnUwXXD9+653Y91oeGHO
	6j/3jNP3vc8WG7N1dYBLIeBu71fvPdVjGRd/+yvoHXJVLhqKAR80jR/QjcNjEwR/i4q2BhXnju2
	zjP2yFCHgyJmSAkgMShiimeUM2Pt8oaiiWtwAAGgw63k0WCIzS7vrwT9DAerVqa9nGnd5E2YuGa
	rZ3FPoKKRj+jWiqNxaEJq/HNvIp1Wvo+cQQwOpsbVWgTMIlqOh11E=
X-Received: by 2002:a17:90b:2544:b0:38e:408:9d7d with SMTP id 98e67ed59e1d1-38e1af44e01mr6899197a91.36.1784126215214;
        Wed, 15 Jul 2026 07:36:55 -0700 (PDT)
Received: from localhost.localdomain ([2406:7400:90:2db1:3066:c473:74d2:497d])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3140e4fd3e9sm2020161eec.1.2026.07.15.07.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 07:36:53 -0700 (PDT)
From: deepakraog <gaikwad.dcg@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] mm: vmpressure: scale sampling window with machine size
Date: Wed, 15 Jul 2026 20:06:41 +0530
Message-ID: <20260715143646.15828-1-gaikwad.dcg@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 97A75A0005
X-Rspam-User: 
X-Stat-Signature: of6h9q17zudwxcay6mx3ddubs49q5b5o
X-Rspamd-Server: rspam03
X-HE-Tag: 1784126216-53614
X-HE-Meta: U2FsdGVkX19ZqbJ2KYJU5wFPNE5OFNzjH20MCxNe45y5bBvMAKlJ0VQBypr+Pui2ig9zPdQApMUA0HEo635ePA+vDGeg6DiZa/xSqVwtjTDN4abLC3hREyVUidLoyAagHOo2fVRxzQ5OYP7vlu1f4heHTGilH7yFN4gGhWPXiQUs8YIwpdxKy/UfPaCW3Gpf9PvxMwPEbIgmJY0/J2qoycrMFkQc0Vh3IpnZPhqS1sI4egVLdi2F/ykgzzVo+kS3N3faJN0BOvIBGSPfy8ZSQlmevY373rpFHrGWh+ucAFIOgLm85JSiu804vGhm/mr24fw4bB5PEN7z8xWmgMQwtDF/8yfqOiezwXJxt/iHpcyuOJGcbwUIQ1d5te2TAO3lN8brPOkzs+NimVcVPt809gUfAl803hHL98V+8YGOl3Mxf7MkcL8oiw6exhtMoU+qfYMyjprIDNOUUKhwn1nfM2A8KaRxJMTmCqHM5BzEVDlP3HbMO0eauUj3XXMy14uCmRvMogKfsh1QYfLCtTTBR0FiJ3dam21M41N/YQ2WPf4XRSNrgQanYjBwilR3mpvL7W0UMFQVEBC5Vcsy0zWa1hbQoonaMkgVK9KEZvOYvUWJllNawpxsp/M6moAYtGNNsqRTVdkeMm2f7X7CwP6Qq7paaVMfajOZ2Vfc8rcu/OkulqTaSQ4mP9Gb25INtD9149TKodkJbE5K+W1X74TNI2gBYQ+Sx1AvWSpb7dK5IAU0DZAZ2MR9ylUYQY7LGLOHio8dvGTsGlJro3c4WJV8p53rTOYw8TtMmgsgqoNZHk2W9NOmnWzzHuW/6K+y9+tT2sBVrnqmu8MfGf2wMu/+c14L8bK1Cakt+X6cHFHtROrroSVhUrMUDh/xeUdFGfpbhEueNCkNgNZ8j7ZejVao45m+3tNoB1BH9wZfKwMccO/nNsIbz+q4zsU3213peb+F+ZVKRAnfwlMKHQPIP74
 v1UUBgvz
 fxR+FBeY2i3D5sMSneqtFkNVVZmCvjYAgfc5LeKbhbp6u89WGvinXviK9Oo5FZSkkGPvN4Pt9ihThqHR6EBpmqM7Zz1iDAu03penb491ALseZBZZN/e4pifLpggXLtFtzcw2N/xWXmDzzXb9cD7i1osB20Z2vGMBXwq7gdEkjMKoZcjxfpGWOESsT0dSq0qSuvvUKD6w9VfOpvUUKR3QSGhLlJJzDVecEhR2wFyGRfE8feSyHyy+E7K78oaH3WyeZYx07kOT5HUeCfQRYC7A9q+gv7xK3wwTJyydsoPDFs0RC6xPnen/sXixlUn+SamO26lIniDrj2RHAhv9XENwtrxbYmTVOGXZd20anCL1UXbXBqkPiDkx+wgHrCGCyWrcbUf0Jy3B7LgDQJLlxJdCcHUMLp9p1VlAJtmCgg016mdj59mMVVWvL5JnUEYHWbatNbco6eVmA/pP/fXo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The vmpressure window size was fixed at 512 pages (SWAP_CLUSTER_MAX * 16).
Scale it at boot from total memory and CPU count using the same fls-based
formula as vmstat per-zone thresholds, clamped between 128 and 2048 pages.

Signed-off-by: deepakraog <gaikwad.dcg@gmail.com>
---
 mm/vmpressure.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index f053554e5..8925d4ad3 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -33,9 +33,29 @@
  * SWAP_CLUSTER_MAX, it makes sense to use it for the window size as well.
  *
  * TODO: Make the window size depend on machine size, as we do for vmstat
- * thresholds. Currently we set it to 512 pages (2MB for 4KB pages).
+ * thresholds. Scales with CPU count and total memory at boot.
  */
-static const unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
+static unsigned long vmpressure_win;
+
+static unsigned long __init vmpressure_window_size(void)
+{
+	unsigned long win;
+	int mem;
+
+	mem = totalram_pages() >> (27 - PAGE_SHIFT);
+	win = SWAP_CLUSTER_MAX * (unsigned long)fls(num_online_cpus()) *
+	      (1 + fls(mem));
+	win = max(win, SWAP_CLUSTER_MAX * 4UL);
+	win = min(win, SWAP_CLUSTER_MAX * 64UL);
+	return win;
+}
+
+static int __init vmpressure_win_init(void)
+{
+	vmpressure_win = vmpressure_window_size();
+	return 0;
+}
+core_initcall(vmpressure_win_init);
 
 /*
  * These thresholds are used when we account memory pressure through
-- 
Deepak Rao Gaikwad


