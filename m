Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5215EC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 12:18:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BEA86B04D5; Thu, 13 Aug 2026 08:18:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 547D66B04D7; Thu, 13 Aug 2026 08:18:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 485296B04D9; Thu, 13 Aug 2026 08:18:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 19D266B04D5
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:18:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9BEC780145
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:18:53 +0000 (UTC)
X-FDA: 85096150146.10.8A23BE3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id AB2BF40009
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:18:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wkb8wCBH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of joel.granados@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=joel.granados@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786623531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fX7Lwab8iW1z5kp2BBYTrZ1W3zgss5vemPidILBs6wc=;
	b=bP+RPQNr/ntyKT+jkWBflkOwkOJXxhkYbMWZ98sQUBRN2FdIMZh6T9CGbswuho48PV2ZHb
	uGGxHp3K7JOcHZ0GK6k07bbGrAmnsUsL+CWkQ1NAv3sLYE6FbZVFNfwj7YwDLVq/2fF+IK
	OpezCpOKcbSnW8km5nsWwJ8ilQbRbQc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wkb8wCBH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of joel.granados@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=joel.granados@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786623531;
	b=WeELdKY9yQ1ku8TJPWcfuGvrgl6jCK1LL5vRiKcC2OGwYD7dEwORl/sk6x60/wgTp1a9w0
	iramnouTr9uiG/vcgqhBEZOQyr5XjkwFBRTzQZUuZB73WY3vNK9YL1Pi6idY5rU1Wa5BSh
	66bAw1FsHNCmKWShbUKPuQI+HOaB4vY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D63F144043;
	Thu, 13 Aug 2026 12:18:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 903E7C2BCFA;
	Thu, 13 Aug 2026 12:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786623530;
	bh=RQxbygSuwuyad2h3rnwJdX+5/FDgwJkAzThNIKfsnKw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Wkb8wCBHVyP7hmrq29NCqd3BCfuAro9J22h1l7HqmDzflqEPhjAiUVuztmjDGGai7
	 Nt9/Al03eqBCZtffr4YFe2pRjCRm2dIhRO0kjcjwEMTX46makDPB6LPf8E08lnwoc7
	 VoW72KTwhh4o8dqQj3D+Z16wqlfxrxeK362wZQdumu6/35iN0RPL9zpLgPY8uJAmnx
	 N1+rXsDAQCR5e5wGXlbN5CtdZ/cyMNpcD10eDsT2bsjaYjdRtPooMuJo8UQOMJOOdR
	 M2+nAuMNtJOUe/cv0Jc+VtFnOhcXSyDlgJGpyMq0lYQSfiEFk1U4KR0JKuVVI8wvDH
	 Je/kAy+K166jQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70EC7C5CFCF;
	Thu, 13 Aug 2026 12:18:50 +0000 (UTC)
From: Joel Granados <joel.granados@kernel.org>
Date: Thu, 13 Aug 2026 14:18:39 +0200
Subject: [PATCH 3/4] sysctl: Disallow partial updates for erroneous sysctl
 vectors
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-lklm-partial_ctlvec-v1-3-df9e51c13704@kernel.org>
References: <20260813-lklm-partial_ctlvec-v1-0-df9e51c13704@kernel.org>
In-Reply-To: <20260813-lklm-partial_ctlvec-v1-0-df9e51c13704@kernel.org>
To: Kees Cook <kees@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 linux-mm@kvack.org
Cc: Jianlin Shi <shijianlin11@foxmail.com>, akpm@linux-foundation.org, 
 vbabka@kernel.org, hannes@cmpxchg.org, surenb@google.com, mhocko@suse.com, 
 jackmanb@google.com, ziy@nvidia.com, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Joel Granados <joel.granados@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4178;
 i=joel.granados@kernel.org; h=from:subject:message-id;
 bh=RQxbygSuwuyad2h3rnwJdX+5/FDgwJkAzThNIKfsnKw=;
 b=owJ4nAHtARL+kA0DAAoBupfNUreWQU8ByyZiAGp9tidSYtNXQW85HJlqyfka+JzTA3W1ID/P+
 //JCQ9gVdu7kIkBswQAAQoAHRYhBK5HCVcl5jElzssnkLqXzVK3lkFPBQJqfbYnAAoJELqXzVK3
 lkFPrKsMAJAzfNd9gpRVn5Z31OoG1SWQsmpB08hMmYsLfLwkc/lQvgoZPRcjQTTTRuqSOhCFKdX
 K6x65TcNfs6csSK5kjZhwTQ95EQeEKsV7Rz3y6NAq6eajw568s6sdAzmCHTn3LHR+Fgm7IaUF29
 i5mI9AN93rogslFVW324J3b0wLgV/Lz4GgNRjeoGfuU/iWcAY/aOTHOXpNqsUSM3oeC4iyi2cDw
 xTt8wnM+2TN+REMFCe//9jJOTSSuh7OXLCxKlFVdxk+RQZfz+fDME/93ccuLETuW915qQzjriKu
 5tMlt56XSXUyciuU6ecNHBhlQBU20VvJ0fDpqwbs1Rg7cPXdQ3w+hKTS2ncbVBrhjl2NyeIkP28
 lt/n2BiyVqANSfOTwhkF1C7WsaMeI9xY00Dl5yHbzpPVqLuA/CGnWOAEdDsu/q43Mndga/89Ov7
 vfO2pcxsVB5CBYSWgpqS+av6TDfhJklrItyjulhjUkUcUkqrdYjDcA4i8WGjqf+D3S2XvVSxQ/5
 iQ=
