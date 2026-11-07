Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A55F606A32E
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 20:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G/Jxmopc
Received: by kanga.kvack.org (Postfix)
	id 885E66B05B7; Sat,  7 Nov 2026 15:10:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85D446B05B8; Sat,  7 Nov 2026 15:10:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74CCD6B05B9; Sat,  7 Nov 2026 15:10:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2E8D26B05B8
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 15:10:16 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A5A5EC0385
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 20:10:15 +0000 (UTC)
X-FDA: 85409414790.07.7BCFFE1
Received: from relay.hostedemail.com (unirelay04 [10.200.18.67])
	by imf31.hostedemail.com (Postfix) with ESMTP id A851820009
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 20:10:13 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794082213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1FTxpkWekBlYDp/UoERMc8KBJg6cu9CB4RQQpW9Xqac=;
	b=yBzrbQeqOeHPYqtNLl4sqRFMMPlpep+fh1cMZz6apYAl9+LUaE4DOTNb4OLvQ0BCTb0PKq
	JUwPWsJpnEomWpd3/qaH2QdM4dVz4L/D0vs0bmURS1d8NSgTK2XR5DQpTGc5UdlP1GG330
	scfBk8Ag8qcKJWVxIbaAoU32sfVMjaA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794082213;
	b=6vBFjy1FLjSqazcF2+wkvL8TbkHf++BYhJrkyJarHPtupsLgbCzz5fkzxoZi3prAidwzpq
	JnEHQ2Cm35/8ISO7KyOa1kqLTsmF4dvhGLLuc639RKgJUVuTsShyRaBrFk4VAlQj+CyRHE
	J/0KiSpV7Fbq1qQ0Ca/2ZD7TTqVFgs0=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 566591A0404
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 20:10:13 +0000 (UTC)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 264F6A7FB5
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 20:10:13 +0000 (UTC)
X-FDA: 85409414706.02.B17A284
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8362540009
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 20:10:11 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794082211;
	b=cZj5eXb702H0dJbALvB8g9NAbrydxUt4pqLP8NiEcjx5UxDjPXEvfGtCYCPE6UEK87mXGD
	966FXJeoYdRDXZzrkxiH4IrmXi9C3tca4Me2vlrtKO+Jzw9ibrIr8wKddS9N+BGcswEzfy
	WBfT8ehEJgzX6W1klo+GPduh0nurWgE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="G/Jxmopc";
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794082211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1FTxpkWekBlYDp/UoERMc8KBJg6cu9CB4RQQpW9Xqac=;
	b=0KxIRu1JCW0fGls7tohy6rk6T1LaCBDR6FHwkFXsw4tqCs1W8lOriWd27Qry32IM+jeOrl
	D/VQBgmH55aI11MDVUNuCklKFel9GFtGZ7dhuYfhXusF72NjZH2rYn18ALuM1KCqOBrx0X
	sCjlRNs3AAERuGDBmS+YPcAUvdWpGAs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DC51A431CC;
	Sat,  7 Nov 2026 20:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C27D1F008A1;
	Sat,  7 Nov 2026 20:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794082210;
	bh=1FTxpkWekBlYDp/UoERMc8KBJg6cu9CB4RQQpW9Xqac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G/JxmopcOvg0rAmmnZebR2qYHC5gTkH3JI07UamM8CjbLw04fADnRq11h1rY4xY6Q
	 BNMigWOw48azYVCplHgJjv4y4MmMLuWkSlJ7iiBQrPlCboUd+Qpf9J6cABkggGXPth
	 ih10HLkwsfv/KljYgYI+HJm/+V0b06QRaoKm52Su4l6g4S8mTYBo6AA1vniPFozkXV
	 /CcbQr8OazMRCOmvVK5b1GxJiOswamMEjhBBMQt1aW5IndlzWV+ZgMOgqfTJhZzgZ8
	 qNhp6OzBwyk/fabJNMtb/Tq2eFxKbUvsUQmsNcWxwx2CsEy12gVC7xsrynS9t6Kxbg
	 tRe4Mlyf1Us4w==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6.18.y 3/5] mm/damon/sysfs-schemes: read sysfs_filter->sz_range only once
