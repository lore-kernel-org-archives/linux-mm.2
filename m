Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C650AC982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 09:24:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9178A6B00A5; Tue, 22 Sep 2026 05:24:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C7476B00A6; Tue, 22 Sep 2026 05:24:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B6B16B00A7; Tue, 22 Sep 2026 05:24:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A3EE6B00A5
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:24:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C7051A5DE9
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:24:46 +0000 (UTC)
X-FDA: 85240863372.11.C18DFCE
Received: from mail-pj2-f3.google.com (mail-pj2-f3.google.com [74.125.227.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id E09041C0003
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:24:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WIKa69t4;
	spf=pass (imf20.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.131 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790069084;
	b=dI7JsIZyaH94TZ/Y5AhCI/UV3Ii3eux5VMAS2t9/YjRIWn82ojGWchlGqHSiuSvsgHb4M6
	SPWsVJFgad2rLKbIvIUaZfv5oTiiSGybgPIbKTR9kFjqgF+6iANcJByaoWJS41PBpyRqKA
	NB+n/ZZ/b3Ht9/2wv4EuLH2nHcRS+Ls=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WIKa69t4;
	spf=pass (imf20.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.131 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790069084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XClesR6PCgee5pL1QNRk08L/1yXOaC+odjip8AQtXVU=;
	b=0pkK2PrJ4ZOyhas078kfrEKxgTdHYPE+QD8eRT7ziPyXVehO3y2Ir/XEik1g/pP8zXvNbw
	q7RmLABXOQHf5km18ptST/loEeRsBCh5yuHVg7LinTdXSXUylKVUtQdetIuv+uwl65/44p
	eHwM5jVhnyM+FaMns0XpiTwOs2u6vHE=
Received: by mail-pj2-f3.google.com with SMTP id d9443c01a7336-2d6fff25530so21494985ad.0
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790069084; x=1790673884; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XClesR6PCgee5pL1QNRk08L/1yXOaC+odjip8AQtXVU=;
        b=WIKa69t4KZPs4hd2elqDG3PJR6YoSpx1Y1rDaot7PX5JARWmhEsh8A4xbYTMvp7f4a
         bAZUGj0TBJmZ52pDKGinFdIQB0Hq/04szXH/xvEaCEU4/7b0yMJ1qh8g8eff8drxo1d9
         NDpjz2xpFY18c4rCzJQ27qsVdAHTsqP7L8RYzgjWsJWSsAumFNxhIQZrdK2gH5Yuzk8a
         TNA5CUhklOYiqecrPDWyqH64Mv2htCH5efOYpiqop8pa481Rkq7yboqDJ9rhCk4gTjkb
         83k44DfPWoAFcHhFe8gULLLrWnknudeL7aXWhCl4Y5TsaMu14Dm/6Xxc1ntphrG1Q03d
         XJtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790069084; x=1790673884;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XClesR6PCgee5pL1QNRk08L/1yXOaC+odjip8AQtXVU=;
        b=0c5KaIQiZaNK7rg/1gaQYMbKfgo393hXzUn+01tF3rbZaIc9aXgLHrQ9gQ4oLVgcpN
         GWHbW+a5cmVgJhWrwirI11UihNLl/arb+M6w0iada4MRp7+pn2zKRfb+HoRjjIjC6k0/
         8CE93+BMWq0VZoqVEjYtzDsKmJNg2UFOjnfxikOjluVOGRjRtYfQxP+q59mftb2gn8xi
         fPP6ZGp8QHNHVqauunYWPdSqyNpFqpqHpGXKoQSjWxVwQx9fND3YLwoMEo+l84fB25Ch
         FvSgGuRSrIWz+5Gah9LhZEKYpXYNjCaOoRraH9fae2PW4B5v6V/SzdgeWWiiWOzhaHWO
         kPgw==
X-Forwarded-Encrypted: i=1; AKwUvBzxb/WHBCCE0rqUS0rEdnDXerRI8XNrBCB8zj/fjsMRAa9g8PvDA4ByBc7BGT39SA+cbW/9LSF2ew==@kvack.org
X-Gm-Message-State: AFuF++kHTXBkBM6vzq6hqnw8HASYHqjd12nZ7mu872KelVmEJ7HIwNaf
	yOPl+bnjtv1+9ir8CT6EPIU+L+J4HIWoADwKdn0GC2hJpZzW+Mk64CQC
X-Gm-Gg: AYBFou1wsLuqbyJ2EI+uu1xhK520ruoryn7k17i4GTgKvpZn7LmBiym10P9pfjBKz5M
	HhjUl7ZU5MVEjOpwXhJA4ywvo42qxKHwGdicI3ifSPHloKihWWX1ouqRD30XjdkdNk2+FOMiave
	CGjIp1bBch6AKhZcazjpqV6v6XKRbxsxqhEAr84jcs0WWd3FdW8H5YoENpN3dCmZT6PYARQCCfU
	j5akKeK96Nqz9Upm5oroOdTBK76R9Q9Q/QwW0Q/QqWjVJhr0/dDQih7va9fZE2259IDo95qYpJa
	NCvS1Ffbr/ehSmyoEMUiyWuftKMRvqe2l6UcOXbHlR4JFM4ZDZpw1wEjxIwneL+LgFPrxu/wdug
	bnN7xH8LF2UIzDyJDRvPfM1HLJMS9f61qM0rVHckmLHeOTV7wMAeco+llroi6MaZkrV9A2wQeSn
	nqx0e+Klgo4QlXS4Sb2sCY/e6i/RkjNh18VYPUBKEepiKMDsiXij7CMhBITZfEovUVxzumumDs2
	QOgLQ==
X-Received: by 2002:a17:902:d592:b0:2dd:c100:80bb with SMTP id d9443c01a7336-2df60b7e838mr5983985ad.54.1790069083577;
        Tue, 22 Sep 2026 02:24:43 -0700 (PDT)
Received: from [10.125.112.20] ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df5d02fb15sm6848565ad.40.2026.09.22.02.24.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2026 02:24:37 -0700 (PDT)
Message-ID: <060fb694-ba1d-40e7-8a18-f32d5a4039ab@gmail.com>
Date: Tue, 22 Sep 2026 17:24:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/5] of: reserved_mem: several fixes about reserved
 memory
To: Mike Rapoport <rppt@kernel.org>
Cc: robh@kernel.org, saravanak@kernel.org, m.szyprowski@samsung.com,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, akpm@linux-foundation.org
References: <20260920092852.614973-1-chenwandun1@gmail.com>
 <arJA6fOMetzoBhDH@kernel.org>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <arJA6fOMetzoBhDH@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E09041C0003
X-Rspam-User: 
X-Stat-Signature: xu4tbeai1m15jzkg8uxmo1esfjfymimj
X-HE-Tag: 1790069084-293071
X-HE-Meta: U2FsdGVkX1/fSeq8KALQOMPGDx5/YZPcjd6Gm3/T3w/5v8egCe4ET4nuyZ5U/XRkIdXGMtcAXvWjTfEDlzpfV9mZHGstMXKIel00g2idM0vjdS3JTIqm/Z7A9cYMipBO9RblxyWJAe+vy0B3BwUNPIP2pGE32OE+G5edjWstdWziemiK7umYlgqliB3e5R+IRpLh+0YMRzNRAN78ln4Hwu3T4VeaK0l6dtUY5QfD0eXkJw1oCoAdU2MbSc5LBmXI9r/cUejiy/axnPWewjS6AxjEAM8mH9k/PNxr22DlpWkj6caj+inPGw/JowpUgm6HvOmaWzrsxTR+gFx0NoTfE3U/AnHMnkm1Q0a7p8O5xPHMy4S/x6Hh4nKedQpTucygbnSk4tbAsor/kIfSKsk78mVRqfyARBn23DomnvKFPeFmHfK0b1yF3ZmRMIfIHaBo1qzLObzvPFyumonFNYWzESozU3B8wbAaTsjrd6eQ3L1YPW3NtByCS5BZKw+gzchnjgVPCyy0RlfZbpGyR6ATNp+bToxXSi8zkALK1esGy4EHXe7rYj0iVVzd48FYHCho2BBICdDrkWhL1jXOIrlv78+PddopsHihaANINCxToOUwJj9VrQ2WTNWyFUldtKNEE4nhx13jCYZMPoqs7cMYsc4mvzuseHLJCd6T8+bIMtDqMJK9VAlLcbSLvePL0m+CFNW6G76EIgfj4d8jvTG9R6hJwbdIkom8OWREYpyauStup3a3OzPJKA0FJtQxpYFGOGiS9nuTb/LBZuH6pN7adcZu1LLXu4gZf9zvFYmMkfeR7zlLqLBujuHTgUymVsCVN+inFyrHCGiTU+u+4hiRqkQMAWhv7TPop+7AzM6NcAQRlGzsjPsB09nNkzmMbXzUUOh0I/+6VjPn/nTbxXvixJwCkEcqvdPpHU9efvrGYdZUPQgQ3Kbv0C66X/K9vS7Nfa3M950ygzmmTSw7SpG
 2v7T8LK6
 iDarqwmGoxaAswKtIPOvgD4Q1MVl61BoOqWSGuUmq1uNSlB1PV2P6Brb5juMj0NrPHi4dKWR4B6HnllRkXJMiqQQ+LlpToCGk7c79hDSc0DTNWo5dqcjezZBsJHwVgOeKyXu48AaNsXZ61LREU2SqiuDXTAxg9toLmYO+/DBb1dOyXT+hLf6KKxkv0T/oXhAwB0HZ5VxxsIi+d74VNo7ENMWj9gNHzzjLRAgmXfUzmEuEpgs0JdnqZcPEbZiLYxYcnWZj7VSQyIyOUL22KTsD5+4tLengpllSngYYg5SZqE1DnhWQq+t2CVXPW4cmkdc5F9zYgnCQspguRw7eZ24FbSmzHQfmRdUy6iEBw0RvalMEUfyfkf785VDbEDjqydZaL9tvfPeVjs6IxkVjV+BcZv2BC1DGxjZDHFcXnU/ybvEbA5ECJ6Qq13qK0jk/nubdr4H3yddhFjytLnBXKvUNohkAOZO8G++/67j+MMlFI5kNJDtcMCGqvDRG4JbQtsrmiDv9QHhVD/O03iWoiLYi5CxWwt4AqwTqUj+Jd27/Q54n6/6lQ0FJDWR7Bu+pfoh1cqWs5e6cOGc7Q42CLj67BAaZlZSMwSQFgzXXRjAYHOpor7U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/22/26 16:48, Mike Rapoport wrote:
> On Sun, Sep 20, 2026 at 05:28:47PM +0800, Wandun Chen wrote:
>> From: Wandun Chen <chenwandun@lixiang.com>
>>
>> This series fixes several error-handling issues in the reserved-memory
>> initialization paths.
>>
>> The first two patches fix cleanup of no-map regions after driver
>> initialization failure.
>>
>> Static reserved-memory nodes are reserved during the early DT scan but
>> initialized later. The third patch tags regions whose early reservation
>> succeeded, so the late scan can skip the nodes whose early reservation
>> failed.
>>
>> The last two patches reject overlapping static regions. Without
>> these checks, overlapping nodes can be initialized over the same
>> physical memory, result in data corrupt.
>>
>> Sashiko reported these issues in [1] [2] [3].
>>
>> [1] https://sashiko.dev/#/message/20260814090305.4C8741F00A3D%40smtp.kernel.org
>> [2] https://sashiko.dev/#/message/20260814084718.29C341F000E9%40smtp.kernel.org
>> [3] https://sashiko.dev/#/message/20260806100605.2C2C01F000E9%40smtp.kernel.org
>>
>> v2 --> v3:
>> 1. Rework the mechanism that checks in the late scan whether the early
>>    reservation succeeded (patches 3-5, suggested by Marek, thanks).
>>
>>    Patch 3 adds a new memblock flag MEMBLOCK_RSRV_RMEM, which is set when
>>    the early reservation of a static region succeeds and checked in the
>>    late scan.
> 
> Can we keep this local to of_reserved_mem please?

Probably not. I do not see a way to keep this entirely local to
of_reserved_mem while handling the issue robustly.

I previously implemented an approach in of_reserved_mem that records
static reserved-memory nodes whose early reservation failed in a local
array [1]. However, the early scan runs before paging_init(), so the array
cannot be dynamically expanded. If the number of failed nodes exceeds
the array size, some failures cannot be recorded and the issue remains,
and that is why Marek said "partial solution", although in practice
having that many failed nodes is unlikely.

To handle this robustly, the late scan needs a way to determine whether
the corresponding early reservation actually succeeded. Current approach
uses memblock to retain that state.

[1] https://lore.kernel.org/lkml/20260818092420.2859026-1-chenwandun1@gmail.com/


Best regards,
Wandun

>  
>>    Patches 4 and 5 are reworked to reject regions that overlap or are
>>    contained by an existing reservation. The code makes a little different
>>    from what was acked in v2, so the Acked-by tags for these patches are not
>>    carried over.
>>
>> 2. Reorder the patches: the two cleanup fixes in v2 now come first.
>>    In v3, the first patch now introduces the 'dynamic' distinction in
>>    fdt_init_reserved_mem_node(), which the following patche 3 build on,
>>    so the series reads more fluently.
>>
>> v1 --> v2:
>> 1. Rework failed-node tracking in patch 1: do not track zero-sized nodes,
>>    and keep a reserved_mem slot when tracking overflows.
>> 2. Reject static reserved regions overlapping existing no-map regions.
>> 3. Keep MEMBLOCK_NOMAP flag for static no-map regions when init failure.
>>
>>
>> Wandun Chen (5):
>>   of: reserved_mem: release dynamically allocated no-map region on init
>>     failure
>>   of: reserved_mem: retain static no-map memory on init failure
>>   of: reserved_mem: skip init for regions whose early reservation failed
>>   of: reserved_mem: reject static regions overlapping no-map memory
>>   of: reserved_mem: reject static mapped regions overlapping existing
>>     reservations
>>
>>  drivers/of/of_reserved_mem.c | 86 +++++++++++++++++++++++++-------
>>  include/linux/memblock.h     |  7 +++
>>  mm/memblock.c                | 95 ++++++++++++++++++++++++++++++++++++
>>  3 files changed, 170 insertions(+), 18 deletions(-)
>>
>> -- 
>> 2.43.0
>>
> 


