Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16707C531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 21:02:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 473056B007B; Sat, 25 Jul 2026 17:02:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44A106B0092; Sat, 25 Jul 2026 17:02:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29C716B007B; Sat, 25 Jul 2026 17:02:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E43EE6B008A
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:02:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5A55916037C
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:37 +0000 (UTC)
X-FDA: 85028522754.13.DACAB9B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id CCD041A0003
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lFj7w8nV;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785013355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TO6lwsfm9yD3fzAHYwk5XK83WiQ4wpFTJMXF7vsoc7c=;
	b=YjlYu+IlloQAUuiONcYrzlaNfUxa7LvRFPgb3/Ew/KD+GErDGZ305pFFnuLWQLQ9oBvQZV
	AV6vHPOf1YuLqmubgwLq/ujKQClFWSxq1FQuA5878J/5WWYbzuuqMfuVsZzyMXOiLxURdd
	QjuR8OuqluPi5cchwjHT+Bu3TahJx3E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785013355;
	b=xzXVoB1E6l9izuYHcb9WQG62avwLKhZSRYRo+jsBMOG2qNcTVpH3evM6FiIR30nWCrzufK
	B+0U4RMMSEMqCVptjIr7XiZBCxzlwtCIrGlxLJZSVJfxQn3HWBJKX3j0mFIFveM9tNUs2Z
	Bzhk85+lW8kdX34lztB1I6L4OW1McCQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lFj7w8nV;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6472460A9B;
	Sat, 25 Jul 2026 21:02:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131981F00A3D;
	Sat, 25 Jul 2026 21:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785013355;
	bh=TO6lwsfm9yD3fzAHYwk5XK83WiQ4wpFTJMXF7vsoc7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lFj7w8nVTqEB2buErY1jl7xXmFwvOsim1E4NC8kbWZ1Qu6ooxtvrGd6YXzcAQkTdg
	 Huw77UQNc2rm5KMoemylpLcMRVMSPHigiTHKzg/t9uY3/VdfAN1ntVNsgNA+U0eqB4
	 iaqK9aLDyKuYEnpgL/Szwhh3z1hVG6cTy+0cmEJqzAfzk3E8gxS+P5eeo1+p0Hl6jl
	 Hzynus+xvrYy/UPDb7vQAHnlOfK9IWKCjjFzKfUxsDbtovxAdbn5C1u07kuZH3VSJz
	 pZiCj/CTaMxoyWevhx4ZzkNNwCyCVoViZ158VU0Mjg6C6kA8iDkD/2xA3X/e02UM1P
	 AlqQOdScGPs0g==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 02/17] mm/damon/paddr: support PGIDLE_UNSET probe filter type
Date: Sat, 25 Jul 2026 14:02:06 -0700
Message-ID: <20260725210225.129944-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260725210225.129944-1-sj@kernel.org>
References: <20260725210225.129944-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CCD041A0003
X-Stat-Signature: 39ok8sh6zkcfbbuh9xewdzqks8z1zsd3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785013355-184921
X-HE-Meta: U2FsdGVkX18SMI6LVJ2arOVXAZRGn5oLhsSgyI7hsdqiYEAjluTfK0Tp+eYJahvrJZdo2vbE/pXovjPtCuFx2EMl54mUlnVkTk/C73Av8thSonWXOE85tn2ZncY0ck28PacZs85OyLFSSWyPZwtDpYMvy3/R1qs232iiW3wJmpYW99lwBnsHVxRhrYZF1KFTbdyjpqKT0v0jhg8K2+8Q4DiaBjlido3dvnfBIaHgWALJR2peSAfsi0R3Mu1/d1WwecPDB85MEMb3GjeMG0tWRvyqDaFsrI0LEMT/gx458PAOzGuj/RUghujWeL2xh32Uus68PPSMg3KYedgVBE7/yqvkoSJTmWHY0hB2p6PpMiCDpV5f0pary0HannvNyqn0jXyCnhjyE368oIiOtzGYkK+o0qKzdwU6MECxfl5CIq9JJzGrR/IdB+PG3itoC8MGO9TQ/213E7e1sinDET++khAXb/I5rbT4OhfdBfmoeNTWoD+27kCs+cor7/fPlYsTWU51sWtAPSC9NYvuBn9gYEk7sJId0Ww99X43ylhYhjjsK/8G12th9LYPMjg7PtrlVkjbIPDlb4S5zYvq8RMAGHzhfAtRQTLF8zJ+utmLB/bt/A6CaAstPfvTCjURa3JHDFGUgW3KB1Ij2ol2/Fmnvwa7HIwmwJ5iLPKgVDHi1uFhi4nD6jQDBpaTo40kxWmzk13kp24gKfou8k5Zx7ilqOUeiiHRX7wrgIVxpPcmz7c9ZVj4hQZUTzMf3sN0tHJQYNVtpgafSu0PbbQ72Ekbh/3jT7XplwfOrQwtR0bix1G1MGwodMhEnfcrUkAxmfStQrvrX79tz1C988bax4/lKyETy3luG1PRgKjAPdJVcOSP1b9JhO8A1qgu/I/PQz7WZmauQ8FvkCEcRBKcVNgLzZX/+qbREvr41aoaUoFfJ2fdawjuXMKJdoSwmPMjzwPXg73kzNQDMHRXe90j/V9
 wd/lY2lD
 +ZPbZ+jt8anX8FUfRTiKbyOd689AObIyzxS2P3kANrItL9aNVccDC4EFwcsqqxRHemtjlOBwxzCJSF4fsszH8Ts7LrzUGS7leSttaxpv/XwCjzHWQUOTEsFAT+DJJUKY3+ClBFUppqE0yxes4UrHynP0DBE0Q5x2vryZCroBjFNAg5GsuRcG6nxg7U0W35gcKQL4k7oSDGJCM1X0CBFRmf5djZO/KD9tqcEsxIrilf58XD1AD3XtgRNgWyouX9E7cq/vPX2k9ycJBnklbQxq8ZkRkoADQmM+sgFoeBoQ8p4pF+ic=
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

