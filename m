Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB0F0D2F004
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 12:16:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 602D36B0096; Tue, 27 Jan 2026 07:16:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C0076B0098; Tue, 27 Jan 2026 07:16:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F9E66B0099; Tue, 27 Jan 2026 07:16:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3F9D46B0096
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 07:16:53 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 10DFE531C8
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 12:16:52 +0000 (UTC)
X-FDA: 84377642706.17.92B38FB
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf27.hostedemail.com (Postfix) with ESMTP id 497D04000E
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 12:16:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="wc/LzcSY";
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769516211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e0pQYHM1jhSwp9PHWAhzAtLgw7dAo1EQ0j0b9Rhu8lM=;
	b=8rLXP4felfbgnioZ7Cdow2bGfkbHWr6FPW/va/9/Zv70TXiRkRP1pNYTdKL2FHhmiGWdrB
	uPMQlo+EEcXDR0n29sUG7/77ybSz+MDFqnspW1xhwEphtQjLVayNM2zjw/q1ChrtBxC5VZ
	WSzHQeFMz8fHC1mSvwTzAzb7QOq6WlU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="wc/LzcSY";
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769516211; a=rsa-sha256;
	cv=none;
	b=lBF1Y/Zwbmux3ZsP6B4Sc5L2tPRZlNIPOSN1xqSKwYqzFnS83p2Cas36CR10M3osHkg9Fr
	IrqirJb83o0CkHA9fIo4zCuj2EujY9OAeMmiSswnuP+ibU1gnNHvIn16RB7/ceUwN5G5Gv
	rj4FC8iYdVrq2iz7scd/jWEa7QOxiQw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769516209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e0pQYHM1jhSwp9PHWAhzAtLgw7dAo1EQ0j0b9Rhu8lM=;
	b=wc/LzcSY84XUN/M01s5VcIBtD1/lXhQlVZzRwxMLJY1XGT2wxJOzGUzWA5oPCfbPCsb1/O
	ht9YXkU/ZBWYV/j9FZpfqWjqnjxWaip5QHGmFskLEMQc1kWqyHjiSkHOF+suDP3tIX1G7K
	JeMpI6zZYGFo3G12ozp0269DFGB3g9I=
From: Qi Zheng <qi.zheng@linux.dev>
To: david@kernel.org,
	andreas@gaisler.com,
	richard.weiyang@gmail.com,
	will@kernel.org,
	peterz@infradead.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	dev.jain@arm.com,
	ioworker0@gmail.com,
	linmag7@gmail.com,
	akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-alpha@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-um@lists.infradead.org,
	sparclinux@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v4 6/8] um: mm: enable MMU_GATHER_RCU_TABLE_FREE
Date: Tue, 27 Jan 2026 20:12:59 +0800
Message-ID: <e2217546504668b8a87a39eb0e378839339a1bb4.1769515122.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1769515122.git.zhengqi.arch@bytedance.com>
References: <cover.1769515122.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 497D04000E
X-Rspamd-Server: rspam07
X-Stat-Signature: n6txyfwugwanz5w3eym8z4feydtz5c1i
X-HE-Tag: 1769516211-300186
X-HE-Meta: U2FsdGVkX19u6ws1uwh2yv5xNQ5ooZGIbir31/pKwU7IhdayXP0/KTpDOp3OdeSQUfijxTikoGKcGWD7Fcmeg2K9CQTv/ghqShIwkbG2iMoxQK/m9WvIGVdpc4DGkx/yNP+4E/UNTHwTNoK+UHMPoVpk70t1/eqBbFnD076slJ2v0LPgNn5uakVaBk3F7emct+74LhyIzAHGasyDJcA7qVtxLOA6IBR5+KKxCQ/KbNaAC3cHznkQQiHgVTzZ6xG2L0OazhlPpxvUsY1whhLYG3Tsdlaq1h37NVfmv5HSV8YA4OAIAVokClhSMUwO4MvAqVWwDjjKB1ywQJDapJ25o7u54cUhNOnVlwOgodM4c1tuNVaB8JZAMkEm6fmPPTQaPLQwTlxsC+T5XqDttWS4tX166OI57HJ7VKwcLokFuRWKaLUwS+bwxGvkbnlJtls8jawGaAvprglrujKWJWXJKi75Hw8vieGbh61DKLN0OWysCmn0PnmBGU6a5WimBvrBMht5ckjIpXZ0kby/+x3NsDPmIBQUCBohfkvfFjdiAK7E6XHsmUxTVmJdYpoqrEVDwtZMKMPLrn4GUocNPGq7sLoGrpm1ulQJublv80mSYA/yDt0EP8WiOR34chncxWZ4+s8/qHn2LaP2wSGlQXdjQrJKbA+OOO8dXepQ6Ezo73BMU7a4R1mKvYQgUmQu03ym0fnf9o83d+TuNjcwwAB1QtsO0XgyuGgtOeJLPP68TDyfQ75QGBc4oAoQoxz3fFF4I6sNgYzQRu5CjP1v+EgtiTHJWbh+QNMMaMil4cdV6cLBukZroQwlyDL455oU0j3cFNZvX8SMZr7Fka4FjOjCR0Uc57vKfiw2fvEn6Su1UpDvdcoJ54wt8K+IBwHr7cBtS1SUvjnxYgU0hI8i+2sGsjfDk5b/p0LQ6RSvWqmwMDTIpmSe5Ds83Xb+V3DgJycFrxzR5TDE+glXauZVhWy
 Y6nHzL+3
 Tkfi3wVoBsmYEQuE1N4D9n5Upl89r2VNhtPXA0NiQ9bp/liWqEujQ2Y7G0RB2VNLRKl5bHtazVjEjLee0Xr1gbNQYtB/ydNZSv0P5c1PVsv4wdf/QEC0xrNsFPrbbFBK3fgxBBaMx3wr9RkAxSZePodT/b9KmMVrkX1dapd24UmbAabpxRBO1fW1dmuJ9k0qbHlbvnD8vn5X+1hGYR7FS6djdaaAE2GBG1K2Q9YsHRpS9XG4Akt8CWwDNrF//c30RDYphOpSAxJAY0me0XKuBW9ZJXS2B8mtcRU5YD6hh4v8gjXU8z4nC5OTyFOIk4GGY8KNkUZT7wIWggXsmU8LiNgq00LAAI7cKg1abhYTpRDfkQhQkG9fHygukZYMNMYCMYPHRWsvBs2MFPnwdNm+hCushwByoFtnu8R69
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

On a 64-bit system, madvise(MADV_DONTNEED) may cause a large number of
empty PTE page table pages (such as 100GB+). To resolve this problem,
first enable MMU_GATHER_RCU_TABLE_FREE to prepare for enabling the
PT_RECLAIM feature, which resolves this problem.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
---
 arch/um/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/um/Kconfig b/arch/um/Kconfig
index 8415d39b0d430..098cda44db225 100644
--- a/arch/um/Kconfig
+++ b/arch/um/Kconfig
@@ -42,6 +42,7 @@ config UML
 	select HAVE_SYSCALL_TRACEPOINTS
 	select THREAD_INFO_IN_TASK
 	select SPARSE_IRQ
+	select MMU_GATHER_RCU_TABLE_FREE
 
 config MMU
 	bool
-- 
2.20.1