Date: Sat,  7 Nov 2026 12:09:59 -0800
Message-ID: <20261107201001.206120-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261107201001.206120-1-sj@kernel.org>
References: <20261107201001.206120-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HE-Meta: U2FsdGVkX1+yZi6BVk4uije/IXG9/sR0iGy3jCpIrxrZKfwHbCLQm0bVgV6+1BkazTyS5zbdphmMzdWbmr2NUnXl7lTH2MeCCQRXDRCdRXDUabTI0P1XqO8kPp3pnwKCMJQysKlSiyfnwSHfXsXzhpenqSCxrUWihAcIfJ7/pzu3bzBZQrrep2Vceap4hoPa5yWM65BHznEgVKuJPatibNmT5fs8YEC8JLo/Y6kR2zpeVAQJISyjiFCJrEkP1gMJ6RYAp8sYF2kik1B7Yt0l7ZICnretcQF9ksvqZu3tmqRhk22rS8eN/dqov88LGMkiAlMG5j3/3kCT2wO++MZdqe4uMYGhmZqVEwtDbFRWYigNcgK5+3QIIuij206CFFYe1LnthGVPfzZt5yd1C0ChgXWS9c/NTOBLPi46jCmrSLnjfTE9s6p9Q83YUvZkLqwdASUeie5JMXwYBTcsS82Qbvo8iz/Vk53wNkqmFiU76ckhshAwmaD4hh+QAViQyWJlYFNFuRtXqUu2NjO8LN2SLQZEC8iiu7gLzGoe59a1Eudsql3XkSuVXaG4p/kuL1glJM1Fa9gYeX3tXB3XUJ4HmJyX7cb22VuDI1/l6Pm4QipBG7nSMBrkGuJmI5SUyW1dqKbWiYrPnDeqxiYYC2vfj12SmKGY86ftaqkZF+1C38gk2/jBB/lR7uzLLczCPN7Xb46sI9UhXK8nE8y/SkrMDDRL8Siku25kzL4ewgbbmjKDRSQ1iDRKkW6JXbA6+Jt6MOvDK+ZTQ4AAjFhgigYbPc1IR/cRN9+TAOXmZywVF1vMsKvqtQIVXBXRrnncQ55Ny55mx9DuRN75syZn39lOYlCoP46X24ERqsbs9g63SlMN4JaZ0+YxYBYdXA3zcBBt3Ss0xLJqslTu9klKEG90IoJOCvAMjjsAurKiuy4oNnTPZ5HVnPxLdLZwFyrtqIpkd8QIuquzQVHw4EEFUxF
 KSXFuGmM
 ob3Ij2FHEqg31fDYHJ+JLozdChgJqjwrPrp2w2NHiEeCly4LBBPRgiAwUvtw5n0C+BuuRe9PhZLtne9pJEe1iBqqqSoNJxr7tcFi4kz/jumQ/oLiRkwspDHm7sr71eG+d7WrvyuL5vesV6qPF+8rC7rPi66bO2f5ReYeFJ1woBPAIpnR+evN2XutVAPpv0UTdsJ7vr89XCvxxkR/T7JncM1UUDYNKwXjndlSPoqB1W+W64Kx36k/haF4H6b/0d5D3+0zqhTznrwLhSIhtAyYzw+1cTCOzp/m5/ufOl5F0TawlsppltrOGa/1BIKTRmTQm26VeqhCU/smCDssZstzup00G+Z9NvRbgSWoqgP/BSC+MAe532UDqxJaEZOe4I5WcFDYQyUTmbw6yyJHdfRp9DSEvPoil+KTCmxnlatvJSNQdk3E=
