Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EFF2EE020B
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 15:31:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6E036B0089; Tue, 30 Dec 2025 10:31:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E44C36B0093; Tue, 30 Dec 2025 10:31:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1A466B0095; Tue, 30 Dec 2025 10:31:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C0FDD6B0089
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 10:31:45 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7C23A139A93
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 15:31:45 +0000 (UTC)
X-FDA: 84276527370.09.7671E5C
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	by imf20.hostedemail.com (Postfix) with ESMTP id F2DD01C001D
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 15:31:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmx.de header.s=s31663417 header.b=GOm5IQq7;
	dmarc=pass (policy=quarantine) header.from=gmx.de;
	spf=pass (imf20.hostedemail.com: domain of markus.stockhausen@gmx.de designates 212.227.17.20 as permitted sender) smtp.mailfrom=markus.stockhausen@gmx.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767108703; a=rsa-sha256;
	cv=none;
	b=xJjyqA8s/Opg4ENw7fhYONjCMMpnHBUViERkkebK+Wf9utgGIcuvVkGnZn4uVGu0t6c2/0
	tCZE7G/hFDpAI+hdUK6ONjiRLqdQkPORa3YVYb2hLmOskblVmsv453y8jr7t3AnXr1q27u
	O40gGCAcCdyfr/tZrPzrVKWR8FPmDU8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmx.de header.s=s31663417 header.b=GOm5IQq7;
	dmarc=pass (policy=quarantine) header.from=gmx.de;
	spf=pass (imf20.hostedemail.com: domain of markus.stockhausen@gmx.de designates 212.227.17.20 as permitted sender) smtp.mailfrom=markus.stockhausen@gmx.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767108703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O/89BOIA7sIM7yjNnltto5wNvtoEALIrG/XCyyRaxZI=;
	b=P9o9f2XLoKQQrVkxZ2mVx3zvG8+y9XCE+idxRHnuICSYZr/HXBn7vQDMyRdbnVe78VJ2BN
	8TsfHYYoKKjccQR3Br2Q85wDTtjnzFHkEjDCq/yNqXhrj1uqFt0trSHEb8uka+wl7YrLbZ
	7rs8wAt0yecWIRtKQU6dwMD35znz8zQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1767108676; x=1767713476;
	i=markus.stockhausen@gmx.de;
	bh=O/89BOIA7sIM7yjNnltto5wNvtoEALIrG/XCyyRaxZI=;
	h=X-UI-Sender-Class:From:To:Cc:References:In-Reply-To:Subject:Date:
	 Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=GOm5IQq7PXpv7FJwoQ8ZBIMDigAlgYNje+xQ/pAT70yZJVOnGMsUOFiJ7/baTF2A
	 YDGh1jkKU2xuyhJNv5hvQqIcDToRUGY6gXabVHDa0dAriHrTi41559sfxL/Z72dQ+
	 PsvMOPTOX7ShHCLQT91kFqjOkkNxdlk419X6MpmFuGUFGKNfTsxys1hnNw/4I464C
	 b51jJSCEsGmu7gNqZoX+48qiGZZ+zWWlbO0u8w2JfLT+gcOmkNxttVSXN4qk5dJ/m
	 o/TKXG+Yu20n3UfdZYWUoWA3U2EltedTS10BGXpzPQfScsn04Nfdl5EoeSW0KTAnW
	 oxnp/DCbwAQQixlu2A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from colnote55 ([94.31.93.28]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M7sHy-1vVdsf40Pa-001Ven; Tue, 30
 Dec 2025 16:31:16 +0100
From: <markus.stockhausen@gmx.de>
To: "'Mike Rapoport'" <rppt@kernel.org>
Cc: <tglx@linutronix.de>,
	<linux-mm@kvack.org>,
	<linux-mips@vger.kernel.org>,
	<jelonek.jonas@gmail.com>,
	"'Chris Packham'" <Chris.Packham@alliedtelesis.co.nz>,
	<hauke@hauke-m.de>
References: <007d01dc78f2$1ca4bf90$55ee3eb0$@gmx.de> <aVLX9yLmIBPzI0MQ@kernel.org> 
In-Reply-To: 
Subject: AW: HIGHMEM freeing patch breaks Realtek RTL930x builds
Date: Tue, 30 Dec 2025 16:31:08 +0100
Message-ID: <005101dc79a1$562a4aa0$027edfe0$@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQFaCkT/QJ6/mAqkcN3Pcnid9AcWCwK/dj1KAq3vqrq2E8GN8A==
Content-Language: de
X-Provags-ID: V03:K1:hk7HES/IDHwzVpxE2GUcbmUrEMMTVf4tUWwB9YeHVhX5I1j/UOh
 mSIZLVpsYOt72yJZxHQhNW+Fim5TFtCb5v9VPy7/Wnz7sPCd3XDgDFGvFTDUYIkPNQej73Q
 877wTcLa5Ke52OycXDjcuWy/QzTCzOmnxr3coolhwiww/5Z+0yVi1zE0/vS2GvoDwchi0eA
 Iw0BvqHWHYHErBxgDsvnA==
UI-OutboundReport: notjunk:1;M01:P0:MS2RU0lruz8=;SKQQgNUikQZ95Tc0HfzMfWcN5rN
 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
 cWkas2p+MuGyxqbcdqF4Nef336A3LsHezmltdp
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F2DD01C001D
X-Stat-Signature: 1g7j6kosxu1gbbwgyxru5kks1obmdb1d
X-Rspam-User: 
X-HE-Tag: 1767108702-804913
X-HE-Meta: U2FsdGVkX19uyJDtFCXZ6JNnw4ZM26fF2NmblDeuqNSct3i80T9IAp54duHGcKgZm3vN9DxvGL9L8R/FGCySsPbU63lLD3w7GFsW3il6BHkBPlETLfSPLOjEjAgUibdcR3t8d2ZOqMGSMOqgWj2BptX0NWxUodhj3cUrAkuJejyYpZiEv/N2KtFfejuWX6qo5M4FSU+RtmNPT5SNeZg7J0duzFSWboebN2stoexZaGFBfHYqv1XGol4K/0xEbjxxTMVKsceAkmka9IxJtnn3GNvtNCn9ND05MIRMIPFkJYXjNoBIJjBYHSJHVMsp0h3pdnjoyTbeueF+0V+hFXzKod93Ca54Z90FYjB4i0AcEMb7iID+lKMOXZBCkLq59uHXb/4iG4ZBS6nxvOHhmY8rlU/jgg9ZXUdl1TPWFcLSNxoqKAOmtxYKM9QNDJ53fx6ISgn1+WM/jMZz3SkgdcGzbA8z8D4Wl6usX/PIO/c4c7iW86uNcjzB4XUYuYI700RSoB4Jum7i3+zYB6RCrLUoAoHEvq+kjobY1Bs0h+Lvx/noM9eNNAWDvDLGaXgJ/1zCg9K52Uaib3L86YEvh16fSiTCa+3hA0hHwa0VNx6I7ueZUCgWk8+3P4yFKDDLYsWCF4v6QauFUzOs+qzO3VFabDD8mav9Hq8WCTv5YWV96ZOXym7Q1Nqn90jtc/QW6EtI2AncvhHoKMHGzHSp55N07QYKMYiqWyrNKcy7s5snZRd0iL3xldBJ8O8RmWaVOmDmomKiwAB60WR4v4SYQfrbRNF6pZEwje6Z+LiuHs0Kbj995q0z5uZDzxCuwaE9PewqIYh06ZXHSwCm0NKB2WzKMRYfGvxifehRxqzukyxB4/JSgpD65Vmr1haMoR6gymjZTTCKcW1tlL5u3iF1DJf2PYvH53Qomj3yz4TCQaNdAYo8K79Kk0Qxwt8wOmoS4cnsjyc0yuVAYwg/GFcRfl7
 DB7C47xu
 /uG63h5UiHofVTV5Lfp3KZ4A2+7poL5wDO6TwfdEQiNp0jPtjdncvczg2B/EHQfaIg38vbPt5zVFHqsqkcW86oUVVZGeq/bpbbMV4MJIPSNbJnpOmMpfq17xdbmcpf2lBYqvQ6eWWYVM5PSRRjgh9rDFs04ri/mJ7P8reuSFTwkVOSiZqD3CdGHFF1NpEfja6hTmTea7xS+0L5WQtdKL7FzzyP/nLZKWKdedNUy/UXHXOeRF00CoW5KkZyflbI60R/MiELaT7Nk1ISzPIOaU4Z4IMDakRwLq4siOT6vuSZGY6ZDU7l7xxi6CZPiXJV0LZFg4Wnf+ANa5VsFGiQeFyRDfIikHidB5ARmRxMaR9PmpSL2110eo8AV/LTyk/oJX05uh4zArLKgl6Mi/F7o5iNYqLZwCLr1/GlqJPEXRNAdiBbsJ7FOz228HlMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000134, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

> Additionally I identified some spooky highmem=20
> initialization in vendors SDK prom.c. We never
> used that before. I added bootlog+code snippet=20
> to the github issue [1].

After checking and testing the vendor prom coding
I finally found a solution to the highmem issue. A
special mapping register needs to be setup prior to
memory initialization. Fixed with [1].

Thanks for helping out here.

Markus

[1]
https://github.com/openwrt/openwrt/pull/21327/commits/02117c1e971b86244178=
43
7400ab8b2f6a81d2e8



