Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBD49CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 15:36:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5166F8E0012; Tue, 16 Sep 2025 11:36:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EE458E0002; Tue, 16 Sep 2025 11:36:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42BAC8E0012; Tue, 16 Sep 2025 11:36:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3179E8E0002
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 11:36:27 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C1C76C020E
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:36:26 +0000 (UTC)
X-FDA: 83895515172.04.3BE558C
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf30.hostedemail.com (Postfix) with ESMTP id BB1688000D
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:36:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="b4/+7Evt";
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758036985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x2McXv5K4mHt7I+1GFycAjz1kVhDLyCfxVIqxlB3gXs=;
	b=VFawPRwCMqEcDKppoMb3Z7cFS/Cha938bZde5cZ7RF85D0F1snO5j7wLqEuBZxmWNGuCJO
	p5iOl+9WljBvg6qq0FprawTW+uAGgR9NXlk33BT3s1WVROIg6HCbqm4Xr431Z2WwS6CFO7
	LpHzaO7qLuNngrWhcDIj+bZCJUfeYSU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="b4/+7Evt";
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758036985; a=rsa-sha256;
	cv=none;
	b=ZsBb+wqcLtTz8kMbvvre6bC+Fwoi1tZzw7TJVXQu4GFncA132+FBUKmumctiZwIPlHjl2I
	dQm3ER9IWUMSF98l2Dhfwa9+O8PGROvxRrbujZDQSOoRfpLI5/YxzYiJGbzd3HxHXWZGut
	5avwq4/7HGVRD7PaXGVny6D6K8hhgS0=
Date: Tue, 16 Sep 2025 08:36:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758036982;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x2McXv5K4mHt7I+1GFycAjz1kVhDLyCfxVIqxlB3gXs=;
	b=b4/+7Evtiny+RcoFRtMa/GCw7xjOfc4suiyVi6Nf4f7xuHAzuhMFjsDcwHY81oBi9rsCcl
	jMQ+eQClXcimhP2EwCCTjMIl4ZtoeWOPw7HRiaflcNSrYTWZYoghprwqkXVTc8Xjra7XVL
	KWN+sj+htFNrOXUf13+XJRlbW3pzXxM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Eugen Hristev <eugen.hristev@linaro.org>
Cc: Matthew Wilcox <willy@infradead.org>, Amit Shah <amit@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Aneesh Kumar <AneeshKumar.KizhakeVeetil@arm.com>, 
	Christoph Lameter <cl@linux.com>, Dave Hansen <dave.hansen@intel.com>, 
	David Hildenbrand <david@redhat.com>, Davidlohr Bueso <dave@stgolabs.net>, 
	Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	John Hubbard <jhubbard@nvidia.com>, Kirill Shutemov <k.shutemov@gmail.com>, 
	Mel Gorman <mel.gorman@gmail.com>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <mike.rapoport@gmail.com>, Peter Xu <peterx@redhat.com>, Raghavendra K T <rkodsara@amd.com>, 
	"Rao, Bharata Bhasker" <bharata@amd.com>, Rik van Riel <riel@surriel.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shivank Garg <shivankg@amd.com>, 
	Sterling Alexander <stalexan@redhat.com>, Suren Baghdasaryan <surenb@google.com>, 
	Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Yang Shi <shy828301@gmail.com>, 
	Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, rdunlap@infradead.org, 
	David Rientjes <rientjes@google.com>
