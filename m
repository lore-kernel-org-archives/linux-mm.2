Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85EA6C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 18:39:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02F406B00A2; Tue,  5 Aug 2025 14:39:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F21CF6B00B7; Tue,  5 Aug 2025 14:39:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE99A6B00B9; Tue,  5 Aug 2025 14:39:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CDDE36B00A2
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:39:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8F62FB7014
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 18:39:39 +0000 (UTC)
X-FDA: 83743567278.20.7F1FE0F
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf10.hostedemail.com (Postfix) with ESMTP id A2C33C000D
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 18:39:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1QrFY5em;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of jannh@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754419177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8xUxg+pq2PUvE8Vk3KBIOKz0oljMTyiqWMDUeHpQ214=;
	b=ceJMsmVYUX+5VuGCCly83Kbr1Zl4rXSPf23fTMlqmzExI+7sSMM5jh7Gy6obtWeoeg2TQX
	305kpxrsWU7Mh6mEO0+gfvpGFLp15EiLd1jOhhYR1MnplZWnySDKXPRZwAGNn1lqIwonMw
	U4sqhprxldGavBFa/02rlJOR9k7T0HY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754419177; a=rsa-sha256;
	cv=none;
	b=aJKbEIH4vAvqwYB5kwXPh64Iip2QBpwp/vtUYa59OTOVAXtz+NFfKdPdlmaY6X9mLgh/Uy
	Hf77z/NhlN1Ox2oQSZZrcnx3u7cs2+WGRqJ/cQQ5/Ij1SCtwFpSyt8Za4QzhaUVywaNT3i
	4MIs411ONHSn0c4VW+ii4g6JOze2ZE0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1QrFY5em;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of jannh@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=jannh@google.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5f438523d6fso2177a12.1
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 11:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754419176; x=1755023976; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8xUxg+pq2PUvE8Vk3KBIOKz0oljMTyiqWMDUeHpQ214=;
        b=1QrFY5emdsvrJWSCRHLpoI7jgKiXHyJKE19qpIf/9eNSuH4sT4H5GcNtLRaTPOEkqW
         Il4P7N/q18StOJ4DGIDs8ZCcWNjIAwMkhkTkbb70LE6+ZhqfL5mlC+c0XyU5cyB+mwPW
         8PQvwZtHjcD7/389M7pOLziCCEpzT9jq2e9jJf0XBuWC9apxtHQ6WruHv4s4Bt2fHIFJ
         4ctyiiRTIQWlN2BA0nw8pkG7WaJWWJr47UbEucM3B9o63AZyZC9aeCpXYfAemNLf4k/g
         KUPeRw86ossDAo/g84N50K5RvzOZDTtQgZBsTHlMY9c5eEKJ465FLqbhTubEvz8/aFeI
         JQ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754419176; x=1755023976;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8xUxg+pq2PUvE8Vk3KBIOKz0oljMTyiqWMDUeHpQ214=;
        b=YvJ9RfF4xsPYAdo43uT8VXfg9GRNCLmapx9E9JwBFHX4nDLD13wcou80wypKBLhizc
         5WeTOXz9+YHa0UNbo28uCeknwQi8jfbSq3Pyi4W1gU/aTik2VY53DgWJoYWaX6xCKJFX
         Hqq5TcYizrxNNyXruxXkh5Ul1WHyyqTr/mWYM2sCsFV8gFhHAC5YRKEzAHtwXE+BbYoE
         /UYbAm52DNw+x2bcA9RF9G1AJzv6Ict4ISeU0asxSb6NBCskl9hZen0chXW4Q6Eh4Uqg
         zLlX5QFFiiw53phX2EXbBCUHpH5OVF5b172SwgUIPLiS/fpy89sqVIqzs+b9BNheoLib
         vnrg==
X-Forwarded-Encrypted: i=1; AJvYcCUYRcyD1XOKDLTBa9BB9meY2SUfKfB+fm0bVvlWnLvy6Bt+qOiV5pobyqyvuds4j0KZQYQTsTRLoA==@kvack.org
X-Gm-Message-State: AOJu0Yw/S31ze/HzHMWXnIvjqbb3fAigsCC+mxOW3f1BBFUP2lD5qbie
	g4VRmRnEJf2pwuO0/+tw1BwLjgGplJyrC6olzGkk1orfOCGn4dYYe048RSqVw7kUKqmhO7LNnU2
	7ypEjqZS1g9e7jDIjIiBpakKti0AP+APnIhrK52sQ
X-Gm-Gg: ASbGncsbQMZRTenxOHG13dz2bk038aNsmr5ca1lBbSErk5Own8pGkYPfxEe9ttsz0Uv
	FUujDpTghYLcDGLqLybLykZMiD86ExESpgltJ/+6NiJkQm4ZSqZ107yQk3cNja8ysM81yUvbsrP
	T/UvUcO/15w7z/suVkNWYWy6tuo5kPq+6et3j3OCJds918VwEdXJzhIsjD5bVpU7sk+Zy0G/tOM
	SV0O4OmiypZW1MRPMv0XJs2C1hjLz6VYM6dI9DpgGpXzw==
X-Google-Smtp-Source: AGHT+IFy4uCtvmoKREB9xPubyGfQITaTP/Y3zHYx2x5Mjq6NIu7iwEqR3CIj5VJ9+pdXbxXR/6XQYM75C8EoDMNJUO4=
X-Received: by 2002:a05:6402:c02:b0:615:60d2:c013 with SMTP id
 4fb4d7f45d1cf-61795f56174mr2645a12.3.1754419175703; Tue, 05 Aug 2025 11:39:35
 -0700 (PDT)
