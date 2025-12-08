Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D72CDCEBF88
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:30:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 277996B00AE; Mon,  8 Dec 2025 01:30:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24CA26B00AF; Mon,  8 Dec 2025 01:30:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 053766B00B0; Mon,  8 Dec 2025 01:30:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E27426B00AE
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:30:43 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B23801409CD
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:43 +0000 (UTC)
X-FDA: 84195330366.15.2103E26
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0232412000F
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QEs8xFy9;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175442; a=rsa-sha256;
	cv=none;
	b=352XbT/xFW2sHNziSu8oFadHEA0aw97EzVEKcizZ8FXpNcxy5t1f6RhMseuBoHR86XXaro
	RVPs0YSr5G9QAU4BxYVzJVbsJTLWfzCJwSmaixLE/zwyNSRUoG3ViHYRBdzhNDPPmWJcST
	cpKQAPk4z8B8GGbzd6avroBraqEqTJM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QEs8xFy9;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xx9JGFYIe5Z+LiZgfTzEP+XvXJiwtZJ197mOvlSTf58=;
	b=ZD1+opBdefb3qJ02A8MUSBEE9BSxayqbgq/Rp0Tk5q7gyX44G3Am3qup3ukMb9y8Dhsy+3
	VXeEW5wg+sRnUpGl1HFJ94IvP0ALBk/00U+ALmDgCg440+lKKtu0apyONWrCpzbOr58RVY
	0lw043zHEMHzg9KpWRexwxEd8DeidR0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 333FA40802
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E86C113D0;
	Mon,  8 Dec 2025 06:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175441;
	bh=RBgupw+0+IFAQYuywBDofV0MFSFxSZkVNemgNSqd6d8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QEs8xFy9N/5t6MNK2CW9AAKR6gDNiwtRhj8gFt5ysY2bEKeVLIvwaRR/qG925Ypc2
	 64UnTu0Zd/Oyj/x+WezlY5QUBF6+gk0sNwB1wrGtSYiT2cIlajPMqNFriu35CaQYyW
	 uJSfF5aQP7wPFdZ9SYEfJUgQeDjB2PQDtkF6fPWt5rNaxZJ90HRSuFIngFYB+itSdE
	 1hbpcmy4Uc1E1kMcpDAmlIuwDlWc2+f2UQz0kq8y8lYCUBoLfb2E5ecL3inu0dgdU/
	 TWH0+AzWqtrCn/xMZrNdLQMrt67rpb8tnfnF6nghvTQiDYEzVZ9qtjcAaUms3XANOw
	 qqQzxtBHmf7Ng==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 33/37] mm/damon: support reporting write access
Date: Sun,  7 Dec 2025 22:29:37 -0800
Message-ID: <20251208062943.68824-34-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0232412000F
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: tokr1dz3srdwzb75yepu5xy9rkjymy41
X-HE-Tag: 1765175441-78986
X-HE-Meta: U2FsdGVkX1+WLtkEfqUnLTzfzHmuStD7rygb+Fjh2jx7skhUVi/Z4Pnjr+Gf53n26xoOdAHSKMHcahxQtFD0ZBQx5ezkHdTqO2bye35EsuMuVGvgpU/ob+YFFzI4Qpm3pGY6MefCPCDBw5H+nWTiuoXC++cI4VuWiMBwN5LE57gkjh/pFzOEPRUj71hHlBA3rnyVon33OGqsGCydYP4mR5yHt1U23SBVu4BwnlQUv06Fcqw2Qr/kzLlezImzJr0Kvma0ReqvVjZHElI/+Bt8MfFmnZh6jgz6eqoSisRntXD1JYraq9k/WWfOKWjxUnaqd4Rg09Menm/4pKzE0Lhf/w1Mcfs92Urg18OCpi0Ww0E4YjNMXEAFlakQ3TWhvuddFxmyE+L6kA6bO2+3kF8MWWqOH63NCa6few1UnFupqsxNr+1dYTKzRGtKdBIHLk5YkiTGqmIdZIzuGHb3np7U3ZaceZGJGXm56OjsXJxK3QbfX/SOS4cxYxHS3dQSZtRnxuHyx8q0o5w8+bn0gmjMXTRg9I7HUqpBQxrXf1iDbbwUhvuOqGr8gz4AEUG7vLdE/mWN1zN7M03f58jZLpSSG2/smNJupzIYVb6zvdVrzniBtJzmAulJt+31ldnbd5FABQqV9aY53so8idlIUD6aSTmqYu0ETwO+LWHWUFPyqNEECvPoVChoyXJAUq9G53L+fvxAuM/J6QQQYvZc/M/8wv4aEoUj9PK10yWXBGa4n3X6ojqjuLDDTENqItu/Sn89Y2BPy5megy3gNQz/JLGDYQHVfxJc90wFOfo6wlqdHH3VpBtTya0DuOU+zEPLcEdDReNy257lFLbLQC/5iqgTO3IQUYbmDFAXXrhCLEJR+OKD23EWFf3LduAyLlCizc8m41tQGH2dLD2Oj9K8yn+mUBrUUr/HIVm/EyVVxGfzc3+c3V5nW+a8IeMLZZzvWzqq1n+3KeacsldCedDRVGo
 SfkqYDLP
 mnj3J3gmiCTZE5llkRws+wllQ/5NgSQM+p0ogTakdbT4I9a1MObZTntJB0xL5su+QV7MbLbjSQ0rl5rfvccdjN8GXCVEngXf1hin15pUGkQ02eCMznqP5hwWScTTdEnj85oCaOdhpNJvRi9dWb5UVIWeP3tMnkYLaKHCJJairgPiYwiaD+hZNxvNoWNJpC+H0wVS+t1FtO+voRNW/bWV7pQSAaycDCj0f16y+hU2ZpnQ8TjZcfHPMN31BeNF9Kxpds92fgtduk8sWRlZatMKL9Hyn12KIEryRAcevQSkq/UAltXmcERuPtEtdF93Mm/632ZIIYMxRLf1+Y4rQVZMuL6ngLQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_report_access() callers could know whether the reporting access
was for reading or writing.  The information can be used for
fine-grained monitoring, such as monitoring only read-only accesses or
write-only accesses.  Extend the reporting data structure so that the
caller can pass the information.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index e3408280ea72..9299fc91ba27 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -117,6 +117,7 @@ struct damon_target {
  * @size:		The size of the accessed address range.
  * @cpu:		The id of the CPU that made the access.
  * @tid:		The task id of the task that made the access.
+ * @is_write:		Whether the access is write.
  *
  * Any DAMON API callers that notified access events can report the information
  * to DAMON using damon_report_access().  This struct contains the reporting
@@ -127,6 +128,7 @@ struct damon_access_report {
 	unsigned long size;
 	unsigned int cpu;
 	pid_t tid;
+	bool is_write;
 /* private: */
 	unsigned long report_jiffies;	/* when this report is made */
 };
-- 
2.47.3

