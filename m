Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6AD6606A327
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 20:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eelJ0Ehg
Received: by kanga.kvack.org (Postfix)
	id B21A06B05BA; Fri, 13 Nov 2026 15:22:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD2DB6B05BB; Fri, 13 Nov 2026 15:22:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C2006B05BC; Fri, 13 Nov 2026 15:22:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 78A576B05BA
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:22:35 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F17F21602CB
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:22:34 +0000 (UTC)
X-FDA: 85431218628.15.A13A08E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2505B180009
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:22:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eelJ0Ehg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794601353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fZBLWHhKZStR4J0kgZ8KXl8AdK3ThP4v2+4JtoQHNqU=;
	b=Hxz3P29TsXmblJQyi7ZNztbZCzsoeQVt2AL7Q6W1GrqiQuWToB3AdZ1AkxccjnzJ6P9OHZ
	DsHvXyf6MrWJHTyxrX/DDVoyVki96oUrgXNb3R2Xnal5KGy1N8841TQkilbOF6BL3l103N
	dm/6otzaB6F5AQ22s34rYN0v3ws5ZJc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eelJ0Ehg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794601353;
	b=o4FtQBal7y3yWMfRhUIhUkK/JLG1BfmIBGlhz+Fzsy7/ymjKNjrfqfyEaW6depjvlvDrax
	0mHqU6uwxCXkMVIoVTnOvhEYxhMJZ5bUmtuao2Wwr8z+1gEXRmhLx9vQ8GTAbtwUHjZFg2
	RZgdZYJhMAR9CAu0WfebCR+X40Ofdb8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5BB3643082;
	Fri, 13 Nov 2026 20:22:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725111F000CD;
	Fri, 13 Nov 2026 20:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794601352;
	bh=fZBLWHhKZStR4J0kgZ8KXl8AdK3ThP4v2+4JtoQHNqU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eelJ0Ehg04DJnjRcI5vV8i/R2cvAgWEc4w7TDjR82Zqf9Mrurdi0U2ViM8LCDluqc
	 oDQWu74h0bM84pqGElumjpFz2Z6u9BHuy/sxJFFgFwMeaeD/MWzz3Stu6qLLYiRPDr
	 aLzekm0yKnWTs+ts5d0hdLYEGQYf2Nd07SIJmG2jXYSQ3RH0RbA/T48Ft618xXZgAt
	 n3V2xlNky96ihS/K8lvBfqcAqh15I8CF3y6SLp+hqFk04XYUvRVwZAsCKb3zCzS/Ai
	 Dhc5ck670LitBKhZiVAT8iWPM+6tXP43Vhy9sq+NYLD2fyDrbyelvLcmcX2Pli0xGs
	 MZ0Petu9Db8YA==
Message-ID: <835c18d0-bee3-41e8-aa46-05dc7c1ebc64@kernel.org>
Date: Fri, 13 Nov 2026 21:22:18 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/15] mm/hugetlb: various fixes
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
 Andy Whitcroft <apw@canonical.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Vivek Kasireddy
 <vivek.kasireddy@intel.com>, Dave Airlie <airlied@redhat.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>,
 Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-s390@vger.kernel.org,
 luojiajun <luojiajun3@huawei.com>, Josef Bacik <josef@toxicpanda.com>,
 stable@kernel.org, Chris Mason <mason@kernel.org>,
 Daehyeon Ko <4ncienth@gmail.com>, stable@vger.kernel.org
References: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2505B180009
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: aa11tco3m3kqyehwi8pqt373n876kpon
X-HE-Tag: 1794601352-281356
X-HE-Meta: U2FsdGVkX19DuYgnFa9UKSmrAl8B5up84S1Q7Dc2hAADi5Y6FDrRNK48TyloYDnJWplY7Vk41WCgwXyyzABiACrmzp9EY9aDT3zXruG5Yi42E8bqG5RyvehbJQn2XVR8tprlXUOoR0ZIxhjxtzK/LOimyW43TmjB/pS2oBChOyw6/zLZFB6LMN4vO7ylHscbEqXSbhhISc3G/2hqFWPaE/UTCumyIUjWJAXPbvGqxHi5xBQTTWfNwHuJm+Z5267kC+XhjBAnsnerdZaa4ZxmezejON1WlV9nkzl5BKMA3tVGRGU8OEgFBk713KacZCa4vzed3F+VSyfFEVd2TR8rc/J9rc+XfZK9joTa0VzqTfwUgzIzMI7m6PZiDOmm3F1fOA3KBp/KWIcuP2foPAvXbgXh5Fz9DG2RcwOcZYKFzuswSmE6JFtAsHsafFNZ5bSIiSGyWlVj4jrvQuTv+C7h2Mnn+IfQ0BspmiKy1qPghdoJff0vqeWWfv4T5RJ922ZwZWGHK5pPRMzPp5LK4zzjkJyFOwnbYk1p1mjC25V24XEK+Zx+jG+VWUzuiGWiDgFwQtwLZkHo03X1fMh8JTW4Kf4sPfrZ3Uj6UI85ilwaOTAy1K4fi6JgDj8Kkp6s/EQYSoa0hsa/ocNGIgL+qlkFcbJZWg3bWtCCv7jSwOdK3AkqxLskYWGi6q/yp3DU9aicx/J4FUs6e6pZmzN8/92L/Tmgq3Xf3MqA3nwlpxMBzzPBNecfx6/MmFvmQ0N9kVYPbZY2tC9URcvJ8gS0vK/Tsiy6oZEgljjnxELOe3hAK2Kx4lJcbg/56wO6Q6Q5W/pZyOWWafRzIVcFFxEnauTRa9QsWI12DtRITwa0ZTlJWodg11SSIe2VG198ZlVVCa/vLK4DIU9f13Xs9Jro9uQXh+IG4Tl8mLG9M+InOMHg7aozDgsCdv5WEGqDekt8ofKyqS077hKPqXKsgM4g5OF
 G2fjW9aE
 mZXOlK/ivne49b9sQaaKejp8Io3T4zhZSjvT2TZIHeUPbumrasItOro3SNjRCP9sCqimksEQJ1QMGymHtq2qaYARgLnSA4uPsHdtlCU0LKzgPX4REN/78Hg8dC6X0RenCRwsfeOT/0K4fKq8GfL6hAqW/8tqWPFlkODCBnRGO02TdAes4wufnF8jsRq7RXSbQdVlgy/zoquBTfBTa9KvMtn94qrCKnaNdv+MJGFLmJ06X0DnKWNPDXlVObCrABL1ekzyUubs2cgtPT/b1wC1hBQcEAROICShV24yc2z07sN6UHK5HYQPHeygj0ez8aXpUW54MEgPdrUErDG9SR3qyocayDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/28/26 21:13, David Hildenbrand (Arm) wrote:
> These fixes almost finished me.

Muchun, Oscar, should I respin with an un-rfc of patch #14?

-- 
Cheers,

David

