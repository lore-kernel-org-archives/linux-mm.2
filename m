Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F40ACCD98C6
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 02:35:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A44226B0005; Wed, 10 Jun 2026 22:35:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1BF36B0088; Wed, 10 Jun 2026 22:35:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9588F6B008C; Wed, 10 Jun 2026 22:35:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8700E6B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 22:35:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0D5F0120399
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 02:35:00 +0000 (UTC)
X-FDA: 84866064360.26.62CF9C0
Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3921B40004
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 02:34:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=LM+6HrSw;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf11.hostedemail.com: domain of chenyichong@uniontech.com designates 54.207.19.206 as permitted sender) smtp.mailfrom=chenyichong@uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781145298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TjRVKXFz/E1UJLwlJUTOT+1jDNXKN5x7G9d87jWpC14=;
	b=hTQcp7Az85fJhNk7Hyf05y+lZGRZ6oGjXO5SkKEo1ymWbmxyDNB+TUOlDrWelLIo+QcNbB
	cuRgu+I7ib9DGaJCyGC49rrwv10bwAu8KCvIVMkX0EdhrREa48a+Y6EacV3Mft45vkJDdg
	h+JMctNeoCQosImZPJFsdzHyErj3Nio=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=LM+6HrSw;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf11.hostedemail.com: domain of chenyichong@uniontech.com designates 54.207.19.206 as permitted sender) smtp.mailfrom=chenyichong@uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781145298;
	b=JT9cyohdUgGy6Q7qrMMMCd4GfcgXaUwWpj1vTlRglDwQR7JXcPoxUGa2Eha1qDQMJO2+2D
	eTPs3Mrr0ko6105D8OBziT59q36LfNlwkAJ37k7nNZZDimFSFheYxGPTBf06NWLS6vQ3DU
	1AhYXvyAIpweHhE+ioiKSnG8tB1PlHk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1781145278;
	bh=TjRVKXFz/E1UJLwlJUTOT+1jDNXKN5x7G9d87jWpC14=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=LM+6HrSw6L7qc8YiJYxOAX2tbj7GyRb+8/s5F2tbEGOH7U1YM5971qEKDnGXt0zsp
	 eVezQDyZVoYq6SrI8s9hcAe7X/2GD/KtZu2ut275MB9msE8iU69gHehxquwu8KSXVA
	 mOOoyLsGrbShL/bDc4n3Mw2gvyv5nXqEFykwJ30U=
X-QQ-mid: zesmtpgz1t1781145263tddd4d4e9
X-QQ-Originating-IP: WCE7ZVVKxu24PB516uGZLbXq8hR4NpgI6uLr2cKzk6o=
Received: from Shurima ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 11 Jun 2026 10:34:15 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 14385813744696445276
EX-QQ-RecipientCnt: 5
From: Yichong Chen <chenyichong@uniontech.com>
To: vishal.moola@gmail.com
Cc: akpm@linux-foundation.org,
	chenyichong@uniontech.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2] tools/mm/page_owner_sort: free per-record allocations
