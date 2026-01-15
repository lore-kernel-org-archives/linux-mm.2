Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53067D46638
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 23:25:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A16246B00A6; Thu, 15 Jan 2026 18:25:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C4276B00A7; Thu, 15 Jan 2026 18:25:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D0796B00A8; Thu, 15 Jan 2026 18:25:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7AB3B6B00A6
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:25:57 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 215381404D1
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 23:25:57 +0000 (UTC)
X-FDA: 84335783154.06.58E26BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7ED4440004
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 23:25:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FTE+9Tee;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768519555; a=rsa-sha256;
	cv=none;
	b=zku2F1K0TtO0cliOsXKsqaTHtygOcfO1NaypgY4WIV5uOaJpfwu5gyd4FMdbTncugatVPN
	hHiVU2LyqoO+rn+gaWVZjpTRoWpsNYXEkuJYPbm1xzq9Nk3l3Xg+BJU6HtGrGAclCKo9mg
	5D2sw7bhV38HAn+8edTPX/NdlYEuWec=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FTE+9Tee;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768519555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=35F0UGAc+nJhzTdSIAY5TYiFvIu/ZKVbe8hPMWSFlv0=;
	b=Wo5Q/mVdom26UF7m5k746oYAn7eDe/9OsWeF90rpyagzSR5KY2cfm7GY0XmZG2Cvpp6ZLr
	xU8heFtuGHB6N04dKPnnFFlsWTFV3aiXcHk68TUXKppeKWBjklfpcXDdjkOaO/My52lCNM
	wR74ROlRofdqWBOrSQz+g24qOO+r7f4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D279960130;
	Thu, 15 Jan 2026 23:25:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6725EC116D0;
	Thu, 15 Jan 2026 23:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768519554;
	bh=KNI/oHIqBgfFMx6fcMtlSdr/1pF66dBuyIEfjvW5BCI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FTE+9TeeEEAG4pXswNt4OyPdglAjdYLJe/pzK6B3nrjYX3SqXI5Gc+N6i8v/7or3f
	 8Eu9PDuruH3sHUyqe5XcIRMsEnAnAfqzWfwRul7b/pORFHmx8/Z3IEsrCP7bctrpOX
	 cGInBrbbDu98DSivWANNSLRM2zVmYVEEQeM3sYu8=
Date: Thu, 15 Jan 2026 15:25:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, Chris Mason
 <clm@meta.com>
