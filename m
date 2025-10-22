Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AAE2CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 10:00:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D68C68E0006; Wed, 22 Oct 2025 06:00:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D411B8E0002; Wed, 22 Oct 2025 06:00:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C56CE8E0006; Wed, 22 Oct 2025 06:00:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B1FC88E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 06:00:18 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5FF3D1A076E
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:00:18 +0000 (UTC)
X-FDA: 84025304916.26.CBDFADA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id BD3464000D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:00:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf11.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761127216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vB9mXiKGH//ZjNPXu2UbFkQNzxkm6NBQrA35JISHdMI=;
	b=CzITVa+jrvv7VEO5mGUI+qYcZf9pk4mmtOslClv2H22H8xhtfzuhyG8vtjzBqWHmdq71Fy
	kEl3Gqs1WlZToi6fdcEir7OPgOtFzy25J3UTqdI62hfh59i5NfyIONf0/yLD1u9wIvhAcl
	EAFK3OQ6ndP79ipgoOiyAD7PYM8n6zI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761127216; a=rsa-sha256;
	cv=none;
	b=LfED6+RyoNXvC9j/uTtbHaJECdAoOfsb4NRaKZi1VjCgEiJO5P0Pmk2xA1NtW++VJNUvwR
	8wHRtJ3izaAVlGlzTVcOGU/It/zyk1dYlL8UtBiV0Gyu3wOuRrL+dOjbF3JwxEuHf5kp4r
	amer4dN8lE4uVKiwxxKnCX2FnVEFZU0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf11.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1783361D03;
	Wed, 22 Oct 2025 10:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D775C4CEE7;
	Wed, 22 Oct 2025 10:00:14 +0000 (UTC)
Date: Wed, 22 Oct 2025 11:00:12 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Yang Shi <shy828301@gmail.com>, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	syzbot+d1974fc28545a3e6218b@syzkaller.appspotmail.com,
	Will Deacon <will@kernel.org>, David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH] arm64: mte: Do not warn if the page is already tagged in
 copy_highpage()
Message-ID: <aPirLHXGEQ2AUzzy@arm.com>
References: <20251021181353.3842660-1-catalin.marinas@arm.com>
 <CAHbLzkpd8awNe=bZVv9fTux+Fx-HT8qL4ENZ-uC4YcPjf9e=KQ@mail.gmail.com>
 <b9520113-9236-4157-a4ab-fd6908f1b577@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b9520113-9236-4157-a4ab-fd6908f1b577@huawei.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: k4xqbgcmdd7byfs75c8gx95d3wbw4f7d
X-Rspam-User: 
X-Rspamd-Queue-Id: BD3464000D
X-HE-Tag: 1761127216-4940
X-HE-Meta: U2FsdGVkX19GnA0vDkX2fgzCVlMbpdOfNA6Zq3eBURijzBfdlrZ48/9NqJioEXpA5cNmw8HsTomIc934t+ABABBrJ6WhAJyXjsxAmnAaococAfqv5f4sNoJ5eh7LPsEExLzpi3ypEC3J+41mXPwajizTMsEgiBBGp+GxpxoEZjRVDC5w5AS4TLjLOKvRJ3lUkXuTKa4ICsvWkKhsBVbslIvPYyVsChVNMS5m5ugA5LdeeZH2B/5msbtBwk06FWlal9t6AgM1eqP9HEO6B/VBGrPv5b/UqRBgXnBMHic2hDJ1WP8uyAN+0MmN2lryQJWT/MEpn4o2/INRlZtoKBzhe5mqkGE+6XoMh78KGCqyBcW/kKjV5uKV9gHosZKEKSB38QXqm00fYg68FVwUHr6Q0fgrnvvaw3/a4njqhI0Qb9VMfTw9sKD0vpo1hd9sEV0QIg7UK6dGZ2wyFwAXQhrEFAb8GXbTnaBgqqedjsh+JpiKwtI9yqgjpjligi84xfmNspDmJuaKCwC86G54BwTV0chksaKWqXxXdX3LUTJrnXS6R9UJ3aivN9RecJnuzDHmpAFrfKfq8zwcQtjT7e1ESxTRwDm4BLXRv1FwNT+nEvDwUrlGx69Ug8cEn2RCmYXb7kKlEeAmPmlnlhYn88LJNX2EZXGbwppUqCbWHgBfPBAiY9eE8xUPJHJJaTqu0Fxlq348oTFWJ3Fqd6Nor/xtti7LWGLzknxrTl6PdUiGIoWu2MAd1RPtiikpkG2xP+W5NSegB0OFsgaPa+AcCcCrBOq2OYcrnmIL46yv/UkliQGV8PvtsNlB/4evcmmtecYMq0FVmqLPYOZoc5Rx9vsg5uHgH55AmeHPtameWYw1hyhIYXvKChr8ygjxGxsB00nOBIbMmsh/Q2vXP1kOFip2Kc5SctWNvXOm1eEw9mNKfdVXsfae87yM0JXkP4AuOEmknoePo6+OUMu1xB2QCkU
 IBtzEPyB
 H4qnPkiIfCgZn384D14qYDQ2giXFgbt/QPshqJOXOBN7XiBPHAUTWB34Ab4b6hygF6/yrwo5UFGuHLftdp3luc4qb6aJokExnvYUcFLshbvqN209CvDrLlpyq8sbvCxHRu9O6cWgkl99bLkcP7G4CKtwZPSf7nviCzkrU8XEV8jhiNCaMCPj/OLHgPKj0Rtk71os8tbONRmqTXaP9jWJQBebKTuioTp0ycxGQJSO6yHe+KelnOngyIMVWF/TKU/IEjoBwuvuB28wsiXRuHuYxkMZFjTyc/B1bd057nW4BPuB4LtV7wGth1lUOeKfgKO8SXUKnsCra7jTK8EJ/2yy8QzIq3a0uI/0H7Ps86y6vwKbjexO7CnTVFs+N73TmIqMmYtY50lSpKGnKKef/ppdtcCQoU6XRncuRKltktMITidvTBXxlhB4XoHpq4lJtLTnMGzEX6vK+lJlap/EGaHW7EOK1MefRcemI/nB/MHhEo/Iy297gm+KEBEORSUJsmbqqCSCUx7gVY2SzRIvaPFmahCbJPvf7GKd7nJ0O2sW1R1uMSg4FgC6GDY4kzt6Rhvs/fZOok4NJZgrtIBx+fui9qYVteziwk0HRlB3D
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 02:19:19PM +0800, Kefeng Wang wrote:
> On 2025/10/22 3:00, Yang Shi wrote:
> > On Tue, Oct 21, 2025 at 11:14 AM Catalin Marinas
> > <catalin.marinas@arm.com> wrote:
> > > The arm64 copy_highpage() assumes that the destination page is newly
> > > allocated and not MTE-tagged (PG_mte_tagged unset) and warns
> > > accordingly. However, following commit 060913999d7a ("mm: migrate:
> > > support poisoned recover from migrate folio"), __folio_mc_copy() is
> 
> no "__" prefix

Yes, I got lost in underscores. Thanks.

-- 
Catalin

