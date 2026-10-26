Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A26E606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 10:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bNyAxV8M
Received: by kanga.kvack.org (Postfix)
	id 6B36C6B05B0; Mon, 26 Oct 2026 06:37:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68BC76B05B1; Mon, 26 Oct 2026 06:37:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A1746B05BE; Mon, 26 Oct 2026 06:37:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3BEFB6B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:37:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BB917C06C1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:37:21 +0000 (UTC)
X-FDA: 85364425482.22.9621A26
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id E549A1C0006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:37:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bNyAxV8M;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793011040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A3UAZP3NJahgTJzf87f0H07PAHvzme0ItsgnIJVLaoY=;
	b=fsDav6gJpwDaHbouBXc7jR69tpRcG9oS/6Cpfw1/ALShuPgHln6OwH3CMMvG/IDcponNib
	4zcCB1DXtFx9tJOVGzb81veXb4mqIPzoH5bA8ristw+i8q7N1XFGlnNA0NuQT8FGRZuGA6
	eMA6lNwvQKv+tnD2vNynCBnC8uZCXt4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bNyAxV8M;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793011040;
	b=SUCFpO9PS7NTDriY2UcJf4Gnhp4XrqKHJAy45oN533kcpgmJDDifIg0V/WRhZEKl6gxzmV
	tTnHlKta5sfMtgkUcWh8HZ4MRu35Ra/U7Ixit/KR7fzYB6XlGJBX7WksxZ2GdJmzgTld+5
	5fxen7kou4HUhaOrPIN45a0DCSgOyo0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 21DEB416F0;
	Mon, 26 Oct 2026 10:37:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235C31F01825;
	Mon, 26 Oct 2026 10:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793011039;
	bh=A3UAZP3NJahgTJzf87f0H07PAHvzme0ItsgnIJVLaoY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bNyAxV8MSqGKy9vRZSzVC96561skAasy5RTkam1kR+Fn+YU8hMyPqejJ9lJcuVBCY
	 O8ZyQgSpltM9mT8a7kELB6aKqX8eVemAIOWkr64xkB47kn8aLNFY1wndkhQVPMqefz
	 odlZckFPGAOWVYyrlqVNqfkYMz2mQAmlaP7cBf9OnhM68Ps2NC9y3NcrAEl07xxBOu
	 nyYK31N0mNr5nIP/CVUZ8CekaB2ghnt9pJr7QtXFicB0k6bwbVa/7OAE0gX6A+ZHwa
	 wjzeq917Ui2HCCtpht3kORS8EnTXbytSQrHNxKeufCO/jpCrlxBG+Mwb9gPnK70+67
	 EnYleJepahYuA==
Message-ID: <fec58606-49d0-4b67-9f28-df54159e29a5@kernel.org>
Date: Mon, 26 Oct 2026 11:37:11 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm: generalize kernel PTE table allocation
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>, Arnd Bergmann <arnd@arndb.de>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, linux-mm@kvack.org,
 linux-arch@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261014035910.687847-1-songmuchun@bytedance.com>
 <20261014035910.687847-2-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261014035910.687847-2-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E549A1C0006
X-Stat-Signature: s1si4m6j5iaq8gmjkdptbgrsfh9wk4p1
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793011039-53135
X-HE-Meta: U2FsdGVkX1/ZthEOOtSpUZIroJ1jXAU+dsc2QxuGXHiugVJjTkhnx7nX9QwcHT3B9BVgzfRleJuDzKNQSOb3DWTzcaa0Noy/T+wgAJ4wPZg3cZ3nVqonDpE9qYcv+/xEDS0DG9e9cfKBciBGzGq1VpIV3yvcRUZ3+j5eOeHOfzwNGereS2QjgsIVa5p84TDXCPJZqx0s7S8F42vxV072QjYEb18CSrbLYgwFrGZmrbmZPLuyU4aR7l13EmA2YvuXY4OzHik2q0mhfmvR6aIjcct4DwbF6UTlRdhg94iIm42Bu9jPJLIT+jxccMTH8ClipkbmIDTaba5NhpEhYqC7lqwnIJAnq6RSqi4+Cun7H4nWok169KYa8yvYpt4OTu0Ic832J+j7Yamfa5Jl3ivpcJTS8pR3aJVrAXCnoNdchsPm8OgvS3GCOGmOpBUaqQBqCph4Uh6VG9Sz5alYT9ZiS/a1FXkthj6KuOwEST2QFenT68+5ZTlcldQiAaEK5XCxxtbl5fbhTZgFF8LsRw0oPifOwxHEey3YmrduCgL/lOjQTtZx6E1LVhAHkof3MiTsm3klQ/pRjKNXjsSP+fwtvbb3dJYeDESZGFO6VVylsnKikDXy4V8fY1ciFiGgZ/dG0QYMZdtXnDucX5hhARgXKN4rONqmr5F39fzJZr5oDjOypP0TwDpBYIj5xJsAz/+d1ZhNgjlFjNhGOYb/cBnXGqSl3aBwaRAcSxEVBaMAw46oidjFbc+tYP7xfc9OCeyNlnD8mYCjwfdE5C4/lq5Y338i6E98wtS2+3s5UHO6l73au+WN+dtG8pcbO1bmn+kP8VaYGMUuSeLOGQV9QdY4l5/Qk/lPwwTMOoITpCRZ0LZgAaYVuJHo1RSKtmL29Rj0wPw5OAZ5MTtj3x832f/6UfQCZMXGIiNIscwFXYzTMySeRmIpPi9zWq9catkU67onRf8Loj3zABNV5WfArNa
 0f8M9DGw
 sWGUAWngzAN3S49SKge93PCMctZvM/w0HXmgy9JziZukvmtYnqPQNAIUvGUcIWD9FKwgppGIrngDxX1vWP8cI91ePQPsRi0z7GO4IoT5V07o8awKjJpyw0HvZPipTyZBdo1oz34CcQApcndv9G37K0Wc4UUV3j+78VNHkiWzORt+/AOlb5gkjHD49yduEMzl7qUGGiriatauVB9udtv2Wn71YL7Q85PZ7UHRIH59Bv9+6N7MnNIXWyoBsHlkp5pBc5B9/kjYffgf6t04n7eDDhlb1O4Tkigicm7b/B6uTWZs6g/r85SspVsq4N0eFQY333cuRer2y75ekn06Vmh1Q8MFDprA0/5Wp/Hk5YgeY9TlB9Us5IsM8WIMArG6RVJgXGCjv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/14/26 05:59, Muchun Song wrote:
> Architectures whose empty kernel PTE representation is not all zero must
> initialize new kernel PTE tables. LoongArch therefore wraps
> __pte_alloc_one_kernel() solely to call kernel_pte_init().
> 
> Call the architecture initialization hook from the generic allocator so
> LoongArch can use it directly. The default hook is empty, so this does not
> change other architectures.
> 
> Assisted-by: LLM
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

