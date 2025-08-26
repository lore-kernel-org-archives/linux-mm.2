Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12CA1CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 04:59:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32E498E009C; Tue, 26 Aug 2025 00:59:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DE638E0090; Tue, 26 Aug 2025 00:59:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CD548E009C; Tue, 26 Aug 2025 00:59:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 075A88E0090
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 00:59:28 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 779FA140604
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 04:59:27 +0000 (UTC)
X-FDA: 83817705174.04.25360D6
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0669B40009
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 04:59:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of gongruiqi1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=gongruiqi1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756184365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HzNX3NeEzB8V23zaQ9TmqXXvMWOXvUwomNCGLR8uscM=;
	b=vgSQtWxg5RGFBy/4tmCB74PND6/INU1aTS7bYD8skHmN/itN3SCcDLJnJZ+sJ9WyTtGydA
	BaNU5ne7D4miZZhedJPXpq/8sm35a9wSuN5cUHrXtcryLo6me1qnj5LUzNsWsQFww5bACs
	OKGihzKwmvaMFxXw+d6SCbujaIPwug0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of gongruiqi1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=gongruiqi1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756184365; a=rsa-sha256;
	cv=none;
	b=meAD9ftHrKN2oW/dHgLBDTwL7iSKqYnoaaiRA3k9TIeTUJgzPEylBmx68lId1CSft1L2wc
	UWfr32yzeWx1bq1L3SfTCDGFjp9Njg6ks+a+E7bpEpTxa432kgicyNx2x2joiDaCV9aU/j
	HksxtJ75oVJk7jR0CF9fr/0OfghAxPw=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c9wMs74THz13NLV;
	Tue, 26 Aug 2025 12:55:37 +0800 (CST)
Received: from kwepemk100018.china.huawei.com (unknown [7.202.194.66])
	by mail.maildlp.com (Postfix) with ESMTPS id B38881402CF;
	Tue, 26 Aug 2025 12:59:18 +0800 (CST)
Received: from [10.67.110.48] (10.67.110.48) by kwepemk100018.china.huawei.com
 (7.202.194.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 26 Aug
 2025 12:59:17 +0800
Message-ID: <97dca868-dc8a-422a-aa47-ce2bb739e640@huawei.com>
Date: Tue, 26 Aug 2025 12:59:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] slab: support for compiler-assisted type-based slab
 cache partitioning
To: Marco Elver <elver@google.com>
CC: <linux-kernel@vger.kernel.org>, <kasan-dev@googlegroups.com>, "Gustavo A.
 R. Silva" <gustavoars@kernel.org>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Alexander Potapenko <glider@google.com>, Andrew
 Morton <akpm@linux-foundation.org>, Andrey Konovalov <andreyknvl@gmail.com>,
	David Hildenbrand <david@redhat.com>, David Rientjes <rientjes@google.com>,
	Dmitry Vyukov <dvyukov@google.com>, Florent Revest <revest@google.com>, Harry
 Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>, Kees Cook
	<kees@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Matteo Rizzo
	<matteorizzo@google.com>, Michal Hocko <mhocko@suse.com>, Mike Rapoport
	<rppt@kernel.org>, Nathan Chancellor <nathan@kernel.org>, Roman Gushchin
	<roman.gushchin@linux.dev>, Suren Baghdasaryan <surenb@google.com>, Vlastimil
 Babka <vbabka@suse.cz>, <linux-hardening@vger.kernel.org>,
	<linux-mm@kvack.org>
