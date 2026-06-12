Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B67E6CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 05:50:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9DF26B009B; Fri, 12 Jun 2026 01:50:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4F416B009D; Fri, 12 Jun 2026 01:50:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A64826B00A0; Fri, 12 Jun 2026 01:50:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 991E16B009B
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:50:56 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C633EA037D
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 05:50:55 +0000 (UTC)
X-FDA: 84870186870.28.FC75832
Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	by imf28.hostedemail.com (Postfix) with ESMTP id 835D3C0002
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 05:50:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=iNl0Typ7;
	spf=pass (imf28.hostedemail.com: domain of chenyichong@uniontech.com designates 54.207.19.206 as permitted sender) smtp.mailfrom=chenyichong@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781243453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UXsDAguAyBgeg3+F4QvJ8USj9F0HBLvBTFNZsh/PP0k=;
	b=rkzlIOKKuqDQK0JhOPCsolDDj/iPxMxxh37R02Af/vRq0NDyyl1p4WVT2Bl1X0ya9xbImx
	oUU6m+UQzx1G40Txa1ojaJzdPs2hN2pOfnEb1jGiQJDU1UXTkW+c/KQm7NhMAcmamNoKrt
	nCANFcv3WA/wz6b9K0shGxOKZsiTYGE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781243453;
	b=j9LQQFA/Rs+0XvNKjrry0RSk7TceaNIJ5XMy2bTwVnjrPMXsIMT2PYN/S/dFvuPxMmdkj5
	/zVVh7+yrcQKFN61w+51UX6yOu8in1yBIhr1CJMy7hvmPde9OYRQ6TY+uxzl09V3BmZr8v
	ISIAkFxbDLY4LHZ0L69EdrW1ZeNKVPw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=iNl0Typ7;
	spf=pass (imf28.hostedemail.com: domain of chenyichong@uniontech.com designates 54.207.19.206 as permitted sender) smtp.mailfrom=chenyichong@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1781243436;
	bh=UXsDAguAyBgeg3+F4QvJ8USj9F0HBLvBTFNZsh/PP0k=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=iNl0Typ7LhI1PZKVYeMmiJJi25HdKjmIVbfh/oCLt4foItgh9YIpdDShed2R2fx9L
	 EfWSozOLh/p2FUKjfRjeJq6MvBMbQT4Jig+S6AYE+5iCu+RqfSyeHIdJsh6Szh9dGB
	 4KSiKLOSmcxVPMZWgggJnGW+7gDzPUJSS7G82iCA=
X-QQ-mid: zesmtpgz8t1781243421tac6764af
X-QQ-Originating-IP: FApgVDL1b1jWqlq8N4ADiOegDmeSMLv93XAxv6OoqqA=
Received: from Shurima ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 12 Jun 2026 13:50:19 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 9411472435998616496
EX-QQ-RecipientCnt: 5
From: Yichong Chen <chenyichong@uniontech.com>
To: vishal.moola@gmail.com
Cc: akpm@linux-foundation.org,
	chenyichong@uniontech.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3] tools/mm/page_owner_sort: free per-record allocations
