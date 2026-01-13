Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01A9BD2F34B
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 17:34:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 223FA6B0005; Tue, 13 Jan 2026 12:34:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DA416B0089; Tue, 13 Jan 2026 12:34:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 110A76B008A; Tue, 13 Jan 2026 12:34:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 00D406B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:34:05 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9788B139C4E
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 17:34:05 +0000 (UTC)
X-FDA: 84327638850.15.E7EE571
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id B8B1740005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 17:34:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WbyA3+Fz;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768325643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0kn45G2Gwx7itxvt4tA3iBGO8Mgl7hnoy6Lgc+69p8w=;
	b=ygVMMi6mOsejdmFO5+3e74o7jAcv3XCQggX+glT5kj5sPlRiaHEjTEYdT2geQASV/hD/z8
	M5fKAxUg9bBdBYnjmr3DuG3Gd0AF79BxLIoBqV+o4kv4216y027mh6O+P55oF3DZKAXY2C
	daw671RJVLrz3r3qptjTOqHRmR7qwAE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WbyA3+Fz;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768325643; a=rsa-sha256;
	cv=none;
	b=HdHzkhEvYVrxBYD9kHiPkd1oHjQJd61VcZAxYaIN1KaZJ+5c9giAPh2DrxqcphX33ieWzi
	UMDaVTN5wFUy5kH2Grl6bIBCjiahMNVKYEOPW1z0WlfFLeoGyV7Vqw79SWP4krFRw75iqK
	I1wAr9gdcvD64ZJNt3k8IT1gp5g69aI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E204437EB;
	Tue, 13 Jan 2026 17:34:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7658C116C6;
	Tue, 13 Jan 2026 17:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768325642;
	bh=YZwbcRRPs13mP8+rij8yZTXdw99Dd9eLfldfmPqX6MI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WbyA3+FzTYTAmHvwVlZfLUe40KQDNlYCOwODqmT24UnodE6me2UXyfdkbMRcgiM2A
	 Ie7nNf0bhgBJqvjW6G7/jpya3q2bjnOxZm4JHG8oFsLRnvEoKeoDSzoMF0+3t4TFR5
	 ZgzaiDm3pu+lQM1rrx41GzTtPJgJ5q3yEJ2FLXuA=
Date: Tue, 13 Jan 2026 09:34:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Maciej Wieczor-Retman <m.wieczorretman@pm.me>, corbet@lwn.net,
 morbo@google.com, rppt@kernel.org, lorenzo.stoakes@oracle.com,
 ubizjak@gmail.com, mingo@redhat.com, vincenzo.frascino@arm.com,
 maciej.wieczor-retman@intel.com, maz@kernel.org, catalin.marinas@arm.com,
 yeoreum.yun@arm.com, will@kernel.org, jackmanb@google.com,
 samuel.holland@sifive.com, glider@google.com, osandov@fb.com,
 nsc@kernel.org, luto@kernel.org, jpoimboe@kernel.org,
 Liam.Howlett@oracle.com, kees@kernel.org, jan.kiszka@siemens.com,
 thomas.lendacky@amd.com, jeremy.linton@arm.com, dvyukov@google.com,
 axelrasmussen@google.com, leitao@debian.org, ryabinin.a.a@gmail.com,
 bigeasy@linutronix.de, peterz@infradead.org, mark.rutland@arm.com,
 urezki@gmail.com, brgerst@gmail.com, hpa@zytor.com, mhocko@suse.com,
 andreyknvl@gmail.com, weixugc@google.com, kbingham@kernel.org,
 vbabka@suse.cz, nathan@kernel.org, trintaeoitogc@gmail.com,
 samitolvanen@google.com, tglx@kernel.org, thuth@redhat.com,
 surenb@google.com, anshuman.khandual@arm.com, smostafa@google.com,
 yuanchu@google.com, ada.coupriediaz@arm.com, dave.hansen@linux.intel.com,
 kas@kernel.org, nick.desaulniers+lkml@gmail.com, david@kernel.org,
 ardb@kernel.org, justinstitt@google.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kasan-dev@googlegroups.com, llvm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
 linux-kbuild@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v8 00/14] kasan: x86: arm64: KASAN tag-based mode for
 x86
