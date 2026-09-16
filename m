Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F3A8C982C3
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 14:58:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 720D56B008C; Wed, 16 Sep 2026 10:58:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CB166B0092; Wed, 16 Sep 2026 10:58:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B9306B0098; Wed, 16 Sep 2026 10:58:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24FC06B008C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:58:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 666D9140715
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:58:29 +0000 (UTC)
X-FDA: 85219931538.05.345ECFB
Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	by imf31.hostedemail.com (Postfix) with ESMTP id 98C8220003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:58:27 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=i+L2wgMi;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789570707;
	b=QbIUYIjVQFYEXQwErtYZBt2NpR5wdT1jYQNOYkof0D3WJWul4nygNHez1Vie5licI3bUda
	0hqkd709/rLEWf2yopN4glU95Df1IOzvxzwi7cEVZyQZHYV3sjm/RnMxwRnIFNNzcnZfoG
	Ld8DeMUPHznAKw73wWUoOq8zqkSIo+o=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=i+L2wgMi;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789570707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wJ/7KRGCLt2483GTzu4rmQfCVmqSHc3OynN8gOawIhg=;
	b=yoNqBmM6bAU3/V97T8pjGrVpF7swqyB1RhBd1QYE5eXXvhEKQ2EhCw6+zP3zEBhzEQSQH2
	GqSCTC858SCWmYqvOpm7gW+gvBI6rxy3j6yW3CiujKG3y+q5mDpjjFr9L9AwFwGgegDYos
	ogA5lBrCBexpCTKtAqz9wso03nQkQRY=
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-90cdfcb5cb3so10338996d6.3
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789570707; x=1790175507; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wJ/7KRGCLt2483GTzu4rmQfCVmqSHc3OynN8gOawIhg=;
        b=i+L2wgMitt0BNInJBYldEG55kC/haIcQ35iqozKZWNCOhaJDQ6b1971jrki1qyXfzZ
         ZzLhYFOOss84+iLrV+tWBG5Y1jVvtRbVOecmxvPZ6wCk0tGldEQRQFRG2C3dBt6wf36H
         mHYh2uAjOofmmkOyg9/SNEFYtJOgIWYzChroyDSU/ybtsXflO2DAfIX28AZqh3J6TxdB
         oIRbCVrF8J14jdJETpTDu9DlnEfiMIaDq4BbVHwuwVF4LljmqaD/51XHn/BpprMSf42f
         TSgb/iCitqfW6tp7PvBo+4H63UGe5ASe3sU48ElXx/QnIa1VMBYpiT6frgjBLQDiqnJn
         SoYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789570707; x=1790175507;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wJ/7KRGCLt2483GTzu4rmQfCVmqSHc3OynN8gOawIhg=;
        b=yf+J9f1JJ3bqW8xby7ww0zE8E14eMKjbR3aCRc20WeWIoilRFoX5E5VrJY1uvRV9be
         4YBTzGfL8DhT+t2fTFKZEXrngqxWhwh5SiH5z14XeduDjEFoc/Qm0iUfikR7GNqBsErD
         N89KEvtCBUT0hW+L7u9XnjEE5N3hU0KjBG76+F2zcuEvaJVQ1KoUXFqgcReLkWDPPEnT
         tiIg19S0iCU8qwV21eaXFd2o1n1LN1w9LCOevTvodlclfr3j8SB9cc1D8k5Emv+EjeO5
         uLDUqwEcdn5GO7kM7NrJTX3+nCo5tUFPNOX+Lczvu9pdJ3D3FY9j27IGGnDKDwtwqLsQ
         Fy4w==
X-Forwarded-Encrypted: i=1; AKwUvBz7A92YL4iuK4qjvbU77JitZk5ClCqbFfUiv1nZ1FpJBcWAes0USCMuG8j9uM1MM4ILYL1VvHL0DA==@kvack.org
X-Gm-Message-State: AFuF++mOp4ZXGUqxTaC3Br6/IdJJFjcZTVNuYo8qGqvt2duHFEwdGyle
	a06bOEGjRqNnLDMpQ0o22geOs1X8RBuv5iOCYwZZExVjX3/am3zobcWf4NfwnmAhzyA=
