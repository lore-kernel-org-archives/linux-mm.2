Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3310DEDF045
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 06:30:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F15B6B008A; Thu, 12 Feb 2026 01:30:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C91F6B0093; Thu, 12 Feb 2026 01:30:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F5DE6B0095; Thu, 12 Feb 2026 01:30:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3DC676B008A
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 01:30:21 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E49871A071C
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:30:20 +0000 (UTC)
X-FDA: 84434830200.27.05E614A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 658D38000B
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:30:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dQdBVOoo;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770877819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m06UiahKQ9+lbR30IuFvod6Mq4J7kcuhc8QY59m3wzQ=;
	b=BRfa06mWeHXNj/evOOKnXw9xvbXE3Nw7RXV5ovhTgLyTG+vctjvXFiXd+oER/YK4nModdR
	6a6WkbLWRuT9SoEfLEulQv1pF5WOMLNSlcVuGIOq9inodZ9OWiWa8NHI3ZMY5zC6+V7WbP
	UnMYobgDO6vSfSQhqFZU3/Z/F6aL9H4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dQdBVOoo;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770877819; a=rsa-sha256;
	cv=none;
	b=p32/GENcvhEc3DO36NEHMCNtL4O4KA8Kt0Bf3sYnT91z0XiTv1QLbQJhhBFHe9jDcuoWxX
	2udzs44wYUCZA22QD4libiL2Aw2VIG7ll1MM9rs3hKC1AAcxbNBKfPzTcZhLVRaD3w7MIn
	MW47ZLl4IxJTE4lnknBZU/nBxLTrkV4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C4D5660122;
	Thu, 12 Feb 2026 06:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242F1C4CEF7;
	Thu, 12 Feb 2026 06:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770877818;
	bh=pW8zfzWPeGX/NrtwmdEhpxnSoeYoudMU3BLTUgjZrks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dQdBVOooaa7gvsHwCnljCEeeqnL5QpFI2pjxdkuOhWGIEotMDtyThVuqfFrInzeuV
	 O4IcwF9shTMX1YwjINUlOxQM2lS0ErJaA8l4N6XfwEg7iOa+zbpSJUoqI5iTMTUSbd
	 YAPdYaOdB00uwiS4P8jHqDvM2yf6sdbPhO04G8+vTPuf36/K/eH0TcOALKwTiQva1o
	 Y3ynfsSnA2nPfOL12U9AGX3Cu6y17fApeKRiqjJU6rl0Q78XLIcJ2nEm1I00E+ont6
	 F1+qnVYq5go4sNdsolG7zxUHNOZf6ezLtrSp9oy4r6K59hVWDxz2SxfShHjRCFqCDL
	 qSV9vCKFTRzhg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Yunjeong Mun <yunjeong.mun@sk.com>,
	honggyu.kim@sk.com,
	kernel_team@skhynix.com,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com
