Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB667C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 13:14:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19A296B009B; Mon, 14 Sep 2026 09:14:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14C5A6B009D; Mon, 14 Sep 2026 09:14:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03C066B009E; Mon, 14 Sep 2026 09:14:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D91056B009B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:14:27 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3E799160139
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:14:27 +0000 (UTC)
X-FDA: 85212411774.17.59F1D5F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7780F80002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:14:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PhuLvABD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789391665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mg65sQYISbsc6y7xV5HAfG8679PrSCSCwP75uEHGxBU=;
	b=c4Ao1lcK3+myfKkWM+meKK7cuoEJZF/ffTBmRLCj1LLbBsMQWZmV2gjTHmR64HaH5nqsJD
	8PM3KQ1oLxdb1X4o/3f/IFiQ1tWtr/G0w8hlqewTMIM4hbQMpiJfJ5h7znvQw17hqnHliA
	xa0cln9OiAZ7NMHCc8W6Cwb53lCs6UM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789391665;
	b=FRrYXf2mDmrcApiu4aycbwq8r/fl2m+R+6JwqGNf2HkQdTG/bHjUYnbY28Iv1vRgp/0tZs
	e2ROWFB5GOvG+zhPOxDgZGmT7YyKmFP9La4TpbpLo4Vh52ICkG7NGOQQ8QM+AxajJDjlmE
	YuSiuVQDw3+/RBv1XOeEGb7fYjsxRJU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PhuLvABD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CF288429F3;
	Mon, 14 Sep 2026 13:14:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD061F000FF;
	Mon, 14 Sep 2026 13:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789391664;
	bh=Mg65sQYISbsc6y7xV5HAfG8679PrSCSCwP75uEHGxBU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PhuLvABDdh6gVR9eE3ikwDgvdiwZ29gA6RyqDBBm13X4hKERVRaqy5W5w2bpzPY7m
	 2e5SgXRCywW3cMgkz+T3Cm3pZohRqA0pF1GQlJa8gT7QsjfEG68ix0Fk2fOr69rgTU
	 4gMvbm8e7B2rNF4lV/Ad3oZ5NFnCmiKt0SACK4jqzJi3Bq7D/jwswLxUSy+FikcyFF
	 xzeSx50rmEnsLP7CCkaiiritAgRvLTyFHy7dpZASZVK+M5w8Y3xlLio/xXhhdGQK8F
	 jAEv8WodNU4D2abpuc4mCCiZsJfhM+clJJoEHAvtFV1Noy/ovZDrvK+VQUNhFK9Fx6
	 qI7Z/uh7MenrA==
Message-ID: <d717f781-0c13-429f-a8df-ee7e59a2fb56@kernel.org>
Date: Mon, 14 Sep 2026 15:14:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] md: Remove the last use of page_buffers()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-raid@vger.kernel.org, linux-mm@kvack.org
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
 <20260914041830.2072626-3-willy@infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260914041830.2072626-3-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7780F80002
X-Stat-Signature: oicoa469q7ozujyzz5s9r7bcask4t5c6
X-HE-Tag: 1789391665-644342
X-HE-Meta: U2FsdGVkX1/j/9SxKPoJIygx6jaD+aQwqZEVnoQc05fOXB1Px5Hv5r554jyQ1s73drXNOlppeW7XbXodxX4FSJsTRFsrutOmEpF3nhWeIHIFJ/ip7FL03U56gK/pIkHsbgPJe4vOkn5+cTp7eEDVY41mw+iwmPbXF5Bdse2g1mt7a74r2ZaoiEQmkF9UODJbEcx6X/k1N4NU8Y7M82iNeJomf7YRQW18ymioM+uKzzQCfaKznKx1Q0cMhnjdgq7D0GVpdt14a57YwwrV+Yga+S0EKg9sWc5nG1B115JfN5+QPJ+vnMrMKBtlGqBP0hNKboyz7kYot7CIrYgWcB+kaMQjvIoWRIMyB683GkxPU6aNG0sj9q8R31F5NK2ANLcBymtW2vsdDbqqcXycdUkGYus8gwMDALMSWeumLdh6htRDJsPJ1MvE+q0HX/o2BHanCHyL0NfHziEtxZYYNIUppefoRdVWo64JByMONqfs/chObnNlXmEu6fV3ypyTpgZlM7/ycdhUDRmnnXUI7a0PDHAYDS1O1kMyfdbslELGpkPmmoy/J/JnWNZaUQIIuwfqmrUXYn2ih3wKuvx0KXv7/2cJpI+n+RJLsTc+tUcRvU47fqsYh+OojUJkT/ZPNisSHARPXJKK/d6vHf21p4wcWzDxpzElUl4tZt4OBL+xMEzap5EH4dM6qvp0Wbx72XbOWtWHUcW1y0XOpYQBOR2PD5A57LNIt/UrjYTvR3izc8AfqPUQfP2OBuaJhtLxffbrc6Ifx1IsUGbLlLqsU/FGKE3ZcYyaOHeBs4Lx5quZAXr/38GabJJWypdlH+EY7qFitqUN1Bo6sJyc3Z6qUffKdELfFBgKOtJyFGx08SLQ3pnHhZLPUly5QplHOSm6bDqS/mHb0UIotJAsyEqzcykC27Lh+uwKx24nRJkxzpnHmdpxIWxaNiuS4seMMhbpA4AP7q59jMKEaHKWD+llug+
 pknsz2zD
 A75cjiknziDtzFNPaYtih8sCvrbm7sFJvjy4YSoIypSiuEagf3K2j6N6H4YX/gGfKBWyBD0bIeR00gAm9NMjr3J64gZOk8/tbSqjARU9V1r46Dg0Lilpkemm4v2KwON2JrrFhNK1daHdAUSctY7sFqaFPXi8CsTZU7t7bJkEY/bZYtkc1a7fIn82qTKlr80MuNafKm/nYUiPQ9+hA+Co2NxDtHDZ+zipdneS7ArHliTlVIF0CFPh6ejslC1RxyvJ3Rgr/hJnA0i0RCPHzG4Bi0u52PT9NTVSTpW5SZAz5rns8+CgKP7G63WgEs4MTJDLOhR728WPh6ZeNpqdt4zXHLJkrhAMV1CIujpVoIr1MruZB2dfE6tc3uf6LatddnzOsxUAYSxDh4FX/1bE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 06:18, Matthew Wilcox (Oracle) wrote:
> Convert the page to a folio and use folio_buffers() instead.  This
> does introduce one extra call to compound_head(), but will simplify a
> later conversion of md-bitmap to use folios instead of pages.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

