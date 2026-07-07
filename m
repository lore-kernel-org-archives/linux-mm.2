Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32438C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 11:06:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 120AC6B009D; Tue,  7 Jul 2026 07:06:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D1756B009E; Tue,  7 Jul 2026 07:06:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F02A96B009F; Tue,  7 Jul 2026 07:06:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C08246B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:06:51 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 08EF01A0405
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:06:51 +0000 (UTC)
X-FDA: 84961703022.14.4CF8264
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 62B0640011
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:06:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eNsHbIf4;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783422408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uxQP3gLmIUzYBfoacOtJptD05zMRflOQs+DB0wW0xpo=;
	b=3SavrQbiQD6p/lzjiLsMkX9ZBJtF8cLdrkVWLpo/w3xlD6IsPDwG5NevzYWrqpoxQ7AvL8
	H4oKfnUF267J86mKtZsCkf8QrWfgJFK2EZ1NGVWAuNgYIC9D6DtfbaUCVk3SpEqmhy0Dua
	ItXpDKKMp9HyfQAYeTGO7hpF7TdBGCo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eNsHbIf4;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783422408;
	b=DhEvIAVbtKpH2h7qmHBxxlFZz/ieTiLRofZBHWb0bgzqttL27lUMMqYahvH49Kn5dve8nw
	v9bL52o+mddvdbXyNLHFBaZmCINAY21nrgILJ/AHIQhzLGE5nXU0IkJ8dLVPVjZAmTg7Cd
	zAYmoMSm8BQ9jbpHxZA6hHPWmRZlGTg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C2C40618A6;
	Tue,  7 Jul 2026 11:06:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59441F00A3A;
	Tue,  7 Jul 2026 11:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783422407;
	bh=uxQP3gLmIUzYBfoacOtJptD05zMRflOQs+DB0wW0xpo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eNsHbIf4sOdWw6JCQpCaE2eEgsRjvyXM0TUxaM/x+HUWu/rR2CciAzQqnoECZaJQP
	 7TEpqs6ZE12aRoYV3bMmMfsJau6Ydnj7iFnb8pWmuEa7H4SjEhfeIyGFpJzvYC6GGY
	 SOGdrZDZKX1RaGFDjE/2DkMaQfkQQOEGEpNHVXONMHdyHm4vLv+qJfHghVL5y708KS
	 t9P1p7NQR2ry1N2SYphqCNTE7QJEopIIn2vS5+Af0aTIrPWOdVs50g/I8sZiuNvaK2
	 Botwhf8za+Mg5LB4L/RmIP19QXFqK+9FfHiMyVhKffEK6HkilXr+z8tpQAyIPS2CXS
	 13E8O5UYUzRVg==
Date: Tue, 7 Jul 2026 12:06:34 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, 
	Sourav Panda <souravpanda@google.com>, muchun.song@linux.dev, osalvador@suse.de, 
	akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, mhklinux@outlook.com, fvdl@google.com, 
	gthelen@google.com, mike.kravetz@oracle.com, pasha.tatashin@soleen.com, 
	rientjes@google.com, riel@surriel.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] mm/hugetlb: Dynamic, NUMA-aware HugePage Cache &
 Free Page Reporting
Message-ID: <akzZr2jfJ0J8zox4@lucifer>
References: <20260707064235.1386552-1-souravpanda@google.com>
 <9624988a-366e-4884-9408-3f3b88c27290@kernel.org>
 <20260707062428-mutt-send-email-mst@kernel.org>
 <b9a48d89-74f1-43d4-b7bb-be988b6855c9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9a48d89-74f1-43d4-b7bb-be988b6855c9@kernel.org>
