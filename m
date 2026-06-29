Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2AC9C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 02:10:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 553086B0005; Sun, 28 Jun 2026 22:10:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DC646B0088; Sun, 28 Jun 2026 22:10:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A30E6B008A; Sun, 28 Jun 2026 22:10:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 07ABA6B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:10:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 705A6140535
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 02:10:09 +0000 (UTC)
X-FDA: 84931320138.20.20CCCC1
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf05.hostedemail.com (Postfix) with ESMTP id 236F4100006
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 02:10:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2026052701 header.b=QYiS6laJ;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf05.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782699007;
	b=xRHwdV5WZHXF3Y8MgTzSOOsOV3paYJcDcBfIm3fQADfQ+rePWUX0gcDvQFKPZYcs0TsPNz
	EKgYbSXTp/3/zHwLc5NgdHMBGjaTillIHtCX4VQJsdVmJivOsItsXGJdrrEBZtNUIc5P6l
	TTPCIPUq9mCo+Va+blteeybADn3pe+I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782699007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kv5dJD+a62Qg64IepgQhkySKSNHhTKfnqhs3Kx+EjjY=;
	b=Du93J5cVuwun5a64EbCWVw8iE2mkHDed/aAmbFPfK0HHvOUTYmkQ9U1Z0R3aL8PRCOaNzF
	pT8pie9dvGT401oWPiubPgpfsLvMzocH4nhsx3r07Cc/cFh8jQllxWztg4OOM1sEpZBphu
	CzSyqMdKvjVArHavlPw5aV1T+Mjeh/A=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2026052701 header.b=QYiS6laJ;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf05.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
Received: from [IPV6:2601:646:8081:7da1:29ce:814c:118a:de3f] ([IPv6:2601:646:8081:7da1:29ce:814c:118a:de3f])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 65T29gd13309161
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Sun, 28 Jun 2026 19:09:42 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 65T29gd13309161
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026052701; t=1782698984;
	bh=kv5dJD+a62Qg64IepgQhkySKSNHhTKfnqhs3Kx+EjjY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QYiS6laJ6bh/Gvvs2qYuXGqIhK5K9kUoaFspoLYFcbNE+I3wVgLg0vVOi9+DzeH3R
	 rO6O6esbn1KCXDDCOf1UVuLiuRjgSlPruj8f5GOLxwHNgb94YMVOSY+A43KGT3FHwH
	 cvVJhSIQmX6mRDi8juy2LqQCpg0D2Ym71EPwKPF6mqxXlNX3XabiNy4QgRlztRA3Gg
	 NMGIfHAan3qEU3IrfeTVpNLTtbVGYRZBrII61mq4WZ3HNLDMgUAYSreMCFSbo3DpQM
	 59rflZB0TxyCuDmB1Qgqk/M+5uI7b6f88Vg5Mcs3dsnxHckFCn80Nj3aFsnttj/nLE
	 A0B4I8tYzE/SQ==
Message-ID: <499a4e15-34a4-421b-946a-c855199fdbf9@zytor.com>
Date: Sun, 28 Jun 2026 19:09:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmalloc: widen guard region to defeat ENTER-based
 stack pivot
To: Xiang Mei <xmei5@asu.edu>, Pedro Falcato <pfalcato@suse.de>
Cc: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        linux-hardening@vger.kernel.org, Uladzislau Rezki <urezki@gmail.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Jennifer Miller <jmill@asu.edu>,
        Tiffany Bao <tbao@asu.edu>, Ruoyu Wang <fishw@asu.edu>,
        Adam Doupe <doupe@asu.edu>, Kyle Zeng <zengyhkyle@asu.edu>,
        Yan Shoshitaishvili <yans@asu.edu>
References: <20260626173444.2252041-1-xmei5@asu.edu>
 <aj7UNceukU9zYeGH@pedro-suse.lan>
 <CAPpSM+RVFDOYJFT2iwgNYdjbwqF-MmrbYizpLYksd1SLb5bT9g@mail.gmail.com>
