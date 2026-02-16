Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34B80E7BD91
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 11:30:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EF146B0005; Mon, 16 Feb 2026 06:30:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C7A56B0088; Mon, 16 Feb 2026 06:30:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FE136B0089; Mon, 16 Feb 2026 06:30:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2DE886B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 06:30:27 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D03E2160C7D
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 11:30:26 +0000 (UTC)
X-FDA: 84450101652.10.7EFEC53
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id D2D772000D
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 11:30:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QWiceWhk;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771241424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ksD6pVfcnC/aM9tuqF9KyWpzF/TzEHbqPcpybabuMU=;
	b=55/rCEeHIcKRrC66g4o3QJ1WxT+UALqiPUsIVFMrBfMOhfce9IP8Va7DCilkAiLwnNxCCx
	HVAmsvwe7I/KtzADt0SxNj6zbc5b/L589HzCa1VgSGI70eSVtFFPWNJ3EeGM+GVNxszskZ
	qu6wg+Fd5p5zw8OuaqTIBMc4m2I7IzM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QWiceWhk;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771241424; a=rsa-sha256;
	cv=none;
	b=6LXJYTwklePEVA2gzfD7etzn2oP/nlLFXOTowkG2S81C9DwCBzgPccGSbr3zMabSa6YfLq
	E3yBbfuT4Juz8bQmjN75Snjt4F4gKvoQAXbwQAYUYm5yEVRvUonmrlFbtmik4W1WAwVEac
	/8kX3igZAW8Vf5Hh72+MjEG6Yx7KejI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1ACE8600C4;
	Mon, 16 Feb 2026 11:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A66FC19423;
	Mon, 16 Feb 2026 11:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771241423;
	bh=KFgAyA/laS4/MU7pCChfZBh0Hjfg1QRQ88qFNdP1x20=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QWiceWhkirDnroa2amGc7Yzcuqe5G8ZzuTAhP4Vi2rX9YaCZJRFkQEv1BUtrcTxme
	 CoTj9P4GePUXa+2Wik7u0Wa9Lh6eiWEnP85WL5vkfkwuTCedCzTsZIF7r86yv3rmN8
	 EB3pDibfGA3+kpFRt/kznLXW1GxPgr9DifC2KrGsvT6tFlNTTQA5FjR+5Fu0n4QbjA
	 oZuG7n1Usbb9IuvLtGMS7n7BRFUGm4ngi6H4saX9JqxL4vwB6mZIK7FcyjoXUhHmT4
	 ES6C+lZbk7cW84yPq72i7mDl9/00ThL3LQotaKdFI0i4HvL+d1sbmmGneJO0Ny4gR/
	 cLQC7uOK+Iz6Q==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 18EFFF4006D;
	Mon, 16 Feb 2026 06:30:22 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 16 Feb 2026 06:30:22 -0500
X-ME-Sender: <xms:zv-SafP6SdpwtyKrIy61_w1L6KRCDqa3wojRXdKE-WnfoRqegezjLg>
    <xme:zv-SaTo5THFs5nSUYFTs8rKGfx5IX0WsRqgOhoR-nGDQS3gxV9h-ysxYRQmfQbZRU
    rbR0SvvqJ50mFzQq0muRybdErIXOO4O9sBw69GMNxjx7zvk7ro2CZw>
X-ME-Received: <xmr:zv-SaVNZz4F9fftM3y5usJj4f403Eg3OPTylNcGpQErHuIZy8W7ryInBHKOaaw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvudeijeeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepheegpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehvsggrsghkrgesshhushgvrdgtiidprhgtphhtthhopegurghvihgusehkvghrnh
    gvlhdrohhrghdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhn
    rdhorhhgpdhrtghpthhtohepmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprh
    gtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepuhhs
    rghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhrtghpthhtohepfhhvughlsehgoh
    hoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrgguohhrsehsuhhsvgdruggvpdhr
    tghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:zv-SaXy3RYYkVrgjT2ePItIoI7nROGRlXkxJI-DmcNGsMg3Ks4NSYw>
    <xmx:zv-SaW0PCwprxWMPv1amXkIEXGoFlPtc4-K63ZVJwbuAOtiDic-kqg>
    <xmx:zv-SaeTXFVwr2DgeActR2sgR2pncUgpqpAePUJrhigvtC8oLr0r4pw>
    <xmx:zv-SafeawC4-UkIKrewg6FMu9XD5_XA_EuL2IW4uShBV2qn_vICcnQ>
    <xmx:zv-SaSvdYc1ErSSH4ujiq4HdlsAPlErFh89bDsMP690zvTe17atmywkM>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Feb 2026 06:30:20 -0500 (EST)
Date: Mon, 16 Feb 2026 11:30:13 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>, 
	Frank van der Linden <fvdl@google.com>, Oscar Salvador <osalvador@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
Subject: Re: [PATCHv6 08/17] mm: Make page_zonenum() use head page
Message-ID: <aZL-7mpPT_S3Paon@thinkstation>
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-9-kas@kernel.org>
 <e5831f0b-88c5-4a20-82b3-6e5952388132@kernel.org>
 <aYnJCnE5vooLROnu@thinkstation>
 <6afd7334-82e8-4f87-8ed3-6448e89328c2@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6afd7334-82e8-4f87-8ed3-6448e89328c2@suse.cz>