X-Stat-Signature: aqcuaxw8md8m7oueiroonf4cb71eh5a1
X-Rspamd-Queue-Id: 62B0640011
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783422408-508885
X-HE-Meta: U2FsdGVkX18AkggqhyYta6q73SMR8r0C1U0vjn0ehwo/c3yXfa7Bn3cz3q3R9vkuDWRDgI56LPN3WELWoFSeNGR63WdvIy9BwZSWFXMhClwd70gjr+1hwn8LrvWI/azMUnfnIsU60tY78G/tWJk5ewKchBNsec/E30z2E+xUG49Z0p3Lah5uw8PWYGVKjPzRtSTzQrCsFf8ySA6Ay1nGZ7N37lvjQZwxQAu7aFXiQ7vS/bNUgPypKxNXN/KLiXwph9+tncf6Wlz/Lwkj4BfpMGR96WaO0c2nediR3Mwzx4C/75AuZCysp+Ar4JfU1aW9JSkFjHD/WN6OVr0cnxHQfwlCCv3/hyHDQgMdzpfTa8opJkiS64C2h5VzrhipR9haCTtX+NCQEbr+WhsPVHLOPMMGEzAgL7CMhMCuTCMls9jRXoDGPLprv5sSinoAS+AzDFxZlM9csRvW/k17dtRwZ2axplZydA1MONL7a4TtuYzthFtr6HXYs6YnMDeag5uN5U/wMkpaLe71FXfPMQjmSry4o+ME7tEDduTd/JCgamAUCQQJOs4xeLnhAHaxHo1UyDdp7k5XiSTgMbKpT30Vrc6qYNEk6SWoH2WYjqGqkH5MGOEJO5CH3kyvvDqlpqR4vEgZ32wyatmyM83PsCHoldsTNGUMxfIWLHlDYiMp/8EAguFJijTWc0DNLNyGBsCfVvR0lYmVm/4K+bCwvdaRLuFGZfvQPrHIMs5kI4rK+zEUMmP+pdb6XXb48TYx1TxPxZYSduheymRkBr4fMvFVMkswbZlScpj8MS/+MlJrL1uMeSSa5ovmWunqvedTMI5OFiEKBegLrXq+bBnBzie1zcXE+jCreE3+WHENeCD9uBthTR9+1WNG66ZNMLAr+NzDPrWQAilkUMMx4Q3tediHBqdccuFN0FSlgKM/gJcJALKpbroSuV2es5rr+fcQsGjaeGOLmHG1YXlZhmFM0P1
 6nLKpg3n
 OAblHiCq+w5LDrhlVjDfoYWHNwyKsEHchnAaU1RN5jBIDXHtg5aTzP9wYs2wh0Y7pfWrwfM+zPHSJTLXwkSHMcz7kvmEaU5amfjbjMhjJsykTMXDXczWupa3CC6wPibvigTo01xJg6UewNTqvGttdKJtSZEkcJb/LUTjlRymFmIrfEZN4wDbPm0BokSTsfSM/FVouWEq94fcfZmCFdok9MaJNAqgaCdDnWh3X2N/mhFru6m35UOiA8/qDbOZ3lvmrX0Oa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 12:28:44PM +0200, David Hildenbrand (Arm) wrote:
> On 7/7/26 12:25, Michael S. Tsirkin wrote:
> > On Tue, Jul 07, 2026 at 09:29:07AM +0200, David Hildenbrand (Arm) wrote:
> >> On 7/7/26 08:42, Sourav Panda wrote:
> >>> Overview
> >>> This patch series introduces a dynamic, NUMA-aware HugePage Cache,
> >>> backed by a kernel shrinker to safely return memory under pressure, and
> >>> integrates it with Free Page Reporting (virtio-balloon) for HugeTLB,
> >>> specifically targeting gigantic (1GB) hugepages. The goal is to solve
> >>> the tradeoff between allocation latency and memory
> >>> fungibility in virtualized and heterogeneous cloud environments.
> >>
> >> Hi,
> >>
> >> in general, we consider hugetlb nowadays to be mostly in feature freeze, as we
> >> realized a while ago that adding more special casing on top of something too
> >> special for all of MM is only going to hurt us more in the long run.
> >>
> >> We want to have less special casing and less special sauce, not more.
> >>
> >> Now, there is nothing wrong in making hugetlb be less special, by making it use
> >> more of core infrastructure etc.
> >>
> >> But optimizing for surplus hugetlb pages by teaching hugetlb about new caches
> >> and its custom free-page-reporting support rather looks like the wrong direction
> >> for me?
> >>
> >> --
> >> Cheers,
> >>
> >> David
> >
> >
> > It is currently bypassing free-page-reporting completely.
> > Making existing free lists not ignore free-page-reporting would
> > maybe considered "making it be less special"?
> >

You have this completely backwards.

You're advocating making hugetlb _more special_ by duplicating functionality that
core mm already supports.

I mean:

mm/hugetlb.c                                 | 590 ++++++++++++++++++-

Tells the whole story right?

The whole issue with hugetlb is the very fact that it's a parallel
implementation of a bunch of mm stuff in its own little world.

We make it less special by mm/hugetlb.c smaller and smaller and implementing
what it does sanely elsewhere in _core mm_.

>
> Depends. We don't really want an orthogonal implementation of something we have
> in core-mm.

Yes, exactly.

Feature freeze means feature freeze, not 'feature that core mm doesn't support
feature freeze'.

Hugetlb is a poster child for poor decision making in mm that has left us
saddled with maintenance nightmares because we allowed 'just one more feature
in' (TM) with little to no thought to the future.

And we've all learned from that and don't want to repeat these kinds of
mistakes, nor make existing mistakes worse.

And work to improve hugetlbfs and make changes like the above are VERY welcome
:)

Laying a foundation for hugetlbfs to be more of a sane mm citizen through rework
series is really the asking price for stuff like this in my opinion.

>
> --
> Cheers,
>
> David

Thanks, Lorenzo

