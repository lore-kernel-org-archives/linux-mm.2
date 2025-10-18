Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89734CCD195
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 17:18:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DACE8E0008; Sat, 18 Oct 2025 13:18:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 264D28E0002; Sat, 18 Oct 2025 13:18:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12C7B8E0008; Sat, 18 Oct 2025 13:18:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F0CBE8E0002
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 13:18:01 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AD16D14045E
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 17:18:01 +0000 (UTC)
X-FDA: 84011892762.10.C82241A
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf25.hostedemail.com (Postfix) with ESMTP id BA97CA0009
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 17:17:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="F/X7M+hY";
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760807879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G29XfdiPrhmaQm8Tird4J1gH3HStwZIQQCKqgD0mb8M=;
	b=laUTW9toyak0DNILW66eaGQPb5CbJa8AY8gFvxwNRuUgywxFqFySwzux0GbD4shf0yvuHB
	yCTeVDDtiok2MVUeFqoPtdNpxxQ5w+6SALcD8n/vdgUgBiY89DqsGa73aFC/AV+mLOShuI
	1opBQyYrvQsLLHpmOpl/ftypO3WaPAg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="F/X7M+hY";
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760807879; a=rsa-sha256;
	cv=none;
	b=pfRmn1+TrEtVVHh6+Cq8YnGsJh59kx8PvAUOHG5qNQePoVJrIEY+hqfhiEu6sNj8TDGX9p
	Shk823jsTCp6hG6vkosQzqdIiEVxonW8nI/PVyOv+wnfPcBVBr0vAuZCr29tkqaCpl6v1g
	2JKNEqbW/byqooNR8Hg2M1yASCAw1iI=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-87c1a760df5so58504986d6.1
        for <linux-mm@kvack.org>; Sat, 18 Oct 2025 10:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760807879; x=1761412679; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G29XfdiPrhmaQm8Tird4J1gH3HStwZIQQCKqgD0mb8M=;
        b=F/X7M+hYKZwllA0GKqd7ao1d707l3adFhMpWm3o6JwrmMqt/eA4HqXV8jD9YWtUOPn
         aVqDOJ8Sh6cgJ7t/VbLM0nJAZ4U6WUs1PI5UdEr1CLs5RxSl+eBnF5s+fpqQH8ACscRT
         Ak5wk+Hjeh0mFEnywbOcxxFHTfAqWWc92vBVwwtIZsrLY6YSVhJ5KpmvfH/91urZuXss
         Y3BBgtxRnsoafHs4BVOc30b5HsJU5jcnedgIKKs0Kb/BBNOQcgk10XuyTK1D1QmWlNl2
         GrsRDg7rD1KkPGIJsLAcZ5jIvTc4IIqyGajOSEDqzJmHuCtM3GgBh32lDNf7WAUOJTy/
         7dAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760807879; x=1761412679;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G29XfdiPrhmaQm8Tird4J1gH3HStwZIQQCKqgD0mb8M=;
        b=h862gratyIphRZ1CaY3VsW2e2wVXz1JPMgNdJ/WPzmwj/NhDAs4GVTuMEE5hplOGNV
         1Wqo4JuWwqATXKq8LDT5dmU8nDdojxgcSQp8UEHCbwBaPBBhfeC7eGqzG9QDdZ1B4Tm+
         F/wB3oPo68q/Qiz8ittC6kIyG1aLGsEG0gfTvKUQ2E5+tx2W7zqllOsfNxFih4nchFc7
         RovNQccv2QBnzXutT5gfOlYGKW8rFI7yY277+weqsJS4pQCfGM01cpFIvIqqDUgPLaQo
         zASc9R152W2bq4KZyQ9iSFGdSqNsTovbRfDzFgWz56IiYyjAmZ4EWfpqh5y7yKruCUja
         wbcQ==
X-Forwarded-Encrypted: i=1; AJvYcCUlaqre2oWCUfAMA1nI7hCGX+CDX0KRR05YTMJUl3DXEqA2HWVA2FgxNn8qdNdlziGT8NBAdOSgXw==@kvack.org
X-Gm-Message-State: AOJu0Yxz7nH5LgjOshLT4CluVt9p/zj6N+nw/q+h43fS7RPWfg8tgVNY
	L0GpMJXhGesWTdwdr+xJMLUByBzU9hLWNGRf4CBY6w1DwfwIB+FzxzkGiwSct1XrPDo=
