Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B60CC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 06:11:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27FD86B0088; Thu,  9 Jul 2026 02:11:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2310A6B008A; Thu,  9 Jul 2026 02:11:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 120ED6B008C; Thu,  9 Jul 2026 02:11:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA5AC6B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 02:11:27 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 34726168FD6
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:11:27 +0000 (UTC)
X-FDA: 84968216214.06.08BB316
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5E99A40008
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:11:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UK2mlx75;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of realwujing@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=realwujing@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783577485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hd6GoWd0nNSvkzn4bZsOD9QjS5q1cvBf4vz24CQIaxI=;
	b=AX3YiFbwV+z/fe1FFLyOQyLn62PaJ964KJP8lCIhh6WYazxL7T9HcjfuPBSmKZ2CUAfTp3
	mKeagM91IgX5LtsMO1/pJz4UdUVvr1YQeNxASgg+lgOFYsIu1d8aanCgb//4oCganFhHh6
	0iALca9P8OQvI/3QuCqbmgUOqdEjNlk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UK2mlx75;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of realwujing@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=realwujing@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783577485;
	b=44RAZksEvKavhW7qBFoHi2VQTtvPivJ10nq9BUXpzRQxpEUTMNHdjO3ekx5gDftgjZ3Wob
	hXRxQiPDIolNvsONvtKo/lZ5u0/wFcbMaoJAy1xolI8lfWuI09XRIsrloxyP+7VOsTbuu3
	dozVI+6/0iOI6XQQwJlx0g0Go/+jZhE=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2cc61541f8cso8326865ad.0
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 23:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783577484; x=1784182284; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Hd6GoWd0nNSvkzn4bZsOD9QjS5q1cvBf4vz24CQIaxI=;
        b=UK2mlx75MmLrgX7qzji4rYUfbJNOj9xrBtlGYxH5C5jQQHEpKaVZBfotdBdciyQ/wM
         y62Qb59M0uW/4B0dJcb0OwC8XoMxPdvMi16zQcHAfeLSaL32ddX5RWJina9TFWjbDYKJ
         /rFMlpbZSYCkUsV+zRjQXz4IORUiM38mRUAfVu+ffwL3aXmTZXiEDkj22n8eMRMyXVWy
         ociuaNIksfX7R2b3dbT2kKLaflg6zCiZmJ//I3RAqxV5a7Oxzjwst3Z6ZI91JA2l8NU1
         PPeTLMhL+JfHbY5rkWTZQ42wg6mGyTTyskIjpshBpF28v5ln3ktEVI/YSkmvUJuCpbDn
         Dedw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783577484; x=1784182284;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Hd6GoWd0nNSvkzn4bZsOD9QjS5q1cvBf4vz24CQIaxI=;
        b=HeFMkjnzj0MvY6uf95ao8EI/dCFMEQjEV6179gIXxD5G8oqBQ+KvqwexFdoDRiDkzL
         3Q9AIGZnTXL/bHyFAJepqeDAnHkybSN54aF5xDGTt5TJWuA5zlE6xU9MWWqPm9d91Zrc
         sZ1hWMhVOhreL5CPfaizwfowqvIjEcZNYui9lZ4DGVMMAjn2C7GInPsQlaoUjRtpoDMF
         palHL3mEp73331OWPLGXoNGciQlhNpKkOLzBTCd12qbJR36oTRNHVBcBF7KGCT9L693a
         Z99WDqNiRdGLD7uPjHXXEAeXsJYcWENXIyoEnz9Jqvdk+BvWaOnJUPNBKxqZ5lLMU/J0
         YnmA==
X-Forwarded-Encrypted: i=1; AHgh+RqiwFFKPw2uXxII+bMvszH4Sw9OOpL+8RKc4NilP3g9vHUFuURjZYk9kgQ70WA/KscNTxliLGalbQ==@kvack.org
X-Gm-Message-State: AOJu0Yw39zIooS63t6eettPcdUbwj5c79x0E2Xd8HEzmXl6NT+3EMElY
	J+KmDaSbRmyULKQuye916MTtWx8h/94tDB8CvsQD6P7RpCdi0e8ha2Oy
