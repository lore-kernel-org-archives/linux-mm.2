Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 668C7CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 23:04:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ECCD8E0008; Mon, 15 Sep 2025 19:04:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C41E8E0001; Mon, 15 Sep 2025 19:04:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 901708E0008; Mon, 15 Sep 2025 19:04:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 823598E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:04:21 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 34DCD11AD9E
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:04:21 +0000 (UTC)
X-FDA: 83893015122.01.6ACADF0
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id 52C9AA0012
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:04:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yAhinT07;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757977459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p4xhFRKYQhwXJkuDc/EEUioctulqeJUCai7qoY8dBkE=;
	b=v4AWchOqbzNp+fw9V1aK+9KF1pEoYdvq4QZELpj6RZ24Y9PQFfbPaMVH2uXbCop/hMtOjN
	kHTfSa6ne2GhoeKqjObNbLRDeENYFn928LBYKjsTF04htRjhpYy1Kx93E7c44mRWvhtBTj
	sziRMNGOFVc1eLEK2/9J63tJ8pJ5IcY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yAhinT07;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757977459; a=rsa-sha256;
	cv=none;
	b=D68T+a81tjKod4VcrZGEOXplZ2pu0K1KcgkgQmMplrbUyawBT2J3DMtF9owiwZIcyxQPYs
	Yz46Hizw0f9lr1M80xZD062QgdoHuL8kwmOIu//2Vr3UnhAhEUbeRE6cV8PVTfl+iJVo6v
	2AUg2rrq7h3inajC+KSu6w1eyx42H/A=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4b78657a35aso49471cf.0
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757977458; x=1758582258; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p4xhFRKYQhwXJkuDc/EEUioctulqeJUCai7qoY8dBkE=;
        b=yAhinT07hGuMPxRM2pZKUuZvvdWFcNBWHfZjfAtgcXN2+ZK4W4XO2/J6YmlS75OONJ
         HSoSRbpkawj9Fbh2//49eDDc5BjQUwRZqoZCkT+jXSgFXCYGK17OXyI/b/Avdlx20d0Q
         YtSxG9REGkGutO5pdXQEVGjSIAK0ekhu3ahLpHVcUCYCbxNY2DyXMymf1818/1mZoTey
         h9f8KuCGomiPERJbjHrTTTYoVETnV9a14rGSk4E06kWmHiDxcuHBG2cptNs334iaIJoQ
         S52RVFCM5MJW+C2tXLX92829PZzkxkz1j1bbmYT/f+lI3QzpLxTt0jleD0PGP3X1KsST
         kKuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757977458; x=1758582258;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p4xhFRKYQhwXJkuDc/EEUioctulqeJUCai7qoY8dBkE=;
        b=lQQ1yN3hXgivIl+l6eX1n75Iwy5mXGbMs9cCkE2phtXAikQDiWVJEVSO8+4zD9SYOc
         Kr2ygTd1DrmVr+iLI8BrriR2SskKHW53oBCLDHrnZVKeyN8hSemaXD5pDHUfe/RiPZuT
         RQAvjwKBbiPkkSf7EXdqNVtdH+pXYAerMsmfNI5mbKekcW7/DS16+D1wHTZm9I9o7fxc
         CpJuQCIxNE3Hvsry6oGC2ZSQjFjNChAOZ/OJ+ksjpY1sq2ip6pCQucvCkR1y/Nl3VGaP
         DynqzY3C/txRgdzRrFPzrrbSeMxbZFPAv83YHpgM0/EBS1rD1FEpF0U3+ou6favNjR0B
         J7cQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTjL/NoMU7Al4DCEWz84+nxvezxPnCjX85cwFnMC5MClNnhIePpGwhRhwTVdBJ34J6QKtd+3fhjg==@kvack.org
X-Gm-Message-State: AOJu0Yxw71f1GmT5REHJk8rZN2UjI9jiJ6fe6wy9Q08PlqFyRAFo6TvK
	xQK3KegboPgMHBWoJ2Vs8qNCNM5Ml2Eo1Rnlkz0fSZ/D7yxJhdXNgDCfOSmYSyPZdTFZ6ue4o2e
	HgZvoT6ujrW2SD2GhYijzrVLlbvmg8AKrT7YSw2Oq
X-Gm-Gg: ASbGncvsWB/J1ZXzLeSVHEu8KXNU4+6CYLKS2XrwrsUwqhtT/RiJM5sTpdZlpmKDn87
	YXIXpBa0Y4Ew6jYLpxfrDD8yCoWD79XXNqo2cH3Wwtz06goMxxlVud4KGstCNEAFQ+pL46RdHjt
	GZsnXSjbAgS2g8u7CfczMiu9i/GdESteaR6McsFusyM3TczvV6NGrVrusVHXi8Ji6q8pdQtsNNA
	/5LFfwoNWmK1JiCGieNctajavJXLBIqj0LWY3EfSghP
X-Google-Smtp-Source: AGHT+IFHHkGyyY8CB0ND1VTmYtN2gUUS8oMVbxVprvwqGNNzj2Kgq8bXC60x7DfHID1D8kjmNG6duvd5/ZOeDEgLVlE=
X-Received: by 2002:ac8:7c56:0:b0:4b3:1617:e617 with SMTP id
 d75a77b69052e-4b7b2d81b34mr1194421cf.11.1757977457970; Mon, 15 Sep 2025
 16:04:17 -0700 (PDT)
