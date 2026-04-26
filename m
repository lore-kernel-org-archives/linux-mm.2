Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9455AFF885C
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 11:08:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5AE66B0005; Sun, 26 Apr 2026 07:08:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0BFD6B008A; Sun, 26 Apr 2026 07:08:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FACF6B008C; Sun, 26 Apr 2026 07:08:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8BA536B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 07:08:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2A54A1B89CB
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 11:08:33 +0000 (UTC)
X-FDA: 84700433706.08.F0DF122
Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.53])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8D342180006
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 11:08:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=E3nYPyZi;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf16.hostedemail.com: domain of fujunjie1@qq.com designates 43.163.128.53 as permitted sender) smtp.mailfrom=fujunjie1@qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777201711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YJoTltremD7Kya8CfcAZL7++rjFxHo615qsgHJhBL7k=;
	b=Rj4XM5c6cA7S99TFn8VxU5fqSrMiHft9MaHf7U7KS31phJ8YnCscyk/61dxy41+qEFh3BX
	3ODks6r9vvH9kfwSlQqEeXonrgt2EeuVGbTMO/mDCV7GhSXbPLHaOvubPSE0fWcKMQt1Dx
	r4eC7/MklBtaf+uXr9bMdVIEF04K8hs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777201711; a=rsa-sha256;
	cv=none;
	b=yV7ijp4l+A74s98dbcKFHpqxNOxll+2ZXlfE/4uPW3hK+yEszjnjLIKs0wiyr7lgeoUNJF
	NLcxiEafB6x9PMeiEGvvSWFdzsWKRCnJrwIY8T8IQjZjbggk4V+8SIKEQbZq++HgGINGvU
	Az67AlL1ZLwzRd08H7yh3sQF7tsy7nE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=E3nYPyZi;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf16.hostedemail.com: domain of fujunjie1@qq.com designates 43.163.128.53 as permitted sender) smtp.mailfrom=fujunjie1@qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1777201706; bh=YJoTltremD7Kya8CfcAZL7++rjFxHo615qsgHJhBL7k=;
	h=From:To:Cc:Subject:Date;
	b=E3nYPyZi/nF16AESo6Y1spzEVSpeDPC7BouJEU14Xiu79toRnPsKhOy4pRCqm3W57
	 CzQtqXFAhjbjqq4ktFBjMsEMYHcZraCkx4fsl6A+n1xE5PCBtY0b6d49PnFdpH2XJK
	 d/CI3onXaAnXu9FGk355PazR0npU5ukCwqxW4c6Y=
