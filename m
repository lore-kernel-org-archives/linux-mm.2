Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA3FFCD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 16:03:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 485406B0005; Fri,  5 Jun 2026 12:03:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45CD86B008C; Fri,  5 Jun 2026 12:03:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3733F6B0092; Fri,  5 Jun 2026 12:03:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 25A126B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:03:46 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AFBBC1C0A43
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:03:45 +0000 (UTC)
X-FDA: 84846329610.05.29C911B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id DD0BC180007
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:03:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Py9Da7bT;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780675424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=roZAnLwQ9BEqqeMeoQFTVZt5nX54bJK1OXfH2IvS9F8=;
	b=ITCH9WMRa0BpW+ndMPWWdkR8PEl+xxN+/sxzaqEx3mQghthWaPsXLE2jDeU7dBWuBF0kip
	E4B03ojufh3cgm/Nb9+mHgqMr1wryMZDS7QPkbmUROgbgtrdH4ck8vVSexnp9g+S5aQPuk
	11w8lW6z2DiTYlKpXhfbAzl8c2tzzfA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Py9Da7bT;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780675424;
	b=djl+0biqRzdKZXsD4m95H7MZsPNj3W6chUbmvekUOssDHcr93ZWNDZdlxT2SP8SxgY3VnT
	Q9l6dptub65iXbk+aHEwAfn7zOkZ+uBBTNqgbK5n0jsRXVMC6794zYAsopU4oYcdph2tv3
	mvTx1aV8Zgt+GAKoSKNsuBzaE12J8hw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F892405FD;
	Fri,  5 Jun 2026 16:03:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F561F00893;
	Fri,  5 Jun 2026 16:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780675422;
	bh=roZAnLwQ9BEqqeMeoQFTVZt5nX54bJK1OXfH2IvS9F8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Py9Da7bTXqUU6SwKwVDf8FVJLiwGSDxNCdKxB2R4NWJKpa0xIeNtbsjfQePIWG5k+
	 8RCZ2zoH6zJKdBkPDQfxoxZUUzyS8Ln3QEtQA5fer6SHgdaWHECqKrIbpj0ukXf+jW
	 xchegXrgiXKsLhbEyz6tNsNpGmirsQnXc57QU7W7QMJn+pte+zsHGIIejFMzMvEWve
	 qqiq3wRIF6fcJ43TofT7L0Jth1YuzYhMYF5dsXederePgbOMU4sxjN5xxTmmnFDTNf
	 1QptNC9M3N6wIVMNGK+lYvO4dUzRGpKvTyGT5ZxNuvOOZZ1O+WKWOlahYJMZJ1m126
	 egxApwRA3uNsA==
Message-ID: <253b529c-273e-4346-91ae-823c8313c31c@kernel.org>
Date: Fri, 5 Jun 2026 18:03:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 3/6] MAINTAINERS: add myself as reviewer for rmap
 section
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org
Cc: chengming.zhou@linux.dev, hughd@google.com, wang.yaxin@zte.com.cn,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ljs@kernel.org,
 corbet@lwn.net
References: <20260530170624912AfpqJafVKV2Xmz1EPfHH2@zte.com.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260530170624912AfpqJafVKV2Xmz1EPfHH2@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DD0BC180007
X-Stat-Signature: jdg97w7wfm67bh4ssq7cwhmhcwarf9ap
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780675423-606757
X-HE-Meta: U2FsdGVkX18S5w3ecHzFIyoxUGkREDZ/SBKUWKo5KTQXZVr4KBD3w1WvwWtv2IM56zcQEqscHeiSkc0hOuEokZlRl487W4Apx36l5oHol3Gjg/NbMvv5IKI2473Zok4C4KgEbPDrQn4xBECG6A2aaS208OsHFIAzy/pwr4ax/5Phbvt8xpmczurwIieRTBKEg69mjhewiED9se4fGk2Cmas29SFLzV4xFpEqkdr+mm5pVDcWmxU4SwDLJOcoXZKvQT5PqF390G79XjiuAS0VfLQD76pnP/4jDhR2vE0sFjeSG1L9U2U3Ds2GeeSIJRLZE6rLP92Q8Mgp0YS0zj00rR0Zs6uXbRzcSTl+lwjZR2I1Hsg14ZVG+Ic+p2z5vhQsL7hV5UU1E6le2CuGugZYQOYluZei7fqHtrsD/14K4QXHaPZthRKte0TBZynsMyq3V8ljovE92VNytYDqjpG7g4AXGMJ6rjJVtIwKYrX347FkSeE2NM6j2vZg4Ph05c9VlXp52qIBBSWSZc3JML1Ca9REydm/Z0i8QgyO7EZ6EPv5iTThJ+x0q4rAkTfokMFrmvcE/q4x/E1jVXsh02zdB/ejq4GnKBzLbK3XUJl/IyebYOFSnNxBP0gKZ4eiRVQdNdQkAJhyCYLY365Avhw/0v75MRjbvq8HXAF2NPNh+7mBpW519naZ30jPz2ilBNv1uaEhkyLjuAxV2Dq4530P9uoHTQkHEXCxCR6tCEVkOcMf4ail+gj2yWv1OeF3MnwV0h2BDTJ6uHWRHaJ47g3b8cFsED2xRUJI81QN9vzHf1ZNuODdg0Jnasx6Xojd5CU5gNrLtUxzgjDt9IsU/oYhK3Xoe3AzTGOS3IlEUphU+Oil3it3Sh6Y9uj2wzDojxtQND1IlpXqzekf2JuXa/d5pRo/r1i4YXDE1ROeWrfNd3uYPWjDllp+PtUSti2G7uJKPOZVkzrDRiLg1W13c8I
 VUdHutp9
 Y3tWmsu0ng6EI5bXZ0U/nSKdSj902ikslnuvgn/XHKfA7wEZq+phPPpsuEYMW/98vm3fx/cMAJmF2Y5ZQQuTWMVeB+0Lsgzb2EfjjKF7GLSfV2NuZjWoZVCo7MizEhqDNVZrvTBhkP6d1a8V5YUR3/QUtdyb0FH9dqkdn/zJxKlJKCfzsdene5irrDQXeUAYX5Cf8Jf0F3N0sX7tHIvjE4WvOZcZIy3h32JJD52+cKdf541peOI6dXiYFaggTciWTW0BrYStbE91TILNm6a5pU/ype8Ln5QpnV4qkLDsXQBriBhJTMWMSPUYOSOA6s4klHcPr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/30/26 11:06, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> To help review future changes related to rmap tracing and testing,
> add myself as a reviewer (R:) for the rmap entry, and also update
> the file patterns to include:
> 
>  - include/trace/events/rmap.h
>  - tools/testing/rmap/rmap_benchmark.c
> 
> Signed-off-by: Xu Xin <xu.xin16@zte.com.cn>
> ---

We always appreciate more review and I am happy that you want to do more review
officially in the rmap space!

However, before we add you as a trusted and reliable source for rmap review, I
suggest you first engage more in rmap review, and provide tags.

Thanks!

-- 
Cheers,

David

