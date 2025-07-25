Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15E28C87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 18:09:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E5686B0089; Fri, 25 Jul 2025 14:09:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 896676B008A; Fri, 25 Jul 2025 14:09:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ABFF6B0092; Fri, 25 Jul 2025 14:09:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6E60D6B0089
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:09:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0B6A65BA1D
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 18:09:29 +0000 (UTC)
X-FDA: 83703574458.03.EAA08F7
Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	by imf14.hostedemail.com (Postfix) with ESMTP id 22008100005
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 18:09:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=YNWivLOe;
	spf=pass (imf14.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.161.44 as permitted sender) smtp.mailfrom=jeffxu@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753466967; a=rsa-sha256;
	cv=none;
	b=gpnBwIulWDalyZscPGZm4HC8yUQqnW+CNfizNNj0Gd8ZVrpnM6L2BD/Af/jRrGd5TcWfxu
	wMrOj9eYYtpKiGJPQ5r86T8UcoOjFAUABRFLiot+7fqFrTj+S0xrw4tMsIuW7AgXBo8iau
	aLxr1pIkqO84VRLqDQCUKj3833K2JU8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=YNWivLOe;
	spf=pass (imf14.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.161.44 as permitted sender) smtp.mailfrom=jeffxu@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753466967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vB5qtyVLlUSKDoN91u7sYSOkoySeFqXDvwHlEk1kptk=;
	b=xCtV/1/bQP+yLeKjhe/fBqqi2c4sSL7GRBbLxruSfA7XxKbYhHUzmZfamQ6x8iTTE57il7
	PNOoIaYaFC7s63GgoQ7zB5lRLNM4STexS3dZRDkSMnpxyjyR39bJ/BLYt4w8r4IRSRyUKY
	UuZfcoHXVR/K5GjkgwC2fG00eaJQmhU=
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-615921bc367so34767eaf.2
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 11:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1753466966; x=1754071766; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vB5qtyVLlUSKDoN91u7sYSOkoySeFqXDvwHlEk1kptk=;
        b=YNWivLOe3QNnSKEtVqZfHc4yJa1tRG8VziJQV0Ck2bIfoE7y0N9zfpvV5Z8uwSPbxP
         45FN0JYt4j0uBtR+CnrBO0IZld+NaNYPTS9mviWd0QlHCfg2GcAGPZMCPVE+daRfKEA5
         vvYxCj9EauERhEmnxfDs88M7Wk44/duxpp6AU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753466966; x=1754071766;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vB5qtyVLlUSKDoN91u7sYSOkoySeFqXDvwHlEk1kptk=;
        b=Sw+3KLfa4BNvslJZY25WE05fxw946EAS6vi4CaGEGj52vro5d5QAj57ALbnin7fIw6
         2m1GN/ilCDV9Hg1eIkEYJhZAQWclGy5f6y0s7816X8oqZglidGlLjzHBZYpWEMRQgdBM
         w3Ml2koHnQFReSDltO5WVSYXXbJ2ukrfQKsLc/XLS0oNhVNf8m7Bzw/5Xi8Ykx/fRDCH
         sc/u8iA4G0gvnpTj3OXdCIHnsMaYZglly+ELPx5/bNR/2XnDMumIoNNAch6XZ4klF2OR
         Oa7Wnne08gI6abejD80DN5nXdbtuW/p+7lmbBwRt9WIxeb0YoeKOLIalJA3tyvTbhlAq
         8tJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUrZ3cec4O6PMsSL2b/7NiVP4Dpcph0UQ36MHvkv1YXC2kybH/wCLtqT1W9RBVznuXWnj1iHqnMdA==@kvack.org
X-Gm-Message-State: AOJu0YxnqGI/Z68gTmxk994wMPsVgZt1AmFx7wY2IAymaFsfwhJr0YsJ
	+9YBTKIvWrKAjwC2AHTZ3pee1cp+e/BrjC7GmLOOJ49HEJg9Pxph6tVCXjiPrjS9zLa11DqQRK0
	VDpoeuNopNY6/zUWvLIr0qs8A+denKqvv5GUyddc+
