Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1B23CD3436
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 10:51:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFB326B0005; Wed,  6 May 2026 06:51:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAC186B0088; Wed,  6 May 2026 06:51:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC16E6B008A; Wed,  6 May 2026 06:51:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B57566B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 06:51:13 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2F9518708F
	for <linux-mm@kvack.org>; Wed,  6 May 2026 10:51:13 +0000 (UTC)
X-FDA: 84736678026.16.D85CF29
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7473C1A000C
	for <linux-mm@kvack.org>; Wed,  6 May 2026 10:51:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=kusQ4HiX;
	spf=pass (imf19.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778064671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zI1hkKPltBSit8ayPUyw9h14Py8v3FaTivUchg53AOk=;
	b=i93PtF2gMw3Ww86IW1AnCCru5Agy3m3i/NFUBJTBSS9fM8KrcetVMda0hH0P2DDBvQw6Yc
	0GbVml1sraNgpo9orOznZiUeTNNZzcLdOlda/+t3C6lrIp6CaQ1xsz2zQ1h+WuK3wyGmEg
	+2J3bFG2BHo1h6K696pQZ/v+BtgoQeg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778064671; a=rsa-sha256;
	cv=none;
	b=rwTt5q4n3Y7h+8vA+lJRYQkfMS3GBbQgcR0EBhvjKIN+M0zUBh0z6uLRYHDearwelvy9PZ
	l/35+NfuecBe2irxZcCncGqGpftqGIVqMJUNnRID6vPAIZC50P+HyjPQICGHIxY7lQi6V8
	fdKs+ZZSHB8Os/A+3v6gAOKvWBT7mko=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=kusQ4HiX;
	spf=pass (imf19.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1241)
	id 426CB20B7165; Wed,  6 May 2026 03:51:07 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 426CB20B7165
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1778064667;
	bh=zI1hkKPltBSit8ayPUyw9h14Py8v3FaTivUchg53AOk=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=kusQ4HiXykMA/hgSWJLc6Y6vhxd5FVAOx8aSWJkOpeZ8HHGv6PHywmCKwhIlkxB+G
	 5Pu0NXOhpsiTJLLLjzY7ZyeBpX+wUa18e3yr7w620v0FHQBTvxyvYL6Yo1K9pmrj5f
	 cQKs6VAZwvmPQrPR56XFYdvHowJNq1Qe25fCBUJU=
Received: from localhost (localhost [127.0.0.1])
	by linux.microsoft.com (Postfix) with ESMTP id 404A430705A3;
	Wed,  6 May 2026 03:51:07 -0700 (PDT)
Date: Wed, 6 May 2026 03:51:07 -0700 (PDT)
From: Jork Loeser <jloeser@linux.microsoft.com>
To: Pratyush Yadav <pratyush@kernel.org>
cc: Mike Rapoport <rppt@kernel.org>, 
    Pasha Tatashin <pasha.tatashin@soleen.com>, 
    Alexander Graf <graf@amazon.com>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
    Andrew Morton <akpm@linux-foundation.org>, Jason Miu <jasonmiu@google.com>, 
    kexec@lists.infradead.org, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/12] kho: add kho_radix_init_tree()
In-Reply-To: <20260429133928.850721-9-pratyush@kernel.org>
Message-ID: <e5e9c15f-a030-423e-de79-757c20d084e1@linux.microsoft.com>
References: <20260429133928.850721-1-pratyush@kernel.org> <20260429133928.850721-9-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7473C1A000C
X-Stat-Signature: khps6zgyu79rsbe4cxkber3nbjhi4tto
X-Rspam-User: 
X-HE-Tag: 1778064671-424382
X-HE-Meta: U2FsdGVkX1+zXmJD7vY1meTc/IBSqqG+9vFVfBiXTtLnIdwa/8JAGUDcptcm0w557vMEvJrYqMGWFRVrKPhtqNcId/FuaX0TOKeXQvD5lHcKrN43RDdrGXrodAXCcMEfo23qnvYFInogkRvvU4b32UD7S6pufj5zTgpUkIdzti39J6mi2XCHqqB9gSbgAFIiVHOVnct8VJgElexJ/viOSMQyM1X30ghMC1fBhdTF7FY3rATepcdBL0wEBPClpdddgVoTBdpDvxOzaFivj947CbQv0NF0jVI0HjtBH2E55QvwtmQqUtEVlvNP44SIWIER6+xQ5SMm4eozXJxj0zWTrW4mkuC9/1eIfrrPJlAZv72sCuyZKyXeJRzMmeuAMSy3TtGWI1QuBGj6EH6rpexNDoBCV+3b5J/uuff4dm7FcavQKwRsx3gVh5MvTRXQUuP0AzTpZWOmP+ik54EaXyUlyqdWBMNrnfwskNLcrLAacAMybHeuueDxF6Ctz5hgRa1OaHXGx8M8DDCV188QUt3gPZ0x7RI5wKgwS9cEdO4hAbgiNy4fsnOFt2H3J57fjcKOBcv6FEWYyNVzWAPz8+FmQBS1hFvCY5q4NYdSB2tewrrYBcEsV4VvuyQUu/0GS1K1AFIleqi/8oj2KadoxsoHVPalAEXLcixpFmSCq/Efe3havEb4evSgCZ+zU+OTGs42W9pS/UKE3N2j/JE0Y5/EdhmsUYeJ3Y54W9H6O8Cgb5VwJwXF5wwgdYG7tVrrfRZaejMq8vNzpxPlCeGGKkkKXM9nlMfaPpZjeh4vgxoiTkjeY7T5AeylgBv9ABGaQRWdhOkZB60+muemkJiQpiuvf9TIgS8ETOISeb/LFrX/DF9a2bFffLy9p6P0MxwScD5zRXJ363nG8o+VwwqXV0s1yaBCi5CAf0qn4yaRR+RKeAnOWhMPVL6I0YY9Zwn5l1hZPJHpO+1Wi5HMghpXUlj
 UmzjbPCG
 udhmMz4oLj6HI3nUwngTtvjqxpY+WN+FeulxJFlsMMh6TkvKz4/3359lF93qili8Io3W4zGIs6KoF09jrRN3H3NLN9Z+oz1JBm3+/iGqay43L7DVra8SKsDyTTzHoIhzxV54mkzRv9kMWfRdLKKcjqz9zNrO0N+XDnQkFPMHdz7F0BTt2/C0Fj6EsD10y8bnrI5pAtumbsrFhN5soYxU0uXguOUA7pR9Nm9s+TPGcAmnTWJUbYhHuWsfOz7/pzkaWzPrOE+AfXSr4jFv6y83GOruMbIunr22YTUdskGwXmyesLbtTi2VBYyKbvqeqGIbtmTiNwZCjfkGQxkJWFI3a22vqLDCMnMdV2psn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Apr 2026, Pratyush Yadav wrote:

> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>
> Move the initialization logic of the radix tree into
> kho_radix_init_tree() instead of having users open-code it. Makes the
> boundaries cleaner and reduces code duplication when a new user of the
> radix tree will be added in a future commit.

Consider using kho_radix_init_tree() in kho_init() as well. This will also 
remove the kzalloc() one-off use. Similar for kho_radix_destroy_tree().

Best,
Jork

