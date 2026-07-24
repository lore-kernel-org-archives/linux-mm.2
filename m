Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBC5CC531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 19:42:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 852656B007B; Fri, 24 Jul 2026 15:42:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8020A6B0088; Fri, 24 Jul 2026 15:42:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A42E6B0092; Fri, 24 Jul 2026 15:42:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 353196B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:42:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9A3DBA0068
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 19:42:42 +0000 (UTC)
X-FDA: 85024692564.23.5B844B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id E56211C0004
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 19:42:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dI+f8BpC;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784922160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ywogaAvqUOwOsRavyteEUkzy0Yuz2a9mp4IXHL5P4kg=;
	b=h3MVtj7tA3JPSfIj710BmGjqPcC3L+QahvS5raIWZgN5+DHnYnE825jqPYVwt2SyN7y+6Y
	x2kDYYyhLAYuz2SrSfff4KLnef+U00E8TyE8asCb51Qs7jDO87d5M2VhaBW1qYf0NsHjXc
	apWcBpnl/B2PC0a2AcgoRo+35MS1PTw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dI+f8BpC;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784922160;
	b=qVkLleZ6D2k4I3vLZS5JFelYxMSfSWO17RUyM/q4bJkIIHAUB8hnOBn5qZTqMYotg6Lz5j
	GdZIw50gMm8taz5o8SSoPjb2VsdgUP42OrTffqQiJNUWH00V9u/z84kSNP9M2iBueG/PgS
	yurl6Bu9+aLLmjDKcwF/Cv/yMQb3Chs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 59FF9600AD;
	Fri, 24 Jul 2026 19:42:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C0AF1F000E9;
	Fri, 24 Jul 2026 19:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784922160;
	bh=ywogaAvqUOwOsRavyteEUkzy0Yuz2a9mp4IXHL5P4kg=;
	h=Date:Subject:To:References:From:Cc:In-Reply-To;
	b=dI+f8BpCXUON/exIOkB9yvFU4FKlYurmajCOqTUYbfh4896aNeQTQkic0cQk00eZF
	 kTFocjW/vPTSyldOkBKPbeDThOwom+vJGYWn1x4nibbKmdo2rqZgUZ3ZcsrQQYtIo2
	 oHjnxd37BsiScCVs8YngdY2FHKK88R8J5htojhjqvnQw2zyKvzla5Mgrdxvoq2/B2L
	 veAwB1GTDbSnmbniTTIX1E8UUtK7/aw3AFKZD9Ad3pk4IUZfszIzyxk7yineB+I63a
	 mMvoDHB+bBWzkXphvbTvYl1ymTrd0lM8T0ewUT4iYQiFpmLryKOKyfbvj6z2Mcjvi3
	 kTF+JZ+HUhGJg==
