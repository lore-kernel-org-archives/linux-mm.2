Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55D3B606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 03:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=o4uqhJRx
Received: by kanga.kvack.org (Postfix)
	id 1B8846B0600; Wed, 18 Nov 2026 22:35:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16FED6B062C; Wed, 18 Nov 2026 22:35:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 058526B0661; Wed, 18 Nov 2026 22:35:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD8666B0600
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:35:33 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 13133140909
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 03:35:33 +0000 (UTC)
X-FDA: 85450453746.09.486E6A0
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf03.hostedemail.com (Postfix) with ESMTP id 23B5A20002
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 03:35:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=o4uqhJRx;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of wakel@google.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=wakel@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795059331;
	b=l/cvwiptApgzODlLtxpsWWP//Mc8ktA0W7nwy/3ksa8GLBIG3QvLT7HfIO/qq+lKT5NJjn
	3IGkuyEAyZkf0LFFlHf2BqlwOvXXfAtlDfOUzYcgJz+qjK/oR+FVg+Z9r3Uv9UUCZ5wlpu
	jIBYnS0tTb0EPvuWENpEVYvrE1yq8Cw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795059331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dTwcKDHMNVZfmdNV5lW/CAgV1zVqOVJlSSJv03x7V3c=;
	b=LWqgxS3lXq9zL2WeuRwVoGUCleHpG55yXZdxhBdAutfRtqXFE699AYarr65VX/zWvDsTXN
	h+IrfmVpFTq+M7reDhVlfmRyy8E3I40Hi9O9Hzf47S2vMkUBgr9Xdhloh/ZJq73ynkL6PC
	TWaIIumQdUCx8t9V1b2dNepxHKVlJrU=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=o4uqhJRx;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of wakel@google.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=wakel@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-8b2d14968c9so16793037b3.0
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:35:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795059330; cv=none;
        d=google.com; s=arc-20260327;
        b=jDF4ftAuLPzKm0hQnUoNXSBCtUc8aD+B65w4m39hOuGmFtwrt39pYj26KGzh9+T4WE
         B0RkrH7yW1ROT8dbO+evQMe7rm3ON2XQKtldQWUGs25ZanFxLZkLGI3BUeweUSWgyjxE
         QD5YxPHxoGesJL5w0+WWxC5k5cS5RPMXw1/Rj/IqBmQxvLVDccrzWRtecSr0L3uVwwbR
         z9jtPWbeuFjtHimbk17c0msyRXomnUAjaeN55IpFvff/1Fc+qOUnc3NmbR9avTJdAcDX
         PdWzoP01HZuDsLJ0/dg3lSROLnwLmNX0fIIA+0Fw9q9xURPKkzVshL0zU1vaEYHYIUIJ
         Sesw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:references
         :in-reply-to:dkim-signature;
        bh=dTwcKDHMNVZfmdNV5lW/CAgV1zVqOVJlSSJv03x7V3c=;
        fh=NdC6KXiRGPe7r9T+iNQ8NKsezm/krXSkSZDg82vjVlw=;
        b=g2axwgQFYDdba+0QUQyToK1i2IqggDJ+GQd1YTzsg8kMGQWEKPji2reD9Iacpp67vr
         NgMO1/RQS0pqfRMoPR7zq447KMmFcvsdZUTzIpHZ4jPhFBJp6BeyHiZ5P4X4DK4vJWph
         io9Hcbwb7Z6Is3BHdZE+VQxUJyQMaMprItXaP1d2KYEgadce+anKchmiQsHvHBpG5qns
         zby6+XHNP2QCTZO8kLaYlht7EhSIGRO1rGwoMMoS2t3/A90zXyqfYNO9iiJrwSvt4Elz
         t6Z3KSBAM/TOH+BwQFpBLrNafW2FJA7QOVXJRk+beJxWB7NT+3ALQ3Rkm7A93xJNtCUK
         SLLA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795059330; x=1795664130; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :references:in-reply-to:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dTwcKDHMNVZfmdNV5lW/CAgV1zVqOVJlSSJv03x7V3c=;
        b=o4uqhJRxAAmZ3jKjY/G2J0kDoeqXLwlypgHRisPdm9r7qgPaT6Rb95qUBMAbTP5CV/
         zyuZvV2wmz/jt0EJz4c/rn86oGMk4XPona0pbnRL856BqBdeXkzihh3St2r+cW5A6a8N
         B77LXI6JrQEeUekC2KLIrG5/nlvXgfGPcwQ4buIHomttnzuT9lvKRPYAIZiLiDkc0OSc
         3JKWQ8ZMy7nkZYBJ9rnp1wu9wtMxjzF37xmsWQi+N1Q97so4X3TmpOTDqaZo+BEuhneO
         WpE8pLp4ZINguAWZnC3OLYK7gx8DrfLnNXfgLkM/p+QhPNcpLwg1dN45hgy6DZJBNuqW
         R8vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795059330; x=1795664130;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :references:in-reply-to:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=dTwcKDHMNVZfmdNV5lW/CAgV1zVqOVJlSSJv03x7V3c=;
        b=MIMIOLUrCnWjqCaNd8BD/RXD9sl47YMYACA4ijLfc31Pieh+IaCedBZNC/vF2tYuAM
         L4co5qprgBY1AoxickJ1CCrqUWk3wnQGfi9vte/Af9oBqK/oH4+87mhrr4YxZA1f+Q32
         Gs9NHdm/8vER9+/SCMOHtsO9kxTZrJl0K42ut31wxpoVqjh3ZprafkxGq4qp7hvvvpjT
         CIvTK4Zv1B+o1Tus2ndkQu0hI+JcN0f01h02ih02OVdPzgG3BGBX6Fu0viHKRGs9dKF2
         eya41ZiNSnGkC23HY7ZAVmUA5ToBY3YVxshr2VKuksk330tRZEj8CXj0gf3+SLC9CjH6
         rXUA==
