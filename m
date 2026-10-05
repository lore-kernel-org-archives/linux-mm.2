Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 755D8CA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 15:16:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6124B6B0088; Mon,  5 Oct 2026 11:16:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59BCC6B008C; Mon,  5 Oct 2026 11:16:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 463296B0092; Mon,  5 Oct 2026 11:16:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1AFCF6B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 11:16:10 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9E3BC140312
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 15:16:09 +0000 (UTC)
X-FDA: 85288923258.28.450E89B
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf21.hostedemail.com (Postfix) with ESMTP id 015AB1C0012
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 15:16:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="Rwv/1D Y";
	spf=pass (imf21.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791213368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uWQLeNOxsComWCIOqGdY0uS9YTS69A3nhBq06GXeH+E=;
	b=6+lfsAueunT7lb/Op9TYdmSQEWDdNaS8cVlooFawIj4hgtfyMQsWjqHziaoHQQKomNQxh2
	s+uqz/eMFk5NFheWqE7GhYnE3xPjvO5qzi7v5mCg4Am662BSZUBo/GTLDD0g8vqhx/UNeR
	ZgQZv1tYF5o7fFfQbL4bSYKX6ER+Ook=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="Rwv/1D Y";
	spf=pass (imf21.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791213368;
	b=31YCBJj5XnsUQp32KFjud1qeyfC84I2155XGgWja+KGgW2KoKVkFgHhPG8frg21fqTE0Iv
	VG7uqborIaZfW9DbJqYzlU9iWvR+oCQWn/PjRaPLSKfGLAEWQ/O6MexLRdhPztDIV/ibea
	R06eyD+aOVLqxvT7ZFHDfixw4NtwxsA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=uWQLeNOxsComWCIOqGdY0uS9YTS69A3nhBq06GXeH+E=; b=Rwv/1D
	YqKojMzxXW7ifrzuve7WNNLOz8yEFDnFY28bdQt5PWOR5qJVU4aisH7HmK3u+OvWd85CauHKjaqmC
	0xTO1p/FQyfpXpReEJAbbKMwuixRr2FWrk/SkPcLdfY4Vzd2sprhB7ie4zm1H8jW3N8XFeNhBU4eQ
	U0Ob1AqZ7r7xDdYF7iHr+RN3CPnScOd+e43XOxebhoCrZLdqbqz8w2fGPJRPIur6sidp73N4upKOj
	+WFv99sRd4SooCprqq2NGRFV+d1nPTXZbaZIYBQiTxQcz5Y2wH9ik4cwUrkDHg2TWer7OFMihS0WQ
	rWbrIUZZYruaGAQIPqpUH0/JQgYw==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xDkPN-00000006JzU-1Y0n;
	Mon, 05 Oct 2026 15:15:17 +0000
Message-ID: <4686fbed54796cbd32b5d524938d9cde184ca501.camel@surriel.com>
Subject: Re: [PATCH 1/1] x86/mm: fix incomplete page-table invalidation with
 TCE
From: Rik van Riel <riel@surriel.com>
To: Lance Yang <lance.yang@linux.dev>, dave.hansen@linux.intel.com
Cc: luto@kernel.org, peterz@infradead.org, tglx@kernel.org,
 mingo@redhat.com, 	bp@alien8.de, x86@kernel.org, hpa@zytor.com,
 linux-kernel@vger.kernel.org, 	qi.zheng@linux.dev, nadav.amit@gmail.com,
 thomas.lendacky@amd.com, 	kernel-team@meta.com, linux-mm@kvack.org,
 akpm@linux-foundation.org, 	brendan.jackman@linux.dev, jannh@google.com,
 mhklinux@outlook.com, 	andrew.cooper3@citrix.com, Manali.Shukla@amd.com,
 mingo@kernel.org, 	stable@vger.kernel.org, toshi.kani@hpe.com,
 david@kernel.org, 	mikhail.v.gavrilov@gmail.com, pfalcato@suse.de
Date: Mon, 05 Oct 2026 11:15:17 -0400
In-Reply-To: <20261005052302.43042-1-lance.yang@linux.dev>
References: <20261005052302.43042-1-lance.yang@linux.dev>
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
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 015AB1C0012
X-Stat-Signature: fsi3hy9iqrwbyece1a7ee8tqyd65n1pd
X-HE-Tag: 1791213367-658609
X-HE-Meta: U2FsdGVkX1/zyJn0cXn6JkV17vvTQ5TpWK13UXz8bVsiCoftYsNOD23Mgzgxu/Om+tbtKUWBfSQt7OxOgAhJF1+5b8VfOCxSp06+fFXWfqhQp4JJLZBBU5lJBAqP7TxsNs4LPRfZ5ETmeGteXH6PmxxAFChpzxCcGpFFMRY+J9Tn7HGVp2ghqfhY6VsnSuS2iBM5i8BrggTZpFjC16aOWlZHyhqBQXiThEOkwNzBidgudOR/ylxoptHTZ+RhdH+6b8KEeWhH37FYbKn4ytpXFdObPp9O89faKfR4Se8kp8RTkY/nUuqtnZq4BFHtBcTf+N6mxb5+H/On5bgDsEAFNCxKrulsAokiUV25Qnl4QxILSL+Q4pt6l1eUMlXXiKXGS7g8MRfgJ4U+oEvhjqvsScav0uR5ivR0Ve+xcsVCDwiMJ5rQyoFYw5aNp902bBWp/K3uhkFFJ2aL0xe1UruLRSqVwZoJjL3nQhT/J2eAg+AF3nS7imphRptSKWQOUKRKZ+3G7hBpfaQ42jSI8D1C6LbgtLk9iawMwaXgtxkHIFpQbw6BdOUJeM/kvmjlRYTaPlumA54Ae8MXVaYcodas7zXXON0l/LR24BSRDvFQZrMkRXNmZmMCQkogtqZIIbXJfd5zfP7oZNa25mY16w0JgSg6klvnicyPe3ShgC1+bqJxRhl4GLKMP5inpK9F3dAox/6XqXrngfMbKvCsZbjP8K5a3FYN9YdlpLxRkLypU/0zXCQuYUfazJZACHW+yolhHRgLhwC2u9X9mIWfksbPazN78RWVxzz9GHiJzYOgqB+9e2un/C7Rh8of9PpAXBsGm4ta577WMFEhzllRBmAeIYcyBKa9t8CBXz0oVsepqfWrQDPmSt5B90APTPiXRDhyUWceWC588TTlly3wPDHSA/ZKYm1yNXiGEBcIm7TXOqApb0aHk3ehmCJOZLcORC1NgFAZ+NWo/9oIqdGsmw5
 QZN6mzF8
 z+MR/3ICN+h/fe2ET5oylSNrVE0lkuRczq9AGdggz7xQpT3QZXL0Xv6SDK54P0CEMFohNIdpUnaaKBzRUxVHsRaaC7sTJnCgKhSj6Iun8tAwGyLAdd+ICsFG1Cn/MyH1QcXx5TCmbxd5rpdEenEUoE7DljDLeuwtfMUWDwvsTrDi73XtQ0OWckXFEQ/+DSjtGEQzQUDwBo0KHY7m7TcHTgfrLBkHP0apRfS01NJG/W6XxGowb7K47MaQ2ISfS8A+TiZ9ykNfC1LNKJE8I8E5XmkEs18bV3lXsIcf2Q107bjAmQpmAje/5d6vAU3y3/HsTyu7mHdUijsxxso3zy9k/i0YmCGLxy/Ew1ieD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-10-05 at 13:23 +0800, Lance Yang wrote:
> pud_free_pmd_page() uses a single-address invalidation to flush the
> paging-structure caches before freeing the page tables. With AMD TCE
> enabled, this only invalidates upper-level entries associated with
> the
> target address. Cached PMD entries for other addresses in the PUD
> range can
> still reference the PTE pages being freed.
>=20
> The AMD manual quoted in the commit enabling TCE says these
> instructions
> remove
>=20
> =C2=A0 "only those upper-level entries that lead to the target PTE in the
> page
> =C2=A0 table hierarchy, leaving unrelated upper-level entries intact."
>=20
> Even with all PTEs cleared, speculative page walks can cache present
> PMD
> entries after the earlier TLB purge.

The comment above the function says it all. The TLB
range should already have been cleared by the time
pud_free_pmd_page() gets called:

/**
 * pud_free_pmd_page - Clear PUD entry and free PMD page
 * @pud: Pointer to a PUD
 * @addr: Virtual address associated with PUD
 *
 * Context: The PUD range has been unmapped and TLB purged.
 * Return: 1 if clearing the entry succeeded. 0 otherwise.
 *
 * NOTE: Callers must allow a single page allocation.
 */
int pud_free_pmd_page(pud_t *pud, unsigned long addr)
{

The PMD could have been (speculatively) loaded by the
CPU after the PTEs were freed, so that one PMD mapping
needs to be flushed here, but there should not be
anything else left to flush.

The code looks odd, but it's a good idea to always
ask your AI to draw up a full chain of events for
a bug to trigger, going all the way back to something
calling the mm from the outside.

--=20
All Rights Reversed.

