Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4D36CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 10:53:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EFAB8E0009; Tue,  9 Sep 2025 06:53:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A0558E0008; Tue,  9 Sep 2025 06:53:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED1338E0009; Tue,  9 Sep 2025 06:53:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DD3B58E0008
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 06:53:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3D36313AFCA
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:53:03 +0000 (UTC)
X-FDA: 83869399446.04.1976452
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf21.hostedemail.com (Postfix) with ESMTP id 510191C0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:53:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="S quqfoQ";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=UVwDxbsc;
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757415181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wg98qBWvsK/xMOq6MrYIGvPlEvdIreb1eSQHFEhM07w=;
	b=6bO2dLJzXBYcCOkboUord9AA073xo3mas/e9JWQnpnBePSbId+2SzM7fYziQqHOUa93Eqc
	7Yba4jB20ATWGsmKDlrgSeOvbjzjAdDj6QpBU9foyZL52X0NUtuEzZARmrruJHLw2z7sgk
	p9+RXCXE0YjyHBaFw9xbT2Kw/2UsisM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757415181; a=rsa-sha256;
	cv=none;
	b=3ANV7eYTTYnSiratSMhdrN/KScy17aSRSGAfkUNyVQgDrCqoSfN+24unprFXqmiaSWeLv7
	bAtZ5LgKY7ZKdvuw8cOkVe24Xj9FSMErHcX+LN4eUmvFJEACWHwtfNUlghOhrmIrRpfQ3P
	8dJvd/Ctsgik0sY19mp/3rbjWufKifE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="S quqfoQ";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=UVwDxbsc;
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailflow.stl.internal (Postfix) with ESMTP id 2BA2613001CC;
	Tue,  9 Sep 2025 06:52:59 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Tue, 09 Sep 2025 06:53:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1757415179; x=
	1757422379; bh=wg98qBWvsK/xMOq6MrYIGvPlEvdIreb1eSQHFEhM07w=; b=S
	quqfoQ1A/Es8HY2Ox1iXgAtilXn4DOoih7hVgISC+p4nALircwFqtKiY0Rcexau2
	R14o5XifOuHy6hYd1Wx9/VoFQQA6WW4jSVfiDMh8jjTw6wr6Zh8P0eMMKhbdmKCV
	WqZv2jgdxelhVDeBKrcD4eywuHF1V9rNGX3doyR7DvdAk4eOqFmBMxFwfi7migIa
	y84yL78mq78rgcKO+4Fi5QEDenR1AwLbNzpJR0BrRA2znS1q2mBqFV7hm8vOHH+z
	ZpMhdRp31e0cWFky0aRd5bFN6fDur5wo3FIqjTOWxayPzZktzZRM98lu8sVHOqpf
	FoZ1w7TbeqIYVj/iLSPqA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1757415179; x=1757422379; bh=wg98qBWvsK/xMOq6MrYIGvPlEvdIreb1eSQ
	HFEhM07w=; b=UVwDxbsc93fwdu4x5rmjBVIqRLw5Ctm77zBemWK02DkfNqm7B6V
	BrfO1hPFwqMpcXVAJ3tT6CFG9Dt9btINdEbOTA6BrI53DScA8SzlIIbbWlljWwIM
	ij/W5nHp7pmaI+dVbX9QmkW9kccau2VdS3c5GOd09lcmn82qGHk0pXTVfEFzn75q
	avg9iskhtj093Kg4vcd3dvioTHfwD4sXPSHkf0XOtqHwA2uuT1jY3kgDjq1VOOsQ
	xWX2AqUrF9S87kJKAzID/SgKs8HfM04g1vAYEV8NKf5FQM9Y8/cbcREQx5TLJ+8q
	PPqZU4+IW/2Fb7p3jp7yxW4/c1kh3GdPB5g==
X-ME-Sender: <xms:CgfAaD8_IwsZ2C_Z6z0Sz4lQ1nZ7q2_smTL65rLTHFgdRZx9Y-_dqQ>
    <xme:CgfAaJ1Zubv1MJxm07JTlc26_txvRB2kMzipfNwVJkbQm5Gg8jji3Eq6_qdFvwste
    4oBbkTWoizEtprGEz8>