X-Forwarded-Encrypted: i=1; AL+hErHAD3siIveMEQRuxuL3MM8mcNMVqeA3TN9oEl2H7xm6pkJYJX4Y/Eyy1KaawSqMYu5eeUlDoaVTkA==@kvack.org
X-Gm-Message-State: APuU4Z8doNyoSxxy8Y2yEnURh8YLBOGrVv9OhPXltEyEJqssmJtXytGI
	TMSiy4bPPKtJfYzcbChTYjbD6kvjX4nyRLFiTZohKqM6Lb4oHiskP7qjkSQfzz926eteVFlH6lE
	ECVYfxHPKxgaiXjJQR0za0LLI8Iz9hxTaTZatCE5/
X-Gm-Gg: AZFdTZcy+bUlZhpyuzVsb3uGNRSU9LO8npK3be5cFLUcU3ZfaioA/5YOzfzr18SJK61
	/frvodG1XYrTHsDeW5MiZa2Dlp2o13GDixdM84KYc11zdLtP5TpOVHuxOjp9/FwLjB9TGSKSalM
	q0WrXn3bA/UPROq3SL1/8dgcvydHn+hd4OBIuDMOSNoegjmwyv/wX/1BBJgK8b1uvWBxI9Ny39a
	nTBeRAOTIjnQ1vgJQXb9nKC+HzHyj+aKNi0GvzTa9dLPgEYhE+zU8nqNKJbwwfgXgJMdaR58pTr
	Mm6LYRtYOk5lcebbXBqo2ntlpqN4iLGREB5cyW3Ah1eXt8sy7rUH0bn5TNnK8AGmx5Pcxy1533p
	hMeb1d2a9JPoLbxweu68KAPraZ9MPw96LrJAVDzj2jJvOeB+hmF0gvg0OuJGIKyKic2+yUT/VkI
	vdoOMhinZ7ed4VEN1+ZXdyOvSQJagGBjL9vVlKB3ekeS2pFknLihIYj/uxrMwzle4ccJGd
X-Received: by 2002:a05:690c:b85:b0:8b4:d554:3267 with SMTP id
 00721157ae682-8b4fea7b90emr18155827b3.0.1795059329731; Wed, 18 Nov 2026
 19:35:29 -0800 (PST)
Received: from 913411032810 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 18 Nov 2026 19:35:27 -0800
In-Reply-To: <20261105030843.3319056-1-wakel@google.com>
References: <20261105030843.3319056-1-wakel@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
From: Wake Liu <wakel@google.com>
Date: Wed, 18 Nov 2026 19:35:27 -0800
X-Gm-Features: Aa3M54rGVyaPN88KSs8RaBBU3XJWLg8t07Bk5yW9RZ-7pR4m_ECj9go4X8bhqeU
Message-ID: <CAOcRiAF6kacjWRdUq=rETV3bO30yk272_PZV7sQn=t31_4ww9g@mail.gmail.com>
Subject: Re: [PATCH] selftests/memfd: Rename local union semun to avoid bionic clash
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>, 
	Shuah Khan <skhan@linuxfoundation.org>
