Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18D97CA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 22:20:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33D6A8E0003; Fri,  5 Sep 2025 18:20:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EE268E0001; Fri,  5 Sep 2025 18:20:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B6108E0003; Fri,  5 Sep 2025 18:20:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 014198E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 18:20:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AAD1E140382
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 22:20:53 +0000 (UTC)
X-FDA: 83856617586.01.9F5B584
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf16.hostedemail.com (Postfix) with ESMTP id F1383180011
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 22:20:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=TCqeOMh+;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=dPtpTyrI
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757110851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=odc26EmzyJ8HGpXoYPMXxK2vau/006W/+LwKY/jri00=;
	b=PZyQifcmoUbZck1qbqiqlrV+C+1WdIdVdW6aY7rGnuphJgmBp8fVurBv7kw+Pfz5pen37N
	wUCq+aA/3AvHOJfybQhJHIs4i4t+8Ep+2YtiBLp/jfs9Ml1edIRLIvAEHTbaVxLDOMEnx4
	638fLtwiTMduURVtrRwBg5obtne5iy8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=TCqeOMh+;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=dPtpTyrI;
	spf=none (imf16.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757110851; a=rsa-sha256;
	cv=none;
	b=McvZ1j2A5RqfoI65zFODYiYqXz7MSDvx61sYGUmiKV8gC1C2SvYfUSV4fYI6V7ZYIPRkOR
	P50SG5z4D7AJiGD6nelG5Wgss2ArUEV5G5DmS1Us19VghZQBH2k655YXcED70YOtzSaMFS
	2eN5u+4iu8JBpqYXp9bSRa6ASbIgL8Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1757110848; x=1757715648;
	d=konsulko.se; s=rsa2;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
	 subject:mime-version:date:message-id:from;
	bh=odc26EmzyJ8HGpXoYPMXxK2vau/006W/+LwKY/jri00=;
	b=TCqeOMh+LiJj3QUTqFaSc9rzXgwRa+HQTJ25aT2mgd20EMKIVRaXBH0FMSMI669cEEap4CsRjCbMy
	 eWYwom2px4Ts9s+/xn/aLTmU6Idnb67yIfMwjgVsloQpv20pNINeboBaDFrMJOzYqcHwRL6SCDCILm
	 2gk86JTdrXLYQl+i4fZyfj5d6/ziZsOFPriAwZejwWjW98MS6rMT2J6IjcGdq4WqzsNPurpcr1j1BF
	 hmWWW0S1fA/4n7x3/UpslHS7konv+VM43ZeEF8ZM4o9uejj7Xkr6LhoQBApGeeR9xB2u6VHg9esu5N
	 7yMahW/zvA5UdWu4r66iSuMYXHJShuA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1757110848; x=1757715648;
	d=konsulko.se; s=ed2;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
	 subject:mime-version:date:message-id:from;
	bh=odc26EmzyJ8HGpXoYPMXxK2vau/006W/+LwKY/jri00=;
	b=dPtpTyrITZpEsdUxVo9uhiVbg8GNRG6UIPYCNNOMgE/ZpxiviHFRR7Yu2R67F5QhZbOAMEZkA/kOq
	 nNyT+vtCA==
X-HalOne-ID: 92c59c38-8aa6-11f0-9393-632fe8569f3f
Received: from [192.168.10.245] (host-95-203-16-218.mobileonline.telia.com [95.203.16.218])
	by mailrelay2.pub.mailoutpod3-cph3.one.com (Halon) with ESMTPSA
	id 92c59c38-8aa6-11f0-9393-632fe8569f3f;
	Fri, 05 Sep 2025 22:20:48 +0000 (UTC)
Message-ID: <16998440-84fb-45a4-9134-5dcff71ee68d@konsulko.se>
Date: Sat, 6 Sep 2025 00:20:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm: remove zpool
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
 Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org
References: <20250829162212.208258-1-hannes@cmpxchg.org>
 <20250904093325.2768507-1-vitaly.wool@konsulko.se>
 <20250904164710.210731847fe25d9419203886@linux-foundation.org>
 <f0869789-ee30-4eb9-840a-502d031df1f5@konsulko.se>
 <20250905113043.3fb70f94c86445617266c958@linux-foundation.org>
Content-Language: en-US
From: Vitaly Wool <vitaly.wool@konsulko.se>
In-Reply-To: <20250905113043.3fb70f94c86445617266c958@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F1383180011
X-Stat-Signature: gzm1cye3j1ttawcurxjs73bso5rwzx5n
X-Rspam-User: 
X-HE-Tag: 1757110850-338282
X-HE-Meta: U2FsdGVkX191hjEumEFZtZzYogK0TvupICFP3CgpVnvmFPtUJIvoEHDfzHeHIpvzKVNnRFL/2X6wZqNAY0D0wCd7GJbmfxWhphn70jPfh+sCzHN04Vd5iGIVi+RgC8dd9LJYKD+DZid3gOLEqM41ws+fsj1RNm4omwk2KrtnnKsjWGvR3+DXkJVpD7kl2JjT476O4c2WFvbtIAhKAKFU70OvmGROfxVqiM0Fobbk/GLlbmu+qLjmlsxkc5zkfka5/BkOfGHemnml8nEpWvryv+MdQ5dwB9/l2SF+wUPEuZSYZetLLwJ39f2GfgZv1FaONxLT7K7OwvX4cjvyoH8IX6fJ/q3s1yW5jYxRbyO7zB1iNe+kiSKJpo9yFskc9PU+kZS/3iWBjZiELeF4SAafxqWG8+jdMeOXCTNwemtfFoXuHZRZIDxDAtdvA65QBRWUxcwNqctiHZhqb8vA+05iq3AXK4/vkt5xDtGg6hRFBXfJ9lSmj26eeu8cta083IT1DLf/05HWt2LRLPstuF0sZBUUcdYR5CjoRR/dRLyCd5ZohPFfYmpTzVzWPbJOyTTp1ye3hKUuHCdD45JD8ZoZrvfG9k5i7345yNsB9PQ6sVSddYn73jMmvZ27uO8beyyQ49YnYYva7tsdTW4onFdrsLcIP36+VsWs/GiH9FxCNyx4C0Lp/ubVvEP0yDKc/rvlrC20M5xKlwjjczHMgLb80GsL4TeKj8A6UHuyhUqIiu/EY7GzQwrwpeHiv1U0ECDmFC7vqb9IXCi6OuROQNjLithsDoBMXZiZovfbIBJ6jbIuaT4LFisR1zLARKO00kcbCNNzNh3OHOmBLHe8dXAABiLImvV5/c40tQ9/ue5llFm5GovVuua2D3bP91uBkvLe9x0RtcQzMtq2OrHf3oWmi5RgvZ8v1wJzi7E8p9A/8yeM4dL5wo3C3j1asz1W5EJxGvXMRZCQAvy4qLTwCrM
 8Bo9a7vl
 XNGmMuJ80d9Aut122Qsf0UtiGSlkBiW9gFWx64vtPpG4WN0Zcg1Ubx8yXVvaxrslmsHHY33iJkad9vikCCOF/6ErztFLk+K8kl4yGYZHHC5b4DI2FBwSoLsNM4m0K4CLoLIUxjz9bM8dk+GSf4bCEmQ3f1qmvcZicnfa2PI/X5H6EnNmfrCEPcga75aLVn+UOj1bVc4dkxRhQKBnuN9vJ7HCODksN8f9oZSGs5VJZLWuMLSLrEi4josOQkk0INQT5CoI95pZk3ts+m/zgF2FvrLbsHogfaYST4s/xqwv5zMjHWT0Q1HVHCFXpkD/QxwpN7w/AZUSarOtEKu1SZifh8lRIKIXd5r+spChB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/5/25 20:30, Andrew Morton wrote:
> On Fri, 5 Sep 2025 07:42:34 +0200 Vitaly Wool <vitaly.wool@konsulko.se> wrote:
> 
>>
>>
>> On 9/5/25 01:47, Andrew Morton wrote:
>>> On Thu,  4 Sep 2025 11:33:24 +0200 Vitaly Wool <vitaly.wool@konsulko.se> wrote:
>>>
>>>>> With zswap using zsmalloc directly, there are no more in-tree users of
>>>>> this code. Remove it.
>>>>>
>>>>> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>>>>
>>>> Per the previous discussions, this gets a *NACK* from my side. There is
>>>> hardly anything _technical_ preventing new in-tree users of zpool API.
>>>> zpool API is neutral and well-defined, I don’t see *any* good reason for
>>>> it to be phased out.
>>>
>>> Well, we have the zpool code and we know it works.  If a later need for
>>> the zpool layer is demonstrated then we can unremove the code at that
>>> time.
>>
>> The whole patchset [1] depends on zpool, with the whole intention to use
>> it on the Rust side.
>>
>> [1] https://lkml.org/lkml/2025/8/23/232
> 
> Well, that puts a Rust wrapper around zpool.  But what user-visible
> benefit does it (or shall it) enable?

There's at least one user ([2]) of that interface in the pipeline.

[2] https://github.com/vwool/linux-mm/blob/rbtree_experiment/mm/zblock.rs


