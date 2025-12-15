Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF990D59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 01:40:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCBAE6B0006; Sun, 14 Dec 2025 20:40:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA3A76B0007; Sun, 14 Dec 2025 20:40:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB8F66B0008; Sun, 14 Dec 2025 20:40:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9DCD86B0006
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 20:40:14 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1DE27BE1A4
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 01:40:14 +0000 (UTC)
X-FDA: 84219999948.06.86BBD3F
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf02.hostedemail.com (Postfix) with ESMTP id 86B2280010
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 01:40:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="zR2/KQiI";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf02.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765762812; a=rsa-sha256;
	cv=none;
	b=IfWjstMoTsNXtBb7ak30XHifw0QD4lYD24PFcHXrKRNiqdh4aV780L1et9eQZmD+zpWQSl
	XubmWZw+lqFWE+0L+9UOZtYzFJPe888ZhxCJvjP5/5pnaDtGGoyp21SMR6HYL3ipZP62be
	d0Nw4gaSRhXreYXvVD4WGHmSfUxZEgQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="zR2/KQiI";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf02.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765762812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZNeQJD5QvAEGKkBmP6xEF4EhUiUy4x2JIHmkUYpd8Uw=;
	b=H6u2q/E/5edFB8i2arrd3UUNP8yKe2xeivR2pinGkLV4/5VingUjLIRTnJNm9nW47dP0f8
	l2sojriFsO2cU/kQgzBNfUpyk1jyBEu4zVxcQ6xgVIFcEtu+vSzwOVqHSGlWmVDa50DmnG
	7ME0qUYNPEYu82Vn3bOZp0IaUoSZvbk=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ZNeQJD5QvAEGKkBmP6xEF4EhUiUy4x2JIHmkUYpd8Uw=;
	b=zR2/KQiIAkktS83hUna21vJ0Aeut2uDBZytGKvdkC7LaE3c6AxNs+oLsyWDT4YdTLZfdE2m5D
	gFsti7B7xMaZOYx/5QmuDoD/kWOdUXbA+yyuPpRx/HL04T8clrcYD2Wn12Gla7LR/fDOGtldIqc
	NEBnvteaipH7o8AAv8lPbXU=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dV2kj6bR6zKm4G;
	Mon, 15 Dec 2025 09:38:05 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id C338A1A0174;
	Mon, 15 Dec 2025 09:40:05 +0800 (CST)
Received: from [10.174.179.179] (10.174.179.179) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 15 Dec 2025 09:40:04 +0800
Content-Type: multipart/alternative;
	boundary="------------tmfWforkdQ7EfLRKvfjUsKiH"
Message-ID: <4a40d056-306d-41b9-b79b-7519b4e8fbaf@huawei.com>
Date: Mon, 15 Dec 2025 09:40:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mempolicy: fix mpol_rebind_nodemask() for
 MPOL_F_NUMA_BALANCING
To: Andrew Morton <akpm@linux-foundation.org>
CC: <david@kernel.org>, <ziy@nvidia.com>, <matthew.brost@intel.com>,
	<joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
	<gourry@gourry.net>, <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
	<mgorman@suse.de>, <linux-mm@kvack.org>, <wangkefeng.wang@huawei.com>
References: <20251213082911.1509735-1-tujinjiang@huawei.com>
 <20251214160459.1c9d9cfdec4088097ff6d713@linux-foundation.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <20251214160459.1c9d9cfdec4088097ff6d713@linux-foundation.org>
