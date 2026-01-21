Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE3FFD46953
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:23:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C6166B0096; Wed, 21 Jan 2026 11:23:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CDAF6B0098; Wed, 21 Jan 2026 11:23:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 747656B0099; Wed, 21 Jan 2026 11:23:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 65BB46B0096
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:23:13 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 69B2F1B03EC
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:23:12 +0000 (UTC)
X-FDA: 84356490624.14.7CDAD1B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 64C324000F
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:23:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pIi5QCw/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769012590; a=rsa-sha256;
	cv=none;
	b=J5aLEJw8Ui/FZ0i9xuUOuNjUrb7450jTXX5B3jue22GLQQoOB1N4/yVfGvkyK5zQhC74Nu
	qti1J5d5m32r7ZaTn+FoPlrBxgpFbM/n7coiPaXcGmdI8ZHzb/pi/yO/hpdahUIo88/4Cs
	pl5u/RnBj0Jgjft+yB0+33j4GxKxE2Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pIi5QCw/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769012590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dAGe1dfiIYGi3XKy1uKxdv04Nj41JPfAb6wkkWVQ4ZU=;
	b=dRv14Zrzlh1YEcuYx5ZZPU8AA7679OQ5shVQIhcrMyuWUZWMMTmR5FBBG6X5MbsPoxxLeB
	4HQQyb8iisnSkrs0E6V+WDu0pj5OiGp8jlXGHa7ax5V6gf/oQXVu8qf+mwa4RCx5Z2trH/
	auiAkeyGWp/G73zeVYaOmXbyExBB9BY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B700360130;
	Wed, 21 Jan 2026 16:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91BAC116D0;
	Wed, 21 Jan 2026 16:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769012589;
	bh=ks57jkdW/KrJZ1O+qpYuIMBO4yJej3zDvmP56bgTAEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pIi5QCw/PTZhzSSUXCUZ1FrVlZAG11OZ7NnpsEOlpwZ6I5/eSO2rWHMR4rgJEhm0d
	 PHBV8YQGbkVl7uPLz/b7F+ooUCVFE0GIXbycIJJFHcFa7AAP6kisMUpxlAfjDe8N+V
	 PeMotC3dHrSHaeGSi46jWOAMrnYYuSTxGvGOwqOkz19SwsVBoreSGgLf60FePBJGgY
	 +2NipdqmLhj/O+2yJc7x/El/QzN0fosYJk3X/YoO9FJ3W8v8rHkNuZYK1kt1l10Pb/
	 DHIq8jGuxXGOR6QGF+IVwIcukr3Vea7pl2t11bnNZLgeq11KWz6FTRzXn+bjWbo4cL
	 SzyAPoCaPaEeQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 20192F4006B;
	Wed, 21 Jan 2026 11:23:08 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Wed, 21 Jan 2026 11:23:08 -0500
X-ME-Sender: <xms:bP1waWr75g8WVLlQPR4cCcq2sZ36I5kQRQya5JkDLs17piMgzj-N9g>
    <xme:bP1waT6AqCGnH4DLVzXuf62eWI1ozctsKa5YdAd4JkRslcdSLrGl2h_2izB8ZBoSt
    e04JKOhTTwNz8YiV046nkp0ffKYDM4qjMX9Op4D5pavuxew0DKePQ>