X-Gm-Gg: ASbGncsmFqnyL8JMCJdW4ohS9Ycuy6PCDE3EWYoCU5weO0AX5xt35awavonlXGH9kuh
	ko1Q35dfAVEAzDGJdp2azG1S7cBM3jfXcjDsJNy+wFy6Mqg9SUHAtE3uyJNBBqWhav/aS5ykhWI
	wrnlXRM+HnYmvCYbC9EJVOPhCZuCyQLSF1GJJDgXcC6QYHT024YfyQe15nsqCE+e/5Hj1l7Ruvl
	7ke3vElxVT+6o6m1K3IsZk3bhUtZzYFWtHrr6aJmJOrVIlLb+hoCg==
X-Google-Smtp-Source: AGHT+IEddEi6xdTXJgtiVapbZgFed98zIN2Pph7V9krQ13B7rmRyYRfak8z97schkfqohmFYUh9PuBDiB+EPcKoyGS4=
X-Received: by 2002:a05:6820:250d:b0:619:574:39aa with SMTP id
 006d021491bc7-6190c8f9259mr414821eaf.1.1753466965838; Fri, 25 Jul 2025
 11:09:25 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1753431105.git.lorenzo.stoakes@oracle.com>
 <dd50984eff1e242b5f7f0f070a3360ef760e06b8.1753431105.git.lorenzo.stoakes@oracle.com>
 <CABi2SkVeHWt+SKWWodXUNhXZi1Wv9YazEOGWEUJLvgPbopqBrA@mail.gmail.com> <ca6af6bc-1c5b-47fc-a00b-11d46867b5e7@lucifer.local>
In-Reply-To: <ca6af6bc-1c5b-47fc-a00b-11d46867b5e7@lucifer.local>
From: Jeff Xu <jeffxu@chromium.org>
Date: Fri, 25 Jul 2025 11:09:13 -0700
X-Gm-Features: Ac12FXzddZD9uWJjnpALakPffhHt86pE7Uh1fvLdscCaUcRVEp6tIBc4NLqA0YM
Message-ID: <CABi2SkVRmuRp459g0RBwyTbd5dACwe6AiHrpxYuPXj41MxHp+A@mail.gmail.com>
Subject: Re: [PATCH v4 4/5] mm/mseal: simplify and rename VMA gap check
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 22008100005
X-Stat-Signature: c3kc3jqn6n1bxwgkqf45rdobi4zqxac6
X-HE-Tag: 1753466966-47085
X-HE-Meta: U2FsdGVkX1/tTIriCPlwYtiCdd8S0fO/Bg+dIghVvqCJ04fzF0lZ37M4XOhVqWHBTSoeURN76S6qBCiCn/pmCINzHJGibb2hQX7+PfUqgsGe/Bo8Kr4EG4KaZKGXtqCXL7WvKmLdiwX/TfCSEFdaoMf5G9jHwdeDu0Xv7vyMv5P8Bnckq2RfNsFv01j6n+DcHSPXR6jRp7KyqmK7DhITuwpD/ML3sfmcide1DJ/+Bh2NrG0vpTeGwzJjbeL8VjGCCKnSRfiBQQSN2tYa3teRgyhwIHR7ley6vaGVI40ls0uEfjmGutFR2r9BRpRps61tcv58fLnScVUPwYpz91263SwgNxEQpOk4/wl1tOKV05z0siJHPqB2X8TvJV5MjEe1w/ayyFcng6cXCxBNBSJXzx1uuIFewe9JXNkFAQldtvNMWR9QhE7LuuO5Oxg0iggBx1PhYAu/QRVa9kC7cRG3LRS0QZClQ2grDi9AT5ZIRt85BLe/rG1ta4XnKwsfcOEN/0hkwZ5ns1rYuI9xdIVhmYVBYMAJogQrUO91JQ37S+hzBXl54JJf6cKwiKpc+i2s2uh37cMkiu9wyvgUtnmXXJOy6ncN0ukmftESZKgViSUkOw6PssD02HDAb2kTFId24lc8obhrl63R3oMuN7i3q1imTIuFt3LqDuXkJbPhN1rk9euEcLqF0qf0jULGmsock86+iRc3IguemfveIjx4zOSfk6q6ubaEmkfF0Bu5HxZo+rlh0gFS6JOivHj2ji8BMUripxM8agwjQk0hxlo4FW6GXMa/8GfTVehZ2ipGJ4DjlvC9TZio0A4MzAgWkdZeQMR2TJCwmvDXV5slbthRLulILnNGKlLr0Br1+f7MniHmLIbVUX4cSZVF82Dr5wicr0x4/R6Om0T3rqlpRJzpGMeDk+Ah1nOJluE73XQRRqW3AB/Yr/rKLtKrcNn08MBBYU0SacLc7c864//NBCF
 RejoHHkp
 AeJGwsVyI8H4vYvF1m7nUfXvavUsxghOQ7+0ynDnp/ggze3mMYxC6OKdI7TBLvkuTl6E8UaCWBIFXZNoudcpB05CQ9rod9QatUBwanwMVJBlUEbxeiKHGrv6chYesZvsq6jbDhavGtPLyWoVNjmdx4YuEtHGyQjCaw9G5TqHBoq0jlr4lN5onQcjUOYH8/nFoGDTf7Lv/qH6L5ZTTzzjU3MoY5mihuI+39weW0GzsJlmYcEAI8CxP5xd+Zg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo

On Fri, Jul 25, 2025 at 10:43=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Fri, Jul 25, 2025 at 10:30:08AM -0700, Jeff Xu wrote:
> > Hi Lorenzo,
> >
> > On Fri, Jul 25, 2025 at 1:30=E2=80=AFAM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > >
> > > The check_mm_seal() function is doing something general - checking wh=
ether
> > > a range contains only VMAs (or rather that it does NOT contain any
> > > unmapped regions).
> > >
> > > So rename this function to range_contains_unmapped().
> > >
> > Thanks for keeping the comments.
>
> You're welcome.
>
> >
> > In the prior version of this patch, I requested that we keep the
> > check_mm_seal()  and its comments. And this version keeps the comments
> > but removes the check_mm_seal() name.
>
> I didn't catch that being your request.
>
> >
> > As I said, check_mm_seal() with its comments is a contract for
> > entry-check for mseal().  My understanding is that you are going to
> > move range_contains_unmapped() to vma.c. When that happens, mseal()
> > will lose this entry-check contract.
>
> This is just bizarre.
>
> Code doesn't stop working if you put it in another function.
>
> And you're now reviewing me for stuff I haven't done? :P
>
> >
> > Contact is a great way to hide implementation details. Could you
> > please keep check_mm_seal() in mseal.c and create
> > range_contains_unmapped() in vma.c. Then you can refactor as needed.
>
> Wait what?
>
> OK maybe now I see what you mean, you want a function that just wraps
> range_contains_unmapped() with a comment explaining the 'contract'.
>
Yes. You can view it that way from an implementation point of view.

Contract mainly serves as a way to help design and abstract the code.

> range_contains_unmapped() enforces your required contract and the comment=
s
> make it extremely explicit, so this is not a reasonable request, sorry.

Technically, this contract belongs to mseal, but if you have strong
opinions on this, that's fine, as long as range_contains_unmapped()
doesn't accidentally remove those comments in the future, which I'm
sure you won't.

Acked-by: Jeff Xu <jeffxu@chromium.org>

Thanks and regards,
-Jeff

