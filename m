Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99263606A321
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 06:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AsNyDcLj
Received: by kanga.kvack.org (Postfix)
	id B05336B012A; Tue, 20 Oct 2026 02:27:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB7E46B012C; Tue, 20 Oct 2026 02:27:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A51F6B012F; Tue, 20 Oct 2026 02:27:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7D3596B012A
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 02:27:55 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0C0671208D5
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 06:27:55 +0000 (UTC)
X-FDA: 85342024110.07.8E64ED1
Received: from mta1.migadu.com (out-83.mta1.migadu.com [95.215.58.83])
	by imf03.hostedemail.com (Postfix) with ESMTP id EA12B20002
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 06:27:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AsNyDcLj;
	spf=pass (imf03.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.83 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792477673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oXWoMZ1H2pnRsuoYdPPZZtfsEnR1q3jeWNCSU2sUjT8=;
	b=xU/3+kYfBzoD5ZmySjsxW9y39W/KadSvC8p0x9QsDAj2ko6AgCkyq2Fm5F+CvYXGm+nouX
	TVbP8GFw+/qGe9Pea/LXPq9Sjmu/fDYfJ8Y6EPlq0qu/9gdW0CDC4ckZT7iiki4GFFhF89
	lfHZkkCCFdM9esejYdCGme1MMttkmuA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AsNyDcLj;
	spf=pass (imf03.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.83 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792477673;
	b=Yl+FuvbqF558itWcLaIURyQQ7BwYoM/NA0PNrbv4U0oWwb0hS0hX1cIUSGfIUD//NyTfg8
	nwocyXuhvfkyFBhAyMPotdHUQh7QGOZ92rlQt/cm3SlqRlj3ZWtQqqVEwOfyK+q/0gUtX2
	hbfZsWyag/M+7hDuFLWxSVyp++4OlV8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=X2OA0zhonpjv/0S8MYbPOzRw5uUgYP/J0+GBxLUXBOI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792477671; v=1; x=1793082471;
 b=AsNyDcLjkdu2n0NL7PxGF3/m6VarwougfDaUnY3GcZdm+lvmOqbgCt6fVITMQjtAvOtP11et
 Z0vvO9Jt4L9kdNOJEiKHNXCnYDj4fzxypgv0gpS/ZidlNnA339d+SL81/zoMIeWAEu+Ij3gkBry
 BPA7mVq/kQMPooxWn2mzSsPY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3dba75d8f5189ea6;
	Tue, 20 Oct 2026 06:27:51 +0000
X-Mizu-Trace-ID: 3dba75d8f5189ea6
X-Migadu-Flow: FLOW_OUT
Message-ID: <a3d410eb-e7ac-43e3-bdb7-d00445cdc7d6@linux.dev>
Date: Tue, 20 Oct 2026 14:27:39 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new] mm/mglru: clarify the generation placement in
 lru_gen_folio_seq()
To: Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20261020023548.3242028-1-ridong.chen@linux.dev>
 <CAGsJ_4wnuQhyCkMq1Dub8HgB+uYAjy+LkgBxCRJG_kZiwAxA8w@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4wnuQhyCkMq1Dub8HgB+uYAjy+LkgBxCRJG_kZiwAxA8w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EA12B20002
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: zrczmzws8wbyeurd6ozg1zu1xfmfrna5
X-HE-Tag: 1792477672-830199
X-HE-Meta: U2FsdGVkX1/lanEbfIEAz+smUYALYzqg6XK2qDU4lnWzy1gHJ1TiBASnGjGnNsSnIC18VBm0ciE7mCUco9Fftt0ogah7zO91I89GSupN8YhNPXxdc/Ex8iSKiDfYXQj6WMTIr0o2SswfaGdKNxDz0Y7KwtBwE0nkrnw9QruMxzb0NWNE95gm96mwGB2pt4tO78Y09Mm9kI90Cr/xdL4hKclis71SifS5Cr66J6fcxp0nchDpc1fn5S2yXiJKitIfiz2rElWOfvWqBlwQRsrRDhRe8CrUaJ+bbCjS5+/OYJWdryzY7ehrFp+GlvgL6gsQshISFWihkC86Yekf1xr6TT1Jwt3jXDwzVFbnwyF5MM5iYfaAni4feXolMJnQXjOoj43iiePK6GIwj0t3iF3xZXHNI5KqhKnC8vRC5+Stv4Vv2IrZEEt58bk0pgTwmC+jMDpfy0ROeulusN2J3AA6HAsjE/Kp5JARYV6fG1M9RRY4hEaCFpGJWW2xu7VFqONzKsde7q1srjjKLnad3ubQt8A4zb1hdqRw8BYI7DWmXprTRCMDZMR5TGXvTdJgs/b2CHLtAb4EJAgbeOmTh+/Rz/kzXvvyBBMjcUg0QzGkd0aqHp3AsxPm+4dI7up667m5g6SSYQkggqYJ1E3Q6Hkmbv9+aWmiRM5NMYr8uOEeBjcPi/lNltdq9u4I/VvSkZ/y5fqVN4cYymHYx3xdM4mySdIt0qnTFG5V3cLh8EyQoKxGVtW9bavsj1IWWScJj+wBCV9Wqi+oZg5BQ9aIihqinJtoGsxZNyizqlEAqiHqevDmWIim6bClUGzFkoqXEFWPnQ83wfQDLcY84nQyCCGAx36HNesBDqvJ76FQmeqiOQtsLn+YqntNyOBVT0gfAaUZXk2MBxQ5lFVJgX2W2e6bCuLKuOy85duOGemIbtKBGSeOBppUYVa4MMi6HyH+bPD9BM4KIW7Ysp+RK6Prbdf
 3T9lMmAW
 xk4jJD8QIkpb0s5f5qbtR0Bx/1V2ogu9OscJ9ZmbB0shZ42+Oa+QIQf/Y97MFinPOKPwFq7xzUPGqwyyWSW7TJa5Mezv7O1fxwP0G0A0SMrj8fJUXiB4R7GSxK+ScZLaMrObvxCeDF2YNHwTNjqSOT0mUVU9SLiOCXbi5FzyzelMq95LZVjifBvUXv5X6l+dl7eESq4vmFqcrF2ejEJAc6sOwVE6gDp6XBnKjkUxV/0TS66pYdtJKdmqZk4m32p/t75MvvA6RnJVvPabfDoSCRYKN/GLpdA4a5OVB26FadQ3a/6NpvdcbCVen77fcoutyOzl+0YWsgS8fXTy872+7rpODcPtnS3hCnjUT0We0qGbzM7QRkw/pND37pQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/20/2026 1:43 PM, Barry Song wrote:
> On Tue, Oct 20, 2026 at 10:36 AM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> lru_gen_folio_seq() computes how many generations below max_seq a
>> folio should be added to, but stores it in a variable named "gen".
>> Elsewhere in MGLRU "gen" means an index into lrugen->folios[], i.e.
>> seq % MAX_NR_GENS, so reusing the name for a relative offset is
>> confusing.
>>
>> The comment table above the code also no longer matches it. It only
>> covers the PG_active and the final branch, leaving out the reclaiming
>> and "can't evict yet" cases, and it lists LRU_REFS_FLAGS as an input
>> although lru_gen_folio_seq() never looks at it.
>>
>> Rename the local variable to "age", redraw the table so that each
>> branch maps to the age and seq it produces, and note that the result
>> is clamped to min_seq[type].
>>
>> No functional change.
>>
>> Assisted-by: LLM
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
> 
> Hi Ridong,
> 
> The cleanup might be right, but this part is changing rapidly
> with Kairui's MGLRU-FG series. Maybe we should wait until
> that series lands and then see if this cleanup is still needed?
> 
Sure, I'm fine to wait. Looking at MGLRU-FG v4, though, only [4/17]
touches this function, and it mostly adapts the workingset checks to
LRU refs. The local is still called "gen" and the table still leaves
out the reclaiming and "can't evict yet" branches, so the function
stays just as confusing after the series.

Or，Kairui, do you think this is worth cleaning up? If so, would you
mind adding a patch to MGLRU-FG to clean it up, so it doesn't
conflict with your changes?
-- 
Best regards
Ridong


