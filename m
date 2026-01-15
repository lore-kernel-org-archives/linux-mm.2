Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 747E1D44C56
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 14:46:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB83F6B00A2; Thu, 15 Jan 2026 09:46:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D35496B00A3; Thu, 15 Jan 2026 09:46:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3A526B00A4; Thu, 15 Jan 2026 09:46:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B7DA36B00A2
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:46:35 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8935C8B673
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:46:35 +0000 (UTC)
X-FDA: 84334474350.09.EF935FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6D183180009
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:46:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TH5fO+yM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768488393; a=rsa-sha256;
	cv=none;
	b=Bev2JaYYauMX7Cp0aVRuDM3plNb3wILHXqGJ4Pz4Sug0tKrARXJoYH8zZbJiCWTA0l16xR
	AZQelG0wi/XJhHdT92jFtfjmj0cPpE/LmhFl6OzIcE522nW8E8XJGPrwefI5vD6JMg8ltX
	tChA2t9zy38ZF0HoDxRsVzg7x5taXkc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TH5fO+yM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768488393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I0nNJxNzYL7C3daqIGejplAJeu65vrYqe9uQOQHOPSM=;
	b=TvsH5NfRF8rtTDr/K6HWg7WpAGhBwyIK/n3mf1wMOkwSLRFMAfIeMljmLddrNUsB3Qjtuh
	mhpZxa4waKOklmmczJIMeJxhlAwYCwr5Is/DXewFS8GujhN2vqMw/UuNXvfH6FN1dn/7AE
	7xnF75ukAwJmIJ+iT5llaq50ChPcAZw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A26DC4431D;
	Thu, 15 Jan 2026 14:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0FEC19423;
	Thu, 15 Jan 2026 14:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768488392;
	bh=G+MNU7DgEj1sJhXfeeHNFOyPFz1DCwEooo5Fb5WVje8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TH5fO+yMgEA1svpjFaAUNdTpySr4fbVFPv4QdN9JW4Hma8kixvp9X0lmWEzRNEq4g
	 fDJ62es05oxfLpQhp768VtI2TC3YmYwTGu7VAkQNIZX7/A43BOEztoOo8ujeq1mQjW
	 o/2CtwIjdhWd+D7/nX2tqdDdRFiIE5wBUEIzlglOaYvdIJE2owBH6fh/hUDW0Fh1Bp
	 iNt0bJccXiuc8LgvfMKrlwdYqo3wz9qmyJZWblR+i/iJxooCdQIrsg8L3w6lFQpFzv
	 ngpzqt//A+Cuir5WGkyXl+erJyfM9KoBIGx8En1EXeG5vhpbcONuouL2gO9OV4x61e
	 1psnlI+DBdcjw==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 444DDF40068;
	Thu, 15 Jan 2026 09:46:31 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Thu, 15 Jan 2026 09:46:31 -0500
X-ME-Sender: <xms:x_1oaQc5oJ3yrvSwQ5Dgypr2fFPiKj_4jm070IJqYWx2E2TeSaRafQ>
    <xme:x_1oaRfKntkF78ewqIb-rEh9dfCvNBe5aIWsGBtubKRg4idX_gXBTO2pPqyoa8Qja
    HxW5hwYAgpcgD-HMVvHxFlBsQnTkWDMhgpiPb8AHCtmWt0GCU1RllI>
X-ME-Received: <xmr:x_1oaUWqv6sj78ckfbCDJBr4z5y8xa7G3WXZdNqdNanhALz-xCOJdbVl8Y_Itg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduvdeifeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdev
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvddtpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    epmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegurghvihgu
    sehkvghrnhgvlhdrohhrghdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurd
    horhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrg
    guohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:x_1oaddUA56X3fs-iuQRJ1QnKtc-gNo7MnYZuq0AeLhTeB-KMcbPgQ>
    <xmx:x_1oaQ-SJCFqGgAxUsEEniqK-vv4BWuutPD8QclqqXHLq7BGIhLsLQ>
    <xmx:x_1oaUn5onvvHh1EVAeytEY1cOTOhF8HJq0yx1RJ94td0SGQMzIYMQ>
    <xmx:x_1oaRihuzb0f7mvxtBuX0-0piyImqEYrHolA0y3iLzWqEf-MpVQRQ>
    <xmx:x_1oaUYRMoaJFFd8vcTnzEKkITJRwaYwxEbT3J_B7s1x8Y9VVYuHiJaH>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 15 Jan 2026 09:46:30 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv3 14/15] mm: Remove the branch from compound_head()
