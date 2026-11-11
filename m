Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF9F8606A32E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Q92bO8G/
Received: by kanga.kvack.org (Postfix)
	id 1BED96B05BD; Wed, 11 Nov 2026 06:32:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1967A6B05BE; Wed, 11 Nov 2026 06:32:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ACB66B05BF; Wed, 11 Nov 2026 06:32:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E40BE6B05BD
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:32:05 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7044D1C31C2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:32:05 +0000 (UTC)
X-FDA: 85422624210.23.36E0EA0
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf31.hostedemail.com (Postfix) with ESMTP id 86BF820006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:32:03 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="Q92bO8G/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794396723;
	b=w4uJZOy92yE64LgiaFyWegjW6AQq8n503rUVbGyWhgtQtYvfE+wpXACH/CF6yphQtkKUAX
	nVb2fcrHCzmzYL6p7Y24cmJzNd/78aWBU7sPdd2TTO9Qkk5eWXM/vcyF9qJ+pNVLDe3LdT
	R05fMSQrngLyFb9tepIsVwMd+DV8FM8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794396723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VpkJYJaK67uI9nRJI+Hn9ZolwDO1Hn47PzK+oblw1iw=;
	b=Yf5k1Nb04mg7wCJ9uVWfjjLBE/hVxDpc0aSplBzOX5Wt2wRy/yqlgQsD3zP76OqpRmaVow
	mzCJtVzDFlwjB3Aq+frr1WtaatU6NtWEXKsQjMSeJnqcb4qFZ9D9QEKBqzX5OfP9HXgy/f
	56gVV+CgQgRPazEmpHvtGr1uNP6gSxo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="Q92bO8G/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-36d1b3b9974so45980eec.2
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:32:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794396722; x=1795001522; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=VpkJYJaK67uI9nRJI+Hn9ZolwDO1Hn47PzK+oblw1iw=;
        b=Q92bO8G/ilQRhwHm58mWpVQJsEYwCCQapmr9bA92DnX77XsarMxW9Ow75aO59lM1yk
         7o2v+5csR2rjA0mJf5DN+g3bYCnBntSt5aam5YkPRBewyEsuak65j5LtMWjeU97lUJgm
         Ub8cyJwb2VHKvKPH4Eo2zzWYYI/I6ZUG3hNMnIBLBqYRZBEdjS3BWrJ1dJynXKQQc9uz
         P7AnzLgB4wA2ka1EPXg6o5EO2cYxsxAj+g3r0ZIySGP3kQedyNqu0x/I4kBC/yyG5R8O
         kdsRBHmKqLpwj3hYC9W9a3xMtIGKoIEo9DpxWL74uIl3R36ETwrFJ40GHuUsW6WUO31l
         aMXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794396722; x=1795001522;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VpkJYJaK67uI9nRJI+Hn9ZolwDO1Hn47PzK+oblw1iw=;
        b=v0bytXkFdLVTsO9SUIAnGmEhxP1oLER+qnhooItvCtGoWlpk4vAt0Da5Nag4IUkDx/
         j2UXSXwBNo0BP267rkbf9Ot64lDcvZXk/okhN9MmJYDx8A29ln7tc8crUZhFqlgUJsWa
         m3w022eunq5luLU4zegx9Qv97FqUPD35UMULmZz5TbGHiYwxee7A6rnnPqYJksGO6b3c
         h8vVBsIqDwX4ShztM3jtz1JvA/uyiY6U3EdKLmat7xN0kAqgN/pzLwJ3mrLZ3SrSIPvf
         Nrv/8y5ZUB9HcrcKbsjLHHxWiUYKGpsLWVl5kbzBo/zWRvQWKd3zlnZqADRZNbSalMdX
         0aSQ==
X-Forwarded-Encrypted: i=1; AL+hErHUO+G+PY799C5PYgKp8bMIWWHnyoAU4WNlD/8li848xlY8zVImJynvrf2/xycdlnepp8fAKdLEfw==@kvack.org
X-Gm-Message-State: APuU4Z9AXaGiQ92OVyDrzaWmkD3jrCxjg7l579MZSRI99cLR5FWN81Nj
	TXhaKGFswvEBhm0XFq2G+golXWevCv9E5V980c/Pgt3bm3Ipncp+ziCO
