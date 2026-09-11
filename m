Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D7CBC88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 18:39:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 775556B0088; Fri, 11 Sep 2026 14:39:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74CA36B008C; Fri, 11 Sep 2026 14:39:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 645346B0098; Fri, 11 Sep 2026 14:39:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 338C26B0088
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:39:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A02A0A4502
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:39:38 +0000 (UTC)
X-FDA: 85202344836.10.B7D7762
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9E7E918000F
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:39:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=POwIsxtU;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789151976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+QDkAqDNHYHbzMD4UzAszEsitYxSsOiRVLmvmyXUE/I=;
	b=kddotyKcNgwi0VhFjDIkcCkJJdcDZbmb42b1z+ySnf6CA1BEYIrJa8eQW7n8HGOJUcYSD2
	QblqiHWvviL9sJ+n06V8kh1kIFB6D/D1M8LpQnBK/WlUpxFqhs3Zdso7siODds23UTBfQI
	qBwydWkiOVf2L74rZ8nLghsvo8mpVYU=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=POwIsxtU;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789151976;
	b=rXmtS3TysfWHDeT3qqplqRXQ7B80H2OCCZihK5U43MeuYhuJaPnI9FJ7k2TXqcqS81DMKt
	73c9t0XaHlQecpFzMKOSaz3apvfk4LoMnqkLK0K9fLMKZQS7nDIei8W8tPcR2mVA3Z40SP
	1YLSRfiJnumyDNDMellgt2Q7BGg2PPg=
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-53012819c04so94541cf.0
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:39:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789151976; cv=none;
        d=google.com; s=arc-20260327;
        b=IEHd4WkNvRHzVz1U3P3q7pEsaaNO/cV1EOEfqgf1dgBxYeAzO57Pe2H+qT1f99U1PC
         szOAI3mfMHT5GIqjgN9scY3TBIlXJ+Ads+fXoF1ctRRAkM3cG/gYZzi9XXTsKUal6d7b
         WUswKJuABQHsQDfhrLxNuXSssmwGZ/iBrZ84aMJw5k1VHU7zpeWi+x6auT8BocxyfMhu
         8g2VDlWV+DuxMqKParta8rVuP3OsH1Kp/lSZF2cXwwO5F1GE8wjEWFTTFG1EYxy3SypH
         0581KHQAStf6qIbBg7e9eBHJNom2MQDUfx8sAJkuxcy1R3b8t3h+o1Y4c/3Eh4xY3fjr
         o4iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+QDkAqDNHYHbzMD4UzAszEsitYxSsOiRVLmvmyXUE/I=;
        fh=WMHXNL9ptUKRGmymowg3wPrG/NCa0nYUDFn4XwsZeMw=;
        b=hIr4haml2aEb9L65N0RKkVSbjMt3HctU/0sEUUaTF65gs3g2vEW/1mNRofzdZ7E1JT
         Gh75fFqMguTD2v5RxUEMyTn9GBt/Y2j62vNw1N/6WJls9reJAZMDQQVf4NIT4ZlT2Zil
         ebbvtmZlMlY2QDzzizHUxLjucxXQYtsQhyKU29FWaNcHeoZq9rX0mYyrL0f+UeK8MVRE
         Rv0WAV0z9LkOpqoFXOqGqpzjox0FqxbgHDK7Nua9GIJdjW9dETWoY6aWr2x/8xQGcMDv
         btFmppYcx4e1ZDxrdBN3JlMxNI97gA3SY8Sqm6tQuuKVEIrNKzTIRN4jR3xxYz0fDtiH
         DSnA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789151976; x=1789756776; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+QDkAqDNHYHbzMD4UzAszEsitYxSsOiRVLmvmyXUE/I=;
        b=POwIsxtUkv2H/3euyo0GVd6wWqBYGxGSah/MTbDzKetksmcA5YsPytBFkFcfhqZZYL
         WQIDjYCOm7eobPS9YHpOdbfFYivcsW/vMpqwGnyvYDBWWsW3zafw+hzGT+3ik84KtSL/
         17ozov8+9HkPe9SqCn7OGTksDU0kqdvkN73l5sUH1wt6PYCqzBPELhU0MIUC2GS92oKh
         hfUpnZRIxH5M0O53eaYWOWHO0QIhE7wFbxRz5wJweeaQ7aZYOeeISPwCyfgtGIye4wkk
         Dd284comfOsA1OttJLn/p9vN//9DYMf++W3EyyKw+PMmYUYK1rgKVuXG00sXkxmor5Iv
         vlgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789151976; x=1789756776;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+QDkAqDNHYHbzMD4UzAszEsitYxSsOiRVLmvmyXUE/I=;
        b=ZNlK4kmZ7EA6fZhx1o1wn/wjj5qGnP5PssoTA/s7WU0wjR9OUgAWh1An5od5IUHGYy
         3S+BQYNJ8FMx0os712kWWCD63P8uTJsE9C0Xr82ZP/KaO6FIMvQexAG/x6mTfZM0qRfY
         9C6xu2ma9qt6puY8mNTIOR2SwOdP7ZWyInQQrtQQDyTQoGwRJYSjUMxI5R+X1gaOjKLi
         8bh6TPHw4t0TDFegX3aYiQ/sym8H1stdTQ7spY/DWfNYqTQsu2pNsVRXV/pf9SqOZ2cc
         uNRbuVFFAEKWkLBV4T7TC0yh/TTuOQjXLs12d/5u1B0XOnARl93sqrkqD5xyiCkMO2RJ
         XujQ==
