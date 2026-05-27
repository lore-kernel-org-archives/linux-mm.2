Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB7AECD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 19:09:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA5906B0005; Wed, 27 May 2026 15:09:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E567C6B0088; Wed, 27 May 2026 15:09:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D45E16B008A; Wed, 27 May 2026 15:09:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF4896B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 15:09:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 64C4C1C1E97
	for <linux-mm@kvack.org>; Wed, 27 May 2026 19:09:17 +0000 (UTC)
X-FDA: 84814137954.19.5B07F73
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6A5D8180003
	for <linux-mm@kvack.org>; Wed, 27 May 2026 19:09:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HyVxW4cD;
	spf=pass (imf16.hostedemail.com: domain of devnexen@gmail.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779908955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jMc5PfwOQ3gD7SO35sfuAww1AA/vOt+pfndL3cxn0gE=;
	b=SyHL7B2otHhx2cT4PIABCfPmyZfXt0pHGKsOUMRmmqx+tvixml5M4N3OZfnwC++VoG5YTY
	tsGrOEMl+cdOsYBJNseUQ9H+GG0Ucw10DDwSDqBVpQUk1NH5apykpkY8OC+Y2KJfw7Kv1v
	wdcNbg0TB725yU0kQ1WzHj4T5KVWIfs=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HyVxW4cD;
	spf=pass (imf16.hostedemail.com: domain of devnexen@gmail.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779908955; a=rsa-sha256;
	cv=pass;
	b=PY2PAeQPbZ618JpuAQknvoXoSklqztt9QU53r8UE0xZIWDT7GCg+Dn0voP9p/Gjv0TPxVL
	V43r8MNCm0aPARz/rxYJV++2BOBa0ExK6Vqqa5eUxsgI5Ixq7IQd5GgIFlP7Epr58srsn9
	3MnO9dK7zW89M0XLyF0IKkT1uvUiURw=
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-65eb1b25c77so6766895d50.0
        for <linux-mm@kvack.org>; Wed, 27 May 2026 12:09:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779908954; cv=none;
        d=google.com; s=arc-20240605;
        b=RQS3ByDefvmxMAR/dflRj0wHu2PpdCvygRYMJ08fGb/Et6kknsp7D3aOpxvH7eE09G
         ohRRZrMdHionc2bACKyZOb3g/EHKKw0VMrgYeH8Xs/veHlV71Lbjw/9zqB/rH0ZvHdh3
         jlil2neOC5Kry9K3r6UgReYlEKSgGZrTwGPK4mPq/9ayVgeFWhgD08qKl6mhq1s9zsbj
         d2TcSl6RLdXKJ3HigaKbmiCBJWPEp1s0BnVpnQ9xAnSUp+a+sGUgnYfC1b438J04dRo6
         zZ9xHIT+CTThJdnnog7HyOvticOxnvVQX09DHUWGd84WIr83OlRVSaZR1h2Wm3/YrYFl
         QtSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=jMc5PfwOQ3gD7SO35sfuAww1AA/vOt+pfndL3cxn0gE=;
        fh=ZndrYXmJar9Jr66F1MwIGAcG0FBySh21B3dI3ltDRss=;
        b=djTYF0vKFAAz4Ipyty1mPc5MDNHRFEmGhq+GgFtyKd+roDAU4a3OnY0XY81sQuzc+o
         6lltJvhuJyUnqFWhHHlk61ZFNtksZxwYFOHrayCH2WLc3MqHeEAW6Me9CbxPG28tGQL9
         OMnzodRrMP3FioqtHGjoeShe0sAY1NVBAitraD4U5HqAovL/zfu8f9V2YPVTLcOHQuA6
         WqVvbBJQSyEAauAeT0EgNgUK4UgWQjxKzi3DlzqUDKYwt8bR7CP3pO4yj6584tRKj1by
         /B3gnZzAlIlB31N44Cb5nj00sXCkJRqFl6WsaPz5xGzqjVvG5Ep4Plyj5+ieSQyw2uuq
         Igdg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779908954; x=1780513754; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jMc5PfwOQ3gD7SO35sfuAww1AA/vOt+pfndL3cxn0gE=;
        b=HyVxW4cD1dTTVqHcD/2dcxLTlDPHTos3wgy1gK07iqviKzxbPCVdDyd00YsHYXucby
         5yV35aXK6lhJ/4YjQ2/P4DBBs1D3/TisgID4HIZ568MAUTNfaW7obtJpWnSKbF77VrDJ
         AGpgsP9PJSEpwpmWP6i1xvYV2wBtePgRtJuza1Ak8niT2yBYPP255K+qRbOfQy9ur6hh
         nKWQGZQHfrUHyRY5MqhJWCFFXf4d63amQGvTfOjrNfEu4lhStQi1SscFDPQjI73TfRiE
         9nABKklcRTh9U7NwKEpYbu5R/5m0KRZ6MYbtazjA05l4jDocmOBCVATi4TQQpwnlb2wb
         oCiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779908954; x=1780513754;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jMc5PfwOQ3gD7SO35sfuAww1AA/vOt+pfndL3cxn0gE=;
        b=RMnlcWImE6k4gJ8z8nYxEpd5uFgrilGTxCUwN3QJtUBxw6CmJ/k4c8yt5dWaMYdGgn
         8/MKKwjuhHkABCkcHSzG1v+Uy8hBR7VxIPshWcfWzMtDZQHbWt3cOyTDSXSguJD1h00r
         Z/xmKKZ7Hwc77T8RMyNr4MZT27Hgl0x2ApvgPNjqPg+vNNTanSKnl2JXCgRDXa3lCnbr
         l6UhEkkRWdHJKfzPzbqGoKxh7ria+vMP7lgO11XtcAaJzKqucfbkDgrqjjJpwebJS2dJ
         AAARzPsVeW0Ga2jJ02WbjeGzbBB0+HHQyoxQUxpPEHOaUQd6IsmNLvC2PcfpTry36rX3
         wAwg==
X-Forwarded-Encrypted: i=1; AFNElJ+rBg4eVBInY7W4CXbXgeOwU8wkurxjg1CX+X72SBXuYWH4xoQwJpr7ZmA7P8ziKz7LgSZ+fwN7fA==@kvack.org
X-Gm-Message-State: AOJu0Ywm6z9wU9JMCPl2SfKNwPmFnj8juDqLLvrrkV9wBb6YvzYtKu77
	tL4tHqAA9JLY2HpR+S9KyqRyOR8VtHYGCGL+b3QPRqeDEhFp1M+QHeXXy4wL03SGZeLqgKroPro
	SgnSxdr65jN+6b482zSFDXBm4Vhe7W84=
X-Gm-Gg: Acq92OGkKw6XGv745OINk7WH/IVkRsONm5h1dYY+xmVBQcLg1sPdzonhDbn8oJ+/HEe
	0lSIwsJIgjdRcef+7RU02wnSZpLojByLHnISOV1v3AF/xHCyEML9eAuG4L7B10CvR3TJKvLGD3X
	P8nrQbZgUaM1W+Gw/z0ZeJPINelFtkTmhUB0yiF7Fhq2cB3tjavXZRSV/vw5A3a3xghvqxUHZF8
	Cvg3VumOU+FwCzKcPC43oj2MRqVZ7O6bnYhVCF4Jy+FSbd0qxq+IXskh/A48p5WxNdlITrCFo4n
	Y0OW9D0383PrazCNoOTYRlHXxAocbnRputLUTIdNGTcrHh/j5cn61iY5t8A=
X-Received: by 2002:a05:690e:441c:b0:65c:5bfd:b207 with SMTP id
 956f58d0204a3-65ec99c0fc0mr16484763d50.62.1779908954310; Wed, 27 May 2026
 12:09:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260527184751.4147364-1-rppt@kernel.org> <20260527184751.4147364-3-rppt@kernel.org>
In-Reply-To: <20260527184751.4147364-3-rppt@kernel.org>
From: David CARLIER <devnexen@gmail.com>
Date: Wed, 27 May 2026 20:09:01 +0100
X-Gm-Features: AVHnY4JN147vmsbDgyIIxFn7rDJU3XyNyGNlp4E5j59xkFcQRBWVg-doGHMCCWQ
Message-ID: <CA+XhMqy6NH6Nn0=jT7Js6nAe-8UbZbhpTCoP5gSBsODpAMfqnQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] userfaultfd: refuse to __mfill_atomic_pte() for
 unsupported VMAs
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Heechan Kang <gganji11@naver.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Michael Bommarito <michael.bommarito@gmail.com>, 
	Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Stat-Signature: g1xbyusdhbih595yggageuzsu1djjp66
X-Rspam-User: 
X-Rspamd-Queue-Id: 6A5D8180003
X-HE-Tag: 1779908955-892999
X-HE-Meta: U2FsdGVkX1+sSaY8wzQT/lMqFU7qXLm2mDKflLMX5F81MA7NXusGMeqp4sNOiKU5eUO+SGwGMxhW1kfeU30mTvnRZCufA4qu/inV+51smlBEq8s3Y9ij52fDsIZK9O6VJnjNgYvPHIY7967rYaBvOG9OvRQd9sbvmXavk4IYFVyk1mHR1jmD3D/nk4Y0TSy9Tj7UHlAhTIUx9W4LuMFCu1YS7l8GG3BXj3gI0FSgtVozxS6QWzsiGwlwIQ6LztR6c5ABuOxttvE0G/PjNKer2ZpXssN0v6tAAN1Z+Gb4SKbBfUlxXNdHJoHYZtJX/rOHJN3AHoV+Nn6fQ7FZQ5S+yyDuZKitqWbkG2drNyrLN7+MHADPFOJ7dagWIJais4N9ponp9KKG+Dp69TUWk/EPDB4J2vvfjuLHiHMqKNjVLL+eXJHIov3fEnj95DiKOYRytgQYfVMA6U/KkLb6ZG4kuPSapfHW06UcrSW+8HoyxsJUh/OVYAR0bizD/sda1Q7Uo1ospt656HDsJgP3E0+RQlLHwGdHWi2Tx/2qSPgu87fPPSuqKu9X+0ToKwK+m7mLygiSPinAPlzHMTm58n33Em89laZsDsYXklQjUzVA4O8cl8kgk9N6OVd12dv/Eptj6qBbEWWgdLN1bXPKWagf/pvqzZvQ0ft0pTzmAzboH90fdoTFVwycivGetYCbk8PmncQctjZtm/9tF/zzE9KprbBTfxTv6JJYU97bSyr4Yv0/p5ghhcPuJ0ESYs+tl6zxpuehepGHgJ3s9KjVJZQZMVXFiP/y4+gdvTvy5wNmFqoQNKIU9QQVMTJd+Q/vAlcGSoGTLhuOjhZ+ZTA5EqLO94iRKg/phbHedqgwr8rAjVSnP7H0xJ5aPK46PXQe03zbtAfvLBFb5SYM3JgaNpvVVdKeioZpq5QID+Ldl02VCtAAdODtNTUKXUtmUXPv1uGIp8rrrLiv8OwrN9NLH0b
 SyQWeQR2
 x4JnFW2UdIQvxHo+2PDqwrwmm58DCiRfGDfDudFzQp3cK/xaSb/jlDiLEYTlB7U2p+zuhMP+KQfdXcRE8E2czP4Q5o93C6gpGjePZSUd7NBxDFZUE19bTS17YyaFOkMoSc5Z7dhwNJ0ciZRTvy+tj+OXoxxZa7akAbjdLuPy7lOAThuraK/fU96hHFIDCjuBqse8qbSmL8g4veuuYkIURuRDdjW+L7be/bMyzrUIU9z4TjeIbcyfUMNv/pvLV4rSpGEzTZIxIq3SE09BmgL0rT27EWUFV9xayVHRSbdc0GSDmtivWcU6cQkbA3a+QQAo9G8lfvaotqSj9my3HNbh8252wD13yyzxtuqfqCb8re1nTxkqKMCiMYs3Pe6DFSEW0fLn+TrFyIwseWEuwt1QaCrtRgqJLJOfNiQccNrzqf9mGKrPUqnGBqfjwqy/2y1Ueb2FAqVhTxYriDAiPkY0BJGnfKw2cKvnqv4ivIEeRmfkb0Q5b3qRgzZP+tqbLfbOlZF7MWXZWHuqsGW3qZCLgEj28ngOFoBE1GGk/pPQ+bmgbHxawRLtjrdH9aDpGB9UtxrsM1tT3jj9xGQSya1d0NKdTyft05h4fzO3iNDfemN4zVoJjSY+yU5P4U7zRXaJP7v09u3PtOSMSNj8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

just chiming it

On Wed, 27 May 2026 at 19:48, Mike Rapoport <rppt@kernel.org> wrote:
>
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> __mfill_atomic_pte() unconditionally dereferences ops because there is an
> assumption that VMAs that can undergo mfill_* operations are vetted on
> registration and must have valid vm_uffd_ops.
>
> Add a guard against potential bugs and make sure __mfill_atomic_pte() bails
> out if ops is NULL.
>
> Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
> Fixes: ad9ac3081332 ("userfaultfd: introduce vm_uffd_ops->alloc_folio()")
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  mm/userfaultfd.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index e5d2fb3ce2c1..2872c71bbf36 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -552,6 +552,11 @@ static int __mfill_atomic_pte(struct mfill_state *state,
>         struct folio *folio;
>         int ret;
>
> +       if (!ops) {
> +               VM_WARN_ONCE(1, "UFFDIO_COPY for unsupported VMA");

nit: Is the warning message a bit too specific ? i.e. Also handle
MFILL_ATOMIC_ZEROPAGE case.


> +               return -EOPNOTSUPP;
> +       }
> +
>         folio = ops->alloc_folio(state->vma, state->dst_addr);
>         if (!folio)
>                 return -ENOMEM;
> --
> 2.53.0
>

Cheers.

