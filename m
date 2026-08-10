Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3DA4C5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 17:09:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD7CE6B0092; Mon, 10 Aug 2026 13:09:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAF2D6B0093; Mon, 10 Aug 2026 13:09:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99D096B0095; Mon, 10 Aug 2026 13:09:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7253B6B0092
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 13:09:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0C0491C07DE
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 17:09:36 +0000 (UTC)
X-FDA: 85085996352.10.5814DE9
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf24.hostedemail.com (Postfix) with ESMTP id 258CE180012
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 17:09:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pgBtqSuT;
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786381774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s+j5d61c3OSpvPdkGdTdwVzk8U68zaEBU5tnTm+IZgo=;
	b=vAgXwWJh6ggp20Dxe2wfTaRV/q5zXvIeLKL70m/cEBZAC/q4htob2AR1GAAU2ijGjku7pK
	TLqZw8jgmLQ/sWo8iB0S1NylMhljpEpbV6I9S4Agg0FUDM7H9q1Hl/R8lUGeLc6mJ9fEkz
	0mBuNXP2nagD9gTvHYbiaTcz9I6UcFY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786381774;
	b=1yqsECHmgKWqMyW88Xn+qHGTmlqapqPvRPV1u6ClDC+dalpmhbnN+di2uq/jF143lQSHth
	7MOimH8lE3InMXUIkbzVht5ovCEoL6d/+I57+Eynqya2d9A49rF+xPjjrm91bStcZBYvaw
	qpDZH25dlQ+YceEHp1l7J5T/oxUrSxY=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pgBtqSuT;
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51c15a5b265so6821cf.0
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:09:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786381773; cv=none;
        d=google.com; s=arc-20260327;
        b=lWaTlnZ3+QZEfx/xXjBMOXM+BdQAK13dqWFtny+qTIWIXLlqbudzK/EHfpWFJAIdtR
         8x6txYIseF4AJ+3Lc2xpaJuDz0+4drvVOyMWl7R24pcNxNo4LiYJJLRNkKlYF6GWcJCR
         A7OWKFcd6/RScOeXaiftowLOfFDn56R1Cg/TzQ7M1S2UnJztIsqMG9PCgpVAoMoYfXhp
         lyuz3Tt5HiVhkZibYB9RIkr1qiUQH3vu5bTFgHQQ87MjpQAf8CWTmZN/J6i8UQS76F6Q
         UN3X0OQmD4roXiALtIOQPB/aDr8XImQS/SA2leR1Pd2pvsjKRKdqrSSDRiE1mOHpLgrh
         GKPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=s+j5d61c3OSpvPdkGdTdwVzk8U68zaEBU5tnTm+IZgo=;
        fh=DWc53XVzDUrDQEmoEOjjl7PpgNDYmV/h5cC/SFBG9wE=;
        b=h9LVRuPy+emKKgqZcwx4UsJY3zf4mezb/cZSTvrLP+ePFN5a9SVSKvxQ6PvA9rXPFD
         lkwZl346fFFtZpTYMTtfHCUfJwobjYZPipgb7YR2aPajnUCY330K+cFEuqgvNWpF8ZdN
         1e21NCNFW+DiWRu9+IhrmLjvZE+83uKyVzPDlyX//cYBpwB07YMpmuTQRLMqok/6romm
         0oDtDb5u+IbtsVOHSdito9f2nu/f0oi/e+5DpT8zoap4IE8PMoxQ7ufI12sPxZzgcUa+
         WaDqf2Df2/WMs16YsRrhVFwougM7Wz1a2Ml1UBXw1pBh0j+f/K2r0KpjsYW8XzREJ5UG
         Kfcg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786381773; x=1786986573; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=s+j5d61c3OSpvPdkGdTdwVzk8U68zaEBU5tnTm+IZgo=;
        b=pgBtqSuTACGnnPaS0wXdKwb/xR8uuJw44wIqcL19y2T0I/KglvGZ+Y5cHr1BvLSNHm
         10LBeq6T38rOLBAqk6/35XoTqFbhJQu5lPKHnKW9uWJ79NJuDJlgy4zGoNuz0dSnnpxB
         qkOY2sUEoX0YoE/Q+q44Uyh2VcNzrL+qPi/YspBkPUmfRQP44H2/XOHk3OkywTZjSnAD
         /DLvVRlcJQpFLvn07pXN6+jq0o2W3z/kH9UxVtVJRboxMtwYckAhnxqTt+TPvp35DedF
         GIJDcmboF7doDRtIB2A0kQfV9rg9b6yC+41FqzlrjMFHiTgtRcRakdUiQLhFuEUpz7II
         J5GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786381773; x=1786986573;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s+j5d61c3OSpvPdkGdTdwVzk8U68zaEBU5tnTm+IZgo=;
        b=ZpH5S6TqeySE09P4T1wt0ZM4CtyKt7GihmPnOTgNim54tmPnI3GjAZdqrTakuVvuck
         dg764715spPERQxoj7fD7c9xKY38uWTMsuNlZwdt6tKIev7jIxKomanebIJhDj7FEyNV
         OeI/Ufbnb8hqhNHYmRd6i7Q54zQ+Y8hVUFXhrRFhzFlbv6aBuhZUo7Vwas4jA/uN8JSW
         dCQPIpUscX9lU4pvdEJAN+qUYEOqp77+r6yVyzw4FC0gUkFUm/Ndo5wtVr5B+uDruKPH
         vQI64YKyoYK5k2F60mqDtBaSl82LI1CGqPbidbHm+S6mHKm+YUd08x2PJrrTQDj7OG/+
         80Wg==
