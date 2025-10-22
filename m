Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBC65CCD195
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 09:44:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7ABD8E0003; Wed, 22 Oct 2025 05:44:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E52398E0002; Wed, 22 Oct 2025 05:44:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D684C8E0003; Wed, 22 Oct 2025 05:44:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C694B8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 05:44:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7916C47C47
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 09:44:03 +0000 (UTC)
X-FDA: 84025263966.12.FF53FAE
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf04.hostedemail.com (Postfix) with ESMTP id A8FEC40003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 09:44:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yFHkAiS2;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of glider@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761126241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UIlHCnSUg7Sz6EMxU9JoMcjFVpE9+lYXJBhrkV15us0=;
	b=wkJ4nQ99kx8P1suVJj+Zl39/YH0nam3hohhlKZaIVk5llpGMJlYTXYz9ifFuMDwtXosrme
	gcEi3F6aeZXBnLU3ZR8kyaTiUqWqfOiG8j30DvwhQ0fNzAcoas9ggmj8qz6YQan5jj3Rrq
	0la7JBXHtAuJfY4RzEcFiHlNg78203I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761126241; a=rsa-sha256;
	cv=none;
	b=HVPt4Qc32rmDHnEaSr9VmiWOpR1akI6iMQThfxgEyB39oHDSBaE4OoWf6Rpdz/71vJ3+6F
	RzRPEoqIpYHF4namJ0eR/wveOLJLYyqqyR+gf2V+l8T3bcxYQPKkEialWfmjSpAVE9g9Em
	Tq9Mv+XrPu6gce+pEbUbKt4kmsMv9JA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yFHkAiS2;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of glider@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=glider@google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4e89de04d62so8391801cf.0
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 02:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761126241; x=1761731041; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UIlHCnSUg7Sz6EMxU9JoMcjFVpE9+lYXJBhrkV15us0=;
        b=yFHkAiS2QgBEnIkHM7W3O40jhA35lWl15T1CFijGO0RLT2B2jsbK7varspYAMlEV4n
         s9p2QfkHQdX4nMqHFrX/HbwUtDXBEZGoDH8j4izXdWsGMPz6Is3ENpCN8AUUsIn056Z8
         i019moBzyHsTv2xLTwn8htXXVLIOVfdE2naXs+flLrxFBM3KAIm15mfu6KDaxLsfrXWS
         cM2BEAtLh3P09X8cdSsBU2NFb7Zj53DFrPhsQCYEvUqIsC60wn4usZdE5cUtTXvlfjCN
         WF6yIMjZCrbhRWl2V/1OVqfAvRveIFvP/Kibxc8/seI9s38ihUsmgPyj+Q5jZ+gb4l4O
         6MGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761126241; x=1761731041;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UIlHCnSUg7Sz6EMxU9JoMcjFVpE9+lYXJBhrkV15us0=;
        b=aF6xQSorgA/slgvcVlWocT3sRFXk5Nd7f0k7e8wrF+dFUyYDNi+AeMlaIn3M89Ycrw
         eqswlaG4EAn3qCcpzFWYCjwzQPgM4FaQev6zOzg0xN7nlt3C51acTaDqLhPqh0CV1reQ
         BElbPOT99JYCuDKeFLnXJX2crfbvD5nq04ibB8IMccWeon4h7OuWVq4tS7s+lWZzlQql
         0RWj3JKhe9xikjnoPmh4EPg47qP4/+npnOywN0JixhdFwWp9SP+c6qhWpyG5mrtZAPC5
         Bzo3JP10kFpwp8nypn5bjSUGbZBGj5joGEcakiU15/Ne0Jx1rBT8x7AlUfuKdXp2E0bh
         ua1A==
X-Forwarded-Encrypted: i=1; AJvYcCUocJ1u50N2+T+Pk7x9NmSBlUFQK544OuquULlRjJzKTK+8n+7IKnen6m4OIm+vE/ix66F5L5KLKw==@kvack.org
X-Gm-Message-State: AOJu0Yw5JyupunncVmTaP3TQJ88J6IzNKEv+CcqAK7dZpHQWErzSVoY0
	e/zHP63ohneJOwm+4W5NVlEPr9eUetlJjhGeSLoThqLm7AaQenlyaQBTKymor/xibsqicV9Mev4
	rbfbo+Ic6Yg4eyjvD7lpGzlbrxXa/f444auZu6uuw
X-Gm-Gg: ASbGnctV84XsQ98lyAgUBpY2GQ6eEDURobYXZbYoAhUmRk3l5aJ3LqN+ts1motTuSb2
	tuzXoLWnnAgcCgWpraJvciMd1/orxoB1PQMtDVynuPyCJq6dRoJFlV9nJnLBKj+VefutEcSlpFq
	zrAl0TmySNbOmz9KVtKfKR/DchIgEJMDt3RjH3ZqxVx1ZJsLEYJnD6RDKOU2Sb2aTrVEV1H5+hq
	CTZciHh+ugnsFE/+4zKCmPMy3owAjIvxbQXFA2TOtpgHqKjByaPnHZ82ksd3v/kayzk8yuBCOe6
	1HwQSjssOE49hyIqGfpZNqkil8fnPUebo0+0
X-Google-Smtp-Source: AGHT+IHMVaR1KLvSbLKE55rXsDOxB9pFk2q8FBKOFas3Va8erj7vqYTEhEid6Fc8ZQJmCt6ROs9GdCqYImYUM+78EQo=
X-Received: by 2002:a05:622a:1450:b0:4e8:ad2a:b0cf with SMTP id
 d75a77b69052e-4e8ad2adeb5mr171413751cf.9.1761126240464; Wed, 22 Oct 2025
 02:44:00 -0700 (PDT)
