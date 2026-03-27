Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 931EB10F2865
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 18:38:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEEBA6B008C; Fri, 27 Mar 2026 14:38:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9F1C6B0095; Fri, 27 Mar 2026 14:38:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB4986B0096; Fri, 27 Mar 2026 14:38:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ADFC26B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:38:02 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 510E71A1207
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 18:38:02 +0000 (UTC)
X-FDA: 84592702404.28.D21B6FF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id A56F5140010
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 18:38:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ytes+29J;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774636680; a=rsa-sha256;
	cv=none;
	b=zBMrUNG2OnVo42kQ0h6kTR5KPm/7zh13bL2fsy37dOAmGXDCBoG/mYSrm92MIX8O3QKWE6
	txUI77yBwtGRjW17XmdQdYFxp15EDDvPrpsnifCyyC4UiuNr6208U3S6AP5lhZQcaL9WS0
	fenlSIPy7J40v2A4N/wKNs4ObSthTvY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ytes+29J;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774636680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zUfA1AKwUTDk0mezLXVXqwZ17YH0Q1XlFSC00+KAnkw=;
	b=IG/uJVhgqblFuECsVa706KlOu/q3lvAma8Mum5KQfYGvyzGuX/ee6In8QI6B+UC32m+AMs
	6ijc492hpzu3ZljeQE+stfnQJO2NiE0RmOW0YJ3VQAYD6x0VkzCCZgZR7J3IAr3gVnRip5
	2pOwdhQp+ooRH5C+B5umItPWAR/5uCA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C566160130;
	Fri, 27 Mar 2026 18:37:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD6FC19423;
	Fri, 27 Mar 2026 18:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774636679;
	bh=A9hPu3Yx5XNH6deOat93hvhGdMaoUB1VLQxEAPMexbg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ytes+29J+RSGnxenqkoI0Zz75a2dl4rJoUO2e+5d65dHfD+kwg2nbcpWa84K+CshF
	 IzC3nAL5czIB4hdIn2KV9oMrUk4YrTbDrC7+OVgdG+UfY7RmLN7NWUsFhSsiHNNAt3
	 Vc38CNkl3N2w6oP5ww4zF2VM1MKJ6SEFWNZ6at6Y=
Date: Fri, 27 Mar 2026 11:37:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: shivamkalra98@zohomail.in
Cc: Shivam Kalra via B4 Relay
 <devnull+shivamkalra98.zohomail.in@kernel.org>, Uladzislau Rezki
 <urezki@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Alice
 Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v8 0/6] mm/vmalloc: free unused pages on vrealloc()
 shrink
Message-Id: <20260327113758.75f04588310a707b4d4b1aac@linux-foundation.org>
In-Reply-To: <20260327-vmalloc-shrink-v8-0-cc6b57059ed7@zohomail.in>
References: <20260327-vmalloc-shrink-v8-0-cc6b57059ed7@zohomail.in>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jf7x9xnmsc7y54nn64879cxpan1r7k5r
X-Rspamd-Queue-Id: A56F5140010
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774636680-647390
X-HE-Meta: U2FsdGVkX18K42X+zMU0BTI+amOT43I98wlnDNNcvlrYhELTq5f7jADiB+o8GATTh9SBr+z/OS9R/IR3A4FBfla9TodU5W4GnD56IxboxLn7DpO5dV/oCewPeKclmH1F1MQ202GSHINAFgSXibkQZxjOstoeaKSm0AdqbuSJ+Q9PjgDehYxR6RRfJDKUfb8H6DsDDYwKf3vsyXA7Xfd02az77T00R31eMOYwssZ1RGfb26XLMBe9d+RDI0F+u1Lq4McszZnYq0Zy6dh4E1dikWsJ3dEg+PI4ydbhxo+s8+qBZH3XQTwtqqdqogheyF4qk/xzeX83aI2SOqqRWLpSl4HrPrDDa9Eon2UkFow8m0Tg17MZjrWuoFl/w1und/35u0UvsS6T53mLnW7mN1KoKVX0X8Q2il/0fSljxd9EfzKht0ZEb7T0WlwG6LKQmTLdV774FCseCrbvb1L4wpd0aNIu/LgAiOH0lDPgWmbs+QlHhVBgeL+kMpC/IQ+tbNw4gpFzaxGKuubJPY5lv1lw5nY8biylbrD8qPa3Q3Kco1sPGZK5UwcyJaXhFGWLNfpex30dxDqsAwFcHn+t/7i7unxIylsEZ6ZEM7dtME26p4TpcHzGz9++qIFZFg4JPbXX/29pwT5TNTqWMGhaNs6BHG2G0EPnyLcCUTzulZubbAvmzIZdlRNAy2UhU2LSQ4tVuLxsohqj7v6p8KfJoh1ARHo3AAYkDllDFsjvreGAphE7ImDiEMuua3JxOnHYwJuo9l6S7yNKPzqRpSLC+Nh+jUxDcmXSjymeNbs+YPFASOS6/8cY8WrUehABXfTAkLmF8FoMZZB6OStP7BH3tQ4ya1X6226TPzeKu4ZxTXg9j+JTJepkJwj4GxxhHuodS/PYMOnhPIijCZNfSJVhRxyv9X2zmy8A2s6aS9HhKX2ijWoh42Y2fRTBwix3kKr7f0Y2cqAQ1pgWRRGYer5JhAv
 TqDk+VqE
 zbhtmbLvAulbuShSaC0oizhP9mP5EGB/KpN9/xSW+Ufd/UTKgDtsEutdQ/ufwNuHOuO5p+dg4uOuhzp+vb6NbwStDjGy1XuJakcwlc9eTpgY2xAuXSXKBXYvj3yXzIce7wIycfB6H7jVeZZf8enu2qUKPdboQWnZmMwvvunvUsvhtQmhC0pdx+N9P891e8osNUoekPmhsghEzfOct5dy5tprAqJLRiAwS5jvz7RRjdkpZn+V6wYikS4DTENTQ5GS7xM3M5Qxga5Rbz6UpUYVCvACl/UARmXd46aLqqnd6Yc9sGdxpY1yvJHrtz6fdtGKcjUspzjFJ2xWo/SbUyoVkiB6UgwegKBbjbsjTdxKCmyh6SL8vRsNU93P67RTJ5f3hjxqY4bJu5nVOib52CCUw8WN80Qw65FfADtp1CeiUfuqH6UN2Eb4Xp1b5ddZJ9mt22qBzFl7d2wC11TbP77NGemFjHoy5o/ALQWb0TLRpKjmUAJPhSn8OmXzSUPpigKDngKliZS3CPUPyeCw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Mar 2026 15:18:36 +0530 Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org> wrote:

> This series implements the TODO in vrealloc() to unmap and free unused
> pages when shrinking across a page boundary.

Thanks.  I'd prefer to defer this until the next -rc cycle
(https://lkml.kernel.org/r/20260323202941.08ddf2b0411501cae801ab4c@linux-foundation.org).
If Ulad would prefer that we push ahead then OK.

Are we able to describe how much memory this change might save under
various scenarios?  If the savings are impressively large then that
would get attention.

AI review might have found a couple of things, one pre-existing:
	https://sashiko.dev/#/patchset/20260327-vmalloc-shrink-v8-0-cc6b57059ed7@zohomail.in