X-ME-Received: <xmr:bP1waeBCfc-6qXxD9dmvn676GEjWZNWQ61ZxPs3x6a8V37jlJ1G92yOysOpohA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugeefjeehucetufdoteggodetrf
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
X-ME-Proxy: <xmx:bP1wadaQvEVWs9DXUyfT3s1lo5Zip6gHQJhaS2CoR_KO7RakvsjrDw>
    <xmx:bP1waaI3_me2SXznHCotL9b0czOFjaFwTgjgTNaIeWvAJzCqaFT5PQ>
    <xmx:bP1waeCKlE4NGIqdTvZEDN5ndAW-dPsNNMNo2T3jeIMbQK8MUhNEQg>
    <xmx:bP1waWNImDl_FzfwNs1Urf9ubONYJB4ju_wqQH_58MryfFWFxpjBRw>
    <xmx:bP1waTWulj-lmqsBzD5i31ERa0Agp6vOF2Z4fwKaLHQy_sNSNeCof-Yu>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Jan 2026 11:23:07 -0500 (EST)
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
Subject: [PATCHv4 06/14] mm: Make page_zonenum() use head page
Date: Wed, 21 Jan 2026 16:22:43 +0000
Message-ID: <20260121162253.2216580-7-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260121162253.2216580-1-kas@kernel.org>
References: <20260121162253.2216580-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: awuqsa47ur7xtd3qm4tj4wemf9jdu4om
X-Rspam-User: 
X-Rspamd-Queue-Id: 64C324000F
X-Rspamd-Server: rspam11
X-HE-Tag: 1769012590-647892
X-HE-Meta: U2FsdGVkX19ljKgaU1YBsCCFNiOpjNiUmhw4WD8WsME/WPuBM2OoSSWmn4rzuLvoYnoXXsFRbyaPDqTChgryRc+yNsdNqFm7VhHn/JgVcbgqN5XrRxHgkXaiAvlBTcFvoDbR0Lv4EbOwL4W4pBotDisxzEF5H8uzallqZFrLMJL1DDKq0C9D0jI5eF54AidGxLsPzGlMPmt6/kif8AJagWLo/QDPwTpeTDnQdmzyK+CzZEotzj3Ot9eD36X95WWjWHobwMX0NMLrRN0cfH/16ly+kWxfzWMOpVjXctxeuBY/LHJ7P63LzLiHiu/1Ypd7pqpYEoYL7TkAYBJI5Xb4KvQWGMAiJqSzDPg9oMjtesxA0wI2v6v5Pl1LifIBVZWPCyNLef+A7K1IOCj8E0Q6KgnYS48x+Ls/60PXBetOk7B3d70WUN9Vx13FoYVevUBV2KA/fZ43Ip2NgQvVd8GAWF1XpOtTQxHG2aNA4hTi4ewB2/KP12g791I/yi560SEmrpvqg2RRH+7Wn/EB0RcX9KQKt9ao/42X58r0lT0k6KdnOhvRgz3SJ7UrzPNnMMp9jA08D64JgxZ6zAqbzq0CnmCuqyP8OAFTy4uBQzxilljgNYznMDrLjnJ1aZ4mVUdHLYx2/tFMdCf7LDR7svsUM5G9fHllE/39MXiUnehaw88JMMQXjl8iBCXNfIAfRjx2FnIF96nyNPiBQVVCjfyqG8opp1KPdCw4PtcyZ32TYJ+e4Kr3oCxwCiCMsTKm5MnRS6oL0o4/dlJX9LGP4mXRM+WBj5p+gtVMSmbj1++9sNSjP+NJRVrvxnBEVK/IgQFjkMQPyMu8Vw6/4XvlKSOZs9UT6EGmRa0XP+lKQjavf260fnMbewKc9kGZiCN6jDjqwC2ncG+2cerh/nxkfZnjw2b5xZoyMVjtk0cMIv0xaa6nZUA+wr9tA7sgFB5mf75k/AfxHmYt4p03O2Mipvb
 rVg2V+9z
 7t30KgqnSslwYsPisY8VnqN0IzuUe17HPFX+OzEEQIGd8x3s2TBLBtTuab6/u6aX/A8nFywNqUU6zU6i6aHz8MqHOh2vk2oh5qrHv6MBQyegUTpMtd1wGHsEjvPSoz9zSWys2jOWWQk/lZ6PDGhICkS4G0eUEzViMc9VV1IavtI1PmqMpb7CfrlZ4xFsc8hRXMQaMuUsHQbUNw2WdYRX3bUg6SLhwYndsM9sns/P7VO3+ybdOag07cME+Ueiwk70QfjSISpcHD0PXRsjxJxwr5+cY4Bp3Edj7ag598XkPML/wXx4qGSLZWGMZzA==
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
---
 include/linux/mmzone.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 6cfede39570a..390ce11b3765 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1223,6 +1223,7 @@ static inline enum zone_type memdesc_zonenum(memdesc_flags_t flags)
 
 static inline enum zone_type page_zonenum(const struct page *page)
 {
+	page = compound_head(page);
 	return memdesc_zonenum(page->flags);
 }
 
-- 
2.51.2


