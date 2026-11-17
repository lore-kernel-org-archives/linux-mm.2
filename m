Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD1F9606A323
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 09:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PKTIhaGa
Received: by kanga.kvack.org (Postfix)
	id DD4906B00EF; Tue, 17 Nov 2026 04:58:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DABF86B05B0; Tue, 17 Nov 2026 04:58:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C73B66B05B4; Tue, 17 Nov 2026 04:58:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A2F5A6B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:58:18 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 43C7C1C2B4C
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:58:18 +0000 (UTC)
X-FDA: 85444160676.21.39043EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 86D1720002
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:58:16 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PKTIhaGa;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794909496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3LgsglAFrX/+u6sq+JUPf5c5+f8fmRKk1XVeo+aF5S0=;
	b=6WbSn31hby0vojHp9ItU0wU5b+hvqED8GtGL6TSgluIv4sMIAhD92lDwlz4HFp+/GpPS/Q
	rdmRZ7UwImoQ3FQ9hb5MZw5ZXZiQuyZGY6yfeNMCeY2FK+XyK7gCtu3iTJ84vzeSN5Rs6s
	PhfXKn30nb7o53lTiD/hZeXYBTLELO4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794909496;
	b=RNd8Zcutu4GDDd+JB+yo9+IsBFNFPUeax7bZw3WO49TlmWAQX1GyEqPD7veZo5j74EmagI
	U2ruzi+WuFEjDKoK484h2GAaNnlF3VxqPuCgsQX/5FZiJxISSIB3Typt/yIrg+Jep7+VVP
	iYnCFUgC6N63ESXyJaDllVIWjVtcSP8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PKTIhaGa;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F0CA461D08;
	Tue, 17 Nov 2026 09:58:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD77F1F000C5;
	Tue, 17 Nov 2026 09:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794909495;
	bh=3LgsglAFrX/+u6sq+JUPf5c5+f8fmRKk1XVeo+aF5S0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PKTIhaGaFJjS8CEuxmoycngekpxqyTVDnR+ZbXMPkZLRz4ltzKBzyYbM81DD7kjQp
	 dJko9j4wHxkttt7vMNmlyiiUPmk6J0+SNRfMMI43e00Q26u/3Zs4SU9IDyENJJCN27
	 0y6HGdbRJ/Pgc8qqTqPRtz/M9tbjAqGvfP3adIBD8UGiRZrpj8LwM74cWF9bM9Ga9G
	 deU1O6u/09nFGfMVdsjWFGVDoE+32ZqEozAehWGjEOzwf3+SpXXWsWVQjmE54Nu9xy
	 ZyDBWs2rwIBJJ63aMdREtpHzjfvEIv9d9d1TbHnsu6uvOD39NXSmHfWxu6C3eTTsn8
	 mhBQ1FxH7fAKQ==
Message-ID: <c368f4a2-aaf2-49d0-90d1-0bacc9950967@kernel.org>
Date: Tue, 17 Nov 2026 10:58:00 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 8/9] mm/migrate_device: do not migrate a uffd-protected
 zero page
To: Tal Zussman <tz2294@columbia.edu>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Peter Xu <peterx@redhat.com>, James Houghton <jthoughton@google.com>,
 Andrea Arcangeli <aarcange@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Michal Hocko <mhocko@suse.com>,
 =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
 Andrei Vagin <avagin@gmail.com>, Muhammad Usama Anjum <usama.anjum@arm.com>,
 Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 =?UTF-8?Q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
 Felix Kuehling <Felix.Kuehling@amd.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, dri-devel@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, nouveau@lists.freedesktop.org,
 amd-gfx@lists.freedesktop.org
