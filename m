Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 663B0CCF9F8
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 02:56:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B66C58E00E1; Mon,  3 Nov 2025 21:56:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B16EC8E00DC; Mon,  3 Nov 2025 21:56:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2CA68E00E1; Mon,  3 Nov 2025 21:56:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9333E8E00DC
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 21:56:12 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3ECC34A68C
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 02:56:12 +0000 (UTC)
X-FDA: 84071410584.08.FC620B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9A0B4C0003
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 02:56:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HkBDPEAQ;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762224970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pPb7ZJkCQeDW1bnlwOr31lAwhLgOC0IpRfiFA8/m940=;
	b=5S6Ov1vCy/UOkPwy/ZKVHBV9K/eqgC8uKiEvIOImeWCQ4zEkGMwsbm1j2zkjA7eDYmudwQ
	xCZE68JVi2Ntcslyl9Emp7ssGv3GlZfqGWAazpEnKqWLZo1tgQsAiFG2yMHKkntK60EGCY
	a7llT04ptB8NWLiUkvcZiM/xlUuTT1g=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HkBDPEAQ;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762224970; a=rsa-sha256;
	cv=none;
	b=TzpICi/k6z3ZIi+EPeu4YaS8ePj3TK89OHPxs+ycpCh1/k+a0VW8597p3LVSgzqBtxlOcr
	LaEj822judNEEiT+6IWhG5dk3Tk1AoY4cpHl4Bm8uZWV6lXoHgGAqjrltwbVDMf+9XYGdw
	IgOa4zf7oRWPGRnDB/21CrK1M/yJu6A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0000A601DF;
	Tue,  4 Nov 2025 02:56:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A21BC4CEE7;
	Tue,  4 Nov 2025 02:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762224969;
	bh=e1ksvYvy9wyyXuqNDd90pTrqbGM9/wp01OAnJwOLx+c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HkBDPEAQOXrI3Gg9U2MfFvNROwTs4e6c15CvvnNlWvp6OmG+UR75ihDJP59ErhLj7
	 R3isc3ieoRdKgC/5CYH2t2H35OXUcMtE3LKn+ohLi7NxMu92fyg0Qx0r/ishxE0Ya8
	 coOlaNJScPuqfe0nULrIHQPszOF4l1pCP02wjz0M=
Date: Mon, 3 Nov 2025 18:56:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Youngjun Park <youngjun.park@lge.com>
Cc: linux-mm@kvack.org, Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song
 <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Chris Li
 <chrisl@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] mm: swap: remove duplicate nr_swap_pages
 decrement in get_swap_page_of_type()
Message-Id: <20251103185608.84b2d685fe0ae4596307b878@linux-foundation.org>
In-Reply-To: <20251102082456.79807-1-youngjun.park@lge.com>
References: <20251102082456.79807-1-youngjun.park@lge.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9A0B4C0003
X-Stat-Signature: 3584fxnimz5ku7ecjgfwn71zp3ex1tp9
X-Rspam-User: 
X-HE-Tag: 1762224970-484506
X-HE-Meta: U2FsdGVkX191X9/7x4iqptddpcq+C4vIGSFOceltRI5/ZFn8NweDB/IyOhsVIqILpJgnZtFcozV3deCvNJc2vw9wFv8VI1BvPZiww8NVjLfbyzqz+NjeghYPvtgN26gSJoTZZoje9al8086M/18iFbRz4N5lgxYIv6uPaM/Tldy/tM0itTrlC0qCuojFDDrD3grGlqNqOsWAqGkr6MFFks/ZnAjdInKWdt/A/AhoDyWu5xA1zHL9ODsqxn6MYoCKI0pVBjOGOfXjSQ8Qog1X8Rsfs/pXNMHnHQ32LJt1fw3WokED5xhnDZCYF1+e7sfoMZN1I0vTN0psSZlO5WC50Yxscjt1n06a5NsfSLC8n+wDl5DL6mqgPY73y06ijrI1NA2B8BxUKO3MB33VMwWdeV8Bo5/wtFc/vvPN7WkXtCmnI+1hwuF0cdmCJtYORJg7uCF931F8IeKfcbJDVoviG/txxXUmOeRKhP+M4xXanWt4WVm4uAOfHdqSXa2Wc/ZjrrKZ9c0t5MBMC8cCb9QWrl+4ZZY39PplL12qibqs+AODgfO9OFPdTsvj0eIvFsybsAjGNTqLMHKc0yBV2p9zNhDB2IA5+reYSZ7l9rNmzXkCgaOaUOzC7+m0AS7O5xwFQYWTDp26BpPDlhfvp9uaSdlYN8v0YuvSeS7kc0oX2iVoF6/JZWFXZAmBecGU32r1njRoFnGleKyG5e82+Sr9Y7z26WMheiUy/lhzvKO2fwPvRKPjUCQ3ZWkNvf3fK5U9o5jQfnQ7YDIWfIA7lDXeLpqLa41zsDDM6tVh6OU33KbF4QHLj2ItiKLU3grfnod6Apk+5se1D+DzCkPY9bUTqJhKqgPyV9e+qr+eE17v8s1C3cuo7R5q+oVt5oCXbksybsQ5d25TEQngjWRDNADRnTw8DyFuoP7H8622jDn1RC8PaFXyUPMYuLcarDHQwze2xWCg5pYIfmMYBlqKyyy
 gk/gwPL3
 gVtzo4kCPF1y459WYTrJf+BM3FF35o3E52fy6BirzY3dJ1RWr2Jn8PyOW0AEp5NZuqu105EZ3HZFd7vFNsXMxjrWL1KSiQYAiTcdgK2iFVChBDGFyb4sBtXH69W0KpOU/2MIfk55Rc30rvlcWjw57WGUQ/l49DdNvpkz2d9WTwxOilmYTsD+XYJcINdoNr1AiEsVT63XeBDBkDJFNnR+Cnf72Na9Jy/6TI37Yi/IzCmY//qYL/tyqA4S07IHCEnn39+NFOMBnBoMrGKwIErXA4+rwhn3/S3017K+v+L2DSUnrofFYdJfs6z6s47HwgFXW0jw6tho/heo1V6m3S1Y8Oeg38EzDCb43izj8iqax1RxSjvflfquERTGR1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun,  2 Nov 2025 17:24:56 +0900 Youngjun Park <youngjun.park@lge.com> wrote:

> After commit 4f78252da887, nr_swap_pages is decremented in
> swap_range_alloc(). Since cluster_alloc_swap_entry() calls
> swap_range_alloc() internally, the decrement in get_swap_page_of_type()
> causes double-decrementing.
> 
> Remove the duplicate decrement.

Can we please have a description of the userspace-visible runtime
effects of the bug?

> Fixes: 4f78252da887 ("mm: swap: move nr_swap_pages counter decrement from folio_alloc_swap() to swap_range_alloc()")
> Cc: stable@vger.kernel.org # v6.17-rc1

Especially when proposing a backport.

Thanks.

