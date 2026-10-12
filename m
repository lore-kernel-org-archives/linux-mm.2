Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F311CA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 15:26:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8A236B008A; Mon, 12 Oct 2026 11:26:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3B376B0095; Mon, 12 Oct 2026 11:26:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9516E6B0098; Mon, 12 Oct 2026 11:26:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 71C116B008A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:26:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5F8941C49D0
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:26:39 +0000 (UTC)
X-FDA: 85314351318.13.777E180
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id C07864000A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:26:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hkEsJf8r;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791818797;
	b=1csj+JNqCwOAuP/Q/e8rKbO2TaQDRuzqh6lAd7zVaMrvx6nIzia17I9ChStIYf8R6s5j2Q
	7sLSbyhG/giPMFo/Wox/bXeC2WJKFoAuZ+mFUTlkk4AU5/XBNhbC8KSMYc/iWSH/I4R4vl
	9ZnlJy3Hb7c3YXJQtmeAbaYAUMM6TLQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hkEsJf8r;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791818797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wLEJOmKB2D1sT8Kd+NykOzJne812G24b12XN/JMTXnU=;
	b=OJHhYe3rjgqjz3cYyAb+JwN/Nvn8vCgfqNF/W3yiNrfbr2TtJuXIRRjzRD0/mWDOjMQw3N
	Tpq4airhNGy+Ul6Nay0W6+QCbJQ6ppomkHs+V4E6lF4kt/UitsMGh2TxxZFMyCW82NQqpB
	YiZ21YEBqksIu1uOPeF3rHKm3BTRV9Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D5F2543618;
	Mon, 12 Oct 2026 15:26:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0A081F0089B;
	Mon, 12 Oct 2026 15:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791818796;
	bh=wLEJOmKB2D1sT8Kd+NykOzJne812G24b12XN/JMTXnU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hkEsJf8rILO2y5vMNiI61WRnKDE00ir2qR7BiAjX7q9VyaDPuENri+7cN7obIIpBn
	 1TCIiOSES415TOEfhPmB5jK6t08rFaNhD6SQfVRyvlVW+3SkMmCOdjTjLy6Doss57X
	 pL2UwxQSAFMHFabgkkwXYo6orBPrOUBC0cZWA1tMVymAbSMRHoEjoQqVgDU7lAURdn
	 ABCSX+5X3cskdpWqGD1q/xLQJBJtu7fGLSl4WwVvQ6pvGAHuTO09i9l3lvjVLI2boP
	 /j3OHg4EfMU4hVKlxlKDZng+1vUEIxOiy/+BkyOna+h5PE/cO3SIhkycB+e7eUpudU
	 BwW4kDnrIuVKA==
Date: Mon, 12 Oct 2026 16:26:31 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, jannh@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH] mm/madvise: keep the hardware dirty bit in MADV_COLD's
 THP path
Message-ID: <asz7YUXhdmlenXvh@gremlin>
References: <20261011132227.413217-1-samarth.colleges@gmail.com>
 <42087cd7-473e-40a7-ae63-3c841c615c8f@kernel.org>
 <asyy7Nwik5yMTNbo@gremlin>
 <asy4c7zkkmSRln1H@gremlin>
 <D964ECBC-59B6-4A4B-83D5-935EA2D06D30@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <D964ECBC-59B6-4A4B-83D5-935EA2D06D30@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C07864000A
X-Stat-Signature: grpowir69ep6npahgcgmgqzx78n3tcpk
X-HE-Tag: 1791818797-101275
X-HE-Meta: U2FsdGVkX1+QOKrZwdMK29B2DWphYtkKJ1Ekm6171ndbiatL5mGo+0k+Ju7JAyLBiYKdn0UYSNAPneYxxdAe8Qak8OwKw7Fs2Hm0LnppJtGn/8c6bOHiu9yW0KfaimXabc3nLveHjw8Hn0VvZMDQnfng6KjBS0DqEffTzbuxWPMk1tkaaKL+aAwUeaFwf5uktWRjO6v2gY1+DfdybLskTQylA0PzZN5CsmBU33WOFk63g/746KeXav4gGO2Fp42wuZCL4pqEy1SbIdQUpEDoBVHz9VocfCMog4tmLUOlqZpMGF3fh1YhyZ2+KN7uzMW4x0wiB14+LUSxRdfYJqe1YdBhEK5vY/6Vr9OQL4iPHNyTr2dSWoNWSjYLosx0wQqvnYtXM5yqf+4mSWqrp1Y9H0jowsix+j6Q9/+oR38D4C48VupJ8JQOmVUdJ4HTXrbB2Cuckp+PogvDJaPxSvh8Iuy/Nj/0J9n605bEIAtaYVCOeODO8TST1yuZaUqlO1pw5iCMBJZU74TIcs8EHUntkdRGeiDJbMxoFknaoRx73pj8qjEAaqhw/c+zETJQF+91CwKEw1TPgmkssNuMgineYLQ4VlHZoZ1HzJyLfO0ym2lFz3EUVM+YUsGKKKwvhIOvUXzd0wnmLiC+JhzVyNVNnT+SLO5bPH2cTQmRjgP8GVniMcZGDIq5UYNOe2u/Mq9T+/pVcnBaetKtWM/tGbBlLK18bZn5+hXgz1L14JjYOdmn9wiRCdMV0Jbvd/qu+13xQXn3eJ6FpsnbeBXTmIHeWY9nne70076Bg8R9PEpe59pDp38Z59Pxebu0tX9p+xD0hkZ8JWQn6bvnKE9XPCL7WAki4oUNvSsx2kQvIEIOESnP/P1xJgrkl4U9JcPDLMhGM4bOLiR1EiTuExiuo2v1ogkEo/OXBFghApIX+mHtpvRXcP/Hh7/NlAJoqPB2LVCRSjSl4sm3kqjKSGHAzmV
 ffjhdrkv
 mVFtzSmqxS9uu32tHScbTWxuMLcf4zuPgWZyznSy8cjDR+v2uUkbq8oxy+VNZ6DXN7V20rzDaEaMHhw5uGBjHwshZ09pa3sfLMQRHFl4Wz+M+HuQnoHdq8W87hs6HCN6cB5AI7TCF9oo7n4dTvJ/T+2unhF6kMZeDOo8FoFrfp/9hfmg0Uy3b9QcbX3IW15MJGTPAF6fcWL7jd8nIlv6WYDVxA0/q4gZytO3POzfwI005iyXZ3vyRlY+zqfRJJ96SehKHYHx2TlXqNjCZw6GAPPk+14CRlNvbEKtwyvxXXzzi8Ub465V9PdwxRaBSBwK+wUm6Nz4XuOWeWrllTYk32JoR5OQ6+ZRYvtOiOjt5WXI4w9dOtF0glgzJug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Pedro

On Mon, Oct 12, 2026 at 11:17:57AM -0400, Zi Yan wrote:
> On 12 Oct 2026, at 6:38, Lorenzo Stoakes (ARM) wrote:

> > [0]: https://lore.kernel.org/linux-mm/20261009-lazyfree-stable-fix-v1-1-70997958ef8d@nvidia.com
>
> No. Without lazyfree PMD level THP discard, the affect PMD will be split
> into PTEs without dirty bit and the dirty folio is still discarded.

OK thanks for clarifying!

>
> We will need Samarth’s fix for backport, then we can think carefully
> about David’s per-arch solution for mainline.

It's AI slop, and we don't accept that in mm (also -cc slopper).

Somebody from the core team will take of this fix separately.

Pedro - you mentioned you were interested in this, will you send a patch?

--
Cheers, Lorenzo

