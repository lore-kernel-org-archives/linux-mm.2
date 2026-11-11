Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF9BC606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 10:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QEjJdJXj
Received: by kanga.kvack.org (Postfix)
	id DF5766B05B3; Wed, 11 Nov 2026 05:30:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA5B06B05B4; Wed, 11 Nov 2026 05:30:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C94726B05B8; Wed, 11 Nov 2026 05:30:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA3596B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 05:30:16 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 922A71C27B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:30:15 +0000 (UTC)
X-FDA: 85422468390.08.94125D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id C424A10000B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:30:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QEjJdJXj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794393013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jOiHR4ad68Npg1NXZSugMmWFxLEASeXZ1K6QbTQKCRw=;
	b=toDMk67eyj/NJZ9nPHaIbEOluhM39kYrWwIxlzNaCDfaxanDbRroeZCvSq0CJXgY8sPO5q
	uWrUtS/Xo+E3QB+9czJzvZQs8NLYTm6PYvyBNYW0zXpMSVgC297PPFhURBnTdtz+WBJZ5W
	sERazkXPqEm0gAtxsxRhtjXO/WF+cYA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QEjJdJXj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794393013;
	b=SaTatgnIkD84oJNqSD5AgOlgks60OldCY8bnseeusUQsSj/rOuacYYZViJTABRQELjWDGo
	i7La4s+Gk6Xze8VYqjN6VJrm+qqXU4ZmKGlrHR1qBDPdPjYAJ7rfG5eez3dl4jBuxsfrOu
	7aUdRvMyLnNlMQntCNXMHohxnPay5Ag=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F0EA2448D8;
	Wed, 11 Nov 2026 10:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75F91F00A06;
	Wed, 11 Nov 2026 10:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794393012;
	bh=jOiHR4ad68Npg1NXZSugMmWFxLEASeXZ1K6QbTQKCRw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QEjJdJXjxc7Lur7NIFKjf55sh5sYArssTP8Vhpn9QBhF5GOPrlZ6OebMEWuma6wKx
	 4vRXOpyYd5xdTJDEXZiVyTiVlmF5QADj9BSFmKHsUpjIOBcvmCMi3zXT2HmJ6QCoIo
	 ZsvGLonn4K7ZQw+EeXWsiqS37DCeoSK8DQc0UU04k9ydoLmmARyrKNHTbVOOrfnFHW
	 X/U6wJmqd97vSowvOi9ZTLvX4SVmsb26JUNLNZQuN4WyNYQuQpm+6GGaVC+5SILhsE
	 7QEdy/Zdigj7BsBE1nC4KLIPM6L0Cg0zCO2HPnDbOtLZLAL82KzlKDgsYxXt6otr3h
	 B9uJ9/xc9f0TQ==
Message-ID: <ec39ce6d-e604-48ab-9582-04ff73d13c16@kernel.org>
Date: Wed, 11 Nov 2026 11:30:09 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 3/8] mm, slab: rework KMALLOC_RECLAIM handling of
 SLUB_TINY
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>,
 Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261024-slub_tiny_rework-v2-0-bf1419ab5ffd@kernel.org>
 <20261024-slub_tiny_rework-v2-3-bf1419ab5ffd@kernel.org>
 <auHcj2G78VkXy-Vz@fedora> <auycUvCC2mL_EQ1r@thinkstation>
 <avE01iTQccxQnhl6@fedora>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <avE01iTQccxQnhl6@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C424A10000B
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: t547a3nsifioj9x69kwkaz96cx5pmnow
X-HE-Tag: 1794393013-187930
X-HE-Meta: U2FsdGVkX18+PqHSrwdlwYGDl74Mk3dq3l1Ckq+NYSlvXJ7MviqXOqFagpqs9WKVnqx5jMXcqgcFnGXqvjL687TDgRtVyUVwdpDC0CddlNl6vRtHK22YSavpUTHRKx6YvscSy+ObODii4vwaw1GGn2nvklx4/xIKfUgSy5OFyJQSwufRAHKixqfg6+nfVge4vZif2UuPn457ASm8W6WkrxWgAHkHDCLdVLxASzyZeyxEHi/FSXvkFrH//4jkXy0adUjANS9EqNamAQw9qJYC3S+J3J0ZYm+Ncu7Sz0llUxNlLIQWgi8PT/qZ5XfzFTEcVFzbAgX+g0CtIy48N3iHSJ864FPRQLnz+Fj6EaHWpBKjg11OdN9KbJsoqzI7+JaK13Fmk1COdYX+P84zA7+3pizzKZypre9MY6FTtsz4+aGbUhQmT/uwE+mt/6GKP25dsVKzI/lJYvjj1fKPSMbL2Zd/muqaA/7gA2eRIhu1qsZ2h8OxzJNdS/SGckCSle4MVXBb07ymu80KXV3lrxACy/xneVSMHq39Krj6uGA7FDdGJ2jr/ZklWk/3v9inhNIDcjMBQrEjMqJnmpgr+P8UqV4GuMSYF9hTIpbOueB5FM3o2ujxinV9StNT6LmJYLNFi8U6bEpC+vm1VkK2bEs4UkiZrs7cCOAx2O5OkLWtsxwG5W8COF+d4usT0trIkJIHXJnre/05pm6FpcSFZGSOSkscwW4fflAr8MTQyXXHtt1j+h2+r4hw512EPX0y3IiehuS6gCFSJem4hx1EhMikJh+mcARHrMUZp9sbRmhTg1T4Hg/IFCvMKhW9zozjzFbBt1sO3/3TL3/g3Re0Tha2qCY2+hgRzdqJWpITtMTT9oDlxKCo5uf9Ql9YPayo6hkeUPSlALW54E6Wuygyz7MXUJePasG1Z6CuJbiONMChUEVKdZ5lwlFb9kvd63lkit6eRpT5egGsQ7Y4vAB3tR8
 cX9BSqXj
 Gh0royN+l/pdF2pRLaDGkCdzYwN5f7qvQmjop6Kx+2pKmcfctpAl1IBXh2HCV828eneGHWfQcuPUQEiXuaA7JGexem1TcMeyeUkCi8E8AmxnLjIGb7KNLSqmmjYMkPZLtRVERvCalztYsUy5AEF2umaXRGQV8A0Hgqo9eKkhPdWZlK1N1zK5fHBW8ZVl55v2yR532WSGnOyAIbMqBMQw6AOOzDdg6DEn59kW2Whx4g7kyTiywTZpW6iLIOn0CDegBg4p9vfS13OAWK1dtJEygwFmyR37eprHvGRjRunT16z7lUsYQc+L1oRmiDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/9/26 04:01, Hao Li wrote:
> On Thu, Nov 05, 2026 at 03:19:01PM +0000, Harry Yoo wrote:
>> 
>> > Given that, would it make sense to
>> > change this line to something like:
>> > 
>> > if (type >= KMALLOC_PARTITION_START && type <= KMALLOC_PARTITION_END &&
>> > 	!slab_tiny_enabled)
>> 
>> Maybe you could send a patch as it's a separate issue from the patchset?
> 
> Sure thing! I'll post it once vbabka's slab_tiny series lands.

It would be better if the fix preceded the series actually.

