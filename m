Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFCBDCAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 10:04:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 194F78E0009; Mon,  8 Sep 2025 06:04:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16C338E0001; Mon,  8 Sep 2025 06:04:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0822A8E0009; Mon,  8 Sep 2025 06:04:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E90738E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 06:04:25 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A514913C06E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:04:25 +0000 (UTC)
X-FDA: 83865648090.02.6E81B6B
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	by imf20.hostedemail.com (Postfix) with ESMTP id 853601C0005
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:04:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="g VcXfc7";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=CNzFogvQ;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757325863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ocQm+Cx5HaA3JRxkViaGMCKl1e6yY4brRhhfHmKmFgI=;
	b=itIa1VCmibGDugIV6VeT5JLYr8tFk/nbmoOa0ah7Cqe30DoyJrxHXgv6DzPfDPwJwrOMpS
	WzuZWTWub/Hg05oIyv9Wm1w3PorCKS3flIWVakVD0XFhBT3hwJp8p6iDGQkW/QkNus67DN
	fkbXbxvySK4JdLyXDppG6rJ7rimqdWI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="g VcXfc7";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=CNzFogvQ;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757325863; a=rsa-sha256;
	cv=none;
	b=017+3q6xcKGjDzDlses/ZRwEhZWDaU4HgpG7hoF+Wab+QjuT99TOsaPKeMOBwpBgRkI1O0
	OffikjOb6UvVUxTwNTyopaqUWr2Nk0ikqPies7VQmQEpVAHWBaaNVkKsRN7fDuUrsMput3
	EmoD6juWCnOFPKmwz/7kCxBIRP985/0=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id 45CC21D00118;
	Mon,  8 Sep 2025 06:04:22 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Mon, 08 Sep 2025 06:04:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1757325862; x=
	1757412262; bh=ocQm+Cx5HaA3JRxkViaGMCKl1e6yY4brRhhfHmKmFgI=; b=g
	VcXfc78Z2e8xAlChTaBJi3jd3oerp3P+FSAzk68oeIAIosKdW0s3/p5AmB5mbIey
	D9Gt2NGYQpERkVKr05nc/W7kKb6O95vsEuXM71cqcySiqxUoZykPYYJC0dZepRff
	42WqxXZAJ4IESpeHbMRWV64GRO63dz6Z2uXdXiBA0ctG4D16eUJU0sKQSn/ZAR8L
	fk3QeG421dY6vCmRFALvGku2sOTY/6zTF07Dkkba57eZ4OCZ+7u3Rwc1CGRv5MeK
	pTXjR+ZFeVdoIImZtK7M+agQB72h1GieNKItza7l6N7IRG547m+UxM4KiPKADgWB
	+ZCoWv0q5JzgVyG1D/bFA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1757325862; x=1757412262; bh=ocQm+Cx5HaA3JRxkViaGMCKl1e6yY4brRhh
	fHmKmFgI=; b=CNzFogvQoR7QCadj1AyZtjoc4p0cTtIm9ZUr5WlxHyalVv9Hp81
	r/fOxegX3BAGsuJDDtELeTB6LBH1go5OagKsrMBuunaUSjN37DZatfZYDV5K4WCP
	K1q6846nVgPx2tC08llKhCM/wX7ggCOC5xb20RUL5TaHkwjatfbnCk3xSu+djKkt
	M9tHFsff6mt7WIe/0F40wedrRiSQ3D0Ml8SlMg2QU/e8Lo+7JOiup1xM5ZdU6Aaf
	5gnjT8m2guuJpUOZNb/pH2JvpHYoHPLS5YIA8U9kPIPrLtY8WhcTXL6gMeSgFuhu
	qnP1DOKYoUnfbwYeKfenvVQ4OuVZOr2ov2A==
X-ME-Sender: <xms:Jaq-aNWiYY7m68nN_ND6HYAm_YQEpLsvdrWbjvRzk9epSQxC7rFhqw>
    <xme:Jaq-aEgQHT8sd0eW_3Fl6j8ZNy8cdC9kS4rVfeYQ-Nl9a5XzxSMS7uuN3wUFvPlQI
    3Sb6IYRrImfmwuqrTo>
