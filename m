Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FC19606A33A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 13:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CN8rDF/C
Received: by kanga.kvack.org (Postfix)
	id C56856B05BE; Tue, 17 Nov 2026 08:09:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C073B6B05E4; Tue, 17 Nov 2026 08:09:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF51E6B05E5; Tue, 17 Nov 2026 08:09:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9168C6B05BE
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:09:33 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 29A5A1C3C2D
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:09:33 +0000 (UTC)
X-FDA: 85444642626.13.507ACF7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7C4A0A0006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:09:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CN8rDF/C";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794920971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MYlCavCmKBR+LcfhJHx6WNDCyIS5wdpBm9jT9WBogFw=;
	b=G91PxTUUTGe/Id1GuRCqEXHom/DEGjNKa3Zye8663KPiMBVWnTI3MG+pWarpTF2RHTYoNe
	2FUDniQ7z8k+o8VI9h4OX5tG2+fysS/pWl+aPvIKvE5DQ61XjuAmoHrkN4P46nbSSZJ9dZ
	znFEpQV8Uv+vI4vnNo8PK7RzA9a/qos=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CN8rDF/C";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794920971;
	b=EL1aJBdM0OCtj9XgTpqdfL7v0UowaXcbSLk0H42hF9nC6WNroi26M76KPTpsL/xRrDFto4
	+cxjalgIhX1ADj8mqS6FelXLid2qcLk7RvClrMjwHPnYhP7r4D4OYcSFKfj4lbpQJ/N55M
	Ykl+Y4zXONwFjv9s65iy/IFVirbxhjk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B5881450E7;
	Tue, 17 Nov 2026 13:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3771F000C4;
	Tue, 17 Nov 2026 13:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794920970;
	bh=MYlCavCmKBR+LcfhJHx6WNDCyIS5wdpBm9jT9WBogFw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CN8rDF/CUbNhGdiyHjCAuz5IQlDn3iZmVveFZowSyDnlwjfBoBajAEkldEHCfnP+8
	 LvzB7xSnpehC2DMCTIZcbLlcqe41Z8LGjH6LsxAK+jkmJJEn17s1ZYyGQ12QtKZB/i
	 ZnXx4nafqJUtuwBCQZ73qMSie9EUQ39m2XRb2xZ96/OI20FTnAy8Pc7jlJHyxHf/Sy
	 zvDjDn1lrSSjKiIJlNUjCCizTzczGQq3xngE8ajRTGZhtPh5ne3NSZmqkGoJ+VDB19
	 yv1DVazWv0zH1+atZx6Z6FsHFZFeuKPkNvzpP828G5PswbrrAwGS0ed4yLCo81UXpN
	 mJJJJUXu9y9Gw==
Date: Tue, 17 Nov 2026 15:09:24 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	David Hildenbrand <david@kernel.org>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 12/14] s390/sclp_ftp: Replace get_zeroed_page() with
 kzalloc()
Message-ID: <avxSBMGhTU0_QseV@kernel.org>
References: <20261108-s390-sclp-ready-v1-0-3e7c90eb6676@kernel.org>
 <20261108-s390-sclp-ready-v1-12-3e7c90eb6676@kernel.org>
 <20261116152608.165348B07-hca@linux.ibm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116152608.165348B07-hca@linux.ibm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7C4A0A0006
