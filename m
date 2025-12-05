Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55561D374A8
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 21:41:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF9356B02FB; Fri,  5 Dec 2025 16:41:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD0BA6B02FD; Fri,  5 Dec 2025 16:41:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E5B96B02FE; Fri,  5 Dec 2025 16:41:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D0E96B02FB
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 16:41:24 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4077EB82AA
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 21:41:24 +0000 (UTC)
X-FDA: 84186738888.20.B480AFF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 49A0AC000A
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 21:41:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="QZ/OnQgW";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764970882; a=rsa-sha256;
	cv=none;
	b=3J6LVM6iKLEhebSr7Ij4mXbTI44Zm5sI+I6lCqlGV8elGcPXkz1VFhC32os5sSH10jAilp
	Wqr3yhSG0tKP00ponX+I40fL4F6LKpzXHONQiU+IMCpFDPaPNO2Q/5zf6vDWPanzkopW83
	rL7lJZJzC/xFDSHvP2iTJdn6zn1Jgpo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="QZ/OnQgW";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764970882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k/6IUDXr0l/444lPGTDUY28Pwt8XKMMjlkfRt2VVQk4=;
	b=hlsmM4u/E0d+ONZaGkymBsl4Emvb0eIHmiADp+OHTzZ3IXb1WVrAMIy/g3VoQMQ6CkC2FC
	GCjAJQksvUi6sBoyTqWcBpuBaqu0PoYGrzbmtyO1T6XZDWiAY70I6QMDOICjf2jLylkhEL
	FbRlrs14w8q6vVd2rMHNrOE0zZ9fhuc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C39446014E;
	Fri,  5 Dec 2025 21:41:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F4AC4AF0B;
	Fri,  5 Dec 2025 21:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764970881;
	bh=p9bCuddlU0so7It/V5QQDTOU/BfpR+4mc0CoT4AQ0Co=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QZ/OnQgWxz4rZhoKIiOXM6gAGLyKmtTLN8rxbMat8nNydfGE69Xv0lT74fDUIHp6n
	 9/Q5wn674/he8Qoy0K3S5FrDWfqqBLUcqm7w5cMJa+bmMpPk+vytQ8qIE8awwdVLhw
	 piwJKhXi9LDPOw/Ymv+SfTm+VM2EqpiuVWwajGK5SkGvuQ3gazHEXqMRPTufpahNut
	 fv8FrUV++SdF1WqVieuaYTnVUB3+TrA91VWkm2eC86NQUST7chVxm0FY8P+qwyvm59
	 DtpQUTEZGJf2WSYV2IcMQENYgxx4Q3NiaKrCaNuWUivvH8VNN1Xa3StQ5p8s9UvlIH
	 ZPL/42p81xm1Q==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 01197F4006A;
	Fri,  5 Dec 2025 16:41:19 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 05 Dec 2025 16:41:20 -0500
X-ME-Sender: <xms:f1EzaT5rRXNgqUMFcaw3QYRZ1OFC7nl-N4Wa7IUDHJYYYzgRmrjQXA>
    <xme:f1EzafvCMLhDjA8lh2UZEARDP_LRYpapGQxsQF54Y2IIn0TnquFlL25OIBNdFHzc7
    gvcAZUtm-fBlfRYfDZUzn4QVsG69dcGQCrNlX2sVm_2nhzEbJoQg_o>
