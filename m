Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C638C55ABC
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 12:12:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8428E6B0088; Fri, 20 Feb 2026 07:12:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81A606B0089; Fri, 20 Feb 2026 07:12:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7504E6B008A; Fri, 20 Feb 2026 07:12:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5E2396B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 07:12:45 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 092E416015E
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 12:12:45 +0000 (UTC)
X-FDA: 84464723490.02.5DFD6AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id ED79E180015
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 12:12:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZxlmI0kD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771589563; a=rsa-sha256;
	cv=none;
	b=l1rrn6MW8BZVou526c8ycNf33cBEEucWNuAZJyXZwHLiO55IBT8G+e8F/eMjWJhotQysTo
	+eRhdC/ezzH4hUn5OX6q0Xs5GZNidjQM45OYYMuvnUDA8MtSTnafD/V+qBi3dTCe7DkCLf
	+CHRcmyItZ9wqrNPhf3P1H2vA5+GXJA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZxlmI0kD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771589563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=doVGXwP3MAgK3+d4BnRMdfL8Os6ny51vPMuWYuYNeDc=;
	b=rz4o7X/PwhFbUtoXWuVo4YzTxkCAbqzCmxvVvOgl0ir5STiDSZeCx0F5c6k2kKPiSfExf6
	PxhQoedt1mZGJK/PRIuxn5PBimOvISVLrNcldcYjKWkoACWTw4Avdpk0Qg/Yy3EIB3rltQ
	7qNGozNw61nTU744RdFmZdGVScuN9zY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 119DA444E0;
	Fri, 20 Feb 2026 12:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E618C116C6;
	Fri, 20 Feb 2026 12:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771589561;
	bh=T6LMUVspLEBgW9ZtGG6f3R7lF/3+q25WW4ZjUXCkn50=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZxlmI0kD2SXQnAPyW7neGnTgyZKE0F5F7EABm00ZS5clsNof8NVxi1I05dHdE0Mi8
	 rkPJH/mixlA8MubPrkqpnsQYIDq5x/PWTnvho+b8FQkYUA82yMB99aJszsaTye333q
	 btJF3jfUvCDT0Nct+NQ90yN23QgCwbsc4oaQl5+ScP9Fy/Lc9LJvFD1fwZ/BUkabJv
	 fYJPg9Zsuvx/yOzgVKbcuLQhlUvQnYR4a0fi9tH71qcpcXzjBsYcuD7Ege29kiy9M5
	 I8r13K2Cme5t+hJDfnoh3wMAbNlD+bzxLGQWAphebKvkEgbpeYWPgG+RADdMh77WzC
	 puFpxY95SNvBA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 04CCFF40068;
	Fri, 20 Feb 2026 07:12:40 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Fri, 20 Feb 2026 07:12:40 -0500
X-ME-Sender: <xms:t0-YaYcy3ASPjYdAgYEad_GJii3P1jAemczBqcjqINAgCa77AzbuFA>
    <xme:t0-YaWUYeZiXFbnjYf4d3geX741spFQFNA_IQ0pHCrismSk9Zh3twhPxy0b4nFDjz
    Um5jSiIUQ93yhGO6fQaWqz8yMEB6sIIXYntscg57yreyv81fmEQJXW7>
X-ME-Received: <xmr:t0-YaSw964fsVLhN96toHTYi8ofqaLRAKtVHt154bXGUF_QIiKwQ7j7bGMyb7w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvvdekgeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtrodttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdetfeelteefteekfefggfffteelvedulefgveduvdeljeejjedtfeegfedvkeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfeegpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegurghvihgurdhlrghighhhthdrlhhinhhugiesghhmrghilhdrtghomhdprhgtph
    htthhopehlshhfqdhptgeslhhishhtshdrlhhinhhugidqfhhouhhnuggrthhiohhnrdho
    rhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtoh
    epgiekieeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghl
    sehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghkphhmsehlihhnuhigqd
    hfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopegurghvihgusehkvghrnhgvlhdr
    ohhrghdprhgtphhtthhopehtghhlgieslhhinhhuthhrohhnihigrdguvgdprhgtphhtth
    hopehmihhnghhosehrvgguhhgrthdrtghomh
X-ME-Proxy: <xmx:t0-YadD4kRi5uMI1nRAes-C-Roa9SoEENQInotQeFz1XlsRHRs3xTg>
    <xmx:t0-YaY7H8bGv46Ipg-2Ppk6Vdm8GKn1byCobaWhBTtbOfAEkfzVEhA>
    <xmx:t0-YaUmABe0oNdNJKrdmIlpJSElGfnwRtgRPlq2twzEWipfAbDNYOQ>
    <xmx:t0-Yabe3rw96EAbb9cBcIwpPKdcAfXyYec-oDuwv4XjpzK3Fgf4png>
    <xmx:uE-Yad3uL9ijU2CxvollWNBEDJRKgqSKE9gZw2tJNfThCaaKMUKuw8Jd>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 20 Feb 2026 07:12:38 -0500 (EST)
