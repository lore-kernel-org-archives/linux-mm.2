Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 898D6EFCE43
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 02:52:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F33F96B008C; Wed,  4 Mar 2026 21:52:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F15CA6B0092; Wed,  4 Mar 2026 21:52:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1E5E6B0093; Wed,  4 Mar 2026 21:52:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4EC56B008C
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 21:52:12 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7254EBA44E
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 02:52:12 +0000 (UTC)
X-FDA: 84510485304.12.CE91CD3
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf28.hostedemail.com (Postfix) with ESMTP id B851EC000B
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 02:52:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gOPPgYw8;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772679130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SSkchyqFNiFC8SjS3pBBe3FbQopPcRvirL1AZrVMU+U=;
	b=y0yB8vGoHZdcz3C2t62neV9XkDB/+RKogC1us/5zKPJcCmTglrtMPVRrE6aGN7nKHmS39s
	QuEkDqrD5cbB9naQqA3jBX8t6gspDnbr/13u756pcS/PBmR0Mh4n81XZjWUqWdRQ/ffoZE
	FXWxBdae/7iytxy5jmVBA70QeJ3LxD4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gOPPgYw8;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772679130; a=rsa-sha256;
	cv=none;
	b=H0xHOCmKDEX3eMUaKopEkfmTRGm5NG8hZT9oyoR5gsrJtH2bg9tM/rx9IGFY//ejFRDtLK
	JBqs62g+Dk4SandNIkliyL2/LP4QCYxbjFoY+AAf3MYo+npBu+F2pa2VnySx4Vo2Vnircm
	MfXMrEx21QXPb9ITph9Ib+1HWI+gxK0=
Message-ID: <b7967290-3bb3-4ddd-ad9a-3bec79fb600b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772679128;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SSkchyqFNiFC8SjS3pBBe3FbQopPcRvirL1AZrVMU+U=;
	b=gOPPgYw84e15Pxl/7OLaZTWOrf1z/5qPnq28NF4nusBn+/l+49QgLJmFgtqU+RJDtBMUhF
	jt0dUNxuMMCtdqBXreF1p+E63wfJgnSeToSnqx8M97cqzpXhe379VJXMZ88d0LVUCar44Q
	XkjmYteq64u6G42+bVGg5KzCicYkJso=
Date: Thu, 5 Mar 2026 10:51:58 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v5 update 29/32] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
To: Yosry Ahmed <yosry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <ef13e5974343b37ae2a0e28aff03ea2d033cb888.1772005110.git.zhengqi.arch@bytedance.com>
 <20260228072556.31793-1-qi.zheng@linux.dev>
 <CAO9r8zNYFvNnz_oTu10kPBYL6=1ZewKUMRYcMmcMdSqbro_miA@mail.gmail.com>
 <de1476aa-20a3-420e-9cd7-9238efd3c85f@linux.dev>
 <46bgg2vwqvmex7wtk2fkvf454tqgaychb7l4odnnrx7svci5ha@vy4b4ophm763>
 <22cca07c-49e0-42e8-b937-7b1c7c51e78d@linux.dev>
 <vfmyb3pp2gatdrqa2uimw44pxioreo7zc373zn7buvdfzhejew@ndhaa4yl3bvh>
 <20260304140307.f51a33f77f6ddc1dfc0cf476@linux-foundation.org>
 <CAO9r8zP9VseSaEO6to9rcRW_TZ6E6Qk4ZQgj49g9bQOAdjgQvQ@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <CAO9r8zP9VseSaEO6to9rcRW_TZ6E6Qk4ZQgj49g9bQOAdjgQvQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: B851EC000B