X-ME-Received: <xmr:f1EzaTYd4oIliimr1RVCDW_ctRR1Y2EYAY4_VXKC0GZByy5Fr2cDc0z-WWsaKA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdelgeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcuufhh
    uhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvghrnh
    epheeikeeuveduheevtddvffekhfeufefhvedtudehheektdfhtdehjeevleeuffegnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilh
    hlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheehqddv
    keeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrg
    hmvgdpnhgspghrtghpthhtohepfeeipdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopegrkhhpmheslhhinhhugi
    dqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepmhhutghhuhhnrdhsohhnghes
    lhhinhhugidruggvvhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorh
    hgpdhrtghpthhtohepohhsrghlvhgrughorhesshhushgvrdguvgdprhgtphhtthhopehr
    phhptheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtg
    iipdhrtghpthhtoheplhhorhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhm
    pdhrtghpthhtohepiihihiesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:f1EzaW-_TroeQG2jCbntYDB4kQeAA-gXyvY-PTpHFJMt4gAPVfve7w>
    <xmx:f1Ezaba_ie_pSiIElbmQzeYNWbepBm_k4E0xE3uIPC1RGazUeJXVVg>
    <xmx:f1EzacSMmrITBTwbaGBGYg2wFBh9PhiG2Al9qdJlpYqHfo1S60VR9w>
    <xmx:f1EzaSlEtq07IH2VoT5xhgysbfXKpQgVOLUMTtT1fQsv6gDGJsG8JA>
    <xmx:f1EzaQIkDa-O594T7dQhn-lf84kvTu4Iq5cCv0ucB_3tMm-rZpiCy9yi>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Dec 2025 16:41:19 -0500 (EST)
Date: Fri, 5 Dec 2025 21:41:18 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>, 
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, 
	Usama Arif <usamaarif642@gmail.com>, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 00/11] mm/hugetlb: Eliminate fake head pages from vmemmap
 optimization
Message-ID: <3v5hdubqnil6w54kimvbgapghj7irjp7xuqma6uxtsrpvj22ph@6t47vsevdwyi>
References: <20251205194351.1646318-1-kas@kernel.org>
 <e1c50f7e-cec4-4676-b5d6-f6446cd64ba5@kernel.org>
 <bdie34dgpltxd5ayvjvqkusx4thdrrebgllvwp333psfuu4vgj@bkfxg2c5sfr2>
 <01e5d0b3-dbf8-4f77-b38a-f48c46f7c31e@kernel.org>
 <ysvhofzg5mdtvxfujdsmffkuqna72pr52ehrpglmlhxnvwstas@xurgptkgtnbe>
 <1b659d59-b1c1-4910-baab-0eef7cda234f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b659d59-b1c1-4910-baab-0eef7cda234f@kernel.org>
X-Stat-Signature: 3basbusndny4ea6dx16or1jq8xa9y7wu
X-Rspam-User: 
X-Rspamd-Queue-Id: 49A0AC000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1764970882-822961
X-HE-Meta: U2FsdGVkX19TfPlPiy8iCnA+rNOW30xtOPkNFDTYDMRCd6hlGOAxFb0TfYnFJw1U8CoLVcJqqR+H9qK93wHq6TalA8cloQXBxOG3yDK0BaVHxLpssHCv4Cd5A1nRc95w/0AYSGKW2BtMFxSDUi7+/NBl4HwPCCuTbuprj9QCznN92c2CEUn2vAwr1kG/meD1P1z6/6KEhkdUfxcbZHuSUHhO1Io9AVtc4aWECynjDGEhy+0PIxiQKTevbP0IILKY8aiVrdVciSrXKpuq8ba+KhN/Bc8in3Ob1lwTnDyhoHxmWwdjLXLJ70U4EwXULOmO4U+F1IvVUHwZHT9cr5b2J1XBsQJV4qFJ/cTplf1360xW75f/0rqzzsR3hNeadsZy5evV+JiyJCgppxN3eiLQT+Mri7e66uhB1vetrOC8orNIbH7Yngf8hQkS+C3XPDysjGpE7zSsBHzz4ueGDjT6hIqpPFTPnzEnrCYqDNTDd1AFBsNBCUSjQEYEziCfwSmVfH5287bSdtQNLFei3LD6stQ9pvC4g6ck201R5KNmpgW5Ak3ykDZTJkZLFRchrqbWMGBIyQnNdoNlpnapIMkhu8UJnIcukAdHFGNYltIuMkW0FGcq/FGJ1DT0r3DYhMg4ymvVAPIyaNSkhUk8Eg1ZyV0ZbaTB8ZhAf+sQCVHI3qY1t57zKngmzw2tN2c+vwXLsZeup6kXqTuQHi8J7uGvPCdP+huB2tWDaJJfndDdstcdldwc7wpUHB9UF3nrU1089JxONBtWT56eSRgyiXP2QnJSIqZE0LkB/XF8kvoG5wd62MtUlUDW9xK0cteyKhxP6ebXb4JpyLugprUYllM9+d/D4ehvAFARfe51Hn0Nsvm7TsnXwthT+fVVdudaxDAzoyoWp7g/z0ivCGk8kntSwv9l3QeiusRUPxXS1B4Yovqq9XEB09h48Bvafia0OtgQ56s4Q1cwNOjd5sWK++i
 OAvwO87u
 IBw1+kjvQbcFZnBWahHXeThuEmIc7V/maAU+pCGjO4v67XJzDFaBKYuj3ZThg0VgvJDqm2u8HzhvRnKzJ3yWfRVP8v1G93WY9JerbjpM7GNHawC2clxdoGGnbxVpQN3SzswGZMyFUBDYU30NBrJ2+WI6AE3h75yTiAPWLyc0sNbh3h+g0CPvMzcT86ahjYfhbi53qKiepL/T43qf5bjGiZ7nfe7wm0g/RIaTmEgabjQBxbwrqJUDZPxhDH8tWQZ500G7+4bMKo8g3kytniYecR8yOyQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 05, 2025 at 10:34:48PM +0100, David Hildenbrand (Red Hat) wrote:
