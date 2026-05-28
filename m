Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CB49CD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 08:20:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25A3F6B008A; Thu, 28 May 2026 04:20:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 231CB6B008C; Thu, 28 May 2026 04:20:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16F116B0092; Thu, 28 May 2026 04:20:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 053076B008A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 04:20:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9D5FB160CFC
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:20:29 +0000 (UTC)
X-FDA: 84816131778.18.B8F5DAD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id D9AF2A000D
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:20:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="T6p/7hqE";
	spf=pass (imf25.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779956427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x+8NAOb/A/8TvZS1/YH3oIOgxhYSlPSAkKFv4aDZ71w=;
	b=MC5bMFHEd9EvMStOsfK6uyX9lP4wzimfxFl+qoGLzkwSlCYf0cga0fYWLAg49fGgzuyKjS
	vt+tLRj6Qww+T8DZlqVfRpYWCGPlgunn+uYq7kPfGLZLILe7frSGFCTLtkpkFKfPMS5PPS
	m2aO/Fdt/XfEBvmbM0019sz3D0tzML4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="T6p/7hqE";
	spf=pass (imf25.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779956428; a=rsa-sha256;
	cv=none;
	b=KHjXAl69A8DyGXFUjIwTQXoMf0GeHMz8AL+JZbZt9twaWYb5lum860k5NQjGOOLr13OMtt
	HUjLaGOG3Mg+Yo+27NkdgYP+jt4aTjp43s926fA+EyMMEVH8zd/5nvxhsG4hh4yKl9q6HU
	JA7BqJJrSBt1HRK8Xm3BGudotyuu7pw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DD5FB406E3;
	Thu, 28 May 2026 08:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE9C1F000E9;
	Thu, 28 May 2026 08:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779956426;
	bh=x+8NAOb/A/8TvZS1/YH3oIOgxhYSlPSAkKFv4aDZ71w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=T6p/7hqEY8yx3KAzDO2CkOs0GbdJi8Ut1Ic9XGT5wzeIEQwjJwFfaw3r76SOyIqM9
	 OJej+uLa9NKHPdFRiJdyHRHBF64bUMpbvdyublrgoRZez+j0md+KKFnFB+iPFeorkq
	 SeH1YzEls4IMWEQmxsLEOeSw3U7hGXIHI3vxzEywf19n9jqlLVTeOSkIP0/lKcWDpH
	 OjO5C0YDp+N4QQXr1rhedKhkvrHc4enOwUbV4iU4xgRc/3guNiiMLQsmiI6f5foMkx
	 XB+2wryC0ssPPT7owuddA2EulqYqLhrtCl7nZjjQyWpkJGcG0h0HYCsOC0mJ931Rbo
	 KFu460cKsjjFA==
Message-ID: <4aceb6da-774f-4a6f-9a10-d06ff37b0e6c@kernel.org>
Date: Thu, 28 May 2026 17:20:22 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] mm, slab: simplify returning slab in
 __refill_objects_node()
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, hu.shengming@zte.com.cn,
 Vinicius Costa Gomes <vinicius.gomes@intel.com>
References: <20260522-b4-refill-optimistic-return-v3-0-2ba78ec1c6ed@kernel.org>
 <20260522-b4-refill-optimistic-return-v3-2-2ba78ec1c6ed@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260522-b4-refill-optimistic-return-v3-2-2ba78ec1c6ed@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D9AF2A000D
X-Stat-Signature: ns3sne314rsy55gm4pgsmigatztxknug
X-HE-Tag: 1779956427-526330
X-HE-Meta: U2FsdGVkX1+k/zOj/3yx+TNahOMOepqnYVWV6cMkaF7vn+HOORf+ahZwCx58FoxhvhCjde1LJIssZBCddrZGXfL4oOHjDqO9Z48GjPc3x/ljiqitP7EkuPn/RpkCWxfQqntYRLQ7ph6Mwxs/8JO7SRv5Zhs9dfZCgtf8B6FI29BkE7MppYlh0Ylnk6p4iLT0lW9VFRUl05K+03YdaJV3QWemzqvl4wEmP5V+PgZWB5W6OqNYg/I/bcKf6ko02rPrvk1KTlWg9bQgvUhAxQZ7tyMPb54pXUvSKjHU8VYQegxgVuOEVJ8DpdSKyX2b5hJqfMkcWaDm5wvZbdY6E8kMgRFRtclZ+t6E0PZCEjQKAhVlt3/IM5fBTi2cD26vbYp2MbCeJoejSAXCzVr8eUzkr9+XfaVjza9I/DQOtawW9X/Dd67MC0p8eWdRC1qKok5ECunoxnF2HydHl8nM4USoJvElay+SV6twM2SzkQLMiTjCkqc8XS9Adj3W36qZSVn8eg+47YSXGjdwJ2YKo+eJ1VATE9eNjZ9CP5A/f4Q81/Ih5biKCdmvvUMgN9dEazwkBERlGEdPwZl1GeyIYXlMGibx057pbBUHqwZvq8Xkmm8lhVuGlpejSjvrJn9a11Y9JBLlJUgkZFh0QVlk44ANrcl0nZdiBCM/G9RZWKcfX6cHlA6EvE9FeR1/rYe/oD1XciPDztbVqCvFed2LRHOHmtA0KD+5Gnp1Xn0PQAv/AKeUbKeeSTSsho2Xe4eyCHbmHqLgXBPUHDbwmO5Rd/zS24FciZId62duePYOwKOcqYVybs97t85Gk5vg15vIOqDjT3lXLf/AbUqwlyFIadjSC+SYCU48Mn82SvjPzQTVG4Fhuaxyndd/NH+7J2RG+z/AwMF81yzwzQ+bminkBpVL6Kl2zvWjs3UJ6fPyHmIjI984ZQy3R/Si88+SpxkFF3cY+anDpxJLmSzUm2Slorm
 TNdCsXD0
 GCg/5VWej4/f4f4casYramw6V75tASqOawcyudx0SGlDBPmr2/OyBzJYIzUn2hRVaLEaMnc/onJ3xug2s0GPulv/3cxPr618qRrsL8tb6H2PaX30vKlyxdtMsrNhAE5qI0NHO1tfM78PDWW+WUYPz0Ho/9LUCFXfTTZIPxA0uus7UrfIKwuSotTjg2cPf+cUKcG5J5INH6wSeuNq4VsStdrZo3niMVUGzWALdMTkLK5qozSoHXMnEUFePsJ4liI5AOPWQGVdJHI8MnmPReyoxUfa4bqVY1V5MsBCZ/+xnua+hnp/9gM0nSnRhELOSHVxYa1ePWROu1dEnpAk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 5/22/26 11:23 PM, Vlastimil Babka (SUSE) wrote:
> When we return slabs to the partial list because we didn't fully refill
> from them, we observe the min_partial limit when the returned slab is
> empty, and discard it when over the limit. But it's unlikely for the
> limit to be reached while we were refilling, and the worst outcome is to
> have temporarily more free slabs on the list than necessary. So just
> drop that code and simplify the function.
>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon


