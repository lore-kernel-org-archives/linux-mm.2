Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32B09C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 22:10:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29FE36B0092; Thu, 17 Sep 2026 18:09:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 250D36B0093; Thu, 17 Sep 2026 18:09:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 142186B0098; Thu, 17 Sep 2026 18:09:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D78B16B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 18:09:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5967F4050A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 22:09:58 +0000 (UTC)
X-FDA: 85224647676.11.D663277
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7490C4000B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 22:09:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BAnHAJGQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BAnHAJGQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789682996;
	b=o5Z8UnBlcrlXz+th7zVShxuIIueahz7gtM9gOPEJSBam9TYlL+ZA0+f6V+i3BGofAUXmKt
	Zv5Q4GzUns+j6vpI2LlsCXY23n5trIyGGMSWoUuV93NSGWJe7qYHioDPTqpQU9CTT9geUR
	rxC/7CVPAkpHMO7nzcsvn3c4vS0aUwE=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789682996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wQRtY5QKl9FkRvfYTUErV4Q5sEVG3iTso9QeFHxPq6U=;
	b=SuSZqOiCUSju4DkrgrKPVB3ZpzZ2zRAGNHsQAmyCM+1gaR/IGgL6eCaiLJ4zaZlOD62uia
	0Zvpt/5exGqVDdFzg9epN/7xqlDpjWkk4zxOkvg/b9Ghbwvc2EMOL73H98v5hz90JqY5TL
	SLR69sIU4Cs6+/YglUo2mihdfSYmUzE=
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-396ccdaea75so30624a91.1
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:09:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789682995; cv=none;
        d=google.com; s=arc-20260327;
        b=HINjR1548hn/hs6JX0crNGDS5joZqVxdG5Za4xfo/rxSIqazCIgfleXTphkqovXT5X
         8+RcEC3e3sDBNuhPeFv4/uV8XNqDioSJrzTuSWtrx30CNmlujMlM5vfaiu9AJLAsZfXP
         cqHe9l6keTFDjRHc9dBkrCReC9JuoQCA+XFmiUsMWf/ts34ubJ2xWBX/adKRpSxUWsMr
         yri1zSX7Z4+jotilt3XUqCRwRAtJgwnnXMhqOoLZg2yeQjfBLVjnZ47+mW0tci9QlPlE
         6NykzQTuBkD83OMGYxmuBqKpZngB4O+qHND/ji0ZPWcrdV+gI+os2KUOwH0ShOyp99Wy
         EQjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wQRtY5QKl9FkRvfYTUErV4Q5sEVG3iTso9QeFHxPq6U=;
        fh=NnAAQg3nwZBvgLX69tgcf/Sczr0W2OkECSnJZGF32eY=;
        b=iL9Eug4q1FY2EVUM+UljS2Rh3jx+UI/iCSLW2yg21xEs+RNRiDgh/niL99t951RExR
         vceu9CYMrHEmVVjfW5CUOEBAk7aGut4BWL9n+UTMRqasYxYE5XDlTSlfX464IRy98wH4
         aAKGeECZnMRjs6ettTlKnMclyJQTYRiasn/ElGAEBBzcgTrOJbhJs8NnbpfW88/H7LOe
         wO7gDIWLPXPBnvoOtvAPIg4rBFIvP15CHXi/MPAl8AEu+vzELLLJTguri1UFr5lpqw4G
         sAXLiwoeQzZIMlhzOg7BZoBTROcN86hLK0wXY95Kz1xnJvaVOb2r2aWDFKm97Y6pyIrU
         6b0g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789682995; x=1790287795; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wQRtY5QKl9FkRvfYTUErV4Q5sEVG3iTso9QeFHxPq6U=;
        b=BAnHAJGQvXeWvzSziy9du7FCRjb1bjbVOcwgCrl0Svjvscaph9LZVj8IXM2/9+d5+6
         +9IFe53cs+bI8g9/bdvgBGw/ZvZ7r36XwxPwDwqYsC8n8B5+wKAnyffvqKCD4RAzq8bF
         GIaBJEU04jUNWgzyMzQdux4vzlyRSk9OVy5fLZzc+3ptQVt9mFhD0wbeOaeU2l6FNNj3
         tPnJm/nhsZAQbPPEGvlCNFi/xUXvddqGEAzy1/wg7ZlFtX8XX3zb6YFa2KkuFV6kjpp5
         8ugjL2K6Lxf5tBaeEH7Qa5j6/Pd7QwFlYk5oh8hqoT1aRwyfJhLM3+kX5MWG8XsOILbk
         9fMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789682995; x=1790287795;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wQRtY5QKl9FkRvfYTUErV4Q5sEVG3iTso9QeFHxPq6U=;
        b=hdHAk1186sVTZlC3dFSm/AUEGwplECqLJwRB51lF9P24rdUWmMQFm4SrNgqMc6hDDR
         SeFCxhVrPtskD5XoegRNcEzHRUU4Rfult6lFfYoY+2hsTTG6mMSec23bx7Tf0tKsrWQX
         JWen90/L/0qDsGUFwhjJWUrfpegRPPl/FMw16Qf4QfAQ3xwa/Ptp0hSmH+0f7ao+ssZW
         t3gIK1EQ1HB4q4tdb2Bv1RNTSMmovomvEUsfTBaDBOhg6upMsj+oKjidtDYsZlpJY1iC
         J+BrOkjZFa8YZU0Y0GDqMnuBx5H0zhKCMjFnouENsVxuMRR8luVpVT1FFBLTydctGuSW
         pB3A==
