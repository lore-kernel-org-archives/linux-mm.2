Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E34AD3CCB3
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 06:06:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC3236B0088; Thu, 15 Jan 2026 01:06:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6A966B0089; Thu, 15 Jan 2026 01:06:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA4316B008A; Thu, 15 Jan 2026 01:06:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 97FA16B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 01:06:01 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 407131AE50
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 06:06:01 +0000 (UTC)
X-FDA: 84333162522.30.63297A8
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5058D180006
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 06:05:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=scuVfxqH;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768457159; a=rsa-sha256;
	cv=none;
	b=JXH7OtFNuYl38BAEmJuIqo1qWsF6E8ugTlwxiE4djyMEHn3UdjvUJ17ElGXHtOeJlVAcrB
	mU4Qp4H/Eerbc3MSi47cZE+d3P6xmYOBOUBmj2AVCpnG6UcatG9FePwMdU1YNnlWMP/2Si
	G2q5A9WACciVscq0Cn0nO1NRKNUA2a4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=scuVfxqH;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768457159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cp95f05P+xA83/rUgh+jT3tO7oOGwmlpf1fGjpsoUdo=;
	b=y9MbxG6jKImpPl1JJUj39DHOor9Xrg0uae4Pd24VfxSCclO77lXID4xHDuwBtuH58LKzei
	owRDRmSqHS5WPrjbk+KZS+Y/zkbxZnH+ccKBfNgzeJOml6h8sMb0RzD18+8yn/WWXYkKWI
	tLUPHyRwWmVcIMkGyt6AU4uqZ7oCacM=
Message-ID: <f91fb10b-19cc-471a-8a45-2cf52d62156a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768457156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cp95f05P+xA83/rUgh+jT3tO7oOGwmlpf1fGjpsoUdo=;
	b=scuVfxqH0RS0DP4ECtaLqxeLhUm/MS0pkZ3DN29Jl1v51x5jAQDJI0sam/Mebc5IBmiJbY
	Cr2n1UfaQcHd+BT4UCQczYjJLbH/dlfcEVIsG2SsS1SwNM0LRFM8kw055llt0WrMPuOiFt
	sI7eKBZ+FvUrwZ4wof0jBQiTUgrTEh8=
Date: Thu, 15 Jan 2026 14:05:46 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 00/30] Eliminate Dying Memory Cgroup
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <20260114095839.eabf8106e97bf3bcf0917341@linux-foundation.org>
 <98819615-5001-45f6-8e63-c4220a242257@linux.dev>
 <20260114215917.8eee7b9fa4da37305b74d6f2@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260114215917.8eee7b9fa4da37305b74d6f2@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: hepw6kpbuehyem3n8orudhihthzgwmq8
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5058D180006
X-Rspam-User: 
X-HE-Tag: 1768457159-253346
X-HE-Meta: U2FsdGVkX1+kw/RZQHoEw61rZT38I52CGP8XWRMcBpQIyQtW6Y8ODlpESv7CZRcB+eJGLLq4/Wn+IfomsfiVWQESXINDabSgpCIbE8hiQPe8pVyWp29MgIAJTB7Zmt1Wpnf6lrALiMB29vqUPeWMU5TJej9Pd2NjUT5ofVpZjb/hOHCbQ5kRWUYMdgJd/yZiASo+MC/tCgThIVG1NAdtHouMcJhG/b7hXBfYIUtoPJn6YYKsFie0zAUJB1nTaGiJwXMwInlCeQu+/a/u/oNc5+rqWg5P26wDDcp4lmhNSd3o3bKKtSZ+xlfK0IlVOtZF2nRLP1s/j4N8t7AhQ/B+6ooA5Nwn7RJvmSmAbu1LZ/fPmp3nGXwK0rPO8kc7C88a39eDA1MaE7pdO0LSa1ye4r9YVNEAqBdskLMAuoS46QLAths9lBRudD77n+adprcfCBdqgIOC3Y0DOA9joL9e+cqbRt+PU738AC3oGyMGAncbHDqmcxbCeyKoWFPENPw+tkVvv/SOn0nRmdQ3EZqm+EEmmPdS0sTguOT3l+f/Szh6DZgTtCNxFj785fgV7tsnozX/KxbeKeuj0sXgu+maANm1S7XTF/dCG8RLxce80HHeNXl/EwqTY2vXKP6Fs098QBGbrjiGaRjhJkBSjqWVeVpdRm3goF7l8KCebAeTkGY52Z1LOaMUq84nCxEch47iJvcognVikw3Lxk+Rnm3AvSGVxUyvcLd5CTHDtsSFOTTCqBQGouJ5xgjAD/NpzwfteNQSDJXD7uu8EpKfDZZKMKksEqWynG6p8M7p6qYHf2cJkYSRNJlW+9iDU2x+PnErxDB1iaNlvhtSQ4qBCM9FYBPi2hLddfMeJgmln5GNaimdCGPqrXhU0iT5fdsxMrQmV2+O2fttE8bA869FUsnZ447duhRAoyJGSlCz5FfS0ntm34k8ZXCGdMyFlxwuAtf5gzhc36WiEv+r5j2MzQH
 GBbJX/DK
 m90wkmGv0857ghalkgovKq/vc48iPK6BZ4RbBK+Hkvi01eY08kPSxcH8i7b2F0UIvapd2++UNp3gfCx0THKqLBkWYXtkOLdJiom3bLKSBWhcECvTnRPeOEycUcRXax83KZl6pQTP3xzJM8WAxqlpIHcbqo2td+lP+Xb7EB9glw/3U5+76I1GDVf86CmKRXX3eEhtU4Syzp6JyarP5e8QEl3YW/nkCnR1VIvaU6vnhnTrYQ70=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/15/26 1:59 PM, Andrew Morton wrote:
> On Thu, 15 Jan 2026 11:52:04 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
> 
>>
>>
>> On 1/15/26 1:58 AM, Andrew Morton wrote:
>>> On Wed, 14 Jan 2026 19:26:43 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
>>>
>>>> This patchset is intended to transfer the LRU pages to the object cgroup
>>>> without holding a reference to the original memory cgroup in order to
>>>> address the issue of the dying memory cgroup.
>>>
>>> Thanks.  I'll add this to mm.git for testing.  A patchset of this
>>> magnitude at -rc5 is a little ambitious, but Linus is giving us an rc8
>>> so let's see.
>>>
>>> I'll suppress the usual added-to-mm email spray.
>>
>> Hi Andrew,
>>
>> The issue reported by syzbot needs to be addressed. If you want to test
>> this patchset, would you like me to provide a fix patch, or would you
>> prefer me to update to v4?
> 
> A fix would be preferred if that's reasonable - it's a lot of patches
> be resending!

OK, I'll send the fix ASAP.


