Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FADDCA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 03:56:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A1F78E0010; Mon, 18 Aug 2025 23:56:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 879EB8E0006; Mon, 18 Aug 2025 23:56:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B66C8E0010; Mon, 18 Aug 2025 23:56:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6E6458E0006
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 23:56:31 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 91B6D82A06
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 03:56:30 +0000 (UTC)
X-FDA: 83792144940.09.D8B83A4
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	by imf15.hostedemail.com (Postfix) with ESMTP id B14B2A0005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 03:56:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b=F96eFffC;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=OyUpNN6c;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of boris@bur.io designates 103.168.172.154 as permitted sender) smtp.mailfrom=boris@bur.io
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755575788; a=rsa-sha256;
	cv=none;
	b=BfeH2iWT1XGtnVqVQjRE1LKYITVMiCslPK5dWn+yE5lQ/UvHpp7a2x2ZGaXQVsd6owfl4u
	B7ZIOYbffZXE+iD4phJgLrrEGVee7RR/4RsknpWCffXJc5/wbZIfzhKqMXBEbpGx6DKdg3
	KHYfa11+SyLieXO0puXf1OGTnn5Dvr8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b=F96eFffC;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=OyUpNN6c;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of boris@bur.io designates 103.168.172.154 as permitted sender) smtp.mailfrom=boris@bur.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755575788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sq6GkPmQrm6lLwWX2E78iMIaD4F38zFJ0qyBMJln7so=;
	b=LXAdbDPb0e84tI2agPMsEGh5k3yQTi3jzKTr788pwn6tm8MioB2stDF3s23emQjFjxj9dz
	XRHzsWUXS3qAxN8e/07yh7IpPIe971DPtmXv0fnT+WP87MhX9NWiW3VlkO0HJw3/ePj7Ki
	fqugSGaU8Ky9QKgnC+Uz3E8fVC2HloY=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id EADEA14006F6;
	Mon, 18 Aug 2025 23:56:27 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 18 Aug 2025 23:56:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1755575787; x=1755662187; bh=Sq6GkPmQrm
	6lLwWX2E78iMIaD4F38zFJ0qyBMJln7so=; b=F96eFffC2rSRSIncMc5tLJCbml
	pK8T1JcKzLiMtmNqxXHXqZrGcqWJGACucPZz2+BmSJlNx2Pb4jRsPQnnH4TfU4p2
	1gfpKcdz2d1sWyU/zamMYG+b1k9E14qAgSp2yfrNldialj4mRWQ2pq6On/vRNehz
	0YZJOJ9ubarkbI2n3uEgoj4XjKd3EGNWVcDRPhbaZ8mx1Q/Z6YtwjMNyMFaRKxDl
	aGDUHRRq3nBCpXwPVKKvY3xNkgWY9OcT6G6T/VY/6w55PkP+xY1rKwWj+fsPIbzX
	QtF7i8O/7DAQUbkmwFYtpmyyVDM035Ny+QxPMfwlTnurw5oey6Yrs6iCTong==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1755575787; x=1755662187; bh=Sq6GkPmQrm6lLwWX2E78iMIaD4F38zFJ0qy
	BMJln7so=; b=OyUpNN6cAQgJc351sAYUZOLuG2GM+GKurO+RGICO31kEfVwsRXc
	EfhEDUkUlHuy28HlexLOffvylJKLcMOtHvDfuz9IIkCGDFjrLp3KuB+0v5CFFbFK
	LPmMApad5fUtm+XUBUNUqz69c3SLSbz5fqNrN91u9PUs1/acSC/9NBJg///blFxY
	FovHGzmZR8ENCjZqMqDoF2/qL9Hj/sPYk1GRAwYD3AF4L2xeJH4Je3+8NsnDc1Sl
	QSsWRxHLd3ATrzMNLA+2wYmxcmj36p6HnsgvFT6quKmBSDv65NKN6R2lvXeHz7/X
	XSlFMdl7wtkd8A1d7aWhdYerNbWNqFfbnBg==
X-ME-Sender: <xms:6vWjaHHi5R4GFAO1gja_PaoTuo-ksJc9tKs3pd9qMUbDCpAi4EKx7w>
    <xme:6vWjaJ2GCbZGE_QMuVx74eXtu4t45cvOTEuanOJ8bFkpS0THjHYUW1ln4IjHtXLVO
    FtfTWOHHCqGz8g6w6Q>
X-ME-Received: <xmr:6vWjaIMwunqUCLseJ2P3PMcHOKGRLymNASxVi6qSjOl8GDwlrjgvB4UiOB_3L64O4sSSBxE2_qhfuca8mo6Y0q3P7GI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduheeggeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfhfgggtuggjsehttdertd
    dttddvnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepkedvkeffjeellefhveehvdejudfhjedthfdvveeiie
    eiudfguefgtdejgfefleejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopeduvddpmh
    houggvpehsmhhtphhouhhtpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdr
    ohhrghdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorh
    hgpdhrtghpthhtoheplhhinhhugidqsghtrhhfshesvhhgvghrrdhkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhope
    hlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthht
    ohepkhgvrhhnvghlqdhtvggrmhesfhgsrdgtohhmpdhrtghpthhtohepshhhrghkvggvlh
    drsghuthhtsehlihhnuhigrdguvghvpdhrtghpthhtohepfihquhesshhushgvrdgtohhm
    pdhrtghpthhtohepmhhhohgtkhhosehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:6_WjaJZnOaU9FgovccDnrYK3V49BVD0Q6X4e-pPOqTGi6HMd5zLWdQ>
    <xmx:6_WjaGxdNNGZLbX9lWDqyGUR_wWGEz_s2tG1BHfsFEH3QFLMn-M-Sw>
    <xmx:6_WjaIPwumM39yT_zcevAO_eZsWTXEM9Bq-NioEdGaK2gyOS9tqSjA>
    <xmx:6_WjaFe53yLXVr5fjH8bpfFhEw8k7FMxsMA5g1cg41g_qtveEG7-9w>
    <xmx:6_WjaODwRtx7oOnv6B0m8XpMwlVq4bz-JD0cm41AZu7zcCcxjhV6OE_F>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 18 Aug 2025 23:56:26 -0400 (EDT)
