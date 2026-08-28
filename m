Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A8C3C61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 23:10:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18BDF6B0088; Fri, 28 Aug 2026 19:10:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13D046B008A; Fri, 28 Aug 2026 19:10:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02B526B008C; Fri, 28 Aug 2026 19:10:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D69176B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 19:10:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 513F61205C2
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 23:10:46 +0000 (UTC)
X-FDA: 85152224892.11.52BDDC8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8DE8D1C0003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 23:10:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RE1aXB3P;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787958644;
	b=emuJhb4soh9nPZqka5PLm1AiIV+CQLz+AKkSNdUQPZhUxc4aX9gFvaG/wAjgPrLZE6CDm/
	WyOz9VkE8VhYcKECcxf4VTwcBPEKOSGejxiDcbk4btWs1PMVYx6ARaayCD5v+fJCX/j5BT
	yxf9WA7JQPI9qVUT1/Ly+5Z17sD/8Yc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787958644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tQJbZfDKCd5vA5KNE4CASZSK9AFL5yPJCvibCadYbiU=;
	b=IC/vsnc90xj38Y330TTMFjxixal0+pW6XC9w9OXZeDfX5H/aFIra8K1wt1qmzP/Aav2RyO
	0LOXZVBSDaPm0/HIWxKSZo99eJZESrzgquAzfM6SD1wvmsfK5f69oD+UvENHhNZVD62fLg
	ZFNm/7RKOHOTBMSopgTf66DT+NeJHmw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RE1aXB3P;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 35C6F6025A;
	Fri, 28 Aug 2026 23:10:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA6A1F000E9;
	Fri, 28 Aug 2026 23:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787958642;
	bh=tQJbZfDKCd5vA5KNE4CASZSK9AFL5yPJCvibCadYbiU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=RE1aXB3PvH2MlSAawRZuYTTM0y5weCaUQiTHs3XvyUXIur027Q8UcO40pfITH9Gc3
	 5ta/aF5q35hGrZUChJmhJN+v9bVZxGYP8NK/2ppGNPvExKc8B9YXD9DxHxE9d3CpIH
	 nKhafDpa72aIXM45SwFEdSXE+7NH+7Fsnyxg8Cl4=
Date: Fri, 28 Aug 2026 16:10:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Longlong Xia <xialonglong2025@163.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
 mike.kravetz@oracle.com, yuzhao@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Longlong Xia <xialonglong@kylinos.cn>
Subject: Re: [PATCH 0/2] mm/hugetlb: fix surplus accounting and availability
 checks during demotion
Message-Id: <20260828161042.de43f4751296883eeca633a6@linux-foundation.org>
In-Reply-To: <20260823034307.1072415-1-xialonglong2025@163.com>
References: <20260823034307.1072415-1-xialonglong2025@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8DE8D1C0003
X-Stat-Signature: sejmjoc1ywyk7igpmfs59ado9ze5jsby
X-HE-Tag: 1787958644-704077
X-HE-Meta: U2FsdGVkX18zrzdnapx6uKyVi9L7/6q+TNUct4dgWFBZlI1OiJ03KhC1f4r+TtIrMX9AwKrjbNn6yvyzrnU8SsVFrjsztkL8qxrBNh+Vg4xx4FlLuUX70VWkDjBjAB7bc8ZH6gIIcs9u8/ciDL2ld262EY9gDfquGqFouYDtkOEA108wPNz349zEikVU4kJrxZxEMwDBFfXrpPBeOGw6Colf70cPZZh38n/28MIo/33RJSiCrx7boQQaQN9apYS4LoU6hO8/mY4r3oLHU84RWdPKX1Xsb7dyc9fWDt2FCx9Yq7PrDa2Nw5BxCBzFLG2bnGy6IYtH/DQgHN3WUFWKa8sb97JsYQd+SoqhREjEa0a3W78Y0K2g9pVb9TFXeYzy8IFKcDQDuVcWrQVbzfUHFAZkzfmudplal7mLMW0FkZCmv50JzQkNpKjrkZext8Bfuz2X9vpHQIMoAej/I5gH0V4rGvuBOJ89vVSe5S6xbM4iDno9h4YL9ZJ7QbXf1cJXtsO4rWLp0dl7iPQdCtWL7pCXspXEbq1abQApKhuhnqmMc2k6qYEfjY0d47owpbt1R/Pz2kb9CsT/la1blFPeTxM62YH4i0njensIUYBnWdhSMAONfTG/9uxqJPHI0gM1N0D9d+PkI8FJ2drTWqS6PGLa2dEAIP42J+rk18xY5Eqgxd7jK36HuM59te8FHv+Eyj5E/38s+DzH2gERJSklY5FYuW1d11FyORAXxgpeScr3rjei1ujCVmkcHxGHRg+gZRlwNCw64dtXi01PaXBJ74M+ssNpkwxl8ByIS2oq5k0ANhjQ4c9Izm8GZxR2fTTbMC/bE7Hj+Wrt9VZxrZZBAdgp4/cmNEVv4AP2ndclqmDV4AE+q5Jr4BKM+BRWum9NYFyPS5vav40gBhkXv3jb35jjTKGIZndqnxnmTwPP4uuzLCba2ZeM5IKnt/zdj6DNHeVYneQHNuAlaYpxjP3
 J9wVHVoq
 HpFbgeoxZkBM6+3wm8Vmt9/+T0EkjPnfXcu4AHvDTKgjakkdW4tYIZGEYDIDNOASUflJUs+Dm+he4/iz1HpPpjYESLVCM3RGo/wl9240mmA7Yxx5IcimBlI6R5WinoGFTsosh1KmMRQPaqnjwxZnfInPl0PuVgfgtY+LQWy7ykWlmhdZfhHG1e1q5rCbfO7ZPCCbog6TaCtmTqcGpQW85z1WspQLD5dgvh+xXVDcxMZIRnE6r1W1681lFJoUKc+8TwGH3CVTw/SEwXJM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 23 Aug 2026 11:43:05 +0800 Longlong Xia <xialonglong2025@163.com> wrote:

> This series fixes two problems in the hugetlb demote path.
> 
> Patch 1 fixes surplus accounting in the source hstate.
> demote_pool_huge_page() removes every source folio as a persistent
> folio, but a free folio may instead account for one of the source
> hstate's surplus pages (for example after a vmemmap restoration
> failure). Removing such a folio without adjusting surplus_huge_pages
> makes the persistent count underflow, and later subtracting it from
> max_huge_pages can underflow that counter as well.
> 
> Patch 2 fixes an availability overcount in the sysfs demote path. The
> sysfs trigger checks whether any page is available but then passes the
> entire request to demote_pool_huge_page(), which can remove free huge
> pages that back existing reservations. With two free pages and one
> reservation, a request for two pages removes both and leaves the
> reservation without a backing page.

Thanks.  Have you created and tested reproducers for these?  Gemini was
trivially able to do this for me.

If so, it would be helpful to includes the details in the
changelogging.

