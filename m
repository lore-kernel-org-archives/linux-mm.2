Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E75D8CD37AC
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 01:01:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34CEF6B0088; Wed, 13 May 2026 21:01:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F6936B008A; Wed, 13 May 2026 21:01:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20BCC6B008C; Wed, 13 May 2026 21:01:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 102736B0088
	for <linux-mm@kvack.org>; Wed, 13 May 2026 21:01:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A21781C042F
	for <linux-mm@kvack.org>; Thu, 14 May 2026 01:01:48 +0000 (UTC)
X-FDA: 84764223096.13.BDA112A
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf19.hostedemail.com (Postfix) with ESMTP id B0A0E1A000A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 01:01:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mMr4yqTJ;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778720506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L/WigXmPbnvrA+e2yTf1aoC90GmCevPGjY6L8srO7K8=;
	b=tsriYvLhxkbGWbQ8J1Ll1eFZxeV/73rr/0s75ZshuSFDytv7MbaNmHBeZmxV++54mq/2ZX
	mlFzV9vO7hG79Bi6Rw4fGCXKU/O5lXgDXdLCbKiox4nfuUG+hmo5lonss+ZFCgNCMOavmx
	q4qDa1yUYJfmwzmeZGhYr5/ZnIVAVqA=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mMr4yqTJ;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778720506; a=rsa-sha256;
	cv=pass;
	b=xnOr9FZab4+vocXcZAyC1LSKJIx/GzH1pChTICBnSwbQ79uF9eraxDrWA0mm6T1vFPK1Li
	csosdKoJVAtvo4xfB1eaxR5MC0J14arOPv86hPu3EZy0qpu7auJoomzCR2okEUSoKJj9Lw
	ITxGAhzNmqTVwU3TcPXTwd/vxhuevMk=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-50e61648f10so151791cf.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 18:01:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778720506; cv=none;
        d=google.com; s=arc-20240605;
        b=EJ+v4FVwy1tTUl5LxRRQHR71KVIaEKG6ozk48adwa8tehJnNySXMfcmg5atb9JwjOv
         rUyBLIL/eMXKDpP4EpNCyfngf4xY2Y+khZy7e1SHhhMP2CCxqPy4LAgD5pHj/e+WyoBK
         6xHFAcax5s0JZ4Jw1yqFj6WmbwnyZcpIM/s2+MnnGJn+fXXTcC56p03DzN9xCxVOo0Ei
         wDMTBjPMVF33HPUmnLlF8baDbMEFOwoR9imbR167OxsHrNN93rPX1n3vfLQmcAWunC99
         ZVmLSGoxhN2xY1m+r+8ZnOG+DEJnwVN0ayBxa46nKg2kP82LPMHBU/lYFg7YaSUxoDOU
         JJmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=L/WigXmPbnvrA+e2yTf1aoC90GmCevPGjY6L8srO7K8=;
        fh=FCBEkVgSTdRwB+6NOmJIsOKKfHyVwbrrtqhVNbSKjVI=;
        b=KxExBjd459cYiwH0u29SliYdasqohF6L2CxiegMKUbpctZLokpHn7FH4dbyfEKkh98
         BvDYNKeY+xPrdH9w9jLz0c2YztThHsIKZB8vPtFFVxgq6cmuDxzNe3fgV4LRGKtiISpu
         rDYxyCuGEo10MMKEBoBrRq1Zx8o1Y6mVSumOOb0L6xiw4fZeSAMdNPILvvtzLgPw9xNQ
         7TNWK/JYZkkxLTkoftjdP7hQvaI/MOmTx/7r690Nf5S74j3ReErMqgl7xyYdknwR1NET
         yXKU+oFcisvdjXnwAXMsL0pAXp1UQRdhXiQcEVu5Tpr0Phrk9/JONStvxIjoTpmrCYoE
         ff4w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778720506; x=1779325306; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L/WigXmPbnvrA+e2yTf1aoC90GmCevPGjY6L8srO7K8=;
        b=mMr4yqTJEe+5mxcLJiYLYZsKQXWUwU/mxvMDVno9ESWxx6KgvZeSIfpMph5r2F03ts
         0e2Nj1kQpuLlrG1jv7PcSGQ/vNkKGlsFuQbM/QcCIYZswwWqE43HqJ2rwVyVyqdG3VQP
         LOoNbZuY8zLIobSOY3Hvl5KA7n/1qzNcW0XsOhHFqH8xjEi1rBxjgLW6zLzVJVKDZRkm
         Y3BgGiCCSFW6JyC0nNQ1jj8/x8x5kcWDcOmTLgUIO1CFHcLMIlbbm8Rs58eZaN7Loor7
         gmThcgRg9GpbAA1GKUL9B5he7UGBcFwKZYC15dTXb/d1aLlusvEC2U7o6siIhtdVUtso
         ZutA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778720506; x=1779325306;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=L/WigXmPbnvrA+e2yTf1aoC90GmCevPGjY6L8srO7K8=;
        b=Z+t3eyATrbn+Goqq5G881TnI+aFuxH4hRN4N+J5OnefezS3Govqx2qjWHKHW2I2HiR
         +n9PcKG8mrK6KeTzowRxzEbUlrDGmBQmwQZCknUwLWlufwnO5qNpPok4PPmUliEI65YG
         M6cup3FvsIBHhPD6Cm1WkLJZHdHMmd1cTNRpqiDffxT3tQNI9caCqX5kAII+eO8d4gdi
         7VhOtx8GLx3UB7qyEBCm1s0q1FmhdJchP4zTKoLjWB276XlHqJlfmUttYLc/NOD1xeTm
         unk4AXhC2wRa/gKLCU8VkEVktsbCTxZD+0G1+CmhL992Gmr0BUcq70BiW3ZPPJIhMAJ2
         Xt8A==
