Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28E23C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 09:47:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E39F6B0092; Tue, 15 Sep 2026 05:47:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 294BC6B0093; Tue, 15 Sep 2026 05:47:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AC356B0095; Tue, 15 Sep 2026 05:47:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EC7846B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 05:47:29 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0BBB7120399
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:47:29 +0000 (UTC)
X-FDA: 85215519018.11.376369D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2B38040007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:47:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="cfMi/f1w";
	spf=pass (imf07.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789465647;
	b=WTZjbfkfi3aXeSr3HOppibCVl5lypg/qd3m2jOANHNUjYHjdqwTT+Bl5mRHwTNQu8b66SO
	/AU9rkcRAb5MSV6Wcrh3new1ugA3/LblRwUyax3bqv0yNBgdyJ3IsTYVrTc/KTOoFJuygN
	PypvmTMK/dhJ60ZBQkDSq0NO2Kc2R1M=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="cfMi/f1w";
	spf=pass (imf07.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789465647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W+F5E+4yAPrBsxUagAfODWqYFVvI472YjmZbXUSQXPM=;
	b=ki3VJdPGYykkO/+8qR3uw970sJ0sZrNarllVJj9TdLk/cjx7ycjGUCA81wcX9MDqQdx0ja
	i4uhKrOAwrPyRwyZd9QPUf5f8uzYmxdzkx5eERphrP11v0Fe0RYZCLgqr1jEMOrHGvhHws
	9LeauIvx4Ku6HGcw9/DuZVaYXbBtIEI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B05ED169C;
	Tue, 15 Sep 2026 02:47:22 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 468CE3F9A2;
	Tue, 15 Sep 2026 02:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789465646; bh=TgiYyAGTrTLCELCWwltNRoXatU+CAWXmARo8WzAWAuw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cfMi/f1wlLVTG20Jg2wnJ6+DbyNLJTUAHFTMYihB7bLYPbjDzjaujrlPV144QpPV8
	 XSl+d7YX01gX2yWrh42B5ii8sgq0sY8AEv8XA/835O7vsqb1KxpCDs4rzB+0+1PQAF
	 vbG/dZlaGXwMv7aR8+YBHgWDaIYqkeTcsSaiHCSg=
Date: Tue, 15 Sep 2026 10:47:20 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: Re: [PATCH v3 3/3] kselftest: mm: introduce size_to_shift() helper
Message-ID: <aqkUKDJYytjTsQvm@e129823.arm.com>
References: <20260914-fix_hpage_macro-v3-0-c9a305a01d39@arm.com>
 <20260914-fix_hpage_macro-v3-3-c9a305a01d39@arm.com>
 <b88f4ec0-61a8-47b0-901a-d63db115936c@kernel.org>
 <aqf_XGKDq6jH6pJW@e129823.arm.com>
 <c60fa1c7-ac83-4e41-9911-a426c6b42191@kernel.org>
 <aqkIQF6XcLeXSHWO@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqkIQF6XcLeXSHWO@gremlin>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2B38040007
X-Rspam-User: 
X-Stat-Signature: xhke8ix9cyqte4q1gxf1uuumrhhbfw64
X-HE-Tag: 1789465647-502796
X-HE-Meta: U2FsdGVkX18XkXvPJfZHucM3ToQwYMmHVo5g/ATH0HJ20z1WKfFEsPzqtD3fgVHjhnSblYVUCNtqUcV/fAqnFRASo/fyQZ6WQw3QgrEiVn7jW9G/9HQRCK7QDkzTXC2PlpccuCe4CZweu8VA0noJrQMmeftjB87GHhma/SGpE3+V4poeyXGoWrxyjhw6MnnKHYdrvU1A3vhdSwK5bWQn1tzwEWP0QCHgqODPcdvY57SXxVrADhojp3qCfyG3gRZicUMe+bNnvcRxzXINjnBEwnNZj2cp0pSX+TTxEPplchG5VH7gSGFAKtRuDWmGl9HFpqL/4WlWhwczrOHTxN32rWnNe/+y1tKU1/lhtiYshrgXHVMOyTyDSCk4Whs32woXpMYoSDZiyLx8YqmIaQL2kFKCk0ovt0r5lqHXIezOPIdO2fvaDV+l4qOg/5ikcgmUZlo7kL8F+z4Vo/yNmpNipykPloHNQgXzFD2aEi4y76SNLIqT2seeb8FqjHlGYR6cpUXYaUVCCTgCpmkkF+COS3IHv+a5NE3ScY+gV/3OSh5jbZiJf0aPO/XVSX7U4houDKbM7t7LIIq+128xx3K7T/XSYOB8wjZPsSs//OkOV1FEhP22wdUbrC2bdRdc6ynS4yIpn0+n84QdNNxhvP+g7cqhwtzIpEJz7TZLtXlKG0gSKimYxVrOPJHZiXNNBnpu7YaR7Xo40sRma9R8CVhPUwC4YM6q1n73CTG8fgy8hd21Y48tr5zc04oxLoj3btuj75gcrJDrHjyRk5pO3XPSBKeWXzy6VvyE21Ms9KjAuQDbjQqhhEWDEs5CzdJiX7C/lEPUT99KdL/StxPcQWXOm7ClvMqg+160apXUGP9ud4i6dQ+w6Ni6B2PXbuExUvWej0Go6y3nk7Hv4PsC7QwZ352MN4PsY0B0aPqgo+9+RhPjwHyp9J9FHmIwmHrxg/ECM2INnRY1+qQXBK937Zp
 VFMCASX6
 Xp5Aybo+sbzsM/YzUQ7v7WlJz6IpNfk3+CzCzld56tBrBPwaydsym0taqlOiTC8rqHlvDUjiGwulVyXKboaM3xcFkx3zonaZpRkRKgVC57CQwcE33E5ZZgJEHrUxuRzHBlXg0JfyFqETawrIRVn1InmGb9uvnKuxTd5Yx7PKXLYwl9GmVA4Qjqozi9ssTZeU0Ophlremyl+X0ZxVB/cXIoQw+lH8jwsmyXE+R6/QQAXq8ipJXhJfPEEs/Ml1fa9NhavXopUkUVptAQ54YSimZnHZMIw2nDkacdCapRJpHNumIZa2/i5ZYE3DIhxffG65uW3hNGYLfnImlheDYZKur+fSCfVNDUzsYBkZ9CzSNXqR78Xg96vBW+JEU9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 10:01:58AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Mon, Sep 14, 2026 at 04:08:30PM +0200, David Hildenbrand (Arm) wrote:
> > On 9/14/26 16:06, Yeoreum Yun wrote:
> > > On Mon, Sep 14, 2026 at 04:01:02PM +0200, David Hildenbrand (Arm) wrote:
> > >> On 9/14/26 09:30, Yeoreum Yun wrote:
> > >>> Introduce size_to_shift() for future users that need to
> > >>> obtain shift of a huge-page which is other than pmd_psize().
> > >>>
> > >>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> > >>> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > >>> ---
> > >>>  tools/testing/selftests/mm/vm_util.c | 10 +++++++++-
> > >>>  tools/testing/selftests/mm/vm_util.h |  1 +
> > >>>  2 files changed, 10 insertions(+), 1 deletion(-)
> > >>>
> > >>> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> > >>> index fd1432dc6152..1fef1266429f 100644
> > >>> --- a/tools/testing/selftests/mm/vm_util.c
> > >>> +++ b/tools/testing/selftests/mm/vm_util.c
> > >>> @@ -157,6 +157,14 @@ bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len)
> > >>>  	return false;
> > >>>  }
> > >>>
> 
> Probably worth a comment here saying it's only for power-of-two sizes.

Okay.

> 
> > >>> +uint64_t size_to_shift(uint64_t size)
> > >>> +{
> > >>> +	if (__builtin_popcountll(size) != 1)
> 
> I wonder if it wouldn't be better to just do the old trick of:
> 
> 	if (!size || (size & (size - 1)))
> 		return 0;
> 
> ?
> 
> > >>> +		return 0;
> > >>> +
> > >>> +	return ffsl(size) - 1;
> > >>> +}
> > >>
> > >> Could likely just be an inline helper?
> > >
> > > Okay. If there is no comments on today, I'll post tomorrow with this.
> > >
> >
> > No need to rush, leave some more days for people to catch up.
> 
> Agree with David seems better as an inline thing, the __builtin_xxx() should
> be... built-in hopefully :P though I suggest something that wouldn't need that.

Whatever is, okay. I'll change with old-classic trick :)
> 
> As long as strings.h is included in the header ofc for ffsl().
> 
> With the stuff above addressed, seems fine to me so:
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Thanks!

> 
> >
> > --
> > Cheers,
> >
> > David
> 
> --
> Cheers, Lorenzo

-- 
Sincerely,
Yeoreum Yun

