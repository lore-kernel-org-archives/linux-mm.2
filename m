Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5543F33827
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 14:34:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE2AB6B0005; Tue, 17 Mar 2026 10:34:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C93406B0088; Tue, 17 Mar 2026 10:34:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA88A6B0092; Tue, 17 Mar 2026 10:34:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AA6006B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:34:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5BC0687FBA
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:34:18 +0000 (UTC)
X-FDA: 84555800196.13.0290742
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id 34F46A0007
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:34:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=E6mWKaMo;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773758056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mnjxrzOC3v6uWzLnI6ltEx0aufj32t/PG4nGWr54wv4=;
	b=j4TueYKcxOhDpFNdKhaE6ET+bjc1I5AhEC+yyjvhx5Fg4miY9KM39pAjOM2nXNQ1N+sqWz
	MHdwqcj1vFSwWMmCDdww8rjlNPQioi5WEWLs4LFY3ImBL/Cxrt4BbTq5bB6k6zv9LrFnU7
	RFhr3Mo4m5DR8YyIG4dMYRW5BwW/GR0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=E6mWKaMo;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773758056; a=rsa-sha256;
	cv=none;
	b=pFCNd+q2nCwhpOMkGBh2KKjjleGmT0469VfGR3rsy1MBW2EGn/h5qK8wTXdGf/HLJX9ENi
	zS7fVbIl9w8tIqwW0Km88s2VKx7HNTxIJLcmmQAsUdfiom+S5q/Mjt3BsaPvc2efxbkdgk
	WadXM8sIJ3aqleEL5DaDphFV6eNORq0=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8cb38e86cf2so580210985a.1
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 07:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773758055; x=1774362855; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mnjxrzOC3v6uWzLnI6ltEx0aufj32t/PG4nGWr54wv4=;
        b=E6mWKaMou0aDHJr6X7n22qPAf3/+GnEYNQtcAUvwdovf3KmetM9MOLOyTKUU+7JpGP
         Qr3h0naLViZe4A6AUhKTyODYfqTDu/qDN8OFFEHj6ncxqDd77DW1S6B7w63BvbkPd6xq
         oyqQbN79lbsZbsW69k8cDTzKmu5dB4NrDWT3AHSR3UwBJwq0U5k2tEYh5pxjXc1jIRl8
         sHrey/kgaZEd14KoBIJjmPzlhnK1l1nIzrJLRpoVKTuTauTknK4XHSaA2TbWeHTqSiUi
         rSQd3YUvDQO1EH4AOQrk8owTkY0DdvAbyoZ1xVFy5RgubZHmlESalaE3poa6OARQPoBN
         50Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773758055; x=1774362855;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mnjxrzOC3v6uWzLnI6ltEx0aufj32t/PG4nGWr54wv4=;
        b=om6e5ZoXNU4CREyXtuk1+QkjvW6/eup8GUqa8VVdmIFByi9IjaxnctxGWF/+FBv2yl
         EHFeYe0/N4v7VmUvNEastGk8Q9QxROO1qPoI1TRTo+XfmZcpBZfY5KfX0DbSuK70RHIa
         jcMIjIiS4Xx5+Fp7n42OgStQb6jTthag1kKrqgKq7w75rpeVz1DoFJSMKxB4Me1DlXFp
         S2/MP8Lbp2cib4w71RKbmalNSTKAFi+u+mB1BjgSlxGnRajuWYm7JYECT6DmIdRISexW
         F9jyI4vZ9l+yE3r6mgQB7Obe3HSqKay1eUY31Qs1Qwmq70j0GPv54zObeBunpzubsuEt
         +fqA==
X-Forwarded-Encrypted: i=1; AJvYcCXP20smuIrxvnxJkvl1+LkFi17wOGu5C0Y5vRWYL/BQxi+RIYjqUq+8GRvmp3THVV8qOtLcY1kS+Q==@kvack.org
X-Gm-Message-State: AOJu0YxtdRl9+D7hp1FRNM4kMwMWdFkaO0gm4Ghb08GQkLo6v2vUMrCe
	Ok09KL3hkjHbYFYLPPGhA+2XdpMzy9DTh5moZoSuo7XEPHm7hwYARJAZ1ZjoE9NiOqQ=
X-Gm-Gg: ATEYQzyRIG1xv2z8kdnfRIW5YHO9+h1OlCHy2GlymfmOU4totuFzqQlSyBrGAqrsyqM
	rev57J8Mkr6tiNa8/tFHeQyceSuqaN2loJ7fp/8+d35ZMf9ylxGRd40RWhXG9qw3Dj5SxDleQO9
	Eoqt8oGHXqWIdSVTvxtJT/lH0X7pykd0lLwwm9eyFxIg+fRWe+pTNgT8B52MpTQp5XYBdQrP9Ia
	Fj0difZnV9FbVVmsKos7BQEHWyq7Wj1SWbbV2+iImIthlLvLvAfim11/omrRd4eEjZvOSLM1bhN
	4Vx2YCLsDz3cfvdfeKfaT5Srk6rySRYMNFC5xh3AkwdCoiWTf+X1EpV1hfoaQ8lIB6E87t+cFuc
	EimS7BXodW+9138UOG+EFEEJrVJJiqtZqbCKlH6DYmJ8KaWDQbOsiGIBZ2240DJU2fE7XxIe/NS
	HFHiHG9+5BxMo9vHWW0/7H5g==
