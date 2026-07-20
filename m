Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBF16C4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:03:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E1E46B0092; Mon, 20 Jul 2026 10:03:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B8756B0095; Mon, 20 Jul 2026 10:03:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D6276B0092; Mon, 20 Jul 2026 10:03:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D173D6B0092
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:03:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2BA09120184
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:03:56 +0000 (UTC)
X-FDA: 85009323672.01.17E566A
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id 835864000B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:03:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Y4SS0WKA;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf07.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784556234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u3FtMQ2QOU38YdAkrHE8mqaCXRSA5UpaTZ5/LtQ8iEI=;
	b=0outokUQqs4O6FYt2+kCqL45kct8eUOS1MZA5btBS0OBiqH57w4E02TQylpkMS7gg70Zc/
	y/qgCZ8pW3kunoD3aoD1cBA3/RIrcX56IM9MxDqKV11KRSFMTtClvyFmhouDmJirs1nDB/
	5bFm5Nn4U0XXxENzEgeDTeHd58izBqQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Y4SS0WKA;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf07.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784556234;
	b=x34+6ZlzTIYBRY5658/S7P5T9mveR10CZMa0JiVLoEmaUw7HtTdJjjo4txgPnLLP9/ldO4
	Vlt7vi4F+q1Rdn7zNW2q36EiV75U7XpWbe5W/QdJPCRsH05B/KEv8qEPWtJ8BFpDIksK1U
	J4FbcGhFFIA2S6pvppHzL2z7Ed9TtC8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=u3FtMQ2QOU38YdAkrHE8mqaCXRSA5UpaTZ5/LtQ8iEI=; b=Y4SS0WKAiZUEIWVWbInUENw/Jy
	VUXX/V0hfaVPt72bdhqIJ/UV7UMhdZ/FB6PElpTULGbDRPAQmACFueq6dY3YbyVhaqUWxuuJJeuv+
	uYYlEaS0cnLgMgYGLh5gPZ63QCqKjwMFS5co2nUUVrnilHaMNOq2eAUsNf/FTZ6HNO/0lwjHuwn5D
	m7oqSL2W1F2ffolm0CE/sTqVuliaa2oYJuJuxyTFdZHuLxq3Cbdgc1fDU+QKpCtUxApLiTjmQkQDG
	ktIHt5TEvFdmb10yqKJdMiE2FVv/x58gn6XzY6oafBc53V0dQD/6jzYydH1Op1zFpkYnJq81krAUe
	reubQfWg==;
Received: from [12.151.47.154] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wlob1-00000006u35-2D4S;
	Mon, 20 Jul 2026 14:03:51 +0000
Date: Mon, 20 Jul 2026 10:03:51 -0400
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org
Subject: Re: [PATCH v2 03/19] maple_tree: Add write lock checking with
 lockdep sequence numbers
Message-ID: <dzp5qpqjzc3j2jwnamgbv7j2blqcbp6xq5jnwvkm6hzx6fbjni@2vom3uipdkuo>
References: <20260630190843.3563858-1-liam@infradead.org>
 <20260630190843.3563858-4-liam@infradead.org>
 <ak5v9UDuieA-dNUh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ak5v9UDuieA-dNUh@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 835864000B