X-ME-Received: <xmr:Jaq-aOfwTyCnQ8TpO1Yy2O7e0_oHwRV3oHVEWQrCU0q_lDXkh_jA7ZRRmS7AHQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddujedvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeejheeufeduvdfgjeekiedvjedvgeejgfefieetveffhfdtvddtledu
    hfeffeffudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepvddt
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorh
    hgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdp
    rhgtphhtthhopegurghvihgusehrvgguhhgrthdrtghomhdprhgtphhtthhopehlohhrvg
    hniihordhsthhorghkvghssehorhgrtghlvgdrtghomhdprhgtphhtthhopehlihgrmhdr
    hhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepvhgsrggskhgrsehsuh
    hsvgdrtgiipdhrtghpthhtohepshhurhgvnhgssehgohhoghhlvgdrtghomhdprhgtphht
    thhopehmhhhotghkohesshhushgvrdgtohhmpdhrtghpthhtoheplhhinhhugidqmhhmse
    hkvhgrtghkrdhorhhg
X-ME-Proxy: <xmx:Jaq-aHdUIyB4VezKBDDBy5ZJbiZGZ6p4mFxsOK9_y_JIkuhSGdSNlQ>
    <xmx:Jaq-aCXVAJe_FvCu0la-MiJ4g_eknfVrG-Zhf17b67aIMoJpJL3_Sg>
    <xmx:Jaq-aDfWxxuoaTma4qeem30XU58IRh6w1s4QA5Pwmmc_oI13_1wO9Q>
    <xmx:Jaq-aO_ni76um9zTeCKnyQpjz27w9opUJXqNKxtlNS_pUiWPE-VEsA>
    <xmx:Jqq-aNCMoTakJUJ7tKTjExn9rdSxTD0fk8_UcMrHedFlKf-TVYR4Lhxw>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 8 Sep 2025 06:04:21 -0400 (EDT)
Date: Mon, 8 Sep 2025 11:04:18 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	Usama Arif <usamaarif642@gmail.com>
Subject: Re: [PATCH] tools/mm: Add madvise tool
Message-ID: <xmcf26bipejct4hisz7qcrs5lkt6d7l6pyn34bm4552dv2474n@su73w4xdlemx>
References: <20250904175729.1029735-1-kirill@shutemov.name>
 <aLrCfvlhWRCEmwXc@kernel.org>
 <txdm2edac7x6bfxcnjri5g4e5qoz4qhbtwi7bpdta6yqeseroo@iqspqwpo24i5>
 <aLvqJKtOgGEZxPeN@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLvqJKtOgGEZxPeN@kernel.org>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 853601C0005
