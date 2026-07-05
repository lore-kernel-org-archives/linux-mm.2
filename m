Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC63CC43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 20:35:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A60406B009E; Sun,  5 Jul 2026 16:35:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0FDC6B00A0; Sun,  5 Jul 2026 16:35:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FEB26B00A1; Sun,  5 Jul 2026 16:35:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 638796B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:35:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E00C5167D47
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:35:38 +0000 (UTC)
X-FDA: 84955878756.12.7C61EAE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 22F7840008
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:35:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="Zl/aGuua";
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783283737;
	b=D8QbGyZEG7kLt2lmCYRJFBpOrjUJ2nmeCNEe5vdgU57gU/DT3tZgMbLe6QbAfNrtGok3Hk
	NbT5JXbYZsPRCltPYkHAoY/wPrdY0CpTqAiaPpGyb43zUdhlGRqD/nwfn0BIC+/63QfAqb
	HJMZpLks5hrxIL8XR1xCYtsWb8XpWT4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="Zl/aGuua";
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783283737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sa0TmpEiPh8i2xeTaaInBr++d04DMsnt6W0yXfVSjlY=;
	b=fA7VMMltrQ5d6INYU6Wf4XIRB4N4cP3cy6mifNNKs/kTyNrt1uBftnbtvqvx8KAPI9bh3D
	JBYu1Br85YVQ/uzE/M2cha+F7IkEhg+tU/EguYFL8TIaXNpWcdcb9Ra1X4KPEVGX8BPbUa
	2LafZscIAWxeplxh1S8TFEf7dcpaemI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4436941FCE;
	Sun,  5 Jul 2026 20:35:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9664E1F000E9;
	Sun,  5 Jul 2026 20:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783283736;
	bh=Sa0TmpEiPh8i2xeTaaInBr++d04DMsnt6W0yXfVSjlY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Zl/aGuuaiSi3T583VoIbLi29yqUPmVOK1rES3+kkX5GWbtgQbiq4yu4iroTC5NsDN
	 ccYfgNXwxORiyiEz48z/8L14iADbbq4FINCXUHVD8V/fGRJwaK/0+zV7NPjBid+0D0
	 xiCkdV2aZP1JtaDLHNtnU+bwCaSSCluH/KNZFFqY=
Date: Sun, 5 Jul 2026 13:35:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
 will@kernel.org, baohua@kernel.org, Xueyuan.chen21@gmail.com,
 dev.jain@arm.com, rppt@kernel.org, david@kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, ajd@linux.ibm.com, linux-kernel@vger.kernel.org,
 jiangwen6@xiaomi.com, shanghaoqiang@xiaomi.com
Subject: Re: [PATCH v4 5/6] mm/vmalloc: map contiguous pages in batches for
 vmap() if possible
Message-Id: <20260705133535.3f4e484e298a52122c6d4721@linux-foundation.org>
In-Reply-To: <CAHKocdGiK0ij7FopLi6b_rQ3CDyVr=ARbC4cCwNG=pY=iTME5Q@mail.gmail.com>
References: <20260618084726.1070022-1-jiangwen6@xiaomi.com>
	<20260618084726.1070022-6-jiangwen6@xiaomi.com>
	<akPKkOt_GNbAbyN5@milan>
	<CAHKocdGiK0ij7FopLi6b_rQ3CDyVr=ARbC4cCwNG=pY=iTME5Q@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 22F7840008
