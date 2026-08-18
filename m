Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6CBAC5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 17:11:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3E076B0190; Tue, 18 Aug 2026 13:10:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEE5F6B0191; Tue, 18 Aug 2026 13:10:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C07226B0195; Tue, 18 Aug 2026 13:10:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FFA46B0190
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:10:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3E950A2A48
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 17:10:59 +0000 (UTC)
X-FDA: 85115030238.28.BE9FA8C
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf17.hostedemail.com (Postfix) with ESMTP id DF40B40006
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 17:10:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="FyNTKe /";
	spf=pass (imf17.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787073056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rCDuDNwz0XeDMuu16CP5eL/KVU2iSk6zvi87cui3E+0=;
	b=mTzZTg0efqBaWmL8bZwgHAFuhWUIe6dhBK98I6dktEkpEpnAmIG7ZgrkwS/t+qQCLkgRHv
	38gzDUWKjeTiNFF7Ri4JsGqJZ5omp3cKe1L2xOp2ZnT1V69pXrLEaU9QebchwDrJ/nxj1S
	5lL/GTo/qVTxif6VbAzZRM0wVgRqvW8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787073056;
	b=ncn3J2puWGgNRg9Gb8+sJvCIq6A/dMf7qIBvgoXTqE7LVjj3bRTC8YxPZ1auJVl2cSoX08
	jml9T0hoFZIo9sn0pyrjGJ9EHk5PjN7Z6r9s3ZWPn+reen8oW+BjZYFBg3+ejtSXazo256
	lhVSvaO6C+e/n9Pw+Ret/p7WwpzniI8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="FyNTKe /";
	spf=pass (imf17.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=rCDuDNwz0XeDMuu16CP5eL/KVU2iSk6zvi87cui3E+0=; b=FyNTKe
	/7iJWhy7xTY+fYY3wY/eUn7R9e19c89FtPDm9TILvGphDJlosu99iTlDu9yUaa8JHoxyC7u0941Yl
	UQCjaUrJ1/gWTaAyIUW97myyEm3XqvyygJv4QjzTl+jB1Mp75TwAu+BqeIH/dHegTdX5jVr0wdGPF
	478xirDUzDQfgqm+/j94btbWrNWZX4cpdeqyfwrJBqx33vcZhnNLpYfty2h8UFQpjEoH/nXqdP517
	fXRnDv41DlZiZ/5oMHC7sdCNx7DSnwrqz9S9lWt9BAqGCs31xlWPuhG2EsxcQDRC59bLXc6aCEw+F
	QPojraOgGxcDZC4bhIRS5tFmdLlA==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1wwMpQ-00000001URT-0cJc;
	Tue, 18 Aug 2026 16:38:20 +0000
Message-ID: <905d08d102e56a026a5ad69573c507d2d9becc37.camel@surriel.com>
Subject: Re: [RFC PATCH 01/57] mm: add pte_folio()
From: Rik van Riel <riel@surriel.com>
To: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org, 
	david@kernel.org, ljs@kernel.org, nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com, 
	hughd@google.com, lance.yang@linux.dev, liam@infradead.org,
 mhocko@suse.com, 	rppt@kernel.org, ryan.roberts@arm.com, shuah@kernel.org,
 surenb@google.com, 	usama.arif@linux.dev, vbabka@kernel.org,
 ziy@nvidia.com, usama.anjum@arm.com, 	agordeev@linux.ibm.com,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kas@kernel.org, jannh@google.com, 
	willy@infradead.org, pfalcato@suse.de, rostedt@goodmis.org,
 mhiramat@kernel.org, 	linux-trace-kernel@vger.kernel.org,
 bpf@vger.kernel.org
Date: Tue, 18 Aug 2026 12:38:19 -0400
In-Reply-To: <20260816224609.308019-2-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
	 <20260816224609.308019-2-kirill@shutemov.name>
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
X-Stat-Signature: wifkeoxic9iwwjmcophm55zptrph317h
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DF40B40006
X-HE-Tag: 1787073055-145123
X-HE-Meta: U2FsdGVkX18nLCF1HaVx3VFE4GcXZJTR/W4WMZ2MmfPH+FhWHoJICYFcIDaDN4ZylvNxWdZIZFiTWNmtwhyGtxISuIMU0R9BKKilc5FRlRxLl4FLVgXqWKrzjI1eqNMndG0dmmCfUVdRXjWYUXigZSpe8QEnZ+3MV+XVmywPXVBobhnpOMLBtoChX3mttShrIeLqRMn38FWe8D96Dl400ASLWLyL4v+PRZK3ejLLgqCxOKQGbtxfYf3GQ8FvmtPKfqgfXg6a7ifAZabZgXN3z4WBima9pXwIgOKaqKD9A+jloRRX59qhX4G4rDMkx4jvhU02bOSmnvzVHWLredXkm8wLNj4MjkTlLlCXd2HOs8Aw/NRrkDBq9uqYC1WL7178YccyMPaKY7BWOu0CFZrPfK7TT5zpw2xCo3RCOCRKde4S4vLb4mYuBCZSBpXGtVLshz0oR0JVYVwrmQOtDlSdoG4L16bJS/plVrT4ibmlVJECnU8/9AF4THRWbQqCJ7Eys9+3nLCKVanZ2lC+PEVPFXNHur415cDwTQ5ALP14/BKQCOLfHcwfX6XlJzUdzuvoZMjiRPkf6JV3aI6kR0vqxsjTwAIM9K0eUFkKmXnuPnzacbcAun7uBL/KWuIjoyyuHHY7bPWzFLmdKQXsEDC1iuNCguODJFyYIsHInQ7f8Kdllra4fhryqJxp5lQ6KP4u30ZvgmUpijY6iCQHp0pIldmsPPbB0a6JXHc2C9Deoj7KWygLfKDVdvn+U49DiBmaXiDzGDFGrSDknYL4W8NOIqR2HabpUcHxqQIBnZP+lmsIVX6vyMeGY1GaG3d+tjQCkXz3pAWG5AgnyyNFYLY58sGTdEdqyLeCnwaxiUrBm5Ow1xPH1vXKdOlAHUxFqdrkm8W9fwQMuj5j741664UkoIPTqVqGPhMZTJgkerVJp/vZP4BokTisGsz4VMe0j3oV9nfZzU8JnTysrVErhRr
 hWI6WigV
 voP/4HNSGHdyyq6my8D9XWjBVA8KaLCmsiTryDAe8jgKgB3U4e8PvPP1zqlBW6G3DvuflAWXgguOIBvqMu/t0eEeQO1RbGr5tiB39lK/HmVguiQxhaTyZ9ZUAmsZ0HVG4Xos3q05T54+lM/znkabk0TaLHm6HIQZj544NnjXNFfxIa3QKJ8+pI+V2LDK6IbKTjE3TCHYfx0dKU5ZxqdvUBRrg01J22C+LyjTsIqNNJbkr9smMhklvTxxoOIWGg2lXDkjYi5Bh7BIRbtFVYQrVUHXcD5HiEB+pmx2CR+oJp1u0rtgddGevzNzItFlyW8KRlXB0+MpDP4q9t7x8b8YCYDIe+Cs7Gy3ZhABtT7Hm1ALz5ZEPmAInuadBNplwVEXvo4rC/jUQ/ipWL9NE0OEXAPbz7BDQsoXmjgAb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 2026-08-16 at 23:45 +0100, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>=20
> Callers that want the folio behind a present PTE spell it out as
> page_folio(pte_page(pte)).
>=20
> Add pte_folio() as the folio companion to pte_page(), and convert the
> callers in fs/proc/task_mmu.c and mm/hugetlb.c.
>=20
> Preparation for the anonymous collapse engine, which reads the folio
> behind a PTE in several places.
>=20
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Oh nice, this could clean up some things in the
get_user_pages code too, when we get around to
tech debt there.

This could probably go in by itself.

Reviewed-by: Rik van Riel <riel@surriel.com>


--=20
All Rights Reversed.

