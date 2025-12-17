Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B22FD66B80
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 18:06:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F6806B0089; Wed, 17 Dec 2025 13:06:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27A146B008C; Wed, 17 Dec 2025 13:06:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1861C6B0092; Wed, 17 Dec 2025 13:06:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 069156B0089
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 13:06:33 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8501160D6C
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 18:06:32 +0000 (UTC)
X-FDA: 84229743024.23.6543CA6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8B2F340004
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 18:06:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=i1LOacvU;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765994790; a=rsa-sha256;
	cv=none;
	b=c11e46BxnaR6BESlid7TdO7skoIChJYseenfpPdPVNsDK5q+HDCBzNutjhsRx0LtwvUE7X
	Wwy+XEenZF8P7KSpDXJLVfi51305ClROFKxyMMbybjOJFZB/StZP5AAfI8G3h6GtL+JUPp
	NDGJ2w2isO0iG50I+Gyox4zxsiP+hfw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=i1LOacvU;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765994790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uKo9H2d82owLfo6EnJra+LDY8Yr0eDCCzyDR7UhtiDI=;
	b=K1M6Wrv2KOckR7qpQgkj4uBN8ZKf7CGQxpBJBP0xd9R/zBkFuVlT5TgBhjF8tQukQLOS3/
	OfqpwuuX5YFI5EEymq+nOBXb+J34p2VSofvT43UIAwWydLquVYLeFT8chLaPiOF65enVTm
	cqIbcgucZL3wLn6cuxuSd3LrpU6xoXM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4EC86429F5;
	Wed, 17 Dec 2025 18:06:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B72C4CEF5;
	Wed, 17 Dec 2025 18:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765994789;
	bh=BMQCiLukZo0B4TRhpdioLwnadR0XKJkea+NKK01RqlI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=i1LOacvUJJVzXv1XfFb8M95W5ll5w/Qb15EJjnFDDIuiJrdkWrDduAzLBSeMjDfOg
	 akITh+5DHhbUYUkHMkeLAmdpRvhqhHffTOBNytzVW+OQgCuZYOa3Koq2wX616DGuzg
	 aY5sH9SJUepTDzHVMiDSUEW2aWuxkjl7bSTjql6o=
Date: Wed, 17 Dec 2025 10:06:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: urezki@gmail.com, kees@kernel.org, elver@google.com,
 andreyknvl@gmail.com, dvyukov@google.com, vincenzo.frascino@arm.com,
 ryabinin.a.a@gmail.com, dakr@kernel.org, glider@google.com,
 linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
 linux-mm@kvack.org
Subject: Re: [PATCH v5 0/3] kasan: vmalloc: Fixes for the percpu allocator
 and vrealloc
Message-Id: <20251217100628.ce0aef7cc975b81f0fc77cc8@linux-foundation.org>
In-Reply-To: <cover.1765978969.git.m.wieczorretman@pm.me>
References: <cover.1765978969.git.m.wieczorretman@pm.me>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8B2F340004
X-Rspamd-Server: rspam03
X-Stat-Signature: 6zisnp33ck1j7au9yhxgf6aoh6hrguku
X-Rspam-User: 
X-HE-Tag: 1765994790-426284
X-HE-Meta: U2FsdGVkX1/9Zr3US/ZCjZonlgfvQAVn27VM4uh2BTfVdtFgDTfIkWjGnaUY8iJdbk35WgQQI9StIP5Ie7g3DMONMHR+I5FvRwTp8BL5pwekly1Nd6+qwD8k5H2HywT/tkCvZ4eTF9WCLBxHy+oniPwiZVBhc0Q3+R5tTImUGmuv6SNA7U0hEoJTHoKqjoeXSsCLNn8ZJYEhzhztYtd8sdhNP15XKiwMs6phMlGIhd08VYi2PmgidIrO8b9up+8mHQyJq161l65M75AC3fRdGhIqJuW/qUZpSGFYIJk2E/77i7l8046+YPTMVwi+m9GG6D31RviEIZ1++Kf4gG0aA0vTO+w2FyW566PO4YY20CGWbwNmNb3bs+pbGDlzyoAvBYv330PEVohhc0ll1DHYtcYAlGTS4poUQEDleNdIYdqLwFiVobhVqKk7bf/w4TjFTdid1Vrb9DVs7kKocl8G6P3vPU8tQ0QXGk4iUV9MvPw5ptlNj1jA1cM0kjkm+SCd+31nYGBzLr5sTBUAnUXStH0jbAzlw/FmD6MkK2oBDqK+Y4CO05vqu3W3VMREoYoNuwPsuQfGw8+FDpSyAA9xC2hNVW5+LdW8y1Kl5YQeNgXNzWt5U1B+css7awEg3uWyulzBwigXaxA0zMMyl1wGejBhXGSF2S2SU5qmLD0PvI0EaXmucJv3BAIHzPH9Ak3k4yeNU3UJOwhU2iJKGdea9Ct8jh0iw4rA0DNIbtCUIodxsnwGHJ2slEpc6N/ytT12ON4nIvpxt+JTGNbp+sjCKellarPaAIMaNe3owH2A5ZNAJXny4InwNbmfw6+Jh1WXytvWiJMVhzDIWrTfwWCCr0F+LMYDX8aKJfQ4929oamX5LQj45ZzVy48+y44w8TdmFD+hCEjFstLi+d7HFoJ+LgnRiMtBPapOL/NKAYMolwSA11UzDE8Y8mTJmBuJvVBISVDPmpAnUD75DjXVeLU
 rHVA3Hlk
 fqRGow7oOEFipZysjLlgPR/KViNkcCv3ISNkrnDm2qGHNdFRLy7mVaFRLufT/sgs61XBQZbQHW/1AwkLhwzneon16pik5+lnBQQNbq+JWmQFFgxQje8duccnVp04BgAuaJUR9ROhp/7nH9qMFKK8EMO7a82XO2TQGS5FiJoRxmI1ozcaa8FgD7Mz1/rO2fzIfaP5eSz31DCrTSkhBhHHYsZOQwcK5/B8PFizMut6qQI3Z4A/0k4ErDVkP2EC7i1SkgbH/WofHkSDaZ5CdjJgCKZFTHpz1e0yzkJr8S6Kp02n48y/JCZxukSORK8fHJvLgf1BJz13gG2s3brjRxbsjMPwLVjZW6z6AaLAj9Uil2REgIPo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 17 Dec 2025 13:48:44 +0000 Maciej Wieczor-Retman <m.wieczorretman@pm.me> wrote:

> Patches fix two issues related to KASAN and vmalloc.

Thanks for the refresh.  This is the same as we already have in
mm.git's mm-hotfixes-unstable branch.  So I updated the changelog
metadata a bit and left the v4 series in place.

