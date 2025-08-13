Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8778FCA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 12:14:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DE8B900064; Wed, 13 Aug 2025 08:14:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06823900044; Wed, 13 Aug 2025 08:14:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E98D6900064; Wed, 13 Aug 2025 08:14:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D9886900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 08:14:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A133858773
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 12:14:29 +0000 (UTC)
X-FDA: 83771627058.12.E570DA2
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf17.hostedemail.com (Postfix) with ESMTP id E913340005
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 12:14:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=rujDt7ws;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf17.hostedemail.com: domain of gregkh@linuxfoundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755087268; a=rsa-sha256;
	cv=none;
	b=vyYKzua4/eNeHUwTWakho2lzkO3IfhyITqU5eDQ8Vtxhwf952vuRjgFcmcbVjKr7/9rzeX
	gFzxd5bIwiMxvugnV1SMbzr+Pg7DKacV8lvXS2marRnPDVQYmmPfaNNTHo7br+w5U5isI6
	ZhWtzch45f6uV1vCsHmcqDNMPufxT88=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=rujDt7ws;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf17.hostedemail.com: domain of gregkh@linuxfoundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755087268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K5A5Rur+Yxpdv4qEffUxxEOzstqQKKgqjNZsKOQ5Sn4=;
	b=TxTLVR6d+E+V6WOyFuoJau2ISJ+rDVkXZ53qzfzDpnvJbmH2gASQCElq/fqTu1ZObWXZSc
	fGJWL7uhX6/EkSL+bUF1Q0JrW4pAC26Sc5z4Q1Rjz8g2Ai6PQ/dfXbqhxwcmUUuF/slA8l
	RuoPJaCivm5blZZnrqPBQp2TtLlLmcY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 189A4A57C97;
	Wed, 13 Aug 2025 12:14:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10ECC4CEEB;
	Wed, 13 Aug 2025 12:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755087266;
	bh=tLOV7MuxuGZuAFjpe/xUc874h2DrbSyeczMhXjDQFOI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rujDt7wsKQqVTbCwQrtiVRdM2aH76LameWGzvTdZ5npEBlrG95aNQxa3fQpNRodhk
	 QJbxh/7YOXP2RZlRsBQ3Euf+xwHlnxbyvDua1jB4H6D5yGcYFwDUM1uYw6W6cryK3z
	 Pug/jEnZ7mb8BeSzL61ybm0Sudo+Z5LhYzcQFvOs=
Date: Wed, 13 Aug 2025 14:14:23 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Vipin Sharma <vipinsh@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, jasonmiu@google.com,
	graf@amazon.com, changyuanl@google.com, rppt@kernel.org,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
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
	stuart.w.hayes@gmail.com, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
Message-ID: <2025081351-tinsel-sprinkler-af77@gregkh>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-30-pasha.tatashin@soleen.com>
 <20250813063407.GA3182745.vipinsh@google.com>
 <2025081310-custodian-ashamed-3104@gregkh>
 <mafs01ppfxwe8.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mafs01ppfxwe8.fsf@kernel.org>
