Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 794FDC531CB
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 20:26:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EF486B0088; Thu, 19 Feb 2026 15:26:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69D166B0089; Thu, 19 Feb 2026 15:26:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 575826B008A; Thu, 19 Feb 2026 15:26:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 42F8C6B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 15:26:04 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DB45113BABE
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 20:26:03 +0000 (UTC)
X-FDA: 84462337806.17.A338B3C
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf01.hostedemail.com (Postfix) with ESMTP id BB67C4000A
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 20:26:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=O47yDVE1;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771532761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LeBgE4c+zffhnIxLomDqTnQzqcUsHtC9ybf+HnwTsGE=;
	b=PdD2x4ztCtouEXaEGMCIgcCpc7Cm3mNIPWBLU+hJFQJSLn+TMD8LIdlLZR9ke31w4ZmGqk
	MZM35+SiVGG5KgU9gpZLM6k2qDI9G3B6Co9xKkUiyKVheGtUhgqqlhh+UzTeB4b9YNALj0
	Gt5E3iRfIDJN0n0WHC1GGBkJa33w73o=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=O47yDVE1;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771532761; a=rsa-sha256;
	cv=pass;
	b=dTqx7iccMF/2vmiWPl98mii0sWc4TLtHLSaV8lXLP1s/CcYyekdudYSl4SMx7k50DCWtot
	BNrHTrDsR6ffoFN+ZwxkxbN6ZIhpu9T6QO7YmLnDh3UZ8R9VXHl6Gl4p9y128gWTKhT5yq
	H79bLYoJ7xF8qlY4EWUgdgmz9nmkH04=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-5033b64256dso106741cf.0
        for <linux-mm@kvack.org>; Thu, 19 Feb 2026 12:26:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771532761; cv=none;
        d=google.com; s=arc-20240605;
        b=LdiGTJvFskGEdYS25/v67dcdzkHI+4Nva1LzfX3CWlgSPSTPkbrOSaBsTR75YmjOVG
         SWDcxdTI2VX0aWaeK2rgSb6E4jgMG3tFVNDeFcIppTmGIRea5c5AJqogCrcFg0sjgQBM
         4OVyuKip71/qPqMsAQXE14/2nBOVSAsEcGhyAqvYzpqUKUUc7wCi/ZBLzQRw5Umg3kET
         i6MIrU+O3hcx0BJl7CHHQQr6f9qbJm3Tx9PnyDWxoV3t+oX1Z+CBzatkrah6KBt+l9bK
         kntC5sIGPXLnu/+Xm04BXlSrmN3eIcTmstVshVYR/yuEjc8H/pNqxKb9C6aTi1oLg5Ac
         Fo5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LeBgE4c+zffhnIxLomDqTnQzqcUsHtC9ybf+HnwTsGE=;
        fh=YstgF6KmXfNlAWyCmyLW1OeLAx1LbIhKBfQSaSpnbSI=;
        b=kF/lVPqRwK0cANcsKZ3IVWOJ4o6Zrpn43+CxJ+sM7NG8dnVJzbhKu5ufTYxNhEoZ7/
         aUcV1uu6NYqgN4y0W+IwVcbnOemOImcHCdn560zGSibeQ7WuWJmK5E0iN0MLijmg9HyY
         6aW0YF1Gr4o0QUj6FfkajCRQjTcnFdXcijY1oUOpy3OZ0mccuNXakMwfCpKNeDrnuZO4
         IA6Cx7C4+FYDSQ0OP09LX7BWXhFrpoc+cEjUahU2XzrldBt3y+5jgqqgcV0+oyBzzFL4
         jJc/tEUx6k5sI4aeeNB6LdKKYDNiHKh6CvK7rlteFo2Fk7QShsC92eyuVldD7zlacYVj
         CUvQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771532761; x=1772137561; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LeBgE4c+zffhnIxLomDqTnQzqcUsHtC9ybf+HnwTsGE=;
        b=O47yDVE1wNpe7YFW2TeafoKcwWnWPT0swk8o52Asee8Tx2mHpTm5nF6q2YC0zZce5a
         AyfqPum14w1rKVHNGLSGsCTefcljkHbi9uev+npODQfahiKU+56Or1St/059Q/PRUD15
         hCsoKjIccXs3JV3IiExSa1dwQfMZlCmB+hI1NyTkz4GS27bS2bXLNaqfjudySlcorW82
         i/pSWBfUrj8iT1rw2IgpCh+ghLorbk4en1xlOeRqugQ4DqEoKImkZaLkZsJPGNv+Jm+P
         UO4xO8YyzKTan2qFODb3/rqRZrLtM+/imHGgT0TCjizi3VKElymALvaydrUDyR5UGiaB
         wj4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771532761; x=1772137561;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LeBgE4c+zffhnIxLomDqTnQzqcUsHtC9ybf+HnwTsGE=;
        b=tuCUOKgZEDrl1YuRv5XFuwQPfTUwTNa8mTZcvCTZHd+zumdODWlCqknUI6zQ6Jh7Cf
         LZUEAewKKuzwWMqucqkwRIylskbHr+6r/ysNjaGaC+f2suKd8hfGb6/aQL6qq5TWjtY+
         6JGzeBx6xNGj/dZl92vxl63KFMMKsj/Q5O7z38tLmMKKJIiU3UXDNHX1mLvmRnk4XqZB
         C7Doj2hcN7pFiv01rHpapOisj2bJVOHLxgmmEDvVMOzBQ6aGe1Nx+AkYHj0K/N0IzkWk
         eu6tLtT5ZjWCD/nwgLuQrRkaQIrBWmiU8cjQBpdj3CPuAziPL8jJLN6TeakUmlVsnRpU
         cxIQ==
