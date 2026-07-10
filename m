Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16BF5C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 16:44:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7A466B008A; Fri, 10 Jul 2026 12:44:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2ABC6B0092; Fri, 10 Jul 2026 12:44:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA7786B0093; Fri, 10 Jul 2026 12:44:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83BBE6B008A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:44:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 02F391C8BD6
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:44:31 +0000 (UTC)
X-FDA: 84973440384.25.6E7D470
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf29.hostedemail.com (Postfix) with ESMTP id 21C7E120008
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:44:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=KukVCWmy;
	spf=pass (imf29.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.181 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783701870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f7jwDOcuUIXFwEJ3t6jZRtuRC5qCtLyV1KSZwcqARY0=;
	b=HRlqHuS1iX3Ikh3TfImjP9ZZvgK9VD/JtlHA3P2t+CLQX+b+hS7+UGqpYIkgBxm/0duT5E
	wJ8rFvZDPZugPey8qGoxikJYPXhe7w5n5pFVVp7i8M/b5RXjAFtDSiOcFBDgoeTtxjvhLW
	ahnHqyv8U+pfqg6VHIjBO7J5DEFlMqo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=KukVCWmy;
	spf=pass (imf29.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.181 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783701870;
	b=Wshzqhhtuqu/d7eElB52xzuzxKXRtaJKpIS1IZnFPu1teh7f8v+BmqeDVNLlY88IU14JTz
	DSKrEpo/mrzgtlnTJrNjT3Lul/q8uvhm/BvB+XEMZsvuNsUmb2bqkjxOUmzw9sX9DE53+B
	RbWcv8p2gDjJ7gi4/PUtan+ysPa9Xjc=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51c22c61795so7682811cf.0
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1783701869; x=1784306669; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f7jwDOcuUIXFwEJ3t6jZRtuRC5qCtLyV1KSZwcqARY0=;
        b=KukVCWmyBwdZ8vRIDgXKnsXZLKr0ddggwnr/oJE3E5F1aXXOYZKX+qwmCb57m42/96
         TqodfRXvQfeOjfsK43zwz3hlmdwr3dfVgvLNq1EPzbvs5tm0TIjFSwoCxAIowlVjwLuI
         wcZ0hQWaPw8atRBHCvoR7PYYuMcZ+SsJynQVLBWRHGMagE160tHy92w3VMD+E17++bF1
         lhcfWkbD/aV9O8K68tV1Cp+xZtAr3FfJygRhTMK/K+CbKJeEZIUCXVF4qSWFVsIVOYkH
         crmrkGjf+AT1IlXrPYiI0oKXGSWXhkoX2l//k/pzInSiajyCfUUXjAUcmwT0mFgsBSp+
         x9ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783701869; x=1784306669;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f7jwDOcuUIXFwEJ3t6jZRtuRC5qCtLyV1KSZwcqARY0=;
        b=igbDrWSQg5Zv46I/qLVN/bhyCNc1nbjogQIlxKfZJBNnyJZ4KgOyBJ5Od6Mxpdn3o2
         KbB91oLnBFcfwY+hPzKPoxdtTZV83uS/xSvfnuEmI+HlCgQzY8afx1UYKFfAW4kt1WE8
         wajWdkFs9q7g1gklPf3X0nNZwfZYMDYbS4iR2/smI3nTtwPxkBrtZfO7WGuXYsWGUcK5
         stSqq4x/iJTdKuh1eMT157w0g6//IOKvo8MXA4/pZUdCb65/Lfb9uDqd63pMqMNmQWTs
         QSAbBnaN7zHPTIGklQBKo+Y/YFyIIdLFxft+LDtvhbcbhPBKVQrAR10lirttK6PDeA+Q
         DGFA==
X-Forwarded-Encrypted: i=1; AHgh+Rqn5j+ZjV8hvE620SEHnGkFywrJsj3pOW6A8CUMUesWPCa9WUjXrExpMlCJIdxlICEZ562S0UyGjQ==@kvack.org
X-Gm-Message-State: AOJu0Yw/dz1mo9PbV5eyI0E+duXl+M7hnUpuPixoTKzokQH7Jk8TgCgM
	z4ChCOcFKwutlI36mqzfj2dI2OV5prxHiCEFFS1U992Q6B7fcUwdcx2snSITDxcFs4U=
X-Gm-Gg: AfdE7cldWr0rgoZUewMcZGeA13NThId4MZ3aT/Wtx5CaPXbIthtsQXK12HX/Rlmmw+X
	d3CBO25BS6OwQaeb8zyBS9sLczmdrHfLcJ8fKV/Pnvq/COY/XSg4EWKX9gBtqjYwNSUHU8zaKta
	WNf88g8VZjDiiD8HcvlUgarxC5eVQiNXaEJxKj3vC4DKiU35mQlEq9vmm0RBMtc8AyRkGOwvI/f
	6T+OqCrdPwiUDr2glLKL0RJ7UXuEjZU6Ry64mbbJXsGGkzvHVDum66/gZu/iNj2H2QrhAlbQ3CP
	7RDhkl/Mny+g5SxcASC+5RzAqbOv9ozTcLgp3i68Zmhb7gVM4Lo/6Hi8SRw2FLeQS6HYfUfN/N4
	Kg2moU2RqsJcYZ2AJcBNYHrmo/e4rRzFwd/d/sEMK9Zhmsn32aEsgZww55Vm7
X-Received: by 2002:a05:622a:96:b0:51c:7b12:5ff5 with SMTP id d75a77b69052e-51c8b43fec2mr132124531cf.81.1783701869227;
        Fri, 10 Jul 2026 09:44:29 -0700 (PDT)
Received: from ziepe.ca ([159.2.72.92])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd56c4b91sm45168766d6.19.2026.07.10.09.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 09:44:28 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wiEKx-00000007Yxj-3wpY;
	Fri, 10 Jul 2026 13:44:27 -0300
Date: Fri, 10 Jul 2026 13:44:27 -0300
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
Subject: Re: [PATCH v7 8/8] drm/gpusvm: Use
 hmm_range_fault_unlocked_timeout() for range faults
Message-ID: <20260710164427.GW118978@ziepe.ca>
References: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
 <178345366389.660027.12986386801605494596.stgit@skinsburskii>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178345366389.660027.12986386801605494596.stgit@skinsburskii>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 21C7E120008
X-Stat-Signature: rfjdocwqi186b1y81jf14a6x5j95b41m
X-HE-Tag: 1783701869-492093
X-HE-Meta: U2FsdGVkX1+Y9EkG7PoO+AYeNE9Biud3FD5IpuNEVd88njkjrEX9Zf9lo6lGu+wI5dTVenUrtTIhdGMUHFbRPClqPz6dGPpB8rR5UDf0smwtVGeyWJE5Wt3nlP7P01HeWUXzN7BIEwv1lonNcT2woMPN7OBLLanO/i/4xPVCaShmaO+QSmbBgm3nrYyZ3pYvRptOR8m1W5sv78qUGy2yVJmib6xfbNU4PO6xdtDxM7VQS1G5FwZfjEDFeIMUJN/c0cbXzTcY7Ji/0eFEh3ejmai/IfF5L5m+WTmjZQ4NB58kzLN0qbt/8jMxtjaeS3hYM17Ihldi+TOepraQSHwpZXo+P9uPYpCx30DDpYkmHAjVNZswf3+wvfHoSKRN8HnQaENa7wPenixnug3mtpatwBjEFxuNd+DJBOe21GHbeVyrIdVRYF2GvarClv/VNeFGtlGMw2tOPO9WGxc+rSsCin0t7mo/jcoIhBBSSn08Sd7J4IHfl9QJEBc0Tfw/nqkGYrXWZU6yEnR6I8rJsENuXXIw1CVfq7vivBQS0Ss2Ak3C2GBSmJwoi+XHPSkcejGtD3qU7Ivr868p/wLE7PBH3DwR+PGdCa6yV1KXk1LiPfqT3BY13aM+UzYvJK6f+lWqa6hrBx51hbvYC2Y4sZkweLpB/BlZKK34dboNHta0tUN/mnm9wXHWJ9ZvygkYt5Ba0QCX958L+yK0flcoeLv2catEMTJ7uSsu1at4iFmOxMmu+cxsKoQPdPjsGYFegdhLH6Gba1W8tHORsbANWm0cEPuf/2pKV0AdX66qXwu5fXnbdsakKc60JaC1ic0nptLHOvRqOBqFfITaVOjWN3hE4hUO37J1b1+n1oXIvy7YBaYaorrzM6gLe8QoANMoWNcFX1wbK3kjNYvEqsML7WNPVHB6M06LBrstwlYNoGJ23QihaI2cFMFd3vmLQS0ZTWTSS50njVBixxokZrelPzO
 r3OH+Ytl
 jmYBDkUbzA76tevdWD5qT+8zO5+zpHUya29NSh5c9ke7AVExQRVU9mhEwS/Si4Mb+SFJQHUqS6QxHLNRm4oli8EMxPASQKmxne+7mWKItDm3UHAVAO5bgBZlZdJCLNaHkiCo/xs3804XOKT6/+76b3qJPGVMtmrbJaeqvGNaKnA30SLPzWP5NIVIv77PrF7ZBlNw0ucmVNvZPAQrDgA8aguS8popfBHre5pWu3vpjtwNXBhTL19t58DiUz2ztMAcYZt5VJa0ALcW1rya5uF8bkz0CXsAgOijWAr0GJoZIgX6LZ1r5M62M22mfH/nnKChpiDXZxfs042ptofvKSphwzlel8ClkgH2U4WpZcMkyIlE6XtnXww4qDVzg63JEfUhnV0jk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 12:47:43PM -0700, Stanislav Kinsburskii wrote:
> Several GPU SVM paths take mmap_read_lock() only to call hmm_range_fault(),
> then retry -EBUSY until HMM_RANGE_DEFAULT_TIMEOUT expires. Those paths use
> MMU interval notifiers whose mm matches the mm that was locked for the HMM
> fault.
> 
> Use hmm_range_fault_unlocked_timeout() for those faults and pass the
> remaining retry budget to HMM. The helper owns mmap_lock acquisition and
> refreshes range->notifier_seq internally for each retry, while GPU SVM
> keeps its existing driver-lock validation with mmu_interval_read_retry()
> after a successful fault.
> 
> Leave drm_gpusvm_check_pages() on hmm_range_fault() because that path is
> called with the mmap lock already held by its caller.
> 
> Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
> ---
>  drivers/gpu/drm/drm_gpusvm.c |   52 ++++++------------------------------------
>  1 file changed, 7 insertions(+), 45 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

> -	mmap_read_unlock(range->gpusvm->mm);
> +	err = hmm_range_fault_unlocked_timeout(&hmm_range,
> +				max_t(long, timeout - jiffies, 1));

Same remark about max_t

Jason

