Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC7EDFD9E0A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 20:34:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFDB36B0206; Thu, 26 Feb 2026 15:34:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAB556B0209; Thu, 26 Feb 2026 15:34:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8CC26B020A; Thu, 26 Feb 2026 15:34:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B76D46B0206
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:34:57 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 520DF1B6B80
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 20:34:57 +0000 (UTC)
X-FDA: 84487761834.25.4313028
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf17.hostedemail.com (Postfix) with ESMTP id 49B2B4000D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 20:34:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=dfinity.org header.s=google header.b=JxSk7O3H;
	dmarc=pass (policy=reject) header.from=dfinity.org;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf17.hostedemail.com: domain of bas@dfinity.org designates 209.85.218.49 as permitted sender) smtp.mailfrom=bas@dfinity.org
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772138095; a=rsa-sha256;
	cv=pass;
	b=xbj/n3flds+iml/m0m/ZIwdwjZ7/norXXzm9cl1YnkDupzBAuqpBELbsqLVlMw9K+B06eO
	DleK+0X/Hx7XY6ja4DfrJFqu4KjaDA86AItlZ92sGM6O7CURm9TvaPjMOi4hGDuunr/Bni
	YRImNENV7gfY+GCw/Ml0r4sbNEWOPKw=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=dfinity.org header.s=google header.b=JxSk7O3H;
	dmarc=pass (policy=reject) header.from=dfinity.org;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf17.hostedemail.com: domain of bas@dfinity.org designates 209.85.218.49 as permitted sender) smtp.mailfrom=bas@dfinity.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772138095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=U/LDD1z2TKe5h3d2wNAHdQcijfYso2V5ER73f9IGGqI=;
	b=4ZoFzaYIhF/0vnrbiycBqZZNW5RyYkVD2bz2a3FM1UHro0SAoPOwpooGIixdXo9Ngv8zjK
	yIbEyeaaNnGStiNkVaHPJ6yXNYXLxzYbg+wiAO6soDdNczL2ZpOcOlQZoENVDUHUCDiHGY
	eUNtp/9b93/UuDRxfwjlwwY8pdUNKqY=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b886fc047d5so218029866b.3
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:34:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772138093; cv=none;
        d=google.com; s=arc-20240605;
        b=jWBkzTM2z0R1tew6riZjpSfIUllITnlY8eTL0pyu0Xh35CzbsQkFwcYYsr1sAWCIgt
         Hzs1x8ww+3aB0uc6HGT1Gf051s38YgYysbE/Mhr2EcHmp0BeG12vSc9cedB3No/retgM
         8KA73tkxmEJ8DyZzsrFAQnx+Jdp+CGgT54KjIrlMfmo+m2cogdgAizklHQIFSXOG5/NA
         piHtqTdoj4jkOofbQIRFGh6DVXIazsyrSbcg809CjNY/ja5CdhV/oYg7DJPGDbpe7eEL
         JicErHGk+xVW3epJokiwds4HcxuyKxVWdPvV9D5oFBglBufXFMcdhRw+VRR5RIpPJUOm
         DdBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=U/LDD1z2TKe5h3d2wNAHdQcijfYso2V5ER73f9IGGqI=;
        fh=7yMZDoPB+9hNOWc9Kn18Tej3joNHccg9aQ0DwjXjEdc=;
        b=AbhkZO1hQN1h+zosHIh3iynyBTbs5H90CaC/jMWYsR3I0+dYfc+EhwcXPtdElL3uL2
         HJGXTM3Xib1gUpTFfZIiYfIrN5F0WvzjgXSObPJP+bBzmhL7KQRIGFQxC2DQvEe72wF+
         /VqknPmmuB+c1VMip7rgzlTCwXLdyWBP7yh9mspq4ZxDA2M5x/IdlbZsk+p45OF9ROa/
         6NsddHpkJNG7I4O8hUqrP6aXulJ8ldKR3kF4sTWm5/38VkNdUJmxF/V6ALrzhtJLbfrX
         Y6rZrXDHgELhw1m4Pf0wQIAsGKn3cY8o10KLKA4WReZClvBRVApGVVU9KEXxHg/cOAEr
         lIJw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dfinity.org; s=google; t=1772138093; x=1772742893; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=U/LDD1z2TKe5h3d2wNAHdQcijfYso2V5ER73f9IGGqI=;
        b=JxSk7O3HoRCekwCGLeqUJFAj1r18RCbhNH1j8u4ZPLDeMehNSh0OFtE/CaZ+lzAuDX
         2P5Z5NGW+ltzsXHGSsOMl8Gm/jSdFBIp8SN6IcNvoYo+8hY4fSUzekmlU/KTMD5MtP+3
         ZANDnIHjyx//Ijtb/Z9R44ou/6DzNTShpz91VmgeyTfT1Hc6fDdi9x5zyvqAQqjFB13r
         DrGh0wjQqjY30/7HgFp0sx0Q/b2GsRV+sE+fLI/kqGwWKMX0d/48ESA1wfL+fNRZU1pD
         9G9EssXKW1K9x8D5KQqMHJQIpH4Gy1WePphAhd/TXbY8+JpHhrvre7f9cL+Fji74VZNm
         fpPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772138093; x=1772742893;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U/LDD1z2TKe5h3d2wNAHdQcijfYso2V5ER73f9IGGqI=;
        b=CpkTiFT863CbD98NDlAv8S13wWaY03BytxG0YhW9+Raj1HQEN1FNi8ki1lLDV/rkF3
         bcEExdc1J0AsUeUG3NAn5ICgY8BlYO/YwO24c2Tp/GFOOL3dTHtCwFG6/VotPl1oUXh+
         uyM1VYJE9sGlcOsdrtCAsRRjDvE1dSa8egW6RmgukhuwdmQLA4kte+1+esPzLIcHrJRs
         xiclp+NQTrJmQSIZbLLbc7HsJQe83hygeRYoCnBUTcs16ZGHbVozcAkIlpBRri1pqcCd
         TBF1RuatRpz0yFvZp2lcQ6iMuSfV7TSqAUFHKPZ8I8gMSsWaEO0tAC/EyGm3j4daeG8z
         oIFw==
