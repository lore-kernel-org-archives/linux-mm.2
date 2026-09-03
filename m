Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65661C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 09:15:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D2926B0096; Thu,  3 Sep 2026 05:15:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A9AA6B009B; Thu,  3 Sep 2026 05:15:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E6E96B009D; Thu,  3 Sep 2026 05:15:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3DC056B0096
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:15:57 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 98B301A0175
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:15:56 +0000 (UTC)
X-FDA: 85171893912.08.FFCD528
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 05C6F20006
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:15:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E0zsCHKQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788426955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2a8yIQ3NE86fziYRRmM1NyoVwXAqG0dHOhexSSfbtW0=;
	b=h0Q/M6KyVcOPWGJFRrbM7jQLDSl3/aMbJpbC8Wm4fz2ohHH40I1AIFpXNKDq/Q9KW7oLml
	CnhubFDT5Ufqx9dJyIKkrrATgnDTG6a/zexicgQP9zto9k5IQwZLPkEfp6VNerRIEJFeRK
	4HMfP9IIw1pOIE/rW+93CfW+QvCTED4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788426955;
	b=hfgZK//+l6u0FaiTzW+uCBBaE12Xjpm/sVY42GNr9nnhVYlwi9FWCAmZZuP23MHjNkszXi
	wOkZuPC6RZu+2O4F+Vu1HuW9ViQ8hqKkQ8jMRvco1dkyDoxae53wnS2jgeHtCpgCYhnxPR
	2d6/zoSdymNGabq7M7X8BqCUPDjzEjQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E0zsCHKQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C994D404DB;
	Thu,  3 Sep 2026 09:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBCB61F000E9;
	Thu,  3 Sep 2026 09:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788426953;
	bh=2a8yIQ3NE86fziYRRmM1NyoVwXAqG0dHOhexSSfbtW0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E0zsCHKQLk4p8gAn3X8j4oy3KYslGMK/guDz3UOJRR2N9We0sVvbpFK/tqFZEs6hS
	 QGZTNx4CYKtVtsv0C4c6LK+370dmf6vuYWyChytDHcZjngcrLBJRbI1EPFabmoqMSA
	 qZY2m0BNqpRVODEnXYlMUDe3XKdhPYn1UADPoG0K7Kp5YbWUwTwJMx998EnYZp5x+E
	 7GFc412nEoX9MMCL8ZxJywrQM0nTSpoDEGJ7jQOSeDwqfeL2JHMR5tpX8WtDYELqbb
	 7IrVKjbr8LEORFSJMs8oYP5mXCSNx/j4l/PbFzx/kbmKrHsqq6Xbb9o6tQoUAyn5GT
	 6o2UQOGFJA4eA==
Date: Thu, 3 Sep 2026 12:15:46 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Eli Billauer <eli.billauer@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Brad Warrum <bwarrum@linux.ibm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Michal Simek <michal.simek@amd.com>,
	Ritu Agarwal <rituagar@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 2/4] char: xillybus: replace __get_free_pages() with
 kmalloc()
Message-ID: <apk6wr2S1IOQp_Kf@kernel.org>
References: <20260830-char-misc-v1-0-05e2ce44f291@kernel.org>
 <20260830-char-misc-v1-2-05e2ce44f291@kernel.org>
 <f6001085-9234-4025-ff34-6cc4a66c293a@outbound.gmail.com>
 <apVmYXlqsVr_p4Oc@kernel.org>
 <7adfefaa-91c5-4bf4-ff98-5dfbba0eac96@outbound.gmail.com>
 <apcKQBRCFeF-usK7@kernel.org>
 <2d7b127d-6079-40c0-2020-dc7767b2396b@outbound.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d7b127d-6079-40c0-2020-dc7767b2396b@outbound.gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 05C6F20006
