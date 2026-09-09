Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED3DEC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 17:15:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01F786B009B; Wed,  9 Sep 2026 13:15:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F323B6B009D; Wed,  9 Sep 2026 13:15:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E221B6B009E; Wed,  9 Sep 2026 13:15:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AED8C6B009B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:15:40 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0AF88C02BD
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:15:40 +0000 (UTC)
X-FDA: 85194875640.07.5112DCB
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf19.hostedemail.com (Postfix) with ESMTP id 099041A0012
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:15:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pdn4DDgy;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788974138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mKUmBDe2b4FLQdJcR20tHldduUrJACzKAwyQg26uG2s=;
	b=4ia2GwOiFCoxskRIITdA4fUi9VYu1cx72qsNGfS9Yx63vJBXH63mFpXHna96ly1yDpYvkR
	8IEZeGh7U06znganvn6H+wKDE24q4H0FFTmFZq/anVnd/1ElEVWeJq1b6XRMn0lsyGzIcF
	h+9HZMKrLfKrupV7K2HK0a+3V7BttFI=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788974138;
	b=Z0eTFyzKDiWzP6zEgfZ8T7AdSOn1RMZAihollBcnWnV41Ic3AKz+J48na5ESGx01skUOHm
	zJULeTWTWzKpR8/uref7M0IAEyxeei3ngRREQP71twDsoyAFOtIoP5TgH5uqVx/kAbyZMY
	Aa1bHtZykSmPY9PiT1uMqIpn7hlfIUU=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pdn4DDgy;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-53012819c04so284471cf.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 10:15:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788974137; cv=none;
        d=google.com; s=arc-20260327;
        b=GlCcPQOMmU2rB3J178hFkWpYlXIThDsHmEl31FNaLnORUupGNWHD1dpvHUBsLY3YdL
         IvRTRS9Z5IsXcDajuqTBOyzDw6t+hLTRbZ7LgeKL+eutjEz9UYiGp2MI3Wx+WlBKaIvy
         92YShkv77cvMU3Mceeza3P7OpvJZRJz+T8IczkMWnTXWs2UW4MbSWbpB+e+j9YqezW2T
         8IJWPUsnAjTjlrxtM5JMH3csTe/3uFmBFJ07HGPc3EGc7ss+/pzV1+v37u32cG5aG3fi
         mAdZe0OgGwxAUev+NgSvxudb8vKNkRBYA1Q9MbWVb123Hc8XW31peo2GCSx0jcSM6mvr
         PtPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mKUmBDe2b4FLQdJcR20tHldduUrJACzKAwyQg26uG2s=;
        fh=tSrTTNn4tMaMHjCuo/bIPn9lt6iDoKQBhZUzlmDpTS8=;
        b=dzjxfLcN1/3OfEVJugvjz7dedHFv7FzmzAKQhwTac80gY5jF6+birFO4bvHySyqESV
         6rCCORqobIn1lmFEkz5fxExF7ogz/UhOdn1btD7YfhGqH4BbaSBmoHLWuy210DXXkrOJ
         nrkCBNO8iresRKtVsow32i3Wc2uf76l/mEjYcPnbhakL25DmddmOCHbt/nU5PmcoDgOS
         4oRuG4hOCyUtq9LpF2dirPlFqaqoosgPhL0qbdPFluZ5n7JtWjle1bOpTTmM8QJoteKw
         V2fxWBvwR7Lcco600O2P+CUxeEvZM8ee0BpniupQqd2BRXoMCHg+NiPcoQH2DP5UCy8p
         vtcg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788974137; x=1789578937; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mKUmBDe2b4FLQdJcR20tHldduUrJACzKAwyQg26uG2s=;
        b=pdn4DDgy7TgkN9GT9wJJzW3etO73proy5T1xCcRwHXUHGNd/lQoSuy3LyddBfQXhpk
         zro7buf9uzPHOzIJo8cZn/dSQQV9fVf3R+DgOzkneRsc9eeNlltmnCWzDogrvI2nX6/R
         Fone8BM/k5SA/afIyClo+Nj6uiUAiaTHxsx6/7Zi5nLdPfE2LNFliUcd18u4LYyfu9K/
         S0F9HuVGSaNNRHmdwoPE1XMlRG6sWk0CrT174lC5hJ9owwFtrjaUF5gmxHpDMnykdB4c
         /E8FCq6SA9oFgYcbCgfUCpftm8ddt5fjukvQFM+RoP+saod63l/RakMJp1bFmo6XTHO2
         hV2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788974137; x=1789578937;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mKUmBDe2b4FLQdJcR20tHldduUrJACzKAwyQg26uG2s=;
        b=GnOcLU6uJeML9luNBzoA3mPs8aiHH9b1ePtdxgauLSpLayurDwnu36WEUuGVFkfXLy
         TGL4QIQygv8dOpb7lF7gjOp7/SUG4RwwjndcQNfM+K+9K+n0qzLqwWvmomgVyU6UnO6e
         Vn5FOIaTWR5D2FLizCwlS0KvIV16uUgFH2blZhHoUjbBgSztdweFH8pnN4d1vjsZejm+
         4Ta/L0QQvAzFVFAdoie644ACQnEnvQEVBUelUtMsyRwnr6OfnIx1uyQJI9sH3+7epXBf
         CehqZAmJRRpIEycSx6jqak+jIPkGzkO0j4weWIVNbRdkaIP4vhvhPYPDf0f3HUqmssKW
         0Mdw==
