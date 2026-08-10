Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 880ADC5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 11:38:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DCE76B007B; Mon, 10 Aug 2026 07:38:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58E236B008A; Mon, 10 Aug 2026 07:38:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47C656B0096; Mon, 10 Aug 2026 07:38:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F7156B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 07:38:33 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9666340114
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:38:32 +0000 (UTC)
X-FDA: 85085162064.24.F563A49
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id D567D40009
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:38:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="aq/rhErB";
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786361910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rVWAlPvkpJvvGkqiZLM7fFRVg0it8TP33N0HujwY3G4=;
	b=xiWLtc4mOIyLD+75T6eE+n4X5UOTthvtb9kt03318m1jg9fKD8omYzcnCjkRSQMXh001sY
	DgBz31gdoXbOjX33leQccb2ThYh1lX9ErRiicc49BjvImw0t8lH0leFRdccUz2zf1QShlu
	9pJsCux8sce/caOoVrmXVpYbkgOELl4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="aq/rhErB";
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786361910;
	b=rusGrNzEI6+zYK8XGsDJBFR441FhqoP0+VejgMpm0hTMJtS5SagHR8E6W2Ml3Q9zaN6Gc0
	HNLMo2vXjEQdbKs9XCQWGV2MvRX3Dp1707MiYtki9NyGV2zE/FHaS5BgPpo/Y1R5w9p3FA
	r8NKG1RLguznns+Ep6s7POgHg1y9ujI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 69875601DE;
	Mon, 10 Aug 2026 11:38:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1BE51F000E9;
	Mon, 10 Aug 2026 11:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786361910;
	bh=rVWAlPvkpJvvGkqiZLM7fFRVg0it8TP33N0HujwY3G4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aq/rhErB0ykBNP3zfwjx1GOjimAKlC5C1JF1g2G9uSp6H71N8yvt8A6GkDDmG/dXG
	 tU/4IFBL1Pbh/sJG3SoRu0Wv4XqYZz+ewDaHzx9wgRpOavNsJDGtXI/9Dwdayt/aNL
	 1S9Xb+BmEIFQfxaxOKTrR4nDDiHoQRMsjdZhb7xYJrO9AUGqkayXq8q05fHMpd92Ap
	 XocLG5h9GcvwUXx7JhsjAn7jzA5JlYLqI5VDDvJn02rtBVOfgyJNWqD/Gf/J/lVbBE
	 /FjJIYfKhB+az5uyoa9uDi1vB0Q+u9vneBIy92LupOT3OwzZZdRr14j7NFUHhET3l/
	 VGRCWbF4AACLA==
Message-ID: <1439da90-292c-4075-82ce-32cb89505db3@kernel.org>
Date: Mon, 10 Aug 2026 13:38:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] mm: remove PageReclaim
To: Tal Zussman <tz2294@columbia.edu>, Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Christoph Hellwig <hch@lst.de>, Johannes Weiner <hannes@cmpxchg.org>,
 Yosry Ahmed <yosry@kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
 <20260806-b4-page_io-folios-v1-2-0899bac3b826@columbia.edu>
 <anYocInoXy7KRcZ8@casper.infradead.org>
 <1b688500-230a-4733-99da-bdd8adc9f67b@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <1b688500-230a-4733-99da-bdd8adc9f67b@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hz5ob4uptq6oqgdcns7rrgi8ij5pnpbs
X-Rspamd-Queue-Id: D567D40009
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786361910-177990
X-HE-Meta: U2FsdGVkX1/139/bqibpL7B1+PmlMwZqYk09IIcsFavhALzKrM9/vTmrGu+DYO++3csWJDIY/+ByJlIZw/A7T2ZbnTsZ1Rrl/BMsozF7VSD6ifbo5DXk0JQQc+e/fZCc6C6Cr8W5Vo1e3gQ30dJKVX8iM41ziF6c5OpTzQCQtvEDXytm5QsmkvXBySALE3ywnbSK1WUN2/B46q2MKtgrihLDAuHNwe0jDFjsLwFoMyu3ebyb/ImWo/qLMOtiPDtSpIk7DiCLPwjlWpKdjuNzyNbnbrNi+hVGfeFu2qP6qjepcq6Zt+Jnyw+z0fkO5/QgvywRnQrRY7yToVe07u/4wKQ7/k3471RXhTgYgcUzDxRH70uxKZe2dr0B55khmbe06S2D/NAAdhEyTGuAlIZNxVbwfztwsRkZmAJNod/Qe6IhQ+ZZ6K0aDMHMyBWENOPkm3oLLIyFmamFcFzdutQloKfAhfTTkdAqA5ltJahOtXcibFK46pRH0cAdKf/CBRAMuiuCb5QdV0mCOkgE0D2hmhXXF32TiHDW1lQeJyJkKO6xF87Udcfchl2kf/9YESLCaxUa8TNdIRXd3Fq0MLq0Ji5qJM7VlJztX/1omd6GuQemb4tv04fubyvhFAMRXFkIWvyjlmNfM9bqWRpLDl956q83UCCsWhEf8O9ACsC6I+NWU+C8VEaPVeXr+9/V/Z5TEYZwzmUBMehc0OPGvBW2sqBxiZG5gxOnzJpE2og7VrXIGWo2UrM29KkqCMvS1Qn47AFJ4tW1co1dYA5w3lNHEcM9B4sjBqwo2jLXVBQHcQpnhsqkHWAi32SoxwP9tdKoORDjFVM/WQ2sXw7iytGwwKyNL8Syhvu4H2p/AxOuu2/yVRf5B+kvKUv8gamHv+5odwfxrAiiRhrPYvbeZKgQ94YwtSzzCbXWMUikc29U51qWU0liU64y39MPgA2NQkw4kHVuMC7MYsUxmjIP+9i
 6nmALjPL
 2/b8QDXNe7neFjZAC0/lRcYbeQV+b27h1zlnfm5yvnsZoODpd3CvHigl/1c9GsjRn736p323w2QTalumSNkFnDWGyK+xUvC80FwEzEvi2mW/hpD14CB4R/yKSxVXmTESxjnwElCo+vvEwHce6Tua+F1Ni5a7olWa8ZfIVTd5Kzu1273W9Nk76B2urteY64IxbsBMcqG5TCCduS/QeOGBc0FluS+osR1wX7+ujg1ElFlD4xkdduRstXJrz+zHvQkOs17TwIe5jK7gXyvqSUJ4Ut26eOP23t5VwblUZnEC4o3KuheXZ67WpwgSExu6h9pvIMVwrogO2obiq4Vl2CK5zRmENig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/7/26 21:27, Tal Zussman wrote:
> On 8/7/26 2:48 PM, Matthew Wilcox wrote:
>> On Thu, Aug 06, 2026 at 06:55:34PM -0400, Tal Zussman wrote:
>>> This flag is now only used on folios, so we can remove all the page
>>> accessors.
>>
>> And we don't use folio_test_clear_reclaim() at all (it's mentioned in
>> a comment, but that's it), so we can drop that line entirely.
>>
> 
> Aha, I missed that - even better.
> 
>>> -PAGEFLAG(Reclaim, reclaim, PF_NO_TAIL)
>>> -	TESTCLEARFLAG(Reclaim, reclaim, PF_NO_TAIL)
>>> +FOLIO_FLAG(reclaim, FOLIO_HEAD_PAGE)
>>> +	FOLIO_TEST_CLEAR_FLAG(reclaim, FOLIO_HEAD_PAGE)
>>
>> With that last line removed,
>>
>> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Thanks

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

