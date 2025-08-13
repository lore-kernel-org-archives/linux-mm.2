Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 973E1CA0EC4
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 07:10:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35FBB8E01C5; Wed, 13 Aug 2025 03:10:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3376F8E01B6; Wed, 13 Aug 2025 03:10:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 275AA8E01C5; Wed, 13 Aug 2025 03:10:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 166208E01B6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:10:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6FA70C02B1
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 07:10:01 +0000 (UTC)
X-FDA: 83770859802.01.B95293F
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf08.hostedemail.com (Postfix) with ESMTP id C31F2160008
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 07:09:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=NocSEfYL;
	spf=pass (imf08.hostedemail.com: domain of gregkh@linuxfoundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755068999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I/FjFoR66bKo4nWo8L3eV43PGq48lUZieBHJNBbCZgk=;
	b=HHuIJ0pEJ+GAP7wcm3byD35hvaqomvIu/rhgRKuyoE6T0s7W/URIlxXNbGU+TNJbsjntKb
	leBTeyHiuzHqZ13RDWoJslZlmc+1oadqMOF5I/j2trb30CJQ8MoU/Q7qHQsC+sLqDNqYRs
	hdwy40bmWuLOT3QTLmO+8cZRP1Oz0q8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=NocSEfYL;
	spf=pass (imf08.hostedemail.com: domain of gregkh@linuxfoundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755068999; a=rsa-sha256;
	cv=none;
	b=3OEdt2eIAJF3P4jdQISS3lTga5NEEBDvza8cHM7IE6qxkrYWOL8t2Gfp/o9bI9cpOp8ruw
	j7Fng/mPvTcSjXT1PhgMYI+CwFtKAEUbIjSA4XjnOdRNcOG4EaACaQ+HuqGoQMx/tos51e
	rLNtClY+Oys+mBcAbR4h46olEmIjXw8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 794165C67B1;
	Wed, 13 Aug 2025 07:09:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA26AC4CEEB;
	Wed, 13 Aug 2025 07:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755068998;
	bh=qYxBarsfIxoqtVOdgyZu0XSkWfI2wWyZlaofZIWXx50=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NocSEfYLe30ZRY2fHD2eMr9WqjHVuC9F/px//tLPS15SsrzoG9iv1HwM8iQDKE67S
	 ZqIZrwB6jm/9KKfam0/4WZbDHX0t5+hxCiBriTSU8w8f0hqWmVGvbCFp0w4JQSDEvS
	 7dYDYI0kpYCmumRuzXCuANSWpidAV9iKz8KGjkmU=
Date: Wed, 13 Aug 2025 09:09:54 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Vipin Sharma <vipinsh@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, pratyush@kernel.org,
	jasonmiu@google.com, graf@amazon.com, changyuanl@google.com,
	rppt@kernel.org, dmatlack@google.com, rientjes@google.com,
	corbet@lwn.net, rdunlap@infradead.org,
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
	linux-doc@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
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
	leonro@nvidia.com, witu@nvidia.com
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
Message-ID: <2025081310-custodian-ashamed-3104@gregkh>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-30-pasha.tatashin@soleen.com>
 <20250813063407.GA3182745.vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250813063407.GA3182745.vipinsh@google.com>
X-Rspamd-Queue-Id: C31F2160008
X-Rspam-User: 
X-Stat-Signature: mh9w848nurdfxiuk497qe9umcoszzoyu
X-Rspamd-Server: rspam09
X-HE-Tag: 1755068999-616154
X-HE-Meta: U2FsdGVkX18cWn8GHD9v8yhkq0uq6r0/mjNiv1DXGYizx/unomPinADWtutZzNAq4lEbtojwGGvmSKJTHNHj78ALPTIrCGuZ/wd4y34aeRzRSAqdpf3Uj82z2QdHVcpt+5PBnP5GiNk5uflVfWztVi2Jif/mykvhtQG56eXCciCeE0ZljsXzLMGPjl3KOGhrMdZD1Jlb8bU1hIuT8wkWb3B9iSUq6G7OrWFux04BnCEXnKbiZvHYFiDlFiuqNKY+VULoD42uHpPN267/2vRujU6y87esdy0yAGkcF1gmZcw5vEKxtImnvQzz8oVpxBprOSp0or5aQQBgjIIjLLMy1ulMUsBgElO3hGVHo6lbfcFjuKFlq+wwINtoPmWGkIKZjALx+bAEraBHJYCly1+FEfFoXm8WGd2LoO/u1Fkw8KtwEosT4GQ/WotSHQTq3N/8bb+OU0ml8V7z+pUxjGBCE1haaLjwxED1t1IIFF/uQExfubk6eEBXdL80pB538erGf07B/Seyn4XFnxYWtkEl5xoFJnTrGv14Nohft4myKhMhhMnQyjUNfP2pi9MMyU8d+sxHgWDsRj9uUtthY7D4XYz731JGElCzO4jJl462K7CXVUeTErXv1gzTjg0IGmmfnQKJD7fPamIKwA7zb1IeTLWfQGZeCy4kLQaGx9xgvtHLWd/UTxQWwl8ntndsrOcwjTe+i7vrG/a4lc30tcT7Xryg7Izfg/hzg/SzcnVOeLc2+RRB5xNKeLpGG+RRt5rKq2BzrG6utIWTmafYiduzrdcinBDYQaCLEipLHeWmTxV7CPAXpPFJlKzrTIUyR0QPULJQEHi+QpO5d8CheRxFVGGKppRhLinKQmXV84ktC7YHYRGy3AIhgeIfulgz2fkWMe1zRnuCCB4X1P0DU3yH9qXrKiHYTI6wTzzWPPRcUwoNtEkD8MEV+6Yqb1cM5ihdcA+QOQOMNU4wmmmA6//
 91lcal2E
 FdhK1ZM+chYOPDBVoKs7OO3gR0tLURzMTgws8TFI/R0HEE0+6KwrLFkqo2wKE6k1egprTBQMlrYVqvz+pSPthL62aBfC/FefXglsv/qsCaMWx6lokmuhgzMsOpvWJIil7aowWUAF3NFAIkdVZD+zu1mnkUFeIUWwWavXJoHmChktlRrXbc/ZChxsDxQSAh97Yo6r10OuJVStkXrpnBkmLPdvX+EBmvcJ/+LTsoZNHYXUcqDu6vYuhSX9ewEsa6/7AAbchQGmfFc7BQ5HFVirTzh8tpHKDriF8nVFZmI6Nt5faUEXKMOLoBXGfPEfynhEeGRPbWeijFkMzMYhcQH6NetaiBlfSDjEiOSxG+L8LGmDLnvEw+FkJE8RQKFMRchijAUjjeAKoqJMYRWM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 11:34:37PM -0700, Vipin Sharma wrote:
> On 2025-08-07 01:44:35, Pasha Tatashin wrote:
> > From: Pratyush Yadav <ptyadav@amazon.de>
> > +static void memfd_luo_unpreserve_folios(const struct memfd_luo_preserved_folio *pfolios,
> > +					unsigned int nr_folios)
> > +{
> > +	unsigned int i;
> > +
> > +	for (i = 0; i < nr_folios; i++) {
> > +		const struct memfd_luo_preserved_folio *pfolio = &pfolios[i];
> > +		struct folio *folio;
> > +
> > +		if (!pfolio->foliodesc)
> > +			continue;
> > +
> > +		folio = pfn_folio(PRESERVED_FOLIO_PFN(pfolio->foliodesc));
> > +
> > +		kho_unpreserve_folio(folio);
> 
> This one is missing WARN_ON_ONCE() similar to the one in
> memfd_luo_preserve_folios().

So you really want to cause a machine to reboot and get a CVE issued for
this, if it could be triggered?  That's bold :)

Please don't.  If that can happen, handle the issue and move on, don't
crash boxes.

thanks,

greg k-h

