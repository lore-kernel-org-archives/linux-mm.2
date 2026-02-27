Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 543DBFEFB77
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 18:50:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 398A36B00A5; Fri, 27 Feb 2026 13:50:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 346D26B00A7; Fri, 27 Feb 2026 13:50:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21B016B00A9; Fri, 27 Feb 2026 13:50:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A0AC6B00A5
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 13:50:46 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C8E681CB26
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 18:50:45 +0000 (UTC)
X-FDA: 84491128050.05.D17DD14
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf01.hostedemail.com (Postfix) with ESMTP id E90034000A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 18:50:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=CD00WPzj;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772218244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ltptxxezpG36AMJmsDSHAvW1047kGbtkSiWKdHfJ1L8=;
	b=kYqbeCdBz3zBaR8RFEo+5qNMy8mxYCZqtThACmvolj9RpvabL6W1s0qTsWDnqlhtYhEfzw
	TrwoOy+j5abzcC94kG2AUpc1z3m+28LrLkWIgSH+uATyBy4KuAGceR6UmTiqxmMdN4mZID
	e8yuFBW4wFMxvXbf26VCjeWmPYMYAqM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772218244; a=rsa-sha256;
	cv=none;
	b=3YJNkNbUgs0VDyRP+6NezBmFVasY/pGWZ/KXxCALkTCh42n13izPy1HyHlOWkNeny6O1op
	yrJ3k/lmcwBwI1EDXOTYbdbQ7aSYxQQY5Qx3b36OfRl4rAut2EC3hCqutQQQM6+zUz/myE
	fOaiWiHH6drDsN1fROj/PDcD2EOlm+Y=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=CD00WPzj;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-50336cffef9so20657101cf.0
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:50:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1772218243; x=1772823043; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ltptxxezpG36AMJmsDSHAvW1047kGbtkSiWKdHfJ1L8=;
        b=CD00WPzjyhJusM/cB0TvD28BA6g6/KQNcssjgNPp+7VuKUuiyKatYxRe3vpxEr7PeO
         SMmFwr1RSU3tg8GMBSgNH7UsbTuYlA7U7f7l+pz0nquJfIhz8gIZrlfzzLcUK79+5JSC
         uN7tj1DUjySpNtZeQpWvlh6vV2ArDlp3ONxaaL2QyjlYHclkWOVBCw9O+FYAQvwS3s+M
         eyNE2cF+zkFUZXHUddKeGPhVOkoUnD3ouKYwPe3Bsp3StkJhsz4dLTIBtClg2Ek60jsh
         7SDeieoTRevhjzWrhqOHdQat4je6n53KS2SOK7dRQChSM/5ZT3MJ5RcQeQSRVFqzrBb5
         JTng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772218243; x=1772823043;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ltptxxezpG36AMJmsDSHAvW1047kGbtkSiWKdHfJ1L8=;
        b=q8/QSy8S/kDHqyNvfRdcdAVv3/agvu4Xc7doivoPTdlLIaeYJmUhFdlTP24ZqRY291
         933MKoAlAo5imEL1dTZj6uJXgQEFAF29BSV2/qGHMC9Euolrvpk6FYSB+YzZ78uqvF2t
         snJ6TX9hvf24KdkoU0tZKKRFeI4rLLuHSPhVGl6fWPSq1hG+dOWxcwWez8ftakfYfAiz
         PFWq1VPg83fBQvZ90dE4HR1FXrEo364QELFUYDmdCG2lBzCxu+DgQaMFA960JSryPAqM
         2qwPcgmP6zKkXfuDFj77eLlzjSwojXqbl0CxCzymSM1fJwLD+6ouqqqeWi+6ypLtG4zK
         oxEQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNzyHFKu72bbwDAt0mKpIrhqx26+az5v8qv1WMGGY1MlqJvO0mhohbc3+ptkmwPbFa6YJkmkgQhw==@kvack.org
X-Gm-Message-State: AOJu0Yy+hvioxyJbLcx/eCT7LlFUEYU/NL8O/t9G3ho/wEe9+aNDNWTc
	quUQv9EcXuoW7oS68F1rWrYzGPKo4GFJft/xv7hbzC65ebGpwjYu06+UdP1d/rCtU58=
X-Gm-Gg: ATEYQzyjbn7gMsziIEdnUFoMNHrg7u7YSfTQdyp56sJLh5JqNpACPGwPKP8BiGvot3I
	C6aPpexdEQVWYYsJEND1DWHG/XYoBr4LEq+R53fBlfTJtJ0uHYFHBZHrhsBkV935sJOd4J5KLmk
	KazFPx/1rW8qwzpAXBzTkfWed8hmcT0cGBgcnuafjeQQJgagZtBogIiLATp7TbtwS9kjX4dAlb2
	N3wgwG5a4HjsScE1AqTE1Cv6kLEqhwM0Sp2BzsIaPp8HMc36B5JzMs4Ff23uTKPJk0pUnGGEtFp
	Rar8o88SIK2QsSbocPbm/89J/5I5sGCYbURbt5fe9Ia/J7KFK84GhrMmDDhhV755KCgGxfe1LEg
	+dsk00olbdonFJf+838+4II7R/rHyk+TClLU5aVVWsgSlii6wVGRcWRaVEC2yw1Qy72zhcztgc+
	JvjS6s7cy/GtlGJCXulb5UFSqN3W0X8J7vTtvDb4bQU1YzHvrixmtH2gDGt+7AGBI+tbTFJHDjE
	x7qU9V8YA==
