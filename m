Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC33C606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 09:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KJ6PUV62
Received: by kanga.kvack.org (Postfix)
	id EC65F6B05B8; Wed, 18 Nov 2026 04:40:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9E3E6B05B9; Wed, 18 Nov 2026 04:40:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D65AF6B05BA; Wed, 18 Nov 2026 04:40:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2F356B05B8
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:40:59 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4F87D14066A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:40:59 +0000 (UTC)
X-FDA: 85447745838.13.04FCE6E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9BAAF100005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:40:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KJ6PUV62;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794994857;
	b=EuSM4ecO2R4sJafwvCnprb6PUd58/ErX9Ar2JKYkIuKsTUJeKuGfM1tLWOkbj+i+CCcnMx
	9SIIb+dHA9ehijPfxUUwo1KZBKBcN7lz4c+4JPG+9SL8tABSLxaRNiX42fWBDqYn4FL1kq
	yku419YcoJ5imcStugjUUyJ3kxnFTCQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KJ6PUV62;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794994857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ec0U4HkUVJSX9L9MyZXzeYkA6/IHQ00seYG0+mz4u74=;
	b=zzX07XrA35ocN1bxV0WYsdmjyzfPdcUjQBI/B6S4FT6eFntpiMN1vC90G9gD/2dxr7Vqhh
	M1OtjC5XFRqC6+2TQ0krrhwgvINMl5XbWUTkqQGRPaW8AwJl/gc8GUSruuDAx/EQYAXXXo
	lR83LH3KiD4zABQ5dIwUQB03dqVn7Fk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 373F86204E;
	Wed, 18 Nov 2026 09:40:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1BB11F000C4;
	Wed, 18 Nov 2026 09:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794994856;
	bh=Ec0U4HkUVJSX9L9MyZXzeYkA6/IHQ00seYG0+mz4u74=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KJ6PUV621t2eK5Gd4c4EeynJ0kIbkgTVZK/76IYhM0+gtvO6/c0znmcSzDjyfNF8h
	 pSKnG0Q0TbODfyVQnR1FlxNE0Ew1PAO3Awl1Z3CRIUvHYcERq8D1+P1eG6EQlrC8F7
	 eDo2hb+vilHkKcmeA8D7ikXn1Xz7VOPZx6ta4Mys+YmQ0N+BqwNtxx0YnINJXRo1hu
	 DCenhMOqjYuGs81iYBmB3Ik63Fc8ycNR9Lh8Mf1A2sirKs3eaVs2W3e+Ylu3MB2jdn
	 4O+5mRQkH9z3XxseghRTfsYKz566j2CtOfIZCpQJZFGNGHgAWGA82LAcR8mL4MIez5
	 fEyBMvUGcYYug==
Message-ID: <d6692c11-df29-4ab6-a578-f86712abbdcf@kernel.org>
Date: Wed, 18 Nov 2026 10:40:39 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 8/9] mm/migrate_device: do not migrate a uffd-protected
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
References: <20261117-uffd-state-fixes-v3-0-b617009d1a4a@columbia.edu>
 <20261117-uffd-state-fixes-v3-8-b617009d1a4a@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261117-uffd-state-fixes-v3-8-b617009d1a4a@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9BAAF100005
