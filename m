Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C73AA606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 06:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Kr1YbDCP
Received: by kanga.kvack.org (Postfix)
	id BD8D86B05B2; Fri, 30 Oct 2026 02:19:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B653E6B05B3; Fri, 30 Oct 2026 02:19:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A03126B05B4; Fri, 30 Oct 2026 02:19:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 785D66B05B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:19:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EB0621A02CC
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:19:00 +0000 (UTC)
X-FDA: 85378289640.24.D36E734
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf22.hostedemail.com (Postfix) with ESMTP id 07336C0004
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:18:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Kr1YbDCP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793341139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qXCUTOuwagzXEtAyZOHJD9pG1akrpFTwm8J5Srg/dsw=;
	b=ahStdvAUCbZj0ECEBUp3l7IMK/dvbuufDfVl3FtVOAJUeUSmKA8h26dD0rznHd6KWjOlVE
	U3792n0/370bqngIkiUphjbKuUO2Zsch2BXBaQQBTHLRWmXXleeGy36L6f9M0k+eEVTwt9
	+YYuOjwhCVOXFvjv+xRn3Ajuz6g0vyo=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Kr1YbDCP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793341139;
	b=e9GgGK0jHX13xrW7Sb3yEGPDFmGVI62jeoKMJhQDXzD/twnKox1glmoDDhVxYb8Q8xIjik
	5VP9J2i6xlRssiXGe8fod8bka8WOjpdFzz6pJHq/4fvh03JOb6rZ4NyRhbfPrpzD06ozm2
	AL7tsYLl6CiQFghsxo7SVMnYy2GOMrY=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5ba36cc21cdso642026e87.1
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 23:18:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793341137; cv=none;
        d=google.com; s=arc-20260327;
        b=jAPRWZbeLFzy+XpVQSkEpyVErZgEoO3TG2EvsxoDzw4AvMAYNiaUUzRZYPejbrflBK
         w5L60a/j1e/0lLSsy0WF6vFtrxV0rmGbw7JyJvv142wRrwC7IPoEh4M/p9rwLsQnL3pJ
         6eI5QNySZA1/uHTGECwOOA8Ie3MvVfSTX8Dj1JCmbbmBI+TQyTdbDFBKL9lIVE1bGiJC
         AK8N0bka2yT/FG0stYrEKfvlfPXfBSJlHQ5jEBe42H+qxWyXQNdSngxALJasPDqrsHGi
         Gr4OOW86ypHneKdqwSIEoHT1cEt24xqbc+yMHP5/XLTbe51BDYWtEl98LpA+r4BURDhO
         oVFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qXCUTOuwagzXEtAyZOHJD9pG1akrpFTwm8J5Srg/dsw=;
        fh=6QWyi2DT6l/cr8EALf5puXXM/0jmrWAescq4JXdwOe8=;
        b=EYlVoaQVMzj+gbRDqRTaTd29Chs0bwDOOa1A6vL1z2zHJ280Sg+gPpkyYhGqHRzsMx
         Kn6eVFrWtoi4SoAyxjaS3gb6En6A/ta5B3l8aZwWCv0kJ/5Tb+vmYuI0i1uksbg4LJtk
         /oObik8T4dYDFOee66WcAFTlvbEBAcib06wysTrhf/+ljMgzfvhxv6a8t/XfywmSUT/X
         wjObgjnFV/njjLHfuAg3EOedM6+gULP+VIIFiqHbs4UioL9Y4blMl8rP6+QS3Sz08lwX
         ETuug3uuFCkoQhl9c3uDQdBszBJIWoEr9Mjw5xMlVYUKg/Z2GyjWibh1umJQSVkJl0L4
         TMcA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793341137; x=1793945937; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qXCUTOuwagzXEtAyZOHJD9pG1akrpFTwm8J5Srg/dsw=;
        b=Kr1YbDCP4On5awVn+cFNwk4EQ8UawtzRP3NCOjzvO09bLs0dlWv0m2tU5OS76jn7H0
         cy70OMU7AuOBrNqPYgudD68YHECyfg14GguOE1mYdjwL9Wvo+G7s5Zf61qk19toac7ig
         vTF33YrLz3issjWVcvgDZufnyArURQoUZygtPmwt/qyz6eP5k+RlNbLXAeE9iLErnAp1
         pRJ+pz0XU86D9jVCP0MWYsgKeZsEvVvZFA95CoByjrIgrH7RRtnErIo1kFZJwcjCw9fr
         XNrtdPVuFfxLLNvzvwbUMjK2Xq3B21uwGo77UAj1EjEyCoi/c6PknkXGIxv28VMph9gj
         ID8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793341137; x=1793945937;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qXCUTOuwagzXEtAyZOHJD9pG1akrpFTwm8J5Srg/dsw=;
        b=B/PUIl8CAc9rehjzQTsxNNYAGduVrYXchprd5WvslTVdLWBdCOyW3mfN5uVHWV/Inp
         qgK7AMhagoLfHnVsXz/xXXOthnAsJ2Bf/k7MieGkiItOrv3mWoGQHNqw5ciOu4gIUhBU
         UJJOjtiAb9uqd99gXv+CwL5cikAVuzBZinF/nQYl/DcFT3bp0Q8g3akD3gLecWcJn9+z
         YW+C1rORGHD/hPVsjFXk0cFeYAGvxoRpTSF3c+DSoTJF532mTC5h4j3Oa9DRAT7k36Gs
         uLSF5/LhiUfqIRgMEnD2Pc8ETGYA/Rd2YGeuZoABjtiK+ZKPrE8/T5CAaRbiM3MLPQVC
         lYHg==
