Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD976C9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 07:28:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 915476B0088; Mon, 28 Sep 2026 03:28:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89F0D6B008A; Mon, 28 Sep 2026 03:28:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 765F26B008C; Mon, 28 Sep 2026 03:28:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4A6366B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 03:28:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C5DC8A010A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:28:24 +0000 (UTC)
X-FDA: 85262342928.17.DEECC7F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0BF9440007
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:28:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dkt6xH2J;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790580503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+LksHqZozTtq7yO6KkjuEVP0ofhwJNDCQXPtObKD/1k=;
	b=t1m+7lBkKfkumQz9FEWyQEUtNBH56lqSgOfNRol9EAITVeRHsHkSL370OV+5esFuPvsvDC
	Dq5UMiGbTsqkhM0WQZARYqg8GJ8hK4j7biJECYqF0tcHSUCMT98o1sh6J4zmM+/EFLk8zS
	vpV74BMlknryVIehI69ZFC3zGP1sugk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dkt6xH2J;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790580503;
	b=B9J5BhM0sjkEwLUi2SU3GPq8nAx13uTq+D4OJEi5dNwoulF0WGKRO3jl7wMEsL9ugfsI+F
	lSWk6vdQKmVl+CL+9jxeQrnEVMd5OMqFLyzhVGht03ou2Fag3B9NwyNa4PsoGyDr2lv3Fj
	7+HXIyVwyKIj8sBNtzvzGAmm5Qovq6I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C8A79601FF;
	Mon, 28 Sep 2026 07:28:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF2B1F000FF;
	Mon, 28 Sep 2026 07:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790580501;
	bh=+LksHqZozTtq7yO6KkjuEVP0ofhwJNDCQXPtObKD/1k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Dkt6xH2JXFEogH+25ymBukI9dCfxA3hNo12nOX8K2n5a6a4QY62Q+ke8no/A5HEVB
	 qZ/L/nhs6YtNxqoHfgLG/Sf2dgwVZrYX0LSF4B9KXmr+XJcClAUwyIu5ELJKVvR+s8
	 n/2gaj3xYxQWF8eiji3ZzJMe9XyxijisYWdV6bSTlX7mWI7PrQOY+SkCFPa3Ya5Xhl
	 Cp9NLzhGBwux1m6QmGi1Wd1JYxXgtzvHpZnD4pjRp59Mo9zpbYS6NBLwVZLIyEl71R
	 fp/89MDqsFlPFFStUrxWH+ltvJYMqlt9WzAZ4YlEs5MMHdOMEHPBy24QJ6zAyFygMI
	 PGgXai9Hc1Zxw==
Message-ID: <655c509e-318f-48bc-8183-2b1274dd05ac@kernel.org>
Date: Mon, 28 Sep 2026 09:28:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/13] mm/sparse: remove SECTION_MARKED_PRESENT
To: David Carlier <devnexen@gmail.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, baoquan.he@linux.dev,
 brendan.jackman@linux.dev, dakr@kernel.org, driver-core@lists.linux.dev,
 gregkh@linuxfoundation.org, hannes@cmpxchg.org, jan.kiszka@siemens.com,
 kasong@tencent.com, kbingham@kernel.org, liam@infradead.org,
 linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 mhocko@suse.com, osalvador@suse.de, qi.zheng@linux.dev, rafael@kernel.org,
 rppt@kernel.org, shakeel.butt@linux.dev, surenb@google.com,
 vbabka@kernel.org, weixugc@google.com, yuanchu@google.com, ziy@nvidia.com,
 devel@lists.crash-utility.osci.io
References: <20260921-b4-sparsemem_cleanups-v2-10-54d81d65e125@kernel.org>
 <20260927192013.144672-1-devnexen@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260927192013.144672-1-devnexen@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0BF9440007