Message-Id: <20260113093400.412cb4c5596ff3336ac803fb@linux-foundation.org>
In-Reply-To: <20260113114705.GJaWYwubl3yCqa1POx@fat_crate.local>
References: <cover.1768233085.git.m.wieczorretman@pm.me>
	<20260112102957.359c8de904b11dc23cffd575@linux-foundation.org>
	<20260113114705.GJaWYwubl3yCqa1POx@fat_crate.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: d914u9c55rrqnfknaxmkbjetc65ejm6m
X-Rspam-User: 
X-Rspamd-Queue-Id: B8B1740005
X-Rspamd-Server: rspam08
X-HE-Tag: 1768325643-234014
X-HE-Meta: U2FsdGVkX198F3jZDt+0kHZ4sEjK1/it2MIwMCKsBLRq8YSYViVExjXMhb+dKpYeMoClZPk1h+FJCj7eBhtqtgbVqQ6HJKSasWvsG8RerhIzbQiD/FLLJ9Une7Cl8ajDGYBZ2iSSepum/ihjDhOqfJPR2GUtSebfEHAtTxaAdSqfStjS34Of0ZNa3oP5Wa1/VYxAEShSOOULPDMR/MrltNG2aLbI3VP0tWsb+uLmiSw8+9HfTXKrBZea9wAIlHzFonMYUweknsJpWNqKujbx9af6lhRi5mUXWHOHla/JGqErgJcr83nweRLoslktOzqVVDDcMqV2yQkmvqDPW1tHTIszQYa6yXQTxk6opAqAkv+J5W2Mz/JtO2nDwlNGLuyuZkLiIvQlJTq3HqBzgHDX5JuDWZJHIenSag5qH5Pwc1SbEWVcPHdDn55CxMALoUSszOrFjPJDJ2g83kyL6fnRkwcTh1lRen1ho31eNvwtxrdqwsQaIke0rxB2mwrI1icE797MVAs6VcSMMsRKG7i0DlgI8SJB1l0IU3205NUgFUMmU20Qtc69GcFv2F06uKPKn02hgLyXeqkTA5OyqYIHqTGVwBDgoiqpgYVeBE7VeI0My52B8EBfoCFF3n92ak67Bb0cAHBsbzNP6HYjAzyYxJCFNmozyq9MZfCD2MlSmheHpavIdYrIrNZQY7g0mIC/y8P8RdRUBF6Zhsk1Ju2DLT3L7Lyy2d0wd3KQG5BqaB67gidQSIMrIRez2yKZp0I847DI2fdfdO2pDQ3yPyXKeu5zmDO3bsUtE7vEGZYi33Fgo9SIHCSA6aC1apXvjkh7z2UZJTZB6jyU4eRkegS9vJDz6y0xfIaCNok+A3XT6tqgqgUcERK7ZXxKrMdfdlNdLrhwVA0Lbd7lHwmuj6WRi1++maTyrhAycTe6FpqXio9V2Tno4Eygd2K5ZoSicl21NhtFxjeV8WLU8FcGwwi
 2OLlrOQo
 hoR1pRs0yClMhaBsLQdOXrh7x2hYXD2p9qM/7GEggpqND/IiGaE4JRz6/2qfFsnf3lGpTDvmbRzXVU73+6pxYh8MtHxEfZEKO/J/WcNsqIorwd/Je+RVWUiIV2r0RvLdOZ4GTMKKx8Jxyln15frsx/gcQmo12/AwAAG/1nwjRJVJ0qi+TTcsZv6QRpq7OADpWu9xHn449mnQ5gz/Gu90iylgo9/5JtJhKgbtU6QLkKBNs5bVzd2EUa+tIM3Pg8UMH3dePCo/vzVov3qGbsC5/DK+6oOC/U+SsAADEfHFKW61/WcIOPc2G2ZfZLEZgir3TuPrhrbt5s9B2Y+g7/sAuwX+YLV4LuE5edao9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 13 Jan 2026 12:47:05 +0100 Borislav Petkov <bp@alien8.de> wrote:

> On Mon, Jan 12, 2026 at 10:29:57AM -0800, Andrew Morton wrote:
> > The review process seems to be proceeding OK so I'll add this to
> > mm.git's mm-new branch, which is not included in linux-next.  I'll aim
> > to hold it there for a week while people check the patches over and
> > send out their acks (please).  Then I hope I can move it into mm.git's
> > mm-unstable branch where it will receive linux-next exposure.
> 
> Yah, you can drop this one and take the next revision after all comments have
> been addressed.

Cool, I removed the series.