X-Rspam-User: 
X-Stat-Signature: gfzq8kimsabu6oc16xcwtzsj5uo144e7
X-HE-Tag: 1784556233-803245
X-HE-Meta: U2FsdGVkX19ohoQlbo7VkSqjAyVBTrcUMfsRj902m5x5PQWkgwldrWPpPFM4e0ekXuo7vSgOzOs96TTx3TnyTIOMYU4Ns2KIIBFwYpDIuaka5qSsmETAwPbnWdFx/fOO0S54nF08J6/CCEaKFEsCbqS0ftfsnO2YLcb1C+vFXZpS4tXlXROS3nw02aUXw6HpdcEB58k2tdeoiwRaXFXAz3hTt7+s8umo5bgsc74sw8kfPtby/ZrVMfGqqq//yuqAkmNQ3TQXdOUHWmWtEWTHDe5GcdW2p99hXKcCA0t5JDKx9N7J7nC7FAMZNFZ40AEzbGeWWbFcvU+sf9MP1ku8K0kEaTrRfrwkRImTZSRhDfjhQNLsmH4xckkUhUJbcnh/xm11TaKO7EOVEGSTboZ3pSYiK5sgAOGflAM/UHcNEMXfselAbe5z2ArNOfmy0COL5KTGQeIJsQxWDllURTxJlgsRdu7GAghc+HsZ99raNy1zqTstyNRTzXb7h3zKFka0PilL7BmFWuAcV5mkSQrEYTVqxI+awp+TiH9WD6rW387nylJfZnQf0XybLAnOe7z2orNow/bzdUYhWlsWy72LzbOE4TDDmHFblRQc2V/z6lndjBbK0PlGdxplrh/cSs/t8C3vxx2dQX/m9wHlaZdnQIoNw3x3tZ3mVBL6BcULd+x/x4Swkx5r3rO2nUZKqejpol0hFX0hwPd7u2E2QaNGLH5jAwEKG7g2qWrknJFmPV3B8mO2Oou3plRwp6MahCqK621hgR6xACNvUO/OGJ2X+/6fYLlSjYbebcYykLqY1Okd4JJf283kRB8Gwi5PEoPdLEsPgCbhirbBNQ+xCrZ2kQ9jmTPXmkWTYuWlJuzq0QCLsMIA6LIWk5KjyRvSLE78kaOJbNJ4gXfj4zSSm4VsCSJX4resKVnIe16wKfmxDxmMj4Np2WQZ2fZr1MlGjf9xjciCfUGOzMw1/MXy20b
 VBMcsaet
 byK/RefJns+jPtRwmljLg+kRlMxA7ESZi3WU0FIQsHEiS0/BJWjz0cYpw6/w5qFKWowiNtywDgoOMMiGs3A+b6nUjUvzbWp96vl6M0rFivQinglxXM6ZT7kbpAh3DpDSBxvj0LChG0IWMD81MvHRFib0l0gGUIduFp5XxCxm1WMUWh/U7Ss+aKtokby+RfSCCqtYi2N308h1yuYYIj+MTTdPusdnQ/T/Q6oKqTe4NSucbxUIH+0ksRKM17QDXUlKew7P/fdb2RTSqkV5xNkMZHrQuXu3cXIB0ILoi+Ub6lwKMCh+q+MM4IhWEsSJgicjgQ4FcxtN5+Xs6DJCQxf2o+ZVkO6TGsQ/eXMBf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/07/08 08:44AM, Breno Leitao wrote:
> Hello Liam,

Hello!

> 
> On Tue, Jun 30, 2026 at 03:08:27PM -0400, Liam R. Howlett (Oracle) wrote:
> > +#ifdef CONFIG_RCU_STRICT_GRACE_PERIOD
> >  	if (!mt_locked(mas->tree)) {
> >  		if (mt_in_rcu(mas->tree))
> >  			WARN_ON_ONCE(poll_state_synchronize_rcu(mas->rcu_gp));
> 
> Testing next-20260706 on arm64 under a stress-ng + fork/exit/mprotect workload,
> I'm hitting the new maple_tree write-lock sequence check:
> 
>     WARNING: lib/maple_tree.c:1188 at mas_store_prealloc+0x2a8/0xac0

No, this is not expected and I didn't know about it.  Does it still
happen in next?  I'll start looking at this while I wait to hear from
your side.

> 
> It fires from several core mm paths — fork (dup_mmap), exit (exit_mmap),
> and mprotect (__split_vma) — across multiple processes. The two cleanest
> traces are both in the mprotect path:
> 
>     WARNING: lib/maple_tree.c:1188 at mas_store_prealloc+0x2a8/0xac0, CPU#67
>     Call trace:
>      mas_store_prealloc+0x2a8/0xac0 (P)
>      vma_iter_store_new+0x2b4/0x3c8
>      vma_complete+0x258/0x7c0
>      __split_vma+0x64c/0x770
>      vma_modify+0x11fc/0x1808
>      vma_modify_flags+0x18c/0x220
>      mprotect_fixup+0x22c/0x4e8
>      do_mprotect_pkey+0x558/0x720
>      __arm64_sys_mprotect+0x88/0xa8
> 
>     WARNING: lib/maple_tree.c:1188 at mas_prev+0x160/0x1a8, CPU#67
>     Call trace:
>      mas_prev+0x160/0x1a8 (P)
>      __split_vma+0x658/0x770
>      vma_modify+0x11fc/0x1808
>      vma_modify_flags+0x18c/0x220
>      mprotect_fixup+0x22c/0x4e8
>      do_mprotect_pkey+0x558/0x720
>      __arm64_sys_mprotect+0x88/0xa8
> 
> Is this a known issue?
> 

That's very odd.  Does anything show up with a lockdep build?  Your
trace comment leads me to believe there is a lot of these triggering
with CONFIG_RCU_STRICT_GRACE_PERIOD, is that correct?

Thanks,
Liam