X-Gm-Gg: AYBFou3byDtev1c4WZuOKSv6v+658xUdinYJUpcjwc2wJd+vqMuG5rJX3229MwieUKd
	bIonknUomGGbgs6s4A1m/xpsmbujzQ4zC5MFxvDHWsBNLM8k2kb8gj/+5dAZ2iPV3ivHqbwuSUN
	EIeh0prtJWMmJAReJGArXxmBsOCuR3g2YJqSPf7Ar4PcaZFpy0T3BMSA8NZCxdX/3+5aI+WtHH5
	pdct2pUK2bHSjvymNi0VOHTZbn1jJA91WWSM3BvB/dYqR2JL3L9DWN4LQBT2FQar5aY5BF+9xVn
	DceEdGJGe4Rb4J8IFXC1IogVpUzn0HBQgoIv5z60HxgrDTWGAomvj+RfGN9RZDfAS4sMrBfM4mV
	0vjyiZaj1ojiHZFfzwaPoAGkYQW/44pmC9M3yIwwSy9CjUIhSvKdjRJ2bnqE3Rsmq34K7Zt0Gmf
	Fr9U6cgdW8/Mfjn/UXaV07iVZThAntfIf3qj4rp8B1amOyrC6SyE8zo+oukbC/A84BtOSUZ2GYr
	0eW+ISYzl6EABqporz0C5NcDNw6SH4w++M1tDHi+KI30zF2UU9xUq+mDV3aysZDEQ==
X-Received: by 2002:a05:6214:21c2:b0:910:47af:7b5b with SMTP id 6a1803df08f44-9123d7ace93mr52499256d6.20.1789570706029;
        Wed, 16 Sep 2026 07:58:26 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9123beeec67sm27942276d6.48.2026.09.16.07.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 07:58:25 -0700 (PDT)
Date: Wed, 16 Sep 2026 10:58:23 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, akpm@linux-foundation.org, 
	liam@infradead.org, vbabka@kernel.org, jannh@google.com, wangjiexun@tinylab.org, 
	sashiko-bot <sashiko-bot@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/madvise: reclaim isolated folios if PTE restart fails
Message-ID: <aqquDtEZL1ndymGN@gourry-fedora-PF4VCD3F>
References: <20260912110832.3203902-1-gourry@gourry.net>
 <aqloB0zm3RjJ47m1@gremlin>
 <aql65IhMobL5Al9B@gourry-fedora-PF4VCD3F>
 <aqqTbGMJL86TzDrf@gremlin>
 <aqqbB_nFAOGenDhy@gourry-fedora-PF4VCD3F>
 <aqqjW5dpyznijYLh@gremlin>
 <aqqk89oTigJ9LS2N@gourry-fedora-PF4VCD3F>
 <5437871c-d9ee-49d2-b24f-965c73c29c3e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5437871c-d9ee-49d2-b24f-965c73c29c3e@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 98C8220003
