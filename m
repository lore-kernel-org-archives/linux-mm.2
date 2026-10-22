Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D682E606A31B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 17:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=M5fVyJMo
Received: by kanga.kvack.org (Postfix)
	id C2AC66B09A2; Thu, 22 Oct 2026 13:38:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C01B76B09A4; Thu, 22 Oct 2026 13:38:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF7206B09A5; Thu, 22 Oct 2026 13:38:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 82E5A6B09A4
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 13:38:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F2B20C0207
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 17:38:32 +0000 (UTC)
X-FDA: 85350971664.23.E1C80EC
Received: from mail-dl1-f70.google.com (mail-dl1-f70.google.com [74.125.82.70])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3CD11100009
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 17:38:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=M5fVyJMo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3FUraag0KCHAOPVWgVSYPOdOhUccUZS.QcaZWbil-aaYjOQY.cfU@flex--abhishekbapat.bounces.google.com designates 74.125.82.70 as permitted sender) smtp.mailfrom=3FUraag0KCHAOPVWgVSYPOdOhUccUZS.QcaZWbil-aaYjOQY.cfU@flex--abhishekbapat.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792690711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9N5nOe+oo4V6R+TK+YKdXm540y3qbeMY86DYHWBNfzc=;
	b=odhtufiV4Lyix7FxXDYu6tokxFNrqYiS2ntyBXNaXkjl6UhImD62+TaKc20uhpFduWzQlO
	JhA5JmEXCCXuwfw4j4BKEiAtVolsuJK+fc/TQPL17mUtuTQoYLq+ONN2nvmfqdn2wET76K
	PKuuS10E3EfbBClgZSDzxe8dYL2DeiI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=M5fVyJMo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3FUraag0KCHAOPVWgVSYPOdOhUccUZS.QcaZWbil-aaYjOQY.cfU@flex--abhishekbapat.bounces.google.com designates 74.125.82.70 as permitted sender) smtp.mailfrom=3FUraag0KCHAOPVWgVSYPOdOhUccUZS.QcaZWbil-aaYjOQY.cfU@flex--abhishekbapat.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792690711;
	b=m7KBqjis7IjibwNoON76r6n6SeHQPaU8EYLmPzyXpm8sJ2vsUJROLWfS6lK8tnYXg5rgkN
	QKVVtZ3jOBuBWOfs64sn2mMtE615CM1wbuugfGsGZT1UvTYIzD6FCgbf41ZWDWVtoV7ldd
	ol4c3uCx5CWI+eQKW7yTWVnRijHPDnI=
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-1383723dfddso16554c88.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792690710; x=1793295510; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9N5nOe+oo4V6R+TK+YKdXm540y3qbeMY86DYHWBNfzc=;
        b=M5fVyJMo3rNoTsQlUk6gq0DFuPTk9SjQt/NcRsD3AqZsTJnzYtgE5vdlMkl9ZcER/k
         PURz6eZO+8l1DjHM0TP+fA1osWeEm/fZgFq4muqMLkZSDp1pS9wHNPBVf8PP7NGKJR0K
         bjODdOkem4U7LHDU/AWfQ+8GXwGJ++htuVK9Zg4dRYes0G/uo4ZhfXfwCfyj/usW4iHi
         nt1dw7Y85jOJAWO912jsRkR0kfZDFRuFgYM1kEPJ700UwHGzDiMhO6Xr7rnInZN/CE9r
         htZm4iuDrPF5ITTtCNoDeEAB+XtUI9HmvWBRbxPGCB2bjF2fA+/MT2sXXVzJTgCTHaWk
         JObA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792690710; x=1793295510;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9N5nOe+oo4V6R+TK+YKdXm540y3qbeMY86DYHWBNfzc=;
        b=kIDH5+hwJ85bXSMaCxpeShH55F8YGJ5Zaw2qW4BP2q2nxV7ujp/uIrA201NWtqrZyq
         2hhrcyTCbdYpVgVKsYuPmw1CiwwBDvPWUuxOBH0KMsxJ0h+XrAzIhZ1FUb7VLU9wq4Cx
         6UCKeCazvS3725e4cNG47E18lCAYydsuE5gnv41u0U1M+oQmbAOtnO0M9IB8ujrxeGoX
         8gMkRViF+9XC7dlsi3W4wDwTY5jSgyocSYb7iV4QpqJWKe5J/AB5/UVaRIEFGhqlpOiY
         AxIffwpjvryhGNBR2fE9kCc1JMMRqHQunyWx6+mGpsQcTNL/0kyg2EjeUs68aW03Jx9J
         mXjg==
