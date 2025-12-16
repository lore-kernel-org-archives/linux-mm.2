Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09768D5C0C5
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 02:48:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 404E96B0005; Mon, 15 Dec 2025 21:48:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B2B56B0089; Mon, 15 Dec 2025 21:48:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BEB66B008A; Mon, 15 Dec 2025 21:48:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 169566B0005
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:48:41 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AC2A2C044C
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:48:40 +0000 (UTC)
X-FDA: 84223801200.27.E3A7FF2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id D756514000C
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:48:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mHRSrcKI;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765853319; a=rsa-sha256;
	cv=none;
	b=yS7fyX8Pk3mi6BSStnHrKjrbcXTkPbaxFJnF0WPd1xc5zIo/m2pe1Zpev6C3xB15BY5HJF
	xEdOvpsN0tAxav78I2A6UgLRsnyhMRfqIZelcXY9S8i9R3uCcS0WSx2BKeBrwUCvnnaTrx
	CC6E8WHkcQg1s3bEo4uiKAY/lgjbrUc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mHRSrcKI;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765853319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Am8on7H1B6picEYGbrc5xSJQJqU1btgOGwYkP4/ViRI=;
	b=zq5nA+hP6BRB5qWs9ORdFNv4G7v82KirmF1ZMZLXUV1YBeVoi0XSLBTcC5LoQvA2N9I08r
	eZDVTcE4xEQZhoBLPk7yfPVUvApguqwhYzPE6roSWToh42AikpxuLpBAb0uKaLTjFYHssQ
	7MyGCPaFActElQ+JgEEPY/4pFtzn0B4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A0C1444401;
	Tue, 16 Dec 2025 02:48:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76C9C4CEF5;
	Tue, 16 Dec 2025 02:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765853317;
	bh=dLovf03U9H7G4zdKCI1UyiSLuE0DPzX4oZlq39p+rBA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mHRSrcKIhOqDFqdMNr4yYNulw7jpi8NXMbPsioKnQyshqkwKnozF3/NzflbuOgh22
	 Bvs/xcoUXC6sxswwOIVSZVNszqlioh3OB1oQe45ftXK+Jn4uldAU1Yct//TOCkRjam
	 RD86kIn1sS3Co00Yg2ZVeEjP+2fbxMAbOFMX8o+E=
Date: Mon, 15 Dec 2025 18:48:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 david@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
 tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
 chleroy@kernel.org, ioworker0@gmail.com, boris.ostrovsky@oracle.com,
 konrad.wilk@oracle.com
Subject: Re: [PATCH v10 0/8] mm: folio_zero_user: clear contiguous pages
Message-Id: <20251215184836.8c003ad094e8bd6bdb96f478@linux-foundation.org>
In-Reply-To: <20251215204922.475324-1-ankur.a.arora@oracle.com>
References: <20251215204922.475324-1-ankur.a.arora@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D756514000C
X-Rspamd-Server: rspam04
X-Stat-Signature: 48ooou9gatqb9yhaq3dje7iomas5bwdj
X-HE-Tag: 1765853318-853074
X-HE-Meta: U2FsdGVkX186qXDbRdR23O3jIGqeP0p+gX/ty8HOLTiRCkW9A8yZIDjdbyGzJxtX0KmR+zXomdXOAhXcMhXjc1bm0OHHGrPzlH7xjONzmSua2eHTr9ahAG131lU1MgQeXDn5iMsPwK3K7WSZxk7/XHIL/xXEzWq8VtJCGmcj+hR6fxXZMwlX7Y+yEMogZEDkAY0V3b6WjBI/KXutli1inALNmXWOTe+KMCutRyzXSx0zkO6P/WRzVq7n5XplD6Vs1ur4MOVhArRylIO3KQZQ7Hh5lQF7icz2uwjA74EGEgm+HN+ZaRRTrjrG2HWgF8ah7E7MvMrYRLFNrSDB5h6LbU3buxr01M2sKcY6bfNAshH0qQg9MYc+47554X+7/fMCNuQOMi6BVkUzvLyEW5Lx8j7Tw52sQHZXct7nxwHcqN8nyEBje84/qWC1K9Qbfyf8ibE2cqov/b/vU2RFNcfRzloEj13zyS8rv+8zekEt1YvWOnhfrsy9YCs718aT5MIsxSpO1ANZVuBUNc7pVBMpmh+GBj/ymPVWlj0+lUKb/ly2X1xg/QZlVLaAaHGeWuLDV9JvfoRYiYD6zelj068fAJqkbWyL/GWWzZ2n+CvxZrUARVhe6YFpWc7j6Hf5/+jyp+HFefOCU2nb3BomRhgeDEyn6iAoB0hdmcjLjwDu0yIcgnGE54lAAOnGuOYerUSP5EIJAjQFU60N1XOGEPZviqOtNo1zUDlnQ5o4lggmlxVLo9rmpWyToFdCNkBg0a4n6U2UF6UP+0eTS+lpYTdH2y+SgKHiNlBMRFLygaQUe9Zw59wP6pShn1wK90qYOa0vFqKMcle7Hi10fgNSEs5TQv4TU+JCcgmD3m8yIFDkTxttS4Nj18XPvnjnXD13xTniq52xeTxQ4ozbmUEg2EWYU5VukKIFlu5T9e/OqOsH8xXRGjJyP7GydNWPN9nRMOuU1IY/1RNeukGxFllxoA7
 ghN0lD8Z
 HySfEZ60W7UASzkOluBHov3woZsDs5of5KhWThHAO6JCPTKmDot2ZexGRexKkOqXEQ3djAPqrq1YiKM6xQ+F4bj3Yg3kc6gA3AsUrcI+MtYvfkhAJq7V+6qZDMLzsCB6FoN4TI8CuHAeGeza9wTPKoOZMSoxQNXwKPFk7ZRU/iBlecHcZiCtzhqZmVF6RCcMhLNYYdxGl2L37TnPDeJjAcA2bsImJ+VfOYbfZXUUORcSIUAumyoKz7DKfJWjft+dk54Z7psAHdB1UNF9Gr83GSR84BpC214MAd3v2LRjOMBWJBa8y1injEJg962GXHsf5e2vV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Dec 2025 12:49:14 -0800 Ankur Arora <ankur.a.arora@oracle.com> wrote:

> This series adds clearing of contiguous page ranges for hugepages.
> 

Review is a bit thin at this time but it's at v10 and seems a thing we
want to push ahead with.

So I'll add this to mm.git's mm-new branch for testing.  I expect a few
days after that I'll quietly move it into the mm-unstable branch where
it will receive linux-next exposure.  Further progress into mm.git's
non-rebasing for-next-merge-window mm-stable branch will depend upon
test and review outcomes.

Thanks.

