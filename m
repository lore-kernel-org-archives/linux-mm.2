Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E0A1606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 19:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=ZqPT3x0k
Received: by kanga.kvack.org (Postfix)
	id 589266B09B9; Thu, 22 Oct 2026 15:33:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5604D6B09BA; Thu, 22 Oct 2026 15:33:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49D2D6B09BB; Thu, 22 Oct 2026 15:33:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 28F546B09B9
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:33:31 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AF4794029C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:33:30 +0000 (UTC)
X-FDA: 85351261380.19.F14448D
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf04.hostedemail.com (Postfix) with ESMTP id 66D4D40008
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:33:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ZqPT3x0k;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf04.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792697608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mCLgkUSjfiPQ2Z/7aDng4XXocalO4USE3TUieu+yZLc=;
	b=1htF4F8XJjnWXA6SOwzc7xElsI+vy+RLG51/Frn7WTn89yOgTweQ+ySyKYKjOrGA43+Ygm
	OujE0dxbYWqOiylhpQvaZPUcyZSM28q2hyCZ95wC4TkKbqHHHo4uGgF/ti/xFCF5TpgaVL
	CG2CeibPyZg3swyniDWSzHbp58BwT8E=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ZqPT3x0k;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf04.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792697608;
	b=J2j1P8y5jJtk91cBSRX5Hl2TwN1FYD+52jat6W3/4T0c4yijCScok0YJVsnOMTZs6mwCBO
	OevTSQ9cqIXdl4ryaUWbf6J8xdgZGT6PYSLg7h1dCBijxX9TSGS73+doFYV6/NtKKNblO5
	zlbUBCq8VQsamWlDqGfrzyDDw5f4Fmw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=mCLgkUSjfiPQ2Z/7aDng4XXocalO4USE3TUieu+yZLc=; b=ZqPT3x0k+CkPYo13D5zgsJ31Zh
	JSJ2yQy9T2F9ZvFcBhY+Z/TsYvx16xi5yE85WvpB2WwilwZxtPJ172IuYZAlhKM9hBKf8xUo001L1
	KcTkOIdULCe5RBTRqtRCfz9nTJTrvqdnAA0jvDHlsZdkWIbYSA8CBt3y3Jlck+YFtCCpf8Kj7c0hb
	Rp1BprJM9xy8SSEPfotOjGut3et+hWHK00vTkqsylvvHEIpK9lniM1vm0xEQAAbmKmzsr4CmZZq5H
	qio3WsXzmjQC7G571OtOw+iVIhxTRPBYODRQA5oyszhf8Yi4Xf3IFUljEFquZQ2s/kCNk0eiKG7TO
	G75+oKiw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xJyXT-0000000EpQv-49dK;
	Thu, 22 Oct 2026 19:33:24 +0000
Date: Thu, 22 Oct 2026 15:33:16 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Jann Horn <jannh@google.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, bpf@vger.kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com, 
	oleg@redhat.com, peterz@infradead.org, mhiramat@kernel.org, jolsa@kernel.org, 
	akpm@linux-foundation.org, ljs@kernel.org, surenb@google.com, david@kernel.org, 
	vbabka@kernel.org, hughd@google.com, kees@kernel.org, mingo@redhat.com, 
	tglx@kernel.org, x86@kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next 4/9] uprobes/x86: Don't WARN if an optimized
 probe can't be written
Message-ID: <dabdsge2cphfoulqobeswzj7xxkvlq2qyyi3iauqgmftfj6vg6@hbmosdt6t4bd>
References: <20261022015712.1297331-1-alexei.starovoitov@gmail.com>
 <20261022015712.1297331-5-alexei.starovoitov@gmail.com>
 <CAG48ez0cG532aaXZF_asCDk+fsnQmE9L5PA9T+JN6OGdx6yjGQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez0cG532aaXZF_asCDk+fsnQmE9L5PA9T+JN6OGdx6yjGQ@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 66D4D40008
