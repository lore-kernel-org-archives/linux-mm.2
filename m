Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6B51E7DEF5
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 15:57:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56C986B0101; Mon,  2 Feb 2026 10:57:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5367F6B0103; Mon,  2 Feb 2026 10:57:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44C8D6B0104; Mon,  2 Feb 2026 10:57:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 346A76B0101
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:57:53 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E36A5888FB
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:57:52 +0000 (UTC)
X-FDA: 84399972384.22.4814000
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id F1D53100016
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:57:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EvtcO+aQ;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770047871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uHj6gPr9FuZw9B6a2IED+z8/irWY7PHg2qHFE+wJL+k=;
	b=zEhVfQiMkGV1xnP5UFOSMl04kBJbXLy/mYOd2wGGa3Y9QevgN5scKSHcVdUWgrgEP1FZlz
	4IaU7gFMZjgWf/3N40m3zahg6rBq0wFOb19YkR+zSGly4neQ5kyACif7gQu3t4fH6Xf64Z
	2btNfH2GcvwUH5unERpJafTd8NWrx08=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EvtcO+aQ;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770047871; a=rsa-sha256;
	cv=none;
	b=xmoSMGSvTS3Ix+5mhPh/xxuPYmjyuBAq1JnQmj7ApdWK06keXUE09ogguASgQYuUO7I10V
	+fMVR78I7gaXvcXqDUFn3JQtuzgdlhxLs5NYcCiNkWwVQT6V3T6eTb2PFSxWD+FT8Y9jrG
	qXn14IjX0n2rWIoCqYzPLCjt1gVDXRw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 723F7600C3;
	Mon,  2 Feb 2026 15:57:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835C9C19425;
	Mon,  2 Feb 2026 15:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770047870;
	bh=VrUiLq75DGzOguYtbXE6XDIwgQv8ey6yUw/4kWmprNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EvtcO+aQ9OQr4h7jVSo1frzhSOxnbEFza5TzKINdvokRgHhzCFihUKNirsH5eRqQI
	 o+nHAnSP3Eoi0bhKqFBJ3u2eSv+qnLcMX9Vd2tQiKRGw4ttIeXYOU/ERlhl5MqOJul
	 PsuLlBgmcEFXn0AuZ32ZOEVEX45Clr5tA5fO+yadkQQj6G6HdMqxFhw3mFdUjHHBXr
	 myrGdBa3SKJ4aSeOQEMvIpP8bh9ers08+Fo6MriW9fAD03sNqBn+9zezmIGd4gom+G
	 jyzYK0M9VwIuZH5OcQeH0iR1bKf5iuEY+RTC0/SsnYMbsljNln0//btttmiAeZNY0x
	 c5pO5QBbZGNjQ==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id AE3FCF40069;
	Mon,  2 Feb 2026 10:57:48 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Mon, 02 Feb 2026 10:57:48 -0500
X-ME-Sender: <xms:fMmAaRmSarQtSgkJL9ElgoWpBN4BS4MNEmLnHRHV6F99rZKMtNTTBw>
    <xme:fMmAaWC0Xz2TieQ8kW0LBdV-hQQhv6v2aDnvjoEeS8YkOBLp3bjHiuklagKlCPa9b
    dWwlqPSveHajPxdOf6gFL3XuztwNv7CRGxmfxMKjoKNaXQmsC2yTAc>
