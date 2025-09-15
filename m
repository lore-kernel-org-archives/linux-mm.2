Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72CC0CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 13:40:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F362D8E000C; Mon, 15 Sep 2025 09:40:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBF3B8E0001; Mon, 15 Sep 2025 09:40:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D60248E000C; Mon, 15 Sep 2025 09:40:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C4F898E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:40:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8BF361406A0
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:40:48 +0000 (UTC)
X-FDA: 83891594976.06.497A328
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf06.hostedemail.com (Postfix) with ESMTP id A0505180006
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:40:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O1gDa9Xw;
	spf=pass (imf06.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757943646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d4jfcSPGUvol/n8ObJSFwltbXIiILhsqpfoN+DLL7zw=;
	b=G6njcO1GClSVMlKJrGXbsqsIb/nj9L7OEpkbJOrN5qBQVjSxT+iz8+baWNRA5g/0axcd/L
	oA9/m8JUw5fyF5SuPTv5Bfh9bYGlBENIshkHvXyp4kEGrenGNTPRQWJCuRmpWg2CQNjdZD
	mA2Q8gM4IzskjsWMKO0Ps4Dvp7PWApg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757943646; a=rsa-sha256;
	cv=none;
	b=guyrBR/d1ui1uE397MtLBsM24Pk2BfPUK59JcG54qgvp8jj4n8M688LLXLyCDVuqRuWFFU
	z+OJKeCQSuqid5zuSgnCGBFDQl6pTJOI0KQ1E+z/C0lFSU/Q3bFBIO9k6eUS57DpGV3p1C
	/B++B8L0e2MJsPu4ne4wabVCPIsyB/Q=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O1gDa9Xw;
	spf=pass (imf06.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5608b619cd8so5186979e87.2
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757943645; x=1758548445; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d4jfcSPGUvol/n8ObJSFwltbXIiILhsqpfoN+DLL7zw=;
        b=O1gDa9XweUqB23o2eYhylHlXFJK5r/upu6ugmOBVQG//Aizss5O6TZZu6WuNdHwggG
         Vtw1rJxCs8dWbq5/M7yViRXcAaR51iymsxNRWEuOFfN0HvboKdaZdcPq17yBaecYasRo
         A6fcJfu/jXjvL+FgYHucCyyVOMryWQhrX4GwrX9Z2QmMZJmDxm0XJ3Zwncva4syMlFvJ
         Bo/NhFzeoIsFaxMwKfWzEVAKjr53hMrq0nkIZbod7GAl7j25hA49VSaSwrXcw1qEPXua
         gn0wGqtgHJ5GGDYuYnSiKbBngKL/G6tXRx7JB0X4xVB9G0RQRBO0Uw06etWGEidBrGEf
         8Npw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757943645; x=1758548445;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d4jfcSPGUvol/n8ObJSFwltbXIiILhsqpfoN+DLL7zw=;
        b=olheMiAS1RDWhAD0uZyXWCed5WM2xk/XT2UkX8b7ivwxKflJBZUUG3VeYqA+JhSQZw
         Ct9v/IMcA91RdEz5dNpd7eatp1yam5dHRIAzbHx5Qv+8zuMufKD/r0qs2z32lmq0a6aY
         T9KhDZMCQa2cEQBbhMGo8StU6TVmSs/vEiAapoKfI9Vj0EZh3Hs9Zx0JipqDJRzbXtfd
         zIG7iPKJJYfcahRJAxx/9Lmfl/KhFEekfkXBRDDHa2pL6ceMHkPHyy1/+Kybk+gYWUz6
         LH2xymSS1iAReoGakEWPIMrWZYQgn/qFO/wP5ZgmqFtoQLgFqgBqfGUQCwpqW67Krf7o
         tWCg==
X-Gm-Message-State: AOJu0YzYnjArAF/yveBldjml/Tt1n2IfKhvL5Nrc7tN80OwDtaU2mkxf
	gGv5zSpGSIvXXJ2YQLD3B4CRdhKxWr0YO7tUdzGD/CxveWQNMAJUqvM7PAfntQ==
X-Gm-Gg: ASbGncuMkO3e2IetCSB59wRFAoMp9Zz0CneUBt3nPeP1rJeTxT49o92rHMPQTbANedx
	bS+wevGQRCLT6RzJycNpuv9MSKE73HaizeKPqVajugqKEo2+zLQgHKnwFaA+xhNoI4Ri3KIyGAl
	2fzl6GJb3KnEBB9Ppy0mZO1tOXIr/L6+sXS8BkR6GiNCFCpNpZ1v1jDigafK9MCuZRDvZkMjkIO
	4+yJ+U+Wl3bowN5FUfQp5ot++Ap5/4II8NbObeosDRWcDuuaPIbUecZ4WnTj8hOj6R8ma0VADPJ
	EFfwdfgIyvbYTL43o4WhRdxB+UShC5dpT6WNNVDFZqCYy1xd8IdB3RsgiyB4s9BGhssC/YRG9qW
	ce037iMa6aUqX3NLM
X-Google-Smtp-Source: AGHT+IFfFqmM0jy7ylbFqglRpgiY5qZFquoCe9bp4TcomMhze69RBptnZFzQntvLjkxDYXF3stX3XA==
X-Received: by 2002:a05:6512:3c8a:b0:55f:64b9:3ab4 with SMTP id 2adb3069b0e04-5704ca47523mr3450667e87.23.1757943644794;
        Mon, 15 Sep 2025 06:40:44 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-573c8330e54sm1150719e87.63.2025.09.15.06.40.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 06:40:44 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: [PATCH v2 02/10] lib/test_vmalloc: Remove xfail condition check
Date: Mon, 15 Sep 2025 15:40:32 +0200
Message-ID: <20250915134041.151462-3-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250915134041.151462-1-urezki@gmail.com>
References: <20250915134041.151462-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rxznm8b9rrm8sokg6s8ddymgu7qi1raz
X-Rspamd-Queue-Id: A0505180006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757943646-805697
X-HE-Meta: U2FsdGVkX1+Qmom7Z5tMikMx4Cj6P6cryPnm//JoGv0cCBTgmhQBukBL4TOb5CSSLTgI59iFEiZITQ3UkxKvg+en2vzP78SKcVqbxjcXkOWO/xrEwyfWV4oOvZNlJU5nh/qqbxY6f4mXWbbhH2mH8Q2VmkEZLPB34mFrezO/dsBnO4tvFydDbBC2zFV5ZwXUVuvVVu+GOIu0QF4NQ07KF1+7I2rmM7EkAAWln/ZupOUUA2JlIz4JBG3AXKhrxyZ+WBGFo2fiPAz/nuDU5vzAbYjMQrvU59jshYVNRgukZ/pXHwfkC2hvJWVpPKvslolj4o8Jh2N1aU1AkIPCtl3r6XpBMJZLh3DZh5vHwwbGk68v6k6tIosNtjexvR2OjzhCOZl/Dr0/5sEYmisrLGP6VaxowIoDwoxOJRUZ6VMKXVNgOQTAVKFjMeH4y6sf1eOtuDxdQRh9MNVPMwT93rx0wAqT3oRn/1aQ+w9qRNMQi4msY4U2pPNWd8FWBujTxJi1fCoger+qWXb1MlJ9mA7BaX/IRZbuz55sQYT0flDMyAI+ZstM6+TPDbK7RoD6cKzY5huthl0BVhdQYvqC+Ex8T4isG/kwQiju17bG+RxxH7rZZkwSTBBRb3egX1an0PYU7f0+9+Jj/E3dfk4ZC+DmeVxl30JkVsttJLJXAegaCfmHfWa5RPqamdh4K4/IeDHleuWJEvybV3hM8JBYP3Tb9xNhTVX5gDNWibETyGxhVUfbbsuAWS6FmkMIWkz1wZLTqL552W9LjPUKC5Ay4mxjvo6VzuxqoX1LeS3syTIaqjlKMOns9pJT9RM6zmGTAaIQn8GCO4JuhABJR6PIHw4SjeZ6cAse0qcWD4n0JqFc5WlwhD2bNZKz82v5ChD9zVTNTgYjZz4ReiNefcllCKx3jK13xEkn917fkqmT+soBJfK+dgBFpPKTPgvA6+9Qk2mQFUScV+vnVePxkKbGxzC
 BAP6pRaG
 0T40+r1KJ2zVHrXkRpMCbnUNI1ELUBwpVAqMEN7s5bTa1ywIyWV3utXinxG5gnJMPeoR3zm7S4OKLQYxPlkDRh6utNyfMHwUd+h029wUSZKVcrxnefDMST4y/itJaxoG26oigY9Zya4wlDgmZ3WtOmhPHVSXUGrpI571OwcUy7pbbgj/20ko3ljvWN4ERW7TJB0PSJtPfnlLUY990lK8sWktlagoi1f8w9ptWMt9A4La/Dn9guvXE6JwXhk8eZHqmQJ5526aphJe1pUAE3LIbao34Di+i2y/0WuhmF7KAvchTYcaukIDZPfjD3oE6ZhbP6a3zEjcxvPy2ffypx5RYNFoZ3qJy3smO/r8hFAFz/M9SM4a4vtm/0PCAMAVU410MvVR9sS27XXbmdOIF0Ib3OGIfPxXIa32GLMx9tMFXYtkjEUtVVfAdq8SVC9Gu2/zfkioHRJzZeLOxHpNWerh/PLuaV/H80tjSXP89CWB1lYSPprxrgBMezdI5Lg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A test marked with "xfail = true" is expected to fail but that
does not mean it is predetermined to fail. Remove "xfail" condition
check for tests which pass successfully.

Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 lib/test_vmalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/test_vmalloc.c b/lib/test_vmalloc.c
index aae5f4910aff..6521c05c7816 100644
--- a/lib/test_vmalloc.c
+++ b/lib/test_vmalloc.c
@@ -500,7 +500,7 @@ static int test_func(void *private)
 		for (j = 0; j < test_repeat_count; j++) {
 			ret = test_case_array[index].test_func();
 
-			if (!ret && !test_case_array[index].xfail)
+			if (!ret)
 				t->data[index].test_passed++;
 			else if (ret && test_case_array[index].xfail)
 				t->data[index].test_xfailed++;
-- 
2.47.3