X-Forwarded-Encrypted: i=1; AKwUvBy5GjIzsmUYLDutEVRl9Yv978HNDI3JdZjg4g+EhEZqdUvWXAwBS9VHKT/njJbu/7c3HLlBQFzHNA==@kvack.org
X-Gm-Message-State: AFuF++lW7IabJDvMN1CuE+H9n6Z7cdVgTEBgvn1Vdbvvv23xylYZ4mC8
	gohDChqdFBOWtga9CIp/nL2yp+9bVFMnXPagKISlZ1vv2d/jtD14EKJBGBgu+S6clfbIKowaT9P
	CGxaIiPZp7YGyY/hsqo9laBnkuLFd4c6lu/UrLi0b
X-Gm-Gg: AYBFou3EFPZ5LiZ0Xr9qfTdxBiwvbAEaHRQgiI7lOCjf8ebyOajNTtFVae5ulSkJ6g7
	HGBexKNLIt44qd5/t0J2zcMrlln9tIjW7j4uANToN+6iTKOPBu/jB6r155PuL2nGr22HoabHuUA
	NPYpyJ9t5NTRqRvb4I44s74+zxoSuc6WBEPIK5/s/uW7DeCzxPfgmyGyrFFiLJkKSvBU8asuj8m
	Mz+dojjnV27eYL9b6v+cAuZ+JiBQp5lm3nHkMuiT/Z03gnaRDjQJTekt3ph0P3Vd39kxV6cT/HP
	tjCHL7e9K57aABIZeq7li9GwLy8yAupvGQIMCx4g6NYiiDNT/a+BPJomMxTDNMRV9lQLlIaJCxf
	mNki9jHjt4Q==
X-Received: by 2002:a05:622a:5218:b0:530:ac23:ff40 with SMTP id
 d75a77b69052e-530e493076bmr1282331cf.5.1789151974931; Fri, 11 Sep 2026
 11:39:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260910234737.1340642-1-surenb@google.com> <20260910234737.1340642-6-surenb@google.com>
 <aqRF4YB7Ijk9PmRM@gremlin>
In-Reply-To: <aqRF4YB7Ijk9PmRM@gremlin>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 11 Sep 2026 11:39:23 -0700
X-Gm-Features: AcwNN1W4dOfkLKGREm-MUH-pM0CR6V-0wgsS0pYyFtiALBPWuaW4-GsVKkWozvE
Message-ID: <CAJuCfpEScgOTK7ymtDrqa52GY-ooeP2boowF=CLpin7hR11iRA@mail.gmail.com>
Subject: Re: [PATCH v3 5/7] proc/task_mmu: change proc_get_vma() to stop
 returning gate VMA at the end
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, xueyuan.chen21@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: p6siu43fwsum9xyzzpi3t8m1nipyqsns
X-Rspamd-Queue-Id: 9E7E918000F
X-Rspamd-Server: rspam07
X-HE-Tag: 1789151976-412635
X-HE-Meta: U2FsdGVkX1+ZDtFOLbXWhzgBluaBeBQnrbomaVTQTI76q7OKzWSjo5Hv/kObuZzfGvCuaT6rC9DIlHq+80+bdWX/DSzSWWNlhlqsH89BBf/z+mk0Ps2qRTrYnAXxfhUmstLcUxcR9R9679wXW4qysHZuM1IadXI/UEOGIU/jdqqSxbS9zBYSJEWCuauf2/1IQOyP/rLPeiof723x8FT29J64ASCTe2DdbCPLjNzGZX/PuzLUlRBOOui/ncXn8Yl+/l10sGlVL71bGP9pMoeh1kmmKOb5WdK5vJktjmmiRZEX9MRnAeMkw9SxCmDW0Ag0xplw9Tphn3SQO6YCD/iGkJOquUoqej2zUsUNMCi/IsMPvSXgnt3kdZsXL3E4PXWJteFv3lo5WofZBmFXgT8iLtnQfNKp/ymz4XyKyIvBHKDqB5qJzHY6mJaYo/RJ+IKVZG/PaDwF2xHiraQunS1Fx+8IPdLuPnMLGhJBD2NJoIfPtBFhkgdw5qPxw3WGnAkys+Op/0tivSQZKPEq4Fe+EDWYe5K3qgteAKW/hxetwVUCfebIdlR9sAghRvwQavOfG1LDRgIiMGznYVkDntInUg+XEfjXzfBEhm/Bjrev7yGL/K20UNyY3bOrgNF1DVH/+M/IXxBnC32v3aJuL4eYSz/6rWII6rNYZL5VRkrc7GHthoqFO5xB3imo2UwX/dno0eo0CoeCYLoIraoloLurh+RH6T+giut9xM9uczvDnfukyVDAEukOEqDw2Pbkvm4KINzwZjsrIB8PUlwlMVbavwY9J6ywUP4u/dTa4IYjJdLROIlDR09WqV07oIiIZdfrk6IF17g4UcxQdDRpiTFG1stjBMPeXDtHJqCyFdh3UOOYL68H1JAo0+ErjhBbzvT27Z999son6mafD1Y007MOdH0fhLFUaKWsKnLf3cRGKMxSBlMJXQgmh8t4d1AOSZmvzQdEkGoAFQOToM4jD7H
 pxP9Qsko
 xM4c38233qEVUk4P+8nb3BFrbobyccL+y20iD+6BYWu9nX60zPgEdRAf2D+ayRvnj0hrbIM75TSY9+Xiomr7UEmVOo2sUI886WgXkO2D/3uGwf5Nk/Ymj6pdc7ffyoL7PYUZmMKe7tmmNKkffHzdTA8PuAKAeZ/E46L+AoOYAugHbDxeow/89JJ4gmkSa0rHFRBeS4I2ANYXkLSlW7us+FHyIf5WdJMbvtQfGEZ7zWPiz0dbxnzGLEsVww45tf5D+ZDrtB00tTiPFzT5Oto2IeWkp8Nso7TfHvzS7CJ64eSuu32cEVFQQsmtznnClmag/K+z38QziFMIX1G9NjNU28giIGrQaT9TGqbhBXass5eJzBbDEAWoM+RrHnxroNYpjGopi6Q38xozpzoDJSG1HCcjkEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 11:26=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.=
