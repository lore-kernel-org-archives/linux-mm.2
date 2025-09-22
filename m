Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDDABCA100F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 16:16:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D0E78E0008; Mon, 22 Sep 2025 12:16:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AE028E0001; Mon, 22 Sep 2025 12:16:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFFF18E0008; Mon, 22 Sep 2025 12:16:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DD8988E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 12:16:42 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8226F140192
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 16:16:42 +0000 (UTC)
X-FDA: 83917389444.27.AF75094
Received: from flow-b7-smtp.messagingengine.com (flow-b7-smtp.messagingengine.com [202.12.124.142])
	by imf30.hostedemail.com (Postfix) with ESMTP id B7C2E8000C
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 16:16:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="I z96PxW";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=CM1i1Kow;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758557800; a=rsa-sha256;
	cv=none;
	b=mz1ACuymsX1xP0sD/FzNxcY4pzx5325vtvFahDky8FzaUnPFGcgIV+UJrm5E7vC5W2Fuqi
	a31jO21Ut0CF7Hm64s8J2NXW76gewOqeyRyQ55NRP5QqW4LvrDenXp3a8vA7IeGx9wwAsD
	zziEwbYXxufMV5Q98HW5ZnjauCJHpqc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="I z96PxW";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=CM1i1Kow;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758557800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=INmHqpS8XOyU8EfGphccX7Ljpp6ELUOxylIKJQ8Yn6w=;
	b=A2rRmy64gx+1mqVKDSFv4tsEdlqkMoGfvZTwNlgVPJMduDr3LY5de5IuSwGdOn1vkhyJ/5
	ci3p5z1nttAsOLf0jLf1aTw9QcRVu4HRPVEkxWHgLZOLseAWbloFDXRDBEcKvtfJnzLnLm
	0AY2n9Lh7cYzvUzzgNZqzmnA2vECYpY=
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailflow.stl.internal (Postfix) with ESMTP id 0DA291300360;
	Mon, 22 Sep 2025 12:16:39 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Mon, 22 Sep 2025 12:16:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758557798; x=
	1758564998; bh=INmHqpS8XOyU8EfGphccX7Ljpp6ELUOxylIKJQ8Yn6w=; b=I
	z96PxW4Yw+8OnYsKB1avCOzDJAGNbTsCLR4kPQNmHK60qvqYXXlOI8C4Jcl/sbzg
	gai9/XcDc14CGTwsChiQgE6DktBZWUwUf3CblNclDkL/Qf7hs3s2YizhNom4+KtN
	ulIZ85BbmMfqMYF7HIWPSp8zudOpCSiLxoaca+D6wuWqzGx8Cxnj6CcT8aFYmKzR
	dPbyMU3jhTaQUEVAhhXZ5XEXtqPSNHcuyac/o0+93TroHfrChLnfnmh+02uVjAxs
	mXpdAqPaUaJWBvpFVCQBN9fz1LjrWLss3y4sLuAAsaMVw04JTPttJqssXTZ2jO26
	BBExHAwPcGB/tgbTT1eRA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1758557798; x=1758564998; bh=INmHqpS8XOyU8EfGphccX7Ljpp6ELUOxylI
	KJQ8Yn6w=; b=CM1i1KowqsrEYJZhezg7fdaxN2W6f8+uafjcx41etkzDbW/7XUM
	v7v6YvZO9orSHMFY2lYTz92x1ML2EMO5aLtnnE/+7gqDUcDTCeMJgB9XC61B81vh
	ZeDhLXnCIjyyzh12eda7XqzVghzY5G2hVozPC/nmrmMhCQHhMWOotm5167EqdXzm
	XU+n3FdYWXltDDFXsm6GagrkVeZRNda5z6E7ysva0MZ7oDHw/+6hrNqCGfiDI/4N
	I4aokKLfBX0OrzOvkb33vj7h6wjunlcoZzah0aybBkYW2XjTgr0FdjnYT8tDmxlv
	xtl833PeBF/n/WTZY+LwMFkmMpRiySijhsw==
X-ME-Sender: <xms:ZnbRaE7LQUF2JMsM9INnfAbzQt8VY0zj_dmw-YId-5i9PTkJ1lQJcg>
    <xme:ZnbRaDhfM0OX2Lq5WpyB3tJfll4w5I-Qn5l0eKv_K3_22gzBOuUnNcJnWHhUUZ5Ia
    _ZlqlJBnxds5_jqiInaGLOVhVJd2hBicJKaObPehly35rVLM7uT648>
