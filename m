Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 284CDF53D81
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 18:20:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88E256B00CA; Mon, 16 Mar 2026 14:20:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83BF86B00CC; Mon, 16 Mar 2026 14:20:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73E606B00CD; Mon, 16 Mar 2026 14:20:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 614AB6B00CA
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:20:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0FD2C1603E9
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:20:28 +0000 (UTC)
X-FDA: 84552741336.22.50C0AB9
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3F5FB1C000F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:20:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=acXGXFV6;
	spf=pass (imf20.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773685226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=whl+jSHmqX1To/01dzedEyQPCGN8UBibir4a9aB04QU=;
	b=lWPuDbOCFqqScYDQcGyeOpV5MPhwxbwgUucYpgAARhP216CwUFzZ23uK2K8P4e6swaY4Qx
	6Ayx0hFZFVl7Z5/tzSl09VQui6dLG1RSfy2oJIHKqGX8VnenC7cRmTegLL/ngY1m7L+UML
	5kAGTFR9pBxAo4EL1zhtgf1MWyIOGdc=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=acXGXFV6;
	spf=pass (imf20.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773685226; a=rsa-sha256;
	cv=pass;
	b=5GXubAKA6UFhGqvqWitmBEG0XnLF8hhqMWLPvFhgk1mxAYLtGsA1LZfzHE8NGFuYn7ttJv
	l+DHSEtnWRSlmc0xzkvJAUbUITOoA4JnFQlb4N72z2j2sP4b93U5hFenWAFPgpgc+lvfAC
	y6szafWSuChgPKteH45EXtFDvMN6ibo=
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-2b4520f6b32so6897798eec.0
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:20:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773685225; cv=none;
        d=google.com; s=arc-20240605;
        b=dvLpyIb9CfhFsxVauP7CzLK02pSuyCtpMflYnRnuonPiUIqkQs4wzFNuWa+cypPMsr
         cYQmgOqXZG2o6Vi1Q5NbuGb3gCYhd2YWqwx/Z5IkErQsjpkeutUj1Za5ztZRoG7uCFeO
         ZF+WBEJpBo35imuDF6Mpj3JnQ0rwBH71RnSLAqcxo7vBCn3OqFhSzWcvIx2zkU4Lmw0D
         NlCojo9AxfFNQ/i3Fb4Wn+zE4fU3onUWtwoXRwWPTsUR7ab97LibmWa6zzKBG4I0X2VI
         r4HvWng0EU9wt1HH29h5Hfc2axnB88ButAiK3kzvQMr4/W/kjDRmxmDVwAjQiGdbvu6o
         aXlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=whl+jSHmqX1To/01dzedEyQPCGN8UBibir4a9aB04QU=;
        fh=ay1PkBTQy4NZHGWsr3jb0KDeX0LLrgNeL67pmdf9RZw=;
        b=BPnSQdPuqCBK3YaA/aFn2vYnsPMU3aO73PY2sQZi7cnsu0DdZ5XBalwfTMBa/1JfC/
         pGFurYLQCokETrvb6/7JhqLwP5KN0XIBMKaZ5yuiwTa4+esHrq+nBYbGpXNKG8IMKudm
         jEtFb0Y5HvwwzWXXjnwWsBREk9rcR4IlxEGSdrmYv45/QLCnixsHSuThjyeMHKUlEKay
         cmLQgnUU9MWAz1+49XJtbsy1VgYHFLFSIcwcrKJISNcD01B5NFTfsPUkMaDyvKEdGW4c
         LpGC/W7+xdlBI30xQIuibRnKvKd6UAxLYFpLq3gHgWLh3HPkpAmDDN7wmg0AXQkrtiMk
         tuNA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773685225; x=1774290025; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=whl+jSHmqX1To/01dzedEyQPCGN8UBibir4a9aB04QU=;
        b=acXGXFV67K8lDUEeK5gntQYV4X5kbHv6ALR3I61r+dp464nFiZzma1nZ1O8H5UNQ8a
         EyTH+BkebgUfJX0YuLvL2wNacPCvt7tkBrv29xGx/aMtaSvsKvMM0OzhjSZcwkL52MK5
         pwppCow+jCEwMMQBumuwU6s+GmDnPoPMd+agQ+KSPy35xiKkErQ9cQm9+Kof/DnpFQAY
         eaqMDlbuLPMFs+nY3H82FiSwegsn1z2as8fAYit5jBPqlHYSre6LXuVySGnR/hCMTp1E
         lSeTkkPjkkFBy/Z5lF4bGjGVVTozA2Umsk6QvKrcYAu4opcHnWXZbg29b3s/jp7zUypn
         O05Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773685225; x=1774290025;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=whl+jSHmqX1To/01dzedEyQPCGN8UBibir4a9aB04QU=;
        b=Zs+uyldvd1PjH8r2YEx+6ucH9PMZ5VWSOzuwPcKe3CRiIgXJa1QIu5tMH65ErbgBNL
         dbpZIGdKOO5XAhvpmjoY5hxbn7lqDelKt6XfWTasJQ6TjNm70YWtmW0o6V8qy0X59hea
         U+N6cGfWNmHKDYlb1Bc+CRazfzQlEzP0BWr9FE/TnY22BsMeX2MVUGeRF53wqrV9YV8j
         qvAK8K/7EAWyasLQEo7USUjB4xtmLdXUTV/sPJ5LIA8QPmfUTcDqZoOzmbqWI2Ni4luR
         JvETCHTddF9RMHIVo6igQt/82jFYFeylteFjGxbuiV79jRZ/qgJrTYFSn2tl54QvtRso
         e+EQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+YsTFXW9dg+2Ts8Lf0eo/x+MexfEJjKU1HjNi34RDCwYbYUw0YWFL14s9ubMLfizL7TBxKzcdFA==@kvack.org
X-Gm-Message-State: AOJu0YxSWi6rJPyHFqq0/3c90iN9wDGWUfUjad60LIUkGesDebKs7vPq
	47kP8w79gqPnf18cVkAdCJSUN71x8WMKN85rPcfhJj/+mnPgjVhF4hRsCpLGwWdjBvIxA2Qv2rP
	mGUc6Pq5N8+owwwPt2HqD//KLkjSLkso=
X-Gm-Gg: ATEYQzxEklQm6qf/EDP+tCLWYVkJufoGxMF6FW+z1yt9OcGkSIXlm5jX6ORDQVUT9pC
	Xz9B2BlGCrU2JmP5aotQ+rBohmLZMiom+GCtezQScjKKRHMxQaV8fn9rnr+Gdhh/5TLymhpQPyp
	nB3JWQG8Poj/LBG92IKqJGZcNb66qncJ1lMDJ3OxWdshJb9UwUNqcIbZ9vcYib4ClWn8GhDEhZF
	b76xyjXCpaUlPggw/J6H0rIUIN5ICaEH4NxdBTdNFcJxb1DcyPgag5ijicnRGgbIJ/ZQmhv90cn
	SmMybsNIZTsmveqaspjS7HYd
X-Received: by 2002:a05:7300:8b83:b0:2be:2964:44c3 with SMTP id
 5a478bee46e88-2bea547ccb8mr6294076eec.10.1773685224740; Mon, 16 Mar 2026
 11:20:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260314051632.17931-1-kanchanapsridhar2026@gmail.com>
 <20260314171150.fd6a80a8f51a5390144d20d6@linux-foundation.org>
 <CACpmpodjsMELCrJ-QX066CYiGgraysr_ZhFMvU5N-6nr2HsRsw@mail.gmail.com> <abgbx0YXbxu2mAHU@google.com>
In-Reply-To: <abgbx0YXbxu2mAHU@google.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Mon, 16 Mar 2026 11:20:11 -0700
X-Gm-Features: AaiRm53SgJc7QPOWee7VxintIM50rtF8gXbOVjKKVT3lbvnfqiKE82CHN4oG1IU
Message-ID: <CACpmpoeo0LhxkoA5Wx6q+9=2scn_az0u=3bar-JgBvTA-ZBkZg@mail.gmail.com>
Subject: Re: [PATCH 0/2] zswap pool per-CPU acomp_ctx simplifications
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3F5FB1C000F
X-Stat-Signature: 1mzqxz3xht5ssr6jhdnwyt1ad5hyhgdg
X-Rspam-User: 
X-HE-Tag: 1773685226-173201
X-HE-Meta: U2FsdGVkX18SuD3p3sk6U68TtLxXwKlj0Mdj1Ywz2ZLX+xBNz6rv+uC+0caGtCYS+qf3qHrHkFaEPORh7XTBMuT4D0nh7s24v7US+kOh0o0kATUwrdaWG2eALGdkIrNM379NLubdHKMnr741b8FEFbyfv/9ruE0nCV+Po9UlDLNXti5BdXYPSDZM8FVa7xhLQ/LqBfCrjlHFl+hSvmkgGrv50aSHVFqaKYyU820m+gNZvF62tndUM7nGfSgkfVg3P5OF7Y1xvwyuCZEM76BUJ2HkNDjEGHGt2FVqYbJRqIadt6vnsFNqlcCJV9Tk+xFv25FyR2Y0v/yh2teT3+V8luU1x17fkApQvjy+eQwCYTkel3LiBZS81tqdKY7dG6FUN3G9X781iB5GJSI40sk38RwAOX0ySaFDoGb2iIzJyjvrxfBvzxIpFg6asWmkb0DshNTmzJvtq7gKMVZX/Q3Lb01PSciaz11mYUfexvheXieSi64EKysY+qylhdqkuVvp4ylOllJ5AnrmwIPpiwtKHwbFCiZvYL8y/ronkIGvcBwQVFWqy6e9vLYJlNTAZHNI5Cwz7SJheIEIxfyshDpYP0tRYjcQMTKX7a/vou+nIu8BrsXbGimMF23WXu39CIdFVXSIABX/jkCEUzH6UrxQ6ie1jTym8XD+8zzOanmQIjR1wf/oK9rx9r8NDjHf9f3eHT7inCJeKI6ujTvRTotkPMNpnjc8Iv3iI4RquUFi/KjJqnvtUhmticKeqFyiTCfRuolq1QXmJYynfoxdtQvrUuadKDDk+M7GwenEouzp7OzHhREpWzUrBZSwcBnDzL1SsMzWleJOrGu2gs2S7YqX4OHRDGD15c1lLFRglKY0mn7BipMHKE0scQgF2bWDa906qSkzomNO2d39HxgOfD8hMDtHhuQBrgmdzttHIi0Cwf//oTrfwMoAm17ducTs3Aae6Y0lLiBOtyA5nGPMHi3
 WHZYw75r
 lSztlS9Xv/B0YCdRPTpHB3nhiWMiSkWxyefoW5zdrfyk3gl3A3y4yxonWfO2EY+/Cpap5xM/YYYYsyUyXxpz7VQckpVBZuJHeByuAXtxQCIpGTck=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 8:06=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> > > > @@ -786,7 +786,7 @@ static int zswap_cpu_comp_prepare(unsigned int =
cpu, struct hlist_node *node)
> > > > return ret;
> > > >
> > > > acomp_ctx->acomp =3D crypto_alloc_acomp_node(pool->tfm_name, 0, 0, =
cpu_to_node(cpu));
> > > > - if (IS_ERR(acomp_ctx->acomp)) {
> > > > + if (IS_ERR_OR_NULL(acomp_ctx->acomp)) {
> > > Does crypto_alloc_acomp_node() ever return NULL?
> > > Looking at the error handling just below this check, if this were to
> > > actually return NULL, PTR_ERR(NULL) evaluates to 0. This would cause
> > > the function to incorrectly return 0 (success) instead of an error co=
de,
> > > hiding the allocation failure.
> >
> > This is a good catch. Just to provide context, this patch was
> > introduced based on Yosry's earlier comments in [1].
> >
> > [1]: https://patchwork.kernel.org/comment/26282128/
> >
> > crypto_alloc_acomp_node() currently does not return NULL. However, it
> > could, in future.
> > Since the rest of zswap_cpu_comp_prepare() dereferences
> > acomp_ctx->acomp, it depends on whether we want to future-proof the
> > code to handle a possible eventuality of crypto_alloc_acomp_node()
> > returning NULL.
>
> Hmm upon revisiting this, I think keeping this as IS_ERR() here is a
> better documentation for the API, and the incossitency between this code
> and acomp_ctx_dealloc() is arguably documenting that the function can
> only return an ERR, but it can also be NULL-initialized by zswap.

Yes, makes sense.

>
> >
> > If the maintainers think future-proofing is beneficial, I would need
> > to handle the PTR_ERR(NULL) which would send a false success status.
> > If we don't think we need to handle a future NULL return from
> > crypto_alloc_acomp_node(), then I don't think this change is needed.
> > We could leave it as IS_ERR(acomp_ctx->acomp). I would like to get the
> > maintainers' inputs on how to proceed.
> >
> > > > acomp_ctx->req =3D acomp_request_alloc(acomp_ctx->acomp);
> > > > - if (!acomp_ctx->req) {
> > > > + if (IS_ERR_OR_NULL(acomp_ctx->req)) {
> > > Is this change necessary for acomp_request_alloc()?
> > > This function strictly returns NULL on allocation failure, not an err=
or
> > > pointer. Changing this to IS_ERR_OR_NULL() obscures the actual API co=
ntract
> > > without providing a functional benefit.
> >
> > As of now, acomp_request_alloc() returns a valid "req" or NULL in case
> > of an error. Same question as above. The only benefit would be making
> > the code more robust to handle changes in the acomp API in future.
>
> For this one, do we need to do IS_ERR_OR_NULL() in acomp_ctx_dealloc()
> to begin with? If acomp_request_alloc() only returns NULL, maybe that
> should also be a NULL check?

This one is debatable, since acomp_ctx_dealloc() is intended to
replace zswap_cpu_comp_dead(), which has the IS_ERR_OR_NULL(). I think
replacing this with IS_NULL(req) makes sense, but would like to
confirm with you if changing existing behavior is Ok.

>
> In this case, we don't really need to make any changes here, and I think
> this patch can just be dropped.

I agree.

Thanks,
Kanchana

