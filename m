Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20042CCFA04
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 06:05:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80D028E0007; Wed,  5 Nov 2025 01:05:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EB828E0002; Wed,  5 Nov 2025 01:05:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 721D58E0007; Wed,  5 Nov 2025 01:05:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 60F238E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 01:05:02 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E9A181601C6
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 06:05:01 +0000 (UTC)
X-FDA: 84075515202.12.815FB04
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id EBE9940009
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 06:04:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iCF1Vtct;
	spf=pass (imf04.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762322700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R+vZkqzUXWYtHnpeP/k+Z0CU35hYTztl88Oxvz+vJuQ=;
	b=tzvBK/4/ANVTk9iwiCP5EUuMKu/8lN36bmSaJWJ6mS4YmgvxPQpYgTIDDwDQwO0F3TUx9J
	rK4DKnHzPLmupZ3B4PqiXR7OHk4W79jzzmhQpy11zZTr31MBb+4WAeMPDaOjFmh7JQBk4A
	D2zcVqqryqZYhtxTMTnC/agjZSNtrDw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iCF1Vtct;
	spf=pass (imf04.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762322700; a=rsa-sha256;
	cv=none;
	b=XHistwrhCoCuJbZAh5cr52I5AxGof6UAYXy9+Dvmrx7lsWHBc/4QROA++0Xo+XgOpeHQfn
	D6oqZGFXUZHP/8PU/GgsuVBB85x8OcRzCd1FonnDAdC3dI2yGgT3juVI8KhPFCMU1mtO2/
	Z6hFrzYV+Dq8oQlsrTlB1lWhMiCXDbc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A85A9437CF
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 06:04:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C11C116B1
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 06:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762322698;
	bh=qRgNido8bfZD7nMso/A3h7JMhBGZS91Mw3fIybZMRmw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=iCF1Vtctc0yn5NV1dP8oUdao7FXc2iy+M4bp89sQLJa1z+e7kouQp6OcfPiCPlRmo
	 QIhCPxq9bwI1/ptnhCmJL05AlLnuit7xYXukQCyl5u0jAvg1YiGnknD1eD1Kuftlie
	 3x8rnjKdHTaJOERVNqq6LUO3YiVdgqMJzEg1Es+S8g9XLUJ8u7TgGGRYHk/vldBicV
	 bf/thobxOmE8DKILY1AXEbK9po+k3PAWGJpLlIAhPJ8NL8MXogQanNNP8AlPuPFoqY
	 rW/ELLA5AfR1EujT0S3+WaLj4ffsrvni8HXd9Tah9qKnVbgyiD0WL8FfvA6yLJpJSm
	 OlQQJAdCbjOtA==
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-7815092cd0bso83922477b3.2
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 22:04:58 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVV9osgfBI8m5y7YwFqr3zvG++mItMXs/0Nonq+lRyt+rrjxuGim8oLaSKREaYeNTloHJHe36rv0g==@kvack.org
X-Gm-Message-State: AOJu0YyfQl7HwEXBxMTm5V51sp2zIqWjY0ia+JZD8+tLEA4jedQhugcZ
	LzG3zt6DR8IgULfu7HvFb+6Yp2pzu9aw3EAOXUYBKO3e3eU+NBj7K9PNQfIL+JwuP3SiGAbL3vm
	Tl7LKLisaKtDgY9/NGtGe0fsY3EqPHYOPrfXS3ulzgQ==
X-Google-Smtp-Source: AGHT+IG8dz3srAIRa1tKabx/AJFYse+7OvqF5RE7dk/QbfEj6NpQPFYcvgaRADoRNca0pb71n/sMJYoiQv8Hhs1ToVM=
X-Received: by 2002:a05:690c:a0aa:20b0:786:7f50:f41 with SMTP id
 00721157ae682-786a413a3f9mr32343147b3.22.1762322697856; Tue, 04 Nov 2025
 22:04:57 -0800 (PST)
MIME-Version: 1.0
References: <20251031065011.40863-1-youngjun.park@lge.com> <20251031065011.40863-5-youngjun.park@lge.com>
In-Reply-To: <20251031065011.40863-5-youngjun.park@lge.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 4 Nov 2025 22:04:47 -0800
X-Gmail-Original-Message-ID: <CACePvbVkwUDAxnjJ96X_nVSgSy8B2nd5f1tMoCnQ0j=T9hfDzQ@mail.gmail.com>
X-Gm-Features: AWmQ_bmJRSfZDbOhDh-lZ9I3TSyE0CaUTOgykA7GZWUk7UPAAxCmiQs2IlbvVec
Message-ID: <CACePvbVkwUDAxnjJ96X_nVSgSy8B2nd5f1tMoCnQ0j=T9hfDzQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] mm: swap: change swap_alloc_slow() to void
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EBE9940009
X-Stat-Signature: c576cdkecftogmouo5q7fhotybozgwbw
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762322699-591333
X-HE-Meta: U2FsdGVkX1/drsVpfZQYg+Y299Oo0MtI450rzcy3I8SGGybisVoHYwB5gCLaOEJpVsYvuJGLtfcqjFaT99WThwqXyP9NlOOwoED3unVnfhxI3XzWjpndHYZOFCgyP+/6hvzuRUGgPhtCzEUDmPhHyWRjDgyRmwnI1SHM1gCweRulvi9rVf7KLC2rt6OjcHqwxDCtqtK0G1iMRsWNyxZIwE9TF8B8O9UJoO3yFkIaB6lszZGSTaqV0oWmY0I7QIf/5o6kAA/r+TrfB6r2q3M8oQl5tdQRenAi7RwG+70GJTw1kPEWlPQ/gq0ElAo9xWwKdugo2/eoFNXYo1kcIFaxwQFQ4cppI/8k21dZIHjqY1WkQfUZegiPQBc1LqSus9k2Dv/BUIa4AJK4jHt1zNFlBfuI2P2Eu41Yega0eVjoTCS/iLbvATPhKkS2ABlfXVfSE5jJ7JuEls3mb9nIUfcf7NjsTyzGDY1/g2T89hc7tR2eOoXPs/cV8hsk5u7J24jGP7N4+PM7kpV++bxVUifKM7NdBz/4zbP7WS75fA1y3gNYjYxMw+u4cECtp1wBXs5x9qsuj8Ounf4DTdbgzmtewx+O8REE8uJpjN5eCz68E59f21jeVKyCaubGB0lDd+n1qumZJFb/Ub6rX7WTe4sHL1fd7NW2wx/vwpvezRfE23MZdJCvXsCrGQ4uEQuAkwuAZ33vbDQq/thuhVSXsw4ayqzotiZIureqeYybMHcdm/y6v05BzuU2H407SzpeRIEC1S7j554aXELLJy+Mfqzo9VK84aejlp2Pw66eXuo45rCnnEO6yKFIrwpiTfLdAa0V8jp+psuHuBFM2RBjEfzob3HX1vK51FKK62WuadVSle0k+DaftlKb0+sJea68v6TkusdZ1A78GaE2cHppum6hPopVsA7LU7omSY4LU07vGY2jbFxXJPf0mGuSNtsOmmK8CLf+zxrA1hTnXRlH9cQ
 AVmXyjhL
 aijxGmemBC+C88G36K36XnmfD+wOvMboacA7Je9GEojrhureSQAjTI8yNJT25m5qfyoSKe+cSJMCEPptpw524VHatgJPCFPgTceQXjnVJ8QgnoBg96FjLwkNOe76dj9v+XmwXMGPW7wJNRv/R7LxQXshXZe6ZjKcAT/CzGuQaxNhroMrX7Cv6Ev0Z/0poQQNkZhMwvtceOZY11+f906BiPvZr54nm7PfaHNtqqT+JOvtzjUi1QEVUyLd0nFczYTMmI4c+9h+wN838aH5VdKr9Co7RBPZS62MgQB7QUKqilD27PRc+xdY7RSZezujb1c9X0gcgd3d1FN/AsRfTSUFrl6rP3AH4iDaSGpb48Tbl3E2lcKyhQNsLgX6W85TDPyMmqOKQJJxCEX+FoOB8asqrnKeq9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

On Thu, Oct 30, 2025 at 11:54=E2=80=AFPM Youngjun Park <youngjun.park@lge.c=
om> wrote:
>
> swap_alloc_slow() does not need to return a bool, as all callers
> handle allocation results via the entry parameter. Update the
> function signature and remove return statements accordingly.
>
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> Reviewed-by: Kairui Song <kasong@tencent.com>
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index b7cde8ef6742..4f8a1843262e 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1339,7 +1339,7 @@ static bool swap_alloc_fast(swp_entry_t *entry,
>  }
>
>  /* Rotate the device and switch to a new cluster */
> -static bool swap_alloc_slow(swp_entry_t *entry,
> +static void swap_alloc_slow(swp_entry_t *entry,
>                             int order)
>  {
>         unsigned long offset;
> @@ -1356,10 +1356,10 @@ static bool swap_alloc_slow(swp_entry_t *entry,
>                         put_swap_device(si);
>                         if (offset) {
>                                 *entry =3D swp_entry(si->type, offset);
> -                               return true;
> +                               return;
>                         }
>                         if (order)
> -                               return false;
> +                               return;
>                 }
>
>                 spin_lock(&swap_avail_lock);
> @@ -1378,7 +1378,6 @@ static bool swap_alloc_slow(swp_entry_t *entry,
>                         goto start_over;
>         }
>         spin_unlock(&swap_avail_lock);
> -       return false;
>  }
>
>  /*
> --
> 2.34.1
>

