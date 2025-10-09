Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20515CCD18C
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 21:20:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 423828E0082; Thu,  9 Oct 2025 17:20:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35F058E0002; Thu,  9 Oct 2025 17:20:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24D7D8E0082; Thu,  9 Oct 2025 17:20:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0EAB28E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 17:20:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BF2F51A0AC2
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:20:50 +0000 (UTC)
X-FDA: 83979845460.12.6BE3570
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3A9CD8000B
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:20:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="AoE0x/Bc";
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760044849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0tI9IAN5mgXaDDlMK323PiY16RnyWr4O7AFohM5PdKU=;
	b=XmJeX7sAJYRnZ/U0359hzC86Lae/PrM9rL5QGgx+fdijNEl0A6P0ma1MCyTXvd9FpAY8iJ
	BbZknZwvgs3I7GT6q9Zj+woSVkkhKy0+LDiLlHW18mVB9QzNnf9740MGkjX1np2gciJrB7
	Pw6IKU/3NDARUlC4JTauCD1adCQDGKY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="AoE0x/Bc";
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760044849; a=rsa-sha256;
	cv=none;
	b=0Bh0n2tNebotvS2/mrbMmnwCwMCvyizQhPj5//14cRcvgoQGwncYvlhKV5ELTvCCv5KPQT
	NR5ajdykaez5n7EWn0qvkV2X/BCUf/h4S/Qg/+JQdX14UbFeMVosqD0rciCjKraBO/wG/G
	NhPknToC9hQOqvmGnEJrXBcfhZW2i2c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3B5DB62420;
	Thu,  9 Oct 2025 21:20:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB76C4CEFE;
	Thu,  9 Oct 2025 21:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760044847;
	bh=w2pLgMeh4x2vtx8hkxpF0higLdemtjuZby1GC48TrEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AoE0x/BcAqmaV2Wgjw0N5gfW/vKHaPIWbzMAPPNOuwRHVJx+nfGi6F9/eOMbJrETc
	 lOUGYD4jUkMYnd7r/uqczxMG5O0feC1chueyOngV2+s5nsbBO6UeA7I6Ea7oHviRe5
	 Zwswpw3JBw/w7ejFNRTDruikLC7I3+0NVCbbqRD0VegD2C1McfJDwVbxBtY6IAmfFp
	 0DIcIrFxGF2AQ6UJLmuZMHz4CJB362AvW6Y12Sl62UAvt18BjZwKeBkdCCe2xGHwse
	 3zZ9uxxCSH37afEwUd/j9HCdMUUWFSm2F+6lheSXl7SF6kPDuIYCxkW0AN30Nq7jqW
	 EMw9vpuJaGmkg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 01/10] mm/damon: document damos_quota_goal->nid use case
Date: Thu,  9 Oct 2025 14:20:33 -0700
Message-Id: <20251009212042.60084-2-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251009212042.60084-1-sj@kernel.org>
References: <20251009212042.60084-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: siqsx3nzkmyecf1he1cmexnptfxjjmyi
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3A9CD8000B
X-HE-Tag: 1760044849-501138
X-HE-Meta: U2FsdGVkX1+tbNOLKf8POsNlszIFiE+Of+1fd+M6YkySBv8tXut2ru8j+YkNdGVVHjUE8MHu+R3qpoVdmIxQVa0Lynjqoom7Z/TzwTzXl29ErPunjaROpI3pzkTA7DENtwZ6flCp6BYns/xYDdFVqf+G6P+F8z62o4jPalw5G4+f27DOxRBmQLoMtWD7KPL7bVRudg0mbguVJdDaF70t9MBy2fvTJFZf/n8xzFKHfN0FHivvuTGN5LG1UrqddMJ+WCFDRG1sNNGPdcwiCwtwNh7ZpkjwPBwfwKZrc2vYyJbTEnyofHSF8DXHeoSlFCrtZuzSS/dZOiK3QwMRdKzEnlbd7uFDEMXXRupRnX5q5FK03kx/004FxoXoNZ8rkME7q4+jBkQ13BaG67ZBvTaHa756IZJlFA5mWCA5y9DUIYNIkOE2IRuezbkzlUd3YlCogSVNmEMS1qxG2mqR5Ta3VkLwiboFQtUSyiXlWXilVBquyq12/dwsPvwzksnUWhhnyepWa38/LUMXDlE9ETqOm4YWA2LBGeSos9bzFwCMnZm2izplDR0x+1g6ufwj/XUM6/AGps5nadT9OnfyZPddkkSo4wbBGX020aFk2P4gQNt/nUVphtu+BnZIwiglKIfOh6CNkGlgeWK1le0IbbakZJzgs9fwED07wzSiIH0tGdYSVBQ1fW0zgQvsAepfkbhgOXSt5159df34oyG9gcFKTQgRpAiMR1gJ80ObFdYIV8Cy4mbAtSQ9cEQQ9kUEUhiQS8L7MJnV1TwVm9P7Pi4pEfl5+O6P1YCHxbbpNQ06oDgsP0LGAlbB4CHAe+E5rHpMkbEfUShVZG9m5vFRQjvkUoQqq3gMar9r2x5dckbNIRfbGI7761p2fN0FWlYk1wmdWHU2nXIGJCmDLZz+ybMXaMhidJecAni+ZI1VBGxtFrsma6VEE/tRz666enHmm8YfZVhC8oBurc36//wkhUR
 sMscvjEv
 b0xKqwemCR3kRiA6OZBJcAT6ZzrcA3O111e+XNX/ieEYac4pUYESWq7YFnRrL3vUOaf0VNVIDAdPGBHmP9jmcxHx85ZdMyvVhxABP4l68np8PSMmG0kyGLFxtlGvpktixob+ZsnhbRIbhCAUtucC94jjVZiH88jHoHLwNyGuXhma08zAgIc/pPv173f42C2arXIIqccHXwovz4ACWufI+V1b4zFyowyDU+l2+3LwBmwiNP8QfrTY/sEkVIL2OTJpza05G7sqlssK8N/2o/vb87JxrcogXJZqfI8a4MLXVkqYaHXb6ehzzjVO/RRnf3plKR1H8DbzQo5stNxs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_quota_goal kerneldoc comment is not explaining when @metric is
used.  Update the comment for that.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index cae8c613c5fc..dc9c310e0e75 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -176,6 +176,9 @@ enum damos_quota_goal_metric {
  * If @metric is DAMOS_QUOTA_USER_INPUT, @current_value should be manually
  * entered by the user, probably inside the kdamond callbacks.  Otherwise,
  * DAMON sets @current_value with self-measured value of @metric.
+ *
+ * If @metric is DAMOS_QUOTA_NODE_MEM_{USED,FREE}_BP, @nid represents the node
+ * id of the target node to account the used/free memory.
  */
 struct damos_quota_goal {
 	enum damos_quota_goal_metric metric;
-- 
2.39.5

