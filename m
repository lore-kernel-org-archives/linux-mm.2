Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ED87C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 19:56:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43B476B0098; Mon,  7 Sep 2026 15:56:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FAD16B0099; Mon,  7 Sep 2026 15:56:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EA2D6B009B; Mon,  7 Sep 2026 15:56:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 04B696B0098
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:56:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8329C1202B1
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 19:56:22 +0000 (UTC)
X-FDA: 85188023004.09.C884E86
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id A0FFA140008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 19:56:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WCOXS26t;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788810980;
	b=YKs0dH2cx10SEivU0HBPSBu3/0Esra9+9XlOlbUyZR0p0v7FjmozG8ZpImnTRexlJflHDt
	Fn1QvuRkRvC+B5QwBPVcwan/NBsxCV2WQMptfgJSpvL1e4w7gPloU1u9vY0Yn6kBayTl6Q
	4MlvaursZHyQnXOH4Lv5BELNpmsYW1w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788810980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C3Pz/iR4GmFSYdm+nHFH7X5f2zkT5Cx1Ic044VaYKjQ=;
	b=iIdkOmznrghbENC5vMuShVMQkZEauby/GAKnoNgOycMLQTpiEx/gh/gikpE2FMGkn5voMk
	25Uif/cOfX/vqSbTx9EcVD9ClcwT5lOJjnuDm6AVG+XwNj8LYkP18QsQTCG5aeU16M3Fgx
	QxYftxYu8l7N1TbHl8y0HmFyfbY41qQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WCOXS26t;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C44BB43C18;
	Mon,  7 Sep 2026 19:56:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24391F00A3A;
	Mon,  7 Sep 2026 19:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788810979;
	bh=C3Pz/iR4GmFSYdm+nHFH7X5f2zkT5Cx1Ic044VaYKjQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WCOXS26toUTLJFI73Th2e5DBWd9pznJ5zigCpkMzAlpc6EvgsoUrsMEgN0bmtUve/
	 Qb2LNffAKzQHuIp0Bk7LDdvW2qNZx88XIAiwsSlgIKhBkSMFsQF+hYi0b2agZOWFB2
	 DZF3bfWkA31yxJ+fb5okPc74s/ctN4KGAscjKVCClPO1DZ3qdeYkgZlLT6VQgvXgjK
	 c13zCIll1Dzcb6Rn4TAT0xuSHHVmzz7KPYv0P9VxQtrYDAGIIoRvd4OJKPoxI0Ysxx
	 ggNnYmtmWDkUOZeLeOHGfXAGypwRvKGVkwRerQ4wiMc6kHH+sKE6d07CW4seXVfD5Y
	 +o6968+qyF0LQ==
Message-ID: <9ab052f8-510d-4d45-be56-f49efca595dd@kernel.org>
Date: Mon, 7 Sep 2026 21:56:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/18] mm/huge_memory: move anon_vma and filemap
 management into split helpers
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Shivam Kalra <shivamkalra98@zohomail.in>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-9-9b43f5163238@tencent.com>
 <acdfa561-0690-4c78-bc50-92d308f4dca0@kernel.org>
 <apRHC9Hk9Ve1gO0o@KASONG-MC4>
 <6e85fde9-9314-4854-99fb-3582b13486fd@kernel.org>
 <CAMgjq7AUeb0nrpt0A=EP1ZCX8SBeE5unYQ6LnhDz0BO8KiqaOg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAMgjq7AUeb0nrpt0A=EP1ZCX8SBeE5unYQ6LnhDz0BO8KiqaOg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A0FFA140008