Received: from node68.. ([166.111.236.25])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 21735AF9; Sun, 26 Apr 2026 19:08:23 +0800
X-QQ-mid: xmsmtpt1777201703txxumchuu
Message-ID: <tencent_98F3571EF9236437E5165F5C08CF258A9E08@qq.com>
X-QQ-XMAILINFO: NC4p7XQIBeahjLyMy+mxShhJwheb0epV3omBl741iKBFUbGfcokmwWgbO66a+f
	 HdGjCKikyvlZpq3vJ47kYD7Xt3wEWLpJpE5ekGucYfRx2Mx0tcqEoWBI23wlnf0J7q/1N7M94QkR
	 WvqwRoFi6IuonuXBq1UnT/wf5aZsN2XSzyPbtnvugXKXFh1ddvMh1Lnj5oz5K13rLdnv75AVUgba
	 Yu5sud5JSuIlVfsT9XAsCCzdxmWqwO8sJCKz+ol9PLQvYM9VTyU5Hkzy0nAEQvjoxD+WDkqyDpjx
	 eUPfrmReCPvhvtoj0MBkMQoKoY7ewSY0L1yVzapwz1AW9HP1ZeoeWvSM3DJ1hzfUaJCWKra4/xaD
	 LcifQ1H10kW4yMsmD8dQz5kEH4gYFg0lojl023Qou7ywrEN0uxhA2T5MqpuS5dVbI5bEeZAwb8rS
	 hi/nM9pg4pZs1WVkIAaf1AXqmrxtW0UrM4bBmHZjMFmNsd2Gu6zhZR5MD3YHoDkdFz5xxnnmjiKW
	 0YSPABOoG/9eUV8x47gFw3qqBTITNc9BzGJGZvy2bv51wmTPG1FSxQ5bOKcixTFnlWlPmp5cVO53
	 2KBVfVDg0K/uIddWMKbxTQZ23VNzL/ks8GYX88R9hAj7AeDpX/aKbQQSAnrbiVHqAAW1hLW+Tyq7
	 BuO8K8nL9bwFphh9T2AbwU+dznVXTYnw2vKNa9Np+4fphNS+2CiSw418CGAueIr2/JZqbuhd1whI
	 LMtutB1YZdgC2cdl545YFKzvXMzHoPmn7myG8QrFaKfuxz+QiTYvS5AhNGyZBFXQwFMc8TsNVjHS
	 O89OXMz2ZFnJinPw/fgAEfk/xpsLgpq/ku8Xva+gq6QJJxVJff9Iwu5VhBQbIZEnexMnqP0UVVFm
	 meeqHtmKYEv4eEKhHMKKdqaGtXswShEQtqqQeB2Q06knSj6hJWb9k/pG7AqHMZhSU3fwcpC3Q7mr
	 AGNAB991WdLLTDGUT4quG8Vzs8L3xobL2JmdZqLZK9ojDvvBCR/sUrFGA3TTHOpXuhpEE+R+LD23
	 wht2/PX3/8eMWajK2Khpgp2h/r9BI=
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
From: fujunjie <fujunjie1@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	fujunjie <fujunjie1@qq.com>
Subject: [PATCH] mm/madvise: reject invalid process_madvise() advice for zero-length vectors
Date: Sun, 26 Apr 2026 11:08:22 +0000
X-OQ-MSGID: <20260426110822.2750927-1-fujunjie1@qq.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8D342180006
X-Rspamd-Server: rspam04
X-Stat-Signature: wkyiguw1qq4exe6iowmb96889fh71sex
X-HE-Tag: 1777201710-721049
X-HE-Meta: U2FsdGVkX1+oeBvwcR+aOgT4OXR2Xz83GdNZFWs50WUoTmpJBwR/c89FOVpKgZWO3b4qRUpRlfPvn7fmh/wjAJsn5TeHp47MNbqassQkyBIHHcCS5/5OcGb9hLAfZjVSexTmBtRHs6aQMdPUaRgyMAS6EDGrdiVISfV0vz8ef27LfEh/8xCMHvDY5p0/i264NYxNUI2e6iPszb6qOzFVNDsnqVe4JMcjSmq+MpqjtD7f383zSQbOdlkqhYeV/EfW+qO2zV2dyN5dBwD8nsI4KKWRC3ocMcDGW/am/rRWPSLzRGVs6z4vsGvmicFOWmKwmgup0N1j2ZzAlXyinruDj0OatznIae1inkqSfvEB33orVSdBE50CzVPV4wLqmbvSo7ZghTBGKKnCqzglqHpbYZQYBRwzTRPaxU76TSFUsokyxAYNZP3UxeI/qK3whbNy9sQrJjXEwXPSzWqROnMWp9I07vpOQzPBoHhR7geNhY2/CkkNlqfFjI0E2HiKoUOjHyq8E8QX5fmpeEeiaoIysfTO8cQ2hq8ReHs3s6HuaYLP58TJgokKjpAS3h6oSep7FEzLAeMSAlAI0kzjzoreBOcXKWx9XPHWMrHLdw3RNrsrw7PX+Mgsqee5ivh7Lwroj3mPiWHk/4W6KBHvkL3xSRe6ljUgfn1AE/GY5jf7HziP9+BoE9OSLyecHQm/UQ4tXKW22whXV4tD0aEXO5Pq6KKHi282vA37wDw/+eWIZB1r/2m3QwOcLoJifWyYba+37D0PtDKexQXZuWhXQ3di3GQJSzVopd28FLRn9r21V1gQOdVXsn5pbd7HfMRiRt7cH9XbbtEwbH/B5tyiTRfkDgdjQWkWFtdgVGoDLd3bg209dgNtEoW83IniHqeQ9RlZ2bOP0wDVQq3r+YbOpRiiLwSRNy81fA8tw6C8cb+JLpvXwKz1rZcGa1YsNWwIF7L6QEDEEHZMfEVFcqyTy52
 ZaMXElrS
 mWVwkOvQ/vIiDMVOr37hFDsyj3obnLulv6yzP/XMfEotzTKlFYcg3EAnS3e2060sbTcKb9eS8hPeXudU6iiScWI/141nLCUuYlE2nbzZo09DeC/ttq8zo9NQ6WQKTqxUWWcinHoWMgta9uckpVogoxN++wZmdSiqxV9kDuWqF1WTO32mSnTjDsZsEPCAgKBciGqqdNFiZIN6eZq2K/ULmsYwgmCwbyUsVGTR9BMAposP/upqnRSZp7YIBVTr4KwDEl0dp60USnxQWWCdlokUzOI860lNIX4MDjDzQrLNz2hwLRgxgqmUhJB9UTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

