Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EE6BC9830D
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:19:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 350C56B0088; Wed, 23 Sep 2026 17:19:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 300E96B008A; Wed, 23 Sep 2026 17:19:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 217816B009B; Wed, 23 Sep 2026 17:19:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F27E36B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:19:40 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 72189140143
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:19:40 +0000 (UTC)
X-FDA: 85246293720.09.7FAAFDF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 93E1440005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:19:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Dj3qaJ8v;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790198378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ph4sZt22ESkzgUHNQP4jcUPEFYrI06GxwSPvp+2Uv18=;
	b=Yp7WmaWACl3Zj2Z5JMeDVkB2NQQbHc9YfcwIWXQMk0RmvfIE8S4nJ248Sn3/0Gc1C4nHQW
	PtPzYUfiMS1OROLDXqct6qbkLtB3ODr2iwTKkisR7NBVvUtsrl1j6tm6etVgtK92oQscgm
	EVNQZOxeVwANWyv9A5vkawjxhgLhXyU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Dj3qaJ8v;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790198378;
	b=cimmBCezo411iA15yKwJaacB21CHVkqWnmb2MZ3eU3QQD++Ni3pDcpju6ZZRLhbo8s+JGc
	0Swmg20EFb4jJdj8oUo18uyHdKeyN/c6QSYqa0L0p6Ovdr7WLz8ozAaruh/+pMUlO+Dd4L
	Pldvm2ETcOwjaUZ4kPgq060emmhdCmk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A284D4197A;
	Wed, 23 Sep 2026 21:19:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6FB1F000FF;
	Wed, 23 Sep 2026 21:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790198377;
	bh=ph4sZt22ESkzgUHNQP4jcUPEFYrI06GxwSPvp+2Uv18=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Dj3qaJ8vVz3tbYuKzWpNoKIDnMaryNKKSoxyHIsS+W+h6TIcoEjSKJRD3V8y/Eqmn
	 XhYpVjFwx40Qe9lJPvahTeuWdHm1VYb/4OMV3V5P56yKoK+vCq0OakJjRxkmE+/bNm
	 CqBNsU46UizbrfNkUde86RE2+JrUxrlUX0foREb0=
Date: Wed, 23 Sep 2026 14:19:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mika =?ISO-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>
Cc: linux-mm@kvack.org, dri-devel@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, linux-kernel@vger.kernel.org, David
 Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, Leon
 Romanovsky <leonro@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>, Matthew Brost
 <matthew.brost@intel.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 00/12] [PATCH v14 00/12] migrate on fault for device
 pages
