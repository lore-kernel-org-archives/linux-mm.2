Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80300606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=U/zSqU/1
Received: by kanga.kvack.org (Postfix)
	id 6B0A36B05B5; Mon, 23 Nov 2026 12:16:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 686C06B05B6; Mon, 23 Nov 2026 12:16:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 579966B05B7; Mon, 23 Nov 2026 12:16:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 16EE36B05B5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:16:29 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 870DE1C43AE
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:16:28 +0000 (UTC)
X-FDA: 85467037656.30.1CA02CF
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9123010000D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:16:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="U/zSqU/1";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795454186;
	b=Dd5okfno64HppstJVKjzNMkdXIcizLKC3CtZLLELg0C4uqL2obGkP3QpLzKR8ixstSDbmC
	jDYadBMV7x9HcKnOWOPoyEmBHpwjWSdnJ6+D2peMvouplzJL34qbv4mymU7SL7eBA4igA4
	bWZ2iaFxJml/aDWAtiLRvpaChcdqdTg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795454186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hTikqUPwqyc50FMehutzNCz2ncKuDk3/OGCI7AzQ28A=;
	b=aWI8FWMrcTRy6N5ZPh2Byp3KvyT+MWrlW5it1ZB3++vWjRKr+dSjM91KU1XVOwJijbC5L8
	MOniNseukU9BXnO5F6T2oLtzLvi4CJenkiPdA6tz3H9js0n0WT/XSf0uV3K0kYQneJAvC2
	NYf51GlPb/2s4wrgJ0qJVel4OdEbz3w=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="U/zSqU/1";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4bb64c99d2fso35074025e9.3
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:16:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795454185; cv=none;
        d=google.com; s=arc-20260327;
        b=dLXSZfnrO2YfMbt1gGKzVAuov+usmLiTPEV0inA8p0KcR5suvOwvovGHix/eIwOMp2
         oQnQ9UQeDCfYORcymBub8aY+5rjPeZ//sV2dV1XDYCiXNfB3gmA07Ek/1GAHQnxjG5Xb
         /iWjbWdOOp6HFjyj9FhqZlGOU0FNM1gRNjXZXTKYxhBFDaSLCfH86gMnX0uDce2ZKUAD
         WDukQJN3GhiAoVDGG/X6g98D3p4pPld1A7zr/uYySNIjRKf911JZ6OWyil+jgqPmuBiZ
         tV6VbJoLfSm5VNZKdDZrisFOnPFxY2lYDyoa+Uyh8hB2nPbAR9/+WnN43Fim4trAN8E0
         A0uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hTikqUPwqyc50FMehutzNCz2ncKuDk3/OGCI7AzQ28A=;
        fh=TKTDYScvx34b2Fi9KjVmfb/vSP0IllVMWsEuQ4jlAJ4=;
        b=oysM9DGNDkZRxL0wP4WpitJz1Rp2TbPKllkMRH/F69lr0zFtV45jhEsSLaJ+5/+UAw
         DWsRTna4234P8XRMchk00jYb1nC/yaPJsb1fNVgIFemNMkmLqVMqmtSylo6KstoJrodT
         afT5tUcSmBPGYqocDOaHFmHm7sa+WDjB09Kq9bCwBtc06xNgWqATSDMuqx/gnhk68f99
         NOxRSc+tTIpCMdPe1EZNvY/UVvMNtDdmD7C7Swat36XJoQipUU8JG3FvHOuqw/lm2QFF
         +HVinIB/wyAKmLkE3Gv/s4aOeNFCYAqCrvsoPvrfJ4xIbWuPnsgbEXmH3HeLV3QsaMUp
         Qqng==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795454185; x=1796058985; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hTikqUPwqyc50FMehutzNCz2ncKuDk3/OGCI7AzQ28A=;
        b=U/zSqU/1dAf7AX5w3kptujAXiS/93cIZbYhB/8yIWUcxZfHbkZfjq1NgUWMszMJHAM
         CI91dJf6HBNp8v9UboFEfkdwzfDv99bUg8+KJeTGAA9dIxobixHznyomnwgM69faal7n
         ySgc52OphT3vdj8n22tmXNFjww/VLbimCUTDpAr96BxjeLRyquEt9HRPNiSllXUGIexJ
         f7X8yLZI70SYibl/jsiB5J+B31Pq+mX+J3gQG3E4k9i3KxCS9VBpPJGDH68a/RzOlM0m
         qT8dOB0lN/O7n84UKYqDy8nIevbxCv6Kuju7cH2xv0ImKvGpTpBuZl8tPlQ71b16QGos
         8RSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795454185; x=1796058985;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hTikqUPwqyc50FMehutzNCz2ncKuDk3/OGCI7AzQ28A=;
        b=A/DZokmyzKM9A6JP7nNUT+r/wrObL16yJt1ZrRVu7sNr0bU1SQb7Ks0SJE559S6a4y
         XEHR7qGu/bts9aSiwrI+ZnOREzd9LULMZSD3Y5Pmx5Teb+07P/cPq9S3IWFwbTytSBzb
         VqcPUy42VTObSlU3b0YoD0x3DqSqp7eFST2bKPXrMOuklS6nhKGfE8ncnmVSPHv5Wn74
         RRjwp4mLOVwXVvGzgOkfH9PeALTJSJ9LvJ+oS/J7ZGpQCCMB5kkhI8lpL6HbqePfiHXu
         Vn8bGy/fJePkg98JNYr3+tUZhLxJUNfBdtqe1kY0Rw5XfoZ2jxvSuOpQn04j+BusHTKo
         6Afg==
