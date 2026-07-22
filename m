Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF640C44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 08:28:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 768F06B007B; Wed, 22 Jul 2026 04:28:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 741076B0088; Wed, 22 Jul 2026 04:28:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65A576B008A; Wed, 22 Jul 2026 04:28:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F4E46B007B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 04:28:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B3DB8140370
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:28:00 +0000 (UTC)
X-FDA: 85015734720.14.70878B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id D4BA1C0004
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:27:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fezJiG3k;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784708879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bd8zVDFZNFpbYFWRYi6X48kR8SBnqH8MhijDXZzQ5EE=;
	b=KnkCg7MaKv5rEFlPV1vA7pgLIOZs7N8hq0ss0NYxp01lIN9RRHGYoU0U3+DMyJ5U/0W+Ij
	WBNayVdzCP35lUW/KtAphGXLh2LcDQ7eZgP5Dz5tlgou8uk0dZRznX9gTTJZN2cp88Qn+5
	aPUF4iwaq7phJqV6u/h4meovvmBsSuY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fezJiG3k;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784708879;
	b=mJeLcm3rImLFxHkiso8yZcwO+u5rnVdCQZDZP669aLwGywd8HGYo/TcIsJzreXJVFKthIV
	0XfA70xMLQSxI1wZGKWkuncC5tmCNzTq8eW0ASZsls+KUMbCUKySp771z+aK/M/oqSc+vV
	5RIHVQ9nMCebswKGE9um7w0hsHII8Kc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ECA4740952;
	Wed, 22 Jul 2026 08:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82EEC1F000E9;
	Wed, 22 Jul 2026 08:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784708877;
	bh=Bd8zVDFZNFpbYFWRYi6X48kR8SBnqH8MhijDXZzQ5EE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fezJiG3kcoo2mXlu9aIwFIytFwPPKIOj0eJ8X60VZk3bv9c672CLJQKRis/OIra9h
	 l+Zh0U6bsluAShQXZH+sHI9JovZnrCrBl4tAi9FpvU693zUyyGRQQzfT4GcxI93HP0
	 seXmq01dNbVXlgFI/uYJCMcIo1OGBpi5HVLDVrA2pe5yFsj63Ku97OMWS+M2XCtVcM
	 ueVgx/Ak0a/pdRZto4PEp+zSnG1GJqZyt9dJfvPdp7ff0aAqsFGrppKLi+oGJEojcU
	 sXVExztfvc6o40BSlS1+JPMZ6/kWD8t59tYDBiPUxMN2P1zzGrfAW1/08cTtQieXh2
	 D4VYDo9OojjKg==
Message-ID: <1dea7b3c-7740-474d-b9d4-cd2baf47f181@kernel.org>
Date: Wed, 22 Jul 2026 10:27:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/5] Only free healthy pages in high-order
 has_hwpoisoned folio
Content-Language: en-US
To: William Roche <william.roche@oracle.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Jiaqi Yan
 <jiaqiyan@google.com>, linmiaohe@huawei.com, ljs@kernel.org, ziy@nvidia.com
Cc: osalvador@kernel.org, harry.yoo@oracle.com, willy@infradead.org,
 osalvador@suse.de, jackmanb@google.com, hannes@cmpxchg.org,
 nao.horiguchi@gmail.com, tony.luck@intel.com, wangkefeng.wang@huawei.com,
 jane.chu@oracle.com, akpm@linux-foundation.org, muchun.song@linux.dev,
 liam@infradead.org, rientjes@google.com, duenwen@google.com,
 jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 rppt@kernel.org, shuah@kernel.org, surenb@google.com, mhocko@suse.com,
 boudewijn@delta-utec.com
References: <20260705180714.3708947-1-jiaqiyan@google.com>
 <85cb7ea8-8116-4092-8310-69b61eb8602c@kernel.org>
 <ee6bcc74-0846-43f2-bcca-b1bedff74351@oracle.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <ee6bcc74-0846-43f2-bcca-b1bedff74351@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D4BA1C0004
