Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D243606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 17:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=L+lRb7tg
Received: by kanga.kvack.org (Postfix)
	id 27E876B032B; Mon, 19 Oct 2026 13:58:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 228A36B032C; Mon, 19 Oct 2026 13:58:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F3EE6B032D; Mon, 19 Oct 2026 13:58:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DFFAD6B032B
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:58:48 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 79DD6807FD
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:58:48 +0000 (UTC)
X-FDA: 85340136336.14.AB9C2AB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id A46F380006
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:58:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=L+lRb7tg;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792432726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oPj1wdj1uiPohgNU0SXZo753xMGMB0lBhXuRs/TA32Q=;
	b=COjGrUWiRrbnQdld62itmX6ub22aC5Bb00wDweLTqbVCTNQE6JtUFHl9rUQ7zPrhsMIeiH
	WSg3p/IHBHT65WXM4+Yjo8NBzWMhfeImdORt6VzNBtbbZYg0p9IqNjpJKJwRO8r/Z1chcO
	/jb7F3Xq9PhGQk4Yvgksednb8AJ8OC0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=L+lRb7tg;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792432726;
	b=bGRbR0R1f43e13Spjx0sqoiMww1m4fElUjXJH+xt/qlX7w82DjUDq21OrYrbnuId3cgTms
	sGJ1wr4vun87eFvq6VCDa/y8sd5Y37X0DxquBgpPLyCBY9yd8en3/3VeqtjQgWZVzLZfGF
	XmbMhMSH8q8wFj0JBcpCJ6SWvOp7N/I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8EDEF40307;
	Mon, 19 Oct 2026 17:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2901F000C4;
	Mon, 19 Oct 2026 17:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792432725;
	bh=oPj1wdj1uiPohgNU0SXZo753xMGMB0lBhXuRs/TA32Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=L+lRb7tgu/5dsyOmtNeQsYQUgYNKPqVooCkrHEGDMjkgJ0nIp1gZ53JowXggaCgK9
	 jbspgOy7SIiuWTL/0cUBRj1CMIeDHzxtEh7Z/QV+swxfnuxuv3SLoHennW0zErr4jG
	 P/U6x1Xu/oa4dK1kzkdhB9nySFbgXzUbjqYsqbn0=
Date: Mon, 19 Oct 2026 10:58:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Nikola Ciprich <nikola.ciprich@linuxbox.cz>, Sean Christopherson
 <seanjc@google.com>, Borislav Petkov <bp@alien8.de>, David Laight
 <david.laight.linux@gmail.com>, Rik van Riel <riel@surriel.com>,
 ljs@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 david@kernel.org, Mike Rapoport <rppt@kernel.org>, Dave Hansen
 <dave.hansen@linux.intel.com>, Pedro Falcato <pfalcato@suse.de>, Kiryl
 Shutsemau <kas@kernel.org>, luizcap@redhat.com, pbonzini@redhat.com, Tal
 Zussman <tz2294@columbia.edu>, Matt Fleming <matt@readmodwrite.com>,
 gregkh@linuxfoundation.org, sashal@kernel.org
Subject: Re: hunting memory corruption bug in 6.18.x
Message-Id: <20261019105844.02d4623b7063fec25ebd34ad@linux-foundation.org>
In-Reply-To: <CAO9r8zO41EromgLGhKv8H0aKXjrffH+t4CFGU6cLo59JJ3CEuA@mail.gmail.com>
References: <aszH4vpXFAOQP1WG@pcnci.linuxbox.cz>
	<20261014235736.GCatAW8GD0GlYumL4l@fat_crate.local>
	<20261015172820.7961d2c0def74d41cc6c4b0c@linux-foundation.org>
	<20261016031242.GDatGWKo98YSOhEOOn@fat_crate.local>
	<20261015211832.45d87fab15bb3e0bbc2f47cb@linux-foundation.org>
	<20261016054954.GEatG7AgMNFRkiTo1H@fat_crate.local>
	<atI_yuCc4BiweBQP@google.com>
	<atT5TYyLapHO5ZoX@pcnci.linuxbox.cz>
	<20261018201538.d0957878f378a9821852836f@linux-foundation.org>
	<atXXma5NXxoSWJO0@pcnci.linuxbox.cz>
	<atY1vWRBRUwpISKb@pcnci.linuxbox.cz>
	<20261019083529.a81910ac0976c1a5687d4c6a@linux-foundation.org>
	<CAO9r8zO41EromgLGhKv8H0aKXjrffH+t4CFGU6cLo59JJ3CEuA@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A46F380006
