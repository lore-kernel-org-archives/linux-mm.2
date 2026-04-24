Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0D63FED3C0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 12:41:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 451526B00A4; Fri, 24 Apr 2026 08:41:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 428AE6B00A6; Fri, 24 Apr 2026 08:41:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 366606B00A7; Fri, 24 Apr 2026 08:41:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 275666B00A4
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:41:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B4761160132
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:41:46 +0000 (UTC)
X-FDA: 84693411012.01.D37D865
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0B81A140006
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:41:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nLQI89a2;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777034505; a=rsa-sha256;
	cv=none;
	b=BvAwCryIWmeFVvBHFfblrnolE+wS2OgHR+u3hZEmcZxEAyAvoy6PxaM+ZJuAw+Bw+JMWkT
	VnTfHWSMAy9Si5kZ34q/svfrnnd7Cc0Hud3bySGeSWDGMGXzhF99m0zmNXYVCXSVeP2exx
	syOXjunRb9se7oeSSj577/ibNX99Mw4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nLQI89a2;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777034505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C4F+IOniokIYjGcU7tu8UzxEE02kHEqSXMi/8M2Uw/4=;
	b=c/UssxP4ItKbJto1hPKRiNYOJjxlw64UUO0eJ35UCRfobUs1Yxh7O4lUNlGjy70AG8CwSL
	T3GfrRFClvFqGbBF4MIeX24D8eOZqqhd2vg1e56JV0ielGxaqIzcuoRHmE9QyVQmKOZfO6
	dd75Z0naAaLh7MwbhwgcWu7AVUpNCco=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 665BE600AE;
	Fri, 24 Apr 2026 12:41:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C70C19425;
	Fri, 24 Apr 2026 12:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777034504;
	bh=6WyGvXM6KrRwk2FYS/oHDsLRLQGvZ+dAbuY5JYWFfvk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=nLQI89a2V5ZI3KSg9JZd/J/lYid7rrGeqdezDBgBTSzXvSAlSBciZ7LLTyVQK2q2e
	 XEW/dXU0S/wLlplEyMAdQiN9qa751li2Fo5LV2FbPmIqN3tIjfP85bUW1mqrM4PlDC
	 I5pt/yFYU/S9MtVBVld3gRpAxY2zPuz8towAG22k=
Date: Fri, 24 Apr 2026 05:41:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard
 <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v2] mm/gup: honour FOLL_PIN in NOMMU
 __get_user_pages_locked()
Message-Id: <20260424054143.087847e1617a84df8b501313@linux-foundation.org>
In-Reply-To: <e9c5cf89-fa4c-4b83-ae70-9d3c72542ee9@kernel.org>
References: <2026042303-vendor-outright-b9d2@gregkh>
	<a20913f0-476c-4f56-a044-9802bb1c7f1a@kernel.org>
	<2026042431-charter-ranging-597c@gregkh>
	<e9c5cf89-fa4c-4b83-ae70-9d3c72542ee9@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0B81A140006
X-Rspamd-Server: rspam12
X-Stat-Signature: jxdbkmnoogtrkb6ibtqb7ebt6dnwxa86
X-Rspam-User: 
X-HE-Tag: 1777034504-390240
X-HE-Meta: U2FsdGVkX1+j4F52FGF1qTLpQS/ZQnMVbh6/EsdG8Px8iPahRvoZtm3XKvKazUmVbOOHts2GRuYwEL2FwOk+W0bbZjd0BwrKozN2SWUy/pu3mfQq7BRo9OVmruqzwRpFrneQVm+Nce3CqorjSYCDABob0VRJrKKVElj+VL3lgL729KnhJwNhh5YKbe0CserO9JummI6j3p5SLLY39mMgMFnBCg6JVWzX6kYAAEJ5Qz7me/fyByQIW8vAGF6yRC7zgXeKfHbdN20+ClJOgtl68jOxFeNabFIIpbuPe4O7Q6Co2LFeurOf+2wB2N/rW4/YLyz37ikw3wPnsLhxcvBrr2Y+F8SQ98zAlGPdrZHMBm9tnas6pYJ3uiJOKLuLUY6TmaaXRO75MFz2m1WFqA6BrKAZm/5kXFk97h8e0JIDiFi1otnjCVMlVhRWZ61w8efjQx0hOBy9wnYXdBRa18oxuDiSZ9nxYR5uTqYpq9eSA6e9oEfV6xrlQEAo52Qj+1TSVo/Hr/RBE/QGmYc30jWF5qqtuOtdfhRmAsXT3nRaGKBodd7hDeUgEewOz9zl6SOtWPFBtK1AbZOqBvTaJqcQUzczPmUouHE8WxtMHOottshfcxj/tNCUYEeZ3AWb4v8g2dpIrXqnsBeLIc6uoqCuLwPN9Fv6XISJKkLkE6rYYwKlFFsYLFcVMSphCCrv/GW3bKNIQzjeaXdDQkQKq68bOwkRhdgVLLZA1DTrmJo5iFrYoVnA9tdGt1AW9Saz/MHRHUisfmNYnfclCKBUAzNyq1EPm898jhC3OG9NQEGeizjP4s3YbwgQxc3x4zNepkeOXJPeTFnKJC0FROTNI7QWCBzfzb6Mltueg/o4Qs/Sy11LN8RLAlJgw01MBpLjde6TyZCw4qETkrcpKEhCCz2/fg3V5xyTZptWxxj4BsajEQ5hc8ocKXmbhCBy/FflYIwrJpmzXja38Iyo1nkaFr1
 qTUQRIzJ
 0Mie1dHyd2XiVHxSgoBMPLj5/8bKtQ3Ga4VUM7kKfQFdIS1llnmAsGjpcX1Gh5b25FfpQ1uhlePEd/LjDMcPp5n9APfeMST22LCa9Vt6cIjJMaA5gfnwhp3guY1XAIg/8ACA3NH/IAZQjYzak1yJqcbI8/UfA/0c9J3T4q+sRFBuI7NMU/cQWLTU6PirvHfnorZhLi2pE2ttvBCdYBUKmHMJZFQURbd/mJgg1aB4PSf7O2gYwqdfSIAH8WzWosUIFtTqoJ6onuWygXGjBehEDivQWjYU39dtWk7XBP3vE27g10rsLjlPEj4lNQ9Jyr22QxeVRwPzJDhjXJvR2jjTae5RdQv3CUt/m58fA56ZvZZoTHCPYxpuKgUpHvNyEVwMBcRb6UKbuLWObkMiOtuqLT23dkSeYPHIKG9NqRiTJXLSTLr8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Apr 2026 14:16:21 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> >>> Cc: David Hildenbrand <david@kernel.org>
> >>> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> >>> Cc: John Hubbard <jhubbard@nvidia.com>
> >>> Cc: Peter Xu <peterx@redhat.com>
> >>> Reported-by: Anthropic
> >>> Assisted-by: gkh_clanker_t1000
> >>
> >> Assisted-by: David :(
> >>
> >> (no, I'm not a tool! :) )
> > 
> > True, sorry, I guess people can "assist", I should have added that.
> > 
> > If Andrew's tools automatically pick this up then:
> > 
> > Assisted-by: David Hildenbrand <david@kernel.org>
> 
> I think we usually use Suggested-by:, but really I was just joking :)

I thought you were gkh_clanker_t1000

> Andrew, can you add "While at it, don't return NULL pointers in the page array,
> as this is really not expected for GUP users; instead, just fail and return
> -EFAULT."? Thanks!

Did.

