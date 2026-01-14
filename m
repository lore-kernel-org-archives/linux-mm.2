Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57B31D3900B
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 19:38:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B56E96B0092; Wed, 14 Jan 2026 14:38:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B00F06B0095; Wed, 14 Jan 2026 14:38:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AF316B0096; Wed, 14 Jan 2026 14:38:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8A1736B0092
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:38:02 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 13779BA56D
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:38:02 +0000 (UTC)
X-FDA: 84331580004.04.C37E3A4
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3B6AE40007
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:38:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=A05wz+WA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768419480; a=rsa-sha256;
	cv=none;
	b=sm97DkJTmirK5GDi8mzaBy5Ha7iqmm9c0eKsjLoTMYS+Av4X3+AIb9Znly3pB1YeXU0VxX
	mUKM1NZ9gnEFw22kgZ8p67SNXRDXOqhiZX7KvttEhj3bsw4lqhGp2hqkRoM1YgMBqDq2f/
	DjTnfbbM7jkzisFZsofyLwMZFtOVvpY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=A05wz+WA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768419480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YwU1lBi0rbbP4UG91Q/23aZsfJ+7kter/zQSZfNp9dk=;
	b=ND9fivX+TS4U3VbsmAKsX7//qALdnc6Hpr2xe/CFu7iMUwtKSvDiYdJF3oEC+V8/XebEym
	trAsWI71qQ6hxtLgJvQS7HMdLUPvYIl19btFjx2tZyETm0WEM/cz8OGkhxMLZ+8ysBiV7t
	gcIj8Eu3kJOjIWHNRjI8oM+kIOsKyzk=
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-7927b1620ddso2335577b3.0
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:37:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768419479; x=1769024279; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YwU1lBi0rbbP4UG91Q/23aZsfJ+7kter/zQSZfNp9dk=;
        b=A05wz+WAmYvVfaJFiRW0McfTO7geHhJ2CB4ratzjTle80lBNR1uhLCImGn/3oZvwgQ
         opcchVjDFB//8qIKZtjpBYVNdmlDpXycQHM16b/6AwJUEDnYrGcTkN88ThlVbSQQk5JS
         lP4xIf3wia1BqmubdSW5ncf6YkuVt8vdMLOF9xlJpCq6hL6pvJTeRXWcDcq164mbuGoa
         8zxelsiCdo1fW4a9xQLW4lXVGxxuqrQVkfqix0leluhxLx1dH9b/wYIUK13LxcAczB1U
         gM/CNQR2qy6fgNTHl6N4FuV8sp7QBpaO1cf1+K1+7469KsgJXC5NgYQBkDvfRLW69Fj+
         Jm8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768419479; x=1769024279;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YwU1lBi0rbbP4UG91Q/23aZsfJ+7kter/zQSZfNp9dk=;
        b=m0fFd/hmt27+5VzYPHGT2Tvpn0GCfXAL3G3h3zRBGqqbYnXJSWSKvmPLzOyph9E6R1
         Ngt0kra9eIg+Dg00NQIapjDY07KWW6fBklRRgR3DQZwLsZE8Aj7UzFnjqaRmwjRYlvHA
         qJMs1vC1wFR+1TCVKJWLaZ5fFwmrQvhOI5SDlIPhffNWSgvyQyReJhyMrqayGGiBGJ6h
         ADAZDmIZKDJkGBRSkvA2hc3Tn218HdgDuwtbF+zSUt5SRGmC2ZO+9dc9vSHKrcGeGQVk
         /+qY6VV9BkGLo/I6hCEAg/xAj6g/EHfsOIVfBNY+QlcAZY0rn8T5ZWFgI1ZsCyxuZ2GC
         oXBg==
X-Forwarded-Encrypted: i=1; AJvYcCXA9mCUd0dPcGTjB/mu1nwZwdJJ4M6HscSpZJIqJHSFOG8RpiM5jhWgbMXtqNA9gR/aB4ebiIwI4g==@kvack.org
X-Gm-Message-State: AOJu0YzQjvWWvYwjA7lxsZ4zcC/8WjuViPUolK+iw6FTu2ovm5VXX7GI
	23xE4Px+XpIhbsBU1g3/GRbSpxyD6xNiViSmzeiFo26W0gUPjyEp/3Lc
X-Gm-Gg: AY/fxX7UFWoJzlFk1S7KTr9aa49GgCDDfer2NPFglxERWQhlrM7TESYCbrmYza4KvC0
	E8I8Y7mr+LBNWG4F+H9iDPM2bRb83K4F8rb4jEOdoZG0VfNNpIQ8JWuXqJGTmrcAoGov1eSUFkz
	lULt1p4N0BkRCf/n1emv5X9A+DjHRPgt5AwZtW8o+LegeJo5ucg9F/mLHju82iZ/IgZYJfz4b4m
	PsFlltFgpinMY4s70AtMhdOGV2w56AKrnxCRTU1Uzm5noIfg+5fjzvz5RWIr1l+J+rZqTBNAK/H
	62etstYgwPF8W7NDni0RsL3dMDszM7ci1TSZLhFO2JFAegb6vW+Mkz1HpGYIQ6sLNQotTF/yFIj
	kHtR04u/h70zM/DelJUKeI/9xw+/G7uIR3rtWEFRwy5DWWOBvgOk698LBlMCE9ZjfEtwt29HePs
	3mEYP5lkUECQ==
