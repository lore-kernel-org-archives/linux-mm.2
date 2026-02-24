Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9FE8E9B248
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 09:56:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 348CB6B0088; Tue, 24 Feb 2026 04:56:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F6496B0089; Tue, 24 Feb 2026 04:56:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CE026B008A; Tue, 24 Feb 2026 04:56:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 076206B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 04:56:26 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A16061C560
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:56:25 +0000 (UTC)
X-FDA: 84478895130.21.448A243
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1881F1A0002
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:56:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kklVnf5U;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771926984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+J/nfHAwLJIj12vEQKINU2E0xiPLAx7XDfHih55tjpM=;
	b=Vq4MggK1Smk/YoofKatTv92Sh7nRF/vyKYoZtsXExX3TKJE89V+grxrbrZpwhMiO9r7rpa
	8BPPwhobyvj2v/QMHXZdgoXoTvUopbdOGVEyKGKt8Tv5y3bLayspDCkdRMtqohIHxqcqhp
	YS+bcsWYw5QQmoBNAf3hnN38b+edH4k=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kklVnf5U;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771926984; a=rsa-sha256;
	cv=none;
	b=wqcWi++GTA8h+WEtEiLHJPoIjR6J6Cg1YSlab7SlSdjyybXYbnodrh45UwSwjp6Xw70jrN
	NJzOPSS6BnDDGKfgLdJe4Ow7flcEp2KCFZ84iWhhu94LZOTOCFtcwlRAubvNPA/yvsU/52
	wiKSkZbjC5AK01RE76Ty/bAe2I/iaGg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F6FB6132B;
	Tue, 24 Feb 2026 09:56:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C49C116D0;
	Tue, 24 Feb 2026 09:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771926983;
	bh=K3RDjAlZowo+4rYvPnOOa5kXWHplgjhbrLLqCtnsTA0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kklVnf5UCe2Ljmnyt2i0NloaCbFvUnJlmKMizwcQtrZT2U3zTmCSy0VgOmSjjCtHZ
	 j0EIcKGW8lRtqwzfV+vEUJdLu/o7sB++sXBQpJNjPNRQHG86G+NopNAzT77MGSLTTq
	 JABx/8iY8+nQV4ke9Pv1Cukb2sFTn6RShrkSmkuDfik2mQSXFJH7rX7n60klv0bZSV
	 w+VDtLyROzo48mj+8gmH2mg4drUHk0Q/a9kxitZC3Bia1/BzgWj1Npx+urRr6LYk8q
	 cW50O4U1pO0pKs4E3E/rwW+BwD69hP+4qVU9ZRZy2MJ5xJFjf9bvNY1nDAf9RnsYZM
	 k5/s+FtOHhu6Q==
Date: Tue, 24 Feb 2026 11:56:15 +0200
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
Message-ID: <aZ11vw7mYmX1onEL@kernel.org>
References: <20260223075219.2348035-1-rppt@kernel.org>
 <b6f4edf5-7587-45d7-b81a-590d4f3d1ddd@app.fastmail.com>
 <aZwyNAbEqb8ZwLUM@kernel.org>
 <e2ad0845-2f87-418a-9f87-5ce619e004ef@app.fastmail.com>
 <aZw8xSI-TM-Gz84t@kernel.org>
 <bfe487fe-6868-4215-b5be-99a0360e9bd2@app.fastmail.com>
 <aZ1vWEgJNwc2nrrA@kernel.org>
 <3a01d817-e08c-45ec-b5a7-4a8d9ecd0fc6@app.fastmail.com>
 <aZ11J7D_iBuG_qjC@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ11J7D_iBuG_qjC@kernel.org>
