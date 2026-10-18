Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DB34CCF2C9
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 16:15:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78D136B0092; Sun, 18 Oct 2026 12:15:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73F236B0093; Sun, 18 Oct 2026 12:15:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 654CE6B0095; Sun, 18 Oct 2026 12:15:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3DA9A6B0092
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 12:15:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA31D140486
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 16:15:33 +0000 (UTC)
X-FDA: 85336247346.10.B940F00
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0381E1C0008
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 16:15:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GvcUdolp;
	spf=pass (imf20.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792340132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rIvy1ABivVMVJ/YwrLZN2t/I+b9NdRqcsPWIXfXCV4o=;
	b=o4bjNHiDZ6ltR7yRA9g3aCA0UsyWl6Ko6IR3H3dgbgTuFaBH6COdjAFKG0DPPquV9wCRkR
	bHTzm3+7g10+KeeNCGHi/MsRQNNWlrl7efg0gOx+aa5tt0GdlS3jSAlROF2rS545Idcu/u
	SiLIi6UJDBw0il0Tn9T2AqnH0zNRkvc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792340132;
	b=wSYL1pQtk4PYRJHo15O9F05q4KeN3xkzdFrmyGp3cc3NLRoqAHW1rwPJFETWWsOG4+eQ1N
	Fv9ZGTvl8S6zhcURvLTm2zt1a/ACuZeLeFunmtKU362AJDaO4yJaXZtMZXM48XNzjWkmxC
	3EtUw6HnNnDLghLR/4r7P8iLhoESiJk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GvcUdolp;
	spf=pass (imf20.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 114004167C;
	Sun, 18 Oct 2026 16:15:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 761ED1F000C4;
	Sun, 18 Oct 2026 16:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792340131;
	bh=rIvy1ABivVMVJ/YwrLZN2t/I+b9NdRqcsPWIXfXCV4o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GvcUdolp5lKHWLRUdZYggrDvIG1ph3QEtPg011D72qDX8rgyo4MXdS75i5iubiwvF
	 U1g9ahlyrvatC77Cx8Kca+U+xhKLJaYJRP2lMuSlPd7LalTDNwp3y9Nhw6JWhG+9/M
	 kzoLDgl1boM/PcglOtUBiOQkVuUwhP726U3Gx1MGP2C1+k6vf4LPhHxTSQs6ECPvjh
	 CnEwwmuWJ/yXMeu+7tRNHKvMJBnOpZJGMk0X9SiLHWx7AnILAp6sTVpMsb8LVtq/zO
	 yialxXN77Xh+Skasd2UFm7On2XXUy5xHgkmZ4hlb3pFEbQkghfgIGyr/s/dvXDE2/9
	 rm/Dhu3hZ1i7A==
Date: Sun, 18 Oct 2026 17:15:28 +0100
From: Harry Yoo <harry@kernel.org>
To: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: akpm@linux-foundation.org, cl@gentwo.org, hao.li@linux.dev, hch@lst.de, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, nickolai@csail.mit.edu, rientjes@google.com, 
	roman.gushchin@linux.dev, vbabka@kernel.org, vitaly.vul@partner.samsung.com
Subject: Re: [PATCH v1] mempool: fix min_nr exceeding the elements array
 after concurrent resizes
Message-ID: <atTv1tg9q9n92kZv@thinkstation>
References: <atTh-yyVIPQ-zNWJ@thinkstation>
 <20261018160315.1465504-1-vitaly.wool@konsulko.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261018160315.1465504-1-vitaly.wool@konsulko.se>
X-Rspam-User: 
X-Rspamd-Queue-Id: 0381E1C0008
X-Stat-Signature: fp4ckc9zskbynawygkkpdrw9fkrtrq8b
X-Rspamd-Server: rspam05
X-HE-Tag: 1792340131-334288
X-HE-Meta: U2FsdGVkX18PM1U1clckGwEWrWX0+RiJy7yrVyjwzUZbOOXdZSi7LCDL36crF7ZnL1UCPJ2Gjvi1Mr3AJWeP2QSMYDFS8yOdJuSdRn7vaT9e/SMmSL3cOSl2yBk2eOfG6t2Fh69dR+AFnuE+5WHg7FmJWrktGFJtOr9MbaOpvQDVoa30foRg7qYYWbiWhIGd0FAIQL+lAKslFjWhzr142n//gUcArv2/q21WlEbMfs+yF86EkwbwzGP/EaDWH7bl/PgM+zbpXt4YrSEJwIgov7rvStHWOx+IkKNP5Diuu2CMUmOZXiNpWi+r2iLrSMiA3M1hXRw86W5um2JNPZ8M9E2I8zZoEZezCIbrbibRhW/FpbsW0eObD28mecFLoFq1TMW4lq07eLYBafpSKExRfWm/RZ0mCqmtCsEpw5jDfPAx2yWT0fezfO0f1kjKofnHuU9newRhD+rVjwlIdb34g7DPqv0EnomL2XWQhxqrZF+mhwI+VqEL0Z/1WnsGYYhuKV2CV96KrFJTHz653WX18Ma65bn95ddtmQ5vFWPIRIO++I+WoxO77d6oWEdSGe64mWaRkq2D9h4QPcB/O/RhtRbfGysYufTpdT+6GPTargBQTBbJ7PRIDj0bwgmuQql20kwlqbX5gfr6SFFBVtYgtTYO7nMQ8y0Kuj7c3hrXUnDruMV/Hn6tk8Abpe3ZavOw1u+Squ9Sv5ApaUdDGq6nYarLeMhyEbaXTqAGazAV+GYZdUh/T24PDiI0v+CnSLVYNQjOLAgtMtcsqV3cynNCBJDAJTXhVWB27Kie5CNHwkQ3tcblpFar6RzlPuZhV3LLQVdrG/keOaGBN0cXVmm/YTmB6PSI/XGu93LgSNl6Iy6mH7HO5jW+AIoWNc0SyoZ05MmQaDLeFTYpueC23Gi6YcJacZ1h56tveZmdEh3J6cGHHBcW3ztnKSlcqM+G2NVPrQaKdjyTviJx3tGPJsY
 PY7sPh2I
 corS3pVTRlEneQKme6Ep7EXlpfL1yRtz0hD2/auBYzUHcULbyPG+tgyYBUgpz2QySe0Y2t+2WJ6sg1G3oL/rBPyRXLuNQ4WYTqyzUeMI3r1KcVbBkkSjkgwT7WrXfAFfjxZqT/u/DliwEnK7434SOkjbVRGGZIiTr/Jg9erGcqVwvXKekEOjE3h+3UhVDFtX0hdV5VdhRmPbFPp7MWIux3/Ljq8yeTVewW4kiCrjrDocD42WKRfnAz995W62eO9dPAccgtyf+hwZOO30oBVA5HqktxW2lHCogyaS5+NxBBOxkCG4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 18, 2026 at 06:03:15PM +0200, Vitaly Wool wrote:
> > > How about we take my patch [1] instead since
> > > it isn't prone to this bug and is a nice optimization to the existing
> > > mempool_resize() at the same time?
> >
> > It is not a good idea to squeeze a bug fix and an optimization
> > into one patch.
> 
> Generally speaking, yes. But that patch had been submitted before the fix
> popped up, so there was no sqeezing per se.

I mean the patch you've submitted does two things (wihch is not good).

It should be split into two patches that 1) fixes the bug and 2)
optimizes it.

(Setting aside the question of whether the optimization is worth the
 complexity)

-- 
Cheers,
Harry / Hyeonggon

