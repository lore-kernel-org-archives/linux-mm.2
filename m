Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A44C9CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:06:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D31B8E0077; Mon,  1 Sep 2025 11:06:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 484DC8E0076; Mon,  1 Sep 2025 11:06:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C1CB8E0077; Mon,  1 Sep 2025 11:06:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E6BC8E0076
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:06:33 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D1FF6C08F3
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:06:32 +0000 (UTC)
X-FDA: 83841007824.16.682A7D6
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf30.hostedemail.com (Postfix) with ESMTP id 776C280008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:06:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=PswySFrn;
	spf=pass (imf30.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/bwNSdY68Wls82Q0k25WMNjJlHUk0r0pQNA4NzN+C5M=;
	b=Gy2nEhZEeBPquobVKmJzzdcAziGHf6ySBqPQGLktb9qK7HICzCylkT7JbK5K7s1PaqDQXd
	TPaFb8/wxGIEGLtjjXK5NlYiAOKjn3wa5tpVVElIj5MxCQkFX8Y86dQFAlSWf8cyU8fIEB
	v+pujXy2DvUfnAKc4rX0np69un74Sp0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=PswySFrn;
	spf=pass (imf30.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739191; a=rsa-sha256;
	cv=none;
	b=PTvuIm5SjOqKbuUrd17hzk5K6B0NcHE9lukXQnkmsoscDIqzZZ7mTPFQpioNx3aJuhuiTo
	kVltK37KReCr/0/oit/sDF/M8EHJeZp3A4m6U+VG2kXWTiWpxjN2LLHbF+Q6ugmjz2VQc3
	zM3ELlYsM2UPS60oz8vK7Z+kCYK9Kk8=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b042cc3953cso128931466b.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 08:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756739189; x=1757343989; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/bwNSdY68Wls82Q0k25WMNjJlHUk0r0pQNA4NzN+C5M=;
        b=PswySFrngsmjmHRS15KWU8hGy+lfghD5iy7h0sdO8FK8AJZrjnjKkbHajVP3xFiiVn
         RzyWMtwSMbII9CT4XXAttqX5cvl+ku2uTGcMb/LsbVd892VnQl4656PYcBKWU7ZNAV89
         BN7Zd2t2oH9//Qr7zHL5e1V7+TL0EB9SsuA6FYGzhcTl+xu8wVmvBG3ms0vdFEmP8jud
         TFfpnMkuZf3tzJq5Bo3TjU6lV86tZArHwYAJAXSH/srqWBY4uzv972wVGkRI60t5x8Wu
         500LK19jJ2oARWqF0XqL5mjdMF/jOASIKdAaymAh/UfoYGO5u93+FwId4wl6LclIreFl
         kdtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756739189; x=1757343989;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/bwNSdY68Wls82Q0k25WMNjJlHUk0r0pQNA4NzN+C5M=;
        b=YUquIEazfuYRbWPEsOD+rQ8uMAdvmEoVoqXcT3fYFUvHK0f9IR0YGew16DT4+B+2SB
         fyblxijqJgHz2VhETHPudiRHvwppCfrrG3uVg8kHiU5LoggM8Snwvynl9KUib3/5O9ZM
         OOWhiN0uw7cTXC8hzxQ67M70b4rbPd+r0wapk7mal90xouw565Sg4BuJAPgvDn47AN+L
         L8PT99bYEHMp66qYYTE3nsE8a1SQ6prL0cBFlinRr471BDIsYc9ECXgZxs4XgU+QW/rN
         n1WInmOVi4BTM81WEAVJs7pk625uFmnFvvSHDqOCthITvc2jnzXjmZ7glhUn4OefuRiV
         IQtw==
X-Forwarded-Encrypted: i=1; AJvYcCUSaJoiJWQ6Mr2y6iWOdgSp+wcKCZj136CdWSi154IeCIMowVXgTWKRx4ZOPdJzeny7Sy9zHVdPPg==@kvack.org
X-Gm-Message-State: AOJu0YyXjLjZsKSWmQylL+MFDfduKzB+AkfbcrYLz+iSLSl67VX1U0Gf
	uux98dbUBJuRDegfjEZ9uINyDqxg/uQ/xZFAwWkBCqseoGLvZ8rbiVPaIfpWS9CeOItK+E21n8Z
	afaVfKx6RO38KXl/E9zRX086+zdWrTcm9vV/gj9QU4Q==
X-Gm-Gg: ASbGncvIF/+ap5Q3iv4semRymLiKugi6Y9hcU6bQ6vtLxztkit12M09m4Khhl3U674B
	PJGLjGMF39o7TMFnniPZd+ue6aqNLPMzJvbonCXDpFpFppvZcTqNQNiWWS+0+Bend5xSguPTQhH
	ohil8bj8Dk3YeYiB8xecd0KSIiLiAIhQkzpeEvWTYi81MswyJ+Bfs7PaKUOr2Ic+pI/HZyk3FUU
	ad1TItksaLsR91f/2TC7J6fGn7daigNC7sVlgrvcWXQYg==
X-Google-Smtp-Source: AGHT+IG0FxeUic5SFzE3UNYIN3B9+gaajPRoU8Y0dXCHXgh8kVRRqajKZHy7y0TqbZFDzgzomSvfHMhYlurHNOihACs=
X-Received: by 2002:a17:907:1b10:b0:afe:85d5:a318 with SMTP id
 a640c23a62f3a-b01d9755f83mr810176666b.36.1756739188996; Mon, 01 Sep 2025
 08:06:28 -0700 (PDT)
MIME-Version: 1.0
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
 <20250901123028.3383461-9-max.kellermann@ionos.com> <2ad655ca-7003-4030-bb2d-1c4bcfda30cc@redhat.com>
In-Reply-To: <2ad655ca-7003-4030-bb2d-1c4bcfda30cc@redhat.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 1 Sep 2025 17:06:18 +0200
X-Gm-Features: Ac12FXwds-_H2NdWifPwev4VbqOwXfa3OcMVFnDeIo9bGQG09tjqsarnzZrb6S4
Message-ID: <CAKPOu+-_bPwE4sCcb6n-nfi3nWy6L0gBAoHgRz3qwdUHByE_Lg@mail.gmail.com>
Subject: Re: [PATCH v5 08/12] mm: constify arch_pick_mmap_layout() for
 improved const-correctness
To: David Hildenbrand <david@redhat.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com, 
	willy@infradead.org, hughd@google.com, mhocko@suse.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	vishal.moola@gmail.com, linux@armlinux.org.uk, 
	James.Bottomley@hansenpartnership.com, deller@gmx.de, agordeev@linux.ibm.com, 
	gerald.schaefer@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	borntraeger@linux.ibm.com, svens@linux.ibm.com, davem@davemloft.net, 
	andreas@gaisler.com, dave.hansen@linux.intel.com, luto@kernel.org, 
	peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	x86@kernel.org, hpa@zytor.com, chris@zankel.net, jcmvbkbc@gmail.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, weixugc@google.com, 
	baolin.wang@linux.alibaba.com, rientjes@google.com, shakeel.butt@linux.dev, 
	thuth@redhat.com, broonie@kernel.org, osalvador@suse.de, jfalempe@redhat.com, 
	mpe@ellerman.id.au, nysal@linux.ibm.com, linux-arm-kernel@lists.infradead.org, 
	linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ojhf9qtot8s97m13hfmi4ioxytch7e6e
X-Rspam-User: 
X-Rspamd-Queue-Id: 776C280008
X-Rspamd-Server: rspam05
X-HE-Tag: 1756739190-440322
X-HE-Meta: U2FsdGVkX18r2QQLT3FyhWPP570TPnYdybwZUvUjpMR520x+N9VllxhuvmqmZpgsBVBMWIruyIfEOmBXbnfS4lWZLteTkFZ8NQNVKFUxsynVfjCLxLPkuQxxp87UBl3nNfQzK67LvGUA5urW5tgJfw1+fyHuZgsglyvoypg5d/B/UmM7AsGDaVTKQ5pVcRJHUNMeYTH/30NWApeuUsFQBBMDpldhhEfJMIBZbcCsC1cwAgdoA/q5gITt2sxXzAKuJ+MH3JBiqN/OawEBMsdsNp4N9SxnqF5rpB/Yni7mL07+Uc4bB2zz7ZQwo4W++2fPUHNWBUWepSOmo/csWGRfZ5eALuphRc60TXjuaPA5boE9nriL2JLhzsVc4pVa9FWA8tTPCH+KlrvVXJY/8iRcX5i/NvunGMJqModesalgXTrtJ6kzUV9GFKXo26jpJXKU1vxzd4rpnACNDch9PCoEKsCnvjeGJN+l5tVv/pmC3xOToWyzEFayCVkg0CwyE1q/gUWXR+WCjBXfHgPD4ZJThOESzXry7pKSC6V6deeRYssl4SHr+pzDDDe7XN+wj191EkZDIZObea+EuaCDtFCWyJr6aKGdD0xAE7pc+2dEmFgO0XcVabRwwvOKi5UQ89uUbE4RwLlwyccdH/bbT8j3jGTZP8zGFAWDddwCeMHFB9S8xjqmNTlac1QINPCqGYrXj3RnNUHM7xYw4OAzAv53oYZtMmXN7cXXFwtRsAs/TeICu9+hz5ctnLBgl/4Fj0K5xkF7OCdsynzi6MqO3eyg9yyibeM79z4PosHgVFb3EkP3szK6fsLVV9DtKZek13HYCm+c9UDU2QXtMPOFGY4BcbCVUj9/oCqjBQsSNSlV3dwvsVfdVV+bh8l7dyTYd3z8cTA2L/4o5d7oSySZlh5Sa4u5n3LuWWKStJ22DeeZ/vtZul6k8dWRkW26ScuHrTC7SRICXiiQP6okhf3/euP
 8nrt9SK5
 s/3b/PxOXUOnA65zxYyupUA6w5/RpjgjBUt3SnxsVPykUjsrmCPTuXU42FKOOfCV9YwM3Qnc/avosin4h97szAXtoMTJ3ma2QiSbFY9IZBB5O0xGOSMqOh95k7KHuEKypMv+UIT7IhS1zyNW9+BgRveXG7TQyd2PtKd13uPBw5cPiVYI3CAINHJW1sV+i8jh0k8b+eB0XTYIY+o2EqSkCQtRMKzuWXirf48nMOqu6CkxqZZjsJod7TAGNYBKZiOk4B24WQsYUSKqR6bUcmnR5t2qGC/D/Nqhu1+H/qmK/dYBHGYpL62L7OuNzxs/Rl/1OlGgrzGQKrmwYlGK7Yya4/fFcjc7Xx+7NZChf53qMwCIgDCs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025 at 3:58=E2=80=AFPM David Hildenbrand <david@redhat.com>=
 wrote:
> > index 2201da0afecc..0232d983b715 100644
> > --- a/include/linux/sched/mm.h
> > +++ b/include/linux/sched/mm.h
> > @@ -178,7 +178,7 @@ static inline void mm_update_next_owner(struct mm_s=
truct *mm)
> >   #endif
> >
> >   extern void arch_pick_mmap_layout(struct mm_struct *mm,
> > -                               struct rlimit *rlim_stack);
> > +                               const struct rlimit *rlim_stack);
> >
> >   unsigned long
> >   arch_get_unmapped_area(struct file *filp, unsigned long addr,
> > @@ -211,7 +211,7 @@ generic_get_unmapped_area_topdown(struct file *filp=
, unsigned long addr,
> >                                 unsigned long flags, vm_flags_t vm_flag=
s);
> >   #else
> >   static inline void arch_pick_mmap_layout(struct mm_struct *mm,
> > -                                      struct rlimit *rlim_stack) {}
> > +                                      const struct rlimit *rlim_stack)=
 {}
> >   #endif
>
> Should both these cases also use *const?
>
> (for the latter we probably don't care either, but maybe just to be
> consistent)

Actually, it would *only* make sense on the latter, because the former
is a prototype...

