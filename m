Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DA06606A322
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 06:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.a=rsa-sha256 header.s=alien8 header.b=JHF72/UU
Received: by kanga.kvack.org (Postfix)
	id 846ED6B00EF; Mon,  9 Nov 2026 01:36:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F7F76B05B0; Mon,  9 Nov 2026 01:36:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BF606B05B1; Mon,  9 Nov 2026 01:36:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3E4C56B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 01:36:52 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CFBFFA05EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 06:36:51 +0000 (UTC)
X-FDA: 85414622622.04.B73CFB2
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf06.hostedemail.com (Postfix) with ESMTP id B682D180002
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 06:36:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b="JHF72/UU";
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf06.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794206210;
	b=2rI8mjG7KXSqKVr1N3ZA1BjrHCLjzqLHoi462r+6vAuQyYm2YFZosrG0G/vY9COS1sOXz6
	SUu8o/HUqjf7333qrWEbUInqpKRlQWiT/f3qWQJS+OqrlqXb1OxmPxWZsubVFV6svYUfkW
	g5b6yzG5Mi70kySRqNP/a+6gBZbJjyA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794206210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AtsfehftEhocEg2I5bmWwp2ROneUNtV4068+F7Hlw8w=;
	b=s+sjIG9kLZpqO+LbpU1DpqcLRFYjs9u2wy9YY2q689iEvm2G+LHsjl2rzr6yUJlAgXFs2S
	Fb7ZrsJzQO6tR4m8LFgr43lHXUDOlwQUp+FJBMWfwuR0tXp2ycIxdv+kb3sBEqI/P9p3La
	Y1R59yTC0NCbmPK/6vntSdsgP6cRoLs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b="JHF72/UU";
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf06.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 56B0A40E04CD;
	Mon,  9 Nov 2026 06:36:46 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id aOVENPtaFWK7; Mon,  9 Nov 2026 06:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1794206204; bh=AtsfehftEhocEg2I5bmWwp2ROneUNtV4068+F7Hlw8w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JHF72/UUi4yUT9aqIf+1NnxYf6RBnkvYAj3W0oNSoARYb9dCH6USJz/XwRB3zKAzN
	 MWJW9xd/ygniOGVsaaW7GBZaf+qXYyhu3aJBhi2D/f1MdqaPIPAWinTyaFBOA9gM35
	 5nUywwgnc62cQv4bfa4eoHQf48x0D4FJFNgLCt83+USeUOLy7Qh+2lSpB7trl1wz/p
	 kEpq/vJ6nrjXE/KAhASp6qorwpWq2HXjCxbam8Cyo1Z2sIRXrUNhsh6zZ/KoYZL2i4
	 1lmr105l2rgJ8qXntBB7PKSVPBF2/Z8bSDrAGXjT8NRQY6og6HlqYUIe5alwo9BgNF
	 dx1kkKAsqjQxtJJM1XRbbhZFSRsQTaoRpIN6D9Rt0nTL0lKCj+axgl9IxZagHCy091
	 r8Ki+ygh/0tcNG4AUVe5LTp4ch5qnCP4xKJ3OLYrbSXIXoab9f+zgIaxkW4jibdP8X
	 3s6MuKTd4JCyKlo7AF17HWOnrGSmGTMzu5kqiIdy8sdRXtaPhqcCV+NSL9gv2T7SAZ
	 ofaUI4PE6zr8T9OByuN3e8vf5AXpiMuzD+cRw/CoXMu517BCsSSS6nnJ+9Y0mm0MV/
	 h2mAq7Jr8pQs6CouL4r0WevxUISKIjEtmSGk88S8UwKCzTVapUK5ItYrpXUIxXDEx2
	 sCCf9g3g76KyyYwpg9RRhxLk=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B1AD640E01E1;
	Mon,  9 Nov 2026 06:35:12 +0000 (UTC)
Date: Sun, 8 Nov 2026 22:35:09 -0800
From: Borislav Petkov <bp@alien8.de>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jini Susan George <jinisusan.george@amd.com>,
	Kees Cook <kees@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Kim Phillips <kim.phillips@amd.com>, Joerg Roedel <jroedel@suse.de>,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Liam Merwick <liam.merwick@oracle.com>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	Xiaotian Feng <dfeng@redhat.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Andi Kleen <ak@linux.intel.com>, Kiryl Shutsemau <kas@kernel.org>,
	Tony Luck <tony.luck@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Carlos =?utf-8?B?TMOzcGV6?= <clopez@suse.de>,
	Jonathan Cameron <jic23@kernel.org>,
	Jori Koolstra <jkoolstra@xs4all.nl>,
	Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Ian Campbell <ian.campbell@citrix.com>,
	Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
	Petr Tesarik <ptesarik@suse.com>,
	David Howells <dhowells@redhat.com>,
	Haavard Skinnemoen <hskinnemoen@atmel.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Ilias Stamatis <ilstam@amazon.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Toshi Kani <toshi.kani@hp.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Vinod Koul <vkoul@kernel.org>,
	Jiang Liu <jiang.liu@linux.intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Palmer Dabbelt <palmerdabbelt@google.com>,
	linux-coco@lists.linux.dev, xen-devel@lists.xenproject.org,
	iommu@lists.linux.dev, linux-mm@kvack.org, aik@ozlabs.ru,
	Santosh Shukla <santosh.shukla@amd.com>,
	"Pratik R . Sampat" <prsampat@amd.com>,
	Scott Soule Cheloha <scott.cheloha@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [RFC PATCH kernel 01/17] pci/dma/tsm: Call disable DMA bus hook
 on cleanup
