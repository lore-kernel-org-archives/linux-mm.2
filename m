Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47919C531FA
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 17:39:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC0F46B008A; Sun, 26 Jul 2026 13:39:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E49BD6B008C; Sun, 26 Jul 2026 13:39:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5F456B0093; Sun, 26 Jul 2026 13:39:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A609C6B0088
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 13:39:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0CFFDC04FD
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:47 +0000 (UTC)
X-FDA: 85031640414.13.7368B34
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 865764000B
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FHQ6mxzK;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785087585;
	b=sMbseHhi0Ww+mKO3ndn7Y9+Z5/uahAT8+7b/AJvNzlo6jt2OdccKMF86S70EpmyHVbeBNa
	GjiNxctqZJLzmzv6IctKxvbCiRzbxfi2hauuayNgVxMYqaDTO9IxzGEVKZbVnXAW8qKnXi
	8ZQb084lvw5ndo9I96Ep4TnkPfwrq/w=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FHQ6mxzK;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785087585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TO6lwsfm9yD3fzAHYwk5XK83WiQ4wpFTJMXF7vsoc7c=;
	b=izU+ZTDtuYz2lPEAu5ID99d7opewdfidtE6duA5tCH1YsXvjf7EQszvkXdFxTkBDl0LEns
	dbnyxdrL/oWDzAYk0k4BX8MtMjEXKjzPpsRFzdH5cy6gQYDCNMwvFGfXfwW604uZCfTXKg
	ROcrfwgIRdMed/BYFbjwBBHMWaRRoic=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1627060A9E;
	Sun, 26 Jul 2026 17:39:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976D21F00A3A;
	Sun, 26 Jul 2026 17:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785087584;
	bh=TO6lwsfm9yD3fzAHYwk5XK83WiQ4wpFTJMXF7vsoc7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FHQ6mxzKDEuHBHoOEGwZBQOyym3BeQ7ltUov1D9T3LMR2jbKsGRDEW8fiJKS8ZQUN
	 fVkCxNT/ttrp57AP0Lym8qGWAWfBgSTXUMfu9MCzxYdYbaDevtArz6vqRkcGk+Wk4s
	 JdhY6ko4nFmWIQHKtBQAO9KGNNE3lQj/FrBp8nWsOuKjmRDXgBaBKI3viF/3x7iwTh
	 JuCuVrJKX10Ap3Qk2vUZYZxc7PsghQASOZtnrZpaOnibDXPrx8chRzk+bOD13S+l76
	 GmvKd3iFGjgPND2f7ZvZf/entQ/W4LK8xkl+rF9k2cew5jX8Qr7660oi+7jvq5MbYn
	 DF5pvaEYLfU8Q==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 02/17] mm/damon/paddr: support PGIDLE_UNSET probe filter type
Date: Sun, 26 Jul 2026 10:39:18 -0700
Message-ID: <20260726173935.94046-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260726173935.94046-1-sj@kernel.org>
References: <20260726173935.94046-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uskqdobbdiu5r5n3q4zoc4t16gwdwpcg
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 865764000B
X-Rspam-User: 
X-HE-Tag: 1785087585-298181
X-HE-Meta: U2FsdGVkX1/hYdY4gGbvfOLVLO6xItTOwvSMAY36ANUeP2IN2RsW0zkAnpPdnbvjz/PXi7OHKWRopZhp4TAlXL4HkF7c7BAes0b9TOAw7ruz7S28HIGiMuFfptHso6yE065ekrPBiX5maoRFZ2eru/helZ9LofIVnq2PhA0iNZuOoXb/z4tOOfzY8VPgRlycoBrdiq22Xsk0bScsCoBm8TbAom9pcrwFBqB37elxSW8TdWPinkiBY5pyxC8ysqtgl1JhzLAVPr6vIgpTzvX3Mg0RYt0L5XDMCqcSKI9A2o3e8h/AR8u8+mbWyg8VSpPrxEASnKqB2FUMKN+l0F08uBuXnCDXO1S8p68Tqjaz0aY+weHYOHbtxuviuh0Z1eJlNmMViFT7Sz2vn0VZW3ldNs59Pxpo/Q+5ph3huYds3HNqsB+XJ0guQdU0g1eJuKMWouOLe+IH76LvgNOmZsl9I9Fj0pUC0J7bajvyw+Rs20w5veirj+gaNrGGXI7P3I7K9FDX+aAJjChXmxA5d0mSSJiFMFQ08cn9nVmXrH4V3YLHoGyGQcJ+w8I+evYsgRfbjwBNEtosNbakqpSw9iF0t8KuG3FEFeax5RWbzNP+6r6M1xKnsEGZqzTBUQ6/SRyE60he8vvui37LcGVLqxDjq4Wsin1fiL4RBR8Jv3/IeFmDqIytoKUGAqa3O6b1BZrZF3Z7T6aTdrhGXAvI9aUPx+TyGiK/BEE6VO3avRz7RhdnkAcfIrGGkjcojhY/6Rl7dsaU7lC1mK2LGaJEHMrq19y1VoQUQPkVlp5zuZqpVMqkVO0zJ8oO4rHr3kIOMOAT02kk+JEsV886yPSgcefWTNz3Quf+UJ0iX2Ar8/F1zSLgYBmV/qaoRb9vl7aqkqe9i1o+mSPY5gmyvQTfnEEA99WllU1pzfMMYKTuvaUYjDXdC/dj/gfDB/vgTxffnFjfXrrmgB2PL4UhLuP0Agf
 ekwBYIhs
 ze1oNNCB942z2ETXHDDuXY7LwCJTvKbNMHlEDyv/3qEt/JVZPTXRAjGYVmC/nw0Saemp4mf+3ZwWqjHZaegRXQ8xUq80bRvJloDIe6/T7T68N1fgqoIiF2CCOQSr1gdtn6xo7WqIZnf3QBafPaFG3rpb5TXE3Gv22VinZQqzjXO1U6auY7jR82bOu3Iau5uiB/p1ctwY6BfiTZEAF24pIiw7ROVTaZ+LtvGzqT8y3AExZxf1dtoA2tmgxVAyje/RKLa+5F7NaaUJA+vVx0BGkZMH6eLyOkocufheT4BiezKPH34o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement support of DAMON_FILTER_TYPE_PGIDLE_UNSET in the physical
address space DAMON operations set.  It reuses damon_folio_young(),
which was being used for access monitoring.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 5a6a78054784a..199de1463fa06 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -132,6 +132,12 @@ static bool damon_pa_filter_match(struct damon_filter *filter,
 			matched = filter->memcg_id == mem_cgroup_id(memcg);
 		rcu_read_unlock();
 		break;
+	case DAMON_FILTER_TYPE_PGIDLE_UNSET:
+		if (!folio)
+			matched = false;
+		else
+			matched = damon_folio_young(folio);
+		break;
 	default:
 		break;
 	}
-- 
2.47.3

