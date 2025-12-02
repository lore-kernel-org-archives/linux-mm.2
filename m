Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 909C8D12688
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 23:23:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0E1B6B0027; Tue,  2 Dec 2025 18:23:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE6326B0028; Tue,  2 Dec 2025 18:23:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B23106B0029; Tue,  2 Dec 2025 18:23:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9B7736B0027
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 18:23:24 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 561671402C5
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 23:23:24 +0000 (UTC)
X-FDA: 84176109528.18.B0A4AC5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id D692A1A000C
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 23:23:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j1+RzGCp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764717802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wvBqm8+lzXFa5X/EA075FJ2SCYaupMK+njsfDl+P8ak=;
	b=W6ZE+z3tjAqkVioN/maRpeM+kB2bozGCigTtPfYEOEdyFBi6ADX5MaA3ASSnDpso9ci0Bo
	JjhIVjUfZc+mBjWtYeeYbQ0f4J9nl0dUBHOsCaJQ8auzojNI63msARXhLsBaQdJJ3iKM59
	oCO6kIsXIa45BHq/gmDmiLMJTBMC6sI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j1+RzGCp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764717802; a=rsa-sha256;
	cv=none;
	b=lvAErFLef8pdU1fm9POTpXHNEqOV+GwxI3WEyy7KAQtTwDUnMppO64BlANCu8MT21/koLS
	OMesNOi9c7gkXoXSjfAwOgEuAZ5Tj0Qz0JbKknUBqZ6JXxF8qy9G2PFkQaTKPmWnDbyRBJ
	vAbrVd79O3bdcF0LbFZxlMYUufjTpfU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E9EC60144;
	Tue,  2 Dec 2025 23:23:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C042DC4CEF1;
	Tue,  2 Dec 2025 23:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764717801;
	bh=S93eJ0Eu1zfU6fil9PyTt+lgYx0wNxFtPFFERmhsitQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j1+RzGCp8Ds2mGnAkkCXz5a2tsDMzcHoUprQIYTJtUPQWzUHYUJEtvmK0aqckp3kU
	 11MbIu6e5UEGJQAiH32gkmYShdxPBnFFd/2Zb1+Zp/7MNUN8WkGwKIn7XzN+IkVdyX
	 a8FNxZey1CymvoGiNkkwMlMSQgRcPQVERuiORDBIHtyj9GlaPb0e498DbRDoGGhdR2
	 QjXwvHNO/vEQsNqHgf/DQ+a1OiJHQc38m2F7Nh20z7/sLYXghwanbYrBth7521FZc2
	 bgJz/eCiQzPhtMLGwTCGwwcO8W7PHJ4GitaUYHBgVtm+m2MwJ9VDxYLDyb1S5DR/N6
	 0U+tuwbRrDO9Q==
Date: Tue, 2 Dec 2025 15:23:21 -0800
From: Kees Cook <kees@kernel.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org,
	syzbot+997752115a851cb0cf36@syzkaller.appspotmail.com,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/kasan: Fix incorrect unpoisoning in vrealloc for
 KASAN
Message-ID: <202512021522.7888E2B6@keescook>
References: <20251128111516.244497-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251128111516.244497-1-jiayuan.chen@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: D692A1A000C
X-Rspamd-Server: rspam11
X-Stat-Signature: 4fh45hxiztun5oh8qx81euw8jerityfg
X-HE-Tag: 1764717802-342053
X-HE-Meta: U2FsdGVkX18u1YReNZW2yHz5u9WMp1i07zuUhX0xlA2RrOKuA7rL4VnFAkJWKEH9OFvVvfaFR7xsg9S+LcXhhoHtlPxqCZQMYvru8AfSU4igzT8Z68ryL+35jG08TfAMbXMTsQ8JrXUuC+E/6TZI0xwT7DQYaAJWaSyakiMbWS4BxVKDVrq5fjkTF6uqEIw/BuLCUlfnX9P4opq8DUxeNo+lNqiGmKrJl1Em3oRyIV6mUOCWyYroFOVTku0ysk3bl4OJ+gY1Fr/Sw3qgS5dQJmzDAb9LVhfibkt2s6v5KunV/r71wzsTAMo/Uq7YaFxytKtx2oL+MDHbvRxzT6w7SxwKL4TXaBcLSkwTQKw3kPwBjEuRfGP7STR5it6aYU4jM6qfgn9nguc3e014p5y3+ixnEWFNBs11ngC3jPShcu2FAXhSx1JBTnjnK2Om0su0LaptMuZUWonZNXerXxtdlI9LtEwUGQe1ehhczrZ+wyxl2SbBW3Ryk7ALr4PEcZL+UGHLPk2VqnQOaWKmzMF5zvgCjg+5MVN1QkP1/pFS6wMG3Zw/zQ2vCbTV7vlhUXIGJe5uhuNwQEH/NeWnhkTYpg1/DIJtGZPTWsfgOHeBQXa8PlbCgTwD/gnm9SEWyZkuNOHHUTZanKS/vtiuleBi0ajzFiuqjDgMZHvIX/jqxXRjUeWGVj3hTAIfLalnLNZ3EqkoNSuyls6tQDexQE4Y48uI+LE1E4q7erlcKR6oubSh8pP4uLE4/yI8DtlsNMYsORIpstC2JBCeJLGahqMfPa+e0DDpUjzicU9lJyxiBjgZP2+osry5gVrDlB4AlE1kDv9x4dO2RQJAY9EGII4tu1djfQIJSf/6qXA2wQdlkzSPXjhdavdTXC9GMItoB/B2zkm+egQIEJtnbK9pz8GPkF5k8UnD3OIsIsxbvdFaVMlL5YEn4aQ3h/iKo5dtOQXZ0aV5SAmQwsr85ffSMau
 CzN5QJiU
 dXKU8pOR+gbPEmVtuYOjBmdymK+AF9I7zujqQSWnJR5Nx+o/ZcJnlgGTopQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 07:15:14PM +0800, Jiayuan Chen wrote:
> Syzkaller reported a memory out-of-bounds bug [1]. This patch fixes two
> issues:
> 
> 1. In vrealloc, we were missing the KASAN_VMALLOC_VM_ALLOC flag when
>    unpoisoning the extended region. This flag is required to correctly
>    associate the allocation with KASAN's vmalloc tracking.
> 
>    Note: In contrast, vzalloc (via __vmalloc_node_range_noprof) explicitly
>    sets KASAN_VMALLOC_VM_ALLOC and calls kasan_unpoison_vmalloc() with it.
>    vrealloc must behave consistently — especially when reusing existing
>    vmalloc regions — to ensure KASAN can track allocations correctly.
> 
> 2. When vrealloc reuses an existing vmalloc region (without allocating new
>    pages), KASAN previously generated a new tag, which broke tag-based
>    memory access tracking. We now add a 'reuse_tag' parameter to
>    __kasan_unpoison_vmalloc() to preserve the original tag in such cases.
> 
> A new helper kasan_unpoison_vralloc() is introduced to handle this reuse
> scenario, ensuring consistent tag behavior during reallocation.
> 
> [1]: https://syzkaller.appspot.com/bug?extid=997752115a851cb0cf36
> 
> Fixes: a0309faf1cb0 ("mm: vmalloc: support more granular vrealloc() sizing")

Is this the right Fixes tag? I didn't change the kasan logic meaningfully
in the above patch, perhaps it should be commit d699440f58ce ("mm:
fix vrealloc()'s KASAN poisoning logic")

-- 
Kees Cook

