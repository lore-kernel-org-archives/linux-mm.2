Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52B9EC53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 05:38:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 388C66B0088; Wed, 29 Jul 2026 01:38:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 312A86B008A; Wed, 29 Jul 2026 01:38:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DA1A6B008C; Wed, 29 Jul 2026 01:38:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E7D4F6B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 01:38:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 68661A05D1
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 05:38:36 +0000 (UTC)
X-FDA: 85040709432.15.A684688
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	by imf27.hostedemail.com (Postfix) with ESMTP id E3EE740003
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 05:38:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ugreen.com header.s=pkvm2402 header.b=AT6AvoBf;
	spf=pass (imf27.hostedemail.com: domain of warren.xiong@ugreen.com designates 54.243.244.52 as permitted sender) smtp.mailfrom=warren.xiong@ugreen.com;
	dmarc=pass (policy=none) header.from=ugreen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785303514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BBQAv/ZzACDpSHuQjeke8uzjlU3mEHl+neRNSNWMQ1g=;
	b=usnxTKMKP8N2i60TM6EDsFx/CUAWgoL8ESXPFIOs6PpQWrwmvqcUs/JgRO6MZjSsMfpTrk
	Ekfg9ailIcZwsKgaSmW9dJvltZ70hUiIZ00j/V7CtXvU49BjoIYOHKNWZ5hVec71p4wyM3
	zklJgHJw6eyqDDiQJAwNBQOVI9Szews=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785303514;
	b=cAaOYW5MY9opHyv8IdpisPBx0lo2S1r85eTj0jTqOsjAbnlUoNcEcNgbVoORWc0K0qvtSW
	6peKZO8dpvfHMEhsKc07GILAMxuwurwAy1yd6NWHn9h9TLortDAZ8Gis0HfBT7jx5EvPd2
	FJi61hW32Gm9usiei/ysRNaZpcUhwg0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ugreen.com header.s=pkvm2402 header.b=AT6AvoBf;
	spf=pass (imf27.hostedemail.com: domain of warren.xiong@ugreen.com designates 54.243.244.52 as permitted sender) smtp.mailfrom=warren.xiong@ugreen.com;
	dmarc=pass (policy=none) header.from=ugreen.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ugreen.com;
	s=pkvm2402; t=1785303508;
	bh=BBQAv/ZzACDpSHuQjeke8uzjlU3mEHl+neRNSNWMQ1g=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=AT6AvoBfBRHtXuLqvDk/AaN/C5tPzFuLkJNlfhZJOsmazRRlYZsyLgIEYJMNIBO1W
	 ZnPLSVJiY3eZfw95peKC1WVAnHsqNvvaGiUyJRE93+32oVIXI1s8GrlDHnKLnmSr2+
	 dOb3Gdisbb3qDOMhrDCAVV0Fsp3mrGyYC0mcIjEs=
