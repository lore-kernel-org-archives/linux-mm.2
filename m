Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F099CD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 14:07:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FF876B00E8; Wed, 27 May 2026 10:07:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AFFA6B00EA; Wed, 27 May 2026 10:07:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F08E26B00EB; Wed, 27 May 2026 10:07:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCC486B00E8
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:07:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AD75A1C04C2
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:07:20 +0000 (UTC)
X-FDA: 84813377040.25.070EB65
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id C041920016
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:07:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YO3iCQgJ;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779890838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i6CFXNwgelzox7IvTlIMcrTk9ZivAZLyNzDVQx0vmz0=;
	b=ZY9ZtSXMt2gH0CWY9r176xXFlpw+C5i1GNW8Qj8f5chbU0uyMSfzegfuNT59w7XDcUs1Pt
	14p4MdurcIWW16FT2vRqjAP6tmTuFFfDSU2xAHkv5JlP4lBhx94IxpyeCzGhPgP4N1nIve
	FXTXWiD+4KCAcFtEopEBEU/ZPRowrAI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779890838; a=rsa-sha256;
	cv=none;
	b=yG5UrE0c3oSyhooD/ZfMK3XUDepeyc/n2sPGCsfMl4hiq4yC7BN35rAmhPHw5t4A3h44y8
	83ZiX1WOa6gpDdLhGITwXfpFgPJPa/gmVaPAc+z/BsalfFNe6PgZp+I3xkNUlVyOi04PGD
	kNbO3r4s/Dgjk+drsrq63OMP/pO/OTM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YO3iCQgJ;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F99440580;
	Wed, 27 May 2026 14:07:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF5B1F000E9;
	Wed, 27 May 2026 14:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779890837;
	bh=i6CFXNwgelzox7IvTlIMcrTk9ZivAZLyNzDVQx0vmz0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YO3iCQgJzQNEuhfJf9xffpLM/icOpMtouwv0izhfb2PKmNQmpH5td51ftB6Du9zOc
	 fHsEanU0BPD8hO37OadHUSVoZd+RngunGa80VBbuatQFfj5tBWlCENwUPM/nfite3C
	 C//16ZlWxP8B5dRSXTSIkQhzKGlOPwaPmn9YLyibH26prw+593LpwZ2DzvkSvUV1gH
	 tfeSw0vUJAIXqB4Adgbf2M7zIJslaT4zS23i6ZJR/pUIHD3BJSSBiiT2dxu1lfwi1r
	 VCpC/dAdISBdIqPPs3SA+oZCx3VP+2EOveKbCGA3Im3COWqV1EtTZXQBlp61LBnMC5
	 8K+VIxz8FXnmA==
Message-ID: <482ee03a-c5b3-4873-a550-cc5743068616@kernel.org>
Date: Wed, 27 May 2026 16:07:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: improve the kmem_cache_alloc_bulk API
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Jesper Dangaard Brouer <hawk@kernel.org>, linux-arm-msm@vger.kernel.org,
 dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, io-uring@vger.kernel.org,
 kasan-dev@googlegroups.com, bpf@vger.kernel.org, netdev@vger.kernel.org
