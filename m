Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00B82FF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 23:36:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A5BE6B0096; Mon,  4 May 2026 19:36:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56B326B0098; Mon,  4 May 2026 19:36:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45A576B0099; Mon,  4 May 2026 19:36:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 338E16B0096
	for <linux-mm@kvack.org>; Mon,  4 May 2026 19:36:41 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C2ED5C175F
	for <linux-mm@kvack.org>; Mon,  4 May 2026 23:36:40 +0000 (UTC)
X-FDA: 84731349360.29.C762B82
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0CE87100007
	for <linux-mm@kvack.org>; Mon,  4 May 2026 23:36:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tBJ5wokf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3hS35aQ0KCBw239AK96C32H2L8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--abhishekbapat.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3hS35aQ0KCBw239AK96C32H2L8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--abhishekbapat.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777937799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vwKDNFxCHplCHNXs9frgTkD+bqZx+jlVLXfcJGvps6s=;
	b=P2yNE7PVjf1F9hEnE39BFm9o3FKS/NyhxYTFUfoIBJ3oI95B9ze5cUwj6j4je0CZ787LKW
	o5+CG+cPLxLav5Rp+H3Kviic+w+N9W3NUfXTojLDxhT6lvoejnm3SzYi3jrqXcqSOH12dR
	BSfM6hDKDNpffLLjV7ShrCyGbEfeLfU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777937799; a=rsa-sha256;
	cv=none;
	b=hTzRyWNAoP7nPLntA1kdlMJD1ZF6H1W5Bgb5TcdvNI/UjR4tZcBvPoACr+Hqnj7WGs3ojH
	U8ar2T3rzapTYlnLbzotC7oIfpC4S/8Me8WZiJ0eGnjd+X0hmGKTcweOEABlcz7WEVq5rd
	zLw4yUJoxuzLcXihOQGZFHL1shWR79s=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tBJ5wokf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3hS35aQ0KCBw239AK96C32H2L8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--abhishekbapat.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3hS35aQ0KCBw239AK96C32H2L8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--abhishekbapat.bounces.google.com
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2eebb099efbso8254179eec.0
        for <linux-mm@kvack.org>; Mon, 04 May 2026 16:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777937798; x=1778542598; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vwKDNFxCHplCHNXs9frgTkD+bqZx+jlVLXfcJGvps6s=;
        b=tBJ5wokfqqH2sONP47bYyHCAwy0e2//cZ6k0EZziNOMnob0Sj0rkOmTFGJ87PTIC5K
         /QavgWZuOQwAGtZuAkbpYP1NRU0pph4WHPOd5jTjYzEeiOHaHLAosgRiMm/C8RkeDdbY
         FuleTjVDOpzDvBrD6sfn/HWUGDTk7PQdkjOBGTLEeTDqEXTDd6gIiZsV1UQ3cH2luVic
         ziuAgGe1yhsPY31DE+4BNPSFt4du+qVI12h//GZCt4bU3+FyA5hu2hH88jCftnn4x7JF
         4P/jsIB0+mVryJfVdJ2ieiE7Z7cT3hHykc949WmNACV7ZqChHWuT/ZHIpcJE215wVpvs
         4hrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777937798; x=1778542598;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vwKDNFxCHplCHNXs9frgTkD+bqZx+jlVLXfcJGvps6s=;
        b=WQT6LecgrilLQYPUmvIQYb4ys3pMn5zH0YfUwCBhkczRcydL2T+aWqYqDg+vK3DXsA
         h3ZddsC6L/QqwFxPLmTqNcdPp+JN+D4JSe13tWR2EmchIJeRlKRS9ZhCdv2byMRwTz1S
         5fqTf2THDLXt3f//sNoldiiPF6seShQE8ljSexjg2Zz9zQdwmB3M5Z492+2D5ao24zen
         gZz/J9CoqLF1frL0EK1M8C6j5eCxn9LxeXDp7nCpAzddcfK2bmVdqRlIBTnkWPEid2DY
         XsDTkekDCXTmMXiEIIQ6K/VlNWjBUk5RvnEzgKlsMy7JX4BJqkai2vSmTIi98FjCAG0c
         OpSA==
