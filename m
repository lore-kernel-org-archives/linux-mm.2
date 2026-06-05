Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46D87CD6E7B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 23:37:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 973576B0093; Fri,  5 Jun 2026 19:37:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 923D76B0095; Fri,  5 Jun 2026 19:37:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C54C6B0096; Fri,  5 Jun 2026 19:37:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C2C46B0093
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 19:37:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2CE928D193
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 23:37:02 +0000 (UTC)
X-FDA: 84847471884.10.E0DB2DD
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5C9DD1C0002
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 23:37:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=miOxjN7L;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3ml0jag0KCDsXYefpebhYXmXqdlldib.Zljifkru-jjhsXZh.lod@flex--abhishekbapat.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3ml0jag0KCDsXYefpebhYXmXqdlldib.Zljifkru-jjhsXZh.lod@flex--abhishekbapat.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780702620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UFvPWrQD/AjvIlGDL+q8aROizOfdZdfW4UIDnk6moas=;
	b=0iwKsm2aok/RD2zWbXHt43reS6sjsQP9igwXiwxlGYgioQyN1yC042kBn6SzPtoKuqEedV
	vq2xWmUcRmknld6WNqNJ2aEJW2H/oXEsmSn3ucwKAxWhelJ+BxML0AQ3WTS9c6wRf8y9TU
	Vn1r1kGlrzL0tMh1jJ+YjIHQlQzDiwA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=miOxjN7L;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3ml0jag0KCDsXYefpebhYXmXqdlldib.Zljifkru-jjhsXZh.lod@flex--abhishekbapat.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3ml0jag0KCDsXYefpebhYXmXqdlldib.Zljifkru-jjhsXZh.lod@flex--abhishekbapat.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780702620;
	b=xq/t377uuvvAzpJDYXYwoK4lC/2uHWIsstXHGLgZELpYCXOSc0hmDHgrlh/AlU6bDdkzWe
	xmNaobyxYECH6dCjpQVdvuLnpiP35jLibfdlO4RfryIze5qsvQk/WRwfow9NqeMaNv0p4z
	EB9tzoo3xofXo77frK8VSmwTJbPqyqY=
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-304e4636205so4637110eec.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 16:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780702619; x=1781307419; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UFvPWrQD/AjvIlGDL+q8aROizOfdZdfW4UIDnk6moas=;
        b=miOxjN7LTLq2TO1DUFNnp5y3oIn+bjdVsFDeAIwjIdU+enJOkjVvR9wRkHMb6hxQOG
         vXBtrlD3WkhOzEMNbi9qZmZNqFu6dyFxJ+PoniY2A/4vePb3ikhd4EbCJpqcYv6ij3HR
         PiGNcnmr+0vp3ygPrmM8BFBOPAMS/uUU6eqCcZToi2RE3Ne6PSWAJHz3GgPP1CYWJ0hI
         6y5pbSpAO7RbBMCDpov73mSnCYOrZpNCyLBswkicXrrQTydwxE0wOEXGpF0qaTDizlpR
         CX8/EDQNSGhYAv0mw2aYB/dBFDluHJ6DjGv0qqKl8OXHks4MCN4O7E2hqBQBozT8DazG
         QhOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780702619; x=1781307419;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UFvPWrQD/AjvIlGDL+q8aROizOfdZdfW4UIDnk6moas=;
        b=YM6PhYJ77bLDnBwkncb5HIdLPK4ayB2afom3TmCoUHmLa41XldqADnsnRAL1ai2Zif
         KasFKO1lb6uXXcwMyWfAMh50E/XoQEO4ojypA1OHvSHM4uYRW3Sofcn9YKekkMn6HvJ3
         sksPLq44xll1LE0i89f5rapWoWD7FV6Cnj7b/Y2chlaA3quraJj3V/PejoZve1Cs7Kna
         YRUsBy388iboa6jD8vFQa+zA/vMAexnvNrp3wLZX7D9/eGuvStSe9EiRYe/e770GyL6/
         evsmOYsK3I7kYNYM4oFJiUsHWhe5zMyTCp9n3/TrMRzoAdgHtR2JGLdOCAV4A+NL1Ugi
         Zzrw==
