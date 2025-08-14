Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCBD3CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 16:23:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F0A99001A4; Thu, 14 Aug 2025 12:23:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A7A6900172; Thu, 14 Aug 2025 12:23:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41AD59001A4; Thu, 14 Aug 2025 12:23:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 26FC6900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:23:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C7A1EBAEB0
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:23:57 +0000 (UTC)
X-FDA: 83775884514.21.6F30457
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf22.hostedemail.com (Postfix) with ESMTP id C3A35C000B
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:23:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=NO+vLMke;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf22.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.41 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755188636; a=rsa-sha256;
	cv=none;
	b=QcIWOZSBhbw0F59G+DXFSsGqF3xjUQMk5o+fY99ckmKeH+NPG67RnZdQt+2vMcfxIQHc22
	PPjGALd1DjvjAKJ/WfTWp09Zcr4nb90XJiDicVbQJt3PpUR4qoWq3e9NGcKIsuJHU5XeNI
	ZR3QfipkKbr9DSwFQ8lgQufGvYKn68I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=NO+vLMke;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf22.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.41 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755188636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a1XdoI1EB+TYi+GTcXprk2z/DCeCB6Qa7ba6UyBEXK4=;
	b=rOUljKHWfOFES+/lCqQZPpKuABLpd95l5Rhx5Gsh+lr1+6cpe5ehtK59t3x/pzHWr30PLm
	rYH97OZGuGf8Fj7M+maGMFgUfPhKm4uWVjRLeWMyjtUoL/rJFszNY3jzLRE5t5Bkqm87JU
	08UCQ+2067L+sqMLKLACa+brZ4oQLDQ=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-70a9f5b60b9so10671206d6.3
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1755188635; x=1755793435; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=a1XdoI1EB+TYi+GTcXprk2z/DCeCB6Qa7ba6UyBEXK4=;
        b=NO+vLMkeRPGrU+Z14WH+uKjTqI5M9Um6Flp8/FDMMy/uj2oIssY+XEtkU82gu79Iqn
         d7d2P7TnXRRyYKUi8Dbvw6EzHy4styXqhzVGKxD8R7i8r5yNn+0d3Q+NMmZMrDDo5xS4
         ZU+w6+zzRoPUZ5+Rh8bdKiwWSzXPKvSXbgRXYqNMHNEfvAiFo0n/wv/KBe2ClEKNvSUV
         2Vngmqqwv0FqltKB6w4UfVc4+wasvmvuDvAmQ3LBT0YHVPgFTqAkp3L7cy1V3NOI3z9v
         HlwNluxJ9FEdH64TjEfy9SOm1gVP1IipfVH/Lzk9UOW99/5tgcimKA62nNUJyVhAwZk1
         lolw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755188635; x=1755793435;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a1XdoI1EB+TYi+GTcXprk2z/DCeCB6Qa7ba6UyBEXK4=;
        b=rWA66HCes9CzeLl+B9dQXiF7CAtccbZAHyXRt3v8cevYIdC3Badsr6FiNweOC/Jko2
         JDAwJ5a3uAvqAPVHrJOMbNs1svWpJ1cq6xE8QmxahB+ohCKCPpb3dTtsolBJzop7mk/m
         iGwiKcLWsf9deXpswXQanv5JFvxgCTDyrSuKZwzayoGc3SXoZkJ9rhQSTHpoC7qizN9r
         /BGAlXXwE06wsViprE8ke6xq7sruwMJLPzNRc+Yi/d3oR0WwnxJNNCbnCG8hb2/n/pp/
         j3cYs9nZ014mjct1MWKGerqw87rWW8NzdUTuNQ6ydcjqKYeOEX+rsZy8jne1MnxFtHp9
         r9XQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDN9QYOBHc9XNyWi/ph2kLRZnALJeVTyiKPthpOyyGldYDUxK4ABVHQfqq+o/Ox9aEsorRs2lg7A==@kvack.org
X-Gm-Message-State: AOJu0YxvagydLjaxPsXygMiaqpO1t3m4XeFRWVBu5dQMIzws1Rt/VIFb
	AdU9jIP3OIr64ytzUPYhSmTyW7I0mNxX/qdjn56BToyi4WkB9ZBcHsZL3djOv/RJi8Y=
