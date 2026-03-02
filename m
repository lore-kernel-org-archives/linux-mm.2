Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18482EB3632
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 21:45:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 858306B0088; Mon,  2 Mar 2026 16:45:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 835A86B014B; Mon,  2 Mar 2026 16:45:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76FFB6B014F; Mon,  2 Mar 2026 16:45:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 63E916B0088
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:45:13 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 06B051A0336
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:45:13 +0000 (UTC)
X-FDA: 84502454106.08.4DDFFE7
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf16.hostedemail.com (Postfix) with ESMTP id 22F8618000A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:45:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="SCHqyeE/";
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772487911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V4WxUh5g8+OtuoKfnpyLcdZy04/Kd4IDvozZUdWIikk=;
	b=r26XrZc261A6UKXJtFjNJzaCYnN63Nf1E8AE3JOA3zze6CRVKS4bc+Ci7UGSKb62Yk+01v
	4DY80NHrA97xZRb8mR7lLtEE+H9kjphNlRgNRlJ5dbyvvAGD7Pnz4gpzb7SIiNrOdo0JzQ
	KVjIvIaa3cDJQjvvzZezdFo3H3UXvvg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772487911; a=rsa-sha256;
	cv=none;
	b=0STFKeX8xFMYfIAIddsRLqvKhrVgEOSaxhxCUtwL+GzjGZqt0qKjCDmITQyj5EFIxOflIU
	SbwSaZI/2tUYfPAzRtYEURiVz7kfyI6uN3lo2E+5D9EDy5mZ3gZIMMqjPYq5lmDTNa8dEL
	58cJONwD9UOSiibXBqFRmx0sqtWFpVM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="SCHqyeE/";
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Mon, 2 Mar 2026 13:44:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772487907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V4WxUh5g8+OtuoKfnpyLcdZy04/Kd4IDvozZUdWIikk=;
	b=SCHqyeE/tPyvzoA1SLlP54HthcnNg/c9rnu6gHn/zlNneyp3iBrxobnchIsl5sb74vIB7f
	hixR2qFiJZpsaJtJZAycbSVZ4/n/CzS2biJFFQVpcw2ralrTz09yoI1ps0uTvAhJav4soh
	FdkBtS+4FymocN6MldxhT1o0rCwskBs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Johannes Weiner <jweiner@meta.com>
Subject: Re: [PATCH 2/5] mm: memcg: simplify objcg charge size and stock
 remainder math
Message-ID: <aaYEwmmn37q9Nl01@linux.dev>
References: <20260302195305.620713-1-hannes@cmpxchg.org>
 <20260302195305.620713-3-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302195305.620713-3-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 22F8618000A
X-Stat-Signature: g5jnu4fhmxiffjunoqnq5d3yquut7sa9
X-HE-Tag: 1772487910-304560
X-HE-Meta: U2FsdGVkX19JkM4G3u5zvQLlKluHFXhNwZi7DjlhsIEA0ZsEs0xtOXZC+Bxztrwmdzrys+k7MCZcYTu6qYz51v3mkdh/8sTQgzvkfJaspE4szLVu9fgrEx1uCpRYVu2Yf7kHN9cVO7vEiQuQxKzB3j8L3vjlagfiw/S1NqMfFKJA+osQyNUavAwkByjmddVvKPR845tsd3UWZyCyRuC2gsFQlFlNtgBKMJMngXBeHryJI1ag29OVc37fhTREm1f2ArdQyNsF89wXNtS0TqXio5AMopajb9P608xJzS472LE5bQkHR1U/+mbdwRtasyc80IG/e/sTiI3NY8q3ikdvHWW1ZriGbc0m5FNnGwkhSoobWu+z9GcOL0WdljPKStD+DhLfnAEwN+S06BfMvkHAtH9rFnK9QYGAI0ePoF/e+BVAiMnjXmByw+pcyVW3Q6nSy/FaqS4tyJ5klfAlug6v1vJxyWR2ebEgeqfbdpOfmMG9XJZGIdq5k6FXf2NOWIc66X5q0p1b1kuhmlYUsytTFGOQhCeP/ZUzUiCkUIH3RIxpKZUGmjgNv3H6yy69MHHo+mmsgDpacoIe7vc0OetmY4jTZ1Glvufq+O4+c2LP9VbOQaJ0yIfY5L6tq6piYEpNRSLLKUaPUlsn+ISvANxnLN6um1KSabk9U9or4m5Up9zbMNcbyzzWlc8NZBajVi/qSArPq2s4F0A2rgKdXh5E4+i4/mAf0HvvzgAwuHeGPF0vEQobCmjL41dL2GI4S/DRvemZBt+dp317NfWBwUmrIn/2tuwENGYv3Hapv9wV8Q19MaCUgwtY1CzrhtwZvHl5seQX7TyZ7vOFD+IC4Ce/OHRSoztwUU1TLjzHRZzZWh1uHEAsCZ5B2FRvtiZm9VjiXwRZ1DHuAfyZVN0TNJm2K4nDxh9xZKaQt8vcuvbNA3js6OYU1aYybmjHuTYNs8twNSAbcZY0buXS+r1a+Rl
 f7RCXNpl
 2XBT0NcWTjBvqLr8NZR9NHv8i8TBfemGR+ogVqqBBz3tLNo3VWLnsQIVQe4d2yd7ZJFHiQtM1Cy6lZL8nlCgXTz6hlSLX4AS3w3SrMIQyx9bg6G/HGdBmsKBiq0CGRPEfjlMMbNa3CAddsAEafPytfS4Jwt6S+o099W4gtPJ6dlLr/GVx8iJqlA+cu0+jGDz3nKJXXtGsrGYtZbf3V0vN44xvAKcKJH3ydxnRaXkJGiRLuxKUoi50gZhK8AK5ixFZUgZRWuWOsU6aw0CSP8JwUVXDk8ABkeL0uck60PfR3YsqEOfucRfcFNEdX1RAK5SELcfBjTPoQ+knESl/1Jp+dxYpocsjSb6vaQVS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 02:50:15PM -0500, Johannes Weiner wrote:
> From: Johannes Weiner <jweiner@meta.com>
> 
> Use PAGE_ALIGN() and a more natural cache remainder calculation.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

