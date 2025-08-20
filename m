Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBC14CA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 23:56:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65D2E8E0044; Wed, 20 Aug 2025 19:56:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 633A18E002F; Wed, 20 Aug 2025 19:56:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 570A98E0044; Wed, 20 Aug 2025 19:56:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 435AA8E002F
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 19:56:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E3B491169F9
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 23:56:15 +0000 (UTC)
X-FDA: 83798797110.17.4FCE3A2
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf28.hostedemail.com (Postfix) with ESMTP id 28D90C0012
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 23:56:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WqpIU8mf;
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755734174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BWLf9Ffl8Lgjnm4H3/4VJgmHdaGpuVsmKnK8xjeBnZY=;
	b=HyEmwpn/ENrZy0oofIlM/Vccjq/AnupFDZbkGe2xaKCm/Jfj8GBjUJcH86/B+3EbuD7CVG
	cSw3wQuDo0Gi9Kbx5XtPvTSAOQS9xCS0v8auNL4gOPwC0AJ+UPttWMQiv8EWZyJvYv/N7b
	4YqUFM43vgEFeYexiOplYzpmaHXyRcU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WqpIU8mf;
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755734174; a=rsa-sha256;
	cv=none;
	b=dUZrsqeYAZoiarcH4smlU687GkJZbZbZARIlLJpFGS1wvRZXwP/FAh5H2mS5KRhzRG1Y1B
	sXk0EzcrFuGf2pF28jT96RiAbx+udWbTaA9sd6VRBHNLaZgfknwOz3NVuQ1otPupTcwvoo
	LWpdNCsRlAtohXwd86KwlMEy/WmbTB4=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4b29b715106so87911cf.1
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 16:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755734173; x=1756338973; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BWLf9Ffl8Lgjnm4H3/4VJgmHdaGpuVsmKnK8xjeBnZY=;
        b=WqpIU8mfD/tzg7YfBSCFp79IIV9EgOXx3qL8tFe340/jQogYxoOhW1bZXPtgCYlwq9
         0zLIlA59R+2o/kc9OibMckA5LFlXM/01L/P+cl3Hn+qG4oL4I1hNPJEYXNVlFhaGp5Oo
         mu2Q62engbwVnDO70PwaVugt5v3MZ3FcZyy/tCbo55fSSdg6SLt+nU+UQp6KnODuVWxM
         haEQISh06Ade5bDy6fMOq3RcPW/7khH2lJLf2pnUjx4WhwCOuReT4ijPBW8O6XukUgR6
         Emb7dUAPVVgrq/BlkQQMX+m6q+wIhFodtSGYOgzJceccCMS5AM8/w0IcTkImA6LPxNXn
         DqvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755734173; x=1756338973;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BWLf9Ffl8Lgjnm4H3/4VJgmHdaGpuVsmKnK8xjeBnZY=;
        b=pItm0jdE/8W9BqgvRR4wZuLlyz4dnT/BvB6JazrzUl8tP1N0moEmngGR2feUD5l0ij
         V/7TVUgEoiAV64Gdcyg5AufNrJSAy2tvxDm72fUAtTBoQ5Y7SYMrqi//2BNsixiMTkQ4
         fLtdYz/kq8JyySjo03wjlNBCMDp/e3jRTut0GHTY7dClBwmW2sXjfeMiO00dY23/FK5g
         SvKoGaeevL9V1fWxXTaDXe9WqymT0g646d4OJ/VP6D3afaqCmvSL4jbaKzVHfs76Z61u
         gZu9xH8N4aXE4ovh3g4xEkzmVfZCGrC23H0fLkD1acwhiIlXvE5aprZfUmpNbudEG6M3
         EibA==
X-Gm-Message-State: AOJu0YxsE/F0Gao05DZ3/tfMCEp8gWsRZq5QQpXmlGagDX0fBR97czTJ
	c7dWUzH7RhHwmIBCVZ+et2noHcKZsWuRDJBfjYHE+rTjAtZCYCkOMxZEdT1Ctq8DuQsWMpdy+E2
	IpEZflHsP0jn1t1dLZ0wp0yIUNrUNDJgLRmj9shIY
X-Gm-Gg: ASbGncuKt0YPCVWWNqOGgQuXT7FGg4IO155ppBERFFU1n3U/zpSaRKlM/FUAzrzkdRm
	4QH/Sfg4ZwzCochxxfW9ArUHMY56jWb1XYgUPiVkH25UCw+LCwqsxoVPGW2PfFrOrMfgLIm3EOZ
	ecAUMpYODnn9EGtFprUxssBIGvOCHBJEADuiTwJ7HC3t81LPQ1C0GMWi8DhwPvYJ/h76WrY094x
	IWygWqncRw2T3V+3AdrHbY=
X-Google-Smtp-Source: AGHT+IErfm7yT7BCKqe17sShglHdYpqJIMTG3Y4aNX1t1u/ZKhg8vLO6UDcBNhy14F6ojhVjQYxhN/ouE9gCg8dt1rk=
X-Received: by 2002:a05:622a:594:b0:4a6:f577:19bc with SMTP id
 d75a77b69052e-4b29f797447mr1131141cf.18.1755734172886; Wed, 20 Aug 2025
 16:56:12 -0700 (PDT)
MIME-Version: 1.0
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
 <20250818170136.209169-13-roman.gushchin@linux.dev> <CAJuCfpHUDSJ_yLEqtfmU0rykUGYM6tXR+rgVv1i3QjJz+2JU1A@mail.gmail.com>
 <87tt23vt8u.fsf@linux.dev> <87cy8qx50g.fsf@linux.dev>
