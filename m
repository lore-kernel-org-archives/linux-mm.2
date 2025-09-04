Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1C08CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 14:26:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BFE48E000B; Thu,  4 Sep 2025 10:26:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 297AC8E0001; Thu,  4 Sep 2025 10:26:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D4C08E000B; Thu,  4 Sep 2025 10:26:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 08F458E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 10:26:36 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A5A48C024A
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 14:26:33 +0000 (UTC)
X-FDA: 83851793466.13.C630B42
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf26.hostedemail.com (Postfix) with ESMTP id C0B9D14000E
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 14:26:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kQb5FbqP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756995991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qTgQLjBIW7lPOusdEJqLpzeRTo29WK5+8WCp15seT54=;
	b=TRh4bO0Bs7C3VS96wOTajM29+ls93699R9+0TjT0zhFG3t07Lx97YiZYvbIxMxVlAHWmT1
	++AbZot6TKJeQVA+fSWP+6YGkrwaef34OSXc54Zown9V5fmD9vjfKEf0TOwhiUF9OySrc5
	W137vbLBoJP4w7BCZpoZtWIRF2kLU7I=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kQb5FbqP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756995991; a=rsa-sha256;
	cv=none;
	b=vN/fRfm+WDPvXq39iSzzVIBqc2L0YBKJ7VV1l/K2JxoUEbYYmO/XdbHsMTOgiW63x2klVL
	ajGaPmSy/8Nh0+KWgsl0BtLF4xbgy/tVzXhTDe1mdo3ssaa6v2SUlk53Htu8fN+xcYqv10
	8tqPxvhJARSZ0WsTQxJLuw0AhHH1jJQ=
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-71d71bcab6fso10683467b3.0
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 07:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756995991; x=1757600791; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qTgQLjBIW7lPOusdEJqLpzeRTo29WK5+8WCp15seT54=;
        b=kQb5FbqPzXoB97tY4wwt5kbCi8rdsbX1XLBkR2P2da4+CgwLyfmmmmmU5kweAyhr2w
         lUBBWlDvOWUeoTmjKB1Gp3/f4vym0VfNcj4bN8lbsn80UGNoIOCjq1FkOhL3UoO6UGS6
         Xq75dWCCvEIru3ItVmjfIKs+/uPTjGw+M3uPuS+Hz+rZf9NeGL06r1Y8KwW5vOb2bo8D
         4xJW20F/fuSo792/FDAt0heuj3UMbkI2QW1ZibTULyulOJ7VU7ve2K1OussgRjIUx3+6
         bi3U0YOT8ZsC3IU7luSKJZBoR0zb9uAG5xEXUsLxi8dAVVd3023MDkyZE6+98e12xvEq
         hIOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756995991; x=1757600791;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qTgQLjBIW7lPOusdEJqLpzeRTo29WK5+8WCp15seT54=;
        b=Czl63T7hjhFTKi1NeVzQJcxdyoBQ8wdh/NIZTSru0x/hCNw9slKMHi20YEdEPvYpYR
         buhN2J5h8ZT5Pq14NdjZlpd+kg9HA97o8s3HsLv3xw+C8Iwx4SZHJt1+AYb/xt8MtrZN
         yi4muWbLZ3zNmzLpQn0Ox60h9qcbnCt076lV+tUi4wYw4TbP9JS5/hkALGDYbIKtTMDf
         43rC51dXbptPitQrLk1TJQO2ewgkB7mrEHXLeRNP0P6EP3jjwADS5/dRAga2ASgkaXvC
         TmQEKpCYlaoaWwxINq2wDYe+ZpvpCHY8MA94y4MnrVoYEcMnPLZky+HtBaSkyoWoGUls
         IoaA==
X-Forwarded-Encrypted: i=1; AJvYcCW34EL2LfVRytXUYev6F1/gZqqNhFIrZyYnP5fXMQdKRXK+srNyR8bTX3ZMC7DEAUCYgVctjfT5mg==@kvack.org
X-Gm-Message-State: AOJu0YwZCNAwpCgUIzJCE35xKg4PH819jsmOs6qikrW9BMX9ILgxgd5C
	odIJw/M7yXN8RxsXni8xvaPC84H+hom5A3Hy8Xgnoo5n2hoefykGvlxh