X-QQ-mid: zesmtpsz9t1785303506t8e81de5d
X-QQ-Originating-IP: QhtVy0fdCH9JSosScZug+MaMnL3g/GeOrGRccLdvFIQ=
Received: from debian12.. ( [14.153.226.139])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 29 Jul 2026 13:38:20 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 7069893039906020633
EX-QQ-RecipientCnt: 4
From: Warren Xiong <warren.xiong@ugreen.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Warren Xiong <warren.xiong@ugreen.com>
Subject: [PATCH] tools/mm: prevent page_owner_sort from truncating input
Date: Wed, 29 Jul 2026 13:38:12 +0800
Message-Id: <20260729053812.882137-1-warren.xiong@ugreen.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:ugreen.com:qybglogicsvrgz:qybglogicsvrgz6b-0
X-QQ-XMAILINFO: NjFgbzSnCN+Vl4wJMP11iyjkmBAl0knBQmnpKWDUCdiRLj+KRvB8ccg+
	y4qeD5KaMpJ4Fv3RZyw9cxh13vhOa5J+QUNlqzExbmb9j1MWhJDMhx1CLRHnI0Ym8d43zfY
	mvY5BjTYDaBOcYC9wyOr5xL0qkLg5IN9fhrMhGlJn1f0f6CHbiLJFcLOPYWTQv79hGUA1Ac
	hmh8L1uIYI4umFP9zwXSFxx35CjFqWgG72YKM5TsfbQPLwr4hmSROKLz5oK9HPpetqTYWZa
	NDUUEKHodvyzDE0LZSgxWevbjfRyKtSaBOGohQOuMJFiYyuGsc+Kt8goQab3bH9ys+6hELK
	YO+ggduyBm+3MVyunSFcS1WyDPjDlFwR4X9ahdTjj+Z1ZNJ9b33KtaZ7jGvIcR2yaQDX7gD
	3pBV8oLEwRx/JTeiiftiJ/hz614l1ghSZt7NqvWsYQEbP3ysakZbDk9Rs9TKCJtf0WSp91E
	xSEOT5H3nYO9HslMOo1OI2bFh+HT715A1axdRX8agAKDD6lCXSgDLs7g7qUbBkUaWy+B2pY
	Ncoe4iLAevavcfmXr4/7MyynADqmQ9liFh2qUYQGSzkN7ZTNFWrXSydSYDHYjWDrYDwfQVz
	tj5DcSs01KFLXlp9F8aG/6oiJq0TjxbZfTLjNkXqlS3aax4wyqJUxx2oKdPdfhGUivBzfaq
	MGXE7wKIJQ4YvI0SmBsJbdw0tSPos4UFrMOifLz44ct/fhS5bYt43S+VNo/VVXbXpVfmttB
	PCqeiC3CXP97/QCcqF5uA1xlR6a1ojUtY2IUUPBGpTGeZOaxO8MQehxiH4p1vIJbOZmwdSL
	WEeXKKPXXVrUBjBW6h8VCapTpo0IMlsGGSODf6IrxGFkZ87XkltvSaqOQ7Xs1QhoFzA9LB3
	9HdhsYK9PEuE9c4ZvcCNZYZGPrZEbUQslz9vrCJ5ve6rPOVHSFWVwKUV5iHqty+ELvdnQ4B
	vdnCInP1tCS4Iwbh9o+yOB1MtxBa6TQPfs5n781gDlsNySg83RkwMl2zEtYaDYeV8Y6eHgw
	Uq7e/QJIFFpA32ZBKPmQv6SOBNz4RFU9MifuDLRX/XrdgHqiOMYQKdt2iy3tvsn/3AzLd3V
	g==
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E3EE740003
X-Stat-Signature: 4nwnoe7wxh97ax5zfdjcf1mx3n79qzk3
X-HE-Tag: 1785303511-285272
X-HE-Meta: U2FsdGVkX1/O/R3mPAb3Mbw9Jew1UEU43MAd16ZHqbHnM+yI3i34h4N47j+7qtmLFPtAlZ/8og9aEkjT7Rf63YUNoyrp7qqpQZq7hg1YBRQ5OUISmcyRyEwB4zBEPEzgfZgvZVny1KIrXEk/xQEwxC0SGqtINnWCDZeZEXowrRwfhOWjMCfLwqHtv7kpDNRL9DQEiabBBhA+PtAH8VnvbjiayToFsmBotycxoVIjp9fgmJXJJ7lBeHso3VJaW1/NJidUl45u8RMmENkqnEgO3UkqPlIfg0QieLUiRFfMqbrzPHVMxCtdeaJmiBmJwAEUToBa2g/pxjM7ubKtz+NA28s5RdQuNu+0dvBlW7jcEvgqgcT0PvJ4amUU2pwJx2reMMASz5WPc+DsA5t9JXMdda06iIIagTE/QgUkVIc1rwcbAgrQJ3LFyOVr8zlq7r777uGxyGHHYh7mZZwlcvyKzyvEjEPCd4jguBKuHpgRV3o4VvWixDK3lwcoOfT/OZJC+stwNy+BI6XsL7pK1+Dc3r345GasDWqfZmZukfatmuws6eJgPg9bfIze7+aV8rNz/jmPBlcV/Wbhrvx6jWxv76I0dIutuILxnkYfI06fHe0yonYg9BXl+KZ8zCUxqfaumE1sW/sd7plOY8xaxBPYrFpcJFiZwGxP/clD8YCIevBvVUB71ljCEzLaVRxz6FJ3zQ/HkEDbYaqKWr11RJwLK/47Sd0HtQw/tqtWoTbeD3TdvRQf46gFKrsGVazD6wYnsC1oJmwsPaYs+xzghgT6zeBFNEXkSAqjJ9vbXBnaWxY6y4ojiFzPXJ8Qu9hxn4LAxTuNurul+Llb7ETBH9XCnV5c3gm21R1RgklqQdBEKieD6p06ekPMhVUMJkMXt8BOagf6zeLv0XM30/4CtPWRjA5YBdDjL+jvwEMQ1SrjDKx2/lg8RpPOQimVKYOz3f2OYBzA+zsZnCMREuoAF6V
 ElZUFbK1
 QGuxEY/HOT20cUfJaINnjaJCXS77Z2B97lK2meUb0ghX0sH7f9JjOb/8GfuIiycIRjm+5JPeLPUAxQshaN2RDexAdtaqdHG4uo1Pb9QlX+8wyWK5Wjmje3ko1FcY8gqyThnBtAlUWh+ABW6wy5fKK+YiBjNOZebz67P/MBmS97jTbHA0HYlI5xGKNxiJ2JHf+kQkwhJ4x4MhHZou3LB66RoFR8db4NOkNCffNEQUUvU/UacxyBgvsiOYoZ2q3ObKkp6uWjpqmpdBwegwBJ6zQiYJ91DqokCcB/Qp4t0/JmhiR48dRNpVm55PRaCGFB155o+VUirwo0giu23V1+kCRuFkrEzkon7F+vg/0yQrmRaKGo+G/Xl6N8DKZNftyPZBYiVSa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

