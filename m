Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 887D4C9EC94
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 16:18:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE4596B00A4; Mon, 12 Jan 2026 11:18:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA4B86B00A6; Mon, 12 Jan 2026 11:18:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBB226B00A7; Mon, 12 Jan 2026 11:18:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CBF646B00A4
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:18:02 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6D1B4D12A0
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 16:18:02 +0000 (UTC)
X-FDA: 84323818404.27.79E7101
Received: from flow-b5-smtp.messagingengine.com (flow-b5-smtp.messagingengine.com [202.12.124.140])
	by imf11.hostedemail.com (Postfix) with ESMTP id 537584000B
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 16:18:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="i 5ey/lM";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=ScyZpglJ;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.140 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768234680; a=rsa-sha256;
	cv=none;
	b=JD1RoT90SIqe0qJ0+TH+aKhQn0BuBov+Ut8s6/WeE/maaq/DMQinJbyeKRaKVycfw3rw5f
	Wcr4WOJ/292BUirXWMHlRJgOl9OwCOaE8ATKYozOg2uZ5q3Y5aNTtJ4QMj/8LQALYyIwJ0
	R2X/8DctrYr9zIzyxICvb8xaDNsiPR4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="i 5ey/lM";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=ScyZpglJ;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.140 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768234680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BxagfD+pocrF1KsIMzuZEdccFWJZvdf3BM7nAN0GhJ8=;
	b=eUr9S6K6ZmUtcpNBcJyIo7FePn0r1Au7iNJSJHtOvDSDBNFSV7Y8pHxhbSrmUochllUesy
	S6HkKfHjEarnNM5RSfgc61s7eDTJ+nq8jX2YjxSdg+L1wPXRR6pMesbZ0zQ/uMQDvuQ3SR
	ZC5v73OZ2qkrqQtIl91r+OdRuuKznYY=
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailflow.stl.internal (Postfix) with ESMTP id AF3B413003B7;
	Mon, 12 Jan 2026 11:17:57 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Mon, 12 Jan 2026 11:17:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1768234677; x=
	1768241877; bh=BxagfD+pocrF1KsIMzuZEdccFWJZvdf3BM7nAN0GhJ8=; b=i
	5ey/lMS4YFIFUGI+mKZAUoTWL+6TdJqjcNgk+iNLnCpev492coPtuD3C+kixY532
	MvSIPbBkj4p05uTh8k5TuVdR8WBXavKCn17t9CSHw5u1EuWF7zr9Z/VQ+PfC7cTa
	09D2Od1j3UgaBdfBbxZ00pZfw4qo/1b5wudPZOpVgasMqu4sYMZd/W6Ujl/jcMV2
	fvobRZdTu5hJt+uYhgsA+OK6yHRJz3K21OgK1b0ryldp+cnKJjBxAZ1D219ajaGA
	Kd6LU3QYU3MyxQ4ifgF4w5UDRPgpZbCkWJKxG4sz/Qwvw8p0h39RBtAQpaJlsUkj
	HX2zAl6oqfip1Uc+h4cFA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1768234677; x=1768241877; bh=BxagfD+pocrF1KsIMzuZEdccFWJZvdf3BM7
	nAN0GhJ8=; b=ScyZpglJMB3T8ym26saJTTpNpq9hEGLTZsAI0bVeJdkt/CqDqeT
	O+o1+cQshCbHsZo25RAL0BHSliy2Gvk8maKIPrWbExjy0ar5KZA/XLbLwFPEXkXo
	2PbbicSMo5emH6wJTEhObztwRDiwOZUOSJnIV/7PZbQ8lXgTsGMQIdjWAWpOk4Bz
	Bk9MD27nKSHuwr+H4h+M9EvF/8IymiKEZriqYrVylJfIAUJXD9YtyayVPJXhGhWA
	Hc+D+oRYrtEcSifovAAipHWTZxDbrToRj+k1q6rOESl3yqddJCN5dwpd6wuCw1JO
	7VofoPVglhPNTTd/QfCyS7twN4W1FQyUObw==