X-Rspam-User: 
X-Stat-Signature: jnqfjxuqxgmmsihgefdbeyed18dmkxjb
X-Rspamd-Server: rspam04
X-HE-Tag: 1784708878-520772
X-HE-Meta: U2FsdGVkX1/kMjGBBKIcsY11bwZneQQtIF8JGuNxUn/SghieLd9zuCGulq8eAemjQwq/L/MtZrCNNtqZ9tuXhbtFaLHdChcW7K+uiKmC5/HTsp1mI6xMxS+J9J63gkMMP7RTp3kj1x2oGC0U5b9TiKfkTsxW6a5z5ag5gq1KUJq5zrIW4mpgixJEwTR0sY+4R7JoJEm75M70j7LCeqMaaJjl6TNKw1iIm+E92nmiFMuu14zbZR5Xz8qf4JlffPdfv59W3HREMIU2GVaFzQ4YpOy0IqGP6uqwTgDigllC2X6P5zUmq3icGRmuYmaWnl22auDzd9VyoPSNny/bvTBRI2eJ0obO6WdBJix0FbHtYiBbiTQ2+lHgI5teLFI78nhgB5i5FrgH8x7/o+jAewePh48Iqd/aHYnp+hTKqNH5VySrmjw6lh3TojN10VLNBHQoPWJ/4I2Z/hbBZLcMQ3QjrTY5b5L93JVhKbFdTKaHMhHkqnvMW4C7FjIBUl5pKJpTnRtfiq5EJRFJOEV1b63tKui8V1s85Ytw9jU0SfunB3HxAO6UrXlOb/UAqj0VWXXDkirRX4J+Q42OVkObGjGgQt8N3VlaVwyFFcVM2zD83/vXBr2TBJ8TKw3N9KKMwMvYeQqaROCCVHHWAhHJW5g7aGiJM5kXR77uSOjHWq5RhAabbdeYBZ+2PVI8LAJlLysdAZaXk6TdGE6F8IrAqFJl9LL/9juo4u3i+Sw3g4mgXeJZHIyQaUiIkW+FAyy1kW8zCiRMCaFsIGkLqZoYTEJilfhV1GHKo5+7bbCf1LwCnr8SM0NwLf7c443eCtqGn0QpSX0QWoaQwTbDHK3T5rBpClDik5zMBQfl9RpbDToLFipWhIMxFNOfLcq+QD5L2eB6J6biEUMye5zHol1pwMJZ/WESTLM+4SUg/y+L1hhi7thaRo3ZkRbHkPR4jArdDqPM0wTIvKemml1QKA5vMzG
 4/ol5sqX
 ygV2RRZLYhWersY5sGgbOHmjAkWfC+qKTzNahfvuJuRXs1ZU+iiI1E07fUjQSDVf1b3S1volMU/DunPSmEKVoSpsRvO5aWO3QMDNLhVL9gtAR0f61hAfsmnCyEiMphFLanJ/a3u7STs7MfBXO6bSmvxICutjFhN/VBWioUTcQTcjCp+4gryo3dIJYHfUKbXR/DFN4YFuwJB84qI8fGizvQUj+WHEnJZKTVl5RwKtUytnhSN1CK1Bc4xZULKnHbWvq8osxGqOujr+vmyeZS0h9Soy7m6ja+NJ1dgvWKpkkiKjXnSP8ly1ehAKwpZNHbf3RO1hPfXIxsdlPsAwXBu1FeOlUtp+LNnNrgJ9bb8RkFEA08HrdaGL7ZpLADaE7duy0bJVXdQzYrmLZVOrmxCD6V1uC/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/17/26 15:06, William Roche wrote:
> On 7/17/26 12:18, David Hildenbrand (Arm) wrote:
>> On 7/5/26 20:07, Jiaqi Yan wrote:
>>> At the end of dissolve_free_hugetlb_folio(), a free HugeTLB
>>> folio becomes non-HugeTLB and is released to buddy allocator
>>> as a high-order folio, e.g. a folio that contains 262144 pages
>>> if the folio was a 1G HugeTLB hugepage.
>>>
>>> This is problematic if the HugeTLB hugepage contained HWPoison
>>> subpages. In that case, since buddy allocator does not check
>>> HWPoison for non-zero-order folio, the raw HWPoison page can
>>> be given out with its buddy page and be re-used by either
>>> kernel or userspace.
>> 
>> I still don't like the complexity of this, in particular, as we have different
>> mechanisms in the page allocator already to try handling this,
>> 
>> We also do have cases where we set the hwpoison bit, while a page is just about
>> to get allocated from the buddy. So before we take it off the buddy, we might
>> just hand out the page.
>> 
>> check_new_pages() seems to check for PageHWPoison() and make us not hand out
>> such pages. It's guarded by "check_pages" but it seems to do exactly what we are
>> looking for, now?
> 
> 
> Just adding a comment about this aspect:
> The check_new_pages() mechanism used by the __rmqueue functions should
> filter these pages out, but this has been disabled by default in 2023
> with:
> [PATCH] mm, page_alloc: reduce page alloc/free sanity checks
> https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
> 
> So it would need to be enabled back, taking some of the performance hit.
> (and I personally think that it has to be done)

Would it truly fix the issue, or rather there would still be a race window
left where we check that there's no hwpoison flag in the re-enabled check,
and only then someone sets it?

Also, can the hardware actually detect a problem with a page that nobody
accesses? I guess if yes, it's only in some corner cases.

So I'm wary about penalizing the allocator paths again. If the page is in
the buddy allocator, shouldn't it be isolated away as part of setting the
hwpoison? I thought we already did that? So assuming we don't just leave
hwpoison pages in the buddy and this is only about some small race window
where it's being taken away from the buddy? Then the extra check would only
make a small window smaller, but is it worth it?

>    A note about the related project:
> This patch is an addition to the "mm: memfd/hugetlb: introduce 
> memfd-based userspace MFR policy"
> project -- recycling the impacted hugetlb pages.
> 
> I do think that "memfd-based userspace MFR policy" is a valuable
> enhancement, and if the impacted large page can be more easily recycled
> enabling check_new_pages() it's even better !
> 
> HTH.


