Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CCD7CCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 12:20:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 840E68E0010; Tue,  7 Oct 2025 08:20:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A28A8E0005; Tue,  7 Oct 2025 08:20:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 532608E0010; Tue,  7 Oct 2025 08:20:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3D24B8E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 08:20:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D2707137FF9
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:20:43 +0000 (UTC)
X-FDA: 83971226766.23.00E3BF2
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf24.hostedemail.com (Postfix) with ESMTP id D9827180005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:20:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FsQud3d6;
	spf=pass (imf24.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759839642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6fNdEfsbjEkSdVOKy7pPxlOS+w8ubFh5YKBkVpFvsGU=;
	b=yTmQsoXJuUxEKbks77QhGaE5k293XxQOVEcvqL6AJXPqzGqDqo5rcyFMsSq4p7T6ra4Xpy
	YGELHdpsVTO56zwMO4MAhT0dajv8IsPgFAbtXBbZdpZIGZfjJunPtFIxkYeFhA10PDSdUk
	D2zspYjYl8Z8wDZgT9nwffFg9EYT17o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FsQud3d6;
	spf=pass (imf24.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759839642; a=rsa-sha256;
	cv=none;
	b=qDStyecb8jPMKQDJVFhfp9tFqnDz9Lg5IU9BC7qDnqIZhnHmF3UghaQRJBm3d+S4Y8zD0C
	wMRW0RmzH6N7n81I5jiv+2+PsM6lCotR3TXOfePGBpyXx+lwjurQvivcpOknYPr7Yow28s
	79KMwVViFmJZ04fTPNpbcpCuGN1zrCc=
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-58d29830058so5991415e87.0
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 05:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759839640; x=1760444440; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6fNdEfsbjEkSdVOKy7pPxlOS+w8ubFh5YKBkVpFvsGU=;
        b=FsQud3d6sAmolTUF55baIdvovKBVmO2LZ+Uxdmir1pBPPOwIazgx0/wELwrmZnaoEh
         LhYueLaJC/05droP86A7+UnSNCQIvG3UcoNZGWw7f3deJDc2xJVPemqip6fUCxLVoM0q
         WwyckPg6oWlvTFaPAVyRVFBib3CNLeOIdcapFS6yO7iI0O9qzsviCSutzGEnB4BxELw1
         bvQLeg1c47VOLDS8rqZosbSc3L2mlNPvn3GwY6OLaOc/yQHLb6YhjmQdxXnmHVBUznZk
         ZplVEjS4XozcYSMFu30jAQtgSuigIHuoyffgdQnSor5o/qUm3EZWiwfVzJ8JjcizHF9+
         6fZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759839640; x=1760444440;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6fNdEfsbjEkSdVOKy7pPxlOS+w8ubFh5YKBkVpFvsGU=;
        b=UTAWwa08vfWOwyWGioPqBagWQFDOObN9A67jeWYQPp31MGpkHlN0uRQZZ+bvL/kfE7
         jZRTU7OIIn/7PDmveJrJWbOLPUX7VKU5+I+1td+Jbbo1pgOL3obcCRO+/R+2O1SkboOD
         JWKjK3dQOuFhLQ7iICT9MikqaB2szzrQtM5gXBIXHS/kLNdew8HU1Jafq8DXe24IRHQy
         qfJPm8N5WC736J//rlrY7amOIYF+edZSSEttA4/kdNNgaTjGhQuwD2VsJclqSqtjtdck
         b2LlM6E8xwoqDt+RsKjkfdHXBhOwe+gKQBOh8c9DYNcx/x5wpN+WlN7HEN7d961rvpSd
         ILbg==
X-Gm-Message-State: AOJu0YxZDLnXrl+ZXyBynVibYUTGa4RUEj1Rp9mLJmpe1gcgWVRukDBe
	8xc6W66KDmcRPRxgP4xqD5+ne+8bw2CNmuUQSuTbUUUt+DxJv9WKx9Y9c3LpS0nk
X-Gm-Gg: ASbGncsjam2qxMe8+tdntvoyQZYObjVw9ikz7PHCpU0t4N3684B+40PBRaB/xMVD2xm
	y4NQzHHfj+F5WN8eFWCYOFE61X6MEErPIGyM30fZQT+mnIHoYN2JqAe0D6dHX87YFFOlyz9tH69
	0G9NXOhJBNsim7MTZBjuygcgC01iHgkVxnf72dpOzZPntAVU/4b4YBxa8hscguV4PK9V94tAqJR
	zBBHCl8Jtko3GdcHGP1ww3cnHM51j0IS7MivVk1mCcYHW10N0kNj08slbESNnOD5kD3WV5x4eDN
	Jc+H0qs07XZPfxoUGzEPvPcAdWfJBKbQYfoQwMHSQT03BYuwD9Mx0bjJAjIb832YwDlW6q3q45k
	cr/mKLDI9fwNq4bUm3RkoSf3Zzu+tKZhoGI3k+rhG
X-Google-Smtp-Source: AGHT+IEiEq8/PRMLU22U8tMd2sr9kO2YecTFI/gyGlkW1+LEry1NgULscngcTZ0ZEHQCDOWqZ/Rlig==
X-Received: by 2002:a05:6512:23aa:b0:587:7f2d:2577 with SMTP id 2adb3069b0e04-58cbc39a817mr5138049e87.43.1759839640112;
        Tue, 07 Oct 2025 05:20:40 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-58b01141151sm6061947e87.59.2025.10.07.05.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 05:20:39 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: [PATCH v4 01/10] lib/test_vmalloc: add no_block_alloc_test case
Date: Tue,  7 Oct 2025 14:20:26 +0200
Message-ID: <20251007122035.56347-2-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251007122035.56347-1-urezki@gmail.com>
References: <20251007122035.56347-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D9827180005
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: iosk596sycpqdfimsu6xj3ebosmiyxod
X-HE-Tag: 1759839641-860104
X-HE-Meta: U2FsdGVkX1+MFMQ8JtoHGQOQhJWezfR01l6bHRl4zWVL1utiZW3M/TPPiXhCtE1wphOvNLMKZeAm7enpCKBDcr/eDAZHVNK+UVDaYBPXh8hqLAdySXOaMk0qMgb9FjK1pVyOo63OJ8454VNAGGdTTmlgTSll2oW0Jhgk6t+LG0ce3Y5J1qUP3J9ZfBX9oVPVH389Wr09SPl5TnwNXni76ZhQNfq97dwCHAyqoTunHu3S39sqTkbOU3AMpeFwhgMtd8YYC32QyxNUztZAhUHbaHdnzTtCulDXEdqa8l5LD8qD0ns/EJoWmtxfrhmtJUNN/YJvJZvfoPp8rLkived5RD5v+TdCbyB8mEGgmAQyj5a+vzC2JLE/EdmJwD/hxoLBqHOVryCFXe29JQLm2enHK0sejZM7NlmVpSjKeryglxTwbmUNjaqo2VVtjvYSsy897vUbv019znepPYBxoVYh2UfTpy/vyT4PhSbeUsXFsOn6EI1dmO+sPVBofx0wVBd8QlhuLEor5fNBVUw7qMKi3AgHyKWC2Z/Ae3WyiEz19HlUlkhzvJXzhmvjSV1F2yp6XUPWXftLZyYGcUvmCMgK+zvDYGnIyXflIP/LhZdTooJye/bQBKKwRH+kuEsbpDIh9lDYf5BN+Mi+CF5RRdOV3DQ3718gVWv4zvKFaSRpEMxQjIH/6rYgqJXoFglF3sIEbxlPWvgo7pFtRVFCZPLKd41ZnHjJTC6yzjN3yQT2MSUe2ynhcxcrx/wMKGOE7qBcNNqHO/aL3gojy4KgcHkfWjWpEI35c8t08rNi+olny4rBi3ZyTfTifNte+CfCOKHGUHg7rZw1b+XXAdXUy+ngl4ZeFUNcLq8fbAbbpWjcmr/57S3BHnn9+c1yJtEOVQjH+USLKWp7rYKWgPa2E1YlLMAA2C7JaU9mEfxGYDnP4EFEXzr+INr717vLWD06QwGUDfrRrsxt2EenJErmHlD
 kex6TlM0
 I/zxyNrIfTtxHjIPPKlDYrelWppH48rlCgWy970rqdPxcFpLcncMok15c8V1R+PJCvsYDwc4nb2EhtlScmECxSGi6DQkTabV7x5UD7RSnVY3kb2mePjoME1yCqsoJLZcFNIZeGgHmYMUCzdsJG5dacDJIVDgb/7C7JvpGVQvuUc3eAyje8kMO88g2dCEHw0z1CeY1FcgzQwCwLoRfSmKKtamb0kBDjBkBlTyNZvjdS+picziKkQvRWHrTDjBaz0YKjt2Orqm+qS7Uj3PDpvnoriC8py5xNslbLVusLHinPK0xtj4O9IGSXmc2v6OWMHJiWQvG2/odeSdyW7H5A6OQBTBj0QSvhY30YZd2ZkAWzt8q+Ih4B0xOZT7mc9SJjmMMR04cytWfYtUyyts4nkq2GUDO//lC7pyIYPAAdyJOCZuHd/jGPpyLKoTAXvY+cS0O7ZzGcll3t0EZd3T3nCH5Lj9Jn928S4wdMEJrQ2/ftvr5I7TPgs2V+pQiGQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new test case "no_block_alloc_test" that verifies
non-blocking allocations using __vmalloc() with GFP_ATOMIC and
GFP_NOWAIT flags.

It is recommended to build kernel with CONFIG_DEBUG_ATOMIC_SLEEP
enabled to help catch "sleeping while atomic" issues. This test
ensures that memory allocation logic under atomic constraints
does not inadvertently sleep.

Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 lib/test_vmalloc.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/lib/test_vmalloc.c b/lib/test_vmalloc.c
index 2815658ccc37..aae5f4910aff 100644
--- a/lib/test_vmalloc.c
+++ b/lib/test_vmalloc.c
@@ -54,6 +54,7 @@ __param(int, run_test_mask, 7,
 		"\t\tid: 256,  name: kvfree_rcu_1_arg_vmalloc_test\n"
 		"\t\tid: 512,  name: kvfree_rcu_2_arg_vmalloc_test\n"
 		"\t\tid: 1024, name: vm_map_ram_test\n"
+		"\t\tid: 2048, name: no_block_alloc_test\n"
 		/* Add a new test case description here. */
 );
 
@@ -283,6 +284,30 @@ static int fix_size_alloc_test(void)
 	return 0;
 }
 
+static int no_block_alloc_test(void)
+{
+	void *ptr;
+	int i;
+
+	for (i = 0; i < test_loop_count; i++) {
+		bool use_atomic = !!(get_random_u8() % 2);
+		gfp_t gfp = use_atomic ? GFP_ATOMIC : GFP_NOWAIT;
+		unsigned long size = (nr_pages > 0 ? nr_pages : 1) * PAGE_SIZE;
+
+		preempt_disable();
+		ptr = __vmalloc(size, gfp);
+		preempt_enable();
+
+		if (!ptr)
+			return -1;
+
+		*((__u8 *)ptr) = 0;
+		vfree(ptr);
+	}
+
+	return 0;
+}
+
 static int
 pcpu_alloc_test(void)
 {
@@ -411,6 +436,7 @@ static struct test_case_desc test_case_array[] = {
 	{ "kvfree_rcu_1_arg_vmalloc_test", kvfree_rcu_1_arg_vmalloc_test, },
 	{ "kvfree_rcu_2_arg_vmalloc_test", kvfree_rcu_2_arg_vmalloc_test, },
 	{ "vm_map_ram_test", vm_map_ram_test, },
+	{ "no_block_alloc_test", no_block_alloc_test, true },
 	/* Add a new test case here. */
 };
 
-- 
2.47.3