X-Forwarded-Encrypted: i=1; AFNElJ/7fHhKGO4wT0KnjtMcnwnprB0kDe0Rh9jGuTCmNGPDjpFUPZtculUrXCkYpiMKFU9+qjEVSb09fw==@kvack.org
X-Gm-Message-State: AOJu0Ywq2826GLsORK4PkeZE55egvUsDCQp7vEAfsiuB+zLrCpzMLOK6
	FAU+mXuRILMk9Wy9I6lrZcTuXAKXIg0sHjG7ZMNb2V+kBQsZHfZdk6bXKEpo3OQUSwCYT5XX05H
	2PIEU5Opt4LUgyehPXKPhsPLQc3MYp6BMrg==
X-Received: from dyvs26.prod.google.com ([2002:a05:693c:42da:b0:304:cda1:27ce])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:572a:b0:304:aca:35c5 with SMTP id 5a478bee46e88-3077b22c938mr2897763eec.23.1780702618822;
 Fri, 05 Jun 2026 16:36:58 -0700 (PDT)
Date: Fri,  5 Jun 2026 23:36:49 +0000
In-Reply-To: <cover.1780701922.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1780701922.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
Message-ID: <b608a6f7d71e3b728f766dbc6dfa1d1753ddcff5.1780701922.git.abhishekbapat@google.com>
Subject: [PATCH v3 4/6] alloc_tag: add accuracy based filtering to ioctl
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5C9DD1C0002
X-Stat-Signature: kpfhxz3hbc6ohy4n8omrjesezfiqyx53
X-HE-Tag: 1780702620-88121
X-HE-Meta: U2FsdGVkX1/UW6Jz2ErTMHZO2c+ZSAeuw8Rp5tNCMQPGeFPiGvvKA0GHl3ZRo66euIACfuAoKxG8E7d4x6PxeyxIjB3XZKYjfUZ7uo7SpfGVB+tWhk0ROTM5trgcKShVpky8qgGoGv4WYSCGCzqvBkz1e3/vIqzyCPgh6PNNhTxvVAcnsNsLKVrMfELD/RuHWyq4W19xbFrk4T4fUIPZ2VX52sjveqSNthXa2m4a37nJWaZcpf0eRvgFVvhiv+sFDUvVOnlR42Ez+GVNpwiUn4FFC06zmgAxzgFUcZzYMWZde8hR1UrEaTd+lqkRFfLk8JqBjJm+2o6S/2vvabI7lrzkUDhdgjynDybAmnM41y3RVDiu7peJI2o8MMT0UbERM0LE5PiJ3hwZomIZCs/DWF2vOSbdAG8/6rxwNDLF/p8lgShKHZYj4gD+E64SLZrjjaXlVKhPF/6ljV6Op7+PyuTMdfeezBRETJAEEZshD6TFG7BWc1XlawNGlwmoIcJys5y9Y9zQQeUYUFw8+U4BBGS4gwe06/K9V4jCAcg2+Gq15JoS/GGSuscKOOPF8rmEVv4wx1gMCy71Z9Fx888mRTlbM65UbFP89+/AFN8Lw4oUsvhbYcTyCk8kZ8vC86L40wK4N43j1mQb04qNJlCuvWfYBVH3W3orq5/Hxg/70mxke4SEvRmqWce9oTx25OZICqN6f5Bk3PUuwcI2xxuwKdec4VuDWgLrqHYosQZu8fr1vk63EDI8CcsmVvt+FQ8Vhfym5ivxJvNfA5vnS1FbpMLo7HHeRsWihkbUo9JLhX4fo32aDUiX+QV4G92YdLj+g7d5205KeeG891TqgkRUST3a/NwVqE4oob5fCCl5jZ+naP80cb+0doS3hheW6JX4UGjY+RSngQIZWXiO4XkKAMBd2po4hsEcuym2XiseoxBysG1Y5Gb63D611CQWFOSIT+Mzde3DnN0DZ670v2n
 WFESRYUJ
 d/DIn95ZqGTP6bs6IJoUqGtEhFg+2wWFn9iNCSCCb9jMr4jHO7ADObbnm4KwEtq2w9lnZn76jXIepJijPdLhOeMjrq/Y37Snjm7Eh8sTSiPUHqgUFVBybC3bn8vOuuHh38AJRvbIGQp+JSa6HBR3nZPEATFDIwqlmJLWuSegcDdQXdPNR4P5q5kkKD9Ygm5VAXyHqQth3vmfZqJA4+ImewfcFV6TVaLLiaeDBl495TkCtrCPlymPQLLNe3VWaSwXoPuZJ35mr+133yGD3k4CzL8iTa0kRxuGa/Ms60/+iFJ8noaih0H+iSCqugB7VcuzvKg4g3Hpne4COeVvEl1pCuFwVvei0eFF85do3H/OSeurAXvitngFQriO0jH8HE+cGi25vhbUyb4exk1gSopsDJpRP//+aBbBglmd/TnrhxrOknLcs3uJJ5lKXFDlPszK9LNZsifLYB0I3mnLnxy/qXcWo1vk1ixxriNJx/w0TLQ2wqPPwArkidIn2zZbXU+JEO+M59bErAqj07BedZgYIl+LB7SBNWsNRrHz3urOzU/nzPAxEqsFDHPCRzjmZ0RJKQSpTqLoU4pkrAXrUGVZ8QNlFPzNJ9UyK40B4pI17XOCKd0hpK7griHHjCzIFKZse4M0d8o9qqa6cI/M6MfO/Vkojxv9UPt2G6bP0
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
 lib/alloc_tag.c                | 8 ++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