X-Stat-Signature: 76dxs4trzr48umi1jbrdjiupcprnt6yr
X-Rspam-User: 
X-HE-Tag: 1788426954-617777
X-HE-Meta: U2FsdGVkX1/Lho0yELDdvRTCfcXAd6HdqxO8Uc0fMZZ5yCQb2eUBkWxZIDAhe9Y34lrCBRn19WezICVKRF3zR1KFAWDIDEzani+akl/8FoxiOWJnMXtO0PIo99UVV4Xhr5M3quTAnsWUU4DPm3u5J5riNrfO4abrpZYzthjoJVbve+7DeU74buC+Uvzi8pxfsGM2SmA0n2YklukJlnYya1Ep/AyIvD8rxsaNZEebxJRSN1mmGfz8uGd5lYbOeCSviwCDhEaQSfds6DzaEHGOcLE8Ye0b3TPAMqPzmOtdr95RBWsqwU3N1BrvHq5Yz6ufAQkKlSU+QD7fNskhnc0aa+dN0f9IA1rt87tJX2JOa2lKaPWgPqrd8YVWENtUSfRDMvjeiQb4fvVauDGqfWwqy0jOhZ0RdthKztTjK7UpCewANurrSU79FB4MvCj04WIU3tTPFyqEEOwitO+7dMN9IXhSLb/GO64o74KePyZpnyRKpDRnKY85u1wwtpFcTm+OyQaMioIubMGSACM6uAvDj/L9eDOK67+7SMCAfqWhJP1eI55v68q8Wb86pQtrX/0nMhdroR3fwBDoVqSUvFhQ72AQtffcffrdtekz8p1lzmaDSGpEExfaZjFLCWLq6phDZS2vdqVn99S6Se0yzBBdHf9bSapUDzg4uJ2CbhLUM4lRVWtUX2k2yoF6rIyrhwoodIPRnFbDgtH7Mtn8tCviwoKqJm9JzWNyH2xF0NgUQ64QEgNUI7btNLAVSZts9vAzQqAS3GCuMBf5l9pZ53PFnCTImYafyVIizfazJF4b8s0cVgSSbuQwFXAmd9uvjYo1ya6G64j2DdivdXWaAfep1WhN+crtlGX+yOAXseCYeVuf0CH4mWVypPRSjauNo09BrNyArCiRJCKSylg9mKyEGjzMjniNzsep74ZTxfJQOsQjJ92dfKPvPSWbWOH94DTRs67a8XgBu5XV01GBPzl
 TzkskCs4
 K9oq6ysQ0TisRrzBrznHJCbd4c/o0tXR/Dcjg+jbA0ZDDKU95F+UMCKYkjX+NjmhMexCse/ucXu5sdV/PrOwvo/bGMElWUhZT1yjnYDGfvRIkaHi94rAEhN/hkc9o+Jlw749y4kqXOWJ8GNmtc5oNLVqkHZ/pCL49+Bmlykji8NCx/9ITbY9r0ugPrWNl7x/F8/Gdo94DUhONHyPtD+J2BT+oqVNzRXoQ+tAVXPf65fDem48S4bzG2cuJ9MPtifXdz75d7FOwFxCtdvdY64OR19lyN7rptr1XWNUiUzcnPZlQCknolM77VT9LiuAZrtczT5jWApfIMdDCnviT+RFvHo+PIDMv/jo+d7BQfL9Vjr2FB63e6Xj7aInK3b+b7xxonkxe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 01:40:21PM +0200, Eli Billauer wrote:
> On 01/09/2026 19:24, Mike Rapoport wrote:
> > On Tue, Sep 01, 2026 at 10:42:47AM +0200, Eli Billauer wrote:
> > > On 31/08/2026 13:32, Mike Rapoport wrote:
> > > > For large sizes kmalloc falls back to page allocator anyway.
> > > > 
> > > > And the doc is out of date unfortunately.
> > > I think it would be a good idea to update the doc first, and by doing so
> > > officially change the API. After getting this change approved, it's indeed
> > > safe to rely on kmalloc() even for larger memory allocations.
> > The documentation always lags behind the code and "official" API is what
> > include/linux/slab.h says :)
> 
> This is what I found in slab.h:
> 
>  *
>  * kmalloc is the normal method of allocating memory
>  * for objects smaller than page size in the kernel.
>  *

Citing vbabka:

that sentence doesn't exclude >PAGE_SIZE allocations :)
 
> Regards,
>    Eli
> 

-- 
Sincerely yours,
Mike.

