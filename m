Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E2B4C79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 12:48:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FADA6B0095; Wed,  9 Sep 2026 08:48:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D3546B0096; Wed,  9 Sep 2026 08:48:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C2C46B0098; Wed,  9 Sep 2026 08:48:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1004A6B0095
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:48:56 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9ECE1401C5
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:48:54 +0000 (UTC)
X-FDA: 85194203388.25.90B0A12
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id CE9C0180007
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:48:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NVevUqrf;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788958132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WiiAwtPF6Pku3MR8Pkjyi8U+d6UdSbkK4PO/kbMV8OQ=;
	b=UFEOh7bWwfA0svptL5fZd5Rcyeakh4+BnU3DSp5H8Bm8gjHV1vL2ljGHxUkC+YDLogqZdO
	Ydam75aYCzx4hksBmFTzomaYlgFmTNilVMOMeQOOkzE8VktvaHUFgEiArJ9cjxwrNxIjGv
	9ro21C8d4wOeTR5lZrZbtT0I8CaFdWs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788958132;
	b=XauhQF/GMDoNDVDt75uAjghE+Gs/0bEO0rR6gduuxGgQ2DioD9OGhPfFqt4Ix8qNpN7nWS
	EWCuM6zPN+fsyZcE+cRo68PpZovv5naHABwVc5vZgWhocz193NfaUkj3pV39VizVS72eRk
	rWSYIA07+iPLZzfQ6umNulKyq30L7UA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NVevUqrf;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EF00843D34;
	Wed,  9 Sep 2026 12:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6AD11F00A3A;
	Wed,  9 Sep 2026 12:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788958131;
	bh=WiiAwtPF6Pku3MR8Pkjyi8U+d6UdSbkK4PO/kbMV8OQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NVevUqrfuep5jObjd5o/zvYSPczEA7v7+UvplrdxdXCtSfnFwpi4z1WPkFyaLIWY0
	 eDC4IcRjsOMO+wWGoMwArnhEAuCe6WwQdH3uukrUDOoIZGgK9+tLoFoQjdedi54r0q
	 No6g/T9QZvdUGbrcdaLmX/UNnyOZN/qPHv8JMNuMODiVI3D5UYQkCc8l3oPIXN85eA
	 O1P8QhR/jP1MQxFUX2h0VY2WEEmJVGBs0hsaDbTPPPTZ5AHfMMNCz7dawF4ClEuXr8
	 A1YjORvfwzsnm+wkP6jJ/Pg3PFf4SePyCVT3V/3C3HpZAMmEJOPsixBxbO2AWrQw5Q
	 Iu3VRVH3VjZ5g==
Message-ID: <e6335c78-a20a-4024-8980-097a922eb257@kernel.org>
Date: Wed, 9 Sep 2026 14:48:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/17] mm/sparse: initialize memory sections earlier
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, David Laight <david.laight.linux@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260825084608.47437-1-songmuchun@bytedance.com>
 <20260825084608.47437-10-songmuchun@bytedance.com>
 <a2016390-28ce-4199-a063-d2e9101dacab@kernel.org>
 <E54037CE-6CE6-41AB-A525-8BDCE55996AC@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <E54037CE-6CE6-41AB-A525-8BDCE55996AC@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CE9C0180007
X-Stat-Signature: hojswa7en6udgpsi5nd8hhxqqp5xbugc
X-Rspam-User: 
X-HE-Tag: 1788958132-65487
X-HE-Meta: U2FsdGVkX19Vvm077IPyjRlYav2PkX7rxcW+9E0JGtSlnvx0EU6mno9iwXSIk+GT4aapH7svtmjW0je58D9izBxI13LrcFsGZgyVvXoEXQ1aqF+Skh9zRcGuELMWgojTcETReqwEQEHTjJ9CYH+CFwyWtOG6Ay9NQ3j5fgrwb8ySu+cRz+9CVllpXKyaacUxkAzvPcnwUvcurXqKZY/MrURlgbKnEpw5Ma/TMqzn92KfBLq/RcenrzV263bvwQdVus0IaUaOkaswZshVgm8mfRKC6vB9ZNuZLwjzzcJjq/9YQ1ureT8T8ScYgiDoHUHwAIxBpBo6b0dhMvCEkcbTdCSuqrjX/E2ffPIobP60NxC6uOSkQhwn6O9M9sR6REiVsxt2TlRWJFjZN3++g+IjAHYfYzdVH63IrJhN7xBzLP/gsgZi6xEJWeN6xkoLQJiComoUPHWePBFacQDyUldteNpEUxq9VWLzaH5CLFeau5n9dBdsi8r9OluafQxsfBUAQNCO8XBYbvYyq4aVatJ5tqA67eDmhXTaSu45aT3k7nTyOzsb2L7l/oMwmnenH0+sS5lWCtpJeNBu6EEC6jB/y4k84hFWCMqG4wKbvys8svnAw/2yuX/k1jVD5dbB/qfxZpy9flkAJPAaaVWrEZwbKDherGzoOL9uFcmzSYPYf2lOISby2TPiqwprWzU1KQ/g5THKoU2abGJ7CbvwGarIz+bJnOcLTrbKGSSaxBKlX7PQZX08tolz+kmtRUJOsoHC4slMwZWaCVHZ7io10JKSNBzvcnbl4mPMtXdLGW0dTJNAUMKrQMNEeXbuJ/298YsM/srvkjW8oK7lRM1gaEy9ox1p77/Ppwk/H2TELFnMHZ7DL5XA6xNjvTL/w5LJX7at9e5sxCdGuoUKRDMynJslb6h5zrHZbCUBvBPGgHijB4iVFl7PesrnodATbA8HRt3iO38fx3WQ70bvFBqY+WT
 jhJN+GoF
 FLPvyv/GcVpE2ofRGDuRdbWWhuiWA1kpkjKjs7Nmj7wklF1ZSUh7HqZphxWUD8mAvNQFr3OdyLUkh7UrkZoAVBRqHSYlcTuVEcTSHXqFo+OXezwLm6g9NfYH4GlbYBOHc+7JplwMh7tniB0H7UNpb+uFvRYelq1eS2ZyuyBsq8OSdcIztutWd4O37fmTfysETUWBM7fQ3IWNdSCOoD7/UjQ/UdqQ/cLGlCG7kqppjOl9P3VFDserOSOia8DgEPMiAjtGI2L3rODGmPG1mYIDkCtH7YN2Xp0jhv2qISPLHRRKeoz9oEeIr+VOdACOzjRhxjxtAjCzE0MhWJWVbLK9afgid5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> 
>>
>> I have patches to get rid of __section_mark_present() and just set them all to
>> SECTION_IS_EARLY|SECTION_IS_ONLINE such that we can just iterate early sections
>> and get rid of that PRESENT monstrosity.
>>
>> Apart from that LGTM, even though I don't particularly enjoy splitting us now
>> having two init entry points
>>
>> sparse_init
> 
> Maybe this one should be sparse_memmap_init? If yes, it could be another separate
> cleanup patch.

It does way more than that. In my patches I factor some of sparse_init out and
call it sparse_metadata_init() -- memmap and usemap.

-- 
Cheers,

David