org> wrote:
>
> On Thu, Sep 10, 2026 at 04:47:35PM -0700, Suren Baghdasaryan wrote:
> > proc_get_vma() returning gate VMA at the end is desirable for the its
> > current m_start/m_next callers, as they need to report a gate VMA at th=
e
> > end of the address space. This behavior is very specific to these calle=
rs
> > and makes proc_get_vma() hard to use for other purposes.
> >
> > Move this usage-specific behavior into the callers themselves so that
> > proc_get_vma() returns either a valid VMA, an error or a NULL when no
> > more VMAs are available. This makes it more generic, simpler and usable
> > in the later patches.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>
> Yes, very good change, thanks!
>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Thanks!

>
> > ---
> >  fs/proc/task_mmu.c | 23 ++++++++++++++++++-----
> >  1 file changed, 18 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index ecce7ce116cb..9a3c996c1d61 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -236,9 +236,6 @@ static struct vm_area_struct *proc_get_vma(struct s=
eq_file *m, loff_t *ppos)
> >                * found the extended vma with the same vm_start.
> >                */
> >               *ppos =3D vma->vm_end;
> > -     } else {
> > -             *ppos =3D SENTINEL_VMA_GATE;
> > -             vma =3D get_gate_vma(priv->lock_ctx.mm);
>
> Yeah this is just so confusing as-was.
>
> >       }
> >
> >       return vma;
> > @@ -248,6 +245,7 @@ static void *m_start(struct seq_file *m, loff_t *pp=
os)
> >  {
> >       struct proc_maps_private *priv =3D m->private;
> >       struct proc_maps_locking_ctx *lock_ctx;
> > +     struct vm_area_struct *vma;
> >       loff_t last_addr =3D *ppos;
> >       struct mm_struct *mm;
> >
> > @@ -280,16 +278,31 @@ static void *m_start(struct seq_file *m, loff_t *=
ppos)
> >       if (last_addr =3D=3D SENTINEL_VMA_GATE)
> >               return get_gate_vma(mm);
> >
> > -     return proc_get_vma(m, ppos);
> > +     vma =3D proc_get_vma(m, ppos);
> > +     if (vma)
> > +             return vma;
> > +
> > +     /* Return gate VMA at the end */
> > +     *ppos =3D SENTINEL_VMA_GATE;
> > +     return get_gate_vma(mm);
> >  }
> >
> >  static void *m_next(struct seq_file *m, void *v, loff_t *ppos)
> >  {
> > +     struct proc_maps_private *priv =3D m->private;
> > +     struct vm_area_struct *vma;
> > +
> >       if (*ppos =3D=3D SENTINEL_VMA_GATE) {
> >               *ppos =3D SENTINEL_VMA_END;
> >               return NULL;
> >       }
> > -     return proc_get_vma(m, ppos);
> > +     vma =3D proc_get_vma(m, ppos);
> > +     if (vma)
> > +             return vma;
>
> OK so I guess the logic is, iterate through every VMA, then once you run =
out,
> report the gate VMA. Makes sense.

Yes, correct.

>
> > +
> > +     /* Return gate VMA at the end */
> > +     *ppos =3D SENTINEL_VMA_GATE;
> > +     return get_gate_vma(priv->lock_ctx.mm);
> >  }
> >
> >  static void m_stop(struct seq_file *m, void *v)
> > --
> > 2.55.0.1007.g17ff1f9808-goog
> >
>
> --
> Cheers, Lorenzo

