Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE037CA0EE4
	for <linux-mm@archiver.kernel.org>; Sun, 17 Aug 2025 17:16:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E7858E0041; Sun, 17 Aug 2025 13:16:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BFC48E0035; Sun, 17 Aug 2025 13:16:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3E818E0041; Sun, 17 Aug 2025 13:16:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DF56F8E0035
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 13:16:54 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 892A21406A9
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 17:16:54 +0000 (UTC)
X-FDA: 83786904348.06.FA1FF11
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf29.hostedemail.com (Postfix) with ESMTP id EEBC0120014
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 17:16:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tjgzNzKN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755451013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=USGf1K52unLVNtRgk2Y7vsHDZwwlaI0Gr8lNHQ1/UtE=;
	b=zibHfVifbdKUVg34CWQiO8G1YrZRNNLsgPm1NXrIpXwsf2LMhLgNVv2pPglyQsZJTFIm6/
	EV0wHpDU8xaSd7z5e4i0ZZLaAHo0clnpB1e6+jCZlvgElNLMHI5igQF27xVj4zvYAWwJXc
	Ot2QIwVNbYWtZOpph4ilr9XB6Q1rJy8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tjgzNzKN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755451013; a=rsa-sha256;
	cv=none;
	b=4+2Maq+iJ1PkluK+TTEhdxb2Z8p36v21YZd44vbhuUMiZK2ReWIBBe6Sj4lhye/qUk85Eb
	P7TOpIXOhoAc7iXgXLXj9OsDzZ4htaXbD+6hpBRpsl7e89et8H/SKEfOJtAkTAIzIN6t6f
	0qzX7KzUTmeobR4/73g3bjys1LZVBvs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id D99485C10AE;
	Sun, 17 Aug 2025 17:16:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B11C4CEEB;
	Sun, 17 Aug 2025 17:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755451011;
	bh=aj2zVl+t+vb0SmFNzFYJnQsEZZaPzlT3JEU0nf6FpT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tjgzNzKNtUylIF0UxOTfPcKWdtPOtR497jM/kfaFp2qeEX3AlfhI9Vlz8j8NrIHcW
	 m5KnCMnwR1BNxbmZ0Hwa7oWhzrjbnIZajOVlHd+4KvVacFXHXQjsQcUhFCB5+OjT0t
	 e7lU0jOdpNkyRwwwoM+11ETStSrpd+nLmTVtTZZXze5R4hGz3TzN98EBrBAkum3sNF
	 W/Hid6iPgBQ3nZHysdZ56cNtxREyrGozh0l+1Jd/sq7ESHuGashCixbRvWkZE7x7Av
	 B9w3HH/11oG7ygnsrLpFAlGE6DBpScuHCPZ5j0AirIVn+VGFKwIIT1RM7XsMDls+tl
	 7BwsWv57L7RcQ==
From: SeongJae Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	honggyu.kim@sk.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm/damon/tests/core-kunit: add damos_commit_filter test
Date: Sun, 17 Aug 2025 10:16:48 -0700
Message-Id: <20250817171648.16272-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250817021348.570692-1-ekffu200098@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EEBC0120014
X-Stat-Signature: 6o34wmfayg3ky7kkhgau4n936eww1deo
X-Rspam-User: 
X-HE-Tag: 1755451012-102700
X-HE-Meta: U2FsdGVkX19RDrbNADPKSdHBq9RZzhDBcT7DpPlID5GHHpay0YIPJbaBMQ6UEuIBeA7UrSPfNFWYpsklNT3R5ycn9F4V0WQwWv+y0LEVcufrENTaX6noVYFG28nuMlwDy9H57yWkaxzRV8e+Y8GN4mVPN5aFnU6Zi/43c0ne3ovtO3HxQbLjWNxXlZEj3q4f8bDMeck5sN2xsCVL06qQc6EO69zuIYhf8Puddu2qiByF3lHWPJpHpMFqw7anOqShNjEQI+WcYS443Ry+JwRFRYCQPOm3SxG5rqi2oN2cdyBoK9ac/WcD8xLSErQbphCR+1/VAo4dKy9Ht7aSbbIR8WlZtw2AMbBRSHx24FVyEmLrkTzmprrVkBpn+EKhW2IRRyVRd6NM2LOsyg2QHE0Yk/8D1cUkZI5e1LlrUvGACv79A3CKe4Vsc+1rf/fVXxIBkjHa/QE13GgN4j+hoUeEgS6uf27vRzl2Jv+KwezmzCem2p/BJFsZbtJ2pWsxSAvcBL3FMhcnxdinzyvA289ARrNByZgKmr1WEd8BKQiSE3251NWsgBNOWUJ+wWtXH7t2PCcSr/aYKzMANh4r4sAj6o2UPS8f0avFTIvJw7Z6BQe80FIbgTsyVaUfwRWIMoMjjeWE11QO7lWZKz6/zdtV1xKHyxe6QQcGzO+MS5sn8kSuqlo4kFWj8osCe42Uv6zhKPPRTxbSZh8ymwfGrTuT4pWQeXIlPsWJfQWusQKMgxsEf5JW+CuMmNMsryax6Uaza7r39U3yzmufteguB3l/jKU/CagrEU1HnTmqX1zfV++js5qIf5YrbYkD+TyPNAHM5g6ZNyuNvTgEO0HvLwPGzk92JwuxeOvoUf8TzwfUns3vDF8TivlEbSrXBCeGwn2qVxfXyi/WNcTDUBVtTqbECq/2B8gWlIYGWxaiiqBNaDmu6RXpsAtSTZwWZZFgB4Q7rxkuM+daglfnjD2gV/s
 B3k6J8Cn
 PufZwa0l8io1KoRsdaRFYeZJfIK6QTHuoPR4Ftj4KNRqHiFhUWbFxg2SJe7fMZS874ffkVeaaVe07JMqGn8ILiHdxpyg3WG0psIjfxlZF/1cvkC++vDo0bhDKd6HI3cRU8heyF+dpFt30YOuYW0G4BAJ3fEw5gmHsqG7iFsf67Jp/Ht8KZm/cYS+XiS3jEgUhYHuqMgHJq1R1LA08UDq7EdEvaxQwjlJq3IB53iYduuxwP+QQ6F17PSHbg7+zmj/W3Z6+3GF0KVQ9rtQ+J/BDjmCMmYPGlbL9OI6dQf7uqG48+a2D1a0jSxC4zM3QeSgwKYD9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ Andrew

On Sun, 17 Aug 2025 11:13:48 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> Add unit test to verify that damos_commmit_filter() change dest value well.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
> This test will be succeeded after this patch [1] applied.
> 
> [1] https://lore.kernel.org/damon/20250816015116.194589-1-ekffu200098@gmail.com/

FWIW, the subject of the patch is "mm/damon/core: fix damos_commit_filter not
changing allow".  This patch should be applied _after_ the fix, since the new
test that this patch is adding will fail and make 'git bisect' complicated,
otherwise.


Thanks,
SJ

[...]

