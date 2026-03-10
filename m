Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C98AFCC9DE
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 08:28:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44CA96B008A; Tue, 10 Mar 2026 04:28:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D0446B008C; Tue, 10 Mar 2026 04:28:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A8106B0092; Tue, 10 Mar 2026 04:28:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1833D6B008A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 04:28:06 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9700A59259
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:28:05 +0000 (UTC)
X-FDA: 84529475730.15.A7AEF9C
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8B20F180004
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:28:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NwpsOet1;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773131283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pR+Un0jjrWR0YKxwH/qCGpHCGkyCh8pRrvyLgeCNA5Y=;
	b=LRHs0RysNYA+ueOjj+U6u40iERnrdMhdwZrJ5/ujGNxbGwXAA8W16dGZMuleL0Yu1vHKnq
	uP0Ef92wRtWdmL8YRLjLswHJDol2vSCq/0XplqnwLaegGr6ps2Q8kVgLtJ8Dz7xWhusq5q
	1+HquJDnoQr/0LDhm1Axdx8ncNZViHI=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NwpsOet1;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773131283; a=rsa-sha256;
	cv=pass;
	b=p3VHU1YNlVL8rmY3/dOH4vVL2WpldS5vDbojCGeY7sbmJjVpfP07QQA5ME6McHM7qHj3zy
	TE7BJjVS6tAmSFvEnT6eb7NJKxzbiWFp/IaWUsxqraJvqEM6HnUHCoxGYgBNcgQNL4Y4ZI
	BFavL0rMZP2gRLJHMOIaW8Lg4vsqmz0=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-662e7450a8aso214064a12.0
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 01:28:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773131282; cv=none;
        d=google.com; s=arc-20240605;
        b=KXxg0h6d3mnlGxyPLfDtjcNYOzgfdcLeF8/+668rMJyvd1a2WzlAazItXuG3vjPp9l
         nQek4jv+Qz951pEgX6flHIotG8oQVNsXdpc+ShhJps26VLCAsHwHffy6IWHCWIeN/SI7
         vibMHMZ8+lo/60qoqlJc8XmNt0keQ6jy6aQdK2Vvwa5F4q5R93NOYcleGw4iQBJaSw2g
         9pXtzLPnv7WD7zgth948iMvjrEqsDdGOzGKVRIWbsOrlDxkeF7ulR3WsXfz8Lj8cNAVM
         Kf4ADaJM7WSGPW1Kcf4jSAg0C85iAa41wYQGkb8I8fASgYFEuJW2wAh2lnrO40VQb5hm
         av4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pR+Un0jjrWR0YKxwH/qCGpHCGkyCh8pRrvyLgeCNA5Y=;
        fh=2/NYFCcBHIOeWVcQHngp96DbpOrdmM9UVXekEOPk940=;
        b=ajiw8gNPgkSkJ5kuLxKY12UPG6jtFLMzZ2hrRmwKLVIOehZWcdlpG9/PP+v8agQJUu
         TtWa5gpyyxHYKJ8x6/2ZFnLz1CgTrgPltukrvU16OKEekiSTC0iZGZMdOnHeRrdH8JQM
         yFVr7lXUxQsUkqPZa+ZUWNaj3ZEMSzvlX25lP9miDfz/yJ1HqnmpZXxw+QLLYIgkruJ1
         mphKw0K+qyeD1L8pHDluZQcm5BwmdAQroJmH2nt3132G35oOFwMCmuDSMkbGbCD3B6xt
         VXsSYn0Vlg5lB12bgxbjCp52i/cprVlPX0CZ0E4p+bXah3Fk7zdR8/1XuZbYIdA5XW7k
         GPJA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773131282; x=1773736082; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pR+Un0jjrWR0YKxwH/qCGpHCGkyCh8pRrvyLgeCNA5Y=;
        b=NwpsOet1R8DWf6jBzjXrwzMAvnflgoaIr8saFJKF6bDTjSjL8o8DhW4FaLLLJOPhqR
         joJGXtr/sB7yFXl88KEL1N7klyPkpIWeRx2h2Ch8WpApJHId9Pf8hYW2BQqodDANu/0E
         9N2ONE5SoFPWDi5ETwipw+eLK8dDHpVFVh5f+LBbHw/V2vRDEOggECraK9cLLwTDAt0H
         XVpdTZ1IDD6u3/WtWOPSQgjkxrhVn9C+RczlfBYObJZO60UIZkXUbyTgw0EUebIYceve
         xTm1pagUomP4amtZ2h0twXrR5YJ/Z9Sb6SGdBfFSwreJZADusFllw/92z7StX5NxrUEF
         7cHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773131282; x=1773736082;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pR+Un0jjrWR0YKxwH/qCGpHCGkyCh8pRrvyLgeCNA5Y=;
        b=kSxPWg+kBNv5scrTSWkLVwUAbD103GHFu7bnRo7TfTzDArV6dk4B8q83jxpGqMWiDD
         3t8O/Q0JxG7B3BAlDifSm8nV1iZN8AGpE10FZYOp/4/f5H4UGR7vw1bI1/gAozCyrCyr
         x6NsIRZPNC1nBaLn9aqOG1Hnh+Nl8s1nnxt7T771uZGm3cAGsj3+eq/4UjHKXbkm8RPU
         +7yUSBVwnHqyuv+beyQLAid3JhqSNFfGUMBeSvCwl48SRs5Obf4rbaPt+rYQ4wplL8b7
         LiMjnhzQRR8fWLLQzgJ4McPFqbMnJWKZ92hVB8138vudcFaTkYqTHozf3ZEmVmBut4e6
         T1gw==
