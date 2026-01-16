Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0080C982DE
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 16:59:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45E476B0005; Fri, 16 Jan 2026 11:59:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41F2E6B008A; Fri, 16 Jan 2026 11:59:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34B5F6B008C; Fri, 16 Jan 2026 11:59:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 24DA26B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:59:33 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E780CD18E2
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 16:59:32 +0000 (UTC)
X-FDA: 84338438184.12.A650F63
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf22.hostedemail.com (Postfix) with ESMTP id EF11EC000D
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 16:59:30 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rUw71Obl;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768582771; a=rsa-sha256;
	cv=pass;
	b=ypn56C489TaCv4n8RTeymuqFPd3atx/vtDdBfs5XE5+Wds97j/StdEjcl8IuwlOLgv9+gl
	f84/etO/vH5grBSwrHPMT2f04R3cb56ADRTBXDTTj0gONOofcrbOzBojcQAx8i43ilsJTQ
	J3Idp1eIQ8Vt8vMVpcqXu0fGhL2C3ig=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rUw71Obl;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768582771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s1BTvLdErVOVTXbojE/mp4bn56MJT1unyCMZ/1mKqI8=;
	b=j6n438k5U7GGUFRtCCKhKLtyTYPl8MavooUyxm9yyz1E4o8P51Qt/6URT8cmbbcszYDCMi
	3wW/o1ur0Tey6Ow/cIgZ3O6Jqneiv5CjPXUPwsDhfdXCeCOTwhx81SxrscF4fcJJjhGlO3
	YwAYjXw7qZoT7/ovZDiPT0TvGume2II=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-50299648ae9so518871cf.1
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 08:59:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768582770; cv=none;
        d=google.com; s=arc-20240605;
        b=H56kkhteb/ex54oKjSslNjNI5S+FP6g849JFKj6jfSiKY8AX83nIed1YYo3isfVjoO
         z8yLSlDIKOvN6Df+cadHgqY7JoxSSzgmzFCBhJZASqOKgJqqe3WBKR/2i6buor1GVXQw
         YqBvfNfk16ZXpE2dF1aXgJUc0y9Ueby+YqDDLYXEhqY/5lc8WXgvebLfriDhA8OPET6X
         p4t7pTIE3+1ANq7YXKKm0tkZj8MiR7tHspQ5LLZYJ+gQTv5ZZ8CKRVciJq0ZlALE/OqJ
         s8sz8ORbSJHeJADZgU2SvWzSh9W4B6FNuV58d/J8iLSL47JT/MTwwYv51Z1ID72Vitlq
         bhEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=s1BTvLdErVOVTXbojE/mp4bn56MJT1unyCMZ/1mKqI8=;
        fh=NwRk/shpSXLAbzkwTzwd/Rk+En3assjZ6uOdwHFWBSA=;
        b=bkrG06HwW5s1bQQbdVqICsECWEzB6iqNklEIjPeaoF3kNMRTH9p/bj/6KuNW7epO6a
         H1H+dkeCwT5Nwwq6XAEn5HKMTXRCWJOe070eSWyw/FMyjNiZEPUI4aSZvMWtDC6OhQs1
         cM8OWCMYZBEz04KbMbrlYDbmlI1AVbYne97t8eDxHc6i0pz1QK0y3wX34qiygZfwJvMp
         EWIQTyo6RK6vcquFHjLYBetx6IBZrmYcgsYmHcHp4p36H7DagIByyke2NqEiZpKW9WF7
         VpN7ZBiiIfWpOjOB/slVRw+YTM9FwTh8m0OS234FYPW6Wz+FiOycEm5Sy0Z2Rt6lZivV
         kjVg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768582770; x=1769187570; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s1BTvLdErVOVTXbojE/mp4bn56MJT1unyCMZ/1mKqI8=;
        b=rUw71Oblr7peGlDLutMKSm84iBbKlzcjl7VFAKEkZsfxbEsyKe0WsdL5dR8f6+n4iF
         qXNb+qnBHzLKNq43qq8dv+Xamh/upJEk34g3cUAK0hYHoRWyGZi0cBVAdqQ5khkVFVxU
         6z0IsTq0R3CUucBYTXqzG1Km/sXlqN1W3BtrQB4aSvxcQc7TCsW0bgO5BnxMy19RCMgI
         0elB7RSSfJDdP3+X79vnZrdZWHxTxkvcuF2zsIRt+Nag3/UQdknYqmmrUXbhPIkEpkKD
         XGVDLHOkFHN/MDGvSOS/O8VoAlRSoRwyOfHvV/yO9vXjH2gAYK5LRLWjaXt9Y6R3OJDA
         4p7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768582770; x=1769187570;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s1BTvLdErVOVTXbojE/mp4bn56MJT1unyCMZ/1mKqI8=;
        b=QGBrQOIdHURSqRJmqHqpoF1Qvgu0ux35ibNofHwyLVvPYT6r3+OszUOaXY9yHPtTpY
         NegpqmJmW0IQBzMLcszqt3Y8SPm3NrupXN9bcHd+WblbYTZ52B0ATL9XTfFJ3gGOb+X9
         qdqBGVxkEhX2Ct0vIk4IuJrRW0kjQK3gfnjTPLLUqnwPd8QeUiGH4GPEMBhb9TNFPCPq
         jV2mCgTQz/b9wqV5sFf1oJ4nWUeeb2CTFJLSHGw8dvvk6eX1YnmaY4zmiHiZz5F7C+2Q
         X7+jOnq12A80zgwbwZ8eNuIMVokfPWt0w6XQj/ik7xeu7hVVq+vTM8wTiuzPQ1u6ZfV7
         gqJA==