X-Forwarded-Encrypted: i=1; AHgh+RrtS72Gx84aLVan9/Go5TzP6K+QjT6WHJZJZ2TXoAIlEzOyPd9vVPIKHCNK8glxZqxS4/tooMvWzw==@kvack.org
X-Gm-Message-State: AOJu0YwHfRywYizQnCpdcaJwsHlbE3TA9urlmTOVl5hWLVWVDxEJVWrJ
	vNegAq1LQn4lrnhtGcMmfYl+bXqmMdOYVGoo/ALj/gwTk+qVKBViKu2taCjj6Q3F2j/GWv4aupp
	B4mkLwJ3nW+l0yb4LF1nXaJI6/BAiT1BVeNP/Z5BH
X-Gm-Gg: AR+sD12PdPVJyW0+5YrpApVgYMYKwf4SGdNRqnQwu8rXDCZVxq25XizIYY37IYLSfsu
	XSxpqsX7hM8BP0/6bO79XyV4fP/fQmMc6thiOyKcUajFV8oKOSpNX6gjvy3sdc15/puztXmcK4B
	weC/N02R5sa+Hl5J93UenlFv3wtFIpeHKa/pZgxVNVbgjM3P9FsuOSudVfUe4zRw9yuHsRo78E/
	DX2U1SsP35UcYi/HwKphd/LdEiYrGUQloCZVg6i8ZzNu8/tLIJ0E6mwl7Sh/ujNBiYxf6CmOpAp
	w/1pe4Sztt/eTcBDL5YdUL0zNTWW6ZNEu9IukqmD1rs=
X-Received: by 2002:ac8:7e91:0:b0:50e:5eba:cadd with SMTP id
 d75a77b69052e-52d51123088mr435601cf.2.1786381772424; Mon, 10 Aug 2026
 10:09:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260806200548.3124802-1-surenb@google.com> <20260806200548.3124802-6-surenb@google.com>
 <anbaJuYXEoldvtPn@casper.infradead.org> <CAJuCfpHh1E34LVTd=4y8m+2ugGABc3MSU2Z5N4pFY4ttH0a5Rw@mail.gmail.com>
 <13c444ae-9da6-4fbc-be98-f107fc3bd0bb@intel.com>
In-Reply-To: <13c444ae-9da6-4fbc-be98-f107fc3bd0bb@intel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 10 Aug 2026 10:09:21 -0700
X-Gm-Features: AUfX_mwx6ocz62ooVQSWbPu7_NupWXDrDYExCS9WPkUtwBsAoq_oeAqr4fQySK8
Message-ID: <CAJuCfpFkyGrN7173CDhZZ01+qovRqW0K=SEz+wNJHZm9Ha2Dtw@mail.gmail.com>
Subject: Re: [PATCH v4 5/5] tcp: Remove mmap_lock fallback path
To: Dave Hansen <dave.hansen@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org, 
	dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, ljs@kernel.org, 
	david@kernel.org, shakeel.butt@linux.dev, vbabka@kernel.org, jannh@google.com, 
	aliceryhl@google.com, arve@android.com, cmllamas@google.com, 
	christian@brauner.io, tkjos@android.com, dsahern@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org, syzbot@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: f7mg498yp65c5rjkh7dhfuzmmaknm1bp
