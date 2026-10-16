Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E648ACCF2C3
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 18:41:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0756D6B0095; Fri, 16 Oct 2026 14:41:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 025C96B0096; Fri, 16 Oct 2026 14:41:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5CF76B0098; Fri, 16 Oct 2026 14:41:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C17626B0095
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:41:48 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 57BC514051E
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 18:41:48 +0000 (UTC)
X-FDA: 85329358296.22.7E07093
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0C4B920006
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 18:41:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="ll17q/ S";
	spf=pass (imf13.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792176106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=83NAm7qyYkwEXRavft5LK4xqvjJEBZGzlvRTDtXgSbU=;
	b=EmvRN+jrOc2lcEFzknmHDLGEJMDLYXmKgHVbbnmp6gg0Iik7I5385NL7uP2ctd6HtkE94v
	ERjuf7m8WtA9eZDFwotmEhZbKv6FPvMzrSkQXWsn3KYq6SccpFC6K65NQcxl7YSyamWfL5
	eNhAOdgIf5xpi9rxcc5pKTTq8uKKIww=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="ll17q/ S";
	spf=pass (imf13.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792176106;
	b=b3fN1BmLLIpNE74/u7ibha8LSOf4F3y3ZtGGn13PPNjqVC13UBMwjDvAS37gPhb5+dLDJz
	M6TsgKzlvLurPG313eGdyBXgkgnliejp58tdIvb5hmFvcuj8EGjU43K9HkQjEz6a73QLLD
	MBr6x4gh3rnQMd/Ay56vmqpRMlroo98=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=83NAm7qyYkwEXRavft5LK4xqvjJEBZGzlvRTDtXgSbU=; b=ll17q/
	Spyeis3hxTUzKQGrNrPge49yGL8fmcE52SurQhbwl2OYsT26/b/D8cVjYgHHmq8Eu9N/Kn6RfriXu
	jxbs4tbB8uV9jNWZMEyEMsMhs/c+LftyU5gc3pe3XtcDR0jTiOzPLObsB/Yasyi5jIL1iytMj9alh
	IG57U+TeEheaOce/P6hHLHNZtj1R9Sh5IMGQwEyPByWWBVUkOBLlN0DQskBQbzElsMruIdug6XSHn
	iVI2QO46EFABPhxBRXC+OR5gwD0ohKk6Ty8z4JqzsCWj8bukFTLTHHb7nkaxzyMb68nf4Stn1a1Yx
	UTbNDtiG+obYG3M5Xt58fk7Ff1iA==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xHms3-00000008q1b-2vDt;
	Fri, 16 Oct 2026 18:41:35 +0000
Message-ID: <8e352038e02e274aab69cd2cfe5820a2734e7f3b.camel@surriel.com>
Subject: Re: [PATCH] mm/page_vma_mapped: continue past nonmatching huge PMDs
From: Rik van Riel <riel@surriel.com>
To: Andrew Morton <akpm@linux-foundation.org>, Kyle Zeng <kylebot@openai.com>
Cc: linux-mm@kvack.org, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes	 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka	 <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, Jann
 Horn <jannh@google.com>,  Lance Yang <lance.yang@linux.dev>,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Fri, 16 Oct 2026 14:41:35 -0400
In-Reply-To: <20261015192020.5336a49bc516219e8254dfdf@linux-foundation.org>
References: <20261016011549.61146-1-kylebot@openai.com>
	 <20261015192020.5336a49bc516219e8254dfdf@linux-foundation.org>
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
X-Stat-Signature: 93115zzd3hj1e7gez1kfseiiqe6jm3ko
X-Rspamd-Queue-Id: 0C4B920006
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1792176104-67269
X-HE-Meta: U2FsdGVkX19gXR2tRAXYtIsk5Hq2pdPhxC4ML29/rdjojwBGX3Z71QuXg9wL2hhLMw+zrpyK3y/WLn+g7GCazbRsXOQ01GMbXNrvgxIvY5X5Pjn+VUmerZQperO/lpcGjxCcyEITRyQUWHelP9idNXTOBNLFekV5CiPNGwoonib/lEb+K8NFApCSb4NOkYzhe15/7t5hbCjvCkn7xM4yA+A89ayFUBgNqDQp/wO3TaWdg2+OHaVDIIu/jmp5O5kCCh2SI4J4jK1cgZFTIf2iH/u7LaWBrCB0Mhx0P4KJhLKh8pvZBbxuozF/gv6HpabnacMCIDISu+fa9ZM7vMZxEAltO2dSd6F4D8FgXxxfibnF92Pf2Dntk6LOUuSOsb4qJNH3a3WEmKGbPiFQLDG0y+mjWb7hhPm3CZdOxwReczs4IX4iMHnaEvapHTiTX74YN6zE+U5U7QYXi92J1bcTbEms1OqaJ87XgT1qopV1KaBpBAa9Ctc4r4EP/rws6nqREqK3FUOVuSXWIG+0Sl926KwbW+v44ZJraw39xDICcaw6WGyBbKMhuQxmXzyQeJ55EnmFT8zwydn4/iI7APwyjFpXUmsweVAYxFLODssrBDrgYoWRLqwCHJI34WwvToE6MRP9HEvB0PVMkLZwTFD9KOpQKhtERZDiGPBktofgTSOb1Ek0+g+5pY1c3LzvFdNZfTGzu3b4yIAyt+rMw7OL7vVTZTZa3NdhJ8LEr7vlpHrLJP5IzQgfEL4lVvsIfEe5bNKJ20Fm589Q3gbtnWiXjt4B3ITNHKzkq7JwWGrpyUuJ8MYcY8WOB18ezowbgL/ZRaCUpCUrGwCRncwyZDQEezQhYeOtts7ZO6pN9vRWQMEroGUc6SwjMrxZvSoegf08bQneYQPaEJ0uiwtlLFEvJx/uxiYa76l/ylieTRTF3S+JYSZD6DHptKKCv9Kt3I2HP/hn3Kla5hu/7m3+7cm
 aii4cPUX
 wsDWs+6Fu9X3syo5JLTfirPGFcfne5myZM10taMzGn937YbTaooymnK8qYHnDWchn/NO0yl7wHmh6oYgKKT2LuCdiZTLdr+JknTvK4aQHuRZnspfmvtUMa2T1tjuGY+Qpv5je0TcurNT7rMeAckWmuDnAfc34iNj4L6Ae2UEeJUgs4KoQYl93or8WZG3wth0P+g5BffgUo+XAr0Ae5MDJZBXkwOWewpAEHHCRg5PGAaHxKVPfOF7QmsXezTAGgU7TQWnyMI6tUZA/h7NhSxF2NlzDW6ODI7BeImVRUpYnVZUsJZJbp8fMkvX4uDHe8mCd/l4fWallbKUC5i/VHNEjOECdtAPlBfe1mUcG2Kanxn9nAYkFDTDiEiWVQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-10-15 at 19:20 -0700, Andrew Morton wrote:
>=20
> As always, when fixing a bug please describe the worst-case
> userspace-visible effects of the bug.
>=20

> But you have an LLM too!=C2=A0 So please never again send a bugfix withou=
t
> this info.
>=20
> Also please explain whether there's a reproducer and if so, at least
> describe it and confirm the before-and-after results.
>=20
I've been working on automating that for the past
few months.=C2=A0

The changelogs, comments, and code have needed fewer=C2=A0
and fewer edits as the rules got adjusted over time.

https://github.com/rikvanriel/kernel-style

--=20
All Rights Reversed.

