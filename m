Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FE66C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 14:36:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56B116B0095; Wed, 23 Sep 2026 10:36:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51B1A6B0098; Wed, 23 Sep 2026 10:36:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E60E6B0099; Wed, 23 Sep 2026 10:36:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F1F656B0095
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:36:24 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5EA78407F0
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:36:24 +0000 (UTC)
X-FDA: 85245277488.07.354B62B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id C6F8A120008
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:36:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ClYUnPzv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790174182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RMqeXTuiYLkxGcHufGPSmGBDIg676NTkv6qsR91GN5M=;
	b=kVM8hcAdVorwpLyPvn31XDhRcQuUZ9kSYookygg23oHgXag0gbORvQrGgtNeLPG8trbGb2
	0AELR88CYzjFv1fmSKVRpwjzbF5rwK10tY2rSmWszb7PkFytSysK3YMz5rBofeQzahPeVM
	t+fjZFtdzyzgQZYn/r9QRn+jhBYT0OI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ClYUnPzv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790174182;
	b=SKRI6PknFwxTelXGtbK8rpGikcXVU9RZd765geeOXzWa6IJy6A+zIBzhz8QGRr3D2hkidO
	6iwU/grX9J/t84/q+2vvrc8BOtP6T//I7IPmprgpx7KEzk7i6oyYkFjg45afpEsu8/022a
	+Kg1/eAwVhpiit25GE0idRIk3zn1/Q8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0C6BF600AA;
	Wed, 23 Sep 2026 14:36:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20FD11F000FF;
	Wed, 23 Sep 2026 14:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790174181;
	bh=RMqeXTuiYLkxGcHufGPSmGBDIg676NTkv6qsR91GN5M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ClYUnPzv7jYTs8D+D+F2aQPQ4bLpd+KRsY8meqPjiKFoPlOyT68Moi3k4LlINCJwk
	 XnRouoeqSE9/J1gR/CXwcsKEFElE2+bpGP90GxFl8GuGor+pxONj1UTnSr9++A9m75
	 BHEkrCzA4xwmcMJivXdnnxqiuewpmCvyWu9QZB58JfawU5o/kY6bver022WQZ+LWpH
	 jXZ0r3GtxClz80gvrVzF25bjVBtaqLU00yMOUgvi/M+K7VtVRUAJgTqdjkimuOHpGF
	 avm9n9Y0KuyubiNek4csBvRPx9/0PBlAFi+kA+ZRvtRYce/cp2NcctX8nycnUjCSro
	 JIcjWOKyvQfug==
Date: Wed, 23 Sep 2026 15:36:19 +0100
From: Harry Yoo <harry@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Amit Shah <amit@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Aneesh Kumar <AneeshKumar.KizhakeVeetil@arm.com>, 
	Christoph Lameter <christoph@gentwo.org>, Dave Hansen <dave.hansen@intel.com>, 
	Davidlohr Bueso <dave@stgolabs.net>, Hugh Dickins <hughd@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>, 
	Kirill Shutemov <k.shutemov@gmail.com>, Matthew Wilcox <willy@infradead.org>, 
	Mel Gorman <mel.gorman@gmail.com>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <mike.rapoport@gmail.com>, Peter Xu <peterx@redhat.com>, Raghavendra K T <rkodsara@amd.com>, 
	"Rao, Bharata Bhasker" <bharata@amd.com>, Rik van Riel <riel@surriel.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Shivank Garg <shivankg@amd.com>, Sterling Alexander <stalexan@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Yang Shi <shy828301@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	William Roche <william.roche@oracle.com>, linmiaohe@huawei.com, ljs@kernel.org, osalvador@kernel.org, 
	nao.horiguchi@gmail.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, muchun.song@linux.dev, liam@infradead.org, shuah@kernel.org, 
	boudewijn@delta-utec.com, linux-mm@kvack.org, Breno Leitao <leitao@debian.org>, 
	kas@kernel.org
