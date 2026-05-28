Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C699BCD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 08:11:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D215F6B0005; Thu, 28 May 2026 04:11:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD23D6B0088; Thu, 28 May 2026 04:11:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE8026B008A; Thu, 28 May 2026 04:11:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ADC2F6B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 04:11:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1C7DA161E62
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:11:16 +0000 (UTC)
X-FDA: 84816108552.13.467B0A5
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2B07E18000A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:11:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=Jp+ofhWh;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf24.hostedemail.com: domain of niecheng1@uniontech.com designates 18.194.254.142 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779955874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WCwaRPNdzdcd/gd4fVb3UjkXGvISPD9Y/AY9fBD0in4=;
	b=cXx0cgEIXb5iqotStHj+vA2Ec1362cEUAnbnKm85j9LaCT+uln8uv2Oqz+zRNw1wGexgC1
	JGBtbIA9AprgXYc/t0hKsDHjl01QbDbweK4u+NRWX5t79E2jjXnlVTOPrclOKN3Fsh9bcw
	Q5E6XfyMCavSmVs5ReiZ1rXHl3MJd+c=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=Jp+ofhWh;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf24.hostedemail.com: domain of niecheng1@uniontech.com designates 18.194.254.142 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779955874; a=rsa-sha256;
	cv=none;
	b=HqEuqmHJKWAA3yBjmY4o2kFC78Fksd+dZ6LY7Z92AtKlitRIiOf/HSs8h3BgKwYhED4wZe
	oQbHpOwCgb3Lvp/3LhRoM/rxH1fzXYgyOQwnEfvf1FzBlBr/Jo0sfEzHUO6ODW4koIEC8S
	LXqzDYU1qGZVAhHLDCOP9VeVl1vilpE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1779955855;
	bh=WCwaRPNdzdcd/gd4fVb3UjkXGvISPD9Y/AY9fBD0in4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=Jp+ofhWh4EeO8HLt0OyKwamN/NdR5vcVVNcGwWz/N/qh9eFrTNTM2VCkvoIMR/xiV
	 DBhdG9MVaE2y5k+KkP+KIXxiIAHL2MZSxcRLt4FxwyToNv1r8hTJKXlR5hp8rMJkuj
	 ExpOAWNQ3YfxgxEnJaq+luWf1lF0kXrRAfhoBHS8=
X-QQ-mid: esmtpsz17t1779955844t268d210f
X-QQ-Originating-IP: Rx7N/RQOsqKeDzZO6mVRTy6pSf2TJ513olPxFOJZa0o=
Received: from PEN1097 ( [61.183.83.60])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 28 May 2026 16:10:42 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 2854023755336146765
EX-QQ-RecipientCnt: 8
From: niecheng <niecheng1@uniontech.com>
To: sj@kernel.org
Cc: shuah@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel@uniontech.com,
	niecheng1@uniontech.com
