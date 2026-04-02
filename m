Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D5A71112246
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 01:40:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62F186B0088; Wed,  1 Apr 2026 21:40:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DFE66B0089; Wed,  1 Apr 2026 21:40:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A7CA6B008A; Wed,  1 Apr 2026 21:40:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 36A846B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:40:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B8BC3140379
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:40:16 +0000 (UTC)
X-FDA: 84611910432.20.B955A46
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id A4A76160003
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:40:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=buP+RANP;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775094014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PFKZLOJ7zu0qyyyaj1iMj9idfs+8EqfH6rE7k5I6Po8=;
	b=Uh3Oe9zW8tltO+NPxCqDfA3WCXmEAJHOt7XPF/BhmcAKEa+PjRQ7ZTQZMBWsVPeYI4zZg8
	mQY1jXfk/2ULxCIJbfOU7m7Jcj65Pty+N27jfSF0GVqcalpvH0Uv/CXTPigcGGVLdMgjfN
	2vFGA/9BnjFxmH46mDa2uuAeN5zOR78=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775094014; a=rsa-sha256;
	cv=pass;
	b=24MnjU9yJ1JINeIMJI5lpinYKR8qwPy93ho3Sn7xhDDoMVAmfR9i2RwEZgsUkJP0q24u7H
	VUx9XZHuIE+MWJMeHAkIOd78tu3gA1KsoM5B4kGAkZF60fteEBnhlsgbh5Lx0V0VC6+N2S
	KkYYJWNIxgl0zhG+gqZiyUSs4xPfVCw=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=buP+RANP;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-66e07d6bba5so236741a12.0
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 18:40:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775094013; cv=none;
        d=google.com; s=arc-20240605;
        b=U7uWS3tQR4SV0xZ9pfx6KOcxB60ckHXfnOcYaPlXEiZtuyZuWTQLaJOK1TmA6MigpZ
         8Nhc9R9ycTrGFjVZ61Etwpc6/i890TqrRGmeNVFrL23bigqMHmSb5lsPUK9lCK9NCDvp
         iOF1WAHF+VfHPIDRImlvj2uz9nbO96lq4RbZ8DfkuZXVjPW4PCZv+yI80qI80HaDBv2v
         vDBOc/uoreeUYnE+ll0TYEAjvTLDVcRrfCP/qhhZ/vLTiyrzvIJqgEkRrjPEjSna+gxG
         o6faD87wwqIBa7vJpEGU/4cbiaMuS+Zk/x1iYZHee1kpgsEg3aXWPwrDKMR6AAvcY3iU
         tXvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PFKZLOJ7zu0qyyyaj1iMj9idfs+8EqfH6rE7k5I6Po8=;
        fh=hrZcizAI7Txq+2/j5uYcx2w2fLChBAzS4+DW/BCFXgA=;
        b=f31EYoM6hBCvwSHiM/uKCSMFTatPc3o8E1jrgJ6x/JhUsLN9W32S+jNDlkKnaNu1Tq
         FhnFwiNg8k5xmGQYY0MMizJbSzyegVZFn+qbkn62JaGNHMyBeCuBC45W98Pqdy5MYP8+
         s0o/a4csDRxsn2wMdzCV/liAGc7do4VBe5yQpm+xoBcXTuVT0a46Yip94WSnx47bvORL
         qAytO0JznBdx3P6ec00iNUGnE4gW5m2b89zWiLi3U4oo5rObNSdqiTEDmKwWzuwK1qMY
         mZqzpoqNEzdzuqOyg+82grgwu/bdVAdFi3l8m82EzYL6kdYkjK7H9fOnmfKcph+DXYxn
         IUMQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1775094013; x=1775698813; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PFKZLOJ7zu0qyyyaj1iMj9idfs+8EqfH6rE7k5I6Po8=;
        b=buP+RANPAJj9gwU3DbaPoWWxv3ic4M1jxoUzO9ScWwWIUwYozbExhkIcUlPntCwT/c
         pT32TW1bYwpa2PHpLDIQUPlqIm823y3CraGSdb/32z6qjiMnefKiLy2RGIQg00vlbEcf
         0ezA9GVPujVYiMN9skO9swYACznjgisZK8EbtlBbMep+H/JW1dZrUnooM+yzNhv1qcDU
         PCUYKpktXMB97VM2JMTKo2X94xn+gu9nYuoYKb9w/BCROA3vu6MRCpIQuPSa47ru5D+n
         8xEkHasWo+k8A/cqMmbF+oTVnMlvCfaftcGP49V+ZUwSyvMhvco/IuvLB36onO5NWX7l
         5KFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775094013; x=1775698813;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PFKZLOJ7zu0qyyyaj1iMj9idfs+8EqfH6rE7k5I6Po8=;
        b=WbPuEyvcItJ9nW1Xj6GTCxKkbmeCqJlzDW/EOSGiC2tIMPLwHTwlMOeVt2D6jl4llz
         7/rgEhqM+Bfra0tnHXtZEJ8KMyFM921acR4LLuO55qEW2Z1oY1U7OhOMTXK8jO29yT2y
         4IhydvpkaPaV/HOhm9sTPLi12gVwUAWGDSiSEZgpxBBfIevlD6Nwb0Bd9T86r3ai6p9s
         3AiBlJhbfMxX0sArk6VIOiMIUrxGQr0A9mz3LGYJy5YT4w+G+FZ/mCoUg+v3wCcOrw3L
         QOq4uLMG4d5kmodjrU70e07wjGKNH93GdHSTC2k/A+WRplsKohoJ94Z61vXg8QKf5UWh
         pC8g==
