Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F06D8C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:24:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 131786B0096; Thu, 10 Sep 2026 07:24:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10A2E6B0098; Thu, 10 Sep 2026 07:24:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0218C6B0099; Thu, 10 Sep 2026 07:24:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C77666B0096
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:24:28 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 590DA1404B7
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:24:28 +0000 (UTC)
X-FDA: 85197619416.11.D08B626
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 87B5E1C0008
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:24:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c+VdKMTZ;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789039466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D8lcb2nj5Qw+R2h/P0sXPBSrOuWk4kRlxcimVGz/6uc=;
	b=K1jO33vnJ4RaMFj71VN32KWKQBPhuIQWn3cIF8B4/GNO+Y+ewtb9Xl8VeBKsP87oEvKje/
	hzsQ5rPSI1pQC9O2WtHOcfk+hqX3uGg2VNQ0uKIv+v+iNzZ0gNIbbhRdCWNYXax8ezxm9v
	O8HLpGc1meiWJ+UqgW4hr1Bb0xQD09E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789039466;
	b=S8flCKmm5fKEs6a10bPawKMHyXH+TFHnoowbcCov7HVO/JijFRNFfo+uEytcaiviUTrkHs
	ZuI/X0ky9Lhuws+aLRC0ThlN4duP2l24SAMmu0k/geFriDOw/o67zVXKiAw39JGpmEZdY4
	1Jzfv5O+WTmgG+qwtikI76LofNJkENM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c+VdKMTZ;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8EB2841215;
	Thu, 10 Sep 2026 11:24:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E651F000FF;
	Thu, 10 Sep 2026 11:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789039465;
	bh=D8lcb2nj5Qw+R2h/P0sXPBSrOuWk4kRlxcimVGz/6uc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=c+VdKMTZQ/uO5Mf/ZmrRZ1jhqqlUW+oRuXyXaXjT6xqCIEI5zWcPjhGXnkfV14n94
	 W39+6DQ95wE3xgFYkI09MnVXNlKJyymdRZ1bm1IMuI3vuRful0+ig/zVU2VHwAtLX7
	 dXoyF40NkApa79X324P9AKBcE+efTSKfGCfW7q7bu5VSMT6r3QDpp1FZg0qqRU6BwJ
	 pK8zPKHy4O4qHAyc6U5EHgZOlXN3BEjm9FmTjfMNJM8PU2bfe65Eu9dz7TBbN5PwZc
	 Gv6+G37ITEeP5kcyoQVFEXv++15r1ncXxqvhtHVo5CT1yOGSc1xMMrWmgo+WTAYeoF
	 d9D9zxr7ArzvA==
Message-ID: <31418d0e-9745-4e8d-bc02-dbbd5cb9e193@kernel.org>
Date: Thu, 10 Sep 2026 13:24:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/3] kselftest: mm: introduce alloc_isolated_mem()
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260907-fix_split-v5-0-822b810458bc@arm.com>
 <20260907-fix_split-v5-3-822b810458bc@arm.com>
 <5c05b620-7a2f-453d-9725-fed4f536a019@kernel.org>
 <aqKOVGECsCNtSMIV@e129823.arm.com>
 <d0b3ea99-e20b-4883-8fa3-67fdbf5b1ee4@kernel.org>
 <aqKS7CP67X4h6NiM@e129823.arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqKS7CP67X4h6NiM@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 87B5E1C0008
