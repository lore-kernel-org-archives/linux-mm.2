Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 499A6CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 20:50:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32FEE6B008A; Wed, 20 May 2026 16:50:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3088D6B0092; Wed, 20 May 2026 16:50:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 020D66B0096; Wed, 20 May 2026 16:50:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DDAEC6B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:50:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 86C5C1A02E5
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:50:39 +0000 (UTC)
X-FDA: 84788991798.04.5BA74AB
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf14.hostedemail.com (Postfix) with ESMTP id 08AA3100008
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:50:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="W/Fc4D31";
	spf=pass (imf14.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779310237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ffJ2JJSKQVzdHRhijG2w6dxdoknMDsdke9qLMqnWpks=;
	b=IdDIwlsx3TsZb1MqtYypQrMKGN3sQ7YQ2RlQ/tKJp8Aha7Qo3AIhJTM3zx7ahxJLov9K13
	sm18aLRXzZ6iPmqDbM8dqozwfL3ysU5wsjFFXkCNJ3ckbAWyQHoxTt4riZKFD3LN0F6swO
	AQWzgQb+a4wgJ7HiZDZtSo3H2YkV8mo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="W/Fc4D31";
	spf=pass (imf14.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779310237; a=rsa-sha256;
	cv=none;
	b=ZcwDBceNojztZn8GrCLJsPY1NBPkDnDbfND48B5T3zcRhcK0KwBE9pzifXFududkzwjWt5
	NhkXXzRdJQriHeMOLq26Ip1IQPRHuQqUX+tla69nPBioKohcGfToz9NWdtGS2wDJ47q8VK
	1Uh9OIrSXkTUDhV9zhGFIw0LocTE2S0=
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KKO1kB2689162
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:50:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=ffJ2
	JJSKQVzdHRhijG2w6dxdoknMDsdke9qLMqnWpks=; b=W/Fc4D31vRqCN3cO4jiE
	O9tkJZzBanaFHDsvBZnN4bSf+oqjUQ5WkPh+/nlPxP1ife3OtDV1s201eBD4xCaX
	EOyM+PIgbyPl5oB4EEetTGEq3CKYLOEzVvyWFKK0XZMDPcskKiKyc1Om+RbJjKBx
	u8+Arrrckm2jbgidqVt8GZb/AIR3KsfeGHFHIkbr0gtRjqrzluYG5tAsE4Tanc9Z
	zOaIYsiG0Oh8zKOdM+sUv4I3Bk6Gbz322ysRCtVeAxCad7iOhpED79Xob+cU3nqW
	V1LvXqiADQcxchodCvqj7J9Q5FwUDwZfdLvzdNeNnECSRFNdecQccpvmA0qKiMKl
	1g==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4e9gr8hu4s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:50:35 -0400 (EDT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-90fdd724bf1so1418814685a.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 13:50:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779310234; x=1779915034;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ffJ2JJSKQVzdHRhijG2w6dxdoknMDsdke9qLMqnWpks=;
        b=hlZuZI8LbdfX6nzMe4EkryGnv6+FLa1HXfk2MXX5bGUdgi352PxYOliP1/4+tcYiOM
         F3XzybE2grwAAlgGQAL00KaCQkPE2eoyM4A5P00IQoFkn8DvlzMEHgL2D0Mptf8m2TPM
         j9zEEj8JXN7z28hjzChty2PNdrSh0m9ZCiWq4+t0YkRFj7rcNG6K2wIHC+0eQ8lCgfo7
         7Z02HXysW1pt/NZEkDK82oGATUBSey81ur0bpgR28tg6J409G36troSRHWXdKH+V0Lx0
         VlGK/iOlpoAAsLyqXNOKavGGVk4+ACgPMxL6VYNyjhLgG+yrOocSM/zNOLrWVr5zDD6p
         5fuw==
X-Forwarded-Encrypted: i=1; AFNElJ8b/9p/QWBldAUhhwYKddqXk0yOLg1cUqq21B1fbJyWvOdkPZ5tOwdEb+l/DRTp++hEnpbUD4BqXw==@kvack.org
X-Gm-Message-State: AOJu0YyXQymjeO3mbCuG63BCM+GwI/CNTXpE/9uuo6v66nv+/4ApB5at
	6Bd982xCzJJwAcXimWB/jkbor4OSs48Rxmov2zwiZruel9KOUctRaqJL1qn3kKConZusyqqoTvu
	vhKYdAi8h2Gd9HBJqBE3I6B4O3qxnROqrm0yUnqmAyjJiiYGJ
X-Gm-Gg: Acq92OEHCtIoUJnRV/fruF7xHsRPSVJ6zzNIJKasa2O3wKcIdFYdyjKLERuYdJK7pZK
	hymIWiYid6RBFRwl9zX7duNIlRm03PsGuN7rOxGlYGw/YbPTM7Tud22l4lFp/HTzl9Glj7DJDEf
	b8ZX/YQzL0g0giedwY+QR5Xc4C2e2r5Z14h4C7LlmqnLbwFXd3lk8m3Bh7iV0HWEpui8/9NHy3D
	IO1wgtkzy+0ondk83abnXbqT38fidtbc1/UX5ioMHupuGtjzY+u3xuZ+7DJPIabjfHwuMfEaBdl
	zSrzBOKOxwCD+kieYpL5tPRFBtgKXrPL59kUfZ8WUysMg4hwQAXHD1kFhacmr+yJDU38CPewNtW
	4SiwQIlfKRGhcuzM/0UCpUkHdA7w4CjSZF38IHRqDVq7MFuRis8ghfoHmwO04Z3Lvg8I=
X-Received: by 2002:a05:620a:950f:b0:912:1206:ddc3 with SMTP id af79cd13be357-9121206e06emr2819139085a.26.1779310234367;
        Wed, 20 May 2026 13:50:34 -0700 (PDT)
X-Received: by 2002:a05:620a:950f:b0:912:1206:ddc3 with SMTP id af79cd13be357-9121206e06emr2819134585a.26.1779310233678;
        Wed, 20 May 2026 13:50:33 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bcf37274sm2232692085a.37.2026.05.20.13.50.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 13:50:33 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 20 May 2026 16:48:54 -0400
Subject: [PATCH RFC 03/11] folio_wait: move folio bit-lock and wait
 declarations to include/linux/folio_wait.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-filemap-split-v1-3-c36ddc2b6cf2@columbia.edu>
References: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
In-Reply-To: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779310229; l=12875;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=JzPEBxOc5uLYO+ALFu5mYnofmzvhYRoxUfHP+iRDfKc=;
 b=oKMCnu1WDCEIQovrQVPCgWvWiT5h4hdabCbpif7zEJlr8N56Mg5qWQhk3F5szAwn3Z0gBo3Wg
 0+m1hXVGY60CEfAZMYtlZBI3W1WCOQkn9X0W5SEZhF3iJoBXoSnunof
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: lc799c5dANiM231UzshJDOfJdJzizJ9d
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDIwMyBTYWx0ZWRfX4Z1zV4BpbRIQ
 RQfnQGv+Rk1aFmEc3c1nJHxG3/9+LuLJpLljeaFoMCQJ01zUjegg0crcUFsGZy3k+mpZxLTyqFe
 p3I7IPibZFltW6vQyzE10f774LJ5FDEUAeloeLRemuPUwbNif2WS/PWovhCc02jCuqu/om5PJeb
 siheHoi/EK4XjE20ZxHax6Yxz4PZT9VKfpLAgFdVeRJ1AuJBo/tZDZMoC3LclKUE6bw18YhqGBj
 4rYIpM+KvFWMXAXVulw9TUGgoOUoTcLpFsYQz13Y8xsniKJ6vTmKCxxJ5sJhrwSKhv+uXRB5s4Z
 MDzjcILH7yfY1AM4GfBqDooFyeLFR4dezNWfOus5qrX01s/4m7a8tHHY4C7ANmWo98lUYUfcJ39
 3PGf48vYBVMoLx7coJljK5MXOSCnwycNwI7qenidEhZjBlYoN+cflXokKjTysQOPU7vWpBFfSyn
 QS//KHzhJ4eiXt/DB0Q==
X-Authority-Analysis: v=2.4 cv=UPXt2ify c=1 sm=1 tr=0 ts=6a0e1e9b cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=DRKH7QcZ0YB8km8p46MA:9 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-ORIG-GUID: lc799c5dANiM231UzshJDOfJdJzizJ9d
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11792
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 impostorscore=10 priorityscore=1501 bulkscore=10 phishscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=10 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605200203
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 08AA3100008
X-Stat-Signature: 4scugy6jhk8iq6rfpemqi3mnxgmnxpkq
X-HE-Tag: 1779310236-900955
X-HE-Meta: U2FsdGVkX1+eLXJTLARx2jXcpG5mCmL+iXHsg4eCDRXwt+6eHqtJGEVTFe53iO0H7iGVWkqUlV5d6RjUV4FIYmJ+IDrT8kH5M/z6+fWD5zWrKIycGbWugDg2uCt/vOBUdu2AIkOz7AzJ8SEw5sBvZk02AxcM0rgZukRXzQ2ud2T1c0doDmFSuB2GbBFBIrzBit1k1n3UI+J2Z78FxWK77Mo9w0UVs8nP2Pl1PlAbHQjfa7H8rB9qAJqKWNqcnX5rQnfoMop9Oo2pbxnP5JiXKZZ5lhu8/g8Aqe4F35F6h1B6+BwJb10k09xWr3fRBltWfO2/Ymw7A5Gyx3mYWyC441guHl8U2NXmreGwVo2BJn1F6/9mALVTMGDTRs/oYhVgmqheLlZEbk39OWSM+K9c2mTor93BoNOZRov9558XEK8lAMWdUtE85+01Nl2bUS3iklFopjFeJgOSKnaz9/Nn68sFpa2YHMmDSsVlMijo5UECF6exZP/oB8Qami35Wyyqis+kOCaOyi88lILl6Da+LxqbUEgfgtX4GA+7t/qLcBMvfWGiPNTzNie3lrQvUkraoOWpOG6wIRL5uxPK5LzBzxVtpw6Pc92lWytPlESqWmiGRTaEJgg00IgzR0MaVOJDyYLbpzMNNIkbvi+VdS5JpXaCqDruPn1NKxwLRQig8qzx0AMhkrTiaNy0eh1Ma86b8/6MqdujB/9M94L5x9GSefgrG+KXz1KWx5DD6rj7jQ/u4o5Sfa0i8vauCrwY8kA5R4gc05HkUstoeQzl2ZIlLRZ1eCp/qA/ybx5OkJTOmXsDm4V7gQgJkRK+R8Cvkdlh+rxWfCoSybxspb3q5r5qBUR7Lq0Q8PWIUSi549qfrW3kAlIgyKfcJC/gvlIn84gou2oaSMtrFufsk+3CkwT+RwICFlvutZnj/n2NDpd0yioRUaWams4GZGVU3yKhIRNV6uOYFVm+cJm19YmZu8t
 yJSPn/Gs
 3slwpGIMdnWTKcMnH+Vo6FnhobyFwGcv7KvuT69nxyS6tEx+f7rX1lhNT1fH3g/ERounm3YMx6I2Ih4ITObX0Scx2BTpGeq8IAiIC6PNH9Qv+d6yUpbDRdWdMZZn/v7Qreih1DOmp/YrEvChCzzR/mX9xJN35C76hs5dUv/dQVoyCz0gtbwFFLcpNKBqf/XTMGU2vUeGsgwF7rbUGgFxH6wDEmKxOlB6LKNK7StciImePNyWJZr4/TmGg2dvZpkls0Yyrh105w9E9DIuw9qcZFeS+AdZEejX2zKijX90TI4C02PF1jB90c8Pr7w3CP4mnC55tDYopZWM2MQLpjt9k5TutKBNqH1sh2kjpKgJWnc9Ok/3l6UmOOnuzaOH/wCp0Jrr0h5RWremAlrpIqUnXo1D9uBbn0MW1P8pGf0jMl5p1PSOhHoUI9N7ctKOGcFkcGG2Ymq27GstzCTmIBaGB5BwUFJCfup39DUyQ/qsu/5qHIz4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move ~150 lines of folio bit-lock and wait queue infrastructure from
pagemap.h to folio_wait.h. pagemap.h includes the new header so existing
users don't break.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/folio_wait.h | 181 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pagemap.h    | 172 +-----------------------------------------
 mm/folio_wait.c            |   2 +-
 3 files changed, 183 insertions(+), 172 deletions(-)

diff --git a/include/linux/folio_wait.h b/include/linux/folio_wait.h
new file mode 100644
index 000000000000..80ddf1ffcae4
--- /dev/null
+++ b/include/linux/folio_wait.h
@@ -0,0 +1,181 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_FOLIO_WAIT_H
+#define _LINUX_FOLIO_WAIT_H
+
+#include <linux/bitops.h>
+#include <linux/page-flags.h>
+#include <linux/wait.h>
+
+struct wait_page_key {
+	struct folio *folio;
+	int bit_nr;
+	int page_match;
+};
+
+struct wait_page_queue {
+	struct folio *folio;
+	int bit_nr;
+	wait_queue_entry_t wait;
+};
+
+static inline bool wake_page_match(struct wait_page_queue *wait_page,
+				  struct wait_page_key *key)
+{
+	if (wait_page->folio != key->folio)
+	       return false;
+	key->page_match = 1;
+
+	if (wait_page->bit_nr != key->bit_nr)
+		return false;
+
+	return true;
+}
+
+void __folio_lock(struct folio *folio);
+int __folio_lock_killable(struct folio *folio);
+vm_fault_t __folio_lock_or_retry(struct folio *folio, struct vm_fault *vmf);
+void unlock_page(struct page *page);
+void folio_unlock(struct folio *folio);
+
+/**
+ * folio_trylock() - Attempt to lock a folio.
+ * @folio: The folio to attempt to lock.
+ *
+ * Sometimes it is undesirable to wait for a folio to be unlocked (eg
+ * when the locks are being taken in the wrong order, or if making
+ * progress through a batch of folios is more important than processing
+ * them in order).  Usually folio_lock() is the correct function to call.
+ *
+ * Context: Any context.
+ * Return: Whether the lock was successfully acquired.
+ */
+static inline bool folio_trylock(struct folio *folio)
+{
+	return likely(!test_and_set_bit_lock(PG_locked, folio_flags(folio, 0)));
+}
+
+/*
+ * Return true if the page was successfully locked
+ */
+static inline bool trylock_page(struct page *page)
+{
+	return folio_trylock(page_folio(page));
+}
+
+/**
+ * folio_lock() - Lock this folio.
+ * @folio: The folio to lock.
+ *
+ * The folio lock protects against many things, probably more than it
+ * should.  It is primarily held while a folio is being brought uptodate,
+ * either from its backing file or from swap.  It is also held while a
+ * folio is being truncated from its address_space, so holding the lock
+ * is sufficient to keep folio->mapping stable.
+ *
+ * The folio lock is also held while write() is modifying the page to
+ * provide POSIX atomicity guarantees (as long as the write does not
+ * cross a page boundary).  Other modifications to the data in the folio
+ * do not hold the folio lock and can race with writes, eg DMA and stores
+ * to mapped pages.
+ *
+ * Context: May sleep.  If you need to acquire the locks of two or
+ * more folios, they must be in order of ascending index, if they are
+ * in the same address_space.  If they are in different address_spaces,
+ * acquire the lock of the folio which belongs to the address_space which
+ * has the lowest address in memory first.
+ */
+static inline void folio_lock(struct folio *folio)
+{
+	might_sleep();
+	if (!folio_trylock(folio))
+		__folio_lock(folio);
+}
+
+/**
+ * lock_page() - Lock the folio containing this page.
+ * @page: The page to lock.
+ *
+ * See folio_lock() for a description of what the lock protects.
+ * This is a legacy function and new code should probably use folio_lock()
+ * instead.
+ *
+ * Context: May sleep.  Pages in the same folio share a lock, so do not
+ * attempt to lock two pages which share a folio.
+ */
+static inline void lock_page(struct page *page)
+{
+	struct folio *folio;
+	might_sleep();
+
+	folio = page_folio(page);
+	if (!folio_trylock(folio))
+		__folio_lock(folio);
+}
+
+/**
+ * folio_lock_killable() - Lock this folio, interruptible by a fatal signal.
+ * @folio: The folio to lock.
+ *
+ * Attempts to lock the folio, like folio_lock(), except that the sleep
+ * to acquire the lock is interruptible by a fatal signal.
+ *
+ * Context: May sleep; see folio_lock().
+ * Return: 0 if the lock was acquired; -EINTR if a fatal signal was received.
+ */
+static inline int folio_lock_killable(struct folio *folio)
+{
+	might_sleep();
+	if (!folio_trylock(folio))
+		return __folio_lock_killable(folio);
+	return 0;
+}
+
+/*
+ * folio_lock_or_retry - Lock the folio, unless this would block and the
+ * caller indicated that it can handle a retry.
+ *
+ * Return value and mmap_lock implications depend on flags; see
+ * __folio_lock_or_retry().
+ */
+static inline vm_fault_t folio_lock_or_retry(struct folio *folio,
+					     struct vm_fault *vmf)
+{
+	might_sleep();
+	if (!folio_trylock(folio))
+		return __folio_lock_or_retry(folio, vmf);
+	return 0;
+}
+
+/*
+ * This is exported only for folio_wait_locked/folio_wait_writeback, etc.,
+ * and should not be used directly.
+ */
+void folio_wait_bit(struct folio *folio, int bit_nr);
+int folio_wait_bit_killable(struct folio *folio, int bit_nr);
+
+/*
+ * Wait for a folio to be unlocked.
+ *
+ * This must be called with the caller "holding" the folio,
+ * ie with increased folio reference count so that the folio won't
+ * go away during the wait.
+ */
+static inline void folio_wait_locked(struct folio *folio)
+{
+	if (folio_test_locked(folio))
+		folio_wait_bit(folio, PG_locked);
+}
+
+static inline int folio_wait_locked_killable(struct folio *folio)
+{
+	if (!folio_test_locked(folio))
+		return 0;
+	return folio_wait_bit_killable(folio, PG_locked);
+}
+
+void folio_end_read(struct folio *folio, bool success);
+void folio_end_private_2(struct folio *folio);
+void folio_wait_private_2(struct folio *folio);
+int folio_wait_private_2_killable(struct folio *folio);
+
+#endif /* _LINUX_FOLIO_WAIT_H */
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 627771e82eb1..7f65c2b0097b 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -15,6 +15,7 @@
 #include <linux/bitops.h>
 #include <linux/hardirq.h> /* for in_interrupt() */
 #include <linux/hugetlb_inline.h>
+#include <linux/folio_wait.h>
 
 struct folio_batch;
 
@@ -1072,174 +1073,6 @@ static inline pgoff_t linear_page_index(const struct vm_area_struct *vma,
 	return pgoff;
 }
 
-struct wait_page_key {
-	struct folio *folio;
-	int bit_nr;
-	int page_match;
-};
-
-struct wait_page_queue {
-	struct folio *folio;
-	int bit_nr;
-	wait_queue_entry_t wait;
-};
-
-static inline bool wake_page_match(struct wait_page_queue *wait_page,
-				  struct wait_page_key *key)
-{
-	if (wait_page->folio != key->folio)
-	       return false;
-	key->page_match = 1;
-
-	if (wait_page->bit_nr != key->bit_nr)
-		return false;
-
-	return true;
-}
-
-void __folio_lock(struct folio *folio);
-int __folio_lock_killable(struct folio *folio);
-vm_fault_t __folio_lock_or_retry(struct folio *folio, struct vm_fault *vmf);
-void unlock_page(struct page *page);
-void folio_unlock(struct folio *folio);
-
-/**
- * folio_trylock() - Attempt to lock a folio.
- * @folio: The folio to attempt to lock.
- *
- * Sometimes it is undesirable to wait for a folio to be unlocked (eg
- * when the locks are being taken in the wrong order, or if making
- * progress through a batch of folios is more important than processing
- * them in order).  Usually folio_lock() is the correct function to call.
- *
- * Context: Any context.
- * Return: Whether the lock was successfully acquired.
- */
-static inline bool folio_trylock(struct folio *folio)
-{
-	return likely(!test_and_set_bit_lock(PG_locked, folio_flags(folio, 0)));
-}
-
-/*
- * Return true if the page was successfully locked
- */
-static inline bool trylock_page(struct page *page)
-{
-	return folio_trylock(page_folio(page));
-}
-
-/**
- * folio_lock() - Lock this folio.
- * @folio: The folio to lock.
- *
- * The folio lock protects against many things, probably more than it
- * should.  It is primarily held while a folio is being brought uptodate,
- * either from its backing file or from swap.  It is also held while a
- * folio is being truncated from its address_space, so holding the lock
- * is sufficient to keep folio->mapping stable.
- *
- * The folio lock is also held while write() is modifying the page to
- * provide POSIX atomicity guarantees (as long as the write does not
- * cross a page boundary).  Other modifications to the data in the folio
- * do not hold the folio lock and can race with writes, eg DMA and stores
- * to mapped pages.
- *
- * Context: May sleep.  If you need to acquire the locks of two or
- * more folios, they must be in order of ascending index, if they are
- * in the same address_space.  If they are in different address_spaces,
- * acquire the lock of the folio which belongs to the address_space which
- * has the lowest address in memory first.
- */
-static inline void folio_lock(struct folio *folio)
-{
-	might_sleep();
-	if (!folio_trylock(folio))
-		__folio_lock(folio);
-}
-
-/**
- * lock_page() - Lock the folio containing this page.
- * @page: The page to lock.
- *
- * See folio_lock() for a description of what the lock protects.
- * This is a legacy function and new code should probably use folio_lock()
- * instead.
- *
- * Context: May sleep.  Pages in the same folio share a lock, so do not
- * attempt to lock two pages which share a folio.
- */
-static inline void lock_page(struct page *page)
-{
-	struct folio *folio;
-	might_sleep();
-
-	folio = page_folio(page);
-	if (!folio_trylock(folio))
-		__folio_lock(folio);
-}
-
-/**
- * folio_lock_killable() - Lock this folio, interruptible by a fatal signal.
- * @folio: The folio to lock.
- *
- * Attempts to lock the folio, like folio_lock(), except that the sleep
- * to acquire the lock is interruptible by a fatal signal.
- *
- * Context: May sleep; see folio_lock().
- * Return: 0 if the lock was acquired; -EINTR if a fatal signal was received.
- */
-static inline int folio_lock_killable(struct folio *folio)
-{
-	might_sleep();
-	if (!folio_trylock(folio))
-		return __folio_lock_killable(folio);
-	return 0;
-}
-
-/*
- * folio_lock_or_retry - Lock the folio, unless this would block and the
- * caller indicated that it can handle a retry.
- *
- * Return value and mmap_lock implications depend on flags; see
- * __folio_lock_or_retry().
- */
-static inline vm_fault_t folio_lock_or_retry(struct folio *folio,
-					     struct vm_fault *vmf)
-{
-	might_sleep();
-	if (!folio_trylock(folio))
-		return __folio_lock_or_retry(folio, vmf);
-	return 0;
-}
-
-/*
- * This is exported only for folio_wait_locked/folio_wait_writeback, etc.,
- * and should not be used directly.
- */
-void folio_wait_bit(struct folio *folio, int bit_nr);
-int folio_wait_bit_killable(struct folio *folio, int bit_nr);
-
-/* 
- * Wait for a folio to be unlocked.
- *
- * This must be called with the caller "holding" the folio,
- * ie with increased folio reference count so that the folio won't
- * go away during the wait.
- */
-static inline void folio_wait_locked(struct folio *folio)
-{
-	if (folio_test_locked(folio))
-		folio_wait_bit(folio, PG_locked);
-}
-
-static inline int folio_wait_locked_killable(struct folio *folio)
-{
-	if (!folio_test_locked(folio))
-		return 0;
-	return folio_wait_bit_killable(folio, PG_locked);
-}
-
-void folio_end_read(struct folio *folio, bool success);
 void wait_on_page_writeback(struct page *page);
 void folio_wait_writeback(struct folio *folio);
 int folio_wait_writeback_killable(struct folio *folio);
@@ -1268,9 +1101,6 @@ int filemap_migrate_folio(struct address_space *mapping, struct folio *dst,
 #else
 #define filemap_migrate_folio NULL
 #endif
-void folio_end_private_2(struct folio *folio);
-void folio_wait_private_2(struct folio *folio);
-int folio_wait_private_2_killable(struct folio *folio);
 
 /*
  * Fault in userspace address range.
diff --git a/mm/folio_wait.c b/mm/folio_wait.c
index 18b42488ce37..06156e138c09 100644
--- a/mm/folio_wait.c
+++ b/mm/folio_wait.c
@@ -8,7 +8,7 @@
 #include <linux/mm.h>
 #include <linux/swap.h>
 #include <linux/leafops.h>
-#include <linux/pagemap.h>
+#include <linux/folio_wait.h>
 #include <linux/wait.h>
 #include <linux/hash.h>
 #include <linux/sysctl.h>

-- 
2.39.5