X-Forwarded-Encrypted: i=1; AJvYcCV4eszqLLUrBGfG7nUx2Rk2xW3SknDACSxHOSEOgLQ55V+3oMypj2paDpU77eRVXxGr4caYhVbxPQ==@kvack.org
X-Gm-Message-State: AOJu0Yyl7C87PjNlQeHbexEgP/vBfaVSi1EA5A+dpwlCSa6T0dKQHgZX
	biqozJcdG4UJpsq9+m9C21EcKJhr5DLZeA27a9ZLBc7enfrgLapg9IKT3XUTsX6OtY9urzXYrV6
	rIzox6qa0jP8a1FGwhPtXA/chjwkJI97uA3EAjpn/FQ==
X-Gm-Gg: ATEYQzw9d4wj9jIuqrhGrGTUwDK7aw110EDLBGfpaKXrOfaVfJCJXW8nPUqb8bQjj7W
	Y7Tk84JxSs2FK1Ro+g8sbM46CzuSLt72n//z4bxrsk8CvnEFbC25JGERVyePU4j4Aif+Wt3sFX0
	Zb3WaNrYcYml+pJPf0gxAhzUVil3rmOlWMMhX/+OUVjqFiCy2dewwbPlJWPhq/qk9x3L8WeQKLL
	FbIIfY3/JE09JOHfZ6GAFpPlNhi/Njdled86bbygfFOzkzxmWayPFYcWtUg9rqi66qsFXGSuQx+
	M1RsOjru0ytKWKc4mlN+/iDh1lGu5F5Mlry9EQ==
X-Received: by 2002:a05:6402:20c9:b0:66c:ecdd:9cac with SMTP id
 4fb4d7f45d1cf-66db09e75cdmr2789082a12.17.1775094013078; Wed, 01 Apr 2026
 18:40:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260326084727.118437-1-duanchenghao@kylinos.cn> <20260326084727.118437-8-duanchenghao@kylinos.cn>
