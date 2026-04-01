Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55B2ED3516F
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 10:11:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C1596B0005; Wed,  1 Apr 2026 06:11:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 772426B0088; Wed,  1 Apr 2026 06:11:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 661046B0089; Wed,  1 Apr 2026 06:11:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5271E6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 06:11:08 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DE2751B8A13
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:11:07 +0000 (UTC)
X-FDA: 84609568974.09.47A9290
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 19E7F100005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:11:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="p/VUuOCJ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775038266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A7vbo/+g0ov30z6CtPlqpYCpm6rLJZJNaIlgwN2weVg=;
	b=RpgiZNGTu/Xi5icILKMe0sRRBZA2o7nAHcuDNMEwBjIzmIDovw76O9B+EyN5mCiE1NX3+Q
	gX7+z2u1O6UWBG0Rslns5n1sw4WZnmujzWKp5KtnXX1pVoekJ3j0LghVYznUiOKl//w9oQ
	OZEF9iA/QGqZGzg18Xk9a20dYjt2/3M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775038266; a=rsa-sha256;
	cv=none;
	b=f2IQjEcCibQlGGqph+Po/Ub3W5BFvFqItTBv9lbCzd9iepoTHeXVq5nL3Kic3UTv6vbGwz
	xIk9W/2m5tYtyJVpiu3+1q7igpKHnGkoTVB996YOnUPXUaALoL13tzuG3lf20bA4sIwq5C
	XMGxXBWKHwAnHBndlS2RRxVadFv5ynE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="p/VUuOCJ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7221760131;
	Wed,  1 Apr 2026 10:11:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18154C4CEF7;
	Wed,  1 Apr 2026 10:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775038265;
	bh=O0VA9UWAz6njsgt0WDi/0I2nafET0lHdPlksmhEmdTg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=p/VUuOCJQh8aeB+vE+vB9mKMOgpKWTI/45lZFSeViQQ/saY7J2vnxjuQuKbXkaOrM
	 B6d9+0xhDbnrny/1LU+9H+LX59wV/ULs+IOmsFeD3bEawtE3ZBjLwuSAJZHQxPHHRI
	 kWIxlcoA3rrx92EkkwEZCA1QAg1Wiwf3QVJ2gC3XPkq9oKerSqSM7POUby4lkwsRZU
	 jAhlHnQrD14QPpUz2HUpjumgFakBs6WJQq7qYVvqhRm5OYXkTsG1739SKZL4N5OZSd
	 F8fMqwJBsdta2/H4Z7dDz5SaqzIV9+cQXslzOYNG+zsD+a2JDVWU/NKz/Wmcl7q1Hs
	 BIsjHKfV1pyWA==
Message-ID: <f0599d26-eebb-4bb3-812f-beee0bce5f5a@kernel.org>
Date: Wed, 1 Apr 2026 12:10:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate: fix stale partially_mapped arg to
 deferred_split_folio()
To: Deepanshu Kartikey <kartikey406@gmail.com>, akpm@linux-foundation.org,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com
Cc: usama.arif@linux.dev, richard.weiyang@gmail.com, sj@kernel.org,
 hannes@cmpxchg.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com,
 Lance Yang <lance.yang@linux.dev>
References: <20260401084116.22219-1-kartikey406@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260401084116.22219-1-kartikey406@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 19E7F100005
X-Stat-Signature: 8nscpph89gg3mfyeoawgbcxztpbaqigp
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775038265-84595
X-HE-Meta: U2FsdGVkX1/3OwKLFj9zxjXf1qk5hW9fjYXN1TYHTy1UzTuXvzUKvHpE9IlpVch2DZwJV7nN1GHi2zP4iicP3hyJygfT3nIV+ieZbOUTI8u6yCM3XcIW3eVVgABeKBUfud5mxrMU6R1E4IgLKVHP9nwchDI8nH5+XoCh22OQINchaRyZyLvW0gA6tpoR3m8VO8R/ffoLBemXGd1btdJYIuywzIMox3T7SLr2l/NMRoRQMVlrC2ULv/C+CNt4yWwNJiMK3LQSDyZ1aNl4JO8Q7jnkEdK4ogqMpt9kylt3/Fiqrk7Mbx8grGCdOG8GsQIxHsQ11fqfBwyrCE5laHJiNtMPO8Q5njx497ipwUHJkT8uiqfriWNjVMfuL736IoGOp7cb2dNMKuC3KjsmaNE8HQVmfarDByvjbBRXul08Vs+qXTZiA7NfQB8EaFsrR5kdD7FKjnG/U/l8PQdI3uljcRMOWBoiecLyuz7HmdJ9WT/bP2xalaFQ6MzuRq7V0x4OFdLHbtVNBijmYBwp3nDXP4iJcGd/A4+4ZxADkHewaacLTXEm0nAmvFderHSMOzGmnHvEvr2rc/7/uBl+pS2GhnSzTAOEFL9n3Njpymz/ijROs+KpYQtlbXhjGeigtXcJv8W/gFt9lfjAbJcYcIF1RoXsnd1IcjcfwntcXkLU3co+IengxW6dY9hTnyBdkCInXUO2lGOm+0XzHkywaww/ict2+xFWSzVrAj1owzlfnxYKpeVXW4p5LjaIQF4kEcW1XHYVWNjVpmM6Z65GSBvJPiVJSe62haMNo6i4DnXdj9ENq3swjOBBz3LoJymcjm5CfveObbVCdddDPbBExNdlR2JcjjpImMxubfL7A6rmAnxBunjY2M0sdbET7TKRe9+vmp4aIXxyK3tg1UvE1XP8hRzmx8aN8Pt/MmQCiQA4zOqqpZqGbfAxFt6Hie2CTQLYLAiE6uZaRb+xaTpT3bS
 opyxto5B
 eYmsGopPokVIgeqtUODb+bIhXBnMqLiEJoh0simvJGVeedHbt8DVUAmNkXVnH7C4/Dn3yPlnbkOI2eODeQ6H0zDbw/EGhADqAd6TLXlj8yt813xTeKULEtQtBirG5XXJ+nZBv033IVhkXw75Xng2ME3UtqohOo1Q9ILa8UdJXaWlkjxM9OuI/qqdtJFCZ54WKNAljhdfjwWG06fx/JZ33tmCg9kcu9c/0g1CnkukDhrAmroxDVNi0KmqBSieqmL9FhUCNtIL2DgRQVuCqiFes8zkHK3NIT0BXyPjQF71nt1RNKkz/zRy9qMwsf4vuAbd3xKmGj6hZnUKVuVBDHrpAUAs1wAvR0NZ6CWTsX4ZDzZOxTLUqDaTTrt4D8c1CcjX6H+/GY8LzkvpsSTa8hz2/ULUH3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/1/26 10:41, Deepanshu Kartikey wrote:
> In migrate_folio_move(), src_partially_mapped is sampled from the source
> folio before move_to_new_folio() is called:
> 
>   if (folio_order(src) > 1 &&
>       !data_race(list_empty(&src->_deferred_list))) {
>           src_deferred_split = true;
>           src_partially_mapped = folio_test_partially_mapped(src);
>   }
> 
> A concurrent thread can unmap pages from the source folio between this
> read and the actual migration, making the sampled value stale.

Trying to make sense of this.

In migrate_folio_move() don't we have the folio completely unmapped
because there are only migration entries referencing the folio?

See migrate_folio_unmap(), where we check !folio_mapped().

Why should we suddenly have mapped folio here? Something is off.

Unmapping a migration entry will not involve rmap code and not mess with
the partially-mapped flag.

-- 
Cheers,

David

