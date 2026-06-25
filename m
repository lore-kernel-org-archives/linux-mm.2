Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8ABCCDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 10:42:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8552B6B00DD; Thu, 25 Jun 2026 06:42:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 806316B00DE; Thu, 25 Jun 2026 06:42:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71E446B00DF; Thu, 25 Jun 2026 06:42:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 455E26B00DD
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:42:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B75D790027
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:42:15 +0000 (UTC)
X-FDA: 84918095430.05.3E60BCD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 109EF40007
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:42:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eKJynOg1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782384134;
	b=e5XKPaR6qmj3Sc8LtckOBD8gQYf9QR9So91Vau0xtLpIo/fG10vMtf8x7t1l8tl2+PkCXK
	anZsb9n3ftMxzD4kZp1CcfHQl+G8cs9EkySJtcFWt0KeDewBO2Kn0+gWxKjszgMNgA0bJQ
	XFrwfrbMTbH2FbmqlLLjPw2JYIUWiLY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782384134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M+hdF44mAriMWEPKasVyDUzCqOm9ZECGxYcFzR8hX8E=;
	b=eooV/GGnSSbESgkuncgZtXXAP4gtQxG/eOtf4eBDhKx/3/Ympnp6YSwG/soMwxjvLnHohI
	mTQmDz+iJD7snFnKwgmkL3i7b7PZEITwqTd4jD67ZTpzjNXYwbivWEApimRJSdSX0C35cG
	UzWprhzjwCm/tnkt0D3pN572GHUofas=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eKJynOg1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8774260219;
	Thu, 25 Jun 2026 10:42:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0491F00ACA;
	Thu, 25 Jun 2026 10:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782384133;
	bh=M+hdF44mAriMWEPKasVyDUzCqOm9ZECGxYcFzR8hX8E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eKJynOg1SL3teW0kvvwJeaHW1wK1bz+B+ChirrsSaw/ZNTJVF1MR9afvhvEOb7I6K
	 gwZt0ZIsLVG9ND2mcQYVCF0XcSdFjTAX5dJHivLSTEBDAvxeEAgCBg78eEZz81qGrL
	 Y3qKCU3MV2cRsGzraivboSUxCkpdQqYcUxDdO5mlgdC4mgtOFVRji6XdzftEYt9Yeh
	 bpfE9Rdv4xjlDxlfAfO9LbOVNFNqVZBLZR4IgaGGiLz182rh9xC62UN+XjDAwqqRw3
	 7KCKdd7ZJd1uS+ZrABmRT0WI29tDzTZCLrCaDmMwlvpauwlEz89sHk6d5Y2llMmXrc
	 HcWySn1cCuONw==
Message-ID: <eba3da0f-cb01-4550-85a2-4696d0fbc194@kernel.org>
Date: Thu, 25 Jun 2026 12:42:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/mm_init: don't overlap NORMAL and MOVABLE zones
 with kernelcore=mirror
To: Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Taku Izumi <izumi.taku@jp.fujitsu.com>, Wei Yang
 <richard.weiyang@gmail.com>, Yuan Liu <yuan1.liu@intel.com>,
 linux-kernel@vger.kernel.org
References: <20260625073941.145014-1-rppt@kernel.org>
 <20260625073941.145014-2-rppt@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260625073941.145014-2-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 109EF40007
X-Rspam-User: 
X-Stat-Signature: f4sikujkrbs3weetrstkq44txu69tju7
X-HE-Tag: 1782384133-279633
X-HE-Meta: U2FsdGVkX18fM832WXa7qR1SybXoMoCJwue6LOUxOPBB4LuMi28EdAu88e05Cy8Qk5B15WSqiYKXwGH0B6sKkJlo02CUE8GJ65h2pBWih/pbHD2YSUVBlOUXsNoFWfzQSKcJI7VShg5BQ/KFPFMFvldlUsbnMv9MaWYsgFStMC6B3QlRVqPjEVC9nqI3RaXn1QqCwCK+1RQ+V4qPySV0A4F9HgZRoG6HI4uuWRITS/81KiW33L4qrS5HcQ+7cP83DdfkwV4SdlCgQuJ342jUKh+Wb1ZYXWw+J/bVGQj2cfuWCqt68mD12FxBHGTfSpNTW2o0YriYfeOX4oXgG8br1uTR4H+JOkB7fjph5QnYcGOB/Opdc+TtaExQVKMop8Y40VL3lZcQ0p5Z2h3pRf//5jze4yWOcWkYm/EzUwbcU2gNriv9N1LQhq/art4HjHypBcddqo2iBotAB3+oXM/z/lpXdMwsLQ5tZ/JKo2HSvCnkmOS+NmTMctCLFKc0628LJfbTK6omhgffYYvJqX2t64zgPP0OJM/WPTT1L9//WetOgQXa3OqamDUSbUkabjdJy59XXWuSJPjwbRbFAobFF9Sr/OYkRMeP0p4es0fRbVl+qujqqBW+2NgNMxv71Arj302kQB035IrH2P0wA++26NxmYtAF9sZiEPomUssPZ/TYS1xcp7An6+oKngpeSnJT58+O8WANxn6wqptF8jbVGP/g6s75rzVxRiS//8W3MMl36dqiANnD1bixmMTzhR0MxXwBYlPg0Vf/W0jdqIrvT+FdQY2dWZF3HawQEmZc0igvty3zxSFSJAePSekBfAjWFweTJ7az+azG2BNBm/s4rvBCCLFhdyR70vpdaWo1idRKXPWoGPC6N9qeLAaElrv84SWV6/r9ROA4r5Nt2vyHQblReuStAzRsyugbauBQz0RbDO1qUSMDtd/ojY2YGcaU4SaMxhqov1Pn96q7TQb
 vIZxzWgF
 WTGthnGayhhtEfeAhna2V+0qUtyucqRXbHGo/QMQ2vDzCFypkGHLIilmQ/ZV9inxAOBgPMihCRAnaHZkNOcMXEmxsdBUtfAmcR7/kWYQkZtB0bcIFPQfDdOqwBmgeqQ9N7oLySRxJpSIfbKVK6cyFhSoE4J0K2xDOuXktO9lNI70xJnO9meJNqbkCQgBt0JrRyoyGeo7A+GrT8qgLQm1ZbQVyMZqyB/SIK6kmsmUxVio7zDus0USMSiFfage5muViZgHcRu9Eib2ceyrgXgDqMPtoPKydlgfxcr2OFEzEYGswzvpQwajZlhhugimm0rErS+oy6uIuXFDv+nVpy5TELx0xTbw6kaocLR+yjx8B6TZ2YSJFa04iQaAWt0BhDEmYE4ylT5srWj1UP08ayIJSzdgtvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/25/26 09:39, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> When kernelcore or movablecore kernel parameters define size of the
> NORMAL and MOVABLE zones as percents of the total memory or by absolute
> value, ZONE_NORMAL is clamped at the beginning of ZONE_MOVABLE.
> 
> However, when kernelcore=mirror the ZONE_NORMAL span is not changed but
> rather pages from ZONE_MOVABLE counted as absent in ZONE_NORMAL.
> 
> Make the behaviour of kernelcore= parameter uniform and treat mirror
> just as another way to size the zones.

That sounds just about right to me.

Hard to imagine that any code would have relied on the old behavior.


Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

