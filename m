Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EE37C5DF80
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 09:24:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FE316B0172; Tue, 18 Aug 2026 05:24:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D6296B0173; Tue, 18 Aug 2026 05:24:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB93D6B0174; Tue, 18 Aug 2026 05:24:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BFFE16B0172
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:24:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3111B120B8D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:24:54 +0000 (UTC)
X-FDA: 85113855708.10.19164A0
Received: from mail-pf1-f194.google.com (mail-pf1-f194.google.com [209.85.210.194])
	by imf04.hostedemail.com (Postfix) with ESMTP id 63CB340004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:24:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CnemNMi0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.210.194 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787045092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9v55YoKHog4sYMlVLVJ4eD+dGmtcRqfX1CYvFqTElOI=;
	b=OHmYzRIZXFr6DTHWd0sb6qh7xoru1+IL5lpVVVMgmbRvz4ItcDjWVLQ4wfDF6uu+9Y1fPg
	6Xm3k+nfZ8OqzmEAkChypJ+HXUjfZS5ETfd0/DjZhKT934nFolKDuBeERP8OXhnyzAwnIU
	lkc+zsC62+z6KiYFZriGT1UflOoSHdM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CnemNMi0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.210.194 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787045092;
	b=IYmM2lcNPsTtf61dpFdJEbLg+1kIiyEFcoEiSYWtHdYZuEf88BgBcDiMhq7hmQjfIA8gkD
	C1ZKig6/IkDQByLoHIMe3JWqYY1g4hNp//QxJjzk3jAJbDqPtQvk/zNESdrZhXyQm7YZTO
	Y/5u6laEX3FOTuG2266BArP+Cujd7wE=
Received: by mail-pf1-f194.google.com with SMTP id d2e1a72fcca58-84a2c90e383so619626b3a.0
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787045091; x=1787649891; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9v55YoKHog4sYMlVLVJ4eD+dGmtcRqfX1CYvFqTElOI=;
        b=CnemNMi0YYlho+zXGIMJud1wkd67Ho4LNo0ElQXWxncPdvTJ3arDmOdRzZv+IH3dsl
         VbnL7+XCJQnZh1/chtcy14IR4ZKrsEkGX7lW11ZMiM/CIxoFpMGasVE1PKfsTZC0kl8H
         bdQjdUA+yMsSczEfurxt8RtutO8JOhQtAkNU5nBUbHC9pEoSDBzMXnfxEKJ1aVrMDOUi
         UXED02oe3Li7OdjGZcO1ucM34KSbhVVlStlp8QDl0qFhW6s5JBSDLICQnOm1SmcIxoTV
         5K1IFAJGROFcum/jOfhBpDsgdVyIhc78WA9Sdh8bVcRA6VZm/Yu6M/eg8sPuxpy8vWNV
         vX6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787045091; x=1787649891;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9v55YoKHog4sYMlVLVJ4eD+dGmtcRqfX1CYvFqTElOI=;
        b=aJyUVEjsNx7bXFtSGSOjYCtFrJbG9FB+U8n3NKAw/TlMcqnIRablDh6q5ySehKJZ6W
         j0mZujBv8aET17UrZN8jdBhpQwB89l5gidl3lWt1Fv2z6+ZlKY6xGTUsWnfXz4qTayW6
         u/x55WaB8iH+zeHXndzOIjOs0fwUG2dJIpnxECbjSX/EUcYFfA3US53tIjjTvl2MntPM
         6NbjFLx1y22iZ47L3ROTHht0VLdaVlQ4CyN6c4Bf9T7BRdl4er9vfS9/Ryflc2cZMzKs
         e+mSg/Mt9tu+SRdoTubuZTTtu6sw5n1sMrMjoF3tq5jyYtVKTPkywmwp81qezgB39yGE
         4Vzg==
