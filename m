Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CFC0CD5BA4
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 16:52:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 525226B00DC; Wed, 20 May 2026 12:52:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D62D6B00DD; Wed, 20 May 2026 12:52:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EF446B00DE; Wed, 20 May 2026 12:52:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 316786B00DC
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:52:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BE27712033E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:52:44 +0000 (UTC)
X-FDA: 84788392248.05.C4174B7
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8F37A4000C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:52:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=MX0C50Qn;
	spf=pass (imf17.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.51 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779295962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IE1WMXvRIxH2O/SD306cerGoIlp9t6+cpBTFwur01Qo=;
	b=O1WjfyzIO7V72V4rke/Ns0LJfWTslpMucbZHhjzSuaNA068oyiYnWlKS9UVV5v75sMDs40
	seSt+JU+KekYqvRh+7AsDcnpoCw0CuB47bmZDWS6FsjX6pAwC32II2Iny0kHR4c9NnB9da
	07EHYJ0mVrEiIEu/gMf9+fOD4o3Fk4c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779295962; a=rsa-sha256;
	cv=none;
	b=3kJ8cYnKQo7aXD8YifHU5ZXvW/ZC52ucmYNEzEiaSOCIbv4qzqO7Exrkawnz8Fa13ohOOT
	ZWciUgUcXEWe3m0x8Yk/y+gPUDczU+uEBd5ngc1XVMhOViJHA4JIpKtEQQUO5GFayWPVKv
	U2G8BBQgalFOtklVgX8u2cE0B4c/tpc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=MX0C50Qn;
	spf=pass (imf17.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.51 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6804e24803bso11240868a12.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 09:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1779295961; x=1779900761; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IE1WMXvRIxH2O/SD306cerGoIlp9t6+cpBTFwur01Qo=;
        b=MX0C50Qnpamr19/DvBy0XGrYEuBfSjgwEGTrvBqmn8XSgK7Bf82tL/tWuPvuFXBRLd
         NKf75NKLjqqPM2DNptpivPV9oousUZ+5PB+pwAlOthPyy4+oUDrnaKd8SBLk46pP6Gnj
         faIrJnOd6sudaSjw74mkyyG+7c+rw72BK/+0U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779295961; x=1779900761;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IE1WMXvRIxH2O/SD306cerGoIlp9t6+cpBTFwur01Qo=;
        b=sqUy0JJASzltP5FvqW4zndjWuzInopfnM+WIvFjYorqhAMc6zkdrNCs3SH+9pNMad7
         sCdEoauzFZ61YtRs0VxcI0bRqMZtXw/qNT0yRo1H+bsfh0Odx+SQ1byUJn4xkHIjZo/s
         LBveOzmSCW2WdvoPyAxJvBgOxQxrwHAWePIJhRJ3gyZ2dPVN4qnhFL9as26CCwA2KAtm
         0Wz9haUWkJAtqtQrAHOxOlmnYfkvElRbP8W33GvL6AUZ4b/JzegEuvHEY06P48QnNh4U
         8BAeAthPbJtREs7fBS6Cl/QZd8SiBsbjKKa4dKU5xmme3tWwckI1AmasY8orAZC27bdE
         RLqg==
X-Forwarded-Encrypted: i=1; AFNElJ9NXHToVQysaYe497y8g05NSxuUjtZ5mJO0HKePK7ks3Sn48h+beQNmFm+5yk29hM6JH/W/HjC+Dw==@kvack.org
X-Gm-Message-State: AOJu0YwTOesDT93pZsobdXvPXSQTd7bcNprDV5KkdTHqiVNNP3UzNDGX
	Vbxpwhv9lMXanCeu8eoLUDdr0kNFlKDOgXHU8xCeASPNAWFB9yidYy2jESzBu3DCpm/Bas5VZjv
	BwIEMpfKULg==
X-Gm-Gg: Acq92OEYcbF+rS/vAeO7B93lz8WTRzQt+ggzAdTHsS/gHHJQHuPEA5MCHOa+VxywnP8
	rMcUKNT0md2EdByK+Qh5NsH20dRfo78cnkhzpkUC+lH4L/4PE38lx1TZZLTVPMtEah49eXiq0UF
	foKzs13RjFUfTkN7KTaSX96FQJQgQzlbbRk/IMi9Kf7HpAuDus9av7RoBDoa/5KDza8tYpWF1u9
	5d8HKMCRj/S+VgNK5ehIVsLJ/baWBe/yEFQfy4Yu6yBuPfxKuewbPAew+rtc31MwTirdkHtAEtW
	lKv5aJhh/8NuGE4A0/VjFc9yaZVsGV1LufEjv6irfbDx23vmsDeWXhZQ5ogzcb2G2tVuLwalrhh
	t5irFSjP0NqO9jbsud4Tl4ujG84zDBtloQVLFDVDcnoBXUjBqMSPgZk0Tj9oBYQq0vFYVGcx44o
	7t2DOumj2gk2Me3HshP50EcVtebgSmCLZG6BxRt1bXCQnb+iBZqtk8aDXn3ve7vXhYiw5mnnM=
X-Received: by 2002:a05:6402:370b:b0:687:bf35:f049 with SMTP id 4fb4d7f45d1cf-687bf453449mr626019a12.22.1779295960912;
        Wed, 20 May 2026 09:52:40 -0700 (PDT)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com. [209.85.218.46])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-68310d58df1sm8287106a12.13.2026.05.20.09.52.39
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2026 09:52:40 -0700 (PDT)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-bd5047a2a4cso801104166b.3
        for <linux-mm@kvack.org>; Wed, 20 May 2026 09:52:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/fZ6Isf5rU2lRfw0l/magdCe7CYX4qx6x2RSogb0+FScQhZ+5/YFsyYHxHxFgxgwwNLUva4A5IWA==@kvack.org
X-Received: by 2002:a17:907:7b82:b0:bd9:a6ab:a245 with SMTP id
 a640c23a62f3a-bd9a6abc524mr420886566b.41.1779295958860; Wed, 20 May 2026
 09:52:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260520-work-task_exec_state-v2-0-9ea88ceb09e6@kernel.org> <CAG48ez0kVA+Rw+pHSi5-JLf9KTh8Y9Am04W567YS=imgk+b7tA@mail.gmail.com>
In-Reply-To: <CAG48ez0kVA+Rw+pHSi5-JLf9KTh8Y9Am04W567YS=imgk+b7tA@mail.gmail.com>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Wed, 20 May 2026 11:52:22 -0500
X-Gmail-Original-Message-ID: <CAHk-=wh7CJo_GmRoByrMePPB6sDC2ienhEd8riq=xp0BLPYZYQ@mail.gmail.com>
X-Gm-Features: AVHnY4KFNC8iyTRW1uwiNUmk6rMIKsAhfqXTFKK_xvLpioBZSdflpbS0y73oX6M
Message-ID: <CAHk-=wh7CJo_GmRoByrMePPB6sDC2ienhEd8riq=xp0BLPYZYQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2 0/5] ptrace: keep mm metadata accessible past exit_mm()
To: Jann Horn <jannh@google.com>
Cc: Christian Brauner <brauner@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Qualys Security Advisory <qsa@qualys.com>, Kees Cook <kees@kernel.org>, Minchan Kim <minchan@kernel.org>, 
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8F37A4000C
X-Stat-Signature: wsi433zxmswy5af4fjnpq3q68u3ops7k
X-Rspam-User: 
X-HE-Tag: 1779295962-626126
X-HE-Meta: U2FsdGVkX19sEVG+FG4xiLPoR9nfcDMK+DHgNXhCADpHsjdiJsrp58w8EyIVNN+HE96u6vRiItJ8HTPjdIzAhhKWh9zGVESzXZSXfHtbhIXCmauTfSz10BVlQCl98z2aThHRm9X/Ol74Z183BSdTb9Gn/DIFD7x/3wT0dE/v+I4Yy2mgUvezqWnp/8Edr5ftn9ZFVuVTGiuxGjXsmftrdboGyA1dHmFdOSo2ydkqXC6KMcNO96bLTBA2H7T9wbS/QPeMFsjSgJmYlkpsq6OuJhhhxDe+nr/WWbLW3Lic5o31bw8mXvz92PjMApcnA3QKIR8r92X/GXgL/jgez9qJErWZl7BlThal0WYS0VXjtoI7hwsY/WpJ9MLvlDwbb9X9nHX9DrHwMBVamL61+bNmAWTYwBaOmG68uQtvRKuE3qgdU3pJGeiV3ExTSwxmlCpdrpPaXbsQU3WRIrakHoUsNB3PyxvEgQMSt81RWzpWAZL8u6hV47watcBeV99VogS2H1eF2CbPJcS6jXfa8cFes7nqeyTpZqiZFYrAHTH7sAaOE8C0LJrRY0hE4bSwtegvDp1CFhIsTIo+s3fjY/NPOIbDAYkNHszeP9qm3nuP3Vn0awbSIGlHHIsU1N3j9LrcICiDjwQz1Ou6FYZX8EXiRwGyowbYmLpH4d+lrs5nF602RC/ki4r0msJ30rQ10eXtUR8bfwKruFXksBs5YXZPBTpuPHnVpa16dTOaq5W7b7LKWCVmwuLP2j0qTdsJBDk19KdhBguriQIToY06xkCw2WlU/tSNttwUjKNBUr+DJOaB38vLZV+YBAKmBj1eBHeOIcAKaOAltxer7KUIHSWygF4qerPKqeXu0bxyugA3RDz/6vUeM13w9w1nT3zbjzmofDNFAQrCmeJndUbaHVA6d4uIyBgdYj/fo0DdYWsFkg9/G0cEncA/5iDl5dbFzeuo2Fiqm5+XuiSDVSelPzV
 /TI6erv/
 /CFqWyusvYgIW9Ty4aGF4aHMSwVc2iPb5UnGErUs3AxNQ/qg8PAgeB0CcCO6o2njIpOCiuJN0lq2XTTPsdvwm621ZzjWLid5//pXNgE0FzFmi4IN8L9wI4hyaTGTM/m05zDTG93rtq2kQ6y41boEuBGkx+kGapwjRhSe5BN/ebb0FFIqtDWmpht2eN6jc6LZ88Uul7ZP6tbquKOBacIUp4t7JKdehqqFqdEj+FZt5vLQWXU0sO7Mquw1kJckgUli+5LICHxg0XzhClZfxsS8BVERuVjyTuDAXU6l443j0gRnvQJZFdfYnlwY5NCIJ4NBcmqUO+Ldcdxiwlvb4eHXoZjTMGV7Y0kkILLkoqF13mlFGLdQNSCseBzqU3TB9ieWIcQtfaH5Vli0FGPa2z3ZRKNIQbK7yrx/uQlH2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 May 2026 at 11:27, Jann Horn <jannh@google.com> wrote:
>
> On Android, there is a process "zygote64" from which all apps are
> forked without exec, and these apps are supposed to not interfere with
> each other:

Oh, yeah, I remember that horrid hack. I think it has come up before
because it makes fork() very expensive when you have a huge process
that you fork for every little thing...

    "Zygote: the GNU emacs of Android".

That said, I think it's mostly harmless, because:

> So I think with this series applied, any app could use prctl() to
> influence the dumpability of all other apps, which seems
> undesirable...

Right you are. How about just modifying the rule to saying that
prctl(PR_SET_DUMPABLE) just always creates a new exec_state for the
current thread?

(Insert obvious optimizations: if the state doesn't change, don't
split it, and if the current exec state has a refcount of 1, don't
split it).

It's still not the same thing as "always create a new one at fork",
since there would be no "shared mm" component to it, and it would be
thread-local. Hmm?

             Linus

