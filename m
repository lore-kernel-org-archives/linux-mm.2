Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AA1DC531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 07:47:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A89116B008A; Fri, 24 Jul 2026 03:47:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A60D56B008C; Fri, 24 Jul 2026 03:47:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99DEC6B0092; Fri, 24 Jul 2026 03:47:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7A3D86B008A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 03:47:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 01737C02DA
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 07:47:06 +0000 (UTC)
X-FDA: 85022889294.08.F62AC14
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
	by imf14.hostedemail.com (Postfix) with ESMTP id 96431100002
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 07:47:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=XEp5H2Mh;
	spf=pass (imf14.hostedemail.com: domain of zhaozhengzhuo@uniontech.com designates 54.204.34.129 as permitted sender) smtp.mailfrom=zhaozhengzhuo@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784879223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jvFc24TZ3mLvfxxnDzgAFIY8NxhmAYXL6YmNdDZ73vM=;
	b=WeujxPNWBnOUyXerffpJjg1mMimLN452RM9G349OIZ+xU0C+b4+zyEqmlOQN+JtlQhqBdS
	zoUBLxQylipgof5T8cnNjms1zJdf6A9l9m2o9FfBb8GT/8wXoCnctjxsPlt4OOL+wAEVqN
	9jb0vl1UF3cBdwLEqpX4MggZQZR383Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784879223;
	b=tFuS2z7Frlqu9l7U/0MGCg7Yw8yEN79m6iJSWE2DuoNebiaxL25ieUQc2+W+YSiRYjM9MK
	CRJbw/8+O3hRCxSUNPjdA9eT3DJlP1fpK8NXOwNXEVa+ZbF0GexZxwYCmdHypvCFkzh/GS
	HWKSLZrIyAW74BpJW15rDfOt2+oSCOg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=XEp5H2Mh;
	spf=pass (imf14.hostedemail.com: domain of zhaozhengzhuo@uniontech.com designates 54.204.34.129 as permitted sender) smtp.mailfrom=zhaozhengzhuo@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784879179;
	bh=jvFc24TZ3mLvfxxnDzgAFIY8NxhmAYXL6YmNdDZ73vM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=XEp5H2MhkZuk07bRvEAvbNG0Sf/dpGKtcOIqmA5TZ1aCJzmKkzTfdDcqx1oGYnapT
	 2L++BCLAvhCOg5zyCmziahhV5Im/klPbhnB1VM6IvFoIDZU1Hj4RrI1tMRZnRA78r0
	 tPuFDoAMaupmq76gnYU894YjmvqZYLn4Om4oEp2k=
