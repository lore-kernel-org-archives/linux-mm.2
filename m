Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A53B0C61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 17:20:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE2A46B008A; Fri, 28 Aug 2026 13:20:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A92C56B008C; Fri, 28 Aug 2026 13:20:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AB506B0092; Fri, 28 Aug 2026 13:20:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 727DD6B008A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:20:41 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F06341204DB
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 17:20:40 +0000 (UTC)
X-FDA: 85151342640.23.6036DF0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 54E3C140007
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 17:20:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=We1NrLZp;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787937639;
	b=EuNHOkvpiYUMKXg5aAdY/I5sr+t45qudn3I/2dIUDMlfG/8wnFGMBMJMnXKWcYW2bJt9+N
	wQ9xSH1PFJ3tdCrGg20Z4xn6cBBWQAhFl/BkoGFp3l19Vvfs4ho/VjlIKGbBCBG9Lb4rnG
	GLeUlsB4HXNfuA4aICXR0QglaiyQJcI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=We1NrLZp;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787937639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vEpWbdrotVCakHs/M3xW3vTkrtuo0K6HufK/TXB7tFI=;
	b=hRbDNvUtAyupquPW/LY+5LHkqB1gu0+NJKc3ko9JqWfvQS2wW/MvWYtslVJTl+1z1Ney7f
	IZWGpDtGDkJ6xzMqU6tiZCxbmRVXHmdio1uh9IEUaoAoQA8LKbIPk2Hzr1oDW+34QdoCgn
	NXtweEOsIX9Dyw0UM4A6FOpKnBL8IBQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9097460052;
	Fri, 28 Aug 2026 17:20:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB271F000E9;
	Fri, 28 Aug 2026 17:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787937638;
	bh=vEpWbdrotVCakHs/M3xW3vTkrtuo0K6HufK/TXB7tFI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=We1NrLZpFnRw3SNelW3DS0SKnGuntUgqP8nU/DBa/LA05Utjgwv0HOXsBcldsKERi
	 AEw7uiElAdJagGqDGuHCTXUbx2SjjOhLCr0Mv7FNYaaW4VWHgvoHE/jpRyDfHWCDAC
	 WUSgGfpTkeDm0qqY2DCMZn3Q6+DtCcFUNON1aM+9VILGBJCNz6jGc8h9xUWa+zeEqM
	 AKeZbnAMgqlLxSb8Ob1D99gYxtwEFjM9r179FT6r1Y9EQPxWNc/USzOXYNlDypD+KV
	 /odd+a6BZWFX4kw29GI4aKNT4gc+KP68X06mnm7mb/7ofpO4RRL4zPtvbFSLeauckq
	 xXsR/IKgPv4hg==
Date: Fri, 28 Aug 2026 18:20:06 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Saravanan D <saravanand@crusoe.ai>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Cedric Le Goater <clg@redhat.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: bypass THP tuneables for huge pfnmap
 mappings
Message-ID: <apHDI2LzF3c6RB_S@lucifer>
References: <20260827-hugepfn-allowable-orders-v1-1-94819c8807c8@kernel.org>
 <20260828164649.77283-1-saravanand@crusoe.ai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828164649.77283-1-saravanand@crusoe.ai>
