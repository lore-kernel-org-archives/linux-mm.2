Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD69CD1268C
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 01:29:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 116A66B000D; Tue,  2 Dec 2025 20:29:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C7396B000E; Tue,  2 Dec 2025 20:29:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF8B76B0010; Tue,  2 Dec 2025 20:29:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D778E6B000D
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 20:29:51 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 79AE113AC2F
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 01:29:51 +0000 (UTC)
X-FDA: 84176428182.14.73D9DE0
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf21.hostedemail.com (Postfix) with ESMTP id 930911C000A
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 01:29:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=grU07+R6;
	spf=pass (imf21.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764725390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pTga2TAwNScG/3kVeor5h8KiVEoB630/ynsQmQFDxGs=;
	b=EmvB4cyaiSKKbdSRohM9KNFiO/IRgcTijZ+LtoPKzlMmA32RPBY3S1l9ivr8+Rm1pmh6mT
	ejeBtxBhRtvfcvnMPm0EOkehUUg6skdYj11hdmeaDWaw/EzuG4ZvWqawi4Lmnj0+D5yPNi
	LF/lkgWwIvl7vuY4j9zNHOMSsV6u6u0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764725390; a=rsa-sha256;
	cv=none;
	b=wUY4omh17hkR/mvyCBrDbzVnBKY4oeAOF58ReN9K2t9xsB1mhU/ZEo0JZr7I8lkTZOKNeL
	CcBwE+RjVtMBxc3kWGEjnN2Ltvq7yakr2OL/IAZEjQs3SSi7seot02LM4pbFyi2YYfeUfR
	LnQDM7IEiYSHnrTD+Ui1JY9ikomAekM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=grU07+R6;
	spf=pass (imf21.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764725387;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pTga2TAwNScG/3kVeor5h8KiVEoB630/ynsQmQFDxGs=;
	b=grU07+R66tQWTudKxjuJrjV0MqznBwqRktZIsP40MY//R1tW1KaoBOXYQvn+qjXW6ahtjY
	h7bzYUAxwwXES071fBPRlZzCn3xf/UJYEdr60FoYqgr0RMvfY9HKf6UgHTUTYJvxvLSPQ/
	WpfOo8sCVlsEOsX+c3UZxuSctWTLboM=
Date: Wed, 03 Dec 2025 01:29:36 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Message-ID: <e5e5bb62c5a40d2673cc1233860143571aab9d12@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v1] mm/kasan: Fix incorrect unpoisoning in vrealloc for
 KASAN
To: "Kees Cook" <kees@kernel.org>
Cc: linux-mm@kvack.org,
 syzbot+997752115a851cb0cf36@syzkaller.appspotmail.com, "Andrey Ryabinin"
 <ryabinin.a.a@gmail.com>, "Alexander Potapenko" <glider@google.com>,
 "Andrey Konovalov" <andreyknvl@gmail.com>, "Dmitry Vyukov"
 <dvyukov@google.com>, "Vincenzo Frascino" <vincenzo.frascino@arm.com>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Uladzislau Rezki"
 <urezki@gmail.com>, "Danilo Krummrich" <dakr@kernel.org>,
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org
In-Reply-To: <202512021522.7888E2B6@keescook>
References: <20251128111516.244497-1-jiayuan.chen@linux.dev>
 <202512021522.7888E2B6@keescook>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 930911C000A
X-Stat-Signature: g1pocqrj4jo7zytaqq8qzu4gwffrg3sr
X-HE-Tag: 1764725389-134430
X-HE-Meta: U2FsdGVkX18VpPUOBVmqchZqDszN22KuoYvljfZYnnRCNti0SAJDFNo32n38AGnUzm26NoKmtUdEoWxZVGotLqP+A+2JQLBtH7fs8uUHJZdR+73G4RK2eAU4B13AywRMBubQDAWlzNihbHcsZYQw7JAiNK1ZV9VLxdunfcH56o+IZJ+p+7kpuS9AMW3reWd8ck/A/kBgoO46tbJ+qZTx5FxI8S5Xr4I6oypHTjkgL3FP3moJzJd2vf6dqIR8FpWV4qvsu7K2yZJSJU2WbdZt3fVKJzg1vTV534Ad6Upbn3TcxVtXYtAG0grGD+LX/+a2HGuWi3+HzELIhxxERNB23O0m182BNPJbWNdUvdUzXuhaOoCUg6To9zRMvniXdBAVQ6yyTWX1sWqpsDj2j4llqZde7Nsz4slJqxqGdnROG35uFQXS9sRF0NrU+WziPp18vMqFob08RZvpZaQUa4tvY5uLDqnIPzd2g80zLFaztmdSR9T04SLpOqYNji7tImgoVCBHYOuMA3GZCMYAiTWVCyHwW+LHkc5axrfUchwPva37z4gWIO0tc995kTsVBHOTVppggzQl1vwZlZNu7uFxpP57+KkvOHdAKYFS75I+3GUPMfiRT4AHCG0/FUF4c3Ele1VqDyFNTQWngBC6GOh9f8TesLRZOWmnMR3GXfOAdDPfd5j5GIjObDhzAn3FtKVel3gj+3g2RohVV9W3+n03U7Y388+cd/xgdRVqk0k/QNHmrKb1OYtjZjDuE/M/BPEJVEIoqpnWCS6hD6bxxOSSir/NEzaQD9NLooK8l3kWmu2S2Hby3P53cQuD3jflCuYSM3wqD9JAmwAyZcGGf4IvH6oXqwCggx8IZl1uk6HT6GV8VWDdEj3TgAdDHsbBIi6eyIq9Mcnr636NVuvQFsdO4DJiUhHeg6/h7BlrGxkTNJQkJOOje0Yf407dd9WoWeUrsYYzOVfNABp1V7+K/U4
 gtA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2025/12/3 07:23, "Kees Cook" <kees@kernel.org mailto:kees@kernel.org?to=
=3D%22Kees%20Cook%22%20%3Ckees%40kernel.org%3E > wrote:


>=20
>=20On Fri, Nov 28, 2025 at 07:15:14PM +0800, Jiayuan Chen wrote:
>=20
>=20>=20
>=20> Syzkaller reported a memory out-of-bounds bug [1]. This patch fixes=
 two
> >  issues:
> >=20=20
>=20>  1. In vrealloc, we were missing the KASAN_VMALLOC_VM_ALLOC flag wh=
en
> >  unpoisoning the extended region. This flag is required to correctly
> >  associate the allocation with KASAN's vmalloc tracking.
> >=20=20
>=20>  Note: In contrast, vzalloc (via __vmalloc_node_range_noprof) expli=
citly
> >  sets KASAN_VMALLOC_VM_ALLOC and calls kasan_unpoison_vmalloc() with =
it.
> >  vrealloc must behave consistently =E2=80=94 especially when reusing =
existing
> >  vmalloc regions =E2=80=94 to ensure KASAN can track allocations corr=
ectly.
> >=20=20
>=20>  2. When vrealloc reuses an existing vmalloc region (without alloca=
ting new
> >  pages), KASAN previously generated a new tag, which broke tag-based
> >  memory access tracking. We now add a 'reuse_tag' parameter to
> >  __kasan_unpoison_vmalloc() to preserve the original tag in such case=
s.
> >=20=20
>=20>  A new helper kasan_unpoison_vralloc() is introduced to handle this=
 reuse
> >  scenario, ensuring consistent tag behavior during reallocation.
> >=20=20
>=20>  [1]: https://syzkaller.appspot.com/bug?extid=3D997752115a851cb0cf3=
6
> >=20=20
>=20>  Fixes: a0309faf1cb0 ("mm: vmalloc: support more granular vrealloc(=
) sizing")
> >=20
>=20Is this the right Fixes tag? I didn't change the kasan logic meaningf=
ully
> in the above patch, perhaps it should be commit d699440f58ce ("mm:
> fix vrealloc()'s KASAN poisoning logic")


The tag you provide is about shrinking but the issue I encountered was ab=
out
expanding(Grow the vm_area) and kasan_unpoison_vmalloc() didn't work well=
 with expanding.

Thanks.

