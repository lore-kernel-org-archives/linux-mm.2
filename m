Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16D91CD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 10:00:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C1EA6B0099; Mon, 18 May 2026 06:00:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 472386B009E; Mon, 18 May 2026 06:00:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3613D6B0099; Mon, 18 May 2026 06:00:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1BE736B009B
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:00:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BB0661C07A1
	for <linux-mm@kvack.org>; Mon, 18 May 2026 10:00:04 +0000 (UTC)
X-FDA: 84780094728.22.5E66243
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id C87D318000C;
	Mon, 18 May 2026 10:00:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V2JzVDB+;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779098403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7m+lIC/0LKslUiCC42NRU0fGTjJFbCMWAWRjqy5NWxs=;
	b=3TZGLJslPbpw5kr0bAJWZ+qnqGPsKO0siX8eOQ/n1aYBiAHt3wkJP/YVys05HgKuCpnenz
	7ntcrGREVcmU/SvhcvIgdJVirr39vqtU5Cn6bOozf/sCDebgYZ+r7oHf3s9YLPw9lcBrui
	kD0dpCUbpk97GTukt5WkMMDdWGkJiho=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V2JzVDB+;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779098403; a=rsa-sha256;
	cv=none;
	b=hAAh8DflnUIrbXF6grNfi/s1V4MjTaMI3o7QcqGItbEmfhBRY1rL03lxBkGolbaIht3IxS
	Eo3+u8rszx03VYG0Oxf3Xt81Rxhe9732FmqNwAW1pi+k5CUCP+lilR8Y5DTJ5T8L3pGdA9
	7IaHnguMvqTOcdEaFfDWFvrOotbZ0iE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1891A6001A;
	Mon, 18 May 2026 10:00:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F0FC2BD01;
	Mon, 18 May 2026 09:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779098401;
	bh=L9CQKlP9naIo5xdjxllOxmVMwhAiSXVYV0xQ7u+Eb7E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=V2JzVDB+N5ImbK6LsGROmwY8AFEtbPDnok+ulyssyRJWuG4HIdxR8GX9dBDXCxm7G
	 PVFkml1jkhQsqoL+W2AwkfVjXHNAlHG68fNELXMo72eiqz30B7YO5OnB9SqLhHC7EW
	 SNaaLXrkTMhbaLT7IBITbeLIcGQ12lkmy8VufCOvczK/L+9k/gH0/vruMKfCebvYvO
	 iSFSgHngJlEbyV/N0dVwwMbTrFN05CS0xCmvpzEiyc9B8GQWKg4owEvLKUUDebDk7u
	 5KyIwcV4d/ERxRU4C3gaH+kSj8CY/jXKc1P/gnVw9Rj+W433rL1R63HRTQ2V9nXexh
	 xJYghDYgCwp/g==
Message-ID: <16ca5667-ae65-4bf0-8efb-e51bf7d70c87@kernel.org>
Date: Mon, 18 May 2026 11:59:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] __GFP_UNMAPPED and __GFP_PRIVATE follow up
To: Brendan Jackman <jackmanb@google.com>, Gregory Price <gourry@gourry.net>,
 linux-mm@kvack.org
Cc: kernel-team@meta.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
 dan.j.williams@intel.com, longman@redhat.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, osalvador@suse.de,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, yury.norov@gmail.com, linux@rasmusvillemoes.dk,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com, tj@kernel.org,
 hannes@cmpxchg.org, mkoutny@suse.com, sj@kernel.org,
 baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 muchun.song@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev,
 jannh@google.com, linmiaohe@huawei.com, nao.horiguchi@gmail.com,
 pfalcato@suse.de, rientjes@google.com, shakeel.butt@linux.dev,
 riel@surriel.com, harry.yoo@oracle.com, cl@gentwo.org,
 roman.gushchin@linux.dev, chrisl@kernel.org, kasong@tencent.com,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
 zhengqi.arch@bytedance.com, terry.bowman@amd.com, owner-linux-mm@kvack.org
