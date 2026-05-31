Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D803CD6E52
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 16:39:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C24F26B0152; Sun, 31 May 2026 12:39:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD6546B0154; Sun, 31 May 2026 12:39:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEB616B0155; Sun, 31 May 2026 12:39:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A083F6B0152
	for <linux-mm@kvack.org>; Sun, 31 May 2026 12:39:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 482DFA044E
	for <linux-mm@kvack.org>; Sun, 31 May 2026 16:39:06 +0000 (UTC)
X-FDA: 84828274692.29.6CF74FC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id BA51F40010
	for <linux-mm@kvack.org>; Sun, 31 May 2026 16:39:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hJq04HL3;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780245544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XObA2UMxNmwwA42Wy22KZAaxCp9zZ0vzc8OHq2Dq5MA=;
	b=CK1SFbAm7ll+6r/AErhztnpBzKi6gPOx23fDFGe3AQ/R+rTpBFg7qkJSvIehHsceCYDmJJ
	+2d21WDWJeGl3jK43Y8clnxIs+H4DK6/AeejwUxeWscHI+jbLMxGuJ/xHK1RV6FCAEF4Lx
	eGMACA6MKKo4+Wi666RmOc2yN+j8OKM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hJq04HL3;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780245544; a=rsa-sha256;
	cv=none;
	b=A/bYbvE4+O2Zvyzp1oFa22QnanCE7dJLzSt2Y6vZXP3yB9/LsHg7FD2mvtJXOe0mYAnbKb
	H6IXD6GnaeyAzlDic1gIeIotYpxIebBix/WAdzm9tjT8CQpjRjMKQthn//kFQbUO4qYqMR
	Uid14ZphOlDwA2a9FGSHJYkGv2VduXg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3511E6008A;
	Sun, 31 May 2026 16:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925311F00893;
	Sun, 31 May 2026 16:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780245543;
	bh=XObA2UMxNmwwA42Wy22KZAaxCp9zZ0vzc8OHq2Dq5MA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hJq04HL3vQiJINojn4UPi/GlrwiB6abd4pbsMxQMxO5wA7sovcbyUeYJvjZMRgPou
	 zObxP9gbaguD0LJwY8/jhJLdNezfFUGyglsFPZOt9I3jnz8SWuMIKzkLJaL39oDCTB
	 KjDwvOKNPde8l1o2eKI5r6ZMT49MCKr9JbHAx1kb6+Jf+tCWs4fnlW6/F58B9f+BJW
	 J4U5Vf6X2Shn/UU0f4MdjzvyChTN1vYh3pVaXHP4iLrXeBFCQUDOQxTTo9Q5/5ere7
	 oeAvHmL++h2mOylMCufG6+vQhwD7IxUV7Cw1Kqq5Te5Amo2beV0oMMtUDHSHHg/1nf
	 LPpexWTcuEHjg==
From: SeongJae Park <sj@kernel.org>
To: Kunwu Chan <kunwu.chan@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	shuah@kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Wang Lian <lianux.mm@gmail.com>,
	Kunwu Chan <chentao@kylinos.cn>
