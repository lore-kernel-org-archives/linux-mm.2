Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 779D8C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 19:46:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72D3F6B009F; Tue,  7 Jul 2026 15:46:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 704796B00A0; Tue,  7 Jul 2026 15:46:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61A756B00A1; Tue,  7 Jul 2026 15:46:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B5866B009F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:46:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B899714052A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:46:23 +0000 (UTC)
X-FDA: 84963012246.04.3AFA46A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id D154610000C
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:46:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n1kQlAxi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783453582;
	b=ML+mi7XY/1OgDGxYHXOsXqCxeegLItUFQuKPUFHukGaV8a/grXlCo5egpSGPV+Pu9EmFY5
	JQRS1wtpB0bXRuzZwceUA1QN034VIFpMOmF00Qfkg19q+Xwj8AqJxboQcXimKgvjs89myH
	S7bHGxUy4HddnWexrnU6RvRs0wuplpc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n1kQlAxi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783453582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6CsXTWyk0ab6TZGDQgEzm0qZO4v7/IxSMWXikYKxYHk=;
	b=kq3XIxzMCth91o0goOjv9b1UgY9ipfCwO1JEX5rMDG5GVYb10zQui5NDRCiDcC8nAOhUKj
	EoMeoxgpxMTBe+KCkM/Z51CQbcfFB1Vrk3fJ2yJoVg82Dz4MbfNPldIoVY0zeIb07HP0B2
	Bk0n1tVLW44NTwVO6NG2X2KMh9eY77o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AD9BB40A8C;
	Tue,  7 Jul 2026 19:46:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6821F000E9;
	Tue,  7 Jul 2026 19:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783453580;
	bh=6CsXTWyk0ab6TZGDQgEzm0qZO4v7/IxSMWXikYKxYHk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=n1kQlAxirZ6gXVxiJPfgygY5nIqZGV/MVJWXnTBsQHs/rUxip9w21/8joxuvvuI/h
	 s/e3noMXh/1PzrUc+zV4W5tNg9mmv9tWOM1Ip37DsRknro4LHKrQJpXGKin6jlrsUS
	 0eUbribKkLsc6X3hRqvUeMi/Qb9ssfryw7FnnThXWYXs1IWefvg78zLNocQRc8lr4f
	 2HE8ifdZCIkM5HwksrxAKxeqnzSR2NjVLR/MCBPa6I3wELpgctRGO+ZqbyGMYZBQ8C
	 uq4+47oCtV2nv+SCr66h1z56XwqaIBXSTio8EcocIV0e3xBVvzwXvzZRTICb/AoPQY
	 /Wrqo6TWgVW9Q==
Message-ID: <f9bad4b3-93ee-4daf-84d5-97f6ca305240@kernel.org>
Date: Tue, 7 Jul 2026 21:46:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/6] mm/hugetlb: Dynamic, NUMA-aware HugePage Cache &
 Free Page Reporting
To: "Michael S. Tsirkin" <mst@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Sourav Panda <souravpanda@google.com>, muchun.song@linux.dev,
 osalvador@suse.de, akpm@linux-foundation.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 mhklinux@outlook.com, fvdl@google.com, gthelen@google.com,
 mike.kravetz@oracle.com, pasha.tatashin@soleen.com, rientjes@google.com,
 riel@surriel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org
References: <20260707064235.1386552-1-souravpanda@google.com>
 <9624988a-366e-4884-9408-3f3b88c27290@kernel.org>
 <20260707062428-mutt-send-email-mst@kernel.org>
 <b9a48d89-74f1-43d4-b7bb-be988b6855c9@kernel.org> <akzZr2jfJ0J8zox4@lucifer>
 <20260707095843-mutt-send-email-mst@kernel.org> <ak0xWgpJPSaNWPsl@lucifer>
 <20260707152755-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260707152755-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D154610000C
