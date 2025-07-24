Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC480C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 13:56:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1170C6B02D2; Thu, 24 Jul 2025 09:56:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A14B8E007C; Thu, 24 Jul 2025 09:56:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E839A6B02D5; Thu, 24 Jul 2025 09:56:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D3AC66B02D2
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:56:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A2734B9404
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:33 +0000 (UTC)
X-FDA: 83699308266.04.65A572B
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf01.hostedemail.com (Postfix) with ESMTP id AB29B40007
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=U6JFdUlZ;
	spf=pass (imf01.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.54 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753365391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SReSPaHbR3saXb697Yp9wPF5rwCm4qBMUK6NGh7oWew=;
	b=ywQbp+ZIOgnpXRDk+YWd/obq38pbgd1WfKdrvIsiEH8AOGt+sfVLC60yxa5p2bO8FYiOMz
	q2TG9Vfkxi/Mjdi9hzW7veBy8FbjVa8OT37XWzIubBacLBGLO922QghaF+tSKytfBoUlhy
	1kBdgyRulOA/qNT/Baoxb7rZ4AG4C5k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753365391; a=rsa-sha256;
	cv=none;
	b=QnP5SclA7031RpTX/7xRrBjyKpXzd3c56pwf1bixACR4HCailAAYPx8RjCuRkahIsLimjJ
	xzcsgkAS//5V1zuQ7ECbPE+T6HGXv0vSB3bkGVwi5Fwo1wgrKT1DpOddFFXuwP80GlxWNU
	k12HPIvuIkHuwhCEenbWSPrfMQO4/vg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=U6JFdUlZ;
	spf=pass (imf01.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.54 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3a54700a46eso497423f8f.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753365390; x=1753970190; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SReSPaHbR3saXb697Yp9wPF5rwCm4qBMUK6NGh7oWew=;
        b=U6JFdUlZp/77pXyCNwtLdWR8kGXYGOmH+HHXiANoeXVE3DRoGr9cxH5aEAU3YZYEUS
         xhT0Gin/wiY3eanmseM8HR6jb67AgTMXnVl3atQJ2VFaIBfBX0BbneMU+kvAq4Q+WYEK
         YjmMQSIjcmxllTHoykgaV1Hx2jwokzkUir8vxId/8rEJESdQueG1x8IzLPf/6SkvEWPm
         LH7kAZDZcgMeBdczn1pL24XKMbDbUDc14mFZAnLwkMtmyOyImlsmN3WnDF+9R0iMgtwt
         lk2J79RC0DzxXStOQBQL5DWWcJ8HPk5nJNgvBXMpqoghBbvCGw+Xs41VJB7C8lpEUgTD
         Wkzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753365390; x=1753970190;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SReSPaHbR3saXb697Yp9wPF5rwCm4qBMUK6NGh7oWew=;
        b=lPbJ4R0SUF9E8E/eFFMdpNJ+SCXIqAQxhZhVGnJxqnXugr9WDwsvIGtO/X1/cszw9/
         huIn1HAQPUGnSWpZsHldFBNF4rdGCRrPMvjm0IaQUZ5VeTwOVlnr6j2jSRbJC1dUpWwG
         cSCY/LJ5Yn1lLMMvxEYwDBVKi4nGin7Jjy9gWET8OiWoqPZyxUK9ILkg6UIANhUloM5y
         HCb/py5BImhcmSvNLmADT/WUy7m1eo7DUhH3HwQUM2iN2rOGtZTUwDGblG6/qxzfruV7
         nCSzlW2DUoEEl0IU+lsxzhV7FErcotu75gZyz+ghDthhFhd9WG5TyaiX2QRFo+BQB29V
         IKhw==
X-Forwarded-Encrypted: i=1; AJvYcCU/MuaWYXWHg40/9inxLzxD0GcNfCLF6a58jqer3wgUvsL4NDU9xu0aOIQ4q6/lI+PwIcLIVUK0QA==@kvack.org
X-Gm-Message-State: AOJu0YzO1lj7BQnmgZz9tviGDCq2tiV2DTeNVMnAZnkrHcO68fggdVTu
	yXVw3DrTrVOlH4xTyGgfBETjr1E+E66/kjMSK55X4dr+Qj1a3SWA3C3mPPPPRFFgbbs=
X-Gm-Gg: ASbGncvsOLhrui89bQCJ0XxcP/NVput7Aty58Yh595ZcArFuVBik3wW6WY7tr9JVCXU
	9SgfR8rvwyex6qUC7OzBe5UffAeJ+wogksWByaCXfKhXecsC/T7Iykz7mUCbcxrlHdX0bLx6inK
	2e5wOv9gaw3XsyxFKEatmrc0UMROw1LgYBIG+xyAuQx9N4shiIXC3IX+LIPlnH8ropPWD70b/ys
	DbuyWXtSMihDTyH0vzJx+747d+7RcdpG8yVfAZdbfKHEmSz6w0Ln1zACNnV2BKRQ74/6jLDmnKp
	JCCht9pgoQki0IxyzktceR1v3yeSVy1++0519wq/2oX+iFXqHB8YtnSQUuFtftVHmV5JA1s/zlH
	Z9sOPVfa/0GnpOYxmhhZun4gLcQ6ncieI5C/n+j8A64NVd2Q4yzPbKFJrxjlqbT47Q76jbPi1d7
	rQsCXOPWT+VR71
X-Google-Smtp-Source: AGHT+IE5OpzTZyLft1dF8PAF1zWD0A9y1GJkIKlmiY5JcqmC3+aHq3C9hKZiU8MWr3uj6ilv3EjyHA==
X-Received: by 2002:a05:6000:2c0c:b0:3b6:333:256f with SMTP id ffacd0b85a97d-3b768f27e15mr5395112f8f.58.1753365390310;
        Thu, 24 Jul 2025 06:56:30 -0700 (PDT)
Received: from eugen-station.. (cpc148880-bexl9-2-0-cust354.2-3.cable.virginm.net. [82.11.253.99])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587054e37dsm20889375e9.14.2025.07.24.06.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 06:56:30 -0700 (PDT)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com
Cc: linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	eugen.hristev@linaro.org,
	corbet@lwn.net,
	mojha@qti.qualcomm.com,
	rostedt@goodmis.org,
	jonechou@google.com,
	tudor.ambarus@linaro.org
Subject: [RFC][PATCH v2 09/29] genirq/irqdesc: Annotate static information into Kmemdump
Date: Thu, 24 Jul 2025 16:54:52 +0300
Message-ID: <20250724135512.518487-10-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250724135512.518487-1-eugen.hristev@linaro.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AB29B40007
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 1sbagb76f7w99shwrbnyibcoaib5xejz
X-HE-Tag: 1753365391-259875
X-HE-Meta: U2FsdGVkX19mCfpY6hYwB9g5zzAl1eSV9MOxCrj17llCgIZcmMAdXI8x/N6G1tIwIC/CATxOg4WaQkDvM5QH9FZb1T9d8Odcfzct/Yft/LaO6I2sEgsQN0sFmRcYdPeQpiFTTeIypLxBMZFAv8HT8XEhBmwFmwMMThbXmBscey4zYr6B4Ad++uwIFHbzruU7xX9u3UOQ93QKjjhfBbQEIViWU7pM7RBS1EjvX3uGu1H8g91t2c/7GuYaD3haSYJrhJUG8qA877mNht0Y94AOruoNB3SKGvS70/6hhDb8lFHj6+R2lLKxeIxqyFivWL2Tx6y/YdIO6goXBZAeFzpxRWMu1m/9dEzLRF+tqp2JyoLXe8TT/uEG0TzZy5R/tpU+W9bzyuk0Q9ZMmxQ9qe1Q6HmOTx9n6fdiAukpiUS5UpTiNxL4hza2W3RwH2IRr763rrkGR9kZVLijQ+kuKS1AKQjeG7p2CqBpgWanDnj0rixufqT5MGRwriay6MDiavl9qhMYZtZoJQg2qhhiK5QZxhZLAmyP9TsIYL4jkgt9vtfHcgDsAXyUOjhdzffaXa/21j5I1V0d7OZG4DHQqc3B8OzQBpoLlpkwAPI1bCmch8p3JwPtbudJi2mNt0ihw0ZPTXyHteodqu3Bat6AeruIXc3K06jrZ18vrWqxA3fhNWuwjbotZIp1PGR8itRznxSlQEbTb02QVgxX+LTAbywuOk0Q3fQg06KZwCp2ljnLxy+eqc9aKm1T+vok/hgtT6F9qdKpwL/OIzNaabxHpIQWFyh4epQL6xlPhCsuoGN9vPt/QsvfGg8HXZ2FlLvSgkmi/prxGQNZtfc+nQ5Bn459JMJdKTayemouOdqFoAXdchgd+boeRIM0NLBd8nD2y9LCwM/ED44FRW3OfnByetLRDF1icUgNVKShdulajTj2k48Dy1aYbLWPbldB3kNNoOVpwTg264cr6ajVJ4IKmq0
 xR8nlVJ1
 FATbCnT3yNWZi2hsQHaWHyuDDtzsSWvKJIbqD/XjaNPMhCaPHj7DgnySOAmeS3EK51Coj3K2YEKSS+XoMIG9G8hgDCSlTHzdBJSthf/SnrMDLpOhHHe7C+K0cmnqC0qvYkj5bBQE60pvlV+cPNT5vBM6N6Cm+HKPkobtQuvN64kDYbbSMktoQLqe4B9IIQJAUxZkhXcDxgRkMfr+H3jb3DYBmSduPQsf9jf6E7odOs7ccGzCU7pbWE4D9j3eKg09bV012fodpiNTOOk0T7Pud9cUWb3DJjGldd8LyOWozcheug48czb6r2CdQWdgLrlDUtlLzrnx8wPqDyZ3k3wcXsyaSZ/kenUBQqKKc+osCS2V4egnkL+YEjtwBlr5BJnUYheB3bwZhkVKucrA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static information into kmemdump:
 - nr_irqs

Information on these variables is stored into dedicated kmemdump section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 kernel/irq/irqdesc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index b64c57b44c20..6d11b85be2b3 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -12,6 +12,7 @@
 #include <linux/export.h>
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
+#include <linux/kmemdump.h>
 #include <linux/maple_tree.h>
 #include <linux/irqdomain.h>
 #include <linux/sysfs.h>
@@ -140,6 +141,7 @@ static void desc_set_defaults(unsigned int irq, struct irq_desc *desc, int node,
 }
 
 static unsigned int nr_irqs = NR_IRQS;
+KMEMDUMP_VAR_CORE(nr_irqs, sizeof(nr_irqs));
 
 /**
  * irq_get_nr_irqs() - Number of interrupts supported by the system.
-- 
2.43.0


