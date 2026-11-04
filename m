Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03648606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 01:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=A2WVZoGt
Received: by kanga.kvack.org (Postfix)
	id 0BA4A6B00EF; Tue,  3 Nov 2026 20:59:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06B586B05B1; Tue,  3 Nov 2026 20:59:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E77576B05B2; Tue,  3 Nov 2026 20:59:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1DEB6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 20:59:31 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B775CA81DA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 01:59:29 +0000 (UTC)
X-FDA: 85395779658.03.44FAD51
Received: from mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4589480004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 01:59:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=A2WVZoGt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793757567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vtQc/hP3UAI76zkIv9UdY4+7Ue+hQnIdUcRDPGnwDYI=;
	b=AYXoCSX47klVRE3OW3WIVowB4tR+ehmlH4EmFusszr5qX9EHnXuSfoIqJCotFfzUA20185
	6Gwoq1uQXju3jc++JMAjsQXAykgSXGVlzNQP6WYBHP14r3wBca2A0y9848X0sV65tKo0A5
	rcNM0UXC1NjZ8qXJe/caV7QjIWQg07Y=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=A2WVZoGt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793757567;
	b=vYLnLKyUKQhgY0pqCfeX8HOXtX4q6ALnowiUELz0tHZgav5w0OZEz0HWECV5aTwDy3E50a
	yKdICezYDB8wXlyeNuPErDpRepG9P0n70p6Z/sQuChaJiJZiRLMRCJsf4YU2zv0bLicfDP
	7YdGtSsM+KGC4FwHDCXLmAV2q8NqDrE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dEfpVcqaKwJtgCHoqizd1/ayWuwTWWIsmQKh7kUEEfQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793757562; v=1; x=1794362362;
 b=A2WVZoGt2KIuU7thWtNqyKE2fIOPMC62rT+8J8Gm3hHFG3vmJoFY1YeHXImUuFBMuCtu3/D1
 EyhSjAeXA9lNiVQplWoHixIJqTmQE1ogAvL0MndHeR8MWo+bHYggWHkj/YI+Ow9rVGv4KnKuz8l
 KE8pcze3J6rMj9d/2DD4ekPQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8f7e9dda1911563a;
	Wed, 04 Nov 2026 01:59:22 +0000
X-Mizu-Trace-ID: 8f7e9dda1911563a
X-Migadu-Flow: FLOW_OUT
Date: Tue, 3 Nov 2026 17:59:11 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Dave Hansen <dave.hansen@intel.com>
Cc: "Ababneh, Ehab" <ehab.ababneh@intel.com>, 
	Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	"ziy@nvidia.com" <ziy@nvidia.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "buddy.lumpkin@oracle.com" <buddy.lumpkin@oracle.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "kasong@tencent.com" <kasong@tencent.com>, 
	"qi.zheng@linux.dev" <qi.zheng@linux.dev>, "axelrasmussen@google.com" <axelrasmussen@google.com>, 
	"yuanchu@google.com" <yuanchu@google.com>, "weixugc@google.com" <weixugc@google.com>, 
	"david@kernel.org" <david@kernel.org>, "ljs@kernel.org" <ljs@kernel.org>, 
	"liam@infradead.org" <liam@infradead.org>, "vbabka@kernel.org" <vbabka@kernel.org>, 
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, 
	"mhocko@suse.com" <mhocko@suse.com>, "jackmanb@google.com" <jackmanb@google.com>, 
	"baoquan.he@linux.dev" <baoquan.he@linux.dev>, "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>
Subject: Re: [RFC PATCH v2 0/5] mm/vmscan: adaptive multi-threaded kswapd for
 NUMA-aware reclaim
