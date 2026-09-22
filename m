Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A703DC98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 15:54:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A64FA6B009D; Tue, 22 Sep 2026 11:53:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3CD26B009E; Tue, 22 Sep 2026 11:53:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 952A16B00A1; Tue, 22 Sep 2026 11:53:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 699366B009D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:53:59 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D35EF14053A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:53:58 +0000 (UTC)
X-FDA: 85241844156.13.AD92D47
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3F33220008
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:53:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="PBuaBZ L";
	spf=pass (imf13.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790092437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gxq5RbPZaBaThrnfCbXwlLeSspEvvoh3Fk+LKjVlj8M=;
	b=SHSS0iwa+dejbwdySOY5qHrF8BpVCjFZL83gQojsnEVYOov8ua2n+coZrR0QgEBLw9Drwu
	p7OmvBPMtyzQxcPHhNGmDbDMv8CCaPsr0lkNs0gyJwPsRH16WrGX3ptJRf3CxGzQBdj6C7
	QqSm5tEO7Raj5SaxpfDLcOVC3uGZ428=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790092437;
	b=a02z+SKm6UH7Q/sTs1+0dzSOjW63sn4s7OIRKwfwvxo8I//0VhU0Zc/jxzi6rpZiy9pEkq
	FpT7L9ZkfPElSRvTkrZtoKotLOoZ23NtdG+TpazjhMx5Y5o6n+HNK6chTFm6wO4G916Ekd
	jPoyU+tfSfE7AkUdtFOWzdOfCOKNJXc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="PBuaBZ L";
	spf=pass (imf13.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=Gxq5RbPZaBaThrnfCbXwlLeSspEvvoh3Fk+LKjVlj8M=; b=PBuaBZ
	LFtXvTTKu8ThDiaJWjea3KKn0i0u9LPgCfI6+TTUCEGLj8AlMSRP0gbyCAaDkq5lsmUORVTuBAkCx
	6Ik9Abux7GDtk3GKH1m8QZKE/rxAJSKEhlk7eW2hbYVkesYUwK2Ncb1MNy/9EyK+iN53bP6iGMkob
	xhonKo+LZnkT18EmkqYGLrgRELQ0Ub9SYS/S93KVNM/A0QsXkbftlwiDzDvw94CbzlWNF86DLs7wx
	bN6cyRrNI8HpTyCydoNrhTHahYRMsc5YJBRQmEEPYiaplAE/HpLGjZgld79w2uuCTf8lf0zgQurY8
	aPPV4sR1h+cF6UHG0fkmPmUOhMdQ==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1x92nZ-00000001pCW-3Y9V;
	Tue, 22 Sep 2026 15:52:49 +0000
Message-ID: <5a7ad159b2fabf377b7e1fc4248c433287ac11fb.camel@surriel.com>
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
Date: Tue, 22 Sep 2026 11:52:49 -0400
In-Reply-To: <CACePvbWW4avTV2WB6iRU+LN5zqkMTg3UhBrq41R0iw91-7Ni0g@mail.gmail.com>
References: <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F>
	 <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
	 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F>
	 <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
	 <e879ac65cb0940325736df7984c737edf1c6be94.camel@surriel.com>
	 <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com>
	 <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
	 <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
	 <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
	 <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
	 <arKbXe1Qe-FDCTMM@gourry-fedora-PF4VCD3F>
	 <CACePvbWW4avTV2WB6iRU+LN5zqkMTg3UhBrq41R0iw91-7Ni0g@mail.gmail.com>
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3F33220008
X-Stat-Signature: 7z6khewuczruiifwsjct6sum1ppzdhap
X-Rspam-User: 
X-HE-Tag: 1790092437-242310
X-HE-Meta: U2FsdGVkX1+XE1DuGkGDiKzw2tfZPBBw78/6m9t17SdTIqpDRLWRm0o1g1cxjEyp2E5yEJ2/WW3vbbVTdCGljb+ZJCKFwYBtpV+JDQASc+6yqlTpOsGUS8Phm5G+0nHGab1n50oy+4jWv2VfMBhNUitnVnYSQd5tL9jR731fWfYz2uWRKWZDIoKJEYFdjWaDYPBlH+f/eKZJMXjA9qlmPYrhRxBDovJLPSlvxm2Mb0yGIE+YO0Mw/MatiZMeQMnY+h5QVXOFlwPpAHIjZu21haiGz6xameKYuRj8HvLiu4rOxIp2Jy5PRPnxcnqaWtBxyRLQvnQIfMRRGG8Avc/fFBTyUEJYwItF2Iaq/FL5lR/Ni2RwNA5WZQEWAsZsYiikJ0XtSvBoKVeDlcPriUCiZdyYC/8+VYz4JoiBs+bhyNS9ZCieJ6FtI4BjD0QIZVqLZnXGdI6Z0mLHNWC9QEmbCm6FkHdrMMQ3Nz4I1H8mRYJsE3dfV0KQOWAmRByCb2ieGfeJFKpbUx+O3D3WhkaAM+oMpXzkPJJ98t3vKsrMHqRKpXglYXI+tbIl+A/OUkyIMwdeU2t3kqYYVdlb+SYJr1nAajDSLxK5clVXCKQGQitxxGos4mc4Shtp1efy3RCupE1IiP+OrNroJrlv+KTS3dNejkue5B0ZcZWYsbO5+WkYVI918gZfn0OzsHukuBLkOxj7Hce9Gi2EqjsWRExt9JiURqG+u7vv1+BcuNCA0nUOWwdeNnqFC6MppYE4meigeX6wjdvNM92xUpoN2rQgC0hc8Z8QCb/lD+S+hRB1hu8Ee/nX5b2/1v7R/4dp3xLBZQ5QRKXVgeBbJ2H7YpqUGPTAe5ZXZrlJCI0YENWhFRHl1jKbAHmJ+hZSllYBhYhNTjV+CUtCCIEM1GcE0AVel0LsCILrRs7n9JGKjlZbDZ5Uwd9XSobzhUuCo6fW6ei9zYKb4hpmaGg7z7rnMZO
 wU4QrzjL
 zccnPd5UL3NQIn/uNsscOQDHjX8/C+873viJC9GwuMvR4ru0vti/SeJM4TjYgGhg+1ZkRFyW6iOjNc5bbMD5i5mnhoejZY8WkDcEQM7z8X0BCJfyQXBts6WvHY9/4c5UF9QsF/H4Uwj9bpnSJRxIx/vrrXP3BcNN5qacPtxa3dLrLZZrlx02J3pA0OLZmw7RVjCecy7hDuSvF5vv48tvyQMEUHDu33SOQgnHyd2RriqNPJpeWxhrQ3m68Y1smjxHaR4PRzrwyLBg2wMNZLhaI3L0lLHjypk8M1INvkFeKo6RtgFrAgJMMbYLRxQu21CEdVLXuGBjyGOoEa4E9MdDdQsiIUR3oY0qH7JZOKx/D8+K2hrcv6ZCbE0mXI087Ql6VpeDPkIWUsoIdnsaViHMB1ZmwI1UIJhzqqiGVJwna5x5cW3nbIDApeuYAhJqGXFyjLkeP4E4f5fJ14KY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-09-22 at 05:43 -1000, Chris Li wrote:
> On Tue, Sep 22, 2026 at 5:20=E2=80=AFAM Gregory Price <gourry@gourry.net>
> wrote:
> >=20
> > On Tue, Sep 22, 2026 at 03:32:44AM -1000, Chris Li wrote:
> > > > Right now it has 64GB of memory.
> > >=20
> > > That is exactly my point. You are running 1/8 =3D 12.5% system ram.
> > >=20
> >=20
> > Chris you are missing the point
> >=20
> > Zswap:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 8812=
236 kB
> > Zswapped:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 24927876 kB
>=20
> I am well aware of the point. The 7%-10% data I provided is before
> compression. After compression, the real saving is about 1.5% - 2%.
>=20
Here I'm at 28% without any issues, with room for
more.

> You are not listening. The boundary was set due to feedback from the
> application SLO. Those are real deployments not imaginary usage.
> Please respect the user.
>=20
Different users need different things.

The kernel needs to be able to accommodate all of them.

The kernel default should accommodate the people who
are least capable of configuring their systems.

Hyperscalers can set their own defaults across their
fleets. They know how to adjust settings.

--=20
All Rights Reversed.