X-Stat-Signature: 8wg4615cmk879ftpnfnxy68yx66ipr7d
X-Rspam-User: 
X-HE-Tag: 1757325863-644122
X-HE-Meta: U2FsdGVkX1/MTpucZELCw2UD525YRzu41Px6ML9D6dBaq/NVX6zteGqKoyFQ+orKKOEdbnEKSChSaRM7WDTFkQJZkR6VQIP2LdMG6ykWp8X4Q/WtDIkgo/RocV8YSLhakkBY7iBmQmA9de0XMhpO/IDRBnKfEZwb0yf36NsS8T0mDu6gJxTykqiOX42wVtGdgS5EWB9wqF3oB/ZXMn7kTawg43ZXq7DZHbHMsIT7p9sVenRwa8OuoNBoAWagn2kJ1yqHBUZM96WE/9LU8t0F7w665+2E8eppNuxYPc4zvVg2ZLmOd7m2y2fZxmWV+/IJ+s5EB8C7dZ1Y4XvdUo0zbpumaN1t5fxdolPcq5Z9uaXihM6XBdkqdj6oTA8wJxAjiSXMDEJkvqosDpBo8ZviIZzr8QxQEOFcnWdRJs2jO4HCsfUGbEcq3exn0FbvxHm7HTHiJlsGvk5kh5Fg//oChMO3CM/cDkAJNXRp9UEfi332OF0VQYSdQc+mFcxN4EDn27pt+0g4bXUwjGayJsYVlkK63sbGJZgVt9D7h+Q+34nl+CQhVdrYvERNq/DTtSFVmvDobZO8xRerhltBzxdmJbNyLQhWOqJpK0CZDoZyHuzOZcYJrBvtezfvVBjd+T/1JAcRC3fWSOKPdmdqnRoi0qbV03UYjbfOsI91F5zXxul+GawPw/xIH+39WoggGHBeZj64zMJqkm603M+hCEATOONRdCVi8shzea82eOB2eTb8qP0r0H6Iu0fV2a6916cs3/PPAt234IhoFtKEv23TDkGwYMS32PWhbQwHmPLNOyj0+N4qmf7NJRq+fD1X9b0cMzAR50+apugo4C0CqYnPYMLt3PD1AWDdDHcPGMssy1HCByuBnmXH53mm6gYmzOHs52jZA9S+0jTedbnYQdbMtljH1H3P0vhVJiQgNfA38Db9JDQeQGTVrHpPdRKCVMY+Q6qDVRQdeO9VM38nBdg
 Ilh/fYOh
 6+HlnsG0xz5JrmHyynub1xv9c+inO/bhRJXYOFumSvRWOH9XE7wfN7FGQUFU1fisZhih1qcVV7iTFkSFOGoHSvNACdPOh+BgcUbvEx+/a/Bi1XI1FV/NR2MB9x9oUldBQbwrQkGh6hfOC9lGzbdNu2kUEsqXr+S7ae2iu7FYs4xaP1JxpNFvzsyRaXrcYEQL5CXMKxkNCRmaMfTE41E3dAXHACrGU9LrGpMvvzCHtwFV8bSNvSDgD8ryccTrAl18qIDE4yOxgcYpq3f2Ym2U7Ch89HO+NRh1Obvv55tWCBny2Ph/6aYlmmbgERqiQnmu/c/eDhCRtJcuYIn4Ionf1mYbtE4VWFyX4Zb3lpoLo+DMkVlCy53j4fgOD3O/lyd7A+H54PfK0IaMw+9xpXCqVHW/suUowGDp1gwrJtJZGEJVhSA4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 06, 2025 at 11:00:36AM +0300, Mike Rapoport wrote:
> On Fri, Sep 05, 2025 at 02:36:36PM +0100, Kiryl Shutsemau wrote:
> > On Fri, Sep 05, 2025 at 01:59:10PM +0300, Mike Rapoport wrote:
> > > On Thu, Sep 04, 2025 at 06:57:29PM +0100, kirill@shutemov.name wrote:
> > > > From: Kiryl Shutsemau <kas@kernel.org>
> > > > 
> > > > Add a simple tool that allows to issue an advice on a process or a file.
> > > > 
> > > > It can be useful to experiment with effects of an advice on a workload
> > > > without modifying the workload itself.
> > > > 
> > > > Only supports advices available for process_madvise().
> > > > 
> > > > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > > > ---
> > > >  tools/mm/.gitignore |   4 +-
> > > >  tools/mm/Makefile   |   2 +-
> > > >  tools/mm/madvise.c  | 170 ++++++++++++++++++++++++++++++++++++++++++++
> > > >  3 files changed, 174 insertions(+), 2 deletions(-)
> > > >  create mode 100644 tools/mm/madvise.c
> > > > 
> > > 
> > > ...
> > > 
> > > > +		unsigned long addr, hpage_pmd_size;
> > > > +		void *p;
> > > > +		int ret;
> > > > +
> > > > +		hpage_pmd_size = read_pmd_pagesize();
> > > > +		if (!hpage_pmd_size) {
> > > > +			printf("Reading PMD pagesize failed");
> > > > +			exit(-1);
> > > 
> > > Shouldn't it fail only for collapse? Other advices don't depend on THP.
> > 
> > True. But aligning everybody wouldn't hurt.
> 
> Right, but this make the tool unusable for kernels built with !THP. 

Yeah, I missed that.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

