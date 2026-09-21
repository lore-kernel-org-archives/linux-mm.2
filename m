Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1926CC982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 16:40:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13E776B00BD; Mon, 21 Sep 2026 12:40:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 117436B00C3; Mon, 21 Sep 2026 12:40:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 053216B00C5; Mon, 21 Sep 2026 12:40:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D46D96B00BD
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:40:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 712F8A0205
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:40:23 +0000 (UTC)
X-FDA: 85238332326.15.2F95CBE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id D5DE21A000D
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:40:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ProEswfT;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790008821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5W8BmDB0NOPitaJzU/9lbnlRA3uI3evt5bZTIrqhe3M=;
	b=eD0lTmKSxTQOkfOpzRZnx0z3CjDqt3uYKzIgFMLLTnQPxMBYmG6DxHkEcuqLjf5xlOxT9U
	ZnoqFHC9DSaWJy56Rbk/Ej868Pht4d+lypmXRcvwmpPHYxEisoyMtMWZLyJl5l0cS1V28w
	/44j+eII4pyTf0HzPZeZrV5fswq351o=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ProEswfT;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790008821;
	b=NCnYvTIe0TZmvS1QBXyLyXHWbTlH3GZgpHoc28Y4M7hCrPUKHWzMjp6gViIsiOlcUqI7n9
	RJkahiNVPREHUc44u8IORyjdRqIC8g+o+U/cPW0vA4rl+/KlgHAdJiAGO1vkNKEhBo/Mb9
	mvamQHluNXzFpS1LEHFwHYHc9gtLLZw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D77F60120;
	Mon, 21 Sep 2026 16:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9598B1F000FF;
	Mon, 21 Sep 2026 16:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790008821;
	bh=5W8BmDB0NOPitaJzU/9lbnlRA3uI3evt5bZTIrqhe3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ProEswfTIrZ65l7DvejWYIVp0UuxwpWF9GPG2r+Y4vn7rwz6OBi95kHHkXrYY8ZDH
	 Dbdl0WWVN8Gnhady5M/ullor4Be4aAImZlxaxXlYiE8Ot/J/DYa+Z74YDSjplyKJ4S
	 YjvwW/1DV6k19vciFAEfRvgt2ZFAUr2ux6+Ojspy3AJ4jF7OhZqMhMljyifHR69nhX
	 RUqYEBBNr1WQCINsMP4/jMYeTEBu1u7dtoafRvhWNcmSfUS24OffEej94xDCAHiIId
	 PmItWeWsZ5LV8puKOkTQeSgyHk7n4kD1p+EpnQt7uj3ksRsYMdV7ec01tbZ8/HfgBc
	 CFbb2kdH+bn/w==
From: SJ Park <sj@kernel.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lian Wang <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm/damon/tests/core-kunit: test PSI goal values with explicit samples
Date: Mon, 21 Sep 2026 09:40:17 -0700
Message-ID: <20260921164017.81642-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260921020013.33105-3-kmehltretter@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 4dsbq6qrpxidu555x8jyroztkepf665y
X-Rspamd-Queue-Id: D5DE21A000D
X-Rspamd-Server: rspam07
X-HE-Tag: 1790008821-36101
X-HE-Meta: U2FsdGVkX19IZIjBHgRlpS6LdQPEKlt1hxB7gssFqnKPda5Rnn7uUVUHX4wNU5pkLBQ28vA/G4f5z0rdlo/VLGjF7z3XShXLWGsepKs4Dji96wDokyk91CFhLGsLxi/igq0SMgnrHDJhDEVVUjef3RME0yV6OL6/08AK87ImpmsJ9IfIDX0lH6AKvO9Xveg9OTffD56iYpoOOGB9nFIAA4cZ92WKqtinH4q2vs84eC5WMeZ+4W8p23lNef4rWxGZuwf3vmjtAF70nNiKwZG9VnhIyoaSn5Ty4Hvf64T+yNjGFP9zYa9AM956lIBXDDC8SE8NeeTjUmb1ZVBsyOw0XUEstfaVXNrol9sVo8594YV9ynmV3v/UyohBGSl+T2/l+0l9+n6qfLaJSGcQAjJF9kDjOiJ5EjJRSBcJ6T8McSbS4sZnd4wthKOVe3QxsgWKq2fprCmzM9ZAMS1O935R/xx8c7eILMhQM2ZZaITyR6okDLbCxB0IjvNGA61k0i5Tk7jrZ0+aVUjIZ2Gy0SG9wLYCbRKuH1NNuUHCzK6Y/9Ic/CMzAk1bE5iRmn+DUF3TGu5DuKhtpGbiomJT95frOA0RB0BPoLIyNvQMYuiGKlUc1+orzLISQU7Ka9K0s68GRbkpztBE6cKovqtfv+DknhzopN/7P3n18NGa4Q1o00u6x7wz7d3Tjj9k5VeYdW4QVdDv1P9gzdgtjz8G7fcxdIon3D15UnIwzRyazGkTQVZQUBzpa4xbpnR0q3f39ZfCqzB+ZNOqnhMTJQyj6wzl5TrEMWsEz0mULGxsF0FvSLMg5K117y3EfIK4K27lXlQg7r2BIRNUFBOQQPecwNZradY7xvkoTmQT9RE2WtJ+yEl4idH46oJK6NnUq1Kef9zY2QmGLQSH60Bvr209alTXBwlBUhBXnilWoDi8j7d174Lt8E/7rJ3O1ZBvQQxskbDgUK2UDuaF7qbkpNvhAi3
 bTVTh+td
 PO9X55NB4tMQjAs/b0zonSt7s9Ua9xNA3gAQRNoELn5JyInqVYLGJihgpbWgDMdo2SCA83ZS5klciHf4LMq5vwDpaB9N8OFfkGoGAcDLq6AS/RTOgm0GImENh14m+jCEoHsJdUVR/izeseM7f4RyZv177EaGKXdNPSPOWBWiqqMeqUSRAcCt5YIeaiTZjkU3bVQOGwtTb+cVssVCVoHhFJd6qWCTKW6XW73CiCTIG/TYYnNXcYHbl6mlD8FPLGflSGF/DgCGS7oh3GRkxEyURJbVdp5uu/B6q8s9GYaJCEcA/QbprNBS1aXbpZxHzbjlGLZHlN4kyhqj4deU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 21 Sep 2026 04:00:13 +0200 Karl Mehltretter <kmehltretter@gmail.com> wrote:

> Test the PSI current-value helper with explicit totals so the result does
> not depend on the test system's memory pressure. Cover an unmeasured
> consist goal, unmeasured temporal goals with zero and nonzero effective
> quotas, and measured rounds for both tuners. Check last_psi_total after
> each call.
> 
> With the old unmeasured-round behavior retained in the helper, the
> temporal check with a nonzero effective quota fails.

Thank you for contributing test!

> 
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

