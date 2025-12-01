Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43E36D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 10:40:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A694C6B0012; Mon,  1 Dec 2025 05:40:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A19FE6B0089; Mon,  1 Dec 2025 05:40:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 909506B0092; Mon,  1 Dec 2025 05:40:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 79CE96B0012
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 05:40:43 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 564DD16010B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 10:40:43 +0000 (UTC)
X-FDA: 84170558766.25.CC580B9
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6A9E218000C
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 10:40:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="T12cL/wG";
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764585641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lw1Wj8imY2xqpphMlisdmGdmHKrrobsZEQcnSuiN6Q0=;
	b=F7lLAXoK0lYN4OPQdrWNycPO7ul/ofwljNMevo65HswnvvdDX4UqiBaMEGf77cj3/H1sXZ
	ph7jbkCMLofTD0i3ngzb5U55XBTSCpYkVBXKG+zzhj+nifj5lgXvMcxGEk417mz0gtWCNU
	ErgY3X259TmIaAyD5T3OU64HRMincr8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764585641; a=rsa-sha256;
	cv=none;
	b=qvT2NYVXn0BZWGF/hi0YcYCg/Itxul0xWdqdgR+GqazjmwmDBtpxuHt6ZQQpkZbyhCltDJ
	xbZdmsWADsNFRwYlSKJdebeIOcS3wZRhz0kSi8M3BvtiQrbM3HMxSHgF9Y/Hv0WxmfBEvZ
	s7ha9dtwqJ6Mvf8b27zVRfezvGtAqxk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="T12cL/wG";
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-640aaa89697so5776239a12.3
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 02:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764585640; x=1765190440; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lw1Wj8imY2xqpphMlisdmGdmHKrrobsZEQcnSuiN6Q0=;
        b=T12cL/wG52daFoNyO2285eZUlQla4xUU+VCSngtvBFcLQJVoAqkohZT/xeREJ9Y0Xe
         cUVQb1FOEg8QD7U+0wtF/uJhDQyV0J+VZCHPPskawpfGw0i/stq5yvFF8Mno2+FimDay
         Cge/aMMRzDKkM2EIzuMiq/j1abj5i+r0a4O1mF1t6c2B7179ysQE5i+xMeBVvhcZTt+X
         bKsrcWW9xepFMBoeQ45EpwouCdbdAwccRZFEA2xiSDqrWHO/8xoWvoocLPQYxqiSpfFr
         7fmdRxgloYF0SgbAY9/SFx2qrF0H1xgOduj645HPlPuqDy8f4wLkn4qqVSYBCtHFeyJA
         jGxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764585640; x=1765190440;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lw1Wj8imY2xqpphMlisdmGdmHKrrobsZEQcnSuiN6Q0=;
        b=YiURmhg8bHc5NOEKREg99FIDjLz2CMYQcsER5Et4N4dvpnd0Lghf6AzSZi0IGzgARf
         IHb/IrtOVizPscSsW2Ain5rFnPk2kGRUyOEfRSrCQQqT1A9sFUt+6rFhmHJJuTjuh25k
         vqiqkwlIkzKT4DKgziCU6BG+YMLzf4QQ/E8Oazs5nMF45nfXle5+ZuQDpT0b78kHV7xR
         2Oik7cqJcM97mUyKR1eCml51My89tBJhQoxfu7Ex+rs1lmxrbZmf6OUndr+u6LaDwTsW
         1Uq2xfX3kqn/fqJEb9PCE8YZFCBcjswW+3wBPBPvmR9Us/o24pk8QsJjicYPH1Jy7byj
         hh9g==
X-Forwarded-Encrypted: i=1; AJvYcCVVsLHBKt3cbJ9VUQeOgey+ru3ZXH1MxWUgvLHtivoWX2ft4qJKl/TOFEn2JJYx3bWir+JKbUi3cw==@kvack.org
X-Gm-Message-State: AOJu0Yw+6kHxL1ihPzV2QkTLX6BB+X4wblqX+ci1kpBjAvjyq7irShrD
	QAqfO0ejaF4NgeI+r3E5WFPKBPwkyeWamq6eEO3Cl6KWlrVvoeLqMjD1n/rD8dDAqv/dLg0WDK2
	JpRP99/y9OiL14FMZT8pD6vVRmzj48w4=
