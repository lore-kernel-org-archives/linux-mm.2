Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33297C5AC80
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 12:32:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D781F6B0116; Sun,  9 Aug 2026 08:32:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D296A6B0117; Sun,  9 Aug 2026 08:32:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3F476B0118; Sun,  9 Aug 2026 08:32:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E6BF6B0116
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 08:32:15 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 98B784055C
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 12:32:13 +0000 (UTC)
X-FDA: 85081668546.22.ACA23DE
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf07.hostedemail.com (Postfix) with ESMTP id B36104000A
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 12:32:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=mWR+CKra;
	spf=pass (imf07.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786278732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=efYPvCjUsEUH5QronJogwjmNGwQFrMfQwWcLj7jrAeU=;
	b=4tkD09OnmL3J8TnDuYrCYnRADp7E9+m4wwnerXTJFWD8/ODdPB9w4m26eccZ1elcciNvqS
	xJqqIM2NEtanZ3wZLaPWP2LlItijSMZhj5qByXwD1Rz3bz+Qy7umnlQ7xp40sqzlIfz4yj
	7Xt68TP9wzMNKs665Wvq2Vg3zGGrkqE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786278732;
	b=xHkcGRKOQesBbbhrljPe9iY96/XHfVu1J08NTDfI5zWzbyVO/56IdKEL+RqrQMEWa9gOdF
	9YlTNxT3o2MC8XUbW/U52jfNtcGZai8BS2PiM3RqS32bbjetudpA5BIdCK8PHnFvq6Vzn/
	Na0A8LsyAVwkt3Fxeph8i+W4eiG+qjE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=mWR+CKra;
	spf=pass (imf07.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=ef
	YPvCjUsEUH5QronJogwjmNGwQFrMfQwWcLj7jrAeU=; b=mWR+CKrawasrGW0M4h
	8krXlTsvm0o6MiWm4Xffp2aqsNWBWR3hymZsG9/2R+vk3RBnqPx7i+YgiQUPz2cg
	O0Cw96QUv2NvHOxsrCI72AlVNqEa37Ohy8rdk+Fj/WaAEWygybi7HJw3yd4RTcqe
	9NXFu3REv/LcPEZATpKqidFZ4=
Received: from XLL-9950X.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wB3rvo7c3hqZ8YMMw--.2688S2;
	Sun, 09 Aug 2026 20:31:56 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: rppt@kernel.org
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Longlong Xia <xialonglong@kylinos.cn>
Subject: [PATCH 1/1] mm/mm_init: compute hash mask with unsigned arithmetic
Date: Sun,  9 Aug 2026 20:31:19 +0800
Message-ID: <20260809123119.3811851-1-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wB3rvo7c3hqZ8YMMw--.2688S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7XF1UZr1rKrW3JFWrtFyDtrb_yoWDJwb_uF
	4Dtr4vgr43C3ZxKw17WFy5t34jga9rCa4jkFnrCr13J347A345Cw4kGr4avw1DGr4Ykryf
	Aan0vw1Ykryv9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8SksDUUUUU==
X-Originating-IP: [240e:46c:1000:421:146d:94c1:77b6:b055]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC2xyknWp4czxD6wAA3L
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: coeh3ccqnf96czskawpqninh3j4918bw
X-Rspamd-Queue-Id: B36104000A
X-HE-Tag: 1786278730-538508
X-HE-Meta: U2FsdGVkX19izyH0zSSqiuuMyOnX9gisMMuEWDgMKsqRYyT4UFVQxIMhQFIhUtmy6Fwuj3w6iPT4k7/oTpK11nq9rsYGHTPJ6VMiUNTrC3vSp2U6l6rWsTp7vHdO46uSjy3SwOREpO9OPXjmIayRtQsz6B39cQ5IT1buF9KSzeAn/8/6Frh0a5tfzvL+dEzAzIhjyJvLA0lnP1fB3NZzQwpRW9DxmiGDCL5htTqwJo57de1Tt4YSn4UeUqgaIzFTNIyApzo2oqBktYExbNN1Q5uKDw4zC766dbFVbhFMVTYmfSGdl++NuEalK1uvfi6VPLTmEAvb+sojDYuTu1JjJfR39ICUWoZLsD5YjpoxKinIQpQ5p0i/JG6Twngkccp3DgLOF6tmpCaxVE8vjfdvTegRqmXgGkkpp8OlGOHPGFAJGAtQdXu9cbZETrSZYc7+Y1SOuH4AUC9tJv4uG8K5l5Dl+lVXnx2bz4ahhWmv25Tm9DAniSf7pyho5TJVexZd75mivWmeDfIbmeU+XND8oqK1O0IwWyRKTPgVSIAFqbR4oSxyRV+7VEtOSALppnaLV3k6RpsWHha1iqaYkOYFqlF5D/9FI/7DC5S0dyP88A/lAeGrlKf0o8D+BnKFXnLXjgbLySUm2DFaFsdvddK0eHkRI05n7/VBshOtu3dBfM7dTsbPnYNSE8pCBXbb2uzt4HnqeQB6zRuf8cIM1pq5uI65k21oyJOd+zCRDD3wb1IQguLOqnXVNich7AJYnzIRhq4etnJvQv/5pbFyw0sfekm4xR0ZqsyUbYR4lEnd0oP29tYYS/btvmB5E4iF6r8SzbQlxC5UR4XjihuMaZ8AbPrIAzxsnngrA6zUtD1ZFDW/lMTdsM7mM76YAuUIiGqsBaYMNri9opYCmcUGgHWpNSHSvnZNYeO7YoOf1ZkvZNYx+tpuy9jedK2v7ffgIB7BQl06i+H8x6axvI+XeSI
 zJud1mUq
 u/y8FpjEz0Y2HBMolVjcIteLeGxHWXUGYG5VcSVYdpVq0ebaz16NpqG8AH8DVoD6t+AlAdzVcfmOpqS5X0Tl5dPtARJID6bY1/tmXLW5viQe7MqMDgUQINt+B2cXr1hv1ST4+5Jo6KblIhocPJGXvbvy95lPB7enBynvV7TPeE5ufdCd3CpAakV4UFd/073Ys6wHBoFyP5fmnyBojXJq1OEVbfC7N9XivmWT3ZPuOFWTy5iQLNziYHJUvttCs91zeAy8aAqgr+FaUZ9uSH2KgDk5nyQpTR1wtiFGoEx1xR69H2lQa3zg2bcX904cmEOBdOs5CeqXGYMsqvCRrSdR3+uJCY4Iy4xRea61KybbH93QO2iA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

alloc_large_system_hash() allows up to 2^31 buckets, so log2qty can
reach 31. At that limit, the current expression relies on signed
integer wrapping to produce the unsigned hash mask.

Use an unsigned literal so the mask is computed with unsigned
arithmetic. Supported compiler settings already produce the same
result, so this is a source-level cleanup with no functional change.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
---
 mm/mm_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 498d62c4ece3..1883fe923ffb 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2469,7 +2469,7 @@ void *__init alloc_large_system_hash(const char *tablename,
 	if (_hash_shift)
 		*_hash_shift = log2qty;
 	if (_hash_mask)
-		*_hash_mask = (1 << log2qty) - 1;
+		*_hash_mask = (1U << log2qty) - 1;
 
 	return table;
 }
-- 
2.43.0


