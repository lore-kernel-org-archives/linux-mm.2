Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D98ECA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 18:43:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDCD58E012D; Thu, 18 Sep 2025 14:43:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB42E8E00F6; Thu, 18 Sep 2025 14:43:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF0C68E012D; Thu, 18 Sep 2025 14:43:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BC71A8E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:43:32 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6F2A0B812B
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 18:43:32 +0000 (UTC)
X-FDA: 83903244264.01.F542939
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2B999A0017
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 18:43:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=O9EVDpf5
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758221010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=liLJhgZknOFrb3ADlwKcsc/J07rUAwg/dZtDpx06Vic=;
	b=CyThT5WV0NsQc6sBIYWtjHU1FIX0eZEtK7xTT9wNkiqKRLXp9DeoGOYQuGwPHyGR3gxBl9
	zGNptEXA4xKenXGG2HfKDXFjZRu6LX6mLRpgaJdWdvAKg9V2Q7kH/2wzEKCrvcrFBk823E
	GAEsJZ4K0Zp8F1zfN8WKiKaHqsgJL3w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758221010; a=rsa-sha256;
	cv=none;
	b=oFMrZsS1ZH+yd1gyJmDdDxQZTmfgR1NrSJ6tnoeT1hDNvmlISj1rfqifoxfisqn5L2AMMp
	ogsVtru5y3esaMB+E3M2dEBXAojo+1S9Tz164kEEjidxqoNsGZbFZK8BdiTTz2s0OvDFYM
	bcadBVvb/dOzbVt3nQL7YfBa1CYwhXU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=O9EVDpf5;
	spf=none (imf15.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=liLJhgZknOFrb3ADlwKcsc/J07rUAwg/dZtDpx06Vic=; b=O9EVDpf5g7zgd/J126cLkxpokq
	67CZ2pUYtUpJvmRk+WYzJi4DRPy27TOexm3lqamKDUh9IAlUGC03Lo2+0dFCanLLcxE4Mq1PqYmfD
	zsG861c8Yr5xX5D52wzOhnO9imrDSEtHEzBeBr7ShxCDXCN7KUWzGlLz5OtEM/SgQI+7R701O6suA
	cqJ61q2nppVq1TNR9wmWEcUpWFM/p7f1YIhX+ZAp278XRRDKeWyKepe8MLKNd1KkIFXmrisE/qJNF
	AeU2q6OwccURPflquwzeQOYrJnhz8Z3QCRMH4kKvxK1qifV6WvifJnGULJgOXEDIPW+XnTMdlRxk4
	KPFtZ1jw==;
Received: from [50.53.25.54] (helo=[192.168.254.17])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzJbK-00000000t2F-3Pb9;
	Thu, 18 Sep 2025 18:43:26 +0000
Message-ID: <be6e146b-3429-4264-bf04-2ea15957f010@infradead.org>
Date: Thu, 18 Sep 2025 11:43:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v3 09/16] genirq/irqdesc: Have nr_irqs as non-static
To: Eugen Hristev <eugen.hristev@linaro.org>,
 Thomas Gleixner <tglx@linutronix.de>, David Hildenbrand <david@redhat.com>,
 linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, andersson@kernel.org, pmladek@suse.com, corbet@lwn.net,
 mhocko@suse.com
