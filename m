Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05986C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 13:42:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B43B86B0088; Thu,  6 Aug 2026 09:42:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACE586B0095; Thu,  6 Aug 2026 09:42:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 994E36B0096; Thu,  6 Aug 2026 09:42:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 618D36B0088
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:42:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E28AA1607A2
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:42:30 +0000 (UTC)
X-FDA: 85070959260.04.15FD075
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 354B54000A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:42:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=op9s3D08;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786023749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rhms/CncUEbTJbEN1GalhQ1XaoUDp8JHYdDp0s1oW/s=;
	b=WgOXxwkvdNUqmm79cE+pjh+omwRiQ9iGNuYV6F/xZZSEILceS6v0XvCvXhjh16/YsEPcxo
	UUT4eMUetvTeJT2c+sip6WegWPcP3Dx2kYhwt5t3zDIgq5Mwo/VjPlFNQCjbo0m7d2OTE9
	cJMNK+yZuIaeed/LyrE+zhsRjqzjd3s=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=op9s3D08;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786023749;
	b=oqv/k0DWi//U6QgfZWMUXg8VxFm6ltrW+pK4N1T2mSfDITBXeFNf/w2vaEXWu7PZt5zC+Y
	8Nrd1BF+/yjMa8NugMah61UGtQiZcbH52+o2vYL6OfLsDhD5ZZz0atDqlniWgebh1oYzd/
	hBtlJV0/fCSa4mGjMRDY+nvZRyP0A9I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CAC2860A69;
	Thu,  6 Aug 2026 13:42:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0581F000E9;
	Thu,  6 Aug 2026 13:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786023748;
	bh=rhms/CncUEbTJbEN1GalhQ1XaoUDp8JHYdDp0s1oW/s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=op9s3D08TfnwWI74/l/IpPsxqeubCMK8JCfVnyqT0sYzdrruHoDsVhMXR7N1ZuwbI
	 3J9i7J9w/mSSa2F94YHlbn8q6Njb9tpePv/2d8ZogA2XJZ9/GRprdfmtcKZB2+EJtQ
	 2M+a90+1PTQwHh7syrozGAX4yyWpEWNpNx4Fr6O4lHAjX3PDoK3Z/xwrp55RMsdNFi
	 bPjpggqKFjmHRNwEJbcTY9z3hIVn3g1fnnu8aok19rN3UpHAPkxIzPOCtAct0/v9Ut
	 +6tqywMYRqJL1aiUhrPrmxEwX5CwTQsNPqZfKid3cWiDQIrBbyUdsoTXjO0uHHk/o4
	 s+/G4xESIzjFw==
Message-ID: <26a86c05-e9ac-4bf0-af5b-da06ce644a76@kernel.org>
Date: Thu, 6 Aug 2026 15:42:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/7] mm/khugepaged: fix outdated comments
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
References: <20260804-khugepaged_pte_refactor-v3-0-0364cad642a0@linux.dev>
 <20260804-khugepaged_pte_refactor-v3-4-0364cad642a0@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260804-khugepaged_pte_refactor-v3-4-0364cad642a0@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 354B54000A
X-Stat-Signature: rkooqcd5rzqnktxww75dicznyb9ia9yc
X-Rspam-User: 
X-HE-Tag: 1786023749-864573
X-HE-Meta: U2FsdGVkX1/yW2jsKP/Y8enmZJDRRKbfleTwJNC36N0bsCbEBV4B+diVd+Yd8HwWa34VUvAOOU3m0yZDaHiKC5aKU3Btq5+u2uvbMsYhuiS86Comui3KDuBUtm/o+ahvsmMsedUyWQIsqFBTcfuBAN0LbxxCOiX7BRfw3+ZdmwI0anZZThwt1DdMQ8S8IwOE514U6ctlGFS83XFDANTGKygTqcdHLwImnAZ34twFn6xaZnmQnqyobbMff9FQ1tdsT3uCkH7VQHtwPeSmNtWYfp5m7aXTZ38OmWpS70cN5Zp6+w4aEqhmgb9PXcyyKrN867Yl0y/opMSfsegsX1mrCZGUEXtc71YrLBEXWrtxLTMD9/x6FjKVCy0sPmiKcqe4wq8aVgYCd0uyeX+rNveWZhyqwuWKnLIFQrb0NeyXXra4C/c0COWpvv3etn/xbyT+rmxNetdFPp98G0z6hZJZK8kCu6txnrhogU5cnCI4Lexx20byqFLEzTGvywSmu8yis7dHy4kP1Jvwyq0uLT9RotMeHJw6T16c06SytoYAO+oTHGVWlx8yeZxhdqTmjPlo8z3VGizwsR2zyRxRavs96hPYK6ejZtjiYlPh8RdZOuFR9kxdCrWcx4WyuHiA/lE2YnIXGcE5zMFNqwtPC6sdKFibK6s1pCqiij7r+RtyaQPKmlRvrvldP/qZNKqNZMAwHOiss5rAwJnEkdrbFBPnMN4YAIPBLY/m4snpcxBUDj3YIWVsRC2Moe9YNx8uCKL3CBcTQpMaooIWefq1K58oewZzU+dBNmNm6PlUd6TYDmuRsWj65CIEjoHIWBiqP+76zaI49+ikEGNn8KFn4m3jHCqpyZVTHE0EOJFeaXhOqX82OVdGn9yRR8TdrY08kseFytk8IHvcxDeh7ZqnLbhMNSpArto3EhF3hdSsPDz13XNLCGMpcyvTenwanARwG/kjrYUCLX5Drtu6HESHKo/
 OB5GCl4F
 Df+KzbU2bC3HmVbbwI+NfEAjwR+rfy0U0OHXT6JfupN2HT/eVrReWMl7Ua2LseuaDyWWzJP/SgABg4ab142t3bk4j5AGsKdJMCpGc5OyRHpaIMyCoBE/HWSiWvbt78RSfxxoM6q3FrGw1m1X1ygVGMUujiAaCdE/ie4obr/4XtgcsWjl8vr3vXQrEM4+DG4+5Xw8Zo6EZdMNFyBa1RbKhNhufTb6XxyKVBpRIl66Ps1bb9pkJb/0Vn5U8aAbQWEIJp3btI0YTjCERCjwUbE1F9+ryXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/4/26 21:25, Nico Pache (Red Hat) wrote:
> Fix comment in collapse_scan_pmd() that still described the old
> folio_mapcount() > folio_ref_count() check and a "512" false-positive
> scenario. The code now uses folio_expected_ref_count() != folio_ref_count()
> which doesn't suffer from the same limitation.
> 
> Fix comment in collapse_huge_page() that referenced ptep_clear_flush,
> when the code actually uses pmdp_collapse_flush.
> 
> Fix comment in __collapse_huge_page_swapin() that referenced the old
> function name khugepaged_scan_pmd, now collapse_scan_pmd.
> 
> Also clean up some simple typos and stale terminology (mmap_sem ->
> mmap_lock, PG_lock -> folio lock, page -> folio, grammar).
> 
> We also clarify a comment regarding where the max_ptes_none check is
> deferred to in mthp_collapse() from the original collapse_scan_pmd check.
> 
> Update all comments that references a function to include parentheses.
> 
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Assisted-by: Cursor(claude-sonnet-4):4.6
> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

