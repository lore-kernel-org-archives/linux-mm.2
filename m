Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 325CFC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 09:58:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 722506B009D; Thu, 10 Sep 2026 05:58:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 683D96B009E; Thu, 10 Sep 2026 05:58:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54BDD6B009F; Thu, 10 Sep 2026 05:58:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 347896B009D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:58:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0B9AB40479
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:58:28 +0000 (UTC)
X-FDA: 85197402696.10.BBC3282
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6BE0A20004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:58:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XpkD3N2P;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789034306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qajx0Ga0bEbHzmdAduwUSL6GZ0I/Qkbf4UlI/1b6gWY=;
	b=dfMV/v4zRcp5s2yMB9wGtYuSZyKgRU9m1YLN7nK3zGlwapOYDPJJklHtpOous4ryYEMAwF
	SPbwMMsfl/NAJ/OuHcY1IoigyXO7t6Ty9t+CPJXTHExfjg9FQNbzVaLIi57Y6Z1MjMVBwu
	CyvvAiZB+ywl7mRq+cgAjx2vfM/NHsw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789034306;
	b=gLsVxa+cjIPfUC7pBSgI0TBA43Xvn/+KTy39FOK0G/69Nbq2rKhujg7GmbWTcwsj/9EMtC
	N175yWMgR6HpmDVfnZLg0aJztBM8ni/8sVHlCPd+oyAjfZPdO7+KAuTEkPmMYIGrHWdRvt
	FZZ294ZbrGJDc0RtgHPa7xqCaddw+YQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XpkD3N2P;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CFBC043D82;
	Thu, 10 Sep 2026 09:58:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD6B1F00893;
	Thu, 10 Sep 2026 09:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789034305;
	bh=Qajx0Ga0bEbHzmdAduwUSL6GZ0I/Qkbf4UlI/1b6gWY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=XpkD3N2PN5bV3HFCxvsyWxPYAhIOYCuKt/JRYfdPeoq8DIh3BBpkMm+JQ+DFnOXT7
	 TXyO6a+hyMEYot7PyOdCFELCHRKQcwzKIYJFqmxUmeVxBhW1Uqnt5Yi6q3HNiFOPRF
	 zeG+gQY16pHE21IS4ibNk0UdLh1MyUk7LViAyvu6hFhg0d05LocSPn6yffMdJ6SbHH
	 V4t8CZGMZ3n3wWjufdwKjQ5pMXu5F0Gmghtz2QrqktxEWge4L1QuFbiVLm3kqGm53M
	 IV28O1tsdKLhzxGbCJLhhKRiksz0EQWV6P0WpemsvJsFcHKgzEt8ujezOVkQepTYrh
	 LEeAviUGXrFww==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: linux-mm@kvack.org
In-Reply-To: <20260908165733.1703766-1-ekffu200098@gmail.com>
References: <20260908165733.1703766-1-ekffu200098@gmail.com>
Subject: Re: [PATCH] memblock: use for_each_zone() in
 reset_all_zones_managed_pages()
Message-Id: <178903430147.1489479.2162515570306846533.b4-ty@b4>
Date: Thu, 10 Sep 2026 12:58:21 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev
X-Stat-Signature: kynuiyhwdudo9zapgz9ofnnx9tp1mw3s
X-Rspam-User: 
X-Rspamd-Queue-Id: 6BE0A20004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789034306-63478
X-HE-Meta: U2FsdGVkX1+ScYpJ1hFGz2tKtcr9H9Y6TZypPmZkcJsjxF7+wuJx6+1XlS7T5lWQfqkD5TwF9GzS1K+D0tC4g2YtuIjQuj23EE4Y6rB3mMwwBCYViW7hYTvvqdioi1hfyN5yko+3X4dLxnp8ygeSmiQOuxqghbkFKaFMgmpkP8IqGwUv0uzCBL8134k/qiyDviJFCu26mV86jcUmzuChBg+Kk7rx8XmboDDOI/JHevM/vEsmnnylKmSMaEuciRp49tVEOk+EODLPEI9PHS2/CQswOCKypa6mMRwt8MhGsE0oDYcPKWO5XmCeNRyNk3TBqWdRlzs19MV5GzGgVOcMS9iGRMID5vkyIBnD2BzUK88E7lPlgdMMq6X0V8TaorpdG1tOxmKERK8kEtwdAFaTgc4clNeVBCLBIAdZ8gOylWDKkGRLeki60FzUz728XaaA9LRfYOplsgFCIont92pThOxi8wa5IXYuLG7EegRF6lcmErP9ROvfuqq2oezvHscyEQmjfywI0dhX7N78cbENBOa/MUmIsyHx5SEihQAWVMl5oAJQUZvPf5eWvN89Q0dxbf5VzeypzqH61L3mnfNGi6b8gidxar+LVat3o77opZO6tvk+ATaieW6svK+AuJHDTeOQxHGVhwTL876OaLt+hLirkrr3OqJQNk7sATBw5uF72B1fAGU8sHHirzY9GpYhQ4lmR5lra8pFgHJObP/u6gY5JJ1s6PosB4iUvQPUwneHXGklySXX2++xET3ot9MzBlDKs9YZenHz4pI9YBE6kGT7LdRV7NeZn42yQFP8AXO895tLOAjQyXraYch42rJs4k9IgN/r8M61ljZpUk336PD2WikgXx18UE6eJJt9IAz+kVpKKbcYuGoZI/bgJhWPN0FI6OnO6RhnFmTtLKXcFjkhU83s/xF5Ax1tVwZRG9qJxQDoORYH4yNR4LYLgw9lTTshhVQgPAFniiF3U9O
 13OubUvr
 XY+KYEb2OST+KA/8smgjhn4ZjziBWgA48PiLrbgtL2kZCb0HTFtmMsVp9cA+1Xx2EHzgLrjTnMNwU3KtDbV7W9AX3oLJKX2dRU+TRplyoE+uNicGLR+ik82gVWIizQJFoVPmc6iPtMxww1CzvFIEmjyeLHkXHlA3LpOcs5kwZk3M51dL6yubA9wEYpLN8Ab8v3MQpdgN0ZamA+LgIfX2Wqx+ag5XCntBGbaiy3JIA2C048eVphtzKbYzPCz5Jv98znT2iaM2WFHBaiNwVeuitjEdu0jPq6925CFdq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 09 Sep 2026 01:57:32 +0900, Sang-Heon Jeon wrote:
> memblock: use for_each_zone() in reset_all_zones_managed_pages()

Applied to for-next branch of memblock.git tree, thanks!

[1/1] memblock: use for_each_zone() in reset_all_zones_managed_pages()
      commit: 0876b2d8794913c867a1bb0dc3fd22ea1c5f0a95

tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
branch: for-next

--
Sincerely yours,
Mike.