Subject: Re: [PATCH 2/2] zram: fixup read_block_state()
Message-Id: <20260115152553.ecaef2749017cf2e8f171390@linux-foundation.org>
In-Reply-To: <wstf2ujpdkz5evedgqr2awze7wdwcmcluxntkqk2eifp5axjpu@lawhwffyeg72>
References: <20251216022727.578BFC4CEF5@smtp.kernel.org>
	<20260115033031.3818977-1-senozhatsky@chromium.org>
	<20260115140743.f7ada77bc912595a580eaf7c@linux-foundation.org>
	<wstf2ujpdkz5evedgqr2awze7wdwcmcluxntkqk2eifp5axjpu@lawhwffyeg72>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: tg7coq7jhf99f68t6wt9deg6h85h68rm
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7ED4440004
X-HE-Tag: 1768519555-700233
X-HE-Meta: U2FsdGVkX1+Z0NTsnNsG1HpcLVgi9vbpuvtOlTN8vP9YpVY154EddwYbhqo6/FmQBkvG3+v07FoStsBMSn9LkAMeI3NH9t33QUvYxdu+HSitkT5Pt6Wh3wfEHAG+BX/ty9UuaY2rLhEk+a9Z9g7WBiIvVOuef/cRJAZ0Ce/U3p/WPmN+/39xUt6dljQgFyUpvTy76+50K+LwkBfkEQDq+UvZU0jLRTiWL6ACYZBwTxz5aUR6PYx49SqfQidlkuMtDFV5iei3LD1q5xobdSK3ayFFXhYuXv7e2Lm4RLA6LYSHZeWwWU6/wjYLjQM7fSpQ0P4mCnfbGhAHtplYP/GQ+Kjv9RdF4DjzccttULoZpr3sq1x80J5CsMlB/fxkD7zqS86N6DEwGfc7eOdJ4c+oN017vBZyObZ11BgbvkW92OS97prRcpNmpoVFTF/XUf5tMx9bK6M1kLiegZzoy0v51g6DEMxeInbNBn96wKzRka/LLExZrO3+EB99WWtz6TNs82JyzBfcHUodXBT2n+e1Wgp/jgV09qoF07FZriNUuh3q/XHg0uwJxm1vr291nSSSLGINuPNabpYhyma/GjUlYvvtkr9Sa6xBUMaQKO8qG43B/9Ku92VSwua314DOqV7UcH9PiRuCfqKSRGtiB5u4TsVYcJ83lHryrpVTZy5KR6uSWFnUdCvnP5PS0BVOrDwqls8k90gvlFNoT/8xUH7SCQk3QVocL3OJ2mqDrA5zPTbMikGqsl3EjbLiPadAHL83zMYFfDRVX+Yekeq8wJRXsUjH1Tn1+4/q0b37SI+0AQ1UU57CqteUHO8A+ZDxEynr35JsG0kHrNQwnei3uL8oQ3N7LK57GTmCGlTrs6NdMlblSKraVJ4cCDg1gFmsdKciBsXe7vhkNgJ2qlpT69+wVyEUzqrhaMfmZjstBxHTEMnuuTT38qR2rsX/xIoxNziIxUZoE+acVWrYlMv3zgL
 2JIgLGo6
 j1qTZT0kA6pCNZflhK8xWJ4EU2xo6FUcxQcQs6Nx6YCkt8D27xqWDSIx4W9hi9C07pdbuh0D6WvDS5CNS7Teinmqt1YzJrt2vAiarGRnhmgfdpZ/R4nwwCLEL6q4JDmWbeJiuYac4+DyBtzYjh9JeSNhs1MiZyUQ2dW+aouGL2p4ADVmZ3R2DRAavocjfe2vvQgIFpMXyYh2IpxjqYmuWywHOeVhLnwL9hMPcAI0Rdwwz9RZOKiIX64V6psE28nxYzIoZZ4rr19QKDzjUZ1ViahtfcImr2gxUANolHlF77BNph95lWCdgX2sn3fW3Gk1/zfjiRgay9zHMIk1HVT6S6hgFcUTB8GegVbZaA7KtOw2pVjK5REWKF+GuUCnA0C+E2KlsGdSTKmYk3eDMx0LWZx2dsg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 16 Jan 2026 07:54:25 +0900 Sergey Senozhatsky <senozhatsky@chromium.org> wrote:

> On (26/01/15 14:07), Andrew Morton wrote:
> > On Thu, 15 Jan 2026 12:30:06 +0900 Sergey Senozhatsky <senozhatsky@chromium.org> wrote:
> > 
> > > ac_time is now in seconds, do not use ktime_to_timespec64()
> > 
> > Please help me out here - which patch introduced the issue which Chris
> > found?
> 
> This one:
> https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-use-u32-for-entry-ac_time-tracking.patch

I figured that out when I fouf Chris's email ;)

> > > Reported-by: Chris Mason <clm@meta.com>
> > 
> > The Closes: link would be helpful.
> 
> I thought that for fixup patches that are still in your tree we
> don't need Closes: tags.  If you prefer to have them, it should
> be this email:
> http://lore.kernel.org/linux-kernel/20260114124522.1326519-1-clm@meta.com

Yep, got it thanks.

Closes: tags are helpful when reviewing, to see all the info.  Fixes:
tags aren't useful because the hashes are unstable and because the fix
is destined to become part of the thing which it fixes anyway.


