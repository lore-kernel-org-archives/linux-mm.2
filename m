Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31F3EC61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 16:40:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3D656B008C; Sun, 30 Aug 2026 12:40:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEE966B0092; Sun, 30 Aug 2026 12:40:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDC836B0095; Sun, 30 Aug 2026 12:40:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B60C76B008C
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 12:40:05 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3B65A1C1CAC
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 16:40:05 +0000 (UTC)
X-FDA: 85158497970.24.43B6131
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6EB4D1C0007
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 16:40:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=s9V0EXm9;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788108003;
	b=ZF4llEWbirhbm74lUq/y4jeGRJdqSh8HPcKypj2ssuk4K+2g7bRSTTeGiYdvJnOt3ZF2/E
	/fawN5XXXxt2kRyKIyiRvzbdxOnmxMq079JhxDkWGAYS0T1hhGx1q85K6ww5mJ1Y3/2oS+
	4ut6RwBU3RQXrXJXvSIMWPN6+hdjOA8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=s9V0EXm9;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788108003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PokV92Wfh1ph78+DVYXuDrVLqAtkUu6EZ7/DX6OOMHg=;
	b=Xe19+1m2Uzlp10CktIoBra3HbAbrPHKkTVeoWw3L+tceCPJoySQhaU4vZ4JcQcNg5atMjb
	lvo1vKjcaYCn4kQQWZoRId+7mxMyyAJt7+ZGHXPs1fFFJ69Uw7R7cmipxj4T9t90eCbLYB
	iJLve1wNwfiSDGWiPPdXavJ7XGT6pMU=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-92ea24a2dbfso273349285a.0
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 09:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788108002; x=1788712802; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PokV92Wfh1ph78+DVYXuDrVLqAtkUu6EZ7/DX6OOMHg=;
        b=s9V0EXm9BdzoqIVY7YILZ25NFJ3NDGkc+z303lq+IiomDYMFfYrLKmS8kwEPipUrXv
         tjJrLiGq/LkGlaYsO2+01qv9jaYjJ7TzMPWQ71RRTHn+h+Dy7V7wuV92EpYvxaNvZZV1
         UzHTuKwCwoJ0jaVB0GYikCzcrcZGqeVdh03/ydsdSknBlWhJ7o1oMaNOIty6N1vkdKty
         2NTHx1C7b3eS3cooHOVH2rF9VyDIEFd8qVtIyuODG7K4hJr7IFWXuIkXwIsaQzWYTTQf
         MTGpYxLXuik7ZYvhbks5KOa+b/7wxzylkVVrDdKHKaj+2X2Ic4PQ4YHNbsMEa07Z8mAC
         B/Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788108002; x=1788712802;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PokV92Wfh1ph78+DVYXuDrVLqAtkUu6EZ7/DX6OOMHg=;
        b=T6rqHawYvULScanBlBcVNSw2e6x9egT5DUlzsOoTi5pQF5vdBQjeiRJ5vxzSqbnD8N
         E9Y3Yxuke35FVj70sYgWfEqkG0mvRSqstigB25/2CdcmGe6I1jiRYngIOJTQz2J6iZ2o
         6vps+L+MQ1hD9Q+5FPH/WmLcJMOy6WQGmYHbqXXaeLTcoZBND+l+AXBuD9qvoLCvLrJQ
         Qoe5mKaG3YvmZ90C2lQ/JKOtrxZiaFF2UnAtlw6Xt9FQiYzNAIUzD/JS96KhNOnFvYkV
         MJlvH3V4goP4TCyNCyRLAVBcqBS6vXlNI2YMBEGvkbye86dGwv0dwCOdXiOhXLwIa1Bi
         WokQ==
X-Gm-Message-State: AFuF++nmMglj3Hp4ptyLM3gb4IlYZ4kiIorhMs6gWDA3GRs2mFx0r1yJ
	Hs+m2d+VQ0chm3mLoNh5IXXljRczo6uUqo0FPvIuLL+1MBnjPnglL0o2NRsgNhFvog4=
