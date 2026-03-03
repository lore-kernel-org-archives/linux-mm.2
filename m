Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9483EDA692
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 15:51:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDC616B009F; Tue,  3 Mar 2026 10:51:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5F686B00A0; Tue,  3 Mar 2026 10:51:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C37236B00A1; Tue,  3 Mar 2026 10:51:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ACA3C6B009F
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:51:14 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 57EA757825
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 15:51:14 +0000 (UTC)
X-FDA: 84505190868.20.1A58080
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf07.hostedemail.com (Postfix) with ESMTP id 596A240012
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 15:51:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Fn4biqiy;
	spf=pass (imf07.hostedemail.com: domain of glider@google.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772553072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XX2std0eOKpVnxlasP7zVX+3pxODM6r50zuPsQkksH0=;
	b=CDke31XNP6XzM+uyEKESZCjbvjKFkr12Y4+DSzzV4tjhE0y7I2Mfias5Q6WWOPO5uXWnCH
	eTqH7O1qY5u0wWn/2No8iXxgGF0Z2JhK8OtRTI6GHlAVWKiw0fzzzaSY9D7ptO/xlq1kU7
	B6icRoyfdMDpc4B0IL0VPOfCokeCVC4=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Fn4biqiy;
	spf=pass (imf07.hostedemail.com: domain of glider@google.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772553072; a=rsa-sha256;
	cv=pass;
	b=SE+PPPAN29Y/Qs2kZJxAVQniD4+pjvyJIVJf+YI9TIWnbveyeda6AN0YU6DaABGXXYZ801
	M/i70iaP1J/c4ABI6mDRriWkiesTsbi6Vuy504lqITSSkNv9CCD78Yjs2bPsRgUAo/Vs7d
	8pjlhEdVOM3Lf9iA2fnF7kgv+ezzDzA=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-899e85736e2so30647966d6.1
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 07:51:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772553071; cv=none;
        d=google.com; s=arc-20240605;
        b=IJh1CgO5BmYil35LaeQdh6saJccOYTeawNZbtUtwEy2OydDRUXEtlYJde+YREOOpEz
         8YlGgFVyBIFWMTjev36IPkVrRJWrysRfnIojRlM3yOgyCIHIuc0Hu0HwxNESEKn5yYfv
         OrGBWRPt9uQeCtYt3oUZhh5/6tP5XrW352TkCkT5Iw16p0Dvewei3EgT61vtTETaRGSW
         wD9DCWWVeGLg6T2iZ0n70TVXXzn8c9kXp0z7ZpSJK8yQMqZz7rEPLB0gypMcWu0/uL4L
         wrml90LNBluC2vrHiBn7N70ZhokGS12CIKDPI5hA841geHrhFW2xlrNVR+uIDNWgpvLt
         DcEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XX2std0eOKpVnxlasP7zVX+3pxODM6r50zuPsQkksH0=;
        fh=8a/KEtL73bGHgKr5MXBU/c4PDKzt+uV7Ura8g5i9/gA=;
        b=c/JyDYGBSav27xthQTLXhuCR6dQD+wYODNpNpPsfvI6N+f04+DQE7hP8Zo1eckSG9E
         DoHvASkBsQq+OCEnPqevWull+XztOvNvvWgX8X5vH9eiSacXa3vxCpnnim+FhvjqtKzs
         k16LQ8EBdBeA6InRPIPurW4KyUaE1m3akB1WhHRmgBSyiWm5q4u8aKeZa+6kqyu158bq
         4T6ufNWv6rMKVRkYxqJhv7Qlr9jQfQ2yLo5pb09Q3OVUldV133A7rxX9yZq9qUNfdNM7
         Ij6pNbFm8Ozlzu/B4TMxrb9XQcbfuI9gSsZ1Z7j/ECWd6c1/EMS77Oz/eYY37gH9Dfj9
         u/rw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772553071; x=1773157871; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XX2std0eOKpVnxlasP7zVX+3pxODM6r50zuPsQkksH0=;
        b=Fn4biqiyh5CP/LLVPIQs/jMlLSfSKbRfKDVQBaljVGAR/dk+yvnG7e4epagBAOnM85
         8EOr2D3JPZcXKt2LpWjWoRoHP4qsBFiBAhS8ifMOADKol7yENa2A4EzJFqQi+YVAheLv
         t/W4u6Og1lxdjk3z0PfK0Rad46X0VtHoOB9ZGq3l+51Ja+RtUhea0EWi73hNge6WYdJ6
         OEkvtzFrMcgZlPyRK8Leez8cPLa6PLbdhZ0ZR+XcJ7gHm/7ymQX1iGkYnhC9WS4yap1H
         kH+AZp0esjfvFlf4TvmTemROjKphdz7TreYvd07Rg9WVsU6NfY6ogjrFX43NyKeTODgK
         zN6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772553071; x=1773157871;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XX2std0eOKpVnxlasP7zVX+3pxODM6r50zuPsQkksH0=;
        b=o9uBQ62iycDTnNhAvv8tlTTBM7mu7XeTyC4GM7EsakFlzDSPUZy6UrZE0VgUrICapU
         xrRLVFO8OHm7CBez9zUqhSL+XHrPo1OhRLh8sZ9+Rc88HwBXYFeqttTWJQTtjsYgUF58
         7FtiuTQ27xzmXbGm4AafxQfsY5aTSAlG275CWA1CEgtcQrnrCRbTvXXzUuG6aFn5X/5j
         varu9J9hTYkfmVp2d0BsZxxo/gEK2+pxOsZVv2W4Da18VJND0qGO882hU+425DyOdznK
         owawQ/p/kf6IvyyN40EEv8FThosjq6MKnm+Qcb/U5BpEkbL9CJHNzWbwNXENcxQo1ibC
         2kLg==
X-Forwarded-Encrypted: i=1; AJvYcCVO/EZNQyDGWYCDnsTc/Furkp5vNvZTSlwN401pDQgywBQCsmE+Vm2CdHXzVrBAJs/b2jgNgGjMvQ==@kvack.org
X-Gm-Message-State: AOJu0Yz8bc7gikuLmuYCTLHE/PoIEuYPSC/F/cYgJnDRZ6Hj+Y0Y5EHK
	HAnRJp7Tc0Bx6O7mlYddDH/fnTLZ+K6D7nMpvpAA9XssqvlpKJqOCwUY8J4HNNz6KWBdxoRcYr4
	cwamd4MM7eHNPbWPhwQ5fCglDY5cZhzQhHF8l/yEg
X-Gm-Gg: ATEYQzwbpJGd2ZWhcYbukRvecvGOGLuQnKdJqG55Kq3L9B7Por+ILas1GvwyqrZGXpM
	Z1Kj37i8iICaxoIYonfe8EEphVckV2GmlydiU+yxTg3AcrX8YjbU++HFqoR6FRCxuktrvW2xPTR
	pxQaXN3mTM/Cfslyr4pPHWE8LE7bceY0vSebRLCPRh3VGr8+KbfQ5kq28tccZnHEsVnj53Tjy4V
	/io3bIpQpejicxLWEyE/Nyr+dXpgvhtiYiyB4tnp8mK9VYGqiWaewpP4w9J55kr/9AC/u9aEXzI
	tBGDK7+p/5ZSPS3G02AP+oTsYtM/NP/wriWtWw==
X-Received: by 2002:a0c:e083:0:20b0:899:a655:1e1c with SMTP id
 6a1803df08f44-89a0a89f981mr24703846d6.18.1772553070977; Tue, 03 Mar 2026
 07:51:10 -0800 (PST)
MIME-Version: 1.0
References: <20260225203639.3159463-1-elver@google.com> <CAG_fn=WAwHUpoay2kY6rkEZQGYxoDGVJYf5B59Y80ht7++Lmqw@mail.gmail.com>
 <CANpmjNNfz9TQcnZWkTXEAzVNdUAAYfBv0-FB-e7oV5PCfsYR5Q@mail.gmail.com>
In-Reply-To: <CANpmjNNfz9TQcnZWkTXEAzVNdUAAYfBv0-FB-e7oV5PCfsYR5Q@mail.gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 3 Mar 2026 16:50:33 +0100
X-Gm-Features: AaiRm50oFjbSzRbajGzbxbdZNPrSH3B1_BNVoEG05ijQc5OU5p9gEg4qp---aio
Message-ID: <CAG_fn=VczquLYh0zs-Rh51=B=J0k9EUtdoqrKncKy-n5jHxFEg@mail.gmail.com>
Subject: Re: [PATCH] kfence: add kfence.fault parameter
To: Marco Elver <elver@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dmitry Vyukov <dvyukov@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, 
	workflows@vger.kernel.org, linux-mm@kvack.org, 
	Ernesto Martinez Garcia <ernesto.martinezgarcia@tugraz.at>, Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 596A240012
X-Rspamd-Server: rspam08
X-Stat-Signature: j5w1extjzfmwtb6p6rbe84wbh85mei98
X-HE-Tag: 1772553072-607595
X-HE-Meta: U2FsdGVkX18yMpmDNkC2msvLXjF01nnL8eaxpSf5V7BWtxQhFQg2/z3Rc7cV0Fbmg/FNx5Mj+sE33SNKMCCD5gl5pFtJcZcgRpa0NlYplgr9asWpyjJbErkwqcBGknBj+an3BMEQBvZQSZ36rOTjvIQBYPRkG+2l8FuBPzWSkcqklBnuC9uNXvOlM9vWHbpA8bTJ+i7Hq8MY5EgGHYLJlYDdA0tmWudCZd6SiPhwJnKIh8zDuldn7Rl0fbP3o3FI8PKODkr6CqlM8FjwT0KvwDXQYKmh0oqOzU47S8K1N+Ii41BbtcFQiN7AyaI0mjxwMBUGsjY5/gbotjdrmnspXEvbMPqe19IAHWK3FhySIwqOA0t2hR07zfEa+H5Ql9G2rMml+vsQmF4nU+f8UzpH/husnKH5ILe5UfTzuDMvUSCTwDAEttWCPoViJIwkCbJUjrIjHt4RKBWKfTTwHgOGdOlxeEr8xbrODf/I3m+hfiYIJy4Om8I9yCs/o1Z80HuIk4Lqwdu21xB/GaHWtoq0S+XdDZ91isvjGWlxuqCnRuwHn5uv3eAj+pVm7tCxY+kbeXofkY2hat+4Fuvi9ikm068fwflpo5Zt18TL+ae/s+xvfXlApjPaauDEi20tiEYNoWjmhAl0erEDDm+vtfpoVgKc0zuR/LlTOEkYCtRknQ4pUN6lEFTQwRGXReZ6N4HbB4xmX8Fq029ZafJlFFlJ/Up1N8M8nDY1XmyZzFVQ7dTL5tvo9a43YsK/KZScQMo0jEBGn6TcDwDtaobgFFkNcxrxkS60jylWNpzUKuHYegMJJfy90RTRlmtQg0hd/S1M9QBBqtx9xbrB8pV+CueWOtfh/z1Rq3Wh/uuGb//6UsKioKU4ay7dV/+CdB2Bxcv/mOV6/q3sZf3wTeAx2REdCYmXKsH4gkEKfbjyzTV3Mqgz01RGnEZjTlXsILHT0PqMsAxBJVQxCwVmM8nZGKD
 y/3GYK3M
 pA1nWlIGX8ep3E7N3xAfY6Y+yZfv99BCvMVKZtv+KVhwgf7B/HmYEPZ3HgeU6g339AP+9eZad87DDzUNHGICTOAuNrmHV7gWyPlMwJL6d0b2O8mw2DKjWFY0yi0oBOJnWQi4Ai/RKGe8pg+7x4Ysil9m5HaImXKuhb2VS4TUtsOgIeqMeuGtZUx9VLKcPV6nhckBXJafR/eW3B7sK7XyZ2v9OYcxwOAImVe3xJ1ehEk16LWQ6EmNy9InhbY4zSKroNh3BcOnVcJtZJY0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 3, 2026 at 4:23=E2=80=AFPM Marco Elver <elver@google.com> wrote=
:
>
> On Tue, 3 Mar 2026 at 12:20, Alexander Potapenko <glider@google.com> wrot=
e:
> >
> > > @@ -830,7 +835,8 @@ static void kfence_check_all_canary(void)
> > >  static int kfence_check_canary_callback(struct notifier_block *nb,
> > >                                         unsigned long reason, void *a=
rg)
> > >  {
> > > -       kfence_check_all_canary();
> > > +       if (READ_ONCE(kfence_enabled))
> > > +               kfence_check_all_canary();
> >
> > By the way, should we also check for kfence_enabled when reporting erro=
rs?
>
> Not sure, I think it might be redundant - I don't see a way we should
> get to the reporting path if KFENCE is disabled. And if there
> currently is a way to get there, we should check kfence_enabled before
> (such as in this panic notifier now).
>
> > > @@ -1307,12 +1314,14 @@ bool kfence_handle_page_fault(unsigned long a=
ddr, bool is_write, struct pt_regs
> > >         if (to_report) {
> > >                 raw_spin_lock_irqsave(&to_report->lock, flags);
> > >                 to_report->unprotected_page =3D unprotected_page;
> > > -               kfence_report_error(addr, is_write, regs, to_report, =
error_type);
> > > +               fault =3D kfence_report_error(addr, is_write, regs, t=
o_report, error_type);
> > >                 raw_spin_unlock_irqrestore(&to_report->lock, flags);
> > >         } else {
> > >                 /* This may be a UAF or OOB access, but we can't be s=
ure. */
> > > -               kfence_report_error(addr, is_write, regs, NULL, KFENC=
E_ERROR_INVALID);
> > > +               fault =3D kfence_report_error(addr, is_write, regs, N=
ULL, KFENCE_ERROR_INVALID);
> > >         }
> > >
> > > +       kfence_handle_fault(fault);
> > > +
> > >         return kfence_unprotect(addr); /* Unprotect and let access pr=
oceed. */
> >
> > If kfence_handle_fault() oopses, kfence_unprotect() will never be
> > called, is that the desired behavior?
>
> It is - consider multiple kernel threads running into the same OOB or
> UAF. We should oops them all, otherwise this change is almost no
> benefit.
>
> > >         /* Require non-NULL meta, except if KFENCE_ERROR_INVALID. */
> > >         if (WARN_ON(type !=3D KFENCE_ERROR_INVALID && !meta))
> > > -               return;
> > > +               return KFENCE_FAULT_NONE;
> >
> > We explicitly don't panic here; guess it should be fine...
>
> Yes - it's a KFENCE bug if we get here, the WARN is fine.

Reviewed-by: Alexander Potapenko <glider@google.com>

