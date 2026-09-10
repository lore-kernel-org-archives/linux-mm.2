Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9F00C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4FF06B0093; Thu, 10 Sep 2026 10:40:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B00726B0099; Thu, 10 Sep 2026 10:40:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EF5A6B009B; Thu, 10 Sep 2026 10:40:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C2D16B0093
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:40:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AED5980509
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:40:17 +0000 (UTC)
X-FDA: 85198112874.18.E522AA4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 12D2B100003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:40:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZHeHvxvp;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789051216;
	b=GGuHtH6B02KGXgxd5w/YoGO2oNKkw8H0KZppEPGV6klmU81gNAjxyUswShEBPP+MWRbPbV
	aWFxZFoYCBzjE4RRVd4JnIlOBPOQti4xxqVgCDcnTmz212ZIwdRU0wwN6f9+0oh1S0WEJg
	0bJYG0D2Y/pZ8aj8hwNP3KUb3ViK+Kk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZHeHvxvp;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789051216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZiIRwFEuHdfHVtyCjAJ5wkFmxjF09C/RketUI/wtcPc=;
	b=vABDmMJoH3To74o4iPCLlRlHPqR1hAjnwEo7AvKrhoD+qJIgllqv/UlD/x2qPxBocMKs/+
	C79MG7dIxJiW2y7u/41yqTF2E7s7V1DKusDj8X0pAEntnVbIItFhrzxayWO/G6Jg2cFzUa
	/0zQvwJ9XbM8e5ab1aei1Xs8slLUy7s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6EE6360233;
	Thu, 10 Sep 2026 14:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A721F000FF;
	Thu, 10 Sep 2026 14:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789051215;
	bh=ZiIRwFEuHdfHVtyCjAJ5wkFmxjF09C/RketUI/wtcPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZHeHvxvptj4gChQtNiKjW0RmyP8s3WN/X4u7TguJSn+uC6oPiO5iLn3mV3KfmUjwA
	 u97EK1rsmi1XOyQtyLiwvn9wi4l9FwDcSwEirpD4+vKLIOvcVnJ2pvmPQRKwfUPJ2v
	 Bj28PoLfuqdse4OEgPvWiifW0DetnkLI7iCiOus5jQSmFo5SoGye1IJAbboNH8h0r8
	 KuJEOnMT04yTd3amLajpElescGmWt8/yEvdnF07vTX3Y3NAKYs/pKDM7kZ1QmOf5UR
	 IwgeobKvlq+7+R95uAbuTL4KM2Krnj/wXDCdfZMVcCYSyVupGPo9QqBwdLxt7AHRY3
	 dU5WNxHG3umPg==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/7] mm/damon: introduce probe_hits_wsum DAMOS core filter
Date: Thu, 10 Sep 2026 07:40:07 -0700
Message-ID: <20260910144007.174043-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260910141849.170896-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 12D2B100003
X-Stat-Signature: qt7sqby133jh3qyqpkk1m1iwi9y879wg
X-HE-Tag: 1789051215-178439
X-HE-Meta: U2FsdGVkX1+tNVAKv8X9ZljJam3wMjGKgCzuph47Rmtyda4Dyo0Ouy5jtjKeo+pRhhwDXErQJz5V7Cj60REN0XxoAvccUqoeXSRXKSXqMksKZLe1y9TXC4op19LNgJQYamCNNQ1LJl19Qd+quzfs9sQStubp5G/KLRYqIuUyPLppfBHoeRPlgDu6rXa872DgaqesR2XWDQX/XMxb5K+61hDb2ePZ8uOkxkQT/P9pQ7FjkOxbqOYXxJpkNpY/KY8K52pHwy2pbQpIdWO+9ho1EpW1q+jcHYPTOL6beGQxpqQSBj2b69E+jd8f0EXKoVNpjWf5HTK4I1GHkdxrRrS4OLLersONov+dqhcVzjHDdQMkoQZXJiuT1lRJSr8hLMnCcjrolTplwT31dftYpDUPGJsIMgpz2vqrjAnl7KuStzDh40qpsJaAHF4qX5bhZoemTgb8XxVTjvWiJ2tjh76saMNbclcg/8Xw8dZ9R5le2WnJ/J1oXbf852TCQ0KVJ2mL9ESOGST22EBGMVu+ylQBSOZEri19p6SiuIgFCKf+pAZpkFS0e0gDHPFUHuECSeMkDhlZu0eOK5xKdD8dCG+blU/xGcsXbeUG3VdLCBmMTbAl9zUKDGPpQSqso6OIqvXcLjQk1jchn8oVGUf1MHSNMzmRE6ILTQMzq1Mk6nXJvgDtw3s/SFznJtAUasjvq7EXkgT4zGLTXHBiU3Fm8SB4R+qdH4tyHH/MrVG/BlSUYKwqZKBaVZuvGdftHC4001VNcpRL9KUQg5fLXBh2mD+p/0b5wkEBLrUf/NK1R9ySZW5t47lOogKAkiXMNA7h61TUu/prXPcd1f2Bl0VCrVD/dEaZqe3g7evXQNrvGR07dBrVo61T7Yx2fBD1m+kRBVfRoTvFAjCy9RZrgt8DQ7IbI+M5IN5RZ/RSG1T+S0VzHuaKtxc4CtFXGFg6TNCG7y5PiBE41mLR7BiYASmQbn2
 XghM056F
 rHqBhh43TbzyBZfL+BQmqekgbClymuXKPKtLs/trjQRtFoEVX8U9uLMAG5b1+9h5XLvIQceaHt/3NBVFghDvyYHcubrEIFwpSptHYkI9iG2KENF9LOMW396BtzTODMkGj7yGOz1WCbw661lmWtvER1WWuZyY9ytKF58N7JH7zV6UjtjkEZIrW7OqRRJRrbmmVBIrBgzLAEvo7omNRrQyFfsitunbX7FGjfD3wc2lsNoqing0/hw4DY6D9WEc1LZVa2ZcP5HJAQsrQhaY9JIT89V6Tyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 10 Sep 2026 07:18:40 -0700 SJ Park <sj@kernel.org> wrote:

> DAMON can do flexible data attributes monitoring.  The classical data
> access monitoring can also be done using the attributes monitoring.  The
> access event is just one of the data attributes that DAMON supports.
> Users do monitoring to make some actions based on it.  DAMOS is a
> feature for automating that.  However, DAMOS cannot utilize the data
> attributes monitoring results.  It is still Data "Access"
> Monitoring-based Operation Schemes.  It requires users to set the target
> "access" pattern.
> 
> DAMOS core filter is effectively the same as the target access pattern.
> It is just a more generalized and flexible way of describing the
> operation action target region.  Introduce a new DAMOS core filter type,
> probe_hits_wsum.  It specifies the filter target based on a range of the
> probe hits weighted sum.  Using this, users can apply DAMOS actions to
> regions of specific data attributes pattern.

Sashiko found a minor issue in patch 5 that is better to be fixed.  I will
send a new version of this series after adding the fix.


Thanks,
SJ

[...]

