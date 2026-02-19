Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 704E8C531E5
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 22:26:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A589B6B0088; Thu, 19 Feb 2026 17:26:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A05F76B0089; Thu, 19 Feb 2026 17:26:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 912AC6B008A; Thu, 19 Feb 2026 17:26:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7AF2B6B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:26:32 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 36D7113BAEE
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 22:26:32 +0000 (UTC)
X-FDA: 84462641424.17.AEBA3E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0A8A3C0002
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 22:26:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KT9MBj8D;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771539990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F73YjnE366GtCtUPqR5WN5a+4ht35k6GX9uH9fxRdCI=;
	b=v3yWnc3j87XMz8kJ27CRcYXF01JUaO4Mf0jpJ3VTuRpP8RANKe43G1rNfOcU/evdDl8Moz
	38KV8L1oZFneJC65z3hqgs4ZIW4U6qKD02TyIidp+HYq4h0hZFF2Xoj4ww0/gW/y2/vMT9
	zl+SQbV1MC9XiQdcoeAO0rptwHqWkrI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KT9MBj8D;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771539990; a=rsa-sha256;
	cv=none;
	b=uFMFHjTYXi04KokflsIhCms5raGjMl80sfFU1ah1iUIWyA7UfaWvf2eEI0GPzAdrXmVZaV
	oY47Fcr23mRIp4B3rcu+0knzbZ+WHbtsXDFo69dlvg48TKWcyvfMoGk6Jh1PDuw3bOgcYg
	wjblPdEwrbN1XBu/EvMIGd2kCOZwtvE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 847CC448A3;
	Thu, 19 Feb 2026 22:26:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6512BC116C6;
	Thu, 19 Feb 2026 22:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771539988;
	bh=orBN2LBkIf7igHtr8R6CLAmIl24SfmbjXYa/a8WFlcI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KT9MBj8D3xUAiRCGuRRmOHbbH/0nU5BhYau706AjTPaNf54+z/9Td2KBPtmwcBL/w
	 YJbXUGWiqxohvGPc68CgX1g8hFidjZHpabX4z66EYE0o0l7QLA7oPyXeGGoKMrEoLG
	 d7wrAHKYGxLqwQ+YMMRpb+Q7HTUgCp/9wUwnk6IT4oz2vm+5bXH7Z7+3BwENq4f/ay
	 INLVluaO0QSJsTUBXOwT/9mY7Rqy2BcWJPHMpDRTS/TnFm75igyLF5BFfL5XySvbn0
	 LTHbZwG3Cp3PwjcdPvQyCDpJeHqiNSqnlaGAEepmFUU0PEcXf0mSjCPOIhRB7WYdcP
	 gAW1RLGgnA02w==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 66BFDF40068;
	Thu, 19 Feb 2026 17:26:26 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Thu, 19 Feb 2026 17:26:26 -0500
X-ME-Sender: <xms:Eo6XafxKzgrSRy_GV1R-V0E3mm4-gAMqQY0o0PDt81tuhtGgCBIEwQ>
    <xme:Eo6XaaeyV7bi5aDbxaYQZHdoV_Kxy1h1R9jIlOb6cmVWD-m1wKpYLMkBC9OHVdwUb
    j1rjh_DIOdqi1xBfp1N-u30T1Wyy_iwo_vbIjicItT8NLCVcofmUj4>
X-ME-Received: <xmr:Eo6XaQIx-mqvhpbaJTP4H5NbWgAOgtmSqzoWMgRfGwq58VUSI2ulEEl-EtWoRQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvvdeijeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfedvpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopeifihhllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoheplhhsfhdqph
    gtsehlihhsthhsrdhlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthho
    pehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhopeigkeeisehkvghrnh
    gvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghr
    nhgvlhdrohhrghdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhioh
    hnrdhorhhgpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthht
    ohepthhglhigsehlihhnuhhtrhhonhhigidruggvpdhrtghpthhtohepmhhinhhgohesrh
    gvughhrghtrdgtohhm
X-ME-Proxy: <xmx:Eo6XaenG99uLRjrGHYnKM5woLSWKZYC4xF9RoB3Av7gK8DTRouW-aQ>
    <xmx:Eo6XaTW30OH7AyAeEek0gWVT0hZFSGffftKyh_dS9CG7cOWeRNJVIg>
    <xmx:Eo6XaYu1yI_zEp1_lgRmGIGtiJempLD5uI_rzZLPZFcDgWXzrN1g-A>
    <xmx:Eo6Xaf0VJRCQCaEDoj1gMlJ3_w88vuXaEEq8CwGX_UXmCQIzaHTdog>
    <xmx:Eo6XafUroXhQKmUnmUkJWISij4ZhX2jRAmpTX6J9_AWXFVAj7jqDjqQD>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Feb 2026 17:26:25 -0500 (EST)