page_owner_sort opens the output file with "w" before reading the input.
If both paths refer to the same file, this truncates the input and the
tool silently processes zero records before returning success.

Open the output without truncating it and compare the device and inode
numbers of the opened files. Reject matching regular files, then truncate
regular output files only after the check. This also detects hard link and
symbolic link aliases while preserving non-regular outputs such as
/dev/stdout.

Signed-off-by: Warren Xiong <warren.xiong@ugreen.com>
---
 tools/mm/page_owner_sort.c | 41 ++++++++++++++++++++++++++++++++++----
 1 file changed, 37 insertions(+), 4 deletions(-)

diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
index 35d3d2549..602f541d8 100644
--- a/tools/mm/page_owner_sort.c
+++ b/tools/mm/page_owner_sort.c
@@ -713,7 +713,8 @@ int main(int argc, char **argv)
 	FILE *fin, *fout;
 	char *buf, *ext_buf;
 	int i, count, compare_flag;
-	struct stat st;
+	int fout_fd;
+	struct stat st, output_st;
 	int opt;
 	struct option longopts[] = {
 		{ "pid", required_argument, NULL, 1 },
@@ -836,13 +837,46 @@ int main(int argc, char **argv)
 	}
 
 	fin = fopen(argv[optind], "r");
-	fout = fopen(argv[optind + 1], "w");
-	if (!fin || !fout) {
+	if (!fin) {
 		usage();
 		perror("open: ");
 		exit(1);
 	}
 
+	if (fstat(fileno(fin), &st)) {
+		perror("fstat input");
+		exit(1);
+	}
+
+	/*
+	 * Do not truncate the output until after checking whether it refers
+	 * to the input file.  Comparing the opened files also catches aliases
+	 * created with hard links or symbolic links.
+	 */
+	fout_fd = open(argv[optind + 1], O_WRONLY | O_CREAT, 0666);
+	if (fout_fd < 0) {
+		perror("open output");
+		exit(1);
+	}
+	if (fstat(fout_fd, &output_st)) {
+		perror("fstat output");
+		exit(1);
+	}
+	if (S_ISREG(st.st_mode) && S_ISREG(output_st.st_mode) &&
+	    st.st_dev == output_st.st_dev && st.st_ino == output_st.st_ino) {
+		fprintf(stderr, "Input and output files must be different\n");
+		exit(1);
+	}
+	if (S_ISREG(output_st.st_mode) && ftruncate(fout_fd, 0)) {
+		perror("truncate output");
+		exit(1);
+	}
+	fout = fdopen(fout_fd, "w");
+	if (!fout) {
+		perror("fdopen output");
+		exit(1);
+	}
+
 	if (!check_regcomp(&order_pattern, "order\\s*([0-9]*),"))
 		goto out_order;
 	if (!check_regcomp(&pid_pattern, "pid\\s*([0-9]*),"))
@@ -854,7 +888,6 @@ int main(int argc, char **argv)
 	if (!check_regcomp(&ts_nsec_pattern, "ts\\s*([0-9]*)\\s*ns"))
 		goto out_ts;
 
-	fstat(fileno(fin), &st);
 	max_size = st.st_size / 100; /* hack ... */
 
 	list = malloc(max_size * sizeof(*list));
-- 
2.39.5