X-Forwarded-Encrypted: i=1; AJvYcCUdjaeQYs+pl92VchjHywazCHR8BzEEmlaaoM5OLm6iCRkbELWo8r7QKcCsWA8m8sCmt9LWoapkGw==@kvack.org
X-Gm-Message-State: AOJu0YzfFIU3iCnS2nooNjaKyLDYL2vUu+VeKVyhBBFOeN6QLdSDKb1Q
	N0aCAsop+ZzQvYe1Nvn0Wl8/3vaprBzBAQkvurJrZ8edmeXs0ksiffcxqSe6DzN+jEeDZF0UR5m
	/hGL2AkOz9FVed341EkUeGMX8SZ68UBxQJ3g/Ch9i
X-Gm-Gg: AZuq6aKYmcvXvtTuYHyNwsVf/Zfjh4xqe+J7YpmEGqCiXjOMh4/O3gpnAB7mBD6O+bL
	EZvTGTVe06tUA5mN6Hl79i7O/+htWv+xXnk4o34cjDSteM5ofh/Ko6ORn6fG3cicFfJiToVQdCu
	Wl7sCIHYAT4gOrwduTr54gifUf7FvrexBi+l8YqcVle6H3jML63YDiSRLxxTb9W4fbS1evF+0zb
	3KIp9Sxj4vJmXteHI0J+pIwyUYR1kUt/63nmASzBtkwIIKS/R1Z6oKV7dfVTb3a85PW2SRUPD0a
	DnPm+w==
X-Received: by 2002:a05:622a:8c14:b0:502:f1e0:dd3b with SMTP id
 d75a77b69052e-506fb4be16amr2262671cf.7.1771532760278; Thu, 19 Feb 2026
 12:26:00 -0800 (PST)
MIME-Version: 1.0
References: <8aa41d47-ee41-4af1-a334-587a34fe865d@lucifer.local>
In-Reply-To: <8aa41d47-ee41-4af1-a334-587a34fe865d@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 19 Feb 2026 12:25:47 -0800
X-Gm-Features: AaiRm515_KwWjm1EGENl8li3V_ta80Lt61PlBE55vHyON_pKbeUjW98bwcOJt_8
Message-ID: <CAJuCfpHfkDmnLO3u25BaUcRE2Hv=WE1HrhKhqNxu81gFKJ_t6g@mail.gmail.com>
Subject: Re: [LSM/MM/BPF TOPIC] The Future of the Anonymous Reverse Mapping
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Pedro Falcato <pfalcato@suse.de>, Ryan Roberts <ryan.roberts@arm.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Rik van Riel <riel@surriel.com>, Jann Horn <jannh@google.com>, 
	Chris Li <chriscli@google.com>, Barry Song <baohua@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: w7jketrae9b6h1kdradhx9fo6ppzhai8
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: BB67C4000A
X-HE-Tag: 1771532761-899996
X-HE-Meta: U2FsdGVkX1++emxlwkLsE+hx8KQ5ZpC4kr99u+WpG8l6ySSeg8o+CrRl4iREjK4dBbghYhweEBDypeVbAvQ9tNjG0rq22daoUmR+vKEw3Wwvtb9oi3LcBndF0QaFx3s62C7iQk6mV9ELMOtwvfR0uK5bR+YCAFGb6nqP8Fcie6cASzHGVUNwqluOfOD0zW+KLjDhJt2dZ9yktqJXuAVJJsFlfe9c6mt+eeLrduxeMuR/hrwt1mPw8RmeQCC7nl2nW3pZPqb3enEB8WdK7Aw1a9WZZo3tXr3ieb8Tw8A59gO0kasq02iDZob2XUnQ7JdNHeMHWF1A1gfv0yMFysY618EY5IkVaaczOr8Lx5QAIkfrSQy0cXqYFCtNCF7ts2kj85FVDfqvYDZsH1m6D5HKK/45PNrZZ54Yxx6wQJkwXJSs+NcHy7iT7+lfJ1rYhK1qayhpZOMFAvt8NlOAydPW3ubke/nHCROWYWSOIuWJTCf5LYvWylkobLTs6lo/9V1Cor4+yr/QeQblNswJwVZnQ6YdT/s6qgSEcT6IEbQSX1egN3xQCilqPHvwc6xV2aLJmWiZC23Wh5cKUnih3LvKX1B+1A+j+iPL9VgJ5807QujJtSwr6VNF8bT29E0KZFS9l1r+h9MCg+erZtlB3pdKl/v5EWQhzRpRpWLvww2cHMYPZvIxnurGM/2fXM8WPugcjetgk4pyKY2W06JF+GMKv4AbhiZNRFTXoVSwupGVDk1S7oRlCgFV4ipJ+IPYBbKvtLiZq3Nvc6+FomunuQvVbfIneClXT7EcFubdQ5YaF/CDFVrwj269Ak0Bbg0JsxNqM2NY8tXnFpeSVddA6y17GLeyjlBPTfjnM0C5+zqNgnVDXxSp/Dy53HJNhnLqRlcBOG2ymTzNjb3WDAkR8hH9ywFNwUgF8Ki005lIViRSKLlJPYaV6N2o3EwV5S/ERfhKjg8+B21OgxSQdWHe0yb
 i1w9LkeH
 OMz42zfyAE9xlU9kGnZHHYvJBpyFvZq8ABfP3E9ObN0vehpf4h1GZW9PUsbbyHNMDNYdzeXYJu3UY8A0IiZB0OS+wOPfHCRmtNM5W5ZMCSf9xjv8uFgX1PSHpTuuaHVQQQqyBli5EeTPsYbWeNCVOCecH/+tlcRYLXs2/Bgk6CD+1fZQ6wk3nvNjBM6yiiDK4HEKd91mlTzXbm/yB+MrBhn+5wxfIymKMGAv9/gY9kBrNdrvHTdpu0wt/34h9RzpvDnpP5tQolAho0p+CoWuQ7ILmTXoV2FpQtb6Y1K/9NoC4LNzDZgj6KmqWKrq6IU0iUWOYUCQWHckvFD8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 11:28=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> Currently we track the reverse mapping between folios and VMAs at a VMA l=