index 0e648192df4d..42445bdb11c5 100644
--- a/include/uapi/linux/alloc_tag.h
+++ b/include/uapi/linux/alloc_tag.h
@@ -20,6 +20,7 @@ struct allocinfo_tag {
 	char function[ALLOCINFO_STR_SIZE];
 	char filename[ALLOCINFO_STR_SIZE];
 	__u64 lineno;
+	__u64 inaccurate;
 };
 
 /* The alignment ensures 32-bit compatible interfaces are not broken */
@@ -39,6 +40,7 @@ enum {
 	ALLOCINFO_FILTER_FUNCTION,
 	ALLOCINFO_FILTER_FILENAME,
 	ALLOCINFO_FILTER_LINENO,
+	ALLOCINFO_FILTER_INACCURATE,
 	ALLOCINFO_FILTER_MIN_SIZE,
 	ALLOCINFO_FILTER_MAX_SIZE,
 	__ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_MAX_SIZE
@@ -48,6 +50,7 @@ enum {
 #define ALLOCINFO_FILTER_MASK_FUNCTION		(1 << ALLOCINFO_FILTER_FUNCTION)
 #define ALLOCINFO_FILTER_MASK_FILENAME		(1 << ALLOCINFO_FILTER_FILENAME)
 #define ALLOCINFO_FILTER_MASK_LINENO		(1 << ALLOCINFO_FILTER_LINENO)
+#define ALLOCINFO_FILTER_MASK_INACCURATE	(1 << ALLOCINFO_FILTER_INACCURATE)
 #define ALLOCINFO_FILTER_MASK_MIN_SIZE		(1 << ALLOCINFO_FILTER_MIN_SIZE)
 #define ALLOCINFO_FILTER_MASK_MAX_SIZE		(1 << ALLOCINFO_FILTER_MAX_SIZE)
 
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index ddc6946f56ab..cbcd12c4ef9c 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -249,6 +249,8 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
 			   struct alloc_tag_counters *counters,
 			   bool *fetched_counters)
 {
+	bool inaccurate;
+
 	if (!filter || !filter->mask)
 		return true;
 
@@ -275,6 +277,12 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
 	    ct->lineno != filter->fields.lineno)
 		return false;
 
+	if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
+		inaccurate = !!(ct->flags & CODETAG_FLAG_INACCURATE);
+		if (inaccurate != !!(filter->fields.inaccurate))
+			return false;
+	}
+
 	if (filter->mask & (ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCINFO_FILTER_MASK_MAX_SIZE)) {
 		if (!*fetched_counters) {
 			*counters = allocinfo_prefetch_counters(ct);
-- 
2.54.0.1032.g2f8565e1d1-goog


