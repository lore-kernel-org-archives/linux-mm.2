Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05EFD606A335
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 20:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=T9CXe673
Received: by kanga.kvack.org (Postfix)
	id 3AB726B0362; Mon, 19 Oct 2026 16:00:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35BE56B0364; Mon, 19 Oct 2026 16:00:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FCF96B0365; Mon, 19 Oct 2026 16:00:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D853D6B0362
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:00:36 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 56F33160882
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:00:36 +0000 (UTC)
X-FDA: 85340443272.18.9782826
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9B7D3140006
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:00:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T9CXe673;
	spf=pass (imf09.hostedemail.com: domain of 34HbWag0KCIUjkqr1qntkjyj2pxxpun.lxvurw36-vvt4jlt.x0p@flex--abhishekbapat.bounces.google.com designates 74.125.82.197 as permitted sender) smtp.mailfrom=34HbWag0KCIUjkqr1qntkjyj2pxxpun.lxvurw36-vvt4jlt.x0p@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792440034;
	b=usQl1e1NSSmTGtqO3OTTEaWS6kPZ4nUpY4t9KsAxQ2ssN/+GVycuo/3xE9IRVGLxRWzZ6S
	qgtIhje/lINJVTyZThTQGrmclpiBoQQN6SA3tankJUlaDo4+jRSRrysvbSEAbg06eXpWtv
	/F7B3M92VlFpTdeZiMPfVjl1vfx0rC8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T9CXe673;
	spf=pass (imf09.hostedemail.com: domain of 34HbWag0KCIUjkqr1qntkjyj2pxxpun.lxvurw36-vvt4jlt.x0p@flex--abhishekbapat.bounces.google.com designates 74.125.82.197 as permitted sender) smtp.mailfrom=34HbWag0KCIUjkqr1qntkjyj2pxxpun.lxvurw36-vvt4jlt.x0p@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792440034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zv+ACCU+gHv1KzeJikhPVLg4kdjDOuVU4kYmmf0PDRA=;
	b=7R17XQdKdeA5jqYjnk+luEFI6xUbCEzvhp0h6cqYoOYI5i+sfbVagOvJu4kb/1/ZRgKDV2
	oiaOZ1qNKBTS+Hk86EFAEkNUrvl6bhw/R5GbjOYVqORNUPon7Tde+xVsnTVqR0JsoY3N7u
	BO6zN7Qo1jU3cqz0uZgJ5kpGRdcmMZc=
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-33713e5e6daso3639542eec.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792440033; x=1793044833; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Zv+ACCU+gHv1KzeJikhPVLg4kdjDOuVU4kYmmf0PDRA=;
        b=T9CXe673K1mooWHzsYK8H+8DNFoCvyuOWJO7pVljR64mpAVVWnY8ViNIp7vMEIG7Sa
         8ETplNNNEsx/1COQ3gDeOfFcvmINJapdexChDC2aprdgh8f7V1IECZm0Hj46YBS0Fso5
         IKDDEHowMaInf0rkYxNVN9biRmNVswkPciHEXo2KxoFO1nJteOoIXfUHhYMBxvPJG90m
         vhTUgabvJs5zxZA0NQlM7xmtCM2FBT/Ao/U5q0vzUqLNgzSBENQtzio7LGtdeC98Wp+v
         bjqDrTE1sWLPj8331cEsnU85ZbD3KjTuWhL9eDTyRu3gT5onOgwdicCtdNfJj0kSSggX
         Zgvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792440033; x=1793044833;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Zv+ACCU+gHv1KzeJikhPVLg4kdjDOuVU4kYmmf0PDRA=;
        b=nLTQBAc6X05tm9rKni2hm9apPF+EVJY4flC+Moq4oQE0nd2FEtZ4YAAmHV8geG2gAD
         4aX5z/D3T+GDB/ziF06VdJFPVJSzeZ3pVsuTDIPaVAq4gml7cE+rj5Pu7FVs8vs3K0mK
         7mm/TILxFMLj4IQu3wvOsBPSJ098Ig6BvBxdk+l3CaZZ0c39tCs0QsjatamGoebe3mZr
         WbiYVNT+x1GRdyf8+G1izd02BHVAhjFuVkoxL6Tg2+lWuvHDWBdHcXnPGveXepLNp4Ot
         Pe0hHYp3MfoCIwlwU0dBUsr2yeAXapEYVryUqJtHOmZEzd9ZwAuIi9OkAfKqnxPa78xt
         lqYg==
X-Forwarded-Encrypted: i=1; AKwUvByuFtumSg/deQNOrR7QZf0jL16kGRTQs5nXJbp50wYz16/uWZPkL9pj+BLhg9V4vcmty55/uE57hw==@kvack.org
X-Gm-Message-State: AFq9FYKHX/ZjCUUVM2HvrO6uXPr96L0x7TNUMNMe3p2QyC8KpTnxu66v
	I5ZWzGG/HwFDxfRSviYz6WRfak64TVfcKNO8yZGw3+3i+XKEcQx4aNC9JxyPaRAhZ5IDH/g/fAV
	T/yPtBC2b/TL3F2FkK43OhStCsXGbQ03Gtw==
