Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA6D8EEA84F
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 20:37:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E88616B0088; Thu, 12 Feb 2026 15:37:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E365F6B0089; Thu, 12 Feb 2026 15:37:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D17A96B008A; Thu, 12 Feb 2026 15:37:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C1AEB6B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 15:37:09 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6E7088AF2E
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 20:37:09 +0000 (UTC)
X-FDA: 84436964178.05.3074E86
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	by imf07.hostedemail.com (Postfix) with ESMTP id 527BA4000A
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 20:37:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmx.de header.s=s31663417 header.b=VBpH+Axo;
	spf=pass (imf07.hostedemail.com: domain of carstengrohmann@gmx.de designates 212.227.17.22 as permitted sender) smtp.mailfrom=carstengrohmann@gmx.de;
	dmarc=pass (policy=quarantine) header.from=gmx.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770928627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/uKmUxP5Dp5BE79FHek/N5d6tyvpzU3GY8ifA5cCOz0=;
	b=u3BUtsOaYM8UOCIN+ui5XRQWe76ncjb/92NWCHZqz0LM8jwin/0RcwwPAygLfriACOL5Rg
	slSBRRwFKTOAzItgXyaV360mm5bBb6Dh7JZ7HZZIr+a4oTIkw/LOeqYoBX7taK6iKzaBO7
	IcoWEDg1iCFXC2SIJdmtYhA6Ur7/mFU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmx.de header.s=s31663417 header.b=VBpH+Axo;
	spf=pass (imf07.hostedemail.com: domain of carstengrohmann@gmx.de designates 212.227.17.22 as permitted sender) smtp.mailfrom=carstengrohmann@gmx.de;
	dmarc=pass (policy=quarantine) header.from=gmx.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770928627; a=rsa-sha256;
	cv=none;
	b=yQ7KtwvPGQ7vBn+eYGvlRZtUole8+W+uQtNV4MlkkEOvIgzV8nYrVXYhfzGStOTFNC33UF
	j/vTiDv1zFsxRI5moJOshRs4N2310PggBTayBbvCoTkECWd0kgREjksRmxnw8SPyMAh+6L
	s84+cpFmSbGW4F6c4ZDXwqSST/2E4zk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1770928623; x=1771533423; i=carstengrohmann@gmx.de;
	bh=/uKmUxP5Dp5BE79FHek/N5d6tyvpzU3GY8ifA5cCOz0=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Message-ID:In-Reply-To:
	 References:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=VBpH+AxoJZQh+Eq/rSkcHm7LLhgdJPYLEXwoYTPznMuFt8/xAahSwg4vOccLdHqE
	 tKE91NAS0V5wzq6/1sir/umvAqAoX6b/YDIxRXBi4LNbijVPSV6mQ0RNIY7ucOGon
	 /TDk3ICrleXgIyiBvM9cxboicin37YObW9uILrKaZid3X4wVIgBuxB6L2plfL5VWi
	 ft2slni423GCkRaYOV3ypq1cHp1rf1SpJBvjiomPmHbSvQkcO2dfElbspLx6OJlWp
	 az94GH2GOt/NE/fOUcnotkojsQHbg54lHda2aQLV0l1g7ACg0ve/DaudVSDswE9oa
	 lE071kbv/SE9W6U2LA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [127.0.0.1] ([109.42.48.107]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N9dsb-1vlZEo2CFp-00szcf; Thu, 12
 Feb 2026 21:37:03 +0100
Date: Thu, 12 Feb 2026 21:37:00 +0100
From: Carsten Grohmann <carstengrohmann@gmx.de>
To: Kairui Song <ryncsn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, bugzilla-daemon@kernel.org,
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosryahmed@google.com>, linux-mm@kvack.org
Message-ID: <f743bc48-b576-471a-b679-28a792822cd7@gmx.de>
In-Reply-To: <CAMgjq7By=prRMh2T=i-T2cV3fZX+oE+YM0H4zHMXwSscnhbZmg@mail.gmail.com>
References: <bug-221055-27@https.bugzilla.kernel.org/> <20260206121151.dea3633d1f0ded7bbf49c22e@linux-foundation.org> <aYt4RwxqH1W_zHez@KASONG-MC4> <CAMgjq7By=prRMh2T=i-T2cV3fZX+oE+YM0H4zHMXwSscnhbZmg@mail.gmail.com>
Subject: Re: [Bug 221055] New: Hibernate image write 10x slower since commit
 0ff67f990bd4 ("mm, swap: remove swap slot cache")
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <f743bc48-b576-471a-b679-28a792822cd7@gmx.de>
X-Provags-ID: V03:K1:YZOduHGOyMmEejUvp+WDB5xV/xhme++FDFZydt9+cdTXJ1kokVn
 yRuI+cPB/A4GoK2Rk9n3vr6S+7emHixcCCh/8jaWHtwsm1tbpTjwhgLuIJjkAiPHZvtxf/H
 VkpJzejvICBzSuZZgVILgf8gbJ/6VaJi0taAdwxyjl6pdzp+BrhkNYyycQfL8zFKJDiZZZK
 EgEE74HPCqCBYCSfxIVdg==
UI-OutboundReport: notjunk:1;M01:P0:vU5HZiyRaho=;kVXuCQT6Gv92rT/0oxFzox4Ujil
 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
 A8gA3wO0bs+SOXmIbhgjqk7pK1hlCYlttgO+8q
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 527BA4000A
X-Stat-Signature: goph8kmppfybkx1i9w9ga557aprkzexf
X-Rspam-User: 
X-HE-Tag: 1770928627-431318
X-HE-Meta: U2FsdGVkX1+MNMfRvVKv5BQRdxeBN9j0ElMy7vO9cyfqYF46b1pV3bRe/FaPrUTGICtq/qvCNXSHXr8KOzrCtHma3Bk/vwm8uzKxrBgzbywQ4JF7YYHfDKrZbv/uch9+uAJiEVQnmuDWAb/75E6Mg+34Z58vr3c/e8NhZjUCHMQ9K5g85ZQLcQ2F51LrrbgRR6sMPjab8pBPriYZtgq/rTe2pxL2K5WVbsO7vMz8b3p+A4yyIZ6SMGYBTAKRUruChYFa5iaSzHF+pmGuEBaZhGyFsRBuh+HcM4Ze67BwWUIim/UbRvEdPHl+EhnLLvSsf7/aTJCBqrOISTv4LpBj8qf096NFD5ryFtz2KIZt1NryrSdDn6ohPm41zUCtTrK+NZsw5Db7cj+jdCnd1M3LLGr0384ouQa9wIWM9hjZXBm8DX08TSi7KUvA+bI1FCWiRHjdcuAht8yu3H82vJZ6cewM76358/OVNqh+9UlEuGBb7+6DqVFWl6xxOBzl5WiORxJE+3G4RGg8Z5LQ1V1gVQNx1rVkHvKTdN1KzOwSvtuP9mErO2nIiwbBt3vi25htjPEcRm02bD4d/CFQPQO4mPfouIzFTwpIe6vXHxesqjdugOzgm37cgJrLd4a+GE9J1L6VP2RyiPuX0DJP/RVUHANw1d0bSvxZOMnrU8EzMjR5wEGbyieDdZgpf9FA4Y3OjozbvMYudwH4tK9q10X40LKv9M34hmzcLhii7vnuVj6ci7Dde6lzKPMQLmXdY/1HH2I5Vqa207jhZ94C1z7+sO6FGTiceq/CGVOgChshtgEo43SIZaWNGFkVtTujrQydBIgOOS5oqPaaPUeq5XbZJz375l2JT2faN7HGSlsdo8StJB699bU71SM2FequrCL3pzqQXFoW2sG+AWze3t/+jOrXPpi6YkSpNY9oDEeeNpV4X4rT4QIzHducBepJeT/rw+aLbFBaq6SQE7GQY1U
 hqmiRpS+
 2NmigV3Fyek+99t84H8VwdKzoOhLydgrJxHfKlImVcWT0pnlyXPbO2I6wnqXqMfFZ0o3tMiL8WJx3fZ6T9oQuBMIIhPUyxqclvQvmhF5ON0EEVZ0Xl8sMgKI3GkmN1nqnTyhIbVwxwoCQQE9srjQjarujUjf17IkDGSqljC0sehfOnIkbDcRjl5ACU6r8T+QYJpThDoBwS7ao0P84BGpBJ9NJ2b/ywcAQ7x9CGjhSNxqA2WrWR79Mf3IAWIGhEAx9x9runEM9+1XYGv6zOSrmOQta2OLAyi7AgonYF/VmnKyUuypjhn9Z8wyzf2rEtPk9GGS+HZbfFUxUinRARzxvBceTTd0dqqMPqmzbNjVI/jrHBX80NgXVFnSXQ5kNAs5W10/jCsXMBnzVWGNjdroPFG/tNlXNf/qer41koqhi1nkWTBJT+ID9aw/lIBqusL+3AbQ0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000167, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

12.02.2026 20:01:48 Kairui Song <ryncsn@gmail.com>:

> And can anyone help verify this fix? I'll also try some other SSD later
> maybe that's only reproducible with SSD that have very poor 4K=20
> performance.
I'll try out your patch over the weekend.

> HDD should not be affected because the allocator has a special
> way to do HDD allocation.
I can connect an older hard drive to my PC and test this as well. Should=
=20
I do that? If it's not necessary, then I can save myself the effort.

