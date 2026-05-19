Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02566CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 18:21:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 612F06B0088; Tue, 19 May 2026 14:21:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EAB96B008A; Tue, 19 May 2026 14:21:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D8F16B008C; Tue, 19 May 2026 14:21:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3EC316B0088
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:21:17 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D97A41615B1
	for <linux-mm@kvack.org>; Tue, 19 May 2026 18:21:16 +0000 (UTC)
X-FDA: 84784986552.06.1960582
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id AE5A14000D
	for <linux-mm@kvack.org>; Tue, 19 May 2026 18:21:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EwJzWSQl;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779214874; a=rsa-sha256;
	cv=none;
	b=mzy+DDuEI//glM9g9t4NfR2ypMCOfMnO/5/kV77BCf0afQMrg+t7LD5ue7Y6X3tOnbFNZY
	l3tfe/sMztVUWd0wyuSQXnEqtp4IVqIT14wB1HUFetp5X+HfO7B2LSxNGx2R6Wi1s19Ht8
	WSCHy+Nes5G2nyoN5e5tk7IITNuZl80=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EwJzWSQl;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779214874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DidhSSVgs6YbRMyQzDDirQnaWZ/O9mawSXYrnotJW/A=;
	b=m2Ox+k8ep++9eUwjGWvT5vqhpA+UPP1zlH/hONFwScyJqWlrPWDkVPI+BBYm896Zuc29W6
	8fuXR4jTxFtE/bmNntDozwpUiED9rRml2+TRVOFnWUDbN7jA5nH1JvMhAUTPlO8711iK2c
	alzQKcP5ptQFtp0iC6uR1IBEGYXrGzI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779214874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DidhSSVgs6YbRMyQzDDirQnaWZ/O9mawSXYrnotJW/A=;
	b=EwJzWSQlCL0UdAZTv9b3/kI5Ms3NgKt7TvUBrHaouaIK8FFTIWa80OWgA8HzlmFovDnNT7
	wvSbRRZFLIH/M6YTQZDF6fybnh5CR/Di0usvn53dYQ7Mv0KOgeQ5u/biC7AHHGhf2l8/5B
	/HLDGGgHCUmyQM7vmL4ZKd3CyhfS5nk=
