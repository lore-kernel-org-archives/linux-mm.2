Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B6A2EDB7E8
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 10:08:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC2FD6B0088; Tue,  7 Apr 2026 06:08:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A73A86B0089; Tue,  7 Apr 2026 06:08:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9896E6B008A; Tue,  7 Apr 2026 06:08:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 85F9E6B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 06:08:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 476E5C1789
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:08:29 +0000 (UTC)
X-FDA: 84631335138.27.C51E306
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7C01C100006
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:08:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OjqNwhS0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775556507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cfar0aBz7g5t2ZOqLZ+P2js5EhdQh95PA1bgX64PG+4=;
	b=sbDPf9VCCF5dlTICUKu0aHhePc4DWJlJ6YVEumBC0seP0ptIyEPhveE8Z+0ywB2+Cclvgq
	my8wIwvOnbFssHVF1thNywiagSc4Xa3smOkoEjdxDo9qeRfVuGXC0H4JZE7n2kgxA1uEPL
	9YponLFHmXNnGelMrOViCyV4InPFO6o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775556507; a=rsa-sha256;
	cv=none;
	b=4TrIvNXHtM1+oC2a6hQnydj9i25wzmputjhm/Cl8D7d/cXjSkQ4YF/WMJ0MqbZZ/fihsGg
	ZT9tMEKYX8DBzHVvKgFBHRzybZpSEePHjSFOEEu+nruq1k05E/fYMZRGzNOeJCaScFYmJ2
	IQQoyYQ5H13VTmjtJv1+BTi2ghs1fTw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OjqNwhS0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 524A044504;
	Tue,  7 Apr 2026 10:08:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC99DC116C6;
	Tue,  7 Apr 2026 10:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775556506;
	bh=LJPJyFP0f2YfeF5uUdY6JnT5FwY6kPTuyJbRkKuNSVw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OjqNwhS053IkVX8CBweRCuteB09IAJKrQK8Ve61pjglln2XH0KA8YzqYFWl2vT056
	 gsVk5hHrcG22Fl9h2ynZVl2HYMCVmlV2abyBDoUheXBZOU+uxILBN6EXItMSgwJVhh
	 5ISkLxxSUYayF2Xw4UeAxAl6vj7tHxcoXTsWKK0fNBX8GgJgWlVNL/gjhc+xXZ03bN
	 zIymO/Qxm/ZpqSYTn5VLUZgUmmYc1Yy2Pn8nCa15Uv6hLIZQXTBY4rFOv7Qx2EZ4t3
	 GJK0LeeIYNzqeTtTiZoAj2IBsSb5fh4tdc62U6PIyO/aiXFzROR5ugvwXvm1v0Gpof
	 /RFVVQtZLajkg==
Date: Tue, 7 Apr 2026 11:08:21 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (arm)" <david@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Dev Jain <dev.jain@arm.com>, 
	Luke Yang <luyang@redhat.com>, jhladky@redhat.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] mm/mprotect: micro-optimization work
Message-ID: <adTXZTApsalskiZU@lucifer>
References: <20260402141628.3367596-1-pfalcato@suse.de>
 <20260402113328.fd0a6f0e28cf74a651fa2291@linux-foundation.org>
 <6bl5bzq742c522nmhlshlnf6ho6y6a747l3zh63aagp7kfxymv@s2c6fsuikn4m>
 <a3ace37b-b75b-47dd-ad7c-c7c3f799dfdb@kernel.org>
 <20260406103854.f48c27d7709beb680268d388@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260406103854.f48c27d7709beb680268d388@linux-foundation.org>
