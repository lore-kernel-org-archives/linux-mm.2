Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3BD5D4A5F4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 12:24:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 344B96B008A; Sun, 18 Jan 2026 07:24:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F34D6B008C; Sun, 18 Jan 2026 07:24:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D3FA6B0092; Sun, 18 Jan 2026 07:24:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 09D1A6B008A
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 07:24:51 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8C910140502
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 12:24:50 +0000 (UTC)
X-FDA: 84345003540.21.A187DAB
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id C2C5D20002
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 12:24:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VoFNHPOC;
	spf=pass (imf13.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768739088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gbcn9ZoWB47ZWS/FNIOuP6vDPNcXEa4VJ9tgLN/6Tko=;
	b=F6wlVMf8GzFVxu7h99ncCxUGNF4SZ2rvPvtb8y2hJ3Pnhc3lJvVDrfuVhuiu69nOe+H8r4
	G6Zl2+XZ6X+B+vTRHgRMEYHzUkqOi0JJd7KpMw0hoKyMeteUOieqDeHaGVASZRDVl1Wokp
	y3Uvw+tBOE6V6Rg9caWgn53E6JgonUo=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VoFNHPOC;
	spf=pass (imf13.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768739088; a=rsa-sha256;
	cv=pass;
	b=M0EaH3wrLo0TytjAo6Sjtx3Vx1rixTGaHLETGWq8sobeQ4HDxV4SserXOvMLfIbBlMD0Gd
	ZZ5H6YRPWkiaGkfuM6y0IfTxaoXEwYVPsvuRQpRzBbYQBVQnQ8pJBsIHhYVac96XIeOuRw
	pvZdsZiTgqIZfb26EsYrtaUvtMyCNs4=
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-78fc4425b6bso30936607b3.1
        for <linux-mm@kvack.org>; Sun, 18 Jan 2026 04:24:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768739088; cv=none;
        d=google.com; s=arc-20240605;
        b=FFg1lox8CkkWtiHzt4YJaxwqoUYH8Y8zyk/AwlmyLD3vaF6jrj9L59dYxAr5OofgEy
         A+YN13WQ5vUMXrbnveH9y2jOS2TQhEx9Zl/lDsES+xGtkh3BVR3Uvaohjhv4JTEEB0lC
         ApUAKxOAAugBH+P1/cS9opApyJg0zjqXdkZg/hEPD9kPXq8K23vay9c9x4JmE85lTc2V
         52nXZTWFL9tFL998dFiFB/OtCQcoRgPz+ozoFgC44r7OTNiU0hmUE7DnGnms62ObdNcs
         qj4wLTrLgEj+nako0iENJMQp80BdAZVx75yznyk8mLAictgmo22Ntk9YK5rXCJGp7f9T
         cUyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Gbcn9ZoWB47ZWS/FNIOuP6vDPNcXEa4VJ9tgLN/6Tko=;
        fh=hZj8TQPw4WuX6NtQ0+auH4EjAJ53qI6ZKXe+ox4ad0g=;
        b=i59gbLJqpStKbIIli0FT+pr9OTNDqsy6BsIew/6rSPiaTq51GNHMjVkDa22gB+7qap
         MS7kCHbOIDcmQ7JPa6a5BctBcZJ7do9sLi3QnLbsz+vWxtQKukDosNo0XOOHtSXRqdgi
         qXLzoSvWPxPCqaw2k3Th8MEfVfBi3SKJigwq9QnHlK02G8nhbhTiFYD+rqTNHjCwQ01G
         l7Qogj+ibAoY2ZGd4vE3Jc0Og5eIJSymVf2zIavrhaVv7CrW7eKOAJM5dAAlNPsRQYV9
         sThWA1nDWZo5OPgyyWGS3D8ccK7Oh+SJuFzrTvLxpRAJB+S0CneywzarWGElrbZy9jd3
         ApQw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768739088; x=1769343888; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gbcn9ZoWB47ZWS/FNIOuP6vDPNcXEa4VJ9tgLN/6Tko=;
        b=VoFNHPOCFWrqd5LbNjIGCymzXnhvcnu/91iqTPzbQdvypF6b/SyMdYRxzViY8FUvSb
         OEd3gKbnXXNhFySoMw1HxEzxp8zlhRLVjjB+g04r0pAzt85ewYHXSmDS/evsyYuTyKG6
         BXxgT/QMXF8YD99aCijkJkehIKHv3aRT9AhmY6saMKSGroZf/uZasJ5Hby8S2DvbUYoP
         BHivDB4B5Cn8o1K5YfaMpG1vZWgQGvx13br3e8mrba82R2KZwf86ZIj3P8j4uB8FITfR
         os6HcT2hWoISTqoQwMii4Vf0DyuCtOLMjtdBenmCIUckO9m1h0fe3OlsHE0ocv2eRaQP
         Zj8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768739088; x=1769343888;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Gbcn9ZoWB47ZWS/FNIOuP6vDPNcXEa4VJ9tgLN/6Tko=;
        b=Yn+xqmOT5r70BvhQtxSzIZTaH8PSRL/7PdTLKpDhZOX59ZukAEww8MiOHdONUuSY4U
         8eiFB4ngI5Cer4QajmkIVgekoj4dj93fPyonv3ltM22+c9VevSRqnj1G/xKxP9viYSSd
         G7yOlBydVcH9Geuwmr+by7iW+hVExfTD3QM4McVVVyG8TxUwNeYnNhsPCp0fG9RwaNGw
         4FnMEGf8AQMM2w8sbHm3BU8fO4BbwMSzAymrDnZZh3tYejbPTmYCd7Ca1Z78zr/YdWWF
         y9KCpf0/XYcnnCVeehQkd0KLfZOSbtyhaLnJn2+j9LhostUALbCqE9U+nDN9LL5smvdP
         xFng==
X-Forwarded-Encrypted: i=1; AJvYcCW5La+EWaKmtnhIo+IzerkJtFPB3vgHRQScYkRV1J4NqTaKv0DFw4TC6XYH7I3EgECu+CPkX/q2oA==@kvack.org
X-Gm-Message-State: AOJu0YwhIlMWxTjEd9GQq0kMX4GB5x0qwW7iHbxyE6pCAEMLslcEnRj1
	luHO+3lWVNLPyVUyKId5S46Y4N4lLld2dlctzQCVP/zh2LlAoXns6PXd6mkJwc6z1U9OrOb8cEW
	Y27DzmxOaukeYLMRQWpsgFRLmjiTZF/E=
X-Gm-Gg: AY/fxX6dUg8TNNbHtLlwhN6JtvgCNQ2LppiMaFwvfRaK3qahqVgDR5B6gZKT+MvVph6
	HERTVOC0E5PSShXrx8o2prIj0BSncW9kNAdFXGfsnsUGrv4oCZvAh/pPUB0IUoC+ZKyWjaKvuu/
	dPAQJe4B4eArbrp9eOa6oydJ6vnFkkaIypsUi9nwDnUnOGDsSodx2OmAzDhGUfNqabBj9WZoI1V
	3VZ8hLg+O2Dw12RlHdwre5bhAoRjCv6Lgj8lA6DaZcj/PZ5LrG/AX4Z724WRFGOTbduKRKsXhLh
	QlZfZo1NlNbkrhAATUR4fKrIcrh3ei113kR3A83j79xonk1PWjuWDL62dn1d
X-Received: by 2002:a05:690e:4189:b0:646:7c7a:c5d8 with SMTP id
 956f58d0204a3-649164d287bmr8540551d50.61.1768739087696; Sun, 18 Jan 2026
 04:24:47 -0800 (PST)
MIME-Version: 1.0
References: <20260118105817.1270617-1-kartikey406@gmail.com> <0c632df4-7128-405a-bf92-083a335831f0@lucifer.local>
In-Reply-To: <0c632df4-7128-405a-bf92-083a335831f0@lucifer.local>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Sun, 18 Jan 2026 17:54:35 +0530
X-Gm-Features: AZwV_Qie9ug2vxAJNEr73_tIl544wILY68nO5bsXRP-Z7xKZEygVc7f_bjxfSzw
Message-ID: <CADhLXY5pgdUP_o+zZJ0mo+kN+PuFY8E1WDuxS=M0+tuhta2nzw@mail.gmail.com>
Subject: Re: [PATCH] mm/rmap: fix unlink_anon_vmas() handling of error case
 from anon_vma_fork
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@kernel.org, riel@surriel.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, harry.yoo@oracle.com, 
	jannh@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+c27fa543e10a45d4e149@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C2C5D20002
X-Stat-Signature: 5hd4wx5hmzfznfwg48b8cyo7oa7hzzdo
X-HE-Tag: 1768739088-963492
X-HE-Meta: U2FsdGVkX1//u9L1LBzRCeBwnH09bYoBb31CfLRvbdGZQigS0ZLQyTbEEvtdcBUFTop2+7/6ZA+9QViG3X37LRsEdDILikPCHGGgVK+uGD6x6U9qJRXyxsHuJ4gb1zmBATsZ3vAJz8snm7WeCPJ2zAFOjVcBQ88i4irUpcLs3rsy/u70pwSvSyAE5FVH/nGVSXYdTUDAbr4VhRpZS5P/Pe+hfCHCDS5I1tWXjiiGZGBFjBm1kdlvfZI2g0d0WyWGLGQVeSYtHQC1aax+/hchxFMDPhhiIdL5z4HKc67ZU6melIMrAfZcxsTHO6bVuYakysgyMEhFEG1tCPW62OgqQSRTLOC7BnKP7Rr3lN9CES4zYBJ8NaBHe5+6chIUbBbNaVZS2puHhTH2+SieHV2mXEcTnjV07PFW26kKPeM7FUI8tukUhfcZX92dhx2cEyjgJH0pCCH0q8Lzd3fxGEeduWp5sffyvIO0MQ6ehOjNjBDThZ+zroNdD7qE7vzPQEVViRvKP+OVdKnnxP2w3+go+Mn1vRA0yiTEOhdksndzdDbof3UNt28MBlwb/cZTvW7nj1YErlRKgFt2PHv3C4occVcf56QbgeGPw8cuFoiiv1Dmx//3yPBp/u/HJGtR2oCLEbaKxUHlZddG1IZ23rffUlBdBwuxU3cUqvRX3n48XrHAh4bqAqO4de6b6CRwZkYU9wfhgs4aq88pyNXKMB4+FDR7Yg9EfArGHpuzPJfnViY4TcWL658xl0CXWOYMRVwvWh7DOePU7SPxQxG+HT2imFBrwwbl6civGXXP/Z9gedEph6jqOLzQTVmHLKDkByWx5mGXF4EhkTClKuewrtnxr/S8w3gxRDPbLZIGFOz8YYJBDUBlX5lnG5a2Srs7uRT5TmicjYDg1VuYbnHd+hq+SjvYHCV4GpL9BYPLk9V38GQzOKsqApkyID0IU/4xmv9wR5nH5SZSJjHQJmzqZux
 GJ3h2W3X
 Lb9xDg3/vSkcAGleUeFUVcJn0pH++4nQD9BiWnPV0bx67UATc0D51/MvTeANsKZzKCMtU1XuRW/dXAN95sGy0nZXvdXVneuUnvOVZg77PhKYz4qOZq+0e+TY3WAP+LQKeAyiajqT8cooqXsJBis9AzA2O6+T/XyUBTtDuy+b/AmnsOi9LU9h5zGv5PzQSv/2jiVYwrwXHI7QE5JA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 18, 2026 at 5:36=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Sun, Jan 18, 2026 at 04:28:17PM +0530, Deepanshu Kartikey wrote:
> > When anon_vma_fork() encounters a memory allocation failure after
> > anon_vma_clone() has succeeded, unlink_anon_vmas() is called with
> > vma->anon_vma being NULL but the anon_vma_chain populated with entries
> > that are present in the anon_vma interval trees.
> >
> > This happens in the following sequence:
> > 1. anon_vma_clone() succeeds, populating vma->anon_vma_chain and
> >    inserting entries into interval trees
> > 2. maybe_reuse_anon_vma() does not set vma->anon_vma because reuse
> >    conditions are not met (common case for active processes)
> > 3. anon_vma_alloc() or anon_vma_chain_alloc() fails due to memory
> >    pressure
> > 4. Error path invokes unlink_anon_vmas() with vma->anon_vma =3D=3D NULL
> >
> > The existing code triggered VM_WARN_ON_ONCE and returned without
> > performing cleanup, leaving entries in interval trees and causing
> > memory leaks.
> >
> > Fix this by detecting the condition and properly cleaning up:
> > - Iterate through the populated chain
> > - Lock each anon_vma
> > - Remove entries from interval trees
> > - Unlock and free chain entries
> >
> > This prevents both the warning and the resource leaks.
>
> BTW this reads rather like AI generated it, can you indicate whether that
> was the case or not? :) Thanks.
>
> We generally require acknowledgment of substantial AI-assistance in
> submission.
>
> Cheers, Lorenzo
>
> >
> > Reported-by: syzbot+c27fa543e10a45d4e149@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=3Dc27fa543e10a45d4e149
> > Tested-by: syzbot+c27fa543e10a45d4e149@syzkaller.appspotmail.com
> > Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> > ---
> >  mm/rmap.c | 25 ++++++++++++++++++++++++-
> >  1 file changed, 24 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index f13480cb9f2e..acc8df6ad4a7 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -477,7 +477,31 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
> >
> >       /* Unfaulted is a no-op. */
> >       if (!active_anon_vma) {
> > -             VM_WARN_ON_ONCE(!list_empty(&vma->anon_vma_chain));
> > +             /*
> > +              * Handle anon_vma_fork() error path where anon_vma_clone=
()
> > +              * succeeded and populated the chain (with entries in int=
erval
> > +              * trees), but maybe_reuse_anon_vma() didn't set vma->ano=
n_vma
> > +              * because reuse conditions weren't met, and a later allo=
cation
> > +              * failed before we could allocate and assign a new anon_=
vma.
> > +              *
> > +              * We must properly remove entries from interval trees be=
fore
> > +              * freeing to avoid leaving dangling pointers.
> > +              */
> > +             if (!list_empty(&vma->anon_vma_chain)) {
> > +                     struct anon_vma_chain *avc, *next;
> > +
> > +                     list_for_each_entry_safe(avc, next, &vma->anon_vm=
a_chain,
> > +                                             same_vma) {
> > +                             struct anon_vma *anon_vma =3D avc->anon_v=
ma;
> > +
> > +                             anon_vma_lock_write(anon_vma);
> > +                             anon_vma_interval_tree_remove(avc, &anon_=
vma->rb_root);
> > +                             anon_vma_unlock_write(anon_vma);
> > +                             list_del(&avc->same_vma);
> > +                             anon_vma_chain_free(avc);
> > +                     }
> > +             }
> > +
> >               return;
> >       }
> >
> > --
> > 2.43.0
> >

Hi Lorenzo,

Yes, I used  AI for commit message drafting and to help
articulate the technical explanation. The bug analysis, code fix,
and testing are mine.

I'll send v2 with proper acknowledgment. Thanks for catching this.

Deepanshu