Cc: tudor.ambarus@linaro.org, mukesh.ojha@oss.qualcomm.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 jonechou@google.com, rostedt@goodmis.org, linux-doc@vger.kernel.org,
 devicetree@vger.kernel.org
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
 <20250912150855.2901211-10-eugen.hristev@linaro.org> <87cy7q9k8y.ffs@tglx>
 <87a52u9jyl.ffs@tglx> <8df2cf28-c15e-4692-a127-6a5c966a965e@linaro.org>
 <2bd45749-e483-45ea-9c55-74c5ba15b012@redhat.com> <87v7lh891c.ffs@tglx>
 <95ff36c2-284a-46ba-984b-a3286402ebf8@redhat.com>
 <24d6a51d-f5f8-44d7-94cb-58b71ebf473a@linaro.org>
 <7f4aa4c6-7b77-422b-9f7a-d01530c54bff@redhat.com> <87segk9az5.ffs@tglx>
 <f8d3c2d4-8399-4169-8527-3c87922f2ef1@redhat.com> <87jz1w88zq.ffs@tglx>
 <c3ab4a21-183f-495a-b3b5-cc74b392eebc@linaro.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <c3ab4a21-183f-495a-b3b5-cc74b392eebc@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qfmqy4rwkb9j1akzox4ds8dyggcr7gxn
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B999A0017
X-Rspamd-Server: rspam10
X-HE-Tag: 1758221009-405044
X-HE-Meta: U2FsdGVkX1/d0jmpHXHAsIRbOuKx5zIwAEMw91EvbLu4j7Ja7+NUwpsRYIic8a5xZOft5Re2U5fu1gPR4EZ/zBZgd0LoZ7xRLCyYDqM/k8MxLJLs5rDFXTOfgVUz3+QiYCQGWtjpXUPPGfF5/Re65uJbBgoFxW22lKNa6i31Eub4UhElEKFQtEWmm1baxpF6ekS5WZy7Ha3YvTjSny5aJoJMC0GsC0Z0Djwu7Nhukcdra04FidCOEDLmXgsKvkNHeUpr9W14l8520UU+ZlVdcKAikNPKZC+cR7AOnCByt3el1CMV0NDpBVj3YOcAokypufY78ZL6Yh70flirubFXRr0UwpTtNmhXbUVBhGhnB7bkfW2X7T2LolOXgPO8z53h70DA8qLgmptdxJiOgMWyhBMvkHaw7xIa5bNOGxCgKa1tOruipklu6MqeluAsVY/+7Q6or+vpKEznO3LZKgM9JQkFOex9Dmn3YPbwqVyfqrlWYAmG1GEuBvErQlxMz4PIhgaXpR9sRFUIIW53cQjKiDOC3LBKEkwm7u3LOjuRD/Kl0vVweiFLh7y96AC/+TCfdeLMssRheRAknLBS2wrImvqtn73c+u5pqRFUiuVtEeUTiZuE/UnU/V9e3v4llA2E+FcSwMXnwWfTzlyW8eF5p4yO7QfKHCTWDV6W3WFiVK4APPsBUipeCWJLcI0RlapGu4pn0ddV/h0XnpUqzZmz8bTfLelaRcV7ccuFaMdKm0plJVIdMtk4ujQczDB43F5O2YyNa+i2TEF5OTWeWZnwF4yIYbFPfk6A3FlfWDfuWlZMKNGUxS3pGROk0no9Uqo+EQm2v8b1h8l1lwuhWWuSsR6J3SfpZUYEu6CMnyR5SMG0+x44MfgJD7hq5Idm3D4eKWncaAha2hmqbZ/w1eZkACYXuDG7lUtHcglnwb0TjanihbOyQuwDx1JCH3qfvOMJ+sfr5/NwYFlIMGaSpLf
 0/Kqd8Ns
 gBkOmSW2g2xYHgnY/en4ixk2bQ6hy9eROzPjiysfjt87x8lcsv9FvfZYsUoj3hzqR6Bxyz3Q/IQKS4Qxz+8HqxNLkpXUlOtFKrgo3OjV0DrH68K3CgKmV8W2PUF2dprML3ABDOavYksadbTLbv0OcXqKn7x4smtlZSobm1wXKk4Ho20Ao7PhR9aG8yH5g5h9h3bDnJsyVjl5YWJvUhI+WAYClcVFq6dOBPuFuDSa58qloHY8G9A71NY42t8b1SyWHQemZYKaX6r1mP/Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/18/25 6:53 AM, Eugen Hristev wrote:
> 
> 
> So, one direction to follow from this discussion is to have the
> inspection entry and inspection table for all these entries.
> Now, one burning question open for debate, is, should this reside into mm ?
> mm/inspect.h would have to define the inspection entry struct, and some
> macros to help everyone add an inspection entry.
> E.g. INSPECTION_ENTRY(my ptr, my size);
> and this would be used all over the kernel wherever folks want to
> register something.
> Now the second part is, where to keep all the inspection drivers ?
> Would it make sense to have mm/inspection/inspection_helpers.h which
> would keep the table start/end, some macros to traverse the tables, and
> this would be included by the inspection drivers.
> inspection drivers would then probe via any mechanism, and tap into the
> inspection table.

Surely someone wants to inspect more than mm/ variables.
I prefer kernel/inspect/ etc.

> I am thinking that my model with a single backend can be enhanced by
> allowing any inspection driver to access it. And further on, each
> inspection driver would register a notifier to be called when an entry
> is being created or not. This would mean N possible drivers connected to
> the table at the same time. ( if that would make sense...)
> Would it make sense for pstore to have an inspection driver that would
> be connected here to get different kinds of stuff ?
> Would it make sense to have some debugfs driver that would just expose
> to user space different regions ? Perhaps something similar with
> /proc/kcore but not the whole kernel memory rather only the exposed
> inspection entries.
> Now, for the dynamic memory, e.g. memblock_alloc and friends ,
> would it be interesting to have a flag e.g. MEMBLOCK_INSPECT, that would
> be used when calling it, and in the background, this would request an
> inspection_entry being created ? Or it makes more sense to call some
> function like inspect_register as a different call directly at the
> allocation point ?
> 
> Feel free to throw your opinion at each of the above.
> Thanks for helping out !

In general I like the way that this is going.
Thanks to all of you for this discussion.

-- 
~Randy


