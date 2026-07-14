Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0F73C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 16:40:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 722946B00DA; Tue, 14 Jul 2026 12:40:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D3F36B00DE; Tue, 14 Jul 2026 12:40:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C2366B00DF; Tue, 14 Jul 2026 12:40:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 34A9B6B00DA
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:40:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B5573A0464
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 16:40:36 +0000 (UTC)
X-FDA: 84987945672.02.838DE4C
Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	by imf13.hostedemail.com (Postfix) with ESMTP id BE7902000C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 16:40:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="z Zdw/Zw";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=mquybT60;
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784047234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zOFwnYn8fKwb2zNmcy6xu4xuyuD89fwUpbMgojxdUPE=;
	b=YLT30RT1w66MM3cP1nW2/WpKhjZBUuA/7dp/Bubzmf7PwlFL/I/2CL4JwSOn9bNSt6xbqd
	8qXF2v80M2XJcRtcIX1cCBTnZyhD/OqXEOnWiBKxgBVbNmLk2HTDkyaxgbVsuqMKLLQxGm
	TuvPYmttUthq9hUac2I91W9TDOhZ2Ns=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="z Zdw/Zw";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=mquybT60;
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784047234;
	b=o8vPJpoeNC8RRFKVyC8t/B/JIhwcEW7Efxs2rowfMHhMBulOHH5pZeejZiSMvNfXy5P9M+
	SxoRub55HDC06q5XfpqKcc4ImV4gaGmdZH1dfwKY8yUukP94xcN+v4HsEqCYHxtFH/rPRB
	/h/ZRAktSzw7uGNjtCEoBl2A7JVij7E=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 0E71D7A01C4;
	Tue, 14 Jul 2026 12:40:33 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 14 Jul 2026 12:40:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1784047232; x=
	1784133632; bh=zOFwnYn8fKwb2zNmcy6xu4xuyuD89fwUpbMgojxdUPE=; b=z
	Zdw/Zwyb81IxsqSfNS/raBGeuan1HzOQYWrNFbkXtZWmrGnFrHmwhqDveaZMfmxa
	Upjrr96mJda9sxuSQlC0XwMD3+dodrQIofGl7Ftxh5/PVKgucEA50e2/XAWxoH7E
	scd89ps49a0zDXfA2O3ddEu08apFSBxwA4E2uIqpGF4ZyXHp8vN6QgOwcZDUFdWE
	W01jTbMi3FjN0HiZ/8YGvN2jV882DY6z9ACQ2xwKSMhpX2lRglxuBWFpQeiYHBxD
	ixqNwxCwAHE6mrM5gUy/nUdqOLWlqneYhqs/f9Alba6ripl07oC8xSi1JvHNEsUh
	JmazU6KNQRAjeo++ovyeA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1784047232; x=1784133632; bh=zOFwnYn8fKwb2zNmcy6xu4xuyuD89fwUpbM
	gojxdUPE=; b=mquybT60523LAiJ2lXKXHpZMf++q3tFZxxH0PpCZJ+L2egIWwRJ
	xHr56f1D/2eLxpNP5x6wxqf6Xksgqqiw2GoixnaI+bJWTOFcNAKFMO+E3feYMJw8
	ydIprwdrSDyh6CoxBQ/rCQvEA+ojyjD5+YJvBjqkBRR3F0Y/ObLjYsjDsnMbNgqX
	0VuAtpJk9eALBauGIrRIRDJHA+AjgLBiExL2eTFFhkT58G0pUt/iTeRfQ6xkymGe
	eRK57WPYp2Jof0KA1cGr4BUHJliBODEYpBepT2M6YNqK+hQeZ9PW2OvHcr4Z8nUr
	EFq8sUpfAzDr8SutMP8wevnrJsYDMmRv1eA==
X-ME-Sender: <xms:fmZWaq5D-KsdSDYOKB1hwgrXn9KpwKA3sKtZ3OaYjMTlZ76SGDiggg>
    <xme:fmZWagpPUCxO367GuUOsYJ1tbLutPRT1ejqOSY4nv7IFLyntKom92p5-4anvVNzp9
    YYMfA7oW2FflEQKDlz_4eZpDSWLQKay_Opu5H8q1JvkZQyT3MkT_CM>
X-ME-Received: <xmr:fmZWapBtjlZpF7-AkzT5080VuSIE_r2onpwmP6URLtrWcptWwhedWuPe7KgtZw>
X-ME-Proxy-Cause: dmFkZTFSadJpVIVVrErQQ5w2CnbepoBgy44z029bkLXtVdKgSSNPIZMzKcIe9uqZn4Tbaq
    zcj6CdDtshQXjIieWXYkkTfUGYylzBJqUB2hRsg8qh/r/r9vzfNUv5SVdDY0Ft84tTZRyx
    +mY1ZeuZa7qeYQsG5vRcrTz+ioyIabOvZ44WliUYtezZXEAJwUBYvCHEhVP03OZpJgfxD8
    fZCiyklxgLdmqhr+dwiUZzGaJfDfH8MQKxr9EZnuy3KYT/bDXTZ9zZ1QKyBmCqduqKoWDw
    HLv9mdSi78zC8T4D/qQd0Ds7osYCRNpt+0Kp7xPiFqgGu0HLHg3bACIjI/eCiao0pPMEHY
    ev2V5YusamRF+J7KGyZOJGdSanPVqrxIoj1oVwDyLHJYVRyXnKhVRrFXYZbjNwmxFiJi5h
    jVSxmFi8jV8H8Z8fyDEEcVqEdHRcQ79+a7mCg3RbHvo8BLuDTsunMnmod0kE5zqQy4jEgC
    MDS4qZFhCQBbtYsYtXTP80AC/cJstV82taW5qsjQ5TBhe3tzYw37RiMCt/0JdQ6U8ezWUk
    L5ux+tBqdEenH/RgxWXiXCZtByWIyRYflPUF6AhzyKotiNOIdNHqkqzmnaS2YcaKA5HvD3
    pTObWLxx7xQA9LhUvSYhD/Piqh3gkF1z10zu/ZUvKBFjfTo3XFazq68NcfFw
X-ME-Proxy: <xmx:fmZWavxgOIUfIw2YCggDwLwNxjLCbk8Ufg3Hbzu33KjZ67TjCwzaFQ>
    <xmx:fmZWaiYW3te2kHeUvzxj73M3nrDHuNxK3CrvRq9e_YvZSSUB6-p7yg>
    <xmx:fmZWaovWViWPM5Y-l6a0PdpvnjbVEewYF7K0RqTlpSg023PBeqadgg>
    <xmx:fmZWaowpcDOQ-L0rTa2QzV5RE4bCh8LxjMsJgFI7WNlVX_qx-DQRFg>
    <xmx:gGZWaseA5mjguVNQhqIQPGtSlzou5PrQLfCFrEGriXgeYQaLmz3zjq2K>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Jul 2026 12:40:29 -0400 (EDT)
Date: Tue, 14 Jul 2026 17:40:28 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Hao Zhang <zhanghao1@kylinos.cn>, 
	Hao Zhang <hao_zhang_kdev@163.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/5] mm/memory-failure: keep the folio, not the
 poisoned subpage, locked across split
Message-ID: <alZljHr4Nk3FOpCP@thinkstation>
References: <20260714122344.351895-1-kirill@shutemov.name>
 <20260714122344.351895-2-kirill@shutemov.name>
 <c4aa63df-30ab-464d-bd0b-48dc37c8e6ba@kernel.org>
 <alZNYYsybKZA0eJb@thinkstation>
 <18fe5529-2ad5-4330-a362-708a152bacee@kernel.org>
 <66A57599-EDA0-4E99-B073-F2AE0B2ED708@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66A57599-EDA0-4E99-B073-F2AE0B2ED708@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BE7902000C
