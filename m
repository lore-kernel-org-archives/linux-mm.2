Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65264C87FDA
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 19:56:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01BE26B007B; Fri,  8 Aug 2025 15:56:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F04BD6B009C; Fri,  8 Aug 2025 15:56:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E41606B009D; Fri,  8 Aug 2025 15:56:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C20836B009B
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 15:56:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7D1E9C042D
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 19:56:01 +0000 (UTC)
X-FDA: 83754646122.17.23A261C
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf05.hostedemail.com (Postfix) with ESMTP id A3755100002
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 19:55:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XHIdYuyT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754682959; a=rsa-sha256;
	cv=none;
	b=0BrVMKMi5CR08Ao0NmjUUYZ/pDMO7qYHCs5WA1zFOTmhgwyXteMkCGlyzQHFtP0Ld7xmuF
	CcbcAwol3z9zKo2Q7CrA+A1shw9raz/BftdYljm0EU8Lm646Z8JWsy9sNQuvsoarddvlMG
	d/k5qK4kGfnJXWwxlW3PEm/iyavPuTk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XHIdYuyT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754682959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5J4Fi2mKTN/GdQ1NmR4jCj2VsL5TUv9pVfPKW/me6N0=;
	b=yau30aFCcC0KqlVWCzA6U4lb+ZAfisOhXoXB26SXqH2mE3JxlUPTxub5kp9LrT3+bp23Qz
	/ABeAaAK17yeKBoSOvU5IqpYC6QxQsCnjbZOb6tO9kKJKy2NkYvWFOhabg8D+RyamVJtLz
	uDAH45vQKPSydB2LfniEwnMjNnTQ4m8=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-76bde897110so2191681b3a.3
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 12:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754682958; x=1755287758; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5J4Fi2mKTN/GdQ1NmR4jCj2VsL5TUv9pVfPKW/me6N0=;
        b=XHIdYuyTPsMAcwO7yBMVnLaoOKQO30YMuOhy24e0TUfRvFqSB/KtdICmDZGB4kbFHW
         sZrMbwPNTlNW0+S/74oVNC4aZyZ3KpsxnYgIhszjRpKEa1F1Ze+5eGGD2tcO47GJZcIA
         iicKxfjH/iJfxnWqwhPtNy2L8gMo5rfQMg/QSNEO/HmhelDXby/zAXoBefCcCv6CAAMF
         elHhuIZ1f4ftXPBicGeL+WzffxVSUQTjhbkwAtIANyMU0KaPC9AZgGw/Jzt0RFoGR4G+
         uodSTVEsI9JkN2YjomoeZcX/A7ZwGn3DPCADpAa/KGoALUMvaBZHQlKKjGnQbxRt9Gd8
         RTiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754682958; x=1755287758;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5J4Fi2mKTN/GdQ1NmR4jCj2VsL5TUv9pVfPKW/me6N0=;
        b=PGu88t2n0BYQagxjTIt9H9yGlNPi18x5Llx6YIBvucZCnDElDlYQSEc8/BOBDJiVlf
         ezOMqztdd+Tr/1nGU5eAVvQhLX36ywn+T66tG8h3TOQ67g3EyxAGi6z+v6R2WSUkGRxD
         sfNILKk2YH3iihXVG8dZ3U98mDsOg2544LATbkgHhacqQicIvohcbGEuLaMZM0iHXmee
         D3vRH94Nj2RgZEBg7G2KlwX62H2NQwefhkXSkOECp03ZNrjgbvKjvLSN0Ai57tWAhWgl
         nD8EYq6wh9OiegLLAG8oU+aPRm4HYEouG22LIbcSoY7EnzGjPcJ3GdHnmJ5PJqVjhJ8b
         pwmg==
X-Forwarded-Encrypted: i=1; AJvYcCXOrQwpGQZkc13zRcCkg38/ub/imdo2ulFribJZ+Wco9Fi2Y/idD6nWEW+OP0nqglrJd98C9cZ1Bg==@kvack.org
X-Gm-Message-State: AOJu0YxHQeYzK157VSWbFSORH1vPpMgEyoE9IdksQyV+xt/FSEXoPFER
	U3YUMe2Ft00OFRw9scZ9UMowWXpiQ60GTrCaLYMfNDhhqZNeK0g/WZRF
X-Gm-Gg: ASbGncu3z2yAI5Pp09Wg7zpGdoBr+Nzzm6gBP4MOH325iOoqyqnl86CoYYwwrQv++K3
	O1dodkr1m0GU1EFRyeTO6w+F7EI07cIMoZCzuFT6u3uI7RoMWv7kiCaVK5f6qmWVEFjzHGE3NX7
	KfdTu1jLuKAmDLqgXEJu4fbZSoECvZGwf+gCKCFVkVz2NO0z9Tj9SRERnUt0O22nMqS17eXzWnf
	QOWN82vF6D3h9vGiH/QYbZEX0MN7J4bOKp6o7HArZ8Aq7oo+LXEBSpzrIx7vir3lIb4MZfHvhxn
	gO5UCccMTWQ2Pch6XGylRT+VQBBNP0i0k/cciinMNiFyOj03syuSz9t5rPZ8g+TVjP1785GuOAZ
	awumkjgWWchgbVvIF
