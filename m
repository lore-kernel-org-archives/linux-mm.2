Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EAE2C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 10:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CFF36B0088; Thu, 27 Aug 2026 06:34:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A7E36B008A; Thu, 27 Aug 2026 06:34:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BE0D6B008C; Thu, 27 Aug 2026 06:34:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 102886B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:34:44 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A071A16039E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:34:43 +0000 (UTC)
X-FDA: 85146690846.16.EAFD6F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id D183F20009
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:34:41 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N5mt9U7o;
	spf=pass (imf31.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787826881;
	b=Y9QuO/gOxnFeRB1h0owldXNiPdaYufg/DZEi9VbLNUuW57YUFPDqHQ2fIYwehBUZMFs091
	VW0BsllK3rgOUMSDhBsHDhv8NbNfW2V6w8p80XKwUxpCRCobOI4UHKVxdVl+AvA0GxGz76
	ZVTGPP7JdKvZULC+ByAAZveAuWZWHjc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N5mt9U7o;
	spf=pass (imf31.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787826881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OYAS+bQ1Ywmr3MiJ8QFUm7cZDm2IkeiM6rs0uMt53Ig=;
	b=1eWveQ1+tWEA+bIDFz2qbay6Dn1ghlWn+TmBtf+O5i8FYSeKAEK/Oti0pN9KJF6w9tHlIz
	MTq7OSvRMhFJmItGlN/lJ78OaGBRrI3D1yIi/hI5q3fH+o0BU4AYcJ3XMefF0SvqhmWD6e
	gWjLukvht28BYR2CFAVwQitnI1gnwJc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0F5CD600D3;
	Thu, 27 Aug 2026 10:34:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E791F00A3E;
	Thu, 27 Aug 2026 10:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787826880;
	bh=OYAS+bQ1Ywmr3MiJ8QFUm7cZDm2IkeiM6rs0uMt53Ig=;
	h=From:To:Cc:Subject:Date;
	b=N5mt9U7oBNIf3gTp1QHYaHzqY+0HOlbWSOw9ZOhiWdK9vjV3h7kGfC9NXRgE9wDVg
	 7rVomqvNO3vY6doA6l2cIpM2P3IWAFTlkH1Op1HUNPJ1lsQBV846BNSqB3k0XIcpkz
	 k3BAKGtKPMQxt3Rf3VJC0d2yNvC/iwNCJl0U89cqEjdiJvbnPAmP7Svj+v9nVfdd2Q
	 snzqJi1muiKStt8qmvmfheMgsQSrm7MqVm/A8++XGLZw9hTZFduiZ67/IeuIC3PkYt
	 Z8F6KLZ1EboMoOatQrQ/Y5Iu7KEfMFpVBieJMWEHYzFRdx/Ltqn6Op1I7p1W6dh1DC
	 36N1WbDNvy+2Q==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.ams.internal (Postfix) with ESMTP id 55CAB198003A;
	Thu, 27 Aug 2026 06:34:37 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 27 Aug 2026 06:34:38 -0400
X-ME-Sender: <xms:vBKQauYgckaa_NJ5jVYiRe1PaqONhxRew7IgffUC-Ivrm5gLAbKZ2Q>
    <xme:vBKQamntroB964bsv0gNxCAMiWb4LOsgqxt6Y2KIXT_hN9WerBiWH-YKNZqT1b_5I
    Sfb33RNYLzO3oUUE7cmpG2TrdQCQwTemMarSuYefs4Au_VM61XWHWI>
X-ME-Received: <xmr:vBKQasXz_f17R147rvdNugqSSnuaHMPtH52mC6Xqr3sX8DQVV_Ror9B16-o>
X-ME-Proxy-Cause: dmFkZTFjohsw3HXZQJsT0uj+pnPqzgvzWtT/qvsjRpTVFjAbOFOsPC98teyoDax/kgH1uu
    ycNhjv8wURCYJu2mklv9mCkyAQJA3RfpsVxpwdty0HXrWUI9hvqL4m6Gv3tl9CRMQGX/iL
    H8VxfT+mWrOk6gTEWo1sj36ev7XmzFTd5PYGuFAKtf6QKhsmJ7oWNWJcRgRiK8uLf//ih7
    Znf4Ei8xFV7VHwL6tP77E6dWXd7FPli35rmKKPOQ8AxDU0/rH0ozBbP6VI+oH4OSR5iOd+
    uogxH+Aar9zt+/JFys1gQFwECbMgdJ2Nc0jxBgySTM6Cn0nQqRio9hqEjps6ExcYTiX6tY
    1la+osfKhfTyElqL7S204kOSyjKUXtDVdsSBbEmUqM3uhIHgNpIwwjMOxwAwO8rBE3Qk2O
    5HqLaY64RkxbU3TeGq6bVU2ihKjuXiULxUokEVT8x6sUfgt1Bptkv2h9325A8dDQpqM2Lq
    uAaqmyqlusv1z5Y4u9pEgAvW+NhtVcP8hn7q/xT15t9WSQvtK5ZH5WO4NoP7i52bjXPJFQ
    sXVwyam06FqqludT487UGFGVak5+MwpFIPO5SbMdXoB4ph021fMGuWlBri9xOb1i543ZJw
    OVsuULE2p5OKJqeiD/dnHsKVI8/pjvYkv9DPezfRSwAOTh7JRadmTllj23RA
X-ME-Proxy: <xmx:vBKQagII3ns-bm82xsUrhhXEdzXUXaVa0DoFwGJ5Plq7eTzTaIRJTw>
    <xmx:vBKQakvIDjkavzs7KMicrKCaDS1i4vSa-DQJ0W9UU1T9H_nmQUldgQ>
    <xmx:vBKQat0pQ4PDLXHSMmO2xaggM9PBaF6naYgRZy_OxXODV7RED7ATWg>
    <xmx:vBKQakPyrLvyR2jwfn16bH9PHA1Wvv6SuB4yUQg1_mOVxEo-N90OYg>
    <xmx:vBKQalVtREHedzrHOwHppXL1t3ROqXmgCDNGUf0Igq64AjZRGHbYNd-e>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Aug 2026 06:34:36 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: add myself as a THP reviewer
Date: Thu, 27 Aug 2026 11:34:35 +0100
Message-ID: <20260827103435.1371882-1-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D183F20009
X-Stat-Signature: tgsb7ubhy9jixg39yydj78ygin33oqz1
X-HE-Tag: 1787826881-561805
X-HE-Meta: U2FsdGVkX1/SBufjAOdRiTckpsoKhmAIFTiW4KJayFZ3Pe5mj3lDuz3FrEEEUNKN9rAbCXCysbCtSHbn6bEu9j6JyozGyvZOk9nuCGJkRQDI9VRNWe8jhY5cp7O1L6Y8qGjKDLWGN+gfXJ9y4CdLPdPSdv6Z5+FGvcZOuGAt3nwM0RY7RwdtJy8WYWHR/cEb2K9f95mN/EQOucY1uG0EeuOa/4yc1IeTURwAnq00FJ+8U4Th6tmZVdGREB7JZnevLIA/gqJdeylLT1TtTPbWui9x7dbbQ9LolwsUHZNUMqFa6uIF/3QGNY9Ltoac12dp0uBu2Mn5DVqxA0sp2WVeyErf1GSxoIMYGp2JVw0peC6SW1Up52k4zxSr3CAl5tAAZ77iLIL6/Y5yFcBu4P++gI4TF0EE6lAdI5S2v5yJ80JpHL/F2d0sEV41VS/tB2S9wlaqP1sCZj3KxzeVurDnEDbHMF2HQ4y4N+q+3NKsADMs6Rx5j4r44+qmgx7XgCrzc4d1MM8VQka53p96JFoeboIzRuJB7VtGuUyP5jMhuscQk97LdvNs5dGgo9z8czAjOh+pN2wcNhWg1NHt1K0soIJmJ8Ze1Eo9IldCLw0FVZajskIQZiCmkUTi5N4BppXkTVk/rTcCeBxHNDS1O1HKDX4iJ+J1R7+9ezy8QnBqP+Jx8pn3tL9mxUyYUki2HJbh+SLrvhWZ4AnOGnRggbqtgwruuimMBQJ6EVC+Lfy6TTgJEt3dPwPr6hY8UOyK3wR1NArkiJFw6Sz7RxHicn0War0PIP/D6stcvS0L2rDcVsQ1wPAcGTGjPZtsdq08xBFiEobUsLyaHlhBNwrYC8+Ox2HRggh83mb54cCprt15U+W9/4miqje2GMJMVXw5hnrPawcXB4xRctnDY79wv2d7rAcuOIn2ziJ4J6qybgneYEw1SbzQC9aHaKSYgWlTcZnpmTqzHmBdcoYolyLzGpK
 BMjFdKYZ
 GNcy3Xhg041HTDtMq3Vv8UDJi27xi/M01mbHwwVxbDtUo2+GxzvTeQDcit2I1faW0OcK2dtnTO7VU+Wsk0yRjvGX6grWnzUQZ52iYK2rHYnK1RdNC3DajlFpZOZGOQjj/lgM64m73zKkra7ozZDBF35VE/DBji2dbmrMauLGlfICA5f+u8QqCNnM4oiusUpE4dYdVYqnpnItX6F7eLsGX9DaEuA8YUwspiwb7tMEw45qkd3AqTV43zs2888UkovHstGAwRMpgreox5vYo52AyH9g+HT/TfJ9dJItN05tmBs/HpZgLJDAkiDsvWj5CVG8M7Z8xGDijZZi8G0S8BIk9EWa9tt9/v8EFmyS4QPsWl30RgQcNXVqG28k/ZnPYr1ySX3f5SvhsDy/ui1frwh8fHTBEiJDqDwjJqw75qoNpQWXhNJE5T0xtK8wiYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I have been working on transparent hugepages since 2012, starting with
the huge zero page and file-backed THP.  A lot of the code that causes
pain now traces back to me.  It is only fair if I share the review load
for THP.

Add myself to the reviewer list so get_maintainer.pl puts me on Cc: as
well.  It is also my commitment to be more active in reviewing this
code.

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1be7da9b6e2e..f5bb29ba41c5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17264,6 +17264,7 @@ R:	Dev Jain <dev.jain@arm.com>
 R:	Barry Song <baohua@kernel.org>
 R:	Lance Yang <lance.yang@linux.dev>
 R:	Usama Arif <usama.arif@linux.dev>
+R:	Kiryl Shutsemau <kas@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
-- 
2.54.0


