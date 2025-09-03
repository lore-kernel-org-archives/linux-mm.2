Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB6EFCA100C
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 09:04:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBA9C8E0006; Wed,  3 Sep 2025 05:04:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6BAB8E0003; Wed,  3 Sep 2025 05:04:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5A488E0006; Wed,  3 Sep 2025 05:04:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C067E8E0003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 05:04:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 715EF140599
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:04:37 +0000 (UTC)
X-FDA: 83847353394.09.80D9AE1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 68A3CA0004
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:04:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e0E694f7;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756890275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BBWI71OsKQZyLnNr0QhdpDLRIJajbdKVNHY9RFe4Ee0=;
	b=2P0jCNM3u29dOOYdOgDCuPkvUOZlVmDWzPVuoWRD6P46ZWsMZwmQhMMwjNTV6AajadW/dZ
	wDEzEFa6uMwFjNxSzX4uhbrhh+03XOThcroBUzOjgR5WcGSHLQ7tt5DN7TDJTavlJXoN0/
	+l4QRtcrx08bT327JuyWXUEtys3kBP0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e0E694f7;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756890275; a=rsa-sha256;
	cv=none;
	b=Jb3ktqyW4woQ0js/5F9IdZW1acjtX976pSfC2zwZ3ZTuqHhytvFsj/YLDkDRfkOTqR9TcF
	ToaNEc9z8v2FHGumFnWGACyiQu36lNiTHbxwOaoRNrIHCarvlw1LtTplkmvjup1m5dl58N
	9PhJDONSLOVbZCSq9bbnRMZbePXjnvw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E79240AC9;
	Wed,  3 Sep 2025 09:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0212EC4AF09;
	Wed,  3 Sep 2025 09:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756890274;
	bh=37WFRxGfXkvYg6/QkLtmsLkCn5i8jVOdpZKNuE4LReM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e0E694f7NF6psG08prlAXYkJM98ksYMAzA82Log9c6VLMD85VmJRoln3rdaN2b1Ma
	 q7wUai2E//Qxiclk/Kcy4s24oUPizqTrFPJ/Eni99/pUIYeK+EPam7Q/r52U6feCmD
	 fPmYsEclOvQ4dK2txi9QwMG1uqyXwEAmkNCml0Ra9crbI6Amjje1a79j66rqxSrIcq
	 /kA/XJAtGjcIxiIxo7Sgr6gLr47nN7FRMd6Bwv+F1l1/dE2lDaM98lHc+7ttxwsUE+
	 eD03qFDOu303HREiMTr7kh/9fxCHdtG2+WIv7JgVMgTOb/Ud17SwEUpPjJVjdjkVZA
	 BmdAdCIqqngZg==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 40380F40066;
	Wed,  3 Sep 2025 05:04:33 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Wed, 03 Sep 2025 05:04:33 -0400
X-ME-Sender: <xms:oQS4aGrF9vs-2BwMTumtKSltb0rILaPsEXbce7Wc1-YEG9GJBifGMA>
    <xme:oQS4aJxgy3Al5sAK_I4Uy-LGL-XRv_sTvAmjAadm73AAi8obrSb-6e0ioy7C9eVZJ
    89Sg8jDANulBBj0Pvc>
X-ME-Received: <xmr:oQS4aCdU5WbE-g2PgcM-Nskn78h4kC2aNosrj6BlOsDfr-wtRHoqFL_QiI39>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcuufhh
    uhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvghrnh
    epheeikeeuveduheevtddvffekhfeufefhvedtudehheektdfhtdehjeevleeuffegnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilh
    hlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheehqddv
    keeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrg
    hmvgdpnhgspghrtghpthhtohepvdekpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    peguvghvrdhjrghinhesrghrmhdrtghomhdprhgtphhtthhopegrkhhpmheslhhinhhugi
    dqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiugesrhgvughhrght
    rdgtohhmpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdrohhrghdprhgtph
    htthhopehhuhhghhgusehgohhoghhlvgdrtghomhdprhgtphhtthhopeiiihihsehnvhhi
    ughirgdrtghomhdprhgtphhtthhopegsrgholhhinhdrfigrnhhgsehlihhnuhigrdgrlh
    hisggrsggrrdgtohhmpdhrtghpthhtoheplhhorhgvnhiiohdrshhtohgrkhgvshesohhr
    rggtlhgvrdgtohhmpdhrtghpthhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvg
    drtghomh
