Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6558CD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 08:21:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 370EA6B02BB; Mon,  1 Jun 2026 04:21:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 322376B02BD; Mon,  1 Jun 2026 04:21:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 237746B02BE; Mon,  1 Jun 2026 04:21:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 131526B02BB
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 04:21:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B6DD8A05D2
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:21:05 +0000 (UTC)
X-FDA: 84830648490.19.42FB748
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf17.hostedemail.com (Postfix) with ESMTP id E5E424000D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:21:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Pg7ytgvf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780302064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lVDMe+IfCVP3nyAHhJAHUzt4yIWtJN2LAaqw4VBU9Dg=;
	b=gO5vJCiViUwDjwCoaZ7ycVoTnjgYVuxc1FNYg9DJbOl8Ict/kyrVObdWX2ajrRCk/D7OdD
	oPI83WKgnrTJ48dJRgjX9RZW9+TAdzcvLBTVbmXDkBsJ+B3sqtPgOv/7ISnVmAW5T1v7o+
	IQ7btY2NLyqYG+rEbSvzUlKaX1m+/Xw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Pg7ytgvf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780302064; a=rsa-sha256;
	cv=none;
	b=g8sx6rZs8Eh1Hfz/jUxCXU0djolXS7Klrm7Ehk9SmI4WFtZFJwgBHL3ySPI+GNPjvJqQGT
	qcmJauasyudYRpiXsTzfYpKGjT9hWM3ElxwquD0OScqgkxHO/E7BNgnb12NF6vUjGJXRyi
	0wA5jSCaVWNegPi5oiK+ougFEybVrhY=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-490a76533faso1731185e9.1
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 01:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780302062; x=1780906862; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lVDMe+IfCVP3nyAHhJAHUzt4yIWtJN2LAaqw4VBU9Dg=;
        b=Pg7ytgvf/E+3BizCL6xqvinQmDA8W1Jcle0ugf+GLhk7Q1PXCsrywBjISmwkRQjP7w
         YuPvZJjoXPEPvPaaKzZwPhyp2GvoPA9Zoi/atHdyLvbD3G76+UPnF+3mFiPO+zeERLFe
         vhKtzgJSij+W+KAHwlI5/c8zQYl12ZXeaFWbOYznLovKBd5HsCl/26zj0oPHIGTuZuIt
         bx1leh1Nf35SQmHDcnYvE+ppcyYYeCp2jeoQbJh2VgYUvVwl7JHwRW0F8/wnzj7uskA3
         8aS/daw7KM/Se1RfLi8XXhRiJ97/IkzT1evPErpWQJzNyT2G2FuH9KJIuIwZM3crOMwJ
         HUbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780302062; x=1780906862;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lVDMe+IfCVP3nyAHhJAHUzt4yIWtJN2LAaqw4VBU9Dg=;
        b=r7DdlScWvXMNFOeFJz3HL8jjomeP+6Cr/W7tHaQ6NfIBZMo25GgxjjNO1PhdkY91hW
         hQ4MF6c4cInRSDMMOY8RTpEXmCzUmBomwhMOOswwMlb0Vjb95mxRZlCeml+HK9z6xyad
         8KxiWHTqPaRCK9RwnBcLrxdj9QYbt0U2pdrcFbEELzvzvWmYGz0gQtgbeRwJozaTn/QP
         xHHaFUnjhC6qjRCyBr3S24VufsRmEJ1JcZQFKbBFgG6KFGGvGVjm5WraN4OmSTo5qrU6
         PALrYyJlWgMv7XYJ/xBxEM8knGGHHQL+V8ZKh7j/UQdVvlOAXypXxkyKeiWgOZ8Oej07
         t+9A==
X-Forwarded-Encrypted: i=1; AFNElJ8rAS7sMMJ3f/L8Dmw0fuKkF+s2XmndeW3B2QR3mTtFyVJIGdtLnDQ1ykAxI4Pfa/fFrAwizkx9fA==@kvack.org
X-Gm-Message-State: AOJu0YxJh0VVX6q+SF0TwPx+pYHcVWZKHR3cQnP9hF9GcBQJNsfr2Ao4
	37/B3yJMPehEPP0qdoHOpse+OFBT+u+4TVmBP1cHuCQ8CcX7u9ligi53
X-Gm-Gg: Acq92OE/WDunYGBcdqkGUnukxYrQkMV5ya0B04OBWCAKMf6dyU7FYTg1sTO7V1XHOWi
	oxrfU/zPgX5zo/YuqKInhgO1SZxHMeAdksKUpCs+Oo34d0idBbK7sHWGA1sRZwlw8sQVEkXiR34
	lWC3j1Q5KZc3dy5gdtFlEYD3OwzHzmnZRCGatEY4/wlW+NzApSiJM0SYbLKGTPvcqQRDjMiQJnO
	xOBqoz6VldsGOdbBpn0OV/tOVwVyG3PmTPheoTGv8uq+wacYITYVj9Gubx0upY0Wii+t4Xx7waP
	M+BPGygoHOOVpG5oYDhza9A/ZXHSc6SMO/YD9gy5tSNIF/ZWJr2R02yyVZz01PCAaDhn29aWpeX
	VcILgYTpMjNlhVasIAfmw8WILzAIM3pumbEUma2TamiKccNziLH24BJAHCn71k9EAid1FUtTinQ
	0k56LRKrF9EUAfh9Z5qbXgcsGQ22/AefY0ctxd4ZE6iBBUjYStfTTQAmKX30MJiMwZtSwN64zbi
	xFdPSoUMPvr2Q7dx1jOSnCsEDvJJw+Actcusp56GRcEZWKWMQT3u94NFb8Nt59RDz4fwHSZOg==
