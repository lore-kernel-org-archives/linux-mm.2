Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED956C5516F
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 17:47:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07E986B00A1; Fri, 31 Jul 2026 13:47:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0562F6B00A6; Fri, 31 Jul 2026 13:47:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E86B46B00A7; Fri, 31 Jul 2026 13:47:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C26D56B00A1
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 13:47:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 10FF1A04C2
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:27:52 +0000 (UTC)
X-FDA: 85049603184.21.390FBBA
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	by imf22.hostedemail.com (Postfix) with ESMTP id 20D94C000D
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:27:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm2 header.b=b5nCQHhm;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="a Qa0aJK";
	spf=pass (imf22.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.154 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785515270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J5nIrNoSMiFUIl5DH8xWdANuglVgj8cbxwTsb9rwYoA=;
	b=ZnM8y6PcgSCOnnrXf05wKYCp5yDCAAQZbAzI0tRAKeIu9HrH+9akOPjnJpMjwr6plnejiP
	MaXr/eqF4DxydFT2kKVUP8248SPbYiy4M0/jZd+HR1p7GAVJJILHCNreZP6dJ2tJAQdNNT
	ZHbn7rQFYArkMTDuE9M5PpRTX5GewoM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785515270;
	b=KSeIzDlu7a+mjOJvBDC/tDxBrbkmHAzwwqzeM3x3CxLAbjK0vdPEWF65sB03hq6by1JVeK
	7J4195XcCnrx8tQPovBsoTBmL3j7MLczI7vpMzg9hOQbc65A16wT6+iYa7Y+AV0p47ZUpK
	xUt4JSWrrp0BdrYiGndzOPad7p2QsjY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm2 header.b=b5nCQHhm;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="a Qa0aJK";
	spf=pass (imf22.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.154 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 4D71A7A00C2;
	Fri, 31 Jul 2026 12:27:49 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 31 Jul 2026 12:27:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1785515269;
	 x=1785601669; bh=J5nIrNoSMiFUIl5DH8xWdANuglVgj8cbxwTsb9rwYoA=; b=
	b5nCQHhm0J+Bh4qWMlYQ+VsiYMqE3pkfp60xUmMoRloMX0iNUYrevWKmbbyiOWGv
	C8A4jONRfkjwdqa4UDoPf2/VFB+0CJDYxlfdIuwSFIxZ1y5yisj6t0jPZSM4VxsH
	pqOYwrh8rjbx+0D9GGSdTnnVK18qbw6BQAVphQpwLDfz4mV8GxmENU1812Qmh5Mh
	Ai8uEnYo6JS6yVNNqsya7j+iQ9tZbapAF0QAWYlNV4Tj9LskF3Mp8dVvKMe/e6jt
	bPcW0IZ8vzdsMlpLkaVB7E1912BAhzHsum9haIOY48eNaYCmPLEPkjirpl8oGvVO
	BCNwOK0df5Nv7Fh7gsl1uQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1785515269; x=
	1785601669; bh=J5nIrNoSMiFUIl5DH8xWdANuglVgj8cbxwTsb9rwYoA=; b=a
	Qa0aJKSLM9u3cdJFxgBm0tbxdbLzGB4URrat1wcWTbAgoDVihHaOx1FvOk5GIiQR
	/9p0LgUh2oyils3n7tYpJKvL79ebLZhQB0aghE1ZC1j4GhFSfbj859ouesVQHpTR
	21iCK7tU/bndrfcMO96y43oh9nCedWbYQwwgEDW3Ng2xKkth4bK/CclGpjKqfrNr
	6g3aqGKku+hEg9VOusp0tbXKRRX9+w2lHNgEwF9ea2ZOoWk1yP9DpQEtpDwF+IsT
	OVW5dLG/FN5Eg5QFY7GFd4Cg0P0hlhUvEJGbgcnZD7AL/LonmXWVSSdE+vPlk7K8
	GD2+mOHKnOpxl9PcfPyJA==
X-ME-Sender: <xms:Bc1sakFa6ckKoqrFLAzPC3TUrv5WJxH6ldYcow49AmwJFyn0bT91aw>
    <xme:Bc1satyJ_0I47EPzXiqmmi1_m9TXVwaQcCgTvfFud_seRcZqPon_9myIfXvEIVnvh
    xtv3nMfz-y1XKLyXPeBF10jKdZoRdIgT3vmq_Ar_VFPFuD_TdrOvvI>
X-ME-Received: <xmr:Bc1sau1WgMT4nRpp1Fsg_3S3JEfCzTecw1KWURrEtAPSWNnCnA_fvP2WfJtWoMcWgnExcfRUem-PM7qFwQ>
X-ME-Proxy-Cause: dmFkZTGGTelZmm0/EhQAYArVTdDhZzjnmAPb6bZI2uOfRhcPRz2TI2oV8V45PSh9LdLr+9
    dOlgXoBfEoyyFAhrcqXPD5Q9hVEjtJXoIhF2MoKd1yKDTw2ea5Nuq/+/AmFYSUo339o9zZ
    H/at4LG3KrzxwoyaKUbXnTAmsLw8u8bstL0n0Hm+zeS6dtuk4WBOYvxR1KeM91qs9pbTHn
    V5Yj6ph4RyA95kbMawVJDFVjaiGwugJQQV6H1QnRSnyH1rCnmQnAGiB4dMHKZak/Asn8tO
    F/0oy0n4YeNO9MT0ImsCVvnJvFB1zR3ciQwN/2JEWm+YOztTqwzq31OHYrU6wne+Cpi3K5
    TTD8qnOBAfOaIb/KCcnmwKr8TGm24y8rMJ8KNnshmEvBNvcrVA3lZ/fsqnabQ+bcEZvCxK
    jVF6kNhPnROpmUpXsT9cQQ9WQAmvp3ChKXD/51Kcb96H3pMPJzDNcq1KfaKpkTZ8t4KfO5
    AZsrHKXNbdf8Go9a0FfJSzKbdlEWCCQe6tUIEj8/1faJjDnVbgdenfwqKItxhfUu5xB2KJ
    wGozjEql6w4pzgqozJiilyeInEsR6qujBgBrWFTgx+kdN6tGchhD24yAmJ/Q5c67/RvrEs
    wT/Jm4IWcIvL3Yzv1SN3Sy2S1UiUxCs+GGRjhmkWjnngDVFojYXuBC16Bqmg
X-ME-Proxy: <xmx:Bc1satrXBRkLfy7bBimN3F5eqR7idEanWT0Vno0Sk7EwpK5or2MGVw>
    <xmx:Bc1sarX8CGRGgs6ptGjh4hnHVpC5Hyl-vlRHZqdDlvC7PuwwdIO5XA>
    <xmx:Bc1samo4L8h--wHiXNuzz4IIByBgWUAUm6bNzU9kzfDiV70sIy9muA>
    <xmx:Bc1saiAZoPLmVSYE-iqXwOXEVnDxMd99-Vrj7I2Y-e1HY64J7oPTWw>
    <xmx:Bc1sahVxvqUHa0FML2utnkaBiC0hBDSUqJQDNS2wNexZYmN7JiE2vwDI>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 31 Jul 2026 12:27:47 -0400 (EDT)
From: =?UTF-8?q?Jan=20Sebastian=20G=C3=B6tte?= <linux@jaseg.de>
To: =?UTF-8?q?Jan=20Sebastian=20G=C3=B6tte?= <linux@jaseg.de>
Cc: devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	keyrings@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	linux-integrity@vger.kernel.org
Subject: [PATCH 1/4] of/kexec: fix typo in comment (usable-memory-range)
Date: Fri, 31 Jul 2026 18:27:36 +0200
Message-ID: <20260731162739.158320-2-linux@jaseg.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260731162739.158320-1-linux@jaseg.de>
References: <20260731162739.158320-1-linux@jaseg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 20D94C000D
X-Stat-Signature: j91ybytmtmtgmxepg9gxieugaak9fn1o
X-HE-Tag: 1785515269-159513
X-HE-Meta: U2FsdGVkX19tTSsTpf4lftbPZqJ0v7TZtKk9HOn+wFhSrC74g5HT0ZfZJ1yOj+GTglD/P0XWPHLtRh+FrQF8ebw3iYrxBW4ZzmZIKmTyXiUW8Oy6j51ubjfzJQgZJ24BqxjlQvkq/6fWaOIoj4IrqZ4tXxCstd4P6+NC4/hsLmvuvIZVKhMkv1MPqK70vFCqrFaqQENhUKSQ/4UkNI/otMmHcI0UPks84OqYbsKKHwkiThHR4ekMWJag6Q3nYFvuR4CyJgsoGS+d1e6h0caZtCMJ0llecBn+VGcK42HkXwcsbeCf6366eQ8nHzVO7GH3LXmacQ/pUemIWgL8cmnTuMEXBZI3a1EQGjqwTYsKb5hsbovyQw48ekaZsoUUiXJoxfuKBhqxP/wqBnPo6WIbI09npkB9zW86d2pwj+MIn04azITVTtaQSj+Q3xetZ7Iif8Ex+0xTrP/uoIrvs+2Yi185WKxDopfHRUlObsr2CmHpxS9YcEsnoMBICxb116ZyG2P6zRnWxfny8FNGu8DyoccKM3EORmPvcYnGEE0AYFOD6lsvj4XouupYcw6O9G5lwL0F3tbZEyAw1W/meyBbKt/GKe7TUF7O4OSniaey1aFIFT+j53hLK+nOU/+hi8ZNpU7n16U4c5i6rfSJwbLUSdPm5d1e/wuIqZ65t0sXc/SdAqGr/fVGr5uwNAFNGREI5aG+sb3zJW24SrEnNZqxPVFPp/Kw6Fg6BGMyF01uymhM4GWpGoWDDV28zfaZN6ZAexvzv9TxJEaPw12CNqH0VBDiaZmKCZYkE3IfSgbVw/Zix51sxfwqO1P61dkZjbctXIPkOmRnTT5AZAT6Wn2Moeav1BO+bnbydCd5FECLAUuv9wjOwHP0yz3QK3PTqBtt0C6KlEnPLbwmHjuv4C5bZKSg45jaPs8R7lv2vpWP/SuSjQz9CfZ9pa+dXz0AtNvnDteu2nOoKfClT/AfRek
 0dkWNwFR
 Q5hOfglJpOJOxXY/OvgHkW5k5B8whCV6NAGRNiJapFF0K1+4XBPiFCBVdczh6uexYKpJjnJ6Hjx9/FKIulkAmDAYOaH9s4dvJKRG2pJVlk1TVLztNT71YSlPqWqTzhOIQBNCRHMPWIZ2wkI6PtpXOxa2GOEyzN0+VDcqNo2tjgO2EebNS361/e1KPvzraK3O1qS7LtSppvAF/pp8aJVIQuD5biYxr/uuNjyW31O4XPV0GScULWh17IKazCxj3yiEFdfaZXzzogeTfiMeQEwJOqAfCPMFmvSURaw7MyonAFPfk044MLwLtjftR31lxk20U6Qe/A7tlRmaekUYtiFNDxFW0Ag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>
---
 drivers/of/kexec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/kexec.c b/drivers/of/kexec.c
index 029903b986cb..36635f6cb900 100644
--- a/drivers/of/kexec.c
+++ b/drivers/of/kexec.c
@@ -24,7 +24,7 @@
 
 /*
  * Additional space needed for the FDT buffer so that we can add initrd,
- * bootargs, kaslr-seed, rng-seed, useable-memory-range and elfcorehdr.
+ * bootargs, kaslr-seed, rng-seed, usable-memory-range and elfcorehdr.
  */
 #define FDT_EXTRA_SPACE 0x1000
 
-- 
2.53.0