X-ME-Received: <xmr:ZnbRaK1sROvbF70OTTbKLHbMICS-QTEm69yIqxEBOQTyT5ISznXVdicPEjLkQg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdehkeeftdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeejheeufeduvdfgjeekiedvjedvgeejgfefieetveffhfdtvddtledu
    hfeffeffudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepfeeg
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrg
    gurdhorhhgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdr
    ohhrghdprhgtphhtthhopegurghvihgusehrvgguhhgrthdrtghomhdprhgtphhtthhope
    hhuhhghhgusehgohhoghhlvgdrtghomhdprhgtphhtthhopehlohhrvghniihordhsthho
    rghkvghssehorhgrtghlvgdrtghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtth
    esohhrrggtlhgvrdgtohhmpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgiipdhr
    tghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsg
    esghhoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:ZnbRaBWAaa3ZvlckATo-PS4VYNmwipKYxGLBltIUst2gHDGckhBA7Q>
    <xmx:ZnbRaP0eQvImVuLJ8CbwviL4F5DNFyUgr5yjPd4oAAkHc7XQ7AVM_Q>
    <xmx:ZnbRaKgAymiCdrCd6eN25Dner05D4l4QHlFjrXSpC2gUbXLHJ1ZFpQ>
    <xmx:ZnbRaHKCV3DdAJTY82PxaYlJUvJJRj12FLcBTlreC9FaJDoNwfYLYg>
    <xmx:ZnbRaIsnq0pVBi34uUBmBtRE32EFwoaipSoqwycNigdPUkP93iQLd7kS>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 22 Sep 2025 12:16:37 -0400 (EDT)
Date: Mon, 22 Sep 2025 17:16:36 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 4/5] mm/fault: Try to map the entire file folio in
 finish_fault()
Message-ID: <n7dly3zxv3wyixmq5yqjijgqjaxzl62ebmsne3tq2zjfqeztgl@ews6hof3zvco>
References: <20250919124036.455709-1-kirill@shutemov.name>
 <20250919124036.455709-5-kirill@shutemov.name>
 <aM5ZwWiFDOuSl6C5@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aM5ZwWiFDOuSl6C5@casper.infradead.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B7C2E8000C
X-Stat-Signature: d3j6kx6agtnaa1bsfewqer6oswrrfttf
X-Rspam-User: 
X-HE-Tag: 1758557800-625178
X-HE-Meta: U2FsdGVkX19Q/2beL/eUxd677Nv4hdlFOTwwd41BVIdI1+1vYUZe/svtTVzFWdc287XafzTiBqeK3GjFt4YNqFZsfF2SQe7qfjl1klL8UG00AGMxxwq9AZdBqg1XcYklkWAZLXUxlu/TsucSTjydiTRlEvSdoO2RoVkSej3ZmVohIHIeg8l0sTFILRuqMRkHV+ErjQPzxfOcYLTWBvGTXeX7jaORDFbcna9js5YjVrfbEhx1+/OI+DcA9er10R0NS4ll/5wUCTGAml9vbOKjhdNIQi7+frzUrp4GbG4ZmYAneh16ZG2HRekhkk0wg8jP35Vq9h291ak7ZJVfhHOI/VNA6UE57NsgUlLkwi77wEfHvVYrFqE/XybkZMThdzWMWDynHM97HiNrU+Rm7N2vf0LOZ0W0EI4r7B+pcsIczjNWI+DbreUiGZ+D8wJdRHkMWpAZFjE3GQLFJEVD8bE9rePmXe+gxpWZyE3lkIPfRFXpfxfOzraXU7k9egX0RW2D3c3DpIRTxJ5g2GQfVEQW/iTPd936XiPHiZBZMrTYwC74jhuCjme47quaLwV/9jpr9u8Fs3mEoGJoUF9dVIrybA8eysDWFImk9D0T77Duxcann/53sMnLjfxjzEFLecJYonu4xFdH8DpoXTuOG8MaxeBU4rTx9TnDbexpd3fsTg1RC54Dus2TsP9tk5qVdVn62t3wmjuy5B6JSY08iGxhpvFhyTZIJXMZ2L/rqh+crKCXDnGUtijpqG1QLbUA40JjOjMdqe5EB0um9qZ2FlA8aybn/u/4pqWGJbjJyoc5jcOInTCnDwKvr3YHw/+57e6iRMjppRf0qnliBvyZEE6OIMUM7b7PEBFZzNIxPib5UopVM+rgFd6YTINN09cV1DwnTAPhRl2gxhXycSRiZoIvZA2DU8f1tG5OqUda8fiIrEeo3hTZNKCKnf4hAmoaP+mFfAorQLBkpz0pySUQvb9
 wtPj1kvv
 nZ9z+WNfMuFuL2fxOb+8qE/fF2Nykbz3fkBJ7dTH3GAn4Q6U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 20, 2025 at 08:37:37AM +0100, Matthew Wilcox wrote:
> On Fri, Sep 19, 2025 at 01:40:35PM +0100, Kiryl Shutsemau wrote:
> > The finish_fault() function uses per-page fault for file folios. This
> > only occurs for file folios smaller than PMD_SIZE.
> > 
> > The comment suggests that this approach prevents RSS inflation.
> > However, it only prevents RSS accounting. The folio is still mapped to
> > the process, and the fact that it is mapped by a single PTE does not
> > affect memory pressure. Additionally, the kernel's ability to map
> > large folios as PMD if they are large enough does not support this
> > argument.
> > 
> > When possible, map large folios in one shot. This reduces the number of
> > minor page faults and allows for TLB coalescing.
> > 
> > Mapping large folios at once will allow the rmap code to mlock it on
> > add, as it will recognize that it is fully mapped and mlocking is safe.
> 
> Does this patch have any measurable effect?  Almost all folios are
> mapped through do_fault_around().  I'm not objecting to the patch,
> but the commit message maybe makes this sound more important than it is.

You are right. My test cases used write faults to populate the VMA.
Mlock accounting is still broken with faultaround.

I will look into this.

I think we would need to rethink how we handle large folios in the
faultaround. 

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