X-Received: by 2002:a05:600c:1988:b0:48a:5546:619e with SMTP id 5b1f17b1804b1-490a294fe14mr71925115e9.4.1780302062057;
        Mon, 01 Jun 2026 01:21:02 -0700 (PDT)
Received: from fedora ([149.3.87.76])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909ca72cfbsm222228515e9.8.2026.06.01.01.21.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 01:21:01 -0700 (PDT)
From: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
Subject: [PATCH] mm: mm_init: use div64_ul() instead of do_div()
Date: Mon,  1 Jun 2026 16:11:23 +0400
Message-ID: <20260601121122.94379-2-giorgitchankvetadze1997@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E5E424000D
X-Stat-Signature: 7ceqkai5hihstkwgqu1mcnxc6nifx37g
X-Rspam-User: 
X-HE-Tag: 1780302063-875060
X-HE-Meta: U2FsdGVkX182+OF8eTpCHHQi2syG8NU1hlwV2J5Drt5Z3Ny4/8kTZRiu7ktycgiJ82ljgMMlqjyN4suGofFr1K9FHUHuFx+GViN3I1cFjkO4nq8uojeqllnvqMfZg+5uyNt2oYU+jDoMHQTVzJKOT8MsZUeUcmAgblAh2H5jyE1MlEt0p9wWSS91FQeba41iCMlr+jUIaq/48ulzbr5q/m6VA09UsrKJ48MEuNXYA6fUsnXeNxQtUXeAn+Go5PDcno1VfSYHu7PiOASDvBstwlBSpDqdA9msDrpjUNrgULElCuUbULHUNXJ4cSYbYybJFbK4uXPR+LCrariy/Wn5MO5Uu2rxZ5/725L2XgFu/6687zo10Q+jS30dUu2fQvNv1KA7yO0YCyGBLzg3ATJTNZXnU/FW2RgJE5YfoRPKaGJQPfEANwnmAN2HYlJRGFWp2ZUEO0ZDCYdysStpstJY13Fg0lcVN8PonArnKOPFqCSL24AZI0OKx3hYvOesvcsv9JSaNQJ8kV9txYk8je4XJLmBLwpLj5Sx3YfjNPIvt00ixfp3jXRblwPdhoSm2c8mxc0WzQcArk18p+MXE0yMYposFdlORxzeWaCo8gqq4Z2K8NHPzi2MqXPKf5S7To+kvj1uBwvB4f/n0gDKufFG9tyi2ybVfmFWoKq6JgE1coLZe5be9Q11HAFwybfU5QtJFUk7A/TZcLKKlUzR038brLIZFAfs3MUiURcOWgVOVpGXKsIGdgHisxaIwPoU1lDJxj3/dGuoHngl/KU4+YFBu82wXEVk1KEpG02FGMMgWJE2dWso1J24duIAYnp7ZW9XhtDaCZEA/M0vnGgVs1UtF83o5+WgK54WpO1Yj9AlBKlJjDvkr22LtjOHPbSXavNms0v54mSn2Rnh4eaoaLp2a6EAuqoY57ePqqrHQ3hYz+cscVDoR2XkUnZU6nsmHLu2DgtjNWFbOfq3hEFctrF
 fmvnxAyO
 KhE5gbvN3kJOC8ejhiC1O3YX+LqeL6v0Wf2hwRUXkwdn/05A6TSjwhB4z4zCioq3Fp3nX/VHBpUPFia326fE7QF+tPh2G3w8oxfsFfTvs5S4MvcrWcFM39Zsn27ElIGLn/qBERyjnsvsqF0TgnndKuM3gnD/Duyz/0mQZa6UbunMLQXFFlVgRq+lGj3x9iKJLLUjLP0GqnOmpZWuMR5rOAfJ4btacrXbIUHK7X14v74Hx7zeVBwiO6iOjt2Txk4LTCKckyBXMgOHR61hmgDKqhygIQitLGE5RsWr1Zv6PttMo4dzitg5g+lg1vDdPTxq0Z0OtYGIxOTpCqNmC5oYNPtopIrDwW/MXQrg8cBWgDTuBVNUfdTFtp4lEgMic5pxOPU9YBOFUuySjwwiSSDfWHAuu1dYvIxXgoDGIwSWLsD4miWDqekt+BN9husbP5x/riDfH9H9jghRPx/s51p/Cd+3HbYzbWa40p2sEni3926gqYrI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fixes Coccinelle/coccicheck warning reported by do_div.cocci.

Compared to do_div(), div64_ul() does not implicitly cast the divisor and
does not unnecessarily calculate the remainder.

Signed-off-by: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
---
 mm/mm_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index db5568cf36e1..4d335eb799e6 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2426,7 +2426,7 @@ void *__init alloc_large_system_hash(const char *tablename,
 	/* limit allocation size to 1/16 total memory by default */
 	if (max == 0) {
 		max = ((unsigned long long)nr_all_pages << PAGE_SHIFT) >> 4;
-		do_div(max, bucketsize);
+		max = div64_ul(max, bucketsize);
 	}
 	max = min(max, 0x80000000ULL);
 
-- 
2.52.0