Message-Id: <20260923141936.d1f9e5b85355f0bdc6a6ecd2@linux-foundation.org>
In-Reply-To: <5b1d0fa6-d183-446e-bc52-56e0afd3f398@redhat.com>
References: <20260922053421.4092027-1-mpenttil@redhat.com>
	<20260922192726.90dec3c4c77b8c9063dbf218@linux-foundation.org>
	<5b1d0fa6-d183-446e-bc52-56e0afd3f398@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: jda69mfa7pa3ob48cupqr9wf8cy45wih
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 93E1440005
X-HE-Tag: 1790198378-414116
X-HE-Meta: U2FsdGVkX1+v9DmAeyIf/FELtNHv5VKzPAvC+Ur6XsK2BnUndYPVasSu9DThPSk1UvU8ckqqxeYsQNPuT1KXyGhu9BjLV+Wd+mellbB4FBiBdZrtivFJ4Z6kJ8F1yjyrIw3jWOxQiQYETZWgm3rr2wpLOwu8lLy8i0+nVbqyRIneYkt9YSOLefG66gN3StQxC2uHVQV/f5H1Rwqv5Bcs7jy8ss9us2knnRjUGKPs+FagShc3YPxyIjZSWV86/pFQANpZ8Q8NCrKPHDh82gJHQq4sMtpeEWm0muxDuavDz+E9hP1H8bGFlKuYdryRYpEIFZ9EIJtnici/UdQE2MNnQtAQuUSkOmM9AwyU9xEVhR7ZLB6oJlal7qyuhDMiqlPHxGataAob9azRx/csgqNfdKKACuUzYjOqq8BYwB1i/GhCZ7kTPyCUO6P0IM2oQuU+AC6BSZjtJJaNxxltnJCuKk49hPugm0f7/eCUF8xGmnyvDcnvmZsmYToQ1vnETF45EwMPTXQbiy1fdWuBkCbShauIJ5RhyEpDnnyPNXJwhQXWHaKuirBpcr+Behn+X7QkKGx8ptTSF0oCAb6ZxlteTXIR5KjsGxR2J/E1rPbOXV9+5EYPmFczoFhKRNzINthXMJ1UZ3tbsAjLlciUQ/p+tiBz6n8ZHn7enTIminFSfJVjHk0jkD7Qaamafd+HyD8CDDSMfnVCVotX8of6SHwYC+gNaW+uZoFCtYdK7NFL9KuNE+ht3sqG9/OCgCVJlxztaWZTh4oV47qU273xZ5A+X6UB/yiLjNUEkyswEZQ+8QZRsNUmg11ZVCLS1/7d+A+DSa9QBzgo2qctzk6i0eb1UvIF/8UGk04VwKixLWJrPLu/Jd2Io5C4ANcdmPuinEBwIg6B+SKz2RAhvyAOl2HI8wZbcHaOhAfuBFkPRa69eiTlEFoGvGA61HKCMlVny4LTam6m+52OzSXoLY//Who
 vx1zxTYM
 z4/pbTtHNjOV6+H7d+GRRdYZrBh2YD80MmeE2W1AhLJhoiKnR44Rfpx91F1WnPy4MRXM/HRC2xK3WGyRh9RoH8l95DjfzZKu6vHIe3tAMouMV8fckRruuegpZXMDPZGUw3l5gL2kF5qzeYz9znQOAA/aGV/3HH81QgeFIuIPsV2bUdyRl3NLSF7SIIEyTRiN8abMJSaXQx8LT9R1rbb333mCmoYFaJY/j5rrsW00KNbodwtSQEI2rZmRlHD8LZIctv1PQm8yaENbQ2y7ou4LvaPLZaW4RU7VHGSgyK9kEk3a4Q3radHP6NfZgn0PDRUpnqQPD/ykBnYHttGakfSf0nIuWlz22sOQAqfxR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 23 Sep 2026 08:29:34 +0300 Mika Penttil=E4 <mpenttil@redhat.com> wr=
ote:

>=20
> >> migration). It is also tricky to code correctly. One page table walk
> >> could costs over 1000 cpu cycles on X86-64, which is a significant hit.
> >>
> >> We should be able to walk the page table once, faulting
> >> pages in as required and replacing them with migration entries if
> >> requested.
> > Sounds sensible.
> >
> >> Tested in X86-64 VM with HMM test device, passing the selftests.
> >> For performance, the migrate throughput tests from the selftests
> >> show similar numbers (within error margin) as unmodified kernel.
> > But no performance benefits are demonstrated?
>=20
> There are no performance regressions for current tests.
> Real benefits come if want to do migrate on fault.
> For migrate on fault today missing pages are collected as not-present and
> the caller has to fault them and re-run migrate_vma_setup(); folding=20
> HMM_PFN_REQ_FAULT into the collecting walk removes that extra
> fault+retry round-trip, dropping two page table walks. Page table walks
> are not cheap. Not to mention simplified implementation for driver.
> Also, the vma looked up as part of the walk is readily available for
> migration, eliminating the need for explicit vma lookup - one more
> performance benefit. Net effect two saved page table walks and
> one vma lookup.

It certainly sounds that this series will result in performance
improvements, but have those improvements been quantified?

> This series also addresses the vanished/reborn page table while
> collecting problem which can crash current implementation.

Oh.  I didn't get that message from the v14 changelogs, and crashes in
the current implementation are not what we want.  In fact, addressing
those is more important than speeding things up.

Under what circumstances to these crashes occur?  Can/should we we fix
those in a minimal -stable backportable fashion before moving on to speedup=
s?