Date: Mon, 18 Aug 2025 20:57:01 -0700
From: Boris Burkov <boris@bur.io>
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	kernel-team@fb.com, shakeel.butt@linux.dev, wqu@suse.com,
	mhocko@kernel.org, muchun.song@linux.dev, roman.gushchin@linux.dev,
	hannes@cmpxchg.org
Subject: Re: [PATCH v3 1/4] mm/filemap: add AS_UNCHARGED
Message-ID: <20250819035701.GA740459@zen.localdomain>
References: <cover.1755562487.git.boris@bur.io>
 <43fed53d45910cd4fa7a71d2e92913e53eb28774.1755562487.git.boris@bur.io>
 <aKPlkhXY9CON4x9v@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKPlkhXY9CON4x9v@casper.infradead.org>
X-Rspamd-Queue-Id: B14B2A0005
X-Stat-Signature: 37ggi4u4npcean836hf6qkp1ppderahm
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755575788-435801
X-HE-Meta: U2FsdGVkX19gOkoq4sGcGHJ/0fF9w1pNfblKhWRU+hdmG6Td8kyL0MVidJxlaZhN+qE7dfu5/+qAhsJFetDJZ8rxWkDr8eIFPKYvMjTdXhdXeHqEekZEtZZQeHnPF8qrVJGpZGtpu3JHd/nIWPbr028xOaQR478wyOn3CTOYCZ5ciU3psqQD78sr4bRZ3X80l+PYiU9Pad5LE39KTvPHnmnWA+1N1A1OaRFhgJS1/AaQ+i1YbBOi2sg2E41eoCWLbYmACZizSIlfkGu5FKs5U1pU5n+2vibdVKhN1xw06vmzbroDwxZAjtKb6r7ArKmISBahq8Ul1d8wckfPcSH8lfL/Yuey1vewxw2X3Uw+jqf9TwiwzvWplNajUjCGLl30ICla650Ftb/NBhj7svDy2DnvEC4U3r7AM/Vjmlk87j9hx1aWYNZ6f7i4zaXyFsjfqRcwgBpLp7TRdTytRwlVpxFK+PZXrJLCzxyv7OiHonDc2gHPSd6XRlUEG9VegubP2e1f99xbu03p3f/TfwzUP/r1026c3F133fXYoS+4tEsMOxZgQ6mzhf90I+s+42uYo/quY5+TeDE77uvYUVWccq6qEXt66LVK3Kr+6WBw118f8G7VRMffuLJrNnB4gJlf/uQ7pB7Sw1qpfoQG1C24YVg2oeMMMRki1CXgglr5ZgCVEdIf2c0l9UNljxr6b9eWIcLngG4krhoOVKUk01NtnAgGwOX/IAnhMp24AwESrv4sYXT7uiaOBXY1+Mqgmd/QbiVuEdKMzgGUi0VzsDgEVECi5LeDu19909Cf4vWZa7x9hgWzv8pYpBEj6di9Cntoa77lRF6s+9niQ/5eUveDdJcm2NuC1Z1Lq4ORosxA7EwYmdI7HIZNTNCkYmvWEOFvYa7SIzZ4tR8J3mY9T2mKqxpOVcKjLqLRuRX/ZkmXjq1em3BM9dOgXvg2S1sv7Y4ZWh2LCyYmzew=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 03:46:42AM +0100, Matthew Wilcox wrote:
> On Mon, Aug 18, 2025 at 05:36:53PM -0700, Boris Burkov wrote:
> > +++ b/mm/filemap.c
> > @@ -960,15 +960,19 @@ int filemap_add_folio(struct address_space *mapping, struct folio *folio,
> >  {
> >  	void *shadow = NULL;
> >  	int ret;
> > +	bool charge_mem_cgroup = !test_bit(AS_UNCHARGED, &mapping->flags);
> >  
> > -	ret = mem_cgroup_charge(folio, NULL, gfp);
> > -	if (ret)
> > -		return ret;
> > +	if (charge_mem_cgroup) {
> > +		ret = mem_cgroup_charge(folio, NULL, gfp);
> > +		if (ret)
> > +			return ret;
> > +	}
> >  
> >  	__folio_set_locked(folio);
> >  	ret = __filemap_add_folio(mapping, folio, index, gfp, &shadow);
> >  	if (unlikely(ret)) {
> > -		mem_cgroup_uncharge(folio);
> > +		if (charge_mem_cgroup)
> > +			mem_cgroup_uncharge(folio);
> >  		__folio_clear_locked(folio);
> 
> This is unnecessarily complex; mem_cgroup_uncharge() is a no-op if
> the folio is not charged.  Sure, it's a wasted function call, but
> this is a rare error path, so minimising size is more important than
> minimising time.

Makes sense, thanks.

> 
> So you can drop the 'bool' as well:
> 
> +	if (!test_bit(AS_UNCHARGED, &mapping->flags)) {

I do use it once more for the stats, so if we do ultimately decide those
are worthwhile, should I keep the bool?

I can also put the checking in the stats function, in which case we
could drop it after all.

