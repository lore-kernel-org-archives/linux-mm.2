Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FE65C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 08:06:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 843E26B00B1; Wed, 12 Aug 2026 04:06:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F4D26B00B2; Wed, 12 Aug 2026 04:06:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70A596B00B3; Wed, 12 Aug 2026 04:06:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F7106B00B1
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 04:06:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D68AA1C09F4
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:06:04 +0000 (UTC)
X-FDA: 85091884248.29.70A7C90
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1543040008
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:06:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hx7cgyNj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786521963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wz+0S2JLAS1USmHbGnLB7ltd/z6oFwbV0RysCi3RDCU=;
	b=PFJZFbOFr3mNcUXgAn5tQga0DowA5G8ce15IQmvd55I7gjNjqzRXwO/BP16TUsCr9jBZKK
	/7BdyBtZ+v0o2IUslZJ4xaHcF0TtTTTif34A4bfVZWTn87odrOsZwJT1/U5GlUMBYkCXjs
	JDEtMUGVpOFOpOQH+nOdoGwMo8bPlRI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hx7cgyNj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786521963;
	b=g2yhxO1ad6iM4weNcrLTgirMIffLIhPAj6aJTCVb91/49SLKEWV7bLD8KpS+RjCRINtCbl
	XP9dkFjElR6QvwrSYjoLdzTbCk+Hq8xJ2A8h0LfF4jyM00yLPI89iRcO7YfG2HOy59nUvY
	HLyrEgpx+xrr2FixV0EQmL+2b73Z9bQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 55C8840549;
	Wed, 12 Aug 2026 08:06:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 133C11F000E9;
	Wed, 12 Aug 2026 08:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786521962;
	bh=Wz+0S2JLAS1USmHbGnLB7ltd/z6oFwbV0RysCi3RDCU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hx7cgyNjl8qUkffNIwDqSmIh551Evkh9G2b/fIDnAR3ugjwPWWihAjlbB3idk2Ikt
	 RGjxy8nCbDNgeiXPK2sVniAR0CnOIXWwzgx/qLaygKkyX6S8MTKnlsbOTaJzPfBVUW
	 SDMyVkPlBMSYY94HRBuRSwvfy9O2ev3bNaPPoPTzeO8tj2IYUpyRZcJYdf6yk3pwme
	 12C3UmpTlCDF75mhdbdlL/+dQA9kmtxuTjUwFOn0/GY3wybJ5OUEmOASY4lzR2ieXM
	 HBDFafKw8hSk5GTChYW2AJmfhsorCdbCUWwBuZ7R3BfhExjuSBV4Z7QvPItHFLGPOm
	 WA928az9S4EfA==
Message-ID: <011609c5-deea-43f2-a2c2-90f64053eb3a@kernel.org>
Date: Wed, 12 Aug 2026 10:05:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-hotfixes v2 2/2] mm/huge_memory: separate out
 CONFIG_PERSISTENT_HUGE_ZERO_FOLIO logic
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Pankaj Raghav <p.raghav@samsung.com>,
 Hannes Reinecke <hare@suse.de>, Hugh Dickins <hughd@google.com>,
 Yang Shi <shy828301@gmail.com>, Kiryl Shutsemau <kas@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hengbin Zhang <uqbarz@gmail.com>
References: <20260730-fix-refcounted-huge-zero-v2-0-c5d8a41b317f@kernel.org>
 <20260730-fix-refcounted-huge-zero-v2-2-c5d8a41b317f@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260730-fix-refcounted-huge-zero-v2-2-c5d8a41b317f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1543040008
