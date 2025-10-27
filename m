Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3766ACCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 09:14:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 928D08002A; Mon, 27 Oct 2025 05:14:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D84F8000A; Mon, 27 Oct 2025 05:14:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C6D68002A; Mon, 27 Oct 2025 05:14:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 690CB8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 05:14:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F087B88682
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:14:46 +0000 (UTC)
X-FDA: 84043334172.24.F0265E4
Received: from flow-a2-smtp.messagingengine.com (flow-a2-smtp.messagingengine.com [103.168.172.137])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0051140006
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:14:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="W pyy6kj";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="l9/9wrY/";
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.137 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761556485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ib3gQpzJ+dspAAgN4VDq9O7p0OnCeMLRAxqGQCUWjEk=;
	b=bTsG2y9OKqHHiW1fGRKQJXi3EEdn3gSrJwdFpMaFy3Q31ZbftFFVGwZkuJsvLnxTYE7vpD
	2drpWSe5E+8xMv4EWO8CuNGd/42O3wEfiNa0niJ77CznxFjlqzOi/ehUI+Tm9u3gtmpS3q
	ZviT5ocrfJ3ZKPpwBF4g/AVqukHoSaU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761556485; a=rsa-sha256;
	cv=none;
	b=f7h2I4tLFq4kgkzo5ll2+SrZMcarAIW+KSqCOf2ElGBG0peC5fcehErmT6c2fjO0VK87or
	Fym8G+nwCVhl2b1rw3vJV045ZEwNlVyTm87tUhdFOBnQXJ8o9B8FchvJ2kicx2AbST+gU6
	0ciZxpGVKX3MrQ91KGXc/vu/OIr85/A=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="W pyy6kj";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="l9/9wrY/";
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.137 as permitted sender) smtp.mailfrom=kirill@shutemov.name
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.phl.internal (Postfix) with ESMTP id 3AE2E138037D;
	Mon, 27 Oct 2025 05:14:44 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Mon, 27 Oct 2025 05:14:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1761556484; x=
	1761563684; bh=ib3gQpzJ+dspAAgN4VDq9O7p0OnCeMLRAxqGQCUWjEk=; b=W
	pyy6kjbYZIpMNvsn6u8lWrvAgvG7AlrJ2FU/9CxigvrmTZ31s77EK1xWt+PLSSXX
	QI795DCVU/ll0ieqdqGhKVmVe+ZFD02N6xabxRowpwNWKX59XNkxTBp0XIHS7SLQ
	jP9Zs/1SUUQS2NDNg26lWETO8ENCwc1HY5xDOIokF1rBYMrhdRG4T0WZVWKXsvxG
	EC85Tx+VJTAKghTlJuIWVCja6NmFiGwFPqbqXuKfk1YfP9O0zuDRUl5KvNsj04Dw
	0xn2N1UnFhSj4GqmtOLiYROQ5wnkX6vFwj0rZWxKhzKRyoptDdjXKXkwFLsc/ozx
	1xquqnUs52ULyFer19YQw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1761556484; x=1761563684; bh=ib3gQpzJ+dspAAgN4VDq9O7p0OnCeMLRAxq
	GQCUWjEk=; b=l9/9wrY/4m6ICv1BZWsV1B8U8iuzjGoDhnacN2D7lZlqMo3YGh6
	0dxBonLjSShWUmMVrVZMhLjcvhw4dkmGxhrVtJc1+uQ359X1S4xikGK4/HBtFdwi
	dtDxLd/nbT4qt7fmS5jOyVk63WracO8WKf6GHRW1wQdtdyEG2kbZARHvHpKsHSUb
	NaCbOUvDPXBHZEbAqO0pKxtIJaeSWNQmCpDu47XRTFNWx+w3poZQpA3MaoV6pgCy
	HkMp+V4C0hAXGi2k9kSDAQd6ZswsNvZnWeCt5j2FiobOurKIzAyw3/tixAEk6OGr
	csIvaI2COCp+3qXuVNT62UMMgggyg+MJv0w==