X-Gm-Gg: AfdE7cmNVMtc9vRvZ3+qNhyADMLKYbqWM4AjvxANrpzkgTnMyRJF8iNOR7YJrRKf0ej
	MsYqnOGzQS1Vr6EJtIQCpQCpL+grwHhJJixlcmNFfGvfvqe0Abjdzc8pLApui4kddJH88hmW75U
	WwSck+pJHjBudw5Ue1zskmwvOBWgkTCqSFeZLJz5HRim2POURMSV9kVMsJIbhq3kwgVyKDh0dKH
	EBevqtdheWkvQq7hrA2QZmTo2eF6pogw1qSddoQBGC5Ef3mlHhTf1AAM/nfKr+/6hpcVdJ9AT4L
	D3Dm1mLrYsXhwsUG5zCwpHq3BNkvG/ToCp+ezW0U5ta9lDh0vyJJ5nJdITWDm9ziwGK3Y6ICHtU
	mLtOTHre8Ra9hkkkirXxqu4z5In7oXqM+dKiQcldZutsxkrV/WQs8EW4SlpZSw2IC0UEPoxPUdf
	xIVdKpJ5Q=
X-Received: by 2002:a17:902:ce0d:b0:2c9:d27b:af11 with SMTP id d9443c01a7336-2cdd8a84479mr14704525ad.11.1783577484149;
        Wed, 08 Jul 2026 23:11:24 -0700 (PDT)
Received: from ubuntu.. ([138.199.21.246])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9d602fdsm37778845ad.81.2026.07.08.23.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 23:11:23 -0700 (PDT)
From: Jing Wu <realwujing@gmail.com>
To: matthew.brost@intel.com
Cc: thomas.hellstrom@linux.intel.com,
	christian.koenig@amd.com,
	ray.huang@amd.com,
	matthew.auld@intel.com,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	natalie.vock@gmx.de,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	Jing Wu <realwujing@gmail.com>
