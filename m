Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7E42C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 12:29:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59452900067; Wed, 13 Aug 2025 08:29:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56C09900044; Wed, 13 Aug 2025 08:29:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A8D1900067; Wed, 13 Aug 2025 08:29:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 37EF7900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 08:29:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B8C84C0205
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 12:29:51 +0000 (UTC)
X-FDA: 83771665782.09.83B460D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1AABF40016
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 12:29:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vHwXqriF;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755088190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0FHvCqoOU7IJTLssb19/3USsvyxBr+M3aKh1KQYufH4=;
	b=5f1n5afkrsR2BMkNX9kTwup5d2rJ5GpB9P5JxS4N0/rjcIpyDSwn9TEeSrXEGS8pxH0WSh
	HkcnCOY/MW7nOfQxECz4ZrDmAiNs97WWEDxuSDS+hab1Zq/I0XSOxfMxjs4fJ3lrFgZPi/
	igNhYVK9vV2s14p8FdFqwVcNtbDIJNY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vHwXqriF;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755088190; a=rsa-sha256;
	cv=none;
	b=QqsiECBHX3KRx+nhTGzNYfSjguGSIY1qBSMoFM5mp27ooM9nbNhryUByycrym/wQYDMN8T
	maea9+eB7J9Yktyk7+tlmOlgLL1jKMorUtFObH0veHkVGUV7GH3Yq/vnpJQnACn7vDeWRp
	6r7dZLPq1ovmRsK9HBXCilEcuY2m/XE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 41D62601D3;
	Wed, 13 Aug 2025 12:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59BEC4CEEB;
	Wed, 13 Aug 2025 12:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755088189;
	bh=XNCAicR2gx/LNWLP2/epE+0fq3acPUIP+umvFC2d4yY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=vHwXqriFkxQ7EiVrUgjSioUks8rwkx4eVjDpZCsbSHDq2agW54WOykwGWuSGyuRoe
	 1feSAHqd3zG2GbCkNRD0nXt6zR/peMPDryianeLxZFn3X+1JRT+lCZ9XMNiU8LZe7H
	 s55az31uVyk5DgZCcqhGog+4sszkPWKka4iv7Ybqd51f1SLf1e6hFUK5mPZc0jUgOC
	 6SELeW6WDEpQa5okr1Bd+5wY18v++0zo0FE4Kgh4yXn5Ch2e/Fe5s+G/atCm3fjFOE
	 paqiDNZuuvFPJftHGAbMCc0ygAnNpvaB+ac+v6hUaftfBpTPghFjxU1hRmcKtPANFP
	 pohjVQJiItyag==
From: Pratyush Yadav <pratyush@kernel.org>
To: Vipin Sharma <vipinsh@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  pratyush@kernel.org,
  jasonmiu@google.com,  graf@amazon.com,  changyuanl@google.com,
  rppt@kernel.org,  dmatlack@google.com,  rientjes@google.com,
  corbet@lwn.net,  rdunlap@infradead.org,  ilpo.jarvinen@linux.intel.com,
  kanie@linux.alibaba.com,  ojeda@kernel.org,  aliceryhl@google.com,
  masahiroy@kernel.org,  akpm@linux-foundation.org,  tj@kernel.org,
  yoann.congal@smile.fr,  mmaurer@google.com,  roman.gushchin@linux.dev,
  chenridong@huawei.com,  axboe@kernel.dk,  mark.rutland@arm.com,
  jannh@google.com,  vincent.guittot@linaro.org,  hannes@cmpxchg.org,
  dan.j.williams@intel.com,  david@redhat.com,  joel.granados@kernel.org,
  rostedt@goodmis.org,  anna.schumaker@oracle.com,  song@kernel.org,
  zhangguopeng@kylinos.cn,  linux@weissschuh.net,
  linux-kernel@vger.kernel.org,  linux-doc@vger.kernel.org,
  linux-mm@kvack.org,  gregkh@linuxfoundation.org,  tglx@linutronix.de,
  mingo@redhat.com,  bp@alien8.de,  dave.hansen@linux.intel.com,
  x86@kernel.org,  hpa@zytor.com,  rafael@kernel.org,  dakr@kernel.org,
  bartosz.golaszewski@linaro.org,  cw00.choi@samsung.com,
  myungjoo.ham@samsung.com,  yesanishhere@gmail.com,
  Jonathan.Cameron@huawei.com,  quic_zijuhu@quicinc.com,
  aleksander.lobakin@intel.com,  ira.weiny@intel.com,
  andriy.shevchenko@linux.intel.com,  leon@kernel.org,  lukas@wunner.de,
  bhelgaas@google.com,  wagi@kernel.org,  djeffery@redhat.com,
  stuart.w.hayes@gmail.com,  lennart@poettering.net,  brauner@kernel.org,
  linux-api@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  saeedm@nvidia.com,  ajayachandra@nvidia.com,  jgg@nvidia.com,
  parav@nvidia.com,  leonro@nvidia.com,  witu@nvidia.com
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
In-Reply-To: <20250813063407.GA3182745.vipinsh@google.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
	<20250807014442.3829950-30-pasha.tatashin@soleen.com>
	<20250813063407.GA3182745.vipinsh@google.com>