X-Forwarded-Encrypted: i=1; AKwUvBwxCzz+EF0DIfVJN68M8JkkBRpp20MJywAEO2NuoixiDnWhFs9GHRUKH8DJfnD90V7c9IWNQB+8pg==@kvack.org
X-Gm-Message-State: AFq9FYLcQHgfwN5tpXG5wppr1oW/s1z0FwHfbQLxtvtdPyibBH6drMSp
	oT3pd8dW9QXnZiikfx5CGYnVLakwzt7+FcwwtYR4NkXIwEB26hpDoDPXkuBIYIIPv6wclA30mcR
	VvAbCFp84rSh6dXn9XJDEY19yrIkiZRk=
X-Gm-Gg: AYBFou0xX+PuPv2PuhCxHsl3V1gIC/Svqy2xgHIOxFXrVucZAJKfRDxkM3Qx1SOunR3
	BZoFpXt1B2tfKd3yMUXqD66mFOA7H54yvFNMoO1puS0yoD953FmEcy7/O9/AepBYD0dSCdm2xU4
	fAGDbSMd+PRL+q6h+OazFg28zwHZXaHHhxN77xj5XpZAO907LeuKEMrggbfjrtkl82i5dHCpZmf
	pQ2xR+K5j/nX/XkW6RuTIHTMVOAGNLXhxNUNl7OQ1g0KeIVZuj0gkvMCkj829exVso6n38Q/Yl6
	KH0E549qdxm9jdDE8zgAkHE+rRmzMEMRJDCkIWjCnU0vLaoAy/LhgP1h4E8veeeKSqhSfw7uogo
	eyak0GpmIxqMnFJgHs+qFTb+tpfde9BgCB8n2
X-Received: by 2002:a05:6512:4028:b0:5bf:d7fb:dbf with SMTP id
 2adb3069b0e04-5bfd955f145mr364874e87.11.1793341137385; Thu, 29 Oct 2026
 23:18:57 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-7-kanchanapsridhar2026@gmail.com> <sashiko-outbox-188658@kernel.org>
 <auQhULh1VTh6lWoe@gondor.apana.org.au> <CACpmpodWMtmE0yNVN656K-8fPZgTj_DSZ0J7qxou+5Asoht+4A@mail.gmail.com>
 <auQwWgMbBuo0YEBI@gondor.apana.org.au>
In-Reply-To: <auQwWgMbBuo0YEBI@gondor.apana.org.au>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Thu, 29 Oct 2026 23:18:44 -0700
X-Gm-Features: AclHuK9qSwZmk6xcNKVjBmbt8Cu41-hCRLHUBZIBg2QtW_8hakGVd1OzTQBnFWU
Message-ID: <CACpmpodxvQCkQgXUU6pF8d7onxHvHF7sEYCbTkv81WXyyrFiEg@mail.gmail.com>
Subject: Re: [PATCH v2 6/8] mm: zswap: Store large folios in batches.
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: sashiko-reviews@lists.linux.dev, hannes@cmpxchg.org, yosry@kernel.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, 
	linux-mm@kvack.org, davem@davemloft.net, linux-crypto@vger.kernel.org, 
	rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 07336C0004
