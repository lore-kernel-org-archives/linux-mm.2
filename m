Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D631CED61E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 11:31:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFC536B0032; Tue, 18 Nov 2025 06:31:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD4136B009D; Tue, 18 Nov 2025 06:31:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEA8E6B009E; Tue, 18 Nov 2025 06:31:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9BDCA6B0032
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:31:18 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2B16A5939E
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 11:31:18 +0000 (UTC)
X-FDA: 84123511836.26.AC96D1E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8BAB68000D
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 11:31:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fdNW3Shx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763465476; a=rsa-sha256;
	cv=none;
	b=eIFAPX15D9txnzQs7ZGbHzwLvUzk7Rbido+i2AqPbOQ4JzLo+Msf/kP/lAf95pNR1D2Khu
	8P7IBwgjU/mUB+Fj7ir3K+mTkCioTceciYkzdqtwTtuEcwLk/MKBefcxJcDYq1JOTypuUz
	ZG9wl9ol3aIIvoAW6OQa8NcUdQF7qCY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fdNW3Shx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763465476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ibr3xAhoDfdFCW/X/GhjCo2lt7F93CYizqOzxoO15jo=;
	b=60+QeRhiA6X/43IlJhoRv9l9qfT4Yhhbs208vuE/SHWbrdb46Bu4sZ99dzeJ2gQ5ON1bBt
	ns7DC9rePImtWXv4WWgQG1la0V+y2Fs/QpnYaCNAD9dL4OdxY5Cvm7YghJo36ej2AAUcGa
	7AZOuIN+KUme62qr0qDdmRd5Fxd6NrA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DE74560618;
	Tue, 18 Nov 2025 11:31:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F6BC2BCB1;
	Tue, 18 Nov 2025 11:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763465475;
	bh=TDbb2U/vh1bt7ZPBFidhpKgCXs1OsPq/ve44MJ2AfpY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fdNW3ShxByK3KPJ6f/r4xo57HHF29jYKzlWJMzAoEG5qhL4vUeTW7q0vODegzHk7x
	 Fcht3rxnbZ0AavV8SEB946ijmPMW63uMz1a6R3WkynBS68yVMJHaDkrh5Vi2CJxKij
	 mL9IWsuiO1hWsOgISGtBoNd7dui5+O7QMhgUupFQl+q75AQCLry25dVxM7lSoo5bCX
	 myydjdFJZlkHu8XkDHAhal5Sn5XDPCIw+PLb82EM6sTiT7UHDrQDrG8g3phkrgwzHz
	 JLOWWFQitPFaMb1HLyyXjecgPX26uBVyuXrodjRAsemgX7QeO14EYdKbQE9Bq8GUpJ
	 QFR4M+EFzMI8Q==
Date: Tue, 18 Nov 2025 13:30:47 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
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
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v6 20/20] tests/liveupdate: Add in-kernel liveupdate test
Message-ID: <aRxY53gBbeH-6L0Y@kernel.org>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-21-pasha.tatashin@soleen.com>
 <aRsDb-4bXFQ9Zmtu@kernel.org>
 <CA+CK2bCfPeY558f499JHKN7aekDzsxQkZJ9Uz4e+saR0qtXyfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CK2bCfPeY558f499JHKN7aekDzsxQkZJ9Uz4e+saR0qtXyfg@mail.gmail.com>
X-Rspamd-Queue-Id: 8BAB68000D
X-Rspamd-Server: rspam07
X-Stat-Signature: kg77gf7xmy6o6kkf37kqg17jtc6kcp9d
X-Rspam-User: 
X-HE-Tag: 1763465476-526249
X-HE-Meta: U2FsdGVkX18bLP50+vG71dUSaf0SDBYviOOhbtR2l+nnsFRt5DGT15MEvEIqKf0viGjR6CAn+rIjRNFzDOMY6uwfSAi6gFSSHETBSPIvdQc793Rmbh1s3iSWWOTgku3ji2K44us5mmWKqgwh2nG3aD1jyODUfCNnIrTwa5tH/7fza7v1eIbWUs79OIfsruZL7KO2MOyv/onFkdjFQ3c78TZyD4nct4Tv7wItZOvjjNlIIr9fcMbaJCcNM7YEu4pJ9KOVhh/1eAoPgguFVEP182Z1DvDSIYmqcixrdek3nbB3VJkuINKRjTk0WLqMdcyk/FVl1seR5hT2WVyzi26T0Btct6UXQN3tlUXdnTkTaNdWWcpC62FKnKCTU7Rf6gP66FCrna4iB+OR8pfQ46iHof+fPDDQPgcsP5iOSgUmEik0XdjVCD2QQ1pbJzQTzzgo5rbncBs8M6Luxs6kfMU55mf+GNrykQDVF4FmYVGrP+pq9trDef4+nZONxSdAJoZOrpGZglUdnfVFzsJNYbPauUkRhqEm1QKusMS67g7AeRp9Vtl3ke1EtxpNuSNsKQ3BCECP206WvKR2MYTA46m57xt9RuW6RpjROyzToj7qJ1we0LkLzSneSYFUw8mcCxhqvFuftRYgatI+QPna5XAmShEVYMnipG1j7Y17ZrbNwwfRjfXfeQCRF8zlMt0zKgfwq3NiVZpcGRxI6kOXw0jKT0um8ALSwY3L0AbmCH3CBEgcAfPGDK1jfTcc5HD1xVjtYbvwbskPFbB9lPig2y1mPSiGAdYhgRbPiYQjvXaqhWxQJBFAoBOmRay8b9ShmZRPd7lCW3uOP3QGVtsdbkHXoTvA8TqWK460h9K1hMvCHtQXH8nb1D14srwJsuMDmyeIwWVvMuhL79OuIzWISOZ91xIKSoq3oYivsCRfRGx531JKddqBN1WaeaWWq9IgifwbIkiD5myciYFJLPiAyq3
 jv4nfIJI
 isPvpliW1K9UogJIldqRCxH7YcFIhrJnxZNRbsK9Ooj1N2ZjIX13sRL9HE927ORZhtvChCTvk0yXf51Z6bdGWBhRHDCyW7ySTl7y9SMhj3z2HDrcVMUN3689Wtu8tzlqU/sfnvIvQtkGeJDJ5iFDTKqo4b64LiwyZQ6C36v2odqoQkStQN+2MftBLBWk7JsifqS6s91OrihyZU1eJMPHfV0n8tgu85FFR0C0xny44ZmC62FOd0+Bj2NGGvsrmxPgEp4st8scDStts0qJEdG5L5z7qLQwJzb7er0jh8T4fWj6gfJkoj5H/4tFvDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 02:00:15PM -0500, Pasha Tatashin wrote:
> > >  #endif /* _LINUX_LIVEUPDATE_ABI_LUO_H */
> > > diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> > > index df337c9c4f21..9a531096bdb5 100644
> > > --- a/kernel/liveupdate/luo_file.c
> > > +++ b/kernel/liveupdate/luo_file.c
> > > @@ -834,6 +834,8 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
> > >       INIT_LIST_HEAD(&fh->flb_list);
> > >       list_add_tail(&fh->list, &luo_file_handler_list);
> > >
> > > +     liveupdate_test_register(fh);
> > > +
> >
> > Why this cannot be called from the test?
> 
> Because test does not have access to all file_handlers that are being
> registered with LUO.

Unless I'm missing something, an FLB users registers a file handlers and
let's LUO know that it will need FLB. Why the test can't do the same?
 
> Pasha

-- 
Sincerely yours,
Mike.

