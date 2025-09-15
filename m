Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4420CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 20:25:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30B398E0005; Mon, 15 Sep 2025 16:25:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E2A18E0001; Mon, 15 Sep 2025 16:25:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21FF78E0005; Mon, 15 Sep 2025 16:25:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 11DDF8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:25:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BB0751406EC
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:25:15 +0000 (UTC)
X-FDA: 83892614190.24.13F7764
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id E5D3414000C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:25:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MxYKNaNO;
	spf=pass (imf09.hostedemail.com: domain of jthoughton@google.com designates 209.85.219.179 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757967913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y3hcVSwY/ZYQp84NSknfw1iNNyJknyUYvwVYuTI+c0Y=;
	b=G4PpaJrWMkLKVRb8UoTwV0VBRUEgNCogsU4JDp5qrZPoaEOKHNeeY5th2PxtFwc+e+VvV6
	pJ7TIXCCqEPSQgLz1Jb/I7AI5zcQTFqvCd6UcmIYO0aMmUWjzooT+KR2noeo6z5Oe8c00S
	KxZvr+rJMLAdqACvyOUTI8R1YUjeqTM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757967913; a=rsa-sha256;
	cv=none;
	b=DU9uv5hbD7qFe6XUwzAfe9Ej3yhdSWIRLXEffk3anWBL08fCd8rxodqj74cO577VVHO4e/
	qQKUfB2z3YP/zuVI9BkklFwhn8YdfzmyshZhxpkUzyQGNwz2ZG6QMJl1QsHxqlCPuQZHMT
	T+2U9pJhdkS0fdwqBROuEcTsE6cPuxY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MxYKNaNO;
	spf=pass (imf09.hostedemail.com: domain of jthoughton@google.com designates 209.85.219.179 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-ea402199de1so2206282276.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757967913; x=1758572713; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y3hcVSwY/ZYQp84NSknfw1iNNyJknyUYvwVYuTI+c0Y=;
        b=MxYKNaNO9LDirfnRMsaMjR8lv329RmpafeitJ5r5ipUdW0c6D+p16UzmwxHFzVcAF7
         i/Fs5Edp3U9KfQhBTuHMozHvXC+2p5+uqX7O47sjjLpR3xR7LEA/Xs3GdlCTi/dO91/0
         SFem5WeT+ug+K7Q1a36S6+TFlRlPuhIAJLn018HFKDcZMn7/xnNeQcZt1zafF1BMGnh0
         ClIxXj9dFfcXr1FnBxCV7jFJX66FyEfysYibsW1W/oA6OSQM8Hg7fepoNa4L8x+i0aEr
         PfeyrZi6qXp0n9wi6Or/tHPDDM4ZpHXtolpj8JH2sjONgBuysIPcrwGFL7DP27mciQ1e
         iC3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757967913; x=1758572713;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y3hcVSwY/ZYQp84NSknfw1iNNyJknyUYvwVYuTI+c0Y=;
        b=YWiTjRMlsiN4gL54IAcjUrR7ocZFu3wSnh4V1Tp0qcBi6r7pbOTusoxD+c4Lf5qYFd
         BEA8UhLOdTy3Vc+rnsmaLZigGW1a2IWW70jLXabQo0qlbwsx2yh/7yU+rm00Eczx/yZU
         5AL4+ZyLXL9EhgtwPRgNjY4Ag9yKUqNTaW0owbpULWx3mkk175Y15JHFoR+x+uXJLrOg
         ig2gZCcDHEdIRUj8rmdekeCN+GOs1blp0YIChr5sgLnPSyxYzw6D2q8GFdIBiwn5rvNI
         VlEEV+ORPMiTM0gEE1m4GP78+655PeLaeFcOkwaQOxG8Tpnn6LLT/SrgtidlEkdT23lP
         y1qw==
X-Forwarded-Encrypted: i=1; AJvYcCWq3flm5zZ45yEyYdLxZ+8UACV1tJbNUNZrHj/saSPMk180dKjU+W9AEaTIoMW3lu0bzcCBYAnMuQ==@kvack.org
X-Gm-Message-State: AOJu0YwIbCsU6vDFY2UVWpaACORGK/J5G3PxPEFI3O3bV+Wd+R4nU7rP
	kVd9D3bRePH2JHW3gjBQJ8hX6pDRU7gOpRMgsepl2X74krjDkKk+xU/Y3ii8AQB+q0QREXXsl84
	VNJ7fDZG/QHtkk4ViDbCGhFVdvyJd8HvgHtXQDMz+
X-Gm-Gg: ASbGncusRK0CqTvPPItzn328GOKpLImoIzur08u6MEA222pjkwIsNKFbtrAuspy4n94
	jMMSTaYXxc547VXf6ZGXw6DMZnpZFNAapKP8aU+nye5bRW6ST7Arm++qLSJhyH8HqGm3b3qqctV
	E1nEx9TL7Bk5b18LttWY+ucP0Ds3VWaBtBfkmyUmygaqlUE7oefGrd4UFLXWTui+Pr0THOFzQpa
	M5+fVx3DITMxnFxRCgKtKijzFl5d3ohG7D1IInxoB3rfqplhvfah68=
X-Google-Smtp-Source: AGHT+IHkOV62P0jPFZnLZEHqdbmDACy4qPrZ0IMkErNiLxlV52ASxbxa+Q5LSgy8813YMZABUuuTgz2gaST21fgyALs=
X-Received: by 2002:a05:6902:2b0f:b0:e95:3811:12ce with SMTP id
 3f1490d57ef6-ea3ca6db1a3mr15061855276.14.1757967912632; Mon, 15 Sep 2025
 13:25:12 -0700 (PDT)
MIME-Version: 1.0
References: <1757967196.153116687@apps.rackspace.com>
In-Reply-To: <1757967196.153116687@apps.rackspace.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 15 Sep 2025 13:24:36 -0700
X-Gm-Features: Ac12FXwJx8tv0l_ErS6--mD2BoBnj8zOWwLKUmypsynLjtI_PNDA6a52wKH4Yzc
Message-ID: <CADrL8HWGcj1oANGY=qAzpYi_-E-Xbi=L28Bmyyf8H7auVix=QQ@mail.gmail.com>
Subject: Re: PROBLEM: userfaultfd REGISTER minor mode on MAP_PRIVATE range fails
To: "David P. Reed" <dpreed@deepplum.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Peter Xu <peterx@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: npwm7hywse8uzuonqejhs46zy4tdie1b
X-Rspam-User: 
X-Rspamd-Queue-Id: E5D3414000C
X-Rspamd-Server: rspam10
X-HE-Tag: 1757967913-915742
X-HE-Meta: U2FsdGVkX18lPLsJLrsx+5I64UhNxhjiKSjdl8oP7oIDDeCdzH7+wYWbVLjByCTjSyc82RH8hBchbq1rCMwEgx91BRYS0YqtocfvCfM5SbB/S/5hPAg6WHbGR61PhCYnGarAP30wqke+oe83YQf1J8ZERa7ZeW4S3YZxDv89cypV4SfjRreAar19U1bUxk1m/4aB0NBxbdN+dra8Y2PCEv5oqfiBJwtvjfT6fXMwXp60T68UMcc97CRjzEMG2uoaUiB0s/CYWs5oci0zGnbp4afYGaIR80eB30e6Vi8DRkCVYJJuU2qDCVbO9UluG7Y1N5HLiPruHKUlKw0ven0AQxeM2+R3LGmLF20CbTf/lAmGjGwE7jzv8D6apg7bCsXMZQpSoILpWWJYerqaA/1PmBy34yN+XmDVKVs9BVmaDQkh83SWh+k6XiiciBHSaWmaeZRcTDicCTtkgAi5Auw3TEHRqTR/MXXutbkAwLntd+hlkoEE3iA+3q0XLrrbANqFfvZ5JUzrhVEPvQjKZafib4lvK9tBS+NUOLA3UW2GPkn+zLkOeMrHuyZzGmAZdc4SpFzbq60k6QPvaymx+Dzp9ad8CBp52hk6MDXf4InKLwNacAEhzHW4JKKI4zjQLaqGE1MBHEZM5cSppcd5DuXrYFfvPktWua+f+zVvL1k2cBqBofpDSFjccOTxxsQ5Vy1fdQWVMZ+M1zAlYDPj7r3kkNhPSF7838M+T8v829gGn5Q7Z06v4iY6Z6DUsl9d3wZMVK7Wy9lxZ15TbmA7sU4Hndktt5Nx/cHoclFco5AdSTgL2AKgd9EIDGybnkI+uI5x7bVSOOLSIlBvtqxlt68KYDHtsQRM2fGoJG7pFghvxyxFJCai79YNaDChUzzkr4zkKkr74vC9nDlP2sjCwKJvtPF97WkNat9ApspQvZ9aoKZ+w4I7vlQspbHuxLjXiR7YHOUFM/2PSDAlwcMl3Sm
 cb5ifLB6
 cArxERG8ehuchBk/Asd8EAsF9aGEBUnYKIzSAlC/WPfEHlaEMkcVHpB0F596+fDOO/vUY12dKWRKC3YXSQ4gIvEcZrKlIOHXdQVgaTplGONduUUg+Rlph/6hNfBTfS6+uDxN4zCvaEvnzBye1CXq9hRqla1iW/VE3HXVbFUSyotceT8ARqvY5HoMaV1GYWNXuA/57HU6SwApQ6pX45pf7BMRlu5OUT6pfN3bhEbXMpJT063CVynqjf1+cxoqnwfLFpPKVa6nj/0K/P9AXoHDLNjWapRmKSJXjFZzNKgKxjIi7jDk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 1:13=E2=80=AFPM David P. Reed <dpreed@deepplum.com>=
 wrote:
>
>
> [1.] One line summary of the problem: userfaultfd REGISTER minor mode on =
MAP_PRIVATE fails
> [2.] Full description of the problem/report:
> The userfaultfd man page and the kernel docs seem to indicate that an are=
a mapped
> MAP_PRIVATE|MAP_ANONYMOUS can be registered to handle MINOR page faults o=
n regular pages.
> However, testing showed that not to work. MAP_SHARED does allow registrat=
ion for MINOR
> page fault events, though.
> Either the documentation or the code should be fixed, IMO. Now reading th=
e code that rejects
> this case in the kernel source, the test in vma_can_userfault() that reje=
cts this is this
> line:
>         if ((vm_flags & VM_UFFD_MINOR) &&
>             (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma)))
>                 return false;
> which probably should include !vma_is_anonymous(vma).
>
> Or maybe the COW that might happen if the program were forked is somethin=
g that can't be handled, which seems odd.

UFFDIO_CONTINUE, the resolution ioctl for userfaultfd minor faults,
doesn't have defined semantics for MAP_PRIVATE mappings. The
documentation is unclear that MAP_PRIVATE + userfaultfd minor faults
is invalid, but this is intentional behavior.

What would you like UFFDIO_CONTINUE on MAP_PRIVATE to do? Should it
populate a read-only PTE? Should it do CoW and populate a writable
PTE? I'm curious to hear more about your use case (and why UFFDIO_COPY
doesn't do what you want).

