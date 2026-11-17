Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07770606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 22:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WQ9Ih8LR
Received: by kanga.kvack.org (Postfix)
	id 03CD26B00EF; Tue, 17 Nov 2026 17:14:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 014886B05B1; Tue, 17 Nov 2026 17:14:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1E9D6B05B6; Tue, 17 Nov 2026 17:14:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B77BA6B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 17:14:33 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 837741A05C9
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 22:14:32 +0000 (UTC)
X-FDA: 85446015984.27.5A8AF15
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id AD2C7A0006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 22:14:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WQ9Ih8LR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794953670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R+2KYdjMaOZoj65JLgMEFAFNxfok4kzbLO0ccaHB1YM=;
	b=wIAzQF7cjeQFzbxIcd8K9djnB/0+364FCufZKgFB8YA8Otyb1d4OhYbiUCVnFus81rM+j1
	pfMeI6kS2KCsVN9g5/KIwbUQR+UM3lvN/REs0PCfpXAMaJJ6BpY2i8HrcbLupT6ogHeEc9
	husSS+T4RCT1p6NeY4uezC8SDc21nOQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794953670;
	b=013ZhNDgNTWjtkEvX9TOaPUcskLAKNtQgyFDqREvxCOonwgK0MhKKBWBTo1ir0zeDCEsnN
	Rm0I0RUhDn4ideuwkN4339hU6TkOlOqO2+2jlN8H+++46IxsRRebKpbxsfiSpA10patQmi
	dAxhLPNMg699KUf+9pGT/LDiFoszjqA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WQ9Ih8LR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D516F43288;
	Tue, 17 Nov 2026 22:14:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 175341F000C4;
	Tue, 17 Nov 2026 22:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794953669;
	bh=R+2KYdjMaOZoj65JLgMEFAFNxfok4kzbLO0ccaHB1YM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WQ9Ih8LR2PtaoATHxRv4/qfWJkjd9zFSoe9U1ofQ2bEGEwBmMpHuicI8cSgsdKW2h
	 Rj1yLoXjm3xzEBkpxwM5vyNGAJc+kf0MW2n/ARn5Dk/+5ZxVP//nbXzgMTEzbYCJ7a
	 1XiuVU5iMW3SkxSJCHHP+1e/zneOkbHQ4I8dO810X+K20GX4LLQa0+k3UT0GvJKPkP
	 hJBr7H3Gd+feLI6RE6RgPl+GhV2zVfrwQudtZvLdbPMdxTqzB1TECfwChQNsCRYNeP
	 6rZMwIC0ZskAnaj2PoCPP8uMBDt1MeTDTh68Vesfzpd+kWP8kQmwnrqsT7HL2VYV+b
	 CzY4huscGDOAw==
Message-ID: <51878e96-c283-4ccb-a06e-4ffe799cb130@kernel.org>
Date: Tue, 17 Nov 2026 23:14:19 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/4] mm: add anonymous mTHP folios to the deferred
 split list
To: Joanne Koong <joannelkoong@gmail.com>, Kiryl Shutsemau <kas@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, akpm@linux-foundation.org,
 ljs@kernel.org, baohua@kernel.org, usama.arif@linux.dev, hannes@cmpxchg.org,
 alex@ghiti.fr, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, lance.yang@linux.dev, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org
