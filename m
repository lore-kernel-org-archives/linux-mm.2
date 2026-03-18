Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97AEF103E18B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 14:10:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7B436B0206; Wed, 18 Mar 2026 10:10:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2C496B0208; Wed, 18 Mar 2026 10:10:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D42456B0209; Wed, 18 Mar 2026 10:10:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C31886B0206
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:10:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9E19F1A066A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:10:42 +0000 (UTC)
X-FDA: 84559369524.13.8122F3F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 03994C0004
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:10:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ElHBZ8Vv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773843041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fezKM7Xvi051pm+0o/waft8Nh8Zbwa9FBAsqhL+7GOc=;
	b=R5bTmGpzFJ6OYRlmcjbmZiqU+AwnW/6yZS43ugXpgWAzj7FCZoo37qcg51xx84RKlKLETB
	GBPkGtpfLmOyZlcbfGf5cgau1XZqdd/viE/Z2wFyxJeLylYpMTE3NWyRVRtISDQLscXs1u
	+jdTB03X38Ki1az2087OphkveEpf9rU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773843041; a=rsa-sha256;
	cv=none;
	b=aejZLCszL4aAAs+hsQaNTMpItwqNm0YmYQLh21lwqbkR02FTQIM7MX65ab92tjBUZS5LZB
	1I1IsnWI39WUKlYRwvOIrO8+NCOPnm/vd99321p8WANJ7VDx3UdxUT40Mi1pguqRUiFUNd
	t7P0d1YFjEjTvlBkYqd1bU7puQF5cAI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ElHBZ8Vv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 418B4600AE;
	Wed, 18 Mar 2026 14:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87CEEC19424;
	Wed, 18 Mar 2026 14:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773843040;
	bh=fezKM7Xvi051pm+0o/waft8Nh8Zbwa9FBAsqhL+7GOc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ElHBZ8Vv9qBAlwoqfdktt9Gp8rntF/lBOYp1KQDNhJNqAco0f83PxFVuWmFsO+9kG
	 89lQNxkt98JNPcTYwc/eSZ60nYNI2g0/HSpBW2zfqeltoEMowMwisdDF0TEADMyDDT
	 k+T3UzgIt6sRxXhDq33smnFU/7Lg4yYgUg3S2cSRWwn40qa7DdFqOMwsV9Rzkn/yS5
	 7InhP8mFagc3sNBV5ZgW9iMxXTFhQT0hXTxRNzeK2BQTsh0kRfhWX5Bo5E08ch/6ur
	 ZuuyZoIEj2n9AyqWdtFhpYwBsp5W5TwmfaRfEK0Y1Rxy+FWZksdckAVqbr8dXHPDlD
	 n8TOHGIO4dW5A==
Date: Wed, 18 Mar 2026 14:10:29 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "Boone, Max" <mboone@akamai.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] mm/pagewalk: fix race between concurrent split and
 refault
Message-ID: <789b4585-7542-412a-b9ab-3f7de8d8dc89@lucifer.local>
References: <20260317-pagewalk-check-pmd-refault-v1-1-f699a010f2b3@akamai.com>
 <7ded426a-0cb5-437b-9634-8d806b704db6@lucifer.local>
 <719CB417-F511-402A-91E3-8A696ABCE0D5@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <719CB417-F511-402A-91E3-8A696ABCE0D5@akamai.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 03994C0004