MIME-Version: 1.0
References: <20250805175140.241656-1-ziy@nvidia.com>
In-Reply-To: <20250805175140.241656-1-ziy@nvidia.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 5 Aug 2025 20:38:59 +0200
X-Gm-Features: Ac12FXyOYi_qLL7ZLj8tprF4j2V_jxE8BegFfXRvFrXyIiZBLUKoXwoL4IXp0EA
Message-ID: <CAG48ez1wKqyCKZX7J2eJekTuzRshVE2btPEWQEm2hW9Ri46Uuw@mail.gmail.com>
Subject: Re: [PATCH] selftests/mm: fix FORCE_READ to read input value correctly.
To: Zi Yan <ziy@nvidia.com>
Cc: wang lian <lianux.mm@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, David Hildenbrand <david@redhat.com>, 
	Wei Yang <richard.weiyang@gmail.com>, Christian Brauner <brauner@kernel.org>, 
	Kairui Song <ryncsn@gmail.com>, Liam Howlett <liam.howlett@oracle.com>, 
	Mark Brown <broonie@kernel.org>, SeongJae Park <sj@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A2C33C000D
X-Stat-Signature: epmwfycjzhxoutsw6db3n1wqb5d7x4jp
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754419177-839767
X-HE-Meta: U2FsdGVkX1+FdDRFawTUD+jBpSxLQq9yG41hXdBwBUQz4JZFgOLzfDNVTCz9deAznxUHdDequ9E0YZeXutxUfZh0xnZJtPVBeGFUV0zxQ/Mn+kHn3dx5vN6d/AKEN7h/AhiYBhuXJhLeZd05AZ+8GE84cnWDJ1Jy5wLIwbWRmO9k07v1BhD6wLyciuYi12UvVucW5oMq4Y2o1CDvrfozAENIzpFSJ01tbqPYqhd1l5Fuokh6jJcahZB51yYCZ3VRSHn0nk7/dezG1lNRz6yvtwkIeY8pjKDEUcOG4ZIMC4v6oyuaojNOdHP/G8GGs4QB19DKwSlJ1z2f4WgU80HAx2zxAUzrZhpMVdYjqT5IYbVPEBG8oZsQBzuU+5IFIneHoMk3YaAFgkDpg8CwjPkcWKoSUuX++CCO6Uw7j0e2gxnKTGlalqpPhv73dE2HiG70TrY8aKYuqNC+57fOxLZKAtAYQw5V9DA9T+V0aq+DZHzKXcRGTMSIoqxvBNk5fFJnxbWWIuC6LL504LIRrhLj36Mc53wcCZZ0whgGy7h/qPkFdT11E0fUr754FkTkJkfAqtDBLAeT8gIdz6IWlYtU7wGOX5cOLUTjoEPBeguK4bygB4zodE0FYuR23ne3R/7UUZaqV4r4C81/T91wwJNlYq7YYLjlpS+Iuub6s9iYaN/DfCcWHsPdhK1gysgQFUHTt0loNSEeWJFJ2ilb60MHey9b904ZTS70zsABDEa2GEADGA2U1cRHJYoBt0GZsZKrBg+JT8JuQ5BXQEU79u7c8sMwZQoCerQAJ24QmcMg4nGtp9F6sY4ewA3Qw5506r1tNvKq+5TjYBVvnF139W/FSPXacDEytMLNo6b8O2XmB1q+jyBVDHraS4TfuhHXB0c/QuHJ525KQFmHThm53aCiWejn1vaTN2zxzWJPr+8ScNavEHRYydtbbfiFjAc00zrz1CF/iui+kBW/RnjR6sP
 7CvTWnpz
 PLO2Pciu/7x8g/oSlVEkKfjtJ4KpBa3iG3VSzCW5gP51cSfPgDOL8y0PF5fBdUH6fQ/JOhZkMg57ziLu8XG63Al1dEI4qzMMI2+F5X2ImOJ24C6/bg3w7ExPtDKSdZtnHlMtxbwSKjXosoNCZSYV+cvZ9FNfcre3EvT9MFVJBvUQiD9WO7RALaFvEmnqNDGtz4EJwcR+h/JHU1Kz0IAvRfCGJHebPz2w8Kgj6Vzj6aOpCqQYD/k6jATk71DqqYvOpnZL7196SZbgvUoZxJvL/+Ks2mFXIx3RMRP6FQMzQTD7TpvI/40mIP0Xd9I86NMZ2qCQOIk2Lp5GnaIDImPzXOJf+aQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 5, 2025 at 7:51=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
> FORCE_READ() converts input value x to its pointer type then reads from
> address x. This is wrong. If x is a non-pointer, it would be caught it
> easily. But all FORCE_READ() callers are trying to read from a pointer an=
d
> FORCE_READ() basically reads a pointer to a pointer instead of the origin=
al
> typed pointer. Almost no access violation was found, except the one from
> split_huge_page_test.
[...]
> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftes=
ts/mm/vm_util.h
> index c20298ae98ea..b55d1809debc 100644
> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -23,7 +23,7 @@
>   * anything with it in order to trigger a read page fault. We therefore =
must use
>   * volatile to stop the compiler from optimising this away.
>   */
> -#define FORCE_READ(x) (*(volatile typeof(x) *)x)
> +#define FORCE_READ(x) (*(const volatile typeof(x) *)&(x))

So is the problem with the old code basically that it should have been
something like

#define FORCE_READ(x) (*(volatile typeof(*(x)) *)(x))

to actually cast the normal pointer to a volatile pointer?