X-Rspam-User: 
X-Stat-Signature: f8it5ysj6i7ikj955etbzbfwjn8qzmuu
X-HE-Tag: 1789570707-729094
X-HE-Meta: U2FsdGVkX18XTZI8S1XekRLYw+EaR72rtjHRmCcVo737RR/N7UyLWV+EQlZ0Snmkv55ydUIw33ALH7spJ9tMSIAceBlYnEpqf7C89wImvzlXy3ZzJT7tvWz9BjIO1itpILF0nl10uZR+rLzAGURaZ3rmubzsxcqsfVKTgsnhye5mK5kDWJet9rx/j8UqWQd9/OnvT74+Fte+DXYwhfwvVlLIXkZNR0etyJL+Cn87wlzFLc39p1zzvVB6YILovjCOHxwurHB3z25ajyGvZGzxTNewX64dy+fAjYdOpqRhB2/aI8o9aA/KMV8W26uqX+/wxJpP6ZCHqgc2LZ3nhkIeqUjbs++ZN/YEr5xLftEhdcxb2/36T7rcTfagVfjmL2g6dZi6V0g3gJLyVCkH7z1Qug8hXHkWzKEIIL2KIJpG3rxa/g28KNL6okonZOb1J6/39gV/ccUL1eNid7nda774C6kiE9znpfOdqS9eRjjmKvGG0Kj5/H8YfF7p4j6WOoyq4VA8D+Yrdd7yA32f5gHLHM+r43HZC8qKkNKp8ozEUEUjgNtn6cBVZt1VdYYVsZxdiDb1+zKOf5WSckRguk1z4wwdj87yQ3A/zzNld2Leuq/JAboXw6yTXEBPqX5k2RiLJawLiTNdmcRO3cQXqC/6iAx2Jp0Cv3Y0SaM1CkvgZbB2bCxpIhtkiPU8W1icBIhpXtQjbj3Q35KNy8RkxFB/cGqHFSQxQMJVVOwOldQrJyOk91rMEilhNEGN9KWj1t8hROQMEV1Opxi/1a2PVgg/GGE8g8B5LNzY7kKMRLQpEXIbiCy8RlZLdi/K4KTk+pOoDOptWa0WvTNFm9WpWu0WOJ66RL+gV1ZVi/pxPikAW7c0HRyPbBXaef1/YxHLjJTBypErMp3vOqKuRIRlemPJ9y9lDYIuHOSp+N4x2dRq75Gc4r0D4sVtgGuc8vIq9G37qxrl4JQIUPfD3MMs1el
 D5FsF4nP
 RmDwOFu1ZsvUxVmTMVYtMYaQ2lvEN4OINxsgdBXRsZxRp+WwbiwswrG1zCRJoivgipwyiKHAUI68kZI2kS5xAJFog8vv6AZivDfTNISxkyuCxVL2UOEYVDsy4BNORWoCz/82SUygQ8LYT5JxOJprR3DzQc1riW1SLUW2+VQjcdXF6he0JR3B7e65Im0Nzsv3egdcLx3lhxzH+Yr2SIy6b7bj9+OHMWz5S6cJpdzfRIyfefCI5QGUfe09ltUR4MUshgK8JkmN6VI/e/lw8teqU49GaKJAJDaS3suzJg789Xi3qcTY/Ef9oPZ7ZSnAraiWRJa2I4KhQjD8xk0o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 04:48:04PM +0200, David Hildenbrand (Arm) wrote:
> On 9/16/26 16:42, Gregory Price wrote:
> > On Wed, Sep 16, 2026 at 03:12:53PM +0100, Lorenzo Stoakes (ARM) wrote:
> >>>
> >>> Going to spend a little more time testing and tweaking before I post it.
> >>>
> >>> I've been working on a making more extensive unit tests for certain
> >>> parts of mm/ and this might be a good time to look at whether I can
> >>> introduce a piece of it.
> >>
> >> Nice, curious as to how?
> >>
> >> Have you tried the userland VMA tests btw? Not tooting my own horn so to
> >> speak :P but it's nice, though it comes at a bit of a cost in how the files
> >> have to be set up...
> >>
> > 
> > Yes, in fact I used that as a start for exploring how I might make other
> > components testable the same way.
> > 
> > "Stubs... stubs everywhere"
> > 
> > There's basically 4 testing mechanisms i explored:
> > 
> > 1) selftest
> > 2) Usermode Linux (UML)
> > 3) Userland stuff like VMA
> > 4) Linux Test Project (for syscall and ABI testing)
> > 
> > selftests are really limited and actually create a maintenance burden,
> > they're not real unit tests and are highly dependent on the actual
> > machine configuration which is super annoying.
> > 
> > But, lets take the page allocator as an example.
> > 
> > The only piece of the page allocator that "should" (cough, simplifying
> > here a bit) be machine specific is zone and node configurations... but
> > I'm not convinced that this should require a full VM to unit-test.
> 
> I told Brendan exactly that (try stubbing it) and he tried ... and had to give
> up at some point because it just wasn't feasible. ;)
> 

LLM go brrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr

I'll try to clean up my current pile and see what I can pull out for
some select components.  Something is better than literally nothing.

I'm trying to be careful about not causing a bigger maintenance burden
while also having some confidence in my own code.

~Gregory

