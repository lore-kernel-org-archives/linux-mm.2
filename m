Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E423DCA5FF0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 07:03:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B88F46B0093; Tue,  6 Oct 2026 03:03:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B09856B0098; Tue,  6 Oct 2026 03:03:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F8396B0093; Tue,  6 Oct 2026 03:03:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7AE396B008C
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 03:03:22 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EB686805BD
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 07:03:21 +0000 (UTC)
X-FDA: 85291310202.04.9795F69
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 063078000F
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 07:03:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iQOrFN9i;
	spf=pass (imf30.hostedemail.com: domain of devnull+michael.reeves077.gmail.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+michael.reeves077.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791270200;
	b=JtHRsaDDGqFEVa0pRheI7hnOdbLY5xzO6g8JnAsk3Nj11hVl0O2OQ8tyT1PNDhyv/VUmb5
	WGumhz2hs51kmcemDRt+iUNe5mxFEtmcbFVa/cWMNF2vOaivCYU7+Dp62+dztjnQKNDYBX
	w2Vxd0+lCX51XvHix3ww8WSedFBaeGU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iQOrFN9i;
	spf=pass (imf30.hostedemail.com: domain of devnull+michael.reeves077.gmail.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+michael.reeves077.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791270200;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1SQtbHoNQ21m+TSWZuwglPwr0v0Xq2UlF/jdJ3sL+fs=;
	b=XaMSthJUfya6GsYHgrjETumHONopAT3nj5z1DjfZ8S9K8vIF6cyfYN1Lc2vI5LtkQTG59x
	4Uusm1fa+JZSsgRZl8I+vohWkIRCePbGSOKQXRbZZh2ASITndKTb99MIcyBiXHBWY8Uyaf
	sdioruAaZDjLtIOWrCwTJ+wJEqv+hgI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 61F15601F1;
	Tue,  6 Oct 2026 07:03:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E67E3C4AF0B;
	Tue,  6 Oct 2026 07:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791270199;
	bh=Fw36XhTXe0b1nKcvjkrW0Rc3WDJ1Wu2lnc6LFxgAq3w=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=iQOrFN9icaXkzvwNYnnwcnEgucWmkSaAp241zZZ7XcNsGQLCuwqnx6WYvIJYyWtrS
	 dHFdBSZksZQbAf5y1uHvyTDFVSl0k7tlymUNvvWy23TBUbEsj/0+Vlp9OAKZjrwmQK
	 sQxI4MZv/aS3u6wsBTq2fV1JIehbnKUM/9bC/6bGfXSWG2G8Na1issy3viAeugNLfh
	 wQahbi14qjIiu7rkb9NbmOukFK4tpubhyTJ033h0GqW+XE1czZs4QWj9bzsyYPkb3+
	 O553oKUezmq2Ys+moWGTJme9E6pT88b8jPykK1T42zPKZxa/+HzE3EnN102F/e1+vV
	 TRCy1G5XxquGA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C079DCA5FF0;
	Tue,  6 Oct 2026 07:03:18 +0000 (UTC)
From: Michael Reeves via B4 Relay <devnull+michael.reeves077.gmail.com@kernel.org>
Subject: [PATCH v3 0/2] regmap: Fix cache lifecycle locking and teardown
Date: Tue, 06 Oct 2026 18:03:14 +1100
Message-Id: <20261006-regcache-lifecycle-submit-v3-0-37bdd82fd47c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/42OQW6DMBBFrxJ53UmNATvOKveIuhgPA4yEIbIJa
 hRx90AWVVdVl2/x3v9PlTkJZ3U+PFXiRbJM4wblx0FRj2PHIM3GymhjtTc1JO4IqWcYpGV60MC
 Q7yHKDK5qS2sD6zaQ2vxb4la+3+3r18YBM0NIOFK/F++3PCfG+Bkxz5x2o5c8T+nxPrMUu/ef3
 aWAAk5lcDWh8423ly6iDEeaotp3F/NTKrSu/ioZ0OCdbSpd88mj+11a1/UFbwfSLS4BAAA=
X-Change-ID: 20260925-regcache-lifecycle-submit-74f366be0fbc
To: Mark Brown <broonie@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Andrew Ballance <andrewjballance@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, linux-kernel@vger.kernel.org, 
 driver-core@lists.linux.dev, maple-tree@lists.infradead.org, 
 asahi@lists.linux.dev, linux-mm@kvack.org, 
 Michael Reeves <michael.reeves077@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791270197; l=1559;
 i=michael.reeves077@gmail.com; s=fedora-20260918;
 h=from:subject:message-id;
 bh=Fw36XhTXe0b1nKcvjkrW0Rc3WDJ1Wu2lnc6LFxgAq3w=;
 b=1TBN4aLDjXZNkcqUmaLZLH4OjfQzc8Jcun6vrb1+wdyzvEfLh1e+9zWeK/8G+R7wooWgl298r
 rv5E2j2yZhgBZJMaKrJ/YYeB1H18i3Ng5iGwnl4w+4sTgsNRV9sCsEv
X-Developer-Key: i=michael.reeves077@gmail.com; a=ed25519;
 pk=VJ0TvyQ9TvfzYZa908YSE9kpkjFLLD5luv0bERu+boc=
X-Endpoint-Received: by B4 Relay for
 michael.reeves077@gmail.com/fedora-20260918 with auth_id=1035
X-Original-From: Michael Reeves <michael.reeves077@gmail.com>
Reply-To: michael.reeves077@gmail.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 063078000F
X-Rspam-User: 
X-Stat-Signature: x646e1hxjg5xu1ewm1eskmiepgsx8ggc
X-HE-Tag: 1791270199-331718
X-HE-Meta: U2FsdGVkX18KZyiuFWzDXEe24T8/83SvNYOxNL5UxT0kNFR238TrRtkG6Dhs9s1CsQgxHNqbkETtXLs9oV1XiBbZZ5GxCMnGUNfNcQeYhoRpVdL7lhOEepCCIB0I+gG/R3/2x7tTYUqFmio1aB/mPLrV0cMZ162B0sWTLus08bimikJpyG2AizQBnX3biYGssX+dFUkV18HPBR5d8dg1qZL0UEO35GqhlwDupUOlLL28N8ns0Ko63RJtp8TnCcNlDwCsTzgX0kIkywiD6g9yaCnTJx27AOmB4DP/NWfsV45S4HvBAE+A+o7HK9BXGDPlvsv+1S/xgKqgMl4iTmqg7BG5Ll4UTrwDLgg+s+qWmFG8oVJsbabelvANuuUZMrSfbWgQjDXt6MfjIs0b217KUIeJXzcruLRkAlNIghWoq34gVY1SpQS68cnddMvUuIIGg0//e39OSWVu9Uwb+unneTFI4k2LK1Cj1VRWGEEb7Hd8lu2/dzKoauhECIKNfDnyJgjotDadVqX6mJCJGYKR0sKpQAZdROZJIsagAMqMXOZFIJbKSl3YmHNxE8XmMHPw6I9oQAXPI8zcL8jQ+hj8M7BjMwOQr6ONf+8/Yl9IrrTnpgnDx+FyWNbFanusELro0xVUUVcNke49KAeajQy5pkOFbTx9Dl4S1tbS8PTiPL4LmPZOd12HQek4FLSoTRCcqdcHGLo/I8qOP6pI6074Ia2dXTWxXogKaabW2ovdgKLCJrOQXygcl57yvYayK3L8wGfoQcfDG2MOOcR7eXgTVNuKy+6CLm/c232/fGcxw6DCdCtFoyw0Zqw14EkuJvpxsl85ljYD12q4CHssFsh6fRj3zhbi5g9DKp/iX4NKzN7psEVusUpiJ2ZG1W/8rILB4k/LHEFjjwEuCRB3gh1pUBNHqafzjJWhzjguoEALjQ8QXwSMUWhF0ypbdB8PCoYorj5m7B5HCWf1wU/5X/M
 8HRIoM9T
 PmpzQJMs3RJZaMZrGw8PJTTD79wm0YUUq6FkTwfh214PbsVGAEastU+tsPejZoZ5xJ2Kd0HhwN+jbEOb05S0PWuCx9aiBqPNLkFTXI2I4NoF79dE5BjSQ76SLfJCVfKHYOE099E0DTHjG26rBVEXex4432Wg8969CQ8R/IeiOm01nYX0XKWIAPu/R59R3VShK+Ha+aCZW72wEe3rAlBjGPWcHbhzk02TjiKxXTwSduPTVb0GEO6/E5EAjquVeW+zzYZTt4X9hczviyXX2e8zkxp83JAGubBrDoWMlIIUGTj3tcHx3DhuWjwFCK7BaIkhw4GetwANk0S7f5sn29EkWwhsp5uCfotOCdq2B9FzCRuwbjaEDMmfJXBEoFI/QME7uCKIKTtA1QPNFuEYmsxuXxYA3Utq+dAxZe1QV1/PdeAWqYP6ZpC486K21N21yA4O7Sf4l5qbunXxrJNs2/ONx4R9oOn0tRdQjtFam70gAWVrcA6hrXOJK+pjZ3OOgeqZ4k/XYOWnXDuqU3hOMEwB5fM7j13AulWerQGmi2juIaeAy4R9rUW7jgcQTnOC1JYPrQ6Ou
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix an "Invalid wait context" lockdep warning during Apple GPIO probe and
correct debugfs ordering during cache teardown.

Tested on Apple M3 MacBook Air (T8122):

- All 4 GPIO controllers probe successfully with lockdep enabled.
- The "Invalid wait context" warning no longer occurs.
- The regmap KUnit suite passes and lockdep remains enabled.

---
Changes in v3:
- Link to v2: https://lore.kernel.org/r/20261004-regcache-lifecycle-submit-v2-0-976d405e89a7@gmail.com
- Add Maple-state irqsave and irqrestore helpers.
- Use the helpers for cache teardown and document why IRQ safety is needed.
- Rebase onto the latest upstream tree.

Changes in v2:
- Link to v1: https://lore.kernel.org/r/20260925-regcache-lifecycle-submit-v1-1-83b75ca79d96@gmail.com
- Make Maple cache teardown IRQ-safe.
- Fix debugfs ordering during cache teardown and reinitialization.
- Rebase onto the latest upstream tree.

---
Michael Reeves (2):
      regmap: Remove debugfs before cache teardown
      regmap: Drop map lock during cache init and exit

 drivers/base/regmap/regcache-maple.c |  9 +++++++--
 drivers/base/regmap/regcache.c       |  6 ------
 drivers/base/regmap/regmap-debugfs.c |  1 +
 drivers/base/regmap/regmap.c         | 15 +++++++++------
 include/linux/maple_tree.h           |  4 ++++
 5 files changed, 21 insertions(+), 14 deletions(-)
---
base-commit: 2c3418fffa9d037b2038a6db48be63f9e2291806
change-id: 20260925-regcache-lifecycle-submit-74f366be0fbc

Best regards,
-- 
Michael Reeves <michael.reeves077@gmail.com>