X-Gm-Gg: ASbGncvf/WDZ9XDTOoB7kNAQvuUq+hbswUeSb5C0DI8bXmwJD8QyW3b+VwYUbl/9bpM
	bXzMQj5S3nuM0JF+kdcI3fHZNxF7oz2ZTUR7DgvhkuRmjwZP1te+zlmBVsdSY1/CoftrpLK9r4z
	AnVU3hh/xazGn3REMVBOLL9OOxTxzGY9M92630ZaL8+Tvps/unek3eOg9ey7KuIpK6654aUuFtY
	e/5GNUQcdjBCO6xhLVYoz6jHbcGUA1nq9guchBmtPq8+3q4xjtmeOUfnYUfzV07go8BEXlj9iDr
	ltZARUE37XUhXs48iiW8I4n2eXqzsSpTAvSj2DZf3SN9uzHDdw66YoiSwU6Q17IZJqT9GO1J8QU
	q2uTJQ46BAl62N/x8l9hF/Q==
X-Google-Smtp-Source: AGHT+IHjkmsqLPMIQBReIDsRlz8WV96jv+aEprdBTrsqjSADWIAiJ+wMvcoDhoVHcgHpljyWm6pdaQ==
X-Received: by 2002:a05:6214:2422:b0:704:f7d8:edfe with SMTP id 6a1803df08f44-70b98561840mr41169446d6.51.1755188634693;
        Thu, 14 Aug 2025 09:23:54 -0700 (PDT)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-70adc1cd94csm14860096d6.14.2025.08.14.09.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 09:23:54 -0700 (PDT)
Date: Thu, 14 Aug 2025 12:23:50 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	David Hildenbrand <david@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Takero Funaki <flintglass@gmail.com>
Subject: Re: [PATCH v2] mm/zswap: store <PAGE_SIZE compression failed page
 as-is
Message-ID: <20250814162350.GH115258@cmpxchg.org>
References: <20250812170046.56468-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250812170046.56468-1-sj@kernel.org>
X-Rspamd-Queue-Id: C3A35C000B
X-Stat-Signature: 93qs76wmzp6orjo8j57uixuhf3ihz68f
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755188635-930680
X-HE-Meta: U2FsdGVkX1/2UjBV5jGZFRWw8Bpa7Cs5cN3mPY28qbW8H5LJdGlLUg6f/KKpLiReDJJCiPWHIt7RPGwFQzDeqKcQICjzsScSvlsL/kdRIhfQLz2oddgfaV/gUBHj77LK5WpFu87DQ8J1nTg8xD/n3asWP6MjIek3++IiVM9tPaexIpwQ2tKItfe13pJvgnbsNo9DLFPwhdzZJW9KeEEdu3RdFg1WQsXQ2i44JcGIMv+Kec7c2Te2cAwTZWfTO8BqweuqoNd9WDNQQqSc/GinSk7PZTWEVuB6O/ZCZlDpSpsVyXYXHf47djuTbRz4LhQ339JGrRwqczgO4eBFPv7RpwANR5IZSuoVT17BQZuHzoJc0L+gn05HYSmEF3N4ltbmfWqf6Typ6PXEdF0eUjKn2q6O9THk3y8cLhRBZ8W73hOWPL/7dTOZ9eTajd8igXrGgmzBTYWRZZlos92CZo/hjHihFgrDnxQ3p/p00LrsOxvHyUO861sT0gPMJixe9a0rqb/tHLw1Gr/RhD49PR85JxPgbv4nvEM86eIVv5nsKCxo5oCLm/W5UeU1yOuM/swQ9ll4CIEqAVaqL2Rj5PdAOW9V7YAbgWnJgZxTt+htTfybDM4cCl0Qkji0f1L+DH1JJLsaLpOjIkkYYTTkQV2uierfM7JhVg59w4CivnG0WfnolU4QP8QvxT3lkow9DwWQWGqa8Kke4VNsSv1UW0jsXBizOQT1Vi42P0kr8yqMAINL4PrFyXlenq7GSbX7ZXqABMUdqDyPUEiNMD3zkKaWiGDYYYu4QALtbeKha0ahZjxUKvHid5lE+3DB4l9nqxlCOZrG6Nm1h9/LM/3ORJlC2PEkrgvHne36V4yAo1EfLHznpo0QEnKqF6GdAw7J6yoHR7J3yFruuscPT2lHQZ4xfd5gsh01gpZYcWMXXeAX36SFM4WN3aSq/+LQfuQDP9D+xgqt0Hkq8xHZlfOMVj0
 A7+I/AbL
 2hxQV9bDM+0AHIeNtst7UkU8SJ/ZiN/bINe+/GvAcZ58Jsrg1OlyXopY1mnKmRH8ql1zm5mik3AiUgb13fZ92GWb+9niDqesl78iRlPEuGrXLGiWot8OWHRTG0ahbSkmIDuo69UV90Y6HB9RucG1DRb9HxkAuJDYD0pgi71izjpjzQCtcVlMWSHzY7gSce8d+or8MRDG6+AkYEyjXTE5+c6jfiQOAEo7xE0z1guJRw7kjq0Cqhj7FVum37qcvGbAcEAHJC4WRUb4eajQ6jsfq1kCAJyiNjip6Arv/X83iQVxqa0d2rcrDxFyPS70I0f8VMSD3+g/3MtfEhgYKYkjQZspGSQ4SoHtvPusLC8dmYN2KVGsVfodxvkRxa58UUl0B9Wm6zzJEyuL+axWnnSUt+NNeyGNghOaqJydnk6In5oZ5nesoUpiXLJ0Ud02LNU4uyktjIF6n0H26hjAVRx3gwrbU0IHyTxTj5OfQy7KDlLkGZXv8/w3hE7YI1U00pNCpNdfBcOZGAUFT+UB3TfFA5AdXh8Trc8fSBgMH4ncegM8n5C4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 10:00:46AM -0700, SeongJae Park wrote:
> When zswap writeback is enabled and it fails compressing a given page,
> the page is swapped out to the backing swap device.  This behavior
> breaks the zswap's writeback LRU order, and hence users can experience
> unexpected latency spikes.  If the page is compressed without failure,
> but results in a size of PAGE_SIZE, the LRU order is kept, but the
> decompression overhead for loading the page back on the later access is
> unnecessary.
> 
> Keep the LRU order and optimize unnecessary decompression overheads in
> those cases, by storing the original content as-is in zpool.  The length
> field of zswap_entry will be set appropriately, as PAGE_SIZE,  Hence
> whether it is saved as-is or not (whether decompression is unnecessary)
> is identified by 'zswap_entry->length == PAGE_SIZE'.
> 
> Because the uncompressed data is saved in zpool, same to the compressed
> ones, this introduces no change in terms of memory management including
> movability and migratability of involved pages.
> 
> This change is also not increasing per zswap entry metadata overhead.
> But as the number of incompressible pages increases, total zswap
> metadata overhead is proportionally increased.  The overhead should not
> be problematic in usual cases, since the zswap metadata for single zswap
> entry is much smaller than PAGE_SIZE, and in common zswap use cases
> there should be a sufficient amount of compressible pages.  Also it can
> be mitigated by the zswap writeback.
> 
> When the writeback is disabled, the additional overhead could be
> problematic.  For the case, keep the current behavior that just returns
> the failure and let swap_writeout() put the page back to the active LRU
> list in the case.
> 
> Knowing how many compression failures happened will be useful for future
> investigations.  investigations.  Add a new debugfs file, compress_fail,
> for the purpose.
> 
> Tests
> -----
> 
> I tested this patch using a simple self-written microbenchmark that is
> available at GitHub[1].  You can reproduce the test I did by executing
> run_tests.sh of the repo on your system.  Note that the repo's
> documentation is not good as of this writing, so you may need to read
> and use the code.
> 
> The basic test scenario is simple.  Run a test program making artificial
> accesses to memory having artificial content under memory.high-set
> memory limit and measure how many accesses were made in given time.
> 
> The test program repeatedly and randomly access three anonymous memory
> regions.  The regions are all 500 MiB size, and accessed in the same
> probability.  Two of those are filled up with a simple content that can
> easily be compressed, while the remaining one is filled up with a
> content that read from /dev/urandom, which is easy to fail at
> compressing to <PAGE_SIZE size.  The program runs for two minutes and
> prints out the number of accesses made every five seconds.
> 
> The test script runs the program under below seven configurations.

                                               four?

> - 0: memory.high is set to 2 GiB, zswap is disabled.
> - 1-1: memory.high is set to 1350 MiB, zswap is disabled.
> - 1-2: On 1-1, zswap is enabled without this patch.
> - 1-3: On 1-2, this patch is applied.

I'm not sure 0 and 1-1 are super interesting, since we care about
zswap performance under pressure before and after the patch.

> For all zswap enabled cases, zswap shrinker is enabled.

It would, however, be good to test without the shrinker as well, since
it's currently optional and not enabled by default.

The performance with the shrinker looks great, but if it regresses for
setups without the shrinker we need additional gating.