X-Received: by 2002:a05:690c:6101:b0:793:ad45:8e8b with SMTP id 00721157ae682-793b34b7537mr6350897b3.19.1768419479114;
        Wed, 14 Jan 2026 11:37:59 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:40::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-790aa6d93d1sm94111507b3.49.2026.01.14.11.37.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 11:37:58 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Yury Norov <ynorov@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alistair Popple <apopple@nvidia.com>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Michal Hocko <mhocko@suse.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Rakie Kim <rakie.kim@sk.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Waiman Long <longman@redhat.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Zi Yan <ziy@nvidia.com>,
	cgroups@vger.kernel.org,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] nodemask: align nodes_and{,not} with underlying bitmap ops
Date: Wed, 14 Jan 2026 14:37:57 -0500
Message-ID: <20260114193757.3337985-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260114172217.861204-1-ynorov@nvidia.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3B6AE40007
X-Rspamd-Server: rspam06
X-Stat-Signature: ezhc3fxphtg8q4otdwkjkg7iwbgqirx9
X-Rspam-User: 
X-HE-Tag: 1768419480-865481
X-HE-Meta: U2FsdGVkX18/0MA67HFEhu7X+VYMk4dxXBNMBxbeg1hFPw4QuWrZ26RHYyo8/7fxvfS6/DiZ49jwwWR/thc4C3v8LttdcoAzOZ5+TzhPM2O5QGrq/ItH1gA2bjWQEU6A9awtGDui4TevfpX33YCSR5PzpQ8d2vVvPnFGC3y6flHN8XeQzQINXHkrjPw7GmWksqI+xqzMWdor1xm4uO6inz2FjO5UKg+KFW9KUaJ14UXGTf3HtKDYxE1sRWYSkygyuX/Nh1jcmBwjSCWQZ/7JKYJlrUq4ZTF6LGVlxIHYOAUDCFO0tVdNFlCrg//cU0d84qbq6ZljQdL+E+miaD0qazZb7bgy0RQLvR5lvE1c4zOkNhwcLI2wzpgcBt93tPMq6en2ptZhn4p89AkfGcMhUkBz9IZbBP513Ey2gkztHJHwxQwPtt7n53EWHRXbsYr66rCHXj8vsL6gAUcNPw/SslhrPIFVJu0VsiaGXyoD6uhQ4r7Sg4lxjXCdY+4jsBdP6yc4wTe0u6ON1ZiOM7gV4Vu6XH4EYDPui7iLOdXUReGZ9woOB1kMvJrVUFatiH++aVW1tezZMc8d0D9J1Y4pxrJB7BvEZbeWefvcxZ8ivnVmwDFYiNhKDlD7ly78oOUEsfVyPJTWAAe9W9YzGsqUgIqHcLSDdM6dymZfTRZ/PxwwBWPiaQevp7qFfUbWW5Ich1Ep1uuGKGKT3bZ4J3LvRY/yABB8a4ilUHOH4FsjeB3tFSqdT2kaY6pqnxTc2iyP82s6YdR0LqWLL1CwOOBaK73ymvGZ4N79t7qyivjW0spF5wvPTiJqnQEFRqgMlWM8DwAQBZhhzOWBJxKGkHqpfxk1WzIthEdreD9lgEeu9rIDvq7y4a5crXlkooPwYy2aLUOmiGvB/ojnd4l2jclfHMIEJNrsep5PaFfm3gni9yGdMch+FaA/Ml/OrZUnweNYh6ER2gY5eT4iSC9ewXZ
 oRpAY7eH
 SrRlyhDC+aScvr+AB68ZJpf7aPvLCHWx+nc0LxC2PLMo1jKuZ1ELzot/NJzxnK0FD9VacHp+/doAWqlpdG+xjYv4qmJd2l48B8wqVT1ILDjTmVqPenqDXG2hMnc7XzYd7eUSo9ISeYR8yAIstZobmZ/gPIYylmq6Zki5LZWcLol+Xp1WRp9tQAA4L2Gb3f+RJb2HErq3nGeP9Ni/nHYBGXQdjr7NaYM/mPP+EV5LATkvLxFw0APm4hBj0BXEpQzsiU7rcf3ZzWeamJBtaNMjWEMoTevrxhQKb8KAVZM0tEsyc7LWDWU8ZJkDS0O1jSn8U340dE8iz5o45itdzrw6fDEx+ES5s+7Q9RjGUFRwPQ4GUrneiGbwm2y0qsrU1q0dyHMWxLsnz52q8afVbX8zzrt67iez+Bq4hKMUCzJNjRxuy9RGJ5DGnR4oTrjWTqEw5hZ2CclWxNqd70PdIaVANRIRtMEAoeJj+OCdlk+DTRvV1ke5SmVmJSddyh1mj7Tx5FKM0erL/nqj530M25NCPDjFmmTFtMaHT5NAHeutbq+xkYbYpZ8SmNVPKJccKqPAnixK3bqiO8Vs6L9GOsEe8l41akZH1qnn8Qi/3yeJfwNEwzkOYlLil2ICnfPNhLSom7L5cfqKBHd20kWQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Jan 2026 12:22:12 -0500 Yury Norov <ynorov@nvidia.com> wrote:

> nodes_and{,not} are void despite that underlying bitmap_and(,not) return
> boolean, true if the result bitmap is non-empty. Align nodemask API, and
> simplify client code.
> 
> Yury Norov (3):
>   nodemask: propagate boolean for nodes_and{,not}
>   mm: use nodes_and() return value to simplify client code
>   cgroup: use nodes_and() output where appropriate
> 
>  include/linux/nodemask.h | 8 ++++----
>  kernel/cgroup/cpuset.c   | 7 +++----
>  mm/memory-tiers.c        | 3 +--
>  mm/mempolicy.c           | 3 +--
>  4 files changed, 9 insertions(+), 12 deletions(-)
> 
> -- 
> 2.43.0

The entire set LGTM, thank you for this patchset! Feel free to add:

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

For the entire series. Have a great day!
Joshua

