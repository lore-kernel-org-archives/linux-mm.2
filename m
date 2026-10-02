Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 849EACA5FDD
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 14:20:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79F286B0098; Fri,  2 Oct 2026 10:20:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 777FE6B009B; Fri,  2 Oct 2026 10:20:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B1CF6B0098; Fri,  2 Oct 2026 10:20:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4A8E96B0098
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 10:20:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C18AA160727
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:20:15 +0000 (UTC)
X-FDA: 85277895990.12.C001C56
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1249B1C000A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:20:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="omENPTd/";
	spf=pass (imf20.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790950814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BGOxvfHN6O4PeXtNTSU1Wm11e0LbAQUwGvTW7m/K2ac=;
	b=4UkNuAwtkiLKm6nnq6BVR9hT5ATL1+KiGb2i6kE6T/xGtT3DZjGxgQvUA9GuqNHXvjqyoI
	0W48Oev7r94Ax0R21qPN5StFTlV0Jvx6+9KNw8b6m7FFQG2BE752K/ezxK2KeJojacXnFK
	N8A2HuC5SSL8R055lq3jQaIF1dCX0Hs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="omENPTd/";
	spf=pass (imf20.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790950814;
	b=mP8bJX+Eb26hMwEIR8EoX20OCktjtIAh+pdkarTyhN24UgZK0LSJTP+DIw9l2qoDTfq/Gk
	oQvH7zv0HC15+GOKFejgJALO/lOhelS9rhOwKkcrUD8ZaSMtSxD/f4HSeH7wV3MB8Yk0VT
	yz1h2jocC4irIAY1KHk+y6hdVK8/4S0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D4D3408A1;
	Fri,  2 Oct 2026 14:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6A51F00893;
	Fri,  2 Oct 2026 14:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790950813;
	bh=BGOxvfHN6O4PeXtNTSU1Wm11e0LbAQUwGvTW7m/K2ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=omENPTd/q1I6eXxvCYCzaW3Y2s3PDwLxGR98xFyRoqWjuORJUwXcr8sC9bMn64d9W
	 XoHKKpRu5QUIOeHb7SI6w0VHfPb7eY9Jsk7e26/akSWtTesbASszZM22NfYJ0G9qfN
	 U+SDP/fjX2zxIQVJ4EgwHQ6i0U83FkY2PPS28KDZh0DuABJ5VYHb4uym+rp+9U3zjm
	 YIOrpY5ywYjLJ3/sqJy2QljRgK8t4n1E6KlOHowuNX/oJ7szSWpVjr4drbdZjufRmg
	 TUb0AuwRVeOa+04lR1ks4QvgPsY+AcYv1fm5GmF1gNvdcQlzk4Oa6CF4F58j7zWYEn
	 VxX2t3BF95LIw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Hubert Mazur <hmazur@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Stanislaw Kardach <skardach@google.com>,
	Michal Krawczyk <mikrawczyk@google.com>,
	Slawomir Rosek <srosek@google.com>,
	Atish Patra <atishp@meta.com>,
	Atish Patra <atish.patra@linux.dev>
Subject: Re: [PATCH 6.18.y] mm/execmem: make the populate and alloc atomic
Date: Fri,  2 Oct 2026 10:19:55 -0400
Message-ID: <2026-10-01-1-daily-reply-0011-re-execmem-populate-alloc-atomic-6-18@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260930-execmem-atomic-6-18-y-v1-1-bd35d4523aab@meta.com>
References: <20260930-execmem-atomic-6-18-y-v1-1-bd35d4523aab@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1249B1C000A
X-Stat-Signature: t8kpze3wjuqg3hmeojhahw9yqhbhop7y
X-HE-Tag: 1790950813-683268
X-HE-Meta: U2FsdGVkX1/UZ6ICo1F0FCLU5fIEjEJmQgwERT4plQKtCoPdkuicTldUOL4JYOq0kwRbDNOFac3LcYsft0UAJc6OmxT/x3ZbjIUJceqKR4rNxiADXbldUeSsNfQEni48UGmSAg9eyNkafWTIvHAAmlsMHsxJkDshhlNTCXREHeXJT3ae1HBZT3dsfGR6k+8iHZdbh5mn9WKLFhCUTaTJ/J425dqkDTPxIVjOWlohRSjhzwL+oqF6A0Rav0OO9JfbGcbLHcuohj2X/kh3SjRSs4b7SzZBhQN8tUpq5yQhJPjSknn6w4xRUmzj4YXH+sXfgGF2GABdWkCBjtYI/ccCglwck4dKqSq9mim9lbXShBuV5AYMBqKMURHxiVUK5uVhMISh+s2OrftE31OqNQiqJ8qpbXN/zwbDeRU6Hx9jo2C0SQ9gBpalBfxK4Mfqpf3sEbQmNNwgxTlSlRt5GZrY0zxbsbfmBb7i+9FqpVqquj7q2h/jCgoPUT2ubrLGgxJJ5ZU43f3Nui88HXUoEEwoYdyveNfafprdKfaNO3JhIKw/OvWPxE9eOag9+a0bRzsdGM30fc6TOJKZIiWopvhtcOQSpj+oQIl8rsEbHeCbEaJ4lwEAVMKUdOG08MlaX9ia7rKdCJatEk/I7OwKIt5N5FCNT2HMbnhNyyyg1N47KSmop1g21jdPkyjw5oa1sZ63kgittQd8FKVAcpOWyqM44iQm8AEeKAPzmlKgxE60IXpqe8uhJs9KasIqcg3RdX12VqrVdWlUSd0dQfO/3Meu5fIsmRXkXed8I4ScvoS70mFMTIZp469XAk4RC9nZTPi/yxKV0hFF++Yafm1a6V9wYlUo1Uu9mUt39iZznep/rRKKqj2baHiJV3mw85weM7bRLlrjreozwYp+jWLpGYCzVsqhe1SrvpFxLnpXDEK1VuPpZuQzVk6400ZpvCry4SbdGxeSijj2FjHeXjfGk4w
 k2xNCJxx
 lj7yw+onldQjES4qYvuKxAFFletPLw1nXzYd5M2EjNADhjAfzicpp51hZuS2h9bjw/eLngEJ82XKzW1op8XGSiw8ZdVxDGsyMnLmzd0MioV1NUVSj6OTrBkuTOpwCQbB6wL6bknfK/dT/zBPi7ubhqqwLi39RMinzD9cHa3alvVjQ07h5w2yb3S7Cf9ImKe3tlPPr5gbGIQT3DRClhad2f//ToA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Please apply this fix to the 6.18.y stable tree.

Queued for 6.18, thanks.

-- 
Thanks,
Sasha