X-Gm-Gg: ASbGncuyyeWHmk4xQBQAFzXzovKN7OwD79/ouaO8msCJmQ4l+2Ue06uoedLENz9p1N4
	B+9YbAYYebO6+y+aGAGS5mHihGcy6i8KIoBeMmrUP6xG7Nep+LLUKtUrKUWrktEhAcRkmC3KGAD
	38LAcv3vJ2nAr02OrAkTVtYNSJD/Bqwv+iCiI2ZywCN9Dcx8TSvSjd8V4pOOMjBS1XBcuFpBDgy
	h6wz3bwJQV/BUuw/NqMjucjs939IzIcHMj9/hO3KXo9BWAWdvM3EUXVoonpE/mLNdYX4707HtS4
	wRwa72DiJwRHJ9A9AlHnw980KILs3eEBcpwpPN67LPatr9sn6fCY3DfEg6PR9JJ7bv1tqEekERt
	/dycykGZaMqY88jFNCOKm+s9wwhWRHXylC8xr+IiCxUGxdn2C82RtAAJO4Zn6B2PMpWnR7rlww+
	p7HEZrqNQGcXqREoG8+/Vs0UJlI5uSuW4Kdpee9UC6v7bS4CQhH6GEJd0GdTrr2DM6eFSKbX8uv
	2EkVArKEY2viSTbIMUxag==
X-Google-Smtp-Source: AGHT+IFUrn/ODTICOJeqybc9wpoG1rwCuTkHZDhaNQG6q4OMb39krbHuQ7xa84xnE8FoRgnLNMU84g==
X-Received: by 2002:a05:6214:248a:b0:7a3:b6ab:6f2 with SMTP id 6a1803df08f44-87c206612e1mr126599836d6.63.1760807878808;
        Sat, 18 Oct 2025 10:17:58 -0700 (PDT)
Received: from soleen.us-east4-b.c.cloudtop-prod-us-east.internal (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87d02d8e909sm18478116d6.62.2025.10.18.10.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 10:17:58 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	brauner@kernel.org,
	corbet@lwn.net,
	graf@amazon.com,
	jgg@ziepe.ca,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	masahiroy@kernel.org,
	ojeda@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	rppt@kernel.org,
	tj@kernel.org,
	jasonmiu@google.com,
	dmatlack@google.com,
	skhawaja@google.com
Subject: [PATCH v6 01/10] kho: allow to drive kho from within kernel
Date: Sat, 18 Oct 2025 13:17:47 -0400
Message-ID: <20251018171756.1724191-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.915.g61a8936c21-goog
In-Reply-To: <20251018171756.1724191-1-pasha.tatashin@soleen.com>
References: <20251018171756.1724191-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bunguwomsof3xhjfufhq39ob9krpgx9r
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BA97CA0009
X-HE-Tag: 1760807879-49144
X-HE-Meta: U2FsdGVkX19IqUWZjwkMABHRFpkNBRxNarIVnBkBQLj2KLdvFfn+jAYiBf2Ar6kN7AzGAcaVkDj+/0b26ixkti+GOcfTYxV9KYteGkfQbIG/Kt4+FsKKZp54Ow7AqcIZJrKmyL9Eo0nh5023lk/S/x7XrILQqYRK1x35XbHghfeWu03gkuB48/vpWYaafcpBAE0HYAmDVTw1moIusKYLRAe+16mRtIc3I9vBsvbzwIjmsGTqstnQKNmeaeUvsRg2+CUyd5QXlgkjJgHMxRjOcQPhckUTKXulTDsFmMJ55zSY/kdH5hRpXjVS+BV3UXhmYTFeb5gnpzM/mT5DQBiubZ2iqJyC7B0Z0hrf7TGqVpzZRQNBcQ5n1fN1vMsBTnpCSzLpGvksEQeTWiNz2q/9vocS9pBj82Z6WpVe5Ed1ycCqLGTY6Nn7rKgvz4Pg58/psgq418Qf6gUgraIkSUqngd8Dy+dv8qyxnSqSaWKSOcdx4bMv3mlK6USx+MPLpCvupWWyLnbvhJ7Roj87uzGN1BI2DUJp/vB6FOqMNevXy3azjWZnQwLlkS//r5yKxBC3TbCr5dapmYb85XZ0ZUI6/HVQYE4M4MPnNigmWdZY8T/JFPJSqUwj0THAhG9GGXYqLs+Qv7UQDlvSkYY3HGtCbc7zLuUwGTVFH1Ykhg/m8yG1eJmgFFhUrNycICUWKhe9+Tb8vZBMDhYqpwBAqO/vZlI9f3f126jAq9woG9RMlMSf/Is+BRmB75l+T7bGXMKQ7ETY2snua1DnEWATNPA2pSKf6O2QzIpKNfNnyZHRUgHTupOok6Nz6LGZameKEqSEhDN+Dmmvgg7yDvLKvjoaxMqjmbT8t065K0wMxsHkKeOSQo/xzcmujf451FaASO3i6vMIasz3i65DjgYr/tRllTuZlofLxEqDC27G73TG8Uu8PHvCu8EejcbXrRbUVcOz96ldZPiVPFZUTNMFoiL
 /fkge7cb
 3YjHM3gS0AUCKvcWYYi8a+pLeobYf5QKZZ2FWwNaxSHKBmRcWbeaJVYCP30hEpyQMLX/aXx4loe7lXVRiUuAUe8v5CfDTuQ3TzUgUOWd/GMXxfOQd7ZaUVbi2/9rheOrgJaMYCThJWsSlRz3A2E3kGbBaPoDs7NkjeoTY/mL592ZZ/0zYzKcsaySaM5bXtNU1Pc3A7ta2FnFkeiC+1TkVON0vttZeMiLOqr7jtIlWT6wNz4gheXutwI4BFGTlLmlvpt5V3TSfuM4qcdVh+ppfzso897Qa/YaUs/CKDJh/qDHT8Gsw0asTlP0g3URq9qUea+u3wIbTKKzUSNJSPPBiVYi6uZrbdHV+9YfBiPWXxSKarzdn08UDo6ui2czfVBSt9D/d
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow to do finalize and abort from kernel modules, so LUO could
drive the KHO sequence via its own state machine.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
---
 include/linux/kexec_handover.h | 15 +++++++
 kernel/kexec_handover.c        | 74 ++++++++++++++++++++--------------
 2 files changed, 59 insertions(+), 30 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 25042c1d8d54..04d0108db98e 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -67,6 +67,10 @@ void kho_memory_init(void);
 
 void kho_populate(phys_addr_t fdt_phys, u64 fdt_len, phys_addr_t scratch_phys,
 		  u64 scratch_len);
+
+int kho_finalize(void);
+int kho_abort(void);
+
 #else
 static inline bool kho_is_enabled(void)
 {
@@ -139,6 +143,17 @@ static inline void kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 				phys_addr_t scratch_phys, u64 scratch_len)
 {
 }
+
+static inline int kho_finalize(void)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int kho_abort(void)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif /* CONFIG_KEXEC_HANDOVER */
 
 #endif /* LINUX_KEXEC_HANDOVER_H */
diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 76f0940fb485..76c34ea923f0 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -1067,7 +1067,7 @@ static int kho_out_update_debugfs_fdt(void)
 	return err;
 }
 