X-Stat-Signature: oc7f5xtnfk941strhcewo1y87cks5kzk
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793341138-635230
X-HE-Meta: U2FsdGVkX1+UZyAGDWqzP3PhjS0/AStEWP+F6gVn/E+ZAkmgP+E/rRFi5FLLkdEnnGi6v5NzaPkWoxonGBpqPel2r20TsoBoDj+kkAqdTho3R/WhGFkk+K/Zy4W+MDe8/NfqFg67GiQqe7EwHW3AHG6V7eIpf8Pq812i0eCdbGezyC3EG3t9hAeDDfsMDwRlUFN6fdTJ5vDiJM08gV8yd+VHkmyEUvCvubCZ6t49U333CtYCSxIjgklUIK817ie0QB531hzeSF/uahYWgia8AomD+9+fu2WC2GEquEIAWY2xYOM4MLDNGuyiByU/sjcX0WRwxHfU/Q8jzMKavcXtVybWII5ZnbXcw0ShQhSJS7A0u5Tk8/rkyRvtJAuNSYY1buEd1f/vw9sT7uK+5epx9RyE8YVouwtQ+qPdbOvHE7jlPL41mTO0f/cQVcSKQLS5M2oP+Kn/C07sV0ky/44CxLucyQlIJGB4Pp/qvE2UpXkizlSQUNVYIsjtz4RnfrWZoJvnMhionmANXZSjhNarR7HJv9PkVIZFsszpqYc3ysGZOP+U0971N4u2ZFYPjfxDMGNCpW9YrwcFVivCSGU7evw7xloJYE7mQjFTUF3VNTjkNsyQLF1YWbjH5welNkoRAjc7yAqgfjhRrI0QxrOad6xn59jiyxa/yepihCR5HF3xc8ABGVhLh53hUGaZ3FpXK45e9Mpo15SN6ZnjpbkOpsZKUMP+XSIhgyUbHv7utOtUB5PsfAdfheEG/MGZ5Yi71n76lKdgLnPmN67/OCkdISqd2L4aJULrHzgedSO57bFcgYsgdZcXxJ1KP8gao1dkFwzTzvHHAMyhdzKozz0OSKWznyRzqjrEGDHneISI7RZ2b2EWmkCoO/QyQmxttCDKyNwkGp1sU9HcT4yAu1l2tdyLcy7xDKR2GGclPhCjl4naxUdxqO9hQapbaaeaIN8iqxgTRG6IWkNO6o13S/w
 adWcYrT2
 CwC/qCYHb+eKKDmwC4AO1JYkkcxs3dMXmffHVWDqJ8zjOFgwgGo3O2Nj+6tLmKYe6TP9GZVUHKkNuMbWbZoE1KeZJ9msmXYO3/vqIesdWyZEPVO5zwkoWT6axssjRLYmFk7FpRVBvH5STwVck2vIQSPXRBADzBJMuclUIACrG37+Gyml3DD/6U+zRxGWVRNV4coVyW/2/MYsoiVzuJDPz6uOl0wRX9r+3eLZ45YzkT1mFeEX3zSFxWrNPJ47YY/R/chPBBw6c+ThaofsKgHG9JKRrEituABiHquceoglT3d9GJwcOo75Vw1w/Au8X+/uv4+LCZji6xKysuzwdgRlyCUsFR8NYrcpgLK1POmm6fwDv71B0Ryd12pRA15ZknlAiycJlH4wzrNdiUwm/Jb35YKVMV58nYjqEUQ5nMgzz//wWJ2E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 10:51=E2=80=AFPM Herbert Xu <herbert@gondor.apana.o=
rg.au> wrote:
>
> On Thu, Oct 29, 2026 at 10:15:15PM -0700, Kanchana P. Sridhar wrote:
> >
> > This is how it is in the current mainline, and has been for as long as
> > I can remember.. I assumed it was because we need a per-CPU acomp_req
> > to be allocated for the tfm. Can this be done with a single
> > crypto_acomp for a given algorithm?
>
> The request needs to be per-cpu, but the tfm does not.

Great.. we can save a lot of memory this way.

Yosry, should I go ahead and include this fix in this patch series? I
am Ok if you want to take this up.

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