X-Forwarded-Encrypted: i=1; AJvYcCWDA7TQsqdWc11eBouTZDKIBBDpjLWd8VbVmbvOppQrTHmJUxXuXxPEX4upcO2IM/wE0j0p9fvt6w==@kvack.org
X-Gm-Message-State: AOJu0YzOgc/VypUkBHF8wT6xeqNCSGwuxv/7w2dNpwCh3pbexTuBCRCI
	o1s6p2su38L3+MRlF2HXHQilCAG1PcVtAA5LS175tHUtw+0qegfzFdZqZx+PvQIKxR8cHqP0Vhk
	tR8PACtDZsRoyRrgIdTL9N4K5ZJY35jShy8a59FLw
X-Gm-Gg: AY/fxX6xdRdim8gVYuA2TdxhmA07q7a2vqThbf3xt05LXPNNjhxE+GgenePxb2pAMv+
	M8jW8Ib0qM/RQLPyhMLXzIg/h4cezxEkox/U3oZDs8gKwUIBRJcC66Gp1v+w1Cb4qu/z1d697Qv
	300GkTq/mXnDEvVFcii0NOV24S3RaG52ZITNLVWH07DbV1SqL2z8W3oR5OhLAIpRdxNhA+ku9/C
	XSObsBmmnax9eDziYgtHCNpHDJ8s508/FCDi/r16guMgxK2stDDtw2dfI5YxEtJMxnLTg==
X-Received: by 2002:a05:622a:4c:b0:4f3:7b37:81b with SMTP id
 d75a77b69052e-502a23a54c0mr4530661cf.18.1768582769172; Fri, 16 Jan 2026
 08:59:29 -0800 (PST)
MIME-Version: 1.0
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
 <20260112-sheaves-for-all-v2-4-98225cfb50cf@suse.cz> <CAJuCfpFKKtxB2mREuOSa4oQu=MBGkbQRQNYSSnubAAgPENcO-Q@mail.gmail.com>
 <d310d788-b6df-47dc-9557-643813351838@suse.cz>
