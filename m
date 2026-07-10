Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FE9CC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 16:41:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1FB96B0005; Fri, 10 Jul 2026 12:41:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF6B56B0088; Fri, 10 Jul 2026 12:41:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D33BE6B008A; Fri, 10 Jul 2026 12:41:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B15106B0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:41:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 31CC21A04DB
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:41:03 +0000 (UTC)
X-FDA: 84973431606.02.D37C7E2
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5DE5B18000E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:41:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=niJSne0r;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.53 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783701661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z7U3THTZDjx6I8tSiQ91l//DDsukKiO5Egsu4KIAjvc=;
	b=gSHrOhQgehg1iCzo3MeJ+K3Od0aKHvW87zFKk+2sngSeRdubmd4N/vWxLojia2rQY/0y0q
	8IixIm3F9TH4cksBY29mDgmoUpMfy3a+a3KGeVnGO5TUXieLM/3IeH7QXaI7rTKje/yaEW
	gnFgCcU2v+eAhlihltZ9Zz32MJ91gJQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=niJSne0r;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.53 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783701661;
	b=IDJ3w2nl882Vw7WEpOd6PuV75+ijZ6wKj41QilWZND41GQOrR7tAxW2qInKLmIxnFWTvgY
	iCCwqp7TggCZ01tOR5EW5RBt901gUJUBbpxgdkfmoy/dBB936NrZj662ekYEHx5R+nxT/t
	t3T1TWLMYTl1Sy1pH/nbNyFpAwwjz5s=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8eeadbc5e21so8909786d6.3
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1783701660; x=1784306460; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=z7U3THTZDjx6I8tSiQ91l//DDsukKiO5Egsu4KIAjvc=;
        b=niJSne0rqri0QmL1tmlfsTvmqVL55XmHzCtyxfWKDLlKaFdrSnvH7B+Jbhyh6fcyqg
         /DWHn++0EDp+c/d9uV9AaMS4uMmuociDl/i/FGiRQ55MKxOdOQhfbbXzcesbfiuc9gC3
         3WaM6QuAOr1C+qwYsNRFsZV2vNab2+0RbCdIF7YtKKUTWHckL7bztyj1Qd0nr3R0dBax
         C/vrOJknRt1EBfLOhNWzxuo92bbhhRt7tpIGub6ktcR4BVaS2KuXFH5NRTGSwv00nrGE
         rfPR9Ufj57HwHhThaa3xIBlRKIgkMFYSMhHTKKzztfcvVDc7v3gitok31c1u9X1HPnMS
         MQ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783701660; x=1784306460;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z7U3THTZDjx6I8tSiQ91l//DDsukKiO5Egsu4KIAjvc=;
        b=HXlRiz8Jl1nyF0dOmrUhHgpvLklBp4R4jWuHtxxc0FEJbVr5cSoTb7egHJVGxTOZK2
         SDXFSo/U6jR1bSQujYmfCQBamgN9bfVxZOoZiMAMUN6IEF0cqhzFATE15YrHSfMsTDOn
         k18PMALGfm6f1jmnxeMMfS+AiGaXwITuIPnmLTehVCvicQv+iAZzHG8L3QNNXrMAeS0D
         XvB2HUCIcEsoGVSKyc0GNpeUaWRqCAYg9fczF47BJkyVyK4VIXPTiytYaPBmxa0ax5XH
         KFiU0kuXUvMb/8oYt4c3BH2g5RTE4LpYx6J5W5oZl3yA6vjeJOYRpO7fpJBO2DpxNCCl
         B5mQ==
X-Forwarded-Encrypted: i=1; AHgh+Rox5bHz/k9+y8Wgx3LeVSFv2VoUdnlz267gxxoS8MBnsdVj/fwZmAIyH/wVxIpZ5pBuhWMbxHIbPA==@kvack.org
X-Gm-Message-State: AOJu0Yz6aFp1iSAFt/Fs6KFmvA3VqhsApxDRUcx+hRnfFEyJoeK1nScT
	PQk/iCFVDYBmzSCmxiQDskekhz18QnhOf6oM+We/+MeqaAqvna9NXMqidqw06UXOz6c=
X-Gm-Gg: AfdE7cm8yCrSc7E9jNWfCC7zGuD/LsZs9iQVRRXq5S94AzOV2qaaRNQn3K03AfIWuES
	3EWI3fs4VitdU8lFRMKYP5H8Nw3cmOimOytUiSBn/ugz+16Zm8FQwDyzzdmrrPWHr587/I8Xar9
	2eark23iHwLvLEtVSkXSuwOvlGAEs0pHoyhnorH/N+rdUa81LyCKssCwAL+Q1tLileoe3llgXjV
	o2oOtruGuaRIJyu4Ywq6KLLZ4LRbvJsSDP60ennT6zjWT6s06aVb5SPMvePdGvt5ufU+z4RMR+p
	vPpqTjkQyEihNqUUUuXQ8FtuSQ7l9vwSW1VIJvVCik/muAYdSxMP4sOVbIzBN6J7a3lBO6EEw1v
	TJrWR3CLuH4QDCA5pOCeXbWUXkoquQB1RXMLHTwaC32Cs3hhy+aPDShORDsXqTBTaW2apqy8=
X-Received: by 2002:a05:622a:558d:b0:51c:164b:b241 with SMTP id d75a77b69052e-51c8b2d5582mr133755821cf.13.1783701660503;
        Fri, 10 Jul 2026 09:41:00 -0700 (PDT)
