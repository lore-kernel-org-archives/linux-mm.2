Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C930BF459EF
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 15:40:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42E526B0088; Fri, 10 Apr 2026 11:40:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 405036B00A7; Fri, 10 Apr 2026 11:40:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F4966B00A8; Fri, 10 Apr 2026 11:40:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1F7F26B0088
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:40:15 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B5737160313
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:40:14 +0000 (UTC)
X-FDA: 84643057548.12.1FD2089
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf12.hostedemail.com (Postfix) with ESMTP id C31AD4000A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:40:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=jOBU7gYY;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.50 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775835612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P+N+RyRq+4Lu2ncfMlDfFIZSLyoiGyTWZ5uga3Pmg4s=;
	b=WQsfbDlVw7iqnxi3Eps5iaDhSwlYG46aZldaxF71XS7pcCuuBBCk+hNEQIXR9UYaZJzEK9
	03pXaqWFZl/v7rTnamHco9i1LCuUouKBHhHQHA0BXaf19vKCQtiE4SESpz068++/Vh8AY+
	w+6D0YsNctScTpyjumF8yFINCcbp9ss=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775835612; a=rsa-sha256;
	cv=none;
	b=c31XwTB2tZG6R3ivQZGxWLsGb1WmiG+XvKYsSzplm6RJGLJw9w/G1fPFViSIpnSXQtMUNa
	YG1jX9J0VxOKJvWGwGyRsTvJTQ3tWemx4tSjWv0U4neFBmFwlF9m+aayS4zAoWBgX5SbyW
	wq5MTdSxO9zHbZmg1EOietPOliCK/Qg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=jOBU7gYY;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.50 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-899d6b7b073so20692466d6.2
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1775835612; x=1776440412; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=P+N+RyRq+4Lu2ncfMlDfFIZSLyoiGyTWZ5uga3Pmg4s=;
        b=jOBU7gYY24oaOSX7HegdM7ShPHWtO1mqnGeCbfRqQuleisoKtvIwJfyKj//edtRk0u
         YaxWMpGBLPrkApjbutcXDMLj77CCHqLoG22a+wWLcDFZcBaVQ00ga16BWz0JfDqesCyz
         1EY4oGEcdq5Lmu7byFUlqasMwwjXX4pT3ROfefpsb9wPons6WdyB7ch3fm1JUW26xY6w
         3bNWlC6rGUvpkcILPB5qEvSV8hQs8HVmlw5OvHstAfppAeAqIu3F45RC8U4ZXb0GGqIj
         Dy0dl0mlojhuHATp2eosPP3lYWl3KQ37X4U2oSNtePX7UYlm/0ds023jHLDZKTTgMlUs
         X5ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775835612; x=1776440412;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P+N+RyRq+4Lu2ncfMlDfFIZSLyoiGyTWZ5uga3Pmg4s=;
        b=eHQ06cV+2rmWjyGtlbW7wUKvtfvnHVYAOoWMCIPuKnWbtLZYQVAmvfg+uWlS8L+UNr
         l9ScDGcCYbDXF0umW8dqjNoKfrOFRqRdIlAFO31oFXnqs6sMN11FLnjt9b3AVqYRVC8T
         MXbrZv4Y+y7jfnmB7jwJRYm+uPKnZiif5Nc7AXiKGL1n4IW3HBRn9xv7mt6STzDyYH3G
         hKOw01Xa8mpaESCBA7hS83QoDBeMJz1qYX2ml2MJ3lDZbP9eXBYV9QaV9YpMFqX/6Edz
         kIaLYwFlQeWzTkL+IW/PpHSpaVt8YkTBZr/UuKinmRBLY7pCcWiSXLh/7VArjVZy6a8M
         NHNQ==
X-Forwarded-Encrypted: i=1; AJvYcCVx65kPYH9TltYR3OeW1eWiZKK2JcTyTPBSsIMFMtqY9H4FUGGkCiJJwqZHVD8adGeC+B/fVxCAdQ==@kvack.org
X-Gm-Message-State: AOJu0Yx5VWEWBJKk6p6QfM/4bSpniQJy6/+FTUhv48chiCaAy5Ab2cpm
	Yqk1usKYdu7s4pC6X8+d16pYoPSWaGD0hlKJK/tA+fV9QZJv8Qkk73jlcQavnFu3apO4W70g4Kd
	Iu4oa
