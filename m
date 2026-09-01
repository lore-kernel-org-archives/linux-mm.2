Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91CEFC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:48:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82DCE6B00AA; Tue,  1 Sep 2026 04:48:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DCFE6B00AB; Tue,  1 Sep 2026 04:48:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CB786B00AC; Tue,  1 Sep 2026 04:48:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4330F6B00AA
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:48:12 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9C80F802F0
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:48:11 +0000 (UTC)
X-FDA: 85164566382.22.D548073
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf10.hostedemail.com (Postfix) with ESMTP id D01E2C0008
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:48:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=J9SyWHLI;
	spf=pass (imf10.hostedemail.com: domain of love_goo@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=love_goo@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788252489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n+SR/NJSg/EtwwaXWRG+qNU7rqtKtDhFvpyfSCWiMk0=;
	b=dz0WLGVwj3aT84MDfFiv5gLQ7f97fcF6Fa86RV/fXKH0tq9MgI0ZGzfIwZyHph54LtX6z9
	FyyRTY16W6x7gRQ7Yw1kKlPzlpfcZnunKmZfKr49hKEapgAiv2xNxvjUr8D/EumTctRDhp
	v4d79u3ZQRMlFgFsu6Bf9uu8SohI+tY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788252489;
	b=jXod7RJeUORUxF34EZJXJFBNLs0dvnmy0yATNFojO/G3FaQO4xGsOhvm/lF/Bm9emUNZ/P
	2pIbaCmD7ScbGqPiS7gfcz5XZYjHWaPJ4JI81L1AkrUAX29zSxF9iw4WFJ3FXSRhoCYrhx
	CXIa3cXlv0NwfU3aOsy3Vp/3z5UghPU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=J9SyWHLI;
	spf=pass (imf10.hostedemail.com: domain of love_goo@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=love_goo@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=n+
	SR/NJSg/EtwwaXWRG+qNU7rqtKtDhFvpyfSCWiMk0=; b=J9SyWHLItMi7+r+nII
	h+iVjgfLEXyNnaZWR0sbd0/n8Zwp07Jkvbph2RA8+vYRQ4roVeruLalcbdU/hxoE
	pxywulbn6BPvP8ZZIhXF8TkpI5ShXpotw5UaKc6o+tRZDUdiT5GFEp7ckkoW2j5E
	qBlMRS/VUPIO8zkCpGDQIJMO8=
Received: from hpc (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgC3qo4OkZZqHFWTNA--.28200S4;
	Tue, 01 Sep 2026 16:47:12 +0800 (CST)
From: john <love_goo@163.com>
To: akpm@linux-foundation.org,
	liuye@kylinos.cn,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	mgorman@techsingularity.net,
	yang@os.amperecomputing.com
Cc: zhangqiuhao@huawei.com,
	wangkefeng.wang@huawei.com,
	mawupeng1@huwei.com,
	love_goo@163.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Wupeng Ma <mawupeng1@huawei.com>
Subject: [PATCH resend 2/2] mm: vmscan: stop scanning ineligible folios after max_nr_skipped
Date: Tue,  1 Sep 2026 16:47:06 +0800
Message-ID: <20260901084706.3784449-3-love_goo@163.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260901084706.3784449-1-love_goo@163.com>
References: <20260901084706.3784449-1-love_goo@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgC3qo4OkZZqHFWTNA--.28200S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7CFyxtF17urWrWF15tr4ktFb_yoW8ZFWUpa
	n3GayDXr48Jw13G3sIqw1IgrySgrWFgFyUJF17Zr1xA3W3JFy2kFy7Kw1UZryrGrykXF1F
	qwnF9FWkWF1UJF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pEeMKtUUUUU=
X-Originating-IP: [36.24.89.45]
X-CM-SenderInfo: 5oryvsxjrrqiywtou0bp/xtbC7BGo4GqWkREuugAA3d
X-Stat-Signature: dkgesk85a9kdazysakdabwbrw3rnkjqb
X-Rspamd-Queue-Id: D01E2C0008
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788252488-138898
X-HE-Meta: U2FsdGVkX19QNTRCRzWSCwaTuC5IE5EbKu23lJ1lNtqqFEvU9kNVxovLM2ZDFEgceRHehBjnuEusNvD3j+b93Dh0fDo6WI/awH+KBOOoa7vLEXFPl0r9APt45VSjOE2RnmzIxz0ee22egUj14MPA56J1GmaIwsj+Nm4q5DVxKNRO3AeaRJn4Y8OjSWUGVA9gRJ2/D8evECX5/Lgdzf50uoeAbe07oCDJdncp2wY1jA/ZOjelJ+omqh5aqnHirgylp33UFe6E+UY1zyPdMdtuqeGXf6JzJQAhW4c7PMUGv+WyPlCpi1JPKmRDe835U6m6QSMwVULfyvc73u2u14pZXmsH7TKSM17duajKp4JgAOiXRbC4gZEY8K25Qfg5efWxYD9BI6/Kjqv6uMcAdMvZ5hPg6qVYGc621TlPE2Mda9ReNqU0LQg1fgBkKnpLM2AkY7UnD7MeJPL+Vca0d9LyZuU9zr480j7U07m6KYux6BI5gq4+uBCHZ1xbnLPOLpf6676fcOgcQXUqXrx3O7ikRpvAhx2Cor+NzjmaVExdhRCeeGbOTaKnUZ1aZoB4+pXvZmmeFCh9Jx1d8s2rZ80SJW7LulvgZGLxJabA32+2JUxh8xY5tfV9bHRocFp18yJhLaiO4Xv5wXIJ1Bb4Wi4jvNM0eRG4mHLbRsEGFMAulaJG2ZNcCyETZ4faIzb3dwPpL44//rSI5/77olRnp3a2DLbOVvQTKobswgjDUWavMgeuru/qjoXMaQ/66IGi5URMBAvz+EuGfUNU5Gat3+5WMaibNkKU096VZbgU6nMi9uEbyBpdy2rvxolplgj/UBE6JphetM1EvVAnT1hc4c/TEv1CtNzLT4anMIh6a5J3UtRZziwnnYVxX3wWD133kJ9uMgOG3q5kuGDOd7ovGj848H3lDM88cIG9Ex1eFwyCkK8iQeJMTSflat7snP1JwU1RLhj/nnFpNV+oZ5OeSq6
 rzjF0gDu
 useX4XDH99+yKsN3BrjwD0A/YzxkmdPbm7dMtcOrDSXVdvOEz5EHetDBJDj6GkUUhnW+xYJ88FuLVTtX4XdQ0AMW34MaOTY20KkARPsgeLIzLP6lzIloygtlAHAm+vlPy7mptXvt71U10MZ32SWFdgaFEpWToUwzNZMbPPaTgQn/dAo0x5eyIOwVzlG0kCWDEICT3cuOXVL1ToySQ6Fcg6bJ93nUbp3jV29+HdhknaZfiv/9h46Gd9gw4N51N3auNfHCh6cSHIuTUydzq2QfHx5a9wrFzDRGHrDUwDopBSCIOv/tBYW/cGdg16Tx/vg9lEWwrt1eIvqdZ+KM38kNf/qyBHobN0d8EzGnGq4tyi0UHCRA0nlH23m8KyOWqL7NT4uRjqQIY+jcKUE5tpy8ehdP48o16WbX7TJD5Ct+cb1Z/029gvRpoPHzfWCeE8evPsyce
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wupeng Ma <mawupeng1@huawei.com>

When reclaiming for a lower zone, isolate_lru_folios() accounts folios
from higher zones as skipped and, once max_nr_skipped hits
SWAP_CLUSTER_MAX_SKIPPED, force-isolates the remaining ineligible folios
to keep the loop from spinning on the skipped ones.  Those folios are
reclaimed even though they can never satisfy the current allocation, so
nr_reclaimed is inflated into a false progress that keeps resetting
no_progress_loops in should_reclaim_retry() and delays the OOM.

Stop scanning once max_nr_skipped is reached instead of force-isolating
the ineligible folios.  The skipped folios are already accounted in
total_scan, so shrink_lruvec() can charge the overshoot against its scan
budget (see the previous commit) and will not rescan them.

Fixes: 1c7b17cf0594 ("mm/vmscan: fix hard LOCKUP in function isolate_lru_folios")
Signed-off-by: Wupeng Ma <mawupeng1@huawei.com>
---
 mm/vmscan.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 823af9e86efd3..375f7cd5aa441 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1701,12 +1701,20 @@ static unsigned long isolate_lru_folios(unsigned long nr_to_scan,
 		nr_pages = folio_nr_pages(folio);
 		total_scan += nr_pages;
 
-		/* Using max_nr_skipped to prevent hard LOCKUP*/
-		if (max_nr_skipped < SWAP_CLUSTER_MAX_SKIPPED &&
-		    (folio_zonenum(folio) > sc->reclaim_idx)) {
+		/*
+		 * Using max_nr_skipped to prevent hard LOCKUP.
+		 * Once the cap is hit, stop rather than force-isolating:
+		 * reclaiming ineligible folios only inflates nr_reclaimed
+		 * into a false progress.
+		 */
+		if (folio_zonenum(folio) > sc->reclaim_idx) {
 			nr_skipped[folio_zonenum(folio)] += nr_pages;
-			move_to = &folios_skipped;
 			max_nr_skipped++;
+			if (max_nr_skipped >= SWAP_CLUSTER_MAX_SKIPPED) {
+				list_move(&folio->lru, &folios_skipped);
+				break;
+			}
+			move_to = &folios_skipped;
 			goto move;
 		}
 
-- 
2.53.0


