Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FBE6CD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 13:35:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60EA66B0005; Fri, 15 May 2026 09:35:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BEF16B0088; Fri, 15 May 2026 09:35:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D48D6B008A; Fri, 15 May 2026 09:35:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3C2D76B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:35:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E5B698E3B1
	for <linux-mm@kvack.org>; Fri, 15 May 2026 13:35:32 +0000 (UTC)
X-FDA: 84769751304.05.9B8DD7D
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf10.hostedemail.com (Postfix) with ESMTP id BBBDEC0003
	for <linux-mm@kvack.org>; Fri, 15 May 2026 13:35:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=L9djSpIL;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf10.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778852131; a=rsa-sha256;
	cv=none;
	b=dr1BiDTTBpsdsZVU3IG7/2wt9BxNGocShlnUVPyteAfhKZlqbUdSdgqoeQsdf+TmjpiV9N
	qYka/5LCzHFSdR017bbFiW2jU1AdKQ5FuAr3iTd4AOW3g4zrQJ4klOhfgHdBurAQpn1K+j
	RX/EC+A2LksmxfsN3MQqzfjEx1bv3wY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=L9djSpIL;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf10.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778852131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ebg+wR9TP7D2WHNKqGHf5dGHBXgXHb0yn/AVr65ZRD0=;
	b=YkO3hmCKyyLKRfKsxXArZD3cllziMwNGKrEx0yw2filfSE+VrP8C4kDoQTtkzrffniPr8z
	XPlBJqEMDEYLllsR+5umAz9NKDSJeON9CZVk5EfhbAs1ZmXrCBkeTtk49i4xj7NV3Aa4PY
	Y+x/3yeOZT5iMu1/fgg0LgKbyvJ1bkI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Ebg+wR9TP7D2WHNKqGHf5dGHBXgXHb0yn/AVr65ZRD0=; b=L9djSpIL7a8s3qV43JouB3oLC/
	qdWvRGb/rpIWKtc2Yn6AbgjmG/iFhJHSEvZwgK6gHyCKukXYuw0JRgmbm2LRGtXHtZH6Pkl5Xwrf7
	AQB1AGumuMqOK5Y3HwGyLGlEkBkmDTjdRxsa8yHeC0o6VeP3fIBXejoZnbVyw9teCHyFPk2esTc8Y
	vOnIjD50nnkxA7ZJZYXzELRr6tztI6hpn3VkuPWivstYfNsX6r1RuCBU5DMF66fviAZrDTfqs7ZJG
	JvacS0LwvplQmk6Q1mGWHNxwHJitERgNYAmir8kZiJvuuRKMdAbWzpKvgvqIVA9jJnD2dT3Y/XsJA
	l6cK8d3A==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wNshM-00000008STk-2mRz;
	Fri, 15 May 2026 13:35:28 +0000
Date: Fri, 15 May 2026 09:35:25 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: SeongJae Park <sj@kernel.org>
Cc: Steven Rostedt <rostedt@kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Ballance <andrewjballance@gmail.com>, maple-tree@lists.infradead.org, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2] maple_tree: document that "last" in
 mtree_insert_range() is inclusive
Message-ID: <lcr4xm7yqwxcodhpufhrmpysuhowiy3bjt4ptuk43o45ql2cbk@po7q6i2cmb34>
References: <20260514100723.4af0d7ba@gandalf.local.home>
 <20260514142311.119947-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514142311.119947-1-sj@kernel.org>