X-Forwarded-Encrypted: i=1; AJvYcCWHjKwMHB8Z4IU2mPc5IvVUGbDkIxBGlkxTSkHaq2be3aijwt/dQ7iKq/TFBpRwAOslb6YJ/kh1eA==@kvack.org
X-Gm-Message-State: AOJu0YwgH+Oja/sGYjmlzZ1Axhsnjy42G9q9kOM/XSbtfFrresRKXY7u
	wiu2s47oJVqCI7jj8HWXAB1l9IX8+GS5qyFEdT0NvxSiEGG4+vvkzN3fC4xQSqaL1OAztmpjYr6
	bCjGr8RNDpHhNOEFp9QnSrKNUotJEhs7EIbNmNUPtkw==
X-Gm-Gg: ATEYQzxMlNgLZOPcRxgbEC2um2aaBxdpHQNZKemXYaEL0EPFmJgWKSri9aZg4Ln2MK5
	UKsE6i/z/Qsg8ttQy8jZvQCuCK5UR3px1HDNTjLsJDwozwRQ1B8l/I2kai0wFv497wnJFwZs9y2
	KPBv7Gb+Vf0hJUSsiO0/bCXUaNEjPdrw76NtneBrMsb41RmREl2guPpbNcDTaAg5hDUiRa136Z/
	0gkPVplPHZKMdmHq+qQGbBSpI8ASeYW7eHd7dZ+uj/AULuTaGDbrvU4yGySs49YUFoOhkKvggDn
	9tS/9xm/EV94Ap8wXA==
X-Received: by 2002:a17:906:fe01:b0:b87:965:9079 with SMTP id
 a640c23a62f3a-b937637a66amr15028466b.3.1772138093346; Thu, 26 Feb 2026
 12:34:53 -0800 (PST)
MIME-Version: 1.0
From: Bas van Dijk <bas@dfinity.org>
Date: Thu, 26 Feb 2026 21:34:39 +0100
X-Gm-Features: AaiRm51ixtaZsR4nC4lb5tpa0OKMp7XhiWCl2cAUjP6Ip_URV0YMaEwCqQ0hxgM
Message-ID: <CAKNNEtw5_kZomhkugedKMPOG-sxs5Q5OLumWJdiWXv+C9Yct0w@mail.gmail.com>
Subject: [REGRESSION] madvise(MADV_REMOVE) corrupts pages in THP-backed
 MAP_SHARED memfd (bisected to 7460b470a131)
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: regressions@lists.linux.dev, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, Eero Kelly <eero.kelly@dfinity.org>, 
	Andrew Battat <andrew.battat@dfinity.org>, 
	Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>