References: <20250825154505.1558444-1-elver@google.com>
Content-Language: en-US
From: GONG Ruiqi <gongruiqi1@huawei.com>
In-Reply-To: <20250825154505.1558444-1-elver@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.48]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemk100018.china.huawei.com (7.202.194.66)
X-Stat-Signature: c31nkhhwwqdbg6zf8awrt3h6nsxkcuhx
X-Rspam-User: 
X-Rspamd-Queue-Id: 0669B40009
X-Rspamd-Server: rspam05
X-HE-Tag: 1756184364-382326
X-HE-Meta: U2FsdGVkX1981FqZeIa10s32wrF2/XOrkT7h1mlk/TGeXgI7EmzsD73BdUoM6SxY545dFJ7Vw31dE4qzzAHAUqCz7XrKRAaAFJTnE6dLyThCmU/iP/pFgmFXwJWhfGeT04o/jW8YiyteVnDhFScIeB+ceM5GuE3WAZXLY3+VOcIOYPD+cbgK7C8FeCSk/6/MG93WsQak25HEQP5P6E+MwpKlCIuUrYNhCWUJsF81/jSNncS1imNTBJdXLvVonr96Rao6CAH+9HPyuDzCAqOUxxScDhhggGJ2VzaVn4XLCpgQcZjdbJGpcnZG+/WrZngL0Tp/uhAVIoICyxD9/Xtjx7BFuAND7/N1/Jd/YqPu+Ji4OrzMdvkhluPGgu30Z2r22UKnUz4iurTNdGw8ZNIMmw++FeO4o5rGS5JaDSDELyGnGb3EooPbdviE71EIbVq4FV30FewGafoI4+0qTE3idMoSTnIyzSkt8UYm3HRe8tF/0LjwDfnd6yNxnJFCDuLsLK9YkHiGyCgimrpCNWUJWCSL4QgvVdha2/TbzhC36IcXa3bbd/SkwL9ugOTdl4lEn1BJm2fA3Affwmlk4WTTMIGyHxVYU21vh2hDU4Wpcdf94ZY/BLS9gdRMtlaWu96d+15YtBLQrV+enazfwcD7DmChbvaZee+gvahjiNla7V5ZM+KwMsGgUHPTjYI6/IBTWy5+btfZ+2lnJI+2ZJZHJPyq0ya1a3kpnbQsZocvj+yUABP9yEQpsZvOVtqRVRK6Xm8KNYPVKi/xt+rEwIbiVYjlZ8/6mEFHGHiOJXytwmkWuL74EEumJ3RUVGdNYTenuDWvQ6SXMjN/JnpRpWnUrxYTi8qi1c8/81ByvTr2Oxjbhw+229nS47KUS3MAV6uE6RumdvmMEmq0oiWfYadCFANa8FdMz1zzXiFROBahwZsO0GRaL4j13wwrgxR38FYkMwBncOIrJhtLaGG1poh
 v+ZoH4e9
 MDi4DkASsPwOC/KfSj7mqqmetWu/1oUc+rPJxOzEhVaDvduU+eWpzeBmCBOqx6DhnaCV5KY6LBMbbD/DcmAeUUlK1acWKy4/bh2yW3+8toUlQEXCrN4r2ERCHS/SrKyagoY1NLuHFdiz0jMo67igOKPrt6LG/purT4bs6CTTzc5n0+uxgWVGKJv8ujrpK3VvoiYrubkBsAxvba/4UMo2cTP8yVEZ3uSHeUydP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/25/2025 11:44 PM, Marco Elver wrote:
> ...
> 
> Introduce a new mode, TYPED_KMALLOC_CACHES, which leverages Clang's
> "allocation tokens" via __builtin_alloc_token_infer [1].
> 
> This mechanism allows the compiler to pass a token ID derived from the
> allocation's type to the allocator. The compiler performs best-effort
> type inference, and recognizes idioms such as kmalloc(sizeof(T), ...).
> Unlike RANDOM_KMALLOC_CACHES, this mode deterministically assigns a slab
> cache to an allocation of type T, regardless of allocation site.
> 
> Clang's default token ID calculation is described as [1]:
> 
>    TypeHashPointerSplit: This mode assigns a token ID based on the hash
>    of the allocated type's name, where the top half ID-space is reserved
>    for types that contain pointers and the bottom half for types that do
>    not contain pointers.
> 

Is a type's token id always the same across different builds? Or somehow
predictable? If so, the attacker could probably find out all types that
end up with the same id, and use some of them to exploit the buggy one.

-Ruiqi