> On 12/5/25 21:54, Kiryl Shutsemau wrote:
> > On Fri, Dec 05, 2025 at 09:44:30PM +0100, David Hildenbrand (Red Hat) wrote:
> > > On 12/5/25 21:33, Kiryl Shutsemau wrote:
> > > > On Fri, Dec 05, 2025 at 09:16:08PM +0100, David Hildenbrand (Red Hat) wrote:
> > > > > On 12/5/25 20:43, Kiryl Shutsemau wrote:
> > > > > > This series removes "fake head pages" from the HugeTLB vmemmap
> > > > > > optimization (HVO) by changing how tail pages encode their relationship
> > > > > > to the head page.
> > > > > > 
> > > > > > It simplifies compound_head() and page_ref_add_unless(). Both are in the
> > > > > > hot path.
> > > > > > 
> > > > > > Background
> > > > > > ==========
> > > > > > 
> > > > > > HVO reduces memory overhead by freeing vmemmap pages for HugeTLB pages
> > > > > > and remapping the freed virtual addresses to a single physical page.
> > > > > > Previously, all tail page vmemmap entries were remapped to the first
> > > > > > vmemmap page (containing the head struct page), creating "fake heads" -
> > > > > > tail pages that appear to have PG_head set when accessed through the
> > > > > > deduplicated vmemmap.
> > > > > > 
> > > > > > This required special handling in compound_head() to detect and work
> > > > > > around fake heads, adding complexity and overhead to a very hot path.
> > > > > > 
> > > > > > New Approach
> > > > > > ============
> > > > > > 
> > > > > > For architectures/configs where sizeof(struct page) is a power of 2 (the
> > > > > > common case), this series changes how position of the head page is encoded
> > > > > > in the tail pages.
> > > > > > 
> > > > > > Instead of storing a pointer to the head page, the ->compound_info
> > > > > > (renamed from ->compound_head) now stores a mask.
> > > > > 
> > > > > (we're in the merge window)
> > > > > 
> > > > > That doesn't seem to be suitable for the memdesc plans, where we want all
> > > > > tail pages do directly point at the allocated memdesc (e.g., struct folio),
> > > > > no?
> > > > 
> > > > Sure. My understanding is that it is going to eliminate a need in
> > > > compound_head() completely. I don't see the conflict so far.
> > > 
> > > Right. All compound_head pointers will point at the allocated memdesc.
> > > 
> > > Would we still have to detect fake head pages though (at least for some
> > > transition period)?
> > 
> > If we need to detect if the memdesc is tail it should be as trivial as
> > comparing the given memdesc to the memdesc - 1. If they match, you are
> > looking at the tail.
> 
> How could you assume memdesc - 1 exists without performing other checks?

Map zero page in front of every discontinuous vmemmap region :P

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