X-Forwarded-Encrypted: i=1; AKwUvBzW4WnREbiZYj0DVaZx84dfsdVVIfl/nEe4hdW2mDfNrBc4tEPeC/Xwg4M+oVz4Ryd4i4Z7aFNiQw==@kvack.org
X-Gm-Message-State: AFq9FYKipRFq1C5hlSC7SHNdxYDPYhj+7ixZeznUuI/rCNHnxsVReMAu
	uM/zvXBELjPFTKbhX5Hejw8wKZhu1jPzycCgr5PLPclC6rdqYenWvWfkdYqyz68yqAOmjdzDsGO
	kVxGd35kEInhuTjsJwcbAKNukAypLCO7GQQ==
X-Received: from dldz19-n2.prod.google.com ([2002:a05:701b:4193:20b0:163:a42e:b837])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:7f14:b0:151:6e80:ba7e with SMTP id a92af1059eb24-1909fc7c7e7mr6852867c88.4.1792690709680;
 Thu, 22 Oct 2026 10:38:29 -0700 (PDT)
Date: Thu, 22 Oct 2026 17:38:22 +0000
In-Reply-To: <cover.1792690544.git.abhishekbapat@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <cover.1792690544.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <f577c773058265f0eb7fe2c10fb6aa4003445a00.1792690544.git.abhishekbapat@google.com>
Subject: [PATCH v4 3/4] alloc_tag: Extend allocinfo_filter to support tracing queries
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 3CD11100009
X-Rspam-User: 
X-Stat-Signature: tmpzn3nw8fhknu9td4kc4tjie1ggsyur
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792690711-381240
X-HE-Meta: U2FsdGVkX1/40Iv/ckGVndQ9Bu3X9brlzto2OcwQm3NPnWhwxdVPyRPEFqWdOpMPzmAJucpJ5A63iepxZEJ7P6D44G0E5B70ZZ0S1NS+5lwpbi9lMHXcDZrKtM2ONou0JFwMW0DalndQ/pN2MGealHalfMEhgMVI9NEE9X8G4xRmR8+WgyJKUT0O7xMMlKsA+hlNKoX4N11ZCJ0PWX5qvjoKd3jxRMxIXUa59yKmRU4Qpn6WyeXL6jutOGb5iRFT2VSgewU6gj19QdVVWPCT9NpaXikLPItnBLbk4Pit10WibjfgYADpjgzqLLat8wuGMPzQx0gbn8uLrYPlKl3r7ikFmP5rifVtstys+vE4JRyJ8OSGWEAwBMTtuo9AVqenvLCUTkBe2RV3g9KswwEHq16N5gXtrbLKxLPzPMoqKp6ncYQq9Rru/ewkhElC/HqoALpYpUVZlWtxC3RofrlfE6SxNKNhNlyTa+7XNckqlQy22NvBgFZ1pt/JwBM2T2OQKBDhLOFge7cbd83cpLsdRNvq+4bmqeaF+hMKReN/Xw3ORtq3xwTxQbW8ctxy88r0oi7cWaq8EJIfVwY5ZFDz76l4GBZfggJCLRGB90j8CZIFCG5GyGw4+bFZC5gTv326VsfSuPmEWHavybyTCC3Hche7yk5zZfhK6BKIGTc3CDMsLXV/FaP1GOGDrNCZYK7+/QZ0OvzzeKGi8Jh2OKXbn/0yk3x0r8Sl9iZh1j97U/pcbxOhWckoUBxSz7jRvhB7NDahiV+t0Ss15/i0i9Lw2LY2Da8WrLvr2X/FbXRV9ta7wccewOwpHZ4NRJeavPQLv6nE+5O9P3YXdINoNInJ7od5g2+PolUO6onoufX3ljZrp9Bckb1wChOuYJ+KMAR+XxjZcfpD9vHBd4rFHtuKeHCptarPWBGcygnpvs6KNVj5TxkK3TWFeF1XmibxtJP868Uf93gAQ27N/02SHBl
 3YvlVvul
 KTI3g2Uu59LG5kMbuZV1OULmVNQ7Q5WZ6PGmCPyU4muWaZDB72ik490gCdn72rcR/UiPK0s7J2XKLRfQ02Zt3OMfkix8W3CP4p0xLYIt251ywUqlxGUyuLCpHKMEo98BbfNSjQbbwmrAJGzlPopxFiKeuTHc72Uwy1b/Xq8xyVlIfHjPnVBxjQFPwKaMh0otn8N0eddfsVQfbEq54sTtWgCiz7Cv7pf/WZPJIZKc8bXY9bvEE4G5ivfCCLsTvWtIXLqrY8zHfj7GOPzBsw2c0NTp23JsUrZ477nnsWUFsXtsrYNs1ay0/bTeO8yFvZqBj8nTl1w5YztQS5332a5MJT3Yr8SynMyuIPXZgac8BI7VFiOnoaybWtwaqG2jSOrnS5LfM4oN3dVgfhltOGomc/KHFhU4m57YyxTfQCQ5341mgkW3POFpStcIoB2Fc+Zx219hp/wQtrYyzEn4sjVa86VyETg8x6riZYb3qugFr8yfhKYhad9RnwNbBWrmghpkkgZx1fwDsCt0+GE43bCafTUnCY5duujrJ7wHAECh5lYnvGLGv+Zbl3iRXZkqJMOMpcDKEnUWNkxyoYPpdlVmsc+FJEG26lOXOuZaLT965133BVVxLBg+lfqwuXebJMFCvpmuQ1QnI7SEshIzYqFWKzKcDIkPGKo+JrtBTfBSJvHkpqsg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Extend the allocinfo filtering mechanism to allow users to filter tags