X-ME-Sender: <xms:tB5laTJTKmHE1fEeSqNASzBD7nHTaXwVGmAR4u-Uq5H3dGYtNe7yGQ>
    <xme:tB5laVlpTcZHz1-VzL3cL-oQ8S4S7YHSfhv9G8Phj3e2DeqYbJQRU-_Z55EEPVjZM
    5Z0eCwEu3g54p4JhXObpjOmzTV-tAtcqkrUij91ogG35e-7mudR2qc>
X-ME-Received: <xmr:tB5laS1YFEfBsUoxIH-98EYLqVIfLEAghtQti7iEKa3GjMh0TixVYkQDcAbflg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduudejleduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepfeetheejudeujeeikeetudelvdevkeefuddtkedvtdehtdetieeu
    ieetjeeugedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeeh
    vddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepghhlrgguhihshhgvvhdrihhlhi
    grudeshhdqphgrrhhtnhgvrhhsrdgtohhmpdhrtghpthhtohepghhuohhhrghnjhhunhes
    hhhurgifvghirdgtohhmpdhrtghpthhtohepfigrnhhgkhgvfhgvnhhgrdifrghngheshh
    hurgifvghirdgtohhmpdhrtghpthhtohepfigvihihohhnghhjuhhnudeshhhurgifvghi
    rdgtohhmpdhrtghpthhtohephihushhonhhgphhinhhgsehhuhgrfigvihdrtghomhdprh
    gtphhtthhopehlvghijhhithgrnhhgsehhuhgrfigvihdrtghomhdprhgtphhtthhopegr
    rhhtvghmrdhkuhiiihhnsehhuhgrfigvihdrtghomhdprhgtphhtthhopehsthgvphgrnh
    hovhdrrghnrghtohhlhieshhhurgifvghirdgtohhmpdhrtghpthhtoheprghlvgigrghn
    uggvrhdrghhruhgsnhhikhhovheshhhurgifvghirdgtohhm
X-ME-Proxy: <xmx:tB5laf-tmIyfYwLJdsPOKMaWJM1z0HCjEg-ZzbPhbYROjYzS5V3HCg>
    <xmx:tB5ladxLTbRhbghGcnqciZQxkPMJHZtZ6zhfZQ7uQpTKe56vs3H2Mw>
    <xmx:tB5ladipgrh7jFlDtkJTKtV-wmZ9w1RiRm0j55y0iUgHbBKbqUxdbQ>
    <xmx:tB5laQMUiVFSUMEfHT4FLyhYcmogIy9rMPiZYM10F0TB--K_VSEkUA>
    <xmx:tR5laToLI3vZ4YakgTF_EX1upYyEiaYorPlNLZw1qF_vSx8l8Rj9G5vL>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 12 Jan 2026 11:17:54 -0500 (EST)
Date: Mon, 12 Jan 2026 16:17:49 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
Cc: guohanjun@huawei.com, wangkefeng.wang@huawei.com, 
	weiyongjun1@huawei.com, yusongping@huawei.com, leijitang@huawei.com, 
	artem.kuzin@huawei.com, stepanov.anatoly@huawei.com, alexander.grubnikov@huawei.com, 
	gorbunov.ivan@h-partners.com, akpm@linux-foundation.org, david@kernel.org, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com, harry.yoo@oracle.com, 
	willy@infradead.org, yuzhao@google.com, baolin.wang@linux.alibaba.com, 
	muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] mm: improve folio refcount scalability
Message-ID: <aWUdHYjHPQGpF-92@thinkstation>
References: <cover.1766145604.git.gladyshev.ilya1@h-partners.com>
 <ec023298-c26d-437b-a023-b49509f83c5a@h-partners.com>
 <aWTfduyPXjhymyzW@thinkstation>
 <d9fe0fb8-2c83-4eeb-8513-853522909253@h-partners.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9fe0fb8-2c83-4eeb-8513-853522909253@h-partners.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 537584000B
