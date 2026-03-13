Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2816E105F7A6
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 14:52:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66BC16B0088; Fri, 13 Mar 2026 10:52:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EF2B6B0092; Fri, 13 Mar 2026 10:52:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FB036B0093; Fri, 13 Mar 2026 10:52:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4033D6B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 10:52:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E645887632
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 14:52:56 +0000 (UTC)
X-FDA: 84541331952.25.A923176
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 43F2E4000F
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 14:52:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=le0W763n;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773413575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cCBZ9IgiIaPlQAC9YvT3JsIWr5CPHgICxQ9tcOoFEcw=;
	b=xdYRwllEHmTP0fJD3UqpQKe/cZMytxByPdI2y6hl3N3rxUmRHoyXEM0dr36yHg/IvRSmKV
	M+XQg/JJI+Mw26U/8w2kWmGBmzV4gTIlgUXlO5NLxQOBcfAF9G7iP6ifLX94L7lGIu5/RH
	8M0UkIBhYTxXtkY+pCiC3xMAT3thCQ8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=le0W763n;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773413575; a=rsa-sha256;
	cv=none;
	b=kHT2AVASlwbK12YlWG6kGoY8D/CeCFUB7zXEUu25sv/iP8SwK5kQ09fFkALTVwHaAJ8Erg
	6DFmGcSqdpHunioMDH8DBPfn5au19HPmSz5QKuZT1jUZ+SbPpWrQZfVjvyKPp4GsCXoPew
	Oop6+SsU/L+XtJ/x0o6Ao+Zf44Zr/AU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3FF4141766;
	Fri, 13 Mar 2026 14:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05CD6C19421;
	Fri, 13 Mar 2026 14:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773413574;
	bh=9+tBGf+6qW8cNORLO7JXvI2gClOkixsr6NngHAxnwk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=le0W763nuZ3pgJhbKOvzX0P0kwTYcR2NhqSh6SPGWMp8Wl0f4PTOagjwDs+W3lUrq
	 qAe88u12T/megxzTjVQdzcF1kwg7fRZq/rVZdneVsmNKlRdIxLhAjlzMGDyBd646Cx
	 LHhEzfbANCIl3KXDttBDCDx508LcKSVJ7erwFQT9guUY/B0Kkto69BEmvBo3NB3FSH
	 TwMNH7l5bke7YUuYv5x7MC1NVyYXoYEngCv5DVTJVXUKZTtrvtsSGWtzvwzSNy2DIj
	 f+cFJh4GJ4LcRLK2kgSuidajFvPF1sf3Jb1501butKP6XDOWedVnv5J0GLiY1CY9l1
	 uLBHTpys4umNQ==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [Question] mm/damon: conflict between DAMON_STAT and DAMON_LRU_SORT?