X-Originating-IP: [10.174.179.179]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Queue-Id: 86B2280010
X-Rspamd-Server: rspam10
X-Stat-Signature: kr5n5ujuipktrajfdab4545ox7rai4ue
X-HE-Tag: 1765762810-130922
X-HE-Meta: U2FsdGVkX1+K/8GzMbKUfm22PRKB0Y1wSk+d4cKO6hWO25657bN0mKNcVBE987Jpdw6S0Mjt2sAk60PydrpCAT3gyVckIJzbFHC4GzKsozphgb2Zs81xkp3GP98/lxtP7PnaqBM3N6HiOSp3PkWXV1UY/At2r9uZpRo5lrlLhUmjqKXqR5Def50roJHsofWSip07MukPmIuOuObOkcIn5sDQDbavQS4KywijOKQvPQAxeR9SiMndMqVTIkOganBpkg/uHKRUDeoLmaK/z0Ft5dDvgPwSdhTByjuydcA/EQdDdL6C5Df3wWAFG3yUGeBLdpOvSBai8ufKFo1d03y/Hq9dhoxUj8aXSXbK+hpl7i0d2cfs1QtqwJIuoxCFg6BHVU4Gz8hQxI8VauIZXSbKsbB5YZZsyQi8XLA4ySFdGNrOZ7GiMFtYVDoIgPDmwYbnlPsk/YipkcH/b8yUdinf+NS/MapHfAkwHdsVJRi4dVtMjwZ493LVQKyKMeHLy3aI7AmLBopw8gq6rJvEuEpJUqotON9+C+/fInFDh74dLrbsatvidbLzbiL+qzpJaqBTVv8zLihSOtL0ygJ4sODT9BfoTRjH7Ew1HxyqRLa+QM3KufQgVMZEjlGvAsx2IeHtBkalJ1uvMxP0sZl2akY8Yz40uT8uhMLQNF9zlQVI3HoEqFzHcw7slQLIIWUY/g5T8SPvzBRHAAYdEA0ziqjfvZ0sr262X7AuZQJiTD+FViyoAIVk2yYhYrT0FYyBIQ4TIwS7d8XVciU4iBztl1B6YHY6Pks4+LHR2okBdMDGqIes694/0GIbMHbTRw7JfKNLzRZEqkDJ8fUg8DCcqoOUH9sg9MlPO+Ry/Ohywb2KrFqY0Xz+GZ/oyQzfhfDdWBBmXG9KyQ15eCzygzXiDPhU97boO/UyTiFSqxrdCKAFuZfbaI2UuuApMiXLNfWtKZJhYHnkNKYkroMCirpt8gQ
 pJisAHyE
 RFoeR8Dp0PdWf3I6ERHjbvGWzkxrosfSRI8Mg9Qj+GpUFE7mWIkgqV9M07AyndypLVvzhjh6P5pJLe4RWgWGi82XsQzjd/GhJheNvFBTtXFescg4u6pU1RPoO5nwvntmpEKoDWlbi6zpp6Hwhu7YcYfZyfrcCFWXrOqqx2xxTCHp6S5Q+KYU3oIw8lct2Atx235WWGwFDcSoPDe6UUbJT3r3z6E56Oh8VEF6zyPS7rvpUqGjFkt0RchWYxko695GIIEu7evLnm2L0RgJXU0qcRCcFYh8s/DYrdJca4izv9I/iNKNfXyoJ40kxtlWqcstdzgakAuVdRaw5z45wpRpK+XvS4wWqLJLxCkimgiEhQzjJoT1x6X9JsADHvMJr/zcY+/LMGgjZv3/R//DDPjPdjC6JT1NtFRqhhQpLkvws3eoP80oyTk0IKvt+mK6sbwEfFTxpIOZs1dPZiUQ3PAzxhAt1ruFmNLKCuC2EMaYkb3mdCqHcR5IfJXjlf0DLzAgxqmv5k/KnAzt90GocQtcUMuLZNueldxTgG4lI1AYGQwX+sXM+dLVMKJ6teZsNAuXwFPoSBF+zjwY/SXvknhh85Qt7h3Wn12T7vUanOPqSJ7g0kelBFRoVA085SF7RDNqi2JtB2MoXxeZnNIA8uJvf6RmQdCWOa4Ui8Jj6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------tmfWforkdQ7EfLRKvfjUsKiH
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/12/15 8:04, Andrew Morton 写道:
> On Sat, 13 Dec 2025 16:29:11 +0800 Jinjiang Tu<tujinjiang@huawei.com> wrote:
>
>> When mempolicy is rebound due to the process moves to a different cpuset
>> context, or the set of nodes allowed by current cpuset context changes,
>> mpol_rebind_nodemask() remaps the nodemask according to the old and new
>> cpuset_mems_allowed by default. So, use mempolicy.w.cpuset_mems_allowed
>> to store the old nodemask allowed by cpuset.
>>
>> MPOL_F_STATIC_NODES suppresses the node remap and intersects the user's
>> passed nodemask and nodes allowed by new cpuset context.
>> For MPOL_F_RELATIVE_NODES, the user's passed nodemask means node IDs that
>> are relative to the set of node IDs allowed by the process's current
>> cpuset. So, use mempolicy.w.user_nodemask to store the user's passed
>> nodemask.
>>
>> commit bda420b98505 ("numa balancing: migrate on fault among multiple
>> bound nodes") adds new flag MPOL_F_NUMA_BALANCING to enable NUMA balancing
>> for MPOL_BIND, the behaviour of rebinding should be same with default
>> befaviour. However, mpol_store_user_nodemask() returns true for
>> MPOL_F_NUMA_BALANCING, leading to mempolicy.w.cpuset_mems_allowed stores
>> the user's passed nodemask instead of cpuset_current_mems_allowed, and
>> mpol_rebind_nodemask() remaps wrongly.
> Thanks.
>
> I find the changelog hard to follow, unfortunately.  It's odd that the
> problem description comes in the final paragraph!
>
> I cheekily changed that and then fed the text into Gemini, which
> I think helped. What do you think of the below?
>
Thanks, it describes the problem more clearly. I will update the
commit log in the next version.

> I won't merge the patch at this time - I'll await reviewer input.
>
>
> ## Bug Fix: Corrected `MPOL_BIND` Rebinding with `MPOL_F_NUMA_BALANCING`
>
> ### Problem
>
> The commit `bda420b98505` ("numa balancing: migrate on fault among
> multiple bound nodes") introduced the new flag
> **`MPOL_F_NUMA_BALANCING`** to enable NUMA balancing for the
> **`MPOL_BIND`** memory policy.
>
> The intended behavior was for the rebinding logic to remain the same as
> the default `MPOL_BIND` behavior.  However, the function
> `mpol_store_user_nodemask()` was incorrectly returning `true` for
> policies containing `MPOL_F_NUMA_BALANCING`.
>
> This led to a bug where:
>
> 1.  `mempolicy.w.cpuset_mems_allowed` stored the **user's passed
>      nodemask** instead of the actual nodemask allowed by the current
>      cpuset context (`cpuset_current_mems_allowed`).
>
> 2.  Consequently, **`mpol_rebind_nodemask()` performed incorrect
>      remapping** when the mempolicy was rebound.
>
> ### Analysis of Correct Rebinding Logic
>
> When a memory policy is rebound (e.g., because the process moves to a
> different cpuset context, or the allowed nodes within the current
> cpuset change), `mpol_rebind_nodemask()`, by default, remaps the
> policy's nodemask based on the transition between the **old** and
> **new** `cpuset_mems_allowed` sets.
>
> To support this mechanism correctly, `mempolicy.w.cpuset_mems_allowed`
> **must store the old nodemask allowed by the cpuset** before the
> transition.
>
> ### Context for Other Flags
>
> * **`MPOL_F_STATIC_NODES`**: This flag suppresses the node remap and
>    simply intersects the user's passed nodemask with the nodes allowed
>    by the new cpuset context.
>
> * **`MPOL_F_RELATIVE_NODES`**: For this policy, the user's passed
>    nodemask represents node IDs **relative** to the set of node IDs
>    allowed by the process's current cpuset.  Therefore,
>    `mempolicy.w.user_nodemask` is correctly used to store the user's
>    original relative nodemask.
>
> ### Proposed Fix
>
> Ensure that `mpol_store_user_nodemask()` handles
> `MPOL_F_NUMA_BALANCING` correctly so that
> `mempolicy.w.cpuset_mems_allowed` stores the correct cpuset-allowed
> nodemask, thereby restoring the proper remapping behavior in
> `mpol_rebind_nodemask()`.
>
--------------tmfWforkdQ7EfLRKvfjUsKiH
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">在 2025/12/15 8:04, Andrew Morton 写道:<br>
    </div>
    <blockquote type="cite"
cite="mid:20251214160459.1c9d9cfdec4088097ff6d713@linux-foundation.org">
      <pre wrap="" class="moz-quote-pre">On Sat, 13 Dec 2025 16:29:11 +0800 Jinjiang Tu <a class="moz-txt-link-rfc2396E" href="mailto:tujinjiang@huawei.com">&lt;tujinjiang@huawei.com&gt;</a> wrote:

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">When mempolicy is rebound due to the process moves to a different cpuset
context, or the set of nodes allowed by current cpuset context changes,
mpol_rebind_nodemask() remaps the nodemask according to the old and new
cpuset_mems_allowed by default. So, use mempolicy.w.cpuset_mems_allowed
to store the old nodemask allowed by cpuset.

MPOL_F_STATIC_NODES suppresses the node remap and intersects the user's
passed nodemask and nodes allowed by new cpuset context.
For MPOL_F_RELATIVE_NODES, the user's passed nodemask means node IDs that
are relative to the set of node IDs allowed by the process's current
cpuset. So, use mempolicy.w.user_nodemask to store the user's passed
nodemask.

commit bda420b98505 ("numa balancing: migrate on fault among multiple
bound nodes") adds new flag MPOL_F_NUMA_BALANCING to enable NUMA balancing
for MPOL_BIND, the behaviour of rebinding should be same with default
befaviour. However, mpol_store_user_nodemask() returns true for
MPOL_F_NUMA_BALANCING, leading to mempolicy.w.cpuset_mems_allowed stores
the user's passed nodemask instead of cpuset_current_mems_allowed, and
mpol_rebind_nodemask() remaps wrongly.
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Thanks.

I find the changelog hard to follow, unfortunately.  It's odd that the
problem description comes in the final paragraph!

I cheekily changed that and then fed the text into Gemini, which
I think helped. What do you think of the below?

</pre>
    </blockquote>
    <pre>Thanks, it describes the problem more clearly. I will update the
commit log in the next version.</pre>
    <blockquote type="cite"
cite="mid:20251214160459.1c9d9cfdec4088097ff6d713@linux-foundation.org">
      <pre wrap="" class="moz-quote-pre">I won't merge the patch at this time - I'll await reviewer input.


## Bug Fix: Corrected `MPOL_BIND` Rebinding with `MPOL_F_NUMA_BALANCING`

### Problem

The commit `bda420b98505` ("numa balancing: migrate on fault among
multiple bound nodes") introduced the new flag
**`MPOL_F_NUMA_BALANCING`** to enable NUMA balancing for the
**`MPOL_BIND`** memory policy.

The intended behavior was for the rebinding logic to remain the same as
the default `MPOL_BIND` behavior.  However, the function
`mpol_store_user_nodemask()` was incorrectly returning `true` for
policies containing `MPOL_F_NUMA_BALANCING`.

This led to a bug where:

1.  `mempolicy.w.cpuset_mems_allowed` stored the **user's passed
    nodemask** instead of the actual nodemask allowed by the current
    cpuset context (`cpuset_current_mems_allowed`).

2.  Consequently, **`mpol_rebind_nodemask()` performed incorrect
    remapping** when the mempolicy was rebound.

### Analysis of Correct Rebinding Logic

When a memory policy is rebound (e.g., because the process moves to a
different cpuset context, or the allowed nodes within the current
cpuset change), `mpol_rebind_nodemask()`, by default, remaps the
policy's nodemask based on the transition between the **old** and
**new** `cpuset_mems_allowed` sets.

To support this mechanism correctly, `mempolicy.w.cpuset_mems_allowed`
**must store the old nodemask allowed by the cpuset** before the
transition.

### Context for Other Flags

* **`MPOL_F_STATIC_NODES`**: This flag suppresses the node remap and
  simply intersects the user's passed nodemask with the nodes allowed
  by the new cpuset context.

* **`MPOL_F_RELATIVE_NODES`**: For this policy, the user's passed
  nodemask represents node IDs **relative** to the set of node IDs
  allowed by the process's current cpuset.  Therefore,
  `mempolicy.w.user_nodemask` is correctly used to store the user's
  original relative nodemask.

### Proposed Fix

Ensure that `mpol_store_user_nodemask()` handles
`MPOL_F_NUMA_BALANCING` correctly so that
`mempolicy.w.cpuset_mems_allowed` stores the correct cpuset-allowed
nodemask, thereby restoring the proper remapping behavior in
`mpol_rebind_nodemask()`.

</pre>
    </blockquote>
  </body>
</html>

--------------tmfWforkdQ7EfLRKvfjUsKiH--

