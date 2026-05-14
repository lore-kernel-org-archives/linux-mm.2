Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4010CD4F21
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 00:58:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B2A36B0088; Wed, 13 May 2026 20:58:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 561FC6B008C; Wed, 13 May 2026 20:58:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 451A56B0093; Wed, 13 May 2026 20:58:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2D7C16B0088
	for <linux-mm@kvack.org>; Wed, 13 May 2026 20:58:05 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BE7D81C03DB
	for <linux-mm@kvack.org>; Thu, 14 May 2026 00:58:04 +0000 (UTC)
X-FDA: 84764213688.23.FA509F0
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id D33CFC0002
	for <linux-mm@kvack.org>; Thu, 14 May 2026 00:58:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AJmAqmBO;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778720282; a=rsa-sha256;
	cv=pass;
	b=EbKLSsXgjnJSWmvQJJs/teIZ8l6WBb9rj/+WDM2EpYFuDAeo/PdU/xOP4Mh0CWiPgStpob
	k5Q2dx8ncX+N4WeQKyNA7jIVoiu9XV4WSiUQDcoCsfOHZIsNwtk2PlEJe8UMR8J4JMHTbJ
	Hh7vkNiAI/KW4b4VfEc7pS1iuJO42Gg=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AJmAqmBO;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778720282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0yLtkvpHrIrmGWo2XwlyoEcBPWHX6rxbIwgfMci1D9s=;
	b=kKad6DsGIReh2Emm18KGD5mHYQkpJV6VKeSa+4o/HuqNVgnrhEr5JPoCHmISFx2aC9AQxG
	7QVAH7+eaE2gJez39W4WX0JyjUl8BwCW3HHhjLmR/r+lSpLqcFxsqpkN0saGUE0auSK4Zr
	jFkXCkNi0xiwPvSH1MV2XI7bGDqIgyM=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-50e61648f10so149121cf.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 17:58:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778720282; cv=none;
        d=google.com; s=arc-20240605;
        b=HxaKtpUOaa4EEMNtOb6eG/UScqq5N9uWc6g/pT0xB8jh5VJ/XxqlT/U5R8Bz8p0Tj7
         EHdOGdx+df/jluarGFN+k/eRTlYueKEXvJ7VeVv7ABpbp97N7FPpSI19Hq8S0pZHpq0A
         0KvDFvrHQhUKHlWKdTBaJCpjyqy0CY2RW9megd53lMbyeS0zUsJm0FSNayT5XgKwCQhG
         XDCeaRgRKCdiB0ptWvMsFNIGMpNc2oKPcR4t3vNhTIg7gcU3MG0LXD40u/PPZ6q6WREd
         X/siq2RKnL11t73JA2gW1CoAd7GSo+yWjqytbCsxy22Ln1tKRgDQsovjQ0TdBTflULM6
         /cqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0yLtkvpHrIrmGWo2XwlyoEcBPWHX6rxbIwgfMci1D9s=;
        fh=wIEjSBMCTrPwc0Nv170oyPW4f7dgQtDgD5SuBlj4cSQ=;
        b=QmjMhh4DlC7/6+4WlkDLOymCnWVQcc/lYwpOzNjxayFHhFvkKn7NFWXds2+jSh96Gw
         muqPCLfp6K5050OQJW0Ho+BBM+eE+ithSSWCanCIOmd4IHGcF2HwjUykK4uP6lBeQVol
         FUVi1rEE3qVZHlAtmz+DxF96DwkmyQA01PxIEJ9TNbEXwwR2tUz7WuytaBaywKCHlnYp
         WuShes0DuKEqD++GVsReAJGMieEjS6wTgaaktK/Yg8meJLwJQdoyn9IkhMQL5cZhlcFl
         Iv2pdWlwb1L7+s+3OF0sf3ePEYXRrR2azHlZRfc78g7i1oCC8ZjJABFPxHZWvhnlhzt9
         Ssug==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778720282; x=1779325082; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0yLtkvpHrIrmGWo2XwlyoEcBPWHX6rxbIwgfMci1D9s=;
        b=AJmAqmBOSblFe1+zLhtxk9sQYUUin+gy9gAOQGZcG/FoH+IXuwt1nSyfGwKyb2zX3X
         R7Cu6ju1iVLrWrqEpoARkwK3rkSDN1/Y8u9/d8Ytut2F3emIQorWgZFLTQjd66vNzJwg
         hMzM/TR7er/oZSx2u9hhs45McOhegX0K70UPUihQnglC8jQetz2SZwI++qF0N/LwfvnR
         AIJHGHTK+sOOR7JNZ9FuCfRrEtQyI3rmKm6I4gNKpt97otO9JcixRupdfVrX0msfZqdk
         vhlx576QoD7rK6K3xPn5ieHKg9rD6/Y5WdhTKN3wTE6rivLUqmUyT4of6yv/DUaV0W8h
         0SEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778720282; x=1779325082;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0yLtkvpHrIrmGWo2XwlyoEcBPWHX6rxbIwgfMci1D9s=;
        b=Dtf1/QyzptHYuJjNUTslGOocwtPNlQ6/M3aWz6VWzSyTFuED2AyTjB6wX5SNo7uInc
         QmnYRi5rtZ1DXu4nmShRdWWGvIiKuRBj1JMoZmhP4U+fLWfbjO+OCRTQP6JFTJ9FougK
         dfJCcS5GiIwEUkFF1H2iVNqoUidZuFLK8sv7/NioRf6FeS/QDJobQbOJRQEZzPWf2+iR
         Gb/HRZ3yRm1of7pELZ8kG8gK4mImurov8++mcdywUOUg+SKmCOz4asIVJXNYya0gQSd1
         AJjdnv9v9atyb8G5zfT3GAxSkNPW3MypPYJQQoTt9rqPEP6fr2scgsdSN7u56uhiu1cw
         K5gw==