Subject: Re: [Invitation] Linux MM Alignment Session on Hwpoison on Wednesday
Message-ID: <arPdnxhX9VHnDx15@thinkstation>
References: <45af1b22-49d4-5d60-e7ad-14a1a33c8dc9@google.com>
 <arPElEV0zDhXrteb@thinkstation>
 <42221bdb-44f9-4c86-a572-1d1372026836@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42221bdb-44f9-4c86-a572-1d1372026836@kernel.org>
X-Rspamd-Queue-Id: C6F8A120008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 6h55kubd7hmg3nto9ngqseiksxwd6u1w
X-HE-Tag: 1790174182-308389
X-HE-Meta: U2FsdGVkX1/BWtYbJhv7XXrWVNtKQXQZBjbhTjX+YAl/j0IC+rqCORLGNpOLt/qQDFlfram3x8CdeAbk5eHwzwOKO86glLo5eNyu/pW/orgaHTprOCoqIuEYpe6uZvI43fZX82+G97/rwZ5RTECaMuiAtppRzudoekzXJ9tPjizNgWW2rDFMA5FZn79o5JL/PV/dnexjGtiCX1nNAE1b0Liwi6VdZU2vT3SmALBii/ER7KMynTmGG40JHGSEuEjeAhVZ6VlW/YS4771eXE01AVGPV6Jksa1w4qvTb7CyonMwgoOAigOx173UVtjXNeLo/0vyJmGmCt7WzubIJQPce+hrXSwvuihGmO7Gq4i6mqDw1AACZhKApVC18J+5IOWZyOjKBUF57NJkNPTAJ6dcczfQDXlYfP/ncPguNLE5T36Wyzm3wArulVX/KXTlp4SjW6b57QWOsopU6bAxlTkHk3b6WYUgmXNF17cu5NmwzShW7/v5wceVjo0d6ZugFy3DD4g+689vu++pBnRujCfPc0/hEjapmGdQGeqzaj/gMgFUzAAr9aJ34gLiI5646nqPq7vJJ4iykZDm/b5DI1gx4UIQspng6k1pHVjK9EHD6KDauXdnj6g2TJMkFlZWIRRHqVuCdRda9zoOuxxWrzOwKPyU+Da1+zDQs8LceZ/jJe+6vofOv1QhqE0nFcjbTnwL7hDKU4DsbNXKD1ri4B9Zv2N9E7GoBGFCPUuSsj7n4SfGPNXdgfsJBDnA9ayzBDHzoit5RxJ6vX4AFANoV2MgfDHeJ3eU0DV04BCk2cZGaSZw9tsaJf0O0rlyat+iyB0w73sb6sjme3B7ugUDliLlGocZNunJ5aaMXEuygJ/DBdFmzC455wlGThbMEamzMH88qBsbRVS9lc/jHcs/7leNmePWy1Dw922Y2ItoK4FuFgiAc0LJ/xBYjoDA/6SBv8h7OZuVli0b6GdnAV+CKh1
 dMBJu/gZ
 KZc+NIX6PTsuikoQBcrAwSHAPFbuuWnSeS4PhuHHvTHTS4NcQnAvglxwnLAGhJFW0nFtE+69CIUYhRhjULI9S7AELcXylmPG7iy8TfKQpQdX3gS3KHON4OYwmxFKsAS8OtCphtP897S2kyFMPe00VWxewZW+ZbvlVwYPiQEp4rXCXpMc95NoKRBp9iumHrec6AJA1vxaV2OW8kNUcCPX3Jm8BR/49DZrxiRQuPE4blEkBGaE8a3PXJSsc8yq5YRXxm6EuOFR3fpBANZJQTAMsgnAJwq13TF5ghd58XtFoUssFFukfyGTFv0h8sJHXnM68gUncqypZJcYCm57GgFTobJP18FdQcxqo7qaMoGxDosBRm7Tg0aiHquXWxwZZaqs7383lkVir+rcmvIgJxUqT9lPoDWYTr4Qp6sbyl7/HaSWJoL1qZhmOd69cFGbu1nbissj/t2tTPpV9aE7m2W486KMXoaoTx8Eacj7GgXmzBYVCzE26/zbn8iF2fux5P3iZ1WDlY+HqDQYexsFz5Z+Q3wGH74sSJ8Ep0fE5zXS/4nk9jMVh6gllaSFjUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 03:37:14PM +0200, David Hildenbrand (Arm) wrote:
