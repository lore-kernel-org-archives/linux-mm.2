Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 391CDCCF2C1
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 14:40:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF22A6B0088; Sat, 17 Oct 2026 10:40:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA45F6B008A; Sat, 17 Oct 2026 10:40:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B9B06B008C; Sat, 17 Oct 2026 10:40:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A26C6B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 10:40:32 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9AF68402C4
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 14:40:30 +0000 (UTC)
X-FDA: 85332379020.11.2C4218E
Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	by imf01.hostedemail.com (Postfix) with ESMTP id CF9D340005
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 14:40:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of ej@inai.de designates 144.76.212.145 as permitted sender) smtp.mailfrom=ej@inai.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792248029;
	b=zerpVa7vi+5yS1usIPGR3hpmgGVNcg/3uRbeA9iNWK0VjnOiCRdAWWxEV23gXRYPGxKDI/
	Har+AXANmk75Kc9gJt0OkZ6XqvcpDdOEfW4hmJkjFuOcsALF3rJY63XUdKgbEbyPuKt3gx
	03MsVKytufauTGpMEPy23Y29r1syFWY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of ej@inai.de designates 144.76.212.145 as permitted sender) smtp.mailfrom=ej@inai.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792248029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r3X3z1z3iN1lFp9psrcamRpBzgWWdRLRwtFsKGYbwF4=;
	b=mz32p+teqCtfNuwc/rJ6fexxPZcsDX3wY9i8PMOGShVo2KyStoKrleMRaPiWX0ox+3BjbA
	MMusheIOWFqkNvPiq/vd2oKoNBGKQwlNA4hImdSUmhgBsN743hW+LsTiJVT7bmrdA4Tzpl
	0bHcMmC9zogukGzm1qcmoUxtEq1OmcY=
Received: by a3.inai.de (Postfix, from userid 25121)
	id 2C0D8100383D4C; Sat, 17 Oct 2026 16:40:26 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 29DB91100CD75B;
	Sat, 17 Oct 2026 16:40:26 +0200 (CEST)
Date: Sat, 17 Oct 2026 16:40:26 +0200 (CEST)
From: Jan Engelhardt <ej@inai.de>
To: Stian Halseth <stian@itx.no>
cc: Andreas Larsson <andreas@gaisler.com>, 
    "David S . Miller" <davem@davemloft.net>, Kees Cook <kees@kernel.org>, 
    Michel Lespinasse <michel@lespinasse.org>, sparclinux@vger.kernel.org, 
    linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] sparc64: Randomize mmap base and PIE executables
In-Reply-To: <20261017100451.2266781-1-stian@itx.no>
Message-ID: <s4s6or92-27s9-73ns-ns7q-7821or0o6o20@vanv.qr>
References: <20261017100451.2266781-1-stian@itx.no>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Rspamd-Queue-Id: CF9D340005
X-Stat-Signature: n3g87tqe3b7qy8136gonbs51q4zkk6jc
X-HE-Tag: 1792248028-837583
X-HE-Meta: U2FsdGVkX19Ir7qiezk3QhmBrv2BNgAx231YHr3ncwmPwGqHsFO3/T3ZUCyDA9OKTiqXr+unLI/jRlHw1Tvwimn6cCam0V2KkZDz8EbXoaOybgwSU4wHvwhOZqhchx4y997Q81qxFkLkL04inUnjZ53rCofRNYVzLk6YxgeLhGVgySWTUiH9lYshrtAZ8C7qe0z+1mZqtiy3lHQfISW48Rarin2ZGJNCV5fsEPLxuawzicBgktc89V4F13xCWF4yY0E1SipJzavSM05ImHPzCbX3FIH9boq7mghBzYBx3U0FWjE2Pz2PnQv8GoJ0LpLimN8uuaMlqn+y4dgD7NH8qu4WXprHZ57fkvkPq1B4kdGNRJTke+N+RI0ECoN6nh9a+Gv722dqnPpRU/XCGIfNlOBG4CPSZPsKu2ifCYT3k4E1J3oE1yEozRMKof6Thm3pDxq0c1gefO+Lhup8t1HPc1fBXXyrp87S1nExnWOlHOF5ZU2WMeGoz2FkYWduedyScr6F4nnkS3uPEbeww3BIQTHhFUOiVjnaKbdJGtYLC6Xjb/UDYAuVRNEHTjKevk9CQbJMqkPDSLEtUsydXYkPvGwXOjf42QVpaSWF13e5/b+kjPIsuCJ8kxEyP123nqxPpItgAj3r78xKjr4yUpyyLGOMM6+CHZ5TtZpkiMg6qp3vy0WWVxZ2Pz4QreOmDMwtp+PFMLHHFmu6GBf5OA34NayK7S2nT7o99v51PgnNZUDmf9n4tFHQt+i8txUzmCUIRfKuBpljDeFHbltl5sYvh+8bqbby2M/iO3x7cibRG5uYny1yZAV/46787iWKubFIc7AOGRwoMfWAzj5d4PzS5kVzIOooUuFnXSpBCAOnPkicQSXX3vbmBbgKLHdlMnUh6C/M258HlRhLq4MwFovlQnTVji+Uy2/GB+7WxUhfKUFsFXCP2lFrcOXW2ddJnPr/TIeRIG7tufKbhElcVru
 V/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Saturday 2026-10-17 12:04, Stian Halseth wrote:

>On sparc64 a 64-bit process gets little address space randomization:
>the stack moves, but shared libraries, anonymous mappings, PIE
>executables and the brk heap land at the same address on every run.
>Tested on a T4-1 and a T7-1 (sun4v) and a V240 (sun4u), with 64-bit and

I too gave this a spin, on T5240 with a Linux 7.2.11 base and
Debian's LP64 userland.

Tested-by: Jan Engelhardt <jengelh@inai.de>

