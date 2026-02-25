Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 714C5FD376A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:04:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D497A6B0098; Wed, 25 Feb 2026 11:04:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE9BC6B0099; Wed, 25 Feb 2026 11:04:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEC6E6B009B; Wed, 25 Feb 2026 11:04:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB80E6B0098
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:04:49 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3F3B71C5E2
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:04:49 +0000 (UTC)
X-FDA: 84483452298.20.FBEDA79
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1D282140020
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:04:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rcYOv44c;
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772035487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EQ3vQXIytAGEH7oeZ/0WjiWaRy0cq0YoMZqI7Sn8Pxo=;
	b=NKdHL0XFg0igpcl2YVdild7ASkll5KFlxCkrIfOGb2oEFh9PsCg2P8Hgx+KugfFMolvc1e
	/Qfht6aO0AkaUrMfyY9OqEOUfRE/zJfeSpEALb63pDjR2qQExYCRseXEmjIfQIF6xTAa8h
	5CfhBYG6k1awxWJktCe5dSNp7g0yR1g=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772035487; a=rsa-sha256;
	cv=pass;
	b=kuQD7G3HiDiAhwhiPT/ivn/e8YsgK1+ca+zCcyfPFSun9y1fUqVYte40yU57vk6rRjKClb
	31RNdi+mpjMAC4Zu4fFF0s5YgHpSI0qtRUIasauZ5hnQ8FTfzh9zXoe6VGV91iA8nxymap
	7XbQj6JtVN/7aQhlKDU8gpR18rALr7o=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rcYOv44c;
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5069a785ed2so723851cf.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:04:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772035486; cv=none;
        d=google.com; s=arc-20240605;
        b=TNy8L/Aq67qzPoOKdHe7VVA0fcRarxDs4Ss00t2Q6q1OcYiLypGzTA5ZA3jfpe1w0b
         whNlOUzOMGfMk5RyPZ9brwAusVVSeTEXoDIolxqJQ3Gxkeam6mxob0N/F+RgvpsIBxeI
         omssKXKivhPiXWb/0vDY/KwkcaWAB5qptttayFnnI+MPPWTNmIt/6JtZ4AtPaWDIp+Up
         wsU+MErsYpMsusMQneLPYFdT1dE8Q0kOZyfK17fzOQgy5ZQB62LEJBTLPE7GZJVku80o
         e0Eb5YODEGfmG+YJ/7IEqJpZyIHY5sX9H0uOn6YfvxkFoalykABLvkEHRwPUpKDWmP0h
         HvOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EQ3vQXIytAGEH7oeZ/0WjiWaRy0cq0YoMZqI7Sn8Pxo=;
        fh=nN6B9II91lnVumd1vTwrlMt9LTeOfUKq+QkwzaruAlo=;
        b=PRNWeI3iRQM/huHPamzrKLQxNzJCESDyi0AeOp9sfHbbfd3/48bGkzH09+ups9gTVD
         F72m7dnPtf7Akiv2oT57gMsQ+GNnJsBBSkcpyGqAlD2hmGIi7m2Nru2/JQqbHuvrgxKP
         GzNFZOkxtsL1X4KKcYeCsEoZ9+6uv9zy/NykcLOmx0ncXzgbzBCSn6mACNRbba+pQRGq
         hdykgeiGdAyJzU7v0OUpPYVwOcX1Zc92tILtnVOKVr7WueDZOVIaxctQ6Ko+aGLbEt+S
         ChVn92Pa6QyxrEPYqVO67ziU/MlsDV4sOQKf00UjalxvRhC6GNJlNccdKK8Bv+mDBNQQ
         BtPQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772035486; x=1772640286; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EQ3vQXIytAGEH7oeZ/0WjiWaRy0cq0YoMZqI7Sn8Pxo=;
        b=rcYOv44c0tc5hVj9AagCQGV5S9fVdQ6MG0b7prwXF1ZyOBNuwjYUhvvS00hl5B07G0
         +eKFL7LltujybUCIhHgnw0Xoo40wC8+OptAFmGXP6AMn1NUvy1cFEoKd3rPkGuJhrQvd
         mwwnvYXcSh79bQUq9JczcSSuHAyRhJ7qlObhE/jYp8Yjj5P+ebXoo0dEb1p5tJp8jWGI
         jc/iOlXePiDooSh//WwHtjK9/JY/ce/+FrEJfdylgU4NhftPcLU1SWewx4xuXh+W/VHW
         vmnzEWFNR1yy0JVe3Nuz9mUGOk3XKRgCPGdRYZiELZtanqOYmIsYCoqXc9EXGjPRBhOu
         Vt0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772035486; x=1772640286;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EQ3vQXIytAGEH7oeZ/0WjiWaRy0cq0YoMZqI7Sn8Pxo=;
        b=drm766hxKdoZpF1zXyDBPF15nqDjObKLAhiwrvt7SQT2r4wT7LeFTCbGphiZ8AEbOk
         Rcbmyp+tM9KJ2nheKr4PYg80SR0ANT8mbM4Ssv+93UjNxP1aFVVzf1aQ91DmgxyeAkHt
         A8jmax96e7oevBiIT//edWPntKsgTOHnc70ts1sNEJ5FnLdKd5pPDN2qt+k8HVrz8ckR
         tbDf6W3ilYc1Hoea3mhjfWPlSbm9jCYU2YFlXpj6eDEcHOvR0T1GKqloOmD7f07+jHud
         r+kLJb1ZMScFKs9vxxBtw89TCLI11KyE9jVzUWa1to4doEJGhe6cnAMbCFSPGrGNUxap
         NdWw==