Message-ID: <20261109063509.GFavFpnZ-OM-rGcjdp@fat_crate.local>
References: <20260916115159.1938195-1-aik@amd.com>
 <20260916115159.1938195-2-aik@amd.com>
 <20260916174929.GCaqrWqZ1fIhi4Rgbn@fat_crate.local>
 <9c83efe9-9367-472f-bf39-e07252e70c3c@amd.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9c83efe9-9367-472f-bf39-e07252e70c3c@amd.com>
X-Rspamd-Queue-Id: B682D180002
X-Rspamd-Server: rspam12
X-Stat-Signature: xr5b5ywfdygcfybqep84jiu5wdmdkkzt
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794206209-83896
X-HE-Meta: U2FsdGVkX1/lT+feugNH9DHtZsmn+UBM2Dnex8KsgUOs9hv69Av9PxLsmq3BX1/fOXxtZtrFgvvWMTdIcPIxhiaDnu7M5tRoGA8g/2FGmfMA/F9A0kqxgOb2qNNT9PGzJffaMJs5nVSTpdlzR2AwhJU7h6501dcaWCnh2Aa7Q75S+tMzBPHn137AuHtQH7bO5/d2YjGV/znlbYqjjtAGqKfErA3lKYgvJCew0Feiu8EH1BssYyksDqmbkGT3UJDEvGFZgWSeRIfyN4dCKsvdmLGUQ2ee03ySMpV+Np3xKOMLJHyk1Xu5rOPNaIM9TnrzEUxNIn7bQs+Uu4k6KEF1vNK9t5W++o8v/BnwH+6okqZPIIaBHG45kNgMvBf1iDbhaFYi8kpUHV0NZSMMGqSPKAOMY2sO0WHhsP4/kkOzokvBl+5AIy650mtEbOMcz4HAQJzEf5CKbe8riQGZKj8XGzMdFbS+rUUU4XjS+2vxXlQnxTmg98SVcjfjmqsNH6TuLsS/uu9i5UtHPOioJKSYSDPXjrEhqzvWhPC301VJLkZGXewZ2GKqpj3knzd+MVkH72hiltYVzDrvcNlNjyDnfbIVaEVr1mqVmQHpSge8sgdu7Y1cBJNa/Jv7KNbH9GNzpkFP5Ms2UT57jqazwRea9K4RmGXo4vvQb6c4XGYgRz/SyjSrl8XnuPy+8zSM2mEwg+2x7+VWpDtSVI4pi6A/PlhFCCarm0DAcdFDMKPYpzuV5YSF3YviYNJaV9nNmp0wqjCBuocBbuCtwI9J8J+95AJZ+VGhBpHqPiNVqcEU7e6SxTqvtq60ZYS5D+dTWSjZPS6Ow8+lEZRMUgoC7QRNeSBuYTDwMWbNZ+nGrM7t/+Jny18mqewIjwOX+lxHoZXQSrpWc+FnY3GZYMtvJzcdbpPbflDRs5llgkQ88eUh5XuI/EDUC5ddO4R7CCDuwAZQFL2JvZ4GPyn66fS5zTf
 JrWhxde/
 eazyT9qQaEhfh52jWpY5Jun2SDCG/gXFMymZzqpYsiseABhZRjxE12IlY/yYtz1ponylwbZ7TB12z6P5VKKaYRQloLC8NC7MEMj5OO+uukPwxpSfC5t8VRP9+pu5JyWDTjRh5xk+klGn675VNVyjEKCgWZfdro7c4kwc+ufFm2tf8itPxWV/BYsmE0FZS2M1i855jrwe1Tv6h3V7Uba5pVwJ7abA0y1xlFX89ojTgGD60H8KtNWYSFIR52TerlNmGCUhKjnhCRlaPWkmtBo/AUOsbuTIcCpDwhAk7+aIM4WmBNEPP3DowJGuERGpyIpt5kiwLMbW9fwIbVQ9yY7L1tmbkTzUJfe9SpgS8CwgSD/mbIKNihWBCs2UXUT0WPyJBt/2ID329EqHILEKfb5q9uly6lh71jnzAV/CZQtA/ppw3Vn05TqlFfDZG50lGQYJZIMMMuaHTKs1QTf1J1owdduLuyauFbk120a9NqVaDdBHOnms=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Sep 17, 2026 at 12:28:50PM +1000, Alexey Kardashevskiy wrote:
> Correct, the patches between v7.3-rc2 and 01/17 (can drop samples and tools,
> obviously) are enough. It is basically recent tagged upstream + rebased
> Dan's https://lore.kernel.org/r/20260705220819.2472765-1-djbw@kernel.org

You probably should rebase that branch on 7.4 because it has caught a bunch of
conflicts since the last time...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

