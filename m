Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A49FC44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 16:39:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AEDF6B0088; Fri, 10 Jul 2026 12:39:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 085C46B0092; Fri, 10 Jul 2026 12:39:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB8BE6B0093; Fri, 10 Jul 2026 12:39:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C69A56B008C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:39:12 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4D1D540324
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:39:12 +0000 (UTC)
X-FDA: 84973426944.26.A134181
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7A23512000A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:39:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=VKQYj3Ct;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.180 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783701550;
	b=4ViEEHaQk8FPKFlnIz1fU7i9kw1++wh2IOzUBQtMCwwTtpvrjQKxMTSTL9VDLt7bz7nXSh
	UTjiJTt/UXZSUp8dgJS5giDT+qAG3QcaZ4TCdrhWI28zln6kWeX1ZbgtX88sqlYiF/5hxa
	VVmi5ZedTeT9jgqpIjU9eVO8dFJmP98=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=VKQYj3Ct;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.180 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783701550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pz9Az2A5A+eQsiowkEP3oUH5xkba/HyvmJjmLQ4f6yE=;
	b=PAAlKLB0e3rC5JMHjk8OYcqdnpH778IHwlRXSGRNRnid08sqvoRfiaJWS+ARxnVAOOA3Tb
	T2zzF++heaW/6uSV7Ff7ZVYXDcTZ1MUlGQ4wGfiWHwJNmyEJYqy0bIZDT/Sf/ezNutt1fU
	bYU24wab7VwCaQKa5bRVnHsXpHNtFPg=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-92e67555e24so58194685a.3
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1783701549; x=1784306349; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Pz9Az2A5A+eQsiowkEP3oUH5xkba/HyvmJjmLQ4f6yE=;
        b=VKQYj3CthkBz7KUlu7shicmQtN6mC62p3gGs1l4NZfyAaB75+eEp+Vy6XYtsXrG4u3
         3IKxJlmB7B4xXu1JiY9hNJCzaJ5E+9S0TN3UIlv/ITPsvNVTOg2h9Ty8Y7tu+qBTzj6z
         /Dl3Fgm7tNUJQ7a/n216MaIgCJwInH+v95FV7Rm8pokBbVxuLdstgFN0iL1qJQ4v0RBe
         p7FhnDeYnR/i3b0ay5G1bRdzpKNSl7qt/HU7vcxiCb44PmpZCvbg5xHJLyqXzkyZgF/s
         fNPs6ejPkobmCTsCmgk1J69bNAJZkY0zic+HN26dWXdsqafxw5brvj0cYvDVn5gmYeP5
         fJPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783701549; x=1784306349;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Pz9Az2A5A+eQsiowkEP3oUH5xkba/HyvmJjmLQ4f6yE=;
        b=kEWVPzWucCYiLI1aNB+Rx7qZfgUYADX3Vh+FBMOS8vrSW11193mfI0JXs4+lxJpLb2
         llZasppr7QrCyUIZwf/hdpg1a1M2gGUSoC5EvaT7Cl/8ZVFcGlDjrRHWy5RDk5d3EhFq
         jNLmVdJ4CI8RscJ+mloJIa93CFH7YLOiXzWDeJqdUufzJyKA6bYsVYNd1Ar5vKsMhw7s
         0c79w2ednazuSdBZxzqnSETRuQqWSfF0mzFyjAvIah1t0ruBM8QCP537dBXsuPUtKfa1
         3xF/61uyiw0AhOzNV7+0ZnqtM0OOh/Z1XIyxgzlHjs39LhfBQjj4iXJYKpHmDEJ/oOVX
         bUCA==
X-Forwarded-Encrypted: i=1; AHgh+RrZ2HMA2Vg4jpHCoL24ADU0IU3OgKDUbl4f0pLejOJGuhOEoUFcvQr2JzFsjCS7EgDLaUyCLqE/1Q==@kvack.org
X-Gm-Message-State: AOJu0YxY0Bj2LCudh4eRHyoN3PzjWeTdcZnm6x9jSBilN+NkgXmSSU3I
	5e9O4QO9mcIftU3uu2eFzUyzkMhzhRzKBgH4PKu5W2LdxqzL26rHg2kOZsjM7S7thxo=
X-Gm-Gg: AfdE7cmE+gPjH8YSrw/g32eIUqksRZdjXGu4GFfohyFIeZbTEqB/BjvDjCDXwC5+/s1
	SrzyFz4MUdN+Bz+dCuwOg9y8aLXM9xGLGh30KbpRMjwsnpOWlbdO+I6Vnbeo9uDxLXc3P9RdHrl
	4Ufsl6WoB37SOSs4gjro64Q9klbX4dMjydC7X/K4HenngM/aW1rstEpjlstWAp/oAnIkPXPlYxN
	NVRSDTnuBDAz3K5QkGxfYpcHD7LoOshG1Xn0kXFH7RgA/G3d3eyAtITnylMhZ6q3AxM1na+Mk8e
	+uzLbBHHRr/7QqIvKLg4xLPX1iZJQvaAx2KNJv8kl1eTl5juot8zK9TFtXMdD3Fac89WJIM2RTV
	KLB6HOR6YacmY+qYEq9P5+Naouhnzx+hd+VIog79B+AhWMkrY2PdiZVmX0K70
X-Received: by 2002:a05:620a:2842:b0:92e:44eb:1e7a with SMTP id af79cd13be357-92ecf5f0e37mr1356630085a.29.1783701549520;
        Fri, 10 Jul 2026 09:39:09 -0700 (PDT)
