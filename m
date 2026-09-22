Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3248C98305
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 08:44:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDC5F6B00AF; Tue, 22 Sep 2026 04:44:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB4586B00B0; Tue, 22 Sep 2026 04:44:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF2206B00B1; Tue, 22 Sep 2026 04:44:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E34D6B00AF
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:44:48 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 22A3F80413
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:44:48 +0000 (UTC)
X-FDA: 85240762656.24.4BB71EB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6E927140006
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:44:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PEd6vwyj;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790066686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L9gRbNdTUyxjBKhfXOwyDG8aLSnmaNHJRGWuT8eoOdQ=;
	b=wgbmNKj80PxWjuGR1NlsREsqLn1YXdVJbEA28LLZlIkSojrleBRxeebCPcIKmgeN0STjzZ
	BHv4oZluYnEj8mn4bvIxTHtT6NZMIqmurJ00gBKcJOYRTMck2lwggDHgBCZwLDJTuMjU2B
	de+pbcUhVRDMuCXNFA9oALensXREC40=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PEd6vwyj;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790066686;
	b=1vrcHXkvifapAy7ehfL286OLVM1sPdTMRzZVgI6QyefFPPelVukrejob6onEeWOfo/aQDx
	OPZyBA7rq43YsVPpiwxZt6N97xqp5hZd40S7M2Qfa/yzifqCf9jYMydVDVh2CUJ8GW6G2z
	LI/4wiDqAwMamzFjc4HEB2Ne7kz29u4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1163A60200;
	Tue, 22 Sep 2026 08:44:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41A91F000FF;
	Tue, 22 Sep 2026 08:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790066684;
	bh=L9gRbNdTUyxjBKhfXOwyDG8aLSnmaNHJRGWuT8eoOdQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PEd6vwyjKQxK5UZsdTxDL09OnRctY2OsBjqmyGXNYrnRjXQZGHf+hbwPe8JUBETIU
	 +AWWI+KsUl7zDmP70bRLe1XuN/SpnZ5nYrXoBcAi16Fzd844xZl3U4STpyBdeN3Vnp
	 2i+e6n/FFhXvKu7OGh5RYYyV6vU78J7IXUBe/ZWQgNohK116msVaraZdhVheM9HroE
	 79raJmEA+RmtQa6Hsirv8NZJFFMDuKjzI1sXLNBJuObT2KB9iBsZsbI+zIMfvGRqCW
	 mcbwRB2eiG7y5MPU+hxjWTgRqGyAKpJ16wYvt9KNLrwk9RWhVEU5X/W+TvfrZzwQNk
	 0shQ3gMxQOfkw==
Message-ID: <c6e2c1e1-a285-406e-a2b6-c09e05df91d8@kernel.org>
Date: Tue, 22 Sep 2026 10:44:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Matt Fleming
 <matt@readmodwrite.com>, Salvatore Dipietro <dipiets@amazon.it>,
 abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com,
 brauner@kernel.org, brendan.jackman@linux.dev, david@redhat.com,
 dgc@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
 hch@infradead.org, hch@lst.de, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
 mhocko@suse.com, ritesh.list@gmail.com, rvvandan@amazon.com,
 stable@vger.kernel.org, surenb@google.com, willy@infradead.org,
 ziy@nvidia.com
References: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
 <20260910114602.926944-1-dipiets@amazon.it> <aqQlUr-1h07G8JWM@cmpxchg.org>
 <8d6a8a63-4adc-458a-b548-a47bf5ff8eb7@kernel.org>
 <aqq8pWI0u1IZNWHT@cmpxchg.org>
 <9f415dc7-adad-4161-b20d-7c3173f50ff3@kernel.org>
 <20260918142813.6ea628dfcc32baf57ba70220@linux-foundation.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <20260918142813.6ea628dfcc32baf57ba70220@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: k6proefedgzq5jfkimmsjbf54rf9era6
