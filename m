Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85335EC1102
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 16:00:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E66576B008C; Mon, 23 Feb 2026 11:00:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3E096B0092; Mon, 23 Feb 2026 11:00:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3D7D6B0093; Mon, 23 Feb 2026 11:00:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C42FD6B008C
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:00:39 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 80F7CB6C44
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:00:39 +0000 (UTC)
X-FDA: 84476184198.29.CB2BD7B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7596C20018
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:00:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FsZdLBDj;
	spf=pass (imf03.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771862437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=azqxiPahwBtctEhQcc93thwsBqbIT0WRLlH0etdIq40=;
	b=SDDavjPeWoWgylF6nWjUFbWyfaFQJt/a1rbJxPLLzOCE2JKpiRUoLFse/Kw4SvNa+7/1hE
	JnW0ys2VX+9cOXRdsLrFUwAAvafR8JfEg9kn/nwEHcu1AR6GgYPyiO/MU5u5AAAza0tpFW
	kQ3pjLVhAtEXn+MQEEHLKupw1WHNL0E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FsZdLBDj;
	spf=pass (imf03.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771862437; a=rsa-sha256;
	cv=none;
	b=DytmIVA/1jU9OsTExZLf33ZLvAMMcBQgc8rpHc5ukk2KmUpFUlyt0wWyW0tjDVeI4Mi8GH
	VYID0YNEoLFlMdldF8++76ax6dBpeGONnJ5uJRqqOIWvW9y/GdYqO7FHMM4RNCuaXob5bP
	FP6Yqz5lzdBZ5rkQHENEuK3GSC5Fjbk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AF07160127;
	Mon, 23 Feb 2026 16:00:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D452C2BC87;
	Mon, 23 Feb 2026 16:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771862436;
	bh=UKIhO7k7VLQSgpTXiMxkaWE6pX9f9Kduyb6QirGAR1I=;
	h=From:To:Cc:Subject:Date:From;
	b=FsZdLBDjEJUxdXZcm5UP08dJ3SCq5dXZBKUUZfLIOTe/JTGDZbuNoSm2tnZ1VCJLe
	 KAAbD7RxD5LRWKE1lWRYrUZSWYsanD+BTRIVmIuBElt3CoimYKrru+3xAMdTRm6kTM
	 DwWpruTckuDudPpDWaw0H8ElsivatrsVQ8/y3RcwNJNL9VnQFepsUVcZitWTIbcSOp
	 sviYiGz/sxtq7amVM6yEa/2KH1N5N7yOpunOp+cs9oKCtX3SoHeETt1m+MjapijHqL
	 0HpLpPj4dYlwogCnmaZ0cwCjjwz9KueQVdbsAlZ9DvBVXv+AD0kVp0sP5Vya2FwDEi
	 VCmQiKjHmok+g==
From: Yosry Ahmed <yosry@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	linux-mm@kvack.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH] MAINTAINERS: Update Yosry Ahmed's email address
Date: Mon, 23 Feb 2026 16:00:26 +0000
Message-ID: <20260223160027.122307-1-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7596C20018
X-Rspamd-Server: rspam02
X-Stat-Signature: cz4yp4z54zxmub5op3ees6wy5xi754a8
X-HE-Tag: 1771862437-112862
X-HE-Meta: U2FsdGVkX18As1mmni0aVQBMjQozGq4mY13/HWAbrE57LTwkCDHL0/dxM150ZB1bjG783GlKL907UL0URI7Kk5mrL51La2LMqCBxJKCsrnzYNP+b4cjr9mf5kmn4faZdVlJSNvHe4qdEVOR6UoTngytO4/Z4fWZuzxfqrmyaFwWZb62NM5S1sMWr1tcU7EG9iF5GFZCzbWpgDS3wjJbGkEBAdPFrryaCOAVN9pSpW1qmDIOAwb3NQN2twJLxwzDI1Lbs/X1h6dolA6G+czCybo7Yp9lC+gCGX/+WZENC0guOKna1P/qStRhNoGdGIxQbsv5gx+RXsBTE6XTE1dl3HfNhDdW3DftOyvr9HCt3IoVXJUHL4WZe5Ae9KCnJWqk70PUoyqozlAM85b8fIGluYGpKiPRHKAAlVMpI2Ri9zIn+W6jVN9CQua1yV6K4Uh6Q95C1+MaAvVqYwKfTBx2nGt4Al3vuLAGrumYqXcV1VxqI95qfd2BqUzCZrhjPLokR2iS4/6QsXMPT2uTAa7MOR/n7VYl6OnoNrg2ojITSdSN9/sHgCBXq+0baQyoHobVUEl5gHbPyFbgcCRG2tftl4QewwC80ZbYqIMtF0jpviAvzHyqfHjjDIex0NcotMHPx+4RDJv1n6CYq2IDU0CeRtw+TvQGEqdFo6LVjbo+7Z0X3mSQQoj/vQ8DALLQrHf1lnrKwXPvykn/TlhX1wYT88PS0Vlqw7zuxFlT1IjO/Zx8kbcZTMHaGaLR7ZYK8uuG/erVDeluugP6sY4riDjDVHh9x31/3BMc/lvzYm4fCK7/tISj/9d4/aqWbCUrqdErHZbmrL9VNK3qTn44MouVJaw4eTTl5O3C7YeArlmQ+f03R0ZTMwE6kEVLIhMRV9Elko/tydZN+P/rNBQLAXOQhNCCrKA+Liby1hrQBerSQlcXttoIcJqpaIVG5ozJR/WUZrRW3cTVx0+vmkOdxQh4
 5VT0AYl4
 xwrnzITs6Ap+CoWgggjudf9AW4tOjYQtA/vCHhxJt8+tU194exm1FwEU2fRTez4UGMD59FXf7CR/SA/z4dn22lVQCrHhbWKCawFocnu+xUS9JQR+kakJnb8zjdXXisThGlKsqnNwydU6zcQ2BE6Cfqxp4cQ5TjB8yF2vsapjogHjuh+h9QxSO6fFmjymplV+DKGBf/XTaC7eGInUbywV/gEYJ1giCbw3XUySJCEInNnfcklmWco0uVhzpVGoj0xcPrp6frnlD/qXOr58hKXzdOat7SaEfdXqFuMwF/Rizxd1AR9miCBzLQ5GrWsQZQkAZXJ8g5eNuGvOFXlMDv0WQFMVGHKR/5VJnhkvkFEEPK6qQUtqanKpsxoqPC7147iZaqbiEYwdM5FhQb9LgsAkAN96TEaS1BAhYl65nUvYJOEERvuPUX5ZU+DUpz42Y9qWjOTDUSIkpRXTevawQjQLfWYAGRcPvOeNb7uZadInt0l8w5mU9onSHz8EM0jE8CsqlUyKMDr/tX7Thedd83Bp0g7hnQf5nSP/0kSZDiDVRNVxd+eXSwQ7J69TdqY4vlcTXbWwMDAXm1qDQR4RtD/WqBpKc3rxxPsuD29xacRAeP0am1fh0etgw+illZiFiePjJAl5KGGs/vV8KQ+eqE+3QcdonGiBth8qO4DkN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use my kernel.org email address.

Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 .mailmap    | 3 ++-
 MAINTAINERS | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/.mailmap b/.mailmap
index e1cf6bb85d333..15b7a064b0bb6 100644
--- a/.mailmap
+++ b/.mailmap
@@ -890,7 +890,8 @@ Yanteng Si <si.yanteng@linux.dev> <siyanteng@loongson.cn>
 Ying Huang <huang.ying.caritas@gmail.com> <ying.huang@intel.com>
 Yixun Lan <dlan@kernel.org> <dlan@gentoo.org>
 Yixun Lan <dlan@kernel.org> <yixun.lan@amlogic.com>
-Yosry Ahmed <yosry.ahmed@linux.dev> <yosryahmed@google.com>
+Yosry Ahmed <yosry@kernel.org> <yosryahmed@google.com>
+Yosry Ahmed <yosry@kernel.org> <yosry.ahmed@linux.dev>
 Yu-Chun Lin <eleanor.lin@realtek.com> <eleanor15x@gmail.com>
 Yusuke Goda <goda.yusuke@renesas.com>
 Zack Rusin <zack.rusin@broadcom.com> <zackr@vmware.com>
diff --git a/MAINTAINERS b/MAINTAINERS
index b8d8a5c415976..58e0684cd757e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -29185,7 +29185,7 @@ K:	zstd
 
 ZSWAP COMPRESSED SWAP CACHING
 M:	Johannes Weiner <hannes@cmpxchg.org>
-M:	Yosry Ahmed <yosry.ahmed@linux.dev>
+M:	Yosry Ahmed <yosry@kernel.org>
 M:	Nhat Pham <nphamcs@gmail.com>
 R:	Chengming Zhou <chengming.zhou@linux.dev>
 L:	linux-mm@kvack.org
-- 
2.53.0.345.g96ddfc5eaa-goog


