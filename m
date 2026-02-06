Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78565EE6B48
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 18:49:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 931BF6B0089; Fri,  6 Feb 2026 13:49:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DFDA6B0092; Fri,  6 Feb 2026 13:49:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EB7A6B0093; Fri,  6 Feb 2026 13:49:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6AB9D6B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:49:34 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AF5851402EF
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 18:49:33 +0000 (UTC)
X-FDA: 84414920226.12.D7858DA
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id 31C4A1C000B
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 18:49:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hseMd+A4;
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770403772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2PnF4DwLH70ap6fHwtiAszTynwFpgDYopGQkueAq9rQ=;
	b=Hc4Rh2KLb2Op0gZd54r4vYEBk4fycWYWsXsQEzLdbB3/VJR3ZmHVxCryi8HcSB7D3IZZ4M
	t+znMO1ZAPWm183+epsORWGTgTLRRa+DzP1VeXeDfx9q1IeoXZftN/mG/2WUPuv/Gz9B3U
	Z9Skzd/wzY5DcJqlfwuom86dJkDJqyA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hseMd+A4;
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770403772; a=rsa-sha256;
	cv=none;
	b=vJRok6AE4C3gKqBhgUkUvXOOPLW+E5M8gpW1RngKyD9R+dKOWlxT7z4ocLcwWqlsP1ieEY
	oa8vEaSt2km2TsD1uTBxx5xEmnYsAI3jz8Nwz3NmOgi2rfdRvtX7is8n66iEzxOj4G0PZw
	r1T66Un5hHb4z10IiB6jtsq5RkDd+Js=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=2PnF4DwLH70ap6fHwtiAszTynwFpgDYopGQkueAq9rQ=; b=hseMd+A4NenMekn6TuWNmdQ+e0
	4qm76n4cPfr3qAb3TCOs2A6YKC8lEIpsBZlhxcAyJO+gzy233TUpHagOH/WZ0LQZnVDgXJ118/BRr
	AA+o/DJmDL/i8aCCUrptRs3gCz7XjcBIsT6TcKaEbLIqgaViLgudML9roCSPQXSr48Z2daK7BomCT
	i5SjDMWHq8FfHt21eLCa9iCDPB/RwHVrTc2qwLYVSc0EcELM4FPJR4aAGrL3h3EnOVqFLy+RULXKi
	TpW1NpkKwPNnyBc8Hk60IuxW7803WyI7AwKiirubp3WKVA86NqkJko4AwcikUVGJYcpuYXpAjPNaP
	HgwCS1Nw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1voQtR-00000005d1T-3eHV;
	Fri, 06 Feb 2026 18:49:25 +0000
Date: Fri, 6 Feb 2026 18:49:25 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: xu.xin16@zte.com.cn, akpm@linux-foundation.org,
	chengming.zhou@linux.dev, hughd@google.com, wang.yaxin@zte.com.cn,
	yang.yang29@zte.com.cn, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: ksm: initialize rmap values directly and make them const
Message-ID: <aYY3tZmsIQnT0b3V@casper.infradead.org>
References: <202602061522548871ohgXN8z0qq87sTSX-yZc@zte.com.cn>
 <aYYIw3h35HOqodAb@casper.infradead.org>
 <5a1cf097-5ab4-41d1-a707-a709de6210cf@kernel.org>
 <3192eca4-1c90-44ed-8386-bf635db357c4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3192eca4-1c90-44ed-8386-bf635db357c4@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 31C4A1C000B
