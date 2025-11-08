Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 365BACCFA13
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 11:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E26A68E0006; Sat,  8 Nov 2025 06:54:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFE618E0003; Sat,  8 Nov 2025 06:54:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3B2D8E0006; Sat,  8 Nov 2025 06:54:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C05858E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 06:54:06 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 69317140738
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 11:54:06 +0000 (UTC)
X-FDA: 84087281292.12.569C50C
Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	by imf10.hostedemail.com (Postfix) with ESMTP id 347D8C0009
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 11:54:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of make24@iscas.ac.cn designates 159.226.251.84 as permitted sender) smtp.mailfrom=make24@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762602844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=y/8z7UpVmFAEnS9Sp+7GFbGIz9e6UeUzP19OGDsbKaY=;
	b=0ERCENKU9nMbjcCq6rJN9ctMSaZXPKYgvrMZMb7SYbobc+QQ2Q1t511FFMgAkFSF528Way
	33AYhs/Db/mr2Q8LkFszu3vGttyiKeUN40aG8y9lQG91QOMd8/DuJzkQCddCjS4kikVZDF
	GURL9/nSbeqIcFOzer3T/BvTIJJB5TE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762602844; a=rsa-sha256;
	cv=none;
	b=uWABcheAPI1nwNL4fB2lx1T7VdX8N/I9GqqRTj5dAhzCsqrr4uCxPNN6JsnuO++R8Awfeq
	st2UbwurhPrNGWG/cfE+4aN6J8gcHBnbgGX9YwXZefMeCWvFwiZU5RrDAk3vAtb3IhZtg4
	ZoBpeWTZNanlKaifd2YZvno5CzckcEg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of make24@iscas.ac.cn designates 159.226.251.84 as permitted sender) smtp.mailfrom=make24@iscas.ac.cn;
	dmarc=none
Received: from localhost.localdomain (unknown [202.112.113.212])
	by APP-05 (Coremail) with SMTP id zQCowAD3YvFLLw9pipgGAg--.40529S2;
	Sat, 08 Nov 2025 19:53:53 +0800 (CST)
From: Ma Ke <make24@iscas.ac.cn>
To: akpm@linux-foundation.org,
	jgg@ziepe.ca,
	leon@kernel.org,
	jhubbard@nvidia.com,
	mpenttil@redhat.com
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Ma Ke <make24@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] mm/hmm/test: Fix error handling in dmirror_device_init
Date: Sat,  8 Nov 2025 19:53:46 +0800
Message-Id: <20251108115346.6368-1-make24@iscas.ac.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID:zQCowAD3YvFLLw9pipgGAg--.40529S2
X-Coremail-Antispam: 1UD129KBjvJXoW7AF17Jr1ktw4rXryfJFW5Jrb_yoW8Xw1fpF
	1UJas0kryUGrn3Gr18Zr48Ww1UKr9Yywn5Aw1UG34IgrW3XryYqry8Gw4Fqw1FkrWkJF15
	XFWaq3Z5AF1UAFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9m14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IE
	rcIFxwCY1x0262kKe7AKxVWUtVW8ZwCY02Avz4vE14v_Gw4l42xK82IYc2Ij64vIr41l4I
	8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AK
	xVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcV
	AFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8I
	cIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r
	1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JU6GQhUUUUU=
