Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58AF3D25B7E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 13:56:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C35116B00A1; Wed, 28 Jan 2026 08:56:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEBCB6B00A3; Wed, 28 Jan 2026 08:56:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B025A6B00A4; Wed, 28 Jan 2026 08:56:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 98A896B00A1
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:56:17 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2FF8716067C
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:56:17 +0000 (UTC)
X-FDA: 84381521994.22.4CFF9B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3918E40007
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:56:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CesdToCi;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769608575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uHj6gPr9FuZw9B6a2IED+z8/irWY7PHg2qHFE+wJL+k=;
	b=Fe6oBPIhp7kb9RThD0xityw9T9yuv3vWsCejXMlIGBZi9MCoUk8dn0wEwhunyvL96zk+Eo
	qNdm3mtb2hkmYZXibThwSN8mlWaCu633jccArnFTu3UlwUyE9k4Sb++s0GwZBKRxkBKQlR
	2/1v/7ei+HnIeMl6e6sK25zyjqoNYW4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CesdToCi;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769608575; a=rsa-sha256;
	cv=none;
	b=JwSjb4NEi6PtuZVlLsVlfBU7cAgXQatOuSjEAODxUdxKO0N6qoNZ4lCxdRKLEzPIQ91D3L
	LnMGf1CUsbnUrN+JajpUQhYBc309lNgiFzkTO3FKNOptxA1u2vKSITwpOqXaSnQa4o4LRx
	c5z3vyGuLquffK6iE9JnlnvlsI2gvhk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BA72260123;
	Wed, 28 Jan 2026 13:56:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04E0C116C6;
	Wed, 28 Jan 2026 13:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769608574;
	bh=VrUiLq75DGzOguYtbXE6XDIwgQv8ey6yUw/4kWmprNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CesdToCiZOfNgCfHGdBNPDTXWSuQ8JYshl9rWWXFZciejbqYb6/4f1yV7bVtzEkyW
	 zXhjvhbjCo+wqNlrPh3B3Ts1wKbTfY3CwIpMcqkb/bXtIIb43bWFzssN+iKukSLzHY
	 beWbHgr41d/+cd2QlLmm2hE7oHBDUYhFPPzbKUQLDyvCV+aD+KFoQnDMZ0fg591RNF
	 CXZkHIqt0ogufNaUDmPNsrOWdzgOiVlefvxLwQY5rMHdJIZxzueUB5OshQvdX7GUXY
	 oXQXq/hbusN1KKHBKjuiv/Th0fzFe3AyYf0p0nKdOkiguY/7ZIgT2pb/ZQ4o6RbkWR
	 Duf7Tdrt2BZcA==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id C8C43F40068;
	Wed, 28 Jan 2026 08:56:12 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Wed, 28 Jan 2026 08:56:12 -0500
X-ME-Sender: <xms:fBV6aYNDf-l6Wp-0p5Rxt6rle6FfVnGj8Hj1gVpgi0fm1Y_NexZeEQ>
    <xme:fBV6aYJ6TOhqNi9JZbX2fkg0w2cvPp_gOrtdkJMMaJnchaMHfCz7urrtaM1rr-iM1
    auDFCXnKP7ALO9xgw3rge0eBuq2ef7z1-5ebSwsz-s7fTsJWVq47A>
