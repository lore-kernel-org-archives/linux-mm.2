Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA362C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 16:04:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DE366B008A; Fri, 11 Sep 2026 12:04:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 988866B0092; Fri, 11 Sep 2026 12:04:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8769B6B0093; Fri, 11 Sep 2026 12:04:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 670F06B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:04:23 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0ABBAA45F9
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:04:23 +0000 (UTC)
X-FDA: 85201953606.06.A692331
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9CAB64000A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:04:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="WnlsB0 I";
	spf=pass (imf04.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789142661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rR1Bx7fi8xYmaqwM12Cl5cmpcBittw/5vU9eYvMxtCA=;
	b=eX5fWYziRINMratxSMKXwbZN2o37UyJ1/PaXdMOg5qKuHswTBXI03qDmklikcyhyEBQNPz
	xZ8kbZ05kfxMRneeBjpQ8SCclV/EhrTtnTjb7h8YfycgyzH4JHDvgrTpj2lTAaoRSWxVlw
	vLBgNP/6/3h5O3pH+335r2a1FwVK14g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="WnlsB0 I";
	spf=pass (imf04.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789142661;
	b=GmTJHjvLNslTiNzhv/GorftEN5XzxT2KHumnEVuAKft5UXpp6kknUCp3lXKbjNkkeVRZFZ
	NvzKQzbLkN2gysIRdHEc+UKrQ2Zykpt0XlW0yeyBVHOb1JvCmsXHl27Y/Zu4/J6sxfQ57h
	H/8Ojyz3TvrAOABgkEmuz8aOs6eeVyw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=rR1Bx7fi8xYmaqwM12Cl5cmpcBittw/5vU9eYvMxtCA=; b=WnlsB0
	IDbzhjdBLketBrAColocv1cck0fpkaLFQAjJHI4hr87M4LisybioWrfUTth+BFqJX/WWHTNcWtxbc
	7NLv6WxJdEVsCMSeBk0VASNfbMqjho2THp070kDqJHdh4JcULIUxaaYNuIdfbIUC5qRbMg3tFPsOq
	E8CIBgyOGHjHQBQNymfwJLmBQZGqSAiPMJc1KY4r6XRK7ZuBrmCm33kVrVIsfA6bsL33gyj5UaaQX
	OcaI4z+ZJMhm8ZDdS8vBvSduyu36pyDDNlK97xHiat8ONcbVxMrol2Nh19vhqVDWKt53yVgv7lZO2
	Tcf7YK7kPCeaFunp9YjXR6i2Khmg==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1x53j7-000000080lY-3ueh;
	Fri, 11 Sep 2026 16:03:45 +0000
Message-ID: <7c7b028ae93f0551e07e9e09468954e76ad072ee.camel@surriel.com>
Subject: Re: [PATCH RFC v4 0/12] mm: use per-VMA lock in __access_remote_vm
 for improved monitoring reliability
From: Rik van Riel <riel@surriel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton
	 <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com, 
 Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra
 <peterz@infradead.org>, Suren Baghdasaryan	 <surenb@google.com>, Lorenzo
 Stoakes <ljs@kernel.org>, Vlastimil Babka	 <vbabka@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Mike Rapoport	 <rppt@kernel.org>, Michal
 Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>,  John Hubbard
 <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Matthew Wilcox
 <willy@infradead.org>,  Usama Arif <usamaarif642@gmail.com>
Date: Fri, 11 Sep 2026 12:03:45 -0400
In-Reply-To: <9e902c8e-c825-45ee-89a1-85923453e43d@kernel.org>
References: <20260724222934.1463812-1-riel@surriel.com>
	 <9e902c8e-c825-45ee-89a1-85923453e43d@kernel.org>
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
X-Stat-Signature: 7djnrxjiibzp74jgnfu5obkt77gsugh3
X-Rspamd-Queue-Id: 9CAB64000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1789142659-785075
X-HE-Meta: U2FsdGVkX1/oUGBPMm4fZA+r5FcASLn3+ldc8JXpIuVhbB9ivAsFjfeizj3Wasp19+VuNArkL3U4/7/SO6UZlX/mShkw5hWeFI/FO4AQMcKU3mjMVwDjAtKqOcFZQMf0H6zsPFz50x4VU6e2DFCizg3lSBOTS2pdfUxs9HcdKe7cxFhdJ60nlQYwu35Jv1YT1l+SuLgEMFmkYhxLtNjOpq9C2t0AJWFG8xlcTmBrTrdCB44VuZbG72uceUcxzvmHiwu3LB2s2YP9B0ojez9svY5Za5zW38dU+O0EtoA6t6m7PTjkNaKNETkFv08gP9TCNJEP8ynl/EfwQV+zANJ5DmoYFeTOXeBktQqvgV1F17pM/wq3RMDuihlr04ElPNA+0lK/QeL/b+CDxfzheFMVa7gU0O0tDgk9CuSgVddfW3H2AoRFlzsHtiWpOOmzEhNwqlKRdD54nWBZykDThrJs9VzUPeTLug8f6vENYLg+Ene2yXaS9QEHnQrfrgQfD6FnIzpFnjyv9alC5VEJfmGG0RB2utgKjJWEI9ppAzOwkb9dFbX5AAW9oE9fKWct7zwpDC24f1w+xU5OksPNE9dvkLkTjOTBBbi2nRG9Y65gl88yDhBlo50uywPklOkUXckAsltPeto9/ymT9WQu1ftiQ5zi4KyhfMbiAkBEzjk7JdvnVzs/UxWGF5aOCZzlfT5sLtX4aElRiLq7d8Nudos74m/d2446Iaa3Fsfz7EsEB6Zrok3OdYXO8cn/foLMhODasAq4KiTDZXbzIqvvK+8ALgO5uTEOquDUcwl+sF4Mv0M5eImLqjV2FPGIJJKEAGHVywN0FPjiuEBqCWcl7UDvHSQnpYYOUp4k044vH2inIZ0AP8vLiDwQC3AeGk1c4/lsUtoNQ977bwMnS4l3pb20napYF8LiA0KxCYnF6JFTT0FKBJwyB2iDHgdoyePzTjTSog+C/yILIUHvZaJoB/V
 NiU+4c3C
 X1KJ5cW8zS21KCv15izsFYzojfMkh5Sk/t9iu1oBm3HFwymej/KcwcmYtrF/LyFXabTdlQmuDl/wmCfDH6u1ZKJymwBO1un1ED+hJ6zgDaX6p8u7tc/H7yx/1EOy72BBuX2RDC/tZ5P+jqIGyM0J2kYwobN08vsyePtGqUBws2nwsOxSviPiDNAsSc5Llkywn2Yflao+8Kj4K4piGoWzJ9vgvSMSlg+43/JFqjATEAby03FyLopk7MxfIJlVxZCvFBDHccH8EhJyHvQIxvQ6EHXmNDChKWuvSQVkw7OmqH5RBu4m3b6KQccSVt98h03d66puVaj6bfiK/BzM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2026-09-11 at 17:11 +0200, David Hildenbrand (Arm) wrote:
> On 7/25/26 00:29, Rik van Riel wrote:
> > __access_remote_vm() holds mmap_read_lock() for the whole transfer.
> > On
> > large machines, with large multi-threaded applications, the
> > mmap_lock
> > is often contended, leading to things like reads of
> > /proc/PID/cmdline
> > stalling.
> >=20
> > This results in system monitoring tools getting stuck, right when
> > system information would be the most helpful.
>=20
> Rik, what's the status of this, and which series do you consider more
> relevant:
> the pure per-VMA lock change or the pure page-table walking + folio
> batching?
>=20
> I'd assume the page-table walking would result in more speedup and
> the per-VMA
> in mostly less contention. So likely we'd want the page-table walking
> optimization first.

We can merge them in either order.=C2=A0

This series gives a speedup as well, by removing=C2=A0
the double VMA lookup.

If you want to merge the page table walking and
folio batching change first, I can easily rebase
this per-VMA lock series on top of that.

Do you have additional feedback on changes you
want me to make to get the page table walking
and folio batching thing in a merge-ready shape?

--=20
All Rights Reversed.