-static int kho_abort(void)
+static int __kho_abort(void)
 {
 	int err;
 	unsigned long order;
@@ -1100,7 +1100,27 @@ static int kho_abort(void)
 	return err;
 }
 
-static int kho_finalize(void)
+int kho_abort(void)
+{
+	int ret = 0;
+
+	if (!kho_enable)
+		return -EOPNOTSUPP;
+
+	guard(mutex)(&kho_out.lock);
+	if (!kho_out.finalized)
+		return -ENOENT;
+
+	ret = __kho_abort();
+	if (ret)
+		return ret;
+
+	kho_out.finalized = false;
+
+	return kho_out_update_debugfs_fdt();
+}
+
+static int __kho_finalize(void)
 {
 	int err = 0;
 	u64 *preserved_mem_map;
@@ -1143,12 +1163,32 @@ static int kho_finalize(void)
 abort:
 	if (err) {
 		pr_err("Failed to convert KHO state tree: %d\n", err);
-		kho_abort();
+		__kho_abort();
 	}
 
 	return err;
 }
 
+int kho_finalize(void)
+{
+	int ret;
+
+	if (!kho_enable)
+		return -EOPNOTSUPP;
+
+	guard(mutex)(&kho_out.lock);
+	if (kho_out.finalized)
+		return -EEXIST;
+
+	ret = __kho_finalize();
+	if (ret)
+		return ret;
+
+	kho_out.finalized = true;
+
+	return kho_out_update_debugfs_fdt();
+}
+
 static int kho_out_finalize_get(void *data, u64 *val)
 {
 	mutex_lock(&kho_out.lock);
@@ -1160,33 +1200,7 @@ static int kho_out_finalize_get(void *data, u64 *val)
 
 static int kho_out_finalize_set(void *data, u64 _val)
 {
-	int ret = 0;
-	bool val = !!_val;
-
-	mutex_lock(&kho_out.lock);
-
-	if (val == kho_out.finalized) {
-		if (kho_out.finalized)
-			ret = -EEXIST;
-		else
-			ret = -ENOENT;
-		goto unlock;
-	}
-
-	if (val)
-		ret = kho_finalize();
-	else
-		ret = kho_abort();
-
-	if (ret)
-		goto unlock;
-
-	kho_out.finalized = val;
-	ret = kho_out_update_debugfs_fdt();
-
-unlock:
-	mutex_unlock(&kho_out.lock);
-	return ret;
+	return (!!_val) ? kho_finalize() : kho_abort();
 }
 
 DEFINE_DEBUGFS_ATTRIBUTE(fops_kho_out_finalize, kho_out_finalize_get,
-- 
2.51.0.915.g61a8936c21-goog