X-Stat-Signature: 6tczo9m759z4zuosqfi7gwbt9j369cot
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794920971-479372
X-HE-Meta: U2FsdGVkX1+E/x914VpLFEpPcgWVHwxtmPsupdpRI9T0IHmdVSX4LsSXID6KcQGEclFYPufnlAdJQTSeISHAdOiHKk4Y7I5m2/ey80ryfG+ySY5gbyvcgoTe4ceygrQxyLKYS49dj79K4qveiT5i14CbwihmKcvY5mcMsmFbeM1akZhZR5VV56014BnD1VZXL7bXDT8eer8U3it8wfD7MpQ9A/VfbO7bTQU4sUsGusniuJuT0zMOF28PPHmkNEvLB1d1Fag/wnaFFrBrvLcY6VC4DYSgVFfktHu8blNxMq1Q6gNbO9vcWxx9+rPMtzMGUELK8MNdr2qCGJaqiZrABNuMNF+8uLwWOmF9jXWNt2f4UxVhh5LJkbgEPvtOEGeUuhikQy+4EoBG5SNSsGeJYqd2EeF52I4gCHDFjzOhPbkUQVxYbeedzeh2JiGFo2cV7Bjt6k3kZTROo0OOhH94jN/I22eQ5AuK5oGUJcMXSwK2GLFVYy0zyW4I3GGGxpN/R8Klpy1lUp4gFZYY2OhMTwCKIZotkThPdN+rqlJEkOaCC9x8kqeKiycefnqKZGbjRzKvfbsQp95GAF0elsrCxJ7A1H1Ecv4iis2DKvpg7kWLatRGjL8somBbJZ6mAYk4QDpnKyf3A9XvKCLRRnUoRUl0quSXetlffL4ZZjb/JjMd57a7mpX5BxHoCL1oRWKiUXDErxhrlUHbgB8pxc1Z1u/OUG2WTk8Gy8nYBrjqMYOdyx56NW2Wm7lc87mbj9fQQVxjHyMQ3EgBvTGhp982qFKfFhvYPml49WM2Uh5wZG65MQ17/LKfu0eSydwCKKyOsy1RFbRim5AYPhAziqzwcRB9uMa2dgrp2Bl0T1AFOq+COIJZQKnFxlhUjuz/O77xgUq5FPpp4vtuIaC5CWxOj1nufQgbc5uVIC5vFgbzjv1AaqC4LPMzWoJfHjzAWqKUoeAFvcW/xN51y1Sz4Rs
 uWIuy3Bd
 CmE14d/aDwm6jEUSXzd549lvmPFPReBsixvhota3cUG7boh+JR55YXvHsogR7snV8t9YovU36she9qLp8OD9wt8fqHp+ej1rmPfLIMiA9An75yrVkUt0F+LBiMHR7r47k+5gwN0VzIbu+BpUzqREpmEfowMabBbn0I7hDRHPzFQD1a2WZbxPV9N3Y0nkYQmrb5Kx196L7l/PeyV+O9Wr/xGykVWz0LYy/MfneqozLxM5d2WvUSuOrwa9YeIq7XIJxWgdCXo+FlocOvQrJTmxWG2iTN7m5ZatzzERi/R2QDg5O3orCs+1i6CXhC2VptQLYu7KuwjuMZwravxIfSuwJWU67y/4yjm47G383
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 04:26:08PM +0100, Heiko Carstens wrote:
> On Sun, Nov 08, 2026 at 10:58:43AM +0200, Mike Rapoport (Microsoft) wrote:
> > sclp_ftp_et7() allocates the SCCB used for an HMC file transfer request
> > and sclp_ftp_startup() allocates the SCCB used to read the SCLP info in
> > the debug code.
> > 
> > These buffers can be allocated with kmalloc() as there's nothing special
> > about them to go directly to the page allocator.
> > 
> > kmalloc() provides a better API that does not require ugly casts and
> > kfree() does not need to know the size of the freed object.
> > 
> > Performance difference between kmalloc() and __get_free_pages() is not
> > measurable as both allocators take an object/page from a per-CPU list for
> > fast path allocations.
> > 
> > For the slow path the performance is anyway determined by the amount of
> > reclaim involved rather than by what allocator is used.
> > 
> > Replace use of get_zeroed_page() with kzalloc() and free_page() with
> > kfree().
> > 
> > Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  drivers/s390/char/sclp_ftp.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> ...
> 
> > @@ -250,7 +250,7 @@ int sclp_ftp_startup(void)
> >  		return rc;
> >  
> >  #ifdef DEBUG
> > -	info = get_zeroed_page(GFP_KERNEL);
> > +	info = (unsigned long)kzalloc(PAGE_SIZE, GFP_KERNEL);
> >  
> >  	if (info != 0) {
> >  		struct sysinfo_2_2_2 *info222 = (struct sysinfo_2_2_2 *)info;
> > @@ -262,7 +262,7 @@ int sclp_ftp_startup(void)
> >  				 info222->lpar_number, info222->name);
> >  		}
> >  
> > -		free_page(info);
> > +		kfree((void *)info);
> 
> Sashiko is right here, the ugly cast can go away with a trivial code change.

Argh, missed that in pre-send review :(

-- 
Sincerely yours,
Mike.

