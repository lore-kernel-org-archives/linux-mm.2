Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDC4BFD0040
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 22:41:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04B8C6B0005; Sat, 28 Feb 2026 17:41:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F11986B0089; Sat, 28 Feb 2026 17:41:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF38D6B008A; Sat, 28 Feb 2026 17:41:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CA85C6B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 17:41:31 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6C06E8B33F
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 22:41:31 +0000 (UTC)
X-FDA: 84495338382.09.C7BA317
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3DFA31C0004
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 22:41:29 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dysuSthP;
	spf=pass (imf21.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772318489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+KrSKJM+qiSozkVcs43faZJu5bbcNOuAa5MWBLAtOZE=;
	b=YtAdDMNn7dFWYnm0Xlz9RACkbznKp9Nbr+wNx19ukEt4YVRxgWEtnSJVnBqARGE5ltjUWu
	GGXcCgtMfiQbaTghcnmNAFrzMv7NB9aI7Y/8UaIqx85w2P6ncz19nvJ/7qXqatXbdVNmdp
	C6EGBnXrRnSxZIaTueACCbkkBSlDu6k=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dysuSthP;
	spf=pass (imf21.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772318489; a=rsa-sha256;
	cv=pass;
	b=avlaITJvKNkIEES9qQ+mwwAUi9oiEgm12Q2DHiIY/+3Y7Sw9wDrWMpUvI1kn9BNJ/Njq7S
	f5PbIuQN6FnjhrUSerJxfJwQ0E4U9APE1uzgwka6Wmznro8vJOZLTUwtDSTwhhjB5nugS0
	B7ayJURQFkYrcFaS6mjQnOgz36+f7qM=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-899ed41208fso6111916d6.1
        for <linux-mm@kvack.org>; Sat, 28 Feb 2026 14:41:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772318488; cv=none;
        d=google.com; s=arc-20240605;
        b=AsQODXnJIMf05CSwL/jg6gRyebuB41p35a0DCWfnVl1P/KMc41NT7qXi2BvD807GVM
         /Q4d7WMmQhL7kaEu47CsgDofKNHjlYv+SjfIjqX59/aK7aFBNThf4joG1i3GQo7yX44t
         runsHl+gHEtAIrZ9/SsuJojYn9DGO4crzYoSfrDoloFFdBGjRQiPJRbwMrqhtrFbSUsk
         t7qNRxjwp2fIP9sY8JK1gI0acTS5JdYQvHs3jWahDBXU2kC+NAETjnA+zt4LFSbBhWKb
         zi+sMy8AYN2DZlC6nXRO4g61hBd4FVmbh8ErQE08Zpw75BHaaSe9Xhs2AC5z9mNTgDsq
         upMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+KrSKJM+qiSozkVcs43faZJu5bbcNOuAa5MWBLAtOZE=;
        fh=MVr7aqXEQPXHbimW1CGAztoXBLrKYxwA0gYa7sJx1Bo=;
        b=knH2DTQkObq46LNQpR1OozvnA85D7DaAnlSzZX4p+o/IaWnOgOGKqfyAoomR37m/Z9
         60lG8ZlNbLn2fIi/6HWhLoPj73Yn8KVCq4uiHBJYT7IRdeEK+yExrFICEIt0m1uiY1WG
         YDtswl1B7XDjeB8qPl5x492j0mtCgTvtLwSfNmeXev4FqVodSK9agq0ShV39NQn7hkLK
         W2itRwU8lolbMuuMZ7N20r6rna8uq07tdLkJxdjQXSr4DIN/t/tKC6h8TjTnFT+qZS1r
         7juyWFleU9gv4sWDkRJcpTexgRjYAJja1jvRvtXpuEG6I+15FZgUq2IlnFfJgDHMz7Fo
         I3Lw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772318488; x=1772923288; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+KrSKJM+qiSozkVcs43faZJu5bbcNOuAa5MWBLAtOZE=;
        b=dysuSthPnebe6yKZtSVQCCMaUjRLrRQByvIa9+fVmt5pOxVqJQtUMmn5IbpbdliV0q
         VHuoBtwddaXISSZ64R54MEXtTHIqjOipOYRRwymUbcX6nQpfLptosv/+QLpnq/iZvbmL
         Eh/S/d+tJwsqU1UjcqTEXCB84JIIK7QWv5/uePCGKb7gCjIdasiNZ0gMSzluasda9vxP
         pPNj1QBPbiZ8XMp8U+wmh8Hx9pBi1S86obwCmusnpKqrZ8y2GzsN7VZ+gJzvBJ7uc0Bw
         06ZsI1uDVg5PAnS6fJS88mB1G5NzjKZ3tHhGQGrAI/wAP4PB1uQhlFlN/VGjCkzjk4Ik
         i0xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772318488; x=1772923288;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+KrSKJM+qiSozkVcs43faZJu5bbcNOuAa5MWBLAtOZE=;
        b=LQ+KSkoXzcmj7tF51C8iKFmFFqI8Dp1immx6iK75dIXHNurtR4P1/SBAlT+s+lKqXb
         8LK2+KEyiVyCA4UCHti3fuI7QIVCiVPKQrP8B2hVK/jaMmxYHoIxkzJ6c9Sg/0hTxILN
         DnHGzl+5bSVloNZHSIKzZ1PmNWG9exsTBRHF5QP6V2cbAb5tWdN6cXPT7mWFPHzY8OUe
         uZ5+3YE778+ueWgX439sJAmiCURNiswvjPfsQFZotzFUBd2V8NT/gkB2CrXLNFN7s5zr
         JEpHdnyOKTIJrStSTfAe0Zoq74zPL8dCUp6kRMshAU3hOaOHH8EZuSqkRcwI6ISLmIJb
         R6jg==
X-Forwarded-Encrypted: i=1; AJvYcCWscOY6/j9VHBgUFJcS66CgTJgksTsLYhW0NQRcv9ON60XO8qH4ROuEYqgA0cUdHSrGxSI0ma+O7g==@kvack.org
X-Gm-Message-State: AOJu0Yy9VeWxdySQl9okpC2l3QQSIs9RGiKi/zW+Hg19R3p/jxM+v++Z
	OcBsLL+/6NDI4xNC1o/8mEKVGLSVZqTvrFl0mhL9/Rdo+eHuBLkLeuaPJOPUAE+mHUcxw9fz2s7
	nW1wYx5wPrhjEWPwh9Ek5R109d3uZE4U=
X-Gm-Gg: ATEYQzx92ZvEHB3xr/Xn7ffXGa54bKgKQhrEJCYD+i1kgjTcOkVDAcnt+2d4/uqFaBv
	b25WJczUZ3D3Wzkx5YHDIVRj2a+vsn3QCV2+dojYHJTb6aFRv+xRPwfsF4/JGKYmzVP9FitsLhM
	t5ihXAJBvXsB2hIzmUJ0U+tIYStnQ0Hhr4tTolXKFrj/VZBdY8vblnBRlL0jTSerazpduyfW8pb
	9qHOz2XhqnE5zFFU9rpTsaLAe99xNZj3U7nYjAc1oL4AubP00g/4pHERVAiZGlZJmh2vIe/pVUb
	gaqfUQ==
X-Received: by 2002:a05:6214:ace:b0:894:68fa:37e6 with SMTP id
 6a1803df08f44-899d1e8d99fmr117361876d6.58.1772318488103; Sat, 28 Feb 2026
 14:41:28 -0800 (PST)
MIME-Version: 1.0
References: <20260228161008.707-1-lenohou@gmail.com> <20260228212837.59661-1-21cnbao@gmail.com>
In-Reply-To: <20260228212837.59661-1-21cnbao@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sun, 1 Mar 2026 06:41:17 +0800
X-Gm-Features: AaiRm52vqgolX-ECsnRzT2bch7ljYemI8lnbHpkrGI9PF-V1-l8ttKMvBQkwdow
Message-ID: <CAGsJ_4yCA008MKV8OKoV=Ge3B_KS1gnVxEPED7VQBmxJxR35hQ@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: fix cgroup OOM during MGLRU state switching
To: lenohou@gmail.com
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, laoar.shao@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, weixugc@google.com, 
	wjl.linux@gmail.com, yuanchu@google.com, yuzhao@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3DFA31C0004
X-Stat-Signature: a8tf4nkyj44oejca3qkfxfserfwtbwhj
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772318489-866663
X-HE-Meta: U2FsdGVkX1+PSCKKhPQUjqG66KV/C/irF5PxiRpqstXDgeksM0c8Hg4iuNkdGkzWMndqs/BbbFxbMTAiVZV1EOdvCHcie+PWTbgrEOnjPoOcOri5hcH2rPO6s2t90Wg3s1JWeGL6MbVlKiQ4kVrF2eW5ArZEEVEfrG2nJx6HKJuEFgEbMPOUJP7vPZKzXSF4/YTAJSJDYBmx+cCJJuJHp3DurSdcVjc5yjvJHtkF6y7xfcSfeGmky62YXDqjgOlBegU/trgCcjePXWSALY78IUeWrHZW5chpJN9n3m6shKLFD0PEJzxOZzhqef0btzssFxJGmvWfwmDp58zcEV/BqzXGePfkh9H3H9hW5D/yQ3Z7BjORGaeL0Qh8qAvXaBL85RXhU/7tL650ipRqtt9nQ2QQVddiOKs6YYVM3Oa8DlX4KZ30n7HIvq3s1RG6U9OnK3KwyMNx69ayKKUHBKB76izFj60FgIF88BACL+d2F5oCWSKag6dT00rMwDSamAo0/80Da5Z4peGo9cAx2IhUtyJHtPt0lafKgmlNC7Hvk+IRJBpxstGxpsT2Xf1FqDJi5kTCzD7OXMCWMAOBt6XDtcb8U/gg3+JZ2XA52+s3Mg2+IKphShTDUUqxv7Pdw1yczf0ek4xTPikRV6Wv6k2aGeZASrrdwFgt0VZRcXGZ6KKIAWw8o655vo7fsOlN3kdCV5hWDclityIP9EF00i1f85zr7PUm/frMKXJeGeNVjR6zkXXtFey9GNpfFlVzf7IKwo+fVVB17tKyoAniZCjbOjMgNGUI4/PG0oXkUhwZbkUlN5AU8dxk12RZmUBkTIXpGU5g4AV78Oif3PC4923S4vs7KpFQmaVlljhngoWmRjAB5Ap5423+8rVoxIZse8IW2ka6XduFvJjoeluWcyy+TTibzDfeeywJ+ullXQ2Gto1pVGzSLswDn69rCeooelzJXSx/KWj8kLHmZS6gndd
 u/pKJQhs
 Xq2AOWKK12d+knnNN7AkhJX0yIu96VFdezWNw6atYUBi8BR5kDUen44mmGQZxf0exGlg+9+b80sKWDaYbDRjyLkWS8RbLTjTx7agE5ZlpVg5UsML4Sb1+7WkQFqMOg9iKhDIGUCLLfPPLSGD46UYTdw9x8Ia4rMS5e0+i5q7IpG6+u1q6NfPny8NYPCLlYM4Opboo9qAq+guHoj3AJ+OXuF/lAURga1u2+4BOM2FDkA4a7oyGPB8X0ddyDVXitop5mkKEkTxENGYn2dgz8REwPrnA7+FQaH4Fdj9h/DWpVdlJH44RElckBTI7wOYO8+hBJObM0yqktSQOiuR3acoxOLJpEFyBpusC0Y1es568987FQxb065XrvSIQLFuA0qRTQ/+o1+vWFq3RARTFlOzTpvgKbMqFKvDF6mMEQxyQHDJCrLnXHoQijVBSZ3tDKVKtVzyAxHwb1qfQX7+vArlO4t/DXjKYe54A9UgldCLHlPQ/nz4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 1, 2026 at 5:28=E2=80=AFAM Barry Song <21cnbao@gmail.com> wrote=
:
[...]
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 3e51190a55e4..ba306e986050 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -509,6 +509,8 @@ struct lru_gen_folio {
>         atomic_long_t refaulted[NR_HIST_GENS][ANON_AND_FILE][MAX_NR_TIERS=
];
>         /* whether the multi-gen LRU is enabled */
>         bool enabled;
> +       /* whether the multi-gen LRU is switching from/to active/inactive=
 LRU */
> +       bool switching;
>         /* the memcg generation this lru_gen_folio belongs to */
>         u8 gen;
>         /* the list segment this lru_gen_folio belongs to */
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 0fc9373e8251..60fc611067c7 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5196,6 +5196,7 @@ static void lru_gen_change_state(bool enabled)
>                         VM_WARN_ON_ONCE(!state_is_valid(lruvec));
>
>                         lruvec->lrugen.enabled =3D enabled;
> +                       smp_store_release(&lruvec->lrugen.switching, true=
);

Sorry, I actually meant:

 +                       smp_store_release(&lruvec->lrugen.switching, true)=
;
                         lruvec->lrugen.enabled =3D enabled;

But I guess we could still hit a race condition in extreme cases=E2=80=94sw=
itching
MGLRU on or off as frequently as possible. The only reliable way is to chec=
k
enabled during shrinking while holding the lruvec=E2=80=99s lock.

Thanks
Barry

