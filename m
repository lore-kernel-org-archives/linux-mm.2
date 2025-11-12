Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35AB1CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 10:21:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B8408E0003; Wed, 12 Nov 2025 05:21:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 868988E0002; Wed, 12 Nov 2025 05:21:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7575C8E0003; Wed, 12 Nov 2025 05:21:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5CB6C8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 05:21:38 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C86F912DBD2
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:21:37 +0000 (UTC)
X-FDA: 84101563434.19.C0ADF7B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0A9C040002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:21:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rYpDmnFD;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762942896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mlniT5rFI5yEsre76XRI2Xx26+jzLNf6OG7wfCVcwwA=;
	b=anQBHinGMIWbYmPNkLbYi3rmecTYsxz6yojQ+fvW0PqU1uh6k+KD4m2CYSFkyXfY9FwL1A
	NaUXjQYYfV50PThqv5IQ3l2G6s7jDEglvwX6fR0PZINOKzv/HmfrMKWyQwjSHemokK3irl
	aIj4t7UU5WECgTSvg0nbB7bTbfCxCkg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rYpDmnFD;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762942896; a=rsa-sha256;
	cv=none;
	b=CK7HhVN+syUTz4UVK8ZF75Jgkk/t3ldtLKRyuG1BZK+fUT+3PK4FCiEWWcSA8IDAKnw57c
	xsHy6q68dUSL0/SzwCmxG/vD5XgCdvMgC9D8JuzRLgHPpNCUjM7ilCZYY4qLkjThzsnoLg
	4nRtlsMtJmEjCH0phqm8/WoSfaO96YI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DF0154420A;
	Wed, 12 Nov 2025 10:21:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD3FDC4CEF5;
	Wed, 12 Nov 2025 10:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762942894;
	bh=zRFgC/LqmJXdXGt/uR0LzuT7bkCTv1lA/W99nU6OL50=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rYpDmnFDGaK39JayZljdcDCvnD5nmaI0NwULXoCt86nssEl/3uJZwSo0NOYyBe0SZ
	 h9tyvZEpL4z3hbdxUIVrWi9IBdYJapZ0foBkg5Zg/gX7O0jz1UdlNyp7pDN4cOC8LL
	 s89A81086/C++ItH13Aq4kxXmrKYWWKTMksaYAEOuQ8gEW9g3n/Rzvg9LB5+cs+fL8
	 5DBHHNMKo8VKyTTxpJSCLVuiiwGzgpMo+1aFqCvjWUTwfiHhMxaPU2g0PGxrEJxs80
	 Nb9EvMmhqR0SYpN37rVtdjokI51KBP4T5T+Se67mEXcqPdh9KUhWEv1Kt3ksgDPwuw
	 o4SMHTw1GA+5g==
Date: Wed, 12 Nov 2025 12:21:08 +0200
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
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v5 02/22] liveupdate: luo_core: integrate with KHO
Message-ID: <aRRflLTejNQXWa1Z@kernel.org>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107210526.257742-3-pasha.tatashin@soleen.com>
 <aRObz4bQzRHH5hJb@kernel.org>
 <CA+CK2bDnaLJS9GdO_7Anhwah2uQrYYk_RhQMSiRL-YB=8ZZZWQ@mail.gmail.com>
 <CA+CK2bD3hps+atqUZ2LKyuoOSRRUWpTPE+frd5g13js4EAFK8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bD3hps+atqUZ2LKyuoOSRRUWpTPE+frd5g13js4EAFK8g@mail.gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0A9C040002
