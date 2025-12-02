Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DE5ACFD376
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 11:10:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA3106B0008; Tue,  2 Dec 2025 06:10:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7A606B009F; Tue,  2 Dec 2025 06:10:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B7666B00A0; Tue,  2 Dec 2025 06:10:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8169D6B0008
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 06:10:02 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2F61E132A7D
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 11:10:02 +0000 (UTC)
X-FDA: 84174261444.11.35F85D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 66CDDC0010
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 11:10:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Fn2joewc;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764673800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UjkaKs7+wssbM2g9NjDQh9mg/vMI7P5mimxwqyaWLFI=;
	b=qx7b85tzzISeRMUaRmjFRKiYD08xLSAHQeFcQoKeIQGho7IXYpiEh2uOhv3Qt7Y6dsfQBw
	gFcvb4yD3qsUJLW94jd1GIvuqZ+n5MrHrUxxwl6Frd4s2UG95WOm2gFWCoqdHomXocdSZe
	5liZX6l6w6NZEmgrkO4RjSlVep+X6A0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Fn2joewc;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764673800; a=rsa-sha256;
	cv=none;
	b=hvN235pzqtAqYeQ42z2WImyxFFTuGLTNILH7n7eiZXCLlYToSOWN4ZGP+i/3OH3ftDlX3f
	OoBv8PBlBp7+wjBf3sgSY/YQOk9lWSw9tQ3sD7vqGO0gRDyREulzfDt08WkBR9BsBRVbiP
	UzJX8rUvNG31c+tHp+ZCksOVgxHvyIo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5FEE743C53;
	Tue,  2 Dec 2025 11:09:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F088C4CEF1;
	Tue,  2 Dec 2025 11:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764673799;
	bh=NUvfwWwI0D471lVrBHXy3OOf20x2Bgx+jTZnuVt4B2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fn2joewcmYGvn1Q6tt3QuSfBi6NG/OXseJjRdnBQlgwBmvB7S0xyefKzVXfzswJ7u
	 xRXBlYA1BF70k4DnAGXCk4lvZsSohqycAE9CacsarpZVTu/gx4mx6MMv6YAU2wCFxu
	 WAYqSHDIZj8EoTBaDN8IyoQDO+mW2dYqw+XfWCvChjivS49SMtaACUl8OZlWD/glFh
	 LG8WI7Okv+kUgF78MS1NRQpZ+ZBue0vzrbWBSoHOW7NJ1Abv+MNIyCEkKiTDnNKvhP
	 vO/mGTdBgA/eS5k1c1x3F2Fed0gwpFbHn/IaKTFEeynpIz8SadtTOPGvGMv8wYp7WS
	 yn/u/Jb8/CuuA==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	SeongJae Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v3] mm/mm_init: Introduce a boot parameter for check_pages
Date: Tue,  2 Dec 2025 13:09:49 +0200
Message-ID: <176467374051.1009192.13862809250568196121.b4-ty@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251201180739.2330474-1-joshua.hahnjy@gmail.com>
References: <20251201180739.2330474-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 66CDDC0010
X-Rspamd-Server: rspam02
X-Stat-Signature: ntrq4wax3bosatxcaoi7r7b3xhifym5h
X-Rspam-User: 
X-HE-Tag: 1764673800-484303
X-HE-Meta: U2FsdGVkX18CuJ3MSv0d/Hu3xYQqM2KuHOa5SlLYy0Azsrw2slbsCHz8AyRcTiPpI1zCdxp4FtvUpFg4yCb0i3WXRntdKC+tp3SGx7G1q8mBXzOJB590fct6Napqqwz2an88gDI+6DzRl0LFe2wajhQne3DAVBAhmkS7Hm+pJx1Rz80Qv2hJVrY5h0cBXDWHi267WZGx6rcUJmE7HhZ/lwAZCGRtAhvWtWFlqOj1lxoJ2d+9WMdTv9NrWKmOGKVJmSL2xdHGmMrvWgNmaWmKgzPWkd59e4tU8LzkVhS+XTaKE25tl4s/ZrSVaDKc1qXVLKbnwzuAVL6KV1isqvxvs5YkijmQX8zB+Xehg/9ktuDYfD+phbRDhR+vIKc/pFgFfTiz0fUHyzv78lu1yqS3s6yoUKD6agwjDRIRMQf+JsxL6+lVh058qcXe4StoqEUhu9viDGb3mRftzIVwIB0nBfrZtEWtaPUIMtiPrq/q2Go95Z2ujJCeO/dMi6DoBU+E6p9VGQsFIJe3OVWqCWi4PKBEk0OOCMeiJKnyD8AV+Bya+rVJkL3h6evRt/l5GYq70+CO9Y3RSq6UIfqTZ1B7FUoXvh9T6TvcZm3Bu39knTiwp7tw0AwHGCsLkCt9MnlAfbUrfJE4kbcKaus24iR8lZzaPFaTmfbLemH77W1EgPn4drG+YY6HUt0Bns32kLfzFh5CZI8Rn0ZU6G0ZQHQF2eHuUaib3tpXArsIKwUfQ3gyFcoRYH6GJygO1ns8PL57YTHortSgj64llAPnRkXv+jg1q31tElqVtKljfn+lKCdoaFhTl+BcMxnkKi4d4Bm2S63bX2iTqpV0soO5jdTaVjjEYCcxuMs3kzb+8qh07Shf+XRqgMHXhtyUejvDmpwP286AUhDygrHlYDt5oPQBEqziqyDQFpo0VWHFHE0tFV9hIzT+ncIqZsWXa+IMKj4bCSfIpIXHidI7MSAoDyq
 wsIrhZes
 PZAyDsJ3yDGITehFSHpqPq+aMQT/NnunhiTdIKkb1Lz93MqzG0+gaJH2Gk1d+wCXauOuLVx4+vYYkHSeIDQ459WmC+DQP+UhEXQzEcp8Suk+fA/FMpssH9NPKmQkUpSOsZi9NcDaSHfDc7YTAPy0HJuqAnBrIsgW6PsN3yZfJ+r41o84EWXUjJ0qRKNWN6SJ8ZRgNGEJ2cfCVeEePXBrFkbd4Sv22K2itgdowJyZx53jFP55CepEy1wyNjyrRCFWEnO7wZW/7Yr8GGk+SFQ/r16boGTMGfm26zWP2v7gCvfiu00QuwD5ScRkWVBcFkvkWYd9SxZxtQiHW0t2Lvu9hXeA1roeEvaf0rW3UEvRpHFZow9k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 01 Dec 2025 10:07:38 -0800, Joshua Hahn wrote:
> Use-after-free and double-free bugs can be very difficult to track down.
> The kernel is good at tracking these and preventing bad pages from being
> used/created through simple checks gated behind "check_pages_enabled".
> 
> Currently, the only ways to enable this flag is by building with
> CONFIG_DEBUG_VM, or as a side effect of other checks such as
> init_on_{alloc, free}, page_poisoning, or debug_pagealloc among others.
> These solutions are powerful, but may often be too coarse in balancing
> the performance vs. safety that a user may want, particularly in
> latency-sensitive production environments.
> 
> [...]

Applied to for-next branch of memblock.git tree, thanks!

[1/1] mm/mm_init: Introduce a boot parameter for check_pages
      commit: a29b922955aa2bedde15876707532b982dec183c

tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
branch: for-next

--
Sincerely yours,
Mike.


