Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59961C87FCA
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 03:14:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF61B6B008A; Fri, 25 Jul 2025 23:14:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA6976B008C; Fri, 25 Jul 2025 23:14:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBC436B0092; Fri, 25 Jul 2025 23:14:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BD6A26B008A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 23:14:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 79EE78098A
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 03:14:27 +0000 (UTC)
X-FDA: 83704947774.18.5281EDD
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf14.hostedemail.com (Postfix) with ESMTP id C641E10000A
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 03:14:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753499665; a=rsa-sha256;
	cv=none;
	b=ypHuCRz6cWmOb8fyKOyn+/xAHKuhboCZC3n38Tu55NA/fB8cz+Oi2rQbrJaJnRXUv8Wzua
	Ed44xP+rRWaclyk7IMuQLQPRPUFa3bdj0a/ayLLTRgWY7P9iqukr3wYHRnnb9HEtZ/xnO3
	jrGTOvLOMkdtKa39XfYVmtMv5xRaQWk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753499665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EDVNwv1hR8RhzmgKQwkU4rhanlmUWcHHjsMUFfmj45U=;
	b=hQMdyc3G8bB/ZN50IEx2dNoDe4VSPeDB+Ebydh2HATfiJXXr4qd+U/FdOhu7yCDs6fpiHO
	ie1eLaMHvnB6WcbQk9pgoCBAy+EWGiIv5jsfcKWU8nFflmwmblg8kU25qfAEJFKN0fKVLh
	uV9JaMaSE0MaePBBVSEIgCdwOscW0CQ=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4bpqZ52ypfztSkl;
	Sat, 26 Jul 2025 11:13:17 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id E666B18047C;
	Sat, 26 Jul 2025 11:14:20 +0800 (CST)
Received: from [10.174.176.250] (10.174.176.250) by
 dggpemf200018.china.huawei.com (7.185.36.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 26 Jul 2025 11:14:20 +0800
Message-ID: <527714dd-0e33-43ab-bbbd-d89670ba79e7@huawei.com>
Date: Sat, 26 Jul 2025 11:14:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/damon: add full LPAE support for memory monitoring
 above 4GB
To: SeongJae Park <sj@kernel.org>, zuoze <zuoze1@huawei.com>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<wangkefeng.wang@huawei.com>
References: <20250725202230.49995-1-sj@kernel.org>
From: Quanmin Yan <yanquanmin1@huawei.com>
In-Reply-To: <20250725202230.49995-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.250]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C641E10000A
X-Stat-Signature: w7hms31sxtecxtbscxashhtk9qec9y8t
X-HE-Tag: 1753499664-846002
X-HE-Meta: U2FsdGVkX1+URoYtlfYyhCVP73ULvBMcjt1qrWkSH/STuwl5waLDPH/2RljH/9YfPnBtc+xHgXTh8ZjZXNO2ic+XGarJUmqcChHQXeHBQAvqidQ361LXyp0nTxW0qlFi4og6ljlBlqhek5uMV1x3K67UxsYXuoLWHO3yQQEfw6KQl5eRzSJYCH5i0GlGp2tm0aLcdf3nLy0A0QGJZlgNsP0BArFdMsmmsSOFPSzF5AHox++s8u3UOUwPLGkhWeVQw1VuV9/7sGQTXtlKWmrdOkysVIR9bTRsMUg8/UGyQTK/0Lc3bQ4Iw70AushJNIJq2QrtFRcwk4DD2A1vMJSGFcQvOEXKjYcD8ykCvLh5b2eghw/kXKki3PRnxp/oUzuzQ6lUvzL9ahaDo80frA2JxeyH8HtBwNLUgDNlbHMgt7rf3Ck8tFx591P6NubYcEd+0cmRcxH/+q7KwhkWvS4ncUszz6Nsi+riC1p+6TYzb0UKTJ1VmL34prUdjKxAt6ooh8Jltx7NgD+ApCKFrzJSBqBwslC4mjrV0UlreA7BPWSoFdcA+ces1ccP6mf0jusXe6eY16EAT7N8vCaPkjCwojE1Ue32cgnVxsLIjqmcKcG/lWNMHU7Q1hi7KmNFX2DYCvCxAfs56etmUC3RArTn+hj8oxG2LSjD5PUWvzdkCnjgB1ne+bR+mjc8FKGH4hc4kEknrBdFs5Qww75mI1lwB7b+CLnb88uxmGhGRDmsrAOMLxB8KvSdKD2e8mQA00C7BgGDxypxvvvkyykTJuFe/hp/sYDezWYhv1782gfklSHKNqwGfGpksIDOyRlzDDkaX1t6R8LENOdU68ID3uZ5RKFvmpzGbaV6S3P8NcgbX7SKhbF5U/n63uYii6ObxfW/9NCSG8e4pj7HvHr/SPghA1rXQZTw3oZW3H3I7jGhnRRXp8jblda2d5yJmksH7I43TxMhNOJ/j8OFdsl45SC
 yO890yeV
 irO2aWo5GPEmaiDw97K94PHN2CJbWuxUGt2XDPdbgTlAm/xJzM7uHzegfmkxzlyy4Ksbd421lE6Q7HLfnp3omU1cVgaYPZHqEmBmqtin8ciHtwHEn8Ds1oPtR5elLZMITLD6ob4vKVeyELY10hCmR6A43P2skyNOOQxid8c1qWMP/bxkA54XMojHwiSxm+JWLaqofZ/cCI7JMvqeET1v+fkuI0r/8WqWU0vmC0MZiEXK4CASBiXRPzfC+pURz+FSekN9WZfC/Dit3QzI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/7/26 4:22, SeongJae Park 写道:
