Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1599DCCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 08:43:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 702B48E00CE; Tue, 14 Oct 2025 04:43:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B3988E00AB; Tue, 14 Oct 2025 04:43:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C8E88E00CE; Tue, 14 Oct 2025 04:43:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4A0328E00AB
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:43:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E498411AC9A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:43:01 +0000 (UTC)
X-FDA: 83996079762.19.89AF09D
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf09.hostedemail.com (Postfix) with ESMTP id CDD7E140007
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:42:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760431380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=K3LkqqfYvr+4iVhjCE2MHmrEAIJHf4SB5Ndp9QwkPcA=;
	b=qet5lwtpYWMeL5OGEI/ilTxyGJmmun0vXjvPiBgh2Ob3S706LxTElP7CG644hrnCermMpA
	Yt7gLX1eI/hx2Y23i231QS5WuA/6HB5tjWtGbOwJQsViS65GxNcBOQ73o6yW/ZYzPu+lxy
	ojULKza9Y69VnH1p0cdk30ZnVWkYiO4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760431380; a=rsa-sha256;
	cv=none;
	b=U9prNVA2NvjAozp9kFHcLwRvnkeJ3c6ESfgSOUENcf5nL9xRGsubwPvtac7qoQPtpAQteD
	xy6+I97Hxy8zNC7nk3KNx63QfrJ8K0eRgNw2OgwdEk5+QHLvsnHSzXdNANHqy50KOSwHXb
	qKpvjOwj168YaA2b1H1F+OyUR+P2Iy8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn;
	dmarc=none
X-UUID: c283b6e8a8d911f0a38c85956e01ac42-20251014
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:598fe906-9c18-4ad6-8aa2-4af1c8eaaea6,IP:10,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-5
X-CID-INFO: VERSION:1.3.6,REQID:598fe906-9c18-4ad6-8aa2-4af1c8eaaea6,IP:10,URL
	:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:a9d874c,CLOUDID:45d320bac237e45ad2aa7e2e56a0f0d9,BulkI
	D:2510141640177430877O,BulkQuantity:1,Recheck:0,SF:17|19|24|38|44|66|78|10
	2|850,TC:nil,Content:0|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:40,QS:ni
	l,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:
	0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSI,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c283b6e8a8d911f0a38c85956e01ac42-20251014
X-User: lienze@kylinos.cn
Received: from localhost.localdomain [(223.70.160.239)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2001799193; Tue, 14 Oct 2025 16:42:47 +0800
From: Enze Li <lienze@kylinos.cn>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH] mm/damon/core: fix potential memory leak by cleaning ops_filter in damon_destroy_scheme
Date: Tue, 14 Oct 2025 16:42:25 +0800
Message-ID: <20251014084225.313313-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: kmxq3uzqgjpp7kqyzi9qnyjuo1sfaryr
X-Rspam-User: 
X-Rspamd-Queue-Id: CDD7E140007
X-HE-Tag: 1760431378-997262
X-HE-Meta: U2FsdGVkX1/IP2p4Lk7F0MeB5jfjJvmAcq1YLQ0EiqBRNLqkeSlX0XRNiJi6H1ZLLtaRjSDRdCDT0FF4PpEUpcnfhLTonyqECF4gIc5AYpQgLq7TTIxF9hRykmSZi2z7Klt1PLnODj/vzgkV0OoZSInceNzoyt4re1N8Lb/EkRJNTn16uxcC8ZEDVACwwWvy2Bctlo8pvtFCffsNl9+yhDypDUiXT19Gb+Ql+LBdK1bg6QUN2juS7I2vNdnWYid+DF/ZjDFkXoWQfh5sAUneY79YgHUd3V7WMFxmOMuXSKwIA5Ysru7AhqgJ8m/wbmOYt9BJLu6V952elyxDJ7busFir5weK4q71AaJ5OcScKqViLEu1dCYpVLlNp/7P0HnapifsSiKrSOEmw6A+a3WwC2N1XXHMqGBx34341VBWKze2NZsHXgTmBecThiFHtisqZ+ENkDpxSj7dbQX5N8xxYn5qLfSZ8V1rXaX+Y93VYwb2kzGbaVXKQrxJ/FV/xfQnO/Cupj6XotHwv3FdwMnCIf+TKMbumLP1sCxjMyGfARFgDmewdmr6LMlQ77//X5rqPd1sD0eqQCqoP9UbchnMvIst9bXmpZzSoTlRCGwMmXOs1HGPBZzr7mwUccr4+SznF7qpsK11EHecWpXNNs+VYklVNpaagrzKPDkHy+y7Efb1XQZEw+chjBh9hajPqv7vWP1iS8Jbu0Z6l+CUcq9gZkGBDpBX2XPqbOLmxRf4omOtzvo8L4hNBRbbB3aN8rhruLe/nwoymDJFs0Yz4LBKbnu1mxUSFAF6i9rYKM1AuDGwPSSbVC20CcIzKXwLFbX8nqY1TWTCT82RQ+9Rtt3fJ1ElVG47VqpTYKN+z1Uzu6n4Zq6D5zoquHx3nz+hBafG7ndqbyFRRebxTs4sYlUASFFBNcYju+TVFljen0rvQZx2AkBUSPC31EcAN/7zzQsW6TpzC6oxMK+ARQEJNCX
 2vmSueE4
 fTbO5IAgmOIwLJh2LLGUY/l5wcke+Pbywp/A4XYRruSOLFw8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, damon_destroy_scheme() only cleans up the filter list but
leaves ops_filter untouched, which could lead to memory leaks when
a scheme is destroyed.

This patch ensures both filter and ops_filter are properly freed in
damon_destroy_scheme(), preventing potential memory leaks.

Fixes: ab82e57981d0 ("mm/damon/core: introduce damos->ops_filters")
Signed-off-by: Enze Li <lienze@kylinos.cn>
---
 mm/damon/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 93848b4c6944..3e2c743e0864 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -452,6 +452,9 @@ void damon_destroy_scheme(struct damos *s)
 	damos_for_each_filter_safe(f, next, s)
 		damos_destroy_filter(f);
 
+	damos_for_each_ops_filter_safe(f, next, s)
+		damos_destroy_filter(f);
+
 	kfree(s->migrate_dests.node_id_arr);
 	kfree(s->migrate_dests.weight_arr);
 	damon_del_scheme(s);

base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
-- 
2.51.0


