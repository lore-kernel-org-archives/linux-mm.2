Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C67D6EE499A
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 19:39:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 310806B0088; Tue, 30 Dec 2025 14:39:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BD6D6B0089; Tue, 30 Dec 2025 14:39:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BFB56B008A; Tue, 30 Dec 2025 14:39:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 085886B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 14:39:02 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A1A28B8061
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 19:39:01 +0000 (UTC)
X-FDA: 84277150482.11.23C05FB
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf29.hostedemail.com (Postfix) with ESMTP id 86C1E120010
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 19:38:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=t+BxswAQ;
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767123539; a=rsa-sha256;
	cv=pass;
	b=kjl+QWe3tmRs5PtD0CozIUBxa+JCv40Zgtq56ftHojJa6ZHQ65B3VyPjkd5HQ2zlwPSGJx
	RYEyd0biJJxITwXPPzNpAMkd+GYLsSso3y/ITPnpodKwVpEIYgwTCEPMdB60J30ExxiLMH
	33F41FgOQ023JTSShMQiMazZDNmF4Bs=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=t+BxswAQ;
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767123539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gvznMYyZGNxGgUAqPXCv41E4K6pkv8m0/5R0C4P9Z9c=;
	b=hYoHilVFNx322I7iuvNw1w3BSDlliq6aGzglr1i3tdhk98q3ACU/PIX4/snte9F++SoJfV
	AaNdbNajiaNo854M6lqIWOJo7MW0tKx6/3PrDGmCgwnb0eEb7OuigBQdzZjHG/YIbNT8ap
	94mUwxBnmoMkgb8MTVmVx8yZslXj+9g=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-64baa44df99so941a12.0
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 11:38:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767123538; cv=none;
        d=google.com; s=arc-20240605;
        b=Vhf1ywSaKASvFJuv1XGI1ux3Yu4b7S7BqtTnBgue0JQmcV5StQTvSQBOpBQ8TwTdwN
         tCImEbEF4x2tWprMV3BvkitxBnVJLoScuFJuH0VEyzTgPIcwbvnIF5Tqy5cMb+kn5eQ5
         fpZUoLprRe+d/q/46fw6f1FPWQM53uZArrpyPdeX4rfJtn2X2o0jhuIQPHSv9+rEeOSk
         lxi9R8ZM2o1t174SAkQiTELr/kSlVLh5WwOCSDknq/bBzHGtayaUm1J2Q1dua1zK+g5v
         b7LsGKRfCQpXoyWJl6Vt6GL9WhFRFQLXpPmSVezM5grgKRJSCyMm0gWDZbRyl2o9LIcL
         xQCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gvznMYyZGNxGgUAqPXCv41E4K6pkv8m0/5R0C4P9Z9c=;
        fh=LY6SIDMjUvqtIwsRV+W7f5fFOnO0FzGvOQ6fUDZ75X0=;
        b=bZ9qqdFehKtu8mpanrOPD0O/+54uwliyEXyG4qQgXKwtDVOHACC34MAfqN+NEsnsd7
         L2Y1Z39xaPRKoB33occkTovo9d2YDYzdQv4vt7YCVCNhcdzl8zkAs8sw8XXppkJ1EWSA
         w0fYiCXk3okHBUSTnsG0rCY42/z58umWYAIXPYRlPaJp8ApKz7S6nUG3Lmg7vmBkAver
         XFKMQDaZ8/j0OLrHc7YWWX1WqWJ190IpiaXmxf36si+nBecCbgv9itvPrAKBH80+oMbY
         nYjt6teWPanHyouOTmxgNCyd6L5r3wynR9DDZqJbwhNzIMSFZYlmoYNVS1KZC31Ei7zt
         jXpw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767123538; x=1767728338; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gvznMYyZGNxGgUAqPXCv41E4K6pkv8m0/5R0C4P9Z9c=;
        b=t+BxswAQ65YmPyOov4xDW3ZIPfWMLHp26fYwO+oOgoDpCSc6tM4NWspI8O4SHRFNUj
         pW2gP4SE+yG0ym9svZp0wM6j5jbz3Ypb2sDqKHiIMo3tKc0L8UpOlvN/gZ5dNwUINrei
         FLcRQFKZ5lSt/ecf1N8S/dfHvMiRj6SYLfvAEUhkfUkAYZyB/ButSAJOgiVYkRy8p3gL
         ZgbvJWTrVdS+7QwpKMlujWmjtzmsPqsUr3c+A2ucuNDkwJtiN4rS7p9XQpINLnLMt+pB
         ah3IHeMw0wc68Ux8hPzNAhIiMZUEj6l2YH1jU5O3Hj2Uh2JnHQ1rjqwarZvJ98r2JkO2
         OzAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767123538; x=1767728338;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gvznMYyZGNxGgUAqPXCv41E4K6pkv8m0/5R0C4P9Z9c=;
        b=UnpWiloCqRxN2u6VOqzmUaR7L4NtDwXKegy3/ZdknqVoFUozkKBGd3nKLL5cUl0cuL
         /bXU8v8xm7eiCNZHVHq83Jsha8e4q+cQtg5FTIC/JIHJehiy+nUIqDYRUj88yLrBDzib
         HNjpQ+VskoPUgtiFHBiQMZ5GG/Z9Y0nsQoibvUwNhRFLe6g/58CpTJquZRqZNsE5wnf+
         X3gpCpDmLZ/6U+NfdifKGEHzFP8v6XY3SGbV5QZIUU+rsZ8/huKBAV71uoCl1/5xKdcV
         Fq7rm6Ydj5HDOlnZl1jX3IABN8ND2KH7egusVy3JHd7XsNUgHmZ94rvS60m8M8sn3HTk
         pEfQ==
