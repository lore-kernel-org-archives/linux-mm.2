Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9643CD3427
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 23:36:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FAFC6B0093; Mon,  4 May 2026 19:36:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D36C6B0095; Mon,  4 May 2026 19:36:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2108D6B0096; Mon,  4 May 2026 19:36:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0B63C6B0093
	for <linux-mm@kvack.org>; Mon,  4 May 2026 19:36:39 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 964101A0161
	for <linux-mm@kvack.org>; Mon,  4 May 2026 23:36:38 +0000 (UTC)
X-FDA: 84731349276.16.9CF7760
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9F1EF1A0004
	for <linux-mm@kvack.org>; Mon,  4 May 2026 23:36:36 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=d8yiztWu;
	spf=pass (imf19.hostedemail.com: domain of 3gy35aQ0KCBo0178I74A10F0J6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--abhishekbapat.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3gy35aQ0KCBo0178I74A10F0J6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777937796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a6S6DlMMQcGikJO+VWHR/PLbk/eNEQ6Kb3xIzqUHnnk=;
	b=nKw5ZO2T9xbmDU3rIVTzqc4JixyDJDzXk71UoLcLKjLyhScDo3046NiFZluTnxOY5+VXcC
	2eN6geIOjoqeu1nl0T/+Mn4A8EALWMGR++L0IiHdaeoRZ4ex5FQx9SeENKmqoFfrH+v/Tv
	s/gjuvSgKqs7m+HMiJg7RUpwqBmZV10=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777937796; a=rsa-sha256;
	cv=none;
	b=iSAEhSF+4O5oEdJ9c6I06MLXzCD7iL2ttbt3zS4Jvo0msqDfYzoHOhABrNjXB89joAEnHW
	wEk+rtfFgfBHsM3HM8pfwFMEovnP0LBXyD+mg15XpBVLtVk6iPpJwHMWoU/gBQsDZQDZmy
	30rBSHqkETDwjYNC1AvZfKaROprud4w=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=d8yiztWu;
	spf=pass (imf19.hostedemail.com: domain of 3gy35aQ0KCBo0178I74A10F0J6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--abhishekbapat.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3gy35aQ0KCBo0178I74A10F0J6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2c0f6593ef5so6682988eec.1
        for <linux-mm@kvack.org>; Mon, 04 May 2026 16:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777937795; x=1778542595; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a6S6DlMMQcGikJO+VWHR/PLbk/eNEQ6Kb3xIzqUHnnk=;
        b=d8yiztWuhyJ0ctCUoW61WOchq8PO+HVepHGwM2Gw6+HpG3pFxcrioO7OUYqMqp2meC
         mRaw+6VEKroPpbspuZROMIrvOGkmGxD69ZSb5R23bZeiqXIgUu649Ghjdz649kvg8y42
         3N9kdM7iG9D+fKWy1hbIroqLxV9s9sC/AcpQHXpXPrtS8S8L/bE6PoepIOeEB26fLvP7
         Li/hmokNOjbyBTGi0GeY/1Z7TVvpWcfeidDZIPZgG3NyUfdgdVQJOI/RABcTz8iHkUpS
         HMJh1J5EvLC07Pri1KVwSXu9Mp75rrpvui38/ssLLvjFQ4y6qeeufGW25ujkWVkxmAFR
         k5eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777937795; x=1778542595;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a6S6DlMMQcGikJO+VWHR/PLbk/eNEQ6Kb3xIzqUHnnk=;
        b=nreXvudRBnBe5EkSRqUnzoRPrSRwf3ZuAfU2GAwZ/K2Wzept9We/qHDjFk3GLQcrhd
         mhNRMNSnsIXW6jYX88IZdX3a5Inii8V4JMq5symw6hXR1B4+iJnPJpamiSiFAw6PB0ZV
         WaIhy//T2VF0Sd9VMiYTMXENlNUju02erkKa2kiyH7+L7WUv9q84BNpJKm/lc7FERiUv
         cfk651Eq1FQgVhR07Kzjok7yDwndlIYDUFKKrNCkmb6tzBMzW5Mnby6cGOWYx4UvwL4P
         5M2Ci8wBGY2BC5DlSp3UXkawFfrM3iQKIJoeh8Szi8h78zXHlvsL6UJTSlHp0AXvhUZz
         iUYw==
X-Forwarded-Encrypted: i=1; AFNElJ9J10VnzYERrWvnbDpOuwdEqtD+ZKmYyx/x7aEmIk7IiuRKqNyIxfiu5lxrpmuh/+nCcTK9tMotMg==@kvack.org
X-Gm-Message-State: AOJu0YzrRKD/2pLlyVJ14vdpPLXuxIkwMIr3PERhlcLoBe6utgHymuRO
	kNkHKE67RZFPPlN69POzwifDlETE9q0V2HIj1Mfj0MoeP0IYpcap1/pj/uqww163/h/LeYPqLIW
	NFa0iXSZAAendyKnqn3rsm53w6euUyUBYRw==
X-Received: from dycoh3.prod.google.com ([2002:a05:7301:da03:b0:2f2:3f95:c586])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:5709:b0:2ed:e14:7f5c with SMTP id 5a478bee46e88-2f40a190047mr396805eec.32.1777937795111;
 Mon, 04 May 2026 16:36:35 -0700 (PDT)
Date: Mon,  4 May 2026 23:36:21 +0000
In-Reply-To: <cover.1777936301.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1777936301.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <06b4fc2457fb4b75eb1ef18320a8722ddb5a850f.1777936301.git.abhishekbapat@google.com>
Subject: [PATCH 3/6] alloc_tag: add size-based filtering to ioctl
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9F1EF1A0004
X-Stat-Signature: 4tbw3gsa3t35uun86jp3rrq4hu4uct98
X-Rspam-User: 
X-HE-Tag: 1777937796-323569
X-HE-Meta: U2FsdGVkX197owiDLKGukzFArz1wZ6yYIlai0VY2w2oCEdwb+NN43IXIduwRFqsHdQ9+0vKayvVhZNPcw5RXfrfMrOVsBijQq1/ugUpk09KCeLCN512rpz6bw6/5jUs5zlwXVZYW/GkEQhO0nZsqlSuxXOuOwmhqLFOWAGyCykbSzB57EbyK+J3HdtboeVg3QyxcsUcFYDWeAyhTEoC7NKqOFPCAMc+TPI1r7djshEdkYaGfOo9kaahxq/dswSkCqKwwwiy3VmMBPHzazVlTI7n88zduI5uw7EndDwPlk/5+Z5VHUv9g++gQcna1Uu5ew5YLCPsVcAiArMFBwCuotDDRfIaUN/guq3CSAVWF2PYK72SoyQuzi9E2EvpkBI25x70Y0VIBbiyuNvKb+EHsgUarQL0nxdAQ/MQd1rHcuN3gbwJ1QUYhO/8IWR0We2SmEcP1ofHUAWkwPZnfzdCmTj3oNKc6tcFE/0EwCfCPUbTjRmCKSMCizvIzEetY3IbmW+SQanMMw9JIiogrJ8h6bS4YX+a+fE+iU1v80AFohJ9B27zZgUvdkkXyOp0/IpcqU4K1JRlRGOp8fvfvQ/w27A5Gj1RHB0tMhLI7oJawdV7yYGgKE7stzycoMerEXMO5eh7/3qIPIqSRWpQ6KL/G5Zi0RHa4h0J+WawYPdFxDjjd0ri6nm9YAUULntb5tXrSExS3TUOl29gJobA33rQusbRg/fWLO4rRE34jR+9EMHuzB/kb/b/6QLVrh/RomnC0G16vov6gVtTUBjK5m3StZCKDvh4EKdgtOf2DgEXGiUy70ENMeHEiyV4YhQx+ZQOsDF5ZlA9IcJrmIkp6PCIPE/fkOy9cKlUCxMfdNPZPPvc6R36m9PDPq/J4VyRUMJq8JNMFi2kIoE13tifBZ4hsIkrL8v7FhNS3U5pyBiIoRvJOJp45BzQi/cr+PRdFOVtAnU1T+YUVtvtyUHB7pCv
 dL01njQB
 AyOaoz/YeHaPcO3LrEp7mGMViCjXxJPyxWqgDKzYPFk6zjL0gxc2cbNRiRZSVfvNptuVsGThONBv1QT4Q0A7CeEUtIDE4arn4/zf1fJnM/YBhNcXusIC4ECOAc3aWqYijXjLY3XplDLgRRvnkQ8d9hT6uwnENIKl4q9PnIxGh5nsFLBXQzLZu/akSd2dmgVO1I48QYjg4zykRHKI3WW3c4rn46pyFe7BBIti16vvQDaNo0KhnIfnZX3G43Pm9JNKDjsXMvxiFhIMFEaAWLATstpFK3UduQUchdPis1dl/uDaisDBqUn2STjX++/gwiTyQo6wqPiBysAZCut+gDiRBypIAGrudBShJmRcsyokthNqA8bgBlyLvh04k5XnPwQDrjnmK77zx75Qaitifb0Dw4Nfr0FAE4EFKdcryQ45rQWsEUKLP2lbDJ6pP3WP7p47lVZlPSzrIWFcpyTmrkZvvUdy1TaECkNgZQKnJ4vgfS2RHLwmhVIKK6JP7by4LcGUHytg9dIy2UZi/QdfLb+tYCxxGS5LBrVjIIDjQJ+EhocQwr4ORUs8DGMkGvg+DLMfYJCkp+dOgu+BR1sN9VazDSEnRoSqjtNH12rrBJNc/q0cEV0znut+2SZH+Eg4xkj6SM1T1uOvLVBlZ3G7wsBTtXYNvD3m1Qncj76NGRwMTzbx8R5eduCQ+Ngj9u4+eWF/gni6hSDmzMfooSpwO6PWm6f81XQVtmuFreUOklLvVN98nFk4dKRus5ZGsWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend the allocinfo filtering mechanism to allow users to filter tags
based on the total number of bytes allocated [min_size, max_size]. The
size range is inclusive.

Filtering by size involves retrieving allocinfo per-CPU counters, which
is an expensive operation. Hence, the performance of size-based
filtering will be worse than other filters.

Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
---
 include/uapi/linux/alloc_tag.h |  8 +++++++-
 lib/alloc_tag.c                | 15 +++++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
index 0cc9db5298c6..229068efd24c 100644
--- a/include/uapi/linux/alloc_tag.h
+++ b/include/uapi/linux/alloc_tag.h
@@ -20,6 +20,8 @@ struct allocinfo_tag {
 	char function[ALLOCINFO_STR_SIZE];
 	char filename[ALLOCINFO_STR_SIZE];
 	__u64 lineno;
+	__u64 min_size;
+	__u64 max_size;
 };
 
 struct allocinfo_counter {
@@ -39,13 +41,17 @@ enum {
 	ALLOCINFO_FILTER_FUNCTION,
 	ALLOCINFO_FILTER_FILENAME,
 	ALLOCINFO_FILTER_LINENO,
-	__ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_LINENO
+	ALLOCINFO_FILTER_MIN_SIZE,
+	ALLOCINFO_FILTER_MAX_SIZE,
+	__ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_MAX_SIZE
 };
 
 #define ALLOCINFO_FILTER_MASK_MODNAME		(1 << ALLOCINFO_FILTER_MODNAME)
 #define ALLOCINFO_FILTER_MASK_FUNCTION		(1 << ALLOCINFO_FILTER_FUNCTION)
 #define ALLOCINFO_FILTER_MASK_FILENAME		(1 << ALLOCINFO_FILTER_FILENAME)
 #define ALLOCINFO_FILTER_MASK_LINENO		(1 << ALLOCINFO_FILTER_LINENO)
+#define ALLOCINFO_FILTER_MASK_MIN_SIZE		(1 << ALLOCINFO_FILTER_MIN_SIZE)
+#define ALLOCINFO_FILTER_MASK_MAX_SIZE		(1 << ALLOCINFO_FILTER_MAX_SIZE)
 
 #define ALLOCINFO_FILTER_MASKS \
 	((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index 7ff936e15e97..98a27c302928 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -195,6 +195,9 @@ static int allocinfo_ioctl_get_content_id(struct seq_file *m, void __user *arg)
 
 static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter)
 {
+	struct alloc_tag *tag;
+	struct alloc_tag_counters counters;
+
 	if (!ct || !filter || !filter->mask)
 		return true;
 
@@ -214,6 +217,18 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter)
 	    ct->lineno != filter->fields.lineno)
 		return false;
 
+	if ((filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) ||
+	    (filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE)) {
+		tag = ct_to_alloc_tag(ct);
+		counters = alloc_tag_read(tag);
+		if ((filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
+		    counters.bytes < filter->fields.min_size)
+			return false;
+		if ((filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
+		    counters.bytes > filter->fields.max_size)
+			return false;
+	}
+
 	return true;
 }
 
-- 
2.54.0.545.g6539524ca2-goog


