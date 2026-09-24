Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4535EC98321
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 19:54:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FAFB6B008A; Thu, 24 Sep 2026 15:54:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ABA66B008C; Thu, 24 Sep 2026 15:54:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09A716B0092; Thu, 24 Sep 2026 15:54:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D3DD16B008A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:54:17 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6CBF81C2372
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 19:54:17 +0000 (UTC)
X-FDA: 85249707354.06.5EB0C97
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9B7E01A0002
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 19:54:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ue+9AbvB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790279655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0HJNKuMWG8smWqhbQSNH8vsLE/Fn0+yWkGNbv2CcO2E=;
	b=EwQc6XxD1mtqf6q4usUZPacHJDoJK8tU0l7mjoLIkJTzwpTLLbGeqZa9KeTCshgTqujAQI
	KOoFaFA4IpBoN+oCO2q0iJ4g7JuEnw3+J9+uxTfTnM0KumiSk76R6FMQjD0yAgSAKkgTwZ
	OUwFCiiFTSfwQwgh6iAYAqgY8kcIRo8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ue+9AbvB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790279655;
	b=JugBaNIo/dcf/E58VxJMnpGk7KlKquuNSvCTMZIemi+riwKoyzdDCaPExBXNcXMbF+S2FB
	9rcwjadUHoyQEYMrnh0jRWQH6ZOjpzCKkwH7uDqEcn/eYxmin6Kh6GdsnzVj8hnz/8A2kL
	g6dRtpzx5HAMU9rbncdqcP+RdLdYfyE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BB3A41FCC;
	Thu, 24 Sep 2026 19:54:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B13A1F000FF;
	Thu, 24 Sep 2026 19:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790279654;
	bh=0HJNKuMWG8smWqhbQSNH8vsLE/Fn0+yWkGNbv2CcO2E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ue+9AbvBliMX+AIYWSvzQWUAHjFI3jdLOlYH/aiNY3rhxae13ZiGjmWsr8aJZNcpr
	 MfQ1/lX8DbksvJiuh/nkNXdhKQe81Z2d8J4cm9YHvfu0c61XAOxufIl4bGlteKSYa8
	 3ZxGS5STiI1p6uzVLM6rQlB7RiVVJOjXfEvc4MfFDn0cZrc/5OGQij2Y5y8akxyKOt
	 QrJ8ML2y4spobTgcJPcgtV+cNiAaLhG9i5cVWxzjvybQ87SHmd0fMDX5VkeYBwd8R7
	 VNVePZoQSbnizLpo3ctvplSR/tUOuDV4rK1BKVLcgMxf8plzTKyPdXN+oUImJ7G2wI
	 SWj4KOKPH2BTQ==
Message-ID: <25cae0dd-6b4b-4519-8119-231e2f65da46@kernel.org>
Date: Thu, 24 Sep 2026 21:54:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/memory: reuse the whole exclusive large folio
 on a write fault
To: Yuan-Hao Hsu <aa9736195201@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, liam@infradead.org,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Barry Song <baohua@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <0c0c19d0-997a-4c8d-a103-2b3d153f4e32@kernel.org>
 <20260919111851.678-1-aa9736195201@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260919111851.678-1-aa9736195201@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: boyrweasj4wpenoiewfbigxrpijm8cg7
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9B7E01A0002
X-HE-Tag: 1790279655-603386
X-HE-Meta: U2FsdGVkX19MaYah0O3W+l4G0aNmjZ1Xhjd+334pFC0JYsiRP7yE3OujCCbkpA4NtgRjuPpCiGSLXGRGdMZ9gNgVJRtqAqyolLhborqCyVlAFB8erPqduNw03YZx8Df6itN3ZmxWa3KRA6nTCRlxaZtBXvsOj5dupAPA3k2aTASn890LeLsyG0Okn76X7HkvX5Mpx/pYgDN/FulU4XQ9SZfm4rsTx51WgSqse0z9NMvl49grjElVRkPGV5J/GOhq3eQxF/OWabgaP8h88bWKUEih5H7uDddkArnO/+YKdi6LGHIKoWug8FAmnSn5DppE/wgepSOGt1uPjf66bvW8uYCUC9A/bTTsUwDUh7tGdLB5j5gcq/UNnzfYZk9y+baZxOLyuyetZ/Zguid9BrDTCjJfRarroiSSLP6lZlneDv475wQgeQmzVeLa2BDxAV5tKjAfd3a8ZkVe31HrldJy9pVt3dn/7d4Nk/Y1KPfaDDd3WSa7+lwTaFDcekjWL2KpCbAbqV3bPfNqLrevT/oLlZWg9EveX/3/rjJi/igEzDADxFEFtd8cYW5mNY0I8QnE41t4GesiedVlsrste4ceuDVdiwkYbW9D0ZmpH9DEOeDtsYkKGATllnkRqL0a61r8s8jeyVgjb8xm5H3LtsCNE7NvRuareR79EKqTPsZoLIv9OthF/wGKCwB3nU3CtmrKowU+YF1j/GGv5OLwYkn2fdt/grLA9GsJz8l3Fh/sEkYC5i0hyUq/YTQq/RTF3cs+ZTnEh55F8OX3D6LSEF9NCW/5In7pYIFGpsou/sMTCE82uxmQaOSEJ9bhqeMSBYWamRYgq9S9POIjFvjz4Eeqa5sNCfF7dsdH9IZ24iOiWT4p8PsZQ9Ceci8nSA+gEKFMbf63d9F9vssuUlkYH0kiHmoyUhdserJhNgVX1x167KbKauhfJuNzqk0xn5ZdObKeIRX8K+T0+d4Vx+6STkI
 DNTKZhGR
 iieFiJf1hcA9/Sd6SNJXRcLwpZoqJv3O9RD863+nX3fpIjZePRpw84GlYYgUOccT9t64nrN2P8LSXelqQq9AxER+TNPuCHPxQ8ufXT6I7YyGIcYdJjt+eH0DO+WW+l+DR1FY9tXtlGmFrWNLYy3McLtuEHvoVR73gSEs8SsMFsgsu/4Vyj7RMxO+AnqiGgNl9Uxepkwu75EwdRGYoherAq/3i16pZei63SXWYBa+OcuYCp4LyQi2cjERO0rnbpY9oFy1vrEP0gqtkNDs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/19/26 13:18, Yuan-Hao Hsu wrote:
> On Sat, 19 Sep 2026 12:10:56 +0200, David Hildenbrand (Arm) wrote:
>> Are you measuring the worst-case latency of a single write fault or only the
>> average over all writes?
> 
> The single fault.  Each store is timed by itself (clock_gettime()
> before and after), and the latency numbers come from a pattern where
> every store takes one of these faults (one store per folio), so there
> is nothing else in the average.  The tables show the median of those
> faults; I also have p99 and max (i7-12700KF, in a VM, us):
> 
>                      v7.3-rc3+              patched
>                      p50   p99   max        p50        p99        max
>   64K, 1 fault      0.42  0.57  25-26      0.71-0.74  0.96-1.10  28-60
>   2M, 1 fault       0.50  0.67  0.7-1.2    10.0-10.2  12.2-15.8  13-22
> 
> max is the slowest store of a run, median over 15 runs.  The 25 us on
> the base kernel are interrupts; the VM has those on both sides.  The
> 2M row is the worst case by construction, every one of those faults
> walks all 512 PTEs.

Thanks. See my other mail, we should focus on keeping the fault path as fast as
possible and minimizing the work in there.

-- 
Cheers,

David