X-Gm-Gg: AeBDiesuRjA65KidCkMvIg+N1O5ONaoA3dAhbdcWTIP+lMt1uMwAqxyvNu03aOD8/WO
	Gr1T+N9p8ZZ0ilWmGLavXLT8rYp96H/0CK4M+CyU/gyVFpqPwXsJdv3EAWhib5jamABrweMD4ly
	Di+SQXReIC7OBgsyBhkTbYB0VrH3NJUSkvplAOd8q4lBg+7fwV6g92jkDGVWXSroTb2VqQj4zHa
	iBzqxOFt9cr4zU3a9mNBQl2+4bW89/VV+iDTpm1GqCE8de47DQ08Q1juSc2xUxV6RT+2+eBJZxD
	c3EUxjF6vDc2684wQxbehKo/N0DX6nXEmyM+bonRq0q4QG6rRQHU6DXwL2RUYYI7Ht6XCZhVQwC
	JcpcKvqjCMN8Szm1/QNda90LYSTyQuVdfMActC2da4MC/wKs7xrFl03qH6kMpG/7iRkjqpbOJ1C
	k9BOlEJRin0RcEhzyQviIPQy1shKO4cmhRg4Z0blmX1TBcYQmFaCbWPBuIvHikQpcZ88+njw==
X-Received: by 2002:a0c:f118:0:b0:89c:5c57:98c with SMTP id 6a1803df08f44-8ac861b003cmr41115156d6.18.1775835611674;
        Fri, 10 Apr 2026 08:40:11 -0700 (PDT)
Received: from ziepe.ca (mctnnbsa70w-159-2-73-22.dhcp-dynamic.fibreop.nb.bellaliant.net. [159.2.73.22])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ac84a104ddsm24587146d6.14.2026.04.10.08.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 08:40:11 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wBDxq-0000000EhY3-2N2g;
	Fri, 10 Apr 2026 12:40:10 -0300
Date: Fri, 10 Apr 2026 12:40:10 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Cc: intel-xe@lists.freedesktop.org, Matthew Brost <matthew.brost@intel.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Dave Airlie <airlied@gmail.com>,
	Alistair Popple <apopple@nvidia.com>,
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/4] mm/mmu_notifier: Allow two-pass struct
 mmu_interval_notifiers
Message-ID: <20260410154010.GZ2551565@ziepe.ca>
References: <20260305093909.43623-1-thomas.hellstrom@linux.intel.com>
 <20260305093909.43623-2-thomas.hellstrom@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260305093909.43623-2-thomas.hellstrom@linux.intel.com>
