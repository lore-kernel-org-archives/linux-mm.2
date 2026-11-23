Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E78CF606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 16:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GDGEYtL7
Received: by kanga.kvack.org (Postfix)
	id 13E0C6B05B8; Mon, 23 Nov 2026 11:20:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 116116B05B9; Mon, 23 Nov 2026 11:20:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0057F6B05BA; Mon, 23 Nov 2026 11:20:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D55406B05B8
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:20:25 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6D2361A090A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:20:25 +0000 (UTC)
X-FDA: 85466896410.23.3394909
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 951A2100011
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:20:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GDGEYtL7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795450823;
	b=gPzR82p7dT3FEtd5r7nP1A7ywYCwJje80zy3B6Am9zKMZy9ciXvIIAKLKhvJpcvlBUYQlt
	E5852G3n5JaZ1kJUZnp7osAILl5C241fvr7Mojume38cDr44cyVabUMDaE3W8jfj2hljB8
	Q0/JADpouMs8bApRo7nCs4w2f9rqH1Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795450823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VMHCwMuWqOW4JKKsOO+FUuvLN27CPePpxu9ZaOnKa9E=;
	b=LDz5MGiySt4vz+sclaPGCuDiEvAhpZZDAcHG1iws68q3lCUyq0KpGXU2lMqwLj4JMmqXSA
	TXS8X7OGH+rqoFe40YcTVGVfWucAsdkFX2BJrlUr58M/kQH5yiMiLh8YImJ1RVxkTgywmy
	o79Pvobmvd3w7uz3R6hU+Dsd5WukjAw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GDGEYtL7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D62C141919
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BCD01F000EF
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795450822;
	bh=VMHCwMuWqOW4JKKsOO+FUuvLN27CPePpxu9ZaOnKa9E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=GDGEYtL7lELpnekg2dZtA0noURTy7b8Qqb2t8Aco6KI9yGEey4fOdVST0kDaZmm9D
	 qC2767n5fEM+SF/OXeH1t9cTXTP/JKvCy756skEqRJ7Eg4CN972uwQAZN5ovDno7CI
	 mUXd5gPHzP9IfCpfhvbG4S17C48Rz5PdKk+55UH3coS0CP5YCH3+3lbgoDbVUytG7b
	 qm18Tkjao+EplItC6lP/zxbj2jul7amNgqUtJk95OK+gQNITt1B7pUJsqIpJnLfwWb
	 8zyOFDaA2eQUm1tuXM8bC0l8uJdybFb3+6sKhiu/fmashydUuDYBl8Tu6PI7ZP4QsG
	 sm3I0pw9V8XpA==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c515319dd89so395826366b.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:20:22 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEAvdKBJlcnQ9YDoK9l39/fvfberrA2k8z2TmNkR2fvvjRquvv4Qc2u2K1AQ4Vb1Tj3xd1NpBKpJQ==@kvack.org
X-Gm-Message-State: APuU4Z8R5iFbaizvKQUfjBNlowBKnAsvD2ujyboD/n0h+mZ8vadSTg99
	7gWojpWm7lPYrdZEZDRahGd9K12DYvPOP023oH1KP3/SnaavY5PCXH//A5mUM3VknKr6PEO+oun
	wpQCnDcu+YQ+Jhp0GA2DSJrrTp4c6EOs=
X-Received: by 2002:a17:906:7b48:b0:c26:1648:a062 with SMTP id
 a640c23a62f3a-c513a9ae0d9mr693411966b.29.1795450821212; Mon, 23 Nov 2026
 08:20:21 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261123032512.6119-1-raizudeen.kerneldev@gmail.com>
