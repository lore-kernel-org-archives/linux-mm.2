Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B2231061B1E
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 20:06:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77C576B008C; Mon, 30 Mar 2026 16:06:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 753F76B0095; Mon, 30 Mar 2026 16:06:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 690F46B0096; Mon, 30 Mar 2026 16:06:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A6786B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:06:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EE99F13BC36
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 20:06:38 +0000 (UTC)
X-FDA: 84603812076.06.E4CCEC3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 490AA120013
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 20:06:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wCKo4Is5;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774901197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G7HZMfX9bxALZwvZ9eSicFX/pjbfJ1VjtQ7gpBZohKg=;
	b=rjxUadK1i+P9DIKRKjCyOljDbkeqNpDM/umw1mSLDDM1Y1i/qer/LcuYvWGq9Q7Zffu1Xe
	0zsRqsLPcxgR3y/fWQ9ZdUNcoIne58zBVKxHwC09N0QqHvZAbtyIPEdai/f3lvPAvQ9Bpf
	BrdgtyOeVUiXZ7Ir54h05W6ZQ8FFsjo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774901197; a=rsa-sha256;
	cv=none;
	b=zn8yRbC+u3MS0lK1MsedS66Jy3LaO6qkTcPPLUw673K7oHXnNTS4laWB06Juxvqdl5/x2X
	jmPBo61qcKg+DMOdayuJPyTZ7lmDbjyWcrdCGskPGCazwvDbeYl403nDKwS0qHOLdwFkAF
	O1CduOPMLUtOwLwr/m5J7mqnrIWuUDE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wCKo4Is5;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BC78C60126;
	Mon, 30 Mar 2026 20:06:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D4DC4CEF7;
	Mon, 30 Mar 2026 20:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774901196;
	bh=sEiQXZDCaaFYtBvA8B0iuBVUBJqm6Up/A5JvW9UflW4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=wCKo4Is5few/I9zid1F4bRtm/hrY88NcDsDx80Fez/TpWyF4vKC+KrjO/D0gNb5tY
	 Plf1l2SaHPhG1cZAZLbWGBF7jFQT0pTicNavKY3UlZx5ZDFSlRfuF+TimxitaHW8+Q
	 +RzFJh06KeRCWZUu7wdorPMc2aNMfgbAL+brZC6g=
Date: Mon, 30 Mar 2026 13:06:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Luke Yang <luyang@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil
 Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, David Hildenbrand
 <david@kernel.org>, Dev Jain <dev.jain@arm.com>, jhladky@redhat.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Nico Pache
 <npache@redhat.com>
Subject: Re: [PATCH v2 0/2] mm/mprotect: micro-optimization work
Message-Id: <20260330130635.1d8bf3f1f9dfcafc0317f5e7@linux-foundation.org>
In-Reply-To: <CAL2CeBxT4jtJ+LxYb6=BNxNMGinpgD_HYH5gGxOP-45Q2OncqQ@mail.gmail.com>
References: <20260324154342.156640-1-pfalcato@suse.de>
	<CAL2CeBxT4jtJ+LxYb6=BNxNMGinpgD_HYH5gGxOP-45Q2OncqQ@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 490AA120013
X-Stat-Signature: 7oxd934grzo1ntwsgkm4y3wy93myrdaf
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774901197-719684
X-HE-Meta: U2FsdGVkX18RvqCl/6TKQkka6p2oZrhqa/HpRDKWuP8RgIrlLw7PhLRVy2jxCj9Pz/rsE0dA9HnZGPdtFrAZzqFTV3Xq1SV4X7bMkxVbL2bfVwRkW+2vCKSPHEOwdiuDCA7Vyd+B2LcicVZNLhH8oH2cg25THeMYzD2II7a0UzgqZIeX0VWEOyEb9sFMWoSHYgoODj0s0PP+QKpjd5P0wVJOyY82Yn9AQQtXCupL+saZO61AiFxR8+WIHBPQfF/HWA1Uo+uyEEGnOIw8Rq9vX+RimsKi8y3NPTzwA9aVDCpzquc/cnTR508hRRSdNBlGjCVHOMvsijTVYOly4m28NdPUQaZHKDPsAj/vhyaPPOfn78yScLCa1diSRXnR2Jl8yhO/KKSeJmMQF/Sd9qWSw1WRE20hI09+SVwKlK9Cr3xZKiowRTstx2LISDDb4cWC7n9V043uARFF9pJfiosO06gYtu4ezH/VX0nyV3M7/lNVuqIdXzcsy+Ff+Tmay0iT/ji4PeOd0huoy/0y6XzYJDaQhh1a2y2Afd5cAII49E6dEqTheToxgJxy+dICzrOKXAT0Ctn3gT5+Ip6Otzxelp9+YHEy2kdUnIt20xhptBjtP3UiX1NFqcacSVWsnXVISknRyeRUFPI/u6Jj/m7TNRfAHwbmaTzPVmTP7QqCRFprCU2jNnSwjg9WKgx6LUvq4D2ZVRVILXQL88MaE++IkMOk/sWq3Txl7M250UVNvmIFiKw7dsmrO73hThKsBBmIOYb0bPiWye/Weh/hO/CgQ2WbkkK0qF/1k1klmdXfEGOPgZtozExSQ8kbme6qA90gOy9jQdv7ni60/qcZ1/VRop14skOVl5mx2N8AA/GMLq3h9IX9BcJzteRZOK4QZ8ZljDC/YgtHNaT3X3gLSCaRFkeytWMTG70oNM9M7f54zsOVPK9LCCGcWs1Spm5FR8n8DIMwoj/ovx4xJp7Zcf5
 5GysmuCW
 ely2L+N229M96cCQl1FDUnfiuIKow9DVPqY+EjYK1TZMV/UIH2gQ+DCK5889icIeqWxCsOBnh/OfGeAWMLH//imwgqJ+GInhEGko3Z2ihyp2O+cXCwTX9cAZbkhLUaomnojBkK38LIdr6E/cmABBtkqt+QfMT8NWQJxyN1lSoGXaGLUmoXMgsUAXl3yPh6YPY+hhMagTlp7y++tuuW8yRXXUsISRgkxRWGDfAh1EqjwN5mCw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 30 Mar 2026 15:55:51 -0400 Luke Yang <luyang@redhat.com> wrote:

> Thanks for working on this. I just wanted to share that we've created a
> test kernel with your patches and tested on the following CPUs:
> 
> --- aarch64 ---
> Ampere Altra
> Ampere Altra Max
> 
> --- x86_64 ---
> AMD EPYC 7713
> AMD EPYC 7351
> AMD EPYC 7542
> AMD EPYC 7573X
> AMD EPYC 7702
> AMD EPYC 9754
> Intel Xeon Gold 6126
> Into Xeon Gold 6330
> Intel Xeon Gold 6530
> Intel Xeon Platinum 8351N
> Intel Core i7-6820HQ
> 
> --- ppc64le ---
> IBM Power 10
> 
> On average, we see improvements ranging from a minimum of 5% to a
> maximum of 55%, with most improvements showing around a 25% speed up in
> the libmicro/mprot_tw4m micro benchmark.

Thanks, that's nice.  I've added some of the above into the changelog
and I took the liberty of adding your Tested-by: to both patches.

fyi, regarding [2/2]: it's unclear to me whether the discussion with
David will result in any alterations.  If there's something I need to
it always helps to lmk ;)


