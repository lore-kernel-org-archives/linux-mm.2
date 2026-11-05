Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04EAA606A32D
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 01:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=RA3zsBB6
Received: by kanga.kvack.org (Postfix)
	id CBB176B05B2; Wed,  4 Nov 2026 20:06:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6BB46B05B3; Wed,  4 Nov 2026 20:06:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5CBA6B05B4; Wed,  4 Nov 2026 20:06:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 91D0C6B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:06:21 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0FB85A086D
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 01:06:21 +0000 (UTC)
X-FDA: 85399274562.29.E1B93A5
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id C6E274000A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 01:06:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=RA3zsBB6;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf04.hostedemail.com: domain of daejun7.park@samsung.com designates 203.254.224.34 as permitted sender) smtp.mailfrom=daejun7.park@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793840778;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7oacRK3Pt7sPDmCYh3oGr8HRMGBnelioWyFlTRnDaT4=;
	b=dE2mz7IUxcdSc2dKgME/v7UPfPmqc/auzdo/0FS4aglMSSLjPjZSqg//2v9WSApaflda2k
	wj1AwEzrFwLA78iQNmbW2W4ZPpFl+KvTXioKthOE7lw4BIyu9AyT9DAwUznkoNWAMgXQD+
	uZWKSeqpCz4cCVIzv4Y5RCsRSPLG3VM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793840778;
	b=RTCXduQy9M6y9r4sB96zV+sKARh1drifxYy5sA1uhzwv+3U83+iR3ED8ccULw0SSXJAL1S
	L9R+BBrELI/kO9EUGDzN3iLH08NgNg7Q3iMj1Zbff4e5xshDyipFiOnI+9AppjqZFAkoGv
	ngSy2cPGa/uL6WxBpEOPcumMPfIBAXw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=RA3zsBB6;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf04.hostedemail.com: domain of daejun7.park@samsung.com designates 203.254.224.34 as permitted sender) smtp.mailfrom=daejun7.park@samsung.com
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20261105010614epoutp04bc638fbb6ec8ce26f01008e1271a1f5d~lAK4qKFTV2844228442epoutp04V
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 01:06:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20261105010614epoutp04bc638fbb6ec8ce26f01008e1271a1f5d~lAK4qKFTV2844228442epoutp04V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793840774;
	bh=7oacRK3Pt7sPDmCYh3oGr8HRMGBnelioWyFlTRnDaT4=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=RA3zsBB6URHMzGwoGYVTZtDnG4Z/RSmoifO152SpBUu+BE87rLi3SQfpeaFgcWXKA
	 E+4yTCLFFv47LIa+83OerP4m0YunVhraHGUkgn7/KS74QvP4afwSZiLvwjZk0B7/2N
	 WJFaNH6P/Rtf+gXJ4fF4CmO1KriIpBYMuSjlBT9c=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20261105010613epcas2p104a21c4f3ac935d60d726cc0c56fbdee~lAK4A-fKR0052700527epcas2p1G;
	Thu,  5 Nov 2026 01:06:13 +0000 (GMT)
