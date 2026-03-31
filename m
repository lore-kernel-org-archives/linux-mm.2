Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 405AE10F9302
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 22:19:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78E146B0092; Tue, 31 Mar 2026 18:19:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 765386B0095; Tue, 31 Mar 2026 18:19:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67B2B6B0096; Tue, 31 Mar 2026 18:19:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 54F306B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 18:19:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 014E11A0491
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 22:19:53 +0000 (UTC)
X-FDA: 84607776708.10.6E34AEC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 57984C000E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 22:19:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mH7fZlLD;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774995592; a=rsa-sha256;
	cv=none;
	b=Vx/kxyDy0CyY2k81gIXom+1JFyzfWbS3L/e8f1Jb8hAtjZhFadiB3gfQKbFtkUb5dFhRFH
	Ix/BDGb1+Gma+h/mf+byTNprtVZ5Nl7T74NNgcIRHfFGnRAaG8tsoZhnWg4yi3YjFcQBLx
	IUwFRMIQ9T75tcAKSNhKo+vT6Ugvx4A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774995592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Sd/ZlmgRJyERI9yWk2odnYGBZ4csWtKuZCLLCrjhGw=;
	b=crJR0J7Yp7TZkRut646UbFnhIgYGL1nEUUwMpyTc0eOaYVZPStPCcRReHcM5TKsbmIewwt
	UqtIrUnfAPT5k92TT2dGlq4hPao782OuqFNkund5i2bHm+kU1jgifE0cGoZ7krR/H77rL6
	Kd9G8rdbVMOOfzjaggN80UvK2pbRrIY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mH7fZlLD;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6761C600CB;
	Tue, 31 Mar 2026 22:19:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB442C19423;
	Tue, 31 Mar 2026 22:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774995591;
	bh=sGOck247aHJSgdA/oNUVdDBxxgKUS/YactnNVKgtYqA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mH7fZlLDjNMDXwthSCewydhEuUQfNYl3heVGdX8iLlN+WMTlwJdEHFPf25eUk4Ttk
	 k5Yea6MdYrNnRbqT9rR1FzCa+qN68ioLNvHKYpGWp8QNN4zupJUWLpv46GIhoMh+jN
	 WzFNGqOUXazGXPLA3HYNSi2QhWUfUxYZOnC1WKGY=
Date: Tue, 31 Mar 2026 15:19:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, hannes@cmpxchg.org, nphamcs@gmail.com,
 chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 herbert@gondor.apana.org.au, senozhatsky@chromium.org
Subject: Re: [PATCH v3 0/2] zswap pool per-CPU acomp_ctx simplifications
Message-Id: <20260331151950.54771bdaf8ddfac766abe3c4@linux-foundation.org>
In-Reply-To: <CACpmpofnKdfprZG=WHW-jOeeXGF47MYoCJDbkZJnemQU+x4wdw@mail.gmail.com>
References: <20260331183351.29844-1-kanchanapsridhar2026@gmail.com>
	<CAO9r8zNaEKDdOxe9yOC0yEgh_obRQTHTo3hJ8t39=UbJ74fVDg@mail.gmail.com>
	<CACpmpofnKdfprZG=WHW-jOeeXGF47MYoCJDbkZJnemQU+x4wdw@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 57984C000E
X-Stat-Signature: frtiab1pacfgmpbpqua698bysdf46dhw
X-HE-Tag: 1774995592-19929
X-HE-Meta: U2FsdGVkX1/FqtbHj4o1Qgsj493L6lg9UOEN1SYZEZBiJGHMWKttWCYIWYijnZtQ/mR1FQwuZMiKTbbI/cPRxFB0Im9KccWvottJH5VFUs3kxg5jb0xKQpDevjEj0nhG/Xo/jJVBWRuNZnkjO2BvlY7v3+91PwnWb1WJRYlPsY6l/Knoxj7bk0OvCpsHD3cumP+l4seuGTP2II08m2goXKyfz0PrtZNjjzwqa4jdu0gDS1xPdAxxPJmRXMnEZR6ZyfoezjiDLRTG2hF8KhPtV3Gvtqv6FhHmnfOIMcRsKqoW3K3xnuiuO4E8os+/KJ5XjWrvJQlZpui3kILglxkJEdeOaQgYvj1PeSPAW8v5mFAgUoJszYj1QgBSyHVkmqbJEDmTJ+dQKG9TOU6t62Osux4eiif1Hamod0qiiCH8LMuMOVJSTkoooZ/fQPWhDzE0g0kfk2W0zT/UekcHpj2l35WUmNsWD+Wvgrh5Q/VLReBJBJLEHIZ1LDED99wIgVvBPtLHEs4OfHg4pEgUXBiVttDl8xwoqdskiTm5qm/kI+9cR/AU7H+simnWIB+wF3/9q6S0QeSTzs60SycpPdVqaECiCxax8EabZPEewYlwuOy/cZOoseag8tqktn1uxxr9ciFYwqQOnBC/jVOvXLP98fJb69uSVRRy6Z/qz5X1LnLZpdy8hTzfH1pRap+ElN+7piva4qQcILDJgZ/bgAYI98ekB3p4jLO3WD2qPIXgsp6cCr1S33igl1vFDtgvYSUZ0NDVePSmx4+9qRh8j3OLjURZoQAklU3ui4y+XmxcoN3nRMOnRQnm247D7TkFQVgK3tIeLwf6hapWdC+z3T96dwGIO82KkfVvoftMXs2E7lEt4iQWc49yYYKBvrA2+rghXRFGr42hIylGZaT9Jk8A5qzKtKLyJ85232mUacFRsaQXJrRnE3c+3t0GcoMG9vIpPsuoA7DxA9Y47x3Mdtm
 7xIYDI+L
 9Xifv+bF8BNGOQdUNTo+XSBFJLwYwzjxSGKZW6aG5RuAqZWhFQipv/NnUgwJfJLVCDn82lPfcS63HahE79PE23hEz/foVIG4Hdb/+kGgV5nQgR1vucLCfTY1RINFckD4HPcdqaBBdtDIK+i6EEv1IybFi1LPYpw1odo1VwF5Mt12rdlOchrYDaQlMLK0Gcqv1a7LjuCJDykMVZFBJpKNmSicsrmMg7jMgq9VXG0pzK6bCbWajOtAFSSWrZMbnLNYn8hfn/+YTXFH+TvzA8ATDcgxqWH1ent63kC/p2ltQCKIW+qBOt8xR0O1ROY5H+x2SfFfG45EVq24crbq256PzGNgbosPy6L5rgY1CBXCq6GJIBXDGuW/f7UYD8NQ3iHk2RbtH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 13:58:37 -0700 "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com> wrote:

> > > Kanchana P. Sridhar (2):
> > >   mm: zswap: Remove redundant checks in zswap_cpu_comp_dead().
> > >   mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool.
> >
> > Sashiko was able to apply the patches and doesn't seem to find any
> > regressions: https://sashiko.dev/#/patchset/20260331183351.29844-1-kanchanapsridhar2026%40gmail.com.
> 
> That's good to know, thanks for confirming Yosry!

Thanks, both.

I'm surprised that a patchset of this signficance got through AI review
without comment, actually.  

I've confirmed that the code changes in v3 are identical to those in
v2, which I removed a couple of days ago for Sashiko's benefit.  v2 was
added to mm.git March 16. So all good, I've re-added this series.