X-ME-Sender: <xms:Ajj_aLAd4AjVLn68RIa5dKxZOS2fwdx1RhoJznr51abL8fGa_wDFrA>
    <xme:Ajj_aKnZykUeegM_rXiJusTi1rwrYye9zHzwpN3VKeCS4cHQviuoS4vXRAeZS_B2k
    Ny0c0Z-F5w0TwxWxQX70akou3pmoUQy_W0s3fJ6PByUIY-EiLm7jds>
X-ME-Received: <xmr:Ajj_aJiZWR8aRThPAADi3GInkvQkAazdCu378TuUW4GBMI-5fk539MdqzRDohA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduheejheekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeeg
    gedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohephhhughhhugesghhoohhglhgvrd
    gtohhmpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhr
    ghdprhgtphhtthhopegurghvihgusehrvgguhhgrthdrtghomhdprhgtphhtthhopeifih
    hllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepvhhirhhoseiivghnihhv
    rdhlihhnuhigrdhorhhgrdhukhdprhgtphhtthhopegsrhgruhhnvghrsehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdr
    tghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpd
    hrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:Ajj_aK0F86OvsqKUuDmWYa16LQ3o-ZC5BZyx3yG0pFU_4B6j9XcVMg>
    <xmx:Ajj_aNRduC-zzQpaZiuPIkIN9-XuLgLGvxnho_tK99J_X0MfH-I7kA>
    <xmx:Ajj_aMbU23mxVz9IT9OZnusHvqvI8nnOss5kkS07yko1uufhkWArbw>
    <xmx:Ajj_aK4xI3Sbk46VwdtUNMgal6bd9PnChr_3OyYCnYa5ST2NlI3eIQ>
    <xmx:BDj_aGcNSJgQIduzTcOhuub8dUJubkX2r4cmqkFgLr8LLKpFmtr-r-3_>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 27 Oct 2025 05:14:41 -0400 (EDT)
Date: Mon, 27 Oct 2025 09:14:39 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/2] mm/memory: Do not populate page table entries
 beyond i_size
Message-ID: <rn5mz62oyfxn4awnylebnsfwp7ixhe5mgvcmnjt3eydglzv5av@eshh4ipljc3l>
References: <20251023093251.54146-1-kirill@shutemov.name>
 <20251023093251.54146-2-kirill@shutemov.name>
 <96102837-402d-c671-1b29-527f2b5361bf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96102837-402d-c671-1b29-527f2b5361bf@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 0051140006
