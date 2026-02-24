Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13EDCE9B245
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 09:53:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EB726B0088; Tue, 24 Feb 2026 04:53:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56EB86B0089; Tue, 24 Feb 2026 04:53:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4845E6B008A; Tue, 24 Feb 2026 04:53:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 325DC6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 04:53:53 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D73B01C3F4
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:53:52 +0000 (UTC)
X-FDA: 84478888704.02.6415F31
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3BF49C0005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:53:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZhbfiEy6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771926831; a=rsa-sha256;
	cv=none;
	b=l7LXoQb7+0SJWgiFqxBLU6v5vA+fiElAxNsqsThvKqrzBaWLFIhhvCLM1aS0W77ymh0OMQ
	LcfjusOJHg3LlJmA9c8dPB5RBMaD20moFqupicXdyg7z4sB+hX2luiCqIghrHVyu3qb7zv
	SzP0JJwfdSZIE9aELKkE0jl1bIrU4BQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZhbfiEy6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771926831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W7SBxP4HKY2Hrtzl0yHvjoiYsW/u5QB397Jjw9XWqAQ=;
	b=F9mFHjGzfSE4ZL13J7LxfjTHRgt6RfGEyZ+8eT/q6+b/q0cUEFjqXMAURcv8pB7EfY1+Ig
	Vzh5QNLGtmnF8QkkfD9Q1Jw3nC+m++NqxUARimc1GQvsV5BNG2Dn79ncp9oSXNau3rtpXv
	iwXJfX7yPs9dmODhUQwdF9tSvNnv4W0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 54FCB40C4A;
	Tue, 24 Feb 2026 09:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292E7C116D0;
	Tue, 24 Feb 2026 09:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771926830;
	bh=r7eHhH2PfG5WZuFexz3hpA8FZFXdMilcr/EoFqc7eI4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZhbfiEy6gxAbMMC5gQAl8nQMiG1ZfhDqZvjCWmBDhYebQHskLcLix/joSge4RXZbK
	 TlruXp01XKOQKUi7btZZj6jI4t7TivvALbCIwgmiSfVsiKDiOeaLF2RCG+WMVEzVx0
	 ehCsE+SR2qKI1icKwegdje4HpM326V61a0vODhnm+5oS/dO/fUgLQZP0XK92xOmeDr
	 Sh/oUd24MLkkHgCGgcqvCicXygmoZT/LLNHxZe2anEfjfJNJgz3KTNGWhinOigT7Lf
	 /Y84R4XjZXxVAIEQxX336X6niiGiVFR1eZNg2Vv/uhLmHzYJJjni3g37pjOHHqa7P7
	 7USnqOtLdchJg==
Date: Tue, 24 Feb 2026 11:53:43 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@kernel.org>, linux-efi@vger.kernel.org,
	linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86/efi: defer freeing of boot services memory
Message-ID: <aZ11J7D_iBuG_qjC@kernel.org>
References: <20260223075219.2348035-1-rppt@kernel.org>
 <b6f4edf5-7587-45d7-b81a-590d4f3d1ddd@app.fastmail.com>
 <aZwyNAbEqb8ZwLUM@kernel.org>
 <e2ad0845-2f87-418a-9f87-5ce619e004ef@app.fastmail.com>
 <aZw8xSI-TM-Gz84t@kernel.org>
 <bfe487fe-6868-4215-b5be-99a0360e9bd2@app.fastmail.com>
 <aZ1vWEgJNwc2nrrA@kernel.org>
 <3a01d817-e08c-45ec-b5a7-4a8d9ecd0fc6@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a01d817-e08c-45ec-b5a7-4a8d9ecd0fc6@app.fastmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3BF49C0005
