Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E62CCD3B7E1
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:30:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 869456B0027; Mon,  8 Dec 2025 01:30:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CC226B0028; Mon,  8 Dec 2025 01:30:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66CE66B0029; Mon,  8 Dec 2025 01:30:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 55B1A6B0027
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:30:15 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1F29CC09D8
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:15 +0000 (UTC)
X-FDA: 84195329190.30.1094E1E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 644AB14000A
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u9bFz9IJ;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175413; a=rsa-sha256;
	cv=none;
	b=8apB+OnqmJsiXGQLIAda5KfiMfX87ZriOhG27hg3xDR7Az3VqBrPcHFSeulJyOHyW/5bzy
	skeaLCQQzDlErws9U2mVMab2KBbvin6hQ76jCaI84TRgGyZbO5YJZbaJkjcOxKZomjkj/v
	9u4roE6KkOkxMkEmjP1iuqcJCUIBxTY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WzY9GOptOUyuqIQxZGQfFklPd9uckrWcpG+HGdC6dUg=;
	b=UL2d6j2zLUf8moqzaJpUMe809is4riDZUGeYGaNG15lpovseFPatv3sdh6WxTUCgnGktN+
	nnkMMZBa1Z8ysJfseobJyKqknS0v4HMCa3SPdX7I2EQSITsLC0w7MS8z6d5RhQRFElbi3R
	d+jD8ZP9iZO3BtTewXQGsRsyj9UUIJY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u9bFz9IJ;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A0F3444B5
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57FEC116B1;
	Mon,  8 Dec 2025 06:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175412;
	bh=DBAN6hkU/P5RDm6zU3vPLM0u0djvJ5SiKcRHSXDFMxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u9bFz9IJ0NFa6OquQ+K7h90ewPoaDRUvo5S3k4xHwsSXIP5d71Z+/NK6jSVU2a153
	 t5QmPH/kEcJc+2qIbDy5odH3l5EKXL7FFsJwYu2kAW+W84JlSl0CmuK2Sbnzc5c6Fk
	 7aiYMY3VS8WuHh06ZSNC4RuDS69q4heswKZttGoQzE3aaCiBaeGnXUAiwNagbPbnZE
	 NsKjJv0/2StxSRaHStwFbxsKxgfxzA0mcfWBzlos2tgiw0INJuuJ+WjO3woN+xBGK+
	 S2WUoXQIIjs3lwquGnwmXicuRu4oOYkT9VGwdhy7MDGfvSoQgUsEd+aA3eY9POSAgY
	 dIZbaAUzOsPwA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 15/37] mm/damon: implement sample filter data structure for cpus-only monitoring