X-Rspamd-Server: rspam02
X-Stat-Signature: toxkdh96mbum9ufthossdtn998w8udqc
X-HE-Tag: 1761556484-656013
X-HE-Meta: U2FsdGVkX1924EEl6JBvuxC+H0piYskaQBwq0edysLj5mYN7tt8tWINdD+Xdi9ar20gK7gSEXoYYyD0oLORuADEycjv93ePwbcXRT6oG/3MhH3g35lke2Gsyc7pxC7DkCnkCvfLToWY7sFwn4Ex1hc+pwaYfpm8LCRm6slIixkY5Hu1k/G17NA3JZUuC/kw6rnIbNFTahH1+CXaLZd5Z9zcW/RKTZ8ZnYzqkjf45lDazCQ53gmmg/2GHMIPRRJh0i9w04JzUFo0L+FBl2l21MTarld4o2CzYTX9QbhyUu895kFJgB69FTB6F6DV2kpAHakZlKJFArIOfA40V7gTt4D2BPocDGOwBTnuO/KML3W6zeYNT/uiEZ8eokBYu7Ja+aCCA0SRktYGggg67U8BckrLz2EMjO+UgnI0On2Z5iEWIMKzHf3wjfdoJZRidCP+oK9yaWN5huofaVK7GXa9C8GWQySrD3k8uw4l7QuWDwbSirKUeySlPK6yz2MoaO4iTy+4gMbrfsyh7x68kXGXfKHyW7CW5bKPhkl2d0w0lA3o3IsVWUw9P2RYBgIc90JWU42s+2Pr810ZziyU/1EawS2zd6sFh9E9FMI1o6QQD3bG50zHrBh61waqk1GL/4tB6waOYsty5F/Bm5BadsgmQ6y17YbeftMUcQuwyXAJFG870r1SVFbJ0pJ/rpSAXcEswbfuyVwuMT0Xfzvk0NClCzlNhUTqc1+9S3NAGwcVdwHXARjmsakRw8uCe2hsaSdzOfF9mAqDxApc0P8gvVkYytIde3TYQK993BwR/mPjoqq19O6flLOUFbsaN/GESa+iHJvijEnMY3smYvvsED6ch65RKJAwu3eE23l0Gx2EiGUjfPHOBKmm0Mwg2DMHkfn9h2ivfnVGL5uGAeKLDnPzOgSKgRcgVpkC0jv1yqkrKDobTNepYpxKQr2ELOyf5PiQSst/TXZxikPBw5uK9Q3X
 +W/ycMSB
 TUVm7Mh/MLs6b9WmPAp0N0qjOw+gXbGYwBzLtdFJ97oUP16ilS8doKEB5YRyDHVk66ZlG0XLO0P9dhgNY7n4RfyD05TCLIiLnlkml7zM9010PXCb8226P5jaPiJ4LmC3UR7gSE72f0E4goJu684GHNHaZ/5+PoKDwcEp3Py+LUvdrcy9ZnqVMpFR8ZjanX/r+w0ahkoE+Fstibis0voPZswp1fzwOeyxydU0xfGKhdj1v1XyeD8FKCBJ7CeUTRMnO/fJiYOlQgZEYPCDOTYTrCdEpavMSYynslKdtikuSbcsmZMJC4DzTF7+RtVBPI51TiAwWEf73GI7FePXb2/IP8ubqokYWJGt/bGH7nTa2mYTnyaBiCivMdaW/MNKTb6+xW1Sn2hO5t1LQe5NTC4QwqagqRy0k7AN8hch75AN+MQpAJSP4xiSUBO0eLZDKOdKcOJINVWmf41r6Zn3oY5VNi/vk9dRF4/xN3+oH4xCvJZ+IBTTqYSyklVoeb4X9l4H8WiixYazR4nygbeY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 01:20:42AM -0700, Hugh Dickins wrote:
> On Thu, 23 Oct 2025, Kiryl Shutsemau wrote:
> 
> > From: Kiryl Shutsemau <kas@kernel.org>
> > 
> > Accesses within VMA, but beyond i_size rounded up to PAGE_SIZE are
> > supposed to generate SIGBUS.
> > 
> > Recent changes attempted to fault in full folio where possible. They did
> > not respect i_size, which led to populating PTEs beyond i_size and
> > breaking SIGBUS semantics.
> > 
> > Darrick reported generic/749 breakage because of this.
> > 
> > However, the problem existed before the recent changes. With huge=always
> > tmpfs, any write to a file leads to PMD-size allocation. Following the
> > fault-in of the folio will install PMD mapping regardless of i_size.
> > 
> > Fix filemap_map_pages() and finish_fault() to not install:
> >   - PTEs beyond i_size;
> >   - PMD mappings across i_size;
> 
> Sorry for coming in late as usual, and complicating matters.
> 
> > 
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > Fixes: 19773df031bc ("mm/fault: try to map the entire file folio in finish_fault()")
> > Fixes: 357b92761d94 ("mm/filemap: map entire large folio faultaround")
> 
> ACK to restoring the correct POSIX behaviour to those filesystems
> which are being given large folios beyond EOF transparently,
> without any huge= mount option to permit it.
> 
> > Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> 
> But NAK to regressing the intentional behaviour of huge=always
> on shmem/tmpfs: the page size, whenever possible, is PMD-sized.  In
> 6.18-rc huge=always is currently (thanks to Baolin) behaving correctly
> again, as it had done for nine years: I insist we do not re-break it.
> 
> Andrew, please drop this version (and no need to worry about backports).
> 
> I'm guessing that yet another ugly shmem_file() or shmem_mapping()
> exception should be good enough - I doubt you need to consider the
> huge= option, just go by whether there is a huge folio already there -
> though that would have an implication for the following patch.
> 
> (But what do I mean by "huge folio" above?  Do I mean large or do
> I mean pmd_mappable?  It's the huge=always pmd_mappable folios I
> care not to break, the mTHPy ones can be argued either way.)

I assume you want the same exception for the second patch as well?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