Date: Thu, 19 Feb 2026 22:26:22 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Usama Arif <usama.arif@linux.dev>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <aZeL8fHz_1WAX49n@thinkstation>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <aZdMqub5RsukLvnv@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZdMqub5RsukLvnv@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A8A3C0002
X-Rspamd-Server: rspam02
X-Stat-Signature: 7g1pokxj676dozfererhfdxxbyhnkrus
X-HE-Tag: 1771539989-572911
X-HE-Meta: U2FsdGVkX1/uXeE1XmgyhgxkESt/joE0B9b4xs+fzXkBX5QL3G7H/swHyRKPMPbSlSjbZsW9yU7JseZtambOZp2+x3B2HAhdrzFUqifdyliWwvCwRqD7t4/5a1SFow+1chuV2S7Omk2uuLqVQ03xQIkq8zM5ah+CRfScUQiwXlPWgDa+FDHUGn+1QYQWoUhxVY6gJCDzOaxsu3xXhjBcLyeTvZY3vWO4Lx++1+dxS79xZtfe7cHn7J+vwmfsXm502zXC12tE4V/ADjs5olQCXcSmxSaTymUeHo6eF1+8YdrZqyHtbvfYRPqXUlDPitSQzEoMg81X6Cjr4d4st02GWGnYjdFDTjfRKe35fSgx9x5/ANai4B7BGCwjVqXKkdSHMbYEHhxRYkCq5hHO8OvLSKg7vSyzYrF6EYdnaAHXwg3RogEd9CQ6tSDMKdHRdxjD4rpqB7WA/XlEMWj34xBrRCpJbFQwHfekHvXdb5nir+AlhkjcWhAuwrK4sjgNR0wPHBp3ycZ1l++SZoBCk6KQp7Lv7xcadapKP1KTlv5+B/FT5b3wFb8Th5cAj+AFpZk7LvIPrnmkr2abdKx/iGaAJwTYLri+F0O91b6bzCr5M+HHXkkK46AxBwRri8wI+NDzfFxoqFDyxv7kaxuE8FqamTjjrYUUuRjx7+zR/5BwfAKElkSw4fLYz/0/QJnTpejwolS113smG01XgqY8aCq1LpsxSgw16TxWdv+rZzCk2u09h2HTrmdrnDYg3s81BupEnH8Ai/+/iIrjGHtAlP+R264m2qkrqyU648N/2BXy7ChHtc1vz7nNxQQJcQNF/SdU0NOeQ4S2ToDVL3AExlaeXvT2/1B2uF4AfeoAlTHjAhXAml/O/S/KOSu/vJ7mc4NA/Fq6MS4iS2vvJSTMe7HcXuF9u+95meDq6aN2M4A6iupoqP2VHDaVwdVm4XcdX7u3aB9h9p77zDJeTz5LH4e
 tblmv1rG
 vvmv3zmWEZdelq7BCvPuYC7XL9CKcffdIG1IuF8XrCO16UcdI5e07tmPCbqHmxbMtCDSscA+drUKxchkKsQbmdbbK1DM1NkmJ49dQbn0HkiRXlYR2B7wxXFy0PLArmVFDpe+hp0JetSl8n4Rur9zdksOlnLZBcljpvTt5BvBGhN3aueuidox6MEik3iSS5c6aGO12I8XpR7DtucgGEvcalxLZt5NAsOCgBU6aE525Nw/60jgB30RgjGcnb/uaLulVr5Rc7TfpsT3El75PQre61Iv/Og==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 05:47:22PM +0000, Matthew Wilcox wrote:
> On Thu, Feb 19, 2026 at 03:08:51PM +0000, Kiryl Shutsemau wrote:
> > On x86, page tables are allocated from the buddy allocator and if PG_SIZE
> > is greater than 4 KB, we need a way to pack multiple page tables into a
> > single page. We could use the slab allocator for this, but it would
> > require relocating the page-table metadata out of struct page.
> 
> Have you looked at the s390/ppc implementations (yes, they're different,
> no, that sucks)? 

No, will check it out tomorrow.

> slab seems like the wrong approach to me.

I was the first thing that came to mind. I have not put much time into
it

> There's a third approach that I've never looked at which is to allocate
> the larger size, then just use it for N consecutive entries.

Yeah, that's a possible way. We would need to populate 16 page table
entries of the parent page table. But you don't need to care about
fragmentation within the page.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

