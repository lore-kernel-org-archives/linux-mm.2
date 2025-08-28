Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF9F3CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 06:48:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB94E6B002C; Thu, 28 Aug 2025 02:48:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D68B46B002D; Thu, 28 Aug 2025 02:48:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C30746B002E; Thu, 28 Aug 2025 02:48:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AD6E66B002C
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 02:48:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 199A4140975
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 06:48:13 +0000 (UTC)
X-FDA: 83825236866.29.4D55A44
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3F6008000E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 06:48:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="LR2El/Qd";
	spf=pass (imf30.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756363691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VhKDCD8/DGV5fH6nxnOqiP7dbAwWbENHECBTrAvc42o=;
	b=OpWdH+pQB/ljgaCP7XvNjPIKvFBK5qk6DosQ4pQQPXbPIyIP7Gf8mgWUVXyzJ7kcQ8LFFU
	ROwqURYtAhFSDxJIxToeNfNmeaRHmiJImB1y0KcIUBcqNJIVkoSBOPdfvf43zVqijBkuqr
	hq8fU8PWVKjD0ARJjeE9WE1YoB/8dBE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="LR2El/Qd";
	spf=pass (imf30.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756363691; a=rsa-sha256;
	cv=none;
	b=3Ptl6MlGNSXjzxJhn5wuXJckx2PwodaJhCREcxCNdvknE4+Xcm5GJZhMVUXxlGngN8OnHz
	PjV1+njT0vP4KJT1nN7/w8K9O4S7/ZO18zJEZf1QhX7JJjTnbK1iUUa8IxXJn5IVC0rUud
	JW6l6RolsUVa3gmggdyF26jb1WS04r4=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-70df1b76a95so3210316d6.0
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 23:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756363690; x=1756968490; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VhKDCD8/DGV5fH6nxnOqiP7dbAwWbENHECBTrAvc42o=;
        b=LR2El/QdfQ8nHYnwT7Fpi0stphg9nuzz+JPrgYwa4Q1R5PLXbBJYjf39+GsuZRyw6D
         Tijo8l2LOB9cmdXD43h2Xdr75P47W4zoXFuDFn8AyX1XiTmTo3AYVR+Ow10bZCEW/Xrm
         2O7mTXMiMbp78yv6lq2PQXbK8n2SD1bun7zZrfGLNWNunOGEFVOULnM37m0nZZSprd38
         2e0OyHabEVhMYQS0YD2GL5OFhpu3s9V1/Y+68JTdrJS+MG/nUdpPPnaPhNF6Ccl7FLpo
         v8AMWLqzfctFtX+xSBkJxdPvx37v9+LBmnlwiVJEc4T+eKfrZWooWYvjszG/41SVlhQB
         hNjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756363690; x=1756968490;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VhKDCD8/DGV5fH6nxnOqiP7dbAwWbENHECBTrAvc42o=;
        b=I5K0dnRCJk7HSG41jKTg+WldcORyuOHxtAc/6YURJ7/TmcsqzwdLRjGtHVSobJ9evB
         29KDzyrRJCnufisq3D6kbMoBJ/gn+68Hy3M/zNOfcZOwQBvfV3mJnDoi/wXvITrNOQWk
         dZcRXicqR7pFKJ2tm42DFmjD0jAtLzA6TTdsgv+DxKXPh6NA6WpLm9HkfASPeYuf2MjZ
         YBRgZRXClCqS+KWuA+OZEPWK1fYxrp7BZ1Dh1dEBOvrklqdk27FcwlhSXTYwwX66phsm
         akNfAQ24YYmcqyMeDFJV85pDuEBomgtPcjbMYFop9GDIWpb1Mcu0R89lMN9+toH3Lv9e
         g69A==
X-Forwarded-Encrypted: i=1; AJvYcCVzLzlNrz+bw0FOcPSFJsQrKYA6qPKD1EqvAc0rHObzeraeU4nDcQuS5e5/XwedMhHSjKN8bRbaKw==@kvack.org
X-Gm-Message-State: AOJu0YwLhlf410V4v31+4ccApsiReLde7l9zeJVG1BnKh88h06Eynhde
	xC/9d/ndygLzvi1uML926Y4lrsN+0tKyKLp4/Pk1PlT/O6yQbr7m2kbGp/w0Y9005/pTvuMVmBt
	tXYhovCqs70oow8+KfstjoRzeza1vouw=
X-Gm-Gg: ASbGncvX8uNl5CGcYvJbjNt3k+BGTP03ydQG/cC9s3GVLrdhl1TdzUlOnzYuu+VLGnj
	Uyo5EUJSExxYniXexEMOPKXueE/nMB3yO5QrrEp90/ANp7kXgNOR6CKqPoEjtyzc/ySp9P0uqM5
	/V0ZUPNnPzBKwv6XNeYEpWXBrNEUdkAp+XCMrvBTPhPQHU2nD7iqVTQanIxj51zxp/c2MrSft85
	ad6Hwxx+crPMmZB03br5F67Nxfn6qFrg8NL1+w=
X-Google-Smtp-Source: AGHT+IEHoD0Uiusmd/UOKL+6+ngiZoVhE1NGASgu/DqDEWY+8Tk5z5aKAhPh99n6YIUVa7EigBjgFPT+dBliZZToc6M=
X-Received: by 2002:a05:6214:19e7:b0:70d:b1ea:25ed with SMTP id
 6a1803df08f44-70db1ea286fmr214292226d6.23.1756363690237; Wed, 27 Aug 2025
 23:48:10 -0700 (PDT)
MIME-Version: 1.0
References: <20250826071948.2618-1-laoar.shao@gmail.com> <20250826071948.2618-4-laoar.shao@gmail.com>
 <5fb8bd8d-cdd9-42e0-b62d-eb5a517a35c2@lucifer.local>
In-Reply-To: <5fb8bd8d-cdd9-42e0-b62d-eb5a517a35c2@lucifer.local>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 28 Aug 2025 14:47:34 +0800
X-Gm-Features: Ac12FXxFTwzSzvJhj5UIbCdO1z68biL2fU9bhU24okrE4ErExRxkOpwYSA6y-j0
Message-ID: <CALOAHbBHLLo+Xcd=zJeQp9gvLBnyYWAdeBiqKYKgj424m1Sn6A@mail.gmail.com>
Subject: Re: [PATCH v6 mm-new 03/10] mm: thp: add a new kfunc bpf_mm_get_task()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3F6008000E
X-Stat-Signature: 9n6a6us1mg99gbcgqsrqrc7oerd9cz3w
X-Rspam-User: 
X-HE-Tag: 1756363691-570147
X-HE-Meta: U2FsdGVkX1+aaG5/rqXomBZ2BCnr/7uBlUVqy3EWF7Fdtb7Q7qbdKa5Pgu1LHrEjP2PdTpNKLt+HgeKd4A3SzKTQDgRBGiApREBmHGkLa7AdZbZgR2QCVPP2MBK9lnOvdyYy83hjNeF4AJfk/m52BNHqp8J7m4zaWrPjFm5MdjIdn7n8gJBOvx/UOV1qTjJBTqLTShOFhWm5tBYJ4fM20RUZ4E2JXL2uG1UeBbe2Hea0Wht+PUzHyNL0QdU5PcQoBaqJqh2e10rdxvfJ9QaUx9anUIGX2T/Yjo/JCPiuSOTUNC3kwa5MTmPGunXHSPPhJXw7V0CZFTS11ojY2e/nV2q1qZey1QGV12myHMU++pNiCMFEPpAI5l3PcxhgoOBEyAzvk0uOVngRIY61TXfVh0RFHB8SwcWvYBFDyFgg/1fENEi5jxxVRfaGH++BahwrSeyXbxPt5lRtrYVhn9dcOY4RzhAB569KsIE6Srl1B27siOwaoTttnFW68SJNZhgHpTCrTwftTIr9O12sF00bntHMepMlfGBfVqnkKTWE84P8tth9bX4rSjDMYTKrABzJRCZbdffeeFRrBWJS7i2RxHYoZsXn61Kw8N3/Je1QkOwZ1lMrOmEfpGT7H844bLO0PtvMIP+DR82qoqpQy3X38xkyx4LH22t34RT42AyNFB0rMb811/++O/SNYvGlAaK0Du7UPKD3DpwDdg4JQBzGyWGMkQD8ewEP36ECk1G9muf1bvcf3fw16HkBN1RXjNQC6nov69eImM7PUAGDyQ+/taDvPg0yyC29jhEemFAH62RH6/hyLHR8o3zKcyatDLX+Qvo9HL+vvfnUz1R6YiXFPI7qqu1eRR25Q+epquZZigAbo2qGtCvQYKVakKT56AVMvlnzWOv4kv1lEz2U2Ywtvb4ORNArVgNDWvekFInk4KR2dpMrXYRKRXz3A/8vS5o3joU7VCbo1NzYch2SUQm
 tOHBDXTC
 POKAaeIxfP4FwyjOWhQ+0go4b6lyleaTgge9TftkMym8xQcEih54YCOHzvKXsBp1EeBg/ok9o26VUiBeUfp46DoieHbv+Gr2ODCD3CvFLK/tUKgLJvGgD5QdifeAzVcyvmm/4AJy7LnGpJKtiCZRNHBeSZC2dRWfrlx+Pp2TC1dNM/HFD4/GdHdmPtrCXeEl91Rn7zRy4nmfSl/Guh6XFQ4xqR0MMF6VWZ02Zo6y/N7oa9nyDUgLjKP0n/ccUyPhTvI6vQ/rGkWKlHlaIQvAKt6jwZlMUwdQ7Wl429FDJYV5IouEvAAcLMqMXpTdxx9yGsvHyrZF+zehnS0rpxSIkQrqQx0/UUzHBrX3fgjLwGQvVSUl/1p3tjt6JlXq97uiOOQE0AApG699xt9xyskZKCoeeQx/1pRMwDIIrhWPn+HyEwowoITRuIAP1CNqIohOJRZ2C
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 11:42=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Tue, Aug 26, 2025 at 03:19:41PM +0800, Yafang Shao wrote:
> > We will utilize this new kfunc bpf_mm_get_task() to retrieve the
> > associated task_struct from the given @mm. The obtained task_struct mus=
t
> > be released by calling bpf_task_release() as a paired operation.
>
> You're basically describing the patch you're not saying why - yeah you're
> getting a task struct from an mm (only if CONFIG_MEMCG which you don't
> mention here), but not for what purpose you intend to use this?

For example, we could retrieve task->comm or other attributes and make
decisions based on that information. I=E2=80=99ll provide a clearer
description in the next revision.

>
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >  mm/bpf_thp.c | 34 ++++++++++++++++++++++++++++++++++
> >  1 file changed, 34 insertions(+)
> >
> > diff --git a/mm/bpf_thp.c b/mm/bpf_thp.c
> > index b757e8f425fd..46b3bc96359e 100644
> > --- a/mm/bpf_thp.c
> > +++ b/mm/bpf_thp.c
> > @@ -205,11 +205,45 @@ __bpf_kfunc void bpf_put_mem_cgroup(struct mem_cg=
roup *memcg)
> >  #endif
> >  }
> >
> > +/**
> > + * bpf_mm_get_task - Get the task struct associated with a mm_struct.
> > + * @mm: The mm_struct to query
> > + *
> > + * The obtained task_struct must be released by calling bpf_task_relea=
se().
>
> Hmmm so now bpf programs can cause kernel bugs by keeping a reference aro=
und?
>
> This feels extremely dodgy, I don't like this at all.
>
> I thought the whole point of BPF was that this kind of thing couldn't pos=
sibly
> happen?
>
> Or would this be a kernel bug?
>
> If a bpf program can lead to a refcount not being put, this is not
> upstreamable surely?

As explained by Andrii, the BPF verifier can protect it.

>
> > + *
> > + * Return: The associated task_struct on success, or NULL on failure. =
Note that
> > + * this function depends on CONFIG_MEMCG being enabled - it will alway=
s return
> > + * NULL if CONFIG_MEMCG is not configured.
> > + */
> > +__bpf_kfunc struct task_struct *bpf_mm_get_task(struct mm_struct *mm)
> > +{
> > +#ifdef CONFIG_MEMCG
> > +     struct task_struct *task;
> > +
> > +     if (!mm)
> > +             return NULL;
> > +     rcu_read_lock();
> > +     task =3D rcu_dereference(mm->owner);
>
> > +     if (!task)
> > +             goto out;
> > +     if (!refcount_inc_not_zero(&task->rcu_users))
> > +             goto out;
> > +
> > +     rcu_read_unlock();
> > +     return task;
> > +
> > +out:
> > +     rcu_read_unlock();
> > +#endif
>
> This #ifdeffery is horrid, can we please just have separate functions ins=
tead of
> inside the one? Thanks.
>
> > +     return NULL;
>
> So we can't tell the difference between this failling due to CONFIG_MEMCG
> not being set (in which case it will _always_ fail) or we couldn't get a
> task or we couldn't get a refcount on the task.
>
> Maybe this doesn't matter since perhaps we are only using this if
> CONFIG_MEMCG but in that case why even expose this if !CONFIG_MEMCG?
>

As suggested by Andrii, I will remove this kfunc and mark mm->owner as
BTF_TYPE_SAFE_TRUSTED_OR_NULL.

Thanks for your comments.

--=20
Regards
Yafang

