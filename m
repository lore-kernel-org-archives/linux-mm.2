Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50A43C5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 14:19:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C87E6B0093; Wed, 19 Aug 2026 10:19:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 179636B0098; Wed, 19 Aug 2026 10:19:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06B9D6B009B; Wed, 19 Aug 2026 10:19:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBFDA6B0093
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 10:19:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6EB4180165
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 14:19:55 +0000 (UTC)
X-FDA: 85118227950.27.7219C80
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id AA2A8C0004
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 14:19:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xc+GCmXX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787149193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GOsETi3yZCXmrX9YQrYtabDAuoutuTIBcppaw8Vqk6w=;
	b=ri15wDgLRu4XhcV6OPZ8XWHmAafjXFYsP2ORlIO+PfPhlR8Z9WA8Se3doPbc2X1jlzxEVC
	Djz7p+DveMBFF2Ye/vZz43WAV56YRV+5S1tb9dGrDB40FK0zKf1sl6HWo9fdwafR95vFGn
	T9iqBpVYikct4nr3J0RbAnfSPOTqbcE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xc+GCmXX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787149193;
	b=TE95YMqfCrUTmaZYxzLrQX/gSJcneXbYA/XBG2pEUOTYFhi06afh5zJljZoQPel3A3RKef
	PaaYEBIWhysyVwZ7cpTr5WJ+oo7F73+n+R1+z4N0p56Xh+ag8lsvVq4t6jop0rs/z9kw6n
	1miu65zXH5N0dsy3eEJtI0NWkl7EFk0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 21F5360DBF;
	Wed, 19 Aug 2026 14:19:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F20E1F000E9;
	Wed, 19 Aug 2026 14:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787149192;
	bh=GOsETi3yZCXmrX9YQrYtabDAuoutuTIBcppaw8Vqk6w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Xc+GCmXXjO7SWndjDHOMYXk4f3YbiyFouGV1Haxakt28T/a0hPCWi75njYqq9lrpg
	 jVHZUoqXeajh7HibO9BnjItpPccS4yS0A48lVecHXa2WGu9PpTHpVW1zxnuZZwfgwX
	 1jPzc9K04ceG8+g0zLdC+GoRkSzHvxieohtDKTrLEPjAQXWtWw1PH+nIi4g/Ohj8N5
	 KiJg3E+ojnsoj1hbF/NXn93eLMrXOkXUsnsdfjrTP1+3yhATIcPp2NggQgQRcVkvAq
	 Z8AfcmLB2cd26sfAN8nBzILxYZPDuPvf78VG8dT5oUdOrL4hjKmvoA14whUplp9QA2
	 ShfzjJhXpvoTg==
Message-ID: <3113ac8b-c1ce-4577-9e93-449b70818918@kernel.org>
Date: Wed, 19 Aug 2026 16:19:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 03/57] mm/collapse: add collapse.h for the shared
 collapse state
To: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
 ljs@kernel.org, nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com,
 hughd@google.com, lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com,
 rppt@kernel.org, ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com,
 usama.arif@linux.dev, vbabka@kernel.org, ziy@nvidia.com,
 usama.anjum@arm.com, agordeev@linux.ibm.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 kas@kernel.org, jannh@google.com, willy@infradead.org, pfalcato@suse.de,
 rostedt@goodmis.org, mhiramat@kernel.org,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20260816224609.308019-1-kirill@shutemov.name>
 <20260816224609.308019-4-kirill@shutemov.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260816224609.308019-4-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: AA2A8C0004
X-Rspamd-Server: rspam07
X-Stat-Signature: 7hr1tawnn7mwyb6szdozzdn315hih3z3
X-HE-Tag: 1787149193-314909
X-HE-Meta: U2FsdGVkX1/69hM8CniQ2dOgkyH/A7H2g3zyFSDa3X8hnBmShcC7IoYmDwZuSx9NZOemSZoo0xdajz3jPpxxSbm9FMtZj4JJYn+51CUGsE0aLOMjkv/Dz6F6yvijio1GiRho4D4vKj9FYfNxbslmGuTyu7oiQ06NjVf/4AVmp5YzjTfgTBmDGozfMz7j/g9HC/2MUwVBzBoII50PMrPfQPeainCmb1ePyYj+wPmUR/+18Td+P3sUg1oKZvHakos3K/Tj4SjLGO6m/qu7sa302Y3sN1A9zIPwf31gPaIo3Rgq9mFnCjH32xd6QOfOo3mldXup0rnMhxssxzcjJBzTq01SWKD5/ZDIBmxeMpSQEr2979MvhwMp/RHksOT90PJ0lfFE4R3LSDL2vZcbb/V+ndW4JY8k4BJ2AFXBhyZUp5G6HBsqbd7XJtNJtovravY04aNBp/+ZeLYiFayQvLszTm27U0TwzwFwFLyhL/AkBDLv8M/uy33AM+lwgjrSV0ZqThaZqJnzJ/4GZ7jLRWPlEiG/ZPVydaMaikqKdq0IA6BLaRyZ/xcE6Ur2WcDKCvKK+oGFzxOxSEz8VGh9PMNEBcwSVbamDoWbBItQohIBWwO/IyFOTaW1880ug0V1RQuHuntvzGtNCP7B8dxxkC/Xm7JhNBxV7jCgEoeXVUGb/kIC+Maj2UJVVh98Ac6vI7uhw2R0Bvfif2PWfK7bNo0u9iZuj/O43OJ2ZdKrxv3TibvfqRR9sG6S3y3jm7SU6iC7JG2gOH0EFS3fTQQ9ssaKVd3H39sbY6iVCYVwOpO+MngSXWHlZiUufQ1u/ru7O9wRgxsWDf/TT6snMuy37P0sfiXu56nAh1qmCqeVRNlFKAY7+ecOFTurkwXXyj4WlhYrpDmk75DuYIRsF/IggKsTtM1N9pybd9QeMcGif7j0C6kAzzYZxrg5jVHMvDVINVxm2cU7Jy9iPIeN2m9fH3+
 LZmfOSKl
 HcqyW23Rmr/jxr9ksNOX2P+vjTF13aq5CEAFDyPXT81m9BPkbnEWAAB/nDDpbfsOZ3BQbnirlJetkbcE10gcGB5JUNho/PlA47PWNJXcJLWhp82vzeFCQaTIUO1MLSmAkmOjo6AyNFGynJ9ZNkU0HnNCzGF3oIUMuOe1jcY5LO+LRVDzPeDMBbhsNb2DgC/QxLw9i6fMV1gshLmK43LvTvcg2Vmq04XSFMDKZRb4L8JATSIabO4ZArj6maU9kWcND3gGoSnOaXOTMDJvt7wbPLGhiqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/17/26 00:45, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> Preparation for building the new collapse engine in its own file.  The
> engine and khugepaged.c need to agree on what a collapse result is and
> what state a scan carries.
> 
> Move enum scan_result and struct collapse_control into a new
> mm/collapse.h.
> 
> No functional change intended.
> 
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

BTW, I'm wondering whether it would result in less churn (independent of the
other changes) to

a) Rename mm/khugeapged.c to mm/collapse.c

b) Move stuff into mm/collapse.h that a new ...

c) mm/khugapegd.c will need.

-- 
Cheers,

David

