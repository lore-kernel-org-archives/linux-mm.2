Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DC16CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 19:37:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D3028E0005; Wed, 10 Sep 2025 15:37:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 683898E0001; Wed, 10 Sep 2025 15:37:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 571A78E0005; Wed, 10 Sep 2025 15:37:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 41B9C8E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:37:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DFFB21601EF
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 19:37:43 +0000 (UTC)
X-FDA: 83874350406.08.EC94D8D
Received: from lithops.sigma-star.at (mailout.nod.at [116.203.167.152])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9264D1C0006
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 19:37:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of richard@nod.at designates 116.203.167.152 as permitted sender) smtp.mailfrom=richard@nod.at
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757533062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kvy79l38OjgXam56LG4SBUALLkxIDxyLLpk0bImYB5k=;
	b=ay/BslhBTqBbXKZewujXBcks5WhNCeuh/ZR583jN9fxOvC+QNe9yoalc5AEBLM0dtkhY5r
	HQH+6pq++BrzAGeMnuE8NfcLW/BsCS9qtsxkmrE+ECfo9O2B2dGUWonNaoS+AKMR22z6T+
	xnyRdQKStFDQyEZOwRyE+rkKFtvrHZs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of richard@nod.at designates 116.203.167.152 as permitted sender) smtp.mailfrom=richard@nod.at;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757533062; a=rsa-sha256;
	cv=none;
	b=RY0k21VHc8s/BG1mll9vNPEcyCXgHDd7lGyD6fsPCm027aEJgRL/FbzTWQ0Ly9AUzojlKu
	9VD2pcLxYMke/SSxKgCbe6YvZ8OAjgqXAllwkpgoM4J/kIFdsj7qThMVDaMGaeBMYQ8g+f
	FzWNmi4+3Xkgojq1Sv4OkjYIQuRdJxs=
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id E33972C14AA;
	Wed, 10 Sep 2025 21:37:38 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id mZ4QcxbfF_Ic; Wed, 10 Sep 2025 21:37:38 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 274732BA98D;
	Wed, 10 Sep 2025 21:37:38 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Q1j44iMB0ybE; Wed, 10 Sep 2025 21:37:38 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
	by lithops.sigma-star.at (Postfix) with ESMTP id D9D02CE340;
	Wed, 10 Sep 2025 21:37:37 +0200 (CEST)
Date: Wed, 10 Sep 2025 21:37:37 +0200 (CEST)
From: Richard Weinberger <richard@nod.at>
To: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Arnd Bergmann <arnd@arndb.de>, ksummit <ksummit@lists.linux.dev>, 
	linux-kernel <linux-kernel@vger.kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, 
	linux-mips <linux-mips@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, imx <imx@lists.linux.dev>, 
	Lucas Stach <l.stach@pengutronix.de>, 
	Linus Walleij <linus.walleij@linaro.org>, 
	Geert Uytterhoeven <geert+renesas@glider.be>, 
	Ankur Arora <ankur.a.arora@oracle.com>, 
	David Hildenbrand <david@redhat.com>, 
	Mike Rapoport <rppt@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, vbabka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, 
	Ira Weiny <ira.weiny@intel.com>, Nishanth Menon <nm@ti.com>, 
	heiko <heiko@sntech.de>, 
	Alexander Sverdlin <alexander.sverdlin@gmail.com>, 
	"Chester A. Unal" <chester.a.unal@arinc9.com>, 
	Sergio Paracuellos <sergio.paracuellos@gmail.com>, 
	Andreas Larsson <andreas@gaisler.com>
Message-ID: <1586788245.22320.1757533057730.JavaMail.zimbra@nod.at>
In-Reply-To: <d9caedb4-41c8-4ef7-99b9-51d891aee555@csgroup.eu>
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com> <497308537.21756.1757513073548.JavaMail.zimbra@nod.at> <d9caedb4-41c8-4ef7-99b9-51d891aee555@csgroup.eu>
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF141 (Linux)/8.8.12_GA_3809)
Thread-Topic: Reaching consensus on CONFIG_HIGHMEM phaseout
Thread-Index: BY4xIXfJeETYMNF0Cnq/68k1mYFqTg==
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9264D1C0006
X-Stat-Signature: gwdesktdox589z5pw6t64frhj1azkocd
X-HE-Tag: 1757533061-689798
X-HE-Meta: U2FsdGVkX19FmvpEMALkRFLT3ge4bflDBzXwXjBaCmdB4+IZx/2w5rUke3jVU39guH/Y/7UjbZi/SmrLaFLo2gA7nALZ70587/zFW8abacP7cwiBHhQIYvgtLpGv4xW8T871DykxUvCGimIrQcWSpYwVfNHEc21JadLZlBxGWYUfjGflnaYxXn9HRS2+6qbo4Ib0W0vBFkFrU1bD06nEhR+SZ2k3Z/aoSL9EjiF79IANLKeuyrn9GdOsSHm6ls8HeFsk5Oq1uoTpDfAweIb80EigXz+4aMPbr9TkQBny/pEoehnRlXdDiEVWM3Ev9TcDXIfr5Te88selC7Mq4KCaVnHbjPxnol0iveT6Fd5ZSlNoOx0pRbE5i+FBY7inw3BohXGfX1khidL6wVRZOxLOPVA/ftn+BVzhtlXzy9peA55R1JMD9KNY4str67ZmbdWo78qc2tXqd0zhe8cLkkSaMVo7huS2QPjSzH1mwFPodRF5nXVr9uOi/D31RVSQeDrrpj/Zc3bXrqIOUEsA4Fl7gFZyYnOB65sKXPpgJZdCKdQuIvVD1jOmvK8dQAeJ6BBRr5I5sivA9t4I16xN41ynVcRQ1NSFkuJkB5FzsGJBAXO+68dpV4PcmIhpPCgSODFhzDL7jqXsyiJoPsVENT8uf5BbU3yuhaF5nl8gH6g/X9z7W8fE9HzJlZOvzE/SD+NJ68u+ZZGf9OiM980bosMi3rtnIN21W3YA4EJT4jxoXN4cCPqrLKadZkzGuBNmeResqNt353xZs/f1MiHSJgwZmram7vCpb49Dl/rzSeqRVzkAFzuMT5H5PUmNVmp+7RPRkF/cqaGbv8SgZtR4vGg93qbyzagT+YBSp+ClC6pZBey21w1On61YyewRqzRws7faeUdoVo/MtvO/o+g1zBsmSgywyctJoCFhjuqxRJm5EG6hfPSSq320P04aJT5ZRv7gH97f+rhL9nt4AvbQqXl
 mLnDWeFe
 IIbOZbTtlOBvTpLm2vClzgWs8Tsvrd++ikojXc8mhvvPzXp0Mu7TcaCvgpdWgbjl0b/N388Q4Kgm6SThtZJ3rCCAbrQOPS685O+GZJobMVPDOZnEWiDfHDf5cqY/xH/sZfIHCs496hKafqX2QEjLy9irLx1w9QKgu4yG+RiLnI58DqY0wGCPf7gESvO+7FzXzSwJuI8qKdknCVbvGYe++c4wj9c32gs4KTyqwgtD1o6lzKRALuOA7E07KK2VWb5GCyaDQH1q4cMWvym6z5VilKi4XI4Tke75rdq8V4lZYHiFF1nIM9x3HDrrIXcvwo2ULv5EJgabdqi6vTx12ymvcJJO1IbbkfnngpghRcLSIOQT9yuxrbFA1jDA43Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Christophe,

----- Urspr=C3=BCngliche Mail -----
> Von: "Christophe Leroy" <christophe.leroy@csgroup.eu>
> Can you tell which PPC32 model/family you are using ? Is it mpc85xx or
> and/or other variants ? Maybe we can look at keeping CONFIG_HIGHMEM or
> find alternatives for that subset of PPC32 only.

Off the head, MPC8343 and QorIQ P1022.

>=20
> Could you also elaborate a bit on the kind of issues you forsee or fear
> with applications and FPGA device drivers.

Unfortunately, applications in this area often make certain assumptions
about the amount or layout of memory. This becomes a bigger problem when
using FPGA device drivers of questionable quality, which share memory
between the kernel, userspace, and the device itself.
These are mostly out-of-tree drivers, so that's my horse to ride,=20
I'm just mentally preparing myself for "interesting" bugs that will need
to be sorted out.

> FWIW I sent out today a patch that removes CONFIG_HIGHMEM complely on
> powerpc in order to get a better view of the impacted areas and allow
> people to test what it looks like on their system without
> CONFIG_HIGHMEM. See [1].

Oh, that was fast. :-)

Thanks,
//richard

