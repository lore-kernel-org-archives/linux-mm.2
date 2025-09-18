Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83C9ECAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 16:33:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA5618E0130; Thu, 18 Sep 2025 12:33:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7D0B8E00F6; Thu, 18 Sep 2025 12:33:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB9A28E0130; Thu, 18 Sep 2025 12:33:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B6BF98E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 12:33:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 60D8613A574
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 16:33:01 +0000 (UTC)
X-FDA: 83902915362.12.020E4D1
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by imf24.hostedemail.com (Postfix) with ESMTP id 53376180011
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 16:32:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=lunn.ch header.s=20171124 header.b=KoLiEW3a;
	spf=pass (imf24.hostedemail.com: domain of andrew@lunn.ch designates 156.67.10.101 as permitted sender) smtp.mailfrom=andrew@lunn.ch;
	dmarc=pass (policy=none) header.from=lunn.ch
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758213179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ks/Dt/gG06zpcviyC2RmuMfALb4spkC/mj20Xhc7U4=;
	b=1S2MYuhAFPuY+Jclz/AdC84U/oA/GGl4rUMWPSWnlPDY0aCAVxMMttyjwJOYvoQHUVmnrJ
	jB1/yA+VfWlVf1CuhMTy67x5PhNIkO/hHGM64a6NeLdv6YbgB9dcukacwVKO0l4j105cix
	iE0wcmchvb/0V6jmwYlf7fzQGs81zlw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=lunn.ch header.s=20171124 header.b=KoLiEW3a;
	spf=pass (imf24.hostedemail.com: domain of andrew@lunn.ch designates 156.67.10.101 as permitted sender) smtp.mailfrom=andrew@lunn.ch;
	dmarc=pass (policy=none) header.from=lunn.ch
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758213179; a=rsa-sha256;
	cv=none;
	b=UJTwXeM4s6vbSieZm51h2OOc0tNVMDK5TEULUUPVyNCS808Q3TB+FMyFVc3tk06FwG2gLK
	w8aR810gMWFRnP3h24wYM0gFFYg/+QM8qI+buJ8ZUn1yF1FqdX1C5jtI4GaMY9L7NhlYZg
	uZ12UEKcGdYwLUy790MGuskf1iPAvtM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=0ks/Dt/gG06zpcviyC2RmuMfALb4spkC/mj20Xhc7U4=; b=KoLiEW3a+FctGMCYTji6G0piKX
	6+2sXpnGjpyCiB9GZ1aJLpE4MPYaT4SHrv8fw7rBSREmCDqF4nuUIBFZIIYmv+i3ReGtxZ8MGrp+s
	j+YRd0HmYRcGKfIR/k6IHWq3t+jxGCnOm+ADllcYsPkFk37j3Kv81W5EGdi5YRAO43vk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1uzHYr-008qze-89; Thu, 18 Sep 2025 18:32:45 +0200
Date: Thu, 18 Sep 2025 18:32:45 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>, ksummit@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org,
	linux-mm@kvack.org, imx@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Richard Weinberger <richard@nod.at>,
	Lucas Stach <l.stach@pengutronix.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Ankur Arora <ankur.a.arora@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Ira Weiny <ira.weiny@intel.com>, Nishanth Menon <nm@ti.com>,
	Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	"Chester A. Unal" <chester.a.unal@arinc9.com>,
	Sergio Paracuellos <sergio.paracuellos@gmail.com>,
	Andreas Larsson <andreas@gaisler.com>
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
Message-ID: <f4154621-be77-4c08-89d4-ab931ac3df30@lunn.ch>
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
 <20250917125951.GA1390993@nvidia.com>
 <02b0f383-1c43-4eeb-a76f-830c2970b833@app.fastmail.com>
 <ca6fc8dc-d1ee-41a8-a1c9-11ed2907207f@lunn.ch>
 <ea6562f4-ec8c-4e99-98ec-000c25c34a3e@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea6562f4-ec8c-4e99-98ec-000c25c34a3e@app.fastmail.com>
X-Rspamd-Queue-Id: 53376180011
X-Stat-Signature: bnr4cjahjeqq99fp3qanu9tqzzffqt3n
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758213179-211933
X-HE-Meta: U2FsdGVkX1+jJbnKV4VCv8M1YyXZa/pWR/5MqgSsBpoXvtqGl1XbEhXla0Rr4uEJB1U2ubCLqqKM7uFpjwwXKtxalgMXggOc4TOsqbG3Vfxfu0W9QR4JyWuGnh9IN32IGQX/WSMjul09jifClPBXBNHYjmc1z3zhi4iLu3W6XHwcd1jq7nzislczsXIgUGN3D00t4Nhe/0M27rTSklXeMBqgCLzVpiUN68uYaJt2Eh4zmlRQryD6/6OCHqJd/rV0mptzuFoGmLHif3lQNB6McFzzqr7Mbyn4l1AMBU+wOrNh0egpZfT17KJ3dhX9uil7arjiPbJSaT11OXlDrOMkJWromfhomZ/vkTXSyL4FwWKUJTY7gfN0kykrolmmF1jrWC2dskHF4Itr2ipK5xXPibYL14iF+SVFxGsFfMB/tNS9xyS3r/IUUJDmgIk8uLkzdj9ikfNjUmqKg9Fbkr9WJrbFhjgqkTD8/ctg2TaefU5sGGFuq0VDGJtP0kg0B8e4tVsPpbuy/ZD0ZJhCwcD0Wk0rNSI4PFXX979Fo1a84u8LNxT0hXrnvflK49esLfaWs1KIwhGhe2wgf/5klG7czstYAQQC+yMiq553JyFwBR0BVdMB6NWhrLa4MEAq+reKGqCfw9zNFnyPyGcmJ+iABlHQgtwAszWeIWuNL6puWJnnezR6ewaqtHXqgC7QKLGR49Yo02e1Xx1M4HeitfSyrAZkUOcZXLscP53Aify+ZDtlP73+Aqypmwra3pGpS9l57pui+WVsz43mqsMDEFeN5pbB5xsbnxS5f2Se3mYLpe1g5bOLgJBkZrlTTKSrGQaZ/LjwKrKWtEfXT4tkoKHC0b7wcFOPUUb0S5jOJ4SCaT9c6Ss+d/ytO+dwsCXdRiBu99OaOily+qreG+fRg9C5S0HVnabELEnUIiw85WrcisCZKmtGuQOMKVomoy2n2TGG6fWEKCLDw0bv0LLXhfS
 RsJgXAwE
 SYkGr8hrIEblNp2TNoujABE6M7/YnvfmdeXErsssibQgJbxponfVvrGFnza+yK6cLPZiwC2CGwnamHa2C+usOSC9SL8if+jNyFOFAhcd7Cw/wyoF/wGM1OmN+MzTUcOh7sdXmkU7VjV4PMWyy/nDp7GcAseI2mwy01gjbRJie1bLTP/HpNNwt1kS1Pw87J+GD30h/hSQ17e/rfywvzEhqqLD+pZ1NZMEXQWvqkyUAqUQfCXvfTwtXpV6c2OOV61yORf7mupEZEzvWdukaFD9KHIu8vpFVYskwKt/qCBrHoUTBUZtaIzLYKEdW0IGI/9dgzf6ZBSjstft0Psg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Do you know of any kirkwood machines beside the OpenBlocks A7
> that have more than 512MB of RAM?

No.

	Andrew