Date: Thu, 11 Jun 2026 10:34:11 +0800
Message-ID: <440C4C1E0D13E6D1+20260611023411.379986-1-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <ailAiIKTNSDHkUl6@fedora>
References: <ailAiIKTNSDHkUl6@fedora>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: NhdiEwnVOUqES4QRWN4On48BN6LhgW3ER6eXD3Nfh32okWjXoHrKmQ/q
	7CoLidVgLku2jG/KPK7KPpYVv0ocYlUZi+P5JuA9s7hZ7X1WmVPFvH67QJH4G8egwTWypGA
	sDzutwr4VKMcZ6DeWUEz2JBHgt47+loxuLmNP02w84QtwuvUCyTjD0z5g0R7iwkyk3w/nrj
	j8B0x4mEvnAZTAm4L2999lw71oB4+jaXRMT6wZsW5DaCnORAgLFGkoh1C7tKfkqG+MK5poK
	uz4X+NL4qATRm1y2hQKu/xqGIvZKJZfby5vWI9ELVAqCGZMPU3DtyC/G8Nkv5esuPONwQ80
	jIE9hKTDtSg0Cd7gXYw2jWwZ01DyeJ8D4sfn80GTKy2l4q/6SQKCbYTDKeqlhexD9Z4JCZE
	/sZ8k1t7jjhOP+BWqjzybjXfYloMkXVLLCkfR9uEWs1lhR+qMMqMXn4QYGSWlxsu1i/5P+1
	9CkO4Gz9E0FNYHQ4r9DNN4O8/No+6/qdGb2siNSUfjxOOj3Y0JiAxVKw0eOQKx3CiMqqXKI
	dKGAvIPVNcmntEVAUGKN3UM6POUKMRpVtjpnD4D91MFezs5S0gGR55Qcfq5pjSbCIZDTgQV
	ZeHSDbN5ZB0X9NidNkvAJPkv0uVYgifgSTXCY2vcz6ko8J9hr8TU+HZfYVQ+A67AgQkj56m
	aPXuMT63qR/9+0D+4/dBZ7nbzFRQgF0bf9M743zinWViHnWsKIu0TI74XgMo4G0zBieslJh
	0gzsSG1kdaiJjxeUwv+xVXjN6XoMYpTaLeIN03lYJoOJEL6nBrYmT39lg7ffNhKvCANSd73
	r8YCsEO/ayE88ns25HznY7DH35dBPmpQMh5onquWU6RRyegxlHfYjI6HIOEbDu9jCULXM+X
	cDZ1nJUTNgIR1lJJnOrRfQ0gWF5O560CnF1b05Gi3mjzFfEaQ+lD5f10n7VWluhuxj32WgT
	fy77gZyRjZxuSxLjTo8knVxpajxFQdppevW/qyQZrz1hc+7ZAIAJIwI2U2ndevPFZoPopP3
	lPZ5BBwVWiMghmdmZE
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: yc3td8ihr5cyiixbjzhxxercoicos99y
X-Rspamd-Queue-Id: 3921B40004
X-HE-Tag: 1781145295-127234
X-HE-Meta: U2FsdGVkX18YseYbf45DKsbj535QFi49oSD2S0khgDyWvTZIkqJHs6Yn2THS7I/Zepc0trnwYGoeQCm9ugl6LiUeLOUbkCG8Eel0XTWc4GCKYDVX8WjvMjVIAncC5LEb8QGHbxsxKgXK924yTOdqWyky1v+6h1/tlw1ILTPlkVEhy+TFHTwjFFVqCbQHtfNOzwKpj6qX6JjUKgsRYd5KEU9x5RgjOEQYgcAcVDEjEiX3Eq2OaNAKYgHIjOaPww8b8HlsbtYMl1RFDiV6E0Ge9bMd0SfgNfpKgax8JnRjk8AkyKzaO8LJpBr8AOGfClsYBNf+k3nX7ObKIH5A2FAjUOOggaTOuH++ylXTvIDKBYxbbNmZr694OpRrXmidED9/3hq2vvRloMMljBWPfdjTWUWMBx3vGh5twDCjErHofrDerLGPP1bJi0jaoS9+uytubNXKDQ+hUPy45fu1QNSDzx1LWKfsyPlqVzX0jRGIc/XpmzsIkgsVTOU9KHOT8eNND4tGVvK+T1UytEcBsVsOATJEEWMaiupDPcSZXpx8luI0Y5ofeyaPStgrHcoUFyFDlPYKKYtPNik6M3/NboEpE4S0IdhWl+8V/Py5LoE4wSkH9BvJZD3fiO92aU5qacliQ7x+0vRe+rzbc4Zd6r8yADdxob7YpA0w2X4OcH5VV1ws0I6G1np5Dj6uuu6fLpjP8CoO0qXSzzzW9ZcVok3icJ/pdVDZHCNiCMNO/iYAxkz0M7a290HMctCA6y3aqrc33XF6L4p3QiIi60c2pQTQTuvmBth303DDPROH2vUzVTG/gR4UN8cBVuUu8T6YeD8XqZ5txXfjs0tB4rRN/dIcEtS+4u22MKwuHipD8uHNtpG1vBwCpTkFYHs8zI8yP4Xoj6r7s//TEYduLC/SuQH38sFnPNMoZV7Q8wtzQD69htAkel5kZzbJUZ8uUfv37ndc8VfEUR+dDQ4KTw9eDqa
 djzbw2l/
 vfxwK/kPsRP8oAVyzfb+7Zll5FoHO/vTXjmzJM5TGZvwO6h9qrTRtejWaUuSKc6tYMd5lbDg3ZMmYtTdNOnjO++8x85NdvrtmXC63yzxFRD6+Sh38FEdxvF6KNSQDewCcvq/8P6dSM03Mv9+042zi0ygaGYna37cpH8X6VeFRHdEK9/X2od8Pvg3FjNh1b++1OstOIyVlxk4fOncZG1Bb1InRLBmxQ/Uh9JTUEri2yd7Ekrbw4gvbHpxPeNlg/Gecit1/NqZxPHYXd+lOl1DSNbSGl+PVfPrZKN+HTQL4Q0w5T19qfbl98FJjH0LTjkbhSBnWRKwR6Id+AStlu1FqNEi1ZXrJu5daLV/nyNt/7ayrCNbw+OHAVeYp8116+O1CG1Cpu60MPo2nqYLlDWJXKuIVbVEuOpfyH8DSmHhxj1hr8IGoTwlGPVzo+Kw5kiW/WwRgOrw7rHwa2NH4xjA74En9/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