References: <20260527070239.2252948-1-hch@lst.de>
 <ee817070-cc7a-40d5-92a4-2bd8e9e65fbe@kernel.org>
 <20260527122148.GA6838@lst.de>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSNWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBrZXJuZWwub3JnPsLBsAQTAQoAWhYhBKlA1DSZLC6OmRA9UCJPp+fM
 gqZkBQJqFFy6GxSAAAAAAAQADm1hbnUyLDIuNSsxLjEyLDIsMgIbAwUJGtCBUAULCQgHAwUV
 CgkICwUWAgMBAAIeBQIXgAAKCRAiT6fnzIKmZJIUEADFx/tREzUImHrEwVHeSvDFmA7tJysI
 UVrlvrM09E7GIuzphzv7jYmo8n3ANpCczLEVr4G0syYQdTigaZgv3+FQDIIzhKih1IHhu1Ei
 XHlywNWKnQxxQEUNi5Mwx43wQz5XVw9F1A7gtKBKNtfogO511hAbrzagrYajyQacEJ/+sfhZ
 9Da8ltHIXD8pcYaHUfQgEusCgmEd9+KrUwrTbckFKmYq5chuE6yJ4J0EmWknL096jIE6CnzF
 FRslQ3B1UKDjxVsm1ZHfir5NeWszLkTvGFsddFaWTgh8UycESG6VQzKXjjewXu2pG7YQYRpj
 QKm1W5X2TkwWkXRBZTmfmbhxIUMh3+zf5wQ463rSmDN/8v81tdqBtAW6rH/kzg1GvkaTHXn0
 507yEHFzBksk2viAuIxxr7km8+/KARYLIdGtx30EG8cKzAUZOK6WqxtNCsXUJNrVE8CWrCaD
 icoNu7Fs1c5hmPHdSTnU48ce67449DdnO4neLSNhRiGlMHJgfJUmgrxu/hcYeOZ3haWmEQ2w
 uW1Mh01OHi8QZHCEyAbABrPs9GUgccc/4eYXX9hIgxfSkYzn8f+8NuIFPWl/0uTvjgqU29FQ
 SbzOLxHq9439Ox40G5mS5eZXRGxITYR+6TXvRGI6P/264jvflnr/pDGUttaikU+0W+1uxgKH
 cmYbEc7ATQRbGTU1AQgAn0H6UrFiWcovkh6EXVcl+SeqyO6JHOPm+e9Wu0Vw+VIUvXZVUVVQ
 La1PQDUi6j00ChlcR66g9/V0sPIcSutacPKfdKYOBvzd4rlhL8rfrdEsQw5ApZxrA8kYZVMh
 FmBRKAa6wos25moTlMKpCWzTH84+WO5+ziCTsTUZASAToz3RdunTD+vQcHj0GqNTPAHK63sf
 bAB2I0BslZkXkY1RLb/YhuA6E7JyEd2pilZOrIuBGl/5q2qSakgnAVFWFBR/DO27JuAksYnq
 +aH8vI0xGvwn75KqSk4UzAkDzWSmO4ZHuahKtQgZNsMYV+PGayRBX9b9zbldzopoLBdqHc4n
 jQARAQABwsF8BBgBCgAmAhsMFiEEqUDUNJksLo6ZED1QIk+n58yCpmQFAmfIHFQFCRYU6J8A
 CgkQIk+n58yCpmS2PA//bqN1LfcotmArgElsa+0EGZSQlYgK48pm8WAeTXTngudP9IJ4SuKY
 HR5RNjHcBeqN+Me0zxRqYzRb8nGanHEkDyf4Im8DQM8d6vbyU+FcPmG4skud4kgS1zMHnlVd
 SXfSIwKC/hKgdHG8aBV7545Lz9X6Iohea+94wneD0aw/hqF+QWewGZhWJriWAZtvEkzNjQOi
 4U9F/trLten/x7bpphDSnDMKJtITbtzATT1Dq7o7VpIUK1nCTQALMuMjKCdi8OdU/+V+R3O4
 0PXWvX8qrvqYapVbZ+9KqT74FsuB0Ya9uXwgBF2Q6cRuETZk5vqaqKxzqoQZCO8AOz/58j6O
 2RHNy/mZEN+7tJ5Tsq42zVJ4jxsT8b9YplavCMsnBgDeRWhcbYhCyttoL7nYISyWg4kQYZ/P
 wIV3OuNv2f8iKYsxNsRuClOAF82+gvqOy1/1pprFjy8uo2pkoOrb63aOP3vO5VHnRKgra6dq
 NcaZ+c6J4H+nEJGi2SkHAUJz5oBzuThvPudLvPA/SK8sKoM01IRxSihev/S/5WLazXB1PGem
 OCbvzC1IjWJJraxiDJ5IygokapUa2RP7+WBR22skQ3SSl6G107QgWKSyTOGWEaRmV53vxQLV
 jXuCmzSSasTL60zq5yGrT4/DYQVSNEUiUbG4pYekxJujNeEDkUlky0Y=