References: <20261103212004.1356327-1-joannelkoong@gmail.com>
 <20261103212004.1356327-5-joannelkoong@gmail.com>
 <sashiko-outbox-198104@kernel.org>
 <CAJnrk1auD1u1J0yQrXOeJrxvVsQfbxYf+nsMS-9qFQ0hfchG-w@mail.gmail.com>
 <aux4FcaEdTrJ60NR@thinkstation>
 <CAJnrk1Za6=B=Y3HOaJjhU7orq_P27QFe92_n9F2y2+108xDSOA@mail.gmail.com>
 <CAJnrk1YTX=kmDY1zwLncOpzTYsJ9UEa1h1PW9egV59hpnpO=WQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJnrk1YTX=kmDY1zwLncOpzTYsJ9UEa1h1PW9egV59hpnpO=WQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AD2C7A0006
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 1n9a3diptbyoyn56frfwjgp56w5przgc
X-Rspam-User: 
X-HE-Tag: 1794953670-336163
X-HE-Meta: U2FsdGVkX1/gXmEeZLp7GL9+ABfiB+goTJs2OBQh/577ClYr2IF4cqQNVYDLi0uQ3is5B9NvjZN+H+mFJlYBc/pAs7J88nT0HhD+U6idD4g1Dn2ObePGfIBh+w7FSEhZfeOwEGSCyJzL+U4CZLYyjLOfJPJBT+mI0HgpOlUF8kqQHrLzDK8CI0uTTtoRuGyAIKlL7V/JXzaoiBjcys12kBJ/u7AwLCTMm+xIW/d1QIk4pXxjFkTe6rP2JVFqNR1V+chqfTmBPIa2my62MZtGscaT8OG44xSU71gxSGEPl574fGksy6C4Owo8VywdcqWg3IboNREr54tq3um2CG8IbyWGp2ZJiiTw+4Hqso0jPZx4VFyQqrCrXKzTwAys3900zqIWzrKGCxsbcQN3yGcc2W0RaXv7zDWk+VGCUaPl/d1GbY6jkoPNDacFvBNFyq30VR1TS5aoWm/ugfShRA40E+3t0Uol7l3Y07NOIri0SXlH/61qzkzPgYEwDS9Fou8mp/lc12prwHanTP4Uz8PgQ4eCyCJmKkONAq9OK++JZveu/L88pc/x8zbPI4dCRFbkbZEY7qyPzXzUd6rCb013VYb2osNy3d6138T9tRAw8LdAfHA1BsWpaNr8NfLb83zW7xejmPvoTooZzDOHlcoBq3qxblA6X5sLtd55I0F6UzrL5dzKU3Rjh04JC88jpPQ0nfmFyWG6xmTibnYtgGoFrOQPZ7smwKLcFL8ymCHtICRZj2lbD1xtKNie1iJy9ANkyE1qeChZWFTMzEWbn9McB9uu+/US2+2AbRVw7lCv7KfyX5RaKVXrpzytGPjbGwolQPIyWvcqcRM/aafNoTGCPcgDVVFIzA9Ad7oAoXaVYFl9G7GBkCvp+e2Gz/aawN+jbvhcx9q1pG5O1R1P6MTEnesgE8hgT6u4GPAmAudoOBm3X34BRi3y9Op5PhVs3DObTYvOFzE6oUQyibBay4L
 Lldv+l0o
 suMrxWA8yTTop2xDdlc7URWLJQl0t2ccNlyuI1xgQaPvA+Yy5Pg8XU67mgwnawyV/dqyHo5Jj7EmxJ2lzG4bFjPs0gFbvuGhY//h/c3BtmHQMUHNttE+5ruzFDFw8xcIt1sqKfH45OMeJXvkX03wSXpTDWSKvAcRUF1zzWhAYK8i9wEAssMD1dy+VS0bQ+4txyBGXXPZ4XpqJraQFJKcAsffYcPUp4XKv0ePqaJ8Od/P2nwPQqk6No6Q3Pko8nu1O6+mzXE2Ggn8eSwDFw9utraOYD5IlVc9+OPMn9jacmKnRnxKDSWe07G2d+1s1RUonu1AKQtXueJEB6L8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/9/26 23:29, Joanne Koong wrote:
> On Thu, Nov 5, 2026 at 4:05 PM Joanne Koong <joannelkoong@gmail.com> wrote:
>>
>> On Thu, Nov 5, 2026 at 4:37 AM Kiryl Shutsemau <kas@kernel.org> wrote:
>>>
>>>
>>> I think it is a bit of understatement.
>>>
>>> For mTHP it is every underused split: the folio is always PTE-mapped and
>>> try_to_migrate_one() drops one PTE at a time. Each underused split bumps
>>> split_deferred for that size next to the new split_underused, and a split
>>> that fails at folio_ref_freeze() leaves a fully mapped folio flagged
>>> partially mapped on the queue, which the next scan splits without
>>> calling thp_underused().
>>>
>>> Can the fix go in before this series? I think it is hard requirement.
>>> Let's not brush if off as pre-existing.
>>>
>>
>> Sounds good, I am looking into this and will submit a fix separately.
> 
> This is the link to the submitted fix:
> https://lore.kernel.org/linux-mm/20261109220958.2071687-1-joannelkoong@gmail.com/
> 
> I'll wait to submit v5 of this series until I've received feedback on that fix.

I assume we can make progress on this even without the other fix in place just yet.

-- 
Cheers,

David

