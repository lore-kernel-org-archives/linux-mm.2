Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0313CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 23:43:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 193B88E000B; Tue, 11 Nov 2025 18:43:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11E5C8E0002; Tue, 11 Nov 2025 18:43:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00BEB8E000B; Tue, 11 Nov 2025 18:43:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DD6568E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:43:30 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 841254BCCF
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 23:43:30 +0000 (UTC)
X-FDA: 84099955380.19.DBA1D2B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id DDD0D4000A
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 23:43:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HF3ngo4x;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762904608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VuLp9VxKuN842PDsOINKbwnoqtUNOj9idkS41O4H+Mc=;
	b=cJz4ZEuFn1/054UBlb0bSAcZilLOiQCrP4bbLBpVbgbSB13FhxZtYLPYjArqJEsDrx2spw
	3JhyFx1EJrv8/8Yh4u+ay+tKA9Ex2sCXkNeJhtVISNu0aIqO5kIyf6jNr04lx1kuz3IpWk
	6kh1kUscDLJsnoyjKlSffQ9+HU7esAY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HF3ngo4x;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762904608; a=rsa-sha256;
	cv=none;
	b=nBkXen0z93rwmzWlA5pmTDL3jkUEjCsyLhlPKTykQvHsObBj2Y6we+voyjJjqW6s24BnHv
	mFx4DEOVJ+1plubZi1+gHvi/dkvvuvWU1lB+9IS0GE0DDvhzi4z9jt+mLjPWIrKS3EJ0/N
	5Nxh6NlG9WSfjYGTSC+XTPSjm1M8U2Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 266EF600B0;
	Tue, 11 Nov 2025 23:43:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C72C19422;
	Tue, 11 Nov 2025 23:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762904607;
	bh=c3fLwfJTq1n2GtFdAVnfh0T8tKEokN21QIA5d7iz358=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HF3ngo4xe0iumt88R1t4nAN+WeQ2VhpOaG+3VZOoCtTa4uEQ/kf6VEv+hfKGX3f8x
	 ai8B+G7DQYNv38p/UOhfW5rmYAkybgew/tYS6CqvVnNvRGIXWolhZN3w517JWybj9F
	 FOeEn9JgFBbA0YWRAddwZl6fLZkH0QEN22DCyi/U=
Date: Tue, 11 Nov 2025 15:43:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Brost <matthew.brost@intel.com>
Cc: Balbir Singh <balbirs@nvidia.com>, <linux-kernel@vger.kernel.org>,
 <dri-devel@lists.freedesktop.org>, <linux-mm@kvack.org>, David Hildenbrand
 <david@redhat.com>, Zi Yan <ziy@nvidia.com>, Joshua Hahn
 <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
 <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 "Oscar Salvador" <osalvador@suse.de>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain
 <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lyude Paul
 <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>, David Airlie
 <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Ralph Campbell
 <rcampbell@nvidia.com>, Mika =?ISO-8859-1?Q?Penttil=E4?=
 <mpenttil@redhat.com>, Francois Dugast <francois.dugast@intel.com>
Subject: Re: [v7 00/16] mm: support device-private THP
Message-Id: <20251111154326.bc48466a6962fbbffd8ebdd0@linux-foundation.org>
In-Reply-To: <aOePfeoDuRW+prFq@lstrano-desk.jf.intel.com>
References: <20251001065707.920170-1-balbirs@nvidia.com>
	<20251008201740.d9507f4807a73058d4da23a8@linux-foundation.org>
	<a5992f11-5841-4bbf-b190-b5df41b68b0c@nvidia.com>
	<aOePfeoDuRW+prFq@lstrano-desk.jf.intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DDD0D4000A