In-Reply-To: <20260527122148.GA6838@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C041920016
X-Stat-Signature: s8bu8hakcyge14bdwgmuodhmcpqefti1
X-Rspamd-Server: rspam06
X-HE-Tag: 1779890838-580370
X-HE-Meta: U2FsdGVkX1/dkDy2Isk9QTwkPO+b91bPgsTbyjWTevKvV7WBaIKtqsy47hY1uctLVGcE4d5UPk2IR/Zfsjh4Nv4/27dbAFgnrT5w6UK07nwWv4N08yNwaLGeBaYxqS5OTUPQ3WsH/eKtCWI8eUL42XsRRIdACYp/0ZiIv9c241d3NFi/a5vXdNFWTojKmXBZRUTl/PIEBf8N11FitKDACSuAi2FE9fc7zGyi7N+m1z1vdIciXo+j/BOybHdiou9oqVhRZ0UCGqzn+jqNzWudhly6WPNM4S9oKRkN3FuTb+QOKJC2iYuoBWCVvIyZSVgmmbViDcbeji3Ev6zdfir7lJiVdd/7XBZM3zpqHabhaKBEYdc7j6YCUCBM124syaNOBdjlTTvPB74/3EcvoRp/C95QOEVRkRcxDcK9cp900Tz2QcrHIwsr3K/M8StgBY8XMXytg/ThPZ3Abh72s4bNG32CgKmFSPH4DJUQZ8uJx+/LhPO50r7phzlyNyjD8BZtifKGs+LTn3SpxJqLoUL63grwuC19XCSyczH+1VlEkdXXMiexD5dA3VeO4r6lokLCNVXnb1Gj0HnUgQjuFpNGExSYN6hF4QsZ3RQfYK+V88ZBDuPOiHo97suMjjzyONYBR3B7aHbTPRE/zuh5ZlLMqw6YdGEBJaS+LHCwBNtdnfG0BdPvkjuqFPYpGCfykHaKkVey9sfF20ixkOtSrD7Qfsk5ZVT8b8Efe1BYs/7cN7THf39cJ3hGFAgxitUV9C5dU3RSUmXTtAtOTbjUBtvKSHsbf2yIjZErHht7yviSmTArTV1Wr8Q8xhAT9aMKp+lNDz1T+yV72l2lft/KxgQ2XbTJaGWy6MeKVdZU/C7OG0/z6cyMqIBlqUhufIfYk+LFQJ9fnWnGQSsiHaOB2aSbqCZw90x1FyPm/RV64y20RBZSaUD6mKTJ1lKahgUkSzJJ5IZRElwKRH3LrEnExUT
 KPtEQGjV
 P2clQhKU3tfhqsHE0wlPk6FmGau9Rmr4dnZDxf4TXnM6D1y4ojBXzIsMc4cdPN5geO89BTy4W4fr+eG8k5IKsVJ1zXB/2LPB4cE+w08/hfp9EwiTxNeQ34jMEulKcetZA4L/v4ZkqdyT+UDbe0L8omSj/LnvfRVJ8FTgQ3NMLuqtm7pd4mAJWY2zSvMvCk3fDtJ16nk1Bme5RXMY98FBlzlMG7zolHTncswDEMr7x75VyCOfVMigL3dPNv7AxijJTjFi5BUtyYTyCMLnIpOJLFtD1ykB1tPaSgFbGm3y3A+QMSAjyEgDwGuE1LA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/27/26 14:21, Christoph Hellwig wrote:
> On Wed, May 27, 2026 at 11:11:31AM +0200, Vlastimil Babka (SUSE) wrote:
>> > value convention.  Fix that and add documentation.
>> > 
>> > Note that the few comments explaining it mention that the gfp flags
>> > must allow "spinning".  That's not really a term used in the memory
>> > allocator, is this supposed to mean "block" or "sleep"?
>> 
>> Page allocator now has alloc_pages_nolock() for when no spinning is
>> possible, and it uses ALLOC_TRYLOCK internally.
>> 
>> Slab has kmalloc_nolock() relying on that when it needs new pages.
> 
> The comment long predates that, and it isn't expressed using gfp flags,

Do we both mean this comment?

-/* Note that interrupts must be enabled when calling this function. */
+/*
+ * Note that interrupts must be enabled when calling this function and gfp     
+ * flags must allow spinning.               
+ */
 int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,                                                                                                                                                    
                                 void **p)   

commit 46dea1744498 ("slab: refill sheaves from all nodes") from this January.
Previously it was just interrupts enabled.

> but by requiring separate functions so I somehow doubt that was meant.

Yeah, it's expressed by the _nolock variants. But slab propagates it internally
by the gfp flags, and since 46dea1744498 it affects kmem_cache_alloc_bulk().

> But I could also not see why it would not support GFP_ATOMIC /
> GFP_NOWAIT allocation, so I might just be confused.

Yeah those are supported because they can spin, just not sleep.

