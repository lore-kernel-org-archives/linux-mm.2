Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BF6FE95A69
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 09:48:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C68626B0005; Tue, 30 Dec 2025 04:48:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C16716B0089; Tue, 30 Dec 2025 04:48:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B212F6B008A; Tue, 30 Dec 2025 04:48:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9FAAD6B0005
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 04:48:57 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2EACD141685
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 09:48:57 +0000 (UTC)
X-FDA: 84275663514.10.0CFDCAE
Received: from outbound.ms.icloud.com (p-west3-cluster4-host4-snip4-1.eps.apple.com [57.103.74.162])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0A60880003
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 09:48:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bne-home.net header.s=sig1 header.b=IYwuKCvJ;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of bshephar@bne-home.net designates 57.103.74.162 as permitted sender) smtp.mailfrom=bshephar@bne-home.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767088135; a=rsa-sha256;
	cv=none;
	b=fKJRQYFT+Fhz0F4gyzxz9HJGuSVnDXmVu6/Zqor+O9aK1Gn5k74ZpOXVU6S3XuH5C5gyPh
	94bNgaWEFD1BstHq3faoikAeh3mEhuqBrbnMLDXSlc9hgy59d3QoFWFV19rGzFX57VEXXu
	2Xh271Yta571lH1XX25rRBaOwEARaH0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bne-home.net header.s=sig1 header.b=IYwuKCvJ;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of bshephar@bne-home.net designates 57.103.74.162 as permitted sender) smtp.mailfrom=bshephar@bne-home.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767088135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WAfqurt205UYSsUGKAjfPC2uLje6kUlWJNEl16+9wTc=;
	b=1PULbTiNuToAgKrIhmqM/3Z07PsphQdxfQHSXd7uPlmZij43G6KcwOv02D1b2h865wCMm2
	3tZgQjvJreeKVoyobQA/023mjEH26JMhF5Jhr8ZylvuPLwbXwJFPHWmAOoMDdQXAve/A4K
	EQHxZCCK3wCaedjH/+Tlqi0gDxXIVw0=
Received: from outbound.ms.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-3a-10-percent-0 (Postfix) with ESMTPS id 7750B1800100;
	Tue, 30 Dec 2025 09:48:52 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bne-home.net; s=sig1; bh=WAfqurt205UYSsUGKAjfPC2uLje6kUlWJNEl16+9wTc=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=IYwuKCvJPyt3JmjSQMlIg7r2weXGdKOAX/L/WlHDJZmw+2UENFntDIiCvBzsaVCTYr/PntlizFSYsi+S2TuwGydGJNFD24LzugXJeR81GAqu/ncRSqo9mm2rmVhY95O1KQX2CqmBKe5JYGXKLMqyrCaqlp1Ya7h2MLjt22D6eBIABe4eEm+03jgNqHP89AqllaJ3zTLyjjfJUeGHBbcChrt81l9h8WqnzU/G0u2mMSrxd5j97VbxBxsUxIIPPzIEsIHbdXP9xN79Cz6UigrFAS4sK5xxJgSe5As8rtbtD8CxmzM/Zm000DZxEYO5scQSCBjTa9X0897R+hnw0fao4Q==
mail-alias-created-date: 1746336505199
Received: from fedora-g16.bne-home.net (unknown [17.57.154.37])
	by p00-icloudmta-asmtp-us-west-3a-10-percent-0 (Postfix) with ESMTPSA id 42E13180011B;
	Tue, 30 Dec 2025 09:48:48 +0000 (UTC)
From: bshephar@bne-home.net
To: aliceryhl@google.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ojeda@kernel.org,
	boqun.feng@gmail.com,
	gary@garyguo.net,
	bjorn3_gh@protonmail.com,
	lossin@kernel.org,
	a.hindborg@kernel.org,
	tmgross@umich.edu,
	dakr@kernel.org