Subject: Re: [Invitation] Linux MM Alignment Session on kmemdump on Wednesday
Message-ID: <nglllfwopxgz3fye3grko3hmbvpmfhewj36qg6lbh3b66bjpvz@foxfjulayqst>
References: <426751f4-428b-ed01-509b-d13e719a2006@google.com>
 <aMhgoUvziLPNt_vI@casper.infradead.org>
 <cfac2d98-2214-4bd3-a4cb-9b319acb462f@linaro.org>
 <aMlS9Kb6_x3fqsLG@casper.infradead.org>
 <50b566d6-aeda-48cc-bd67-362cb29b214a@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50b566d6-aeda-48cc-bd67-362cb29b214a@linaro.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: BB1688000D
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 6zef6jr1rxm6p534izzzh8tyict95oc3
X-HE-Tag: 1758036984-566232
X-HE-Meta: U2FsdGVkX1+e4BgYtZg8jQQLYKkoOquF1auBgIx/Qkauenl95OL0h7n0PKZMWCL8S0CesM95gxkQLKCWkWVKjx5OpgzO+YdtBIH8ZBAfkn3UoeIKZ40IuxppYzGI4S3uK7BwVxu0LPn6WnK8qFVkCTg9E9KBzywOagqUSYYkcVoxNeqMKAZuICwJE1sAmE6AbmU4RN5CZ1rRA48Y0Ha3NmGqZzssBcice7qqMx3522+HWZxYIqBQOpmEjUnZOzfxBabmtfEIInzdsC4VpvY8B6tyFAVlYgfPh0SsonnA6iLNZGAJZxJnXnE5Ap25+wG3o2gk7CEuzffdM4RvY+NJRdJyhw4V4e2lhN6G1McyOx6JMgbFYtYQ/g31QyjUpqJyEDVy32T37vucyMiKC6zviim9c3wccKymzIojxoZynQMz5PIkiqAPI9SlCz9FLZPjhC1x4bCWvPcX2QyKVV7PCe2Dpv2ouwSYOqXVd4Ifeg1cSL4rakbdaEEK73ucjLJiAh3Ukd9tdM76KR6Y+lFWcu/zcKm8DHZz6Ef6QnpkRw3+mEDUgyDssiS9SUTtHL2CNpVMgkFwX4C6mY2lmktpAGoWQxskAZP/meLUNWKoyxQiJIPFBd6OtYgoMjPCS6oVF13Z0/jDK4LZZhlulu4bO4UM/CZHhYJWldmFeOTMlkYLfSVvdvcIIeFne7RGiF806wLx1zqOOAfMIkAfzUzOHsa48dg+n/KrhgKEF8CNcsp1a5XjGkAeCavTBXguYqBi07oHM6T81k7CW2SlFI+QdrrawkDf8sMYsikZzX0+kheGfx4nF0l9N0GX811mxbpJfdwkdmUSWNM8XIQ1i5adWFjbnZi095Amiw94mIs0IPVF/Opt8o3Gf7RaZOcJy4bnpAXZiyngAnvEn2vJocL4W7WgE1CHT5KryuMY/JX/+y4aNANCyWLC/gKBry+aTn932CDgd5nkJ3Odhd43J98
 3VZGAbsX
 kyFA98h4fnoy9bpjJg1yrx6uCqwIFwuwjouFUliJxiQnTuQWOdZOCsHq7+ersyo3zBHhOTlbgQTmMur/Ag0QCydGpSp6bl8L0fG2yf8O2iSEjLKHmqSOkc73AKd08EJOusW2HQsymv4ZTlmMnvBduXaeGKi9GP9MBjIM0ALot21MIEsH710wi9PIrD5Sjp0Bi9+jiYGwzup1K2gCK/PRnsSUksvEP15MCeiH7f540m1P+MfEfjt3DwUOiUHHJcLt18h/+n3/kbb56ESOdOcT5JrJ7UmMePd4b7JOxGtTfUqUGvYLoa1F06HxEOIIurFPb8+k6p4jlSt4wvKGCwQ4hXg4pnTq9H6XuCubhD4bJBtpNxGKA+DUNJlK+g4x6rSWe67Blw/coN0TjDYQDz2rxPdxNyl6PSqWzrvXsGm9UqtE/kj9MxGaa9tjfYjHmfo48/VyBW7gezbaZbhFtjCGzehH9kpXUTO8z/qqC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 03:14:48PM +0300, Eugen Hristev wrote:
> 
> 
> On 9/16/25 15:07, Matthew Wilcox wrote:
> > On Tue, Sep 16, 2025 at 11:49:35AM +0300, Eugen Hristev wrote:
> >> On 9/15/25 21:53, Matthew Wilcox wrote:
> >>> On Mon, Sep 15, 2025 at 08:58:35AM -0700, David Rientjes wrote:
> >>>> This week's topic will be kmemdump led by Eugen Hristev.  See the latest
> >>>> proposal at https://lwn.net/Articles/1031319/.
> >>>
> >>> I don't understand what this has to do with mm, to be honest.
> >>> It looks like a debugging aid.
> >>
> >> It was suggested to move it to mm/ :
> >>
> >> https://lore.kernel.org/all/0fa9e4e7-1247-4c82-8c0b-fa65b7fbb56d@infradead.org/
> > 
> > I feel like you should be able to explain this rather better than
> > "somebody else told me to move it".  As of this moment, I still don't
> > know what kmemdump even is.
> > 
> >>>
> >>> https://lore.kernel.org/lkml/20250422113156.575971-2-eugen.hristev@linaro.org/
> >>>
> >>> is a great example of how to write a lot of documentation that doesn't
> >>> actually tell the reader what anything is.
> >>>
> >>>
> >>
> >> Here is a link to the v3 where I changed it a little bit :
> >>
> >> https://lore.kernel.org/all/20250912150855.2901211-1-eugen.hristev@linaro.org/
> >>
> >> I am eager to improve the documentation to make more sense out of it, I
> >> am happy with suggestions.
> > 
> > Start by telling me what it is.
> 
> A way to select memory areas from the kernel that can be used to debug
> the kernel, instead of saving the whole memory dump which is mostly not
> of interest and takes a lot of space.
> Anyone can register a pointer and a size, these are placed into a list,
> and a dedicated firmware can parse it and save it in case of a crash.
> Does this make sense ?

Is it only for kernel or is available for userspace as well? And the
crashes here, we are talking about kernel crashes or includes process
crashes as well?