In-Reply-To: <d310d788-b6df-47dc-9557-643813351838@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 16 Jan 2026 08:59:18 -0800
X-Gm-Features: AZwV_QgPp527tGrUgX7CIcyuFqzTixlPtSEyPVxRBLdI9BmrU9Axe1wzPof38j0
Message-ID: <CAJuCfpEqZwgB65y3zbm0Pwb_sVLjMbmHbTmJY6SdiVvvOPq+2A@mail.gmail.com>
Subject: Re: [PATCH RFC v2 04/20] slab: add sheaves to most caches
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, 
	kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: g38199aw7waj9i7w4u7doiy66ipmd5ex
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EF11EC000D
X-Rspam-User: 
X-HE-Tag: 1768582770-909199
X-HE-Meta: U2FsdGVkX1+1A8AEdlKqyC2SaqoNQ2x9AiGFmxONnNvQTZkYElira36gt2WqGus1OYGMuttVeJWUj7uyT+tZ03IcRycKGKs93rsKtfE9h01I6NS69/2e8hRwBkoyF3+OOwBZ+fM/U3+/ay2ljZPJB7WAH+RwZBS7owQLGeF4lD3vGiwILw8RwU7y4O/aXWN/xgSzCv3n8WPxi40IDtepDcXWFPhXYtVRqnXSX/9HRimZ8zVpU4AEZzcRNYLmxAfm6buLKWPWjHZXpNpukJy4jQ6wrfvmy2bkxELm06rmjgpWOjttf/kSh2OyJUuy9I3+M/MuwR3TwxhWKj/9qCEWrQe922yaWReaLAZ790uZw6PyVBYnhgWJH4Fl7pPqsS9IQtF3aLthblVmilsAS8GFsmvo586/0aPl97l53uEnk+Beo5Lu4iwwP0OMEYUBtEvFXXA+6NvouyqY/dLpmlXVa5ohwzP1OEfzAkKACU+auyLoJ/mo0ZuVFaJJloRrYMx5u2W85YJZ1fIeCMfVqfE06Genz8Pcf8hTmZOIBzrIUTx1wwOH501wqnIIIxuGhw3qUzRWu1xr2krOZvXfr/TIHB6RpLwv4bb05Wo/kHmAeMwbssyjBAKYtZrpp0BZ8xujA+7iNFK6nFaRfZ8j6gemArK9gTsg+Vy26aiciFMyMAD5y4pyHatzyWTBu3VrdF72AeJy4sI/07kB+7t+Tem4Qq5nsoZdGrG6NT9SrXT3gG1hux6f1TTFcwok+/9C92BTp0/mMYjBUR9y/eHXLG1Pd+83vYbcadoJIFSxA0B+uKtWc3e7C9QG76aUQVoFxkRB3zg6pRwMDAq1s44tINKQYUaR9zYUxsX0TX3kHsrkV/jhEdBkfTAqnFQERAtPNGCm+D/pfnt3t7MqJAmA9ynPtkWu9DouqMSoTCBANkDYLJxgf1uJOQ9O6la/C2FEs+haNVEz/Kb7axYhTzUPHMi
 tvkomyot
 hcxS5Cng89Z/trRGlxPHk8vy447cfSVpmLVyj3xLm3JZjIFFkhuPcs8hvDJckmEHtrgj5uhzMCAsaBoncc1dbwvJ+n/yvDGL7ECuaLBuAsevx4WYPR0VlDrT2qCr+SNd1uoCNjBjUr6mgyiaFdeDl/Cr+NYXM6i0ZIl62BnCbhT35G6HPJjMXw0Q9yL8dul5DjtmBoEMq6QrcCMcutJFSc6NNvSs41Z6hQfFGBx1mYXj/COL+lX+ISahnq1jXt0G5SxxNG2P7RrLAYCc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 3:24=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 1/16/26 06:45, Suren Baghdasaryan wrote:
> > On Mon, Jan 12, 2026 at 3:17=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz=
> wrote:
> >>
> >> In the first step to replace cpu (partial) slabs with sheaves, enable
> >> sheaves for almost all caches. Treat args->sheaf_capacity as a minimum=
,
> >> and calculate sheaf capacity with a formula that roughly follows the
> >> formula for number of objects in cpu partial slabs in set_cpu_partial(=
).
> >>
> >> This should achieve roughly similar contention on the barn spin lock a=
s
> >> there's currently for node list_lock without sheaves, to make
> >> benchmarking results comparable. It can be further tuned later.
> >>
> >> Don't enable sheaves for bootstrap caches as that wouldn't work. In
> >> order to recognize them by SLAB_NO_OBJ_EXT, make sure the flag exists
> >> even for !CONFIG_SLAB_OBJ_EXT.
> >>
> >> This limitation will be lifted for kmalloc caches after the necessary
> >> bootstrapping changes.
> >>
> >> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> >
> > One nit but otherwise LGTM.
> >
> > Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>
> Thanks.
>
> >> ---
> >>  include/linux/slab.h |  6 ------
> >>  mm/slub.c            | 51 +++++++++++++++++++++++++++++++++++++++++++=
++++----
> >>  2 files changed, 47 insertions(+), 10 deletions(-)
> >>
> >> diff --git a/include/linux/slab.h b/include/linux/slab.h
> >> index 2482992248dc..2682ee57ec90 100644
> >> --- a/include/linux/slab.h
> >> +++ b/include/linux/slab.h
> >> @@ -57,9 +57,7 @@ enum _slab_flag_bits {
> >>  #endif
> >>         _SLAB_OBJECT_POISON,
> >>         _SLAB_CMPXCHG_DOUBLE,
> >> -#ifdef CONFIG_SLAB_OBJ_EXT
> >>         _SLAB_NO_OBJ_EXT,
> >> -#endif
> >>         _SLAB_FLAGS_LAST_BIT
> >>  };
> >>
> >> @@ -238,11 +236,7 @@ enum _slab_flag_bits {
> >>  #define SLAB_TEMPORARY         SLAB_RECLAIM_ACCOUNT    /* Objects are=
 short-lived */
> >>
> >>  /* Slab created using create_boot_cache */
> >> -#ifdef CONFIG_SLAB_OBJ_EXT
> >>  #define SLAB_NO_OBJ_EXT                __SLAB_FLAG_BIT(_SLAB_NO_OBJ_E=
XT)
> >> -#else
> >> -#define SLAB_NO_OBJ_EXT                __SLAB_FLAG_UNUSED
> >> -#endif
> >>
> >>  /*
> >>   * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index 8ffeb3ab3228..6e05e3cc5c49 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -7857,6 +7857,48 @@ static void set_cpu_partial(struct kmem_cache *=
s)
> >>  #endif
> >>  }
> >>
> >> +static unsigned int calculate_sheaf_capacity(struct kmem_cache *s,
> >> +                                            struct kmem_cache_args *a=
rgs)
> >> +
> >> +{
> >> +       unsigned int capacity;
> >> +       size_t size;
> >> +
> >> +
> >> +       if (IS_ENABLED(CONFIG_SLUB_TINY) || s->flags & SLAB_DEBUG_FLAG=
S)
> >> +               return 0;
> >> +
> >> +       /* bootstrap caches can't have sheaves for now */
> >> +       if (s->flags & SLAB_NO_OBJ_EXT)
> >> +               return 0;
> >> +
> >> +       /*
> >> +        * For now we use roughly similar formula (divided by two as t=
here are
> >> +        * two percpu sheaves) as what was used for percpu partial sla=
bs, which
> >> +        * should result in similar lock contention (barn or list_lock=
)
> >> +        */
> >> +       if (s->size >=3D PAGE_SIZE)
> >> +               capacity =3D 4;
> >> +       else if (s->size >=3D 1024)
> >> +               capacity =3D 12;
> >> +       else if (s->size >=3D 256)
> >> +               capacity =3D 26;
> >> +       else
> >> +               capacity =3D 60;
> >> +
> >> +       /* Increment capacity to make sheaf exactly a kmalloc size buc=
ket */
> >> +       size =3D struct_size_t(struct slab_sheaf, objects, capacity);
> >> +       size =3D kmalloc_size_roundup(size);
> >> +       capacity =3D (size - struct_size_t(struct slab_sheaf, objects,=
 0)) / sizeof(void *);
> >> +
> >> +       /*
> >> +        * Respect an explicit request for capacity that's typically m=
otivated by
> >> +        * expected maximum size of kmem_cache_prefill_sheaf() to not =
end up
> >> +        * using low-performance oversize sheaves
> >> +        */
> >> +       return max(capacity, args->sheaf_capacity);
> >> +}
> >> +
> >>  /*
> >>   * calculate_sizes() determines the order and the distribution of dat=
a within
> >>   * a slab object.
> >> @@ -7991,6 +8033,10 @@ static int calculate_sizes(struct kmem_cache_ar=
gs *args, struct kmem_cache *s)
> >>         if (s->flags & SLAB_RECLAIM_ACCOUNT)
> >>                 s->allocflags |=3D __GFP_RECLAIMABLE;
> >>
> >> +       /* kmalloc caches need extra care to support sheaves */
> >> +       if (!is_kmalloc_cache(s))
> >
> > nit: All the checks for the cases when sheaves should not be used
> > (like SLAB_DEBUG_FLAGS and SLAB_NO_OBJ_EXT) are done inside
> > calculate_sheaf_capacity(). Only this is_kmalloc_cache() one is here.
> > It would be nice to have all of them in the same place but maybe you
> > have a reason for keeping it here?
>
> Yeah, in "slab: handle kmalloc sheaves bootstrap" we call
> calculate_sheaf_capacity() from another place for kmalloc normal caches s=
o
> the check has to be outside.

Ok, I suspected the answer will be in the later patches. Thanks!

>
> >> +               s->sheaf_capacity =3D calculate_sheaf_capacity(s, args=
);
> >> +
> >>         /*
> >>          * Determine the number of objects per slab
> >>          */
> >> @@ -8595,15 +8641,12 @@ int do_kmem_cache_create(struct kmem_cache *s,=
 const char *name,
> >>
> >>         set_cpu_partial(s);
> >>
> >> -       if (args->sheaf_capacity && !IS_ENABLED(CONFIG_SLUB_TINY)
> >> -                                       && !(s->flags & SLAB_DEBUG_FLA=
GS)) {
> >> +       if (s->sheaf_capacity) {
> >>                 s->cpu_sheaves =3D alloc_percpu(struct slub_percpu_she=
aves);
> >>                 if (!s->cpu_sheaves) {
> >>                         err =3D -ENOMEM;
> >>                         goto out;
> >>                 }
> >> -               // TODO: increase capacity to grow slab_sheaf up to ne=
xt kmalloc size?
> >> -               s->sheaf_capacity =3D args->sheaf_capacity;
> >>         }
> >>
> >>  #ifdef CONFIG_NUMA
> >>
> >> --
> >> 2.52.0
> >>
>

