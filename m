Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 520BBCA6019
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 15:43:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 015956B008A; Fri,  9 Oct 2026 11:43:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F09C46B008C; Fri,  9 Oct 2026 11:43:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF7A16B0092; Fri,  9 Oct 2026 11:43:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B1A106B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:43:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 32C951C3AB8
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 15:43:24 +0000 (UTC)
X-FDA: 85303507128.17.B9BB29C
Received: from flow-a1-smtp.messagingengine.com (flow-a1-smtp.messagingengine.com [103.168.172.136])
	by imf30.hostedemail.com (Postfix) with ESMTP id 26FD180006
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 15:43:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=s-joshi.in header.s=fm1 header.b=XEpP0FrT;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=ikIvuA3m;
	spf=pass (imf30.hostedemail.com: domain of suhaas@s-joshi.in designates 103.168.172.136 as permitted sender) smtp.mailfrom=suhaas@s-joshi.in;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791560602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Aj9UrRCfC4ORX2AFQFmPC/gxe5C/DS1Ye4qCAs4zrbs=;
	b=bhj6W5VSbvb5/k7N3zjQSs3lyyE5DO1aPFflTB+JiSOvaISTyQ7gWm+sT4Bwwz3hIWxRu7
	y3hLslLDabikDOUK5fTxUQpNpxp3+MctX8nBqmPkO4a9Tflk6PzYnXcVlbkJoFazZuBYbq
	IVQ6manpWPm29njZAvYn0bjRO5rOe6M=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=s-joshi.in header.s=fm1 header.b=XEpP0FrT;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=ikIvuA3m;
	spf=pass (imf30.hostedemail.com: domain of suhaas@s-joshi.in designates 103.168.172.136 as permitted sender) smtp.mailfrom=suhaas@s-joshi.in;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791560602;
	b=nYGWfRO6VJ4df+JvkMx2LCOGpqvavxCp1LPifNBJJ3dzbCDjifFu3VjXxaxZgPI8mYtwTn
	FqKKFV67gylzoKHkSZbdvEI8loTanX2iqp55N+GCL5gHr0PFNZ+m+wSoFO3pfGgSlNTzlU
	aXHC0qlyQnQ7FDhYejhTDYKPcR5+dx0=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.phl.internal (Postfix) with ESMTP id 815361380241
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:43:21 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Fri, 09 Oct 2026 11:43:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=s-joshi.in; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1791560601; x=1791564201; bh=Aj9UrRCfC4
	ORX2AFQFmPC/gxe5C/DS1Ye4qCAs4zrbs=; b=XEpP0FrTvsyVazMOrGNZCze8Lr
	D8L0HSl58HpSMe/0h18dGudr9nURdzkjdh2fXW+aWpVxPygxndaj5kai/BIYIjUO
	HIsxLwJmqJm4B9fiBWhCgvIXA959KVm4Oik8X2iVvWMgj/22Ik4Dcsz1MVnHVaaJ
	iTeMsbAevoKlKnUQAeTDexN0aXGz42yHjo4ZmCb7SM6FJAgxsYLHZVA4ul3J/0jf
	SS2iLlNon+ldOW+2qrqUW2weg6/SeC8675Iiu/uJMmbRerh1oI89m8eDR4kn1+vu
	5OabcQDd2IEucDoP3JjWyKLHxCs8bLgwD5WVg/teBvAqbvbJqG5q3HU8Vu1Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1791560601; x=1791564201; bh=Aj9UrRCfC4ORX2AFQFmPC/gxe5C/DS1Ye4q
	CAs4zrbs=; b=ikIvuA3mQ4svYeCPUw1+tNupADyvkcshehblvPl2qv74+zv0Eyl
	lpTOqb9tPTmDdFi7dt+ACjKpHnkvnKkpJjTg5mbrVqYZVOx95Na/JeanGDaMR/VW
	AAQ5STnKIVtQiR+FxXEv2edmqDcSr/mvzi7gU6VVd3B78l5iJAJ4Q4+Gg0Oy9VzY
	e7XUmrZVpEZbolRvWVd59YPCQgZoNkpe5+E5rqDwxxhgOu8PwL8iKGEzBD2u0ziC
	AbATnJxmzrAYLMCoicYVKXGq0fHNeVxdNeUNH6hMGygGGkU2d4vxETDqUbj2OE5N
	9p6m8s9yFm/X3lgh2J/+LPnZSQSRbNWHzjA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=s-joshi.in a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791560601; d=s-joshi.in;
	mf=PHN1aGFhc0BzLWpvc2hpLmluPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:eK7T7dn9x8nkfGSSx7mSytgOs5P8dboe4oC6+z52GkPdvtw
	XO78vuXfKpUhuHUIj09WUCgsYbsB5cG03Uw1MUYEcYDwX7aOqqrGI+ukWwbL3O82
	HoQPPNWmM3X+jXPX9YWqV3+pxKfB5xQ2jPeiJB6za3mNb+6E8kJT6JyeNjWYuCDi
	7hxf2qxGOir1BCXlWCi1RS+XDRZNfeZDoNptdwh57CNshyfPgHVEVVHOIX4vljYX
	rkdlhzDD50WeLIQcf/fUafYM41d5CzHV2hqNtkVJC+XPgAAheUjkz4AZRHhJmrUY
	e13he0l71tFi5i3MioJQoQAevF7eotEwlnA4caA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:WJq6pW7ABN48eZYcW6c9nITdcUioh3s5dQ3/0wXPO+s=:DDehand84XTzijPnsTs+htwcV1Cmbb757Dl1EsmDkMQ=;
