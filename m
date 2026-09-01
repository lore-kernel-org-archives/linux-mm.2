Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1BFEC624D4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:26:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E57B6B00CC; Tue,  1 Sep 2026 09:25:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36E216B00C8; Tue,  1 Sep 2026 09:25:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 236256B00CC; Tue,  1 Sep 2026 09:25:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 010A56B00C0
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:25:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 81B9B1A040F
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:31 +0000 (UTC)
X-FDA: 85165265262.07.68C33ED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 75C402000E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GxUYEHoO;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788269129;
	b=OvDM8vlHcrWtmrpiPH/D/ggNxcINN9kuwx+DLsOORfsXOL4c5GBj0NvtD9RPINxD4PYo4P
	YrSSA3bUX4+TH8y4xl3FvDhIVr8PczJqtaLtZDkkAM4DqUZxh3kvwlOZ3TBU9XbGqDVPxv
	Houh9ZWDUhhigWcpZ1Ke71L1U0XY5ww=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GxUYEHoO;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788269129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GjkoT1gxvL78iC9qUQ1DUbeqA6ep6ohbNZ7UjlvHRxs=;
	b=BFan665995wAfZlyKo4XlQ2DldGutpOg6Ayu+IYHgS+XIVZGm+eA0vH+dr2XbuDfq6PTuy
	bZ5UJGQMB/fq7jz1HZxY2WmSUiem042L0yMZrScv+ffBoWUNgpwDRC+5qacXjyIdyCWEeF
	Ulih60ouvtJ8o9NunGpWbe6g32xLxs4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 109B760A54;
	Tue,  1 Sep 2026 13:25:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F2AD1F000E9;
	Tue,  1 Sep 2026 13:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788269128;
	bh=GjkoT1gxvL78iC9qUQ1DUbeqA6ep6ohbNZ7UjlvHRxs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GxUYEHoO00HdfaVkssUElaOpXc26GL7n7K0UP338xb1sdyYbLd9XCMD2Nsz70xrey
	 s2NVkTLmDsADQvfrZa4iSwkBNsCu4231Sv0hpW5T/hctM/NJAv1JQu3rcAn1ZwguLo
	 jWzRBEthdXwCF00I4hvOy3T+1l1dadHNZUdEtClgmnOMQfRnHzbYdn+HkGPlOamQ5Y
	 IsuScwhcCiyjEaVlSINR8ac855kwW5x7txObdP3myKUwYo+nsaQg5IFeJFBQ2LTkHb
	 X4ZruLx3ku3GJXuRBAR4Ef/ZBzIR0BkhbEZkgvYvtHg4N3XpDcH6Q7r79iWB4ghlG2
	 RWWPYXaWisNeA==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id 986AC198003A;
	Tue,  1 Sep 2026 09:25:25 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Tue, 01 Sep 2026 09:25:26 -0400
X-ME-Sender: <xms:RdKWar45zpB_vsbUR8UzOreKewyA1VITM7TZi-t9bhdGK7JonuK3-g>
    <xme:RdKWaocZaUVLpwM_ztj_c6ehWPCXojyWTp8qF4nCc6ZZaIAgLx_kB7u0OPgjUtwoo
    X9ks_vkUlPv5E_w2uXx70JIBDK_IA0S7960VatVAWsmb7u_sTyz-Fsr>
X-ME-Received: <xmr:RdKWaiEzzq-z7gav2AfzuOrhYtio4g85HQZXGKkP3MpJpAM_3klNZfFjFmY>
X-ME-Proxy-Cause: dmFkZTF/zIups+nPbokX8UKm482kR7kMGorOCvM9dp0+cLB+pCykGtcbZY05LQacwdhnLX
    jfsd5gYa21u1EwH01eFAsZxyGms661mdhfrgQ5daWtupEuHrYChNpKfKzNohEcLtwsd4tz
    2z9yaU1GFL78g5y0O897nRdxoP1JxqCAo+htkT0VOrJFjYw1l0K10KoF5YBznBZws+BTi8
    3A6IjAe5+eYC8A8BZShoPcDSEEvu5HUQZoq/GANPP9XbB2FlqiJVwCsMx1J9I5wfq8HGKY
    QfN34QoBXAMHz2/t0VKchNn7cOmSsX8ro/UDTX1nCcyU4R8ru2TkT2OGrHj4v15kH8zZAx
    eUqN2BRuKS+K7M7M/2NKXl7+6JYQzQfiGWG+WtWaAAPOQIlzJ0PocvWxntXf96Ui0d/NWM
    a5DWgwfgtGMOWIfInxTC2aJVfrDv2057TH8oBrNAvf0sN5H9+SiX/HmKRnZr4cxkf91D5w
    E6k0WKDQNQL3JbuRreO3NpNsimDym8+KhtSky7ZQCLk+zQV7ee38Q5zZnORrhUoiyrSfYn
    5ukvKky/3HsCWcXxxiKzaogbCZ7H9rXD8XmMuYpizQqlV0Lg11QpKHHqm7Xdv0N2t54Fp8
    39UfA3On+TxieASdh7+WEo0ZBveGoWfESQtqZ3JxCleRUPDGmzm4I0y0ABow
