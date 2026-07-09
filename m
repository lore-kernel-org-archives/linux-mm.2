Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C508AC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 14:06:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F35856B00A1; Thu,  9 Jul 2026 10:06:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBC156B00A3; Thu,  9 Jul 2026 10:06:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D36136B00A5; Thu,  9 Jul 2026 10:06:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A1BFA6B00A1
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:06:11 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3BC1D8BFA7
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:11 +0000 (UTC)
X-FDA: 84969412542.26.B8EB18A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8ABB7140004
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kKda/8Kk";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783605969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ibGLnCcjbBBeYSipXvEOLcsc39tu7yTI88ewylASLiM=;
	b=YrrltDVbmyAELUhx38BzBwPPehgtop98SP30qLzn/gQEWAAwf8xumFYaqmzPZITOe9jjSQ
	/Q02yn/H8LFcGOvEU+DTOuo4sbEoIDxOu+18HxAFrqq7c9ausFprbQ2Xz/QGitk490Wma9
	e7E2CXURs42qpex5awwOxd9L0/wLU7A=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kKda/8Kk";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783605969;
	b=l7H5LY4HkC+lcX9V0Ch4Dd5FxaZxScaotl7WXA40gY5Pm3VxUixsdctK/FpbaRhAU0wMPc
	kPXQA5oYjh5GICJzkERMwo4xTBeBFScC2X9Kqvp4AnZhXmJCEsrfBPTUb/M0gzVYU0fEHo
	ilg6tDSEXq6cqI6agE+M+MQlRtJ0gKs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DBE2F42E7C;
	Thu,  9 Jul 2026 14:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE531F00AC4;
	Thu,  9 Jul 2026 14:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783605968;
	bh=ibGLnCcjbBBeYSipXvEOLcsc39tu7yTI88ewylASLiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kKda/8KkTpzWtIhthgfP+t+vMJfnwe8SlB1loMD8eVeFj+//HmZIsJkTq42mkLq4X
	 BnVd2fq+HBz0XB4eFCyjTUQmiom2Gei/OYA+mGjlUCYPQZWURKEQ+foDBCPBoKuNE9
	 pEYoiNiUUqyLpNhhyqWWyOItvYbD4Zhtr8IAOr5/YUIU5u0Sg0RyDg2aK4xDvbVsMr
	 56ietg39h++6cAz+hIlmTQk6GARVL005iEaUC34v+np5H/J6XZed3J1OIq+8AFD9Hn
	 0hUbJfs958cCxOqHE7/jzEJ4GmPzFdKgQs8pBHQ13j3ATCExTVBbT51zDfDS2LgFJ0
	 CpgRm9OyxALkw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 15/19] mm/damon/core: implement damon_has_probe_weight()
Date: Thu,  9 Jul 2026 07:05:53 -0700
Message-ID: <20260709140600.90950-16-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260709140600.90950-1-sj@kernel.org>
References: <20260709140600.90950-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8ABB7140004
X-Stat-Signature: rdafoe79nsew1kan9kbiy3esckh49gjm
X-HE-Tag: 1783605969-983327
X-HE-Meta: U2FsdGVkX19FNb4+b5q/JnNZ+50cqnyIVarf63jqPF2UTqka1WPqwz6fr8vMQtz0E+oPVYE5mVk5SYpcr6ef/Pj20SBk2FnADgOvk7ykdwah+/PTIWj4uzkM/MnAqa8BpvDrCMSfRc+cOwJztO2aArbxl45y+habnSFM1eke31MDwccrN7dIIwgN7sdl6Xb5TgaN7lyJeebsa4AZBiCBjYaoqXftGLM+sZvsAjbWimL1yoVVBAVAiIGLhRwUiS0vVsfw9nlo/6KC0w99rhnciW6X9fYo2r6GLLp+bN4c3QO6PSZvGKomDZxDxzhSWDD2CMnF0ndE115lYVnOvMPCmUXMQiXVFaxIyz0BIKYzvwJjgKxJqh3syKSYb/+mHg4kZ+oEL04dXG8fqsDL44DK9aj+BtsHlbwu2U7NLkfUdxiFGDhU+eQCMOEXGbXcrkkUYldUxxN0cUH8UQCBG6iX+UIq8edc6sZiMYhPbd4t4bUuNT/b9hFtald2EiUIDv7mv7C7wR1PLJEVHsGCWGdbwnqikVqniVuefugugmIp+h46SjPUfSHF/g/Q9G6vgBxWgPUPNBvKaeqXflm+kDhcZvLha2Vk8zv3vF/inru6mebeQd7f7GQkJQiNHLi21cJ3TfR7jwdw99h5j23SerOnUQn7YAICYXt3D1hDApkvtwWfMz5P7tZprHyzQOm8+9PD03XwmcCcM+CB61UsOslmKQVDNgV7Yp2PQf4ttSHzVAolOmwqM6WhogF2vkCnAUnq+JExrQQFR4W7W+AhHzpY8rx5bkrFks9vTkhAyBQ5bD/gXeR3IVbygeuYiN4+BDuHhK7PiJQPPk0ztMmzIYNuhLnc4pHe74oPs+fvdRmBwA6w8PqYnBTde4C36idgGw6tJoOBgJW5NTpG+s7W9xtMsE2Gbo3/DP6j26iKDKO0KNThB3P55nc4QQan6llXjnFAYabCIbnoALGzPuZFxLe
 yQ/8g33y
 VnCUol9KW25dBau9U0/g5VA2l49IBgwVY3NyV96OPuVyBe1esbBbwDpMpEr8HCri/vGunCxNpMMVdGDT19u2pL3u23YsQIjgUB3aPRlv2oj/2pLBqpXs+IiwU4mkjo3f9a6N1xwRNyq0qExadNmJB3h1tgeEcxH28ewLhSKBEy2t83m57E7Gc/UIu7wKrfuHiX8gPoXeqFAELOEF1JWMMUd2qEejEO71MaxzemryLaWFv49Hpanbl39zGK0NO04mBDEZdhSyvDxOG3Mg/VquJXY08bA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON monitors only data attributes when probe weights are set.
However, the function for detecting it is intentionally returning false
always.  The intention was to make changes for complete support of the
mode in a safe and incremental way.  Now all the building blocks are
made.  Complete the mode detection function so that the mode can really
start working.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 12c66edecd783..6661d4bfab5b9 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -211,6 +211,12 @@ static struct damon_probe *damon_nth_probe(int n, struct damon_ctx *ctx)
 
 static bool damon_has_probe_weights(struct damon_ctx *c)
 {
+	struct damon_probe *p;
+
+	damon_for_each_probe(p, c) {
+		if (p->weight)
+			return true;
+	}
 	return false;
 }
 
-- 
2.47.3