X-Gm-Gg: AYBFou10OKRKd6F7xKlOIjGZBjWkcOzzG8UHuN4vu330leRjwh/vFF3XpPnxGc2gR4h
	3FFYyhfGM07PiWStNWg0sekskrwJU2TopEKKzNGacZpslskU/xzyx6ykV18iz4hyZx9g0vlgdLh
	k7b0CdcNIi037kjzz1YofRFwFPHnqjTKrsGO9xcszgcpfAT0F6QbHazWYugurTyrwRxIJBEAGgk
	pGXYF8UuiWyFR3LHDCqmJbai3jyR4iwbyPoR2xwsQvly9/Svj2bxK3domUqTck/XR/TEt28OkAo
	qzxUrpC6/qp8YaP7dex/HCA4i+nJl2QTf3JK3KcdrZWWHEDuWNIUA5m9oCUkqJSn4Dq3x4IYkLo
	9apXghwiLj/g/iS4YxoJXcm0K8ccvj4JQ4oX2zTShULqXh24KlA48tbbm7uJja7x/NFFpDXwXWB
	RGdm+EjEZ29eX37CxXSexGLvI12Fjujyr1NKnK10kLC0xbSXAZKtZdA/xR74b7lSAAJDvh5+cob
	+TL+ksC+dXQEcsQekswVUtuK1MzC8jgXfHrPkbUdguOlVE87Uz5lJSFHVH68jvV+zqZ8oYWirHX
	7oU/QzbIHoP7pclfM0i/2l9gfAaowErvExENwQOyDgqTMQIWTtjYZb9XQpLkgeU5CrE=
X-Received: by 2002:a05:693c:20cd:20b0:375:f846:5b3f with SMTP id 5a478bee46e88-3767fe8f34bmr4140295eec.0.1794396721865;
        Wed, 11 Nov 2026 03:32:01 -0800 (PST)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-375218c7c50sm30508177eec.29.2026.11.11.03.31.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 03:32:01 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 2/3] mm: remove CONFIG_ZSMALLOC_STAT
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>, 
 Minchan Kim <minchan@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <CAKEwX=PNpMr5x4gTo_OK5D5EgKPDvZx2e2=95-4_SV8zq37VnQ@mail.gmail.com>
References: <20261109-zsmalloc_stat-v2-0-caee41684aba@gmail.com>
 <20261109-zsmalloc_stat-v2-2-caee41684aba@gmail.com>
 <CAKEwX=PNpMr5x4gTo_OK5D5EgKPDvZx2e2=95-4_SV8zq37VnQ@mail.gmail.com>
