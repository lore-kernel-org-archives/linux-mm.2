Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0B31FA1FCB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 15:59:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB6BB6B008C; Wed, 22 Apr 2026 11:59:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E67C26B0092; Wed, 22 Apr 2026 11:59:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D55826B0093; Wed, 22 Apr 2026 11:59:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C0A8E6B008C
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 11:59:39 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 64434140258
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 15:59:39 +0000 (UTC)
X-FDA: 84686652078.16.195A09E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id AB0061C0012
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 15:59:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KapIo0YA;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776873577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dA9bOr9QsLhla7qIjNcy9rU/TvxJFlpDOgf0oHJoSg8=;
	b=7hZmXJLTv5UAZZ0dgzzmO9Ioaq+3r0X5INcflMgMcHTwvIhP6aHUDnoKRUn1I6POY3tqAm
	AOH6l8zv2QC/GVGszAYwEvFY39ehbkSG1L86x4FZVSbkdun89gr0SddKqON3QJwmUdMnDR
	rVisU5oq0yZ+5E1W+QTFygQf08xt3LE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KapIo0YA;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776873577; a=rsa-sha256;
	cv=none;
	b=BJkcTlaA4Yx//0bl50054soNMYL+RoJmnCpcyYa+XczlVfMm89uWizjytg/Gc0rh5U6adz
	T/8J2Ivj5spsP01RiUtVQQ2PgmAYZOI2qF+DmQyjV2fpmQ3WSE4EsXgyDWEct/WEXHwW+a
	C4bwRkWS+7Iag0w+LbqImhkJtbgU6iE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C5A4A60008;
	Wed, 22 Apr 2026 15:59:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D33EC19425;
	Wed, 22 Apr 2026 15:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776873576;
	bh=OpFRKXrxgQlrZERfkfExOUVodahlrbJOmwNQU1isD94=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=KapIo0YAcAMpnp2MKCde9yoK3xnYdqKi3lVt2oIAIt8JtUqshiYKIsYQFQypD7BQc
	 2vogDF8mwvrdFUmzck9o6c5uynUdw3gVSN1iX9aTcOkWxI0JUenwlFbM2d8oU8TMru
	 vqYfk8YMDliC380Jm/uA2LEhpSe7F+aBaRMbBcUGKj2VyA10LUEb08k+P5gRaEnMV/
	 YDepZuQJJZYX5I9WRcfaoM1ZeBSjgsUYEmeev/BnBD1sdQb8rahx2vhgveeITBio3l
	 RTW20Tq/3lim2Z3uruxmgZtIr/DiyDl3CReQlSaTvLG9fMP70q0J/vPtHg/b4tWZZA
	 AAfboUjW5zH9w==
Message-ID: <5903bf12-82fd-454b-925a-819e43c5cd28@kernel.org>
Date: Wed, 22 Apr 2026 17:59:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] vmalloc: add __GFP_SKIP_KASAN support
To: Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Muhammad Usama Anjum <usama.anjum@arm.com>, Arnd Bergmann <arnd@arndb.de>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Andrey Konovalov <andreyknvl@gmail.com>,
 Marco Elver <elver@google.com>, Vincenzo Frascino
 <vincenzo.frascino@arm.com>, Peter Collingbourne <pcc@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 david.hildenbrand@arm.com
References: <20260324132631.482520-1-usama.anjum@arm.com>
 <20260324132631.482520-2-usama.anjum@arm.com>
 <727df89e-2069-4a7d-b3c0-88f89cd3dcf8@arm.com>
 <e772bbfc-1f77-478e-b378-7947ca7a8b3f@arm.com>
 <25c78859-f514-47ac-a3b9-7dcde101f72d@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <25c78859-f514-47ac-a3b9-7dcde101f72d@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AB0061C0012