X-Stat-Signature: efbqo7byeki1f1nqoaurusfaopdokwo9
X-Rspam-User: 
X-HE-Tag: 1768234680-218869
X-HE-Meta: U2FsdGVkX1/6VHjM8gonPnSYWc8qnvlYBPMZXMveoaO1EG1RNwBUyu4Ti8k/JdFSYfUw3iPYmahRZIfbaD7FJ7/2GYbpaUnl+8qyfEVGzsqVnbVaK+auecPa4x8acvLwYPRnGJdVkrSw6RjhF1r/RjJ8Zamt0g6uUmcyQNGi/oqRfq1QSGLmF3Lzj484rl00czEqh8NAMn7M6pg2GGQUjF+xoR0Rt+ZA8MOJm0UZFfI05ea6V3Ci+CTlypYStNOHdn/r/UWF2FUGRcNh1/NtvKiShU6L0EXO/4BQPCiEJCgI6WBZMRVyOnBDe2BjTgSVpfa3NGRw+AQie2tjwTmkZizUFdMOO+wfNrYnJUqRd4zKf4A3f7cJA88U7aI8AqEHc0jTC449ypRcagaykQ/vVr6YJQtg9nZv19cGIXa4PkMvUWm0q5K7J8CHyys51j1pRt8EeR9IrniEEIiyfyORrGNkecbnyxBw+XJh+u0/Ne4iBLO7WzBZCB50MqzWmNG+vmYiZaS/g6iALnoD6CNzM4xXMghbrrO5j7PFpN1ZsbBA1kNZReAvNdd5MFK1qOrTwph9XDjtNRdL/ECmOdGR1WFrIjavXBWj0oPy7XUrZXpU0lNDFPcA5maZHaL/tbcDD0Cts3NU6NgHRknL9LVFj9Am00QwtjcvNOgUjWA9GmA8Zm5vyaIux+Ca15e/FX6z51dBYG4LC8cokHc5/xC7BWuhRuIIEGoYOVvn5mA4ghmB3A+q24VWauQrJg3DGyMTfNJr0tqWv3S5HpfbCaHTtVkLrKYrbIxUOdvemjyFL8RyPlT9uzZb/OB4pDliDgltLa5mHY1/yZpeor3ChXUn6cQPLgqeUoEimEB4r5Z35ij/l5Vfyr/lO8021ImitPr2Jg1vNFn9xhjzAM2KPdMW7lK6hEZNkn2F6+szoj3WtEXw+RksDzg4F/IdwImI2Nh3Yc5k62git+W0xWaboTG
 xeylCWHf
 Scl2yVA6GB0tMeeyONi/Q0j1UCst8oabD2ONiaAiCNsqmfwhRQ7wPCeixFZEqPEWSZlwKpywUhqMrtrYqppR185PCMRZKP2aO4lGbwDC90B3pYjhqMSmzts9HCXz4szhMQN7qe4j9gIT2WhRsBlYF+iwiKjrg9wjziYXcJdpa77sZ/9M1dd+AfqyoQuN0o3k7+f+BjB8G/wgKWF5Sr/dSDg52ipnPHpCIn9Ol35eBhtxs5JZPxOC+0lE3KiLLxupWxGUeZbWQro2rX3B/bXtiPIU76ld5j9UEZMRQbDiOqiGFcLdYr5nWnJFoWOJeEcM5mYlVpZdO+NFt87P8kCysm5S88SWRzzByPgGGbtKLmL1IGHP7ryygHHvPcdaYSaG4IryYdQ5IA4O42QI2aoFeCSZ9SL5AJgWG/aR44PVnfF6vuStwpaFFCj7jZT8nTpHPyixq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 05:32:10PM +0300, Gladyshev Ilya wrote:
> On 1/12/2026 2:49 PM, Kiryl Shutsemau wrote:
> > On Mon, Jan 12, 2026 at 11:30:38AM +0300, Gladyshev Ilya wrote:
> > > Gentle ping on this proposal
> > 
> > I generally like the idea, but I would like to hear from folks who
> > actually understand serialization.
> > 
> > Also, do you have number for "a full CAS loop when the counter is
> > approaching overflow" thing?
> > 
> I am not sure that overflow is a real problem because you need a very
> specific race condition over a long time to achieve it...

Yes. But if the page is popular for pinning, GUP_PIN_COUNTING_BIAS can
cut the "very long time" substantially.

> But as a safeguard, everything lower than 2^31 - #max concurrent
> accesses (~#num cpu) should work, so let's say 2^30

What I meant is when we put a branch/loop in the hot path, your
performance numbers will likely not look as attractive. Am I wrong?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