X-Gm-Gg: AR+sD10fMRNwJyTSXIHU6QAeJyi/aHgXULXNko3dzrMjviqevxzFTTj9lSybcQ/qWc9
	uLDY+d1K7PtnCHm2aF2ydglliBRDHJO9gmu+QOyrlILARrmiUUwwkCgpYVNlRwb/20lwamVvOyw
	j51yg0Z3sntDXLGNynU2DHE0QwRIh3CBKHRfrudrAUnXPaheDiPMC9x8eJ8DSF2xZL6TqY5a5me
	UVzlA2vlSpfl/hIqFQdE/7QvhjtKzQ4YvLVXDFNb63P59bk7vnEZ+9JxaIx+aocfcTKEYFooty+
	DiNDYewFeI2Jl3dSEuWWw6zvK2puqb6cKBq3UV2vGKv1JqNYa9FyLV3ClDlwiQ/oGjryf3DSK+c
	bn0CyJ0Oc97y0dsEFldWgDi1ykVxKl9rdG6XVUOuFIPM2N4y4uDeMUA44EiDQP58hynGIsDHJsA
	tsdI7fhTQwXdHSLBRKccWWoY54Zc3unb9QdyIq2WvLuWuWa3YMuTf+tZ8O8WaOvjhNaU1KPO5A8
	1KxTFINjKgDS7QT8bQxT6m4VbwESlmOrHHiRMTYloL+
X-Received: by 2002:a05:620a:5235:b0:937:5298:7820 with SMTP id af79cd13be357-939137b5b95mr2035043285a.8.1788108002384;
        Sun, 30 Aug 2026 09:40:02 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9391725f916sm605301085a.20.2026.08.30.09.40.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 09:40:01 -0700 (PDT)
Date: Sun, 30 Aug 2026 12:39:59 -0400
From: Gregory Price <gourry@gourry.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	david@kernel.org, ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, urezki@gmail.com, chenwandun@huawei.com
Subject: Re: [PATCH 0/2] mm/mempolicy: stop copying state in the interleave
 paths
Message-ID: <apRczHobjsdUTChR@gourry-fedora-PF4VCD3F>
References: <20260829015943.1258774-1-gourry@gourry.net>
 <20260829161850.db162f9f99deb419f4700c11@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260829161850.db162f9f99deb419f4700c11@linux-foundation.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6EB4D1C0007