In-Reply-To: <20260326084727.118437-8-duanchenghao@kylinos.cn>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 1 Apr 2026 21:39:35 -0400
X-Gm-Features: AQROBzAVSCiR4lL8xidx1gqAxIaAcOtLfz2MqrBrE39rYeaq1LvBRWmL93x06bE
Message-ID: <CA+CK2bBVZyZx9L=dxU1c7EAnoT3bdJ0=hq-gj915Fz4zya0Khg@mail.gmail.com>
Subject: Re: [PATCH v3 7/7] mm/memfd_luo: fix integer overflow in memfd_luo_preserve_folios
To: Chenghao Duan <duanchenghao@kylinos.cn>
Cc: rppt@kernel.org, pratyush@kernel.org, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, jianghaoran@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A4A76160003
X-Stat-Signature: xogt8w1xzi16h5d4fqecu7ww1i176cpr
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775094014-656057
X-HE-Meta: U2FsdGVkX19LHF6U+jxxtXzY6OLkExavCCUzPUsOU+3BidOyBXV4FNN7+diMx8fn2t7xtEvp7cu1+EMOOYLCs2Y/yZXretRsBYwtdA+yYPSjuU3orDL/KX2Aevnbg0qAWNBaLtEHuxGoxicVhqf12sWP52daj7S1ma5jgtiQN6/UMe/0qpU20jnaMLT+f2T3nhCWIVLDyKdWn6278DruTG86ZjyxG6J5QEzpzWFA7LnkxjD17rdTTQvRdSp3SDNcF7NRNyqLwtRR9gQNyYxe5NiL9v3rUQwj0Qycc0l2T6rz1c8PLjKr/2aAiROb+3W+ukUMkwAxyScgl/dPROeuTZBfcVARVjZxuG4beJdBzZgMbQNunP8YmfkVPLFu0HO7y9JFw3XhtfpLMrONN1wHPZVldibFpB9exTS7kgYfqke3IaAt9D6BwkA8HmlX0pUqxhHU5NJn/GhJcFbLHTx6EEriWkJoapfhADSeOMZVuQHtV35kYAvUgZ/NoRRsxlrxJNfc4LLXpV2y59SUyH16KeNbAQg0TTEfekb43Qi/QDHW3JOEnCK6BSxB/qEI0cPxD0l1jfr/0C/q2VQ4tub1IuhyDJeAaGUqeS4HaRpu8jQxdDyN2roDg8kN1DESj12jYTsmmHOIAGLx0qz04dId9oVIlNkx8uu97cRVABf6dRCC90XPz2ie7R3Yit8lOE3VtPolBmW7ZBYaHbG0mn2SDgjFBo7+c6SXIThwaC6ZaXSoDxMiyfhDEjnfDPeQqpSf3ESkSXUry5kVDVLCY33yAakWZAUPUgNjsnnFH11RnZfnsLK5DS5uvchxgN8kks3025x3S3srkWXVXNuCctzNykMhnvmQXjv8jrRi9GsnCxWVtIZ4NjkUQ4Hnka1W+ygPDrmG7zkB9FtkYEshsyvw8tFSp9MiyPcVC4ol9wF3fJJ1VU2jiUIV9cKcSier3f/IABBnyLjxt7afT+0sCRz
 iKZNIus3
 JVC1+1c0sNWUlV4Xn4hy6mat9+nHQ9y+34f5Zv2d0Tvhx90sxJoG3XleL0zj9RgO3WJNNqLuvQ3u2QBFlC+sdxyM5TbjZVTuGhTGm/iZYylFL4889LKGeQwMry4dJGcoMt3aCLI4vvbMpxCowc80aMv5FMsywLCzDjIp3/nLyPn62A9fE5b/6tuTRyIL186jsFJIA5q9NUALHYCOoAb9bcmG7V/0phjnmPwStKsX0onFqw//jAamys/v0cxwzDGVURhRrP1M4NhJhOseMxbBh/BzTDWJNZucwnCNZxvLn/lTIOrQT2WuCDTEQ6qK7KG5VSG2EabQ1oB+ymVroFG6dezjejw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 4:48=E2=80=AFAM Chenghao Duan <duanchenghao@kylinos=
.cn> wrote:
>
> In memfd_luo_preserve_folios(), two variables had types that could cause
> silent data loss with large files:
>
> 1. 'size' was declared as 'long', truncating the 64-bit result of
>    i_size_read(). On 32-bit systems a 4GB file would be truncated to 0,

This is not an issue, KHO only supports 64-bit systems, but using the
correct type is a good idea anyway.

>    causing the function to return early and discard all data.
>
> 2. 'max_folios' was declared as 'unsigned int', causing overflow for
>    sparse files larger than 4TB. For example, a 16TB+4KB file would
>    calculate 0x100000001 folios but truncate to 1 when assigned to
>    max_folios, causing memfd_pin_folios() to pin only the first folio.
>
> Fix by changing both variables to 'u64' to match the types returned
> by i_size_read() and the folio count calculations.

Strictly speaking, i_size_read() returns loff_t which is 'long long',
so s64 not u64, but anyways u64 works here.

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