X-Forwarded-Encrypted: i=1; AJvYcCXYX7XY9rEzU9SnYLLgniGgJgRbTUYTk5TNHgMHDSo69rhuAE593+xQ0i1r+c1tbPfRemJtvXT+ZA==@kvack.org
X-Gm-Message-State: AOJu0YxOuULYz7PrlnvGrAyneV48ATSTZAxeMbgOUmyaK0wdi5A/0A8l
	egQVxjroy+HtRvIXzwfR4LgEhEiYk/yRFHrJP1hYMVtihbhbpuGWbZm3Ya8URfHG7TKzacnUBo7
	PRmwOX3Hcr6QaIERV4Cc5gkDYZezyLdO84EC8rdcT
X-Gm-Gg: ATEYQzz0PqAITsYrR6KQxqdEsv1voPhEjk3MgBiWc0/pQ6doFFe0vVGUa9ZucfNiqxl
	e5azo0B7omRsqo4stkPje7MjYfu0PKdXu/ZJPfmRERu2GLXxAVpg08ny2SDPEHwDk+ikw84uxbw
	lQJm29W0dxSga9ra3uc8m8o0NgqPq8qDdBRYEApFG4fROpGmRzAK59BJ5iZZe3UFMZFaXgpIDYC
	ay0YLJHGVBI6x1oo7NbkK7SAZoHaeKItDcWoJJcHDXSU/0b3YYC/cq3y3/STsCaW/95d6huXS7L
	mmf8BbTXSdeZzeJEteVnOYZw7DYQnQH1aaKH6g==
X-Received: by 2002:a05:622a:30e:b0:507:358a:2b22 with SMTP id
 d75a77b69052e-50738178b0bmr8689341cf.0.1772035485341; Wed, 25 Feb 2026
 08:04:45 -0800 (PST)
MIME-Version: 1.0
References: <20260224221132.1702713-1-surenb@google.com> <aZ5dxxgIb7MfuRVW@hyeyoo>
In-Reply-To: <aZ5dxxgIb7MfuRVW@hyeyoo>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 25 Feb 2026 08:04:34 -0800
X-Gm-Features: AaiRm52bvV-gzzwU-95fDRgL-5WqeOGfDYuM4Kb0jrgnEIOxH1o0-d3_DX5mpnM
Message-ID: <CAJuCfpE6XVE4BswKbPPx_bz7pUy=zSQrm7njmKhZ=ryq12fNQw@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] mm/slab: mark alloc tags empty for sheafs
 allocated with __GFP_NO_OBJ_EXT
