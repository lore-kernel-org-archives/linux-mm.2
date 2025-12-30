Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF1B4E95A6C
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 11:41:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3619C6B0005; Tue, 30 Dec 2025 06:41:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31EB56B0089; Tue, 30 Dec 2025 06:41:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 255D76B0092; Tue, 30 Dec 2025 06:41:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 10E816B0005
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 06:41:30 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A27FD1A8BC9
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 11:41:29 +0000 (UTC)
X-FDA: 84275947098.16.3ABFFE0
Received: from outbound.mr.icloud.com (p-west2-cluster6-host4-snip4-2.eps.apple.com [57.103.70.15])
	by imf21.hostedemail.com (Postfix) with ESMTP id E89991C0003
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 11:41:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bne-home.net header.s=sig1 header.b=jaZyhkgm;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of bshephar@bne-home.net designates 57.103.70.15 as permitted sender) smtp.mailfrom=bshephar@bne-home.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767094888; a=rsa-sha256;
	cv=none;
	b=2s5gOsz6pc8hapQqG3WE8Vso77IuJXm+galizxAtoVdHTrc63HGqWfdodScb9vLH2DBsI/
	ISIsAFxFmzyMGmET+dY2CncCRE0BaE+n4p/u/jAOKrJa1gZ8xzWJbU47XXpt/MudGAlGCZ
	NKOjArm/rCmwMN3nm/fCwCOFvP1wG7E=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bne-home.net header.s=sig1 header.b=jaZyhkgm;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of bshephar@bne-home.net designates 57.103.70.15 as permitted sender) smtp.mailfrom=bshephar@bne-home.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767094888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ggYLBMvaykf4rMZdqtcloQRFZz5xZPrUJndHsUSseU0=;
	b=yAlYs8VlwSTnHVrgf9qlSZX8DVY3XkD05G/DtSg1iCjh4FKW60u/SsjQsJ/aC0JJ2HWkHq
	+gvtmAYokOOMXkqpfbYnQqok4NN7zCKkOOlpB442z657Okb8fpca5tQIzBNMtQMSxDdeaT
	vxkO6LXeS4Ov/H++BLGbb+S+k/FsUNQ=
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-60-percent-8 (Postfix) with ESMTPS id 1622918001DB;
	Tue, 30 Dec 2025 11:41:23 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bne-home.net; s=sig1; bh=ggYLBMvaykf4rMZdqtcloQRFZz5xZPrUJndHsUSseU0=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=jaZyhkgmbPY0rkEcB+J3fnaE/68FjNM6TwQxhmPIWSCRlbgsnkQqraFSQX4qNGu2v3XpxfowonTQvKb3TpmRRXoJkms0jmL9RdcCiooc1zd2TXa1KA1cp6hgavN3ZTgf7uqr5f528eZ49m4yyVOc0OQM3M13ewACR2z/1d0PdWs0fni8JEa8c92iDe0Y6Y5zEIwEFOjQ32/JCd+zQ2LpCF8JFdJoMdwJC3Mh41POjVE/59jSC8B4CyhGFvswj0bQg2CV9dY8gR9T5k/X+povQOm8UfY2lvxNNLWWVf7XyaK+Xamah8RWxwWV05ZfLs7gk7wLTJfSAXX0zufdCIZLag==