X-Stat-Signature: 6rj1d6zhd3f6wu6rqd61nd4tw1946y7d
X-HE-Tag: 1788810980-173
X-HE-Meta: U2FsdGVkX19LZTWQp6tdTFzXnCCZKlTl6EvAiVHKWKXh2rpGQ6v1QXF5rDODKDwt1FvFjvK9jdqwUd52ME5M2nej8RV3LhyhQLzl9KLBJtXi7j/t8MqR9XNMSlg2wS9KPn5ujnfCA1ug2Ja5n2KoWsa3c5bfiHIt7PumJPBHDwQizFUnxLUTGTbTggt984u1D0raVJIX4jr/C3J9csLaQ7jrJY46FwvU3GwK0YgIOQUzV3yTlKdqk6xpSlOVdrrT5bWT2D/rqAGASdCQO+Wsxi+c8XK7nVvrtplkvRxS455D1AQdUpTjr8hFxEJM294c6/5GbnaRKXlvFO4ZaFHz/6r2FB5u3/N5oFMjn1v3r9IiAkhtd5GEw27d59PQgMqwLVff6PKliF/GzgEGz3pUjw8LkgrhoKP5jkFQEueugxz794QC2Qk1cdOe0cyOJSJnQLpsJMKmutTsxe87b0b9SytD6tKIcfDQswRiIZqlufunccFSRqmX41TbobMx0Cl6Gyq45clyVyYTKR1Oj2YBIgnErlRbQNhO3rIWGL+xhe1x9BN/9ZFDoEB3yRnsjEyMDHzPAhWMLp94QScx7kYdTeczbY7AUgO86QNmbo53IiyGdd5cXm4acWds+OXQ9PXZ8YdYRjG8hGHHmI+rE9B4oY5jI90fUds3s/bXv+xQNrBug86c2AVs86Gg7RUwvoo403AdUr772Q7iIOrNWCQlE4KdgBxOu31vkWNyCA/x5IUj+SxDfObITYf6TWzKXikHSDUpr0zPHtU6c4uEBs9htfVnUSrrr7EjtMRbA/27ladKJtX1GKQdLMQ7rco99XLZmvX9o+ivuam3Dy1avGftZZDCQO99ITNBCkZ7X4yHYBv45bgOMmAF//l3mL9h0rXmvQ+afZz0MZqy6lOYFjVGHBl11C1/AM6s3GVM3zuvA5aeXqjTSgoaRaTKHz4lGp0kq32kQCdbHgnsSZ+TQqe
 iV/6Xy97
 qNKKgpNC4t3PpWHOp/AE6kzRTQN3T+tUh61KTEP4KA3axLsWScE/+yQvwtAtheNfr5yYUyzt1xUSicaaKb/ltlc2A4yB0hO5VZj6AG4rj+mrcs5QBudd6Tc74HsIo6SwGQVieHOnNJFGtwgqtXZ1/LXUsKN3NaJNUL8lB4sjIZPgUD+UVGH86DKNDplUjBVlnYGs0Zal8Y7vtrpm5ocpxaapGdSmJPEr2piKP6ix0m3GE1npBGCQ/aa62p5aDuE6zvHpgZzjBj6xJLJLMKdg1BY34HaPfVrjoCy5r3uzJCIbqw0UpMMWm3prXhDqjTtYw21+nvlbk7DRTEe7/RN+7L/aUFzdiay+lbe03
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/7/26 19:55, Kairui Song wrote:
> On Mon, Sep 7, 2026 at 8:36 PM David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>> On 8/30/26 17:23, Kairui Song wrote:
>>>
>>> We can keep it where it is right now, but this patch is moving the
>>> anon_vma_lock_write and i_mmap_lock_read into the two anon / file
>>> helpers seperately, so keeping the folio_expected_ref_count check
>>> outside and before the helper call will cause a potential higher
>>> false positive / negative rate of this check? Leads to unnecessary
>>> call to unmap_folio.
>>>
>>> How about moving the folio_expected_ref_count check into
>>> unmap_folio since the purpose of the ref check is to avoid
>>> unnecessary unmap? No more duplication that way.
>>
>> I think the crucial part (for anon folios) is to also check after we unmapped.
>>
>> See __folio_migrate_mapping(), where we don't do the !folio_ref_freeze() in case
>> we tun into the !mapping scenario.
> 
> If I understand you correctly, I think we are fine as is? The
> folio_expected_ref_count() check here is just a racy check to avoid
> the PMD split for a folio that cannot be split anyway, not a gate.
> 
> The gate is the folio_ref_freeze() immediately after unmap_folio() in
> __folio_freeze_split_anon() (only a local_irq_disable() in between).
> For an unmapped anon folio folio_expected_ref_count() is uses
> folio_swapcache_ref_count(). It might be worth optimizing, but that
> could be done later.
> 
> Or did you mean something else for the anon case?

I thought for anon folios during migration it actually serves the purpose *after
unmap* to detect any remaining GUP references (etc). But I might be wrong. I'll
look at v4.

-- 
Cheers,

David