Received: from ziepe.ca ([159.2.72.92])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5bcb074sm235123285a.21.2026.07.10.09.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 09:39:08 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wiEFo-00000007YRj-1Qzt;
	Fri, 10 Jul 2026 13:39:08 -0300
Date: Fri, 10 Jul 2026 13:39:08 -0300
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
Subject: Re: [PATCH v7 4/8] mshv: Use hmm_range_fault_unlocked_timeout() for
 region faults
Message-ID: <20260710163908.GS118978@ziepe.ca>
References: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
 <178345363584.660027.14063544694872741718.stgit@skinsburskii>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178345363584.660027.14063544694872741718.stgit@skinsburskii>
X-Rspamd-Queue-Id: 7A23512000A
X-Rspam-User: 
X-Stat-Signature: ys96oz6gy6updiyiuz5m9xmdek5hdmrg
X-Rspamd-Server: rspam03
X-HE-Tag: 1783701550-783875
X-HE-Meta: U2FsdGVkX19inuQtgr6ApKzOzFilR77wyOB6/U1ekogKKP4p8XT4BOA2jOpfd1oF3hdme+ycFTPO49BHmnBewCP/PzoqHS8nXQkkiGK+wbLxL2MdeAxGBp30R/2pakTxekSFt92O9mUN6666iy0ai2U3CSOduExwdWlP7KWBuR7PTyIqpYAnUqrasLg8MLGHroiYj0cBFCoyMioEl5OldSBBI1IqbADLd+ymcE+PzCfXg9ZIbCbApjQUAv71u3n4YzF0As5vW0/YPG77JGQoCtwwh/elWhRw/gsNhocW91h5DfeR4ax7qvP2mWM6LqhA3N+RDti7OVxZ4kmyqfkVCM+jXNWj1+gVKwMhfP4CmeJelSLD/+72Er7aE9/+OrqeD3ugamoWesg6KHnuBC2skCVtiBzQyygYLv2PIJHf1Trh0aH1tUOOjN8M8ElfsObqQLb1nIFQ69wnNiKBJk2g2VukHtpukllfU3Lv8JxwN61bUiGr8Vi+IJtz1L9ZEsPye3OVOj/jqz7Cnn+vNN+lWi5wjjWg5hFzUqJ61oySpzBZIyLioKhZ/xA442iDCoAgSJnabTVYTsh4Fshn/KH2xgyelETzNCk5Q+gyknANVjQfH9hCt9BoImKrGmyVhFbDCfynsvDhwHP8wxjjOt8HUp8vxWoHPRNIYrwuUCW9dZ1FgtKE3KSiLumnzD1lo8WZF6VnAfaU9Ly38NG/TIOl6ZbYWzAOuYMSVrxHoZgOwf2LKJgt7/xKBu9Ybgt5rgnhjmk0o494HxFNA4y5B2zs4+tdg+hKlGVc9kCXP1GaJVEd9ArZQVuhJtkeKuFCIsc7wb1iLtLgIV4ttJrqtnG2H+W7I3OYx9mxc2g6N8xVb0ktkwhNQwLZmEfzuHKDzNAFj8vq3zNcmAmuP9YFADGGC2fUBPKFTIV0EGEITxVK0B1FpdaYLqPPYwl+DuzZw7/K4cFQLMKM77EFM/0PPzb
 pAI+xQOS
 +uCE+r1Z1fwsKv0Fb7OVX9mf33Wd7RPHd9vhIbgTi3mIKMbvg/QTZPGPdAOTbF5ce6zr+pK6HFDL9haPMP74Jct72hUYZ1NwuP+20UY1UVof4eAhNYf7RYwkQN3XwA19uUOsNN3ynG8hKMB6LHT/j77I3U//5TL+DMJND8cqObqq6pa/qd+6xNnu1+v2cyuB4kN9DQ4ei07Vpx9RpXmGMhlCMP14Xfs2FG/cxBO+TfDOmw6lf0C2chJ/lVRUTJlKv9La4GvKuLy+5eOM2HSisDJTzYMmzls/T5qPt7AghPZyrs9mQxFoBw2pgChakDMECgtDa7DFdYtsuNA67Uu9gw6hqzD+Zd72tKlTbjKBQ5Hhx0kj6+kfWPHS56/NYgp7W8XXu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 12:47:15PM -0700, Stanislav Kinsburskii wrote:
> MSHV currently faults movable memory regions by taking mmap_read_lock()
> around hmm_range_fault(). That prevents the fault path from handling VMAs
> whose fault handlers need to drop mmap_lock, such as userfaultfd-backed
> mappings.
> 
> Use hmm_range_fault_unlocked_timeout() instead. Passing a timeout of 0
> preserves MSHV's existing unbounded retry behavior while letting the HMM
> helper own mmap_lock acquisition and refresh range->notifier_seq internally
> before walking the range. After the fault succeeds, MSHV still takes
> mreg_mutex and checks mmu_interval_read_retry() before installing the pages
> into the region, so the existing invalidation synchronization is preserved.
> 
> Fold the small fault-and-lock helper into mshv_region_range_fault(), since
> the remaining retry path is just the standard "fault, take the driver lock,
> check the interval notifier sequence" pattern.
> 
> Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
> ---
>  drivers/hv/mshv_regions.c |   54 ++++++++-------------------------------------
>  1 file changed, 10 insertions(+), 44 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

