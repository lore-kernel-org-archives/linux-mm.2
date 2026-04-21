Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92883F8FA99
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 16:00:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAC3E6B0005; Tue, 21 Apr 2026 12:00:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5D516B0088; Tue, 21 Apr 2026 12:00:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4C076B008A; Tue, 21 Apr 2026 12:00:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A35436B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:00:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DD92A5E50D
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 16:00:41 +0000 (UTC)
X-FDA: 84683025882.08.F7123A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id D7E921C0015
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 16:00:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D4ElFQay;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776787240; a=rsa-sha256;
	cv=none;
	b=QXTH2yTZVOKuE5ra0WVuWokf4dV2u1QmPAnwWo/v+j8bMIVeJ3qHTXRK/rOB5Vukybi46o
	4TLHEM6BNj/vYjHGCNAyZ+dpMxBjjBtO/jUlmcE2/v/07CR/vqa5x2Orr3RJvmTfvUM3g9
	HsqC2vjQcjZ9487EplWzHb9ghTtNfTY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D4ElFQay;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776787240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dpl+gsq/cQftsvD4NwD0nckm1lmBAIYWbi42EZy4D9M=;
	b=UGM11cut8BqQuGhs68l9tqiwCI/Qffl/GBCPYvmRYmnOU9ungu26HPuFC83sv4kwHb5ncB
	NA0R4HQooei7VMW1ZoNzRSqGDMzPrRzhcjsY5tPNW81GQgmWQStQt99zT3UVw/Lc8GwgEb
	zB16ZH3KF/0FvJ9PZhVKm28noK3iDI0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B97EB43B3F;
	Tue, 21 Apr 2026 16:00:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40DCC2BCB0;
	Tue, 21 Apr 2026 16:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776787238;
	bh=bipVOkyye5+9x/U593UGsC8WRYcJxQNZu5e1HDOUX8Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=D4ElFQay9oK6FZyanK3dlZltnmmlnlP/5Hzm1k6ZiDvefKvRrJpdbPmcnNdI8faRC
	 RRROk7QVFL7IwBv7nzjxnRQPBRHm3ae3zPq1821bt1HC3DY9aVHWqb53LD5kEEyrja
	 z8tVKZJlZI27+qvw4aaoBdOPdSLW6AlPSJ37fT69C1GgsIhDzRvzCXMpcIqA2/71uY
	 TvDuGtH7DiBVTvjYMZpdYgJN+RvDXjrhndTiKPtySYhrGkRKYOPZyZHicRDrVrN9zp
	 /l6+eJ0aGKQORiaM/KPuQXj8f2VOuJKbhWCueUkBUSWYq8C6RQIn6owAqH4blVr9A8
	 r7zHGKrcKO2rw==
Message-ID: <51168a90-d6ad-4429-8043-3dfdd81cb9a3@kernel.org>
Date: Tue, 21 Apr 2026 18:00:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] mm/migrate: wait for folio refcount during
 longterm pin migration
To: "Huang, Ying" <ying.huang@linux.alibaba.com>,
 John Hubbard <jhubbard@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Alistair Popple <apopple@nvidia.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 Barry Song <baohua@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 linux-mm@kvack.org
References: <20260410032333.400406-1-jhubbard@nvidia.com>
 <87h5p4isbb.fsf@DESKTOP-5N7EMDA>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <87h5p4isbb.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D7E921C0015
X-Stat-Signature: pq7eqz6xzgxm3kjor3jff4fwnkrbxikc
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776787239-588704
X-HE-Meta: U2FsdGVkX19bdLRoLSH5PraKduqiVT0tjSAsFmTDhpsArgwov1KKMd8Io/HchpjrSCd3ibvsvVxBionFHAdfxvaGbjivYLvCGi7H1JUv9uSrFtb/PIS84Cwy7qjFmxbe7olcm7/bcVl1OtIoCkljNmx3wDmaDWO6feeTL0RDiTf33Xx6GBz5PLWh8ReSqXUTHtna4Q8KyvW1VFcZs6ukbkSQ6lLdlFuJ56N8Y3Sn5cvdvlAJ+suSexFA6sH4TsCYCtzi00oVRKUXcIM+xTtDGDdXLUESpvedHy1G2VsXAbaeZSdtdoD6aUeTaQ+j0B3Rsge4nOGKGtJJW5LsOHYcYabSo1vEEWdXhtkJbkgP1x4zO9hEUgHwDbkHmph7twLOydk0kFGEt6eH//VDgKmbf1//doMg2KiR80TAGuc+/NfCNVKPu9lTzlKdcH8aQQhfgjoBRCTfiZ7souLCaYrCtlboKb0pu31jwe0SSxG25/vw4+Iw86HQGTGcRYA6nnLbswzkBR7mL8+hl1NhdcElJ44u2wG2ULpcm7Ow9/Fs0pb7Y5kbenxJi2ZRxA43AT5EW5ZBs9qvjsOVdgTmb/8L9B6/F/scA/C4Ge8DzBCYEYl5OekPuN9LiE4PcANVk4ET/GmrqZM0H5Fa7xTbpSx64sBQ/wFKrMzTWCvmzBaUdVm6wsDcJEWE/OFpxYmM0txdugkN8kN0I/3aJ4pi4pD6m2u9/lkuxoyG0vKudyjioZXsdP5mipW6jXJSG46WPJs74t6bDPOTv8myogmBo7adXdX6ebFCCZVYoSL3aTYWyb1vLkZgpX2Namg0Y3s4eDIIEEMsC/JSK6pt6yLjAhhKoCz/FwOqFAhNwiHkEt2XbViDQH8kt7nJ808wnb2w8JKFkFLhgz8e78bZ+ZyXqQYPrWI9+HlW7YAi0UqRdxwyLTAbkFnrD+i1mA8V9H+/J+/BSBMUMkT8aHMEm7Ofl11
 Uu13Mnya
 nf3X50MTMTchsSyXoRV9MwNDFbrlC8M3r+lNlDpKKIYkPRtq51ipggBsy5dQ1JvXpCQF0DNDt0L6RQYxXJTKj+rqKvlPy6FxzlrNSzK04WPqsK6PBJUp95BkDu6oXF1mXhanfpwkxvVRKs6RGk2xozBVZX84nne7+m1amAx7H9anWGD+5woJcOf/E9NQPNr7Rk2ov++O8a6ZvLpg4O9loa1mhQyfPssQXLCaR/tJjQUSZK3iQ7kGuzXLDn+oKKihFWzDrntC94D90T4WL2/0PfvKFRAxPBsZewIgPmdYQhei9Oe1vxMOS6bJnUkbkOpQD4oB3eXSFDju/hitxh1X4M71OTq3vgD59S84wbJvbUARvmnVelhYWe6dTng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/21/26 11:19, Huang, Ying wrote:
> Hi, John,
> 
> John Hubbard <jhubbard@nvidia.com> writes:
> 
>> Hi,
>>
>> This adds a bounded sleep to migration so that FOLL_LONGTERM pinning can
>> wait for transient folio references to drain, instead of failing after a
>> fixed number of retries. The wait uses a one-second timeout. An
> 
> Is the one-second timeout appropriate for all users?  Do some users
> prefer fail-fast behavior instead?  If so, should we add another FOLL
> flag to support a timed wait?

We should avoid a FOLL flag to affect that behavior. FOLL_LONGTERM
already implies that things could take a while.

So we have real examples were failing is even desirable? :)

-- 
Cheers,

David