X-Rspamd-Server: rspam08
X-Stat-Signature: 19mexwiae4qzr3n57kcqxe3x1gfk7573
X-HE-Tag: 1772679130-186069
X-HE-Meta: U2FsdGVkX1+KfzUvkJ34TiwbuE6+LaMC6kG1PUGMs0lMAoAdwJXUuRz2bqWnY6yqsMmEhMUkl99QmSDAy5rSVYzULAyU8byCifEKuwK8DlwUiPuXEFTIxQTx/yrDIbFe8kIor1fLIq2aGpCdO6jEP0ohZHQR0MzP8QiITTkpA3Q9grRIjl1yzwbJFGDySCZ7xuICGgGn+dlKGHqMB9PoMFycd1OmcJc6+iNL52gQ3GOx3wymZp75gVHGKe3ACX7B5lvC4LgNMPcK69iZ/GuURxO8wO3X/2ADOwa+prvjeQ2HdBuYQMLzclCTDvadWhPvywaB6w+Q3+azClLeZ/yd0pQeE4iMcWxkY4xpjzRC2psOoLC5otzc3MYwgXTDrTfo9inZuTPq0kDq7ra/gy5MOPR8EXm9DRD9EtIIXFkMmGxBQw1LyofS1A7p3zvky+5TQ+XuUil559vS7vac0KvpkxanwgRoHAwy5S76fpMT3likrZS+scosZnLa4aNPKGzlT6u6VrPeZmW2e7VkJUeWMBaievtfzSXYAYGhIFNYGtXYoLmlEkZ83VLolq4LePqnkoVsuXe5x23YanAxJsa5buvVd2ibSPilkOgeKDqL7Gh6b7N/jLorbAPdzmauado9HklyTM7O2xraoEc/4gjerBkN3m6uO7TScffflrwXIstEOcwvcfhWgieDumKFawh8aqAdUNqZ7MvGQq49yBwifxeA58ylIj3B9OVFfRxEZFTWvGgDjqgUc7ehIeFdcixe44A1rF+6sADT2RQ/3ONvkCJOLsxjN45i5tJ012f+qsPvrM5u4EJmK8NX1ZWjLMhdIfvyO/nqJyvFzebc37vrUGSXJh8w+jnyFm80Mp1W9Prhx9QhkeC9tnp5cMDLLrBXwGU3xIVf+QkosRht1dXkegyf62GDwRKdnXOmACpEkZrUPIsdq50/lTr5/NCfhU0j4E9sW5BL9PBoRIcmdBM
 CTkXO2TB
 Xb0hcouUuXEDCQ3gWlHxlc4qJgol4iZLLYya/IhP5zHw211DLjRNzon1a26nmrh/AIlyeXXZN4VwxFhVdKJusjRgGgsqfDTKqxHLmPukZJSCQoLVWONNlywyeV/VZCu7YQBVvkx17lr27vb7gwRxraKsbo69b2lwcW7xIr9hRzjofT8dOjWftBQQ+kwFHtLX4S3Ytn7wdsneIqu1N7NXMOQnO8Zx3wUFz89Kt3kukb63vJfMY//Oi4bwuU/lD4xyLo+2FOevMmFwrNP+83hcczqfyOMZlJYtZzRaegQWHMqjBfu9iM8V9+cpNuAZjMPdhSYHo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/5/26 8:18 AM, Yosry Ahmed wrote:
> On Wed, Mar 4, 2026 at 2:03 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> On Wed, 4 Mar 2026 13:57:41 +0000 Yosry Ahmed <yosry@kernel.org> wrote:
>>
>>>>> What about this (untested), it should apply on top of 'mm: memcontrol:
>>>>> eliminate the problem of dying memory cgroup for LRU folios' in mm-new,
>>>>> so maybe it needs to be broken down across different patches:
>>>>>
>>>>
>>>> I applied  and tested it, so the final updated patches is as follows,
>>>> If there are no problems, I will send out the official patches.
>>>
>>> If I am not mistaken, Andrew prefers fixups to what he already has in
>>> mm-new (Andrew, please correct me if I am wrong).
>>
>> Yes, if the changes are reasonably small and the code has already
>> undergone significant review.
>>
>> Although the mm-new branch is quite speculative/early so I guess this
>> is less important there.
>>
>> Adding a sprinkle of -fix patches can be a pain all round, so nowadays
>> if someone sends a replacement series I'll generate and send a
>> what-you-changed-since-last-time diff.  So
>>
>> - we can check that the diff matches the changelogged updates
>> - reviewers don't have to re-review everything
>> - the author can eyeball it and think "yup, I meant to change that".
>>
>> I believe this series is due for quite a few updates so a full v6
>> resend series would be appropriate.  I'll generate the
>> how-you-changed-mm.git email from that.
> 
> Thanks for chiming in. Qi, if you send a new version, I think
> separating refactoring (and moving, if needed) mod_memcg_state() and
> mod_memcg_lruvec_state() into a separate patch will make things easier
> to review.

OK, will do.