Date: Wed, 11 Nov 2026 19:31:57 +0800
Message-Id: <179439671723.2142163.87241960983612244.b4-reply@b4>
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: 86BF820006
X-Rspamd-Server: rspam12
X-Stat-Signature: k1ih6csrz1pdkh33uojeoefm3rqmfhrt
X-Rspam-User:
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794396723-102219
X-HE-Meta: U2FsdGVkX1+RbfwT78mq3CUoKeG9KRp0K+h9XmXM7YlTRwPd1AOHPZW+ACc30jdop8s/K7H2EBh4iZ/za2ITHwoaTblJ4Dd65BgtjZt4K5m+Km3lN8Z5MjJHLpZAObjf209Hr+GKBXUJjLxkwaVD3xwtvK3LxoG5ZcgBA5le9iR8ocOEn6RBvsl4SvF3QQ4auPr1T5zaO3w3gk508PUOTtUlxVkKNFpcPRNOQw4ThAdW2ratVgKYIWYpmx4uU02dlafIFomQXyTchiZlhUfnidd08OiCDA2PcYwe0voS4Vlsx7PO54FG8UrBzmHHkcx2z6KNlOM7GdxMqrYZutO+HZwch30uwhrSG3/5hDQe00tjrIhFCgAX6rEng3vZN/YrxDGL7825RzaW312qRTSKedZGW1irUT+h/AOUGAEjxcV2mnvqYfkMEa5x3/RCTmNxcWl7vqwjVNroo2mtHsi53OKtv77NKtSzed1+5JiOdaXYS0lLnkD2mihQIRpyHbIAHo9wzkFZINeApLif3FY22cPX0TxZzOgAERy5STxPkKJYlq1SyBltddXRiRshUQ8CyVOJTyh1dUzERtFSTowUqjNek1eZFQ28BJyIXEBivNkovfmLK2hAKFWgWnnR5yp7aZjtwK1hWqe0yG/jGjJc8rgu80JWrSJFv31ARlOvyeXvJKoK77ek/gaYyFKh+wdfksJAaUC1toI2Z3CtVo27avfpmhO5VA/6g49UEDTq33u3sEwg9syn1Q5j5qJblrVdH4YohRUz5WtdKXoMagMgpV1MTDgb6wA1nKZIaRx29xUBswjHxcwAaL6tu9pBX2WekmiZFgq6jJaVM6LjHPnim68PJhVvsJ4AO4yyPxJK79ty/8gejYt4mxtFgN6BRcRJkyXLWrExfmDu6fETkIyZzA3RaE3dSg41KW/UR5JDVwriSjywBHraWhwRgP8vyH8GGFwY95QjJwGvivM8Ok0
 g/TC2qFd
 uLiUuRg9LDKZ8u2YlCzYZS9ACA1zTYSXn/FadVVT+X9863/7V4j7+QNDECOc9XKmo6wf/X7HUfr63qjEycwSe/gWe8LVAhNJ7LS6YhJ9Tu8QqnHy0FN3UcjEJWZQEQjzg4DeaMkIw4tz5OD/F582+SKBripisu4vncktkeAu8+36zjlnTysKojYahkAUTZudKyQVs5OtPdPR9JYcfg32nBi50Z9GzrG+5N9/W+1axZhQiu2Do3XpvFf4W6xG86pKEkQVSXPyjT7v9QEi7wyltJBvluj58OxJNEfF+erNznS3VV1Qg9aP2+SpfMJnRsBnMbVb9T/mkS5xVvKpMypwDfAGyvYR6I8tXY+qGFyNWHELODEaZ039L9RGS/DezR0cIb3fx1saiKQux0fTXTeQflUlZRUpnLsXA/zUXmI/LHpsEri0lxfGAP5aRhii3u4ygQcgKWGub1qTL+ldO0smVrIRXRgtQEmf1BfrgR9xtxb8LZD4lX/Tr5JVSvwyPYjwNH8xT2xuhDAXRkswJRUQwNUjIo3KWQRdKd7ND8sugDtm7PPUuvnFhzjob/lOeoogcD7TcXyiuj9DafLM06/bKJPhnAh+Eh2D0g0kr7N5UG77txJzktHHXlEqYOL4gZheEbOD1bOm+gAaKyhgm7hnjZ8R4anpvgwZMwq5ygyX0IzuDbGRWZgC+oyic0Fi0MME8Xjopc5J9w8VApO2tlLVjIc3hhY8EwWGFzQqGn2uoHCK5uVZ/h1kOJb/0b5JOhTR/S0dV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-10 08:03 -0700, Nhat Pham wrote:
> On Mon, Nov 9, 2026 at 5:59 AM Xueyuan Chen <xueyuan.chen21@gmail.com> wrote:
> >
> > The statistics interface now uses the debugfs API stubs directly, so
> > CONFIG_ZSMALLOC_STAT no longer controls any zsmalloc code.
> >
> > Remove the Kconfig entry. Replace the remaining CONFIG_ZSMALLOC_STAT
> > settings with CONFIG_DEBUG_FS=y.
> >
> > Suggested-by: Nhat Pham <nphamcs@gmail.com>
> > Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> 
> I wonder if we can just squash all 3 patches lol. Anyway, LGTM:
Haha, agreed. I'll squash all three into one in v3.
> 
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> 
Thanks!