Subject: Re: [PATCH v7] cgroup/dmem: implement dmem.high soft limit with proactive reclaim
Date: Thu,  9 Jul 2026 14:11:13 +0800
Message-ID: <20260709061114.1623774-1-realwujing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <ak81RUK6vRZaMN2D@gsse-cloud1.jf.intel.com>
References: <ak81RUK6vRZaMN2D@gsse-cloud1.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5E99A40008
X-Stat-Signature: caw1xrdwdb13rkh8k5qe3q484cj99uo9
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783577485-117021
X-HE-Meta: U2FsdGVkX1/bW9oVHfVZJId0dw45tvwb6GWYp09ZAMI1dvIIM3BXNFtQf7NjJQkhIk1vIcKj7FI7q3VnWhqgJjdeDkkry0HuplQLf5lMDlBzxkYweb/uCd4t1OmswlpCOtYLwEVDPB1e8sor3wgZguNSp4bAqJ88Z6BFoiwh9HyD4O9ntQB10XwC3Wp22/ZG/gJca2oEZdbamG/9mnqAUzLTiGGC91hwXztBN20f3SCjaqQfsbnNuZEWOA2fpHRMHqWCwDmapWf+FvOhQfiwCAJByBQKTxBtp6cMm9Li40hPoq+0L67jx27qIqaqpEpwvtROm/mb/nOeU71drqk/Kp+79xMTcOqPU6s9zVqZ8SZH/EX+Qk095tYHzDPt5X1nC8UOfZyoUHXBBstJ+gk7Cl8uXQIlqrot1HK8ABG3N0YnzcnHBEHYWClC3rGlaKVD2Aic0OTjt4g4K4M8OHeOpwqOl2AvYCR4MzfuhBP9DWJE9paqCffyqv+yluFvQgq2QGgw4EYCyThnnEApxDO5gokihkyTGclErTN1y4bqgLhWYaqL/mLTmGWlcWCkPNAdPt/Kej4i5chBKDpEtyi0i6HA+XFTSfJ8jsk2hPYrZ46LcxE9S7kN0XcPi7ZvhL9jsMDRCYs+LNMtpm9fojkUgfcY9eyl6ND3CZA/xZ59po9tCwhzYSFaOASkHzzdRbI0eei+RLW+ImvfNvWnj7y+lQ+SipYKB0BXKIl5dQNStR6b8RkTbhfg6jrBB4VIyb1nuXgHe+p7z2GPEfZuDp/DdqQAbNc7EggXoUtuGggaOajsQyy8XrnpU84dkZOt8+vrofyCnJGSb0z7eiDG87wGIh4oRc8Hlkp20DgIgCYO5X/v9ZnY5pX81ub0UIDyqv26B/gS2iPtGkrrjAH41TZ0mXuKbNx8el1K0hifp28k5MziRzLCAouwPWiTdAyEyzuwO4BFRHTqRSqpUOErRCh
 tv+j9i7U
 RCQ3ilAxJ2iHFHL2qNML7QJKwKFRaV/njmHD0PDOtPH25bqRT+9vm4X6U4qFezqezhcYMDcCrYRUzkEjGIIdP7siJ7E3qb0gRstL2F2ufAtgZwNk83l1yRrYjgT6lOhEr55W34se14LlJYlqv/8QNYRIdv/bbjG1l3tDnFsTtey6PWtyEVSTNtNR76F+qNs8aF02ePox2axwfltFzo9U5BNkNGENjFqwsk8hIZPzvLGoG1nmOAxi9dmTwSk0Qxqh31mpzK85vOYd3WVUBiWghL58I625HDXRWij3KyCnibs5YDTnLMPFw5IiRy+iYJDDnXlG4K4PMLuGOhgpwG7+JbZclcV6UmRIl8Fybia4qDMlJQQZ5cZ2jwT8lpgPjoHvYsD5aRSidPhPvLCkbfNvyRhuAyM2dC3mlYg2RfoHIj/fvv597iUI6rWaxmWRyK8Jg50BxKujQDWrb/JtF3W1T8Z12k0KWdfqFXgWTuJs3OPx1mjFAK7ATJ3skFonQI5cegVleR8FOIGupVFNIPtBNIcrgSpz/J24I4G3oCOn3tWwDR94y7bKVTJDEoTfWDWP40TdreyqlfgC2u0g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 09, 2026 at 12:44:37AM -0700, Matthew Brost wrote:
> This looks quite similar to work Thomas is doing here [1].

Thank you for the pointer, Matt.  We were not aware of Thomas's series
before your mail.  After reviewing Thomas's v7 [1], the two series turn
out to address different — and complementary — problems:

  - Thomas's series hooks a reclaim callback into the dmem.max write
    path: when an administrator lowers dmem.max below current usage, the
    kernel calls the driver's reclaim callback to bring device memory
    usage down to the new limit.  This is analogous to what happens in
    memcg when memory.max is written below current usage.

  - Our series adds dmem.high as a soft limit enforced in the charge
    path: when a successful allocation pushes a cgroup's usage above
    dmem.high, TTM proactively evicts one BO from that cgroup before
    returning.  This mirrors memory.high semantics in memcg, where
    reclaim is triggered per-allocation to keep usage below the soft
    threshold.

Both mechanisms coexist independently in memcg and serve distinct
purposes: the max write path handles capacity reconfiguration by
operators, while the high-limit path provides automatic backpressure
for workloads approaching their quota.  Having both in the dmem cgroup
controller seems correct.

> Are either of you two aware of this seemly overlapping work?

We were not, until your mail.  Now that we are, we would like to
coordinate with Thomas on a few interaction points:

  1. API intersection: Thomas's v5+ replaces the bare u64 size argument
     in dmem_cgroup_register_region() with struct dmem_cgroup_init (which
     bundles the region size, reclaim ops, and driver private data).  If
     Thomas's series lands first, we will adapt our patches to the new
     registration interface.

  2. File-level conflicts: both series modify ttm_resource.c and
     ttm_bo.c.  The changes are semantically independent and should
     compose cleanly after a rebase, whichever lands second.

Thomas, would you be open to coordinating on merge ordering?  We are
happy to rebase our dmem.high series on top of yours once it lands, or
to split out any shared infrastructure as a common prerequisite if that
helps.

Thanks,
Jing Wu

