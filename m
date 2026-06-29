Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73FA2C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 07:28:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 440D16B0005; Mon, 29 Jun 2026 03:28:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4192E6B0088; Mon, 29 Jun 2026 03:28:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32EAC6B008A; Mon, 29 Jun 2026 03:28:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 093346B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 03:28:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7D2C31405C0
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:28:02 +0000 (UTC)
X-FDA: 84932121204.21.D66538B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id BD0E218000B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:28:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782718080;
	b=kI2zOxLV2HiwE/ZLNI3x3CiMD88u4NlHOihhySwJF4nlXKgDy5TOAUlFA1DrY5iNFj54b4
	zU8nLvoQhXnwyijoo0TyLpCn5n8IHpLmEweGwsRL4CUU5GPSy8VWNEnzDNMSzIK+aoaWkR
	23rVp0072iGAetB8hGtgSpeF2dIl7sU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782718080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9K0ZkzX+wdmwIdGa0Hqy9PfDQUOF8G3dL0/A/ACpZOQ=;
	b=PKIO3U/SkKaEoMLb3gdL5zQG6wCuY5i9GgK+JbggrBWaI+ATT0UDynPRNY8dqBnqnFSXvP
	lNl7WG6VPPkvMEd09QoiufKVKfbvJtOtNM8LBzzE0JWq1q3zPCxdi5iX8wuXPM6B5xFSy4
	MrckdsdDyVjc/uLGqscbzJ1nJsuM4AE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 31950600C8;
	Mon, 29 Jun 2026 07:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04FF1F000E9;
	Mon, 29 Jun 2026 07:27:54 +0000 (UTC)
Message-ID: <fd16413a-95a7-4503-80df-2d71303498fa@kernel.org>
Date: Mon, 29 Jun 2026 09:27:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] cgroup/cpuset: rebind mm mempolicy to effective_mems,
 not mems_allowed
To: Andrew Morton <akpm@linux-foundation.org>,
 Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: Waiman Long <longman@redhat.com>, Farhad Alemi <falemi@asu.edu>,
 Gregory Price <gourry@gourry.net>, Yury Norov <ynorov@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 stable@vger.kernel.org, Tejun Heo <tj@kernel.org>
References: <CA+0ovCg05rUk1-3k2ysdxmbcER8aG-wVh9SSTrrbp6LPWpPHYA@mail.gmail.com>
 <CA+0ovCgfHJHv5d1mzapWWvF-LhjppzDX8NPPLvCPZxPKg8RiYw@mail.gmail.com>
 <20260627231508.74201ca47c883507be97d8c2@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260627231508.74201ca47c883507be97d8c2@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BD0E218000B
X-Rspam-User: 
X-Stat-Signature: e4rkpqwfoj1h4hxu1xdzgifhsw86catr
X-HE-Tag: 1782718080-69932
X-HE-Meta: U2FsdGVkX18JdExBHrZyrnNqe/YDd38ewncZ4sVKexCcbnmqGBFzEEQhIDlZs42JJzEmvrBRfzXMzdM6eVweqIwmYnitQhlyNMB5QDLbuU4LjjNRSXNRxX5dmtOsLLcTmcjbRIqAxwfRJJTj+tP1S3xOwMRC/4dFvyVwMB9kw3TfDfTyUcNRiJwvRuANjmZLslw/CBQUUhMZh2bJ1v8A/1jL9+APmY0yNriDhHC/HnNg3Qsa9hFtnaPHdkB6dWc8Rf8JsBXTh+XabJsvrXGiJ6wetdjqdK+gQUubH+3L4uFoOp9sjxnJ0ylMXfMv0XvCLPSct2SRUhDxQY/OvPEJYDjh6mSfw7KWaYzipt95iHW9j033DvhqicxG2Lb8A27AAPdaO2yefVgxPZuafNT03uY/2eQ5IMTwG/I74lcNSlMnk8lnk4cfQGMw+NuOUSXCg9HjbB7NBgSOAPyLw1jARP7dy9HAAw7LJg2pAbEI4yiidH24lXBeQqDadvtjrz9eFcSr9ZMg+++gfugGiH8+clHl7JhDBoZ54xw8C1gHSSQX2gffT8YzfDvWvWTLITV/1lsjZtL3Hx1VZHs9U4bWiA/M0oz2FMipqY/eqhQ75+b5Loj9jsWF1r6l8oP0xy2ZIx5YU81rRdWkCSs2oEqNTMVz7Kh1zofYBPGygfRDPu7OqgcpQ0hC2m8jypifULa9Iu+4EoDXzoEE1D1UWuPeaqzHNVyyeqF5bfOV94d0q4fGzUvIDjpx4e1uQWDz4pWAX0LebFQgbgr6tWnVP+U4LNkXVYXMvqYX1cSrviThx9QVg4ovOgAoT9+tFv/dpi+YhxX5kxBGv9yO5uS3SlvPMh4A05P/TncZcMuai361um52N7+N/iGr1LYqZdk8lTo6uWThwtiA/XXGrpSQpQ4OfSuIEn3T/jWrBpIpSOLADqYhRQUzx5dA0zwIiVDtF57QDfm8Z9mTswZGuOvlpLw
 OAxjMvPs
 /+qY7bS+k7l0cMxjG327Bcv2oh9Chn80WvjAaEuETRdG7SmtrJEfHyV7fmamBXPNVAf3DmoR5Xri7KErAqR6g4RaWQcmhygT+UzbnhU3M9enNGLqT8vajw4JFF6i5ZcrTXcT8u7HL8MY/HVaATlRGqRm5O7kT4iXCptC44jy3VXdftCL2i0tsuJdt84HIlIm/HpEfiM5pYUebinq0Na2cIqL33TTlM5N18GJ/2UlMqeTjUghPSOvd6lQzHOO0SuMyFlb+osySXkZLFuilV8NOCi1Xtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/28/26 08:15, Andrew Morton wrote:
> On Sun, 14 Jun 2026 06:25:55 -0700 Farhad Alemi <farhad.alemi@berkeley.edu> wrote:
> 
>> Creating a child cpuset where cpuset.mems is never set leads to a div/0
>> when a VMA mempolicy with MPOL_F_RELATIVE_NODES rebinds in response to a
>> CPU hotplug event.
>>
>> Reproduction steps:
>>  1) Create a cgroup w/ cpuset controls (do not set cpuset.mems)
>>  2) Move the task into the child cpuset
>>  3) Create a VMA mempolicy for that task with MPOL_F_RELATIVE_NODES
>>  4) unplug and hotplug a cpu
>>       echo 0 > /sys/devices/system/cpu/cpu1/online
>>       echo 1 > /sys/devices/system/cpu/cpu1/online
>>  5) mempolicy rebind does a div/0 in mpol_relative_nodemask on the
>>     call to __nodes_fold()
> 
> Oops.
> 
>> The cpuset code passes (cs->mems_allowed) which is not guaranteed to have
>> nodes to the rebind routine.  Use cs->effective_mems instead, which is
>> guaranteed to have a non-empty nodemask.
> 
> Well gee, what happened with this patch.
> 
> I apologize for misfiling a cc:stable bugfix into my post-rc1 backlog
> pile, but I got there in the end.
> 
> I guess this is an MM patch, even though it's against
> kernel/cgroup/cpuset.c.
> 
> Nobody cc'ed Tejun.  Fixed.
> 
> David acked v1 but is being coy about the v2 patch?

Yes, after the discussion, I think we should add comment similar to what I proposed.
-- 
Cheers,

David