Cc: linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Brendan Shephard <bshephar@bne-home.net>
Subject: [PATCH] rust: Test page_align usize::MAX boundary edges
Date: Tue, 30 Dec 2025 19:48:41 +1000
Message-ID: <20251230094841.76830-1-bshephar@bne-home.net>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjMwMDA4OCBTYWx0ZWRfX7dVSLQn+9RZQ
 30zkexKtcWsMBWMzg69DaeLoGRcZwnDBIRSXwZErNQIMTJ3LJEV2mOmdDW0TziL0WvX4vdTR/yn
 XGSAZqp/FKhqLe6h6427f2FtvzAF578pbZ47ytqMrgoGkVajdm8MhvFKU+rnFDK2PiEn2BqHuK+
 WQgAvZ/K1+7aMJV6w6Ci9gHHvDecZI8qigTaA108FUhdJeW3vTGU5IyzaxsRguuixwKruhNpf+l
 1ruku0OmS+CrtnIOhRP7iSh3Bo+kZ69hEmmfRLMt6RVyz5ibb1fmj/TyKe8bfzKQyO0kaslcPpd
 OcvEDMLX8UmZXcEQdq3
X-Proofpoint-GUID: Gf5ONyvWc2ShQi0c-_67pPfwp-V5Evjb
X-Authority-Info: v=2.4 cv=a8A9NESF c=1 sm=1 tr=0 ts=6953a005 cx=c_apl:c_pps
 a=qkKslKyYc0ctBTeLUVfTFg==:117 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JppZAXPjAAAA:8 a=W2ZBZt_SNlrk6TKUfwYA:9 a=mTXuAFqUwmiQvsSFmwXH:22
X-Proofpoint-ORIG-GUID: Gf5ONyvWc2ShQi0c-_67pPfwp-V5Evjb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-29_07,2025-12-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0 clxscore=1030
 mlxlogscore=842 adultscore=0 spamscore=0 classifier=spam authscore=0 adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2512300088
