Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00CF4C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 12:32:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCB496B00A4; Mon, 24 Aug 2026 08:32:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7C216B00A5; Mon, 24 Aug 2026 08:32:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6A336B00A6; Mon, 24 Aug 2026 08:32:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8ED2D6B00A4
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:32:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2FA851A006F
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:32:47 +0000 (UTC)
X-FDA: 85136101974.23.549DE15
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5511018000D
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:32:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lamlZeId;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787574765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zqlFWmE7mdoPXGZ20KnqQ/XM8s+nHIOBkClz/EjLnkA=;
	b=Td5jyrH96KhoGGIWOrsn2c9RsxIbrbcwIAiyyqsesdNNSaKCAeDrdmIhCqw6OYFiOvyPBY
	14GzGt4QH3b8UBwat+sKghpAUOeCuIqEaA0AFHENyVSJ4RRPYF12/GoomnrShBIFi4v+tL
	1x8pmpEWqHyFBrvIr7+4IZnEQpcWKA0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lamlZeId;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787574765;
	b=gw1tOEx8yWjq3hu5WsUHziLKBwUG4YfdjLNJJFSD7SwNPbHFfXJkLo5+1j7koNqaiLCDhF
	p4u3Nt7NLLln/v3XkwvIyMr1dVemtaEtSTXcPGD6tnOqZxRFr7DE7WUsSS8mP3HzNxwiIW
	3D70up5WnKsM2JUAgoN+Xegz9s7/2LQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6EFB440BB8;
	Mon, 24 Aug 2026 12:32:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73231F00A3A;
	Mon, 24 Aug 2026 12:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787574764;
	bh=zqlFWmE7mdoPXGZ20KnqQ/XM8s+nHIOBkClz/EjLnkA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lamlZeIden2T7H96cAGP3JYCXFRJHvO7TKYBqByTFY/tbx8hLgbafEj3FOa1hLCXo
	 bvT47pEqO8NGGvRnREP0MZ5U9T9bw9WOSsLeWIiOOARHUkZ33tNMc2RlAuKTy9i7DV
	 +4sUw0fKHTlEhyU5GrugvrVElTuIoxoFsnlj0eVC1caSA0h0aVd+a6BjvGupe9BBpK
	 At97pfmODC5igqlEaRe9fpWFZw6fJ0irq6puf2fcqWrtOVyAU1YCnFuB3bCccZpPyp
	 3dUPrV7ncUy623pmM/CqJ8KZyAetuzS9ge+y9RptHHG0wUe+Y//wNVnNWKG/YAwo3v
	 ATZe41e10DA5g==
Message-ID: <df35f58a-fe11-4cea-938a-f4b036a5bcc8@kernel.org>
Date: Mon, 24 Aug 2026 14:32:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 3/6] tools/lib/mm: move hugepage_settings out of
 selftests
To: Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Leon Romanovsky <leon@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Mark Brown <broonie@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260813181230.483746-1-sarthak.sharma@arm.com>
 <20260813181230.483746-4-sarthak.sharma@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260813181230.483746-4-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: szoymogbrfxfkmdynsnqzowmddunnqph
X-Rspamd-Queue-Id: 5511018000D
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787574765-180420
X-HE-Meta: U2FsdGVkX1+KxnE9RtQZ/Pkk2fnkc/DBLre+lwF2CA5w06YFeQHwCoJEOjAgQcFqmP3aDmh9dsWG2t0BRYUikBaDP+y0DY4NifkhWa/wNe/gdZxxYVPCVkq3L953IbC+irWzyGC6MWFoyUyEUryh/m6MsGfkIffpifLR45nNzhgPVEFHA4BONOh0BmB/NFSP7trFEd+L3+knZAQpIYWvHUfAU+ULAupUbyvGDaVky/mMM3cdYrc1GPorTyhZ/UCiCqTy2WzDdBpI2X3bovC0CP8LDHpkNFmJye3Th/m1PSB3I62VmdtaKJsKiVMqWyB7t7YU6zkOmt6Ur3XcWdyHBgelulghUckul3f0f1MY8Ibp1WfEPlLPfheXL2gjc/QGVjySE80kyiD0K6xENS5uBI2FXyx+igoRnk07yEYbzOF50VIkrBTcw94Nc48uia5E+Ub+GGWKL7x07ZdH+0G16QfB2Su/E0bixB6ig4IJmBdiUbBPpdewzl0p2AADr2EBhuudrQzTL0k5pZsbTtgB5P0WXFEtkGy2xsEP6+j7MIwOhqcXR3OA3kJzvyp5aDU08182wKSfIHIR0EtXP5yrE/bjFaGHG/MQKlv32MnR0kj3yvlcHe0v+WQRG9Gt+N/o2Qy7ZrLbWwxNGQK1scz78W4Q/tHKsVNO/oHmMFU8kckLit/xRTi93W/KmIgAN8IwUIL4PQSrl7IFOG6xJM9iJr2ksEmxLQ6OZUsQgU6XAuDhanZtn4IHlSFE6t0BiS9UsyGNKFn+AcX0OiM7QFbVRCUd47Wfg/YmkNjUYYN4ejvkiKHM2oW2sn3ga5OHYCceFVx3rSmlI3nCubMUCoCnQ8jtZyahk0mb2eIdtK2XmI7vtGqrU4Te7zeIScKaRG6++AaueHPKLQfuMF4cCNWrqLO/k86QY6AHW0v1gc52MeGhr/F5OR7Mpi/hOw4wIGJBJkAsw0rmwQ7P2hW0VFL
 YHNlnn5o
 ibcOgYGlmgKHMDkzJv0lEomtEV9uJ2zQoiwQPm2sn0klT5Aowajx6TwE5HwFynHfu7TbQCljwvloP7JrIaGiL8TzgGmBtRxfoEoWZ3V5kyF//8Lgm//fhKPFwQooZVNVR7jphqlgSKiea0I1xcfg+n+GYwRgVqjUUxkgIJWLpG1s9JKGyDkaLM4lF56xUuXAbm5SCh0fD19K7rQ5uQblCjWBpggg5dQOg/57ouH1Y5GZyNpmM2Gt8kdgZMv4AEwO96G9iF2cOz2DMpvIcKq68iN/ZwEWv/nqGzeI+TNgZmkaqK7+sAfs/xsvZPd17JbT4ZmyTE7iH7ojG5nr3y7rYfPV4II1x7lfDCPEIDydgu/R5CEL49aBd5W5+Qs5Ayq7gg6WcMWz5yoXuRL8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/13/26 20:12, Sarthak Sharma wrote:
> Move hugepage_settings.[ch] from tools/testing/selftests/mm/ to
> tools/lib/mm/ so the THP and HugeTLB helpers can be shared more easily
> between selftests and other tools.
> 
> Keep the helpers exposed to mm selftests through vm_util.h where possible,
> and use direct <mm/hugepage_settings.h> includes for files that do not
> include vm_util.h. Adjust the selftests/mm build to compile the moved
> implementation from its new location.
> 
> Remove the remaining kselftest dependency by including file_utils.h
> directly and using EXIT_FAILURE in the signal handler.
> 
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

