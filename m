Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D48C2FEA802
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 03:35:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46F9B6B0005; Tue, 24 Mar 2026 23:35:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E1BE6B0089; Tue, 24 Mar 2026 23:35:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A9A56B008A; Tue, 24 Mar 2026 23:35:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 16CBB6B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 23:35:30 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 96E8C13B7AF
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 03:35:29 +0000 (UTC)
X-FDA: 84583170378.10.4AB7DD0
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf12.hostedemail.com (Postfix) with ESMTP id C7A1C40005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 03:35:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="BOj/KfMt";
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774409728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3OpymkQSEIKE7Fqn9V/VdkGHTLFOzEO+6mJnfDDyy/Y=;
	b=H7HUho89MC9bc/rDTEJwCHN1flmdKuc9rNngc7+vRSQxskX8AUr1iKL2QUJ2x5KO14f+0h
	Rxou3Woy1Fp1ACDKfXftrxt3+Q6l/LeB0846j86s2l7UGFhDF2MMwiBvUi1dD0Y7HyRijr
	MkGs+gRcp8rNH32UOBtbNLO4KIMat7w=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="BOj/KfMt";
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774409728; a=rsa-sha256;
	cv=none;
	b=LnPg9ud19e34+HvmhUzxg46ei4WbYBFYIHwHIRK7QUF4e8OdSuxC/y830Qi4+GAlh4V3XQ
	8Ia+5c65GU8UAHnvJ1TL88nh8mpQGov3frjEWU581R7GSq+BqqM+UKoXmQwou9IyVSjloH
	VPhIC+njykV5VUKk2lVZpSqQ2wQwl/0=
Message-ID: <18ee1c67-f905-4b38-8f1e-8a2a77017ceb@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774409725;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3OpymkQSEIKE7Fqn9V/VdkGHTLFOzEO+6mJnfDDyy/Y=;
	b=BOj/KfMt+1WEUT7P6P9uUUJQmnHMsWXDCl5EPEw4x4QerN0OZjHxJCUE3Bc8vRcnZb12Xz
	tuHab2WH0/haqInhIBlBryL1W7FI15wcO/yFnpPiLyAPvVoHV7xbLBhP/z+yO1NadQoYGa
	2RnPdmnU9G58oRg0bEQwJQfONqiKXRk=
Date: Wed, 25 Mar 2026 11:34:55 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] mm: memcontrol: correct the nr_pages parameter type
 of mem_cgroup_update_lru_size()
To: "Harry Yoo (Oracle)" <harry@kernel.org>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
 apais@linux.microsoft.com, lance.yang@linux.dev, bhe@redhat.com,
 usamaarif642@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1774342371.git.zhengqi.arch@bytedance.com>
 <2cf06f9faf51900ce6acbb4740fc60355a2842ed.1774342371.git.zhengqi.arch@bytedance.com>
 <641f8cfa-3a8a-439e-bf03-87af4c49ca2e@lucifer.local>
 <acMr1nU5PLnHpnwZ@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <acMr1nU5PLnHpnwZ@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: jxkyckgn88efce1qy1kab3i794efs8h6
X-Rspamd-Queue-Id: C7A1C40005
X-Rspamd-Server: rspam09
X-HE-Tag: 1774409727-201992
X-HE-Meta: U2FsdGVkX19BkIHb/QEeXain2lzoZBNjZZzPGQ+V2Uz2QjuVi7SEiJUVJcaMq0fLW6Fx+QSRNK2JLKWz4FEMJJ0r4C9qW2aMW+uP+xmslhzjGiRCgY8JiP+ntip1dO3P6AgvRZTOvmcPHd009HVrRXGW/OYCfDGeUMHfxO+e+DBx88jILJoxF6Yn/JvLz9+tL/7G55rP+8p9hPsT81zKHoVnBkCGMRbXFrbxO4FcdGK9q0UZhbyx33XLJFm8Y7qOCL4YKLxjASm9I35InQWUIG2y9+VhCldlxP6YHXSzOaOMQ74OIpwOQfGVhcr0mEdjZZzxUMZ8sy2K3V9w9LeTF9o+mgIqAFeualT2QU4FutS1ziICKyQJNsD80iQqA5160+t0OKI+n+fqHF65pcFm5DQKOG21Vav3HfacAEONcu1rbX7m/07HiqmP+ErbY+alDy2+nwX3THUQdo33jXlHtfNZH/rr54EjxpLKkoyuwIh4yHRk71zwe280eYo6CJ7ttkjfRCEjPFY8NRIcUIWbxkLAgbnUzbZp6CHWhve6vgkpC2mb6qz/011+cW4/AfhlzzUO67TC6DUnwKXNJGOnnWcM8OEckCal4xe7/GLxe9gtQ+sHARcmv+bwXta3uMVv2jhKa09IzWmsMSVVjHMMvinxUgh/4nLLU0sYLEx+wa65flZev8e6yQvnFzerdTaRBUeIudiEQlMacHOZMsdZtchWTASXNdspkpOIffZL2C38Cr3i6IKozWNbasSgVigBtUEzD9wehwzBzCTHeEpk7b0+jFepiQc1VVPDCNhN8e+3TImP18Uu3GC8bS8C0VBSBWa7CImJAlL9dzlLXZc98KF3LpbzTtxj5/hR/ZfF9OSI2rTGJSrnfhjfwKRRpFP5Q3tVWSqMNs4ngAHjdy9R0XTf8tRQVfjuLTemOe2HmaUgk2aQCAlNzBtB+N6TN2AoHIXP1MWBfw8O8GlFk4M
 fbwGJ+L8
 zjAzofA7jKgyZiRke28Yy6oktm7cNZydksPJPSdHE7Sf1TL+q3GPdw70xEAUFv83elpW9G+thFsKCBl3w2H8HVvw/1CXkmQinOknDwDyzA+A7tgPugvaekQiX66aJlkOvp81d4UYMSPI9XvVe8ZNcjqq8zhaDzR8JDuhdTk4kebecumEgyV1YxcTpaaYACFi/wU84kZwm+SNgLIOE8Rb3xvC4SA1NfjZkF7hZ6NUdPDTah+vLQG4EtmuprfOUtybiGD9NQyVKAAUFFgEcp8FN8MLnjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/25/26 8:27 AM, Harry Yoo (Oracle) wrote:
> On Tue, Mar 24, 2026 at 12:28:08PM +0000, Lorenzo Stoakes (Oracle) wrote:
>> On Tue, Mar 24, 2026 at 07:31:29PM +0800, Qi Zheng wrote:
>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>
>>> The nr_pages parameter of mem_cgroup_update_lru_size() should clearly
>>> be long instead of int, let's correct it.
>>
>> Hmm, but are you ever going to be adding that many pages? I guess technically
>> correct though.
> 
> It has been fine as-is, but reparenting changes that.
> Reparenting in theory could add billions of pages at once!

Right. Thanks for the explanation!

> 
> And yeah the commit message could be improved.

Yes, I've omitted a lot of background information, which might seem
abrupt to some reviewers unfamiliar with it. I will improve this in the
next version.

Thanks,
Qi

> 