X-Forwarded-Encrypted: i=1; AJvYcCWDAtz2EZBePAPwhvuqDcJcuXWD5ck8n/3nloZsl1ExtG2LaZzzrGiaN0Pf+ctmP9a91SjxoLMoqA==@kvack.org
X-Gm-Message-State: AOJu0YxuansFqs3/hTpj9sKniqt3Pk9YQqqNCWd3bBVRIMEMCxeVYa/1
	Y0kXIBnTKyAIYDP/fkYB34tafbEj8EJjmlXqlVCk99XQDhKl/tsVBTTgyGoX62ZqcXrcxNCBLD1
	MmSS0pKbe17eWGUZgq7ODl11mVdgsYL9XnoQ8TElj
X-Gm-Gg: AY/fxX63WeHPBiaU2EmUPDM3sWBCyyUOoEUiopRhZeK4Lsf0WNeCNLGmyjtdoPAQPPR
	Ir42XUVZp7KG010Oj3/m9GO67Fonht4+fOZjS3/hR7ahBw7cc9VOArl84EsK5KzZg5w01nlJN+A
	hlhaQLvv2KsQEkYYBkJZ/jBEXZb5RrLZ+PzO+P5GOdDVxq5B365xJgsSa4zZqXEuPowMra7za/I
	4gMkr0Trjb39i4dnlw3Gr7lGCm++edvY2u3Fn8mG34r/Oj7EcbtmkTXtUdV8s1sXLuBhKRWnzoU
	CEKGNzaYxbg/LakeIxJh+OmSPg==
X-Google-Smtp-Source: AGHT+IEpEHj/xGYoKYzyOgvcBfL8Gjau4mxkTywLRH4b01bUVl4hCqDkfFX6kzWpwAgT2dSNReSSyrc6kbm0YsGvEOI=
X-Received: by 2002:a05:6402:8c7:b0:647:be8d:d67d with SMTP id
 4fb4d7f45d1cf-64f4192c041mr4020a12.2.1767123537836; Tue, 30 Dec 2025 11:38:57
 -0800 (PST)