Subject: Re: [PATCH 3/5] selftests/damon/damos_tried_regions: fix expectation output and join TypeError
Date: Sun, 31 May 2026 09:39:00 -0700
Message-ID: <20260531163900.99184-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260531091724.84381-3-kunwu.chan@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: b8pcm3c17yed7eautkfo1bwb6t95dxpf
X-Rspamd-Queue-Id: BA51F40010
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780245544-309049
X-HE-Meta: U2FsdGVkX18FQMWmQlcCf7K54IFO6EbALEC2C9bvmshmq3MnKTmZ0UzXKWUlb/MtIHRsh5JWWAh0Ij8hmSqQwUI7hEwJn8yA6sVQKmGUd8HeP1gdNUCuEq4+vI4p0665KVH+gFS5MgDiQfMwqlApVVPU2Y3Ph67mZedcKqsMk/Ryc3vgBOy+J0zOOhBilxIPq9P03sD65c1/h9Oy/J3nkyuQv60W1we5RKLCTYv50zy1/+2Ryzl4HqyT6CmwwYp4VvVxH/CtD2ilrnF6VtUGHQI7EJ3dl7brBhRfyzG+9KULRrXnPDlyWADozzSQ/iMysFOFqjv7+GqRUNTm1tZMw9hMmMN6cPpkmC1eAz6oDsok+nZ35yVOukD7ZhC5R5h24mDl8J0pf8gEjj0H3+gw6XMZc8HKh8nS4pZydywGK3BHRcMovx8sviSsmy3pMw1GoQbz/HD96ZS/+mMZ5SNzuXhRbEwT7dHoUKB9mXN+XO8BWsdOvyOzhFVCMY1tbItyr2Kjf4U+YQ+3FAcd1qzS93qL3//Qh+WokMp+yJ8JXqW1O49bgmWlKGlPQCXhhtqXy22w74AjVyYIKRtdHba9es+iYRBHwTdBUq9v0btuW2lg1z/mCDfYq2sWZ3+T8IgX+5hvq1K1NHiFUZSEg9JE3uUCcj+vKuIeGTZqZ6KE9ORh3CvrZqbJvIe8fs753th4dRdwgn2E6r1zWT5yOba0pOjn9bPhxzgi5ol6HHoXUpnWBWAjWZOr1Tw+as4GaPA/xUWYQysNs4L/QoVDsFr0tB+j8encYDc+UJqjvT8JaTHy+0Q+T/bGZG22OcseM4V3PWDmoyt+JLtiSb01rI+oufPdjU86ZAI34756tlXoQmDcwyfZqkpEQO3A3AvbBlJaTYV3O6vUZLjvKTn6JA6neXueu/aBjG40R0U1MYnDCb8JgGmSIvPwfMEUc+X9LDmj0DwaY4QdHydlOj3WYf1
 kwknMQQD
 M4KCuhL9nuy4b581LlRySRP2DTETuQQmIynAmwJBPTG+JLxNdekjJTNK0ixi8AeWGF6TLYsAty2MaHykK9tNcWAzq6PCDVhb21ym5/rhY5axI0a6bq608YO09GalnAUnFPqOeKwrpTypCW7SrzYXlasS0XRqTviqfsF0FvHtvzSTgy7vWcCV/jd2zb57ceCiVpo1q98AjtT4ejnvrjpjlk2gMMbdFsMKzefV8E+0NtElGWXcC9dFBfXYOIxzInumm55BYpSGbmLJR7W1jXIi7QVG/zyKmYA/7Q/zCkPohsZOC1Cin8huDNyYDeUQThuGqDHvsmKUHEsvzC/xcBEBgofJiXhGI4EhglQGEHsgd3ArG9w3VAyBTCN6JD6JTKmEOAKoypwE9xW9OYmQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 31 May 2026 17:17:22 +0800 Kunwu Chan <kunwu.chan@linux.dev> wrote:

> From: Kunwu Chan <kunwu.chan@gmail.com>
> 
> The expectation print has wrong operator precedence: '%' binds
> before the conditional expression, so the else branch prints
> 'not met' without the prefix 'expectation (>= 14) is'.  Add
> parentheses to fix it.
> 
> Also, '\n'.join() on the list of ints raises TypeError;
> convert to str in the list comprehension.

Nice findings and fixes, thank you!

> 
> Co-developed-by: Wang Lian <lianux.mm@gmail.com>
> Signed-off-by: Wang Lian <lianux.mm@gmail.com>
> Signed-off-by: Kunwu Chan <chentao@kylinos.cn>

checkpatch.pl may warn here like below, and it should be fixed.

WARNING: From:/Signed-off-by: email address mismatch: 'From: Kunwu Chan <kunwu.chan@gmail.com>' != 'Signed-off-by: Kunwu Chan <chentao@kylinos.cn>'

Other than that,

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

