Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ABAFCA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 15:44:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0534C6B00AF; Fri, 12 Sep 2025 11:44:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 002676B00B0; Fri, 12 Sep 2025 11:44:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE68E6B00B3; Fri, 12 Sep 2025 11:44:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C9E726B00AF
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:44:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7EBB71A08B9
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:44:26 +0000 (UTC)
X-FDA: 83881020132.01.65FB137
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6528D1C0007
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:44:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="JZb7/Ffl";
	spf=pass (imf20.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757691864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7exun9y5Z7TRyYQteAwiitGs+bF6xX3OcOLXnhe7vE0=;
	b=WoIUFdin7FiTAyAB55k/QuFryofRfh4Wz6FK/MiKwRwdGjVElhtOe9SaoKHjQArUPTKwWd
	/i+hUvHncB6pNNTWAJH261vV16JWDtnARRGGK/ZYhQ+pyULvLU0yYXnYj18yi5izmBTsjJ
	PkF/6oGQW0CNmkRp1EZwXr3kHCIlTSs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="JZb7/Ffl";
	spf=pass (imf20.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757691864; a=rsa-sha256;
	cv=none;
	b=yRSywbibA8ZpyqxJO1fJOLspuivG8sZTG1ypz/Bsk/JC9c3WPf/fnvx8kFpGKXcfNr9OZX
	0xZt3I58BxQnMVI/b7JhM4aMk0DsECrJwOmH/R7uBVqDg3feLd6ZsFoit4p9B27kd7WjyL
	E1GeRIdX/630uQ9ZWHTSNG+oxkjAXuk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3EF2B45179;
	Fri, 12 Sep 2025 15:44:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A148C4CEF4;
	Fri, 12 Sep 2025 15:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757691863;
	bh=kpVYj7WUHWfm+jnW6bApk8xbRCU272PKzrnqUyqiGjE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JZb7/Ffllikt1PXlZ4utdqkFTqhzSxJ5t3jjKXQPzjS6QCKL3ZeYIUb0qIELhKAA5
	 5hybKO1qwzk2htug/5MY/L+aEf4Ez6KNb9p7NeHUxVC6hxfUxXi3vCzzOzSLH0C00G
	 239Edai8GH+VbnsmgHWnHsGW8pS9ESiwU3cJEba+vgBj+N1zRV8aEU1vWMStYvoshh
	 5kmkF+q3sIgQsQhnYtdR8JfZwRMOEUDIL/4c8JsbHZwjVxcU0pHAMN0V3J9qMh1rJ6
	 DTF4ed9NcpU6eYdNqF+3nnu+dG4y3Bhh76nYrwp2HbR3Q4Yvn5w/SaXWneo/yDxCqC
	 EUI4teo+YWajA==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id A9237F40066;
	Fri, 12 Sep 2025 11:44:20 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 12 Sep 2025 11:44:20 -0400
X-ME-Sender: <xms:1D_EaGsWdRp8F2mVm6-IDKfSFB5-M77EMj4jXSx81KrLf9NRyNvxmw>
    <xme:1D_EaIStNObfpHQ21qmqZHb_7SDbSk7iv-3_vQvA5woaku-3eV5qO-YwmiydSw0xI
    qfYK4r_F0OHV6txsq8>
X-ME-Received: <xmr:1D_EaEBXBCr6dqXqn_-3KAeNQ6mzJf30RPAeY9ttbW1bG5HuePVKwFjrgjqd7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvleeggecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeehieekueevudehvedtvdffkefhueefhfevtdduheehkedthfdtheejveelueffgeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopeelkedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepphhfrghltggrthhosehsuhhsvgdruggvpdhrtghpthhtohepuggrvhhiugesrhgvug
    hhrghtrdgtohhmpdhrtghpthhtohephhgrnhhnvghssegtmhhpgigthhhgrdhorhhgpdhr
    tghpthhtohepnhhprggthhgvsehrvgguhhgrthdrtghomhdprhgtphhtthhopehlihhnuh
    igqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhopehlihhnuhigqdguohgtsehvghgv
    rhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvgh
    gvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqthhrrggtvgdqkhgv
    rhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepiihihiesnhhvih
    guihgrrdgtohhm
X-ME-Proxy: <xmx:1D_EaBWnj324dLTo8bCSbIZLTbHfiqWiI4VScbBxm134V47WNLcrHA>
    <xmx:1D_EaME8hhyGlnR9VQGNhVof7qnANEr9X7-uIjIsAUeYZbnU8ELefw>
    <xmx:1D_EaOjrvcP-XNRIvuq0ERhwqIC43EqDXUxoY7x4Irxu4J4iSFNEFg>
    <xmx:1D_EaDHBha3yZ9jrV0t5GvDpnySHp8c1Pga83bdlxixzD5-j2B6oNg>
    <xmx:1D_EaPmyd0IDEoFruMoEWLoJfqlGsi9WDWcu7SnNijalaLzDLKxCPS9y>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 12 Sep 2025 11:44:19 -0400 (EDT)
Date: Fri, 12 Sep 2025 16:44:17 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@redhat.com>,
 	Johannes Weiner <hannes@cmpxchg.org>, Nico Pache <npache@redhat.com>,
 linux-mm@kvack.org, 	linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
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
 rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org,
 	hughd@google.com, richard.weiyang@gmail.com, lance.yang@linux.dev,
 vbabka@suse.cz, 	rppt@kernel.org, jannh@google.com
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
Message-ID: <y6ljs2byyzxkxqqxaf37kx5lqpshv47ndejksen2ihrvhcwksc@4r6f4sdtjd3g>
References: <20250912032810.197475-1-npache@redhat.com>
 <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
 <d0e81c75-ad63-4e37-9948-3ae89bc94334@redhat.com>
 <20250912133701.GA802874@cmpxchg.org>
 <da251159-b39f-467b-a4e3-676aa761c0e8@redhat.com>
 <hcpxpo3xpqcppxlxhmyxkqkqnu4syohhkt5oeyh7qse7kvuwiw@qbhiubf2ubtm>
 <k54teuep6r63gbgivpka32tk47zvzmy5thik2mekl5xpycvead@fth2lv4kuicg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <k54teuep6r63gbgivpka32tk47zvzmy5thik2mekl5xpycvead@fth2lv4kuicg>
X-Stat-Signature: t1y6ketpbrpojbhmkdj6t6b8m8rq8k1a
X-Rspam-User: 
X-Rspamd-Queue-Id: 6528D1C0007
X-Rspamd-Server: rspam04
X-HE-Tag: 1757691864-846839
X-HE-Meta: U2FsdGVkX1+D9Ui4pE5KFmb8QAM8r3wh7u5WvpF2NlF1p0vcGFRyI6uSSB1CRcmcqDXA9Bran39uh63vUSD0LwcYMkoxqpX2S0Z/gVxM4xbm4Jzs5B57BQOyisX7XuUlg5yio4l7KuljdTvCj8r0DvPM/6jHrtj52H4a100dRxYeiYn2Apmviq62eIeX1wRze7ubCwRGFPDbWictDR08k0VUpVAAwTO+kgz2+/od0f49XPvnbOaFSqLWRfj3Yv2ak039z9v822AaEmBT1KmGrNKSZ4tY6HBQUtWsBNvVQ2cRav9zbyp3P59TT6bWRuMOgcTxC1TiVdYW/Y4tq0/CHpjdVqF2H3rP7cJW2oodWJsFeW1H7nN7OIdT0S7+tVfDzDeqDNbQ0+7HSh4gehcne43SMsKLvko08lfwcZehT/4R2xGYQhjqAlMbo+6XFjiJ+qPwlMe1iSUsu/SKBaVS+82l4C4mmJu1ag8YsXap2sv9Rj4ZzUsLAbBp7sZVtSWJ4gMzguPMoo7HUx7mEcDB/HVI9oX3tC4lcT/e6TwONGdyrS/5kYNOR2zWFNxSs6SOoX4EBrtIBOrkM51fQVKpS2zFZEtvt5UhATtaAsJDrtUDWJRCO6uL2Ffyz7Zh4t/WfljJKsPo9daEkxYLIp5AWSGki3PjDTyhagBe7CIPdnxlwRA7IidDOxiQg7tiSmf0xZ/DFSdWAyjanrw2RX+9BU3xIUCIe0+D/qh37wU7CgvbMmFd54HDjaQQrwbwXv9yVumLiDxuUtn4MsHbM41zcEp2cKnLHfnfIWHMtHQclxytgDq9gR7waR111TcMkzjvZbeQmDu41/qB/7c72AvEvrTYYSDUFJnmJekruUAYzx1N92O5LJKQRr2W2FHE4Wt/zc6Kkc7/bWwbmYXfRmvLsGuzpW5WYwYwO66GgsTeA6qs9dm3ZkqKgAflTL25aPFBEgFnNWeg41brRKMBPyt
 O6V5Ka5s
 E3t4e0+0m3eM3T+opMXJsA+J4WS8kjiPl92k2IotRrfMZTrF/4lAMFrsIdY7PpW+VAJJPuJWMN0iDfSN8Nst0L6hF9ehMZ5x23u0+odi0iI5jDJFvlSsFypcirZOsIFnGY/OK+7h/90dBDD4GLgdGpA+mlhtnSNzkqwCiZR1yFYDTo7g4WKjG77gdepoEMFqVI53dcFOzkIPj+Jat6NqIurcsSsZavoFQtqdMrSpQZDkYU8iUElG9HI8qTvO1M92eUtE5/H+En/uqHbfgH92ymRC+WPT5ZmwrVN8X71qeTlrxpT15offBCOXkkGCAR/7jsjqIAjA09B3qEZI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 04:39:02PM +0100, Kiryl Shutsemau wrote:
> > Shower thought: it might be in these cases especially where the FreeBSD
> > reservation system comes in handy - best effort allocating a THP, but not
> > actually mapping it as such until you really _know_ it is hot - and until
> > then, memory reclaim can just break your THP down if it really needs to.
> 
> This is just silly. All downsides without benefit until maybe later. And
> for short-lived processes the "later" never comes.

The right way out is to get better info on access pattern from hardware.
For instance, if we move access bit out of page table entry and make it
independent of the actually mapping size that would give us much better
view on what actually is going on.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