X-Stat-Signature: oieg1jz4zb4j8ijkac4fnj386tx7en1n
X-Rspam-User: 
X-HE-Tag: 1789039466-466832
X-HE-Meta: U2FsdGVkX1+fgJQtc6Pz0fk6ndAHYyQ1HKUCtFW3ere01H9lYl6qiUtcjMGuqym7x9OUJ0x534d/ChVQpMDCn0W0Dla8r7Mh1+K8EIVATG1cq3bbs+a+pK23PlY9ojlx3QQhHo6VZsbgV3TxJ1tb1W0Uy5B/TfFQP4VsjD0T/As4ySpeFYuySiC6QeOJAGGkTA9sEmWnkIFAII6dIppk+xXmjsF5cE1qsTVjB6VxvqJ7KUpDu2n2ucdsiDfnZWLgO9TPIhhkJCtQOzBKBZD1WbUJtMfCi3bbDlRjoQgaF9Y9kvpStZBHTYipLKhppXifcC4O0rgnCHVyzbocI1jkWV4GzutdnGZMoKiLZEpiTktFpeZNojzCUMixUZPQDi56nbLowE1mIw7eHcoPlXTbymQo/grGC7s248GY22YwlRbskVPJkgr40u+B0XIr7lqu11MD+Od9oyyEPKaJrRsr/jlQD6SH24IP1smjP43HLofPLwWGOD0zVtgoEgFFk4yWOurn9j1kHYy7WWB8jh4rIZfry1riN4eb4GHOqvmhtdQli+YCb1R+t0+Gcc41urbGopPFpODKtT3VamCCHngzc5f9hQ+svgNALJRLPEntS54PrDFlzyHscZsFVqAnP2q8fe0NeVOPh8CE5BdokwcApEgYi8sVCzbjcODVe3aQTtzkwLlBJkxrlJpHcdCra5f9yfjlcsvp/IMSLExTsjFQ47pouBFGZL8pekgbZW0f76RxP5KWeSirJB2XpYoN2ymhAmRWyBY4m4dPOsMEMWXJ5GMcAvvxABkiA+X1gKQdZVDE/6967HdBon9fk4Fznat88jeuMIRwl6FGFvNEUK7cDcyhKgAO3paDmO6dl1j76s3j+iIVdZN5Nvto9AjQUMuoGn5VZvgC4yB2DQUjCsAtZ24I+gWhFKqpJq2ydb6w95sRSRyWGmYWMJZoFL0ZL7a40VV6VvtW+83URCI+kgr
 PuMP5z8e
 RExS+YoRK5m8q+hM0JSe1ZKrnT2JIWPUJN8JrrbYc5Ct7iVb+CkcgbdW7kctU8PU2DlWj5aqukRP0bGWNuqmShATMGDYre+0GlBhNc+HpRxzV31skytjzwXuhIAhBvzih0QO1ncZV7fpHFj0GPSfFvmuVSiVbuKzF8mYMBSzeWNZOw+c8j+EfzARbMmNP0QKv7TJ38KyDfh0w19c6gs5dOZQptvIFhznueiyrOkhaOMD0NmWBvmREC+XAh9G7JeBlHqwnajC+awSBsUUNc4BOL4Yjx7OPSuyVBkucaBh2DpxLMe04I76OGy5zogMIPXlPgwmKEa0CrbQ5ulo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 13:22, Yeoreum Yun wrote:
> On Thu, Sep 10, 2026 at 01:14:42PM +0200, David Hildenbrand (Arm) wrote:
>> On 9/10/26 13:02, Yeoreum Yun wrote:
>>>
>>> Since there is no interface to get vm_flags not via /proc/self/smaps,
>>> It might be good to have it for preventing unwanted VMA merge.
>>>
>>> And might be useful for future to prevent unwated VMA merge.
>>
>> See my reply on why vm flags are generally not a problem. Just like other
>> properties that are not changed during VMA merging.
>>
>> Let's not perform random code changes without a clear picture.
>>
>> And just to emphasize again: VMA merging could already be a problem before
>> memalign() internal changes.
>>
>> (also observe here how we do a MADV_HUGEPAGE, so this is all rather arbitrary,
>> which is not good)
> 
> As I mentioned in my previous reply, what I’m trying to prevent here is
> a failure when checking, immediately after memory allocation,
> that a specific vm_flag is not set.
> 
> Yes, I agree that this could have been a problem even before
> the internal changes to memalign(). An unwanted VMA merge could already
> occur at the time of memory allocation.
> 
> So what I’m trying to avoid is a test failure where, due to such an
> unexpected VMA merge during allocation, the subsequent check that
> a specific vm_flag is not present fails.
Which is only a guard-region marker problem?

-- 
Cheers,

David