X-Forwarded-Encrypted: i=1; AKwUvBz6RLoYyTBIzHOQpXnv2q+mh3FaHwDTMSm3ISQg5GALvRyLu4VxvVAQTOl6mWMdBybbhhrzvio20Q==@kvack.org
X-Gm-Message-State: AFuF++lR9Ww/0NnRt34ziWT/tQOpd3YQBgZ00R85lrQNes2LPl2ENKql
	gC7S9gxxj+/XpxXzSGstBJO2xflIlkgxMjkINMfj23EQq/a20REqhmX1pfA4FZisqGTQdCnlrq+
	u/LUfESEF+bPPDJZPdpVLSQlvxbOtTKZEYCNpunDB
X-Gm-Gg: AYBFou2Dzu24UsJlvA9v4SHUqxdrKSol8OFkSCxE4PVb1NTnWxNBKhv6dfUwmYhl/tY
	LerrruBuoroH2fzVX0xOPeIug/rVyW5GGbQ7yiSD7SGOmmTfCDF1FBZcI9dBsILqheYmYjxrA5Z
	u+m7uTyrh7ZBbvE9lLpBUXeUNGItghvg4j1Dtbkrird4bC+HInSn6mWSAPXrnKjyKeSTBmXsnBE
	qpjR3ryd8fg+BzipU5GzgSzTBdZUAkucL7mG8E/+tyafVi1/ZAdGkfyWdMcmKhhKswPpvOfG/n6
	CIcD5tQ8rXMFxlzrfzkT6uPwiI2j2SbpEK8CDy9u4sfxosmknrJV2FK9sbtmzR/Y+TMl
X-Received: by 2002:a05:622a:a1b:b0:530:5ed7:50f0 with SMTP id
 d75a77b69052e-530a5f51176mr89211cf.13.1788974135518; Wed, 09 Sep 2026
 10:15:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260907063918.3432401-1-surenb@google.com> <20260907063918.3432401-3-surenb@google.com>
 <4964f874-3f3c-464c-9977-0d004f6ffdbd@kernel.org>
In-Reply-To: <4964f874-3f3c-464c-9977-0d004f6ffdbd@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 9 Sep 2026 10:15:24 -0700
X-Gm-Features: AcwNN1WWr8U2hfUDprfzdhTtlvlOsxUFMQbj8KtH7xWoq0JQsfsSVRf58XyzXHk
Message-ID: <CAJuCfpFJHNq_iCHuzDC0a8CT-AsPLHgnZ0=hVAvVhax_Q6GjOQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] proc/task_mmu: remove unnecessary inlines in
 function definitions
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org, 
	vbabka@kernel.org, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 099041A0012