X-Stat-Signature: 9q71mbo686n5tfuootoo4idamsojdbm9
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792697608-363569
X-HE-Meta: U2FsdGVkX19OxXMZ+f1LuFcFABR1KvARbJRXriPieJWOkus3B9+dMDWxCI6AA/fKX2RmzRJGnKiYhoKtNDs8ya5LvRyYfcYaKwzj8X+tOWenPFewJb7W0+HYXCMmvKYiKBS9HBphHcACgUnPK/q3ChYKPP6eazP2YRqEcYc12ciRu2llbKegjJQot/oh2mCCwKaaARaz2hpXnueL5Yc+q0QZ2vO8obeYRGZ0O6dcfr+LWHIigBOwVW9Z/R7SZWvjGsVPGiTVcmTzoXMRJsl26yG5F9XgkR6MKPZTO2DBDAeei/Uhxm9gQAu9eBceNaHOBm0cy9WGgJ2iiubOwqgsV7q7x+YrSyTi82MWpYBxo7mXunJa3/grXJooqp5cou9ldTzz1Ya8+bKaL5TVdaQcbbwVh9O/xFPTD3bOPYX00ctdxp55THBs7koJGLdhVOllJPeLvRJ+XXfGD+txEho42bo3gOeAQxPCVaJNlVosJbrZdP7U3BLJc013+2x2i0BPbsnX3Hf3FSRe60wU8YSfcMF+zbjGL1mTgxLN6jYQkrGexfxBIR260YBjtxuT/p7pbrjd7MIp8vu49nKkIX6RXAfSG2aaT+k4+ZCrXHVZQXl0rvJMiGFxzPzm0yjBFk/ex7g6fQj0e6yTd7KlQHrB51tKGVw+g9vrPTWR2/rpRGrIdeRvvCoxmcZ6n7127kBumCAirWE3xYFVhWWXz9wEV0/7RnJBNmAkzfmNBUuR7Gp5nF6TaQJBCg1SHlSL7fb2F5aMCmhRRsW9JTRBIzfnCNd3Gq8nlzwHrkA9WDMLlZAYr00MchcdCrCicKeRxFGq4yxXRI4s5mRzrwGDVPmxyrKqPPV4KgzIQ258L+1DbgqjMbprmpMmiszkpKiQGADkz8wUyLWdRp/TfPu12UtQ/Q+yi1ttu98bIN9uR6BUoQlpJAW1G+fyNt3H+UtXbLGNqoJnBscwMEC97Vr3mzZ
 kQzLAOKL
 Rc23++V0wZK1FLFxPCMn4R5GCPMptKlK3hPKpz0cbcM+kFXFd6vdIKInTukY/fS8PvRkSr/PR/LccT7eLrFAYbVpmZ9J5/JGsk4cawS0b6Bd9ZJoSF8fR7KGVjWT7dtfGbXb36kSrnfnbBYAkml7HsL5k2jPOfsDfkaIn1xTsysMSniY3Gau/xC5jEQGGlKR5WOcjapwNbAkdHPRS4oeVAplK5LQsoyoWCEgztJaKDQ9SgUh9ovmUcIMIHixOW8ClMzKlkFGKOkwRQiMIjqwtyXqL8VhRs8vph61kGhvMBVs5go/TJrl9UEJFgjL3l2jb1eXUR9dqpubDZW1aRTWgkmeFEo1mdsW1EPYE+n9ePr0JQO/LC6IA3QgikdYcA2Y+rr77RNFFMsgAyXWepZatbGjcuA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 26/10/22 07:56PM, Jann Horn wrote:
> On Thu, Oct 22, 2026 at 3:57 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> > @@ -1197,7 +1194,7 @@ static int __arch_uprobe_optimize(struct arch_uprobe *auprobe, struct mm_struct
> >         if (IS_ERR(tramp))
> >                 return PTR_ERR(tramp);
> >         ret = swbp_optimize(auprobe, vma, vaddr, tramp->vm_start);
> > -       if (WARN_ON_ONCE(ret) && new_mapping)
> > +       if (ret && new_mapping)
> >                 WARN_ON_ONCE(do_munmap(mm, tramp->vm_start, PAGE_SIZE, NULL));
> 
> Not an issue with your patch, just FYI regarding this preexisting
> WARN_ON_ONCE():
> A failing small GFP_KERNEL allocation could theoretically cause
> do_munmap() to fail; the VMA tree has the ugly quirk that you can't
> reliably _remove_ elements without memory allocation.

During munmap() we may need an allocation of one or two vma(s)
(splitting a vma or punching a hole) - and those may have anon vma
chains that need to be allocated, we may need to allocate for uffd
reasons, and we may need to allocate for the maple tree.

That said, this path exclusively uses GFP_KERNEL which means we will
invoke the shrinker.  If the shrinker comes back unsuccessful, we will
invoke OOM.  This either succeed or it does not matter (we'll kill this
task).

The other two possibilities is that the OOM is disabled during
hibernate/suspend calls, or error injection caused the failure.

Thanks,
Liam


