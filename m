Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 885EDC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 18:02:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 770D76B00BA; Mon,  6 Jul 2026 14:02:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7482E6B00BB; Mon,  6 Jul 2026 14:02:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65F816B00BC; Mon,  6 Jul 2026 14:02:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 387956B00BA
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:02:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A8C0740140
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 18:02:13 +0000 (UTC)
X-FDA: 84959120946.17.09AA16F
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf05.hostedemail.com (Postfix) with ESMTP id AD17D100014
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 18:02:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=jHPHziOI;
	spf=pass (imf05.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.41 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783360931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kXDlM4ALMMZ+goUgzxjE8iSzN63pj5SPv611+8XFIGI=;
	b=U8CULvmMQfjnoC5Cq4P9iEoun1HzJiEImZc4JtT9idjNMJcVYhlnHIY12Vn0Ksgcr85FKA
	p2hGISe5sPRjk2bmss/6TTXk6pF1JL7M92ESCccLtp0LBSeyAFB7haEQ3t+OLClILkfSkT
	MDfNP3EGr//O+CYTfIw89V02+SEjWA0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=jHPHziOI;
	spf=pass (imf05.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.41 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783360931;
	b=bUVRy021rv/PtlIP+QJXmBpoWBZupW+7Ol3DQAdFQ1MuTCh/qMZh/cx7Y1/ZCjf7pwSmnD
	ZOFp37+9t1zII97qOKgSqjKQP6uZdCyin45nlT/DWvrFO5UOy8+kFrorYccAq9YHJtdVP0
	CtowmNq+sfT8nxf7kUF/40DDvGZyjBc=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8ee88fce572so29552456d6.1
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 11:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1783360931; x=1783965731; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kXDlM4ALMMZ+goUgzxjE8iSzN63pj5SPv611+8XFIGI=;
        b=jHPHziOIossvwh7QrurmpbipBQYtvXzL81eZd7o9qEE49jHCmeQHIAyyuEBlyIclqb
         YmMVeZYmtyX4dv++s57n9+rowubamJepKY88T5EjqEXW2s+Ywko8Lx0bfqwwcoTgaqF0
         fSU6sD+zCMo/pyI/vD7t4CkUDPLx2EcB1tPd3HRJIm+qEQ+wNHsWyT+lwXDr3gMC+N9/
         V1Nnc87QVp/3LX04qACOgXnqbHxwyLzpdzRYuMBkPZNC6x/KnWTidRHCceeZhM38M22K
         +FTgHamKWbPZKT5bvCUpAjCc1hN6NPubMTE9E7WgkYEPMD0Et/a3qiBY0zUp6o+bW3AG
         h7sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783360931; x=1783965731;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kXDlM4ALMMZ+goUgzxjE8iSzN63pj5SPv611+8XFIGI=;
        b=rjRHt1840JOpHvB/gETT9pLvbbdObHUxzmD4b5ipylvtVLU/FoJWHVr2BnwIpDAmwe
         OMFAoYCmxVxqF8AjHZJ1fBJvNJX+5V+He5BLn0fHbxi8CI9aLOfP7x4FtxkJaqZX2DvU
         re3s8RsXHIDkjyfBkLuM6T9pok4cgQ4MxLFWXoe3JLd4qCmRMQ19LUKZRzbHw+INezVy
         jII9oPCrwGAeCAbGGuTjXKDTa/vUuKoeD3haZORDEo1AOlDLW85ATfNvxT82oKi6wyWK
         9GzgXiXHevDb0HtUvGV4AZtJt3r01Xm4USAi4GUeyoBCbYYf/o4eUSorELEGjSkE/lW+
         QNiQ==
X-Forwarded-Encrypted: i=1; AHgh+RpOj+bYTl7sF9KwjUCipB8mDmbBFGVJW1+IblH4EwWNaZhBxu7Fq+cY3mzQfe9oPCyNBj9f0A07aw==@kvack.org
X-Gm-Message-State: AOJu0YwfZfzGEgnNYRs5pdKRadyXPfx5Xs0Gk67xEY369cFoihCf0GV+
	YjOx3Ev6qegrGLZ/vbo0lzX0WI8Xixn8niB8iNMJoWABbFLaOaw5aEIPI1qhq9anW7U=
X-Gm-Gg: AfdE7cm/eWusZaIENkmiCvdApuyPsu0HU2JmIsPlFchvyS1q8QS00WHYntwt6bZmyO1
	UI1+KTow1OGLPjy8OKefwfxd+gfiewrY+5r4/6G/CEHKB7vLPF9yHZdbPjnyFGep78+d0wPeAOU
	mNSrLMGxbK+EOw/d3KTxDvgXxJEHXetLEUljL9Mirm7g/LtOQ0Pg4YpBjcv2vncYeVjfM6eoLEE
	WZAz8V9N3M4VrihIT6GDapZmTFOBWBej8aGrhuiNLs8sSOHgp2GDV6UsqyOgTF3u6upRF5r9CoV
	BMZ+CZgbsFuG/YBKhLCYG+sHQNYcx3vlMG9zKyEegWaOVdh0RrpSRVLzzuKARBcL+MtCrbEaKJ+
	SMxzcVBY6L6j6q8DuAYpP86y+YJDmbtEs2d+3GaQ1IbZ2ehKTghc7x4NHYxrKXIuszc4cMGc=
X-Received: by 2002:a05:6214:590c:b0:8ce:ca7d:b099 with SMTP id 6a1803df08f44-8fcb2990a80mr21004896d6.18.1783360929999;
        Mon, 06 Jul 2026 11:02:09 -0700 (PDT)
Received: from ziepe.ca ([159.2.72.92])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8f46e371f44sm150118746d6.2.2026.07.06.11.02.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 11:02:09 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wgndw-00000000dS8-35OA;
	Mon, 06 Jul 2026 15:02:08 -0300
Date: Mon, 6 Jul 2026 15:02:08 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org,
	corbet@lwn.net, leon@kernel.org, ljs@kernel.org, mhocko@suse.com,
	rppt@kernel.org, shuah@kernel.org, skhan@linuxfoundation.org,
	surenb@google.com, vbabka@kernel.org, kys@microsoft.com,
	haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
	longli@microsoft.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v6 2/4] mm/hmm: add hmm_range_fault_unlocked() for mmap
 lock-drop support
Message-ID: <20260706180208.GB118978@ziepe.ca>
References: <178336023903.504354.7500950448226027718.stgit@skinsburskii>
 <178336050736.504354.6052508493877924780.stgit@skinsburskii>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178336050736.504354.6052508493877924780.stgit@skinsburskii>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AD17D100014
X-Stat-Signature: wcxtnr9ogx4u371eoh3izumf7xc9pkmb
X-HE-Tag: 1783360931-810924
X-HE-Meta: U2FsdGVkX1/LAUDd/OJPoGnjMTdT0EhnDwSDXhMZQKOhjjn/5//aMvpFqMmfGa2imO4SO5p2kRRUzrImgfXsrFd2I355T6M9X3AOGJg3ScmQPdk3LjkGwi3OreZii75V+14shupdoXoLxDsQ4yb9faJcRibnf/ZrMiVzNIDUQW1N8lNAhHxx7yA2Lvo762xYbz9nJl0zmlOCMj2ItzmK85lbpg64tJz3kvNJZ/Ry7izmmTn1XabGLgwohXLP95aEatICo+wf5Ntzd3Sl/lw+IC8nVlE8TwVbxrcpoSIeSWqYr1IfKVNl8Sra2CDF80NsRo8Ww4Yg2XCncnMm7RlwJlL/7+Fq2DT8fhwE2yXnbz9Q3sKCN3mTDpVo77OoGXBbfZzURbLthM4a5sAdzhsUjm0hB1TW+43VKChowv/A7E7Z9hrUltCFQuqhOj4IKfjLPE6VIs6tew+HnRi97//77f6wCSlQf2oHo3PmjSu+gr7GvNebQIr6cwoh/P8dBYtK+RUeWgY5hi3SUWURG5B7gN8+59ootaMwvFMC4DR/jKQ2buu3P/MowKlYs8/8ikgf35OIOwZMUMaW42aNpN0W3YjLp4O6PLTlOtJ1JbmaWI2tljwcoFF8GkDdJc9CxZ8okQFb4XDeNXTqEDwJV6e1QmemLmrbsqnrb13/FfaWCe0Cq47HZGZ3YQt5xMZKstETXZ7zZWO++UO8u+MAqOslXsKF+ZbHtf0oqzuoaEUs1Zz0s4cubaCGTaNrsdiW5gW5ey8gMWdNQ/ifbYZKitKzpsAB609XCmU1qSnExNXqBbSE0zrszssBZICB6X6REwVC4DJaQh0f+L02YYYpvkmBOrJXniS0T4r6B3r58WDBQQ+c8wAXs/AiWUlmZHHDDWy9NoXIIZt2rUTuzG1INCXxDhmsI6xQPPAA4JEElXpK0PwFkcUipcnuVn/G44nkr/EApyluFlYzks/C5KW259n
 SNjmAM6J
 n/QHIga5+M4fUjJkslDTzMveb2nsT7FjJevKefzaRZGIIo0+ThXdwd97fhRGOeg+ixuh1SQBIO9wAFTGDbS0ALZHAzO8wNErlXyNkFYl7+ntcsaeqzyqRJLlfVAP6kr0GWeiWomh5E2LJDLGKF+CZc/Bu0BLRkpet8yFf/yWZmsN7faCs6XVsFSKZMLXIpbI0ilAD/JhSVgJcGGW/n+efNaC0G6CRFjU3lpZXvFM3/O8kPOBwoEQa4JsTvVkAlH12uXeDrG+iUelfPM4OOGYvrmLWxh5eK6RwmDjY7N1Xp/uE9IMBvPvYZqlkpJYmTfQkLAGuhJw0ol18X5VwbLzO+iTQpalYFz0/+Uz4xMpgVoSZ3ljqapQXE2JJ2VPy65r5CdjJmoVqz4rlyxh72YiGvqSyc4aEvb6/352s1v7Mho9FB+Q3LaX2/P8B6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 06, 2026 at 10:55:07AM -0700, Stanislav Kinsburskii wrote:

> +The caller must not hold ``mmap_read_lock`` before the call.
> +``hmm_range_fault_unlocked()`` takes the mmap read lock internally and allows
> +``handle_mm_fault()`` to drop it during fault handling. If the mmap lock is
> +dropped, the function returns ``-EBUSY``. The caller must then restart the
> +walk from ``range->start`` with a fresh notifier sequence. ``-EINTR`` is
> +returned if a fatal signal is pending during retry handling.

It doesn't make sense to me to expose this to the caller, the caller
isn't holding the lock and there is no reason to redo the mmu_interval
at this point, so why not just loop inside hmm_range_fault_unlocked ?

Jason