X-Stat-Signature: pohcbo7mgjw6guaqeoiz1djwybskgtcm
X-Rspam-User: 
X-HE-Tag: 1776873577-42241
X-HE-Meta: U2FsdGVkX18auwCdUKZgNa57H1aODjYqJWgrpypQGy31moSMCs/ygWEtNf2thhkw6U0tmqDZI2MAFes/6+Gim602B5F0mwmumrpjF6sHQzxgG9A2q2VZilOu3BJMPhaBvBlTginaxSJLff3GLjfBaqYWy30eZlKAgSgqrNTJlLu2X4TVjGZK1yw/WwWlKjzYdnmqi0F1ahB8evXUfrOprjZ73WUPOoOObG/A7UIcjDTKk8S/E/9LwIIq+Hwv7kcv8pGyqOqKGCLy4TIFGfdiByvZfyE/3XwBP1nKBjGecHMHi9xx18GmCFOo1bvor0XoNygFwQxn1A57K/8d8RGPFe0xUhO6d09CpezOaE8Gi8H4/XBRRIrSO+YW35OvWpgs1rrnrnFcag9O6BkFdTfAMZb5WJ1R6A0vVIGuqGYW/h9k1ICgzjo0jHYPqStovl6ltcKAjCge35cMRAvb9P+3/hcGf7OcQu4k62rYOP5y8xeBbF0Y2jooScOaV+xYZgdbc5pfS9EIDE4wArqwJbGpqhcKDcBicG552zQzhMZ6mAfp/+3n0l1p38bacGTH79Vl7aZ6g1X92bR0rnOXcHTnUpBbo1QqdefNYGwS00quN6zQQegwv1qLD/UqhBG41CfXxyvKo6AhxbKHetqAEzzcL7ibAAzl0Co7WRm7/vebe9yRnpg2FqravBd4j8Yggb6Z6N/4qkV/cZ9WVmOIw0vyj2gkVIiQSLgav2yxOZqCMZqV9NqUlv8vs/jp7mONKCbAeR+Kui2knJ6re5Wyg6lI7Ert13WZnkD+rs4fZH+hb0WzUwN2XPcrieswg41bShjJxnst1JREx0lhoHN6WCBPxm7jc8SYqsUUgr7pvhQGeoMyKWwfYNrWjCQGPt1WzjLyBOpkSeRayhUFAPxeVNRAciRUUR5yJL5RWkBNJgskJCmMhCAVgKU28+ynGU+HXxkX2gj7NZpUW5nwsDH4uNO
 OfI2wrKj
 ZNJqrydifeil2kRE9ZGNHCAAUUJsA2nr6oZVXpX/vspbHxVXUXtJ+78wr8Kvwd6LYaBiNRcT0YyljXxRLkfsWWBZptEBLFJm9GZHxsCRq2ALfgnBcIedVw/xTYMeD8FKrBMlmjoEZRg/cVYrzbMNwTAnrsenm5f/wM9QMPRO9KHNyLoLFvwIaDJurpkwd00jCy9HwGM/wD/41MszRSlesh+hqqMWf2WL9vhLXkuUyMXe4HZt+5gZujdCeeLCUegyoQYUrMFEsk1pQYP05N7ojcmF5H4953aiL1bg5VnLas+ycvU4g8ZgPFunL6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> I think we are doing patch 1 because of patch 2 - so in patch 2, perhaps
>> instead of calling __vmalloc_node we can call __vmalloc_node_range_noprof and
>> shift this "skip vmalloc unpoisoning" functionality into vmalloc flags instead?
> 
> This is exactly how Usama was doing it in v1. I suggested we should just reuse
> the existing flag since it already provides the semantic we want and is less
> confusing than introducing a new flag.
> 
> I know David is keen to do a wider rework and remove/rename/change the semantics
> of __GFP_SKIP_KASAN, but I'm hoping that if we just continue to use the existing
> flag and its semantics for vmalloc then there is no reason why this series can't
> be merged independently of that wider rework.

Independent of how the flag will be called, I think it will have the same
semantics. How we'll implement that internally is a different question.

So I agree that adding __GFP_SKIP_KASAN support here is the right approach for
the time being.

-- 
Cheers,

David