X-JNJ: AAAAAAABKJKhbGoIelncA6EOSHZHcUcxh2qqXKGgbJay4xmp8vxSDf7sFd40wI1VU1lCSy3jdlENrGiQhUDUti9/JbtjagR7zJihMbTX6ynj36XjijVgzAZXKG+bLA9tMvadJkRWovtkXrWhLNYtSl0JrytwfxVh0afrUuqhoc/w2wj8pAF3I4RkkguUHn0Sc4bM3G1jGyHQNNryA8HwhLNC7xtL2p2BLAbRypLnSBlfRKZOkxvvqVEe/3016CAze0YeRbTbhHcR81zmBCU0JzaCpmDAAyE/Kk29EVFoodTyrxxbWOCtMJkXPT1bCXcSVoEwAQdGLfd1LVuwTDstQ8434aoaax9jWHIw7qXx8GyuVrrZ7do4wdDTe32xMjl1VuIBW28sdM+2mHbF/1r0sV42W9VvG/z4iv1Ckcf2rDH5YyCJt0dD+QfOgu4nhgWlDaZ75I+z68yF5NBRjLUipzXSwmsqzNB+iToTaA/REEKNYCxMURLrM19FLhzkmSWdIDQasfK6m+w5xqfjnXHJ9ELrnFH0fxdYhy4AE8kd9/nBik2mDPRaAwY6twe8zp39ktzQkk9FOLW6O7HFEvmj35LHcSrC3yVGwB/YrMNcnOon/KYCBNWSfEJlMyRJ/B1//2RMRrAueBTHGRfBrOZhxbrHinYsWKRYu8NaNuH9O4fqqM06Rc+iNEbcqVBD9Ges3kyhn5etfagn+dvXLRo6FMFqpTKNzLuh0yPwT4gqAtVZmq/lpxQmWKCYsc4rcKZMrMYUJsg4SWDKl37P0agVtpaOqAqtvGLZ8mQ=
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A60880003
X-Rspamd-Server: rspam10
X-Stat-Signature: xddpxb83zu4ywgnz3788nxkupcsx1etc
X-HE-Tag: 1767088134-141441
X-HE-Meta: U2FsdGVkX18Q7LLjI45ZkQFJloWlKA9RoT9yUYK6BLGethFbyW5zkvq3thUIqUIeCYfgFs4OL28feZ5VDfXblh8BO6CFb7xwUo6Cqva3e2ENtKnFcdR0CIMp/bhJfrtBjs4LuSAoNKvNMg3YqGZrl4VQgI4baqKY8n7ApWGt1kTHxOoK+z++T3gKXn4cIzrm9IApkkfot8pebXmVTtj2H4qe9y12SxAD+u85GxuBLNF7aKkPviMRdgsIDTpft7U5Aub7R9gm9c3X6+exEczEpxbMZiZ+IlRO18uLnHz+pc5Tx2A3zkAsNcBWfyfq/0+BqSJcZfDOx2oOJHM0pJgnWg1QzoGIpHMfce/gKpDT7fLRz5MxHRyD8y5xGtaR8bItwcA8L+d8JYxIGzrcs9rg9cGXqK7CgHjz5RELA/eF8V0eHhNfep9UPTyOCOUjWk51ISPCsWoXDlM7dkHdMlPTqy4hhCYiutYLvuGeckCPc/TPg22RNrjSqRN1v3UVmvczKCukG/MdCwmQ9e8MEw0nw1qHuShsmLkRZ8rGsqLeXNLTwVlHQfNiDCjT6fPoU0mvyMmObkpRBLQnwutNxhF0sGczfnSDyMsTrW/ifZSvPET12N0Rnlqdq+dqFVxY6TGd48m0FWPaDSm6SKLZ8tlchxGf6WxfJ+wurVQs3M6g/yaV67mMMsatC8VYdI+lhhqm+aNgpHPHyMJob5lGFkDYD44BcKe6tTHHFF9uX9uZi5GkGgmXm/YDzCTO3ST/pBs0z0FvbtgKcNjIU45/G5GhxRrOJ5br3mUSQUI1ybKUTrRnTaN3tkWtXX4XJ5+PtMp4DlvgoJvebO/175yYsVO6OzFscnJFfkRMRp02NSoIMd384UjD7xxTCrW587krzYEmtjVq6zktc0qzyvFZfE/n5AlxiVfg7QhE/Fk72nZIkcsh5cPFFa+/P3AXLdKdLatwu4UQLQfzTlDRkoLBjC7
 tn4GWSvf
 xx7lzxpwbtnNoLncG887SsLOGLsCHerOrVn5lVwsti2gNHtyAjk7VdYAOxjcSGlcGWx0Z/oowFvKBGA17AYyJOa870xji7PK1SnXgJSuKZXCYJgyHkGcTTC2/LNb6ul+hhlPyyOxq/x7ofeKqgaYDEJNPvsGHBpE4g+1XPDo6+Kw5gMMbSHZup5ZyqCJxILG5PCRG1NLAOGghyUqia7viJToI9vJ8V+12+BlB4BFSmyAyJtKF5GahTM338kRTWRdl2fkVtIBs5QfcKHxml51vqkErzoPp3CymMa084Ib3Y250RbOf0q3nKs6QFIQrgXbWkZji
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Brendan Shephard <bshephar@bne-home.net>

Update `page_align` doc tests to test `usize::MAX` boundaries
rather than arbitrary middle of `PAGE_SIZE`.

This patch is a follow-up of:
"[PATCH v8] rust: Return Option from page_align and ensure no usize overflow"

Signed-off-by: Brendan Shephard <bshephar@bne-home.net>
---
 rust/kernel/page.rs | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index adecb200c654..d602d4231f56 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -45,9 +45,10 @@
 /// assert_eq!(page_align(0x1), Some(PAGE_SIZE));
 /// assert_eq!(page_align(PAGE_SIZE + 1), Some(2 * PAGE_SIZE));
 ///
-/// // Requested address causes overflow (returns `None`).
-/// let overflow_addr = usize::MAX - (PAGE_SIZE / 2);
-/// assert_eq!(page_align(overflow_addr), None);
+/// // Testing boundary conditions at the end of the address space.
+/// assert_eq!(page_align(usize::MAX - PAGE_SIZE + 1), Some(usize::MAX - PAGE_SIZE + 1));
+/// assert_eq!(page_align(usize::MAX - PAGE_SIZE + 2), None);
+/// assert_eq!(page_align(usize::MAX), None);
 /// ```
 #[inline(always)]
 pub const fn page_align(addr: usize) -> Option<usize> {

base-commit: 7acc70476f14661149774ab88d3fe23d83ba4249
-- 
2.52.0


