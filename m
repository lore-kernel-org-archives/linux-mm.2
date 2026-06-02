Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E1BFCD6E5D
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 19:37:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17F866B0088; Tue,  2 Jun 2026 15:37:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 157656B008A; Tue,  2 Jun 2026 15:37:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 045916B008C; Tue,  2 Jun 2026 15:37:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E74F36B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:37:32 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9771F120123
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 19:37:32 +0000 (UTC)
X-FDA: 84835981944.11.1EF5690
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id D70B7160002
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 19:37:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fRfQKSbW;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780429050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=50Yhnk6PWDkQ8e+9r8WghTkuVFdiSnHd/7RHujr+6f4=;
	b=aLXpkSOXH+klMv/QmXB4kTXomxa3kQ5heu8oFAZ9SOlddSK6I4GXYsjIeoR4uO2cN19niI
	3HD8YvLqO5zzCUQW922FpiZPqsMRSpwpeiW83LA5hnKHYna+5O2d+6INJ/9mmsZZBhgEtX
	1LbZ/Eluvj9MNpHVxguT3wtJ3SNxiIw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fRfQKSbW;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780429050;
	b=SCVZifArE3xTqU+h91Z4OswD2IJczmRM8qOmO3qVsK7NgZHHfg4iXAmvzdWD9+GzD7Xyy+
	MuyCDhvsGDqJ5WUSe7MkBvWJVg5hykrfgUIeZZen8EnYB2NGh8N/l9zfim90vJtn5dP/hC
	szSxhS49qAvwHbhNMo6VPHdpLwj6D7U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F56560098;
	Tue,  2 Jun 2026 19:37:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B18AD1F00893;
	Tue,  2 Jun 2026 19:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780429050;
	bh=50Yhnk6PWDkQ8e+9r8WghTkuVFdiSnHd/7RHujr+6f4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fRfQKSbWYoyof3ByugQB2NtLtGtDR0qtOs4f6a53/UhNDaH28ImpMcgDhP8pODcCE
	 hyzYUG9ko7J6cM3BAhTR0hXsUglJlNNQOo5C1h+Ngxhb44ATz48+UBIjK2+TtArp1q
	 elXx1g/OszwemAU8qzJkzyx640mTLh+TC2RAlWXJBblmkMSSg2e00QZlCbC1BgrQ+j
	 1/RFFdQ8TaF/AUEWkehHvIhXUJPD+1ixYA5YwUXNjloFXdu5tTkyoLtcrWtTPuGCdK
	 GbscUkzkSrfnCJ1z0sN61DgGGulEe8u1ZQBdm3ybSg5YhYcWf9499bimfJVci4ptdL
	 XdccpieUpJEhg==
Message-ID: <48e3c0af-1c28-4a4f-a3f5-fa1f45f1c5ce@kernel.org>
Date: Tue, 2 Jun 2026 21:37:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: page_isolation: avoid unsafe folio reads while
 scanning compound pages
To: Zi Yan <ziy@nvidia.com>
Cc: Kaitao Cheng <kaitao.cheng@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Liu Shixin <liushixin2@huawei.com>,
 Oscar Salvador <osalvador@suse.de>, muchun.song@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20260602130755.38794-1-kaitao.cheng@linux.dev>
 <34F0943E-4ACD-4655-B9B8-41F658FCDB7E@nvidia.com>
 <b03c0d32-07e6-4148-bebd-50784aa3cbb1@kernel.org>
 <3BF8FD42-7792-4862-B5B3-79691618217D@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <3BF8FD42-7792-4862-B5B3-79691618217D@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D70B7160002
