Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39D57CA0FED
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 19:34:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CAD48E00FC; Tue, 26 Aug 2025 15:34:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 254F88E00FB; Tue, 26 Aug 2025 15:34:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A80E8E00FC; Tue, 26 Aug 2025 15:34:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EE0CC8E00FB
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:34:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BC8DA58057
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:34:00 +0000 (UTC)
X-FDA: 83819909040.20.7D3F76B
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf14.hostedemail.com (Postfix) with ESMTP id D62A3100009
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:33:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="DHY01n/G";
	spf=pass (imf14.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756236838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i+rwqTqsm/ZsZGDIt2sbK5HdEEIm0ZDAp49YtE2Ezew=;
	b=fGaHpnJUIyaEVz7qELwz2ckqrUzlSV2YkihEgFZHio+H/BiI01XvRp4Njd/wNEy/Vzanas
	LCt90NQufmZHF5iKHZdOd97sYEyr2cylTMr0ZIWG6yaw5FDuZSejCvznTFBhGTzFSKyilP
	Fx2IlzQZbzTdJfMl3P4wflNbdsxKj+s=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="DHY01n/G";
	spf=pass (imf14.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756236838; a=rsa-sha256;
	cv=none;
	b=Y1xQ4HxzttdzeyH+ltXhQPpV9mAJOwGJsLvS2tcbcFYdq5kdt29xN7PVuSllB2eaT74UtW
	a2mRiFAqGz+X/4Ne72XtaUDMnbrF7uGBwYPQ5E0TEQP3rjA/FMmaZPQUdRJMLs38Ft8kaZ
	k3+ewkPiOzAUossuwoPFkYY7P9r/9q8=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-771facea122so676769b3a.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756236837; x=1756841637; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i+rwqTqsm/ZsZGDIt2sbK5HdEEIm0ZDAp49YtE2Ezew=;
        b=DHY01n/Gz7CbVkXWICQGMKH0Cyoh1j169JVs21/4AOMjK5rcildBt1QTrZTD+u6Ufz
         EsqgELVkHaS8i9uIsg8X1+B9frLoSxikTnPHOfEk1/82qCw/xzCz6KthCvaHl+Jnr3I9
         M6hzrZyvOcmuhb3BS4knmgqXD44oh5riAJPJgAVbLwiXAAM5Mv3HYkO1/7hHplMDRCxY
         cmgK1U5f2p5MDZOmLKpaKjItm2z9GA8qlGZABNIFhCVQBVJlUL+b1He6GKmKk3RKnabd
         SujY+TaGCVohHwtpZSXeXEOv39nYvJP/LZr6OXgXPdgenB6UjQsL8RTKw5G1wBwbkcXX
         759w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756236837; x=1756841637;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i+rwqTqsm/ZsZGDIt2sbK5HdEEIm0ZDAp49YtE2Ezew=;
        b=d5tDYggfZIbgjinaEmundYK2Xj4XenDemafUWqEKLculzmKE37xDW8fPhBOr65eVnO
         WvxBbQsq+ZPptDRGSKhXs3U6ZprgiEm1ht0uW9swHwSkwcb1l4wXCnHaqgjxyg13bCoy
         KdBF8S3zr4bR0gPY1t1BKlTPJ7dE0pslioiYn7VbzweDUnq/wMe0TcE2YDZbDix/Zm2y
         R5p5qdiA/MlYPxy6dByNjW4uI+jTeTyIkQ3UXl/Y7ORIjMxIhxJojh2iIilOji0LAc9+
         1+6uWvWUB55lS5WhlHOR2Zxl5woNLFGZaFyxu1FA63o12Asw5divYBh4+bD31Xy4RmJn
         fQGw==
X-Gm-Message-State: AOJu0YxQM3ENxhX25lUZZFqHQ45G1686isjJpggFIGtESri+gN7bAsE+
	HmfqKQz296oJ54JKRb2cnu51bWvOoz9cilmodspV+kkKEZ8mnWraxg9UGzkLag==
X-Gm-Gg: ASbGnct76oHKO24m6/Zm0ZYNgfr0kavSeLENDIcsQVd0SRxgcrjD/T/9Fzo0tX/Q/pN
	SiT+jTJTIKeaYL9O6D7ZIDthcIE5VfXzBCTjrG3syMIdWxMbwEx1xs4Qf/1LaWfjA1B4DKK9lzA
	Y4+4Mfmyx+yfLHBYvbdhanB9sHK8SE7zq31/R7dJZcpbgovGB8fAtCxczhaZIa3hP/ObjJGVxbS
	4BQfzvRViWhiKH1k2autuwACIvz+R/3jSFQU0JTVQIqAQ5thEQIYIAgujqRcM+DCf3YhNazk9WC
	MgCWC1SOBl7JL/OgzaeFYExR7M+kCepYCyMs8EJq7O6rvCHzaBGjwjgxDym263aoV3tRKDBLe3z
	m/rSyL/KNNNb4WxYZDzOVZYUNTbCHkZcnpZCFJr04RzFimc/YwK+7JQ==
X-Google-Smtp-Source: AGHT+IFXNiHeLyR9ad6ENnhydukRYpHfL7W+c4d3otcDgB4qLzLTcun64OhpwzDFr6oUuvRj1X+e/Q==
X-Received: by 2002:a05:6a20:a124:b0:23d:6956:26e1 with SMTP id adf61e73a8af0-24340d72883mr23281699637.46.1756236837321;
        Tue, 26 Aug 2025 12:33:57 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-7705647e03esm8054053b3a.59.2025.08.26.12.33.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 12:33:56 -0700 (PDT)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH 2/7] aoe: Stop calling page_address() in free_page()
Date: Tue, 26 Aug 2025 12:32:53 -0700
Message-ID: <20250826193258.902608-3-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250826193258.902608-1-vishal.moola@gmail.com>
References: <20250826193258.902608-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D62A3100009
X-Stat-Signature: m7go9xn5uoxrqxta9ntihpphhyz9d7e5
X-Rspam-User: 
X-HE-Tag: 1756236838-917968
X-HE-Meta: U2FsdGVkX19jEEmD7u4WQH/zgpB8QvFkozd39WdnD1gVNls8d4UgdhZpe474a1IzbWW+IvNR5iC0K3bDJfSp2IcHZvcgCw3KrsknIEfBNJixa5xiumzN0O9RIVKbYFxSw3+xuyFkd3rTbEwqo7WH1xhhXx5CtaevfVtZ00bb5Ij/CKL2n25NBY+5xu89kUZSjTP7Qg7UZ0LIQwaOYDcF3mdFfcxzQZzujtXfdRxB0WilkBpJQiPS4RIW/VIA0Ju7/oA6ELiresO0qA5mi17NpiJqxZLtbYLLNtqxYyudDF7gk+bP2Bb7eQZBfqLn4QISZa2XQYkwq5VPhj9ZGQXZtQrjA0T3m3H8HBv4MWX9YAY5AQfQDiQDmxMCEzvW2wEGb2+IEWgnpHKSUP0pJYoNCE973h6ywVBstW3Ducize4o0wcm/lCTAytMupz0p4tQ5H5/jYdBG0Yeqt8KnuBLbRkW4K7TFO/q4ZQ8kXjjOwZObQ+4joOaYW4WAlxKLuMg+b1wy2kZcCa74LWt5NXC2gxEShTWTxW/Adpsi+wBug7/nkCOfbXshHPlTJvyK+WQZrZoPL4+T7QIknRb+PGA4TNUmznJt8klb0A3rWpWD6Nuhb8oMrO2KthwXle74qjibvWNDT8qBYpC/tWOmOAgeK0VLgywC5PZ0RSxOwCcwnEZry2lAVwmW7kSEvgeczLWaOiC/Qx1UzM0QsZP3xoAbWFVvTLLzdRHI+ZyMjqDIJNb25/Yv2c80LkeKFWTSu5PdqNGHKIQZaNPmXfH+r4sZ8KL0SeUhxP7vcU7U2+xh3mQH+HnZRxNh6DRCQslcpv83BjUF36L5mrT8vC+x9wKsAbU2LTcE7kM6dQgZaXW/yEBQKkTxElV/Qdgv77T/d3cdUJPF9CkhWuPQeJVAsLdHKoay8WVeH8LdnXPWavVSarFdUf82k02P9qc9CD3kRvMi0BBT4CzuG4P6vUKD6G/
 rLBvb+iW
 k0H8+xgxAtrSyo5lKa4UddrLob6WcOEbPFPFwUO6L63SZtTH99mbSDwwAomvEPocQ8tlVeAeLFCgmt+eF82iPL0tWX3mZScXqqFAlI2VzzFKuo/gAEnqIZVMChSdIRVVdYrQ5QfupVQex1iGYIhrYKjTgp7vGfjoZA9HG+WFiIRr+4Mms1+oQujP3XfnCp6ewY1V5r17n1rHfnuEPxf32Xd2sFiobXWUBCya0Dg0VOzoSEzFufW2fwKxA81z4hl40ZTTBSFn5OcRglwbiNCSWBM6MaHUvD47JhM7u9FYY1fDToRYsRkzWiSTISKMc9wbcbyros+vAM6S/Iaqm23vzrMVjzpnRXsY2mDimgPklZncf8/G8VHVKMIxTO76H8pFnb/gKRmaVgmDNKuoFsUGX0t2SH6HVuArqEwnjABqULvV9IL42k/StZmzFEmhGMTrI0lG5TOYBFJxI+2v4uLwRh5PlN0cXaudb8vrkbU5MLd8hDYZ9cqpPwjp82W083zHILawAE3wy4ejdhII=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

free_page() should be used when we only have a virtual address. We
should call __free_page() directly on our page instead.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 drivers/block/aoe/aoecmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 6298f8e271e3..a9affb7c264d 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -1761,6 +1761,6 @@ aoecmd_exit(void)
 	kfree(kts);
 	kfree(ktiowq);
 
-	free_page((unsigned long) page_address(empty_page));
+	__free_page(empty_page);
 	empty_page = NULL;
 }
-- 
2.51.0


