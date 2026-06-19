Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF1B1CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 14:53:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D44F6B0093; Fri, 19 Jun 2026 10:53:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 784DC6B0095; Fri, 19 Jun 2026 10:53:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 601136B0096; Fri, 19 Jun 2026 10:53:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 362D46B0093
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 10:53:49 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 886F612041B
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 14:53:48 +0000 (UTC)
X-FDA: 84896956536.01.70CE8FA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id D03AF40002
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 14:53:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bbEofCKD;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781880826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VrrWV2DRPuCzvFAaTNjpF2YIzw78aeVa0n4wK4sF7ww=;
	b=JeNTgU19lsNinCG24hM6awwTQwGvOd/nVMagZWacb9ePY8uWP+a9eqHgPDMtZZLFbHqn5M
	+KvvgAwmbqoyHol5wa4SrDpDhqjUVJGnr1P+XNMkYc2PeGeBg8HhzMTPTUqThZalUjUPXS
	91Axy4ZASJfeqx3sie8ZGaeBHYTeAyY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781880826;
	b=PNkpdnQrM93Fo7d6cGBTZWGF8ak7chIEIuV4qKQVUjSXI70RCOhA0G3gbNdhv0T9PDQUKc
	3SXYPo/iDamBxuo5e6a33X6qU4PS1gvIAoTnxcnzOKQ462GckXuVB8lyMHBuT0d7yn1pk7
	beFFbuKwZ/TuaRh5szqxHuWB/TojNw8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bbEofCKD;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 67A2C601E3;
	Fri, 19 Jun 2026 14:53:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 489001F000E9;
	Fri, 19 Jun 2026 14:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781880826;
	bh=VrrWV2DRPuCzvFAaTNjpF2YIzw78aeVa0n4wK4sF7ww=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bbEofCKDBZNY/76Fd3JBNzOpEr/D2ueHYO7uT7JbwW3mXeZQWrYSvJgTCMTlRBagO
	 GNa7YW4B98+zZIwObh/mpt+hVLobxj831W/PZ5TFNBoL7qUMHybs1zw8GqFN3M5tdT
	 jaRouZP3fBqLAB4FGsq13CvrK5cCR/O12ohAa9SeSwN/6Argih2w+AekHnWnNlINji
	 xY5WRDRnJysFscSweC2biKEVIglK/LHvgQD8GQNHx6u9wujWWX29R+UcCJZm9fFBbr
	 0jOTHJLuGZfU70ZowErRFhZCt+WJsfbgPsFzcT+n6FglPW+gaNpn3r7z+1dXvlDBb/
	 yNsLKnm2KIMZQ==
Message-ID: <fbe1e70b-2a33-4db0-b390-3841c1a84522@kernel.org>
Date: Fri, 19 Jun 2026 16:53:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/page_alloc: drop flag-conversion "optimisation"
To: Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price
 <gourry@gourry.net>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260615-gfp-pessimisation-v2-1-65f1319e6818@google.com>
 <DJ9KK3Z7BPYU.2HDB5IVO6Q40@linux.dev> <DJD06ZZOC9IR.33KCFLM7L4267@linux.dev>
 <DJD0X2R79SVW.1XM7FV4REYCHS@nvidia.com>
 <DJD12YR8S99G.1I43PSHB77TA2@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <DJD12YR8S99G.1I43PSHB77TA2@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D03AF40002
X-Stat-Signature: xrqbe967kkon5swh7ck6c8cdejwfzi98
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781880826-643824
X-HE-Meta: U2FsdGVkX19MYCiMMxXMPvpCPPIIW439F5fl1RnjoFVmLx+/1R62aTy/t/0kp30PRRJolscigr79MS+blqP62SkVq5X5yEsIQlwUHCppoeklJA7nhTxJw6XwDRdTu77FiSZgyLwO42kvj0BhfKKezibfaWls9FHIw/9csUvHEGq2khMuTqjhPYq7b+BAxqC00vPv52KXwxP/Pq//7mFwpoJ7hkcYvA5mGlbUa+WquMbbIE8IcoIRWepL6+zaiKbQGnUbYcV535ChoifkTiOORCUMa6vwBj7qb+0PoVCdgUDG7JDaUBWROo5yG/SkMXpwHMqkhsm0LiGy+xxvaNYkFi1pTrAaGQX73l1dmBQ2UFz9vJMwtB6kAUt5RiVFIm666bQaCnSgt4iOew7NfKKxkhe3azf/2Fk9EZ8MBOEbubQyUBXd1sO7XgSvL06mxHEOCjEdwn3/7/839x1dQ/EL36FiPH7y0zxTa9D/s54InLAMu0HXFpUuuINPaWKHO/h3yAT5wcQbNH+w2DSctpGmEm3ANFVBLj3xDBO73Q4n5DxuWWMA6qnfrjHWDVvcqmmbu2yDOWtc+0UQK2SYKqCWutf/OSk8RgHNgylbPifHy/xuMRIi6KZ7rKUBSiVEZF8BpA+78AVRuTuTwZCbjOpwse/f8fwr/zDaFOeoaqWjympRxTbioDqmBGRjGIqLrRwzwHZRSmzWE0lhzpml/ITGuQumsuBXadWHIg/QhVclHah81MibkFCf5PiImrMkjWWtH+7V9PS02o7UY1kN1SCr7IBxky4sBGPLqbJQpGBaq1teOHXVb4lGUJl/BXW5FAw7JSsaG3z80PnLGN3Tf96vUiE9QuUyRMVkzowcAkMwcIr7YA41H2dYILefJqONczoaweOLwLYTwB/IGgzJsixtMw3H6EeuQQds70Qof2BzKd6QYkOS2R/i8rRA8FqdH84tn/Jf7LbSBVShuTbI4ut
 Z0Lb73Dh
 Wc62Xlmm2cOuwevR6XcAflcmU7cqDy+9MLo9clt0birjQbck6rgtp56OF7YPAHbppkhgEMmshSg40GWDwauXgMh/XGGELuaQ2nj19wlzmCThLzrKOa9uElQ+KHJpkUc+aVaZfVXpakska+5JyNQ5Fi/jtOI+Jkytm5r78nRH97oT+LBQ5FnBCMTtr31TT6wJn5+H9V7V3pv9169RPtqf5/4Sw+Bkh8s/T2x56KDHEzrII9am2jeLKQc1S5bjYbEAU/TzH5dpWW7mQtUe4aBHLrp4bzNjTxfgjxxpafpHiyBHD1fY+4V4d4wQTP/vDNK1nRNNNBEUm8L9pqAk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/26 14:34, Brendan Jackman wrote:
> On Fri Jun 19, 2026 at 12:27 PM UTC, Zi Yan wrote:
>> On Fri Jun 19, 2026 at 7:53 AM EDT, Brendan Jackman wrote:
>>>
>>> Hi Andrew,
>>>
>>> This one didn't make it into any of the latest mm-* branches, is
>>> anything blocked here?
>>
>> It is in the quiet period, no patch will be picked up until -rc1 is
>> out. If yours is not picked up then, feel free to resend it.
> 
> Ah, I thought mm-unstable didn't care about merge windows. It got
> updated 2 days ago, but now I realise that's probably just coz Andrew
> was updating mm-stable and then rebased onto it?
> 
> Thanks for clarifying.

We're targeting for mm-unstable to only have material that is already upstream
at the end of the merge window.

-- 
Cheers,

David

