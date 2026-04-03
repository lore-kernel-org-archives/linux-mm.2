Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 953FED730AF
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 07:05:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C19D96B0005; Fri,  3 Apr 2026 03:05:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCB2D6B0089; Fri,  3 Apr 2026 03:05:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABF6D6B008A; Fri,  3 Apr 2026 03:05:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9BDF46B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 03:05:52 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 320EE140391
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 07:05:52 +0000 (UTC)
X-FDA: 84616359744.22.207F4E4
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	by imf04.hostedemail.com (Postfix) with ESMTP id 17A8F40005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 07:05:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=grmfSH13;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775199950; a=rsa-sha256;
	cv=pass;
	b=HY8/FJOLrBGUIcMFWDalquyiUG195rnXaLhFvYdsd8CT+bgvCznjEH1glgY6AU7SzwFQFi
	OjbCL/JKbNTTUSBjquEIjnnSc+vE8qmPWRmFUZEtZqLsCG6tOalHIcKRxMDTk+xNyHUXrZ
	3OJptNBEBoLu84ya9ize9xRYb6q9UTo=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=grmfSH13;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775199950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SNAzA4IkN2rgUh7bSNPXBqB8n/Kvut/4jH91TJB/T/Y=;
	b=fCmEvCHWkkWTWKEpYvcIVrSRovFpv6stMos2SUumEzoBPwksP3L5Y+gal7mPexq/NKD4Qs
	Eb34Fprrio3haH5OE1YD6HBWYMWGnqw9CwRhXsdvL/DqcExHdT0E7t5/NIHpE3J+sateP4
	pP3eAG+mlnzh5H8s+cEp4ALG1Qw+01w=
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-38c6bd590f5so2409601fa.3
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 00:05:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775199948; cv=none;
        d=google.com; s=arc-20240605;
        b=jIIv/ZaIyeqyw5bUx3AMPq/cFWu1Wi7dxEodtYJmOBFKGtLjuMv6EJxODpfpDL5kJy
         PcuN/JlDvkx36QqDpAJLtPvaR/Vj+WymOpEDBD4OO+YA0sMBuHACtHh/0sXHoTbAqQ+h
         4wlB4SMDw8QQL8wT2HmXvXvW+gf20LpcIFIPswq7EicjdngnMmJ+2VPzRLZv3AUDw8cD
         JdkPiow3D3n2BhNI/7UzhAFXPxPBPz3i83TlOpFYluzn8AV9nc1u2rXfeXOQX6c9T1mj
         lMkwQ100BUrUtB5Fnuy4di78iTffYSl7VmyziOZbczpZzZLT7xtnaaKQqokSAcjKei3p
         qdiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SNAzA4IkN2rgUh7bSNPXBqB8n/Kvut/4jH91TJB/T/Y=;
        fh=nZtSyVTIyV+XGWpOo1gcotMkTpc7byND0VHMPQu0APU=;
        b=ALCIB7EmS0W5CLJXTDeHMZ9XQ8rYSRP3Qmkk7Wm04sjF3WFDEOMmK11miYEd0i6M6Z
         D/h/B+Q1XX6CostXDXMul3g98PWdaLJDbJaLb5xcT5gCVclhbvO1mNYdIrYub7R5zI3A
         2jJiN3qLXZDqotRJ473jAdoNiGH9gxWXk3sjF4jird/POspdDfz32lO2M6t9zEPcCpiK
         kb+GuDK2UONimbRmEyNciUYRnKV4QZtmhLUBLpCQtMWMqP9C2fSNH+XgUTDBktC/8Q0Q
         fCzhHAUhAhcoW7Tb56DphG6ZJ0acNp5Odok6Hb3zWP5H6KH/XZahKQWAbESO+4vORq0M
         HiiQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775199948; x=1775804748; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SNAzA4IkN2rgUh7bSNPXBqB8n/Kvut/4jH91TJB/T/Y=;
        b=grmfSH13Pj2NAcLRTGY2rjfTCd2Ufoy4DWJD04q/Fcvk8l9nKPRlS5kdg4iijP79S4
         ksHOfjFmyQppdHCMxPwKI2f0Tjx8F4NiITZvYiJUm39XuKwRy+tWIZzjxzi3krHBVhzx
         MvxN+rLq5UCQgNlxbkl4IlPyaMTG6MwXvQrGiHM9maPKKb3cf9PSZCz9/EFKAMcrJbgH
         G/laDQRR20y32EnjhsLSlzqI/hJo7YogodQsl/Wd2u0deifzSTs17XB7qK4o9tODMVlD
         ORnSwKrmcyYsNCqT57gAZRDCu2IuVZODrFUx8TPjVIL6efX+++LdS6645m7tWYyl/ScC
         rPNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775199948; x=1775804748;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SNAzA4IkN2rgUh7bSNPXBqB8n/Kvut/4jH91TJB/T/Y=;
        b=gi1H+6sR+QypEU0KI+dN9T9UfQxwTG35caENYcZ1oFoPJmNZROxb9pEDf02qj48bZ/
         C+Pml2O9Ncpz0QHX2bEL4gtBoZSlK2nXynWvRotgaknbcBI6Z8s4o8DfzQXlfWAuyGhz
         OCUcA6cwJiVUIFIt28O3v/NCINAIu/D/bRHBczCq72EPZSyCIrjLvJHf6I+jf1LK3Er3
         e4dPSw9kziuwrjoiYS4QAhsHmZsB6FMgiY6AWSMWVB/3WJYFeVV7lurywvY/ydThxvQa
         qzlu9dm/HH3LwM/1RAWGz8HBRSQ7YKKQIIyYnNpz2nyQs0v7uGc4pPli1z0muyag4Qln
         /ZEg==
