Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 386E0C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 12:10:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A2036B009B; Fri, 18 Sep 2026 08:10:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 552A76B009D; Fri, 18 Sep 2026 08:10:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4908F6B009E; Fri, 18 Sep 2026 08:10:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3211D6B009B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:10:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C7A6F1A062D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:10:32 +0000 (UTC)
X-FDA: 85226765904.11.A9C2429
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 158EC4000C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:10:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aYqeBaPG;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789733431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oDTrurI8Kvvvyc5Kv05BLsaZ29K35VenZR5mYeAgZOo=;
	b=lN5lVOwIR7N84Jy9kGQr5NDiQObnVjwHBC9Y8iP9/cx4HgO4ERMppJ0fBbsiyk7I6g7MAK
	BjObAjAn3w4+EjHT2lN5Y3YNKg8gXNRsweHIloSQrHTGsYw1hN4D8Gb8Jcy1EB+3NGBRxq
	XQGUgt8154OS4WNTIxZtEi0S+Q3G11I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789733431;
	b=uU5qxScNZapTTk1LnbTeCX/9jTQF0fJ5dyaQOhqiSP566WLaDEpPwmGCRJ7O5Ir/5q963L
	HRmF+Sf4CcOVUpMOTBvY9+c56GGfkYA+OXZd6zbSI8FZcWIFU9O/tM1NiQO58BO4SLUSer
	k3g8NAmggSG48MdSlWlb8qZmiLzhbeE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aYqeBaPG;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A92CA60A82;
	Fri, 18 Sep 2026 12:10:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C391F00893;
	Fri, 18 Sep 2026 12:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789733430;
	bh=oDTrurI8Kvvvyc5Kv05BLsaZ29K35VenZR5mYeAgZOo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aYqeBaPGqgVCnGwuvPdFvw4FhXEbUUqtYbbQ1q6O68WBT9JZr3v8eY9rDcdR5z7ML
	 Z+D8mfZHER3XEkF+maX6SJQscQnYViODMzgE7qSkeWhXDDaTAR55xudkDJDChUXdqU
	 8v/PQSZWtNzD6qNTYXskVAUbFIVzIExRbxH6MlhnLYG+PgtcwXLLUHG3sXTZguUsy7
	 pbBCf71M/La8BmXkY06KfvQU91hjFoATgQ8sEXsbgsrn49Ew7FN3K8kyEcjqQZKzyl
	 lxt3ihN4leANJDqLyupdfPF+EkREssxSJhpsuB1/VxNVTX+ZSD8ghMsE18qbqwnnpA
	 aH54W1ySAvXHA==
Message-ID: <96b917e7-0167-4650-9f04-b9821590bf92@kernel.org>
Date: Fri, 18 Sep 2026 14:10:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Constify arguments in default pxdp_get()
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org
References: <20260918064928.793742-1-anshuman.khandual@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260918064928.793742-1-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 158EC4000C
X-Stat-Signature: 73dutu543mojebfrpromn1kgsdb3ko3g
X-Rspam-User: 
X-HE-Tag: 1789733430-587835
X-HE-Meta: U2FsdGVkX1/d41lR9xl9TU7mdBBoBk/AFINKjQgJX9IIceeP/wgwmLr05YgXkelANahsYEugVJUxc9Uv4PTWqvbyqipTwSOrDWKQzsqO+iVn+Aomzqi5iNpqxQDatv2IJBAGYpwMG1ym71jc92/1+5jJhOs3xk1H617kYcMmEKgfr90TmxBfR6AGZlWjinc/yVkukTWRF6OLgA2ZJGwOx6i/v87mSefu3PNOfv8n1eER2xXpjQH1axWeiaVJfVbIQ2j1JfqSjVAtxJz3qMNwPHcwjS4MVUZOFfGfQEyrkYWU9JrRz5txmDTupr0LXoHF9AUjzXeqTRc3MabQVFGGxq/gVNc8622ZbC4CU8vulEtZEO/q4qF+/bjTCERx31FcGyjTi/ch184Pv5bF9UPdWeUnsjzTk96q7D+SL+XSNRS3aAR8ndYwCgPXDoF39yIPzhuzd9H72ENIcRqoFkA4c3ngqkefqaZqQct5r70NpoP9sl7vlanl+GEzt4qGLADHVRg7JRWhaS6ATEmRbxarWI/ZPFUFzmONoMn1j4sVrZ3v8jusnbpDigOi7mRBljrv/X9zmTOsHnnfMQpZYh69Ua41ig4ZNpipHBJg2nzNMjOAAbMKXEE2bpiOquFPcvbiBeB7eTOhsCAwgBJDjZEQHwpShTLwsyLgCwiI6/jXEj+Oa6oQqMB4zeAE24OEjGOH2eEDTQTkfAlL5JT7vQSQAyekhBthODX3otxMJp93RPRDMJqZbDDyQizJOyo8ar18A72AW3oFKIvTBuCUybCGIg7uhaVeqhWbKicqWSY3pwJFJ2ukpv0WYbFY+enKONyVqVAtxTfSfs5b0rq1LXmEMWCO74AE+1CFu4CL611nLxDY8S2V6eO4IPMZXKrmwYLw3K/KfW3HaxEcMCLz0PsnLGokbPGN6ikm1ovbIhhlh+A4RTSoWwP/8pbTsjdJ0/plQc5hijiOgz5b+YodKfA
 hYIb8M4X
 HcTOdyDhE0tWK32zDjqb1EmzD84IeLtLfya5WpKqi9CwFpcw1EcNpyQM4puTx3AddTYSKOJBzpT/JqSd9uSPdIBuol+lF5QWjwRfeDZA40mq+996IQl/DWCWN2XQZDsJpRrfGrxaDxRn5Uzfs9g9xvr+QFO9PJbjEPVtKd9O6/YppDhuFX/UaE6HqBpfZwGKhNwZFhbz9Q4iDcm4McCY5D0Op3iPXH3Q5JKByu0CRxMq0wY7VIO2HzcIJ/JqBygjpeZsV4WI1hXmgZ8x9bfezUExJc+Fnc5yseDi0S8qvhkl0/PnEqx9vnsPkjdpe3erSHjaAyL8maqpI4Ga0URjHhXzexX5DGJ6dHrIFaJpNzqTBEU/Plo+xAFAApEGU2aAqZOEOWZS4GvrlqQG2imOpF37lSXe8GZg2uoi3UUikWgm1Th6h7DAmlsE2nrJaTqT+aa/QeCke6z3VDJJQn09uOhlc6Xp9ry7GhkBw81/HzDI/b/cm9PLlYZzqOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/18/26 08:49, Anshuman Khandual wrote:
> Generic MM default pxdp_get() helpers fetch the values contained in pgtable
> entries via READ_ONCE() without modifying them. Just make their arguments
> explicitly 'const' for some additional protection.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