X-Stat-Signature: 1otrxj85dzywmy3rfq1jdaw351nk9i8n
X-Rspam-User: 
X-HE-Tag: 1788974137-237870
X-HE-Meta: U2FsdGVkX1+NcHeON28AQBIQafaKahaWCBsLAe1gR3Z2KExVW8tF96phM9PPoXsvqkDl/g3dBrog8BGNCwaZfllwnW8Mx0g1HxgDUWkO/fAjbj4gve8+4IT5tWLgF2Z4pvavLQ9//eyjXfTSJHbiflGcc7roapIAsBwNMYUD8DCGsSYw2a+whtKl/4m916+DtrvZ8sA9GJHR+JFarwchWo3haeGnb04YTlRsdDE4zMg4UMnXZp1Ojr2qDrdFCbfz9ppJcLhzCxr2MJuqzhmAIJVIHrNziwJ7shVrkpavZmGoURcFm1jlNo8c3nf44ymCRmjG+J/ctCbnKCY7KA/MUt2iAumm0nfSe/4r6i1GL9+F+MOonFl1xkhk8G5Pbu4nxqzwrIVNzW0bRPx8iygVavorpURhpJ0MjlQsr6aQyVqAs8M7pVAp8fNTuDlviYOa6DPM77OrTBGZa8uZJzGQE+DA3CC4BNeStP4RitPFkRVhl84ctdcn2PsH9EJUMAk+hGI1e90JTO/FthbaPjp4O5z7zlZ8yBQJtzodXoIyYYBD4eLujJlCTWQe2RK6bpBTbTdKh74zOkf/Od1ifkvlRXVlDZNLKHm8CXKbf00EItvFlup+U2CTE7F1fj0+djbctOfS2n8r53oGYijQL4bk6ozZeZz6qN7MkLsuzYyb0ihfiiwcLT6AdXCCIaO95A5L2shyoadwB4ZnaZKt27LbQUOi8yo3LqGpBishYv36R8FYnzpsj7mY9HSMe/eLJVzrpOGLXyXj9S0dHJoARsEGLn0wDZ97ro2OKVSOFzeIQDJxB1Vc/APSfT8uM/ywAXVj04JeuDYpE3Yrl3RR1wI9aixmui+IhKzlc6zC0H7nOrZH8Dze66xbMt2HI+U51lLNVJY50MEt/J7zVtaZ2zalTY1ZUBlEQFTaNsXdpnholUdgmr/ZSq1dY3DN6AGAtpPTZ8VMHhxBhNW2sqP7H66
 fiNs4aSu
 v+aFQwrWYgiTLXD5LOJ3xRvJEv5lN27gx1MmBrsy2t2478zglxcyohurFMNbV04JCd7295ZymqxgJoQ6sh/a7QrVfgNqtlJoyMIuIGMRuI2ivnpSPJD9IgXe+QIVqtNV+ktbvDVh4hCB4Bdz8Oh3LwcJNAAcyNIyn8oIzwa7iWEUZ6hdnhoDrO2HUoUCT66moGATrfb8uYwFCs39jnIwpzwtZ8a2Y9q1mLtHX+timtN1VFYC6i9jsoRzGDc/JgEW5d2YJKHS03NTNF++HWthVHbU5h/wYLmqKuHKKtyy+X8ug45PvtsNqAZKoLsc+fFbpnzJC9nW7d5x9Fec=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 9, 2026 at 10:07=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 9/7/26 08:39, Suren Baghdasaryan wrote:
> > It was pointed out in the previous reviews of this code that many
> > functions are specified as inline, which is unnecessary as the compile
> > can make that decision by itself. Cleanup these definitions.
> >
> > No functional change intended.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > ---
> >  fs/proc/task_mmu.c | 32 ++++++++++++++++----------------
> >  1 file changed, 16 insertions(+), 16 deletions(-)
> >
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index 2f500d639db5..9908ba32f180 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -130,7 +130,7 @@ static void release_task_mempolicy(struct proc_maps=
_private *priv)
> >  }
> >  #endif
> >
> > -static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> > +static int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> >  {
> >       int ret =3D mmap_read_lock_killable(lock_ctx->mm);
> >
> > @@ -140,7 +140,7 @@ static inline int lock_ctx_mm(struct proc_maps_lock=
ing_ctx *lock_ctx)
> >       return ret;
> >  }
> >
> > -static inline void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ct=
x)
> > +static void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> >  {
> >       mmap_read_unlock(lock_ctx->mm);
> >       lock_ctx->mmap_locked =3D false;
> > @@ -177,7 +177,7 @@ static struct vm_area_struct *get_next_vma(struct p=
roc_maps_private *priv,
> >       return vma;
> >  }
> >
> > -static inline bool fallback_to_mmap_lock(struct proc_maps_private *pri=
v,
> > +static bool fallback_to_mmap_lock(struct proc_maps_private *priv,
> >                                        loff_t pos)
>
> If you touch these, please convert them to two-tab indent.

Ack. I didn't realize that's the preferred formatting.

>
> --
> Cheers,
>
> David
>