X-Stat-Signature: f9yefhk76j4pxbz7f6ci8cgr3rcz1i39
X-Rspam-User: 
X-HE-Tag: 1790580502-824043
X-HE-Meta: U2FsdGVkX1+EcmrR83d1BIZ6UYXtNyE1fMxd7qYeWk5m5Chme0Yp4w99JUsfkqHvA8/oPwggMzQtxtPq7c0RBSODo0zBq/8dVW6aC8zLaZeIsDX6HVkLYSyAwiiZl37rrawQry8SiwR5NXMKVvmU0749E9E6Mui8TXune7/+yLyBnWFkcCklIK8aWBzC/IylmKvK3tvpjKmZDpYR9pkWdqFp6CGB4aFv/sIeYcKnXepHAVUs6GnBukJlXa0PJlm4Y6QGFe8ove60ZRMI0sG/Tb738JNE8He+CBHikUf9oNRsvLCQcQKKFHMmwZ7iaGw6V28Zgz2dCFzz2EutrPw7nrvuCPP8QO14alhvQpbUKhWeim8Zas0BnfhNaL7v+lSmlQtuu1UEWJTVpyKfV1rrVR6QAGhIb9g0P7b2QoAxL5qGomOhjTvKrVE+3yhjfD7Q3ngXZjb1Qs2mo53ho6EoYrIosVOkaumzFMzB6wObvV/L99+FaxvvWc/OlR1p6VmSEqM8MocTBIHH6F3PpKQm0wEJni1HXDj0B6Nh40jGu2SsPy7dBgtD51tGnfUpViKFetVv43nUz9inRfFFif0r4RVbRe66yaZZqdtPCb7f39Y7ezguBEy0pns1WgRfLvm4AQS6wK9Jn+g/vDsE9JKUrjssnav7b1XJZz8fLscssGZIld0KsWRuXy1TdoAKeX7CJYrRyE35v1idG1NJ9FEO6kxaPyMK/SeE9rHcCT+5N+hlX/E5pePOPwbWyjpAIet2brIF7CGha4NPLSd1P+TLl2a1tgb+7I1tLxl+FvKjJ9RCXPFWSQbdVmKNg5PRtmInx2ZUv2Sx1PtB83JYlsfRqeS/VyRvxESS4AJJgveZ/5XM+I2fIigqIkjgG2xz6pHbiRIw1dXWkx4FNW48Sx1e8bPz+r7KJoZcUUGUVW42ygJri/xo2POwEKqwwcpwZwpEjvVOmy1foi2B7I88xQX
 MXWvgNA7
 sF8hZM8oGRHgV0hdhoi8CxubDjpaVLdaUf7ycQO5UPzy4S/Bar6v6vzfFHVltfeiTOm7Mt8o5pEU6mg7m8t/4KhpTzmif2ArTInfajIPl8hEnL4+CPuUh0BZcsHN6s52gxsX1xqN/XfamuoE3rVTlDeZ/0ZJ1mbDoYj8GZMl14LhrcqbhyehCAczP2P6jv1hbvhZzmuAGQ0rfa8JqwBI027R2RubrwrKVKcCzE8bveAYJnveNGE7juBQGZ7P4MV2UWTYOKYLSBQsYU5TPFJeFEAp8By/jyAqwgLm/Al/kEgzSq7vLTJjfAhfWkF7CMpy2IY+hTyW8yLIrixY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/27/26 21:20, David Carlier wrote:
> On Mon, Sep 21, 2026 at 09:59:02PM +0200, David Hildenbrand (Arm) wrote:
>>  enum {
>> -	SECTION_MARKED_PRESENT_BIT,
>>  	SECTION_HAS_MEM_MAP_BIT,
>>  	SECTION_IS_ONLINE_BIT,
>>  	SECTION_IS_EARLY_BIT,
> 
> Hi David,

Hi!

> 
> It seems dropping SECTION_MARKED_PRESENT_BIT shifts the other section flags down
> one bit. crash hardcodes SECTION_HAS_MEM_MAP as (1UL << 1) in
> pfn_to_map(), so it now tests SECTION_IS_ONLINE: offline and
> ZONE_DEVICE sections no longer resolve to a struct page. makedumpfile
> only checks bit 0 and is fine.

Thanks. To be expected when relying on kernel internals.

Which makes me wonder why makedumpfile
(https://github.com/makedumpfile/makedumpfile) not require any such information.

> 
> Keep bit 0 reserved, or export the bits via vmcoreinfo?
We could export it, or crash can simply detect the change based on the kernel
version. I remember the latter was done in makedumpfile in the past (although we
export it).

I can send a separate patch to export it.

-- 
Cheers,

David