Content-Language: en-US, sv-SE
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <CAPpSM+RVFDOYJFT2iwgNYdjbwqF-MmrbYizpLYksd1SLb5bT9g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 236F4100006
X-Rspam-User: 
X-Stat-Signature: qx5k64tyot6ywa6mhan1nyyxqrzcgi84
X-HE-Tag: 1782699006-953600
X-HE-Meta: U2FsdGVkX196EqxlBr7KktaIBr6N2FpLsNRamTMfRTt4tuELKEdRbXONG4s0WR/7jjB547uMzE1qKDTarXlINuBcj67RlSD3OYeXkcpvXX0U6N8+dOMSpTn/ZGAUroZzfz9aV11XUR6dK7ptN4oyvPbe71gATzzGsHSwncxYTSSQwtR7lRLe7lDqMOy3sgfNegTwITQ6b13qf4o/x7VUjwzpsXSOA3N7BC6IzYwaLlF1kpVRMrzZdc2wqERGjuZTt5h/HI4Ke7/FHGiXfg4XkcLbKbW7v9OP1vTV5b8k7WTWGSo1mC6J1WQo1GLPIMxS1e7rRg0RuiK0LEjB8dLnadIlBpYmhb5OUOsmJRSODNinDhCR5ut2G50Vgc7G/zy+7IIrureqzKvAVyVX6vCWe8RE5zdcD9XgQaiLOfuwrpN8jqF1RLeFbSrz5fb8Rr75Y+pZiC7wtdmorAgQuEjv6lp8Y55ohY9ri3+dcVorbELqQNRUIXv6V1G6uFYnovgxvosUFJ//5UHvfYEZzesc+CmjxZNEdY+QRyVmN3gNiuJo2rvAbiQceaWO08QGt5b1C4IqPKFCGnyPibbye14HW1+cNt5vXjWLzaCgpdF9fJryVpb0BxkWrf0Sa+F4QcMSwapoPHkuPC8O8aIIv7dUww2Jun8jzYCOgrxWpBubJ3k4XwWFIZUDGSrA8hN0Hsm7MiN1zIHb9gMPV/omo4lioTfNcbjtpbul/n3g3Dxii3xdYXHsVe99FEyGV1wj78dC4Cvmn8VtpOOIRWZe+cmuXIPEVAyuwLOPHVV3ygVVlii7pFaFewSR4XQHDiMg3rxj0yxOGurDFQL0q2UslekBVC1d4rUEXgRMnE+lAqcC2GLPEzU27hEGWFdvvYAzASeq5WHpHeFTEd6VDMm6AmIuwZKA+oKl1fnaiq92X8HOB/CdKO+lXt8r0SDPoPpRgVkp/3H+HayU7gZEH1uGKHH
 z6qupM1t
 ynSKWDi/4o/2SE2mcy19vxqov50+lOhFvjx0PMcOeUV6nBB4sbTuOI2amQ4Ccxvr1dMvj4gFsChmFIyg59VlonQBIiqzfH5rirvLSfxYC5skHKn1qPOs5tWpx9lPo6adUGmjRiKrGJXtiMWgF7oJPDbNnJCUFrlMeLy5Z1r7amsAqYr5RW0bRLRGgUR07go/e1PIkXuGeX0A6O4vg57leqe4jkEC9w/iCTMt2FYaxj8cUklOkvq1Fouc+IdhjLP7+tbP7a6W8CBlul+4U67gfVhhSpppq0PtMRW8KmRhdlJgdE6yqKrd++xWJVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-26 13:05, Xiang Mei wrote:
> 
> Thanks for your questions and attention.
> 
> 1) `enter` can do big enough stack pivoting (where we can't find many
> `add/sub/adc/sbb rsp, ` doing so)

Say what?

Using add/sub/lea on %rsp is probably more common than enter, because enter is
considered kind of slow.

gcc, I believe, will generate "leave" but not "enter" as a result.


> 2) `enter` is not rare since we can take part in the instruction.

This sentence doesn't parse.

	-hpa


