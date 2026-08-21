Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47E38C5DF97
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 21:56:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 419886B0095; Fri, 21 Aug 2026 17:56:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CA5B6B009B; Fri, 21 Aug 2026 17:56:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B9376B009D; Fri, 21 Aug 2026 17:56:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B9B26B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:56:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8B337A1263
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 21:56:03 +0000 (UTC)
X-FDA: 85126635006.08.694C805
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9B0FD100005
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 21:56:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=UoKmZsYT;
	spf=pass (imf05.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.175 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787349361;
	b=qtCLGO7HMjuBJvmUlccL2Tv3eyrfOHL0NtHccZ7gFI9ZOs5ZnAWhy0IJzEjIPCCzzaKYpl
	5+WsVikEvovQd0oUF1W4yPOGwf7yN5lCMBDgUs71KcL7cRbnwD3SFbXWWBe8/hTZwb6EnZ
	xbBe2HDDQMJjUK/ypADhhRTmkpEhS54=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=UoKmZsYT;
	spf=pass (imf05.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.175 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787349361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TaMgLC1XEvgEyOFZ0XV/AGJXW4iKEs3kvJPlr5MniCg=;
	b=liGKvEzoYI8ggGi/Iomfi+2jxUv1ykP7Jl71b14eqgyQ17RL1OSY91fUpBiAu2L2hrzpz+
	bbfpR35bPt4m40l+KL2CG+y6acn8ZgJQ1znhsa9oyBcL1kmp2ucI6vji4j8R8Qk4brb+ii
	bNDacJU4P0u8Qq5VWkim11xDZNO9IfQ=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-930f4e5eed1so88187785a.2
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1787349360; x=1787954160; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TaMgLC1XEvgEyOFZ0XV/AGJXW4iKEs3kvJPlr5MniCg=;
        b=UoKmZsYTZsxYdP6HqkliXXqbFweiVsUGAkRBLsa24uCVCtk5ZaTNGQSy7K77fCAXat
         HNZIK2dWB1CgJoCmY+n46VoQiDgZtBw2adwkV9Ps29MueHCAE3+r8s6Lcvl4fUmOPdnp
         IrUUxq3octH9pewlUxxqL+nE2zaIWKc8LGUFIl0ehQupk2F81Rrhd0ZOKq80Evg/eCBk
         7S3RKteON4ktOCC4DVqRHNYSsAbtb/JU6YSJydgsw8LHswbjGEDZxIWFOoUQDQaL3ymt
         3ziZJX6R2nuxAEqvOk3BzK3dqUhQQQsXeGt2B7MzW6ulflS5R553fDKK8Tc06cdZezCA
         RcXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787349360; x=1787954160;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=TaMgLC1XEvgEyOFZ0XV/AGJXW4iKEs3kvJPlr5MniCg=;
        b=a1R+wryXrcOFND3UcGwV85Hu7VKEXWq0qex95UxVtW1glBT7SDVr69yZ+LEb3XaIbd
         nL/dJIw9g7YviAu9QcGrN+IeOZ2Rb4DpJefafReHbP3VbXBISYAzha+5TsVL/ZdXA9DK
         QMfo8DdJ26J/uPk42prdjsTU8BQ4hnkKZomZPM4SWMrCPLIckus6IOx0Ive6h3HGUTxn
         UGvOv1HfNqinFglQ2W0U3+I/yrU8BB4n2LJ/CygA0pzWQoB8ndTkRwVO0gj0A62mskxS
         sdUcoHLxSeHoFQ3U5j6IVWsbx7Y7blo7if3zTGDEWzTrOXIbge+T9Vz4ar23qES5Ubxa
         xXSw==
X-Forwarded-Encrypted: i=1; AHgh+Ro9BbKQLMP+MKRQf7Jqlok6eqNw8F+lep2yEvTfcSxAi06jynsTcftKfX55BfbKhiHiZREUvQ9fdA==@kvack.org
X-Gm-Message-State: AFuF++m0rGQDbBni5/j4ioHzjVLuhCS+urgb2ySmksPTf3HBwNxYm1pC
	o9f73xiO1/lenj8qDQYJPxcIXl73FLI973muU8w6wBZcZXjz3wKL9b0hawT59ipS+WE=
X-Gm-Gg: AR+sD13ArtOtAJFGyZFtLDp3vMu52FB7tpz9eGiH3mt/iW767L6f2AzbwRrTnqAmLg2
	fSxDtots8t8dltpVSZNJ6FyLHsiWQlid0T195UbWJVAGBO5QmUWQrGZwVlNCFAFIuFikeZEatx1
	Qa0rNlT36I2pIRypkiOlQkbCVNf9mAnmGFA56P6ReOY6Vtyk4EXC1v3nNEs61KZMzDJvagICG7y
	NFhcGgud9Bw7qG976Mt9h2wmQ0utV20Hcqe2jmca5S6phu80FtDLlLvi7ffk/j/RetxS3beLc4C
	2Hq0uIGlKUltvnA0I/G62IfwVKgI8B/3LiuQ7ld/EMFg/35eCiBxMBtsFuydZGCPvI5yeVTzMpQ
	u1GijTN0VFOdOJkVb3aYTg+z38U6F1ntdESKYHnEXtRBZiykwxF+bYrsfoGcEVuZFqIFHgQpxC/
	dzKHRMGfcC8b3135t1FU0Ijlwr0uQVktW5FaQGoCIQogYUmYSPOBPngD62rILPUTCBr10w+W44Y
	lzblTLtTWXFYReiqaTl4wLkM/wbfIU/iT+w/v9MSmkSTw==
X-Received: by 2002:ac8:5fd5:0:b0:519:8b76:2ce0 with SMTP id d75a77b69052e-52df5a6e0d5mr84971361cf.37.1787349360616;
        Fri, 21 Aug 2026 14:56:00 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c5eec2f0csm73294756d6.14.2026.08.21.14.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 14:55:59 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wxXDS-000000074tz-27sh;
	Fri, 21 Aug 2026 18:55:58 -0300
Date: Fri, 21 Aug 2026 18:55:58 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Cc: Rik van Riel <riel@surriel.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org
Subject: Re: [PATCH v3 15/19] maple_tree: Document erase and allocations
 better
Message-ID: <20260821215558.GA1449020@ziepe.ca>
References: <20260821192627.4085470-1-liam@infradead.org>
 <20260821192627.4085470-16-liam@infradead.org>
 <500549bf86f8fab571424af9a7f3a69bb1a08a5b.camel@surriel.com>
 <ufmfevzbrdg44ovtraidb3xt4ba6uneej6e5rkf5cmkkyp4ubi@3tvzvyj7kh3e>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ufmfevzbrdg44ovtraidb3xt4ba6uneej6e5rkf5cmkkyp4ubi@3tvzvyj7kh3e>
X-Rspamd-Queue-Id: 9B0FD100005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: cidp7pt5kpx4ob6ftks4ce4p34gepptb
X-HE-Tag: 1787349361-624462
X-HE-Meta: U2FsdGVkX1+QCp/dsNP8koS7Xa2moX/ByB/IJGlYC4WYyhvqBzGlMqV25HKoWaDaN87pXVafjCmKghjamxAdbqsl9vIHb+jtseYYHIbIQajSiOpBlt2X0ACRtrmw5VDG8z+aSofPj+4w9GKA5nXXVvTAj2v2zREjIm8QhcmNV0eIgf7acoeOx8wt9gOtMXN+Nar6USP4NDmy812SvSnMf2XZFJW00zXJ1+DQTC9cwhPJiDEWg6yL4hp7kSDTIy3s4D7VdvK4dvfXTNscbVuuOaNX+YL7re8iZWOtilbNSF0vJF/5KnYptNHDEw/iAmhsSsXQacRmefIqoIPaueYpfYuzJfTzOmpEe2KYasaAPVQdnr1Q5aJ3xwWzJXLhUwP7mrkJj8g9lss7aFJXgtHwTTsrfNsyFxQU+UphqKjL0aFa5cnteyEwJag3lJiPRoim0d2QFXwgBhMnWBBjTIWK+UEI9a0KaO3aTKgc16HC69Hc4WersbLJFsppH+ztejxKH+7EryY8l9dnHqWDnOIjqgX0o8EMF2Wvn6v2XR5wef8bDyOuqyxBkVUP8XNy6bMnShuLCyuA1DHkyVoieCVLlDH+JGOm4mRpJ2mPIu3fkwSbjpcHHFY7uL/xlR1UwS859ckYM/7n62y54F/AkQegeimma1bl2dPx6vzxEHJM6XGcYmqQKD6giLhFbKEBKSaRMVEW87WQ4Ivl0liM46a/OYyzgdAJqAo6GfI2M/Poyl+TpmxaAZw68dNEX3AfTVPaOJext59D01tsEwI0g0SBdKGUFxpcqKbunSc0S2a4IQy2ue22Bjs9z8uFsoVWG9jj7hXTD6m5zvcOZJp88H5/IVV35blrfpXpWzIDf4VEhioOqIQVB4vvNjOGUNjw0qxwNNynFJHI6Hsif8E7DbseKcIJADh81BmGAYf7qC+X1eCPGdkKxzKWLeHLQ0Xf4WjXWSbsCRhfFzzHGuSQ94D
 n0s5mRX1
 5QfZgbkWf9+OtnmPy59Mzorl+IL/cJA8y9tCUcDEIxFfARQoglE0Q+fpN7fs5CjwfYnCDHZm6jn8AOq71GiQ5aEvcwQzEm3kTTE263awS0AkNFLM1E95hnTRPPa9WCZbC76ZjDkJ/ReioNVr8+mhN3JGKE748qXnEpw9RjHPj5JusPAHlWrxd6MIH779QGNbiJ3NH4GknFep6oKNX1NPgPFwq6wmsSqyv6VNQ+bBBAdBZiCuvCQOkRIkkQJxviz3npTQwsKR/jiuvpJQ0GiHD+B4oCsa2x8mPjBrLKcEyCTzp7XlJV8ih7I2XHIfRrM39sUBPGrHh26l86TmDdSZ4LhZqqwnSTDIuuAmv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 04:37:48PM -0400, Liam R. Howlett (Oracle) wrote:
> On 26/08/21 03:34PM, Rik van Riel wrote:
> > On Fri, 2026-08-21 at 15:26 -0400, Liam R. Howlett (Oracle) wrote:
> > > 
> > >  knowing one value within that range, or mtree_store() call with an
> > > entry of
> > > -NULL may be used to partially erase a range or many ranges at once.
> > > +NULL may be used to partially erase a range or many ranges at once. 
> > > Note that
> > > +mtree_erase() may use GFP_KERNEL | __GFP_NOFAIL for allocations and
> > > cannot
> > > +fail, but may need to sleep - do not use mtree_erase() from a
> > > blocking context.
> > > 
> > 
> > Do you mean "from a context that cannot block" ?
> 
> Ah, that's not clear.
> 
> "Do not use mtree_erase() from a context that cannot tolerate blocking"
> 
> Is that better?

I would say 'can sleep, so must not be called from an atomic context' ?

If that is what you mean..

Jason

