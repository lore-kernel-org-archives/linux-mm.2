Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86B05C9830E
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 07:28:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78A6C6B008A; Sun, 27 Sep 2026 03:28:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 761866B008C; Sun, 27 Sep 2026 03:28:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 651AE6B0092; Sun, 27 Sep 2026 03:28:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 46D696B008A
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 03:28:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C0B24A719F
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 07:28:46 +0000 (UTC)
X-FDA: 85258715052.23.A3E6DF5
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf10.hostedemail.com (Postfix) with ESMTP id 00CC9C0003
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 07:28:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790494124;
	b=YZekdgBiH1sIcJAzLaRA2PbB304fcq06SeMRrbTGR2LzB2V1StVLrD90qNWE5X5a4nB7L7
	HVp3VKLxjus4CDxgMLT2/XJqvPIu4o44McW3jGKadOzzN7EbVHd84Wa3DXUceit7xp42f4
	68RZ2FegFY3OrXf/RfL5Alw0miqJM+g=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790494124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TpXjNgvW9XEn1I41Sa7AD/yGMeYMaV0vw4Yt4uChvSE=;
	b=k7ysZ/yfmgyMsG9M8IDQj0SOWYZJzqWcW8HZT6V0j3JJplsTuABVEsaUPwPNehk9mesOhz
	LVWu8+34WybqnRWAaSpH6RfwSyscU+wFefQLN6/pWwbtozRIUHIwF2VsrslOLqIUbiiwKU
	2LuGqBt/5U2jTWaYPC1Q3LpRpfRcStk=
X-UUID: 0b43221aba4511f19a56ed5b684f684d-20260927
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD_SPF, CIE_UNKNOWN, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:b52e714b-24c3-468e-a57c-77be4319c65c,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:b52e714b-24c3-468e-a57c-77be4319c65c,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:1d7d607b7b428a55179892fcfea18ccc,BulkI
	D:260927151414B60ZCH1M,BulkQuantity:2,SF:17|19|38|66|78|81|82|102|127|865|
	898,TC:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:41,Q
	S:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,
	ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0b43221aba4511f19a56ed5b684f684d-20260927
X-User: lienze@kylinos.cn
Received: from ubuntu.. [(111.193.136.161)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 741960507; Sun, 27 Sep 2026 15:28:32 +0800
From: Enze Li <lienze@kylinos.cn>
To: ojeda@kernel.org,
	boqun@kernel.org,
	gary@garyguo.net,
	bjorn3_gh@protonmail.com,
	lossin@kernel.org,
	a.hindborg@kernel.org,
	aliceryhl@google.com,
	tmgross@umich.edu,
	dakr@kernel.org,
	daniel.almeida@collabora.com,
	tamird@kernel.org,
	acourbot@nvidia.com,
	work@onurozkan.dev,
	sj@kernel.org
Cc: linux-kernel@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com,
	lienze@kylinos.cn
Subject: [RFC PATCH 1/4] rust: add bindings for linux/damon.h
Date: Sun, 27 Sep 2026 15:28:09 +0800
Message-ID: <20260927072812.2393456-2-lienze@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260927072812.2393456-1-lienze@kylinos.cn>
References: <20260927072812.2393456-1-lienze@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 65uyzapfawp78yamoq9buazch193fr6z
X-Rspam-User: 
X-Rspamd-Queue-Id: 00CC9C0003
X-HE-Tag: 1790494123-237757
X-HE-Meta: U2FsdGVkX1/a3H00We3X+raVpbJuUBcWwfef/rRsWRPGtGrzC3Xvwmndvm2ZABH+n1iSBXKxVO+Bh1tQm+XnTuloZ5uvxkOc83n/N60SLClm8yd6MdQ41cnCxgLwteLZHm38HRnQN6u0g6E5VRRWtaFZWnV16wNtiLCYRrRXBhS+BjI5QVhyxit4IH/jiOYsb2EVz3U9CSHu5BuZJTtTOXVbs02bN5OIVGDRKZDK4ojIHuPhmcogD7kAjRlZKkjxytvhrI5uXGqEc6UtPOgjw9KBKTegSGE8ddVCg8GV9OA0IdGLDuB13bPgJtIqKW2C/sw/ej40W+8jnmk88I4bmy9tuY9WAi74vWWVLRUhivC4aEDKCcuoSzuU5iYuZfnjoyclsfmCZwmkLjMM3G4T3StO8X/2LYTCelkNa/Unhxv/+ER032iK9MI7xhtEsHxHqSfk1s9NII5Ml+hHi0yYJNbeJ+o/y3FDo89tiaDy5kr67SVBoHYDHQoqfLayEuF3cjuZt6i+3HGa67bqd/EuyjJIEZ77s8XiWx33BizvVq8pdy6ZOX8+IEbo3OfQuRtOcno1jvJJ2jDHTvN9FDTolHb9nuuAcL/f2GR5znuWKrkBLRzBtRhmCeEfLzRqrp1VRtASf8gUvlL+2yPu0QcsDItEbxm8M/hTG/wYamBTYFBX8ZDWB/r+3eVZuIYIpul5KC3q6g+XBmTf41/o2u7OO6b/wAeECw3RE3deogCjonXRIl6GHs/Fb/wVXy08ZBqMB6BxMOqPqFBLXIINnPrTwxs7abJLPKPXf0YxwpJVPuxcdMF0oWD2/59UMJKCTuknR907Go8/OTsQTLuqp7RFpoejeFSnq0mMCF14gA/ZBu4sksfI/lXnx+wV6v5RfGIql49ydbHHvK0aTxjJmVG7w1bCs24UkR0o277kl+gzj3YDCP0Y/RSy0JO05zWYJBqdMBWtETxgKo4IlYl/o67
 YRfTSK4T
 5eerm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Include linux/damon.h in bindings_helper.h so that DAMON APIs become
available to Rust code.  This is in preparation for the DAMON abstractions
added in the next patch.

Signed-off-by: Enze Li <lienze@kylinos.cn>
---
 rust/bindings/bindings_helper.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 4b31aa7f432f..0951dfe8e3e5 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -50,6 +50,7 @@
 #include <linux/cpufreq.h>
 #include <linux/cpumask.h>
 #include <linux/cred.h>
+#include <linux/damon.h>
 #include <linux/debugfs.h>
 #include <linux/device/faux.h>
 #include <linux/dma-direction.h>

base-commit: 1c2b8d2725f84b43fabe3b3e9628c91db8ca6c65
-- 
2.43.0


