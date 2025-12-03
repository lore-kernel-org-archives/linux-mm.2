Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FFADD1268E
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 02:05:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 625176B0011; Tue,  2 Dec 2025 21:05:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FC766B0024; Tue,  2 Dec 2025 21:05:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 538B36B0027; Tue,  2 Dec 2025 21:05:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 42D4F6B0011
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 21:05:24 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BFFA91603EF
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 02:05:21 +0000 (UTC)
X-FDA: 84176517642.15.3BCF11C
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf26.hostedemail.com (Postfix) with ESMTP id DCF4C140022
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 02:05:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U7HNZreu;
	spf=pass (imf26.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764727520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FPy21LS9S9ludFgcJ2xXTrctbrNoQvJ7KLCEgrlMWY4=;
	b=O1MxRZIbCN/Sg5Yj9s/Zk1I8LIT4b2fy0FwayJYIG7Y8b70Ud44p1ZtE1K+MzQl2eQb93p
	F9z47s+RWVzHxY/5oiHJd5NIp2fQiQ1VpLlT5lRkavlRFMAQMzegKUUBB3ciiouN1WftOR
	9RWzICd+lJCkpRVRGw6DlgRJ4KosBZQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U7HNZreu;
	spf=pass (imf26.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764727520; a=rsa-sha256;
	cv=none;
	b=BCjLW6O6Qececp2rf2LruzPFZDFtdx4amikQ2yPSsiizrM8WglxIrDBL+MhHaWiGszz7bH
	D7OfM0LskxC9pvuAr6RWc1dPSejNvCFcXWG/wK3dqOXk6PbNqxdxk9az2LlaFpYbrDvqpy
	gSFND7Hkp47fg/1NVdnF7+pcOKglpkk=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764727517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FPy21LS9S9ludFgcJ2xXTrctbrNoQvJ7KLCEgrlMWY4=;
	b=U7HNZreuY+SKQM4W2W/A4RDpj/eYJW4S4KdiwUKujs4SG+sE5YtcwoncbbuHqaRF1t/ign
	lIUXuLv8OH8xhDENOskVZGWWbSSmgxxvdsr1yqOudR9eJYxTlTREjDgHklusmUfdQaoDLX
	NmWZ6xagQosAiKFHOVuevF5ozfke8VM=
Date: Wed, 03 Dec 2025 02:05:11 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Message-ID: <fe3436bcc785ae432edb9a24aa8993e8d25dad9f@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v1] mm/kasan: Fix incorrect unpoisoning in vrealloc for
 KASAN
To: "Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>
Cc: linux-mm@kvack.org,
 syzbot+997752115a851cb0cf36@syzkaller.appspotmail.com, "Andrey Ryabinin"
 <ryabinin.a.a@gmail.com>, "Alexander Potapenko" <glider@google.com>,
 "Andrey  Konovalov" <andreyknvl@gmail.com>, "Dmitry Vyukov"
 <dvyukov@google.com>, "Vincenzo Frascino" <vincenzo.frascino@arm.com>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Uladzislau Rezki"
 <urezki@gmail.com>, "Danilo  Krummrich" <dakr@kernel.org>, "Kees Cook"
 <kees@kernel.org>, kasan-dev@googlegroups.com,
 linux-kernel@vger.kernel.org
In-Reply-To: <xfqnzil2oiidogd2drvjrzg4dymydywkge4zws2dildgqvcr2v@ns45a6frntpf>
References: <20251128111516.244497-1-jiayuan.chen@linux.dev>
 <xfqnzil2oiidogd2drvjrzg4dymydywkge4zws2dildgqvcr2v@ns45a6frntpf>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: gkq6h76an5hk3goz99rxjkwambt8hqh9
X-Rspam-User: 
X-Rspamd-Queue-Id: DCF4C140022
X-Rspamd-Server: rspam09
X-HE-Tag: 1764727519-736955
X-HE-Meta: U2FsdGVkX19XXl+S/Nt6QxWSxmQeKoPWXLU8csh2eZsptdeiuVWE2MV4YJ/lD7tix1d1zlXtkgFXOekw1uaZqvLZLkaggdEMtfjb2yn3U5DXvSDtGTlYgOuO44ie/szQ3X3Fwy00srv2FGw1+7jEURVE8wiTosWLRwXtSqzFzqAmlsGHtCpb5FA+hSbl1mOU257UyQ0GDoAqhxOzaOE3bZD9F37imi8kumRvFMfv/Ba2DbvihyiWlM2envgZIq+DjcWbPoErXTD6MMGq2b8vuY2MzhnyBkGicxyw7iCzCkYEV27RqBLHqhuiUUBlxuoI9jU2MskTzAzzaM+OffkWxvGdL572X9BBaEg1BhNN43fB2yJgdsRJrZPR1YoQADidIXkLiYrRFmIAdmmGtuUfm3oeydV2gYMKYT+bAHe3J6HfndCGcEKPQIO3sa7O69kah0kqcX0HjXlpeLbzqr4AH1TJEawqnEYAWVc37qaQEDo5Hz0vxUIbr7oM1koF/9bGeP+JIuSZWFGlwQG3SkoLFdAvNiaYJmd2k2TTdYAHt9k9y+zqwgWIa4DqekAcoMEpcImMsmLy/irce57NgjVFoo1All3Mkd4cGyw20rgT/Mjar6ewkX1obJg2SqaHgSjDyCppoWRSWX7IOQlvlv2OzzBly+dCwa+W0607XtFuXEwfreRUX2UZV1Xy5MtSd7Zda0iyRkOF68FeZRzGe0LzPc3Tte9RxN5u+tHozNwqkvjKwGTIyHURuCS+rvTTvhmfSebZQDp9tIoa8Log9lxCdbTn1o+UyySFwX15yWZ5fhSYT7OzL7rsaqmR73Wl2h0rDjz5thjDj/XEc+zO8m7dg6P/JnNVhzfY5Yp+2CHEph7jVw9C2TXvX2AB4V2ePFfzDqccZUFiZkMyrrVnh0kyUa1Ct3vfe1+v4HRNDOlp/OdpcMFMapnbgzHpbR5MVx8kFbwuAi6X+HtXysEUIso
 udVV7wJg
 EbYkiT8dG02Pqeod7PKXHdz5OLu11f6I1ZLw9Mm0qOr+2harMLLyAhQrXzN65FsGleFYa/rJ0fwVMBidPe+ig1aJru4rElWNV6HGMWqGmcAHrO1vEW2orMPn0PxE13J+NlB4wvRU9zn1gX16fI6cOvjq6nNI/oft4GOa5GP94EkX8EZhue0CVtRG1rtmXFU2EQhITW8Hx3b3X0iHEEPDzqnOXs9lavCZY07Fh46YRYCtO+jGXycsjxENNPgl0hO/Wo0xRbdIQ0bwPhD6TpyrZHBlkxwNdKVP/XRjehqr6sydXzYbmg7Cd+Rhzutmy6rPB7HjSwyunqHEFEj1l74SekDmJEpp21JzOROx9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

December 3, 2025 at 04:48, "Maciej Wieczor-Retman" <maciej.wieczor-retman=
@intel.com mailto:maciej.wieczor-retman@intel.com?to=3D%22Maciej%20Wieczo=
r-Retman%22%20%3Cmaciej.wieczor-retman%40intel.com%3E > wrote:


>=20
>=20Hi, I'm working on [1]. As Andrew pointed out to me the patches are q=
uite
> similar. I was wondering if you mind if the reuse_tag was an actual tag=
 value?
> Instead of just bool toggling the usage of kasan_random_tag()?
>=20
>=20I tested the problem I'm seeing, with your patch and the tags end up =
being reset.
> That's because the vms[area] pointers that I want to unpoison don't hav=
e a tag
> set, but generating a different random tag for each vms[] pointer crash=
es the
> kernel down the line. So __kasan_unpoison_vmalloc() needs to be called =
on each
> one but with the same tag.
>=20
>=20Arguably I noticed my series also just resets the tags right now, but=
 I'm
> working to correct it at the moment. I can send a fixed version tomorro=
w. Just
> wanted to ask if having __kasan_unpoison_vmalloc() set an actual predef=
ined tag
> is a problem from your point of view?
>=20
>=20[1] https://lore.kernel.org/all/cover.1764685296.git.m.wieczorretman@=
pm.me/
>=20


Hi=20Maciej,

It seems we're focusing on different issues, but feel free to reuse or mo=
dify the 'reuse_tag'.
It's intended to preserve the tag in one 'vma'.

I'd also be happy to help reproduce and test your changes to ensure the i=
ssue I encountered
isn't regressed once you send a patch based on mine.=20

Thanks.

