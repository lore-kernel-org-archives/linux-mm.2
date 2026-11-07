Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1D66606A32C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 09:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FGDnI9wq
Received: by kanga.kvack.org (Postfix)
	id D67E06B05B2; Sat,  7 Nov 2026 04:45:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D18D06B05B3; Sat,  7 Nov 2026 04:45:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C08A86B05B4; Sat,  7 Nov 2026 04:45:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9624A6B05B2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 04:45:14 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 273351402D8
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 09:45:14 +0000 (UTC)
X-FDA: 85407839748.26.ECA6320
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5951B20002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 09:45:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FGDnI9wq;
	spf=pass (imf03.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794044712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BlmA8eYzmWyrO0gOdWezWdA8rgwwfEDu++sldJMdKd4=;
	b=us8gyVOJu1fwQ8mFt7os+JEGO/6DWNglHT0dukQwiGZoyGBdxG1elCkJyQt8flnOuGpcas
	tRpFw0o/sv9lOYje4f62n07NY41RMJgmtYen6n6D3s0VkFN26gWrAkXBNYufmhcPLTD17w
	/NHQRvK6yG3WOmAxmSiVR81HmvAEFxw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794044712;
	b=flsBh8V/JwYgBaiRSsIb9xXqYZyaB0XCG2Gnrz+A63bTkPPQ8DCswxYSv6lEEJr4xfiPk1
	qKlK+a7xRLZmGIqH6gQgEzHyZg9BBsIWgkGjEAafbZB4z/6UmziWLFv90sMyiNfDu4gxUG
	ZSgR3uTZFt+gsD6yRjO4VA1EXVFzR9Q=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FGDnI9wq;
	spf=pass (imf03.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cc4c02ddd62so678128a12.0
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 01:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794044711; x=1794649511; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BlmA8eYzmWyrO0gOdWezWdA8rgwwfEDu++sldJMdKd4=;
        b=FGDnI9wqsLlOdyP3Sdk+gw9vVNHjXCBUpMcW2QINz7+x4kDGPU547bgRdFwm6djUKp
         gHVYNZFBDGMucusfV10tq6dyjd5FfJzZugifbdPYwUXVSCp+cR2QGOM8rkOtoxUqAzED
         EJoGfPLwcrC13j9LPI57ESGminEN09BB8Eb1Gza8zX7TRYtf4Z0dYiZ2bNaRe9yyLd2b
         T/NXwJVWzwOnif7v55XL3EzAL/XuIREto9ZjmNkcpa+IyaurJQcNQ5wv4Y/bH5ji6je9
         QmC7iRHL4KTLBNCsac6PAXjWoyfLTxsqG2u/07CVHMtz2V/PibDko3PzULzDshXBgSh4
         hcYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794044711; x=1794649511;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BlmA8eYzmWyrO0gOdWezWdA8rgwwfEDu++sldJMdKd4=;
        b=PU693BRn9v6mOyIUPITJIjccEFuzoudwnTiUzJyWwYQWxlVhpt4xzA6/Mp6ofucUBR
         lH5y446ufGwbx9CCgjXICWKXiU6SW4XExR/9XdQ/UpOvgAoqzIERAa9sU28QIkxPqOg3
         2NjGTYhyXZHqfEiIAxPY358L1KQEh21W57J/LFLxf9FEBaN8aY9DxYsCZZEw27JesE78
         k9oyAmkmKOVXuyG6mpugNAISReXc8S21bv5vuP6kwmh3KtjSgPF8p6S1Yf4YHva3BqY7
         BOIywB7sdXFkX78py5j5RwcD8DerrqJbgAkmzevoIrhRLnakvax7RXPQtowAcK5I5ss4
         t2mQ==
X-Gm-Message-State: APuU4Z+k0DCQIL9trpx0Mgcp59tqYw9GEz0RHb2/ceDBfTlU7Eociik9
	hePApYWarVIffFr1EycW4etAkWONtxy6yjU9wqMXD03EOgt9plRQ2BX4
X-Gm-Gg: AYBFou0izYGn1oZGNqpIo9s26pQDf6bT7Y5KUf9xdMU02qX1vLZzfYM3QA4w92ox4pL
	a8K5WBnDc/+sFznUbmFzYbPOwO+iaMDhPilznj/knO9leMLpVMrj66olh2Mv2CR/GigWEH0DMxZ
	Mpq3GntwKn1uz7AOGui9uAaQtnWgjNaETsCKOku38zmDMn2CN5HK40LrAcLIP8DFQX/eV6fENHe
	0G3v5JoxellrtpIwHcKBgsm+bMo6SacYqzNkFEb4duWTSXphu0lv5lWfsPR0mXh2iRblvXyHzvi
	h4tbSncE5L14XGMchwXDw/tQqtiblXd4B88mgYT2pqqw+WK/xfpgu31sS9glEhZjw/ZXKyFYMuS
	RoST2SfSwf2QrijDgooyAWAY2nGY32WWAGrgCYvDq9itY+fRBw7ibPh0Jh/h/jftVrftZO+vakN
	Uy6h81XKEl0C7n9rmn3Bkco3x5HDuGo9XHxNMbnGLEldMPP7l4bLD+7njGLOhN2aRHxEbEn2VUA
	ACwEzJdmIgOd+xb0dftLC2V7g01cItRM10Thtgu+VHTzG7wXIRX2XLGhonNKrT6TlMFamE33qy8
	/RDmdhN/rW/oRX9ylqG18tVjMfzeJlVS2WOc47cNTatZAs0LIMJyIV4X6fcudxYXrLb47A==
X-Received: by 2002:a17:90b:2f4c:b0:3ab:2d17:51c5 with SMTP id 98e67ed59e1d1-3b0db5f176bmr5147749a91.6.1794044710961;
        Sat, 07 Nov 2026 01:45:10 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b105817ce1sm2910093a91.9.2026.11.07.01.45.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 07 Nov 2026 01:45:09 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	shikemeng@huaweicloud.com,
	kasong@tencent.com,
	linjh22s@gmail.com,
	kunwu.chan@linux.dev,
	kees@kernel.org,
	gustavoars@kernel.org,
	tglx@kernel.org
Subject: Re: [RFC PATCH v3 05/18] mm/swap: change the swapon lock into a percpu rwsem
Date: Sat,  7 Nov 2026 17:44:26 +0800
Message-ID: <20261107094447.37093-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <sashiko-outbox-188134@kernel.org>
References: <cover.1793106426.git.lianux.mm@gmail.com>	<d7120017ded998ca722ed78e1995f0d1af82e88c.1793106426.git.lianux.mm@gmail.com>	<sashiko-outbox-188134@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z56fgkoyhx35iw8umdradtoy4yzq8ppk
X-Rspamd-Queue-Id: 5951B20002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794044712-88406
X-HE-Meta: U2FsdGVkX18Tt489N9T7Sh701zKdDZZ1n8GYY2/L+LhJSQwc2ldgMJZOE4vJsC3ELgdAJzyljRxFNxe6DCxvLQhAmcT0cVsoJeF03+/xKKugT5LkPGFM0zAi+933vrMOeuJn0IS/fEsLFlTZ7cJwYjU7LhCP2GdqxMst/ZKtN4aammchFU0XszKTY+Ogx5dLGtCU8LKWtJRzYHPSqSI6vLWCdGTGkkzjiNwTNJ9czcwjpbKv1XdQGp5Sqx7RnSBw9GKqORg7ri8BlhUFq1Cc8vUzp255kmUfTjCw8/E01BXvfqLIrkBtul9QajwfzfWAEqSF1hZ1CpUgbmmZzTev5EnhR24lU9hIjGUecZaEtYZ1Lk1Fflxj/QK7ag4mPAAbbHDfWVGQhtcHjri4ScuXSRO3MyH4BinzfEZomWawOdfZqDY66sLTQFzx5kQ4GNcMA4GnKZisjOj9aknb55F0GCaPOmLLQXEES077yAVdpl6IleX2A2AhPhLWmHgOKtZh9A+ksM7rpGsZqmWS/APXgalqqlDzbbCtzCbNqJYLBn+p7Ez58BRF1coDNNWkE9BSI5mj/Eg3vM1BUwq43TjZ6Y1v41q8BxyTBZdM3niH2Seeje8lcjc5wIsIidn5+NCutfqZkPsmD0z4AmcbsZyz08rIEHEdGNyTcpGhZUptnAIkYgaDQXoEzLPEY6zD7XEjXIslXGWJVyUsVPmjtE2XEXNUTbZr/6UMjewRaGhiu+WAALmOGoOnk0RkYnIL1EMQSjtU84ItwGN9THL3Q/ZaUFDCTOcfI0HHJlyLZUHJR0PEj1nFB/564vZsGW5HDUHyGZLDtl980K/P60YBbjmGn42irPPcWn5KREL8OUSp8pOErdIOgIai53YEgdryYtkv19go1wnE5azvjVzZvOf5Y+epxex0JKEWqESIpv/167JlMlr5rTi6HYDrTX7+t3MG/7GX+yrl7MrjAQ3g7KC
 WtCb1k+O
 0ZMGyZQMoS19qsRyj/5dv2d70dp7VRc4ZqH/KKrxsEX+7dPcyOppCH8j30TBKReUfGJdWHwugXaUhznV0yoiAAIa5QHRel6MSy5PaLMaNYUPF38yRAUk1IUaI8HIKq/myK2xPtpsSrFD85GjESlsuwIVhPvT6iGjOMrR5rynqR4k7oBC1MQzyUdyWOoOFKgbDTyrGIEuNPRkg4o6acBAHfeJIRa2p/JK3Yo2a/Le08b+OZwkUSeR3ijSTmUbRVOJ0ORtYobgBvb6Bp6GRR21ddmPFMmg+BO5dYxobwvnr/ED1qUd+YTLTqrvPooUYcETkjrfpoRx/0hnMyzhvk2T7PNM8GpZM2MAJ9petSYm8NLiEwVNQcfC4H3YqSU/IYkw2PXoUYYXnTVHVdjGY+BkfJW+IKB44+CV+x2zDDXadQRMGAMHXIlUWnF4f8DehJ5CeFMWg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 28 Oct 2026 16:14:56 +0000 sashiko-bot@kernel.org wrote:

> cause a concurrent order-0 swap
> allocation to enter an infinite loop in cluster_alloc_swap_entry()?

Yes. Clearing SWP_WRITEOK while leaving the device selectable opens the
same availability window reported on patch 03. I will restore the atomic
flag/off-list/list-removal transition in patch 03 and preserve it through
this lock conversion.

The device-selection and cluster-allocation paths do not yet hold
swapon_rwsem here, so merely moving the separate operations inside the
writer is insufficient. The transition must stay within one
swap_avail_lock critical section. The synchronous-discard fallback already
takes a short reader, but it does not protect this earlier selection and
scan. Once patch 10 protects allocation walks with a reader, the queue
mask must also be complete before the writer is released.

I am keeping the underlying scan-liveness guard separate, since an
allocator selected before disable can encounter that problem on the base
tree as well.

The final revised tree passes the targeted KUnit scan cases, including
the disabled fragment scan that does not complete on v3. The earlier
availability-lock boundary has been checked in code; this guest comparison
does not execute each intermediate commit or the syscall race.

Thanks for the report.

Lian

