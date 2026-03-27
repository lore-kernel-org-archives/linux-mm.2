Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC41D10F2867
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 19:31:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21A666B0095; Fri, 27 Mar 2026 15:31:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F1AF6B0096; Fri, 27 Mar 2026 15:31:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12ED96B0098; Fri, 27 Mar 2026 15:31:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0516D6B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:31:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8CC62C8BCE
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 19:31:22 +0000 (UTC)
X-FDA: 84592836804.16.9B5C912
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 12209180002
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 19:31:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AUtlnl4j;
	spf=pass (imf24.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774639881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zCJaOJvD240evQKIHyoqIdAXaS7qUTD+6ysggtQwAX4=;
	b=nJPLxA3Jw7bky/2PZO0Qb8dCKNBc/Ef8K3eN+yE80SeqKJJ8wgYn4g9n604wZQNXkwsbeR
	Ei9gbw7bbw1fM+iE4R9PBTR2BYLez+8AOcgy8cYPj7juHjNvKMc9pUDCKCS24nY16klYWo
	1uldh6Rl2gPk1kzNn09F1RS1AmvEHgo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AUtlnl4j;
	spf=pass (imf24.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774639881; a=rsa-sha256;
	cv=none;
	b=PmuYDCBhBmw5D4IzCuwXLb2MzfAXJIVTf9x0m6jHTK7NCNImlmdvetP7YRWAccxpk0XgI2
	4de+RT383K8WfwV9tU1OUQ8PjXD9an0ITyX3mjm/eRiJ8WMeG72wwG7/y/YnEAcAe1KB2K
	XKQOGlCt4If99a33nlVhQmA9VBpua3Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E5DF543352;
	Fri, 27 Mar 2026 19:31:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 605A3C19423;
	Fri, 27 Mar 2026 19:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774639879;
	bh=+3SzXS/yxWjVX5Q80XaoPY9MGqSGzroOg4bwjGy2F4c=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=AUtlnl4jO5rHk4LN3cdPRtT0NTkQtM7bu71WJgsbbe00t/zR0TDzeiPtUEVrnPez/
	 3dsW8oL4dC4JcysU/UYcJYzLxQhwUXWBLd/oVrUCr7Su+Oem3g1z1ZouNGqKoEgdXh
	 CF2+fAhFxILPhe5pW9deMoIdDLrJr1sL9dh3avl4qcF0mEJxCjNyYEo6ODBuotS79N
	 /KgHnsqp5EtPPDYy7C0PFl5sK0scNlix8NQ2TRqBU2oKPpfH8yViu57q9SiNsgRB2r
	 s+hxY7cZFRUF2rPoP3wytmzOLYPekY9ibUNOpuLgC6Cwn7bK9Admq7A9VjSrXjUO8K
	 yX/by8BT8LNlQ==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 27 Mar 2026 20:31:16 +0100
Message-Id: <DHDTC0KLR9FH.3F9GCS0Y7FNRY@kernel.org>
Subject: Re: [PATCH v8 0/6] mm/vmalloc: free unused pages on vrealloc()
 shrink
Cc: <shivamkalra98@zohomail.in>, "Shivam Kalra via B4 Relay"
 <devnull+shivamkalra98.zohomail.in@kernel.org>, "Uladzislau Rezki"
 <urezki@gmail.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 "Alice Ryhl" <aliceryhl@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20260327-vmalloc-shrink-v8-0-cc6b57059ed7@zohomail.in>
 <20260327113758.75f04588310a707b4d4b1aac@linux-foundation.org>
In-Reply-To: <20260327113758.75f04588310a707b4d4b1aac@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 12209180002
X-Stat-Signature: we1ibde7rpsm4i8ip5ef43xquk1qoyou
X-Rspamd-Server: rspam06
X-HE-Tag: 1774639880-132207
X-HE-Meta: U2FsdGVkX1+/zrETGoVzgDTUu4bp96LVWjaPgu2LFUDfgddgIqt93nP6F7vblWyE9wQ3na802jf1wBzBFyP/dAuxyxF1ncLX5X2eAV4xHi82s53fXEov7FBWw3TDD0K2TGXvl9nz+Vy7wXrLUS7F1Oh8Tetce7CNjPrJ99c6/5HaEBPtniY8yJpX1S7RAJtSwDJBI/QPm6bulgcu7cyhhrgzOBQnamGRt5YcOJU3trNd1XVO5gPH6xsUJPF0dkNtNSBwc2EMMhChYvrITb3DrhPa0aelyBjqQLwrC/ER0HKNmRStoZ6q18S9v4KeZQrBkMIVxAK6mE44XvA57UJY2ys64dDggrj8sWa6+R7JmJCR+fCYMW+BXF7hnEVY8TAH7HA3MCM2OSXJIAUPAohoGnwB0oeIGwE2nLmjqBkgM9OapMEubykrYd0O3INhMRQYMdt21Kef82Cxjh8EnGhvv5Ez4glA4x5PMGOfM68YXv0VyszraVX8HXHIyc893oIe9breKNYRxTPbTtVIQzb6nLQoUKJkox7lytmocMG0+EwN46gmCWcCuMh/o1u2M7FaolPkOSRyZM4nhOH0NEFXmzxvywNmkyLLx87S2swxn+9TlqofLZ0Cn09DkA/pZAwQQNC/MwJruzjk/9EgX7NcYRMKr3FII+yMipeBUpGCA7uMLxD7yCHFU2gSPDmxq1M2r442ZFayZCEuygxzzhMQbDH9Cos+Q+uLk2nE7hh7Ji7cBw76tgxrCRDn1ACk9DOnJMBAFNeYKtbw1n9PXsqoU+cDvEo89eX9TKSJlR/g5g5rSxY1tYfGAn+YPqpqfLFVUCkhP7i5oOaCFT3djJtNgbZ0H6XwcARiapv5/OMsUShpitjJauMjOJT710XOikpr/DuUeJlDugpEfwTrPyDi6BYS1u90fz+DLk1Yy4HwfATm/beAUV58p3o1fR5EziWpwjT9UzZmcyjVg82rCVs
 7T6PtaxC
 0cV4leoSgDDFdc1aQuyOdi35oBCqREhtls4HYnxCk9y+FI4Qc1D+3vs51frtj7310EI+df5jGZUintgi5aXCRGa1llQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Mar 27, 2026 at 7:37 PM CET, Andrew Morton wrote:
> Are we able to describe how much memory this change might save under
> various scenarios?  If the savings are impressively large then that
> would get attention.

We already have a workaround in place for shrinking vmalloc buffers through=
 a
deep copy in Rust alloc.

Given that binder, which motivated this workaround, uses it already, it sug=
gests
that the savings are significant enough to accept this overhead (I assume A=
lice
has some numbers).

So, I assume the more interesting question would be how badly the deep copy
hurts binder compared to unmapping and freeing spare pages.

