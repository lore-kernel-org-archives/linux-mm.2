Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A772CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 09:56:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F8DC6B0005; Fri, 12 Jun 2026 05:56:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A8A36B0088; Fri, 12 Jun 2026 05:56:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BF056B008C; Fri, 12 Jun 2026 05:56:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E7EA6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 05:56:17 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DE76990A28
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 09:56:16 +0000 (UTC)
X-FDA: 84870805152.13.DA70A2F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 202404000A
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 09:56:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QTXgxiEE;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781258175;
	b=veQDhv0DVOFbZK3AlwZy/oai8l7neoZ8H1XAcRh0yjhe0RccvjFl6rHd5iu/ZXDpk44hNl
	Ay70lNf2JtEK2o9FrGda4I3k/93TEpbcLaYSd40UoC1YsMklNcsCUv6yYR+oQrCF9X7egQ
	J4G4+D6lZR4ywdU9JJ/uJ7kLiZZQIMM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QTXgxiEE;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781258175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l6jlVZrTMp9LTygLVsRPuYIo4sYNTWWXIWJqAK8CgDc=;
	b=owwr5CvGCwFEz7bmafFFWPdTeSHmyyKCZHwVbKYCbK7VTRNt5fZ80j676DuwvpsE9YNxe8
	3HZXji+B/CO0PAEgjW+LReN4H9dpNFBL8aMhggwxRaaehq3IOB+1JLjtsB1EyhVCtLLHRG
	C7W7FZD4fTYk7J1/W1H8d1UJZsgGdvo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 62C1860052;
	Fri, 12 Jun 2026 09:56:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960A11F000E9;
	Fri, 12 Jun 2026 09:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781258174;
	bh=l6jlVZrTMp9LTygLVsRPuYIo4sYNTWWXIWJqAK8CgDc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QTXgxiEEC9QGJWYpS0Z9cwaz1rtLdzbQ0fpUyZng1u68HugBNa2NEwfLuqiZnKGKZ
	 cNl7io1VPRSEnsQkN9bp62xX7SXyBksBKi/w7N80y0U8MkD37s2QdZb8ppf/2yKFKQ
	 nCfHUJgFDOIZWUZW6Ka4x1oAl+nPyn9/kvhGWfXCEF90qZLHBUUN8p5YA7qX/3cPO5
	 p4OTjdbTz2i3b7fUplvPwFuWk8m0N9IOebB2kC3HfFK58eailvNao1AEb3ezWyxzM7
	 UOcypfufLVWwA8QrH6/k7mroDWe0gf4YsgkYNHnAa2bxtDOZoQ8/K2RUVIW1eUomv6
	 PI8tKy2MOyw0Q==
Message-ID: <aca6aedd-d6dc-46fe-8d7f-7b5c1d7bad40@kernel.org>
Date: Fri, 12 Jun 2026 11:56:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/16] mm/slab: replace struct partial_context with
 slab_alloc_context
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>
Cc: Harry Yoo <harry@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-7-7190909db118@kernel.org>
 <aiuCiXBBB64AfPjI@fedora>
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
In-Reply-To: <aiuCiXBBB64AfPjI@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 202404000A
X-Stat-Signature: z6ucxjqpuzj88onm75ek5wj8yoocibu3
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781258174-908816
X-HE-Meta: U2FsdGVkX188ttpxvFIG1jZuHeQKiUeXGIXoBaKhHlGR8OpxeGlfGYvcr4yWtbJpYDujjJqDZh8wrBJhAnhknPAvTl0m7Ts9fpeiVxwSpHheCBQEzcsuO6HVjaOekY92wtM7sjRfws1JQL1MLEwKozhHmvcFlqolpq0UGUIAgUeGptUkvq1PDUNIh+Y7axnADsVg5rF7Fp9FU+rAUeXWAIfiRiUwAWzZaPmlDRLRy80JuWkwoRGXTnnvQvY7dk5Z7KbG0hHdTUSS2x01LT6zK4Mdb1VzEzsH4DvULpMUX+sz+N+A9n1j4PKdVFMPERlaf/UApPIVOw0gRy/0DdLtbvnaNK9hJQMiU61/4VEwd+YM7CGVf/6WnWhZxhbo9ILBjQYuvV5GBbQ7qqo+WmGEieImqsuzv/wH9VJNwoPrEJKyPsSRg5OJ1aZIXNZPNQOQEoHk+uOEwuef1oKWVu4130aYCHB/zZj1UHax5t0aGZsTbwQ1pCOqvKLyjgN5SlXoM1lfxLqtMRWHYCEar6X8TKgMwbQTGG7qWeg5tfee6pc0b4VMuhsA9JZ6zbbg0p1xCGHuY3L3S1K8gazXStsW7YDsOhH0FBwS38KmKIHL4PPk+33R/2YIfWr6jtaMrvCA6v1GfijOGntxaeUbeeL1J8ng55hdTSe7ZLowrphaENopELHBO92NRgWuu7QoyBov6nOGaCFK5xSOKMar+Ud8bCRu+Pi6IeRZHlKlcT1OjZn8TtXLJl/4Ded2kqpIChsAhx3R/zTpGFgVhlnu1aCyTNDHcC8IodSnrsXYmgRP+LhO/X6mAQtw4UJNgkb3WpNaiY2rXGc6STFRrBtN+6krW8qoxoBkv8z4HNJpLtWKzif3tjQzyxrw7O9I0lOV+SQ0oBN5ZhgysDMKyXd8dmGdFG1B1UFnmaQUJjw6p3GJmNbWfD3FDellOBsoB2AwRLV3+52gCgFUrx5Re8fz91m
 +r6Bp79r
 xk7AELu51UxoLIvStaatoByQIGXPLAqWx8sV1MimCD73oYdhMQkRmBxJX/tbiUk3KMCyKgaoPhzfK77XPZc/ia6O994TtaR0bU4QkbRAC1RP67MD5vkj09fkFBm9PWQKvpC0itqX296RUnMOXJZiQSyXxMpkeJGbrGwK29XSdDhyQmpwDdVirl/Cc8FiTsW8/zFQ+CkuW8PXZWP1Kc9RhYgpSsJAswhfu48ta345yeMhtWz+6iV4lWjQy+lEHb3k8KaY2h97h9nKLUgYfwPlSZ6/9qeDpc5snJqSOCGnuqJ8fboQGW0wIWWdhmlOA4UuFy1Hsn9F+XRkUt31TRE7dw5a4u0IqhuZWNahIQ6PPaPuqaCpdJQicDGN0yg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/12/26 06:04, Hao Li wrote:
> On Wed, Jun 10, 2026 at 05:40:09PM +0200, Vlastimil Babka (SUSE) wrote:
> nit: the comment "__GFP_THISNODE in pc.flags" also needs to be updated to "trynode_flags"

Done.

> otherwise, looks good to me.
> Reviewed-by: Hao Li <hao.li@linux.dev>

Thanks!


