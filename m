Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAA06CAC58E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 09:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 416158E0012; Mon, 15 Sep 2025 05:22:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C5EF8E0001; Mon, 15 Sep 2025 05:22:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28E4D8E0012; Mon, 15 Sep 2025 05:22:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0E6148E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 05:22:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A94135934F
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:22:57 +0000 (UTC)
X-FDA: 83890945194.03.13E4E48
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9CDD01C0004
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:22:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ddgSRp7M;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757928175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yFdBs8uVO1wgOJmBighvguMG/T/XzEB4WaqwzwckPBc=;
	b=yUBE9GyqFVUwPLi8j6v3EOcyh0ZbXbaQijGyWkIDsykc1Q847D35N7t2+QgeAvp9WfiW3M
	mEMCGwNkjkhRO//LcXu4LRNWj1TK2TabHTgYyGd4Y6ZjmuLI4ELN7cxnojcitrMiWTrfwY
	WQ4G9iJEPH0TKOkk5ssp1mM35TZbbGM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757928175; a=rsa-sha256;
	cv=none;
	b=quxXu0YbfDTWJg2WxF66rylGmuATpKQ4BGE0M+sAPMchjUAfdswngROqB7P82izVg83uO3
	uQQ6miXws641aErDYfltq7xkMqu59U+UqEAd5Ata2nY2mVJC7HKcxqp90rz3KGWfawNj6q
	d8GVanRygC+eqT1ihPqs9uegz8I7IAc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ddgSRp7M;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 83600601B4;
	Mon, 15 Sep 2025 09:22:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26423C4AF0B;
	Mon, 15 Sep 2025 09:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757928174;
	bh=FCX12NufR9hPAdv0bFmisNfhDgNG0TsC9/KUddJvsbE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ddgSRp7MYQO0PpKvVULa2Y7Ou8Joa17mmVxhWUcMVEDONwpA8MWRiT4Hu5UvXEcrM
	 6CeRaGFVa4NTj2lUUlocQshU8G3QuxvtRW/Dg++Rb20pRpJvplQCG2WyBXlsIP8Bll
	 ZN5EkQEpXyvr6lVHTMo9fWGvwM96xCRvFebVXCXJGfxYtXUXtUExCFFzHJJlFMB3k/
	 Gkq+g2/UbkB9WuoBab4Qs3a0h6oJeN4umrx1Sti+y0Z2fYYX9d6xhWsY2Cc4lCyQOo
	 T/oUKV2GUNiafRHnWNbiDXDVddmL8KboT7k1luCw7g2CK2DbQrUPhQLP85KCQIHCbZ
	 fAuOk95uYQakQ==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 13730F40066;
	Mon, 15 Sep 2025 05:22:52 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Mon, 15 Sep 2025 05:22:52 -0400
X-ME-Sender: <xms:69rHaBEX8--NaKtOgfLpSSuCjoFscA_2YIgMsHF3PGXj1EtIfRYaWw>
    <xme:69rHaDIYeI73CF1n7bboa4cVBQZbVHe1P3ojx3I6sHIjMNlMvzCaBhwDUFNUm4yaN
    tmmcjcYN4kziDFTCm4>
X-ME-Received: <xmr:69rHaFYX-ZyG29VFQwNq94hT6b5G8BzVzbLRmPu9xup814c3hZWTP0evMIcgEg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdefjeefvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtugfgjgestheksfdttddtjeenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepvddufeetkedvheektdefhfefjeeujeejtdejuedufefhveekkeeffeetvedvffek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepleekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehnphgrtghhvgesrhgvughhrghtrdgtohhmpdhrtghpthhtohepuggrvhhiugesrh
    gvughhrghtrdgtohhmpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhg
    pdhrtghpthhtoheplhhinhhugidqughotgesvhhgvghrrdhkvghrnhgvlhdrohhrghdprh
    gtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehlihhnuhigqdhtrhgrtggvqdhkvghrnhgvlhesvhhgvghrrdhkvghrnh
    gvlhdrohhrghdprhgtphhtthhopeiiihihsehnvhhiughirgdrtghomhdprhgtphhtthho
    pegsrgholhhinhdrfigrnhhgsehlihhnuhigrdgrlhhisggrsggrrdgtohhmpdhrtghpth
    htoheplhhorhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhm
X-ME-Proxy: <xmx:69rHaHM0oXzGFzFz42IznQZHvLOHMYiGmso2AUhXWSNDW_O5pFLnfw>
    <xmx:69rHaMfhqVLAknOGODhFLpQwFOo_AQMuJWX8dj6UvWfCONKobg_CPw>
    <xmx:69rHaHaTtizXT2uzWD6RFr1F4J5BVSYYgURP90lEWJl9LsVZMX_Abg>
    <xmx:69rHaKes1mC3bPXTYnlir4bDw_7k6oIQL1DTQwkJ2kH2EriG7CYw8A>
    <xmx:7NrHaDf4P7T48R-9rl0wnfVssBgbK2dhFa8Q6nKwUgx3ByHykSNyjkIe>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 Sep 2025 05:22:51 -0400 (EDT)
Date: Mon, 15 Sep 2025 10:22:48 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
 	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, 	ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com,
 	Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
 corbet@lwn.net, 	rostedt@goodmis.org, mhiramat@kernel.org,
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
Message-ID: <enrgrocqajwu5d3x34voghja7pbvau45oobxgabawrly44ld4u@ahch3xn6rtq5>
References: <20250912032810.197475-1-npache@redhat.com>
 <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
 <d0e81c75-ad63-4e37-9948-3ae89bc94334@redhat.com>
 <CAA1CXcA+pb5KvEnJJqdf1eSjaFiBZ82MRB+KDmyhj3DbiQqOxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA1CXcA+pb5KvEnJJqdf1eSjaFiBZ82MRB+KDmyhj3DbiQqOxg@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9CDD01C0004
X-Stat-Signature: a3jmnquuo9ct48wdyyqusohkb97cb9i5
X-Rspam-User: 
X-HE-Tag: 1757928175-727557
X-HE-Meta: U2FsdGVkX18kYfhzIHrLSha1Q1CYqPT2z6wqiBubcAdTH9j7ItVQbuGUg86n7bu8Ya6tgrFyXlyNO3rX2xzYx1t5359mGIJiHEbuVDPCn5GW5bST0ulUgOq2DcOHqXjf6sW+VpqLUzpWJVsX4WXuom9HSCcTp+tPoieeq2Rey1MIHo4Q1CI5Ox9J9okZqzCTpGb9BUxf0N7boLCKToPybXluBnhSWxAvup0xabegwPAj69dOa3whSpOsDgFskBQ86ysbhnQucD2DvcRPtp0lKidEettU0Mavp6S9uncnZSwjMerNj14Q+byI10SgmYQDJLYHLyQOrSNDy+qxhT26FET5RmTo/4P+M6hYyc0B+zPZDI0FPYnMwEyA1TqLCmdoj5xRhHBecchAV0wb1EFDM9Oj1CFoGF2dL6eOcBMgWok77Nwpvp6TueET4cCxcrtpZXOYNGOPsrByf8MC4UD5jZ+jnXfsEUdQmZTrz1yeNX5cJXBy/qMyU4Xzl5BwVmTBkv1LY8b5cwaqzftUsh5IP515FQeWm0edMZIAwI4dfl27n67wdBTruYsL0GQaP5l5X6XYhvJVvqr29njdP3vceZ5t/RaKi3EbI27O3r4dT3eqYKpo38Rf8cjRFtXAik/2L0g0bC2F8egIQREUsvzmPr7oztaEiR1apFuc8UGGJQxICGjckoQNyvH3gAPHZqfD0nvx4QxzYTku+E0tQzrJeu3WNNRLMZHm1zJbnvVRYYv8wlna9naD29MxE0YnjebJ4eujeNOQvJUVKcCbjhUNXExZYIw9Gf3xts5U8YRSvVBw0420L9vKyR4up2luUDeEElR9XevNrAPu4Z9kj+LjE18HEblAQDVrAcEFbuesZWxog0iVa7q2XK2NSbZznEMK1mhWGvHzp97H0niWEjhlvQGKjktrfb4RWLluundw8AyivMOY8SRPAE8RIkyvlR2yqtrj8ejjbtErLrsxnmd
 1ZvwtU1F
 y9W+c7o5avr3Vf9pWJH0ce9gXNlo5VjT2Yk8Iwfz9Sy4XyZehWNx79yZHIYlQMVVGqLhsBPJ38h2gwFLp6/02VK0yDf5IDWP8BkxhKbq2WfM3EcgOH1zuJqPw+ve6BQHzrMhoFIpOE5GqWzbD26SDTFyj2T42K8vh+Ygug22q/6/OOZEJhjodiESdFCCiVNKIjoR+C7nRqPrI5Exb1LrMyVbJ6cfChbzCYBCc2w5jgYKQX9CqRXdIqJWWwbMHdmJOcqRaPeYcNc614eoMfwLY3Np3ZxCgD7WrK57eIJjVUfFkCejLUMKmX69Ol0STl5zaE0PJWH07Levz8CT2EqQkf6VXiCBZTdPMLpI9rh/03rYD5Hq5Ylym2RHU18aKsU42Gu0S9LOhhYlzZxU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 05:31:51PM -0600, Nico Pache wrote:
> On Fri, Sep 12, 2025 at 6:25 AM David Hildenbrand <david@redhat.com> wrote:
> >
> > On 12.09.25 14:19, Kiryl Shutsemau wrote:
> > > On Thu, Sep 11, 2025 at 09:27:55PM -0600, Nico Pache wrote:
> > >> The following series provides khugepaged with the capability to collapse
> > >> anonymous memory regions to mTHPs.
> > >>
> > >> To achieve this we generalize the khugepaged functions to no longer depend
> > >> on PMD_ORDER. Then during the PMD scan, we use a bitmap to track individual
> > >> pages that are occupied (!none/zero). After the PMD scan is done, we do
> > >> binary recursion on the bitmap to find the optimal mTHP sizes for the PMD
> > >> range. The restriction on max_ptes_none is removed during the scan, to make
> > >> sure we account for the whole PMD range. When no mTHP size is enabled, the
> > >> legacy behavior of khugepaged is maintained. max_ptes_none will be scaled
> > >> by the attempted collapse order to determine how full a mTHP must be to be
> > >> eligible for the collapse to occur. If a mTHP collapse is attempted, but
> > >> contains swapped out, or shared pages, we don't perform the collapse. It is
> > >> now also possible to collapse to mTHPs without requiring the PMD THP size
> > >> to be enabled.
> > >>
> > >> When enabling (m)THP sizes, if max_ptes_none >= HPAGE_PMD_NR/2 (255 on
> > >> 4K page size), it will be automatically capped to HPAGE_PMD_NR/2 - 1 for
> > >> mTHP collapses to prevent collapse "creep" behavior. This prevents
> > >> constantly promoting mTHPs to the next available size, which would occur
> > >> because a collapse introduces more non-zero pages that would satisfy the
> > >> promotion condition on subsequent scans.
> > >
> > > Hm. Maybe instead of capping at HPAGE_PMD_NR/2 - 1 we can count
> > > all-zeros 4k as none_or_zero? It mirrors the logic of shrinker.
> > >
> >
> > I am all for not adding any more ugliness on top of all the ugliness we
> > added in the past.
> >
> > I will soon propose deprecating that parameter in favor of something
> > that makes a bit more sense.
> >
> > In essence, we'll likely have an "eagerness" parameter that ranges from
> > 0 to 10. 10 is essentially "always collapse" and 0 "never collapse if
> > not all is populated".
> Hi David,
> 
> Do you have any reason for 0-10, I'm guessing these will map to
> different max_ptes_none values.
> I suggest 0-5, mapping to 0,32,64,128,255,511

That's too x86-64 specific.

And the whole idea is not to map to directly, but give kernel wiggle
room to play.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