X-Received: by 2002:a05:622a:1882:b0:502:a241:1eec with SMTP id d75a77b69052e-50752883f60mr47517741cf.3.1772218242851;
        Fri, 27 Feb 2026 10:50:42 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50744aef9e0sm46655051cf.30.2026.02.27.10.50.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 10:50:42 -0800 (PST)
Date: Fri, 27 Feb 2026 13:50:40 -0500
From: Gregory Price <gourry@gourry.net>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Matthew Wilcox <willy@infradead.org>, Kairui Song <ryncsn@gmail.com>,
	lsf-pc@lists.linux-foundation.org,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	linux-mm <linux-mm@kvack.org>
Subject: Re: [LSF/MM/BPF TOPIC] Improving MGLRU
Message-ID: <aaHngKLxfGp9wLG2@gourry-fedora-PF4VCD3F>
References: <CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com>
 <aaBsrrmV25FTIkVX@casper.infradead.org>
 <aaHaSRXNLJNLwvKh@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaHaSRXNLJNLwvKh@linux.dev>
X-Rspam-User: 
X-Stat-Signature: cpgkxb61efb4c8npp3zfhjxc6ukaactf
X-Rspamd-Queue-Id: E90034000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1772218243-429089
X-HE-Meta: U2FsdGVkX1+v8Ick+kscfqKme5+/vuooklyUb5ZUZPuv5umQWJ+Qwi0/hq7B7Gqucppb24PXk0k5u/dUHwa/WIaRdLQgur6BQ+sP3JA7DzA30D35zeNnPeRJczqci1v0ZQLRlfaDfNQ13H31OzbBDuUDZmcs6+TB1QHBQ5k1zOJZfmayiI68ZOG2AmfWoqLT5b8D1sOL57/VfiB+oFCWWNlhOq8AUizP4DvnUKLRWX4POV+X7cfodLlUvkEGr72/1JSuZVzmc05/kYaxDbCNypgjiB7KmMJZjZOTW4ygoMn1SFrzolwUH5gfzRWUw4YM9yp+BXqc1UmRBph3e5DeXN2BSbnq2zfVzZI6wWlh3Q15UdcHAqiFl2UuRQwxxYTBzHa2V88xidyy0dhIZHJc217KZDtbM6FrhtAr+lqMfeByeQYYzVxh0YNGar3sAhkTXXjQP7DJHEKuBZQYBqCNfm0rFAf10w+5ugJATqFcKPHAChRK9Dt0v/XFFxC4qNL981LycLVfklqOyXMh8Wv0YFNG+1dsZOdoEljpay4DOLomCJJiQo/juG7aHlcsl5hXWg8uNI3GNESga/iJdEtH/EIHNmxA2QCS84RcJ/cUz0ZzQy7jX2dB4hBTH4dlKxbp7fosJXJKZgHxaln0e6ykqNmOeLJrugJT6JXU+1rxWAmcNkJOTOSKm6ymNlBiP2p1BoBABvFVI6tPumslVK4mRho1FgjlCsspjeF2I0b4doEQti1r1OQWC17W/4pCmMpJg/hr9wv4vyk13bzdCRP3UJPGYmkac9RmtU/a7oG4gmhtdK9BFtgOliys+Acon+ATiWT4nZyRv98UzGBfEpwXvwed3+nSrvszYBBpcCKAM5FCgWwLqKLCKdSuUFUf3qn9aLs224LHSwDjZixrWH/SBOxBfMc8FcVF/OAqAFhEPUmzOmj1AjyP15uYMwGQhPSajCgKvYizNU1sVJyIdKX
 bi5yEbxS
 bMR1SLVYqi7q6F7SsuBY5JHTb7Pbm94p3CCz35KFB5jfbjKfeYLMFAdHE/RtpzbUiTjHxSSUkk6QaNFuJVxempin6ExScr0W6/2VUFEUdrTARArZf0oun7XH16zk5U/FvC5DvMiUzzV5Fv2/CYaXEChqJl4DuXL4ZFuqOgao65Hy5ItUzGA5TNWlS8qHOivZkSAHh+agrQehLOdtYFm+0vobgI4Y1GQMdvyDGBSkrryYK/hAK8dQPHd/mMX7ZPPXGeufx+IdZdFSgDAbIPD+olEdBdUW5gu2Wc8U806jIqfBsR7tW7i0XB/XDDVvOISAihg3T4BXnQCyoIGk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 09:55:52AM -0800, Shakeel Butt wrote:
> On Thu, Feb 26, 2026 at 03:54:22PM +0000, Matthew Wilcox wrote:
> > On Fri, Feb 20, 2026 at 01:25:33AM +0800, Kairui Song wrote:
> > > MGLRU has been introduced in the mainline for years, but we still have two LRUs
> > > today. There are many reasons MGLRU is still not the only LRU implementation in
> > > the kernel.
> > 
> > To my mind, the biggest problem with MGLRU is that Google dumped it on us
> > and ran away.  Commit 44958000bada claimed that it was now maintained and
> > added three people as maintainers.  In the six months since that commit,
> > none of those three people have any commits in mm/!  This is a shameful
> > state of affairs.
> > 
> > I say rip it out.
> 
> I have very similar concerns. Though rather than ripping it out, I would like
> we put efforts in unifying the two reclaim mechanism (traditional & MGLRU) over
> improving MGLRU.
> 

I would agree.

If we could make the baseline MGLRU 2-generation and with behavioral
parity with the current LRU, then adding the additional generations
is just a mechanical change - and doesn't hurt anyone (default= 2 gen). 

But my understanding is MGLRU has behavior differences regarding its
preferences on how it ages anon vs file.

That mistake will cause significant pain in unifying them.

~Gregory

