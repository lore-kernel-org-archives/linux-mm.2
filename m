Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D972C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 06:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D9FA8E01C3; Wed, 13 Aug 2025 02:34:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18E7D8E01B6; Wed, 13 Aug 2025 02:34:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09E928E01C3; Wed, 13 Aug 2025 02:34:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EADD78E01B6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 02:34:46 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A89231A029B
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:34:46 +0000 (UTC)
X-FDA: 83770770972.27.AC56183
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf25.hostedemail.com (Postfix) with ESMTP id C691DA0004
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:34:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BdIAXwGo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=vipinsh@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755066884; a=rsa-sha256;
	cv=none;
	b=Rt7bnFs1ytisWFiENryu5Pyc6TE9zTtqLQdgXvapbYG1ouYG1ldSMIH/Q7x6RWg6kx+nd7
	06rbJQdidJZXy1BwPzV0V58sEMR1Jv1t06uzuycYGtkvmlJXpm/uLcTq5Yu0W02mf0u9P8
	OziFEyGFX7qu1ZFXw5Z9xkg+T0S/Cvo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BdIAXwGo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=vipinsh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755066884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lBz0ZD/446lYgybbXFehAqqU9nULcqKZHue50p4Cg4E=;
	b=Hd/gW/vx/Gn+qDiX2bDP6g3sLEKkru2MlmlBKz8Ly+koYYst5w7cF1AdM1/WYTj8ESss+M
	l3aL7W4EK8AgTeLPnjU7vRA9E0lxJI3R0HcvP+uajtW1ut8ffo7ECMp+ZLKB62vrRfEHsp
	s7+cLUwsGbg2OVblJFN/ZxlSMpsC8ws=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-242d1e9c6b4so145255ad.0
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 23:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755066883; x=1755671683; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lBz0ZD/446lYgybbXFehAqqU9nULcqKZHue50p4Cg4E=;
        b=BdIAXwGo12IStR/UlKHQtq1k36O4PuK58RC8FD31wJxBu94UF0LPLKCMQw5tUAkGoa
         QM7T1Fh6gRe5wQSdF2BbtNp/RVxMNA1w9NBii8wPBihQRxH3Jv8wozJmJjrPZqG0MKR6
         ppNlLhGZ9npq1nL5YQX4IjUBEQj7DyyRwA2iADghe0ff05ikQ/cqzRfQASuYfftEx4LB
         EJidlY7rdzcsYlKYNm9VQQnOYEL0+3nJEKQ5au3/K2KjfjVTolE2DlirlEI/geOFvBWR
         PPkP9CK9LWU5udV4QVVhUngX8u4KVwzioQd8+NZsAz6zPsdvLrRVYhoWWR/HNwits7Y5
         u7QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755066883; x=1755671683;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lBz0ZD/446lYgybbXFehAqqU9nULcqKZHue50p4Cg4E=;
        b=Ub46f9i6DrfS2eullAhL8+lpBqU0AJbQQS9AufIR8c7SV2oqaOrJDYAX3XRCc62RyD
         vqCC87G+lncMuf5xrNff4MVe1le2v4AvGPkADH4yDsMIf0JUNDa62zmBVrfEGh8m9LVm
         c5k9fp3qTE0LEZxVtKnkFPyRrntadh4HRdTVFKSFVVrYLRgZh8G2AloiH4LUCg9WJTNX
         78/jOf7teWW0jbgQOq37LbTK0lZXn6cTDsgSpzOIz7hxGMjYmsqN5rirXi+fmkx62M0O
         Se2SQ0lJRaVyWdOWfYGs9Z9/+ud579K80j/0lXywry+NCIOApUWTSqSkeRICumImJZmW
         OIzQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDXoC5hGin8BKMi8/fZO8vASR1WcPkCP0Cww231SeEqDhIa8cs0pDf9xpXTW2WYbINKXXtUK6IfQ==@kvack.org
X-Gm-Message-State: AOJu0Yx7ewWETgYI5bNxaECX8xLE2IgqnS9xRr6yNbJhJXREXfYxXkDD
	naLLJ/ouX9Sv1BG6mnouBU/wYSJ7qjontLVEqbgV80+p9kYVT3vMzGu2dS66c7Mdxw==
X-Gm-Gg: ASbGnculIRvlksHw3u3hJD/dAV1THpw/+CRToSYY9nMHCUlYFOxxsGPrMD2sTuFR2QK
	VYjT0Nt1115ZmAmkwzDPVncNEU3ATbiApvs59ZVsicnbQqEtK3OxW4Icw0uXPBICX9DtrCZu6R8
	lMSMRAkG3c22QZbp0+hguc+oIb8BPDQfu75WTTMSBX3hT+CJw3RFxrx809VFOBCA8Kwq/Lg4JEw
	x9SyrIUO2PC4FfH9QbhmLvrslvNycD8QKiH+jLfBh/U7VL5T4wQIcs9AncBaphWLk6Op/JC0IzH
	vZQaIoRFBG7PSfqQHw6AVuyK9Da/dfpevygosv+0pswcFmAeplDEDAPPuwY/S6ycPKaOvNGR5gq
	qSRbtGi1N7l8w4y+cTbnSIudLitF4wnwDKIcAJAN8jgEQTCH6KOHLcqEG6ykTaMgbSKk=