X-Forwarded-Encrypted: i=1; AJvYcCUHPerNJ0+6WppTnN4lFuR/U08hLM2VPQlqPxWc0x5s5I/bXQ1VByNotruEEWXxEooLvSWlT3N77A==@kvack.org
X-Gm-Message-State: AOJu0Yw9YS3VDCY5WG2J1TDJswDVEYhwDeKbTxFjzcJSUaOvp9gBwja7
	6Aaz3jyVQDBJT0Npvg0UGGyBtr9mUHWqan79PXGjJKt6fS9+63AYYQyk2ihhEwG50OAlTIuFCci
	S56vQw9Xzz59mFzvHugC9djbLdBt4ATY=
X-Gm-Gg: AeBDieuUNeZTzHQa+iw+UqFSy9ChmS1hU6ReKQzEi4EMfdPRD+K3v8oBKLhKdoSSIzT
	za/DQvvfQ9BlzKk2dTB64fAipe1t+xRmJKO5WCDoyvwqvagWRdZM6g3s74XFSFa4qQwd8GbIg/c
	c+OkOznxq2sxStd1eglippsCMAkfLpSB4NYDPJ1JwKcDXqmPy3scGg05E83amGHN+tntHIPMYiz
	3uo+gDeniNISirvak5WAwHVHb3UxUGseTJRbnJycue11jsj+buQg9gzzp046r57VBh48RPBDwbZ
	iSOLKjqR
X-Received: by 2002:a05:6512:3c9a:b0:5a2:c66a:d6c4 with SMTP id
 2adb3069b0e04-5a337593b1bmr254206e87.8.1775199947790; Fri, 03 Apr 2026
 00:05:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260318011558.1696310-1-zhaoyang.huang@unisoc.com> <CAGsJ_4x15neqzYW1qruNUSeFjJuQokkPxrCJ_D55VSYZ6-bYNQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4x15neqzYW1qruNUSeFjJuQokkPxrCJ_D55VSYZ6-bYNQ@mail.gmail.com>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Fri, 3 Apr 2026 15:05:36 +0800
