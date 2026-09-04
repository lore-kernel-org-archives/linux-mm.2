Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45FF0C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 16:31:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E3476B0088; Fri,  4 Sep 2026 12:31:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 094596B008C; Fri,  4 Sep 2026 12:31:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC4D46B0092; Fri,  4 Sep 2026 12:31:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CCC776B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:31:22 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 48B1CA0132
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:31:22 +0000 (UTC)
X-FDA: 85176620004.02.7472702
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id A8DEC120011
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:31:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RSemKsnr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788539480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j2r0KoKgq2hanpcV5bTU2teAuvBMeSQzSfhGhjq68n4=;
	b=YYkuE1P/Kh02hQ8fXU0mLpKfAY1c5nBf+JqBFNdFqRk1/Sevae/rOKYmMXRFkebS7xMySR
	zTqNYvfTW7fGAA2m7fP+QBJ6AJjivVZQfJy+1Jkivgj/WIq6EMnpTDdI2FjO4Htb6pqimH
	yIM4VBSsltm4MSKQbq8l9DYDzzK+XPQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RSemKsnr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788539480;
	b=tKxSESS62V4OqnLugBqtVfpoHBsfyUo5fXZsIQLcg18YySjgffy4/fWBTJcl5pQRMn+Jo2
	ZVM4RbRhebmOTdwYknRoTb9Sim04vuU9816A21NeSNisdGY+lIhw9OY2Zfbse7MDeS14Ih
	poDLa7LyXg9vUVe3twK4dijtK0W7lDs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 304666053B;
	Fri,  4 Sep 2026 16:31:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9101F00A3D;
	Fri,  4 Sep 2026 16:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788539479;
	bh=j2r0KoKgq2hanpcV5bTU2teAuvBMeSQzSfhGhjq68n4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=RSemKsnrj3pHIuCVbsnDLx/wt1VFKGCe9P1UdS6sS6D04rgIzeYeog59OxZ2EqvG3
	 4AoaR2OnVKDz1Co0MgXRuABNi4x2XQX+ZYdHLu3iM/VWdythmpqCdnMLx6+XYGm1BO
	 JNO8PsqwfVAFpnfg/FhSD3yh990j6d+v+ucSzEtu7vyOBpUTIkni94ouoUaJMs6CVv
	 a49FcY6Et2SNenPmkKiozk8+UywCqZhX49cOrgY6YA8Lg+7pgnuKd6A0jjpme3RJzw
	 ZqIwYCT6BiFXcFWD/D7XByQ+oYxuP1mxJrw4CLvt9wIQONyOE2XdEcb6gcq0wPPzhF
	 1hAhD7grQ0peA==
From: Pratyush Yadav <pratyush@kernel.org>
To: George Guo <dongtai.guo@linux.dev>
Cc: chenhuacai@kernel.org,  rppt@kernel.org,  pasha.tatashin@soleen.com,
  pratyush@kernel.org,  shuah@kernel.org,  ardb@kernel.org,
  guodongtai@kylinos.cn,  kernel@xen0n.name,  graf@amazon.com,
  liukexin@kylinos.cn,  loongarch@lists.linux.dev,
  linux-kernel@vger.kernel.org,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kselftest@vger.kernel.org,
  linux-efi@vger.kernel.org, Sourabh Jain <sourabhjain@linux.ibm.com>
Subject: Re: [PATCH v4 4/4] selftests/kho: add LoongArch vmtest support
In-Reply-To: <20260904031108.11986-1-dongtai.guo@linux.dev> (George Guo's
	message of "Fri, 4 Sep 2026 11:11:08 +0800")
References: <20260807103714.33074-5-dongtai.guo@linux.dev>
	<20260904031108.11986-1-dongtai.guo@linux.dev>
