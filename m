Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 006B6D2502E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 11:48:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69D666B0099; Tue, 13 Jan 2026 06:48:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 650E56B009B; Tue, 13 Jan 2026 06:48:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 557DE6B009D; Tue, 13 Jan 2026 06:48:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 46E476B0099
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 06:48:24 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D334E1402D3
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:48:23 +0000 (UTC)
X-FDA: 84326767686.18.AA581B2
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf01.hostedemail.com (Postfix) with ESMTP id 88EFA4000E
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:48:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=Xu0+QRmj;
	spf=pass (imf01.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768304902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rTbY8atxjKRjBA0y7/TdrF1D3ojAC1i7Hfmy4BpGVjk=;
	b=bJX68HIaeTFOLKXzRhpXyYe0y8gt3yagiIFj/Ryx0bzzdTFoMQEvQNKMjBD3YkJ83538oc
	0hLgotlb4KnDCWR+qEuIhEu6nC+3RwJ8q4NY44MGlm/J69j1Vdh0Ml7Z6v9IaWcZm5PEov
	JpTZL5Or5nC8U1AXCON2M/FjdV6p0/I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=Xu0+QRmj;
	spf=pass (imf01.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768304902; a=rsa-sha256;
	cv=none;
	b=kDrBHcCqhSlAlynOoi/ErgV29Gdaqg7KNAPMpx0ff8LXe3+LTPmy9w7vJTr8XhYh3ziE7V
	ELN7xsNbiA+XLPcpT4OYqwMBxFSK+mg2j3gCBKurSEwCgEUXS8kZKeAhUxx4+JsOXyOPeI
	pZSqkkdPu0bVZRztlTGO3Ma+i4E55Gw=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A7D7E40E01BB;
	Tue, 13 Jan 2026 11:48:15 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id w9KlwacFOika; Tue, 13 Jan 2026 11:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1768304892; bh=rTbY8atxjKRjBA0y7/TdrF1D3ojAC1i7Hfmy4BpGVjk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xu0+QRmjVzNBeP/SFAjZtAYJhh21/UMZZySy8yfoIPEBTM4uIy81JkjyYzMDkN+01
	 n+8yvHO7z7BYTqramqSmlCga3GRnbhy7+aaGT9vruZ8fLyV2f6AyRnKg7EVljfIqK6
	 lOHOIMZuDODjGpIdo4Qc2uqTKS9WoZmSXSetNTKJ/hoXL1K3f0EuVcGvghZ6XV2pje
	 uSZa2REx13fy9H2mVCdKrJtb02uLGMEYUONgSqVGTtnI9OLu8V1NSDwPz7de71ETiO
	 wBA9CcU/Bzp1kCBtzPupRc/pF1vb5GoIkk9j8U0lmI827DrbA0GGCKA9XqcU1poQqb
	 uKIrf9KzbJYRxhJHXaSxcxLN52HneYEXBmDHVmSOgslImgxuumZkdJAvl4SVmu9BMy
	 1ZNoNFr194LKYfVF+BxPzd5FSH2shoVaru+f41SJ+nEeSwAX29dBPVqqHxxnEo7Uua
	 yy30+t1ym5n601GoZV5F76xpQhfo7AV29Y9mu3rWjfyxDPhVrHt53rWfTxzQ6bG+11
	 UXsjKFSGRi/2UG/gm5Kh3HFtjczcjwwRG/cn6wYOMivXrevjw8nosm4zMs55sut6HD
	 wAi/LWh0YyOYKy54CB2fW1apZheJfHlztDFVkJvkT1BYdgWEEW46JWy3RDdAcDDsHR
	 FcYQ/RrS/jrxs8yaH2eXQqk8=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 78B1A40E0194;
	Tue, 13 Jan 2026 11:47:06 +0000 (UTC)
Date: Tue, 13 Jan 2026 12:47:05 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Maciej Wieczor-Retman <m.wieczorretman@pm.me>, corbet@lwn.net,
	morbo@google.com, rppt@kernel.org, lorenzo.stoakes@oracle.com,
	ubizjak@gmail.com, mingo@redhat.com, vincenzo.frascino@arm.com,
	maciej.wieczor-retman@intel.com, maz@kernel.org,
	catalin.marinas@arm.com, yeoreum.yun@arm.com, will@kernel.org,
	jackmanb@google.com, samuel.holland@sifive.com, glider@google.com,
	osandov@fb.com, nsc@kernel.org, luto@kernel.org,
	jpoimboe@kernel.org, Liam.Howlett@oracle.com, kees@kernel.org,
	jan.kiszka@siemens.com, thomas.lendacky@amd.com,
	jeremy.linton@arm.com, dvyukov@google.com, axelrasmussen@google.com,
	leitao@debian.org, ryabinin.a.a@gmail.com, bigeasy@linutronix.de,
	peterz@infradead.org, mark.rutland@arm.com, urezki@gmail.com,
	brgerst@gmail.com, hpa@zytor.com, mhocko@suse.com,
	andreyknvl@gmail.com, weixugc@google.com, kbingham@kernel.org,
	vbabka@suse.cz, nathan@kernel.org, trintaeoitogc@gmail.com,
	samitolvanen@google.com, tglx@kernel.org, thuth@redhat.com,
	surenb@google.com, anshuman.khandual@arm.com, smostafa@google.com,
	yuanchu@google.com, ada.coupriediaz@arm.com,
	dave.hansen@linux.intel.com, kas@kernel.org,
	nick.desaulniers+lkml@gmail.com, david@kernel.org, ardb@kernel.org,
	justinstitt@google.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kasan-dev@googlegroups.com,
	llvm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v8 00/14] kasan: x86: arm64: KASAN tag-based mode for x86
Message-ID: <20260113114705.GJaWYwubl3yCqa1POx@fat_crate.local>
References: <cover.1768233085.git.m.wieczorretman@pm.me>
 <20260112102957.359c8de904b11dc23cffd575@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260112102957.359c8de904b11dc23cffd575@linux-foundation.org>
X-Rspamd-Queue-Id: 88EFA4000E
X-Stat-Signature: nehqt1167s4dicxdu1dyt1d1uwk6c9pz
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768304901-719106
X-HE-Meta: U2FsdGVkX18vs9qiTXq4duN9IMH2geIywnX0jtGCECR3DMCmLlDgE7wb1vTzwBNwkVTy5W05Xg1x2BFaxBNfzOh4ymaHLWya0m7ECr9uNLipkkEkvxjMOTO8X7mkPfZv1YyS1wv+LeP2KlgLoqip1eBKpNQzD2BhGoE/7dNl152RPK8F9dycIGZV8hdLVNC2NF5VuxydtfqQvkDfF+iAcL2+xAkAf1Zs6occWSeMXDjb5tLQDP3ppT7UqDnaKzg2v/7qAbzceM84j+isk7epcQ9bCKIvuzyi/KB7DGNt3DOCbQARlybaTIKKZ1juc3ppot+1hhXMZmTqe9niIwsU2jS7mwkgQTAFPrGMYr/gQGfQHWqHAIf69rpnlpY1bofATe4gEg8UQeawPg6FnrM0EN8OIsScdNFEFjH7+a1hXrEspXcfowRvExU3Mg0W5y/C768k1pwsW57Brq6ndxUWUZqEryoopsjQcMOGWMbH5XzNfnxbjk7ogZIpzcAfSv0UuDktPFZAKRQJ8zLt2jOgkHtOw3JlUObFB6QOR6LZ8V8eKA4tOWH38fIev9yka+z7h3h2NAuCUQ1CVyikfyisyVkoQgGWaO3wJZLEELowa2DFzEcAvqRnbrlGUDTUwgKvk3RIoka74WiJJ3VbjxMRyH+lOMgCSOR5iCVaIF8GXCM9jSe2nF7cmdWMw/Lm7hcLwkyaIg1VkDFUFmkdLZzAF2Ccfmqfw90wCXm2iaZhn2oh4sg+Jd5m9ot3mjZ45+gKKQthXQt1B0vJ/o61pbl1ikaclzotmK/DirPqBZQf1yg5obaHaAINTZaIHfWKw0b83D8QHLUyfnbhPwth241CTzsPSqGrmNoI/Pq3SX4sXzr/6TW5zJpTrYOGmIGbsLQwYWXQQKZ97qP6m5GFxTc3bCvw9G8WghBrWqT5AjWyiNe1bFBlclaWgSjr4b2We0uAfiwUn3jYA3K1OeiGUaM
 N+P4nqZ6
 cK3m8qp1C8XeVYm6FU7UvADFT2mwR824CXqx+UUT29p2GbggYuvr6mFaWSjr4x3Mwo3lbkknxjz7oLkIHH5HKoNnsW7QHFYYZburZWeeS5Dqd8JJmwNA+LI3vgMBICizpyXqzkz9CA8KZZV0c10cFKscwGOYNM8E6v1vw0eVaPWUcZ4gbjN9+jrzy7W9kQto/3JLgTw3vgWIEBbXf75JjMUYF71oFZ4hld8G9y+j7yp/PliE8kJEJiNhRf8XuXbFzXq3ylJjecUj7aFnktZbNARtQfjcrxUZtNC4yS7lfUFPgkO6LGwHkz+vYHhPF/xCOMY5Szbn1T/oP4ZM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 10:29:57AM -0800, Andrew Morton wrote:
> The review process seems to be proceeding OK so I'll add this to
> mm.git's mm-new branch, which is not included in linux-next.  I'll aim
> to hold it there for a week while people check the patches over and
> send out their acks (please).  Then I hope I can move it into mm.git's
> mm-unstable branch where it will receive linux-next exposure.

Yah, you can drop this one and take the next revision after all comments have
been addressed.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

