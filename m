Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEADFCD5BD1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 17:18:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAD856B0088; Tue,  2 Jun 2026 13:18:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5E5F6B008A; Tue,  2 Jun 2026 13:18:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4D9A6B008C; Tue,  2 Jun 2026 13:18:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B41896B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:18:10 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 74CDE409FD
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:18:10 +0000 (UTC)
X-FDA: 84835630740.20.787A5AB
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5BEF118000A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:18:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=P2M37+Ro;
	spf=pass (imf24.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780420688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xDwFnt2lpR6e1TlOQ3Hpe10nl9gubFxS4NYr9ytPIQU=;
	b=fxsHWpTVbX6AwNnC4ftBJ5YcUcvSGCSE2LEdiseTWTcNCVzoyWfb5wPaQmqmYyS6qcVnwL
	rlOAo8Nfz1xX3+kicxEIX44cp+ULx7BZFouAOd2keu5zJ1vJfCPKHcDpQLK3PKaqa3jIn1
	2IJWxYMVcu7xEORKCY5EgobRLxd3pZw=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=P2M37+Ro;
	spf=pass (imf24.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780420688;
	b=o5r3b6BMt5nFGu6bcN4WsThVfSLiGooqmLOM/Mj8k7XRe2lhrpAUHrxDIN09sHJ0oTE+nV
	9q2JpSp4U2V4VgMP9b/0eOg4lMnGe8sXm8ZtSjrKokk0bTyhR8t9I2TlHMapY9XmCzbYBl
	bFS0oxYEBsQpPEV1EIGz/rmozOozXv8=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-490ac10e337so14464965e9.3
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 10:18:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780420687; cv=none;
        d=google.com; s=arc-20240605;
        b=ba966eF4XYTA/3XkVmH2buhlq6esAOznjyNZ3bbknnIu3s4jmjF8h23VBX42AAqJrD
         LngxUKODB2d+Bv6ebvZUPRAMFFgagMBz1FLH0+EjcnhuXy2LcuEayb/K/0OwKtDNbKMz
         myCoIWIb7uZqTSn6D13wgrf/p1rwRKq39XL7gzbdEHJwovBGejF/Xcc8OE7pLGaaKNHT
         1tefnfz/Jpu2bLNjCmUjtYMbTUqNEbdiVInBAAdEZi6zwhdD1ERV1ODWqg9SvA9n6qMn
         oHKItMMb3x6XtilIxVMo/iIST7LvGTYcSzgk54FEqwNwy54QtrH7Ocl5XNDvnwaKEegP
         t2TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xDwFnt2lpR6e1TlOQ3Hpe10nl9gubFxS4NYr9ytPIQU=;
        fh=7Hvgr/FLbZjZR3y+Hq/UBcBue64eDSsN6rpGSlprT5w=;
        b=I4kqO2xB62mYOaui8OnDSb2ZBQTeWFhlV6u9692aBYL+niSvB6ZyZWWBoTd4wMxcRb
         NmFPnfUokMiRMUo1FSSeJg7/zt6BGJi+WFg6vcU8uHsOBrXgi/UigKVG9ula4gsOvo7c
         omyA+B6avABlYcwtaX+XeBdEih439ELFg3IPSlMuyKqLRaB+1AUIaKaKqInzt+/yjCE2
         a3TCHRO9Wvu7Uk9XrDKucBFSoK2mOmrHgLZAI7ISYj+nT2siPp703l3ni/9KAUGre63u
         l1cWsp3ZFdOjEQBQyrvIoZ3cC81MofoUwVvq1EHd1RR0FdJpu2yNwlddnuRgZFHST/zT
         03EA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780420687; x=1781025487; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xDwFnt2lpR6e1TlOQ3Hpe10nl9gubFxS4NYr9ytPIQU=;
        b=P2M37+RoXAYxMk2jLPzraO0QPwYQlFGltwctBQ11RYye7/VFZPQnqId7rFt1mF/jZM
         J7oFRSjucJF9vH57PD6juqaODSAT7uGyINnH5O+uPogM/NAHnyi1z6UdWv2EOYslTqF6
         T4wd8YyKY/pntYphHhlMAKItzMleLRQ51578j//u+byryI9GeAPSOD5ESFr88fb8HNkF
         nLYG+WxTYIeqw05rGHXBdGcKZbbtwejpbmn1ohIfEMRP7QElXpY6fgJieOJNMAloTipw
         yfVMiOYrfmX4FtGuoqaluEGUSZ/uvE27AJgUkMBp+ssygWUf7rOhlRZbXtGjXxNNvLch
         dWTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780420687; x=1781025487;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xDwFnt2lpR6e1TlOQ3Hpe10nl9gubFxS4NYr9ytPIQU=;
        b=kfZhayp7B9EuLyoqobNULLWaA1WCLZgeEHacZQqSSJY+StLzGow93a9/Kjy5tdMa+m
         A0hWDT16e+bSY5xenYq//2ARqIxzAXI5Zw8+TYJ4lLeLGnMTK9CE2LTM9gpi+cK94kh2
         5vD7KIW7To6ran0cd0EER0+qW0mHjDDq5YagpCr1ZHQ6NKDMYe1LO4cIJ0rFUZad/KpJ
         UhBFwCiO+zCOf1n3koe1F9XBwmmX89jbxIRR5iwbBMGV1pX8xxSos4vg9RH+fwyU5QfH
         YF5sm+zAOqoege1xeP0RkdhwAUXAKQw7fIPMGYxYct21xK2S3D9lJ40t1dSE2Pl5xpoP
         skNg==
X-Forwarded-Encrypted: i=1; AFNElJ/0d1OwhMBfITSR3kdWkEhXbjqaXY7mTBeyYooHQbCW9nHAPllXe8Gg2JbUI9R+TA43e+ri0gr86g==@kvack.org
X-Gm-Message-State: AOJu0YxeM8SnazLXBkY2nqzMLBnWzekDuOq6BXUwd0IxZH4XZJdL/P6h
	puSQMnh9XQh2sES8zQIdfy5NuoBH2q+8Z+KvfF5T0yPfrd2I9P7lyz8mCXWUClpJjQSMOCB0mQk
	RoQu7w6HKa/2PUdRgQuvKUELIpaxi5w4=
X-Gm-Gg: Acq92OHWC8TOFQJhO1/f1Ihp/N7dErVcSHZSt6UGmqqROxlRDzTHv6D4vyYzHokpJhf
	ewaVIhzgR+iZIpbaBhhakRUKMQiZzNDmJWY1vhLMu+ibkBK6QtclXh+x0hDELlRjHekw/3z9Qcw
	HRH5k4WHqOIx5F8ruMGr//YfvepwfF1Bx64pWE0780o26T8POo9CZElqwzFYhxHSjqNAvQAmnYm
	4RoC5EIuMS78jmxkEsCyCUGE0wZ1RmlbkAwUlTufQjb52U4qN/bhNHoSROAefK4dY0baR1OreZB
	boJQT0tvKPU51aFMTl3xA6+CnStjqJC2tRbpMF+gf9x7VMKCOExpWXXj6vIOa0UM51tPnl4CL2l
	MUw==
X-Received: by 2002:a05:600c:470b:b0:490:aef9:aa3b with SMTP id
 5b1f17b1804b1-490b50b9f14mr10005675e9.32.1780420686539; Tue, 02 Jun 2026
 10:18:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260528222014.38980-1-alexei.starovoitov@gmail.com> <89920f87-3638-4182-aac8-23b06784be35@kernel.org>
In-Reply-To: <89920f87-3638-4182-aac8-23b06784be35@kernel.org>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 2 Jun 2026 10:17:55 -0700
X-Gm-Features: AVHnY4KMH09YtzIOxEyKEisCim5jPQOzJv_tH2MC0NSB9YCozVfyRLw49W6OGGk
Message-ID: <CAADnVQ+Pv+-Eb1qRrf3r=3WTZzip72ScwugX3iMSp0q1v+=-5A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Take mmap_lock in zap_pages()
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: bpf <bpf@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Eduard <eddyz87@gmail.com>, 
	Tejun Heo <tj@kernel.org>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5BEF118000A
X-Stat-Signature: 9hifp6gnxi49d335ehp7cxxhs6td9aip
X-Rspam-User: 
X-HE-Tag: 1780420688-953203
X-HE-Meta: U2FsdGVkX1/nEkl/NkQRuVhwpJ7u4pR9GuFn6Paa8MdqDZKnFBD7ngQS1XvfM2N23aYwhZt4oPKQovQfmOElQ1Qkf9LjvqPliHd0KH+c2ZJ0kjR1ME8cm8O0Ktm/bFF9cU61oi6aGXp6+J5D4txtDP9pk8sLBck+FEEniIkKrwtBha4UJZ8zLkrnNfGJL1qLgomwLGrcjm6wLtG5X0Q5Tp8povDP589wmo1rah2RXhfg098Ep38YVGVXB35klsr69RBazb6MiRZ61oFgtd3b5R4f2Xw9VA4WWpBYtN1l1OjQ4WOv55ics3UCyV2VMIGxgI+ftAPIK8WpgybX4zAUKoO7R50VwhQF1cKEsAdtrV6YjfCUQSuO9gFzfEC9haMrYvaBGdXedKTzbgTXdcgl83TVSj7AxQIcDPYsalcyQUqbt+QhzBlGfoHZhDHXlha/CYKjfPM6QE0WkLoDyj5V8P7Fyx6cIpBR6CiYZi64eb7XpMls0kRTvk4YIp88ywxTDMIuAJslKdm15acHi8KoidUjpzpPOEhIW6EnP2KUdXbS0h7qbeVtmDJfumyvjuf9FsXPDRdHcIuF+BmCLkjhp/mNCMa7Wt4aSfOFitIkTO8/8vKXyILt8WZM9zjkIVbDUMhEjZSWITiiCZCk/0sAmlqiyBZwNzgzLJsMn5OlEWlAS7KJfaC4kw+l+wpNABLbtfcLyZajXdgIbORQBWiDfc+8yT8FdxWj8Pks3KCa+2QaX3LXDGTxXaENDz1AqNtR0I7vc+3NFt7XHQukI5f3w2+kRkmq9KaIrYdJR0yZdskMMTpURgVHAK05taywrdQAd/YkhW3P8oyNgTIMElIjj94AmVWn8jVIry1Lpyh1xOVOHpLyF7ZJBjEdVC4km+JfZxhryojU1VNrPTEhEsWjpfWYkNBcymLBRjk2b6SfGJs37L2OGYbMuU5HziKKadegv296JSKWBoffQ683pqe
 g/X080rk
 7ByhYUDDrS+P5VzowCYMo3Dq7fR4QNgP8W3gblqWPiKsTIiu+U4qxjOhALSikf2i3Qx93U9U6OlyzSEgh4/lpRC2nOdV//kbnwaVVeUDdusi2oBbJo0/jL9bJeh+I417+bR9mqJufy3XMUZSQ/UWOPulZ2joH+GgJ/aGXDvqOLcNC1Gi9CH/tJsTqZhHUjxARtKg/69aI/VEj1smEvc/IK81L8ya1Hwce+oKgvOx5BHqNsekojisReOadp7OFJweRlMi5F4E+THTwYCSYoIFo85w8Rabwkk5G9XsSbrFQe/SGT9bYMfxNb9Ndeyv97oEd6M/c2CWQN2flCyDiktxvyZ+15hFsnmR+qWYIGdIZtGXovj9plS+/a8aOirQCiStjfu7ly9+znuDFZL3eglhO/4fD45imqPHMwWsGM19gvq0UIAfNqpfG0s6E+u0Txk5yrnr3ACk8kmdQmO48OaqzwHH4OSnOdfTlii3A4IKK7sOLhy2VpJXVYCK/7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 8:37=E2=80=AFAM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
>
> >
> > -     guard(mutex)(&arena->lock);
> > -     /* iterate link list under lock */
> > -     list_for_each_entry(vml, &arena->vma_list, head)
> > -             zap_vma_range(vml->vma, uaddr, PAGE_SIZE * page_cnt);
> > +     /*
> > +      * Taking mmap_read_lock() under arena->lock would deadlock again=
st
> > +      * arena_vm_close(), which runs with mmap_write_lock held and the=
n
> > +      * acquires arena->lock. Drop arena->lock for mmap_read_lock().
> > +      *
> > +      * Use per-call my_gen, recorded in vml->zap_gen, to remember whi=
ch
> > +      * vmls this invocation has already processed across the lock dro=
p.
> > +      * Hold zap_mutex around the whole walk so concurrent zap_pages()
> > +      * callers cannot overwrite each other's marks on shared vmls --
> > +      * otherwise call B's mark would make call A skip a vml that A ha=
s
> > +      * not yet zapped for A's uaddr range.
> > +      */
> > +     mutex_lock(&arena->zap_mutex);
> > +     mutex_lock(&arena->lock);
> > +     my_gen =3D ++arena->zap_gen;
>
> I was confused by that as well, good that we can get rid of it.

get rid of it? As I explained to Emil, zap_gen is needed.

> > +     for (;;) {
> > +             mm =3D NULL;
> > +             list_for_each_entry(vml, &arena->vma_list, head) {
> > +                     if (vml->zap_gen >=3D my_gen)
> > +                             continue;
> > +                     vml->zap_gen =3D my_gen;
> > +                     if (!mmget_not_zero(vml->vma->vm_mm))
> > +                             continue;
>
> Given that we still have a VMA with a valid MM pointer, I'd assume an
> unconditional mmget() should just be alright here.
>
> Or am I missing something?

exit_mmap() -> vma_close() -> arena_vm_close() will remove vml
after dropping mm_users to zero.
But parallel zap_pages could have accessed valid vma and mm pointers
from vml list, but vma->vm_mm->mm_users could be zero.

