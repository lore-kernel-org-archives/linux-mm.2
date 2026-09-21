Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E413DC982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 12:03:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E549F6B00C7; Mon, 21 Sep 2026 08:03:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2C2A6B00D7; Mon, 21 Sep 2026 08:03:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D694A6B00D9; Mon, 21 Sep 2026 08:03:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B824D6B00C7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:03:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B82341C06CD
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:03:23 +0000 (UTC)
X-FDA: 85237634286.23.6201B69
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 24FAD1C0004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:03:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gg+fJKlx;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789992202;
	b=CI1LsjiaMXtI9XqCTpvMMZyHLwpcCFrXs0IBtXg6+qe23BPs3FibpsrOG3CcR9YNnhwkek
	HYzzr9Lla2qnRQRY3HusbL9KBOtlqu5QNAoZsdrawVAoKAD4pn1winFDJq2UwR8IUAyvxL
	PiC2a/qMFCvPEmgxvT+C0Y5rxZFEyVQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gg+fJKlx;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789992202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZSkmJtXL7WUnfY0TRuru1PuhPDtpUorFFaCq4i0ogiM=;
	b=kIvfXWn3js/vdZ7aWr1fI43cq2dZH+Ah4mkHr3i2CCUI7PXim3oll2ZXiWcBaoPNr2Oa87
	EnnjybZrK/M1QlHzLfR5z+f6vAjDjiezIyJ0V4jUewW5ta0ncc2NRPREVLvZqNlXhEBXWv
	Y8LDjuVQ/BQCMUrtvDe6OisBVOL9Ofk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 96D0D6021A;
	Mon, 21 Sep 2026 12:03:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D732B1F000FF;
	Mon, 21 Sep 2026 12:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789992201;
	bh=ZSkmJtXL7WUnfY0TRuru1PuhPDtpUorFFaCq4i0ogiM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Gg+fJKlxBLTrl/SOVvdc/MFTvGp7WFSDmdkHklDMOKY5Ds45e6mpUkt0UR56r8bai
	 6tK8pPdYdyO7yTw2WypRtgizXItRBHvX8S5H/4PUCmfrL+w2kwhNnrsUrbCWNnm2JX
	 AO1ayb2mZTCxhcXx366fnkk3wGSjoLTwD7GEd2/gOmFFkm6Vz0MQuu4D7LKHkYzscE
	 ZZPoylgQzGxEBBG/05saCGEQ9j+vr3u6gfdBfbna/4cXG5pPqEPmtQB0hPuAFVrVDb
	 grxsWteKBuVUYGn9WYJTsHiS38ExMjy6pj//h3C89EHqSjWHfoKBxCDTcyQMxqsFcg
	 mcT8HuHdMzjDQ==
Date: Mon, 21 Sep 2026 13:03:19 +0100
From: Harry Yoo <harry@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	Pedro Falcato <pfalcato@suse.de>, Kuniyuki Iwashima <kuniyu@google.com>, 
	linux-hardening@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jason Xing <kerneljasonxing@gmail.com>, =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>, 
	Jiayuan Chen <jiayuan.chen@linux.dev>, Willem de Bruijn <willemb@google.com>, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4 1/7] mm/slab: Mark the kmem_buckets_create() context
 as a Context: section
Message-ID: <arEcRFw3mQ6frlDq@thinkstation>
References: <20260921075811.too.775-kees@kernel.org>
 <20260921075820.1718334-1-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921075820.1718334-1-kees@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 24FAD1C0004
X-Stat-Signature: hk9s3xa81nsbwcnhb4j5zbay7qwj4ybk
X-HE-Tag: 1789992201-707897
X-HE-Meta: U2FsdGVkX1/6sCPPAdU4HGesvn+z3y58OSen0ng3YJzc1801T/fcQwSASlV+sPiOhErtZsRdnqA0uIA30gA1G6s2Y0LciHjvXP4QYF6i4LmTnXpJx080VAEzJB9genYeMy6nGBBVJCiVtjCXZZQf+0az3kyBEPYaVHUou2VQJxdp2urCWjYCud9uFMltCwyUdoR/rt84axUkRh+45ZxOG9dGQjYEFiky43zDKK5V0InGYAolJeMHOcbcJHHkQYt+o4iNu15ZdsEL57RmXZ2i/+UD4ZgOTHO3Lep3B0gMsce8cNDZLdTwWhv9e4KOd7QOmWoV5zJuM3ckA+2d283/+wfp1SmVE/XLEuQIPEfc7+8h8t0U6Ym0gL7LpgUyqhOEB2WsackSpPhXW7UCnF5jPweJvD8ofILT8R6yse07unngpjUVf2ZgL6gh9dmhe170/GHTIDG5gDlg3mP33pjOuUREBWMM4TC5a89YnMhqjghArq10ydrATZlt/1GANFvem0vQIosnR7tH188cpq3NgWSfgVbVzNBNZd79YjWho5X6KL+ycuunByP234jzOq7f8v1YAR8tCoC1DpYCgzSC4CZK5Ajn3PN/JVH3U3RxMp4F3S3DkYd338lQe+R6pe137pmPCYSSY0/XT7k2yd599fL6C2Jv3ERRq/chAIB1SjoS8wBOCmQ0SnS7YeTkFtYBDousoEOyb/FQvg7KGG8N7qFjTNoY/TAVNUclRczQcFz97hDIzWWv29eneBHBRDUy3HVspjU7IT//wBCn5EaGcMc1h1/ooKcHYHoJS8/UrqGf6GdPaHYoFLdQmqeqAal/DZJ29bqWEz9oOGJucG/6TfyUk+pfMXM7r+HQPAxnO4GYxcgE5JHdkvsJSv8SXwEgpPko2ls76qnpMTHfgLktiIuc8UYpomcVVIpdDMAOdK8eImLwX6ZLssKBk81eEK1mfS1kokU15m92441Hq1J
 J5kXqAjK
 VV8Omvy3TqQHPhAmNEPm8Q8hXW1Qw4CUEpmYi+aYcNeaMlHkOE5u/0b4e9ghHy1at3fHwjvD+LuLn5PJ1z2fgUkXiQacsP7u6hPdFCRSK1xmvUxdoLGat8/tlKvVC2HNc0wKIlEpmBEHy/7s0d4V8kC3xKLWgOK86Hz607afYGqf8hZ3MaOzQlfmNshdK3fxX6qMwOI5sMGDuY0NUp4KAv4DAa4lxoD9b/K45WgCnXb9twfgrRlSZ37SD+cOlbkrIbyrPtvdRbjl7fu3zC7hYMdalymZq58V3j5qLd/BkkE1timhZ/plc6mhij++XOTWA8Thp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 12:58:12AM -0700, Kees Cook wrote:
> kmem_buckets_create() had the same sentence about calling context as
> kmem_cache_create(), but lacked the "Context:" prefix, so kernel-doc
> rendered in the body instead of as a "context" section.
> 
> Give it the missing prefix. Additionally fix the "a interrupt" typo
> __kmem_cache_create_args() had.
> 
> Fixes: b32801d1255be ("mm/slab: Introduce kmem_buckets_create() and family")
> Assisted-by: LLM
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

