Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C49CCCCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 04:36:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06CC18E0007; Mon, 13 Oct 2025 00:36:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 044848E0002; Mon, 13 Oct 2025 00:36:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9C3F8E0007; Mon, 13 Oct 2025 00:36:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D20738E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 00:36:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 67F3585EE2
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 04:36:41 +0000 (UTC)
X-FDA: 83991830202.19.D7B3160
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf30.hostedemail.com (Postfix) with ESMTP id B99BB80007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 04:36:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760330199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fbwzHBnlz8cioHrI6BAZV5K21Tovpnntl4to55CIXiQ=;
	b=ec1J/14zSe9uvj+mCDrmBk+1JQ48gzH8qgMgLS1zCDY7zXjGKly8hdrTKI8Yg88v2CJoUH
	HfXiCYjipyHQ1tZupU4UuJLYBsenMSi5kKFvXLiZN/5dTR2VYbeIOlbozx1T+eGe84VeYk
	+z89Ge5QRXtmsKiV4Qkp6WXfE9jTgo8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760330199; a=rsa-sha256;
	cv=none;
	b=iVUMBdlYzzTV5nAjVNqgvGPnD6/UKwN9RUUhMfcip9E3jlHuoUpOuqLZJVpcTZMVode0aU
	FSLx1hZah4Sc1cqp9aG7nDXQ7e9GKEko6wEHBazjTtfeFoHbs5QfNsxXd2mYNlm/8TynEa
	fGXug96MbWQIvHviMWVLv1zJtghJiGA=
X-AuditID: a67dfc5b-c2dff70000001609-b4-68ec81d4371c
Date: Mon, 13 Oct 2025 13:36:31 +0900
From: Byungchul Park <byungchul@sk.com>
To: David Hildenbrand <david@redhat.com>
Cc: Yunseong Kim <ysk@kzalloc.com>, Hillf Danton <hdanton@sina.com>,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: Re: [RFC] mm/migrate: make sure folio_unlock() before
 folio_wait_writeback()
