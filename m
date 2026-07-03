Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84E2BC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 19:04:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D6DD6B00B5; Fri,  3 Jul 2026 15:04:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 488956B00B6; Fri,  3 Jul 2026 15:04:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39DA86B00B7; Fri,  3 Jul 2026 15:04:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0FCA16B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 15:04:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7C3CA140290
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 19:04:33 +0000 (UTC)
X-FDA: 84948391626.07.3CD0B2C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id DA1521C000C
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 19:04:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CBVsGjI5;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783105472;
	b=bsfk6nFQOu/rQ++hWpiVnQLr/wZ1FqdD9gLY+jhS/LSlYXEOvDwL8I208OfdjlySxf2GgJ
	IS9WW/8kp0Jy5s9KabPwVuPYzMP/zv4X7xtCNbikM3Dixhwcz/Ibxfqua1mE/5MHUgvIg9
	HuGAbR44A+AlzRMV5rIQLvsTAoDv0b0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783105472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OUtVmkb1xdoAAa5ycGAXmAUp7beR6p0/p7fLJoMo4dA=;
	b=kI06GqDAMJAxQxphCB51Jfshy0SE0QsGyY7Npb8QHYMF97J/bd42qoaQhOgMJfjBWGGz0G
	0cShYZXI7AN0L5O94v45kyxacApQeLzeOMNx96CvM6/Y8B6byCo45jbC6ucMv+cAUApRu/
	4AVeS78x4t9Z/1fvWhoPGf8WMqFDCLg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CBVsGjI5;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EAD9643AB1;
	Fri,  3 Jul 2026 19:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43BFD1F000E9;
	Fri,  3 Jul 2026 19:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783105470;
	bh=OUtVmkb1xdoAAa5ycGAXmAUp7beR6p0/p7fLJoMo4dA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CBVsGjI5LZTNS/uhJj9/3t+BgzAKJsCXhVGL852GhTKmqXDbSVUcLcsq4HBXqUxMH
	 Wy/ypjFnWkuIsT9MjRUblmc1KW04NX1gxqIJo1PkfxFV46d4KObLp44aLwmHGII9FX
	 sbhasIWXNAGX8qUTASCwf+N9Bg69ULbsnPy9e76ZObpUNPAdyCah9NVuH3qreKk0L8
	 uM0mYtIV/7rQaw004zI1EyG0+fdC3mYRL0UwaXswGsObCKvRkN0LyOpuRnLAuXv/T1
	 0RMhwEX/TEQKzDU0LmzmilFo1WPSVLpVYTDpfXVgdQflqrnQSDjJLnJP06+fkG4sfk
	 Se0pdGbSuOoew==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	Lian Wang <lianux.mm@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	daichaobing@sangfor.com.cn,
	kunwu.chan@gmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	linux-kernel@vger.kernel.org
