Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBE50C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 10:20:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0D766B009F; Tue, 21 Jul 2026 06:20:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE4A46B00A3; Tue, 21 Jul 2026 06:20:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD4A26B00A5; Tue, 21 Jul 2026 06:20:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 869866B009F
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:20:21 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 123111C0752
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:20:21 +0000 (UTC)
X-FDA: 85012389042.27.1B6471B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 44E3880004
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:20:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LH2Gn/tS";
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784629219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A9wRHEKwv+WdwFijMYO9/GWWMxwCr4GTDiWIhHFElFQ=;
	b=V9gxr8w0LqDAMjpsxD3894zeHtOX01At+eS0jVUdeXOzggZ3S1TtQ3x/PLQvqy2ntK3qiR
	nWPQdcki9WisK7bsDTaP5TVsQMgoEEr5+Mpa7uRgondpwz7IdVQE/555AoT2hXg7dJP27X
	B7ks4LmYOn8H3/QEIpqep1025K2xElk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LH2Gn/tS";
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784629219;
	b=F8KtybbJ8D+tjxvNLX5SlKTXWZtbj83blzFw10U0CdabhllkY4lmdZColcXRUc2c7a8cpb
	2TvyfCgMzVsf45ejCUPRiGmHbwYPxaNTv/yfbLDtQmBbvmFud1y3Q56EldifyhDWRZWUd+
	aWv7G9iTiwg0RUi7KkSVtLj1IoyQQds=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 93B6A41A75;
	Tue, 21 Jul 2026 10:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19AF21F00A3A;
	Tue, 21 Jul 2026 10:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784629218;
	bh=A9wRHEKwv+WdwFijMYO9/GWWMxwCr4GTDiWIhHFElFQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LH2Gn/tSDjmt0o/rxLzdRUzmR/X+9XO7/lkR4rZcqBhJoe6dg7SIelJtk/NI2fUMW
	 TP4JarZF/p96LnvNGm5xE79+Jrq6awPLZzM7qmC2O6i54tuOZXpnuaVMs9OEswiJUP
	 NRPaD9dZf9nX2PdG5QrWsOrhPqwiPfMl83chC6/CcoLz+9MlQu7ZsJfeFwcK1C1s01
	 4tjxx66KAunQHXbe2HTdYsoKFFtPhilJN+UKM7bQGs3fjvGGwi+4zYZmNEVVSBRBdR
	 npGOQTJucOq8R4QBqEQn5R46mPEIQx/PlLEdFrrGLm7ymMFSzy5ea8Ge68NMvNNWfM
	 pClVDWgTdDXpw==
Message-ID: <681e178c-f7d6-4b1a-a060-6ca7ff7d3419@kernel.org>
Date: Tue, 21 Jul 2026 12:20:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: update Nico Pache's email address
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: npache@redhat.com
References: <20260721101811.115954-1-nico.pache@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260721101811.115954-1-nico.pache@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 44E3880004
X-Rspam-User: 
X-Stat-Signature: 4w7kys5ti34gcsoko1hzyryr7kt4s83u
X-Rspamd-Server: rspam04
X-HE-Tag: 1784629219-467449
X-HE-Meta: U2FsdGVkX1+yCXIltogPopnKL9NvijEl7rgsAJL+NXnmgKIDdB7AtrJ56x2bRQY2AGlv2MRwsCIhPqq7YvBsUJbXca/L6KdGfemNyWwwwBQQ+r+6UloFl1fsS0kJyqDk3c9UpC4psmLP9rbkyemcDGGiWfBmzHUTA/9Hs4RX0l4LbHJ6egjcPGLbKU0l4Wm13h+jPE+Z58h1v1b8THLQ4DachPgEw8Ihmw2G7TSybC8q+p66OwfXibqKipDwejdz002JjkYl4DLaixJMlmDHXvkEFbKDiueZBb/WjwvLAV/hb8tQOJ5NsL51WOyzHYUTUao7DRrmgY8uo48dH+XpjzDFezSgMKA4dBBeW0sbBaeS5LPai9OFsufj2uU6iSDeDkI1b8LVPymfXeop7zv8+B3AfKbszRTpVg2bFFF5VmZpQyxSdgcn9eqHVH3ji+rqX+sOTF1ByzmhXniXe9S0q4hyOWfJDq29o8In7e5Vfd7nSaJ9Pq3sMdnP8HGNZmyToQvz/N9YpB+Jrvw+5CbsCI9SI/qj6rz5qaXwwBCp1SCs/Kckud1LgI6B8e4mVeiFD9d1Tqz7GrmBqmnbPHhNwfrgqWFBOCwVkdDJcEdaIQh+dlFZBjyS4YG362HK7rekJ5U1LJ84EQY2f9VYuTA91AYUddiUR4PzkMpmfLcrLr/ONdbN1Q9WYaLC3hkl63oVyxqEKU3NnOI9Iouis865twu+v6qIWCp/Iuq4oUV91WAMvxmS4lzcD8MS4Eu4f2eXugUOlSqt2Ds5wgXadKEEV+7ftTaIHoIj029bcjC2BIlpVPc4GqVdYx+M/Jv+Dai1Cxs/ScYeGr2rzzGK0V+K6s6vqcDzaOBRYGrxv+IiSK7PhpccPrAHTNnn5ayv/9b8z2F8qKsnH7yhLI+aFrENbzCYC+G8ZZLfYoogkZ0wo4WegDUtzNSo1Km4E4wtpGjZHLxolBlUIWoCaCL+uow
 4sQKR94O
 9DQdJPxZynXZQNBAuZMJ+Bg28q5FbKEa9rtsnjW4NLPJpE4PUhnebS2+vcTPUqFNqhWubo576ttyAAyQBXdjZ/tQonXhFm31U0htGfuPRB4efZLjI0+IrSqx8S9QP3wKumhoFliUy8E3RbYA4mJo5ne1W1l2wPueKszw7dTxwFXlK3vFv1f9Wq62+0sUYR5i8SE9oV9Z6HMJrddmHB0ulzFn4WEiikmmtYTgvokyPfD2wkJ0U3PAsM2thiptZ9Z78QzSSgOf+PRrEZsoLLI8Tlpb8ixL7oc9EDoRuwZsyMiBhvAKjaEbpDpjuUsSEv7FG68pd9ZcFPesArDU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/21/26 12:18, Nico Pache (Red Hat) wrote:
> Switch my entry in MAINTAINERS and .mailmap to my @linux.dev email address
> 
> Signed-off-by: Nico Pache <npache@redhat.com>
> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

