Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D13D8C61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 13:49:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECD8E6B0088; Thu, 27 Aug 2026 09:49:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E58436B008A; Thu, 27 Aug 2026 09:49:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6D716B009B; Thu, 27 Aug 2026 09:49:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B1AEC6B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:49:57 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3A3FB8043F
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:49:57 +0000 (UTC)
X-FDA: 85147182834.03.0352BEE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 90A108000C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:49:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VKhpbEsp;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787838595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MdLgXdf5TcxCSOGCt8+O5lejStWVA0dR5b/HwK08zHE=;
	b=g+IhUeRuBVxJOGyQBqWl0yIcat0BUR11d2ADW5nB6QpTXuVygb/jB7YAupSlIRNWX6G+4O
	LhJcCGxnFHqKqvQRSFAu0veWcYjwh04mSTemizTgju+IweukLur7EbezkoBZeHlP5evmtj
	BBVVv/j/uZhl/7rM7UHa5RYh76rZ8qA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787838595;
	b=YMR5DFY6bIjb4JrA9zvVbHKm5gX4NOUVorSf6ATDVx97g5w8+1VYCFxVyEOtFT7+UfcQel
	CSuYZ+lNT9jH1QZCZSD7AG599FtAigkqDG999FZYPhTq3pjJG2Ep+Mrj/EKvSMofetX6kg
	+zZ6MYilSB6RPV1qVvVAwP3uD8ndrwY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VKhpbEsp;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C54F9412D1;
	Thu, 27 Aug 2026 13:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793E01F000E9;
	Thu, 27 Aug 2026 13:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787838594;
	bh=MdLgXdf5TcxCSOGCt8+O5lejStWVA0dR5b/HwK08zHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VKhpbEspM7u4jb8cPd7raVUz1QkbPa4PUzEYBzB/uxI7w3xR7Pe1jCdx8yRhOJjQI
	 kVop7F7Tfm2oauPuSzBpAIffzQRORk2YWxMNdAJSfo0dAGbsqGOlvbSFHTkPtsVoO4
	 ROBRzwGfRElypIblqq1zO9J4cQkESnvwVKZ66AjTqYeo9jnJBTOFZ5w8yqdesXqiSW
	 evMVeXNIWmysf5Wof2yCbG8lVAKDp/Bb3hlf25BL97N8dgBYwBmrzGFbsqTWERzW9B
	 2YAVz/vhWYKm0cj8/42I7O/O1D4nwRU5qSSa6KhvGBtUkLHoX/mWre6EblnT/c+Lk3
	 Gl/4pVc0q593A==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon: fix damos quota walk-position tracking
Date: Thu, 27 Aug 2026 06:49:46 -0700
Message-ID: <20260827134947.123814-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260827060255.18114-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 90A108000C
X-Stat-Signature: 3hhsqcrqr3ipkdb1xq3w8nrcc41ds7tw
X-HE-Tag: 1787838595-994760
X-HE-Meta: U2FsdGVkX18yIeotKnMJvmCjL2YVu0tuYr6TVJ/ZUOJRqgYLtoeVXOzjhYcE1RSMip0NBDHMWcoRMXpNoFK42yJN7U5GtQbv7oaHc+WloGuNysJ1ZWsg7ebUKkFGdzFQ9DfvuasXOxxyqX/LHmnHEq6y3cLq67OqCzEz1vWELI2y6kVd+zilxmSTUkPG1IiZtNrrkZQ7Ikppl68fJZJoFvgxneJ4KQXvEOkQqpmL4Tqlz3bEo94a5IvN55tu+CauU5ZVkgTkjPMU8sfjWPcUz5RxKlS+VhdAOtZ90vbGs2P/HybO6hiOfSD/WzVrXanrY64/inHkbRTGu7pbBL5ozgvto/G6Gq8545lxXtOVZpLOxQDLS4A9C8TEcih32tocGJENw3UHJGA/qS/kARbhFh8pI4ALJzXkqpLC4QQv5kFtIzop4nOGMa4Z2j+Lcl0CR25NtoSI9JnAwiRvvRduItemsLqEDF8ecGfgYrW5s4i1iP+OYzt5P4II0oMcoIERUtJjtE6ANB1htBX1i6fmD+h2YPW2Xld1isMJ8wt5/CeXoPaHzk0o3uW4j68P7oYtV7RKzqH00mMrLU1RHded4gsmTf5Wh2YIlWiOTvs88AH+l9Qhk/r6BKmchsmwHHdzRX5gLMB+gAccq3qpZfFThstfrj23HJwnt76g1zEGsac8Tt8IpbGRZ/R9epB0rmDp/13MjsbHYqnc24htaRFwfjkLu7D6RlpxxkiG4g8o1psD1M0Q+2hN1Dda81ML0bQ4TDBgg/BHMYz4+oP0o69tlcY7ezAh6NFdE7gvXhiIY1hSCLk/yEa3HPwdr+rdBLNRtPZBfGeOf/pwtbfb1iwV7f3cTcP8NFFZFyksOTE8Nqh44a9SRvwNa79wnsm1EWLcAx6Vl4Tu7nc/Px4RJowIuTWdzj+U5VTm9jfzUUeqRFdVrVBZfO0Z0grMRBq/AjQVKlDGvJZD1qG0uu4fsno
 /D2BJugo
 B7BtqbLzraS7byQ/jLW1XQGap+MJioMkTKpSwnVbDy8GRcXA4ISn8B7+Xb/gsNcgPOrAr1AydI4knrx4NtPF7oy54cNDEx7gpNIXe+p2y0PyykyIbfS4xG6oiLgilDEBK5FCK2ACMpdhNi3GRj4OPaVGaYc1XM8bR3jJuDil2kYswKcapa7br8gUhOiFzTPuf6wOWbMn/n5M9hbL70vnzMXIAIUkhgC3VKJYSTkFvanl/8aIv0U5Lk/ZyGgbD7YGEcAay+dhi7txFs2/jEx2bjtY1DzUR4ir7QUOXK7GJ2fgfTQY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 27 Aug 2026 14:02:55 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Hi SJ,
> 
> Apologies for the noise.  I accidentally started a new thread due to
> missing --in-reply-to flag in my git send-email command.
> 
> Original thread: 20260827004438.82746-1-sj@kernel.org

No worry.  Could you please re-post the reply to the original thread?


Thanks,
SJ

[...]