X-Forwarded-Encrypted: i=1; AFNElJ9QrfB/rVxQ1T61Qdpr/S+yta6CRASsFjGPiDpbvN5AZ5ms+Y/wAN5o47ybbOhT8k5z6srtjyQQ0Q==@kvack.org
X-Gm-Message-State: AOJu0Yy2955zYNyt/usLNp/AJx4D/d05LPCHM0A6VlVypcd9/Cytdy7j
	IzvTGMtv5lp5Bzbl5T6YqH4PNdU486btPWGxYjRX1SzrZCsvKfT+Q/HQp/4kdov/r+BKGcUs2Lg
	t1wtGKn6RHbLR9r7nGzOk0hBF+u3mkWsw3pj+RvVS
X-Gm-Gg: Acq92OEK9P74vQGzQ8vyGK36SiJtzcrApCV1K5yAe0XrMzV3b4A4ZqSGD/+a1wKbSyA
	HsX5PpWtMKoFcEtS6C5AOBuObSfyeM7kVKChqEEi63egi0CpGMP/oSmDwfCFXT9AmL1P0vA4B6z
	dkee8g3jEDTG0ymndCQOLyKeLCbmDozrcv2FFN86+HNOkRjTTkO3+L9qqplS4BeQxv1rzkOlCs4
	1r8heirQqSasluEWUT5yRO/EnM6PTpHsORblKz3XBcRN0Zbum/W5vs3OjrdCWUCATbfzULyB1Sq
	MySGVh2J5uiIJTq/
X-Received: by 2002:a05:622a:2d1:b0:50f:b69a:f4a8 with SMTP id
 d75a77b69052e-51644c205a1mr4455921cf.7.1778720281321; Wed, 13 May 2026
 17:58:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
 <20260429182000.93887DFB@davehans-spike.ostc.intel.com> <af4dDky6E7DjV-hr@lucifer>
In-Reply-To: <af4dDky6E7DjV-hr@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 13 May 2026 17:57:50 -0700
X-Gm-Features: AVHnY4JobshR3fENv4wNjHTrUx0cd27qjFdccniHbBCDYk_kC7_QeP9bR4TxfX8
Message-ID: <CAJuCfpHwkJCjicLu4gZ2US+J4uy7UGPAs2RX6c=Qq0y6Bu9a9w@mail.gmail.com>
Subject: Re: [PATCH 4/6] binder: Remove mmap_lock fallback
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, 
	Shakeel Butt <shakeel.butt@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Carlos Llamas <cmllamas@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: npmfkqj1z5rr1bxq7uzi4ytqjk5r93do
