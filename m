Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2070FCAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 12:19:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68D528E0005; Fri, 12 Sep 2025 08:19:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 664B68E0003; Fri, 12 Sep 2025 08:19:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57B078E0005; Fri, 12 Sep 2025 08:19:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 460D78E0003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:19:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E40F5140797
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:19:14 +0000 (UTC)
X-FDA: 83880503028.09.49F17C5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id C18CFA000F
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:19:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lF4XTIe4;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757679553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eR/wYaGa5wvjmtwNq2v3O99hpKOxwpiELuIM4n3SHR0=;
	b=Ko3Br0xZojjU2WWRGFHzaXlM2OEIP/izvT/f7zTKW+2tWnDYJmpJzgfH1WDNPSWv2SYtuh
	EJWb/GDR0LhbQ+TbJv6dIP+QMEKhoC/Ss5Ge1jjPPX5J8BbrVnFClH1C9LnxDClP0T/AUE
	2vc2Syrfyikft3kuwrba56asxLcd+MQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lF4XTIe4;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757679553; a=rsa-sha256;
	cv=none;
	b=S+EJVi3uyRHZ7TTOmHziyeuPKX3oNNtNwjZ1B+rOCn1N6z1zi3NQ2qatp5LVV3Aod35S/p
	i7XzoQvkt4BiIOnqLcPwT5IypT6SF/eYxDhuA1wThsW7y+ENYyxVQYqFssAHbyWjMsueOR
	AbDbh8XSiT+Zf7wkBfMKm66gwdq5x5Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7AB9144C61;
	Fri, 12 Sep 2025 12:19:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C732C4CEF4;
	Fri, 12 Sep 2025 12:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757679551;
	bh=K3GZbphVPlB7nuQAjzkpUgDrop8YRGxK0QNvD4dJlT0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lF4XTIe4iKegJ0rmylKbKMd9zZwZP/zIKRWEgifHWylvwDqe+/bcCp6PTd1DaMu5q
	 6koS1uU04Pfqc1gFpBtQ1GPb1ZHgThsuZIpqXpgoimJvZYvcLaUtdFOxt02jq0cT88
	 Y8emYNZHJ20LHSx1Jn0jxiYxcewbahCwSvU7ASgP9+3K7W1dvGX6L4DzE2Qj6J0NhS
	 O2skSi9AdHQ9YRh9qAw33nh1uq307WCkugZ0S4cq+aV4l8929L7hIrQc1SniSkMGdw
	 aAjEpGMyQ55RvxApMlltOGRAqHES8WVG7pb7fHPeXxwiTUJx0rB8UZXXpy7jzBtu3s
	 XXclgEXiMOcSw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 65418F40066;
	Fri, 12 Sep 2025 08:19:09 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 12 Sep 2025 08:19:09 -0400
X-ME-Sender: <xms:vQ_EaK5xWBY1OdvF-9-d-sBUXNenG8gua_7hWi2WtgkltP5dOTL5eA>
    <xme:vQ_EaCKZNA4xmO0B_lwQCc1yauLGpBsIpon_obzCyKFQYA3O_2OY9uY14tjJYYWn7
    ie4qEIshJxtTOLW5xM>
X-ME-Received: <xmr:vQ_EaE_ApLlX2-1sPH9iRKVulzbqQF32iQCZ0c1yZl98l36j4NV0FjbCKRB6qg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvledtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeehieekueevudehvedtvdffkefhueefhfevtdduheehkedthfdtheejveelueffgeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopeelkedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepnhhprggthhgvsehrvgguhhgrthdrtghomhdprhgtphhtthhopehlihhnuhigqdhmmh
    eskhhvrggtkhdrohhrghdprhgtphhtthhopehlihhnuhigqdguohgtsehvghgvrhdrkhgv
    rhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkh
    gvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqthhrrggtvgdqkhgvrhhnvghl
    sehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepuggrvhhiugesrhgvughhrg
    htrdgtohhmpdhrtghpthhtohepiihihiesnhhvihguihgrrdgtohhmpdhrtghpthhtohep
    sggrohhlihhnrdifrghngheslhhinhhugidrrghlihgsrggsrgdrtghomhdprhgtphhtth
    hopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:vQ_EaHMWpDNhgOLz8YhDyr22doRmBwip5EtzLxG1TIUWdkSQuP4Stg>
    <xmx:vQ_EaLKIIXmaXJp1Xlcvza7CLbKKPRKaMwKcIMBShlR_Y3f0-9Pblw>
    <xmx:vQ_EaDP_BB6dvMXH6WfQFZ17ShzOZbq3erteRXV-JJJxTy96d_WCTg>
    <xmx:vQ_EaNPlMmBIvYxJHR_H-aeQE4Rho1M3DBBavtR2-v2adrY6Rn23Fg>
    <xmx:vQ_EaOLaoIF3jav84kPurobIsVHJDJx511uKZR1tsMpEl8EJmqQpZt7o>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 12 Sep 2025 08:19:08 -0400 (EDT)