X-Google-Smtp-Source: AGHT+IGFb0xX7B2Q6MyY6rFw3BXv1hxo5YhlKW11olCnEO5GfmzQ9WNDztxD1sYVpPXUsxAdW3d/ig==
X-Received: by 2002:a17:902:e746:b0:240:6076:20cd with SMTP id d9443c01a7336-2430e55bb17mr2238135ad.15.1755066883155;
        Tue, 12 Aug 2025 23:34:43 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24303d5e705sm30477375ad.14.2025.08.12.23.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 23:34:42 -0700 (PDT)
Date: Tue, 12 Aug 2025 23:34:37 -0700
From: Vipin Sharma <vipinsh@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	changyuanl@google.com, rppt@kernel.org, dmatlack@google.com,
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com,
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org,
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr,
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com,
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com,
	vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
Message-ID: <20250813063407.GA3182745.vipinsh@google.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-30-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250807014442.3829950-30-pasha.tatashin@soleen.com>
X-Stat-Signature: t68yjrdiup347k35pnq3hruty4fgzbeh
X-Rspam-User: 
X-Rspamd-Queue-Id: C691DA0004
X-Rspamd-Server: rspam02
X-HE-Tag: 1755066884-803407
X-HE-Meta: U2FsdGVkX19HQ5FIAIe27TNOOylmIwIHd6kzqXstyYMlaOoAXyt584LH2kMPCY911dU2EEX/wNut1BrOjPl6s/VV9JSBsi24O2UIUj5V10+SSRSUIMBFe84DHCgT3gp6sZlSHsOw1ENUWF/8uVxfNmMy6RbnqLXYCaIAHNMTPgtTYizQd0pJiX0j+yWd5bMp3cAUaPCofOqAAUEkImhqTM4foaiUdlYOD0xjJvDUOwjeGCpj5lRZN1wvbuQj3Qm8nCO3ds4PS/r0loS8jBu6vulbVkmeUJeZsA3SprluVn89rGYzfNj/pK5pT0HXducFmUC2zs3G1QcEkPq7vvj1JXyuHaUKDLHcQGjTdwa/UabTFuDU3KH5fJxsuCtXK2C8wO78Eb0vWjRW9aNzukrkoFlUZ37rWAWAdl+3KFrhdQIotYLFrH2ZYSo7eTL8ksm0rujcJ5BnEJWEgJE95gYxC4g1qhHrbInnzrGXhN0i/VQj4P45Rg7l9TSweTaPC05dt8k6atUl4w34LkFNCAVBaJZNk/Zw4L2yi09PTHXarxskr/UXMLNPG+3MAeu7RUXbkHW5Vo4JvVK7NcAzFAN3XDGDdf7K9QWcxztZGTGEegInJLfOKuBqJu+MBTn8ENOxGV84PSr5wXBXNDGESOe25aCK3sMal9PpeClVKF2lco1+lWpUkkToVeOg+Xlh1gWmCtIuqVvErFmnbNR1FJY4eB3i3QAqmiDcY+wMZavQNgmnUXrZ+E4cIuggAxMumcAjRmv2qp4dFKm1XTTqTtR8Zc913v3ruqlLV4EiRUOau+HFbuy+N9gXIv3iTxApl6Z1P2U6b51yUmND1Lxnn77EfBqqIUGsa5S2tN9j3hcZ4sboRIZAu3yW+ZgWBU2R+jh6rW3NMPrnRhVMqqxsXtp8MwI7IEVeq/+FiQzQgUvJQ+RThsIkwOh4rCVZXkdeCo+yQenZpHnqjUxeshOjICa
 FG2bXCaX
 PnAOCTm5zPlFwVb1/j3e10LlhE/3+4VJYEBXfV87xwstobr5fXX3x3LWlB/W64xCjdBcFNbBeetUYnixf9Qvtk/6s0pDFAvUtE4qL5lxFJju0cruACUBxJpqL9/y+3acnrzTp39b4qT4gacOUt+pmULmKPcXti/ugpfcxJ5oW8Ap6B2oxdNrwquLHhun+9NanAxkS/ccXECcejQDmqo6fIXObm6q9XqXhsmISJ0lFvSlImryYHwZsGyxzle3HgwXHnTvvR73H5SyYDlzchXYe40Cau4P3Na+PlYBi849krTI3TRDyAtYKck/4jZjtptJAQlBjnKXrRHpT6QzM3/2oYoV5KU1wDadlThJ+AIAoeG8zZNciaFRTGo4LeRby/pZNqjO6hTA8zi9jnPCXGoU6T6kUVYXG1QkMhYzKmDRbNZ2gqxv4TpF1cO6AIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-08-07 01:44:35, Pasha Tatashin wrote:
> From: Pratyush Yadav <ptyadav@amazon.de>
> +static void memfd_luo_unpreserve_folios(const struct memfd_luo_preserved_folio *pfolios,
> +					unsigned int nr_folios)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < nr_folios; i++) {
> +		const struct memfd_luo_preserved_folio *pfolio = &pfolios[i];
> +		struct folio *folio;
> +
> +		if (!pfolio->foliodesc)
> +			continue;
> +
> +		folio = pfn_folio(PRESERVED_FOLIO_PFN(pfolio->foliodesc));
> +
> +		kho_unpreserve_folio(folio);

This one is missing WARN_ON_ONCE() similar to the one in
memfd_luo_preserve_folios().

> +		unpin_folio(folio);
> +	}
> +}
> +
> +static void *memfd_luo_create_fdt(unsigned long size)
> +{
> +	unsigned int order = get_order(size);
> +	struct folio *fdt_folio;
> +	int err = 0;
> +	void *fdt;
> +
> +	if (order > MAX_PAGE_ORDER)
> +		return NULL;
> +
> +	fdt_folio = folio_alloc(GFP_KERNEL, order);

__GFP_ZERO should also be used here. Otherwise this can lead to
unintentional passing of old kernel memory.

> +static int memfd_luo_prepare(struct liveupdate_file_handler *handler,
> +			     struct file *file, u64 *data)
> +{
> +	struct memfd_luo_preserved_folio *preserved_folios;
> +	struct inode *inode = file_inode(file);
> +	unsigned int max_folios, nr_folios = 0;
> +	int err = 0, preserved_size;
> +	struct folio **folios;
> +	long size, nr_pinned;
> +	pgoff_t offset;
> +	void *fdt;
> +	u64 pos;
> +
> +	if (WARN_ON_ONCE(!shmem_file(file)))
> +		return -EINVAL;

This one is only check for shmem_file, whereas in
memfd_luo_can_preserve() there is check for inode->i_nlink also. Is that
not needed here?

> +
> +	inode_lock(inode);
> +	shmem_i_mapping_freeze(inode, true);
> +
> +	size = i_size_read(inode);
> +	if ((PAGE_ALIGN(size) / PAGE_SIZE) > UINT_MAX) {
> +		err = -E2BIG;
> +		goto err_unlock;
> +	}
> +
> +	/*
> +	 * Guess the number of folios based on inode size. Real number might end
> +	 * up being smaller if there are higher order folios.
> +	 */
> +	max_folios = PAGE_ALIGN(size) / PAGE_SIZE;
> +	folios = kvmalloc_array(max_folios, sizeof(*folios), GFP_KERNEL);

__GFP_ZERO?

> +static int memfd_luo_freeze(struct liveupdate_file_handler *handler,
> +			    struct file *file, u64 *data)
> +{
> +	u64 pos = file->f_pos;
> +	void *fdt;
> +	int err;
> +
> +	if (WARN_ON_ONCE(!*data))
> +		return -EINVAL;
> +
> +	fdt = phys_to_virt(*data);
> +
> +	/*
> +	 * The pos or size might have changed since prepare. Everything else
> +	 * stays the same.
> +	 */
> +	err = fdt_setprop(fdt, 0, "pos", &pos, sizeof(pos));
> +	if (err)
> +		return err;

Comment is talking about pos and size but code is only updating pos. 

> +static int memfd_luo_retrieve(struct liveupdate_file_handler *handler, u64 data,
> +			      struct file **file_p)
> +{
> +	const struct memfd_luo_preserved_folio *pfolios;
> +	int nr_pfolios, len, ret = 0, i = 0;
> +	struct address_space *mapping;
> +	struct folio *folio, *fdt_folio;
> +	const u64 *pos, *size;
> +	struct inode *inode;
> +	struct file *file;
> +	const void *fdt;
> +
> +	fdt_folio = memfd_luo_get_fdt(data);
> +	if (!fdt_folio)
> +		return -ENOENT;
> +
> +	fdt = page_to_virt(folio_page(fdt_folio, 0));
> +
> +	pfolios = fdt_getprop(fdt, 0, "folios", &len);
> +	if (!pfolios || len % sizeof(*pfolios)) {
> +		pr_err("invalid 'folios' property\n");

Print should clearly state that error is because fields is not found or
len is not multiple of sizeof(*pfolios).


