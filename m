Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19331106ACCD
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 18:19:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00AE66B0093; Thu, 12 Mar 2026 14:19:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB7B26B0092; Thu, 12 Mar 2026 14:19:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1A9F6B0089; Thu, 12 Mar 2026 14:19:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BFAC06B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 14:19:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 53D8D13AB0E
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 18:19:53 +0000 (UTC)
X-FDA: 84538224666.29.4768EA9
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5F87F1A0002
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 18:19:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WILExUZd;
	spf=pass (imf19.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773339591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bd82W9EWXsyf1ygE+4E7KIjySZctQNSmqHpy+W+OXjg=;
	b=VPBk6p3QDgjrDGSK63LGlSjCHmADDhap4M+dCQLIu65+OXeR722WgWSRogJ9F7eoeMIxUs
	gI0DNf1N1vDBgkr15GRbyZ8f/2hwuvkF9hHgVsRJziP+LJdnhDAPm/FM8/z+vSB9xcdBZP
	7KBZCj9lP0mHgNeJhNGyuBkoWnpPd5M=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WILExUZd;
	spf=pass (imf19.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773339591; a=rsa-sha256;
	cv=none;
	b=iR/QNMtmzWiXNkv1jt/52Ps4iWX0UhyGW03nlmsadXcSgWykEqECfiwMzSnw6SAQBdjXfK
	OXrqNZ8X6grq7QeZAVZVyb+npqzlsFVGZGuKa8nBM7A1L5Q4/IVIkR/OYUaPfQy1YRrz83
	As+7g8xxCBwqFHvY5G33b9PZHuMcM4w=
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-59e4989dacdso1593950e87.1
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773339590; x=1773944390; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bd82W9EWXsyf1ygE+4E7KIjySZctQNSmqHpy+W+OXjg=;
        b=WILExUZdvctPMmIBzT1KD0xAP9CYnSv8/cLAVdIgcf2pqCv0W/XvHHTrepqomfly/Y
         /mFpsZxmjbDzkzP11o2q87J+4AdOXxin7Q2cMOLw7J2kU5Eg6wWoFZhVMY/OTibviD75
         0ndV4l4WhKWvqVJYWUrJLU60YHAZLLee6UIk9ud0vW2HGulf37wRtA8UxKyPsixyVgox
         qek65/7HkNnp8vnrYi8MjgMs/u70DHFpuCjG0zZYtxMnpTJuHbub343UHI1/T7PiicBP
         vjR8a8jmR/KZvdFaQDCZ2gbmkNBhiGsjScoCKaSfSNGyYI7sv2B5kWWQcxXJBpHMiWua
         vOpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773339590; x=1773944390;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Bd82W9EWXsyf1ygE+4E7KIjySZctQNSmqHpy+W+OXjg=;
        b=PL/OTMU4JTPMa39pFM/RCubbVd/PZ1ksXBwswEUYnivS7Yi/RXGt5+GXorUxpM0gaC
         MA0XLiNBUc7DDNCzpyzWhve6o3NCZsPZtGkzu0gWcyhG7KymMXYXV46CtWTL3JHFNGv5
         u4D6cKOdnsHey3OmeFjtodXg5vzCbpLXKeEQApaxraY1lt6jEZWJoX9a3O/c+OVI8Zm6
         NiT9HxQ9VEfcK0A8QbCJ8F1yGiirCjkXOYv0uvmDMoOpEssFBRxr4S4F0z0fhrLzOUsb
         cztgD9x/YxcCZy2sOBCMFrsw8pUcGz7BTu3KCK3bcVMtaxwX0OHv41vq8RBHYzj96q5c
         KRIA==
X-Forwarded-Encrypted: i=1; AJvYcCUyDdfWW7Yzp/YGyejDzIPqNlZZ9KiYmLw4+3UBJCnlF+ERNTgU5EoLAoXmsG/D9W2QD6mVKHaIgw==@kvack.org
X-Gm-Message-State: AOJu0Yyz8Uzv+Ux7mrE3Z8wyuP6TsVSuBsyw9zm8HsfiA/c2hFyUOlro
	rf391LdIjJgeAYjZ0yQ7GLjIJ7cxqLiPEiK/51A5d1tILiFZgX/6PKJ5
X-Gm-Gg: ATEYQzykdnEZaKfnCWq+GMqB9ZHiHfAPclGYryFqo85gnO7BjgpOoBsv3JNrG87Pe5N
	vrOkGJr/tzLRyS5gJR6SoFMWnVUgBU02JHewYoLVxJhauGjrhaNJBUpMfPV3Hr/+cEhTCEcnTqz
	negZqYoC56fLsMFhAAaWh+gaITuwpG/rOMa918iTT07CA9pBa/8L8cwQjUL3qwFpHtIeUodu630
	ot379bAIsYNsBZ5jNQJG+6KBDaim+3kYJwiYwc/K6SPyPJbLv3dCRMQ0gaI44o4nl+DLXz3Ucmp
	T957XKBwL/xD3ikf2mEXXbdsEEemysnMbSSq72wu+VPVWfOks9/j/OMEh7Ad/EgLX6lKr/y/tca
	eVGv5NvkBZEctqzEQFYd24Tw/DMZO7yYxfgB9ioxsc549h8w5mQW8MJj/uvmmt222YVrRN/qPA2
	6bK2KequDGnIkczfKbtFPh6Rt+IKV7mHljowhgRKeoLh2URf4Oj4+iUNNGS69SF8OmIOXO1M1DI
	3qC6EOe+g==
X-Received: by 2002:ac2:51d6:0:b0:5a1:3fa6:8c62 with SMTP id 2adb3069b0e04-5a162b0c0e7mr217244e87.24.1773339589410;
        Thu, 12 Mar 2026 11:19:49 -0700 (PDT)
Received: from ubuntu.. (static.159.107.27.37.clients.your-server.de. [37.27.107.159])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a15602e7d9sm1085336e87.35.2026.03.12.11.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 11:19:49 -0700 (PDT)
From: Josh Law <hlcj1234567@gmail.com>
X-Google-Original-From: Josh Law <objecting@objecting.org>
To: Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH v3 1/2] lib/idr: fix infinite loop in idr_get_next()
Date: Thu, 12 Mar 2026 18:19:47 +0000
Message-Id: <20260312181948.20020-2-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260312181948.20020-1-objecting@objecting.org>
References: <20260312181948.20020-1-objecting@objecting.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5F87F1A0002
X-Stat-Signature: f4679m178rbk9rn34jw83iztmebu45rr
X-Rspam-User: 
X-HE-Tag: 1773339591-734051
X-HE-Meta: U2FsdGVkX1/csky66UJt51rLGSU+r0ImWLTABUxz0/hhybG2h0CoV4MaKYwTY+shrgUZ0vjNJdggGk9IG2fN+vl5466+2uyNERzJKto6sw8Sz2QrWsuvf9kj2nnupiahHZhCiXX5kEKnXY0b35HdNJBxGRjqRvyGDEBhknFwUeGdAiU9oFcbPI8G8VaS4xeXMOCWGngg22lULcFjJSyD7Op6b5zxIb+gVWgHnuhdHrVM4SL/MwLJ6DbEipivpnmfB2YbWRvu0mJr4gZXrXVAXN80P62BeSGSkKgNawV/ER58WRjWBlxjpLAxMArRWuULIMbi348ixZbkLo55XD9sDXjd4U4gkPUq0rFM9nLRn1XaL/po9zmFS3B5hmYx0MrBgO18IFEAoHMdmNkoSQT86SlrKBM0Mb+4VbxBaxDaFZ6zi+Qcp/whtLJsq2PjkAZziQ4O67YCQBD9zPzOUqTaWCDL2Vlleok/wCgXiIZZQswwaPgMPzDpwV6HCc9tYI0rHcH7mp/HMor2FYD2gpGDi7SO1jkq5AXUVHfG3VNV3GO1jbhTwGqUV7kJoLMt7uY8skYJc6hkgCQRgrDptJdUGgqJ/Aan9lCaUd7UF6BUmA3+sBBkeVYr91PY/v7Wq2qW333lx1Bve/gZtaGW8c0mpFY+7ROTxlTzpv59HGIoVBRTunBchbHDshCp67JZW5Q+dTU97pdw/x28n0eKsIf8BtbvoICXZmvkaLVBi2zlf7p3DjhMvaM4zmBjHe2BCWW91xEv5Ek6uDXepITzMYu792hoB6LtfiMnU8CVCxq555jK9qrdM0wSjyOY7p5mpaZGE/qspuRPqU8k9j5qLJ3iFis8IpMxCf6OMSXD8zNY5LJnqPujFj3Hi64SM4KeIGUspaXVx2B4FSzgdEkN1vEWmDOS1mDErnl6JrhXq9gkiOd1HmDdKguosRz7fhDTUcaRhMsdnq2HXNzyFQcgbi3
 r9O0qUk2
 sfcWPCq6YyBDxnTMPY7bItesGceTdNIHOdHnM+VAyowj2D8s86X+9cAYx4hTWGDU4kfjLrSpV5/0P9DDFzJR2TMUoMFpnKnM2hP+Y2BrulHAz5c1FaSbfSvGa+Y7rcFMdRAItVIXbjTWifpWroXBHA91HYV//5hgWNwj2ZQIiQK37bNscjay+TNWtqwvZeBTUYi4A7R+/PoMEjrjJbhQiX3R7wMPI0qKEDwftGXOfiQHyWv/r7rXzMvmnlcyzVwewbEZbQPWIvHfdRhvXuJCrRc53shjRefsDqRXeaubdR8xvYJzUD0JeLqJMwBXXccTTQaVcmDAQDxgvCq0rWgPCUpCnO0rLVh8dA91k3jiPtp3S7kmRzEyOfSxs4cbLDCzfPo1nb9jIpNA2UDLRLLW3kUxTBay51scNMhpl5yuJzQXmQIUIkKnZ5DME7PRkBRMuCHjFIjte/dMyj6Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In idr_get_next(), if the returned id from idr_get_next_ul() is greater
than INT_MAX, the function issues a warning and returns NULL without
updating the *nextid pointer. This causes a soft lockup for any caller
iterating over an IDR (e.g. via idr_for_each_entry) because they will
receive NULL, fail to advance their index, and repeatedly query the same
state forever.

Fix this by setting *nextid to INT_MAX when the bounds check fails,
ensuring the caller's iteration will terminate.

Also update the idr_get_next() test case in the radix-tree test suite
to expect INT_MAX instead of 0 when hitting this condition.

Signed-off-by: Josh Law <objecting@objecting.org>
---
 lib/idr.c                           | 4 +++-
 tools/testing/radix-tree/idr-test.c | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index f25bd2b9e9a4..07098eb4ddc3 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -268,8 +268,10 @@ void *idr_get_next(struct idr *idr, int *nextid)
 	unsigned long id = *nextid;
 	void *entry = idr_get_next_ul(idr, &id);
 
-	if (WARN_ON_ONCE(id > INT_MAX))
+	if (WARN_ON_ONCE(id > INT_MAX)) {
+		*nextid = INT_MAX;
 		return NULL;
+	}
 	*nextid = id;
 	return entry;
 }
diff --git a/tools/testing/radix-tree/idr-test.c b/tools/testing/radix-tree/idr-test.c
index 945144e98507..bf6a0da6a50a 100644
--- a/tools/testing/radix-tree/idr-test.c
+++ b/tools/testing/radix-tree/idr-test.c
@@ -213,7 +213,7 @@ void idr_u32_test1(struct idr *idr, u32 handle)
 	ptr = idr_get_next(idr, &sid);
 	if (id > INT_MAX) {
 		BUG_ON(ptr != NULL);
-		BUG_ON(sid != 0);
+		BUG_ON(sid != INT_MAX);
 	} else {
 		BUG_ON(ptr != DUMMY_PTR);
 		BUG_ON(sid != id);
-- 
2.34.1


