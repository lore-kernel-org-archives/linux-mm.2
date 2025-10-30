Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B0A4CCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 21:27:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99F538E01E3; Thu, 30 Oct 2025 17:27:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94FFF8E009F; Thu, 30 Oct 2025 17:27:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88CBF8E01E3; Thu, 30 Oct 2025 17:27:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 708CB8E009F
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 17:27:34 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F320E5701F
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 21:27:33 +0000 (UTC)
X-FDA: 84056067186.26.0638C77
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1384E1A0007
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 21:27:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GH85E4ue;
	spf=pass (imf19.hostedemail.com: domain of peterjgray999@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=peterjgray999@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761859652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G2gY82C8nLyw94EfwUiPT9I8jzFFk795RN8AeGsby+0=;
	b=G48WeGqshGXM+n5PAPLh0D1AE1Nv4U5paKNU/+X/rfRoVip1w/3/bkSI1fMJwj1jOwAAjK
	C2uKjrf9bX9CITus6KuWd6ZUNcEMHvxC4fsZZoyfEyuBdYEaA9ReWYgOIvqR8nzeKCS0ib
	6wj5f+A5AsJrNuWwHMxsYCLuWydX7T0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GH85E4ue;
	spf=pass (imf19.hostedemail.com: domain of peterjgray999@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=peterjgray999@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761859652; a=rsa-sha256;
	cv=none;
	b=hiLCMx22/zAijpGRWQgc3Wr0a2urlxVTo+HMftdd2DXpEi5M0vtUrJKRa2e10n3up05SLw
	uq4+6+RNH2CXrbFG5JOv3JGRnG2jY8JUtkJgMB3sriguikdj+l/RA50115wfHldn3Lc9bB
	CnPy89LLiqm7atXFni+a1EMt6zU7hp8=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-63c4b5a1b70so3341329a12.1
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761859650; x=1762464450; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=G2gY82C8nLyw94EfwUiPT9I8jzFFk795RN8AeGsby+0=;
        b=GH85E4uethIz3GLI/gy0mo9UOg6iPDwMWFxf79qCWi3x0TjPrvktvgnnfCX5y4iQa+
         lEnIuE35kKB74gudNlgim+aetMW4chaACvTtlJt/xS3a4S3njHkonx+fOnnrIfkLB24y
         DvTyvH42yiWlxr935wAISbmUxGE8ePgKUi9xq6J8XK1vU9P0wOaWl14eYrcK6WzT3E9r
         BlmsslYcO2/Hl0byIrCS1bZh08DraAdfLvkyAOULttLkkwU4zkije20xM0yQQJ8Sc/u7
         Nx2RlpAjmgG+x7FrgM/lfNjSPsWRfsUvKhUMLqWchmG5y13ynCzCiYsnNU0eutvS36WG
         Vaiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761859650; x=1762464450;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G2gY82C8nLyw94EfwUiPT9I8jzFFk795RN8AeGsby+0=;
        b=Nywv3bUY1HEegaGofKoGmCe5WA1hRkDyT63ZW6IFdBAOhd73LlfgsOsm2YF6q5laIC
         18/rn/ROzuvnY2Q//5lcHq0eFdWvPshaMHOBsk++7fkUq/IkNmuIsLNfyh2iucg4K5qH
         QcSNN0pC4h/ciVprf9DlahT5o9JV296Q/q0PWnG+1Ir1z/Fb3l9M8lUJKprgbfOj8wYc
         BZ6KLhmx34FICeG442BLpf+cWcH/H8tSXpdugBZeh/y4rhPGaGsx0ZwlVE8DmuaBSg+2
         +v9UyR6FiVKfLKAYlG2t3dqRusEuGYuX9AiwE/967UzNPiVpvCSQuKsrQvL8Nq9iZhhY
         Qnuw==
X-Forwarded-Encrypted: i=1; AJvYcCWN2Sm/KGQ4Ke06j0GZXTxzWRlZWFi0CncDIvWL8UJCXVXU1Y9NKRXAJ1iAhOnB1KbxS12FJ0Rr7A==@kvack.org
X-Gm-Message-State: AOJu0YyWRFDkl3v2bS9gBRSaruRSBO9NqowreAPgA7wGo/eP3dmTnJQo
	g0FhGmzaXfk+ALdHp85OgKg6W8/CG5BZiCm/ndb8DUws4ydD7S48oHSFJ/RP9vhCEi3Wsti2sC4
	WoZZ5ZKsT7kiQl4u1PfTmxAvkkqJTo7s=
X-Gm-Gg: ASbGncskbAZ8KcH9e31wwlNZPUXaWqMo2KwihkYC5fOIIVNAOtThkcLAywsVs99P78H
	h6XRGG09JiKLyVnczUnB2vVU8iZRwuvzB/exNSGUSvlPTgjxROy5timE/YND/aDtLuVK6cAWD5A
	d3zX0zbQIKn4Zlw+U91l8pciC3DAx1DOPZmH/D79+g2TuSRLPqaBvs6d+uxu1DH2POUoq8g1ZHX
	GAhcOcCmjhFVPiP6Yx2YZP9BD8tQN62Hl3UbUzskt9eff0xW6Cj0OKbVmYg99pofx8Tu5BVDx0R
	JuCVyof5wtrLoaWvAbGzI2zlJ5dehpvO/Yo=
X-Google-Smtp-Source: AGHT+IGLu+PCJltWDujSpQPIkY5FNxNB+Kt49ac69OQRIVOUnPy875s9e3ocPHOw6lCdck1PipJMXtwmB9MhLWw0d34=
X-Received: by 2002:a05:6402:1ec2:b0:63b:f157:bc2d with SMTP id
 4fb4d7f45d1cf-64076f6bf8amr902937a12.1.1761859650094; Thu, 30 Oct 2025
 14:27:30 -0700 (PDT)
MIME-Version: 1.0
References: <20251014231501.2301398-1-peterx@redhat.com> <78424672-065c-47fc-ba76-c5a866dcdc98@redhat.com>
 <aPZDVuscFsYSlQjI@x1.local> <dtepn7obw5syd47uhyxavytodp7ws2pzr2yuchda32wcwn4bj4@wazn24gijumu>
 <aPe0oWR9-Oj58Asz@x1.local> <nnxhd7zxjza6m4w4lr5qyev2krbkp4yfcgcwq6nkaqrqt6bzpb@iklep2xxp5gv>
 <aQO3Zko6Qrk7O96u@x1.local> <aQPCwFZqNd_ZlZ0S@x1.local> <d0b037a6-11b9-483b-aa67-b2a8984e56e0@lucifer.local>
 <aQPU-tyo_w68cnKK@x1.local>
In-Reply-To: <aQPU-tyo_w68cnKK@x1.local>
From: Peter <peterjgray999@gmail.com>
Date: Thu, 30 Oct 2025 21:27:17 +0000
X-Gm-Features: AWmQ_blMSRgvqIQWevhuChxEd5G2uJ2xb-qez3wJLdFHrAINA2vrHCmzKSt6Cuk
Message-ID: <CAL_esO2M6Tpqj5zgHXzbx1NKF5pU7kGBM7h95PBZYgf2Rrg8zQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] mm/userfaultfd: modulize memory types
To: Peter Xu <peterx@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Axel Rasmussen <axelrasmussen@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	James Houghton <jthoughton@google.com>, Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>, 
	Ujwal Kundur <ujwal.kundur@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
	Suren Baghdasaryan <surenb@google.com>, Andrea Arcangeli <aarcange@redhat.com>, conduct@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ijgzqqy9az8894mdiduimi4gr5ahozh3
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1384E1A0007
X-HE-Tag: 1761859651-961702
X-HE-Meta: U2FsdGVkX1+LF6Ej1ul/rEm1RaG5TpeLfSbYMS4j0+RUPbEdm0u5G5IXAZ/FbetuTC3R3eLVevOY7Wt5ONABDfLJF98pdKOoNnc8Dem0TrJgfgLCKwDyIbxlkTyGiPr6CMsoyJy/64HvGbhgHicXqmWctlpg9n4plOdiiZP5vn2pIyZ5ToHeM4cxc5z2zHy5QQ6Y5Q2nEVu2WQuHSWosZc6xFAYriKDbE2eAELixshYmus2jYf1eo3gROblQt/PyWXPUp9+f0UBR5OOTDCivYxyeENK1GTbYmWQdmXxD80vQZlTCOT18KdcIypLWdv+AHG19bwipgvJYak/ZhSVmdV9yfeQOOT3GJ9l+H4O75lK8aSow+8sLoYOiuCPdwjokreMlqBqgoozgJ729tXXkEJdQJgfDhYgHZGiM4YBxvpmox1xis/LuNa0hPZpEcjaGfi+WLjMv/zErQSdBL4iPJBF0uQGfesYY8OuQMohquG25xkKVFprQ9Y95btXwgc/94JQUuPjm6lbfp8tiKOALSVdmVFGzrBzpAWd9Z8taknFiJKbnYOUV+jHz46tZ7VRne27lAwjfLKMaFICctqqU+EVibQhuB8L9KqI5WH7doVrDU1Xo0dSbqCp1azs/kcx1eokb/u/CQ58AjgF6SyEesVSLebLLcMwp7CNQ9DWQw71OvDkmqVcuVrK8JzDJULx08HoiEJdT89MHHAjXifWb5wzg+KVUtt5yqkQBBO9XwVqn31bj7NIViCyTTOuKQg8vVmCcRaXbEiTIxvGykS4Xu2kkT86g4/8jEkWcUEiudTpMLL9dOgImoZ5+BGtBCxxRvxBvjy8DtmkK68iqMt7Wi7nRxELOI5KEbNokVj4OO1CZng17qA09El9wQ5P3FJTPJVbQ/K5tUahLLIZvxe8rnYfPtfMO1KT/RDM2R6/UYipctgY5nJha0YqwZ7d7Ys84vEa6QOvXXiAZP7RbmuE
 dq2kU3Dy
 KQOVUYH5BO+QTW/auFsTma+IeMQUGKv84PKLiq5KL08wQ/2ClWTrDsX/dhZKj2uRkOHVY2Va2N6MeUn8QW+yzwhLcSi58LuMPaNfcT4c1FAg579R4OgyGwMFjAEHXg4U9pRa1kcpSGcl98b7WDWWcCp2yvGZdhxFpdW1R3RlHE7v91UDAG2jVuv3BotfIl8qsMMRvLt7valY8RH6+jCLosw6eyHuMzyj2Qj3XRGx8wXf8K/AqAHEHJHrj06xbM8KoukLRDPLVjiOQN0gy2CY9Y2ohPzon+Y28u0CE4h/FU9Jew7Wg12Es8i84adg0nsK17fUX4aZ3jLHlrytREC7OyK5PZKmP/CKRbSZLCnqszv5oZ5a1BSlMVVLIydQpBoAwYYyuX9zA/wDSbtgi+fcZcancrKS7wtCkxz6kHihtooJV77+ADbK3TmvARA8e4IQa1qo/iiv93ieltBaCHAuNsrBJ4h9U8h3813cH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

thank you


On Thu, 30 Oct 2025 at 21:24, Peter Xu <peterx@redhat.com> wrote:
>
> On Thu, Oct 30, 2025 at 08:23:03PM +0000, Lorenzo Stoakes wrote:
> > +cc CoC
> >
> > Peter,
> >
> > I'm sorry but your reply here is completely out of line.
> >
> > I know tensions can run high sometimes, but this is a _good faith_ effort to try
> > to find a way forward.
> >
> > Please take a step back and show some respect for the fact that Liam has put
> > VERY significant effort in preparing this after you _repeatedly_ asked him to
> > show him code.
> >
> > I am starting to worry that your approach here is to bat off criticism by trying
> > to wear reviewers down and that's really not a good thing.
> >
> > Again, this is _good faith_. Nobody is trying to unreasonably push back on these
> > changes, we are just trying to find the best solution possible.
> >
> > Comments like:
> >
> > 'Your code allows to operate on pmd* in a module??? That's too risky and mm can
> > explode!  Isn't it?'
> >
> > and 'that's the wrong way to go. I explained to you multiple times.'
> >
> > and 'I'm pretty sure my code introduce zero or very little bug, if there's one, I'll
> > fix it, but really, likely not, because the changes are straightforward.'
> >
> > vs. 'Your changes are huge.  I would not be surprised you break things here and
> > there.  I hope at least you will be around fixing them when it happens, even if
> > we're not sure the benefits of most of the changes.'
> >
> > are just _entirely_ unhelpful and really unacceptable.
> >
> > I have an extremely heavy workload at the moment anyway, but honestly
> > interactions like this have seriously put me off being involved in this review
> > personally.
> >
> > Do we really want this to be how review in mm or the kernel is?
> >
> > Is that really the culture we want to have here?
>
> Gosh.. Seriously?
>
> I'm ok if this needs to be audited.  I have all the previous discussions in
> the cover letter as links.
>
> --
> Peter Xu
>
>