X-Rspamd-Server: rspam12
X-Stat-Signature: zytsafyk7ce88dai369xger8dc6kx98d
X-Rspamd-Queue-Id: D2D772000D
X-Rspam-User: 
X-HE-Tag: 1771241424-945483
X-HE-Meta: U2FsdGVkX1/sjyIY0eDDjgnGyL17DAAZ3TF9Tkh49ockrlEM2ntDjKGJkdpWBtNV26bDlsF/mRLv4/xH0T8x0DEeFzC03HLDdKH80chCQ/XfM6KPXPfaRFp+cv6fvW8Y+E57HLjMh2dJ6JIZGr9kHkM6SyJi6XJEMfZgP1N1Zw4GtAVXJBn6m/sCnLtLVrjre06oEPSeCgw2bS9BdpGwoj4z2cGRM0SMMMfJ79+3OIu5kJHe8s4qp20pxWp8947wx5x9b+LjkkfPgWlC4vUlmHgbbQarnoE/+FrzJFVrEfcDZ7X3/PwJtHIjztdoDrSJJXTuBzsUc7sBaOeygxUWEJ6mTNYDmEYxCesGx9+yusf3ti+XpoznJPD1dPVuRfJpK0V4J78mhxJiM1l0n71jTe8SD7pv6h+mF/qrxBQC8l4Ury6zCeCZAC2/JvQNk2kZmQ8U1sXy7cXneIoPFGP1YvmxeVdBoWVbDINZv1OxCt3zagFxj8lYUw2GGte895HMyyFf50aL5rQlUikCvz3mV+V5PAuaoZAQ13247NVD5+e1pcaEupczk+jtFW5bOFrUcNeEaG+CBznRmZFmpMOJUkg0KcD8nhAfBFX+Ug3f8rr+XRqOUmP3ISOltRJnkVx+5B4g9fm3nxs3erdSXJyrdLF7EeWAEeC6O38q/lgDIF2sBplwXNNPcbhn+8dMxmuURWm+AIYyuc/D5Sd8UY+pxZ52oyFvy5eue65XlpwK9dbLkxkL5bBNU0C0pgqKvmkQ+0cY7yl+rHtS7Z2CIssDyJ5is8oAX6bC7/TXB4j23eGGCTb0sKBxS/+Z+iAJIMV1lReAOCgVOF+CzwN/fdE++h8FWph4kVC3jx8cWE7/4xX8hrNLkuO573S0cheMCQjsQi4oKore/+KqoUjOo5WT7i6q8vhY1M0IPnqSB/MIiFTwwo4p80xP1wQJno8IwkEwJrCbbJ9sPtQtA8DmGF/
 99aBxqgT
 SEVRwkd+qcpvbe7W5TFvk+7idDgkfiIIhcdzeGaGJ9sQg8pth0/f7rKh8nFfKCoisg6PIBfavj1b6zMDaBGHA3/F5nY4iXqR66xrJ3ENwuTF+V9+BGRuor+NKdfN10fKlXdppUl9+3IUojYZdVfAJQ2zziGVe0lEh5VHvTGEcasvDpP8tZbxT3qstCa9/rSZ1VOC2Q0lQnZ8xHgYFWO0U9bzpt4VsnQXhsI2uq6vCmmNoc0APH0TIPAL6JlQIZhEycy07mkUz8Mj2GBl0FdemzP4Pyv+0N7vgbkDOUUHPXHgg267cXR99oxOWxhVGGtVu95uEOgDY9PVq2GvFSfPMXesUcNr3SsVD+8jsabyiNEyTvdKZ9H7cBZF57g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10, 2026 at 04:57:55PM +0100, Vlastimil Babka wrote:
> On 2/9/26 12:52, Kiryl Shutsemau wrote:
> > On Thu, Feb 05, 2026 at 02:10:40PM +0100, David Hildenbrand (Arm) wrote:
> >> On 2/2/26 16:56, Kiryl Shutsemau wrote:
> >> > With the upcoming changes to HVO, a single page of tail struct pages
> >> > will be shared across all huge pages of the same order on a node. Since
> >> > huge pages on the same node may belong to different zones, the zone
> >> > information stored in shared tail page flags would be incorrect.
> >> > 
> >> > Always fetch zone information from the head page, which has unique and
> >> > correct zone flags for each compound page.
> >> > 
> >> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> >> > Acked-by: Zi Yan <ziy@nvidia.com>
> >> > ---
> >> >   include/linux/mmzone.h | 1 +
> >> >   1 file changed, 1 insertion(+)
> >> > 
> >> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> >> > index be8ce40b5638..192143b5cdc0 100644
> >> > --- a/include/linux/mmzone.h
> >> > +++ b/include/linux/mmzone.h
> >> > @@ -1219,6 +1219,7 @@ static inline enum zone_type memdesc_zonenum(memdesc_flags_t flags)
> >> >   static inline enum zone_type page_zonenum(const struct page *page)
> >> >   {
> >> > +	page = compound_head(page);
> >> >   	return memdesc_zonenum(page->flags);
> >> 
> >> We end up calling page_zonenum() without holding a reference.
> >> 
> >> Given that _compound_head() does a READ_ONCE(), this should work even if we
> >> see concurrent page freeing etc.
> >> 
> >> However, this change implies that we now perform a compound page lookup for
> >> every PageHighMem() [meh], page_zone() [quite some users in the buddy,
> >> including for pageblock access and page freeing].
> >> 
> >> That's a nasty compromise for making HVO better? :)
> >> 
> >> We should likely limit that special casing to kernels that really rquire it
> >> (HVO).
> > 
> > I will add compound_info_has_mask() check.
> 
> Not thrilled by this indeed. Would it be a problem to have the shared tail
> pages per node+zone instead of just per node?

I thought it would be overkill. It likely is going to be unused for most
nodes. But sure, move it to per-zone.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

