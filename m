Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0727CCA1010
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 09:04:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BC368E0001; Wed,  3 Sep 2025 05:04:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 346608E0003; Wed,  3 Sep 2025 05:04:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23B088E0001; Wed,  3 Sep 2025 05:04:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0BCC58E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 05:04:03 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9974C160581
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:04:02 +0000 (UTC)
X-FDA: 83847351924.19.AAA5E32
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8BE8140008
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:04:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dCuXRWFa;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756890240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3N0k0ltBKHOmD0JWsMESiflKx9c7o0r8RCLFEl9yyPc=;
	b=SufQIqj/uNHdv09RkMPpn6BsHeRPs+aQ7d02xYk7Y4Iee4bLl44J48oHqjEZWf1J5Ngh/2
	88ts2PY/GlTXWbNCjEDuUuINAfbTsnP7Ayxj4b6l2YXC/EZFir3w/4usl557FZdS8hcnPA
	Djvr4nTi021uvBtkKlrAsiFh3MHgMTU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dCuXRWFa;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756890240; a=rsa-sha256;
	cv=none;
	b=OiMNaSB3HpFp5vChEkJcAlxIljN6Fkp+MLM8wmDI+oEEpuE/x7dDoBND1ts11xSeX0piop
	nAFdT8utAHaqukyiO1Ih1SuDaKTLjbGbNUGUR5/Tujtjud9EUVKekG1o8eIZUZbDIFpGPi
	efFE91h97uNwsdWvIDQ5/Xy1eedpxPs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 60600417E2;
	Wed,  3 Sep 2025 09:03:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDBBC4CEFA;
	Wed,  3 Sep 2025 09:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756890239;
	bh=ZaBMP/zFHBda4PhKlPNUHtLAon8HnCbog/bzM7/qsLo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dCuXRWFaPOKeT8s8VSomyL4TZSLL/K2iEy+vANXoWi7l+s1IL+KAsZOmFbPSpeMrz
	 GtNBOTPlFORl/e6dAOiIq1ZdRNNMtj0b0XNQd42l1cZe5Ler6CQDofvooNBHDuaRB0
	 SkFGenh7wkgssCxScdTwYMem6kILdRABDO8oSf0TGX7RjGObfCai/xtsFE+yEHkcNY
	 GVv/8U0MpI/Z3PGI/wX7PVK74MTXzusiXk20qevHz1G0sfOi20/ykOGsfyfJpGD+Jb
	 bVQSi1c02W0t4+6z9kdot59uCTeogNTv9YMZlxsboNMw/nFVT9u6wJ1ZwhY4gPjIB7
	 Uy3jrL1tukKiw==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id BD786F40066;
	Wed,  3 Sep 2025 05:03:57 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Wed, 03 Sep 2025 05:03:57 -0400
X-ME-Sender: <xms:fQS4aIQ1N_CDI01OKhItzAZIUDPa5aYouwp9FW0XEtllPt8jUZUeLA>
    <xme:fQS4aK536jiIPuWC9tHkWWd_MqpADSJjbPM1G-440ZfqEj_ZHNmlXYDB4vt8RQ9Dv
    dnmFc4L9gRH8qTGzcY>
X-ME-Received: <xmr:fQS4aNFSdGsvvMyd1uU1pPkrgaAtYB89PixOSmzs2Dkx_X4V51Gpf0j9hz2e>
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
X-ME-Proxy: <xmx:fQS4aDnqSNdhLb2-VJF2K12Kx46jhh211gSa6S0cQMvIQDXSXXf71Q>
    <xmx:fQS4aIBDKsRZCWaHlvA1kqNaWZG14y0PnsPVPr67XjVMFOeAGi_o9g>
    <xmx:fQS4aKGnXp1yIduCd61JZC9CQwodSVCSHYf6FTDnSl8zlDGdVnN4Dg>
    <xmx:fQS4aE-Jn65CreQMv2TzpYgUQ-ZrSGeJYULb-1o47oPRlnXely5Gow>
    <xmx:fQS4aHnYg_Kxk0W_Y0elB-E_nAkGfi2jnp4wf8Mms3-Vp2mh8tkL7_eC>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 3 Sep 2025 05:03:57 -0400 (EDT)
Date: Wed, 3 Sep 2025 10:03:54 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@redhat.com, willy@infradead.org, 
	hughd@google.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: Enable khugepaged to operate on non-writable VMAs