X-ME-Sender: <xms:mQvJar3akoFrwUKVFGaWiXDlCosFL1Kv4FW7DXYTAnznSyL27Lek4Q>
    <xme:mQvJakJQlvrmp4bD00JhVOrXdhrdVCLZ78SKbkZb4pqUbZUv42r0gYhYlAtzzzBzd
    Q7xxHsmSuR871teV0YKWi_ubjlRwFWJxnaHcJwcwhc0BAfMeN3bL74>
X-ME-Received: <xmr:mQvJarzTzWoqsMs3JIg5kPLSAhwUhObEPYZkuWTXdiFxPQDP_Zw5PEhogg>
X-ME-Proxy-Cause: dmFkZTFP7n4MPUnav3RdIK8H+A+dtxAAXt54vCBIuraeho5WQfeHByTBT4IoaCUtoZhKA9
    xRkgW2ggkExRiY6WPzL2eFX0GkcilCgd2QDboVrZyWPyd5MJncixOoXLA1lp6y+HBajQdU
    zhaYlpnPaQo1g5zFuxvR0o+RMlkOdfpWW9wEG4jqDPRYMbBNYwH5EfY4f1Nz3ehijk10UO
    MHIWoFTu64o2yWqgiHhwJUXO4h8feE//Z3IR6OfFq9QKNxKi1T1hobVl09aJaYDM8DIDY5
    kJI53e2lzHheXiW26gCW5ak2cBIT75HD8GGUWJGHfr6mQFymG43KpLZHWyKHIRaQTFG1nl
    ebrATdBiF8dGTwXUTEpJL+zTIZ8XRyk2fDc+I+CXsKtDplEvlL36LgyKU31RTVw2zSjGQ0
    kB66tXK1EMVeN9fiFVOoC9fk5/+iapTOtMN1/gradK6kQP2/Pdsu4BUI0C54CcOu78LQ0K
    YpoYKeRGYCLFxSFh0ztbPvErhiBrsoITf6QrqdTOArtsqs1YD94UcUPd0lx4PAIqxvJ3X1
    hZL0RpazTnYySYOnijA3YvnJ+4GY/MSNkn3rHUFY1vudZhtMG0aqSPPSX5IaEYP2PUcwCY
    nf9QS6bIvxZMSEc23UKO4VG6Sa+/MY6tRqOPcsWPUU5anbo6LYwXfuEQ3F5A
X-ME-Proxy: <xmx:mQvJaiUKly3qoJANb6WNl-0R9g7vpE7NA-CG4HgpQkrbYvXHLne4pw>
    <xmx:mQvJarhNFSDFgUJIHr651imzPsCgMYB_W3X5J03TxJA8qVqO_yol2g>
    <xmx:mQvJaiCFbndnjjqzg6qKS0LfXRhZzbadkSgXixOkMRX-VR-Q4vefZw>
    <xmx:mQvJahv9Z8en6FZGqn1AKDS9DK2MdE2tQjrLqUhHN4lksl16LwZLkA>
    <xmx:mQvJarQLDfnQvrga8cNkxX3qbq3dp5BWGtJkd5hsNVmfXSgAbCh0DFjQ>
Feedback-ID: ia9504abf:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 9 Oct 2026 11:43:19 -0400 (EDT)
Date: Fri, 9 Oct 2026 21:13:17 +0530
From: Suhaas Joshi <suhaas@s-joshi.in>
To: SJ Park <sj@kernel.org>
Cc: akpm@linux-foundation.org, aethernet65535@gmail.com, 
	oe-kbuild-all@lists.linux.dev, damon@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm/damon/core: Copy only installed probe in
 damon_split_region_at()