Date: Fri, 20 Feb 2026 12:12:33 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Usama Arif <usama.arif@linux.dev>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <aZhPZWFdymfmrICW@thinkstation>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <20260220090409.1784bc64@pumpkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260220090409.1784bc64@pumpkin>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: ED79E180015
X-Stat-Signature: 8d4owzgcc15js4m5aq5pd6okgf4ub1u1
X-HE-Tag: 1771589562-383543
X-HE-Meta: U2FsdGVkX181Dp/+44XNzkmeU8vy1io4l3Xac+14g7WEooKov8slsjdIIGu6QD9DL9wgE/SXu4GnF2g4HTCuDyw6rNBiN/gUiQH1xwHqYX7SVr21bH8zPB4rs35FZULlE4Pj3wBS/b5C6InkiU6v3lfQT3qGbBssfr7voAWaO9TpZOGfVhhZ/AphhXUc6bUkCr4VR8ZlXHjqZZWGegGTYHZs2Q/Jvtr/NanksXzX0xXKrQb9Sv1kuuYGrcbeqYIopRxh5HRuCI+kF9MNEXLYVnxyoaP/bdPw6BjLvbjrY4FGyM02swFe9gFMe2hln4DAjK6MLyi4Scdv6P8dqYHui4mPqnEX/Du2NId9aXwMs0LxZa7f5ExKm8ZAP6gjTYqqtJAaL8ISgSR44GrtL/r/6QrovofZTWCjPGNESdLjZA5JjLCDdsApLBIfinxmdYVOIEHwh1Hf0YcfzqidOjdtqF9tBYE1lbuqH4oWh6he28KMFAHgBqUOcg/VR11RXUZkY3unT5A660jDS6qp3OQD9ZG/OfJs3Pdbq1eRSlWxzF9cwKWGkLCldizrZVqr+O0MOL5FvaSRNnN/VV9/x8VyLExpq+rJ5sng7yKEY3qdeXEzlecxnDkNN4eD7zkOeiDI6EbWRAjDB25WnjLdHVtSVs4hLJnoqn0oFOeT++O/vdlR/GTsrlB1oDjyw3CNPutXf/9TsVTnkzAunfpbohV57ixD6iDMaeGeXZ0ur+Q1q4rMKSsglKBzoqwXle4ZQJ1mOowyShGCc1JqahOvDEoLlLs7ZFT8s9MXXqaoKMM+f+99PYM/COlZ4IXtH6gp2plGyI/4NMt5GFKVRPJfJR6x5AkNrkVRPoICp9avutC2HaRCp2by7sc4x++3vPIVS+GQrMppgY709zKSf9RVcbFPq0bAe9F1TmUcjV4k7essYyW8WqAHMLbCIPdw4xVuc2hDTpORyqtT6SnmjmEOdQ3
 vRpQawUo
 YxOy/W4ViqoTkcow8SiAMdwfx3kM782vDMdrwb/T7W9bI9+iwBMKaYubMtAMnEohJnupkK3/7X+yiO0KS6exuqJAaGJywTbBSA9d3SSoXn0Vv7YWT2x9CyM9NX6BLmhBHv/tRk19Ptb9n8BedhslJujXQDdBxh9Yr8l6PtXh8W77m1AxvgYzN9POmN7YJgfZOx21UbF/tJdIMcp+k9eQeo4/aZVJ2VSOocNRiJ7xemf+dda7e99NzE6Z8sKz/BSS/8FZNSsZSaxA5NQXrJBEfDFXwBMlx4eeAz+8ykkwHe//JW9SbI3bcXcqVys9bLs04SjN4lUqUmVHad8RRhpBGu3K8qebzJM1Q8Fot3dODHypV4HIH/zooe+H3/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 09:04:09AM +0000, David Laight wrote:
> On Thu, 19 Feb 2026 15:08:51 +0000
> Kiryl Shutsemau <kas@kernel.org> wrote:
> 
> > No, there's no new hardware (that I know of). I want to explore what page size
> > means.
> > 
> > The kernel uses the same value - PAGE_SIZE - for two things:
> > 
> >   - the order-0 buddy allocation size;
> > 
> >   - the granularity of virtual address space mapping;
> 
> Also the 'random' buffers that are PAGE_SIZE rather than 4k.

Yeah, in some places we use PAGE_SIZE just because without any reason.

> I also wonder how is affects mmap of kernel memory and the alignement
> of PCIe windows (etc).

Kernel, as userspace, is free to map memory PTE_SIZE granularity.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