process_madvise() validates the advice while walking the imported iovec.
If the iovec has zero total length, vector_madvise() never enters the
loop and returns 0 without checking whether the advice value is valid.

For a local mm, such as process_madvise(PIDFD_SELF, ...), the remote-only
process_madvise_remote_valid() check is skipped.  As a result, an invalid
advice can be reported as success when the vector has zero total length.
This differs from madvise(), which rejects an invalid advice before
returning success for a zero-length range.

Reject invalid advice before walking the vector.  Valid zero-length
requests remain no-ops and continue to return 0.

Add a selftest that covers invalid advice with a zero-length iovec and an
empty vector, while also checking that a valid zero-length request still
succeeds.

Fixes: 021781b01275 ("mm/madvise: unrestrict process_madvise() for current process")
Signed-off-by: fujunjie <fujunjie1@qq.com>
---
Testing:
- Built bzImage.
- Built tools/testing/selftests/mm/process_madv.
- Ran tools/testing/selftests/mm/process_madv in QEMU:
  # PASSED: 7 / 7 tests passed.

 mm/madvise.c                              |  3 +++
 tools/testing/selftests/mm/process_madv.c | 29 +++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index 69708e953cf56..83fe9e651a907 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -2046,6 +2046,9 @@ static ssize_t vector_madvise(struct mm_struct *mm, struct iov_iter *iter,
 
 	total_len = iov_iter_count(iter);
 
+	if (!madvise_behavior_valid(behavior))
+		return -EINVAL;
+
 	ret = madvise_lock(&madv_behavior);
 	if (ret)
 		return ret;
diff --git a/tools/testing/selftests/mm/process_madv.c b/tools/testing/selftests/mm/process_madv.c
index cd4610baf5d7d..9a7e2788fcc50 100644
--- a/tools/testing/selftests/mm/process_madv.c
+++ b/tools/testing/selftests/mm/process_madv.c
@@ -309,6 +309,35 @@ TEST_F(process_madvise, invalid_vlen)
 	ASSERT_EQ(munmap(map, pagesize), 0);
 }
 
+/*
+ * Test that invalid advice is rejected even when the iovec has zero total
+ * length. A zero-length advice is a no-op for valid advice, but invalid
+ * advice should still fail with EINVAL.
+ */
+TEST_F(process_madvise, invalid_advice_zero_length)
+{
+	struct iovec vec = {
+		.iov_base = NULL,
+		.iov_len = 0,
+	};
+	int pidfd = self->pidfd;
+	ssize_t ret;
+
+	errno = 0;
+	ret = sys_process_madvise(pidfd, &vec, 1, -1, 0);
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, EINVAL);
+
+	errno = 0;
+	ret = sys_process_madvise(pidfd, &vec, 1, MADV_DONTNEED, 0);
+	ASSERT_EQ(ret, 0);
+
+	errno = 0;
+	ret = sys_process_madvise(pidfd, NULL, 0, -1, 0);
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, EINVAL);
+}
+
 /*
  * Test process_madvise() with an invalid flag value. Currently, only a flag
  * value of 0 is supported. This test is reserved for the future, e.g., if

base-commit: 1b55f8358e35a67bf3969339ea7b86988af92f66
-- 
2.34.1