X-Forwarded-Encrypted: i=1; AFNElJ8xbefkWLICmt+9GBjQFvUAF2dy14BDIwaqge7ipo2TVMu0Y2AVIEz2x07EERNOoS7o7b9/F4fZMg==@kvack.org
X-Gm-Message-State: AOJu0YwdJcI8TgaWlEgiyHF8yWq8G4rXB7bbieLPOwu4tKbeiwhgZz9n
	qJzktX2bFAhB2kNWqahIsKyd+WY3GA0TMatTf3cqimDYEr4EKwwtxpKCZo9S6jxBS8HEbhzewxd
	yN4+u6Hix9dJKG9Tgz+s2NA/FL3hUe6tTFl3YvyKD
X-Gm-Gg: Acq92OF3BaIaXk5O4Tumz3zUnBeVtwJ7C4wwclxQovkG5JAEbXQZ8cSpgCaORQu7zkV
	OChZ4LKKljqlAeb4wHtH9IdNM11RbVIY3w5+gUHL9pwOKicFH0oPOm9vqluQyWz8ZX8YJgWe13C
	pmDWjCp7qIXo41F6yJxu8eOWkWQhLSltacpvFHxoDoIYwcq85AUcfBqkmU9Qsa9kcVCe9DZsYvp
	zNn3Z65aanydlXf1Tblfo4ghIQnPvvkqgXifMDgjIlT1zPYrvijcnZXJzCYh8RA9xUR7G/BB8nl
	6AKTwq1I5mtbOwZUcL8UGDsrQzI=
X-Received: by 2002:a05:622a:aa44:20b0:50d:edb1:6bd1 with SMTP id
 d75a77b69052e-51644c82ec4mr4196821cf.13.1778720505261; Wed, 13 May 2026
 18:01:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
 <20260429182000.93887DFB@davehans-spike.ostc.intel.com> <af4dDky6E7DjV-hr@lucifer>
In-Reply-To: <af4dDky6E7DjV-hr@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 13 May 2026 18:01:33 -0700
X-Gm-Features: AVHnY4I1eoueleC_XhH7whFyCMs8hfDiKEiY9UI5wPu9QKk7C3GFo8te4B523Ig
Message-ID: <CAJuCfpEca=dpfRSX5qd+M2Hguwd8XqC53L7dd6oG=4SV+4i5Og@mail.gmail.com>
Subject: Re: [PATCH 4/6] binder: Remove mmap_lock fallback
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, 
	Shakeel Butt <shakeel.butt@linux.dev>, Vlastimil Babka <vbabka@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: B0A0E1A000A