X-Forwarded-Encrypted: i=1; AJvYcCXBd1DKdll04plBcmugcuW99RdCDGnO2gSWTNZc+5z8AfYLaIXMK2Y8InTrfbPKabIxcM9V4Zb7TA==@kvack.org
X-Gm-Message-State: AOJu0YwyTnynS+HcugyGl5tMsMLXKxLKKaLkTt7rBldkkSl0c76npr/p
	q461W4oCFSE/IyOjd1bwE8TQjsZVAP1neAHDBHG1bmbeq/00yFOlD+UD/qq6LnyQdblTotDfrgG
	+R3/EuHOsS6dJuLmKjmB1SlsPTZ/X/4E=
X-Gm-Gg: ATEYQzwNIzzFjIRNwdJNJvFlt4AOyinUMSXIxoB/8EZHxY6hkgW6XL+9Xxxz0WryBQt
	lrCv/v00tKsJTNgo7+28NKdHmh0fwr7NHJ687pBjY80saiGkpgn5IIcYKKYEhcbWAz525FnCbxB
	DHQ+fsjAwDHMyvYV5AsgZQkOrz/6Pi3WqgzIX9Is6Io6Bd5AJsQK6Avxdn3Cd5NjwW0HXLnjroB
	E/1svtqjDLjBr3mkUrYrNGBydAw3eFVwWpC32668eG1WusTMyVCPSqXJZ0SUhkIKabIVEWfrlYk
	OYA5jrqUGbTYb9d20p2uXYRi6mW+a4cuifn5BpTD
X-Received: by 2002:a17:906:6a13:b0:b96:e0b1:ccf4 with SMTP id
 a640c23a62f3a-b96e0b1e511mr459974366b.47.1773131281332; Tue, 10 Mar 2026
 01:28:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260310073013.4069309-1-dev.jain@arm.com> <20260310073013.4069309-7-dev.jain@arm.com>