Received: from mail-yx1-f69.google.com (mail-yx1-f69.google.com
 [74.125.224.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-bxRyRYcZPX6PTRC1anbG_w-1; Tue, 19 May 2026 14:21:12 -0400
X-MC-Unique: bxRyRYcZPX6PTRC1anbG_w-1
X-Mimecast-MFC-AGG-ID: bxRyRYcZPX6PTRC1anbG_w_1779214872
Received: by mail-yx1-f69.google.com with SMTP id 956f58d0204a3-65e1b9f1ebeso8501892d50.1
        for <linux-mm@kvack.org>; Tue, 19 May 2026 11:21:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779214872; x=1779819672;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DidhSSVgs6YbRMyQzDDirQnaWZ/O9mawSXYrnotJW/A=;
        b=chJvbffOpzqniEhK+j6693iKJnDybD9kC2pTgBkavxGGOl/w08Tio8eBK/0TDyyYP3
         qArjFetLmQ8hQ/2pMg7s8io1GYcrlShb/okSQEGtcqHS86cPUUTyTRIwrXaO7eMskcui
         su9uKMk2fHT3fOVxGvUPmNYsidQxX4ofhgtBG8vJI+OxagORbG6cSn4FLLu/tElvH4v2
         3yp0bX6+UvevyA+YLmNp+o/RgBIL2ZXhfB6jsBukMyJbOkQ7EghmcAAHOsJeEAI5JoTn
         VzM5znWvtyP6kOcvrTB+AZAr+n/aAD1/pNmFAMbbKuwwa99ETnevdPwnRoZQHll7JlCo
         Lpfw==
X-Forwarded-Encrypted: i=1; AFNElJ8QaSw33TpIP1vGcz3b77CfgH8mqCRAwhNikSRQDs3k5IVDp6ql+k4FInkE5Cz9sGlpBCUQrTNT4A==@kvack.org
X-Gm-Message-State: AOJu0YyFd7eOsbm+N8ZUKCShryxNnjgTaCOal8rvOM3UrwKD37G6LiSE
	0Q/Qi/AomPLQsT0MvgjFreAm+maBxLu3MiPm7ST6yjZ8AUN4SEXcrc41kF1ZOhR5uZDZsxRtmJq
	+B93K09H672w5UZ/gyyT6NMTANI1aG6q4OnsbI6oZW9UPTRl/aiJjrGXgR7oMZVQAgO7i1DiP6r
	xl2d4r/jD8a2nLr/jbxoo14cOUcSI=
X-Gm-Gg: Acq92OE7JGUWSCo4fBSb5JyROdyEF7oiRkTan1AzFS4rXm2cSDJS3M6zNt+FhkpQUW8
	ar1HX38WNNo5BaY1qyiADp9CNMF57US0B4lr5szaLWQ+aGuXkF1gquH7Luuzz69c+nBRx7EGbQ5
	XzV9PYnKhYUSsiI+bBq0LJSHCY3NIsHwHTCnHoE5sxyVG205B1iclS9UIBxvU72dEsxg10ZQVk/
	rvTVA==
X-Received: by 2002:a05:690e:1402:b0:65c:6ffb:3038 with SMTP id 956f58d0204a3-65e215f82abmr16063333d50.17.1779214871866;
        Tue, 19 May 2026 11:21:11 -0700 (PDT)
X-Received: by 2002:a05:690e:1402:b0:65c:6ffb:3038 with SMTP id
 956f58d0204a3-65e215f82abmr16063273d50.17.1779214871174; Tue, 19 May 2026
 11:21:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260511185817.686831-1-npache@redhat.com> <20260511185817.686831-4-npache@redhat.com>
 <4566170a-7e3d-49e4-baab-ba2790c198db@kernel.org>
In-Reply-To: <4566170a-7e3d-49e4-baab-ba2790c198db@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Tue, 19 May 2026 12:21:35 -0600
X-Gm-Features: AVHnY4L4MNLuHeolsP-TGGRMvsoQWuP6zfUselEJ0zRNjehB522kQizaPVIyv5w
Message-ID: <CAA1CXcCD5ooRJonAVp2LvnoCrQwcs1-NsAYomXbHTVNSe5X0cw@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v17 03/14] mm/khugepaged: rework max_ptes_*
 handling with helper functions
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com, 
	jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, 
	lance.yang@linux.dev, liam@infradead.org, ljs@kernel.org, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, 
	mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, 
	raquini@redhat.com, rdunlap@infradead.org, richard.weiyang@gmail.com, 
	rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, 
	surenb@google.com, thomas.hellstrom@linux.intel.com, tiwai@suse.de, 
	usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com, Usama Arif <usama.arif@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ek2vjLFjiud5ZBiVOX8Vaa4PDT8VPF7GIfgX0yP114A_1779214872
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: tdtnogka3sbg6hdahptqd6naf1iycs9q
X-Rspam-User: 
X-Rspamd-Queue-Id: AE5A14000D
X-Rspamd-Server: rspam07
X-HE-Tag: 1779214874-140117
X-HE-Meta: U2FsdGVkX19kCdAtSXNfpJ9KYeNul2CL9utbNE1qyaBbcyg3AsX1zSU896R15+vgAxg0cEpR5nv2Mq2emQ+HXjM/Anb/vZGgx1OZpIdZhwjuHALp/rIdGnvrnUJz9OFpanvBDhVlNHFuLWPYGqmgqaJb7BtJ2ouREGOXEGvB/C3kk8hsf+c+lZ+eZ2dpx0HEIFpwKrnmnPqXV9iw+9TcNvlaDsxRtMI8OQXfBQt+KOSs42D/YChyrnOXXECmjUmpwmMgJQQwXQJm9dApUIwQlXLZwjokucRcPzEV0RsTqhh1IQH071ZWFrFFfJ5e6jKGJMCVLI2nNWwLn1xpmmHkzSnk5tTqslYSXwDHrw8EiMWRXThMshr+ZvI5TpmXKG1Vy0bpT7F6fcZh4JS1YVAXFvhizWPY1F6vbbZCH6HTgniIxVvaOGERu9dd+s8VMAuypXBna0ulc+wF/ERSQyIqt3t9TQ7d4Y+8ksPxQqiKx81EG41EKh6HkPOnvSCQupBLUZ5pu0SpP4ckZVWj2wHgSzPWIs9bNjCbN+pNbSD+xDSTeLzAuQGHon0v64Kfe11k2p0YTemrzs8ltfnAzTC6IRKZkmFOvQmvXNJ8/APB+d/OyY+pdJcs5j4SLwM7kK8SaYu/QQxWf4/nNzWLVsr2O21pktDglfy9GsO+3zlKxKydvtS4u4OvHnMTQxFoImzm+WF986X2iSAVrAArNFHBeYBDtMN7yGBJCxPrTUiF4k1Zhod5xcNOMJUZ21dshANArTM5Dd8TeZwmnIpOwNrX/ztc+fERr232/xO5xJyM8WoFb5H7ZMHrRgxAZCtBS8euITGRUMMT5l3uTZJI+OSs6JIxkvRtOFJdyR5POSbZuFFcsXQ+DKRCSAsK/gIKlqD7O+dCpYSuKmrTALufpvsN1Uh5Vtc19kxxYrocpWOJzbnhsMGAE9aPxNxq3ByuCqx9Yj4+BduCkPFQwcKcnfL
 g7DjpwTX
 YMLPOJfrAVv1oisWV4lICoRTFFZm9e3ukcvVWPwQBObALb03EBnOeOD3qpMSdnSJCUNoSRBmmfJjhz4zKRInl5lSywKNGtQ5KeESIXEmn+3A4pr9ZyizeYICApOuz1qE5ycNgdbPuVZgaU6wY+xMVYxJ3I5QUKpRGv5F6elJ8J5Kjc25jLbna9bf+anzfmKiSz7K8UnFSR02GL58MqPu+Y7HnCZNl2JeW121MrY9mqyJz5TAPGDaLmkkfzHUQx9+8pe3YDoGeKeBLgWQX3ihpwwEWpDOBY5JnLuHvyZE5lQxLO6+jy0vRjqcXb3wZfdtD+gjybI9ePp0twge8V/19/EFza+v+qTNvznekymhBTA0NUZCuzygrmzK6UCHzESNimoMAVGoM9nOo4Xyj5N9kBiBO/fyrQswmr8b8OP78A1ZonJbuimnApOfsOE5xIcj9fZNOPhvZgo3NNa4WThN4HNaeSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 1:30=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 5/11/26 20:58, Nico Pache wrote:
> > The following cleanup reworks all the max_ptes_* handling into helper
> > functions. This increases the code readability and will later be used t=
o
> > implement the mTHP handling of these variables.
> >
> > With these changes we abstract all the madvise_collapse() special casin=
g
> > (dont respect the sysctls) away from the functions that utilize them. A=
nd
> > will be used later in this series to cleanly restrict the mTHP collapse
> > behavior.
> >
> > No functional change is intended; however, we are now only reading the
> > sysfs variables once per scan, whereas before these variables were bein=
g
> > read on each loop iteration.
> >
> > Suggested-by: David Hildenbrand <david@kernel.org>
> > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>
> Some nits when re-reading:
>
> > Acked-by: Usama Arif <usama.arif@linux.dev>
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
> >  mm/khugepaged.c | 118 +++++++++++++++++++++++++++++++++---------------
> >  1 file changed, 82 insertions(+), 36 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index f0e29d5c7b1f..f68853b3caa7 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -348,6 +348,62 @@ static bool pte_none_or_zero(pte_t pte)
> >       return pte_present(pte) && is_zero_pfn(pte_pfn(pte));
> >  }
> >
> > +/**
> > + * collapse_max_ptes_none - Calculate maximum allowed none-page or zer=
o-page
>
> I know, it's painful, but ...
>
> There is no "none-page".

Yeah I think you mentioned that last review... sorry!

>
> Calculate maximum allowed empty PTEs or PTEs mapping the shared zeropage =
... ?
>
> > + * PTEs for the given collapse operation.
>
> We usually indent here (second line of subject), I think. Same applies to=
 the
> other doc below.

Hmm tbh I couldn't find a example of what you meant here. There are
some that put a space between the first sentence and the @ list.

>
> > + * @cc: The collapse control struct
> > + * @vma: The vma to check for userfaultfd
> > + *
> > + * Return: Maximum number of none-page or zero-page PTEs allowed for t=
he
> > + * collapse operation.
>
> Same here.
>
> > + */
> > +static unsigned int collapse_max_ptes_none(struct collapse_control *cc=
,
> > +             struct vm_area_struct *vma)
> > +{
> > +     // If the vma is userfaultfd-armed, allow no none-page or zero-pa=
ge PTEs.
>
> Lance commented on the comment style.
>
> Is this comment really required? It's pretty self-documenting already.

Dropped it, thanks.

>
> > +     if (vma && userfaultfd_armed(vma))
> > +             return 0;
> > +     // for MADV_COLLAPSE, allow any none-page or zero-page PTEs.
> > +     if (!cc->is_khugepaged)
> > +             return HPAGE_PMD_NR;
> > +     // For all other cases repect the user defined maximum.
> > +     return khugepaged_max_ptes_none;
> > +}
> > +
> --
> Cheers,
>
> David
>


