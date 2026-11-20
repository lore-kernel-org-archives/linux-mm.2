Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A743606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bjyawddn
Received: by kanga.kvack.org (Postfix)
	id A05CC6B05B1; Fri, 20 Nov 2026 05:41:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B6FA6B05B2; Fri, 20 Nov 2026 05:41:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CC986B05B3; Fri, 20 Nov 2026 05:41:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 67FC06B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:41:02 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 798271C47D6
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:41:01 +0000 (UTC)
X-FDA: 85455154722.16.8598E71
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id B1E574000C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:40:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bjyawddn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795171259;
	b=Bs5Xv7yDoYS3THrCPwjHIqZvjJHD1kf7EJKt6G3Htm1IBwoz1Bzj078zpd614NLzpcPPiW
	SHIdy5+a/YTDZMOTq8SAETRiE9bFi6mzK5h8Bq4YKiblUkv+Gs84huNCixoQ/DxQhmapG8
	f8xn+VkPFUsEBsfPGb60VrwYhtfHP00=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795171259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wuF3voKG3KiMsxJLfQZCJijkDisSiEB0JzslwfKJP50=;
	b=AiaFHhPfQvI9mDZ/vvi0i1DaWE8t78DhtTSYI/4f+Mu4JgGXU7eEn4YnYkfWZ8iF6xHIUp
	6LAf2mnA/FBrBXvpyqxYqazFM6NOt8YdbtldSjJM0PewVCSlxH+whftj44L07G7KAOBPI0
	pvw+Q5bs9eLjoeH2c1zusM/aHjmFCD0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bjyawddn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E2B4F4581E;
	Fri, 20 Nov 2026 10:40:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6403D1F000EB;
	Fri, 20 Nov 2026 10:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795171258;
	bh=wuF3voKG3KiMsxJLfQZCJijkDisSiEB0JzslwfKJP50=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bjyawddnWiPtZYcrrH/VNFTmoOnGihjVjMZtQYVGsg4PsDddn4HQL26RBf+uD2Dqz
	 OlWv5iNZz9ivXgBWpweKGQs1X6mIoUbkMcFyqcluFNFtSngw57ZU9M+WnO4jtB3JBT
	 kmlPWaR0mW3D8f26oCjtZjBznicmVSatGMNRpvi1KfPeG+e5HTFBGIykhoDwKky4yZ
	 kp5c2N0sxSR/+LJW/SrJHOxNW6dw8TNaJm5RqaY0hHjHg60wu8NjDAYmvnrSIkCcxI
	 mBcKJzgukxs0OE1NxKslLElUXvL+JqI02fq1fnwPeuw7W+dblIWzqzDmS+uJxDRs7a
	 rbZXtkS1Og7XA==
Message-ID: <a9fda4ff-1758-4ee5-ae43-9a951eaf44e1@kernel.org>
Date: Fri, 20 Nov 2026 11:40:53 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] alloc_tag: two fixes and one cleanup
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Usama Arif <usamaarif642@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, stable@vger.kernel.org, Chris Mason <mason@kernel.org>
References: <20261119-alloc_tag-v1-0-efcccfd3a9c9@kernel.org>
 <1f12c78f-782d-4d03-ac3b-7321520f02ed@kernel.org>
 <a0a5c3e0-ef9f-49ab-9f2a-d1a2e1e1934f@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <a0a5c3e0-ef9f-49ab-9f2a-d1a2e1e1934f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B1E574000C