X-Stat-Signature: sabozraccbp3w5j9f738kwi1af6orqi6
X-Rspam-User: 
X-Rspamd-Queue-Id: E913340005
X-Rspamd-Server: rspam02
X-HE-Tag: 1755087267-569119
X-HE-Meta: U2FsdGVkX1/o9lTvVv17u0N1MFTJlpxEG8Qpo/1lhP5DpMH1RaBo19rjfUJxX+LHqlTmK7fupc2iNmhdm8GRmJBaijps085D9kAys7CFXkSGsporYkc7ZiaqSki8JgtjXb6IAC5azLPujfzr++twrsvy2uQTimFam5A+aQhCg+5JenrzKRcIseZbZ55iOptID9pc0b17dZbonSw/Ik6ifwPhxJxf7eW5zT46izeTMiFBwwqlfgVG7W5BUQW3+8JdsIKWloHVM1/CvQtCQdQJHOjsauplnsiqMvST4uHOprXL3TtCLJG54aV3t+5UGei1yiySbpzyQ+1DJ1P+2rAtMaLVIOfRktTJdMxFwi5DxUQ1rtYl7wj9Sr1bjkIjnva8qtoUnfew/Y1wAg5RJyqugtvUCeGLCR3Sdxr4yAQeb4jpW5C/cLVlEDUhIdvHhItonJ0Xa8jxulM6AKkp+esTHGZHAbog/rgLSRdSX46f614saMI3veE5JY8TY+yCBZ0MMYHVqOBuAhKwagaA3RK+H8bZ6JrjeSfNqvlKk5u4F+EZY0LwpCL4XgscWfFC1d96GYEj19IwMV0mWP+QDlxxRpKXaRMHglW6s7t0Wtbi0wXLX9eOMWojVDA8OwRTJ6mItztCkgtFM3LEjrt3TFMDatCUdtTMbu+eddTPSNrVz22JfkXzzB9hZvkuc3jOVUB329RKcKpj7rSp71h9q3xiwnG8Py08UcJJ2COtsFXMOSBDelwQSNjaLww3Xv2foMJQpPm+cjI0Bz/onAL+0SLZkajvPxbX7XnrnR7t+SHkz8luu/PhqY1XJr29viKHZ1Gt2D6BK1pdcUzf+FUg3OPm9xhNGtFOQ1MG/M6qbnGg7ZDD0bjOYD/Ebiwh7D1biZNyXVyX6xSmjcgI6OMP3idORLqKNKnC4ynPApjuBHa9XX0C8Jp+RLfhHrh7a/EY78lfiOpmuaVPlumqOEeTObE
 hIRLWRRK
 x/NarDW5lBBJi9xDSoA4D5SgPxcAlqLsqPQkjKhXW41DfIPzpwwH8aM0d4+GRu5LVIZWLDOP6Gb9W6ElkLZbCXimeVRKmXh9qDI2e/AHB+a10atI4qJkaU9L6N9GnfB+2dhtf8LBgICjWVj+smiXOY1N1YQUuaexPxneh3CV7eliVccW7AmJPpwjKv37tTr9wITrpX2wI2dGYRhf6PHWa1V5EdjvORD/oXlHgghNkXHfJJzTeOb51gC9lOzMg95tPvk81KACJurs4v9V6QC0cjkEt+uXHTZIPVh0UOM4E5Bw160F5Xe65d4oxjYt9ThhuMBevBUuRIP9v8UFTcl3mauJGDomqPq96BGoMYho7RQXaep6oPYhBnVZeDeq0JcIgE8MZewb1hSQLft4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 02:02:07PM +0200, Pratyush Yadav wrote:
> On Wed, Aug 13 2025, Greg KH wrote:
> 
> > On Tue, Aug 12, 2025 at 11:34:37PM -0700, Vipin Sharma wrote:
> >> On 2025-08-07 01:44:35, Pasha Tatashin wrote:
> >> > From: Pratyush Yadav <ptyadav@amazon.de>
> >> > +static void memfd_luo_unpreserve_folios(const struct memfd_luo_preserved_folio *pfolios,
> >> > +					unsigned int nr_folios)
> >> > +{
> >> > +	unsigned int i;
> >> > +
> >> > +	for (i = 0; i < nr_folios; i++) {
> >> > +		const struct memfd_luo_preserved_folio *pfolio = &pfolios[i];
> >> > +		struct folio *folio;
> >> > +
> >> > +		if (!pfolio->foliodesc)
> >> > +			continue;
> >> > +
> >> > +		folio = pfn_folio(PRESERVED_FOLIO_PFN(pfolio->foliodesc));
> >> > +
> >> > +		kho_unpreserve_folio(folio);
> >> 
> >> This one is missing WARN_ON_ONCE() similar to the one in
> >> memfd_luo_preserve_folios().
> >
> > So you really want to cause a machine to reboot and get a CVE issued for
> > this, if it could be triggered?  That's bold :)
> >
> > Please don't.  If that can happen, handle the issue and move on, don't
> > crash boxes.
> 
> Why would a WARN() crash the machine? That is what BUG() does, not
> WARN().

See 'panic_on_warn' which is enabled in a few billion Linux systems
these days :(

