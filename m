Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7CF7CCF9E5
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 12:13:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D5358E016B; Sun, 26 Oct 2025 08:13:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 986388E0150; Sun, 26 Oct 2025 08:13:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8751E8E016B; Sun, 26 Oct 2025 08:13:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6A8698E0150
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 08:13:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DDC8387C8B
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 12:13:06 +0000 (UTC)
X-FDA: 84040154772.29.9644674
Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1219420004
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 12:13:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LcSZYCSi;
	spf=pass (imf03.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761480785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fSAfFGnWpYn/dZ6LVH9R+UmFT4gpUozqFi1yTtvIhew=;
	b=uZojEzQjwpqWSq7PZy4RFmsskuH0gBxJJNiP7DFwRFTs7vk7fqKwpQ2w/aBoAbGYMsl6eg
	9AtupeQr5OMSoT/yk3DFn8p8NHnrMezXHLnKVx+rymceQ7vDwsCjlS8jXCkWzw7UzUQIIb
	r3U6/hpfAwBGPihuAdJznom0pYFaa4Y=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LcSZYCSi;
	spf=pass (imf03.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761480785; a=rsa-sha256;
	cv=none;
	b=SNfUCsIr1BOtLMaKUy3PsiFqJb7rpTRRY9EnaWavzwPlYLjkw58lM7WIa/q+CNZk4bVH7z
	IEip3IGArODq86qJzrNRxfEr5GjhdgBkmNgQ5k7Ss154qCKcqP/cVjbJU6Pi0o+773vt9y
	R9Wir/doBM9eOJwNSLcgGjwQA8PZx3A=
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-63cd60ca2b2so3996459d50.2
        for <linux-mm@kvack.org>; Sun, 26 Oct 2025 05:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761480784; x=1762085584; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fSAfFGnWpYn/dZ6LVH9R+UmFT4gpUozqFi1yTtvIhew=;
        b=LcSZYCSi2Pl4QurGulGJDhV+KPJcLriuqML536hLstlUOFJDqGm24FoY2MFT7kOcuw
         C4xHXkqpBYLFzZjwgdsq3DZI0HicQbo1IsM7Ol2fTvzaasm5S39sfM1w/0k4kKklwa9S
         6DwigSOcSOTO/446Pr2p72RnzFr4YPavXzfBR0IHNLkuxgy9dtEWMrwtFmATH+c7EEvA
         dhDbSsK6TK28r/XQ/3fT3uq4Pa35dFCMHvwTYl9EzsBxJWRZ6jx+s6j0V7F0n0KWh7Eg
         T52jd+nDil8hcmAPD4XbZqxNsverYiAFCVNxUXbDTGFfANs1ZC/yX6JSmW4Cr4mg/YhB
         zZzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761480784; x=1762085584;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fSAfFGnWpYn/dZ6LVH9R+UmFT4gpUozqFi1yTtvIhew=;
        b=oQ2atUHstCc8zRVnbGusJ/1qSRnAD80h2Sv2GAf1vF8gcYNbf8wuj3hmvd7VZ02+vD
         jqP2aKpvS7TVgdX3+z7dDzGC/cMEE6pOx+oTPfPH/gEBEipgXrcWqGfSEGxY+09Dhe6J
         l8mQsXlf7NBGRqhwsUVT80/ahx5/qFYKcxaviz7NN85BwYdUK0QowJahUR7dR0YORaDU
         +lWTOQrTCp3NomPZCBlQ+FhNpZb5I34CRWzC6qDScGi3r013vmaNXDtYXUMHPXr+EVq9
         DSOLZHD7ezdSK6qnb6vLHQtf20noyTGQjy/CPnn7If6bnqbB7F0/vQQpCXbUCNOyT36n
         7B+Q==
X-Forwarded-Encrypted: i=1; AJvYcCU8xDWwwI4SVpMZyxpX6MyB9GhGV8czMmK+JOX6e+gkuSeZb1p2zaYnpn/AaXd/gE5/Pi1xPx5xRQ==@kvack.org
X-Gm-Message-State: AOJu0YxH4L/+KIXFAsn37TRD+t3Ujl8/MJ8z56Nt8Dt8P+uBON9Lwhj7
	T3YOYb0rzq2JMnx75iwXz9rXQ92VV5xi9KCjcmaBHPWmAEO2KpjaIu+0X5tpLtLwRAZbMUZWGAm
	ElW+IT/SQcdNezrzs0OIHbwL9VsWCmno=
X-Gm-Gg: ASbGnctLN40NQ2DLtuHl/u44OEZQq/fcnYHwR5eOJA+VFX/4vW6rAYh6aUT3cMqw+f6
	SttAElxB/hxoyXwTFfBV+4z7qB74+u9g9h5UdIIx7ZHoPrFWPl+39mRkmCJy8urf6ueq41+uwvG
	Zj9k7CiWB5a0JrEQf+y8iPUDlGuan0g1IPWHP9GX8agBEzhIMOKvSpOehnnRYFJUsrd4YSwT6wd
	RXGAjgl0AOVxUA0NrvhJyMlhMRcNd2q7AAZw6Q66FlC2A/I2Hyv47istdJ4+gptHDxSCsF/
X-Google-Smtp-Source: AGHT+IG7PGd0U1694qdjVf5ZY8i0ed+hvlevVbZGyO1DN04H3gVvS6A5MEP2qMY4ZXrpbiRWoYwLMS6Eww9iMDtwDCQ=
X-Received: by 2002:a05:690e:d8f:b0:63f:35b3:aa7c with SMTP id
 956f58d0204a3-63f35b3ac7fmr9475382d50.4.1761480783993; Sun, 26 Oct 2025
 05:13:03 -0700 (PDT)
MIME-Version: 1.0
References: <aPpv8sAa2sYgNu3L@shell.ilvokhin.com> <aPstDXRerYqi1O2X@tiehlicka> <aPtg1vUnpkaK1Ce5@shell.ilvokhin.com>
In-Reply-To: <aPtg1vUnpkaK1Ce5@shell.ilvokhin.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sun, 26 Oct 2025 20:12:27 +0800
X-Gm-Features: AWmQ_bklbQ8LeCAd8iCMkzhDl9gft9WmH6KmOChrMON5i99JpRRIVdnJ-oHNJR0
Message-ID: <CALOAHbDneRGZFGcTM0YuObcK0Ugctb+6Hsxvkcy=76xDmgYapg@mail.gmail.com>
Subject: Re: [PATCH] mm: shmem/tmpfs hugepage defaults config choice
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1219420004
X-Stat-Signature: z47m4u3p7iztpbhog4j7rbokhpphssw4
X-Rspam-User: 
X-HE-Tag: 1761480784-736136
X-HE-Meta: U2FsdGVkX18QFf6lYTrX/1aPv6xRX3OGJHtvvGpFjSIdJauTUeKVL24CrqJeRBQbuCytWecO27jZl+lzQelOwDsq4pAK5oLTgxppeT+MVy7K3OSp9lExjbLPpwFq0m5g0KRceJRql3ynMraSwEWnnmVi/2hpO1q2VLAShKXTVf6ul4S9027VQc6OR6ZbX3Ox0MAh065aroiC8cIS1SJmN4+Jjaf2zLCMa7XLMxIQ4xLtsWklGN0uwNJrmiciJ//YSxTzumLAtJRVcLaY+iXyp7rdR9yPEubxXzI1QcRWyvIgLLyqjHY0o27pmO7iR6eh35lxr98ImajmJs/MiLkkEvCOfVtsOAKES0q4E9+fBiX9DgiNCy9gszFe47FN0OFQ37l0/POjr5VouoOUyLWFDkD0Blx9BNywDGKII9B/tE7eAGvhVe01xF7E2Q03OKkiQ27cW6YRhIvMTkimHFqyynJeWc1GihtVISy3FuKDUuKvKulBnbfL1vDCFwpEqSbNioee2JrMPEC1TYopaRNonVo7EiNJLZcmFX+/HV5OfILJeOfAVRtT7a/0v+ZpCykKEPOyjOcRKKaUyE//XEDjElbsT5AbR4f82YTpQ3pj+qPlr6YluSX2XhNK6XQ/d8ymTD3H8PrD8PsVup9ygALW/aBvKt4rVkdow+yBO89MeeHPEc9JFmyKtvCvfufAwXuIx9wmqnvg4FvTIoMQ6zqXi/EGfOvyZvpI1BCfAbXZ/ziMo9yv32KuZBKJLZDk/SKTQoFJuhWBFnnjLFfkdMLu/8sH98jY/3s6v+/RD/4CJXI+fOr+TH5rlWnt1TECCI4EH54x0Uxqi9L4EWrCasmHMGGqk31wi09M8W4tyHW7LXIPawbAxnZyh4UVSzXnfe261AMBly2yJAIFxZlJswYYQUP+dbBExfJoMfV1wrpNx/ByIm0sRcCGQblgeQFnDX7CwJHCv0Oppen9MzgyCTK
 6z/zMmOE
 IKZbpLhM2lb+SaBtPS0RyUVGLhAi2xTt/inTHyN4KTzNcjvO7a/IFFQgEgq5iwm+9UsnJ1ecmUFUYkWdovtbcri77P2MrMsLP7I5RsPl1aUh8ySs2cAZ4RJQ9iNiOYJRezfCMaG3u0220zdrfpvrpYYDzOE+FW58M/ECYvhJv74Zqwh5unSwgoEGOdd5DrvsEKGJkzcl1iv5Fn6BvTU8opD+3LE4ZDjVq0+c129vN905ALJcShMrGq7PwNZcFVR6+hq1zY6aXeUY6YIjwhxgprIq7zK4Ndjh8nXQAB7vRJVCNa34ta4Bv+DjONwWr6t0/TmZUQqx8O1Gbeyh8e99QWrr6zWXWD3NJMDwGpeBFlPjdeix3wlKWuXqmtaMQCjCsHzkj93mV7vFi83yjhfuMdgF1dF22w2DJWo7ENs7AEx/kqWJqWpHJK5wFn565p3qFikD9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 7:23=E2=80=AFPM Dmitry Ilvokhin <d@ilvokhin.com> wr=
ote:
>
> On Fri, Oct 24, 2025 at 09:38:53AM +0200, Michal Hocko wrote:
> > On Thu 23-10-25 18:12:02, Dmitry Ilvokhin wrote:
> > > Allow to override defaults for shemem and tmpfs at config time. This =
is
> > > consistent with how transparent hugepages can be configured.
> > >
> > > Same results can be achieved with the existing
> > > 'transparent_hugepage_shmem' and 'transparent_hugepage_tmpfs' setting=
s
> > > in the kernel command line, but it is more convenient to define basic
> > > settings at config time instead of changing kernel command line later=
.
> >
> > Being consistent is usually nice but you are not telling us _who_ is
> > going to benefit from this. Increasing the config space is not really
> > free. So please focus on Why do we need it rather than it is consistent
> > argument.
>
> Thanks for the feedback, Michal, totally make sense to me, I should have
> expand on this point in the initial commit message.
>
> Primary motivation for adding config option is to enable policy
> enforcement at build time. In large-scale production environments
> (Meta's for example), the kernel configuration is often maintained
> centrally close to the kernel code itself and owned by the kernel
> engineers, while boot parameters are managed independently (e.g. by
> provisioning systems). In such setups, the kernel build defines the
> supported and expected behavior in a single place, but there is no
> reliable or uniform control over the kernel command line options.
>
> A build-time default allows kernel integrators to enforce a predictable
> hugepage policy for shmem/tmpfs on a base layer, ensuring reproducible
> behavior and avoiding configuration drift caused by possible boot-time
> differences.

I'd like to better understand your kernel deployment strategy. Are you
maintaining separate kernel images for different environments in your
fleet? We've found that this approach can introduce significant
maintenance complexity in the build system.

In our practice, we standardize on a single kernel image across all
environments and handle variations through dynamic boot parameters.
This approach is quite straightforward to implement. If you're
concerned about uncontrolled environments, you could set default
values like shmem_enabled and tmpfs_enabled to 'never', then
explicitly enable them only in approved environments.

>
> In short, primary benefit is mostly operational: it provides a way to
> codify preferred policy in the kernel configuration, which is versioned,
> reviewed, and tested as part of the kernel build process, rather than
> depending on potentially variable boot parameters.
>
> I hope possible operational benefits outweigh downsides from increasing
> the config space. Please, let me know if this argument sounds
> reasonable to you, I'll rephrase commit message for v2 to include this
> reasoning.
>

--=20
Regards
Yafang

