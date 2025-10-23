Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B25BFCCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 17:58:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCDD78E0011; Thu, 23 Oct 2025 13:58:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7E0F8E0007; Thu, 23 Oct 2025 13:58:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6D468E0011; Thu, 23 Oct 2025 13:58:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B028A8E0007
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:58:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 480885CF91
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 17:58:17 +0000 (UTC)
X-FDA: 84030138234.23.6A2E273
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 964C5180009
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 17:58:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761242295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nI6Fdd9M/ljBVrydhqfvwMnD/zDhS0cJ+5YJJ+zGUZ4=;
	b=S8y9Sjmfibx+bKrmqu6fGfXGp0LUNaUyeAGEBdy9UinV/6/kQtqflLlrs2OjUqikZrOByC
	vKXC9VTSVOKynyzSBDhJYlsFSDqh3O+kW4spnTwLSo44VrMXhPbtdmG3bSJ6WW6njFiXDP
	5z04HBSy/suN5yMQaxe80uJig49l/dk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761242295; a=rsa-sha256;
	cv=none;
	b=JGsXBaNeinLePsDK0ibikeB5+8G/T0JvUYnIIa9tlLAcRNDJES7bpxObUgTOcTIYqkZWKM
	hNZ7v+9mYm9ehKqWe9pplbpWgdlByCTMajdT4p/sNRd3HEaIz0w5kr40NI9s7oOhyE1OrK
	yclu29DfQfcAXp2VZPynPL3L35U3IT8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E7216116F;
	Thu, 23 Oct 2025 17:58:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14620C4CEE7;
	Thu, 23 Oct 2025 17:58:12 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>,
	linux-mm@kvack.org,
	Yang Shi <shy828301@gmail.com>,
	syzbot+d1974fc28545a3e6218b@syzkaller.appspotmail.com,
	David Hildenbrand <david@redhat.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: Re: [PATCH v2] arm64: mte: Do not warn if the page is already tagged in copy_highpage()
Date: Thu, 23 Oct 2025 18:58:06 +0100
Message-ID: <176124228654.947262.14709608501971650824.b4-ty@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251022101704.4015055-1-catalin.marinas@arm.com>
References: <20251022101704.4015055-1-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 964C5180009
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: gk3d657j1fw9q5c1pfsmazu66un1d8jd
X-HE-Tag: 1761242295-443773
X-HE-Meta: U2FsdGVkX183l8yxVIefsOEF3moHsybuPp2jUoKFRqfMEzSQebJ0V4p/08Jxao2IZY3hD0Otuc54W58uvx1UaStgoncQ73aBnNhTFkKl8hLL0+V2tyarmljVPJMMrdz9WzHu4rDM4pbOGr7udEo4nfqgzZXjS92z1BuMHToVhww9yJrloh12hD5Q9xoMCIckdrpIPagn3wyZKAcsBo0tCK7Hl/7KYFPcJbrszEg/J713GJwc6cxSHwLr2UXYYyTGkObnzgYnehIeqOawnm7xasyiIkbSq5WwVY/AL1JDMuYm6Mzh2bWDfXop9BWBVWNdxw9MNCodwY5WCQ+3yOXx/05wA1C/vHk2jhXiufyMT27rxoH4POQLImeBLT5DO8KjEE4d19RAVExITqiKxdit/MQNOMJmqk7hI7+A4ch5taM/ngEcS2KZiXW76DayqmIScfmLq0EgoZYYUASB8K4/FsTHAvidUhMd0nZxh7NK1oz/ziiF73T6HQPf0ejRaDrq/A4lzP4Sg+XYms678vEDXJQEYJSbhkMa7Jr99gZ0KIb+WCXe6fzV6rBxHHBI8NY1n3/xJ2QtGb4kw1HzwWtN/559qOsq9F/7hjQAoKAdgXJvNSPTmE8zDyLaHbtJnxHGnWCcC9E82ZIuao6cFCmW4KjbaOvf2lrTdEHcgxvRzvK++t82fO7NttPtsX4h2ofJ4BiTbPtX10KBLLFVHFnt/wjaXAR+2YWLy3UBDdeH2DWwXlek8nRR9KScpaeAdVfRoGak+3NW5WRxBgYX7CHpIhnkqhjCMD1YcB7cc41xXN/LhN1MvoQ7YcN6Bfgz5eg94MZP1SzsfB9cE5oKaI2HYIx/O7n5GP65F0+eJEGLIjWT6F/t9RzOBWfgWK0cGrVK80sI0VVL732JLNg1uKLrlZB8HKpyIjgihreZDR/11kDIYwETxM075uYiFSXQvFrczA8WpXDUItwPC1llXNa
 NWtabfqk
 PHvXsQ2fyA/Qg0qyqxuL25rbo4RUWj1PbZpYBZGEtHe7TZXxmLpS7Vivq4Eu9Y8XvKNmgXO9Mt4hZ5cHZK1Mwthzv14XQVu1Idr5MC2sP2RXzV1AT7ejxW3R2O0oxMBQrEORbusip3woYLmqEgFES8ieaYwU+z40AjtwYthFthfDjmu+IUrSY+PzNlDTfOmP7Ati1L70oz5LS4br12h2nVgu87M+1jFDLkH2Pp3c1mUVgmqUxlpV8XFGh5+N1y5U6+yJ3Gus4d7i3ukKBrSp3a7rIdcStf+9ZytuXowdLsyzIRhjJi4fTpqqhnicbwAMvxuxg4hmBB2mlst4G9os5PHA/Za1KMK1aiFvlBKCGnFdaVQCHMizuHc9Srh+G4pQaqbXV3bBmuO2ecwDDELbd0MsZB0DD0uHbaSj8uSoaQUBkmhMBxZYomOSqKW4xyKxWZKs+JftOkRggNb9TC8UTfOCThmFcK0DB7LocRahjYfSrun77XKLj/iMDqAfxSmV7qP4A
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Oct 2025 11:09:14 +0100, Catalin Marinas wrote:
> The arm64 copy_highpage() assumes that the destination page is newly
> allocated and not MTE-tagged (PG_mte_tagged unset) and warns
> accordingly. However, following commit 060913999d7a ("mm: migrate:
> support poisoned recover from migrate folio"), folio_mc_copy() is called
> before __folio_migrate_mapping(). If the latter fails (-EAGAIN), the
> copy will be done again to the same destination page. Since
> copy_highpage() already set the PG_mte_tagged flag, this second copy
> will warn.
> 
> [...]

Applied to arm64 (for-next/fixes), thanks!

[1/1] arm64: mte: Do not warn if the page is already tagged in copy_highpage()
      https://git.kernel.org/arm64/c/b98c94eed4a9

-- 
Catalin