X-Rspamd-Server: rspam06
X-Stat-Signature: 4i8383nt4bwtuc1zh1oit7ze6dr4tg9i
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag-Orig: 1794082211-623444
X-Rspamd-Queue-Id: A851820009
X-Rspam-User: 
X-HE-Tag: 1794082213-888901
X-HE-Meta: U2FsdGVkX1/d3l1Ecgfb7u9/HYG+PyEoDC3Ept+WAGUxwCQBqxLWsYB3ukUepV/HdHSIn0YKFmD6Ey1ig1CnU51mI5/ZQGU59kwOHpGnBhxUEbuq9t11lPHi/3o1OPG+tysMR8BG9sXn5T1l3rJQ5PRugh3E/OZElRE9pNo08P2yppYhVeXZs6BADKDB3Q2d1U+saRUSyJ4UQSWMO/uJhjMmZnTjvfz7SiSEsfVst6Q9/OjmQhSxb4MOmJ+CPdthcsSZI/VCsinPhirsp4Nqgs8NXbx5zTovK+HK1+vI5OK/9dPY8ruWpYyyc2EjRvSRL4Y6zaUda8g7fA9h4Di214lO+8FT311TIFJy5aQh37cwFClYeMRF5Ahcmk4bXkO2nK43hk4083F0Yo7m9ehMA6BEWYGOIBX/vSyoXRPW5cqJPss8PUPfWfpAK8M7//qXun+HX2PkFMefC6WfcJSJ/eTypYJ5h9l6iTNEAU/fhm5LDR+AYXM9RpFvVi/UEcQVmXRkY4HqXgKj0rX2MnPlEk1Ty/FN6DUAhMnGpEntI1pJvzuD79QuzrmER4faPnsdZyzzh6nTGm/XCAaeZjJemRuxO6MyMOXfWX4CFhxyMSjPxoOomMz5xP1tKr9AUngNBpayPousx5lfltDf/z74qCpyqXH97SfSHOjguzmSYIEd2ng7teLNVexcje+6fYbzr44XskYbLJl259tNGDMcVKTKhO7ocfrkNa8LQUIE//JVf7h4ZzFlXMP0C6tQCJXEN9R5HH897F/2S3jpf4+IdSE1HkWZsw81Jlb4jjnx3aFujLF9dCqDhNzdSkrkpRV0Ipjsl2Ud7GvATTVeWMlBqZ54UiNdOU1qR0oyE6aMYWuBp7yhKQULs225O/6SWn8y92/QLpabLi4EWwqBlmg2hKDUifCPxNPt8ix8EKiqOnz3raYbBVtwnC3ihJrah8WvaOeg6B0BuTeiYFT7F9Q
 KVQ+IjKi
 Xv5DORzizUyI/LLDznxWPXoKwq8L1KwxOrxrJGGK7i6aSqUochYZZGUMZzAY6z1UF6UpotWtVz6FOboqOmSkPE1oX9ZKAx3SvCw2jJelxSEcnh009OzW5IqfMjApkePWFTZXbjrg4zSJR3MDHdS2sCK3YK9XSB31hyBGq4zh/dak0Q2+q6BO6WsmJomlg+5jmPhccN2UrUpsfUYXULMNO/qODbjfaPE/44x/OcuXATXxxYB06cnRbgWhIQ9ppWxNt8Udzzg4JFhTxi6yKZ15NbMG/UYFp3GyuMWttYBC60BATql72rnS7EfHQwaHA+1DgaHYrAVQxiib1Xd/V2OFJFAg+Sl2pK6hbNTVUpmiDB3TRfGkvgvb5QlB6mRd0uK88NwjHsycAItSvXGJ00/8iHI2rwyBWkCZ57EG33qSqMy34oQRprlhS2hcBT0T8Bnu4F4U67T+9ZLe/sM8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DAMON sysfs interface reads the user-provided size range arguments for
hugepage_size type DAMOS filter twice.  Once for validation, and once
again for assignments to the variable that will be passed to the core
layer.  If the user updates the arguments in parallel, an invalid size
range could be passed to the core layer.  Avoid it by doing the
assignments first, and then validating the assigned variables before
passing those to the core layer.

User impact of the bug should be trivial.  From the core layer's
perspective, the invalid size range is not really invalid.  It just works
as having a weird size range.  No critical issues such as a crash or a
leak could happen.  And sane users ain't do such parallel arguments update
anyway.  If they do, such racy behavior is arguably somewhat expected and
deserved.  That said, there is no reason to keep such races.

Link: https://lore.kernel.org/20260914142327.92510-3-sj@kernel.org
Fixes: ea1f204ba29a ("mm/damon/sysfs-schemes: add files for setting damos_filter->sz_range")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org>
(cherry picked from commit af19aff38d6faea35b10f26cca32d0e54f8aea5e)
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 37e0a8bef4b1f..0f945ef043709 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2493,12 +2493,11 @@ static int damon_sysfs_add_scheme_filters(struct damos *scheme,
 		} else if (filter->type == DAMOS_FILTER_TYPE_TARGET) {
 			filter->target_idx = sysfs_filter->target_idx;
 		} else if (filter->type == DAMOS_FILTER_TYPE_HUGEPAGE_SIZE) {
-			if (sysfs_filter->sz_range.min >
-					sysfs_filter->sz_range.max) {
+			filter->sz_range = sysfs_filter->sz_range;
+			if (filter->sz_range.min > filter->sz_range.max) {
 				damos_destroy_filter(filter);
 				return -EINVAL;
 			}
-			filter->sz_range = sysfs_filter->sz_range;
 		}
 
 		damos_add_filter(scheme, filter);
-- 
2.47.3