X-Rspam-User: 
X-Stat-Signature: 93qgg5pjybrgxfhx8esa64z5psny8qho
X-Rspamd-Server: rspam03
X-HE-Tag: 1783283736-889424
X-HE-Meta: U2FsdGVkX1/xNXnc6V2wMYq5BCopV+2bdtMTPGkAwRZsLXK+lP+9b5/7OPX5pzsORAsG+C1rrsMfJc7JZNQ8pkpNfw9HxfI4jRjZ1KUGNy02qPHJOUg3ENCRrZAkIwE+lu7o+YTBxqUqN01zykup3L+zibrjY9KF973jxkwDFtGzomHphXUHjyz1fPoD6YT6qJFTUvfjoFhnxhFaSZQz2dNM1DznsRJHulfRR/10Ta7eHZ8T3ey83Ry2ApleQxyP5LcM7oA4+kanfHyTBMGpGQMBALFunZiZiUocMYRK0be4jjziNrLWlq33H499pcqxf4Lo9yrYCi8+8b9K3N2HtSTa8tYPcEbwMbMrstVgd42mr/l5hpzx9bV/NhVmwwpiMMAz9AQ2ygmzi4NPB53zBEf7VwvlXRT59aGTfzTBFDDpamYYe879swKNc/LWo2Wk1dSuPFXhH9YP5+zlkv5a4DXcPzpAtd4XCRy3xIvGVBvuGkmlzY69R6W3VMw7DR6BYE4L9yWxfmYE3ZT9VzBuRfIqzL4RToBXIDuaiF4pALOA2CBeVVvVEvxbgdFZ+GYAsN0pzR/TK8EfWxzxreallF/r+2NBNBWTzcFKT228xlwEXEPqxWHMTUkL4VSqsm3IzmQ8FEvcGggVBbtVZ90wPNyj1tIJLpCoQM373yAuyqp0x9zFJ3Ta9IZtshlTJYEc3KYuKdba07ciRtkl2CPqGiCDuURHh3qNbcctPyvRMmrXMa7y/kIujkLZRV0EsDVXzPj8hdM3s2UBYMcu1agKBg8m4+uUQu8a4eCvrUzXuD/ZusDxACV+oUFrZDeb1d8AY107llLQkHTpIEEJxPqbCzSISZC9vY7nb0avGY+3wSt24oRtpvJvCW9OOQb70IHhlLu8ixbdIDEvEA+L1fO2TZTWPn7Xce0DwnllyvvlEGX1FzmNWXUHWan3GKb8gvdAQMn/WJyKBMp577XZkXo
 LdQA3f1d
 Oa+5GHNKW+bR3g3xOyWiF7855ugrCa1cYTT6God72E+dMeqsDBtb/D8xqMNht0C3JUHq7y2kxkMCac42kjUQh7VQun1AltMXGytzaQKBo25FoIlG1yQCGkyupLOFQGs2ejxpdgm/LcvkH3TijvwjyLiqzvl8+HIaHuClPt2y2zR/lw9saHmKZ+Qd7PAcTA8JWBybsm196+4ABwjbvuLOClfaVSiV5D/CC99hERwhIX8iiFsif/FPHEgvsa9emjKf50rkMDWCh5ETFFUKglQDdc+BDChqabZF9hz4+kUo7USpUf0V8hA1axTqVVJObxIoCn240vSjutaASMTN3DSbfQ5T2HibohhVISrOD2ILMTR02pE0pgHg2JYqTx1HFR/Rth2xLhWCbLyoD6PkZAYyIL2hdJnbVVVGvwUDG2ja+YYDhMcWQChqSQd5ItxF/aITRxFwL15Nn2+JTvh4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2 Jul 2026 17:18:51 +0800 Wen Jiang <jiangwenxiaomi@gmail.com> wrote:

> > Better naming? vmap_pages_range_batched()?
> >
> 
> Yes, I’ll adopt this naming in v5.

Cool.

Seems this series is due for significant updates, so I'll remove v4
from mm.git.

Some notes I took are:
https://lore.kernel.org/a6e410bd-7413-45f0-9033-a60cd5386512@arm.com
https://lore.kernel.org/a8ff2b34-5e5c-43c8-9de2-cf7929265853@arm.com
https://lore.kernel.org/akPKkOt_GNbAbyN5@milan
https://lore.kernel.org/aecf8ea2-43e3-4aad-810a-120b036d8bc2@arm.com

Also I added
	https://lore.kernel.org/20260630184129.4B62B1F00A3A@smtp.kernel.org

