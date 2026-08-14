Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B2F7C5B572
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 10:41:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 731FC6B02FE; Fri, 14 Aug 2026 06:41:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E1966B0301; Fri, 14 Aug 2026 06:41:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55AD06B0303; Fri, 14 Aug 2026 06:41:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 255876B0300
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 06:41:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9EF571C150D
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 10:41:26 +0000 (UTC)
X-FDA: 85099533372.24.2612B16
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id A359840005
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 10:41:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dQHUmCJQ;
	spf=pass (imf01.hostedemail.com: domain of joel.granados@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786704084;
	b=gwj5RYZE0pCtSpFeuvRWuJH1zqIDFx7sMP4S5h8Dy0c4UEjEph1pUgbXMM8IQRWEX3qsv1
	KvGih1Npsl20HUs9YpX0apuAVqKuybF+zdHSt/cBcn68CUonmPCrJ2CY6KQgCdHZdDAAUZ
	WenJDRmb4VxKDMpaxIgAc/5/3fRLWqc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dQHUmCJQ;
	spf=pass (imf01.hostedemail.com: domain of joel.granados@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786704084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ETfka9dqRURMa5xFoea1PMU0P/5QPArWw+vQFL/Gwa0=;
	b=hZZGPKgQJVPaOcWvRYSMmt5x7egtAQScGfgwM26cZevk1DIxKdiUE6+6rlC/oe+iK9Agb3
	P4JztfGTR9gaCRymF7a0hKN9GU0XvtF9N2tzPduVUEZDcojzIpLQxbaje9nGR9aN+xYlgM
	sZtPY4JQwZlvMPA7KEMHsU+K+NVlTow=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D27DA43F1B;
	Fri, 14 Aug 2026 10:41:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A9444C2BCB9;
	Fri, 14 Aug 2026 10:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786704083;
	bh=wc51Ar1jilhnjUGqKXjw2tY4+e0678L6LjQxN5ZQWOY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=dQHUmCJQbHpjKnszykCVG2CXecJtAI1vFAeTZz+5JJU2z9FGb+3OXBQ/bCdNSHiL5
	 2BzxxnDlk8zvKNQKQTN/ZuzEFCzHtZbpqT1NJFU3iQLEIq70SotgLWtuIDjRitnMuE
	 N0dRUrKmmswfRgW1DAlN8g/CkvxXImDojG4hVVrTFOVi2RPvvDWfTe6l988H44BkeE
	 ExNQVoZ08YfZ1nNrgFW1gdMiwIYytZNqvTu5heMOc1TnLEkaVl4txKhJF2AQvqtyNH
	 1K4iar9cDdS8YFn9FLl83jw9nbk5m3o8r2xdUoqY6Ldvgri/oaF/QB4J6GpzO9aHlg
	 PLByPtR7Qzhdg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8792DC5B572;
	Fri, 14 Aug 2026 10:41:23 +0000 (UTC)
From: Joel Granados <joel.granados@kernel.org>
Date: Fri, 14 Aug 2026 12:41:12 +0200
Subject: [PATCH v2 1/4] sysctl: Split data conversion and file position
 handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260814-lklm-partial_ctlvec-v2-1-9df50d26e477@kernel.org>
References: <20260814-lklm-partial_ctlvec-v2-0-9df50d26e477@kernel.org>
In-Reply-To: <20260814-lklm-partial_ctlvec-v2-0-9df50d26e477@kernel.org>
To: Kees Cook <kees@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc: Jianlin Shi <shijianlin11@foxmail.com>, akpm@linux-foundation.org, 
 vbabka@kernel.org, hannes@cmpxchg.org, surenb@google.com, mhocko@suse.com, 
 jackmanb@google.com, ziy@nvidia.com, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-mm@kvack.org, Joel Granados <joel.granados@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=12066;
 i=joel.granados@kernel.org; h=from:subject:message-id;
 bh=wc51Ar1jilhnjUGqKXjw2tY4+e0678L6LjQxN5ZQWOY=;
 b=owJ4nAHtARL+kA0DAAoBupfNUreWQU8ByyZiAGp+8M8vr+lEf7V6BRsfLebGaWNXeMT1k+ohr
 RnFxBUiAJih0YkBswQAAQoAHRYhBK5HCVcl5jElzssnkLqXzVK3lkFPBQJqfvDPAAoJELqXzVK3
 lkFPMfEL/0TFDnPZxzlhtXUe9sCMJNET1aPiqy5DcZpclEhrldW8L1wXDZr8CQcQcCghr2pqD1R
 0lnclMJMoJL+CnnpGkKKnpGIfNJlaEIsGxWP9gZtKY0H++d5VKmcZBiVJW+Eh3eOQSBslAwiZOQ
 Pie6ryhgU9ey1vQfJcuZ7fPgjrkU6IrBEMgSlKL3JuToGg2ZKx6m9q50HvR6CNAS/WfyTQi13G1
 APpUpKdLdYZD8A6WgS/MbMJioHFOvyHNHW2aKOvb/Q6C927bPNb/n9kM30BOE6//f1Dj+bPn9Ia
 EAdTLDB6Zcgc3DfEeASQ3U19FmWqGUFI9+SKbyv6PBi8TEzXq0PtFaBTH9F4LYFt86LGlsAqT8o
 tim5ER91NcIV8h9Z6ERaa+AQgKyI/oexSGdGA1JxcVLGpSau4y2l1v+gqPLjSok21K/9VBRKZWZ
 vROgkt1ttZ11Ku4CXJiQ58HYK2Rvz3Bm0nfODk+OJ9mGkrZJaYQ7e/7gsZRTPBWMbqGQWaLsuL4
 OU=
X-Developer-Key: i=joel.granados@kernel.org; a=openpgp;
 fpr=F1F8E46D30F0F6C4A45FF4465895FAAC338C6E77
X-Endpoint-Received: by B4 Relay for joel.granados@kernel.org/default with
 auth_id=239
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A359840005
X-Stat-Signature: b6p156papuemwyrizeoafg95e9q98ubo
X-HE-Tag: 1786704084-202193
X-HE-Meta: U2FsdGVkX19Kv6dKfCIyVcMJ6Kj0n/A7XF13AS9Mu8ptdY0poOhoFfVyOXrihV0BA1QPwDmm9yiUTooUihJMpqjhujKkfCD1DBtHa6IEiVEW6C84tYiIh5E/gpRqHHFqPERncSeQSq4Uls4z4gc8ZLKYRDcqJ3sPaL8+cmLm1cmG2QbH5xzTAfmsOudDEf0VinJ+OkcCS9s7qdUri3QNiK/UsMa9BTGRvwLydRA/xxlrVr5KYoq9YLXsc60FugcWe9+1Cu92wMaQPSSxQaWTgNIRpDT1Crq7ZGusCRb3DyL6uQAaIhLDybLWvPuOaJb3USYwvyjyCNXBGMnfJkPa+aMmlvhN3CTTaF64U1GDX73s+pvoPJdLycKM0cTMLbpzv+BZAg9k+t8ay7g2qL+3VS73mWFykYkQH5mop7qm9zfJ9TeAtb8Tv9VGhL9e1Rq1vHzJMyUHQ7mmYOnFqUyq4oNEUEeSSuExnDL/R06GTdG0Ob/sTiZ+VArFMR/nnaotAnbaA+dxiUppDwC4/uMrjCdvyfcbBORI2Tn07i7oYIVh9FPEqpoIHey7UIrKj9Xf3mN+8T+mx8FqFL0hsTdCUZHiwbe73OtXODQITh/D03Aa5RGnoTvvJkFOr/0aAKBuw5ay2YhIkIYSD5Hn0d5nZkGaJlepVnc/aVJ1AFL7GZ7ZH0+sk8b6ymobHotUir9ETlFSFyu8vGfBMONrkbD6GTUHLn+eUyrZPTvdSlwmGbxgdHYxMwZci7S8g6Is/ewkRYxNjKE3LOFCzQBrwvarnpITQ6MegdRcH8nwwQrJyhV2rFFZt4ouwUdCvvIw14DCdyduK1xaUEA/YJhy/iuY7FG3S+DyrsHM/ySWNdUmYflgaTrOEwbhZPDIRyauuel4NjxCK1BEQfEykPSa2PJEi+jV1hrzY8r01utl9Fb17vgi4emUMsx1p/VPAxj8A2iowAlD7BE2AmCLreqytCm
 h+AEVUB6
 JhjZoe+cw8BAuLEjKQsoJGmHGdcM5NcIb7ZWEA6EHDVQy0PhTN6SJ3yxi0QanDAZnthDD94I+DGemYLdteEQJQg9GfHfKoOSjJSysBM9L2NV/p87faUqQAtMVVTqwQSvHvJ/2ZG8pVfB+vQ2PGzjoRlgUu5fa9nCQ5uCzXYL4licLHw6/H1+yAVh6k80uuOK7bL3lLG2EFUrb80m7EDZnQ9EJvAvyCnCVK3RPH0OdoFOMr6U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Apply the conversions to the data in a new helper function
(apply_conv_on_vec) while file position handling and argument validation
stay in the original function. Rename function to prov_vec (from
do_proc_vec). This is a prep commit to isolate the logic that needs to
change to prevent partial sysctl vector writes. No functional change
intended

Signed-off-by: Joel Granados <joel.granados@kernel.org>
---
 kernel/sysctl.c | 211 +++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 126 insertions(+), 85 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index f7b75985d5420a522a316d1fade40dc7fbe60455..47a92cbbcb69cd361a18dba6606ae6ae8f86b5e2 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -595,7 +595,7 @@ static int do_proc_int_conv_minmax(bool *negp, unsigned long *u_ptr, int *k_ptr,
 static const char proc_wspace_sep[] = { ' ', '\t', '\n' };
 
 /*
- * Element type processed by do_proc_vec(). The tag selects the element size
+ * Element type processed by proc_vec(). The tag selects the element size
  * and signedness, and it selects which member of union proc_vec_conv is live.
  */
 enum proc_vec_type {
@@ -605,7 +605,7 @@ enum proc_vec_type {
 };
 
 /*
- * Converter passed to do_proc_vec(). Only the member matching the
+ * Converter passed to proc_vec(). Only the member matching the
  * enum proc_vec_type tag is ever read, so every dispatch stays fully typed and
  * no void * converter pointer is needed.
  */
@@ -637,101 +637,142 @@ static int proc_vec_conv(enum proc_vec_type type, union proc_vec_conv conv,
 	return -EINVAL;
 }
 
-/*
- * Read/write a vector of @type elements. The element size and signedness are
- * derived from @type, so a single runtime function replaces the per-type
- * variants. table->data is walked as raw bytes (@i) advanced by @size; the
- * converter performs the actual typed load/store.
+/**
+ * apply_conv_on_vec - Apply converter function on data vector
+ *
+ * @conv: The converter to be applied
+ * @table: The sysctl table
+ * @data_type: Type used in converter appliation (INT, UINT or ULONG)
+ * @data_size: Number of data elements.
+ * @conv_dir: %TRUE if this is a write to the sysctl file
+ * @buf_nbyte: Number of bytes for buf
+ * @buf: The user buffer
+ * @buf_left_final: Number of outstanding (non converted) bytes.
+ *
+ * Element signedness is derived from @data_type. table->data is walked
+ * as raw bytes (@data) advanced by @data_size; the converter performs
+ * the actual typed load/store. Sets buf_left_final to the number of
+ * bytes that where left outstanding after conversion. Can be > 0.
+ *
+ * Returns: %0 on success. Non-zero on error.
  */
-static int do_proc_vec(const struct ctl_table *table, int dir,
-		       void *buffer, size_t *lenp, loff_t *ppos,
-		       enum proc_vec_type type, union proc_vec_conv conv)
+static int apply_conv_on_vec(const union proc_vec_conv conv,
+			     const struct ctl_table *table,
+			     const enum proc_vec_type data_type,
+			     const size_t data_size, const int conv_dir,
+			     const size_t buf_nbyte, void *buf,
+			     size_t *buf_left_final)
 {
-	int vleft, first = 1, err = 0;
-	size_t left, size;
-	bool is_unsigned;
-	char *i, *p;
+	int vec_left, first = 1, err = 0;
+	size_t buf_left;
+	char *data, *p;
+	bool is_unsigned = data_type == PROC_VEC_UINT || data_type == PROC_VEC_ULONG;
 
-	switch (type) {
-	case PROC_VEC_INT:
-		size = sizeof(int);
-		is_unsigned = false;
-		break;
-	case PROC_VEC_UINT:
-		size = sizeof(uint);
-		is_unsigned = true;
-		break;
-	case PROC_VEC_ULONG:
-		size = sizeof(ulong);
-		is_unsigned = true;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	if (!table->data || !table->maxlen || !*lenp ||
-	    (*ppos && SYSCTL_KERN_TO_USER(dir))) {
-		*lenp = 0;
-		return 0;
-	}
-
-	i = table->data;
-	vleft = table->maxlen / size;
-	left = *lenp;
-
-	/* uint arrays are not supported, *Do not* add support for them. */
-	if (type == PROC_VEC_UINT && vleft != 1)
-		return -EINVAL;
-
-	if (SYSCTL_USER_TO_KERN(dir)) {
-		if (proc_first_pos_non_zero_ignore(ppos, table))
-			goto out;
+	data = table->data;
+	vec_left = table->maxlen / data_size;
+	buf_left = buf_nbyte;
 
-		if (left > PAGE_SIZE - 1)
-			left = PAGE_SIZE - 1;
-		p = buffer;
+	if (SYSCTL_USER_TO_KERN(conv_dir)) {
+		if (buf_left > PAGE_SIZE - 1)
+			buf_left = PAGE_SIZE - 1;
+		p = buf;
 	}
 
-	for (; left && vleft--; i += size, first = 0) {
+	for (; buf_left && vec_left--; data += data_size, first = 0) {
 		unsigned long lval;
 		bool neg = false;
 
-		if (SYSCTL_USER_TO_KERN(dir)) {
-			proc_skip_spaces(&p, &left);
+		if (SYSCTL_USER_TO_KERN(conv_dir)) {
+			proc_skip_spaces(&p, &buf_left);
 
-			if (!left)
+			if (!buf_left)
 				break;
-			err = proc_get_long(&p, &left, &lval, &neg,
+			err = proc_get_long(&p, &buf_left, &lval, &neg,
 					    proc_wspace_sep,
 					    sizeof(proc_wspace_sep), NULL);
 			if (!err && neg && is_unsigned)
 				err = -EINVAL;
 			if (err)
 				break;
-			if (proc_vec_conv(type, conv, &neg, &lval, i, dir, table)) {
+			if (proc_vec_conv(data_type, conv, &neg, &lval, data, conv_dir, table)) {
 				err = -EINVAL;
 				break;
 			}
 		} else {
-			if (proc_vec_conv(type, conv, &neg, &lval, i, dir, table)) {
+			if (proc_vec_conv(data_type, conv, &neg, &lval, data, conv_dir, table)) {
 				err = -EINVAL;
 				break;
 			}
 			if (!first)
-				proc_put_char(&buffer, &left, '\t');
-			proc_put_long(&buffer, &left, lval, neg);
+				proc_put_char(&buf, &buf_left, '\t');
+			proc_put_long(&buf, &buf_left, lval, neg);
 		}
 	}
 
-	if (SYSCTL_KERN_TO_USER(dir) && !first && left && !err)
-		proc_put_char(&buffer, &left, '\n');
-	if (SYSCTL_USER_TO_KERN(dir) && !err && left)
-		proc_skip_spaces(&p, &left);
-	if (SYSCTL_USER_TO_KERN(dir) && first)
+	if (SYSCTL_KERN_TO_USER(conv_dir) && !first && buf_left && !err)
+		proc_put_char(&buf, &buf_left, '\n');
+	if (SYSCTL_USER_TO_KERN(conv_dir) && !err && buf_left)
+		proc_skip_spaces(&p, &buf_left);
+	if (SYSCTL_USER_TO_KERN(conv_dir) && first)
 		return err ? : -EINVAL;
-	*lenp -= left;
+	*buf_left_final = buf_left;
+
+	return err;
+}
+
+/* Read/write a vector of @type elements. */
+static int proc_vec(const struct ctl_table *table, int dir, void *buffer,
+		    size_t *lenp, loff_t *ppos, enum proc_vec_type type,
+		    union proc_vec_conv conv)
+{
+	int err = 0;
+	size_t data_size, left_nbyte = SIZE_MAX;
+
+	switch (type) {
+	case PROC_VEC_INT:
+		data_size = sizeof(int);
+		break;
+	case PROC_VEC_UINT:
+		data_size = sizeof(uint);
+		break;
+	case PROC_VEC_ULONG:
+		data_size = sizeof(ulong);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (!table->data || !table->maxlen || !*lenp ||
+	    (*ppos && SYSCTL_KERN_TO_USER(dir))) {
+		*lenp = 0;
+		return 0;
+	}
+
+	/* uint arrays are not supported, *Do not* add support for them. */
+	if (type == PROC_VEC_UINT && (table->maxlen / data_size) != 1)
+		return -EINVAL;
+
+	if (SYSCTL_USER_TO_KERN(dir)) {
+		if (proc_first_pos_non_zero_ignore(ppos, table))
+			goto out;
+	}
+
+	err = apply_conv_on_vec(conv, table, type, data_size, dir, *lenp, buffer,
+				&left_nbyte);
+
+	/*
+	 * An unchanged left_nbyte signals a write with no parsed element; which
+	 * is an error. Using SIZE_MAX to detect this error is possible because:
+	 * 1. lenp is bounded by KMALLOC_MAX_SIZE in proc_sys_call_handler
+	 * 2. lenp could never be SIZE_MAX as it is a "ridiculous" (exabyte) allocation.
+	 */
+	if (left_nbyte == SIZE_MAX)
+		return err;
+
+	*lenp -= left_nbyte;
 out:
 	*ppos += *lenp;
+
 	return err;
 }
 
@@ -760,8 +801,8 @@ int proc_douintvec_conv(const struct ctl_table *table, int dir, void *buffer,
 	if (!conv)
 		conv = do_proc_uint_conv;
 
-	return do_proc_vec(table, dir, buffer, lenp, ppos, PROC_VEC_UINT,
-			   (union proc_vec_conv){ .uint_conv = conv });
+	return proc_vec(table, dir, buffer, lenp, ppos, PROC_VEC_UINT,
+			(union proc_vec_conv){ .uint_conv = conv });
 }
 
 /**
@@ -820,8 +861,8 @@ int proc_dobool(const struct ctl_table *table, int dir, void *buffer,
 int proc_dointvec(const struct ctl_table *table, int dir, void *buffer,
 		  size_t *lenp, loff_t *ppos)
 {
-	return do_proc_vec(table, dir, buffer, lenp, ppos, PROC_VEC_INT,
-			   (union proc_vec_conv){ .int_conv = do_proc_int_conv });
+	return proc_vec(table, dir, buffer, lenp, ppos, PROC_VEC_INT,
+			(union proc_vec_conv){ .int_conv = do_proc_int_conv });
 }
 
 /**
@@ -840,8 +881,8 @@ int proc_dointvec(const struct ctl_table *table, int dir, void *buffer,
 int proc_douintvec(const struct ctl_table *table, int dir, void *buffer,
 		size_t *lenp, loff_t *ppos)
 {
-	return do_proc_vec(table, dir, buffer, lenp, ppos, PROC_VEC_UINT,
-			   (union proc_vec_conv){ .uint_conv = do_proc_uint_conv });
+	return proc_vec(table, dir, buffer, lenp, ppos, PROC_VEC_UINT,
+			(union proc_vec_conv){ .uint_conv = do_proc_uint_conv });
 }
 
 /**
@@ -864,8 +905,8 @@ int proc_douintvec(const struct ctl_table *table, int dir, void *buffer,
 int proc_dointvec_minmax(const struct ctl_table *table, int dir,
 		  void *buffer, size_t *lenp, loff_t *ppos)
 {
-	return do_proc_vec(table, dir, buffer, lenp, ppos, PROC_VEC_INT,
-			   (union proc_vec_conv){ .int_conv = do_proc_int_conv_minmax });
+	return proc_vec(table, dir, buffer, lenp, ppos, PROC_VEC_INT,
+			(union proc_vec_conv){ .int_conv = do_proc_int_conv_minmax });
 }
 
 /**
@@ -891,8 +932,8 @@ int proc_dointvec_minmax(const struct ctl_table *table, int dir,
 int proc_douintvec_minmax(const struct ctl_table *table, int dir,
 			  void *buffer, size_t *lenp, loff_t *ppos)
 {
-	return do_proc_vec(table, dir, buffer, lenp, ppos, PROC_VEC_UINT,
-			   (union proc_vec_conv){ .uint_conv = do_proc_uint_conv_minmax });
+	return proc_vec(table, dir, buffer, lenp, ppos, PROC_VEC_UINT,
+			(union proc_vec_conv){ .uint_conv = do_proc_uint_conv_minmax });
 }
 
 /**
@@ -935,8 +976,8 @@ int proc_dou8vec_minmax(const struct ctl_table *table, int dir,
 		tmp.extra2 = (unsigned int *) &max;
 
 	val = READ_ONCE(*data);
-	res = do_proc_vec(&tmp, dir, buffer, lenp, ppos, PROC_VEC_UINT,
-			  (union proc_vec_conv){ .uint_conv = do_proc_uint_conv_minmax });
+	res = proc_vec(&tmp, dir, buffer, lenp, ppos, PROC_VEC_UINT,
+		       (union proc_vec_conv){ .uint_conv = do_proc_uint_conv_minmax });
 	if (res)
 		return res;
 	if (SYSCTL_USER_TO_KERN(dir))
@@ -1066,8 +1107,8 @@ int proc_doulongvec_conv(const struct ctl_table *table, int dir,
 				int (*conv)(bool *negp, ulong *u_ptr, ulong *k_ptr,
 					    int dir, const struct ctl_table *table))
 {
-	return do_proc_vec(table, dir, buffer, lenp, ppos, PROC_VEC_ULONG,
-			   (union proc_vec_conv){ .ulong_conv = conv });
+	return proc_vec(table, dir, buffer, lenp, ppos, PROC_VEC_ULONG,
+			(union proc_vec_conv){ .ulong_conv = conv });
 }
 
 /**
@@ -1087,10 +1128,10 @@ int proc_doulongvec_conv(const struct ctl_table *table, int dir,
  * Returns: %0 on success.
  */
 int proc_doulongvec_minmax(const struct ctl_table *table, int dir,
-			   void *buffer, size_t *lenp, loff_t *ppos)
+		void *buffer, size_t *lenp, loff_t *ppos)
 {
-	return do_proc_vec(table, dir, buffer, lenp, ppos, PROC_VEC_ULONG,
-			   (union proc_vec_conv){ .ulong_conv = do_proc_ulong_conv });
+	return proc_vec(table, dir, buffer, lenp, ppos, PROC_VEC_ULONG,
+			(union proc_vec_conv){ .ulong_conv = do_proc_ulong_conv });
 }
 
 /**
@@ -1114,8 +1155,8 @@ int proc_dointvec_conv(const struct ctl_table *table, int dir, void *buffer,
 {
 	if (!conv)
 		conv = do_proc_int_conv;
-	return do_proc_vec(table, dir, buffer, lenp, ppos, PROC_VEC_INT,
-			   (union proc_vec_conv){ .int_conv = conv });
+	return proc_vec(table, dir, buffer, lenp, ppos, PROC_VEC_INT,
+			(union proc_vec_conv){ .int_conv = conv });
 }
 
 /**

-- 
2.50.1



