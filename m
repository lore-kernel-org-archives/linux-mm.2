Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26B04606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 14:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ItKwD9uj
Received: by kanga.kvack.org (Postfix)
	id 4E0F86B05B1; Tue,  3 Nov 2026 09:36:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 491B66B05B2; Tue,  3 Nov 2026 09:36:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A8286B05B3; Tue,  3 Nov 2026 09:36:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1DD6D6B05B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:36:35 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A1AB4A0436
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:36:34 +0000 (UTC)
X-FDA: 85394058708.28.D9EF55B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id F2838180008
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:36:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ItKwD9uj;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793716593;
	b=utL4qeagqZCUCyyXC5QD69GXY6ePOtgiwrUhuyVJSMgWXCmvxe1DenwTvrDu4++Vb2aN3I
	w96la1horkqmJp1g36d1UxgRww8L5VsebQCO4mHjyuPRK1mcRj2EioXViSCrYRryuzngBF
	3wAgeAAFGGYcIbCwjXiYsi1uBfI4quc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793716593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q+a2wZJ2Sr+Br++CEZ+cT4egHi/stEdo2N+elVI+KzA=;
	b=CWwWbCvowiaegdgP/BvBCnaYgK2Upn3YBIVWotv+QY5kpbS9kt/NFVeBgcaxgCHF2xsQJo
	MYXYkb9X/+xc+yl/hGh1YwtkWlvzdyNh8MHj/GFU/FrDi+A6jCR5l0j5r1Zs91T2J4OtQT
	0tY9yZD6eDO6e53fi7Kr074IgDqxzL4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ItKwD9uj;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F29440B82;
	Tue,  3 Nov 2026 14:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88EA1F000C1;
	Tue,  3 Nov 2026 14:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793716592;
	bh=q+a2wZJ2Sr+Br++CEZ+cT4egHi/stEdo2N+elVI+KzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ItKwD9ujotxRUWUD0Nc2COsYKT7zk/W3ZKPNJr43S8pe86LEco1327TT4io8rfgZP
	 r7uvqMI37FJir7fz/EHwmZuTkl+2jWBDJld8JrwzdZ5O5gwhAPdBsyluZefBXDytYO
	 PwE2/aXli8cWVmRj39WoyjYn/oJSnT3inm4MJDT+0gyMEpr8Su46eYDOXyc/3N3tCY
	 pNXg5uqGYrbtc+1DhSp0dx/5CuLPHQ7p9xAXfoeRZqhyd7yk+dO+KkcX/EvZ6lyvn0
	 33xJJ4nQC42lCThtXWFG6axQwgESejvl5ZVMcDim6Qdt6Aam/ReUceuMPby7AxoQ87
	 uUVOwCpTNmCyw==
From: SJ Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	enze.li@gmx.com
Subject: Re: [PATCH] mm/damon/core: use list_{next,prev}_entry() in damon_{next,prev}_region()
Date: Tue,  3 Nov 2026 06:36:24 -0800
Message-ID: <20261103143625.87764-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261103100714.70742-1-lienze@kylinos.cn>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: 14458pu6uszrbpnsgr4bjwozshzufkw8
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: F2838180008
X-HE-Tag: 1793716592-451867
X-HE-Meta: U2FsdGVkX1+huNpXyL0wJqQfgcF89mnibsNU5ynBuOhtDAVVYX2uUB/MgTxoDeJOJB+yDWT0As/QaaeqSM2f1buoQKBxtDGKUihlltnH7eGG5VVSJ6lHZM4xU+qcZr8HPgjw5M3t5LOrQrtSmZfzGqWAgliXmNkd7VHJ1ID0BexOf4JtZ780bZz5vcXrr3Ejhdvzv5J5dtp03FRKafUvGTHy4Yomqk1k+1ImW3Ux/XT3HH32WvCHUvnPAmJQCTqQTnjV2b66TULzTzg6x9A3kj7Xxz6RfQ3k7IR3jGqDCmMdfQ5B37wAWxtvnvKeeDH+SbJwZvCIvPrHH/vgFfM+luwKXIt02RxmmuNs6ERGBenQwW8Y56y8HpnWwZy7gMeMm9U1UpgmBbW5wRePciCm/X7puRhPhflP5ZuD3Q0GuWOlZoG4moZI9SIdRftm0QsfIPwyY4xgtgMceUXkJFDCCNS/Eav6FsHewXoDdVgnNeknD94HsjR27eVC9m+xcqlq+FMMp+Ag6HESXNajjqjafC1wtpHv+4oBAg2/IAsKvIjutjcD6aR/Eavgi5zArG+jHMGsn8kghuTbfHOsI46mYb7Cq9eTlnYL3cdbUWvqbLqlKR6a2vpNp1appTsscbyLDZHPB7KgRXi2MRE1LH6JSvdZME7RA/gRncFQf3DFSZMpVq/GhYMdmmRSvmPJ8w0u7Vt0nFd1zceUcby/WMa/jBETeiMpCRGSNge5/WGYZ5tZIcvG95chzW+sfsYUqf5FLAX/FEXbzi9Qt/wdS/ulQnyW0kCwHTV2XufKI/X6U/xAtpDyO/u1EkDU2BM4ognN8RytVB8diiVJaNbS03xhpom2sBg8l43olTxgAmSxmMVTPMzDN9wdVWwxtaZ89oEFVPlFe207DCw67Hn5BhzCRgptQChYh8r4+BTQySSaO4UbgEKBhw+P26aFERIz0Vze5J0Oa/18QrN9l+Q/uYJ
 p0zo1o4l
 qtkpBax0IzWR25ZrjKrmMflWhfm5NOgARkGWVEIyZMzP5isRyKDWvM8a8uGIowrAj3jwgk7eudL6MHaGVGf9z5Q3vKJ0e74IMXn3Ralg+HaYcPC9l3AhTqPi3Pp7L2F8FJRsOTiw4e2UTV875IejK/56eHbNJA9P2eh1QBNJYCHt1sfJ5GPSFVewkwsra28PsLJ0HJja4Z7mWkOfZ3k+OkYP8TMkDbDifID2+/lFp+mQ5/VlyqosgtFgUZHvL7mxSzIaSRog+2ihRsaSq1guHdNwf4GGbWQS5GyeQWBMQHJLMu7hINYHWZUhBGMenjoOSosrj5ttiKA+I6DvhjecBN/AdAtoBwu4wXXkg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue,  3 Nov 2026 18:07:14 +0800 Enze Li <lienze@kylinos.cn> wrote:

> damon_next_region() and damon_prev_region() manually do container_of()
> type casting to fetch the next and previous region from the linked
> list.  Use the dedicated list.h helpers, list_next_entry() and
> list_prev_entry(), as damon_first_region() and damon_last_region() do.

Looks good to me.

> 
> Signed-off-by: Enze Li <lienze@kylinos.cn>

Reviewed-by: SJ Park <sj@kernel.org>

This patch is applied to damon/next [1] tree.  I will repost it soon (~1 week)
as an mm.git merge request.  So, no action from your side is needed for now.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