X-Forwarded-Encrypted: i=1; AFNElJ+YPP5MF/gyYUIy8WvLa/isq+BKBAN0aUaIMnV12twXkjQRJktgahFT/Gpe9IMIzle5AudjXfJalw==@kvack.org
X-Gm-Message-State: AOJu0YxmUU33x/ZFcOKzhSV0NStZp9N7BqYerHbCu3yPgMYx8s9x/c2f
	Ee671n3QzwRpL6f0vBn/Kj0orSenYOnNvAH1ZVL6dFkKPFjGy5Z4vbaKR39LBo4yZrqAWwHbNXS
	NygU1dKtQuQb8L5lvDxoXScp7OpRuGG3l0g==
X-Received: from dyctt4.prod.google.com ([2002:a05:693c:3e44:b0:2f1:5dbf:fd4e])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:fe0b:b0:2e0:4edd:64e4 with SMTP id 5a478bee46e88-2efba178867mr6138179eec.26.1777937797656;
 Mon, 04 May 2026 16:36:37 -0700 (PDT)
Date: Mon,  4 May 2026 23:36:22 +0000
In-Reply-To: <cover.1777936301.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1777936301.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <3d6ba4a1b49489b8138a4736704fccb9ed00bef3.1777936301.git.abhishekbapat@google.com>
Subject: [PATCH 4/6] alloc_tag: add accuracy based filtering to ioctl
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 0CE87100007
X-Rspamd-Server: rspam04
X-Stat-Signature: pqow1ztcaqd7t46m17ohagtcccq6ua89
X-HE-Tag: 1777937798-884607
X-HE-Meta: U2FsdGVkX1/G5OhPzNJlcOCdsQP9VbZoVPUywkxSAxA7ZugyQMn4XmUMMszVuyresiokEq8AlT7CHSgU/W6XfAaxBpczOFspO1eFVqT4eiF1Cc+Tr+wPEmX6VMLVBaeAAW5UJWlu0+DhMLo/6au7sobPEFN6jiwNlS1+tsJPAFQw0JlunsbLau5Fw2uOrxj3MXpqvGMfpefoxogpdycHx3JzDv+HNHbbYFfIrSNjQwdC04ZB4fjOzkfdPfIcFfLq29nk+AN9OEEpG7OZ26XUTWDm2RMS90xODaYbpPUxrCryR16fSp+ncnh1Si3IuUTGhT2zEToZfYHO89tcpAMOZcbMPF9S9vNFGaaJd1m3XrdiI0C9j8zapRklKQALw6Yf8AoYFH+TNnqPbhwQV1KNcpRU7vd1qazk5L/vjxEcg3oaUTXjxKSmcI9qvz4b9JQ8XyhOGKLJbAGFDIMq7fv/B5xjFpdakQY3uOGopa1zErueH56aL+oS3T5ZkiqYmvsuBM3o5XhXsoctAKfLL/4OHJVHbf1K0LJYPb+eJYhaxV2/MPhUSpUrsiaiUG/x7pKtzxek7U1qRWrNOnMCzZqdhv9p0ZbpdausvaHNOAqpO07hXTUAZ9j1KPx1+MTqtNYzJGZ6naYn025eOATJX4RJrLhD3PIVUnx01DcBqhOp7usBmsL5OYEiSwozMjguxEquJJCPz8P9Pp4Bde9hDFPsOPkF3XGAGRaSaR+yAubaslr30iIICPvghYs8vB4ul6aN+PKw3HW/A33OYhvGDU0HSxoEsmhPMK+qe74Q8sfNDetEwQ/KTHo9hEUhDGQrRIbiqKzsNli8LpPFAWSiPxJVJab0BKQSW+O1Bn/kdkrdQ5As5TmxE3PjkCFT9qYRoxlsQuXqimVdJGft9lBwv0kikTSa81Q22i0/e+q8+aXwZudJorKuOaLGNL0+d3QVIG38P0w7DGyqdh8rSVmPdr0
 s05MjYYU
 SwI1wJ2kqg+R0Mzwv22smDX/v8T76ANp9iPEkr+EAkmCHG6C9ddVTXg842pac8+PLNF73e7ndHCXEI7SsVwRUV9pFz4mkfxQduq00ZyLnV+Ksw6zJm37mHeBHjTmduZUkEFJ/PViZugzLbm0N9oUHoyhXREwfzej3kd5n1/Y8LNsiFdNz2qTE7LozecvZmaZkTQcOzX1V6pMb2DqCKe5cheS6h/6xnP7hVXpxqJW+IBgOkzp6lW8NtEW7dDXwZkabrqv40++//DY2UjPbwL1iuHnIdgZMzKWZc6EkQ0M83JOLsSatb2Qn81tsssHk7huk3rdEm+LU1VaqUfcGHtn6VqGl59rIwDcd+TtPCFjDa5hozfv2d3txhYVkWsPNrIt+ShUDubCjdU7q9lNjRG33TyWo0BcUmg0YlcDvEJDW6R+9bcDRNm/mcP1xTq6YhffGuyZnb0R251WThek8vyjAgmBOXJNplxWAEUHpCPh/MuSuALLObpdPTxYNhhMJnAcLM/lIZXtbW4BY01MJC95CrJeht78jhe1edLOHZgux4DFCotZjhO6M3tc0cD/NUi4iKJrf/rXw6FS4KPwPH7gYUcZTHTcHgf5i5BVfP0cM2vY3PAIbHy3QFPGAygbZow4+TTRzbnPRRomcmp4iIz0uAqwVbs1VhYnO7px9kqVTZvCuJsADF+Tmh3L0ZuFlNs2W4yg+YXwbu3HzhBocTsS7BCzlrHPrZj8aJ/74i40hZx662YzG+MA3UmQ7WA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend the allocinfo filtering mechanism to allow users to filter tags