X-ME-Received: <xmr:fBV6aZbWJkhclum-ZYcIzBk2uXa6l_Oa7ZFIrvpm8cQW3NdjKFd9bw738VmMkA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduieefheegucetufdoteggodetrf
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
X-ME-Proxy: <xmx:fBV6aRl1v8AVKSsqAqM5yGyp6qvoorfMCqgMyQmhGZSYlNRyPaTH_w>
    <xmx:fBV6acY7gJoG88XxhixLUdmboNl4eFnBYdOkvTXu0mGuiOxXqLA-cw>
    <xmx:fBV6aRDbIEmSL5ukcuIGiJkKzeYXwo9K8JHg15JHW1y6FZPlDxjXCA>
    <xmx:fBV6aaYN86aFFiDOrh2ZE8HHsB6ZdQkTj1Ya2GZYdOHsgLj13gIMPQ>
    <xmx:fBV6adjTz2q8JbYQyOSrZH6cfM8V7XejcbT3uPo-4Y-8sYSeKU3uSYAY>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Jan 2026 08:56:11 -0500 (EST)
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
Subject: [PATCHv5 08/17] mm: Make page_zonenum() use head page
Date: Wed, 28 Jan 2026 13:54:49 +0000
Message-ID: <20260128135500.22121-9-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260128135500.22121-1-kas@kernel.org>
References: <20260128135500.22121-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 49dubkskgzdic1n5c7tn9shtgnz6kecd
X-Rspamd-Queue-Id: 3918E40007
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769608575-193080
X-HE-Meta: U2FsdGVkX1+Dkhd4nGzdny885IBSurbfoJHp6PGKFfrb3cRc3YLQ2eyuIsdiFFkkZ7U1P9UegXdCK5CeHIS9dTQmaQnX0irhruo6pbm8u2NlVigLVgxDRFPM8dcT9fVbtcid7CLI1YsUirFVCuE7DVMmf03McQDbKjpKIqUR+FQ4D1T/7SmSohMgAJqG61jqkRddVDppnJicB0lz5fdLEbFq0yYF8LSkPy9qvZ6/AyYLhR2QofzR5GorOWHlIMsSmVF1lUw/srFL7gLVLjLROhW0lXNe9mdqI49v4rsnMU9tVPWz9VGlBYlMOQkIaUJ3cKSocawL7udQmUiYUTZFmA2ovBEYyVvoYz+8bYQ9C6Kd9Ih9Gp8JGYqYgON5lb2j2dOxceveLyMbTAcd8NNghh6eSzGp7zBsiE7zxVI7z4nvxJEzG12pzfA7taxwWPGhN9I7H+noEiQ6GYn3Qbrwgmw8WjgSCFyYGdFowExZX34Q7AcxPvublNkEbDCa4/63T+kR0qUoQSlKdUp91cKiZ6uGSXyz20X7XfcvrGXA5JRTi10vP234IvVCpFn1hCEqULb5N27Q3BmLYmJ+0Bv+nlkFrj2LIEoqSPBAM5CR9LvM/VsDdF4X9RNzkcllS1FryiaZpUgZ95lwSmE3+8tG+9BkTxbqsTS5SQqi0taMMb0kZDGUzX44SWS7kTZHAt3InUEdSYflFQfpQco5gqavqp4sDp/8CYOxeX6EBaCuMNAsI2rXhIhTzRUPeblmH7yWUtroFMzkDvrLpCATqhYmMT7dIyw1Ht1dS3OtotwWozHNwz+XWZJNWu35URrkc5Fi5Gkvkdjy1l0aJySw34a/M9g+ZHjJjnAMQtjpvSWmf4+lhLu90hLBLFIClvYEEbZPNjEm0aLDOYrQlxWPb7iZwu7ZNN38erM3tSUIQCLjfKaOJXc4NNkv78OY/0NIGXHi0QMDOZBEmfKpSv7ZmD1
 lyMVh+/m
 evfVpeH6PdTAzgS0Jsv/vYJ5Xi1H8iRwE2MhWWX8g55wjB1DK6PS74MbI3CWefKD9c/0wOjfiHZHVyMtFDHylZzlXIRYV9i9MsubuCaZmDpgvPgS5xrIkfK3HEAYb19xN651Jkl+lflrkZuxKvkn/UHZ8BleZwgLzVr20dRp2Fxiv4XjQ7NoKvGBcHNOK3j4KfA6OFHfRjVbgllz9qDV1L+QMbGQd87397GiftuZS3wE8H+Xt5C7yEe+r6iXBUZbfIQl0kELvg1HV843+BrCztCMuz8kJS7bOJmuJSzExSlML4loiGi9QoyIpAVZ23njhM6VNXvah8kkQq6o=
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