X-Rspamd-Queue-Id: C31AD4000A
X-Stat-Signature: o8ganigcz5h1g4n4zwi1dt3pgfgiei9n
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775835612-835516
X-HE-Meta: U2FsdGVkX185+eIbabsbrrF7ebDXx/tlPLqEg8hh2cVJGnrbrsa9qyb7IYg/eRo4VUU2g0JZtAvgXtA9xf8RYyIOKn2DWwaKXtsgnnjNKVSyOsDIExSbaREl4R3IW5n90rEZgfj++52rCcEE8TduWMt1yRUEOLdJCGxt7rcJivSDERpvP1GD5+dQVngGQFTwL1aQMgei8ajw9PZxH8gXRZdfVH5QVMXa9msa5zQBtdHwjm/xP5fjV6R/dCjmUZWG0JxiL+LGQKlWMMO6m4PW56irZnr1NOZbrNmrB0nRxNwLXcwbbu/N7C9+B1H+ytQcLyH99b5akEhPwZtk7JCrdqUwOUIwazD1f8xfKC+tqXOezuwYDYB3rPcjUOLDeSQso+LADFxIdOtu8K33tjFL//YkRCJj4hhpgsvnVBIaiZscVvh5p5trvNU+QOOx1uafIo1Pfl25bRpV/H9fiK6+UfrF9pE0A62oosn6Q3fsgMq8bpUTjlTA8JDUVQbm07Q3F6Lt7Vx4XNpCiNB4hi5eW1Dz10E07nw5hoFbtTgZaOCi083tRAyxyIiM1uwzTjDlc9P24iQCT1IR4Etxly9PsCVfkG/b02SmcI1rRQ3o6blP335HKACcJTDvqANI9+AbtPpFOCwsRdDOmsg0rc8vHoo7s1KQqumdI4kNDOld8h+VjX5qujyX3yog2/ISTbVtuULT4ynOHJrM9HR+NN3SezJ/w2ScpwuvOcdapqBIxPce+bH/w7+/4+Jrvb+EY6qhUSJKFvKu+JzN2lSriYtsiIilm7TnBC6G9DIfU9w5kY2fT8qqV3QUFcHC4SU9ZXV+6s2svgfbnSRcajZGjBb7iEbmx5ugMAvPD+c3bUNQzLvDxr64WYouwtn8ay87jNWWMKG9U0COeeFe/uugYhrEx4tN+BFAKIrDqXOTpsPZmnOrKOUelrxn5LEsAiWa/m6WPOFhzypgarOeFg3onAB
 SAlLIZkU
 tVXzKAEfO68/qaoS2KiRGCZ1OPFHV1PWAa8ESv8ZdVmI20o59L6U7vjAivJ78l2RfrJcGY/psrJTpiQpj1oo+DCUH5zMyYMOK/THroX2ItrrpN+/1o9Cc0lJanW/LXj6TfumpboKppXDxEMrdTqzMPu6qVoSIsJ+E2e/wey1SfAE/HTS2Mnp8wtYNqt/Q8bKRI8mvfp/sgIkREkPaZXsdV+Hc2ZP2WJjZxZ8reQFC/7mEDdkpelMERS2SWL9QJXYSxCYuqbg3IpMfMfUd0I0bFxhRUHx6WtmgzSlGBk092UflPJ+DtuWXH84gjKS3CaMBaVTxeqErB9BaoOCLAYeIsBohpC8ah81MegcVELzjWZ7TTojV3qbHS4M6uAJBl9XuQ96+YSMJHrmq8uyptffqzeD0lh8t0LLEPB7L1K+XieXgU84XVbKUJiRfhFEXBO+voC2yMzGBXl1DN9b1HccLTQRW/4NvM/UxwJpK9YFSq199CWi1W1/VeKVRAsbvZOZtGG9yAhat8uyNRGglG5J/fpwRONUu6gKe52NmyybxH6CGuc1/Cg16Jk90kBCbMqh0eSniuiVvir4qIxo/+6efzYhUnk1/5D95YvfBUrZz/E4MuIsxDrj/xDC/XwCMOJn5BXc6DGhbpas+GmckyZi1yB5P3SemdQyZhnOIQvPf2JBIiUr43jJKyGiSSeDdpsZhsiOrE3NNgCDg9hqAGcXSxNX3lY6mloZuR6BTBcKLGptj/UBCNqVggMv01DewfnjnOWiRtBeCBAxKt6TCaa0IwOSF/fAVEsh09xtaJuDQeDsxeBSaVurnLJYNEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 10:39:06AM +0100, Thomas Hellström wrote:
> GPU use-cases for mmu_interval_notifiers with hmm often involve
> starting a gpu operation and then waiting for it to complete.
> These operations are typically context preemption or TLB flushing.
> 
> With single-pass notifiers per GPU this doesn't scale in
> multi-gpu scenarios. In those scenarios we'd want to first start
> preemption- or TLB flushing on all GPUs and as a second pass wait
> for them to complete.
> 
> One can do this on per-driver basis multiplexing per-driver
> notifiers but that would mean sharing the notifier "user" lock
> across all GPUs and that doesn't scale well either, so adding support
> for multi-pass in the core appears to be the right choice.
> 
> Implement two-pass capability in the mmu_interval_notifier. Use a
> linked list for the final passes to minimize the impact for
> use-cases that don't need the multi-pass functionality by avoiding
> a second interval tree walk, and to be able to easily pass data
> between the two passes.
> 
> v1:
> - Restrict to two passes (Jason Gunthorpe)
> - Improve on documentation (Jason Gunthorpe)
> - Improve on function naming (Alistair Popple)
> v2:
> - Include the invalidate_finish() callback in the
>   struct mmu_interval_notifier_ops.
> - Update documentation (GitHub Copilot:claude-sonnet-4.6)
> - Use lockless list for list management.
> v3:
> - Update kerneldoc for the struct mmu_interval_notifier_finish::list member
>   (Matthew Brost)
> - Add a WARN_ON_ONCE() checking for NULL invalidate_finish() op if
>   if invalidate_start() is non-NULL. (Matthew Brost)
> v4:
> - Addressed documentation review comments by David Hildenbrand.
> 
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Christian König <christian.koenig@amd.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Simona Vetter <simona.vetter@ffwll.ch>
> Cc: Dave Airlie <airlied@gmail.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: <dri-devel@lists.freedesktop.org>
> Cc: <linux-mm@kvack.org>
> Cc: <linux-kernel@vger.kernel.org>
> 
> Assisted-by: GitHub Copilot:claude-sonnet-4.6 # Documentation only.
> Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> ---
>  include/linux/mmu_notifier.h | 42 +++++++++++++++++++++++
>  mm/mmu_notifier.c            | 65 +++++++++++++++++++++++++++++++-----
>  2 files changed, 98 insertions(+), 9 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