Message-ID: <20261104015214.GA1088663@shakeel.butt@linux.dev>
References: <SJ1PR11MB6105E073723CFEEE8C8EDBF48C832@SJ1PR11MB6105.namprd11.prod.outlook.com>
 <cover.1791577417.git.ehab.ababneh@intel.com>
 <CAGsJ_4wmSL7i4EPLWLKhDD6J=1TywBi5EYYDxp=SvOuXdmLGjg@mail.gmail.com>
 <SJ1PR11MB6105E839E55E9B0BDE183E9D8C9D2@SJ1PR11MB6105.namprd11.prod.outlook.com>
 <SJ1PR11MB6105A05870574FF39B449CE28C692@SJ1PR11MB6105.namprd11.prod.outlook.com>
 <ee9d317a-9829-47c1-81c7-1145304ea484@intel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee9d317a-9829-47c1-81c7-1145304ea484@intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4589480004
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MSGID_MULTIPLE_AT,SPF_HELO_PASS,SPF_PASS
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: dk1ourncyabfo9q9oyespht5mij8zsmj
X-HE-Tag: 1793757567-117272
X-HE-Meta: U2FsdGVkX181c1aMrS+1Zm4UruE+rhHIOryyJ9A8PYyV16aQmyC5FLXMLFCVSDJO2tKOHaCKfTjQORSk5ZqCnw8Pq+Vof1ywxKWOlt06ezDp5N7QthMbiKjSx9Y53bXK4o0CXKklcgXm2oX1siTvVKXS6rrvW7Drhi88/JJv/bmNP4g4VfrTfeejYEw2aFR7ZpXDgi/nxAcrNeL0PmnDfYIPXcrF7xsx+r0zxiyMLHEwrUmPnAHR90IG17PB6+qfDAGUHUm2u6WzbYKdB+EiZtQgIhSN5k18x34iqqTVwFC1GPS//vnfX7UwAgxzrTGi1675r+7gf1lzgyyXMMy3WIBQLYDOGGIatLKSpA1XHRiFD6lbWEGdEPHVWZMSOAKbeCWL/NSmBFWHiSP1qP/aE81MEcWAt4iu8O6U5Gl1I/8UQG8CN7xPk9Q/aX9iqFfz8P46988jdTC5eaQcZmJ9/VAsfP+N4ifCPNs+vAx+d+4gKij0jhdL8HqSpluh/Z3b1v4SIkQjW4uB5PeOCkpq/GV6TVJ+HdSIBeCO3rQLmr+/XjxzIXLfGE5GXl7qmm/G3Z/7DLrVfhiPyq9gh1KQuoA3ch5ZInx+Hwa9B2O/LkxWB0T5iS8kYYVVfkjq5ytx4VbdcKSqJYLopyur5ETAIQWC3OJ34/SL+LxLF5dlOrAEJVTI83YskxiZig1MeaDn1R7eTJ3Ex89nUTfxR0inS3ni7zlcUlLoak8rXnAH+WrBMeQeeMFdWCGi3f8BB1l1kREmJzvrXXlD0ketK3a20hB3WpQLQ7recKh2n8LhmwpqjqXaFJ4BnIJdgcjf4Uy9+vVSQT9o4E25Li2ZdmnvOdddsEzVPv3tREcqZ4BVu6GDlYduK8t2KWnO9F6Cs8enGUwDjfKyDd73mNExQZb4ilA3hsybj/0ov2lBUaJBrdFporEdr5HfSgxxBG3ILZV65vPMzRVOzg/GK1031Ox
 5MDIOkaj
 tC69HcFrgWt4Tm0oGD4hN1nxmHtOZVpzfFz0Sn9m8jE5h64UdxZuNgFOxxucR3OjAw6uZHz4sffzHSA6p4USZNSYGcOLXYpsUR066f8r7qf78nbkH/i/4VDGnsxamVTm8tezs7WxUtxflon6OttbZodce0+8SKbcKc/qBRuxQIzCwgTRhK6zGSWj+AAizdbRpm8cL3WqkQMvOwXTxXhgxvk1Dl9SsA57j1vE2q7LCIX2yoLtsf7Giu8ylgBWxH/W/m9iH1ysFXjKKcwix1vy+IOWnpuVQv2zfkI9SwAJTNgZy+GSCwqHKfT+nzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 04:15:44PM -0800, Dave Hansen wrote:
> On 11/3/26 15:41, Ababneh, Ehab wrote:
> > I would appreciate your thoughts on how we might achieve a similar
> > performance improvement without increasing the number of kswapd
> > threads.
> 
> It also just plain doesn't seem like folks are very interested in
> optimizations in this area at the moment. Feedback that's basically, "go
> optimize something else" would also be very welcome.

Hi Ehab and Dave,

My appologies for late response. I have not gotten the chance to look
deeper into the series as I am stuck in something else but I am very
much interested in this (line of) work.

I have discussed with Johannes about multithreaded kswapds but the
motivation is more about scaling kswapd threads corresponding to the
number of cores on the node. We are getting CPU with hundred of cores per
numa code and kswapd is already too late or slow to keep up with
allocations happening on all of those cores. So, I definitely think we
need multiple workers doing the background reclaim.

Please give me sometime, I will organize my thoughts on how we should
aim to tackle this challenge. I will also ask Johannes to provide his
take on the issue.

Thanks for pushing this work.
Shakeel