X-Stat-Signature: ogbk6qr393motwfbyecukzxp57xxb4hd
X-Rspam-User: 
X-HE-Tag: 1780429050-508917
X-HE-Meta: U2FsdGVkX19AnE9vAFw4s04ns6Js86trYjXZaMZ4otb0/Rh5Af3zOry8CznjHsB10NSjRGOt+YaWrAOnHnSBQOZ5TtSb/8z8m/vcLZX35RcLfPrbDkKjHQ7yaZs9PYj/heVDZLgRwC/vEqMDB6Cqa3NboNHEJGaRaKu5kOb1FntTd4GvxcZyROSLDfISn0Hp4E1XCBPbVZEyrLNtlisyrIltgqlqK0KKPeQwwKQFYB7VWOynW+BKuWOk6RKDgUbZBzfJIXvU9PWw1wOGECidrN46ITvOpu9hvyDEJesxGQigW+j3kfhzC0MI2FuI0hNgoi+zCrM3FvWxy2qWjP4AecrZRkXsJVMiv8q3uhelb9vVSfW1OgLJgj/jCBMcX+gEf6GP1tQs2UtY9nZqHmygmTfWSKK02C462j3BNT27ZX5U3U2Gxc+Hrh0JnhENHnBf7UA4+B8fBG/9GHNntkxen9myRuwjoBciANJ7pvsmqq/DN9WCL67wXRBo3bj+Nwx/+/OC5GEUsq2uJe42QOd/jNsjIHJRbg38og05pXq4/hnjtS3Z/O8nftLe2Uh+Nek6RlQZA27JWJ7DDzXypDiezlLAU68kle68gYnOzFqDS6M0eAD6Qe17T96kMT3kDk3IXFC+VbVEJd1Dbw1R5zeRjHDAUDjR697OTOu/OMt3qatO7sOqWZwsZHG7alM7vD3MhX10XcnFyo5b88uDoee8Mzk4/R4nnVnphXBKlTj8qqORcu/97/jlWPa4YZoRE464QkmburuUKwckdwhi/TH/yqxjTAqJqMR1dgsC9vJUUl9xKr8W/O9oRKgkE6W0AzaSUa60sfCieq8wiFOwz0nKTKaVeLqbP0CWanPdW7ah2Yq8rPJrjqKIXhUDP7lU9KKoQX1TRZ1fpFU5A708Ilt1I7p6pn7expGG3ep7xB2cnDDlNqb5nxgbRAuJfVapYALcnT1N+EqDoCd7JpbWMLB
 Dw7aK7nB
 WlvyHOY4o9NgpmqJnDVJDA5WrejCHTKymNJAXGGSbsbq9nolt6gKE2Mb5+ekdcF4E7gx6rQr7aE/2ys9P3HwPgekm1DvNGKn+eWJtjWyDWH/GOuJmQ5nUZTzdZKBX2InxFZW/vHIg/Tj9pYYG0aK8EeM9pyClngnKvEtCEvGjbO23Lnu+UArUnK+K90HivcXH5dlGdzjcT2k3siE2esxgjg7zhYZQIn6XxhViAmpMwtZXlLsClKiEVyTdwkrz0ZCCKdFedMOP9047xbnCmWCav2uLb0KeB15qzwtAO/wcC1KqUsxnyx6sK7ae+gNnKo3VvqnP1m2c0GUFXlQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/2/26 21:31, Zi Yan wrote:
> On 2 Jun 2026, at 14:56, David Hildenbrand (Arm) wrote:
> 
>> On 6/2/26 17:02, Zi Yan wrote:
>>>
>>>
>>> LGTM. Thanks.
>>>
>>> Just a comment, order can be dropped and use
>>> nr_pages = compound_nr(&folio->page) instead:
>>> 1. order > MAX_FOLIO_ORDER -> nr_pages > MAX_FOLIO_NR_PAGES
>>> 2. PAGE_SIZE << order -> PAGE_SIZE * nr_pages.
>>> But it is not worth a new version.
>>
>> If we use compound_nr, we have to check for power-of-2, like
>> scan_movable_pages(),  as folio_large_nr_pages() might use the per-computed
>> value (which might read garbage).
> 
> The power-of-2 requirement comes from “pfn | (nr_pages - 1)”, right?

Yes, you could end up stepping backwards, at least in the scan_movable_pages() case.

-- 
Cheers,

David

