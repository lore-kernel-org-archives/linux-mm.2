Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2B7C606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 06:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=KyAaAhH/
Received: by kanga.kvack.org (Postfix)
	id BD6916B062E; Wed, 21 Oct 2026 02:11:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAB7A6B0630; Wed, 21 Oct 2026 02:11:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE9566B0631; Wed, 21 Oct 2026 02:11:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A44B6B062E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:11:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0F89280453
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:11:14 +0000 (UTC)
X-FDA: 85345610868.30.91FACD0
Received: from mta0.migadu.com (out-217.mta0.migadu.com [91.218.175.217])
	by imf23.hostedemail.com (Postfix) with ESMTP id 97271140002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:11:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="KyAaAhH/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.217 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792563072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RoigheuXlEgEVVeOm0wqZxiwY5/DXHnZexKpxuh+vtk=;
	b=w7opRstwcyXQWvsLTA714f6qUaoc6N7gBqOZ48ZQzj5CoYPQH6H5H41Bv5DOxriof52Ku4
	8NavCjYe31KysIYZnbeHOnxXwJJ8Hw2dGrDYqI6EIfHiGe57kU2u1Is1pjCIchSQN1XBwo
	WsHOnflIupcJ09kIn795XitpPjCG94Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="KyAaAhH/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.217 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792563072;
	b=hWt7rhGTYBrUbqF9UtZyJde7q+YubwVTYhkB/rJPDKU2R1TL7M+gGyaOyzEsi+PUZdXxQM
	B83p4VP/5OgN4ldANCj3PuuIn9svQNgpaNtFN5N9Alfmb9/eGiliK37ajtEUUfMnARKyUK
	PibuLrcTXm11MC1CmxOVZxLRIb58kMI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=RoigheuXlEgEVVeOm0wqZxiwY5/DXHnZexKpxuh+vtk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792563069; v=1; x=1793167869;
 b=KyAaAhH/eYfv2EtlnJFOXQeqVG+6ADHWw8k6iQd17UIBgcsZIaW1WIf+o+/Q81kvO7aqjckN
 k9gsBbyAi4mn1MRj7Lgh/OA4smyfnFbNsOgKeACNDfbNnJViy7hw/dO6dgnysEK4hYW6c25EUpP
 Ur5IANeC4CF42e1c02Tz/W/U=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 73700c2a578380af;
	Wed, 21 Oct 2026 06:11:08 +0000
X-Mizu-Trace-ID: 73700c2a578380af
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: pratyush@kernel.org
Cc: rppt@kernel.org,
	pasha.tatashin@soleen.com,
	chenhuacai@kernel.org,
	ardb@kernel.org,
	shuah@kernel.org,
	ilias.apalodimas@linaro.org,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	ruirui.yang@linux.dev,
	guodongtai@kylinos.cn,
	kernel@xen0n.name,
	graf@amazon.com,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: Re: [PATCH v5 2/5] liveupdate: synchronize EFI KHO channel at execution
