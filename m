Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0536D25938
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 05:53:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D54FB6B0088; Tue, 27 Jan 2026 00:53:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D03146B0089; Tue, 27 Jan 2026 00:53:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB0DD6B008A; Tue, 27 Jan 2026 00:53:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A798B6B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 00:53:20 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 466C28CC92
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 05:53:20 +0000 (UTC)
X-FDA: 84376676160.23.990E8DD
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4F9A1A000A
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 05:53:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="SNqSb/iO";
	spf=pass (imf15.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769493198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LeDIVD1rpzqBRdVcsIFn6kXLZVWyCLZm8MCh2bZLSqk=;
	b=ClWFavbFo28NVtl8yiXD1tGxqKshv7Xfe431e+u0aMgxKi/JKDNLn0euTcBM21LbMkI39k
	ad4fk3vu826fB+P48eVqPKBbCYB7O9vczkq0rx4mzxRoXuqfkve0n92CpCXQ5e9A6QFLel
	W2aJInKKPoN4l2yC9fe0sSI91z7184A=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="SNqSb/iO";
	spf=pass (imf15.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769493198; a=rsa-sha256;
	cv=pass;
	b=sMfRS59CxEsVYgEprUYawONlRSpa4WuHJV+t76tc6JBwjts3iUOsFVIHsQYIWZDskOLv7O
	J1ksTIMokpD+5HCfngqp+AdzWS6dlrlPNXCiSAxZfGihKpl6XL5QzWqFV1Ocr1dNr0jAeA
	2R2IXzejwcu9M0XSH3rlD10v6Pqrt0I=
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-790b7b3e594so54712077b3.3
        for <linux-mm@kvack.org>; Mon, 26 Jan 2026 21:53:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769493197; cv=none;
        d=google.com; s=arc-20240605;
        b=QTJXUpsBWVsrW2yo+DLiNU7KAdqcePxykjUc1izFk4Zpt2TXIoKUfZTtXcNQEaL7no
         kCiBcrG/oGUuHgWeCsZQofGBjs9gBAVfDNGUPjMIqNg6pSSCIkiQVUjki67N9TF3g1Ge
         9wvloKvdCi/GoMt0Ag6dbztvdH0q3HVZ9MXhdpk6vuEVar486eTHyteY0hhaTOubvLHa
         VG5xQv/YFvwALJnEMemTY38H/kXsqNXGqVOvL2FCQ/DG9XdJDvvSejaOe67obg8TTlCZ
         7guY8Xh+PRQD6nk42rBsPM7oozttZsIz3H/wLAG4guXOu18xtxZ0r2a4xzFEkV5l1Qw6
         G81g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LeDIVD1rpzqBRdVcsIFn6kXLZVWyCLZm8MCh2bZLSqk=;
        fh=6lhgRDAWUishqJ8k3bLwwft1KqbddT9GLm5hp6ePfbo=;
        b=CK17BIa/C3v2YwbfkMuAo0t0Qq6kjodw6xC/yqCUAEQVaB7+k2UDtxOdDI8Nw5AXbt
         Cgru1GK26yJEAUg/kLgi3jv30AHsrKBSRF9HjMv9A+SQKG/Z/xAQgEKi/G6Iks/P3Ok+
         xV/pugfZbOP9lHaQeSWLNEVMf3KXWnFIKp/+sCFAcx2MZavn7KE9Cjg6fNK/Va1xqyg4
         kNk50Gj77WUY37hODt3F+JokqxiTsFkVkQQ8kmg6AI1LbWOsuwRLrFV9+t8M5dv0KVDN
         FcToq3WYr2R+oMVLhePD4HX8jebyZuQEVdNQaP7x+4cLzLRQE7gOJRTkSIBGOe1l7ut3
         zXFg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769493197; x=1770097997; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LeDIVD1rpzqBRdVcsIFn6kXLZVWyCLZm8MCh2bZLSqk=;
        b=SNqSb/iOHpFM49hODqmHjKoNCaZBStC6Vz55wjRRi6V/tOD+n8m/l1NDrZDr+0Out8
         Su1ygvhPJV8mjII00DLGoajXQf95XUxQ9gg9U2OffEwIJuZHs3siD5t/JVyy+K5usc3z
         znhZ8gj93m0XhUDxsQgqSl2DIJRG7AS29r9K1NKLeHW+SNyJfWhGQMHlKojoh+a92ZUd
         x9pxzqcgMA1r8jm+tGKKOzc5BlKRySEqgv+VO/Zhij95H/kv+0Pij6uybe2VyXNy2Z5L
         UnmxVf0KLHDrgL6YFfj4ql9wXr3+GTfHWZFtjnnWCNKMQFA0Pugey9C4YQZtmZug+coE
         5Cww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769493197; x=1770097997;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LeDIVD1rpzqBRdVcsIFn6kXLZVWyCLZm8MCh2bZLSqk=;
        b=HNGWLoy2QwgG8YinuKqJGrZrn44xIwgn3ma4BwoJBTViM3IQhhmwkiuKd5qJ60wKpc
         1aYqNFTXNyGKnREx1d83WENMXOG+NSx12Tlsun7JY6x+3xjyJcqD8ns72yy8ydotxAkq
         d+XfePtMUXRXl2aPl1S38bqAlzdyxW1EAvTvPaXrZcevcg5TATpKLo+vAMjPNxbPv8tN
         IOPZ3Dg3PdtHtAHP0L1BE13vyxXARZ8pNyrIx/fKn42KLGiSb1RDIKfIAWW9zM9OIZDg
         I5eDWmEC8lIfBKC7QFI9WGKGTkbY4Mw6spxP9cleHqSF7JBHOr/vS4d3KIOTIcjqmhdM
         svkw==
X-Forwarded-Encrypted: i=1; AJvYcCX39dHeM7vfhCapdy8aT8S7XpOJJiYE0wLQjGLlp3gFJwbwDLNMGvXp1CfJIk666o99af2mSY5wug==@kvack.org
X-Gm-Message-State: AOJu0YwG/H41mZtvh0G+XBm0xu5CDWR5NwjnORhUZkvvP8T+pZg+tC7M
	c0byeL84djHBsQa+XNlFq3qHVOfiRx8pnHNDtAZ5Dh6oKVwVQJ1tu+5s4Vtk2e7mFiM5O37LzJt
	8hEfW4Cg2IFBUqFH9bi7rFetQzYQuVog=
X-Gm-Gg: AZuq6aKvYVtoTrPIsTspfaDutGvb0ydIQeNgsP7FVO1iiAaIoFzPhbqRK47htzBmUO4
	kGYeQKXdbVp/BQ40jAmcR7nSTA3vSfltIUGaWksbOBcGFi18DzNL7IXugwofsIeu4n/QHIYxp7b
	1CGVfwW7h9fay3yblMztJRU8kw5djvJzuF+E1bHHR8Jxj3LjPB8x2GFgbxFarRToCjec/5NZoV8
	hdSie+6ElBhW4WwhFlBl4IrA3EzD9fJgX/e19OIA7v8APbrOw1dZYHONiF992DA6mkPwmtw
X-Received: by 2002:a05:690c:6b03:b0:794:722c:3a6a with SMTP id
 00721157ae682-7947ac7f221mr3895447b3.51.1769493197439; Mon, 26 Jan 2026
 21:53:17 -0800 (PST)
MIME-Version: 1.0
References: <20260127024421.494929-1-roman.gushchin@linux.dev> <20260127024421.494929-4-roman.gushchin@linux.dev>
In-Reply-To: <20260127024421.494929-4-roman.gushchin@linux.dev>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 27 Jan 2026 13:52:41 +0800
X-Gm-Features: AZwV_Qjf35hHKQUxt2WbxyqXXiuhYl-WXoFHvpi_hheh4V1RgfaGbVlbUXeOUQE
Message-ID: <CALOAHbDSYceqjsWLOO9mD5gkzrO=jnxgiRL7pcSuYjLP8Nq-9w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 03/17] libbpf: fix return value on memory
 allocation failure
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, Michal Hocko <mhocko@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Matt Bobrowski <mattbobrowski@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, JP Kobryn <inwardvessel@gmail.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4F9A1A000A
X-Stat-Signature: bj97o4pucg8wwbcsrjr15u95u6t1ahtt
X-Rspam-User: 
X-HE-Tag: 1769493198-324841
X-HE-Meta: U2FsdGVkX1+WYsRCo7KDk+IPeUQ9Ww1lh/Bw/5N9lkKUVuDFyjFmINip9QA5Kyy3N9u1SjQcUlTGTPMp7YnYEx2iR8JA+WKRdrQX71e5fG7P8du8d1trccg0vp3qzJwPlCzgzLllic+Cl0nn5BRFYXRN+Z/qFYc8cdkn4PjR/GH1JSIGbPQa/RLv9Vw0DCzIE1ztzCSWAzqA2u824OAKdYH77ryapPLlyJbGRbIYfjuO5GIBPEFWUXLAp4ilmdyaDUiodwtCRDfg/lAwKzEJiaV+XmnooMQC+nBUoac2qxbuF2lR3P5QrTMxEiboO+hcNbMXJRIRVs0yS3LnzYY/CXnEkG/OIILwf3kJunQ93NpyAjeuOS+fA9ZY3dAVPnDk93JzMbOC6JqiHvkeAWK946ATqqvgpSXk/eQtB2k1BSQ2oF5LMgrvc2uSTicmzDtdanuMCY2oCPTm0b2+V09B693ShX+ti6qCulaU40oFhYsC5P7Hylw2NPCZ1kVJ7IWe4C9cZdmBHdI9kcS5y1LgzIGPJL6/OpsFJR6d9pl4vX7cLJUUdu6bktP4e0cf9TtR+xLHkbqUoFT0i9D8PDZVV+ljd7GOwdU2j+0nmzoAKeM3wwZyYM8YvUX4R8zAif77wsTdnMr9dqftIZI6Gq3NaPJOplaqtHS22qItR5HOILezZwuDmwGDoC9u0F1D4cpnsxjq/6sMd1mEmTo40nCFZEOFlMLBNXAqTHfG2DEmSsETBmH+Gw5ZafaSfJci8vNz3BCkPDhWPVKbj4kxT5zp+zimD9BQWnMUvwbq5bJagctMVEPg5He+glyBHo6O8qtcx6vbxQZDtB+oHE5mxHPGAGLL+f85DfuvnSkDIrxzAZK/RyhYtfSWDG8iZQkHzT+K+Yd3RhCsB/7HmmFDJT17jaAIQ6CL7O44X3ZrubWePPBsz5ZIrfFrEXP6S108+ITM1kehy2B8N6JEb5+6R1Q
 FtHn6ipn
 0/8urDPjJ0V4Np/CwkOwfgkqdbk4pFGbu2WnFihdOJV4xhdtm6If9AlfSJJMNZyOcKLKW4EtgniyF7vI+rvaOSIwPNMAmnIxXqrraGgLZnScT+k9jvwE5QFfKJnMsAW3ic4up6cjzghWFwEcTDidpgxh2Ia4zE3WJZYjHWmfxJhyhgGAcBLcFbAWZSJvmZf7bQfx5m0F5Wg8GByrvKDEVwKP6zlExvtoeg6ByfX8LUhak4O7R07zAqt5mnHA8GAzEo68lUK45dF+1s3/9t0LRhppJnPJx2/33hxH7J9YMAJmUJ6gGPJRZmVNnX1x1fGQDtf9mikxWrImjGZZT4MoZuHG0YB+gkEo+0CBL5dz0qpp3auN9W+CK7vfkCg3QiCnerzcfp0LAx+vDqRIn+CKJwqcZDW3u8Kc7hhCHaruEsChbXnDChZQ1Umc2og/+eHLwxM5QBKTbwFIeCIE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 10:53=E2=80=AFAM Roman Gushchin
<roman.gushchin@linux.dev> wrote:
>
> bpf_map__attach_struct_ops() returns -EINVAL instead of -ENOMEM
> on the memory allocation failure. Fix it.
>
> Fixes: 590a00888250 ("bpf: libbpf: Add STRUCT_OPS support")
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>

Acked-by: Yafang Shao <laoar.shao@gmail.com>

> ---
>  tools/lib/bpf/libbpf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 0c8bf0b5cce4..46d2762f5993 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -13480,7 +13480,7 @@ struct bpf_link *bpf_map__attach_struct_ops(const=
 struct bpf_map *map)
>
>         link =3D calloc(1, sizeof(*link));
>         if (!link)
> -               return libbpf_err_ptr(-EINVAL);
> +               return libbpf_err_ptr(-ENOMEM);
>
>         /* kern_vdata should be prepared during the loading phase. */
>         err =3D bpf_map_update_elem(map->fd, &zero, map->st_ops->kern_vda=
ta, 0);
> --
> 2.52.0
>
>


--=20
Regards
Yafang