Received: from epcas2p3.samsung.com (unknown [182.195.38.212]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4jKkdx2v9gz6B9m7; Thu,  5 Nov
	2026 01:06:13 +0000 (GMT)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Subject: RE:(2) [PATCH 1/2] mm/huge_memory: set memcg_data before a split
 page leaves the folio
Reply-To: daejun7.park@samsung.com
From: Daejun Park <daejun7.park@samsung.com>
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>
CC: Tao Yi <escape@deepseek.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
	<liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, Ryan Roberts
	<ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
	<usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Vlastimil Babka
	<vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Brendan Jackman
	<brendan.jackman@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>, Daejun Park
	<daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <DMMKKOIGA9UJ.353PCUUMFLCCJ@nvidia.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261105010612epcms2p60abe5ce24c4ca7d61236b613a517fe2a@epcms2p6>
Date: Thu, 05 Nov 2026 10:06:12 +0900
X-CMS-MailID: 20261105010612epcms2p60abe5ce24c4ca7d61236b613a517fe2a
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261104163327epcas2p1f056cd220dc0d3e40e6fcea082f01b74
References: <DMMKKOIGA9UJ.353PCUUMFLCCJ@nvidia.com>
	<20261104-kpagecgroup-split-v1-0-f70e947fec85@samsung.com>
	<20261104-kpagecgroup-split-v1-1-f70e947fec85@samsung.com>
	<CGME20261104163327epcas2p1f056cd220dc0d3e40e6fcea082f01b74@epcms2p6>
X-Stat-Signature: 5e5ht7ixmt6qt6xn9sstskzzx48jb7xj
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C6E274000A
X-HE-Tag: 1793840777-175264
X-HE-Meta: U2FsdGVkX1+TC6fpJJ2v8+f4cwUUTjIbV6yZJQtgyzCONadBiB065quMr86D4cT7tH0nfEdEjVaePakmCCqaBrKGXdPQvN3GJF9UANhnbaAv21tJRSUkrD6HrO0oZiM5fLVj/eUc2tJtNkb1dPlwoZVWfsK53ckx2UEGvbMjd9UxPL4gSI6C7tIqV08wj4V1FXFvLje+VEFykVCuugEOSZReNRJRpHwn2yTIKvsDzmLVn39yISueCQhc2VFo81OcEgVFkqK4vBpwHWRVTAWd6T9Mj0lW7TW6KS6DxmBxFC63MRbbdO9ZLG+sRzYdoXK3HLlxR/e5P9hKWjlddEZ3wTB7XvCYdvspGQGATLE+SaO/mXFF0IdVaaELHKHb3I2dluGWYlMlc2mQ6FfmbF7EVrkL4Xzs1wGE34wjd42khThMeouE3Dyed9F2xvMUnVZtGpgwTzraM0YExAUfig+HRs+Vzm5KAJ863I4j00QrUwYmhpdhw26pbw4I3EvjrZckWGqtMartmgUPMmIWC8rqZTrTI29+u57ZidnVc/60+AGe6BbBACFDIOVxKhJWW4SeQWkQechkpraDTixneyyHppLA6sR3L1EnNziOounTGhGvC+xKmHHmoo5mmVsdyuxl3fZIvvI2EnJJcZ/7Cex2+Z5cu27zTyxhixs8uZeVE7PgAw/ht7B+aOkrV84qJdBsb/FBHSkxkerP9nibFIcEGoDdsQYxmk4uYdwKDlEw6QK9AlkBiMDCK4DERv8aAbBMSOFRmUY36AeFs3OdnuYag2eDDXrKLx7B0QNIg9xWtVzLe8LSdOIssbv7poHZhD/Vvc7ddBOwcxwcyTCuqqO50jzy5NsluTsaqNcisV61Z2DmSY7Ojt71C3exIhu+7yczt792f35PRaE3DO0qL3B+PeROU96Go9tn4kmF+6prq2l/qgzqD8kaLP94zalEODl3V1LQHk25TR09thmBBgO
 H9MspmaM
 vnN2hfYkjFi5snR3F4SSpmYNJQI/vg9+k04jzPlbAYvfHdOklrOIdmENhgmIeiOzEh66E8z4X5SDABKUXWCnA81S1I1feF1amc1BzUhyWyiOwloPCfi/GpD+Ym/TmtQcqdDXSHJTOOpdGW84TIEFvEl/MuRue+9FMk1w7353n5IL/G1EpdriW69vSlVsIgmgvJXTVTwawmNf1lpOq09Pn4kQ2H1grIOGsMj2Gg2Tdq6sda1hAZUf522iyF33RmVC/IFpJ2NkIeBiC1nPKyqBsgL+p4Vc/xmXuLevjYV5bofrc4nUiWfjAXaV/QFVUwpvauO4+MfLun5FWrmSueV0SbDIb3w+5IVfAKFBnZKISBuxorg6CKPNH56wfqu2tdE1EBYFBiQZwPOHKPBM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed Nov 4, 2026 at 11:33 AM EST, Zi Yan wrote:
> Assign memcg data before clear_compound_head(), so lockless,
> reference-free readers get the right value instead of bogus data from
> the overlaid ->_nr_pages in the first tail page.

Thanks, agreed. Your wording says why the assignment has to come before
clear_compound_head(), which my comment left implicit.

Thanks,
Daejun

