Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F7C6F589D0
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 13:22:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD35F6B008C; Thu, 23 Apr 2026 09:22:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D84536B0092; Thu, 23 Apr 2026 09:22:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C746D6B0093; Thu, 23 Apr 2026 09:22:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B58956B008C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 09:22:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4ED03120157
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:22:24 +0000 (UTC)
X-FDA: 84689884608.12.E6E973C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8FCC51C0002
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:22:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fmmlHdvT;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776950542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3EXZz79asyTCA2YQbVtqAxh7oAXiZXvREE1gw4u43b4=;
	b=IEGSa9lV0IYL1xJTF0G8zf+qECORl+xVEKhr/Jh0YVew7dA7q1SEjEpSO6UkAbn6Q4X41R
	VU/ip6ZcvaSkkNswFe0Wl5xB5nF9pm0U56obyvNFQIYhD6VsgUFSEPVDWPA07WLoa2p4Fo
	8tXPHKwBfi+ryqEhqzujMqGZwJmg2yY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776950542; a=rsa-sha256;
	cv=none;
	b=Awt7ixp5L1gv14JHexegKCobFxpfyBy7cYl1lyVwRmsMCd3HWVoOCMBAwPzwte9UJ6lQML
	NP3SXBERsrz5+RnpaL3uiptHY8KKjR4wdnp6b1NzGymJi7hzTcNzBy51yB9amttuRdWgLA
	0Ndz5IJQK8fMFmT+MIDcO4rPMPQEdnk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fmmlHdvT;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C967F6014B;
	Thu, 23 Apr 2026 13:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECEAEC2BCAF;
	Thu, 23 Apr 2026 13:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776950541;
	bh=7HjhCeGqAeGhH5pZg8mgHAuQzAKytrrTmEN4suuSJzI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fmmlHdvTpyIBa8fjnS56K1y4xm2iUS5mUPlWtqkveTk1qCuCkL3feZXk+m9dgQqWp
	 kc6nqGSov/0+orXUO9Jncnq/twT/fuElONdMYycx11BkTDDvdR1ZcDJuUv58vi4CMB
	 MzJcBvUq4lv/diU8sxkqj29sTSZ8+yrmV9r1ZoL6bli8uK8eiR1hRluNhNAweGUxFM
	 VhFFUWvdBs0M0zUNs+uac0dxk8PmSRiKOn8VzJ7/l4kk9/m4sXjhTt21rh7pZosba+
	 RnVO1FFzVrX5hQPubXN0rtGly0qET0ITynAS+x6iMNoPxEkrxAk39q4dom9i2f/Tuj
	 JdgddCqPBtCIw==
Message-ID: <b9f5622a-5806-4b22-8b9c-5d968a14a792@kernel.org>
Date: Thu, 23 Apr 2026 15:22:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] mm/migrate: wait for folio refcount during
 longterm pin migration
To: Alistair Popple <apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 Barry Song <baohua@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 linux-mm@kvack.org
References: <20260410032333.400406-1-jhubbard@nvidia.com>
 <20260410032333.400406-3-jhubbard@nvidia.com>
 <aecQkNxjoMReR6Ss@nvdebian.thelocal>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aecQkNxjoMReR6Ss@nvdebian.thelocal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: deu5aar87kmemaub6hq16m7rzmn9nsfh
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8FCC51C0002
X-Rspam-User: 
X-HE-Tag: 1776950542-93938
X-HE-Meta: U2FsdGVkX1/2IDUHp+R+Uk1OSpHVwfoUb80rAFdXMNTyqVjGGn2FLdhXfcq49/FUKK+Piid2OA5KugoFlPSUBje6iD/yRmovinyE6k3dbxqvz23vTzeyh7JXfBLWoDWjjs75PmVjC7B2LlkwU+MsM7QDlau+jH+4IqCZDyLvxc49n1OLmveo1zFKfsjR3TxqREBJyRym0z4yAlLwvlXJpMkeQPGhtVskIaj5ChjI1fWBALBn28vJa2cvYH2555rqgndq0AOhXQZ4G8/PYFyYbEez5BCF5si30ygvuqymdEMECae+kVY98qEgJiMR1xitmHO+gNHfZ2SotVAiiHivXm8AynMEoXQlKsIzp76rNrgoAIekkpdhVUYXxgSLLoQ/UGSts6pwOwWdEBGCFfVtYQxJs6O1PG8/rCeEw5IZDRHV/gleQ+dZLIEkh0oioz7RjHsCXxFe3bu9ZNZw4G58q1vBdBWhLbs9hqGKOdBcM6OYshf86mzqbVC6Tia4bqhhoMw12Zn2qSyO+e1swvJkHwl4lAfvPVxux1dK6NpljtuhMj9rECCZxx0aXYzoF5ef8KkDbM0E1w7AqsN7rd1zq2msiLfmnEMluHBtV3MIYbJT5fOacdBp4A/E2XeHfliwTnKUbmOI5lpSLGtw6ndajNX3edxXv0g1m8EUOYl4o4RQvttfW980DwCPuLkstb0VAgNfPQnsOMfsxeCLTM7q+ePKq4EUPAaEx7Aog0gIuZ3SgNTibx5Ila76pPyB+ugNiIOQk0K+vvzft2ozsOiVJ38SkY9L7u2CDAdscNqpIor6yZTchVGiAM1ciZLBe6kXwSogy9nIrFdYBW5LJFHQo21mCJ8b9t8jjfoQyQGhJq2rKhAaBVmaEoeivNdyT8+tI7l7v76ABMVwlWNSFiRRlkhaXpNQXN4KNk5qvDs7mw7r3EKNlxvz7CZCEzK5geyNcrENcYhp9po75ZtqEqs
 K2C76MRJ
 R6YhQqsmxEboBvwWazc4QiP04jp8vJOznJseYFPI9QCxDYq3pKiWhkHrN3Sq/OoDsWqqLc6WRv84+8L8gH0Q9mkILlgJ2f5Ies/5Ji3/wVvZQk9xTMZE9laWsDVnfS1OE6mI/N3vuewctpTOJIijiiztEKm7LPZTmxqb0fHFiN8YKt4GkEPUgSTLLnwSVjG1YywoGGzlzOxJ1Ei/S/YMCcALBBTb21IwO9/ooFHPBV199sv197iyMmy+djbMrkDigXDKfoOCeR016im5xtWGCOCMfJLknqykW+VuvX1sS4dJ/TO587boRXYL8J0Ld0LRi4VKQePoNnbA01/eZIxfl48SHqz0Nwg5VWvzL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/21/26 07:57, Alistair Popple wrote:
> On 2026-04-10 at 13:23 +1000, John Hubbard <jhubbard@nvidia.com> wrote...
>> When migrating pages for FOLL_LONGTERM pinning (MR_LONGTERM_PIN), the
>> migration can fail with -EAGAIN if the folio has unexpected references.
>> These references are often transient (e.g., from GPU operations like
>> cuMemset that will complete shortly).
> 
> Is there a reason this logic should only apply to FOLL_LONGTERM pinning?
> Or could it also apply more generally to any ZONE_MOVABLE page, for which
> migration should eventually succeed? Currently that has similar retry logic of
> NR_MAX_MIGRATE_PAGES_RETRY times and give up.
> 
> We have a similar retry problems in mm/migrate_device.c:migrate_vma_*() so I
> could see something similar being potentially useful there.

Agreed on both!

-- 
Cheers,

David