X-Rspamd-Queue-Id: 258CE180012
X-HE-Tag: 1786381773-7435
X-HE-Meta: U2FsdGVkX1/qKXvw7+ARC5/ijbJ1AmJaYghB2FE/cksGxpn9xr2TzgKne3U7mPCW5N/yR4ZSnTLpmliI5JQ6moPk/i1RjGAUo+mGxboCyjtGUcvyod1FkwiGDf8AKv9JsA941PLlgWoftWxA+GtDRhgY1zy40mVHirJp7ldL4QCrjpyFDthOGQRW0KsGrTBv2pwrqCtQtCfkZBu85E9Ejgf6lTrAmN6sRdZwIo0FguHB3U+Yw94RJ6OqNBx+ulWvfMNjHWfM5JOh/ffKryPRpTuEnDH5t8lIB4cwAzCUNbb+bAyOptxHVbkiPU9belxwtzATm3JaMX+4KJ0smdoAhfx5eWncSFCszqPMvBSkWbjDxv6kr/JdgHvQhig9t/oXOJJd+R7n4Cu+ntmuRNzbvqpK/HX75O3AZC1PdN8MjX1WMMQgZ7uoHSHVd/20MAT2/9e5BIjxyiocBzNHsv6hEkNMkvTTQQkFQOfIBT4viuyWs+BuRrUnRYsKbrqrMvqkEDdkxBWHpn3cu3bCwnISatVTF1BXz028nTyASRQj7fAr4VEZzUxGSAnzITargm4aHE3mvNDqDgLNfHfX2hZ6Jtwca5QvQ4f1SifLwdRpYKc4Y4J4a1JJFYGOeUE0zgP/uV4arqMeDdjYjlbnN7h+Xn1nJwip8h5YM+6FetNuSpMbv6imW0eA1L+DTBvah7E252gxX3XbBnPNCsx92g6NIE92k4TuPDjCShkQDAx6DCWAfg2E61NHrr+GdKNg8laXtuROpNh9izy+7WLE62ACxmEFsdGO1O+Q3mvaDqF6ABgRRnIASR/RQcfKkP3/U8aX2QOo0/Hp6ew7apxAWmyooZAu2Ff3gugHdwa+kDrQswQIVSAqgG0XfG//qy+XGd6tPoLbgmGHbWvKtj+tzGSjw0irLsYxc8yWK9Aoufx0kswZphGZlJ06N5nAwzzDFvfY+4Z0jHlJPOwbDpF9Y8E
 WHfe0s2l
 ABbxnFw4tbxj2E6n5IcMBDNXRlZsm/7tYCxQnMrmDGosvstbMfsbCvOcdb9Cho2ouVC2vZ102mv5Fs6YoXiMiGv0GZKaNIVTQgwO6cQa2iP5h6EWFlfdHinHBIfpGkqUEUj8IhrTe5EA/Vv98rffMPFB0qnEB5zRjkrnp2DL9Nk1EzGRtPycjcVwvNC9+EMHYCluca8NH0jhsw7DiVlXFxb/VWhUfmSbNMqey+2j+k/UFuApayjKcljr50evdZaRGRfzdRmqKLCFSFNn7LMhDOIAxjzYLk4VsjoUZMk+wNJ4xQt1kHZSYA55CK6Xg5xeIIQoTZu042RoAFkaDbH5SwddF/yncSMkn5L69F/RDwMNaAkWzoPu6TGKsHWv/1a6a5mZ+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 8:26=E2=80=AFAM Dave Hansen <dave.hansen@intel.com>=
 wrote:
>
> On 8/8/26 17:51, Suren Baghdasaryan wrote:
> > Ack. Will fix. It's obvious that I took over someone else's patch, isn'=
t it? =F0=9F=99=82
>
> BTW, Suren, thanks again for taking over the series!

My pleasure! Thanks for starting this cleanup!