X-Developer-Key: i=joel.granados@kernel.org; a=openpgp;
 fpr=F1F8E46D30F0F6C4A45FF4465895FAAC338C6E77
X-Endpoint-Received: by B4 Relay for joel.granados@kernel.org/default with
 auth_id=239
X-Rspam-User: 
X-Stat-Signature: s9x3ogqif91s3agxjyq96cg6h76nfa8d
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AB2BF40009
X-HE-Tag: 1786623531-602931
X-HE-Meta: U2FsdGVkX19kOF5JFGqsCH5QxTDxoacp/Sh2EYPgdCwxU2fN5wEPyikKgHIs6HCObjJ1JueUkLPjNLl4A5r6yME8vC22IeD3pCqCbmmMXn47BHZVhyQ958RC9zkE4b+GYpyf0IG/9cqOmmwM3IyUv2pi61W2pqiAWbZISeVBbix6LZd4m9E9Tak9xAcROwqinCtr+4mGqEpqUKQ8wAtD3e5hCD2Ks7GBAfd/2pUExpIgGo5wpYtHH0J0MCVjHSc4T+m6Idi3KeejGEFQLSQODlC80uzGEQxzDIlQXuSnaYKrIwJIeMxyNk07D7K4AoF6YWVIj3K7pnRZKi9sWOECBF2I/tDj5yXBkGP78CSvpFjK6m1U4S482OoKxfAiV6t316Kooh377ktkz3J+V05E7bmWpPBDUJM87ctSBUHyH8dUjdkTTXlkZdJfUAHYgVYL57Vs4Fb0S5VEOeHDVkohBSP1FcHsIqfmet69hp1w5uI6P6JecP6bNlKft6ejkmmKRC+lRL6+lsrR3cJxJx1K+fPF87WIm+8FiEYfd+6cRI5k8Sl89NvRjcb2VEHpjU73SaMAf8/hjtJMYGLFDk83h36aIi+6c+OKgyt8Ysw8tqi/z+CJjbMs1Y1YzyKko0dISSBHtmAPKDNViZTfqhl1Qy2yhu24wmMWqK7LbaXKVO7KAczKhMnaGO+xpSBgXJ5xAa6mN7p5Lcebznd6IfPGtum5cpZychst3G+qVSd06rCvPRxi4TaaL8Eoy/aG8p/cU2VAAFd7xP4x3E2zCCooQKY5GZ1CFEG2pA5ZO8xyZ8/CznOoXl+JKRomLHhZOLzskQjRZIxXddsBURC2ulNNprA2Uu+4ZAFMNnREeclNXg2Dy+qfXHaRy8f2jZN+/hDP7a0evPA+gk9R3OA3Jayz+eMwW97jzv+2XMi2KBLb6kpYh34643VXOK+ZmEIVsEVgudxqWRw/wxOmca5WbFj
 F+LKbNmL
 4J2fDxsHnXQUf/+2JVInpIdajFiKINoyvdEVedI/0s5KXJstTElRW+ws1XdMZyolzs1PSv4BHYz1m+zkvenI//uIfNA45DaWgzhMN04+X06Vyt3yprI9UubP2RLLS8Xzmqk5kLkuL/Ys5ASQ1TVTNK6cimcXTDkmAYPz7y8xbg4Ky3EezoONEEs36f4H4uhySCbrza5Zyk9uqxUkG0MRMX0P0kMX2ipadR1/i
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
index c5fa916e626a336c004d596f4c74f829b1cdc5e1..787f53d70507b1583518f86d50d526828462a902 100644
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
@@ -654,22 +674,31 @@ static int apply_conv_on_vec(const union proc_vec_conv conv,
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
 
@@ -694,20 +723,30 @@ static int apply_conv_on_vec(const union proc_vec_conv conv,
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



