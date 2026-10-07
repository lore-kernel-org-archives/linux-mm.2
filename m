Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EB93CA6002
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 22:40:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 564F26B0095; Wed,  7 Oct 2026 18:40:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53CDA6B0096; Wed,  7 Oct 2026 18:40:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42A7C6B0098; Wed,  7 Oct 2026 18:40:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 17D6D6B0095
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 18:40:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 85690803DD
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 22:40:14 +0000 (UTC)
X-FDA: 85297299948.27.BBE1ECB
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	by imf04.hostedemail.com (Postfix) with ESMTP id DA07840007
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 22:40:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iAOLlJd6;
	spf=pass (imf04.hostedemail.com: domain of 3SsrGag0KCFcz067H6390zEzI5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--abhishekbapat.bounces.google.com designates 74.125.82.69 as permitted sender) smtp.mailfrom=3SsrGag0KCFcz067H6390zEzI5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791412812;
	b=xRCqFpIFUdAfaaShcixK0t27xolw1wtH09UCXwMiidvvnF3HUmyLa8mHEku3L9WhtWf2pY
	ujPzTrePVme7+Zw6Is1+ssEwHj0AZvzrDB7wglniIHsqhVu+jlEHTnnGBIRHaPcoe6bPqP
	vpKQQ4Tj+PimPofkg47zr94vu4ZgGWU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iAOLlJd6;
	spf=pass (imf04.hostedemail.com: domain of 3SsrGag0KCFcz067H6390zEzI5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--abhishekbapat.bounces.google.com designates 74.125.82.69 as permitted sender) smtp.mailfrom=3SsrGag0KCFcz067H6390zEzI5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791412812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9D5gsWzyCIxnio62hRxNUwEKaT5VZFEdzDbs5uZhd24=;
	b=g/F1752iazs+K+nBYySxOA+iR1WW24/IqVL7ttGIOJlM9CLGh09vuD7cXQtpekL2rJwcWd
	6q2Mi5CYkXa1DygkDOgq2EtwqgYgauawWYyMkU3nb+Y/8MyEdFBXAUjEmkeJkm2ZNpwKcD
	rFF/iz/Xvvb2mIJ1kD5MlxyhZGb/Mf8=
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-152d1363a29so7544895c88.1
        for <linux-mm@kvack.org>; Wed, 07 Oct 2026 15:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791412812; x=1792017612; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9D5gsWzyCIxnio62hRxNUwEKaT5VZFEdzDbs5uZhd24=;
        b=iAOLlJd6QXGYzVX4UorThzW9qHWLQ37Q4iSgn2yFXogdRIYOeOzruNukK/txgz4USX
         GlpW1ZbsmYmgWrL75c/X5OLpDKQFlYBWt1q13UUFZmeqIJ4SSchjZcA92LZDPdu11Pi9
         dhycFnSlMNK5uG9QFb/VgdyFghL3XmfnQ7bwlChkpf4/7z8fk3rESZdeYCCt+FMu5zb8
         YZjFqmckPj+C5mAJdaX/zmZMz4WPciQJfU88WcHXc4biTVo4ztXz3H4UNcG18lCn1dEK
         XGiRyXDxZUhEW6Wc9bGSjjrEmzY54jfswvjdLaOLd02olSSvI5ooNOeX5Vr813MuVMp+
         iNyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791412812; x=1792017612;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9D5gsWzyCIxnio62hRxNUwEKaT5VZFEdzDbs5uZhd24=;
        b=IAlPdMwTm67NT+IR2RR9xJaZCpL85VAzVPbtPOAlC9usyQhSWLYz57FrTcwzfZJ2w2
         gCSG9OpIkGRYCKkagMYSyR9FTkEl98tG+5FOHT2Kn1bSdqc8VeGyYtxBycnMwHcqqiC0
         X713T86vQ9yg96KF18pUiCS66vRFZTk7dYWZTzZ567VIQ5Z5F5aCnHD+lVejqdO69MFd
         mBtrdBbv2hGeq8I74BOprHuilG1oy0s3+FY5AzQgwITORsPgZeSJbu3qNWP5PtiluDYw
         F40FD/VW+GqbOuCxLbZrbA1pFG7fEQBOGPDQ758FljfHE9PVmSEROnS2qt+6wDCwzhaR
         kx6A==
X-Forwarded-Encrypted: i=1; AKwUvBzdZ+k5oG7BRqNe5lEpyIWzVM+QAl0avyN4ps947mcF+qBRI9QGWdOdbBmNReHCN0Zpk8C5PTIvaw==@kvack.org
X-Gm-Message-State: AFuF++ka+mvP1K+PtXsZOsf093Faeo3npuSOziuc7QFEv2fQ9nU2O0og
	qDDjZFiN2WV/xLTjdorqOGq1OiMCVgtRSP8WS9iPWLfT5ToyrwpxhYxAB72vPytqGmrxP26wss2
	AkhUM48v2HDVHcB5LVEBIFnhyuX0h3T4PNw==