mail-alias-created-date: 1746336505199
Received: from fedora-g16.bne-home.net (unknown [17.57.152.38])
	by p00-icloudmta-asmtp-us-west-2a-60-percent-8 (Postfix) with ESMTPSA id D25D2180032E;
	Tue, 30 Dec 2025 11:41:18 +0000 (UTC)
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
Subject: [PATCH v2] rust: Test page_align usize::MAX boundary edges
Date: Tue, 30 Dec 2025 21:35:50 +1000
Message-ID: <20251230113550.82666-1-bshephar@bne-home.net>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: carxnywWYml8JtP_bfebN58g1FgHtMvd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjMwMDEwNSBTYWx0ZWRfX8M7cBbS5dK2P
 gJu8b2V3TqPP+ktUMmg1gwzZE80Av7a/qyNoK4dDqyGGie3n/sIlpSIBuRc/HU0AE6uGVMfhrU+
 s853APhVDHnLVEQIgfgoKB4HODKqv1Wgj4T/c0bwT4iZi9CmMnxgE32GrRngvML9lZ4eXTsDQ7n
 h6K1GBww9HBsc/gwAexk8LKTIg6eXijRT3to/CV++QXqsGIUWzqPxbisqiurhQWnS3y5Bu79eK/
 vtOar+d2KWM3TV9Ni0ujFrHDTu5vibsyhdNdgWNqbyaR+JeIFXUoOtePzp6WlRZEMS+OpA0Uyxw
 HCMLYMlhacuawRf/uJ5
X-Authority-Info: v=2.4 cv=DJ+CIiNb c=1 sm=1 tr=0 ts=6953ba65 cx=c_apl:c_pps
 a=9OgfyREA4BUYbbCgc0Y0oA==:117 a=9OgfyREA4BUYbbCgc0Y0oA==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=JppZAXPjAAAA:8 a=b_JMli5UIlt5Tm9dsTYA:9 a=mTXuAFqUwmiQvsSFmwXH:22
X-Proofpoint-GUID: carxnywWYml8JtP_bfebN58g1FgHtMvd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-29_07,2025-12-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxlogscore=942 phishscore=0 spamscore=0 suspectscore=0 clxscore=1030
 bulkscore=0 adultscore=0 mlxscore=0 classifier=spam authscore=0 adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2512300105