add_list() allocates comm and txt for each page owner record, but the
cleanup path only frees the outer list array. This leaks both buffers for
every retained record.

Free discarded records during culling and free the retained records on
exit. Also unwind comm when allocating txt fails.

Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
---
Changes in v2:
- Wrap commit message lines to approximately 75 columns.
- Use "Yichong Chen" as the author name.

 tools/mm/page_owner_sort.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
index e6954909401c..67a7fc6d9de2 100644
--- a/tools/mm/page_owner_sort.c
+++ b/tools/mm/page_owner_sort.c
@@ -372,6 +372,9 @@ static char *get_comm(char *buf)
 {
 	char *comm_str = malloc(TASK_COMM_LEN);
 
+	if (!comm_str)
+		return NULL;
+
 	memset(comm_str, 0, TASK_COMM_LEN);
 
 	search_pattern(&comm_pattern, comm_str, buf);
@@ -386,6 +389,12 @@ static char *get_comm(char *buf)
 	return comm_str;
 }
 
+static void free_block_list(struct block_list *block)
+{
+	free(block->comm);
+	free(block->txt);
+}
+
 static int get_arg_type(const char *arg)
 {
 	if (!strcmp(arg, "pid") || !strcmp(arg, "p"))
@@ -480,9 +489,15 @@ static bool add_list(char *buf, int len, char *ext_buf)
 	list[list_size].pid = get_pid(buf);
 	list[list_size].tgid = get_tgid(buf);
 	list[list_size].comm = get_comm(buf);
+	if (!list[list_size].comm) {
+		fprintf(stderr, "Out of memory\n");
+		return false;
+	}
 	list[list_size].txt = malloc(len+1);
 	if (!list[list_size].txt) {
 		fprintf(stderr, "Out of memory\n");
+		free(list[list_size].comm);
+		list[list_size].comm = NULL;
 		return false;
 	}
 	memcpy(list[list_size].txt, buf, len);
@@ -841,8 +856,10 @@ int main(int argc, char **argv)
 		} else {
 			list[count-1].num += list[i].num;
 			list[count-1].page_num += list[i].page_num;
+			free_block_list(&list[i]);
 		}
 	}
+	list_size = count;
 
 	qsort(list, count, sizeof(list[0]), compare_sort_condition);
 
@@ -876,8 +893,11 @@ int main(int argc, char **argv)
 		free(ext_buf);
 	if (buf)
 		free(buf);
-	if (list)
+	if (list) {
+		for (i = 0; i < list_size; i++)
+			free_block_list(&list[i]);
 		free(list);
+	}
 out_ts:
 	regfree(&ts_nsec_pattern);
 out_comm:
-- 
2.51.0