X-Google-Smtp-Source: AGHT+IHFbZ9g9txwoRArdrZPIHCxEoHurNyfEasCmGgGMvZpszV21DG4t4TeI/5uWuzfctJ73RcMdA==
X-Received: by 2002:a05:6a00:3d4e:b0:76b:f24d:6d67 with SMTP id d2e1a72fcca58-76c46193b4fmr6631578b3a.13.1754682958415;
        Fri, 08 Aug 2025 12:55:58 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bcce8f911sm21201103b3a.47.2025.08.08.12.55.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 12:55:58 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: sj@kernel.org,
	honggyu.kim@sk.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: [PATCH 2/2] mm/damon/core : fix commit_ops_filters by using correct nth function
Date: Sat,  9 Aug 2025 04:55:18 +0900
Message-ID: <20250808195518.563053-3-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250808195518.563053-1-ekffu200098@gmail.com>
References: <20250808195518.563053-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A3755100002
X-Stat-Signature: rxeqsncu6k7wfn3zh8igy6kc955dku8s
X-Rspam-User: 
X-HE-Tag: 1754682959-924117
X-HE-Meta: U2FsdGVkX189kM6JBSDdGeSCfCW5lqv5xPzJNxvbpYQtt3ZTIv5oIFzAfmCF5tU6y/bHcyZl+YyuY279mbefgNHViwQ5h/6h48ao//LMQt1Hb6GL8z1KuTUPre1JPnIauw1qTYu7ow51e4tx2XHStD800iuBiFKvChAKRwlQnG+1ucVZORcNLc1gYOOamImdB/i4liFqvQMDqKw1vZ1LNgmUeU1i4MHyMdpcGKdlYfwl5tr3pPDWiqgrzNfcE2rqsly9MNA8VHg/iI9o5HpIzXHHuXo+pK8/15KyfZvsaAmeHfyLw/NW43OBpAyL0vZNIVnzlRdsriOmV2giZdy3bZ3To7hV9Uy4MTVK8OhCow5nGwUuGgXoHPo/7K1XchYOHwg8o5yFueIChsuPcBUfVO/bv9wfyzs18RnojQZ294h21Z8Q/x6YMV06QOxCG8RGYPb3atBTldOrkVaHi27xnGgB+XYZEvFyKAhwSYyP/wW5VzfFisQXI+jvt8O4KVqq41T3eWsEqWZ/LQICNwywuVhXmdUrHH9lkh2j7ha10kmhHd5cHbnJXcTxCQK4qBIisCKTMotpp/sGKGP7XOZJi2rumNB+nYZOnVEURZvnxMuz4PJcw0LIwqvORfaCGXpXqtOuiBe8xP4CwR3Y89SIYH+bNM+Ac5eyXkgpMpj7e031MM34n3+EAY6oT20KMkug+omFhpd0VZE6mVG3COJDchpKQS3k3hkrfQ+wuUJNkCvUSpRh5lyIlxrjyEOqoSNoK/+1n29H/6e5aDsps/+5+9wYYHFuERa5ZzTBK9LI9ZHwzoPyeJzMAi9oNX1MaGGUjmZ1sSEnoOVuJh7jlsgBDV0jd/knGIc4hbe2hU+Zc0bWPV7tJJUVEQOZVisCpJSglkS+8Kgj7pbAOY0WBBF7ZHpNGJawSVp0p98mE2VSsCdtS0XfloabD7vw+hKOeOkBaknW4SzeQXpV5mV5FB2
 hg0Md9Re
 PV+4A5T5iEZkPfA9pKv16WHJYX0VVKrvFHbGZMymhAySghCTo+Xk2TV9A6AAM2FjJ2wQicpCtC1lnrZuGQOcYm9hOy7AuINqdnDqyCuOAJU8S8B4utYUVJtUerE4vACTLfmpO0O42MJbCHod2ITgpXWXJBb+uHkGG3lNW4vdJ09H+TudHVxDJya9t0Ulm2+XHg9vS4FXSShP7/xwdZZrGRDHLzMlmDNSfCnttqI1sjgLo6YmGfM6lrqdlvUSRuMVeeahEgDZv1VYYkWI5E7pNr0pTMkc1gqVAL3manrCP5da8O5rGef5pWCui2KOlSoW4e4dCZ88qF2GUlgTQ/Yn8fWKrQtCMMuYZHIW54ApGBcRHkohvp0vZCPay7p0W73DbvOMCnTxtCCAM3WvGAeQq0FFtXC3b8ja3vLiJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_commit_ops_filters() incorrectly uses damos_nth_filter() which
iterates core_filters. As a result, performing a commit unintentionally
corrupts ops_filters.

Add damos_nth_ops_filter() which iterates ops_filters. Use this function
to fix issues caused by wrong iteration.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/damon/core.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 883d791a10e5..19c8f01fc81a 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -862,6 +862,18 @@ static struct damos_filter *damos_nth_filter(int n, struct damos *s)
 	return NULL;
 }
 
+static struct damos_filter *damos_nth_ops_filter(int n, struct damos *s)
+{
+	struct damos_filter *filter;
+	int i = 0;
+
+	damos_for_each_ops_filter(filter, s) {
+		if (i++ == n)
+			return filter;
+	}
+	return NULL;
+}
+
 static void damos_commit_filter_arg(
 		struct damos_filter *dst, struct damos_filter *src)
 {
@@ -925,7 +937,7 @@ static int damos_commit_ops_filters(struct damos *dst, struct damos *src)
 	int i = 0, j = 0;
 
 	damos_for_each_ops_filter_safe(dst_filter, next, dst) {
-		src_filter = damos_nth_filter(i++, src);
+		src_filter = damos_nth_ops_filter(i++, src);
 		if (src_filter)
 			damos_commit_filter(dst_filter, src_filter);
 		else
-- 
2.43.0