X-Stat-Signature: jqoy48bq9ssujautr93znf91njw6jst6
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795171259-137892
X-HE-Meta: U2FsdGVkX18FgYMIvN6uf0zVJhj2FKZdSS05TDCxqKfbddB7QvyW1c1Gaq75PYEiTRkhdAyuDhF16fQzSMniQGWDaIXp6icdNHdGWj5u75MFtCFo2fCjg2BmPQBtRombj/5rfxGlN6g/kdgN44xwFSuwkJ3wwGsO00fr8RLPlLA0cWHb9nO4UFjj9vm3EYrPzYkULT5WThMUp1MAUL5cL4GqE6J3k7KO02oaj507ETEYUdrLU1Gt0bDrV50bIET5zC1z3q5bG9vpd4MV+qZAfRJVZakMpayFv8UsG6p9oD7TGwpBGEzo+FXx03Ramdxlz0p0iwGbj+RDdGIOTdhKgz+QIP/vygobHxG/KGuZ8g+wNW+a452U1FFpaF2Hr64km9ix2lZh7tl+Xan2WX8blXVPaI1JLyuYymDc7/Scgur5PsSUQQZJHmHy0xwgjxGRaXOiskQuHdFA5vWWCnBs9t/hKRIn+psOUU1uJf2JM9Uqijucciuv3ayi9dy5iW5s8SrxtlYEl//oYzWf3fE4hdiOdcYriqmmXtGwnnX74uB7MnMlWAPmvVNNeVO/Y6PLJnwUL/sh/NgkGL7OoZy0G1V7I+8nsXkCt/UjSW9bV92ndHbnMtwarYKnn/N1a4rWC34dh8OJVkRWoDc/DnlQyLmQQ1x8U256IAZ2imZNR6kASnC4cFkezRc6J5N4Q9f8FCg4ZAcB9PBcTY9Zb2WBdS+3u/obl1T78a9muQM4po8yhHqLLldxRDnu342LNmcbkRC7nDGQLXZVLQRpjuRlFddbuPT3IbfuHQc6P92U3QbfAh4lZ3+c0cTDUj48GKQTnrXAmFLZEBSdnFZbhI7h4HIlDxHiy+Zo6DMQXs55DakCxBNcwa90fK6ytlv8TeUZPHVPA4ukaLk+vIRm+usqbegm5/bKIWyR7KUWzBSVZtobPR31UT0xRvl7EcZy/LHqifw579QBISreSYH543d
 m5M4+2RS
 A2W0Mo3sKpRMitbD/73gWqIiez9UxxNuo+0HGhDWB7dcG6atf7GKEXGv4EgMDPJwvjvMU4SwlzR4OHjc129RdyZRcnnnLOp76FvoXZANpGxlczd32CKIoJ6w2OtTn7IBV0L9N56FUUa14zlk1cRvKng4c3myqgqddjNosBixP7E0NVnPIi5hvhXV0V5ECjUIXIOL4xnXXa1RCCZarLO88C5MEjVXiq5UaINmp7LNTZ/Nbq3yCMRPBcDju5hIP07pd1uzEkV4LNtDaDKM51HnqCI5Tc/x0PN0hDREQn7oXn+b/YEW8Gi2vbUk9fMV11GJDkrg1iwUazO+/YQG79XGH1iWPDgcny4HkNqR44HlmI3RSN7OY34v7Wu5B0fvihn4UbMYio2sny4zfxSoxR3xe5Foi9WQYIMsM9u8PJRJPa+Wew9h/BpslDPUmNREF323sxqlTY032qEIQORWsHtqK+H2c4qCP5/tWIW3H2MKUy5SiJAtVbTlxHUwecZtlu5FGFfrZHcxliPQTUv46zIEkll+slxgWqrOqP4Jg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/20/26 11:08, David Hildenbrand (Arm) wrote:
> On 11/20/26 11:02, Vlastimil Babka (SUSE) wrote:
>> On 11/19/26 09:52, David Hildenbrand (Arm) wrote:
>>> Hi,
>>>
>>> two fixes (one for alloc_tag as triggered by slab, one for mempool) and
>>> one related cleanup to make things consistent.
>>>
>>> Quickly reproduced and tested the warnings in a x86-64 VM.
>>>
>>> This should go through Andrew's tree. No need to rush, it can wait until
>>> the next merge window.
>> 
>> mempool is part of slab section and the first fix while in page_alloc.c is
>> also for slab, so we'll take it :)
> 
> Thanks! :)

Actually, let's separate to minimize conflict potential

patch 1 merged to: page_alloc/for-7.5/misc
patches 2+3 merged to: slab/for-7.5/misc

Thanks!