Date: Thu, 15 Jan 2026 14:46:00 +0000
Message-ID: <20260115144604.822702-15-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260115144604.822702-1-kas@kernel.org>
References: <20260115144604.822702-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6D183180009
X-Rspamd-Server: rspam06
X-Stat-Signature: q4f6r38buh5o6qd1ucthdyj8mu1q68yh
X-Rspam-User: 
X-HE-Tag: 1768488393-855828
X-HE-Meta: U2FsdGVkX1/HsSsMGc2NfkGPx3D4Nn9TkStK9UPfKGZkFDTsBsToRmK7Apq72Azkrm0xhzBCg4PAUH7M61SGUooDqAdM7f30nW5ceOAzMhgeXAl+HMRweRDYCfklH6Hdcor1Ocjjb/n0zQJmE57wG36vPTql1qBcdxwoazp+J+Zjv9lPbTU7fxpVnpwd2K5s7TlGO/l5tHTTn7b9SKt/8UNb9IWQ5nWP6XmvcdI69hGoRTJqf/jJAWVzr94qK0HYYv930ZX6ojGisqDwRQUtlngdqBvk34kUYPUDq0mKTnndl8sYZmfb2kTrQDhGwcs594hcnzOyQCFdYxE4cYJftrWTEpFrkg/qEzEa50HjOd/GZIQytYQiPsPWkHOQCvLD+21wAqH3TuUyEdTeeE3T2jax4Z6RmS/v+K93yeuj1oB/ZeIQI1BHE7Quouy6UOPrRMko7JK33saM+Usu51us4hCO6SOrnl/aumCoyh3c5ntKdIbTH6JH+61HpOEgqaVWzulfMYjtf7KNt1JqPUYJO5UyPIAkys5SDWoVzflGb0E5XwaWNLTqg9ic0/18JafA5WNHa7zQWLsdo/x/UPGfcuQllRSVl4y4uJeFSi1/5etBVcx4Pl946Th47guLwC8e8i/KRD6sOLsVWmWkG82smrqfBtd6kJ5H7lEPXEE8xiICfFNBG2MhqPEBHr3MgTGUkPN4SUC8kYfQZxmQ+LaacyUXFTx1aaXvkOR+mHR9nukIc+E4ivP/QtnodzN/dEJOR+/WGzw/5ZleL8QL+kKRBIuo6BgyMIzYovGopPD4DYlL6ombDo4s/Fq2FxKW4gspA4ZcYAJh/ZUbb8NOGR+KAoH5ZKp6/0iNX+Gwa8tsxM78Do8HgutPU7MYp6I2CTkelX3dIYqrh7JlG6WIvWDv+8zoMIjfbQTTieojTAfKsSKEuDF4YrgBkQaJw7gFMhbLi1VtDGLzKzKVyQi87k7
 25rtwTWs
 JPVcas226a7J8YZrmsD7astMqkR0L3ovsC7tD9eiapQPMjmqNlHNqHAUuTwHU+gJrQ57Zr0TNy3zBcfQsBHScEeqrPiqSggcKaDbBVebcrvp2sWnpV6OM3rakpo/MQND/gQVvpWfsgKkP2EoaSEMeH0snNWmpIg19AJtyBmmlAAGr9IGmL7UHr+dK+TuQ3Yh1dzJW3ZJX6XGB6FQlvgMbqZOeE3Rb0JS1erzX2edzplfhJQVaF8TmUMeSPymZCd08jG30YI1tWhT0r2j1NHyyTZE0NdJ72yYSc7gi3I7MDi7oYtM60IrpQ70Aew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The compound_head() function is a hot path. For example, the zap path
calls it for every leaf page table entry.

Rewrite the helper function in a branchless manner to eliminate the risk
of CPU branch misprediction.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
---
 include/linux/page-flags.h | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index f89702e101e8..95ac963b78af 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -224,25 +224,32 @@ static __always_inline bool compound_info_has_mask(void)
 static __always_inline unsigned long _compound_head(const struct page *page)
 {
 	unsigned long info = READ_ONCE(page->compound_info);
+	unsigned long mask;
+
+	if (!compound_info_has_mask()) {
+		/* Bit 0 encodes PageTail() */
+		if (info & 1)
+			return info - 1;
 
-	/* Bit 0 encodes PageTail() */
-	if (!(info & 1))
 		return (unsigned long)page;
-
-	/*
-	 * If compound_info_has_mask() is false, the rest of compound_info is
-	 * the pointer to the head page.
-	 */
-	if (!compound_info_has_mask())
-		return info - 1;
+	}
 
 	/*
 	 * If compoun_info_has_mask() is true the rest of the info encodes
 	 * the mask that converts the address of the tail page to the head page.
 	 *
 	 * No need to clear bit 0 in the mask as 'page' always has it clear.
+	 *
+	 * Let's do it in a branchless manner.
 	 */
-	return (unsigned long)page & info;
+
+	/* Non-tail: -1UL, Tail: 0 */
+	mask = (info & 1) - 1;
+
+	/* Non-tail: -1UL, Tail: info */
+	mask |= info;
+
+	return (unsigned long)page & mask;
 }
 
 #define compound_head(page)	((typeof(page))_compound_head(page))
-- 
2.51.2


