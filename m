Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7246C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 09:03:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 706E36B008A; Mon, 13 Jul 2026 05:03:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B7B46B008C; Mon, 13 Jul 2026 05:03:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CD646B0092; Mon, 13 Jul 2026 05:03:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 339E76B008A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:03:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B0D551C960D
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:03:37 +0000 (UTC)
X-FDA: 84983165274.27.5190A8E
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf03.hostedemail.com (Postfix) with ESMTP id 052F32000A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:03:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="b468/HCN";
	spf=pass (imf03.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783933416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3BBr7zjRouO3G2NSuqXNMmvWjnBpUuLq7/WaloAanxI=;
	b=78QS/QnF23Jc5JzFs+xlUiwy4JwQx4VqacQaydkyvcUVnSS+sM4HDH+lHkz+5u42vyqjUU
	gtMRhT3978xUpQ/UL+wTqkN6WWrn1fMQ0O2etLsb+obLcSHe72itYSVix7rZToVewzfGHt
	JreZx6HALK03AImmz2Xf0NUO5ntEBdQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="b468/HCN";
	spf=pass (imf03.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783933416;
	b=Qb31mFzhVQIp2qLGte6CQfXolu322CMD2Xzj3vhW5EhKbJIhaxJYJEHabXMTgdVHy0gp9y
	DHLXnrU2dqqFyJEwkcMAvJjUxgfxWazCWAsfQCr8ZNDenDTgMmfbf1N9/hJCQi6Pp7uBe+
	ufmAD8HHZ/+TSWtKIDs6bx+xdc4jjRA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3BBr7zjRouO3G2NSuqXNMmvWjnBpUuLq7/WaloAanxI=; b=b468/HCNQ4+KZwSA//T2I7MmIa
	mUnsF1tYfaMbE1y5VZKPPJSWeD15dwI+57ElHvSom/QPDyOW+HNOxBFub3m4i80is/hMvXHxzmkM6
	l5DGPmJcrXs+MW7G30++if82wWn6PUH+94dIKAQVPj2A83eD7730/03Qt5qas20ZYn+Lx7lkf3oGd
	Ii7sRn5FI6e5ZAsesb++pHAsOGcZSEZrH8OyM7obWzF4296Lp8K3MUe8DPBAD/4WwgbmlvqcFFNe6
	vxGX0PGaHXJT5Z30gX4vEjW/k9lN422VBYSDfmZVPcAFCaUjrad06v2HGkV7q0KvCrmPf7UAtLlpn
	p3wVPBqQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wjCZY-001O7F-2k;
	Mon, 13 Jul 2026 09:03:33 +0000
Date: Mon, 13 Jul 2026 02:03:29 -0700
From: Breno Leitao <leitao@debian.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: kmemleak: confirm suspected leaks with a second scan
Message-ID: <alSpwP4hyghuj-x4@gmail.com>
References: <20260709173347.689607-1-catalin.marinas@arm.com>
 <alCxkNBvoDGRG2ee@gmail.com>
 <alSpN_sTpUkjDFxh@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alSpN_sTpUkjDFxh@arm.com>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 052F32000A
X-Stat-Signature: w7h4pk5fg1mig1uyftgacc9dr5u1n38u
X-HE-Tag: 1783933415-74727
X-HE-Meta: U2FsdGVkX1+hFXAtjJ6mKFA9uqiBJhz6l5b3PyD4Cn4wDF/5xL2Hw+w7rLk3wvDAOS1Zjf5ONHVWepKbo03cIX/MWrvPFFhjmb9qo1M/MJ934gMZUeMNQvPmfebnCA/nRaErwu16sq6KQF8HN7TzP3dtKUEo5sDsGnts2qMIrUej+9ovesl3K8JJqXAsOlN5M13XamNwCmuIBENp2jQ+LL/U6+c6ynDfLSI8v4ay0SEAIFZGbNYUseMgRlcSzsg3jeN94RP0xXd9dwRgVwLZ0YyiONkSD6/CkiBP4rBSjvow+0AXZ8sTQnHz2eZpvzJhcj2YtNOADgS16ZaF7CYAGnzQLxHELYrqDK4+eGDbpJpBM3U3IAbn2aZ6RmNuESrP8Kp4Tsn8pF57WX4zqXwJ8ztQskNfGkx8OdLVcv2UoSJzUKOCeSBZ7do2inwh0krPGPDzRq2K1kg2D7x43hd8aWFGYVS/w41oleVyXdKfcqwr5+6q5Zr9hhXLv8FeYsCY2hn1XVf7rXrt0Aol4EkG1adi4IfYWVwkbcqsJG6NtuUwRlLGWNtAj/1tTT/ZCwP7zHd1j1WZ+rNhO/htn6bEoF6HmF6ENYA/i2QZaxSvmN9oPze40JiD3NZqSsJlWVdBzZQRwt0dzr2muECrogr/ZkK7E1T83jn9K0FVpbVddU87aSn+GA3zywJy1hd2K5Idz+yXRvKKOFpZMwLxblkjXROmgIYiA1VH0z6sHe0pECp1D34t4WUybr9tyHX3INawLnnVjSvOraoTpkcx58wZx7g/PmX8YANdmbuoYKVLolUUvK5Vhfymr83fDwCiWTO/lWNpbU9ET8g593CR9frBVxxOWkSDdUb3QpQE57O4ejr2iFwNelLzb21ZiWLBcCaCKjur1XhvJ8Px269tHqThvbnY7tpJNLwlobYtspT1YQWTHYsrT/MtFsCFmH/SzRSF+u/Gj0jrgrItpEIASGJ
 B4d4Blf5
 0xLQ9UyV033NCgPNi2lkDpNy6GjVzL2WMnGlseo2GrGPYGorVoGe/JEjrP6fgf9kNqFFPsih6lbOl8tYZthmi0ZF9+HRjaNEPmcrnHudIH5WZxVKNCnBk3uiCOuf6LamC2cuikrTaam63Qx3WPZKFAQRbDrl2uQG4sRZtaW/73xlRHRWsHOQVdZDdUcekoVAEyi2NEyHIaBVPFKHILUwIBscjUx5w0/NLqzt7SK+gspIk/ieF+afRb4CLqLlMyd7oGA4f72tvLkoBUlnwGq7yNak+QIUQM/+t2y5grUEOsE3AWh9FhEFofRj79F+PPx70kVQhS49X83XjkWBwU73lzmvdluosrH7/DaxYtyFYGG3cd6dhgEpaG3GerJN52vAg99deQEn9341oXg4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 10:00:39AM +0100, Catalin Marinas wrote:
> On Fri, Jul 10, 2026 at 01:51:40AM -0700, Breno Leitao wrote:
> > On Thu, Jul 09, 2026 at 06:24:47PM +0100, Catalin Marinas wrote:
> > > The kmemleak marking phase is not atomic. While the object graph is
> > > traversed, the kernel can modify pointers, free objects or allocate new
> > > ones. If a reference to an object is moved from one location to another,
> > > kmemleak scanning may miss it. We have explicit annotations like
> > > kmemleak_transient_leak() but identifying and maintaining them is not
> > > trivial.
> > > 
> > > Given that such transient leaks are short-lived, rather than just
> > > reporting such objects as leaks, do another scan to confirm the
> > > suspected objects. If no new leaks are found during the first scan, skip
> > > the confirmation one.
> > > 
> > > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > > Assisted-by: Claude:claude-opus-4-8
> > > Cc: Breno Leitao <leitao@debian.org>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > 
> > Tested-by: Breno Leitao <leitao@debian.org>
> > Reviewed-by: Breno Leitao <leitao@debian.org>
> 
> Thanks!
> 
> > PS: This is now conflicting with commit 946935b07cc94 ("mm/kmemleak:
> > skip the remaining scan phases when interrupted"), which has just showed
> > up in linux-next. So, a respin might be required.
> > 
> > > BTW, I'll be away from Saturday for three weeks. I may reply
> > > occasionally but won't be able to test anything.
> > 
> > Let me know if you want me to respin it based on linux-next.
> 
> Yes, please, you have time. Thank you!

Ack, I will respin soon.

