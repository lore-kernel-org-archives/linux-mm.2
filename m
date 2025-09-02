Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25F41CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 12:32:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 480B48E0002; Tue,  2 Sep 2025 08:32:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 458C98E0001; Tue,  2 Sep 2025 08:32:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36E998E0002; Tue,  2 Sep 2025 08:32:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 262C78E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:32:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D7C941D90F0
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:32:41 +0000 (UTC)
X-FDA: 83844248922.11.0F4ED56
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	by imf03.hostedemail.com (Postfix) with ESMTP id D44172000E
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:32:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="g DjAI6u";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=A9R1ALHL;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756816360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+FtZglCWUX4HE6q7QPlc7pf6zeTQT7t5TN4Mt+TpGxQ=;
	b=wasE9pxTz6U5tWTIX4U9B7zD9nKhBwL8/c8PKxPFIl/7XPGaDFKgjKgFR58214NTtLbX2f
	dGvF6PozMi/qLKO9v4WDFeYVsHHiUNF8yUKOcYEOlOQYU7wvDv+tS2bim4Girm/PgOU/hD
	ZhnZrRMWYdMlM88n1/sDYKMfchpdxBg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="g DjAI6u";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=A9R1ALHL;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756816360; a=rsa-sha256;
	cv=none;
	b=oBbF7A9GkGEiQ9tihpms9Q1R5fLGKkVOfuR6x1UWtODbtkwN14/qDnRE4Me4mWKPQSEfRG
	ToyqW5cVgUovo04wNjPBAZ7CKdX5u6m4azSNdLgOaxBNu7/ol8hPovdHx+JkUZSzBt2Eb1
	0r7lJHe1K8NktolVP7C0LyqDAepLjmk=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 15A6E14001E3;
	Tue,  2 Sep 2025 08:32:39 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Tue, 02 Sep 2025 08:32:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1756816359; x=
	1756902759; bh=+FtZglCWUX4HE6q7QPlc7pf6zeTQT7t5TN4Mt+TpGxQ=; b=g
	DjAI6uy4tOZAnFg6ywGVrNbZtovdWrTb9GA/kYsSmyTuKMx4O72CJPJGG4WUD1Gh
	v+E+2DIqAOp9k1AEseg0pMP9ItMBtzc7zt+LUdng06++4CeIguUfZAI6H5F8LQnn
	YjwV5NieZtzPvUFjhW5mxDBKhrpqMqqFRmgnYBTg7QnGXrsmAV8+egtYg9P7EFgE
	vzPbzd76HwmBHP7fDdrM4AhYx1AuRYObtJxQCrwCCkaQDVZHH6j95CIOcfV9EbCx
	SVqtLkujYnCjbBJqQMAlfqPY7l8cG4GfInkeIZtYb+GGWIdwvzBdvggF1LfkQm5i
	5C990IapVvjBWFst8xB0g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1756816359; x=1756902759; bh=+FtZglCWUX4HE6q7QPlc7pf6zeTQT7t5TN4
	Mt+TpGxQ=; b=A9R1ALHLw5BMAc22+yvrl1UsjkuHI0XttiKSsVNSWHgiCvKWcdd
	CMM9P1vFA6OfXbG1SHjq3pnDytLxoeSKdlqB0ago1TW8LPRbojRLwNInJ4g5+e10
	lv4qJsM3+pcD34kA76YMe1dyAT1fJbotsZfTnF71FmN55nFd5ne4Frf4AJp1Xf6e
	xW67Mh7yW2/ekIwihKDdzYbnAh4OLKUyzfV8yddGXESbXhipO6cctoCn5u/ntW2E
	JhgOgqUs1EQ6HPyx6quuvxSTbnu80ZP9HndaY3KqHYu+UmJcSaRjnT51vT25hOvZ
	bvRQatEsW/Fpez3gZMOfsdWXNxXeBw8fLVA==
X-ME-Sender: <xms:5eO2aAx-bc5MVSpEeiZs0d8m01MOh8DtWGc2IWPYIghd9EHZ69kxPA>
    <xme:5eO2aPEEJq5xbYbjB98iOSvOnK-xKRKkQLA_7SZXV1hDw2ciaIu3-5uQZomTxZWrm
    t4lJx463DGCpE6YrCg>
