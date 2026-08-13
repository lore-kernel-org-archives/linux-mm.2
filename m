Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10B0BC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 09:07:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 298DF6B0436; Thu, 13 Aug 2026 05:07:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 249776B0437; Thu, 13 Aug 2026 05:07:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 139D06B0438; Thu, 13 Aug 2026 05:07:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E585C6B0436
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:07:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 697DBA2C40
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:07:00 +0000 (UTC)
X-FDA: 85095666600.11.557AC4B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id C88F940004
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:06:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UZ1JRuGv;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786612018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f74M4vY5M+2zO1em0yOqfoJZ60aIm02Bq2xp6Rph69k=;
	b=MitBthHfg8f/KGSz0UWrjutKeP60vN7Lbal1U9n9xyiKJxea+IzDfLZAiU75biWuZ5xBWt
	ezwbqN+u7tCFIGFePvTtiIWOLKSnrNLYD9H+RJ192BUd/8UfsA3C0y6tupT4aVfJ5u2bbu
	WHiW9PxKS45uQTBmjaz87/tpmFg/WmI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UZ1JRuGv;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786612018;
	b=A8ly3EyDBKIJapw2+SXD+rc/bOslm4Gc6FFl+bBpTylZj9JOxgAV1LojLJQf8/rrEY7Yxw
	lNcP+OFCd+kwjdhznkr4goLXcBAwK7Pc0gxE8SwKPsWUkin7BmKDQiOCE4YCr8v667mQy2
	3w2MOHlfO94YSU2ezr1KDkvTpfCz930=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 040DE434F2;
	Thu, 13 Aug 2026 09:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193941F000E9;
	Thu, 13 Aug 2026 09:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786612017;
	bh=f74M4vY5M+2zO1em0yOqfoJZ60aIm02Bq2xp6Rph69k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UZ1JRuGvfKkMyoxXfQ8kKoa030GuhZsX9w/7MUDxcPmPecINNwx/WxJhR5cDxJzkR
	 /1kbAoVtalAYqD2He1nq9FJtU89y4q6aiGhMGrdErZEn+I5YdKz6w946Fk/qEMAF3B
	 pTFPf/qYgy5I9fVvRB4c94tWQvxMB8+H8TXUUSoACVtNykug+Ayb/EQJfqmqF8rDa+
	 6E124O0yDYZ5IJh5sxcj/mqoZAeIZ5HJU0oCQDcB1gcsAyNK5pFr0vrsddBkg9Io4c
	 Md9RPmDtObgg3yckY+CLkSo6ohVCFK11OmIThdsayNORgEQascflUh+lhwp4ehbVKn
	 K6cWSkGaPvKVw==
Date: Thu, 13 Aug 2026 10:06:34 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Mike Rapoport <rppt@kernel.org>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, 
	Borislav Petkov <bp@alien8.de>, David CARLIER <devnexen@gmail.com>, 
	David Hildenbrand <david@kernel.org>, Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Juergen Gross <jgross@suse.com>, Kevin Tian <kevin.tian@intel.com>, 
	Kiryl Shutsemau <kas@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Toshi Kani <toshi.kani@hpe.com>, 
	Vishal Moola <vishal.moola@gmail.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Will Deacon <will@kernel.org>, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org, 
	syzbot@syzkaller.appspotmail.com
Subject: Re: [PATCH 0/5] x86/mm/pat: CPA fixes
Message-ID: <an2I80eAb1hb1q1t@lucifer>
References: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
 <anCwUb9lV18v6mfN@kernel.org>
 <anXp--mLLEE2Qo0g@lucifer>
 <90c2be6e-fe03-4da9-88d2-fe4d4f745cf2@intel.com>
 <an2GkrW35R5reoeC@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an2GkrW35R5reoeC@lucifer>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C88F940004
