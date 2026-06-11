Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20DA8CD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 17:13:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50A416B0088; Thu, 11 Jun 2026 13:13:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BADC6B008C; Thu, 11 Jun 2026 13:13:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D0D06B0093; Thu, 11 Jun 2026 13:13:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2DCF36B0088
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:13:35 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6BB59C2901
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:13:33 +0000 (UTC)
X-FDA: 84868278306.22.9A10B55
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id AD6BD140010
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:13:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HA0uKigk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781198011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nwdxz81celIWV0g+LXaRXXBHu4C0uL5MSLZDhZvdBVM=;
	b=n17n7mbBKO4WQh+n7FjmyIbI/zAkVAjD5MwBztqwOqqIUz/sOdYHoIeWrRqhWW5NCkhjlq
	uKzuPfeyTKRuv8LaavT7WFX8SzrpUv+RSygXWUe5zgx+Un19HeaeT8GNfHt8PfrFReJgJP
	GY/aFLzIqu0ZPu4AexU6PMt3N/yVRWQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HA0uKigk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781198011;
	b=Obm0d932xp9Fd91lrPx4379/tyFIuHiUaWtEA/uK3H2jT9X5RG+qRwg0xm5FCDTQycSbuY
	BYAqmTKMFNEz3vdhU5a6uTdt5IcwQd1WrTXxrejmYrUxiwar706G0QYoVyPyPaUI86UetS
	6TtCKToMROJmLyC3FIDQtrdLbsrnv7I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0813B600AA;
	Thu, 11 Jun 2026 17:13:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B3911F00893;
	Thu, 11 Jun 2026 17:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781198010;
	bh=Nwdxz81celIWV0g+LXaRXXBHu4C0uL5MSLZDhZvdBVM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HA0uKigkLOcHQ7YitAFpJn66wcFJnpHFUImT72I4hnXNmC4KiZBB1vewKMkG95gXS
	 lPQR6Rssw1umWs+neqkAgV0wH1nUqJg1kcMlqZtri6FkG5MtaCZQ8PovwbvjYc72H0
	 W5J3X7zmWRiWxMn1+HofALnPaNvjcPxWbXuNU22seGqiEVyZ08Q1THfyHuhEYm+HEM
	 rgHs7LjibR0HTqzCW/og0M3tHy6E6QgJ3vFeGPRfkSOlIvkPHO2qHUWoEnYQHCo717
	 UGJXXqkieucbGxxeKWE24x4PnAycgrZFCHTAOHCy3D9kasbcULPPt18DyT3sUAr07L
	 h7jOmhptUvAwg==
Message-ID: <8c5d67d1-e4b0-4cb2-9336-875f4f2ca96b@kernel.org>
Date: Thu, 11 Jun 2026 19:13:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/5] mm/slub: preserve previous object lifetime
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>, Pengpeng Hou <pengpeng@iscas.ac.cn>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 liam@infradead.org, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260611063926.38111-1-pengpeng@iscas.ac.cn>
 <2b5577b0-d81a-4dee-b4e2-acadcf7f7db2@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <2b5577b0-d81a-4dee-b4e2-acadcf7f7db2@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: gnxc14hu64bbng64tcjbjdiioaj5wj8z