> On 9/23/26 14:57, Harry Yoo wrote:
> > On Mon, Sep 21, 2026 at 09:26:22AM -0700, David Rientjes wrote:
> >> Hi everybody,
> >>
> >> We host a biweekly series, the Linux MM Alignment Session, on Wednesdays.
> >> We'd like to invite MM developers to attend and will announce the topic
> >> for the next instance on the Monday prior to the next meeting.
> >>
> >> Our next Linux MM Alignment Session is scheduled for Wednesday.  The
> >> details:
> >>
> >> Wednesday, September 23 * 9:00 - 10:00am PDT (UTC-7)
> >> https://meet.google.com/csb-wcds-xya
> >> backup: https://tel.meet/csb-wcds-xya?pin=1301132214803
> >> doc:
> >> https://docs.google.com/document/d/1QQfZFPHa-pGEGf4A06cSqS0jdJwuZ8ro9JU5H0YSUQ0/view
> >>
> >> This week's topic will be Hwpoison, see the discussion in 
> >> https://marc.info/?l=linux-kernel&m=178796007385067&w=2
> >>
> >> No specific agenda other than to gather core MM developers with hwpoison
> >> developers and discuss:
> >>  - where validation should live, esp with regard to the page allocator, or
> >>    strict invariants in the page allocator
> >>    + implications for the fastpath
> >>  - handling for folios of arbitary orders
> >>  - handling partial folio poisoning and split failures
> >>  - race conditions between memory_failure() and concurrent
> >>    alloc/free/compaction
> >>  - soft offline for pages in the pcp lists
> > 
> > [+Cc Breno]
> > 
> > This might be worth some attention:
> > 
> >   [PATCH v5 0/9] mm/memory-failure: keep hardware-poisoned pages out of the next kexec
> >   https://lore.kernel.org/linux-mm/20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org/
> > 
> >   - The question: How best can we pass information about poisoned pages
> >     across kexec when the kernel accesses a poisoned page, panics and
> >     calls kexec, so that the next kernel avoids hitting the poisoned
> >     pages again?
> > 
> >     One challenge here is introducing another source (a new EFI bitmap
> >     that represents poisoned memory, in addition to existing
> >     PG_hwpoison) of poisoned pages adds complexity and confusion.
> > 
> >     David Hildenbrand suggested that we should simplify this as much
> >     as possible in a way that we don't have two sources of information
> >     w/ inconsistency between them and using memmap as the only source.
> > 
> >     e.g.) By consuming the EFI bitmap only once when initializing
> >     memmap (to propagate poison information to not just free pages
> >     through __free_pages_core(), but to the all pages on memmap).
> > 
> >     Another challenge here is that we don't have functionality
> >     to poison pages early in the boot process before memmap and buddy
> >     are ready. So any allocation before initializing them might still
> >     allocate poisoned pages.
> 
> I've been thinking some more (and will reply in detail to the series), but I do
> wonder whether memblock should actually be thought about poisoned ranges and
> refuse to hand them out (reserved/allocated).

I believe this is what the patchset actually did in v2.

That way we'll have to either
1) make any architecture that supports kexec select ARCH_KEEP_MEMBLOCK,
or 2) make kexec scan the bitmap when allocating the memory.

> So we'd use the bitmap only to feed memblock, but not for anything else later
> (if possible).

We can try not to use it for anything later, but still we'd have to
pass a proper bitmap (through the EFI table) to the next kernel.
At least the kernel should update the bitmap for newly poisoned pages
at some point.

-- 
Cheers,
Harry / Hyeonggon