MIME-Version: 1.0
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com> <ff68a8f703701c8e626f0cb190c845c5d883c88e.1765970117.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <ff68a8f703701c8e626f0cb190c845c5d883c88e.1765970117.git.lorenzo.stoakes@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 30 Dec 2025 11:38:44 -0800
X-Gm-Features: AQt7F2pNZwwSc-1Nyq5uGObM8k-tavap238rloZSrFlJxt1Cu9f1S41KL1tcW6I
Message-ID: <CAJuCfpHZ=SESegi=M4MxX7gfxiWN=Fmn38XwqVszGoveZp9gUg@mail.gmail.com>
Subject: Re: [PATCH 5/8] mm/rmap: make anon_vma functions internal
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 86C1E120010
X-Rspamd-Server: rspam04
X-Stat-Signature: co1y9cbma75ob6rwio57syoke6z566r4
X-HE-Tag: 1767123539-273684
X-HE-Meta: U2FsdGVkX194yPK/5ZJzMqgbFt9pEBMW/jcM34FKKguUPuu2vCG72Foepc4gnuRdAw8AGG4vSowmIyWsMDw4E3pKEYeLQzwVUY/vvtQqgD+wSLudqg4g0kVkAL/k5cEuf08Ff9a1FG6FZX/1EA+qFFiGH2UksZwNLPWIF97oRO8tp9sEvg8vJicex6aeGjQCgiBM/dk+7u1+TFUeLkhuhIAf6vQ23xl0Q1N6Eo1CpuaunKcpdnQYSl22qQe0+noDqp1LqB34oIiHs7xcOfIOYIVGS2SsBSrNjSjLpqT/s7HJqNtIzbArSk2H7UZGhgua5cPknlMDDj+2otz7B/+Qf8w1z7zXyBfdEsURXDdriPfoukvh1rjHBV+mHvV6nj97o65URDHvS/zYi5CdHYtfPmMxBWDYIIDDYGFwZm+pFPOlkC5NpY9DKZgchZ0GgBzZ5WNqA6gtsr/pPqEX3J4BRiWz5O1k8DvPa7SheTnIMeqUG7u/qeHP2mda6nhZQjl5jEnFO8qGVVC3VWTcpPM4wGW3SAeN9d35VJ3AfK4WqiVFmYYooCWck+v5pZDW+wVWaKI0DdTis4v+wjGOlrDaVP40lJFhWEokzKCKocSobCiPyuYp2iTarxX2jL8FXkSeIL08UcjXl6+MD4JyGUNVtQ+aFrnqM0+VWl/sno67bIrMxLOeihDmGWB8T31LTfHWLva+FpNzSzYxX8BvPqPgG9aD9f0wA5zet+8fVmKFoJV1sUB5leqZ3/YnNnfnKKpAWupVm9/5HKz8CKnhsIuzE3uhUnbPJhrZ6seYA1zz7B5mSjQJcgL8/ihuFgLU/hA3b6/JsaxLocPrTdTRAGL+wPn8iOkrsZF8yk+37A6touByb9Nl30AYWDZLcfr6fVMK5P1oEgJUmifnST/yQz87geUnX47rFc6Vg0pN70RhSWhfOIS6sh68SfG+OjR7NVPhgVE3q11Ar7l3hDFUfr7
 E18hdCBy
 Rc2CH2i8kg3V137IQXF5pqvCo+opwiya1ehRKr7wH9F1X0AcIL3JTT3yMtsXpgKHwD1UgEQuZ9bsgbuFwB2DJpvV6NlIFvfdMmEz31oLIn8AxnUP4SCFq3HdH9+YsS35P8/+tDQOrjbZYXEZn9eTd7ubDv/TMV5ONJ5xE/M9UWSu85Etvqwz6oVmKYt7HuEMYvfowE5uWInmTkVtQwPx/WLEap+NZqjlfNDMZav8J16Do3bKpIrQ9DZTfxbxLQAyT8siHOnN4JD2EfuNlqu3yRaITb4YMs/t8z154e7Zybfudb6iXy3pt3wVuasCxAtobo/Rgo35uL5LPOBjHRzVnCqH6tvMiWJiYoxn98G4f7zDDvyI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 4:27=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> The bulk of the anon_vma operations are only used by mm, so formalise thi=