References: <agYJcRgOHho8upVv@gourry-fedora-PF4VCD3F>
 <DIJ5IBGSO0OC.1S6AARO01CD6T@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <DIJ5IBGSO0OC.1S6AARO01CD6T@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nswdjq6ddwdt7iumaf8omg5ez3zjxeom
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C87D318000C
X-Rspam-User: 
X-HE-Tag: 1779098402-994238
X-HE-Meta: U2FsdGVkX18U8MgoTJh4ctssRoLS6uVGsZFizC4fVw8m81JQCeEGznOxYijFXZBx21ZJ6vV420fQ37XXDbUV+z9B53OfTItjWR40D44IA/a9dQ45ikM/SFIbkJs7ffEySp33GGw6LII4cE7ReIH/9SUTbHhMSF6drepZhEph+w832JrwCPsNeN3nlxvD0FHopSSWI7GmcTtvK8d+Ehr6HRTLBBlq0xXTPq1oIZK9n+ZYL62VSkudpiyyTU4o9sPBybPNM9LVc+kXfpMxgfZcbRQ3yGYxXgycsoXkxQI5Qrvm62ZxSSnz4OWCi16NeBALc1oxLj/MJJCqq9VaNDAZgoSsG/byz1tXsJQTTneZfgAKdFZP6iK9/OZFo9SXYbF2QoBFA7fZJPBi9Nw21COMAMNpOt36yX5e02aGFSDrfHhYjnNOCtWfjAcTn4hE5MsPJ8zU7VeG0B9vlrnTVxLm35M8qiGH+HElNjZsLNtQRG7Fsl0clng9NsH/yJDsHWW37DI7A7ORRkTQJLBeyb/G6zIt7ggiClncZfcDq9lxkn4YYkGeb772BCkvQEiKGq7RrCwPBsqr8Xq8zpH1vQRNJ4qmJNQOdy88SvC7tQRlqBVnzX4cW/rSs0zad4w/pnV06a28VY1dxPRsI7BFAdMWyhylefAAN30f1xKRi4MVDARYquFyA8UV1hxMCmTCDSGTL63D2AWfm3DUXqB6P5VX9Ob9gFvKVkzfRM+dOmyIXULiALFO8GIOgaDtgSzJSIS2jjxvQPfoa5b10DWrS9KyffpdT0ogJn3sqOI8wNWXQSu8tCHWlegxxW7f8jrcfGueyiJ7Uli/nxQmlN3QGWZ+Rs6W/A+NThUKXZaqXYZsM4ViDnCu4CcyeWEchsX5wt6DANDjBvtkQ5eemsZ1PCBDiyOLCp8X6VeiNsqWdWdXGvHHTLSBOqMR5Y7PhksvbXPP5tZ7y+q55noqq1G1UfN
 TJsg1oGt
 YwL5kNZBKim1eYUmtQaOZmRPpHCKEwRQnVFVWMOmXvYt3FGjVfMZSXGdywP+F1LqjGUBif+vQxRNbnPVxMGEb2jGRraIMhf7dOUV2kmc8ZH1SJgDB3XrSVM9P88FyDoyGtQOH/0Nh+RrE/Ibsgp32Ctxt10ETTTGonP9WSw6+ONhSwZG/oVKM9XKUV4nGVQLf4w5vH2ZUL5fVrQJOF4pYuY18/3XnqQSMHS7+3MRNcbMLxunFCMtCEAwQUV5Gdtl9fFbTseWBnIcSmt7B8zi/s0Hi5fQzsA4kPyYdgSQUugq1OvgaWHdHjWd/WX6I2WkyldImLT3mdatmGshrCE20jqEAqx3ao5EBkhCQsJ7o0/IDR7lrdShZD7+TXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/15/26 11:43, Brendan Jackman wrote:
> On Thu May 14, 2026 at 5:42 PM UTC, Gregory Price wrote:
> ...
>> Maybe we could modify alloc_flags to be a struct, and export that
>> without being tied to down to a 32/64-bit flag field - and mark certain
>> sets of alloc flags verboten (internally controlled / controlled by GFP
>> flags, and will either be ignored or cause a BUG()).
>>
>> Then we could get something like:
>>
>>     struct alloc_flags {
>>         /* 
>> 	 * internal only: will be ignored, cleared, or cause BUG() if used,
>> 	 * or should be applied via the appropriate __GFP flag.
>> 	 */
>>         uint64_t wmark_min : 1;
>>         uint64_t wmark_low : 1;
>>         uint64_t wmark_high : 1;
>> 	... etc ...
>> 	/* 
>> 	 * external context flags
>> 	 * allows explicit access to certain resources
>> 	 */
>> 	uint64_t cma          : 1; /* allows access to CMA regions */
>> 	uint64_t unmapped     : 1; /* return pages in unmapped state */
>> 	uint64_t managed_node : 1; /* allows access to managed node */
>> 	... etc ...
>>     };

Wouldn't it be cleaner to really only export what we want external users to
consume? IOW, a split between internal and external flags. We do that for
gup-flags, but I wouldn't suggest that models as is, just the overall idea.
There are other ways to achieve it I guess.

-- 
Cheers,

David

