Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5D30C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 12:40:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8F408E0008; Thu, 28 Aug 2025 08:40:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3EAC8E0006; Thu, 28 Aug 2025 08:40:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2EB68E0008; Thu, 28 Aug 2025 08:40:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C1C968E0006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:40:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 69EC31A017B
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:40:44 +0000 (UTC)
X-FDA: 83826125208.11.C80F5B9
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2ACAE1C000D
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:40:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=LIDhJeXP;
	spf=pass (imf18.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756384842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=trSlbet/QuueBs9xQCBBEcGeeBLPyPlp1BPEQPaV1q0=;
	b=6VzOq9WJhdgC8cW2F+Fl1kb+3RvGR6/ZBeq5DrNuw5Q13mQGNgNWE0Cou2hsUXvAmr+zxK
	yBCggcbRnMbGEN9WHtF88dvhJJnDZsifJjuFkkKLoGTMMjMMQFP5rsV4/fDewTwFffs1kJ
	+kPTOjpjToQaTJNLCFNcWC/JANHvTLE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756384842; a=rsa-sha256;
	cv=none;
	b=GJwd8tKdMVKsAGuhQ27o/GuOp/lUk9GGywkgwZVQiTOdsFYvTjut9+taqS4xzLE7EBo8pF
	DT/EPDHc86UcR10dsY50sXVafAXGME3N6n6bQoO0db+/+VCnMbjwYeY9wjFvClgqfVgQ7b
	B1hscLUgW/nym3IHEBC+vPVr96xJn9A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=LIDhJeXP;
	spf=pass (imf18.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-afcb7322da8so160049666b.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756384840; x=1756989640; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=trSlbet/QuueBs9xQCBBEcGeeBLPyPlp1BPEQPaV1q0=;
        b=LIDhJeXPyWCt5ObVsi9yyuKr7oJjUIC7tRqbBAkEMxHSUkWIyGcjIngXIfNd1qpvI7
         FzD//7MXrENcO6JcODuSdcRorwbl+oW/tjypS9R6mHNuhwCYAYGT37inrlbLJ4GF9LzF
         5PrZWGR5exW/yp1IvLM8V1D0quiFOO2C82U1zbmLp56jnSXQ7P+AO/HMwMRiuqRK47iy
         NTNbKRuvkMWWDhJ3DFOGUIomcHswFlSjeXWDGERwj8T+OQC00PfqZJcgEAO+8ST9JLt/
         P/bVKFA/cRdyoAxBIvSQoINWxgPPMHjXIUnOI15cj/3K0vIg0I0hulf3GsjC0vlJ9x22
         EDMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756384840; x=1756989640;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=trSlbet/QuueBs9xQCBBEcGeeBLPyPlp1BPEQPaV1q0=;
        b=Iw6hYbKkS76sxY0ixr8Z9+uqaeBMH+f5fJOg3/pORsrRU4iJpSS6HFLODACtFVjmpq
         AKRGRMA5rNOFSXc7aZ0HaaZZrarssNNZQaAQX5+g5NoH91+jLaOh69zY08GWOvuWlSdE
         e6MsDC4MqH2cKjyilxZetqk1E3erHvYwc9H4H8EXFToThBaPTaZBHUAaxXR/LuTxzgt4
         Fa85x1PyYD5fTtnjsZA5R0/64+KZspCEuiuISwh0ateAUiH+lxnpZWcXsjXaFq3A9n0r
         tIL5bGt7RqDRaRGEWmVtXAkHkbDyqqh+qKDdWZNiP8a2bFCD4182CSdZGDLkGbTDPZqQ
         aoZw==
X-Forwarded-Encrypted: i=1; AJvYcCVFzIs5FYwiWELBPFE0hN/BP59Gtjf2PPuyOtO1cxN74UJuqywFmJ5YlYcz6k8kal+bYcCj5h8bjg==@kvack.org
X-Gm-Message-State: AOJu0YyixTT/FtsOwQlGBDptd0VyK43amBoc12D9vhlv3/m4UHZxUkQT
	x7nlWRPSG2U9YiSKle9z0Zyf06znULQw20y34y3Vp2QzQjn4hLGiB8Ub/5HvNiLWuvHr8RbCzB7
	ifBZixrwclxtk1mSSFCStLvm/PJHZGM+CFDk2Ox4P0A==
X-Gm-Gg: ASbGnctnlyhbXNysEYlBmarY/LCERwob9KFcwvhOYRyHKgRh12JASHbq89u42QGk/yX
	MFlrp0DeCc3PGSMskRjaeDe7X0jlDHQe2UqygbfSelAhto8CQq9tzSo2Lz9L494/nPqdpmexIHz
	9iUhTr+muzsvJ0Yu+D3n0/So/2o3Hh5b+XMs1P+kHv3wyMu/t24+qXHxEhL3OJASh/makR83n8q
	Tmpeikbdh5Aks2sULyrIQ8t5S9RJWmMv74=
X-Google-Smtp-Source: AGHT+IG8bYx4wIXfIdcPfZhiB4fk8x1jfzQ79t0ZECOBclW3p4Or6CJiYYn5dcoy89VV/Q824U7zbSHINWxTvm92/XY=
X-Received: by 2002:a17:907:dac:b0:ae3:f524:b51 with SMTP id
 a640c23a62f3a-afe28ffcee8mr2305659766b.10.1756384840560; Thu, 28 Aug 2025
 05:40:40 -0700 (PDT)
MIME-Version: 1.0
References: <20250827192233.447920-1-max.kellermann@ionos.com>
 <c688a2f6-375e-4a00-8d44-6a833e3d30ef@lucifer.local> <27a21510-e9e8-4eb2-9e26-618c103d49c6@redhat.com>
In-Reply-To: <27a21510-e9e8-4eb2-9e26-618c103d49c6@redhat.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Thu, 28 Aug 2025 14:40:29 +0200
X-Gm-Features: Ac12FXyF-XXXzaswyonUogGJ99vkSxahZWLwoczFyKONaWpaCVV1M_vCYlT-A6M
Message-ID: <CAKPOu+8DbXY6wT_8gcqLDpyZEg0=En6wOYtHX_VkUvZ_oOLHSg@mail.gmail.com>
Subject: Re: [PATCH] mm: add `const` to lots of pointer parameters
To: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, akpm@linux-foundation.org, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2ACAE1C000D
X-Stat-Signature: 6s1akowm4imhhypxzc9xhm31unq9qj1r
X-HE-Tag: 1756384841-50374
X-HE-Meta: U2FsdGVkX1/3ji65fcpEDaGuMCMkRPRXCqVr6+ADBvJ0L4mxv+3aUjIps9RfsPLLSGWucgbisV0BlXl0gU1E4MO5mR/xecM0BTFJqKqDfLIp3nLDFeu3OiVHz/xn4oG/dqpEc5yPQI/vDv+FPUf0UlZ3IXidusGJfcNCRNha6yuikw7dIoYQaVhrbTXTMnT/Q1wLHhkkS3yaCz05h6ExOvddhishP6316kRRQthVxo/qScBPJmmIpaWmUjg2zdgM4pxsjROXpf0YEoj5A+8UMB1GCz8R+hsm+6skcoJsKnibr2UhfYEoXOxJBNzFAvFOLkhaVlV/Kb5e4+xozNPzgk2KTGXnUdAuyit85Hu9Qwmc0jR34jKeFvW+K8HXcEh027gCzEJrKlJR0vtawFnDBEl9wdRbmP8NQtOuyjAFunCO5hj9td7ZrNWGO7zNxz6kpNxgomKyFQZYEk01FNHOFBmPwwZ3+j7NmnSq9+iL2ScnJsNIf4K+5LSCsQlUOwVYlBZPg95c/6LyT+rlnLLFW8OnjNEaBLB341GB2eR5ueR2J33+4+9NcaopwdY6WWN51JG+Wmp8MMqToCj105VpeJsq9cwkrnjcXjbPSlp6jpbmuNKPduNuOp3rfw8b7t484FB8Zi4pQNNemIVW3vXpA1MLEC/zpUed0ItVzuuM6w/3K1VHIAd2FT2Y+0O7g6zKN7dpNALkBGTdJ7/WZ+5IQzThPTaMo4BpsOxYR/fqteD3VvdihbDZrughDHDl+QLVY9bGptZ25QiQslFZlQhVrClqJx7upoRq0cwW6s7YN+aHnzua8KRlqKOazjE2jIwZ2+03QWlH3VnMhx9Ro1525iGdvSkKYkhiNQwopls5GPBmgdfuMRjNJP/HktNujMVqFk2EWX2lC4gITdrBs8WJ11exDGPlSBRxXezHMPo3NtcAGmcns440XXizfNlBmloqXAb+cfQpQwM96fdGMU0
 wFBQSXrv
 x7mKE9fz6+mz75tzNlSHc6kDYNW5nFcXsmdILCwfQAOIOmZMEx1jLpSdiJtUDcKd0BBv/8I1M+7VIoOSziazncCFjNAWBGXb33nEfjh3Lsv45uUifcv7Hhbj6srpuTwpMWio+HQvm+nBrGLPbPHXKkqVERNsUPDwDDXj9ESPR7xMt7fahEnz/v9JCLLjlqnQu82dgszV/V4dAjQlOw0oaZxpaHw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On 28.08.25 14:24, Lorenzo Stoakes wrote:
> > On Wed, Aug 27, 2025 at 09:22:33PM +0200, Max Kellermann wrote:
> >> For improved const-correctness.
> >
> > 'const-correctness' in C is extremely weak.

"const correctness" is a commonly used term for this concept, and I
find your arguments against const-correctness "extremely weak". I
don't think discussing the benefits of const-correctness is worth the
time; the concept is trivial enough, and if you don't already agree,
there is no way I can convince you. Let's agree to disagree.

On Thu, Aug 28, 2025 at 2:29=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
> I recall that Willy did some more targeted conversions of that kind in th=
e past regarding folios.

And I found many more commits adding "const" to pointer parameters.
That shows this kind of patch is acceptable in the Linux kernel.

> I would appreciate similarly doing it in logical chunks.

So you suggest splitting the patch into many? I can do that, but will
it be merged then, or will Lorenzo be able block it? Will further
const-correctness changes from others (e.g. Willy) be rejected, too?