X-Stat-Signature: brbxeuyfke1j7omi4ofthpzt8r6f77b9
X-Rspam-User: 
X-HE-Tag: 1762904608-44360
X-HE-Meta: U2FsdGVkX19Ib4wDvvmJ7QcmTgpb+Shnfu32VkH7DtFM6BUDHsB582xHWICBU1nEljLZ7Fz+H4Nt4o16Jia3M9EtpLlwhG6BF/wQVVKEfQYCU+rI/4tW0MFuGxAee5NYGcOpH7PmxSEpQhQ9gRLNbMy1Z9At3XQaXDg3Sb8RIMkwQAlMrOOrldGtDLpUMJDLqOk9+yAxoBTNtsCpG5xaH/PzAeZkbXEgve4mjC8kAV0xObAGIy2bVnkyFNUnmwzeCZVSUhmV6hwNSWKRXGMDFVR8u4nKtt2Uw57SanW78pgV7ysA2oeKoI17IC2gJJKTCTvgeDqYyBNqOOPQRpI1m3YPI0z2weqFwUENlhvWsvw5QoqNzBkVnkHNauMPzptSKyJ35pBvCarYioHqazd6CYxAHAuHB4wi0R5xJbAP1mi8ccGxRqvD5TvtXFbbc+wC7ylgXijuiB4R35MRNMc+LNRnrs3QFH4uWYxmufY2KzCmuauWWKWVkZCALwKpajaI6RGoVAtPQxcZ/0bocVZ/iV+K0bWHgvDI29v0lOFQxkLaJNnhvKQkHDWqUgwPSgQxHc2DsZuETNeLHacsCjCmgUy1W5mXgvNrhjaIIMlDNKNkSSlkH/7pK7Bu9O6qN9jR3wOQXrQiROl8pMYcOwwg7rukqojgwnJl3Fn9z/+u/5rmXl1QqAAgSw/sA0j74eEr8F+1nNyzBFwxk3olj3eiufL31F9TSXiIUVr0enwjYVHqv0yNpXscLzWDWt5bntSFC2VjK7/F9PIHXVthI/wAh/PUuR/uguiZqBQdULOIDak1yjRbu222idHyx9loB3YSK9BQb4ME775qIdmVDno4op67XWW3y3/WYMqOk3Dyaj/4n9uc3q/+hJNSNJTbrJenzlRs7w8rma/v4l0PW6+dMVyYyTLA1UJbehcbjJfSoxX67tMxrBVd9JuvrwRpjb1VhojMZKzNlWsB3tH+9Cz
 D4XWxnNG
 78+ZOWhtCSNChUWmomjXINhpDe6db2niEaXpIPAw4+IYzZf2aBJVapNfp+X4VhHthu+lH2hZZ2oiz8v779M1lScOsIls285ckxBl61kLfzzIKBTJEHeY+bT6ZubPzyphX+S8ojrCHh4596f/xrGxqDp+0TG19a1yAGgYPiQyIC4wsyAHScTuckkP8Ba2Y5dP6xVsZjLS40SniTigCblYU0blXa6dUOghEUe2tq0voSGjxLJqVNn5Vh12LVLPnnshmqVP0tY6YrC9DPv8QkUbmswH4FeFL22wvpSO84qoJ3jm4546jhBkmTYyLObkeUT6IcVA49RBGNxbGkc6+M0p9yh9ksbOuuoN3j8HDkViEOeHd0gXi0Xs3PkX6ng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 9 Oct 2025 03:33:33 -0700 Matthew Brost <matthew.brost@intel.com> wrote:

> > >> This patch series introduces support for Transparent Huge Page
> > >> (THP) migration in zone device-private memory. The implementation enables
> > >> efficient migration of large folios between system memory and
> > >> device-private memory
> > > 
> > > Lots of chatter for the v6 series, but none for v7.  I hope that's a
> > > good sign.
> > > 
> > 
> > I hope so too, I've tried to address the comments in v6.
> > 
> 
> Circling back to this series, we will itegrate and test this version.

How'd it go?

Balbir, what's the status here?  It's been a month and this series
still has a "needs a new version" feeling to it.  If so, very soon
please.

TODOs which I have noted are

https://lkml.kernel.org/r/aOePfeoDuRW+prFq@lstrano-desk.jf.intel.com
https://lkml.kernel.org/r/CABzRoyZZ8QLF5PSeDCVxgcnQmF9kFQ3RZdNq0Deik3o9OrK+BQ@mail.gmail.com
https://lkml.kernel.org/r/D2A4B724-E5EF-46D3-9D3F-EBAD9B22371E@nvidia.com
https://lkml.kernel.org/r/62073ca1-5bb6-49e8-b8d4-447c5e0e582e@

plus a general re-read of the
mm-migrate_device-add-thp-splitting-during-migration.patch review
discussion.


