Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F569CA0EC4
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 05:34:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D38018E01BC; Wed, 13 Aug 2025 01:34:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE8968E01B6; Wed, 13 Aug 2025 01:34:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD73F8E01BC; Wed, 13 Aug 2025 01:34:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AA7E98E01B6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 01:34:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4B19857AA3
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 05:34:53 +0000 (UTC)
X-FDA: 83770620066.05.CF5A256
Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	by imf24.hostedemail.com (Postfix) with ESMTP id 037D4180009
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 05:34:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=codewreck.org header.s=2 header.b="egPHiuC/";
	dmarc=pass (policy=none) header.from=codewreck.org;
	spf=pass (imf24.hostedemail.com: domain of asmadeus@codewreck.org designates 62.210.214.84 as permitted sender) smtp.mailfrom=asmadeus@codewreck.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755063291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XjWBHGXAcgSV563xYk+j+40WjifMEzSXGjNe9KQBgLk=;
	b=x5EQ8hfhuGCSWS19a53T4kqUVMA3f7zVRfrAN6+dMC5qSsR+On+gMye4RyXo9M1DPG8Yup
	GCRvmADH3Q0jpO3h1W1xytskqhSakxlCQh9e2kDCi5wF6uixsVyKVnewV6IXPHiYkl8Sgj
	5RqCHl2BbNUFR9DfCcA3pNl/jpLRHcA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=codewreck.org header.s=2 header.b="egPHiuC/";
	dmarc=pass (policy=none) header.from=codewreck.org;
	spf=pass (imf24.hostedemail.com: domain of asmadeus@codewreck.org designates 62.210.214.84 as permitted sender) smtp.mailfrom=asmadeus@codewreck.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755063291; a=rsa-sha256;
	cv=none;
	b=ERxReAqEQYhFDcX6rsGuF2gg+56ZEhyCuKBnpBlwN5eYi4gWElx/gjFOpakel/MgWPfZhE
	mJRwnCOSqFLA7E8QZUITeVP1IYpFHksrIMP0noi3FdB5yJG2wxNvijKkR52EpYN3aPe8w1
	QyACnrDEa/aHHwJXgs0nXKFsjcHdzxw=
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 1CB7814C2D3;
	Wed, 13 Aug 2025 07:34:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1755063287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XjWBHGXAcgSV563xYk+j+40WjifMEzSXGjNe9KQBgLk=;
	b=egPHiuC/UC4UD4nFojr3h+78xh94q0eLp3Zq21uBe8/LCpwZK5VBHhPh9biDCwsjmCVJnC
	CFyJ0T1fh3cJfPengyIw1VXIKESumJNM2n9UFWGwG0KkXgd34hp2B/yF1MQZjSAYiQ/d60
	8PWe6PSIJFyJHf2TRZISebDIzWprvPBpvm55mgMY+d3Ib8JIirsbnKbO7ECSm+j9b5DenO
	NJa+UHGLhlCaA8/WWL7kOYYRzgNKmLAq/YaBH5oieeCCQGoPB7YE+okWPLuEmWJhY6T4Rj
	zmwT6YJssNSgb9Sb+7caUlK2ahGNWZaFZgv6Trd5sguwsYKpqxLITSfw0KCw1g==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 2a270480;
	Wed, 13 Aug 2025 05:34:40 +0000 (UTC)
Date: Wed, 13 Aug 2025 14:34:25 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: kernel test robot <lkp@intel.com>,
	Dominique Martinet via B4 Relay <devnull+asmadeus.codewreck.org@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>, llvm@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Maximilian Bosch <maximilian@mbosch.me>,
	Ryan Lahfa <ryan@lahfa.xyz>, Christian Theune <ct@flyingcircus.io>,
	Arnout Engelen <arnout@bzzt.net>, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] iov_iter: iterate_folioq: fix handling of offset >=
 folio size
Message-ID: <aJwj4dQ3b599qKHn@codewreck.org>
References: <20250811-iot_iter_folio-v1-1-d9c223adf93c@codewreck.org>
 <202508120250.Eooq2ydr-lkp@intel.com>
 <20250813051633.GA3895812@ax162>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250813051633.GA3895812@ax162>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 037D4180009