X-ME-Received: <xmr:CgfAaGC_fEnoZJFVkgYfHwq441M3PpAuDBkXzeCCINvcvyBJckNh2bkbDofSlg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvtddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeejheeufeduvdfgjeekiedvjedvgeejgfefieetveffhfdtvddtledu
    hfeffeffudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepheeg
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegurghvihgusehrvgguhhgrthdrtg
    homhdprhgtphhtthhopehhuhhghhgusehgohhoghhlvgdrtghomhdprhgtphhtthhopegr
    khhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheprghlvg
    igrghnuggvrhdrkhhrrggslhgvrheskhhukhgrrdgtohhmpdhrtghpthhtoheprghnvggv
    shhhrdhkuhhmrghrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopegrgigvlhhrrghsmh
    hushhsvghnsehgohhoghhlvgdrtghomhdprhgtphhtthhopegthhhrihhslheskhgvrhhn
    vghlrdhorhhgpdhrtghpthhtohephhgthhesihhnfhhrrgguvggrugdrohhrghdprhgtph
    htthhopehfmhgrhihlvgesghhoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:CgfAaDnH0hHt5UvkdrVLCCjub-He_pyUuOZrNWoFNOEIktC8ZyCMMQ>
    <xmx:CgfAaHotZP_nb5NJTEHc_40cABL3TMXOkFjsOByFxWpTfCUswDcUiQ>
    <xmx:CgfAaIM5Qx0qdcQ6sCMm-FvaXRbCQjY-sReL8MJkhgOk38wKq-6glA>
    <xmx:CgfAaBZbmOt0gWMZAthCchWYJaWki9MMaOhB5UCfYpP9j8tUCXovXQ>
    <xmx:CwfAaDrUB9oOsBVIlUW8HmOtjp1gbFp2KBd1hEKTJ3djVE-9ZRqF91Qk>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 9 Sep 2025 06:52:57 -0400 (EDT)
Date: Tue, 9 Sep 2025 11:52:55 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Alexander Krabler <Alexander.Krabler@kuka.com>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Chris Li <chrisl@kernel.org>, Christoph Hellwig <hch@infradead.org>, 
	Frederick Mayle <fmayle@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>, 
	Keir Fraser <keirf@google.com>, Konstantin Khlebnikov <koct9i@gmail.com>, 
	Li Zhe <lizhe.67@bytedance.com>, Matthew Wilcox <willy@infradead.org>, 
	Peter Xu <peterx@redhat.com>, Rik van Riel <riel@surriel.com>, Shivank Garg <shivankg@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>, 
	yangge <yangge1116@126.com>, Yuanchu Xie <yuanchu@google.com>, Yu Zhao <yuzhao@google.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 2/6] mm/gup: local lru_add_drain() to avoid
 lru_add_drain_all()
Message-ID: <bq6mehuumf5gmf5tnm5jo3iiglqtn4yo3owkxhdddnkejd46jv@4hax34dkkzds>
References: <41395944-b0e3-c3ac-d648-8ddd70451d28@google.com>
 <66f2751f-283e-816d-9530-765db7edc465@google.com>
 <ebaeb8d9-0b22-4304-9dba-40d37d82e369@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebaeb8d9-0b22-4304-9dba-40d37d82e369@redhat.com>
