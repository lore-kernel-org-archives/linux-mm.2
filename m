Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90819C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 14:58:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 885AC6B0088; Tue, 15 Sep 2026 10:58:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 835426B008C; Tue, 15 Sep 2026 10:58:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7242D6B0092; Tue, 15 Sep 2026 10:58:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4FCD16B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:58:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 121C4120470
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:58:34 +0000 (UTC)
X-FDA: 85216302948.08.C13AEB4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 70C4D40003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:58:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hHfmlG5F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789484312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JTN8lMc50PscJwhdMYkWxf6DIrkJ3RqvGR5lgJYuR9c=;
	b=ZnKIi/23PBy0nnWxTgkZA8I9y8m9X3Q2CCKsH/0+nsTlKxoZ7PJmROgB971rh/Ws0rYyqC
	1MAdGJPtVNN+MZG7TJLiFMiWIWTfF/UK1SYVRuOMzZ0J4wNM0xuy+ifhYO/YMpIdQ4Ntp6
	0Ak94Tu68knYUs105fpXLAyb5lc2+P8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789484312;
	b=rU85kY2204sQDLhMXiS1AwzE7yWpjp+f6RURdDIVD2zAIQp894g6D9EpAdHtJx2g7Y0hit
	F0E8iJUcQRqMJslvzdDy0JefvBn73++MI0Tx7bvBrjpSy/KSjw94QsafBgCdh98s7Vh3mV
	9iYLAiBa00rhlWD+uezGFiyBcZh5KhQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hHfmlG5F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E3C4D60142;
	Tue, 15 Sep 2026 14:58:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180CB1F000FF;
	Tue, 15 Sep 2026 14:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789484311;
	bh=JTN8lMc50PscJwhdMYkWxf6DIrkJ3RqvGR5lgJYuR9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hHfmlG5Fu0AY30+2hg8Ux4vA66SpyMTPZnBgbGv9qMTPxneg9BYhXRyg1thvljVKx
	 1ycbjf1gqqCz+CbLqlhC3IL19bBwYHsn1HxBeYFMIlV6GbZJdTg5wbsCPGOtj/iixI
	 vSqCilDfIhpEaLEAyy83YnRU2Sk7FoNUX86pCQPaYhYemLdGRjDhpk0U4CP2sGA5aQ
	 ASLSl8eslkmyau+KEtZ9KfmMUUPdokRIhHQO+amkGCBq2gFc8Ye77sP0PGQSa2ybP1
	 wNEb8ZRBQI1iWgCoeKQ04bRiDBH2+IsPUaPICk/HZHTCs8S4P+cHRLw/tH/qgfDaVi
	 y9kECvbDj6qeQ==
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
Subject: Re: [PATCH 0/8] mm/damon: introduce hugepage_size probe filter
Date: Tue, 15 Sep 2026 07:58:22 -0700
Message-ID: <20260915145823.92329-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260915143359.91472-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 70C4D40003
X-Stat-Signature: boxzxrz51idta5u77yyfin6gzqph6dhf
X-HE-Tag: 1789484312-107187
X-HE-Meta: U2FsdGVkX1/41YIR7mT85T9+qFhbU7pfpVI10S1ICPtVBiXPvrgQAs1wRw3PUQoBeVy1o9n95LDpU7RuBQfU9ea8Blii7kfOBnRpCgwmReKLGAWCYndsXzrlLYkDkCyxMlGJAMg2ZCahO3ecDDAZ/NbyI8779Np6nK13X2WNrdFXVtpN+ETF2IOrn6XI6dPxvBZGuA84NDMhy1x6v7pjqi75wbbNj80wce+wbBJlGKdJVry6g/Rj0usqpn18T8NSPn8tMSjKEch7jzt8BFAdiVCedvXmlnXBNc7x68rDSD+SFrLhbZbmpiuNCFFdxY3iRNBnQoEyf94dHLThrCt3F8BSw1sC61rdejZauQdG82ELeKYqhn+Af/GlsZ5aJmQ5Kl/WY3mo+vjt+Qlrk+IyQSfYcW9AAhGifXaZ58Cai2zsAQ3JXU+PUmJzIs0YaoaPE+Y8vp7Tm8IX2205fJQpKxrIgzRJdIiawKrOLm037ljZvhIVhJzk9mxevABk1V58dO8v6C5zUKaooe+wC0laZ1qIIaIRDlDFp3Mx2ByTOYgbYyQhedDVxH+D433h0m/6z5NMTUswX6lQ/EIbvGPT9+FEZn+u4FgXLFC6siMK4q8DtbwpdpD4cf91I43i4543USkl0MwejnGO1XVy3k/VepeQHUk1AgngCPz87f/G5xH0axawJkOfHrZrcKwoUboMhe0i0OW107QgFuvywkHR3O3rgCOOrKbkS6/A+j5Jm9666Y0r8cZETHbp13e7RsSpzYHtXtZFxtoKn5+t3Hb7141yLBpGM2oeAO7T3jTpt8AYbuC7qS8HsMbGXyqWQU26YFceI056TU2ikBaAijP4m++kQdjmGESVolYZKIEi7M8M0CCiNSzPZoc/NvQA1gkV4PsB2pVglch9YEkPh+5C9fiX2fV2yBWzUfgSlv9G5AgSXvK8Z0onY2qYJPqFkIQOQOLzD9MSd55ZojV9vMG
 ZYWasnAp
 W/dXuIaHkw62uT9O628Dd6uxPgnKq2JeZ5eM0HM/ZOkeQxUm10aGJGf37xEzSAidn2qAckSquTVw0p/ClrzaglXYJepp2ME3f4sDAvDzUvFMvZr9VMvT5bdGgjr8z7cfR4TFOngMaq/NloDQ9b6p1dWxmPVzq1Tdu5W+80T4Imm8aKZWJ841bvXZ88VirURVHBIjWIrFnaP7t3ITBNMg5UzxNG5mYt8OYG06FxJgW5DfkaS8WASdO9S6OQmJ3wkE1/soNjD4LSSmJTP2aHoWRQCHSfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 15 Sep 2026 07:33:49 -0700 SJ Park <sj@kernel.org> wrote:

> Knowing whether a given memory is backed by a hugepage of specific size
> is useful for efficient utilization of hugepages.  For easy monitoring
> of the information, introduce a new data attribute probe filter type,
> hugepage_size.  It works similar to the DAMOS filter of the same name.
> It works for memory that is backed by a hugepage of a given size range.

Sashiko found no blocker for this series other than a grammartical error in a
document of patch 7.  It is too trivial to respin the series in my opinion.
Andrew, could you please fix it together when you pick this, or let me know if
you have a different opinion?

Sashiko send its findings to damon@ mailing list [1], and I reply those if
anything needs to be clarified.  Please refer to those for details.

[1] https://lore.kernel.org/damon/


Thanks,
SJ

[...]