Message-ID: <73ccbdf2-7145-4dcf-bb73-44fc23fbb325@kernel.org>
Date: Fri, 24 Jul 2026 21:42:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mm.git review status at 7.2-rc4
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
References: <20260721225139.fd654a3a40e755d3e621899d@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260721225139.fd654a3a40e755d3e621899d@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E56211C0004
X-Rspamd-Server: rspam01
X-Stat-Signature: sa9iweqpmu3cx4wnodjcc1gmek86nwi8
X-HE-Tag: 1784922160-452669
X-HE-Meta: U2FsdGVkX1/K8Co/oOLdMqAjoPf5iaz4zrcKuFbqtHodMhiXGaBLMW9d+KAgZjQuZ/CUE8VlypaGkNnhQ4GpHLcnKoTTK496FaTPaKRNUM6sCgV2z6VyMpuBPllObxL9e16KR02WPXyoy4I44eSXV3xsW0rxgB2QFdiTwraDQmR0kxqdl5kixCwv4PygsnvNoog8eenOjl+XoWn0x9oHetMjpfxOCe5FliXOIwA1iZTQ1WGNSTK0m/gqVEm4cBPd4qohZUqVnC7dRaI6viwb/gsxhxXZejvwP4t+yJN235CCBtgdTX8KyWPqswiVFrKARdZqCe0GJyHH/aMtE+lb8113P5BQhQKb35goaRBhmaCgA2BeDT+dDRca3npY3wDFBJxfY1ZKNlZzH98qWzqeTnMmY+dv+SMje2WgWlafHCkXZrF6M5bPzQSdIbqCGuUQnezrXn6R1sM8cOEGYAPuhO+ckcUWEM0A8qn0cg8rd7qkhf9qHuLoW6VNKv+I5Z4zwonfiOJBt93SlT8POW+7TG66QVJwMwLGW9W3Z0LyISMRkzsiy0rRgOnlWM1eA7DZWltT4eNXu8ac/1p/7tMRP4eYcRlLvnBwVBHFRIC4IX4YLaaNrSYq9j0dc2FISjNxqgoAzsGyZnb4eZGbcJpMoqK0ndaW00BQNKAZmtP5QfBtWDtkawU1KoVazx5x+okG8F/+a5+k/t/PpsYzUudaSojY8YexX5PWpmhF3PB71aS4q8Q+9x9Nty2KWmIVheW8+dNjas9G47vaipgcsfgRVv2JYc3r9oiOTQs2p7grHy1ezT9CnfTk2Lf7xXoBUPeIV3wQvgcm75myNKBiZQgORWcMTRQ+9Mgx9jtPsqNFz3rVr4wo8pt1pgmkU4bB8imOTxGB7wCpb+GFgoVsuAFpQ2vs8IAb2ldwPMfRJqOVWCjvmyJX8fUEUy/Ii1EVKsemJUYwmPmR57qp+SyDRKt
 xzaUSgF9
 YTqpv18Yc8GCEgmAU12j3HmPGOvMjJDMJ3Anj1l5crp5PbEHkW5PXwoNh5KLjHMMoTV+I62ZsMEjav4z6hyud7fqQKXGken2ioosYnVbe8b0wwKlaZ2UjfWqITjZIvAekvLlimrdG0eFNPMzsZ52zUSXrSX99924jR5kwDz5muNwQ8V2P5zUVSNe2XI0OhM8oCmz9uF3sQ5HBYwssXsz6f6nXsct7F6sEx3Ye8Z7H5hOFRrGcn2ycgnd6OEBGcLwWAz/M+0GPnl26pTdbG5A3ZnHrS6dTsN2QjztWvV464Pi87SpeOB/OioR3FaDmE6/vvsPjbsGDCs+G+AvcvkJIEXWT+1WdGC7TLOP49kdww/crrZA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi!

> 
> Unreviewed patches by author:

[...]

> Barry Song (Xiaomi) <baohua@kernel.org> (1 total)
>     "mm: rename in_lru_cache to maybe_in_lru_cache"
>         Link: https://lore.kernel.org/20260708145718.82690-1-baohua@kernel.org

That should just be squashed into the respective patch:

[PATCH v3 1/4] mm: avoid unnecessary lru drain for wp_can_reuse_anon_folio()

The curse of fixup patches.

> 
> Yunhui Cui <cuiyunhui@bytedance.com> (1 total)
>     "mm/gup_test: fix race with PIN_LONGTERM_TEST ioctls"
>         Link: https://lore.kernel.org/20260608025043.88087-1-cuiyunhui@bytedance.com

I proposed an alternative. No reply. So please drop that. We can use my alternative.

I assume submitters get lazy once they see that you picked up stuff.

> 
> David Hildenbrand (Arm) <david@kernel.org> (1 total)
>     "mm: standardize printing for pgtable entries"
>         Link: https://lore.kernel.org/20260709044334.1741263-1-anshuman.khandual@arm.com

There are still discussions going on, Anshumann will be look into Willy's
suggestion?

> 
> Dev Jain <dev.jain@arm.com> (1 total)
>     "mm/rmap: refactor anon folio unmap in try_to_unmap_one"
>         Link: https://lore.kernel.org/20260713050050.1017741-5-dev.jain@arm.com
> 

Acked most, will review the remaining parts.

[...]

[...]

> 
> Sarthak Sharma <sarthak.sharma@arm.com> (1 total)
>     "selftests/mm: transhuge-stress: check duration inside page loop"
>         Link: https://lore.kernel.org/20260720103105.169955-1-sarthak.sharma@arm.com

Provided feedback, needs rework.


-- 
Cheers,

David

