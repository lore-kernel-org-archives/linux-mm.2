Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AE13D6CFA1
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 19:39:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37CF66B0345; Thu, 22 Jan 2026 14:39:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 329BC6B0346; Thu, 22 Jan 2026 14:39:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22CB66B0347; Thu, 22 Jan 2026 14:39:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D2596B0345
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:39:49 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B32DC13C228
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:39:48 +0000 (UTC)
X-FDA: 84360614856.06.107AE9D
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf30.hostedemail.com (Postfix) with ESMTP id CD17780004
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:39:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JPuFTfU7;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769110786; a=rsa-sha256;
	cv=pass;
	b=7mT1b5qjij24ZFRWBFI3cig+RywfWt5aH8GRCC78ebPo1RGfaZ11lAbY/sU1H7X2f2Kw0k
	uM+eIClbOmnytQYiwMqqcWAF3mRYD1C+e/GNe0+aHdo0E/kkQUIEqO1XeDkR7c5t+ZylMk
	7cS1kz6rKmPWlymqJ29wNQqAy6EpF9A=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JPuFTfU7;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769110786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FbXrFJ0fbRQV5M77+5bXTD1xfH71g5LG/AxIH0V558A=;
	b=8W7mX7iWbtI6QYVqIBoDQSwjPku2H7x48C/ywjwKp6yB6bjDlDRCCRgvg2PSx1JdJHHDHx
	aziiuTTOVsncL+eJT+JM9qls1Es7C5eMGNAa9SLuZhlDxGh4552E8zme3Ky7KrpBSWgbiC
	LtA7jcg5Zv4y6YxHLIsW2M4cl5woqfw=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-5014b5d8551so89121cf.0
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:39:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769110786; cv=none;
        d=google.com; s=arc-20240605;
        b=kDzD1rfCMDQQ3JkaJQr78SJmfYEznTX2VC9cwd+vsAODuu0RNk4QDPzGfxjIO8Q8m6
         UjKhJC9QCOqk+pRcEpqOAjztho7i143aaSI8reFNkfJAbys4mkAHqEPQtQrhGwo95xe5
         fJVL3Q711UbP1uqlPuWT+0yLvWyVsdpc9t9vXE+pSn3q/1RTkyzhlf5+8503jItsgGJ2
         zkF+5CS8YmQDf3ZP+dBIsDCNYF1e1yzTPIwBsi5QY+YHruQxqCaSkj37wsnU9NtmAVYs
         AEFNdFkPdRFZZIjI0SRsRj/IOGShxqNzkpLsYvoODbfx0riESKLWFJ+g+MqRhvPGsIVT
         6b9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FbXrFJ0fbRQV5M77+5bXTD1xfH71g5LG/AxIH0V558A=;
        fh=HVR03vSpXYifA7UksUaS79M8plJRSmv6B089vDvCAOw=;
        b=Ym6+moeSOb/VHquT+ThkLpQocelamqIvk+dRyIkgQMJwQjiSYId4z7G4FigEGzkz0J
         C3v7qv/KQnUnt7Wt2rNdFqyvL6tc90niZ2qIsQo4JLtqlxJx0X4xAHi4/Npc/Sza9J5W
         JgyiRj52KUhKs4Fiy+uwTihTjJyRZE1UMYKs7BqxOAQYbt9n2CPxi3gkS1Yd+kN4m9ND
         dHCjl6MQweVxO67F2vU3gmB4H2D1oE7QBBXMhv1vEI9+e5T2U/0LmCgFZOAIf+TH/dRb
         qavMapv5rje4OFEmAIbnp0ORTdQZIt2yynfFwR4eVa6KcysAqyWX+RlQ2hMFK8+Xl6JP
         8zyw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769110786; x=1769715586; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FbXrFJ0fbRQV5M77+5bXTD1xfH71g5LG/AxIH0V558A=;
        b=JPuFTfU7JYUDcIXNIxmyPuDG4GhhPw5zQevk1ajrSF8VtLoqADdAxIr4t4qlhAPaJo
         HWuOZLPQkyyN5mehhTgw3dHfpGvQICdBb4hnM+Fyu4NVk0VrufjuNC+FJktcruDfXVVL
         EtBw0mWn2F4d/Nn4tK6mtFSgkAm7o/oQ0EqrPdMGAX+mRngikOrclL/9x8YROlRM0ZAL
         t2hxOlGZySBcEj5Qjt8rzv5JhqveLMcxK/8MvUYNdl35hFAsYg8Ke7VoHG92brD2/SOG
         9EhxNoZCoFud1fDzbkLyUEdPEGunuFjbvM/tU9Xyg/zUiiGltszntWNW9alqKc/nHNA0
         FFww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769110786; x=1769715586;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FbXrFJ0fbRQV5M77+5bXTD1xfH71g5LG/AxIH0V558A=;
        b=v8NPq1GuhaUSOiBL+Y4cX3UVFTbKrgCTU2ysMeMxRF6MsRcBmoO5Cc1/W8O+TPCtW1
         hBHe4HOCSfSM/MBCBzhulLOqjjkGx/iAbFcxUlMzZDxqDgYb7EjxUZFOFc6+zyZrTMHa
         bF2RfAHHsulzbRBe2ffHLM4BmGTgUH9p46rdXaiLq2QuxUibQVjLyStYkmhgoKmSXMlf
         iuqyH7INKYwx1BtDRFVDKowUtKWE2Q2fNDwCO1+6Q3xqqeNw1CmjBtnzYXYWdAORSZuL
         3qfJdzJtq0TgQvLoPkZefhA74bjVJQbhsRACajBF4L7syXyOQcWomdS4przer1U5nTkD
         tNrQ==