X-Stat-Signature: pxzzk3oxq63irz98rg8etjhkaudbt8ag
X-Rspam-User: 
X-HE-Tag: 1788108003-488143
X-HE-Meta: U2FsdGVkX1831kq/k5pSKM0mUyr1pvFOlTKgxiaaw9e2lEwyANopjc96K8ph58OuUy3mmr8jDd1L8J4Z0s7SQHTYIoB5josHDVpNLjYTZYAbTFsl4FE2oDCx2KGG77AU16phnDBGIqMktPwi9+RvcWGlGC4FiZEp1ROrWDPwbG1ONa6zC7YSLRrLWxyjpLOmgy+UGpm4GeQ0rPeRup4caKMf3DshZKGZH4Y6xyVaieLigTB+lXtslzUTDGFVlcRscm3ChAXvIiAGVv/rCui3uj+/GT95883ElCj6Z8gx+jbG7gfpD+fTRQoNOAMHLCSuXQl6xPZ/V43dhQel1xHCvTUf+mOatZOuPCih4SDM6NH0ZhewW+7gD09BOkP96dOVkbfu4GqenxmiriLIq8zWRJ75oDlpcC7GTlXpygIE+s2BFqroOfcCfinMg1M0b865MrrSvre4fZHPMvA7yPdt3ec7YlYHgBjMy3zB95fyjnkBauhQPPYDV8No5PNjyLZbbsrvQ30B2MseSFKqOmpIoLlaX+ctyj736P+zf0JQpdKNqwRS/Pged0hnbnsNQir6zWSc9moSzsaS6lsx0Zx2c0TsZqx23T86YD5LxLkuo3n6N2WCYbjIQ4YIGyLWx7BlwPoBFdqo0cJCztCBzyZHiC9a83PBAl0TlWD8h7/Z5/MFw4YAzOqoqreQS5Xkb0U3c5dbImmPEAkzffoedNC6bXoe2YK/RwQtXsL0ma24/01QZLdVbJDi4v2hxEHFjRdKtkaUODtTf2QAdsaDoiycVWaP8VnlDm5sSCBieWqLLtsQ8+n8iTVKnTPgnZjU/cMLOD+uMWF3djOseLSR0AXIAeFciu0Nq4gXe7cUrZIgyIu08WG5RcJlrVhY7Z47F9Geu4J+p5a1hJTXrq7wwc97pSAuBYsSl9XJsc1RFBbbwV0KUfSnbIHh6zeC3nfySWVwc5JntJjE4f0gjIPxaRD
 vocMkzYE
 mlp3iLFnU0DmqvTjFw2DJdxlludX40qCdzuAjAo/w5mFyyQc07b0mv9/CfpCBIHiGIi79+yVxy9q9jflL1ymU89UqF7OVWbpgKwhswV682zn81II6tl3Y3JXbGvQOzCVNTJeMlkJqQYYtZ09gl4b0dgtz/uL8ck3VX0Qwd4AhohuSoPYKJWWsqLecApjjsm+b15Z87VHAmYGLM9m0QHUxAGYGS2oZp8NXp7s+q99n4zHVRltb3Uwc0DIH986tm9HLP1S4p4t7/O7ilg/rE7qlU59MzpVOiyTK3M3CGykvDVUvXj1xSaUKR/GnaO7SxJ9LqmH5wEHyk24KZ2D8zfATezaIX+xCRE4tqkdTmFdbPQ6/byINeIf9Yug4P4h6oMwqEKT127AQlgurv+UNVKnCVJeLDKZ1KiNxZc3CKRzat1ZSjJKag+62HjasTC4CoFXtq7li7FDldttb93yaKtIZxuNfaSRmqDC4rxYL7k4vTI0MjukLMVe5iULGQFNHtYaayHV3XtT0+V3DP9Y15TxFPlueVzHXDSYQUBVG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 29, 2026 at 04:18:50PM -0700, Andrew Morton wrote:
> On Fri, 28 Aug 2026 21:59:41 -0400 Gregory Price <gourry@gourry.net> wrote:
> 
> > The interleave node selectors and bulk allocators take copies of
> > nodemasks and node weights (for weighted interleave) in the fault path.
> > Both of these copies can be entirely eliminated.
> > 
> > For node weights, use SRCU to pin the weights in place.  This eliminates
> > a copy and a kmalloc from the bulk allocator path.
> > 
> > For nodemasks, we can operate directly on pol->nodes as long as we bounds
> > check the walk.  A concurrent rebind can shrink the mask, or tear the read
> > of it so the mask appears empty.
> > 
> >  - The interleave node selectors fall back to numa_node_id() when that
> >    happens, which is what they already did when a copy came back empty.
> > 
> >  - The bulk allocator simply returns what it managed to allocate.
> > 
> > The node count and weight totals are read separately from the nodemask
> > walk that consumes them - creating a time-of-check / time-of-use race.
> > Just clamp the walk to a single pass (number of nodes), and clamp each
> > bulk allocation chunk to the space left in the request.
> > 
> > The cost is distribution accuracy during a rebind.  The copies never
> > corrected for that either - they only kept the code from dividing by
> > zero and overrunning the allocation request.
> 
> Not very well, it seems.  Sashiko thinks there's a div-by-zero in
> alloc_pages_bulk_interleave().
> 
> 	https://sashiko.dev/#/patchset/20260829015943.1258774-1-gourry@gourry.net
> 

That's what this was for :]

https://lore.kernel.org/linux-mm/20260828193111.1023497-1-gourry@gourry.net/

~Gregory