X-Stat-Signature: yipg4rymnw3rk4eo958ckhu4mfaqysfn
X-HE-Tag: 1784047234-56410
X-HE-Meta: U2FsdGVkX191so1WNXBUA9evAjlriHC/2pssvkMiqw+u6r7n5/A1CLaVUgmJlfmcfFfVLpsb/heOE7tHvzbFjurhR81DgZzwdH+dETVLuGGXDwHWiz5gVpgcYrXNSh6bg74HvfP2Oj+4ONlvNXeHJly2onsmQZ4gjDggDYNk3w0fKkCSKwooLfj6YkEEG8+gNqBWybHD4L6FuHtwTepfTssRrCfp2aqsifikNoQ1L3GHXrMepl6UMipozP8XLbdyKc70A7IyB6bn4lqKSoCQWfWXFanHApQUwza4kKL6l/GlYJhqlFdPzcWaV3VucIPSBv+VUcfODJOr7khnLB/6FWhMbS4NiEQ2f+fRP/+08C5a1zct3J33DsdPP44SnDNbVJsMttAQ/GvMmZ00C5hG7JHYDPeMSuQ7Qwl40ASMQEv/8bXH6utSC3cVnFa+NyXHtrySN9QacGr4vy0I/xEKAZFqMLfWPy9JuQfaqNmLTf5Hrm1NqA/RoVJaqgm6YPMXzd5Z8GvLSRqkpwXe/gGFlZ6BMjhRWYIh7KhXndg8/x+OYhognZbiRJ9QqNmIl9J1VVJI7XrmiCY6HJoYG05EO88HJG/04y91A32NveKZWfNmkdvigtnpFvHlBo18LXw+YobK1KGOCC0A7fRnFVU+rze65VBNqgSMXrQD2Fn2kRmBXuj92ZFGMXa+O/LpU3C/0uDmKn7KikVmmEPopHXMWoc5NTZaK1RxrljjYo3zNqWeUTiNbqLqydznjhLfUC+r/Xvcpgt7iSiJavr2sxRu3INNV2Wdiff5ZAIgAktihAayyiN+M2WCinZtoRLL/UhN44/SrDwpCya9BfAYNBnOgetCDvRJUnBb1uJe+L+BrNzbvw7xNEVTyzqHEeEKROy5nyEH3QqMbdoHjMgbJDNuYSBOiXmh+eRe+N+ylIA5QBQqZ8OCzJFA5sOOwP9ir5d8EPQ8DOwhbV6Ygj2uRus
 cDWMQPJ9
 ct64IzzXPb+mwSaHlGazM/Ta8A9LGTnUxms3cSs6r1db5BTjuXfygAqSB5KfJfmx/69bQ/qsq+7/JaRTg4ySA0tGU/oSOQwsLLAEJc6jpna1iVdbvVUdB2Mkt3XzhGKP7VMq6wZ8dhE+L/Eddqa+pEgEk4RBVY2H2ZcO8jjdRwsstEVBe470ZPvxBI3OziViwx+/Zwvf6hQbbpbpF2exfhU1eZZZ9u9a5FHTGsxTYGnaonubt/bAjKamIdkYmu3iHD30uV18JZWTUkc0Lq8vXdEbSvnrNgZ6jEPhmlePh2r8FnuOKYOC6nmdk7Cs8rsdAFnH5QfD4z+I/FFxo/Lqra8edZnlqb8JSptV0OTPg5qCByEzvCGRFJ6noL7tldq5qtzGSESQwalLqlnpTtzmRjgunCz73UyQ313wVaNQkGr4I6zWGwD9FUASyxzBZ5U9WaZoD+M54X4ecxetlrgrrb/RmtjwtGN8IeOfItbG3FrHHP4mqlFICXFFktaEsw1JlcG0lWcpToLKG1BI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 11:44:39AM -0400, Zi Yan wrote:
> There is an alternative, only igrab() when @lock_at is at or beyond the EOF,
> as I was bouncing ideas with Codex.

I saw this option too, but I wound rather not go this path.

iput() still can lead to inode eviction an bunch of random filesystem
complexity under us. I don't think we want to think about other
fs-related locking issues in split context.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

