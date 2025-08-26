Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDE26CA0EE4
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 06:23:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D9238E00A3; Tue, 26 Aug 2025 02:23:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B1E38E0090; Tue, 26 Aug 2025 02:23:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE32A8E00A3; Tue, 26 Aug 2025 02:23:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DB49A8E0090
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 02:23:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 726A61DD9A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 06:23:30 +0000 (UTC)
X-FDA: 83817916980.17.6DEA3A3
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf21.hostedemail.com (Postfix) with ESMTP id 93C5A1C0006
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 06:23:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GVNbe1dM;
	spf=pass (imf21.hostedemail.com: domain of visitorckw@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=visitorckw@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756189408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KZyZNf4Dr55KEIlR75zNWS/ByBEDgqsfEHPE537c8XU=;
	b=XUMClOf9yDmc42hiPkWqWpfloLjI07i0WhPYbmZPVhN6VcFoV1R+GDpjgi356Y4Sid8nTk
	Utl2YHHckQbpgmugp49kq9jPMhiBCdSOnLN/3sytdi8vU6NdLuTOyHMFzTPHfJXQmXp0X+
	VeDll4wfWZsZoXf1Qcl6t2MLTB7H+AY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GVNbe1dM;
	spf=pass (imf21.hostedemail.com: domain of visitorckw@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=visitorckw@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756189408; a=rsa-sha256;
	cv=none;
	b=ilwxEGnAsdItSVu6/6woNMn4Oj5q5Puic+Y18VWD1D5HNP5YZCViJXuS7vMQydMYNAdvk9
	PLSAWa6WFbd11zADBx89/FY6OqtRyo+2BprYWfU4QMLp+K87uPypDruRswxR/tRNJVPAyg
	hTeWuNCDz27SuDsq9CPQ2g8Wh1wbkPo=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-771e15ce64eso1360532b3a.0
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 23:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756189407; x=1756794207; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KZyZNf4Dr55KEIlR75zNWS/ByBEDgqsfEHPE537c8XU=;
        b=GVNbe1dMkvI2Ov0770Pc6/td6x9MAiVnEWZYL4mpXnc938jiC+mPsGNZm+bZpFQ96Q
         uvxQTsjSUUQOQ2HqPHb4Ye9ldf5RD0kR9sXXSAt1i7ADAQ4C2Bd0qdT20XiApQZqstlP
         P4nb5MMaDHTuxYiklTaUVjdmZgKxRUnGsdaov6Q/fS0f8jnG85bld64hziNhg3iVGI53
         8Q5bSEJm7wb1DV7mxCZZrdzK5jDRg6abI1vpdIaY1WyAkYDz1IOSd5kleRdetU6DVAlI
         Yh44lAXUUs3eSwgYJzF5JXmZAgAQ6QPP3VZjL/U2qet9Kaa4CRGGJltuPEBUUIV9euD3
         ls7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756189407; x=1756794207;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KZyZNf4Dr55KEIlR75zNWS/ByBEDgqsfEHPE537c8XU=;
        b=uXkHL2tuPSMzIckf/24GxUhSMhhOIWV8bt+405HRO9vewJ2AMAzly67MuPJM1PcEw/
         E3jC6Mf+8KsI7eJZ/xVgLnppOyuFg1vv+KaYRcePb/aV3fWW8ntyvGP88pKlZUYWH8cI
         T7L/sudv+ZunnUNuOOksC4d8x4fJd2z7fr4N3A32vyXrpnc58mpO1uT+Oq4j8T1e5SFz
         fcXlEPUErA6pFUaq3SH2VDn2f4NtUkuBIHmU4zjrJqUTeH4iTm2kBtTBDLUO2aVVnwgv
         9PK9hKPwLKigsH4upnSdXM1d4AgGh73CUFO2eqdnZZZvCFxnPpi/4KkC1PJDEjj/p/4E
         5nfQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0Dg73+f2JOgExJI/g5d42HuU3aiUnuOX+zuAyzHLY0MoVwvcUc+StD8cGFXRz8D5xk4wCdqZxaQ==@kvack.org
X-Gm-Message-State: AOJu0YwGQMS1hRMYROw3eRebucYug9OIKboYAp0/orhLXr6Zuww/gL9g
	Kmoax5DI//sQJLxZKHYzUzDKIT7Vqy9h6B777F6cgcwJPz0DXosdBeAqn4n3y89N
X-Gm-Gg: ASbGncutTINtha63/hFBx7hi+ZWG00oPONEpGy6wze4XqQWHZSTIxp+v0oqhLGRDxf2
	7IW6+DPysnlqDd9ZhK4IcJJ82znVrHpTbJ5uM32ohHqfuoesB2icZ2w4QhHslXDACIt6i9Vpryy
	ncA2BLxJAgHA3dkvhfP4hXqX0CKUGdu5qaKBiSgvO/PIXfhOmvy17WxozLN/ScKFUTSRTbKtKAU
	i6vt0oKgw2XcydAsl6+pBtti7lMXf8eQT8DHKXi3HA9bpAcZ7UfMHuV33Ns4GJpcHu/jxdDhITH
	xXPMU9aK/r2/R3auXI/5n7enM4hABwGKUDqaZgc/FLNGapoRJIAClsMwdAA9wpvjxcqGGzJ1uxi
	EnqnAJ6oHe+jYFJlz2XLXK8yBQ5ahkJdnxerRAj7rClhjVwtgt25FjvUz5dYdVP4aetbhD5keeA
	==
X-Google-Smtp-Source: AGHT+IGoeyYkfTdO7uF1s8t48caGzsyOPfqYIDXRxUuDxsAVNHKoMtxa7xfOKLylp93hCfDdks4Gqg==
X-Received: by 2002:a05:6a20:1586:b0:243:253a:fb7d with SMTP id adf61e73a8af0-24340d2c163mr19908117637.34.1756189407377;
        Mon, 25 Aug 2025 23:23:27 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-771fbbc3bb0sm492535b3a.66.2025.08.25.23.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 23:23:27 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: vbabka@suse.cz,
	akpm@linux-foundation.org
Cc: cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	harry.yoo@oracle.com,
	glittao@gmail.com,
	jserv@ccns.ncku.edu.tw,
	chuang@cs.nycu.edu.tw,
	cfmc.cs13@nycu.edu.tw,
	jhcheng.cs13@nycu.edu.tw,
	c.yuanhaur@wustl.edu,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: [PATCH v2 1/2] mm/slub: Fix cmp_loc_by_count() to return 0 when counts are equal
Date: Tue, 26 Aug 2025 14:23:14 +0800
Message-Id: <20250826062315.644520-2-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250826062315.644520-1-visitorckw@gmail.com>
References: <20250826062315.644520-1-visitorckw@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 93C5A1C0006
X-Rspam-User: 
X-Stat-Signature: 9pp5fdkxoyq8iq9x9gi4p33rwabwruzn
X-Rspamd-Server: rspam09
X-HE-Tag: 1756189408-845721
X-HE-Meta: U2FsdGVkX1/oiql7ZgDZxL1ig7Du7KSCTV4NO1vy0stUD2Jg3CcuDpYDxyR5uIwmlgJ2/f0Ztap/mCygqCPUPoxeiobOLJdEbgOL2CofKanM++7EagNbNHLTQJhnXYaIEtI0I4eew5E+j3cMOMMUoP0ECVvEpSyVwk78xSIozapoeQno0mKWsYsbEhkvgRl57igWeqIOBTG/SqyCcfskTKMOQ5FYLXEoVmhjL1YeEKmf2yN1hP4qK1I3siFKkYJcdHDp8cXiZzwRpxJW8St5YYljZLOdpQ8/iFo3ZJozNY/njKmiW/vMvE/y43gAGhVKt25/T3xgUtXc5k4w/zBsSPZjXL5Pv2LtSRxylU9Nsh7nRnVPBcjvPz8rYEWhxCgOiBZK/nl1BCBGT7W9pxT17yle3vcY9si0gK4f/qJtjkRtPYhUMXM7jX/4MtxbyIxBWBppg+r8TrEApxgWM5qdtsoyjwavuM14kH2I1jNZkyjqcGXN+xS1Kwa2HdI6uOJsFb1bmK4wZz5lTOj6CA6JN4Fa0wcQEhUTwkMeGF0XFN2xEy/TYWO6A9kAHQHWTU1G3P+oDFSjyCjhvQmNj4WQOZIwegyBhKvCDIV3esk9xDdbgGGIxcao6t7LSXcO3Wn+eIlvVb6CWU+no9byNnpS3Bbeny1MAcdkMtI0KeoKx78QYpm/mG1mDS9p0XNVT1A+QkE8ERgKrCEmxo2qJv63wgZy/S98yNmqeQcOUzXf2LCEmKZMFBEuSGF16UcygInqtGHEW6UIMJde1H/77OkLiZxbRO0EhoLnfBibvYONccT9kciY72eU/6K/rZukmJZdN/BDZMN9a5DtofT/Pk5NyqSxhtEEY0+txwVnimHCf8L/oT/MKAB3cU1bHlWxOK+Rp00QyfjmxSB1AKPVtnIv461ejI/13aT5VGkt4Q947Vnt6nwtTlF7j4zdlRg5bNDXARti9IOfbnK5QscTnVZ
 KMQKjLWs
 LX5cfiMD7HaP74aahRSJ9blYUMXaOEQ4vxEYilDnK6ON5KwhzUNV7UMosW+QBFJl1LISyhaaShOgVxG2sKlpnpm8SoJxkyhhORtWDJi2B9jCqG7JaF/+qN6wEDROVC4E+CXEN/OvF1IUpsiO3OW6m4bZKim4Ep0TEE7vtF/E7QUWO+b1kNxc0ZPJPcSYAEWmHKF3DjgoLobQKMHcQstYQILN10PlKXRBZkYzFOCJyH5xYgXiygG/oS8/RQug7LOCDNKkeHI1pQDrLhUFXlIRfYnl91t9Yal85ns+Yxf8EjPkKEQltk9129TE2zC56ocCgKhiDIed8k1Kcf8KgTEKmeMJD9Vlb3EmUlWGoIaUET/JZUargHxk8eKSZ2Ulin9qATbHMj9B1xIWdusb1wiXfR3a2YTkpcBgwF/xViWlsDaRskLUVV35cbcmtrqKjKCHXUEuR5b2xrdK8419xNo6/CsBpKu3k+x5nIvY5GKFCMPahpwY8gcJpWE+htzbYO1CrUL5PtyZzifdqHKbAbF6uRlLYGw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The comparison function cmp_loc_by_count() used for sorting stack trace
locations in debugfs currently returns -1 if a->count > b->count and 1
otherwise. This breaks the antisymmetry property required by sort(),
because when two counts are equal, both cmp(a, b) and cmp(b, a) return
1.

This can lead to undefined or incorrect ordering results. Fix it by
updating the comparison logic to explicitly handle the case when counts
are equal, and use cmp_int() to ensure the comparison function adheres
to the required mathematical properties of antisymmetry.

Fixes: 553c0369b3e1 ("mm/slub: sort debugfs output by frequency of stack traces")
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 mm/slub.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 30003763d224..081816ff89ab 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7716,10 +7716,7 @@ static int cmp_loc_by_count(const void *a, const void *b, const void *data)
 	struct location *loc1 = (struct location *)a;
 	struct location *loc2 = (struct location *)b;
 
-	if (loc1->count > loc2->count)
-		return -1;
-	else
-		return 1;
+	return cmp_int(loc2->count, loc1->count);
 }
 
 static void *slab_debugfs_start(struct seq_file *seq, loff_t *ppos)
-- 
2.34.1