References: <20261116-uffd-state-fixes-v2-0-4397a0196479@columbia.edu>
 <20261116-uffd-state-fixes-v2-8-4397a0196479@columbia.edu>
 <a384d75c-2134-407a-924f-ee511f65a2d1@kernel.org>
 <71aa028f-c753-40d5-a8e4-8daef5aea3aa@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <71aa028f-c753-40d5-a8e4-8daef5aea3aa@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 86D1720002
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: ezyx6qyg7fubf39bnub348468p8d7yy8
X-HE-Tag: 1794909496-539967
X-HE-Meta: U2FsdGVkX189eIb+z19cimCIjVt/7gY8l5D8vtCuxAXtLcvx6Ig6Vv0sYtmpti5OnCKiXGh01LESrT4UGfyY2ubFL1UviDV9ztok7TTDyym+T/t5SWZBXAmIGcFAh3GRTGXWj9p9m6D82qbHFmbVpiIVMbZU8uqjzlygNgijwX/aEqVLeAHnJTstM/jVoIzHW4J3iTULZlm9QgsfkJIMUyrCgqZKOUVks1tSRc57WzuYAgPf4L6m9vgFoYytRYUVUxwXKGZCBikoaSTjzHQCTEodw7IhW2l//ATqpz/RoyWGw8ktge7oji6CwK+zktQZvpBR4de+P4VVGAcnY1PSiSEYFKSCITXK4WHy7kVJZPEcjkk7I25gd32Y25/aXD9PCnhUGPF1gcD8zod6D+WPpR+W7FgiKcloMd63oI1kC+qizpogWRQC2Cj9yozi5to3Jp17YzdHaRsMw1ft9Abrs70dtpDulAUK6RtW+I4ZFi7afEppua4OQ1Oiuatz5AnZ+ojR4bIMeMwks+0MlvCzKsbQt/HpfUe5lcmRJbD95B3d4i9td9urFfIRjCBZSld/pgVi0CwjtIh2m6gQWuVIeAt6zWZF3ILq7KRSrpLsNcyxMrG/+a8A4lQrU5bVVNO3xd6JZ895M3xvOBWalvrLp8O9szABcWV5RziZgS00ntYQ/bUJwvih0Iqfo6s7JAm8j0rmvl3vgms/McoDeLfFg/rCZ7s45yv5siZPftoWTVUA0974Rwc4cWArS4X/H9cR2bfTeb+vqW1VLxeJpHS27tsV++IHrKYeVSYRtSgXuUF3lJnE27lnGvvm+jDU8vsODpEmq+zNQDSqFWyC1mdxVZf+GQvjP8HeMhXK6PF564SAFoEZVsRxup0YehI7esfmUWEuSraxZV8HV0X9I3tjGlZGZVx7YldWoOcvu9Hmf0WIxzcfL59JoNzbC7QZRTOyw3awXGoWXGXtrumVvFg
 s4k367+b
 B2366seYf54lLEXX0zytYYx7yfGJhXk0/sStTBGSLI7SkB7JDY1/7/sTQDZ9ljrFt7vO64zcWkm+oFUF7074J9VisWM/jDBOTihd3vvvsMSLBnV0XKFO/fu4/i8/f48m+Iao5tq6I0XNGR8OQE5Max6HCw0Z/Ei4WA/z1th8CUwjScwGNfvWIgbGRQMDNu0dJ+cDpci5Xu7rP42dFGo6kayJ4XUwty2J66aV4emlY4DreqfhzIrV8wv00NFiAiGAzAhLtgMilY8iNpO5NQza1FCFLLkAK1KkTRvp1TWiZ61fmxrBW+ZiVEidsOYgmwZ2X4ORMFQzdafkPl8CjD4W2t+p37MGjYsMSVtW3QfLp1BT6Y8TGvcEYLWZXKY3X/5nlNJclhOzTRp4fbcDFlt8QSE8VhsQcUvpS6AVSqYz70Pw5Re2hHstrIWQIvyV+cjBZOL6oggKA4oypd7gYdhXnHbmaeDhcjF0rSSjeGnHVgM6rxw/Yschw3IqjzNVcyPCZBZ5PhxKhXoXLB/q8v8j9H1MisohisBpOzFHM9R4l0ksBd0CucdVQtUWRdqvAxZwLbVuj84JbTiIYGDEGRINPjWd0Yce0DqNNQyixavbWifUEsls1ORQdB2Md5BKivH3nehTnk9Sxvm2e/Fw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/17/26 00:06, Tal Zussman wrote:
> On 11/16/26 3:45 PM, David Hildenbrand (Arm) wrote:
>> On 11/16/26 21:02, Tal Zussman wrote:
>>> Device migration replaces a PTE that maps the zero page with a new PTE
>>> that is built only from the VMA flags, so its userfaultfd WP or RWP
>>> protection is lost. The same applies to the huge zero PMD. Writes and
>>> accesses to the page are then no longer reported to userfaultfd.
>>>
>>> To fix it, do not migrate a uffd-protected zero page. Skip it during
>>> collection, and check again under the page table lock before inserting,
>>> as another thread can protect the page after it was collected.
>>>
>>> The alternative would be to carry the uffd state over to the new entry,
>>> but a uffd-protected zero page in a range that a driver migrates should
>>> be rare.
>>>
>>> Fixes: 292924b26024 ("userfaultfd: wp: apply _PAGE_UFFD_WP bit")
>>> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
>>> Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
>>> Cc: Lyude Paul <lyude@redhat.com>
>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>> Cc: Felix Kuehling <Felix.Kuehling@amd.com>
>>> Cc: Jason Gunthorpe <jgg@ziepe.ca>
>>> Cc: Leon Romanovsky <leon@kernel.org>
>>> Cc: dri-devel@lists.freedesktop.org
>>> Cc: intel-xe@lists.freedesktop.org
>>> Cc: nouveau@lists.freedesktop.org
>>> Cc: amd-gfx@lists.freedesktop.org
>>> Reviewed-by: Alistair Popple <apopple@nvidia.com>
>>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
>>> ---
>>>  mm/migrate_device.c | 23 +++++++++++++++++++++--
>>>  1 file changed, 21 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>> index 9e19fadfa65c..140b99f72508 100644
>>> --- a/mm/migrate_device.c
>>> +++ b/mm/migrate_device.c
>>> @@ -159,7 +159,16 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
>>>  
>>>  		folio = pmd_folio(*pmdp);
>>>  		if (is_huge_zero_folio(folio)) {
>>> +			/*
>>> +			 * Nothing carries the uffd state of the zero page
>>> +			 * over, so skip it if its uffd bit is set.
>>> +			 */
>>> +			bool protected = userfaultfd_protected(walk->vma) &&
>>> +					 pmd_uffd(*pmdp);
>>
>> Now that I read it 3 times in a row below, these needs a helper.
>>
>> userfaultfd_pte_protected() ? userfaultfd_pte?
>>
>> That might help you to get rid of the local variable (that should have been
>> called something that includes uffd and should have been const)
>>
>>
>> Maybe just add a simple helper for the pmd as well and use it below.
>>
> 
> Will do. I'll do userfaultfd_pte_protected() and userfaultfd_huge_pmd_protected()
> to match the existing wp and rwp helpers.
> 
> Re: the local variable, I'll rid of it and just call spin_unlock() in
> both branches, which is a little ugly.

The clean thing to do would be to read the pmd once using pmdp_get() :)

-- 
Cheers,

David