Subject: Re: [RFC PATCH 0/5] mm/damon: Add node_sys_bp quota goal metric for
Date: Wed, 11 Feb 2026 22:30:09 -0800
Message-ID: <20260212063009.70556-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260204060641.97191-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 658D38000B
X-Rspamd-Server: rspam07
X-Stat-Signature: j96tsfsu5zo6drkhms7qrdy3c59n4sjw
X-HE-Tag: 1770877819-777138
X-HE-Meta: U2FsdGVkX18CeT9B6052ljSHz6Brzu7HH3wXCrzNFB8jZULtBN9YuZ/FszQCi6iQ4KPdVHM+27LkN3s9swzNv7IBivfSnVdPEZHXTB69+LQCVa+1dKC0vZ/FcDcJai9mw6einxRQNU4VBL7W9W78wfz9b6ddbjjB7rwIGC7tHFN60crOq9+uyTunjCQ6azmamSE7nTmj80rRTdBO9PFNioOAQJVRYCS6UpJLMQWWa/7kdg663Iw+/0g8pwwbi9v9tPplnAAHa24ceogB4VgT9YDnag/ISc5liZ7h3j/MKKWkw2efh8aViuj5IXa+82TFNLnOw5XNn9pmzQLH4LorqLr8ZA/C3/qTQr/pF9s73WImer6KyYUYqa82F1y5WRXhSmD2McSThl08i2gjHNgG4kAEBraqoExk9SAFgs8XqI073N2xeg2KDX8FpuqL65vQQzfp+Jx7jPTYfVGZa2sg56YpDfXQb+xcLHY+CvfYanoVF9C1mhGNLHFdufrtRk5JXy2NkI/MyxJD6kooJeYNo6ev5ynCcLeiP8yQoj7IgGdJosV+wWuhotsEFMWxRBAL7fzn0Adr8s0mDByTIMjPzTi7Npn0kpk5cl8fmR6ATJjz3aMZewTsAwEqUO4t0e4O4Wn7z1i6a1UONF7jehKkHyVCpPUB+zxiJgGZZoNdCoRzNHyVgqzyTPMM5ReS9FyaR6eDOywusD0DGXasxucItg0DPV3TBP3tvfD1IAK36zbBq3ZAiL6Juf9t3Ufgg4OoQOgALd7/I/XhwqP1ehj5QDn3jvb6dRhcqec292KdOUhYl0P/oxx8mN+fqewuFsLcS1rKEXg3NFJfodbRlR3/bMcvpJ5gCYz4rWHeuhJY3zqE4ZcS7xGRXrtC4sQW4B3qgyn4vXD0XQ2LyCkT5wAmP1WGwIiG2rWMbXtBXRwmv48rN6lwPioc3XYL2KDnxq3+LcGvXbvmTnccR7SNaz6
 2vtxV3Qi
 jv1ucrOorv7zbt25ss8Mvy9S2A1s/LvtHcsoWFPRMHfM12zIksccXjfzXdxyfPs7hlZHDouMC1C1TKH28ylWukqwUYkJFIB/BOpW3N0PCifUlKhN3+yuxAZ9Ol6ikQ9RdUaAxY3W3syy9f57nUcTFRMxeTWXU6HmlAQFBdw1L5vJ6xFqk247FJPMY31EF5kQo7DZ+43VCuXGMo+mOIW7MIfoIeBjNjyZpvTQnh1krHC2kpIi/imUIljDPLNZ7T+TOQek8HqiAMLWoUY5TiE5QjJa8Evggu6EMyd7+VYSuDhSkB/zKSzAzkCqtb6Lq1GOyNdUTzu3GDcCv9QQ7v258zPN1PGvENvk25AsgjGjVUKRfbtBbjfyT26xDlQfas3gKl09P5HdhEk7DjCfFFgGudEw+4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  3 Feb 2026 22:06:40 -0800 SeongJae Park <sj@kernel.org> wrote:

> On Wed,  4 Feb 2026 11:25:35 +0900 Yunjeong Mun <yunjeong.mun@sk.com> wrote:
> 
> > On Fri, Jan 23, 2026 at 05:50:43PM -0800, SeongJae Park wrote:
[...]
> > > IIRC, SK hynix people also confused with the behavior when they experimented
> > > migrate_{hot,cold} action with NODE_MEM_USED_BP goal based quota auto-tuning,
> > > but using only a single scheme that does migration in a single direction.
> > > Because this is at least second time it made confusion, if you need, maybe I
> > > can try to add a feature for making DAMOS immediately stops after the goal is
> > > satisfied.  Let me know if such new feature can be useful for you.  Cc-ing SK
> > > hynix people (Honggyu and Yunjeong) so that they can correct me if my memory is
> > > broken, or answer if the new feature I described here can be useful for them.
> > > 
> > 
> > Yes, you're absolutely right. Currently, esz(effective size) starts from 0 and 
> > esz gradually increases as `current` approaches `target`.
> > Once `current` reaches `target`,  `esz` then begins to decrease.
> > 
> > However, we observed that even after `current` hits `target`, 
> > migration still continues relatively aggressively - because `esz`  remains high, 
> > and it takes time for it to decrease.
> > 
> > To address this, we previously suggested that initializing `esz`  at `target`
> > (or something suitably large value, rather than 0) and letting it gradually 
> > decrease as `current` gets closer to  `target`.  
> > This would allow for stronger migration when `current` is far form `target`, 
> > and gradually weaken migration as `current` approaches `target`.
> > 
> > Such a feature would be useful for us to experiment with tiered memory system :)
> 
> Thank you for confirming, Yunjeong.  I now agree this is what really need to be
> implemented.  And I agree your suggestion makes sense for the use case.  I want
> to take sufficient time for good design of it, though.  I will share update as
> soon as I get some idea.

I just posted an RFC patch series for this:
https://lore.kernel.org/20260212062314.69961-1-sj@kernel.org


Thanks,
SJ

[...]