X-Forwarded-Encrypted: i=1; AHgh+RqTOC6IE5WaU2znbZwlVWJzq1ZdnfILLJUSeHG6t+effgzQMxJKhTWsRB2uUtbkByonvDLGGa9z2A==@kvack.org
X-Gm-Message-State: AOJu0Yyw4Q6xqC8RhibDAIcWyifBM9A611AyojaO8uSvc2qhBUxYStpM
	w8uMpFSp+huvfqFZwdxbTPGRRW52vBJHHw41VkoQxypB5vxVZadhOga1
X-Gm-Gg: AR+sD138o3qQaI2Ir8VEG1sGRCNXNpvmWmR3v8XSC8s2Sm3dx6MnUSt22KHNUiOEt/5
	T58Jnj/uefw5M092utVKhREPrE3dmlqsj2woK82H+1zeSVuMMpAESe0Yhcm57IHMRyTwgPAaKE9
	iApPjTZ8C3J4DaXc6dTa33MsYKhEDrhh7V5yTntm6x66KXexfA4z2u3n6QuPE1ljlaSXAh/ZwG+
	gsAwZ+kXd20nXdMEMYK1p5ttB73O9RWzTRMDOuGEXzknQxqyAyeB/t1IjGGUS8DpNjnyw2A5CeN
	VwNvVhZiN0C9zJP8PxB8x70XjTBANbQAWx9Z/QDRjTXMg2v4pQ4GGEUzERwj0IKx/j9KZ3R96H5
	k5G6jTXImKN8XmUQdoanhmhw0McgWrRq0pedU9RzjPKDxTmrgkn4+Ej37B0O9dqBaPgleLEeGfj
	INsjnhY3DHWXtplMlcZgz3akt0lD1ioeFkpClh/3kvhlOCCS2xsM2Pw1nX3JWKMgAt5jTIV7OM5
	pyqx9XE9W0=
X-Received: by 2002:a05:6a00:1d96:b0:836:6f2e:bb6d with SMTP id d2e1a72fcca58-851bc3cce42mr4379051b3a.14.1787045091103;
        Tue, 18 Aug 2026 02:24:51 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc13c036c50sm1855975a12.26.2026.08.18.02.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 02:24:50 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: robh@kernel.org,
	saravanak@kernel.org,
	rppt@kernel.org,
	m.szyprowski@samsung.com,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: akpm@linux-foundation.org