X-Stat-Signature: 8dywnfzzbrqqapeao687d8dmuozf6eq3
X-Rspam-User: 
X-HE-Tag: 1762942895-478403
X-HE-Meta: U2FsdGVkX1+X+bAzJoImRivgYyfDeHgiBEGkpucha5ug1gr6Y6FtbDzTI5xeaQ4F9jRFJ9aVi1GwQxwY4THYfCtLPLyIW2GC01oIAurUUU2U4n6XkFfkeYUDlYFajoJT9d+xgB/LKHjhYtmsChaHMhuiDQ4WLzp8j0wjJACA4SKDQbh6he/QtsRvCgD5mpR7enLAWvm17sNHiUC4HXXxQ9tJUMhFQb8/AufuCv7zUinOmkysbmZY3b4U5+RXX2ypmI44tjVRGaWaNH+o6fL1Mni63e9PWaVrTg3TNkhMoJ0cEt0R6xZZafKF0s4RSpXWZ0GdfQsO9a8gcQA7GAU0Sd+Z6qUpBXNKZvUm1mWNyrLbUyYyas8PUirtn3FQJ1B4enh0/+0FkVzDlo3qEckxKFWacmmyKioaL8TrISZHBDdExWXzG7ns4U1H0FyRjazA7I0Z0luJ90FbT8PpAUpYjoZWYQYZHtUf6qEHUXLD6NdVeH5g6XCyiYwIKLQuglT1XdWSNAKNzfXxKZaV48EgWX1+nD3znRMtqRLzipf3GhrMYt97EchvghIkqQfo4OML68a4RvUDajwp4fXHGwl4tzcrwyjyGhZ4q2pQX5I8689jnDceVmSgA3iQHG80T3LsYZz0wFJI5rvMYTQ7ify0ybnEfUxDivtgd9wrgzXbk+sF4QTBBrS9ctgF6a8glpw02WgPpjlNe8n4DNw6ZpfrLrWKImsXiI/NETx7CSHbgJ+Wi/DxuRYfbtXzK23PTabRcnswLyySIVMDAxE0xNUZrjT96hVVxkcafpRxDx17gR73ENeNuxRlMHGP+M6cz5pAXY1ya6rrYmVCQ997LccR7piMzpeXP98HAKg6QmslHpUqXwucnv68fafY2vif4eDktoDB7qvMq/MBZ9mJaq39apNy+4Q2T19wKdycD2t1O7bK1+U/XkXm0ztpbP6xJ9AKIPx3g3MuB7D9fjuiIbr
 +5TmwsLI
 rkJ64cH6MTRbq2tF5yLHIrTNAuPQxMvaqFtCPDeZpKBeFdp2HFLrnsdSGoy1xeq0HlzFRY3YySbPFvMoGOhrqNL3aRzYaoZXCBuIxmCe+OwoNTaRcjwSbtFyxDLOq5x7zEy6ma/okyltmYu5Kio7m6sbUaKrkNf6pX2FkT00oGQ4VL/aZNESubLlywv0SYlH1jjFMcSpUsZZGCT35vt/5YnFRmJ7xURSVrmUAXYZSJtoWkco8gqcZMJNWRt29ctb2IFBKqTZOa7pie67IzYivMIn80zDX4hLPFmUFcx4SV4xrw14oClzXYhO8s9oTqWFFc2r8XeIFFfy+sYRPfyDWAx4rFC9WSu6y7qQkK4kCAxWNTuZrv7d6+RnWFc75iTb+wV3UXRhxGXBji0zOj+acw73LjNmnkscDS7Ce
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 03:42:24PM -0500, Pasha Tatashin wrote:
> On Tue, Nov 11, 2025 at 3:39 PM Pasha Tatashin
> <pasha.tatashin@soleen.com> wrote:
> >
> > > >       kho_memory_init();
> > > >
> > > > +     /* Live Update should follow right after KHO is initialized */
> > > > +     liveupdate_init();
> > > > +
> > >
> > > Why do you think it should be immediately after kho_memory_init()?
> > > Any reason this can't be called from start_kernel() or even later as an
> > > early_initcall() or core_initall()?
> >
> > Unfortunately, no, even here it is too late, and we might need to find
> > a way to move the kho_init/liveupdate_init earlier. We must be able to
> > preserve HugeTLB pages, and those are reserved earlier in boot.
> 
> Just to clarify: liveupdate_init() is needed to start using:
> liveupdate_flb_incoming_* API, and FLB data is needed during HugeTLB
> reservation.

Since flb is "file-lifecycle-bound", it implies *file*. Early memory
reservations in hugetlb are not bound to files, they end up in file objects
way later.

So I think for now we can move liveupdate_init() later in boot and we will
solve the problem of hugetlb reservations when we add support for hugetlb.
 
> Pasha

-- 
Sincerely yours,
Mike.

