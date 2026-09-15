Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9B2EC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 09:02:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDF136B0093; Tue, 15 Sep 2026 05:02:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D907A6B0095; Tue, 15 Sep 2026 05:02:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C81886B0096; Tue, 15 Sep 2026 05:02:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B9C16B0093
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 05:02:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8A39A80361
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:02:08 +0000 (UTC)
X-FDA: 85215404736.12.BB2E88B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id E6C24C000C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:02:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MW8hwpwx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789462927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gDJQ+Dp4XqFFM9jA+QlPrk7mPj7e5HiBfLcieYIKpAo=;
	b=iUvoPqtBGqJUPOo89zHJM34sLPpMOQF92IX1P1MOk3lyoelRBMBklJ649lByH4elvu3tyz
	p9WtLoTm58ZrJfqXUoURz/G098aaxdu0NCViUVynbA61aDxJT8xOB7lOuDHIa0QzsIjBWz
	vqCobZy//szEWHlENDmP1qSJRY2BSVE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789462927;
	b=L066Qm7zBAXoQustKGT771+48o21A+GkrXwRFRYRst3NQ9nCqY90tSax9SWX2fENxe+LsK
	TwW1/7Llnq7+I2YoMicltLHoVt3P/swXSYyp/UOoV9QEkmi30znvFw/7ABd0ccmZIav0Ix
	haJ+gchfdlVAxvC4JZaKmeVcFnmWGzs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MW8hwpwx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 814F1602CC;
	Tue, 15 Sep 2026 09:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69E91F000FF;
	Tue, 15 Sep 2026 09:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789462926;
	bh=gDJQ+Dp4XqFFM9jA+QlPrk7mPj7e5HiBfLcieYIKpAo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MW8hwpwxQWyiTItd2rjqwSdxeCZaHtwFUMRokpaoIrX7DjTl+xaqQB1RN9wDImwXB
	 S7Msymu2OHWAYoza2Qx9eCGexwt4JTDSq316ER5Sayob1v8cq5aIZ92Ck3AGqYbmLx
	 XrIDhQT2nsrhfl6AKMSe66hHWV1JCiWAEl2HgcpvWv+UvNRdlVk4PCOM9ksSbmVpe8
	 gA1FWSdRvFGJNBlHZHntpDh2bBjDNdbvTk//WKWw5rQ9zYr/vWrrkUHJ3O5ucU/A6d
	 LmIQALw0VxViUcPA4tRUjG6LqlNq1scX8ynlU3xr97wemdwTKqel7oJt8AXeUtHjoK
	 8qTclbYIbQ1Jw==
Date: Tue, 15 Sep 2026 10:01:58 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Sarthak Sharma <sarthak.sharma@arm.com>
Subject: Re: [PATCH v3 3/3] kselftest: mm: introduce size_to_shift() helper
Message-ID: <aqkIQF6XcLeXSHWO@gremlin>
References: <20260914-fix_hpage_macro-v3-0-c9a305a01d39@arm.com>
 <20260914-fix_hpage_macro-v3-3-c9a305a01d39@arm.com>
 <b88f4ec0-61a8-47b0-901a-d63db115936c@kernel.org>
 <aqf_XGKDq6jH6pJW@e129823.arm.com>
 <c60fa1c7-ac83-4e41-9911-a426c6b42191@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c60fa1c7-ac83-4e41-9911-a426c6b42191@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E6C24C000C
