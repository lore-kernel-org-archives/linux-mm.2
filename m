Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E944FCA100F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 16:13:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 535C48E0005; Mon, 22 Sep 2025 12:13:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50D828E0001; Mon, 22 Sep 2025 12:13:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 423D78E0005; Mon, 22 Sep 2025 12:13:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 308C28E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 12:13:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E0A42117B86
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 16:13:34 +0000 (UTC)
X-FDA: 83917381548.04.C82BD8D
Received: from flow-b7-smtp.messagingengine.com (flow-b7-smtp.messagingengine.com [202.12.124.142])
	by imf05.hostedemail.com (Postfix) with ESMTP id DDEEA10000E
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 16:13:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="T Qnx8Yd";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=hi0s1aBr;
	spf=pass (imf05.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758557613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dL1BvnI43qIxZyYhkmHSIoN6CjGw1NlqI0MDthq8w9Y=;
	b=EejaQdBCDHjggxNZ8UwWC/UMhxVMHDsQm2qOxXy6htBg7KZEe0bZDB7lYpEOgl8/8pD+Wo
	w66p/4ceqFVz9CwTyVJWpf8fXCg/tmp4FXMerPprCJGnOfZ1W4JFuy1euGeCrvRJN5QDGn
	cGQr6O09nokL9uD5hyJJtlfrHas48lE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="T Qnx8Yd";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=hi0s1aBr;
	spf=pass (imf05.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758557613; a=rsa-sha256;
	cv=none;
	b=R2jr39LxhM2LUVYb54c/bR6jbhM/G0x41hgleEhoP+te85FFjW1ct8hCG1lwOL4Bswx8yf
	bnPwksGjiTv9Eqlk0ixBhL21Uk2PeWHyoT+9k8l+teiBNUCPl3ClUfhfXYPuv0HpvEICAh
	ULG7YbX8XVIomHEFfjBpEpsszmr9huk=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.stl.internal (Postfix) with ESMTP id 2B6AF130096C;
	Mon, 22 Sep 2025 12:13:31 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 22 Sep 2025 12:13:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758557611; x=
	1758564811; bh=dL1BvnI43qIxZyYhkmHSIoN6CjGw1NlqI0MDthq8w9Y=; b=T
	Qnx8YdlA4Bixu00SPEK/E8uvAGBG2ZuirkZjqZKZo/wDFN0WRIAnizm/yvSZF83x
	BmdlJ1RcJUGgsSjj5tzUcqK72WaHBV+mGoM5OxTBVe7bceH5j20FSqOice/U0oV7
	tZYQ1Ko5CkWnQVtzfn7WPvH/xo7CYZL7b7547T7LvGfS0DriblTobFRTN/ZotfzS
	VygQDe5ZZLfa85WItHWDmaBdXLLUGDkL8W4Xm2t1bm56HjRd6T4h58i0f8CQnmao
	f7qsQzt3/W4GLfKWViAGC7Co59zUGTHF2Wa8plaJY+lS/V0cDghQRSp1P00i/l3K
	BXBMkDs2RCFcwmPijizdA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1758557611; x=1758564811; bh=dL1BvnI43qIxZyYhkmHSIoN6CjGw1NlqI0M
	Dthq8w9Y=; b=hi0s1aBrjyLf7KpNYh61eeN/01oa41y0Twc5U6m79rDCb53AYb4
	EYQluMA77XCpQZEtclcH/mys9nSq3mE2eLvage7i9Lt5t9uW16XinFd40gSaFREL
	9mK6m6wv3FLanJ54jQl3rkqMYN65XZYphC+w6nXrioR/4UCuYTCx7sv1uneAWnFA
	QKq5vC7kRGJnDTn2wqHRwgGkdegNVPtt8CBiveOxIjkkDH1WPp2+MXObGUG4SG47
	VNUk8j/rdSWpXgZ8TbHdGTlJvgalTY/wfDmbr1cGIIHT8QMWHLHhE1qmdVr69+aY
	OSZU7yGdV4E96BM2+tEYdCgmWjWIZacaiGQ==
X-ME-Sender: <xms:qXXRaK5-PYvzCD-E4oS9Ik0F6FYumOp1szuHE9oykxxD7AxwsUSMEg>
    <xme:qXXRaBj_BoMm96RPO87hvhtaaQ1FadVMcam7rJGq8T0xnuwbqlZMtlrGi2k6gMc_G
    zYFWYtXsOml9aSULf7uOiQC5ypZsTaOSJ5iXAXvQNY_kNpmiWDu9Uw>
X-ME-Received: <xmr:qXXRaA2_gtxaz7-WQj2u54xSP0sG8CImf6lHFwbpocnBaEsVBXDTUe8sVGmI-g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdehkeeftdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeejheeufeduvdfgjeekiedvjedvgeejgfefieetveffhfdtvddtledu
    hfeffeffudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepfeeg
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehshhgrkhgvvghlrdgsuhhttheslh
    hinhhugidruggvvhdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhi
    ohhnrdhorhhgpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpth
    htohephhhughhhugesghhoohhglhgvrdgtohhmpdhrtghpthhtohepfihilhhlhiesihhn
    fhhrrgguvggrugdrohhrghdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghsse
    horhgrtghlvgdrtghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggt
    lhgvrdgtohhmpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgiipdhrtghpthhtoh
    eprhhpphhtsehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:qXXRaPXSdJN4P154GrwvVLIh1WSMjw0ByeJs2_M-9ZHvnVz7bW_O8g>
    <xmx:qXXRaF2oCbgrdnQipG4V-EJDmcNAtLy5ujm7sjce1rHVBZzIwq78qA>
    <xmx:qXXRaIi-q8guWTWB33mTkkr8Rc5WfOmsH_jJntYH7t0pCfpYHv4BKg>
    <xmx:qXXRaNKajF62yjoOdyjGK-bBpSpiA3k19zT7_TB0fJf3AglwuNL7Yw>
    <xmx:q3XRaE7y_bkgd_zKul3O4e5ZFYOdeRkuQziAifMzK1YenzemQPgDJ5iZ>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 22 Sep 2025 12:13:29 -0400 (EDT)
Date: Mon, 22 Sep 2025 17:13:26 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/5] mm/page_vma_mapped: Track if the page is mapped
 across page table boundary
Message-ID: <wnenjcqvr2lzqaqnxyc6tbtd7smv2hepajtjxl72kundsfaisk@k2mlxpzuzhbv>
References: <20250919124036.455709-1-kirill@shutemov.name>
 <20250919124036.455709-2-kirill@shutemov.name>
 <7qkpt4ia3qryjp2xo2ywy7qydav6nijghasr7biwctd5ah7dat@t3epq5dzt2sd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7qkpt4ia3qryjp2xo2ywy7qydav6nijghasr7biwctd5ah7dat@t3epq5dzt2sd>
X-Rspamd-Queue-Id: DDEEA10000E
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ntiguz4xhdddbsmwj58io9zwp415mq19
X-HE-Tag: 1758557612-419575
X-HE-Meta: U2FsdGVkX1/Ra+50h4xBFsIoEf0mwg+REqQ7FSh6jHNffb3CRRZkyfGHpvl96sLZiNrtimkrFcSsfDN6wZ+mpr5nx8yqa9Nn6Bri4Kl9tXcKvQGYl2pjDKomELkFNLCniqXCq0v4wUzQEezqYiHWL3vjS/2xdk1AURTFCt8icBK17kWB9vfXZbbno079hmYurz/Avc+SqurecOn86WwgWcnIProaki2IxOjUG0skhy1G5uGfvsZxH/uCM+ekNU64oFT6HEfl7mWdlr9OtpPScp6zhtDwPuh8N+FfDY5dKeCLczXs9430PqUiEsoTW6+ol0B4xzC8YFU/27fqXU4MKnUVZdwx3AXNQRzVpYH8MAqnEePsyp8tX0MVYVOKZXLimuXGXfKpmO7ip0SWz48ZFeF9uZBop+kLtscpOGrgR3UDV/tahd9P35XHlyj4/YYr4io8hpt5rLJu7CgeYo0kQIdWyBbu1Ikopu6CxSkNRhI0ZS6SlisHqoXxcK1RJ+io8DvVtiNlaZpmsVaHCc43obvg1F9tUulNWTk8YjZuU+DmKoDmHyfqitH5Id7cF7oUV3SR+TsVjeXlpOX+77VGEkddS3OoJNUVIZU2SdusPXNJf/cr0x5uIyZyzbnYCH1zuU9vavDf0WlkO72ZTPqSyhl16U9qXiA3UDtjfWhma/h7NId+KF7sSLi6w1dKjq8XGMCTMzbYq55fLqlYhQCoO0VBz3I115B8kxe/6LPGb/OzSb2aL3aW/Yew1gDR/OqEo8EY49OJo0Pnqmx63cKF2Li0aFNMkvwoJL4FLrMtam6z+TmZ0IO0HzjHOYRL4VPdv9kK6C/9rzLyjIGM69ndTXTQsGR8wHc6CohoXfJDoU0r7/Elo0tHmHn4w4f3jPMYO7Y60Tj/SOAPOANncFTz5/bMHcXPmBUWGTkzD8/NbcXFLuPmNUgh0FsvEwPz6ScHddMz12nCvue6jXfF5jW
 fX5VL+nQ
 8Lk6QV1zE6hJU2H5k2HdbRldVf6XK8caDPPrEChl9tK+UPZ5S5/s/CIZRdOOTFKUY3/izmENpazo+84tHCaXogBBLmP2k29jLuJn4NUxWwUHO174XdOPBUMwHZpvgh5jROHwZa2zIovSOKdxT0BFflX1YPeLN3itTac7N9+vHdkY3lDkj740YoKgR60IX0EVUyzR7AINavjz3NjearNnXPh8fhSeHkkDGFacsJp5BkmMiiVkp3GK86rKao3FyG/BxaN2tXDfGSu72AD+vGVP7PJN+MPQYHHzLKyD4381IJ6O392VkB90wmDoJwiG+qZ8ai9iSwrUUaJGnAMsS94Fm9T2Pq/mCtiGGfPcnZK0auoVmO0dRvDN6VNHdUq9eDZfrI21SNk0Oz0m3OPjabLeaAWmtMcsvaETHNfFYNUvrXK/rCjdofuk3AP67Om/VX9x3HrNQqOKJRoe6TRpirLpTjAlXaItGWII37HupmwrqAAZ6eSrhChRvpFFAh1KbhFxIifSx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 01:25:36PM -0700, Shakeel Butt wrote:
> On Fri, Sep 19, 2025 at 01:40:32PM +0100, Kiryl Shutsemau wrote:
> > From: Kiryl Shutsemau <kas@kernel.org>
> > 
> > Add a PVMW_PGTABLE_CROSSSED flag that page_vma_mapped_walk() will set if
> > the page is mapped across page table boundary. Unlike other PVMW_*
> > flags, this one is result of page_vma_mapped_walk() and not set by the
> > caller.
> > 
> > folio_referenced_one() will use it detect if it safe to mlock the folio.
> > 
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> 
> Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
> 
> > ---
> >  include/linux/rmap.h | 5 +++++
> >  mm/page_vma_mapped.c | 1 +
> >  2 files changed, 6 insertions(+)
> > 
> > diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> > index 6cd020eea37a..04797cea3205 100644
> > --- a/include/linux/rmap.h
> > +++ b/include/linux/rmap.h
> > @@ -928,6 +928,11 @@ struct page *make_device_exclusive(struct mm_struct *mm, unsigned long addr,
> >  /* Look for migration entries rather than present PTEs */
> >  #define PVMW_MIGRATION		(1 << 1)
> >  
> > +/* Result flags */
> > +
> > +/* The page is mapped across page boundary */
> 
> I think you meant "page table boundary" in above comment.

Right. Will fix in the v3.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

