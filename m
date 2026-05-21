Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 344CDCD5BAF
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 17:09:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 547716B009D; Thu, 21 May 2026 13:09:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51F846B009F; Thu, 21 May 2026 13:09:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45D4D6B00A0; Thu, 21 May 2026 13:09:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 397C66B009D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:09:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0656D8F916
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:09:43 +0000 (UTC)
X-FDA: 84792063846.15.B69B821
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf22.hostedemail.com (Postfix) with ESMTP id EBFD1C0015
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:09:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=POweKYiL;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779383381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h4ti8tMqv/39MPGM3dj4x90oM2WjJ+5dTMf5p7SntO8=;
	b=VRn1SCMBwcFacvHiUVugci/UaiSi2E3r5Mo7A9Y18hynpgDXnBjquHOlfeZnmx5wSkZjIU
	bvJbFO+cEifc8KUz0r1+y+F74k1pwbBWgi8QF6jWNdazT6KamuliERqRXeXx33Z6RncYb1
	QKvwbuIghvbn+7Dc3X+mTrNnJ7o7ZbI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=POweKYiL;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779383381; a=rsa-sha256;
	cv=none;
	b=MQmy6uNJciGEbu/P+Vpq/RgH1YRZAP3IL3Ogi4bwkcOlz47xef2t7Y7fD+tDChat09bFAD
	scL7H+8ecg2cyulgzx951WiEPe0D8jef6xrKK4q19prBu0P9h4qtmV551FZhp3+nQCKVxk
	1wjSWhw78TwsoRwYDe9ZDucSnM6RJFI=
Date: Thu, 21 May 2026 10:09:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779383378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h4ti8tMqv/39MPGM3dj4x90oM2WjJ+5dTMf5p7SntO8=;
	b=POweKYiLpn8+ZjkVrZcM7/VVK5Km63yJ38njVHPQb2CraBfI/2fiRzEwJDuH8zcFuYbEKr
	8sr9cG+tG6MWKQBFUqb0/gCpcS7EpwTemtDrL3FKwPV6p+P9rGrQ8wmCje3hTviiKdL0+6
	DKQIfle45Zzr5iJ+Nna4+wG00SL8jqk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Dave Chinner <david@fromorbit.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Kairui Song <ryncsn@gmail.com>, Mikhail Zaslonko <zaslonko@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 7/8] mm/memory: flatten folio allocation retry loops
Message-ID: <ag88K4CRpsqOoRak@linux.dev>
References: <20260521150330.1955924-1-hannes@cmpxchg.org>
 <20260521150330.1955924-8-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521150330.1955924-8-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: EBFD1C0015
X-Stat-Signature: 3y3wwnwy8ztk71pxmnb67gjscutmsrjd
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779383380-927260
X-HE-Meta: U2FsdGVkX18OHntfpKLlSusRjF4Q6LsT5pzjeLXJU5m6aoZVA8csfqr7YGi2Op2eoxHZ00+6B8lMngOjYEkNp027j1O+XXGwGJ8EABNTR5Q1T/MfzgSxVI/21lPBKEyzRhL8uXEtrgAGSKCV453j3p2yX3SdhqmfFAtulfykWkxem9NapHGARsLyMM12bY6W93tflbHWG5xZKfuVTCftPOSEXkqi8eDFrw7Cod4e1fdMHY/A4qqvxp5LJrO+PMMv4y/YC3rwP4F2GRMmbUf6TqmpIYjUFHPcIxi9wM1ovLU4KWThFyciBQ3C8XNQK4645yc8Hr5xsr5SdKUCgboW0S9dkhlMbNJHfz84y5H3ECdKVZzinBt8YE8V2jxkc3BS+vGRmjc+z4A/+L/vg6/dyT8zTkyQrV8japWKdx3V8ACiDPnbX1iUF49WmtKwrcqJhST14bp+yhlSfsp7jI2gy83MboCRMTvoRZyPzcu42AqieI+QN30a5ciT86L0BnYzmlQr3hArFAk2fZvQD79MEX6XvtSI6B/ZMifKN3ayySWLBNUvXxplEiQCVgL/fsXA45QgdvVIsxyJknvOh1WgzYNvkgOH5pJi6TleKW6oqO0GaP7T+8xWam7avwnkx+jLalHH7WIIunAWSd6qW/+4DuuCFeQSmaFd6SXreApi3CJv9mCYfETb5SoPmsKQQXP/JRrRjMCIMZn3KoWuZWVNYLVN8TrvMy2ExxKvyU4bOBupNgpLhi67O15L8VOqKkva/v5kgcXcwsFRJM/JbJnfLz+QBWDAgXuEdzF0PD4eKRIqqYoNGtdrq9vu8pHSfXzz7pbQ5POY2EW4vHjVx0Bu8H1BwkBrDswMC+3+bsRCa+7BFZWv6/HF1c08ikCrhlIvJw8yYSMKyL1OZG1wYQdPzm6/cyloLKYrutcAgdGOLOCv+78mOIx3GL4mZfVd7UTOthnVhIWgMVIQ/VKwsE7
 wtzk0GAq
 Ny/xUhyo7ZAXTsOkT90/aAY7bG7DG7ll83QUevbMXr3QuiivU81A94KnWXWSK8Pjfzu6FAM17fUwrvzFKK6WVl09exo3Yqw3p8F7mUIoaXVrnYSyWfn4WXuEwJAGXA0xC8hAcgn4/sYgm0cx5DgRgsBClGAaacWMmy9rezQqBxkMxkM37CJzeIXGna2fFnWA8LQtZFxUAbM1LsIr5lEOd/BZlUzQwppBJiv+u2Lrtxtv1cx/7BjBNYS+fde+EZi9s6ZofwOMX1HAw0Ke41tbtRMvQXUoRGiGWUYHrvjX+hIKaHq8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 11:02:13AM -0400, Johannes Weiner wrote:
> alloc_swap_folio() and alloc_anon_folio() use a top-level if (folio)
> that buries the success path four levels deep. This makes for awkward
> long lines and wrapping. The next patch will add more code here, so
> flatten this now to keep things clean and simple.
> 
> alloc_anon_folio() already has a next label, use it for !folio. Add
> the equivalent to alloc_swap_folio().
> 
> No functional change intended.
> 
> Suggested-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