X-Rspamd-Queue-Id: 6E927140006
X-Rspamd-Server: rspam07
X-HE-Tag: 1790066686-633977
X-HE-Meta: U2FsdGVkX1/Q0V2HTBcTwtLeMO+apo8dF0tMHMxNLEnQUf4xq9FvM5rGQTLAhK12LLudTrAXmt7uWdYgDyomET4jimks0uVdFziWSxvpSS49/zb6VrBNDhVLCLCQVE1KNl2MwPkqmcDs8VKuueyc+zJS5AksLg5lowDSrVCNJ8zXBcPy4GyoxB7Dn9NII7+hOp0bglSkH3npER/CSDhdtAnHXqKAt/A/Cj0ScUMPsOSjyWv4shetky3/rHgctdaV0Z5M2DWM1B2FZHup6503uiHDdPQCZr+NqTBc5zfn91piAz5ZlOQqwyTGHEZLgBh0xGtu8wZyGHgOz7vdVE1jPNO0yOtXTBCy5eAtkausKj9KB/05Ap4IxA2+/+mjmH3dfKVhP5o5JU3Rsn9gbu9wQf4kHX0nWcnEk7rY6xHLpi01HYz4SN7BmtqRQWXCI+laMqTB/Rl+UThWBWkkVg362q6imQRDhzjxdU+MSGGb4pGjfFr9ghU5NNIaiy3/yjsSf9JbZB0KUuMzixQ2JZlYeVJtuS7QJN0ZuZMLEUzARAUAn+C0MPVSy7Ecl4TdT88LxDDTGwUEEod0yq6yTJVtXXNEDM83KUtW/7x/7q6VrF8pg4XIPEm8kJev3wbN8MhU2Ew/97ximuwQXPr1YHkKp1WXb76uGyb4Z7BoVZbIokizc2e6n/qGES0BW1niqOYReFNsLdwVswr1U50AJCsdZ1J2VZXAyhboGlTI3hnV4pvkgh2yPag0sbrvEPkeQHbhMtN9L9rju25L6cYWAJFFzmzCd6lbA9Zx/u4ZrNRPRhgyvrU1JC8s0zqttvvv9/AdNMm1XhgokY850AqjEbbISskJMK/kC+LGWLTWEGgb0F42JTenoZKFBrzQg/jyDMsRs4yO0lBQLCH0CxnK1GdYkQZHJmSDFLdAD1xt20i9jCo1n7E+7v3pA5X6Em1hK05+I8eRzlRmRoM+C8mYrDY
 CZX1YBdZ
 A5MR6YlSx1Z2TsLO6gIV/xv+hRYadSJidC16kT8mdFbbEcq5SGUMK+jHS66+oSxUrbminAzj5Pf+kNPx0raSZ1VDpT3ZeTLO1HSgypE1IZA6ILCsTVg9AWJ3irwiKzW1JPU3pHNFxEyvhGLQCyaFSVefAvd0dPw7kpfUGY0RlgODbLAXiRzgrSZWwZHR2+nUeRyXX8DM6wEmzD6sdvHu1Mn32iDcSWQJ+TOs5QWNXBBATXyW+FSJCT36fc/6fSI/3Jlg8QgOko3JP9OhlmFKPV97g9agzEniqmFUG5n4Yl65ADSuaDbyK4Va6jnPXQPRZJXeawa9vAoVKZW3Xpk1br8gWpRbvdY6tm4bWqtgvajLU8vB5HUtc352arhucqxKah8MM1mYwMkVBYw+3Ao8aezP/YA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/18/26 11:28 PM, Andrew Morton wrote:
> On Fri, 18 Sep 2026 09:05:40 +0200 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:
> 
>>>> Unless I'm mistaken about that MIGRATE_HIGHATOMIC part, it seems all sashiko
>>>> concerns can be dismissed and then indeed v4 is the better version.
>>>
>>> It looks like a real issue to me, but one that already exists
>>> independent of Salvatore's change.
>>
>> But Salvatore's change (v4, not v5 IIUC) will make it worse because
>> __GFP_DIRECT_RECLAIM + __GFP_NORETRY costly order opportunistic attempts
>> with fallback will start eating the highatomic reserves too?
>>
>> In that case the fix for this should probably be part of the same PR to
>> Linus and be also stable with Fixes: 281dd25c1a01
> 
> Oh.  I thought this was settled.
> 
> I've removed "mm/page_alloc: avoid direct compaction for costly
> __GFP_NORETRY allocations" v4 from mm-hotfixes-stable and re-added it
> to mm-hotfixes-unstable and I'll await developments.

Since it's fixing a bug from 6.6 it would actually IMHO be better to
target 7.4 and not treat it as an urgent 7.3 fix.