Date: Wed, 13 Aug 2025 14:29:38 +0200
Message-ID: <mafs0wm77wgjx.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: u9wy7s1q1ssmg875b4g8dzi3oxqku4zq
X-Rspam-User: 
X-Rspamd-Queue-Id: 1AABF40016
X-Rspamd-Server: rspam01
X-HE-Tag: 1755088189-979503
X-HE-Meta: U2FsdGVkX19ecNilgAanlo9uAkDv81Abe61lriOGYIdge7MoZaM04PQtBM35Rb4m58OLWoTnDIh/UAAVC17tCaF30nCpQy4MYQgi3H7gTotRa5TXNAmxvAOPrUAPNnXzk/WVHKRJ6QzfGWcXgZREIpIB0GpWz4wVx6FjLUMinhDDwQ/qj3K6KMQZ20Y/UkuPs83oFW5JR7Cx4MfmKYFgWMvc0vyit2NAFpMRQCV8zI1lW4THQCvkGxNm8Hyn7JA9kcZ45tcdyEgc9mCSjiHt2jrc5bWf2wWVfXi6Kl0z+GUKYY1Jv1qJzTUvDs4+QAJ7/u+uU7pjPgJweG3HHI4mCgvt3PolojTZo767DpQoca+ms54C3KBVlc9Ck00eFm4lQRts5czI0MRj24DdKzjZjvGHTIqtFA0P8rxmSQa3cPk0u6Qm6u0DB6weV4GXqmJ9JNuy32YjcVYEg9FKXlECKNomFqJAfooSL6Cbbet/Gw4oqT7UHGfrHgvHRT4R3K9qxb7NmsorQ8hYeCbj8osOWw4tr8lVgrmbIFBk3W70QQT+ZP4H0yGoy+DHiSzbx9j2vEyYryhgAvMyyFIU8kitpyFMNbRuR/sCXWsnRtpeY91fWpR6qipOF5gVy4RSJs9z/K0tZ/Ik5jk2+FuVIg0OM6KBcZujAbvcJgYfnEWYnfeXOe3cub9BBytr6cF01AyP1y2Yl4gIgu16BiHwJraw1BbxOHwnmCjTHFqiwFtyWg7bmcVrMrYPp0UGgBTIBje3t+jKtPMR5lkIaVW6erg/7KqXiHGEAKJb74EmswQD3lirR1+FjKeq4ZlkTrh2CRVtAChDBDy6fCU0BCkYFeSpahSqXmJFOV0YADt3ERL6Ug3iFfCXcL2JRQxVTdSQJytSqdgRFqVQ+NVzXUmqK7YrTSx01m3ytxiZSXYWCFIIBnD6MoN/cci0aSTzVw28wM4+xmZWvOHG/MHIVt4Fz7L
 f2+zh3DU
 G/Yv5/vzZhc1kjbR2BO4pSApDrzdpGC3ftdS/g5pVERUpsF72MwRcdYl+B/eXvGtrTt2vzqqk0rPuDY8yIGhcuR6D0B4JscUbasT+Crh0nfwepKm1coAQxI55hlQCNafZwUB/4EIl3AV1Ifc3xyLozOvSrwDIsfSE8Q6DGKb6wwuIzpCoDyr4lCdzo8DxlP/vM/GSr96+88b+sdN6J7n2QKXu9aU3gReb6GzpaFBs6ZkVRRM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vipin,

Thanks for the review.

On Tue, Aug 12 2025, Vipin Sharma wrote:

> On 2025-08-07 01:44:35, Pasha Tatashin wrote:
>> From: Pratyush Yadav <ptyadav@amazon.de>
>> +static void memfd_luo_unpreserve_folios(const struct memfd_luo_preserved_folio *pfolios,
>> +					unsigned int nr_folios)
>> +{
>> +	unsigned int i;
>> +
>> +	for (i = 0; i < nr_folios; i++) {
>> +		const struct memfd_luo_preserved_folio *pfolio = &pfolios[i];
>> +		struct folio *folio;
>> +
>> +		if (!pfolio->foliodesc)
>> +			continue;
>> +
>> +		folio = pfn_folio(PRESERVED_FOLIO_PFN(pfolio->foliodesc));
>> +
>> +		kho_unpreserve_folio(folio);
>
> This one is missing WARN_ON_ONCE() similar to the one in
> memfd_luo_preserve_folios().

Right, will add.

>
>> +		unpin_folio(folio);

Looking at this code caught my eye. This can also be called from LUO's
finish callback if no one claimed the memfd after live update. In that
case, unpin_folio() is going to underflow the pincount or refcount on
the folio since after the kexec, the folio is no longer pinned. We
should only be doing folio_put().

I think this function should take a argument to specify which of these
cases it is dealing with.

>> +	}
>> +}
>> +
>> +static void *memfd_luo_create_fdt(unsigned long size)
>> +{
>> +	unsigned int order = get_order(size);
>> +	struct folio *fdt_folio;
>> +	int err = 0;
>> +	void *fdt;
>> +
>> +	if (order > MAX_PAGE_ORDER)
>> +		return NULL;
>> +
>> +	fdt_folio = folio_alloc(GFP_KERNEL, order);
>
> __GFP_ZERO should also be used here. Otherwise this can lead to
> unintentional passing of old kernel memory.

fdt_create() zeroes out the buffer so this should not be a problem.

>
>> +static int memfd_luo_prepare(struct liveupdate_file_handler *handler,
>> +			     struct file *file, u64 *data)
>> +{
>> +	struct memfd_luo_preserved_folio *preserved_folios;
>> +	struct inode *inode = file_inode(file);
>> +	unsigned int max_folios, nr_folios = 0;
>> +	int err = 0, preserved_size;
>> +	struct folio **folios;
>> +	long size, nr_pinned;
>> +	pgoff_t offset;
>> +	void *fdt;
>> +	u64 pos;
>> +
>> +	if (WARN_ON_ONCE(!shmem_file(file)))
>> +		return -EINVAL;
>
> This one is only check for shmem_file, whereas in
> memfd_luo_can_preserve() there is check for inode->i_nlink also. Is that
> not needed here?

Actually, this should never happen since the LUO can_preserve() callback
should make sure of this. I think it would be perfectly fine to just
drop this check. I only added it because I was being extra careful.

>
>> +
>> +	inode_lock(inode);
>> +	shmem_i_mapping_freeze(inode, true);
>> +
>> +	size = i_size_read(inode);
>> +	if ((PAGE_ALIGN(size) / PAGE_SIZE) > UINT_MAX) {
>> +		err = -E2BIG;
>> +		goto err_unlock;
>> +	}
>> +
>> +	/*
>> +	 * Guess the number of folios based on inode size. Real number might end
>> +	 * up being smaller if there are higher order folios.
>> +	 */
>> +	max_folios = PAGE_ALIGN(size) / PAGE_SIZE;
>> +	folios = kvmalloc_array(max_folios, sizeof(*folios), GFP_KERNEL);
>
> __GFP_ZERO?

Why? This is only used in this function and gets freed on return. And
the function only looks at the elements that get initialized by
memfd_pin_folios().

>
>> +static int memfd_luo_freeze(struct liveupdate_file_handler *handler,
>> +			    struct file *file, u64 *data)
>> +{
>> +	u64 pos = file->f_pos;
>> +	void *fdt;
>> +	int err;
>> +
>> +	if (WARN_ON_ONCE(!*data))
>> +		return -EINVAL;
>> +
>> +	fdt = phys_to_virt(*data);
>> +
>> +	/*
>> +	 * The pos or size might have changed since prepare. Everything else
>> +	 * stays the same.
>> +	 */
>> +	err = fdt_setprop(fdt, 0, "pos", &pos, sizeof(pos));
>> +	if (err)
>> +		return err;
>
> Comment is talking about pos and size but code is only updating pos. 

Right. Comment is out of date. size can no longer change since prepare.
So will update the comment.

>
>> +static int memfd_luo_retrieve(struct liveupdate_file_handler *handler, u64 data,
>> +			      struct file **file_p)
>> +{
>> +	const struct memfd_luo_preserved_folio *pfolios;
>> +	int nr_pfolios, len, ret = 0, i = 0;
>> +	struct address_space *mapping;
>> +	struct folio *folio, *fdt_folio;
>> +	const u64 *pos, *size;
>> +	struct inode *inode;
>> +	struct file *file;
>> +	const void *fdt;
>> +
>> +	fdt_folio = memfd_luo_get_fdt(data);
>> +	if (!fdt_folio)
>> +		return -ENOENT;
>> +
>> +	fdt = page_to_virt(folio_page(fdt_folio, 0));
>> +
>> +	pfolios = fdt_getprop(fdt, 0, "folios", &len);
>> +	if (!pfolios || len % sizeof(*pfolios)) {
>> +		pr_err("invalid 'folios' property\n");
>
> Print should clearly state that error is because fields is not found or
> len is not multiple of sizeof(*pfolios).

Eh, there is already too much boilerplate one has to write (and read)
for parsing the FDT. Is there really a need for an extra 3-4 lines of
code for _each_ property that is parsed?

Long term, I think we shouldn't be doing this manually anyway. I think
the maintainable path forward is to define a schema for the serialized
data and have a parser that takes in the schema and gives out a parsed
struct, doing all sorts of checks in the process.

-- 
Regards,
Pratyush Yadav