evel,
> utilising a complicated and confusing combination of anon_vma objects and
> anon_vma_chain's linking them, which must be updated when VMAs are split,
> merged, remapped or forked.
>
> It's further complicated by various optimisations intended to avoid scala=
bility
> issues in locking and memory allocation.
>
> I have done recent work to improve the situation [0] which has also lead =
to a
> reported improvement in lock scalability [1], but fundamentally the situa=
tion
> remains the same.
>
> The logic is actually, when you think hard enough about it, is a fairly
> reasonable means of implementing the reverse mapping at a VMA level.
>
> It is, however, a very broken abstraction as it stands. In order to work =
with
> the logic, you have to essentially keep a broad understanding of the enti=
re
> implementation in your head at one time - that is, not much is really
> abstracted.
>
> This results in confusion, mistakes, and bit rot. It's also very time-con=
suming
> to work with - personally I've gone to the lengths of writing a private s=
et of
> slides for myself on the topic as a reminder each time I come back to it.
>
> There are also issues with lock scalability - the use of interval trees t=
o
> maintain a connection between an anon_vma and AVCs connected to VMAs requ=
ires
> that a lock must be held across the entire 'CoW hierarchy' of parent and =
child
> VMAs whenever performing an rmap walk or performing a merge, split, remap=
 or
> fork.
>
> This is because we tear down all interval tree mappings and reestablish t=
hem
> each time we might see changes in VMA geometry. This is an issue Barry So=
ng
> identified as problematic in a real world use case [2].
>
> So what do we do to improve the situation?
>
> Recently I have been working on an experimental new approach to the anony=
mous
> reverse mapping, in which we instead track anonymous remaps, and then use=
 the
> VMA's virtual page offset to locate VMAs from the folio.
>
> I have got the implementation working to the point where it tracks the ex=
act
> same VMAs as the anon_vma implementation, and it seems a lot of it can be=
 done
> under RCU.

Do you have a link to the code we can look at before the discussion?

>
> It avoids the need to maintain expensive mappings at a VMA level, though =
it
> incurs a cost in tracking remaps, and MAP_PRIVATE files are very much a T=
ODO
> (they maintain a file vma->vm_pgoff, even when CoW'd, so the remap tracki=
ng is
> pretty sub-optimal).
>
> I am investigating whether I can change how MAP_PRIVATE file-backed mappi=
ngs
> work to avoid this issue, and will be developing tests to see how lock
> scalability, throughput and memory usage compare to the anon_vma approach=
 under
> different workloads.
>
> This experiment may or may not work out, either way it will be interestin=
g to
> discuss it.

I'm interested in this discussion. Hopefully this will result in
simpler rmap code and reduced lock contention.
Thanks,
Suren.

>
> By the time LSF/MM comes around I may even have already decided on a diff=
erent
> approach but that's what makes things interesting :)
>
> [0]:https://lore.kernel.org/all/cover.1767711638.git.lorenzo.stoakes@orac=
le.com/
> [1]:https://lore.kernel.org/all/202602061747.855f053f-lkp@intel.com/
> [2]:https://lore.kernel.org/linux-mm/CAGsJ_4x=3DYsQR=3DnNcHA-q=3D0vg0b7ok=
=3D81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com/
>
> Cheers, Lorenzo