X-Gm-Features: AQROBzCzJXA5cZWdwZkLTUqqtrwfZR09gayKHq5IgdXhII8O_JEuUKdeJUvfoP0
Message-ID: <CAGWkznHc56x8REsLPJsnK2t8ZHwu3CK8fTd-Gb=sBW3X+EXD8Q@mail.gmail.com>
Subject: Re: [PATCHv3] mm: remove '!root_reclaim' checking in should_abort_scan()
To: Barry Song <baohua@kernel.org>
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@kernel.org>, "T . J . Mercier" <tjmercier@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: pxerqp8aud9tzrhxbmnqmos7ktm8x3pb
X-Rspamd-Queue-Id: 17A8F40005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775199949-565570
X-HE-Meta: U2FsdGVkX19xRMAFfcLrTJAGupD21GAcbn3GOUDeXXC8iH9NiNfkr1QrZ7GqTohVwYUYYhuphNii4PqLVeo7qD4OHIlvsv3L7uyq2m603PNxcOKTtbYqnx4pVrYouUPGJOHwvqUwBdEwkdpCJ+uVk3lf9WFToTROac02VPXkzCD/E9z5eAsLeJZo4DVOaua07dZNlTHLq6eaTv5axxegXEXON5R53LZorUbU9GgQg+/pos0dwTDWehhZOwEE9vs/TOmARd9yGF/WItongNjPdXCMpbrBL1JMEobfmmvWQ+zct2WkD6rQDqTV+mk+SCsBYSElaE8CD03ahIrO+T9l1nKNiNUU+4ZB3xLI6GePp+8Z+i9pbYo3d4fYoQGDTxDoFN7RACUfkc234D7OGxO80h8j6ElxZos3ypzRspcm+ioyHM8a8jfOQtBYZ8VmaKXUm4TDs0CgqUhjUHla1Uf4u7zvwgD+jBDpXvHPSD7BbsTjPkwyydtHp/iexOWXFQaaq7kKFJSb0YOtWwztK8qASh/xm6qxgA2IjWiyuGJhMthCd+y7Nn0+jR/izP/44+u+BFeqWD1J2QOUpmjJL6jPtMXia/B/S2PASM1ZXSJZKCLsm4txblTqWm2IUR3kPUZ3UaXOHOCg6v37xT+RQkY1bx9M8AxGyXgSuQQkaTj84bx4q793bXkm3RVO0KS6uYu5k9z6AxOV4aDohyp9tQRDrZpCdRoBQPdDlkadCYEhNx9DZ4/PjsR5Yd8DGcaBzIOjxg4w1B7Q5eleDB8TAKustZOvX5LWBl1kKUpFYZWxZRhKMWRjD2RAtrntv861hh2mJVL54Am/aXkAMBrTbblQM4mwVrso4aknpV485Nx3ZqkiLn1CkHFjZs99i9ygoAnKZ0Et0ZtiLMKEEdE3ljJNlfYTbiHD4PoDQJddCv3sEuWysvvx593zGO3t80wcXFa4BMWCq87aU4MJGBd7ZVu
 ALxbgr4j
 DxuWAcUEhoqvQOyHb7VmUwZfDctsveDtLWjTzjmYxzIwNu+umEZyJ/2BKMFYRJ6gJDN14xWUf3fw9e4SS3TArSX6HZmkV3fOoebA8s3NbTqRnd3RSyVv/n0wMbupL34+NB0tacoWB4xMTBaW8P6TnPMfZoqiFRml+p58CxoHjmW3lTF+FxwnBSQ4FTiF05HnbavhEcFhfzNC6Oek6NBNmfHD4C7hoc7hxJd7lI8SfW+rK+57sLZE12LBmJ6eR7Gu+5smmQjYO+6X5NP6PK1YjlHZD9vMj1OKFL1AM9dKQqCWqNPGPZOxfkYTwy4NNqKX85oJYnOWGGzlUNVerdaU9/PPl4IDh882CebwB1kDMyWCB9h8gZW8ptJB0wSr6XTlYD6ZT4pBqDrWk/2MgwbfM5mb9i5OEMv3ZBq9zHfROPLzeOU0ii2O3fFyUYw1dRk0zu9js+bFbHa0rVoD7jL2Sra1WmGXhht0fJxbUzrbOJQ6YLMQdWjoNZIKJDvmk1XnmSmFFIzEphYuRzUk5VorTgJrOXjBZVI2IZ6fZHLgo8XrMvLtwPz71ZicCeEI3BuSl7OptNsN0gLOqbcbebLkqAUCcAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 3, 2026 at 6:59=E2=80=AFAM Barry Song <baohua@kernel.org> wrote=
:
>
> On Wed, Mar 18, 2026 at 9:18=E2=80=AFAM zhaoyang.huang
> <zhaoyang.huang@unisoc.com> wrote:
> >
> > From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> >
> > Android systems usually use memory.reclaim interface to implement user
> > space memory management which expects that the requested reclaim target
> > and actually reclaimed amount memory are not diverging by too much. Wit=
h
> > the current MGRLU implementation there is, however, no bail out when th=
e
> > reclaim target is reached and this could lead to an excessive reclaim
> > that scales with the reclaim hierarchy size.For example, we can get a
> > nr_reclaimed=3D394/nr_to_reclaim=3D32 proactive reclaim under a common =
1-N
> > cgroup hierarchy.
> > This defect arised from the goal of keeping fairness among memcgs that
> > is, for try_to_free_mem_cgroup_pages -> shrink_node_memcgs ->
> > shrink_lruvec -> lru_gen_shrink_lruvec -> try_to_shrink_lruvec, the
> > !root_reclaim(sc) check was there for reclaim fairness, which was
> > necessary before commit 'b82b530740b9' ("mm: vmscan: restore
> > incremental cgroup iteration") because the fairness depended on
> > attempted proportional reclaim from every memcg under the target
> > memcg. However after commit 'b82b530740b9' there is no longer a need
> > to visit every memcg to ensure fairness. Let's have try_to_shrink_lruve=
c
> > bail out when the nr_reclaimed achieved.
>
> I think we need some clarification here. Does the code
>
> nr_to_scan =3D apply_proportional_protection(memcg, sc, nr_to_scan);
>
> still serve a purpose, or has it become less useful after your patch?
proportional protection is still useful for calculating the nr_to_scan
when 'memory.min/low' is configured in the hierarchy.

>
> >
> > Suggested-by: T.J.Mercier <tjmercier@google.com>
> > Reviewed-by: T.J.Mercier <tjmercier@google.com>
> > Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> > ---
> > Patchv2,v3: update commit message
> > ---
> > ---
> >  mm/vmscan.c | 4 ----
> >  1 file changed, 4 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 0fc9373e8251..10f1e7d716ca 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4839,10 +4839,6 @@ static bool should_abort_scan(struct lruvec *lru=
vec, struct scan_control *sc)
> >         int i;
> >         enum zone_watermarks mark;
> >
> > -       /* don't abort memcg reclaim to ensure fairness */
> > -       if (!root_reclaim(sc))
> > -               return false;
> > -
> >         if (sc->nr_reclaimed >=3D max(sc->nr_to_reclaim, compact_gap(sc=
->order)))
> >                 return true;
> >
>
> Thanks
> Barry