X-Stat-Signature: kochfy68wehffniy73tkn4m446e31ryj
X-Rspam-User: 
X-Rspamd-Queue-Id: 510191C0003
X-Rspamd-Server: rspam10
X-HE-Tag: 1757415181-312351
X-HE-Meta: U2FsdGVkX1/JCh8jI+KdM3qQ6NhAO6SpzB62x+WewR1wtxoFOuC8MKqjCVsqpLece7wq5f559166cEVtaDHlBI04MW/iDmI8lxRlfX1ZJxEjcBLp1iakL2x/b4g34jJ17veBF3laXemjkeFTEZpJHQbL0/MI+UOyvIo+y+iL4dET/PjXgGdeKyf5ItFGT5XNwlnD0Bqg2ExYufLqo+jbh7Fq85qkf8H4nSwSBVfZjzyW+tkzyI5ri5V8mi9tQ2ewZxyFKOiJuXzXYIsJ8aMbZjw/L8HIrvBIECRKaXtjE+moueX4bmhCS6ZWqpPaTlvsVkZQEFeUk3sWjY8sQkjSMOxNNfaIeE06SKP3firB2OpSV4k9vl4ET4zhEMznRnnA5aG1Gxb631WhV7GqA7Zw+c2/0dR9C6gutuT/fEZQLz8HeDkn7+vshrK3iD9AFqoYEUJSFxBjC2Dv2bWodnh/8CJQ5r2C1iJfZ8hIEhxFk/vWGh47W/h6dO/nV+P8zhtzV3+Hj+gX/wIeX34ZwQ3x66f2j0fn5seuznMt7tV/QJijnUFq+/YsgAVuWHLFxvMNhFFfwh+mh5yNhmoi1MxGYQqxs+tY9/MhoXMSszULfJefNey470swOn8B16KJuorqMTFeMgdQ0fZRBxs89TlNAqZ7401fi0RC5MmRBgjhOfeOybW+/lj4EYnk0TqyHDjUuMLadEzgnjCXcnR/H3uU5PiFmmcYb/VSaHjjZC7VrRnnzw204fNDZGFv3sKWMwGZpOu/UZygZUSPe1EieXFuxMTsc29AhTaFquMboWs7OBf9YeViMKAPxQMaFYKotoIO2VBu+idwX006Ml6jzKlzC2ZDgmhxijpFGGM2E34G1Ntz7vCxDZ6ttFklXH/H9U2M3XeuGk7yZAWpVNePKtXHoYuY67hHX1TWh7j6zNbhWZ3dsf9yKYXCqNTPEobN8jptqBxbb4q7qvNUIqkFjxF
 teZ9KHIn
 9H3p9BjB9bHOG2xQvqTiIJiMzkJabCV6jDz3MKmkSSZFFQNnZ8+X5aMqHSLQdS8SxojrMMoz/2EeIRj03TNtnmRwo1H6ADB4XxShgjOwUqK+0a2fv4t7QeEhsyd9LL41DbZQCofUTtZz0h1KR/b3pI1FlRaKn/ywex3XCk3bEAZJpemgfJ3qFyJ5H5kW0IT059+NDNoSetb2R8MSM+WeznjSeKlWs4Qp3M+A7N9VRjdAnNUE7UFHzpEHwUIUCoJwphovqXSMwxk1jv8UTUCpwyRd37Nw8JoW8PSrUTWEEH2OT6Ewt7tRvWJCfqTsAQGuq8nYHVz1jwnNjuz2KGUaMPimDTYAZ/zaKqilJ6JBHki/lzUM2savX+TvXCre4abg3UVWLYBiEN3TflovKwE7hZhJ99vACKBVolWmNClnJIj/2O6abUuXz1vXTZ/4ekvCqOHDrwkarSmYuRhk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 09:56:30AM +0200, David Hildenbrand wrote:
> On 09.09.25 00:16, Hugh Dickins wrote:
> > In many cases, if collect_longterm_unpinnable_folios() does need to
> > drain the LRU cache to release a reference, the cache in question is
> > on this same CPU, and much more efficiently drained by a preliminary
> > local lru_add_drain(), than the later cross-CPU lru_add_drain_all().
> > 
> > Marked for stable, to counter the increase in lru_add_drain_all()s
> > from "mm/gup: check ref_count instead of lru before migration".
> > Note for clean backports: can take 6.16 commit a03db236aebf ("gup:
> > optimize longterm pin_user_pages() for large folio") first.
> > 
> > Signed-off-by: Hugh Dickins <hughd@google.com>
> > Cc: <stable@vger.kernel.org>
> > ---
> >   mm/gup.c | 15 +++++++++++----
> >   1 file changed, 11 insertions(+), 4 deletions(-)
> > 
> > diff --git a/mm/gup.c b/mm/gup.c
> > index 82aec6443c0a..b47066a54f52 100644
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -2287,8 +2287,8 @@ static unsigned long collect_longterm_unpinnable_folios(
> >   		struct pages_or_folios *pofs)
> >   {
> >   	unsigned long collected = 0;
> > -	bool drain_allow = true;
> >   	struct folio *folio;
> > +	int drained = 0;
> >   	long i = 0;
> >   	for (folio = pofs_get_folio(pofs, i); folio;
> > @@ -2307,10 +2307,17 @@ static unsigned long collect_longterm_unpinnable_folios(
> >   			continue;
> >   		}
> > -		if (drain_allow && folio_ref_count(folio) !=
> > -				   folio_expected_ref_count(folio) + 1) {
> > +		if (drained == 0 &&
> > +				folio_ref_count(folio) !=
> > +				folio_expected_ref_count(folio) + 1) {
> 
> I would just have indented this as follows:
> 
> 		if (drained == 0 &&
> 		    folio_ref_count(folio) != folio_expected_ref_count(folio) + 1) {

Do we want folio_check_expected_ref_count(folio, offset)?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