X-Rspamd-Server: rspam07
X-Stat-Signature: h9tokgi58ws5xa7gj1dhg5tr8zxsnqn6
X-HE-Tag: 1770403770-417800
X-HE-Meta: U2FsdGVkX1+TT1H/7EEcfG9X7KXtcCzEaIHVcv9wquLnSUrd0TxBD4rzmMdBMEhiHt4oaV0PaIQ7D2hf5vNDIdpGqj57jY9tCCir8p8tmUxfVRwPgAaxTa1XDQhyBQ7NNkGr29Ldx0DcgC/YrnGXX9n0+QwfN43cboOYfswzt4ecFkPl+Z0bhweBaK61yhjf6hgPKJ/bxLT0F6/38mtSMYm6FHh4GpFpxQOJXFzChbrbEk1nAl2vTqj/RRB/Kr+nH5wHrjhUiAfuKFmRGD3wE0OiZoQkJq0bgyTa+8nwcp9iMQRB8PrH8QJDQFO4nscKXIUwxIyYzU5u5lUkFu50R82ocopSawq678f8AtV659/NgbrhlR/Ow1drjxLnF0afc5L+2Kq9MGBgsuFVPZ1foGd3LCrvmcenRRsVYkYghLFKT4WXtX+hRR71GKEKTpkUFMq3q7ir74N4OQKyXeezDBUX23B4uOuzR8PhGjFco/JRPLZy2CfB4qX0wPm+psQMozrW/CYYqlYwBq0A/+o6pMiIRxWCdmeCPA+LHoN4t1o5prmAmMvzWxmLg8GyKijAGu8+nscn5HkuPFHhDMANKbYpSm0sT0tsDik5X8+4qOBs7EuJ1clIajCaRs2ToH1HUFn/kWi89pdKbgeZguxWTI6L4VzFZ2qs5QgZLN1vT55aFGV2NDHnw+8orQuntkLAbrYNlIumQz17mkgCW3jQ0QesDoyJ8NmhskOODl8hx5mbJVAPzGNA5bh10PIS2kFzrcOLJzz5oRhxZhGqSwPXNYGoov938dWxK0cWC40d+6OqywD6alkWG2YGLp2Wc+wNyoyhO9pV856qKlGuGnFCq1k9ipY8IbHnyUgDtl+HJFLRS1cNLnC8ppurcazQLvi62WeIPKGHpiO/DZZoDf0lvoFPT8dxshuWmdhAI7lwiQXHhK1Zkvi1k4sGdy4TJTH98isfZvBllzs6aTNB7LV
 0o1r+zyw
 Kkp6jWf6HMP+MuR4uEN4aFdRClgk3YMoAR5lhiq7XNz2lTgE4O1DiyreyWSLpJZzs68OBCocz7bsf8W2sh8c65Zo3hNPx5sZHU1/AkuGjmk7znuupNmbzSQYpCtnKdA6d4UfSRmw20RD+i2pMmE91B58Sauf51FbueFi/cWip/YNDYGSFgwJkXqgF6rCJK9JidFEwSfwczT0p/yvkKQ3fEAykhBlGvSwGer0CpSFmtIL0cSZcsgecBxTrH5OoI/1TIE4GxBgbDZ6Iq7UOwpoQN4oRdSonPFCOO0IsPpCJ0V0kSXQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 07:09:56PM +0100, David Hildenbrand (Arm) wrote:
> On 2/6/26 18:34, David Hildenbrand (Arm) wrote:
> > On 2/6/26 16:29, Matthew Wilcox wrote:
> > > On Fri, Feb 06, 2026 at 03:22:54PM +0800, xu.xin16@zte.com.cn wrote:
> > > > make them const to make code more robust. Besides, since KSM
> > > > folios are always
> > > > order-0, so folio_nr_pages(KSM folio) is always 1, so the line:
> > > > 
> > > >     "pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;"
> > > > 
> > > > becomes directly:
> > > > 
> > > >     "pgoff_end = pgoff_start;"
> > > 
> > > How do you know KSM folios will always be order 0?  I don't.  NAK this
> > > change.
> > 
> > Once that changes we can revisit. ACK from me stands.
> 
> And just to elaborate a bit: I don't see support for > 0 happening any time
> soon, and it will require significant changes that I am not even sure we
> would want to maintain upstream :)

OK, you're the KSM maintainer.  There doesn't seem to be anywhere else
in the KSM code which handles large folios, so this is just removing
code that was recently added?