Received: from ziepe.ca ([159.2.72.92])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd50e0347sm45334476d6.2.2026.07.10.09.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 09:40:59 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wiEHb-00000007Yc5-1TXt;
	Fri, 10 Jul 2026 13:40:59 -0300
Date: Fri, 10 Jul 2026 13:40:59 -0300
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
Subject: Re: [PATCH v7 5/8] drm/nouveau: Use
 hmm_range_fault_unlocked_timeout() for SVM faults
Message-ID: <20260710164059.GT118978@ziepe.ca>
References: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
 <178345364273.660027.15274510603185163961.stgit@skinsburskii>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178345364273.660027.15274510603185163961.stgit@skinsburskii>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5DE5B18000E
X-Stat-Signature: 3mt31kpto33kx8iqyju6yrwmn1ehs8kn
X-Rspam-User: 
X-HE-Tag: 1783701661-369868
X-HE-Meta: U2FsdGVkX1/IvJ/Ebm5+UjyEoLjJ5vcy7IobWnmop/pNhRvyvvDu9UN9BzdnUPxi6hA8261luTM50ddPJ5pQV46labzYEVNxRkXYjanVBdGM9JdAkJ149N/w6MqfkCIsGkeKRJrB5drJshOK+CzR6LsRVxV2H/8GRkemA0psDJ+WesSx5u8z5BFW5umyJt0Qayi0+Nppl2il0t9bABe3Tujrl42DGXdf1bxwNWnaIXThLiSTFTkKTAZOUK/LEydab1XLjfKmD/4w5+xr5PS06wB6g0C77KBA258jB/bxCDj9bOvOKIXwqhMKON6h7a/5fo9X7RBrPDYmNL4Up1pF9kmihXwLQL0B58ArlVrInJB91zrua2HZNsKX9BEdIR7teOTybLb2OHaFhSBtcN4h4T2XHNVmDTAe+P6lMBsTzQ5WxB0A3nW680V46+GvOApY/rCo4x9uZPk4hL2elT7H+9Br/ypFBkCXEScvvu8iCfqHMKu+DXZpBxOXDoFXtVRFIQfeG3EuM6Nik+TjxdsRHrlraVSnatJzYtFlz++s7g63WdAF/iUpOHwKqFqwxj+Lz1Yc+zSRQyfz7vQ6oJRXuNiDTmxrrdUMhFvge7FoXl8jeatRTscN17yTJjKv9jJFPnlXlcclc4f8+vkQHd4JrGYtjvngiKcPO4cOC7mAFQRtRnlz8EoF2Q3kibH6B6hwWS4KC9VQKlvoIJ50Doc+S+Dbm+2BZUIBMS/9jJTip5Nrw25lIhh2oSGW7r481nZF/8LYjDG+3xKA5Z9LhrfTiAPLhV+Mpq8QPXTbEPnmgDt/aZX+6zMiXCRcOrKWECL2c83vNgFU3D7jIzYVXtakjQTtgmH34R2TUBibTLsfJsKUwG5p4hY8mi3EfgXIqny5wQyLBrKh209m/GqR5MiNO91aoY2KDmkfMUGP1crpUn+lepxWAcGHgACUE6HlaauShheYWfvVFm2YbFgXKFY
 gVIUQKwb
 OPtxojdTrLDoveaGxZLIloTHRfNsT+XCf3RL1lqzRdhXr7Vk6Fj7mg1gAJ3woZ71JMiFlwz8G8osBpxRf+YFqxz06ETo2+tRqrD9S3cPHaL8v5LOQecHFscK1dWU9T7clqXA80F20HfjW1DB1tGotISmz1kFPFC4znOGoxr2wDLcVLYbo9IYC9a99ZXIGPcVneYLpsr3FN/t2XaPaFA0eRNELQ1EmC5LlMwV5jnJfhgyewjayQj7wmqFD/kwILSeqSBdYWNd6BAlyKeETQeY26e/e5J5J/oQgNk9/chCFlsIahl5K1qqIKLuhOwUpzQJdNEmBJOVShTGQckuFgPrzSTz5m8R5unSv3maCNwh9rm/BRKXCYxuMeG8Ca3fa9+jlOSJc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 12:47:22PM -0700, Stanislav Kinsburskii wrote:
> nouveau_range_fault() takes mmap_read_lock() only to call
> hmm_range_fault(). It also keeps a single HMM_RANGE_DEFAULT_TIMEOUT
> deadline across both HMM -EBUSY retries and post-fault
> mmu_interval_read_retry() retries.
> 
> Use hmm_range_fault_unlocked_timeout() instead. The HMM helper now owns
> the mmap lock and refreshes range->notifier_seq for its internal retries.
> Nouveau keeps its existing absolute deadline in the outer loop and passes
> the remaining jiffies to the helper for each fault attempt, so retries
> caused by mmu_interval_read_retry() do not reset the overall retry budget.
> 
> Nouveau still validates the interval notifier sequence while holding
> svmm->mutex before programming the GPU mapping.
> 
> Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
> ---
>  drivers/gpu/drm/nouveau/nouveau_svm.c |   11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

> -		range.notifier_seq = mmu_interval_read_begin(range.notifier);
> -		mmap_read_lock(mm);
> -		ret = hmm_range_fault(&range);
> -		mmap_read_unlock(mm);
> -		if (ret) {
> -			if (ret == -EBUSY)
> -				continue;
> +		ret = hmm_range_fault_unlocked_timeout(&range,
> +				       max_t(long, timeout - jiffies, 1UL));

Avoid max_t, 1L should be a signed long.

Though I'm even more concerned about the timeout if drivers are now
wrapping the whole thing in a timeout... That's not sensible at all

Jason