Date: Wed, 21 Oct 2026 14:11:05 +0800
Message-ID: <20261021061105.3697-1-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2vxz1pal5u64.fsf@kernel.org>
References: <2vxz1pal5u64.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 97271140002
X-Stat-Signature: ozfkigksn1rhirwuw3ufxz71ate3imio
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792563070-165573
X-HE-Meta: U2FsdGVkX19o4y4LE4D/2cI3jFt3oPlYtQax/lhkdbMbmFvtEmcVbxhSoEYLR3542qUqV1jw2ybBs2bCFys+UwUaix3hMNS9IlWR7yrjZUOLDd5b8tWiR9zm7HIC5d7ntCUlqUxkMlsO86FjP0lpw0+zLa7VaLVTaFqwy823uDtQrsOSiuqFbu8yzd5pG9IeOR5MXY+l3BJoGZ28INLthAZl/mw0KQuX8dgRZumaouwV+18gr2SxYeULMLDZameJI2Yyxrj1sOsvbaW7HIGnUEDC3GDVwbyMWzOLHgrMKJP0gYoU1ZOvwcQ+Yi7CZk1m+B5dpiheqhJUMgTCEbKOrlZTBywWa/aaKt602SBTOceioLzy1ihseaqykbgGNoqxlnhWTqEdI9RwZyD2DqWcRWbHludejArYLCQLiU06ZNr/LZkvduVosa2k/sWRzuw8ejCRMaDpp+mwLK/L5rmc3KapOSGW8u2XZyGnrxXD2RH8FXeSZnQlpZI7i0perD4hT+lawp/e7B+34G6ctIpyDiiuOKs5BPOtl3TxL1ytxO3TbKLaXC1wAjpx3HALd04FS33n4FPGkVkYp1odTY1LDNkxeg/x8LOm5BUJusx63d+s7x517/FyD34ONh3v+pUrmhjpihraLW+Vhz1zEHMgA87mzqDM0d0IN62XB1MZ6FKQoufZuAYJlomznSMmOvQB2W1gh/ZFwbRUVbSgzOY2SRAhCtu7JyviJXe5a+iLGlausmQeMZ2QAWraA5S/tDG3CjonRvcdn1vW/Fn9fYhSyBr1+5eQAaoIZR0akUrD11k4dXYCULLIzIiDxv7eaEKrh6wDZG7cURlzrOiZOwmV3cdEw/RrOZvpE7Xa65pgcArw9njHBz+hQoRV/SE19GFD8jDfX/oWyfEJ/1ojW3no3ELoMFo3d3sL4iOh7T9TNFSEuAFgpEc2zW0kIPhyNzgnCGXvjE9cMdOojg7tmFC
 jFeAO70c
 aJkQAECN4wjmLA3JDtAEkU7X3MMld19t7QHNKiHeGNpxk3Jka295uxiUAfZvLQaMoeYUmfJNUPiiHFNGyhYu38S36EbARRJIDbRP3Ud74Miw6ZVaC2ciiCqfB35EIRzOsvKilSq+GMjWNOeXdVGlPdeCd+qjc1825R7Q13PgcAPJ23kdXsboKb5jRPvyzr6+5Fn17x5ZPp9HsacHCCjwt/fQxruntEDl7W7LBJ20s4CW60EM8p4D50VLGASGvI73c3Y//
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Pratyush,

You are right about the text, and I am sorry. I used an LLM to help
write this series. I meant to check every commit message and comment
word by word myself before sending, but I made a mistake and sent v5
to the list before doing that check. That is my fault, and it cost you
time trying to read it.

For v6 I am rewriting the messages and checking every line myself before
sending.

On Tue, Sep 22 2026, Pratyush Yadav wrote:
> > The EFI KHO configuration table is a global channel. Updating it while
> > a candidate kexec image is still being loaded can leave the channel
> > pointing at the failed candidate even though the previous image remains
> > installed. Synchronize it instead from the image selected for execution.
>
> Huh? Sorry, I don't understand this is supposed to mean at all. What
> failed candidate?

Rewritten in v6.

> Why are you setting this at kexec time? Why not set it at load time like
> every other architecture?

Other architectures store the KHO addresses in the loaded image itself,
so each image has its own copy.

The EFI table is shared, but the normal and the crash image can both be
loaded, and they need different contents: the normal kernel needs the
KHO addresses, the crash kernel must find the table zeroed. Whatever is
written at load time is wrong for one of them. For example, after
"kexec -l" with KHO and then "kexec -p", a panic boots the crash kernel
with KHO addresses that were meant for the normal kernel.

kernel_kexec() and __crash_kexec() know which image is about to run, so
v6 writes the table there: filled from that image, or zeroed if it has
no KHO state.

> Also what's this "sync channel"? Use simpler words that _actually
> describe_ what they do.

Renamed to kho_update_efi_table() in v6.

> > Use the actual scratch payload size rather than its page-aligned segment
> > size, and propagate update failures before live-update serialization.
> > Keep clearing the channel for cold and crash images best-effort.
>
> Huh? This is word soup and I don't understand what any of this is
> supposed to mean.

Rewritten in v6.

Thanks,
George