X-Rspamd-Queue-Id: 7C01C100006
X-Stat-Signature: thitabwrjbfw9uacx1ct6yithzt7dhq4
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775556507-949946
X-HE-Meta: U2FsdGVkX1+O/c3eINqvwNUXF6ZI0cpAiY23vefNfupaMMrQ275QKPeYHhm3rKwzfxs0o+39vnxJOKXwaE2Vwrka1Quj2i58wHcAYPwFepfFuljCm7ZNrAreyuSSqW8uiK5689mNCziGTQQGIl7AQVfi3nck3Vt4mTT1NRTdXB/8Gd6FUZyWHvHLzwWWznWS72PZOvpK1Y84qv9k6cItsCAHNua8USLBtWoLFTde2o03GCs372mNgh33mtqaHJXRYk7s13mHB+hP8kJFA2TGv3J/AAD+K9BF0S3Nntcdyqd3v1Sm+dB79fdMWEPSZMLmpS5Qrg8Jl/LhypyZEbeYpbKwfR79HH+yuj1k6aChrxf5ltvvsK2iLvXgAWs6wKZXNVHgXMs1WeqfJ6EhgXCqMSJF24A/5pNnZo+fo08Fd10SQZkF3xDio+JYqnjF1Jkh9s7A9mNTFlgBC0j1hL+r2jIwXQ0i+M8y0Ov8PeHAIS5Jnq5WdXlGFPmSl6Z65z78GEhJHPJbfoTpVDxX8kEWpvMt14ive7/Ha37Wpc0EOtQNO451PGlpVMsoWfXTNo9fZox0OmTxk405SFE24H1+n5cOd1yVaahjruffrayqeHE8+A8oBaLk3cYCzDMHGytyzjfXpkT29u9N1Ph3pPFEqfHy6ZmFhrqxWKPtt1DqfRjslFpTlEn6qaiu4LXSWcKoby4mJ7OflcPkGhgjP2qkxdIKQA3EX6exQtKAQN+RPKIonPvSmDKzj07PKe0GkHbEGzqMHJKbHf3LIDFMhdzQoEUhGSIz/6E08edW57WMTbF7HhA+2418lrDwvdQnbcclGDvutzcaxJ/Oac5g4h4ViAV3t64uAkDBjEMwpgJ25JglnbE1HJaOI9uNzKZpdB6+V51nr/1eLX8Vx2sOIJTb6rND2mgIUWqt81HEo68CLWgtTm6Z9a6eTr4MEEq3oK9fyU/A1HCulhJDd7Bzrcb
 TyshpGJ6
 dAqo0Q3zK0IQnXHKaLownJ0Gr/nPdsvS0xbAix6rZotPt15jnxKeB9Xld2SR+Gd6l7i9sFcM6iP9hfmYy/6Ta7uHikejpNNBSf76Szi5knmB47eGkJd4c3aCM0wilchp5wD2ILUo6S1OiiGcMOWnSpT2oexzBthdYXsXX08D0h5KBVrHthF/40mNWDt4upaEbOrrd6T8+HBwSRrE5nYxOKtx7gUYIOgWOUsIAiIyW92z7TG/VKefpqCtgFi/rq2MUjh5NvB1GOxssn/wFw51ewJWcOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 06, 2026 at 10:38:54AM -0700, Andrew Morton wrote:
> On Mon, 6 Apr 2026 11:09:01 +0200 "David Hildenbrand (arm)" <david@kernel.org> wrote:
>
> > On 4/6/26 10:29, Pedro Falcato wrote:
> > > On Thu, Apr 02, 2026 at 11:33:28AM -0700, Andrew Morton wrote:
> > >> On Thu,  2 Apr 2026 15:16:26 +0100 Pedro Falcato <pfalcato@suse.de> wrote:
> > >>
> > >>> Micro-optimize the change_protection functionality and the
> > >>> change_pte_range() routine. This set of functions works in an incredibly
> > >>> tight loop, and even small inefficiencies are incredibly evident when spun
> > >>> hundreds, thousands or hundreds of thousands of times.
> > >>
> > >> Thanks, I updated mm.git's mm-unstable branch to this version.
> > >>
> > >> The update is rather large.  If people think it best to spill this work
> > >> into next -rc1 then please advise.
> > >
> > > I think it's a fairly safe change for 7.1, but I'm biased :) Perhaps others think
> > > otherwise.

I'm fine with this for 7.1 (as long as Pedro buys me a beer ;)

>
> Thanks, I've firmly added these two to the second-week-of-merge-window
> pile.

Ack!

>
> > It's mostly code movement, so it should be fine (unless we messed up
> > passed parameters somehow :) )
>
> This (or an earlier version thereof) have been in mm.git since March 24.

Also ack, yeah it's fine.

Cheers, Lorenzo