X-Received: from dlbts20-n1.prod.google.com ([2002:a05:7022:b054:10b0:15f:5ef4:b896])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:701b:208a:b0:168:fe32:35a with SMTP id a92af1059eb24-18512296a20mr11988623c88.20.1792440032834;
 Mon, 19 Oct 2026 13:00:32 -0700 (PDT)
Date: Mon, 19 Oct 2026 20:00:26 +0000
In-Reply-To: <cover.1792439751.git.abhishekbapat@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <cover.1792439751.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.56.0.218.g1ec904b173-goog
Message-ID: <9e49a8f68e4e7d25c5a9a73c1926f68e468ef320.1792439751.git.abhishekbapat@google.com>
Subject: [PATCH v3 3/4] alloc_tag: Extend allocinfo_filter to support tracing queries
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B7D3140006
X-Stat-Signature: e5o7wkxcsq3u1pciq55zpouuq7zsxfh9
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792440034-107560
X-HE-Meta: U2FsdGVkX1+8CIMSCAZG+RDEpfG2qQKPlbUDu4rbjNeGQak2TXCnIBNDrYbJm1Ww1ZX12X82JIkjouhiQSqmt7CPbs4LtYSWUQtpRWFkI6GsHiNWectv0vSW7ir7v1u2UdEtbBOCPcIElQIDgzNJwicZKFtNPDjdTNZSMENPtv56ADAEAAQY6Frb/o5kG1X6kLEbYdJpmVZC0EclBC9n7Fqa45HzfPlONRee/trO/v9QVtOqjc0l3sYoLbuN8c1cRgALwC9iJXkwKTAGzMXpXvAsu3DrtDswVCwkp9vSmC3MlrrwgdfhUtzKBjhOrNGsFnEdaAAYMhyKajQLCFNsvcXP1S1lYfDgcQ5OnHWt/+M7JW3Cg5k2Ehy08cAOfyMJY9Ed4oWicA+QHz1ft0Cxk4+W1XtC9UNv+lnN4/gWy5zAgUBhA4cQxrPmptcUZXQQKmmfrPYHC8EdpVrbNvOtnnhZ3a8WmFrDMDJbFqaRHI4lZpWruxWZbTg6TEa8t1aeCiAoMJzVR7vQ/X+iEAMQQJC6GoQGhwagv7vTcAGjV614Ext/NEYAXBs+8LtlHlaaNWN9wmFtm06ATO7SN20gcc++AiiziNbLKXR+/ZsjXLQUZcUCCqJS/ShZLHEr6cIcJNRjKkkz30go/yzTeI9oKgeKcJHR55d6n3HStAop6GzGPkCP96+CxL8naO+3e6MLYKOnV1tNmr8FzUth4auGRRe+nMqzKNjRiPzDNrb4BFEnYfLHFVDI+qbvbBkDq6/Yy9KoAV4UqafmVQoJu7EebhkYrdb3QAyQQ3rHIHvcJkpKNMZSeELeI5Ab3v0YbYxS1+n/hPlM2Xs8pzpgvMvmy7HZcWJMrEjd8/X6ruZqpAKZA4DGudKGyfchOPKix2HrbDtu6s7gz3K4yi1Bvliabd16AMAVTmlGEgpD44cT3RQZJVieQBnS7mP8uSENdlEM0uDEH1pkeliy0+F5AML
 Zhpasp8O
 saJX8Tzbo1Yd1+EUgwA5XmBNRdmJrkoVHFFFtOzenLJZNK9/2QhNfIzxVT/VhSUEKcfwQWr0yG5UhruDsvD0bX7n7BHQR3plzOYc/ScbdANJzCJ6wLl+vNVz4X1+HbxQmh/121wggVGcOK+qDG6GMNSupLUiXnAbHZptUYueAuIah5rDDr/FpQjZtXIhtg1sU3nWUU3kUcsuIyB5zVemh7/aLCUzvStBWzHjeY0pDCuL8CDrnpk0OQjpI4FC0JUdCwiD7dgO8K9+zOz2QSUp0komKZzv1etDDalBLgnBKwqEVCXpgAZ3pKHemKRiaop+WOspPXf2zqmKqnXsVFjgyeiOF2Ty2eaoN01IkkFrDT56zxSX0Xaws1FQ49nUmV0veW0GTrw+bWtC+bC7pAKKTyQ1U2YfuYmcp3cKdRx3zeAzHpdJhHMV8rMb6b6EdZHNH30HNU7dvLZcl3wcZApTLtAMpvKn43PSaWVheFmSp5/23jiJ63tjGiOzLXC5WcSX+4E1vw/6BH05rwgcBCKJu6UYg0mhs1p+Fyalw2mTlgLxqZ9fDYcovRxS4QVDmc+rzVC12GRS7nWUx1CiN5r0k0EGz0BcNrR8HrboypI8fq98dfTB+pcepjGiHjVABQE0o+teOZ/56nW0YscJZRmNi58Z5/064S6B4aORtzEBk2SsM4B8=
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
2.56.0.218.g1ec904b173-goog


