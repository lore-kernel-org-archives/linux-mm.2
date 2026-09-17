Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6F70C982D6
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 15:30:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D073B6B0096; Thu, 17 Sep 2026 11:30:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDFF46B0098; Thu, 17 Sep 2026 11:30:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF5796B0099; Thu, 17 Sep 2026 11:30:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8CDB06B0096
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:30:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2555F1A03D2
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:30:14 +0000 (UTC)
X-FDA: 85223640348.27.8493113
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 58F6A160014
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:30:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sj1m3QF5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sj1m3QF5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789659012;
	b=LGLz9QIrfi9TaIc1GyPyNeu/IebDWdiIO14h1LkXWE2emUiVWC/Zr2GfoCLL9BUnXWgOvq
	fLWN9n8VNdd0tDV1/8i5JGswCJg+TjA5w+8Fube51ccrfX0KimnR/Ug54wT8JREwp7neen
	dab8XVMfaATkkth5op0SobYtIu4PHWs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789659012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xa9FPId/Lya7JMaN4dMhVb0KsDluGo2C+s62v2mCeD4=;
	b=tb7uvsNrwP1h1gtA1jI9jooOqA3nVpnGlFTWhloXL5tgAVpf6eAGU7S5DpGckQBBXRTvaD
	oijTC6h9YHe1nxbMoDK+9X98yadmioi7jI67Eu+cj9Jm8eCzhhwJsRnU5XdpyG8VmYKNBT
	BzSE5LobRfFF955DSpEcr9Gqyif6yHs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E639260211;
	Thu, 17 Sep 2026 15:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BBF11F008A5;
	Thu, 17 Sep 2026 15:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789659011;
	bh=xa9FPId/Lya7JMaN4dMhVb0KsDluGo2C+s62v2mCeD4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Sj1m3QF5fXQa1Yeeeo+dj9Z1YRZ7CqLS9BoSuoPsFGK1Vcqq98//oj8x5AH3sofQx
	 NEXle6uQH3Wr4Jt9Z1H0at2lWU8MrKsNIc3jQropnVENc07EoXqB0qMR1h1Q+MBlhd
	 o8lvZDclxzuvjt+iVhzyceCprpV5oUHn09QMyOdCT4DJg/QTsODxw5GHYYPAoadzMJ
	 Nv6ZybHGsdON3UIlQNNzkYhi196I5+sly9HzAfaq9oYuohktoXW00ZNn0OZj4cxOsl
	 5l2UO5y0i6eFvwsk2C+zYArATkHQ2Vm5mqCnYAlO6hhrxHhhS5PegdjV4Y+fh8GeZj
	 c57ZCeL1X2YPA==
Message-ID: <dffdbca2-1ba8-492d-b7c0-be749ce8149d@kernel.org>
Date: Thu, 17 Sep 2026 17:30:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab/for-next-fixes] MAINTAINERS: update slab.git URL
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport
 <rppt@kernel.org>, linux-kernel@vger.kernel.org, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
References: <20260917-maint-slab-git-v1-1-d21a5210aec9@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260917-maint-slab-git-v1-1-d21a5210aec9@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 58F6A160014
X-Stat-Signature: x76xbjxoc5oogyrfn67ot3sdp3wkz6bx
X-Rspamd-Server: rspam01
X-HE-Tag: 1789659012-582077
X-HE-Meta: U2FsdGVkX19GlMUnvUP0FyZxeYYeYQvSfW2DvdPWsZNi3yXxtAWDWTG0PUV6d2j7ysLpW2k6uBOAdsV6N+GCuNERx+68yFbDHYN3sF98hjKHHohG/REA9ZSNK2yZuAmejrQv3Kqjg0hdtbSUT/EyjDT9r8UMFTGb4hP2mXNzr7Ku3zQoHnPzqsFF/BL2g5uBakXqUEuhrKEakU7pg4N0eM5DkfjTv1clobikFwXGjZE8F8EO4NDlmIbVrpd/+KVbR7P9UuPyg1XaGaNSwByU7YkG5Hn3j7O4I+nQ0BY+NEe5OSPekG0czMURyJ5VJchZyOVrQW1H2oEh44xWZWz2oITqqZuDZZWODfVUwPb+435Kibx10dRonFm0QJdYRt9zBTmArZedsKB4DQb8UFzE2zpAglXHQXnLsTgkt3YSUaAbxetUsN1TcGfim34NALUoET2TfmF1C7pvB5iQqmCr+ek/5R7JLRlkXLv+B+34MTcx139xg1UyWbw+D+XbfVVvOaty32YPlX3xh3Z5kBKrQbk1aLc8ko61TEB5qvL1neMT6SMVqGkOhrq0lmxQZ8jAnh91YNtmIyc7tX/2ZYTgqZx37cIW0Jz9ndj0vD7htTpLfaFzoqFFLUUzvhjAqCZnC7Y1sSJ/uZJmrELWWIgajGlrEHfImTTL7OwC4AHINLL1LqBENiP5xgo8xfTrkQ8p8QkiPLqw+tOfCzBpqnCerrq66DblKx4zcxLzR2E4+N0JBEI4IngOEHQ9BAThXAr2ZY5MeHMSYfCBO14h/jdI0FJCBR++H8sF5xE2P+7MctjIithFCiNeTyuJBD9w3KZYEq7XxDrlJvWvSaiQBaJ5pj/WQqEL/DJvsIrJUgdLWQvUgG21yFMuzTGgAbcZwlCxJZSq3E/i8/Ivv13B/fiOTqQZxlH239lmxOB//9DnTZUhiQ2a5hh19zn/hLIgpTSN+ssWT+biUfa1WaCuauy
 pHpfz6Q1
 O8iavIzHgXbcirFKsScKwyivGZa8ZOoDDjiS7ZvMgQBzk6oezi8V45+8F/c5CepvSSIGR1+M75svmnw1GL4p1gUDALDT4PDNydzMi93WWzj6jwA35Pah1wISApZXoacgqdt5vjU+iolWBAM6yvWHnl9qi1e85IxgDTCwuaVUA5FhyjspQol9xyHqsR7rPRLq5aZ5sGRJ5RVfvHthQ/gWJlSg+acFemCN4nEUxrlaEOfvRuefgMLIlfgGXYLkrVtcTy73YA5EeGvy4HLC4G9FZXT+v34gseL34j6+8ri+wQAD+vduHSCDcyFPsDaMS1W9+kRAb0gxByFZ0bFpD1YGY4sDmIFCkIC6gSniSBIvj405uGhQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 16:38, Vlastimil Babka (SUSE) wrote:
> The slab.git tree has been moved to a new URL as part of the mm-next
> integration. Reflect this in MAINTAINERS as well. The old URL will stay
> around with historical branches and tags.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
> Since Harry as a co-maintainer now also has RW access to the new tree,
> we agreed that he would apply this patch to test the access.
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3a19da74d00c..f9c1aa1df9b9 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -25186,7 +25186,7 @@ R:	David Rientjes <rientjes@google.com>
>  R:	Roman Gushchin <roman.gushchin@linux.dev>
>  L:	linux-mm@kvack.org
>  S:	Maintained
> -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/slab.git
>  F:	Documentation/admin-guide/mm/slab.rst
>  F:	Documentation/mm/slab.rst
>  F:	include/linux/mempool.h

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

-- 
Cheers,

David

