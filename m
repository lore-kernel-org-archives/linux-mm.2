Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D452CD98F0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 08:21:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8454B6B00A1; Thu, 18 Jun 2026 04:21:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F6806B00A3; Thu, 18 Jun 2026 04:21:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70C936B00A4; Thu, 18 Jun 2026 04:21:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4961F6B00A1
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:21:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DB0AD90A1C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:21:13 +0000 (UTC)
X-FDA: 84892338426.29.AF1A3AB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 295D4180011
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:21:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GIXHsSRN;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781770872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vRZP6BkXeV5Y9+mYdnU67rb5ToB409RMcoGypcijP74=;
	b=4sbcrzpT+nrG7jHYugRVFghzyaTmec9cHjj+sKTxeWeGjCtWK2J2MZKwroUja2/wQIkuSn
	VrrsXbHNy2muORZebc4y1ZJ9p9rODEHnePrm8CCNh/mXq8/DEkokeIOOctTxmjv1ssE922
	Y/KIUZJadilubSxQ5xiuHzzYq2JbUP4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GIXHsSRN;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781770872;
	b=QoX90bKWbTMIItywEHU1CbqAeazG+KMKbecP+jE83fFDwrhPmPl20jjqvhmC5WAa1yfcOt
	7U/X6FaqFJEC2wqYo70V4HFZz7YIyJY3aJEXxOph1vYGMoyf6ystrlgyWCVry80JajmdmE
	d70VgYGvbwJDRtJVLbgi711IvsVoARo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 75080601F8;
	Thu, 18 Jun 2026 08:21:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92611F000E9;
	Thu, 18 Jun 2026 08:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781770871;
	bh=vRZP6BkXeV5Y9+mYdnU67rb5ToB409RMcoGypcijP74=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GIXHsSRNDqHF1t56tZ2e9PPEkZAA7QhQ46XgrrEuMJ+dGkcBFbZoqdTg7CeChoO72
	 nunFwrKujraAZP1AdtQOBrqIYf2M91mFe2cY/TjhznFI1Q0MMPeJVRYR0l/vUiWHfa
	 dfnPPbUortMBhwKjV975EsO1K1YhPFu9xEqBsKaLBqDIxLaOWcnxOnNIpd/oPYToAR
	 ie9ukMlHY/IvfadI7oF/nciocoJjY5ab0gzJt1aw/6vdKAcsApD5MS0H+vawUlXJQC
	 qsRjNjzy81USSLZHE1T2TYW5o9lJ4sY2EDHI8NuE2cOYtdmkKyXY+++JhGZgPQ9jay
	 jx88RYsubK7Uw==
Message-ID: <3149bc84-dd3a-43ba-826e-6364965fdafd@kernel.org>
Date: Thu, 18 Jun 2026 10:21:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/lruvec: trace LRU add drains and drain-all requests
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: JP Kobryn <jp.kobryn@linux.dev>, linux-mm@kvack.org, willy@infradead.org,
 usama.arif@linux.dev, akpm@linux-foundation.org, mhocko@suse.com,
 rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 kasong@tencent.com, qi.zheng@linux.dev, baohua@kernel.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chrisl@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 baoquan.he@linux.dev, youngjun.park@lge.com, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
References: <20260610195220.12403-1-jp.kobryn@linux.dev>
 <06122cae-e28b-4ded-a9dd-d380d31c5230@kernel.org>
 <ajK1YsIJmD2ImbAk@linux.dev>
 <1136baf3-3967-4202-9eaa-5fd667c235cf@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <1136baf3-3967-4202-9eaa-5fd667c235cf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 295D4180011
X-Stat-Signature: j6eu5dnfi98zu68axs4kenjnckm8zu17
X-Rspam-User: 
X-HE-Tag: 1781770871-554197
X-HE-Meta: U2FsdGVkX19/+rl6Ez0wts2KM6ifjORznH1CrrRfFRFF6NRo2+AhBcjoSDgVk94Vb8gf0eIik3wyny0shojeEE3lCksAO3kWuH4ngp+q+O3vnDfALA/sRx29LCxVM2xJZ58405wlY3rbYJfQmbbAr0ROB5fauD5rNa27MIfLLew5mSMLiBgU2uUA2Y9O43bCRshE0abSSX57ITugJvbz4ERwDNWO+ufkQwtiDg4ZnFSW9zJRkmDWq+wIFY0w9qrKc5L6I2BX+6oPk5lSGmioXZy1JEZkvfSXfqlYYXbByxsEZQUXDP6womFVq2BYer3vJFkWlxZPDW3PBTW5qWtNGBPgaG6dY+IkcPrEWCCIBRmsYpUu7WjDRPs/uTMHBKNwPE362zC81ZrSlH08ZujxtPqPXYcCLxOgRJhqGumKIAAcaF4GohMGH5/mrrkUxtnqLjHOEJYGQeFv9PN6KZR+XSz2U8qiC1CND7Z75DnfUn8Rbxocl50l85r89Jl5zBGekkInvYDJOSlBqzwSNiz5phn3WkFirjekrTDTGLqUB++6lwEaKtYNs6aXx/koLVomdRsWK0JUuoxwEFRlrDdMMw2bkGowla2h+A/5TXPdhd3oKBs4gE7kmGbbqMo//bHi/ubudeqwLp6urmsYLtM1/0LKA/nRBZ+BHdKGc65csV1BIGKTBQxPK+0cvFTDt8xgLku2wEwFmjNrWnEGGWq0rvigyVTk1NvmAXnKuQRusRbGabo1aCxR7FPc4QNdp712TzTyM/cvvtBp9iDG2x8hk8yHQuLGiuXEK1bmeb0N3TOZJxoQxaId0xywZaOXrEYUDe1FJscYmEPaWyL6ntdIk/ecOQebxr8iIjSNTGxaXVV9qs2vJ7Z5ZNiaZ20G6auqTX92VG/twcLbFMrgBHrYlPlCMam1T74gnX/l/miYiFirkVH8/C9ikWS8dh+x3o4NVxspNmPI8OEhU6yGr51
 87SiaKVT
 pipqYowILetxvxj8nUkrTTHmFFCycSV+msULY7J5QJW5H+H26BaX9teiEpCNwstMTquRkfYV6graa5GRbUQAOiDwdHj3YiHlZ1I3+J8VlrIifC6VGG0Hfe1QXaFzTfxeg+rogP6J+byFwZEBOeb6McKQDtQcbE6N8vE80Leiox7QbopGQL4hKLC08j/Gdufw+RjU35xvtzxYZKbCbaUckUPTu1ljr515oVLYOlCP8gqljJb72ypSjOfk+kxoK8DXv14pM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/17/26 20:18, Vlastimil Babka (SUSE) wrote:
> On 6/17/26 17:03, Shakeel Butt wrote:
>> On Wed, Jun 17, 2026 at 01:11:16PM +0200, David Hildenbrand (Arm) wrote:
>>>
>>> Given that trace events can quickly become stable ABI [1], are we really sure we
>>> want to add this?
>>
>> Yes, I think so as this is useful to get insights into lru cache draining.
>> Trace events being stable or not is secondary IMHO. If in future we rearchitect
>> the lru page handling where there is no cache draining anymore, we can make
>> these a noops.
> 
> Yeah and I don't recall ever that a change to a mm tracepoint would ever
> break someone who'd complain and we'd have to revert it.
Really? :)

Read the context of the link I posted once more.

-- 
Cheers,

David

