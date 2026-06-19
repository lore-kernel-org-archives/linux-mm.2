Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC0D0CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 20:51:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9B6A6B0088; Fri, 19 Jun 2026 16:51:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4CBB6B008A; Fri, 19 Jun 2026 16:51:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C62ED6B008C; Fri, 19 Jun 2026 16:51:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A36296B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 16:51:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2D0A9140556
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 20:51:54 +0000 (UTC)
X-FDA: 84897858948.08.0AC3999
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id A919E120002
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 20:51:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h1OovN4s;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781902312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4iq0ijo90COF3Rq3DtHD6rw3T7Yg//ZMNQpyM055t7Q=;
	b=5Xibrk2khefDecBIygsogG6DNo1NhmPBCLD+SkZ+E3HzdBv2Jgx1iIEiKSutxDFTBdwJ7N
	aHKV3MXGx80h3txdzuOlCLl8Me6tBgCe+1jg2fmAlekb1DqY7zFRYmdzy+g1+JHkfVENlY
	THIiLUL9sLsZZUyq3V/P51Gn8wZlQnc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781902312;
	b=pXAtWXZucyhzmaONWnBFqROjoqtlohfuiov3A+iAdIv80MmvizAY11WjvHA64CL6rV7+Pn
	0wiUe4MBYcR4cIU4AQeO948wR1TwK2v4wMmm5ETEDbb+NEkZXPoxGiR39qxY0vEvh4v1mT
	MQ50BSTcY4t5ZIny52uWLIOuF3/zXFw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h1OovN4s;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0C17F601E2;
	Fri, 19 Jun 2026 20:51:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5F21F000E9;
	Fri, 19 Jun 2026 20:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781902311;
	bh=4iq0ijo90COF3Rq3DtHD6rw3T7Yg//ZMNQpyM055t7Q=;
	h=From:To:Cc:Subject:Date;
	b=h1OovN4sxY+yovVJ4XlVy27s5+y10ZuVfIBbIbydeh9OnbDkr+eYx8cPyiR3q5j+C
	 GVikjWO2PHiS906CfWT4guAhMyn/S4moYzQKGLfmTi6xVj1/A7GbnYzzbg+3mLhdb7
	 R5Mp19yxBUCqaVpJPHTSBu+NO5PAJL2rrnib2acSYL7hO/NAvOOCToKF0lpH9LHf7W
	 dVz9nlgef0HbkOQ8I1Y+oFjCMkMX+XRUwOqi5tzPYnEZymQ0hHWxQn3ZbEnK3ii3qe
	 WqBbKxqdMrTHl8ChLcJ3yNEwNgrU6YxNdB275kEGLFGBJ6pZUbno+1gHg837V3574V
	 OzZUHgQM0SYsQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 16 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH] mm/damon: handle zero sampling interval in damon_max_nr_accesses()
Date: Fri, 19 Jun 2026 13:51:43 -0700
Message-ID: <20260619205144.150664-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A919E120002
X-Stat-Signature: 7u5esrqu9hccn18g11a87mdpxj4zy3mq
X-HE-Tag: 1781902312-515977
X-HE-Meta: U2FsdGVkX1/o5FURV091xXEQAATpGe9KUYU8kDArsVJSmANZ9g6EXvcG0XAyC/6+EgScSAPUTJYBMf5OS4//SkG8f679PbLeci7LIl2y4z4fBNw89jup8TkIGp2tJ5pJGFIRbCxrYrCPzQ1ZShPjPqZuqdyB7lWpTueX1Hpj6SVowr1Gd4Z1CjfAykEoSc9Q2gZsIMRcO5nKXNvr256HcaEkrnNQqHonq/yITD0NiIxmE7Xk+kCTETBtrEHFsF9waimLs8D0hjtYx1vEieOmYEOV28BGUsCO0/aAX9v9VnDulb04uunlZhMl9ohs6miV597sYWFvoUt2DOnDEHc1FRbA58+SoWbdOXS//jpELEff51OEViVQMaO3u5W28/RIP0xOpKnpIXG9Swy00myWuR0ZWsSyyBiBtEh0JfqmwUBQFvn0EVl7enPqwcQetpX88Rj9x5UXjIk2JAxbRAYxkqPCLVbMhihdtJozsqYENziyNPBw9y9cJOv+6JlGDQrqDDQb/HjGGttXHhMCQd3mKC3wjPs2qZaw6ZsifhwLoPeq8g1hFCMafBTzK9SkHQwj2oBup+Rg4LfQiABLL0C/+cZYqjnOU6k8qcKoIgMz5bRtazN9bEnIJWS5MoODXaaoZasV6x90o2YMPfuB/RX7x2Xxx/zCXUs5t38E2R4esidjA0/JWvv03Ibt+OWoKvBtXSLR+RmjXUSE/Ch2QVRX1PejvJ7KYG3i42rUYtnudeNp5RvpJOvKyxCiz57FPedNHunYB7cMy/zsEhC8n96yzO6RQlOKf1vtbgjtlpNo5B19x2LIsiHq0Gpr1nUwKLaE3kp5HpaS5OgPxSSkRcnUo4vYVT+J4RlC1aoG5M+azstYmtINKoFJcUtnRlDxjFK74fwpMCsNdqxufLeyV0h/vZROtf3wUk+APU7nd0oikQ4Hr7DpQFDCdvNHUkPejOuhcARnIUplytHcCZv2Ni+
 g7Fh1F3C
 rqkyA/2ioorhV3T9tKaiDfVVYp5gMmccQE0KoxyyQSEECie31/r1itpuKBLKOEPGjbRNX17ucNzzee4p0/mdao+XH0vGgDS6WpOLVTLKupZgQ3HlLToevlcJdnbOLOZcIEuNzalel+8a0wharGL9yW+GIALgihSfitD67C8DxM33BKiuegN3KCqMGpU36McB7XMaHCP2mzzXwRkzHd7k8b9J7c6ueu9TMdPtoVO7sAg4D/hL+rPxF4P3vs4Ur0oSXG6G8b3AM9OaPUzDC1Yg9z2NbgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_max_nr_accesses() causes divide-by-zero if sampling interval is
zero.  Fix it by handling the case.

The issue was dicovered [1] by Sashiko.

[1] https://lore.kernel.org/20260619202459.145010-1-sj@kernel.org

Fixes: 198f0f4c58b9 ("mm/damon/vaddr,paddr: support pageout prioritization")
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 64d75c78f4df4..b6fbe6089abc6 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1066,8 +1066,10 @@ static inline bool damon_target_has_pid(const struct damon_ctx *ctx)
 
 static inline unsigned int damon_max_nr_accesses(const struct damon_attrs *attrs)
 {
+	unsigned long sample_interval = attrs->sample_interval ? : 1;
+
 	/* {aggr,sample}_interval are unsigned long, hence could overflow */
-	return min(attrs->aggr_interval / attrs->sample_interval,
+	return min(attrs->aggr_interval / sample_interval,
 			(unsigned long)UINT_MAX);
 }
 

base-commit: 7a58ae62cdf3c006a53b805bbb12079ab2621a07
-- 
2.47.3

