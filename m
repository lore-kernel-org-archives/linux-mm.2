Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 421EEC54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 14:14:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AFD76B0095; Fri, 31 Jul 2026 10:14:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 560B56B0096; Fri, 31 Jul 2026 10:14:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 428AC6B0098; Fri, 31 Jul 2026 10:14:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 158086B0095
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 10:14:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9C0041A0477
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:13:59 +0000 (UTC)
X-FDA: 85049265798.09.9EB34A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id BDC8940014
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:13:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YigsGhKL;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785507237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y/41p4/Kr/MVi4hSJAjbKgh4tTo8fUdwQ7XoxvN9Mx4=;
	b=MCfZvKTo3Pdy3qfilX3+O9AiSYfL1ofe0MicZfmC67kBq/Srehgs6qsBt9C67lYIAqHtjO
	o/oNSyiu2nW65SqNR94vYqJsqRO0jYLKeYWlg49FhQjlzXd+zfVfYcUQY4tkvJT0dwHs8x
	y8J578ToBsoMSXoSoA6jgOWqObwt9ZQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YigsGhKL;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785507237;
	b=hlecsbejz9jacTTmjzNV0JgnnaPiwjQe6X+zGsLlKMvSnG5F2xauzq3ktOuIa3ufPFDkyK
	ra9aDuoTqIdJnbqarVQysHQu3xVrMqoQL7jJqC9ah4Q/e6Xwh8RVEgswGXE68qhq0FwchJ
	jWghTyOHTvPKr8VVNj+BKRBmCvlGyVE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BD0694373B;
	Fri, 31 Jul 2026 14:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A82751F000E9;
	Fri, 31 Jul 2026 14:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785507236;
	bh=Y/41p4/Kr/MVi4hSJAjbKgh4tTo8fUdwQ7XoxvN9Mx4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YigsGhKLHAS1cw4q3uoFzwBffhZ8H3PN7g5JvVhSdCE3LGi5D4xlnJxVQ/41Qh3OJ
	 k93K3uVnQeWymvZ9/2zXtjabw6KxidwLG7oBUPjtnQutYilyAlDA1wzlKvJj+V57v9
	 kgvu+7zrqTYTmma1qy1Q8ef8mryAaDvdSyrLVncX0LhdQd8L/DEvPbQR2454slyynJ
	 b9wUUP/02ooIKyJYBv03FFsQso8c9XK99GtIjqOYEH61EmuaiWpnRDL1Rc2iuecjYK
	 K+ZAfZxB2+z97igjuJCEppXdQ/4ubhuFHUve8CiJBcd6uBu64Za6hOm/8+jpTBxPxm
	 Belb0pPocadGw==
Message-ID: <b07bdb1e-4c6a-45cf-9f5b-20745075f19d@kernel.org>
Date: Fri, 31 Jul 2026 16:13:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 15/26] mm/page_alloc: add support for freetypes with no
 freelist
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>,
 rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>,
 Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>,
 Sean Christopherson <seanjc@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-15-6f5729aa9832@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260726-page_alloc-unmapped-v3-15-6f5729aa9832@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BDC8940014
X-Stat-Signature: g7bibysiat31j4tgqyg5ptetq6wbjd6d
X-HE-Tag: 1785507237-752289
X-HE-Meta: U2FsdGVkX1/vk2O92JW81x1dfkPWmzcTlIiGggLs8I+lAylKQ1sQ1sindZq4fvtwU+6HicDgaUwgINg8eIAITdMouwAnT/3nqZVdX7oaDX5WGQ6d0z2y1Xnomob5XQVaMmwSNZHnM9FV4Smy1s9BWuWPj/ZOestJ2kdq3kFJHnw24AkD7wqtZbrXhyubb17l4uaS7TDZwBgv5amSnMd1kQqy24erQGsHI/C6kJXF7oZ1XcnTV+vl9pOnJ+iwCV4dOv8Ay4StcDlHl+V7MqnMj5tq3opbdpiOocVMKi2DcpMMGa6GqFI6u5kKjfus6hhEzeFYTSbRF07vMMlehYalH/GiqefrR5Slt8S/muUVPd9sfIV0qXwKTd4yxuhjxW7+0ljd7MVGIbpckuu8DYHDQ/TQ1wQxuBxjig2LBx/5BBzF8OL8aQlOAl5vEvrejYHrDtYEaORfuWp1Ojqs395DSkITEimjS0dLWgVWgOjejfQ6qoqHVlibzHOYc/E2pSmjIBaYOu6bQOUKWjA1VVTehEf1x+7Xy7i0KZft/Zsqu86tPflr+UK4UBPU2qU6Pdii3TdhIwcE+Xf3P4NWE8/0DyDkBCIbZVGzNnj5oZ6SNfHecBJp5SQv0nFps/5af+pm9CeCC0cP6R+uxi08udc7B5RreRY9XwJI+QQkSb4LV8sfoEMEMngufAASGd28v+SLTnErapz1IVdXFfcVqwqCJnXViE0HOjzaVT/cvcGWOwGSJvpj1byRRM6P5uVhJbE/XN+PigO+TePWmBhuWS7vegPp4C9C1+i7gsXXsiDUwsQ1Hr+px9okBeAnAg5jMHwmMo48ToDz0/sTZGDBfYpgsyhVyabHPzbR7uXgI/ZKcjfb9lF3Q302tv4N9YfJotAkjAwO0VQEvTwAw6BBRmqox0zccnrG2VQOAhFdp21UVIhVKerctBDTqA6Y6YLjla3oDmaqoSHH0gYOFpHTZjT
 gG6S9/lt
 4yRKXH0PmNG3/GZz85lFTHNH2CweWoJosRvfoikuhnwgBvsYvnLQTRKnIIO7nDWjgUYi4zntGvbkqMK2cA+j3tO3dLmmUmQYTJUijufqpmu1OzxWs0I/RuuKyJFk1x7VjTmQwnmFY9PP8jUhBji3wDi4THP5jbH+S/SiWM0QeJsbBgMQp/IkY/4UH8dLQvjSm0OEUJb7NQPfEuvmNqZ+w29HvQFpShgAR60IwvDaziq8PZOIxqbTauz5++J3m6csC+68eRJ9Ojj3cmnWND5z5s/CGfvaX8tDdtuxt4Y2aSePKMqIRWYRTz2XXb91jLJ4a8Ywcco2dQQaUfmcTsT8GUVndb/Mij7/jEyD7d2/Gb2oHzf4T9a/bnhvl1BVclkrdxv2O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/27/26 00:22, Brendan Jackman wrote:
> Freetypes are currently just a wrapper for migratetypes, but in a later
> patch they will gain flags. The theoretically possible space of
> freetypes will thus grow, but many freetypes will not actually be used
> in practice.
> 
> To avoid bloating structures that contain arrays of freelists, mark
> freetype_idx() as possibly returning -1, and add handling of this case
> to code paths that will look up freelists by freetype (unless those
> paths "know" that they're operating on a freetype that has a
> valid freetype_idx).
> 
> It never actually returns -1 yet, this is just introduced as a separate
> patch to make review easier.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