Subject: [PATCH v2 5/5] of: reserved_mem: retain static no-map memory on init failure
Date: Tue, 18 Aug 2026 17:24:20 +0800
Message-ID: <20260818092420.2859026-6-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260818092420.2859026-1-chenwandun1@gmail.com>
References: <20260818092420.2859026-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 63CB340004
X-Rspamd-Server: rspam07
X-Stat-Signature: gn3s7irz98kbdzqoaypiyo1kwxyo7whf
X-HE-Tag: 1787045092-336740
X-HE-Meta: U2FsdGVkX1/Oo2qtQ0KdiOauqeJWyUIZis8cvnYJHk4PQzlMVZehZSsiHo5XpWl8HcuOW9+S91UgveHsnXlGAglF7Pspr/yXglz/I53Y3TOzAZbkU7uZ5k7xNyDMOJ3GsNcdRjAb71ca6awdD+9jaLzj7D4/vlw8kDxJf0Vl9P02PhNIh4p+yUJrZa8KMkrWim2Ce9MoSpmQGN8ZsIDA7lcZgpEBNa5VjOmgE3tlpX1weyIerh9W9qIkk8REmyjQpaByBa+eLdd0fcuyNIzBSJ/7rdVaiM9pwlWPBTFPYqPkmFbkZw4/LE94sDiyKXhRs4ljHZOAvyvM8DOmjbCw9+oEgj/gHv2E0ZwIhI/mtA2PDgz1/gnYTXaCwb7qHaSDqXVnuKlzuN7YUv/FpUf8/rlizXiuUHFycScc/y6nnnaT/nqvjc3wxM70iMOYfexPtzERMFaYI50sHTG+F96iAt/+/PpTf2dDHpHJb1fHZE9xiGjplZ6OnxtNEdVlHOeVnF0x9dN0fX7EoW0/2NSkTdZgjYsp/mehcrC9mbYv2VyvQ7HqNyw2zXsWEZmd4mx0weOF5AlkoYA+SUc31Q7SRDDk1QAlDuDUU1ziLT/dgNCjn86PNjpgxXLUMSwyP2N7iqAapErPgUNxgO3xGnF3gO3Ev2K2Zcef2MsADsBmRz8Trp1Xub+rgSGoLjKm7+CA+H9b2WP4y2cT7ET1DZH6YNlL5Oh3J9kJ4YtzTR5xs2ILBbr5C4pv7K1mrrBzyG6QcaH9Q6HgPkwkYVm+F1p7kEA8sqaeJAKNNM4CKiiO2va83FhUnRyJKutLEASxs2DTDiOEtMJXSMutIMAHg/ymglu1Y8nOsHi1vGe9y6MT1GNsWYq5OV94pq7l5ZgWs3S1dUkxPpV9VkcGyLw74BU/a+vma+uaITLP3TI1H/nRjLqh25SYuLut9R29qIPTuqs+Xvik08jw2Iir6bMCadw
 pejjsYae
 TuYVGfzQLxxzwooY6qUNK8ELS7Y+g48kyVnCQyC48iUgLM3sOvFZI4TwJqhQ67aiyobirPzp13LIcHz3OuB1oSHup0HusGmYnK45+qX38tB9N+I7DwTGoVpT0TTP8iZ43yGM82eDrwRfFK0YmayzNLgsgYZ+vVRIQTPJ1uQuI7i+lWGIqrar+iUVu2Mzqpbp0Q6242FCAYM9TxsdsllQSdcsT2JNHM35+J46aqrKfMWgQCqngeSH2mnAkFXFMoW94XcJ+wbpp71/oEKLjWsk444bmEDM0y6WbHQKPEIQadGW6xOlXZo//EFWEwzK1ElkNVkuDZrx1981Ix52bURTTH/MAnsWSI0QNXr5fApmM/n+nXr4liBarwzFsyJj0tKl209QZgnNX3JhcL1bH4cOZZ4QXMN1fN9ckDh61UDmoVm+jzkqINAmc4I2ycpezmeHeix7X/W3b37/JOmpL3kfZsH3HVg4iTLEgZNPcJU+SzRTWDiOi2fv26a85LiOWKrVRsi9zmqETxarcJ8rcxD5VzRY19QP6IHJYqvmj+/EeTfpy5nUCtZ5mRLk9eg2ZhzK6rCKaLrLFwngMlwE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

Static no-map reserved-memory regions are initialized after paging_init().
If initialization fails, MEMBLOCK_NOMAP would be cleared, and the memory
is available to the buddy allocator even though it was excluded from the
kernel linear mapping.

Clear MEMBLOCK_NOMAP only for dynamically allocated regions, which are
initialized before paging_init() and can safely be made available to the
kernel linear mapping.

Sashiko found this issue in [1].

Fixes: 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved memory regions are processed")
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Link: https://sashiko.dev/#/message/20260814090305.4C8741F00A3D%40smtp.kernel.org [1]
---
 drivers/of/of_reserved_mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index ac5db19dcc93..0090fa86dd10 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -709,7 +709,7 @@ static void __init fdt_init_reserved_mem_node(unsigned long node, const char *un
 		pr_info("node %s compatible matching fail\n", rmem->name);
 		rmem->name = NULL;
 
-		if (nomap)
+		if (dynamic && nomap)
 			memblock_clear_nomap(rmem->base, rmem->size);
 
 		if (dynamic || !nomap)
-- 
2.43.0