X-Rspamd-Server: rspam07
X-Stat-Signature: btursyprq91oyx6hajppfuyb4ta8ku4h
X-HE-Tag: 1786521962-79634
X-HE-Meta: U2FsdGVkX19jR2R2tyNwEufRv+8EdMR/858NPFzvlQb3Je3bhHZ+yj5Hek+ri2nwMfDkkTjrdTLHuRq0Dix2AcADG2s1KZgMAD6IjKORQMIUyHC0ikPDFSLvH3YfJ+ITl4s1Qhgw/JAFJ+O6LiU5B/T4+t3eb68Z1cmFh9DrPOi9SfAbc6rBuE+A3egGWLTGy2FIlToeYpGFhJc9jt9411xddqG9ye6ORWcMcx9YeuS+Iq3oEypA5m5Ct8OMrKL3H1nZ1W0siqqfejd/i46WDtiSfZGe59RjRwUUa3iL07piZJMFPTkrAQ4UcuSNNTHkuPlwHxz9PtilDaFgn5GXtUa9R9lyHIwK7HqEBAb/Cz69y2FWBbZzSIlFTHWxqmL8qPdIED30QQwzSPlub9R8pM/N0fJ2iSSTldk24rPSmrz/7NXQageREapyv46V1ffGbX8j+a39Nee5qNcFPu6P0qrnAGQsQaE308otsG6i4oVronpfKGNU2qFJv372LjGHX4zO/ivaFffYV893rUmlNuCxh42gaeSfN1cq1bC1eKSW9It7yjSdiTi8EFM6gt/8aGxeadbZOPD/u1RDK7Fqj1IZ0nd3FqKYakgk9NDi8w6wfxEpSL/m2CLRG2K0TnWL4hCrB3X/dhH0M4Ff0W6Wa46GNRtIS1kawz73lHA+9GLtuL+Zdr5oyPpvYhjQ1LZy+GdSpCE/AyLse9As246956RTa6wkyIYFzgsZ5V6oPTLlEKV139IQK1KhSGI1rPciEMb1OA+tMZL/ht/MJ7YboVUiOLovd0sn6gILgleV9udD2Q4sUng2FrwIo6nTrW+V26Mn6JP2bwzAkYOj9AW0rdrbQHqRQmEwrByugjjXsFtNgJ2tG4U7zWvdfRibiJX3FkrwICmePHId6BGVHWea3xPQvMDI63/3/71A8XcQxhtpix3OaKYzbjxFiHDHuL2QTFoFW9IIkZC9ntlDsk8
 B3oo+yZZ
 gj0PDz3Qj1tV+s+kb8nPNxQSu1YBpVmtxuxCU9bhu/cZBRVus97vuKlGuTQZZ/VYCjHa1TrZVi19fHG8nB6LRoPEqjmVmavl85gkXX5aKutirJ0LL38okbmLp6oRZR/aqs7xk5LWVaCNm4U0i0sXwlCdq/8Mih/O/RquV3irxX0TM7ruEtUcc2ynqUVvQtYA5DZozbXWBDR8PPPAhL+adtOTnmRA5vRSeXebKgJnve41ybyMgqwt40PO/t9Jk8z6TJ9VpCMSQed2PHTtEHMogMNI9EIwiLcm6Y/m+crzZMjLGyZ1Fa8jws6a+Qa8ZniomytZKNpFKRQpWZ0c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/26 12:55, Lorenzo Stoakes (ARM) wrote:
> Rather than mixing the refcounted and non-refcounted
> CONFIG_PERSISTENT_HUGE_ZERO_FOLIO logic, separate the two out cleanly
> so it is clear what happens when this configuration option is set and what
> happens when it is not.
> 
> Introduce HUGE_ZERO_UNSET_PFN to abstract the ~0UL assignment, only
> introduce the refcount, lock and shrinker if
> !CONFIG_PERSISTENT_HUGE_ZERO_FOLIO, abstract initialisation and teardown,
> abstract the huge zero folio allocation from refcounting.
> 
> Also change a BUG_ON() to WARN_ON_ONCE() while we're at it.
> 
> No functional change intended.

Ugh. Why is this patch already upsteam with

Fixes: 3b77e8c8cde5 ("mm/thp: make is_huge_zero_pmd() safe and quicker")
Cc: <stable@vger.kernel.org>

It's absolutely not a fix. It's a cleanup that should have been reviewed properly.

I really wanted to review this.

Making David grumpy in the morning, good job everyone.

-- 
Cheers,

David

