Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97A5DC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 16:43:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91CBE6B008C; Fri, 10 Jul 2026 12:43:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F4A06B0092; Fri, 10 Jul 2026 12:43:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BD696B0093; Fri, 10 Jul 2026 12:43:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5608F6B008C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:43:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CED641A0460
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:43:49 +0000 (UTC)
X-FDA: 84973438578.02.240DABB
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf26.hostedemail.com (Postfix) with ESMTP id F06B8140014
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:43:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=InTqDJsz;
	spf=pass (imf26.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.170 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783701828;
	b=msJ4DfTjTcXJfiDQKBIqUYc98qBF4Yhdo68DAB0yce8m62b7s+hahzEmc2aZ5/BF6wA8Mw
	56nsd0SvANPKGnab7+lb7cQYOwNicsdLto6GEngA7DZZswXeR6Up3c6aXIkFfZZK+BGssL
	CGBz6O5WvZ4AaBCcODdxTd3UKVybu9A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=InTqDJsz;
	spf=pass (imf26.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.170 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783701828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WXM4slhr2CFKJAVwVD2VemgO6fJY6jlNQ4kyqua9fHY=;
	b=VtCuvHE3xSMWeULpPijCEq0VM/SRRDpe1oK3kR/fYvUmxu1iIlgzwi5e2X3RXwo1wvbErD
	5lvGxs+GqpMuRhfUJImEutpx8AY672AYncdKF8yxbQOxuL5Uekzhxm1FDpuF1v5y8x+B+B
	JSwkBKZvKA3wiC3j5jM1r5Lo21jUIEk=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-92e53581361so62425485a.1
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1783701827; x=1784306627; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WXM4slhr2CFKJAVwVD2VemgO6fJY6jlNQ4kyqua9fHY=;
        b=InTqDJsz6udzMGowSEsyD50KXe7G7kkyrzmuLOnnwn6+b/0ygE6mwHC+BJSACEJcfR
         7WComJkVuwmCOCD4e1Sqvn6gTUmn4wJ3zTr9Xy5JS2b7bn8mf5+Of+pXyNPiYVN6XsS4
         KShEHRTIwMYcMuE9a6t2RKDQev+qfDiQIlIbawXxr8RYK1aTF/kaTF5RACSz63CGrrhO
         nh7ejMRK2YI02zQb5jHEc3pPF81TSIeeR6XI/8dfR/WbZHYgAk195v1cUcME38lEJcX4
         ivb4rp9zq5g479c5xbzBUfyeyhiPSj+xqIzhVyk58zHkZnpU5l8ywZXDdPPgTQ4A/vYo
         LMfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783701827; x=1784306627;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WXM4slhr2CFKJAVwVD2VemgO6fJY6jlNQ4kyqua9fHY=;
        b=QgiHf/8OA5ME85NRhyxQJ4SaEp9vxTjGGihkBoL8Vfk97YVV7uDl1YwjIuW6APs6V/
         4tBpGw3rz+EWYXv0mF3tz4zpEC4reEUpDAb5r9vs1N+uSdSRVpDOnjUWiHkWsuL7mMGY
         74fTqUwv+1i4i33CmroRFNuADOg07qYpTgKXRyneOPMbaT6WydzpBZr3ijsbYAWFdUHS
         PO+PIBdNaTLfDTdDvBTkQ8xBAlN1sZkbJab2QQ7jAZuIwwIuHnQw9wKli1FQ86TuiNDy
         JM75WALoTsPNnSYK0b097yYdSym+4+kbXy2rAQzX+qGpx+T/lN5HDhamHVAZT5EbQePj
         TIDQ==
X-Forwarded-Encrypted: i=1; AHgh+RoV+w7vi/mUYXmOAFTpu3LbC5HhEl12ikGCOxoYkzjXAPCo7zi1v958RHzWd4Jr/0SqYQCluIYa8A==@kvack.org
X-Gm-Message-State: AOJu0YyogBGltJnJ6SVxZ7tTIEnzSz33RUY3UJtsWmfd1f+9Crny9qPs
	L7cHO9z8G3uCpXFDh0DYTgfA0xLLZCo+3cI+M/EHjNXvuHS5SRPcd7ufYEmbC9mY6/o=
X-Gm-Gg: AfdE7ckhQYXnL+ZvpyqctNd5Z9T/YUQ3PBa6X5iOscZ+hr8yv+8dpFmyvXx1Fkb+3Mv
	NHjH05DOB16YHSyLsFyWqpewGzpRxUHTvkSyPPi4M4MW7HJLlwv3G6635aep9U8pFh+m6joKE7u
	gd41XiHad5zS6RY3bVEW+yIIassFUX6cQlQ7McH0G8bmRc+k7/QnGovt7rCcOLmCvJfStZ1yfvx
	pzJieqJx8Ufsb4YcY1vdjMXAwtQByvt2PFEGhFH9qFyFXmwzT0JlHAwj+8awA685EHemufwh2GK
	i2GEFZ6DFGGfVcidD6sqyh8v8GCYQchWZRfffSsSQIWCecFTKOH11OMRLqmYqg1eKNAGene8gFt
	9d5wyODRqACQkOiaBcDLMTDEVjlwzGlZ4SrbDlBturfjPwb2347VhToZ7azYxHzx+n0ZRdAY=
X-Received: by 2002:a05:620a:240f:20b0:92e:e569:dc20 with SMTP id af79cd13be357-92ee569e3c8mr347342685a.78.1783701827057;
        Fri, 10 Jul 2026 09:43:47 -0700 (PDT)
Received: from ziepe.ca ([159.2.72.92])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee59223e7sm237517985a.0.2026.07.10.09.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 09:43:46 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wiEKH-00000007YpZ-3qzk;
	Fri, 10 Jul 2026 13:43:45 -0300
Date: Fri, 10 Jul 2026 13:43:45 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
	corbet@lwn.net, dakr@kernel.org, david@kernel.org,
	decui@microsoft.com, haiyangz@microsoft.com, kees@kernel.org,
	kys@microsoft.com, leon@kernel.org, liam@infradead.org,
	lizhi.hou@amd.com, ljs@kernel.org, longli@microsoft.com,
	lyude@redhat.com, maarten.lankhorst@linux.intel.com,
	mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
	nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
	rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
	skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
	vbabka@kernel.org, wei.liu@kernel.org,
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v7 7/8] accel/amdxdna: Use
 hmm_range_fault_unlocked_timeout() for range population
Message-ID: <20260710164345.GV118978@ziepe.ca>
References: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
 <178345365679.660027.16671418103486907555.stgit@skinsburskii>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178345365679.660027.16671418103486907555.stgit@skinsburskii>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F06B8140014
X-Stat-Signature: nosdfzsha4ku6rhjc9hougbi6idhp3io
X-HE-Tag: 1783701827-589000
X-HE-Meta: U2FsdGVkX1//frxt6967jVS2bHidQy8EpXODzEvdGfSyzgQVdYSIjnqyYq8/zRTwsq49cjQmUKrgGFKpeJUWOJfv25W84ws9NcBZoSpD2rjg8jSvj9K5yvDk+HU/RUv7X36QNDTdPEpsFeRzJbHYGpcsMpU61+AYVL/9J0hzBJb2MnO5GGjhsI3vPNzFv4httts20SgnIVmDyaADCvxw1yHb5O8wdG87+W5wIWT6l+Vm426ah9CrLFfKuX8LWBQlFDzAee3dgU+sa+LUAJPsoLRVUMR0sz45QSWxxNZZnlY4oFuk+NKFYvEVjEsmvKQ1Sh6eSFXJVv3nMGZNdQHfSCcgcKaQSWARASqjt3Gokgtotm+JYTwvYAs1ObwKVamfxdkGPKqXaCVRvoW7++rBFky1AO+DGJrach6XkE8frjtcJuf+rz9f48r6iS5sRqWpXYllTaTp0UngChBia7fgNeStPyCtqyzt73furjIYxxOZy4ZpaqOxXukRyiGIdybzgxDgAd45v8gnNUWtWXw8A6NqZyrMQ6lLy5y32QYeceVqaHVMcqfqcyGSpNpWlU38LKw8rFtwUOqEXNB0Fhezv4uEVZaxPBSQEAlCYdGfKC0loxjbbDsiSjETf2/f+6oAMRWTei8Py84fO3SjUQq2uec+ZKPf5wImhOd1zWTjWbPSvqzZuSvKWattzl3KD6KRhF1g5o4S6A5uCQHCJsAPF3UTCq8TsZ+fx4JrTAMG3nSR7tGj2kgUL4I+LdgXARZwYQLvdaLVmzoeu+pEc5qO/nDyL5gNfzVVQZvb+fCPHyDFUdLKyc/dWBd5bxoyoySuG2hy8VIU/I9IODvWgg7Yx5f/mUSsF5ee5bSak5Fq0T/6rwprttMtHp3dmw/JelKA9kKa1s02YaRLlhB0YULWtXVuXJw3uybv+eoY10L5oeeRfyVLGLMeVsUWF6zTXSVyQIGqAS2fgKvEPIHUys5
 cNAXlKbk
 zp7Edz9cnwvY+Z7SclnPfKbozo5ygUd1vHO2yIghqDVqBTHIZKEAPDIZDSw+QXJ4mkIQIHBXF01JxeZF10BkLReNVDssHxmotwlRtGfguKWksOj3Rq+n20DeFWL6FvwyhaGzr6Nq2E5+3K9GQ61a4wylbzqHmjJliOEbKmOQrt4K/CUhw4YlGzIs+nC4wCmIFffhT/smWY1Cr5rZE++dgnRgsm80NzQndhLBlBkSfzQp8ColiIzrmpZOqzBdpM0ZFXaR0zk4botUnUKs5njueu48uBokZM9A+iNjg0vM2IJsMBvHWOpD55+mbAtxtdMAwXaJvKO9xisdqli90cr2WESinvjrer9hrA324FHLaMhsSLjleyXehinE5UbreollIEz/4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 12:47:36PM -0700, Stanislav Kinsburskii wrote:
> aie2_populate_range() takes mmap_read_lock() only around hmm_range_fault().
> It keeps a single HMM_RANGE_DEFAULT_TIMEOUT deadline for the populate pass
> and retries -EBUSY until that deadline expires.
> 
> Use hmm_range_fault_unlocked_timeout() instead. The HMM helper now owns
> the mmap lock and refreshes mapp->range.notifier_seq for its internal
> retries. Pass the remaining jiffies from the existing deadline to HMM,
> while preserving the driver's existing outer loop for interval invalidation
> retries and for selecting the next invalid mapping.
> 
> Keep returning -ETIME when the retry budget expires, matching the driver's
> existing timeout error convention.
> 
> Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
> ---
>  drivers/accel/amdxdna/aie2_ctx.c |   17 +++--------------
>  1 file changed, 3 insertions(+), 14 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