X-QQ-mid: zesmtpgz4t1784879174ta9d19419
X-QQ-Originating-IP: WUXYcae5nEufZ1rlLXj47kWA3ZOFt65COWJNWGkcdKo=
Received: from zzz-PC ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 24 Jul 2026 15:46:07 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 16488411257486240047
EX-QQ-RecipientCnt: 11
From: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
To: David Hildenbrand <david@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Subject: [PATCH v2] selftests/mm: fix gup_longterm EINVAL error message
Date: Fri, 24 Jul 2026 15:46:03 +0800
Message-ID: <23557F4CB8CF36FF+20260724074603.1479243-1-zhaozhengzhuo@uniontech.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <8A3ADC563A32EF67+20260724065929.1474539-1-zhaozhengzhuo@uniontech.com>
References: <8A3ADC563A32EF67+20260724065929.1474539-1-zhaozhengzhuo@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: OJDPILheKkFdcZV9/gLCRTZNY2yeQ0HO3o0Qy1NPZeW4UQV2lt0Hx39P
	eU34YhmmOoMOLC9HpjhN2q6YsAfJDIOKn1DKWFdV0bBk7g2lugPCywqJVZOyQ7osOMHM5Gx
	sh9SvahUMMwHh6d0tmxdqp9QDlfuwtw5wM76CgoZwdK+pslJUacxV/r0cpUme5Ed6VpSFJx
	/6AYvjJI62OCYkjckPFQr4ukkOIHfV/1hGZjTSequMhnBrj/Bn2aFSFUv/FnFTOgMzslKsj
	T7OfQma1vDWbnvcdJd20uD+d1bzMv84cKoP1sh98/o6IUTYuXkDtslGACeyvQrPQmXmP2gj
	gtAPpRl86BR/ryQUH13NYgsJpLFGB9ARP8NRcCbjTa47TUgWAMoy6JnNvz0E/ch6sce3Xc8
	2IDYM1FtI2boYuMNy5A5Pev9isrPhoqowPUOC/ulfnOawXKofenoCPRBgWoQYetvcKp9nOj
	nwlrIHQLR12qmPY5t6EZIopMw/aBKybEpyJx9qi+grFDgFzgic5djp6dpNCo6NCDEvUrC2m
	W34l6KrAoSBySt3/wzbpYwAzBqPISq1MLJ4GFmXhnOs1NmUepFPFYxT95yLxel6JBAcRdwv
	0q/uOtx+y71QUH1tXzYSQxkNpm1FEZ+Y4L5ATr3SzAB6B+RpEUTqmp5FsqcxqVWqTNzCN+J
	lphhJ8qRdmAdjwwX3gPXk/ejkGSK94ulxx+/tva4SU1gxRtnSWoufcIm6AQ2FXrlc8S06G6
	/Q1kPI6M1z46j3mzaPhuIyc13C+lh1Ux9e+5VpPwPNw2EWAkcGuE1Le4q5sySytfVt8wxF1
	V6MZ9pgEvKd+STv5X5H9EciBFnDNdIugP7U8I0kGWRJ5qssYJ4lkBBxDNNMhdh1lMWeRL5q
	bQqU+mDcSwfciW4c8qFf1z5xObrR69L3Pw0CTO4YVNdihlt9pWLb/vk0v7j8KL3EBa2LuOy
	q9Y8y5YjVNQy1a2pxt2FobaUxTHwIAh4b5WPcLo3A1WxW9rDMuvcUAHEMz4bKXPPnMvGYws
	5MrEyB3nQcceHH7dqfG/OsN9ffsJwfoyzf5UVoapeJsCfYBXhuktuwSaJ26vymNRZO/jpNh
	w7KDcwQ8qa18KoYrN2Wqw8CVU33c6Fpt2lh0dBux4e08S3IjhGejL7H2R2szq0orRKBSNJ3
	FOi2nJuOTMAUgrg=
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 96431100002
X-Stat-Signature: jtf7n87qypgsncogbn9xik3hfjprao4d
X-HE-Tag: 1784879222-947498
X-HE-Meta: U2FsdGVkX1+AS0AjhouT56ua46chRkH2JzAXvNVESmeXJFkP6neicKm+2hhKnuRwO+1vyoCuq4pqj39kmocfLcZ3czw6pKfGxltpteridZOG3Bg0x2rglDnXZIIT+Q/UetS0CMIYPNwO4r+zMYyldw5DKDkL4kRXnS4U+eEeIvKWbqT6nQzErROO3fz4iSkR0KO15nOEtibqZrPWFCIudk5CgD4XAypnu5f1CAp3azQOMuHH3NM70GmEfxDJFP7R3p9zd1wH5+Bf0ImPQwvEELalcCv0tIqk8qRJZO5Ie1NtsDbvB4RKX0+JAMSoBoN+n9pwJaX78n06gQpkS/m4GgigDKKgQh5za7oEtruRSi06Yfoqg7IK6qD8e/HlnupRl3P7SPO4C4CAcWG/R1iaD43LMs/N4XDH5TQFhqjqNYgk46XfUEFH5UuTQUeBIgp9QHvqosivvHYLQHdM+TIjMzeEAkCAp+DPUsIBSBhcouXoGbPn1RCz//1rKJkfqDxUBJYbzRCZrzKvlFuHlQgf0BsikF90IjazFdIdcQlzGhmXf+Ymfmy1pzFry/c09jf23JRT65UpxRDAzxu+RpQoUtEoXSIzItXQsbKbvyewuJZCnRLISP3/p61SIytDWlMptOxnzDBseiDsCNg5KILBR5KEcLjBhEdtWyFbih2yppQdAKghel+OEo7kVhTeXsayAHcUq5RdoH4j76iArIp7P1XxgKiZ2HHYOsgjFuZ7S26KGwFEzZiIky0y1HhGJa8gC7JE3FWbI/9PgA1P9bINWxjvrpch+U+J9M74p1vbeluVSoTyQzzGY84P+ecPMHadQ1l2yObXpsgKZtBGNk56POoCfxBK7V/gK1JTa/+hhlNIdDJf/anIcAz8rYJz+Ma6blqvw0LD8zyuGYlQLcwFomIdYjjc77KxBEu2kgbIC7a82Ml0I7vDs1h1G5U1syfuFFVO5W8elKC5GDe//kF
 efk3b5Pq
 5dhQMyrIPjA206fc+7BlAVPlWOmjF5EXzFt2wq+gIruOiTiiNwtQfPtgKFgW4Q3XnaFakgsnTNe0b5+zX7CVroneBWMmWxQck0MsatvnEAH7/HCQdg+0tk2viPO7k42OokOaH6A9LodUIu59f2RVMDvQ/hpSBMV1iyjLQEeLpITH1RdIbwhOzK2LGWH4EmYpeTuTV90iycHF7gRupquAuxKgDvJHiB6NqZpbYg48iLMPYOh57QDVP8UsXHx0L8DpvFMktgFi8iLBsVSabLUR6PhEA7uMvO7WKRQru9E4SuALq9NDBZakMPScx+ZjPhh0Rhzb5BW2RDjiwjWlKR0GUk6Vd0uMWJh50lnjXH9e+tPHdCAOgQV8Sk1+SCcVa+NryoaWnhl65IhMWBXU2IU4HsmdpdRp4FH64bG9KKWdtJRqFgE7swqcFrqOBreCMWT5QKip2rnBYgsicaYE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The gup_longterm test prints a literal "n" when
PIN_LONGTERM_TEST_START fails with EINVAL because the string is missing the
newline escape sequence.

Print a newline instead.

Fixes: 800ddf3cd74b ("selftests/mm: report errno when things fail in gup_longterm")
Signed-off-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
Changes in v2:
- Add Fixes tag as suggested by Sarthak.
- Add Reviewed-by tag from Sarthak.

 tools/testing/selftests/mm/gup_longterm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/gup_longterm.c b/tools/testing/selftests/mm/gup_longterm.c
index eb8963e9d..c03b4f891 100644
--- a/tools/testing/selftests/mm/gup_longterm.c
+++ b/tools/testing/selftests/mm/gup_longterm.c
@@ -196,7 +196,7 @@ static void do_test(int fd, size_t size, enum test_type type, bool shared)
 		args.flags |= rw ? PIN_LONGTERM_TEST_FLAG_USE_WRITE : 0;
 		ret = ioctl(gup_fd, PIN_LONGTERM_TEST_START, &args);
 		if (ret && errno == EINVAL) {
-			ksft_print_msg("PIN_LONGTERM_TEST_START failed (EINVAL)n");
+			ksft_print_msg("PIN_LONGTERM_TEST_START failed (EINVAL)\n");
 			result = KSFT_SKIP;
 			break;
 		} else if (ret && errno == EFAULT) {

base-commit: c04df384b55dd9dcf72c36b661becb5aaba371a9
-- 
2.51.0


