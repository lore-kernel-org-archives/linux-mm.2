Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EE5CC61DC6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 13:07:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 707106B0095; Thu, 27 Aug 2026 09:07:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B7BB6B0098; Thu, 27 Aug 2026 09:07:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CE0E6B0099; Thu, 27 Aug 2026 09:07:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 361766B0098
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:07:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 80945C0406
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:07:52 +0000 (UTC)
X-FDA: 85147076784.10.FC47420
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id D07F120002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:07:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g1ZTwjkk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787836070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oP+7K0U7f/7k6ULptFAlBCzvX6+UF6UEPqqqOr6WHTY=;
	b=wuYA6MYcIcal35nUpS354jAamK1oaxLwoHfomrVdI9TX8oRvOs36pdJw/AhLWgrjq+2ijI
	iXA/f1rfNnLSWnG+JpxBLZ462JHRjwY23wxgEvEklOIRtPUeQdNImP1CaGz39rwHEx3Ozo
	f6NCjfrLHLG+A/PFjT7KS5tYpMaIOgc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787836070;
	b=3btModXmO3VsqouoJuVIQUJu3YD6rp3m0Vv56WBScRJ6l4czqvsAg5H41QO40c5YVOwq2w
	faDhMMG8Cs8Zcp2jvsWhEdetxrt6Xl5MAeBANS8kooC5KOc2yBNQ56eRc6B8ATJJDLmQEY
	nkaN9VEA97t0yBOMNgBBOBazCIapZ0E=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g1ZTwjkk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A4DE4350C;
	Thu, 27 Aug 2026 13:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011471F000E9;
	Thu, 27 Aug 2026 13:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787836070;
	bh=oP+7K0U7f/7k6ULptFAlBCzvX6+UF6UEPqqqOr6WHTY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=g1ZTwjkku8NYz28tCgrC7ro8xgeZQIXfzQPBhs5PJHXFNMwZeTFG9jSnsgWtNJvO9
	 pzjf9YygEswaMc4vm0upoTYTJ5Jy1uDlZlYvTeS8WUe7BeZQxZh8XQZmVGh5eoVVz2
	 dlbYSCtk/1iGgs9KMO7tp5WP0HXwJI7tBQz3vBl+nOOzyzjhLKShNjIyeU7qglrU28
	 qwM1d+elfM8jndjAP8AFyEU/0bIzzIdDM/a78gMxoXndkcDKRcvItpkCFhmTk3ZOF2
	 3gVonNoZ0FH7GnXDv304QoWGSTsszNvSZKrUfRKrCwxk0+tkESGT/KcE01Fac3vtH+
	 VnVSTCZ8XhsWA==
Date: Thu, 27 Aug 2026 14:07:44 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, 
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] MAINTAINERS: remove myself as THP co-maintainer
Message-ID: <apA2lxYv7r5qaJR5@gremlin>
References: <20260826-drop-thp-maintainership-v1-1-3d102748fa17@kernel.org>
 <ao7S-wjzcMIgM3s-@thinkstation>
 <adf90329-020f-4a2a-bac5-fe815b692a7d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adf90329-020f-4a2a-bac5-fe815b692a7d@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D07F120002
X-Stat-Signature: 68ixnyq1umbyuo81as6wzmfdcw7s6mdy
X-Rspam-User: 
X-HE-Tag: 1787836070-567672
X-HE-Meta: U2FsdGVkX19sAk46NK6guSB3Q992rObfuCpDavwBZd8ogDQX9UUVBs6Ok10BvB/4EHSlGXXnquFqTYGtqI3GW2Opb2Z52t/YtZEtaVnaYkbxUvHHLBuoRu4j+uQlzhC4S9GcdILCAaAfbY1MxWZxa7gsOF0AEckZ+KsyY9Ps9TBiPExMsfm7BaIbWIlQACkTSMnTfqaEDKYPbCdcUM1dKIwxdKsdFfzKN3/k3GrQKAiPxLcYIGoThD7lYonHFR0xl9PagtPE2VDJYUsDINR6DE19ney4ybsFIZmhXeiokLPVmrLyLuk5gokLfu1KJ+8iPTL31leK5nnF6CYDmqUOuJvEAWWkmr/hfiRgT0L7t6MKGeh/8/XmnRY7/laeC1UptwDO7+sQoQOBX2dvlyok0rhbQX3qg7Ur93+N2KnNugPKplmrjDIQhhRSqnTE64t1I1l3jN01jY3f2EyU01oZP9hyz0kYRieYE7tGDCOvh0cALqlsW9FQMDa3QV69CyGcK6OJvBcoHpmihp/5l4JOmV8mpTGzsxuxo7TbCAn/DyFCAYbYQxtSYF4rN/I2sAORQ0+CjAR35w3k8+A+rfw44nkonX1vlSwX5pk7AKAiB8cSyOZMgEjjmpnXNo4ygEI6NOcIMhaLgVxkHwdNur4amYDsLO3reGqH54qaCX9ivswazbzsUvmIMvKs/tu8Boce8F/8+WFs1G1XgL0fXB73neIn+ItMeiW31zabJ15r3iUhp3kpDBNO/SQXd3UrYlYSS//KuwAnUgfbT3CLzYVX7CiBvbf5STAmuXyXtljK8yxnXzmp3vs8EfsXaW3yPrWf0HtigjxJpZPe3xGq74mKRVwKepxwYEgMe3/tweAW4TqepNPsKzJZSB8J6K/4yu+by76FGyBznL0YwW7HFCN55/EtmbPqIXNPLXRBil2VLCHCmwK5LE7ZNg6PXRM7EQh/nqcZFM6tpZehOSax1LP
 Egeka09R
 LCTac9GGxsiRCGYR1RrtwQsHot9IeqtagrQgul0YOrwSvZ8BOByFNgzi+DsKw6MOVzTLvA3RZ99HHruaYk8vIpfe9j86HVdxrkfyaPkrq/Y5jLJLZ539vwLwezsEb9FSSIh93Pt13bRhyDpy0VrRI1EPjUUZjpTuGokg7L3RmwmTj5hl+X0nqkey2xRNo6hJvip5RemM7AGlDKE5bc8myRi+VT2mIw+FBxjO2iCOuFu0NaMmO+6dCWehThRm3y7iJzIf9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 02:52:27PM +0200, David Hildenbrand (Arm) wrote:
> On 8/26/26 14:04, Kiryl Shutsemau wrote:
> > On Wed, Aug 26, 2026 at 10:56:39AM +0100, Lorenzo Stoakes (ARM) wrote:
> >> Unfortunately my workload is such that I simply no longer have the time to
> >> give THP the focus that it deserves.
> >
> > Ouch.
> >
> > I guess my 57-patch series did help the situation :/ Sorry about that.
> >
> > It would be only fair if I share review load for THP. I will try to be
> > more active on review.
> >
> > David, I can send patch if you are interested in my R:. I know thing or
> > two about THP and can be useful there.
>
> Yes, please! :)

Thanks Kiryl :)

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