X-Gm-Gg: ASbGncvZof+kww35UTkLa1vWkPM0zmDq2slEfFoMJvIZfRiK/YPq7ELM9JF7LPol1O0
	fhFvjzoJPJ+jCSyJjLCbMlYF5oU85d9aNNM0IWbPiy72+rwcjS6tktHsCHHxk/xB7aFivi1WSdG
	Z6uuJ2+tarfUZjQNL0Q/NwL+ke2Z+OTxDAXr4i1GTQRJ2M33pDbMe1Jy32X8SJg0fI+C1PCiVfu
	Syapo7mLzhG2oYbstOb/gUsEpq7ju7NBkKt4VT1zfjpefMsqyMVytdYt69j98ABT6ESCLcllf92
	Lr/14Hovt7ACKxgGug1j7lNjLKdjX3EmaVRkHg==
X-Google-Smtp-Source: AGHT+IGCd2jLZ7RWXEuJBG/8+wQgZ6chSdTTlYuoZS3w361zhPChIuEPqPC62DzuHYO5VRoK2v+SoKWD3b8t3mhijIw=
X-Received: by 2002:a05:6402:5188:b0:647:72a2:771 with SMTP id
 4fb4d7f45d1cf-64772a20a53mr3626804a12.22.1764585639508; Mon, 01 Dec 2025
 02:40:39 -0800 (PST)
MIME-Version: 1.0
References: <20251201093741.730884-1-kartikey406@gmail.com>
In-Reply-To: <20251201093741.730884-1-kartikey406@gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 1 Dec 2025 18:40:03 +0800
X-Gm-Features: AWmQ_bllUTrdQgKUWU6S4w5l9orZb_OcDiYaz9EiOcuBeib3QuUUufu70N_tPOM
Message-ID: <CAMgjq7DLkbfXczQvT5on_25PbJOGT1iOqteuXYsXEzFL6CTbTg@mail.gmail.com>
Subject: Re: [PATCH] mm/swapfile: validate swap offset in unuse_pte_range()
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, YoungJun Park <youngjun.park@lge.com>, 
	syzbot+d7bc9ec4a100437aa7a2@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6A9E218000C
X-Stat-Signature: ki9bd9pi15sow6oes57pz83k1nk5zbb1
X-HE-Tag: 1764585641-412005
X-HE-Meta: U2FsdGVkX1/4EOr/zSU3xw0m+T52N0gb1tlVUm3U5TmCkplsX8pHx8VwHe1R8cfGj02FeG6Szo0VCTrfSEwhDWskZhCdMqdiGWHSdEn5K1FeN4oNpMhx18wkcJuZ12yFiLNPSuoZitj7A/FCXbxW6kZscLeylNMids1lYPMaqTcfxrV1xrtVgC4ooA83s3FbPVpBLgQHBzQjP7rT34vSZGsfz5qpYqvRvfQHRhdH50ekhX/cagFsleN/v+4rmq9wMZeOYvGff0LdA6BGDx5m0BvfyKd8pACne1crLiC2nrhUwNliBz2wN6nqKFZgi88LX09LA5Lc3FAEBDxW5FO6Ac1DQPJ4HtBAM2eKKa1B3ChgHrT+ZE6uUSaSoRPtyAJ2Y+4Wv0BQdsP2YZaYgh9Uh4/ujHRNyrhRWfd5KrbpwjyvAnx3hdSUeF/Jgrc9o/CdYpO84Gp09k9ZhqyyeBHXneFaS4LTzP7RnTEG/fLY47TCZZTl2qJNNj85nHQ4WhUAhzX6v4Z8o0SNoR78lzBIlzn+gePaEbYuDI0b7Q2RfzKQnJkOuCiRhW6jeUwirOzFpU7raS5ycwYfin3DrRcsbcfarYxRe5pn0b2sYC5JHzpLSf36iscR5GCk9i6cjO/R7SBz32MB4dLFjeLuhnagIwfmVe3sMJ6bpQT9dqKM+oAVuARi+Z6/QPlOE/ssAQ7tQPi0LFG3x9hBXODP23qEpDEVm05ifDjLPKGPaVwnk/hnjx1/24Z1s1O6E6+WyogivP4ZWEix5SymQkL10kcQAvnTgpPvhSLYvPvmcd7tC1sMoQij97Yg5ULLXsc7lBnYAnftInj2XZF28muRKSnm7QvVIlk1l7iRftzsI0N95FewwP1F2vaoYJKPOzalG64/o6fkOSgtDMe6/oIqtoDuJhkZdjOI5SVg4XbnvdsUwcSWd73t9Xfau772FM47a1hBHYiObKuIKJLMvz0Xkxr
 DL7uogNz
 OrBx2nxFAMuHI/69ksYJb8ya/3N+ZnEi0aoidOkMv+R8XJwC17xnA+RbVSD836RNDgvQKSZo1m+fmaEP5Yvg8gQytqwJ0AKck4QoARdn0SicEztQUWgPIQih3+H+ZJTsBo8zFaH1k/ccbJ1FaPPXkb3H0wcxgLwIJ/9m7+eFZ+KZyfeBHTIFcy8ibC10P7Q+gneySZXw5Ny1LcqVy6eVMA0ma6BiwR140Gt3wyd5ypByWvJ1AYR4fyKfMd9HyK+ZhGVxRQjrnJFH9kk+Dg+uadnT/fEpKzrUepKJqm+Zx0Qnz53nijlK+GQF/KdMQ6bX0qolaahsIUIusUEDHNO6dzddDwvatvmhxmT+8fShBS3iS62gMEueLS1htCRilrtokRrJI9RKVAi2isfYhtx891/jabpl6o15uiGA+4tEKAwVNpYvPFzPd4Itj4TJSRo9fVLbU+K9FXEGKJaUKA6SVDIgx45svQ8MPD7GH4vzCHw7HUy8yZZ1Ek6zsnG/MbVX0CBR70oyq96SUMZV9qgiqXZH5CkgPp6RSTf7w9M08aWqTJSBBLrZNSMvAwE4uywbXf5jI346LVRvctochlUQ69nbKEfejo30TsJhf4/sobzjeBK4Zkzz1hn7WPT5XoFWyoyy+qn3zQyUxfhLyvRh65rXowddNm3sxmkAb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 1, 2025 at 5:39=E2=80=AFPM Deepanshu Kartikey <kartikey406@gmai=
