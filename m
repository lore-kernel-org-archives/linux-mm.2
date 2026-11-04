Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67898606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vY8Z95Su
Received: by kanga.kvack.org (Postfix)
	id 892836B00EF; Wed,  4 Nov 2026 11:35:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 862AB6B05B3; Wed,  4 Nov 2026 11:35:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 750B56B05B4; Wed,  4 Nov 2026 11:35:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 51C336B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:35:16 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 66ECBA0723
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:35:15 +0000 (UTC)
X-FDA: 85397986590.08.4574CEE
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6CE641A0011
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:35:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vY8Z95Su;
	spf=pass (imf19.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793810113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r1Dhv/Jl1KwjwSgeC5h/yWHauZP92LHd9bdUwOqpNVM=;
	b=FnLThSxCHsHKudEg8R4yrYnDEUKemcf5oHfrvR60qy0fMmzD9aFADMaKBbJm6thErxuEUu
	b0fl4e2p41Ljq8vMU4BCgXkpDuiLml0bqGrtsac1bFqANK685bIcpc2MJE84huw01EQkWm
	T5r/0TaGxqO1e8TTt2PnMb68FA4VCeU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793810113;
	b=L8yUFy4BbkXHpRQx+p2uEUdRXYme0DPuoPQMJzD2BtU4Ez782QqFcfYt5KtCFge2cpmNkY
	JMKChW5Fh7IJ5CselAMJMT7JpBAjAezEBCmIyASKHNZr5fisqJwlTP3Dv00zVM4PFUfyZ8
	VztFiU6LLMMa9AzFRf/tuR/2iAo0l9s=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vY8Z95Su;
	spf=pass (imf19.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4afe2d546f9so10932385e9.3
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 08:35:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793810112; cv=none;
        d=google.com; s=arc-20260327;
        b=TIuYHJNGHY5LrEWSg1PNvIR3KqZjXsmlnp52wTpBWi1c8RG6Z/Db/tCOuRSdD0+2Nc
         n0POklHOq6sZCx2E1s1qxQkP1eyqA6PRZFKVQbDywCs6WE3ZohWB/FKCsCz7RDRTFoRl
         PCmcs8i7eDqbzkUmqpm+gIyiwKevwNRWzAytGmIIgGhsRfxeyjaxzsLBzmTUs/IRyU8f
         F8Xp5ATAK0Ju141Bvnj4a98jkZ2x2sf7eVh5aST9JUtn0t6k+l2C7ZnbBblMCCidkfUN
         9E6vsrgpkfUjU4olaaVXBlJMHhzkbTeeuhy6JsmxmTjbuKDReQgK6x5yLJZwDRt7CFPT
         3ogw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=r1Dhv/Jl1KwjwSgeC5h/yWHauZP92LHd9bdUwOqpNVM=;
        fh=sannMMBgr4CBRbgZshJnvHqoj4aJCFrNHw8mVWDrGOg=;
        b=RtI3HwANT1ZjpM2eibhkkimiy5YnPNwOpfbqSm7AW3wxfBjg37rk9PIPix/PWBOYSb
         6qwQKt5FLb+ZDliiOC0djAgN49xDvdLa7pgTgy7/6e8WUNHIODAgGuHFWeiZRwE1RMVg
         Xu8vBpyyxuBDDvyB1PL8GthaNu7beGFugsVfL3iK1eqBvQ65J1LcBV2jb9bb2z1/d9yC
         Z28WNcsc4EDQR61U/TvwP9wiM5vuDYKqR/w/nv3jp8Lxp/z3eFxtFOtEnfenswS09QKp
         lllvV2GjfNmUjupQ01m6s4rKmYfLhacFK8nXrCHksbA3PvAq+hBYM4JORg6zi/+dvz1r
         zIgQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793810112; x=1794414912; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=r1Dhv/Jl1KwjwSgeC5h/yWHauZP92LHd9bdUwOqpNVM=;
        b=vY8Z95Su9TJjWdl20rDZLfKlVGrwJcLnCW0HQsBVokZS/caMYmyRC1HlW0NBAP/R9R
         r3XAiCDElMXRlWFMB34K186rnqXguWs+Dcc80CRqUeSHDCIQfYZEHfA2WqOJu15s2vx6
         vHCq8/stMZOWd0zr6xnXkZfNEI/jegaWJQilvcXwWl12JDvwXxzgpvUV6saEmW5a9HNu
         f508Qib1u60/3H6lXuI7ZKyY5u9/Q5wzQSJ+AKwlU0qe3hwxKWcxOvTSorpEyxnLeP+Y
         Lchf5tuGik+hqf4otRN3iUySDoLiwiYiOuPfM4GWHFtOCCAJsqgIJCA/gchbzrQ1O1Gm
         mL+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793810112; x=1794414912;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r1Dhv/Jl1KwjwSgeC5h/yWHauZP92LHd9bdUwOqpNVM=;
        b=CnfbG+FMagkhRMqryMuOAP6aEjc3bSBt2noKfdF9qaYUawdwtvqwgtYqVXd5ObBFIx
         vowi3pLYieRAhrlixeCQ/wN7Y74CPVjXR2d/6oYSZT5WonnJmcYd+1JePVrKoRKb0lam
         ZwasQUT8kv4UCtgNvK1PAiNsw/1AeKgZXNMyYuSBNEesm1WlS/6XJDn50rzGjLP0eQKL
         KfVjIgz0RYULiABIK8cEzkQYhVX0x51GAW2cB0Fb1Ds2JoFJKIiTeVnFRp42zuhLQM8h
         /fgvC57evSuTLoYktdlIhzX+WSGafRhtSF9Oc8yfTIKTqaHVVw8TnQQC5U0xFZA17pYt
         8Ogg==
X-Forwarded-Encrypted: i=1; AKwUvBwRskzLQACo3UB9Kkkudf4m4f9G1k97mLoHQPna2KuksPcVgmc9SKzfmRHghojhNzSTkUHvDGrN1g==@kvack.org
X-Gm-Message-State: APuU4Z/vkhZm9ycpidsQ9jQJrxr1QRNTdTWN/XK9Xa6UojgXwLKeUD8n
	kbvquXpQOYBe0g6w9YnZAGOFvXZvpORddkZaw2TajdjbaS0qO7BsSk2WDcVU4hi2DErGGTJInwc
	+ZB33zxQ+wI5RiISBLlmGzRG3NvDXl6o=
X-Gm-Gg: AYBFou2nVau70LWD7hOl7ZsKBrhvhz1UF9GeqsGPsXFS3mFu1c0c9Pl5x7/FVofwups
	hN3S15hMzcdrC+EfTPjkmh30WRBCdPTC2j0bJI+rCnlxSReLgPgP2wJdR4Ta0Ux91yA8XdP5Grt
	ZHgDj/jr6hId9rlNHnmrRsiu/MyjMjxaxyXzTOz8wQNqyasOgJv7TrHN8UCBH0St27qJCTuNRXY
	P/hNaCpzh3yDbK4WcCKvGz2MaXaWS+ZPLJ1q3eIsuQBvp3JKy93/ITyx3ESktglytTilxrVsQYu
	pKn0am5Y50uqDljgxIWjx+TMZ4StSlFMY2/ERpnjCdk6ayS4ZvJVipfj0iTkJ5TwdDC4rT0kvz8
	Bh+v/yG8nLpEIhJ64xazMvd/ULIJAJgaEZwDLbwFhlJo+GczPoD1drHhfhThSmDoKOxf6KI6Bf1
	fVBHqzYvjj2PpJK8Ef3Vi2B6HVxvfTkCUCdxNX0qBDz+vEHiyP1T5nGiRCwF2FozhewZDRniIGG
	A==
X-Received: by 2002:a05:600c:4715:b0:4a6:eca1:7d5c with SMTP id
 5b1f17b1804b1-4ac182dca82mr384625265e9.32.1793810111530; Wed, 04 Nov 2026
 08:35:11 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261104095315.2326-1-zhangchujun@cmss.chinamobile.com>
In-Reply-To: <20261104095315.2326-1-zhangchujun@cmss.chinamobile.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 4 Nov 2026 09:35:00 -0700
X-Gm-Features: AclHuK9XCOvhLBDiROBbZxHR84Wbx48lhNSlCdNeopT450arvK86EzOe3nZed14
Message-ID: <CAKEwX=MyLZ12jtwWOYWvf+KK5dyOOG=RWJb9Q8-DEFy4-twNgg@mail.gmail.com>
Subject: Re: [PATCH] selftests/cgroup: test_zswap: check malloc() return value
To: zhangchujun <zhangchujun@cmss.chinamobile.com>
Cc: hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 8kfeizu3t3tbobkdjn69mk6xgcm3f7db
X-Rspamd-Queue-Id: 6CE641A0011
X-Rspam-User: 
X-HE-Tag: 1793810113-66412
X-HE-Meta: U2FsdGVkX18PlzPDo8eK0uEhZEXTGM+9JOYFoaTlokkP/Ysno6kcmgaZYPPGuYskk4NVz+RKBY/XHGXw1SrohXNQ1Owl9Z8DDtxvwWZ8OymI4wxXFR6xRPFsx+7B2wfqkFu+iO+C58UbmZRgfqK6c+7WUHhpzNrssYkdNHSZi3eYw2y12UaO3svc1nvrBq9/d7BYum53rA+kQUzUMaHf5HQU+yR4CKnpPR9AXX02LzCTbkjC0M4MtSO/m5cawFKyBfOr7evKPjvZIUqR6xByyZuTEpMG4yP+CYwMtzbqpjWRc75mGfxvjYzWWCa7GD/tdHygubkThk03id3upedlT0RYy2tjzie7R/Ag6M3jDa/fMiufx1CMM3RdCH4tESJt7ERmzfPJ/U2jBRFNy3rxg3N6AsZDd3bRyJOmmgOFqd4DFwpFoZtTF+hcnQcKkrnB/54C6wD0/s9/LyNIWocs7UQx/g4Orhk7VDz7n/1oX08fxHVv7ktAaNnf+Zrprr/S5PfglkQMSbjcw342VcG10D+SXmTdF78EKZobVawe8K8ds2azMJDV5+IhuXVe8B7w53XD93I+8R72yt4k/9kfguTFd31to1hHNG0zNgb/XcQohJ1bGwo4VW8/gHE+NNSiGUQ/KebYGjCkdsTUh4ycHVdExQBsBb7I4v0sHZNR4W+kmT360t97PUgu9bBnKCXY21S4UpXf5jXDkFHXaQDM4E7yDKzw2Hc3YbqKN7RF+wbNOiJdIGxdCAH/Xvi0aVdcr3UJFkbogimYE6D9i4eP7wjl1m3uTBEE2NolBaAvGArQIFvYtG69L5EDCHqMo+kzRPrm5FDqnSt5e6hhO4g6k1kivzQP1M0+GlBtFsxgsL4qkuSi++ERMubxjrFrS4AiBrcaPSk3jQIJjSTL/wH0bS35lycYJJoR4blMaymF/iL8GEzOfrzyrUZ+dnlzb0Z5G+ySaIcrGZNS49Vqrm5
 /KXbNnJ3
 Mv+QUeDdHxnEfj3uwHoBMnhLOSKEoc4F6sXEVfRSYZXYKjmG3l8rLln+fXf0rFO+xuXnqV5AhVa2GkHjVyp+9f/E3YK+9CgPuoFz8V8k8hdgi/borNxax5dUNg+N5eFNf7fSr4Ld/5m9s4lijgK99kjH59rb1hCEe2Bq4zURmm2R8fGxlRrhjjMZf6EtnVXFEGNPZPivN/2DWntpjyFFTtTA722rwvMCqhLxz0KaWLhD3Flo0FZGG52AWc5dqRzTrN1sBIFRdC/Ul9l4yGtIHBlwz/WeNsMVMDQzUfh7tvya0eCC++e8XSK6ndovIK24nlWvhuISdK7xIG+nZNKLwsxxPp6zeu62wgHPKeuAhPh1IjBqTy+Maykn8yYJnXUndCi5e3GFNhNbdS6Zm5qg+UoQRHRCQzR7TZop58Zm29MyD4ltC02DgvxgHRR9YqKUsvIQOB8tRGzQB2qjib3LZWPgi+qHfdXjiLGMz61x2k/DA0mirrryUkcVCG2o4Z1Dqf8qfrA2SLH3me8Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 4, 2026 at 2:53=E2=80=AFAM zhangchujun
<zhangchujun@cmss.chinamobile.com> wrote:
>
> test_no_invasive_cgroup_shrink() uses zw_allocation immediately
> after malloc() without checking for allocation failure.
>
> Check for NULL before accessing the buffer and use the existing
> cleanup path to report test failure, matching the handling of
> wb_allocation later in the function.
>
> Signed-off-by: zhangchujun <zhangchujun@cmss.chinamobile.com>

Acked-by: Nhat Pham <nphamcs@gmail.com>