X-Forwarded-Encrypted: i=1; AL+hErFPYSxrn9dPU9UxkCeTDlW9uRHSZiO6yebNRoZk7tM3gNU+r+v2noa08Hh96nP5UGVX/2tDIGeLwA==@kvack.org
X-Gm-Message-State: APuU4Z9BltKgE32NJxOJieUupVLfTgdK3EXnwaoSEZPYg++P/Yc7uaRm
	/MXZlIdlMU+6/mB2ccT5g5QU94Yzj8/6T1eTjzCO2LyeX15424j+5kDGsUlfPz5m7QdAlma2r9s
	W2J0UrhPbtGL7JzPXrW3Tb4y+6DEz2Ps=
X-Gm-Gg: AZFdTZf3+4rwI+w9ji1M60XAok+nGahRidX7bNgW+5cHR1cM753TzuXBtZlnUNbznlP
	/8Obl3cQjmnchW0sCS49BHdqIFqylTsGRKWBb/8I5K5YTjI8rrjl7cbwMYM/JecrJaO9e/LTW4h
	PPDFbfyCiC+OIYT2mkNwBToOwY02hZpMT55NFfe/qQWD153LUyp4ig59mY+XUHVqVHQ+Z7N4s+g
	ZqOIhVVmABl9kfIuWi1qZTGfXjK6SYHFz/ZfsQjgvh+Rfq7QEzZi5+7kzk8zDOcCFEaPje7iQD2
	yXaBNQPXPMQIqOvwQ+SRKCQOUa1CpEk8R6h+2O/Avc1QFHxl7f48KPGiO+SeEin2d6hhun5zlhw
	+/PZlSELku8CYQ9PgqdDBhQDpkPQ8vLvEckUDtqR0NeBPbLAFTdsvRb013pY9y+RM7pGJGe92Jc
	zvJBdCkkvJBBQ+P5fDh+sBm8+Ba/oTewSBDFNgm9Lzp8zj4W/XzvWu
X-Received: by 2002:a05:600c:a085:b0:4a2:a9:ed87 with SMTP id
 5b1f17b1804b1-4bb88811c75mr272447135e9.19.1795454184841; Mon, 23 Nov 2026
 09:16:24 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261123032512.6119-1-raizudeen.kerneldev@gmail.com>