> On Fri, 25 Jul 2025 11:15:22 +0800 zuoze <zuoze1@huawei.com> wrote:
>
>>
>> 在 2025/4/23 1:43, SeongJae Park 写道:
>>> On Tue, 22 Apr 2025 19:50:11 +0800 zuoze <zuoze1@huawei.com> wrote:
>>>
>>> [...]
>>>> Thanks for the patches - I’ve noted the RFC series and user-space
>>>> updates. Apologies for the delay; I’ll prioritize reviewing these soon
>>>> to verify they meet the intended tracking goals. Appreciate your
>>>> patience.
>>> No worry.  Please take your time and let me know if there is anything I can
>>> help.
>>>
>>> I think we can improve the user-space tool support better for usability.  For
>>> example, it could find LPAE case, set addr_unit parameter, and convert
>>> user-input and output address ranges on its own.  But hopefully the current
>>> support allows simple tests of the kernel side change, and we could do such
>>> improvement after the kernel side change is made.
>>>
>>>
>> Hi SJ,
>>
>> Apologies for the delayed response. We've verified your patch in our
>> environment and confirmed it supports LPAE address monitoring.
> No worry, thank you for testing that :)
>
>> However,
>> we observed some anomalies in the reclaim functionality. During code
>> review, we identified a few issues:
>>
>> The semantic meaning of damon_region changed after addr_unit was
>> introduced. The units in damon_addr_range may no longer represent bytes
>> directly.
> You're right, and this is an intended change.
>
>> The size returned by damon_sz_region() now requires multiplication by
>> addr_unit to get the actual byte count.
> Again, this is an intended change.  damon_sz_region() callers should aware this
> semantic and updated accordingly, if it could make a real problem otherwise.
> If you found such changes required cases that this patch series is missing,
> could you please list up?
>
>> Heavy usage of damon_sz_region() and DAMON_MIN_REGION likely requires
>> addr_unit-aware adjustments throughout the codebase. While this approach
>> works, it would involve considerable changes.
> It has been a while since I wrote this patch series, but at least while writing
> it, I didn't find such required changes.  Of course I should missed something,
> though.  As I mentioned above, could you please list such changes required
> parts that makes problem?  That would be helpful at finding the path forward.
>
>> What's your perspective on
>> how we should proceed?
> Let's see the list of required additional changes with why those are required
> (what problems can happen if such chadnges are not made), and discuss.

Hi SJ,

Thank you for your email reply. Let's discuss the impacts introduced after
incorporating addr_unit. First of all, it's essential to clarify that the
definition of damon_addr_range (in damon_region) has changed, we will now use
damon_addr_range * addr_unit to calculate physical addresses.

I've noticed some issues, in mm/damon/core.c:

  damos_apply_scheme()
      ...
      unsigned long sz = damon_sz_region(r);  // the unit of 'sz' is no longer bytes.
      ...
      if (c->ops.apply_scheme)
          if (quota->esz && quota->charged_sz + sz > quota->esz)
              sz = ALIGN_DOWN(quota->esz - quota->charged_sz,
                      DAMON_MIN_REGION);  // the core issue lies here.
          ...
          quota->charged_sz += sz;    // note the units.
      ...
      update_stat:
          // 'sz' should be multiplied by addr_unit:
          damos_update_stat(s, sz, sz_applied, sz_ops_filter_passed);

Currently, DAMON_MIN_REGION is defined as PAGE_SIZE, therefore aligning
sz downward to DAMON_MIN_REGION is likely unreasonable. Meanwhile, the unit
of sz in damos_quota is also not bytes, which necessitates updates to comments
and user documentation. Additionally, the calculation involving DAMON_MIN_REGION
requires reconsideration. Here are a few examples:

  damos_skip_charged_region()
      ...
      sz_to_skip = ALIGN_DOWN(quota->charge_addr_from -
                      r->ar.start, DAMON_MIN_REGION);
      ...
      if (damon_sz_region(r) <= DAMON_MIN_REGION)
                      return true;
      sz_to_skip = DAMON_MIN_REGION;

  damon_region_sz_limit()
        ...
      if (sz < DAMON_MIN_REGION)
          sz = DAMON_MIN_REGION;

Now I can think of two approaches, one is to keep sz in bytes, this requires
modifications to many other call sites that use these two functions (at least
passing the corresponding ctx->addr_unit. By the way, should we restrict the
input of addr_unit?):

  damos_apply_scheme()
      ...
  -    unsigned long sz = damon_sz_region(r);
  +    unsigned long sz = damon_sz_region(r) * c->addr_unit;
      ...
  -    damon_split_region_at(t, r, sz);
  +    damon_split_region_at(t, r, sz / c->addr_unit);

The second approach is to divide by addr_unit when applying DAMON_MIN_REGION,
and revert to byte units for statistics, this approach seems to involve
significant changes as well:

  damos_apply_scheme()
      ...
      sz = ALIGN_DOWN(quota->esz - quota->charged_sz,
  -                    DAMON_MIN_REGION);
  +                    DAMON_MIN_REGION / c->addr_unit);
      ...
  update_stat:
  -    damos_update_stat(s, sz, sz_applied, sz_ops_filter_passed);
  +    damos_update_stat(s, sz, sz_applied * c->addr_unit, sz_ops_filter_passed);

These are my observations. What's your perspective on how we should proceed? Looking
forward to your reply.

Thanks,
Quanmin Yan

>
>
> Thanks,
> SJ
>
> [...]

