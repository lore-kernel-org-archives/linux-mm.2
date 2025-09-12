Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B6DACAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 09:59:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AB668E0006; Fri, 12 Sep 2025 05:59:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21A8C8E0005; Fri, 12 Sep 2025 05:59:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BB9C8E0006; Fri, 12 Sep 2025 05:59:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E7DFE8E0005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:59:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7A8A1140784
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:59:24 +0000 (UTC)
X-FDA: 83880150648.18.ED71EAA
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5C47E1C0013
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:59:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025082201 header.b=Iv4suKXi;
	spf=pass (imf21.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757671162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wXwHzs3cuy4XVADNPAdl5sfqQoJprLOTD7qqu5IX6ek=;
	b=mYUyc5rs5hZoJ/TSii3CEQDaSV/DbfWzqjjl7QNgB2LR9mn/F9g5/kLxLk9yhKi2i+csm8
	SS0a+lxd2aNy9IqMXVYlaD3uFKQm9SvFdJ95iTMTnmd7j/BWEcBQBrO/JhPsrCK4bb4A97
	PM7EtI6BzZQ5fkGXiYWmVh019ukdBH8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025082201 header.b=Iv4suKXi;
	spf=pass (imf21.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757671162; a=rsa-sha256;
	cv=none;
	b=z2xxKW3RrxGu88iWpfddcwZ0vSvA6LGDOxXb5SRHrwQp7+BHkgX1fpcwFhWUZLjH0e2SCr
	ERd7GvPrlQh3h/bYC8JW4EWBgxWfVUsGuj7eFAqbHOdumO+23SGHIyEL3/QMMu5lRff99r
	0KzZanudjeOGAZyRHr6QBaPhZxQYxFI=
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 58C9wovj1383935
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 12 Sep 2025 02:58:50 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 58C9wovj1383935
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025082201; t=1757671132;
	bh=wXwHzs3cuy4XVADNPAdl5sfqQoJprLOTD7qqu5IX6ek=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=Iv4suKXiAxoLsxR2i11aAdvhMLL0LO5cMcs1CvBme2/ey9ISbE8mmgQ2f9bOYVhlv
	 2l1qElf6X9ZwESTueasD9/lDo017OlrdCm8f2y4ckj3NA9QXf4T5BYDKS6pLCC2hQE
	 8q+SZy2Dwf91S5hGoA2CP767WUCArqI8deJyBK171k0gbhXOuRszd/TpSl98B8Gicy
	 pmBmXN/1mNCAHsS+pgcVurnG5yieK0YeNEr4nImgCKJ7mZJmOM5odOCX4B0Ck3SN+E
	 blt70msFBUwxUp3/M097HMDT54EEYk5VaHutWeDlQ5yVo3/5b/ggpIM2UrfLYw+JHB
	 /PgINChn3uJzg==
Date: Fri, 12 Sep 2025 02:58:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Andreas Larsson <andreas@gaisler.com>, Arnd Bergmann <arnd@arndb.de>,
        ksummit@lists.linux.dev
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org,
        linux-mm@kvack.org, imx@lists.linux.dev,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Richard Weinberger <richard@nod.at>,
        Lucas Stach <l.stach@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@kernel.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>,
        Ira Weiny <ira.weiny@intel.com>, Nishanth Menon <nm@ti.com>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Alexander Sverdlin <alexander.sverdlin@gmail.com>,
        "Chester A. Unal" <chester.a.unal@arinc9.com>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
User-Agent: K-9 Mail for Android
In-Reply-To: <5d2fec2b-8e59-417e-b9e6-12c6e27dd5f0@gaisler.com>
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com> <5d2fec2b-8e59-417e-b9e6-12c6e27dd5f0@gaisler.com>
Message-ID: <E986779F-C7AA-4940-9508-08601EE2FDD0@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5C47E1C0013
X-Stat-Signature: 5xfzyw7ftp98f78d5tjqqfmc989d8i4m
X-HE-Tag: 1757671162-250265
X-HE-Meta: U2FsdGVkX1+UtmJPPIjYHcyyutC0P04HO0oktYwPL7danRBW8fe/slI2COqgWpNmnQNvX4gOta80FibgFWilI99YP+C4YSQDe5GlC2yg6VcjJYmMziefAfiAfia7m1GfWjyqe2H9BZizftgpZvbWz9sy4S9rgBPN4q7BzlxkWRbTFCivx3ntDAp0tahhdx5cS8Ql2O7vp+bTPim6dE53kXxZGD4vJUiMcRisd0PR5feMsSQPYaHwdJGo6tCZSllYR0HsMKYQ5RnCDTZr2ERdvlRg/eUC7jD+32CCvn+Ivc+XWE2U6O5e1b0S2z0Bs75TASTgNLAHFcbpPR/z45sCZd7DygmPQ7jf32ZQX8NVJPOVjNs4y2SziT9jWYSJJGb0C1Fm+cRlVg9ltczFjvv7WKq1QeZj2PHS7PP9k9RxOfITnR14Vwkq9h3A2BpXPeF78cNDB9Ms2JhyadyjNHQrUFywrrGjPELdN5wUYmoPTa1t9ycr5Xry9GGuMh9HInTdEWbJBVytosZwLpYC9gYXkRTiep7k44L9qT1xCyRV04VXY/wuqD4FmNeFAJFxwh5blSfbLJD+Ug1bH38vDYC+lOE8p2e/G12yoK2eiM6H2Cag9VNrENEbJJ+s8yL3uJIuWOqPT3wiMFPushZX8NrtcFA1tm99u7qB4Z1hOOvslQ8JBX4fYfHJh9qrI1XceYzhz1RPY2H4+iHMijD4iXoHIOokg6x9QthD6PAGHX/b8DZkhyg30WIGQz92Ff08IwAPupvY710MPwVKs1SN9woHc6jK3BhT6ywZFJK6IfGcGQiuLDJuzRmCT/mSj+r7ufu0Z8Z5EeUSQKaDeJwZpDSGVG4gpqEojGMvUKJ7Jf6FJkoykZyI+4eQxfYeABmaKEu5q+H4kQQNSKTBr9Evu648Y0MryAF484OZuuBoWQ334eOwNSm2JBcSYJtM27F1p4yJ6BpMjGyVLrzk6QO03lU
 r7xTW2gA
 diTupCWMi1jcksiwDkeWAbfLW1Q3AQpdyowE3tBxyf6qaY0ZOS48hhyKRKc9/MwN7PAXmpt/sAHKoZjy642t/Mg+/+EldjEebkJTU5lg7gJPfMDaa12hQ6JOsTUDKX2KXvM1R6dlkdZC8jkACVqt6qWugvqLw0LuEMHtBAQnH3YRzVLrTtpLJB0FAf7Hh0PzclpXE96MdLB/rEEkHJUTiXHjh+zj75fWQog7BvUOwS/94Ht1f9JcHpMVF6RfidmJ7e9AxeDLO3ODFR/De5p+4x/y/NjUsQutxgB/9YaUpA0SN+lJDdgz3X4EcxQfZwO4DtKQhYKb+dECcL/lQVDrhmbljSn7CxrY5MQRKzhaiszuG6mD5mziZ4HRmCe/15GUwbJ9fNOgfkTe8XAWAxcZMPN9la/HTFaHKMcpqq3utr/wRIJc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On September 10, 2025 10:38:15 PM PDT, Andreas Larsson <andreas@gaisler=2Ec=
om> wrote:
>On 2025-09-09 23:23, Arnd Bergmann wrote:
>> High memory is one of the least popular features of the Linux kernel=2E
>> Added in 1999 for linux-2=2E3=2E16 to support large x86 machines, there
>> are very few systems that still need it=2E I talked about about this
>> recently at the Embedded Linux Conference on 32-bit systems [1][2][3]
>> and there were a few older discussions before[4][5][6]=2E
>>=20
>> While removing a feature that is actively used is clearly a regression
>> and not normally done, I expect removing highmem is going to happen
>> at some point anyway when there are few enough users, but the question
>> is when that time will be=2E
>>=20
>> I'm still collecting information about which of the remaining highmem
>> users plan to keep updating their kernels and for what reason=2E Some
>> users obviously are alarmed about potentially losing this ability,
>> so I hope to get a broad consensus on a specific timeline for how long
>> we plan to support highmem in the page cache and to give every user
>> sufficient time to migrate to a well-tested alternative setup if that
>> is possible, or stay on a highmem-enabled LTS kernel for as long
>> as necessary=2E
>
>We have a upcoming SoC with support for up to 16 GiB of DRAM=2E When that=
 is
>used in LEON sparc32 configuration (using 36-bit physical addressing), a
>removed CONFIG_HIGHMEM would be a considerable limitation, even after an
>introduction of different CONFIG_VMSPLIT_* options for sparc32=2E
>
>Regards,
>Andreas
>
>

It really sounds like a self-inflicted problem=2E=2E=2E getting your custo=
mers switched over to the RV64 side is probably the best you can do for the=
m=2E