X-JNJ: AAAAAAAB16aefhdp9z/pkituRZI4nAfgWhi3MOouJuVIdITiC4iSSb14pKOKsU7JVkNdt2jFdPMClFVciE8dXljuGNANzrh0H3qYYo7Sz3SXhyxBaEdqn06GAmhlfljLrZyf64ImjQGHPrB5aTCoy7rSHKAVXGaZrt+0dWQlAdHpODfq+WUV05UZ5QYDsX7gy1QX6ebczLqqQ97+KRY77FXpzG3YsrVC8V76V5wy91MWcLHo/fI88lmwsGjab6FrnMvBJD5fuHjcW3tBXUMBFwdjSGkznHdkRz9dti9tOFhqgtAr3XX2H7aCzHtmPy3SpBgR2XjJTtefZ6gOA/qxP/67II0qg/PrQA+61N1xIyydH7C1pWAB88IqMvFMoAnv8nu4NcIhB+GkFBMuIWAdO+YIBWQOZz+uu0+aqI6zamUw0wM06/82MbRq8yAUm+YV9QUHEPYdBvRTcISgV3y52BiwXQ6bVIpvoVs6Z+/Icjc9vzzkO6BYVMHxkc6t8TN5H3jlOXP4ZS+3gv0Svd+h2meJtuN3+z7fa6F4yOXIr9ImGhanCqurBuqqBS+DC860qT0B+X4u2txsUuEf8tSEAyH+8YEOxp29Oj6iW0CFzO/faMj8UswfjtBP6keDSBbQ+Bb4eEcsSbsLRAxG4LgxcmqQQOdxkEJeFlaT7SJkaeSGEZEKGB0/qdy5eetrc4DTcs5UncI2YA53d6bej3TGq/HRJ1DRSU7fI4iqMzM7ab5TTjdps/uBMBxtDG6YWZXNfieH4jePC31cQy/mekfoq8lBuew5np01VGLjPxDHeFbKgnwtmSDS
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E89991C0003
X-Stat-Signature: b3qiqx98kguuenm8khodx9tjg7rqu5h5
X-Rspam-User: 
X-HE-Tag: 1767094887-160928
X-HE-Meta: U2FsdGVkX1+LJn4uC9aQQiL0e0XI630vL3gEVIrcmMoKPnr1+lIQJ2eJOuL2egOrcSbix3VuPny1MlW8ldwOjuDxNOSfK/KWzSmRArYOHbySbCTroXyXfJ/xqIr1Y76fX6v3bVUx97O4ORU4THQLcwBkGzyOpvlvZ/Y1CLnukdQEYbCej8wDw/18ZYnxQCyukUVmOq6JduADsIffw+PwYjxK8bxo5y7SHn9rTTQeKUR2/sG0oqA5zbfIfTTd5HwGW5UjU4g5bjTwUjnjW5e4couL/dTNhRqNzoArXY9kskmgzPXFjFwq2myoyQAqsKFYiDJfdD+TfioYf52DDYWXUyapEomc8Ktn8huEUprtCiK8JDUoAEetvOX/5kY+AeqrwCNDLfXAGpD/eY7GkwBw4RYEr6GEcDGRXHZP4S8ut3yQwCmFXVGVWcP50I2YP9esRxzaDOYqmDJccPEdYRk+h0kA0Aw8RwKR921j3vtcg9xFBVtBgDOWN4S4w9lqVYOj4CK9ZR+9znB65fqhlAMR6mrNpY5hA8njKP2xM68xau3QgWGqpfBduZGo50wGG+iXcmbC7pEEGDrvhqjBCZ7s6R6/EMUYbUrDpWAeiPRgpfR/nW7/8K0zKbDTTGXn6VoaufVltOvAOUEAo8uvhtHXkf2fYoKiYdlDnaRc5GEy7UdWJzn+5nQrPqJ2W+n7StZQXCcLYYb/eY1IJoqOauAIElMMlQWIHUj/YRHRBeev9MFg7YG/pSMurygypU/y7AEi2cwuzP9/nS1B2W036WLz+o5qb42OuN/A71JlAB0cKLavar3Ls557K9gngXUD2beRdSPIx15jqv4F1mJNTERmEd8lVW8NV5G0AxBBeQKZ2GJg2jQ+3g59u7nfINcwTYJkWyEZ93W7jDLYLIc06HwlLcaq47Xq8Blbe/nO6mBO4c5LbtbVoSBRQaPAAPw6vpXVPEgopH020fIMEeTka+S
 2d3hooyh
 6jc/qemr1k5FuzpRglD0fw9dKx8yof2+IpqaH6NJzz4GhoX2KmVLcJWumfsGHGxyq5r4kb6S5lAo1dShmLuW3/gHvjeyErVZhLRtimMLVKR+TLfDC7Ujne7WXY+MB/HBdrfeh7b0ty1c90OQ=
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

Signed-off-by: Brendan Shephard <bshephar@bne-home.net>
---
This change is a follow-up to:
https://lore.kernel.org/rust-for-linux/CANiq72mLPvB_6Ow3bW5-V4-km=RyA59chQ1g1x9qUt2P-zZweg@mail.gmail.com/

Changes in v2:
- Change test comment back to explicitly mentioning overflow condition
- Updated commit message to remove follow-up comment.

 rust/kernel/page.rs | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index adecb200c654..c8dafdd843d7 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -45,9 +45,10 @@
 /// assert_eq!(page_align(0x1), Some(PAGE_SIZE));
 /// assert_eq!(page_align(PAGE_SIZE + 1), Some(2 * PAGE_SIZE));
 ///
-/// // Requested address causes overflow (returns `None`).
-/// let overflow_addr = usize::MAX - (PAGE_SIZE / 2);
-/// assert_eq!(page_align(overflow_addr), None);
+/// // Requested address causes overflow.
+/// assert_eq!(page_align(usize::MAX - PAGE_SIZE + 1), Some(usize::MAX - PAGE_SIZE + 1));
+/// assert_eq!(page_align(usize::MAX - PAGE_SIZE + 2), None);
+/// assert_eq!(page_align(usize::MAX), None);
 /// ```
 #[inline(always)]
 pub const fn page_align(addr: usize) -> Option<usize> {

base-commit: 7acc70476f14661149774ab88d3fe23d83ba4249
-- 
2.52.0