X-Received: from dldyr16-n2.prod.google.com ([2002:a05:701b:4510:20b0:143:7311:4b88])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:f68e:b0:144:c112:5f23 with SMTP id a92af1059eb24-162071f8e9dmr5633509c88.24.1791412810906;
 Wed, 07 Oct 2026 15:40:10 -0700 (PDT)
Date: Wed,  7 Oct 2026 22:40:01 +0000
In-Reply-To: <cover.1791410885.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1791410885.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <aae089a81ea891e1bc7e3ad171064d37d800ad1a.1791410886.git.abhishekbapat@google.com>
Subject: [PATCH v2 3/4] alloc_tag: Extend allocinfo_filter to support tracing queries
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DA07840007
X-Stat-Signature: rag76i4ihgsyho57efz8fjt8hmumjyoc
X-HE-Tag: 1791412812-862805
X-HE-Meta: U2FsdGVkX1/ddSKcJJfcmLfq63EoBUMCoj5Bp56SICJ/fg1+nphIxSlO/eIpk8emStC7pNqESO70ENC0OhgEL3tCtO+b5+hkEygsqnyWCLCCArCRXgIJJYeDp6WKckwEi011LnZeMPHbAos9PBfncNEoyR3xYmo2M9BbJNnQkKAsYV97VIn6gDtOQ5AhfCLqTitZrPc+LsuXTForZZTmxflbYQ5MWhcsEOhFfKczltKlNNJMNIDLGtIzLqn1cDJnieDIZ0fZQjFN62pQfIVohNGH9B67DrwPMY2JQtDyxyjnuooUxpukT8gVOT5EQ3pzvpN45wPkO1mxJmuc15x80dElaKxjHlfYEMYfLd8c4iD1FcVrMAFnRsqdFXOYohb/m2Jxry5WgV32bwBnhyRkWZQGewDo9qZJwPb9DmA5j4O24R2nq1tQdVudRFxoYBpOYsq1hSqDsgzfziuekkW5Z+6wlWnAGsbamrupLq9yTTH3iHZ8bS7BB5MOoKbFxv2aj5KtHlUM7wygMJnJ7hJI0vxPr/naeTqeskf7pkZvIUlCrLgV7UpEHgxf/9S+S3m2GlBPG1ufpf5PVF7+DfKKstPs+cycV3AL8PsPL2T+Fug3cKdYn89y3ilgP82wLnTWIBW7Mjy8d3WSPDHskE8VUpkEAFUU42RMi84E7O8EuGoOsFrXL0q48a2rRXEBquFp+pEnINNS1+gBZDix/OuPHLiFjTDjkFrga/cGXbZ4yidTdP5fwPnM+AYY9ynIi8duv9R+XF3uN1orn5MPegnvSmI+HFL4PzEEmWs6IZViiMq+l9keJuGJITl9RQMkah+QSN5rK+VKoJuR1bAb0HvtSlcU3aG+v95JDkGEIU3gRuXSx5s9Rm50qgP3+c0Cgu5Sa8ORENDylG9SJF0TEHeGhSgo3aweL7N3fIYtTBP1RRsEz1RRs6n4fHiz/goa2EJY5mqvkB7ksrYe8LWpCoL
 zgKXHWZx
 8F2s+GA1zHPSHxA4pAdKOGrXvjq6IHMfAsDf7WWP9OFB8ybcgSJg1ZJjqCG32+EGYyQQuqIByU6ayGgRfGn9sZAkKKDJfgaS2rM+OB5uwQVqtx+BhWFC3dAGt8hGqoHUd10Fk9WsymewYLCNyrqe8gMUP1Nc7eOnrUCxNdtmVFo61CMqw1tZVS/NYp1xxDJmHFTey0LNMpWHoi3UMXoiuu9z+WOjigKdKTTk19roPB+07dBwTqK3moAxQ9TaKiQhrwDo7gLhCF2HaZAZWKwSnUhOeXYFbIC8t5Ak2j6K1IXsiaM4JXuPX+4LZ4jWSOcfdc4bfOShTwPftwoWZht3pWfvHzqT/veUEfPiJdZZITxDcGkHFxnKHysi6fHCjnGTFzCGK0oNJAvx9GUFxx584DzPHmYW+BsU5SiDEFyqr+0+s122yqz71FuQQRlIx/4GQQQMSUxyuUuAScciuP8bj+YPdp+zziZIOxzb/gmSC7UFNroOlOiS94Xt2A8qURT0YICvGyNpIqjTwmZdD4zHtVu+zGK7+TB+QAS8DAdGmc1hlKiHlxkzCz8F9YLm/5jR1xmbafnqGAZ7k+nmNE7iNwFpZtba8LnigaUlAea9T04tmW94z4j0rNgVMYjrj8boMz81nr6LY+sEPnCXfecUnytdSQzBso/ZMQtJdef9Eet2bxl4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend the allocinfo filtering mechanism to allow users to filter tags
based on their trace state.

Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
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
index 262f00f2bba9..8e63f347657b 100644
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
2.56.0.385.gd3acb90ef8-goog