Cc: Aristeu Rozanski <aris@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Carlos Llamas <cmllamas@google.com>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 1b7fm91k3tux1o3c5yya6ysbto431n4p
X-Rspam-User:
X-Rspamd-Queue-Id: 23B5A20002
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795059331-518400
X-HE-Meta: U2FsdGVkX1+6BO4iAo1dZKXhiTKoeZb7cxZFOslOG2aJsAOhnYFwxJ0ZPQCA4JLTI4P9h5JD6dyHUFwPx5fu9gu4GjRJf5cTrR1aNMmbvmGIzNxRNVwV1bFwb9pIEeUipMksN6IVjMU2txQIbv24xI40SsUgslcLgm2GtpJ5Tokvxg5xsbWpucTde6D4POC85uSlL3jcus/YzrQkJODht5u141nlYnDcO7i7/+nMo6ikejCgp5W6IdIcmgz2DI4y+VqIsXlB1Xvkxog/FyE0EyIt+5SpwKZLhedjWdSHHVlSxHkKiDrL/+lt7IGtNBoX2KwoGJQaF3LWb0eo3QK6MEyCgmez/2T3OD5hLz2liY/N5paeUgS4NVal1zihTjcBiLcbffoCiBk9QMh1A5cHRcwC7aw80iltWJPXWbFpZmGUDd31nSEjbxX8ZkjxCLJOATBcWbwJX0BTEdbZMVpBAYoXEHihJGV9mlZmnU9TaGIe11iMAhh/AX3Gy3TRTLlGkHjF8+eUHjYN5VIAdKNGdjIyryr+f6gX2yYqOERmOwGaUxRS2GDyLWjxOof7pzC5A16YAR5hYaccqwhUtc7i+ac71nLX/uQH5Qy3fL8FfRv3mvVshej2L569gLkeBM9VVh6rNPNiBo1u7NQDg/PrBqYlzI/4upKm/Ca6+e0xfnwEGkYryVeBzQCgpiCi9mxWMvG/auhHNmUjtlEFgOaQUjSgpcX7OATmYudQpiRWz0KwfURmi7cEEwbXqBhDBkHd2DfV9zyBwO757sjgfwQfNJZPr1614imHpSEsv6r3A2v3VWENBbpm0UGVJjbkHc7lQMLqU4nSbvuBlGaQc65h2cEzTStqlVz4i9x8QmLHH+nK8Ykz+olIaeCdF2wOy0++WCVJj9YVp016g6EnRSBLIA/8DfVgaA+C1EzPNklkt90CZ9PKBHBTkx0Sax3IQ0eeYK/moWDvADVaOnbtg/w
 gjEWtFkJ
 /T+rcPiZGCHacc+h639/Jar5ZIAysv6v9z0f7OrFmgtD+fBBU1LikhK9Ws/J6l3XPoSN7IWo5SOOjbYQDLq0dnvMRNRSdqp+g5/aoX0Xgq5VNTWeuf3YR6QjkJ7fLs2IblgBsVSr2l/cMbLy78cT7fEPXDoGZ9Aetw69mPP1QDAYjtER1Kgoc2qxvkq4X3DR+XEcB5DX7qLTnPHprQCtsnfl2WyhyZ5EhWKrLWqUiaY8BTttUO/fW9D7Bo1hGomHd5w6JNVgSlhlipoZH8p1Fy1dzHHgQEgyMmkvache4ls7fOYl3PmQMOb9hWy+0qbSKICxh5xFqHp46CiDF/EQBtEy65+jgKyJ6F97JKEGzYtsG3hE6TKJjl+Mxe/+l8fzxcqfIkeaLW0Kncq0WECYGMgRlRB6GmgZgd55TO+b40fxIvg74W5wdN/aUaOe0BvhW9OGvXOeP0KvpuYrggG0MArsCpPkNqq9vNZIHkX8kpSpY7h5y/r/qxjJk2gK0Dxcv29dvSq/PDooKnC73Yx5G92aC7dJneL7ZE9+tux4KkB/Zfv7jljSzodGVhgAvAW3VOcxeHoXSjZPwrR7frHfzsQnjWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Andrew, Shuah,

Gentle ping on this build fix for memfd_test against bionic:
https://lore.kernel.org/all/20261105030843.3319056-1-wakel@google.com/

Since b24335521de9 went through the mm tree, Andrew, would you mind
picking this up, or should it go via Shuah's kselftest tree?

Thanks,
Wake