Subject: Re: [RESEND RFC PATCH v2 0/5] mm/damon: add mTHP collapse and split actions
Date: Fri,  3 Jul 2026 12:04:20 -0700
Message-ID: <20260703190421.100480-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702165235.86684-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DA1521C000C
X-Rspam-User: 
X-Stat-Signature: 15uh6sqozr6q8371kuzc8ob46hashcwp
X-HE-Tag: 1783105471-221214
X-HE-Meta: U2FsdGVkX1/yCZtS32sxa/Tf3srWtSiXPLHvGZ+Vyhoboau2xHlPJFn6XCjqJ/Y4Ri9lyhPJJTtbOSCkLm9JmNbsh9K4QMRJEXjkX4nOYJ+9NNn7Hus/KmZ3p+wVx+lOh2FTwaO4TzJWV39BBl1fvcTVwniaQltHuUFze0YN3vi+0GPuEMfFn8BcwEnr5KYwXJrUKRq2bJDUb2B2eJxXRVoRdPOaosnitdKoBjIzv83ddTvFuGYDLjfRhQ79z4MonUar3cBHpQMG5tQu/BCL9K6X+8ObcsUmB8Fq7pHHi1+MRfnEv+Me+fXOqLcHz5tW5dF/HASf6MsSusH4MaRnazDqzG6KiAtRqwgPa0Gjptx2ymjQPqL/koJmFIAC886QiHkCO0MqcEY0DedmwQmTBljzZHRoWrvZTWGN97ocsHlP7Cp4MZEzG+pDoKeLcwloaVU0CcioM+2iqMCDc7UTCfeXUEj9qH6800wRfLmY4pJ6tTILfgNvtE1P2SbhZuABbtGqrtVqTOM8q02XZCfz9NdTztNVZwba8OdoapEBRV+N91Tqwrswij1v3CG8tj4IxWrdLX7boxgghM9YkfZt0eS/JPc8pbN30xKlNktZfNgIoPKLgOWxMJ5y+l4TnOGyk4r5Lv/DiwadK3elaO2Qu/6d5B9IaNEcXDP4ymLNb0vAqLBS3cHGZgSzD7q7Y71IPGUcJCyEXUjg7dKr/gydI81JCQedwNq4i8m6LwV5WkW4SdGoJiNxMik6ZIPQZWfH1CWFILkBxcbK7l+2y8upSCzVBoLNQY8mEkE5R/bQEb0RMbRD+rRdvDtQHbTw2xnVCHFeszaJr16o9XvMXVylx6FfVU5cLi3qzSXAV2rEANUkYicM1oOQZPHu2sAEPPzB0VDGkK8eD7wIPgyK+xNHacACwobN9VvwDb+cpxHSR6DciF+zRZiT8R9P2iOiMRMgpT51O+0k77FaEChLLWF
 40+6QzZU
 7CTxTTIThrOAvjde2hbd6xL1nOTfb9jIHkrzBU1tfd8aU1+ps82iJDh4d/8nCbGWnZxo6Ew2v7wZ4nKp17EQ02QWDmyWvzBee9Tbx4P84gf7PczBHJ29PBbo0YCvfdBYKkK1kZJJyolPL82bpuQ0qBZ4s+7xOuCDnZrlgo2upAQWJvU3Cn2OgziMruwIGl6ueExwv2Cj6/6oj5F3/nmc7V9NzUsPuvXomMqroMLJYB75Uo7SI9qDOV1sXXlyIiqAjlaujCvjoF9r+sDUqiyGyqmbegphFotI+/AY5yQ/IUSve4OZpEp3+fo4I5KvC3kTBGZeFgmXri/E7tmW4TAE6zYD2DbnmnzgTZ5g4p5wQJwI3CkILdl/vgPXsqt3ypRx/oQIv1ZcdlZEOReg6/3f0gDNvafuBeXnREIE2Ss8o8oo/gTsQNG1V7ZaBzR4RwhWz4yd0t226/Nkb87iKYsUoCEq0Q6+Ha6pdr1DHgQEwkPfGGhpzzDsKJZQGVgSbwXf6amiLR5r3mv39ysHxug61GK0X59kFmtXoKKpG8qHl5JEpt6a6Fw1EyVC0Zbyc+poCD875l0hhIrc9Pl3T0VvvhrcHI79j5VHXwMnNwkotEkI/RpdvXEI7Bf5nMTvbebCArXKvAQ+L17a1bfk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  2 Jul 2026 09:52:34 -0700 SJ Park <sj@kernel.org> wrote:

> On Thu, 2 Jul 2026 11:23:55 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:
> 
> > +cc all those you missed.
> 
> Thank you for doing this, Lorenzo.
> 
> > 
> > I really need to write a bot to do this, because I'm getting a little tired of
> > pointing this out :))
> 
> Good idea.  I will also consider implementing this kind of checks to to my lzy
> tool box [1] or hkml [2].

I implemented [1] the check logic on hkml.  Many things to fix and improve in
future, but seems working at least for this series.  You can use it like below:

    $ hkml patch check --check_recipients only ./0002-mm-khugepaged-add-damon-collapse-folio-range-for-external-callers.patch
    MISSING RECIPIENTS for [RESEND RFC PATCH v2 2/5] mm/khugepaged: add damon_collapse_folio_range() for external callers
    - Andrew Morton <akpm@linux-foundation.org>
    - David Hildenbrand <david@kernel.org>
    - Lorenzo Stoakes <ljs@kernel.org>
    - Zi Yan <ziy@nvidia.com>
    - Baolin Wang <baolin.wang@linux.alibaba.com>
    - "Liam R. Howlett" <liam@infradead.org>
    - Nico Pache <npache@redhat.com>
    - Ryan Roberts <ryan.roberts@arm.com>
    - Dev Jain <dev.jain@arm.com>
    - Barry Song <baohua@kernel.org>
    - Lance Yang <lance.yang@linux.dev>
    - Usama Arif <usama.arif@linux.dev>
    - linux-kernel@vger.kernel.org
    $ hkml patch check --check_recipients only ./0003-mm-damon-vaddr-implement-mthp-aware-damos-collapse-handler.patch
    MISSING RECIPIENTS for [RESEND RFC PATCH v2 3/5] mm/damon/vaddr: implement mTHP-aware DAMOS_COLLAPSE handler
    - Andrew Morton <akpm@linux-foundation.org>
    - linux-kernel@vger.kernel.org

It is also integrated with the interactive mails list [2], so that you can run
it without manually downloading the patch files.

FWIW, 'hkml patch format' automatically adds recipients based on
get_maintainer.pl, so this check is unnecessary for hkml users.  But this will
help me reviewing patches that not formatted with hkml or other similar
scripts.

hkml has a feature [3] to monitor new mails.  Extending it to run this new
check and send mails for check failures could be one of the ways to implement
the bot.  I'm not planning to do that by myself, though.  I will run the check
only for patches that look interesting to me, for now.

[1] https://github.com/sjp38/hackermail/commit/9ca6fa1f71edc7a219edeb41d4c7f91
[2] https://github.com/sjp38/hackermail/blob/master/USAGE.md#interactive-viewer
[3] https://github.com/sjp38/hackermail/blob/master/USAGE.md#monitoring-mails


Thanks,
SJ

[...]