X-Stat-Signature: 7pt7tdh7bbof81k4yntceookaah4zrcu
X-HE-Tag: 1789462926-204215
X-HE-Meta: U2FsdGVkX19GzGkda+9ne7A5vM89id+PI+oJ/ZTpX8xenff9kQ2G8pNl96V7zfmIpR2GeJzhFbgklIvGyf+fdhF5pufQ8lAmfGq/B2Q4BRvgizZluxIJhELTqPlOOcBxkGNpN4D4wS/PmI62Xp6bzsgFFPSS+w9j9u2FtqANYDmwFXKk0WTQDcKCf7GR0m4UnNyfYwiRP+guiiu/6D8uXeSA6ci2Nbz1TXiCGTihEDzCCNZgWFunqv3c1d5T1fGMLFwUxNLW/OtVa19eeUh7ERcXKJcywVH5akvaijKR6fKVxvqM5RPuj+qBTV0KYOw04nvlNg7/TIIy5hZwqJ2w+otZ73iiuz7ZgtTlCL3HI34hOCyKyG2iK+PuJ3kMT8nZYmuCJhuT1tlwcz5ejhUtpW2LkjoG7SSwJT4jWKW7CWZ8Hr4uS8+G/sfFTmKLVKlxxBiZlB1D+wBwP4EigcpINXnJOYfByF4q0J2+6nBzc9RgOI2do+RJ1LbbijHOZhCa+cEDMqhbDXc4G0UVhiaptI6cWVWAHYudQTzbnVQ1DcvY/ZdzZL3er2M+cOkD4LDIvvkrtDcio930zQBzcT0jyBIOASHGBjNpcTZLBp4hpthzbPaBb4D5ku7fQo7RG81tFMbh4eMxkGPOPVAXk0Odnx5e0IVdfUzFFhK7BwfOJyIy8cSL2e9MChih3jPqzlJu1PdIK3e3WvtdyjxdJaR3h/gibrzn8Afsqxe37jSha7Kk8KLwomAsltiLwuy7drgIjibdXIirpjVj5mewoQkh2Zk5WcMe029B1pc9mac6ZvBQ3LpXVPlFJK2MHxdq3dtnuSIhOMC/0Zksq+PX7coU5aXZcDqiOHi+nTi3mAc+SBG28FoXC3iX6ChKE5SLw+bajlSzHlIFZPFXM5y/w04xoIzxa5vydcn+9pzmJR8B31GUKaNxYdDuFvwBda6dFxEc+F9YHDUc1k/uodMb+BW
 RTkrWOrP
 CiHPqcO0URX/+EY/r3+B5kY4svlJLs/wrRC9P5lmtqUHm2IfBiNFxNZIeMrko3/GXlwI75zdWSG6GgBp0c7BXd8W6pnBxgrjrGXDFpTi+lqJ9JZB9ioS1oZMJ53vzSR/Nh3rUKWRqLGfUFQs45fuO9GbdxOQ70EWgYMqWMV9yAgqfrl64ZY/gTJ9Nnc/TkIc5zdipxXGMl3JUV7rQREIjf4vCrxyko7bYTimNUFr5Vu1dUE9oAXb2IVFM2sAqCOutOAf8NU1PNZa/4tByfDaIVmzCdoLDuvnvKwvvT1RJpJx9kLLiq8aqr2te3Qc/39Ctv24i0Ltor+vq63VFSdpzYzBkZpTIQXQjxPehaxxjUJxxGel+BafSLFMHd/cBK8Q2jpDY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 04:08:30PM +0200, David Hildenbrand (Arm) wrote:
> On 9/14/26 16:06, Yeoreum Yun wrote:
> > On Mon, Sep 14, 2026 at 04:01:02PM +0200, David Hildenbrand (Arm) wrote:
> >> On 9/14/26 09:30, Yeoreum Yun wrote:
> >>> Introduce size_to_shift() for future users that need to
> >>> obtain shift of a huge-page which is other than pmd_psize().
> >>>
> >>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> >>> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> >>> ---
> >>>  tools/testing/selftests/mm/vm_util.c | 10 +++++++++-
> >>>  tools/testing/selftests/mm/vm_util.h |  1 +
> >>>  2 files changed, 10 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> >>> index fd1432dc6152..1fef1266429f 100644
> >>> --- a/tools/testing/selftests/mm/vm_util.c
> >>> +++ b/tools/testing/selftests/mm/vm_util.c
> >>> @@ -157,6 +157,14 @@ bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len)
> >>>  	return false;
> >>>  }
> >>>

Probably worth a comment here saying it's only for power-of-two sizes.

> >>> +uint64_t size_to_shift(uint64_t size)
> >>> +{
> >>> +	if (__builtin_popcountll(size) != 1)

I wonder if it wouldn't be better to just do the old trick of:

	if (!size || (size & (size - 1)))
		return 0;

?

> >>> +		return 0;
> >>> +
> >>> +	return ffsl(size) - 1;
> >>> +}
> >>
> >> Could likely just be an inline helper?
> >
> > Okay. If there is no comments on today, I'll post tomorrow with this.
> >
>
> No need to rush, leave some more days for people to catch up.

Agree with David seems better as an inline thing, the __builtin_xxx() should
be... built-in hopefully :P though I suggest something that wouldn't need that.

As long as strings.h is included in the header ofc for ffsl().

With the stuff above addressed, seems fine to me so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