MIME-Version: 1.0
References: <20250909234942.1104356-1-surenb@google.com> <20cafc1c.a658.199394de44e.Coremail.00107082@163.com>
 <aMLvCCZbmpSE/aql@devbig569.cln6.facebook.com> <902f5f32-2f03-4230-aab0-a886fd8e4793@gmail.com>
 <20250911143132.ca88948c48df874f71983218@linux-foundation.org>
In-Reply-To: <20250911143132.ca88948c48df874f71983218@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 15 Sep 2025 16:04:06 -0700
X-Gm-Features: AS18NWBsZ6p05tPWyvjbKjMLvzq3s3vldcjpufEELtGglP0Q6Ltxk0Uz6ecdD3E
Message-ID: <CAJuCfpF7NaUJk7fwPQ7-V6DPaTo4eqL-5Xxs7iO0nzNDS9N7nQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Usama Arif <usamaarif642@gmail.com>, Yueyang Pan <pyyjason@gmail.com>, 
	David Wang <00107082@163.com>, kent.overstreet@linux.dev, vbabka@suse.cz, 
	hannes@cmpxchg.org, rientjes@google.com, roman.gushchin@linux.dev, 
	harry.yoo@oracle.com, shakeel.butt@linux.dev, pasha.tatashin@soleen.com, 
	souravpanda@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: wqeruwdosocheahbaybnyaabtfpyoq5d
X-Rspam-User: 
X-Rspamd-Queue-Id: 52C9AA0012
X-Rspamd-Server: rspam04
X-HE-Tag: 1757977459-835264
X-HE-Meta: U2FsdGVkX18wcK8CUdwyxIbJZR7DKUcghSLuftgYu8fEZTRaL5ISK8UogmaB125reG2S+XvR9I4faPP4lIzQAJX5Sscxxz0YsyccTS7+TrJZwyrKFNCgenyRJg5e/tfWU//lFfacnEl1fFIOOUwsb4PHvzDsjK2K2hKGnR4fCh4yHD+5+4FCA5saTPhillRQzVNhZDkCOR8EP+R93EYb1ST8yG6g68AqXRIm+1hCwUD9DEfli0473B9nohg+bKH/U0mSnFvY3cTOaz67VcqyS3X6ukzu9rS5Aw6G10K6eVd3YnheQWHJVQqo2Th+2zCXIzfLBlkrsxIQsxFkA6DZm4OLY9GjYDxMAFtZEtYKgiTCgV8UNPkdoccBXkKpjc7ZnBXBQnYwvDHzboLn0ApsYivQnQh7qAwS8nnISE9hhMgUSL3URc0q/D6QWETFq9gEIbuWr3j2YLiQdrGv/hVz3a1JuJnXfJ8k63j5icMqBhlKXprVzB6HSHyIZDbiik6/VW3qTRA6Zv3ogBQUqp3wgYuCi85aoujj8Cp/0Ipme9NN+9a2lkfQwoJlroidABYLkgnp623ICoMWx8l5Dsmc+RewyPH1/H+jjlGrNTClu7L+qi5maZQFDV3cHEOPsRzqfi3mW/mnDpf7UmXLc/dBV6sibHnfptT7WK33pfl4S54BddmGionOdmKNHs1Rplm7z/sCWMEfnu3ZvL5HKVFkfkl4nL8FyROdzaUr46LPW5vxmrcy7LjJ+DqFtniT3lfi1rHnSJ/KKvunGEkO/C7P4XxGbCt+L5rP+Cc3rK1HEJ4llTHUeM2TFCl1xYqx1eLf9CoWSs8EfFd6o3v/AoFQq05iJem+rZqbk3jju8YOO+oxKoSAXjTfvqoslWWuGDlx+NlvY5TcOb8rOM45B6ofAhYWron12DpOH0YRis565yE/wOcUuzODeRza3BQycHKVEtHUo3OuD47PQIrb39O
 0Ul9OJKL
 BmEJ5njdbynEz2sZJ3GiEzSGITjfuAA78w5V0iHePzgW3KDIRqPlUxSOYV4semzbCxpEXp79aGb8fueTAkZuNut4MdqWiRl/iXwTSij8zvGDvMK08oFz5T30He5G61Q1wFJIjWJ9mFd1u1D766CHtegVl2kKbcVaHw+SWYwA7YeKD3NEbvS/J9nnzPBoLJ4LqWDnY0nccWjaO51aMmWidHTeRxbjHnX+LfZNK4PdedCFkiegIkCGx/4LEQybjTChqsBV/P8jsN29fbMlTDIb7PZQmBed4HED6oc38YBU39FT8eUXhyUQuWrTRsXSqCd5HB5tPAhLxq6z1eTNpenjG83xxdl+vZYX4wFnMhqOmVOxNjcQ2eWac7UdY6g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 2:31=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Thu, 11 Sep 2025 12:00:23 -0400 Usama Arif <usamaarif642@gmail.com> wr=
ote:
>
> > > I think simply adding * to the end of function name or filename is su=
fficient
> > > as they are already str.
> > >
> >
> > Instead of:
> >
> > 49152*      48* arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_cre=
ate
> >
> > Could we do something like:
> >
> > 49152      48 arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_creat=
e(inaccurate)
>
> Can we add another row, saying "the previous row was inaccurate"?  I
> guess that would break parsers also.
>
>
>
> I don't know if this was by design, but the present format does provide
> extensibility.  It is basically
>
>         NNNN NNN name:value name:value
>
> one could arguably append a third name:value and hope that authors of
> existing parsers figured this out.
>
>
> Whatev.  I'll drop this version from mm.git.

v2 is posted at:
https://lore.kernel.org/all/20250915230224.4115531-1-surenb@google.com/
Thanks!