X-Forwarded-Encrypted: i=1; AKwUvBxrdnNGwHVS3NoxmifZ8BLC4sdbxtVpCQjJU+ALxZsCzWT10SZVV9e4CVUchH3iDUiKvLDQU5YUMA==@kvack.org
X-Gm-Message-State: AFuF++kF63gNkU+NrhlNeEOSzUy/KfsGn+3u+Wg5facYhQjtOiRE+Z5t
	5f79yi3j7bHu9uEkDukfFAhRLeuL9mVWPLZVei7bqFtAz+WqvcekKxyrWs2QxJ2UuuIeY5DeEaN
	i8P1FJdNkaYDaYz178NML94zH6C4AUjc=
X-Gm-Gg: AYBFou3O/B0zhyMv34Vl1Mivq5KmN/L+d7iodeqbhftjEtjRdsOvrKJt7oWVizJwEkA
	JyL+q1KxH19/4QdOYdhba3/5PFNcSHXSrXGfxSvAK0Ljo5sC+wmbEcHkd1xWgKSCWUFF9G7cA2l
	wfIfSAIRrKVXDSs0K37dLIv7d0SYDcLltiE61AUvihAbajL5IC2CJGn+RTiBSvrReBMnee5W9HV
	fxLlNyXpu72XXgUjcIkcF5kqYzHpX5VbDRJiNR/4RNwEu0zaNMOUyo1JSg1W5ylY+R5hDhvfDOS
	JmmMZViTD2ScP/96A74kQ/dAlHEzg8YTGydb8X3u8TwGhLoioAHSAsvjh2vAlruas14w7sHE7xQ
	4HR/OAb/uy+raCbWuBQB+UBOSlZ63vkrrDd/Vo87T/7Szu3BFJwCp
X-Received: by 2002:a17:90b:5143:b0:39b:5622:d645 with SMTP id
 98e67ed59e1d1-39e5513d689mr482743a91.0.1789682995305; Thu, 17 Sep 2026
 15:09:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260915080255.48929-1-tasos.papagiannnis@gmail.com> <20260915080255.48929-3-tasos.papagiannnis@gmail.com>
In-Reply-To: <20260915080255.48929-3-tasos.papagiannnis@gmail.com>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Thu, 17 Sep 2026 15:09:41 -0700
X-Gm-Features: AcwNN1WTXc_NwWK6MQi-iRZUsTUWGjz1v6pzQXRB3O-GWxbyeKhFKxC4Xn1Cz6w
Message-ID: <CAEf4BzbfScpCi+x+QTdLifbaXPOR=DJ-7nM7F-Lki7vzD9L4OA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 2/5] exec: Clear bprm->mm before dropping its reference
To: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>, brauner@kernel.org
Cc: bpf@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org, 
	akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org, 
	daniel@iogearbox.net, eddyz87@gmail.com, kpsingh@kernel.org, ljs@kernel.org, 
	matt@bobrowski.net, memxor@gmail.com, song@kernel.org, 
	sun.jian.kdev@gmail.com, utilityemal77@gmail.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 7490C4000B
