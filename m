Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0341C55173
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 17:36:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 781A16B0099; Sat,  1 Aug 2026 13:36:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 732006B009B; Sat,  1 Aug 2026 13:36:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6217D6B009D; Sat,  1 Aug 2026 13:36:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 43B346B0099
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 13:36:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CDEEF4036C
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 17:36:09 +0000 (UTC)
X-FDA: 85053404058.26.013BB55
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4F31C4000A
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 17:36:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hS2FSll7;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785605768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2lVMcowLJ38JKqepYS3zjjIyEUx+xmDnTKakKUngaTk=;
	b=WCpuTb12arHxXBT5VTGLCe77gylpa4yUGGMfBC3ofKCVGnqS846v1rujc6YF/c2V9KS6Ro
	NzzpHsaAu3ZtZY3GocZXVBvQYzIEkWsRaJvLrfUOCrmDauVze47CoAwQnicpN9SwteCVup
	5UZFLZAlRpgH9G+wIUMCCUIzk3FHpLM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hS2FSll7;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785605768;
	b=xDSQgE6wmp+tiQ1obfnVPekn8Dy7ajkuMjQLaivn8n949nPRySzrMcjxMMN5iukUeGmdAr
	Fnwp1BBEG4nTxPGrubE6gaGUmuVhcyCekQLNFant2qUGvOgUF8f6Z6IC0hwwEC89q1PkY/
	0wET1VXFFEHnxTdcGJ5Ua9OTW2XNhbM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E84CB60A9E;
	Sat,  1 Aug 2026 17:36:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4581F00ADE;
	Sat,  1 Aug 2026 17:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785605767;
	bh=2lVMcowLJ38JKqepYS3zjjIyEUx+xmDnTKakKUngaTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hS2FSll79ic9yMYMFuLhwoUua4YRp9/4WIiXbfw5x6UFbIs9W48ZLxX71wW/1mjPp
	 4hElEN3ceCaDJwohmysCJQ8Os/yBJMkMcDr1ed/B5fNDoaLkfvTSODJXQDHLUZ68ec
	 gJq/5SVn2fJak45Gu3sBShz/WaVDXWL15JZpIc2FUL5zEgVrPnbJExuIILUBga5MNX
	 rubm5ausGrbA/uIV/lFwajWxVdcZEzt5htR8R4Y3Vy1v1Dv/LcTJCU1HYMhc+UbJvA
	 ybvYjUeYMh32ArPj5pkOW8bpiM+OXlIQ0Hg/3GPKuhDWGQS26QQMwztb/ASwWAU+BV
	 uGUP52S9y5k9g==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 9/9] mm/damon/core: handle extreme memory state in get_in_active_mem_bp()
Date: Sat,  1 Aug 2026 10:35:52 -0700
Message-ID: <20260801173554.94710-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260801173554.94710-1-sj@kernel.org>
References: <20260801173554.94710-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4F31C4000A
X-Rspam-User: 
X-Stat-Signature: 46pshhqasuhfawjcy5495cm4r9n1bt7p
X-Rspamd-Server: rspam04
X-HE-Tag: 1785605768-18852
X-HE-Meta: U2FsdGVkX19tW7XB04OR9Q0Kd7e7j7iKcNV/Tj2bRQK4FVT0V8sI5P9k6Q4HY0BxlfgoaIIMHdCiqaLN34iRU9PpHV/YyuzzAtjCQcQJV8sVt50EJF0SL8DRxH7SrrvI4D2k93GNHUdpWjQo/jVLTVd6Hc+0HHGGJynrPFEacK+HAqbo02+bX8aFCY5oEJVympsGthIZBTcHtDJkKxgegTX1pxKFg/4YJs8GbTdTmJ3nn1DDkk1BK+M3IwIDLagdQlAC95lWzzYVe0IU9WzQ5Ixh3NqgtoXk3zOFCASTMvjrFzGrXHdrGCQGJeB29/kCDOOED0ZJspRwMUwPD5+xAE+53PAKDaiWf/EvH29k7Vb1tkWQm6OWlzuo3gqw26kM+CzfsWrEuXccf6FU/R5IeG18fndx45xdZ1GqYcPO7CPWkJmynfyTunFLf4taTVAgPfllKYguuwpzH5lI+MmtDtjePumWFM3mfVhPkfVz6Zpdtk8KHsDmdVfHRd4RPbHPoKjWeg9tLhfSAnbWpV486yjpkopnoosZzgSMcRtUYOVIdwaNRku5Rvk+GHbWOV43iXuX3uVcQ4bOn0VZ4BiYGn41uA1AgAVI+YhoxyfpyvvcBgJlnSTmn1Sc/FrOYaGBPg7bCk06t28rKfMzV6pm9WRALKhRgSr+gDYzFxPKSTerVc4lN8ts2/icKvmEX5GBm3pii5Z4XaFCDU1+qdtVQktEheVapRFd3OTTwKJuPWsYEWKBplzMHAkJRncr3BhHvS1pBQeVLcHzduBBx6ruTEESKfCIryDZetBeUH1e3M6I6niuj+wfWgLRRuzR5MqEC/PMSkfKXibpxJ6NBreZq68ugRZDPMBiz0a5KJaDnJwfqSwirSQLqf05F6R55MqQtZj+kb6kU70P/o26x3sgqqI2lSrAP/TrB1mep+u6i3jhAixeCqRT5Ido+040lzABWYNvEQGI7947ylhhcVU
 ahUIsoxe
 aaQ1XXjy9JecUgScEj/w01uGoMjz5TIVpSm2g2Q1Wxq2rYR5Ri0/W24OWGNioQvH5Np8jU+CqwxhI4wlkOi5v9HyDaCkzCJjDv0bsollYVLoFFlnyMOFMeWE0wXd82qxOGmaWv9Oy/g0G21g6S7YHyxGmAOzjoh2VdlSFF58XrR4qGk5AWcWcgx0xSTY1LNVVmlDhxxbZajl9x5tzDdKYgqYOPxSS6hK3ax8HxNymygAw/XSTkKUSTgNsJPVPbQGPf8RnSiy5Go6a2MBGfMQ7KT0Oew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_get_intervals_adaptation_bp() uses the sum of the active and
inactive memory amount as a denominator.  In an extreme and unlikely
environment, active and inactive memory might be zero.  In this case,
hence, it results in a divide by zero problem.  Avoid it by changing the
denominator to one if it is zero, before it is being used.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260721034756.147011-1-sj@kernel.org

Fixes: 4835e2871321 ("mm/damon/core: introduce [in]active memory ratio damos quota goal metric")
Cc: <stable@vger.kernel.org> # 7.0.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 76764a2056f7c..4944cf2c5afae 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3010,7 +3010,7 @@ static unsigned int damos_get_in_active_mem_bp(bool active_ratio)
 		global_node_page_state(NR_LRU_BASE + LRU_ACTIVE_FILE);
 	inactive = global_node_page_state(NR_LRU_BASE + LRU_INACTIVE_ANON) +
 		global_node_page_state(NR_LRU_BASE + LRU_INACTIVE_FILE);
-	total = active + inactive;
+	total = max(active + inactive, 1);
 	if (active_ratio)
 		return mult_frac(active, 10000, total);
 	return mult_frac(inactive, 10000, total);
-- 
2.47.3

