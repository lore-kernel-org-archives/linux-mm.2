Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10850D1119B
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 21:53:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 226FE6B0012; Wed, 26 Nov 2025 16:53:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FE8F6B0022; Wed, 26 Nov 2025 16:53:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 114AB6B0026; Wed, 26 Nov 2025 16:53:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 00C236B0012
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:53:49 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4F9DC12C67
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 21:53:49 +0000 (UTC)
X-FDA: 84154110978.25.9731659
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9CED5C0005
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 21:53:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="YW9thB/l";
	spf=pass (imf10.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764194027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/sojixFnf4M/f4sy4V7pcKETyhDbT5OKE0RZH3urOZ0=;
	b=ImQQiJrP+cyeNKrsHgMHxuMlWt4SyYoada1OpsBdL9gxvasBdTrMWZ10rrE4jC3Q0YqVa2
	/fp1QhHjj+YgQv83mPF1AgL7wG/55dGNkMZ/zVvA3ucv+xkp3XYCGd/NnLLa+ksNzcYpfo
	MUepy5nXmTBIB36qLmtfsLbtwsTxgsc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="YW9thB/l";
	spf=pass (imf10.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764194027; a=rsa-sha256;
	cv=none;
	b=OCQwR78BF5xcgS3ScXuLHSV4yb171VzHiJuprRJwaVZE/7B1OqryHJQv5E2rLnZfJakNMX
	ql2vHAMoGY4qoLbI4bxbFpXDJ6Fd/yI+6aCWeJ2YBtAzhwM7N4NRj6tGw90Z4zBkjtazm3
	6XyYAERL2zh+C9QN5hQpVNyIFjr36aE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/sojixFnf4M/f4sy4V7pcKETyhDbT5OKE0RZH3urOZ0=; b=YW9thB/l1Yn63i71gsX97F8VDD
	EC6nFU9YBoCaH41/qyhTkRTRLv2pD+Bem0I3CBiHcsNsLVPTHr/X+m6Affzkv0ILSY3W/MjkiB39T
	Yf1DFWvSzfLvYxfJAh8LU9Z//meA+eBTajN10m5IsOhXcgWwlv0cmBo8GqkAwk56aFDLxUCFdUqP/
	iy4kIl4gGAYD18WCJNbyGcd7o5vmnD0UKJmEo3id5trXZ5lHk7m3FZGHUY7zZLJjL1XmQQ/PpF/1K
	ilAZTkPVj0bujHTWVXCz+Tk0jCHRV+P8Xz5XlghOzs1+BreO33X+jxLAvlY9GnOrYr5oB/4/dcdWO
	+vGfnvtw==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1vONRE-0000000006z-0daw;
	Wed, 26 Nov 2025 16:52:37 -0500
Message-ID: <7665130c511e3cd00f83e8b14de2b78e08830887.camel@surriel.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
From: Rik van Riel <riel@surriel.com>
To: Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song
 <kasong@tencent.com>,  Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham
 <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,  Barry Song
 <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, Chengming Zhou	
 <chengming.zhou@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, 	pratmal@google.com, sweettea@google.com,
 gthelen@google.com, weixugc@google.com
Date: Wed, 26 Nov 2025 16:52:37 -0500
In-Reply-To: <CACePvbXstKtQXE+0i-KRcq5LwrCr92a_FKy2KBmqaiwZEkFxng@mail.gmail.com>
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org>
	 <20251121114011.GA71307@cmpxchg.org>
	 <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com>
	 <20251124172717.GA476776@cmpxchg.org>
	 <CACePvbXLdf9bC3Juj=wA4_TKeH6XUgHbbvwV5HhNQtgoT3CiBg@mail.gmail.com>
	 <20251124193258.GB476776@cmpxchg.org>
	 <CACePvbVJEWd64r-o8ezh+0QByYbWjYVKiLgxNiBJOjfRWP__sw@mail.gmail.com>
	 <20251125213126.GB135004@cmpxchg.org>
	 <CACePvbXstKtQXE+0i-KRcq5LwrCr92a_FKy2KBmqaiwZEkFxng@mail.gmail.com>
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
User-Agent: Evolution 3.54.3 (3.54.3-2.fc41) 
MIME-Version: 1.0
X-Rspamd-Queue-Id: 9CED5C0005
X-Rspamd-Server: rspam02
X-Stat-Signature: xxgt8zuc9arjjkot6q3o9brhuz69kc5n
X-Rspam-User: 
X-HE-Tag: 1764194027-683717
X-HE-Meta: U2FsdGVkX19ThO4trjSB86HjpYzYfuWQpTEXgW+sgOu3HBdBAMnyd8QeFYKsJBVSkDbAXdQg8sAa9NxzPlcnZlo/+awr56bG0Id3iM0MJOvYKwEQM6yuDuZFO+fBch7lolpSel/CkRlTe0V9LIJO9GCvwb4X+KfYrn/wUMfDx/Rh8zjlpdwFPLhzZ4SRHKVsG3HEuiBcHyZIeDPXqlUyQ5kWXsembSascb0u+H8C2SeeSpW8LUuPx2Wrc8jX/ziRZyKh7nDKl9dtQjJElaiZXVfm2hDFyEY/l4VjlGjTq11FMaSW1clqQaFvVcXhshmuujCDBy5vUPx7BPjy/fZW4scgYsAJSJSq5hBIGChII6NehD3WNtydpkTXlT99lzayhbp/MEcIJaAkUAaXqcWjbp0dzunfMcpAcBwpmr2QeLvA3FLC3SWnnhZf3JxhJta0yqiiNjLflF44YFPo6et+y4o0oFXaOlz/i7Qw1CHXCh9GNWvySEhMJmtT54b9ESnpW+FSptke5rlDyXa98GDf4jYzSG6juejJ8ebP8T42aVPfRJQhY9LZBw53+t5T9fIUYPCfUxL2BiLDN/6x/OQnj4tj/kUZCYa1EoO2xOk+S5zPlTjVcfrfHFQtMGqiyJynhlEQOBt3j0aqwthanADeyprMNLGCoHCFLIT9KFZPyVQBKJmb9VKZVu9BJ5m0z3LOLRY77Zn5dsug9ku+brPNC0L/xLlbX+3EuBCZYnozQ+7SzY4sArjtE1ihOY+7qkYbXKgVgS5wf3d7mU4uo+K3C8ggLAaFlGW+VvkBhsK/Dq9/4WEmVL9tirgdCdf4mFekWi4An/uL9hOGgrSWj6gSKTZtMwTlcghwdwIC4snzM9dAJfqM4itfdYtRyMkuqhVHjAZajQAKIzuPEbEec2fPJSiRXBf1CgThv5AYYORuMQ3M1cOuJjWihTybYoOF+DttFe6Gt79wh2xE15m7ZKb
 4TjmT9uE
 BBR9kuIZ39Ktyc67Z/Se4XimfEeORL/4AW2WQnzNC9TG7vT//U8dxxMFqWKMqUN6VCDT49ndmRpYY26NcdtdDCBX4536sjpIrd9/T4p1R/F8CWwBQASsA77YpKdo6rOLQSJ2BivpFHKiojtwmpsTfNVLgfrsmHKnuK2QYiaUGPvf6cFsU0Ioc6GZITvwkBwcAsHsg7RKKQqPZwjjsiJd5INeDdgTuM38HOCzI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2025-11-26 at 23:22 +0400, Chris Li wrote:
>=20
> That being said, I think I have answered enough technical questions
> of
> my approach, to let you re-consider my proposal. You should be able
> to
> realize by now my approach is more optimal compared to VS. Do you
> agree or not? We are just arguing how big the gap that is.
>=20

We would have much more confidence in your
solution if you had told us exactly how
you were planning to solve things in future
stages of the project.

A "I'll solve it, but I can't tell you how"
is not very confidence inspiring.

--=20
All Rights Reversed.