X-Stat-Signature: 1s8jhxdtg4sjd8iqhfhonuxptx9prpq8
X-Spam-Status: No, score=-12.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792432726-189465
X-HE-Meta: U2FsdGVkX1/1Yji4+yJcMYL6wR997DegCdIufg7Z12YtOis1CxdRtKJ/yE8wF3u3ftZ20XmZsLttlBaOPfUA0oSylRwFE/bnedynSuxwURHTKlAPXwVPLhZa1ke4H1r0VMqpIx+H4IDev8d+DiEJbZIThwPM4SFHuzLUV8kPTlFCQqnSvMv0wvld6wP2F0ajHbDvCFywl0bw5+v1ULQwBPwMXiGjrCrBX6fOpsBT1zBVaQJO/ta0KhJ7Z0pR4w3xcSPL+FijdI6nBfjwYBhTlRYQothfb8fGh3HREfIVIcUqavymcOIUCxmg6U29OTBEfO/CA3iufDtMDjgFwWXjQSVMM+ZJhZIfvl/WW/Z9MXhpwyRG+WiZp0LMs5BfGwPGa7j+LXk/u8y9ri94KvxIlBZWHb8EmWSSyguB4hvxoS+GCihmFzlx2vkT6RsO5k/9OcHRJQ8H6KORzWk65nkwBiwm+Cf4T7t2VUyUSGMlJ+ozvtm1HcJ80BbQO4KipMh69l79ZtOQyHWPC1pWVaV1xxG1dS6J2ObfhIO+FGgJ9csaPVryfN4GYJe+kyb5t3Iw3BkZCLWL6Ot6x9t8WPyDRCkNV9TKivDgTylsstfhTPmA3FQIOHn9xV957/QA/K/QBs71vDVMX6JQ6FcuepMBbknqh2izkU3cubqU+pt1RR7ixyeAKOkv/kvl79aQp6TJbtQbZKsE5BODxVbokMdD1hecg1+an0hANt7tA8C4F7Rd/n7hJm8KBbxqM8wsfPfJaTDMXdb6NSM83ZKgvHCOJN/qNYqAgJcs68FXBtVRv5uXf1RnNcgVoiHdEK4Af73WClqA0oKiju061Yu92L/gMPaVknD/SDcp6CTlqFum+akw2lVOUSb+GdeHtczbdzKSoOWbjiw38llqCA/3ZdXLbQ99VXTD+hEvY/EUpM4OsXpSWXNEMOzpVS/4gdP0GHpixPNgSY7Aq4iDI0DGMIN
 N9ZQKq2L
 ReL7hPZF+zuXDR0HJWpnLtgYuVV00cUw0d2VtwIxHe0w9sU1tZx8fvkSgBppZazAUna3IWMy4dU4zn+c5Kt8EBs1Er+alDd549uH49Y/pubrEbNzhWy8Gbq9KGXSjp7xWU69ArcJHX5ZXbYUiFfDNsu6w95baD2CYvMINIZUi5t/TqDvo9SxBd1RjWebHs5sZ+2VewAH1XDSKxeu9lg/cN9wAEUxQwRAL7ZYvxB3hF0A5qwNXCzIfkPPVjZu78vQ4saZYJ/CCxVwfhsqRgjoU3wnvinEJBfA0IKxG3qlDc4XQHspsul19Sxu8HSXOvltqbuPsNYP3Hbqun5CtSbAwZD2Sh2pCaHTWkJaA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 19 Oct 2026 10:39:30 -0700 Yosry Ahmed <yosry@kernel.org> wrote:

> I am glad the commit fixed your problem!
> 
> >
> > Great, thanks.
> >
> > oops, we haven't been cc'ing Yosry.
> >
> > > Definitely a -stable candidate. Andrew, will you send it to Greg, or shall I?
> >
> > I volunteer Yosry or Sean ;)
> >
> > I think 55780d8a1dcc should be repackaged before sending over to the
> > -stable people.  Its changelog is very wrong: "The bug is benign
> > though".  Update the changelog to explain that the bug is in fact evil.
> > Otherwise -stable and further downstream won't understand why we sent
> > it to them and won't understand the impact.
> 
> It was found through code inspection, there weren't any symptoms, and
> I think I know why my analysis was incomplete. It assumes that
> svm_recalc_instruction_intercepts() already ran at least once for L1
> (vmcb01) to configure its intercepts, which generally must be the case
> (L1 must start L2), except during migration :')
> 
> About repackaging, yeah we can add a note about the new finding and
> the necessity of the backport. One question tho, is there a way to
> send a patch to "all" stable branch (the same effect as adding Cc:
> stable retroactively), or do I need to send separate backports to all
> open stable branches?

As far as I understand, a cc:stable and a Fixes: will result in it
being backported into every tree which has the Fixes: target commit.  

> >
> > And that repackaging would be an opportunity to add
> > Reported-by:/Closes:/Tested-by: you, which is the least we can do to
> > thank you for all this diligent work!
> 
> Will do.

Thanks.

