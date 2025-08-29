Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41202CA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 18:32:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36C7C6B0026; Fri, 29 Aug 2025 14:32:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31DD56B0027; Fri, 29 Aug 2025 14:32:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BE686B0029; Fri, 29 Aug 2025 14:32:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0A5F76B0026
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 14:32:15 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CCFB51DEB08
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:32:14 +0000 (UTC)
X-FDA: 83830639788.14.9DB46AB
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf29.hostedemail.com (Postfix) with ESMTP id E12BD120003
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:32:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=Vo4qw4q7;
	spf=pass (imf29.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756492333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VpTsIMZMAvGu+0Cv94tirrHwkbCcjUoCoe0E1cezNnQ=;
	b=K8e3scYbyaDP/oCzAeynNonmJS2UvN4EJthNtMfov/M3H7900VmvdjcCBIDy6Ixb+oY/Pi
	PIZYwLstBHYMdKxzZjZxtY7oh2d7KkGhTtTElxPva7t24AZjYPFI2C9rjy5+lqAs27jJg/
	jYO1KT30LrkfuruESHkx+eQnAJaH2eg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=Vo4qw4q7;
	spf=pass (imf29.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756492333; a=rsa-sha256;
	cv=none;
	b=qfzlHz5zvD89/AxfXgjcIpTIEebRBW2RZ3XDNnLNC0bl6jTzuCpvYWMnvfAizdNbb68+3w
	Iu+D+ai14fk4HFDeVsxGBjhCQ3+6i6/YSBTp0FjbnN4c5B/nJVfTpJRV/OYphyEHrFuzn5
	avUKTWhhed3XIKvUc1BfE7CBoXpdJTQ=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-afefc7be9d4so190021866b.1
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756492331; x=1757097131; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VpTsIMZMAvGu+0Cv94tirrHwkbCcjUoCoe0E1cezNnQ=;
        b=Vo4qw4q7haVhThBDARRZRb3MnQVJlfBwf6qscMApE8PCK8Q4vSGuKGg0Aw6eqTSwkd
         BsZnUOZUgE3vO2l+P0SQk59lEOvdLQ11N6wWImUQs3SwUaU2SteCUWs86Q1GllB07Ex8
         0CnzKL+TApVAgwLY3ix1RPhwrTS+uleE3wxgIM/dTTXtXtUKWJSnDZDdN1Mytl/ePjE3
         V8KJGfU6K4QGAkD5/5Ef6380kFBMQj53bOqbYN38Pt0dapFFlRMTLR0GOegHui27dgXg
         DQDiSYkTtApdnYLL0ikeDigHk+UfVp/Ptxg+mmAdt7a16vdtL5IzBE8nJqHIExrxQl83
         GQlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756492331; x=1757097131;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VpTsIMZMAvGu+0Cv94tirrHwkbCcjUoCoe0E1cezNnQ=;
        b=Iq1R5EcvUQhebbwp1bQAKBPv1p+v6uOrWdpHatfwd5gCYb2vGIwxRO5fu4jlMlEOo7
         xAY/AdizT+QyrvJsz92Z6FoJG6D/izC+HcT6zZ7U2H9K8IbhLzpQXZsqnWcVIpiGGnV6
         WuKXh44GH111IVVMqKQ/hrQyFLdtmAb0RhOpqdRXOrUSxg0Fw0QUW+xDWBM99k0RklPK
         ojuwjtRQHR4R00iALNVZzXALv+DszWGhROQjaHQIqF/wGDi20Mo+gCCD8mrx+XLZpKJt
         RmroGJu5xn1ogI1xO2yuk4RQFzILOVsrFE5U+ciNVkx3xCZdNQAtBeSGeWmXAQCERGMH
         CwWw==
X-Forwarded-Encrypted: i=1; AJvYcCWvE1RfGCnxLWB+ydDSMYP+f+jEF6I8PCtGCh8K7M5SJHp4kWuE7igZyaDwSVUjpKl4P2x5jYfe/g==@kvack.org
X-Gm-Message-State: AOJu0YyDc5a/wr/+UsDz1rpCiA47d/5ZabY1/kN7cvEKxqfWfCNwzvwn
	JTwqJl/l17UAkMMWpBhwL/jzoL5F8/imoVp1bsrE+74XftXNplQvR4xsgd5f3hPF6H4=
X-Gm-Gg: ASbGncuFxscGa/YJ4M67WjRheGoSYwf3bem66ut9Wx5OQMIiT3QiKx2rPQOAh3/NxKB
	XrhKJ4mr9tb3YmzzkPXmrPUbZxhA1H27MB4eyZ+bKQaX4O3JA+YZfasj37sW0k5QuUZJK6MzdNa
	+N5iApV+VA8e2kjgGXWXlnctPShy3rP7PhdNzRdOLNUnMRWXCeq5SQks+k8C32WSaBlrDnOuO00
	bx/4qNChRioS6MQScxDuY2VjrfUCuKvoXqDBdylCAMJhM+5YIDND+vxAodkKM8bv5wA8bdZ3AUj
	3JQKO5V8Gnhpp/vBVNawcKuG2Vq+KvJ+moWgaRN/qWoHks0aDbogtFqnl6cKfv8+tfAnwgmeRiQ
	B+CwkMl0CzNW/hrXoP1UDkBTOVDeSfDST+TZAUFY3JczcqqvWPLSsZQOLz/R6LLBXg62Qy0wn97
	LBv7APsM+qEqBcgN1F2oNIRshnuDGLd6p+
X-Google-Smtp-Source: AGHT+IGY8RZG7UM9cRbB/qMS7odXqSdwqfd3yzWdCRIEIpzTBfe1cib0eGa/n8oqQzAkKhR9Vr5KxA==
X-Received: by 2002:a17:907:78d:b0:adb:428f:f748 with SMTP id a640c23a62f3a-afe294b483emr2613549166b.21.1756492331404;
        Fri, 29 Aug 2025 11:32:11 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefc7f1174sm257964466b.9.2025.08.29.11.32.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 11:32:11 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	willy@infradead.org,
	hughd@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 05/12] mm/oom_kill: add `const` to pointer parameter
Date: Fri, 29 Aug 2025 20:31:52 +0200
Message-ID: <20250829183159.2223948-6-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250829183159.2223948-1-max.kellermann@ionos.com>
References: <20250829183159.2223948-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E12BD120003
X-Stat-Signature: qh93ie41x7o9o7i3zanxkqgozymui5u8
X-Rspam-User: 
X-HE-Tag: 1756492332-288992
X-HE-Meta: U2FsdGVkX183iebeFLIbacbmAlHitvESHTWgzBq6iRfxPhxuAs/3PVhsfNZA3goG8NXLrRxTlD2e1BErqgasPgko8+ayEekS/iThIcWPtZo/QsbDgJB4DtdjAQaCK6kb5dnf97HM2k6lwSqHpNL2K5s8agAkVztru+0QM5dLu5uf+py5JnIMXbkYxCgwCExM4Y5qZyVGtP1Gtg4jWjWGITJ6MLy/9KtY4vTnpdElVcOvTZWlfmffBAjy5BlKDRsvPwjX0J5+4cNIniqa/914FNSd81qgj3eUB57ppizjbsxgw5O8q85d6J13Bie+kZi4Hqr7Ft2OsQ2Ag8A1CcLgsY5W+5wsb8HeYPI2qriszwVoJ+MZZcF5qbaEDVNH3UP+ohODsDcr1HSFeL/2Prh5EPrnkc/ZlpMtbrhLuSHdRvANK5iFiV8GGZEdwon+QE0ZcMroOe3c4/qpqIL8UaihZ5Gj28zTb5tIsNe1NMgq86HAjQcHUgrsMrIlGTRH0qKR0s1676FGr7IJq8RVhTLcT5D3JRhdh9yiK7o/nd/raE489q6x3cj3fSszdtK3tJ6Yy+H3QtfAkjQYMnEJen6Mm8ppz1y5KCWY9GZVP+fJ5VDs9YG18MV9cUeGtVQBpikg7X03On/bAfxo8UXOWLI65mJ6rcJ3Zoo420zRxjmisxBMfBdQFnU8hXuKM3NQB8XfExD6I2uzDdXnpwbYXc5LTB3bGmgE/bmbNaGNUgjGqCqEBHb9s6dJ+K++CdO2sDXO/JnIpk+NOywIkcdHWS5MNPUgdNX03f1zyAKel/oYrMKazQOqNMV6giCgR2t36Hon6nj5SE05D1l4fyZHvM9ofTR6tVtI46G7OJ0KencQOv1d/v0Vfr7gt1FKCLlkH+49a+HMhwv/EP8xidRLdOccSl1/q9eMl/BRSq3EHHElaCFQmmZrX6Dzd/JeigQGeCpLxpTARrZCe+enpbF3DFM
 pJjSrDc1
 EeRTuq9k/zpA+gbd/vcrg41PevjEOk7eLVvPo5wjADUUVaIt851ezkgtzQtZzVD4zF3bbjkTIw4/rNAMYjFGQSdF7UdBNNvIlGO0onWlwf0r1LiX8HX23Dd+Kv2gut3//wGoL9yn11zwYJ8vxaJVlw7LTgcfVqAF5tFDflFR7D8TDViSGOOPrVLg3LiNme018Op77koodHXRM34wCjnumYe0DW2ZE71IkC0ewXo/mLvYyC57uo8xfEDvFZmiOCbida3j0GCigBluwSVdvkSfZasFVWnwMkBxkmEpKX9WPNLHVoQm2VInEYNXYP1IFQ0k/S7hdHIOxrTOvkK1YLbTgjpcXBqxMVqRsPTEJp7uVVO4+arpeDSccVLJpF+SF0yAwpOQN1/4n4z+AnfniOH9Gf4zAw4oL36uWaKKe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 include/linux/mm.h | 2 +-
 mm/oom_kill.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index a40a3c42c904..a795deef93eb 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3840,7 +3840,7 @@ static inline int in_gate_area(struct mm_struct *mm, unsigned long addr)
 }
 #endif	/* __HAVE_ARCH_GATE_AREA */
 
-extern bool process_shares_mm(struct task_struct *p, struct mm_struct *mm);
+extern bool process_shares_mm(struct task_struct *p, const struct mm_struct *mm);
 
 void drop_slab(void);
 
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 17650f0b516e..69c4fc9d90e6 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -490,7 +490,7 @@ static bool oom_killer_disabled __read_mostly;
  * task's threads: if one of those is using this mm then this task was also
  * using it.
  */
-bool process_shares_mm(struct task_struct *p, struct mm_struct *mm)
+bool process_shares_mm(struct task_struct *p, const struct mm_struct *mm)
 {
 	struct task_struct *t;
 
-- 
2.47.2