X-Stat-Signature: 8mhwbpuxhqo7nus1epzcrboo7jw4ijbz
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 1881F1A0002
X-HE-Tag: 1771926983-458453
X-HE-Meta: U2FsdGVkX1/tv50ZcASkIWPH337yTWKhmTGrQmPG4Dc0gno9FS6qKFsz1wjfF+XzxcpLDDvMOh99Zcx5Uicrb9ruhamZ1SejAIxcS4sXuB8Gg30TOPFTxZjqPGC2GJeMa/3xx1+YpvLV7HEuDAcgjdKDL1pvSFK7ElluIaHUwZBj1cbgvDLvG4SBAlJafzfHACY6nWcQ4VqiQOquDtJA6G5+DGgDHtkVqTKQopd7kuAYJr3cQhy/Rcp6YNOzR7y1JwzWYSyrPi8C10TjiW1UYXfNlwqDhK8Vff0qzSRb1oSzIaobFNXad3VLtc7GbU5AePjSLyQABOoytsH2I/0wN+0WdgXCZAfh4rAK5Kpb/h2t+mG9yuhndodIjBu8vQbUPrYlmxp2p4Wo6D5EtUoISGDB1nd7HEZfK+9I1ms0VW7ub0VZjiR6mFJsyVORZ/k6jT7RlEzvP3HbmV+PbGXsYwJrd7v8yqtWy1yKe9sOXAAyz7RuXiHmcX7MWAHVmruPDzPLvw9juTmZ9h2ZK/L3ABriMf52lCtlkuB//9BV3ya8R7Ld3OPrdlhabYuEQ9SmRw3M/ESicM5gViUyMZxSvJBhN4ixW/XssoMxm3cmcUSwjTcm+L6lbEQ4wE5kma6yh80dfpgbq9RIrmbchgW34CYBSj2IDj5K6UVavwYZIhXe8Gf/EKTGiDyUusJK5u1oM9Pk4v85VZY6t9bYrqbgRkjPoZtETWeiRGjfNFW5dytlSRoEi4QiU9CAudVf7FRwrRJlH491OiPH2WWMCQsGfgR5rCU+mScEg6py1ANiUFGUbrVBwbTZJtfvCbfwb+qpHzla7Yx2xdlVH7YdDxNe6APYxsjM9zSjmSaPc99h1606yVzfj32TJx+CHC4Fy5l1jGvCTXULLXXvSO/SQ5o99Inu4ToivuQ8jgfI0OINJ/4ec5BIH3quMf74IM8dtgHrkogruLGGmfPMwSCPgqP
 /iO8laXJ
 hSYMoVSmgOKuDnTawA63eUPdJSwBsTe/Qa983R2zcxghLXysYswTzbcpJBkVV8Omk+1iZITQTJm+LoEye1TDi8+EbuIyCc/kjgesu1511gzASs7/ykyAT/oNBrFexT340Jf4C5J2GXGcrv9BokJ+05ZQRPoFkF4lCVQ6jlOm3lT6v/Z8sEoWnrE1FUmMZKvZNZB2JST+4vh2UvPubbuq1Q7zQML0v89Fdzsw6N97JKqfKfzjKEtUwOI4wg4iedwqPbZLv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 11:53:50AM +0200, Mike Rapoport wrote:
> On Tue, Feb 24, 2026 at 10:29:59AM +0100, Ard Biesheuvel wrote:
> > 
> > 
> > On Tue, 24 Feb 2026, at 10:28, Mike Rapoport wrote:
> > > On Mon, Feb 23, 2026 at 01:18:41PM +0100, Ard Biesheuvel wrote:
> > >> On Mon, 23 Feb 2026, at 12:40, Mike Rapoport wrote:
> > >> > On Mon, Feb 23, 2026 at 12:17:22PM +0100, Ard Biesheuvel wrote:
> > >> >>
> > >> >> > I wasn't sure it's Ok to only unmap them, but leave in efi.memmap, that's
> > >> >> > why I didn't use the existing EFI memory map.
> > >> >> >
> > >> >> > Now thinking about it, if the unmapping can happen later, maybe we'll just
> > >> >> > move the entire efi_free_boot_services() to an initcall?
> > >> >> 
> > >> >> As long as it is pre-SMP, as that code also contains a quirk to allocate
> > >> >> the real mode trampoline if all memory below 1 MB is used for boot
> > >> >> services.
> > >> >
> > >> > initcall is long after SMP. It the real mode trampoline allocation is the
> > >> > only thing that should happen pre-SMP?
> > >> 
> > >> early_initcall() should be early enough, those run before SMP init.
> > >
> > > I don't think so. All initcalls run quite late in boot, early ones just run
> > > before the others.
> > > 
> > 
> > It is documented as running before SMP. If that is no longer true, we should fix the documentation.
> 
> Ah, my bad, it is running before SMP. 

But then it also runs before page_alloc_init_late(), and it's too early for
free reserved memory with CONFIG_DEFERRED_STRUCT_INIT=y :(

-- 
Sincerely yours,
Mike.