Date: Sun,  7 Dec 2025 22:29:19 -0800
Message-ID: <20251208062943.68824-16-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 644AB14000A
X-Stat-Signature: 3uaztbze8bc8m6cn4ozj4m9tidx1c7ku
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765175413-199937
X-HE-Meta: U2FsdGVkX18+n0SK0RMObbrqj6UH/r1gzs/7LHWvivq8G38lCOeLi2pXExmfsxGYMEGVXpONBl5EAI8NV5MCOA3LMzCVt3WU+bEvYL+w3Gj7yZLf8cnK+KeqiU/R6nKt/b1CCkdkMUuldsG6Au/ZviCMDgFFef8IjiFhPkhFRVIR/JPyor2XQtc8oIdSXode2rrO5RgwyjecwduJvWy2R8dWgAYGgqMerJ09mCNosCeNgspZFaiFCZ5S+UgOxmb5/bi5+iMG73vSVXdUCz/JnrLLkIsoioYMH0LUSuJB5fBgVLpOlMwdnu5s03fm2sjRLEqS7iBzsOOzzVS/wRv4F/dLJz/pK4ACfif1TeCuvhZS+DKv2sCNkE4JxNPZSJcXA/PqU1756ky4UDeHpuVgKWiP8A4jITxFqjIZLYSut0YYBgv8oprzd5zpXsIPEVlWpwpZCNHQ6KFvNJ7CatmDyX229FnDim5UwK0E8R2lolMtDLctWV3dKO1y0px9dUL3JLUO4l9xHEKEt2PBGFMai+vlGKuBC/Ljr6srwm5INS3GXQH/Rb/aQDbVTrHomgx0nviSAxNsh4pYDGRawsblRMJnJ4Mjc2oPJY/i65V+3OQKljDZc5dbVdCZdTOXbZk8P79P9MUp8BM/rQeeKsqlNajiuSzQzaXBK9XMSyLwxIUSFdljle8WiXE/vR6DosD2V9lJ/uBppzSCBHdUHb+BrcVtuWDWOu9CyMW3m4/NkizM8AFjH35P+znP2uk7nmRgKaINTwIGb0FqSVOhACrKnY3G/SHCIlxEAEO6yiAExg8WjHGxzc5rLmv+1NkZo7tQMhKAJV51Q/nHiHWze1JK4oRsYETwnnA1WmrArktRGgjquCtPMZEIerU078YGopyMJuuhqeTiPPPt1qHl0t0i5A3ZORqClXDx0gaDsI6cnWJkUE8laJbw0+JKys9MeL5/4Vk/QoVtRWpvNnfubIc
 1s9CBVn+
 oSQevpvfOfh3TkYFllUW+kCREPLNhmryNNm+ltbWbm/I/jTuK/nYsmYwensRnGT+04pkHDKZlffceHH+LCIMjLGupzcxjPHgcJ6nApzryM7mLTk6MpZD0vAY/0gYn8i44rUBhgBBClBbrq63CRBX4dZjwuJ2t0dTx+M1F37Wu3Jj1GMHa0NCTpemffqTyE08Pdpp9E7DfBlS5QNbZ4GkG20v53WjA1tOfGdC65YM4McNL4AYSS02MzP9eSdUkR0Hy78Q/LX8RSAY6czKTo7gExm0bjB86OGOJyZ+IleNES48EeNM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Access information that is reported via damon_report_access() can inform
DAMON not only whether there was an access, but also additional things
such as the access-generated CPU.  By filtering in/out specific types of
the reported access based on such additional information, DAMON can
support more fine-tuned monitoring, such as per-CPUs access monitoring.
Implement a core API data structure for controlling such filtering.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 39 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index e23a10ba7c92..78be584ce5dd 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -781,18 +781,53 @@ struct damon_primitives_enabled {
 	bool page_fault;
 };
 
+/**
+ * enum damon_sample_filter_type - Type of &struct damon_sample_filter.
+ *
+ * @DAMON_FILTER_TYPE_CPUMASK:	Filter by access-generated CPUs.
+ *
+ * Read &struct damon_sample_control for more details.
+ */
+enum damon_sample_filter_type {
+	DAMON_FILTER_TYPE_CPUMASK,
+};
+
+/**
+ * struct damon_sample_filter - &struct damon_access_report filter.
+ *
+ * @type:	The type of this filter.
+ * @matching:	Whether it is for condition-matching reports.
+ * @allow:	Whether to include or excludie the @matching reports.
+ * @cpumask:	Access-generated CPUs if @type is DAMON_FILTER_TYPE_CPUMASK.
+ * @list:	List head for siblings.
+ *
+ * Read &struct damon_sample_control for more details.
+ */
+struct damon_sample_filter {
+	enum damon_sample_filter_type type;
+	bool matching;
+	bool allow;
+	cpumask_t cpumask;
+	struct list_head list;
+};
+
 /**
  * struct damon_sample_control - Low level access check sampling rules.
  *
  * @primitives_enabled:	Enablement of access check primitives.
+ * @sample_filters:	List of access check sample filters.
  *
  * DAMON collect low level access information using sampling, and aggregate
  * that to make higher access pattern picture.  It can use multiple sampling
- * primitives including page table accessed bits and page fault events.  This
- * struct is for controlling what sampling primitives to use (enable).
+ * primitives including page table accessed bits and page fault events.  It can
+ * also filter in/out specific types of sampled access events to monitor
+ * accesses of specific types, such as access-generated CPUs.  This struct is
+ * for controlling what sampling primitives to use (enable), and what sampled
+ * access events should be filtered in/out.
  */
 struct damon_sample_control {
 	struct damon_primitives_enabled primitives_enabled;
+	struct list_head sample_filters;
 };
 
 /**
-- 
2.47.3