X-Stat-Signature: f39f1p9d1bf5zxxay1oendqfrqhgomk7
X-Rspam-User: 
X-HE-Tag: 1786612018-388876
X-HE-Meta: U2FsdGVkX19MSec4nGvNIBbS2hh20F2wsCePGYWzQffIwvSZWxvlZY3Fbo9N+IxG1L/m4JYSLf0UJFNb2sHcA8gyP1ubWgWuFWnKsd/6lunYQq8U5Td9DS4mxwHrtrZ7fGKKvgzGWoPHrkVkiXdI3/VLuM62DfYDtDb/noP9v6aDLx19UHRrl+NrcKrpv+VnlEnj7vEByGWmhn3Ls4GV7IsRHgXhmdXtXN/aef4eIoBwFy8X/4MGNe0PX2bWC+Dh/PU+CcRHspXzDgeDFKBS0tSIn3yFrESf33Odx6Sbjt8r98XsVpNakykiKWCURMQreY1EbhWhsSJ9t8AjubLOodv7apT68QnvX6T1ByMx5+d4099EjwrFbtIyUslnWUiBPuVXXpQ7PDKzoHRGmRJ0VjIKPP7+Xk1IXnlQTs0x1iG7L/DOEFP1mcHW7maZJ7JxXIs9tpfJxeawgYBQwkCauoP6E+comwGzQ3GFnnx9A7XL++layH9PLbHv4VQhDXaiIKd3BOY7DoJ7WbiWAaaWRzvyL13DwrKlJOSxiRkFs5B2uaUsVWDQZkCt0sEBUbra9teO3NvAWEtiW7E7cwvzFPXdvFpqGVNnVXB3MnNa6/3cik5kU4Zu9flm2P5so+xTl6hYw387rkH9AKdtI95MKR6Rx3/fb1n1t0Zxp/cLlBt+k7njHpgbLeTQqitjqdU/7L3Y1FVxOVYWjoKu1Dss4REJQV4IdngWvRNl7dSvQYYzPNjRQQHO18Jj/nCtvOqjg1lhHcG70/nvevp7Nsa4YJZnfkA/lY2A8FRMr9d0zGfkN1pSUtJRC1dftcrqP3l8p69ODWsBzpTwFLpihqaErz5x3QKP4Rp1HEMqSHWtscAnYSk1yXt7jPC+/w5f+9hqcUdO70dhsxTDJCizLDTIQ7CWUIHRRMfcpolru1pNreKbkcZ02Gpr5uYwSywwXgh6rnc85u/WmrjAiSfoNmb
 kmoi2an4
 b9mvosuroH4qb4zoZR8JzNREFLJoGMAKN4GCvhNnBz/E1TNTHoYt8k+Odpf7mrN9j8q3hFXE9hoA45LLbhjS2ExOOA4Vg77f7r7NyTfSaj93lOvBD8JRpyifSIy+AJLDYLi2DaIxVIEFiNIDrwRl/HycQbMMpFc2sSRjJ6pvJNa0GdV/KB1Ceb0Igtct33Bd/b/2gQWJ9IIlv+r+DNdZaKrdD7sSouzmg7qSottn+zPj2rAoSzy5YzPjvqKF6mI0O1ucTofGgAWhegEDM7tAnYGRXEGVIZ0cMh2Y8DCtiQFgcB4rxQVElBBV/XgVO7exbwQakLomWlXExuXv48mW1xOpZRg8q71a+b5xT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 09:57:33AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Wed, Aug 12, 2026 at 03:20:23PM -0700, Dave Hansen wrote:
> > On 8/7/26 07:34, Lorenzo Stoakes (ARM) wrote:
> > > In any case - Mike - I think you probably need to respin this on tip
> > > x86/mm anyway?
> > >
> > > Maybe worth doing that and seeing if that makes life a little easier for
> > > the x86 folks.
> >
> > Yes, please. If it interacts with things in there, a rebase would be
> > much appreciated.
>
> Thanks, Mike is already working on one I think he should get a rebased respin
> out shortly :)
>
> >
> > Also, please do send things separately if they are fixing active
> > regressions or bugs that folks are hitting in the real world. We'll send
> > those urgently and not through the normal tip/x86/mm process.
>
> By separately how do you mean, as individual patches? There are some ordering
> requirements here I think, is it OK as a series on that basis?

Why, speak of the devil :)

https://lore.kernel.org/all/20260813-cpa-fixes-v2-0-39b4ff90f91d@kernel.org/

Let us know if you need anything us from us, happy to help!

--
Cheers, Lorenzo