X-Received: by 2002:a05:6214:d69:b0:895:4b79:83a4 with SMTP id 6a1803df08f44-89a81c89e4cmr226468216d6.4.1773758054904;
        Tue, 17 Mar 2026 07:34:14 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89c4feaaebasm48948496d6.37.2026.03.17.07.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 07:34:14 -0700 (PDT)
Date: Tue, 17 Mar 2026 10:34:10 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/7] mm: list_lru: introduce caller locking for
 additions and deletions
Message-ID: <ablmYhfNFIfHqzX5@cmpxchg.org>
References: <20260312205321.638053-1-hannes@cmpxchg.org>
 <20260312205321.638053-6-hannes@cmpxchg.org>
 <46d9173e-98cd-4f59-b0f3-e477afd5283b@kernel.org>
 <ablfFy6xnWwZQyUq@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ablfFy6xnWwZQyUq@cmpxchg.org>
X-Stat-Signature: okzojuejfem4ccw5czztuutnc4xw5yi6
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 34F46A0007
X-HE-Tag: 1773758056-237949
X-HE-Meta: U2FsdGVkX18STc/nS6Ums7LaKeBC2n2UMZ9UnoJ/hwCPTaAfVVnAnCdIgGVlLTW0GlZqNl59zo35KMesgvlYDwrzYuD264tv5HMhmHLO9rQq2xQ+Ei/bmq3deGt5sT9fR/u1KxiTomsC9nO+CXBOvJnUeBiKt/1MQRJwYlYOszaUwlTxbdSFcRFamGeyRHcq08O+tkK2Yjk+0nbMM0G2fNq8AcMvoaa1EprtJOElIxHnyRXS5wqaYWPSUFQ6gcDc0Jz7OXraQGpp/8VBB0WS5LtHdUUDobrNBDb3YRhAomFPS89h0erGNiTuwj16QplEtab/Fj5g9f8Rz1gB+MQxDUbQF2daXEB/hFBl2H5iMO7fBtMws988jNWb5QF1YUd8vOQgyJilw/FY9HOtCB3O6lO4zdUkkM0OrfwrMSD3OmK/y7XM4F7QdyTVdZvRGpn381wh7LPI+bPZBMaD+d42+pKi3L+3At8fzFuk48FW6d2VhD4srSXnxL6CtHSLJfZaMfd0KBIdXSwZqt5A+4wM3arYWRBft2uziwMkRS+/ivB8ZX8RIHlIPgXJ9gYuuYWJwgikVG80plXe+vZ20MQmeBlmQi7kjrA9IyU6tmioAxNvP94WQJ1I4KNyDHSmCy0gLOYipFUUIlhN0hOl/c18BQhHtAdu+uhC2S2SRYOzCTV98hUi+ksZOTSB6LEBik5K80lBDcrgfarvTbecj0hd8aTT4s43jLBL8TqoLPpJFdAo2/RbcATHbtU0DL2v3sCMHMPYgDS/jVnL/0Syv+BOo427Yii9wN5Khc7XC1hSLh2ienvUPAoYW2Mx8mTsK4nfoOA4PRNN4/H+H4/jgbArtdbr/cO691a/YuLtAElVHpEF/s3pC31XISr67DbkM46zMdsLp6VhQMwsGOTgU7XgTxfAn1KenFGgOIBrDPjExQsqvryfhO9d+JAY+0K6EY9lLflekhaBslJJ2uyvZ3j
 4yOjCiP8
 tIsVGNyOVek4+PbEW4+hfnpVdZnbLip2NhMHyesJr6B81CeVDH27R38caxDVIRr4LjsqVA1udmviCFILfsT6ThKqq/4KivPVaGXpZxYR7uHu9txQviWqWx4k6S22hKDRZrV1HgEJ/OZBLVrChCMzSVyeUO7+ymmA5MiW7nl5KcRC/rAF5MJqdWYssH8gmxJ81QFDERhNjarlc5h5+U6DueYtlGMcl+UMXN19L2NYrCzhMZQ9fjtx29ibNT+M0hWtUgE1lC1X2fb5IJE182tytSqck4efTZVu3PuBw8+dvIvmEAERwl32XT1e1cwRCZYmHMo8XJUnLM1xiQb1+oofdHB6LO55idhcHRwei8UmQQfW7xj76cVp+zdVLGjwbPualIUIhQ3FxlypgZIFXPd+/eij8ySdfX2buvstsL52Skb1lP+6zviFgM7WVFqJugVxBvJGtORboAuwhcLw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 10:03:08AM -0400, Johannes Weiner wrote:
> On Tue, Mar 17, 2026 at 11:00:59AM +0100, David Hildenbrand (Arm) wrote:
> > On 3/12/26 21:51, Johannes Weiner wrote:
> > > +void list_lru_unlock(struct list_lru_one *l)
> > > +{
> > > +	unlock_list_lru(l, false, NULL);
> > > +}
> > > +
> > > +struct list_lru_one *list_lru_lock_irqsave(struct list_lru *lru, int nid,
> > > +					   struct mem_cgroup *memcg,
> > > +					   unsigned long *flags)
> > > +{
> > > +	return lock_list_lru_of_memcg(lru, nid, memcg, true, flags, false);
> > 
> > And here it gets really confusing. true false false ... am I reading
> > binary code?
> > 
> > I guess the second "false" should actually be "NULL" :)
> 
> Good catch, I'll fix that.

That's actually "flags" haha. But it supports your point.