based on their trace state.

Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Hao Ge <hao.ge@linux.dev>
---
 include/uapi/linux/alloc_tag.h | 8 ++++++--
 mm/alloc_tag.c                 | 8 ++++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
index dafcba2f7e2c..a96054ac2237 100644
--- a/include/uapi/linux/alloc_tag.h
+++ b/include/uapi/linux/alloc_tag.h
@@ -38,7 +38,8 @@ struct allocinfo_counter {
 	__u64 bytes;
 	__u64 calls;
 	__u8 accurate;
-	__u8 pad[7];
+	__u8 trace_on;
+	__u8 pad[6];
 } __attribute__((aligned(8)));
 
 struct allocinfo_tag_data {
@@ -54,7 +55,8 @@ enum {
 	ALLOCINFO_FILTER_INACCURATE,
 	ALLOCINFO_FILTER_MIN_SIZE,
 	ALLOCINFO_FILTER_MAX_SIZE,
-	__ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_MAX_SIZE
+	ALLOCINFO_FILTER_TRACE_ON,
+	__ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_TRACE_ON
 };
 
 #define ALLOCINFO_FILTER_MASK_MODNAME		(1 << ALLOCINFO_FILTER_MODNAME)
@@ -64,6 +66,7 @@ enum {
 #define ALLOCINFO_FILTER_MASK_INACCURATE	(1 << ALLOCINFO_FILTER_INACCURATE)
 #define ALLOCINFO_FILTER_MASK_MIN_SIZE		(1 << ALLOCINFO_FILTER_MIN_SIZE)
 #define ALLOCINFO_FILTER_MASK_MAX_SIZE		(1 << ALLOCINFO_FILTER_MAX_SIZE)
+#define ALLOCINFO_FILTER_MASK_TRACE_ON		(1 << ALLOCINFO_FILTER_TRACE_ON)
 
 #define ALLOCINFO_FILTER_MASKS \
 	((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
@@ -75,6 +78,7 @@ struct allocinfo_filter {
 	__u64 max_size;
 	/* filter criteria only; see allocinfo_counter.accurate for actual accuracy */
 	__u64 inaccurate;
+	__u64 tracing;
 };
 
 struct allocinfo_get_at {
diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index 9ff9dd04d692..0d4d267c065f 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -250,6 +250,7 @@ static void allocinfo_to_params(struct codetag *ct,
 	data->counter.bytes = counters->bytes;
 	data->counter.calls = counters->calls;
 	data->counter.accurate = !alloc_tag_is_inaccurate(ct_to_alloc_tag(ct));
+	data->counter.trace_on = alloc_tag_is_traced(ct_to_alloc_tag(ct));
 }
 
 /*
@@ -323,6 +324,13 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
 			return false;
 	}
 
+	if (filter->mask & ALLOCINFO_FILTER_MASK_TRACE_ON) {
+		bool tracing = alloc_tag_is_traced(ct_to_alloc_tag(ct));
+
+		if (tracing != !!(filter->tracing))
+			return false;
+	}
+
 	return true;
 }
 
-- 
2.56.0.257.gf7497c7d27-goog


