Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 298C2D6CFA6
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 22:12:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4575D6B0369; Thu, 22 Jan 2026 17:12:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F72D6B036A; Thu, 22 Jan 2026 17:12:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 308146B036B; Thu, 22 Jan 2026 17:12:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 20E726B0369
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:12:41 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BA8A71A22DB
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 22:12:40 +0000 (UTC)
X-FDA: 84361000080.12.AFCD32B
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id C2BBB80002
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 22:12:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0Bx+I17S;
	spf=pass (imf02.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769119958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S0Z4UtmHMtrm22Dzvewt+n+aqxxbFiEfZAYYSqL4AsM=;
	b=IagoMkt5C0NwSLGDOXFzZY4i6xjV344DRZWnjO+Fhz2XyMmRU65llE6ACz2ISK8zkub1ES
	7uvedE8S7VJapr1Br9Gy9dA8a7zYo9BdOADwYzUP6BnUgoEG4ftjLfJCSyWZlaW13zhE03
	02coKDB9zVe0ZGirHy1XDr4upn/RYn0=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0Bx+I17S;
	spf=pass (imf02.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769119958; a=rsa-sha256;
	cv=pass;
	b=X6L8qDesYVEYiVzYyE7y4l8RX9t3xK9tcMT6s4GJiqj5bfuyUmplaWLziTcQmsjhB5rZjP
	zs55UuI6t5ubSwIXxuXTrMJwbSUFYxrMWFfZHbvChoss66cbB/q+BbiLK/huuVFdWa6ffB
	7CJKj9Ho8rYJUUGqiYdnQsduL+k5bp0=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-501511aa012so158681cf.0
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:12:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769119958; cv=none;
        d=google.com; s=arc-20240605;
        b=JttWyqs7kXkD3wvhYHdgoJkZzZincCv9hM5VYr5lpzqRoBzZGI74F9WylZ39xzpjtc
         daPhoK4S3Ib0EqDq/08NItps2jMsOe74tUVzryHhpGbQHuoO5028C+dxLkCvB1b8bd2q
         tR1Z8snhNW8+nVcJOsaUZGQ/hFRGl0Rre8FiHdPZSNTTuBLMSYoD85Y2YWi75CKlRiCv
         uBBL1GbZ5vFFoymh7StIefmiuIsfX6rDn+4ldBopbT5IR4Itz1710MX/6yq7VSkKw3Yo
         KQ6hXjnQdsHMUO5F2ZKjgWQeboXQk9DxnNfHBRdFa+XHQr4fVhtcw1koDPQhYZzNGUey
         4RAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=S0Z4UtmHMtrm22Dzvewt+n+aqxxbFiEfZAYYSqL4AsM=;
        fh=0vJDVfG9BXW+sehGCwyYBAJsbixOfvyi2Vvp87Q0IWg=;
        b=LHfdn6mHghfnRNSciRv7+/xeD+AWhEj8c/RgLifyzBbE9BBI4vk+BpeaCBIZUWjdU1
         PamJrfyLcsUG6BxKkd0Jjdz8C0sn6ZhjI/xArIE20d9FDfqJYqUlNKhX0Doxf3nJ75WX
         am9ojsBH7zPz08nD16R8DpeKikqETVmUfiudhorx5WTYvOYZZoxr1bdTdwFPMipirRli
         JcV6JHD3GUoE7oYhKlTQs7Y36BlxHecKildkHqdQx4wWPsAIG5eF7MinEhcfgyNK3sL5
         fysKkuUmx5Yxw3hopF2cCM+c2VXvhSCYt31MzTUtAj7jX0+4GFv7JLKdKtOv+DwIjTDB
         dbIg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769119957; x=1769724757; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S0Z4UtmHMtrm22Dzvewt+n+aqxxbFiEfZAYYSqL4AsM=;
        b=0Bx+I17Sz6qpIGAAPDF0qM50d01obsk/NG06jfvi5MQcOqsKY/uXRpsHCwYSEzfzOX
         FAslhfUYCqNySPxnMgm8brNyLG1MXkkvqd7ffKiYMyKaZO4okG7oZTZOLlWo08OnHrSE
         P+wXQQLm+GknkFh1k29H7Dpf8weRYWWM4o/+hqNjTL0gIS1Xg9J4JmX7376IvbSEtHkk
         iJ6iIiDzP9xlGza0C/EClhKwu34o4HexfLz8cb5QvA8oW1zZoOsEnLCXW3jzMF0svzaN
         HGtrzN1n02ORl6CwOTlJc16Nu0n5GbG/EMUsvcRTvE0PcOKjU94Zrj/7HmkKaHJlDz88
         YfJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769119957; x=1769724757;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=S0Z4UtmHMtrm22Dzvewt+n+aqxxbFiEfZAYYSqL4AsM=;
        b=UA5nKOajTS5njBDumEFmtEShCPsW9IbVM6Kuw6AWwdda1bQuEOSeM1TP1hdPQFxlRk
         Zdi/1aocWLb45RdJIz6t7lUzALBccBeUCraCMRSxw4SPrYhB/48glLDQTRMlVKorSB6E
         +ULRPARYdgIJW/FAs8+JeCDHma/3TGbLUVptzPnhM7r+qNPCp3DCi8EAL7z9NQI4Zuvo
         eKda70bJ94W5LHuhB6DlzpTKStFVuxFcF3GAfWYiWgsslRaQDA0gABiJP9LhP5CZh+H+
         cZFv7xSMXPBklmrJQsT621iy8ZgUGbFcXmk7TNEsXJCdgK/AwolWFmh/Ed3ILlj3M3XU
         doUA==
X-Forwarded-Encrypted: i=1; AJvYcCWh2/7vel4juvk/lZhJ4K1zfpzgqeOsB7+jf2pF3XWSUW+fXummP7HS+aCQeKom/K2y/Wm5msiH3Q==@kvack.org
X-Gm-Message-State: AOJu0YzHIJYUPcKkmCV+lytHr9RyXMQM3qjP9IfAD5WbMZUs3/iZ7pXE
	JuwS7i2p9m3HbNAPeJuLK9KnH4B64tsWcK1D6+c2PGJ0V+flHbjXbAALsL0qkQdXfuSQ0iz6Qae
	+Ts2aRZ2xFn8U0z7jzjt3/+OUqmVyQuYyNCRbNRg2
X-Gm-Gg: AZuq6aIvwqL1B0wfWGaWeZsBe6xDvT221pSvDoG5dX0vg4aqYtMNiGw4s0q1LlsMH/+
	Uo/norJXBxvCF6gINIeQFlaBbL69dNUI3jzaXZRZRO68CMgoQrPhb2KlFQjoJobc6TAF89sqZXG
	cwpjjN8lX/J1kDQuDHdA7c+CiOCDT1ZOeyBQzk6HPmEUlO2ca6sfnrYEOLnC8AiJv/ZMLFxqVvF
	YqobXWlBNVwBphOWlHPFJcCB5i5KqIWXLawDT1xhSzcNHekR24GyVinM4oTls4bCeTnordvvGCQ
	XLGTBAr5hR/Cr6oQulgOhBudkR0h57eNN+U=
X-Received: by 2002:a05:622a:189e:b0:501:4eae:dbfc with SMTP id
 d75a77b69052e-502f8db53bbmr1163411cf.5.1769119956786; Thu, 22 Jan 2026
 14:12:36 -0800 (PST)
MIME-Version: 1.0
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com> <43c90424ba0874a71bb7ab9d6423b3a2bf616f8e.1769086312.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <43c90424ba0874a71bb7ab9d6423b3a2bf616f8e.1769086312.git.lorenzo.stoakes@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 22 Jan 2026 14:12:25 -0800
X-Gm-Features: AZwV_QgEDRlflQAy1nDh25c_dk6-859XJWS6UBtVlFMJyyoqvQVG2qiSotUSCKs
Message-ID: <CAJuCfpEJ0NRB3vgZ2uajGcTRovKYTnrV6woSbFGWZ_LSFerkTA@mail.gmail.com>
Subject: Re: [PATCH RESEND v3 10/10] mm/vma: add and use vma_assert_stabilised()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Waiman Long <longman@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: w6duoobmwpqzxd7ycjhkwzs3gesd58ux
X-Rspamd-Queue-Id: C2BBB80002
X-Rspam-User: 
X-HE-Tag: 1769119958-301497
X-HE-Meta: U2FsdGVkX19fHeflUBl6zg+kIwxWoLCajBRcuuS4XtbZ5LHXl3Er196ExCB73YPamNsT10AcW3og6v/SElz5V719I5NqIFRUR8W0Aw6k6suEALnHQiWxFTuRwM62itpWH8rnJg+xBFFxJaiWZpBjWLsXhPIuse4cpu0cuJRiYzXJKgS/ED39qtiwIGCbwcVyUjB1uC3CHZdW4tOhCc3fEjy63XmrwoXXJxvPgFuj3eDfoHJo8zZDdygCeFA+X3oUFWh8YXSm0OyLwaXwyFk/DobI3iCVp+U3ILdOmrTf2LoNwF8jB1AAjbJzRe1yanSHgsKhxUPQzmS7ButO8sXetHasZjiWanKO1Nb7U9TTgIkTEddf38+02si4/GMBGTIGS4cDjvG2/SNXD+VfJo1GYvHzFBWSLNHn/URNUXLf4WkKBvSuha7o+rsCv1OEoTL87oTd91vZQKzjexiHY4Ekd2wogn8RyO1/j1oEgUR9u5df9B+uTdMKNq2kzEIzYufsXNt8xx1zoeP4/x+6cZnOjg7knZypgWDzEFrNJ7bf3IGLBdtRQC71H3pgxPA7dhXtxZklUN1AWNUwFBm4AN2SezyZCjtMhFVn0XYbN+0upMX7iG7iwFlKgn/wJ8H9saUwLTL2KYbF2+hqYaJ2eJeq1rLZnXpcY8wCCu2eLQkxsMBpCTejsbKHlInTd3xBzhLYhuJf0gGz7rDmCfVeAA304RBN9omyT9rWsn0/w0gdrWb3sejVMbv9lw5RVbrfpDKyNo7e79nkv/BLe+x0VMEESEKX6ZnIvEK2kFIvD+lBS9VK9Ff1ITD1HGpYy7KpgMmpG94eWtwZNScy5TE+pw/Pl35gQyUx67XcGgjomcS4c0/akvWGG9O5ZvULmedSoMxb+9Exn3OYu7uiA8gf4qx9mVQkmDXyNz6plS6vqU6KSHvy+kAcMMjdzXx4YCHxRmPoYL/pXyfJdcgLDi1bCsZ
 7GHNsf+Z
 6iBfYmVjDKcEvuHfU+cZrImgFngqiTBAQxgWw/Hax8Dm/mzh271pOm60zZv4zN9ubK+ZgYIU0ZEOF++YT3TOBlAOsTN7F4gXBpKSlqosAPfwBidrIOTfQzJZcg/0S1LuxCyP5ZqfAiKvgIQRNvo7UASfCQv6VvPv2uTKn7xfkbFI0ReQA4+4I5VXG/n2zNPkiTV5OribnbU4p6oU+aBkKcmBUxaoO9OvlvKLNsrCQsFCgseTI1vLmpsevbHyXFhFVcq5NPpmMDGcM1jFSjpUsx6Blu60bL9tSDQYcj5IGXc8s8kkVcCHxn1qLTzaQZ+6coAtRPMjelE0gQVJNKppYVaWR7ctFgXxHLAGVH41s1QIKPYrCo5XSdwvad301nicItlEtB3HoA5gb0d+p1lXNYTf7kJ84NFkNxCujNCCfu0P1qpbK1T8Gw5+4FQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 5:02=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> Sometimes we wish to assert that a VMA is stable, that is - the VMA canno=
t
> be changed underneath us. This will be the case if EITHER the VMA lock or
> the mmap lock is held.
>
> In order to do so, we introduce a new assert vma_assert_stablised() - thi=
s

s/vma_assert_stablised/vma_assert_stabilised

> will make a lockdep assert if lockdep is enabled AND the VMA is
> read-locked.
>
> Currently lockdep tracking for VMA write locks is not implemented, so it
> suffices to check in this case that we have either an mmap read or write
> semaphore held.
>
> Note that because the VMA lock uses the non-standard vmlock_dep_map namin=
g
> convention, we cannot use lockdep_assert_is_write_held() so have to open
> code this ourselves via lockdep-asserting that
> lock_is_held_type(&vma->vmlock_dep_map, 0).
>
> We have to be careful here - for instance when merging a VMA, we use the
> mmap write lock to stabilise the examination of adjacent VMAs which might
> be simultaneously VMA read-locked whilst being faulted in.
>
> If we were to assert VMA read lock using lockdep we would encounter an
> incorrect lockdep assert.
>
> Also, we have to be careful about asserting mmap locks are held - if we t=
ry
> to address the above issue by first checking whether mmap lock is held an=
d
> if so asserting it via lockdep, we may find that we were raced by another
> thread acquiring an mmap read lock simultaneously that either we don't
> own (and thus can be released any time - so we are not stable) or was
> indeed released since we last checked.
>
> So to deal with these complexities we end up with either a precise (if
> lockdep is enabled) or imprecise (if not) approach - in the first instanc=
e
> we assert the lock is held using lockdep and thus whether we own it.
>
> If we do own it, then the check is complete, otherwise we must check for
> the VMA read lock being held (VMA write lock implies mmap write lock so t=
he
> mmap lock suffices for this).
>
> If lockdep is not enabled we simply check if the mmap lock is held and ri=
sk
> a false negative (i.e. not asserting when we should do).
>
> There are a couple places in the kernel where we already do this
> stabliisation check - the anon_vma_name() helper in mm/madvise.c and
> vma_flag_set_atomic() in include/linux/mm.h, which we update to use
> vma_assert_stabilised().
>
> This change abstracts these into vma_assert_stabilised(), uses lockdep if
> possible, and avoids a duplicate check of whether the mmap lock is held.
>
> This is also self-documenting and lays the foundations for further VMA
> stability checks in the code.

So, is the lockdep addition the only functional change here?

>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  include/linux/mm.h        |  5 +---
>  include/linux/mmap_lock.h | 52 +++++++++++++++++++++++++++++++++++++++
>  mm/madvise.c              |  4 +--
>  3 files changed, 54 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 6029a71a6908..d7ca837dd8a5 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1008,10 +1008,7 @@ static inline void vma_flag_set_atomic(struct vm_a=
rea_struct *vma,
>  {
>         unsigned long *bitmap =3D ACCESS_PRIVATE(&vma->flags, __vma_flags=
);
>
> -       /* mmap read lock/VMA read lock must be held. */
> -       if (!rwsem_is_locked(&vma->vm_mm->mmap_lock))
> -               vma_assert_locked(vma);
> -
> +       vma_assert_stabilised(vma);
>         if (__vma_flag_atomic_valid(vma, bit))
>                 set_bit((__force int)bit, bitmap);
>  }
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 92ea07f0da4e..e01161560608 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -374,6 +374,52 @@ static inline void vma_assert_locked(struct vm_area_=
struct *vma)
>         vma_assert_write_locked(vma);
>  }
>
> +/**
> + * vma_assert_stabilised() - assert that this VMA cannot be changed from
> + * underneath us either by having a VMA or mmap lock held.
> + * @vma: The VMA whose stability we wish to assess.
> + *
> + * If lockdep is enabled we can precisely ensure stability via either an=
 mmap
> + * lock owned by us or a specific VMA lock.
> + *
> + * With lockdep disabled we may sometimes race with other threads acquir=
ing the
> + * mmap read lock simultaneous with our VMA read lock.
> + */
> +static inline void vma_assert_stabilised(struct vm_area_struct *vma)
> +{
> +       /*
> +        * If another thread owns an mmap lock, it may go away at any tim=
e, and
> +        * thus is no guarantee of stability.
> +        *
> +        * If lockdep is enabled we can accurately determine if an mmap l=
ock is
> +        * held and owned by us. Otherwise we must approximate.
> +        *
> +        * It doesn't necessarily mean we are not stabilised however, as =
we may
> +        * hold a VMA read lock (not a write lock as this would require a=
n owned
> +        * mmap lock).
> +        *
> +        * If (assuming lockdep is not enabled) we were to assert a VMA r=
ead
> +        * lock first we may also run into issues, as other threads can h=
old VMA
> +        * read locks simlutaneous to us.
> +        *
> +        * Therefore if lockdep is not enabled we risk a false negative (=
i.e. no
> +        * assert fired). If accurate checking is required, enable lockde=
p.
> +        */
> +       if (IS_ENABLED(CONFIG_LOCKDEP)) {
> +               if (lockdep_is_held(&vma->vm_mm->mmap_lock))
> +                       return;
> +       } else {
> +               if (rwsem_is_locked(&vma->vm_mm->mmap_lock))
> +                       return;
> +       }
> +
> +       /*
> +        * We're not stabilised by the mmap lock, so assert that we're
> +        * stabilised by a VMA lock.
> +        */
> +       vma_assert_locked(vma);
> +}
> +
>  static inline bool vma_is_attached(struct vm_area_struct *vma)
>  {
>         return refcount_read(&vma->vm_refcnt);
> @@ -455,6 +501,12 @@ static inline void vma_assert_locked(struct vm_area_=
struct *vma)
>         mmap_assert_locked(vma->vm_mm);
>  }
>
> +static inline void vma_assert_stabilised(struct vm_area_struct *vma)
> +{
> +       /* If no VMA locks, then either mmap lock suffices to stabilise. =
*/
> +       mmap_assert_locked(vma->vm_mm);
> +}
> +
>  #endif /* CONFIG_PER_VMA_LOCK */
>
>  static inline void mmap_write_lock(struct mm_struct *mm)
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 4bf4c8c38fd3..1f3040688f04 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -109,9 +109,7 @@ void anon_vma_name_free(struct kref *kref)
>
>  struct anon_vma_name *anon_vma_name(struct vm_area_struct *vma)
>  {
> -       if (!rwsem_is_locked(&vma->vm_mm->mmap_lock))
> -               vma_assert_locked(vma);
> -
> +       vma_assert_stabilised(vma);
>         return vma->anon_name;
>  }
>
> --
> 2.52.0

