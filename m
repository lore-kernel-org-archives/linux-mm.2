Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCEBAC982CC
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 01:15:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FB816B008C; Sat, 19 Sep 2026 21:15:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D34C6B0092; Sat, 19 Sep 2026 21:15:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EC146B0093; Sat, 19 Sep 2026 21:15:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3ECF56B008C
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 21:15:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A7E874034F
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 01:15:26 +0000 (UTC)
X-FDA: 85232372652.12.281BB48
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf22.hostedemail.com (Postfix) with ESMTP id 180D0C0005
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 01:15:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="ZeeUys 3";
	spf=pass (imf22.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789866925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HTuSBU8KK3K7/N83f4aPJRBXiU0OTjT5r5WttsKnUKk=;
	b=DZyfVQKKp4sySP7fI8GwPcg87kkAAO2yewDLznP4USnsTJhWMWtj9M+f3456lhK6U0n2jw
	j1PIum/pFdPFzbvl6CmntDJNRzb1e7nnPIc6imyfo9DzLDdZgbaSo9KtqqwDJ8ao6gRrIG
	JLP9b2OqLA6pKzUrvySUtEsOrXJMnic=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="ZeeUys 3";
	spf=pass (imf22.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789866925;
	b=0WJzIRDM0bYzkzxT7khqhk8M3esiV26NtUZVAutp7uoTTkLMWRRmswzrdxx2OroSfP5DvP
	XQOLxU++mjII7XHkvTyUgQpVkNNEq+N6KfgN7Dzdd6+U9E+mE1y+cjOcQPaK5UmsKcdDaz
	vL1KX/GkJsslbq/+4bGOVCDygmRGO/Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=HTuSBU8KK3K7/N83f4aPJRBXiU0OTjT5r5WttsKnUKk=; b=ZeeUys
	33i+AIcqdU1FJxq8rMKnhaX3Y8Bo7yAhndQ65XRY1f4CRE7xJXO+0W9BgMYZeuf4+1KFpzCuzPY6o
	XUQTD3gCKBDlHrJ/dd5QFNOiEU13Us14W0MN765tdamM4e5rcwVExXurLUIlN138oGbZLfBaTRjm9
	bsv1vlPpMaYSPCbgoXsaYJiHJif2Ss2i+UjxGGxxlVUMKxf1YfMH/polRdcKPkckYQQJ3TDVCdZre
	4yvgYwf0cPp5hpD4Mwbf62YZeKH28w/R4CkFoelojGoiSl/4DNs3p7nfpjF8L7sETieMCE6Wndb7u
	wh4PcgzlBOOaOLZIruOLyvOc931A==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1x868U-0000000CQPL-0vV5;
	Sun, 20 Sep 2026 01:14:30 +0000
Message-ID: <6dd762e3775de977cbf09b73cd2f9d375f04d6b3.camel@surriel.com>
Subject: Re: Path forward for Virtualized Swap?
From: Rik van Riel <riel@surriel.com>
To: Chris Li <chrisl@kernel.org>, Gregory Price <gourry@gourry.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Baoquan He <baoquan.he@linux.dev>,
  Nhat Pham <nphamcs@gmail.com>, Kairui Song <kasong@tencent.com>, Michal
 Hocko <mhocko@kernel.org>,  Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
 David Hildenbrand	 <david@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Kemeng Shi	 <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>,
 YoungJun Park	 <youngjun.park@lge.com>, Chengming Zhou
 <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)"	 <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)"
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 =?UTF-8?Q?Baghdasaryan=EF=BF=BC?=	 <surenb@google.com>, Qi Zheng
 <qi.zheng@linux.dev>, Axel Rasmussen	 <axelrasmussen@google.com>, Yuanchu
 Xie <yuanchu@google.com>, Wei Xu	 <weixugc@google.com>, Wenchao Hao
 <haowenchao22@gmail.com>, Jonathan Corbet	 <corbet@lwn.net>, Hugh Dickins
 <hughd@google.com>, Baolin Wang	 <baolin.wang@linux.alibaba.com>, Tejun Heo
 <tj@kernel.org>, Michal =?ISO-8859-1?Q?Koutn=FD?=	 <mkoutny@suse.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan	 <kunwu.chan@linux.dev>,
 Meta kernel team <kernel-team@meta.com>, Linux Memory Management List	
 <linux-mm@kvack.org>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, 	linux-doc@vger.kernel.org, "open
 list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <ryncsn@gmail.com>,  Joshua Hahn <joshua.hahnjy@gmail.com>
Date: Sat, 19 Sep 2026 21:14:30 -0400
In-Reply-To: <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
References: 
	<CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
	 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org>
	 <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
	 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F>
	 <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
MIME-Version: 1.0
X-Rspam-User: 
X-Stat-Signature: fh7psqa6zzuw117tn34ybmcwk5ahthre
X-Rspamd-Queue-Id: 180D0C0005
X-Rspamd-Server: rspam07
X-HE-Tag: 1789866924-796699
X-HE-Meta: U2FsdGVkX1/UpSC6V1bAllMH3Unnk2IrOSSK0s4m87xeuREKtTKrkJQimH1KlZa+HY+ermS8vopeOIWkrYW3g+ceYSDG7SrzhUu48FWiqZFn4kc2aKF8emXJdmdkDLWz88/746zOl5QSC3O4hZ8ipA/SPKcCGAX2pxNCHsN05+uvjRTQAefjj4QmMIvHjT1BKHHkG6M1ecYY/pSXZ2WLYBPTCjntZ5L0Idi8kB7MbR3ocMS9CV+Ju7q8OGkSLSEIHSqMd7YdraIt7r96ukdc2/KYFg0U5YI28R2g36xR5WJYodGf98Vns/XXlbAYoCwKHb4yP3pm3VTQ+vlVjI+pzkjvoIZGl8UcBt+n0SM76PpcyNBGUgF2tmXipBF01IINbzQ6cmdiSk2qpUaMsnteWGrqA4BnTnr8YJBeSMRggwQ1d/rMeRw9zxuTLBhoFnWz/eu7VJLNPQk2LFuTTWDoo56EA7cnxd2WLunLgRjNSDpVd6ebiydOHU3Ozdkde4s7on9/plCnUi8nafJ5f4h2BR/ZeMz0uM4calTxiheRfft7Xoh781TRti/m7sx3sE3ICw9mf6jF0GtObUuz4AKIYEEROp/1/Ls2M+mQFm7ZvqLMZ8hvDZR8zT99kREsM2T9I9bOlXDmdNEPxMTPoty3XVe7E1FkDDPAqVTLml0LPP8MiRoPh8efET9O88j9c+hzmz5+wquZs2I7zMwcR0+8XOpK9Wz2pc5AoFv34+VASW9zQXgC455sRkGL0xBmEWO8WyDvL34FSPND+iGkwKud/YtmmMtovG9tP5xQml3EFxaBbuxTxwKa7KZicawx4tOdRgbyRFZftudQMFfb/6b4c17GnIltiOkDGU1MkSb2P00Ev3R/i5enUkqJNyJ9wg+nBONUo5O1qqEEDkYSR/z+ZBtSDWc9JI14Mc9ZAf5u7kArYbDzxhBnEtQhWhW1ebChm25h9fIXaDg2js9qtPD
 IqTB/jut
 Fc7RkTPyekGkTo4lKMcfcyTEj8tTqjaTRSAyKgUQX/FPBRZSdoK7mpnpg+++hjRfLb+vSWsaw+bclzQ040y1Bmr6jhOBuY2o2Z2SSmU86Ltw/7Ng1feWuQQ0yS6opV3oxXtfmeFB+rM9EW3U3MY4kOwMukVehi1JXqujyPv3tsj6ZSfiqmWU3cQ8izvvas9yH3EbMEk+At2Wf5wbBAPut97slasMs2qDyCPSmziDycBQB41Z7zh03kZJBN2t/BNEl7D4U2+udNwALs6yReZz4/gDihwjB+cnOjk4vAiOgIbkxPWqfAbULWIaKTPfQdKG8kgifsV+qRq7fPE89fFB6seI22F00tEQdVewX+ghmu3cEEO6UzLFfxqIsdtjs6K1XMDP6J/ff7G2+5RWqkbkAAWwXZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 2026-09-19 at 09:02 -1000, Chris Li wrote:
>=20
> Secondly, I notice that you are reasoning from the memory usage
> aspect. That is a different usage requirement angle than the SLO
> violations. Maybe we need a separate counter to track actual memory
> usage, regardless of compression status.
>=20
That's what the cgroup memory.current does.

It adds up anonymous, file, accounted slab, and
(after compression) zswap memory use for a cgroup,
and can be limited with all the usual cgroup
limits.

--=20
All Rights Reversed.