X-Rspamd-Queue-Id: AD6BD140010
X-HE-Tag: 1781198011-895647
X-HE-Meta: U2FsdGVkX18fhTSU+VL7LdJh8apKScsSQUslNM0xMXFGz8+LDrS6w/cN5yFDBWmK2xL1ZdsUgX+MfvvBQzuSlTSe8f3f+kaeulWPTV/jwSARDqwrb+NX6wZ+9MBmLuF7dTma1/+4Wrf0Vb++MMzcLP5YvURxwsmcsNJGk+mwGJsfV/dIZR63oSxMZWCmOCIxMMDfRXr2x4IzGLORD9UupxW5LbWY73IzvMbYVKK1zMI4AOlJjIpvOSs1yMldJuWXBIZHoz/+fy5OWoiCBift8tVCnveF1n85r9b0m4fwb1B/lr0n53i2qUJtVYxT+y+f7ugR9vq1128BeyQ1dODuwQ3Hz45MdD9+DBgpQ/9mLKogGide2Fb+FSe6Rvj87XrUAA7tl4usZGKA77ebhqAMDCDTFO+xlxQt1HrtZvQtJlLVk9/LismfS2cLmUL6UzBTQdk6H6FnDsgb4cThIKYcMLkLJYtfCIrflOzNxCpr/6FU4eo+homTZnzxRc6xYCJFT7CoWxM6RU5xRT20iTLH11I6UanCisWQalsYPVN5NjJnnpQpK6Z0kdfZz4iDhb1ZzK0IB3Orur06WvTwSWrSlbieIeIQOv6HcxzeNbC4TDxBGtLhSoPhlbMGyocsQSvAB53+3UgTLlvKfOZOyfaPfU9Xle6RHakSmIW+K+rFCKBeLpcbhbigR2oaCtSDz/FpnrpsCNtyNUTjUsyZ5ivSUMtkbFZLOK7iYaZwumHREeVuLscEV4b2OnvHs7xKMT4YXqeoy/S9eVug94TsG0w9IF6DrcbbSLR8nILnbWw04kcwJxMdEb4JymvmoV/FGzzMyAjqCHNrkdYlSp03mPnmO/fKvtiVHXYgIxi9gKuRVULhogQP25SavOOHpkmNg6hzhs20FNyv1jijIn8uo7KqGRMWpE/63xnJT/jj/yE/HGvUAdhv8VqmvzBABnH685a7vNA7NKn/kubwuyDyGqH
 ZNzdvC9Z
 VpSgsxWFMjv+Ar5Uxi5IbzngLFqS0IJI/z7ODXwy9JN/qM2ZHep2mAxKVSyeC8xzK6f/ZaJrwA3kubJ2Q16xtE2dh7JMi0ASHXtwGizbrJcZ3N1WUDGcFLnd+zabqxaYCmguVKnDso9Yr+LN6IBMmugCcL7YLr2qKosVPzT9wXi/JUDcMUY/bTcKeobuIIt7ajXJ4169iP/hMQemVtdqyuXCIgPIleoA0WigsNiLNVVWFJGRDrwgydLhJBri1MCv35zgr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/11/26 09:19, Harry Yoo wrote:
> Hi Pengpeng,
> 
> On 6/11/26 3:39 PM, Pengpeng Hou wrote:
>> SLAB_STORE_USER currently stores one allocation track and one free track
>> for an object. This is useful, but it loses part of the previous lifetime
>> when the object is reused: the new allocation overwrites the allocation
>> track, and a later stale free can overwrite the free track.
> 
> I'm not sure what you meant by "stale free", UAF is accessing object
> that are freed. What makes the free "stale"?

I'm guessing it means 'second/duplicated free" of the previous owner.
Accesses (UAF) perhaps may not happen by that owner, or if they happen after
he object is reallocated, they are not recognized as such.

> In general, I don't think slab_debug=UP is the right tool to debug
> use-after-frees, because slab will never know _when_ the object was
> overwritten. It can only tell that somebody has overwritten freed
> objects by checking if the object content is POISON_FREE or POISON_END.

It could give more information about double frees like this, however.

> KASAN is a better tool to debug use-after-frees, because it can
> tell you which kernel code is accessing memory it shouldn't. (It also
> quarantines slab objects to avoid immediately reusing the object for
> better coverage).
> 
> So I have to ask, "Why not use KASAN instead?" before enhancing
> slab_debug (neither is intended for production anyway).

From my distro experience, it's very useful to tell a user to just enable
slub_debug for a specific cache with the existing kernel, with some but not
prohibitive overhead. And with some luck it gives you enough information to
find the root cause too. So in that sense it can be used in production.
KASAN is indeed superior wrt catching issues, but almost never applicable in
such environment. It would need a rebuilt kernel and the overhead is much
higher. So it's a tradeoff.

>> For free-after-reuse bugs, the report can therefore contain the victim
>> allocation and the stale free, while the earlier alloc/free pair that
>> explains where the stale pointer came from is no longer available.
> 
> Again, I'm confused. I have no idea what "free-after-reuse" means.
> Objects cannot be reused until they are not freed, no?