Message-ID: <askIjMr06hNDZpMo@fedora>
References: <202610091039.fhMXCn7d-lkp@intel.com>
 <20261009082154.42336-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261009082154.42336-1-sj@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 26FD180006
X-Stat-Signature: 4ej9csmad59gy8mtke6n6d6958c9ip4e
X-HE-Tag: 1791560602-449638
X-HE-Meta: U2FsdGVkX18OnCqNJfW82orlWGHBEZbUI3gmyHzrtgXLtF8Slw0KA0FznXii00ej+DoPNuoxq5gI6f7ztim9IBuBN69Mx6jIDFAqq/xJ4dn6DwBMavLkkO9SLE11GzNeMcDQ3AYJRI0z8v8wTqvQ+C/VvBEYB+cY3mSA7YwDs91XJDCaL+HjH7dqpeAOf2JoTyCDPP88UUCfqX89Q4Vu+wr8avvERj+706GoUFQTz+SWTHUE+6WkdCuXzhcELFT9Ydp0k5P94LQ4B4GrOYVtc89pez8i/0cpyStCBA3cfBJEXhs/yyzfoESUHZdIFjPR6F0EjohSKTqGA2bt6DrspvwzvsPmFGFTWf9rDNrzx3Husv1qG2leZz3Ybi2YnVXKSgfXcuNwi9cG84MEpQUSq/9cp13dUnyJHzmWUEphJj2hW1jPJrRBcFNWKbsbTRnC9zhBdQMRhx4IXP/5Lve3kC4V+IMh1zjq+aCBtBACIKOG5PodASeHuOWzuCGKhRZBqk6xq+ZkYzgn7m3nrevZT/t/vyS2VaeSW8BHPmPXPqMXdwPrLop4H6Tz+ltFIouGXAUnGtSxSIYHmgLzw4DUShqL61h9LBOvdv3tovm5flY6K2jBv9DVIz7t9pJcm0AsgoT5lFDBEjHYZX18m7qxp6ajBq80iupTWdqIE2db6orAf+lP1NF7W+JgvLgeJjj9AdZ+OIRZkGng6Tg3KqPRijLWzH2FXZd8nzD/Jo+elXLl3kspcGiLvlpm7OUWJx2tJrgbgSbmr6vSNYSdQnab2SMjx1zzz8Wm7x74mdUnWrW53Nv8H725fdyypavtNf+QKqo5zwH2095IS/CRAbnz6vjONwZIhf/LPSYXAAq3AGhchc4LgMtyzVfjmHBg0ckVWgGSOhfNPtLHz1EjI9f/9tUJE/kcu9vhM6MIgbHmQ86eGndBBMXWpSBG87iENJDx0i/NoYF+LFoi67P9+De
 vzYI+exk
 ZyMqZPAgA9dXYcg52XUHddZhvoIQZ9aSoOo5c7tK2u7aCIAzYEfsG5Mb8Cqf43DyXFvf2z9Xg2iU2/Po4TIcTKEqHCMmz0wz4Cv9NCXMSvbH4ogQQYsJCmHfNqXAkaQkHS3TJHyMT5kUvHlD1jMFZ3xZNdnhcdul+WYmi77cwqX70vcARG9R7vDfv7utOOlg0tKjJyluBQ+/bUbAOSeSprQKejXxRQ0faMBimKi/z9MJUVKnfsB+gUJrlPhgHp3gMewjVNeOYVw5flEl+1QtmgsVEBF+EqjOos1P6rMwm7eP34wW4ZfEt3fliXi7JKrGYUAPR2PNOHebAmi2Qb1Qwls7deaKfQcZoIXikXO7m9F9uYI1BH7+UssHpmNadHw0Zs/K3lr3HmiJEXufBvwMIo0/Ccsc9BXKf0IEO6eK47NELCVN4/MIZ6GItNLgcYmJDIf1tKPcfGXxlkkbrVmRMh/jeRCPHMv0nMtDs5H2teCm5MNq6ab+eiwIixQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 09, 2026 at 01:21:54AM -0700, SJ Park wrote:
> Hi Suhaas,
> 
> On Fri, 9 Oct 2026 10:40:07 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > Hi Suhaas,
> > 
> > kernel test robot noticed the following build errors:
> 
> Could you please check if this is a real problem of your patch?
> 
Hi SJ,

Yes, this seems to be a problem. Liew's patch [0] was merged recently,
after I started developing off mm-new. So I didn't catch this in my testing.

I will rebase, fix this up along with your other comments, and send out a v3
by tomorrow.

[0] https://lore.kernel.org/damon/20261006065209.41507-4-sj@kernel.org/

Thanks
Suhaas Joshi

> 
> Thanks,
> SJ
> 
> [...]