Date: Fri, 12 Jun 2026 13:50:17 +0800
Message-ID: <610C3A89A09303F8+20260612055017.632263-1-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MwQdfXoP8nuz5tnB7GNZQmaGclwCxYPJzWaEza+Rc9zFLegehe0bsHo7
	WsyJULohh4e3lpkgPUpsPcU5Z3VGGIHz60dRJJs4FVhckMwWK+YgdTRGeDTdcoXTHk5tEGW
	QIc5ONqxoChacuK4N7OHyLm/RByLHViNdRTSW3buzswUGaYMvAK7Uq2/HJ0sQaEMvd7MY1r
	rmg5YIoUnThpQsVATvejW3Tp/LFlpiPz7C/uFjyQJB/9yOChzVi34/5kaGC+nHYGYd2ifuG
	EMY3v8AzovjQOnSe1dwvRdvsHf7YrYaqqcX5AzM+ddbMUspJJYNgt1DrSXgsSb+5cYVbgLe
	3t0ojJuqR+1uFgYC10wIW1eT7WG0TExycgWWRmh6fn4qBp33PyADvydxMtHfASOoz/9CEG+
	sIY8Fl8YyJDk5e8LGNP+TqyxEUeWLX4MYApiH0IMPgwjGZs1OtEejjXO42lEx5S1oaJ7Tnw
	0P7Jx+1R6eRTw3RD2R+81P9YRcxuxft5kyHDCRD18VUTjrLj15g6zh7nhYxg6SwyhbknIK+
	hNcMnjWpmUZStd0oImZfcXqUnSafSaEvJUPX0DHdBmCyzGkavXdGO1aUSDjvLmPkrC4/sjr
	ZJ4qTPvG0xOc9F49DlymenQfMYV4A7HKF0nsmXvOoW8mookJpkQgGQb2WByrUaKL86ECuNr
	73hn4GYiZllchJoND2936B97TihI/zLXmTE3vdx8jMDor6D1JvwPEl4o6UTcDaHdMiEBW/R
	7jl/GOYRzsHZfVj/cJ3eyxiFgcGc83C3FyOCLPDisiJrpT/Wv2WFIjhTh3HKOijQBgQqMAg
	l0iTZFU/6NILgafTIKl63b7w7S6Vl631uZ/TCtNFZQ7LO0jQIhvdxnFNAK15tBErj2aRxvq
	J+Rgyy9gO2adDZfon/VvDBKuAJqQeciFD0pAHwswbuK0pqNMhpVMhbd7qg0SOiPtsbaVsVk
	QY8MdFSk5Eb5Vj4h1gTSWbM3a9lh9cvbSpqw3W7aLkYzqwFCrnY7ydSPm5EhePY9k++Brqx
	8s00TBV39XY7bFg/6Q
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
X-QQ-RECHKSPAM: 0
X-Rspamd-Queue-Id: 835D3C0002
X-Rspam-User: 
X-Stat-Signature: a76u6a1snnp75opde4itacss5rqk5zj1
X-Rspamd-Server: rspam08
X-HE-Tag: 1781243449-798687
X-HE-Meta: U2FsdGVkX1/VbjQEX0JTSraDTjH8L+BvMrOwTpc/RgjkaXt6+Z9tT0Mnq3esCLhAYZq0SBLlKXWlG2ZgcZM3a4FdBfmQfb4r77mAp4ESTSAM0Nc7B9xdxY4+cGstZVJTTx4YYsfe2KhO+6wDVaKTaTKPciBn8HAAmSA/B5jk+jSocKsK1uRn1Vjf2crmrWCv4dRpXJj6870lnWXkTkLPv2PWFCDvXfDsznj9XCel9sbl5NM1FZb6CIXu3+qF0J8Xt1LZ8RDDQEda4lTnY702MeetCoxTJT2h21KIChO0VBv9g36INQnwajUmEvJuGhkfKCgbLSlQRWTmUItOkryK+vT3k3Ny8fcVHGo1/gXyk9qvNLJ7bIrOB6KwgZ+cQU2vz+FqtQEYBPyXi50IF5bF2QfLLIFMysG0AzHce4KTLMHbQgm2HTXKiyzTa2tfcTFpkz6Yl3BL6MkwXbh9xORE2U8nSMA3/aa4n3WxLKvKeI2VpDT2gawpJtvhOOHvNa2/uX7bHd3tSS8uhGcq6QtuRYqUepf4E65ly5CVTFHrDh8atc6hWbmZxfNSCjEAu8dytO5Q0hoSbq8xTiPlEQZCQWPvXXRgbIa4WEaP84SsKNnJWQ4JuYZXc9yuIz0GmYxujfLEfvSgJFlk6ZckJPVIDi5QDUW7LylA6z1+qxhn0dYXQ0a6z30wAjrEu32Kdmtnl3om6P+L+7PxOGrbCMo53X83WwwoC3KWzQyGpLGydMSDKYmM6iuw+FMu7JhRJfTd+jElztFknZUGkVVp3957OUP7TKidsH8QHL6AszR0p6m/DHpEnl9KtVaTPEd2YhTh/rVxQA/NIb1HQax8A9GwNAacJwMIdk0lccpBnQkB6gfGcsfMKLy5wA2YVITqBmhCK55fHbeeO87+TdA3Y9FyTn7/2Zi+l+gcndJykr4OVHs2S5gBYq8cvgrBjUUNkPebMwE8b4phEsWGZUqtxqa
 X8wFP/7V
 /SSCfg7/1CZ5XoAhOQbRCE3n5yl+4SpdI2E4bg5E1A9FeqO+vbE4UB/DWxIEiEkwJywXfJikXSFrjTIXUiTPXrW5dGRSnCpdyQd2jeqQIsyPpuhojpPT24/xuhNyKNbgCCOWfzHCvbGA1xLaiIV8VOJoUAkyjvdUSuDpLtgTvFT2wB7uQcF2798EOkJBCL/ZpyCfPFX4CWccCKzpoLPAgg6yqeixhncIgk6r2UQ8MmUx6cgzwdjuJG1lPX44Fewbf9Ty702BexUmj3wKwWEUqkSUsQYUKk9GR/VhH6SjNzHIpr64RcetdLTAj0b/V994YHsPjObCJemqCeealRE1Bj5BkSCC7M+IKFj15Occ9cADGwJBaqzIaIIZMZoifolBSeK+F6gX1G/eTOJ5k05lS67AIWCiy14RnbdMsoiTEotHUhVk69JE6fJAssP67uRcjheo3a5SR4enWVcWsQvbj1d4Ogg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