X-Gm-Gg: ASbGnct9S1Fv60hAe99R/uVaFVJ5cgNlFvFuhp2Nvqp/VbqMF/mDvPLqaIrTl4WwvaZ
	TtnVDy9mvFXSIG88dIUHlploGaEn7EzznHnberM3zDy4kgjwhuE8Tp13qbLtlSbgyHRMy59D1Tm
	siImlAcYjJh+NQMJJs9gd4V7ddR07JvR790+XKD5mtb9WYJ8RIJOULXyiJCQIQEi2L9P4lt2A5u
	D0wVxZ549KdOr6K2voyVrIfEsgyu2AUYKLy62g0RytQ0ciz0i0fZjHbHNu7Q1WlpzhaVSuxD8au
	weUYi6T4N2hl3UXj0DR37FZg92oDBpJEce68AdrTVxrRyGSkDvM9N5mm46Sc2/GEFRhLdwQYMWp
	Ao8mDmcIIDoLof0uwmhAMemtUE1tjnuShAnXKHxEqc5cN1uNIkJAf
X-Google-Smtp-Source: AGHT+IFV6wA24+bQQZ6qBwrdls0b7LMXfpUQ+tRFu15rQD7QX1y0pBmouk0/ogZn12e0oam2DiItZg==
X-Received: by 2002:a05:690c:6e93:b0:720:8ff:58e5 with SMTP id 00721157ae682-7227656a369mr171254947b3.40.1756995990496;
        Thu, 04 Sep 2025 07:26:30 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:1::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-5ff8555acb7sm1602886d50.1.2025.09.04.07.26.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 07:26:30 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: mhocko@suse.com,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	akpm@linux-foundation.org,
	david@redhat.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com