MIME-Version: 1.0
References: <20250930115600.709776-2-aleksei.nikiforov@linux.ibm.com>
In-Reply-To: <20250930115600.709776-2-aleksei.nikiforov@linux.ibm.com>
From: Alexander Potapenko <glider@google.com>
Date: Wed, 22 Oct 2025 11:43:24 +0200
X-Gm-Features: AS18NWCvJIsDRRmmPGlRlrKGRNevHIxIdBHxPohsj_ockyK-Yc0HtDMQf0r6L8g
Message-ID: <CAG_fn=XM_HRovM+VanVsNoi2ug1HQ1yx8oBhYAj0sVDJsh0nfQ@mail.gmail.com>
Subject: Re: [PATCH] mm/kmsan: Fix kmsan kmalloc hook when no stack depots are
 allocated yet
To: Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
Cc: Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Stat-Signature: 5g7uw7euepqppibsnzu1wz1t6rz9e4zw
X-Rspam-User: 
X-Rspamd-Queue-Id: A8FEC40003
X-HE-Tag: 1761126241-500135
X-HE-Meta: U2FsdGVkX1+mTyuc8j4fMvibiFgInFZx/67jWy+TfzVn2mD6AYb24lCwwmadOCmixykhIqJILiI3AxXyfiHaGvhsxusm0lmNBeCrXRnY/10H/qxfq42WWlhdh0NBvsUxk12sz8Rb+5SoDZe2zpFbmc5XEjZQkd5t2Dl2nzK+DoPnm+T+DwnNB9NTEye3qxt4jBICyVNaOUfJSsNRqLml6Br2VIwMkBA9uF3zEn0wjJcyr60qb5dOqZA4VgHC5NAswtyQsrxWy+nzZRsyG6zhMCwXh19Nqrl5fZZmSi5wStk7la70bgJu3Ue5ZTvTS2pqdih9/KbAOteG2GsErc9UoV1rdzDdhTvfv4J5zR9M6fUe4L837GsfQmYdWTKFPLevmIvKRoHeXruku5hOLby/8NqepR0W8wI6mil9u30yCcPfMZw05EGwj23JsB4DsoMP6ebFje6dD6t7rEsTei/wKd+uRz8UOtuM0C82iAmfg/43ocKMQrXax7CQsecwTRIBUcYODsuNfm40x43fmh0JJ7hfqsRHF+GyLBO5w3eI/39SezVp6l6PgrMERGY4l1/vZspkqljaLN2JTOJmzCtpkGzClGs4TFccjCVqC8d1WUxIJHfC91qh9Kv3RQwNuSx/d+ydEMv9MJlBmBnDPNY9xJICyfJOGM9XM4Br0ESBRmYjeSpW0Ef2sP5m0z0J+gntyyvnJGDsSEtUQvlugqf/Nrc28EGGMZMapqSnv1BMJS4jk3webkPi+jTW20Oiykh6M0gDrhYPjUNk11N4ZAByWDRAcXbcTl/t20Gzb9db8t7feFGnpw9w98PAiwxsnB2IBWVjPX4psFFW06vC64BBowSPr4pzdrU17PGUTaxw2V5f7OcwXnBZAo9ecTxo/7MZwyoIz9xar4ogXf7uxOdGdkHoI+qqXpBnswFXW8/E7Alk5/saGSlSdGxouGgNCZPcanQO1lNg64TyZRpwzb5
 AxRKpWqI
 jBrS0VfZO3Cf7d7fXcNBo7KV7AH148H75NXCmO14QlBYthgwwsJ021x8Kvud6S+RXloRH2yMYO8DHVIilyY3K0CMjhOuDNKVKcurb8k9eO4XEsoLDv4WqCIUEjuXnsu3iRbgCK/cAXkxI950F7EenOGYktKmrTzMLDYRYEBGTsqwNXH3zUmFW3gKzmATu8JOwSXza6kaTlyaiCvRpAgthb4mBA/OMYUWxYvvQn4nwJihYb5E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 30, 2025 at 1:56=E2=80=AFPM Aleksei Nikiforov
<aleksei.nikiforov@linux.ibm.com> wrote:
>
> If no stack depot is allocated yet,
> due to masking out __GFP_RECLAIM flags
> kmsan called from kmalloc cannot allocate stack depot.
> kmsan fails to record origin and report issues.
>
> Reusing flags from kmalloc without modifying them should be safe for kmsa=
n.
> For example, such chain of calls is possible:
> test_uninit_kmalloc -> kmalloc -> __kmalloc_cache_noprof ->
> slab_alloc_node -> slab_post_alloc_hook ->
> kmsan_slab_alloc -> kmsan_internal_poison_memory.
>
> Only when it is called in a context without flags present
> should __GFP_RECLAIM flags be masked.
>
> With this change all kmsan tests start working reliably.

I think this makes sense. The whole __GFP_RECLAIM filtering was mostly
for poisoning local variables, so we don't need it for allocation
hooks.

It is still possible to pass __GFP_RECLAIM to kmsan_poison_memory(), but:
- it is actually not used in the entire codebase;
- the documentation clearly states that kmsan_poison_memory() will be
allocating memory, so one should be mindful of passing wrong GFP
flags.

> Signed-off-by: Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>

Reviewed-by: Alexander Potapenko <glider@google.com>

