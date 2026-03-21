Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D58BE1099B4C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 00:03:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68A976B0109; Fri, 20 Mar 2026 20:03:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 662826B010A; Fri, 20 Mar 2026 20:03:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59EE76B010B; Fri, 20 Mar 2026 20:03:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4AA9B6B0109
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:03:06 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EF9681DD67
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 00:03:05 +0000 (UTC)
X-FDA: 84568119930.05.637A88F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 37E22C0008
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 00:03:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d44ms4oT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774051384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=25GyMLsrrMFj9Fd5O0kcQ9F8eIP0ds5IQjNnNZZGb3Q=;
	b=17R1Cs9xz81i/czFkV3X0OiucM+wN8PmLKEHvpZSZKwTUS2Yv/cyEABtezZOXTYq72TXnF
	fIhBpQ7ph2H1yIJl6ib6WZU/U3eoy6VS4Oy149k2CSp/HyWjd0T+HJ7yXISt9G+HD4DeaW
	+r+pydCUy9jGgBF+F9DJLdjgGbRHxAo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d44ms4oT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774051384; a=rsa-sha256;
	cv=none;
	b=K9TjBRd6KJqMncE1A+Aw3+dxv+9VTwLsu4sr8mCW5oAIzAyzoFi4e9xMVxEB4RmkbD2BEI
	tx+TWnueFy1I/BMAeZadWFPncfAyvFtg82JhMl1bhowESqh9saHOKWkG/maZbN2kcWZZCp
	5fG8eV1U0hgzTU52NCNT8LuH4XdP4Dk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0FFF443969;
	Sat, 21 Mar 2026 00:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7FABC4CEF7;
	Sat, 21 Mar 2026 00:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774051382;
	bh=ZhLgMTxTqhozNm1gYYPDnW5zUUjGgwMJlwUn+I+KLSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d44ms4oT/uU2JUEIpcp/yUVZBpfQpXMdi9ZJ0XFFkK2x9NaGIQMw8vtwQAGwNl/ei
	 ogVrtP0zRTwAcabz9UZqZXdp+zLoj/dE15Oj0tKtSLmAlwA5Iq8fvQx7m6j7xsyVn2
	 L3zuQ7tz/uT2cOh1n0F0KMEdk/eHr9B9cpEiP+s4/YP6R4I3sw1YIEZE4/Q4fTFWsM
	 u8h2HA0geOtqamWIllqzxaPONCdZqJlfN4hX+tD/iI9SS8gjck9j8HU1tT9jyjH1JP
	 7oMgN74R78JbjthoJjomlGY06+0AGOgK6Sd1pyrExRrdgaB+Gw0tVJWZfF4v7/6UhO
	 GtbzTGEau8vtw==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/damon/sysfs: fix param_ctx leak on damon_sysfs_new_test_ctx() failure
Date: Fri, 20 Mar 2026 17:02:54 -0700
Message-ID: <20260321000255.102944-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260320163456.177750-1-objecting@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 37E22C0008
X-Stat-Signature: ojpahhkqij47z4nccor9mguuj1fh84es
X-Rspam-User: 
X-HE-Tag: 1774051384-581374
X-HE-Meta: U2FsdGVkX18o4I2Q9yHCsysrqkgFo2yWPonTzY/kAbABTKtmU6/EEJf3vSUuaH/yIxMqov4OBkYLdRm0WAvqfkKJhbMS5Mt0crxoK1PyVyFp0qyQl6f5WEarw3yOivPE3BXjhmUgntLtqoeVWMnRnnfiNMVGYehc8tFsd/+F/cU+nkj9yRrhvJPZJAmuqzrBriaYQWyD26LD1O6xq/WlD3PZxucScZqXiKMJ1Zmbqme65NTdp6szc7+3a9zoUx7DRaG6IBrar8dyXRmjfZ2zgzrvJsGaAgzdhbYS4yNv6tvSPHnygqM5b9BpkfWkPfhVNHUQw8cub+gPNn2OQ6Fg89lCb9PqDmUgii+3ZtUUHcWYzxTJVIRj53GEa6pTLFGP/0joTu7jBTfP3AQKQj/uiXHVCtE1/Wxy7Pa9d4KBHR7cLL5K7cFclEr8bFE3MVvOMHQs4NuqamN/85QjZxSMTT4wDbwCsR6iDDEbx0rYrQLQktTY92IT48F+Lsx6XuWBWGOa7U7ABHTXAeKhlie3YZkZSKjHGtu/PVTN1BM9c79DmOQxIJENqqI6y8u+lOFtHbOpoPeL9te0RcAE8FuMFtvbZJa/lsRnz2+NlHn1A4+Aaa0joSp6xQiKbmInl1Pc4sNFZ/aKjnm8r7Q4F0toTUeVfJ147+MiJUveKGt0Kx3j0mtJqtbc0/cYa+WWoAs6ie1SaUcII3iRvDR79DpJqilLQSsS+sGV2L8vrHarFerwAntX8Lme1mHTadr8JI6lMiCRGPy85h6hG2mdN7nLWSmcZC8tKeg4LKg9xXx6UNQnU7/3/MRBD5x1CS2lr6PMOvBCETyW8GEut5WmIlYXEHQNMdCIxjuBe8BBhYKTgGNBeqooefwh31xsiQ3tzT6evdvHD4gXi6mlGbzufoL9i7dT2/36ctPzj+Algw8ciQKjUdDycIEAEH1jZfyG83B2YocMLFlZ4erJnRU9Omr
 3H6QrR4F
 qJ4AVbVH3NDGGcigvQpxksfyuPjkMqQuP0CXcAW/b5WhnVdZ8JcPQ1mC71eulFcSV2Tcf1z0I+0Yb9RDktNN/srkprr2Vo5DukVB20tT5H89fH/kfxUnZkMqNtVNMCDKWaRVhv2nixiumQLEW0Z5ch0ASK7OdOg5N0fsnSleIMH2ZDs3roy3HKMRINiRR5544fTJ2ohNFYWsF+Jxvf8UWNVLVAQEJmIfrLz0P+hcf8xfy+3WZiiALcMNPEdNU6VIeaogaYnbruHOGJrOxo1cL5Nqt+K+pxuY/ZsItLVaXGQJUmN9ZPNdmptFsstn9Cnr6QHDZxEzisy+XzccezFKNl7d3jAmNY1Oh0Hgkbe3U76ciBzo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Apparently this series is only by a mistake, and therefore a new version [1] is
posted.  So I will skip this series and review the new version.  Let me know if
anything is wrong.

[1] https://lore.kernel.org/20260320163559.178101-1-objecting@objecting.org


Thanks,
SJ

[...]

