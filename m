Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DBFB10854AA
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 00:18:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8ACB6B0088; Sat, 14 Mar 2026 20:18:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B38016B0089; Sat, 14 Mar 2026 20:18:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A43F26B008A; Sat, 14 Mar 2026 20:18:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 937746B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 20:18:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1EB3F140974
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 00:18:20 +0000 (UTC)
X-FDA: 84546385560.08.9BB0EA0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 63D1C4000B
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 00:18:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B1mfvhIr;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773533898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=olhnuRvcjv4k7NIA8mxtQfLu9spH4Yb28/CLzdW9jQY=;
	b=j5Uu/qo3m3hxz76+PhEsjKImPbfWk2U646dnDKCp08KhCks8LtITdqRItNvmvWRw96WxZK
	U0pFCBLiVD6sw0u3bdDr+u3Pw5VvBnkCVSlrpWft5L63SGLhJOGqDS/oaGeEsL8YtuqIWM
	UziO4/AdXXQLWhwq2r9IomzViLmwEgo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B1mfvhIr;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773533898; a=rsa-sha256;
	cv=none;
	b=e9WQ9rYpciCQA8uJUgEuYIjeEJclD6ob0zw59Nv6lpdqpJPLTVwuxiA5Pp2Z/LxRZN17CC
	sAVH3yjT8IuJDbSdKKu2u3h/gs5uNr1p8o2yqyjDW/chB5AlfNp9dop8MbsJUWFZaMzsdG
	OMQoX1YspGhxC0nz3OrK/zG8CCOSCUs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 72E48407E0;
	Sun, 15 Mar 2026 00:18:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27428C116C6;
	Sun, 15 Mar 2026 00:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773533897;
	bh=3KrYYqBFao9HexZl8dVIaZI1Ujoz1XwPkmSGsgT1YxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B1mfvhIr63lebUuyx+nRSgcVy5qyzJYvVEWDc7rnoUHJrE4d7wp2F2HMTKW8ct2Gw
	 LmfuCbxL7JewypYtCy9HPjlvDT7hUzsbsZfkAr9tQk+2dVAj0Ztkl760OWSGAEaVDi
	 zqTIUQ/j/vbQPrVmmqiqVGEFwSH69MQlmKzOrDysJVK4T7a/HGBREMYEG17zD7Xipp
	 eQZEhFC2efcF5ktTFvH7wgOYWaZYv6nlpbkw8OKxxCQEkqGJPLYjdtKvZeRWjnWLr4
	 QoJKE0ttdNLOQH/VnBNNJHXhdhPIKBMqCJXAX4uIxTy9xZEjKI+M2x3hca2u60Ldo4
	 rh7f4+9g8ct+A==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH] mm/damon/stat: monitor all System RAM resources
Date: Sat, 14 Mar 2026 17:18:08 -0700
Message-ID: <20260315001809.77161-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260314155109.5e37efaea8ef72f169434d35@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 63D1C4000B
X-Stat-Signature: ri4f65u9mnzo31orqu69dkowhecwwkkc
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773533898-50442
X-HE-Meta: U2FsdGVkX1/UUoNFL1ipz3PFuCaIRwPsVvgIvP7MNaZDfYabVJTRkZEnUYghgzle7s8VCY/wpYHn3AJYsv0QSYnX1Ke+ltAe8B5c/syBxHdw4rkhBnVX0RO0MHYZgAThAQfRk6I6kJmtnjebDaRyhhPJJ8gMtE9xqSZxH4LSAwzcW7da1QwBCHgb0/Iums7yaWVD2DFUl1JHJUnyoLU5DSqgjJ+0WCmuRXj9Qe1tNM0gPc7VEY/Dx5/VyN1XDE+xEDHctKHNF7X1dQMiy8lE7jduYS/3OfsVIm9LsV7by4yPWgpLPiKsHW6qhfXkn/cWMfmW9P3QwePUJZu0CaGeQnY6TGo5H3tjAuDYXjV5o/NIFrk1M328kCIhUfBgl85XAnVahGlX8gAA3rnAqWe3HHtzfYRlXqZafi9VcKE0lcvhpCiuqFugBsZGYhcQI/tESiuXupBogbm/PKssWIzwWOnMY6iXKX5aGVkskCRuovThXERLU0A254n3WUbPtevn1IVJaUbK3baNxQGOmaYyg7U6ly+sWjMxAWYTn1mzSMk7l/ZqumJiMCkg3ULw+tgFOsxbiPVJbUmrf1BmhpC3IswgdafN9hoN7RKPftd6IpfV3Lqyd0RKE2Qeo7EfjszFjEP+24lL094ZJOgeKaiLFfZ+v28jSqFJKx+IptFcoGwStBgXXjlN81u5Bg0z1R0NAjurpqx8G7hpY+YhOMCFxYadYBxSG/6q+CvoKbS6jMKq9nsLmXuEsVvinFQiL2dM0IHBVh8rx2LuDBGTIE2T3D8Z0Cc0MgGAHec98q1Nyerfi312J6Z2IyqJK1jdl/G0uYp1Paatx4EOSEwetwclN/ag6PturM2KLgVztlUyrzfQ9iLRiBSLnLFFFaFbqFXQGTlblHhYZ9OPChgT4U6e3nDpzQKkFT55/2qO/rK3hQ6ivrP32T82S7GMq53tG9C14Uan4PDdEl87KgvIHce
 GMNONHGC
 Fcywteo0ZK6VrnHNZXS5Y7Mfat+HXxibHWqoesx6W8GKLVlc4icpcuo/FgnDiyoJgehYzQ5FZVS/xI0Zca3OXDuXU3xKp4X3r+w3Gdnznyr3F1kt7NbeOKAjj93lIUFW1D+Ds8fN39mXnP8U8fSTmTBhHhm5CbCRbEJyXy3yoQRfV9bnxm+CIoVGG0l7kmhE8PJYn9FwMiK7q4nZbw9UdA8IvCK0bE51L6r6+KJ4V98shFavCIFaUR+qKcmrMKZZkakX1u5hI4PBXsO2/y3N9m+1hAVPKYoHbkyoTIN6RyPR2BihJyF7eeJykOwD78T+b9XEIkd9acSLt5UVz5uqOjwKuzhb9gjfMBsbFRfxRBz1sBG3xcS5l6pMu1uNlT3LJHJO1tyYqId6dnmkEQZtDRkaLmU5TMNxlKkPL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 14 Mar 2026 15:51:09 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 13 Mar 2026 16:40:22 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > FYI, I found this issue from an AI code review result [1] that published on the
> > internet.  The review also added two more comments, but those seem irrelevant
> > to me, so ignoring.  I don't know who made the web site.  I only got the url
> > from a social.kernel.org post [2].  Whoever made the web site,
> 
> Sashiko is being led by Roman at Google.

Thank you for letting me know this, Anderw!

> 
> > thanks for the review.
> 
> yop, it's good.

I'm now a big fan of it.  It is really good, except the lack of the dark mode
;)  I therefore added features [1] for showing the AI reviews on the terminal to my
mailing tool (hkml).

Anyway, this is really awesome and helpful.  Thank you for developing this,
Roman and the team!

> 
> > 
> > [1] https://sashiko.dev/#/patchset/20260313044449.4038-1-sj%40kernel.org
> > [2] https://social.kernel.org/notice/B4E8DdeZY07PseemfI

[1] https://github.com/sjp38/hackermail/blob/master/USAGE.md#reading-sashikodev-ai-review


Thanks,
SJ

