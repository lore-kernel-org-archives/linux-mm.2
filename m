Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47834C88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 19:44:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 532496B00B1; Fri, 11 Sep 2026 15:44:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 508126B00B2; Fri, 11 Sep 2026 15:44:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AA276B00B3; Fri, 11 Sep 2026 15:44:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 13E296B00B1
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:44:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8E50E14032F
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:44:19 +0000 (UTC)
X-FDA: 85202507838.25.61FFC5E
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7C2EC20008
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:44:17 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hM6J7OQd;
	spf=pass (imf31.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789155857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kN0XHRUDweJ1/OhG2mXDTF4VMn4i+usHL3piKE2cuME=;
	b=YfJG5kbFSaQWPcxwZXNIjpVPQgi+owunWGTxQ28DKbddP+S7tFqxcjEN59izJ5yxwmkXyD
	GN38bNwSLy39DZjLxE5fcUCaFxBzZVEqbJdOg6LcqoZVLaoXYUAO8EtXI9Mmj9XVrcawIW
	+nqfWIfQmb3Gchuhy4FH/D1dvwRnrkc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789155857;
	b=7vEuZn+REOPDV/Y8B7DNCTqzzAfLKodlHZOD5pQUOEIFCwKgv6GQ46ErEfpU+ef5V7y+6m
	Kb2CUR1INXOdXy+rasYkw0/nyjh93CU0oMVbO8pgKvjKcoKVhAJl2gV9dc0G0lbp3ID42x
	U9xU6Te+fZmGSOkhj40oQ98PYOOX91s=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hM6J7OQd;
	spf=pass (imf31.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-53012819c04so112481cf.0
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:44:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789155857; cv=none;
        d=google.com; s=arc-20260327;
        b=rtLt2IO5rwlOyMy5TGoOjJs/bHPVbv71IFT5lazUEVCFDONCovpQasPrt0ldv13h8D
         oF4XR60rsAN8/5+uq6+xzsNH5eh0CYK1CWC28D5e72b4CiY9J6ojFHELxHYL1iYDQrCz
         HeMkSZCffEaIJPoPatBdINpC7pslZH9jJpr7knIEBaHr9AZ8bV0/0g6/OwvZDAXz3dfN
         nFalkN5e6cLd3Z3aeJQTSuG82uvXdeWgKGUT7OgONUWuQk0nz9tkahqaQIQXY1R5MdmT
         trW1h4cbLHasjnIf0Zt+aclx8i88TwY04LYbuqzykYEgka15TbGeyp0rfm8VsvVMNd/P
         4Dbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kN0XHRUDweJ1/OhG2mXDTF4VMn4i+usHL3piKE2cuME=;
        fh=M+ta+FWAm01MDLEBWJP76MxuSWUWNtKqdKLKZuvzkIA=;
        b=rdS6HsIQJ+olTPV19GjrTPFNyM4qmUOe2ficKyERiwtooF8gwPCJmqgeUcwE4GAlzp
         Aj0TKbveNswfJG9n3Spb9bhZg/C3QNere8E/nycZp5gn3sTAb1MPnZRUpwdeYD0EHiXw
         X3khNnZf3ePsy0dOQkaqIQkJWH/ey1VV9xLYFfCDsZkMmGFIem0853/Zv3u2Yb8ouqJL
         L7f/KpHnIBJjWtsnxFsSQn2rKdZpJKDEFehO35on/ChRXS1Rq+9J1laX+pyGYOu3q5Bz
         DFc5hmc7Okg7inL/6+s2vZ6c1H2dsFUz8mL95tDnq29J8Gu1PhxM8NTpaMRnNJuKDKGI
         ISPg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789155857; x=1789760657; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kN0XHRUDweJ1/OhG2mXDTF4VMn4i+usHL3piKE2cuME=;
        b=hM6J7OQds1B3dc1483P+F6Jxv3tWvn0RdaAemkearmWJFWSIbVQ1DeK0ENjUbLxqJg
         XcO6oHEsJ741lL9S4gb2zZIP/sRm/jniDQ1s3H0z/OH76Wm777VaSPm+U7gxfCMtVa+z
         gxqjCRmUdXwWv+KNOwKdnUEkdTqzPPnMCwLliqTCLc1KlOOoZqVhFFNmcxw8CHE4xb5Y
         9/1+/od2ocjBX2LxUCM8SVbQ5y0cxGEvwvZ2b9pRJm013x5UBlncfIEt3p6vRBuQJ4Vu
         HrVYTqnbBPJyr0zi76BgwPpNr0OAkFvKoW1A841zUoHFhiS9b+muCl29N3hLTQ9Ip+/x
         3qQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789155857; x=1789760657;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kN0XHRUDweJ1/OhG2mXDTF4VMn4i+usHL3piKE2cuME=;
        b=s5tK9ZkFTXDpX01cTTnP5Y/AmVJNnv2DGOaszbr7kh2Ov8lnoExoLbwaudYiQwW0nn
         GLQscaArWgiudRO8ABJ439HttyeAkBPuzLdIZYI/yL/Nuq9A2F6TNEzP8YVAjY/clAkU
         hUBQFaYkf3iguZ/St1axh8LdEKuIKLXh5klDRkkr7MMjs4lkZ5c4bM0eJScd8KFXI9dV
         mTWLMTY98nDQ3ovfQSLw5Y3Ouw7OVWGROPyBsXcVe00YbXFHNzCzRdZpRWDSDE/RgMez
         dI1e2UE8HhNTfVY6oc+3aNbah7lQbYcdyZobo+F5QZ2h1TyXuVYQ4ZBVcVNeSiT0ssns
         UiUg==
X-Forwarded-Encrypted: i=1; AKwUvBx+4HVCsf3eO16d2KgreOzuRoL3bO/fX7sWAD0sPbl++k6a5AyL1qAN94KXefqNxoAEBkmGy2TFxA==@kvack.org
X-Gm-Message-State: AFuF++lnvjbPs3v0wRQmRq0urjonGxsy9Vl5W60qqfZgXl3jMbcygFmD
	/56daXQimPu9bsAr2jiq6xzZBy31LuRPCE9cX4C4sJT2Jl9fHEaN2Is8PW8Vex8ML/Ijg1zk1MP
	EdjlpS7PXUN+NBAzicmQQuODzMoXwJ82vhJ0hf+DY
X-Gm-Gg: AYBFou12YTXSqKXCrUIYerfW3RrLo4bORjU2NaFpSyBHh52NG+1eJWq49T2tA/vCk4c
	KBiIPemCnh2A5yjY6Idz4u5RHpaH6dBSFAjSM1G5Ko6qTeUO4IPXZNlYPcOTuQkvvqGgOgI4m0w
	ER0k2ni7LcE6tItyMnWtlZGao1ZJsL6i5ZOtarfpLEIak4yC8RVxXMGFKOVquzPljzXVRvKfkYG
	nmibFqFMifWWosomrYnJn2wds8PAw/EmNQur/bK8elSexbolmnYEKl4TATszFn02vKn6r7VMPL3
	Dxrm8iwLsBTXzhyLtI0JcRSMpsKtiFu/BtlR7ri51oMI9a+qd/5bxYC++8uJYngR0sGY2X5BMPr
	bNFjudW5oVNk=
X-Received: by 2002:a05:622a:cc:b0:52f:9ed4:8d74 with SMTP id
 d75a77b69052e-530e475171amr2444781cf.14.1789155855913; Fri, 11 Sep 2026
 12:44:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260910234737.1340642-1-surenb@google.com> <20260910234737.1340642-6-surenb@google.com>
 <aqRF4YB7Ijk9PmRM@gremlin> <aqRPeZH4yeYXfWgS@gremlin> <CAJuCfpG-8sQjg2ECiRQpjn9tBj3AfEXnmgmomdfFGS7JoDhZ4w@mail.gmail.com>
 <aqRSvISJtYrt5Gvp@gremlin> <CAJuCfpGvB4o1HrKsi4zbzKNmdxppW_76xJUbaYeE+sN6w-u6UA@mail.gmail.com>
 <aqRVzecC23YpZeh0@gremlin>
In-Reply-To: <aqRVzecC23YpZeh0@gremlin>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 11 Sep 2026 12:44:04 -0700
X-Gm-Features: AcwNN1WZAK4AhrgJSaOV-mvzjDcNBoqfmvSShEkPZAg297uHKBFoNS2-TUHAzeE
Message-ID: <CAJuCfpGOR5X6R2NwASMFwp=UtWCCDn64OJNEmzbMh9DDmn2d4Q@mail.gmail.com>
Subject: Re: [PATCH v3 5/7] proc/task_mmu: change proc_get_vma() to stop
 returning gate VMA at the end
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, xueyuan.chen21@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: aebr8nnczwf3a3t31wanaatz38rr9ypz
X-Rspam-User: 
X-Rspamd-Queue-Id: 7C2EC20008
X-Rspamd-Server: rspam03
X-HE-Tag: 1789155857-555119
X-HE-Meta: U2FsdGVkX183deM7EC5nYL6Z0FlM4+TZMix1fhHZGSHcqEJup3SCX4PtjMU9L+4t2xcoiC9qfzE7OhpUNI7ceuaENc6RJQ4JbkWrbA/ns+NX3lOtBK2MVxkCxAH2u5Igc68YhFJoGk4uh7iyJZKhVuVFZjj9JO6Yo3FK/OlSfoVI0luDlPgMxT0G3RpRrWNUQSWgzJir36PxI9qFYdZju1LmPuEY0Dub9DbpNALKwVyMBNWF8GFUdBHOBI+vcyfuD32toDZlQtHjB5bliF5Tl7UrNER+A50/zoBox8KB3iOWn7rl2eJx3qv31Lhgk5TvDzKAfmjT71ep9nZ1GafGuebuC49XMdNBFTCzDEyAYyb9aFXDKhhfLXJYSQoYgcCQWwLIveGqa5vHbL0Vg8S6M3Zkuc1oTNtrnPhkmuMwEms9ZX2lW7VfOQRyUJMfg9fWrz1zkO0fBD58CLPv6+teQ8UPSHMbfaJeJPl05szehbDYiKaRPyxiin7a0AUXkgA+L41Ta8KIWB8FUqu8OpQV2jlZp7iuLONuGJFrRBp72sVArREHPkttNrkyLVQz46pBdk/B3v+SW3TzAdabpjKifEdDAZ0Cmk3vWLME9ttmiasBH1GXtT1aBlQVLG5dboTRDBCkdL/EpNePCUnuKJx7mzLtIfEOToI2p2b+LOvQq5BSW2HfVryBNT2iw9W8Qgn7pBXBwWJf0Q7+JwtyyugVzg5SOmHxxq43n9brDOe5AYKWLQPty1vlSsFa95+8eZpvIDlZYreL8DJ8JL+X2WdaKouk31kCzRqx0M5UIraKohu0PtQBorslmGx0RSRvTrm/6cATVSJdvtHVAZEKji//cla+BHYDIg69EkbQwwn4XAO+Iv2AbGsnQ3+jWrRrUUtaaPrw/43bpep+MFbLdy9aQ7twYUoo1ax6rDBXdU8kPZhnyjo/JiIYK2E3bhfj05EFmeySSze6r/psDh/Zgc+
 Ce2C+kqG
 bqtffVKYAPyq1kqok8dnrpgzN3ghMH+D6OxIc5Ja4z/0fcocSaWrwm/iWQKlw1YqSml4nuvEj+r0dVHO4kTIZ4ifo7uAh7sXMZITBzmxAprIhXA8KwFTYHC7ZGTs+6DsTIzc80j2e+aCckt34N5pjPf7mH8mUWqguxj1G0oAwR5AlEcqMgF3uaGxl8XWrqy1RrQqHyAOa5LPQFlEwWxmmswI6wz/uNhiOI+3fy0BwMEuffAXqonT1wMNL8y9pSmViLMTmqHFGutLX2pVIVflbIeHtlG6L9WJYNX++SlPCeoFQD4j7yvPREPPSZ6AD4YkDn3JAajglOcPF4vAEg04cFpURIZa3q1AB9GDWKeHp0KUn7W/5GiM8z/TWic2ANPY9BOa483gbnovF9U5MdThRMDzwHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 12:26=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.=
org> wrote:
>
> On Fri, Sep 11, 2026 at 12:18:41PM -0700, Suren Baghdasaryan wrote:
> > On Fri, Sep 11, 2026 at 12:13=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@ker=
nel.org> wrote:
> > >
> > > On Fri, Sep 11, 2026 at 12:11:55PM -0700, Suren Baghdasaryan wrote:
> > > > On Fri, Sep 11, 2026 at 12:03=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs=
@kernel.org> wrote:
> > > > >
> > > > > On Fri, Sep 11, 2026 at 07:26:49PM +0100, Lorenzo Stoakes (ARM) w=
rote:
> > > > > > On Thu, Sep 10, 2026 at 04:47:35PM -0700, Suren Baghdasaryan wr=
ote:
> > > > > > > proc_get_vma() returning gate VMA at the end is desirable for=
 the its
> > > > > > > current m_start/m_next callers, as they need to report a gate=
 VMA at the
> > > > > > > end of the address space. This behavior is very specific to t=
hese callers
> > > > > > > and makes proc_get_vma() hard to use for other purposes.
> > > > > > >
> > > > > > > Move this usage-specific behavior into the callers themselves=
 so that
> > > > > > > proc_get_vma() returns either a valid VMA, an error or a NULL=
 when no
> > > > > > > more VMAs are available. This makes it more generic, simpler =
and usable
> > > > > > > in the later patches.
> > > > > > >
> > > > > > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > > > >
> > > > > > Yes, very good change, thanks!
> > > > > >
> > > > > > Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > > > > >
> > > > > > > ---
> > > > > > >  fs/proc/task_mmu.c | 23 ++++++++++++++++++-----
> > > > > > >  1 file changed, 18 insertions(+), 5 deletions(-)
> > > > > > >
> > > > > > > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > > > > > > index ecce7ce116cb..9a3c996c1d61 100644
> > > > > > > --- a/fs/proc/task_mmu.c
> > > > > > > +++ b/fs/proc/task_mmu.c
> > > > > > > @@ -236,9 +236,6 @@ static struct vm_area_struct *proc_get_vm=
a(struct seq_file *m, loff_t *ppos)
> > > > > > >              * found the extended vma with the same vm_start.
> > > > > > >              */
> > > > > > >             *ppos =3D vma->vm_end;
> > > > > > > -   } else {
> > > > > > > -           *ppos =3D SENTINEL_VMA_GATE;
> > > > > > > -           vma =3D get_gate_vma(priv->lock_ctx.mm);
> > > > > >
> > > > > > Yeah this is just so confusing as-was.
> > > > > >
> > > > > > >     }
> > > > > > >
> > > > > > >     return vma;
> > > > > > > @@ -248,6 +245,7 @@ static void *m_start(struct seq_file *m, =
loff_t *ppos)
> > > > > > >  {
> > > > > > >     struct proc_maps_private *priv =3D m->private;
> > > > > > >     struct proc_maps_locking_ctx *lock_ctx;
> > > > > > > +   struct vm_area_struct *vma;
> > > > > > >     loff_t last_addr =3D *ppos;
> > > > > > >     struct mm_struct *mm;
> > > > > > >
> > > > > > > @@ -280,16 +278,31 @@ static void *m_start(struct seq_file *m=
, loff_t *ppos)
> > > > > > >     if (last_addr =3D=3D SENTINEL_VMA_GATE)
> > > > > > >             return get_gate_vma(mm);
> > > > > > >
> > > > > > > -   return proc_get_vma(m, ppos);
> > > > > > > +   vma =3D proc_get_vma(m, ppos);
> > > > > > > +   if (vma)
> > > > > > > +           return vma;
> > > > > > > +
> > > > > > > +   /* Return gate VMA at the end */
> > > > > > > +   *ppos =3D SENTINEL_VMA_GATE;
> > > > > > > +   return get_gate_vma(mm);
> > > > > > >  }
> > > > > > >
> > > > > > >  static void *m_next(struct seq_file *m, void *v, loff_t *ppo=
s)
> > > > > > >  {
> > > > > > > +   struct proc_maps_private *priv =3D m->private;
> > > > > > > +   struct vm_area_struct *vma;
> > > > > > > +
> > > > > > >     if (*ppos =3D=3D SENTINEL_VMA_GATE) {
> > > > > > >             *ppos =3D SENTINEL_VMA_END;
> > > > > > >             return NULL;
> > > > > > >     }
> > > > > > > -   return proc_get_vma(m, ppos);
> > > > > > > +   vma =3D proc_get_vma(m, ppos);
> > > > > > > +   if (vma)
> > > > > > > +           return vma;
> > > > > >
> > > > > > OK so I guess the logic is, iterate through every VMA, then onc=
e you run out,
> > > > > > report the gate VMA. Makes sense.
> > > > >
> > > > > Hmm one thing on this though - m_start() still has:
> > > > >
> > > > >         if (last_addr =3D=3D SENTINEL_VMA_GATE)
> > > > >                 return get_gate_vma(mm);
> > > > >
> > > > > As well as:
> > > > >
> > > > >         vma =3D proc_get_vma(m, ppos);
> > > > >         if (vma)
> > > > >                 return vma;
> > > > >
> > > > >         /* Return gate VMA at the end */
> > > > >         *ppos =3D SENTINEL_VMA_GATE;
> > > > >         return get_gate_vma(mm);
> > > > >
> > > > > Now at the end.
> > > > >
> > > > > Is this correct? Is it maybe duplicated now?
> > > >
> > > > Yeah, I noticed that too but I it's not duplication. The first chec=
k
> > > > handles the case when right after m_next() hit the end of the addre=
ss
> > > > space and set *ppos =3D SENTINEL_VMA_GATE, we ran out of page space=
 and
> > > > had to flush its content. Once that's done, m_start will be called =
and
> > > > last_addr will be set to SENTINEL_VMA_GATE. In that case we should
> > > > return get_gate_vma() and avoid calling proc_get_vma(). That's what
> > > > the first check for sentinel is doing. The second one handles the c=
ase
> > > > when m_start() itself readches the end of the address space and has=
 to
> > > > return SENTINEL_VMA_GATE.
> > > >
> > > > It's possible this can be refactored a bit and made cleaner but I
> > > > would keep that as a separate change.
> > >
> > > Maybe just add a comment to the first one to explain when it'll trigg=
er? That
> > > should suffice, cleanups can be separate yes.
> >
> > Will do. Appreciate the reviews!
> >
> > I'll post the update today because there is some urgency to backport
> > these patches and I want to have a public link when backporting but I
> > don't expect anyone to burn the midnight oil to review the final
> > version. Have a nice weekend!
>
> Well you have tags on most things from me now so it'll only be one patch =
I
> think? That'll be missing mine anyway.

Yep, thanks!

Posted v4 at https://lore.kernel.org/all/20260911194145.1781926-1-surenb@go=
ogle.com/
and the only patch missing your stamp is
https://lore.kernel.org/all/20260911194145.1781926-4-surenb@google.com/

>
> >
> > >
> > > >
> > > > >
> > > > > >
> > > > > > > +
> > > > > > > +   /* Return gate VMA at the end */
> > > > > > > +   *ppos =3D SENTINEL_VMA_GATE;
> > > > > > > +   return get_gate_vma(priv->lock_ctx.mm);
> > > > > > >  }
> > > > > > >
> > > > > > >  static void m_stop(struct seq_file *m, void *v)
> > > > > > > --
> > > > > > > 2.55.0.1007.g17ff1f9808-goog
> > > > > > >
> > > > > >
> > > > > > --
> > > > > > Cheers, Lorenzo
> > > > >
> > > > > --
> > > > > Cheers, Lorenzo
> > >
> > > --
> > > Cheers, Lorenzo
>
> --
> Cheers, Lorenzo