X-ME-Received: <xmr:5eO2aAlt9Kx0YB2yyn7TRJzwIV4oDxhV_m6SsHS1iPO4-0ewiEDwtaU806DH>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegrihhl
    ohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpe
    ffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfuhhhu
    thhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtffrrg
    htthgvrhhnpeejheeufeduvdfgjeekiedvjedvgeejgfefieetveffhfdtvddtleduhfef
    feffudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepfeegpdhm
    ohguvgepshhmthhpohhuthdprhgtphhtthhopehkvghrnhgvlhesphgrnhhkrghjrhgrgh
    hhrghvrdgtohhmpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghp
    thhtoheprhihrghnrdhrohgsvghrthhssegrrhhmrdgtohhmpdhrtghpthhtoheplhhorh
    gvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepsggrohhl
    ihhnrdifrghngheslhhinhhugidrrghlihgsrggsrgdrtghomhdprhgtphhtthhopeguvg
    hvrdhjrghinhesrghrmhdrtghomhdprhgtphhtthhopegsrghohhhurgeskhgvrhhnvghl
    rdhorhhgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdroh
    hrghdprhgtphhtthhopehnphgrtghhvgesrhgvughhrghtrdgtohhm
X-ME-Proxy: <xmx:5eO2aOE6PJp4_Bc5G-nV6nFNA_UDXPzOgRuu07cAZCWMx2x9qMh5pQ>
    <xmx:5eO2aLy4hhF5Ut-29bvuurfp2q6EjmhZUsBMvvwQxd50CdcNHGoowA>
    <xmx:5eO2aPbag-AFmTw9IEC9R8mmnD6gwOZGDBYlImOqrQp4HK90Hd-oCQ>
    <xmx:5eO2aOla-vqKICj0ACORsiltZ_3PKgjqQSIBzy-2f8lxng6Nti5BFA>
    <xmx:5-O2aHW3cAmiLoOPv2T5qnWuUzxLYlWfKI6oEKs3cOg6Jsdi3yfmR50g>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 2 Sep 2025 08:32:37 -0400 (EDT)
Date: Tue, 2 Sep 2025 13:32:34 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Pankaj Raghav <kernel@pankajraghav.com>
Cc: David Hildenbrand <david@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	willy@infradead.org, mcgrof@kernel.org, gost.dev@samsung.com, 
	Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH] huge_memory: return -EINVAL in folio split functions
 when THP is disabled
Message-ID: <6l6f5idkqebpai6qn6n3phbnydz55typdwmvp3eexwnhk4qr54@otcgssegyqke>
References: <20250902084036.208921-1-kernel@pankajraghav.com>
 <qh7s3j26aac3hyzgnr2ee6byjenstxhjnlwn4qxbvz2l32ohqc@qbhdxvpnuhtp>
 <90cd5be7-cbe6-42c5-b0eb-bf9613047097@pankajraghav.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90cd5be7-cbe6-42c5-b0eb-bf9613047097@pankajraghav.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D44172000E
