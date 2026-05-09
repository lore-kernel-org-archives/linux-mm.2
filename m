Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05460CD37B6
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 00:04:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C4206B02C2; Fri,  8 May 2026 20:04:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39C1F6B02C3; Fri,  8 May 2026 20:04:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D9346B02C4; Fri,  8 May 2026 20:04:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C4D96B02C2
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:04:01 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BE0AA14041B
	for <linux-mm@kvack.org>; Sat,  9 May 2026 00:04:00 +0000 (UTC)
X-FDA: 84745933440.11.BCE8A3A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id DB10CA000A
	for <linux-mm@kvack.org>; Sat,  9 May 2026 00:03:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=H9flbxHX;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778285039; a=rsa-sha256;
	cv=none;
	b=ZsTUV6nNS5OPocky1nT+LuR9AWp8Y2jsWcDGvPhTQESxDc1ZDIGg+/laQJ36pBsBcbryNx
	gMJmDVhGyqH1RTNhZGQAnExUfRS0wjS4qiNK+UyWNE0aN3STwipu0Qd9A2n1PM4tHLRnUz
	OvIzCgrEMIomEs/fv/KY2RP4m7TToGE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=H9flbxHX;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778285039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7KhD5DYD+wI0JFYkU+2Yqol6EI+jwRVkNLAnC38UmIs=;
	b=0mhPRc5OOAwTWWfWAtYltNE5We8Lpgb3aTloxou8WF5ocLps6QuXEmASr/UsWvgnIasXOy
	gWpZu6iyiZ613XymJwtru9/kM4eMoPk3mT54W/z9vrB7GaXZswUIWknbr4Tqt2ov/zLDi2
	2Ca7Co+nB8Yb3BP9eDe1Q/G2JQ5sNaA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 67CAE40335;
	Sat,  9 May 2026 00:03:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DAFCC2BCB0;
	Sat,  9 May 2026 00:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778285037;
	bh=P/Qen/p/hgzkZSMrVAIJYJsw5zswEedUGvCpzhK6ymo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=H9flbxHXrEiDkVopyYa4xIdghiK8TmpfU6i1slZ+6t3//7lG0RLJyE0Ggb243jzAP
	 Q0ToYutOYWdxnwgUiNIwQrwO++m18C1cAyGU1fpDQeett9U53Ztruyc75QQhzd51+k
	 2i8J3N96mwZgl833Eeq8lABs0LcNWFBwFkdJ0kaA=
Date: Fri, 8 May 2026 17:03:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Brost <matthew.brost@intel.com>
Cc: intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org, Dave
 Chinner <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>, Roman
 Gushchin <roman.gushchin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Tvrtko
 Ursulin <tvrtko.ursulin@igalia.com>, Thomas =?ISO-8859-1?Q?Hellstr=F6m?=
 <thomas.hellstrom@linux.intel.com>, Carlos Santa <carlos.santa@intel.com>,
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>,
 Matthew Auld <matthew.auld@intel.com>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Daniel Colascione <dancol@dancol.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/5] mm, drm/ttm, drm/xe: Avoid reclaim/eviction
 loops under fragmentation
Message-Id: <20260508170355.c937b91cdd63a11e56d2225d@linux-foundation.org>
In-Reply-To: <20260506033300.3534883-1-matthew.brost@intel.com>
References: <20260506033300.3534883-1-matthew.brost@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: a39keb55zfdtmngqiccszzs7uthg73ra
X-Rspam-User: 
X-Rspamd-Queue-Id: DB10CA000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1778285038-349688
X-HE-Meta: U2FsdGVkX18pE2ljwQ+wbAFW0Pz5ic4inPD0sOb+x4m9vryZLKf8ILrMAxK/iuKTt2cP/UjPrtUNziwtVgi1u9SNPn+WOsR2L/B2bkVAo2xwR9rXeZKMypaNNkiaPlNbT+2RCqELHGjrE0AA7x6y6YK9TEwmElBen7aQbeBqRCwa04IUH0AzzrWG6gmosbpDpnp20vfQqM7gjmGrVJGORXdNOn6poYxfTMan/I1vmwhUwQ6ppg1aSQdYaiBZSWnGPzi4lpu9aepH0V3F0WE3e/L7fRdeZU1UKVCuRqAwPy1iAc/UGXWu5z4EuJXC8J1zYwmyNuYTueYePh8dR7ojNkQrXLtwwjGT2hy+2wkDWm0CgRADC5ltLM+FwVabXiFsuiqcgsuJ7ldrnq8hjXytt9nTNU/U/x2PgUpMxYpBHvIGI3NLWTwZPCFTn+KiVYbKKBk04v9CPths62f5aPyb0jjOCTbVYLfvpeLr8h0ql6QEbRAMYSz1I5KZRhJqRmnQOt8sEhu379h7HcKAAL2pLyEuYGLsLQ4yUNIKX2AL60rU2NOfs0XdisE2l0I4xfadGT3MzwQzA0r2vds2qTdoIaD7OpwjBOPSfMxo8E+XOHXSYCu0MMt4rzaPg2on6wFXKbF//BaBQvUTZyAJpGz14XzXQDwiG6f0DeEl/z1h3hxoIr4rLB/P3tGroGR0hyR3KqIt4Wb7tX9WEbYQ/ZtrqodndRB9tVscfnzu/6mMR9gacnRJWCm2JoqpOwbRVieePQnixLrRDuiQD5NfSs7dTDFk1+lWkH5D9/cShjkcu9M81VjUwqoA6NOZEOJGIC7oxvBYWa8nDnwsWVa2cIyVW+1tCa3dns10R0CUo6vUl53Z/eY1cJIFoUwosqxkutVMSYaxRSBYXTsFP6Jtoo0k0w50ZQyjsQwUz9+XqoQTym+c+bhg46epZWWy+FszfOu34IrrvUrToKPoiHoqxHH
 Skh11G+S
 w8umg1wadMlRNU5WHOba8+QDMi7Z92HB8eJNmU7LqMB+7CMS60Pjp5iPZferm3euw5n/PY84JFa0++9aWsXz7diR9FBcXYA81xYZjNVblCdq4vQxFfsI1Zc94p/gcBfSUsuK4tkxVDlZJCna+E8Nhihvb+Cl0UfI+8602YddM+CbsnmYRarVuxbw/BPo0C2be8IUY5IBnxeMkxOQ4hxTmhnX2wTeWHaSwx3Ws5hT8cZ7hKJpTXf45bc2aNUdKAST1np3xsSm8QlZ567ytNs0di7QENSD3LjbgqkY+PU3Gmfe/qf8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  5 May 2026 20:32:55 -0700 Matthew Brost <matthew.brost@intel.com> wrote:

> TTM allocations at higher orders can drive Xe into a pathological
> reclaim loop when memory is fragmented:
> 
> ...
> 
> This series addresses the issue in three layers:

Thanks.  AI review asked a few things, nothing looked very serious to
my eye:

	https://sashiko.dev/#/patchset/20260506033300.3534883-1-matthew.brost@intel.com

