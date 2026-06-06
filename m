Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B6FACD8C88
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 19:36:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 927346B0088; Sat,  6 Jun 2026 15:36:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D7856B008A; Sat,  6 Jun 2026 15:36:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ED716B008C; Sat,  6 Jun 2026 15:36:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6E4AC6B0088
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 15:36:27 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 04C26120541
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 19:36:26 +0000 (UTC)
X-FDA: 84850494414.08.4914528
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf23.hostedemail.com (Postfix) with ESMTP id 57A79140009
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 19:36:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=qDIoFcav;
	spf=pass (imf23.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780774585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7fbbCNfM8QB0F2+KJw49ucJeet+q95TfB3QJq47jJao=;
	b=lQj46dW5KTYX01MzxOrXqH3sLhAHJwEJia5Q5eYeAg7RPTrWtIBfIxiMP6dR4FAP4JJyEh
	bnBcEtmRJKfrZaHWmZo4ePLsfnM+mG1GFVH8ZaK6ccGGOXwbDyiW07/BsOlWFKZxduRZeh
	OaWy3a3f69vAinSImheeTcUVXZbrFek=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=qDIoFcav;
	spf=pass (imf23.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780774585;
	b=ym0ut+hMgOEA7cNrOlXFqIrCOBYKAI1dMwmrUoDnqB9yxCAvu7xaKvHSbJoOoFN8DHF6Py
	ebVMzaNykjxFjzwIkXoteZatq9NMqX7BHP3g3OLG1J7KbV5zSkzHoZVW/AR+VmXcZos3ei
	Ud4FffYQwvnGj0sBrYlhJPMDN/X6O/c=
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 9103240E33
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1780774583; bh=7fbbCNfM8QB0F2+KJw49ucJeet+q95TfB3QJq47jJao=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=qDIoFcavkomeO718/o6FLB4OChv9WwAgx7i7tBWbQ6MmmpQ9fXCbo/2qI4LRIAI3P
	 ATLQlrx2OFpFC3oKaXSfF/hsU4UchJSfbCdSgPBJDzwm+auIIvdFsSXc6ISj6Ao3M2
	 CiYpizcz20MSSt9r5J5LuDP/sevLvZOHUkR1sZDIqGNdzQeUIClBr2cPjeXMEWrfiG
	 BZIK0mHS7+TW0HaFLCuvyNiN9eCa/SJXaaVrpdl8KuiG2b1fdFo8r4R0FmOz8FGElQ
	 zC9G31y4thvT6ptNpIfyp8mgtC58TnCjJ2VrANZd+0avTLB2po8k9Iw4Ndin7hZ9nG
	 s+/uUePPlOZ7w==
Received: from localhost (unknown [IPv6:2601:280:4600:27b:67c:16ff:fe81:5f9b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 9103240E33;
	Sat,  6 Jun 2026 19:36:23 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Mohammed EL Kadiri <med08elkadiri@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka
 <vbabka@suse.cz>, David Hildenbrand <david@redhat.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Kees Cook <kees@kernel.org>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs/mm: document slab cache isolation with SLAB_NO_MERGE
In-Reply-To: <20260606174412.4843-1-med08elkadiri@gmail.com>
References: <20260606155856.15548-1-med08elkadiri@gmail.com>
 <874ijfvec2.fsf@trenco.lwn.net>
 <20260606174412.4843-1-med08elkadiri@gmail.com>
Date: Sat, 06 Jun 2026 13:36:22 -0600
Message-ID: <87v7bvtqa1.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 57A79140009
X-Stat-Signature: xbg1wetm8je7rqtesafqqypck3sd8w7r
X-Rspam-User: 
X-HE-Tag: 1780774585-437348
X-HE-Meta: U2FsdGVkX19buT6tqNMXKnvD3E89r1I8PmMbH1tbaCzmAGsPsaZN6AscEsI68j4Qxh6aTpRp5BfGwhHtq7CCq8mZAZk4PRcsx6N9+NKEIIN8pNPrL+HYezh+1cel2MFh3gGG8+9UlJa17haCI72USp7+vl0xk9NDCApAUkjq0/UZziOYfOEAES+51lfDVxPHAHh9VSo0qBtnxUrPKIxAq7hc3boc9TyCpLbcLBo4VLHfmMZgZPlJzbvKE7TZOTaTuwHd1YYpTsVg8U5iKTuTPdPZwoTGetzPKEofchwOuT6Hl9sOfORh7wHFLwsz8O8GHYtHUfF+/tXcSZscVpL3HiVbyRCpimAZ+dKiI8k9tVumUa0HBZreIjcyhjGiQhVizm206dYMrzlGFo1IwuBBhmzVbv60fDsELELqkbvVizuAqiTQKEHQmDvesx3QrcqMYnJGkMDYsqWaLW1cPjaUq71O5pok6UnyPk6fl11I6gAZlDHZQQi2H9evfuIEFLk16ihDdMKcPVG4q707rjKp8pITBFSrQMveMLLRLpmRXs4eivnV+ERRp0kdPiLmFULbQ1Zp8Kk18zEBoB8RwTZq6LU96dxr+ocTwniab0Fzq3Re2fSqG9c/FSKNi1emI3314YTG6PmweamQDI/Yr8bEBkc+qFc0LE+N+zRu3vNuBfmSlTsIqQgw3eIno93tEL5/RnZnGbvlAc7siJgmmkpk3ivDvJ8yPTuyi9DIFJdsNfZaCYaYSTjDUIGWwelTTp9EySR9gokl4qsFe2mv+BdzWCnGn5+03H/Ek/rJ+ux5nJzcOLsE9Torne0c/C58NvJn5w3qA6ilfHEV/mOpkn58groHSM2VuwyD4iqjYXu2e64qZGtisQGdjvTJyTqwRavjU/F6+D1C/pUWXH3iV42od1ptYJuHds8fkA3YLmTzJxEMh0mFv4eM8odBYP4wVsVNkLdY5jCSr5TRf//j3g6
 2B9p3MqG
 le9g9XnZe8dK9nx37Jcz39ezJBJ5l9ZpqHhvhNeQwWuB5pqIFYHgmnBb86WaofieVudeK4WLX8g2q6pVXn4XcHY9KBPfeCe8DQLoXfPG/2s0gjSJJi9pGHeP03KgB2nA9DqdVFJCmFU5F4CzoKF8Wm5dCnrtUEHaefC22BNfa8TiveTFqG4sf60CpL8OfnYcUpx6pWBFNU9t20gK/IMXJxahyEzuTB9A+Rc2m4V0sFDTE3KrNOWJLOC3nXx8QXLydLzTRGguU4LFknsu842THRLId0HJ/ZYdyvo7DynyXu4YvdQRMlpq9d9hIuaQGThzY4gFsEe3rM3H44o2sVBlJphLuq73bfNO8KIsCV5k94hfNMF794z1kuDgqASqK+z3f4xlempQURPTkBBE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mohammed EL Kadiri <med08elkadiri@gmail.com> writes:

> Hi Jonathan,
>
> Thank you for the review.
>
> Yes, I used AI assistance in writing this document.

Please see Documentation/process/coding-assistants.rst for information
on how to document that use.

I would also consider starting to fill out Documentation/mm/slab.rst
rather than creating a new standalone file.

Thanks,

jon

