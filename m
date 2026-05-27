Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94734CD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 23:17:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C6756B0005; Wed, 27 May 2026 19:17:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 877276B0088; Wed, 27 May 2026 19:17:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78D266B008A; Wed, 27 May 2026 19:17:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66F7C6B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 19:17:26 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2968B1406CD
	for <linux-mm@kvack.org>; Wed, 27 May 2026 23:17:26 +0000 (UTC)
X-FDA: 84814763292.23.837F51B
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8305B180006
	for <linux-mm@kvack.org>; Wed, 27 May 2026 23:17:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=L0QusdHv;
	spf=pass (imf06.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779923844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8chj61ssxpOwjXyr1dKZNkjg55TZBjnN92wYvqo2wVM=;
	b=Z24fSuOee/4ZqTouWbsIUM3EHO9PZ5gPuzo3Q0+H37wRVKH6OhMm8+3AwHbiEEATbKxAWs
	XuIWJl9XmPejzSACZSk15Mqa26DX8ULI1maja0WB+vsxjnvQsFCc06t3h6EE2LVeEqs1D4
	JaxjrKUeW2bcm/Ctiqkg+piF0HxPOPM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=L0QusdHv;
	spf=pass (imf06.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779923844; a=rsa-sha256;
	cv=none;
	b=Hhp/kkxAOLrjCIUkoAhCNF7v5n1/BTn7oMMHFDhcDmLx6CgVIygpyboKRY+JPjFMBWcyCP
	YCXQbk1o2LSK4iAimn7X5w9tqjha9P9uG26SJO1hNCj8ghDX43CD9uKSJz8fpXxxw25yMI
	yGSO3ujw5oRcQ93OiH6HW8TgCE7mf9Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1779923178;
	bh=8chj61ssxpOwjXyr1dKZNkjg55TZBjnN92wYvqo2wVM=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=L0QusdHvliQE5w7xFb+WEfWBVlVf0LPO5GTu8/PbUoq0Re71KzkNHjrkQdTGRGI8M
	 PZuacxwJjg6CLPhRMhXIvRD7kSN6wc+nzhrSprAYUFJzSq4BTTGO9rHRr2HsD1lR6b
	 e1M8e7eVq86j3cmQ0SbPeKyKslPyriou7JqPGGYg=
Received: by gentwo.org (Postfix, from userid 1003)
	id 88A4D402E4; Wed, 27 May 2026 16:06:18 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 875814014B;
	Wed, 27 May 2026 16:06:18 -0700 (PDT)
Date: Wed, 27 May 2026 16:06:18 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Matthew Wilcox <willy@infradead.org>
cc: lirongqing <lirongqing@baidu.com>, Jonathan Corbet <corbet@lwn.net>, 
    Shuah Khan <skhan@linuxfoundation.org>, 
    Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
    Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
    David Rientjes <rientjes@google.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, linux-doc@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm/mempool: use static key for boot-time debug
 enablement
In-Reply-To: <ahdsgyYYDn6juR_R@casper.infradead.org>
Message-ID: <7f4ec43c-0d9c-190a-0ce5-bc3276b45cb0@gentwo.org>
References: <20260527104634.2434-1-lirongqing@baidu.com> <4da5d090-8272-7f26-9e83-ea4ab489f1f4@gentwo.org> <ahdsgyYYDn6juR_R@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam12
X-Stat-Signature: z6gn7d14ci16mcwhskrc76c6aae9srf1
X-Rspam-User: 
X-Rspamd-Queue-Id: 8305B180006
X-HE-Tag: 1779923844-686947
X-HE-Meta: U2FsdGVkX1/aA1WNWps+NhDI6RBzP5ge8epgTNZXaas7dggOwxo8cU5Ho2UAC341ZtvTw51/pgpqjlEsXZ47zWDnMOn7F++51a6wzZfhZIfenO2bXWjJ0g7xWVZoQU0HgZUqzyBJIlp7iMQKVAA5sbjHoq7La8Pvp5k94ammaz6i1vbRsFGBXGSguNM5SuxsKouiGhuQoq+FZu1fJ9vOitmkYJwDXH6O+aZjC+w/K5bJloipaUN7Sm6JJ/rxWoOouECAdfRv9JrnlKzigSsjI2KeulJwgGJ73GFAlD4Lh3gn2KJa9RQUdRXy3Fd0QuHY2WotKcsE0Rf+nJCA6Tf1ROWIFyWxDhUKqfdApXzNJ0zRyHQZAqoF21pHxTl19HVeupVb53JxEoKdraNMdQZt/giX2o0Q8WyWo/Ul3c8qzPNvEjjmStKQr5zZ4At9xcpA7vzIffOBSjD9IKbkAKvpN+E9pCurM5mp5QGjv184ToCKHANn9ibizqu7CMfZabRMcd+S0G8GRMun+3hOcLIqmIbmXWAulvbd/CM+AK+yqCOBI6CKqmqnR+OetDRntQOsm7frWWnT/LMyZ4j8pVc0WejrQ6p9/yrUXKe20nSh+JrREZAqHNSYUAPYJyTBdGI4QfdKX8M4LoDp2nN7dfCGy+RoUKQHJbeLUw+jURDIqm/ShaOMvCtR58RU6Eb3mUEQNvGPDKvrxFxUo3GgN2zYXuzAo1E0dHjS9+juX1Wyjet60R8QVjdobtvcVDCDmr3ROIAC/bMqyeMpm4qM9pJobH/59kSPm4oyiHCzlVGimBPnkW7tQ8d2uDCGEvWd7J9MRV+3IHOYpHk/0qrapUsLSZ3YN0sdnjqt4U6Dugc8hOoaG7+1rpBVAHWVoz+ZhYsr1RRqAyq4eIpmF8dQ4w2SvSEcfks7r7ZTjjfHJ9PXCaWBnHd/s43FwIVPMD0yhnogJcHqg9+1BiPH/VuI0CF
 79oRM+uv
 SG0X+9g52rFjjWTvDF2sMV/8p3jrLk/AimTG2XP0gmqg9SY5uZKkmOkCLMB5pjWjK93ZsPvWJvETlRlexA9MvxOXaxlsfzioO/FSbtGjAbhAYGaDz+FNC/nTsLVP6X7INtKUcbwM3BYvJZn3VeoZp7dG8a6+jtSO5wG9tfG1YModp4kpRjeu4KE2h8Z+ACkBv+D95g4cg0mpgeBnr8NlXGCH/YEH8DBzA797eFAkQU3Xwr7KKuUHSTN/iFws/5zIUNVYUvF61BKM4j6wAykCW2z94jLrzngav9oUY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 27 May 2026, Matthew Wilcox wrote:

> > Please clean this mess up.
>
> Isn't that what this patch does?

Its not marked as fixing something nor as addressing the weirdness of
using CONFIG_SLUB_DEBUG_ON here, A kernel build with CONFIG_SLUB_DEBUG_ON
can still boot without debugging if a certain kernel command line option
is given.




