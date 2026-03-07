Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9DCEFC9EC0
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 01:29:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09CD26B0005; Fri,  6 Mar 2026 20:29:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05E026B0089; Fri,  6 Mar 2026 20:29:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECC9C6B008A; Fri,  6 Mar 2026 20:29:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DDF3D6B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 20:29:33 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 589FF14079B
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 01:29:33 +0000 (UTC)
X-FDA: 84517534626.14.D37C853
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf19.hostedemail.com (Postfix) with ESMTP id AAC781A0015
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 01:29:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=COmdWw4F;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772846971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KEbq7+B9siae4mtuT/OYYL/NsKQtpMVr0am+LjM7dGw=;
	b=oXp3JFCKOc+AvbURCD1pbLV4UxedNcJtoqCL6iRZOyoI2Yk9XEqFFVdqBr7Zb0R5xbOMAV
	VM0ljXZLZbhTzYRz5JIUYzayXCkaduUst+zocM8z/BMWx39lYj1Q14j+cYE7gmyHBj08Mx
	O2AYR30bY8m0qSrNeOVK0xM4nxlHfx8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=COmdWw4F;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772846971; a=rsa-sha256;
	cv=none;
	b=p1RQY+c85YhQ/qwWu7NPSjvrWuH4gm9AQmdBLyumcQrbmK3Tx05OMAAvogWWVfEJivvS6Q
	aGv4MB+pdxfFGzJ+eKzhqxrK5QdI3FnuterEtc1/ZpKKR33C8hx9fFAi7ebjnHgwA82F3a
	249GA2SSqatHmB3EwLYT/YilZa3FVJU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772846966; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=KEbq7+B9siae4mtuT/OYYL/NsKQtpMVr0am+LjM7dGw=;
	b=COmdWw4F5wqp9MQts9BrqJRil8wUk5bX0NVBmeKnOCBLForzrgIusr/Cc8hdu4nV3xuYAsJY9Tm0g4+8Glhnx9zOhAwSvyndggLn2/HnBON5zUtgjszjnQu8XKFcEE5bEnvTHQuI35lBtnHNJHTBXyS1raXxnEQmXmbD/FK/z9g=
Received: from 30.42.98.36(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X-OMk1T_1772846963 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 07 Mar 2026 09:29:24 +0800
Message-ID: <0fb36b71-d9b9-4a43-a13c-463469fb202f@linux.alibaba.com>
Date: Sat, 7 Mar 2026 09:29:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/6] support batched checking of the young flag for
 MGLRU
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, baohua@kernel.org, dev.jain@arm.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 hannes@cmpxchg.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1772778858.git.baolin.wang@linux.alibaba.com>
 <20260306152042.8516ec644e95e9a23df30e5f@linux-foundation.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260306152042.8516ec644e95e9a23df30e5f@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AAC781A0015
X-Stat-Signature: bc6rxs8kpusgbpaa8hfqe5fsrhuyiweq
X-Rspam-User: 
X-HE-Tag: 1772846970-509187
X-HE-Meta: U2FsdGVkX1/aJdO9nqrG5a9Q4KOzkTegrPkwvgBSjp174z8JkVroq7H0QcxL5s9buTgPMVg7+WoNaJyWdpNg8oTv2jPW//v4xWug1EptBbfXvk5TjnhxQ431IP36CMHUCtu3x1nT1fj4Fr/W+GuMeHXgESF4usqAT6V86z5ibqHRvwSf5yDndkcmhQ0ocxyGg00rWh3OKpEKtWoK0qMJWS9APhZjgbJ2ssqGRpy+jnAJ09KsKmxjUGM2cYVnWOcNtMgrS1cvVXflEDyvCxEKLbYGvCdPM7F5si3DdjJH09QussAMDtKXg3caRZylfKXjj94CnGn0T8I95C86YX3he+90HY8fvXFl9D22yqf3wPoBS1GubqTJ/4yW3AwrZFesxKThHPYTpmLeRP4t6fdSmDTUEGhz1iRqbmJanfCCCwuq8H0D4XPbLOb2sIybdKOMWXdzqkFh8Sj1sXNvpmFxldmnc2L+OiF8RisWod88d2Skl33pAw1wKUJYxvPjvSR+YbE8ty97pwv1BtxSYrTwghmEXtje4rV6E9z9XrS0wR0G181UEJoZZqBeA4MMmK1oUvT7+FOfpWQ7RiTbR2eXyDn2pywMmQbjVPAZUAtNB8sfFws/mtuTlVF7ZANexeCyJFvEqqtY48gFVwgPwsp+zbZkAjkSR4VVcHFm94TQW7v+SRUjozuiMwcBZDr14571hbGgTogdnpElEoa+7IpviKtoUMo7RyIf7i3Q9ghGU2tVC0xTL4+SugtowCR1bFliC3yqw/MXFqYnAr6fu9bZYZrjD7UHjtfRuIBOZzR4TxLnYDZTDltHuC8Ur3rTM9s0bW444W66IVoeeGWC0gORVKewr04OVgVIbY67rhCkd4IRSW04mFeXJFVBEaMiUTFU6wTmkYT1yAN2xWD+Co2AxnEKqh1A4MTQrEQiEwaWX+gHZBcFdmHfQjhWj/G5Vjj0/aEDiIYkWdN7xupY9pY
 D/kZjzbt
 nGObrBc1PZH8pap1hYNltqzVK9m2AZ/oCJc2EjN+h/lg86jqn1Ba7VPU8qx+1BwjzajRHrCDL+jeIwdTEGuwVYFn8gfGV+EuZZ3Pa+3879+QmfVW0fSOCUAitiStDm/bLQOGunWWW10suBp/0s1vSZ/FFmDuyHrnrtjKMgU9ybc9cKdGU/BXJVEH+S34eWLNMMg9hcmO6hyWtsKg5tbWut3vNOOModvUGv9xWQFkdDE75GX4YronqB3Ckm8tkXluYRhnphPTsOMYWb03BG6x3lqdAYlLZmWfrHLK7CH9pQxvOIlDZgvHuW4LiSKNH1onTQXd3fWvYCv74kDo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/7/26 7:20 AM, Andrew Morton wrote:
> On Fri,  6 Mar 2026 14:43:36 +0800 Baolin Wang <baolin.wang@linux.alibaba.com> wrote:
> 
>> This is a follow-up to the previous work [1], to support batched checking
>> of the young flag for MGLRU.
>>
>> Similarly, batched checking of young flag for large folios can improve
>> performance during large-folio reclamation when MGLRU is enabled. I
>> observed noticeable performance improvements (see patch 5) on an Arm64
>> machine that supports contiguous PTEs. All mm-selftests are passed.
> 
> Thanks, I updated mm-new with this.
> 
>> Changes from v2:
>> v2: https://lore.kernel.org/all/cover.1772185080.git.baolin.wang@linux.alibaba.com/
>>   - Update the commit message of patch 5 (per David).
>>   - Fix some coding style issues (per David).
>>   - Remove 'cur_pte' variable in lru_gen_look_around() (per David).
>>   - Move 'ptes += nr;' to the suitable place in folio_referenced_one() (per David).
>>   - Add acked tag from David. Thanks.
>>
> 
> Here's how v3 altered mm.git:

Thanks Andrew. LGTM.