add_list() allocates comm and txt for each page owner record, but the
cleanup path only frees the outer list array. This leaks both buffers for
every retained record.

Free partial allocations in add_list(), discarded records during
culling, and retained records on exit. Return explicit error, skip, and
match results from filter_record() to handle get_comm() failures.

Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
---
Changes in v3:
- Keep the free in add_list(), since incomplete records are not included in
  list_size and cannot be reached by the common cleanup path.
- Return explicit error, skip, and match results from filter_record() to
  handle a NULL return from get_comm().

Changes in v2:
- Wrap commit message lines to approximately 75 columns.
- Use "Yichong Chen" as the author name.

 tools/mm/page_owner_sort.c | 61 +++++++++++++++++++++++++++++++-------
 1 file changed, 50 insertions(+), 11 deletions(-)

diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
index e6954909401c..cdf31985287c 100644
--- a/tools/mm/page_owner_sort.c
+++ b/tools/mm/page_owner_sort.c
@@ -43,6 +43,13 @@ enum FILTER_BIT {
 	FILTER_TGID = 1<<2,
 	FILTER_COMM = 1<<3
 };
+
+enum FILTER_RESULT {
+	FILTER_ERROR,
+	FILTER_SKIP,
+	FILTER_MATCH
+};
+
 enum CULL_BIT {
 	CULL_PID = 1<<1,
 	CULL_TGID = 1<<2,
@@ -372,6 +379,9 @@ static char *get_comm(char *buf)
 {
 	char *comm_str = malloc(TASK_COMM_LEN);
 
+	if (!comm_str)
+		return NULL;
+
 	memset(comm_str, 0, TASK_COMM_LEN);
 
 	search_pattern(&comm_pattern, comm_str, buf);
@@ -386,6 +396,12 @@ static char *get_comm(char *buf)
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
@@ -450,39 +466,57 @@ static bool match_str_list(const char *str, char **list, int list_size)
 	return false;
 }
 
-static bool is_need(char *buf)
+static enum FILTER_RESULT filter_record(char *buf)
 {
+	char *comm;
+
 	if ((filter & FILTER_PID) && !match_num_list(get_pid(buf), fc.pids, fc.pids_size))
-		return false;
+		return FILTER_SKIP;
 	if ((filter & FILTER_TGID) &&
 		!match_num_list(get_tgid(buf), fc.tgids, fc.tgids_size))
-		return false;
+		return FILTER_SKIP;
+	if (!(filter & FILTER_COMM))
+		return FILTER_MATCH;
 
-	char *comm = get_comm(buf);
+	comm = get_comm(buf);
+	if (!comm)
+		return FILTER_ERROR;
 
-	if ((filter & FILTER_COMM) &&
-	!match_str_list(comm, fc.comms, fc.comms_size)) {
+	if (!match_str_list(comm, fc.comms, fc.comms_size)) {
 		free(comm);
-		return false;
+		return FILTER_SKIP;
 	}
 	free(comm);
-	return true;
+	return FILTER_MATCH;
 }
 
 static bool add_list(char *buf, int len, char *ext_buf)
 {
+	enum FILTER_RESULT filter_result;
+
 	if (list_size == max_size) {
 		fprintf(stderr, "max_size too small??\n");
 		return false;
 	}
-	if (!is_need(buf))
+	filter_result = filter_record(buf);
+	if (filter_result == FILTER_ERROR) {
+		fprintf(stderr, "Out of memory\n");
+		return false;
+	}
+	if (filter_result == FILTER_SKIP)
 		return true;
+
 	list[list_size].pid = get_pid(buf);
 	list[list_size].tgid = get_tgid(buf);
 	list[list_size].comm = get_comm(buf);
-	list[list_size].txt = malloc(len+1);
+	if (!list[list_size].comm) {
+		fprintf(stderr, "Out of memory\n");
+		return false;
+	}
+	list[list_size].txt = malloc(len + 1);
 	if (!list[list_size].txt) {
 		fprintf(stderr, "Out of memory\n");
+		free(list[list_size].comm);
 		return false;
 	}
 	memcpy(list[list_size].txt, buf, len);
@@ -841,8 +875,10 @@ int main(int argc, char **argv)
 		} else {
 			list[count-1].num += list[i].num;
 			list[count-1].page_num += list[i].page_num;
+			free_block_list(&list[i]);
 		}
 	}
+	list_size = count;
 
 	qsort(list, count, sizeof(list[0]), compare_sort_condition);
 
@@ -876,8 +912,11 @@ int main(int argc, char **argv)
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