In-Reply-To: <87cy8qx50g.fsf@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 20 Aug 2025 16:56:01 -0700
X-Gm-Features: Ac12FXwHFX4DgL6ZNVWka_tcMoj1Wu2SMzrvjJmRsLac3uNbaTN5z0M9dFMR-KA
Message-ID: <CAJuCfpGGAEh0pnbp8jA+0LgdT5k5qtGthJQopHZz9vzXZ8KQ1w@mail.gmail.com>
Subject: Re: [PATCH v1 12/14] sched: psi: implement psi trigger handling using bpf
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, bpf@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Song Liu <song@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6zmdbhxx43pgt8s9ig6joi6oq8k1s14r
X-Rspam-User: 
X-Rspamd-Queue-Id: 28D90C0012
X-Rspamd-Server: rspam05
X-HE-Tag: 1755734174-869263
X-HE-Meta: U2FsdGVkX1+4viZnS1fCG2GFRsrJc3rOQnQCuyVLuM2v07hFkNZQawVuUr7/+NBov56vLB8a0mX+1GF2tzjH6XxSH+tLOrqZzfVgzngHc21t+tCRigY9VNOnzMMLQ0ta4KzOZlzu6qtZOkNYak8fV0+PhnVZXQxuuzE9v2y6c+re6Y+b/uXy+x88uu1tNTta+k0Uo78gmLE9K+lslIflkZDlzv5mH+yIHoQ0PJOpcZLfzTPb6WDa8njj8oTKSADJ19rPkQ1DgA+NWiijgdRHS4FjGzTLeliDUOzGjyFg3sHn1ZeOQc2cDrNaIpFZAv9nW0h55w72ctpkNokOhlVQsvwlVblszIdUchftBeJgjQpNvQTysHDxt8m8EXBjfkpxIma0XQtgLX1sXqkYGYb1CRSx9NTiFdtv1Yhhve7O3a1r+MJLum1eAkhorWVS0Hj7IyrkoecCmi7D2XNDmx8OhcmywPtwSCS8QK4uANBQu4i7qCZ+zZisnYWunwtk4ZcNI9B5AGY5umcCUHZ+7pcz4GjtXFrY/qdyn5NskM1jw0KdAnecVH2Wb2dCvyo4UzNDvDKgmCiz4LqbhTQ1W2+2CTg2gpdPLq+swsYYUJ6kqQvA6wwQJbhy7bDzHb7QIN1wq8jvFtk4++ptfa1CwRYI+w3AFwtoFMFqsp6bWDlYFuLDPTaYzBoEFOygVBAYFOmaZsfphzng8DUpNPIIrBLenqSX476L9o5IGqGlohU7JnuxnouMcB63MgBHksbYqotsEx9u0yynJAmqm9I/kjhdXbwxAzFGwxcUwQO+a2jD7PTd/SRCQtyq+d2OWes9LGyDnsTZT1QLFiEwaDDNXsAjFZMhB2stPVEtzSnFs0ktSRvSt9IdboLMJkYizBZrk8FkGYjTWGDropaVI46o0uJ9lYTismcTCh+ofN3wXnbZKDZywrj2p2YeYILiLBP+0lZge5hna3XZo6gIWWjHJ8p
 72BEPKl9
 2uKZZ69XgYN2lGA/qulYmZHwp9LCi4SbZjo8eU6IrpyW+ba7FsAR0nyvAJ/GV24u3CTW6yHQTxz5rPUt9JzUnYshoembizovFZKcGnPJs1Jj/ifDVlvpGUq12rf578otziYXgxYQFrdaGcSosnAgeuCWLSXjCsuOPnAu3CLF6qWmJwBPDMrjBmJ8YW9lonz9P6uc0Es6ldkAEGjdqlHCJmOYA8Tr8cOqBAdflU0JW2JcK0rA1JSd/FD41vcexeGio1ihU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 4:31=E2=80=AFPM Roman Gushchin <roman.gushchin@linu=
x.dev> wrote:
>
> Roman Gushchin <roman.gushchin@linux.dev> writes:
>
> > Suren Baghdasaryan <surenb@google.com> writes:
> >
> >> On Mon, Aug 18, 2025 at 10:02=E2=80=AFAM Roman Gushchin
> >> <roman.gushchin@linux.dev> wrote:
> >
> >>
> >>> +
> >>> +       /* Cgroup Id */
> >>> +       u64 cgroup_id;
> >>
> >> This cgroup_id field is weird. It's not initialized and not used here,
> >> then it gets initialized in the next patch and used in the last patch
> >> from a selftest. This is quite confusing. Also logically I don't think
> >> a cgroup attribute really belongs to psi_trigger... Can we at least
> >> move it into bpf_psi where it might fit a bit better?
> >
> > I can't move it to bpf_psi, because a single bpf_psi might own multiple
> > triggers with different cgroup_id's.
> > For sure I can move it to the next patch, if it's preferred.
> >
> > If you really don't like it here, other option is to replace it with
> > a new bpf helper (kfunc) which calculates the cgroup_id by walking the
> > trigger->group->cgroup->cgroup_id path each time.
>
> Actually there is no easy path from psi_group to cgroup, so there is
> no such option available, unfortunately. Or we need a back-link from
> the psi_group to cgroup.

Ok, I obviously missed some important relations between these
structures. Let me digest it some more before commenting further.