Date: Fri, 13 Mar 2026 07:52:46 -0700
Message-ID: <20260313145247.46643-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260313111702.38667-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 43F2E4000F
X-Rspamd-Server: rspam07
X-Stat-Signature: n8hj4gmkr9dsethsue1hapzbrbfzh9m1
X-Rspam-User: 
X-HE-Tag: 1773413575-940919
X-HE-Meta: U2FsdGVkX195cASB+9C6QGTryqf4m8JQKDGCgXanqUbpTzB59M4QAsqPhPOPylW13VcbwXTsI/NDbeD2Ho4mIfqjknH+KpMFH21oY+Lmmr1U0ciCbTt3Zumr1VoXrTyWZgg+pINC3s2PhbXHteXTJ6mngxzF7/r2YrPCR1dFDb4+sEyCuXSL2H37D4h8WSZEzHo4VmZ2JP5FLZx7yNqZRvkJ2oaIuHKOvMe7Tuy9hlwyBladqc6qAuz74khBokg6jM01mgc1Rf3Z5VhlXpzZVHVNd0NPsP59kEjN7+tDZaKHLS5Epbx5sv2rKevpUu0Ih7J34J24BRxQn7AKeHjXShiC1Iqi/+K94wZC0n2jlgsb8/njmxO7V10oysaREyVt+TxPRUKrJlUslfNaUYBfZ87HK1CzqZFeUWXTw+Hm4z7htwy1I1cVoAbSchq2C2aXHLXbIRjnO9NM86K7WPz+4q/g2pi5xjUA8RmSMixN6DL0BnNPlQ+biJ/AWwPUg6arVn5/XVCOJl8aDSXtsKc3L2iQlFIgCYdd/QAg5JJMlKMve9fBAKuy7Vt6XIUTF1ftfhtvts4O5lMhn3Perh3iJ7wMdY3TlEQvWe1zHeLzgtAGaW6XFSJkcFjL5MVZy05JyBYwsKOoP/0f6T0AvnXayP5jaVM7GfbXzQuGymuSVGGoSCaw1ecXIpPwcdqtN72bTF95MGTHw1nhdCdvXhFVvJ080L/XzJ4IzU9RrJhgijvC/LARux8uuxB3Z1MLsViVth35YgEnSVPelQ15H9QmLHCsfl8+NjBWkBTlB42Qp/bitZGz+vE72i/tf4HpRUAWGEF8vfk1JwzexGDnUK0cDEn2xOadbX2xhfmWICoUYPwuQCXwZnLpCaISoiGTuF/MXcE1LmbK7/1xZ66GPervkAXYJhZzm065p4Cw5IlPvJBxIOhconWZQSGOeqEh5/auvWtHBPMx5I44igIQGVy
 I7MBerrB
 b0zaZSz3FUgfz9HUfFejeJiPezbki69H14Jri7TH2PAM+VtX6VJGYCp1UHoVUm+KjzuLOayfsucQ+SZ7daVoUmC+NXuZYDYuc0Rl03FKW/6quVbLkCevceA4IaD4VCbgFdKA1LcUhJqBN5Ay1cDD14CB3lPV3pmeN+EbZK3RsA/l0c9Mq9jOvTpBoVFgIQ4b7FDN3lpkOfd22AyRC0pyE+mcxaOB/gTM6zjwb/OIC2bX3ZSYo3FV2QPqZIJOQ6aUYm/EyCF/yE0l+iFCTOrJGvQMde1SjGh5AMNTzG3UKOa7kuFAOUEcuka53SZFy2UXOwtJZlwmvNCaO0MUMuKA8hMOE0mE+FyedaVHB/SF39hSpe2WKrTE8E+rprd70qXFqNVNA2Za2Wc4fTHxheUGEGX0dSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 13 Mar 2026 19:17:02 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> TL;DR
> =====
> When CONFIG_DAMON_STAT_ENABLED_DEFAULT=y, enabling damon_lru_sort via sysfs
> "enabled" parameter returns -EBUSY. Is this expected behavior?

Yes, it is an expected behavior.  DAMON modules run in an exclusive manner like
this, to avoid interfering others' monitoring results.

I'm planning to make them be able to run together [1], but that's a future
work.  For now, this is the expected behavior.

> If yes, should
> this limitation be documented?

Good point!  Yes, it would be better to be documented.
 
> 
> Reproduction
> ============
> Environment:
> - Kernel: 7.0.0-rc3+ (x86_64)
> - VM: Virtme-ng (4G RAM, 2 CPUs)
> - Config: CONFIG_DAMON_STAT_ENABLED_DEFAULT=y, CONFIG_DAMON_LRU_SORT=y
> 
> Steps:
> 1. cd /sys/module/damon_lru_sort/parameters
> 2. (optional) tune parameters: hot_thres_access_freq, cold_min_age, etc.
> 3. echo Y > enabled
> 
> Result:
>   bash: echo: write error: Device or resource busy

Thank you for sharing this detailed steps.

> 
> Workaround:
>   Disable CONFIG_DAMON_STAT_ENABLED_DEFAULT, or disable damon_stat at runtime
>   before enabling damon_lru_sort.

Makes sense.  Indeed, DAMON tests use [2] this kind of workaround.
> 
> Questions
> =========
> 1. Is this resource conflict between damon_stat and damon_lru_sort expected?

Yes, as I mentioned above.

> 2. If yes, should this limitation be documented in:
>    - Documentation/admin-guide/mm/damon/lru_sort.rst
>    - Documentation/admin-guide/mm/damon/stat.rst

Yes.  But, I think 'Special-Purpose Access-aware Kernel Modules' section of
Documentation/mm/damon/design.rst is a better place to document it.

Would you mind sending a patch for that?

> 
> Additional Context
> ==================
> - On major distros (Arch/Fedora), CONFIG_DAMON_STAT_ENABLED_DEFAULT is typically
>   unset (disabled), so this issue may not affect most users.
> - However, for kernel developers or custom builds enabling both modules, clearer
>   documentation or error handling would improve debuggability.

I agree.

[1] DAMON-X in https://lore.kernel.org/20260307210250.204245-1-sj@kernel.org
[2] https://github.com/damonitor/damon-tests/blob/master/corr/run.sh#L62


Thanks,
SJ

[...]