In-Reply-To: <20261123032512.6119-1-raizudeen.kerneldev@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 23 Nov 2026 10:16:13 -0700
X-Gm-Features: Aa3M54rfVgjOdHlfCA_u99G7OPTAv0jJRAR-jRxCmNX7C5t-zjR2LD1E9wZP3bU
Message-ID: <CAKEwX=M8m6iKXApiCLqQR3s6_dNvZG7MW-bUWGSvbqGkcQkzRQ@mail.gmail.com>
Subject: Re: [PATCH] mm: zswap: remove dead length check in zswap_store_page()
To: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Cc: chengming.zhou@linux.dev, yosry@kernel.org, hannes@cmpxchg.org, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 59zjcn4hkq9wpn7b94fcphef57hwhmai
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9123010000D
X-Rspam-User:
X-HE-Tag: 1795454186-273663
X-HE-Meta: U2FsdGVkX1/L/XssYLh9NQUBZnt87NGgqPk2rnFxH3XJhjFDXs7Y4hOOGnZipNllDRM41gPmsXBe2UqNEWFooy45Ji635OSnJNCgWKqPtbjAqfjy4IKwsBMe40anpOmgsfuCOHk6vL2OkvLjkZXz3gymFE2tNaUAAgyBfSpo7xFvTG6Xwh1eHFNIZ48zW16NXhEYxAJGXt4YQcp6oTE3c4SJ11YVXIa/8shg3eo3p26G4mdL9RLmbmNiIfGXsINcI8QVmsWBw+J9lDWNNxMSK04cH99gjqOj6d3Lh2xQcVSHKghVF+qynMFmnZ+lDP+fjnS3e+tgyjekvNYGowtnGXGjFLhrrluNbHMVJEuBYRhot8gROi8xlo3wKev8vHILVfJZQHV89m17lAQH/JY5CdLqFPxDsmkzCjdWeP6GMhwCzrwgd3Mq0Pb4sD+pcjOMF3I5KxYbKNm5ng4LB8DTrc+51uEbYDLxCZf32HTFKLGAx4kro+cC5IBgdFaeYXhUkWY2Aegu2gi1geKTXyUK3J0282mAfEkPXhG7QEu/h5CAFkczMAuXHgERbZUYnVKfAqc2HUhggvqVgEjLoXj8p3Tzjzt6CFLw+bpXFJ1VGU+R8NegLZxcFscHRnKUNerQD+UzLS7H4IN7mspzY4QMeq/55QjtE4QM9192MSL0VsKHalm345dzW5CSEonmfCr9T69gLRFasAnfyOgNYkfJCA94QMB/0r670fmOIUFMB/ZmuaBFSDljf9nkkx/FP1fHsb0LeGBkEC1hbrwz6j9irA38FgTI3WQ3UGlcdfmrGC8U4jLTd5+BBI9kfhMIeD6eEH/DrqWPYSoIj49IB65mEXr51xNUTZOZRPmkDWPFN/PDYF+q1C6nvmor6cX9SYFf2zK9Ij6O+fPok/MgUEH/gRjnwYIXpM10YTxeAFdQ3LQjb/VO8AsEzaRS5gFoowf/8c04m1OB+XGNBB+H7tR
 s5etZXpe
 r+cSfQr/La4HPOkP3GUKP+/etYKfzs4zAkI2bXzOoJAVSP0sWv8Tfa9RTspW9diV21+elILABYDMG9eElSPBa5zvtQfvmmMGa0/mhZKfHjTPGE2seXTs2ON+J9GedOnTsFc24KCUJF+jbzgO6MaZGBWdCjgWX68lvAXha/R5UpLs5tw5+b/Kx1jfx/zYkys7ZmdfhlHyd7lPPerEc9FnhE3t/YViawlVCWGaQIyQNwjyC0s3Y/9VwRdlH4wzSoQ3pY99vfFh9IVXCTsX1qe01ibcpWT2HgC2wDB17TzRxvnaKah1gcGW9in0eGkmr2NoWxTkD59I9r5H4yMK56whzDaAGQ893uW7Xlh+LzmkCFm2A+KSHMQ1kIDOEO83hFOboaTzY6DrSk6l3Mvs8rrXmYQ8uzJFw12+yxaApjkqtt2YrZroobUURpb+A7IsUbV1977LNpQvoaLTPl88XDEFAlQqQSUX5P1G0P9mFk9sWNt5yOzO/KbFSFqNtNqhYkYlGZ+vaZI+FGfhFbE+A3u8BKAUoV2qsME26fbpvjGlsDNTt9NgFdDvIHtB4OKh7uKryCzwf5A/b4UJNV9DAtqA74J6/kDSEQMYWiu5K9v4u3b1mY1j+Pf/It6M5neo3ms2P3VjaTx7MwQucXYPFsEqdU8htU2zdUD1xgdszaaBTmiRLjwzo+Ug7+teZKq4eJbUEWbp18XRPSHtDqbD9vEU8pF/6a/4ITShqo7MIAQIFbBt1kVEm/PJwx0Lhr42Ftz0QkF6d0LRkYq5UO1GVpaGaOh1QqCPG0vSkeTChmkw6V1uWPrA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 22, 2026 at 8:25=E2=80=AFPM Mohamad Raizudeen
<raizudeen.kerneldev@gmail.com> wrote:
>
> zswap_compress() never succeeds with entry->length =3D=3D 0, so the
> condition is always true. Remove it.
>
> Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
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

Acked-by: Nhat Pham <nphamcs@gmail.com>