X-Stat-Signature: k6rjbygjrsmgu75ys44eyx6bm9e6ma9g
X-Rspam-User: 
X-Rspamd-Queue-Id: BBBDEC0003
X-Rspamd-Server: rspam07
X-HE-Tag: 1778852130-624375
X-HE-Meta: U2FsdGVkX18gjOT29B7368kiCIeIOQuHZV3zWsi79efzSlkTNkW4QfdBQ/Y1tESkZFSuWyoPXVkLd09K+wBfP3uqcCZ15XCpF8J/x9+3/rc4g3Kt5wvs1d5wTzJX9fWjQ0Saux/kojnnbLz6v77V5MpndUAoN5wW0zg2sNEqEMmL6jjWxFLhhydxucFjmnTVGNoEqcKxMJr0VrN58T8a7If7x7THdDHfzzy4Uo3eKZtxJQjFsDjJIXca9KqRssrekoKNiAQW8poqYzOWuu5oDjJkkSPzZeHFwNlmCsdGJfkI/Vp6S21O3ADXKcV2odxb4mFggMTYuEwlFFvkFn8QbYxJp/LYifx2Fe5sSnOgGgyw1uyH3zpuPplOew/A0sUdkn4GxJ3SkCL50ZpTcvg7f3Itibla8eciTjLdtIYDWxXqDSBnNziURW8YpDb7+5CLDh0qFKXG4q8OdspV/J0dHK45f0TyFDJBn0O0qPWNH5yj7y9uYk7nMdT3W2FEam0WT+MCj/sY0wfypJd1jHrj8xHZOJ1ejwgqAcpxIm7KGatyZXHPZNLbRtEDYEmLtiS2MQTgifjU8JtYG2p1fQm+seJAjAMUwuo2oSHidHrrQC0t2blxKosuIZpz058Revel4B4OwJbDWogVw1h0x9bWcm2KI4J2LQVj0bsvRnfOpikztTLC1GiyvC4BUR/6vgksNahqtwyQYYJWD1zGq5dCY61uQkiXNyl1BhZtKZvLLV1Ae3vqvJrRuRaXXTLL6ypMyvih3/aspAMd8FcB5eBCEROi5TcShE7ZGy0jgv8T1eSUHUJhMM/MnMjBkO/zJcHDIeyNxJe5aC5JQOugExPI8Rp3xMWyhfgj9sLAGw+F8yjAM5XMGiaB5YNUR0s75Qgebi1YCSR+/syShmTsSNjRsmA8AMW6DvfD9bnoPbQX97uM0+jXR9eY1K1Hbq4FZSOW/wga6twzfNNwl59Ll1F
 nmHNBmFT
 yP5Y8BjXe/ITu3yriWX6Gxz7NEWhmwn+xcfamziPgE1ut1Ppv3kcPTV93YKJKm3q8qMajpY5gnUR3CuGdbQL6qRajnBGj/i2fn5qTZ6TNjaeG68gwGCQm+KJTQsfrDc68ylLCn2KZotMue/QdmIoCOTvGcdQvIVLdT1CbmHUjAAb+23aNHcWX+E/YfFMHc81kxcFwFU9Bxz/MPqr2yddwhjeJNCj0ToC6IAxEIQP/woKuSB5QdHt0PnibJGgJPfTDISao7TSaJrFdRsesIPZrfaCAr55jrg1TZoQq71cJLj9n1sAfSnNBtgzo4nCkIPG1vI8pzi+zV1yuOCjgl/g6Ze9UA/Hkvjgwu9bZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/05/14 07:23AM, SeongJae Park wrote:
> On Thu, 14 May 2026 10:07:23 -0400 Steven Rostedt <rostedt@kernel.org> wrote:
> 
> > On Wed, 13 May 2026 18:42:04 -0700
> > SeongJae Park <sj@kernel.org> wrote:
> > 
> > > >  /**
> > > > - * mtree_insert_range() - Insert an entry at a given range if there is no value.
> > > > + * mtree_insert_range() - Insert an entry from [first, last] at a given range
> > > > + *                        if there is no value.  
> > > 
> > > It feels "at a given range" bit repetitive to me.  s/at a given range// ?
> > > 
> > 
> > I just added what Liam suggested.
> 
> Liam's suggestion was very sligtly different.
> 
> : Something like this:
> :
> : mtree_insert_range() - Insert an entry from [first, last] if there isn't
> : an entry within that range.
> 
> So I assumed you intentionally reworded it, but might forgot erasing 'at a
> given range'.  English is never my mother tongue language, but Geminit also
> told me dropping 'at a given range' makes it bit easier to read.  Hence I just
> wanted to check if this is intentional.
> 
> > Should I send a v3?
> 
> The current wording works for me.  English is never my mother tongue langauage,
> so I cannot judge.  I just wanted to make sure this is the intended change.  So
> I will leave the decision to you and others.
> 
> If we decide to rewording, I think Andrew could help without asking you to
> resned v3 for such a minor change.
> 

I'm happy with what we have.  Steven, since it wasn't clear to you
before maybe you can say if it's clear now?

I think I'll have to look through the rest of the function documentation
to align to what we've decided here.

Thanks,
Liam