X-Rspam-User: 
X-Rspamd-Queue-Id: D33CFC0002
X-Rspamd-Server: rspam07
X-HE-Tag: 1778720282-391938
X-HE-Meta: U2FsdGVkX1+M2NzOV2M+jEzf+ubZa6TOCFHonvfNUqLPiWV/JnYMxx0UNLxkwMHgBgC9ZpjqPfKLpwCPhAcfckhfvODfv606dXYcG3v1DsoWGFvrk+hqzMBVjMzEPZF0ytg/B5TLONuju/p7KpVvb1NjPWQVJLtNkLX7YVZu7LGstppzl2o3pxCJpwjSwB5MGsfk38bnXmVJM+k5GoO58SDEIgXqDkSPLjAcWXtTUPiYnHebwSGBZSMcNk+fAPogYRfo3fGlV80WGXvXd18WnD8E8cHJWvkrQqUFBnNsyCvo7VEOOA7M0Yld9daSYuojWL7/R+sE5C9ndUMhsEolvPhcKHR7Q37xLcrjyUGvdabZzWGtVB4huv0FdB+M8JT/DWayc9y1LMMGvD7sJs8JV5WMvtLV447F2EAhJiA7YuVWS0HIu+TJQoWBb4mox2TdqD6Zgdm28ATF6TSWn0izYsJkzUKpuJpzWdvQhr0Gtyj0vriESwl7VYhcWKa7kdj9wZiLFEnuuxnoj7Tt7EVtXc5zf9OMg5PSNMcpd5uysgbgJJFKmm+MHUovl0/UgoQnZFvcgj0byHsuDE+4DXZRj4U18W3pYn22GE3PaxA8CfWzS3ADCPPiDncymXpc/lFy+83CaZQw5SUDrlCJpZzXqxQPhW4TXALhnEImbDGKAgOZAiaiDDLynQzdOr8r5S/99+1GhIYcg/Ttk07Sgq2GBD4mBFaubz0xskIA19NfyWlKmp3rok60GDFvKEZwbb/xx3VgRZlVZcYFf1OyGuOyqhMjazGdJ3NGCDLR3fOH0nCGoV4kdINaJQwTwdtjpGdI+MtLDJg41ekPranEVNz08hL1a10WaQ4w90uaih99hVHj4bXsMSU/s8dbfu8VR2F8IxSGJS8eoCyD3m+AZYEVscYdm0R9ipJDDw/DpFbJ4zJ9tGZ/mlF8H01UW8lCsnxuFB9/URzR6RceBRBAY+I
 RkZof8b9
 2uG7YlN0nNN0alRkYVSG/EQtkFuf1rYFz7LEKdWFICTLDrJPsLoiVjX6VItIxhYU/YRkHW8OzfVHSGO4ambEXc29kT4hyrbVcVehhu97n7nW2G0xBtksA95rePtQYDskBkQ1yPwsejhnS90rJshigCJ1yI2XGSZ2SOqLtUb3dm63vCYpdbfGUN6X6wpbCNZiA8D+e78vVMVflvl35IikwrKZ6bCHkAw6VnLlb75yl6wBynJW4qUa9pO7RQBsw+WMQcO1rIi+jqI80468IyNbegCYnW8jWphy+gMrBnVmh2LNI6449ixz+h/UjcoIxiJVJ89upIKoWm8gyD7ICruaIOEs/yk+tvYO/7VNOi7F++g04N6YP5P1ZwVemWQmSbW7SC4mrOL1Teij22StJLhdnoGSkvZ5qh3zPcYV1fmCWC+7v0FTwsxdNGGzDE3gV0Wvy8H52alOMwYtD9QZ5KB+aIQHzW13WJfGtkd/9LyOVumbwLNL37C5HbazMFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 8, 2026 at 10:29=E2=80=AFAM Lorenzo Stoakes <ljs@kernel.org> wr=
ote:
>
> On Wed, Apr 29, 2026 at 11:20:00AM -0700, Dave Hansen wrote:
> >
> > From: Dave Hansen <dave.hansen@linux.intel.com>
> >
> > Previously, the per-VMA locking could fail in the face of writers
> > which necessitate a fallback to mmap_lock. The new
> > lock_vma_under_rcu_wait() will wait for writers instead of failing.
> >
> > Use the new helper. Wait for writers. Remove the fallback to mmap_lock.
> >
> > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
>
> LGTM in principal, though again not a binder dev so just an A-b :)
>
> Acked-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

CC'ing Carlos to keep him informed on binder changes.

>
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: Vlastimil Babka <vbabka@kernel.org>
> > Cc: Shakeel Butt <shakeel.butt@linux.dev>
> > Cc: linux-mm@kvack.org
> > ---
> >
> >  b/drivers/android/binder_alloc.c |   17 +++++------------
> >  1 file changed, 5 insertions(+), 12 deletions(-)
> >
> > diff -puN drivers/android/binder_alloc.c~binder-vma-waiter drivers/andr=
oid/binder_alloc.c
> > --- a/drivers/android/binder_alloc.c~binder-vma-waiter        2026-04-2=
9 11:18:51.307654829 -0700
> > +++ b/drivers/android/binder_alloc.c  2026-04-29 11:18:51.310654944 -07=
00
> > @@ -259,21 +259,14 @@ static int binder_page_insert(struct bin
> >       struct vm_area_struct *vma;
> >       int ret =3D -ESRCH;
> >
> > -     /* attempt per-vma lock first */
> > -     vma =3D lock_vma_under_rcu(mm, addr);
> > -     if (vma) {
> > -             if (binder_alloc_is_mapped(alloc))
> > -                     ret =3D vm_insert_page(vma, addr, page);
> > -             vma_end_read(vma);
> > +     vma =3D lock_vma_under_rcu_wait(mm, addr);
>
> Yeah this name is definitely iffy haha!
>
> > +     if (!vma)
> >               return ret;
> > -     }
> >
> > -     /* fall back to mmap_lock */
> > -     mmap_read_lock(mm);
> > -     vma =3D vma_lookup(mm, addr);
> > -     if (vma && binder_alloc_is_mapped(alloc))
> > +     if (binder_alloc_is_mapped(alloc))
> >               ret =3D vm_insert_page(vma, addr, page);
> > -     mmap_read_unlock(mm);
> > +
> > +     vma_end_read(vma);
> >
> >       return ret;
> >  }
> > _