Content-Type: multipart/alternative; boundary="0000000000008c1373064bc00d41"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 49B2B4000D
X-Stat-Signature: e8zje75c1ik7tc6ayb318b8cnm9515ut
X-Rspam-User: 
X-HE-Tag: 1772138095-753375
X-HE-Meta: U2FsdGVkX1/Sz8AZZ9uWXzQuXnrFo0aEtIBeK5va6ba8fXrvLT3iEWt7xLknYLjPwe2yxsut1oP8h9EEUsyaPOJEjTjI4M0EXNQR3M3730Syo+UhOXgEY/l7hLwVZLMovgE9/QZ5FVcyNHrujgiXWQxhANrh+yNbPIUvkmA4h74WIEk0Mxff0R8oAQsFMFLGNUJ7NhylIutGr8787LZ+pcXLAEoVifw6qphtrzf8DNf7dW4xiCHl9Jc0JYG8k62VNBGB7tKlMYBalpqvAZrdQHgJ4sQC1YLVeKpmUb5CtkVIuthhFUikJxbzF+MPABVAlstItZUHacm3PnG1jzbcLkXgBDqMZRo2htCbQx0GhUfGXHlhP85T+gn9eKEhbDRYDC7EfMhvHL8mBJ0zZRQM74Nlxztp+RaNf7keFuvUCzVlTOa4FY7xpow1b8VkDYl3743f7EmXKVGlh/8j8ujnGC+jlIGkXH4DXbd6CzBcg7xsoXm9ZGerKkj5iXQS+Al24dvmslBvZgsWpApYGpCj70zhGxp8GeCtDVeyqIcIsu7nhxLl+WfDw2gMVLr3yNswTw0RxI8iugdodjMMOrdbSdA4JBq9/VD+p1op5MSjAYtP6/zt6zLI3luSd7l5Zoe/C144ZLQgA0BBYOodqzhW/zpm1Oz9DSC2D8HdNaqYOvQl6eNQzGti2Ki16j/1rigI3NWEP70hdaO7Qfaf0mRUarHXEfaxfLmQpCWK7ki8ix+YEZlHfjEY01rbzWdWAcmZGhqKKz/O+w/mc5jDzlsNfItZSHY7p3R/Vvs25q3EIzRAfAcLev0299BxsqRMB+b68Fldjl/zsrz7Tp19W0KGe7QySBaRd7Wn1VHpQLArb9CtrN+U+nGbQww4jFNWFpQb1LOCB1bWEMiwlkZWgLGlu0H04j1JNLqciUz4n7sP2y84ZkRvspIZBFRU+E5LnYEB7aSkkMk/r4BcazDYTpA
 BWHlzlN9
 uuHUmgtzqGRKVf+qZHQ+w39Cui4VVTXoafC6uhn0eMRdpi8/uZUjCU5W/GKw6zw2iUN7EW2KeDWvd75Z83Z1XdNGx9lMHd0eO60nFKPGYW3b5Wg+7N2Z0267YvpA94RsWc9CS/WchwvygSYfngaJFOzVLWVMyxgaevxbdXqfUJhxwsHisTY+gTcpCnv+a6u3ovIQANJdJoawrPy1R8d9h6GEfxUxLRb3SEw90Ajm7l6N11nz1O7ZmQJ204Hzy5gVdWDkDvoA61pc0LzhwogbjFSo8OC+jQUNBAyVC5NbkDvnXuw4d5ET4UdxAB0zB6jEp3ftrbJzZ2rgxxx5fZZn0N9AnxuICsGgeKHCnTqTBcwmGDpBD8A9Nh0LXSEC/vLRrgMLoRCVIaJMYXaG4yqJlvsbe2S5hu25HwOeZQSl7lHUiC/dgHu1QDF40cA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000008c1373064bc00d41
Content-Type: text/plain; charset="UTF-8"

#regzbot introduced: 7460b470a131f985a70302a322617121efdd7caa

Hey folks,

We discovered madvise(MADV_REMOVE) on a 4KiB range within a
huge-page-backed MAP_SHARED memfd region corrupts nearby pages.

Using the reproducible test in
https://github.com/dfinity/thp-madv-remove-test this was bisected to the
first bad commit:

commit 7460b470a131f985a70302a322617121efdd7caa
Author: Zi Yan <ziy@nvidia.com>
Date:   Fri Mar 7 12:40:00 2025 -0500

    mm/truncate: use folio_split() in truncate operation

v7.0-rc1 still has the regression.

The repo mentioned above explains how to reproduce the regression and
contains the necessary logs of failed runs on 7460b470a131 and v7.0-rc1, as
well as a successful run on its parent 4b94c18d1519.

Best regards,

Bas van Dijk
DFINITY Foundation

--0000000000008c1373064bc00d41
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>#regzbot introduced: 7460b470a131f985a70302a322617121=
efdd7caa</div><div><br></div><div>Hey folks,</div><div><br></div><div>We di=
scovered madvise(MADV_REMOVE) on a 4KiB range within a huge-page-backed MAP=
_SHARED memfd region corrupts nearby pages.</div><div><br></div><div><div>U=
sing the reproducible test in <a href=3D"https://github.com/dfinity/thp-mad=
v-remove-test">https://github.com/dfinity/thp-madv-remove-test</a> this was=
 bisected to the first bad commit:</div><div><br></div><div>commit 7460b470=
a131f985a70302a322617121efdd7caa<br>Author: Zi Yan &lt;<a href=3D"mailto:zi=
y@nvidia.com">ziy@nvidia.com</a>&gt;<br>Date: =C2=A0 Fri Mar 7 12:40:00 202=
5 -0500<br><br>=C2=A0 =C2=A0 mm/truncate: use folio_split() in truncate ope=
ration</div></div><div><br></div><div>v7.0-rc1 still has the regression.</d=
iv><div><br></div><div>The=C2=A0repo mentioned above explains how to reprod=
uce the regression and contains the necessary logs of failed runs on=C2=A07=
460b470a131 and v7.0-rc1, as well as a successful run on its parent=C2=A04b=
94c18d1519.</div><div><br></div><div>Best regards,</div><div><br></div><div=
>Bas van Dijk</div><div>DFINITY Foundation</div></div>

--0000000000008c1373064bc00d41--

