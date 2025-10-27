Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08DEDCCF9EB
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 07:54:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 281E28001F; Mon, 27 Oct 2025 03:54:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 231FB8000A; Mon, 27 Oct 2025 03:54:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 148DE8001F; Mon, 27 Oct 2025 03:54:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F3F3B8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 03:54:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 977E813B226
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 07:54:18 +0000 (UTC)
X-FDA: 84043131396.15.B36B66A
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf28.hostedemail.com (Postfix) with ESMTP id 08412C0006
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 07:54:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="t/gXiQku";
	spf=none (imf28.hostedemail.com: domain of BATV+f89618a03c6ce0da8aec+8100+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f89618a03c6ce0da8aec+8100+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761551657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=Vmdq/ZHu+PZLiMTjDMtz5qdHSqtXgHatw3Ko2ORTjmUaEa684Lp+kEWFNLPLzME7rz05ok
	1eTm03TxEuNnuZAQQb4vn5LWInwmPqPh8Vn5pyeSbi0lldcMPW2QVa+xY+wg4fdDboUXmv
	9EqEmRuT4tfn6WN5r2K2owV3NqubTEw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="t/gXiQku";
	spf=none (imf28.hostedemail.com: domain of BATV+f89618a03c6ce0da8aec+8100+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f89618a03c6ce0da8aec+8100+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761551657; a=rsa-sha256;
	cv=none;
	b=fP2vMD8XToNvWH75kLuVJlhoGKZCRBZpi00dzQsDZtedCgbZaSuZBgEr1Ibe9GzaQJw0xl
	9P/1rlkBcpAP2p5NwqOgDDjZ2l2VYkTMTN3rP/o2dfPgJmc+F6C5hErII5WaZZHRoejtqX
	94RrcwWHQ8N7ibON6WM7fFb3lV7io+I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=t/gXiQkuTnG2yI2p4BkN1b6Xb5
	QOBArQBoWxCuyT00CDyXXgpr+/NYSJU1KQfW5oOPidw/5wHPCux13N3o8X587nKyYiqMdIrDckBjh
	dkHM63tNXsr+OWIPMhHpz3wcSiKILtNiBBlKYE0HaZnsHZMPwLhs+gJfd6E0JiJ1Jj8qgpHCjHtE2
	iwPslEif7tXXuSH++a8LlLGFVSxh5WG2uqDNaxB53GWpkfZDhvo2mkRBadZwedKa1kemmqHwh7KaA
	NIlRZ5aYTW4urgg1AKRGpZuZ1nKtoeU8eDjg2msPepaghibGuiv61uB/n0bnskEJm769mFwum3OXy
	w4U55lAQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDI3R-0000000DJ7k-3SXo;
	Mon, 27 Oct 2025 07:54:13 +0000
Date: Mon, 27 Oct 2025 00:54:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 10/10] mm: Use folio_next_pos()
Message-ID: <aP8lJYc3olHusUTr@infradead.org>
References: <20251024170822.1427218-1-willy@infradead.org>
 <20251024170822.1427218-11-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251024170822.1427218-11-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 08412C0006
X-Stat-Signature: zee3s654ok6cak7o5e7cfgt3nmr59edz
X-Rspam-User: 
X-HE-Tag: 1761551656-903331
X-HE-Meta: U2FsdGVkX18V2JbDQ4fflTJ9TV3oYJNuVQ1iL6A8wG4bAQOid7jkVBlALczVRPHA15wNT6KqUFBgi2tg4dXYJ5TG3WYq1F1IIIQkilXzAb+mtapFjxWVC3OizUP3K4Kcg6Szc0WBV4nRvEKMMcSFn/U0DFmvfy/at9MCOk4alFU8mk6TbG/zMEhHor+t2U3H3U5h2fODMcrUH809vKxXPMU808+lFHD4ES4RXFAUYmjLpLxwG9DYQ72cyZutKdQZJb9jcYyAs2tCVjF/HqxFyCFCoUe95E8hMwq9iLfjg20Woi2hMSDfPw7GVRLCV4KiedHwZcXr66jejMklyZBZ1K3yLWIIl2GgVpWUNZa+RkLnLySOX4I+xlZ+ItShaVmIMfEhZIQUnE1tz1CugCsNBbVgEimz3vBzaLdaa9YO8lv72nLsjRD68K/LC2y0ckIpLi4bGvS2Vtz+YsoFlyUOUO3fOcUER7+ZQjv539KJA419vaeLdIa0o60PPSfMVYu+tMCAwRF2HH7lt8qqBlrN4mPGozPYac046Btb/lo8yaQIAgyCev4XVfGTDjge3XfMcg7Ovw3b1qSSff0Pk7wQ8RIgXZijipdkHpudg5llG1+/e7w5WTFr9wwxBmrcV8a87kitgJmowZcyU+qxtqNNR4uq9VLBqfweL0FA1pTnNZ1VEo3BVlrD0b+fbXp62J0K0x5/Vd8Jm4gVzxCT+QSwxXO13bQmRa6DvtQlBNDFrenuVCIX79nlc46pbyCX9WhnHQfjb7LPnLhI2aK3Y/LeV45SX693v8GGi1AbHbzDcBoehLiSDj+kvA/4gpTgTfLEhr0DvYhSa9coK2Z7c8MI0WdKJMv3bjF2hHUvMN0Aq8pKoNp/FALJkZ0wHe0PFJ56R+NiT1/bdlWmCwCKH2J2+1Dbbk/+DLWrBbL13pWoHwp+F8kFeRZxpAKPqBGNqsUEb+xUHWuYUWMnyr3o9+M
 ef+ZYvpx
 jxhFhPmapMlA3LpyqJcGZprqSCB/z/oYWa/0pz0NtUS98dcERsSc8K6q4YlX91Rxg03I+Knyc9Kb6nbpWA7eH5fm/NAUf/4LPNYmraSjhLqctuoUbj78EGV4/Urlx3Lsj2mppd9Q7xXwkYlKH2kj8IEcuwv3Q2L0OKnmuCF0quw0pt77F4Px1N4E+o/E03GiDEtEu6iJ6wBybmLnHXaQZzXeOYnPxnx27xYDDp8dpoD40KWdvqJb3wsQWskJgLQZpx/uKoBoOAVyWoqucd1heDYHq9HmKamJZ1ulDg7ObHFf6j+paHbpI/ONK/AaSEK8OCcs8Ztydl6cyiNBIWWrn5IahnguDb3HX3YL6o6mVy5pTOTLoxzWIUKAPVK6wlGuGuuhg2gTzK1t1QSizpuTSgbkM1PM/05q0BHhPqiDCKB5SiWd1CxGkgGDa0L5bRWw9sDlmmdXrPlFzz9QyN4Io5+8+hkspuRyyVGlD1GSdw8cOS7rL55nh8RaLcIGTASishBfMfVeSD8Y4EGy3bY6zaWZoHClWlWin1nBLffT9g6qDG+UJ3A/GM3Ocynqx5OtDVSDglnbqEEm/NKe0zKOq8JALfT0XDRjxY8Z8TmeinZBs3osNjmVcAmifoFuxZfXDa9WDl8Jem94XGNA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


