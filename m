Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A9FECA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 17:51:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB8B48E0204; Fri, 15 Aug 2025 13:51:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D41148E0001; Fri, 15 Aug 2025 13:51:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7E358E0204; Fri, 15 Aug 2025 13:51:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B9A188E0001
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:51:43 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3D622C0139
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:51:43 +0000 (UTC)
X-FDA: 83779734486.30.5AB12E0
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf07.hostedemail.com (Postfix) with ESMTP id 920E34000A
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:51:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a8jYM6LP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755280301; a=rsa-sha256;
	cv=none;
	b=b8Lvgl6kEWztt4ARwxVkLK7BFaLZa3EqcNMMuDmDqQI9jcVUJY2i+aTL/ccz10U5ZL45vV
	MD0aZRYHTLAsWQmrwhdJzq6lUc+6EU4evshslVJNCFuLaSqKCqYipYqlkHRsQlzPxndoDZ
	6lPidxe7S4GwdaxE7/+ycD3se3pqCS0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a8jYM6LP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755280301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KCSbJI/Hy+C4u/9wMpXP6zJJ7aDcRhkGq6k+ECpbVMk=;
	b=XiIu3kOFgbZJrz4VNitQ+qdXaohUKmhKci6LWVT94dYQBQnxLrCQr3AWH+BVPWI7R0CO/a
	Z3sau74KWVsyi2v3w3kJMn/CKbTeyeSyP1UT5+K0K4rbTMo8rFoqkFxmjAk/58dmSPOc3y
	22phjha6p3SIsysdS+vXAhvnmHdNff4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 89B205C5936;
	Fri, 15 Aug 2025 17:51:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18EC0C4CEEB;
	Fri, 15 Aug 2025 17:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755280300;
	bh=Mw+kCsH1LEqRX0xIi485fYTMBbhV7nCPhw+PqbP2J94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a8jYM6LPxJ1nfo3vFlVGUXAJSvvI+tVL+q0+tmB3pIRf8QTc/ctpFqITt6WudDHkw
	 tRmqDg/FLV8FwkfFFgbMnXG0S1Xxt7KqwuqLZPRNhZIE2o24PSv5QlLhOaaj0Kn5QC
	 ROE8LCLuHSiTmsOYnrgxHJBeAkydgjq530XdDqJmCA/CCajp/V0Z8XF2ZTdSezb+MY
	 FBa+wv5deV09Y651KBhu0+eYliHc0TMvsXuqYlaevUpur9aanbCpP6FVPo2hyOKXYw
	 Jgnfk/x3X1bwsUbH74+2OgMEZdx+UreLYm0syTbSx+VIWbGj6OGdpQ2mLw8HoBGEll
	 xe8nG2F27MABA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>,
	honggyu.kim@sk.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	stablee@vger.kernel.org
Subject: Re: [PATCH] mm/damon/core: fix damos_commit_filter not changing allow
Date: Fri, 15 Aug 2025 10:51:35 -0700
Message-Id: <20250815175136.87287-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250815172545.16704-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 920E34000A
X-Stat-Signature: asjfwj743qcj9wdnnenmws7htggicjwy
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755280301-670943
X-HE-Meta: U2FsdGVkX1862+VoTGfKTYyAxEnlGCPQA/Ndp4RnoNop2JFJe0KeRn+XBtT48pq2D6VGij3gZTgqs/4IWvJc5K2iL2yMMjkebfrKiA3QogvlTeoO9VGy0lMKqdKh0o3FpUQFTUEmJWJer522gPcMQzZWGRXlOSLL7X/QGy+rNupebjfDuLYKulzlS6W4nr9rIwD0RVUB2D3HZ68qFYRw+TZZbanOgjQklOOjZlI9QaRcJjEGKULLU8eIZ1SgV9pQDLjsffRp4JrL+kmSGBh+lNQCgJ0hYsgcxlfwOExV3iqjA3Ugki2gchnlttAy9yx5ql7goRXhSHGXk3XPHLkoWeL8vQgyS/WqPsqYYvzSUMZjZx8Sw+LdzQJ5aqaMSQSIsxgYBpnTkAQ6bnSVWZSVEyqo830l2gYXYARf+wCLTJb0ESCL90myMd3wUTq0sgR7a989lXYeDhpnbai5PisUe934IKHRUI7PVo1khxzE0oSv0IazK658HKSGuFidgqD13qThoHsMVnjUbvM/5iNvb6ERDRQQRZCDFrsPWpoxDU9T/WwNz19gZFiqZ4G7E530vQKj4B44y6lKjAJXzF8HQRa70CmgbvrLzZL4Mvwf+o3tJPQD7uPEYVo2SYWBXiW0DM6C+z8pwsc9xzBHKtnlfn3Bag4h81c6SQ/hMfdBpUJYFpL1u1O6Y0v4XALvNqBRjhSk7m7iiPkvMwM4eoxd1E2eGrPiDMvkwR+QAIBwmR/Dr1nSq7dYi5glgEzfXt07sWlHlBJLCf2FyhiLmy9WWhzw6k15TL4CDsNpIsEGvsqLPP/MVPEDOEwzxRLK8bmNjs+ECchw3bYIvsbo/ulL0f+i11jMMNPecMRPAib+Qh5Ze+vXd4Th9OX1M+dqq36SuECV2ENSM11xLqsD49rvh3/MbXgxLs09BO+HL+SsOCdSbPu4jDSZ1gadukj/8RSxU3BKFerkXqZqcvnf4SZ
 kjK07pyB
 t9mh/ndkVD+YWn8Q3KlckcjnljA3LcXCP3zQkBI0qZFko5pcqfTl0bML8spg7TUkbDzrKmOCmNUjiGNEySLYEllUNoQ/ShrJLTEgJeHqaQCz11B+0ufOdLgk3KWk41JBFCZ/NZpsNVL+IhX6wGHSiTnBV3rfDZZUsysV/BO7SIQsVUefqfR3SLq/ZCQSypFVMMHSD/82J5UACHUXU62sQ3nxdKjAVrUM9rmmTyrat1EgqBrLEFlmEopo2qq7G8XuVmVOrKb3fWMw4lhfEILle0DNG6Fir8V4IU2Yy0jAOwlEm3ds=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 15 Aug 2025 10:25:45 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Fri, 15 Aug 2025 18:40:59 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> 
> > Current damos_commit_filter() not persist allow value of filter. As a
> > result, changing allow value of filter and commit doesn't change
> > allow value.
> > 
> > Add the missing allow value update, so commit filter now persist changing
> > allow value well.
> 
> Thank you for finding and fixing this!
> 
> > 
> > Fixes: 9cb3d0b9dfce ("mm/damon/core: implement DAMON context commit function")
> 
> At the time of the commit, damos_filter->allow didn't exist.  I think below is
> more correct.
> 
> Fixes: fe6d7fdd6249 ("mm/damon/core: add damos_filter->allow field")
> 
> Also,
> 
> Cc: stablee@vger.kernel.org # 6.14.x

Sorry, s/stablee/stable/ please.


Thanks,
SJ

[...]