In-Reply-To: <20261123032512.6119-1-raizudeen.kerneldev@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 23 Nov 2026 08:20:09 -0800
X-Gmail-Original-Message-ID: <CAO9r8zMhvpiD6JXBfd=KCVfHxQ3=VgmsVpcoydC89Kyj37thJQ@mail.gmail.com>
X-Gm-Features: Aa3M54pyWRX5QSV5IVnMsgXQsdYhEWxByyxSD0tUw2dlim72dadxdTz936Q7lRk
Message-ID: <CAO9r8zMhvpiD6JXBfd=KCVfHxQ3=VgmsVpcoydC89Kyj37thJQ@mail.gmail.com>
Subject: Re: [PATCH] mm: zswap: remove dead length check in zswap_store_page()
To: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Cc: chengming.zhou@linux.dev, hannes@cmpxchg.org, nphamcs@gmail.com, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 951A2100011
X-Stat-Signature: sarif3di715mxqkuc1bh4bygxbf1tejx
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795450823-28175
X-HE-Meta: U2FsdGVkX1+L/jZetbAayBiHVveJhWyUsNp1UmcxY2azeFOYK870yAT64BwGaEjePR1A0in1lmohjD+gf9ogyFZS6ZYNczAEAvXBKlKOM4lKvEZKcDQvGVgTB2iFZ38RHsVRdc0dmu/v+A7bsCGMC18M+o5oPzdbkkFfkjVyx7ejRarJV5M5O/8JZ3msN58QKfwRlRLuWfY4S/vIYp21gsZ6jBKXoTu+2ilAVWlkH3gAGn4DwwKZ6U/lUScvKPF2dhhkgeD2D6OEeID9U4wsOGzGS/tEwPOrwpnLadkYfENg9K40h+fQMBzmYNmfuNmokcoEPy559xO6JlI+IMGkOKqEhM2Q9VJ9KJizNvltuOuhFUEDiIMB/MPElQNyjdNg9ZcJu9bNDGzEIQirtk7EKHNMs939TYkblhWTqTdOAtgfcLc7z/j0ods+V4inbil7IEXjhW3J3eg9mBDjg+e8jNXCuL3IBdAENGBmwxS4MD69g0ibKIwO+dLi+OfhnhbsJpKIhxLQiYAZ+1mMYqx4qI/0rKlihhfomd2Hz2oKlkaCteeeLUgQHP+yYpIyorRVhOhMld20o8cfgJv1sve/WnGXMkpnghaNrGijjbOOxIQHMM888FIoohnYlQ0543GZ6wdaFGHLGdvlw5pRC94vMK+pTuvFbN1nFcEm+ODayKXwvonmSRzbwHEpTpafQW6sfCMAPcRIpBT2bLn3sry/sC0qUEOddGumTV4zZk32nW9/MWvUoxALMockbtKF+xidlyAmM8AhR9b7S/jdHUQDRnkhT3mmNGPZa8WDj1YHKeTncWALvaGhksMIDDrbHvs8+JRyaAuAWyTkpjnzvFOnnZK6RO5M1fEwiNSWD+Rrw0B+X/sj4OYe+S9KxIoMhzyWHGueGT4oHafP9c8x1Rj308xF0L2EFbv7CBwWzyOSc7+etphDsyE8LIdjzYnbxJxZLKFTaswMBmubbmhEx6n
 bsMo4NdO
 mNUJmzrcXa+MYQ5OXuijspiZGQiOg50RMjNSaae1XavFn/sirOF7PlDF+ec7oxVAOWj1nmvLqpF4U6iUwRo2YiRpGnO5yQZwYvdm4V89qiFvuCMN54lkB9dWOgHzB00Qc9IRwWWOv5uqpY2TLnP4p40AdhvkjkiHg8T58HZnqpVL5wsydxwFlXnfrRDmZB/n+V9kBNd/o4NjCZf1RPDEVsyOrbEQsHplatAjPx3cx2Nk9hNO1BOvEMqDaRjNQEREqs3UtXdOcqIMuln0V3CQcO1m9IPaAxap/TIlty6+9jgzI1E5k2U2MX/OII9MNdFbhwPA1Ql26IV3MeE/Gd1Ly1EEr73uLAS2+w1MSWFcFL4xWcR7YcOjl8HwDmKvmykHEanHp5X0c3kxlCmHc8lIkio0ZoiCCEh4AsTVN0dOyEv8OhjpIAP2b36n6+vohOKNnVu4QmWp3p24dMeaO8YWcvu+dyyGnBtkJvPLAOYCk1+pBvTIyd8h9UPZJr5PLIv9Pxdx04/vIoDwwBFNfS1PEZ2/Sgzec72HEnGcaAPLel7MrorLg4mDD9W2rnKSTXqrueIAVj0XmHGxVm/VTGt7dppq6cQAnKEdTU+Zpvt4xQIw1ehJz9XIlgxEUstVtaszjE5//EaTFYpCm2BPQy7R4XNdcFT13BPV7AW5CCZbuCQarCuA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 22, 2026 at 7:25=E2=80=AFPM Mohamad Raizudeen
<raizudeen.kerneldev@gmail.com> wrote:
>
> zswap_compress() never succeeds with entry->length =3D=3D 0, so the
> condition is always true. Remove it.

It's probably a remnant of same-filled pages that was not dropped in
commit 20a5532ffa53 ("mm: remove code to handle same filled pages").

>
> Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>

Acked-by: Yosry Ahmed <yosry@kernel.org>

> ---
>  mm/zswap.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index ae19e301fced..9590f333d83f 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1509,10 +1509,8 @@ static bool zswap_store_page(struct folio *folio, =
long index,
>         entry->swpentry =3D page_swpentry;
>         entry->objcg =3D objcg;
>         entry->referenced =3D true;
> -       if (entry->length) {
> -               INIT_LIST_HEAD(&entry->lru);
> -               zswap_lru_add(entry);
> -       }
> +       INIT_LIST_HEAD(&entry->lru);
> +       zswap_lru_add(entry);
>
>         return true;
>
> --
> 2.53.0
>

