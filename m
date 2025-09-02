Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B372ACA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 19:05:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B2B08E0007; Tue,  2 Sep 2025 15:05:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18A768E0001; Tue,  2 Sep 2025 15:05:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A1158E0007; Tue,  2 Sep 2025 15:05:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ECA5F8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:04:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C6A13160359
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 19:04:59 +0000 (UTC)
X-FDA: 83845237518.11.C00125E
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf20.hostedemail.com (Postfix) with ESMTP id E3DFF1C0007
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 19:04:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=C4S+AnMI;
	spf=pass (imf20.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756839898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k/iym4cIrJNo4Q5VC/UKquxFkhUODw0zuZKatOzpAZM=;
	b=gktCI2Q5wagFTF5St+nwk4f48a2Eb8R3mqK2bJ93P5I/5EzDwTdLLHNTulBGjnDt54wJc0
	7YG1rkjlYJ3JybSG6M1UN7S7V/LjvGI7WADnOQneGhKoG/mnactSJMOLazJwRmDZu24zhf
	3NhjR4y3nhHXukJcJGGxxU+1k0NXFmI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=C4S+AnMI;
	spf=pass (imf20.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756839898; a=rsa-sha256;
	cv=none;
	b=P5VF+0TR8OpbLSGH5ME9mSTqhhnJ3npJdpSOWZ8Yd0hc2indY2mNV2x4WvhmE3eZZo8txp
	uYpO1rAotZUfJJxhXwPLvyb2xhcIpAmjYNNSqdaOxPmedJHp+F3xjM6OP57z9aNVj++O4t
	gbUieA3E5SXIz/fSacRd18UNp69CPxI=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-61d14448c22so2177a12.1
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 12:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756839896; x=1757444696; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k/iym4cIrJNo4Q5VC/UKquxFkhUODw0zuZKatOzpAZM=;
        b=C4S+AnMIsvw6Xqay2CV9+TZvbeCiNzwXHMF5j4Y7AZtOHKJf3a6TUFhUsrUadWBKqp
         +GxSF7pszwomAzZHUc2Yb6ZyiDzqSLNSyCgY8xL5gwCUfKGKWCdcSEdwPCaCA4Mfqmow
         ZmWq6hqlEJ2Ki40eF6KhV5IMvGwTprNMQhA4egNM6GhwedCM0GIxMafpgO3dTNX3OQGL
         wZdYNq2LGTMc6zbNTdNm2EIgQuIGMgMdViHfoMDUJe7ju6dSaCC++nvkk8kZdkZS1ob5
         6mq/nAJkU4vQKj1PUFQCJ1w+d998w4/VQvQx8KgtbTealOYTz3KlRKujc/7rp4FChSdT
         4P4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756839896; x=1757444696;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k/iym4cIrJNo4Q5VC/UKquxFkhUODw0zuZKatOzpAZM=;
        b=Etaqqq5ICFfPzuVDnYyiLwgH/ic8pt7/KvKug53LBlHJzgW7q+sJTqyBxQzQEixg0W
         r3jJ4qPwmHN1Ut+MFvYV9GvqjtjK0nZTXrUgeb83PbEzKpe6DaqIqiHQvKenTkSi+Wy7
         AJZvebQhOiWXgvubEF2NcqBV2b0DHsdWfSyyRgysUtu2IWexqpriJSgB0ORcP5Fw1Zez
         CAokCLhlfjnYR5kzso+MFgjB2xOhipA+b/LooixwKRex70YSSnyqBrwkaLzDcDbFqmJI
         rxu7Ofx2njaWG0FBAs8F6c1/EF7Z1Bth0scmDMZGvOGW90fzw2772ONjp/sfxIOUizNg
         n/Dg==
X-Forwarded-Encrypted: i=1; AJvYcCXZfd/dtbt0qM27sj6hNTVkFpkDhqgkPjC6oWNj/GsKg6rdHc80kATW0+18176HTKEpRX4vF9C+TQ==@kvack.org
X-Gm-Message-State: AOJu0YyYH940f/IdXvY2F1WGSzpsO0VCCPQZym0KYRAFLmaIbbni0t2s
	b9qR9HZMStuE0ZuXMIMzyDMCiJcc+j0XAYBa9mjsMM06pLE/eKiQwsqedN7xPk4PA8wOLtQU6xq
	KwVYzSRhsgo34iPZyLTJbxX6vSvLrV9U/WY+maf4L
X-Gm-Gg: ASbGncs6CG4rGvRmXMz1xyHLS8hLRc8JExGJS3ArKMd6BLTvxmrjiT1pq5RhVLTUdb6
	0ZM3sYxcxMQHkepjJcoqzhe6YTLw+NPDibQpcUJ5e/w2I27ClpSV3F8S2uQK7+VUl+yWFV4rCMk
	QSTeq1yA9c2VFP0JPdR8qvn56pOtASTQMPw8kGzvJXdh1Y1AMrX7q6sp2V2dBNUufvaTRbTYwYq
	V9VM+fa7EjncRRqp2kdOiRr9curHq8laaadhyOi2WYcq82ihSVu4EI=
X-Google-Smtp-Source: AGHT+IHW1iP2K/0lzfDE5M94W+26Zi+j3C1Zop0Fbmf8Oniuw1MxpSYupR6RBrxTt3Dh2I5ouGxFOfoGIigbrfA8ZRs=
X-Received: by 2002:a05:6402:11d1:b0:61e:c5d1:5d4b with SMTP id
 4fb4d7f45d1cf-61ec5d15e4dmr86086a12.2.1756839896149; Tue, 02 Sep 2025
 12:04:56 -0700 (PDT)
MIME-Version: 1.0
References: <CA+EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5+4aDx5jh2DvY6UHg@mail.gmail.com>
 <dc92aef8-757f-4432-923e-70d92d13fb37@redhat.com> <a0350dd8-748b-41d5-899e-1505bd2b2e80@lucifer.local>
 <CA+EESO73TRAcMWeo_aXkLM+0rT5nt1cxyvf+Ye3Xp9kqxL5=6Q@mail.gmail.com>
 <f5cb68a7-19eb-40aa-95f7-51fd004a3f8e@redhat.com> <e6b12ef9-1808-45a3-9d64-5c7fd1904b5b@lucifer.local>
 <CA+EESO5FnraOUV=CzcD6t_e086pC7rDZuVv4w2ng==7KacA=Pg@mail.gmail.com> <d61b173f-ed58-4d60-b1a1-b93678371576@redhat.com>
In-Reply-To: <d61b173f-ed58-4d60-b1a1-b93678371576@redhat.com>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Tue, 2 Sep 2025 12:04:44 -0700
X-Gm-Features: Ac12FXwmHm5I2z834Z7P1GGZaAOSsWVEGTGHgu4b-CIknO62BLPfbmr4hrdBY0Y
Message-ID: <CA+EESO42EqQps7C7P1HfMJ07ioRnkktKGXO42VU0fHT_1xvC8A@mail.gmail.com>
Subject: Re: [DISCUSSION] Unconditionally lock folios when calling rmap_walk()
To: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Harry Yoo <harry.yoo@oracle.com>, Zi Yan <ziy@nvidia.com>, Barry Song <21cnbao@gmail.com>, 
	"open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>, Peter Xu <peterx@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	android-mm <android-mm@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, 
	Jann Horn <jannh@google.com>, Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@suse.cz>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E3DFF1C0007
X-Rspam-User: 
X-Stat-Signature: nj97zo93j4wcp7xzzcmh4rksskxdkkjx
X-Rspamd-Server: rspam09
X-HE-Tag: 1756839897-163207
X-HE-Meta: U2FsdGVkX18ipUbcXOdHZwbs7MqEuUreCqv3q+mclcS5ypOqof9FcpT4NpPczwVK7lI6P0WBhZ0/ajG1JbIFpn3kttWjhhg+jBrg8nNUsGMyX1sMTwywKGfnZUBw3OzGSoFKQOMQyspbNxGlYmWT4bTJ7ss31yTM52ykF0vryqoawzLz2h3kNrQ+SA2uYKVzKspj8YYIhqi/cszyAU1GtRJvfebSVO++YTdpHRJVKb4y6sXPE9GCtiVsqWvomV30NsHEnaVbEvuRyApEQrg3n7w398lxuS1q4na1WVS9hzBrYrczPHs4fLR0fNx1Rr5pawICPZ17ZeJ0GC6PsXER0E5rzq9Hses4uny+nhVaUFMPL6gz5VbqoBdLI2garJ/+J98XJ5vgUG8BnOyj1e+o6f4kMk4JxRRlqNCQ6kRXDRPtHbHVrlqcUyzpganrZBxl95ROec9BuYncOnXDSHVj1aAek9saeXP0J2gXCpDM3ekGLhUzGwxF0EXvV9qxBjA2syQ325kgX8raq/QLYGsbI/JpsG2AXY20EIVo7fJ8i/yTDWCyiOZ96zSya/Trmh7ue3VLe2VLaB/OZE1PQV3HZ3SkNjvGR9gLb+JU+VRiT4meKtx0XjDXsiF36gqO+MyIG2Z4voUWP1hMwsGuZEk/gsCoQzMHYGLIAkEV8e52IwWDaYGdQWXksacr3xL70uY4Z+scnqaBmw3+vMNKIZ9YiCIfX/aNYsMhVkK4igBAcecVAk1lNpBy1rZzm6IU3bf7getbdU2wlOIAUgNrN16wjlVdBG7Qz3fyx//nGOfNuPYdVjPGdu6DOv406O79uFuYhkpk8VRIDAyFbjcc7IG+FRJfDtzqFqSoDyBYHX6Rlue1XgiWXuyctGjxO90qILqcb10Y4MthJlDcBEEYw4T4KPU7zTzg0bn3v7FDV0qRVBPZgsQ2BSLPupD8dSP0ckMLIgGlRzkkT1iQqI0rROV
 0L350d5J
 nKSoyfNOCMOaHFed3acwilQ/P4YqciZNJMsEOKBna8w94ZYHGoXMSLZ2/UJ510F5aEud2guejY49YWGjzW42YLDIb1PEX31Lb5z8amOk2SJ9xkeXbZ7RvnEU4bVc6WJlmS49vt1G6TRhxIE70ASntQ74QKL1xtBz/HETw5V/bozOWBBobgzgU0g5jhw5Xz+lxur8265JhR6JwNVaSpt69t4TftSpIns4ouqfMWiC6AjqVWWyHHO9D/mYay163/yuSZGPzdrMkY/GeUEYYVnqJDvyfc55dK01da+pm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 2, 2025 at 12:01=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 02.09.25 20:59, Lokesh Gidra wrote:
> > On Fri, Aug 29, 2025 at 2:04=E2=80=AFAM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> >>
> >> On Fri, Aug 29, 2025 at 10:42:45AM +0200, David Hildenbrand wrote:
> >>>>>
> >>>>> I do wonder if we can identify this case and handle things differen=
tly.
> >>>>>
> >>>>> Perhaps even saying 'try and get the rmap lock, but if there's "too=
 much"
> >>>>> contention, grab the folio lock.
> >>>>
> >>>> Can you please elaborate what you mean? Where do you mean we can
> >>>> possibly do something like this?
> >>>>
> >>>> UFFD move only works on PageAnonExclusive folios. So, would it help
> >>>> (in terms of avoiding contention) if we were to change the condition=
:
> >>>
> >>> I think we shouldn't be using PAE here. Once could consider using
> >>> folio_maybe_mapped_shared(), and assume contention on the folio lock =
if it
> >>> is maybe mapped shared.
> >>
> >> Interesting!
> >>
> >>>
> >>> But the real question is with whom we would be contending for the fol=
io
> >>> lock.
> >>>
> >>> Is it really other processes mapping that folio? I'm not so sure.
> >>
> >> Yeah, I might go off and do some research myself on this, actually. Na=
il down
> >> wehre this might actually happen.
> >>
> >> Generally I'm softening on this and maybe we're good with the proposed=
 change.
> >>
> >> But still want to be super careful here... :)
> >>
> > Anxiously waiting for your assessment. Fingers crossed :)
>
> I'd suggest you prepare an RFC patch where you neatly summarize all we
> learned so far. :)
>
Sounds good. Will do. Thanks.
> --
> Cheers
>
> David / dhildenb
>

