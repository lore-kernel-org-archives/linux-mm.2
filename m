Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A22B0606A326
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=l2AqlyJL
Received: by kanga.kvack.org (Postfix)
	id A0E8C6B05B1; Tue, 10 Nov 2026 00:26:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E5F96B05B2; Tue, 10 Nov 2026 00:26:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FB566B05B3; Tue, 10 Nov 2026 00:26:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 63EAA6B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:26:18 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E15C9A8471
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:26:17 +0000 (UTC)
X-FDA: 85418073594.25.42EAE33
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf02.hostedemail.com (Postfix) with ESMTP id 466E880004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:26:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="l2Aqly J";
	spf=pass (imf02.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794288376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jn/JURTzNSN702gufOjyuihJkt0/ufyCIq9CJgAj7Ss=;
	b=E0ot6IWoHin/N5XAy5lVlcOeunF7+Pro6B7on4rCbV6T719Gt2sUsU40dOInl7HM82Xm+x
	Cji5cbcvC10ZRBk2iVufGpJrPW8Q0hZh+LMRTYq0756iHg2+scQmYqup3fRx6qWXxsPP/j
	I9w7Pn+st1+ZoPbi8HxXERHY1SR87pE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="l2Aqly J";
	spf=pass (imf02.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794288376;
	b=tY5QrViEDNpYF8Zqy0BrjPwVqqlpPAc1q0lvdjzdAlOcKccZ8GZXffqGa7fom5EnzaJ34g
	IwC2C9e9G5Tizdi1Yyff1hStzvNTGSw/b0I9MIqF9nbU3ci6/5gayiD9HURKrj6QC75r1s
	WBvb5wsnY9jFF+hbT8bZIVUAT1vOw6g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=Jn/JURTzNSN702gufOjyuihJkt0/ufyCIq9CJgAj7Ss=; b=l2Aqly
	JLF/ZWWhtNYgzeru75YDr+PlygIIgxmigulBaWiPo62y8dOR3x6vaJEpnBGUAWYDv8KcIsvOXv+S2
	WuPz8ck72BKhBDQVq7O20goXlRT4fz+lCRXIN3qVGWnMr80nFvs6NFboaaLC60IATEnGYyopDyhqh
	xdUfMvPaPPbFpA0glNLu+Sj4nHsr0R3BvNhblcmjv33h6HRlqudUaGAtPvKGAVMFepSPcLzp1Jid0
	jQWD8eyHI/cXTWxEPnayLl4+KxPXcGmEHs1XhaIMWRqea/hAaAbcLEpxp+bjSH/8oS+V1FBLkUGlI
	RFWDSe3x97aoO3AKeHM+D332ZWiA==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xQeMz-00000003Wu8-0jjJ;
	Tue, 10 Nov 2026 05:26:09 +0000
Message-ID: <7627c0d90188b581e7740bf8d17c8dd07b460f89.camel@surriel.com>
Subject: Re: [PATCH v3 5/6] mm: gup: introduce gup_unshared_pages()
From: Rik van Riel <riel@surriel.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>,  Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,  Michal
 Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand	 <david@kernel.org>, Yuan-Hao Hsu <aa9736195201@gmail.com>
Date: Tue, 10 Nov 2026 00:26:08 -0500
In-Reply-To: <20261109-refactor_gup_fast-v3-5-2aaef02df0e1@arm.com>
References: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
	 <20261109-refactor_gup_fast-v3-5-2aaef02df0e1@arm.com>
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
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: 7o9w4koqhod17t6cbnpoxcjwhdc6rfxh
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 466E880004
X-HE-Tag: 1794288376-272659
X-HE-Meta: U2FsdGVkX18CnxFd44jVtrm5Q+80P8OHUSAjf2CXn9S7v2zbLs99jSjXL7pyF+bROec2diXZGKnQj8YMaoDr4bEerMmYlPkHUDdwu7zxqdaDzXvwHBVFO+Kw7XAlnSLVoDSXl0BAN17sNp0UsLc14iabzSKIM21b9AieqwNDLXzDiLD/HklTZMxRsr73P3jJq0KaS4z2d9Bif/6TaUTou3UvDZhY4S5hgEHaivH5Jh0AJcSbGGxuUx+GqWpSQNUR1igrtNVB0XgcnqYbjcWeiFnHpa3/57z6N36BKw/rkrMfT91qKZh6GGg44tscAiCClJOv3bPH9EETKcM3pUofls+A/Y38uyify8/fALMZopKwkMEmYPM0BnYBAc2YGLU8y1gTB/yV0ie+QCwXNCarQGJI1wnOvqQAsMU0WTKupP8tCXs9Kv4DaCAcsjGwQBcTHOqWvdZYsF2cU/0qZPHILyMnY2IlydG0SHCNydm2XLuA2lOWu7iWXtBjuNfqoeq6Ru0F9jkbOtHvHwGdu3EaREwq+y4mVYhq+OGCOnYBpuGFcy2xjYuJf8DhBTb32cmwvBpqinSovfdvJlZyhXXa9HFf5ZuxLK7RiGnnbPDBxTMjA++xThamO3U5K3qSFzSbQJ2FBnU5qwp/Wai9TOZvrJrYgz7b5btqn/7KLyf0peb3cSOPhd9ptW0QKzaa2pDFdWE0vvMZ4TVmvZ86/rtvaA4kKhFI+VYmKb45c/DFypMnhR1G8hmBSdsWPgrH3cdRcVi+zLPvPerHgvdxTYLCJ2cV9y5KV/fp72cvYuIdTIXbW49PQzkaGRavyoY3xCpTkUvP3xDeqPq+RzphgVayQ/qAaY9VB3SBgS9CvvCEf+p9AtrbHSbLMguRLi/IPGkiKpTgc651uhPej/AC7POX4HicrCe6tlxS9yb23myGJMwlee/nepa4u2An31TcpCFYgLl0F8ikP+Enf5L3Jf1
 kkBXzj2y
 I733hIIZQd/Ug/hcBrk3gDl4TvEy3YToD2S1DCLs+4LRQVMkLK3xSgAO+EJLBSUgZ/9N6X5uwK4ajZnOW4ax8uy4IP52daYZKtA/U6XBDMpPN0gapYsCE2nUldUv/Qr2TXDz3j0flleBuQ28EZElMYer5RXTdtYLqnf5/S1dZRzOBTTJoUiLd4rGLFRzkoyEtqqzMPpuvntb5IAJESrNhiwAI1vFeTX3CGFZyv16Z+4gSBSf/2p7F9MI/0dz1FFOFgfRtWlyj7Eh3dP7XMG+SMvoxFrENRamR2d7zc1BphrUyrOTBhMLk05JrI/UF+9tFsdTNERyA2nZ9UCjllRiIUUCMLDB8pUTc9XWKOKxq+s2CQ6SrdJKH0S/pmC+PPXpdBxi06E1mPgAkKppKL+fSxe9DsRyl27l9LcTJCSywUx/lQTmPeJoUDRQs4ix8FQwSaeVnK+SWxcEoOxb+VrTiiaBt4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2026-11-09 at 12:32 +0000, Yeoreum Yun wrote:
> This is preparatory patch to make gup_fast_pte_range() batchable.
>=20
> Introduce gup_unshared_pages() to count consecutive pages within a
> folio
> that do not require unsharing, and use it to implement
> gup_must_unshare().
>=20
Could gup_exclusive_pages() be a better name?

The code all looks good, though.

> Also add a folio argument to gup_must_unshare() so callers can reuse
> an
> existing folio and avoid the compound_head() call implicit in
> PageAnon().

Does that count as a functional change? ;)

>=20
> There is no functional change.
>=20
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>

Reviewed-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