To: Harry Yoo <harry.yoo@oracle.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, 00107082@163.com, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: yht4t3ezt3tj79ac37at39j5ct5r6bjh
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1D282140020
X-HE-Tag: 1772035486-580888
X-HE-Meta: U2FsdGVkX1/4wp74DNJiOXG1MgiOqw8Dj7pstN4KYTEbyof21aS/FZe5OYcVHPVohazKS01OjA84Srrm0jznXQ7WlHTMR1yusbAzY05sJHV6xjoqXMfnAdudzm8RvG+s7S2yNhQrEyZo8R/HARixrdyASphdSA54EX5iFEgVR9cEh2AIMswRGX/tOPVzfDUXEuFFCFkX5upH8xrQmVL05ehaFSnkEJyYHvE+Fs+uDXvaIbMK/hC0jULJK5wVc39rmckSjkX5fMAg2lRClr1eIJ/7XiOSQecQi5XOvRAfN1sZayWbZUiwQ2pGZUq+4P42VV9ecYiiAwK5XAmHV3yQh11ZfjiqpK7p9jGBWPxzNgrR58+yJuyf6QesOKOjc9peQyHViYuU4AHHDP7uDWByiDTqhVK6fNXWB4us5lJHa4wgjdFKKXOmfcEUoQhmAkcdKar+raD2qOEzq1nKRF9WIO+7/iMbr37k05si0hu4sMyin8OZK0lScJnqx4T6pu88oB0bZmnkhoq4lb5VnPSF932qG+HqsjXIkghybCv+sRcJib/AwqJbMmzMiHNvXU717yQ2oySTUowWksXfdGccqv+s/M1rzsM8We8fI/RIm63z0wKLAUxnODgWBHvwNTxnOWYO5cuMMaMCV3zAJtx8awboS74oYisSIyWbxFGKRbTAx6tlacAwOiHsHxWSre37p+pHmLErOl/xgR9DYaFaegQlWP9VkoxUDlsrmXJERpzxf3ET0stKlve4T+lIN5cZ1V+E40VpEL7hJLYS/lGOBF+YL6+BFmcE1vs9gLITfqYHw33GG6dDhwMa3yMMl6VoU9UIWbX/CUBXrxwN3w6HbQAMNXq/0f39nMTaygWk/j8IHDSSd3X+tMOvD+rU6sjf7WDZkR6xk8vFWGEEWOAKLlT/fRtbaUOHe5NIHCoUSS46+YkRusTdxjfz4MTiztuIanc+zgTuRTxa76V3Wd+
 d9g7Fjqe
 xv/wGWb9GcZxSctmnA4q60gvkPaAydsgBRr3AgmiAE7i5YkE5R4rCwStIOzICS62SqjgzVuHFL/OVS0iUl4n9lch0KZ6/KpGFqwWlzQ6Q+ggoKA2b6DOBUSsF50MtdPhk/c+dmimEuXmGRkR0wDOCiF0rEhEIEi2h3sLaBJGcZbnDpbmL43kPMnVSghnkYF6dQTS/aagppNykvk3upXw/gE9EzcQwxaB9TOsFBtF8a/2/d7pT1mofrCW8k+0YDLnrd31uUprpqMtlNhVTRb/pGVH3x1sN0mxdbatXbS0aHEVAoyvVmbNEOw63G9GbLnBIfyhZKnLZ4nmSa29G2f4GkO3EodTnKbtDV7yWkXWg3A9ICvGlin+WqSyvPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 6:26=E2=80=AFPM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> On Tue, Feb 24, 2026 at 02:11:32PM -0800, Suren Baghdasaryan wrote:
> > alloc_empty_sheaf() allocates sheafs from SLAB_KMALLOC caches using
>
> nit: the plural form of sheaf is "sheaves" ;)

Ack.

>
> > __GFP_NO_OBJ_EXT to avoid recursion, however it does not mark their
> > allocation tags empty before freeing, which results in a warning when
> > CONFIG_MEM_ALLOC_PROFILING_DEBUG is set. Fix this by marking allocation
> > tags for such allocations as empty.
> >
> > Reported-by: David Wang <00107082@163.com>
> > Closes: https://lore.kernel.org/all/20260223155128.3849-1-00107082@163.=
com/
> > Analyzed-by: Harry Yoo <harry.yoo@oracle.com>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > ---
>
> This resolves the issue on my machine.
> and the fix looks good to me, so:
>
> Tested-by: Harry Yoo <harry.yoo@oracle.com>
>
> and
>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>
> By the way, perhaps it's worth adding a comment on __GFP_NO_OBJ_EXT
> saying "you need to call mark_objexts_empty() before freeing the
> object".

Good idea. I'll post v3 with that comment and spelling fix.
Thanks!

>
> --
> Cheers,
> Harry / Hyeonggon