In-Reply-To: <20260310073013.4069309-7-dev.jain@arm.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 10 Mar 2026 16:27:25 +0800
X-Gm-Features: AaiRm50yuweXIx2i1T1Blimj5C_fGmgUZvolZRliVqIDmqAb0COvj0jCc5QmXDo
Message-ID: <CAMgjq7A1QX2s52aQKQcg0vFAK2t2Xsh8S0THdUC9t9r=DEUQrw@mail.gmail.com>
Subject: Re: [PATCH 6/9] mm/swapfile: Make folio_dup_swap batchable
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com, 
	david@kernel.org, hughd@google.com, chrisl@kernel.org, weixugc@google.com, 
	ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, 
	jannh@google.com, pfalcato@suse.de, baolin.wang@linux.alibaba.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, 
	baohua@kernel.org, youngjun.park@lge.com, ziy@nvidia.com, kas@kernel.org, 
	willy@infradead.org, yuzhao@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 34w6rucchi4f9z8yqifqn49x9inau5wn
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 8B20F180004
X-HE-Tag: 1773131283-551200
X-HE-Meta: U2FsdGVkX185llYN3e3EQRpaYOe1bdFDibue6X4WkWWRTB8/HUnxyk9UNYHOJLonkRcozieX/DfRAQz3BYLrap+IDaqVz/GEXVuL+aHnu+u2HhpTVXTiObxEFBmTLWZFiHg5cldPmEc/xfwPlmuo+cZU9dF+lk6+NbuTrYkpZmcz5aj9xgg+UBSv6936MjyfJ5/VgazfWbrzqVCLJz+CwSs1jn91NnZKTqMc7YvojVxaeYNWrLbiB3WUB+L6VKskQh1s/0LFdqqPzevT8c3huVZ6AH71M5AifxaecMLAqZ+IB2n8wVeh0A+a8AhDVhNDg709dqRtZD3Wobl1PCWu0Kg1HXLK36RBClW3t3EnUTLTrj/YiloxWYIuLbzA62aEarEEbBcJF1q0XeRxiPNeBDZICpbnxty+fdNyUF67g95iG3gMr0+tqAoTI4TFAKclIpdbxHrOnEzKaCzWQIOY13J5F3nZZ4iPTLife0HLntdW6666/gJl89dcp6BfCcLVNDE+lAbYkoFTKJAhKN7lZMASI7WPr7vXyihsrppmeSL7dXeqXePUN8Jegqn6y+3KA9gAYXKWMyB5KgS5QdYtYQj3Fy621KNcnX4/E2UwFHZ3/K5xnb3l6iyGX5LvD1xucjsY/1lsb+dUx/DyJ69L6dZNcBucXGygsoFzNNFejIX/+FzNmHFXqmrJi1nHntELKm9FstQ+1743NgH0QVBv2mO+sh7qyDKZueWHPrSyMCbkTkKh8Vsho8/Ky2Zim2xSoCsv1YyCSh/XmYx98uAQigCVLuZ3EXGeDW1w6XzusO3tR70QDaixMC7gNUNSycn5YEQS4fmEcSosynkEtoFSzWZ6SX/jUI8cn8w9kVXXitC8khfEns/P4ipZY1o2DAErqpqAcmqhLPRbSjdsF9GgvEqUIftsZ7f66nLzPrqR6Iuw11Gw5NnxM0F7qhQCPhJmESd5mmvzLrcjRHc6Ii4
 VqPP+T2n
 i5+IO3tEPgYMj1yis9sDXFKtiYs9qLQLEP0XDYbw1d4Y3AQ4pUj0Ew71BeaqvS+Jvp/4htlmV3YFsE8xzBA5yjuaT1ETHQtjRQXuZYsw3RBUiGxHmwLJh7rjeH8ImsMVYFCQzdozSk0Se6LvA/B0zPRHaAkwTdR0i8oA8XM5orfEKi0o+3kRzJHbQVMq99ggwA5OF9mXRnPaeP4GjWH2Rz8OC33ucFXjg66HpJeYP9E6eJ8lf960MR6DuwL3tBRLf5Jx/b9sWh+UJRRcbTJL4Pn2jedcu/s5MhvKPqfKTVH+fYSv2EjdaHmKT9cGcP7kzZ1reou/5WdwvSlRsyfOLw4d4uUQb+S1xLQODCuHiOEAYDLJsmgVEmeQV8AAl9yzIMmeXYJXDe+vAkJIoszOgFnzO0n4CALCoDr0A+1gqKK4uA+UluufhC+HHj8AfdW6VImbLwK69HZx+VJKOFXq6er2URck3ZlFuKiqwo5pUOPmQcgP330rc3sGnrwUd12OezHmV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 3:36=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
> Teach folio_dup_swap to handle a batch of consecutive pages. Note that
> folio_dup_swap already can handle a subset of this: nr_pages =3D=3D 1 and
> nr_pages =3D=3D folio_nr_pages(folio). Generalize this to any nr_pages.

Thanks a lot for doing this. I was thinking it's about time we respin
the batch unmapping of anon folios idea. Barry tried that before with
an RFC, and now batching from swap side is easier, so some parts can
be done cleaner.

> Currently we have a not-so-nice logic of passing in subpage =3D=3D NULL i=
f
> we mean to exercise the logic on the entire folio, and subpage !=3D NULL =
if
> we want to exercise the logic on only that subpage. Remove this
> indirection, and explicitly pass subpage !=3D NULL, and the number of
> pages required.

I was hoping most callers will just use the whole folio, but after
checking your code, yeah, using explicit subpage and nr does fit the
other parts better.

> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 915bc93964dbd..eaf61ae6c3817 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1738,7 +1738,8 @@ int folio_alloc_swap(struct folio *folio)
>  /**
>   * folio_dup_swap() - Increase swap count of swap entries of a folio.
>   * @folio: folio with swap entries bounded.
> - * @subpage: if not NULL, only increase the swap count of this subpage.
> + * @subpage: Increase the swap count of this subpage till nr number of
> + * pages forward.

The new nr_pages parameter isn't documented in the kernel-doc comment?