X-Rspamd-Server: rspam06
X-Stat-Signature: 8rioq96ma7e1k9qbyo71phpmr4oi9rej
X-HE-Tag: 1778720506-947359
X-HE-Meta: U2FsdGVkX1+NIo5GW1cdxe8jpWivuV71lks6eIXKMTbp679+Crxy9fAhoELz4B0aEerMOFb3bSBeBe1BBKz8U9uQVCd/VgDGJxaj+4xol1nGR3QoiDjY8jZUvV0RX4ayUeUmVEB4gS8otm70f9Leu5vXSSDsK/YcqYao4sU3a54E7ZzRTP0ka+HcKU/FsydackRNig8HHLz+C8OvXO75SMwk3L7+wssJW3E9Usw0X7t36kh2s5wxLYulL5XQpVUEfeoo2EiOV7FFCn+dZ44zUDyAWCiEBGj9GeWWKxMRySCOzq6anqO3ZvSpwEhSotVr4l0iDnmKggGr0o8UWEuRCqdAr8y1avwOr5Sn3qNwSdriyx063SbJW6JkV3E7QXrEbfvfbZc7TH+9R6YFd4/1FdJ9xqKa0paK2Zr75JZk1zYZsnfxYcdrMadAwPrQy/LT5QAbn/Jkew/0gM6RCjAlw4qynshf50EHYF9n5FQpsdMcvtkK4WLedT3tc3GulsoYGXbX0+PakmCpDFs6CQGwfujHx1QDnZQO/ouNjkkB6Q8GOqQJvoGaCfbO6UD4uXqY7Wn4szGyYKIeLu5NSte/xINb//LLrHD9JkjHecHNY5V9wNieaa5Ivs91weTqX1GiteZwZiI5yp3lqionp+LoX2mkSHRICeDW+kXH1PsUuVcbeL0uVlyn8LxgyheS9TRU5i/Z/VcBKBuStIGOjNKTldxpNtmlmTeK9DutVDKXezASq5RT7XwmDNMs/3abhwLaR3OapaXTiFnxhv4MtDwNi3x/1f4GaRDJuKfZRQFloNM+8XLvXUa7/+QMw8y5fVJHaA7b3NXIJJ12ZCShBAYbpUOIgIMOI5A4PeHRqLAbG5TGm5ncmXPBWUqzkEdgRt2PP6t3a0hRVhPylZFK9rY7tZ0ZTWiCyLE4ks+ytlPxRZoAjV/tnlp0h9TOMZ3Uy+vkSXh4dE0KyZiQEaVdvK7
 W6ylycoL
 jlKVX3vngZhsIRbSR842lMHMOTe4sAKNQQGWk2TvYmtH/Oyx6mXiXEnJhSdvsofleqX+ohezOWM1guZZkcramJ/Wcbql1xM0rc+FG4mFAeAmaAETrJJeRv5kwmqHVxALW0xl77RPQwcoJFRnuEV2OsK2Stpc0CZ1p4SLiJmAifkVw+iBfJpxuN2RUKEwMl5AChTOWNRNIi8Xz2fZWTIafy8sPL+nSkc7UuiTehWSuNByWxf5Qx43pNt3UpeLQf4eUfRg/Y4pJzOVFDA15XlJyEb4xm8Ru+/0V25forgD1xQMnT4moc6trZiNPxZR7gZdUabSTBPgTDLt7l7ZuajsQv8ihNEc0cV9HvKvkGMJjw49MUMOzVi+XxUXOpv8axM3GLIc4wo+Q/O51ywPaCa3asz0qMTnQY0iFg4+jb3yRW+/Apnphq+SQYDnB9V3NUU5UO9JwbXX5r7DrqqLw/Yt0BYgi9CzMZ8DIbk1trbiR7+JXG8xbsSHK+x24TIFFCSaRV1S3fRWeH4X6/gPGSZRnc+s/jygosvMF8OlVH9yS/EVSFGGsE49WsucmYQx5QOVnXOgVPsuD+jhnNx0=
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

How about calling it simply lock_vma()? It does not always lock under
RCU, so "_under_rcu" suffix becomes untrue. I think the name is still
available...

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

