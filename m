Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09C62CD4F48
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 03:42:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 246DC8E0009; Fri, 14 Nov 2025 22:42:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21E7F8E0005; Fri, 14 Nov 2025 22:42:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13A088E0009; Fri, 14 Nov 2025 22:42:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 02A078E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 22:42:21 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 89D9D4D5E7
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 03:42:21 +0000 (UTC)
X-FDA: 84111443682.07.E22AC8D
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf09.hostedemail.com (Postfix) with ESMTP id A5F70140004
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 03:42:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Aq8GfOYM;
	spf=pass (imf09.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763178139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Af+nXEWtEaAxNcvRVetKdQJrBk2sAifaziyN+YLmfE=;
	b=oSlPNmuc8R4x2EM7CtXeVTn7m6IX2swvfVQJoWqzDcMjHu7XrOnTGSWfAz5rwIA0b/+4fE
	/pA0mdBpKc81FXAK8887AJ1LXH+IP2vrql5JMYQlbUevsb8z/ov4Kx80xVjrcwS9wTuMH0
	gzY3ZR3gZwORmlIDuUvf/q0927rq81w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763178139; a=rsa-sha256;
	cv=none;
	b=6KS6+l0oQ+hx8fALlDZBZz3FvIpzaTSjbCK1IIcCX0SVn3X1x9MowpPDimD/JcoNzlqq5z
	Pr0I9bbfXdUNx5N6cfgx7DfxRy+9vIvzoDqTvMYvejd3UGNqmTnKN2Rqvs/Mh+nDdt9qzU
	z5hQWleBDEuYsm9Dla6Ojec3n9rHRWk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Aq8GfOYM;
	spf=pass (imf09.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-298145fe27eso32017575ad.1
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763178138; x=1763782938; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4Af+nXEWtEaAxNcvRVetKdQJrBk2sAifaziyN+YLmfE=;
        b=Aq8GfOYMeqxozO4/8RmVMI5pU8M/VG4ViLn54edPjG44b6FDscCJ9CP8OCCOUuCw79
         L7HJ8bUPUpP+ajfrUK+s4698boxhW5IVauL6Z7+HyzKque8ASwMnM1dkGIzWOfR0LJT5
         atiijS3xZ1jdp/o+lwckVgXi6SmPKRM3LI8Us=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763178138; x=1763782938;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4Af+nXEWtEaAxNcvRVetKdQJrBk2sAifaziyN+YLmfE=;
        b=nGb+BurYfxiUQQjrTXkeWaPHRGNwA6L/PkaOO1DBkQOWYdLq0bg2Tq8N8VwjyZ8BST
         Zdgezb8PiAqb9C6iQtHB/ATvPwBBHqOZe1nbt8Ar+cXKcQsI1hLmkkFlVEKP8l3/J67i
         jEJOAR8NuWSoqub/fSUb3ZaTlB/Jll4XwXlc9oKkv0iy2553vcC+iw/s6N4vZbQZTyVH
         7flid3GCJuw+Yt9noZKEyeGTus3MIydOOBaIR3eJhCiXZZQn7WE69gh2NOaVtuOQPj7h
         Pvf2un9UjeuA52jJeImBnYnSw+8eBC9qa4hI0mpBtyiXJzHNq+fCi0Wnr0OqYzG7jdmc
         HaIQ==
X-Forwarded-Encrypted: i=1; AJvYcCVGcJFyMxAKxNgK5PKM1rH0luwj1/nnAzyn1ArI4OA6iLbgBEMVfn0qd6Lm8A/XIl/eRhc6M4qigA==@kvack.org
X-Gm-Message-State: AOJu0Ywys+V19WyFPtUgdKl8V0JzAc1pDcSEIZbdNSoQcE0ApzAIsjBb
	JklN//uqGs5QPnnW/vlgT6wiMJPUgd/YyUKu1LWxTC4GZc0PgHhIgNgPn0LFUQtBNg==
X-Gm-Gg: ASbGnctUVDrdxP6XwaiEJSVnxeMlZrTVUrlBmUnAzgruCaqq4RV3J6h+WHdEBjC97mF
	H1YxvuFhO3SXby0BWrzUnG/BoSqiu2UsxvZOHiRprR1LBoymdBURLRd2rk4KAY185TFsFW9UmMq
	bs2Dmak7PRQjyOOp1rZmw+ubMGJv4ResK8RQ22Be8BxSTckV67EMQS02teWT8YMipwX4BxpgmU0
	jGaVz0NNBrFrlWQtbyh6/sD0z+kxHQmuRBVbgs3oTxgFZDcfTAUsMimN7Q2sE/orn6SUBLKklnL
	rK5tTFawuCD+FjyFEO9aZc4F3nI5eGWldwE2X//IJPkLkxowCWRjooQ8VJ6PCvIzuTKKwyjFHLg
	2uukGFqKm3vUQoOywPqGnQ0AbqChoPQ//Tm2rz/JkdglmtZl1+vcMZyw4IVGy9whzCod060zrSb
	CsA+NI93d00i7GJJg=
X-Google-Smtp-Source: AGHT+IHF1HltwLwMqhbQxQs+gAn1RIWFWael5BuA17en31fTdcRQ390Bt7bG4aTQ2UBh7dpIUKY4Mw==
X-Received: by 2002:a17:903:1a2f:b0:298:2afa:796d with SMTP id d9443c01a7336-2986a76bcefmr57326565ad.61.1763178138476;
        Fri, 14 Nov 2025 19:42:18 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:b069:973b:b865:16a1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c245da0sm69774885ad.26.2025.11.14.19.42.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 19:42:17 -0800 (PST)
Date: Sat, 15 Nov 2025 12:42:12 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Yuwen Chen <ywen.chen@foxmail.com>, 
	Richard Chang <richardycc@google.com>, Brian Geffon <bgeffon@google.com>, 
	Fengyu Lian <licayy@outlook.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org
Subject: Re: [PATCHv2 1/4] zram: introduce writeback bio batching support
Message-ID: <rt5rjjjypqv7b3syrey4bb3rqmoewvpudt44sacaarzvfvrss7@vtn77o3upvha>
References: <20251113085402.1811522-1-senozhatsky@chromium.org>
 <20251113085402.1811522-2-senozhatsky@chromium.org>
 <aRZttTsRG1cZoovl@google.com>
 <rjowf2hdk7pkmqpslj6jaqm6y4mhvr726dxpjyz7jtcjixv3hi@jyah654foky4>
 <aRd_m00a6AcVtDh0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRd_m00a6AcVtDh0@google.com>
X-Stat-Signature: e69p6xrs5kozamfziae4gym4k9k8u8r1
X-Rspam-User: 
X-Rspamd-Queue-Id: A5F70140004
X-Rspamd-Server: rspam01
X-HE-Tag: 1763178139-783540
X-HE-Meta: U2FsdGVkX18N9hL7ymxX+IvLjNZ6eUy/lDhRR4/kBmMRi8B+31rxY3tW+dgbko5I+Dg/VKSKWHp+XHYc9ZbPf1rFTryY5TtrjrLR6rB/VZmti/lGvpA8GptWAf0j11nuaD2VHt9h22+5in4QTngMrwHWbhHyopjDsdAnNhxCXRpzxdaLZ09Dtm3bQpt+X4GOIU/D2sAR8zn6IDEwx/FhMinKWRHPGfkmk2kU38qMFzt9FYy2ULYO1pMQ4rW1YqoONZ41DQvjnTJBEWjrCwzISnYApc8SIFvcZQFHcLuJkbTZH+Wq9lkYE8VIgi1DVmvNYOYoRlMffG9OC1+Y/FMr1QLrVl7sBM2Bq3Jp7ZkupLbNv10LFviwztjPZztNUGG5vgJp7v3FWVYxRKDF79k1oCJz9eUnzGd8+IFKt3Ouv040NynySTiJNkO229yS1ubjRGHagtGCUOCXNL9q9gvuCl6L1Q+5YSRb0pjPK1u+xcSuj6m4iL4oVFgYsFUyJ0ykMZlQw0gAOlm8+h37+U3t16OTUUsdhpKr/BYQ+Lz09i2BjdNtw8mpe2t5OMCgTnfFvQbizEcTIMUI4pMVXPnivgFPF+ZuIPKYviIqNaEbp5WnEuZYFEL+FuTzYkjiSJHTjHEtOZyLaWy+7LqVO3kIOAjEy/z9JMxphgMaIB5bpZRuVkvHoxCxCmdy3TwRZ/vjsaHF6Nv+Oyve1GRLi847lZBAMwjUWgwb+MKmiM1bH8Mpkj4zA02DMbJOUftpx58DsQFUQXvYwl1wz+stK8ETybFvbfYPrxRjoDZMGiXTawJvYhMAV3VjfEMn5Ylqdihq1n4tncmsOtb+dCf9VBxK6ZFAI6BiNsPWcRJdc2WPrcR/+nwnohn8LA+KttXoFGHUier4boX+n6ToEfBNVUq85zu/uWm08cUBMk+NxTFwYyD5KeFQ6oHgNuEgxk7r29OZ5nCHdleb03f8rXV7qYW
 xHTEuZQq
 ed/5nWc1ZO3wiHyUIrWXPoAL79wuzakEOtS2N+gy2/cQ9FAOgCfwDr/3MUoHaOavVkeWizHyL1rDjURGs1PB2wVqs6gm4MVI9UQgSAx9uaDbJYPcKzSB8M8tCmGTW8j+GgQbdzH6F3m6Uifumse02LrSbHZ4WryUHnlWoFCSDN//YJvWbGBcWVfah/PBKIM/c0WtWBD6CdyadesZ4sLN+8AA3nJUyNyQ7cZY6FbM+7g3tWlh2BiSVoeu+P0mSygNWAVwSJQxxJKVZbwEqvXW3fK3hondKCW1i+EUdI7q6FLCFk+rKChHDhf42+us6HF3nADqOGU3EPseyia4XDjZ9JA4cWK9jSJnrsNI+nxkJ/9aBB5w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/14 11:14), Minchan Kim wrote:
[..]
> First, this writeback_store path is not critical path. Typical usecase
> is trigger the writeback store on system idle time to save zram memory.

One thing to note here, is that this is likely the case for embedded devices
(smartphones, laptops, etc), where zram is often used as swap device.
However, on servers (or desktops), zram can be used as a general purpose
block device, and writeback can be executed under very different conditions
there.  Writeback is guaranteed to save memory, while on servers there
might be no "idle time", so I can see scenarios when writeback is executed
under load.