X-Originating-IP: [202.112.113.212]
X-CM-SenderInfo: ppdnvj2u6l2u1dvotugofq/
X-Stat-Signature: tbk1f94sromjc3w8twjsyw5d8hhcxsyx
X-Rspam-User: 
X-Rspamd-Queue-Id: 347D8C0009
X-Rspamd-Server: rspam01
X-HE-Tag: 1762602842-849254
X-HE-Meta: U2FsdGVkX18EMSmV9ABZ4MQkzcfxSFppcwPLEN03mfJO2jsPpSHyxFgU4dRsDMQQyQokfNbE41fJCQrjuQydNe31SY0LD9A0RPFcMNroxA5BHDtZIBzoqVC2wuLPjjD1z4i4gpXcRWnro4QMCm37dtpX3fIhNNcruaIz2ZkMAYvHccwSGScdzqd8kHSmD+uE4BcWtRFQCA441PY+JxUzM3IJJIAX0dO/u9YkcYz83peRiayMoapfdy2quIwCBLgh6udJ+G9m0Li9aibMymC/Ybxre62VR2SL+20BjIvl2zuOtgY6apQk+C/UJn2f1F53/kd5yFm2QgejPruwFmq5AxJx0lQgi1w9+bV6gdBagOpD7iWKiAAIu4OpkFvwiLp37mFVjyUEAuSVQdjCUHpFBNZi/RYj/39P6ZruaLLRPzuKUEPJzF8C/UWB+INMseaEJuBA7eqKIQXAH4WiiUZ0QFtQu33ZNeZQr5Dst3h0Fw5Aqi/tVKD7AiuefkdqQj+g/x3gHn17qYnXgJs96d+vWlvx1hpihIfsJuEsvLquIvp/5I3z+wvVZPbL2z51xy5YvExlAPEnkgZc3WyFT3XA9kHim4Obe9OvFAMEriaLa7BZjE74wL+koy9H9wC/g2dBlbGgbPsuSUFedOVDVICdb/lbBCmw4GScVJM+MU1XcAQ8fi8wFv2uBQSuP9FeTUOsRzQdfnfvCQcJKC6e9PRravls1NRCBJ9F+UpEX6e5V25ePphEgj2To6V7wtTAp24Bc2zGAsoJKqCnQT+zfHvKQMOQgzOcx1ONsY0Yr4be0yb+d+vpb9Al+IZ/I4fB8RkP99FQOVcHt7G1C4A5P/d/2s+lZhs/WkIrA7GclWa/M7kY/Q4k+kE/KNnQZ1TGXNjG8+sDyQ5PiNENmgGOAgCDEHGdmTIoH8vWo5ig3KIjRB9A1ZSDAgDV/dbHp/tj75k8uRYD11piNi8flXp1ZPc
 QIVaXN+1
 3wRtZivMpyetAjcyiFR+m+wY8UA3HgD1OISKReTwXrm7jN0DunJh8mp2auYiN6KJU65G49KOe+0307rEVg68vP5q1DrBamXpTYsdiUXUpvVw9PPNsVT4K7H6C55rjRDJii+aqW5MYv7NCdv+Wc0zr7Kv7W6EsZ9zbtLJIH7OXfnNs05pgf8/CByB1VxNdGsVPNIrN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

dmirror_device_init() calls device_initialize() which sets the device
reference count to 1, but fails to call put_device() when error occurs
after dev_set_name() or cdev_device_add() failures. This results in
memory leaks of struct device objects. Additionally,
dmirror_device_remove() lacks the final put_device() call to properly
release the device reference.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: 6a760f58c792 ("mm/hmm/test: use char dev with struct device to get device node")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
---
 lib/test_hmm.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 83e3d8208a54..5159fc36eea6 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1458,20 +1458,25 @@ static int dmirror_device_init(struct dmirror_device *mdevice, int id)
 
 	ret = dev_set_name(&mdevice->device, "hmm_dmirror%u", id);
 	if (ret)
-		return ret;
+		goto put_device;
 
 	ret = cdev_device_add(&mdevice->cdevice, &mdevice->device);
 	if (ret)
-		return ret;
+		goto put_device;
 
 	/* Build a list of free ZONE_DEVICE struct pages */
 	return dmirror_allocate_chunk(mdevice, NULL);
+
+put_device:
+	put_device(&mdevice->device);
+	return ret;
 }
 
 static void dmirror_device_remove(struct dmirror_device *mdevice)
 {
 	dmirror_device_remove_chunks(mdevice);
 	cdev_device_del(&mdevice->cdevice, &mdevice->device);
+	put_device(&mdevice->device);
 }
 
 static int __init hmm_dmirror_init(void)
-- 
2.17.1


