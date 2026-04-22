Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCC50F94CC1
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 04:35:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAE806B0088; Wed, 22 Apr 2026 00:35:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5D3D6B008A; Wed, 22 Apr 2026 00:35:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D75156B008C; Wed, 22 Apr 2026 00:35:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C82BE6B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 00:35:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 88AAFBEC3C
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 04:35:22 +0000 (UTC)
X-FDA: 84684927684.17.5BE01DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id D9EA6180009
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 04:35:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P7iEnDsY;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776832521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KV9rAtq/T0lix4Cblgpg7zzg7+56SAGTgAWeagfbVvw=;
	b=UqovsAO/pZz1i/rXwc7sSlzJpk+DK/dKX95FojxEs1DOGIGX/ICh7K5qz3JlAEwRSmAJzS
	nzDD1AUBVYJHnaNwY9LKjseiWGofuZ2y1Sovf84VkFTRl3c4YO6252YxLhJwkq2C1i+sAZ
	VpZBbMJm8oHiXz0ttJ8soM+u+fSrv+k=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P7iEnDsY;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776832521; a=rsa-sha256;
	cv=none;
	b=4AVH5J5uorthyyHCoJmtNrhO2qb4qknZUlYXJjkbdSXF7iIrLQgXj47jQ9F2//O3nEUQ3B
	0QgyZJjnqQoj3GV5zOcyeStWDixAKy1i66A5u9aduOVZmJqj3RTfgD9Ep777hdRjlRJ0Ia
	jeoxUON0XcVYvQTXbTu2ulnz7XSMyy8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D3F5C43CC7;
	Wed, 22 Apr 2026 04:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71BF2C19425;
	Wed, 22 Apr 2026 04:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776832519;
	bh=h7aRfzS42EkElr2GaVorlivQS4yQtChao6czjfMEwyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P7iEnDsY5RMSecQ3rEatP4xUzPb3pPMYWcFK5FCe4RN7KROzBL4cqfOK3p7jZ11/4
	 mnLufX3fl7Aa49dvZQiCvypuvlb3kg66ac68fvgh3rw+PM0aAE4moMGuDNVkIEJ5wn
	 SKpC+va594fXdXnwu36qGNe0G9QI9+5ZmnbCSZyIXbQJ6S6KAF1fRCm8e7cosExI2x
	 HWBH0uftBp8YOvSfTsdmpWIZdYwu/SJqwYKoGpQ82smB0dKiC/Cnsqv4sF3CaDSQvx
	 c7RXLWmTJXcJd4diCTWhjUZAokEbHOEc5jerjNHTXTbKpQum7GPkg9nKPiKLhDOHsi
	 UiEJdv7fitWsA==
From: SeongJae Park <sj@kernel.org>
To: junxi qian <qjx1298677004@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon/sysfs-schemes: fix use-after-free on memcg_path and goal path
Date: Tue, 21 Apr 2026 21:35:09 -0700
Message-ID: <20260422043509.66755-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAAkLyHRCUS7=YEQRrLyRXX5X10pHDGA1e2gnKQsLvGkcqUy2Ng@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D9EA6180009
X-Stat-Signature: acix1tw88dbx3cppdnj8dpyaxyz88hsz
X-Rspam-User: 
X-HE-Tag: 1776832520-644823
X-HE-Meta: U2FsdGVkX19GPmtNwX/i2k/FGX/Is1K8R//y4PSoWKb4vbGNQyeScu6Ndwm2nlgRiUVOnPYXiZewIjdWx8NSktVeot0CK3KRKOQQ1jjMcAPZvEUVvZLGBPYI/R/zg1pRvyOEYz55BnpQpnA4vR6EYK8JjB+c9nr+SsQFG7qbzbfA71/VqX2b4aVSBa84uA4LiGaZuEespLrgJOX/Wdg/SPs9JnXIbM/6ufHSXmpJepFy8Ah9TewoVqATpyJNDa0J3QFl2TYIab7NFfsxwfz865UVbkmw8kwX+XOf6glNVNoeVgfwKKRKHx7mo4C5+pI5GHbHqYhZgmUa1+nUE32oVuAmrI/S98jlrE2t+YZd5OBMX8+Q6oSRXKARh+z1nyRHZUBmcmrjJ2i7PYGS6VSc/dAhKwXGE8IUhIA7NdwVMtM2eAgXR+p6LLRPmly8SrmMkWw9S6XifTdE9StlyOvo2VXuKhjEGLL6lh0jjGLy+Cv2ZrNHxAwnoJYKMS4HmD6jL5eiEFnL1XpN4slT3kD8nDu4wip35niTxeKLxJA5huTYFVrRbrevcV3ZpKHKp++oLlnSodoAfXLwlzCI9ub1+ZXOWb1uO40GJMr1cwr2NqkmHMkKhMKkmngOZyEl44HBVkH4xV2V8plv7ArZy/KMgpEyh7m/ZWi5waoKoJjzRUVn5CagP829/GmWn+1ULvHsxVvvpX5BSF/Wsxh5b4V7i3MkgC0RV1MynyG95oYlOgl0WoeHYpphCOpEE/Yk42dHOiBrJvXbwlfp1R7mLFB7bvKy9GtF0hDvyGp3BdURJ5zl3fHce6NsVR4DTLrmyqGqz/gOjxzu4006orz1Ao6NUnaJSzN8yV5eosouZyn856LGZVZjM1bqGp/evtujX56ZSyhUpdUmGXSAywDNcvxjSKhRoH5Jt1gm9KKd+OHlqCtg/UJjQyN0fGvot/MnmTKEabwE4FLfQx9mjRmMA0M
 RuS9BfTI
 aYy6lc0Elw0nkWKodBlzXArXSME4yaqB9uQsbULGMWqhXt0FnAyIKlw/XYLZZGkUt7REgNkMVZpo2XtYsh8bAiODh3L3yBydYUasgZ20/CU8lnx08aK2oEgKb3aS9WpiwkSYCMd2FKdWNV4XFnprR2SjelVrHEosFZdgpLsi1YaPySJxNQ5dlpAcZUzzH2WyqMTGT67FGuGi5IkH9mIs5MveZ0Xh1i/LG92UK0JrwGjjEI7fAnPcLYaRsoMkHSDrJvKpLF9YyOnVdWSBmwcVqIoZgQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Apr 2026 12:31:43 +0800 junxi qian <qjx1298677004@gmail.com> wrote:

> Hi SJ,
> 
> Thank you for the suggestion and for offering to help.

My pleasure!

> 
> It would be great if you could finish the remaining work. Please feel
> free to add my Co-developed-by: and Signed-off-by: tags.

Ok, I will.


Thanks,
SJ

[...]

