Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BC64606A32D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 14:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PDJrQxmN
Received: by kanga.kvack.org (Postfix)
	id DBB336B072E; Tue, 24 Nov 2026 09:43:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6C036B072F; Tue, 24 Nov 2026 09:43:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C81F96B0730; Tue, 24 Nov 2026 09:43:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9ACB66B072E
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:43:27 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 32FAB140BFE
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:43:27 +0000 (UTC)
X-FDA: 85470280854.25.5F83A56
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4EB7314000C
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:43:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PDJrQxmN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795531405;
	b=ZJnuBPNpFv6ElYj4C3vZfY6js+Jaz/0YfyzevC1T5cq0DjqaEhZw1HayDdmkmQqVHTug6Z
	tOEkFoMAhpIAFz3IT6A6C0/gatOoZrbLHeGHlmHOm7Wr/SnVZ0/A1qJ7MCarMJ6WtU/zCc
	jmfx02gIPtOhfJNx45KRMDf8hYIB4/E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795531405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t7LubSWd+iYxlj/XP8vahvIuqfClM9LvXthjnvc2fUY=;
	b=6wSuU6tXrh5ZafKAkOAY9VZxLxvIFYsVRFJ03Oyq/VXZt0qhpzW+RZRLFZUCAT4Fup/J8y
	WiGeF+MGz7kmLa6ZEFvmWqAbViOkIQO1RKL3n8Ww0Mr37eDSWQ3PyZEkUcXvXtUDcpvtPV
	KEPBK3lp3Lvk+3xCLC/+yj7GiZ5IefQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PDJrQxmN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C53FB612D3;
	Tue, 24 Nov 2026 14:43:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B321F000D1;
	Tue, 24 Nov 2026 14:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795531403;
	bh=t7LubSWd+iYxlj/XP8vahvIuqfClM9LvXthjnvc2fUY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PDJrQxmNsobCT4kmEB9/+PlLwkxpbPP49gNIU7x1oBDN7BPz9ruvEwFlI4ve6HwKf
	 Z7aeZMBDmvea9r/H78UFL2NQeJdFw+JX3zUG74jBGjd5END/B9U7MTzp4hil6n37Z9
	 c55dV4IGkRiYTbgoEyn04qKMcbhGUtxvdoq/8L4m4NhjGHAElbyk66obxcEtem1H9x
	 zZhFr6SZx4e1Lu7Bqk3Cx4uakJS2/IUwpgTdHqiJGfr8Q5ItN15HvzVkjpqZsOzf53
	 4fgvRrppYkqsA5rgy6o7T9NUfNcFPd4x4HLuubexIEB4mTOESLlsXrflzcSojQYTqc
	 6g/q/Gx5z4dbg==