X-Stat-Signature: sbk17sq3ma9chq64h6qngj4dbqcghxqq
X-HE-Tag: 1771926831-204963
X-HE-Meta: U2FsdGVkX1/apXwcQ762vCVe1mYAKNaDLRuvCPnDQxTxZOrSr524i4FvAmvG9gvmUcLk0hi2VQUVeU3lJgKFUuxNb/dgogQ+pGaNz9Gl8bF137YY+mcGObOP+o6bPIy1Hpz3dmDilYCWTxhelCb6ucJ873Jrj/EYEHs4VOHMkOC+gYFAcysmF4mKcfUPIOJ3ZAnUAKVjFpc8oVBl73KD1pI3wbqaW+myeqatK/APpOFW5UIxNxKV2SrtqelXA2DItZlvkkI09yZlerHeeXUE7+jwIFp+LwfWWt9TyEv3m1bPz/E1VDx6Je+6Bumzk4rvk9im2ndE2mo3xal34cZRdJYqK3mk42/u1BlxiwQvSK588de17LEb3ZmwjZ3aJV4U2H3bPVSSquSRniK6a/1WAmwbibydHuFe/JkFRnqOLxgxbZ9Sxtb2tIn/0RgYEvybojWY50XPTOtntw79VRIZBvVqlTyGXTI9k57aqaE8UdWCilk70HGaWQvHf3/xtCUACpYakL5iBRUrx36zI1xJ7PvA+YAmM3tWYaIyynEV9z4vGTJkKKk6OUjQnTK8b9vEBtTKxskgWSgrc2IQjw/aJahiQR4L48VZUzm9+Zx5WIEzyx7LmQPLyAqLhu+hIIZCNTWMGrKSgRhe3/F/TSq3rLUTE5FXvc8sw7TBlQ7Ko5K/TMko/J/fLKkf+SE2h2YHRKhOjJad5xvxZbOXujpcXMhMsfzcI2tTjdmauey0sQK8U+cRvB3uW79qe6B289ZF8+ZBGNgb7JZcZjKNEwMe3jx2GxHUwpd2h5bkgtMC5brgkEvb/LkF+mqYq0HhRgzayDzAXGsPP/n0CnaA+TWnuhRQ5Gwzp+RsM8D4B4npNPvgOyxL6C3mUql2tBJdjkGbDxyQFZcCeidATLnlbBDz0fT1DXh5cP/dQKtWFM0zJLTDOq5lHUkupkLG+YbfP62oNW3nBUQZ7Lx/0tJ0cnc
 rfqVq+J/
 pLjGB2Wp64NV302WxjPkCMYrWYi+wbUGBecISPzivQUeqZ5hs9edPzU+5XwfYhwrYlzJLVACIdwYkUQTKU9IIBoBARkrZ4iCsdlwLKl1bwyC9oslyYDgi8dY/JhoMq6rVMiLe44cO40bE0oLf21+f7xiyv7W+4HEmGhZiE+R38E2Jx7Lk9yikm47Uh7inyNukdsjjNgBkqwgzOFq06Z1TkMmxq4BEKFwNW5u4pg6tq4BPnDB6ZaGa4sQAKAN4mI4oF3Ce
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 10:29:59AM +0100, Ard Biesheuvel wrote:
> 
> 
> On Tue, 24 Feb 2026, at 10:28, Mike Rapoport wrote:
> > On Mon, Feb 23, 2026 at 01:18:41PM +0100, Ard Biesheuvel wrote:
> >> On Mon, 23 Feb 2026, at 12:40, Mike Rapoport wrote:
> >> > On Mon, Feb 23, 2026 at 12:17:22PM +0100, Ard Biesheuvel wrote:
> >> >>
> >> >> > I wasn't sure it's Ok to only unmap them, but leave in efi.memmap, that's
> >> >> > why I didn't use the existing EFI memory map.
> >> >> >
> >> >> > Now thinking about it, if the unmapping can happen later, maybe we'll just
> >> >> > move the entire efi_free_boot_services() to an initcall?
> >> >> 
> >> >> As long as it is pre-SMP, as that code also contains a quirk to allocate
> >> >> the real mode trampoline if all memory below 1 MB is used for boot
> >> >> services.
> >> >
> >> > initcall is long after SMP. It the real mode trampoline allocation is the
> >> > only thing that should happen pre-SMP?
> >> 
> >> early_initcall() should be early enough, those run before SMP init.
> >
> > I don't think so. All initcalls run quite late in boot, early ones just run
> > before the others.
> > 
> 
> It is documented as running before SMP. If that is no longer true, we should fix the documentation.

Ah, my bad, it is running before SMP. 

-- 
Sincerely yours,
Mike.