X-Stat-Signature: 4tynk4fi9gh46bbohho5xs3h5bcbc43s
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794994857-130671
X-HE-Meta: U2FsdGVkX19bJydX7QlpkyFVklpdABg+U1k8wO2uMPTgJnua42hpmAeS2/4QAwg14f2XGD0lUIx5jgPkPGDyIlKrlQr4tDAh5VWFMDGUl9DnDOG6UOwaUJAaMld+BmaSkjIAOagijYzEw5Cg2YGmDiX77im8mptOsl686Xf+AM3pdBzbQmimeu8UBI3J5+JluH+fZ4fG5GU1VGChFvUxhzO81vMeSc1ZH4ZrjybehK8BdeGQUO64ggeDS+sNfsdXJ09y4zSvc67fOApzvkbF+6B2wLk0UBEvcbhiafbf+f6LCb0AmuNg4XwJ6sraIqbB0XdJKKPHpD7zzt4908R5NeVRVUPvAnh8KZH2WNbny/EvnL2XVSMPXxqAWpi/5pQMp73OxZghd4yWHjdBkgaaYAzSvpauU4tUpkkx/WXdyUiZNUNdccenb4Ek47TZrJxG6GXAQs4GcOqeyqncD0FvlYKcp9pLz30mVBTlPXXghejBqoEeq47p5SNYL53t48YrCEfA5pERyVurQnPFT+gJJYz2YEDl0ObHaqxeMY2rCRUAPgtCRFCw7TlBAvUKW+mwImo6zz1BNhF8oPTyOSrp+uHtxX1OXui8HLJjRx5V0Qb1H9R/Ld3SKZOx1S3KOZCOhr4RDrHaHCib0vKAa8zNfNIlg811Akho/Lb8j5cURA9sfORvMdMmV4UYGDpFcE7zwYXdg44GkkQKL+Sp69WCrAVFaZulboi/huatGlzzSeRMx/Wvr5DocOogHwKwc43E+zzG2aS83zD35w8ZaPYcio7I9Tz8F0EjMK4HLM7jy4xfkDn/VG9xH1uHBxPTYj2rF0xqN4SjRdt63OgFwlBLh6olWXYW6hG7qSL47ax0ul/w1Z7lxKJ/OME6tK642KaT2Ex5+ss+yDmDyM6X3H9Q1x7OLNCwm9fGDaNwrZIDm/LCE8U8+YG4QJvaBQV9TZzJEtV72jl1Qa31to1Svxc
 B2hAYd0g
 mprHxKmvzjYAwRQFiDeFtTZvYJKfbDFB4Qac1CN8njDmslxIosYXUaDWJlY7eNhA9/Z3HOJ5YG1g/69X6GsMqTm530GqOW3AwpZ5EwVVKTED3PSE+Dy1FtskwnqehfVZu7JoC56tkZZMlNNvl09HPddrdUQ5rmFUHhIvdyzbHwuXxGjjVWMqKpUgzsITBfQNKdLMYxBLGQX5+14xsARku/KBMHnZEsHcvm5cxo0juaO5m5JkxjYVsibtBFroAJDtnaMOXkgZk7bprKnEDUV3os4WHcWUvvx1BisphVk81sHvBy0zmMj5W/9vcZqWLV8HtfAj8+O3TJ5wIMVZxEjjyiq5wvlgx1xCu7THzkkXUr3HgGl0CyuXjxU5f3LJj2KgKmd701LFG32UzTFepgWQlFDDAtW9nppGw40bo6s0nZrrPTUm5qAJot5Jvl+sMZgEARg1X5EPJI8sxw+0KMiVvdKh3yvei008d4pvGMBCF2GEfxF4lBc/Ew18A9yeB+wSmf1CXGOf5NOnO0QxW/fsUTccFFMJlM5x4j2w2hXqhBxrNgAYaXSJNSpcyrFCe+Hsz7++BVNWLY21Wb+5oK6SW1nKPsZ4CaLGZNL5/J0DPOh3MVrQRYKrRLFBeHN9v+FkzHV+mUP88z7A4/1U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/18/26 05:28, Tal Zussman wrote:
> Device migration replaces a PTE that maps the zero page with a new PTE
> that is built only from the VMA flags, so its userfaultfd WP or RWP
> protection is lost. The same applies to the huge zero PMD. Writes and
> accesses to the page are then no longer reported to userfaultfd.
> 
> To fix it, do not migrate a uffd-protected zero page. Skip it during
> collection, and check again under the page table lock before inserting,
> as another thread can protect the page after it was collected.
> 
> The alternative would be to carry the uffd state over to the new entry,
> but a uffd-protected zero page in a range that a driver migrates should
> be rare.
> 
> While at it, read the PMD once with pmdp_get() in
> migrate_vma_collect_huge_pmd().
> 
> Fixes: 292924b26024 ("userfaultfd: wp: apply _PAGE_UFFD_WP bit")
> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
> Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: Felix Kuehling <Felix.Kuehling@amd.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: dri-devel@lists.freedesktop.org
> Cc: intel-xe@lists.freedesktop.org
> Cc: nouveau@lists.freedesktop.org
> Cc: amd-gfx@lists.freedesktop.org
> Reviewed-by: Alistair Popple <apopple@nvidia.com>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