Date: Fri, 12 Sep 2025 13:19:05 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
 	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 david@redhat.com, 	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, 	Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
 	rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, 	akpm@linux-foundation.org,
 baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
 	wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, 	vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 	aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com,
 	catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
 dave.hansen@linux.intel.com, 	jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, 	zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 	rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 	lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 	pfalcato@suse.de
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
Message-ID: <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
References: <20250912032810.197475-1-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250912032810.197475-1-npache@redhat.com>
X-Rspamd-Queue-Id: C18CFA000F
X-Rspamd-Server: rspam05
X-Stat-Signature: 76f113qjszh7bb6qr8zcfra4bhaqmizt
X-Rspam-User: 
X-HE-Tag: 1757679552-346060
X-HE-Meta: U2FsdGVkX1/g6SXrvjSG4ptV5UsPJAD7SiqJg8isv5rXlh0fClJDDYnBjIJjrvM0pB67g6G2VNO7uxboT+u2upNaIPghP1I2sJ5bF2tjbgT1L/RQAetPNQ3nkDlfUvtgjIE1jiAJbxAjQNeQkym5iJkLdUeltYSvDuCrwMJ1DJNHdCI0kg9g/JDSBDOET7dpGhbx+LniBjXmxBtDDxpSE/nookwveCnod8LcK7lou+9hbIy1w2rK0nv3ajvs8NKKHhbevK+nyuki0duUTIhjw2o7hOK8yJ8buBdkoKQlo2NSMKMRDW3DGbRt8SU/I6iiWZt3kXQCpZcQgoKW2z8Pg4r5ij5BasXmx20op3koHvMu7f/s7n2MaOoBiyqf0KxvMvOh8Ztq2+VLJNbc/f1w3VVDe/Mh8szj3e7VUg6LmDvtccxOM5C6iMhWqscLlwz7PjMqpq07YfUdkxUbb1T9xd0jEqFsr4GwhNeJ2ftSNB9HAoXMBY/TNkMMn7PEXgTwYVFnugp7W3sGBxbBxDtKhyboT1jBXIC+T5InrqG7Ipzwl/UM6wJ3w3mc6utQdbp0QBZrvemnsFD0Jju7USTWJqNkiQvQPwRjK9YAmyjnmqoTIBFNqyxrB0XGoGAOhsR3S0hShFOzRCDeMogiSsPw+bdVCitFmRpbQQd15VrJ8jFAuzQOZBoKVOM+fKyDAuMYg+MN+i8oW0n2Wd6MkKiV8yADniN/1pxLKjHTVNQFpNS5u5QWw++FZSbIhKaYRYsupKszTZMwW1UrZ15hTgHHYUOvUtpeUIO53bCD4XGyLo7PdGBFHQTpjGMIc/sdmmLDw2iXVoJbSQ4YQgmusFaDN7FLdl+kEbRa9mlHIQlTZrpI5m/t6ZgkcgbxUQ9H4cnV03BN4y1o1igAOtJmsDAODbPmN5HTG+KMeGv8Fw0ThqGf+JrnTYh4y2e9UYXYMhj0G/A9elfkXCi+aysVpuC
 AaXNmF5+
 3wAeFFE71ahOoivK1T8kI1VMmv0n+fX1eX973mCkP7uTnX+/RKpKXqgtNHupjwd6Rf5HkPQoeHNP7npF+QtOh2OQX6P94ARxnWjYnU4k8h+9b9EVvZDzZFj4rtH8sGnV4bWPjTNARu6PAqQ8c5hmNCGjfhU9wth/MVYPa5BQPpCC2RN/Mdo5W9sRpECiajlmoaL5SzRlQ2Jfst0AxYpLSdlzmR6CLQndKAqqOmMazEcu6ViIL5F5bW2XQJmCMKFHl7WVCYmMVd0E0znARwkHl/O6zDN8385VR9qsrb0L+XpPvil/LFpQSF03b2dByrAGUrgadvcmalzkIH1mXgmnEvCmr/ApfP8Kxkir6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 09:27:55PM -0600, Nico Pache wrote:
> The following series provides khugepaged with the capability to collapse
> anonymous memory regions to mTHPs.
> 
> To achieve this we generalize the khugepaged functions to no longer depend
> on PMD_ORDER. Then during the PMD scan, we use a bitmap to track individual
> pages that are occupied (!none/zero). After the PMD scan is done, we do
> binary recursion on the bitmap to find the optimal mTHP sizes for the PMD
> range. The restriction on max_ptes_none is removed during the scan, to make
> sure we account for the whole PMD range. When no mTHP size is enabled, the
> legacy behavior of khugepaged is maintained. max_ptes_none will be scaled
> by the attempted collapse order to determine how full a mTHP must be to be
> eligible for the collapse to occur. If a mTHP collapse is attempted, but
> contains swapped out, or shared pages, we don't perform the collapse. It is
> now also possible to collapse to mTHPs without requiring the PMD THP size
> to be enabled.
> 
> When enabling (m)THP sizes, if max_ptes_none >= HPAGE_PMD_NR/2 (255 on
> 4K page size), it will be automatically capped to HPAGE_PMD_NR/2 - 1 for
> mTHP collapses to prevent collapse "creep" behavior. This prevents
> constantly promoting mTHPs to the next available size, which would occur
> because a collapse introduces more non-zero pages that would satisfy the
> promotion condition on subsequent scans.

Hm. Maybe instead of capping at HPAGE_PMD_NR/2 - 1 we can count
all-zeros 4k as none_or_zero? It mirrors the logic of shrinker.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