Message-ID: <9ee51be5-c100-470a-989b-6ef05c534438@kernel.org>
Date: Tue, 24 Nov 2026 15:43:18 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/2] mm/page_alloc: get_page_from_freelist cleanups
Content-Language: en-US
To: Joshua Hahn <joshua.hahnjy@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20261123181829.4065581-1-joshua.hahnjy@gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261123181829.4065581-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4EB7314000C
X-Stat-Signature: ea53xqgdcdbus8pqtyri8obkgi3tbp3b
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795531405-30634
X-HE-Meta: U2FsdGVkX19ZEelPbIpQqHYldXfttpaQtYtnqJ3d+w2Qpi2B4repGd/OfqviFpZxY7mYSQ0qJ3jPTB9Mjt6K2yiUFDpRueVMyQVLHCOB8/1t/KnlJrTsmWP5+x7WrMYWLTdYrq47kMYkIVEUn3YwqELW9CAP7RI42ETNbeEjggFAVFVmEW0h28LkTsIXhGetAyK5+9sveGmIh+flITEgBg1TpOK/2IyWMzSn7j1CvX0w5DCI7yzae/3RpGJ6YjHml7K3xSRVU0OojSwYU4ckKjQjhXnChCGr8Rp/yLjGq7EsWEN36rpe4RzttCXdb8LS3I5VWU3oc4FpMlOiw3VJtzpjAQsG6AZxLIZV3p5Ec7eWNDdO348Xkbo2rlYfUMEYsiFQRYSN02JskKg2FWZy5RGzEB3MK7AkiVUIkOvoRUcGFtuWf4MCRylKH9cAlv7kUTTWYGTkBihs+iiIMKWneuibwRx+wlIxZxy/HBOBTSrHeQodRZdqwZcblHEsGuv6N/+HUG91UcMDaAo/kkGLTH1bbt0zm6JC4qdl4zufFD83TlJPIucdnCaFD+9PvE2H1g7BZ3l2VDYsPuJtG4O9Li8QaOR7/VQMo5kGmyDuiy7pFTUJRA58gQJt/icoEMaRBrPnwYcDBkBCoTwxiJ/Pd0RC3XfIt+Z0LB2UUU/IUPBfs5Fvoi6NJJwyEMT7bFGJvFujO5nX7dmkVdVwoGX+O1WWy01KcIa3FZZzOk8ipkmQAzD58+YwuJF/kMn6+T3c1TUtwqRJm43PWPnK1KGStrC5sYE0UsnVUgnEGTrUz/GtXI4PLeGMtz3pnoZhvVtAgqiP2rFxP8eaB/VIjl5+DEVQSNu3feJMpzHUOQuF8UtvnHvfAtM0YCqOIu0004PeZ7i5q8E/xGoxNfoTdzxG3gtjRVyJjhE7cno4GlF3rfqXAbH7q/3X5+mGxMpmo35QBgSNPqPOHExBq6jwQPc
 ScasNHYF
 wS5DZvTI3b9Ilcv5K1Ln/qd1zWMQKHR3o6jm/KJtpxO8UDzt7qQKK8zAxC/X4vqoKYYgQhvgMgRUsQ/2T+93AXvoZVUlNZ4OupZuPawKN5mqzfZUA5Ej82yIqVFgaWY7Om9bDgebQMY8ApAOikRWSTiiuQjetdh3cerB8LKXmpIqFOama35RFfoKSD4u2tRHp0En+ydqZsPcNMyCN2fGjgQ1Tyq5h32UbcwrNf+yK/+eyqaxsLJ/Sqw9DqHaaIH1Li5FbvXfkHvSNB+GNtoSR4sdTDBfyDpKO3unDkW9sqddFl5NUz/GaribXAX6vuo4SbEdhWa5Ty118dUFqWvm7igpDl++JkJKLxdxpGrWr89s5qiOt+WRmuKIIJOpw/liy8m5SZ5W+HO929mERW5vjjiSL5A4RJ1Z+r5da/pPjbGYzjjyBXkOyzUeMnZrLvbwYgW2Qvstn1C+6s/UfEWoG5UyqjmDHzZzMxSXbMewmFWPJ762AEJriY+5sI5cSAi6aeaGN910IhIeXrcKuaAU2+fXi/skKcI7tXSyrrhkgGX+owZ3WL7L0LXks7cvOntu9oKz8xAk79O5iq1/pYA2NMIcopqtnLyfAY60y7siwxtGrnNMNKxJMYHYx5S/gfOJADi8ErgtELdl5tjTzwel9JeIfYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/23/26 19:18, Joshua Hahn wrote:
> v3 --> v4:
> ==========
> - Make kswapd_wmark_pages() static inline, as suggested by Vlastimil.
> 
> 2 cleanups for vmscan and page_alloc code. The primary goal is to make
> get_page_from_freelist a bit easier to read, especially after the new
> kswapd zone skip conditions [1].
> 
> Based on the latest page_alloc/for-next branch as of 11/18/2026.
> Notably, there is a dependency on the aforementioned kswapd zone skip,
> 677dfdfad244a "mm/page_alloc: only skip kswapd nodes below their kswapd
> watermark".
> 
> No functional changes intended.
> 
> [1] https://lore.kernel.org/all/CAN+CAwNsqWpPoag_XE6bxbrfi6m71xw1NS_wc3h_ShZjNspSjg@mail.gmail.com/
> 
> Joshua Hahn (2):
>   mm/page_alloc: move the kswapd node skip check into a helper
>   mm/vmscan: consolidate promo vs. high watermark checks

Applied to page_alloc/for-next, thanks!

> 
>  mm/page_alloc.c | 47 ++++++++++++++++++++++++++++-------------------
>  mm/page_alloc.h | 12 ++++++++++++
>  mm/vmscan.c     | 11 ++---------
>  3 files changed, 42 insertions(+), 28 deletions(-)
> 
> 
> base-commit: 3a99594e62fce8c646e8aac01d38af16d6833a40


