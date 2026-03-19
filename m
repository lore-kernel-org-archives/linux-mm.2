Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BFF21075279
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 08:52:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E58746B0440; Thu, 19 Mar 2026 04:52:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E09936B0442; Thu, 19 Mar 2026 04:52:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF8856B0443; Thu, 19 Mar 2026 04:52:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BDF6F6B0440
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 04:52:21 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7112A160406
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:52:21 +0000 (UTC)
X-FDA: 84562196082.29.CEDA80B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 992271C0003
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:52:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iq8fqK7y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773910339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+CBhGCmCPvSek4nKMfxP0QZO3qvNTGdua0oZRYNKNTw=;
	b=q4ZPaiSqdjlhz+tuuUqK3YF23aRjvp2DvckkZExx+Y4dDrsu23ss2XeH4TWOmJ3IZT//c9
	wRncr6jrvUcpy/eZ7dpjGPIPSQ9AvgBK+IDWqu9t7lJWnLaMN7UNiJLEAlK3rRrmuMkOmw
	fQoJAD4mpESdFROhR+hAELKlsloN3sg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iq8fqK7y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773910339; a=rsa-sha256;
	cv=none;
	b=hGfVG9i/0mcM+xtrC2qdH6mK5C57qVzCW4YugDSwG+YMx/KJns/GoQUpuIoNz3q1BcCuy/
	cUToMfcDfjgDlsSM50jwFcaJK2uH3RM0DwDYWx1JmfAvFgiy2SNlgGzpHDKA2lS951xj1j
	1jQwfZohZn3LHTZ2ptgyHyMiR/HzaR4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9DD5742A12;
	Thu, 19 Mar 2026 08:52:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9946C19424;
	Thu, 19 Mar 2026 08:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773910338;
	bh=KjTih1mV7xhDt8AoXAzz2WdUR6gzCkgsXYJPv8aWXHA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iq8fqK7yyUYa4xk2bNEcjetDuYfbZKAW0SGBJeEEK/oJUh3k5l6MBI2DqqQ9wvg3C
	 R3GaHiP01BQp3WWD4/ypw6uHwsQ5fNDNiUalsHnq+eLNyC0AHlrc2S5y5yLXh0oOUH
	 FhDCikRdQrbEQEHR217aLmbH2F/jfJ0Qlo0NlIwwh2wtBC/5Bmq099Tse81KcnwRc+
	 2rUvtlEVwCE7Z9WdeRvEeU1v5p+n1l5krvsgwxnH65GyovXMzeGICEaQTCcqaCQFKb
	 zxFzIjLzmFDvxGIh5oApqNdfrZH9jZArGnWImuzgpif65DyQdzl/8Rsb3CPWBRC+pf
	 6Vj8YluhC73Sw==
Message-ID: <502c7928-5d60-41e3-b93d-37244d4b2443@kernel.org>
Date: Thu, 19 Mar 2026 09:52:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/7] mm: switch THP shrinker to list_lru
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry.ahmed@linux.dev>,
 Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Dave Chinner <david@fromorbit.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
 <dc95cd21-8e7e-4903-b337-03f2a39e256e@lucifer.local>
 <absnshL4E4iXSC1y@cmpxchg.org>
 <06625acf-ee08-45ee-bdbf-5a3157df0468@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <06625acf-ee08-45ee-bdbf-5a3157df0468@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 992271C0003
X-Stat-Signature: xshcn67tijt6y49t1skhgdacqq5t4r9o
X-Rspam-User: 
X-HE-Tag: 1773910339-250647
X-HE-Meta: U2FsdGVkX1/h0q24K5lb3Ku2EmxbaVnootUCJChxj2JlJ/r7/SGV7InDMRjgPen1u2LHQv1e9RAtyCgH+DALCSs9cx40BKDT895rbiQBzVxm3yWU3uQTxTWnlxvBehduqHq4zCwtIN8h/06XfXba4FjPDS3uc3ZZXxNcxPdzAbeKlriiGHeQn6jxg8Y0Ggs/qtzaNjCObJCwHw41ClZ5AKYAEt/hGh8YdFtCqzhqOQNb6C0rNhT0WcekCqx4oAZgSpYWKMBPqxsHySFtcm2Tf2TQyb089ZhcwwGTmiW/kG/rcev0lRXebLZ9yunYfA8sDhNdj4uwMFj6Yshv1N0loCePmUwAYqQDYBl4zq3Tt74lqMKUp3f6UXnGjMD1op3J8vZDrhTvbSyHWH7lSpFTXpmBliuonl7GBFlesox2bbRHfD25zdJ3y2/fEnO/RMDieutw0sdshT58V56iXsv2yw0rPMYnWga/jvU6HqGW0g7AAh4xG5BnJIAE3XsoBfCXlqtu02pkJGvP7xeO7CO3Qp11qrA6Vm4++s4a3Qk/yusDIYFoi3DI8OQK0xTP9gFi1O59EkG9iyOiG56vcOqTVcg8v/QnT4fnPAHvTM57e1ho9SuOCgZZUCZZ2hsK4u76kq6EmIrVXGHC8vKBHVnpRzJqqY26rKGFIrFzrGc/8ra45RhTGi8ejAiDZlwnFoHUWUMa27uVqHw198HY/kg/+Fn/+AaQ9KX3q3YoV4mkJjHg2BHxEeXvZyaO1vfg35ShQeGVkY7hLCe0BECCHpAJShKtIhVJcgN7ofGrHBzLInbGtNLdVeVhBQkpqgmXC/KWl5ZR66PG67gHVZjYM6VoaT3wFywNHSW8vHTEhfw6VeamlCT+NkfLzcNYTm/fze5XMYH0NuJmFWwSNwGwJq3DCj4ZHm+hOhZeXooN5iaTuyI8/AZewbnE/Eh5s7Ns9nM1ekWeRg5ZJISlvfbee8B
 F+4CD+hW
 2pndFEDBllBJca/rfINzmXbE8olHDZqD36RyHrV9tGM+mNlIXBaPTKgXWKr1ZV4hvL4WQ991/3Yk3tC3KglwAmSScivjKOaFYPjGfUu0QeF9abKyMWO+00yOZJaX0HJdrYJpIFTiX2vlPZaG7L8h9ylNtZE5UpCRJxOIlbvspjHotZ2Kyb+WrO3PPxlhTCkfCYGPRjj3S0JsrERf89hD8a9K4Jl5tZ0zuT+KzvWn9yDOjI6ssBP2plF37UG6pEblghH4kZWK+ghmn2pLp7sa1/mFx4am7mWmeLywxGB5pfxaTYGl1++2MvaVrDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> TL;DR - anyway, I think get_maintainer.pl --nogit (and trim anyone who
> isn't listed as a maintainer or reviewer) is the right balance to take -
> maintainers with screwed up email set ups (*cough* naming no names
> beginning with L and ending with orenzo) and reviewers who have signed up
> for lots of mail I think are totally fine to always send to.

On some simplistic changes (e.g., simple function rename) I sometimes
drop the Reviewers of subsystems because the simplistic changes are
mostly just as information to maintainers that there might be conflicts.

That helped in the past to reduce the CC lists on series that touch many
archs / subsystems.

-- 
Cheers,

David