X-Stat-Signature: 1x8t5ihyadyfhdog1u9pt9jbocno3h8d
X-Rspamd-Server: rspam01
X-HE-Tag: 1789682996-317065
X-HE-Meta: U2FsdGVkX18DlsCSNp2snNjY+dHC84AAGLbPvraJgQMn2pKC3F/2v0ry9wE8QVg1RI/B/lE2xuAtxsRg7LiDdu/MiaWTZA4kvazWNf2JfehJl7HviEkdnF/vqTFP2qveo6/1QyYpIPRLsXQhao0gC00riQVCo8hOsNtcMfveL2b2hh0ERDJbk1OOilx5dfuLIRgeN07J/8bGqx3oIAd7cSJa/eOXyjjIr3ygLyZ5SjWbvh+exL2xFWgmCXGqPD46523TXsDlLVpIs7bvkwnkQSi3dNmDAatib6DoYpg/lQzIl0yCq0fXmEa3gUoclNu52impCY6iEZbnvC6hBs18DuNjfj+QiQFYtvrGGc1oiiWx9VGN0NoPlbKgQuAKO38+jbAZOb5ajLyQyfrtHKpD9jhV7C3k5NY3X9jSnQffis443U2kBVurwCod0jgmRR77wdQZ99uGUzj9c9umvjpeEehzGGs8Py+w+1EU8sb5smfCrIUoLqBaNoEhTGpCYM+HvFiRM8eVYjpmbaB9d/ay7Y09g6GTyF6kNZ0AVUbxGKtJ1iys6+EzI6lhBU+/u/NGSnAmHpZyZWYswM1Y+y3MBYRIThpHkqJLnzM9G2G+uNgpLQ+5ylYnf8g3ZIMUqtmP2jB8+KM0mtMOlRimz25yPikkJOOhnr3zBVVQno2jIVB9ojB1ymK8yc/0T+g1Cl0vRN+E2W9mezUkWsiNRJ799aej32nIDMi/NruBei+1BxwspUu9DcaAetATiW36Zu5+ti9qxYDQhN2L6bWWsgQHMUXNdeAA7RXc/YmbF6Pa7sgRDTh20Bf6h1YcP2kNg4S7kT42bsohWxl6LmVfFfrjS/LfrzI+B2nt4oCpDs8Xqgv+XEXgwBQQBnC+fWnSd+KO2xqXqjjOQULWRmEnWvqoCRSFYfIhGpHbZUt7D3/YTAzkWj4D0+Rbr5GuKdhnff8zcYPHcXkySs7qIV6ti8O
 tpp8Xe3K
 fdFVFuJFm744aC57TsQ8gVd37BK3zDdA93S4NpH0IYtz/j1/A5kjYkpCXlWEPIQdpNMU99F0tUedbCe8HXHAgCtsA3SgLjpe1SjcuDRSHLUnWO9ak/w87FEkvNcBFo4OBTiJrnCNQ5T/wCnJ5Q6tGCp55odAnVNK/ZTVdhh5wq3nKXmNt4fVFn+0Fa0bOHFmHl3gRbev2tbC1oxcXtLuKkD6q8F1OqvloTVh/IjYmvT7gx4uP4qtREoVhuq41Yh/RgbJ6Yi218Mk42qxKZmkNEx9CTLaazF7x+H0A0FhGF0vqPi6CUzAuBPp+T3Q1vzZKWg/PfNUt2Lqv+bepoCZPFLVkFOWvavmzB8uB6f9scEPJO0YEcIKVOxzdCAlhyhpSHgA9xJKseib78NhldFY3Xk9kRwaemOQoUUj9MZxT6eBfIzNQ5J4unk2HoZkRiibimXbfwPG1yO81hJ4UQHcAoGk0HYkohX3rqH5QyE969fF8ihFS7yfWDJgHlJj3143A9xDIWHGGrNEeu1MaVtMlIPjZCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 1:03=E2=80=AFAM Anastasios Papagiannis
<tasos.papagiannnis@gmail.com> wrote:
>
> Once mmput() drops the final reference to bprm->mm, the pointer must no
> longer remain accessible through struct linux_binprm.
>
> The successful exec path and the bprm initialization error path already
> clear bprm->mm when ownership is transferred or released. Do the same in
> free_bprm() before calling mmput().
>
> This is required for BPF kfuncs where bprm->mm is either NULL or points
> to a live mm_struct to ensure safe access.
>
> Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
> Reviewed-by: Sun Jian <sun.jian.kdev@gmail.com>
> ---
>  fs/exec.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>

Christian, you ok if we take this through bpf-next? ack?

> diff --git a/fs/exec.c b/fs/exec.c
> index 745f6eb5279e..4ddd403fd91c 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1456,9 +1456,12 @@ void bprm_drop_loader(struct linux_binprm *bprm)
>
>  static void free_bprm(struct linux_binprm *bprm)
>  {
> -       if (bprm->mm) {
> +       struct mm_struct *mm =3D bprm->mm;
> +
> +       if (mm) {
>                 acct_arg_size(bprm, 0);
> -               mmput(bprm->mm);
> +               bprm->mm =3D NULL;
> +               mmput(mm);
>         }
>         if (bprm->user_ns)
>                 put_user_ns(bprm->user_ns);
> --
> 2.55.0
>