based on their accuracy.

Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
---
 include/uapi/linux/alloc_tag.h | 3 +++
 lib/alloc_tag.c                | 7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
index 229068efd24c..99dfe951b185 100644
--- a/include/uapi/linux/alloc_tag.h
+++ b/include/uapi/linux/alloc_tag.h
@@ -20,6 +20,7 @@ struct allocinfo_tag {
 	char function[ALLOCINFO_STR_SIZE];
 	char filename[ALLOCINFO_STR_SIZE];
 	__u64 lineno;
+	__u64 inaccurate;
 	__u64 min_size;
 	__u64 max_size;
 };
@@ -41,6 +42,7 @@ enum {
 	ALLOCINFO_FILTER_FUNCTION,
 	ALLOCINFO_FILTER_FILENAME,
 	ALLOCINFO_FILTER_LINENO,
+	ALLOCINFO_FILTER_INACCURATE,
 	ALLOCINFO_FILTER_MIN_SIZE,
 	ALLOCINFO_FILTER_MAX_SIZE,
 	__ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_MAX_SIZE
@@ -50,6 +52,7 @@ enum {
 #define ALLOCINFO_FILTER_MASK_FUNCTION		(1 << ALLOCINFO_FILTER_FUNCTION)
 #define ALLOCINFO_FILTER_MASK_FILENAME		(1 << ALLOCINFO_FILTER_FILENAME)
 #define ALLOCINFO_FILTER_MASK_LINENO		(1 << ALLOCINFO_FILTER_LINENO)
+#define ALLOCINFO_FILTER_MASK_INACCURATE	(1 << ALLOCINFO_FILTER_INACCURATE)
 #define ALLOCINFO_FILTER_MASK_MIN_SIZE		(1 << ALLOCINFO_FILTER_MIN_SIZE)
 #define ALLOCINFO_FILTER_MASK_MAX_SIZE		(1 << ALLOCINFO_FILTER_MAX_SIZE)
 
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index 98a27c302928..576ecb3c5b6c 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -197,6 +197,7 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter)
 {
 	struct alloc_tag *tag;
 	struct alloc_tag_counters counters;
+	bool inaccurate;
 
 	if (!ct || !filter || !filter->mask)
 		return true;
@@ -217,6 +218,12 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter)
 	    ct->lineno != filter->fields.lineno)
 		return false;
 
+	if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
+		inaccurate = !!(ct->flags & CODETAG_FLAG_INACCURATE);
+		if (inaccurate != filter->fields.inaccurate)
+			return false;
+	}
+
 	if ((filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) ||
 	    (filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE)) {
 		tag = ct_to_alloc_tag(ct);
-- 
2.54.0.545.g6539524ca2-goog


