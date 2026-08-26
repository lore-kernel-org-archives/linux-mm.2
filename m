Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3DC3C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 06:31:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E605D6B0092; Wed, 26 Aug 2026 02:31:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E100F6B0095; Wed, 26 Aug 2026 02:31:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFF936B0096; Wed, 26 Aug 2026 02:31:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ACC8A6B0092
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:31:57 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2486CA3156
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 06:31:57 +0000 (UTC)
X-FDA: 85142450274.02.09F1516
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4EB8D14000C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 06:31:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of liudalin@kylinsec.com.cn designates 54.254.200.128 as permitted sender) smtp.mailfrom=liudalin@kylinsec.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787725915;
	b=PlotZaNJhcyzRgK7IOHLJMXtmQlZzQiifHFAif8YAcy0gHBjdJFDFqLs4Vt9tHMIkr67l3
	QvD5A1fKosUQV1TOdi8VJrbl2qGQC0zM0KQGHkWNSfOXhRM3ox5ZERG/tIyxc8zXfiPmin
	jb0jw6qiioOt6fgJkINjb5IYsvHiRNk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of liudalin@kylinsec.com.cn designates 54.254.200.128 as permitted sender) smtp.mailfrom=liudalin@kylinsec.com.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787725915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=NaMcK1mHk++nTvXqZQgclcZOKcCf/XfU6jkUKr1W8fE=;
	b=dleYpuE6AzsVDq0/bwQ3QbEnaysp/12CupCrZOwrAqw+GKaarKW8AYjhbLlkKkIUK8Yyt7
	SlZ6BPx9ymLE6rDxaGdD+7UFiOhVXcNzlayeBDzKJkQG0TFXgt3ZFSKdIuC9j9Z/RIDNnl
	fAfKCMp1eFbNJUcEzwUHk4YvVbSxly0=
X-QQ-mid: esmtpgz16t1787725891ta63e8adb
X-QQ-Originating-IP: kW0zayIzP3o/qoxTIBQCQN6S1pyzy6x6ZC7xM/dLCAc=
Received: from localhost.localdomain ( [111.8.45.130])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 26 Aug 2026 14:31:28 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 17325394170361992191
EX-QQ-RecipientCnt: 11
From: Liu Dalin <liudalin@kylinsec.com.cn>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Liu Dalin <liudalin@kylinsec.com.cn>,
	Deng Yingchao <dengyingchao@kylinsec.com.cn>,
	Qin Yungao <qinyungao@kylinsec.com.cn>,
	Luo Qiu <luoqiu@kylinsec.com.cn>
