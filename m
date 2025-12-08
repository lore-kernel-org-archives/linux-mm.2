Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 303CBD3B7E1
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:30:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A6EC6B00A7; Mon,  8 Dec 2025 01:30:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 709046B00A8; Mon,  8 Dec 2025 01:30:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61FC96B00A9; Mon,  8 Dec 2025 01:30:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4BDA56B00A7
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:30:32 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 05ADAC09C7
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:32 +0000 (UTC)
X-FDA: 84195329904.15.FCC21E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6AAEC180019
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tJgREwbl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a1YTfl2JYTYH0RJ2EIhah3PLJTxFj+jXcmXY6oSNQAs=;
	b=3ehGgwMT+pwEzoqIVNUUW+QTxh0yxyAhbDauWWL5AmxdsL/yhDEEJAm6bTZP1/Rzez60WR
	ehuPD4mwbDJIFONdcnsI/Bv/etTSnjHeeMGPE/3qJBn3HIol2bScl9M7AlWGQuqx2lOHh3
	JuxpdJfVAtpOd61ms/N1Dwg7pdI7rN8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tJgREwbl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175430; a=rsa-sha256;
	cv=none;
	b=v2AkwXjXwvMnPXoKewLd12wPuDNKZX/hp1ExKU6FQYGBDdbTNDg5bnOUa9q6b2K57VQ8YU
	mBsZ0W8NT+/iuZQuEXJuhGZ0h14WjRfBqzkBt6T2ez7i1hgbDcF2yQ+pDTRxICnmaeTNpN
	/M6hgBeris01MyJHbiy9SLDt6gSP+90=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E8B24390F
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B051BC19421;
	Mon,  8 Dec 2025 06:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175429;
	bh=JPE1XJEWPTQxQyA4KvTjuuct2aS89H1amzc/wDg9UWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tJgREwblfsPOxlzcswCmUBjL+skiE69803sMzc3gSdhETg2/YQKMTmiUTdKrSpIXk
	 NOdj/igxZZbOXrL/JAkgCT3/YtMbkS8uSBPiL810CntJQ/tU7m05PHbrEEkZno5dnB
	 WRjYU3mEpQ6zRE373T7OxkdT30znjkQ4N5WHpSyPbR63r/0upbHKttJQhRjI/p/WTF
	 yOofkVwejRIAofsv5sqTF00LqmTd7DUrOd0bD9M08jltQoMdW6NXLtPz8u+VG/FUQ5
	 ZBE2ZhkelamznjhP0Cm7Y7YRfH7sDjVUVFLL7Vz5vaDereF7P85kB8UwEKDPAMdDrF
	 4HvoQZYRLZk6A==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 26/37] mm/damon: extend damon_access_report for access-origin thread info
Date: Sun,  7 Dec 2025 22:29:30 -0800
Message-ID: <20251208062943.68824-27-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: a9qq8t5jxaarm7mx1ze8biusnapoqx1b
X-Rspamd-Queue-Id: 6AAEC180019
X-Rspamd-Server: rspam06
X-HE-Tag: 1765175430-284394
X-HE-Meta: U2FsdGVkX196bQUpXpf7tMrAVsuSXfG9ZHEdrKEqQWnrsN7SEE0P1kzihDxgmJYFaXOpXOgRxQW6H/3Ytx5QcnuUTpEyY119s8n+ZTXrpmwZkz2k9JBiR0Blq05XUs21ayTiVkJ9hk4KcAtW/X+Us1y7fq3x2fblEUEEDcreGxRAn2a6qZHBHbPtqqu//B1CN0cXddPoqZ0b2fl7rcoZ5x77XvtRhZ2bNoP8mNvOErMjuIKyZSXpX+OeHIoqEyP2RK/PXku1ssEtgAKYlzkm8Uy0vcHryyRn99jHeNzk2GnqhjJiFozjq29H8r65uLbSo/jj8dE63U4RQFIyqhfalKAuCDjxynJmv+y3385OqcQ7OmjKAviZuuiWsmuQsvJHC/nOd008JKi5OLlImy5WGunPNSEomzkzzSJhNXUctP6QGS9jxv7453Xuv21LAIn0q8/blkGVJMG68pu9G2LKPB8USnEqnfuLdQgZcGfAUnhWL0g0ZIoIaK+YZIukEcJg8jWEKWHB0CqaSHfJGtqScUOmhsIls3XyxfUsfG69q6LYe7Plw6atoDTHVrH363K1r6Ym/gJKUzxwsH4gabxLhmMWPXi0L+mwmpgdXbdHE1kRdLNAt215rj5oSqY6o/eF7RrAnIk1fROoc2RuQFI4pHLcYzxsD5l4L7SxCySLvQYgBhXgnJPQ1Oco0IgbRDOnffNxyw8PK2oa0mHiytjakY77TFjVXOeUtV0kiQjxh1AxLK/djv5pcsA0rUbDsjrRj7zpGNfSe3aAyh8Wkxz6aLzq0sXovw9E94QRIA1ybbEDVj+3awOX4escBZH325O4jurmtZlV5qyk0fU085pkNcM5qiwIPE7r94VYe3F8AOnU87zhGoi2Yd2BBN/MPcBUd3UY41y/UnjkIotlhr2lvneMH2ZkHSD5OIIyUvU0Nqqs7BI6YNi+uZALU6bvf7W/2Oep+q8BZzhJSu7tEtl
 amlrhpIy
 TYO7qkHtpiBjq1Y3oL2ZFC7HNJDehOhLTHf/ak/znAykliWatH/00tw6wfJQ4Zc1KTiTREF9Cw56C8xW5IQDDxslpz9yQnIFJ4B4JG8MARykGBUbgdDeMfn6qPJtTLygCESQ8xnspyb8Wheub0QzAMlCR7lEhQKq7VWo/jefy/z72jE0U7A7AK7F9xW7chm8h7QaXAOGl3f/pfqOXT1wZPmTjhuCVmN4UqDdaMxYPqEAdLZLT0E9//3yvssa7/ABB7Bx1PnlwAY9o5GJrd/q4B5s3m78cnM+1Jpe4sXW+JjVts7jLhtg6pti2qjTpks4eVMFVmqmDAFYe6sCMgqIpc2X6lMLz/j1aS8de
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The access reporter might be able to know which thread has made the
reporting access.  Extend the report data structure for the information.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index aff34dce7c7c..80332bb2b73c 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -116,6 +116,7 @@ struct damon_target {
  * @addr:		The start address of the accessed address range.
  * @size:		The size of the accessed address range.
  * @cpu:		The id of the CPU that made the access.
+ * @tid:		The task id of the task that made the access.
  *
  * Any DAMON API callers that notified access events can report the information
  * to DAMON using damon_report_access().  This struct contains the reporting
@@ -125,6 +126,7 @@ struct damon_access_report {
 	unsigned long addr;
 	unsigned long size;
 	unsigned int cpu;
+	pid_t tid;
 /* private: */
 	unsigned long report_jiffies;	/* when this report is made */
 };
-- 
2.47.3

