Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 680CACAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 18:28:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 967F98E000A; Wed, 24 Sep 2025 14:28:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93F5A8E0001; Wed, 24 Sep 2025 14:28:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 854908E000A; Wed, 24 Sep 2025 14:28:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 72D4F8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 14:28:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 286F3C0137
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 18:28:19 +0000 (UTC)
X-FDA: 83924978718.01.FA85C16
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4A0C4140002
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 18:28:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=l0LdB9X8;
	spf=pass (imf23.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.217.51 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758738497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IC9nKcdgtD6FCnJ0khO3nQPUu6U/Swo2cDFZgdHuKJk=;
	b=1oFfksWLahRGhjcT3rGO0CnKom6OoqomczuqbIevV3zlKfjHSucsGfUsJYKwnjKEw5ifiS
	0rwM0Hi5r1nDjSx2G8RVIuEUfV1Zf482KsU7fhYbhJx99Dfojdg/hRY8rQEPj3cry9W8l+
	EnJdCgkDgk2QgYQ53/MvBpT7YcA465M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758738497; a=rsa-sha256;
	cv=none;
	b=nqCZixTM2OdbAntAxZY+GXC0TbtFWglhMrL3f5JQwZl41xv5NGEgXzEJOVfxBlGbi6RFwL
	FEma87aaaIZrFzXOGxOgA7O2iye0aCMyPrbJvA1KyarePjhB0hb+fHGiY+ji1XESgyz+Eq
	fvo6tIj9xqIiERH1wdrPH4R9lypk/2M=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=l0LdB9X8;
	spf=pass (imf23.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.217.51 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-58d377d786bso129429137.1
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758738496; x=1759343296; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IC9nKcdgtD6FCnJ0khO3nQPUu6U/Swo2cDFZgdHuKJk=;
        b=l0LdB9X8NbOid+PGy11phHVc/4nekmBuedqbWMcfIBTLeOajGWDWURlZsJH9x0tA4f
         qui/fGY/haYw1i81sbmdL9R4EthIIQHS2jEvykpcthYQBr+JrnxHlEzdwll+b+FZdKcJ
         94kRScWJunu5RZhIG1hMIIc4vysxcjGGcyXDiBBLHjwEVik09/GEGKfaJbc+1BTSDf4d
         N3QvI6ZFe/tn2WiV/N7jO2kefOlgCLHSn6kOaCeSd6iaMrsJN79oCc1iXtDy8kEW2k2c
         x81PbCimozn8OYKQZ9xCSHXeGpW+T6HeOPsqt/ilUddel46mbAL3NjzSwMmWouPQ2euK
         g7Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758738496; x=1759343296;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IC9nKcdgtD6FCnJ0khO3nQPUu6U/Swo2cDFZgdHuKJk=;
        b=wsN+eJiWKCtftLTUd5W5a5YueaF2SHzkPFndygFGhJjsihE/7aFbRxsGm4UUCZivLs
         vaRd5Nssj0XnAyWlimHlFQXC/OdbPCXaLBPojtU2WzKt7QJZV+qkxE0mtshiu98+8qup
         dxYMrvrsUcXluaGk8d024g7uTs+rzxkGj9/TfANBcoRcr9S0JQbvR7felHp+tGyyzLSN
         bApEppgA+LFYXUnvszYw/XD5ZV5sStDdSmI0qx+nRGLhS8mwfc/qcrrBc6RUnl7eQjyZ
         3GCwZM0xhyj6xziNqD1XgunoqyTWSCMidsNj1lcM+g3czUzkwV3uFycm69Sx/hIJogyF
         fs4Q==
X-Forwarded-Encrypted: i=1; AJvYcCXllADCl/QNCqAFF+Qs9YpiCVU3L6wrgmNaQjgxjUqAzTnOgZcpPn79hvkmzcqYvjuNveTfY9vudg==@kvack.org
X-Gm-Message-State: AOJu0Yyz9Xm0nAqMMpI7kqwHbhhJ0GTKlxQsiyBh2DFGIR+ecSAQgpVC
	NKIqadvSczgCzxXZA7NxIXw57g2vfKZbWj2kC1iV5SlbTdTsae4MakhRdUhEQ1j0QGJSIZRUBFv
	/j+w3sh4ieoDorXuPyBdV9uJ4nNRdufw=
X-Gm-Gg: ASbGncsZmi9/ItNRAhGNMNvVItMNvecTPtYunXfHCVXOkxfa/gTDyh66g68Vmbg/dXw
	+kyA5CXP1QZi4v8eHfnKDgnekkM2txh1Kryp+fmh7tJh98EHzXNGY66ajkkCcOiRJ5OOMs8mLy2
	H4xvizs6UYy3Hoj5ehRZ3LlLvgqKIAwxT42no3flhg8kIwwIXWeJDq+XFEAiY8if3/K291YcgIV
	4zGzLGfHoEufCXydWLi+azgmDEs5oVyFslIQNg=
X-Google-Smtp-Source: AGHT+IGnZ5YD7V4USsci1qW3abSoXkq9k+Mc//5cJJhmJJIWBD1IuJEsonv3BX4urHjIQD5e13xNPYxJy+BdDvyWIxM=
X-Received: by 2002:a05:6102:d90:b0:4fd:53e0:b522 with SMTP id
 ada2fe7eead31-5acd4639abbmr429762137.19.1758738496130; Wed, 24 Sep 2025
 11:28:16 -0700 (PDT)
MIME-Version: 1.0
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
 <20250919212650.GA275426@fedora> <CAM_iQpXnHr7WC6VN3WB-+=CZGF5pyfo9y9D4MCc_Wwgp29hBrw@mail.gmail.com>
 <20250922142831.GA351870@fedora> <CAM_iQpWO71vSV_0qXiUYeKYZMYF0xWNz8MrUVRkqKwDEtQvKqA@mail.gmail.com>
 <20250923170545.GA509965@fedora> <3b1a1b17-9a93-47c6-99a1-43639cd05cbf@redhat.com>
 <20250924125101.GA562097@fedora>
In-Reply-To: <20250924125101.GA562097@fedora>
From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Wed, 24 Sep 2025 11:28:04 -0700
X-Gm-Features: AS18NWCuwrysu1oqk43xTve6hldZaAK8cQhNTzJSaIvDKFt0icQ4DA4v7i2Wf-M
Message-ID: <CAM_iQpWRZ-vihMEa=k-j9EYN9itUeZLhZ14AoCvZ9mturFxAyw@mail.gmail.com>
Subject: Re: [RFC Patch 0/7] kernel: Introduce multikernel architecture support
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org, 
	pasha.tatashin@soleen.com, Cong Wang <cwang@multikernel.io>, 
	Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
	Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, Changyuan Lyu <changyuanl@google.com>, 
	kexec@lists.infradead.org, linux-mm@kvack.org, multikernel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4A0C4140002
X-Stat-Signature: qg8q69gjd4suwtj9y1mtstrpbcuc3ffr
X-Rspam-User: 
X-HE-Tag: 1758738497-186415
X-HE-Meta: U2FsdGVkX1/A21hnyglQt+2c2rFMDbrCa0C332GzrgZKH9tPHRlfXHjRGz+lRT5cxso7xEXu4qr53NZeNb05zAUEXT3oV0OiPYSZfaU469K4K6QvYGboTzWHyR8E2oyK3uUHjeQsYhlxlZUWoPRT1pHaGAqTvV66O3s1FGCn2w9lcwGYzJ2rNVR28Go9IUAa/mGKCWNJEzGPDu9oRGGiPgc0XkNADV3iQntMTgde2ciMQLND6APq/HnLzYwkJEB5kT1PITn/gtLFFP/96Bth38+Lkux8BLRoeiWLHpo4qpSd29lR+uCbofW1GK9Lxx5LNIZApTTxw9z+ayTgl+vmAbfsajipya7sTjcPiVBYT+RIZlc/TJtldxOR9i9pJRQT/5wV/31QZACLyqNuv+FKpV2CT1QwEpF8/ApgpgUcyly34jFkkcjw0zi+KGzFNV2snX+HtOlhM7X1sFcYk2xrAnn+nSbGBla+5iL1ZALauA/fuB8TkiniWR7wxoRr8nN1BZwPKqPiE0jrO+oJxd2klcFA2fHDpThdz1PAnPsUW5H/U6XKEgrYYm3+haDO8ImxKRR1t5oRQbDsxX/SgUAffhVEcr4AbI4ZMli/NfJ4Q0br0kgiNwK7uIPpMKoPSSDYX/GdU8maU3L4m6pclW+8qUlyYxQLveZ2JQqlfLNFSP1oREBHz2RbUofntyYrdFDjjZqmktRxC+067Z+I2ZzSlFsvUvxkA+cqmtDNFIZRl3zDfp2JzGCYE1feGk8k9ykk4xyOtxlXfiStoEcf0wT+FpE3IKjZcFy9u+MV/Y9eqJ1c5B79bxzHC44mXO4JlDxgpUwP+RzLZovdZcF5Hd0EQlIEv8GTYL45PqAFtMDQeFiVhZoJsnppCn1fOExNMatVb6OQA8ys2T07TlleIlzcAsLOlUyd5YLUB0QOv1A26optIHJy20XA7sawzu80AYuNLNKYdJe6Kr2QG9o4P6U
 ZBjjbeie
 /OQLSiSKTdbdSIIXPSnZ1t16erbK/+JFXOKQt8r88Wtrt0HcO0AFUmprQxCScAvRMA1pb4qA5UyGDs/cy2iOGp0xovSNSXbtUMAwphISDOs7ADpUZCt2Ngbq4pWD8ug87oQK4LH2UNKRf4EFzFoEXUi/ycD5onxQNU36MM/dRFnxjPG4mXczBAly0890B2fDMelrseg/IMbFo0aYNzVtPZf9Dy0Fz0zXDocx56ehs/VAQdoenrkdO+GEhQgm0C7m//aIUco0ZJ9rKvOlDMzYYv7lqn/uyY0KTAjv7wfq3A3x+SnHOwKflSZ3KhVNWEERaK8hmfG1tOCr9ZDJvXFM3Md3mCSJrDyuvcLfEUKanEipHbnDbcgc62qDRJuS1s8M7g8TE4Hltm6gQh9+5qWw6b5/HQIT+jFD/s4vV8apEeHM6gLg/0p+L5gDozg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 5:51=E2=80=AFAM Stefan Hajnoczi <stefanha@redhat.co=
m> wrote:
>
> On Wed, Sep 24, 2025 at 01:38:31PM +0200, David Hildenbrand wrote:
> > > >
> > > > Two more points:
> > > >
> > > > 1) Security lockdown. Security lockdown transforms multikernel from
> > > > "0-day means total compromise" to "0-day means single workload
> > > > compromise with rapid recovery." This is still a significant improv=
ement
> > > > over containers where a single kernel 0-day compromises everything
> > > > simultaneously.
> > >
> > > I don't follow. My understanding is that multikernel currently does n=
ot
> > > prevent spawned kernels from affecting each other, so a kernel 0-day =
in
> > > multikernel still compromises everything?
> >
> > I would assume that if there is no enforced isolation by the hardware (=
e.g.,
> > virtualization, including partitioning hypervisors like jailhouse, pkvm=
 etc)
> > nothing would stop a kernel A to access memory assigned to kernel B.
> >
> > And of course, memory is just one of the resources that would not be
> > properly isolated.
> >
> > Not sure if encrypting memory per kernel would really allow to not let =
other
> > kernels still damage such kernels.
> >
> > Also, what stops a kernel to just reboot the whole machine? Happy to le=
arn
> > how that will be handled such that there is proper isolation.
>
> The reason I've been asking about the fault isolation and security
> statements in the cover letter is because it's unclear:
> 1. What is implemented today in multikernel.
> 2. What is on the roadmap for multikernel.
> 3. What is out of scope for multikernel.
>
> Cong: Can you clarify this? If the answer is that fault isolation and
> security are out of scope, then this discussion can be skipped.

It is my pleasure. The email is too narrow, therefore I wrote a
complete document for you:
https://docs.google.com/document/d/1yneO6O6C_z0Lh3A2QyT8XsH7ZrQ7-naGQT-rpdj=
Wa_g/edit?usp=3Dsharing

I hope it answers all of the above questions and provides a clear
big picture. If not, please let me know.

(If you need edit permission for the above document, please just
request, I will approve.)

Regards,
Cong Wang

