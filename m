Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4E85D3B7E5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 21:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 403356B0088; Sun, 28 Dec 2025 16:44:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 386406B0089; Sun, 28 Dec 2025 16:44:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 292D06B008A; Sun, 28 Dec 2025 16:44:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 14C086B0088
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 16:44:59 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9BC82898AC
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 21:44:58 +0000 (UTC)
X-FDA: 84270210276.05.3B4EFC7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 00849140008
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 21:44:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RbLb3us1;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766958297; a=rsa-sha256;
	cv=none;
	b=DybYoZz5q1LFIFZD0+XAi7YIh2h9TQKg7Y9wQkCx3Db/Et14GyzNmQNzeuvKlcaMI2ObCP
	UKg7kFuszrWs+jzoxyCe9wrcBdgEIu3owoi+UzD99ZiShY6oHVoRMhfh68grAW1IFjOPcP
	hx2xgb2OHndV8cclmG7fFVlyof1gv/o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RbLb3us1;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766958297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qUfqEzgivMYQGECCNGtsmaAqpjWhlGhU3rs1rTXEOBI=;
	b=p4U+EE8gKMAPdO7gugW+f2kawTEwcfd0NlDu3QZVjqWvLKLCP5GRQZss0JY2kotb7lkKzF
	shag1PoK8HAuhJk4OdAfSZlV9TfaLULnVuigMUtR28skt+h2FK6KL9T++t6BYOG2GDoBV+
	HLMDkqCXDWiVBOUlQZC0fh1hbtVS6s4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C45260010;
	Sun, 28 Dec 2025 21:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BAD4C4CEFB;
	Sun, 28 Dec 2025 21:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766958295;
	bh=e67iq+2uXCVlGPGtPOqLPN1L9vPHUvzEDKlvyVreJyE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=RbLb3us1ZyOjJ0CP+Z/fauHY/A+rUNDs6T9GG4UJLDJMw9kfEbLSjhb/1Oh3/8i+J
	 FaCIe39c2PkI0FI5GXpxVFQGYSpkBPkro8hZbitrymAJjuqndW5p6bcxJ1lUCdc2SX
	 zWHPemSO5B2MGtl/BJ0HXd8GMgL6YTyQRYqjp9pk=
Date: Sun, 28 Dec 2025 13:44:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: =?UTF-8?B?5p2O5ZaG?= <lizhe.67@bytedance.com>
Cc: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>,
 <fvdl@google.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 Ankur Arora <ankur.a.arora@oracle.com>
Subject: Re: [PATCH 0/8] Introduce a huge-page pre-zeroing mechanism
Message-Id: <20251228134454.89617c004a6625556f7ca9f3@linux-foundation.org>
In-Reply-To: <20251225082059.1632-1-lizhe.67@bytedance.com>
References: <20251225082059.1632-1-lizhe.67@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 00849140008
X-Rspamd-Server: rspam10
X-Stat-Signature: qnk4kp655o1753as9ieu7s9qf9s313k8
X-HE-Tag: 1766958296-296625
X-HE-Meta: U2FsdGVkX1+OouuvspqWSd5kUB/5yZNmjn7LlfT3jGRTEL7UxSgUso38zHa0MlPj7xqBnwScvCmjWSdauIyseKWAoHWaQfhkEFJCZwBsgeZpbV+nznYa81KjJEJLcRFCl6M7oZg4IgsZR3QeEr0oV485RDmU9k05Guq3bpZw6/ev00Kgg7spEowADvbGI2GBLdGE1F4s8eBgaf7BFnSK+G1vKd/COxiYKNhtOIbIlgQXXWD3AfEPQox2yTHpFiLe6eb4SVfHpxhmmcKJuBjm5KAkKF2D5o28edHBjJNt55IOhEfNDLfh+BWMbpLO0Pitm5elcCpbjWLhaekIqwnPHzhC8rT5nvOBoVdhINeZXxKh/6eaB+fLY9WPr2PVRkqDrwEJ6dn8UISTm2Jrt6bzAQGjDulVsunm/TKX6kfTHWSKmQ3WbTQxCVNwfaZHzPe3UOEssOb8/wiFuAWm2KSWwgTq0cxprCz1CfMiCzqAHcopAnw5PJMtmP3S1jlW9QGLigO6w1mKGQI6Le/Ip0IldWwXdIw6sTRi0kfspwcvbQpB7TxPyxrWUvf6HrXaE/TNmbN9Sh0aIGxA4QlviWi/a0ZFy74fFwdwTdrTCHQGxSJe49HBNaC+fGyn4/+Lh6MzvLIeguJ6FwLleIztrpTC9U0B/Zkmrwv437t+rO9cju66/FHJOUx8dqWuPvy+6kQ94MKvu4Q/JSDonIWQxFGpGNiNOXT/ziM+SbD0X4uFdNR1AfuU+ITiXFKHSyb40HDTQlB1nddpzCk4x80vB1wq52lY1SzlKKkMnFRQAl85IYxoK5nC0F9rWP5oXoA1+38M0Qxjv3UUC4xbz7krThV2IL7xxpyhDYixaK6nrp96JsDZOuWcj9Cefp/oRbJDmRI9c83Q6/PPu2XjgOv+ZHpt9VL+me2BiO7q6TQo2aIRlQEUJHvL4eifnvF9mMLa8S5qkeQkTy3xATXsrMy210i
 AmGcLXDd
 LoBDHl+M0lqWN06oabAkj76xtt5QF2bgG9sPN5quZqGocjMwPIRjOF9ve3VWmWsRfArNFv9G9ourfwK0ngjPyQ8VrI/reqJWE8KxTQfTQVKYkucyP0ynvqtakpkoCQkc62M7NpOVmFKSf8Pw5khpv3TQIXUIgRqfkJJc3gyZIX2diEkzjecfx1uUs5Zbqf+QzQxeYhyufp1fDOQEf1WEmtb/x8bCFI8DiseBWo/Owk8fc+Gt7pTmP2rCFC9xDb+uWL4mKvBOWgQjVlbvgTR2LcaJeOALn40TrI1XLDdSbq9SaudOroHecpcnPsbyBhUwLQ3uLwYBaJa8fk4QtzPs4bh1ODQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Dec 2025 16:20:51 +0800 李喆 <lizhe.67@bytedance.com> wrote:

> This patchset is based on this commit[1]("mm/hugetlb: optionally
> pre-zero hugetlb pages").
> 
> Fresh hugetlb pages are zeroed out when they are faulted in,
> just like with all other page types. This can take up a good
> amount of time for larger page sizes (e.g. around 40
> milliseconds for a 1G page on a recent AMD-based system).
> 
> This normally isn't a problem, since hugetlb pages are typically
> mapped by the application for a long time, and the initial
> delay when touching them isn't much of an issue.
> 
> However, there are some use cases where a large number of hugetlb
> pages are touched when an application (such as a VM backed by these
> pages) starts. For 256 1G pages and 40ms per page, this would take
> 10 seconds, a noticeable delay.

Ankur's contiguous page clearing work
(https://lkml.kernel.org/r/20251215204922.475324-1-ankur.a.arora@oracle.com)
will hopefully result in significant changes to the timing observations
in your changelogs?