Date: Fri, 04 Sep 2026 18:31:15 +0200
Message-ID: <2vxzpkytvuzw.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: rhx9hhdtde9ptr7cxj8gb5ruaaz3spmf
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A8DEC120011
X-Rspam-User: 
X-HE-Tag: 1788539480-602829
X-HE-Meta: U2FsdGVkX1/FjNt1bm8rMENVNeU3tYuFhQu3MwMIpmfZ8tE0FMis1EQKjrfvJk0vHXKcMJjoqQNgLhTQygapeDZjf3VgKuu9FYE3/FqhX7Sh0yf0VA0JVs2g+kACGlU5BU8MqejwDDpPN3vSdcMcwEy07j6tXUSaJELmj3SPaFA7YWndj/NwqeThFx5dUXYzeNwLUvwNrj7/pY0yO4TsJuKh36gzww/WBAv/pt0iEHabNVqkylqfOjrzIzf25itVQO6cQKXlEFsqmpRk1mN6bcZfMeIdI4KhFje8zvn+B/PYnlT6CroGpp/UTQFgmH/a4r86Y9lLjWIJzOwlLozB0caSFFhsXBFJ57nNMgqfZ45TSwefux9YCLcsXDBgCScahMtEXa3wQB/wxI8fu6T1lUG9sKTcNSHS/of7ZXaLFOahdlR+yXAHdm9KPKRPKREGjPmOHqjRPJhYEWMN8fcxg9mIgrg11SykeIgBt4MNDnLAf8t/WYAMYya4rvKp23xLn32YAL24F/XebWBAesH9lgD8x9m+/9/CC0ZyFQ2jHLnzVSsbRT1gS1l+dCTSYA7JC3bw/d7gA0XwNfHfYbzHi8EFaA3p0wTMeYner//oB0YVsfqdP7rTwbxqsULzrxS/a418KcirrMtFtIwLKnaQITr30OZ7bL5C02mzM4R6NVXb8XNCi9WeMhdcPDEo+DaiZL2K87a0Y2hwBKaJbcc+/06RQcSztG18dtxrYphO+DP5EyIsIzYCThWtx/537E4J7OJQRnjtKg17vIqba6uGp43UP3MQgSRzmva0a0xXM5odPT0LZ1gLuk3DkJSesQ5WxRU/+K+5gkDzsCuUJn8VXISMEf+FvT5cQqRpk39204pvChFXkg2DPHeHCIH+qlwreIgBJh4eZ3kzcFRNeOkJvb/qWspwA8bIcGwk7748hoDQsU9yMV+bU38cC+VrQqhRTLJ/H0/u9yxf2Sw0jc0
 QbdbgbaS
 jc/hBv8QgvuHzCzkFhRz6INuNCHYBBwSA96YszHJ1So1Fw1G5ZZBg6UvGC4ZKg8raC0ZHbNonwE0tJGBkXNcSK0poQiGOoimObnEGVBw9EL84IcKwH7pNcqOQOfGSH9YtC5DzfioEVzCzpThv15tvKzBEObDd5nI9qkBePOlU+p52qOyFE6SvRpALsRbBN6K3H3HkcLMrLv3W0tcsMYlt8bhL4W1nQh+7I6c1jlNkgk8ygIBQGWm8Sg4xZg9ZDpM3B7iB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04 2026, George Guo wrote:

> Hi,
>
> While preparing v5, I retested the LoongArch vmtest without the explicit
> `kho_scratch=16M,16M,16M` setting. That setting was masking a pre-existing
> bug in the generic percentage-based KHO scratch sizing.
>
> The percentage heuristic itself is reasonable, but the old implementation
> calculated each per-node baseline after allocating the lowmem and global
> scratch areas. Since memblock allocations are marked MEMBLOCK_RSRV_KERN,
> those scratch areas were counted as new kernel demand and scaled again.
>
> On the 1 GiB LoongArch guest, the 98.45 MiB reservation baseline and 32 MiB
> alignment made the old ordering request 224 MiB of lowmem scratch followed
> by 672 MiB for node 0. The node allocation failed and disabled KHO. I sent
> a separate generic fix here:
>
>   https://lore.kernel.org/loongarch/20260904025101.9959-1-dongtai.guo@linux.dev

Oh, cool! Nice find. I just wrote Sourabh (+Cc) an email [0] about this
too.

I think there is other wonky stuff going on with scratch sizing, like
global scratch being inflated. See my email [0] about that.

Let me go review that patch, since this seems to be causing a lot of
pain.

[0] https://lore.kernel.org/kexec/20260821105609.983622-1-sourabhjain@linux.ibm.com/T/#t

>
> With that fix, the total aligned request is 448 MiB and the LoongArch
> vmtest passes using the default percentage-based sizing. I also ran the x86
> KHO vmtest with the fix; it passes as well.
>
> Therefore, I will remove `kho_scratch=16M,16M,16M` from loongarch.conf in
> v5 so that it tests the default sizing path, matching the existing x86
> selftest behavior.
>
> Thanks,
> George

-- 
Regards,
Pratyush Yadav