X-ME-Proxy: <xmx:RdKWao7K2pDGB1SatppoN-lt_7qNYaEwgQzawFLKSELvFOnrK9SFDA>
    <xmx:RdKWaltaXTJeGvnwuNe-_9vkEo-2QwAU3hqqfeFmPwuxxezlhXJYBg>
    <xmx:RdKWas94V2Y6q7P1oy5S1EgGjNBHmgCzI7axArEXYl9cmDLQnGuU4g>
    <xmx:RdKWavmFmIDSRuyxl4z6Go6Le1JGXnYZA17VHG5a2iFyyRnQMCvReQ>
    <xmx:RdKWasMMQQrQAymUXvvL9YvpPnnYhyFvpdE5wzS3UVoPfpwRjoNEpm78>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 1 Sep 2026 09:25:24 -0400 (EDT)
Date: Tue, 1 Sep 2026 14:25:23 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] mm/gup_test: prevent overflow in GUP batch
 calculation
Message-ID: <apbSKcI2DQt86ncE@thinkstation>
References: <20260901083452.115365-1-sarthak.sharma@arm.com>
 <20260901083452.115365-2-sarthak.sharma@arm.com>
 <apaqJk91uAN-zD66@thinkstation>
 <f2fb4b62-f96a-4df4-915e-eb7130671515@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2fb4b62-f96a-4df4-915e-eb7130671515@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 75C402000E
X-Stat-Signature: gc3en7phanrxuus3ey4fju1cd5q9denf
X-HE-Tag: 1788269129-625579
X-HE-Meta: U2FsdGVkX1/aoQ6QBPRBRGtWdi38tY9TGAQhllVtUqo0/ccfrVZCt4A3lMPN/7RcZWKWF3VK+2vcqYH6SMM5pBDzbTNXnusQWtgGPnvCZOkscn+r6I8zOXTB+K8cM3v0bHbs52kqLpIkSo4S5eo9V7dvJInTSUmCbBmpI92CTD5lP7D2+DUSezhXQ+lg4jxi2zGvD77//eoeec7blyYj0qCk6IhBo9lrgRSQymeDkPhtYKE1cktqYzVsfsKEPRwUkQhn9qWwNZPCRM34qGuXK55tUn0Mk0xq6QnWdkcy2OuJ5kLpGpTobSTrY1w7Iwx7NBdSEWkLI+cXYFi1rIsL133fW6iNhHzo278ohb1Ue2aAyePLxExdxol/sp6JQ0PJjFxQi3Zlz25wMddSu+rTIOl14bz0BYeHTvqn7c6Jg8M9WuUD9c73n2k4Y1DqYuW3malemKU0pJT61Hqe6xp+1QiMlC/MukPRy7hx/BoM9HiMMxzPGcztaCWobpSrB1eZRP2Hn338/+HFh29c/jR5eOvWcgNfzWNuQJsIUxNKyEBLkQ655Qoz8BxySPg9/by4KrKkf5orx0TYiLmzQjdJ3npo4xujrsFQShrEvJsAQsgOnL/XPMhSML7vsT1eIm7CCXAcG/FQBgETB9YgUdDHfcoZ4r9oUWnS2j3bs4O/bmcoOUEbeBqTjWUGGvhy3/hlTt83zr2nlrLoiY3V3o1cMbb6RTzGjJniy2snqlAxFq7iWB3DykvD86ZSs961U1v6FKouiUa7amwFMROJidgh5LYcip0FMesgKJKQJ8MTuV9fPFDr2btnTSnnLGrNiPNDDUr5ilsNc+ONfu88RBBIN7HvOeJw/9PBQ4Ob5k5Jv1ZZCKOcnQnAS27VEb8Dqu1J6z4TmXnHIjaVdGjvevIyxTCGd+gVzvHg9iXKaEvI/YVw5epoGIf4jz+gIl8+QENt0/MLBy3UAxxXxKrVEub
 qJ8WflVK
 IWAs03aPO479Q9jmhGP5jaqgFl9blyPo+gFRthVbeUNNecVnYQZTjWzLbGhtWZG4ASmyctCTZMRy224reWPfi/v+ZhamVj2gLwYuHozB0DyFS17vA+UQwMfjkac8bZO/TWycd4LJp3DDLHi6KsmUZWp4In0V/T4YZEksCWLYkarDfASGsgGSP0xIXG7X25YGf2bIoGXCV8TSAYy54Kp8kkVHRivChspkA5SRLNe6ws2HSsdM6TY+1CQI8uamXFmqwGajmC+UMAP+iM55wuX2Id+I34aaLmChBgBP7pERKcjSA4Cxec1BD4kWf9950ojJL1DQX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 04:52:11PM +0530, Sarthak Sharma wrote:
> Hi Kiryl!
> 
> On 9/1/26 4:05 PM, Kiryl Shutsemau wrote:
> > On Tue, Sep 01, 2026 at 02:04:51PM +0530, Sarthak Sharma wrote:
> > What about this:
> > 
> >               nr = min(nr, (end - addr) / PAGE_SIZE);
> >               next = addr + nr * PAGE_SIZE;
> > 
> > Seems to be easier to follow, no?
> 
> Yup, this would be cleaner. Do you want me to respin with this changed?

Let's wait a bit for more feedback.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