l.com> wrote:
>
> syzbot reported a WARNING in __swap_offset_to_cluster() triggered by
> an invalid swap offset during swapoff:
>
>   WARNING: CPU: 0 PID: 9861 at mm/swap.h:87 swap_cache_get_folio+0x186/0x=
200
>
> The issue occurs because unuse_pte_range() extracts a swap entry from
> a PTE and uses the offset without validating it is within bounds of
> the swap area.
>
> While the existing swp_type() check filters entries for other swap
> areas, it cannot catch cases where the type bits are valid but the
> offset is corrupted or stale - for example, due to a race condition
> during PTE updates or memory corruption.
>
> Add validation to ensure offset < si->max before using the swap entry.
>
> Reported-by: syzbot+d7bc9ec4a100437aa7a2@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dd7bc9ec4a100437aa7a2

Thanks for posting a fix!

But it seems the report is no longer triggering after the softleaf v3
change right?

Checking the syzbot link, last reproduce was 11/11, and my analyze was
posted here:
https://lore.kernel.org/all/CAMgjq7B=3DOizLoqKca3RjeV0h3p0GQ4uen+gDo3=3DWdA=
xQ1gfxnw@mail.gmail.com/

Then we have soft leaf v3 merged, and the warning is gone.

Your analyze:
> for example, due to a race condition
> during PTE updates or memory corruption.

What kind of race will lead to a invalid swap entry in the page table?
During swapoff no one can allocate any swap entry from this swap
device, and the swap type can't be used by other swap devices, so any
swap entry still in the page table must be a valid swap entry that was
allocated from this swap device before swapoff starts. And we are not
releasing the swap_map or si->cluster_info until swapoff is done, seem
no risk of OOB or UAF.

Memory corruption may cause it indeed, but memory corruption can also
cause failures in too many ways.

I'm not against a sanity check like this though, just want to double
check before we process.

> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
>  mm/swapfile.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 46d2008e4b99..fdf358df7116 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2277,6 +2277,8 @@ static int unuse_pte_range(struct vm_area_struct *v=
ma, pmd_t *pmd,
>                         continue;
>
>                 offset =3D swp_offset(entry);
> +               if (offset >=3D si->max)
> +                       continue;
>                 pte_unmap(pte);
>                 pte =3D NULL;
>
> --
> 2.43.0
>
>