X-Rspam-User: 
X-Stat-Signature: 995fowayfpwey9eaqw7ngxx3i8ooipi3
X-Rspamd-Queue-Id: 54E3C140007
X-Rspamd-Server: rspam06
X-HE-Tag: 1787937639-574577
X-HE-Meta: U2FsdGVkX1+Ps4JxKse383+EfGDxKcFO9jnH7lSrk6vehRZfgStwsigTXle3RFnGx0nvzf6WOjNsCaeKDP95bsglTCmzt+FFeDCReUYwJCX88HrlcJPTUPGKeo8geioq8f3rZaGMcQm1vXjA3Fr5Ulcwx/UTsH9jb5F0GWhMXzmODBRyhG/F0yEEMhwB844Y0topW6rdv+n7+swqSEJ5TKLi0TRN+BZuLiHLXE68F1PN5cWuXdDS1593WztUu3MbUe+MTOA0qDVTsVdiVMCgrenyxVk9+vXk+69ECNRSc96NaUWxMPG728k9ZcLwTpT/3z8jnKin99bNViqsRgm6G699ILuHnucEmGgf+ydP5Chc2Bb9tUgVEJF4Sfrml3AApbx2R3IlvFx2eAHuIdje2PSWZa0SExwLbudKQVH6ROAgSDivxf9fkvshvjyY/LC3ENKhqBrXqE/McXeCRStx/Q5AB1i+8dk/H6Pg4IlDlEnkS/wbDXlqMXcSsBEDkbO/PRTutnMZ/ZLE2uKchktt8HILUfnrSsoT0sh0lXlyFl/toIUposUXUzVfb7XxoB9pKqBUNQzP3tHjd4qpiAY2UlaPaV7QAL15wJ6hO6qRwjpPlSN3wA2HxaUarAD9FrxeHhlUMJ269Vps6IPXwz9D89o+9XKVSZB8uqYpJHTx5pQvAp8wz41kRsxeKvVnQswCpRZblAoyvWFUWwPq1OoYKcKrzzngZscLjhMZvIL5nh/Fql8bLP0ZIfD2ukF7GrKTQAfkmLcew6Ax77V0paZ66nunsxQVujS7pruvVvLQJAmTKmKhDDBgAz/8PSRmKA2MxU+i2I1czBAnreVF5UXeYRsHCdbOdsPQr8V/scLN7rcbUf2DQ75zeFHZwEtn5mqeCeYXRR9SyCwffjddkhavGawcDQ9IEaZa4J7U7JYmJuzdGDHMyF1hFGFJYX09mBWtoMpFl2GTwDbYqCIxS2C
 qaXgcozs
 bgNkt7TOTCQxHPpJp0bntZm3WkaBPox6Zy6Us4iKbsfF6HOXba87ftU6AnTWQzjWCKkYpslRXXTsZN2bh+w4H0u1+NPyv138WOGh9W0UOwPi8RfBYkQGZ2Y7MoSRMfmWv5oP2S4CcfjaPoiznApvyICCnb2R3PrIoIsKxFfDP6x7MHMeCxNCEFalaoAOwj5ApDHmyexWVgXcm4q8H+zvwfQGXQzNutX1XVW4g4xRDf9YksRnEYZGbTSI00Y1OzSLM13lMpr7+86QdNx11BC+uay6vz2tPfmxiJs53LwuOIivJaYA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 09:46:49AM -0700, Saravanan D wrote:
> On Thu, Aug 27, 2026 at 08:55:57PM +0100, Lorenzo Stoakes (ARM) wrote:
> > This is incorrect - if a huge PFN map is available (defined by
> > vma->vm_ops->huge_fault being non-NULL for a VMA_PFNMAP_BIT VMA), then it
> > should be mapped huge upon fault-in.
> [...]
> > Correct this by explicitly checking for this while ensuring that smaps
> > continues to accurately report THPeligible statistics.
>
> I backported this to a 6.17 based kernel and tested it under
> cloud-hypervisor with THP left at the Ubuntu default of madvise, on
> two GPU generations:
>
>   - 4x H100, 128 GiB BAR1 each
>   - 8x B300, 512 GiB BAR1 each
>
> With the patch every BAR faults in entirely at PUD (1 GiB)
> granularity, one entry per GiB of BAR, so 128 for each H100 BAR and
> 512 for each B300 BAR, and smaps reports THPeligible: 1 for every
> vfio-device VMA. Total time in the huge_fault path was 4.5 ms on the
> H100 node and 130 ms on the B300 node, and the VMs booted in 11.6s
> and 32s respectively.
>
> Tested-by: Saravanan D <saravanand@crusoe.ai>

Thanks! Appreciate the testing :) and glad this helps your usecase.

--
Cheers, Lorenzo

