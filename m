Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 154D0CA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 06:56:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 162156B0099; Tue,  6 Oct 2026 02:56:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 139906B009B; Tue,  6 Oct 2026 02:56:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0775E6B009D; Tue,  6 Oct 2026 02:56:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CFE3E6B0099
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 02:56:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 40D6B805B2
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 06:56:32 +0000 (UTC)
X-FDA: 85291293024.22.4DB8F60
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id AA8B41C0009
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 06:56:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I0G2i9cq;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791269790;
	b=iHi6MbPuIF2ex8fjybq6wFdXY2FZ/ukrTIxkLOOBhpHcmzCkoFn93qY9pf+/4Eiu/vhE8Q
	xPyUU/eRcre+fGVI/g/ySb7Ng5CZZisHtCkXO5AYl1eVfQ3Ym+rHqVikfqj/DgxHLCPAHT
	7jvJkG9ZRla5OAYVL7HORNQ2FxPbmNo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I0G2i9cq;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791269790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2TrSGIznF7im8gcegltGhb5pwVxJVzRbP+0GzODKKlc=;
	b=toXLqYH1iyA1sIZJbgt9hhx9YsNDky8Ti8/66RgiXJMeUP0UgRMaNrNr8wJRqwi05MDO3M
	mhwaCCK0qdBy0v2nzdy3uVizh7mcKubFRxnIx/EY08L15cP2M0wL2pJHTeLqGU2fzZDX5S
	fsKv0TzI+sbk6U7EInGR4Kjbmegvw6I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 544FB60142;
	Tue,  6 Oct 2026 06:56:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 543511F000FF;
	Tue,  6 Oct 2026 06:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791269790;
	bh=2TrSGIznF7im8gcegltGhb5pwVxJVzRbP+0GzODKKlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I0G2i9cqB3NKuWApR6iaSzv6q9mWeKzdc63fIAyzU7olFj1n2Oi5rn8pAvPTfRSy/
	 7wI/+p35QAehJ9497fkMeU4VfutIk0IMj2REZ/mgM45ZNMdC12rbjQjyoBdJTnyK99
	 wDacEREJELrPGk+WNJiBPx2yil077Fzeuq7rspLT+Hs4b7RA5m0+kVk8oI3AutEMOL
	 /FXKiNDUgDOQi9gavHgJ9OgJ77FWoOtkXYwr5PENC4KxKmp/7MseQiMwd111e28A8v
	 Gj+fWIv7Bduj4120aFPafMbUb9qYvNo2RdiTJfv9WBu6mUDobPJ4BNIsiPbKLO3JK5
	 iwUJQFea/OCJA==
From: SJ Park <sj@kernel.org>
To: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	ahuang12@lenovo.com
Subject: Re: [PATCH 2/3] Docs/admin-guide/mm/damon/lru_sort: Fix copy-paste mistakes
Date: Mon,  5 Oct 2026 23:56:24 -0700
Message-ID: <20261006065624.42053-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261006061549.627-3-adrianhuang0701@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: as17t1oe4ufkeedhryup4hdhe8wnic16
X-Rspamd-Queue-Id: AA8B41C0009
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791269790-870820
X-HE-Meta: U2FsdGVkX19fMYmOeKDqOlO/wxYcZsfpe7OiTxLyO0eDUeZbNhEQNEiuAeCOfrgDnzJ0APTAcwzQP+UGgcVAIiFCvB3poGFPPHHCuNg/BEQSi1IdPppThs6seTdBtOl59KNH9tQmLFC1JTSd7+awItfHud50yQogeLAs05QINfjy/w7CmYqQetCLjy/Om6OV3fwRnRmgql/rSefdckRR/sv6K6TfA1JNxp8VTbwKPVJJam+fQ/IyciwKM1aCJ445H98xC5Gufpzxgy3WhB5HPml9F/V1DqS5LHbWMlXqtH3zR9nA2Ir5VjTGH4gus1XAYqT7OC3AsskY0Ug9AbikEEw4is9o07aZ2MkJ9RtawVGBZlIHUWSF5ph0dZthhS6kGgz4ddYQ1Qlkt7UrcUb8SQI3eMJu6e+zKAiEJLOLxul9liky4uZIzKnRBZ9HefcecnO02C4H0YmgWHXpPbOWffSoeZ6A4oNtLSESt/fucx2yipMf7PtLesY6tMN5lCpBTyC/lbUPN0K9aeGdk5AVzvfTzzzPBpIb72DfUDVCPOWU+2at53IMbETcR94nmgIMSwDNPBkDN4r3kdtB13TE9KMv9CDiVwzjIydehpJrr1vTnb91XIMPLDp3+Gw4ZMkHscrRYlBgOJabvwIa0M9bhwc6h1oQqJ1o1vrXZVlK7o9Pm1ZE2Pg+lmR63Oe51AnawORgTqVc8gCoD7iZdVG6bd360lRDAeMvozxuZ6Br9BiBBMasuG4+YAwYpegAmBoVnJ326MWLcTV8aQZWWn7ckfEXVYk045JUOxWJxFmJ2UiPCX1UKvCJbfdvCSdhCwS/Ncwz7yuc/lL1nKlPNBAkhEN2UwANNKCd5Vx1UndVWy0V2oGW3rxwxRvHcf6XGnkQ0ZnywCVX1bOkWrzGJ85pFX956P+7CYsYbs0l5wJpLtW27mfyRxODKcPWpQbyR2zRZKdbXIU7bAno+Sq7eNm
 yDk4zo5X
 TjeY1AtoDszqC9f9uKE3Kj9qvMMpxXHthMdf+zGTesgwSR+5i3fBE9RcDSb9ONJ7ie5HK2eOQQs8N74JkDqOoRhO/EDrD9aXSIQ5WaOsHLujbii/vTwqbpz7Gedqb5yIea+kRBTrLwhaZsOCabz5/oCBF0/2h9DYUl75cT+bK7NS47JJWWYxeRocip3RqFQRujAwQKt1OvQdXix8k3EGhb/vIKuXnkXCI0x2x1H1PniV3pry09mZtHPAdgyekpPfszFk/I664UlFiLvAApuDxs7BptmRJUsZcaJ4a/aoX4qA5PS0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  6 Oct 2026 14:15:48 +0800 "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com> wrote:

> The DAMON_LRU_SORT documentation mistakenly refers to DAMON_RECLAIM
> in a few places.
> 
> Fix these copy-paste mistakes to correctly refer to DAMON_LRU_SORT.

Good eyes, thank you!

> 
> Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