X-Forwarded-Encrypted: i=1; AJvYcCVrn7yOz/HuBeWUDXRxnGVY62D8rI1J8sxxubD3t+G+8jEGa1IYvwejB4sgUP3feMc09ivtS1cSfA==@kvack.org
X-Gm-Message-State: AOJu0Yx048fzu6PEKzDzzcQpk4mwNdrGTN3VQfw6o/YpGgcRf+vWL0M3
	kYYufq71jLSxUizHlj1URoCNnanBaHLNLdbr9lYXdWcOa9Z2lK5d8mURCCKs8kAhYO4/GzhISpa
	vbuSHje6xcign7hUb9Omc8fp4Kx/EJWo6K41D4QKd
X-Gm-Gg: AZuq6aIQwOK+uCGFoVcTZnGdUPvmTbLVnfPvtmaxZG/sRAUkIYo1T7wwdYvVZRaIR1E
	iIrKl98Vfy0eB1piNLYrFQVT4CQ9OGV2QjJrmYVWY/yrANlGP38UbMhlKowPD6Bv8+3hlct1gCq
	IklQlUvdmC+eClT86TBePZb85SissChwM8CIB6qvFKibMU+XcAhZXfOtexI9VkkK9OrbVjYjH/O
	0UqYmQAVIhR1TxzcXXZQwrt33IpVKVifpS+aK+KJCYTJnjsShYfxzZojWz5Z7/U49P0OIXYeLCP
	K0ocJBV+RKp+Ab/hYBusNl1+
X-Received: by 2002:ac8:5f82:0:b0:4ff:cb75:2a22 with SMTP id
 d75a77b69052e-502f80e7440mr1370691cf.3.1769110785523; Thu, 22 Jan 2026
 11:39:45 -0800 (PST)