s
> by putting the function prototypes and inlines in mm/internal.h. This
> allows us to make changes without having to worry about the rest of the
> kernel.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  include/linux/rmap.h | 60 --------------------------------------------
>  mm/internal.h        | 58 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 58 insertions(+), 60 deletions(-)
>
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index 832bfc0ccfc6..dd764951b03d 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -104,68 +104,8 @@ enum ttu_flags {
>  };
>
>  #ifdef CONFIG_MMU
> -static inline void get_anon_vma(struct anon_vma *anon_vma)
> -{
> -       atomic_inc(&anon_vma->refcount);
> -}
> -
> -void __put_anon_vma(struct anon_vma *anon_vma);
> -
> -static inline void put_anon_vma(struct anon_vma *anon_vma)
> -{
> -       if (atomic_dec_and_test(&anon_vma->refcount))
> -               __put_anon_vma(anon_vma);
> -}
> -
> -static inline void anon_vma_lock_write(struct anon_vma *anon_vma)
> -{
> -       down_write(&anon_vma->root->rwsem);
> -}
>
> -static inline int anon_vma_trylock_write(struct anon_vma *anon_vma)
> -{
> -       return down_write_trylock(&anon_vma->root->rwsem);
> -}
> -
> -static inline void anon_vma_unlock_write(struct anon_vma *anon_vma)
> -{
> -       up_write(&anon_vma->root->rwsem);
> -}
> -
> -static inline void anon_vma_lock_read(struct anon_vma *anon_vma)
> -{
> -       down_read(&anon_vma->root->rwsem);
> -}
> -
> -static inline int anon_vma_trylock_read(struct anon_vma *anon_vma)
> -{
> -       return down_read_trylock(&anon_vma->root->rwsem);
> -}
> -
> -static inline void anon_vma_unlock_read(struct anon_vma *anon_vma)
> -{
> -       up_read(&anon_vma->root->rwsem);
> -}
> -
> -
> -/*
> - * anon_vma helper functions.
> - */
>  void anon_vma_init(void);      /* create anon_vma_cachep */
> -int  __anon_vma_prepare(struct vm_area_struct *);
> -void unlink_anon_vmas(struct vm_area_struct *);
> -int anon_vma_clone(struct vm_area_struct *, struct vm_area_struct *);
> -int anon_vma_fork(struct vm_area_struct *, struct vm_area_struct *);
> -
> -static inline int anon_vma_prepare(struct vm_area_struct *vma)
> -{
> -       if (likely(vma->anon_vma))
> -               return 0;
> -
> -       return __anon_vma_prepare(vma);
> -}
> -
> -struct anon_vma *folio_get_anon_vma(const struct folio *folio);
>
>  #ifdef CONFIG_MM_ID
>  static __always_inline void folio_lock_large_mapcount(struct folio *foli=
o)
> diff --git a/mm/internal.h b/mm/internal.h
> index e430da900430..469d4ef1ccc5 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -199,6 +199,64 @@ static inline void vma_close(struct vm_area_struct *=
vma)
>
>  #ifdef CONFIG_MMU
>
> +static inline void get_anon_vma(struct anon_vma *anon_vma)
> +{
> +       atomic_inc(&anon_vma->refcount);
> +}
> +
> +void __put_anon_vma(struct anon_vma *anon_vma);
> +
> +static inline void put_anon_vma(struct anon_vma *anon_vma)
> +{
> +       if (atomic_dec_and_test(&anon_vma->refcount))
> +               __put_anon_vma(anon_vma);
> +}
> +
> +static inline void anon_vma_lock_write(struct anon_vma *anon_vma)
> +{
> +       down_write(&anon_vma->root->rwsem);
> +}
> +
> +static inline int anon_vma_trylock_write(struct anon_vma *anon_vma)
> +{
> +       return down_write_trylock(&anon_vma->root->rwsem);
> +}
> +
> +static inline void anon_vma_unlock_write(struct anon_vma *anon_vma)
> +{
> +       up_write(&anon_vma->root->rwsem);
> +}
> +
> +static inline void anon_vma_lock_read(struct anon_vma *anon_vma)
> +{
> +       down_read(&anon_vma->root->rwsem);
> +}
> +
> +static inline int anon_vma_trylock_read(struct anon_vma *anon_vma)
> +{
> +       return down_read_trylock(&anon_vma->root->rwsem);
> +}
> +
> +static inline void anon_vma_unlock_read(struct anon_vma *anon_vma)
> +{
> +       up_read(&anon_vma->root->rwsem);
> +}
> +
> +struct anon_vma *folio_get_anon_vma(const struct folio *folio);
> +
> +int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *sr=
c);
> +int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvm=
a);
> +int  __anon_vma_prepare(struct vm_area_struct *vma);
> +void unlink_anon_vmas(struct vm_area_struct *vma);
> +
> +static inline int anon_vma_prepare(struct vm_area_struct *vma)
> +{
> +       if (likely(vma->anon_vma))
> +               return 0;
> +
> +       return __anon_vma_prepare(vma);
> +}
> +
>  /* Flags for folio_pte_batch(). */
>  typedef int __bitwise fpb_t;
>
> --
> 2.52.0
>

