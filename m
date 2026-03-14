Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECA1210854B3
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 22:51:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 384AD6B0088; Sat, 14 Mar 2026 18:51:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 332A26B0089; Sat, 14 Mar 2026 18:51:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25F376B008A; Sat, 14 Mar 2026 18:51:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 14FE36B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 18:51:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A3EA013B921
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 22:51:12 +0000 (UTC)
X-FDA: 84546165984.03.0817402
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0B729140004
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 22:51:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bnWEn5WO;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773528671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q3bBl7XKo/Y+hmjVJ0yo6lxh5A92ITyHxkH6Z4xgE9o=;
	b=I4++Si8yO2oKzM/4OkywYUBNgHBWviFvgUjjeZTE0IwqAUTMLgIpLdlQz+dlvH9J8cbEHv
	7FTNQ746jQxbP/TzUyWbN8fhXR/az+EyDe4Uw3tjUxlZ7BP0udcH5cqNjxXVWhT/Qmi3qM
	bp/URksujXBG6YBxUe+7jIkvHDDhc2c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773528671; a=rsa-sha256;
	cv=none;
	b=h7PbMzboFQhMg9+Ipx/j+iRDwRL0LjYSGQNXE66YAGr7Cr+dyFs4deepuQ3Ccr1ePE/Vys
	3/jazRw2vbgqvTBIpXAl8IvxN2al6pTuK3Xih23fV6ACJZYoqQzAdQ7JyjpMRlNJh0SxGk
	QB04USTXPQJObX6QcwjpXQPZMHpFMkU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bnWEn5WO;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D8BD60121
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 22:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6493C116C6;
	Sat, 14 Mar 2026 22:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773528670;
	bh=4tWZx42twyBePr3J1Y66iQLkre3WZLhQ6Fbu5xC5H1g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bnWEn5WOuzuASTldcQinAKJv2qKeCsF1UjrnpVs/M5Mj2nHIFZrLpNqzEGKSHzY7A
	 C0+KnnHzeZsUeyxyksEOj5UbRmf8FJL8qwxIH9pnsZ+1UdzxgvlSFJ00KsvvrDW+4I
	 H4yqjONSdUXIGTKm0xuRSrUWZC3NqxiNmx9E402c=
Date: Sat, 14 Mar 2026 15:51:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: "# 6 . 17 . x" <stable@vger.kernel.org>, damon@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon/stat: monitor all System RAM resources
Message-Id: <20260314155109.5e37efaea8ef72f169434d35@linux-foundation.org>
In-Reply-To: <20260313234026.48872-1-sj@kernel.org>
References: <20260313044449.4038-1-sj@kernel.org>
	<20260313234026.48872-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: nocqn4wwzumx63koyhdwxw1j4ws9kxie
X-Rspamd-Queue-Id: 0B729140004
X-Rspamd-Server: rspam03
X-HE-Tag: 1773528670-409637
X-HE-Meta: U2FsdGVkX19nZwnjSe1gQSyQc2Ak1qU6NYOqgpyB8KWwZBr85+QOtACjNeCSfxFzP9KE2gJOya9IRul42/CtSJ5NgqarBlzeuRmQENojKQHxUtnwBLwspM6cdY0twY1MlRmH1MRT8r3H5viB0vM9CoEkNjhW/orEff5g2Nj2YkxHbsb2Z+OUEZyH+lglXRm6uAdccO99Tvct73dHiUULJp0TeNYLR8G6mN8kJ7lSS+ygBs9ayJwXjHHXbiFW6JK1LYfVwF+aqPtnwxIJq1c5Gs80ZKp+4BZQ4YhYvHYQ/evCGMTyYRXSXqQomVihbi8COmsqHK9RdBimbcFNaWQU5dPYgM4GCkiE6Z4TVTIFPmR6E2A0pU3JnUVjJBFJa/TYE8NbVq1kjFRPFsQbcP59+xeTK0XSPGFCu12nBw64FKX5Xs8k/lSwqdWhZ6TdyNOpbz7hQZaLlbzTPQhPG4Vmshzqtg+pdKu2XXqoyECgmqiAevRQ5HVS0wZeuk0ENo0Khi8m6UASY3K7YbWXanFO7+kzz7N/DiXyk9vww0aE6Xkydx6XgnBxFEA+S2D4nwKuZ3iOp92PkYcHfE8xBLR5G01+k2EZYK1s5HQvgfOK9ptIdwvkN+D/p9yRgWgsD2CoOJjYF+1wBbPQsV+dS5zXV2MCxO/9SKt+ZUYHBfvoCtJsRO9rlQuXjTWPohCcIfQePbE4AO7IxYnHgysCJyUvAh1HtcTpNR2+rqOI2kjsv9bKC2tDtxSbWczYOrGnpJZ42t71enSTz08CI3TS4DWcwBMYjNX4rpRZtB+V9a/d7pWG4Embi8lHM9MsK8j58TUaeQKNNy5HTibGCosZQozT47DXmTkcRNF5mHt/1kP3qfe5sv8U1pNWufBuxBQtLYpFkWqQIcOciEQ2NFmWAaNX2Eh28FCbBJ14wQioNOs4eZI8Tyn44we7dIDmq7LTUyUYAKhg1EXwlVC9KBBj8B4
 ypadypeV
 Ze16B7Rv+Yhz/hfvdgPYGUsqgMQOZ/uGV4nAZRVALTcre6TuBhjvWrc/nCCoRrS8/FxLO3j06dv+dxJamiGbA46eDOxYo+HdDvG/i2uDFRZwHayPSp3ojlfGHp1RDqYZ1MhnF6jLzXhnqcw/BxV5o8c20ie/DY8pv7d6ONdqjHbLzVc3GC9Unwj51qLFlzqRM2crYScAm7ePGFSjsbBIADjaAoH/EidNKciB+TurgQYAWQTCX1cb4Ba/XNin+BH06DsTma2ZjU+3H5Ev768XpoXxvQgHpxEOSCS15pnmtDGs9C8Q5cluXsDhwhGF7x3mgt9tieXISw5jA17+H95R4CPd1g6QdN8zZ8rC7BKNo2qxYYQw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 13 Mar 2026 16:40:22 -0700 SeongJae Park <sj@kernel.org> wrote:

> FYI, I found this issue from an AI code review result [1] that published on the
> internet.  The review also added two more comments, but those seem irrelevant
> to me, so ignoring.  I don't know who made the web site.  I only got the url
> from a social.kernel.org post [2].  Whoever made the web site,

Sashiko is being led by Roman at Google.

> thanks for the review.

yop, it's good.

> 
> [1] https://sashiko.dev/#/patchset/20260313044449.4038-1-sj%40kernel.org
> [2] https://social.kernel.org/notice/B4E8DdeZY07PseemfI



