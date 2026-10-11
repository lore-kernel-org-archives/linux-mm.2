Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCFE1CA9ECF
	for <linux-mm@archiver.kernel.org>; Sun, 11 Oct 2026 22:00:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63EF86B0088; Sun, 11 Oct 2026 18:00:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EFC56B008A; Sun, 11 Oct 2026 18:00:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5056D6B008C; Sun, 11 Oct 2026 18:00:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F5DD6B0088
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 18:00:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 888BB12070A
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 22:00:07 +0000 (UTC)
X-FDA: 85311714054.29.E41A777
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf21.hostedemail.com (Postfix) with ESMTP id C00AF1C0006
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 22:00:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="CdZxhg i";
	spf=pass (imf21.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791756005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L+whpSUY8l7dBDYv2v/0jlwXxPfZEgsXE+WR12p+ftQ=;
	b=bJaO86XdQfJ6e7NVDtpPHfHyKy2GBN/4a4EAdwBlYyOaJ6/1EReCLSTyNclteiRjtXtMxX
	E9EZpVKmd87hZKjIhME7phLhSycBk3lNfCEQFiiv4t+sd14m70Dtv223cymWdPFT3OrIiC
	UCTf3M5oujwOwpncQoRRG9aoXRc9fyk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="CdZxhg i";
	spf=pass (imf21.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791756005;
	b=dDmLBAesGx3UHQ8z46KUo9T9HPrVcNKT8GDziylBMreFxCKJSMWoMzoSugtX8/cKMhDtzw
	jRWUQEdoJNhsGgBPPvCCtcEcQNgJuwCzMA/1Ikkd51YI2fD+Wr1aOstCdjzWXqoTmvyVvO
	xFNHdi3lJ7SIXaxqN8Tg/MDbvHaetc4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=L+whpSUY8l7dBDYv2v/0jlwXxPfZEgsXE+WR12p+ftQ=; b=CdZxhg
	ia92+T7t9tNF9vFf9w3P69Jw3yi0P/s6f9KhxSwJFEMx3iadFoORgrniAV81+LBD/5qGjh/nRPaeD
	HJSrzr340wYnn7XQ8VDnzzILWHZoELF8LnEtpNLDZUWI4zLhVAnTWw5miSGMIpo6RUbBHIdge+A1Q
	rirkKWO+QO1q/F+5pLd2wZ4dMS8FJaEmRKoeG3izUopYp4QXNpqWr/nVRXoMInHfuY4JPpL9DxKpt
	wuIq7xjZVUQxZysrQD+18rU3B8ca2zxeLKeGUqIFurAmAmuW2aLACMqNwxhdMKlWPUsNTtiqfNoXA
	KsE+aN+ofpiPyAfbAml7z0hy00Vw==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xG1Zy-00000003Buv-2G6U;
	Sun, 11 Oct 2026 21:59:38 +0000
Message-ID: <16a9c5ef3fde0b7693e52dac91a2d397526dd99b.camel@surriel.com>
Subject: Re: [RFC NO CODE] [DISCUSSION] Anti-fragmenting ordered buddy
 allocator
From: Rik van Riel <riel@surriel.com>
To: Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, ryan.roberts@arm.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, 	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, 	kasong@tencent.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, hannes@cmpxchg.org, 	brendan.jackman@linux.dev,
 ziy@nvidia.com
Date: Sun, 11 Oct 2026 17:59:38 -0400
In-Reply-To: <20261011215412.1181172-1-dev.jain@arm.com>
References: <20261011215412.1181172-1-dev.jain@arm.com>
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C00AF1C0006
X-Rspam-User: 
X-Stat-Signature: tgqms7m35bjftrci3itwj7i3espsqjjd
X-HE-Tag: 1791756005-388285
X-HE-Meta: U2FsdGVkX1+r0TWnqR/kXTMy8jIerJoEh0dmtD5vU7RjmZd12B6SQjaxqQYuQtaXiD3doHrCrkpIBIdLk1S3a+MstqKz4oQlHIY+D9guVkm74iTW6Ixs2wW/VksBk8FCVv7VGo9aS4tIWuKSR4Q0ijr07rz4Ejf4BKzmr6sc7Q2qcIeKLj0qm3Czct5x7IVf6qepqr3KO/QrIqqnQwzTK4rgbhxOhdM+AGRB39kcMaeR427A6ZDwcnZ7gCp6HaMQ+TD/dmzoegLk/3Ez711lPYaBzKIzLS/Z1IUl1bXiT6wyct8NETbtqN7DijbOatdd+P2j7C6S1jpZbBiHbR5ytL57htTXhCb7wuFf0yvmqH0cuZYDd7hfrVct54lhd5L4uuXmPGnpq2EtxDB2cS8JrgPZgejHO1xFKQjrlYaMfp0INTZTBGnon0aAi7OCdkzz2vOZN5lpkLxfwrCkM0+UMKlOHlW/hHKWUsACcG9gQ7+grBzfzU9yc3utwnWwrvyhT1miQM3S3TZkLbsxAL2cNnQa/kbk975tTpn0sxpt8gAedtbx8f0yj4WqvUwIhDRr7zskKrBQ79jpnP7q/lfZS070w7njyaZCPsaClwM2Cbp5Vc9OobqzO8ek0Zq5rXUgiVoAWNemraUl9R2QDSbxiK1jlJ9WKznVmhLbMK3OUwgWHj5Kdnvc59EiXFcJ6B3Li1zILFmAXpVVTeoJJ4zMpaDzdz1kK6cix/ohZMJ5Rqv/JZG5PEIbTEb6hz3ozyZP1ZZFCXbuzS4v0oO18l6brjRIdb3EQeGJMLqCCflxFsYsqzsocmvhLAuDIplvlwgYEGHWNkk/ci91UvSjNxzc2wZgulMqHcKvqcSYUfDlyjHHyn0TjD7yhWiFeNblcIqWxM7ex3MdesKnkYo79z2lgsXL2M5t0qk03UQXZ6wUx9XuyPVW+cRE73ppoJ/a+397lmJgbN7qAychLfDv9AS
 KCddJaDM
 41oPnXvIEi2TpQgkcru/NlvRuKuORT2d8yvH+sJT8kVu8jIitrahaAFXdZmwMeVLRmawYTu3xO3sc5dBU9Te8wsKxFtbKPi/+yn1B4bXEd7iIC5ZIBZMBIirgyYBrX0C5BA7R2wdMTx6VxDeBxjCJNp98j4x8CWIyQ/4r+Bx+y5Vu1uk97JfDsKWNUiKMQSbrsN7tO3kd+bS1YQrkh7tzcAxCHVmDpCGYdJCBo0Dn/3iybsB/tUNsc22L1O4dmhAkSNjChPbh6PUeQoSs/OA14DLvf0vA0i3BPq6dMcaOv79S2RcNlZyQIbZAFo5+RBgGGmUA7Wk734lH/F5qvcVbVJHFr1fpDar7n4S2HQZJKCaZLeyCKdSgpHOcfSMkkZcwTTnz9yHnflZ0w9m1EQVsoCzcwEFw2gr9stpf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 2026-10-11 at 21:54 +0000, Dev Jain wrote:
>=20
>=20
> Apart from dividing the freelists between migratetypes, little
> attempt
> has been made to change the algorithm

Could I convince you to take a look at these
patches?

https://lore.kernel.org/all/20261007021250.1665929-1-riel@surriel.com/

My current plan is to first improve the
fragmentation at pageblock level, and then
add some slow path code on top of that
which can steer the allocations by physical
address range, to preserve the potential
for gigablock page lalocation.

--=20
All Rights Reversed.