Subject: Re: [PATCH] mm/oom_kill: kill current in OOM when binding to cpu-less nodes
Date: Thu,  4 Sep 2025 07:26:25 -0700
Message-ID: <20250904142626.1146459-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250904134431.1637701-1-tujinjiang@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C0B9D14000E
X-Stat-Signature: euz3hda8mk6dnwwmn4n4rdnp68s9tyci
X-Rspam-User: 
X-HE-Tag: 1756995991-989106
X-HE-Meta: U2FsdGVkX1+5SBZTalCvvLaGUvbm/kBF0EPb+o2c5k4rxzTOEtERRKbyHWniPdd6fkcOwSsujxwxY3y5w1eDGXJ0H9Ze0EUlMIl9VTW5nja5YE9F7pRDi9n2qxoqw5LG3Oiyag8Hk3l0cQ7X/qu3HqocsA71wMRScpFGcwIWOinDruGJHZxoLlI1CLw8Z+hhF707KLjQQQZowKGGKgu+eSY5E6wSr+MND+PqE6ZK/+38/2vgEEv/0BVqzLbMA+xoI3+cClNXprfaBe5Q94T7e8lh1zb+iBUdSj24UrlvrnhXr96ZYYzkLS0YbiRMbBUozS9Gs9G9cc64RqE4WaEmv737aAOjnboRmixx3XhpPECWDl3ZJgbs3smDyF2g35DUfUsut9DQ7ar8aAzx0gYxAA6GheH2mawKdTjJjLUmlGM37jz0tebGHNVDpdvGZY4hkq87gcA3XQeC0eDvFJzkAxv99kNgIBL+6jB8DcuXsTptYIBGs2hSSqgQQV5DwbdfALcLCV/03vRTQVVK4u+kBFpSKxVUl6npWBdkcCwXYDRnT+9tR6mGV/tP1pxTuPrCPoex5e/CAJsO8Pj7XIXydQEMSGReBX6nHIwOSSdS4HqEhaT+0oAZdNSIqwVr0ZSgXsmtENt964iOkbee9s9vk4eGk6U9nQmrmMEHYjm+N2HTpUWWLqXyV/TVp29GwUsRTwz70G3UU7npSXKUG47WIVRIfL/k0GZht3sG8g9NWee3V5ktyJLwxmssr2t5TDwz04E7KTbQ4BgDsAaV25a3tWCb9J8ihhRDqIQzdp/uEc1hg6H4656N9k6++6Q2H3KzeknqqnuFC29t4XlgVv0z0eWUruNWmgu1/1/Unf9dk8uwmT/+sKfstWqUp8qZnPiVetyQqB2aRp/wotY/qSBYsT4WrdPOz54oec27Tf92UWMppUyuULAHQxFubhJ+AQ34Pj+gbhY7dsjFHfC1VbX
 RXOtXvgL
 k1e5keJ1kYUgU/kfrPRTUqNRrTqX54twTo5UdjwQNGmIJgyqpS/d0OdPyPL4LfjvlYnB7H4AWd2XG76y2ySX7Wi1dg4eKZhCx0c0fV+GdFmUaQ9h5AVcriST5Joi3l1POH3DhKtlt2eeBrdhXPOnZa8RWxpPECXFkfeCqBMprHzLVisQHEMlPt+t9swpyUvxJ/QhotXQONBx7Y6NNN3K67OicIp5wjOnEsnn4KqQGbyWvFCuo/GNyER9hYwBqqCBvdoN4FT1TW3JUpimW5r6ezrAkTlzENAu+JvcYGu76g0xh030C66Xi8975UhLJq/2Sm7nNm0LmUHG+JYjyPn+NMqhJHLD4TRufY/Ps9sESbUmzc5joGFUCHP0f8CQBs7eI+Ma/LXBoBwKIhb7OpVQi4FGtqXWl9U8Xm4J9UvYR5E/ztyoDyE5yiQcRq0uYR2Fr9wTeddZT/qp9Fd2Z0HQzFrWSaio0zFDKKZDRUUvh9MAJDR2o880nqPtmRbRRT/osVB+Fv2w4TXIUKqFqsEWv0t6FvbhmLGKZQPCFXOQFz3I+pGZMCkfXOx7EMRznKYv+x943K3aNQmLEaPzHLOuAwyAbxVsK4TZmlwRaP4GDvk1z9FeiHJZ03bgS47uPrFTBlv2s/NqdspNAXjg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 4 Sep 2025 21:44:31 +0800 Jinjiang Tu <tujinjiang@huawei.com> wrote:

Hello Jinjiang,

I hope you are doing well, thank you for this patchset!

> out_of_memory() selects tasks without considering mempolicy. Assuming a
> cpu-less NUMA Node, ordinary process that don't set mempolicy don't
> allocate memory from this cpu-less Node, unless other NUMA Nodes are below
> low watermark. If a task binds to this cpu-less Node and triggers OOM, many
> tasks may be killed wrongly that don't occupy memory from this Node.

I am wondeirng whether you have seen this happen in practice, or if this is
just based on inspecting the code. I have a feeling that the case you are
concerned about may already be covered in select_bad_process.

out_of_memory(oc)
    select_bad_process(oc)
        oom_evaluate_task(p, oc)
	    oom_cpuset_eligible(task, oc)
	    
	        [...snip...]

		for_each_thread(start, tsk) {
		    if (mask) {
		        ret = mempolicy_in_oom_domain(tsk, mask);
		    } else {
		        ret = cpuset_mems_allowed_intersects(current, tsk)
		    }
		}

While iterating through the list of candidate processes, we check whether
oc->nodemask exists, and if not, we check if the nodemasks intersects. It seems
like these are the two checks that you add in the helper function.

With that said, I might be missing something obvious -- please feel to
correct me if I am misunderstanding your patch or if I'm missing something
in the existing oom target selection : -)

I do see that with your patch, we avoid having to go through select_bad_process
and we just go straight to choosing the current task, which I can definitely
see as an argument. But in that case I think this patch's description would be
more of an optimization, and less of a fix since the behavior is already
accounted for.

Again, please feel free to correct me : -) I hope you have a great day!
Joshua

Sent using hkml (https://github.com/sjp38/hackermail)