X-Stat-Signature: hpegt4bxscu3wgc8qtbbn8n7i4n8xifq
X-Rspam-User: 
X-HE-Tag: 1755063289-64477
X-HE-Meta: U2FsdGVkX18NjKw4N+q+nxf+EwzPbwwh/MwaMg1fenFMEvPgVdRf3A2cAMkyZVjXHj6OC/XBafud9Stw8++HbKlPkyzwNE/yAK/CSsspcVTQsgfREI3Y6500oJnXivXT0G3lmPw8D1a2mD9F7UQhMdVidT87AqMGS0EppqavOyWhnm0pmrshOUvcMHw4ixXNBcEaNrt1hd/gIg4h/gbNzYZ0oiupIvmrOxXJiUH3eJAAoMYdf8x93ALoDFHUoe9jBu5fxsLmxs5AeDqodgqLeS/Ejs13tANuQYi3LyU5Ty3D77GoLtXsE7OqrfS/NZ2J63i8EEU5IK2hjvXO/MHftw6nzfAlW40v0ngQCg0Gve9ZgKt6W3wQDLk/7z+7YohH9c+78uiP5jQ3H68lzF1F83NcNFIGLshU3uDSHBkYgiGxHoRw90CUisKiEUGK2i61w3tZJ0UlXWkmwY3arXsAOfgiuEfPtNCwr3N4QCk3Cb6273oJOc/Ddx/wJy5x5y4FUPNfJBMQskjHrnhRTG7WftL2uzPov01T47HfJPrRNKIyJ1W8/otfqgYB2DogFZi+6rbYjaqS3g9CowIyVH0ZC22DpT/rfjRIMs/IDwNMa/hJK4oYlDBWt5fDMJ1AN9Acaw+mnybMS2QoDbkzPbKld5pLJCPt4hO87ApYH1fliqJsd10tWbW2Gy4cPRoFhrp5VeAMmdUdyJ71aXQ6BUjyL1BSAG7IHsfq58iwJwARkyZlAbtltAt+fLZKiC2Z8B2Se76GuF5YY6Q52xaENmbgZSqOdMqYlZAnwBZh5rtLjIYra93jg1v7ZqgeBKjIoPjCNqo3ePjyPM5dpD0ekHA5ggMkXVIiHBq8CAAJ9ALrv0o//SEBckzxvpa8640ijYyq2k1qc0y7XVk5gsbWIqUEr+404V4BJkIO+SoBhgrNbwXYm0csgJC5wecThNxtW2JpQIjkGU6MzUGwyvDdxk/
 A1J3e4UU
 tN3TOijG15L7q7h++gaSq1QKeKTvj3y1+KupH1QMGyKUltaTPhjIsxb+BKnzuT/hy5xw+w5Pf6oEJIqLVAyHFoWMH+Q5JnIHeYCBvcA7WYEqCo0AciWHPnZnd9Rff7TCZesdM7OmZOZYunP561ryi6A885sRH7B14yHCko5TdqN/Rt7iMI4XnetZVzra0N3DObdfkSZ6kTRMyWTyKpZSPLd/m3IL+rK32FHuvVZnhegzYV4jEoJsqLau/lmt2zi/7A0XwvI1mTtmJYGfetiqEq9I1fdRXYaGTOeHN+6l01Gwhas5VcVCSCIMi2WvFACgu0Lp2Ix/wDyg9M4BpVeiihmWzoS+PDbPpx9dJhrHl9xlO9K93Ufs5ZTlpSg9wXsqNTPLzHRNI+qgO87GqYWqHb3LpYoUyDT/G00znUroHg6LTD8ObX+IXrWPwn+D+447rfODg1TIOKfKuquqRW90bcliWgsSJsCITCzKvzEBJgnZ1wjR2EHVMpytYGc3WKBEMOOc6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nathan Chancellor wrote on Tue, Aug 12, 2025 at 10:16:33PM -0700:
> >    1 warning generated.
> 
> I see this in -next now, should remain be zero initialized or is there
> some other fix that is needed?

A zero-initialization is fine, I sent a v2 with zero-initialization
fixed yesterday:
https://lkml.kernel.org/r/20250812-iot_iter_folio-v2-1-f99423309478@codewreck.org

(and I'll send a v3 with the goto replaced with a bigger if later today
as per David's request)

I assume Andrew will pick it up eventually?
-- 
Dominique Martinet | Asmadeus