MIME-Version: 1.0
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com> <2611b2b6957b7aef587e9ae62712a888159dce60.1769086312.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <2611b2b6957b7aef587e9ae62712a888159dce60.1769086312.git.lorenzo.stoakes@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 22 Jan 2026 11:39:34 -0800
X-Gm-Features: AZwV_Qh6PNOVoCipXXRRGwgLnWMjxjJqYBHLgvVtO7OcfwK79_FWKqPDx6CCM90
Message-ID: <CAJuCfpEv+aag1s2Aa=moCueyfB38hmSJFJ4ieZwthRdsKZEhWA@mail.gmail.com>
Subject: Re: [PATCH RESEND v3 05/10] mm/vma: de-duplicate __vma_enter_locked()
 error path
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
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CD17780004
X-Stat-Signature: sd74mff4aiq75w6irn9j9pk9gd5j5udj
X-HE-Tag: 1769110786-403948
X-HE-Meta: U2FsdGVkX1/ijeS3viZJWBz+EnuDKSA5IwLpiC3UdTR+0P1of7kU1PlTu6lVJLkk5gp3Ubzvx4xK7XRj04+jLlJHetNRnt29pUmvEWWvrwBr1Jr3XotR2BDPC4TkmTWKOsKMi9Gkrsy85ni0Pg0x6cnGWiY3nE+8ofEYkdCmCBr/P/c7m3yXcDDOIQLV440LAFBGCv7cOUpCv6kgpn0uAcQQcoa3cTxCg+OsssFGdQ+wRxAgUHEqd28xNtmt5WnEcEqJiTtiai+jCWeyDXP5ML9B9j57qsDpuEj+jxS5pMkwbpITq9lSiHm/PNKahwOWDhMoCl7yaZ/057AHIKJ7LX0kWIV2hHsNe0omNECtoq/7bN9o4nvj24l5bpLvwAdL/WEDM8fNUj3eQmbO5cKtQqfBJGRfgTA3oVaq8dZm1XsOosy4qB9V1WtmyzRq3axvRPwz9UeZtqXairCiYOrOQ3Uoi87A+2Yu08/HaPaugXBxWerg5sNtApW1Qg1pmoYTCdoGOi3oOWY4eSgDcuXNB+g9jbeK8EqQBIr2n9QxLqU2GEzlfxJuEikiTC2uwg1Ge6z/Jnn5xu8C+XwYHEQLddkAM8jZDZgBhzWXIs75pGnihXQK453lLNNt2EBvKGW8Y8Lh6ExmWH/tCtTsxK3hc7pyW2v8Z+y7Zf68QTunSmVYoOHZGYkN3hgOOYyWMS0KNdz2GucymI47X3CR5MKzlFmvWK+KtobxRnENvCMtcoGCxH7PJqEVU36uNWTtMbIAncN+Ik7lhTI9ta5z1/NgHbjWvwVwXURd9VKiLrKoezxNJlIyQVhxm2e5seFnZFAM93EPG1e4BpbCw8yJM/DNFl+4HMwl/oG6TYaIMQZmusUvSRQTfjHzklIEV2CYmg5sJttDEK532oNlOps9k2Otcn3qQUKSPuWJwilH++XvWKwHhQDrZLXkEQCgF5ckPsWktLMlukptjNpenZoeelt
 z1iCXmy5
 cJ3lF+J2nb9kyl6yzyzF21zCGU5FRtosdl0Q8+kAUHjhyzXGn2E3vNHF8M4mOstShHPdE26hQwliuRBYV1H/71IlIO/DJxNuPeqIwUrcy4omrganlVIoMfPKIJEW92463/l8zQgefE+r3vtdBmpKqY1ATiFjuig/8HgZWteNUChp23y+Q2muJmYMjbmnKCAlH06uJIRIRbQ7w1GeINEg0/c9/997YLteXrl9rGlRkJ1lnriaeO/0Ll2Uvl+21pWQeEK12FT/fTHcKRZyN1JoAhInqqPgaPomyD28fg7bXHmJpH7by2FAyp3p09tWhqeYUo8mqF+rt2JlHtuG9ClTHD2IpbmA7Cauhxrqvu8PqarnYIxTlcJbUYSlrH/wCZGIlyM4NrY6d5JdJlkuzo0JJE6xesg==
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
> We're doing precisely the same thing that __vma_exit_locked() does, so
> de-duplicate this code and keep the refcount primitive in one place.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/mmap_lock.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
>
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index 9563bfb051f4..7a0361cff6db 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -45,6 +45,14 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_released);
>
>  #ifdef CONFIG_MMU
>  #ifdef CONFIG_PER_VMA_LOCK
> +
> +static inline void __vma_exit_locked(struct vm_area_struct *vma, bool *d=
etached)
> +{
> +       *detached =3D refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLA=
G,
> +                                         &vma->vm_refcnt);
> +       __vma_lockdep_release_exclusive(vma);
> +}
> +
>  /*
>   * __vma_enter_locked() returns 0 immediately if the vma is not
>   * attached, otherwise it waits for any current readers to finish and
> @@ -77,7 +85,10 @@ static inline int __vma_enter_locked(struct vm_area_st=
ruct *vma,
>                    refcount_read(&vma->vm_refcnt) =3D=3D tgt_refcnt,
>                    state);
>         if (err) {
> -               if (refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,=
 &vma->vm_refcnt)) {
> +               bool detached;
> +
> +               __vma_exit_locked(vma, &detached);
> +               if (detached) {
>                         /*
>                          * The wait failed, but the last reader went away
>                          * as well.  Tell the caller the VMA is detached.
> @@ -85,7 +96,6 @@ static inline int __vma_enter_locked(struct vm_area_str=
uct *vma,
>                         WARN_ON_ONCE(!detaching);
>                         err =3D 0;
>                 }
> -               __vma_lockdep_release_exclusive(vma);
>                 return err;
>         }
>         __vma_lockdep_stat_mark_acquired(vma);
> @@ -93,13 +103,6 @@ static inline int __vma_enter_locked(struct vm_area_s=
truct *vma,
>         return 1;
>  }
>
> -static inline void __vma_exit_locked(struct vm_area_struct *vma, bool *d=
etached)
> -{
> -       *detached =3D refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLA=
G,
> -                                         &vma->vm_refcnt);
> -       __vma_lockdep_release_exclusive(vma);
> -}
> -
>  int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_s=
eq,
>                 int state)
>  {
> --
> 2.52.0