X-ME-Proxy: <xmx:oQS4aNe_4TyZ4DWV26viDhAmFw2Q504W-pBhL-14PpQeZk3IidcWPg>
    <xmx:oQS4aMYr0UdkDBd3JpAVNTmiZyEx5p6Lbu6S2tU13dFaxfhMfcTYMQ>
    <xmx:oQS4aG9xpnRm-JrdcAN830fWxhA-LfJuvkBPcYb8DLSsBy2gEabqPA>
    <xmx:oQS4aAWKZ4XvrAQrmLWs84zHRXbsKuVa6bwuN12vs64yK5OOGuqXGQ>
    <xmx:oQS4aPepF5KBAJNj-t6vIUoYQGWZwb_GJcMKdgXOsoWI2UHmflYF4Ep8>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 3 Sep 2025 05:04:32 -0400 (EDT)
Date: Wed, 3 Sep 2025 10:04:30 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@redhat.com, willy@infradead.org, 
	hughd@google.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: Drop all references of writable and SCAN_PAGE_RO
Message-ID: <5mqa4xqrwfeot7q6id5garayr5shflnr6fqkvpao476eg6gk3e@gnpvdttydzs5>
References: <20250903054635.19949-1-dev.jain@arm.com>
 <20250903054635.19949-2-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250903054635.19949-2-dev.jain@arm.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 68A3CA0004
X-Stat-Signature: j46w9wsqngrz8k8k3i6nf69jhjssgbic
X-Rspam-User: 
X-HE-Tag: 1756890275-382867
X-HE-Meta: U2FsdGVkX18SJ137duz6v0jaWdoIG2YL13rK+kS/DwpxUsFdjZ47ZqfPIEa4X9Yu5C941t+JA3w2q1gWSWRTawGMWcQOFm8K5ydY+hvEo0aO6ehMGv/SaELlrC0Wv7ODW0U+rzzZ54fS7/cqIqDPy/X0m1ZJdw1IAE79trOM2aoDU/zU9oYzsYx5XRc6r766o6YcPTPL4a8RpnIWEloauDn7+EecmJ/K/9TimVMSTA29NXvek5ybN8n7tkv3Q3tHTV7/8OZf2M2LKHfyEz+lVRILTt9Rnzccs1pM0pbgCuVNmcv5f9YX+KlP4/3oLAN5G+yI+touHBJoBrSh9WqCfyRR376LhQ1KN04XYPP6tWmgRLNKHWSzjcpJ7VmaVwLSaf711mLFEzSQRxeUvHJQdfC7cqlrWedz76wURKoIdLmvmGa1fr6P7lxI/9wzbW4RCh0fdCWxTrVZqVvBJ1oSUH7d/LJaWl3KGzKWoiyjFBdPqqJ0yNslc9jpdbNySewlsg0ymTB56Qyivq5x8LP7BhJ0ypBS5b0weO9UtHgAut6zI6sGip3lsqEEu8UKlvn0R8SimXT+wf241rsctUZM+32wDSzXG6JGJdFUUyiaLDdOMUcXPyrL9FAVsP/h0FSY6K9D3KhoniMT5AvsBxGrWgVu7+SHlgE4+UXx8gyEc/10EhAWVYEg2Q2wx57/RYxFTkX5XU1wm3m/gVx/FvxAZ4a6tzms7v9dVyozGYMoXDBKfBKTztei7Tx4FplO/fWV3ZrIw3vW/5y2G9622evBFKa+IgKmqW2EY+CNTS7hKU8nwcmHfJgYJZKXRlslNw2LoouA2SFaia/lUbyZf246WCfP2d0D6Hl/iHZdVQOVuyzbGKjm23WhSfxw4Uwj9HQx/jziTCXjQDsMh9ueKw/Ir+RmixqwUKSSd2aJOo8w1r686osgjSuo/EXIs01C0aWcIyZft5xdx9v7jJ3fQw1
 i34EERUt
 wnCXPXcS3JgQPsDmrtFjGwgR3EhGSinPyU5zw6sIKnZ5epABVyfN333IKo3L41Nq82Pei9om/IBJg3DvIHMnnw7fVqWxxGd/46sLzuPLSoy7UEBGx4y9txAO2fLwuKa0MI40tgwIPlfijqZbYRUKDgtnBVmq6RTRniXs+StCS5PW/AGw941c7NWHIXYMK3RP+Zo1+XgAh7HZkAZRo6AmyIw9sFiSofqC+k9MT4GKwXYcV0Ahp4/qtuvuR6Q36r/TF0iqbojqp2SDLXjs8J6bLf4tjQPj6THgmMV322TdTOFIvULM+xlXzjHQL9FqZ03Z3sUKug+ZIaogjXcHdl0YaUKG6nRH5MDYjWMbFSLnj/Evv/ch833+WnGbP3dUjaLegNR/hzXGIppFLPqHgS92g0LMz/VIFeYU0YTBCuc6ojTVd7BH4MbS87lJfHFeyAuhK8AJMZRC1+0cQquU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 11:16:35AM +0530, Dev Jain wrote:
> Now that all actionable outcomes from checking pte_write() are gone,
> drop the related references.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>

Reviewed-by: Kiryl Shutsemau <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

