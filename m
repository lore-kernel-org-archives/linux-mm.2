Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90D03D6AAF7
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 17:58:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA67B6B0088; Thu,  2 Apr 2026 13:58:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7E446B0089; Thu,  2 Apr 2026 13:58:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBA5B6B008A; Thu,  2 Apr 2026 13:58:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF18B6B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:58:49 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4A0F21A08A0
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 17:58:49 +0000 (UTC)
X-FDA: 84614376378.19.F42A289
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id B479780012
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 17:58:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="R4h/nqxa";
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775152727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xp1KXjlzb34uoWm/HPqaHunzLfUzOd7IrY6w0Xyql6w=;
	b=I5Ho40BFIMa4xOakCdqDMUSbPO8Gnb8hV9nYk/F25Q4d0/zSq+1QuXPZ0RPdFzSyNXYS/f
	b+Yda7zbWsTb/WaJYWm9GXPUboXoCkJJyDfTZx/OOkX+d835X/4P1/+veVhe6vXfISaN6d
	xxHQmm8wDeDSDAVcGsFqR9akccp0r9s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="R4h/nqxa";
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775152727; a=rsa-sha256;
	cv=none;
	b=OqKeV1NvY1ikIhHUGljS9RivUFW3bzhyTOUeidEpyr9ml+qpwbadpsIzDGGCS6ZyQMGFo7
	8RG37syRJ60i3+kIVLoJS+dDKd7rhZLTXtOedJAIcrgaLv4c2rD/DlIGajqbM3ahOUlg0L
	KmFskYkXuPb2Ak36UUV3LCF6VAnu3gc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C070B435D4;
	Thu,  2 Apr 2026 17:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC3FC116C6;
	Thu,  2 Apr 2026 17:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775152726;
	bh=lBe4YpWJXS/sZuCCHV9WDdwH1hkqW/YGfCjB92X6oqU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=R4h/nqxaaI/JOKP3X4Gup1XYtC4T102FTQ5qvlMyhJMFI2zcsFyJOQqK+5ypy3OxA
	 t0+enSjocY6eB8mI7c/6M+OaAOyCtUZVgZG58iuZem7ndSW7hsam2rKbhloXK/dvAP
	 1i1qMZidrX4COpdZQJ0mR6kkF0H1FmaGFhzfU1hU=
Date: Thu, 2 Apr 2026 10:58:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Chenghao Duan <duanchenghao@kylinos.cn>, pasha.tatashin@soleen.com,
 rppt@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 jianghaoran@kylinos.cn
Subject: Re: [PATCH v3 7/7] mm/memfd_luo: fix integer overflow in
 memfd_luo_preserve_folios
Message-Id: <20260402105845.f4d375734c0b21a1203fb9c0@linux-foundation.org>
In-Reply-To: <2vxzv7e9ftwd.fsf@kernel.org>
References: <20260326084727.118437-1-duanchenghao@kylinos.cn>
	<20260326084727.118437-8-duanchenghao@kylinos.cn>
	<2vxzv7e9ftwd.fsf@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B479780012
X-Stat-Signature: h7g1p1yi4g9y7o9uhhkx4rqodxk56ynp
X-Rspam-User: 
X-HE-Tag: 1775152727-255349
X-HE-Meta: U2FsdGVkX18e7ynj+fQWCQ/ooV6aAzPD4B8mdAG2auGLnTdInmuBrBBbfiQHhvi4zOuDIJZGBj8kQzvDt+2quq9qMdlNHAoBu5mKnkS0Y+zQBAbupz/4dQ90ooywn70vv6C9aXYta1F0cJBruAevY1tx141e9u7/lj5xK16sW+dnZVb6UAcuHwFKnKBzw6U+6YYo2VOdTT1pr+9wtyk604uNBSb2t7b7bSEl/VNq67cmf1k/w99cxVm0ywByJr6QGjCL2kWVTDWhhP5sQI1ObxRsDxYEkwuUWa53Y6PmlaEaLVYAIbfcyvgYQB+OxQNdegGIFzRiPAaxgHqQxQLB3bBSjy4T53OU3+UhT6VBgvjVXini6VFHqyqFatks+NyCJcLTqAPkB3uqlmZut4Wi+uwSEhb1/zhHmMCarYl89BOY1lhDZTDVO6RINHBV4P5Gw2NAm9IruCdV16nzsMvy9N1C5uZ89MaVziAe40jv+9NMBN+wyKD3ySR+/FebRXIxsCgvj4E1eFhmX4zTXhpmNAVPTn927FnZXbhWFbFNCP4VbD0yCcj56qrsaffUi2vFmj6t1WPVxbCstqZDqUkeuSLaC92QCQx4V5bFyCvnuThMZqLuhR+Szfwb+Soc0G69YGgON4YdCC3/6ju62uEvThSIoN+eoOE37V9zxnQt6YndPP8pD6SQ8cr1LqCsJcFox3K2J5AqOE8CUnUzkJc7S0ImksoSPl1hBeMh9nc1Fv9on9fUwtr+zrgO65SFXObUTKcIg/44Fa/XpqUhG8++UHVmlTAFmjHl/IsRcUXh/4a7gRr1lriOQ6F+s8RE829h4imJhjQu0bYxigr6rVByDGJFmSATSei8pHt9iikKngwwCwCLyJQvZcZsOK1aUn4ZqKTrRRHabKrfAeKR4YHHp2KzGA/s8QUO/KC47aAdkLL1AHtlk9WhtGQ8ssK3/jVcn2CgQ6B2T/AhE9eh5jS
 XvsX+fG9
 wQLSN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 02 Apr 2026 12:06:58 +0000 Pratyush Yadav <pratyush@kernel.org> wrote:

> On Thu, Mar 26 2026, Chenghao Duan wrote:
> 
> > In memfd_luo_preserve_folios(), two variables had types that could cause
> > silent data loss with large files:
> >
> > 1. 'size' was declared as 'long', truncating the 64-bit result of
> >    i_size_read(). On 32-bit systems a 4GB file would be truncated to 0,
> >    causing the function to return early and discard all data.
> 
> As Pasha said, KHO and LUO are not expected to run on 32-bit systems.
> Plus, since i_size_read() returns loff_t, why use u64 when you can just
> match the type and just use loff_t (which on 64-bit is long anyway)? I
> don't get why u64 is any better than long or loff_t.
> 
> >
> > 2. 'max_folios' was declared as 'unsigned int', causing overflow for
> >    sparse files larger than 4TB. For example, a 16TB+4KB file would
> >    calculate 0x100000001 folios but truncate to 1 when assigned to
> >    max_folios, causing memfd_pin_folios() to pin only the first folio.
> 
> Using unsigned int was intentional. We pass max_folios to
> memfd_pin_folios(), which expects an unsigned int. So this change is
> pointless unless you go and update memfd_pin_folios() too.
> 
> I think making memfd_pin_folios() use unsigned long for max_folios makes
> a lot of sense, so can you please go update that first before making
> this change? And when you do, please match the type of the argument to
> the type you use here instead of using u64. This can be a separate,
> independent patch series.

Thanks.  I'll drop this patch.  The preceding six patches are looking
well-reviewed and ready to go?

Chenghao, please prepare any update for this patch against the
preceding six.  Or against tomorrow's mm-unstable or mm-new or
linux-next.