X-Rspam-User: 
X-Stat-Signature: ez5qiumtnowk1rphm7mbcpb46mc8snnt
X-Rspamd-Server: rspam03
X-HE-Tag: 1783453581-666802
X-HE-Meta: U2FsdGVkX19ZDL/hWL8NWH6T3jXipktcnrJSGwH3zbxzObonwxEMzcWnqBFtTOg0jJCE0NdryS0nOIRH4CoSlVMvXt9Frz/7XJ4JhqHBXk+SB8FQU/8kgFZ5CfUggIUKV5coCjGWl4uTh8Vt/mwplKRJOYh8borcI0HlhxT6l0xFfJ/aSBqF+9kXlM115caKouCpaRrs0/YokKBo3GybpT4t5cEFhbD4HDOvVUakv42IvTqZfmW7Kueud6giRFP7t0yhQOl8MJ0QMKGRZPW3gcs/8mCJPkE5b2BhUfoJHDduDDtB9c4CUQV2PxbD3fXXcLzl6jXS+5ROwAtHiXHLUaPxOtnKwIb3s44D2tJ2W9hus0gSiRKG6FhRuJtp+rhNQixd8IKfTgb4RU9hXwzDy8yCUIc5IrzljUs1G8NOr+xmEclz3VNh+XE2oPSMAHtzqHqWt3JNxtmID38AqM//ii/gl/7IbkzOB9pkUs6Nwh7dXBMmWePNA95heQ1qYKE6a/r7jmYjEqa/60hZUikbysMM8bq5xaR3rr4JhM7MoRdSKIck2Nz3i52cA/jZsM67Nd+szI/N7hkqfqO1DMMjFq9lxlrCbBg3B3ft0bheNumI73VQG6QDs3BXjrKSbsm2iEHPfHWpN0RNuIht7DtpxjdF7fV1WdGrn2+JYgjyxM/oIySrU7eAvi5CLcfru0vBCsBqjD/onuOLBoStwW8DeSyngpvzPwCsg9kgOnIPegCDd+xntqI9PugNnFyqERYIZbAWfM4pe/kdZ+3WJ2rAdx/DpHDU2m/uDJtb0pvYLrrBPb2ySYskig1hHxnu36WVElC5Ylx2wiFw9fk/v5AbidgWF8meTYEJX/hlQTDtTRnYjqed6QFpiQBgLV369sOV9j8YdeHUq0OLvvNWIlGwPDQrierjrJ54WhqQDZm6k/uRvoyJU8jf51lDTEY7XLCnFW/HlHSl8Oc5YP5NFS7
 NwkYnYMq
 VNJJ67EzLozHRgtE7y2mJrUlmPBVsL0/My+qRP4orFMot9ECw85G03hQmYvUrI9fL3r0FQp/ByDiOOtnjrQMegxigdCjc9O1qUPUMIfEcTk0QA1YlVKJfbRcYtYflsRiT8x6FK7rVnmaErEvri19D10URsSS49WYHxDAG/bUN8IvjvYD8vLslfKFCnsol64J/FMiwsjAHN14FBu+mMaa49AyMdiAmSKIWD8NVKiu+FLUHzZpoNbafvUhglPwI0WZqPMyd7OwyR9Yxw1Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/7/26 21:32, Michael S. Tsirkin wrote:
> On Tue, Jul 07, 2026 at 07:46:28PM +0100, Lorenzo Stoakes wrote:
>> On Tue, Jul 07, 2026 at 10:01:55AM -0400, Michael S. Tsirkin wrote:
>>>
>>> Fair enough.
>>>
>>>
>>> Lorenzo, do you know *how* you want it reworked? Could you write it up
>>> at a high level?
>>> Because if not, it's not really practical to make it the asking price.
>>
>> Michael, you're an experienced maintainer, I'm surprised I have to tell you that
>> the burden for that lands on the submitter.
> 
> Oh sure, "fix bugs A,B,C before you add to this mess" is a classic way
> to actually not end up with even more of a mess.  But I usually do try
> to be explicit of what are specific issues I want submitter to address.
> I don't really feel figuring that out lands on the submitter.

Sometimes it's certainly easier. With things like hugetlb there often just isn't
a feasible way to integrate it nicely into core-mm. It's just too special.

-- 
Cheers,

David