X-Stat-Signature: ocbeg99q4coagatuhxiw7s7zo6exxakp
X-Rspam-User: 
X-HE-Tag: 1756816359-648854
X-HE-Meta: U2FsdGVkX185q+sKyGauE64bi8/Mb4TnxESfZm16+k5NqHq25wEgLWUfZj/boqripy8GGCQluMSxf2Uzp8fw8XQWuBUQ5OTOXKx7oBbDJQV1uwy3J0ppvn5ZFoLQshJhTnSwFQd3N7O9PbwUQhFkDpyEkc5f5izb6BrTiLtMwE9X1CsNn0624pwLiYT8TkkzWomAyIidttHeRzfjYug3KqkqDXLKi/WsoG0NeAIhE2RzRewW1i2rBrJWPiqmrq8Pcrwzh252BwXuTLvrIXZXXHTsHBU9keYyrWMeiRtNO+Zsovdz1QH0CUbSgFd8M2eBIyr/sZoD/V6paOOAT8kPgY8ZkeGpJcebK3u7AOUPfvVBybSa61YG/9/lIsiPoyshyV3gQRblc3YEW1fSCfP1gBv/44agoQz3X2f7qtK4oks52GnrFYzdtaS+L0F9dbj8aiUyrRyLZDAPKy+NDNbwAWI4kBtZfVY56witxF5kKONYNEPb7IQTCVkB6NW20BPXK0bEFbcV+vsIYcobl2GpxBBq1RQfUXCO/9McTOqLvihZTs1X6hklOTPsPiYWoZk2mL36tKBlk0pmkRyGi1F5rMqtSVp0gcEF+Y1KzdMWZETuoVBprKeVzl9+b9oE1vhvfluCftcQS3U1+TgMOnsnZQTN0gLGJeHbwXKwkRjCxmYqBWcDQrpxmq/UPvFTBqXrzRW4RVbBvC+sOdfl3lWX4cIX33x5ACOW5CnT37u04ulWQo5p8BlXVigqrCyorU0eI8tL0cWVi7lrYHIko/Cb4EvJMGgllWuOOocCPWB3zZ031rEpYbGwmH3ZC89mM74wyWw34ThZXJcxZBnOE6H0nL0PrsGedKg81aJV1qzOK9/L3IsDyHXoq0GfNFOYyr6zgNiWhJdLu+YyUPlT1WAwhF9HiimqNV5ssTnafPDvThMANTg0ybtGn8kJDt32tYVSYM/Ae+Hz+Yl8+l5NGKu
 +ICwzWpw
 e+YufK/vmcGgQ2PNI31fqQvmL7a4StQ+nsVACF3w6ROv2st1hQXCsgQVEnKATwWJNyQyJwZzDxD+g8koNauTVfaGjxC8YdxA3WDfIo4x3ylkKcBviKPNZKpTddlNYNUhkhd2WsZWUToO2GVUlPsmCY1JT/TUWAiBM5R9teBD8af2PNLkF5gA2R6G3gEFhdj2jzXowIITcYjDHVWTN5OBJ5QHoX7JiuIUzASjyzF78zux7up8i6OEWJiXn+DYmhnn/0xMzPTfzmZQeeSoOSUHSf0MJ54RHJ3pmlFLZOIRhcAFY0RE6hSheNcUJj94esdHNlGz3Zd30+Ydrlg7HGVZw6EBOWTMOa0HRu8tlFcjtnaTlJjQp/LQK2hbi/iN1NBQuoPD+CPxEQUmTeCvj38xYbbdbMro2OoZnyymskIQWVdN6fTcgYn4uBxQe5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 02:15:42PM +0200, Pankaj Raghav wrote:
> 
> On 9/2/25 13:22, Kiryl Shutsemau wrote:
> > On Tue, Sep 02, 2025 at 10:40:36AM +0200, Pankaj Raghav (Samsung) wrote:
> >> From: Pankaj Raghav <p.raghav@samsung.com>
> >>
> >> split_huge_page_to_list_[to_order](), split_huge_page() and
> >> try_folio_split() return 0 on success and error codes on failure.
> >>
> >> When THP is disabled, these functions return 0 indicating success even
> >> though an error code should be returned as it is not possible to split a
> >> folio when THP is disabled.
> > 
> > Other view is that the page is already split therefore nop.
> > 
> >> Make all these functions return -EINVAL to indicate failure instead of
> >> 0.
> >>
> >> This issue was discovered while experimenting enabling large folios
> >> without THP and found that returning 0 in these functions is resulting in
> >> undefined behavior in truncate operations. This change fixes the issue.
> > 
> > Could you elaborate on the undefined behaviour? I don't see it.
> > 
> > If you argue that this code should not be reachable on !THP config, add
> > WARN() there. But I don't see a value.
> 
> Little bit of context:
> 
> I started investigating what it takes to remove large folio dependency on THP[1][2]
> 
> I have some non-upstream changes which enables Large block size (therefore it uses large folios) on
> systems with !CONFIG_THP.
> 
> I was hitting a weird stale content read error and finally ended up with this fix.
> 
> I thought this is a self-contained patch that can already be upstream. My argument is not that this
> should not be reachable, but returning -EINVAL will do the right thing instead of returning 0, which
> means success.

Okay, makes sense.

In THP=y case, __folio_split() also returns -EINVAL for !large folios,
but it is not very explicit:

	if (new_order >= folio_order(folio))
		return -EINVAL;

In THP=y, we also issue warning:

	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);

Makes sense to do the same here for THP=n. It might help to catch cases
we do not see with THP=y, like getting non-THP large folios here.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