X-ME-Received: <xmr:fMmAaRzu-6Ov4o68ZrAs1fsMHIkekcEygHLprxa3NZwsSl9ugG7hi-6TLMrNdw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddujeektdeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdev
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvdekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    epmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegurghvihgu
    sehrvgguhhgrthdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurd
    horhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrg
    guohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:fMmAaSfdJDEPUUayeRq0_IedMJFA63QZZDNwuXMpIlsxg_PtDbT70w>
    <xmx:fMmAabwdEqLjU_0sxb900rKtA_5hXCpvTfDBPBc7EdbygooWNN7YqA>
    <xmx:fMmAac4UCTbwO-KzGoscML5ay9adm1RDBg-oUftUQLU47tQtNdtsuQ>
    <xmx:fMmAaYxX3Ch1V6RubEzj8Zil73pfO2J9zLr5vSfJug1YDdj_fvfEzg>
    <xmx:fMmAacbukOcaweQH080ju9vu0XhOswAzy5C2A4J3UVL_JveQqEs5iY8B>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Feb 2026 10:57:46 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@redhat.com>,
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
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv6 08/17] mm: Make page_zonenum() use head page
Date: Mon,  2 Feb 2026 15:56:24 +0000
Message-ID: <20260202155634.650837-9-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260202155634.650837-1-kas@kernel.org>
References: <20260202155634.650837-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: F1D53100016
X-Rspamd-Server: rspam07
X-Stat-Signature: u5hkun7f5437kags8j5x9jyqaes78t33
X-HE-Tag: 1770047870-175192
X-HE-Meta: U2FsdGVkX1/eAB3fORHpLrdDRk/HjusNEYf5PiEvVJmMHcw+wSJWEwpx/9W4rk+CtMZHP+DPa1qvXmVlaCG9RbmVo1BLMYVaUn9x5aEVgRxNevAXrdhhWLDNoG6YUdBcHoHVs8q5H5m8DAONwC+V4Bel/OCemrs8D2wplCYiF9yTkxDb4q9nMH1s88eXG7BuUzwKBuQCBwvnOO/etA24B633G4vsrrBR/b33omGj49EPnJcvJIM3WAZQjoXiO789M25+q3fKmP9w940bddzhFBqTNZedDTxDRtpLwpTHAzTWJIk7BMM5laudTj52ZRqjM9eU05vQ/vZZ5TFvknxjhh9GeTpx0MxjqtGTiuqM0xhZGUvrxbNhzP1N131FJH/IdgjaVNjldHYiEPRbTbOmDstmAaBlcJXZ5vzZx+QY29cbA2PTsPylw+m8w0wklB8JTTQNXtR+Yf6yf8ei6uWlI3ahymbWzLsC2hOwtwSPrWfTYyt20ULvVlYvsO8Y2xsjkU/qDQhKti43M2RkbXXbHIb9sflUXlDglMxF3kqwE8XxWzHEfQgQjrh9b9W78Du62GI589vjcR8IMwfHAHD4/zNB4OggK+EZTW2y9ZL7R9tgGHozUOKryzDWM8jIO+l3ZVQLozhKZGE8WUE3mo551RbnPc7B4f05Kvl9T7fvTloCtZfIlqLVBb15sfREwR4n+laFrquVTNlTcwsTgm8Gm4qS/HNi2k4OIaoV3+rYNDW+niZkN/Lox0UqmS7WKYpT8ClyQkOMXT9u3DRitY1Tn3yKT+ssUM6dwLiMyNAad0WovXRUAWlIy6xzFu+oGzuKnzVABUlJzNHYCs08bTudvS3dOyD0eRawq+OQnMEc0rdnYhbC/y6QVucQbMXAE8MM3n4CDhGA1AFExbJ+HakzQRaPDveUhX+Lj4Iukkfs1LG6D+HS1kajhsQR2nMZ5lrTj+a4FS60b7xNuaBIq8S
 rEWxLJz6
 rjhnnrBxK1qL6BNv34r3CTZrD4cW3VX0SoMOcMjgdBe//UCjWjt6qZQBrQubzjy8pQgazhG40fsvk7jTcCKkGB8xOjj5l63lTzRpzHnwa+VCwnh3+THDQXK4sv4iOMlSy4m0FA5uon5mxd64CJ3WNBhVPmgiNT9jM909hgZftsu4LemZeqjgo3URuDVSxoNvnqvmCT9qFx7AUPhQ0D9mRjB4v9+4rYdWzT1goqEQGBtmNSHAyZNk1fZ1iFNoTIVR/YfVdtcLJ5s43nQlewxH8JZf/+HG4fGDlcVLGVgu/0SC2Qrs2Wv/VDTRUKpNK+pfJmWypnVaN0j48jHw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With the upcoming changes to HVO, a single page of tail struct pages
will be shared across all huge pages of the same order on a node. Since
huge pages on the same node may belong to different zones, the zone
information stored in shared tail page flags would be incorrect.

Always fetch zone information from the head page, which has unique and
correct zone flags for each compound page.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
---
 include/linux/mmzone.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index be8ce40b5638..192143b5cdc0 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1219,6 +1219,7 @@ static inline enum zone_type memdesc_zonenum(memdesc_flags_t flags)
 
 static inline enum zone_type page_zonenum(const struct page *page)
 {
+	page = compound_head(page);
 	return memdesc_zonenum(page->flags);
 }
 
-- 
2.51.2