X-Stat-Signature: skgziscnt81u7mn5jr7wc9e8961fm817
X-Rspam-User: 
X-HE-Tag: 1773843040-869322
X-HE-Meta: U2FsdGVkX1/Kramb2AEg6buQcEy8e2foPngMcqNCc5Y6fKMnd0jJTkVtRuJbUEeAK2gScScK6XZj4pTI3wE9E2M6+9Qlw7qoAWWSZxtwJWjuv8/Rw4EjwGxAyqzMdlqa1924PQw5GUSpjJa72OccZWU7+liBR03y1PQiWR4/ftGRilbdOP5thRp+XE8L85hc6ADMzVmtyNvu0UL1Qb6jTGRwL9T1Ip1k8XvT1M1SWfYH9dYhyJzY5YIH9Xi2JLix3EJ2zqvVm2p+A5P2QNvziRNEeyuNwsC2vXdNxQ7Vh9qXMCwh+Xvs+t2na/YDaDP028cd+Oh1PmBq3gpD9a1Ca9TugWYYo6znQm4YkrS8IFKbvZ+lHRPOvd6svDu/3TrrAPWt6V5ozqi21GjypAItE9v7PIBsLzqSh0xgcIrxO3dePPXSqYOsSJ6uxiluejoLDniYPoYGDoAUSXuDnQXi9XD0nqAghhKKQNjHYang6/qymMKcf/JY5XUN550vsKwi+n85GSvchFbDSzV0D/hrFo0JoSCOzhEauqS34YEKQJTODupN2owxFx/Esv5RkU+g8bUYH+jZ7EHz7Mld9bD0yxAAKl7jJ7gXyulnk/HWga1yrUk+gCWa9Z/8zI6MxtyvlwVF3QDhzNrHOrZCbQxg6hrVKJsCG9n47n6aLRX27gEWZPErvxRyniUtCDMdwAK9o/ThWIcqJ81cpxbVd9gVxnZwpkYYNRbnXH7VxJKMDYCMuIxqYm1nxp6VXktbcYqb//LwfFudaBh3RAQkyb7NE7C8/LrWX1poASlU4hHTn/+AN/86+lhOki42gd/ByT+4z6p+5hqb7xv2NVwHwHH9UNg7aqXrpWzAr16//DMHNSkt7lI5MAqp7u5QCbVojbpjuoZjZxfNuWp2yKPIFXLUkhbN69oM75Y8ZH0HOBRGVLm+wTZow6YRZKJgGOASbeUkplUo+cwclKwEa7Qtz5G
 H9gnHuS9
 p1VW3fT123lF89h/+XliR98orEjAKANEv6Hg9uvLoQE8YwIfCuNmv6NkgdSnqUaRGYTeVg9vnU8tRFTJrwz2xjjSc1SjUMwLI78m9QJMKFfQRg5Sx/uKCCMsA0gqpwfKdgsvKbeoA3A2k1IV1EOguGhwSqg81jn+BbuL7E/KyqszDqh/gdQ+vT3NszZlVxttkMhgj2lIZYUePSkfOs4TaUnFS/ETJqebNopNl8KQrZbRGeyPlfBh7w/6Kjt6Hh6mQcLaCeosDBExC+jTHlFmTL3TWg1FXtfLyJIYSECeBbRLy/GQ9+ZE5Vfmyvw+gwb1GKAJ9yp6dUXqUz3Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 01:08:33PM +0000, Boone, Max wrote:
>
> > On Mar 18, 2026, at 1:55 PM, Lorenzo Stoakes (Oracle) <ljs@kernel.org> wrote:
> >
> >> […]
> >
> > So IOW, the PUD entry is split, then refaulted back to a PUD leaf entry
> > again?
>
> As far as I understand indeed, although the usage and faulting of huge
> pfnmaps does not feel intuitive to me yet. Empirically, yes, observing this
> when follow_fault_pfn() in drivers/vfio/vfio_iommu_type1.c is running
> concurrently with walk_pud_range(). I have another patch sent up to
> that list because this fix causes follow_fault_pfn() to return -EINVAL [1].

Ack

>
> >> […]
> >
> > I think it mirrors the retry logic in walk_pte_range() more closely right?
> > Because there it's:
> >
> > if (!pte)
> > walk->action = ACTION_AGAIN;
> > return err;
> >
> > I.e. let the parent handle the PTE not being got by pte_offset_map_lock(),
> > and you draw a comparison to this in the comment in walk_pmd_range().
>
> I’d personally say that the main logic introduced is walk_pud_range() retrying when
> walk_pmd_range() fails. We’re also splitting the PUD in walk_pud_range() and
> descending. But yeah, retry logic mirrors walk_pmd_range(), deciding that we need
> to retry mirrors walk_pte_range().

It's not a big deal we can leave that as is.

>
> >
> >>
> >> Fixes: a00cc7d9dd93 ("mm, x86: add support for PUD-sized transparent hugepages")
> >
> > Yikes, really? :) This is from 2017, I'm a little surprised we didn't hit
> > this bug until now.
> >
> > Has something changed more recently that made it more likely to hit? Or is
> > it one of those 'needed people to have more RAM first' or bigger PCI BAR's?
>
> Yeah, frankly, this is the first patch where I could find the splitting being introduced. It might
> be more correct to refer to the introduction of 1G huge_pfnmaps?

Yeah maybe that makes more sense? David - what do you think?

>
> >
> >> Cc: stable@vger.kernel.org
> >> Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
> >> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> >> Signed-off-by: Max Boone <mboone@akamai.com>
> >
> > Only nits here, the logic LGTM, so:
>
> I’ll write up a PATCH v2 later today.

Cheers!

>
> >
> > […]
>
>

Thanks, Lorenzo