Subject: [PATCH 0/2] selftests/damon: fix and validate memcg filter memcg_path handling
Date: Thu, 28 May 2026 16:10:37 +0800
Message-ID: <9479D47690DD7F07+20260528081039.1192194-1-niecheng1@uniontech.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: NkdVy0O1B8HBDN+4dS35Lw8unz6/WKI6wyblS+3v5211A+yErlmVXR6P
	jCtSnoqeoDZkI1n6nWV/bNrZZ7KdYKIrOGx+7NVMhnljnQtYbAaK8wlwVXyVRELuIr4NXsO
	IbKukelGwD7SDGwWnqtu5NZ3kYE2AHouaZ51q6mUujUXGJpgNAtqOcSRiQ39A9GZ2fuUIX+
	1M8z4sNaWVs6wW9NNmioInLuqsgGCYnuKYgKcaxeHJoVnKdHPEKt2i9K7Qj/xFEdXmSFFJP
	rujPM2vGS4uqkj2nWfPDPSDqW3KqF5N4AGLEtpWVczszQ3EpsERyylBDafjawgrNGjLsLEe
	NW5YbeaypV30E8i72Rf2sU4sf3ndOsD+XhjINZSjjApdVQa3z8yBIQo/+lg8CoB5vVcM+wC
	IVElmXmzNKNCWrs2DnLxlCAMavMT64cL3uN1XQvFX4e5JxXwby295angoyqLoLaKs6lUkqv
	74d4Ys62rEb7wE/BlnqjgwH7JJzWduUJiMzP0HjMkLbdLTaBP77KAZmJCma3TVNoWUfoBy0
	MU2Kn/lr3nkTtELuHzhJJT2lC4xT2codqGazlT8dlro2/ayNeS8WUu3htlZN/KcgZ7ycwfD
	f3eUX7BzKPeTj0Za5UfWqMCx2nl+Ayr2usSONYIs9PUcW7I+4qVe+KvEJ//u39vMqT6q9js
	/0sH6dm/bfLFdOeaz922jNzE68hQ953Tr/dkXEJc08evrGnSIGqVCmwy5gxjAKCszjFcLYa
	k/pP8dXmFAX0svt4q5Pir/USJRFGs5FHgxh4ZDUCIk8htUWXZBK0XQinJO5ywP5c2v5qgED
	bsf5C1NQCjLkZe1zh18LyBtYW5/SLxuPpgEmjrUB1hUleRtw9Nsi5fKBJ8m5D/ysVkbS4z5
	9c4uJ1YLY6zy7c1rm7F7FUFyZ0Zhz01/L9A13QZuHycv+jdbQzwZK/EBkOL0np32Yn2GrD4
	sNrk87xhQshfE0vJd7UdECK4+RWV58VgJ7LBGwcJrA195RZYIGkMISqcM6vu+TdARrCP4sr
	p405dJrU2fEb4qgWlvuj7DbmWev730z5h9eUwe/Ff8MFClTSNNDvjBb3UFm0UY4i5sig3Td
	pCc0RUyD2yM+LiQ3S8mV3f8f6c1vlvbRTXYU963Me8TATc8Znx4EBCyKqhvNf6vRsLFomu8
	ra/77uBwzsu5+bY=
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
X-QQ-RECHKSPAM: 0
X-Stat-Signature: gh5qgysadcsmjrw9qwefojiy8rj7b9x7
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2B07E18000A
X-Rspam-User: 
X-HE-Tag: 1779955872-909394
X-HE-Meta: U2FsdGVkX1/kd6DutTte7EkC0+YDqXQ2UUJw2XBwD8A5ni2bDt3rAoQia7/05yk2es3dspCE1M2gEUho8xliJ3wBmZ1VTLW8q4wWEs8rXyGO5Hf9KkWGyCVbtHDWDg5wQxJhpAs7Y7u7mgpo6wDCO6MFizq4yjPVHkBqnYxiRCJvJRtpuuSlsbWqGqpbD5Nrg1k28A8Cg0M0VfoAX4gx4Amg7okzNfrnN+D/MwBO9v7M13GYwZXU0ZnpDPaKFvhlJ/xLhA9HuK609OChvggr716UFuE5DuRq7mYR7oHTHBhDqxNcO1ZkGP9D4omTxHUa5DLXFkUIFXYC2p2JHIVIGG9T3LTZKuT3HcsjDxfD8DWQanHJujic3PTg6KN0yEy+Ga+Q2Lln6+XMwo67PCJ7z1kjkQyd8MBGAvw+BcuDxupp0Hdp+8mxtY4uf5WMBsbPHsdK+wE046v4uX0ANJLXcM5ET1fkgWz69C/pRwFLI1U6yBbeE+bm6qhi4JVywGqpshWd+fGUnVXGdqXc51J2RlG/UWPDq6MBrGjXAgva4XxmmZSasHAQDNLd1xTNNWceQmPw5hAG+1RhmZWpuneeemVwlGgYnbIy2DAGGr7XLMzREOEZA9N2hXb0/+6elLVQ0aAGLiyC7LkWw9BEWXZQ0+ykoPEzd8/g7hf8nKlLBE81fdWDfIIOTfAH6A3DFXsOhjjaC2xP9xDVYpK6cEzrAJnl20Wf4HgLF/L6+rPsIbzrvvhu4UsczzwKV6L1JH1XS603RB7myucL4nFRazwXcROP6+pwGXZEpa0cgkc1zFOQaEAq5e3kyB7TwIHoxESqpaJ3CVAkAuT1Z2bEnbw85tzbMpy29F8oyNeSbXMP+lC2PmPR/BU7POIDxOdgSUrPXbH7a1WTmcQuV3i8Lxz0FtyVhJ7hNOQjlrd2xgJyEvekUHQoLoKz3S61CyDbHQMO/8rijpAgKQMm4txwzbX
 9s/IehTa
 tkaIwRvHjQjkrjKN6fBX/tHLNJ51S1KdzQgXQahjMiFWugrQgQteGBgpevtmoREPNF49k0kopIiqBLGc0UiKxQJhqZWpn5wMYGVi13JxgjrvEeLLpsCqDoG44ue+akqE9wKddTsn+tBTQyS/VknziEpn3At9mE1ieZkbZIGPC0jFXLQn3q/7rReFTVc6hVfN774ri5WsQB5iTMp5Pa8Zr6Si9scj0q98H72TunZoz+eOgKrPeLWmaP4sZED0C/4zAk60jM9lwS36vMC1TAwKdgl8V0MJ73oXcSFzuI7Nwq3rgfGvHmhI62EICn5ePwjcJc3ifg+enhk7bDNjxv2s9YRi64sZyBIeT74I3NzY284qlc6U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series fixes memcg_path handling in DamosFilter and adds memcg
filter validation to the DAMON sysfs selftest.

The first patch fixes DamosFilter so memcg_path is stored as a string
for sysfs staging.  The second patch adds memcg filter validation by
checking the memcg_path sysfs readback.

niecheng (2):
  selftests/damon: fix DamosFilter memcg_path assignment
  selftests/damon: validate memcg filter sysfs readback

 tools/testing/selftests/damon/_damon_sysfs.py |  2 +-
 tools/testing/selftests/damon/sysfs.py        | 13 +++++++++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

-- 
2.51.0