Subject: [PATCH] mm/gup: add NULL check for unlocked parameter in fixup_user_fault()
Date: Wed, 26 Aug 2026 14:31:24 +0800
Message-ID: <6D25DBDC7BEC853D+20260826063124.3255387-1-liudalin@kylinsec.com.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:kylinsec.com.cn:qybglogicsvrgz:qybglogicsvrgz6b-0
X-QQ-XMAILINFO: N/5uKQClqYtPM1OK2QllPf1Za3G9snMwPFA+3bm0Rm6LdNibDniZc1NV
	5FR6xe5gs/wtetbp3/uf/MxVQTQteVKy/evXkvBs8Pew0rDbGT4q7HmWgDQwaNG1ZVi4b3P
	wIZt1FP1OcpryZSli0gE2b4dh0wvknBPT34na/9ZXEgeJtaufPNZLV2FgDdE5h5T0t7lqTv
	/6yd7CuWELMi+LWjxniu0+neCxpGvnJH/8/X4M4Lv+BaXNJOKoW4Zhn4jzYRI2CZPxFbXgR
	dWNxr26RH+GzFXM6AtHOrRItgEPFd2wTJl+Qqun9qs2eAR2OYFuIeYgSPQbIEWKUf8Yz4Hr
	vaNKc41P3XfayPxfrskuqFXz1v1lkDSTD3XWcOnXwV3q6vgaVF1I5gwZ+lD6WjBwfwaOJ66
	M0+xEVs0ZqRXeSxZVegisiIkk7a84pPFfUEIBkh9/ifHj3NFWLKwNMjGmnntIxksCsNPs2x
	Xk3Pt6P1oJ6thGOEIwO3pG8rn6M1X2OF8HpGFQNDcnIDY5eSNvTXlndI4poZ08Q8GHpj/DB
	ZR/4e2PwSPry0T2fW5HnziyY1igPHVMLwsGQdf3x9E7Eqi+ggEbCwv8mz+Y27ldwdoYc8xg
	MoYGLzVk09A4KYl7j/G4UJTaGtXKymYl1p7aiMc1CR0IaDqaDxwE6jFzY223IwXbpMm6AdJ
	VD6WYvIgJh5YBwWtMnpwHBgIXpzNKwNJBGODiYyaiHukg0ghL8pM3PWQXvLZ3tl4aHNTDVw
	0wqDoILF6DlSzGtmSMhhMVZKeteCOUenZkmxQB2xPeU5ZEHFlX5wskOJwaddjujvud2nTru
	AWyiuq5jVQuUji05aTfgnHkjlTg1h0DcIERaQG3a5q4IoDFT04AlJs2z+GC1PCgKTUr0ykZ
	8dc/3PyZkrALHKJDQuxQi9n/zzb9LNyARBAHCbcDUrX9tIpnm+k4FyPjMNGz4dZbecfeCqs
	NfrZGBzx8ucXNMplsHhmmFU1uAuiLxg97KZdLqe+xJcYZHSs+qr0W6UDi9bUaGW4VnbA42d
	9kHKoyUCRH+B/x+jzFbvJfiKZWE9iMZLAkROpqNaUGWVB80nBmq33vak8/guLsc49nAL8LO
	2PQRSB23xWhb0CJpVFjW18JrPZczYLq8x+27fXmTUXr6z26YP3zHiA=
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4EB8D14000C
X-Stat-Signature: igy6izqe819ow8897tosjmcdoy9ah53h
X-HE-Tag: 1787725913-924666
X-HE-Meta: U2FsdGVkX1/DPEUMJex6Tp36MmxbnxaL+eudcM5KVBFPCdxSZNAPllvPHaII1EdlljDY8/F2kUxR4yzPLpK8cGLLz2G9lmnyrjokmMBSr16920klATu5bgbFGcaWPi+fTTK6mXjqbdIpiIIVa9u/EiqtB/lNWjw8peUS4fzen/kU0cH2hyVc3fW+exPTzOWJfVtMrThhEE6uWbCDvesUqyG4lZcpZ+89n6ZBXvMhrLkVXh9/lY4oeZu4YEfdchfwbphQ0km0dsWSzJVhEhwng1F10/YGPhuSavx1B4ueBZEm6L32oPM2WkyX5TgP0sc1xBihNxdVVAkbD/L6fFe6Fr+Oy1MwYfR7kES5gIP21LntEasS7fKqQ/y6+jyds60KqYAh3vkN86KZkENzcojM2+LEHBmBQPwKbXXQektH8zEiUdE4gA8ZZw1X1rKpNT/lnVxXDKA7PsiOPcKoJg5dlOPUaaxjrWBsLlh92D+7pibuCLU4nRpsSSg4cOo2oFCuRdUmVVlMPt0Frzip90x4FnkAiL1B2yVqh4v9GPR8M1XsQdx/fVLTUk2mVx6iSDHsHGOXS/EHBBxKEOjEeNo9fUaX4BONMOuk1ed3DAgs+CEolbtFjLn5VwSgtuQCaXBgzO/AAxdY6pTLuRpKfCgkKbbtNqOe1QHJSffxfA57l8CuCUlHZkebM98NYUMuud/kBnqW7IUKK53FVsRwajqBbCWrKPN/dNypjxqVDseN2Bci2qJPrNhw/ouYut6ME0XVxehqh9MQOvVWmpZfvHnRbV/74qHACFdkYAlcmgF4PfL9xxqgXr8zjfZ/w0+pyylLY6d17Ugw3RXdUGcLIUOhcNkvsHnWNiPo99Ro3DC+699pEjy+DEZB300QAiRqKMSmCHWZIyJnK1ua81yNcFqakYmDS+5hKe65gwCefZf1DXRcg3WsrjsyYATWcRt7arkvvLfGLygrM5mGOsNo6CN
 ggBkf2Py
 spalQAuZYGGSFUIpYBECwmqeQAN/bF79az3PQMWx6S3jw/hkFgD9EcSXLPf/WxZ7s57Wg8Z7qrjCNDAiMUtI7XF34MTajiDEzLPTeFRlREJZLQ9B41/kaHvEwMAbhA0pfT0qJQlWK0/tSgfxc5xf5YVsxpuiV/plOvmkd/tmMwcAMN1ChDgOwG4CpzVojQWzYuWrE/uIv+IEHLKByfguaY/H1yX5TcWlOABiEg0hjnZVcD7g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While the current callers either pass a valid pointer or explicitly
pass NULL (indicating they don't need the unlock notification), it is
safer to add a defensive NULL check before dereferencing. This prevents
a kernel crash if any caller passes NULL and handle_mm_fault() returns
VM_FAULT_COMPLETED or VM_FAULT_RETRY.

Fixes smatch warnings:
- mm/gup.c:1597 fixup_user_fault() error: we previously assumed 'unlocked' could be null (see line 1573)

Fixes: 4bbd4c776a63 ("mm: move get_user_pages()-related code to separate file")
Assisted-by: smatch:2.0 [static analysis]
Signed-off-by: Liu Dalin <liudalin@kylinsec.com.cn>
---
 mm/gup.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 0692119b7904..d12475a7f7cc 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1594,7 +1594,8 @@ int fixup_user_fault(struct mm_struct *mm,
 		 * could tell the callers so they do not need to unlock.
 		 */
 		mmap_read_lock(mm);
-		*unlocked = true;
+		if (unlocked)
+			*unlocked = true;
 		return 0;
 	}
 
@@ -1608,7 +1609,8 @@ int fixup_user_fault(struct mm_struct *mm,
 
 	if (ret & VM_FAULT_RETRY) {
 		mmap_read_lock(mm);
-		*unlocked = true;
+		if (unlocked)
+			*unlocked = true;
 		fault_flags |= FAULT_FLAG_TRIED;
 		goto retry;
 	}
-- 
2.43.0