Message-ID: <zpmk35ljrb7qlfel32bpiomcj3y3ugyz6p35x43oryjigizxvm@jrmzg7ao6omq>
References: <20250903054635.19949-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250903054635.19949-1-dev.jain@arm.com>
X-Rspamd-Queue-Id: 8BE8140008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 8ch4tt37t9maf7yhrbju64xu4kikmruc
X-HE-Tag: 1756890240-309781
X-HE-Meta: U2FsdGVkX18ygRkAudTlfnVcVZ+Ym+6/8W4ymAxRUNz1JOrF9jcX1G+WI2ECQKITptSBv6s67SB29XntNNejMjqPul6fkeQEkbBVgMHwtdOOTebcZ1wlV1TEIyNjL/Hbrdd0491iXEqPoQ4RbsLCRjidzmBrboHFcb2G90hXTtqRpt3yEfUcqetKlQNA7jmD+EQA2AibKM0WvYQYHRYAFdSYJsmGV2bTYmM+rEL+JVc4muOCLRt5d4LZIQtTz3b4Cnh/TGoQ9r9ixVbKfVZntBggPqKiqLODIGO/Zk0yTa5NNa2EUU0EN9syOF8zdgD16RTqWKzj9iLv4S3SaTc6b/+6mRIsM2aSzZ/n/G4JD3auMR/i/mxiIZM6i9B7ebJVpIEKMA9fsfUZ1kGbLeW0boNWap9hqKOt/hIxOuq3rOBDj74VgFqSIT58hiXeNBfkOgE361L5y7ATuVUpI9g/HK4RLrPvUlbAE03O9OmypWATSiTNKTTPnGGl9CC+Lj7X/1ZAAdIckuN2kLvKuVyeiGyjxM4vXXn21oxblTmStwMQAF5/9smNEaePnRv24gGxie6Ddb/LUcpeIw9XfLdVKnEpVB8lNRKGsVJ9sBdpqhbi/U6SbZo9ba8whxC9/9NdjZAAM5oV4081eBYlLVZMX5U6SADTrBRYPiMEwDHrXksnsKw7w/hmEmDq/AHAcoZ8fERalOQI5OIemvQOfneFsce1CzyFS+ACngHZfsXPjt8UkxdS9ZZNXKtwTNKY7q4t0MRUaOQz2S+JLeexYTjNsIvDtbrjxpWnmb76NJ6+X/kETmB6AeDhvaTs8Btsx1IqlINpbXIHOi3fZo45qh28hz+VlKfPefR6vSHwqWzvka+NAksdGTOq6v8e8eKlpIF+Dabw3wCDGf59FMVRWYPRthspvKcrZDkgW3JZZiph0VoIImusZmROIiA8O7o+3CFWAgUbVLWaw78Oamt3FqC
 EkEFdHus
 SYSACEt3d9W3uNJC4ZtBmoNLCDb1B4vp22wB2S+H8LNyTciLlrzGOCa3kWoeT2LUQL5+HP/oQmXUxfHeD7jVrS6GLqbTcduHu13mKCLu8MIY7htOfcO+dG109eFi1EtjpChl16SkJr7QmQonQbLdPY8/4HlxZW4+FDUQDxAvZTFbCNEZ7a9dILYbc8mOnck7Sb5HgktPkF0GDUAcUBUEKmr2na886TH5bxUg7bLTs2gKbAiII/Quy70U1khTKWDeW1EViO2OyBxHkAC1kW6GnqtQ+XkvoKZpQyOV6wjvEbRZL9u71G8ISgI00CGQI0S5/IWSHdtgc5pv1nCDaEQw2CwUzIe6nRsfUZPn9SJr4LwYQptw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 11:16:34AM +0530, Dev Jain wrote:
> Currently khugepaged does not collapse a region which does not have a
> single writable page. This is wasteful since non-writable VMAs mapped by
> the application won't benefit from THP collapse. Therefore, remove this
> restriction and allow khugepaged to collapse a VMA with arbitrary
> protections.
> 
> Along with this, currently MADV_COLLAPSE does not perform a collapse on a
> non-writable VMA, and this restriction is nowhere to be found on the
> manpage - the restriction itself sounds wrong to me since the user knows
> the protection of the memory it has mapped, so collapsing read-only
> memory via madvise() should be a choice of the user which shouldn't
> be overriden by the kernel.
> 
> On an arm64 machine, an average of 5% improvement is seen on some mmtests
> benchmarks, particularly hackbench, with a maximum improvement of 12%.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>

Reviewed-by: Kiryl Shutsemau <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

