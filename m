Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DDE4F3092A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 10:33:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7735F6B0088; Thu,  5 Mar 2026 05:33:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 721526B0089; Thu,  5 Mar 2026 05:33:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 603026B008A; Thu,  5 Mar 2026 05:33:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4F11C6B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 05:33:21 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E59E21B66C8
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:33:20 +0000 (UTC)
X-FDA: 84511647360.10.A770465
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8C589C000E
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:33:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PaIgBv+h;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772706799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y1Fj9M+9MCzVST4GZRGx2rYqUlSw5gaJKBoH4D41oZA=;
	b=JM4CqggVqbyik/ynf1snHuS0/x/KTOT73DUFeJqntoycwODV8PmNk4j7OfS/2pfF7obQeG
	L+2P1Oyq/5inXcx19edq8PEIapOO0rRNyETICqsSepqA7tRjgJOb3+AlA4Klw0LHvfZ4Lz
	wuNE6nDt+gA/vxVOl2V86jU30jS/mHo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772706799; a=rsa-sha256;
	cv=none;
	b=aEeBmAjBnZQ5irSvR82cAR4rBEubjDnfUtHidBzSEHI9nRpk3Q/h/1FsNSP2aNcpIr01ch
	XyAdMilDgRe6GM3eKwmGMkaOLB0uRaGhm0Y2AF8T8jQkfNdKdg14F1p28FNfQQ5xr9Q+hw
	2kHkQwGiWHO5btyHPDPU57HJtyWPygM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PaIgBv+h;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E5B7361344;
	Thu,  5 Mar 2026 10:33:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A930C19422;
	Thu,  5 Mar 2026 10:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772706798;
	bh=y1Fj9M+9MCzVST4GZRGx2rYqUlSw5gaJKBoH4D41oZA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PaIgBv+hQWhUXggbSdfC69LRkexxpDTAW8zNRAFmpbJSTPWfYyoJF+mI94j4W3OhQ
	 Q5aErN0GD5DbklxZ+35eRpQo8Y5fxdlx0zhxvS2B0qCRJvIqEQ83MLaP6IUQGXgnzN
	 rat0CwNQ9L0prCkEahZN5p1S6xUr1exBmNYg3L3PNgRK4m0ORBqJ+dLk9puAn4R1t0
	 XTvv0BoG/ykfT7+zs4dlRXiICL3rujs31ekaeQw9Z49lLMfZKhNA+G2Y5U+Ppm/H63
	 Jhj8uog8R8rVIaTflFA7hxePO4DGHq8HAD3s3GbQYVZwk2D1DzcY9KfPlhLr9NLKkG
	 L1SioXISm0j+w==
Date: Thu, 5 Mar 2026 10:33:15 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.com>, Andi Kleen <ak@linux.intel.com>, 
	linux-mm@kvack.org, akpm@linux-foundation.org, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: [PATCH v3] smaps: Report PMD page size for pure PMD mappings
Message-ID: <f7ef9fed-d774-43b4-8ee1-20252096374e@lucifer.local>
References: <20260303201556.107960-1-ak@linux.intel.com>
 <101ac423-252d-4ef8-a07c-34f5d59820f5@suse.com>
 <f03ac28b-a2f8-4182-9f11-bafd6309cee0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f03ac28b-a2f8-4182-9f11-bafd6309cee0@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8C589C000E
X-Stat-Signature: 5ra4enpe6j7gy1gn48sp87adk6z1zq59
X-Rspam-User: 
X-HE-Tag: 1772706799-178594
X-HE-Meta: U2FsdGVkX1+frhIRbRdU9SDfairn4HYel6KkoAR0dGbCrOxnldrEc8Ku0tRDCfAIaJCv+rS5MOB8EdkJuwuzoc9Fsecn4fENX+TdD0rZpC+L8K1rPSxYrOdhFB8Hmfzs7JPj3sd/MZNVdNNTrk8iR618q5xVgPdN09R5nFmql5weeLQzEKngqek+TCC7KxXMyglOhqLSu2KeZEeZEpN+79U2jT1K255LWdrdOStOHWbKzGsFe0OMiDyOxp8ts2LVIbR7TO/3tj9iPkBsIaxtjK8iFrueeOdE907/aJ8utwIKsseWCtb+LxisZj7Sfuf330DLzsEBk8Ujtc1xFJDMdvKN9Xxs1rk75JkOqvQWj7SfyXGCJc/FLOVAMtSqS0NO9u69nZa4UTuOJ8y49fkf6WIXCruTGRw54vgg87utUMZyWa3Fy70WO9wG7YoVS3ifaU1K7HNCPV0Z4BHmzdWfbSA+ZS3Dfhrvhz4n5fIekDuBpqWyXlXKks3gi7ZdJOYgwF1NdEAF301yWuGsCZmUvsbPpX4E01EWLWbIjV0WXSomBPnrIpMTdLTIP9aiGDiqk8nVVJ1gJSnEJylgN6algNihY/NhQ8+5z269D0PQ6Ogu+RKvK0Ah4dNSGuMXMDUdsYlNGbBY+I3X9iOrngFhL2+4pD4PcEl5z71qfgdWhzUcQWVqejFGn5RGxtAhyqLzflyFA71iy0mQhl3ROt3247PhgfbJpfrLadOLComVohlFMGaUMpw81awh/B1Ao2FLldYgwvcyKNx9lpD6u5rSZ+8ioYvOBefEEb5EQyfBkewH/w+VeWl1Md6FoBC8TwcxRnTVaTS9HbZ3S3pyKBwpKQL5r5xQnfx/S8VhSnasfHBJ9puZJDfU6RqGKinhDKAe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 08:20:38PM +0100, David Hildenbrand (Arm) wrote:
> On 3/4/26 18:29, Vlastimil Babka wrote:
> > Why do you keep not CCing people from v1/v2 discussions? David said that
> > already on v2. It seems rather rude to me.
> >
> > On 3/3/26 9:15 PM, Andi Kleen wrote:
> >> When a smaps mapping is only PMD mappings report the
> >> PMD page size for MMUPageSize instead of the base page size.
> >>
> >> This is a revised version of an earlier patch that tried
> >> to report multiple page sizes, but there were many objections
> >> mainly centered around compatibility for mixed page size
> >> reporting. This patch side steps all of this by
> >> only handling the non mixed case in the simplest possible way.
> >> It also avoids a problem introduced with v2 that page sizes
> >> for mappings with no pages were incorrectly reported.
> >>
> >> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> >
> > Will this be useful in practice or just confusing? There can be e.g.
> > misaligned mappings, or other reasons why there won't be 100% THP
> > coverage. This all or nothing value (IIUC) seems inferior to the
> > counters we have that say how much is pmd mapped, so I'm not really sure
> > it's worth changing this.
>
> My opinion on this remains unchanged.

Mine also.

>
> Not CCing me once more is questionable and makes me want to recommend
> Andi to work on different parts of the kernel.

Andi - I'm genuinely concerned that you're doing this on purpose here -
especially since you ignored that part of Vlastimil's reply and ignored
previous feedback about failing to cc- on more than one occasion.

Responding to negative technical feedback by being rude and dismissive then
(seemingly) intentionally trying to circumvent the review by failing to cc-
those who commented is completely unacceptable.

Sadly I have to join David in suggesting you find other parts of the kernel
to work on.

>
> I sent a doc update to clarify this. Won't make everybody happy, but we
> can't turn back time.

Thanks, will take a look!

>
> --
> Cheers,
>
> David
>

Cheers, Lorenzo