Message-ID: <20251013043631.GC6925@system.software.com>
References: <20251002081612.53281-1-byungchul@sk.com>
 <20251002220211.8009-1-hdanton@sina.com>
 <20251003004828.GA75385@system.software.com>
 <20251003005230.GB75385@system.software.com>
 <3b66d603-543d-4616-92a5-9e6e32f116be@kzalloc.com>
 <deb6c0a2-e166-4c91-9736-276c9f1741c9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <deb6c0a2-e166-4c91-9736-276c9f1741c9@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsXC9ZZnoe6VxjcZBtMP6FvMWb+GzeLr+l/M
	Fgd+PmexuLxrDpvFvTX/WS3mfjG0+LJ6FZsDu8eaeWsYPTZ9msTusfD3C2aPEzN+s3i833eV
	zWPSC3ePz5vkAtijuGxSUnMyy1KL9O0SuDL+Hd/EWPCUvWLlsqwGxm62LkZODgkBE4lvO1ew
	w9jHrr8Gs1kEVCWOLJkNZrMJqEvcuPGTGcQWEdCQ2NS2Acjm4mAWuMQosXRtJ1hCWCBcYnr7
	ORYQm1fAXGLFrjmMIEVCAsuZJL59f8YIkRCUODnzCVgRs4CWxI1/L5m6GDmAbGmJ5f84QMKc
	AnYSm+9vB1ssKqAscWDbcSaQORICe9gkruy9DHWppMTBFTdYJjAKzEIydhaSsbMQxi5gZF7F
	KJSZV5abmJljopdRmZdZoZecn7uJERjsy2r/RO9g/HQh+BCjAAejEg9vxu7XGUKsiWXFlbmH
	GCU4mJVEeM2r32QI8aYkVlalFuXHF5XmpBYfYpTmYFES5zX6Vp4iJJCeWJKanZpakFoEk2Xi
	4JRqYFzx91jHTpGov1Yf2c1bfbsnG0VdZap9vcRhxhmBHAsxVqPjHVMZF095zb+p4lWD4MW8
	K+IT98fcVapa8OviSvuz3BnNf5X/KHOcDOK+b1T0gNnvjHbfS8U7y/mWOR5SOnpMZAvT5Kx+
	qYNu/+5P3tZ1MO7PUQHOSrO2S6HaeefiTtg8jOG4M1GJpTgj0VCLuag4EQDaKre4cgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsXC5WfdrHul8U2GwdHzShZz1q9hs/i6/hez
	xYGfz1ksDs89yWpxedccNot7a/6zWsz9YmjxZfUqNgcOjzXz1jB6bPo0id1j4e8XzB4nZvxm
	8Xi/7yqbx6QX7h6LX3xg8vi8SS6AI4rLJiU1J7MstUjfLoEr49/xTYwFT9krVi7LamDsZuti
	5OSQEDCROHb9NTuIzSKgKnFkyWwwm01AXeLGjZ/MILaIgIbEprYNQDYXB7PAJUaJpWs7wRLC
	AuES09vPsYDYvALmEit2zWEEKRISWM4k8e37M0aIhKDEyZlPwIqYBbQkbvx7ydTFyAFkS0ss
	/8cBEuYUsJPYfH872GJRAWWJA9uOM01g5J2FpHsWku5ZCN0LGJlXMYpk5pXlJmbmmOoVZ2dU
	5mVW6CXn525iBIbusto/E3cwfrnsfohRgINRiYc3Y/frDCHWxLLiytxDjBIczEoivObVbzKE
	eFMSK6tSi/Lji0pzUosPMUpzsCiJ83qFpyYICaQnlqRmp6YWpBbBZJk4OKUaGA8vSl52Y6NP
	j4nbeZczotd2zbWXuZVxm8snXlHkm80926W8F61z+HYeSpqWb76LbfNWg/9/NRJ2fltm4eax
	/mSCyWcjsdwD25Kv8LXm3jkl8OrGXAGxMzrLpVh7ag7PvvOelyHqq8rR6De5myaYZaewlP2s
	+5h49ee+w3sv5PX+viQcLhkhWKHEUpyRaKjFXFScCAA6FUjaWQIAAA==
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B99BB80007
X-Stat-Signature: xijpeojqa1i4fmdh4xn4f8ircy4dnb3z
X-Rspam-User: 
X-HE-Tag: 1760330198-511936
X-HE-Meta: U2FsdGVkX1/xzEwH2wEldI+jEPIHr2eC2Ie0o+XP+Mel/Wh2P1FB69PWhvNo7/OKM6obwgJxLVgKrWHgUzcu+G8W6tvFelr9cpoGLPIY90xE6tzsiEDbq6dY4ZLrLhPHtZmVwDN8HgfjlwgREDB8dZIouQmTM3yg5fDDgUREBgwWaLZmM+mCQCF1N/WQJs1I+8y2gp291J6HT0MlPaTS+5vbikU+ghBKdQY7+OnJqt5vgYjM2M5WmTLyOybL0JBXTd8v6Amg3lRNisG6sgOHADwKudVDc1Eyzesr9z09o9nURTBedSatOr87ikcUmEiYveOZE16uqowKsoY6YFJZzJD3FalokERDxwNDp/6h9kuQRwOv2Moat2NLPG3JNftIV2sAXHy8JL8oXotzM53kZnj/NqHbBNZtp+oJsDTYsNkfJU7nUswPiE+QIb68kB7KGL4GZlKdyXhMuLEowZuBrvqJQFSyVLIwak9MNFuoN4Hm4uLKy2QVDXHCF+GX/VrTTVGZqSTsWSmrc6aQejIW/4/ebI7+IXyJIqbLYeXJmdEacy3qqnBefRRr+qHRsKxTAmqrr0svhm4lvAWqBuWvXDI5JVShQ3JPAMTWVB+ozIaLvpgT61yyl8p7KdgL/fO+I1HDInThS+jNyBhAn6wgNWwFpP2CStr110IG3UXrCmS46UQp4qUg5ekUK0oG4PcLEtZB3JS6wP1DUeB5ANVjM+g3rRBQWifPbjJrFZ7+dMCxWkYEF32nBTmIbGTrrkLaXQGbuG59oMJ9+L9QPnAVmhYhAxPw8GxfqXo28L1zYyewOdLYMQ9XCdrjnMxpD9Y9HTsqiIpesGfAs40UBRS6Qfdwy4eHAvTbl4dYO0/KbeIYJ9qiKQGNR9SuWHwdkWQBko7IRc65OEvzbjGdnqfFWtvz5hBUM+HCNfrqbQ2qC2DuhmWOXnu7l0wqn+Qeq/UptAbC4SJ3eYn3WP/rHQW
 /WQdDAj2
 AGvBN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 07, 2025 at 09:04:59AM +0200, David Hildenbrand wrote:
> On 07.10.25 08:32, Yunseong Kim wrote:
> > Hi Hillf,
> > 
> > Here are the syzlang and kernel log, and you can also find the gist snippet
> > in the body of the first RFC mail:
> > 
> >   https://gist.github.com/kzall0c/a6091bb2fd536865ca9aabfd017a1fc5
> > 
> > I am reviewing this issue again on the v6.17, The issue is always reproducible,
> > usually occurring within about 10k attempts with the 8 procs.
> 
> I can see a DEPT splat and I wonder what happens if DEPT is disabled.
> 
> Will the machine actually deadlock or is this just DEPT complaining (and

Of course, it was an actual deadlock, not just DEPT splat.

However, even though this patch resolved the acutal hang issue, it
looked mismatched between the watchdog hang report and the DEPT report.
We are now re-checking it using the reproducer.

	Byungchul

> probably getting something wrong)?
> 
> --
> Cheers
> 
> David / dhildenb

