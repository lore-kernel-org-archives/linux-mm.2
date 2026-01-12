Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C577C9EC8D
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 14:38:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8569B6B008C; Mon, 12 Jan 2026 09:38:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 804976B0092; Mon, 12 Jan 2026 09:38:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7043A6B0093; Mon, 12 Jan 2026 09:38:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5FF796B008C
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:38:49 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2477713AAEA
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:38:49 +0000 (UTC)
X-FDA: 84323568378.25.A58C0C8
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4F65B120002
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:38:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=r5u3Vc19;
	spf=pass (imf29.hostedemail.com: domain of glider@google.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768228727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3OVHLwGSVY3ROBM8cymA1lSVZ22bXnEcQvZKsbH0Omk=;
	b=d+jMdIMsK14aNiFODNMdn91q2zx7iWnVhdCWc9zf9cWfmoWGkgU8oZiKn81a9oylsUWhez
	E53L4/3xfFkuBe+yLHcrZ0323898Hc1unn2Te1G2jNDRsNyGnig4C+PfYyo3FuiujyE1UY
	3dOlUwPzTmSfbomNWhkXSl4v2v+8ytw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768228727; a=rsa-sha256;
	cv=none;
	b=t2H8gJCggHR315Ocq0zzkXPsmVr+CuGw3tC/Oy/7pdEEZtTU85S3F+XQEfrJSyunNwrL06
	+8tFG0M689QubbPQjQXKBcQAiMtybnXEtXZO8ifD14rhq4GdCunMmaqqj7CD9d9zzUchFc
	3jCi7s3tFBF/7LWxnhe6xWzQqo8ec0U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=r5u3Vc19;
	spf=pass (imf29.hostedemail.com: domain of glider@google.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8b144ec3aa8so684814385a.2
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 06:38:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768228726; x=1768833526; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3OVHLwGSVY3ROBM8cymA1lSVZ22bXnEcQvZKsbH0Omk=;
        b=r5u3Vc19OqnnQweAuuZELkQ/9TP37fGhq1w0Zdi/KLl6wwsT0oe9d6eyFNd5DkVQNF
         u58krQ8MLsCwzKXwKu/pmA2x8scYQp6ZJhZmrE4XC1GYApn1DuNjlW6BVaXyKm8iM1I4
         n5GkfLfWDTjZmqkMUenV7gDBtkS1Mohcn74bqelr4/AXQwaIfp97gUPDIDrWD3pBFpUv
         54dqNEO2ErV/526RT5K+AQouYSByH6dkgYpI9w+z72Lu8gnUS2EOar7M26ydI1qAEvZO
         sXBJtPYd1+HgQRVcpS/hgb9Hxf8VybhTZbVeqLWuyLURcb46ZQgiVQVfKaLe/GQGXpfF
         hKeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768228726; x=1768833526;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3OVHLwGSVY3ROBM8cymA1lSVZ22bXnEcQvZKsbH0Omk=;
        b=kSuSm2thXWUbMucUl/eif9xE6ZXG+kzz041uQwgepUlBhK6hU1+iuKXMAGogUjF0rS
         CHTMh5KZYAoQWutVxEdKEktFIJ3u3K3J0+VsV9CxiwTPquyDFuCsGZxA0ORXHIep5Pzv
         89hGPV/9CitihlHKXkFOU2SwMFmRfumoYix84Aym5gti6adKVwMAvYHwEv+hHt+eurVb
         OyT5olr8zA2lDMGfyLjnRJunykqIka0pjAvcm+lHyv87ZKcJ/I+IzUDY7BUf5sJ9Q15R
         fOYn2Ey33vmcXEaLMqIRjQ1ZOA1ZmHUewhPRs5dWGSUktfR3H9sY40JZjahaIsZSjWEI
         99UQ==
X-Forwarded-Encrypted: i=1; AJvYcCWA3hvutTBbfZm7wnkZdIVgEe4tYBC4MZeedI80kjyFqoXdMPuVhxpBCETeefQo4+UxY95vpvdPmg==@kvack.org
X-Gm-Message-State: AOJu0Yy/qXA6XmyK1hU4Nz7iYBWn3aWNYcfJvnOstyF2V+vYJJKJYtvS
	kXURF5CxJKOsCUoqxKEy9p/FJfOfaJ1tihrex7kj9RyOPawkHSQFpyCxPicizJ3Q+MAqAbkOzop
	rc2MXXDP6R9fTSYAEzJsa0bcKl0EbTtvTFdEsjW8T
X-Gm-Gg: AY/fxX7GHRwJgvtJlUZe24fuEWbstcCxEEY+jetfB7FbRTSX1BqlWd7WqzgdvyO9lWK
	59lYpgpHjO6lFy/CHhgNeboJc/1pMgNAPrR2d4a9lyhQsTNgU4o1goz32ptQjWVWOa+q3F43gCd
	mxQupHHZAWfl+CrzazbFebty0mLAQv3SUBIESQtH4JucVUFh9HYcmvwVNBTDNgtJovoUWqp4MJR
	kvyJ1NRQisSHXr5ckx83LntyZsjCdCx790CSnsHb1UetyLWCqRxGbUq/NhLS8ZtVPm2xfx0B60/
	CNlgXFlH0zdm8ohgEUrchgp6xA==
X-Google-Smtp-Source: AGHT+IGhrNYAx5nJsuxOp5EIbKgtYvgqICeyAKUqFhsc50IvEZWhS8EmoDJnYDpLRXA0O1DJ7MEwbYmYdwbQDJwI+uc=
X-Received: by 2002:a05:620a:40d4:b0:8c0:f13e:42ee with SMTP id
 af79cd13be357-8c389420351mr2515603785a.88.1768228726114; Mon, 12 Jan 2026
 06:38:46 -0800 (PST)
MIME-Version: 1.0
References: <20260104134348.3544298-1-ryan.roberts@arm.com> <20260104100230.09abd1beaca2123d174022b2@linux-foundation.org>
In-Reply-To: <20260104100230.09abd1beaca2123d174022b2@linux-foundation.org>
From: Alexander Potapenko <glider@google.com>
Date: Mon, 12 Jan 2026 15:38:09 +0100
X-Gm-Features: AZwV_QiYkGu98o69ZXegThGdFPJzrbQ3TdfnesIl4fIhpP9VWTIXvd7AfjMrgqQ
Message-ID: <CAG_fn=XtONeeJzBFFyxqWa1=Zo8bCGcUPO11Kaa4093vJOPgrA@mail.gmail.com>
Subject: Re: [PATCH v1] mm: kmsan: Fix poisoning of high-order non-compound pages
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4F65B120002
X-Rspam-User: 
X-Stat-Signature: z8metaebpfdnmkrq1x3cwtz5ww7bkof1
X-HE-Tag: 1768228727-411390
X-HE-Meta: U2FsdGVkX1+wFO//K4MahUtysDl6plQIaWbnkQJ3ABEfhKw7psdOKywpGSELB4ndxuosvLDOJtYEsUeCxQh/2W77qj4sJQGQnO3S7uYFtvt4ZHB7OTTb1uh8d/xu8QlNt0ik2RREW4WpkJYrQYX6pOBN/xJB+u+q/ilVsIlEfdHpuF40enkgmgSsQfjt8mgH14LdgyNYEzQW9CUmfw0GKdV1GjizHhF2LnyIQ9DGKqAVjZTPNGN9XZOc6j/Gme1Ds3Sqt2U5kecUiDESUu0bBzTMYtcHxRF9S8fV5ctxXc/yXsArAOfbZB+wQ6HA9v7atJGUr964VMzbD2hACL4gHyxo56Ou4nnNK853fXJIK/vA5+rHJbywAzAtdySpOnZ6wvLtWryyyqzAoOF5gHCInlWPx76/mWdSXou7geO4f+lCiABgMmHz0i+D/AUl05YIHb8P7oU4GfteXOfOGfaOHufy6C0vLozI5iwJXXyjTCr+XB3ysjwBHJRLm/ToDMCEiGMo0YOWYeKX6rpdFEfz7Ycxeuj14RDmCRn8Ix9FJjdOcmF0hin7jEC9TGF3nSUE9JDHflkA8+wdvj8b/y4CSA6inGrrskiO5T67svNhQpur+HNbB4+lnElV8FdXH5+UsNYNSz1krFIY9vytBO0Qt4RJwZFfN2fNoMxGQRMwcbg4nmUqYrP50jrsgfh5/iivgfboVoXQ14TUrVA/n2lYvT1ckpyeQG1UBvavY4tAi8jWOC6IIvfPXUUWaR7dGXtPMdj4DZXu65U1APwXaHKnkLwVVay4/94jmYt1Gyj8i1fDczsQRASt2wLQFhLp3Nx2tFaEmXN0DRJxNMdlnKFPd6RU8vDCcmRsimXAntJb/fAD7juFK9pL8oozRNyTbTF9YkChvdXqy9Ty1YmG8hoiOYLxiN5aoaEvasEimj7PfAJNIRfVEwiPQQ+guNnycnNGJ4naqIMK+denpmNbmsn
 b2VEhwQc
 AFsdUvJsgOFmKOA5QdMJIHKSy66Tyo51xYZWHh238uO+u6FRdL9KTBPBRqNMQRYNuw8yPhAfMP6CrocW/wcyr1YgFs6SSAjs3Tn3DncYmj/l/Yo1a6u4j1fPvQZw45V2QvOYZ1QTOZ+B58gVWyIIFzcj1AwRbOdZOHoQ/MYEOtFhRkYdin+m+O5EuzSxiB+RmZZaCt/30ka7ehonphwru4nFL7mYs6B4rh1ZackpAnxCUOmbO3nGngjruyljcEOPTCRktpMFv66D2vVubUzI8FT8RAkLn+jzF3eYFghiUfiFmNnpTGTtf+6rYF9dW2CLUiFSNkAoHQGx6XwgbWr7n27NFd6KUTB2xh5NnEo+JNFFMKOE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 4, 2026 at 7:02=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Sun,  4 Jan 2026 13:43:47 +0000 Ryan Roberts <ryan.roberts@arm.com> wr=
ote:
>
> > kmsan_free_page() is called by the page allocator's free_pages_prepare(=
)
> > during page freeing. It's job is to poison all the memory covered by th=
e
> > page. It can be called with an order-0 page, a compound high-order page
> > or a non-compound high-order page. But page_size() only works for
> > order-0 and compound pages. For a non-compound high-order page it will
> > incorrectly return PAGE_SIZE.
> >
> > The implication is that the tail pages of a high-order non-compound pag=
e
> > do not get poisoned at free, so any invalid access while they are free
> > could go unnoticed. It looks like the pages will be poisoned again at
> > allocaiton time, so that would bookend the window.
> >
> > Fix this by using the order parameter to calculate the size.
> >
> > Fixes: b073d7f8aee4 ("mm: kmsan: maintain KMSAN metadata for page opera=
tions")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Tested-by: Alexander Potapenko <glider@google.com>

Thanks!
I'll send out a follow-up patch with a test for this behavior.

