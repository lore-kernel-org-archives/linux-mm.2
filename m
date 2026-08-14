Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A64DAC5B572
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 10:41:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 890BB6B0301; Fri, 14 Aug 2026 06:41:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 819BC6B0304; Fri, 14 Aug 2026 06:41:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66D616B0302; Fri, 14 Aug 2026 06:41:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 31FE56B02FE
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 06:41:27 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B98FFA0423
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 10:41:26 +0000 (UTC)
X-FDA: 85099533372.26.4CB363D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id ECE1680004
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 10:41:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eKK7b8HQ;
	spf=pass (imf30.hostedemail.com: domain of joel.granados@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786704084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HYIzYjfC8zO2G0fNU5Y+z1PQUJW9A5aF7NuyKF6BFlI=;
	b=TnLhR62ZVqtbUJFKhhx3Opws5vsML5aoya9tgSXlGF9IU50lDaufX4SLzueFSsbeKLF/GX
	zQWyMaaOKYVG6bZuqsWJyGBfDMft4delSscdWLQZLLeICLW0tsyiHOYz1nd26DTGTXeO2e
	D5wiwNlBXhggzy5sOn0SvTX8oGKT5vk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786704084;
	b=PuKdSYTvX/ey4DSVAeau9eSa/5E9pd/AIQyvENDEPHsKTzk256cGZj270jCJi0OCjiojjk
	tqT3wBcoyhfvJnury36/AtzZjl7Pts8AOfJ14OYjvS+7TVD+OCoaYO26l5t3vUoLB287c7
	E4jFEX0Ma5c47Cq8NeDuEQEMdsgP+xI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eKK7b8HQ;
	spf=pass (imf30.hostedemail.com: domain of joel.granados@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 22347601E0;
	Fri, 14 Aug 2026 10:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BC9EBC2BCF7;
	Fri, 14 Aug 2026 10:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786704083;
	bh=CJlMe8eckMtRbFMo6OjTUfLXAWdcwp7d+38BdYAigIE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=eKK7b8HQktyx7HHxZzmr9+dwYq8G83AG+MtacqM6wPAyyvVlvZ50/BTv1ASYdCBgc
	 M4pdva1YgaBnVbRkuI+nBkfipPy9wJKzTaS7OmWzd1+FQTpWqbOjoZQW/rnyVZEe0J
	 bnjZC8VHcm9IAJbtxBfLzT4wtEcf449pr5CmNo1KpZKkREQUcSg9r91atpIBL6lRDc
	 rwb5zFOcLEsgNJFLT5yGynBMvYMwc3kFo5RIFPsiIiJ3PSVC3TpUo2TbdxH3tIHZfM
	 Yl59Ff1n6D/oFNcosGzKX7dV50UqzPAC6zfHN+L+P4knGnnxWGgJJL2CePLyjPbVbR
	 fyZqVEIkog3Zg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7F22C5DF6A;
	Fri, 14 Aug 2026 10:41:23 +0000 (UTC)
From: Joel Granados <joel.granados@kernel.org>
Date: Fri, 14 Aug 2026 12:41:14 +0200
Subject: [PATCH v2 3/4] sysctl: Disallow partial updates for erroneous
 sysctl vectors
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260814-lklm-partial_ctlvec-v2-3-9df50d26e477@kernel.org>
References: <20260814-lklm-partial_ctlvec-v2-0-9df50d26e477@kernel.org>
In-Reply-To: <20260814-lklm-partial_ctlvec-v2-0-9df50d26e477@kernel.org>
To: Kees Cook <kees@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc: Jianlin Shi <shijianlin11@foxmail.com>, akpm@linux-foundation.org, 
 vbabka@kernel.org, hannes@cmpxchg.org, surenb@google.com, mhocko@suse.com, 
 jackmanb@google.com, ziy@nvidia.com, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-mm@kvack.org, Joel Granados <joel.granados@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4178;
 i=joel.granados@kernel.org; h=from:subject:message-id;
 bh=CJlMe8eckMtRbFMo6OjTUfLXAWdcwp7d+38BdYAigIE=;
 b=owJ4nAHtARL+kA0DAAoBupfNUreWQU8ByyZiAGp+8NHUjrC7/UY5qTi0oMM3LIpSbQYbXCUtz
 uIVIOsjNamHHIkBswQAAQoAHRYhBK5HCVcl5jElzssnkLqXzVK3lkFPBQJqfvDRAAoJELqXzVK3
 lkFPMgUL/1+0vc9a7WaBT4uQrdf6jczPCFm0E/iBcZQPHgbAfV+CEAmg0uJf2GHtzgs9xmRKM6E
 HxBTtxcUx5A/LhJWwVQberzSHPAf1BaKBa5ymaidcfZNBCG0TEn5hVChTZqPHT8m5frNEYt4JQu
 Ao5xgFF2wgHM4ExTr5rB1xccWG8AF+FRZI+YcR747VuBx2BUd70cOmQeTrxSyoITjkOVzL9Ad6Y
 0owmDRcqrx3GJRa8xcK0CCuw9nLGB53pQfkAJhBTkD+B9OKgf6CmgHLLJsUqreQzPsRJsxR7f2k
 PKXfYS7UZTBKMrKouFiXKAjAiX49LXafoFkwGzwrsFIfBeliqQPkw+YFHmxfbJnHvCawt37SPdM
 x1qVyHmVRqzyp73hHuxn3IGLUBsjURiyVRGNdAHyRMnwm+pnL1NoZI/vNGRUg3qVXKOo5C4Xcn7
 EOPhbwbV3bTl7u+SWBFdqsthVkyw0VGeOE2sGm6a/4+oG/3YeolYydFWmyZnrtKnghQE32o11K4
 2M=
X-Developer-Key: i=joel.granados@kernel.org; a=openpgp;
 fpr=F1F8E46D30F0F6C4A45FF4465895FAAC338C6E77
X-Endpoint-Received: by B4 Relay for joel.granados@kernel.org/default with
 auth_id=239
X-Rspam-User: 
X-Stat-Signature: fmy8hag5emat8pr38xfq45s434a6xpdf
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ECE1680004
X-HE-Tag: 1786704084-260709
X-HE-Meta: U2FsdGVkX18JWPkq8pPrhYDhRJKc0GsJMqmXUz3qcQIE9/O0AJ6O0ufReXHmtBD6XVPB6pd0Tokylbf0sWe9ztSL5YBts1MDdg82Yxm80QoJAbLrN21hMxXlUVUfApy2AyuMMNqKhofekKpqZ4RqWs2WAydAI7cF4W1Tv1Q1CfTijRHt0kBbGE15lLLN9wTQ0Tlge8b5uqHuCjZ3LEEY1gq3/zG/eDEQ8QmtBQdWpSFh5vsuOaD4RY235e6ArPB5b8J0gvBSiyVl3QP+4zzpJ7uayD76qyEeltExJflWNu/c3AzZ7qYqrTGm0yT5Y+fbAf59mIsrwTCh3eA0zwaWha5NwWpcCc5FkRXI9BqA65UbmTAaFPTTtopQ3kvk3/MjAUk8Xa6e/SDSvmfiqNiLF4Olm10ciW5HXI+cNCwtWglpDxS/q/4fE7ftMuzrORUXcK1PBTyhJun8SviWcUA5rdJyoG4KdAySfznke7JN5ftHHzpD3ScsWEIM1e4fIENtPne/5//oC+8cIphdXvIv1/6DY1Y7lGkLuuK2m2vzCmdbbVp3unSwGylYWWZOhXjfUYf0QYKjTp2qM4HoHmlxnk7QvBxl5PBrAFzXub0OjbImNzbvj9rQKLhTatiNIzox+8ew6M/6la+3oOC0SDqSOBnRnaGOTlWBhC44QZEUdrdbDJDVc6/f6L2PyQZcmk7wxiqk3RY5gqiX9TNjjPzzUbV/pizrx35bPuBCN6nVb31jp2RW9uRjjw+1XextyAtllLVGMs2AZaLspkMjZ54iswbIpH4r5+x9nFBGKqvihf/Xuai0cT49ywj/8DPjsht5nwdmwSOFIYjx3Tkepw0ClbJowHkvgHsCLck34nuPFnswdpBcXt9N4tXVODNW/eweTgmLWDuEPhEIS3EDH0MaTYYyT38di270eMU4l7dEIfVbTljhU6lF9QCsemClbDULQ96blQLw7aGXHOESxgv
 uDJnzf1C
 EJKhrx76addyfknDqv3yXYvLgyytuOdX3rveeQ9GP+GezSp9r41wkrqsZLEPVuJBsqprb96vCr+NUOeFi59JOjHeY+k07j9FjBV05hdE8foQTGkoW+qhz7h0v61M3tbx8AbawVNuZuy4qr28Y1GJVjWw0P3rAv4q4mWJHBGIxi+31OZPntNTYq35UTwKepzpFFye4C1fuONw9B7nMz6CxMPKt/ONfw0uQMhhT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When updating the kernel sysctl vectors there is a chance that not all
vector elements are updated due to erroneous input. Use a staging
variable that holds a copy of the vector and commits to the actual
table->data only when all input is successfully updated.

The staging is only for vectors; cases where table->data points to a
variable should not be staged as they will not be updated on input
error. PROC_VEC_UINT is not included because UINT arrays are not
allowed.

Replace first with nr_conv, incremented where first was cleared. first
is exactly nr_conv == 0, and the counter doubles as the number of
elements to publish.

Example of behavior that is being prevented:

  # echo "4 4 1 7" > /proc/sys/kernel/printk
  # echo "1 x" > /proc/sys/kernel/printk
  -bash: echo: write error: Invalid argument
  # cat /proc/sys/kernel/printk
  1 4 1 7 <- incorrect

It should be unchanged ("4 4 1 7") on error.

Link: https://lore.kernel.org/all/tencent_A860C873956A52E26AD8D309A308A241BA08@qq.com/
Signed-off-by: Joel Granados <joel.granados@kernel.org>
---
 kernel/sysctl.c | 65 +++++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 52 insertions(+), 13 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 7e9024899be6d5971752dd5639ab4b806a899081..25577ffc2801267cc69df60a1064ada9efd4b97d 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -637,6 +637,26 @@ static int proc_vec_conv(enum proc_vec_type type, union proc_vec_conv conv,
 	return -EINVAL;
 }
 
+static int commit_conv_vec(const enum proc_vec_type data_type, void *dst,
+			    const void *src, size_t nr)
+{
+	size_t i;
+
+	switch (data_type) {
+	case PROC_VEC_INT:
+		for (i = 0; i < nr; i++)
+			WRITE_ONCE(((int *)dst)[i], ((const int *)src)[i]);
+		return 0;
+
+	case PROC_VEC_ULONG:
+		for (i = 0; i < nr; i++)
+			WRITE_ONCE(((ulong *)dst)[i], ((const ulong *)src)[i]);
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
 /**
  * apply_conv_on_vec - Apply converter function on data vector
  *
@@ -663,22 +683,31 @@ static int apply_conv_on_vec(const union proc_vec_conv conv,
 			     const size_t buf_nbyte, void *buf,
 			     size_t *buf_left_final)
 {
-	int vec_left, first = 1, err = 0;
-	size_t buf_left;
-	char *data, *p;
+	int vec_left, err = 0;
+	size_t buf_left, nr_conv = 0;
+	char *data, *data_stage = NULL, *p;
 	bool is_unsigned = data_type == PROC_VEC_UINT || data_type == PROC_VEC_ULONG;
 
-	data = table->data;
-	vec_left = table->maxlen / data_size;
 	buf_left = buf_nbyte;
 
+	data = table->data;
 	if (SYSCTL_USER_TO_KERN(conv_dir)) {
 		if (buf_left > PAGE_SIZE - 1)
 			buf_left = PAGE_SIZE - 1;
 		p = buf;
+
+		if (table->maxlen > data_size) {
+			data_stage = kmemdup(table->data, table->maxlen, GFP_KERNEL);
+			if (!data_stage) {
+				err = -ENOMEM;
+				goto out;
+			}
+			data = data_stage;
+		}
 	}
 
-	for (; buf_left && vec_left--; data += data_size, first = 0) {
+	vec_left = table->maxlen / data_size;
+	for (; buf_left && vec_left--; data += data_size, nr_conv++) {
 		unsigned long lval;
 		bool neg = false;
 
@@ -703,20 +732,30 @@ static int apply_conv_on_vec(const union proc_vec_conv conv,
 				err = -EINVAL;
 				break;
 			}
-			if (!first)
+			if (nr_conv)
 				proc_put_char(&buf, &buf_left, '\t');
 			proc_put_long(&buf, &buf_left, lval, neg);
 		}
 	}
 
-	if (SYSCTL_KERN_TO_USER(conv_dir) && !first && buf_left && !err)
-		proc_put_char(&buf, &buf_left, '\n');
-	if (SYSCTL_USER_TO_KERN(conv_dir) && !err && buf_left)
-		proc_skip_spaces(&p, &buf_left);
-	if (SYSCTL_USER_TO_KERN(conv_dir) && first)
-		return err ? : -EINVAL;
+	if (SYSCTL_USER_TO_KERN(conv_dir)) {
+		if (!err && buf_left)
+			proc_skip_spaces(&p, &buf_left);
+		if (!nr_conv) {
+			err = err ? : -EINVAL;
+			goto out;
+		}
+		if (!err && data_stage)
+			err = commit_conv_vec(data_type, table->data, data_stage, nr_conv);
+	} else {
+		if (nr_conv && buf_left && !err)
+			proc_put_char(&buf, &buf_left, '\n');
+	}
+
 	*buf_left_final = buf_left;
 
+out:
+	kfree(data_stage);
 	return err;
 }
 

-- 
2.50.1



