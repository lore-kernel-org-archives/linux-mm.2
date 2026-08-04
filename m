Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C464C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:39:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0DD16B00E1; Tue,  4 Aug 2026 10:39:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE5C76B00E8; Tue,  4 Aug 2026 10:39:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFBE06B0103; Tue,  4 Aug 2026 10:39:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE3836B00E1
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:39:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 208CE1401B9
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:39:50 +0000 (UTC)
X-FDA: 85063846140.12.8180D74
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3414F160004
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:39:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U7wFuYSI;
	spf=pass (imf08.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785854388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MhtpiG6+kpUvMAJXfjVRt16vMjujdjPL16yVvDUppsw=;
	b=uXdcId12dqgxJNVGUPsxM4gZh63wLlKdq/mrkpzf8QHj5rDuDD7N0C8Lduad8PUUtaT/Vw
	eE6zNOloN50Cx6F++6yDjzFMvRFhKBH2uy1eZv1uFRoKi0BZcLsAxuJ5V+/QjdbK8BD0MD
	PeoI9sSSdzDyJYF+m7JX+FxHkBwigx8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U7wFuYSI;
	spf=pass (imf08.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785854388;
	b=6gGNed2hBOWa59lEcyqxuGrbOb6KcnZ73G8ejRg1puC+/L6T5Ub6vygYTeeTH2nPHrcxuv
	G3hzyY1DGt00agiOs7oCsl3yMgSKpGtAta04lyZAevtQdONVV6muO1AcA3t5ldxKQbEGvd
	gDZASuOygYiHdbIMK7RdnjmigIM5KF8=
Message-ID: <7bb32d25-2c3e-40ab-904a-ba22fff60cca@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785854386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MhtpiG6+kpUvMAJXfjVRt16vMjujdjPL16yVvDUppsw=;
	b=U7wFuYSIWMyC9a+9Dlg3QesN0lxz8QWO+If9NxTlXwHrZuvJRNbSG+onU+hMktdtXASsHE
	Nu2Jw5IjVUkvtpmQYQFNyWs0BQRB8raZ/euL2FThU90zruNA+9LXeOa34KIlW+VF0E9/f2
	OpPoaUEKIR3WC8cqRAEwxgi9J/agc8A=
Date: Tue, 4 Aug 2026 15:39:12 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v1 2/2] mm/memory: add anonymous mTHP folios to deferred
 split list
To: Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org, alex@ghiti.fr, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 willy@infradead.org, linux-mm@kvack.org
References: <CAJnrk1Zc1cZa5edmb6Z18nO3xfLBww-7wobxkOe2OJmWE9qzpA@mail.gmail.com>
 <7da62e60-6ce2-411b-acaf-f9f77ef34752@kernel.org>
 <amoWjOnPayHVQU9v@cmpxchg.org>
 <b93cde83-0ce3-4db2-8e53-29864027d655@kernel.org>
 <amtv0YRbSrN6iUEo@cmpxchg.org>
 <CAGsJ_4yWAUcXmVr7Oe1V42szqi2Od-0MhDBspNKURZcBnub9+Q@mail.gmail.com>
 <amy5ZKC2Kc7RX94Q@cmpxchg.org>
 <CAGsJ_4xhbEAiLFt-3N7738zJDoJ=hPRYLpP3tpU2sGOz=ORiaQ@mail.gmail.com>
 <anCpdjEoDNgVbfzP@cmpxchg.org>
 <CAGsJ_4x86EYsMz_n2NKDwTqeiv2pi4AcZb1RuZoBeUBR1iFqOA@mail.gmail.com>
 <anE27CtvCFx7sAuO@cmpxchg.org>
 <CAGsJ_4z7bsDzMtO5PzaSHV4CBYBFS=wmmG3H8xfj-mdUo4VyxA@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <CAGsJ_4z7bsDzMtO5PzaSHV4CBYBFS=wmmG3H8xfj-mdUo4VyxA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3414F160004
X-Stat-Signature: u6ftm7wfqcwnpxwnt44fj6a5kh5m6b5q
X-HE-Tag: 1785854388-179851
X-HE-Meta: U2FsdGVkX18Ucwrga3dhMCYNR5Y3ax9iV9R5mKD8lkLy5Fr4yW4J1QknQ+o1s4MVw5VWKOLtZzGj3flbD1ujO0YJQ8a6xBpLwibKxfG49BNb7YNDy+OgjRhlduoJts2KulGf3Jfe412isimePRAx0wAkgD830meYBuwQHP19Np2hAD7TxcUVu5RW8xGEYKaZwiuJ3CUQcP4iboS5ODEPFGA+5H64WDiidotK2Abt1kMnPay0AhlYP1LBSAw2Rt3nvdds+O9HD2cuxLAuyugNtC6VH6PmmD0SoEV3rrb+KamtKV0+fkOc5VYvzPxlgsBtTuE3zri5xBGbAThOf16GoTU6oRbKcvfLIWMOl/BZ0oK7Nzk6i6IQ3YVy5Y5DKTAlSY7v6XmFex2R9oB+oHaiXg6jtYva2B8uopwgoMXlVOQbrhpsEvz6ZTSoYaSe/Ie5rKCgjc4F6TUk0LZVnslx0EdJ8nMyGKg+be4JEWvA3iu/+NGDd/dPVKq1gGCEB9gQZzoGxKdYSQVBM1nUS8AacAi6TdIo5tpedreyM2kLKSVoJdSDpyDhgwxD14MGxRQp0goLcwtZ70+iSndxm+kU9l0rlZ9puUvSZBYoa88+4xIU0psToTel59sEQPwzcAtkBpKRr5+8pNENz9y5MoHC0w+pjAtAej3K4KHn8sQ8Hz9suLV496P776UJ9GiQ19iYXPIOzLgnsl99Wn9snAN6Hvd8nO3JnxgaqNW/DNZcSoldOmk3w5wZxeTOotc/hwB3ubPH6gBezoOSVxixNicPjai7q44gIXkhiZGG6gV5l/ygZSxYmp2fvcf6oIViXPLzdzmKAoO/oBkRJI+29O7Ust+egaLYXPH7mZ6iHnjJG8qVWM3/sA4zyU0k5V7z6sv/7N2WCnKSCSt7/f4WmNigTUFvz3XALr3jilg+ZuMwkCkIZU00xzN/HUtCUYglzdJfHZxeQ3UC+9AJBA7TN4k
 amk/B0OE
 hKf5V/OK3OFAC/KC2FYcpSOilWQxF0MUExhiRweGOEOEkLiOY4ACUBEsZ/E39iDVYBEDdN9zPj28q7FYnXqIs9V0sgL2jorT6oFQKc+C9mx1eAfMYnMunM3oltfKTqY01/I1djxslw1BFgr0OnnhZi/PszTEQCop4eIxLT2xHuC1RrJ/2yt31Y0dHBGR2OR5J35x+2q4JWKakBRmPr6xY6gMV2C1NydGnSNQMQVzgRgt/t2hCrC7yQButc9EaK3jHIVAeHRerFUNu19iBV4mvfzB+YBxk+sffZG9YjAyEtQwysVk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 04/08/2026 03:03, Barry Song wrote:
> On Tue, Aug 4, 2026 at 8:48 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
>>
> [...]
>>>
>>> #define LARGE_FOLIO_ZERO_SCAN_MIN_SIZE SZ_2M
>>>
>>> if (folio_size(folio) >= LARGE_FOLIO_ZERO_SCAN_MIN_SIZE)
>>>      deferred_split_folio(folio, false);
>>>
>>> If, someday, people find that 1 MiB also helps, they can provide
>>> data to support it.
>>
>> I am very confused. Did you not see my proposal above?
>>
>> Why not this?
> 
> Hi Johannes,
> 
> For arm64, if the base page size is 64KB, a PMD would be 512MB,
> and PMD-1 would be 256MB. Usama mentioned 2MB, which is just
> order-5, not PMD-1 on arm64.
> 
> BTW, I assume khugepaged_max_ptes_none is intended for collapse,
> not splitting. I am a bit concerned that reusing it for this
> purpose would be quite disruptive.
> 
We have to use the same parameter for both collapse and splitting.

For example if you use a new parameter for splitting which is set
higher than the value for collapse, then khugepaged and shrinker
will constantly thrash each other. khugepaged will collapse
and shrinker will break it down.

