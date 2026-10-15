Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F96CCC6B2D
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 01:50:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DFF96B0088; Wed, 14 Oct 2026 21:50:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B85A6B008A; Wed, 14 Oct 2026 21:50:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CEE56B008C; Wed, 14 Oct 2026 21:50:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA2346B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 21:50:12 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3B38D140849
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 01:50:12 +0000 (UTC)
X-FDA: 85323180264.22.EBE5536
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf02.hostedemail.com (Postfix) with ESMTP id 684E880009
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 01:50:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="apXUJ1 q";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf02.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792029010;
	b=iTBCA4yuFw5/4ncJAjOYqdk2JYtYzx7APAFaO85/GjLu/MhoaX2WQQICMdjTga8/1OEGMc
	F6iy0BRrgNCL3qr4wkJ5SMpEkriOVBY3FF1V8+GvnBXRtYYb4aShyJF+U0T8oZhpJnkkCR
	8j1dPDRXOSpYNldhLP4n08F6Yo8ueT4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="apXUJ1 q";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf02.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792029010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1tTxZ5kOWU06Y0H6PgnC/UOcxg4zC3bPkYQIp8UlU78=;
	b=SfkfbwWZ3M5o89iQsanmLGPab20bc2WZWnyA7LzI01KwCQ0EFi4xtZl8ocqZ5MQq9c1oaD
	YwMsXASu041NfZQn1SVZ0NzijU9TNkCbFxWWM/C2kzbLrW7LNwd9NSEf8ZWuxA+TmJq/+h
	KCN7ly8edW+/QyLNCtNWJawshkKWcNM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=1tTxZ5kOWU06Y0H6PgnC/UOcxg4zC3bPkYQIp8UlU78=; b=apXUJ1
	qvxEejs0phcpBdCH+HRMDFBZ8US2Z+7dEGv/dISiydav3dlIN04lyA6W5kiZ4tJNUaAjl1VuNh53C
	UaAtu4PizEVYeEhjeus2F3WzEdfbp5KMB0F1htj44qHhEG1VwTISecaC+kv1z5eVgeAsOfHUTcfIi
	KZMbFaY+g1ilbmO6fdik44/6sYd8yAiHBeHY94KmdOFF+z8dK3eQozD/ycM+Y8MaRM7ze0sOExw59
	BtOn5wdJkpp1k6IcoDW2QybD0SHYcRS1qtSDu+EH59FCOcc38PTPaOHlTB/242pg+EtbaHV9TDe+K
	5s5GobLjPbxI7Zfw6M4RGLrHHuJw==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xHAbI-00000007uZB-33oH;
	Thu, 15 Oct 2026 01:49:44 +0000
Message-ID: <bbeb70884055b85f99f93795deb5d6af8f64cd64.camel@surriel.com>
Subject: Re: [RFC PATCH v3 7/8] mm/gup: walk multiple PTEs per
 follow_page_pte() call
From: Rik van Riel <riel@surriel.com>
To: Yuan-Hao Hsu <aa9736195201@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, Andrew Morton	
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Jason
 Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu
 <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>,
 linux-mm@kvack.org
Date: Wed, 14 Oct 2026 21:49:41 -0400
In-Reply-To: <20261014215451.515-1-aa9736195201@gmail.com>
References: <20260811025157.1632867-1-riel@surriel.com>
	 <20260811025157.1632867-8-riel@surriel.com>
	 <20261014215451.515-1-aa9736195201@gmail.com>
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
X-Stat-Signature: zid4td776qc5mf6ttjo5ye6ywjw1fyi4
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 684E880009
X-HE-Tag: 1792029009-277084
X-HE-Meta: U2FsdGVkX1/ZR3yf73DO6u/5v3R6v2+ypba2tXSX6APWT7P4gPLDU1LtV8POXUgtacBxz2tdEhA1LlZXpHX6oOxEHyJCt5V0mw21OGiwB2KXMg6xES+VUUTFqbJhw5ATaa8QKLWk7ehn6Crq8x80M0BLZP7wMd1INzNnET3gga9TEgbri+BmuWLbcbqsuyWwIl7KPgO9sIO/dvbtsUwJlHTG31PT1Ek+2cH6PVZ7drhKX/Ep2cfLGUgYwb425Eu1z6SJdhYuSmfJUJ8sWCo/xnQGplk3n9usHmSZlksbpBa1LpsnAomixuRx1T9yT1u74co2uszz97D5WD4kAj3/I82tpCGSg8Ey5ru4FMhTS+vgvetkrlzRQn7Zztt4rssQY0Nk997eFNfSLRafQhZsEZuYcif5UechlJLu9PLO/eyYee2Y5iEaFYV8MH0fo4P/j6a7a7aHde04Z5DNI6IW+DGjvo2QsNsonH3m9Fx86lBkmBwgL5XuD8nqx+vfkstEg1CFVHt5LiQyCCy0C6wmmXj4p0peF6dZmGH468pZDYu9Va33ScP9CynIwi1qC+4GEyLNokWHWEn8VLa7p9uG9EEsoCdVXZd7ahkWJxcQ/jKOLV40efNLxILs9ZlHHS7UfoIyNQ2DYaQShSSC4Wm42L8T5Nzjzuv7aKh0pDdLG/LA2AXDwJbvgWsdaO47AT8ITC/kYo1bI8W4dPeYrzmlRPYwUwVbHNXqZXFoqNxgKYX09OEkmT62Q+WUwzm746bD6KCkJRs+PCDCmhlp/g7CFsAA4LeFnZbkfyazZt0DVNrz7EWvFhkxWnrOxJTa5YT9VRllg8lz3grp4gJfQxQSPzgwRM63oHA0fintmcMkVkyv2IzG0dD3xiMBD6GtsXrlLU+Nyb87PBBApyxcz797KSMp4Z/d4+upzvjljrL7kzZAy34yx2sGax7v4HNg/ZFzy/goHPWetX4wPWCdw9M
 /cW5rv9N
 XgYKagJFX39eZ5N+JMpB7QBjWhKuVwh6BeJpIF+fjwolQMSmw0r6ajZVxZ/Dxsh4GAuKsQKLIgwNDXrC48cL1ftMv6891wTU1oFYN5BmRa0XyVnOdE3cywgUfMpJfCdE+qAp/7AztIqC219bDuve5H5GYRZVPsGit73OUOwuV/wZcAxQFWUfuLdM0GCY7OHgRZ11vePBD75RXpECSQ++RYAaIxfRVFMIYxagIeO6aChO7BaIJ8oEThISNFBEYpy+Ab+B8pzkgutNM5sDXCCe6dOnIyZL6buEYhXlcdQoK8LbiSDwe2u+doCrJ7SuDlFQqmFum+rN/oCQdga4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-10-15 at 05:54 +0800, Yuan-Hao Hsu wrote:
>=20
> You already mentioned on 3/8 moving the gup_fill_pages() call out of
> the lock so the PUD path can share the helper; this makes it more
> than a cleanup.=C2=A0 Storing pages[] under the lock is cheap; could the
> flushes move after pte_unmap_unlock() and run over pages[0..nr), the
> way follow_pmd_mask() and follow_pud_mask() do it after 5/8 and the
> way __get_user_pages() did it before the series?=C2=A0 With pages =3D=3D =
NULL
> there is nothing to flush either way.
>=20
Good point. I'll move the cache flushing to a separate
function for v4.

Thank you for pointing out this issue.

--=20
All Rights Reversed.

