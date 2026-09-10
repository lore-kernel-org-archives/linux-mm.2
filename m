Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BDABC88E46
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 13:34:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2462E6B0093; Thu, 10 Sep 2026 09:34:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21E096B0095; Thu, 10 Sep 2026 09:34:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10DB46B0096; Thu, 10 Sep 2026 09:34:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E21B06B0093
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:34:13 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 267651A053B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:34:13 +0000 (UTC)
X-FDA: 85197946386.16.13DD6EA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 603C1120009
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:34:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e3QGBMx4;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789047251;
	b=XXsm1023IOC7Msoe2UZOwmIClAwTUbpO40oaBtctZYdPk4tZ4bIYUJcjvIs/D+mYstJhNf
	BF2/OPbChM0Y61qM1YIkfzNwbwxAVlOUe4XfR9DE0ZsThUCzIUDB0EOBLfjrhCCrGoVjYC
	WKeyXMSsG6ee6/oCRIwIUIZStlKbd9U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e3QGBMx4;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789047251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R6tbpyuljfgfZdUpmG6m3DA4a87+jb+g/2HfQLUIr5Q=;
	b=DqyCZ8Okoz/r+Hn6IxpRpPL9WGIgTc/hNXZIN9KvDMntTCklAbH4pKBwWnEhRbmcAW/Dkh
	O9LUuWM4S33i6+rV701ThBSRdwdY+Q4r7lKovSUBKiLSfKTjen0vVRqQeQKn7tpe5+LkWz
	vB3qQdIScRBflPoSKF4uZnH8ujS+6bs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 96F6B439D3;
	Thu, 10 Sep 2026 13:34:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759441F00898;
	Thu, 10 Sep 2026 13:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789047250;
	bh=R6tbpyuljfgfZdUpmG6m3DA4a87+jb+g/2HfQLUIr5Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=e3QGBMx40PqUN7AXNN5xvAZrRXc+smUA71DzaOAKCJ6G7uqdD/CedJcNXMpOGUtHV
	 Oin5mrHtRH23KfztzB+zwG/7C1glqUgUwj6gLis2aKwn1hCcbYbcWE2YjEX8j2f0vz
	 ITlhZYTr4l0g/wDFEPFTBYUwOyPh8Y0EXNK+44DCc11pTauxgCg3z7KF4079I7zGh4
	 YzbRYSmBqz6tHCTqhhCe2BLIicwyugGqTygpIr7GqAKHWqjqfAxLl3y/wcvvqr/QKt
	 pYGbrrHMx/QLyGr4h06b4NGOBWghPeB6yFdgwKWG1AZ0cow3YJLjnuA1Ny7jRfsZFo
	 Avx7L5fZNelJg==
Message-ID: <db6eb031-4eff-4eb2-bc66-df94e890dba0@kernel.org>
Date: Thu, 10 Sep 2026 15:33:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/12] mm/sparse: move __highest_used_section_nr handling
To: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Oscar Salvador <osalvador@suse.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-8-008fc8d579fe@kernel.org>
 <aqJrblWch-lajp3k@localhost.localdomain>
 <c2239ef2-10f4-4c87-a23a-2753f1e18d27@kernel.org>
 <aqKd1MUgFVHozVWu@localhost.localdomain>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqKd1MUgFVHozVWu@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 603C1120009
X-Stat-Signature: fexj6twx6eeycfif6g57m4des7exf6bq
X-HE-Tag: 1789047251-43593
X-HE-Meta: U2FsdGVkX1/x3aDTs6bhT8zEilXGXsphHn5ytXUMDU986E6z0+OEj2MapsfbdDsPfNLt6M2+fdlRZGlKzEAbNoRA7j30E4XS3TA8GrOS9MqGMf9jOL7lxHrP9eoKY9nwau1jlrZBsJ4Jt6pHjIgAB2nKgG+pnCrhdS6oUsY88c1ofh9qC/yeRobflHVr4ghTIVoNOhfleSJ4tFAfiMRWmC4/ETPJ5TAzODx7NuStEpASAVzRejMFlcHy6qIM5jXx+aI9dKSDw8eBIyV1DTCVm3jDq/ARFl5HTI2fPkbAK+hwkY71bz3zpQcWxWcRdC94atpl7Mh5n+6TnKs1x+tCBGSra7yGY7rsdu8tgF0PCC9oNNi0bi0IVg/NMOhUli9fv43YHz/NeOlBdYqYB8XY6WWD/7LvQGR5Ql4Gz1WoHYkiI4AN3NronkL9bNHs/Q4o+rfL2cPe92DCtEzty1lAgmgDdZGdGnV0OmHT1p9ng++T4YMvGdjxSYy7FCBt3vQyBO9JdW/6481ZKQ8dEbIvw4r016lkEbiTCsi3BapppXGzrj5e+U2ALFMtvTFowl89dvbsaBTsdh5uA5uUeuMMCWrNdiPK27AXo+FZnD1aFzgKdOpC+TOLD986mDPwpKK+IqcNPU279MyhmrF7G50LJfbhAgwmG7fIZAqPC85tRbwUll/pHGTYG54xZ2+nzJgWhkMcaOLiW3eyhj9JM2UVBVJR10ystX+YCB94Y5M+NckFhZnp1L7oSAtMOZebykfm8tdTyaA47fWHeSPBgovXU87I4acEZtFY3Af1U9cO2TD+mBCYPQ1VUHdZ8VpRCU/IOWNmuQZrWPpGfaumh6PF2SBBhGHHkgKxBLMwNwqfcB8g94LyRIqap/LAUFanf+HgKEQqgmeud8dYJ/4BK9HFEf3sXFKK/rGn+RDsO88/4YjbJS1i9vnG62AwsLE6PHLpLvGxt1rx/REDXpK+m/f
 o8FC2CNN
 cYidQyAoFfcODqxPaNQxjp5z2X7KwwYZqHUkGMwoDgTJg7mcwgdDBy4ELLfpxEdpPCLnxBsi+9pueY2iyqb2BDvThyzY6e8om6zxL5f86LXslWihk9sAMoNNcPRz3G/mEL3negAXBWM9N7D3EDXa4ZSEouzmcDxaDNTSLpuy9pIMbjtB5NgDPa1HfizYYUmjimCF3He8XtCii2imyYw03JT/FmpdddnQekcHf83pUnTSuAnkWpj1ryqfR2Q7ogafdBHCJOYbzM0S3pV9m4LhUhAQBhHGpubNyisWySreO5STEqzJ4rI/itKp9uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 14:08, Oscar Salvador (SUSE) wrote:
> On Thu, Sep 10, 2026 at 11:13:18AM +0200, David Hildenbrand (Arm) wrote:
>> If you have something consuming __highest_used_section_nr while concurrently
>> updating it, you might get torn reads/writes that mess up the value on the
>> reader side.
>>
>> For example, mm/compaction.c consuming __highest_used_section_nr.
> 
> Right, but I guess that if we get a 'wild' value, at least we are
> guarded by online_section_nr() performing the right thing?

I guess so, I was assuming the only real scenario would be us missing to process
certain sections (which would usually not be the end of the world). Getting
larger values is unlikely when tearing reads/writes I think.

-- 
Cheers,

David

