Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6E71606A337
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 04:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=jYOloyN7
Received: by kanga.kvack.org (Postfix)
	id C19626B05B5; Mon,  9 Nov 2026 23:51:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEAD86B05B6; Mon,  9 Nov 2026 23:51:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B00836B05B7; Mon,  9 Nov 2026 23:51:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8AAF96B05B5
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 23:51:36 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F30A0A8446
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:51:35 +0000 (UTC)
X-FDA: 85417986150.15.6BA6287
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2A2E0A0007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:51:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="jYOloy N";
	spf=pass (imf25.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794286294;
	b=z55zqGqvVmIRBBCw4a39I/1cbOkgijdiT2QWbdWOabjgux2m+FLX/05i+U8kTTo+uYfwQ2
	hgtmNM1/qd0XcXQ+LUurkQTDQ3ep7nhxbrqYyt/KeFd1Wr5Z8fEun35z4lEIdfAHYJA/h/
	OnMRh8eYbf07dwTSaCwe7XL/a79VKSo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="jYOloy N";
	spf=pass (imf25.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794286294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hlu7ksmyy0VtKWdZrpCJUVhsfYHu/YIZGfPiir2Huy0=;
	b=o19Jd/4QwOeSRTNIQIyqnjUoheAJuP0WeOAbopJxJ5SI61AsGmx9sCufI4kHiQhnjxYL8R
	mF9nN1nxw/pnIp6nUiG9y7QZNYVVRpvgmH5BkRWJyX1HzmOP4kD0xPk8WR0844aOk8lIOF
	+T7lqF7sIf0n4bbexUQHIUk9KfAdfN0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=hlu7ksmyy0VtKWdZrpCJUVhsfYHu/YIZGfPiir2Huy0=; b=jYOloy
	N7KuatV8i812SECW8R4UW20pDecNNOLe+DBjhjLOUn3y4Hiek9jqPludBaZR8X7Xn3sZDz3T/ziHW
	+JDVham+hHtTlxnVBiwXmTu521aMtNTIpFMdE7/3lfOBnPqlLxHtIeUYrv3/wo86Mg12G++BR7Zgr
	MZf4l5NQJ9RiSIiTNqjd83WH9dS16U+wcywgtp9+g4fI76Fl1fe0DS+ZMy6AtsdXqCwYJarCmtnAH
	OJhcB0P2Z3lKA6QNCWEJF9SKN4UWwCC9mD7Td0tCJ1J5WGBEk6KNl3oB2/CJJ0Uv0AYdsYRCqpJOn
	C2WZxCRdxOCiF8nDN25SIY4awn4Q==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xQdpQ-00000003WXP-1TA3;
	Tue, 10 Nov 2026 04:51:28 +0000
Message-ID: <163854fc5a1b794a807c3f5eb5b2955f1a4a9991.camel@surriel.com>
Subject: Re: [PATCH v3 4/6] mm: internal: introduce FPB_LOCKLESS for
 folio_pte_batch_flags()
From: Rik van Riel <riel@surriel.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>,  Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,  Michal
 Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand	 <david@kernel.org>, Yuan-Hao Hsu <aa9736195201@gmail.com>
Date: Mon, 09 Nov 2026 23:51:28 -0500
In-Reply-To: <20261109-refactor_gup_fast-v3-4-2aaef02df0e1@arm.com>
References: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
	 <20261109-refactor_gup_fast-v3-4-2aaef02df0e1@arm.com>
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
X-Stat-Signature: g5k4dhw6zjfcseis4xd4j8mxmpruyab1
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2A2E0A0007
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794286293-229890
X-HE-Meta: U2FsdGVkX1+r+G6XN5j+wI8cRLL2/1J2/xMiQB6GLJP8KaFyjQCnsng8A8FWu5wi7XE1KQe1CNGd3vDG5Ycuq7M5/29hTL7A0MF5zk1NZ13V79o+Y/Y+XH9AmZbR7kr2P+9x6h+b3vw55IAoCIEPeSZLtgieSUO6KpWtZScLjq5CapKkXDPKTb+0h1QAwMlnzLQjDgdG1y9r1TksaSZkHwY2uLHUmnjPPOT1ykb+1A/EcyXgOKa5/0pJogtnlnDm5r+aPtMGvTpEFshWZpfa7heqVvW92RRKv3iGKDGK+8gu0xKOARs2V+PHWJwtHkmikF0+vtY6pih/kOYnDG18E9JfRagzt1pH4JjlnKetYklly3YQ2KjVUG1CnDGDUmWPGM0BtHGt2vsI3kMPe26TqbTzQquodenNuz/hWx4+upXVGsrb1Wj8Hi4uCbBkUouWnkmToLZQTmgQpE7rm1Uu+/J85sThs/O6n1/B08pfSQEsIno6enxbhIm3pGiTm2ogF+4i1lRc/mIG/g4JLfJFwskRNq2uA0ME+SZZ1nGBwl6XTmFLm4TYMYfj45VKbhkNRFpcsbB7HHOyP1ZgB+ab8I9MGteoxxERz9tLBBbC35X11ShGa3ro35O5L2zLzeQQFOKOY+4IVNOMBQ9ZRDIJGk4MK4HeCOmcZ7mirhQUQFIAZoxpApgKmR0LLhcpxkKD7zaq6t/TQ4KjiiR1Pohl9+gP+9NPUtoXgN3S0OAd09T9DSVruq2Ovp98AlP0zkAEQgfIKqKDUHc7PHlXMckH/rwCIY8YXKFG0X6AuE5npU3TQLQUw2VAIi+2bo8nn6PR3DDY+OhkAH+LtPyHCLESacNKSMw8rurrDW96HPbK0WUplUpW3jVnYCTU2f74N6FHBbc8/gosBR+em05Wt6l0Oj1D0AFg2qEADy2QpqnE7Q4E3ee55SQ69e1wt923IT0dzrjq/MCSJJ86WVobnYk
 GhFIi9sJ
 i2llRAHl4RjS3eeGTOUGhNVg40h2uBAt11w4BeITEm+1q/Fh4MTJMkBYslaoteE0Mk82cuIFxV/gbbUbucDUaY71MvEvxfL3XIIFr9etJviAVsCh/Mo95ve3NkvY8LsO9/UtHsBkCSEagc3J+UHVdbK+q5z1G/cKVxRwwBqxo0nXWdckCSR+gGoTOahgNcaheDWoM03qlTK+UdWiwcfPUKss741tENjQ2hfm83qhzc4rAoye3oAMQ0BoFYvXbge5kof2jKgwp5TaePoU6+swAc/4QAIKiNaGAxY1EilwaH3leGdafJ+ypjLFQVyYG/r3EJrUcoMMG8nY1ldPRgPHijJuMD99BJIFPc1X4jJ59WIKKM4WtNfFafKewB56e+l8sYQ1iilGauUxJDahgyosP1xPOlZ+f2yjRwM5GqJkhZ+n8HyV0si0d9uGCXFs3EwfxStJJeJMLEjerR29p4lQ9N50Y6GDTBjHMx3BC9x5AoZ8XLOI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2026-11-09 at 12:32 +0000, Yeoreum Yun wrote:
> From: Yuan-Hao Hsu <aa9736195201@gmail.com>
>=20
> Add support for calling folio_pte_batch_flags() in GUP-fast context
> when we are
> not holding the PT lock. Instead of reading PTEs through ptep_get(),
> we have to
> use ptep_get_lockless().
>=20
> Specify the new behavior through a new flag FPB_LOCKLESS. We'll make
> use of this
> functionality for batching PTEs in gup_fast_pte_range() next.
>=20
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Yuan-Hao Hsu <aa9736195201@gmail.com>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>


Reviewed-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

