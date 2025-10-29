Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BAD9CCD1BF
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 01:56:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D1628E0025; Tue, 28 Oct 2025 21:56:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85B468E0015; Tue, 28 Oct 2025 21:56:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 723028E0025; Tue, 28 Oct 2025 21:56:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5DE688E0015
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 21:56:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 03B561A0696
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 01:56:18 +0000 (UTC)
X-FDA: 84049486878.22.3906AEF
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6CC19180003
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 01:56:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	spf=pass (imf24.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761702977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zwplIuk/MRGEYW4X8ivRoUc70BXAw+JZdbjEk+Wsuxc=;
	b=ph/1JRxOHZPpnv4e1mp6WG8wJ4qM8PpUEWM/gpw1K8mR8icUBT3o8s8kw2kS5ksBgBTdm/
	dryfe/UkDEMAyzh4BWo1DzgYTpZiUg5nDNA59A5o1iuexD9YHCKy5t/FODm1hmAGthI2ED
	y7K/z700/eW9xlAWcCyff4/Yt1nZ4YY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761702977; a=rsa-sha256;
	cv=none;
	b=FKNynK3v47S+yZ6jgOSZCFxlsvVzhkDu03KnTVcUqs7chBQlAYYEYilKdWh9FvznGVK3Mu
	LINqpilwd1221bFxjbttvuRntCyC1eTKCCz05aH9N/4UvcAZPUZuPAPBm4gRSTT19gqm0j
	2xZNwdGF04K1PYZa0/KgGx8BHfFXe1Y=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
X-AuditID: a67dfc5b-c45ff70000001609-f7-6901743d1673
Date: Wed, 29 Oct 2025 10:56:08 +0900
From: Byungchul Park <byungchul@sk.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
	harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
	davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
	sdf@fomichev.me, saeedm@nvidia.com, leon@kernel.org,
	tariqt@nvidia.com, mbloch@nvidia.com, andrew+netdev@lunn.ch,
	edumazet@google.com, pabeni@redhat.com, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, horms@kernel.org,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	ilias.apalodimas@linaro.org, willy@infradead.org,
	brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
	usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
	almasrymina@google.com, toke@redhat.com, asml.silence@gmail.com,
	bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
	sfr@canb.auug.org.au, dw@davidwei.uk, ap420073@gmail.com,
	dtatulea@nvidia.com
Subject: Re: [RFC mm v4 1/2] page_pool: check if nmdesc->pp is !NULL to
 confirm its usage as pp for net_iov
Message-ID: <20251029015608.GA37879@system.software.com>
References: <20251023074410.78650-1-byungchul@sk.com>
 <20251023074410.78650-2-byungchul@sk.com>
 <20251028183356.29601348@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251028183356.29601348@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxTZxTH99zn9t5LY81dBXmmm3GdZoYEBILmbEHDzBKfDyok+mXMZDb2
	blTbYlpeTVyqYhQjlSEqLSwDjbzWsJWNvgTMVqCAmM1UwetgoPhCVECCiPIi2GrM/PbLOf/z
	O+fDEbC6R7FC0JuyJLNJa9BwSlY5tqQqdlMW0sc/7l4HFY1ODhpe5kHNHY8CZpwjDFTUNyOY
	munnYbE1gOBZeycHT9omEVysmsZQ8U8BC88bZzF4fSMIHpdd5uBBYJiHBtd2GKp+yELLcTeG
	4dNdHBQVzGFonRnn4YinNiRusvJwvdmmgNLZSxjc1js83PBVcDDoXFTAQ38RC92OOhYmzrZj
	GLKlQKByOUz3jCJob3QzMH3qZw567T4G/mjt5eFMsJKDewVDCIJtwyycnT/BQflhG4K5lyHl
	ePGUAso7BvmUOHpYljnaNvoU09/rbjO0r+wnlspXrjLU6/iPp5WubNpUG0NPykFMXfWFHHVN
	lvB0oK+Fo11lcyz13v2Cej3PGFp0dJxLi0pXJuskgz5HMq/fvEeZ8cpn4w4EFXkNVX8jK3Kz
	J1GEQMQkci101Ds+d+T8G2bFtcR3vFQRZk78nMjyDA5zpLiGFDTZQxmlgMUJnpTJg6GQICwT
	jaSj1xjOqEQgiy/qcTijFk8g0ubtZd42PiTd9vtvFmAxhsgLj5jwLBZXkpoFIVyOEBOIvfoC
	F+Yo8TPyZ3MnE/YQcUogo4XX8NtDPyJ/1cpsMRId72kd72kd/2srEa5Har0px6jVG5LiMvJN
	+ry4vZlGFwq9WPWh+W89aPL6Tj8SBaRZooq/8IFerdDmWPKNfkQErIlUjZ4OlVQ6bf5ByZz5
	nTnbIFn8aKXAaqJVidO5OrX4gzZL2i9JByTzuy4jRKywovMls/ZF54ODxbryru9tm+qid3nu
	5+7QrS10zKcNDJiTTQmfXKI/Pi3eMpt3c9mtY6WuuaHUX9PZWNfwwpUNO7Y4X/TYU5N2GwKJ
	W0sDzC8l+RtTsrdZ+hOqc79aerfT/Y1nbNXXp2K/3DdiDc4n7mlUGVb3J+8aW9OS+vHF35pv
	fur/V8NaMrQJMdhs0b4Gq9SA+l4DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02SXUhTcRjG+5//Of9zthyczOxUdtEqpEEfRtHbJ14EHYoiuonqQtc65HBb
	taloFCwbZZbTPiy3ZkwlLbWEWepGVmxmWdGHpp2o1OzDPsSkzHLmbCui7h6e5/c8783L4ehL
	zFROb0qTzCatQU2UtHLD8oNzV6Yh/QJvLg+ummoCVT8yoaK7gYHh6l4KXJV1CAaHn7Mw1tiM
	4GvTbQKfAl8QlJUMYXA9tNHwrSaIwevrRfCx6BKBt809LFR51kNX+Tsarh2ux9CTf4dAnm0E
	Q+NwPwvZDRfCw7VWFgLFLQw8qrMzcCp4HkO9tZuFNp+LQGf1GAPv/Hk0tDgv0jBQ2IShy54I
	ze5YGLrXh6Cppp6CoWPFBNodPgquNrazcLLVTeC1rQtBa6CHhsKfOQTOHrAjGPkRnuwvGGTg
	7K1ONnG+eECWiRjo+4zFKxefUWJH0XFalK/fpUSv8yUruj3pYu0FjZgrt2LRU3mEiJ4vJ1jx
	Rcc1It4pGqFF76ulorfhKyXmHewnG2O3KlfskAz6DMk8f1WyMmXUZye7W5nMqpIHyIrq6Vyk
	4AR+kXA6+8xvTfOzBd/hU0xEEz5ekOVhHNEx/CzBVusIM0oO8wOsUCR3hiGOm8gbhVvtxgij
	4kEY+16JI0w0n4OEgLed+hNMEFocb34fwLxGkEMfqEgX89OEihAXsRV8guAoLyURPYmfKdys
	u00VIJXzv7bzv7bzX9uNcCWK0ZsyjFq9YfE8S2pKlkmfOU+3y+hB4Scq3//zeAMabFvjRzyH
	1FGqBaXj9NGMNsOSZfQjgcPqGFVffthS7dBm7ZXMu5LM6QbJ4kfTOFo9WbV2s5Qcze/Upkmp
	krRbMv9NKU4x1Yq6O3XeMWaKYU1B/uWOwkMz6kYSEzRRtn56TvrCh0/8CteS6Sv7NOMLXsXH
	jeriP0PbfeK4Ejq6ddU5zdOBM8GPul5tRtU63Z4cHbW5efEbU1KNNVNxQ97HrzOPixNWV9i3
	LMl/v6yMCXY8z45NjQps2p6b/DipJy748sXT16Fto2rakqJN0GCzRfsLmdJKBkADAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam05
X-Stat-Signature: owi3m73qzdpohuxtgrhdgk11kg6t8iqz
X-Rspam-User: 
X-Rspamd-Queue-Id: 6CC19180003
X-HE-Tag: 1761702976-456601
X-HE-Meta: U2FsdGVkX184B6IUdCCMAfR3W+JsQbYuUkIIgyw9gm8hWU6HhWNFE3KTzl8Z1pqBi1GJsM+g8gM3ybVD+78twEMAqz1rrAvtrZvEUjO5+vnICm1hMDBiCwZiZTL8QLhOOnb5yLxejZZILEDl9DhI2U8maq1KBMjU7P04hD+CtYMk8N8anWy+0Lh8AzirwUmFSR9QOL9QSd2g0JYthO0NgYIQ70Zvv7LrsjiMve+J+wvIVfWh0q8/n2hdlRGYFJAR6nRaDtYEgPeIALBmQjnOcCIpNM5b2yUBIVE1fT7lBegE54NQ2jUCZXkiIv3xG41nlc+A0MnOPZakEXzsI6qdZ/lNDX2Bl29ERTI1fRDwyMozh4afU9XONJdBVCFC7Ueq3iem9KkB6Hdu5fl0vAjc0iFups/pA0Zv4YQ6hlB/3gH5NvClQEyYGUxBLCdS+0n2cnQQBFJ5hMhecj1xQ6M7gnkTKIaagvwZLcMMju8jfiyHA2QJKZfJLTr2rR+HZzh65F2z6vVqEHBfjZTJEkt6Roqahc1ONsZ2t25REvnqYoqx8oCrkJRFi8fiVCxkwShWoB9ByehKfORmKPxmbcN6Q20/TOIu09rVd260KlqkMdTOtRypDq2E6e4vj+XfU0K7x0K6KO5ny2rrPRIU7Yow15Ld2cOjljQzhSi/Q77PpRZbJRvRQdP6ON+njEmKNUZ8l+RBzFXGRD35gyd3s/xHPPDsNZ1Yed+SdJ+M7yKVy4TqPiIGUr5FHbpeRppYbh8FOquj9cr1WQl1A5vwjmuxSKtDk1uhNy/Kfv4M6OljGu67vFQKfuHhoMMcPxHIjvXXM4LgdbaXXSitaAGcJDA0yfxe7XmDQE1zTTNxtdXo9c6v51A421eSzUDHu/5hCdDvHORcAsnoJcvbHnbo9hv1yeqfyCjm5nlkEuxg9Alp6B9/A7H6hsEePadJ2b243qptDJqPUGZCiTlzzpDWhma
 lgU/Pls8
 NW43D6OXfh9GxyO27gIKNd2wv83zmVE35hHoh8jHhOtYmV9P5ejtYF/aJM9Kw5YzINcwVF80beN9/vL5HaSY2flCgmMGunHxWgTCDuFA8NhgjHPznEjJFfBSeer+23nwvEtcOdH8rhCCFipA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 06:33:56PM -0700, Jakub Kicinski wrote:
> On Thu, 23 Oct 2025 16:44:09 +0900 Byungchul Park wrote:
> > As a preparation, the check for net_iov, that is not page-backed, should
> > avoid using ->pp_magic since net_iov doens't have to do with page type.
> 
> doesn't
> 
> > Instead, nmdesc->pp can be used if a net_iov or its nmdesc belongs to a
> > page pool, by making sure nmdesc->pp is NULL otherwise.
> 
> Please explain in the commit message why the new branch in
> netmem_is_pp() is necessary. We used to identify the pages based
> on PP_SIGNATURE, now we identify them based on page_type.

Yes, I will.  It'd be much better.  Thank you very much for the comment.

	Byungchul

