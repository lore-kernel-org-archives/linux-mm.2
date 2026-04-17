Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A41A8F436B4
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 15:09:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2F1E6B011B; Fri, 17 Apr 2026 11:09:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDEC16B011D; Fri, 17 Apr 2026 11:09:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF5A46B011E; Fri, 17 Apr 2026 11:09:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD9F26B011B
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 11:09:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 829B81B7108
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 15:09:10 +0000 (UTC)
X-FDA: 84668380860.26.C59D869
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id A06D540016
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 15:09:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vxUywOw5;
	spf=none (imf04.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776438548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uw8dwXId/yPwcrCcGJGBKafy5htb5BP4SZRU2vJxBOw=;
	b=cvr3yz8JIhXgzH/qymYiL8OWF6Kt/m9BMkqo/UNSPA3XzNKDNYvRq1GlgdmNil1+PXcAgZ
	A0b6D0lZeYK0mk4OLJaTI/xvug17E4uMeO00G9GhFboWbsCJhG+9LC8AXsX8fMz1axXi5M
	v0K9MhW20XTqhV4iNMGw+Olw4YzPy4g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776438548; a=rsa-sha256;
	cv=none;
	b=sgao4BAql9ur7GmJv04zfIPwhELLqo9Y4D8MgSrI3oNoawe9ok2tuiukPb9l5cgg2aCBgm
	2MsF2thCLy5Ke4YR1YS82g2MVIXaty+dg38e4+EJTpH9hIS6Tu4AiPXd9XGm9aTa+Ach3i
	aqXkLAf6SuZwNov3Xfi1yO9FfU3+dYw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vxUywOw5;
	spf=none (imf04.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Uw8dwXId/yPwcrCcGJGBKafy5htb5BP4SZRU2vJxBOw=; b=vxUywOw5NQFi+GzBgs01Fo4Zhw
	BowXSTTWEDVn5n3dOS73hd3sTkaaYtTvNuxfAQ3DVLg+PqqDexIfrCF3FTLyegSqcRXvtI4TIwndN
	reVlHiOBKBy8r551AKVh7HCWNYmjVk6dc9GxWBFwnU+wzV3R+wuit4iRoxxxvoKzgAlxD5eEjfsZ1
	w0bdJ0Y4nQY9loA7LLPHN1cNGnd/pQW3w/DA6JgoR7gDPxNTwvKdoq0wni4rmWj9j9p1ymlCUkhqI
	eD78UMSUL7qCY8fm3MrdR8DipR3ma246w1AbeC53gq6VTUP4bW3aL5LJe9aDlTig3mrbG72SLHCQr
	HhoXo13A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wDkoY-000000044KE-1kM9;
	Fri, 17 Apr 2026 15:09:02 +0000
Date: Fri, 17 Apr 2026 16:09:02 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	ZhengYuan Huang <gality369@gmail.com>, akpm@linux-foundation.org,
	ljs@kernel.org, Liam.Howlett@oracle.com, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
	r33s3n6@gmail.com, zzzccc427@gmail.com
Subject: Re: [PATCH] mm: prepare anon_vma before swapin rmap
Message-ID: <aeJNDo2jFkKGyzyq@casper.infradead.org>
References: <20260417011606.1089985-1-gality369@gmail.com>
 <66f67e51-819b-4c60-9f61-170db32362a2@kernel.org>
 <fb80d953-93de-4ce3-80c6-15cd53dd956f@kernel.org>
 <aeIviKEdw-52J7JY@casper.infradead.org>
 <b6519ff8-3a8c-4add-a313-c36b13fad231@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6519ff8-3a8c-4add-a313-c36b13fad231@kernel.org>
X-Rspamd-Queue-Id: A06D540016
X-Rspamd-Server: rspam07
X-Stat-Signature: d4txczy6f73ww53rrg1uqgjn55kpzzu6
X-Rspam-User: 
X-HE-Tag: 1776438546-214050
X-HE-Meta: U2FsdGVkX19BlnfIPKMupnvZBnmQQEpoLEenHfGGh8FwboFV+tdPGnFWWEbiurbQSQZTFr77hR6dAp7uhFDWDU1BSBhdg18EKe7FKRsrLTsM2Hem02ck+IGzW+IzJoRDS55yZmJgsNtT/hCwO3ct7Z8rUWMrpmVpz4iJQ8UMZrykpnFs2PnowG6mWw8gD5+G+YBcUgZbTdj3HQHaMEtseCfJjBpUa7YIpBxFyISRFx6joNU8KFeCJ36ok9qp1AqgUk/dqpmFW3aLb4u3Ow1vEjCW9KiQd3pY2YNwGAgnnfZCXN2qXrzRu9loq1exGP+jxNYVtNh5STAlNrCtDiavp30rfPWWIJrckEcv2sCSYjOeBgebLKCI7ec6MeTQC1tTTJtmyx4fp2FbB7tdcrKeYRdPZ/HvFVxAXy4g/JOUYM9wjoJZxoVPtnvOP8uSVHO8FOgV2X6tFjIBxDzHaPZMiccDtHmHBu57cm38chd9N/J8leNAJaZWYVcVxZp/4sku0ijO8yDLk2kkil7i3bKVMMc2yEq4eV6tL9iMAxguL1AHjUJMvto8RrX6uKbfRaavnAjGbnTAyrOJ4Vd4Vs6Y2dmQ97ccfenc7kp6w1wKtNSQzE2dPciQg2xxdC5IACNR9oUPzCrUQ/Fc4kecYAkinqoNvM26VyX5C6X2eqrOg9u5xcVGfPqXkInEx1wxZZ3Z//7Ybd+yDBuJj0hAyOfBAI+KjWwZ9m1IRqjMBqtvDSzYF41MsOpbd4uptJZQXsSdPhbWZ6AR37UwWBtVcLG/qDy0cALnlMdROLXwm9K75Y+Ve4URD0qnYBsvvwId7GMiRSn+9d+UBriQ6p3xQPhP++eZXkJwF55cDf1Ri1GKuIx+dAPG81SQ+OPAF4q6u0oiAN8hQwhD+yZ8VDpBAI+GL4sc/AVx8wGZMo/DKip6jMOXqgAf4VlllfmHEaS5j9/7tC2HbWKLN0AazeUMUjx
 W0bfsOM3
 YaXv+FgTHv7YjVzDkOAwSwNiM08NnZwxitw2rH0svZGpOPqDZlJ6nh+BthhUoEE5hozkcij4rO9Rghw3QzusbkONlcqDU/PyyZ/Gw3BBtgNdJhXJMFwabnkX2tzwclJ6qs+gf+AgEsrxIUFzxYCpfxlwqWR0iwzQ7m7CCSXbTsDC6+O0lu8gQoq5sl4vdyRN4YMdf8702c89X/IiMJjJG9zDKrIhrcDQv1/VCNZZSDBERR4AWvsMnVOKra5inPV3Rw9KMVP/pP4EFLm9P228uKv4t8NljS8u5jRXLqvR7fvBRwyXTAhtuCdKEhD1l9YIcWqE4Da8N13WAJOvVZOO17G3UWCkeeSqJjtTsj99OWg4qP0nOiy/efMShY3fmMT1UnRMB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 17, 2026 at 03:36:59PM +0200, Vlastimil Babka (SUSE) wrote:
> On 4/17/26 15:03, Matthew Wilcox wrote:
> > On Fri, Apr 17, 2026 at 01:57:59PM +0200, David Hildenbrand (Arm) wrote:
> >> Just speculating, we had
> >> 
> >> commit 3b617fd3d317bf9dd7e2c233e56eafef05734c9d
> >> Author: Lorenzo Stoakes <ljs@kernel.org>
> >> Date:   Mon Jan 5 20:11:49 2026 +0000
> >> 
> >>     mm/vma: enforce VMA fork limit on unfaulted,faulted mremap merge too
> >> 
> >> Go into v6.19.
> >> 
> >> Maybe there was a scenario where we could have lost vma->anon_vma during
> >> a merge, resulting in a swapped page in an anon_vma.
> >> 
> >> If this cannot be reproduced on 6.19+,there is nothing to worry about.
> > 
> > ... except that 6.18 is LTS so we need a fix for that kernel version.
> 
> It's there: https://kernel.dance/#3b617fd3d317bf9dd7e2c233e56eafef05734c9d
> 
> > And maybe 6.12 as well (a373baed5a9d went into 6.9, so no need to
> > go further back than that)
> 
> Not there (yet?) but it was tagged stable.

879bca0a2c4f (the commit fixed by 3b617fd3d317) went into 6.15, so if
that's the problem then there's no need to backport 3b617fd3d317 to 6.12.
Unless someone backported 879bca0a2c4f to 6.12 which they might have
since it was a fix for a 2011 commit.  But so far nobody seems to have
done that, and since it's only a performance bug (right?), probably
nobody will bother.

